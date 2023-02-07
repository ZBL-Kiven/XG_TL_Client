------------------------------------
-- 2022珍兽预热活动
-- 活动界面
------------------------------------

local g_Frame_UnifiedPosition

--关注npc
local MAX_OBJ_DISTANCE = 5.0
local objCared = -1
local npcObjId = -1

--数据
local g_CtrlList = {}
local g_ItemList = {38002489,38002490,38002491}

--================================================
-- PreLoad()
--================================================
function ZhenShou_HuoDong_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")	
	this:RegisterEvent("PLAYER_LEAVE_WORLD");	
	this:RegisterEvent("OBJECT_CARED_EVENT",false)
end

--================================================
-- OnLoad()
--================================================
function ZhenShou_HuoDong_OnLoad()
	g_Frame_UnifiedPosition = ZhenShou_HuoDong_Frame:GetProperty("UnifiedPosition");
		
	g_CtrlList = 
	{
		[1] = {bk1=ZhenShou_HuoDong_1BK_1,bk2=ZhenShou_HuoDong_1BK_2,btn=ZhenShou_HuoDong_1BK_Btn,finish=ZhenShou_HuoDong_1BK_Btn_D,item=ZhenShou_HuoDong_Item1,},
		[2] = {bk1=ZhenShou_HuoDong_2BK_1,bk2=ZhenShou_HuoDong_2BK_2,btn=ZhenShou_HuoDong_2BK_Btn,finish=ZhenShou_HuoDong_2BK_Btn_D,item=ZhenShou_HuoDong_Item2,},
		[3] = {bk1=ZhenShou_HuoDong_3BK_1,bk2=ZhenShou_HuoDong_3BK_2,btn=ZhenShou_HuoDong_3BK_Btn,finish=ZhenShou_HuoDong_3BK_Btn_D,item=ZhenShou_HuoDong_Item3,},
	}
	
end

--================================================
-- 恢复界面的默认相对位置
--================================================
function ZhenShou_HuoDong_ResetPos()
	ZhenShou_HuoDong_Frame:SetProperty("UnifiedPosition", g_Frame_UnifiedPosition);
end

--================================================
-- OnEvent()
--================================================
function ZhenShou_HuoDong_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == 89306903 ) then
		local objid = Get_XParam_INT(0)
		if objid == nil or objid < 0 then
			-- 关闭界面
			if this:IsVisible() then
				ZhenShou_HuoDong_Close()
			end
		else
			-- 关注npc
			npcObjId = objid
			objCared = DataPool : GetNPCIDByServerID(tonumber(objid))
			this:CareObject(objCared, 1, "ZhenShou_HuoDong")
			local bUpdate = Get_XParam_INT(1)
			local nData = Get_XParam_INT(2)
			local bFlag1 = Get_XParam_INT(3)
			local bFlag2 = Get_XParam_INT(4)
			local bFlag3 = Get_XParam_INT(5)
			if bUpdate == 1 then--仅刷新
				if this:IsVisible() then
					ZhenShou_HuoDong_Update(nData,bFlag1,bFlag2,bFlag3)
				end
			else--打开+刷新
				-- 打开界面
				this:Show()
				ZhenShou_HuoDong_Update(nData,bFlag1,bFlag2,bFlag3)
			end
		end
	-- 游戏窗口尺寸发生了变化
	elseif (event == "ADJEST_UI_POS" ) then
		ZhenShou_HuoDong_ResetPos()
	-- 游戏分辨率发生了变化
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		ZhenShou_HuoDong_ResetPos()
	elseif (event == "PLAYER_LEAVE_WORLD" and this:IsVisible()) then
		ZhenShou_HuoDong_Close()
	elseif ( event == "OBJECT_CARED_EVENT" ) then
		if(tonumber(arg0) ~= objCared) then
			return
		end
		-- 如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			-- 关闭界面
			ZhenShou_HuoDong_Close()
		end
	end
end

--================================================
-- OnHiden()
--================================================
function ZhenShou_HuoDong_OnHiden()
	-- 取消关心
	this:CareObject(objCared, 0, "ZhenShou_HuoDong")
	npcObjId = -1
end

--================================================
-- 关闭界面
--================================================
function ZhenShou_HuoDong_Close()
	ZhenShou_HuoDong_OnHiden()
	this:Hide()
end

--================================================
-- 更新界面
--================================================
function ZhenShou_HuoDong_Update(nData,bFlag1,bFlag2,bFlag3)
	if nData == nil or nData < 0 then return end
	--显示进度
	ZhenShou_HuoDong_Num:SetText( ScriptGlobal_Format("#{ZSYR_211227_25}",nData) )
	--显示任务
	local bFlag = {bFlag1,bFlag2,bFlag3}--完成标记
	for i=1,table.getn(g_CtrlList) do
		--奖励显示
		local theAction = DataPool:CreateActionItemForShow(g_ItemList[i], 1)
		if theAction:GetID() ~= 0 then
			g_CtrlList[i].item:SetActionItem(theAction:GetID())
		end
		--背景显示
		if i <= nData then--已开启
			g_CtrlList[i].bk1:Show()
			g_CtrlList[i].bk2:Hide()
			if bFlag[i] > 0 then--已完成
				g_CtrlList[i].btn:Hide()
				g_CtrlList[i].finish:Show()
			else--未完成
				g_CtrlList[i].btn:Show()
				g_CtrlList[i].finish:Hide()
			end
		else--未开启
			g_CtrlList[i].bk1:Hide()
			g_CtrlList[i].bk2:Show()
		end
	end	
end

--================================================
-- 点击寻找珍兽
--================================================
function ZhenShou_HuoDong_BtnClicked()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnAccept")
		Set_XSCRIPT_ScriptID(893065)
		Set_XSCRIPT_Parameter(0,npcObjId)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
end

--================================================
-- 点击接取任务
--================================================
function ZhenShou_HuoDong_Clicked(nIndex)
	if nIndex == 1 then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("OnAccept")
			Set_XSCRIPT_ScriptID(893066)
			Set_XSCRIPT_Parameter(0,npcObjId)
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
	elseif nIndex == 2 then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("OnAccept")
			Set_XSCRIPT_ScriptID(893067)
			Set_XSCRIPT_Parameter(0,npcObjId)
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
	elseif nIndex == 3 then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("OnAccept")
			Set_XSCRIPT_ScriptID(893068)
			Set_XSCRIPT_Parameter(0,npcObjId)
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
	end
end
