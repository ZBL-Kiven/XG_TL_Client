--累计收花奖励界面

local g_SeventhFestivalReceive_UnifiedPosition;

local g_ObjCareID		 = -1
local g_ServerCareID	 = -1

local g_SeventhFestivalReceive_Value = 0
local g_SeventhFestivalReceive_ValueGet = {0,0,0,0,0,0}
local g_SeventhFestivalReceive_77Day = 0
local g_SeventhFestivalReceive_DiffVDay = -1

local g_SeventhFestivalReceive_ActionList = {}
local g_SeventhFestivalReceive_TextList = {}
local g_SeventhFestivalReceive_AnimateList = {}

local g_SeventhFestivalReceive_77Value = 99

local g_SeventhFestivalReceive_InfoList = {
[1] = { itemid = 10124292, value = 11, itemnum = 1 },
[2] = { itemid = 10141875, value = 33, itemnum = 1 },
[3] = { itemid = 30503140, value = 99, itemnum = 5 },
[4] = { itemid = 39920098, value = 188, itemnum = 1 },
[5] = { itemid = 30008183, value = 520, itemnum = 1 },
[6] = { itemid = 20307195, value = 999, itemnum = 1 },
}

--=========================================================
-- 注册窗口关心的所有事件
--=========================================================
function SeventhFestivalReceive_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	
	this:RegisterEvent("ADJEST_UI_POS", false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED", false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false);
end

--=========================================================
-- 载入初始化
--=========================================================
function SeventhFestivalReceive_OnLoad()

	g_SeventhFestivalReceive_ActionList[1] = SeventhFestivalReceive_Award1 
	g_SeventhFestivalReceive_ActionList[2] = SeventhFestivalReceive_Award2 
	g_SeventhFestivalReceive_ActionList[3] = SeventhFestivalReceive_Award3 
	g_SeventhFestivalReceive_ActionList[4] = SeventhFestivalReceive_Award4 
	g_SeventhFestivalReceive_ActionList[5] = SeventhFestivalReceive_Award5 
	g_SeventhFestivalReceive_ActionList[6] = SeventhFestivalReceive_Award6 
	
	g_SeventhFestivalReceive_TextList[1] = SeventhFestivalReceive_Award1Text
	g_SeventhFestivalReceive_TextList[2] = SeventhFestivalReceive_Award2Text
	g_SeventhFestivalReceive_TextList[3] = SeventhFestivalReceive_Award3Text
	g_SeventhFestivalReceive_TextList[4] = SeventhFestivalReceive_Award4Text
	g_SeventhFestivalReceive_TextList[5] = SeventhFestivalReceive_Award5Text
	g_SeventhFestivalReceive_TextList[6] = SeventhFestivalReceive_Award6Text
	
	g_SeventhFestivalReceive_AnimateList = {
	[1] = {SeventhFestivalReceive_Award1Animate, SeventhFestivalReceive_Award1OK},
	[2] = {SeventhFestivalReceive_Award2Animate, SeventhFestivalReceive_Award2OK},
	[3] = {SeventhFestivalReceive_Award3Animate, SeventhFestivalReceive_Award3OK},
	[4] = {SeventhFestivalReceive_Award4Animate, SeventhFestivalReceive_Award4OK},
	[5] = {SeventhFestivalReceive_Award5Animate, SeventhFestivalReceive_Award5OK},
	[6] = {SeventhFestivalReceive_Award6Animate, SeventhFestivalReceive_Award6OK},
	}
	
	g_SeventhFestivalReceive_UnifiedPosition = SeventhFestivalReceive_Frame:GetProperty("UnifiedPosition");
	    
end

--=========================================================
-- 事件处理
--=========================================================
function SeventhFestivalReceive_OnEvent(event)

	if (event == "UI_COMMAND" and tonumber(arg0) == 89116401) then --打开界面
		
		if Get_XParam_INT( 0 ) <= 0 then
			SeventhFestivalReceive_Close()
			return
		end
		
		--关心当前对话的NPC
		g_ServerCareID = Get_XParam_INT(1)
		g_ObjCareID = DataPool:GetNPCIDByServerID(g_ServerCareID);
		if (g_ObjCareID == -1) then
			PushDebugMessage("server传过来的数据有问题。");
			return
		end
		SeventhFestivalReceive_BeginCareObject()
		
		g_SeventhFestivalReceive_Value = Get_XParam_INT( 2 )
		g_SeventhFestivalReceive_77Day = Get_XParam_INT( 3 )
		g_SeventhFestivalReceive_DiffVDay = Get_XParam_INT( 4 )
		
		for i = 1, table.getn(g_SeventhFestivalReceive_ValueGet) do
			g_SeventhFestivalReceive_ValueGet[i] = Get_XParam_INT( i + 4 )
		end
		
		local strTime = Get_XParam_STR(0)
		if strTime ~= nil then
			SeventhFestivalReceive_TakeOnBtn:SetText(strTime)
		end
		
		SeventhFestivalReceive_OnShow()
		
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 89116402 and this:IsVisible()) then --刷新界面
				
		g_SeventhFestivalReceive_Value = Get_XParam_INT( 2 )
		g_SeventhFestivalReceive_77Day = Get_XParam_INT( 3 )
		g_SeventhFestivalReceive_DiffVDay = Get_XParam_INT( 4 )
		
		for i = 1, table.getn(g_SeventhFestivalReceive_ValueGet) do
			g_SeventhFestivalReceive_ValueGet[i] = Get_XParam_INT( i + 4 )
		end
		
		local strTime = Get_XParam_STR(0)
		if strTime ~= nil then
			SeventhFestivalReceive_TakeOnBtn:SetText(strTime)
		end
		
		SeventhFestivalReceive_OnShow()
		
	elseif event == "HIDE_ON_SCENE_TRANSED"  then	
		this:Hide()
		
	elseif (event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED") then
		SeventhFestivalReceive_Frame_On_ResetPos()
		
	end
	
end

--=========================================================
-- 显示信息
--=========================================================
function SeventhFestivalReceive_OnShow()

	for i = 1, table.getn(g_SeventhFestivalReceive_InfoList) do				
		local theAction = DataPool:CreateBindActionItemForShow(g_SeventhFestivalReceive_InfoList[i].itemid, g_SeventhFestivalReceive_InfoList[i].itemnum)
		if theAction:GetID() ~= 0 then
			g_SeventhFestivalReceive_ActionList[i]:SetActionItem(theAction:GetID())
		end
		local strRose = ScriptGlobal_Format("#{QXHB_20210701_194}", tostring(g_SeventhFestivalReceive_InfoList[i].value))
		g_SeventhFestivalReceive_TextList[i]:SetText(strRose)
		
		if g_SeventhFestivalReceive_AnimateList[i] ~= nil and g_SeventhFestivalReceive_ValueGet[i] ~= nil then
			g_SeventhFestivalReceive_AnimateList[i][1]:Hide()
			g_SeventhFestivalReceive_AnimateList[i][2]:Hide()
			if g_SeventhFestivalReceive_Value >= g_SeventhFestivalReceive_InfoList[i].value then
				-- 是否已领奖
				if g_SeventhFestivalReceive_ValueGet[i] == 1 then
					-- 已达成 已领奖
					g_SeventhFestivalReceive_AnimateList[i][2]:Show()
				else
					-- 已达成 未领奖
					g_SeventhFestivalReceive_AnimateList[i][1]:Show()
				end
			else
				-- 未达成
			end
		end
	end
	
	local theAction = DataPool:CreateBindActionItemForShow(38002291, 1)
	if theAction:GetID() ~= 0 then
		SeventhFestivalReceive_TakeOnIcon:SetActionItem(theAction:GetID())
	end
	
	SeventhFestivalReceive_TakeOnIconAnimate:Hide()
	SeventhFestivalReceive_TakeOnIconOK:Hide()
	if g_SeventhFestivalReceive_Value >= g_SeventhFestivalReceive_77Value and g_SeventhFestivalReceive_DiffVDay == 0 then
		if g_SeventhFestivalReceive_77Day == 1 then
			SeventhFestivalReceive_TakeOnIconOK:Show()
		else
			SeventhFestivalReceive_TakeOnIconAnimate:Show()
		end
	end
		
	local str = ScriptGlobal_Format("#{QXHB_20210701_193}", tostring(g_SeventhFestivalReceive_Value))
	SeventhFestivalReceive_TakeOn_Text2:SetText(str)

	this:Show()

end

--=========================================================
-- 重置界面
--=========================================================
function SeventhFestivalReceive_Clear()

	for i = 1, table.getn(g_SeventhFestivalReceive_ActionList) do
		g_SeventhFestivalReceive_ActionList[i]:SetActionItem(-1)
	end
	
	SeventhFestivalReceive_StopCareObject()
	
end

--=========================================================
-- 领取奖励
--=========================================================
function SeventhFestivalReceive_Award_Item_Clicked( nIdx )
	if g_SeventhFestivalReceive_ActionList[nIdx] == nil then
		return
	end
	
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("GetReceiveAccGift")
		Set_XSCRIPT_ScriptID(891164)
		Set_XSCRIPT_Parameter( 0, g_ServerCareID )
		Set_XSCRIPT_Parameter( 1, nIdx )
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()
	
end

--=========================================================
-- 查看帮助
--=========================================================
function SeventhFestivalReceive_77_Item_Clicked()

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("GetAcc77Gift")
		Set_XSCRIPT_ScriptID(891164)
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
function SeventhFestivalReceive_BeginCareObject()
	this:CareObject(g_ObjCareID, 1, "SeventhFestivalReceive");
end


--*************************************************
--停止对某NPC的关心
--*************************************************
function SeventhFestivalReceive_StopCareObject()
	this:CareObject(g_ObjCareID, 0, "SeventhFestivalReceive");
end

--=========================================================
-- 关闭界面
--=========================================================
function SeventhFestivalReceive_OnHiden()

	SeventhFestivalReceive_Clear()
	
	this:Hide()
	
end

--=========================================================
-- 关闭界面
--=========================================================
function SeventhFestivalReceive_Close()

	SeventhFestivalReceive_Clear()
	
	this:Hide()
	
end

function SeventhFestivalReceive_Frame_On_ResetPos()

  SeventhFestivalReceive_Frame:SetProperty("UnifiedPosition", g_SeventhFestivalReceive_UnifiedPosition);
  
end


