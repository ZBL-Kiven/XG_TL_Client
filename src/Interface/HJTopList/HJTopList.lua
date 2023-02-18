
local g_HJTopList_Frame_UnifiedPosition = nil


local g_HJTopList_ItemData = {}

local g_HJTopList_MyInfo = {}

local g_HJTopList_guildpicture = {}
local g_HJTopList_BtnIndex = 1--Ĭ��ѡ���±�
local g_HJTopList_Column = {}
local g_HJTopList_Fenye = {}
--���ֺ�RANKING_LIST_TYPEһ��
local nHJTopListPage = 1
local g_HJTopList_MenPaiImage =
{
	[0]   	= "set:HJ_MenPaiLogo02 image:HJ_PatternIconShaolin_Normal", 	--����
	[1] 	= "set:HJ_MenPaiLogo02 image:HJ_PatternIconMingjiao_Normal", 	--����
	[2]		= "set:HJ_MenPaiLogo02 image:HJ_PatternIconGaibang_Normal", 	--ؤ��
	[3]		= "set:HJ_MenPaiLogo02 image:HJ_PatternIconWudang_Normal",		--�䵱
	[4]		= "set:HJ_MenPaiLogo02 image:HJ_PatternIconEmei_Normal",		--��ü
	[5]		= "set:HJ_MenPaiLogo02 image:HJ_PatternIconXingsu_Normal",		--����
	[6]		= "set:HJ_MenPaiLogo02 image:HJ_PatternIconTianlong_Normal",	--����
	[7]		= "set:HJ_MenPaiLogo02 image:HJ_PatternIconTianshan_Normal",	--��ɽ
	[8]		= "set:HJ_MenPaiLogo02 image:HJ_PatternIconXiaoyao_Normal",		--��ң
	[9]		= "",															--������
}

local g_HJTopList_Image = {
[1] = {}

}
				
local g_HJTopList_Type =
{
	TOPLIST_LEVEL = 0,
	TOPLIST_SCORE = 1,
	TOPLIST_GUILD_SCORE = 2,
	TOPLIST_GUILD_ACTIVITY = 3,
	TOPLIST_PAOSHANG = 4,
	TOPLIST_LEVEL_EMEI = 5,				--//��ü�ȼ���
	TOPLIST_LEVEL_MINGJIAO = 6,			--//���̵ȼ���
	TOPLIST_LEVEL_TIANSHAN = 7,			--//��ɽ�ȼ���
	TOPLIST_LEVEL_XIAOYAO  = 8,			--//��ң�ȼ���
	TOPLIST_LEVEL_WUDANG   = 9,			--//�䵱�ȼ���
	TOPLIST_LEVEL_GAIBANG  = 10,			--//ؤ��ȼ���
	TOPLIST_GAIBANG_SCORE_TOTAL =11,			--//ؤ���ܰ�
	TOPLIST_GAIBANG_SCORE_STATE1 = 12,			--//ؤ��1��
	TOPLIST_GAIBANG_SCORE_STATE2 = 13,			--//ؤ��2��
	TOPLIST_GAIBANG_SCORE_STATE3 = 14,			--//ؤ��3��
	TOPLIST_EMEI_SCORE_TOTAL = 15,			--//��ü�ܰ�
	TOPLIST_EMEI_SCORE_STATE1 = 16,			--//��ü1��
	TOPLIST_EMEI_SCORE_STATE2 = 17,			--//��ü2��
	TOPLIST_EMEI_SCORE_STATE3 = 18,			--//��ü3��
	TOPLIST_TIANSHAN_SCORE_TOTAL = 19,		--//��ɽ�ܰ�
	TOPLIST_TIANSHAN_SCORE_STATE1 = 20,		--//��ɽ1��
	TOPLIST_TIANSHAN_SCORE_STATE2 = 21,		--//��ɽ2��
	TOPLIST_TIANSHAN_SCORE_STATE3 = 22,		--//��ɽ3��
	TOPLIST_XIAOYAO_SCORE_TOTAL = 23,		--//��ɽ�ܰ�
	TOPLIST_XIAOYAO_SCORE_STATE1 = 24,		--//��ң1��
	TOPLIST_XIAOYAO_SCORE_STATE2 = 25,		--//��ң2��
	TOPLIST_XIAOYAO_SCORE_STATE3 = 26,		--//��ң3��
	TOPLIST_WUDANG_SCORE_TOTAL = 27,		--//�䵱�ܰ�
	TOPLIST_WUDANG_SCORE_STATE1 = 28,		--//�䵱1��
	TOPLIST_WUDANG_SCORE_STATE2 = 29,		--//�䵱2��
	TOPLIST_WUDANG_SCORE_STATE3 = 30,		--//�䵱3��
	TOPLIST_MINGJIAO_SCORE_TOTAL = 31,		--//�����ܰ�
	TOPLIST_MINGJIAO_SCORE_STATE1 = 32,		--//����1��
	TOPLIST_MINGJIAO_SCORE_STATE2 = 33,		--//����2��
	TOPLIST_MINGJIAO_SCORE_STATE3 = 34,		--//����3��
	TOPLIST_BATTLESCORE_STATE1 = 35,	--//ս�����ܰ�1��
	TOPLIST_BATTLESCORE_STATE2 = 36,	--//ս�����ܰ�2��
	TOPLIST_BATTLESCORE_STATE3 = 37,	--//ս�����ܰ�3��	
	TOPLIST_SHILIAN_TOTAL = 38,				--//Ӣ�������ܰ�
	TOPLIST_GAIBANG_SHILIAN_TOTAL = 39,			--//ؤ���ܰ�
	TOPLIST_EMEI_SHILIAN_TOTAL = 40,			--//��ü�ܰ�
	TOPLIST_TIANSHAN_SHILIAN_TOTAL = 41,		--//��ɽ�ܰ�
	TOPLIST_XIAOYAO_SHILIAN_TOTAL = 42,		--//��ң�ܰ�	
	TOPLIST_WUDANG_SHILIAN_TOTAL = 43,		--//�䵱�ܰ�
	TOPLIST_MINGJIAO_SHILIAN_TOTAL = 44,		--//�����ܰ�
	TOPLIST_EXAM_WEEK0 = 45,				--�ƾ�
	TOPLIST_EXAM_WEEK1 = 46,
	TOPLIST_EXAM_WEEK2 = 47,
	TOPLIST_EXAM_WEEK3 = 48,
	TOPLIST_EXAM_WEEK4 = 49,
	TOPLIST_EXAM_WEEK5 = 50,
	TOPLIST_EXAM_WEEK6 = 51,	
	TOPLIST_EXAM_FINAL = 52,				--����
	TOPLIST_MENPAICHUANGGUAN = 53,			--���ɴ���
	TOPLIST_CANGJINGGE = 54,				--�ؾ���
	TOPLIST_FENGHUANGLINGMU = 55,			--�����Ĺ
	TOPLIST_MANHANQUANXI=56,				--����ȫϯ

	
}

local g_HJTopList_NPCOpen = 
{
	{type = g_HJTopList_Type.TOPLIST_EXAM_WEEK0, frame=3},
	{type = g_HJTopList_Type.TOPLIST_EXAM_WEEK1, frame=3},
	{type = g_HJTopList_Type.TOPLIST_EXAM_WEEK2, frame=3},
	{type = g_HJTopList_Type.TOPLIST_EXAM_WEEK3, frame=3},
	{type = g_HJTopList_Type.TOPLIST_EXAM_WEEK4, frame=3},
	{type = g_HJTopList_Type.TOPLIST_EXAM_WEEK5, frame=3},
	{type = g_HJTopList_Type.TOPLIST_EXAM_WEEK6, frame=3},
	{type = g_HJTopList_Type.TOPLIST_EXAM_FINAL, frame=3},
	{type = g_HJTopList_Type.TOPLIST_EMEI_SCORE_TOTAL, frame=1},
	{type = g_HJTopList_Type.TOPLIST_MINGJIAO_SCORE_TOTAL, frame=1},
	{type = g_HJTopList_Type.TOPLIST_TIANSHAN_SCORE_TOTAL, frame=1},
	{type = g_HJTopList_Type.TOPLIST_XIAOYAO_SCORE_TOTAL, frame=1},
	{type = g_HJTopList_Type.TOPLIST_WUDANG_SCORE_TOTAL, frame=1},
	{type = g_HJTopList_Type.TOPLIST_GAIBANG_SCORE_TOTAL, frame=1},


}

local g_HJTopList_nosave =
{
	RANKINGLIST_NS_DASHIXIONG_EMEI = 100001,
	RANKINGLIST_NS_DASHIXIONG_MINGJIAO = 100002,
	RANKINGLIST_NS_DASHIXIONG_TIANSHAN = 100003,
	RANKINGLIST_NS_DASHIXIONG_XIAOYAO = 100004,
	RANKINGLIST_NS_DASHIXIONG_WUDANG = 100005,
	RANKINGLIST_NS_DASHIXIONG_GAIBANG = 100006,
	RANKINGLIST_NS_HUASHAN_GROUP1 = 100101,
	RANKINGLIST_NS_HUASHAN_GROUP2 = 100102,
	RANKINGLIST_NS_HUASHAN_GROUP3 = 100103,
}


local g_HJTopList_Btn2_list = 
{
	[1] = {g_HJTopList_Type.TOPLIST_EXAM_WEEK0},
	[2] = {g_HJTopList_Type.TOPLIST_EXAM_WEEK1},
	[3] = {g_HJTopList_Type.TOPLIST_EXAM_WEEK2},
	[4] = {g_HJTopList_Type.TOPLIST_EXAM_WEEK3},
	[5] = {g_HJTopList_Type.TOPLIST_EXAM_WEEK4},
	[6] = {g_HJTopList_Type.TOPLIST_EXAM_WEEK5},
	[7] = {g_HJTopList_Type.TOPLIST_EXAM_WEEK6},
}

local g_HJTopList_ColumnName = 
{
	"#{PHBD_180311_01}",	--1
	"#{PHBD_180311_02}",
	"#{PHBD_180311_04}",
	"#{PHBD_180311_05}",
	"#{PHBD_180311_18}",	--5
	"#{PHBD_180311_03}",
	"#{PHBD_180311_09}",
	"#{PHBD_180311_11}",
	"#{PHBD_180311_12}",
	"#{PHBD_180311_10}",	--10
	"#{PHBD_180311_13}",
	"#{PHBD_180311_69}",
	"#{PHBD_180311_68}",
	"#{PHBD_180311_93}",
	"#{PHBD_180311_94}",	--15
	"#{PHBD_180311_114}",	--��ʱ
	"#{PHBD_180311_115}",	--����
	"��Ʊ��",
	"#{PHBD_180311_110}",
	"#{MHQX_191212_95}",	--20
	"#{CJGN_191210_123}",
	"#{CJGN_191210_112}",
	"#{CJGN_191210_115}",
	"#{MHQX_191212_100}",
	"#{PHBD_180311_123}",	--25
	"#{PHBD_180311_126}",
	"#{PHBD_180311_128}",
	"#{HSPH_191120_12}",
	"#{HSPH_191120_13}",
	"#{HSPH_191120_15}",	--30
	"#{HSPH_191120_16}",
	"#W�۽���λ",

	
}
--
-- ������İ�ť����
-- Ҫ��[i][j] ������j��һ��
local g_HJTopList_SubIndex = 
{
	[1] = {g_HJTopList_Type.TOPLIST_SCORE,
			g_HJTopList_Type.TOPLIST_GAIBANG_SCORE_TOTAL,
			g_HJTopList_Type.TOPLIST_EMEI_SCORE_TOTAL,
			g_HJTopList_Type.TOPLIST_TIANSHAN_SCORE_TOTAL,
			g_HJTopList_Type.TOPLIST_XIAOYAO_SCORE_TOTAL,
			g_HJTopList_Type.TOPLIST_WUDANG_SCORE_TOTAL,
			g_HJTopList_Type.TOPLIST_MINGJIAO_SCORE_TOTAL,
		},
	[2] = {
			g_HJTopList_Type.TOPLIST_BATTLESCORE_STATE1,
			g_HJTopList_Type.TOPLIST_GAIBANG_SCORE_STATE1,
			g_HJTopList_Type.TOPLIST_EMEI_SCORE_STATE1,
			g_HJTopList_Type.TOPLIST_TIANSHAN_SCORE_STATE1,
			g_HJTopList_Type.TOPLIST_XIAOYAO_SCORE_STATE1,
			g_HJTopList_Type.TOPLIST_WUDANG_SCORE_STATE1,
			g_HJTopList_Type.TOPLIST_MINGJIAO_SCORE_STATE1,
		},
	[3] = {
			g_HJTopList_Type.TOPLIST_BATTLESCORE_STATE2,
			g_HJTopList_Type.TOPLIST_GAIBANG_SCORE_STATE2,
			g_HJTopList_Type.TOPLIST_EMEI_SCORE_STATE2,
			g_HJTopList_Type.TOPLIST_TIANSHAN_SCORE_STATE2,
			g_HJTopList_Type.TOPLIST_XIAOYAO_SCORE_STATE2,
			g_HJTopList_Type.TOPLIST_WUDANG_SCORE_STATE2,
			g_HJTopList_Type.TOPLIST_MINGJIAO_SCORE_STATE2,
		},		
		
	[4] = {
			g_HJTopList_Type.TOPLIST_BATTLESCORE_STATE3,
			g_HJTopList_Type.TOPLIST_GAIBANG_SCORE_STATE3,
			g_HJTopList_Type.TOPLIST_EMEI_SCORE_STATE3,
			g_HJTopList_Type.TOPLIST_TIANSHAN_SCORE_STATE3,
			g_HJTopList_Type.TOPLIST_XIAOYAO_SCORE_STATE3,
			g_HJTopList_Type.TOPLIST_WUDANG_SCORE_STATE3,
			g_HJTopList_Type.TOPLIST_MINGJIAO_SCORE_STATE3,
			g_HJTopList_Type.TOPLIST_SHILIAN_STATE3,		
		}

			
		
}
local g_HJTopList_ColumnType =
{
	HCLevelType = 1,
	HCScoreType = 2,
	HCGuildScore = 3,
	HCGuildActivity = 4,
	HCShilianType = 5,
	HCXiangshi = 6,
	HCDianshi = 7,
	HCDashixiong = 8,
	HCMenpaiChallenge = 9,
	HCCangjingge = 10,
	HCHuaShan = 11,
}

