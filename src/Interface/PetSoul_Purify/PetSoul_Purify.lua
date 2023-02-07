local objCared = -1
local MAX_OBJ_DISTANCE = 5.0

local PetSoul_Purify_MainFrame_UnifiedPosition
local PetSoul_Purify_NPC_ObjId
local PetSoul_Purify_FinishTimes

local PetSoul_Purify_Buttons = {}
local PetSoul_Purify_Tips = {}
local PetSoul_Purify_ActionItems = {}
local PetSoul_Purify_Animates = {}
local PetSoul_Purify_Marks = {}

local PetSoul_Purify_Reward = {
	[1] = {itemid = 38002508, times = 3 }, --累积3次礼
	[2] = {itemid = 38002509, times = 8 }, --累积8次礼
	[3] = {itemid = 38002510, times = 15}  --累积15次礼
}

--=========================================================
-- 注册窗口关心的所有事件
--=========================================================
function PetSoul_Purify_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("ADJEST_UI_POS", false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED", false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
	this:RegisterEvent("OBJECT_CARED_EVENT")
end

--=========================================================
-- 载入初始化
--=========================================================
function PetSoul_Purify_OnLoad()

	PetSoul_Purify_Buttons[1] = PetSoul_Purify_Page1_Icon1Get
	PetSoul_Purify_Buttons[2] = PetSoul_Purify_Page1_Icon2Get
	PetSoul_Purify_Buttons[3] = PetSoul_Purify_Page1_Icon3Get

	PetSoul_Purify_Tips[1] = PetSoul_Purify_Page1_Icon1Tips
	PetSoul_Purify_Tips[2] = PetSoul_Purify_Page1_Icon2Tips
	PetSoul_Purify_Tips[3] = PetSoul_Purify_Page1_Icon3Tips

	PetSoul_Purify_ActionItems[1] = PetSoul_Purify_Page1_one
	PetSoul_Purify_ActionItems[2] = PetSoul_Purify_Page1_two
	PetSoul_Purify_ActionItems[3] = PetSoul_Purify_Page1_three

	PetSoul_Purify_Animates[1] = PetSoul_Purify_Page1_one_ButtonAnimate
	PetSoul_Purify_Animates[2] = PetSoul_Purify_Page1_two_ButtonAnimate
	PetSoul_Purify_Animates[3] = PetSoul_Purify_Page1_three_ButtonAnimate

	PetSoul_Purify_Marks[1] = PetSoul_Purify_Page1_oneMark
	PetSoul_Purify_Marks[2] = PetSoul_Purify_Page1_twoMark
	PetSoul_Purify_Marks[3] = PetSoul_Purify_Page1_threeMark

	PetSoul_Purify_MainFrame_UnifiedPosition = PetSoul_Purify_MainFrame:GetProperty("UnifiedPosition")
end

--=========================================================
-- 事件处理
--=========================================================
function PetSoul_Purify_OnEvent(event)
	if event == "UI_COMMAND" and tonumber(arg0) == 5051001 then
		PetSoul_Purify_Refresh()
		if not this:IsVisible() then
			for i = 1, 3 do
				local theAction = DataPool:CreateBindActionItemForShow(PetSoul_Purify_Reward[i].itemid, 1)
				if theAction:GetID() ~= 0 then
					PetSoul_Purify_ActionItems[i]:SetActionItem(theAction:GetID())
				end
			end
			this:Show()
		end

	elseif event == "UI_COMMAND" and tonumber(arg0) == 5051002 then
		if this:IsVisible() then
			PetSoul_Purify_Refresh()
		end

	elseif event == "OBJECT_CARED_EVENT" then
		if tonumber(arg0) ~= objCared then
			return
		end
		if arg1 == "distance" and tonumber(arg2) > MAX_OBJ_DISTANCE or arg1 == "destroy" then
			if this:IsVisible() then
				PetSoul_Purify_OnHiden()
			end
		end

	elseif event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		PetSoul_Purify_Frame:SetProperty("UnifiedPosition", PetSoul_Purify_MainFrame_UnifiedPosition)

	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		PetSoul_Purify_OnHiden()
	end
end

--=========================================================
-- 界面刷新
--=========================================================
function PetSoul_Purify_Refresh()
	PetSoul_Purify_NPC_ObjId = Get_XParam_INT(0)
	objCared = DataPool:GetNPCIDByServerID(PetSoul_Purify_NPC_ObjId)
	if objCared ~= -1 then
		this:CareObject(objCared, 1, "PetSoul_Purify")
	end

	local max_progress_value = PetSoul_Purify_Reward[3].times
	PetSoul_Purify_FinishTimes = Get_XParam_INT(4)
	if PetSoul_Purify_FinishTimes > max_progress_value then
		PetSoul_Purify_FinishTimes = max_progress_value
	end

	for i = 1, 3 do
		if Get_XParam_INT(i) == 1 then --1.已领取
			PetSoul_Purify_Buttons[i]:Disable()
			PetSoul_Purify_Buttons[i]:SetText("#{BBWH_211230_21}")
			PetSoul_Purify_Marks[i]:Show()
			PetSoul_Purify_Tips[i]:Hide()
			PetSoul_Purify_Animates[i]:Hide()

		else --2.未领取
			PetSoul_Purify_Buttons[i]:Enable()
			PetSoul_Purify_Buttons[i]:SetText("#{BBWH_211230_20}")
			PetSoul_Purify_Marks[i]:Hide()

			if PetSoul_Purify_FinishTimes >= PetSoul_Purify_Reward[i].times then --2.1可领取
				PetSoul_Purify_Tips[i]:Show()
				PetSoul_Purify_Animates[i]:Show()

			else --2.2不可领取
				PetSoul_Purify_Tips[i]:Hide()
				PetSoul_Purify_Animates[i]:Hide()
			end
		end
	end

	-- 进度条
	PetSoul_Purify_EXP:SetToolTip(tostring(PetSoul_Purify_FinishTimes).."/"..tostring(max_progress_value))
	PetSoul_Purify_EXP:SetProgress(tonumber(PetSoul_Purify_FinishTimes), tonumber(max_progress_value))
end

--=========================================================
-- 控件事件 - 领取奖励
--=========================================================
function PetSoul_Purify_Page1_OnClick(idx)
	if type(idx) ~= "number" then
		return
	end

	if idx > 3 or idx < 1 then
		return
	end

	if PetSoul_Purify_Buttons[idx]:GetProperty("Disabled") == "True" then
		return
	end

	if PetSoul_Purify_FinishTimes < PetSoul_Purify_Reward[idx].times then
		PushDebugMessage("#{BBWH_211230_24}")
		return
	end

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnGetGift")
		Set_XSCRIPT_ScriptID(505100)
		Set_XSCRIPT_Parameter(0, idx)
		Set_XSCRIPT_Parameter(1, PetSoul_Purify_NPC_ObjId)
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()
end

--=========================================================
-- 控件事件 - 关闭
--=========================================================
function PetSoul_Purify_Close()
	PetSoul_Purify_OnHiden()
end

--=========================================================
-- 界面关闭事件
--=========================================================
function PetSoul_Purify_OnHiden()
	this:CareObject(objCared, 0, "PetSoul_Purify")
	objCared = -1
	this:Hide()
end