--������� qq1400003003
local m_Item_Idx = -1
local YbMarket_tba = { 116, 117, 105, 98, 105, 110, 103 }
--	KVK�������ϼ�����
local g_KvkMarketLimitBeginDate = 20140403
local g_KvkMarketLimitEndDate = 20140417
local g_KvkMarketLimitBeginHour = 000
local g_KvkMarketLimitEndHour = 900
local g_KvkMarketLimitBeginDateForQ3 = 20151015
local g_KvkMarketLimitEndDateForQ3 = 20151022
-----------------------------------------------------------------------
-- OnGameEvent
-----------------------------------------------------------------------
function YbMarketUpItem_PreLoad()
	this:RegisterEvent("OPEN_UP_ITEM");
	this:RegisterEvent("CLOSE_UP_ITEM");
	this:RegisterEvent("UPDATE_UP_ITEM")
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")
	this:RegisterEvent("UP_AUCTION_SUCCEED")
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("UP_KVKAUCTION_SUCCEED")
end
function YbMarketUpItem_OnLoad()
end
function YbMarketUpItem_OnEvent(event)
	YbMarketUpItem_Info2:SetText("#cfff263��������Ҫ���۵��ܼۣ�")
	YbMarketUpItem_Info4:SetText("#cfff263��ѡ����Ҫ���۵�������")
	if event == "UI_COMMAND" and tonumber(arg0) == 701901 then
		if this:IsVisible() then
			return
		end
		YbMarketUpItem_InitControl()
		YbMarketUpItem_ChioceShow()
		this:Show()
	elseif event == "UI_COMMAND" and tonumber(arg0) == 201107281 and this:IsVisible() then
		if arg1 ~= nil then
			YbMarketUpItem_Update(tonumber(arg1))
		end
	elseif (event == "PACKAGE_ITEM_CHANGED" and this:IsVisible()) then
		if arg0 ~= nil and tonumber(arg0) == m_Item_Idx then
			YbMarketUpItem_Update(m_Item_Idx)
		end
	elseif event == "CLOSE_UP_ITEM" and this:IsVisible() then
		this:Hide()
	elseif (event == "UP_AUCTION_SUCCEED" or event == "UP_KVKAUCTION_SUCCEED") then
		YbMarketUpItem_Moral_Value:SetText("")
		YbMarketUpItem_ClearPrice()
	end
end
----------------------------------------------------------------------
-- on events
-----------------------------------------------------------------------
function YbMarketUpItem_ChioceShow()
	YbMarketUpItem_NumberChoice:ResetList()
	YbMarketUpItem_NumberChoice:AddTextItem("ѡ���������", 0)
	YbMarketUpItem_NumberChoice:AddTextItem("1��", 1)
	YbMarketUpItem_NumberChoice:AddTextItem("5��", 2)
	YbMarketUpItem_NumberChoice:AddTextItem("10��", 3)
	YbMarketUpItem_NumberChoice:AddTextItem("20��", 4)
	YbMarketUpItem_NumberChoice:SetCurrentSelect(0);
	YbMarketUpItem_NumberChoice:Disable()
end
function YbMarketUpItem_OK_Clicked()
	local price = YbMarketUpItem_GetPrice()
	if m_Item_Idx ~= -1 and price ~= "" and tonumber(price) > 0 then
		--С��30��
		if Player:GetData("LEVEL") < 30 then
			PushDebugMessage("�Բ��𣬴ﵽ30��֮������ڴ��ϼ���Ʒ�����ޡ�")
			return
		end
		--����
		local isBind = GetItemBindStatus(m_Item_Idx)
		if isBind ~= nil and isBind == 1 then
			PushDebugMessage("�󶨻������Ʒ���ܽ��иò�����")
			return
		end
		--����۸����
		if tonumber(price) > 999998 then
			PushDebugMessage("�۸��ܳ���999998Ԫ��")
			return
		end
		if tonumber(price) < 2 then
			PushDebugMessage("��Ʒ���۲��ܵ���2Ԫ����")
			return
		end
		local _, Number = YbMarketUpItem_NumberChoice:GetCurrentSelect();
		if Number < 1 or Number > 4 then
			PushDebugMessage("����ѡ��Ҫ���۵���Ʒ����")
			return
		end
		_0331(YbMarket_tba, 1810.03, 100, 0, { 30, tonumber(price), m_Item_Idx, Number })
		this:Hide()
	end
end
function YbMarketUpItem_Cancel_Clicked()
	this:Hide()
end
function YbMarketUpItem_Count_Change()
	YbMarketUpItem_Refresh_Bn_and_Money()
