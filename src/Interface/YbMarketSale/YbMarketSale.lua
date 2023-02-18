--潇湘添加1400003003
local YbMarketSale_UICommand_Id = 701902
local m_cur_sel = -1
local m_CurTab = 2
local YbMarketSale_ALLItem = {}
local YbMarketSale_ALLName = {}
local YbMarketSale_ALLPrice = {}
local YbMarketSale_ALLStatus = {}
local YbMarketSale_ALLItemInfo = {}
local YbMarketSale_g_nContentButton = {}
local YbMarketSale_Now_page = 1
local YbMarketSale_Dowbtn_page = 0
local xiaoxiang_sskjhhe = {}
local YbMarket_tba = { 84, 117, 105, 66, 105, 110, 103, 95, 65 }
-----------------------------------------------------------------------
-- OnGameEvent
-----------------------------------------------------------------------
function YbMarketSale_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OPEN_ONSALE")
	this:RegisterEvent("UPDATE_MARKET_MY_SALE")
	this:RegisterEvent("CLOSE_ONSALE")
	this:RegisterEvent("SELLBOX_REFRESH")
end
function YbMarketSale_OnLoad()
	YbMarketSale_ALLItem[1] = YbMarketSale_Item1
	YbMarketSale_ALLItem[2] = YbMarketSale_Item2
	YbMarketSale_ALLItem[3] = YbMarketSale_Item3
	YbMarketSale_ALLItem[4] = YbMarketSale_Item4
	YbMarketSale_ALLItem[5] = YbMarketSale_Item5
	YbMarketSale_ALLItem[6] = YbMarketSale_Item6
	YbMarketSale_ALLItem[7] = YbMarketSale_Item7
	YbMarketSale_ALLItem[8] = YbMarketSale_Item8
	YbMarketSale_ALLItem[9] = YbMarketSale_Item9
	YbMarketSale_ALLItem[10] = YbMarketSale_Item10
	YbMarketSale_ALLName = {
		[1] = YbMarketSale_ItemInfo1_Text,
		[2] = YbMarketSale_ItemInfo2_Text,
		[3] = YbMarketSale_ItemInfo3_Text,
		[4] = YbMarketSale_ItemInfo4_Text,
		[5] = YbMarketSale_ItemInfo5_Text,
		[6] = YbMarketSale_ItemInfo6_Text,
		[7] = YbMarketSale_ItemInfo7_Text,
		[8] = YbMarketSale_ItemInfo8_Text,
		[9] = YbMarketSale_ItemInfo9_Text,
		[10] = YbMarketSale_ItemInfo10_Text
	}
	YbMarketSale_ALLPrice = {
		[1] = YbMarketSale_ItemInfo1_GB,
		[2] = YbMarketSale_ItemInfo2_GB,
		[3] = YbMarketSale_ItemInfo3_GB,
		[4] = YbMarketSale_ItemInfo4_GB,
		[5] = YbMarketSale_ItemInfo5_GB,
		[6] = YbMarketSale_ItemInfo6_GB,
		[7] = YbMarketSale_ItemInfo7_GB,
		[8] = YbMarketSale_ItemInfo8_GB,
		[9] = YbMarketSale_ItemInfo9_GB,
		[10] = YbMarketSale_ItemInfo10_GB
	}
	YbMarketSale_ALLStatus = {
		[1] = YbMarketSale_ItemInfo1_Zhuangtai,
		[2] = YbMarketSale_ItemInfo2_Zhuangtai,
		[3] = YbMarketSale_ItemInfo3_Zhuangtai,
		[4] = YbMarketSale_ItemInfo4_Zhuangtai,
		[5] = YbMarketSale_ItemInfo5_Zhuangtai,
		[6] = YbMarketSale_ItemInfo6_Zhuangtai,
		[7] = YbMarketSale_ItemInfo7_Zhuangtai,
		[8] = YbMarketSale_ItemInfo8_Zhuangtai,
		[9] = YbMarketSale_ItemInfo9_Zhuangtai,
		[10] = YbMarketSale_ItemInfo10_Zhuangtai
	}
	YbMarketSale_ALLItemInfo = {
		[1] = YbMarketSale_ItemInfo1,
		[2] = YbMarketSale_ItemInfo2,
		[3] = YbMarketSale_ItemInfo3,
		[4] = YbMarketSale_ItemInfo4,
		[5] = YbMarketSale_ItemInfo5,
		[6] = YbMarketSale_ItemInfo6,
		[7] = YbMarketSale_ItemInfo7,
		[8] = YbMarketSale_ItemInfo8,
		[9] = YbMarketSale_ItemInfo9,
		[10] = YbMarketSale_ItemInfo10
	}
