
local FeedYuTu_Frame_UnifiedPosition;
local g_StartTime = 20210902
local g_EndTime = 20210922
local g_LimitLV = 30
local g_Reward = 
{
	[1] = {itemId = 20310168, num = 8, times = 2, modeId = 1867,},--
	[2] = {itemId = 38002221, num = 1, times = 5, modeId = 1868,},--
	[3] = {itemId = 20501003, num = 1, times = 10,modeId = 1869,},--
	[4] = {itemId = 20502003, num = 1, times = 15,modeId = 1870,},--
}
local g_Button = {}
local g_MF = {}
local g_Text = {}
local g_Total = 0
local g_ObjCared = 0
local g_TargetId = 0
local g_ButtonOK = {}
local g_MAXProgress = 15
local g_Animate = {}
--=========================================================
-- 注册窗口关心的所有事件
--=========================================================
function FeedYuTu_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("ADJEST_UI_POS", false)
	this:RegisterEvent("OBJECT_CARED_EVENT", false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED", false)
	this:RegisterEvent( "HIDE_ON_SCENE_TRANSED" );		-- 离开场景

end

--=========================================================
-- 载入初始化
--=========================================================
function FeedYuTu_OnLoad()
	
	g_Button[1] = FeedYuTu_Item1
	g_Button[2] = FeedYuTu_Item2
	g_Button[3] = FeedYuTu_Item3
	g_Button[4] = FeedYuTu_Item4

	g_ButtonOK[1] = FeedYuTu_ItemOK1
	g_ButtonOK[2] = FeedYuTu_ItemOK2
	g_ButtonOK[3] = FeedYuTu_ItemOK3
	g_ButtonOK[4] = FeedYuTu_ItemOK4

	g_Animate[1] = FeedYuTu_ItemAnimate1
	g_Animate[2] = FeedYuTu_ItemAnimate2
	g_Animate[3] = FeedYuTu_ItemAnimate3
	g_Animate[4] = FeedYuTu_ItemAnimate4

	FeedYuTu_Frame_UnifiedPosition = FeedYuTu_Frame:GetProperty("UnifiedPosition");
end

--=========================================================
-- 事件处理
--=========================================================
function FeedYuTu_OnEvent(event)

	if (event == "UI_COMMAND" and tonumber(arg0) == 89117001) then --打开界面
		FeedYuTu_Clear()
		g_Total = Get_XParam_INT(0)
		for i = 1, 4 do
			g_MF[i] = Get_XParam_INT(i)
		end
		g_TargetId = Get_XParam_INT(5)
		g_ObjCared = DataPool : GetNPCIDByServerID(g_TargetId)
		this:Show()
		FeedYuTu_ShowFrame()
		

	elseif (event == "UI_COMMAND" and tonumber(arg0) == 89117002) then --刷新界面

		if(not this:IsVisible()) then
    		return
    	end

		g_Total = Get_XParam_INT(0)
		for i = 1, 4 do
			g_MF[i] = Get_XParam_INT(i)
			if g_MF[i] == 1 then
				g_ButtonOK[i]:Show()
				g_Animate[i]:Hide()
			end
			if g_Total >= g_Reward[i].times and g_MF[i] < 1 then
				g_Animate[i]:Show()
			end
			if g_Total >= g_Reward[i].times then
				FeedYuTu_FakeObject:SetFakeObject("")
				DataPool:SetRabbitModel(g_Reward[i].modeId);
				FeedYuTu_FakeObject:SetFakeObject("Rabbit")
			end
		end

		local tipstr = ScriptGlobal_Format("#{ZQWYT_20210712_23}", tostring(g_Total))
		FeedYuTu_ProgressValue:SetText(tipstr)
		FeedYuTu_ProgressBar:SetProgress(tonumber(g_Total), g_MAXProgress)
	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if(tonumber(arg0) ~= g_ObjCared) then
			return
		end
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			FeedYuTu_OnHiden()
		end	
	elseif (event == "ADJEST_UI_POS" ) then
		FeedYuTu_On_ResetPos()

	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		FeedYuTu_On_ResetPos()
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		FeedYuTu_OnHiden()
	end
end

function FeedYuTu_Clear()
	for i = 1, 4 do
		g_MF[i] = 0
		g_ButtonOK[i]:Hide()
		g_Button[i]:SetActionItem( -1 );
		g_Animate[i]:Hide()
	end
	g_Total = 0
	FeedYuTu_FakeObject:SetFakeObject("")
end

	
--=========================================================
-- 界面控件数据
--=========================================================
function FeedYuTu_ShowFrame()
	if g_objCared ~= -1 then
		this:CareObject(g_ObjCared, 0, "FeedYuTu")
		this:CareObject(g_ObjCared, 1, "FeedYuTu")
	else
		return
	end
	DataPool:SetRabbitModel(g_Reward[1].modeId);
	FeedYuTu_FakeObject:SetFakeObject("")
	FeedYuTu_FakeObject:SetFakeObject("Rabbit")
	for i = 1, 4 do
		local itemAction = DataPool:CreateBindActionItemForShow(g_Reward[i].itemId, g_Reward[i].num)
		if itemAction:GetID() ~= 0 then
			g_Button[i]:SetActionItem( itemAction:GetID() );
		else
			g_Button[i]:SetActionItem( -1 );
		end

		if g_Total >= g_Reward[i].times and g_MF[i] < 1 then
			g_Animate[i]:Show()
		end

		if g_MF[i] == 1 then
			g_ButtonOK[i]:Show()
		end

		if g_Total >= g_Reward[i].times then
			DataPool:SetRabbitModel(g_Reward[i].modeId);
			FeedYuTu_FakeObject:SetFakeObject("")
			FeedYuTu_FakeObject:SetFakeObject("Rabbit")
		end
	end

	local tipstr = ScriptGlobal_Format("#{ZQWYT_20210712_23}", tostring(g_Total))
	FeedYuTu_ProgressValue:SetText(tipstr)
	FeedYuTu_ProgressBar:SetProgress(tonumber(g_Total), g_MAXProgress)
end


--=========================================================
-- 关闭界面
--=========================================================
function FeedYuTu_OnHiden()
	if g_ObjCared ~= -1 then
		this:CareObject(g_ObjCared, 0, "FeedYuTu")
		g_ObjCared = -1
	end
	FeedYuTu_Clear()
	this:Hide()
	return
end


function FeedYuTu_On_ResetPos()
  	FeedYuTu_Frame:SetProperty("UnifiedPosition", FeedYuTu_Frame_UnifiedPosition);
end

function FeedYuTu_OnRewardClick(idx)
	
	if idx <= 0 or idx > 4 then
		return 
	end

	local nCurDay = tonumber(DataPool:GetServerDayTime());
	if nCurDay < g_StartTime or nCurDay > g_EndTime then
		PushDebugMessage("#{ZQWYT_20210712_25}")
		FeedYuTu_OnHiden()
		return 
	end

	local nLevel = Player:GetData("LEVEL")
	if nLevel < g_LimitLV  then
		PushDebugMessage("#{ZQWYT_20210712_10}")
		return
	end

	if g_MF[idx] == 1 then
		PushDebugMessage("#{ZQWYT_20210712_31}")
		return
	end

	if g_Total < g_Reward[idx].times then
		PushDebugMessage(ScriptGlobal_Format("#{ZQWYT_20210712_27}", tostring(g_Reward[idx].times)))
		return
	end

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("GetReward")
		Set_XSCRIPT_ScriptID(891170)
		Set_XSCRIPT_Parameter(0, g_TargetId)
		Set_XSCRIPT_Parameter(1, idx)
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()

end

function FeedYuTu_ShowHelp()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("ShowHelp")
		Set_XSCRIPT_ScriptID(891170)
		Set_XSCRIPT_Parameter(0, g_TargetId)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
end