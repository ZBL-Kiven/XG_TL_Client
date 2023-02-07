
local g_Cur_Modify_Type = 0
local g_Index	= -1
local g_Old_Price	= 0
--local g_itemNum = 1
function YB_Modify_PreLoad()
	this : RegisterEvent("OPEN_CHANGE_PRICE")
end


function YB_Modify_OnLoad()

end


function YB_Modify_OnEvent(event)
	if event == "OPEN_CHANGE_PRICE"  then
		g_Cur_Modify_Type = tonumber(arg0)
		g_Index	= tonumber(arg1)
		g_Old_Price	= 0
		if g_Cur_Modify_Type == 1 then
			local pName ,nowStatus , price = Auction:GetMySellBoxPetAuctionInfo(g_Index)
			if nowStatus ~= nil and price ~= nil then
				g_Old_Price = price
			end
		--	g_itemNum = 1
		elseif g_Cur_Modify_Type == 2 then
			local pName ,nowStatus , price = Auction:GetMySellBoxItemAuctionInfo(g_Index)
			if nowStatus ~= nil and price ~= nil then
				g_Old_Price = price
			end
		--	g_itemNum = Auction:GetMySellBoxItemNum(g_Index)
		end
		YB_Modify_Edit:SetText("")
		YB_Modify_Accept:Disable()
		this:Show()
	end
end

function YB_Modify_Edit_Change()
	local price = YB_Modify_Edit:GetText()
	if price ~= "" and tonumber(price) > 0 then
		local newNeedMoney = Auction:GetNeedMoneyForSell(tonumber(price))
		local oldNeedMoney = Auction:GetNeedMoneyForSell(tonumber(g_Old_Price))
		
		if newNeedMoney > oldNeedMoney then
			YB_Modify_Money:SetProperty("MoneyNumber", tostring(newNeedMoney - oldNeedMoney));
		else
			YB_Modify_Money:SetProperty("MoneyNumber", "0");
		end
		YB_Modify_Accept:Enable()
	else
		YB_Modify_Money:SetProperty("MoneyNumber", "0");
		YB_Modify_Accept:Disable()
	end

end

function YB_Modify_Cancel_Clicked()
	YB_Modify_Clear()
	this:Hide()
end

function YB_Modify_Accept_Clicked()
	local price = YB_Modify_Edit:GetText()
	if price ~= "" and tonumber(price) > 0 then
		--安全时间
		if tonumber(DataPool:GetLeftProtectTime()) > 0 then
			PushDebugMessage("#{OR_PILFER_LOCK_FLAG}")
			return
		end
		
		if tonumber(price) > 200000 then
			PushDebugMessage("#{YBSC_100111_54}")
			return
		end
		if tonumber(price) < 2 then
			PushDebugMessage("#{YBSC_100111_53}")
			return
		end
		local newNeedMoney = Auction:GetNeedMoneyForSell(tonumber(price))
		local oldNeedMoney = Auction:GetNeedMoneyForSell(tonumber(g_Old_Price))
		local myMoney = Player:GetData("MONEY_JZ") + Player:GetData("MONEY")
		local needMoney = 0
		if newNeedMoney > oldNeedMoney then
			needMoney = newNeedMoney - oldNeedMoney
		end
		if myMoney < needMoney then
			PushDebugMessage("#{YBSC_100111_30}")
		else
			Auction:ChangePrice(g_Cur_Modify_Type ,g_Index , tonumber(price) )
			this:Hide()
		end
		
	else
		PushDebugMessage("请输入正确的价格")
	end
end

function YB_Modify_Clear()
	g_Cur_Modify_Type = 0
	g_Index	= -1
	g_Old_Price	= 0
--	g_itemNum = 1
	YB_Modify_Edit:SetText("")
	YB_Modify_Accept:Disable()
end
