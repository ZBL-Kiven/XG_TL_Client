--��������ƹ���
---===================================================
--!!!reloadscript =TGM_XinShouNew
local g_TGM_XinShouNew_Frame_UnifiedPosition;
--�������ܵ�Frame
local g_TGM_XinShouNew_Frames =
{
}
--===============================================
-- ��һ����Ϊ�˶�̬��ʾButton Tips ---------begin
--===============================================
local g_TGM_XinShouNew_Event = {
	[1] = {text="˫���ַ���",  isShow=0,},	 	--˫���ַ���
	[2] = {text="������½����",  isShow=0,},	 	--�����׺���
	[3] = {text="��Ԫ�׳佱��", isShow=0,},	 		--�׳䳬ֵ��
	[4] = {text="��ʱ��ֵ����", isShow=0,},	 	--��ʱ��ֵ����
	[5] = {text="��������·", isShow=0,},  		--��������·
	[6] = {text="�������ͽ���",isShow=0,},  		--��ֵ��ֵ��
	[7] = {text="������������", isShow=0,},	 		--�����к���
	[8] = {text="Ӣ�۰ٱ���", isShow=0,},	 		--Ӣ�۰ٱ���
	[9] = {text="����������", isShow=0,},  		--����������
	[10] = {text="����Я����",isShow=0,}, 		--����Я����
	[11] = {text="����Я����",isShow=0,},		--�°�����Я����
};

--���Button �ϼ� ������ϼ� ����Ϊ�Ժ�߻� ��Ҫĳ���ض���Button ����
local g_TGM_XinShouNew_Button =
{
}
local g_TGM_XinShouNew_Tip =
{
}
local g_HaoXialuRed = {}
local g_Button_StateTemp = {1,1,1,1,1,1,1,1,1,1,1}  --��ʱ�� ������  ����
local g_Tips_StateTemp = {0,0,0,0,0,0,0,0,0,0,1}  --��ʱ�� ������  ����
local g_lastDay = -1
local g_lastMaiDian = -1
--===============================================
-- ��һ����Ϊ�˶�̬��ʾButton Tips -----------end
--=============================================== 
local g_EventIndex = -1 --��ǰѡ�е�ѡ��
local g_TGM_XinShouNew_ButtonCDTime = 1; --��ť��ȴʱ��
local g_TGM_XinShouNew_ButtonLastTime = 0;
local g_TGM_XinShouNew_LastClickedId = -1; --�ϴ�ѡ�е�ѡ��
local g_TGM_XinShouNew_EventIndex = -1 --��ǰѡ�е�ѡ��
local g_TGM_XinShouNew_MD =  1533			--���ּ��껪MD ����ʱ�� YYMMDDHHMM
local g_TGM_XinShouNew_EndTime = 0 --���ּ��껪����ʱ��
--===============================================
-- �׳�
--===============================================
--�׳佱����Ʒ���
local g_TGM_XinShouNew_ShouChong_Gifts = {
	[1] =   {GiftItemID = 10155006, num = 1,},
	[2] =   {GiftItemID = 38002946, num = 1,},
	[3] =   {GiftItemID = 30900130, num = 2,},
}
--������Ʒ���
local g_TGM_XinShouNew_ShouChong_GiftsIcons = {}
local g_TGM_XinShouNew_ShouChong_GiftsIcons_Num = {}
local g_TGM_XinShouNew_ShouChong_ButtonState =0;
--
local g_TGM_XinShouNew_ShouChong_LoadFirstTime =1;
--===============================================
-- ��ʱ
--===============================================
--��ʾ������Ʒ���
local g_TGM_XinShouNew_LimitedSaveUp_Gifts = {
	[1] = 	{
			{GiftItemID = 20310168, num = 10,},{GiftItemID = 38000378, num = 4,},{ GiftItemID = 30503133, num = 5,}
		,},
	[2] =	{
			{GiftItemID = 30900130, num = 1,},{GiftItemID = 38000380, num = 2,},{ GiftItemID = 38000654, num = 1,}	 
		,},
	[3] =   {
			{GiftItemID = 30900130, num = 2,},{GiftItemID = 30008114, num = 1,},{GiftItemID = 38000654, num = 2,}	 
		,},
}

--set:ZhizunHaoli","")
local g_TGM_XinShouNew_LimitedSaveUp_GiftsImage = {
	[1] = {Set ="XinShouNewBK" , Image = "XinShouNew_HL1", },
	[2] = {Set ="XinShouNewBK" , Image = "XinShouNew_HL2", },
	[3] = {Set ="XinShouNewBK" , Image = "XinShouNew_HL3", },
	[4] = {Set ="XinShouNewBK" , Image = "XinShouNew_HL4", },
	[5] = {Set ="XinShouNewBK" , Image = "XinShouNew_HL5", },
	[6] = {Set ="XinShouNewBK" , Image = "XinShouNew_HL6", },
	[7] = {Set ="XinShouNewBK" , Image = "XinShouNew_HL7", },
	[8] = {Set ="XinShouNewBK" , Image = "XinShouNew_HL8", },
	[9] = {Set ="XSYNewBK02" , Image = "XSYNewBK_LeiChong_HLicon9", },
	[10] ={Set ="XSYNewBK02" , Image = "XSYNewBK_LeiChong_HLicon10", },
}
--Button
local g_TGM_XinShouNew_LimitedSaveUp_ButtonDone = {}
local g_TGM_XinShouNew_LimitedSaveUp_GiftsIcons ={}
local g_TGM_XinShouNew_LimitedSaveUp_GiftsIcons_Num ={}
local g_TGM_XinShouNew_LimitedSaveUp_Button = {}
local g_TGM_XinShouNew_LimitedSaveUp_Content = {
	[1] ={Content="#{XSJNH_180111_63}",Tips="#{XSJNH_180111_76}",},
	[2] ={Content="#{XSJNH_180111_64}",Tips="#{XSJNH_180111_77}",},
	[3] ={Content="#{XSJNH_180111_65}",Tips="#{XSJNH_180111_78}",},
}
local g_TGM_XinShouNew_LimitedSaveUp_ButtonState = {
	[1] =0,
	[2] =0,
	[3] =0,
};
local g_TGM_XinShouNew_LimitedSaveUp_GetGiftsCondition =
{
	[1] = { Exch = 400000, Cost = 400000, },
	[2] = { Exch = 2000000, Cost = 2000000, },
	[3] = { Exch = 6000000, Cost = 6000000, },
}
local g_TGM_XinShouNew_LimitedSaveUp_WDCImage =
{ 
	[2] = {Set ="set:XSYNew01" , Image = "image:TGM_XinShouNew_Time_DisabledDay3", },
	[3] = {Set ="set:XSYNew01" , Image = "image:TGM_XinShouNew_Time_DisabledDay7", },
}
 
local g_TGM_XinShouNew_LimitedSaveUp_Cost =0;
local g_TGM_XinShouNew_LimitedSaveUp_Exch =0;
local g_TGM_XinShouNew_LimitedSaveUp_RemainTime =0;
local g_TGM_XinShouNew_LimitedSaveUp_RemainDay =0;
local g_TGM_XinShouNew_LimitedSaveUp_CurSelect =1;
--===============================================
-- ��ֵ��ֵ��
--===============================================
local g_TGM_XinShouNew_SuperSaveUp_LoadFirstTime = 1
local g_TGM_XinShouNew_SuperSaveUp_ScrollbarPosition = 0
--��ʾ������Ʒ���
local g_TGM_XinShouNew_SuperSaveUp_Gifts = {}
--�����Ľ���
--Button
local g_TGM_XinShouNew_SuperSaveUp_Buttons = {
}
local g_TGM_XinShouNew_SuperSaveUp_ButtonState = 0

local g_TGM_XinShouNew_SuperSaveUp_GetGiftsCondition =
{
	[1] = { Exch = 100, Cost = 100, },
	[2] = { Exch = 300, Cost = 300, },
	[3] = { Exch = 500, Cost = 500, },
	[4] = { Exch = 1000, Cost = 1000, },
	[5] = { Exch = 2000, Cost = 2000, },
	[6] = { Exch = 3000, Cost = 3000, },
	[7] = { Exch = 4000, Cost = 4000, },
	[8] = { Exch = 5000, Cost = 5000, },
	[9] = { Exch = 7000, Cost = 7000, },
	[10] ={ Exch = 9000, Cost = 9000, },
}
local g_TGM_XinShouNew_SuperSaveUp_num =0;
local g_TGM_XinShouNew_SuperSaveUp_Cost =0;
local g_TGM_XinShouNew_SuperSaveUp_Exch =0;
local g_TGM_XinShouNew_SuperSaveUp_ContentButton = {}
local g_TGM_XinShouNew_SuperSaveUp_CurrentSelect = 0;
local g_TGM_XinShouNew_SuperSaveUp_Page = 0;
local g_TGM_XinShouNew_BaiBao2_LeftImage = {}
--
local g_TGM_XinShouNew_7DayHaveDone = 0;
local g_TGM_XinShouNew_7DayShowTimes =0;
local g_TGM_XinShouNew_7DayButtom ={};
local g_MD_XINSHOU_7DAY_1=1534        --��2017Q4�������°������£�7�պ���
local g_MD_XINSHOU_7DAY_2=1535        --��2017Q4�������°������£�7�պ���
local g_TGM_XinShouNew_7DayPrize =
{
	[1] ={
				[1]={ItemID = 30900130, num = 2,},
				[2]={ItemID = 30505818, num = 10,},
				[3]={ItemID = 30505821, num = 10,},
				},
	[2] ={
				[1]={ItemID = 38000464, num = 1,},
				[2]={ItemID = 38000654, num = 1,},
				[3]={ItemID = 30900130, num = 3,},
				},
	[3] ={
				[1]={ItemID = 30503140, num = 3,},
				[2]={ItemID = 30900123, num = 3,},
				[3]={ItemID = 38001595, num = 10,},
				},
	[4] ={
				[1]={ItemID = 38000945, num = 10,},
				[2]={ItemID = 30900131, num = 1,},
				[3]={ItemID = 38000378, num = 5,},
				},
	[5] ={
				[1]={ItemID = 30900131, num = 1,},
				[2]={ItemID = 38000932, num = 10,},
				[3]={ItemID = 38000571, num = 30,},
				},
	[6] ={
				[1]={ItemID = 20502005, num = 1,},
				[2]={ItemID = 20700063, num = 50,},
				[3]={ItemID = 20700055, num = 25,},
				},
	[7] ={
				[1]={ItemID = 20501005, num = 1,},
				[2]={ItemID = 20700063, num = 50,},
				[3]={ItemID = 20700055, num = 25,},
				},	
};
local g_TGM_XinShouNew_7DayPrize_Button = {}
local g_TGM_XinShouNew_7DayPrize_Button_Num = {}
local g_TGM_XinShouNew_7DayPrize_Click = 0
local g_TGM_XinShouNew_7DayButtonText = {
	[1] = "#{XSJNH_180111_39}",
	[2] = "#{XSJNH_180111_39}",
	[3] = "#{XSJNH_180111_40}",
	[4] = "#{XSJNH_180111_41}",
	[5] = "#{XSJNH_180111_42}",
	[6] = "#{XSJNH_180111_43}",
	[7] = "#{XSJNH_180111_44}",
};
local g_TGM_XinShouNew_7DayImage = {
	[1] ={
				[1]="set:XSYNew07 image:XSYNew_7Days_ShowD1",
				[2]="set:XSYNew01 image:XSYNew_7Days_D1",
				[3]="set:XSYNew03 image:XSYNew_7Days_ItemD1",
				[4]="set:XSYNew01 image:TGM_XinShouNew_Time_DisabledDay2",
				},
	[2] ={
				[1]="set:XSYNew06 image:XSYNew_7Days_ShowD2",
				[2]="set:XSYNew01 image:XSYNew_7Days_D2",
				[3]="set:XSYNew03 image:XSYNew_7Days_ItemD2",
				[4]="set:XSYNew01 image:TGM_XinShouNew_Time_DisabledDay2",				
				},
	[3] ={
				[1]="set:XSYNew06 image:XSYNew_7Days_ShowD3",
				[2]="set:XSYNew01 image:XSYNew_7Days_D3",
				[3]="set:XSYNew03 image:XSYNew_7Days_ItemD3",
				[4]="set:XSYNew01 image:TGM_XinShouNew_Time_DisabledDay3",				
				},
	[4] ={
				[1]="set:XSYNew05 image:XSYNew_7Days_ShowD4",
				[2]="set:XSYNew01 image:XSYNew_7Days_D4",
				[3]="set:XSYNew03 image:XSYNew_7Days_ItemD4",
				[4]="set:XSYNew01 image:TGM_XinShouNew_Time_DisabledDay4",				
				},
	[5] ={
				[1]="set:XSYNew05 image:XSYNew_7Days_ShowD5",
				[2]="set:XSYNew01 image:XSYNew_7Days_D5",
				[3]="set:XSYNew03 image:XSYNew_7Days_ItemD5",
				[4]="set:XSYNew01 image:TGM_XinShouNew_Time_DisabledDay5",				
				},
	[6] ={
				[1]="set:XSYNew04 image:XSYNew_7Days_ShowD6",
				[2]="set:XSYNew01 image:XSYNew_7Days_D6",
				[3]="set:XSYNew03 image:XSYNew_7Days_ItemD6",
				[4]="set:XSYNew01 image:TGM_XinShouNew_Time_DisabledDay6",				
				},
	[7] ={
				[1]="set:XSYNew04 image:XSYNew_7Days_ShowD7",
				[2]="set:XSYNew01 image:XSYNew_7Days_D7",
				[3]="set:XSYNew03 image:XSYNew_7Days_ItemD7",
				[4]="set:XSYNew01 image:TGM_XinShouNew_Time_DisabledDay7",				
				},	
};
--���·������¡������ͺ���Begin
local g_TGM_XinShouNew_LevelUp_PageIndex = 1;		-- ������ʾ�Ƿ�ҳ��,��ҳ����:0.���뽭�� 1.�̽�����
local g_TGM_XinShouNew_LevelUp_GetGiftLevel = {		-- �콱�ȼ�����
	[1] = 10,[2] = 20,[3] = 30,[4] = 35,[5] = 40,[6] = 45,[7] = 50,[8] = 55,[9] = 60,[10] = 70,[11] = 80,[12] = 90,[13] = 100,[14] = 120,
}

local g_TGM_XinShouNew_LevelUpBtnState = {			-- ��ȡ��ť��״̬
	[1] = 1, [2] = 1, [3] = 1, [4] = 1, [5] = 1, [6] = 1, [7] = 1, [8] = 1, [9] = 1, [10] = 1, [11] = 1, [12] = 1, [13] = 1,
}

local g_TGM_XinShouNew_LevelUpPageState = {			-- ��ȡ���ĸ�ҳ��
	[1] = 1, [2] = 1, [3] = 1, [4] = 1, [5] = 1, [6] = 1, [7] = 1, [8] = 1, [9] = 2, [10] = 2, [11] = 2, [12] = 2, [13] = 2,
}
--��������ʾ������Ʒ��ICON��
local g_TGM_XinShouNew_LevelUp_GiftsIcons = { }
local g_TGM_XinShouNew_LevelUp_GiftsIcons_Num = { }
--��������ʾ������Ʒ��ICON���Ͻǵ�Сͼ��
local g_TGM_XinShouNew_LevelUp_GiftsIconsImages = { }

--�Ƿ��ǵ�һ�μ��ء������ͺ��񡿽���
local g_TGM_XinShouNew_LevelUp_LoadFirstTime = 1

--�����ϵ�ÿ������չʾ��
local g_TGM_XinShouNew_LevelUp_Frames = { }
--���桾��ȡ��������ť��
local g_TGM_XinShouNew_LevelUp_GetGiftsButtonList = {}
--������Ʒ���
local g_TGM_XinShouNew_LevelUp_Gifts = {
[1] = 	{--10
{GiftItemID = 10155001, num = 1,},{GiftItemID = 31000000, num = 1,},{GiftItemID = 31000002, num = 1,},{GiftItemID = 30000000, num = 1,}
,},
[2] =	{--20
{GiftItemID = 30402046, num = 1,},{GiftItemID = 30402026, num = 1,},{GiftItemID = 30008117, num = 1,},{GiftItemID = 30000000, num = 1,}
,},
[3] =   {--30
{GiftItemID = 30501178, num = 1,},{GiftItemID = 30501187, num = 1,},{GiftItemID = 30501332, num = 1,},{GiftItemID = 30000000, num = 1,}
,},
[4] =   {--35
{GiftItemID = 38000945, num = 5,},{GiftItemID = 30900010, num = 2,},{GiftItemID = 30900015, num = 1,},{GiftItemID = 30000000, num = 1,}
,},
[5] =   {--40
{GiftItemID = 30503149, num = 1,},{GiftItemID = 30900010, num = 2,},{GiftItemID = 30900015, num = 1,},{GiftItemID = 30000000, num = 1,}
,},
[6] =   {--45
{GiftItemID = 30900130, num = 1,},{GiftItemID = 30900010, num = 2,},{GiftItemID = 30900015, num = 1,},{GiftItemID = 30000000, num = 1,}
,},
[7] =	{--50
{GiftItemID = 30900130, num = 1,},{GiftItemID = 30900010, num = 2,},{GiftItemID = 30900015, num = 1,},{GiftItemID = 30000000, num = 1,}
},
[8] =	{--55
{GiftItemID = 30900130, num = 1,},{GiftItemID = 30900010, num = 2,},{GiftItemID = 30900015, num = 1,},{GiftItemID = 30000000, num = 1,}
},
[9] =	{--60
{GiftItemID = 10156001, num = 1,},{GiftItemID = 10156002, num = 1,},{GiftItemID = 30700230, num = 5,},{GiftItemID = 38001565, num = 1,},
},
[10] = {--70
{GiftItemID = 38000655, num = 3,},{GiftItemID = 38001197, num = 1,},{GiftItemID = 30505076, num = 1,},{GiftItemID = 38001565, num = 1,},
},
[11] = {--80
{GiftItemID = 10157001, num = 1,},{GiftItemID = 20310181, num = 10,},{GiftItemID = 20310182, num = 10,},{GiftItemID = 20310183, num = 10,},
},
[12] = {--90
{GiftItemID = 38001897, num = 1,},{GiftItemID = 38000930, num = 10,},{GiftItemID = 38000932, num = 5,},{GiftItemID = 38001565, num = 1,},
},
[13] = {--100
{GiftItemID = 38000378, num = 5,},{GiftItemID = 38000399, num = 5,},{GiftItemID = 20700063, num = 30,},{GiftItemID = 20700055, num = 50,},
},
}
--���·������¡������ͺ���End

--����������begin
local g_LuckyDrawCount 			= 0;
local g_LuckyDrawRemainTime = 0;
local g_LuckyDrawTotalCount =3; 
--�����ĸ�����
local g_LuckyDrawIndex = 0
--��������ʾ������Ʒ��ICON��
local g_TGM_XinShouNew_LuckyDraw_GiftsIcons = { }
--��������ʾ������Ʒ��ICON���Ͻǵ�Сͼ��
local g_TGM_XinShouNew_LuckyDraw_GiftsIconImages = { } 
--�����Ƿ��ǵ�һ�μ���,����ǵĻ�,��Ҫ������Ʒͼ��
local g_TGM_XinShouNew_LuckyDraw_LoadFirstTime = 1 
--�齱��Ʒ���
local g_TGM_XinShouNew_LuckyDraw_Gifts =
{
	[1] = 	{
			{GiftItemID = 20500005, num = 1,}
		,},
	[2] =	{	
			{GiftItemID = 20501005, num = 1,}
		,},
	[3] =   {
			{GiftItemID = 20502005, num = 1,}
		,},
	[4] =   {
			{GiftItemID = 30008034, num = 1,}
		,},
	[5] =   {
			{GiftItemID = 20310131, num = 1,}
		,},
	[6] =   {
			{GiftItemID = 20310180, num = 1,}
		,},
	[7] =   {
			{GiftItemID = 30503118, num = 1,}
		,},
	[8] =   {
			{GiftItemID = 30900010, num = 1,}
		,},
	[9] =   {
			{GiftItemID = 30503119, num = 1,}
		,},
}
local g_TGM_XinShouNew_LuckyDraw_GiftLightImage =
{	
}

local g_TGM_XinShouNew_LuckyDraw_TimerLength = 5000
--����������end

--===============================================
-- ��������·-begin
--===============================================


local g_TGM_XinShouNew_Heroes_Road_LastClickedId = -1; --�ϴ�ѡ�е�ѡ��

local g_TGM_XinShouNew_Heroes_Road_Button = {}

local g_TGM_XinShouNew_Heroes_Road_HX_Value_MD = 1518
local g_TGM_XinShouNew_Heroes_ItemBounsId = 38002172
local g_TGM_XinShouNew_Heroes_ButtonTextSelected = {
"#{XSJNH_180131_272}",
"#{XSJNH_180131_273}",
"#{XSJNH_180131_274}",
"#{XSJNH_180131_275}",
"#{XSJNH_180131_276}",
"#{XSJNH_180131_277}",
"#{XSJNH_180131_278}",
}

local g_TGM_XinShouNew_Heroes_ButtonText = {
"#{XSJNH_180125_260}",
"#{XSJNH_180125_261}",
"#{XSJNH_180125_262}",
"#{XSJNH_180125_263}",
"#{XSJNH_180125_264}",
"#{XSJNH_180125_265}",
"#{XSJNH_180125_266}",
}

--===============================================
-- ��������·-end
--===============================================

--Ӣ�۰ٱ���begin
local g_TGM_XinShouNew_BaiBaoBtnState = {			-- ��ȡ��ť��״̬
	[1] = 0, [2] = 0, [3] = 0, [4] = 0, [5] = 0, [6] = 0, 
}

--��������ʾ������Ʒ��ICON��
local g_TGM_XinShouNew_BaiBao_GiftsIcons = { }
local g_TGM_XinShouNew_BaiBao_GiftsIcons_NUM = { }
local g_TGM_XinShouNew_BaiBao2_GiftsIcons = { }
local g_TGM_XinShouNew_BaiBao2_GiftsIcons_NUM = { }

--��������ʾ������Ʒ��ICON���Ͻǵ�Сͼ��
local g_TGM_XinShouNew_BaiBao_GiftsIconImages = { }

--�����Ƿ��ǵ�һ�μ���,����ǵĻ�,��Ҫ������Ʒͼ��
local g_TGM_XinShouNew_BaiBao_LoadFirstTime = 1

--���桾��ȡ���򡿰�ť��
local g_TGM_XinShouNew_BaiBao_GetGiftsButtonList = {}
--������Ʒ���
local g_TGM_XinShouNew_BaiBao_Gifts =
{
	[1] = 	{
			{GiftItemID = 30900131, num = 1,},{GiftItemID = 30900045, num = 1,},{GiftItemID = 38000571, num = 50,},{GiftItemID = 20310099, num = 5,}
		,},
	[2] =	{	
			{GiftItemID = 30900131, num = 1,},{GiftItemID = 30900045, num = 1,},{GiftItemID = 38000571, num = 50,},{GiftItemID = 20310099, num = 5,}
		,},
	[3] =   {
			{GiftItemID = 30900132, num = 1,},{GiftItemID = 30900045, num = 1,},{GiftItemID = 38000571, num = 100,},{GiftItemID = 20310099, num = 10,}
		,},
	[4] =   {
			{GiftItemID = 30900132, num = 1,},{GiftItemID = 30900045, num = 1,},{GiftItemID = 38000571, num = 100,},{GiftItemID = 20310099, num = 10,}
		,},
	[5] =   {
			{GiftItemID = 30900133, num = 1,},{GiftItemID = 30900045, num = 1,},{GiftItemID = 38000571, num = 200,},{GiftItemID = 20310099, num = 10,}
		,},
	[6] =   {
			{GiftItemID = 30900133, num = 1,},{GiftItemID = 30900045, num = 1,},{GiftItemID = 38000571, num = 200,},{GiftItemID = 20310099, num = 10,}
		,},
}

local g_TGM_XinShouNew_BaiBao2_Gifts2 =
{
	[1] = 	{
			{GiftItemID = 39999901, num = 20,},{GiftItemID = 20700055, num = 888,},{GiftItemID = 39999909, num = 3,}
		,},
	[2] =	{	
			{GiftItemID = 39999901, num = 30,},{GiftItemID = 38001106, num = 3,},{GiftItemID = 20310185, num = 10,}
		,},
	[3] =   {
			{GiftItemID = 38000571, num = 300,},{GiftItemID = 39901012, num = 1,},{GiftItemID = 39999902, num = 2,}
		,},
	[4] =   {
			{GiftItemID = 38000571, num = 600,},{GiftItemID = 20310187, num = 30,},{GiftItemID = 20310186, num = 30}
		,},
	[5] =   {
			{GiftItemID = 38001111, num = 3,},{GiftItemID = 39901012, num = 2,},{GiftItemID = 39999902, num = 5}
		,},
	[6] =   {
			{GiftItemID = 50913004, num = 5,},{GiftItemID = 39901012, num = 10,},{GiftItemID = 39999902, num = 10,}
		,},

}
local g_TGM_XinShouNew_BaiBao_GetGiftsCondition = 
{
	[1] = {  Level = 70,Cost = 1867000,	PriCost = 2000000,  Discount = "6" },				--Ӣ�۰ٱ���
	[2] = {  Level = 80,Cost = 1867000, PriCost = 2000000, Discount = "6" 	},
	[3] = {  Level = 90,Cost = 3734000, PriCost = 4000000, Discount = "6" },
	[4] = {  Level = 100,Cost = 3734000, PriCost = 4000000, Discount = "6" },
	[5] = {  Level = 105,Cost = 5601000, PriCost = 6000000, Discount = "6" },
	[6] = {  Level = 110,Cost = 5601000, PriCost = 6000000, Discount = "6" 	},		 
}
 
local g_TGM_XinShouNew_HeroBag_NotifyTipsControlList	= { }	--��Ӣ�۰ٱ��ҡ���������ʾ���������Text�ؼ�,�߻�Ҫ������������ʾ�ɶ�̬��=...=
local g_TGM_XinShouNew_PrizeItemButtonIcon = "set:CommonFrame20 image:Item_New"
local g_TGM_XinShouNew_HeroBag_IsShowTips =1;
--Ӣ�۰ٱ���end

--�罻���˻�
local g_SheJiaoButtons = {}
local g_SheJiaoButtonKongs = {}
local g_SheJiaoButtonDisbles = {}
local g_SheJiaoButtonAima = {}
local g_SheJiaoRewardBtnState = {
	[1] = 0, --��齱����ť״̬ 0������ȡ 1����ȡ 2����ȡ
	[2] = 0, --���
	[3] = 0, --��ʦ
	[4] = 0, --��ͽ
	[5] = 0, --���
}
local g_SheJiaoBtnToolTips = 
{
	[1] ="#G%s��%s��%s��%sʱ#Yǰ���ڡ��������˲����Ľ���֮�У���Ѱ���Լ��������һ�벢��Ϊ���£�������ȡһ�����ּ��껪ר�������񣬿ɻ��#G2#Y��#G��ʫ����#Y��#G1#Y��#G7��ʱװ�������#Y��#r��������ȡ������Ŷ�������ȡ��",
	[2] ="#G%s��%s��%s��%sʱ#Yǰ���ڡ��������˲����Ľ���֮�У���ֿ��������������������ȡһ�����ּ��껪ר����ݺ��񣬿ɻ��#G1#Y��#G��Ѫ���嵤#Y��#r��������ȡ��ݺ���Ŷ�������ȡ��",
	[3] ="#G%s��%s��%s��%sʱ#Yǰ���ڡ��������˲����Ľ���֮�У�Ѱ��һλ�ذ��Լ�����ʦ�����������£�������ȡһ�����ּ��껪ר����ʦ���񣬿ɻ��#G1#Y��#G�𵤺�«#Y��#G1#Y��#G��Һ��ƿ#Y��#r��������ȡ��ʦ����Ŷ�������ȡ��",
	[4] ="#G%s��%s��%s��%sʱ#Yǰ���ڡ��������˲����Ľ���֮�У��ٵ�һλ�ϻ۸�ͽ���������£�������ȡһ�����ּ��껪ר����ͽ���񣬿ɻ��#G1#Y��#Gʦ�µ���#Y��ʹ�ÿ��Ի��#Gʦ��ֵ#YŶ��#r��������ȡ��ͽ����Ŷ�������ȡ��",
	[5] ="#G%s��%s��%s��%sʱ#Yǰ���ڡ��������˲����Ľ���֮�У�Ѱ��һ��־ͬ���ϵİ�Ტ�������У�������ȡһ�����ּ��껪ר�������񣬿ɻ��#G1#Y��#G�ﹱ��#Y��ʹ�ÿɻ��#G��ṱ�׶�#YŶ��#r��������ȡ������Ŷ�������ȡ��",
}
local g_SheJiaoBtnToolTipsDisbles = 
{
	[1] ="#G%s��%s��%s��%sʱ#Yǰ���ڡ��������˲����Ľ���֮�У���Ѱ���Լ��������һ�벢��Ϊ���£�������ȡһ�����ּ��껪ר�������񣬿ɻ��#G2#Y��#G��ʫ����#Y��#G1#Y��#G7��ʱװ�������#Y��",
	[2] ="#G%s��%s��%s��%sʱ#Yǰ���ڡ��������˲����Ľ���֮�У���ֿ��������������������ȡһ�����ּ��껪ר����ݺ��񣬿ɻ��#G1#Y��#G��Ѫ���嵤#Y��",
	[3] ="#G%s��%s��%s��%sʱ#Yǰ���ڡ��������˲����Ľ���֮�У�Ѱ��һλ�ذ��Լ�����ʦ�����������£�������ȡһ�����ּ��껪ר����ʦ���񣬿ɻ��#G1#Y��#G�𵤺�«#Y��#G1#Y��#G��Һ��ƿ#Y��",
	[4] ="#G%s��%s��%s��%sʱ#Yǰ���ڡ��������˲����Ľ���֮�У��ٵ�һλ�ϻ۸�ͽ���������£�������ȡһ�����ּ��껪ר����ͽ���񣬿ɻ��#G1#Y��#Gʦ�µ���#Y��ʹ�ÿ��Ի��#Gʦ��ֵ#YŶ��",
	[5] ="#G%s��%s��%s��%sʱ#Yǰ���ڡ��������˲����Ľ���֮�У�Ѱ��һ��־ͬ���ϵİ�Ტ�������У�������ȡһ�����ּ��껪ר�������񣬿ɻ��#G1#Y��#G�ﹱ��#Y��ʹ�ÿɻ��#G��ṱ�׶�#YŶ��",
}
local g_SheJiaoDaRenGitf =
{
	[1] = 
	{
		{GiftItemID = 38001241,num = 2},{GiftItemID = 10124018,num = 1}
	},
	[2] = 
	{
		{GiftItemID = 38001296,num = 1}
	},
	[3] = 
	{
		{GiftItemID = 31000000,num = 1},{GiftItemID = 31000002,num = 1}
	},
	[4] = 
	{
		{GiftItemID = 38001898,num = 1}
	},
	[5] = 
	{
		{GiftItemID = 38001897,num = 1}
	},
}
local g_SheJiaoSheJiaoDaRenIcons = {}
local g_SheJiaoDeadLine = 0
local g_bInitSheJiao = 0
local g_SheJiaoLastClick = 0
local g_SheJiaoIsFillIcon = 0

--˫���ַ���begin
local g_TGM_XinShouNew_Double = 
{
	[1] = 0,
	[2] = 0,
}
--˫���ַ���end

--����Я����2018�°�
local g_SheJiaoNewPages = {}
local g_SheJiaoNewPageButtons = {}
local g_SheJiaoNewCurPage = 0
local g_SheJiaoNewActionCurAchieveId = 0
--�������е��¼�
local g_SheJiaoNew_EventId2Data = 
{
	[1] = 	{Len=1,Start = 0,MaxValue = 1},   	 --���
	[2] = 	{Len=7,Start = 1,MaxValue = 1},	 --����żͬʱ����
	[3] = 	{Len=1,Start = 8,MaxValue = 1	},	 --˽����ż
	[4] = 	{Len=1,Start = 9,MaxValue = 1	},	 --����ż����ָ����
	[5] = 	{Len=1,Start = 10,MaxValue = 1	},	 --���һ����ٳ����
	[6] = 	{Len=1,Start = 11,MaxValue = 1	},	 --���һ��������Ϭ
	[7] = 	{Len=1,Start = 12,MaxValue = 1},	 --����żһ��ص�����
	[8] = 	{Len=12,Start = 13,MaxValue = 900}, --��ö���ֵ
	[9] = 	{Len=1,Start = 25,MaxValue = 1	},	 --������
	[10] = 	{Len=2,Start = 26,MaxValue = 3	},	 --��ɰ������
	[11] = 	{Len=1,Start = 28,MaxValue = 1	},	 --�������
	[12] = 	{Len=7,Start = 29,MaxValue = 3},   --�����Ա��ɸ���
	[13] = 	{Len=7,Start = 36,MaxValue = 20},   --�Ͻ�ս����
	[14] = 	{Len=1,Start = 43,MaxValue = 1	},   --��ɰ��۱���
	[15] = 	{Len=14,Start = 44,MaxValue = 300}, --�����Աɱ��
	[16] = 	{Len=12,Start = 58,MaxValue = 2500},  --�ﹱ
	[17] =	{Len=1,Start = 70,MaxValue = 1},	 --���
	[18] =  {Len=1,Start = 71,MaxValue = 1},	 --��ʦ
	[19] =  {Len=1,Start = 72,MaxValue = 1},	 --��ͽ
	--��������λ������Ҹ������ݵĴ洢������Ϊ�¼�
	[20] =  {Len=4,Start = 73,MaxValue = 3},    --�����������index
	[21] =  {Len=1,Start = 77,MaxValue = 1},	--�Ƿ����ݳ�ʼ��
	[22] =  {Len=4,Start = 78,MaxValue = 7},    --����������������
}
local g_SheJiaoNew_MarryUnkLockDayBit = 22