local g_Top_Info = {}


local g_huodong = {}

local g_SubIndexButton = {}
local g_SubXiangShiButton = {}
local g_Standard_First_ratio = 0.1
local g_Standard_Second_ratio = 0.2
local g_Standard_Third_ratio = 0.12
local g_Standard_Forth_ratio = 0.29
local g_Standard_Fifth_ratio = 0.29

local g_CurSelectType = -1
local g_CurSelectItem = -1

local g_Standard_ratio = {}
local g_HJTopList_Info ={}
local g_RankListRenwu = {}
local g_RankListBanghui = {}

local g_zhandouli = {}
local g_yixiongshilian ={}
local g_dengji = {}
local g_keju = {}
local g_dianshi = {}
local g_dashixiong = {}
local g_HJTopList_huashan = {}
local g_HJTopList_AllType = {}

local g_HJTopList_DuanWei1 = {
	[1] = "�Խ���",
	[2] = "������",
	[3] = "������",
	[4] = "������",
	[5] = "�⽣��",
	[6] = "#{HSSC_191009_42}",
}
local g_HJTopList_DuanWei2 = {
	[1] = "#{HSLJ_190919_154}",
	[2] = "#{HSLJ_190919_153}",
	[3] = "#{HSLJ_190919_152}",
	[4] = "#{HSLJ_190919_151}",
	[5] = "#{HSLJ_190919_150}",
}

local MenPaiName = {"����","����","ؤ��","�䵱","����","����","����","��ɽ","��ң","������"}
local nHJTopListData = {}


function HJTopList_FormatHuaShanStr(nDuanwei,nDuanwei1,nStar)
	local str = ""
	if nDuanwei >=1 and nDuanwei <=5 then
		str = g_HJTopList_DuanWei1[nDuanwei]..g_HJTopList_DuanWei2[nDuanwei1].."#{HSPH_191120_53}"..nStar.."#{HSPH_191120_30}"
	elseif nDuanwei == 6 then
		str = g_HJTopList_DuanWei1[nDuanwei].."#{HSPH_191120_53}"..nStar.."#{HSPH_191120_30}"
	end
	return str
end


function HJTopList_PreLoad()

	this:RegisterEvent("OPEN_TOPLIST",true)
	-- ��Ϸ���ڳߴ緢���˱仯
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- ��Ϸ�ֱ��ʷ����˱仯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	this:RegisterEvent("RECIVE_RANKINGLIST_DATA",true)
	this:RegisterEvent("COMMON_LIST_RIGHT_CLICK",false)
	this:RegisterEvent("BWTROOP_UPDATE_COMMONRANKING",true)
	this:RegisterEvent("UI_COMMAND");
end

-- HJTopList_Close => HJTLBB_ButtonClose
-- HJTopList_TitleBK => HJTLBB_TitleLaceBK
-- HJTopList_Title => TLBB_DragTitle
-- HJTopList_Client => DefaultWindow
function HJTopList_OnLoad()
	g_HJTopList_Frame_UnifiedPosition = HJTopList_Frame:GetProperty("UnifiedPosition");


	g_Top_Info[1] = { Image = HJTopList_RightContent_Top1_Image,
						MenpaiBK = HJTopList_MenPai1_BK,
						Menpai = HJTopList_MenPai1,
						Text1 = HJTopList_RightContent_Top1_Text1,
						Text2 = HJTopList_RightContent_Top1_Text2,
						Text2BK = HJTopList_RightContent_Top1_Text2_BK,
						Image2 = HJTopList_RightContent_ZhuangYuan,
						Image3 = HJTopList_RightContent_DaDizi1,
						guildtext = HJTopList_RightContent_Banghui_Top1_Text1,
					}
	g_Top_Info[2] = { Image = HJTopList_RightContent_Top2_Image,
						MenpaiBK = HJTopList_MenPai2_BK,
						Menpai = HJTopList_MenPai2,
						Text1 = HJTopList_RightContent_Top2_Text1,
						Text2 = HJTopList_RightContent_Top2_Text2,
						Text2BK = HJTopList_RightContent_Top2_Text2_BK,
						Image2 = HJTopList_RightContent_BangYan,
						Image3 = HJTopList_RightContent_DaDizi2,
						guildtext = HJTopList_RightContent_Banghui_Top2_Text1,
					}
	g_Top_Info[3] = { Image = HJTopList_RightContent_Top3_Image,
						MenpaiBK = HJTopList_MenPai3_BK,
						Menpai = HJTopList_MenPai3,
						Text1 = HJTopList_RightContent_Top3_Text1,
						Text2 = HJTopList_RightContent_Top3_Text2,
						Text2BK = HJTopList_RightContent_Top3_Text2_BK,
						Image2 = HJTopList_RightContent_TanHua,
						Image3 = HJTopList_RightContent_DaDizi3,
						guildtext = HJTopList_RightContent_Banghui_Top3_Text1,
					}
	g_HJTopList_MyInfo[1] = HJTopList_RightContent_ListInfo1
	g_HJTopList_MyInfo[2] = HJTopList_RightContent_ListInfo2
	g_HJTopList_MyInfo[3] = HJTopList_RightContent_ListInfo3
	g_HJTopList_MyInfo[4] = HJTopList_RightContent_ListInfo4
	g_HJTopList_MyInfo[5] = HJTopList_RightContent_ListInfo5
	g_HJTopList_MyInfo[6] = HJTopList_RightContent_ListInfoNone
	
	g_SubIndexButton[1] = HJTopList_ShowAll
	g_SubIndexButton[2] = HJTopList_RenjieBut
	g_SubIndexButton[3] = HJTopList_DijieBut
	g_SubIndexButton[4] = HJTopList_TianjieBut

	for i = 1, 7 do
		g_SubXiangShiButton[i] = _G["HJTopList_But"..i]
	end


	
	g_HJTopList_Fenye[1] = HJTopList_Renwu
	g_HJTopList_Fenye[2] = HJTopList_Banghui
	g_HJTopList_Fenye[3] = HJTopList_Huodong
	g_HJTopList_Fenye[4] = HJTopList_BangHui
	g_HJTopList_Fenye[5] = HJTopList_JiSha
	g_HJTopList_Fenye[6] = HJTopList_ShenBing

	g_HJTopList_Column[g_HJTopList_ColumnType.HCLevelType] = { str= {1,2,3,4,5}}
	g_HJTopList_Column[g_HJTopList_ColumnType.HCScoreType] = { str= {1,2,5,3,4,6},ratio={0.1,0.2,0.12,0.12,0.22,0.24} }	
	g_HJTopList_Column[g_HJTopList_ColumnType.HCGuildScore] = { str = {1,7,8,9,10} }	
	g_HJTopList_Column[g_HJTopList_ColumnType.HCGuildActivity] = { str = { 1,7,8,9,11}}
	g_HJTopList_Column[g_HJTopList_ColumnType.HCShilianType] = { str = {1,2,3,12,13},ratio={0.1,0.2,0.12,0.26,0.32}}
	g_HJTopList_Column[g_HJTopList_ColumnType.HCXiangshi] = { str = {1,2,3,5,14,15},ratio={0.1,0.2,0.12,0.13,0.12,0.33} }	
	g_HJTopList_Column[g_HJTopList_ColumnType.HCDianshi] = { str = {1,2,3,5,16,17},ratio={0.1,0.2,0.12,0.13,0.12,0.33} }	
	g_HJTopList_Column[g_HJTopList_ColumnType.HCDashixiong] = { str = {1,2,3,4,18}}
	g_HJTopList_Column[g_HJTopList_ColumnType.HCMenpaiChallenge] = { str = {1,20,25,26,27},ratio={0.1,0.26,0.32,0.19,0.13}}
	g_HJTopList_Column[g_HJTopList_ColumnType.HCCangjingge] = { str = {1,20,21,22,23,24},ratio={0.1,0.26,0.17,0.17,0.17,0.13}}
	g_HJTopList_Column[g_HJTopList_ColumnType.HCHuaShan] = { str = {28,29,30,31,32}}	

	g_Standard_ratio = {[1] = g_Standard_First_ratio,
						[2] = g_Standard_Second_ratio,
						[3] = g_Standard_Third_ratio,
						[4] = g_Standard_Forth_ratio,
						[5] = g_Standard_Fifth_ratio}
						
	
	g_HJTopList_guildpicture[1] = "set:TopList image:Toplist_BangHuiHigh"
	g_HJTopList_guildpicture[2] = "set:TopList image:Toplist_BangHuiMid"
	g_HJTopList_guildpicture[3] = "set:TopList image:Toplist_BangHuiLow"
	


	local ranktype = g_HJTopList_Type;	
	local nsranktype = g_HJTopList_nosave;

					
	g_dengji = {
					{id=ranktype.TOPLIST_LEVEL,str="�����ܰ�",nullstr="#{PHBD_180311_84}"},
					{id=ranktype.TOPLIST_LEVEL_EMEI,str="#{PHBD_180311_38}",nullstr="#{PHBD_180311_53}"},
					{id=ranktype.TOPLIST_LEVEL_MINGJIAO,str="#{PHBD_180311_39}",nullstr="#{PHBD_180311_54}"},
					{id=ranktype.TOPLIST_LEVEL_TIANSHAN,str="#{PHBD_180311_40}",nullstr="#{PHBD_180311_55}"},
					{id=ranktype.TOPLIST_LEVEL_XIAOYAO,str="#{PHBD_180311_41}",nullstr="#{PHBD_180311_56}"},
					{id=ranktype.TOPLIST_LEVEL_WUDANG,str="#{PHBD_180311_42}",nullstr="#{PHBD_180311_57}"},
					{id=ranktype.TOPLIST_LEVEL_GAIBANG,str="#{PHBD_180311_43}",nullstr="#{PHBD_180311_58}"},
				}
				
	
				
	g_zhandouli = {
		{id=ranktype.TOPLIST_SCORE,str="�����ܰ�", nullstr="#{PHBD_180311_84}", subid = {ranktype.TOPLIST_BATTLESCORE_STATE1,ranktype.TOPLIST_BATTLESCORE_STATE2,ranktype.TOPLIST_BATTLESCORE_STATE3}},
		{id=ranktype.TOPLIST_EMEI_SCORE_TOTAL,str="#{PHBD_180311_38}",nullstr="#{PHBD_180311_53}",subid = {ranktype.TOPLIST_EMEI_SCORE_STATE1,ranktype.TOPLIST_EMEI_SCORE_STATE2,ranktype.TOPLIST_EMEI_SCORE_STATE3}},
		{id=ranktype.TOPLIST_MINGJIAO_SCORE_TOTAL,str="#{PHBD_180311_39}",nullstr="#{PHBD_180311_54}",subid = {ranktype.TOPLIST_MINGJIAO_SCORE_STATE1,ranktype.TOPLIST_MINGJIAO_SCORE_STATE2,ranktype.TOPLIST_MINGJIAO_SCORE_STATE3}},
		{id=ranktype.TOPLIST_TIANSHAN_SCORE_TOTAL,str="#{PHBD_180311_40}",nullstr="#{PHBD_180311_55}",subid = {ranktype.TOPLIST_TIANSHAN_SCORE_STATE1,ranktype.TOPLIST_TIANSHAN_SCORE_STATE2,ranktype.TOPLIST_TIANSHAN_SCORE_STATE3}},
		{id=ranktype.TOPLIST_XIAOYAO_SCORE_TOTAL,str="#{PHBD_180311_41}",nullstr="#{PHBD_180311_56}",subid = {ranktype.TOPLIST_XIAOYAO_SCORE_STATE1,ranktype.TOPLIST_XIAOYAO_SCORE_STATE2,ranktype.TOPLIST_XIAOYAO_SCORE_STATE3}},
		{id=ranktype.TOPLIST_WUDANG_SCORE_TOTAL,str="#{PHBD_180311_42}",nullstr="#{PHBD_180311_57}",subid = {ranktype.TOPLIST_WUDANG_SCORE_STATE1,ranktype.TOPLIST_WUDANG_SCORE_STATE2,ranktype.TOPLIST_WUDANG_SCORE_STATE3}},
		{id=ranktype.TOPLIST_GAIBANG_SCORE_TOTAL,str="#{PHBD_180311_43}",nullstr="#{PHBD_180311_58}",subid = {ranktype.TOPLIST_GAIBANG_SCORE_STATE1,ranktype.TOPLIST_GAIBANG_SCORE_STATE2,ranktype.TOPLIST_GAIBANG_SCORE_STATE3}},
	}		

	g_yixiongshilian = {
					{id=ranktype.TOPLIST_SHILIAN_TOTAL,str="�����ܰ�", nullstr="#{PHBD_180311_84}"},
					{id=ranktype.TOPLIST_EMEI_SHILIAN_TOTAL,str="#{PHBD_180311_38}",nullstr="#{PHBD_180311_53}"},
					{id=ranktype.TOPLIST_MINGJIAO_SHILIAN_TOTAL,str="#{PHBD_180311_39}",nullstr="#{PHBD_180311_54}"},
					{id=ranktype.TOPLIST_TIANSHAN_SHILIAN_TOTAL,str="#{PHBD_180311_40}",nullstr="#{PHBD_180311_55}"},
					{id=ranktype.TOPLIST_XIAOYAO_SHILIAN_TOTAL,str="#{PHBD_180311_41}",nullstr="#{PHBD_180311_56}"},
					{id=ranktype.TOPLIST_WUDANG_SHILIAN_TOTAL,str="#{PHBD_180311_42}",nullstr="#{PHBD_180311_57}"},
					{id=ranktype.TOPLIST_GAIBANG_SHILIAN_TOTAL,str="#{PHBD_180311_43}",nullstr="#{PHBD_180311_58}"},	
				}
				
	g_keju = {
					{id=ranktype.TOPLIST_EXAM_WEEK0,str="����",subid = {ranktype.TOPLIST_EXAM_WEEK0,ranktype.TOPLIST_EXAM_WEEK1,ranktype.TOPLIST_EXAM_WEEK2,ranktype.TOPLIST_EXAM_WEEK3,
																							ranktype.TOPLIST_EXAM_WEEK4,ranktype.TOPLIST_EXAM_WEEK5,ranktype.TOPLIST_EXAM_WEEK6}},
								
			}
	g_dianshi = {
					{id=ranktype.TOPLIST_EXAM_FINAL,str="����"}
	}
	
	g_dashixiong = {
					{id=nsranktype.RANKINGLIST_NS_DASHIXIONG_EMEI,str="#{PHBD_180311_38}",nullstr="#{PHBD_180311_53}"},
					{id=nsranktype.RANKINGLIST_NS_DASHIXIONG_MINGJIAO,str="#{PHBD_180311_39}",nullstr="#{PHBD_180311_54}"},
					{id=nsranktype.RANKINGLIST_NS_DASHIXIONG_TIANSHAN,str="#{PHBD_180311_40}",nullstr="#{PHBD_180311_55}"},
					{id=nsranktype.RANKINGLIST_NS_DASHIXIONG_XIAOYAO,str="#{PHBD_180311_41}",nullstr="#{PHBD_180311_56}"},
					{id=nsranktype.RANKINGLIST_NS_DASHIXIONG_WUDANG,str="#{PHBD_180311_42}",nullstr="#{PHBD_180311_57}"},
					{id=nsranktype.RANKINGLIST_NS_DASHIXIONG_GAIBANG,str="#{PHBD_180311_43}",nullstr="#{PHBD_180311_58}"},						
					
	}

	g_HJTopList_huashan = {
					{id=nsranktype.RANKINGLIST_NS_HUASHAN_GROUP1,str="#{HSPH_191120_09}"},
					{id=nsranktype.RANKINGLIST_NS_HUASHAN_GROUP2,str="#{HSPH_191120_10}"},
					{id=nsranktype.RANKINGLIST_NS_HUASHAN_GROUP3,str="#{HSPH_191120_11}"},	
	}



					
	g_RankListRenwu = {
						{list = {g_dengji},str="#{PHBD_180311_18}", id = ranktype.TOPLIST_LEVEL},
						{list = {g_zhandouli},str="#{PHBD_180311_17}",id = ranktype.TOPLIST_SCORE},
						}
						
	g_RankListBanghui = {
							{list = {},str="���ս����", id = ranktype.TOPLIST_GUILD_SCORE},
							{list = {},str="������ջ�Ծ",id = ranktype.TOPLIST_GUILD_ACTIVITY},
							}
							
	
							
	g_huodong = {
					{ list = {g_yixiongshilian},str="����ľ�",id=ranktype.TOPLIST_SHILIAN_TOTAL},
					{ list = {g_HJTopList_huashan},str="#{HSPH_191120_54}",id=ranktype.RANKINGLIST_NS_HUASHAN_GROUP1},					
					{ list = {g_keju,g_dianshi},str="#{PHBD_180311_108}",id = ranktype.TOPLIST_EXAM_WEEK0},
					--{ list = {},str="#{PHBD_180311_120}", id = ranktype.TOPLIST_MENPAICHUANGGUAN},
					{ list = {g_dashixiong},str="���ɾ�ѡ", id = nsranktype.RANKINGLIST_NS_DASHIXIONG_EMEI},
					--{ list = {},str="#{PHBD_180311_133}",id = ranktype.TOPLIST_FENGHUANGLINGMU},
					--{ list = {},str="#{CJGN_191210_109}",id = ranktype.TOPLIST_CANGJINGGE},
					--{ list = {},str="#{MHQX_191212_93}",id = ranktype.TOPLIST_MANHANQUANXI},
	

				}						
	
	g_HJTopList_AllType = 
	{
		g_RankListRenwu,g_RankListBanghui,g_huodong
	}

					
	-- HJTopList_RightBK:Hide()

