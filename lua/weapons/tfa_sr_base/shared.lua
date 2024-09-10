DEFINE_BASECLASS("tfa_bash_base")

SWEP.SRWeapon = true

hook.Add("TFA_PreReload", "TFAISSRCheckForWalk", function(wepom, keyreleased)
	if wepom:GetOwner():KeyDown(IN_WALK) then return true end
end)

local l_CT = CurTime
local ReloadDelay = 0.175

hook.Add("PlayerSpawn", "ZALOOPA", function(ply)
	ply.LastR = CurTime()
end)

IsReloadFast = false
IsReloadFastReturnedAlready = false

function SWEP:ShouldDoFastReload()
	if self:GetOwner():KeyPressed(IN_RELOAD) then
		if CurTime() - self:GetOwner().LastR <= ReloadDelay and self.SRWeapon then
			IsReloadFast = true
		else
			IsReloadFast = false
		end

		self:GetOwner().LastR = CurTime()
	end

	return IsReloadFast
end

local function PlayChosenAnimation(self, typev, tanim, ...)
	local fnName = typev == TFA.Enum.ANIMATION_SEQ and "SendViewModelSeq" or "SendViewModelAnim"
	local a, b = self[fnName](self, tanim, ...)
	return a, b, typev
end

SWEP.PlayChosenAnimation = PlayChosenAnimation

local success, tanim, typev

function SWEP:ChooseReloadAnim()
	local self2 = self:GetTable()
	if not self:VMIV() then return false, 0 end
	if self2.GetStatL(self, "IsProceduralReloadBased") then return false, 0 end

	local ads = self:GetStatL("IronSightsReloadEnabled") and self:GetIronSightsDirect()

	if self:GetActivityEnabled(ACT_VM_RELOAD_SILENCED) and self2.GetSilenced(self) then
		typev, tanim = self:ChooseAnimation((ads and self:GetActivityEnabled(ACT_VM_RELOAD_SILENCED_ADS)) and "reload_silenced_is" or "reload_silenced")
	elseif self:GetActivityEnabled(ACT_VM_RELOAD_EMPTY) and (self:Clip1() == 0 or self:IsJammed()) and not self:GetStatL("LoopedReload") then
		if self:ShouldDoFastReload() == true then
			typev, tanim = self:ChooseAnimation(self:GetStat("AltReloadAnimation.reload_speed"))
		else
			typev, tanim = self:ChooseAnimation((ads and self:GetActivityEnabled(ACT_VM_RELOAD_EMPTY_ADS)) and "reload_empty_is" or "reload_empty")
		end
	else
		if self:ShouldDoFastReload() == true then
			typev, tanim = self:ChooseAnimation(self:GetStat("AltReloadAnimation.reload_speed"))
		else
			typev, tanim = self:ChooseAnimation((ads and self:GetActivityEnabled(ACT_VM_RELOAD_ADS)) and "reload_is" or "reload")
		end
	end

	local fac = 1

	if self:GetStatL("LoopedReload") and self:GetStatL("LoopedReloadInsertTime") then
		fac = self:GetStatL("LoopedReloadInsertTime")
	end

	self:SetAnimCycle(self2.ViewModelFlip and 0 or 1)
	self2.AnimCycle = self:GetAnimCycle()

	return PlayChosenAnimation(self, typev, tanim, fac, fac ~= 1)
end

