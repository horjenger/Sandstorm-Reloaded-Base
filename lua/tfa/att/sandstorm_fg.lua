if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "Foregrip"
--ATTACHMENT.ID = "base" -- normally this is just your filename
ATTACHMENT.Description = { TFA.AttachmentColors["+"], "60% less vertical recoil", "20% less horizontal recoil", TFA.AttachmentColors["-"], "10% lower base accuracy", "5% lower scoped accuracy", "Marginally slower movespeed" }
ATTACHMENT.Icon = "entities/ins2_att_grp.png" --Revers to label, please give it an icon though!  This should be the path to a png, like "entities/tfa_ammo_match.png"
ATTACHMENT.ShortName = "GRIP"

ATTACHMENT.WeaponTable = {
	["VElements"] = {
		["basegrip"] = {
			["active"] = false
		},
		["foregrip"] = {
			["active"] = true
		}
	},
	["WElements"] = {
		["basegrip"] = {
			["active"] = false
		},
		["foregrip"] = {
			["active"] = true
		}
	},
	["Animations"] = {
		["idle"] = {
			["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
			["value"] = "base_idle_fg"
		},
		["idle_empty"] = {
			["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
			["value"] = "empty_idle_fg"
		},
		["draw"] = {
			["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
			["value"] = "base_draw_fg"
		},
		["draw_empty"] = {
			["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
			["value"] = "empty_draw_fg"
		},
		["draw_first"] = {
			["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
			["value"] = "base_draw_fg"
		},
		["holster"] = {
			["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
			["value"] = "base_holster_fg"
		},
		["holster_empty"] = {
			["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
			["value"] = "empty_holster_fg"
		},
		["inspect"] = {
			["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
			["value"] = "base_inspect_fg"
		},
		["inspect_empty"] = {
			["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
			["value"] = "empty_inspect_fg"
		},
		["bash"] = {
			["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
			["value"] = "base_melee_fg"
		},
		["bash_empty"] = {
			["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
			["value"] = "empty_melee_fg"
		},
		["shoot1_last"] = {
			["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
			["value"] = "base_fire_last_fg"
		},
		["shoot1_empty"] = {
			["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
			["value"] = "base_dryfire_fg"
		},
		["shoot1"] = function(wep,val)
			val = table.Copy(val) or {}
			val["type"] = TFA.Enum.ANIMATION_SEQ --Sequence or act
			if val.value then
				val["value"] = "ACT_VM_PRIMARYATTACK_FG"
			end
			return val, true, false
		end,
		["reload"] = {
			["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
			["value"] = "base_reload_fg"
		},
		["reload_speed"] = {
			["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
			["value"] = "base_reload_speed_fg"
		},
	},
	["IronAnimation"] = {
		["shoot"] = function(wep,val)
			if not wep.IronAnimation.shoot then return end
			val = table.Copy(val) or {}
			val["type"] = TFA.Enum.ANIMATION_SEQ --Sequence or act
			if val.value then
				val["value"] = "ACT_VM_PRIMARYATTACK_1_FG"
			end
			if val.value_last then
				val["value_last"] = "ACT_VM_PRIMARYATTACK_2_FG"
			end
			if val.value_empty then
				val["value_empty"] = "ACT_VM_DRYFIRE_1_FG"
			end
			return val, true, false
		end
	},
	["SprintAnimation"] = {
		["loop"] = function(wep,val)
			if not wep.SprintAnimation.loop then return end
			val = table.Copy(val) or {}
			if wep.SprintAnimation_Grip and wep.SprintAnimation_Grip["loop"] then
				val["type"] = wep.SprintAnimation_Grip["loop"].type
				if val.value then
					val["value"] = wep.SprintAnimation_Grip["loop"].value or "base_sprint_fg"
				end
				if val.value_empty then
					val["value_empty"] = wep.SprintAnimation_Grip["loop"].value_empty or "empty_sprint_fg"
				end
			else
				val["type"] = TFA.Enum.ANIMATION_SEQ --Sequence or act
				if val.value then
					val["value"] = "base_sprint_fg"
				end
				if val.value_empty then
					val["value_empty"] = "empty_sprint_fg"
				end
			end
			return val, true, false
		end,
	},
}

function ATTACHMENT:Attach( wep )
	if TFA.Enum.ReadyStatus[wep:GetStatus()] then
		wep:ChooseIdleAnim()
		if game.SinglePlayer() then
			wep:CallOnClient("ChooseIdleAnim","")
		end
	end
end

function ATTACHMENT:Detach( wep )
	if TFA.Enum.ReadyStatus[wep:GetStatus()] then
		wep:ChooseIdleAnim()
		if game.SinglePlayer() then
			wep:CallOnClient("ChooseIdleAnim","")
		end
	end
end

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end