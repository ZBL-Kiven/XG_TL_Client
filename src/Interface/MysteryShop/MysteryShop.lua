local GOODS_BUTTONS_NUM = 12
local GOODS_BUTTONS = {}
local GOODS_DESCS = {}
local GOODS_PRICE = {}
local GOOD_BAD    = {}

local CALLBACK_BUTTON_FRAME = {}
local CALLBACK_BUTTON = {}

local g_CurPageNum = 1
local g_MaxPageNum = 1
local g_objCared = -1

local CU_MONEY			= 1	-- 钱
local CU_GOODBAD		= 2	-- 善恶值
local CU_MORALPOINT		= 3	-- 师德点
local CU_TICKET			= 4 -- 官票钱
local CU_YUANBAO		= 5	-- 元宝
local CU_ZENGDIAN		= 6 -- 赠点
local CU_MENPAI_POINT	= 7 -- 门派贡献度
local CU_MONEYJZ		= 8 -- 交子

local MAX_OBJ_DISTANCE = 3.0

--存储随机排序的索引值
local	g_tOrderPool	= {}
--当前商店的商品数量
local	g_nTotalNum		= 0

local g_MysteryShop_Frame_UnifiedPosition
--===============================================
-- PreLoad
--===============================================
function MysteryShop_PreLoad()
	this:RegisterEvent("PLAYER_ENTERING_WORLD")
	this:RegisterEvent("OPEN_MYSTERY_SHOP")
	this:RegisterEvent("MSSHOP_BUY_INFO")
	this:RegisterEvent("UPDATE_BOOTH")
	this:RegisterEvent("OBJECT_CARED_EVENT")
	this:RegisterEvent("CLOSE_BOOTH")
	this:RegisterEvent("PLAYER_LEAVE_WORLD")
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