function SWEP:Reload(released)
	timer.Simple(ReloadDelay, function()
		local self2 = self:GetTable()

		self:PreReload(released)

		if hook.Run("TFA_PreReload", self, released) then return end

		local isplayer = self:GetOwner():IsPlayer()
		local vm = self:VMIV()

		if isplayer and not vm then return end

		if not self:IsJammed() then
			if self:Ammo1() <= 0 then return end
			if self:GetStatL("Primary.ClipSize") < 0 then return end
		end

		if not released and not self:GetLegacyReloads() then return end
		if self:GetLegacyReloads() and not dryfire_cvar:GetBool() and not self:KeyDown(IN_RELOAD) then return end
		if self:KeyDown(IN_USE) then return end

		ct = l_CT()
		stat = self:GetStatus()

		if self:GetStatL("PumpAction") and self:GetReloadLoopCancel() then
			if stat == TFA.Enum.STATUS_IDLE then
				self:DoPump()
			end
		elseif TFA.Enum.ReadyStatus[stat] or (stat == TFA.Enum.STATUS_SHOOTING and self:CanInterruptShooting()) or self:IsJammed() then
			if self:Clip1() < self:GetPrimaryClipSize() or self:IsJammed() then
				if hook.Run("TFA_Reload", self) then return end
				self:SetBurstCount(0)

				if self:GetStatL("LoopedReload") then
					local _, tanim, ttype = self:ChooseShotgunReloadAnim()

					if self:GetStatL("ShotgunStartAnimShell") then
						self:SetStatus(TFA.Enum.STATUS_RELOADING_LOOP_START_EMPTY)
					elseif self2.ShotgunEmptyAnim then
						local _, tg = self:ChooseAnimation("reload_empty")
						local action = tanim

						if type(tg) == "string" and tonumber(tanim) and tonumber(tanim) > 0 and isplayer then
							if ttype == TFA.Enum.ANIMATION_ACT then
								action = vm:GetSequenceName(vm:SelectWeightedSequenceSeeded(tanim, self:GetSeedIrradical()))
							else
								action = vm:GetSequenceName(tanim)
							end
						end

						if action == tg and self:GetStatL("ShotgunEmptyAnim_Shell") then
							self:SetStatus(TFA.Enum.STATUS_RELOADING_LOOP_START_EMPTY)
						else
							self:SetStatus(TFA.Enum.STATUS_RELOADING_LOOP_START)
						end
					else
						self:SetStatus(TFA.Enum.STATUS_RELOADING_LOOP_START)
					end

					self:SetStatusEnd(ct + self:GetActivityLength(tanim, true, ttype))
				else
					local _, tanim, ttype = self:ChooseReloadAnim()

					self:SetStatus(TFA.Enum.STATUS_RELOADING)

					if self:GetStatL("IsProceduralReloadBased") then
						self:SetStatusEnd(ct + self:GetStatL("ProceduralReloadTime"))
					else
						self:SetStatusEnd(ct + self:GetActivityLength(tanim, true, ttype))
						self:SetNextPrimaryFire(ct + self:GetActivityLength(tanim, false, ttype))
					end

					if CLIENT then
						self2.ReloadAnimationStart = ct
						self2.ReloadAnimationEnd = ct + self:GetActivityLength(tanim, false, ttype)
					elseif sp then
						net.Start("tfa_reload_blending", true)
						net.WriteEntity(self)
						net.WriteDouble(ct)
						net.WriteDouble(ct + self:GetActivityLength(tanim, false, ttype))
						net.Broadcast()
					end
				end

				if not sp or not self:IsFirstPerson() then
					self:GetOwner():SetAnimation(PLAYER_RELOAD)
				end

				if self:GetStatL("Primary.ReloadSound") and IsFirstTimePredicted() then
					self:EmitSound(self:GetStatL("Primary.ReloadSound"))
				end

				self:SetNextPrimaryFire( -1 )
			elseif released or self:KeyPressed(IN_RELOAD) then
				self:CheckAmmo()
			end
		end

		self:PostReload(released)
		
		hook.Run("TFA_PostReload", self)
	end)
end

function SWEP:Think(...)
	if SERVER then
		self:ShouldDoFastReload()
	end

	return BaseClass.Think(self, ...)
end

----[[EVENT TABLE: MAG DISCARD]]----

function SWEP:TFAMagDiscard()
	if SERVER then
		if self.Shotgun == true then return end

		if self:Clip1() >= 1 and self:GetStat("Akimbo") and (not self:GetStat("DisableChambering")) then
			if self:Clip1() >= 2 then
				self:SetClip1(2)
			else
				self:SetClip1(1)
			end
		elseif self:Clip1() >= 1 and self:GetStat("Akimbo") and self:GetStat("DisableChambering") then
			self:SetClip1(0)
		elseif self:Clip1() >= 1 and (not self:GetStat("DisableChambering")) then
			self:SetClip1(1)
		else
			self:SetClip1(0)
		end
	end
end

----[[FREE VIEWMODEL]]----

local freevm_var = CreateConVar("cl_tfa_debug_freevm", 0, {FCVAR_CLIENTCMD_CAN_EXECUTE, FCVAR_ARCHIVE})

hook.Add("CalcViewModelView", "TFA_Debug_FreeVM", function(w, v, op, oa, p, a)
	if freevm_var:GetFloat() == 1 then
		if not fp then
			fp, fa = Vector(p), Angle(a)
		end

		p:Set(fp)
		a:Set(fa)
	end
end)

----[[JUMP ANIMS]]----

if SERVER then
	util.AddNetworkString("TFA_HasLanded")
	util.AddNetworkString("TFA_HasJumped")

	hook.Add("OnPlayerHitGround", "TFA_Landing_Anim", function(ply, inWater, onFloater, speed)
		net.Start("TFA_HasLanded")
		net.Send(ply)
	end)

	hook.Add("PlayerTick", "TFA_Jumping_Anim", function(ply)
		if IsValid(ply) and ply:Alive() then 
			if ply:KeyPressed(IN_JUMP) and ply:OnGround() then
				net.Start("TFA_HasJumped")
				net.Send(ply)
			end
		end
	end)
end

----[[MISC]]----

SWEP.ViewModelPunchPitchMultiplier = 0
SWEP.ViewModelPunchPitchMultiplier_IronSights = 0
SWEP.ViewModelPunch_MaxVertialOffset = 0
SWEP.ViewModelPunch_MaxVertialOffset_IronSights = 0
SWEP.ViewModelPunch_VertialMultiplier = 0
SWEP.ViewModelPunch_VertialMultiplier_IronSights = 0
SWEP.ViewModelPunchYawMultiplier = 0
SWEP.ViewModelPunchYawMultiplier_IronSights = 0