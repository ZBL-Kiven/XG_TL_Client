local YbMarketSale_UICommand_Id = 701900
local m_cur_sel = -1
local m_CurTab = 2
local YbMarketSale_ALLItem = {}
local YbMarketSale_ALLName = {}
local YbMarketSale_ALLPrice = {}
local YbMarketSale_ALLStatus = {}
local YbMarketSale_ALLPetInfo = {}
local YbMarketSale_ALLItemInfo = {}
-----------------------------------------------------------------------
-- OnGameEvent
-----------------------------------------------------------------------

function YbMarketSale_PreLoad()
	this : RegisterEvent("UI_COMMAND");
	this : RegisterEvent("OPEN_ONSALE")
	this : RegisterEvent("UPDATE_MARKET_MY_SALE")
	this : RegisterEvent("CLOSE_ONSALE")
	this : RegisterEvent("SELLBOX_REFRESH")
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
	YbMarketSale_ALLPetInfo = {
		[1] = YbMarketSale_BtnPet1,
		[2] = YbMarketSale_BtnPet2,
		[3] = YbMarketSale_BtnPet3,
		[4] = YbMarketSale_BtnPet4,
		[5] = YbMarketSale_BtnPet5
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
	if event == "OPEN_ONSALE"  then
		if this : IsVisible() then
			return
		end
		YbMarketSale_ClearFrame()
		YbMarketSale_Check_Item:SetCheck(1)
		YbMarketSale_Check_Pet:SetCheck(0)
		m_CurTab = 2
		this:Show()
		Auction:AskAuctionBoxList()
	elseif event == "UI_COMMAND"  and tonumber(arg0) == YbMarketSale_UICommand_Id then
		if this:IsVisible() == true then 
			return
		end	
		
		if Get_XParam_INT_Count() ~= 2 then
			return		
		end
		
		if Get_XParam_INT(1) ~= 2 then
			return
		end	

		local obj_Server_id = Get_XParam_INT(0)
		local obj_id = DataPool : GetNPCIDByServerID(obj_Server_id);
		this:CareObject(obj_id, 1);

		
		YbMarketSale_ClearFrame()
		YbMarketSale_Check_Item:SetCheck(1)
		YbMarketSale_Check_Pet:SetCheck(0)
		m_CurTab = 2
		this:Show()
		Auction:AskAuctionBoxList()	
	
	elseif event == "UPDATE_MARKET_MY_SALE" and this:IsVisible() then
		YbMarketSale_Update()
	elseif event == "CLOSE_ONSALE" and this:IsVisible() then
		this:Hide()
	elseif event == "SELLBOX_REFRESH" and this:IsVisible() then
		Auction:AskAuctionBoxList()
	end
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
			pName ,nowStatus , price = Auction:GetMySellBoxItemAuctionInfo(idx - 1)
		elseif m_CurTab == 1 then
			pName ,nowStatus , price = Auction:GetMySellBoxPetAuctionInfo(idx - 1)
		end
		if pName ~= nil then
			m_cur_sel = idx
			for i = 1 , 10 do 
				YbMarketSale_ALLItem[i]:SetPushed(0)
			end
			YbMarketSale_ALLItem[m_cur_sel]:SetPushed(1)
	
			if nowStatus ~= nil then
				if nowStatus == 1 then 
					YbMarketSale_Reprice:Enable()
					YbMarketSale_PutUpTheShutters:SetText("#{YBSC_100111_51}")	--下架
					YbMarketSale_PutUpTheShutters:Enable()
				elseif nowStatus == 2 then
					YbMarketSale_Reprice:Disable()
					YbMarketSale_PutUpTheShutters:SetText("#{YBSC_100111_52}")	--取回
					YbMarketSale_PutUpTheShutters:Enable()
				elseif nowStatus == 3 then
					YbMarketSale_Reprice:Disable()
					YbMarketSale_PutUpTheShutters:SetText("#{YBSC_XML_62}") --取钱
					YbMarketSale_PutUpTheShutters:Enable()
				end
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
		PushDebugMessage("#{YBSC_100111_40}")
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
		local pName , nowStatus , price = Auction:GetMySellBoxPetAuctionInfo(index - 1)
		if pName ~= nil then
			Auction:ShowMySellBox_PetInfo(index - 1)
			YbMarketSale_Item_Click(index)
		end
	end
end

function YbMarketSale_PetList_RClick()
--	local sel = YbMarketSale_PetList:GetFirstSelectItem()
--	if sel == -1 then
--		return
--	end
--	Auction:ShowMySellBox_PetInfo(sel)
end

function YbMarketSaleReprice_Clicked()
	if m_cur_sel ~= -1 then
		Auction:OpenChangePriceWindow(m_CurTab ,m_cur_sel - 1)
	end

end

function YbMarketSalePutUpTheShutters_Clicked()
		if m_CurTab == 2 then
			local pName ,nowStatus , price = Auction:GetMySellBoxItemAuctionInfo(m_cur_sel - 1)
			if nowStatus == 1 then
				Auction:GetBackWhatOnSale(m_CurTab , m_cur_sel - 1 ,0)
			elseif nowStatus == 2 then
				Auction:GetBackExpired(m_CurTab , m_cur_sel - 1 ,0)
			elseif  nowStatus ==  3 then
				Auction:GetMoney(m_CurTab , m_cur_sel - 1)
			end
		elseif m_CurTab == 1 then
			local pName , nowStatus , price = Auction:GetMySellBoxPetAuctionInfo(m_cur_sel - 1)
			if nowStatus == 1 then
				Auction:GetBackWhatOnSale(m_CurTab , m_cur_sel - 1 ,0)
			elseif  nowStatus ==  2 then
				Auction:GetBackExpired(m_CurTab , m_cur_sel - 1,0)
			elseif  nowStatus ==  3 then
				Auction:GetMoney(m_CurTab , m_cur_sel - 1)
			end
		end

end


-----------------------------------------------------------------------
--private function
-----------------------------------------------------------------------
function YbMarketSale_Update()
	YbMarketSale_ClearFrame()
	if m_CurTab == 1 then
		YbMarketSale_ChangeToPetFrame()
		for i = 1 ,5 do 
			local pName , nowStatus , price = Auction:GetMySellBoxPetAuctionInfo( i - 1 )
			if pName ~= nil then
				local strHead = Auction:GetPetPortraitByIndex(i - 1 , 1)
				YbMarketSale_ALLItem[i]:SetProperty("Empty", "False")
				YbMarketSale_ALLItem[i]:SetProperty("NormalImage", tostring(strHead) )
				local nEra = Auction:GetPetEraCount(i - 1 , 1)
				if nEra == 1 then
					pName = "二代"..pName
				end
				YbMarketSale_ALLName[i]:SetText(tostring(pName))
				YbMarketSale_ALLPrice[i]:SetText(tostring(price).."#{TLBC_090617_11}")
				YbMarketSale_ALLPetInfo[i]:Show()
				if nowStatus == 1 then
					YbMarketSale_ALLStatus[i]:SetText("#{YBSC_100111_49}")
				elseif nowStatus == 2 then
					YbMarketSale_ALLStatus[i]:SetText("#{YBSC_100111_50}")
				elseif nowStatus == 3 then
					YbMarketSale_ALLStatus[i]:SetText("#{YBSC_100111_48}")
				end
			end
		end			
	elseif m_CurTab == 2 then
		for i=1 ,10 do 
			local theAction = EnumAction( i - 1 , "ybmarket_self")
			if theAction:GetID() ~= 0 then
				local pName , nowStatus ,price = Auction:GetMySellBoxItemAuctionInfo( i - 1 )
				if pName ~= nil then
					YbMarketSale_ALLItem[i]:SetActionItem(theAction:GetID())
					YbMarketSale_ALLName[i]:SetText(tostring(pName))
					YbMarketSale_ALLPrice[i]:SetText(tostring(price).."#{TLBC_090617_11}")
					if nowStatus == 1 then
						YbMarketSale_ALLStatus[i]:SetText("#{YBSC_100111_49}")
					elseif nowStatus == 2 then
						YbMarketSale_ALLStatus[i]:SetText("#{YBSC_100111_50}")
					elseif nowStatus == 3 then
						YbMarketSale_ALLStatus[i]:SetText("#{YBSC_100111_48}")
					end					
				end
			end
		end	
	end
end

function YbMarketSale_ClearFrame()
	for i = 1 , 10 do 
		YbMarketSale_ALLItem[i]:SetActionItem(-1)
		YbMarketSale_ALLItem[i]:SetProperty("CornerChar", "TopLeft ");
		YbMarketSale_ALLItem[i]:SetProperty("CornerChar", "TopRight ");
		YbMarketSale_ALLItem[i]:SetProperty("CornerChar", "BotRight ");
		YbMarketSale_ALLItem[i]:SetProperty("CornerChar", "BotLeft ");
		YbMarketSale_ALLName[i]:SetText("")
		YbMarketSale_ALLPrice[i]:SetText("")
		YbMarketSale_ALLStatus[i]:SetText("")
		if i <= 5 then
			YbMarketSale_ALLPetInfo[i]:Hide()
		else
			YbMarketSale_ALLItemInfo[i]:Show()
			YbMarketSale_ALLItem[i]:Show()
		end
	end
	YbMarketSale_Reprice:Disable()
	YbMarketSale_PutUpTheShutters:SetText("#{INTERFACE_XML_738}")	--下架
	YbMarketSale_PutUpTheShutters:Disable()
end

function YbMarketSale_ChangeToPetFrame()
	for i = 6 , 10 do 
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