local g_SheJiaoNew_AhieveIdData = 
{
	[1]  = 	{EventId=1,NeedValue = 1,		RewardList={Id=10124018,Count = 1,bag=1,mat=0},szUnReward="#{TLXS_180427_119}",unlockDic="#{TLXS_180427_133}",szTitleName="#{TLXS_180427_133}",szNameDic="#{TLXS_180427_21}",Desc="#{TLXS_180427_14}",},    	 --���1��
	[2]  = 	{EventId=2,NeedValue = 1,		RewardList={Id=30501104,Count = 40,bag=1,mat=0},szUnReward="#{TLXS_180427_120}",unlockDic="#{TLXS_180427_134}",szTitleName="#{TLXS_180427_134}",szNameDic="#{TLXS_180427_22}",Desc="#{TLXS_180427_15}",},   	 --����żͬʱ����1Сʱ
	[3]  = 	{EventId=3,NeedValue = 1,		RewardList={Id=38001241,Count = 2,bag=1,mat=0},szUnReward="#{TLXS_180427_121}",unlockDic="#{TLXS_180427_135}",szTitleName="#{TLXS_180427_135}",szNameDic="#{TLXS_180427_23}",Desc="#{TLXS_180427_16}",},	   	 --����ż˽��һ��
	[4]  = 	{EventId=4,NeedValue = 1,		RewardList={Id=10141824,Count = 1,bag=1,mat=0},szUnReward="#{TLXS_180427_122}",unlockDic="#{TLXS_180427_136}",szTitleName="#{TLXS_180427_136}",szNameDic="#{TLXS_180427_24}",Desc="#cfff263����ͬ�У�һͬǰ��#G����ɽ#{_INFOAIM64,151,15,-1}#R���˻�#cfff263��������Ը��",},    	 --����żͬʱȥĿ���
	[5]  = 	{EventId=5,NeedValue = 1,		RewardList={Id=38000832,Count = 5,bag=1,mat=0},szUnReward="#{TLXS_180427_123}",unlockDic="#{TLXS_180427_137}",szTitleName="#{TLXS_180427_137}",szNameDic="#{TLXS_180427_25}",Desc="#{TLXS_180427_18}",},	   	 --����ż���һ����ٳ����
	[6]  = 	{EventId=6,NeedValue = 1,		RewardList={Id=38001302,Count = 7,bag=1,mat=0},szUnReward="#{TLXS_180427_124}",unlockDic="#{TLXS_180427_138}",szTitleName="#{TLXS_180427_138}",szNameDic="#{TLXS_180427_26}",Desc="#{TLXS_180427_19}",},    	 --����ż���һ��������Ϭ
	[7]  = 	{EventId=7,NeedValue = 1,		RewardList={Id=30509143,Count = 1,bag=1,mat=0},szUnReward="#{TLXS_180427_125}",unlockDic="#{TLXS_180427_139}",szTitleName="#{TLXS_180427_139}",szNameDic="#{TLXS_180427_27}",Desc="#{TLXS_180427_20}",},	   	 --����żһ��ص�����
	[8]  = 	{EventId=8,NeedValue = 200,	RewardList={Id=38001595,Count = 4,bag=1,mat=0},szUnReward="#{TLXS_180427_151}",unlockDic="",szNameDic="#{TLXS_180427_94}",Desc="",TrackDesc="",},	 --��ö���ֵ1000
	[9]  = 	{EventId=8,NeedValue = 500,	RewardList={Id=30503140,Count = 4,bag=1,mat=0},szUnReward="#{TLXS_180427_151}",unlockDic="",szNameDic="#{TLXS_180427_94}",Desc="",TrackDesc="",},	 --��ö���ֵ2000
	[10] = 	{EventId=8,NeedValue = 900,	RewardList={Id=30900123,Count = 5,bag=1,mat=0},szUnReward="#{TLXS_180427_151}",unlockDic="",szNameDic="#{TLXS_180427_94}",Desc="",TrackDesc="",},	 --��ö���ֵ3000
	[11] = 	{EventId=9,NeedValue = 1,		RewardList={Id=31000000,Count = 1,bag=1,mat=0},szUnReward="#{TLXS_180427_126}",unlockDic="#{TLXS_180427_38}",szTitleName="#{TLXS_180427_142}",szNameDic="#{TLXS_180427_38}",Desc="#{TLXS_180427_31}",},	     --����һ�ΰ��
	[12] = 	{EventId=10,NeedValue = 3,		RewardList={Id=31000002,Count = 1,bag=1,mat=0},szUnReward="#{TLXS_180427_127}",unlockDic="#{TLXS_180427_39}",szTitleName="#{TLXS_180427_143}",szNameDic="#{TLXS_180427_39}",Desc="#{TLXS_180427_32}",},	 --���3�ΰ������
	[13] = 	{EventId=11,NeedValue = 1,		RewardList={Id=38001897,Count = 1,bag=1,mat=0},szUnReward="#{TLXS_180427_128}",unlockDic="#{TLXS_180427_40}",szTitleName="#{TLXS_180427_144}",szNameDic="#{TLXS_180427_40}",Desc="#{TLXS_180427_33}",},	 --���1�ΰ������
	[14] = 	{EventId=12,NeedValue = 3,		RewardList={Id=38000932,Count = 2,bag=1,mat=0},szUnReward="#{TLXS_180427_129}",unlockDic="#{TLXS_180427_41}",szTitleName="#{TLXS_180427_145}",szNameDic="#{TLXS_180427_41}",Desc="#{TLXS_180427_34}",},	 --�����Ա���3�θ���
	[15] = 	{EventId=13,NeedValue = 20,	RewardList={Id=38001087,Count = 5,bag=1,mat=0},szUnReward="#{TLXS_180427_130}",unlockDic="#{TLXS_180427_42}",szTitleName="#{TLXS_180427_146}",szNameDic="#{TLXS_180427_42}",Desc="#{TLXS_180427_35}",},	 --�Ͻ�ս����100��
	[16] = 	{EventId=14,NeedValue = 1,		RewardList={Id=38000930,Count = 50,bag=1,mat=0},szUnReward="#{TLXS_180427_131}",unlockDic="#{TLXS_180427_43}",szTitleName="#{TLXS_180427_147}",szNameDic="#{TLXS_180427_43}",Desc="#{TLXS_180427_36}",},      --����1�ΰ��۱���
	[17] = 	{EventId=15,NeedValue = 300,	RewardList={Id=30008117,Count = 1,bag=1,mat=0},szUnReward="#{TLXS_180427_132}",unlockDic="#{TLXS_180427_44}",szTitleName="#{TLXS_180427_148}",szNameDic="#{TLXS_180427_44}",Desc="#{TLXS_180427_37}",},  --�����Աɱ��10000ֻ
	[18] = 	{EventId=16,NeedValue = 500,	RewardList={Id=38000655,Count = 3,bag=1,mat=0},szUnReward="#{TLXS_180427_150}",unlockDic="",szNameDic="#{TLXS_180427_84}",Desc="",},	 --��ðﹱ500
	[19] = 	{EventId=16,NeedValue = 1000,	RewardList={Id=38000930,Count = 100,bag=1,mat=0},szUnReward="#{TLXS_180427_150}",unlockDic="",szNameDic="#{TLXS_180427_84}",Desc="",},    --��ðﹱ1000
	[20] = 	{EventId=16,NeedValue = 1750,	RewardList={Id=38001087,Count = 20,bag=1,mat=0},szUnReward="#{TLXS_180427_150}",unlockDic="",szNameDic="#{TLXS_180427_84}",Desc="",},    --��ðﹱ1500
	[21] = 	{EventId=16,NeedValue = 2500,	RewardList={Id=38001090,Count = 2,bag=1,mat=0},szUnReward="#{TLXS_180427_150}",unlockDic="",szNameDic="#{TLXS_180427_84}",Desc="",},    --��ðﹱ2000
	[22] = 	{EventId=17,NeedValue = 1,		RewardList={Id=49100000,Count = 1,bag=1,mat=0},szUnReward="#{TLXS_180427_152}",unlockDic="",szNameDic="#{TLXS_180427_95}",Desc="��ݣ�����������ȡר������(�ֵ��أ�)",},   --���1��
	[23] = 	{EventId=18,NeedValue = 1,		RewardList={Id=49100001,Count = 1,bag=1,mat=0},szUnReward="#{TLXS_180427_153}",unlockDic="",szNameDic="#{TLXS_180427_97}",Desc="��ʦ����ʦ��ͽ����ȡר������(�ֵ��أ�)",},    --��ʦ1��
	[24] = 	{EventId=19,NeedValue = 1,		RewardList={Id=49100002,Count = 1,bag=1,mat=0},szUnReward="#{TLXS_180427_154}",unlockDic="",szNameDic="#{TLXS_180427_96}",Desc="��ͽ���������£���ȡר������(�ֵ��أ�)",},   --��ͽ1��
}
local g_SheJiaoNew_GiftActions = {}
local g_SheJiaoNew_ProcessList = {}
local g_SheJiaoNew_PageButtonList = {}
local g_SheJiaoNew_PageHasAchieves = 
{
	[1] = {1,2,3,4,5,6,7,8,9,10},
	[2] = {11,12,13,14,15,16,17,18,19,20,21},
	[3] = {22},
	[4] = {23},
	[5] = {24},
}
local g_SheJiaoNew_RandPosTips = 
{
	[1] = "#{TLXS_180427_155}",
	[2] = "#{TLXS_180427_156}",
	[3] = "#{TLXS_180427_157}",
}
local g_SheJiaoNew_AhieveDataPool = {0,0,0}
local g_SheJiaoNew_RewardData = 0
local g_SheJiaoNew_CreateTime = 0
local GetBitValueInUINT = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
local SetBitValueInUINT = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}

--===============================================
-- PreLoad()
--===============================================
function TGM_XinShouNew_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("TGM_XinShouNew_OPEN")		--
	--this:RegisterEvent("PLAYER_LEAVE_WORLD")		-- �뿪����
	this:RegisterEvent("ADJEST_UI_POS")			-- ��Ϸ���ڳߴ緢���˱仯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")	        -- ��Ϸ�ֱ��ʷ����˱仯
	this:RegisterEvent("UNIT_LEVEL")			-- ���·������¡������ͺ���ˢ�½���,���������ʱ����Ҫˢ�½���
	--this:RegisterEvent("PLAYER_ENTERING_WORLD")		-- ������Ϸ����
	this:RegisterEvent("PLAYER_FRESH_HAOXIA_FRAM")	
end

function TGM_XinShouNewInit()
g_TGM_XinShouNew_BaiBao2_Gifts2 =
{
	[1] = 	{
			{GiftItemID = 39999901, num = 20,},{GiftItemID = 20700055, num = 888,},{GiftItemID = 39999909, num = 3,}
		,},
	[2] =	{	
			{GiftItemID = 39999901, num = 30,},{GiftItemID = 38001106, num = 3,},{GiftItemID = 20310185, num = 10,}
		,},
	[3] =   {
			{GiftItemID = 38000571, num = 300,},{GiftItemID = 39901012, num = 1,},{GiftItemID = 39999902, num = 2,}
		,},
	[4] =   {
			{GiftItemID = 38000571, num = 600,},{GiftItemID = 20310187, num = 30,},{GiftItemID = 20310186, num = 30}
		,},
	[5] =   {
			{GiftItemID = 38001111, num = 3,},{GiftItemID = 39901012, num = 2,},{GiftItemID = 39999902, num = 5}
		,},
	[6] =   {
			{GiftItemID = 50913004, num = 5,},{GiftItemID = 39901012, num = 10,},{GiftItemID = 39999902, num = 10,}
		,},

}
g_TGM_XinShouNew_SuperSaveUp_GetGiftsCondition =
{
	[1] = { Exch = 100, Cost = 100, },
	[2] = { Exch = 300, Cost = 300, },
	[3] = { Exch = 500, Cost = 500, },
	[4] = { Exch = 1000, Cost = 1000, },
	[5] = { Exch = 2000, Cost = 2000, },
	[6] = { Exch = 3000, Cost = 3000, },
	[7] = { Exch = 4000, Cost = 4000, },
	[8] = { Exch = 5000, Cost = 5000, },
	[9] = { Exch = 7000, Cost = 7000, },
	[10] ={ Exch = 9000, Cost = 9000, },
}
end
--===============================================
-- OnEvent()
--===============================================
function TGM_XinShouNew_OnEvent(event)
	if (event == "UI_COMMAND" and tonumber(arg0) == 8926771 ) then

		local nIndex = Get_XParam_INT(1)
		if nIndex == 0 then
			if g_TGM_XinShouNew_Heroes_Road_LastClickedId >=1 and g_TGM_XinShouNew_Heroes_Road_LastClickedId <= 7 then
				for i = 1,  table.getn(g_TGM_XinShouNew_Heroes_Road_Button) do
					if i == g_TGM_XinShouNew_Heroes_Road_LastClickedId then
						g_TGM_XinShouNew_Heroes_Road_Button[i]:SetCheck(1)
					else
						g_TGM_XinShouNew_Heroes_Road_Button[i]:SetCheck(0)
					end
				end
			end
		end
		if nIndex >= 1 and nIndex <= 7 then
			local nValue = Get_XParam_INT(2)
			local nDayGap = Get_XParam_INT(3)
			TGM_XinShouNew_Heroes_Road_OnSwitchPage(nIndex,nValue,nDayGap)
		end
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 8926776 ) then

		local nValue = Get_XParam_INT(1)
		if IsWindowShow("TGM_XinShouNew") then
			local strMsg = string.format( "#cfff263��ǰӵ�к���ֵ��#G%s/150#cfff263", nValue)
			TGM_XinShouNew_Heroes_Road_Detailtips_text:SetText(strMsg)
		end

	elseif (event == "UI_COMMAND" and tonumber(arg0) == 2019031902 ) then
		g_TGM_XinShouNew_EndTime =  Get_XParam_INT( 0 );
		TGM_XinShouNew_Open()
	elseif (event == "PLAYER_FRESH_HAOXIA_FRAM") then
		TGM_XinShouNew_Heroes_Road_Page_Clicked(g_TGM_XinShouNew_Heroes_Road_LastClickedId)	
	elseif (event == "PLAYER_LEAVE_WORLD") then
		TGM_XinShouNew_Close()
	elseif (event == "ADJEST_UI_POS") then
		TGM_XinShouNew_On_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		TGM_XinShouNew_On_ResetPos()
	elseif (event == "PLAYER_ENTERING_WORLD" ) then				-- ���·������¡������ͺ���&�׳峬ֵ�������¼�����Ʒ����
		g_TGM_XinShouNew_ShouChong_LoadFirstTime =1;
		TGM_XinShouNew_SheJiaoNew_Request()
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 20180118 ) then
		g_TGM_XinShouNew_7DayShowTimes =  Get_XParam_INT( 0 );
		g_TGM_XinShouNew_7DayHaveDone = Get_XParam_INT( 1 );
		if this:IsVisible() then
			TGM_XinShouNew_7Day_Update()
		end
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 892675 ) then
		local nLogin=  Get_XParam_INT( 0 );
		if nLogin == 1 then
			for i = 1,7 do
				g_HaoXialuRed[i]:Hide()
			end
		end
		local nDayGap =  Get_XParam_INT( 1 );
		TGM_XinShouNew_OnCheckRed(nDayGap)
	elseif (event == "PLAYER_ENTERING_WORLD" ) then				-- ���·������¡������ͺ���&�׳峬ֵ�������¼�����Ʒ����
		g_TGM_XinShouNew_LevelUp_LoadFirstTime 	= 1;
		g_TGM_XinShouNew_BaiBao_LoadFirstTime  	= 1;
		g_TGM_XinShouNew_LuckyDraw_LoadFirstTime= 1;		
	elseif (event == "UNIT_LEVEL" ) then
		if IsWindowShow("TGM_XinShouNew") then				--���·������¡������ͺ��� ����ˢ��
			TGM_XinShouNew_LevelUp_FlushWindow(2)
		end
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 892684 ) then	--���·������¡������ͺ���
		-- ȡ����		
		local  LevelUpBJ = Get_XParam_INT(0) + 1
	      for i = 1, 13 do
			if i <LevelUpBJ then
				g_TGM_XinShouNew_LevelUpBtnState[i] = 1
			else
	            g_TGM_XinShouNew_LevelUpBtnState[i] = 0
			end
		  end	
		  g_PlayerLevel = Get_XParam_INT(1)
		-- ����Btn
		TGM_XinShouNew_LevelUp_FlushWindow(2); 	
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 89267601 ) then
		TGM_XinShouNew_ShouChong_UpdateButtonState()
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 89268901 ) then
		TGM_XinShouNew_LimitedSaveUp_UpdateInfo()
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 892685 ) then	--���·������¡�Ӣ�۰ٱ��ҡ�
		-- ȡ����
		for i = 1, table.getn(g_TGM_XinShouNew_BaiBaoBtnState) do
			g_TGM_XinShouNew_BaiBaoBtnState[i] = Get_XParam_INT( i - 1 )
		end	
		g_PlayerLevel = Player:GetData("LEVEL")
		-- ����Btn
		TGM_XinShouNew_BaiBao_FlushWindow(2); 
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 892690011 ) then	--���·������¡���ֵ��
		-- ȡ����
		g_TGM_XinShouNew_SuperSaveUp_Exch  = Get_XParam_INT(1)
		g_TGM_XinShouNew_SuperSaveUp_num  = Get_XParam_INT(2)
		g_TGM_XinShouNew_SuperSaveUp_ButtonState = Get_XParam_INT(3)
		TGM_XinShouNewInit()
		local l = {}
		for i = 1,6 do
			l[i] = Split(Get_XParam_STR(i-1),",")
			for j = 1,table.getn(l[i]) do
				local Pos1,Pos2,ItemId,ItemNum = string.find(l[i][j],"(.*)|(.*)")
				if Pos1 ~= nil and Pos2 ~= nil then
					g_TGM_XinShouNew_BaiBao2_Gifts2[i][j].GiftItemID = tonumber(ItemId)
					g_TGM_XinShouNew_BaiBao2_Gifts2[i][j].num = tonumber(ItemNum)
				end
			end
		end
		local Prize = Split(Get_XParam_STR(6),",")
		for i = 1,table.getn(g_TGM_XinShouNew_SuperSaveUp_GetGiftsCondition) do
			g_TGM_XinShouNew_SuperSaveUp_GetGiftsCondition[i].Exch = tonumber(Prize[i])
		end
		---��д
	if g_TGM_XinShouNew_SuperSaveUp_Exch <100 then
		TGM_XinShouNew_BaiBao2_Frame3_Bk1_Button1: SetProperty("DisabledImage","set:ServerNewUI2 image:ServerNewUI_LQ_WDC")
		TGM_XinShouNew_BaiBao2_Frame3_Bk1_Button1: Disable()	
		else
		TGM_XinShouNew_BaiBao2_Frame3_Bk1_Button1: Enable()
     end
	if 	g_TGM_XinShouNew_SuperSaveUp_Exch <300 then	
		TGM_XinShouNew_BaiBao2_Frame3_Bk2_Button1: SetProperty("DisabledImage","set:ServerNewUI2 image:ServerNewUI_LQ_WDC")
		TGM_XinShouNew_BaiBao2_Frame3_Bk2_Button1: Disable()
		else
		TGM_XinShouNew_BaiBao2_Frame3_Bk2_Button1: Enable()
	end
	if g_TGM_XinShouNew_SuperSaveUp_Exch <500 then
		TGM_XinShouNew_BaiBao2_Frame3_Bk3_Button1: SetProperty("DisabledImage","set:ServerNewUI2 image:ServerNewUI_LQ_WDC")
		TGM_XinShouNew_BaiBao2_Frame3_Bk3_Button1: Disable()
		else
		TGM_XinShouNew_BaiBao2_Frame3_Bk3_Button1: Enable()
	end	
	if 	g_TGM_XinShouNew_SuperSaveUp_Exch <1000 then	
		TGM_XinShouNew_BaiBao2_Frame3_Bk4_Button1: SetProperty("DisabledImage","set:ServerNewUI2 image:ServerNewUI_LQ_WDC")
		TGM_XinShouNew_BaiBao2_Frame3_Bk4_Button1: Disable()
		else
		TGM_XinShouNew_BaiBao2_Frame3_Bk4_Button1: Enable()
	end	
	if 	g_TGM_XinShouNew_SuperSaveUp_Exch <2000 then	
		TGM_XinShouNew_BaiBao2_Frame3_Bk5_Button1: SetProperty("DisabledImage","set:ServerNewUI2 image:ServerNewUI_LQ_WDC")
		TGM_XinShouNew_BaiBao2_Frame3_Bk5_Button1: Disable()
		else
		TGM_XinShouNew_BaiBao2_Frame3_Bk5_Button1: Enable()
	end	
	if 	g_TGM_XinShouNew_SuperSaveUp_Exch <3000 then
		TGM_XinShouNew_BaiBao2_Frame3_Bk6_Button1: SetProperty("DisabledImage","set:ServerNewUI2 image:ServerNewUI_LQ_WDC")
		TGM_XinShouNew_BaiBao2_Frame3_Bk6_Button1: Disable()    
		else
		TGM_XinShouNew_BaiBao2_Frame3_Bk6_Button1: Enable()                
	end
		
		
		TGM_XinShouNew_SuperSaveUp_FlushWindow()	
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 892686 ) then	--���·������¡����������ǡ�
		-- ȡ���� 
		g_LuckyDrawCount 			= Get_XParam_INT( 0 ); 
 		g_LuckyDrawRemainTime = Get_XParam_INT( 1 );  
 		g_LuckyDrawIndex			= 0;  
		-- ����Btn
		TGM_XinShouNew_LuckyDraw_FlushWindow(2); 
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 8926861 ) then	--���·������¡�����������-��Ч��
		-- ȡ���� 
		g_LuckyDrawIndex 			= Get_XParam_INT( 0 );    
		-- ����Btn
		TGM_XinShouNew_LuckyDraw_FlushWindow(2); 			
	elseif(event == "UI_COMMAND" and tonumber(arg0) == 892687) then --	���·������¡��罻���˻�-����ˢ�¡�
		TGM_XinShouNew_SheJiaoDaRen_UpDateDate()
	--elseif(event == "UI_COMMAND" and tonumber(arg0) == 8926871) then --���·������¡��罻���˻�-��ȡ�����ɹ���
	--	local nIndex = Get_XParam_INT(0)
	--	TGM_XinShouNew_SheJiaoDaRen_RetReward(nIndex)
	elseif(event == "UI_COMMAND" and tonumber(arg0) == 89267501) then --��ʾС���
		for index=1,table.getn(g_TGM_XinShouNew_Button)  do
			 local TipsState = Get_XParam_INT(index-1) 
			 if index ~= 8 then
			 	g_Tips_StateTemp[index]  = TipsState 
			 elseif index == 8 and g_TGM_XinShouNew_HeroBag_IsShowTips == 1  then
			 	g_Tips_StateTemp[index]  = TipsState
			 else
			 	g_Tips_StateTemp[index]  = 0 
			 end 
		end
		TGM_XinShouNew_ShowButtonTips()		
	elseif(event == "UI_COMMAND" and tonumber(arg0) == 2018020101) then --  
		g_TGM_XinShouNew_HeroBag_IsShowTips = 1	
	elseif(event == "UI_COMMAND" and tonumber(arg0) == 892753) then --�°�����Я��������ˢ��
		TGM_XinShouNew_SheJiaoNew_UpdateData()
	elseif(event == "UI_COMMAND" and tonumber(arg0) == 2020081301) then --�°�����Я��������ˢ��
		TGM_XinShouNew_Project_Clicked(6)
	end
end

