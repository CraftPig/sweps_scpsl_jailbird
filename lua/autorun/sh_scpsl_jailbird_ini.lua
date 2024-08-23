AddCSLuaFile()

--[[
-----------------------------------------------------------------------------------------------------
Particle Cache
-----------------------------------------------------------------------------------------------------
]]

if CLIENT then
   game.AddParticles("particles/jailbird_effects.pcf")
   
   PrecacheParticleSystem("jailbird_smoke")
   PrecacheParticleSystem("jailbird_elc_low_dmg")
   PrecacheParticleSystem("jailbird_elc_low")
   PrecacheParticleSystem("jailbird_elc_high")
   
end

--[[
-----------------------------------------------------------------------------------------------------
Ammo Tables
-----------------------------------------------------------------------------------------------------
]]

game.AddAmmoType( {
name = "JailbirdDurability",
} )

--[[
-----------------------------------------------------------------------------------------------------
Sound Tables
-----------------------------------------------------------------------------------------------------
]]

sound.Add( {
    name = "swep_scpsl_jailbird_0",
    channel = CHAN_WEAPON,
    volume = 1,
    level = 55,
    pitch = {95, 100},
    sound = {
        "weapons/scpsl/jailbird/Inspect 0.wav",
    }
} )
sound.Add( {
    name = "swep_scpsl_jailbird_1",
    channel = CHAN_WEAPON,
    volume = 1,
    level = 55,
    pitch = {95, 100},
    sound = {
        "weapons/scpsl/jailbird/Inspect 1.wav",
    }
} )
sound.Add( {
    name = "swep_scpsl_jailbird_2",
    channel = CHAN_WEAPON,
    volume = 1,
    level = 55,
    pitch = {95, 100},
    sound = {
        "weapons/scpsl/jailbird/Inspect 2.wav",
    }
} )
sound.Add( {
    name = "swep_scpsl_jailbird_3",
    channel = CHAN_WEAPON,
    volume = 1,
    level = 55,
    pitch = {95, 100},
    sound = {
        "weapons/scpsl/jailbird/Inspect 3.wav",
    }
} )
sound.Add( {
    name = "swep_scpsl_jailbird_4",
    channel = CHAN_WEAPON,
    volume = 1,
    level = 55,
    pitch = {95, 100},
    sound = {
        "weapons/scpsl/jailbird/Inspect 4.wav",
    }
} )
sound.Add( {
    name = "swep_scpsl_equip",
    channel = CHAN_WEAPON,
    volume = 1,
    level = 55,
    pitch = {95, 100},
    sound = {
        "weapons/scpsl/jailbird/Equip_Fast.wav",
		"weapons/scpsl/jailbird/Equip_Fast.wav",
		"weapons/scpsl/jailbird/Equip_Fast.wav",
		"weapons/scpsl/jailbird/Equip_Fast_Yo.wav",
    }
} )
sound.Add( {
    name = "swep_scpsl_ready",
    channel = CHAN_WEAPON,
    volume = 1,
    level = 55,
    pitch = {95, 100},
    sound = {
        "weapons/scpsl/jailbird/Equip_Slow_fixed.wav",
    }
} )
sound.Add( {
    name = "swep_scpsl_swingr",
    channel = CHAN_WEAPON,
    volume = 1,
    level = 60,
    pitch = {90, 105},
    sound = {
        "weapons/scpsl/jailbird/Normal_Swing.wav",
    }
} )
sound.Add( {
    name = "swep_scpsl_swingl",
    channel = CHAN_WEAPON,
    volume = 1,
    level = 60,
    pitch = {90, 105},
    sound = {
        "weapons/scpsl/jailbird/Normal_Swing_invert.wav",
    }
} )
sound.Add( {
    name = "swep_scpsl_hit",
    channel = CHAN_STATIC,
    volume = 0.35,
    level = 60,
    pitch = {95, 100},
    sound = {
        "weapons/scpsl/jailbird/Normal Hit.wav",
    }
} )
sound.Add( {
    name = "swep_scpsl_discard",
    channel = CHAN_WEAPON,
    volume = 1,
    level = 55,
    pitch = {95, 100},
    sound = {
        "weapons/scpsl/jailbird/Charged_Discard.wav",
    }
} )
sound.Add( {
    name = "swep_scpsl_chargeswing",
    channel = CHAN_WEAPON,
    volume = 1,
    level = 65,
    pitch = {95, 100},
    sound = {
        "weapons/scpsl/jailbird/Charge_Swing_fixed.wav",
    }
} )
sound.Add( {
    name = "swep_scpsl_chargestart",
    channel = CHAN_WEAPON,
    volume = 1,
    level = 55,
    pitch = {95, 100},
    sound = {
        "weapons/scpsl/jailbird/Charge_Start_fixed_real.wav",
    }
} )
sound.Add( {
    name = "swep_scpsl_charge",
    channel = CHAN_WEAPON,
    volume = 1,
    level = 75,
    pitch = {98, 102},
    sound = {
        "weapons/scpsl/jailbird/Charge_Run_fixed.wav",
    }
} )