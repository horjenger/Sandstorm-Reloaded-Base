if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "Aimpoint CompM4s"
ATTACHMENT.ShortName = "M4"
ATTACHMENT.Icon = "entities/tfa_qmark.png"
ATTACHMENT.Description = {

}

ATTACHMENT.WeaponTable = {
	["VElements"] = {
		["reflex_aimpoint"] = {
			["active"] = true
		},
		["reflex_aimpoint_lens"] = {
			["active"] = true
		},
		["modkit"] = {
			["active"] = true
		}
	},
	["WElements"] = {
		["reflex_aimpoint"] = {
			["active"] = true
		},
		["modkit"] = {
			["active"] = true
		}
	},
	["IronSightsPos"] = function(wep, val)
		return val + wep.SightOffset_AimpointM4 or val
	end,
	["ScopeVElement"] = "reflex_aimpoint",
	["Reticle"] = "models/weapons/sandstorm_reloaded/dot_reticule_holo"
}

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end