--===============================================
-- OnLoad
--===============================================
function MysteryShop_OnLoad()

	GOODS_BUTTONS[1] = MysteryShop_Item1
	GOODS_BUTTONS[2] = MysteryShop_Item2
	GOODS_BUTTONS[3] = MysteryShop_Item3
	GOODS_BUTTONS[4] = MysteryShop_Item4
	GOODS_BUTTONS[5] = MysteryShop_Item5
	GOODS_BUTTONS[6] = MysteryShop_Item6
	GOODS_BUTTONS[7] = MysteryShop_Item7
	GOODS_BUTTONS[8] = MysteryShop_Item8
	GOODS_BUTTONS[9] = MysteryShop_Item9
	GOODS_BUTTONS[10]= MysteryShop_Item10
	GOODS_BUTTONS[11]= MysteryShop_Item11
	GOODS_BUTTONS[12]= MysteryShop_Item12
	
	GOODS_DESCS[1] = MysteryShop_ItemInfo1_Text
	GOODS_DESCS[2] = MysteryShop_ItemInfo2_Text
	GOODS_DESCS[3] = MysteryShop_ItemInfo3_Text
	GOODS_DESCS[4] = MysteryShop_ItemInfo4_Text
	GOODS_DESCS[5] = MysteryShop_ItemInfo5_Text
	GOODS_DESCS[6] = MysteryShop_ItemInfo6_Text
	GOODS_DESCS[7] = MysteryShop_ItemInfo7_Text
	GOODS_DESCS[8] = MysteryShop_ItemInfo8_Text
	GOODS_DESCS[9] = MysteryShop_ItemInfo9_Text
	GOODS_DESCS[10]= MysteryShop_ItemInfo10_Text
	GOODS_DESCS[11]= MysteryShop_ItemInfo11_Text
	GOODS_DESCS[12]= MysteryShop_ItemInfo12_Text
	
	GOODS_PRICE[1] = MysteryShop_ItemInfo1_Price
	GOODS_PRICE[2] = MysteryShop_ItemInfo2_Price
	GOODS_PRICE[3] = MysteryShop_ItemInfo3_Price
	GOODS_PRICE[4] = MysteryShop_ItemInfo4_Price
	GOODS_PRICE[5] = MysteryShop_ItemInfo5_Price
	GOODS_PRICE[6] = MysteryShop_ItemInfo6_Price
	GOODS_PRICE[7] = MysteryShop_ItemInfo7_Price
	GOODS_PRICE[8] = MysteryShop_ItemInfo8_Price
	GOODS_PRICE[9] = MysteryShop_ItemInfo9_Price
	GOODS_PRICE[10]= MysteryShop_ItemInfo10_Price
	GOODS_PRICE[11]= MysteryShop_ItemInfo11_Price
	GOODS_PRICE[12]= MysteryShop_ItemInfo12_Price
	
	GOOD_BAD[1]  =     MysteryShop_ItemInfo1_GB
	GOOD_BAD[2]  =     MysteryShop_ItemInfo2_GB
	GOOD_BAD[3]  =     MysteryShop_ItemInfo3_GB
	GOOD_BAD[4]  =     MysteryShop_ItemInfo4_GB
	GOOD_BAD[5]  =     MysteryShop_ItemInfo5_GB
	GOOD_BAD[6]  =     MysteryShop_ItemInfo6_GB
	GOOD_BAD[7]  =     MysteryShop_ItemInfo7_GB
	GOOD_BAD[8]  =     MysteryShop_ItemInfo8_GB
	GOOD_BAD[9]  =     MysteryShop_ItemInfo9_GB
	GOOD_BAD[10] =     MysteryShop_ItemInfo10_GB
	GOOD_BAD[11] =     MysteryShop_ItemInfo11_GB
	GOOD_BAD[12] =     MysteryShop_ItemInfo12_GB
	
	CALLBACK_BUTTON[1] = MysteryShop_Callback1
	CALLBACK_BUTTON[2] = MysteryShop_Callback2
	CALLBACK_BUTTON[3] = MysteryShop_Callback3
	CALLBACK_BUTTON[4] = MysteryShop_Callback4
	CALLBACK_BUTTON[5] = MysteryShop_Callback5
	
	CALLBACK_BUTTON_FRAME[1] = MysteryShop_Callback1_Frame
	CALLBACK_BUTTON_FRAME[2] = MysteryShop_Callback2_Frame
	CALLBACK_BUTTON_FRAME[3] = MysteryShop_Callback3_Frame
	CALLBACK_BUTTON_FRAME[4] = MysteryShop_Callback4_Frame
	CALLBACK_BUTTON_FRAME[5] = MysteryShop_Callback5_Frame
	
	g_MysteryShop_Frame_UnifiedPosition = MysteryShop_Frame:GetProperty("UnifiedPosition")
	
end

