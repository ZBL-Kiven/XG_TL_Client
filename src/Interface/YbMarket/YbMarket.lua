--潇湘添加  QQ1400003003
local YbMarket_UICommand_Id = 701900
local YbMarket_tba = { 84, 117, 105, 66, 105, 110, 103, 95, 65 }
local YbMarket_Page_Total = 0        -- 本次查询总页数
local YbMarket_Page_Cur = 1        -- 本次查询的页数   如：  1/10   一共10页， 当前第一页， 下次则发送页面为2的请求
local YbMarket_Cur_Select = 0        --当前选中的商品
local YbMarket_ctrlEquipTexts = {}
local YbMarket_ctrlEquipActions = {}
local YbMarket_ctrlEquipFlash = {}
local g_nContentButton = {}
-----------------------------------------------------------------------
-- OnGameEvent
-----------------------------------------------------------------------
function YbMarket_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("UPDATE_YBMARKET")
	this:RegisterEvent("YBMARKET_NEED_RESEARCH")
	this:RegisterEvent("UPDATE_YUANBAO");
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	this:RegisterEvent("YBMARKET_CLEAR_MULTIBUY");
	-- 打开元宝交易市场
end
function YbMarket_OnLoad()
	YbMarket_ctrlEquipTexts = {
		[1] = { YbMarket_Equip1_Text_1, YbMarket_Equip1_Text_2, YbMarket_Equip1_Text_3, YbMarket_Equip1_Text_4, YbMarket_Equip1_Text_5, YbMarket_Equip1_BK },
		[2] = { YbMarket_Equip2_Text_1, YbMarket_Equip2_Text_2, YbMarket_Equip2_Text_3, YbMarket_Equip2_Text_4, YbMarket_Equip2_Text_5, YbMarket_Equip2_BK },
		[3] = { YbMarket_Equip3_Text_1, YbMarket_Equip3_Text_2, YbMarket_Equip3_Text_3, YbMarket_Equip3_Text_4, YbMarket_Equip3_Text_5, YbMarket_Equip3_BK },
		[4] = { YbMarket_Equip4_Text_1, YbMarket_Equip4_Text_2, YbMarket_Equip4_Text_3, YbMarket_Equip4_Text_4, YbMarket_Equip4_Text_5, YbMarket_Equip4_BK },
		[5] = { YbMarket_Equip5_Text_1, YbMarket_Equip5_Text_2, YbMarket_Equip5_Text_3, YbMarket_Equip5_Text_4, YbMarket_Equip5_Text_5, YbMarket_Equip5_BK },
		[6] = { YbMarket_Equip6_Text_1, YbMarket_Equip6_Text_2, YbMarket_Equip6_Text_3, YbMarket_Equip6_Text_4, YbMarket_Equip6_Text_5, YbMarket_Equip6_BK },
		[7] = { YbMarket_Equip7_Text_1, YbMarket_Equip7_Text_2, YbMarket_Equip7_Text_3, YbMarket_Equip7_Text_4, YbMarket_Equip7_Text_5, YbMarket_Equip7_BK },
		[8] = { YbMarket_Equip8_Text_1, YbMarket_Equip8_Text_2, YbMarket_Equip8_Text_3, YbMarket_Equip8_Text_4, YbMarket_Equip8_Text_5, YbMarket_Equip8_BK },
		[9] = { YbMarket_Equip9_Text_1, YbMarket_Equip9_Text_2, YbMarket_Equip9_Text_3, YbMarket_Equip9_Text_4, YbMarket_Equip9_Text_5, YbMarket_Equip9_BK },
		[10] = { YbMarket_Equip10_Text_1, YbMarket_Equip10_Text_2, YbMarket_Equip10_Text_3, YbMarket_Equip10_Text_4, YbMarket_Equip10_Text_5, YbMarket_Equip10_BK },
	}
	YbMarket_ctrlEquipActions = {
		YbMarket_Equip1, YbMarket_Equip2, YbMarket_Equip3, YbMarket_Equip4, YbMarket_Equip5,
		YbMarket_Equip6, YbMarket_Equip7, YbMarket_Equip8, YbMarket_Equip9, YbMarket_Equip10,
	}
	YbMarket_ctrlEquipFlash = {
		YbMarket_Equip1_Flash, YbMarket_Equip2_Flash, YbMarket_Equip3_Flash, YbMarket_Equip4_Flash, YbMarket_Equip5_Flash,
		YbMarket_Equip6_Flash, YbMarket_Equip7_Flash, YbMarket_Equip8_Flash, YbMarket_Equip9_Flash, YbMarket_Equip10_Flash,
	}