--===============================================
-- OnLoad()
--===============================================
function TGM_XinShouNew_OnLoad()
	g_TGM_XinShouNew_Frame_UnifiedPosition = TGM_XinShouNew_Frame:GetProperty("UnifiedPosition")
	TGM_XinShouNew_SetButtonPos()

	g_TGM_XinShouNew_7DayButtom[1] ={Button =TGM_XinShouNew_SevenDay_Top_day1_Button1 , Done = TGM_XinShouNew_SevenDay_Top_day1_done };
	g_TGM_XinShouNew_7DayButtom[2] ={Button =TGM_XinShouNew_SevenDay_Top_day2_Button1 , Done = TGM_XinShouNew_SevenDay_Top_day2_done };
	g_TGM_XinShouNew_7DayButtom[3] ={Button =TGM_XinShouNew_SevenDay_Top_day3_Button1 , Done = TGM_XinShouNew_SevenDay_Top_day3_done };
	g_TGM_XinShouNew_7DayButtom[4] ={Button =TGM_XinShouNew_SevenDay_Top_day4_Button1 , Done = TGM_XinShouNew_SevenDay_Top_day4_done };
	g_TGM_XinShouNew_7DayButtom[5] ={Button =TGM_XinShouNew_SevenDay_Top_day5_Button1 , Done = TGM_XinShouNew_SevenDay_Top_day5_done };
	g_TGM_XinShouNew_7DayButtom[6] ={Button =TGM_XinShouNew_SevenDay_Top_day6_Button1 , Done = TGM_XinShouNew_SevenDay_Top_day6_done };
	g_TGM_XinShouNew_7DayButtom[7] ={Button =TGM_XinShouNew_SevenDay_Top_day7_Button1 , Done = TGM_XinShouNew_SevenDay_Top_day7_done };

	g_TGM_XinShouNew_7DayPrize_Button[1] = TGM_XinShouNew_SevenDay_Right_ShowA;
	g_TGM_XinShouNew_7DayPrize_Button[2] = TGM_XinShouNew_SevenDay_Right_ShowB;
	g_TGM_XinShouNew_7DayPrize_Button[3] = TGM_XinShouNew_SevenDay_Right_ShowC;
	g_TGM_XinShouNew_7DayPrize_Button[4] = TGM_XinShouNew_SevenDay_Right_ShowD;
	
	g_TGM_XinShouNew_7DayPrize_Button_Num[1] = TGM_XinShouNew_SevenDay_Right_Show_NUM_1;
	g_TGM_XinShouNew_7DayPrize_Button_Num[2] = TGM_XinShouNew_SevenDay_Right_Show_NUM_2;
	g_TGM_XinShouNew_7DayPrize_Button_Num[3] = TGM_XinShouNew_SevenDay_Right_Show_NUM_3;
	g_TGM_XinShouNew_7DayPrize_Button_Num[4] = TGM_XinShouNew_SevenDay_Right_Show_NUM_4;
	
	--���·������¡������ͺ���Begin

	--��������ʾ������Ʒ��ICON��
	g_TGM_XinShouNew_LevelUp_GiftsIcons =
	{
	[1] = {TGM_XinShouNew_LevelUp_Frame3_Bk1_Icon1, TGM_XinShouNew_LevelUp_Frame3_Bk1_Icon2, TGM_XinShouNew_LevelUp_Frame3_Bk1_Icon3, TGM_XinShouNew_LevelUp_Frame3_Bk1_Icon4, },
	[2] = {TGM_XinShouNew_LevelUp_Frame3_Bk2_Icon1, TGM_XinShouNew_LevelUp_Frame3_Bk2_Icon2, TGM_XinShouNew_LevelUp_Frame3_Bk2_Icon3, TGM_XinShouNew_LevelUp_Frame3_Bk2_Icon4, },
	[3] = {TGM_XinShouNew_LevelUp_Frame3_Bk3_Icon1, TGM_XinShouNew_LevelUp_Frame3_Bk3_Icon2, TGM_XinShouNew_LevelUp_Frame3_Bk3_Icon3, TGM_XinShouNew_LevelUp_Frame3_Bk3_Icon4, },
	[4] = {TGM_XinShouNew_LevelUp_Frame3_Bk4_Icon1, TGM_XinShouNew_LevelUp_Frame3_Bk4_Icon2, TGM_XinShouNew_LevelUp_Frame3_Bk4_Icon3, TGM_XinShouNew_LevelUp_Frame3_Bk4_Icon4, },
	[5] = {TGM_XinShouNew_LevelUp_Frame3_Bk5_Icon1, TGM_XinShouNew_LevelUp_Frame3_Bk5_Icon2, TGM_XinShouNew_LevelUp_Frame3_Bk5_Icon3, TGM_XinShouNew_LevelUp_Frame3_Bk5_Icon4, },
	[6] = {TGM_XinShouNew_LevelUp_Frame3_Bk6_Icon1, TGM_XinShouNew_LevelUp_Frame3_Bk6_Icon2, TGM_XinShouNew_LevelUp_Frame3_Bk6_Icon3, TGM_XinShouNew_LevelUp_Frame3_Bk6_Icon4, },
	[7] = {TGM_XinShouNew_LevelUp_Frame3_Bk7_Icon1, TGM_XinShouNew_LevelUp_Frame3_Bk7_Icon2, TGM_XinShouNew_LevelUp_Frame3_Bk7_Icon3, TGM_XinShouNew_LevelUp_Frame3_Bk7_Icon4, },
	[8] = {TGM_XinShouNew_LevelUp_Frame3_Bk8_Icon1, TGM_XinShouNew_LevelUp_Frame3_Bk8_Icon2, TGM_XinShouNew_LevelUp_Frame3_Bk8_Icon3, TGM_XinShouNew_LevelUp_Frame3_Bk8_Icon4, },
	[9] = {TGM_XinShouNew_LevelUp_Frame3_Bk9_Icon1, TGM_XinShouNew_LevelUp_Frame3_Bk9_Icon2, TGM_XinShouNew_LevelUp_Frame3_Bk9_Icon3, TGM_XinShouNew_LevelUp_Frame3_Bk9_Icon4, },
	[10] = {TGM_XinShouNew_LevelUp_Frame3_Bk10_Icon1, TGM_XinShouNew_LevelUp_Frame3_Bk10_Icon2, TGM_XinShouNew_LevelUp_Frame3_Bk10_Icon3, TGM_XinShouNew_LevelUp_Frame3_Bk10_Icon4, },
	[11] = {TGM_XinShouNew_LevelUp_Frame3_Bk11_Icon1, TGM_XinShouNew_LevelUp_Frame3_Bk11_Icon2, TGM_XinShouNew_LevelUp_Frame3_Bk11_Icon3, TGM_XinShouNew_LevelUp_Frame3_Bk11_Icon4, },
	[12] = {TGM_XinShouNew_LevelUp_Frame3_Bk12_Icon1, TGM_XinShouNew_LevelUp_Frame3_Bk12_Icon2, TGM_XinShouNew_LevelUp_Frame3_Bk12_Icon3, TGM_XinShouNew_LevelUp_Frame3_Bk12_Icon4, },
	[13] = {TGM_XinShouNew_LevelUp_Frame3_Bk13_Icon1, TGM_XinShouNew_LevelUp_Frame3_Bk13_Icon2, TGM_XinShouNew_LevelUp_Frame3_Bk13_Icon3, TGM_XinShouNew_LevelUp_Frame3_Bk13_Icon4, },
	}
	--�������� ��ң�� 2019-8-27 22:58:17
	g_TGM_XinShouNew_LevelUp_GiftsIcons_Num =
	{
	[1] = {TGM_XinShouNew_LevelUp_Frame3_Bk1_Icon1_NUM, TGM_XinShouNew_LevelUp_Frame3_Bk1_Icon2_NUM, TGM_XinShouNew_LevelUp_Frame3_Bk1_Icon3_NUM, TGM_XinShouNew_LevelUp_Frame3_Bk1_Icon4_NUM, },
	[2] = {TGM_XinShouNew_LevelUp_Frame3_Bk2_Icon1_NUM, TGM_XinShouNew_LevelUp_Frame3_Bk2_Icon2_NUM, TGM_XinShouNew_LevelUp_Frame3_Bk2_Icon3_NUM, TGM_XinShouNew_LevelUp_Frame3_Bk2_Icon4_NUM, },
	[3] = {TGM_XinShouNew_LevelUp_Frame3_Bk3_Icon1_NUM, TGM_XinShouNew_LevelUp_Frame3_Bk3_Icon2_NUM, TGM_XinShouNew_LevelUp_Frame3_Bk3_Icon3_NUM, TGM_XinShouNew_LevelUp_Frame3_Bk3_Icon4_NUM, },
	[4] = {TGM_XinShouNew_LevelUp_Frame3_Bk4_Icon1_NUM, TGM_XinShouNew_LevelUp_Frame3_Bk4_Icon2_NUM, TGM_XinShouNew_LevelUp_Frame3_Bk4_Icon3_NUM, TGM_XinShouNew_LevelUp_Frame3_Bk4_Icon4_NUM, },
	[5] = {TGM_XinShouNew_LevelUp_Frame3_Bk5_Icon1_NUM, TGM_XinShouNew_LevelUp_Frame3_Bk5_Icon2_NUM, TGM_XinShouNew_LevelUp_Frame3_Bk5_Icon3_NUM, TGM_XinShouNew_LevelUp_Frame3_Bk5_Icon4_NUM, },
	[6] = {TGM_XinShouNew_LevelUp_Frame3_Bk6_Icon1_NUM, TGM_XinShouNew_LevelUp_Frame3_Bk6_Icon2_NUM, TGM_XinShouNew_LevelUp_Frame3_Bk6_Icon3_NUM, TGM_XinShouNew_LevelUp_Frame3_Bk6_Icon4_NUM, },
	[7] = {TGM_XinShouNew_LevelUp_Frame3_Bk7_Icon1_NUM, TGM_XinShouNew_LevelUp_Frame3_Bk7_Icon2_NUM, TGM_XinShouNew_LevelUp_Frame3_Bk7_Icon3_NUM, TGM_XinShouNew_LevelUp_Frame3_Bk7_Icon4_NUM, },
	[8] = {TGM_XinShouNew_LevelUp_Frame3_Bk8_Icon1_NUM, TGM_XinShouNew_LevelUp_Frame3_Bk8_Icon2_NUM, TGM_XinShouNew_LevelUp_Frame3_Bk8_Icon3_NUM, TGM_XinShouNew_LevelUp_Frame3_Bk8_Icon4_NUM, },
	[9] = {TGM_XinShouNew_LevelUp_Frame3_Bk9_Icon1_NUM, TGM_XinShouNew_LevelUp_Frame3_Bk9_Icon2_NUM, TGM_XinShouNew_LevelUp_Frame3_Bk9_Icon3_NUM, TGM_XinShouNew_LevelUp_Frame3_Bk9_Icon4_NUM, },
	[10] = {TGM_XinShouNew_LevelUp_Frame3_Bk10_Icon1_NUM, TGM_XinShouNew_LevelUp_Frame3_Bk10_Icon2_NUM, TGM_XinShouNew_LevelUp_Frame3_Bk10_Icon3_NUM, TGM_XinShouNew_LevelUp_Frame3_Bk10_Icon4_NUM, },
	[11] = {TGM_XinShouNew_LevelUp_Frame3_Bk11_Icon1_NUM, TGM_XinShouNew_LevelUp_Frame3_Bk11_Icon2_NUM, TGM_XinShouNew_LevelUp_Frame3_Bk11_Icon3_NUM, TGM_XinShouNew_LevelUp_Frame3_Bk11_Icon4_NUM, },
	[12] = {TGM_XinShouNew_LevelUp_Frame3_Bk12_Icon1_NUM, TGM_XinShouNew_LevelUp_Frame3_Bk12_Icon2_NUM, TGM_XinShouNew_LevelUp_Frame3_Bk12_Icon3_NUM, TGM_XinShouNew_LevelUp_Frame3_Bk12_Icon4_NUM, },
	[13] = {TGM_XinShouNew_LevelUp_Frame3_Bk13_Icon1_NUM, TGM_XinShouNew_LevelUp_Frame3_Bk13_Icon2_NUM, TGM_XinShouNew_LevelUp_Frame3_Bk13_Icon3_NUM, TGM_XinShouNew_LevelUp_Frame3_Bk13_Icon4_NUM, },
	}
	
	g_TGM_XinShouNew_LevelUp_GiftsIconsImages =
	{
	[1] = {TGM_XinShouNew_LevelUp_Frame3_Bk1_Icon1_Xin, TGM_XinShouNew_LevelUp_Frame3_Bk1_Icon2_Xin, TGM_XinShouNew_LevelUp_Frame3_Bk1_Icon3_Xin, TGM_XinShouNew_LevelUp_Frame3_Bk1_Icon4_Xin, },
	[2] = {TGM_XinShouNew_LevelUp_Frame3_Bk2_Icon1_Xin, TGM_XinShouNew_LevelUp_Frame3_Bk2_Icon2_Xin, TGM_XinShouNew_LevelUp_Frame3_Bk2_Icon3_Xin, TGM_XinShouNew_LevelUp_Frame3_Bk2_Icon4_Xin, },
	[3] = {TGM_XinShouNew_LevelUp_Frame3_Bk3_Icon1_Xin, TGM_XinShouNew_LevelUp_Frame3_Bk3_Icon2_Xin, TGM_XinShouNew_LevelUp_Frame3_Bk3_Icon3_Xin, TGM_XinShouNew_LevelUp_Frame3_Bk3_Icon4_Xin, },
	[4] = {TGM_XinShouNew_LevelUp_Frame3_Bk4_Icon1_Xin, TGM_XinShouNew_LevelUp_Frame3_Bk4_Icon2_Xin, TGM_XinShouNew_LevelUp_Frame3_Bk4_Icon3_Xin, TGM_XinShouNew_LevelUp_Frame3_Bk4_Icon4_Xin, },
	[5] = {TGM_XinShouNew_LevelUp_Frame3_Bk5_Icon1_Xin, TGM_XinShouNew_LevelUp_Frame3_Bk5_Icon2_Xin, TGM_XinShouNew_LevelUp_Frame3_Bk5_Icon3_Xin, TGM_XinShouNew_LevelUp_Frame3_Bk5_Icon4_Xin, },
	[6] = {TGM_XinShouNew_LevelUp_Frame3_Bk6_Icon1_Xin, TGM_XinShouNew_LevelUp_Frame3_Bk6_Icon2_Xin, TGM_XinShouNew_LevelUp_Frame3_Bk6_Icon3_Xin, TGM_XinShouNew_LevelUp_Frame3_Bk6_Icon4_Xin, },
	[7] = {TGM_XinShouNew_LevelUp_Frame3_Bk7_Icon1_Xin, TGM_XinShouNew_LevelUp_Frame3_Bk7_Icon2_Xin, TGM_XinShouNew_LevelUp_Frame3_Bk7_Icon3_Xin, TGM_XinShouNew_LevelUp_Frame3_Bk7_Icon4_Xin, },
	[8] = {TGM_XinShouNew_LevelUp_Frame3_Bk8_Icon1_Xin, TGM_XinShouNew_LevelUp_Frame3_Bk8_Icon2_Xin, TGM_XinShouNew_LevelUp_Frame3_Bk8_Icon3_Xin, TGM_XinShouNew_LevelUp_Frame3_Bk8_Icon4_Xin, },
	[9] = {TGM_XinShouNew_LevelUp_Frame3_Bk9_Icon1_Xin, TGM_XinShouNew_LevelUp_Frame3_Bk9_Icon2_Xin, TGM_XinShouNew_LevelUp_Frame3_Bk9_Icon3_Xin, TGM_XinShouNew_LevelUp_Frame3_Bk9_Icon4_Xin, },
	[10] = {TGM_XinShouNew_LevelUp_Frame3_Bk10_Icon1_Xin, TGM_XinShouNew_LevelUp_Frame3_Bk10_Icon2_Xin, TGM_XinShouNew_LevelUp_Frame3_Bk10_Icon3_Xin, TGM_XinShouNew_LevelUp_Frame3_Bk10_Icon4_Xin, },
	[11] = {TGM_XinShouNew_LevelUp_Frame3_Bk11_Icon1_Xin, TGM_XinShouNew_LevelUp_Frame3_Bk11_Icon2_Xin, TGM_XinShouNew_LevelUp_Frame3_Bk11_Icon3_Xin, TGM_XinShouNew_LevelUp_Frame3_Bk11_Icon4_Xin, },
	[12] = {TGM_XinShouNew_LevelUp_Frame3_Bk12_Icon1_Xin, TGM_XinShouNew_LevelUp_Frame3_Bk12_Icon2_Xin, TGM_XinShouNew_LevelUp_Frame3_Bk12_Icon3_Xin, TGM_XinShouNew_LevelUp_Frame3_Bk12_Icon4_Xin, },
	[13] = {TGM_XinShouNew_LevelUp_Frame3_Bk13_Icon1_Xin, TGM_XinShouNew_LevelUp_Frame3_Bk13_Icon2_Xin, TGM_XinShouNew_LevelUp_Frame3_Bk13_Icon3_Xin, TGM_XinShouNew_LevelUp_Frame3_Bk13_Icon4_Xin, },
	}
	--�����ϵ�ÿ������չʾ��
	g_TGM_XinShouNew_LevelUp_Frames =
	{
		[1] = TGM_XinShouNew_LevelUp_Frame3_Bk1, [2] = TGM_XinShouNew_LevelUp_Frame3_Bk2, [3] = TGM_XinShouNew_LevelUp_Frame3_Bk3, [4] = TGM_XinShouNew_LevelUp_Frame3_Bk4,
		[5] = TGM_XinShouNew_LevelUp_Frame3_Bk5, [6] = TGM_XinShouNew_LevelUp_Frame3_Bk6, [7] = TGM_XinShouNew_LevelUp_Frame3_Bk7, [8] = TGM_XinShouNew_LevelUp_Frame3_Bk8,
		[9] = TGM_XinShouNew_LevelUp_Frame3_Bk9, [10] = TGM_XinShouNew_LevelUp_Frame3_Bk10, [11] = TGM_XinShouNew_LevelUp_Frame3_Bk11, [12] = TGM_XinShouNew_LevelUp_Frame3_Bk12,
		[13] = TGM_XinShouNew_LevelUp_Frame3_Bk13,
	}
	--���桾��ȡ��������ť��
	g_TGM_XinShouNew_LevelUp_GetGiftsButtonList =
	{
		[1] = TGM_XinShouNew_LevelUp_Frame3_Bk1_Button1,
		[2] = TGM_XinShouNew_LevelUp_Frame3_Bk2_Button1,
		[3] = TGM_XinShouNew_LevelUp_Frame3_Bk3_Button1,
		[4] = TGM_XinShouNew_LevelUp_Frame3_Bk4_Button1,
		[5] = TGM_XinShouNew_LevelUp_Frame3_Bk5_Button1,
		[6] = TGM_XinShouNew_LevelUp_Frame3_Bk6_Button1,
		[7] = TGM_XinShouNew_LevelUp_Frame3_Bk7_Button1,
		[8] = TGM_XinShouNew_LevelUp_Frame3_Bk8_Button1,
		[9] = TGM_XinShouNew_LevelUp_Frame3_Bk9_Button1,
		[10] = TGM_XinShouNew_LevelUp_Frame3_Bk10_Button1,
		[11] = TGM_XinShouNew_LevelUp_Frame3_Bk11_Button1,
		[12] = TGM_XinShouNew_LevelUp_Frame3_Bk12_Button1,
		[13] = TGM_XinShouNew_LevelUp_Frame3_Bk13_Button1,
	}
	--���·������¡������ͺ���End
	---------------------------------------------------------------------------------------------------------------------
	g_TGM_XinShouNew_BaiBao2_GiftsIcons =
	{
	[1] = {TGM_XinShouNew_BaiBao2_Frame3_Bk1_Icon1, TGM_XinShouNew_BaiBao2_Frame3_Bk1_Icon2, TGM_XinShouNew_BaiBao2_Frame3_Bk1_Icon3, TGM_XinShouNew_BaiBao2_Frame3_Bk1_Icon4, }, 
	[2] = {TGM_XinShouNew_BaiBao2_Frame3_Bk2_Icon1, TGM_XinShouNew_BaiBao2_Frame3_Bk2_Icon2, TGM_XinShouNew_BaiBao2_Frame3_Bk2_Icon3, TGM_XinShouNew_BaiBao2_Frame3_Bk2_Icon4, }, 
	[3] = {TGM_XinShouNew_BaiBao2_Frame3_Bk3_Icon1, TGM_XinShouNew_BaiBao2_Frame3_Bk3_Icon2, TGM_XinShouNew_BaiBao2_Frame3_Bk3_Icon3, TGM_XinShouNew_BaiBao2_Frame3_Bk3_Icon4, }, 
	[4] = {TGM_XinShouNew_BaiBao2_Frame3_Bk4_Icon1, TGM_XinShouNew_BaiBao2_Frame3_Bk4_Icon2, TGM_XinShouNew_BaiBao2_Frame3_Bk4_Icon3, TGM_XinShouNew_BaiBao2_Frame3_Bk4_Icon4, }, 
	[5] = {TGM_XinShouNew_BaiBao2_Frame3_Bk5_Icon1, TGM_XinShouNew_BaiBao2_Frame3_Bk5_Icon2, TGM_XinShouNew_BaiBao2_Frame3_Bk5_Icon3, TGM_XinShouNew_BaiBao2_Frame3_Bk5_Icon4, }, 
	[6] = {TGM_XinShouNew_BaiBao2_Frame3_Bk6_Icon1, TGM_XinShouNew_BaiBao2_Frame3_Bk6_Icon2, TGM_XinShouNew_BaiBao2_Frame3_Bk6_Icon3, TGM_XinShouNew_BaiBao2_Frame3_Bk6_Icon4, }, 
	[7] = {TGM_XinShouNew_BaiBao2_Frame3_Bk1_Icon1, TGM_XinShouNew_BaiBao2_Frame3_Bk1_Icon2, TGM_XinShouNew_BaiBao2_Frame3_Bk1_Icon3, TGM_XinShouNew_BaiBao2_Frame3_Bk1_Icon4, }, 
	[8] = {TGM_XinShouNew_BaiBao2_Frame3_Bk2_Icon1, TGM_XinShouNew_BaiBao2_Frame3_Bk2_Icon2, TGM_XinShouNew_BaiBao2_Frame3_Bk2_Icon3, TGM_XinShouNew_BaiBao2_Frame3_Bk2_Icon4, }, 
	[9] = {TGM_XinShouNew_BaiBao2_Frame3_Bk3_Icon1, TGM_XinShouNew_BaiBao2_Frame3_Bk3_Icon2, TGM_XinShouNew_BaiBao2_Frame3_Bk3_Icon3, TGM_XinShouNew_BaiBao2_Frame3_Bk3_Icon4, }, 
	[10] = {TGM_XinShouNew_BaiBao2_Frame3_Bk4_Icon1, TGM_XinShouNew_BaiBao2_Frame3_Bk4_Icon2, TGM_XinShouNew_BaiBao2_Frame3_Bk4_Icon3, TGM_XinShouNew_BaiBao2_Frame3_Bk4_Icon4, }, 

--	[7] = {TGM_XinShouNew_BaiBao2_Frame3_Bk7_Icon1, TGM_XinShouNew_BaiBao2_Frame3_Bk7_Icon2, TGM_XinShouNew_BaiBao2_Frame3_Bk7_Icon3, TGM_XinShouNew_BaiBao2_Frame3_Bk7_Icon4, }, 
--	[8] = {TGM_XinShouNew_BaiBao2_Frame3_Bk8_Icon1, TGM_XinShouNew_BaiBao2_Frame3_Bk8_Icon2, TGM_XinShouNew_BaiBao2_Frame3_Bk8_Icon3, TGM_XinShouNew_BaiBao2_Frame3_Bk8_Icon4, }, 
--	[9] = {TGM_XinShouNew_BaiBao2_Frame3_Bk9_Icon1, TGM_XinShouNew_BaiBao2_Frame3_Bk9_Icon2, TGM_XinShouNew_BaiBao2_Frame3_Bk9_Icon3, TGM_XinShouNew_BaiBao2_Frame3_Bk9_Icon4, }, 
--	[10] = {TGM_XinShouNew_BaiBao2_Frame3_Bk10_Icon1, TGM_XinShouNew_BaiBao2_Frame3_Bk10_Icon2, TGM_XinShouNew_BaiBao2_Frame3_Bk10_Icon3, TGM_XinShouNew_BaiBao2_Frame3_Bk10_Icon4, }, 
	}
	--��ң�� 2019-8-27 23:31:34
	g_TGM_XinShouNew_BaiBao2_GiftsIcons_NUM =
	{
	[1] = {TGM_XinShouNew_BaiBao2_Frame3_Bk1_Icon1_NUM, TGM_XinShouNew_BaiBao2_Frame3_Bk1_Icon2_NUM, TGM_XinShouNew_BaiBao2_Frame3_Bk1_Icon3_NUM, TGM_XinShouNew_BaiBao2_Frame3_Bk1_Icon4_NUM, }, 
	[2] = {TGM_XinShouNew_BaiBao2_Frame3_Bk2_Icon1_NUM, TGM_XinShouNew_BaiBao2_Frame3_Bk2_Icon2_NUM, TGM_XinShouNew_BaiBao2_Frame3_Bk2_Icon3_NUM, TGM_XinShouNew_BaiBao2_Frame3_Bk2_Icon4_NUM, }, 
	[3] = {TGM_XinShouNew_BaiBao2_Frame3_Bk3_Icon1_NUM, TGM_XinShouNew_BaiBao2_Frame3_Bk3_Icon2_NUM, TGM_XinShouNew_BaiBao2_Frame3_Bk3_Icon3_NUM, TGM_XinShouNew_BaiBao2_Frame3_Bk3_Icon4_NUM, }, 
	[4] = {TGM_XinShouNew_BaiBao2_Frame3_Bk4_Icon1_NUM, TGM_XinShouNew_BaiBao2_Frame3_Bk4_Icon2_NUM, TGM_XinShouNew_BaiBao2_Frame3_Bk4_Icon3_NUM, TGM_XinShouNew_BaiBao2_Frame3_Bk4_Icon4_NUM, }, 
	[5] = {TGM_XinShouNew_BaiBao2_Frame3_Bk5_Icon1_NUM, TGM_XinShouNew_BaiBao2_Frame3_Bk5_Icon2_NUM, TGM_XinShouNew_BaiBao2_Frame3_Bk5_Icon3_NUM, TGM_XinShouNew_BaiBao2_Frame3_Bk5_Icon4_NUM, }, 
	[6] = {TGM_XinShouNew_BaiBao2_Frame3_Bk6_Icon1_NUM, TGM_XinShouNew_BaiBao2_Frame3_Bk6_Icon2_NUM, TGM_XinShouNew_BaiBao2_Frame3_Bk6_Icon3_NUM, TGM_XinShouNew_BaiBao2_Frame3_Bk6_Icon4_NUM, }, 
	[7] = {TGM_XinShouNew_BaiBao2_Frame3_Bk1_Icon1_NUM, TGM_XinShouNew_BaiBao2_Frame3_Bk1_Icon2_NUM, TGM_XinShouNew_BaiBao2_Frame3_Bk1_Icon3_NUM, TGM_XinShouNew_BaiBao2_Frame3_Bk1_Icon4_NUM, }, 
	[8] = {TGM_XinShouNew_BaiBao2_Frame3_Bk2_Icon1_NUM, TGM_XinShouNew_BaiBao2_Frame3_Bk2_Icon2_NUM, TGM_XinShouNew_BaiBao2_Frame3_Bk2_Icon3_NUM, TGM_XinShouNew_BaiBao2_Frame3_Bk2_Icon4_NUM, }, 
	[9] = {TGM_XinShouNew_BaiBao2_Frame3_Bk3_Icon1_NUM, TGM_XinShouNew_BaiBao2_Frame3_Bk3_Icon2_NUM, TGM_XinShouNew_BaiBao2_Frame3_Bk3_Icon3_NUM, TGM_XinShouNew_BaiBao2_Frame3_Bk3_Icon4_NUM, }, 
	[10] = {TGM_XinShouNew_BaiBao2_Frame3_Bk4_Icon1_NUM, TGM_XinShouNew_BaiBao2_Frame3_Bk4_Icon2_NUM, TGM_XinShouNew_BaiBao2_Frame3_Bk4_Icon3_NUM, TGM_XinShouNew_BaiBao2_Frame3_Bk4_Icon4_NUM, }, 

--	[7] = {TGM_XinShouNew_BaiBao2_Frame3_Bk7_Icon1_NUM, TGM_XinShouNew_BaiBao2_Frame3_Bk7_Icon2_NUM, TGM_XinShouNew_BaiBao2_Frame3_Bk7_Icon3_NUM, TGM_XinShouNew_BaiBao2_Frame3_Bk7_Icon4_NUM, }, 
--	[8] = {TGM_XinShouNew_BaiBao2_Frame3_Bk8_Icon1_NUM, TGM_XinShouNew_BaiBao2_Frame3_Bk8_Icon2_NUM, TGM_XinShouNew_BaiBao2_Frame3_Bk8_Icon3_NUM, TGM_XinShouNew_BaiBao2_Frame3_Bk8_Icon4_NUM, }, 
--	[9] = {TGM_XinShouNew_BaiBao2_Frame3_Bk9_Icon1_NUM, TGM_XinShouNew_BaiBao2_Frame3_Bk9_Icon2_NUM, TGM_XinShouNew_BaiBao2_Frame3_Bk9_Icon3_NUM, TGM_XinShouNew_BaiBao2_Frame3_Bk9_Icon4_NUM, }, 
--	[10] = {TGM_XinShouNew_BaiBao2_Frame3_Bk10_Icon1_NUM, TGM_XinShouNew_BaiBao2_Frame3_Bk10_Icon2_NUM, TGM_XinShouNew_BaiBao2_Frame3_Bk10_Icon3_NUM, TGM_XinShouNew_BaiBao2_Frame3_Bk10_Icon4_NUM, }, 
	}
	
	g_TGM_XinShouNew_BaiBao2_GiftsIconImages =
	{
	[1] = {TGM_XinShouNew_BaiBao2_Frame3_Bk1_Icon1_Xin, TGM_XinShouNew_BaiBao2_Frame3_Bk1_Icon2_Xin, TGM_XinShouNew_BaiBao2_Frame3_Bk1_Icon3_Xin, TGM_XinShouNew_BaiBao2_Frame3_Bk1_Icon4_Xin, }, 
	[2] = {TGM_XinShouNew_BaiBao2_Frame3_Bk2_Icon1_Xin, TGM_XinShouNew_BaiBao2_Frame3_Bk2_Icon2_Xin, TGM_XinShouNew_BaiBao2_Frame3_Bk2_Icon3_Xin, TGM_XinShouNew_BaiBao2_Frame3_Bk2_Icon4_Xin, }, 
	[3] = {TGM_XinShouNew_BaiBao2_Frame3_Bk3_Icon1_Xin, TGM_XinShouNew_BaiBao2_Frame3_Bk3_Icon2_Xin, TGM_XinShouNew_BaiBao2_Frame3_Bk3_Icon3_Xin, TGM_XinShouNew_BaiBao2_Frame3_Bk3_Icon4_Xin, }, 
	[4] = {TGM_XinShouNew_BaiBao2_Frame3_Bk4_Icon1_Xin, TGM_XinShouNew_BaiBao2_Frame3_Bk4_Icon2_Xin, TGM_XinShouNew_BaiBao2_Frame3_Bk4_Icon3_Xin, TGM_XinShouNew_BaiBao2_Frame3_Bk4_Icon4_Xin, }, 
	[5] = {TGM_XinShouNew_BaiBao2_Frame3_Bk5_Icon1_Xin, TGM_XinShouNew_BaiBao2_Frame3_Bk5_Icon2_Xin, TGM_XinShouNew_BaiBao2_Frame3_Bk5_Icon3_Xin, TGM_XinShouNew_BaiBao2_Frame3_Bk5_Icon4_Xin, }, 
	[6] = {TGM_XinShouNew_BaiBao2_Frame3_Bk6_Icon1_Xin, TGM_XinShouNew_BaiBao2_Frame3_Bk6_Icon2_Xin, TGM_XinShouNew_BaiBao2_Frame3_Bk6_Icon3_Xin, TGM_XinShouNew_BaiBao2_Frame3_Bk6_Icon4_Xin, }, 
	[7] = {TGM_XinShouNew_BaiBao2_Frame3_Bk1_Icon1_Xin, TGM_XinShouNew_BaiBao2_Frame3_Bk1_Icon2_Xin, TGM_XinShouNew_BaiBao2_Frame3_Bk1_Icon3_Xin, TGM_XinShouNew_BaiBao2_Frame3_Bk1_Icon4_Xin, }, 
	[8] = {TGM_XinShouNew_BaiBao2_Frame3_Bk2_Icon1_Xin, TGM_XinShouNew_BaiBao2_Frame3_Bk2_Icon2_Xin, TGM_XinShouNew_BaiBao2_Frame3_Bk2_Icon3_Xin, TGM_XinShouNew_BaiBao2_Frame3_Bk2_Icon4_Xin, }, 
	[9] = {TGM_XinShouNew_BaiBao2_Frame3_Bk3_Icon1_Xin, TGM_XinShouNew_BaiBao2_Frame3_Bk3_Icon2_Xin, TGM_XinShouNew_BaiBao2_Frame3_Bk3_Icon3_Xin, TGM_XinShouNew_BaiBao2_Frame3_Bk3_Icon4_Xin, }, 
	[10] = {TGM_XinShouNew_BaiBao2_Frame3_Bk4_Icon1_Xin, TGM_XinShouNew_BaiBao2_Frame3_Bk4_Icon2_Xin, TGM_XinShouNew_BaiBao2_Frame3_Bk4_Icon3_Xin, TGM_XinShouNew_BaiBao2_Frame3_Bk4_Icon4_Xin, }, 

--	[7] = {TGM_XinShouNew_BaiBao2_Frame3_Bk7_Icon1_Xin, TGM_XinShouNew_BaiBao2_Frame3_Bk7_Icon2_Xin, TGM_XinShouNew_BaiBao2_Frame3_Bk7_Icon3_Xin, TGM_XinShouNew_BaiBao2_Frame3_Bk7_Icon4_Xin, }, 
--	[8] = {TGM_XinShouNew_BaiBao2_Frame3_Bk8_Icon1_Xin, TGM_XinShouNew_BaiBao2_Frame3_Bk8_Icon2_Xin, TGM_XinShouNew_BaiBao2_Frame3_Bk8_Icon3_Xin, TGM_XinShouNew_BaiBao2_Frame3_Bk8_Icon4_Xin, }, 
--	[9] = {TGM_XinShouNew_BaiBao2_Frame3_Bk9_Icon1_Xin, TGM_XinShouNew_BaiBao2_Frame3_Bk9_Icon2_Xin, TGM_XinShouNew_BaiBao2_Frame3_Bk9_Icon3_Xin, TGM_XinShouNew_BaiBao2_Frame3_Bk9_Icon4_Xin, }, 
--	[10] = {TGM_XinShouNew_BaiBao2_Frame3_Bk10_Icon1_Xin, TGM_XinShouNew_BaiBao2_Frame3_Bk10_Icon2_Xin, TGM_XinShouNew_BaiBao2_Frame3_Bk10_Icon3_Xin, TGM_XinShouNew_BaiBao2_Frame3_Bk10_Icon4_Xin, }, 
	}

	--���桾��ȡ��������ť��
	g_TGM_XinShouNew_BaiBao2_GetGiftsButtonList =
	{
		[1] = TGM_XinShouNew_BaiBao2_Frame3_Bk1_Button1,
		[2] = TGM_XinShouNew_BaiBao2_Frame3_Bk2_Button1,
		[3] = TGM_XinShouNew_BaiBao2_Frame3_Bk3_Button1,
		[4] = TGM_XinShouNew_BaiBao2_Frame3_Bk4_Button1,
		[5] = TGM_XinShouNew_BaiBao2_Frame3_Bk5_Button1,
		[6] = TGM_XinShouNew_BaiBao2_Frame3_Bk6_Button1,
		
		[7] = TGM_XinShouNew_BaiBao2_Frame3_Bk1_Button1,
		[8] = TGM_XinShouNew_BaiBao2_Frame3_Bk2_Button1,
		[9] = TGM_XinShouNew_BaiBao2_Frame3_Bk3_Button1,
		[10] = TGM_XinShouNew_BaiBao2_Frame3_Bk4_Button1,
	}

	--������ȡ������ʾText�ؼ���,�߻���Ҫ������������̬��ʾ=...=
	g_TGM_XinShouNew_BaiBao2_NotifyTipsControlList = 
	{ 
		[1] = { LevelText =  TGM_XinShouNew_BaiBao2_Frame3_Bk1_Text1_1, YBText = TGM_XinShouNew_BaiBao2_Frame3_Bk1_Text1_2, CostYBText = TGM_XinShouNew_BaiBao2_Frame3_Bk1_Text1_2_1, },
		[2] = { LevelText =  TGM_XinShouNew_BaiBao2_Frame3_Bk2_Text1_1, YBText = TGM_XinShouNew_BaiBao2_Frame3_Bk2_Text1_2, CostYBText = TGM_XinShouNew_BaiBao2_Frame3_Bk2_Text1_2_1, },
		[3] = { LevelText =  TGM_XinShouNew_BaiBao2_Frame3_Bk3_Text1_1, YBText = TGM_XinShouNew_BaiBao2_Frame3_Bk3_Text1_2, CostYBText = TGM_XinShouNew_BaiBao2_Frame3_Bk3_Text1_2_1, },
		[4] = { LevelText =  TGM_XinShouNew_BaiBao2_Frame3_Bk4_Text1_1, YBText = TGM_XinShouNew_BaiBao2_Frame3_Bk4_Text1_2, CostYBText = TGM_XinShouNew_BaiBao2_Frame3_Bk4_Text1_2_1, },
		[5] = { LevelText =  TGM_XinShouNew_BaiBao2_Frame3_Bk5_Text1_1, YBText = TGM_XinShouNew_BaiBao2_Frame3_Bk5_Text1_2, CostYBText = TGM_XinShouNew_BaiBao2_Frame3_Bk5_Text1_2_1, },
		[6] = { LevelText =  TGM_XinShouNew_BaiBao2_Frame3_Bk6_Text1_1, YBText = TGM_XinShouNew_BaiBao2_Frame3_Bk6_Text1_2, CostYBText = TGM_XinShouNew_BaiBao2_Frame3_Bk6_Text1_2_1, },
		
		[7] = { LevelText =  TGM_XinShouNew_BaiBao2_Frame3_Bk1_Text1_1, YBText = TGM_XinShouNew_BaiBao2_Frame3_Bk1_Text1_2, CostYBText = TGM_XinShouNew_BaiBao2_Frame3_Bk1_Text1_2_1, },
		[8] = { LevelText =  TGM_XinShouNew_BaiBao2_Frame3_Bk2_Text1_1, YBText = TGM_XinShouNew_BaiBao2_Frame3_Bk2_Text1_2, CostYBText = TGM_XinShouNew_BaiBao2_Frame3_Bk2_Text1_2_1, },
		[9] = { LevelText =  TGM_XinShouNew_BaiBao2_Frame3_Bk3_Text1_1, YBText = TGM_XinShouNew_BaiBao2_Frame3_Bk3_Text1_2, CostYBText = TGM_XinShouNew_BaiBao2_Frame3_Bk3_Text1_2_1, },
		[10] = { LevelText =  TGM_XinShouNew_BaiBao2_Frame3_Bk4_Text1_1, YBText = TGM_XinShouNew_BaiBao2_Frame3_Bk4_Text1_2, CostYBText = TGM_XinShouNew_BaiBao2_Frame3_Bk4_Text1_2_1, },
	}
	
	--���������ͼƬ ��ң�� 2019-9-3 15:02:31
	g_TGM_XinShouNew_BaiBao2_LeftImage = {
		TGM_XinShouNew_BaiBao2_Frame3_Bk1_Info2,TGM_XinShouNew_BaiBao2_Frame3_Bk2_Info2,TGM_XinShouNew_BaiBao2_Frame3_Bk3_Info2,
		TGM_XinShouNew_BaiBao2_Frame3_Bk4_Info2,TGM_XinShouNew_BaiBao2_Frame3_Bk5_Info2,TGM_XinShouNew_BaiBao2_Frame3_Bk6_Info2,
		TGM_XinShouNew_BaiBao2_Frame3_Bk1_Info2,TGM_XinShouNew_BaiBao2_Frame3_Bk2_Info2,TGM_XinShouNew_BaiBao2_Frame3_Bk3_Info2,
		TGM_XinShouNew_BaiBao2_Frame3_Bk4_Info2,
	}
	-- Ӣ�۰ٱ���begin
	------------------------------------------------------------------------------------------------------------------------------
	--��������ʾ������Ʒ��ICON��
	g_TGM_XinShouNew_BaiBao_GiftsIcons =
	{
	[1] = {TGM_XinShouNew_BaiBao_Frame3_Bk1_Icon1, TGM_XinShouNew_BaiBao_Frame3_Bk1_Icon2, TGM_XinShouNew_BaiBao_Frame3_Bk1_Icon3, TGM_XinShouNew_BaiBao_Frame3_Bk1_Icon4, }, 
	[2] = {TGM_XinShouNew_BaiBao_Frame3_Bk2_Icon1, TGM_XinShouNew_BaiBao_Frame3_Bk2_Icon2, TGM_XinShouNew_BaiBao_Frame3_Bk2_Icon3, TGM_XinShouNew_BaiBao_Frame3_Bk2_Icon4, }, 
	[3] = {TGM_XinShouNew_BaiBao_Frame3_Bk3_Icon1, TGM_XinShouNew_BaiBao_Frame3_Bk3_Icon2, TGM_XinShouNew_BaiBao_Frame3_Bk3_Icon3, TGM_XinShouNew_BaiBao_Frame3_Bk3_Icon4, }, 
	[4] = {TGM_XinShouNew_BaiBao_Frame3_Bk4_Icon1, TGM_XinShouNew_BaiBao_Frame3_Bk4_Icon2, TGM_XinShouNew_BaiBao_Frame3_Bk4_Icon3, TGM_XinShouNew_BaiBao_Frame3_Bk4_Icon4, }, 
	[5] = {TGM_XinShouNew_BaiBao_Frame3_Bk5_Icon1, TGM_XinShouNew_BaiBao_Frame3_Bk5_Icon2, TGM_XinShouNew_BaiBao_Frame3_Bk5_Icon3, TGM_XinShouNew_BaiBao_Frame3_Bk5_Icon4, }, 
	[6] = {TGM_XinShouNew_BaiBao_Frame3_Bk6_Icon1, TGM_XinShouNew_BaiBao_Frame3_Bk6_Icon2, TGM_XinShouNew_BaiBao_Frame3_Bk6_Icon3, TGM_XinShouNew_BaiBao_Frame3_Bk6_Icon4, }, 
	}
	g_TGM_XinShouNew_BaiBao_GiftsIcons_NUM =
	{
	[1] = {TGM_XinShouNew_BaiBao_Frame3_Bk1_Icon1_NUM, TGM_XinShouNew_BaiBao_Frame3_Bk1_Icon2_NUM, TGM_XinShouNew_BaiBao_Frame3_Bk1_Icon3_NUM, TGM_XinShouNew_BaiBao_Frame3_Bk1_Icon4_NUM, }, 
	[2] = {TGM_XinShouNew_BaiBao_Frame3_Bk2_Icon1_NUM, TGM_XinShouNew_BaiBao_Frame3_Bk2_Icon2_NUM, TGM_XinShouNew_BaiBao_Frame3_Bk2_Icon3_NUM, TGM_XinShouNew_BaiBao_Frame3_Bk2_Icon4_NUM, }, 
	[3] = {TGM_XinShouNew_BaiBao_Frame3_Bk3_Icon1_NUM, TGM_XinShouNew_BaiBao_Frame3_Bk3_Icon2_NUM, TGM_XinShouNew_BaiBao_Frame3_Bk3_Icon3_NUM, TGM_XinShouNew_BaiBao_Frame3_Bk3_Icon4_NUM, }, 
	[4] = {TGM_XinShouNew_BaiBao_Frame3_Bk4_Icon1_NUM, TGM_XinShouNew_BaiBao_Frame3_Bk4_Icon2_NUM, TGM_XinShouNew_BaiBao_Frame3_Bk4_Icon3_NUM, TGM_XinShouNew_BaiBao_Frame3_Bk4_Icon4_NUM, }, 
	[5] = {TGM_XinShouNew_BaiBao_Frame3_Bk5_Icon1_NUM, TGM_XinShouNew_BaiBao_Frame3_Bk5_Icon2_NUM, TGM_XinShouNew_BaiBao_Frame3_Bk5_Icon3_NUM, TGM_XinShouNew_BaiBao_Frame3_Bk5_Icon4_NUM, }, 
	[6] = {TGM_XinShouNew_BaiBao_Frame3_Bk6_Icon1_NUM, TGM_XinShouNew_BaiBao_Frame3_Bk6_Icon2_NUM, TGM_XinShouNew_BaiBao_Frame3_Bk6_Icon3_NUM, TGM_XinShouNew_BaiBao_Frame3_Bk6_Icon4_NUM, }, 
	}