--===============================================
-- OnEvent
--===============================================
function MysteryShop_OnEvent(event)
	
	if event == "PLAYER_ENTERING_WORLD" and this:IsVisible() then
		Booth_Close()
	end	 
	
	if event == "OPEN_MYSTERY_SHOP" then
	
		local nUnit = NpcShop:GetShopType("unit")
		if CU_YUANBAO == nUnit then
			MysteryShop_querengoumai_Text:Show()
			MysteryShop_querengoumai:Show()
			local check  = tonumber(NpcShop:GetBuyDirectly())
			if check >= 1 then
				MysteryShop_querengoumai:SetCheck(0)
			else
				MysteryShop_querengoumai:SetCheck(1)
			end
		else
			MysteryShop_querengoumai_Text:Hide()
			MysteryShop_querengoumai:Hide()
		end
		for i = 1, GOODS_BUTTONS_NUM do
			GOOD_BAD[i]:Show()
			GOODS_PRICE[i]:Hide()
		end
		g_nTotalNum	= 0
		this:Show()
		MysteryShop_Text:SetText("#gFF0FA0"..Target:GetShopNpcName())

		OpenBooth()

		--关心商人Obj
		g_objCared = NpcShop:GetNpcId()
		if 0 > g_objCared then
			MysteryShop_Text:SetText("")
		end
		this:CareObject(g_objCared, 1, "MysteryShop")
		NpcShop:CloseConfirm()
		MysteryShop_UpdatePage(1)
		
		if IsWindowShow("Shop_Fitting") then
			RestoreShopFitting()
			--CloseShopFitting()
			CloseWindow("Shop_Fitting", true)
		end
		SetDefaultMouse()
	end
	
	if event == "UPDATE_BOOTH" and this:IsVisible() then
		MysteryShop_UpdatePage(g_CurPageNum)
	end
	
	if event == "OBJECT_CARED_EVENT" then
		if tonumber(arg0) ~= g_objCared then
			return
		end
		
		--如果和商人的距离大于一定距离或者被删除，自动关闭
		if arg1 == "distance" and tonumber(arg2) > MAX_OBJ_DISTANCE or arg1 == "destroy" then
			--取消关心
			SetDefaultMouse()
			--RestoreShopFitting()
			--CloseShopFitting()
			this:CareObject(g_objCared, 0, "MysteryShop")
			NpcShop:CloseConfirm()
			this:Hide()			
		end
	end
	
	if event == "CLOSE_BOOTH" then
		--取消关心
		RestoreShopFitting()
		this:CareObject(g_objCared, 0, "MysteryShop")
		NpcShop:CloseConfirm()
		this:Hide()	
		if IsWindowShow("Shop_Fitting") then
			--RestoreShopFitting()
			--CloseShopFitting()
			CloseWindow("Shop_Fitting", true)
		end
		
		SetDefaultMouse()
	end
	
	if event == "MSSHOP_BUY_INFO" and this:IsVisible() then
		MysteryShop_UpdatePage(g_CurPageNum)
	end
	
	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		MysteryShop_Frame_On_ResetPos()
	end
end

function MysteryShop_OnBtnClicked_OpenFitting()
	
	if IsIdleLogic() ~= 1 then
		SetNotifyTip("不能进行此操作。")
		return
	end
	
	if IsWindowShow("Shop_Fitting") then
		--RestoreShopFitting()
		--CloseShopFitting()
		CloseWindow("Shop_Fitting", true)
	end

	MouseCmd_ShopFittingSet()
	SetNotifyTip("请点击您要试穿的时装或试骑的坐骑。")
end