end
function YbMarketSale_OnEvent(event)
	if event == "UI_COMMAND" and tonumber(arg0) == YbMarketSale_UICommand_Id then
		if Get_XParam_STR(0) ~= nil then
			g_YB_stringR = Get_XParam_STR(0)
		else
			g_YB_stringR = ""
		end
		YbMarketSale_Dowbtn_page = tonumber(Get_XParam_INT(0))
		if YbMarketSale_Dowbtn_page == nil or YbMarketSale_Dowbtn_page < 1 then
			YbMarketSale_Dowbtn_page = 0
		end
		YbMarketSale_Now_page = tonumber(Get_XParam_INT(1))
		if YbMarketSale_Now_page == nil or YbMarketSale_Now_page < 1 then
			YbMarketSale_Now_page = 1
		end
		if YbMarketSale_Dowbtn_page <= 0 then
			YbMarketSale_btnDownPage:Disable()
		else
			YbMarketSale_btnDownPage:Enable()
		end
		if YbMarketSale_Now_page > 1 then
			YbMarketSale_btnUpPage:Enable()
		else
			YbMarketSale_btnUpPage:Disable()
		end
		YbMarketSale_g_nContentButton = {}
		if g_YB_stringR ~= nil and g_YB_stringR ~= "" then
			YbMarketSale_g_nContentButton = Split(g_YB_stringR, ",")
		end
		local itemnum = math.floor(table.getn(YbMarketSale_g_nContentButton) / 4)
		if itemnum == nil then
			itemnum = 0
		end
		if itemnum > 10 then
			itemnum = 10
		end
		for i = 1, 10 do
			xiaoxiang_sskjhhe[i] = ""
		end
		_a = 0 + 1
		if itemnum > 0 then
			local jjuk
			for i = 1, itemnum do
				jjuk = (i - 1) * 4
				if tonumber(YbMarketSale_g_nContentButton[1 + jjuk]) ~= nil then
					if tonumber(YbMarketSale_g_nContentButton[1 + jjuk]) > 10100000 then
						local PrizeAction = GemMelting:UpdateProductAction(tonumber(YbMarketSale_g_nContentButton[1 + jjuk]))
						if PrizeAction:GetID() ~= 0 then
							YbMarketSale_ALLItem[i]:SetActionItem(PrizeAction:GetID());
							YbMarketSale_ALLName[i]:SetText(PrizeAction:GetName())
							YbMarketSale_ALLStatus[i]:SetText(YbMarketSale_g_nContentButton[3 + jjuk])
							xiaoxiang_sskjhhe[_a] = YbMarketSale_g_nContentButton[3 + jjuk]
							_a = _a + 1
							YbMarketSale_ALLPrice[i]:SetText(YbMarketSale_g_nContentButton[2 + jjuk])
							if string.find(YbMarketSale_g_nContentButton[3 + jjuk], "已卖出") ~= nil then
								YbMarketSale_PutUpTheShutters:SetText("收取元宝") --取钱
							else
								YbMarketSale_PutUpTheShutters:SetText("取回商品")    --取回
							end
							YbMarketSale_PutUpTheShutters:Disable()
						end
					end
				else
					YbMarketSale_ALLItem[i]:SetActionItem(-1);
					YbMarketSale_PutUpTheShutters:Disable()
				end
			end
		else
			YbMarketSale_ALLItem[1]:SetActionItem(-1);
			YbMarketSale_PutUpTheShutters:Disable()
		end
		if this:IsVisible() == true then
			return
		end
		this:Show()
	elseif event == "UPDATE_MARKET_MY_SALE" and this:IsVisible() then
		YbMarketSale_Update()
	elseif event == "CLOSE_ONSALE" and this:IsVisible() then
		this:Hide()
	elseif event == "SELLBOX_REFRESH" and this:IsVisible() then
		Auction:AskAuctionBoxList()
	end
end
function YbMarketSale_btnUpPageClicked()
	if YbMarketSale_Now_page <= 1 then
		return
	end
	for i = 1, 10 do
		YbMarketSale_ALLItem[i]:SetActionItem(-1);
		YbMarketSale_ALLName[i]:SetText("")
		YbMarketSale_ALLStatus[i]:SetText("")
		YbMarketSale_ALLPrice[i]:SetText("")
		YbMarketSale_PutUpTheShutters:Disable()
	end
	YbMarketSale_Now_page = YbMarketSale_Now_page - 1
	if YbMarketSale_Now_page <= 1 then
		YbMarketSale_btnUpPage:Disable()
		YbMarketSale_btnDownPage:Enable()
	end
	YbMarketSale_UK_page(YbMarketSale_Now_page)