--	for i = 1,6 do
--		for j = 1,4 do
--			g_TGM_XinShouNew_BaiBao_GiftsIcons_NUM[i][j] = _G[string.format("TGM_XinShouNew_BaiBao_Frame3_Bk%d_Icon%d_NUM",i,j)]
--		end
--	end
	g_TGM_XinShouNew_BaiBao_GiftsIconImages =
	{
	[1] = {TGM_XinShouNew_BaiBao_Frame3_Bk1_Icon1_Xin, TGM_XinShouNew_BaiBao_Frame3_Bk1_Icon2_Xin, TGM_XinShouNew_BaiBao_Frame3_Bk1_Icon3_Xin, TGM_XinShouNew_BaiBao_Frame3_Bk1_Icon4_Xin, }, 
	[2] = {TGM_XinShouNew_BaiBao_Frame3_Bk2_Icon1_Xin, TGM_XinShouNew_BaiBao_Frame3_Bk2_Icon2_Xin, TGM_XinShouNew_BaiBao_Frame3_Bk2_Icon3_Xin, TGM_XinShouNew_BaiBao_Frame3_Bk2_Icon4_Xin, }, 
	[3] = {TGM_XinShouNew_BaiBao_Frame3_Bk3_Icon1_Xin, TGM_XinShouNew_BaiBao_Frame3_Bk3_Icon2_Xin, TGM_XinShouNew_BaiBao_Frame3_Bk3_Icon3_Xin, TGM_XinShouNew_BaiBao_Frame3_Bk3_Icon4_Xin, }, 
	[4] = {TGM_XinShouNew_BaiBao_Frame3_Bk4_Icon1_Xin, TGM_XinShouNew_BaiBao_Frame3_Bk4_Icon2_Xin, TGM_XinShouNew_BaiBao_Frame3_Bk4_Icon3_Xin, TGM_XinShouNew_BaiBao_Frame3_Bk4_Icon4_Xin, }, 
	[5] = {TGM_XinShouNew_BaiBao_Frame3_Bk5_Icon1_Xin, TGM_XinShouNew_BaiBao_Frame3_Bk5_Icon2_Xin, TGM_XinShouNew_BaiBao_Frame3_Bk5_Icon3_Xin, TGM_XinShouNew_BaiBao_Frame3_Bk5_Icon4_Xin, }, 
	[6] = {TGM_XinShouNew_BaiBao_Frame3_Bk6_Icon1_Xin, TGM_XinShouNew_BaiBao_Frame3_Bk6_Icon2_Xin, TGM_XinShouNew_BaiBao_Frame3_Bk6_Icon3_Xin, TGM_XinShouNew_BaiBao_Frame3_Bk6_Icon4_Xin, }, 
	}

	--���桾��ȡ��������ť��
	g_TGM_XinShouNew_BaiBao_GetGiftsButtonList =
	{
		[1] = TGM_XinShouNew_BaiBao_Frame3_Bk1_Button1,
		[2] = TGM_XinShouNew_BaiBao_Frame3_Bk2_Button1,
		[3] = TGM_XinShouNew_BaiBao_Frame3_Bk3_Button1,
		[4] = TGM_XinShouNew_BaiBao_Frame3_Bk4_Button1,
		[5] = TGM_XinShouNew_BaiBao_Frame3_Bk5_Button1,
		[6] = TGM_XinShouNew_BaiBao_Frame3_Bk6_Button1,
	}

	--������ȡ������ʾText�ؼ���,�߻���Ҫ������������̬��ʾ=...=
	g_TGM_XinShouNew_BaiBao_NotifyTipsControlList = 
	{ 
		[1] = { LevelText =  TGM_XinShouNew_BaiBao_Frame3_Bk1_Text1_1, YBText = TGM_XinShouNew_BaiBao_Frame3_Bk1_Text1_2, CostYBText = TGM_XinShouNew_BaiBao_Frame3_Bk1_Text1_2_1, },
		[2] = { LevelText =  TGM_XinShouNew_BaiBao_Frame3_Bk2_Text1_1, YBText = TGM_XinShouNew_BaiBao_Frame3_Bk2_Text1_2, CostYBText = TGM_XinShouNew_BaiBao_Frame3_Bk2_Text1_2_1, },
		[3] = { LevelText =  TGM_XinShouNew_BaiBao_Frame3_Bk3_Text1_1, YBText = TGM_XinShouNew_BaiBao_Frame3_Bk3_Text1_2, CostYBText = TGM_XinShouNew_BaiBao_Frame3_Bk3_Text1_2_1, },
		[4] = { LevelText =  TGM_XinShouNew_BaiBao_Frame3_Bk4_Text1_1, YBText = TGM_XinShouNew_BaiBao_Frame3_Bk4_Text1_2, CostYBText = TGM_XinShouNew_BaiBao_Frame3_Bk4_Text1_2_1, },
		[5] = { LevelText =  TGM_XinShouNew_BaiBao_Frame3_Bk5_Text1_1, YBText = TGM_XinShouNew_BaiBao_Frame3_Bk5_Text1_2, CostYBText = TGM_XinShouNew_BaiBao_Frame3_Bk5_Text1_2_1, },
		[6] = { LevelText =  TGM_XinShouNew_BaiBao_Frame3_Bk6_Text1_1, YBText = TGM_XinShouNew_BaiBao_Frame3_Bk6_Text1_2, CostYBText = TGM_XinShouNew_BaiBao_Frame3_Bk6_Text1_2_1, },
	}

	-- Ӣ�۰ٱ���end

	-- ����������begin
	g_TGM_XinShouNew_LuckyDraw_GiftsIcons =
	{
	[1] = {TGM_XinShouNew_LuckStar_Frame3_Bk2_Icon1, }, 
	[2] = {TGM_XinShouNew_LuckStar_Frame3_Bk2_Icon2, }, 
	[3] = {TGM_XinShouNew_LuckStar_Frame3_Bk2_Icon3, }, 
	[4] = {TGM_XinShouNew_LuckStar_Frame3_Bk2_Icon4, }, 
	[5] = {TGM_XinShouNew_LuckStar_Frame3_Bk2_Icon5, }, 
	[6] = {TGM_XinShouNew_LuckStar_Frame3_Bk2_Icon6, }, 
	[7] = {TGM_XinShouNew_LuckStar_Frame3_Bk2_Icon7, }, 
	[8] = {TGM_XinShouNew_LuckStar_Frame3_Bk2_Icon8, }, 
	[9] = {TGM_XinShouNew_LuckStar_Frame3_Bk2_Icon9, }, 
	}

	g_TGM_XinShouNew_LuckyDraw_GiftsIconImages =
	{
	[1] = {TGM_XinShouNew_LuckStar_Frame3_Bk2_Icon1_Xin, }, 
	[2] = {TGM_XinShouNew_LuckStar_Frame3_Bk2_Icon2_Xin, }, 
	[3] = {TGM_XinShouNew_LuckStar_Frame3_Bk2_Icon3_Xin, }, 
	[4] = {TGM_XinShouNew_LuckStar_Frame3_Bk2_Icon4_Xin, }, 
	[5] = {TGM_XinShouNew_LuckStar_Frame3_Bk2_Icon5_Xin, }, 
	[6] = {TGM_XinShouNew_LuckStar_Frame3_Bk2_Icon6_Xin, }, 
	[7] = {TGM_XinShouNew_LuckStar_Frame3_Bk2_Icon7_Xin, }, 
	[8] = {TGM_XinShouNew_LuckStar_Frame3_Bk2_Icon8_Xin, }, 
	[9] = {TGM_XinShouNew_LuckStar_Frame3_Bk2_Icon9_Xin, }, 
	}
	
--	g_TGM_XinShouNew_LuckyDraw_GiftLightImage =
--	{
--	[1] = TGM_XinShouNew_LuckStar_Frame3_Bk2_Icon1_Image,
--	[2] = TGM_XinShouNew_LuckStar_Frame3_Bk2_Icon2_Image,
--	[3] = TGM_XinShouNew_LuckStar_Frame3_Bk2_Icon3_Image,
--	[4] = TGM_XinShouNew_LuckStar_Frame3_Bk2_Icon4_Image, 
--	[5] = TGM_XinShouNew_LuckStar_Frame3_Bk2_Icon5_Image, 
--	[6] = TGM_XinShouNew_LuckStar_Frame3_Bk2_Icon6_Image,  
--	[7] = TGM_XinShouNew_LuckStar_Frame3_Bk2_Icon7_Image, 
--	[8] = TGM_XinShouNew_LuckStar_Frame3_Bk2_Icon8_Image, 
--	[9] = TGM_XinShouNew_LuckStar_Frame3_Bk2_Icon9_Image,  
--	}
	g_TGM_XinShouNew_LuckyDraw_GiftLightImage =
	{
	[1] = TGM_XinShouNew_LuckStar_Frame3_Bk2_Icon1_Image_Animate,
	[2] = TGM_XinShouNew_LuckStar_Frame3_Bk2_Icon2_Image_Animate,
	[3] = TGM_XinShouNew_LuckStar_Frame3_Bk2_Icon3_Image_Animate,
	[4] = TGM_XinShouNew_LuckStar_Frame3_Bk2_Icon4_Image_Animate, 
	[5] = TGM_XinShouNew_LuckStar_Frame3_Bk2_Icon5_Image_Animate, 
	[6] = TGM_XinShouNew_LuckStar_Frame3_Bk2_Icon6_Image_Animate,  
	[7] = TGM_XinShouNew_LuckStar_Frame3_Bk2_Icon7_Image_Animate, 
	[8] = TGM_XinShouNew_LuckStar_Frame3_Bk2_Icon8_Image_Animate, 
	[9] = TGM_XinShouNew_LuckStar_Frame3_Bk2_Icon9_Image_Animate,  
	}
	-- ����������end 


	g_HaoXialuRed[1]  = TGM_XinShouNew_Heroes_RoadBK_day1_Button1_tips;
	g_HaoXialuRed[2]  = TGM_XinShouNew_Heroes_RoadBK_day2_Button1_tips;
	g_HaoXialuRed[3]  = TGM_XinShouNew_Heroes_RoadBK_day3_Button1_tips;
	g_HaoXialuRed[4]  = TGM_XinShouNew_Heroes_RoadBK_day4_Button1_tips;
	g_HaoXialuRed[5]  = TGM_XinShouNew_Heroes_RoadBK_day5_Button1_tips;
	g_HaoXialuRed[6]  = TGM_XinShouNew_Heroes_RoadBK_day6_Button1_tips;	
	g_HaoXialuRed[7]  = TGM_XinShouNew_Heroes_RoadBK_day7_Button1_tips;	
	
	--����������
	for i = 1,table.getn(g_TGM_XinShouNew_LuckyDraw_GiftLightImage) do
		g_TGM_XinShouNew_LuckyDraw_GiftLightImage[i]:Hide()
	end
	
	TGM_XinShouNew_SheJiaoInit()	
	TGM_XinShouNew_SheJiaoNew_Init()
end

--===============================================
-- SetButtonPos()
--===============================================
function TGM_XinShouNew_SetButtonPos()
	g_TGM_XinShouNew_Frames =
	{
		[1] = TGM_XinShouNew_DoubleExp_RewardFrame,
		[2] = TGM_XinShouNew_Seven_DayFrame,
		[3] = TGM_XinShouNew_SaveUp_RewardFrame,
		[4] = TGM_XinShouNew_Time_LimitFrame,
		[5] = TGM_XinShouNew_Heroes_RoadFrame,
		[6] = TGM_XinShouNew_Supe_ValueFrame,
		[7] = TGM_XinShouNew_LevelUp_RewardFrame,
		[8] = TGM_XinShouNew_BaiBao_RewardFrame,
		[9] = TGM_XinShouNew_LuckStar_RewardFrame,
		[10]= TGM_XinShouNew_SheJiaoDaRen_RewardFrame,
		[11] = TGM_XinShouNew_SheJiaoFrame,
	}
	g_TGM_XinShouNew_Button[1] 	= TGM_XinShouNew_Button01; --
	g_TGM_XinShouNew_Button[2] 	= TGM_XinShouNew_Button02; --
	g_TGM_XinShouNew_Button[3] 	= TGM_XinShouNew_Button03;
	g_TGM_XinShouNew_Button[4] 	= TGM_XinShouNew_Button04;
	g_TGM_XinShouNew_Button[5] 	= TGM_XinShouNew_Button05;
	g_TGM_XinShouNew_Button[6] 	= TGM_XinShouNew_Button06;
	g_TGM_XinShouNew_Button[7] 	= TGM_XinShouNew_Button07;
	g_TGM_XinShouNew_Button[8] 	= TGM_XinShouNew_Button08;
	g_TGM_XinShouNew_Button[9] 	= TGM_XinShouNew_Button09;
	g_TGM_XinShouNew_Button[10] = TGM_XinShouNew_Button10;
	g_TGM_XinShouNew_Button[11] = TGM_XinShouNew_Button11;

	g_TGM_XinShouNew_Tip[1] 		= TGM_XinShouNew_Button01tips;
	g_TGM_XinShouNew_Tip[2] 		= TGM_XinShouNew_Button02tips;
	g_TGM_XinShouNew_Tip[3] 		= TGM_XinShouNew_Button03tips;
	g_TGM_XinShouNew_Tip[4] 		= TGM_XinShouNew_Button04tips;
	g_TGM_XinShouNew_Tip[5] 		= TGM_XinShouNew_Button05tips;
	g_TGM_XinShouNew_Tip[6] 		= TGM_XinShouNew_Button06tips;
	g_TGM_XinShouNew_Tip[7] 		= TGM_XinShouNew_Button07tips;
	g_TGM_XinShouNew_Tip[8] 		= TGM_XinShouNew_Button08tips;
	g_TGM_XinShouNew_Tip[9] 		= TGM_XinShouNew_Button09tips;
	g_TGM_XinShouNew_Tip[10] 		= TGM_XinShouNew_Button10tips;
	g_TGM_XinShouNew_Tip[11] 		= TGM_XinShouNew_Button11tips;
	--�׳�
	TGM_XinShouNew_ShouChong_LoadControl()
	--��ʱ��ֵ������
	TGM_XinShouNew_LimitedSaveUp_LoadControl()
	--����·
	g_TGM_XinShouNew_Heroes_Road_Button[1] = TGM_XinShouNew_Heroes_RoadBK_day1_Button1;
	g_TGM_XinShouNew_Heroes_Road_Button[2] = TGM_XinShouNew_Heroes_RoadBK_day2_Button1;
	g_TGM_XinShouNew_Heroes_Road_Button[3] = TGM_XinShouNew_Heroes_RoadBK_day3_Button1;
	g_TGM_XinShouNew_Heroes_Road_Button[4] = TGM_XinShouNew_Heroes_RoadBK_day4_Button1;
	g_TGM_XinShouNew_Heroes_Road_Button[5] = TGM_XinShouNew_Heroes_RoadBK_day5_Button1;
	g_TGM_XinShouNew_Heroes_Road_Button[6] = TGM_XinShouNew_Heroes_RoadBK_day6_Button1;
	g_TGM_XinShouNew_Heroes_Road_Button[7] = TGM_XinShouNew_Heroes_RoadBK_day7_Button1;

end
--===============================================
-- Hide()
--===============================================
function TGM_XinShouNew_Hide() 
	TGM_XinShouNew_Close()
end

--===============================================
-- Close()
--===============================================
function TGM_XinShouNew_Close() 
	g_TGM_XinShouNew_ShouChong_LoadFirstTime = 1;
	g_TGM_XinShouNew_LevelUp_LoadFirstTime   = 1;
	g_TGM_XinShouNew_LuckyDraw_LoadFirstTime = 1;
	g_TGM_XinShouNew_BaiBao_LoadFirstTime 	 = 1;
	g_TGM_XinShouNew_SuperSaveUp_LoadFirstTime = 1;
	g_SheJiaoIsFillIcon 					 = 0;
	g_EventIndex = -1
	this:Hide()
	
end
--===============================================
-- ResetPos()
--===============================================
function TGM_XinShouNew_On_ResetPos()
	TGM_XinShouNew_Frame:SetProperty("UnifiedPosition", g_TGM_XinShouNew_Frame_UnifiedPosition)
end

--===============================================
-- Open()
--===============================================
function  TGM_XinShouNew_Open()
	
	for index=1,table.getn(g_TGM_XinShouNew_Event) do
		local event = g_TGM_XinShouNew_Event[index]
		event.isShow = 0
	end

	for index=1,table.getn(g_TGM_XinShouNew_Button) do
		g_TGM_XinShouNew_Button[index]:Hide()
		g_TGM_XinShouNew_Tip[index]:Hide()
	end
	
	for index=1,table.getn(g_TGM_XinShouNew_Button)  do
		local ButtonState,TipsState = 1,0
		if index == 10 then
		    g_Button_StateTemp[index] = 0 --�ɰ�����
		elseif index == 5 then
			g_Button_StateTemp[index] = 0 --����֮·����
		else
			g_Button_StateTemp[index] 	 = ButtonState
		end
		if index == 8 and g_TGM_XinShouNew_HeroBag_IsShowTips == 0 then
		   g_Tips_StateTemp[index] 	   = 0
		else
		 	g_Tips_StateTemp[index] 	   = TipsState
		end
	end
	
	local buttonId = 1
	for index=1,table.getn(g_TGM_XinShouNew_Event) do
		local isButtonShow = g_Button_StateTemp[index]
		local isTipsShow   = g_Tips_StateTemp[index]
		local event  = g_TGM_XinShouNew_Event[index]
		if isButtonShow == 1 then
			g_TGM_XinShouNew_Button[buttonId]:SetText(event.text)
			g_TGM_XinShouNew_Button[buttonId]:Show()
			if isTipsShow == 1 then
				g_TGM_XinShouNew_Tip[buttonId]:Show()
			end
			event.isShow = 1
			buttonId = buttonId+1
		end
	end
	
	TGM_XinShouNew_Project_Clicked( 1 )
	this:Show()

end

--===============================================
-- Clicked() �ҵ������ĺ���
--===============================================
function TGM_XinShouNew_Project_Clicked(clickId)
	if(clickId == g_TGM_XinShouNew_LastClickedId) then
		return
	end
	if clickId == 4 then
	PushDebugMessage("�ȴ�������ʱ��ֵ��������")
	return
	end
	local curTime = FindFriendDataPool:GetTickCount();
	if ( curTime - g_TGM_XinShouNew_ButtonLastTime < g_TGM_XinShouNew_ButtonCDTime * 1000) then
   	for index=1,table.getn(g_TGM_XinShouNew_Button) do
			if index==g_TGM_XinShouNew_LastClickedId then
				-- g_TGM_XinShouNew_Button[index]:SetCheck(1)
			else
				-- g_TGM_XinShouNew_Button[index]:SetCheck(0)
			end
		end
--		PushDebugMessage("#{ZYPT_081127_2}"); --����������������Ե�Ƭ�̺��ٵ��
--		return
	end
	g_TGM_XinShouNew_ButtonLastTime = curTime;

	local buttonId = 0
	for index=1,table.getn(g_TGM_XinShouNew_Event) do
		local event = g_TGM_XinShouNew_Event[index]
		if event.isShow == 1 then
			buttonId = buttonId + 1
			if buttonId == clickId then
				g_EventIndex = index
				break
			end
		end
	end

	for index=1,table.getn(g_TGM_XinShouNew_Button) do
		if index==clickId then
			-- g_TGM_XinShouNew_Button[index]:SetCheck(1)
		else
			-- g_TGM_XinShouNew_Button[index]:SetCheck(0)
		end
	end
	g_TGM_XinShouNew_LastClickedId = clickId

	for index=1,table.getn(g_TGM_XinShouNew_Frames) do
		if index~=g_EventIndex then
			g_TGM_XinShouNew_Frames[index]:Hide()
		else
			g_TGM_XinShouNew_Frames[index]:Show()
		end
	end
	if g_EventIndex==1 then
		TGM_XinShouNew_DoubleExp_Show()	--˫���ַ���
	elseif g_EventIndex == 2 then --7���׺���
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "Ask7DayPrize" );
			Set_XSCRIPT_ScriptID(990016);	
			Set_XSCRIPT_ParamCount(0);
		Send_XSCRIPT() 
		return
	elseif g_EventIndex==3 then
		TGM_XinShouNew_ShouChong_Show(1)	--�׳䳬ֵ��
	elseif g_EventIndex==4 then
		PushDebugMessage("�ȴ�������ʱ��ֵ��������")--��ʱ��ֵ������
	elseif g_EventIndex==5 then
		TGM_XinShouNew_Heroes_Road_Ask()	--��������·
	elseif g_EventIndex == 6 then 
		TGM_XinShouNew_SuperSaveUp_Show()
	elseif g_EventIndex == 7 then  --�����к���
		TGM_XinShouNew_LevelUp_OnShow(1)
	elseif g_EventIndex == 8 then  --Ӣ�۰ٱ��� 
		g_TGM_XinShouNew_HeroBag_IsShowTips = 0;
		g_Tips_StateTemp[8] = 0
		TGM_XinShouNew_BaiBao_OnShow(1)
		TGM_XinShouNew_ShowButtonTips()
	elseif g_EventIndex == 9 then  --����������
		TGM_XinShouNew_LuckyDraw_Show(1)
	elseif g_EventIndex == 10 then --�罻����
		TGM_XinShouNew_SheJiaoDaRen_Show()
	elseif g_EventIndex == 11 then --�°�����Я����
		TGM_XinShouNew_SheJiaoNew_Show()
	else
		-- return
	end
	-- TGM_XinShouNew_SuperSaveUp_Show()
	this:Show()
end
--===============================================
-- ����Button С���
--===============================================
function TGM_XinShouNew_ShowButtonTips()   --nIndex,nIsShow
 
	local buttonId = 1
	for index=1,table.getn(g_TGM_XinShouNew_Event) do
		local isButtonShow = g_Button_StateTemp[index]
		local isTipsShow   = g_Tips_StateTemp[index] 
		if isButtonShow == 1 then 
			if isTipsShow == 1 then
				g_TGM_XinShouNew_Tip[buttonId]:Show() 
			else
				g_TGM_XinShouNew_Tip[buttonId]:Hide()
			end 
			buttonId = buttonId+1
		end
	end 
	
	local IsHideMiniMapPoint = 0
	for index=1,table.getn(g_Tips_StateTemp) do
		if g_Tips_StateTemp[index] == 1 then
			IsHideMiniMapPoint = 1
			break
		end
	end 
	PushEvent("UI_COMMAND", 2018013002, IsHideMiniMapPoint)
end
--===============================================
-- ˫���ַ��� -begin
--===============================================

--˫���ַ���begin 
function TGM_XinShouNew_DoubleExp_Show( )
	--˫�������ʱ�� 
	--˫������ֵ��ʱ��
	local pEndTime = g_TGM_XinShouNew_EndTime
	local dpEndYear= math.floor(pEndTime/100000000)
	local dpEndMon = math.mod(math.floor(pEndTime/1000000),100)
	local dpEndDay =math.mod(math.floor(pEndTime/10000),100) 
	local dpEndHour = math.mod(math.floor(pEndTime/100),100)  

	local dexpText = string.format("    #G20%s��%s��%s��%sʱǰ#cfff263����������ר��������#G˫������#cfff263Ч���������ﵽ#G70��#cfff263��#Gÿ��#cfff263�������лظ�#G200�㹦��ֵ#cfff263��#r    #Gע�⣺��ר����˫������Ч�����������������1.2����2������Ч�����ӡ�#cfff263", dpEndYear,dpEndMon,dpEndDay,dpEndHour)
		
	TGM_XinShouNew_DoubleExp_T_Text:SetText(dexpText)

end
--˫���ַ���end
--===============================================
-- �׳������-begin
--===============================================
function TGM_XinShouNew_ShouChong_LoadControl()
	g_TGM_XinShouNew_ShouChong_GiftsIcons[1] = TGM_XinShouNew_SaveUp_Right_ShowA;
	g_TGM_XinShouNew_ShouChong_GiftsIcons[2] = TGM_XinShouNew_SaveUp_Right_ShowB;
	g_TGM_XinShouNew_ShouChong_GiftsIcons[3] = TGM_XinShouNew_SaveUp_Right_ShowC;
	g_TGM_XinShouNew_ShouChong_GiftsIcons[4] = TGM_XinShouNew_SaveUp_Right_ShowD;
	
	g_TGM_XinShouNew_ShouChong_GiftsIcons_Num[1] = TGM_XinShouNew_SaveUp_Right_Show_NUM_1;
	g_TGM_XinShouNew_ShouChong_GiftsIcons_Num[2] = TGM_XinShouNew_SaveUp_Right_Show_NUM_2;
	g_TGM_XinShouNew_ShouChong_GiftsIcons_Num[3] = TGM_XinShouNew_SaveUp_Right_Show_NUM_3;
	
end

function TGM_XinShouNew_ShouChong_Show(ShowTime)
	TGM_XinShouNew_ShouChong_UpdateButtonReq();
	TGM_XinShouNew_ShouChong_FlushWindow()		--�ڷ��������ݷ���֮ǰ,�������ݳ�ʼֵ,�ȳ�����������
end
function TGM_XinShouNew_ShouChong_UpdateButtonReq()
	-- ִ�нű�
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "GetSaveUpGiftsButtonState" ); 
		Set_XSCRIPT_ScriptID(990016);		
		Set_XSCRIPT_ParamCount(0);
	Send_XSCRIPT()
end
function TGM_XinShouNew_ShouChong_UpdateButtonState()
	local ButtonState = Get_XParam_INT(0)
	g_TGM_XinShouNew_ShouChong_ButtonState = ButtonState
	TGM_XinShouNew_ShouChong_FlushWindow()
end
function TGM_XinShouNew_ShouChong_FlushWindow()
	--����ǵ�һ�ε��ô˺���,��Ҫ����Ʒ�������ص���ʾ������
	if g_TGM_XinShouNew_ShouChong_LoadFirstTime == 1 then
		for i = 1,  table.getn(g_TGM_XinShouNew_ShouChong_Gifts) do
			g_TGM_XinShouNew_ShouChong_GiftsIcons_Num[i]:SetText("")
			local GiftItemID	=		g_TGM_XinShouNew_ShouChong_Gifts[i].GiftItemID
			local GiftItemNum	= 	g_TGM_XinShouNew_ShouChong_Gifts[i].num
			local theAction = GemMelting:UpdateProductAction(GiftItemID)--DataPool:CreateActionItemForShow(GiftItemID, GiftItemNum)
			if theAction:GetID() ~= 0 then
				g_TGM_XinShouNew_ShouChong_GiftsIcons[i]:SetActionItem(theAction:GetID());
				g_TGM_XinShouNew_ShouChong_GiftsIcons[i]:Show();
				if GiftItemNum > 1 then
					g_TGM_XinShouNew_ShouChong_GiftsIcons_Num[i]:SetText("#e010101"..GiftItemNum)
				end
			end
		end
		g_TGM_XinShouNew_ShouChong_LoadFirstTime = 0
	end
	if g_TGM_XinShouNew_ShouChong_ButtonState == 0 then
		TGM_XinShouNew_SaveUp_Right_Button1 : SetProperty("NormalImage","set:XSYNew01 image:XSYNew_LKCZ_Normal")
		TGM_XinShouNew_SaveUp_Right_Button1 : SetProperty("HoverImage" ,"set:XSYNew01 image:XSYNew_LKCZ_Hover")
		TGM_XinShouNew_SaveUp_Right_Button1 : SetProperty("PushedImage","set:XSYNew01 image:XSYNew_LKCZ_Pushed")
		TGM_XinShouNew_SaveUp_Right_ConditionText:SetText(string.format("#cff0000һ���Զһ���%s/120000Ԫ��", 0))
		TGM_XinShouNew_SaveUp_Right_Button1 : Enable()
	elseif g_TGM_XinShouNew_ShouChong_ButtonState == 1 then
		TGM_XinShouNew_SaveUp_Right_Button1 : SetProperty("NormalImage","set:XSYNew01 image:XSYNew_LQCZJL_Normal")
		TGM_XinShouNew_SaveUp_Right_Button1 : SetProperty("HoverImage" ,"set:XSYNew01 image:XSYNew_LQCZJL_Hover")
		TGM_XinShouNew_SaveUp_Right_Button1 : SetProperty("PushedImage","set:XSYNew01 image:XSYNew_LQCZJL_Pushed")
		TGM_XinShouNew_SaveUp_Right_Button1 : Show()
		TGM_XinShouNew_SaveUp_Right_Button1 : Enable()
		TGM_XinShouNew_SaveUp_Right_ConditionText:SetText("#Gһ���Զһ���120000/120000Ԫ��")
	elseif g_TGM_XinShouNew_ShouChong_ButtonState == 2 then
		TGM_XinShouNew_SaveUp_Right_Button1 : SetProperty("DisabledImage","set:XSYNew01 image:XSYNew_LQCZJL_Disabled")
		TGM_XinShouNew_SaveUp_Right_Button1 : Disable()
		TGM_XinShouNew_SaveUp_Right_ConditionText:SetText("#Gһ���Զһ���120000/120000Ԫ��")
	end
