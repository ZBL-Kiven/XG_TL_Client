local GOODS_BUTTONS_NUM = 18;
local GOODS_BUTTONS = {};
local GOODS_DESCS = {};
local GOOD_BAD    = {};

--��ǩҳ����ֵ
local ShopTabIdx = {
	YuanBao 	= 0,	--Ԫ���̵�
	Bind		= 1,	--��Ԫ���̵�
}

local SHOP_LIST_A = {};
local SHOP_LIST_B = {};
local SHOP_SEARCH_LIST ={};

local SHOP_LIST_A_BIND = {};
local SHOP_LIST_B_BIND = {};
local SHOP_SEARCH_LIST_BIND ={};

local nPageNum = 1;
local maxPage = 1;
local objCared = -1;
local lastA = 0
local lastB = 0
local lastA_Bind = 0
local lastB_Bind = 0
local lastSelect = 0
local lastSelect_Bind = 0
local nYuanBaoShopPrice = {}
local maxChildShop = 8
local isCareObj = 0

--�洢������������ֵ
local	g_tOrderPool	= {};
--��ǰ�̵����Ʒ����
local	g_nTotalNum		= 0;

local	g_changeTabFlag	= 0;
local	g_tabIndex	= 0;		-- 0��ʾԪ�� --1��ʾ��Ԫ��

local g_YuanbaoShop_Frame_UnifiedXPosition;
local g_YuanbaoShop_Frame_UnifiedYPosition;

