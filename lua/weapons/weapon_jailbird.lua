if SERVER then
   AddCSLuaFile()
end

if CLIENT then 
    SWEP.WepSelectIcon = surface.GetTextureID( "vgui/hud/vgui_jailbird" )
	SWEP.BounceWeaponIcon = true 
    SWEP.DrawWeaponInfoBox = true
end

SWEP.PrintName = "Jailbird"
SWEP.Author = "Craft_Pig"
SWEP.Category = "SCP: SL"
SWEP.Purpose = "WHAT!?"

SWEP.ViewModel = "models/weapons/sweps/scpsl/jailbird/v_jailbird.mdl"
SWEP.WorldModel = "models/weapons/sweps/scpsl/jailbird/w_jailbird.mdl"
SWEP.ViewModelFOV = 77
SWEP.UseHands = true
SWEP.DrawCrosshair = false 

SWEP.Spawnable = true
SWEP.Slot = 0
SWEP.SlotPos = 0

SWEP.DrawAmmo = true
SWEP.Primary.Ammo = "JailbirdDurability"
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = false 
 
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.ClipSize = 1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false

SWEP.HitDistance = 90
SWEP.PrimaryCD = 1
SWEP.PrimaryHitTime = 0.3
SWEP.SecondaryHitTime = 0.1
SWEP.SecondaryIdleTime = 2.7
SWEP.Durability = 10

function SWEP:Initialize()
	self:SetHoldType("melee2")
	
	self.Ready = 1
	self.Durability = 10
	self.IsCritical = 0
	
end

function SWEP:Deploy()
    if self:GetOwner():GetAmmoCount(self.Primary.Ammo) <= 0 then -- Delete weapon if durability = 0
	    owner:StripWeapon("weapon_jailbird")
	end
	
	if SERVER then
        if self.Ready == 0 then -- First pickup
            self:SendWeaponAnim(ACT_VM_DRAW)
	    else
	        self:SendWeaponAnim(ACT_VM_PICKUP)
		    self:GetOwner():GiveAmmo(9, "JailbirdDurability", true) -- true means to set the ammo limit to the maximum value for this weapon
	    end
	end
	
	self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	
	self.Ready = 0
	self.Idle = 0
	self.SetupCharge = 0
	self.ReadyCharge = 0
	self.StartCharge = 0
	self.ForceStopCharge = 0
	self.ForceCharge = 0 
	self.Charging = 0
	self.SwingRight = 1
	
	return true
end