end
function TGM_XinShouNew_ShouChong_GetGiftsForCostYuanBao()
	--ǰ����ֵ
	if g_TGM_XinShouNew_ShouChong_ButtonState == 0 then
	    Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "XYJCall" );
			Set_XSCRIPT_ScriptID( 990000 );
			Set_XSCRIPT_Parameter( 0, 15 );
			Set_XSCRIPT_ParamCount( 1 );
	    Send_XSCRIPT()
		return
	end
	-- ִ�нű�
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "GetGiftsForSaveUp" ); 
		Set_XSCRIPT_ScriptID(990016);		
		Set_XSCRIPT_Parameter(0,1);
		Set_XSCRIPT_ParamCount(1);
	Send_XSCRIPT()
end

--===============================================
-- �׳������ -end
--===============================================

--===============================================
-- ��ʱ��ֵ����-begin
--===============================================
function TGM_XinShouNew_LimitedSaveUp_LoadControl()
	g_TGM_XinShouNew_LimitedSaveUp_GiftsIcons[1] = TGM_XinShouNew_Time_Mian_ShowA;
	g_TGM_XinShouNew_LimitedSaveUp_GiftsIcons[2] = TGM_XinShouNew_Time_Mian_ShowB;
	g_TGM_XinShouNew_LimitedSaveUp_GiftsIcons[3] = TGM_XinShouNew_Time_Mian_ShowC;
	for i = 1,3 do
		g_TGM_XinShouNew_LimitedSaveUp_GiftsIcons_Num[i] = _G[string.format("TGM_XinShouNew_Time_Mian_Show_NUM_%d",i)]
	end
	g_TGM_XinShouNew_LimitedSaveUp_ButtonDone[1] = TGM_XinShouNew_Time_Bottom_day1_done
	g_TGM_XinShouNew_LimitedSaveUp_ButtonDone[2] = TGM_XinShouNew_Time_Bottom_day3_done
	g_TGM_XinShouNew_LimitedSaveUp_ButtonDone[3] = TGM_XinShouNew_Time_Bottom_day7_done 
	g_TGM_XinShouNew_LimitedSaveUp_Button[1] = TGM_XinShouNew_Time_Bottom_day1_Button1
	g_TGM_XinShouNew_LimitedSaveUp_Button[2] = TGM_XinShouNew_Time_Bottom_day3_Button1
	g_TGM_XinShouNew_LimitedSaveUp_Button[3] = TGM_XinShouNew_Time_Bottom_day7_Button1
	
end

function TGM_XinShouNew_LimitedSaveUp_Show()
	-- TGM_XinShouNew_LimitedSaveUp_UpdateButtonReq();
	TGM_XinShouNew_LimitedSaveUp_FlushWindow(1)		--�ڷ��������ݷ���֮ǰ,�������ݳ�ʼֵ,�ȳ�����������
end
function TGM_XinShouNew_LimitedSaveUp_UpdateButtonReq()
	-- ִ�нű�
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "GetLimitedSaveGiftsInfo" );
		Set_XSCRIPT_ScriptID( 990016 );
		Set_XSCRIPT_ParamCount( 0 );
	Send_XSCRIPT()
end
function TGM_XinShouNew_LimitedSaveUp_UpdateInfo()
	g_TGM_XinShouNew_LimitedSaveUp_RemainDay  = Get_XParam_INT(0)
	g_TGM_XinShouNew_LimitedSaveUp_RemainTime = Get_XParam_INT(1)
	g_TGM_XinShouNew_LimitedSaveUp_Exch 			= Get_XParam_INT(2)
	g_TGM_XinShouNew_LimitedSaveUp_Cost 			= Get_XParam_INT(3)

	for i=1,table.getn(g_TGM_XinShouNew_LimitedSaveUp_ButtonState) do
		g_TGM_XinShouNew_LimitedSaveUp_ButtonState[i] = Get_XParam_INT(3+i)
	end

	local nFlushIndex = 1;
	for i=1,table.getn(g_TGM_XinShouNew_LimitedSaveUp_ButtonState) do
		if g_TGM_XinShouNew_LimitedSaveUp_ButtonState[i] ~= 2 then
			nFlushIndex = i;
			break;
		end
	end
	TGM_XinShouNew_LimitedSaveUp_FlushWindow(nFlushIndex)
	
end
function TGM_XinShouNew_LimitedSaveUp_FlushWindow( Index )
	g_TGM_XinShouNew_LimitedSaveUp_CurSelect = 	Index
	for i = 1,  table.getn(g_TGM_XinShouNew_LimitedSaveUp_Gifts[Index]) do
		if g_TGM_XinShouNew_LimitedSaveUp_GiftsIcons[i] == nil then
			return
		end
		g_TGM_XinShouNew_LimitedSaveUp_GiftsIcons_Num[i]:SetText("#e010101")
		g_TGM_XinShouNew_LimitedSaveUp_GiftsIcons[i]:SetActionItem(-1);
		local GiftItemID	=	g_TGM_XinShouNew_LimitedSaveUp_Gifts[Index][i].GiftItemID
		local GiftItemNum	= 	g_TGM_XinShouNew_LimitedSaveUp_Gifts[Index][i].num
		local theAction 	= 	GemMelting:UpdateProductAction(GiftItemID)
		if theAction:GetID() ~= 0 then
			if GiftItemNum > 1 then
				g_TGM_XinShouNew_LimitedSaveUp_GiftsIcons_Num[i]:SetText("#e010101"..GiftItemNum)
			end
			g_TGM_XinShouNew_LimitedSaveUp_GiftsIcons[i]:SetActionItem(theAction:GetID());
			g_TGM_XinShouNew_LimitedSaveUp_GiftsIcons[i]:Show();
		end
	end
	if g_TGM_XinShouNew_LimitedSaveUp_ButtonState[Index] == 0 then --δ���
		TGM_XinShouNew_Time_Mian_Button1:Disable()
		TGM_XinShouNew_Time_Mian_Info1:SetText(g_TGM_XinShouNew_LimitedSaveUp_Content[Index].Content)
		if g_TGM_XinShouNew_LimitedSaveUp_RemainTime <= 0 then
			TGM_XinShouNew_Time_Mian_Info2:SetText("#{XSJNH_180111_70}")
		else
			if g_TGM_XinShouNew_LimitedSaveUp_RemainDay > 0 then
				TGM_XinShouNew_Time_Mian_Info2:SetText(string.format("#Gʣ��ʱ�䣺#cfff263%s��",g_TGM_XinShouNew_LimitedSaveUp_RemainDay))
			elseif g_TGM_XinShouNew_LimitedSaveUp_RemainDay == 0 and g_TGM_XinShouNew_LimitedSaveUp_RemainTime >= 3600 then 
				TGM_XinShouNew_Time_Mian_Info2:SetText(string.format("#Gʣ��ʱ�䣺#cfff263%sСʱ",math.floor(g_TGM_XinShouNew_LimitedSaveUp_RemainTime/3600)))
			elseif g_TGM_XinShouNew_LimitedSaveUp_RemainTime >= 60 then
				TGM_XinShouNew_Time_Mian_Info2:SetText(string.format("#Gʣ��ʱ�䣺#cfff263%s��",math.floor(g_TGM_XinShouNew_LimitedSaveUp_RemainTime/60)))
			elseif g_TGM_XinShouNew_LimitedSaveUp_RemainTime < 60 then
				TGM_XinShouNew_Time_Mian_Info2:SetText(string.format("#Gʣ��ʱ�䣺#cfff263����1����",g_TGM_XinShouNew_LimitedSaveUp_RemainTime))
			end
		end
			--Exch = 4000, Cost
		if g_TGM_XinShouNew_LimitedSaveUp_Exch < g_TGM_XinShouNew_LimitedSaveUp_GetGiftsCondition[Index].Exch then
			TGM_XinShouNew_Time_Mian_ConditionText1:SetText(string.format("#cff0000�ۼƶһ���%s/%sԪ��", g_TGM_XinShouNew_LimitedSaveUp_Exch,g_TGM_XinShouNew_LimitedSaveUp_GetGiftsCondition[Index].Exch))
		else
			TGM_XinShouNew_Time_Mian_ConditionText1:SetText(string.format("#G�ۼƶһ���%s/%sԪ��", g_TGM_XinShouNew_LimitedSaveUp_GetGiftsCondition[Index].Exch,g_TGM_XinShouNew_LimitedSaveUp_GetGiftsCondition[Index].Exch))
		end
		if g_TGM_XinShouNew_LimitedSaveUp_Cost < g_TGM_XinShouNew_LimitedSaveUp_GetGiftsCondition[Index].Cost then
			TGM_XinShouNew_Time_Mian_ConditionText2:SetText(string.format("#cff0000�ۼ����ѣ�%s/%sԪ��", g_TGM_XinShouNew_LimitedSaveUp_Cost,g_TGM_XinShouNew_LimitedSaveUp_GetGiftsCondition[Index].Cost))
		else
			TGM_XinShouNew_Time_Mian_ConditionText2:SetText(string.format("#G�ۼ����ѣ�%s/%sԪ��", g_TGM_XinShouNew_LimitedSaveUp_GetGiftsCondition[Index].Cost,g_TGM_XinShouNew_LimitedSaveUp_GetGiftsCondition[Index].Cost))
		end
		--TGM_XinShouNew_Time_Mian_Button1_tips:SetProperty("Tooltip",g_TGM_XinShouNew_LimitedSaveUp_Content[Index].Tips)
		TGM_XinShouNew_Time_Mian_Button1_tips:SetToolTip(g_TGM_XinShouNew_LimitedSaveUp_Content[Index].Tips)
		TGM_XinShouNew_Time_Mian_Button1_tips:Show()
		--��Ǯ������  ����ͼƬ
		if g_TGM_XinShouNew_LimitedSaveUp_Exch < g_TGM_XinShouNew_LimitedSaveUp_GetGiftsCondition[Index].Exch or g_TGM_XinShouNew_LimitedSaveUp_Cost < g_TGM_XinShouNew_LimitedSaveUp_GetGiftsCondition[Index].Cost then
			TGM_XinShouNew_Time_Mian_Button1:SetProperty("DisabledImage","set:XSYNew02 image:TGM_XinShouNew_Time_DisabledWDC")
		else --ʱ��δ��
			TGM_XinShouNew_Time_Mian_Button1:SetProperty("DisabledImage",g_TGM_XinShouNew_LimitedSaveUp_WDCImage[Index].Set.." "..g_TGM_XinShouNew_LimitedSaveUp_WDCImage[Index].Image)
		end
	elseif g_TGM_XinShouNew_LimitedSaveUp_ButtonState[Index] == 1 then -- ������ȡ
		TGM_XinShouNew_Time_Mian_Button1:Enable()
		--TGM_XinShouNew_Time_Mian_Button1:SetText("#{XSJNH_180111_79}")
		TGM_XinShouNew_Time_Mian_Info1:SetText(g_TGM_XinShouNew_LimitedSaveUp_Content[Index].Content)
		TGM_XinShouNew_Time_Mian_Info2:SetText("#{XSJNH_180111_69}")
		TGM_XinShouNew_Time_Mian_ConditionText1:SetText(string.format("#G�ۼƶһ���%s/%sԪ��", g_TGM_XinShouNew_LimitedSaveUp_GetGiftsCondition[Index].Exch,g_TGM_XinShouNew_LimitedSaveUp_GetGiftsCondition[Index].Exch))
		TGM_XinShouNew_Time_Mian_ConditionText2:SetText(string.format("#G�ۼ����ѣ�%s/%sԪ��", g_TGM_XinShouNew_LimitedSaveUp_GetGiftsCondition[Index].Cost,g_TGM_XinShouNew_LimitedSaveUp_GetGiftsCondition[Index].Cost))
		TGM_XinShouNew_Time_Mian_Button1:SetToolTip(g_TGM_XinShouNew_LimitedSaveUp_Content[Index].Tips) 
		TGM_XinShouNew_Time_Mian_Button1_tips:Hide()
	elseif g_TGM_XinShouNew_LimitedSaveUp_ButtonState[Index] == 2 then -- �Ѿ���ȡ
		TGM_XinShouNew_Time_Mian_Button1:SetProperty("DisabledImage","set:XSYNew02 image:TGM_XinShouNew_Time_DisabledYLQ")
		TGM_XinShouNew_Time_Mian_Button1:Disable() 
		TGM_XinShouNew_Time_Mian_Info1:SetText(g_TGM_XinShouNew_LimitedSaveUp_Content[Index].Content)
		TGM_XinShouNew_Time_Mian_Info2:SetText("#{XSJNH_180111_69}")
		TGM_XinShouNew_Time_Mian_ConditionText1:SetText(string.format("#G�ۼƶһ���%s/%sԪ��", g_TGM_XinShouNew_LimitedSaveUp_GetGiftsCondition[Index].Exch,g_TGM_XinShouNew_LimitedSaveUp_GetGiftsCondition[Index].Exch))
		TGM_XinShouNew_Time_Mian_ConditionText2:SetText(string.format("#G�ۼ����ѣ�%s/%sԪ��", g_TGM_XinShouNew_LimitedSaveUp_GetGiftsCondition[Index].Cost,g_TGM_XinShouNew_LimitedSaveUp_GetGiftsCondition[Index].Cost))
		TGM_XinShouNew_Time_Mian_Button1_tips:Show()
		TGM_XinShouNew_Time_Mian_Button1_tips:SetToolTip(g_TGM_XinShouNew_LimitedSaveUp_Content[Index].Tips)
	end
	 
	for i =1 , table.getn(g_TGM_XinShouNew_LimitedSaveUp_ButtonDone) do
		if g_TGM_XinShouNew_LimitedSaveUp_ButtonState[i] == 2 then
			g_TGM_XinShouNew_LimitedSaveUp_ButtonDone[i]:Show()
		else 
			g_TGM_XinShouNew_LimitedSaveUp_ButtonDone[i]:Hide()
		end
		if i ~= Index then
			g_TGM_XinShouNew_LimitedSaveUp_Button[i]:SetCheck(0)
		else
			g_TGM_XinShouNew_LimitedSaveUp_Button[i]:SetCheck(1)
		end
	end 
	
end
function TGM_XinShouNew_LimitedSaveUp_GetGiftsForCostYuanBao()
	-- ִ�нű�
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("GetGiftsForLimitedSaveUp"); 
		Set_XSCRIPT_ScriptID( 990016 );		
		Set_XSCRIPT_Parameter(0,g_TGM_XinShouNew_LimitedSaveUp_CurSelect);
		Set_XSCRIPT_ParamCount(1);
	Send_XSCRIPT()
end

--===============================================
-- ��ʱ��ֵ���� -end
--===============================================
--===============================================
-- ��ֵ��ֵ��-begin
--===============================================
function TGM_XinShouNew_SuperSaveUp_LoadControl()
end

function TGM_XinShouNew_SuperSaveUp_Show()
	TGM_XinShouNew_SuperSaveUp_UpdateButtonReq();
	TGM_XinShouNew_SuperSaveUp_FlushWindow()
end
function TGM_XinShouNew_SuperSaveUp_UpdateButtonReq()
	-- ִ�нű�
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "GetSuperSaveUpGiftsInfo" ); 
		Set_XSCRIPT_ScriptID( 990016 );		
		Set_XSCRIPT_ParamCount(0);
	Send_XSCRIPT()
end
function TGM_XinShouNew_SuperSaveUp_FlushWindow()
	for index=1,table.getn(g_TGM_XinShouNew_Frames) do
		if index~=6 then
			g_TGM_XinShouNew_Frames[index]:Hide()
		else
			g_TGM_XinShouNew_Frames[index]:Show()
		end
	end
	--���ù���
    local InfoText = "#cfff263��ֵ�һ��ﵽָ�������󣬼�����ȡ#G�������#cfff263��ÿ�غ��������ȡ#G1��#cfff263��"
	TGM_XinShouNew_BaiBao_Info:SetText( InfoText )
	this:Show()
	if g_TGM_XinShouNew_SuperSaveUp_Page == 0 then
		TGM_XinShouNew_turn_MoveUp:Disable();
		TGM_XinShouNew_turn_MoveDown:Enable();
	else
		TGM_XinShouNew_turn_MoveUp:Enable();
		TGM_XinShouNew_turn_MoveDown:Disable();
	end
	
	--��ʾ���
	for i = 1,10 do
		for j = 1, table.getn(g_TGM_XinShouNew_BaiBao2_GiftsIcons[i]) do
  			g_TGM_XinShouNew_BaiBao2_GiftsIcons[i][j]:Hide(); 
			g_TGM_XinShouNew_BaiBao2_GiftsIcons_NUM[i][j]:SetText(""); 
  		end
		for j = 1, table.getn(g_TGM_XinShouNew_BaiBao2_GiftsIconImages[i]) do
  			g_TGM_XinShouNew_BaiBao2_GiftsIconImages[i][j]:Hide(); 
  		end
		g_TGM_XinShouNew_BaiBao2_NotifyTipsControlList[i].LevelText:SetText("")
		g_TGM_XinShouNew_BaiBao2_NotifyTipsControlList[i].YBText:SetText("")
		g_TGM_XinShouNew_BaiBao2_LeftImage[i]:Hide()
		g_TGM_XinShouNew_BaiBao2_GetGiftsButtonList[i]:Hide()
	end
	--�������ʾ
	--g_TGM_XinShouNew_SuperSaveUp_Page
	local nEndIndex = 6
	if g_TGM_XinShouNew_SuperSaveUp_Page  == 1 then
		nEndIndex = table.getn(g_TGM_XinShouNew_SuperSaveUp_GetGiftsCondition)
	end
		
	for i = (g_TGM_XinShouNew_SuperSaveUp_Page * 6) + 1,nEndIndex do
		--��Ʒ��ʾ
		for j = 1, table.getn(g_TGM_XinShouNew_BaiBao2_GiftsIcons[i]) do
  			-- local	GiftItemID	=	-1
  			-- local	GiftItemNum	=	0
  			if j > table.getn( g_TGM_XinShouNew_BaiBao2_Gifts2[i] ) then
  				g_TGM_XinShouNew_BaiBao2_GiftsIcons[i][j]:Hide(); 
				g_TGM_XinShouNew_BaiBao2_GiftsIcons_NUM[i][j]:Hide()
  			else
  				local GiftItemID	=	g_TGM_XinShouNew_BaiBao2_Gifts2[i][j].GiftItemID
  				local GiftItemNum	= 	g_TGM_XinShouNew_BaiBao2_Gifts2[i][j].num
				local theAction = GemMelting:UpdateProductAction(GiftItemID)
  				if theAction:GetID() ~= 0 then
  					g_TGM_XinShouNew_BaiBao2_GiftsIcons[i][j]:SetActionItem(theAction:GetID());
  					g_TGM_XinShouNew_BaiBao2_GiftsIcons[i][j]:Show(); 
					if GiftItemNum > 1 then
						g_TGM_XinShouNew_BaiBao2_GiftsIcons[i][j]:SetProperty("CornerChar", string.format( "BotRight %s", GiftItemNum ))
					else
						g_TGM_XinShouNew_BaiBao2_GiftsIcons[i][j]:SetProperty("CornerChar", "BotRight ")
					end
  				end
  			end
  		end
		for j = 1, table.getn(g_TGM_XinShouNew_BaiBao2_GiftsIconImages[i]) do
  			g_TGM_XinShouNew_BaiBao2_GiftsIconImages[i][j]:Show(); 
  		end
		g_TGM_XinShouNew_BaiBao2_LeftImage[i]:Show()
		g_TGM_XinShouNew_BaiBao2_LeftImage[i]:SetProperty("Image","set:"..g_TGM_XinShouNew_LimitedSaveUp_GiftsImage[i].Set.." image:"..g_TGM_XinShouNew_LimitedSaveUp_GiftsImage[i].Image) 
		--δ���
		local Text1,Text2,Text3 = "","",""
		local nIsNotGetGifts = 0
		if g_TGM_XinShouNew_SuperSaveUp_Exch < g_TGM_XinShouNew_SuperSaveUp_GetGiftsCondition[i].Exch then
			Text1 = string.format("#cff0000����������ۻ����Ѵﵽ#G��%s/%s��", g_TGM_XinShouNew_SuperSaveUp_Exch,g_TGM_XinShouNew_SuperSaveUp_GetGiftsCondition[i].Exch)
			nIsNotGetGifts = 1
		else
			Text1 = string.format("#G����������ۻ����Ѵﵽ#G��%s/%s��", g_TGM_XinShouNew_SuperSaveUp_GetGiftsCondition[i].Exch,g_TGM_XinShouNew_SuperSaveUp_GetGiftsCondition[i].Exch)
		end
		if g_TGM_XinShouNew_SuperSaveUp_Cost < g_TGM_XinShouNew_SuperSaveUp_GetGiftsCondition[i].Exch then
			Text2 = string.format("#cff0000����������ۻ����Ѵﵽ#G��%s/%s��", g_TGM_XinShouNew_SuperSaveUp_Cost,g_TGM_XinShouNew_SuperSaveUp_GetGiftsCondition[i].Exch)
			nIsNotGetGifts = 1
		else
			Text2 = string.format("#G����������ۻ����Ѵﵽ#G��%s/%s��", g_TGM_XinShouNew_SuperSaveUp_GetGiftsCondition[i].Exch,g_TGM_XinShouNew_SuperSaveUp_GetGiftsCondition[i].Exch)
		end
		
		Text3 = string.format("#cFF0000�ۻ��������:#G#r%sλ", g_TGM_XinShouNew_SuperSaveUp_num)
		TGM_XinShouNew_Supe_TopImage04:SetText(Text3)
		
		local JIHUOMA = Get_XParam_INT(0)
		if JIHUOMA ~= 0 or JIHUOMA ~=nil then
			TGM_XinShouNew_Supe_TopImage05:SetText("#cFF0000�����ƹ���Ϊ:#G#r"..JIHUOMA)
		end

		Text2 = ""
		g_TGM_XinShouNew_BaiBao2_NotifyTipsControlList[i].LevelText:SetText(Text1)
		g_TGM_XinShouNew_BaiBao2_NotifyTipsControlList[i].YBText:SetText(Text2)
		g_TGM_XinShouNew_BaiBao2_GetGiftsButtonList[i] : Show()
		
	---����ȡ���
  if g_TGM_XinShouNew_SuperSaveUp_ButtonState>=1 then
	TGM_XinShouNew_BaiBao2_Frame3_Bk1_Button1 : SetProperty("DisabledImage","set:CommonFrame34 image:SignSummerButton_Yilingqu")
	TGM_XinShouNew_BaiBao2_Frame3_Bk1_Button1 : Disable()
  end	
  if g_TGM_XinShouNew_SuperSaveUp_ButtonState>=2 then
	TGM_XinShouNew_BaiBao2_Frame3_Bk2_Button1 : SetProperty("DisabledImage","set:CommonFrame34 image:SignSummerButton_Yilingqu")
	TGM_XinShouNew_BaiBao2_Frame3_Bk2_Button1 : Disable()	
  end
  if g_TGM_XinShouNew_SuperSaveUp_ButtonState>=3 then
	TGM_XinShouNew_BaiBao2_Frame3_Bk3_Button1 : SetProperty("DisabledImage","set:CommonFrame34 image:SignSummerButton_Yilingqu")
	TGM_XinShouNew_BaiBao2_Frame3_Bk3_Button1 : Disable()	
  end
  if g_TGM_XinShouNew_SuperSaveUp_ButtonState>=4 then
	TGM_XinShouNew_BaiBao2_Frame3_Bk4_Button1 : SetProperty("DisabledImage","set:CommonFrame34 image:SignSummerButton_Yilingqu")
	TGM_XinShouNew_BaiBao2_Frame3_Bk4_Button1 : Disable()	
  end
  if g_TGM_XinShouNew_SuperSaveUp_ButtonState>=5 then
	TGM_XinShouNew_BaiBao2_Frame3_Bk5_Button1 : SetProperty("DisabledImage","set:CommonFrame34 image:SignSummerButton_Yilingqu")
	TGM_XinShouNew_BaiBao2_Frame3_Bk5_Button1 : Disable()	
  end
  if g_TGM_XinShouNew_SuperSaveUp_ButtonState>=6 then
	TGM_XinShouNew_BaiBao2_Frame3_Bk6_Button1 : SetProperty("DisabledImage","set:CommonFrame34 image:SignSummerButton_Yilingqu")
	TGM_XinShouNew_BaiBao2_Frame3_Bk6_Button1 : Disable()	
  end
		
		

	end
end

function TGM_XinShouNew_SuperSaveUp_PageDown()
	-- if g_TGM_XinShouNew_SuperSaveUp_Page == 0 then
		-- g_TGM_XinShouNew_SuperSaveUp_Page = 1
	-- end
	-- TGM_XinShouNew_SuperSaveUp_FlushWindow()
end
function TGM_XinShouNew_SuperSaveUp_PageUp()
	-- if g_TGM_XinShouNew_SuperSaveUp_Page == 1 then
		-- g_TGM_XinShouNew_SuperSaveUp_Page = 0
	-- end
	-- TGM_XinShouNew_SuperSaveUp_FlushWindow()
end

function TGM_XinShouNew_SuperSaveUp_GetGiftsForCostYuanBao( Index )
	if Index < 1 or Index > 6 then
		return
	end
	
	if g_TGM_XinShouNew_SuperSaveUp_Exch < g_TGM_XinShouNew_SuperSaveUp_GetGiftsCondition[Index].Exch then
	PushDebugMessage("δ�ﵽ��ȡ��׼������������ߵ����ѣ����������ý���������Ҳ���������α����������")
	PushDebugMessage("���������������С��޴���ģʽ����ŵGM����������Ϸ���������У�Υ����ȫ�ң�")
	return
	end
	--��Ŵ��� 2019-10-29 08:35:49 ��ң��
	--Index = (g_TGM_XinShouNew_SuperSaveUp_Page * 6) + Index
	-- ִ�нű�
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "XiaoXiang_yaoqingma" );
		Set_XSCRIPT_ScriptID( 928775 );		
		Set_XSCRIPT_Parameter( 0, Index );
		Set_XSCRIPT_ParamCount( 1 );
	Send_XSCRIPT()
end

function TGM_XinShouNew_SuperSaveUp_CalcListScrollPos(SelectIdx)
	if	SelectIdx <= 2 then
		return 0
	elseif SelectIdx == 3 then
		return 64
	elseif SelectIdx == 4 then
		return 128
	elseif SelectIdx == 5 then
		return 192
	elseif SelectIdx >= 6 then
		return 270
	end
end
--===============================================
-- ��ֵ��ֵ�� -end
--===============================================

--===============================================
-- �����к���-begin
--===============================================

--**********************************
-- ����Data
--**********************************
function TGM_XinShouNew_LevelUp_OnShow(ShowTime)
	TGM_XinShouNew_LevelUp_UpdateButtonReq();
	TGM_XinShouNew_LevelUp_FlushWindow(ShowTime)		--�ڷ��������ݷ���֮ǰ,�������ݳ�ʼֵ,�ȳ�����������
end

--**********************************
-- �������Btn״̬
--**********************************
function TGM_XinShouNew_LevelUp_UpdateButtonReq()
	-- ִ�нű�
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "UpdateLevelUpBtnState" ); 
		Set_XSCRIPT_ScriptID(990016);		
		Set_XSCRIPT_ParamCount(0);
	Send_XSCRIPT()
end

function TGM_XinShouNew_LevelUp_UpdateRedPoint(ShowTime)
	local nLevel = Player : GetData("LEVEL");
	local LevelNeed = 0;

	for i = 1,table.getn(g_TGM_XinShouNew_LevelUp_GetGiftLevel)  do
		if nLevel >= g_TGM_XinShouNew_LevelUp_GetGiftLevel[i] then
			LevelNeed = i
		end
	end

	local flagpage = {[1]=0,[2]=0}

	for i = 1, table.getn(g_TGM_XinShouNew_LevelUpBtnState) do
			if LevelNeed < i then
				break
			end
			if g_TGM_XinShouNew_LevelUpBtnState[i] ~= 1 then
				if g_TGM_XinShouNew_LevelUpPageState[i] == 1 then
					flagpage[1] = 1
				elseif g_TGM_XinShouNew_LevelUpPageState[i] == 2 then
					flagpage[2] = 1
				end
			end
	end

	if flagpage[1] == 1 then
		TGM_XinShouNew_LevelUp_Client_Button01tips:Show()
	else
		TGM_XinShouNew_LevelUp_Client_Button01tips:Hide()
	end
	if flagpage[2] == 1 then
		TGM_XinShouNew_LevelUp_Client_Button02tips:Show()
	else
		TGM_XinShouNew_LevelUp_Client_Button02tips:Hide()
	end
