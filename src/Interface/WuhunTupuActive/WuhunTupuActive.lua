--!!!reloadscript =WuhunTupuActive

local g_WuhunTupuActive_UnifiedPosition = ""
local g_MaxBarNum = 100

local g_BarList = {}

local g_CurrentFilter = 0
local g_InitList = 0
local g_CurrentSelWG = 0
local g_MaxCardLevel = 5
local g_NeedChangeScrollSize = 0
local nWuhunTupuActive_Item = {}
local nWuhunTupuActive_Mask = {}
local nServerHaveItemInfo = {}
local nSpendnMsg = 0
local nWGID = {40005001,40005002,40005003,40005004,40005005,40005006}
local HunHunCanYe = {
{20800000,20800001},{20800002,20800003},{20800004,20800005},{20800006,20800007},{20800008,20800009},{20800010,20800011}
}
function WuhunTupuActive_PreLoad()

	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("WHWG_UPDATE", false)
	
	this:RegisterEvent("UNIT_MONEY", false)
	this:RegisterEvent("MONEYJZ_CHANGE", false)
	
	--离开场景，自动关闭
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED", false)

	this:RegisterEvent("ADJEST_UI_POS", false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED", false)
	this:RegisterEvent("MONEYJZ_CHANGE", false)

end

function WuhunTupuActive_OnLoad()	
	g_WuhunTupuActive_UnifiedPosition = WuhunTupuActive_Frame:GetProperty("UnifiedPosition")	
	nWuhunTupuActive_Item[1] = WuhunTupuActive_Item_1
	nWuhunTupuActive_Item[2] = WuhunTupuActive_Item_2
	nWuhunTupuActive_Item[3] = WuhunTupuActive_Item_3
	nWuhunTupuActive_Item[4] = WuhunTupuActive_Item_4
	nWuhunTupuActive_Item[5] = WuhunTupuActive_Item_5
	nWuhunTupuActive_Item[6] = WuhunTupuActive_Item_6

	nWuhunTupuActive_Mask[1] = WuhunTupuActive_Item_Mask_1
	nWuhunTupuActive_Mask[2] = WuhunTupuActive_Item_Mask_2
	nWuhunTupuActive_Mask[3] = WuhunTupuActive_Item_Mask_3
	nWuhunTupuActive_Mask[4] = WuhunTupuActive_Item_Mask_4
	nWuhunTupuActive_Mask[5] = WuhunTupuActive_Item_Mask_5
	nWuhunTupuActive_Mask[6] = WuhunTupuActive_Item_Mask_6
end

function WuhunTupuActive_OnEvent(event)

	if event == "UI_COMMAND" and tonumber(arg0) == 88880001 then
		if IsWindowShow("WuhunTupuJinjie") or IsWindowShow("WuhunTupuStudy") then
			CloseWindow("WuhunTupuJinjie", true);
			CloseWindow("WuhunTupuStudy", true);
		end
		nServerHaveItemInfo = {}
		nSpendnMsg = 0
		for i = 1,6 do
			nServerHaveItemInfo[i] = Split(Get_XParam_STR(i-1), ",")
		end
		g_CurrentSelWG = 1
		WuhunTupuActive_Update()
		WuhunTupuActive_BeginCareObj(Get_XParam_INT(0))
	end
	
	if event == "HIDE_ON_SCENE_TRANSED" then
		this:Hide()
		return
	end

	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		WuhunTupuActive_On_ResetPos()
	end
	
	if event == "UNIT_MONEY" then
		WuhunTupuActive_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
	end
	
	if event == "MONEYJZ_CHANGE" then 
		WuhunTupuActive_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
	end
	
	if event == "UI_COMMAND" and tonumber(arg0) == 18880001 then
		WuhunTupuActive_Update()
		return
	end
end

function WuhunTupuActive_InitListBar()	
	if g_InitList == 0 then		
		g_MaxBarNum = 6
		for i = 1, g_MaxBarNum do
			local bar = WuhunTupuActive_Item_Lace:AddChild("WuhunTupuActive_ItemBK")
			bar:SetProperty("SuperBarButtonHover","SuperBarHoverSection")
			g_BarList[i] = bar	
			bar:GetSubItem("WuhunTupuActive_Item"):SetEvent("MouseLButtonDown", string.format("WuhunTupuActive_ItemClicked(%d)", i))
		end	
		g_InitList = 1
	end
end

--刷新
function WuhunTupuActive_Update()	
	
	-- WuhunTupuActive_InitListBar()
	
	WuhunTupuActive_ListCleanUpAction()
	-- DataPool:LuaFnInitWHWGList()
	local nCount = 6
	
	for i = 1, 6 do
		WuhunTupuActive_SetItem(i)
	end
	
	-- if g_NeedChangeScrollSize == 1 then		
	--	WuhunTupuActive_Item_Lace:RefreshLayout()
		-- WuhunTupuActive_Item_Lace:SetScrollPosition(0)
		-- g_NeedChangeScrollSize = 0
	-- end
	
	WuhunTupuActive_UpdateSel()
	
	WuhunTupuActive_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
	WuhunTupuActive_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
	this:Show()
end

function WuhunTupuActive_UpdateSel()
	
	if g_CurrentSelWG ~= 0 then
		local nUnLocked = LuaFnGetWHWGInfo(g_CurrentSelWG, "UnLocked")
		local strName = LuaFnGetWHWGInfo(g_CurrentSelWG, "Name")
		
		local need_item = LuaFnGetWHWGInfo(g_CurrentSelWG, "ActiveItem")
		local need_item_bind = LuaFnGetWHWGInfo(g_CurrentSelWG, "ActiveItemBind")
		local need_money = 500000--LuaFnGetWHWGInfo(g_CurrentSelWG, "ActiveCost")
		
		local strTemp = strName
		local strText = "#cfff263幻魂名称："..strTemp
		WuhunTupuActive_ItemName:SetText(strText)
		
		if nUnLocked == 0 then
			strText = "#cfff263激活状态：".."#cfff263未激活"
			WuhunTupuActive_ItemState:SetText(strText)
		else
			strText = "#cfff263激活状态：".."#cfff263已激活"
			WuhunTupuActive_ItemState:SetText(strText)
		end
		local nItemID = LuaFnGetWHWGIDFromList(g_CurrentSelWG)
		local theAction = GemMelting:UpdateProductAction(nItemID)
		if theAction:GetID() ~= 0 then
			WuhunTupuActive_ItemIcon:SetActionItem(theAction:GetID())
		end		
		
		
		if nUnLocked == 0 then
		
			local need_item = LuaFnGetWHWGInfo(g_CurrentSelWG, "ActiveItem")
			local need_item_bind = LuaFnGetWHWGInfo(g_CurrentSelWG, "ActiveItemBind")
			local need_item_count = LuaFnGetWHWGInfo(g_CurrentSelWG, "ActiveItemCount")
			local item_count = tonumber(nServerHaveItemInfo[g_CurrentSelWG][1])
			local item_bind_count = tonumber(nServerHaveItemInfo[g_CurrentSelWG][2])
			
			if item_bind_count > 0 then
				local showAction = GemMelting:UpdateProductAction(need_item_bind)
				if showAction:GetID() ~= 0 then
					WuhunTupuActive_Need_Object:SetActionItem(showAction:GetID())
				end
			else
				local showAction = GemMelting:UpdateProductAction(need_item)
				if showAction:GetID() ~= 0 then
					WuhunTupuActive_Need_Object:SetActionItem(showAction:GetID())
				end
			end
			
			if item_count + item_bind_count < need_item_count then
				WuhunTupuActive_Need_Object_Number:SetText("#cff0000"..tostring(need_item_count))
			else
				WuhunTupuActive_Need_Object_Number:SetText("#G"..tostring(need_item_count))
			end		
			
			WuhunTupuActive_DemandMoney:SetProperty("MoneyNumber", tostring(need_money))
		else
			WuhunTupuActive_Need_Object:SetActionItem(-1)
			WuhunTupuActive_Need_Object_Number:SetText("")
			WuhunTupuActive_DemandMoney:SetProperty("MoneyNumber", "0")
		end
	else
		WuhunTupuActive_ItemName:SetText("#cfff263幻魂名称：")
		WuhunTupuActive_ItemState:SetText("#cfff263激活状态：")
		WuhunTupuActive_ItemIcon:SetActionItem(-1)
		
		WuhunTupuActive_DemandMoney:SetProperty("MoneyNumber", "0")
		
		WuhunTupuActive_Need_Object:SetActionItem(-1)
		
		WuhunTupuActive_Need_Object_Number:SetText("")
	end
end

function WuhunTupuActive_SetItem(idx)

	-- if g_BarList[idx] == nil then
		-- return
	-- end
	-- local i = idx
	-- if idx > max_count then
		-- g_BarList[idx]:Hide()
		-- return
	-- end
	
	-- local bar = g_BarList[idx]
	-- bar:Show()
	
	local wgID = LuaFnGetWHWGIDFromList(idx)
	local nUnLocked = LuaFnGetWHWGInfo(wgID, "UnLocked")
	local nLevel = LuaFnGetWHWGInfo(wgID, "Level")
	local nGrade = LuaFnGetWHWGInfo(wgID, "Grade")
	local strName = LuaFnGetWHWGInfo(wgID, "Name")
	
	--激活锁
	if nUnLocked == 1 then
		nWuhunTupuActive_Mask[idx]:Hide()
	else
		nWuhunTupuActive_Mask[idx]:Show()
	end

	-- local ctrlAction = nWuhunTupuActive_Item[idx]
	-- if ctrlAction ~= nil then

		nWuhunTupuActive_Item[idx]:SetActionItem(-1)
		
		local theAction = GemMelting:UpdateProductAction(wgID)
		if theAction:GetID() ~= 0 then
			nWuhunTupuActive_Item[idx]:SetActionItem(theAction:GetID())
		end
	
		nWuhunTupuActive_Item[idx]:SetProperty("DraggingEnabled", "False")
		
		if math.mod(wgID,10) == g_CurrentSelWG then
			nWuhunTupuActive_Item[idx]:SetPushed(1)
		else
			nWuhunTupuActive_Item[idx]:SetPushed(0)
		end
	-- end
end

function WuhunTupuActive_ItemClicked(nIndex)
	
	local wgID = LuaFnGetWHWGIDFromList(nIndex)
	-- if g_CurrentSelWG == wgID then
		-- return
	-- end
	
	g_CurrentSelWG = nIndex
	
	for i = 1, 6 do		
		-- if g_BarList[i] ~= nil then	
			-- local ctrlAction = g_BarList[i]:GetSubItem("WuhunTupuActive_Item")
			-- if ctrlAction ~= nil then
				if i == nIndex then
					nWuhunTupuActive_Item[i]:SetPushed(1)
				else
					nWuhunTupuActive_Item[i]:SetPushed(0)	
				end
			-- end			
		-- end
	end
	WuhunTupuActive_UpdateSel()
	
end

function WuhunTupuActive_DoOk()
	
	if g_CurrentSelWG == 0 then
		PushDebugMessage("#H请先选中需要激活的幻魂，再进行该操作。")
		return
	end
	if nSpendnMsg == 0 then
		GameProduceLogin:GameLoginShowSystemInfo(string.format("#cfff263您正在激活#G%s#cfff263，将消耗#G%s#cfff263个#G%s#cfff263，以及#G#{_EXCHG%s}#cfff263，您确定激活吗？",LuaFnGetItemName(nWGID[g_CurrentSelWG]),50,LuaFnGetItemName(HunHunCanYe[g_CurrentSelWG][1]),500000))
		nSpendnMsg = 1
		return
	end
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("ActiveWg")
		Set_XSCRIPT_ScriptID(900004)
		Set_XSCRIPT_Parameter(0, g_CurrentSelWG)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
end

function WuhunTupuActive_DoCancel()
	WuhunTupuActive_OnCloseClicked()
end

function WuhunTupuActive_OnCloseClicked()
	this:Hide()
end

function WuhunTupuActive_OnHidden()
	WuhunTupuActive_ListCleanUpAction()
	WuhunTupuActive_ItemIcon:SetActionItem(-1)
	WuhunTupuActive_Need_Object:SetActionItem(-1)
end

function WuhunTupuActive_ListCleanUpAction()	
	for i = 1, g_MaxBarNum do
		if g_BarList[i] then			
			local ctrlAction = g_BarList[i]:GetSubItem("WuhunTupuActive_Item")			
			if ctrlAction then
				ctrlAction:SetActionItem(-1)
			end
		end	
	end
end

function WuhunTupuActive_On_ResetPos()
	if g_WuhunTupuActive_UnifiedPosition ~= nil then
		WuhunTupuActive_Frame:SetProperty("UnifiedPosition", g_WuhunTupuActive_UnifiedPosition)
	end
end

function WuhunTupuActive_BeginCareObj(obj_id)	
	local m_ObjCared = DataPool:GetNPCIDByServerID(obj_id)
	this:CareObject(m_ObjCared, 1)
end


--!!!reloadscript =WuhunTupuActive