function YuanbaoShop_PreLoad()

	this:RegisterEvent("OPEN_YUANBAOSHOP");
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("UPDATE_BOOTH");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("CLOSE_BOOTH");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	this:RegisterEvent("TOGGLE_YUANBAOSHOP");
	this:RegisterEvent("UPDATE_YUANBAO");
	this:RegisterEvent("UPDATE_ZENGDIAN");
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function YuanbaoShop_OnLoad()
	GOODS_BUTTONS[1] = YuanbaoShop_Item1;
	GOODS_BUTTONS[2] = YuanbaoShop_Item2;
	GOODS_BUTTONS[3] = YuanbaoShop_Item3;
	GOODS_BUTTONS[4] = YuanbaoShop_Item4;
	GOODS_BUTTONS[5] = YuanbaoShop_Item5;
	GOODS_BUTTONS[6] = YuanbaoShop_Item6;
	GOODS_BUTTONS[7] = YuanbaoShop_Item7;
	GOODS_BUTTONS[8] = YuanbaoShop_Item8;
	GOODS_BUTTONS[9] = YuanbaoShop_Item9;
	GOODS_BUTTONS[10]= YuanbaoShop_Item10;
	GOODS_BUTTONS[11]= YuanbaoShop_Item11;
	GOODS_BUTTONS[12]= YuanbaoShop_Item12;
	GOODS_BUTTONS[13]= YuanbaoShop_Item13;
	GOODS_BUTTONS[14]= YuanbaoShop_Item14;
	GOODS_BUTTONS[15]= YuanbaoShop_Item15;
	GOODS_BUTTONS[16]= YuanbaoShop_Item16;
	GOODS_BUTTONS[17]= YuanbaoShop_Item17;
	GOODS_BUTTONS[18]= YuanbaoShop_Item18;

	GOODS_DESCS[1] = YuanbaoShop_ItemInfo1_Text;
	GOODS_DESCS[2] = YuanbaoShop_ItemInfo2_Text;
	GOODS_DESCS[3] = YuanbaoShop_ItemInfo3_Text;
	GOODS_DESCS[4] = YuanbaoShop_ItemInfo4_Text;
	GOODS_DESCS[5] = YuanbaoShop_ItemInfo5_Text;
	GOODS_DESCS[6] = YuanbaoShop_ItemInfo6_Text;
	GOODS_DESCS[7] = YuanbaoShop_ItemInfo7_Text;
	GOODS_DESCS[8] = YuanbaoShop_ItemInfo8_Text;
	GOODS_DESCS[9] = YuanbaoShop_ItemInfo9_Text;
	GOODS_DESCS[10]= YuanbaoShop_ItemInfo10_Text;
	GOODS_DESCS[11]= YuanbaoShop_ItemInfo11_Text;
	GOODS_DESCS[12]= YuanbaoShop_ItemInfo12_Text;
	GOODS_DESCS[13]= YuanbaoShop_ItemInfo13_Text;
	GOODS_DESCS[14]= YuanbaoShop_ItemInfo14_Text;
	GOODS_DESCS[15]= YuanbaoShop_ItemInfo15_Text;
	GOODS_DESCS[16]= YuanbaoShop_ItemInfo16_Text;
	GOODS_DESCS[17]= YuanbaoShop_ItemInfo17_Text;
	GOODS_DESCS[18]= YuanbaoShop_ItemInfo18_Text;

	GOOD_BAD[1]  =     YuanbaoShop_ItemInfo1_GB;
	GOOD_BAD[2]  =     YuanbaoShop_ItemInfo2_GB;
	GOOD_BAD[3]  =     YuanbaoShop_ItemInfo3_GB;
	GOOD_BAD[4]  =     YuanbaoShop_ItemInfo4_GB;
	GOOD_BAD[5]  =     YuanbaoShop_ItemInfo5_GB;
	GOOD_BAD[6]  =     YuanbaoShop_ItemInfo6_GB;
	GOOD_BAD[7]  =     YuanbaoShop_ItemInfo7_GB;
	GOOD_BAD[8]  =     YuanbaoShop_ItemInfo8_GB;
	GOOD_BAD[9]  =     YuanbaoShop_ItemInfo9_GB;
	GOOD_BAD[10] =     YuanbaoShop_ItemInfo10_GB;
	GOOD_BAD[11] =     YuanbaoShop_ItemInfo11_GB;
	GOOD_BAD[12] =     YuanbaoShop_ItemInfo12_GB;
	GOOD_BAD[13] =     YuanbaoShop_ItemInfo13_GB;
	GOOD_BAD[14] =     YuanbaoShop_ItemInfo14_GB;
	GOOD_BAD[15] =     YuanbaoShop_ItemInfo15_GB;
	GOOD_BAD[16] =     YuanbaoShop_ItemInfo16_GB;
	GOOD_BAD[17] =     YuanbaoShop_ItemInfo17_GB;
	GOOD_BAD[18] =     YuanbaoShop_ItemInfo18_GB;

	--������
	SHOP_LIST_A[1] = {btn = YuanbaoShop_Button1 , shoplist = {}}
	SHOP_LIST_A[1].shoplist[1] = "��Ʒ�ϼ�"	--"��Ʒ�ϼ�";
	SHOP_LIST_A[1].shoplist[2] = "�����̵�"	--"�����̵�";
	SHOP_LIST_A[1].shoplist[3] = "����ר��"	--"�ؼ���Ʒ";

	--��ʯ�̳�
	SHOP_LIST_A[2] = {btn = YuanbaoShop_Button2 , shoplist = {}}
	SHOP_LIST_A[2].shoplist[1] = "����ʯի"	--"����ʯի";
	SHOP_LIST_A[2].shoplist[2] = "������ʯի"	--"���ݱ�ʯի";
	SHOP_LIST_A[2].shoplist[3] = "���ݱ�ʯի"	--"������ʯի";
	SHOP_LIST_A[2].shoplist[4] = "¥����ʯի"	--"������ʯի";
	SHOP_LIST_A[2].shoplist[5] = "��ʯ������"	--"��ʯ������";
	SHOP_LIST_A[2].shoplist[6] = "��ʯ�ӹ���"	--"��ʯ�ӹ���";

	--�����̳�
	SHOP_LIST_A[3] = {btn = YuanbaoShop_Button3 , shoplist = {}}
	SHOP_LIST_A[3].shoplist[1] = "ϡ�����޹�"	--"ϡ�����޹�";
	SHOP_LIST_A[3].shoplist[2] = "��ͨ���ܹ�"	--"�߼����ܹ�";
	SHOP_LIST_A[3].shoplist[3] = "�߼����ܹ�"	--"������ҩ��";
	SHOP_LIST_A[3].shoplist[4] = "������ҩ��"	--"������ҩ��";

	--�ϱ��ӻ�
	SHOP_LIST_A[4] = {btn = YuanbaoShop_Button4 , shoplist = {}}
	SHOP_LIST_A[4].shoplist[1] = "#{YBSD_081225_091}"	--"�ɵ���ҩ";
	SHOP_LIST_A[4].shoplist[2] = "�칤����"	--"�칤����";
	SHOP_LIST_A[4].shoplist[3] = "#{YBSD_081225_031}"	--"�����챦";
	SHOP_LIST_A[4].shoplist[4] = "#{YBSD_081225_032}"	--"�������";

	--����㳡
	SHOP_LIST_A[5] = {btn = YuanbaoShop_Button5 , shoplist = {}}
	SHOP_LIST_A[5].shoplist[1] = "�þ�ʱװ��"	--�þ�ʱװ��
	SHOP_LIST_A[5].shoplist[2] = "ʱ��ʱװ��"	--ʱ��ʱװ��
	SHOP_LIST_A[5].shoplist[3] = "�������ݷ�"	--����ʱװ��	
	SHOP_LIST_A[5].shoplist[4] = "�칬�����"	--����ʱװ��		

	--�����˼�
	SHOP_LIST_A[6] = {btn = YuanbaoShop_Button6 , shoplist = {}}
	SHOP_LIST_A[6].shoplist[1] = "���ǰٻ�"	--"��ͳ�̻�";

	--�书�ؼ�
	SHOP_LIST_A[7] = {btn = YuanbaoShop_Button7 , shoplist = {}}
	SHOP_LIST_A[7].shoplist[1] = "#{YBSD_081225_042}"	--"��ʩˮ��";
	--����ͼ
	SHOP_LIST_A[8] = {btn = YuanbaoShop_Button8 , shoplist = {}}
	SHOP_LIST_A[8].shoplist[1] = "#{YBSD_081225_043}"	--"������ǹ��";
	SHOP_LIST_A[8].shoplist[2] = "#{YBSD_081225_044}"	--"���̺�˫��";
	SHOP_LIST_A[8].shoplist[3] = "#{YBSD_081225_045}"	--"�Ⱥͻ�";
	SHOP_LIST_A[8].shoplist[4] = "#{YBSD_081225_096}"	--"�·���ñ��";
	SHOP_LIST_A[8].shoplist[5] = "#{YBSD_081225_046}"	--"���׺�Ь��";
	SHOP_LIST_A[8].shoplist[6] = "#{YBSD_081225_047}"	--"����ͻ���";
	SHOP_LIST_A[8].shoplist[7] = "#{YBSD_081225_048}"	--"����������";
	SHOP_LIST_A[8].shoplist[8] = "#{YBSD_081225_049}"	--"��ָ�ͻ���";

	--�����̵�
	SHOP_LIST_B[1] = YuanbaoShop_Button01
	SHOP_LIST_B[2] = YuanbaoShop_Button02
	SHOP_LIST_B[3] = YuanbaoShop_Button03
	SHOP_LIST_B[4] = YuanbaoShop_Button04
	SHOP_LIST_B[5] = YuanbaoShop_Button05
	SHOP_LIST_B[6] = YuanbaoShop_Button06
	SHOP_LIST_B[7] = YuanbaoShop_Button07
	SHOP_LIST_B[8] = YuanbaoShop_Button08


	if lastA ~= nil and lastA > 0 and lastA < 9 then
		SHOP_LIST_A[lastA].btn:SetCheck(1)
	end

	if lastB ~= nil and lastB > 0 and lastB < 9 then
		SHOP_LIST_B[lastB]:SetCheck(1)
	end
	YuanbaoShop_Dis3:Hide()
	for i =1 ,8 do
		SHOP_LIST_B[i]:Hide()
	end


	--��Ҫ��ǿ��
	SHOP_SEARCH_LIST[1] = {}
	SHOP_SEARCH_LIST[1][1] = "#{YBSD_081225_023}"	--"���ݱ�ʯի";
	SHOP_SEARCH_LIST[1][2] = "#{YBSD_081225_024}"	--"������ʯի";
	SHOP_SEARCH_LIST[1][3] = "#{YBSD_081225_025}"	--"��ʯ������";
	SHOP_SEARCH_LIST[1][4] = "#{YBSD_081225_027}"	--"ϡ�����޹�";
	SHOP_SEARCH_LIST[1][5] = "#{YBSD_081225_091}"	--"�ɵ���ҩ";
	--��Ҫ��������
	SHOP_SEARCH_LIST[2] = {}
	SHOP_SEARCH_LIST[2][1] = "#{YBSD_081225_037}"	--"�����̳�";
	SHOP_SEARCH_LIST[2][2] = "#{YBSD_XML_1}"--�þ�ʱװ��
	SHOP_SEARCH_LIST[2][3] = "#{YBSD_XML_2}"--ʱ��ʱװ��
	SHOP_SEARCH_LIST[2][4] = "#{YBSD_081225_034}"	--"�������ի";
	SHOP_SEARCH_LIST[2][5] = "#{YBSD_081225_035}"	--"���﷢�չ�";
	SHOP_SEARCH_LIST[2][6] = "#{YBSD_081225_036}"	--"�������ݷ�";
	--��Ҫ���켫Ʒװ��
	SHOP_SEARCH_LIST[3] = {}