end
--**********************************
-- ���·������¡������ͺ���ˢ�½���
--**********************************
function TGM_XinShouNew_LevelUp_FlushWindow(ShowTime)

	--����ǵ�һ�ε��ô˺���,��Ҫ����Ʒ�������ص���ʾ������
	if g_TGM_XinShouNew_LevelUp_LoadFirstTime == 1 then
		for i = 1,  table.getn(g_TGM_XinShouNew_LevelUp_GiftsIcons) do
			for j = 1, table.getn(g_TGM_XinShouNew_LevelUp_GiftsIcons[i]) do
				local	GiftItemID	=	-1
				local	GiftItemNum	=	0
				if j > table.getn( g_TGM_XinShouNew_LevelUp_Gifts[i] ) then
					g_TGM_XinShouNew_LevelUp_GiftsIcons[i][j]:Hide();
					g_TGM_XinShouNew_LevelUp_GiftsIcons_Num[i][j]:SetText("");
				else
					GiftItemID	=	g_TGM_XinShouNew_LevelUp_Gifts[i][j].GiftItemID
					GiftItemNum	= 	g_TGM_XinShouNew_LevelUp_Gifts[i][j].num
					local theAction = GemMelting:UpdateProductAction(GiftItemID)
					if theAction:GetID() ~= 0 then
						if g_TGM_XinShouNew_LevelUp_Gifts[i][j].new ~= nil and g_TGM_XinShouNew_LevelUp_Gifts[i][j].new == 1 then
							g_TGM_XinShouNew_LevelUp_GiftsIconsImages[i][j] : SetProperty("Image",g_TGM_XinShouNew_PrizeItemButtonIcon);
						end
						g_TGM_XinShouNew_LevelUp_GiftsIcons[i][j]:SetActionItem(theAction:GetID());
						g_TGM_XinShouNew_LevelUp_GiftsIcons[i][j]:Show();
						if GiftItemNum > 1 then
							g_TGM_XinShouNew_LevelUp_GiftsIcons_Num[i][j]:SetText("#e010101"..GiftItemNum)
						end
					end
				end
			end
		end
		g_TGM_XinShouNew_LevelUp_LoadFirstTime = 0
	end
	local nLevel = Player : GetData("LEVEL");
	local LevelGrade = 1;
	for i = 1,table.getn(g_TGM_XinShouNew_LevelUp_GetGiftLevel)  do
		if nLevel < g_TGM_XinShouNew_LevelUp_GetGiftLevel[i] then
			LevelGrade = i
			break
		end
	end
	--��ȡ���ֹʱ��
	local EndDate = g_TGM_XinShouNew_EndTime

	local deEndYear = math.floor(EndDate/100000000)
	local deEndMon = math.mod(math.floor(EndDate/1000000),100)
	local deEndDay = math.mod(math.floor(EndDate/10000),100)
	local deEndHour = math.mod(math.floor(EndDate/100),100)

	--���á��·������¡������ͺ��񡿽�����ʾ��
	if g_TGM_XinShouNew_LevelUp_PageIndex == 1 then
		TGM_XinShouNew_LevelUp_Info : SetText(string.format("#cfff263���ﵽָ���ȼ���������ȡ����#G����#cfff263�����б��С�#G��#cfff263���ֵĽ�����ֻ����#G��ڼ�#cfff263����ȡ��á�", deEndYear,deEndMon , deEndDay , deEndHour) );
	else
		TGM_XinShouNew_LevelUp_Info : SetText(string.format("#cfff263���ﵽָ���ȼ���������ȡ����#G����#cfff263�����б��С�#G��#cfff263���ֵĽ�����ֻ����#G��ڼ�#cfff263����ȡ��á�",deEndYear,deEndMon , deEndDay , deEndHour) );
	end
	--���������п�����ȡ��Button��״̬Ϊ:"����ȡ"����"δ��ȡ"
	for i = 1, LevelGrade - 1 do
		if g_TGM_XinShouNew_LevelUpBtnState[i] == 1 then
			--���ð�ťͼƬΪ����ȡ
			g_TGM_XinShouNew_LevelUp_GetGiftsButtonList[i] : SetProperty("DisabledImage","set:ServerNewUI2 image:ServerNewUI_LQ_Disable")
			g_TGM_XinShouNew_LevelUp_GetGiftsButtonList[i] : Disable()
		else
			g_TGM_XinShouNew_LevelUp_GetGiftsButtonList[i] : Enable()
		end
	end

	for i = LevelGrade, table.getn(g_TGM_XinShouNew_LevelUp_GetGiftsButtonList) do
		--����δ��ɵ�Button
		g_TGM_XinShouNew_LevelUp_GetGiftsButtonList[i] : SetProperty("DisabledImage","set:ServerNewUI2 image:ServerNewUI_LQ_WDC")
		g_TGM_XinShouNew_LevelUp_GetGiftsButtonList[i] : Disable()
	end

	local	ShowIndexBegin = 0
	local 	ShowIndexEnd   = 0
	local   HideIndexBegin = 0
	local   HideIndexEnd   = 0
	if g_TGM_XinShouNew_LevelUp_PageIndex == 1 then
		ShowIndexBegin = 1
		ShowIndexEnd   = 8
		HideIndexBegin = 9
		HideIndexEnd   = 13
	else
		ShowIndexBegin = 9
		ShowIndexEnd   = 13
		HideIndexBegin = 1
		HideIndexEnd   = 8
	end

	--���õ�ǰҳ���[��ť]��ͼ��Ϊ�ɼ�
	for i = ShowIndexBegin, ShowIndexEnd do
		for j = 1, table.getn(g_TGM_XinShouNew_LevelUp_Gifts[i]) do
			if g_TGM_XinShouNew_LevelUp_GiftsIcons[i][j] ~= nil then
				g_TGM_XinShouNew_LevelUp_GiftsIcons[i][j] : Show();
			end
		end
	end
	for i = ShowIndexBegin, ShowIndexEnd do
		g_TGM_XinShouNew_LevelUp_GetGiftsButtonList[i] : Show();
		--g_TGM_XinShouNew_LevelUp_Frames[i] : SetProperty("AlwaysOnTop","True")
		g_TGM_XinShouNew_LevelUp_Frames[i] : Show()
	end

	--������һҳ���[��ť]��ͼ��Ϊ���ɼ�
	for i = HideIndexBegin, HideIndexEnd do
		for j = 1, table.getn(g_TGM_XinShouNew_LevelUp_GiftsIcons[i]) do
			if g_TGM_XinShouNew_LevelUp_GiftsIcons[i][j] ~= nil then
				g_TGM_XinShouNew_LevelUp_GiftsIcons[i][j] : Hide();
			end
		end
	end
	for i = HideIndexBegin, HideIndexEnd do
		g_TGM_XinShouNew_LevelUp_GetGiftsButtonList[i] : Hide();
		--g_TGM_XinShouNew_LevelUp_Frames[i] : SetProperty("AlwaysOnTop","False")
		g_TGM_XinShouNew_LevelUp_Frames[i] : Hide()
	end

	-- ����С���
	TGM_XinShouNew_LevelUp_UpdateRedPoint(ShowTime)

end
--********************************************************************
-- ��ť,�ͻ��˽���"��ȡ����"��ť�����Ӧ�¼�����
--********************************************************************
function TGM_XinShouNew_LevelUp_Frame3_GetGift( nIndex )
	--�ͻ��˽��г����ļ��,���ͨ���ɷ������ű�ִ�з����߼�
	--1.�����ҵĵȼ��Ƿ񵽴���콱�ĵȼ�
	local nLevel = Player : GetData("LEVEL")
	if nLevel < g_TGM_XinShouNew_LevelUp_GetGiftLevel[nIndex] then
		PushDebugMessage("#{SJSHL_140919_24}")					--�Բ�������δ�ﵽ����ȡ�����ĵȼ����޷���ȡ����
		return
	end
	--2.����Ƿ�δ��ȡ�ý���
	if nIndex < 1 or nIndex > 13 then
		return
	elseif g_TGM_XinShouNew_LevelUpBtnState[nIndex] == 1 then					--��ťΪ"δ����"״̬,˵������MF�ж�����Ѿ���ȡ��������
		PushDebugMessage("#{SJSHL_140919_25}")					--�Բ���,���Ѿ���ȡ���˽���,�޷��ٴ���ȡ
		return
	end
	--3.�ж���ұ���λ�����Ƿ��㹻
	
	--4.ȫ�����ͨ��,���÷������ű����콱�߼�
	-- ִ�нű�
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("GetGiftsForLevelUp"); 
		Set_XSCRIPT_ScriptID(990016);		
		Set_XSCRIPT_Parameter(0,nIndex);
		Set_XSCRIPT_ParamCount(1);
	Send_XSCRIPT()
end
--**********************************
-- ��ť������é®������¼�
--**********************************
function TGM_XinShouNew_LevelUp_Click_Button1()
	g_TGM_XinShouNew_LevelUp_PageIndex  = 1
	TGM_XinShouNew_LevelUp_Client_Button01:Disable();
	TGM_XinShouNew_LevelUp_Client_Button02:Enable();
	TGM_XinShouNew_LevelUp_FlushWindow(1);
end

--**********************************
-- ��ť���̽�����������¼�
--**********************************
function TGM_XinShouNew_LevelUp_Click_Button2()
	g_TGM_XinShouNew_LevelUp_PageIndex  = 2
	TGM_XinShouNew_LevelUp_Client_Button02:Disable();
	TGM_XinShouNew_LevelUp_Client_Button01:Enable();
	TGM_XinShouNew_LevelUp_FlushWindow(1);
end

--===============================================
-- �����к��� -end
--===============================================

--===============================================
-- Ӣ�۰ٱ���-begin
--===============================================

function TGM_XinShouNew_BaiBao_OnShow( ShowTime )
	TGM_XinShouNew_BaiBao_UpdateButtonReq();						-- �ڷ��������ݷ���֮ǰ,�ȸ���Ĭ�ϳ�ʼֵˢ��һ�ν���
	TGM_XinShouNew_BaiBao_FlushWindow(ShowTime)						
end
--**********************************
-- �������Btn״̬
--**********************************
function TGM_XinShouNew_BaiBao_UpdateButtonReq() 
	-- ִ�нű�
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "UpdateInfo")
		Set_XSCRIPT_ScriptID(990016)
		Set_XSCRIPT_ParamCount(0)
	Send_XSCRIPT()
end
--**********************************
-- ����Btn״̬
--**********************************
function TGM_XinShouNew_BaiBao_FlushWindow( ShowTime )  
 if g_TGM_XinShouNew_BaiBao_LoadFirstTime == 1 then 
  	--����Ʒ�������ص�ҳ����ʾ
  	for i = 1,  table.getn(g_TGM_XinShouNew_BaiBao_GiftsIcons) do
  		for j = 1, table.getn(g_TGM_XinShouNew_BaiBao_GiftsIcons[i]) do
  			local	GiftItemID	=	-1
  			local	GiftItemNum	=	0
  			if j > table.getn( g_TGM_XinShouNew_BaiBao_Gifts[i] ) then
  				g_TGM_XinShouNew_BaiBao_GiftsIcons[i][j]:Hide(); 
				g_TGM_XinShouNew_BaiBao_GiftsIcons_NUM[i][j]:SetText(""); 
  			else
  				GiftItemID	=	g_TGM_XinShouNew_BaiBao_Gifts[i][j].GiftItemID
  				GiftItemNum	= 	g_TGM_XinShouNew_BaiBao_Gifts[i][j].num
  				local theAction = GemMelting:UpdateProductAction(GiftItemID)
  				if theAction:GetID() ~= 0 then
  					--if g_TGM_XinShouNew_BaiBao_Gifts[i][j].new ~= nil and g_TGM_XinShouNew_BaiBao_Gifts[i][j].new == 1 then
  					--	g_TGM_XinShouNew_BaiBao_GiftsIconImages[i][j] : SetProperty("Image",g_TGM_XinShouNew_PrizeItemButtonIcon);
  					--end
  					g_TGM_XinShouNew_BaiBao_GiftsIcons[i][j]:SetActionItem(theAction:GetID());
  					g_TGM_XinShouNew_BaiBao_GiftsIcons[i][j]:Show(); 
					if GiftItemNum > 1 then
						g_TGM_XinShouNew_BaiBao_GiftsIcons_NUM[i][j]:SetText("#e010101"..GiftItemNum); 
					end
  				end
  			end
  		end
  	end
  	--������ȡ�İ�ťȫ��Ϊ������
  	for i = 1, 6 do
  		g_TGM_XinShouNew_BaiBao_GetGiftsButtonList[i] : Disable()
  		g_TGM_XinShouNew_BaiBao_GetGiftsButtonList[i] : SetProperty("DisabledImage","set:ServerNewUI4 image:XinShouYueUI_GM_Normal") 
  	end
  	g_TGM_XinShouNew_BaiBao_LoadFirstTime = 0
  	--TGM_XinShouNew_ShowButtonTips(8,0)
 end

---���ý�������ʾ�Ļ��ֹʱ��
  
  --��ȡ���ֹʱ��  
  local EndDate = g_TGM_XinShouNew_EndTime
    
  local deEndYear = math.floor(EndDate/100000000)
	local deEndMon = math.mod(math.floor(EndDate/1000000),100)
	local deEndDay = math.mod(math.floor(EndDate/10000),100)  
	local deEndHour = math.mod(math.floor(EndDate/100),100)  
	--���ù���
 	local InfoText = string.format("#cfff263�ﵽָ���ȼ��󣬼��ɹ���#G�ۿۺ���#cfff263��ÿ�غ�����ɹ���#G1��#cfff263��",deEndYear,deEndMon,deEndDay,deEndHour)	
	TGM_XinShouNew_BaiBao_Info:SetText( InfoText )
	--ͨ������ �������� 
	local nLevel = Player : GetData("LEVEL");
	local LevelGrade = 0;
	for i = 1,table.getn(g_TGM_XinShouNew_BaiBao_GetGiftsCondition)  do
		if nLevel < g_TGM_XinShouNew_BaiBao_GetGiftsCondition[i].Level then
			g_TGM_XinShouNew_BaiBao_NotifyTipsControlList[i].LevelText:SetText( string.format("#cff0000�ﵽ%s���ɹ���", g_TGM_XinShouNew_BaiBao_GetGiftsCondition[i].Level ))
			g_TGM_XinShouNew_BaiBao_NotifyTipsControlList[i].YBText:SetText(string.format("#cff0000�ۿۼۣ�%sԪ����ԭ��%s��", g_TGM_XinShouNew_BaiBao_GetGiftsCondition[i].Cost , g_TGM_XinShouNew_BaiBao_GetGiftsCondition[i].PriCost  ) )
			if i <= table.getn(g_TGM_XinShouNew_BaiBao_GetGiftsButtonList) then	--δ���
				g_TGM_XinShouNew_BaiBao_GetGiftsButtonList[i] : Disable()
				g_TGM_XinShouNew_BaiBao_GetGiftsButtonList[i] : SetProperty("DisabledImage","set:ServerNewUI2 image:ServerNewUI_LQ_WDC") 
    	  g_TGM_XinShouNew_BaiBao_GetGiftsButtonList[i] : SetToolTip(string.format("#Y�ﵽ%s�����ɹ�����Ʒ", g_TGM_XinShouNew_BaiBao_GetGiftsCondition[i].Level ))	
			end
		else
			g_TGM_XinShouNew_BaiBao_NotifyTipsControlList[i].LevelText:SetText( string.format("#G�ﵽ%s���ɹ���", g_TGM_XinShouNew_BaiBao_GetGiftsCondition[i].Level ))
			g_TGM_XinShouNew_BaiBao_NotifyTipsControlList[i].YBText:SetText(string.format("#G�ۿۼۣ�#cff0000%sԪ��#P��ԭ��%s��", g_TGM_XinShouNew_BaiBao_GetGiftsCondition[i].Cost , g_TGM_XinShouNew_BaiBao_GetGiftsCondition[i].PriCost  ) )
			if i <= table.getn(g_TGM_XinShouNew_BaiBao_GetGiftsButtonList) and  g_TGM_XinShouNew_BaiBaoBtnState[i] == 0 then		--���Թ���
				g_TGM_XinShouNew_BaiBao_GetGiftsButtonList[i] : SetProperty("DisabledImage","set:ServerNewUI4 image:XinShouYueUI_GM_Normal") 
    		g_TGM_XinShouNew_BaiBao_GetGiftsButtonList[i] : Enable()  
    		g_TGM_XinShouNew_BaiBao_GetGiftsButtonList[i] : SetToolTip(string.format("#Y����%sԪ���ɽ�����Ʒ����", g_TGM_XinShouNew_BaiBao_GetGiftsCondition[i].Cost ))		 
			end
			if i <= table.getn(g_TGM_XinShouNew_BaiBao_GetGiftsButtonList) and  g_TGM_XinShouNew_BaiBaoBtnState[i] == 1 then		--�ѹ���
				g_TGM_XinShouNew_BaiBao_GetGiftsButtonList[i] : SetProperty("DisabledImage","set:ServerNewUI4 image:XinShouYueUI_GM_Disable")  	 
    	  g_TGM_XinShouNew_BaiBao_GetGiftsButtonList[i] : SetToolTip("#{XSJNH_180111_145}")		
    		g_TGM_XinShouNew_BaiBao_GetGiftsButtonList[i] : Disable()
			end
		end
	end

end

--********************************************************************
-- ��ť,�ͻ��˽���"��ȡ����"��ť�����Ӧ�¼�����
--********************************************************************
function TGM_XinShouNew_Supe_TopImage_XiaoXiang_222( nIndex )
Clear_XSCRIPT()
Set_XSCRIPT_Function_Name( "XiaoXiang_yaoqingma" );
Set_XSCRIPT_ScriptID( 928775 );
Set_XSCRIPT_Parameter(0,tonumber(30000))
Set_XSCRIPT_ParamCount(1)
Send_XSCRIPT()
end


function TGM_XinShouNew_BaiBao_Frame3_GetGift( nIndex )
	
	--�ͻ��˽��г����ļ��,���ͨ���ɷ������ű�ִ�з����߼�
	--1.�����ҵĵȼ��Ƿ񵽴���콱�ĵȼ�
	local nLevel = Player : GetData("LEVEL")
	if nLevel < g_TGM_XinShouNew_BaiBao_GetGiftsCondition[nIndex].Level then
		PushDebugMessage("#{SJSHL_140919_24}")					--�Բ�������δ�ﵽ����ȡ�����ĵȼ����޷���ȡ����
		return
	end
	--2.����Ƿ�δ��ȡ�ý���
	if nIndex < 1 or nIndex > 6 then
		return
	elseif g_TGM_XinShouNew_BaiBaoBtnState[nIndex] == 1 then					--��ťΪ"δ����"״̬,˵������MF�ж�����Ѿ���ȡ��������
		PushDebugMessage("#{SJSHL_140919_25}")					--�Բ���,���Ѿ���ȡ���˽���,�޷��ٴ���ȡ
		return
	end	
	--3.ȫ�����ͨ��,���÷������ű����콱�߼�
	-- ִ�нű�
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("GetGiftsForHeroBag"); 
		Set_XSCRIPT_ScriptID(990016);		
		Set_XSCRIPT_Parameter(0,nIndex);
		Set_XSCRIPT_ParamCount(1);
	Send_XSCRIPT()
end
--Ӣ�۰ٱ���end

--===============================================
-- Ӣ�۰ٱ��� -end
--===============================================


--===============================================
-- ����������-begin
--===============================================

--����������begin
function TGM_XinShouNew_LuckyDraw_Show( ShowTime )
	TGM_XinShouNew_LuckyDraw_UpdateInfo();
 	TGM_XinShouNew_LuckyDraw_FlushWindow(ShowTime);
end
--**********************************
-- �������Btn״̬
--**********************************
function TGM_XinShouNew_LuckyDraw_UpdateInfo() 
	-- ִ�нű�
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "UpdateLuckyInfo" ); 
		Set_XSCRIPT_ScriptID( 990016 );		
		Set_XSCRIPT_ParamCount(0);
	Send_XSCRIPT()
end

--function TGM_XinShouNew_LuckyDraw_UpdateRedPoint(ShowTime)
--	if g_LuckyDrawCount < g_LuckyDrawTotalCount and  g_LuckyDrawCount >= 0 and g_LuckyDrawRemainTime == 0 then   
--		TGM_XinShouNew_ShowButtonTips(9,1)
--	else
--		TGM_XinShouNew_ShowButtonTips(9,0)
--	end  
--end

function TGM_XinShouNew_LuckyDraw_FlushWindow( ShowTime ) 
		
	if g_TGM_XinShouNew_LuckyDraw_LoadFirstTime == 1 then
  	--����Ʒ�������ص�ҳ����ʾ
		for i = 1,  table.getn(g_TGM_XinShouNew_LuckyDraw_GiftsIcons) do
			for j = 1, table.getn(g_TGM_XinShouNew_LuckyDraw_GiftsIcons[i]) do
				local	GiftItemID	=	-1
				local	GiftItemNum	=	0
				if j > table.getn( g_TGM_XinShouNew_LuckyDraw_Gifts[i] ) then
					g_TGM_XinShouNew_LuckyDraw_GiftsIcons[i][j]:Hide();
				else
					GiftItemID	=	g_TGM_XinShouNew_LuckyDraw_Gifts[i][j].GiftItemID
					GiftItemNum	= 	g_TGM_XinShouNew_LuckyDraw_Gifts[i][j].num
					local theAction = GemMelting:UpdateProductAction(GiftItemID)--DataPool:CreateActionItemForShow(GiftItemID, GiftItemNum)
					if theAction:GetID() ~= 0 then
						--if g_TGM_XinShouNew_BaiBao_Gifts[i][j].new ~= nil and g_TGM_XinShouNew_BaiBao_Gifts[i][j].new == 1 then
						--	g_TGM_XinShouNew_BaiBao_GiftsIconImages[i][j] : SetProperty("Image",g_TGM_XinShouNew_PrizeItemButtonIcon);
						--end
						g_TGM_XinShouNew_LuckyDraw_GiftsIcons[i][j]:SetActionItem(theAction:GetID());
						g_TGM_XinShouNew_LuckyDraw_GiftsIcons[i][j]:SetProperty("CornerChar",string.format("BotRight %s",GiftItemNum))
						g_TGM_XinShouNew_LuckyDraw_GiftsIcons[i][j]:Show();
					end
				end
			end
		end 
		g_TGM_XinShouNew_LuckyDraw_LoadFirstTime = 0
	end
  
	--����������ʱ�� 
	local eEndTime = g_TGM_XinShouNew_EndTime
	local deEndYear= math.floor(eEndTime/100000000)
	local deEndMon = math.mod(math.floor(eEndTime/1000000),100)
	local deEndDay = math.mod(math.floor(eEndTime/10000),100) 
	local deEndHour = math.mod(math.floor(eEndTime/100),100)  
	
  --���ù���
	local dexpText = string.format("#cfff263����ʱ����ʱ�����ɻ��#G1#cfff263��#G�齱����#cfff263��#Gÿ��#cfff263���ɳ�ȡ#G3#cfff263�κ���", deEndYear,deEndMon,deEndDay,deEndHour)  
	TGM_XinShouNew_LuckStar_Info:SetText(dexpText) 
	
	--����ʱ��ؼ� 
	TGM_XinShouNew_LuckStar_Time_Watch:SetProperty("Timer",tostring(g_LuckyDrawRemainTime) ); 
	TGM_XinShouNew_LuckStar_Time_Watch:Show();
	--���ô�������
	TGM_XinShouNew_LuckStar_Numbertext:SetText( string.format("#G�����ѳ齱������#cfff263%s/3", g_LuckyDrawCount) )
	
	--�ж��Ƿ��ǳ齱֮�� ����� �򲥷���Ч
	if g_LuckyDrawIndex > 0 and g_LuckyDrawIndex <= table.getn(g_TGM_XinShouNew_LuckyDraw_GiftLightImage) then
		SetTimer("TGM_XinShouNew","TGM_XinShouNew_LuckyDraw_Tick()", g_TGM_XinShouNew_LuckyDraw_TimerLength )
		g_TGM_XinShouNew_LuckyDraw_GiftLightImage[g_LuckyDrawIndex]:Show()
	end
	-- ��ͬ����� ��ʾ��ͬ�ĵ���ʱ�ֵ�
	--����ʱû����ʱ ��ʾ����ʱ
	if g_LuckyDrawRemainTime > 0 then
		TGM_XinShouNew_LuckStar_Time:SetText( "#{XSJNH_180111_155}" )   --#G������һ�γ齱ʱ�䣺
	end 
	--����ʱ���� 
	if g_LuckyDrawRemainTime == 0 then
		TGM_XinShouNew_LuckStar_Time:SetText( "#{XSJNH_180111_156}" )   --������һ�γ齱ʱ�䣺00��00��00
	end
	
	if g_LuckyDrawCount >= g_LuckyDrawTotalCount then
		TGM_XinShouNew_LuckStar_Time:SetText( "#{XSJNH_180111_157}" )   --������һ�γ齱ʱ�䣺���ճ齱����������//��ɫ
	end 
	
	
	TGM_XinShouNew_LuckStar_Frame3_Bk1_Button1 : SetProperty("DisabledImage","set:ServerNewUI4 image:XinShouYueUI_CJ_Disable")  
	TGM_XinShouNew_LuckStar_Frame3_Bk1_Button1 : Disable();
	
	-- �����ʣ����� ����ʱ���� ��Button ����
	if g_LuckyDrawCount < g_LuckyDrawTotalCount and  g_LuckyDrawCount >= 0 and g_LuckyDrawRemainTime == 0 then   
		TGM_XinShouNew_LuckStar_Frame3_Bk1_Button1 : SetProperty("NormalImage","set:XSHLY03 image:XSHLY_CJ_Normal")
		TGM_XinShouNew_LuckStar_Frame3_Bk1_Button1 : SetProperty("PushedImage","set:XSHLY03 image:XSHLY_CJ_Pushed")   
		TGM_XinShouNew_LuckStar_Frame3_Bk1_Button1 : SetProperty("HoverImage","set:XSHLY03 image:XSHLY_CJ_Hover")        
		TGM_XinShouNew_LuckStar_Frame3_Bk1_Button1 : Enable(); 
		TGM_XinShouNew_LuckStar_Frame3_Bk1_Button1_Animate:Show()
	end  
	
	-- �����ʣ����� ����ʱδ���� ��Button Disable ���tips
	if g_LuckyDrawCount < g_LuckyDrawTotalCount and  g_LuckyDrawCount >= 0 and g_LuckyDrawRemainTime > 0 then  
			TGM_XinShouNew_LuckStar_Frame3_Bk1_Button1 : SetProperty("NormalImage","set:XSHLY03 image:XSHLY_CJ_Disabled")
			TGM_XinShouNew_LuckStar_Frame3_Bk1_Button1 : SetProperty("PushedImage","set:XSHLY03 image:XSHLY_CJ_Disabled")   
			TGM_XinShouNew_LuckStar_Frame3_Bk1_Button1 : SetProperty("HoverImage","set:XSHLY03 image:XSHLY_CJ_Disabled")  
			TGM_XinShouNew_LuckStar_Frame3_Bk1_Button1 : Enable(); 
		  TGM_XinShouNew_LuckStar_Frame3_Bk1_Button1 : SetToolTip("#{XSJNH_180111_159}")	
		  TGM_XinShouNew_LuckStar_Frame3_Bk1_Button1_Animate:Hide()
	end  
	
	-- ����齱�������� �������tips
	if g_LuckyDrawCount >= g_LuckyDrawTotalCount then   
			TGM_XinShouNew_LuckStar_Frame3_Bk1_Button1 : SetProperty("NormalImage","set:XSHLY03 image:XSHLY_CJ_Disabled")
			TGM_XinShouNew_LuckStar_Frame3_Bk1_Button1 : SetProperty("PushedImage","set:XSHLY03 image:XSHLY_CJ_Disabled")   
			TGM_XinShouNew_LuckStar_Frame3_Bk1_Button1 : SetProperty("HoverImage","set:XSHLY03 image:XSHLY_CJ_Disabled")  
		  TGM_XinShouNew_LuckStar_Frame3_Bk1_Button1 : Enable();
		  TGM_XinShouNew_LuckStar_Frame3_Bk1_Button1 : SetToolTip("#{XSJNH_180111_160}")	
		  TGM_XinShouNew_LuckStar_Frame3_Bk1_Button1_Animate:Hide()
	end  	
		
	-- ����С���
	--TGM_XinShouNew_LuckyDraw_UpdateRedPoint(ShowTime)
end

function TGM_XinShouNew_LuckyDraw_Frame3_GetGift( )
	--�ͻ��˽��г����ļ��,���ͨ���ɷ������ű�ִ�з����߼�
	--2.����Ƿ�δ��ȡ�ý���
	if g_LuckyDrawCount >= g_LuckyDrawTotalCount and  g_LuckyDrawCount < 0 then
		PushDebugMessage("#{XSHLY_150522_32}")					--�Բ���,���Ѿ���ȡ���˽���,�޷��ٴ���ȡ
		return 
	end
	-- ִ�нű�
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "GetGiftsForLuckyDraw" ); 
		Set_XSCRIPT_ScriptID( 990016 );		
		Set_XSCRIPT_ParamCount(0);
	Send_XSCRIPT()
end
-- 5�����Ч
function TGM_XinShouNew_LuckyDraw_Tick()
	g_TGM_XinShouNew_LuckyDraw_GiftLightImage[g_LuckyDrawIndex]:Hide();
	KillTimer("TGM_XinShouNew_LuckyDraw_Tick()")
	g_LuckyDrawIndex = 0;
end

-- ʱ�䵽��
function TGM_XinShouNew_LuckStar_TimeReach()
	--TGM_XinShouNew_LuckStar_Time_Watch:SetProperty("Timer","0") 
	TGM_XinShouNew_LuckStar_Time:SetText( "#{XSJNH_180111_156}" )   --������һ�γ齱ʱ�䣺00��00��00
	-- �����ʣ����� ����ʱ���� ��Button ����
	if g_LuckyDrawCount < g_LuckyDrawTotalCount and  g_LuckyDrawCount >= 0  then   
			TGM_XinShouNew_LuckStar_Frame3_Bk1_Button1 : SetProperty("NormalImage","set:XSHLY03 image:XSHLY_CJ_Normal")
			TGM_XinShouNew_LuckStar_Frame3_Bk1_Button1 : SetProperty("PushedImage","set:XSHLY03 image:XSHLY_CJ_Pushed")   
			TGM_XinShouNew_LuckStar_Frame3_Bk1_Button1 : SetProperty("HoverImage","set:XSHLY03 image:XSHLY_CJ_Hover")        
		  TGM_XinShouNew_LuckStar_Frame3_Bk1_Button1 : Enable(); 
	end  
	TGM_XinShouNew_LuckStar_Frame3_Bk1_Button1_Animate:Show()
end
--����������end
--===============================================
-- ��������·-begin
--===============================================
--�����ť����·��ҳ��������������
function  TGM_XinShouNew_Heroes_Road_Ask()
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("AskHeroesRoadInfo");
		Set_XSCRIPT_ScriptID(892677);
		Set_XSCRIPT_Parameter(0,0)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT();
end

--����·�����ҳ�л������������أ�ˢ�½���
function TGM_XinShouNew_Heroes_Road_OnSwitchPage(nIndex,nValue,nDayGap)

	local idx = nIndex-1
	g_nContentButton = {}
	if idx<0 or idx >6 then
		return
	end
--	Lua_SortHaoXia()
--	TGM_XinShouNew_Heroes_RoadList:CleanAllElement("TGM_XinShouNew")
--
--	local Num = Lua_GetMaiDianNumByDay(idx)
	for i = 0,Num-1 do
--		local MaiDianValue = 0
--
--		local BounsFlag = 0
--		local nChangeIndex = Lua_GetHaoXiaIndex(idx,i)
--		BounsFlag = DataPool:Lua_GetHaoXiaRoadFlag(idx,nChangeIndex)
--		local Desc,TargetNum,BounsNum,Isspecial,Image1,Image2,nType,param0,param1,param2 = Lua_GetXinShouHeroesRoadInfo(idx,nChangeIndex)
--	
--		local ItemBar = TGM_XinShouNew_Heroes_RoadList:AddItemElement( "HeroesRoadButton", "LEFT", "TGM_XinShouNew","" ,"")
--		ItemBar:SetProperty("SuperBarButtonHover","SuperBarHoverSection")
--
--		if Isspecial == 0 then
--			MaiDianValue = DataPool:Lua_GetHaoXiaRoad(idx,nChangeIndex)
--		elseif Isspecial == 1 then
--			MaiDianValue = Player:GetData("EQUIPSCOREHH");
--		end
--		if MaiDianValue >= TargetNum then
--			ItemBar:SetText1("#G"..Desc)
--			ItemBar:SetText2("#G".."��ǰ����"..TargetNum.."/"..TargetNum)
--			ItemBar:SetText3( "#G".."��ɻ�ú���ֵ:"..BounsNum )
--		else
--			ItemBar:SetText1(Desc)
--			ItemBar:SetText2("��ǰ����"..MaiDianValue.."/"..TargetNum)
--			ItemBar:SetText3("��ɻ�ú���ֵ:"..BounsNum )
--		end
--
--		if MaiDianValue < TargetNum then
--			ItemBar:SetButton1Show()
--			ItemBar:SetButton1Text("ǰ��")
--			ItemBar:SetImage2Hide()
--		elseif BounsFlag == 0 then
--			ItemBar:SetButton1Show()
--			ItemBar:SetButton1Text( "#G".."��ȡ")
--			ItemBar:SetImage2Hide()
--		elseif BounsFlag == 1 then
--			ItemBar:SetButton1Hide();
--			ItemBar:SetImage2Show()
--		end
--
--		ItemBar:SetImage1( Image1, Image2 )
--		ItemBar:SetImage1Show()
--
--		table.insert(g_nContentButton,ItemBar);
	end

--	TGM_XinShouNew_Heroes_Road_Huoyue:SetProgress(tonumber(nValue) , 150)
--	local strMsg = string.format( "#{HDRCYH_130118_03}", nValue)
--	TGM_XinShouNew_Heroes_Road_Huoyue:SetToolTip(strMsg)

--	local theAction = DataPool:CreateActionItemForShow(g_TGM_XinShouNew_Heroes_ItemBounsId, 1)
--		TGM_XinShouNew_Heroes_Road_Icon1 : SetActionItem(theAction:GetID())
--
--	local strMsg = string.format( "#{XSJNH_180120_242}", nValue)
--	TGM_XinShouNew_Heroes_Road_Detailtips_text:SetText(strMsg)
--
--	TGM_XinShouNew_Heroes_RoadList:Flash()
--
	g_TGM_XinShouNew_Heroes_Road_LastClickedId = nIndex
	for i = 1,  table.getn(g_TGM_XinShouNew_Heroes_Road_Button) do
		if i == g_TGM_XinShouNew_Heroes_Road_LastClickedId then
			g_TGM_XinShouNew_Heroes_Road_Button[i]:SetCheck(1)
			g_TGM_XinShouNew_Heroes_Road_Button[i]:SetText(g_TGM_XinShouNew_Heroes_ButtonTextSelected[i])
		else
			g_TGM_XinShouNew_Heroes_Road_Button[i]:SetCheck(0)
			g_TGM_XinShouNew_Heroes_Road_Button[i]:SetText(g_TGM_XinShouNew_Heroes_ButtonText[i])
		end
	end

	--����·ʱ��
	local eEndTime = g_TGM_XinShouNew_EndTime
	local deEndYear= math.floor(eEndTime/100000000)
	local deEndMon = math.mod(math.floor(eEndTime/1000000),100)
	local deEndDay = math.mod(math.floor(eEndTime/10000),100)
	local deEndHour = math.mod(math.floor(eEndTime/100),100)

  --���ù���
	local dexpText = string.format("#G20%s��%s��%s��%sʱǰ#cfff263�����Ŀ����ɻ��#G����ֵ#cfff263��", deEndYear,deEndMon,deEndDay,deEndHour)
	TGM_XinShouNew_Heroes_Road_Des1:SetText(dexpText)