end


function HJTopList_GetIndexTable(list,nType)
	local start = 1
	for i=1,table.getn(list) do

			start = start + 1
			for j = 1, table.getn(list[i].list) do
				for x = 1, table.getn(list[i].list[j]) do
					if list[i].list[j][x].id == nType then
						return start
					else
						if list[i].list[j][x].subid ~= nil then
							for subi = 1, table.getn(list[i].list[j][x].subid) do
								if list[i].list[j][x].subid[subi] == nType then
									return start
								end
							end
						end
						start = start + 1
					end				
				end
			end
	end
	return start
end


function HJTopList_GetColumnType(nType)
	if HJTopList_IsInList(g_dengji,nType) == 1 then
		return g_HJTopList_ColumnType.HCLevelType
	elseif HJTopList_IsInList(g_zhandouli,nType) == 1 then
		return g_HJTopList_ColumnType.HCScoreType
	elseif nType == g_HJTopList_Type.TOPLIST_GUILD_SCORE then
		return	g_HJTopList_ColumnType.HCGuildScore
	elseif nType == g_HJTopList_Type.TOPLIST_GUILD_ACTIVITY then
		return  g_HJTopList_ColumnType.HCGuildActivity
	elseif HJTopList_IsInList(g_yixiongshilian,nType) == 1 then
		return  g_HJTopList_ColumnType.HCShilianType
	elseif HJTopList_IsInList(g_keju,nType) == 1 then
		return g_HJTopList_ColumnType.HCXiangshi
	elseif nType == g_HJTopList_Type.TOPLIST_EXAM_FINAL then
		return g_HJTopList_ColumnType.HCDianshi
	elseif HJTopList_IsInList(g_dashixiong,nType) == 1 then
		return g_HJTopList_ColumnType.HCDashixiong
	elseif nType == g_HJTopList_Type.TOPLIST_MENPAICHUANGGUAN or 
			nType == g_HJTopList_Type.TOPLIST_FENGHUANGLINGMU or
			nType == g_HJTopList_Type.TOPLIST_MANHANQUANXI then
		return g_HJTopList_ColumnType.HCMenpaiChallenge
	elseif nType == g_HJTopList_Type.TOPLIST_CANGJINGGE then
		return g_HJTopList_ColumnType.HCCangjingge
	elseif HJTopList_IsInList(g_HJTopList_huashan,nType) == 1 then
		return g_HJTopList_ColumnType.HCHuaShan
	end
	
	return -1
end

function HJTopList_IsInList(list,nType)
	for i,v in list do
		if nType == v.id then
			return 1
		else
			if v.subid ~= nil then			
				for index,value in v.subid do
					if nType == value then
						return 1
					end
				end
			end
		end
	end	
	return 0
end

--�Ƿ����Ҽ��˵�
function HJTopList_IsShowRCMenu(nType)
	if HJTopList_IsInList(g_dengji,nType) == 1 or
		HJTopList_IsInList(g_zhandouli,nType) == 1 or 
		HJTopList_IsInList(g_yixiongshilian,nType) == 1 or
		HJTopList_IsInList(g_keju,nType) == 1 or
		nType == g_HJTopList_Type.TOPLIST_EXAM_FINAL or
		HJTopList_IsInList(g_dashixiong,nType) == 1	then
		return 1
	end
	
	
	return 0
end

--�õ�ҳ���������


function HJTopList_OnEvent(event)
	if(event == "ADJEST_UI_POS") then
		HJTopList_On_ResetPos()
	elseif(event == "VIEW_RESOLUTION_CHANGED") then
		HJTopList_On_ResetPos()
	elseif(event == "UI_COMMAND" and tonumber(arg0) == 20210529) then
		HJTopList_RightContent_Title:RemoveAllItem();
		nHJTopListData = {}
		local LinShiData = {}
		for i = 1,10 do
			LinShiData[i] = Get_XParam_STR(i-1)
		end
		for i = 1,10 do
			if LinShiData[i] ~= nil and LinShiData[i] ~= "" then
				nHJTopListData[i] = Split(LinShiData[i],",")
			end
		end
		nHJTopListPage = Get_XParam_INT(0)
		HJTopList_FenYeSetCheck(nHJTopListPage)
		this:Show()
		HJTopList_Init()
	elseif(event == "UI_COMMAND" and tonumber(arg0) == 202105291) then
		--���ݸ���
		HJTopList_RightContent_Info:SetText(Get_XParam_STR(0))
	elseif(event == "HIDE_ON_SCENE_TRANSED") then
		HJTopList_On_Hide()
	elseif(event == "OPEN_TOPLIST") then
		if this:IsVisible() then
			this:Hide()
			return
		end

		this:Show()
		AskServerTimeAgain()
		HJTopList_Init()
	elseif(event == "RECIVE_RANKINGLIST_DATA") then
		--��Ҫ��NPC���򿪵Ľ�����Ҫ��ʽ��������ʽ
		local nType = tonumber(arg0)

		for i = 1,table.getn(g_HJTopList_NPCOpen) do
			if nType == g_HJTopList_NPCOpen[i].type then
				local index = HJTopList_GetIndexTable(g_HJTopList_AllType[g_HJTopList_NPCOpen[i].frame],nType)
				this:Show()
				HJTopList_CreateMenu(g_HJTopList_AllType[g_HJTopList_NPCOpen[i].frame])
				HJTopList_FenYeSetCheck(g_HJTopList_NPCOpen[i].frame)
				HJTopList_ItemDataChanged( index,false )
			end
		end
			
		HJTopList_OnShow(nType)
	elseif(event == "COMMON_LIST_RIGHT_CLICK") then
		local name = tostring(arg0)
		if name == "HJTopList_RightContent_List" then
			HJTopList_On_ListRightClick(tonumber(arg1))
		end
	elseif(event == "BWTROOP_UPDATE_COMMONRANKING") then
		local nType = tonumber(arg0)
		HJTopList_OnBWTROOPShow(nType)
	end
end
function HJTopList_On_ResetPos()
	HJTopList_Frame:SetProperty("UnifiedPosition", g_HJTopList_Frame_UnifiedPosition)
end

function HJTopList_On_Hide()
	HJTopList_RightContent_Title:RemoveAllItem()
	this:Hide()
end


function HJTopList_RightContent(nIndex)

end

function HJTopList_GetServerData(nIndex)
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("acme_OpenTopList");
		Set_XSCRIPT_ScriptID(900036);
		Set_XSCRIPT_Parameter(0,nIndex)
		Set_XSCRIPT_ParamCount(1);
	Send_XSCRIPT();	
	local nTop3 = {HJTopList_RightContent_Banghui_Top1_Text1,HJTopList_RightContent_Banghui_Top2_Text1,HJTopList_RightContent_Banghui_Top3_Text1}
	for i = 1,table.getn(nTop3) do
		nTop3[i]:SetText("")
	end
end