--	SHOP_SEARCH_LIST[3][1] = "#{YBSD_081225_022}"	--"����ʯի";
	SHOP_SEARCH_LIST[3][1] = "#{YBSD_081225_023}"	--"���ݱ�ʯի";
	SHOP_SEARCH_LIST[3][2] = "#{YBSD_081225_024}"	--"������ʯի";
	SHOP_SEARCH_LIST[3][3] = "#{YBSD_081225_026}"	--"��ʯ�ӹ���";
	SHOP_SEARCH_LIST[3][4] = "#{YBSD_XML_3}"	--"�칤����";
	SHOP_SEARCH_LIST[3][5] = "#{YBSD_081225_031}"	--"�����챦";
	--��Ҫ���켫Ʒ����
	SHOP_SEARCH_LIST[4] = {}
	SHOP_SEARCH_LIST[4][1] = "#{YBSD_081225_027}"	--"ϡ�����޹�";
	SHOP_SEARCH_LIST[4][2] = "#{YBSD_081225_028}"	--"��ͨ���ܹ�";
	SHOP_SEARCH_LIST[4][3] = "#{YBSD_081225_029}"	--"�߼����ܹ�";
	SHOP_SEARCH_LIST[4][4] = "#{YBSD_081225_030}"	--"������ҩ��";

	--��Ҫ�ƶ��ĸ���
	SHOP_SEARCH_LIST[5] = {}
	SHOP_SEARCH_LIST[5][1] = "#{YBSD_081225_037}"	--"�����̳�";
	SHOP_SEARCH_LIST[5][2] = "#{YBSD_081225_032}"	--"�������";
	--��Ҫ����˱��
	SHOP_SEARCH_LIST[6] = {}
	SHOP_SEARCH_LIST[6][1] = "#{YBSD_081225_039}"	--"�����̻�";
	SHOP_SEARCH_LIST[6][2] = "#{YBSD_081225_040}"	--"ȫ�����̻�";
	SHOP_SEARCH_LIST[6][3] = "#{YBSD_081225_041}"	--"�ʻ�";
	SHOP_SEARCH_LIST[6][4] = "#{YBSD_XML_1}"--�þ�ʱװ��
	SHOP_SEARCH_LIST[6][5] = "#{YBSD_XML_2}"--ʱ��ʱװ��
	SHOP_SEARCH_LIST[6][6] = "#{YBSD_081225_037}"	--"�����̳�";
	--��Ҫѧϰ�¼���
	SHOP_SEARCH_LIST[7] = {}
	SHOP_SEARCH_LIST[7][1] = "#{YBSD_081225_042}"	--"��ʩˮ��";
	--SHOP_SEARCH_LIST[7][2] = "#{YBSD_XML_4}"	--"��ʩˮ��";
	SHOP_SEARCH_LIST[7][2] = "#{YBSD_081225_028}"	--"��ͨ���ܹ�";
	SHOP_SEARCH_LIST[7][3] = "#{YBSD_081225_029}"	--"�߼����ܹ�";
	--�������
	SHOP_SEARCH_LIST[8] = {}
	SHOP_SEARCH_LIST[8][1] = "#{YBSD_xml_XX(01)}"	--"�������";


	YuanbaoShop_SearchMode:AddTextItem("#{YBSD_081225_055}" ,1)	--��Ҫ��ǿ��
	YuanbaoShop_SearchMode:AddTextItem("#{YBSD_081225_056}" ,2)	--"��Ҫ��������"
	YuanbaoShop_SearchMode:AddTextItem("#{YBSD_081225_057}" ,3)	--"��Ҫ���켫Ʒװ��"
	YuanbaoShop_SearchMode:AddTextItem("#{YBSD_081225_058}",4)	--"��Ҫ���켫Ʒ����"
	YuanbaoShop_SearchMode:AddTextItem("#{YBSD_081225_059}",5)	--"��Ҫ�ƶ��ĸ���"
	YuanbaoShop_SearchMode:AddTextItem("#{YBSD_081225_060}",6)	--"��Ҫ����˱��"
	YuanbaoShop_SearchMode:AddTextItem("#{YBSD_081225_061}",7)	--"��Ҫѧϰ�¼���"
	YuanbaoShop_SearchMode:AddTextItem("#{YBSD_xml_XX(02)}",8)	--"�鿴����������Ʒ"


	-- ��Ԫ��begin
	SHOP_LIST_A_BIND[1] = {btn = YuanbaoShop_Button1_Bind , shoplist = {}}
	SHOP_LIST_A_BIND[1].shoplist[1] = "��Ʒ�ϼ�"	--"��Ʒ�ϼ�";
	-- SHOP_LIST_A_BIND[1].shoplist[2] = "�����̳�"	--"��Ʒ�ϼ�";

	--
	SHOP_LIST_A_BIND[2] = {btn = YuanbaoShop_Button2_Bind , shoplist = {}}
	SHOP_LIST_A_BIND[2].shoplist[1] = "������ʯ"		--"";
	SHOP_LIST_A_BIND[2].shoplist[2] = "��ʯ�ӹ���"		--"";
	


	--
	SHOP_LIST_A_BIND[3] = {btn = YuanbaoShop_Button3_Bind , shoplist = {}}
	SHOP_LIST_A_BIND[3].shoplist[1] = "#{YBSD_081225_030}"		--"";

	--
	SHOP_LIST_A_BIND[4] = {btn = YuanbaoShop_Button4_Bind , shoplist = {}}
	SHOP_LIST_A_BIND[4].shoplist[1] = "�����챦"		--"";
	

	--
	SHOP_LIST_A_BIND[5] = {btn = YuanbaoShop_Button5_Bind , shoplist = {}}


	--
	SHOP_LIST_A_BIND[6] = {btn = YuanbaoShop_Button6_Bind , shoplist = {}}


	--
	SHOP_LIST_A_BIND[7] = {btn = YuanbaoShop_Button7_Bind , shoplist = {}}


	SHOP_LIST_A_BIND[8] = {btn = YuanbaoShop_Button8_Bind , shoplist = {}}


	--�����̵�
	SHOP_LIST_B_BIND[1] = YuanbaoShop_Button01_Bind
	SHOP_LIST_B_BIND[2] = YuanbaoShop_Button02_Bind
	SHOP_LIST_B_BIND[3] = YuanbaoShop_Button03_Bind
	SHOP_LIST_B_BIND[4] = YuanbaoShop_Button04_Bind
	SHOP_LIST_B_BIND[5] = YuanbaoShop_Button05_Bind
	SHOP_LIST_B_BIND[6] = YuanbaoShop_Button06_Bind
	SHOP_LIST_B_BIND[7] = YuanbaoShop_Button07_Bind
	SHOP_LIST_B_BIND[8] = YuanbaoShop_Button08_Bind


	if lastA_Bind ~= nil and lastA_Bind > 0 and lastA_Bind < 9 then
		SHOP_LIST_A_BIND[ lastA_Bind ].btn : SetCheck(1)
	end

	if lastB_Bind ~= nil and lastB_Bind > 0 and lastB_Bind < 9 then
		SHOP_LIST_B_BIND[ lastB_Bind ] : SetCheck(1)
	end

	for i =1 ,8 do
		SHOP_LIST_B_BIND[i]:Hide()
	end

	--
	SHOP_SEARCH_LIST_BIND[1] = {}
	SHOP_SEARCH_LIST_BIND[1][1] = "BindSearch1"	--"";
	SHOP_SEARCH_LIST_BIND[1][2] = "BindSearch1"	--"";
	SHOP_SEARCH_LIST_BIND[1][3] = "BindSearch1"	--"";
	SHOP_SEARCH_LIST_BIND[1][4] = "BindSearch1"	--"";
	SHOP_SEARCH_LIST_BIND[1][5] = "BindSearch1"	--"";
	--
	SHOP_SEARCH_LIST_BIND[2] = {}
	SHOP_SEARCH_LIST_BIND[2][1] = "BindSearch1"	--"";
	SHOP_SEARCH_LIST_BIND[2][2] = "BindSearch1"	--"";
	SHOP_SEARCH_LIST_BIND[2][3] = "BindSearch1"	--"";
	SHOP_SEARCH_LIST_BIND[2][4] = "BindSearch1"	--"";
	SHOP_SEARCH_LIST_BIND[2][5] = "BindSearch1"	--"";
	--
	SHOP_SEARCH_LIST_BIND[3] = {}
	SHOP_SEARCH_LIST_BIND[3][1] = "BindSearch1"	--"";
	SHOP_SEARCH_LIST_BIND[3][2] = "BindSearch1"	--"";
	SHOP_SEARCH_LIST_BIND[3][3] = "BindSearch1"	--"";
	SHOP_SEARCH_LIST_BIND[3][4] = "BindSearch1"	--"";

	--
	SHOP_SEARCH_LIST_BIND[4] = {}
	SHOP_SEARCH_LIST_BIND[4][1] = "BindSearch1"	--"";
	SHOP_SEARCH_LIST_BIND[4][2] = "BindSearch1"	--"";
	SHOP_SEARCH_LIST_BIND[4][3] = "BindSearch1"	--"";
	SHOP_SEARCH_LIST_BIND[4][4] = "BindSearch1"	--"";

	--
	SHOP_SEARCH_LIST_BIND[5] = {}
	SHOP_SEARCH_LIST_BIND[5][1] = "BindSearch1"	--"";
	SHOP_SEARCH_LIST_BIND[5][2] = "BindSearch1"	--"";
	--
	SHOP_SEARCH_LIST_BIND[6] = {}
	SHOP_SEARCH_LIST_BIND[6][1] = "BindSearch1"	--"";
	SHOP_SEARCH_LIST_BIND[6][2] = "BindSearch1"	--"";
	SHOP_SEARCH_LIST_BIND[6][3] = "BindSearch1"	--"";
	SHOP_SEARCH_LIST_BIND[6][4] = "BindSearch1"	--"";
	SHOP_SEARCH_LIST_BIND[6][5] = "BindSearch1"	--"";
	--
	SHOP_SEARCH_LIST_BIND[7] = {}
	SHOP_SEARCH_LIST_BIND[7][1] = "BindSearch1"	--"";
	SHOP_SEARCH_LIST_BIND[7][2] = "BindSearch1"	--"";
	SHOP_SEARCH_LIST_BIND[7][3] = "BindSearch1"	--"";


	YuanbaoShop_SearchMode_Bind:AddTextItem("BindSearch1}" ,1)	--
	YuanbaoShop_SearchMode_Bind:AddTextItem("BindSearch2}" ,2)	--""
	YuanbaoShop_SearchMode_Bind:AddTextItem("BindSearch3}" ,3)	--""
	YuanbaoShop_SearchMode_Bind:AddTextItem("BindSearch4}",4)		--""
	YuanbaoShop_SearchMode_Bind:AddTextItem("BindSearch5}",5)		--""
	YuanbaoShop_SearchMode_Bind:AddTextItem("BindSearch6}",6)		--""
	YuanbaoShop_SearchMode_Bind:AddTextItem("BindSearch7}",7)		--""


	YuanbaoShop_Bk1_Bind : Hide();
	YuanbaoShop_Bk2_Bind : Hide();
	YuanbaoShop_SearchMode_Bind : Hide();
	YuanbaoShop_Text2_Bind : Hide();
	YuanbaoShop_Bk4 : Hide();
	-- ��Ԫ��end
	
