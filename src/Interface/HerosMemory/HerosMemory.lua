
local HerosMemory_MainFrame_UnifiedPosition;
local g_StartTime = 20210416
local g_EndTime = 20210505
local g_Button = {}
local g_ButtonMask = {}
local g_Tips = {}
local g_Text = {}
local g_HeroMemory_MaxValue = 28
local g_LimitLV = 30
local g_Reward = 
{
	[1] = {itemId = 30900006, num = 2, times = 2,},--天罡强化精华*2
	[2] = {itemId = 20310168, num = 5, times = 6,},--金蚕丝*5
	[3] = {itemId = 20800013, num = 5, times = 12,},--地元石*5
	[4] = {itemId = 50313004, num = 1, times = 20,},--红宝石3级
	[5] = {itemId = 38002221, num = 1, times = 28,},--晶石3级礼盒
}
local g_FinishTimes = 0
local g_MF = {0,0,0,0,0}
local g_Animate = {}
--=========================================================
-- 注册窗口关心的所有事件
--=========================================================
function HerosMemory_PreLoad()
	this:RegisterEvent("UI_COMMAND")

	this:RegisterEvent("ADJEST_UI_POS", false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED", false)
	this:RegisterEvent( "HIDE_ON_SCENE_TRANSED" );		-- 离开场景

end

--=========================================================
-- 载入初始化
--=========================================================
function HerosMemory_OnLoad()

	g_Button[1] = HerosMemory_Page1_one
	g_Button[2] = HerosMemory_Page1_two
	g_Button[3] = HerosMemory_Page1_three
	g_Button[4] = HerosMemory_Page1_four
	g_Button[5] = HerosMemory_Page1_five

	g_ButtonMask[1] = HerosMemory_Page1_oneMark
	g_ButtonMask[2] = HerosMemory_Page1_twoMark
	g_ButtonMask[3] = HerosMemory_Page1_threeMark
	g_ButtonMask[4] = HerosMemory_Page1_fourMark
	g_ButtonMask[5] = HerosMemory_Page1_fiveMark

	g_Tips[1] = HerosMemory_oneTips
	g_Tips[2] = HerosMemory_twoTips
	g_Tips[3] = HerosMemory_threeTips
	g_Tips[4] = HerosMemory_fourTips
	g_Tips[5] = HerosMemory_fiveTips

	g_Text[1] = HerosMemory_oneText
	g_Text[2] = HerosMemory_twoText
	g_Text[3] = HerosMemory_threeText
	g_Text[4] = HerosMemory_fourText
	g_Text[5] = HerosMemory_fiveText

	g_Animate[1] = HerosMemory_Page1_one_ButtonAnimate
	g_Animate[2] = HerosMemory_Page1_two_ButtonAnimate
	g_Animate[3] = HerosMemory_Page1_three_ButtonAnimate
	g_Animate[4] = HerosMemory_Page1_four_ButtonAnimate
	g_Animate[5] = HerosMemory_Page1_five_ButtonAnimate

	HerosMemory_MainFrame_UnifiedPosition = HerosMemory_MainFrame:GetProperty("UnifiedPosition");

end

--=========================================================
-- 事件处理
--=========================================================
function HerosMemory_OnEvent(event)

	if (event == "UI_COMMAND" and tonumber(arg0) == 89112401) then --打开界面
		HerosMemory_Clear()
		HerosMemory_Init()
		this:Show()

	elseif (event == "UI_COMMAND" and tonumber(arg0) == 89112402) then --刷新界面
		HerosMemory_Init()
	elseif (event == "ADJEST_UI_POS" ) then
		HerosMemory_On_ResetPos()

	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		HerosMemory_On_ResetPos()
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		HerosMemory_Close()
	end
end

function HerosMemory_Clear( )
	for i=1, table.getn(g_Button) do
		g_ButtonMask[i]:Hide()
		g_Tips[i]:Hide()
		g_Button[i]:SetActionItem( -1 );
		g_Animate[i]:Hide()
	end
	HerosMemory_BottomText:SetText("")
end

	
--=========================================================
-- 界面控件数据
--=========================================================
function HerosMemory_Init(sex)
	g_FinishTimes = Get_XParam_INT(0)

	for j = 1, 5 do
		g_MF[j] = Get_XParam_INT(j)
	end

	for i = 1, table.getn(g_Text) do
		g_Text[i]:SetText("#c993333"..tostring(g_Reward[i].times))
		local itemAction = DataPool:CreateBindActionItemForShow(g_Reward[i].itemId, g_Reward[i].num)
		if itemAction:GetID() ~= 0 then
			g_Button[i]:SetActionItem( itemAction:GetID() );
		else
			g_Button[i]:SetActionItem( -1 );
		end

		if g_MF[i] == 1 then--已经领取过
			g_ButtonMask[i]:Show()
			g_Animate[i]:Hide()
		else
			if g_FinishTimes >= g_Reward[i].times then
				g_Tips[i]:Show()
				g_Animate[i]:Show()
			end
		end

	end
	--进度条显示
	local tipstr = ScriptGlobal_Format("#{TLYXH_210223_44}", tostring(g_FinishTimes))
	HerosMemory_EXP:SetToolTip(tipstr)
	HerosMemory_EXP:SetProgress(tonumber(g_FinishTimes),g_HeroMemory_MaxValue)
	tipstr = ScriptGlobal_Format("#{TLYXH_210223_45}", tostring(g_FinishTimes))	
	HerosMemory_BottomText:SetText(tipstr)
end


--=========================================================
-- 关闭界面
--=========================================================
function HerosMemory_Close()
	HerosMemory_Clear()
	this:Hide()
	return
end


function HerosMemory_On_ResetPos()
  	HerosMemory_Frame:SetProperty("UnifiedPosition", HerosMemory_Frame_UnifiedPosition);
end


function HerosMemory_1_Select(idx)

	if idx <= 0 or idx > 6 then
		return
	end
	g_Select = idx

end

function HerosMemory_OnClick(idx)
	
	if idx <= 0 or idx > 5 then

		return 
	end

	local nCurDay = tonumber(DataPool:GetServerDayTime());
	if nCurDay < g_StartTime or nCurDay > g_EndTime then
		PushDebugMessage("#{TLYXH_210223_46}")
		HerosMemory_Close()
		return 
	end

	local nLevel = Player:GetData("LEVEL")
	if nLevel < g_LimitLV  then
		PushDebugMessage("#{TLYXH_210223_47}")
		return
	end

	if g_MF[idx] == 1 then
		PushDebugMessage("#{TLYXH_210223_48}")
		return
	end

	if g_FinishTimes < g_Reward[idx].times then
		PushDebugMessage(ScriptGlobal_Format("#{TLYXH_210223_49}", tostring(g_Reward[idx].times)))
		return
	end

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("GetReward")
		Set_XSCRIPT_ScriptID(891124)
		Set_XSCRIPT_Parameter(0, idx)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()

end

function HerosMemory_OnHiden()
	HerosMemory_Close()
end