--	PushDebugMessage("n="..i)
--		if n==g_TGM_XinShouNew_Heroes_Road_LastClickedId then
--			PushDebugMessage(g_TGM_XinShouNew_Heroes_Road_Button[i].."1")
--		--	g_TGM_XinShouNew_Heroes_Road_Button[i]:SetCheck(1)
--		else
--			PushDebugMessage(g_TGM_XinShouNew_Heroes_Road_Button[i].."0")
--		--	g_TGM_XinShouNew_Heroes_Road_Button[i]:SetCheck(0)
--		end
--	end
	--TGM_XinShouNew_OnCheckMe()
	TGM_XinShouNew_OnCheckRed(nDayGap)
end

--�������·�����ҳ�л�
function TGM_XinShouNew_Heroes_Road_Page_Clicked(nPage)
	if nPage <1 or nPage > 7 then
		return
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("AskHeroesRoadInfo");
		Set_XSCRIPT_ScriptID(892677);
		Set_XSCRIPT_Parameter(0,nPage)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT();
end

function TGM_XinShouNew_Heroes_Road_OnButton1Click()
--	local sPos,ePos = string.find(arg0, "_auto_element")
--	local nIndex = tonumber(string.sub(arg0, ePos + 1, -1))
--	local nDay =g_TGM_XinShouNew_Heroes_Road_LastClickedId-1
--	local nChangeIndex = Lua_GetHaoXiaIndex(nDay,nIndex)
--	local BounsFlag = DataPool:Lua_GetHaoXiaRoadFlag(nDay,nChangeIndex)
--
--	local Desc,TargetNum,BounsNum,Isspecial,Image1,Image2,nType,param0,param1,param2 = Lua_GetXinShouHeroesRoadInfo(nDay,nChangeIndex)
--	local MaiDianValue = 0
--	if Isspecial == 0 then
--		MaiDianValue = DataPool:Lua_GetHaoXiaRoad(nDay,nChangeIndex)
--	--	MaiDianValue = 1
--	elseif Isspecial == 1 then
--		MaiDianValue = Player:GetData("EQUIPSCOREHH");
--	end
--
--	if MaiDianValue < TargetNum then
--		TGM_XinShouNew_Heroes_Road_GoTo(nDay,nChangeIndex,nType,param0,param1,param2)
--	elseif BounsFlag == 0 then
--		TGM_XinShouNew_Heroes_Road_GetBounsValue(nDay,nIndex)
--		g_lastMaiDian = nChangeIndex
--		g_lastDay = nDay
--	end
--	
--	for nButtonIndex = 1,table.getn(g_nContentButton) do
--		if nil ~= g_nContentButton[nButtonIndex] then
--			g_nContentButton[nButtonIndex]:SetButton1Normal()
--		end
--	end

end

function TGM_XinShouNew_Heroes_Road_GoTo(nDay,nIndex,nType,param0,param1,param2)
	--�򿪽���
	if nType == 1 then
		TGM_XinShouNew_Heroes_Road_GoTo_OpenUI(nDay,nIndex,nType,param0,param1,param2)
	--�̶�����������Զ�Ѱ·
	elseif nType == 2 then
		--AutoRunToTarget(param1,param2,param0)

	--�����Զ�Ѱ·1,���ȼ����ֲ�ͬ��Ѱ·Ŀ��
	elseif nType ==  3 then
		if  Player:GetData("LEVEL") < 65  then
			AutoRunToTarget(65,92)
		else
			AutoRunToTarget(281,81)
		end
		--�����Զ�Ѱ·1,���������ֲ�ͬ��Ѱ·Ŀ��
	elseif nType ==  4 then
		local menpai = Player : GetData( "MEMPAI" );		--��ȡ�������ID
		if ( menpai < 0 or menpai > 12 ) then
			return
		end
		if(0 == menpai) then
	--		strName = "����";
			AutoRunToTarget(91.7971,71.3921)
		elseif(1 == menpai) then
	--		strName = "����";
			AutoRunToTarget(109.1598,59.3804)
		elseif(2 == menpai) then
	--		strName = "ؤ��";
			AutoRunToTarget(94.1281,99.142)
		elseif(3 == menpai) then
	--		strName = "�䵱";
			AutoRunToTarget(82.8534,84.9902)
		elseif(4 == menpai) then
	--		strName = "����";
			AutoRunToTarget(98.105,51.7009)
		elseif(5 == menpai) then
	--		strName = "����";
			AutoRunToTarget(87.068,70.1534)
		elseif(6 == menpai) then
	--		strName = "����";
			AutoRunToTarget(97.9375,67.0415)
		elseif(7 == menpai) then
	--		strName = "��ɽ";
			AutoRunToTarget(88.6175,44.5456)
		elseif(8 == menpai) then
	--		strName = "��ң";
			AutoRunToTarget(125.1805,142.0748)
		elseif(9 == menpai) then
	--		strName = "������";
				PushDebugMessage("#{XY_0110_67}")
		elseif(10== menpai) then
	--		strName = "Ľ��";
			AutoRunToTarget(48,134.5865)
		elseif(11== menpai) then
	--		strName = "����";
			AutoRunToTarget(38.4,75.2)
		elseif(12== menpai) then
	--		strName = "���";		
			AutoRunToTarget(92,55)
		elseif(13== menpai) then
	--		strName = "�һ���";		
			AutoRunToTarget(92,55)
		end

	end
end
-- �򿪾��ʻ--ȫ��
function TGM_XinShouNew_Heroes_Road_OpenJCHD()
	local nLevel = Player:GetData("LEVEL");	
	if ( nLevel < 10 ) then		
		PushDebugMessage("#{XSJNH_180112_236}")		
		return	
	end		-- ��UI
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "XYJCall" ); 
		Set_XSCRIPT_ScriptID( 990000 );			
		Set_XSCRIPT_Parameter( 0, tonumber(4));
		Set_XSCRIPT_ParamCount( 1 );			
	Send_XSCRIPT()
	PushEvent("UI_COMMAND",2018012302)
end
-- �򿪾��ʻ--Ĭ��
function TGM_XinShouNew_Heroes_Road_OpenJCHD_Default()
	local nLevel = Player:GetData("LEVEL");	
	if ( nLevel < 10 ) then		
		PushDebugMessage("#{XSJNH_180112_236}")		
		return	
	end		-- ��UI
    Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "XYJCall" ); 
		Set_XSCRIPT_ScriptID( 990000 );			
		Set_XSCRIPT_Parameter( 0, tonumber(4));
		Set_XSCRIPT_ParamCount( 1 );
	Send_XSCRIPT()
end
--�����ַ���¼
function TGM_XinShouNew_Heroes_Road_OpenWLFYL(nIndex)
		-- ��UI
	local menpai = Player : GetData( "MEMPAI" );		--��ȡ�������ID
	if ( menpai < 0 or menpai > 12 or menpai == 9 ) then
		PushDebugMessage( "#{JDZY_120806_875}" );
		return
	end
		-- �ȼ�	
		local nLevel = Player:GetData("LEVEL");	
		if ( nLevel < 30 ) then		
			PushDebugMessage("#{XSJNH_180112_236}")		
			return	
		end	
	PushEvent("UI_COMMAND",2018012303,nIndex)
end
--�����ɼ���
function TGM_XinShouNew_Heroes_Road_OpenMPJN()
		-- ��UI	
		local menpai = Player : GetData( "MEMPAI" );		
		--��ȡ�������ID	
		if ( menpai < 0 or menpai > 12 or menpai == 9 ) then
			PushDebugMessage( "�㻹û�а������ɡ�" );		
			return	
		end	
		--DataPool:Lua_SetLastSkill_UI(2)
	ToggleSkillBook();

--	local LastSKilltap = GetLastSkill_UI()
--	local nProcess = DataPool:GetCurrentFreshManGuideItemValue();
--	if nProcess ==22  then
--		if LastSKilltap == 1 then
--			NotifyPopUITip("CommonSkill", -1, 1)
--		elseif LastSKilltap == 2 then
--			PushEvent("OPEN_FRESHMAN_NEWNPCCHAT",8)
--		end
--		DataPool:SetCurrentFreshManGuideItemValue(0);
--	end
end

function TGM_XinShouNew_Heroes_Road_OpenMZTH()
	local nLevel = Player:GetData("LEVEL");
	if ( nLevel < 15 ) then
		PushDebugMessage("#{MRLB_170623_03}")
		return
	end
	local curDay = 20190319--tonumber(DataPool:GetServerDayTime());
	--�����������ڼ�ĸ���ǩ�����ͬ���޸������ʱ��
	if curDay >= 20180101 and curDay <= 20180228 or
		curDay >= 20180501 and curDay <= 20180531 or
		curDay >= 20170801 and curDay <= 20170831 or
		curDay >= 20171001 and curDay <= 20171130 then
		--OpenOneDayGiftSP(1)
	else
		--OpenOneDayGift(1)
	end
end
--��װ����������ָ������
function TGM_XinShouNew_Heroes_Road_OpenFightScore()
	if Player:GetData("LEVEL") >= 30 then
		PushEvent("OPEN_EQUIP_SCORE_CONDUCT")
	else
		PushDebugMessage("#{PFZY_140613_174}")
	end
end

function TGM_XinShouNew_Heroes_Road_GoTo_OpenUI(nDay,nIndex,nType,param0,param1,param2)
	--PushDebugMessage("g_PageNum="..g_PageNum)
	if param0 == 0 then --�򿪺��ѽ���
		DataPool:OpenFriendList();
	elseif param0 == 1 then --���������
		ToggleMission();
	elseif param0 == 2 then --�򿪾��ʻ���� ѡ��ȫ��
		TGM_XinShouNew_Heroes_Road_OpenJCHD()
	elseif param0 == 3 then --�����ַ���¼ ѡ�иð���ҳǩ
		TGM_XinShouNew_Heroes_Road_OpenWLFYL(1)
	elseif param0 == 4 then --���ּ��껪-�׳����
		TGM_XinShouNew_Project_Clicked(3)
	elseif param0 == 5 then  --�����ַ���¼ ѡ�б�ʯҳǩ
		TGM_XinShouNew_Heroes_Road_OpenWLFYL(5)
	elseif param0 == 6 then --�������� ����ҳ
		TogglePetPage();
	elseif param0 == 7 then --�򿪾��ʻ���� ѡ��ȫ��
		TGM_XinShouNew_Heroes_Road_OpenJCHD()
	elseif param0 == 8 then -- ��������-���ܽ���-���ɼ��ܷ�ҳ
		TGM_XinShouNew_Heroes_Road_OpenMPJN()
	elseif param0 == 9 then -- �����ַ���¼ ѡ�����
		TGM_XinShouNew_Heroes_Road_OpenWLFYL(10)
	elseif param0 == 10 then -- �򿪾��ʻ
		TGM_XinShouNew_Heroes_Road_OpenJCHD_Default()
	elseif param0 == 11 then --����-ÿ���ػݽ���
		TGM_XinShouNew_Heroes_Road_OpenMZTH()
	elseif param0 == 12 then --������-����-��
		OpenShengDingLayout()
	elseif param0 == 13 then --�򿪾��ʻ���� ѡ��ȫ��
		TGM_XinShouNew_Heroes_Road_OpenJCHD()
	elseif param0 == 14 then -- ��������-���ܽ���-���ɼ��ܷ�ҳ
		TGM_XinShouNew_Heroes_Road_OpenMPJN()
	elseif param0 == 15 then -- ���ַ���¼��ѡ����Ԫҳǩ
		TGM_XinShouNew_Heroes_Road_OpenWLFYL(15)
	elseif param0 == 16 then -- �򿪾��ʻ
		TGM_XinShouNew_Heroes_Road_OpenJCHD_Default()
	elseif param0 == 17 then --��װ����������ָ������
		TGM_XinShouNew_Heroes_Road_OpenFightScore()
	elseif param0 == 18 then --������-����-��
		OpenShenDingPage();
	elseif param0 == 19 then --��װ����������ָ������
		TGM_XinShouNew_Heroes_Road_OpenFightScore()
	elseif param0 == 20 then -- �򿪾��ʻ
		TGM_XinShouNew_Heroes_Road_OpenJCHD()
	elseif param0 == 21 then -- ���ַ���¼��ѡ�н���ҳǩ
		TGM_XinShouNew_Heroes_Road_OpenWLFYL(23)
	elseif param0 == 22 then --��װ����������ָ������
		TGM_XinShouNew_Heroes_Road_OpenFightScore()
	end

end

--��ȡ����ֵ
function TGM_XinShouNew_Heroes_Road_GetBounsValue(nDay,nIndex)
--	local nChangeIndex = Lua_GetHaoXiaIndex(nDay,nIndex)
--	local Desc,TargetNum,BounsNum,Isspecial,Image1,Image2,nType,param0,param1,param2 = Lua_GetXinShouHeroesRoadInfo(nDay,nChangeIndex)
--	local MaiDianValue = 0
--	if Isspecial == 0 then
--		MaiDianValue = DataPool:Lua_GetHaoXiaRoad(nDay,nChangeIndex)
--	elseif Isspecial == 1 then
--		MaiDianValue = Player:GetData("EQUIPSCOREHH");
--	end
--	local BounsFlag = DataPool:Lua_GetHaoXiaRoadFlag(nDay,nChangeIndex)
--
--	if MaiDianValue >= TargetNum then
--		if BounsFlag == 0 then
--			Clear_XSCRIPT()
--				Set_XSCRIPT_Function_Name("GiveBounsValue")
--				Set_XSCRIPT_ScriptID(892677)
--				Set_XSCRIPT_Parameter(0,nDay)
--				Set_XSCRIPT_Parameter(1,nChangeIndex)		--��Ҫϴ������
--				Set_XSCRIPT_Parameter(2,g_TGM_XinShouNew_Heroes_Road_LastClickedId)
--				Set_XSCRIPT_ParamCount(3)
--			Send_XSCRIPT()
--		end
--	end
end

--�콱
function TGM_XinShouNew_Heroes_Road_HuoYueHaoLiFunc()

	--���콱����
--	local g_IsOpenUI = 1
--	Clear_XSCRIPT();
--		Set_XSCRIPT_Function_Name("AskHeroesRoadBounsUI");
--		Set_XSCRIPT_ScriptID(892677);
--		Set_XSCRIPT_Parameter(0,g_IsOpenUI)
--		Set_XSCRIPT_ParamCount(1)
--	Send_XSCRIPT();

end


--===============================================
-- ��������· -end
--===============================================


--===============================================
-- ����7�պ���-begin
--===============================================
function TGM_XinShouNew_7Day_Show(nType)
	for i=1,7 do
		g_TGM_XinShouNew_7DayButtom[i].Done:Hide()
	end
	local nDate2 = g_TGM_XinShouNew_7DayHaveDone--��ȡ��״̬
	local nTimes = g_TGM_XinShouNew_7DayShowTimes--�Ѿ���ȡ������
	for i = 1,7 do
		if nTimes >= i then
			g_TGM_XinShouNew_7DayButtom[i].Done:Show()			
		else
			g_TGM_XinShouNew_7DayButtom[i].Done:Hide()
		end
	end
	if nType == 0 then
		TGM_XinShouNew_SevenDay_Click(nTimes + 1)
	else
		if g_TGM_XinShouNew_7DayPrize_Click == 0 then
			TGM_XinShouNew_SevenDay_Click(1)
		else
			TGM_XinShouNew_SevenDay_Click(g_TGM_XinShouNew_7DayPrize_Click)
		end
	end
end
function TGM_XinShouNew_7Day_Update()
	TGM_XinShouNew_7Day_Show(1)
end
function TGM_XinShouNew_SevenDay_Click(nIndex)
	if nIndex<1 or nIndex>7 then
		return
	end

	TGM_XinShouNew_SevenDay_Left_image:SetProperty( "Image", g_TGM_XinShouNew_7DayImage[nIndex][1] )
	TGM_XinShouNew_SevenDay_Right_imageDay:SetProperty( "Image", g_TGM_XinShouNew_7DayImage[nIndex][2] )
	TGM_XinShouNew_SevenDay_Right_imageDayItem:SetProperty( "Image", g_TGM_XinShouNew_7DayImage[nIndex][3] )

	for i=1, 7 do
		g_TGM_XinShouNew_7DayButtom[i].Button:SetCheck(0)
	end

	g_TGM_XinShouNew_7DayPrize_Click = nIndex

	--��ʾһ�½���
	for i=1, 4 do
		g_TGM_XinShouNew_7DayPrize_Button[i]:SetActionItem( -1 );
		g_TGM_XinShouNew_7DayPrize_Button_Num[i]:SetText("")
	end

	local nCount = table.getn(g_TGM_XinShouNew_7DayPrize[nIndex])

	for i=1,nCount do
		local nItemID = g_TGM_XinShouNew_7DayPrize[nIndex][i].ItemID
		local nNum = g_TGM_XinShouNew_7DayPrize[nIndex][i].num
		local theAction = GemMelting:UpdateProductAction(nItemID)
		if theAction:GetID() ~= 0 then
			g_TGM_XinShouNew_7DayPrize_Button[i]:SetActionItem( theAction:GetID() );
			if nNum > 1 then
				g_TGM_XinShouNew_7DayPrize_Button_Num[i]:SetText("#e010101"..nNum)
			end
		else
			g_TGM_XinShouNew_7DayPrize_Button[i]:SetActionItem( -1 );
		end
	end

	g_TGM_XinShouNew_7DayButtom[nIndex].Button:SetCheck(1)

	--��һ����ҳ�ǲ��ǿ��Դ�
	local nTimes = g_TGM_XinShouNew_7DayShowTimes
	if nIndex > nTimes then
		--��X�տ���ȡ
		TGM_XinShouNew_SevenDay_Right_Button1:Disable()
		TGM_XinShouNew_SevenDay_Right_Button1: SetProperty("DisabledImage",g_TGM_XinShouNew_7DayImage[nIndex][4])
	else
		--���ǲ����Ѿ���ȡ��
		local nData2 = g_TGM_XinShouNew_7DayHaveDone
		if nData2 < nTimes then
		--δ��ȡ
			TGM_XinShouNew_SevenDay_Right_Button1:Enable()
		else
		--����ȡ
			TGM_XinShouNew_SevenDay_Right_Button1:Disable()
			TGM_XinShouNew_SevenDay_Right_Button1: SetProperty("DisabledImage","set:XSYNew02 image:TGM_XinShouNew_Time_DisabledYLQ")
		end
	end
end

function TGM_XinShouNew_SevenDay_GetPrize()
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("Get7DayPrize");
		Set_XSCRIPT_ScriptID(990016);
		Set_XSCRIPT_Parameter(0,g_TGM_XinShouNew_7DayPrize_Click)
		Set_XSCRIPT_ParamCount(1);
	Send_XSCRIPT();
end
--===============================================
-- ����7�պ��� -end
--===============================================
--==========================�罻����==========================
--============================================================
--��ʾ����
function TGM_XinShouNew_SheJiaoDaRen_Show()
	TGM_XinShouNew_SheJiaoRequest()
	TGM_XinShouNew_SheJiaoDaRen_FreshWindow()
	--TGM_XinShouNew_SheJiaoDaRen_UpdateRedPoint()
end
--����ˢ��
function TGM_XinShouNew_SheJiaoDaRen_UpDateDate()
	for i = 1,5 do
		g_SheJiaoRewardBtnState[i] = Get_XParam_INT(i - 1)
	end
	--��һ�Ľ�ֹ����
	g_SheJiaoDeadLine = Get_XParam_INT(5)
	if(this:IsVisible()) then
		--ˢ�½���
		TGM_XinShouNew_SheJiaoDaRen_FreshWindow()
	end
	--TGM_XinShouNew_SheJiaoDaRen_UpdateRedPoint()
end

--ˢ�´���yymmddhhmm
function TGM_XinShouNew_SheJiaoDaRen_FreshWindow()
	local year,month,day,hour = TGM_XinShouNew_SheJiaoGetTime()
	for i = 1,5 do
		g_SheJiaoButtonAima[i]:Hide()
		local tooltip = string.format(g_SheJiaoBtnToolTips[i],year,month,day,hour)
		local tooltipDisble = string.format(g_SheJiaoBtnToolTipsDisbles[i],year,month,day,hour)
		g_SheJiaoButtons[i]:SetToolTip(tooltip)
		g_SheJiaoButtonDisbles[i]:SetToolTip(tooltipDisble)
		if(g_SheJiaoRewardBtnState[i] == 1) then
			g_SheJiaoButtons[i]:Show()
			g_SheJiaoButtonKongs[i]:Hide()
			g_SheJiaoButtonDisbles[i]:Hide()
		elseif (g_SheJiaoRewardBtnState[i] == 2) then
			g_SheJiaoButtons[i]:Hide()
			g_SheJiaoButtonKongs[i]:Show()
			g_SheJiaoButtonDisbles[i]:Hide()
		elseif(g_SheJiaoRewardBtnState[i] == 0) then
			g_SheJiaoButtons[i]:Hide()
			g_SheJiaoButtonKongs[i]:Hide()
			g_SheJiaoButtonDisbles[i]:Show()
		else
			g_SheJiaoButtons[i]:Hide()
			g_SheJiaoButtonKongs[i]:Hide()
			g_SheJiaoButtonDisbles[i]:Show()
		end
	end
	TGM_XinShouNew_SheJiaoFillGiftIcons()
end
--���߽������ǲ���ģ���һ�δ򿪵�ʱ�����һ�ξ�����
function TGM_XinShouNew_SheJiaoFillGiftIcons()
	if(g_SheJiaoIsFillIcon == 0) then
		g_SheJiaoIsFillIcon = 1
		for i=1,table.getn(g_SheJiaoSheJiaoDaRenIcons) do
			for j = 1,table.getn(g_SheJiaoSheJiaoDaRenIcons[i]) do
				g_SheJiaoSheJiaoDaRenIcons[i][j]:Hide()
			end
		end
		for i=1,table.getn(g_SheJiaoDaRenGitf) do
			for j=1,table.getn(g_SheJiaoDaRenGitf[i]) do
				local theAction = GemMelting:UpdateProductAction(g_SheJiaoDaRenGitf[i][j].GiftItemID)
				if theAction:GetID() ~= 0 then
					g_SheJiaoSheJiaoDaRenIcons[i][j]:SetActionItem(theAction:GetID());
					g_SheJiaoSheJiaoDaRenIcons[i][j]:SetProperty("CornerChar",string.format("BotRight %s",g_SheJiaoDaRenGitf[i][j].GiftItemNum))
					g_SheJiaoSheJiaoDaRenIcons[i][j]:Show();
				end
			end
		end
	end
end
function TGM_XinShouNew_SheJiaoInit()
	if(g_bInitSheJiao == 1) then
		return 
	end
	g_bInitSheJiao = 1
	g_SheJiaoButtons[1] = TGM_XinShouNew_SheJiaoDaRen_RewardFrame_JieHun_Button
	g_SheJiaoButtons[2] = TGM_XinShouNew_SheJiaoDaRen_RewardFrame_JieBai_Button
	g_SheJiaoButtons[3] = TGM_XinShouNew_SheJiaoDaRen_RewardFrame_BaiShi_Button
	g_SheJiaoButtons[4] = TGM_XinShouNew_SheJiaoDaRen_RewardFrame_ShouTu_Button
	g_SheJiaoButtons[5] = TGM_XinShouNew_SheJiaoDaRen_RewardFrame_BangHui_Button
	
	g_SheJiaoButtonKongs[1] = TGM_XinShouNew_SheJiaoDaRen_RewardFrame_JieHun_kong
	g_SheJiaoButtonKongs[2] = TGM_XinShouNew_SheJiaoDaRen_RewardFrame_JieBai_kong
	g_SheJiaoButtonKongs[3] = TGM_XinShouNew_SheJiaoDaRen_RewardFrame_BaiShi_kong
	g_SheJiaoButtonKongs[4] = TGM_XinShouNew_SheJiaoDaRen_RewardFrame_ShouTu_kong
	g_SheJiaoButtonKongs[5] = TGM_XinShouNew_SheJiaoDaRen_RewardFrame_BangHui_kong

	
	g_SheJiaoButtonDisbles[1] = TGM_XinShouNew_SheJiaoDaRen_RewardFrame_JieHun_Disable
	g_SheJiaoButtonDisbles[2] = TGM_XinShouNew_SheJiaoDaRen_RewardFrame_JieBai_Disable
	g_SheJiaoButtonDisbles[3] = TGM_XinShouNew_SheJiaoDaRen_RewardFrame_BaiShi_Disable
	g_SheJiaoButtonDisbles[4] = TGM_XinShouNew_SheJiaoDaRen_RewardFrame_ShouTu_Disable
	g_SheJiaoButtonDisbles[5] = TGM_XinShouNew_SheJiaoDaRen_RewardFrame_BangHui_Disable
	
	--˵��һ�������ť����������û���ã�֮ǰ�����������߻����ܸ��ɵ��ˣ�xmlû�ģ�������Ҫ��ʼ������
	g_SheJiaoButtonAima[1] = TGM_XinShouNew_SheJiaoDaRen_RewardFrame_JieHun_Ani
	g_SheJiaoButtonAima[2] = TGM_XinShouNew_SheJiaoDaRen_RewardFrame_JieBai_Ani
	g_SheJiaoButtonAima[3] = TGM_XinShouNew_SheJiaoDaRen_RewardFrame_BaiShi_Ani
	g_SheJiaoButtonAima[4] = TGM_XinShouNew_SheJiaoDaRen_RewardFrame_ShouTu_Ani
	g_SheJiaoButtonAima[5] = TGM_XinShouNew_SheJiaoDaRen_RewardFrame_BangHui_Ani
	--�������ߵ�ICON
	g_SheJiaoSheJiaoDaRenIcons = 
	{
		{TGM_XinShouNew_SheJiaoDaRen_RewardFrame_JieHun_Icon1,TGM_XinShouNew_SheJiaoDaRen_RewardFrame_JieHun_Icon2,TGM_XinShouNew_SheJiaoDaRen_RewardFrame_JieHun_Icon3,TGM_XinShouNew_SheJiaoDaRen_RewardFrame_JieHun_Icon4},
		{TGM_XinShouNew_SheJiaoDaRen_RewardFrame_JieBai_Icon1,TGM_XinShouNew_SheJiaoDaRen_RewardFrame_JieBai_Icon2,TGM_XinShouNew_SheJiaoDaRen_RewardFrame_JieBai_Icon3,TGM_XinShouNew_SheJiaoDaRen_RewardFrame_JieBai_Icon4},
		{TGM_XinShouNew_SheJiaoDaRen_RewardFrame_BaiShi_Icon1,TGM_XinShouNew_SheJiaoDaRen_RewardFrame_BaiShi_Icon2,TGM_XinShouNew_SheJiaoDaRen_RewardFrame_BaiShi_Icon3,TGM_XinShouNew_SheJiaoDaRen_RewardFrame_BaiShi_Icon4},
		{TGM_XinShouNew_SheJiaoDaRen_RewardFrame_ShouTu_Icon1,TGM_XinShouNew_SheJiaoDaRen_RewardFrame_ShouTu_Icon2,TGM_XinShouNew_SheJiaoDaRen_RewardFrame_ShouTu_Icon3,TGM_XinShouNew_SheJiaoDaRen_RewardFrame_ShouTu_Icon4},
		{TGM_XinShouNew_SheJiaoDaRen_RewardFrame_BangHui_Icon1,TGM_XinShouNew_SheJiaoDaRen_RewardFrame_BangHui_Icon2,TGM_XinShouNew_SheJiaoDaRen_RewardFrame_BangHui_Icon3,TGM_XinShouNew_SheJiaoDaRen_RewardFrame_BangHui_Icon4},
	}

end
--�콱��ť��� 1���  2��� 3��ʦ 4��ͽ 5������
function TGM_XinShouNew_SheJiao_ClickRward(nIndex)
	local curTime = FindFriendDataPool:GetTickCount()
	--��ť���Ƶ������
	if(curTime - g_SheJiaoLastClick < 1000) then
		return
	end
	g_SheJiaoLastClick = curTime
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("GetReward")
		Set_XSCRIPT_ScriptID(892687)
		Set_XSCRIPT_Parameter(0,nIndex)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()

end

function TGM_XinShouNew_OnAnimaOver(nIndex)
	--g_SheJiaoButtons[nIndex]:Hide()
	--g_SheJiaoButtonAima[nIndex]:Hide()
	--g_SheJiaoButtonKongs[nIndex]:Show()
	--local strFun = string.format("TGM_XinShouNew_OnAnimaOver(%d)",nIndex)
	--KillTimer(strFun)
end
--���������������
function TGM_XinShouNew_SheJiaoRequest()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("UpDateInfo")
		Set_XSCRIPT_ScriptID(892687)
		Set_XSCRIPT_ParamCount(0)
	Send_XSCRIPT()
end
function TGM_XinShouNew_SheJiaoGetTime()
	local nTime = g_TGM_XinShouNew_EndTime
	local year = math.floor(nTime/100000000) + 2000
	local month = math.floor(math.mod(nTime,100000000)/1000000)
	local day = math.floor(math.mod(nTime,1000000)/10000)
	local hour = math.floor(math.mod(nTime,10000)/100)
	return year,month,day,hour
end
function TGM_XinShouNew_SheJiaoDaRen_ClickDisble(nIndex)
	local strTips = "#{XSJNH_180111_170}"
	local strTips1 = ""
	local year,month,day,hour = TGM_XinShouNew_SheJiaoGetTime()
	if(1 == nIndex) then
		strTips = "#{XSJNH_180111_170}"
		strTips1 = string.format("#H%s��%s��%s��%sʱǰ�����Լ��������ҽ�Ϊ���£�������ȡ������",year,month,day,hour)
	elseif (2 == nIndex) then
		strTips = "#{XSJNH_180111_176}"
		strTips1 = string.format("#H%s��%s��%s��%sʱǰ����ֿ��������������������ȡ��ݺ���",year,month,day,hour)
	elseif (3 == nIndex) then
		strTips = "#{XSJNH_180111_182}"
		strTips1 = string.format("#H%s��%s��%s��%sʱǰ����һλ���Ϊʦ��������ȡ��ʦ����",year,month,day,hour)
	elseif (4 == nIndex) then
		strTips = "#{XSJNH_180111_188}"
		strTips1 = string.format("#H%s��%s��%s��%sʱǰ����������һλ���Ϊͽ��������ȡ��ͽ����",year,month,day,hour)
	elseif (5 == nIndex) then
		strTips = "#{XSJNH_180111_194}"
		strTips1 = string.format("#H%s��%s��%s��%sʱǰ������һ�����֮�У�������ȡ������",year,month,day,hour)
	end
	PushDebugMessage(strTips)
	PushDebugMessage(strTips1)
end
--============================================================

--=======================�°�����Я����========================================
--��ʾ����
function TGM_XinShouNew_SheJiaoNew_Show()
	TGM_XinShouNew_SheJiaoNew_Request()
	g_SheJiaoNewCurPage = 0
	g_SheJiaoNewActionCurAchieveId = 0
	TGM_XinShouNew_FreshTopButtonTips()
	TGM_XinShouNew_SheJiaoNew_SwitchPage(1)
end

function TGM_XinShouNew_SheJiaoNew_Request()
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("UpdateDataClient");
		Set_XSCRIPT_ScriptID(892753);
		Set_XSCRIPT_ParamCount(0);
	Send_XSCRIPT();
end

function TGM_XinShouNew_FreshTopButtonTips()
	for i=1,table.getn(g_SheJiaoNewPageButtons) do
		local bShowTips = 0
		for j=1,table.getn(g_SheJiaoNew_PageHasAchieves[i]) do
			
			local nAchieve = g_SheJiaoNew_PageHasAchieves[i][j]
			local bLock = TGM_XinShouNew_SheJiaoNew_EventCheck(g_SheJiaoNew_AhieveIdData[nAchieve].EventId)
			if(TGM_XinShouNew_SheJiaoNew_GetAhieveState(nAchieve) == 1 and bLock == 1) then
				bShowTips = 1
			end			
		end
		if(bShowTips == 1) then
			g_SheJiaoNewPageButtons[i].btntips:Show()
		else
			g_SheJiaoNewPageButtons[i].btntips:Hide()
		end
	end
end

function TGM_XinShouNew_SheJiaoNew_UpdateData()
    local StrData_1 = Get_XParam_STR(0)
	local StrData_2 = Get_XParam_STR(1)
	if StrData_1 == nil or StrData_1 == "" or StrData_2 == nil or StrData_2 == "" then
	    return
	end
	FinalData_1 = Split(StrData_1,",")
	FinalData_2 = Split(StrData_2,",")
	for i = 1,table.getn(FinalData_1) do
	    GetBitValueInUINT[i] = tonumber(FinalData_1[i])
	end
	for i = 1,table.getn(FinalData_2) do
	    SetBitValueInUINT[i] = tonumber(FinalData_2[i])
	end
	TGM_XinShouNew_FreshTopButtonTips()
	TGM_XinShouNew_SheJiaoNew_SwitchPage(g_SheJiaoNewCurPage)
