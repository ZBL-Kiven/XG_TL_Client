
local XiaRi_HanBing_Frame_UnifiedPosition;
local g_StartTime = 20210719
local g_EndTime = 20210804
local g_LimitLV = 30
local g_Reward = 
{
	[1] = {itemId = 20310168, num = 10, times = 12,},--金蚕丝*10
	[2] = {itemId = 50313004, num = 1, times = 24,},--红宝石3级
	[3] = {itemId = 38002221, num = 1, times = 48,},--晶石3级礼盒
}
local g_Button = {}
local g_MF = {}
local g_Text = {}
local g_Total = 0
local g_ObjCared = 0
local g_TargetId = 0
local g_ButtonOK = {}
local g_MAXProgress = 48
local g_Animate = {}
--=========================================================
-- 注册窗口关心的所有事件
--=========================================================
function XiaRi_HanBing_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("ADJEST_UI_POS", false)
	this:RegisterEvent("OBJECT_CARED_EVENT", false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED", false)
	this:RegisterEvent( "HIDE_ON_SCENE_TRANSED" );		-- 离开场景

end

--=========================================================
-- 载入初始化
--=========================================================
function XiaRi_HanBing_OnLoad()
	
	g_Button[1] = XiaRi_HanBing_FeelGood1Btn
	g_Button[2] = XiaRi_HanBing_FeelGood2Btn
	g_Button[3] = XiaRi_HanBing_FeelGood3Btn

	g_Text[1] = XiaRi_HanBing_FeelGood1Text
	g_Text[2] = XiaRi_HanBing_FeelGood2Text
	g_Text[3] = XiaRi_HanBing_FeelGood3Text

	g_ButtonOK[1] = XiaRi_HanBing_FeelGood1BtnOK
	g_ButtonOK[2] = XiaRi_HanBing_FeelGood2BtnOK
	g_ButtonOK[3] = XiaRi_HanBing_FeelGood3BtnOK

	g_Animate[1] = XiaRi_HanBing_FeelGood1BtnAnimate
	g_Animate[2] = XiaRi_HanBing_FeelGood2BtnAnimate
	g_Animate[3] = XiaRi_HanBing_FeelGood3BtnAnimate

	XiaRi_HanBing_Frame_UnifiedPosition = XiaRi_HanBing_Frame:GetProperty("UnifiedPosition");
end

--=========================================================
-- 事件处理
--=========================================================
function XiaRi_HanBing_OnEvent(event)

	if (event == "UI_COMMAND" and tonumber(arg0) == 89115901) then --打开界面
		XiaRi_HanBing_Clear()
		g_Total = Get_XParam_INT(0)
		for i = 1, 3 do
			g_MF[i] = Get_XParam_INT(i)
		end
		g_TargetId = Get_XParam_INT(4)
		g_ObjCared = DataPool : GetNPCIDByServerID(g_TargetId)
		XiaRi_HanBing_ShowFrame()
		this:Show()

	elseif (event == "UI_COMMAND" and tonumber(arg0) == 89115902) then --刷新界面

		if(not this:IsVisible()) then
    		return
    	end

		g_Total = Get_XParam_INT(0)
		for i = 1, 3 do
			g_MF[i] = Get_XParam_INT(i)
			if g_MF[i] == 1 then
				g_ButtonOK[i]:Show()
				g_Animate[i]:Hide()
			end
			if g_Total >= g_Reward[i].times and g_MF[i] < 1 then
			--g_Tips[i]:Show()
				g_Animate[i]:Show()
			end
		end

		local tipstr = ScriptGlobal_Format("#{HBS_20210621_39}", tostring(g_Total))
		XiaRi_HanBing_FeelGoodAll:SetText(tipstr)
		XiaRi_HanBing_FeelGoodProgress:SetProgress(tonumber(g_Total), g_MAXProgress)
	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if(tonumber(arg0) ~= g_ObjCared) then
			return
		end
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			XiaRi_HanBing_OnHiden()
		end	
	elseif (event == "ADJEST_UI_POS" ) then
		XiaRi_HanBing_On_ResetPos()

	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		XiaRi_HanBing_On_ResetPos()
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		XiaRi_HanBing_OnHiden()
	end
end

function XiaRi_HanBing_Clear()
	for i = 1, 3 do
		g_MF[i] = 0
		g_ButtonOK[i]:Hide()
		g_Button[i]:SetActionItem( -1 );
		g_Animate[i]:Hide()
	end
	g_Total = 0
end

	
--=========================================================
-- 界面控件数据
--=========================================================
function XiaRi_HanBing_ShowFrame()
	if g_objCared ~= -1 then
		this:CareObject(g_ObjCared, 0, "XiaRi_HanBing")
		this:CareObject(g_ObjCared, 1, "XiaRi_HanBing")
	else
		return
	end

	for i = 1, 3 do
		local itemAction = DataPool:CreateBindActionItemForShow(g_Reward[i].itemId, g_Reward[i].num)
		if itemAction:GetID() ~= 0 then
			g_Button[i]:SetActionItem( itemAction:GetID() );
		else
			g_Button[i]:SetActionItem( -1 );
		end

		if g_Total >= g_Reward[i].times and g_MF[i] < 1 then
			--g_Tips[i]:Show()
			g_Animate[i]:Show()
		end

		if g_MF[i] == 1 then
			g_ButtonOK[i]:Show()
		end

		local tip = ScriptGlobal_Format("#{HBS_20210621_38}", tostring(g_Reward[i].times))
		g_Text[i]:SetText(tip)
	end

	local tipstr = ScriptGlobal_Format("#{HBS_20210621_39}", tostring(g_Total))
	XiaRi_HanBing_FeelGoodAll:SetText(tipstr)

	XiaRi_HanBing_FeelGoodProgress:SetProgress(tonumber(g_Total), g_MAXProgress)
end


--=========================================================
-- 关闭界面
--=========================================================
function XiaRi_HanBing_OnHiden()
	if g_ObjCared ~= -1 then
		this:CareObject(g_ObjCared, 0, "XiaRi_HanBing")
		g_ObjCared = -1
	end
	XiaRi_HanBing_Clear()
	this:Hide()
	return
end


function XiaRi_HanBing_On_ResetPos()
  	XiaRi_HanBing_Frame:SetProperty("UnifiedPosition", XiaRi_HanBing_Frame_UnifiedPosition);
end

function XiaRi_HanBing_OnRewardClick(idx)
	
	if idx <= 0 or idx > 3 then
		return 
	end

	local nCurDay = tonumber(DataPool:GetServerDayTime());
	if nCurDay < g_StartTime or nCurDay > g_EndTime then
		PushDebugMessage("#{HBS_20210621_30}")
		XiaRi_HanBing_OnHiden()
		return 
	end

	local nLevel = Player:GetData("LEVEL")
	if nLevel < g_LimitLV  then
		PushDebugMessage("#{HBS_20210621_31}")
		return
	end

	if g_MF[idx] == 1 then
		PushDebugMessage("#{DWCXN_20210508_41}")
		return
	end

	if g_Total < g_Reward[idx].times then
		PushDebugMessage(ScriptGlobal_Format("#{HBS_20210621_41}", tostring(g_Reward[idx].times)))
		return
	end

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("GetReward")
		Set_XSCRIPT_ScriptID(891159)
		Set_XSCRIPT_Parameter(0, g_TargetId)
		Set_XSCRIPT_Parameter(1, idx)
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()

end

function XiaRi_HanBing_ShowHelp()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("ShowHelp")
		Set_XSCRIPT_ScriptID(891159)
		Set_XSCRIPT_Parameter(0, g_TargetId)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
end