function HJTopList_Init()
	--��һЩ�ѿ��Ŀؼ���HIDE
	
	local nInfo = {"�ȼ���","��ֵ��","���ȣ�","�ͻ���","�ջ���","ɱ�ˣ�"}
	local nTop3 = {HJTopList_RightContent_Banghui_Top1_Text1,HJTopList_RightContent_Banghui_Top2_Text1,HJTopList_RightContent_Banghui_Top3_Text1}
	for i = 1,10 do
		if nHJTopListData[i] ~= nil and nHJTopListData[i] ~= "" then
			--ǰ������
			if i == 1 or i == 2 or i == 3 then
				nTop3[i]:SetText("#cb400ff"..nHJTopListData[i][2])
			end
			HJTopList_RightContent_Title:AddNewItem(i, 0, i-1);
			HJTopList_RightContent_Title:AddNewItem(MenPaiName[tonumber(nHJTopListData[i][1])+1],1, i-1);
			HJTopList_RightContent_Title:AddNewItem(nHJTopListData[i][2],2, i-1);
			HJTopList_RightContent_Title:AddNewItem(nHJTopListData[i][3],3, i-1);
			HJTopList_RightContent_Title:AddNewItem(nInfo[nHJTopListPage]..nHJTopListData[i][4],4, i-1);
		end
	end
	
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("acme_Toplistspendstring");
		Set_XSCRIPT_ScriptID(900036);
		Set_XSCRIPT_Parameter(0,nHJTopListPage)
		Set_XSCRIPT_ParamCount(1);
	Send_XSCRIPT();		
	-- HJTopList_RightBut:Hide()
	-- HJTopList_RightBut2:Hide()
	
	-- HJTopList_RightContent_TopBanghui:Hide()

	-- HJTopList_Renwu_Click()

end

function HJTopList_CreateMenu(thelist)
	HJTopList_ListContent:CleanAllElement("HJTopList")

	g_HJTopList_ItemData = {}

	local index = 1
	for i,vList in thelist do
		local listindex = 0
		local bHasSub = 0
		if table.getn(vList.list) ~= 0 then
			bHasSub = 1
		end
		HJTopList_AddMainMenu(index,listindex,vList.id,bHasSub,vList.str) 
		listindex = listindex+1;
		local listcount = 0
		for j,vInfo in vList.list do
			for k,vDetal in vInfo do
				HJTopList_AddSecMenu(index,listindex,vDetal.id,0,vDetal.str)
				listindex = listindex+1
			end
			listcount = listcount+table.getn(vInfo);
		end

		index = index+listcount+1
	end
	HJTopList_ClearAllShowListStatus()
	HJTopList_ListContent:Flash()
end

function HJTopList_Huodong_Click(bshow)
	HJTopList_CreateMenu(g_huodong)
	HJTopList_FenYeSetCheck(3)
	HJTopList_ItemDataChanged( 1,bshow )-- Ĭ����ʾ��һ��
end

function HJTopList_Renwu_Click()
	
	HJTopList_CreateMenu(g_RankListRenwu)
	HJTopList_FenYeSetCheck(1)
	HJTopList_ItemDataChanged( 1,true )-- Ĭ����ʾ��һ��
end

function HJTopList_Banghui_Click()	
	HJTopList_CreateMenu(g_RankListBanghui)	
	HJTopList_FenYeSetCheck(2)
	HJTopList_ItemDataChanged( 1, true)-- Ĭ����ʾ��һ��

end
--�������˵�
function HJTopList_AddMainMenu(nIndex,nSubIndex,nID,bHaveSecMenu,szName)

	local itemCatalog = HJTopList_ListContent:AddItemElement( "zhengzhao", "LEFT", "HJTopList","" ,"")
	itemCatalog:SetProperty("AchievementWindowCatalogButtonHover","AchievementHoverSection")
	local szText = szName
	itemCatalog:AddTextCatalogText(szText)
	-- add
	local ctrlItemBar = {}
	ctrlItemBar.index = nIndex
	ctrlItemBar.subindex = nSubIndex
	ctrlItemBar.id = nID
	ctrlItemBar.canshow = bHaveSecMenu
	ctrlItemBar.show = 0
	ctrlItemBar.name = szName
	ctrlItemBar.ctrl = itemCatalog
	table.insert(g_HJTopList_ItemData,ctrlItemBar)

end

--���Ӷ����˵�
function HJTopList_AddSecMenu(nIndex,nSubIndex,nID,bHaveSecMenu,szName)

	local itemText = HJTopList_ListContent:AddItemElement("zhengzhaoText","LEFT","HJTopList","","")
	itemText:SetProperty("AchievementWindowButtonTextHover","AchievementHoverSection")
	local szText = szName
	itemText:AddTextTextAndImage(szText,"","")
	itemText:Hide()		--�տ�ʼ�ӿؼ����ɼ�
	-- add
	local ctrlItemBar = {}
	ctrlItemBar.index = nIndex
	ctrlItemBar.subindex = nSubIndex
	ctrlItemBar.id = nID
	ctrlItemBar.canshow = bHaveSecMenu
	ctrlItemBar.show = 0
	ctrlItemBar.name = szName
	ctrlItemBar.ctrl = itemText
	table.insert(g_HJTopList_ItemData,ctrlItemBar)
end

--================================================
--�����е�״̬��Ϊ����ʾ
--================================================
function HJTopList_ClearAllShowListStatus()
	for nIndex = 1, table.getn(g_HJTopList_ItemData) do
		if g_HJTopList_ItemData[nIndex] ~= nil and g_HJTopList_ItemData[nIndex].ctrl ~= nil then
			g_HJTopList_ItemData[nIndex].show = 0
		end
	end
end

--================================================
--�������ؼ�������״̬
--================================================
function HJTopList_ClearAllStatus()
	for nIndex = 1, table.getn(g_HJTopList_ItemData) do
		if g_HJTopList_ItemData[nIndex].ctrl ~= nil then
			if g_HJTopList_ItemData[nIndex].subindex == 0 then-- һ���˵�
				g_HJTopList_ItemData[nIndex].ctrl:SetCatalogButtonSelect(false)	--��ѡ��
			else			-- �����˵�
				g_HJTopList_ItemData[nIndex].ctrl:SetTextCatalogSelected(false) --��ѡ��
				g_HJTopList_ItemData[nIndex].ctrl:Hide() -- ����
			end
		end
	end
end


function HJTopList_Close_Click()
	HJTopList_On_Hide()
end




--================================================
--�л���ָ��ѡ��л�ҳǩ����һ�� ��ѡѡ�����һ��
--================================================
function HJTopList_ItemDataChanged( nBtnIndex ,bShowDetail)

	if nBtnIndex == nil or nBtnIndex <= 0 or nBtnIndex > table.getn(g_HJTopList_ItemData) then
		return
	end


	local nItem = g_HJTopList_ItemData[nBtnIndex]
	if nItem == nil then
		return
	end


	--��¼ѡ����
	g_HJTopList_BtnIndex = nBtnIndex

	--�������״̬
	HJTopList_ClearAllStatus()
	HJTopList_CleanRankingFrame(1)
	HJTopList_RightContent_List:Clear()

	--ˢ��ѡ��״̬��ˢ�²˵���Ӧ����ϸ��Ϣ
	if nItem.subindex == 0 then		--һ���˵�
		if nItem.canshow ~= 1 then -- û�ж����˵���ֱ�Ӹ����Ҳ��б�
			HJTopList_ClearAllShowListStatus()
			g_HJTopList_ItemData[nBtnIndex].ctrl:SetCatalogButtonSelect(true)
			if bShowDetail == true then
				HJTopList_ShowDetail( nBtnIndex )
			end
		else -- �ж����˵�����¶����˵��Ĵ򿪹ر�״̬
			HJTopList_ItemButtonUpdate( )
			HJTopList_ItemDetailUpdate( )
		end
	else		--�����˵�
		-- ��ǰ�ҵ�һ���˵�btnindex
		local btnIndex = 0
		local curIndex = g_HJTopList_BtnIndex - 1
		while curIndex > 0 do
			if g_HJTopList_ItemData[curIndex] ~= nil and
					g_HJTopList_ItemData[curIndex].ctrl ~= nil and
					g_HJTopList_ItemData[curIndex].index == g_HJTopList_ItemData[g_HJTopList_BtnIndex].index and
					g_HJTopList_ItemData[curIndex].canshow == 1 then
					btnIndex = curIndex
					break
			end
			curIndex = curIndex - 1
		end
		HJTopList_SubItemButtonUpdate( btnIndex, nBtnIndex )
		if bShowDetail == true then
			HJTopList_SubItemDetailUpdate( btnIndex, nBtnIndex )
		end
	end

	HJTopList_ListContent:Flash()
end



function HJTopList_SubItemDetailUpdate(nIndex, nSubIndex)
	if nIndex <= 0 or nIndex > table.getn(g_HJTopList_ItemData) then
		return
	end
	if nSubIndex <= 0 or nSubIndex > table.getn(g_HJTopList_ItemData) then
		return
	end

	--�Ҳ���ʾ��ǰ�˵���Ӧ����ϸ��Ϣ
	HJTopList_ShowDetail( nSubIndex )
end

--================================================
--���һ���˵�
--================================================
function HJTopList_ItemDetailUpdate( )

	if g_HJTopList_BtnIndex <= 0 or g_HJTopList_BtnIndex > table.getn(g_HJTopList_ItemData) then
		return
	end

	-- Ĭ����ʾ��һ�������˵�
	local nIndex = g_HJTopList_BtnIndex + 1
	if nIndex <= 0 or nIndex > table.getn(g_HJTopList_ItemData) then
		return
	end

	--չ������״̬�Ѹ��£�ֻ��Ҫ����Ƿ���Ҫ��ʾ���б���
	if g_HJTopList_ItemData[g_HJTopList_BtnIndex].show > 0 then
		--��ʾ
		HJTopList_SubItemButtonUpdate( g_HJTopList_BtnIndex, nIndex )
		HJTopList_SubItemDetailUpdate( g_HJTopList_BtnIndex, nIndex )
	end
end

--================================================
--��������˵������¶����˵�״̬
--================================================
function HJTopList_SubItemButtonUpdate(nIndex, nSubIndex)
	if nIndex <= 0 or nIndex > table.getn(g_HJTopList_ItemData) then
		return
	end
	if nSubIndex <= 0 or nSubIndex > table.getn(g_HJTopList_ItemData) then
		return
	end

	--��ʾ��ǰ���ڵ�һ���˵��µ����ж����˵�
	for curIndex = 1, table.getn(g_HJTopList_ItemData) do
		if g_HJTopList_ItemData[curIndex] ~= nil and g_HJTopList_ItemData[curIndex].ctrl ~= nil and
		g_HJTopList_ItemData[curIndex].index == nIndex and g_HJTopList_ItemData[curIndex].subindex > 0 then
			g_HJTopList_ItemData[curIndex].ctrl:Show()	--ȫ����ʾ
			g_HJTopList_ItemData[curIndex].ctrl:SetTextCatalogSelected(false)	--��ѡ��
		end
	end

	--��������һ���˵���ѡ��״̬
	if nil ~= g_HJTopList_ItemData[nIndex] and nil ~= g_HJTopList_ItemData[nIndex].ctrl then
		g_HJTopList_ItemData[nIndex].ctrl:SetCatalogButtonSelect(true)
	end

	--���������Ķ����˵���ѡ��״̬
	if nil ~= g_HJTopList_ItemData[nSubIndex] and nil ~= g_HJTopList_ItemData[nSubIndex].ctrl then
		g_HJTopList_ItemData[nSubIndex].ctrl:SetTextCatalogSelected(true)	--��ѡ��
	end
end



--================================================
--���һ���˵�������һ���˵�״̬
--================================================
function HJTopList_ItemButtonUpdate()

	if g_HJTopList_BtnIndex <= 0 or g_HJTopList_BtnIndex > table.getn(g_HJTopList_ItemData) then
		return
	end

	--�Ȱ����е�״̬��Ϊ����ʾ
	local iOldCurShowList = g_HJTopList_ItemData[g_HJTopList_BtnIndex].show
	HJTopList_ClearAllShowListStatus()

	--���չ��״̬����رգ�����ر�״̬����չ��
	if iOldCurShowList > 0 then
		--�򿪱��ִ�״̬
		g_HJTopList_ItemData[g_HJTopList_BtnIndex].show = 1
		g_HJTopList_ItemData[g_HJTopList_BtnIndex].ctrl:SetCatalogButtonSelect(true)
	else
		g_HJTopList_ItemData[g_HJTopList_BtnIndex].show = 1
		g_HJTopList_ItemData[g_HJTopList_BtnIndex].ctrl:SetCatalogButtonSelect(true)
		--��ʾ���ж����˵�
		for nIndex = 1, table.getn(g_HJTopList_ItemData) do
			if g_HJTopList_ItemData[nIndex] ~= nil and g_HJTopList_ItemData[nIndex].ctrl ~= nil and
			g_HJTopList_ItemData[nIndex].index == g_HJTopList_BtnIndex and g_HJTopList_ItemData[nIndex].subindex > 0 then
				g_HJTopList_ItemData[nIndex].ctrl:Show()	--ȫ����ʾ
				g_HJTopList_ItemData[nIndex].ctrl:SetTextCatalogSelected(false)	--��ѡ��
			end
		end
	end
end



--================================================
-- ��ʾϸ��
--================================================
function HJTopList_ShowDetail(nIndex)
	if nIndex <= 0 or nIndex > table.getn(g_HJTopList_ItemData) then
		return
	end

	local	nID = g_HJTopList_ItemData[nIndex].id
	if nID == nil or nID < 0 then
		return
	end

	--�߻�Ҫ�ƾ���ʾ���ܵ�
	if HJTopList_IsInList(g_keju, nID) == 1 then
		local nWeek = Lua_GetServerWeek()
		nID = g_HJTopList_Type.TOPLIST_EXAM_WEEK0+nWeek
	end


	Player:AskRankingList(nID,1,50)
end