function SWEP:Think()
    local owner = self:GetOwner()
	
	-- self.Owner:ConCommand("-forward")
	-- self.Owner:ConCommand("-speed")
	
    if self.Idle == 0 and self.IdleTimer <= CurTime() then -- Idle Sequence
		self:SendWeaponAnim(ACT_VM_IDLE)  
        self.Idle = 1
    end

	if self:GetOwner():GetAmmoCount(self.Primary.Ammo) <= 2 and self.IsCritical == 0 then -- Change texture
	    self:GetOwner():GetViewModel():SetBodygroup(0, 1)
		self.IsCritical = 1
	end
	
	if SERVER then
	    if self:GetOwner():GetAmmoCount(self.Primary.Ammo) <= 0 and self.IdleTimer <= CurTime() then -- Strip Weapon Active
		    owner:StripWeapon("weapon_jailbird")
        end
	    if owner:KeyPressed(IN_RELOAD) and self.IdleTimer <= CurTime() then  -- Inspect
	        if self:GetOwner():GetAmmoCount(self.Primary.Ammo) >= 9 then
		    	self:SendWeaponAnim(ACT_VM_FIDGET)
		    elseif self:GetOwner():GetAmmoCount(self.Primary.Ammo) >= 8 then
			    self:SendWeaponAnim(ACT_VM_RECOIL1)
		    elseif self:GetOwner():GetAmmoCount(self.Primary.Ammo) >= 6 then
			    self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
		    elseif self:GetOwner():GetAmmoCount(self.Primary.Ammo) == 4 then
			    self:SendWeaponAnim(ACT_VM_RECOIL2)
		    elseif self:GetOwner():GetAmmoCount(self.Primary.Ammo) <= 2 then
			    self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
	        end    
			
		        self:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration()) 
		        self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
		        self.Idle = 0     
	    end
	end
    
	if SERVER then
        if self.SetupCharge == 1 then -- Setup Charge
	        if self.IdleTimer <= CurTime() then
		        self:SendWeaponAnim(ACT_VM_PULLBACK) -- Charge Idle
			    self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration() 
			    self.ReadyCharge = 1
			    timer.Create("TimerForceCharge", 2.5, 1, function()
                    self.ForceCharge = 1
                end)
		    elseif (not self.Owner:KeyDown(IN_ATTACK2) and self.ReadyCharge == 1) or self.ForceCharge == 1 then
			    self.IdleTimer = CurTime() + 0
			    self.StartCharge = 1
                self.SetupCharge = 0	
			    self.Owner:EmitSound("swep_scpsl_charge")
			    owner:ApplyEffect("Haste", 2.5, 300)
			    timer.Create("TimerBreakChargeUp", 2.5, 1, function()
                    self.ForceStopCharge = 1
                end)		
		    end
	    end
	
	
	    if self.ReadyCharge == 1 or self.ForceCharge == 1 then -- Forward Charge and Swing
	        if self.IdleTimer <= CurTime() then
		        self:SendWeaponAnim(ACT_VM_HAULBACK)		
		        self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
			    self.Owner:ConCommand("+forward")
			    self.Owner:ConCommand("+speed")
		    end
		
		    self.Charging = 1
	    
		    if self.Owner:KeyPressed(IN_ATTACK) or self.ForceStopCharge == 1 then
		
		        self.Owner:ConCommand("-forward")
	            self.Owner:ConCommand("-speed")
			
			    owner:SoftRemoveEffect("Haste")
			
			    self.ForceStopCharge = 0
			    self.StartCharge = 0	
			    self.Idle = 0
			    self.ReadyCharge = 0
			    self.ForceCharge = 0
			    self.Charging = 0
			    timer.Remove("TimerBreakChargeUp")
			    timer.Remove("TimerForceCharge")
		
			    if self:GetOwner():GetAmmoCount(self.Primary.Ammo) <= 2 then -- Decide attack sequence
			        self:SendWeaponAnim(ACT_VM_MISSCENTER)	
                    self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
				    -- PrintMessage(HUD_PRINTTALK, "SWING!")
			    	self.Owner:ConCommand("-forward")
				    self.Owner:ConCommand("-speed")	
			    else
		    	    self:SendWeaponAnim(ACT_VM_SWINGHARD)	
                    self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
				-- PrintMessage(HUD_PRINTTALK, "SWING!")
		    		self.Owner:ConCommand("-forward")
		    		self.Owner:ConCommand("-speed")	
                    self.Owner:EmitSound("swep_scpsl_chargeswing")				
		    	end
			
		    	self:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
			

                timer.Create("TimerHitChargeWhen", self.SecondaryHitTime, 1, function() -- Impact Timer
			
			        self.Owner:RemoveAmmo(2, "JailbirdDurability")
			
	                local tr = util.TraceLine( {
		                start = owner:GetShootPos(),
		                endpos = owner:GetShootPos() + owner:GetAimVector() * self.HitDistance,
		                filter = owner,
		                mask = MASK_SHOT_HULL
	                } )
	                if ( !IsValid( tr.Entity ) ) then
		                tr = util.TraceHull( {
		    	        start = owner:GetShootPos(),
		    	        endpos = owner:GetShootPos() + owner:GetAimVector() * self.HitDistance,
		    	        filter = owner,
		    	        mins = Vector( -10, -10, -8 ),
		    	        maxs = Vector( 10, 10, 8 ),
		                mask = MASK_SHOT_HULL
		                } )
	                end
	                if SERVER then
		    		    self.Owner:SetAnimation( PLAYER_ATTACK1 )
		    		    if tr.Entity:IsPlayer() then
		    	            tr.Entity:ApplyEffect("Discharge", 2, 50, 1)
			    		    tr.Entity:ApplyEffect("Hindered", 3, 80)
			            end
	                    if tr.Entity:IsPlayer() or tr.Entity:IsNPC() or tr.Entity:IsNextBot() then
		                    local dmginfo = DamageInfo()
			            
                            dmginfo:SetDamage(200)
                            dmginfo:SetAttacker(self.Owner)
                            dmginfo:SetInflictor(self)
                            dmginfo:SetDamageType(DMG_DISSOLVE)
                            tr.Entity:TakeDamageInfo(dmginfo)
			    	        self:EmitSound("swep_scpsl_hit")
						
			    			local effect = EffectData()
		                    effect:SetOrigin(tr.HitPos)
		                    effect:SetNormal( tr.HitNormal )
		                    util.Effect("ElectricSpark", effect) 
				            util.Effect("ManhackSparks", effect)
		                end
	                end        
                end)			
	    	end
		end
	end