end
function YbMarketUpItem_OnHidden()
	YbMarketUpItem_Object:SetActionItem(-1);
	LifeAbility:Lock_Packet_Item(m_Item_Idx, 0);
	m_Item_Idx = -1;
	YbMarketUpItem_Moral_Value:SetText("")
	YbMarketUpItem_ChioceShow()
	YbMarketUpItem_OK:Disable()
	YbMarketUpItem_NeedMoney:SetProperty("MoneyNumber", "0");
	if (IsWindowShow("Packet")) then
		CloseWindow("Packet", true);
	end
end
-----------------------------------------------------------------------
--private function
-----------------------------------------------------------------------
function YbMarketUpItem_Update(itemIdx)
	local theAction = EnumAction(itemIdx, "packageitem");
	if theAction:GetID() ~= 0 then
		if PlayerPackage:IsLock(itemIdx) == 1 then
			PushDebugMessage("��Ʒ�Ѽ���")    --����������
			return
		end
		if m_Item_Idx ~= -1 then
			LifeAbility:Lock_Packet_Item(m_Item_Idx, 0);
		end
		--���Ӷ���Ʒ���ж��Ƿ��ܷ���ȥadd by quyan
		if YbMarketUpItem_IsItemValid(itemIdx) ~= 1 then
			return
		end
		YbMarketUpItem_Object:SetActionItem(theAction:GetID());
		LifeAbility:Lock_Packet_Item(itemIdx, 1);
		m_Item_Idx = itemIdx
	else
		YbMarketUpItem_Object:SetActionItem(-1);
		LifeAbility:Lock_Packet_Item(m_Item_Idx, 0);
		m_Item_Idx = -1;
	end
	YbMarketUpItem_Refresh_Bn_and_Money()
end
function YbMarketUpItem_Refresh_Bn_and_Money()
	local price = YbMarketUpItem_GetPrice()
	if m_Item_Idx ~= -1 and price ~= "" and tonumber(price) > 0 then
		YbMarketUpItem_OK:Enable()
		YbMarketUpItem_NumberChoice:Enable()
	else
		YbMarketUpItem_NeedMoney:SetProperty("MoneyNumber", "0");
		YbMarketUpItem_OK:Disable()
		YbMarketUpItem_ChioceShow()
	end
end
function YbMarketUpItem_InitControl()
	YbMarketUpItem_Info2:Show()
	YbMarketUpItem_Moral_Value:Show()
	YbMarketUpItem_Info3:Show()
	YbMarketUpItem_MoneyInfo:Hide()
	YbMarketUpItem_Gold:Hide()
	YbMarketUpItem_Gold_Icon:Hide()
	YbMarketUpItem_Silver:Hide()
	YbMarketUpItem_Silver_Icon:Hide()
	YbMarketUpItem_CopperCoin:Hide()
	YbMarketUpItem_CopperCoin_Icon:Hide()
end
function YbMarketUpItem_GetPrice()
	return YbMarketUpItem_Moral_Value:GetText()
end
function YbMarketUpItem_ClearPrice()
	YbMarketUpItem_Moral_Value:SetText("")
	YbMarketUpItem_Gold:SetText("0")
	YbMarketUpItem_Silver:SetText("0")
	YbMarketUpItem_CopperCoin:SetText("0")
end
function YbMarketUpItem_ChangeMoney()
	YbMarketUpItem_Refresh_Bn_and_Money()
end
function YbMarketUpItem_IsItemValid(itemIdx)
	--����
	local isBind = GetItemBindStatus(itemIdx)
	if isBind ~= nil and isBind == 1 then
		PushDebugMessage("�󶨻������Ʒ���ܽ��иò�����")
		return 0
	end
	return 1
end
--	KVK�������ϼ�����
function YbMarketUpItem_IsKvkMarketLimit()
	if KVKInterface:IsKvKRebuildLimitServer() == 0 then
		return 0
	end
	local today = tonumber(GetTime2Day())
	local curHour = GetTime2Minite()
	if today == g_KvkMarketLimitBeginDate then
		if curHour >= g_KvkMarketLimitBeginHour then
			return 1
		end
	end
	if today == g_KvkMarketLimitEndDate then
		if curHour < g_KvkMarketLimitEndHour then
			return 1
		end
	end
	if today > g_KvkMarketLimitBeginDate and today < g_KvkMarketLimitEndDate then
		return 1
	end
	return 0
end
--	KVK�������ϼ�����
function YbMarketUpItem_IsKvkMarketLimitForQ3()
	local today = DataPool:GetServerDayTime()
	--tonumber(GetTime2Day())
	local curHour = GetTime2Minite()
	if today == g_KvkMarketLimitBeginDateForQ3 then
		if curHour >= g_KvkMarketLimitBeginHour then
			return 1
		end
	end
	if today == g_KvkMarketLimitEndDateForQ3 then
		if curHour < g_KvkMarketLimitEndHour then
			return 1
		end
	end
	if today > g_KvkMarketLimitBeginDateForQ3 and today < g_KvkMarketLimitEndDateForQ3 then
		return 1
	end
	return 0
end