function HJTopList_ListContentItemClick()
	local sPos,ePos = string.find(arg0, "_auto_element")
	local curClickIndex = tonumber(string.sub(arg0, ePos + 1, -1))

	if curClickIndex + 1 == g_HJTopList_BtnIndex then
		return
	end
	if curClickIndex + 1 > 0 then
		HJTopList_ItemDataChanged( curClickIndex + 1,true )
	end
end

function HJTopList_CleanRankingFrame(index)
	for i = 1,3 do
		g_Top_Info[i].Image:SetProperty("Image","")
		g_Top_Info[i].Menpai:SetProperty("Image","")
		g_Top_Info[i].MenpaiBK:Hide()
		g_Top_Info[i].Text1:SetText("")
		g_Top_Info[i].Text2:SetText("")
		g_Top_Info[i].Text2BK:Hide()
		g_Top_Info[i].Image2:Hide()
		g_Top_Info[i].Image3:Hide()
	end
	HJTopList_RightContent_Title:RemoveAllItem();
	local ColumnCount = HJTopList_RightContent_Title:GetColumnCount();
	-- if ColumnCount > 0 then

		for i = 0,(ColumnCount - 1) do
		HJTopList_RightContent_Title:RemoveColumnByPos(0); --����ǰ��
		end
	-- end
	for i = 1,6 do
		g_HJTopList_MyInfo[i]:SetText("")
	end
end


--�õ�������һ�Ű�ťӦ��ѡ�ĸ�
function HJTopList_GetSubbuttonindex(nType)
	for i = 1,4 do
		for index,value in g_HJTopList_SubIndex[i] do
			if value == nType then
				return i
			end
		end
	end
	return 0
end


function HJTopList_GetSubSelect(nType,subtype)
	for i = 1,4 do
		for index,value in g_HJTopList_SubIndex[i] do
			if value == nType then
				return g_HJTopList_SubIndex[subtype][index]
			end
		end
	end
	return 0
end

function HJTopList_ResetFrame(nType)
	HJTopList_RightContent_TopBanghui:Hide()
	HJTopList_RightContent_TopClient:Show()
		HJTopList_RightBut:Hide()
		HJTopList_RightBut2:Hide()
		-- HJTopList_RightContent_ListClient:SetProperty("UnifiedSize","{{1.000000,-4.000000},{1.000000,-177.000000}}")
		-- HJTopList_RightContent_ListClient:SetProperty("UnifiedPosition","{{0.000000,1.000000},{0.000000,176.000000}}")
		HJTopList_RightContent_Title:SetProperty("UnifiedSize","{{1.000000,-3.000000},{1.000000,-208.000000}}")
	if HJTopList_IsInList(g_dengji,nType) == 1 or 
	HJTopList_IsInList(g_yixiongshilian,nType) == 1 then
	elseif g_HJTopList_Type.TOPLIST_GUILD_SCORE == nType or
		g_HJTopList_Type.TOPLIST_GUILD_ACTIVITY == nType then
		HJTopList_RightContent_TopBanghui:Show()
		HJTopList_RightContent_TopClient:Hide()
		-- HJTopList_RightContent:SetProperty("UnifiedSize","{{1.000000,-182.000000},{1.000000,-40.000000}}")
		-- HJTopList_RightContent:SetProperty("UnifiedPosition","{{0.000000,186.000000},{0.000000,0.000000}}")
	elseif HJTopList_IsInList(g_zhandouli,nType) == 1 then
		-- HJTopList_RightContent:SetProperty("UnifiedSize","{{1.000000,-182.000000},{1.000000,-40.000000}}")
		-- HJTopList_RightContent:SetProperty("UnifiedPosition","{{0.000000,186.000000},{0.000000,40.000000}}")

		HJTopList_RightBut:Show()	
		local subbuttonindex = HJTopList_GetSubbuttonindex(nType)
		if(subbuttonindex > 0) then
			HJTopList_SubIndexSetCheck(subbuttonindex)
		end
	elseif HJTopList_IsInList(g_keju,nType)== 1 then	
		HJTopList_RightBut2:Show()
		HJTopList_SubXiangshiSetCheck(nType-g_HJTopList_Type.TOPLIST_EXAM_WEEK0+1)
	elseif g_HJTopList_Type.TOPLIST_CANGJINGGE == nType or g_HJTopList_Type.TOPLIST_MENPAICHUANGGUAN == nType or g_HJTopList_Type.TOPLIST_FENGHUANGLINGMU == nType 
			or g_HJTopList_Type.TOPLIST_MANHANQUANXI == nType or HJTopList_IsInList(g_HJTopList_huashan,nType) == 1 then
		HJTopList_RightContent_TopClient:Hide()
		-- HJTopList_RightContent_ListClient:SetProperty("UnifiedSize","{{1.000000,0.000000},{1.000000,0.000000}}")
		-- HJTopList_RightContent_ListClient:SetProperty("UnifiedPosition","{{0.000000,0.000000},{0.000000,0.000000}}")
		HJTopList_RightContent_Title:SetProperty("UnifiedSize","{{1.000000,0.000000},{1.000000,-380.000000}}")
		-- HJTopList_RightContent_Title:Hide()
	end

end

function HJTopList_SubXiangshiSetCheck(nIndex)
	for i =1,7 do
		if nIndex == i then
			g_SubXiangShiButton[i]:SetCheck(1)
		else
			g_SubXiangShiButton[i]:SetCheck(0)
		end
	end	
end

function HJTopList_SubIndexSetCheck(nIndex)
	for i =1,6 do
		if nIndex == i then
			g_SubIndexButton[i]:SetCheck(1)
		else
			g_SubIndexButton[i]:SetCheck(0)
		end
	end
end


function HJTopList_FenYeSetCheck(nIndex)
	for i =1,6 do
		if nIndex == i then
			g_HJTopList_Fenye[i]:SetCheck(1)
		else
			g_HJTopList_Fenye[i]:SetCheck(0)
		end
	end
end


function HJTopList_ShowEmptyMessage(nType)
	if HJTopList_IsInList(g_dengji,nType) == 1 then
		local infostr = ""
		
		for i,v in g_dengji do
			if nType == v.id then
				if v.nullstr ~= nil then
					infostr = v.nullstr
				else
					infostr = v.str
				end
			end
		end		
		local message = ScriptGlobal_Format("#{PHBD_180311_60}",infostr)
		HJTopList_Paopao_Text:SetText(message)
	elseif HJTopList_IsInList(g_zhandouli,nType) == 1 then
		local infostr = ""
		--�õ��ܰ����������
		local maintype = HJTopList_GetSubSelect(nType,1)
		for i,v in g_zhandouli do
			if maintype == v.id then
				if v.nullstr ~= nil then
					infostr = v.nullstr
				else
					infostr = v.str
				end
			end
		end	
		local param1 = ""
		local index = HJTopList_GetSubbuttonindex(nType)
		if index == 1 then
			param1 = " "
		elseif index == 2 then
			param1 = "#{PHBD_180311_50}"
		elseif index == 3 then
			param1 = "#{PHBD_180311_51}"
		elseif index == 4 then
			param1 = "#{PHBD_180311_52}"
		end
		
		local message = ScriptGlobal_Format("#{PHBD_180311_49}",param1,infostr)
		HJTopList_Paopao_Text:SetText(message)
	elseif HJTopList_IsInList(g_yixiongshilian,nType) == 1 then
		local infostr = ""
		for i,v in g_yixiongshilian do
			if nType == v.id then
				if v.nullstr ~= nil then
					infostr = v.nullstr
				else
					infostr = v.str
				end
			end
		end		
		
		local message = ScriptGlobal_Format("#{PHBD_180311_71}",infostr)
		HJTopList_Paopao_Text:SetText(message)		
	elseif nType == g_HJTopList_Type.TOPLIST_GUILD_SCORE then
	
		HJTopList_Paopao_Text:SetText("#{PHBD_180311_64}")
	elseif nType == g_HJTopList_Type.TOPLIST_GUILD_ACTIVITY then
		HJTopList_Paopao_Text:SetText("#{PHBD_180311_66}")
	elseif HJTopList_IsInList(g_keju,nType) == 1 then
		local list = {"#{PHBD_180311_101}","#{PHBD_180311_102}","#{PHBD_180311_103}","#{PHBD_180311_104}",
		"#{PHBD_180311_105}","#{PHBD_180311_106}","#{PHBD_180311_107}"}
		local index = nType-g_HJTopList_Type.TOPLIST_EXAM_WEEK0+1
		if list[index] ~= nil then
			local message = ScriptGlobal_Format("#{PHBD_180311_100}",list[index])
			HJTopList_Paopao_Text:SetText(message)
		end
	elseif nType == g_HJTopList_Type.TOPLIST_EXAM_FINAL then
		HJTopList_Paopao_Text:SetText("#W�˰���ÿ����0����£�����ƾٵ��Ե���ң����л����ϰ�")
	elseif nType == g_HJTopList_Type.TOPLIST_MENPAICHUANGGUAN then
		HJTopList_Paopao_Text:SetText("#W�˰���ÿ��һ22:00ʱ���£����������ս����Ҽ��л����ϰ�")
	elseif nType == g_HJTopList_Type.TOPLIST_MANHANQUANXI then
		HJTopList_Paopao_Text:SetText("#{MHQX_191212_102}")
	elseif HJTopList_IsInList(g_dashixiong,nType) == 1 then
		HJTopList_Paopao_Text:SetText("������ÿ����24:00���£������ɳɹ��������ɾ�ѡ����Ҽ����ϰ�")
	elseif nType == g_HJTopList_Type.TOPLIST_CANGJINGGE then
		HJTopList_Paopao_Text:SetText("#{CJGN_191210_119}")
	elseif nType == g_HJTopList_Type.TOPLIST_FENGHUANGLINGMU then
		HJTopList_Paopao_Text:SetText("#{PHBD_180311_135}")
	elseif nType == g_HJTopList_nosave.RANKINGLIST_NS_HUASHAN_GROUP1 then
		HJTopList_Paopao_Text:SetText("#{HSPH_191120_50}")
	elseif nType == g_HJTopList_nosave.RANKINGLIST_NS_HUASHAN_GROUP2 then
		HJTopList_Paopao_Text:SetText("#{HSPH_191120_51}")
	elseif nType == g_HJTopList_nosave.RANKINGLIST_NS_HUASHAN_GROUP3 then
		HJTopList_Paopao_Text:SetText("#{HSPH_191120_52}")
	end
	
end



function HJTopList_InitFrame(nType)
	HJTopList_CleanRankingFrame(2)
	-- HJTopList_ResetFrame(nType)
	HJTopList_RightContent_List:Clear()
	g_CurSelectType = nType
	g_CurSelectItem = -1
	HJTopList_InitTableHead(nType)

	for i = 1,3 do
		g_Top_Info[i].MenpaiBK:Hide()
		g_Top_Info[i].Text2BK:Hide()

		g_Top_Info[i].guildtext:SetText("")
		g_Top_Info[i].Text1:SetText("#{PHBD_180311_48}")

	end
end
function HJTopList_OnBWTROOPShow(nType)
	HJTopList_InitFrame(nType)
	local nListNum = XBW:GetRankListNum()
	if nListNum == 0 then
		HJTopList_RightBK:Show();
		HJTopList_RightContent:Hide();
		HJTopList_ShowEmptyMessage(nType)
	else
		HJTopList_RightBK:Hide();
		HJTopList_RightContent:Show();	
	end

	for i = 0,nListNum-1 do
		local szName,nDuanWei,nLevel,nMenPai,nTotalCnt,nTotalWinCnt,nDuanWei1,nStar = XBW:GetRankListInfoByIndex(i)
		local nparamlist = {nLevel,nMenPai}
		local strlist = {szName,HJTopList_FormatHuaShanStr(nDuanWei,nDuanWei1,nStar)}
		HJTopList_AddNewItem(i,tonumber(nType),i+1,0,nparamlist,strlist)
	end

	local mRank,mName,mLevel,nMenPai = XBW:GetSelfInfo()

	if mRank >= 0 and mRank ~= 255 then
		local szName,nDuanWei,nLevel,nMenPai,nTotalCnt,nTotalWinCnt,nDuanWei1,nStar = XBW:GetRankListInfoByIndex(mRank)
		local nparamlist = {nLevel,nMenPai}
		local strlist = {szName,HJTopList_FormatHuaShanStr(nDuanWei,nDuanWei1,nStar)}
	-- 	local nRank,nValue,nparamlist = DataPool:GetRankingListIntInfo(myRank-1);
	-- 	local strlist = DataPool:GetRankingListStrInfo(myRank-1);
		HJTopList_FillMyData(nType,mRank+1,0,nparamlist,strlist)
	else
		HJTopList_FillMyDataNone(nType,myValue,myStr)
	end
end