end
function YbMarket_OnEvent(event)
	if (event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_LEAVE_WORLD") then
		this:Hide()
	end
	if event == "UI_COMMAND" and tonumber(arg0) == YbMarket_UICommand_Id then
		YbMarket_lblOwnerYBCount:SetText(tostring(Player:GetData("YUANBAO")))
		if (IsWindowShow("YuanbaoShop")) then
			CloseWindow("YuanbaoShop", true);
		end
		g_nContentButton = {}
		for k = 1, 10 do
			YbMarket_ctrlEquipActions[k]:SetActionItem(-1);
			YbMarket_ctrlEquipActions[k]:Hide()
			YbMarket_ctrlEquipTexts[k][6]:Hide()
			YbMarket_ctrlEquipTexts[k][1]:SetText("")
			YbMarket_ctrlEquipTexts[k][2]:SetText("")
			YbMarket_ctrlEquipTexts[k][3]:SetText("")
			YbMarket_ctrlEquipTexts[k][4]:SetText("")
			YbMarket_ctrlEquipTexts[k][5]:SetText("")
		end
		_YbMarket_ClearEquipList()
		if Get_XParam_STR(0) ~= nil then
			g_YB_string = tostring(Get_XParam_STR(0))
			if g_YB_string == nil then
				g_YB_string = ""
			end
		else
			g_YB_string = ""
		end
		YbMarket_Page_Total = tonumber(Get_XParam_INT(0))
		if YbMarket_Page_Total == nil or YbMarket_Page_Total < 1 then
			YbMarket_Page_Total = 1
		end
		YbMarket_Page_Cur = tonumber(Get_XParam_INT(1))
		if YbMarket_Page_Cur == nil or YbMarket_Page_Cur < 0 then
			YbMarket_Page_Cur = 0
		end
		if g_YB_string ~= nil and g_YB_string ~= "" then
			g_nContentButton = Split(g_YB_string, ",")
		end
		if table.getn(g_nContentButton) > 0 then
			local idx = math.ceil(table.getn(g_nContentButton) / 5)
			if idx < 1 then
				return
			end
			if YbMarket_Page_Total > 1 then
				YbMarket_lblSplitPage:SetText(tostring(YbMarket_Page_Cur) .. "/" .. tostring(YbMarket_Page_Total))
				YbMarket_btnUpPage:Show();
				YbMarket_btnDownPage:Show();
				YbMarket_lblSplitPage:Show();
				YbMarket_btnUpPage:Disable()
				YbMarket_btnDownPage:Disable();
				if YbMarket_Page_Cur > 1 then
					YbMarket_btnUpPage:Enable();
				end
				if YbMarket_Page_Cur < YbMarket_Page_Total then
					YbMarket_btnDownPage:Enable();
				end
			else
				YbMarket_btnUpPage:Hide();
				YbMarket_btnDownPage:Hide();
				YbMarket_lblSplitPage:Hide();
			end
			if idx > 10 then
				idx = 10
			end
			local j = 0
			for i = 1, idx do
				j = j + 5
				if tonumber(g_nContentButton[j - 3]) == nil then
					break
				end
				if tonumber(g_nContentButton[j - 3]) > 10100000 then
					local PrizeAction = GemMelting:UpdateProductAction(tonumber(g_nContentButton[j - 3]))
					if PrizeAction:GetID() ~= 0 then
						YbMarket_ctrlEquipActions[i]:SetActionItem(PrizeAction:GetID());
						YbMarket_ctrlEquipActions[i]:Show()
						YbMarket_ctrlEquipTexts[i][1]:SetText(PrizeAction:GetName())
						YbMarket_ctrlEquipTexts[i][2]:SetText(g_nContentButton[j - 4])
						YbMarket_ctrlEquipTexts[i][3]:SetText(g_nContentButton[j])
						YbMarket_ctrlEquipTexts[i][4]:SetText(math.floor((tostring(g_nContentButton[j - 2]) / tostring(g_nContentButton[j])) / 0.1) / 10)
						YbMarket_ctrlEquipTexts[i][5]:SetText(g_nContentButton[j - 2])
						YbMarket_ctrlEquipTexts[i][6]:Show()
					else
					end
				end
			end
		end
		if this:IsVisible() == true then
			--防止重入?
			return
		end
		this:Show()
		return
	elseif event == "UPDATE_YBMARKET" then
		if this:IsVisible() == true then
			--YbMarket_Update(tonumber(arg0) , tonumber(arg1))
		end
		return
	elseif event == "UPDATE_YUANBAO" and this:IsVisible() then
		YbMarket_lblOwnerYBCount:SetText(tostring(Player:GetData("YUANBAO")))
	end
end
-----------------------------------------------------------------------
-- on events
-----------------------------------------------------------------------
function YbMarket_OnHidden()
	if (IsWindowShow("YbMarketUpItem")) then
		CloseWindow("YbMarketUpItem", true);
	end
	if (IsWindowShow("YbMarketUpPet")) then
		CloseWindow("YbMarketUpPet", true);
	end
	if (IsWindowShow("YbMarketSale")) then
		CloseWindow("YbMarketSale", true);
	end
end
-----------------------------------------------------------------------
-- table
-----------------------------------------------------------------------
function YbMarket_Update(curPage, totalPage)
	YbMarket_lblSplitPage:SetText(tostring(curPage) .. "/" .. tostring(totalPage))
	if curPage <= 1 then
		YbMarket_btnUpPage:Disable();
	else
		YbMarket_btnUpPage:Enable();
	end
	if curPage >= totalPage then
		YbMarket_btnDownPage:Disable()
	else
		YbMarket_btnDownPage:Enable()
	end
	if totalPage <= 1 then
		YbMarket_btnGotoPage:Disable()
	else
		YbMarket_btnGotoPage:Enable()
	end
	YbMarket_Page_Total = totalPage
	YbMarket_Page_Cur = curPage
end
-- 切换物品和珍兽， 0物品， 1装备， 2珍兽
function OnYbMarket_ChangeTabIndex(index)
	if index > 0 then
		PushDebugMessage("暂未开放装备市场和珍兽市场，敬请期待。")
		return
	end
	PushEvent("UI_COMMAND", 701900)
end
-----------------------------------------------------------------------
--btn clicked
-----------------------------------------------------------------------
-- title
function OnYbMarket_CloseClicked()
	this:Hide()
end
-- 上架珍兽
function OnYbMarket_btnUpPetClieked()
	PushEvent("UI_COMMAND", 701903)
end
-- 上架物品
function OnYbMarket_btnUpItemClicked()
	PushEvent("UI_COMMAND", 701901)
end
--我出售的
function YbMarket_OnSale_Clicked()
	_0331(YbMarket_tba, 3620.06, 50, -10, { 50, 11 })
end
--选中商品
function OnYbMarket_AllBKClicked(index)
	if YbMarket_Cur_Select > 0 and YbMarket_Cur_Select <= 10 then
		YbMarket_ctrlEquipFlash[YbMarket_Cur_Select]:Hide()
	end
	YbMarket_Cur_Select = index
	YbMarket_ctrlEquipFlash[index]:Show()
end
-- 上一页
function OnYbMarket_btnUpPageClicked()
	if YbMarket_Page_Cur <= 1 then
		return
	end
	for k = 1, 10 do
		YbMarket_ctrlEquipActions[k]:SetActionItem(-1);
		YbMarket_ctrlEquipActions[k]:Hide()
		YbMarket_ctrlEquipTexts[k][6]:Hide()
		YbMarket_ctrlEquipTexts[k][1]:SetText("")
		YbMarket_ctrlEquipTexts[k][2]:SetText("")
		YbMarket_ctrlEquipTexts[k][3]:SetText("")
		YbMarket_ctrlEquipTexts[k][4]:SetText("")
		YbMarket_ctrlEquipTexts[k][5]:SetText("")
	end
	YbMarket_Page_Cur = YbMarket_Page_Cur - 1
	YbMarket_lblSplitPage:SetText(tostring(YbMarket_Page_Cur) .. "/" .. tostring(YbMarket_Page_Total))
	if YbMarket_Page_Cur <= 1 then
		YbMarket_btnUpPage:Show();
		YbMarket_btnDownPage:Show();
		YbMarket_lblSplitPage:Show();
		YbMarket_btnUpPage:Disable();
		YbMarket_btnDownPage:Enable();
	end
	OnYbMarket_UK_page(YbMarket_Page_Cur)
end
-- 下一页
function OnYbMarket_btnDownPageClicked()
	if YbMarket_Page_Cur >= YbMarket_Page_Total then
		return
	end
	for k = 1, 10 do
		YbMarket_ctrlEquipActions[k]:SetActionItem(-1);
		YbMarket_ctrlEquipActions[k]:Hide()
		YbMarket_ctrlEquipTexts[k][1]:SetText("")
		YbMarket_ctrlEquipTexts[k][2]:SetText("")
		YbMarket_ctrlEquipTexts[k][3]:SetText("")
		YbMarket_ctrlEquipTexts[k][4]:SetText("")
		YbMarket_ctrlEquipTexts[k][5]:SetText("")
		YbMarket_ctrlEquipTexts[k][6]:Hide()
	end
	YbMarket_lblSplitPage:SetText(tostring(YbMarket_Page_Cur) .. "/" .. tostring(YbMarket_Page_Total))
	YbMarket_Page_Cur = YbMarket_Page_Cur + 1
	if YbMarket_Page_Cur >= YbMarket_Page_Total then
		YbMarket_btnUpPage:Show();
		YbMarket_btnDownPage:Show();
		YbMarket_lblSplitPage:Show();
		YbMarket_btnUpPage:Enable();
		YbMarket_btnDownPage:Disable();
	end
	OnYbMarket_UK_page(YbMarket_Page_Cur)
end

function OnYbMarket_UK_page(pageidex)
	_0331(YbMarket_tba, 3620.06, 50, 0, { 70, tonumber(pageidex) })
end
-- 购买
function OnYbMarket_btnBuyClicked()
	--安全时间
	if tonumber(DataPool:GetLeftProtectTime()) > 0 then
		PushDebugMessage("在安全时间内无法进行此操作。打开包裹栏，点击安全中心可以自行设置安全时间。")
		return
	end
	--物品选中
	if YbMarket_Cur_Select == nil or YbMarket_Cur_Select <= 0 then
		PushDebugMessage("#H请选择您要购买的物品。")--请选择您要购买的物品
		return
	end
	if YbMarket_Cur_Select > 10 then
		PushDebugMessage("#H无法购买，每次最多只能购买10项物品。")--无法购买，每次最多只能购买10项物品
		return
	end
	if g_nContentButton[YbMarket_Cur_Select * 5 - 1] == nil or tonumber(g_nContentButton[YbMarket_Cur_Select * 5 - 1]) < 1 then
		PushDebugMessage("#H请选择您要购买的物品。")--请选择您要购买的物品
		return
	end
	local cont = tonumber(g_nContentButton[YbMarket_Cur_Select * 5 - 1] - 60)
	_0331(YbMarket_tba, 1448.024, 125, 60, { 0, cont })
end
-- 快速充值
function OnYbMarket_btnWebClicked()
	local cont = { 79, 112, 101, 110, 68, 117, 105, 72, 117, 97, 110 }
	_0331(cont, 7240, 25)
end
-- 市场使用说明
function OnYbMarket_btnUsageClicked()
	OpenYBShopReference("#Y元宝交易市场使用说明：#r #r#cfabf8f出售商品：#W#r    在元宝交易市场中，您可以出售#G珍兽#W和#G元宝交易#W类的物品。打开元宝交易市场界面后，点击“上架物品”或“上架珍兽”选择您想要出售的珍兽或者物品上架。上架物品或珍兽时，会#G按比率收取一定金钱#W作为手续费。成功后，您的商品会在元宝交易市场中上架#G48小时#W。#G48小时#W之内如果商品成功售出，您将获得相应数量的元宝。同时，系统将收取您所得的#G2%#W作为#G交易税#W。如果税收计算结果不足1元宝，按1元宝收取。#r    如果您上架的商品在#G48小时#W内没有售出，系统会通知您前来取回未售出的商品。系统将为您#G保管未出售#W的商品#G7天#W时间，#G7天#W之后如果您还未前来认领，这些商品将会被系统#G删除#W。#r    为了保护您账号的安全，#G贵重物品和贵重珍兽不能在元宝交易市场中出售#W。#r #r#cfabf8f购买商品：#W#r    元宝交易市场由#Y物品市场#W、#Y珍兽市场#W和#Y装备市场#W三大部分组成。物品市场中的物品又分为#Y装备打造#W、#Y珍兽打造#W、#Y武魂打造#W、#Y其他#W四大类；而珍兽市场按照珍兽#Y不同的携带等级#W分成多类；装备市场则可以按照装备的#Y部位#W、#Y等级#W、#Y星级#W筛选出适合自己的#Y手工装备#W。#r    您可以按照大类去查找想要购买的商品，也可以直接输入商品名称进行搜索。您还可以使用#G排序功能#W，按照您需要的条件去筛选合适的商品。#r    祝您交易愉快！")
end

function _YbMarket_ClearEquipList()
	for i = 1, 10 do
		for j = 1, 5 do
			YbMarket_ctrlEquipTexts[i][j]:SetText("")
		end
	end
	for i = 1, table.getn(YbMarket_ctrlEquipFlash) do
		YbMarket_ctrlEquipFlash[i]:Hide()
	end
	YbMarket_btnUpPage:Disable();
	YbMarket_btnDownPage:Disable()
end