g_YuanbaoShop_Frame_UnifiedXPosition	= YuanbaoShop_Frame:GetProperty("UnifiedXPosition");
g_YuanbaoShop_Frame_UnifiedYPosition	= YuanbaoShop_Frame:GetProperty("UnifiedYPosition");

end


function YuanbaoShop_OnEvent(event)

	if ( event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_LEAVE_WORLD") then
		YuanbaoShop_Close()
	end

	if event == "OPEN_YUANBAOSHOP" then
		g_nTotalNum	= 0;
		local check  = tonumber(NpcShop:GetBuyDirectly());
		if(check>=1)then
			YuanbaoShop_querengoumai:SetCheck(0);
		else
			YuanbaoShop_querengoumai:SetCheck(1);
		end
		if( this:IsVisible() == false ) then
			YubanbaoShop_ADRandom()
			if (IsWindowShow("YbMarket")) then
				CloseWindow("YbMarket", true);
			end
			this:Show();
			OpenWindow("Packet")

			-- ���ȴ�NPC�̵꣬���Ԫ���̵��ʱ�򣬴���һ������
			-- Ԫ���̵��ڴ�ʱ��ر��Ѿ��򿪵�NPC�̵꣬���ر���������Ὣ�Ƿ���̵����״ֻ̬Ϊ�٣��Ӷ����¹�����ص��߼����ִ���
			-- Ŀǰ�Ľ���취����Show�ĵط��������Ƿ���̵��״̬Ϊ�档
			OpenBooth();
		end

		--��������Obj
		objCared = NpcShop:GetNpcId();
		this:CareObject(objCared, 1, "YuanbaoShop");

		NpcShop:CloseConfirm();
		YuanbaoShop_UpdatePage(1);

		if(IsWindowShow("Shop_Fitting")) then
			RestoreShopFitting();
			CloseWindow("Shop_Fitting", true);
		end
		SetDefaultMouse();
	elseif ( event == "TOGGLE_YUANBAOSHOP") then
		if( this:IsVisible() ) then
			YuanbaoShop_Close();
		else

			lastA = 1;
			lastB = 1;
			YuanbaoShop_Show()
		end
	elseif ( event == "UPDATE_BOOTH" ) then

		YuanbaoShop_UpdatePage(nPageNum);

	elseif (event == "CLOSE_BOOTH") then
		YuanbaoShop_Close()
	elseif (event == "UPDATE_YUANBAO" and this:IsVisible() and g_tabIndex == ShopTabIdx.YuanBao) then
		YuanbaoShop_Text2 : SetText( "Я��Ԫ��������"..tostring(Player:GetData("YUANBAO")))
		YuanbaoShop_Text2_Bind : SetText( "��Ԫ������/Ԫ��������"..tostring( Player:GetData("ZENGDIAN")).."/"..tostring(Player:GetData("YUANBAO")) )
	elseif (event == "UPDATE_ZENGDIAN" and this:IsVisible()) then
		YuanbaoShop_Text2_Bind : SetText( "��Ԫ������/Ԫ��������"..tostring( Player:GetData("ZENGDIAN")).."/"..tostring(Player:GetData("YUANBAO")) )
	elseif (event == "UI_COMMAND" and tonumber( arg0 ) == 888902) then
		ObjCared = Get_XParam_INT( 0 )
		if Get_XParam_INT( 1 ) ~= 0 and Get_XParam_INT( 2 ) ~= 0 then
			lastA = Get_XParam_INT( 1 )
			lastB = Get_XParam_INT( 2 )
		end
		YuanbaoShop_Show()
	elseif( event == "ADJEST_UI_POS" ) then
		YuanbaoShop_ResetPos()

	elseif( event == "VIEW_RESOLUTION_CHANGED" ) then
		YuanbaoShop_ResetPos()
	end
end
--==================
--���̵�
function YuanbaoShop_Show()

	if lastA < 1 or lastA > maxChildShop then
		lastA = 1;
		lastB = 1;
	end

	if lastB < 1 or lastB > maxChildShop then
		lastB = 1;
	end


	lastSelect = 0;
	for i = 1 ,maxChildShop do
		SHOP_LIST_B[i]:Hide()
		if SHOP_LIST_A[lastA].shoplist[i] ~= nil then
			SHOP_LIST_B[i]:SetText(SHOP_LIST_A[lastA].shoplist[i])
			SHOP_LIST_B[i]:Show()
		end
	end
	SHOP_LIST_A[lastA].btn:SetCheck(1)
	SHOP_LIST_B[lastB]:SetCheck(1)


	lastA_Bind = 1;
	lastB_Bind = 1;

	lastSelect_Bind = 0;
	for i = 1 ,maxChildShop do
		SHOP_LIST_B_BIND[i]:Hide()
		if SHOP_LIST_A_BIND[lastA_Bind].shoplist[i] ~= nil then
			SHOP_LIST_B_BIND[i]:SetText(SHOP_LIST_A_BIND[lastA_Bind].shoplist[i])
			SHOP_LIST_B_BIND[i]:Show()
		end
	end
	SHOP_LIST_A_BIND[lastA_Bind].btn:SetCheck(1)
	SHOP_LIST_B_BIND[lastB_Bind]:SetCheck(1)


	SHOP_LIST_A_BIND[1].btn : SetCheck(1)
	if ( 0 == g_tabIndex ) then
		UpdateShopItem( lastA , lastB )
	else
		YuanbaoShop_Yuanbao : SetCheck(1)
		YuanbaoShop_Gongzi : SetCheck(0)
		--��ʱĬ���л�����ͨԪ����
		YuanbaoShop_ChangeTabIndex( 0 )
	end
end
--===============================
--ˢ��һҳ
function YuanbaoShop_UpdatePage(thePage)

	if (g_tabIndex == ShopTabIdx.YuanBao) then
		YuanbaoShop_Text2:SetText ("#{YBSD_081225_068}"..tostring(Player:GetData("YUANBAO")))
	end
	YuanbaoShop_Text2_Bind : SetText( "#{BDYB_XML_6}"..tostring( Player:GetData("ZENGDIAN")).."/"..tostring(Player:GetData("YUANBAO")) )

	for i=1, GOODS_BUTTONS_NUM  do
		GOOD_BAD[i]:Show()
	end

	local	i = 1;

	if g_nTotalNum == 0 or g_nTotalNum ~= GetActionNum("boothitem") then
		g_nTotalNum	= GetActionNum("boothitem");
		YuanbaoShop_Order();
	end

	-- ������ҳ��
	local	nTotalPage;
	if( g_nTotalNum < 1 ) then
		nTotalPage	= 1;
	else
		nTotalPage	= math.floor((g_nTotalNum-1)/GOODS_BUTTONS_NUM)+1;
	end

	maxPage = nTotalPage;

	if(thePage < 1 or thePage > nTotalPage) then
		return;
	end
	--HEQUIP_DRESS		=16,	//ʱװ
	--HEQUIP_RIDER		=8,	//���
	local bHaveRide=0;

	nPageNum = thePage;

	local nStartIndex = (thePage-1)*GOODS_BUTTONS_NUM;

	local nActIndex = nStartIndex;
	i = 1;
	while i <= GOODS_BUTTONS_NUM do
		local	idx	= g_tOrderPool[nActIndex+1];
		if idx == nil then
			idx	= -1;
		end

		local theAction = EnumAction(idx, "boothitem");
		if theAction:GetID() ~= 0 then
			local nEquipPoint = theAction:GetEquipPoint();

			if nEquipPoint == 16 or nEquipPoint == 8 then
				bHaveRide = 1;
			end


			GOODS_BUTTONS[i]:SetActionItem(theAction:GetID());
			if(theAction:GetItemColorInShop()~="") then
				GOODS_DESCS[i]:SetText( theAction:GetItemColorInShop()..theAction:GetName() );
			else
				GOODS_DESCS[i]:SetText( theAction:GetName() );
			end
			local	nPrice	= NpcShop:EnumItemPrice( idx )
			nYuanBaoShopPrice[i] = nPrice
			if (g_tabIndex == ShopTabIdx.YuanBao) then
				GOOD_BAD[i]:SetText("#{YBSD_081225_101}" .. tostring(nPrice))
			elseif (g_tabIndex == ShopTabIdx.Bind) then
				GOOD_BAD[i]:SetText("��Ԫ����" .. tostring(nPrice))
			end

			i = i+1;
		else
			GOODS_BUTTONS[i]:SetActionItem(-1);
			GOODS_DESCS[i]:SetText("");
			GOOD_BAD[i]:SetText("");
			i = i+1;
		end
		nActIndex = nActIndex+1;
	end


	if bHaveRide >= 1 then
		YuanbaoShop_Try:Show();
	else
		YuanbaoShop_Try:Hide();
	end

	if( nTotalPage == 1 ) then
		YuanbaoShop_UpPage:Hide();
		YuanbaoShop_DownPage:Hide();
		YuanbaoShop_CurrentlyPage:Hide();
	else
		YuanbaoShop_UpPage:Show();
		YuanbaoShop_DownPage:Show();
		YuanbaoShop_CurrentlyPage:Show();

		YuanbaoShop_UpPage:Enable();
		YuanbaoShop_DownPage:Enable();

		if ( nPageNum == nTotalPage ) then
			YuanbaoShop_DownPage:Disable();
		end

		if ( nPageNum == 1 ) then
			YuanbaoShop_UpPage:Disable()
		end

		YuanbaoShop_CurrentlyPage:SetText(tostring(nPageNum) .. "/" .. tostring(nTotalPage) );
	end
end
--���һ����ǩ
function YuanbaoShop_UpdateList(nIndex)

	--PushDebugMessage("YuanbaoShop_UpdateList:"..nIndex);
	if nIndex <1 or nIndex > 8 or ( nIndex == lastA and g_changeTabFlag == 0 ) then
		return
	end

	for i = 1 ,maxChildShop do
		SHOP_LIST_B[i]:Hide()
		if SHOP_LIST_A[nIndex].shoplist[i] ~= nil then
			SHOP_LIST_B[i]:SetText(SHOP_LIST_A[nIndex].shoplist[i])
			SHOP_LIST_B[i]:Show()
		end
	end

	SHOP_LIST_B[1]:SetCheck(1)
	lastB = 1
	lastA = nIndex
	lastSelect = 0

	UpdateShopItem( lastA ,lastB )
end
--�������
function YuanbaoShop_UpdateShop(nIndex)

	--PushDebugMessage("YuanbaoShop_UpdateShop:"..nIndex);
	if nIndex <1 or nIndex > maxChildShop or ( nIndex == lastB and g_changeTabFlag == 0 ) then
		return
	end

	lastB = nIndex

	if lastSelect > 0 and lastSelect <= table.getn(SHOP_SEARCH_LIST) then
		UpdateShopItem( lastSelect+8 , lastB )
	elseif lastA > 0 and lastA < 9 then
		UpdateShopItem( lastA , lastB )
	else
		UpdateShopItem( 1 , 1)
	end
end
--����
function YuanbaoShop_BeginSearch()

	if ( YuanbaoShop_SearchMode_Bind : IsVisible( ) ) then
		YuanbaoShop_BeginSearch_Bind();
		return;
	end

	local str , nIndex = YuanbaoShop_SearchMode:GetCurrentSelect()

	if nIndex <1 or nIndex > table.getn(SHOP_SEARCH_LIST) then
		return
	end

	for i = 1 ,maxChildShop do
		SHOP_LIST_B[i]:Hide()
		if SHOP_SEARCH_LIST[nIndex][i] ~= nil then
			SHOP_LIST_B[i]:SetText(SHOP_SEARCH_LIST[nIndex][i])
			SHOP_LIST_B[i]:Show()
		end
	end

	SHOP_LIST_B[1]:SetCheck(1)
	lastB = 1
	lastA = 0
	lastSelect = nIndex

	for i = 1 ,8 do
		SHOP_LIST_A[i].btn:SetCheck(0)
	end

	UpdateShopItem( nIndex+8 , 1 )
end

-- ��Ԫ�� begin

--���һ����ǩ
function YuanbaoShop_UpdateList_Bind(nIndex)

	--PushDebugMessage("YuanbaoShop_UpdateList_Bind:"..nIndex);
	if nIndex < 1 or nIndex > 8 or ( nIndex == lastA_Bind and g_changeTabFlag == 0 ) then
		return
	end

	for i = 1 , maxChildShop do
		SHOP_LIST_B_BIND[i]:Hide()
		if SHOP_LIST_A_BIND[nIndex].shoplist[i] ~= nil then
			SHOP_LIST_B_BIND[i]:SetText(SHOP_LIST_A_BIND[nIndex].shoplist[i])
			SHOP_LIST_B_BIND[i]:Show()
		end
	end

	SHOP_LIST_B_BIND[1]:SetCheck(1)
	lastB_Bind = 1
	lastA_Bind = nIndex
	lastSelect_Bind = 0

	UpdateShopItem( lastA_Bind + 100 ,lastB_Bind )
end

--�������
function YuanbaoShop_UpdateShop_Bind(nIndex)

	--PushDebugMessage("YuanbaoShop_UpdateShop_Bind:"..nIndex..",lastB_Bind:"..lastB_Bind..",g_changeTabFlag:"..g_changeTabFlag );
	if nIndex <1 or nIndex > maxChildShop or ( nIndex == lastB_Bind and g_changeTabFlag == 0 ) then
		return
	end

	lastB_Bind = nIndex

	if lastSelect_Bind > 0 and lastSelect_Bind < 8 then
		UpdateShopItem( lastSelect_Bind + 108 , lastB_Bind )
	elseif lastA_Bind > 0 and lastA_Bind < 9 then
		UpdateShopItem( lastA_Bind + 100 , lastB_Bind )
	else
		UpdateShopItem( 1 , 1)
	end

end

--����
function YuanbaoShop_BeginSearch_Bind()

	local str , nIndex = YuanbaoShop_SearchMode_Bind:GetCurrentSelect()

	if nIndex <1 or nIndex > 7 then
		return
	end

	for i = 1 ,maxChildShop do
		SHOP_LIST_B_BIND[i]:Hide()
		if SHOP_SEARCH_LIST_BIND[nIndex][i] ~= nil then
			SHOP_LIST_B_BIND[i]:SetText(SHOP_SEARCH_LIST_BIND[nIndex][i])
			SHOP_LIST_B_BIND[i]:Show()
		end
	end

	SHOP_LIST_B_BIND[1]:SetCheck(1)
	lastB_Bind = 1
	lastA_Bind = 0
	lastSelect_Bind = nIndex

	for i = 1 ,8 do
		SHOP_LIST_A_BIND[i].btn:SetCheck(0)
	end

	UpdateShopItem( nIndex + 108 , 1 )
end

---------------------------------------- ��ȯ�̵� ���� -------------------------------------------

--���ò˵�����ʾ����
function YuanbaoShop_UpdateVisiableProperty(shopAList, shopBList, searchList, lastA, lastB, lastSelect)

	if (shopAList == nil or shopBList == nil or searchList == nil) then
		return
	end

	local findA = 0

	for i=1, table.getn(shopAList) do
		if (table.getn(shopAList[i].shoplist) > 0) then
			shopAList[i].btn : Show()
			if (i == lastA) then
				findA = i
			end
		else
			shopAList[i].btn : Hide()
		end
	end

	if (findA > 0) then
		shopAList[lastA].btn : SetCheck(1)
		for j = 1, table.getn(shopBList) do
			shopBList[j] : Hide()
			if shopAList[lastA].shoplist[j] ~= nil then
				shopBList[j] : SetText(shopAList[lastA].shoplist[j])
				shopBList[j] : Show()
				if j == lastB then
					shopBList[j] : SetCheck(1)
				end
			end
		end
	elseif lastSelect > 0 and lastSelect <= table.getn(searchList) then
		for i = 1 ,table.getn(shopAList) do
			shopAList[i].btn:SetCheck(0)
		end
		for i = 1 ,table.getn(shopBList) do
			shopBList[i]:Hide()
			if searchList[lastSelect][i] ~= nil then
				shopBList[i]:SetText(searchList[lastSelect][i])
				shopBList[i]:Show()
			end
		end
		shopBList[lastB]:SetCheck(1)
	end
end

function YuanbaoShop_ChangeTabIndex( nIndex )

	if ( nIndex == g_tabIndex ) then
		return
	end

	g_changeTabFlag = 1
	g_tabIndex = nIndex

	YuanbaoShop_Bk1_Bind : Hide();
	YuanbaoShop_Bk2_Bind : Hide();
	YuanbaoShop_SearchMode_Bind : Hide();
	YuanbaoShop_Bk1 : Hide();
	YuanbaoShop_Bk2 : Hide();
	YuanbaoShop_SearchMode : Hide();

	YuanbaoShop_Text1 : Hide();
	YuanbaoShop_Begin : Hide();

	YuanbaoShop_Text2 : Hide();
	YuanbaoShop_Text2_Bind : Hide();

	YuanbaoShop_Bk3 : Hide();
	YuanbaoShop_Bk4 : Hide();

	YuanbaoShop_Dis3 : Hide();

	if( nIndex ==  ShopTabIdx.YuanBao ) then
		YuanbaoShop_Bk1 : Show();
		YuanbaoShop_Bk2 : Show();
		YuanbaoShop_SearchMode : Show();

		YuanbaoShop_Text1 : Show();
		YuanbaoShop_Begin : Show();

		YuanbaoShop_Text2 : Show();
		YuanbaoShop_Dis3 : Show();

		YuanbaoShop_UpdateVisiableProperty(SHOP_LIST_A, SHOP_LIST_B, SHOP_SEARCH_LIST, lastA, lastB, lastSelect)
		YuanbaoShop_Bk3 : Show();

		local check  = tonumber(NpcShop:GetBuyDirectly());
		if(check>=1)then
			YuanbaoShop_querengoumai:SetCheck(0);
		else
			YuanbaoShop_querengoumai:SetCheck(1);
		end

		YuanbaoShop_UpdateShop( lastB );

	elseif( nIndex ==  ShopTabIdx.Bind ) then
		YuanbaoShop_Bk1_Bind : Show();
		YuanbaoShop_Bk2_Bind : Show();

		YuanbaoShop_Text2_Bind : Show();

		YuanbaoShop_Bk4 : Show();

		local check  = tonumber(NpcShop:GetBuyDirectly());
		if(check>=1)then
			YuanbaoShop_querengoumaiBind:SetCheck(0);
		else
			YuanbaoShop_querengoumaiBind:SetCheck(1);
		end

		check  = tonumber(NpcShop:GetBuyDirectly());
		if(check>=1)then
			--YuanbaoShop_querenzhifuBind:SetCheck(0);
		else
			--YuanbaoShop_querenzhifuBind:SetCheck(1);
		end

		-- YuanbaoShop_SearchMode_Bind : Show();
		if ( lastB_Bind == 0 ) then
			YuanbaoShop_UpdateList_Bind( 1 );
		else
			YuanbaoShop_UpdateShop_Bind( lastB_Bind );
		end
	end

end

-- ��Ԫ�� end

--�Դ�
function YuanbaoShop_OpenFitting()
	-- if IsIdleLogic() ~= 1 and IsMoveLogic() ~= 1 then
		-- SetNotifyTip("#{YBSD_081225_100}");
		-- return 0;
	-- end
	-- StopMove();
    PushDebugMessage("�ݲ�֧���Դ������������¡�");
	-- if(IsWindowShow("Shop_Fitting")) then
		-- CloseWindow("Shop_Fitting", true);
	-- end
	-- RestoreShopFitting();
	-- this:Show();
	-- MouseCmd_ShopFittingSet();
	-- SetNotifyTip("#{YBSD_081225_099}");
end
--�����̵���Ϣ
function UpdateShopItem( shopA , shopB)

	--PushDebugMessage("shopA:"..shopA..",shopB:"..shopB );
	g_changeTabFlag = 0

	-- ����������⴦��
	if (shopA == 1 and shopB == 8) or (shopA == 16 and shopB == 1) then
		OpenRecentBuyYuanbaoShop();
		return;
	end

	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("OpenYuanbaoShop");
		Set_XSCRIPT_ScriptID(888902);
		Set_XSCRIPT_Parameter(0,ObjCared);
		Set_XSCRIPT_Parameter(1,shopA);
		Set_XSCRIPT_Parameter(2,shopB);
		Set_XSCRIPT_ParamCount(3);
	Send_XSCRIPT();
end
--===============================================
-- Button_Clicked
--===============================================
function YuanbaoShop_GoodButton_Clicked(nIndex)
	if(nIndex < 1 or nIndex > 18) then
		return;
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("YuanbaoShop");
		Set_XSCRIPT_ScriptID(892002);
		Set_XSCRIPT_Parameter(0,nYuanBaoShopPrice[nIndex]);
		Set_XSCRIPT_Parameter(1,g_tabIndex);
		Set_XSCRIPT_ParamCount(2);
	Send_XSCRIPT();	
	GOODS_BUTTONS[nIndex]:DoAction();
end
--===============================================
-- PageUp
--===============================================
function YuanbaoShop_PageUp()
	curPage = nPageNum - 1;
	if ( curPage >= maxPage ) then
		curPage = maxPage;
	end
	NpcShop:CloseConfirm();
	YuanbaoShop_UpdatePage( curPage );
end

--===============================================
-- PageDown
--===============================================
function YuanbaoShop_PageDown()
	curPage = nPageNum + 1;
	if ( curPage < 0 )  then
		curPage = 0;
	end
	NpcShop:CloseConfirm();
	YuanbaoShop_UpdatePage( curPage );
end

--===============================================
-- Close
--===============================================
function YuanbaoShop_Close()
	ObjCared = -1
	this:CareObject(objCared, 0, "YuanbaoShop");
	if(IsWindowShow("Shop_Fitting")) then
		CloseWindow("Shop_Fitting", true);
	end
	if(IsWindowShow("YBShopReference")) then
		CloseWindow("YBShopReference",true)
	end
	SetDefaultMouse();
	CloseBooth();
	NpcShop:CloseConfirm();
	RestoreShopFitting();
	this:Hide();
end

--�������
function YuanbaoShop_Order()
	local	max		= g_nTotalNum;
	local oldt	= {};
	g_tOrderPool= {};

	for i = 1, tonumber(max) do
	  oldt[i] = i-1;
	end

	if tonumber(NpcShop:GetIsShopReorder()) == 0 then
		g_tOrderPool		= oldt;
	else
		for i = 1, table.getn(oldt) do
		 local idx	= math.random(1, table.getn(oldt));
		 local val	= oldt[idx];
		 g_tOrderPool[i]= val;
		 table.remove(oldt, idx);
		end
	end
end

--ȷ�ϰ�ť
function YuanbaoShop_querengoumai_Clicked()
	if(NpcShop:GetBuyDirectly() == 0)then
--		YuanbaoShop_querengoumai:SetCheck(0);
		NpcShop:SetBuyDirectly(1);
	else
--		YuanbaoShop_querengoumai:SetCheck(1);
		NpcShop:SetBuyDirectly(0);
	end
end

--ȷ�ϰ�ť
function YuanbaoShop_querenzhifu_Clicked()
	if(NpcShop:GetBuyDirectly() == 0)then
		NpcShop:SetUseYBForBind(1)
	else
		NpcShop:SetUseYBForBind(0)
	end
end

--���ٳ�ֵ
function YuanbaoShop_web_Clicked()
	local bIsFatigue = Player:GetIsFatigue();
	if bIsFatigue ~= nil and bIsFatigue > 0 then
		PushDebugMessage("#{CMXT_191210_07}");
		return
	end
	GameProduceLogin:OpenURL(GetWeblink("WEB_LOGON_MAIN"))
end
--Ŀ¼�Ͳ���˵��
function YuanbaoShop_Dis_Clicked()
	OpenYBShopReference("#{YBSD_081225_070}")
end
--Ԫ���̵�ʹ��˵��
function YuanbaoShop_Dis2_Clicked()
	OpenYBShopReference("#{YBSD_081225_098}")
end
--�����̵�ʹ��˵��
function YuanbaoShop_Dis3_Clicked()
	OpenYBShopReference("#{SMSD_100127_01}")
end

--������Ϣ˳���������
function YubanbaoShop_ADRandom()
	YuanbaoShop_ScrollInfo_Frame:ClearInfo()

	local ADInfo = {
				"#{YBSD_081225_093}",
				"#{YBSD_081225_094}",
				"#{YBSD_081225_095}",
			}
	local nADInfoNum = table.getn(ADInfo)
	if (nil == nADInfoNum or nADInfoNum < 1 or nADInfoNum > 3) then
		nADInfoNum = 3
	end

	for i = 0 ,1 do
		local idx = math.random(1 ,nADInfoNum - i)
		local str = ADInfo[idx]
		ADInfo[idx] = ADInfo[nADInfoNum - i]
		ADInfo[nADInfoNum - i] = str
	end

	for i = 1 ,nADInfoNum do
		YuanbaoShop_ScrollInfo_Frame:SetScrollInfoFixed(ADInfo[i])
	end

end

function YuanbaoShop_ResetPos()
	YuanbaoShop_Frame:SetProperty("UnifiedXPosition", g_YuanbaoShop_Frame_UnifiedXPosition);
	YuanbaoShop_Frame:SetProperty("UnifiedYPosition", g_YuanbaoShop_Frame_UnifiedYPosition);

end



function YuanbaoShop_OnChongZhi()

	Clear_XSCRIPT()
        Set_XSCRIPT_Function_Name("Scripttransitcenter"); 	
        Set_XSCRIPT_ScriptID(892002);
        Set_XSCRIPT_Parameter(0,6);
        Set_XSCRIPT_Parameter(1,2);
        Set_XSCRIPT_ParamCount(2);
        Send_XSCRIPT()
end

function YuanbaoShop_OnDuiHuan()
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("OpenDuiHuan");
		Set_XSCRIPT_ScriptID(181000);
		Set_XSCRIPT_ParamCount(0)
	Send_XSCRIPT();
end