function HJTopList_OnShow(nType)

	HJTopList_InitFrame(nType)

	local nDataCount = DataPool:GetRankingListDataCount()
	if nDataCount == 0 then
		HJTopList_RightBK:Show();
		HJTopList_RightContent:Hide();
		HJTopList_ShowEmptyMessage(nType)
	else
		HJTopList_RightBK:Hide();
		HJTopList_RightContent:Show();		
	end

	for i = 0, nDataCount-1 do
		local nRank,nValue,nparamlist = DataPool:GetRankingListIntInfo(i);
		local strlist = DataPool:GetRankingListStrInfo(i);

		if nRank > 0 then
			HJTopList_AddNewItem(i,nType,nRank,nValue,nparamlist,strlist)
		end
	end

	local myRank,myValue,myStr = DataPool:GetRankingListMyRank()
	if myRank > 0 then
		local nRank,nValue,nparamlist = DataPool:GetRankingListIntInfo(myRank-1);
		local strlist = DataPool:GetRankingListStrInfo(myRank-1);
		HJTopList_FillMyData(nType,nRank,nValue,nparamlist,strlist)
	else
		HJTopList_FillMyDataNone(nType,myValue,myStr)
	end
	
	HJTopList_MiscShow(nType)
end


--��ʾһЩ���������Ӱ˵Ķ���
function HJTopList_MiscShow(nType)
	if nType == g_HJTopList_Type.TOPLIST_CANGJINGGE then
		HJTopList_RightContent_ListInfoNone:SetText("#{CJGN_191210_118}")
	elseif nType == g_HJTopList_Type.TOPLIST_MENPAICHUANGGUAN then
		HJTopList_RightContent_ListInfoNone:SetText("#{PHBD_180311_129}")	
	elseif nType == g_HJTopList_Type.TOPLIST_MANHANQUANXI then
		HJTopList_RightContent_ListInfoNone:SetText("#{MHQX_191212_101}")
	elseif nType == g_HJTopList_Type.TOPLIST_FENGHUANGLINGMU then
		HJTopList_RightContent_ListInfoNone:SetText("#{PHBD_180311_134}")
	
	end
end

function HJTopList_FillMyDataNone(nType,myValue,myStr)
	if HJTopList_IsInList(g_dengji,nType) == 1 then
		local menpaiID = Player : GetData("MEMPAI");
		local szMenpai = GetMenpaiByID(tonumber(menpaiID))
		local szGuildName = Guild:GetMyGuildInfo("Name");
		if szGuildName == "" then
			szGuildName = "#{PHBD_180311_06}"
		end
		g_HJTopList_MyInfo[1]:SetText("#{PHBD_180311_07}")
		g_HJTopList_MyInfo[2]:SetText(Player:GetName())
		g_HJTopList_MyInfo[3]:SetText(szMenpai)
		g_HJTopList_MyInfo[4]:SetText(szGuildName)
		g_HJTopList_MyInfo[5]:SetText(Player:GetLevel())
	elseif HJTopList_IsInList(g_zhandouli,nType) == 1 then
		local menpaiID = Player : GetData("MEMPAI");
		local szMenpai = GetMenpaiByID(tonumber(menpaiID))
		local szGuildName = Guild:GetMyGuildInfo("Name");
		if szGuildName == "" then
			szGuildName = "�ް��"
		end
		g_HJTopList_MyInfo[1]:SetText("#{PHBD_180311_07}")
		g_HJTopList_MyInfo[2]:SetText(Player:GetName())
		g_HJTopList_MyInfo[3]:SetText(Player:GetLevel())
		local str = string.format("%-14s%-32s",szMenpai,szGuildName)
		g_HJTopList_MyInfo[4]:SetText(str)
		local str_2= string.format("%9s",Player:GetData("FIGHTING_SCORE_HH"))
		g_HJTopList_MyInfo[5]:SetText(str_2)

		
	elseif nType == g_HJTopList_Type.TOPLIST_PAOSHANG then
		local mypaoshang = DataPool:GetPlayerMission_DataRound(1467);
		local menpaiID = Player : GetData("MEMPAI");
		local szMenpai = GetMenpaiByID(tonumber(menpaiID))
		local szGuildName = Guild:GetMyGuildInfo("Name");
		if szGuildName == "" then
			szGuildName = "#{PHBD_180311_06}"
		end
		g_HJTopList_MyInfo[1]:SetText("#{PHBD_180311_07}")
		g_HJTopList_MyInfo[2]:SetText(Player:GetName())
		g_HJTopList_MyInfo[3]:SetText(mypaoshang)
		g_HJTopList_MyInfo[4]:SetText(szMenpai)
		g_HJTopList_MyInfo[5]:SetText(szGuildName)	
	
	elseif nType == g_HJTopList_Type.TOPLIST_GUILD_SCORE or
			nType == g_HJTopList_Type.TOPLIST_GUILD_ACTIVITY then
		local myGuildID = Player:GetData("GUILD");
		if myGuildID < 0 then
			g_HJTopList_MyInfo[6]:SetText("#{PHBD_180311_08}");
		else
			g_HJTopList_MyInfo[1]:SetText("#{PHBD_180311_07}")
			g_HJTopList_MyInfo[2]:SetText(Guild:GetMyGuildInfo("Name"))
			g_HJTopList_MyInfo[3]:SetText(Guild:GetMyGuildInfo("Level"))
			g_HJTopList_MyInfo[4]:SetText(myStr)
			g_HJTopList_MyInfo[5]:SetText(myValue)
		end
	elseif HJTopList_IsInList(g_yixiongshilian,nType) == 1 then
		g_HJTopList_MyInfo[1]:SetText("#{PHBD_180311_07}")
		g_HJTopList_MyInfo[2]:SetText(Player:GetName())
		local menpaiID = Player : GetData("MEMPAI");
		local szMenpai = GetMenpaiByID(tonumber(menpaiID))
		g_HJTopList_MyInfo[3]:SetText(szMenpai)

		-- Ӣ����������ȡ��ǰ�ؿ����� 
		-- ����ֵ��һ��nRet 1 �������ݣ� 0 ��û���Ӣ������ û�н��ȣ� -1 �쳣����
		-- 2-4����Ϊ �Ѵ�����½�ID���Ѵ���Ĺؿ�ID���Ѵ���Ľ���index
		local bRetCur, nCurZhangJie, nCurGuanQia, nCurProcessIndex = Lua_GetYXSLCurProcessInfo()
		if nil ~= bRetCur and 1 == bRetCur then 
			local bRetInfo, nProcessIndex, strZJName, strGQName = Lua_GetYXSLGuanQiaInfo(nCurZhangJie, nCurGuanQia) 
			if nil ~= bRetInfo and 1 == bRetInfo then
				local strgq = ScriptGlobal_Format("#{PHBD_180311_70}", strZJName, strGQName)		
				g_HJTopList_MyInfo[5]:SetText(strgq)
			end
		end

		local mymingwang = Player:GetData("MWLEVEL")
		local strxm = ""
		if mymingwang > 0 then
			strxm = Player:GetXiaMingNameById(mymingwang)
		end		
		g_HJTopList_MyInfo[4]:SetText(strxm)	
	elseif HJTopList_IsInList(g_keju,nType) == 1 then

		local nWeek = Lua_GetServerWeek()
		nID = g_HJTopList_Type.TOPLIST_EXAM_WEEK0+nWeek
		if nID == nType then
			local time = DataPool:GetPlayerMission_DataRound(1498)
			local ServerDayTime = DataPool:GetServerDayTime();
			if time == ServerDayTime then
				

				g_HJTopList_MyInfo[1]:SetText("#{PHBD_180311_07}")
				g_HJTopList_MyInfo[2]:SetText(Player:GetName())
				

				local menpaiID = Player : GetData("MEMPAI");
				local szMenpai = GetMenpaiByID(tonumber(menpaiID))
				local rCount = DataPool:GetPlayerMission_DataRound(1499)	
				--ʱ��
				local nTime = DataPool:GetPlayerMission_DataRound(1507)
				g_HJTopList_MyInfo[3]:SetText(szMenpai)
				local str = string.format("%-16s%-12s%s",Player:GetLevel(),rCount.."/10",HJTopList_FormatKejutime(nTime))
				g_HJTopList_MyInfo[4]:SetText(str)

				

			else
				g_HJTopList_MyInfo[6]:SetText("#{PHBD_180311_109}");
			end
		end
	
	elseif nType == g_HJTopList_Type.TOPLIST_EXAM_FINAL then
		--���������δ�ϰ���Ϣ����ʾ����
		local nWeek = Lua_GetServerWeek()
		if nWeek == 0 then
			g_HJTopList_MyInfo[1]:SetText("#{PHBD_180311_07}")
			g_HJTopList_MyInfo[2]:SetText(Player:GetName())
			

			local menpaiID = Player : GetData("MEMPAI");
			local szMenpai = GetMenpaiByID(tonumber(menpaiID))
			g_HJTopList_MyInfo[3]:SetText(szMenpai)
			local nTime = DataPool:GetPlayerMission_DataRound(1511)	--������ʱ
			
			local nScore = DataPool:GetPlayerMission_DataRound(1510)	--���Ի���
			if nScore > 0 then

				local str = string.format("%-16s%-11s%s",Player:GetLevel(),nTime.."��", nScore)
				g_HJTopList_MyInfo[4]:SetText(str)
			else
				g_HJTopList_MyInfo[4]:SetText(Player:GetLevel())
				g_HJTopList_MyInfo[5]:SetText("#{PHBD_180311_118}")
			end
		end
	elseif HJTopList_IsInList(g_dashixiong,nType) == 1 then
		local menpaiID = Player : GetData("MEMPAI");
		local szMenpai = GetMenpaiByID(tonumber(menpaiID))
		local szGuildName = Guild:GetMyGuildInfo("Name");
		if szGuildName == "" then
			szGuildName = "#{PHBD_180311_06}"
		end
		g_HJTopList_MyInfo[1]:SetText("#{PHBD_180311_07}")
		g_HJTopList_MyInfo[2]:SetText(Player:GetName())
		g_HJTopList_MyInfo[3]:SetText(szMenpai)
		g_HJTopList_MyInfo[4]:SetText(szGuildName)
		g_HJTopList_MyInfo[5]:SetText(0)	
	elseif HJTopList_IsInList(g_HJTopList_huashan,nType) == 1 then
		local menpaiID = Player : GetData("MEMPAI");
		local szMenpai = GetMenpaiByID(tonumber(menpaiID))

		g_HJTopList_MyInfo[1]:SetText("#{PHBD_180311_07}")
		g_HJTopList_MyInfo[2]:SetText(Player:GetName())
		g_HJTopList_MyInfo[3]:SetText(Player:GetLevel())
		g_HJTopList_MyInfo[4]:SetText(szMenpai)
		g_HJTopList_MyInfo[5]:SetText("")		
	end
end