end

function TGM_XinShouNew_SheJiaoNew_SwitchPage(nIndex)
	local nPages = table.getn(g_SheJiaoNewPages)
	if(nIndex >=1 and nIndex <= nPages)then
		for i=1,nPages do
			g_SheJiaoNewPages[i]:Hide()
		end
		g_SheJiaoNewPageButtons[nIndex].btn:SetCheck(1)
		g_SheJiaoNewPages[nIndex]:Show()
		TGM_XinShouNew_SheJiaoNew_FreshPage(nIndex)
	end
end

function TGM_XinShouNew_SheJiaoNew_FreshPage(nIndex)
	if(g_SheJiaoNewActionCurAchieveId <= 0 or g_SheJiaoNewCurPage ~= nIndex) then
		g_SheJiaoNewActionCurAchieveId = TGM_XinShouNew_SheJiaoNew_GetDefaultAhieveId(nIndex)
	end
	if(g_SheJiaoNewActionCurAchieveId == nil or g_SheJiaoNewActionCurAchieveId <= 0) then
		return
	end
	g_SheJiaoNewCurPage = nIndex
	TGM_XinShouNew_SheJiaoNew_FreshProcess()
	TGM_XinShouNew_SheJiaoNew_SwitchAcieve(g_SheJiaoNewActionCurAchieveId)
end

function TGM_XinShouNew_SheJiaoNew_GetDefaultAhieveId(nIndex)
	local nDefault1 = -1
	local nDefault2 = -1
	local nDefault3 = -1
	local nButtonMax = 7
	for i=1,table.getn(g_SheJiaoNew_PageHasAchieves[nIndex]) do
		local nAchieveId = g_SheJiaoNew_PageHasAchieves[nIndex][i]
		local nState = TGM_XinShouNew_SheJiaoNew_GetAhieveState(nAchieveId)
		local bLock = TGM_XinShouNew_SheJiaoNew_EventCheck(g_SheJiaoNew_AhieveIdData[nAchieveId].EventId)
		if(bLock == 1 and i<= nButtonMax) then
			if(nState == 0 and nDefault1 == -1) then
				nDefault1 = g_SheJiaoNew_PageHasAchieves[nIndex][i]
			end
			if(nState == 1 and nDefault2 == -1 ) then
				nDefault2 = g_SheJiaoNew_PageHasAchieves[nIndex][i]
			end
			nDefault3 = g_SheJiaoNew_PageHasAchieves[nIndex][i]
		end
	end
	if(nDefault1 ~= -1) then
		return nDefault1
	end
	if(nDefault2 ~= -1) then
		return nDefault2
	end
	if(nDefault3 ~= -1) then
		return nDefault3
	end
	return g_SheJiaoNew_PageHasAchieves[nIndex][1]
end

function TGM_XinShouNew_SheJiaoNew_FreshButtonList()
	local ButtonList = g_SheJiaoNew_PageButtonList[g_SheJiaoNewCurPage]
	if(ButtonList == nil) then
		return
	end
	for i=1,table.getn(ButtonList) do
		local nAchieveId = ButtonList[i].AchieveId
		local EventId = g_SheJiaoNew_AhieveIdData[nAchieveId].EventId
		local nRet = TGM_XinShouNew_SheJiaoNew_EventCheck(EventId)
		if(nRet == 1) then
			if(ButtonList[i].text ~= nil) then
				ButtonList[i].text:SetText(g_SheJiaoNew_AhieveIdData[nAchieveId].szNameDic)
				ButtonList[i].text:Show()
			end
			local state = TGM_XinShouNew_SheJiaoNew_GetAhieveState(nAchieveId)
			if(ButtonList[i].Tips ~= nil) then
				if(state == 1) then
					ButtonList[i].Tips:Show()
				else
					ButtonList[i].Tips:Hide()
				end
			end
			if(ButtonList[i].ToolTip ~= nil) then
				ButtonList[i].ToolTip:Hide()
			end
			if(ButtonList[i].rewardbtn ~= nil) then
				if(state == 2) then
					ButtonList[i].rewardbtn:Disable()
					ButtonList[i].rewardbtn:SetText("#{TLXS_180427_181}")
				else
					ButtonList[i].rewardbtn:Enable()
					ButtonList[i].rewardbtn:SetText("#{TLXS_180427_182}")
				end
			end
			if(ButtonList[i].btn ~= nil) then
				ButtonList[i].btn:Enable()
				if(g_SheJiaoNewActionCurAchieveId ~= nAchieveId) then
					ButtonList[i].btn:SetCheck(0)
				else
					ButtonList[i].btn:SetCheck(1)
				end
			end
			if(ButtonList[i].DisbleText ~= nil) then
				ButtonList[i].DisbleText:Hide()
			end
		else
			local szUnlock = g_SheJiaoNew_AhieveIdData[nAchieveId].unlockDic
			if(g_SheJiaoNew_AhieveIdData[nAchieveId].unlockdicparam ~= nil) then
				szUnlock = string.format(szUnlock,g_SheJiaoNew_AhieveIdData[nAchieveId].unlockdicparam)
			end
			if(ButtonList[i].text ~= nil) then
				ButtonList[i].text:SetText(szUnlock)
			end
			if(ButtonList[i].Tips ~= nil) then
				ButtonList[i].Tips:Hide()
			end
			if(ButtonList[i].btn ~= nil) then
				ButtonList[i].btn:Disable()
				ButtonList[i].btn:SetCheck(0)
			end
			if(ButtonList[i].DisbleText ~= nil) then
				ButtonList[i].DisbleText:Show()
				if(ButtonList[i].text ~= nil) then
					ButtonList[i].text:Hide()
				end
				ButtonList[i].DisbleText:SetText(g_SheJiaoNew_AhieveIdData[nAchieveId].szNameDic)
			end
			if(ButtonList[i].rewardbtn ~= nil) then
				ButtonList[i].rewardbtn:Enable()
				ButtonList[i].rewardbtn:SetText("#{TLXS_180427_182}")
			end
			if(ButtonList[i].ToolTip ~= nil) then
				ButtonList[i].ToolTip:Show()
			end
		end
	end
end

function TGM_XinShouNew_SheJiaoNew_FreshProcess()
	local ProcessList = g_SheJiaoNew_ProcessList[g_SheJiaoNewCurPage]
	if(ProcessList == nil) then
		return
	end
	local EventId = g_SheJiaoNew_ProcessList[g_SheJiaoNewCurPage].EventId
	local nCurValue = TGM_XinShouNew_SheJiaoNew_GetEventDataById(EventId)
	g_SheJiaoNew_ProcessList[g_SheJiaoNewCurPage].ValueText:SetText(string.format(ProcessList.szDesc,nCurValue))
	for i=1,table.getn(ProcessList.List) do
		local object = ProcessList.List[i]
		local RewardList = g_SheJiaoNew_AhieveIdData[object.AhieveId].RewardList
		local nNeedValue = g_SheJiaoNew_AhieveIdData[object.AhieveId].NeedValue
		if(RewardList ~= nil) then
			local theAction = GemMelting:UpdateProductAction(RewardList.Id)
			if theAction:GetID() ~= 0 then
				object.GiftAction:SetActionItem(theAction:GetID())
			end
		end
		local nState = TGM_XinShouNew_SheJiaoNew_GetAhieveState(object.AhieveId)
		if(nState == 2) then
			object.Mark:Show()
		else
			object.Mark:Hide()
		end
		if(nState == 1) then
			object.Tips:Show()
		else
			object.Tips:Hide()
		end
		object.NumText:SetText("#cfff263"..tostring(nNeedValue))
	end
end

function TGM_XinShouNew_SheJiaoNew_SwitchAcieve(AchieveID)
	local GiftActions = g_SheJiaoNew_GiftActions[g_SheJiaoNewCurPage]
	if(GiftActions == nil) then
		return
	end
	if(g_SheJiaoNew_AhieveIdData[AchieveID] == nil) then
		return
	end
	if(TGM_XinShouNew_SheJiaoNew_EventCheck(g_SheJiaoNew_AhieveIdData[AchieveID].EventId) == 0) then
		return
	end
	local RewardList = g_SheJiaoNew_AhieveIdData[AchieveID].RewardList
	if(RewardList == nil) then
		return
	end
	g_SheJiaoNewActionCurAchieveId = AchieveID
	local nAchieveData = TGM_XinShouNew_SheJiaoNew_GetEventDataById(g_SheJiaoNew_AhieveIdData[AchieveID].EventId)
	local nState = TGM_XinShouNew_SheJiaoNew_GetAhieveState(AchieveID)
	local szDebug = g_SheJiaoNew_AhieveIdData[AchieveID].Desc
	local szTitle = g_SheJiaoNew_AhieveIdData[AchieveID].szTitleName
	if(AchieveID == 4) then
		local nPos = TGM_XinShouNew_SheJiaoNew_GetEventDataById(20)
		if(g_SheJiaoNew_RandPosTips[nPos] ~= nil) then
			szDebug = string.format(szDebug,g_SheJiaoNew_RandPosTips[nPos])
		end
	end
	if(GiftActions.Title ~= nil and szTitle ~= nil) then
		GiftActions.Title:SetText(szTitle)
	end
	if(GiftActions.DescText ~= nil) then
		GiftActions.DescText:SetText(szDebug)
	end
	if(GiftActions.ValueText ~= nil) then
		local szColor = "#cff0000"
		if(AchieveID == 3) then
			nAchieveData = 100
			if(nState == 0) then
				nAchieveData = DataPool:GetPlayerMission_DataRound(281)
			end
			if(nAchieveData >= 100) then
				GiftActions.ValueText:SetText("#{TLXS_180427_183}")
			else
				GiftActions.ValueText:SetText(szColor..nAchieveData.."#cfff263".."/100")
			end
		else
			
			if(nAchieveData >= g_SheJiaoNew_AhieveIdData[AchieveID].NeedValue) then
				GiftActions.ValueText:SetText("#{TLXS_180427_183}")
			else
				GiftActions.ValueText:SetText(szColor..nAchieveData.."#cfff263".."/"..g_SheJiaoNew_AhieveIdData[AchieveID].NeedValue)
			end
		end
	end
	if(GiftActions.helpbtn ~= nil) then
		GiftActions.helpbtn:Show()
	end
	local theAction = GemMelting:UpdateProductAction(RewardList.Id)
	if theAction:GetID() ~= 0 then
		GiftActions.GiftAction:SetActionItem(theAction:GetID())
	end
	if(GiftActions.Mark ~= nil) then
		if(nState == 2) then
			GiftActions.Mark:Show()
		else
			GiftActions.Mark:Hide()
		end
	end
	local nYear,nMonth,nDay,nHour = TGM_XinShouNew_SheJiaoGetTime()
	if(GiftActions.TimeTips ~= nil) then
		GiftActions.TimeTips:SetText(string.format("#G%s��%s��%s��#cfff263ǰ�����ָ��Ŀ�꼴����ȡ��Ӧ������",nYear,nMonth,nDay))
	end
	if(GiftActions.TimeToolTips ~= nil and GiftActions.ToolTipValue ~= nil) then
		GiftActions.TimeToolTips:SetToolTip(string.format(GiftActions.ToolTipValue,nYear,nMonth,nDay))
	end
	TGM_XinShouNew_SheJiaoNew_FreshButtonList()
end
--����м��action�콱
function TGM_XinShouNew_SheJiaoNew_PageActionClick()
	TGM_XinShouNew_SheJiaoNew_ProcessActionClick(g_SheJiaoNewActionCurAchieveId)
end
--�������һ�ŵ�action�콱
function TGM_XinShouNew_SheJiaoNew_ProcessActionClick(AchieveId)
	if(AchieveId == nil or AchieveId <= 0) then
		return
	end
	if(g_SheJiaoNew_AhieveIdData[AchieveId] == nil) then
		return
	end
	--///////////////////////////
--	local curTime = FindFriendDataPool:GetTickCount();
--	if ( curTime - g_TGM_XinShouNew_ButtonLastTime < g_TGM_XinShouNew_ButtonCDTime * 1000) then
----   	    PushDebugMessage("#{ZYPT_081127_2}"); --����������������Ե�Ƭ�̺��ٵ��
----		return
--	end
	--///////////////////////////
	local state = TGM_XinShouNew_SheJiaoNew_GetAhieveState(AchieveId)
	if(state == 1) then
		--������������콱
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "GetReward" ); 	-- �ű���������
			Set_XSCRIPT_ScriptID( 892753 );				-- �ű����
			Set_XSCRIPT_Parameter( 0, AchieveId );		-- ����һ
			Set_XSCRIPT_ParamCount( 1 );				-- ��������
		Send_XSCRIPT()
		return
	elseif(state == 0) then
		local szTips = g_SheJiaoNew_AhieveIdData[AchieveId].szUnReward
		PushDebugMessage(szTips)
	elseif(state == 2) then
		PushDebugMessage("#{TLXS_180427_51}")
	end
end

function TGM_XinShouNew_SheJiaoNew_HelpClick(nIndex)
	if(nIndex == 1)then
	    OpenYBShopReference("#{TLXS_180427_160}")
	else
		OpenYBShopReference("#{TLXS_180427_179}")
	end
end

function TGM_XinShouNew_SheJiaoNew_Init()
	g_SheJiaoNewPages[1] = TGM_XinShouNew_SheJiaoFrame_Page1
	g_SheJiaoNewPages[2] = TGM_XinShouNew_SheJiaoFrame_Page2
	g_SheJiaoNewPages[3] = TGM_XinShouNew_SheJiaoFrame_Page3
	g_SheJiaoNewPages[4] = TGM_XinShouNew_SheJiaoFrame_Page4
	g_SheJiaoNewPages[5] = TGM_XinShouNew_SheJiaoFrame_Page5
	
	g_SheJiaoNewPageButtons[1] = {btn=TGM_XinShouNew_SheJiaoFrame_Button01,btntips=TGM_XinShouNew_SheJiaoFrame_Button01tips}
	g_SheJiaoNewPageButtons[2] = {btn=TGM_XinShouNew_SheJiaoFrame_Button02,btntips=TGM_XinShouNew_SheJiaoFrame_Button02tips}
	g_SheJiaoNewPageButtons[3] = {btn=TGM_XinShouNew_SheJiaoFrame_Button03,btntips=TGM_XinShouNew_SheJiaoFrame_Button03tips}
	g_SheJiaoNewPageButtons[4] = {btn=TGM_XinShouNew_SheJiaoFrame_Button04,btntips=TGM_XinShouNew_SheJiaoFrame_Button04tips}
	g_SheJiaoNewPageButtons[5] = {btn=TGM_XinShouNew_SheJiaoFrame_Button05,btntips=TGM_XinShouNew_SheJiaoFrame_Button05tips}
	
	g_SheJiaoNew_GiftActions[1] = {TimeTips=TGM_XinShouNew_SheJiaoFrame_Page1_EveryMissionInfo2,Mark=TGM_XinShouNew_SheJiaoFrame_Page1_MissionGiftMark,GiftAction = TGM_XinShouNew_SheJiaoFrame_Page1_MissionGift,Title=TGM_XinShouNew_SheJiaoFrame_Page1_EveryMissionText,DescText = TGM_XinShouNew_SheJiaoFrame_Page1_EveryMissionInfo,ValueText=TGM_XinShouNew_SheJiaoFrame_Page1_EveryMissionTimes,helpbtn=TGM_XinShouNew_SheJiaoFrame_Page1_EveryMission_Help}
	g_SheJiaoNew_GiftActions[2] = {TimeTips=TGM_XinShouNew_SheJiaoFrame_Page2_EveryMissionInfo2,Mark=TGM_XinShouNew_SheJiaoFrame_Page2_EveryMissionGiftMark,GiftAction = TGM_XinShouNew_SheJiaoFrame_Page2_EveryMissionGift,Title=TGM_XinShouNew_SheJiaoFrame_Page2_EveryMissionText,DescText = TGM_XinShouNew_SheJiaoFrame_Page2_EveryMissionInfo,ValueText=TGM_XinShouNew_SheJiaoFrame_Page2_EveryMissionTimes,helpbtn=TGM_XinShouNew_SheJiaoFrame_Page2_EveryMission_Help,}
	g_SheJiaoNew_GiftActions[3] = {TimeToolTips=TGM_XinShouNew_SheJiaoFrame_Page3_EveryMissionButton,ToolTipValue="#G%s#Y��#G%s#Y��#G%s#Y��#Yǰ�ڡ��������˲����Ľ���֮�У���ֿ��������������������ȡһ�����ּ��껪ר����ݺ��񣬿ɻ��#G��Ѫ���嵤#Y��",GiftAction = TGM_XinShouNew_SheJiaoFrame_Page3_EveryMissionGift}
	g_SheJiaoNew_GiftActions[4] = {TimeToolTips=TGM_XinShouNew_SheJiaoFrame_Page4_EveryMissionButton,ToolTipValue="#G%s#Y��#G%s#Y��#G%s#Y��#Y�ڡ��������˲����Ľ���֮�У�Ѱ��һλ�ذ��Լ�����ʦ�����������£�������ȡһ�����ּ��껪ר����ʦ���񣬿ɻ��#G�𵤺�«#Y��#G��Һ��ƿ#Y��",GiftAction = TGM_XinShouNew_SheJiaoFrame_Page4_EveryMissionGift}
	g_SheJiaoNew_GiftActions[5] = {TimeToolTips=TGM_XinShouNew_SheJiaoFrame_Page5_EveryMissionButton,ToolTipValue="#G%s#Y��#G%s#Y��#G%s#Y��#Y�ڡ��������˲����Ľ���֮�У��ٵ�һλ�ϻ۸�ͽ���������£�������ȡһ�����ּ��껪ר����ͽ���񣬿ɻ��#Gʦ�µ���#Y��ʹ�ú�ɻ��ʦ�£�",GiftAction = TGM_XinShouNew_SheJiaoFrame_Page5_EveryMissionGift}

	g_SheJiaoNew_PageButtonList[1] = {
										[1] = {btn=TGM_XinShouNew_SheJiaoFrame_Page1_Mission1,ToolTip=TGM_XinShouNew_SheJiaoFrame_Page1_Mission1Warning,Tips=TGM_XinShouNew_SheJiaoFrame_Page1_Mission1tips,text=TGM_XinShouNew_SheJiaoFrame_Page1_Mission1Text,AchieveId=1,DisbleText=TGM_XinShouNew_SheJiaoFrame_Page1_Mission1Text2,},
										[2] = {btn=TGM_XinShouNew_SheJiaoFrame_Page1_Mission2,ToolTip=TGM_XinShouNew_SheJiaoFrame_Page1_Mission2Warning,Tips=TGM_XinShouNew_SheJiaoFrame_Page1_Mission2tips,text=TGM_XinShouNew_SheJiaoFrame_Page1_Mission2Text,AchieveId=2,DisbleText=TGM_XinShouNew_SheJiaoFrame_Page1_Mission2Text2,},
										[3] = {btn=TGM_XinShouNew_SheJiaoFrame_Page1_Mission3,ToolTip=TGM_XinShouNew_SheJiaoFrame_Page1_Mission3Warning,Tips=TGM_XinShouNew_SheJiaoFrame_Page1_Mission3tips,text=TGM_XinShouNew_SheJiaoFrame_Page1_Mission3Text,AchieveId=3,DisbleText=TGM_XinShouNew_SheJiaoFrame_Page1_Mission3Text2,},
										[4] = {btn=TGM_XinShouNew_SheJiaoFrame_Page1_Mission4,ToolTip=TGM_XinShouNew_SheJiaoFrame_Page1_Mission4Warning,Tips=TGM_XinShouNew_SheJiaoFrame_Page1_Mission4tips,text=TGM_XinShouNew_SheJiaoFrame_Page1_Mission4Text,AchieveId=4,DisbleText=TGM_XinShouNew_SheJiaoFrame_Page1_Mission4Text2,},
										[5] = {btn=TGM_XinShouNew_SheJiaoFrame_Page1_Mission5,ToolTip=TGM_XinShouNew_SheJiaoFrame_Page1_Mission5Warning,Tips=TGM_XinShouNew_SheJiaoFrame_Page1_Mission5tips,text=TGM_XinShouNew_SheJiaoFrame_Page1_Mission5Text,AchieveId=5,DisbleText=TGM_XinShouNew_SheJiaoFrame_Page1_Mission5Text2,},
										[6] = {btn=TGM_XinShouNew_SheJiaoFrame_Page1_Mission6,ToolTip=TGM_XinShouNew_SheJiaoFrame_Page1_Mission6Warning,Tips=TGM_XinShouNew_SheJiaoFrame_Page1_Mission6tips,text=TGM_XinShouNew_SheJiaoFrame_Page1_Mission6Text,AchieveId=6,DisbleText=TGM_XinShouNew_SheJiaoFrame_Page1_Mission6Text2,},
										[7] = {btn=TGM_XinShouNew_SheJiaoFrame_Page1_Mission7,ToolTip=TGM_XinShouNew_SheJiaoFrame_Page1_Mission7Warning,Tips=TGM_XinShouNew_SheJiaoFrame_Page1_Mission7tips,text=TGM_XinShouNew_SheJiaoFrame_Page1_Mission7Text,AchieveId=7,DisbleText=TGM_XinShouNew_SheJiaoFrame_Page1_Mission7Text2,},
									 }
	g_SheJiaoNew_PageButtonList[2] = {
										[1] = {btn=TGM_XinShouNew_SheJiaoFrame_Page2_Mission1,ToolTip=TGM_XinShouNew_SheJiaoFrame_Page2_Mission1Warning,Tips=TGM_XinShouNew_SheJiaoFrame_Page2_Mission1tips,text=TGM_XinShouNew_SheJiaoFrame_Page2_Mission1Text,AchieveId=11},
										[2] = {btn=TGM_XinShouNew_SheJiaoFrame_Page2_Mission2,ToolTip=TGM_XinShouNew_SheJiaoFrame_Page2_Mission2Warning,Tips=TGM_XinShouNew_SheJiaoFrame_Page2_Mission2tips,text=TGM_XinShouNew_SheJiaoFrame_Page2_Mission2Text,AchieveId=12},
										[3] = {btn=TGM_XinShouNew_SheJiaoFrame_Page2_Mission3,ToolTip=TGM_XinShouNew_SheJiaoFrame_Page2_Mission3Warning,Tips=TGM_XinShouNew_SheJiaoFrame_Page2_Mission3tips,text=TGM_XinShouNew_SheJiaoFrame_Page2_Mission3Text,AchieveId=13},
										[4] = {btn=TGM_XinShouNew_SheJiaoFrame_Page2_Mission4,ToolTip=TGM_XinShouNew_SheJiaoFrame_Page2_Mission4Warning,Tips=TGM_XinShouNew_SheJiaoFrame_Page2_Mission4tips,text=TGM_XinShouNew_SheJiaoFrame_Page2_Mission4Text,AchieveId=14},
										[5] = {btn=TGM_XinShouNew_SheJiaoFrame_Page2_Mission5,ToolTip=TGM_XinShouNew_SheJiaoFrame_Page2_Mission5Warning,Tips=TGM_XinShouNew_SheJiaoFrame_Page2_Mission5tips,text=TGM_XinShouNew_SheJiaoFrame_Page2_Mission5Text,AchieveId=15},
										[6] = {btn=TGM_XinShouNew_SheJiaoFrame_Page2_Mission6,ToolTip=TGM_XinShouNew_SheJiaoFrame_Page2_Mission6Warning,Tips=TGM_XinShouNew_SheJiaoFrame_Page2_Mission6tips,text=TGM_XinShouNew_SheJiaoFrame_Page2_Mission6Text,AchieveId=16},
										[7] = {btn=TGM_XinShouNew_SheJiaoFrame_Page2_Mission7,ToolTip=TGM_XinShouNew_SheJiaoFrame_Page2_Mission7Warning,Tips=TGM_XinShouNew_SheJiaoFrame_Page2_Mission7tips,text=TGM_XinShouNew_SheJiaoFrame_Page2_Mission7Text,AchieveId=17},
									 }
	g_SheJiaoNew_PageButtonList[3] = {
										[1] = {rewardbtn=TGM_XinShouNew_SheJiaoFrame_Page3_EveryMissionButton,AchieveId=22},
									 }
	g_SheJiaoNew_PageButtonList[4] = {
										[1] = {rewardbtn=TGM_XinShouNew_SheJiaoFrame_Page4_EveryMissionButton,AchieveId=23},
									 }
	g_SheJiaoNew_PageButtonList[5] = {
										[1] = {rewardbtn=TGM_XinShouNew_SheJiaoFrame_Page5_EveryMissionButton,AchieveId=24},
									 }
	
	
	g_SheJiaoNew_ProcessList[1] = {ValueText = TGM_XinShouNew_SheJiaoFrame_Page1_TotalNumber,EventId = 8,szDesc="#cfff263���ۼƣ�#G%s#c6a3906",
									List={
									[1] = {AhieveId=8,GiftAction=TGM_XinShouNew_SheJiaoFrame_Page1_Gift1,Mark=TGM_XinShouNew_SheJiaoFrame_Page1_Gift1Mark,NumText=TGM_XinShouNew_SheJiaoFrame_Page1_Number1,Tips=TGM_XinShouNew_SheJiaoFrame_Page1_Gift1tips,},
									[2] = {AhieveId=9,GiftAction=TGM_XinShouNew_SheJiaoFrame_Page1_Gift2,Mark=TGM_XinShouNew_SheJiaoFrame_Page1_Gift2Mark,NumText=TGM_XinShouNew_SheJiaoFrame_Page1_Number2,Tips=TGM_XinShouNew_SheJiaoFrame_Page1_Gift2tips,},
									[3] = {AhieveId=10,GiftAction=TGM_XinShouNew_SheJiaoFrame_Page1_Gift3,Mark=TGM_XinShouNew_SheJiaoFrame_Page1_Gift3Mark,NumText=TGM_XinShouNew_SheJiaoFrame_Page1_Number3,Tips=TGM_XinShouNew_SheJiaoFrame_Page1_Gift3tips,},
										 }
								  }
	g_SheJiaoNew_ProcessList[2] = {ValueText = TGM_XinShouNew_SheJiaoFrame_Page2_TotalNumber,EventId = 16,szDesc="#cfff263���ۼƣ�#G%s#cfff263",
									List={
									[1] = {AhieveId=18,GiftAction=TGM_XinShouNew_SheJiaoFrame_Page2_Gift1,Mark=TGM_XinShouNew_SheJiaoFrame_Page2_Gift1Mark,NumText=TGM_XinShouNew_SheJiaoFrame_Page2_Number1,Tips=TGM_XinShouNew_SheJiaoFrame_Page2_Gift1tips,},
									[2] = {AhieveId=19,GiftAction=TGM_XinShouNew_SheJiaoFrame_Page2_Gift2,Mark=TGM_XinShouNew_SheJiaoFrame_Page2_Gift2Mark,NumText=TGM_XinShouNew_SheJiaoFrame_Page2_Number2,Tips=TGM_XinShouNew_SheJiaoFrame_Page2_Gift2tips,},
									[3] = {AhieveId=20,GiftAction=TGM_XinShouNew_SheJiaoFrame_Page2_Gift3,Mark=TGM_XinShouNew_SheJiaoFrame_Page2_Gift3Mark,NumText=TGM_XinShouNew_SheJiaoFrame_Page2_Number3,Tips=TGM_XinShouNew_SheJiaoFrame_Page2_Gift3tips,},
									[4] = {AhieveId=21,GiftAction=TGM_XinShouNew_SheJiaoFrame_Page2_Gift4,Mark=TGM_XinShouNew_SheJiaoFrame_Page2_Gift4Mark,NumText=TGM_XinShouNew_SheJiaoFrame_Page2_Number4,Tips=TGM_XinShouNew_SheJiaoFrame_Page2_Gift4tips,},
										 }
								  }
end
--����¼��Ƿ����0 δ���� 1����
function TGM_XinShouNew_SheJiaoNew_EventCheck(EventId)
	--����ֱ�ӿ��ţ�����һ����Ľ�����û��Ҫ
	--����¼���һ�����һ��
--	if(EventId >=2 and EventId <= 7) then
--		local UnLockDay = TGM_XinShouNew_SheJiaoNew_GetEventDataById(g_SheJiaoNew_MarryUnkLockDayBit)
--		if(UnLockDay + 1 < EventId) then
--			return 0
--		end
--	end
	-- if(EventId >=1 and EventId <= 8) then
		-- local nRet,_guid = Friend:Lua_GetSpouseGuid()
		-- if(nRet == 0) then
			-- return 2
		-- end
	-- end
	--������ǰһ��������ܽ�����һ��
--	if(EventId >= 10 and EventId <= 15) then
--		local LastEvent = EventId - 1
--		local nValue = TGM_XinShouNew_SheJiaoNew_GetEventDataById(LastEvent)
--		if(nValue < g_SheJiaoNew_EventId2Data[LastEvent].MaxValue) then
--			return 0
--		end
--	end
	-- if(EventId >= 10 and EventId <= 16) then
		-- local guildID, clanID = DataPool:GetGuildClanID()
		-- if(guildID < 0) then
			-- return 2
		-- end
	-- end
	return 1
end
--��ȡ�ɾ͵�״̬ 0δ��� 1����� 2���콱
function TGM_XinShouNew_SheJiaoNew_GetAhieveState(AhieveId)
	local EventId = g_SheJiaoNew_AhieveIdData[AhieveId].EventId
	if(EventId == nil) then
		return 0
	end

	local nCur = TGM_XinShouNew_SheJiaoNew_GetEventDataById(EventId)
	if(nCur >= g_SheJiaoNew_AhieveIdData[AhieveId].NeedValue) then
		if(TGM_XinShouNew_SheJiaoNew_RewardBitGet(AhieveId) == 1) then
			return 2
		end
		return 1
	end
	return 0
end

--�����¼�ID�������¼�������
function TGM_XinShouNew_SheJiaoNew_GetEventDataById(nId)
	if(nId == nil or g_SheJiaoNew_EventId2Data[nId] == nil) then
		return
	end
	local nStart = g_SheJiaoNew_EventId2Data[nId].Start
	local nLen = g_SheJiaoNew_EventId2Data[nId].Len
	return SetBitValueInUINT[nId]
end

--������ȡ��־λ��ȡ����
function TGM_XinShouNew_SheJiaoNew_RewardBitGet(nBit)
	if(nBit < 1 or nBit > 31) then
		return 0
	end
	local state = GetBitValueInUINT[nBit]--GetBitValueInUINT(Data,nBit,1)
	return state
end

--=============================================================================

function TGM_XinShouNew_OnCheckMe()
	if g_lastDay == -1 or  g_lastMaiDian == -1 then
		return
	end

--	local nHaoXiaIndex = Lua_GetHaoXiaIndexChange(g_lastDay,g_lastMaiDian);
--	local viewPos = 0;
--
--	for i,v in ipairs(g_nContentButton) do
--
--		if (i-1) == nHaoXiaIndex then
--			v:SetBarButtonSelected(true)
--			viewPos = i - 1
--		else
--			v:SetBarButtonSelected(false)
--		end
--	end
--	TGM_XinShouNew_Heroes_RoadList:SetVertScrollbarPosition(80.0*viewPos)
--	g_lastDay = -1
--	g_lastMaiDian = -1
end

function TGM_XinShouNew_OnCheckRed(nDayGap)
--	for idx=0,6 do
--		if idx > (nDayGap - 1) then
--			continue;
--		end
--		local bCheckRed = 0	
--		local Num = Lua_GetMaiDianNumByDay(idx)
--		for i = 0,Num-1 do
--			local MaiDianValue = 0
--
--			local BounsFlag = 0
--			local nChangeIndex = Lua_GetHaoXiaIndex(idx,i)
--			BounsFlag = DataPool:Lua_GetHaoXiaRoadFlag(idx,nChangeIndex)
--			local Desc,TargetNum,BounsNum,Isspecial,Image1,Image2,nType,param0,param1,param2 = Lua_GetXinShouHeroesRoadInfo(idx,nChangeIndex)
--
--			if Isspecial == 0 then
--				MaiDianValue = DataPool:Lua_GetHaoXiaRoad(idx,nChangeIndex)
--			elseif Isspecial == 1 then
--				MaiDianValue = Player:GetData("EQUIPSCOREHH");
--			end
--
--			if MaiDianValue < TargetNum then
--			elseif BounsFlag == 0 then
--				bCheckRed = 1
--			elseif BounsFlag == 1 then
--			end
--
--		end	
--		
--		local ii = idx+1
--		if bCheckRed == 1 then
--			g_HaoXialuRed[ii]:Show()
--		else
--			g_HaoXialuRed[ii]:Hide()
--		end	
--	end
--
end