if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "Kobra"
ATTACHMENT.ShortName = "KOBRA"
ATTACHMENT.Icon = "entities/tfa_qmark.png"
ATTACHMENT.Description = {

}

ATTACHMENT.WeaponTable = {
	["VElements"] = {
		["reflex_kobra"] = {
			["active"] = true
		},
		["reflex_kobra_lens"] = {
			["active"] = true
		},
		["modkit"] = {
			["active"] = true
		}
	},
	["WElements"] = {
		["reflex_kobra"] = {
			["active"] = true
		},
		["modkit"] = {
			["active"] = true
		}
	},
	["IronSightsPos"] = function(wep, val)
		return val + wep.SightOffset_Kobra or val
	end,
	["ScopeVElement"] = "reflex_kobra",
	["Reticle"] = "models/weapons/sandstorm_reloaded/kobra_reticule_holo"
}

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end