function HJTopList_Newelement(ntype,Index)

	local a = {}	

	if 	ntype == g_HJTopList_Type.TOPLIST_MENPAICHUANGGUAN or ntype == g_HJTopList_Type.TOPLIST_FENGHUANGLINGMU or ntype == g_HJTopList_Type.TOPLIST_MANHANQUANXI  then
		local ItemBar = HJTopList_RightContent_List:AddChild("HJTopList_RightContent_Migong_Item")
		a.txt[1] = ItemBar:GetSubItem("HJTopList_RightContent_Migong_Text")
		a.txt[2] = ItemBar:GetSubItem("HJTopList_RightContent_Migong_Text1")
		a.txt[3] = ItemBar:GetSubItem("HJTopList_RightContent_Migong_Text2")
		a.txt[4] = ItemBar:GetSubItem("HJTopList_RightContent_Migong_Time")	
		a.button = ItemBar:GetSubItem("HJTopList_RightContent_Migong_Button")
		a.button2 = ItemBar:GetSubItem("HJTopList_RightContent_Migong_Button2")
		a.button:SetEvent("Clicked","HJTopList_TeamDetailClick("..Index..")")
		a.button:SetToolTip("#{MHQX_191212_97}")
		a.button:Hide()
		a.button2:Hide()
	elseif HJTopList_IsInList(g_keju,ntype) == 1 or
		ntype == g_HJTopList_Type.TOPLIST_EXAM_FINAL  then

		local ItemBar = HJTopList_RightContent_List:AddChild("HJTopList_RightContent_Item1")
		a.txt[1] = ItemBar:GetSubItem("HJTopList_RightContent_Text1_1")
		a.txt[2] = ItemBar:GetSubItem("HJTopList_RightContent_Text2_1")
		a.txt[3] = ItemBar:GetSubItem("HJTopList_RightContent_Text3_1")
		a.txt[4] = ItemBar:GetSubItem("HJTopList_RightContent_Text4_1")
		a.txt[5] = ItemBar:GetSubItem("HJTopList_RightContent_Text5_1")
		a.txt[6] = ItemBar:GetSubItem("HJTopList_RightContent_Text6_1")
		a.button = ItemBar:GetSubItem("HJTopList_RightContent_But1")
		a.button2 = ItemBar:GetSubItem("HJTopList_RightContent_But1_1")
		ItemBar:SetEvent( "MouseRClick", "HJTopList_On_ListRightClick("..Index..")" )
		a.button:Hide()
		a.button2:Hide()
	elseif HJTopList_IsInList(g_zhandouli,ntype) == 1 then
		local ItemBar = HJTopList_RightContent_List:AddChild("HJTopList_RightContent_Item2")
		a.txt[1] = ItemBar:GetSubItem("HJTopList_RightContent_Text1_2")
		a.txt[2] = ItemBar:GetSubItem("HJTopList_RightContent_Text2_2")
		a.txt[3] = ItemBar:GetSubItem("HJTopList_RightContent_Text3_2")
		a.txt[4] = ItemBar:GetSubItem("HJTopList_RightContent_Text4_2")
		a.txt[5] = ItemBar:GetSubItem("HJTopList_RightContent_Text5_2")
		a.txt[6] = ItemBar:GetSubItem("HJTopList_RightContent_Text6_2")
		a.button = ItemBar:GetSubItem("HJTopList_RightContent_But2")
		ItemBar:SetEvent( "MouseRClick", "HJTopList_On_ListRightClick("..Index..")" )
		a.button:Hide()
	elseif ntype == g_HJTopList_Type.TOPLIST_CANGJINGGE then
		local ItemBar = HJTopList_RightContent_List:AddChild("HJTopList_RightContent_Cangjingge_List")
		a.txt[1] = ItemBar:GetSubItem("HJTopList_RightContent_Cangjingge_Result_rank")
		a.txt[2] = ItemBar:GetSubItem("HJTopList_RightContent_Cangjingge_Result_Leader")
		a.txt[3] = ItemBar:GetSubItem("HJTopList_RightContent_Cangjingge_Result_Member")
		a.txt[4] = ItemBar:GetSubItem("HJTopList_RightContent_Cangjingge_Result_Escaped")
		a.txt[5] = ItemBar:GetSubItem("HJTopList_RightContent_Cangjingge_Result_Time")		
		a.button = ItemBar:GetSubItem("HJTopList_RightContent_Cangjingge_Result_Member_Detail")
		a.button2 = ItemBar:GetSubItem("HJTopList_RightContent_Cangjingge_Result")
		a.button:SetToolTip("#{MHQX_191212_97}")
		a.button:SetEvent("Clicked","HJTopList_TeamDetailClick("..Index..")")
		a.button:Hide()
		a.button2:Hide()
	elseif HJTopList_IsInList(g_yixiongshilian,ntype) == 1 then
		local ItemBar = HJTopList_RightContent_List:AddChild("HJTopList_RightContent_Shilian_Item")
		a.txt[1] = ItemBar:GetSubItem("HJTopList_RightContent_Shilian_Text1")
		a.txt[2] = ItemBar:GetSubItem("HJTopList_RightContent_Shilian_Text2")
		a.txt[3] = ItemBar:GetSubItem("HJTopList_RightContent_Shilian_Text3")
		a.txt[4] = ItemBar:GetSubItem("HJTopList_RightContent_Shilian_Text4")
		a.txt[5] = ItemBar:GetSubItem("HJTopList_RightContent_Shilian_Text5")			
	else
		local ItemBar = HJTopList_RightContent_List:AddChild("HJTopList_RightContent_Item")
		a.txt[1] = ItemBar:GetSubItem("HJTopList_RightContent_Text1")
		a.txt[2] = ItemBar:GetSubItem("HJTopList_RightContent_Text2")
		a.txt[3] = ItemBar:GetSubItem("HJTopList_RightContent_Text3")
		a.txt[4] = ItemBar:GetSubItem("HJTopList_RightContent_Text4")
		a.txt[5] = ItemBar:GetSubItem("HJTopList_RightContent_Text5")
		a.button = ItemBar:GetSubItem("HJTopList_RightContent_But")

		ItemBar:SetEvent( "MouseRClick", "HJTopList_On_ListRightClick("..Index..")" )
		
		a.button:Hide()	

	
	end
	return a;
end



function HJTopList_FillMyData(nType,nRank,nValue,plist,strlist)
	if HJTopList_IsInList(g_dengji,nType) == 1 or	
		nType == g_HJTopList_Type.TOPLIST_PAOSHANG then
		if strlist[2] == "" then
			strlist[2] = "#{PHBD_180311_06}"
		end
		local szMenpai = GetMenpaiByID(tonumber(plist[2]))
		g_HJTopList_MyInfo[1]:SetText(nRank)
		g_HJTopList_MyInfo[2]:SetText(strlist[1])
		g_HJTopList_MyInfo[3]:SetText(szMenpai)
		g_HJTopList_MyInfo[4]:SetText(strlist[2])
		if HJTopList_IsInList(g_dengji,nType) == 1 then
			g_HJTopList_MyInfo[5]:SetText(nValue)
		else
			local str = string.format("%-19d%d",nValue,plist[1])
			g_HJTopList_MyInfo[5]:SetText(str)
		end
	elseif HJTopList_IsInList(g_zhandouli,nType) == 1 then
		if strlist[2] == "" then
			strlist[2] = "�ް��"	--���ֵ�Ļ���ʽ���ַ���������ֵ��ʹ����ʽ��ʧЧ
		end
		local szMenpai = GetMenpaiByID(tonumber(plist[2]))
		g_HJTopList_MyInfo[1]:SetText(nRank)
		g_HJTopList_MyInfo[2]:SetText(strlist[1])
		g_HJTopList_MyInfo[3]:SetText(plist[1])
		local str = string.format("%-15s%s",szMenpai,strlist[2])
		g_HJTopList_MyInfo[4]:SetText(str)
		local str_2 = string.format("%9s",nValue)
		g_HJTopList_MyInfo[5]:SetText(str_2)


		
	elseif nType == g_HJTopList_Type.TOPLIST_GUILD_SCORE or
			nType == g_HJTopList_Type.TOPLIST_GUILD_ACTIVITY then
		g_HJTopList_MyInfo[1]:SetText(nRank)
		g_HJTopList_MyInfo[2]:SetText(strlist[2])
		g_HJTopList_MyInfo[3]:SetText(plist[1])
		g_HJTopList_MyInfo[4]:SetText(strlist[1])
		g_HJTopList_MyInfo[5]:SetText(nValue)
	elseif HJTopList_IsInList(g_yixiongshilian,nType) == 1 then
		g_HJTopList_MyInfo[1]:SetText(nRank)
		g_HJTopList_MyInfo[2]:SetText(strlist[1])
		local szMenpai = GetMenpaiByID(tonumber(plist[2]))
		g_HJTopList_MyInfo[3]:SetText(szMenpai)		
				
		-- Ӣ����������ȡ��ǰ�ؿ����� 
		-- ����ֵ��һ��nRet 1 �������ݣ� 0 ��û���Ӣ������ û�н��ȣ� -1 �쳣����
		-- 2-4����Ϊ �Ѵ�����½�ID���Ѵ���Ĺؿ�ID���Ѵ���Ľ���index
		local bRetCur, nCurZhangJie, nCurGuanQia, nCurProcessIndex = Lua_GetYXSLCurProcessInfo()
		if nil ~= bRetCur and 1 == bRetCur then 
			local bRetInfo, nProcessIndex, strZJName, strGQName = Lua_GetYXSLGuanQiaInfo(nCurZhangJie, nCurGuanQia) 
			if nil ~= bRetInfo and 1 == bRetInfo then
				local strgq = ScriptGlobal_Format("#{PHBD_180311_70}", strZJName, strGQName)		
				g_HJTopList_MyInfo[5]:SetText(strgq)
			end
		end

		local strxm = ""
		if plist[3] > 0 then
			strxm = Player:GetXiaMingNameById(plist[3])
		end		
		g_HJTopList_MyInfo[4]:SetText(strxm)
	elseif HJTopList_IsInList(g_keju,nType) == 1 then
		local nWeek = Lua_GetServerWeek()
		nID = g_HJTopList_Type.TOPLIST_EXAM_WEEK0+nWeek
		if nID == nType then

			g_HJTopList_MyInfo[1]:SetText(nRank)
			g_HJTopList_MyInfo[2]:SetText(strlist[1])
			g_HJTopList_MyInfo[3]:SetText(GetMenpaiByID(tonumber(plist[2])))
			local str = string.format("%-16s%-12s%s",plist[1],plist[5].."/10",HJTopList_FormatKejutime(plist[6]))
			g_HJTopList_MyInfo[4]:SetText(str)
		end
	elseif nType == g_HJTopList_Type.TOPLIST_EXAM_FINAL then
		g_HJTopList_MyInfo[1]:SetText(nRank)
		g_HJTopList_MyInfo[2]:SetText(strlist[1])
		g_HJTopList_MyInfo[3]:SetText(GetMenpaiByID(tonumber(plist[2])))
		-- local strsec = ScriptGlobal_Format("#{PHBD_180311_117}",plist[6])
		local str = string.format("%-16s%-11s%s",plist[1],plist[6].."��",nValue)
		g_HJTopList_MyInfo[4]:SetText(str)	

	elseif HJTopList_IsInList(g_dashixiong,nType) == 1 then
		g_HJTopList_MyInfo[1]:SetText(nRank)
		g_HJTopList_MyInfo[2]:SetText(strlist[1])
		local szMenpai = GetMenpaiByID(tonumber(plist[1]))
		g_HJTopList_MyInfo[3]:SetText(szMenpai)		
		
		if strlist[2] == "" then
			strlist[2] = "�ް��"	--���ֵ�Ļ���ʽ���ַ���������ֵ��ʹ����ʽ��ʧЧ
		end
		g_HJTopList_MyInfo[4]:SetText(strlist[2])
		g_HJTopList_MyInfo[5]:SetText(nValue)	

	elseif HJTopList_IsInList(g_HJTopList_huashan,nType) == 1 then
		local szMenpai = GetMenpaiByID(tonumber(plist[2]))
		g_HJTopList_MyInfo[1]:SetText(nRank)
		g_HJTopList_MyInfo[2]:SetText(strlist[1])
		g_HJTopList_MyInfo[3]:SetText(plist[1])
		g_HJTopList_MyInfo[4]:SetText(szMenpai)
		g_HJTopList_MyInfo[5]:SetText(strlist[2])			
	end
end