--===============================================
-- UpdatePage
--===============================================
function MysteryShop_UpdatePage(thePage)
	
	NpcShop:Lua_UpdateMSShopLimitItem()
	
	--MysteryShop_AllRepair:Show()	
	--MysteryShop_Repair:Show()
	
	local nMult = NpcShop:GetShopType("buymult")	
	if nMult <= 0 then
	--	MysteryShop_Wholesale:Disable()
	else
	--	MysteryShop_Wholesale:Enable()
	end
	
	--收购
	local nBuyType = NpcShop:GetShopType("buy")
	if nBuyType <= 0 then 
	--	MysteryShop_Callback1:Hide() 
	--	MysteryShop_Callback1_Frame:Hide()
	else
	--	MysteryShop_Callback1:Show()
	--	MysteryShop_Callback1_Frame:Show()
	end

	--修理
	local nRepairType = NpcShop:GetShopType("repair")
	if nRepairType <= 0 then 
	--	MysteryShop_AllRepair:Hide()
	--	MysteryShop_Repair:Hide()
	else
	--	MysteryShop_AllRepair:Show()
	--	MysteryShop_Repair:Show()
	end
	
	--回购
	local nCallbackType = NpcShop:GetShopType("callback")
	if nCallbackType <= 0 then
		for i = 1, 5 do
		--	CALLBACK_BUTTON_FRAME[i]:Hide()
		end
	else
		for i = 1, 5 do
		--	CALLBACK_BUTTON_FRAME[i]:Show()
		end
		
		--显示回购物品
		nActIndex = 0
		local nCallNum = NpcShop:GetCallBackNum()
		i = 1
		while i <= nCallNum do
			local theAction = NpcShop:EnumCallBackItem(nActIndex)
	
			if theAction:GetID() ~= 0 then
			--	CALLBACK_BUTTON[i]:SetActionItem(theAction:GetID())
				i = i + 1
			else
			--	CALLBACK_BUTTON[i]:SetActionItem(-1)
				i = i + 1
			end
			nActIndex = nActIndex + 1
		end
	end
	
	--使用什么作为货币
	local nUnit = NpcShop:GetShopType("unit")	
	for i = 1, GOODS_BUTTONS_NUM do
		GOOD_BAD[i]:Show()
		GOODS_PRICE[i]:Hide()
	end	

	local i	= 1
	if g_nTotalNum == 0 or g_nTotalNum ~= GetActionNum("boothitem") then
		g_nTotalNum	= GetActionNum("boothitem")
		MysteryShop_Order()
	end

	-- 计算总页数
	local nTotalPage
	if g_nTotalNum < 1  then
		nTotalPage	= 1
	else
		nTotalPage	= math.floor((g_nTotalNum - 1) / GOODS_BUTTONS_NUM) + 1
	end

	g_MaxPageNum = nTotalPage

	if thePage < 1 or thePage > nTotalPage then 
		return	
	end

	local bHaveRide = 0
	
	g_CurPageNum = thePage

	local nStartIndex = (thePage - 1) * GOODS_BUTTONS_NUM

	local nActIndex = nStartIndex
	i = 1
	while i <= GOODS_BUTTONS_NUM do
		local idx	= g_tOrderPool[nActIndex+1]
		if idx == nil then
			idx	= -1
		end

		local theAction = EnumAction(idx, "boothitem")
		if theAction:GetID() ~= 0 then
			local nEquipPoint = theAction:GetEquipPoint()
			
			if nEquipPoint == 16 or nEquipPoint == 8 then
				bHaveRide = 1
			end
			
			GOODS_BUTTONS[i]:SetActionItem(theAction:GetID())
			if theAction:GetItemColorInShop()~="" then
				GOODS_DESCS[i]:SetText(theAction:GetItemColorInShop()..theAction:GetName())
			else
				GOODS_DESCS[i]:SetText(theAction:GetName())
			end
			local nPrice = NpcShop:EnumItemPrice(idx)
			GOOD_BAD[i]:SetText("元宝:"..tostring(nPrice))
			i = i + 1
		else
			GOODS_BUTTONS[i]:SetActionItem(-1)
			GOODS_DESCS[i]:SetText("")			
			GOODS_PRICE[i]:Hide()
			GOOD_BAD[i]:SetText("")			
			i = i + 1		
		end
		nActIndex = nActIndex + 1
	end


	if bHaveRide >= 1 then
	--	MysteryShop_Try:Show()
	else
	--	MysteryShop_Try:Hide()
	end
	
	if nTotalPage == 1 then
	--	MysteryShop_UpPage:Hide()
	--	MysteryShop_DownPage:Hide()
	--	MysteryShop_CurrentlyPage:Hide()
		MysteryShop_BK:Hide()
	else
	--	MysteryShop_UpPage:Show()
	--	MysteryShop_DownPage:Show()
	--	MysteryShop_CurrentlyPage:Show()
		MysteryShop_BK:Show()
		MysteryShop_UpPage:Enable()
		MysteryShop_DownPage:Enable()
		if g_CurPageNum == nTotalPage then
			MysteryShop_DownPage:Disable()
		end
		
		if g_CurPageNum == 1 then
			MysteryShop_UpPage:Disable()
		end

		MysteryShop_CurrentlyPage:SetText(tostring(g_CurPageNum) .. "/" .. tostring(nTotalPage) )
	end
end


