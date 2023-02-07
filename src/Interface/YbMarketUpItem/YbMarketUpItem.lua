local m_Item_Idx = -1
-----------------------------------------------------------------------
-- OnGameEvent
-----------------------------------------------------------------------

function YbMarketUpItem_PreLoad()
	this:RegisterEvent("OPEN_UP_ITEM");
	this:RegisterEvent("CLOSE_UP_ITEM");
	this:RegisterEvent("UPDATE_UP_ITEM")
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")
	this:RegisterEvent("UP_AUCTION_SUCCEED")
	
end

function YbMarketUpItem_OnLoad()
	
end



function YbMarketUpItem_OnEvent(event)
	if event == "OPEN_UP_ITEM"  then
		if this:IsVisible() then
			return
		end
		YbMarketUpItem_Update(-1)
		this:Show()
	elseif event == "UPDATE_UP_ITEM" and this:IsVisible() then
		if arg0 ~= nil then
			YbMarketUpItem_Update( tonumber(arg0) )
		end
	
	elseif (event == "PACKAGE_ITEM_CHANGED" and this:IsVisible()) then
		if arg0 ~= nil and tonumber(arg0) == m_Item_Idx then
			YbMarketUpItem_Update(m_Item_Idx)
		end 
	elseif event == "CLOSE_UP_ITEM" and this:IsVisible() then
		this:Hide()
	elseif (event == "UP_AUCTION_SUCCEED" ) then
		YbMarketUpItem_Moral_Value:SetText("")
	end
end

----------------------------------------------------------------------
-- on events
-----------------------------------------------------------------------

function YbMarketUpItem_OK_Clicked()
	local price = YbMarketUpItem_Moral_Value:GetText()
	if m_Item_Idx ~= -1 and price ~= "" and tonumber(price) > 0 then
		--安全时间
		if tonumber(DataPool:GetLeftProtectTime()) > 0 then
			PushDebugMessage("#{OR_PILFER_LOCK_FLAG}")
			return
		end
		--小于30级
		if  Player:GetData("LEVEL") < 30 then
			PushDebugMessage("#{YBSC_100111_42}")
			return
		end

		--不是元宝商品
		if  PlayerPackage:IsYubaoTradeItem(m_Item_Idx) ~= 1 then
			PushDebugMessage("#{YBSC_100111_05}")
			return
		end
		--是贵重物品
		if PlayerPackage:IsProtectGoods(m_Item_Idx) == 1 then
			PushDebugMessage("#{YBSC_100111_07}")
			return
		end
		--绑定了
		local isBind = GetItemBindStatus(m_Item_Idx)
		if isBind ~= nil and isBind == 1 then
			PushDebugMessage("#{YBSC_100111_46}")
			return
		end
		--输入价格过高
		if tonumber(price) > 200000 then
			PushDebugMessage("#{YBSC_100111_54}")
			return
		end
		if tonumber(price) < 2 then
			PushDebugMessage("#{YBSC_100111_53}")
			return
		end		
		
	--	local nNum = PlayerPackage:GetBagItemNum(m_Item_Idx)
		local nMoney = Auction:GetNeedMoneyForSell(tonumber(price))
	--	local totalNeedMoney = nMoney * nNum
		local myMoney = Player:GetData("MONEY_JZ") + Player:GetData("MONEY")
		if myMoney < nMoney then
			PushDebugMessage("#{YBSC_100111_09}")
			return
		end
		Auction:PacketSend_SellItem(m_Item_Idx , tonumber(price) ,0)
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
	LifeAbility : Lock_Packet_Item(m_Item_Idx,0);		
	m_Item_Idx = -1;
	YbMarketUpItem_Moral_Value:SetText("")
	YbMarketUpItem_OK:Disable()
	YbMarketUpItem_NeedMoney:SetProperty("MoneyNumber", "0");
	if(IsWindowShow("Packet")) then
		CloseWindow("Packet", true);
	end 
end
-----------------------------------------------------------------------
--private function
-----------------------------------------------------------------------
function YbMarketUpItem_Update(itemIdx)
	
	local theAction = EnumAction(itemIdx, "packageitem");
	if theAction:GetID() ~= 0 then
		
		if PlayerPackage:IsLock( itemIdx ) == 1 then
			PushDebugMessage("物品已加锁")	--道具已上锁
			return
		end
			
		if m_Item_Idx ~= -1 then
			LifeAbility : Lock_Packet_Item(m_Item_Idx,0);
		end
		
		YbMarketUpItem_Object:SetActionItem(theAction:GetID());
		LifeAbility : Lock_Packet_Item(itemIdx,1);
		m_Item_Idx = itemIdx
	else
		YbMarketUpItem_Object:SetActionItem(-1);			
		LifeAbility : Lock_Packet_Item(m_Item_Idx,0);		
		m_Item_Idx = -1;
	end
	YbMarketUpItem_Refresh_Bn_and_Money()
end


function YbMarketUpItem_Refresh_Bn_and_Money()
	local price = YbMarketUpItem_Moral_Value:GetText()
	if m_Item_Idx ~= -1 and price ~= "" and tonumber(price) > 0 then
		YbMarketUpItem_OK:Enable()
	--	local nNum = PlayerPackage:GetBagItemNum(m_Item_Idx)
		local nMoney = Auction:GetNeedMoneyForSell(tonumber(price))
		YbMarketUpItem_NeedMoney:SetProperty("MoneyNumber", tostring(nMoney));
	else
		YbMarketUpItem_NeedMoney:SetProperty("MoneyNumber", "0");
		YbMarketUpItem_OK:Disable()
	end
end