function HJTopList_AddNewItem(iIndex,nType,nRank,nValue,plist,strlist)
	local element = HJTopList_Newelement(nType,iIndex);
	if HJTopList_IsInList(g_dengji,nType) == 1 or
		nType == g_HJTopList_Type.TOPLIST_PAOSHANG then
		--plist[4] ����
		--strlist[1] ����
		--strlist[2] �����
		local szMenpai = GetMenpaiByID(tonumber(plist[2]))
		if strlist[2] == "" then
			strlist[2] = "#{PHBD_180311_06}"
		end
		
		element.txt[1]:SetText(nRank)
		element.txt[2]:SetText(strlist[1])
		element.txt[3]:SetText(szMenpai)
		element.txt[4]:SetText(strlist[2])
		element.txt[5]:SetText(nValue)

	elseif HJTopList_IsInList(g_zhandouli,nType) == 1 then
		local szMenpai = GetMenpaiByID(tonumber(plist[2]))
		if strlist[2] == "" then
			strlist[2] = "#{PHBD_180311_06}"
		end

		element.txt[1]:SetText(nRank)
		element.txt[2]:SetText(strlist[1])
		element.txt[3]:SetText(plist[1])
		element.txt[4]:SetText(szMenpai)
		element.txt[5]:SetText(strlist[2])
		element.txt[6]:SetText(nValue)
	elseif nType == g_HJTopList_Type.TOPLIST_GUILD_SCORE or
			nType == g_HJTopList_Type.TOPLIST_GUILD_ACTIVITY then

		element.txt[1]:SetText(nRank)
		element.txt[2]:SetText(strlist[2])
		element.txt[3]:SetText(plist[1])
		element.txt[4]:SetText(strlist[1])
		element.txt[5]:SetText(nValue)

	elseif HJTopList_IsInList(g_yixiongshilian,nType) == 1 then

		local szMenpai = GetMenpaiByID(tonumber(plist[2]))
		local strxm = ""
		if plist[3] > 0 then
			strxm = Player:GetXiaMingNameById(plist[3])
		end
		
		local nDataCurZhangJie = 1
		local nDataCurGuanQia = 0
		nDataCurZhangJie 	=  math.floor(nValue / 1000)
		nDataCurGuanQia 	=  math.mod(nValue, 1000)
		local Zjie = nDataCurZhangJie
		local GQia = nDataCurGuanQia	
		local bRetInfo, nProcessIndex, strZJName, strGQName = Lua_GetYXSLGuanQiaInfo(Zjie, GQia) 

		element.txt[1]:SetText(nRank)
		element.txt[2]:SetText(strlist[1])
		element.txt[3]:SetText(szMenpai)
		element.txt[4]:SetText(strxm)
		if nil ~= bRetInfo and 1 == bRetInfo then
			local strgq = ScriptGlobal_Format("#{PHBD_180311_70}",strZJName,strGQName)		
			element.txt[5]:SetText(strgq)
		end

	elseif HJTopList_IsInList(g_keju,nType) == 1 then

		local szMenpai = GetMenpaiByID(tonumber(plist[2]))

		--HJTopList_RightContent_List:AddNewItem(HJTopList_FormatKejutime(plist[6]),5,iIndex)
		element.txt[1]:SetText(nRank)
		element.txt[2]:SetText(strlist[1])
		element.txt[3]:SetText(szMenpai)
		element.txt[4]:SetText(plist[1])
		element.txt[5]:SetText(plist[5].."/10")
		element.txt[6]:SetText(HJTopList_FormatKejutime(plist[6]))
		if nRank >=1 and nRank <= 3 then
			element.button:Show()
			local showitem = {38002080,38002079,38002078}	
			if(showitem[nRank] ~= nil) then
				local theAction = DataPool:CreateBindActionItemForShow(showitem[nRank], 1)
				element.button:SetActionItem(theAction:GetID()) 
			end
		end



	elseif nType == g_HJTopList_Type.TOPLIST_EXAM_FINAL then
		
		local szMenpai = GetMenpaiByID(tonumber(plist[2]))
	
		local strsec = ScriptGlobal_Format("#{PHBD_180311_117}",plist[6])

		--HJTopList_RightContent_List:AddNewItem(nValue,5,iIndex)
		
		element.txt[1]:SetText(nRank)
		element.txt[2]:SetText(strlist[1])
		element.txt[3]:SetText(szMenpai)
		element.txt[4]:SetText(plist[1])
		element.txt[5]:SetText(strsec)
		element.txt[6]:SetText(nValue)
		

			local showitem = {{rank=1,item=39920393,item2=38002102},
								{rank=2,item=39920394,item2=38002103},
								{rank=3,item=39920395,item2=38002104},
								{rank=10,item=39920396,item2=38002081},
								{rank=20,item=39920396,item2=38002082},
								{rank=50,item=39920396,item2=38002083},}
			for i,v in ipairs(showitem) do
				if nRank <= v.rank then
					-- element.button:Show()
					-- local theTitleAction = DataPool:CreateBindActionItemForShow(v.item, 1)
					-- element.button:SetActionItem(theTitleAction:GetID())
					element.button:Show()
					local theawardAction = DataPool:CreateBindActionItemForShow(v.item2, 1)
					element.button:SetActionItem(theawardAction:GetID()) 
					break
				end
			end

	

		

	elseif HJTopList_IsInList(g_dashixiong,nType) == 1 then
		
		local szMenpai = GetMenpaiByID(tonumber(plist[1]))
		if strlist[2] == "" then
			strlist[2] = "#{PHBD_180311_06}"
		end
		
		element.txt[1]:SetText(nRank)
		element.txt[2]:SetText(strlist[1])
		element.txt[3]:SetText(szMenpai)
		element.txt[4]:SetText(strlist[2])
		element.txt[5]:SetText(nValue)
	elseif nType == g_HJTopList_Type.TOPLIST_MENPAICHUANGGUAN or 
	nType == g_HJTopList_Type.TOPLIST_MANHANQUANXI or 
	nType == g_HJTopList_Type.TOPLIST_FENGHUANGLINGMU then

		local membercount = 0
		for i = 1,6 do
			if string.len(strlist[i]) > 0 then
				membercount = membercount+1
			end
		end

		element.txt[1]:SetText(nRank)
		element.txt[2]:SetText(strlist[1])

		local formatStr = ScriptGlobal_Format("#{PHBD_180311_124}",membercount)
		element.txt[3]:SetText(formatStr)

		element.txt[4]:SetText(HJTopList_FormatKejutime(nValue))
		element.button:Show()
		element.button2:Show()
	elseif nType == g_HJTopList_Type.TOPLIST_CANGJINGGE then
	
		local membercount = 0
		for i = 1,6 do
			if string.len(strlist[i]) > 0 then
				membercount = membercount+1
			end
		end
		element.txt[1]:SetText(nRank)
		element.txt[2]:SetText(strlist[1])
		local formatStr = ScriptGlobal_Format("#{MHQX_191212_96}",membercount)
		element.txt[3]:SetText(formatStr)

		local escapeStr = ""
		if nValue == 0 then
			escapeStr = "#{CJGN_191210_114}"
		else
			escapeStr = ScriptGlobal_Format("#{CJGN_191210_113}",nValue)
		end
		element.txt[4]:SetText(escapeStr)

		element.txt[5]:SetText(HJTopList_FormatKejutime(plist[19]))
		element.button:Show()
		element.button2:Show()
	elseif HJTopList_IsInList(g_HJTopList_huashan,nType) == 1 then
		local szMenpai = GetMenpaiByID(tonumber(plist[2]))
		element.txt[1]:SetText(nRank)
		element.txt[2]:SetText(strlist[1])
		element.txt[3]:SetText(plist[1])
		element.txt[4]:SetText(szMenpai)
		element.txt[5]:SetText(strlist[2])	
	end


	if nRank >=1 and nRank <=3 then
		HJTopList_ShowPortrait(nType,nRank,nValue,plist,strlist)
	end
end


function HJTopList_ShowPortrait(nType,nRank,nValue,plist,strlist)
	
	if HJTopList_IsInList(g_dengji,nType) == 1 or
		nType == g_HJTopList_Type.TOPLIST_PAOSHANG or
		HJTopList_IsInList(g_yixiongshilian,nType) == 1 then
		local szPortrait = DataPool:GetPortraitByID(plist[4])
		g_Top_Info[nRank].Image:SetImage(szPortrait)
		g_Top_Info[nRank].MenpaiBK:Show()
		g_Top_Info[nRank].Menpai:SetProperty("Image",g_HJTopList_MenPaiImage[tonumber(plist[2])])
		g_Top_Info[nRank].Text1:SetText(strlist[1])
		g_Top_Info[nRank].Text2BK:Show()
		g_Top_Info[nRank].Text2:SetText(plist[1])
	elseif HJTopList_IsInList(g_zhandouli,nType) == 1 then
		local szPortrait = DataPool:GetPortraitByID(plist[4])
		g_Top_Info[nRank].Image:SetImage(szPortrait)
		g_Top_Info[nRank].MenpaiBK:Show()
		g_Top_Info[nRank].Menpai:SetProperty("Image",g_HJTopList_MenPaiImage[tonumber(plist[2])])
		g_Top_Info[nRank].Text1:SetText(strlist[1])
		g_Top_Info[nRank].Text2BK:Hide()	
	elseif nType == g_HJTopList_Type.TOPLIST_GUILD_SCORE or
		nType == g_HJTopList_Type.TOPLIST_GUILD_ACTIVITY then
		-- g_Top_Info[nRank].Image:SetProperty("Image",g_HJTopList_guildpicture[nRank])
		g_Top_Info[nRank].guildtext:SetText(strlist[2])
		-- g_Top_Info[nRank].Text2:SetText(nValue)
		-- g_Top_Info[nRank].MenpaiBK:Hide()
		-- g_Top_Info[nRank].Text2BK:Hide()
	elseif HJTopList_IsInList(g_keju,nType) == 1 then
	local szPortrait = DataPool:GetPortraitByID(plist[4])
		g_Top_Info[nRank].Image:SetImage(szPortrait)
		g_Top_Info[nRank].Image2:Show()
		g_Top_Info[nRank].Text1:SetText(strlist[1])
		g_Top_Info[nRank].Text2:SetText(plist[1])
		g_Top_Info[nRank].MenpaiBK:Show()
		g_Top_Info[nRank].Menpai:SetProperty("Image",g_HJTopList_MenPaiImage[tonumber(plist[2])])
		g_Top_Info[nRank].Text2BK:Show()
	elseif nType == g_HJTopList_Type.TOPLIST_EXAM_FINAL then
		local szPortrait = DataPool:GetPortraitByID(plist[4])
		g_Top_Info[nRank].Image:SetImage(szPortrait)
		g_Top_Info[nRank].Image2:Show()
		g_Top_Info[nRank].Text1:SetText(strlist[1])
		g_Top_Info[nRank].Text2:SetText(plist[1])
		g_Top_Info[nRank].MenpaiBK:Show()
		g_Top_Info[nRank].Menpai:SetProperty("Image",g_HJTopList_MenPaiImage[tonumber(plist[2])])
		g_Top_Info[nRank].Text2BK:Show()	
	elseif HJTopList_IsInList(g_dashixiong,nType) == 1 then
		if nRank == 1 and nValue >= 10 then
			g_Top_Info[nRank].Image3:Show()
		end
		local szPortrait = DataPool:GetPortraitByID(plist[2])
		g_Top_Info[nRank].Image:SetImage(szPortrait)
		g_Top_Info[nRank].Text1:SetText(strlist[1])
		g_Top_Info[nRank].MenpaiBK:Show()
		g_Top_Info[nRank].Menpai:SetProperty("Image",g_HJTopList_MenPaiImage[tonumber(plist[1])])	

	end
end
function HJTopList_InitTableHead(nType)
	local ColumnType = HJTopList_GetColumnType(nType)
	if g_HJTopList_Column[ColumnType] ~= nil then
		local radiolist = g_Standard_ratio
		if g_HJTopList_Column[ColumnType].ratio ~=nil then
			radiolist = g_HJTopList_Column[ColumnType].ratio
		end
		for i=1,table.getn(g_HJTopList_Column[ColumnType].str) do
			ratio = radiolist[i]
			HJTopList_RightContent_Title:AddColumn(g_HJTopList_ColumnName[g_HJTopList_Column[ColumnType].str[i]],i-1,ratio)
		end
	end
	--Ĭ��Ϊfalse�������lua���¼ӵ��У�ֱ��ֱ�����ó�false�����ں�Ĭ��ֵ����ǲ�����ģ�
	--�����ȵ���һ��trueȻ�������ó�false
	HJTopList_RightContent_Title:SetProperty( "ColumnsSizable", "True" );
	HJTopList_RightContent_Title:SetProperty( "ColumnsSizable", "False" );
	HJTopList_RightContent_Title:SetProperty( "ColumnsAdjust", "True" );
	HJTopList_RightContent_Title:SetProperty( "ColumnsMovable", "False" );

end

function HJTopList_ShowAll_Click()
	local nType = HJTopList_GetSubSelect(g_CurSelectType,1)
	if(nType > 0 ) then
		Player:AskRankingList(nType,1,50)
	end
	
	HJTopList_SubIndexSetCheck(1)
end

function HJTopList_RenjieBut_Click()
	-- g_CurSelectType
	local nType = HJTopList_GetSubSelect(g_CurSelectType,2)
	if(nType > 0 ) then
		Player:AskRankingList(nType,1,50)
	end
	
	HJTopList_SubIndexSetCheck(2)
end

function HJTopList_DijieBut_Click()
	local nType = HJTopList_GetSubSelect(g_CurSelectType,3)
	if(nType > 0 ) then
		Player:AskRankingList(nType,1,50)
	end
	
	HJTopList_SubIndexSetCheck(3)
end

function HJTopList_TianjieBut_Click()
	local nType = HJTopList_GetSubSelect(g_CurSelectType,4)
	if nType > 0 then
		Player:AskRankingList(nType,1,50)
	end
	HJTopList_SubIndexSetCheck(4)
end


function HJTopList_RightContent_List_SelectChanged()
	if HJTopList_IsShowRCMenu(g_CurSelectType) == 1 then
		local nTemp = HJTopList_RightContent_List:GetSelectItem();
		g_CurSelectItem = nTemp
	end
end


function HJTopList_RightContent_List_ItemRightClicked()
	if HJTopList_IsShowRCMenu(g_CurSelectType) == 1 then
		if g_CurSelectItem >= 0 then
			local nName = HJTopList_RightContent_List:GetItemText(g_CurSelectItem,1)
			local guid = DataPool:GetRankingListGUID(g_CurSelectItem)
			ShowCommonMenu("HJTopList",tostring(nName),tostring(guid))
		
		end
	
	end
end


function HJTopList_GetColName(element)
	if element:GetSubItem("HJTopList_RightContent_Text2") ~= nil then
		return element:GetSubItem("HJTopList_RightContent_Text2"):GetText()
	elseif element:GetSubItem("HJTopList_RightContent_Text2_1") ~= nil then
		return element:GetSubItem("HJTopList_RightContent_Text2_1"):GetText()
	elseif element:GetSubItem("HJTopList_RightContent_Text2_2") ~= nil then
		return element:GetSubItem("HJTopList_RightContent_Text2_2"):GetText()
	else
		return ""
	end
	

end


function HJTopList_On_ListRightClick(rowid)
	if HJTopList_IsShowRCMenu(g_CurSelectType) == 1 then
		local guid = DataPool:GetRankingListGUID(rowid)
		if guid and guid == Player:GetGUID() then
			return
		end
		local select = HJTopList_RightContent_List:GetListItemAt(rowid + 1)
		if select then
			local name = HJTopList_GetColName(select)
			local guid = DataPool:GetRankingListGUID(rowid)
			ShowCommonMenu("HJTopList",tostring(name),tostring(guid))
		end

		
	end
end


function HJTopList_RightBut2_Click(index)
	if HJTopList_IsInList(g_keju,g_CurSelectType) == 1 then
		Player:AskRankingList(g_HJTopList_Btn2_list[index][1],1,50)
		HJTopList_SubXiangshiSetCheck(index)
	end
	
end

function HJTopList_FormatKejutime(time)
	if time >= 3600 then
		return "#{PHBD_180311_99}"
	else
		local sec = math.mod(time,60)
		local min = math.floor(time/60)
		return ScriptGlobal_Format("#{PHBD_180311_98}",min,sec)
	end

end


function HJTopList_TeamDetailClick(index)
	local x = HJTopList_Frame:GetProperty("AbsoluteXPosition")
	local y = HJTopList_Frame:GetProperty("AbsoluteYPosition")
	local width = HJTopList_Frame:GetProperty("AbsoluteWidth")
	
	PushEvent("OPEN_RANKLIST_TEAM",index,x+width,y)
end
