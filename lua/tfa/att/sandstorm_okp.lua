if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "OKP-7"
ATTACHMENT.ShortName = "OKP"
ATTACHMENT.Icon = "entities/tfa_qmark.png"
ATTACHMENT.Description = {

}

ATTACHMENT.WeaponTable = {
	["VElements"] = {
		["reflex_okp"] = {
			["active"] = true
		},
		["reflex_okp_lens"] = {
			["active"] = true
		},
		["modkit"] = {
			["active"] = true
		}
	},
	["WElements"] = {
		["reflex_okp"] = {
			["active"] = true
		},
		["modkit"] = {
			["active"] = true
		}
	},
	["IronSightsPos"] = function(wep, val)
		return val + wep.SightOffset_OKP or val
	end,
	["Secondary"] = {
		["IronFOV"] = function( wep, val ) return wep.Secondary.IronFOV_OKP or val * 0.95 end
	},
	["ScopeVElement"] = "reflex_okp",
	["Reticle"] = "models/weapons/sandstorm_reloaded/okp_reticule_holo"
}

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end