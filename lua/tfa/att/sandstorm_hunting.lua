if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "Hunting Scope"
--ATTACHMENT.ID = "base" -- normally this is just your filename
ATTACHMENT.Description = { TFA.AttachmentColors["="], "7x zoom" }
ATTACHMENT.Icon = "entities/tfa_qmark.png" --Revers to label, please give it an icon though!  This should be the path to a png, like "entities/tfa_ammo_match.png"
ATTACHMENT.ShortName = "HUNT"
ATTACHMENT.Base = "ins2_scope_base"
ATTACHMENT.WeaponTable = {
	["VElements"] = {
		["scope_hunt"] = {
			["active"] = true
		},
		["modkit"] = {
			["active"] = true
		}
	},
	["WElements"] = {
		["scope_hunt"] = {
			["active"] = true
		},
		["modkit"] = {
			["active"] = true
		}
	},
	["Secondary"] = {
		["ScopeZoom"] = function( wep, val ) return 7 end
	},
	["INS2_SightVElement"] = "scope_hunt",
	["INS2_SightSuffix"] = "HUNT"
}

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end