if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "EOTech"
ATTACHMENT.ShortName = "EOT"
ATTACHMENT.Icon = "entities/tfa_qmark.png"
ATTACHMENT.Description = {

}

ATTACHMENT.WeaponTable = {
	["VElements"] = {
		["reflex_eotech"] = {
			["active"] = true
		},
		["reflex_eotech_lens"] = {
			["active"] = true
		},
		["modkit"] = {
			["active"] = true
		}
	},
	["WElements"] = {
		["reflex_eotech"] = {
			["active"] = true
		},
		["modkit"] = {
			["active"] = true
		}
	},
	["IronSightsPos"] = function(wep, val)
		return val + wep.SightOffset_EOTech or val
	end,
	["ScopeVElement"] = "reflex_eotech",
	["Reticle"] = "models/weapons/sandstorm_reloaded/eotech_reticule_holo"
}

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end