end
function YbMarketSale_btnDownPageClicked()
	if YbMarketSale_Dowbtn_page <= 0 then
		return
	end
	for i = 1, 10 do
		YbMarketSale_ALLItem[i]:SetActionItem(-1);
		YbMarketSale_ALLName[i]:SetText("")
		YbMarketSale_ALLStatus[i]:SetText("")
		YbMarketSale_ALLPrice[i]:SetText("")
		YbMarketSale_PutUpTheShutters:Disable()
	end
	YbMarketSale_Now_page = YbMarketSale_Now_page + 1
	if YbMarketSale_Dowbtn_page <= 0 then
		YbMarketSale_btnDownPage:Disable()
		YbMarketSale_btnUpPage:Enable()
	end
	YbMarketSale_UK_page(YbMarketSale_Now_page)
end
function YbMarketSale_UK_page(pageidex)
	_0331(YbMarket_tba, 724.012, 250, 0, { 40, tonumber(pageidex) })
end
-----------------------------------------------------------------------
-- on events
-----------------------------------------------------------------------
function YbMarketSale_Item_Click(idx)
	if idx > 0 and idx <= 10 then
		local pName = nil
		local nowStatus = nil
		local price = nil
		if m_CurTab == 2 then
			pName, nowStatus, price = 0, 0, 0  --Auction:GetMySellBoxItemAuctionInfo(idx - 1)
		elseif m_CurTab == 1 then
			pName, nowStatus, price = 0, 0, 0--Auction:GetMySellBoxPetAuctionInfo(idx - 1)
		end
		m_cur_sel = idx
		for i = 1, 10 do
			YbMarketSale_ALLItem[i]:SetPushed(0)
		end
		if YbMarketSale_g_nContentButton[m_cur_sel * 4] ~= nil and tonumber(YbMarketSale_g_nContentButton[m_cur_sel * 4]) >= 1 then
			YbMarketSale_ALLItem[m_cur_sel]:SetPushed(1)
			YbMarketSale_PutUpTheShutters:Enable()
			if string.find(xiaoxiang_sskjhhe[idx], "已卖出") ~= nil then
				YbMarketSale_PutUpTheShutters:SetText("收取元宝") --取钱
			else
				YbMarketSale_PutUpTheShutters:SetText("取回商品") --取钱
			end
		end
	end
end
function YbMarketSale_ChangeTabIndex(idx)
	if idx == m_CurTab then
		return
	end
	local isCanDo = Auction:IsYBMarketCanSwitchPage()
	if isCanDo == 0 then
		if m_CurTab == 1 then
			YbMarketSale_Check_Pet:SetCheck(1)
			YbMarketSale_Check_Item:SetCheck(0)
		elseif m_CurTab == 2 then
			YbMarketSale_Check_Pet:SetCheck(0)
			YbMarketSale_Check_Item:SetCheck(1)
		end
		PushDebugMessage("不可连续点击，请稍等片刻后再点击。")
		return
	end
	if idx == 1 and m_CurTab ~= 1 then
		YbMarketSale_ClearFrame()
		Auction:AskAuctionBoxList()
		m_CurTab = 1
	elseif idx == 2 and m_Curtab ~= 2 then
		YbMarketSale_ClearFrame()
		Auction:AskAuctionBoxList()
		m_CurTab = 2
	end
end
function YbMarketSale_BtnPet_Clicked(index)
	if index > 0 and index <= 10 then
		local pName, nowStatus, price = Auction:GetMySellBoxPetAuctionInfo(index - 1)
		if pName ~= nil then
			Auction:ShowMySellBox_PetInfo(index - 1)
			YbMarketSale_Item_Click(index)
		end
	end
end

function YbMarketSale_PetList_RClick()
end

function YbMarketSale_ReUp_Clicked()
	--安全时间
	if tonumber(DataPool:GetLeftProtectTime()) > 0 then
		PushDebugMessage("在安全时间内无法进行此操作。打开包裹栏，点击防盗号按钮可以自行设置安全时间。")
		return
	end
	if m_CurTab == 2 then
		local pName, nowStatus, price = Auction:GetMySellBoxItemAuctionInfo(m_cur_sel - 1)
		if nowStatus == 2 then
			Auction:ReUpExpired(m_CurTab, m_cur_sel - 1, 0)
		end
	elseif m_CurTab == 1 then
		local pName, nowStatus, price = Auction:GetMySellBoxPetAuctionInfo(m_cur_sel - 1)
		if nowStatus == 2 then
			Auction:ReUpExpired(m_CurTab, m_cur_sel - 1, 0)
		end
	end
end

