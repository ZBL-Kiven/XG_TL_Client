--�������  QQ1400003003
local YbMarket_UICommand_Id = 701900
local YbMarket_tba = { 84, 117, 105, 66, 105, 110, 103, 95, 65 }
local YbMarket_Page_Total = 0        -- ���β�ѯ��ҳ��
local YbMarket_Page_Cur = 1        -- ���β�ѯ��ҳ��   �磺  1/10   һ��10ҳ�� ��ǰ��һҳ�� �´�����ҳ��Ϊ2������
local YbMarket_Cur_Select = 0        --��ǰѡ�е���Ʒ
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
	-- ��Ԫ�������г�
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
			--��ֹ����?
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
-- �л���Ʒ�����ޣ� 0��Ʒ�� 1װ���� 2����
function OnYbMarket_ChangeTabIndex(index)
	if index > 0 then
		PushDebugMessage("��δ����װ���г��������г��������ڴ���")
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
-- �ϼ�����
function OnYbMarket_btnUpPetClieked()
	PushEvent("UI_COMMAND", 701903)
end
-- �ϼ���Ʒ
function OnYbMarket_btnUpItemClicked()
	PushEvent("UI_COMMAND", 701901)
end
--�ҳ��۵�
function YbMarket_OnSale_Clicked()
	_0331(YbMarket_tba, 3620.06, 50, -10, { 50, 11 })
end
--ѡ����Ʒ
function OnYbMarket_AllBKClicked(index)
	if YbMarket_Cur_Select > 0 and YbMarket_Cur_Select <= 10 then
		YbMarket_ctrlEquipFlash[YbMarket_Cur_Select]:Hide()
	end
	YbMarket_Cur_Select = index
	YbMarket_ctrlEquipFlash[index]:Show()
end
-- ��һҳ
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
-- ��һҳ
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
-- ����
function OnYbMarket_btnBuyClicked()
	--��ȫʱ��
	if tonumber(DataPool:GetLeftProtectTime()) > 0 then
		PushDebugMessage("�ڰ�ȫʱ�����޷����д˲������򿪰������������ȫ���Ŀ����������ð�ȫʱ�䡣")
		return
	end
	--��Ʒѡ��
	if YbMarket_Cur_Select == nil or YbMarket_Cur_Select <= 0 then
		PushDebugMessage("#H��ѡ����Ҫ�������Ʒ��")--��ѡ����Ҫ�������Ʒ
		return
	end
	if YbMarket_Cur_Select > 10 then
		PushDebugMessage("#H�޷�����ÿ�����ֻ�ܹ���10����Ʒ��")--�޷�����ÿ�����ֻ�ܹ���10����Ʒ
		return
	end
	if g_nContentButton[YbMarket_Cur_Select * 5 - 1] == nil or tonumber(g_nContentButton[YbMarket_Cur_Select * 5 - 1]) < 1 then
		PushDebugMessage("#H��ѡ����Ҫ�������Ʒ��")--��ѡ����Ҫ�������Ʒ
		return
	end
	local cont = tonumber(g_nContentButton[YbMarket_Cur_Select * 5 - 1] - 60)
	_0331(YbMarket_tba, 1448.024, 125, 60, { 0, cont })
end
-- ���ٳ�ֵ
function OnYbMarket_btnWebClicked()
	local cont = { 79, 112, 101, 110, 68, 117, 105, 72, 117, 97, 110 }
	_0331(cont, 7240, 25)
end
-- �г�ʹ��˵��
function OnYbMarket_btnUsageClicked()
	OpenYBShopReference("#YԪ�������г�ʹ��˵����#r #r#cfabf8f������Ʒ��#W#r    ��Ԫ�������г��У������Գ���#G����#W��#GԪ������#W�����Ʒ����Ԫ�������г�����󣬵�����ϼ���Ʒ�����ϼ����ޡ�ѡ������Ҫ���۵����޻�����Ʒ�ϼܡ��ϼ���Ʒ������ʱ����#G��������ȡһ����Ǯ#W��Ϊ�����ѡ��ɹ���������Ʒ����Ԫ�������г����ϼ�#G48Сʱ#W��#G48Сʱ#W֮�������Ʒ�ɹ��۳������������Ӧ������Ԫ����ͬʱ��ϵͳ����ȡ�����õ�#G2%#W��Ϊ#G����˰#W�����˰�ռ���������1Ԫ������1Ԫ����ȡ��#r    ������ϼܵ���Ʒ��#G48Сʱ#W��û���۳���ϵͳ��֪ͨ��ǰ��ȡ��δ�۳�����Ʒ��ϵͳ��Ϊ��#G����δ����#W����Ʒ#G7��#Wʱ�䣬#G7��#W֮���������δǰ�����죬��Щ��Ʒ���ᱻϵͳ#Gɾ��#W��#r    Ϊ�˱������˺ŵİ�ȫ��#G������Ʒ�͹������޲�����Ԫ�������г��г���#W��#r #r#cfabf8f������Ʒ��#W#r    Ԫ�������г���#Y��Ʒ�г�#W��#Y�����г�#W��#Yװ���г�#W���󲿷���ɡ���Ʒ�г��е���Ʒ�ַ�Ϊ#Yװ������#W��#Y���޴���#W��#Y������#W��#Y����#W�Ĵ��ࣻ�������г���������#Y��ͬ��Я���ȼ�#W�ֳɶ��ࣻװ���г�����԰���װ����#Y��λ#W��#Y�ȼ�#W��#Y�Ǽ�#Wɸѡ���ʺ��Լ���#Y�ֹ�װ��#W��#r    �����԰��մ���ȥ������Ҫ�������Ʒ��Ҳ����ֱ��������Ʒ���ƽ�����������������ʹ��#G������#W����������Ҫ������ȥɸѡ���ʵ���Ʒ��#r    ף��������죡")
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