if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "PK-AS"
--ATTACHMENT.ID = "base" -- normally this is just your filename
ATTACHMENT.Description = { TFA.AttachmentColors["="], "1.5x zoom" }
ATTACHMENT.Icon = "entities/tfa_qmark.png" --Revers to label, please give it an icon though!  This should be the path to a png, like "entities/tfa_ammo_match.png"
ATTACHMENT.ShortName = "PKAS"
ATTACHMENT.Base = "ins2_scope_base"
ATTACHMENT.WeaponTable = {
	["VElements"] = {
		["scope_pkas"] = {
			["active"] = function(wep, val) TFA.INS2.AnimateSight(wep) return true end,
			["ins2_sightanim_idle"] = "idle",
			["ins2_sightanim_iron"] = "zoom",
		},
		["modkit"] = {
			["active"] = true
		}
	},
	["WElements"] = {
		["scope_pkas"] = {
			["active"] = true
		},
		["modkit"] = {
			["active"] = true
		}
	},
	["Secondary"] = {
		["ScopeZoom"] = function( wep, val ) return 1.5 end
	},
	["INS2_SightVElement"] = "scope_pkas",
	["INS2_SightSuffix"] = "PKAS"
}

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end