end
 
function SWEP:PrimaryAttack() 
	local owner = self:GetOwner()
	local tr2 = util.TraceLine( {
		    start = owner:GetShootPos(),
		    endpos = owner:GetShootPos() + owner:GetAimVector() * self.HitDistance,
		    filter = owner,
		    mask = MASK_SHOT_HULL
	    } )
	    if ( !IsValid( tr2.Entity ) ) then
		    tr2 = util.TraceHull( {
			    start = owner:GetShootPos(),
			    endpos = owner:GetShootPos() + owner:GetAimVector() * self.HitDistance,
			    filter = owner,
			    mins = Vector( -10, -10, -8 ),
			    maxs = Vector( 10, 10, 8 ),
		        mask = MASK_SHOT_HULL
		    } )
	    end
	local DumbTracerCheck = (tr2.Entity:IsPlayer() or tr2.Entity:IsNPC() or tr2.Entity:IsNextBot())
	
	if self.ReadyCharge == 1 then return end
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	
	if SERVER then -- Decide attack sequence
	    if self:GetOwner():GetAmmoCount(self.Primary.Ammo) == 1 and DumbTracerCheck then
	        self:SendWeaponAnim(ACT_VM_HITCENTER2)
		    self:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
            self.Owner:EmitSound("swep_scpsl_swingr")			
	    else
            if self.SwingRight == 1 then
                self:SendWeaponAnim(ACT_VM_MISSRIGHT)
				self.Owner:EmitSound("swep_scpsl_swingr")
		        self.SwingRight = 0
	        else
	            self:SendWeaponAnim(ACT_VM_MISSLEFT)
				self.Owner:EmitSound("swep_scpsl_swingl")
		        self.SwingRight = 1	
	        end
		    self.Idle = 0
			self.SetupCharge = 0
		    self:SetNextPrimaryFire(CurTime() + self.PrimaryCD + 0)
	    end
		
    self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration() 
	
	end
   	
	timer.Create("TimerHitWhen", self.PrimaryHitTime, 1, function() -- Impact Timer
	    if SERVER then
		    local dmginfo = DamageInfo()
			local tr = util.TraceLine( {
		    start = owner:GetShootPos(),
		    endpos = owner:GetShootPos() + owner:GetAimVector() * self.HitDistance,
		    filter = owner,
		    mask = MASK_SHOT_HULL
	        } )
	        if ( !IsValid( tr.Entity ) ) then
		        tr = util.TraceHull( {
			        start = owner:GetShootPos(),
			        endpos = owner:GetShootPos() + owner:GetAimVector() * self.HitDistance,
			        filter = owner,
			        mins = Vector( -10, -10, -8 ),
			        maxs = Vector( 10, 10, 8 ),
		            mask = MASK_SHOT_HULL
		        } )
	        end
		    if tr.Entity:IsPlayer() then
			    tr.Entity:ApplyEffect("Discharge", 2, 25, 1)
			end
			-- if IsValid(tr.Entity) and (tr.Entity:GetClass() == "prop_physics") then
				-- dmginfo:SetDamage(50)	
				-- dmginfo:SetAttacker(self.Owner)
                -- dmginfo:SetInflictor(self)
                -- dmginfo:SetDamageType(DMG_CRUSH, DMG_SHOCK)
                -- tr.Entity:TakeDamageInfo(dmginfo)
				
				-- self:EmitSound("swep_scpsl_hit")
	        if ( SERVER and IsValid( tr.Entity ) and ( tr.Entity:IsNPC() or tr.Entity:IsPlayer() or tr.Entity:Health() > 0 ) ) then
                dmginfo:SetDamage(50)
                dmginfo:SetAttacker(self.Owner)
                dmginfo:SetInflictor(self)
                dmginfo:SetDamageType(DMG_CRUSH, DMG_SHOCK)
                tr.Entity:TakeDamageInfo(dmginfo)
				
				self:EmitSound("swep_scpsl_hit")
				self.Owner:RemoveAmmo(1, "JailbirdDurability")
				
				local effect = EffectData()
		        effect:SetOrigin(tr.HitPos)
		        effect:SetNormal( tr.HitNormal )
		        util.Effect("ManhackSparks", effect)	
		    end
	    end        
    end)
 end
 