--===============================================
-- Button_Clicked
--===============================================
function MysteryShop_GoodButton_Clicked(nIndex)
	if nIndex < 1 or nIndex > 12 then 
		return
	end
	GOODS_BUTTONS[nIndex]:DoAction()
end

--===============================================
-- PageUp
--===============================================
function MysteryShop_PageUp()
	curPage = g_CurPageNum - 1
	if curPage >= g_MaxPageNum then
		curPage = g_MaxPageNum
	end
	NpcShop:CloseConfirm()
	MysteryShop_UpdatePage(curPage)
end

--===============================================
-- PageDown
--===============================================
function MysteryShop_PageDown()
	curPage = g_CurPageNum + 1
	if curPage < 0 then
		curPage = 0
	end
	NpcShop:CloseConfirm()
	MysteryShop_UpdatePage(curPage)
end

--===============================================
-- Close
--===============================================
function MysteryShop_Close()
	this:Hide()
end

function MysteryShop_OnHidden()

	if IsWindowShow("Shop_Fitting") then
		CloseWindow("Shop_Fitting", true)
	end
	
	SetDefaultMouse()
	
	CloseBooth()
	--取消关心
	this:CareObject(g_objCared, 0, "MysteryShop")
	NpcShop:CloseConfirm()

end

--===============================================
-- Goods_Clicked
--===============================================
function MysteryShop_Sold_Goods_Clicked(nIndex)
	if IsWindowShow("Shop_Fitting") then
		CloseWindow("Shop_Fitting", true)
	end
	CALLBACK_BUTTON[nIndex]:DoAction()
end

--===============================================
-- RepairAll
--===============================================
function MysteryShop_RepairAll()
	RepairAll()
end

--===============================================
-- RepairOne
--===============================================
function MysteryShop_RepairOne()
	RepairOne()
end

--===============================================
-- MouseEnter
--===============================================
function MysteryShop_RepairAll_MouseEnter()
	
	local nMoney = NpcShop:GetRepairAllPrice()
	
	local nGold, nSilver, nCopper = Bank:TransformCoin(nMoney)
	
	local szMoney = ""
	
	if nGold ~= 0 then
		szMoney = tostring(nGold).."#-14"
	end
	
	if nSilver ~= 0 then
		szMoney = szMoney..tostring(nSilver).."#-15"
	end 
	
	szMoney = szMoney..tostring(nCopper).."#-16"
	
	MysteryShop_AllRepair:SetToolTip("全部修理#r费用："..szMoney)

end

function MysteryShop_Sale()
	if IsWindowShow("Shop_Fitting") then
		CloseWindow("Shop_Fitting", true)
	end
	PrepearSale()
end

function MysteryShop_BuyMult()
	if IsWindowShow("Shop_Fitting") then
		CloseWindow("Shop_Fitting", true)
	end
	PrepearBuyMult()
end

--随机排序
function MysteryShop_Order()
	local max = g_nTotalNum
	local oldt	= {}
	g_tOrderPool= {}

	for i = 1, tonumber(max) do
	  oldt[i] = i - 1
	end
	
	if tonumber(NpcShop:GetIsShopReorder()) == 0 then
		g_tOrderPool = oldt
	else
		for i = 1, table.getn(oldt) do
		 local idx	= math.random(1, table.getn(oldt))
		 local val	= oldt[idx]
		 g_tOrderPool[i]= val
		 table.remove(oldt, idx)
		end
	end
end

function MysteryShop_querengoumai_Clicked()
	if(NpcShop:GetBuyDirectly() == 0)then
		MysteryShop_querengoumai:SetCheck(0)
		NpcShop:SetBuyDirectly(1)
	else
		MysteryShop_querengoumai:SetCheck(1)
		NpcShop:SetBuyDirectly(0)
	end
end

function MysteryShop_Frame_On_ResetPos()
  MysteryShop_Frame:SetProperty("UnifiedPosition", g_MysteryShop_Frame_UnifiedPosition)
end