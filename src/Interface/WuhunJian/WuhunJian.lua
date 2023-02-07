--!!!reloadscript =WuhuJian
--极致Q546528533 仅供娱乐交流 切勿商用
local g_WuhunJian_UnifiedPosition = ""
local g_MaxBarNum = 100

local g_BarList = {}

local g_InitList = 0
local g_CurrentSelWG = 1

local g_NeedChangeScrollSize = 0

local g_CurrentSlot = 0
local g_CurrentGrade = 0
local g_HuanHunLevel = 1
local g_HuanHunType = 1
local WuhunJian_TupuItem = {}
local WuhunJian_RightItem_Mask = {}
function WuhunJian_PreLoad()

	this:RegisterEvent("OPEN_WHWG")
	this:RegisterEvent("XINGZHEN_UPDATE", false)
	--离开场景，自动关闭
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED", false)
	--更新装备
	this:RegisterEvent("ADJEST_UI_POS", false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED", false)
	this:RegisterEvent("UI_COMMAND")

end

function WuhunJian_OnLoad()	
	g_WuhunJian_UnifiedPosition = WuhunJian_Frame:GetProperty("UnifiedPosition")
	WuhunJian_TupuItem[1] = WuhunJian_TupuItem_1
	WuhunJian_TupuItem[2] = WuhunJian_TupuItem_2
	WuhunJian_TupuItem[3] = WuhunJian_TupuItem_3
	WuhunJian_TupuItem[4] = WuhunJian_TupuItem_4
	WuhunJian_TupuItem[5] = WuhunJian_TupuItem_5
	WuhunJian_TupuItem[6] = WuhunJian_TupuItem_6

	WuhunJian_RightItem_Mask[1] = WuhunJian_Item_Mask_1
	WuhunJian_RightItem_Mask[2] = WuhunJian_Item_Mask_2
	WuhunJian_RightItem_Mask[3] = WuhunJian_Item_Mask_3
	WuhunJian_RightItem_Mask[4] = WuhunJian_Item_Mask_4
	WuhunJian_RightItem_Mask[5] = WuhunJian_Item_Mask_5
	WuhunJian_RightItem_Mask[6] = WuhunJian_Item_Mask_6
end

function WuhunJian_OnEvent(event)
	
	if event == "UI_COMMAND" and tonumber(arg0) == 202104151 then
			if(IsWindowShow("Ride")) then
				CloseWindow("Ride", true);
			end	
		PushEvent("REFRESH_EQUIP")
		WuhunJian_FakeObject:SetFakeObject("")
		this:Show()
		g_CurrentSelWG = 1
		g_CurrentGrade = 1
		g_CurrentSlot = 0
		g_NeedChangeScrollSize = 1
		WuhunJian_Update()		
	end

	if event == "HIDE_ON_SCENE_TRANSED" then
		this:Hide()
		return
	end
	
	if event == "CLOSE_XINGZHENUI_GROUP" then
		this:Hide()
		return
	end

	if event == "XINGZHEN_UPDATE"  and this:IsVisible() then
		Variable:SetVariable("RuneStarPos", WuhunJian_Frame:GetProperty("UnifiedPosition"), 1)
		WuhunJian_Update()
		return
	end
	
	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		WuhunJian_On_ResetPos()
	end
end

function WuhunJian_InitListBar()	
	if g_InitList == 0 then		
		g_MaxBarNum = 6
		for i = 1, g_MaxBarNum do
			-- local bar = WuhunJian_RightItem_Lace:AddChild("WuhunJian_RightItemBK")
			-- bar:SetProperty("SuperBarButtonHover","SuperBarHoverSection")
			-- g_BarList[i] = bar	
			-- bar:GetSubItem("WuhunJian_RightItem"):SetEvent("MouseLButtonDown", string.format("WuhunJian_ItemClicked(%d)", i))
		end	
		g_InitList = 1
	end
end

--刷新
function WuhunJian_Update()	
	--图标显示
	for i = 1,6 do
		local wgID = LuaFnGetWHWGIDFromList(i)
		local theAction = GemMelting:UpdateProductAction(wgID)
		if theAction:GetID() ~= 0 then
			WuhunJian_TupuItem[i]:SetActionItem(theAction:GetID())
		end		
	end
	WuhunJian_InitListBar()
	
	WuhunJian_ListCleanUpAction()
	-- DataPool:LuaFnInitWHWGList()
	local nCount = 6
	
	for i = 1, g_MaxBarNum do
		WuhunJian_SetItem(i, nCount)
		local nUnLocked = LuaFnGetWHWGInfo(i, "UnLocked")
		if nUnLocked == 1 then
			WuhunJian_RightItem_Mask[i]:Hide()
		else
			WuhunJian_RightItem_Mask[i]:Show()
		end		
	end
	
	if g_NeedChangeScrollSize == 1 then		
	--	WuhunJian_RightItem_Lace:RefreshLayout()
		-- WuhunJian_RightItem_Lace:SetScrollPosition(0)
		g_NeedChangeScrollSize = 0
	end
	--默认第一个
	WuhunJian_UpdateSel()
end

function WuhunJian_UpdateSel()
	local wgID = LuaFnGetWHWGIDFromListEx(g_CurrentSelWG,"init",g_HuanHunType,g_HuanHunLevel)
	-- PushDebugMessage(wgID)
	WuhunJian_FakeObject:SetFakeObject("")
	Player:SetHorseModel(wgID);
	WuhunJian_FakeObject:SetFakeObject("My_Horse")	
	WuhunJian_UpdateButtonCheck()
end

function WuhunJian_SetItem(idx, max_count)

	if g_BarList[idx] == nil then
		return
	end
	
	if idx > max_count then
		g_BarList[idx]:Hide()
		return
	end
	
	local bar = g_BarList[idx]
	bar:Show()
	
	local wgID = LuaFnGetWHWGIDFromList(idx)
	local nUnLocked = LuaFnGetWHWGInfo(wgID, "UnLocked")
	local nLevel =LuaFnGetWHWGInfo(wgID, "Level")
	local nGrade = LuaFnGetWHWGInfo(wgID, "Grade")
	local strName = LuaFnGetWHWGInfo(wgID, "Name")
	
	--激活锁
	if nUnLocked == 1 then
		WuhunJian_RightItem_Mask[idx]:Hide()
	else
		WuhunJian_RightItem_Mask[idx]:Show()
	end

	-- local ctrlAction = bar:GetSubItem("WuhunJian_RightItem")
	if ctrlAction ~= nil then

		ctrlAction:SetActionItem(-1)
		
		-- local theAction = EnumAction(wgID, "whwg")
		if theAction:GetID() ~= 0 then
			ctrlAction:SetActionItem(theAction:GetID())
		end
	
		ctrlAction:SetProperty("DraggingEnabled", "False")
		
		-- if g_CurrentSelWG == 0 then
			-- g_CurrentSelWG = wgID
		-- end
		
		if wgID == g_CurrentSelWG then
			ctrlAction:SetPushed(1)
		else
			ctrlAction:SetPushed(0)
		end
	end
end

function WuhunJian_ItemClicked(nIndex)
	
	for i = 1, g_MaxBarNum do		
		if i == nIndex then
			WuhunJian_TupuItem[i]:SetPushed(1)
		else
			WuhunJian_TupuItem[i]:SetPushed(0)	
		end
	end
	g_CurrentSelWG = nIndex
	-- local nModel = LuaFnGetWHWGInfo(g_CurrentSelWG, "Model", g_CurrentGrade, g_CurrentSlot)
	WuhunJian_UpdateSel()
	
end

function WuhunJian_Model_TurnLeft(start)
	--start
	if start == 1 and CEArg:GetValue("MouseButton") == "LeftButton" then
		WuhunJian_FakeObject:RotateBegin(-0.3)
	--stop
	else
		WuhunJian_FakeObject:RotateEnd()
	end
end

function WuhunJian_Model_TurnRight(start)
	--start
	if start == 1 and CEArg:GetValue("MouseButton") == "LeftButton" then
		WuhunJian_FakeObject:RotateBegin(0.3)
	--stop
	else
		WuhunJian_FakeObject:RotateEnd()
	end
end

function WuhunJian_ChangeView(slot, grade)
	g_HuanHunLevel = grade
	g_HuanHunType = slot
	WuhunJian_UpdateSel()
end

function WuhunJian_DoCancel()
	WuhunJian_OnCloseClicked()
end

function WuhunJian_OnCloseClicked()
	WuhunJian_FakeObject:SetFakeObject("")
	this:Hide()
end

function WuhunJian_OnHidden()
	WuhunJian_ListCleanUpAction()
	WuhunJian_OnCloseClicked()
end

function WuhunJian_ListCleanUpAction()
	WuhunJian_FakeObject:SetFakeObject("")
	for i = 1, g_MaxBarNum do
		if ctrlAction then
			ctrlAction:SetActionItem(-1)
		end
	end
end

function WuhunJian_On_ResetPos()
	if g_WuhunJian_UnifiedPosition ~= nil then
		WuhunJian_Frame:SetProperty("UnifiedPosition", g_WuhunJian_UnifiedPosition)
	end
end

function WuhunJian_UpdateButtonCheck()
	WuhunJian_Right_Set2_Button1:SetCheck(0)
	WuhunJian_Right_Set2_Button2:SetCheck(0)
	WuhunJian_Right_Set2_Button3:SetCheck(0)
	
	WuhunJian_Right_Set3_Button1:SetCheck(0)
	WuhunJian_Right_Set3_Button2:SetCheck(0)
	WuhunJian_Right_Set3_Button3:SetCheck(0)
	
	if g_CurrentSlot == 0 then
		if g_CurrentGrade == 1 then
			WuhunJian_Right_Set2_Button1:SetCheck(1)
		elseif g_CurrentGrade == 5 then
			WuhunJian_Right_Set2_Button2:SetCheck(1)
		elseif g_CurrentGrade == 8 then
			WuhunJian_Right_Set2_Button3:SetCheck(1)
		end	
	else
		if g_CurrentGrade == 1 then
			WuhunJian_Right_Set3_Button1:SetCheck(1)
		elseif g_CurrentGrade == 5 then
			WuhunJian_Right_Set3_Button2:SetCheck(1)
		elseif g_CurrentGrade == 8 then
			WuhunJian_Right_Set3_Button3:SetCheck(1)
		end
	end	
end


--!!!reloadscript =WuhuJian