function SWEP:SecondaryAttack()
	
    if self.SetupCharge == 0 and self.IdleTimer <= CurTime() then -- Initialize charge up
        self:SendWeaponAnim(ACT_VM_PULLBACK_HIGH)
        self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
        self.Idle = 1
        self.SetupCharge = 1
		self.ReadyCharge = 0
		self.ForceStopCharge = 0
		self.Owner:EmitSound("swep_scpsl_chargestart")
		self:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration() + self.SecondaryHitTime + 0.9)
	end
end

function SWEP:OnRemove()
   if self.ReadyCharge == 1 or self.ForceCharge == 1 then
	    self.Owner:ConCommand("-forward")
		self.Owner:ConCommand("-speed")	
	end
end

function SWEP:Holster()
    
    if self.StartCharge == 1 or self.SetupCharge == 1 or self.ReadyCharge == 1 then return end
	timer.Remove("TimerHitWhen")
	timer.Remove("TimerHitChargeWhen")
	timer.Remove("TimerBreakChargeUp")
	timer.Remove("TimerForceCharge")
	
    return true
end

function SWEP:PostDrawViewModel( vm )
    local attachment = vm:GetAttachment(1)
    if attachment then
        self.vmcamera = vm:GetAngles() - attachment.Ang
    else
        self.vmcamera = Angle(0, 0, 0) 
    end
end

function SWEP:CalcView( ply, pos, ang, fov )
	self.vmcamera = self.vmcamera or Angle(0, 0, 0)  
    return pos, ang + self.vmcamera, fov
end

if CLIENT then -- Worldmodel offset
	local WorldModel = ClientsideModel(SWEP.WorldModel)

	WorldModel:SetSkin(0)
	WorldModel:SetNoDraw(true)

	function SWEP:DrawWorldModel()
		local owner = self:GetOwner()

		if (IsValid(owner)) then
			local offsetVec = Vector(14, -17, -0)
			local offsetAng = Angle(-0, 90, 90)
			
			local boneid = owner:LookupBone("ValveBiped.Bip01_R_Hand") -- Right Hand
			if !boneid then return end

			local matrix = owner:GetBoneMatrix(boneid)
			if !matrix then return end

			local newPos, newAng = LocalToWorld(offsetVec, offsetAng, matrix:GetTranslation(), matrix:GetAngles())

			WorldModel:SetPos(newPos)
			WorldModel:SetAngles(newAng)

            WorldModel:SetupBones()
		else
			
			WorldModel:SetPos(self:GetPos())
			WorldModel:SetAngles(self:GetAngles())
			self:DrawModel()
		end

		WorldModel:DrawModel()

	end
end

if CLIENT then -- Worldmodel offset
	local WorldModel = ClientsideModel(SWEP.WorldModel)

	-- WorldModel:SetSkin(1)
	WorldModel:SetNoDraw(true)

	function SWEP:DrawWorldModel()
		local owner = self:GetOwner()

		if (IsValid(owner)) then
			local offsetVec = Vector(3, -1.5, -6)
			local offsetAng = Angle(-0, 0, 90)
			
			local boneid = owner:LookupBone("ValveBiped.Bip01_R_Hand") -- Right Hand
			if !boneid then return end

			local matrix = owner:GetBoneMatrix(boneid)
			if !matrix then return end

			local newPos, newAng = LocalToWorld(offsetVec, offsetAng, matrix:GetTranslation(), matrix:GetAngles())

			WorldModel:SetPos(newPos)
			WorldModel:SetAngles(newAng)

            WorldModel:SetupBones()
		else
			
			WorldModel:SetPos(self:GetPos())
			WorldModel:SetAngles(self:GetAngles())
			self:DrawModel()
		end

		WorldModel:DrawModel()

	end
end