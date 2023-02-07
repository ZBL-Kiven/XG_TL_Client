--累计收花奖励界面

local g_LoverTimeReceive_UnifiedPosition;

local g_ObjCareID		 = -1
local g_ServerCareID	 = -1

local g_LoverTimeReceive_Value = 0
local g_LoverTimeReceive_ValueGet = {0,0,0,0,0,0}
local g_LoverTimeReceive_214Day = 0
local g_LoverTimeReceive_DiffVDay = -1

local g_LoverTimeReceive_ActionList = {}
local g_LoverTimeReceive_TextList = {}
local g_LoverTimeReceive_AnimateList = {}

local g_LoverTimeReceive_214Value = 99
local g_LoverTimeReceive_214Item = 38002473

local g_LoverTimeReceive_InfoList = {
[1] = { itemid = 10124698, value = 11, itemnum = 1 },
[2] = { itemid = 10141875, value = 33, itemnum = 1 },
[3] = { itemid = 30503140, value = 99, itemnum = 5 },
[4] = { itemid = 39920101, value = 188, itemnum = 1 },
[5] = { itemid = 30008192, value = 520, itemnum = 1 },
[6] = { itemid = 20307204, value = 999, itemnum = 1 },
}

--=========================================================
-- 注册窗口关心的所有事件
--=========================================================
function LoverTimeReceive_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	
	this:RegisterEvent("ADJEST_UI_POS", false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED", false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false);
end

--=========================================================
-- 载入初始化
--=========================================================
function LoverTimeReceive_OnLoad()

	g_LoverTimeReceive_ActionList[1] = LoverTimeReceive_Award1 
	g_LoverTimeReceive_ActionList[2] = LoverTimeReceive_Award2 
	g_LoverTimeReceive_ActionList[3] = LoverTimeReceive_Award3 
	g_LoverTimeReceive_ActionList[4] = LoverTimeReceive_Award4 
	g_LoverTimeReceive_ActionList[5] = LoverTimeReceive_Award5 
	g_LoverTimeReceive_ActionList[6] = LoverTimeReceive_Award6 
	
	g_LoverTimeReceive_TextList[1] = LoverTimeReceive_Award1Text
	g_LoverTimeReceive_TextList[2] = LoverTimeReceive_Award2Text
	g_LoverTimeReceive_TextList[3] = LoverTimeReceive_Award3Text
	g_LoverTimeReceive_TextList[4] = LoverTimeReceive_Award4Text
	g_LoverTimeReceive_TextList[5] = LoverTimeReceive_Award5Text
	g_LoverTimeReceive_TextList[6] = LoverTimeReceive_Award6Text
	
	g_LoverTimeReceive_AnimateList = {
	[1] = {LoverTimeReceive_Award1Animate, LoverTimeReceive_Award1OK},
	[2] = {LoverTimeReceive_Award2Animate, LoverTimeReceive_Award2OK},
	[3] = {LoverTimeReceive_Award3Animate, LoverTimeReceive_Award3OK},
	[4] = {LoverTimeReceive_Award4Animate, LoverTimeReceive_Award4OK},
	[5] = {LoverTimeReceive_Award5Animate, LoverTimeReceive_Award5OK},
	[6] = {LoverTimeReceive_Award6Animate, LoverTimeReceive_Award6OK},
	}
	
	g_LoverTimeReceive_UnifiedPosition = LoverTimeReceive_Frame:GetProperty("UnifiedPosition");
	    
end

--=========================================================
-- 事件处理
--=========================================================
function LoverTimeReceive_OnEvent(event)

	if (event == "UI_COMMAND" and tonumber(arg0) == 89297101) then --打开界面
		
		if Get_XParam_INT( 0 ) <= 0 then
			LoverTimeReceive_Close()
			return
		end
		
		--关心当前对话的NPC
		g_ServerCareID = Get_XParam_INT(1)
		g_ObjCareID = DataPool:GetNPCIDByServerID(g_ServerCareID);
		if (g_ObjCareID == -1) then
			PushDebugMessage("server传过来的数据有问题。");
			return
		end
		LoverTimeReceive_BeginCareObject()
		
		g_LoverTimeReceive_Value = Get_XParam_INT( 2 )
		g_LoverTimeReceive_214Day = Get_XParam_INT( 3 )
		g_LoverTimeReceive_DiffVDay = Get_XParam_INT( 4 )
		
		for i = 1, table.getn(g_LoverTimeReceive_ValueGet) do
			g_LoverTimeReceive_ValueGet[i] = Get_XParam_INT( i + 4 )
		end
		
		local strTime = Get_XParam_STR(0)
		if strTime ~= nil then
			LoverTimeReceive_TakeOnBtn:SetText(strTime)
		end
		
		LoverTimeReceive_OnShow()
		
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 89297102 and this:IsVisible()) then --刷新界面
				
		g_LoverTimeReceive_Value = Get_XParam_INT( 2 )
		g_LoverTimeReceive_214Day = Get_XParam_INT( 3 )
		g_LoverTimeReceive_DiffVDay = Get_XParam_INT( 4 )
		
		for i = 1, table.getn(g_LoverTimeReceive_ValueGet) do
			g_LoverTimeReceive_ValueGet[i] = Get_XParam_INT( i + 4 )
		end
		
		local strTime = Get_XParam_STR(0)
		if strTime ~= nil then
			LoverTimeReceive_TakeOnBtn:SetText(strTime)
		end
		
		LoverTimeReceive_OnShow()
		
	elseif event == "HIDE_ON_SCENE_TRANSED"  then	
		this:Hide()
		
	elseif (event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED") then
		LoverTimeReceive_Frame_On_ResetPos()
		
	end
	
end

--=========================================================
-- 显示信息
--=========================================================
function LoverTimeReceive_OnShow()

	for i = 1, table.getn(g_LoverTimeReceive_InfoList) do				
		local theAction = DataPool:CreateBindActionItemForShow(g_LoverTimeReceive_InfoList[i].itemid, g_LoverTimeReceive_InfoList[i].itemnum)
		if theAction:GetID() ~= 0 then
			g_LoverTimeReceive_ActionList[i]:SetActionItem(theAction:GetID())
		end
		local strRose = ScriptGlobal_Format("#{QRZM_211119_194}", tostring(g_LoverTimeReceive_InfoList[i].value))
		g_LoverTimeReceive_TextList[i]:SetText(strRose)
		
		if g_LoverTimeReceive_AnimateList[i] ~= nil and g_LoverTimeReceive_ValueGet[i] ~= nil then
			g_LoverTimeReceive_AnimateList[i][1]:Hide()
			g_LoverTimeReceive_AnimateList[i][2]:Hide()
			if g_LoverTimeReceive_Value >= g_LoverTimeReceive_InfoList[i].value then
				-- 是否已领奖
				if g_LoverTimeReceive_ValueGet[i] == 1 then
					-- 已达成 已领奖
					g_LoverTimeReceive_AnimateList[i][2]:Show()
				else
					-- 已达成 未领奖
					g_LoverTimeReceive_AnimateList[i][1]:Show()
				end
			else
				-- 未达成
			end
		end
	end
	
	local theAction = DataPool:CreateBindActionItemForShow(g_LoverTimeReceive_214Item, 1)
	if theAction:GetID() ~= 0 then
		LoverTimeReceive_TakeOnIcon:SetActionItem(theAction:GetID())
	end
	
	LoverTimeReceive_TakeOnIconAnimate:Hide()
	LoverTimeReceive_TakeOnIconOK:Hide()
	if g_LoverTimeReceive_Value >= g_LoverTimeReceive_214Value and g_LoverTimeReceive_DiffVDay == 0 then
		if g_LoverTimeReceive_214Day == 1 then
			LoverTimeReceive_TakeOnIconOK:Show()
		else
			LoverTimeReceive_TakeOnIconAnimate:Show()
		end
	end
		
	local str = ScriptGlobal_Format("#{QRZM_211119_193}", tostring(g_LoverTimeReceive_Value))
	LoverTimeReceive_TakeOn_Text2:SetText(str)

	this:Show()

end

--=========================================================
-- 重置界面
--=========================================================
function LoverTimeReceive_Clear()

	for i = 1, table.getn(g_LoverTimeReceive_ActionList) do
		g_LoverTimeReceive_ActionList[i]:SetActionItem(-1)
	end
	
	LoverTimeReceive_StopCareObject()
	
end

--=========================================================
-- 领取奖励
--=========================================================
function LoverTimeReceive_Award_Item_Clicked( nIdx )
	if g_LoverTimeReceive_ActionList[nIdx] == nil then
		return
	end
	
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("GetReceiveAccGift")
		Set_XSCRIPT_ScriptID( 892971 )
		Set_XSCRIPT_Parameter( 0, g_ServerCareID )
		Set_XSCRIPT_Parameter( 1, nIdx )
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()
	
end

--=========================================================
-- 查看帮助
--=========================================================
function LoverTimeReceive_214_Item_Clicked()

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("GetAcc214Gift")
		Set_XSCRIPT_ScriptID( 892971 )
		Set_XSCRIPT_Parameter( 0, g_ServerCareID )
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
	
end

--*************************************************
--开始关心NPC，就是确认玩家当前操作的NPC，如果离NPC
--太远就会关闭窗口在开始关心之前需要先确定这个界面
--是不是已经有“关心”的NPC，如果有的话，先取消已经
--有的“关心”
--*************************************************
function LoverTimeReceive_BeginCareObject()
	this:CareObject(g_ObjCareID, 1, "LoverTimeReceive");
end


--*************************************************
--停止对某NPC的关心
--*************************************************
function LoverTimeReceive_StopCareObject()
	this:CareObject(g_ObjCareID, 0, "LoverTimeReceive");
end

--=========================================================
-- 关闭界面
--=========================================================
function LoverTimeReceive_OnHiden()

	LoverTimeReceive_Clear()
	
	this:Hide()
	
end

--=========================================================
-- 关闭界面
--=========================================================
function LoverTimeReceive_Close()

	LoverTimeReceive_Clear()
	
	this:Hide()
	
end

function LoverTimeReceive_Frame_On_ResetPos()

  LoverTimeReceive_Frame:SetProperty("UnifiedPosition", g_LoverTimeReceive_UnifiedPosition);
  
end