function YbMarketSaleReprice_Clicked()
	if m_cur_sel ~= -1 then
		Auction:OpenChangePriceWindow(m_CurTab, m_cur_sel - 1)
	end
end
function YbMarketSalePutUpTheShutters_Clicked()
	if m_cur_sel == nil or m_cur_sel < 1 then
		PushDebugMessage("请选择一个物品")
		return
	end
	if YbMarketSale_g_nContentButton[m_cur_sel * 4] == nil or tonumber(YbMarketSale_g_nContentButton[m_cur_sel * 4]) < 1 then
		PushDebugMessage("非法物品")
		return
	end
	local cont = tonumber(YbMarketSale_g_nContentButton[m_cur_sel * 4]) - 11
	_0331(YbMarket_tba, 724.012, 250, 20, { 30, cont - 9 })
	this:Hide()
	YbMarketSale_PutUpTheShutters:Disable()
end
-----------------------------------------------------------------------
--private function
-----------------------------------------------------------------------
function YbMarketSale_Update()
	YbMarketSale_ClearFrame()
	if m_CurTab == 1 then
		YbMarketSale_ChangeToPetFrame()
		for i = 1, 5 do
			local pName, nowStatus, price = Auction:GetMySellBoxPetAuctionInfo(i - 1)
			if pName ~= nil then
				local strHead = Auction:GetPetPortraitByIndex(i - 1, 1)
				YbMarketSale_ALLItem[i]:SetProperty("Empty", "False")
				YbMarketSale_ALLItem[i]:SetProperty("NormalImage", tostring(strHead))
				local nEra = Auction:GetPetEraCount(i - 1, 1)
				if nEra == 1 then
					pName = "二代" .. pName
				end
				YbMarketSale_ALLName[i]:SetText(tostring(pName))
				YbMarketSale_ALLPrice[i]:SetText(tostring(price) .. "元宝")
				if nowStatus == 1 then
					YbMarketSale_ALLStatus[i]:SetText("#G出售中")
				elseif nowStatus == 2 then
					YbMarketSale_ALLStatus[i]:SetText("#cff66cc已过期")
				elseif nowStatus == 3 then
					YbMarketSale_ALLStatus[i]:SetText("#cff9900已售出")
				end
			end
		end
	elseif m_CurTab == 2 then
		for i = 1, 10 do
			local theAction = EnumAction(i - 1, "ybmarket_self")
			if theAction:GetID() ~= 0 then
				local pName, nowStatus, price = Auction:GetMySellBoxItemAuctionInfo(i - 1)
				if pName ~= nil then
					YbMarketSale_ALLItem[i]:SetActionItem(theAction:GetID())
					YbMarketSale_ALLName[i]:SetText(tostring(pName))
					YbMarketSale_ALLPrice[i]:SetText(tostring(price) .. "元宝")
					if nowStatus == 1 then
						YbMarketSale_ALLStatus[i]:SetText("#G出售中")
					elseif nowStatus == 2 then
						YbMarketSale_ALLStatus[i]:SetText("#cff66cc已过期")
					elseif nowStatus == 3 then
						YbMarketSale_ALLStatus[i]:SetText("#cff9900已售出")
					end
				end
			end
		end
	end
end
function YbMarketSale_ClearFrame()
	for i = 1, 10 do
		YbMarketSale_ALLItem[i]:SetActionItem(-1)
		YbMarketSale_ALLItem[i]:SetProperty("CornerChar", "TopLeft ");
		YbMarketSale_ALLItem[i]:SetProperty("CornerChar", "TopRight ");
		YbMarketSale_ALLItem[i]:SetProperty("CornerChar", "BotRight ");
		YbMarketSale_ALLItem[i]:SetProperty("CornerChar", "BotLeft ");
		YbMarketSale_ALLName[i]:SetText("")
		YbMarketSale_ALLPrice[i]:SetText("")
		YbMarketSale_ALLStatus[i]:SetText("")
		YbMarketSale_ALLItemInfo[i]:Show()
		YbMarketSale_ALLItem[i]:Show()
	end
	YbMarketSale_ReUp:Disable()
	YbMarketSale_Reprice:Disable()
	YbMarketSale_PutUpTheShutters:SetText("下架")    --下架
	YbMarketSale_PutUpTheShutters:Disable()
end
function YbMarketSale_ChangeToPetFrame()
	for i = 6, 10 do
		YbMarketSale_ALLItem[i]:Hide()
		YbMarketSale_ALLItemInfo[i]:Hide()
	end
end
function YbMarketSale_Close_Clicked()
	YbMarketSale_ClearFrame()
	m_cur_sel = -1
	this:Hide()
	if (IsWindowShow("YB_Modify")) then
		CloseWindow("YB_Modify", true);
	end
end