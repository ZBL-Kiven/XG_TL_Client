-- PetSoul_FengHunLu ���¼ 2022-1-5 lishilong
-- !!!reloadscript =PetSoul_FengHunLu
-- !!!reloadscript =MiniMap
-- !!uiopentest = 791010 ��ָ���ű��ŵ�AskOpenMainUI
--Q546528533  �������ֽ������������ã�����
-- 458

local g_PetSoul_FengHunLu_Frame_UnifiedPosition
local MAX_OBJ_DISTANCE 			= 3.0
local g_nObjCaredIDClient 		= -1
local g_nServerObjID 			= -1
local bCaredItem 				= 0
local bCaredObj 				= 0
local bCaredMoney 				= 0
local bCaredYuanBao				= 0
local g_nComfirmParam1			= 0

local g_nFengHunluDayIndex 		= 0 
local g_nMDMaiDian01			= 0	
local g_nMDMaiDian02 			= 0	
local g_nMDReward01 			= 0	
local g_nMDReward02 			= 0	
local g_nHuoYuePoint			= 0	
local g_nEndYear				= 0	
local g_nEndMonth				= 0	
local g_nEndDay					= 0	
local g_AllTotalPoint			= 0
local g_nCurPage				= 1

local g_nUICommandID			= 79101001
local g_contorlPage				= {}
local g_contorlPageTips			= {}
local g_contorlEventIcon		= {}
local g_contorlEventDes			= {}
local g_contorlEventProcess		= {}
local g_contorlEventReward		= {}
local g_contorlEventButton		= {}
local g_contorlEventButtonHotP	= {}
local g_contorlEventGetedPic	= {}
local g_contorlPointReward		= {}
local g_contorlPointRewardGeted	= {}

-- ÿ����ҷ��¼�ĳ���ʱ��
local g_nTotalDays				= 14
-- �������	
local g_nMaxTotalDay			= 8 
-- ÿ�����Event����	
local g_nMaxEventPerDay			= 5
-- ���MD�洢��	
local g_nMaxSavePos				= 32
-- �����������ȼ�
local g_nMaxPointRewardLevel	= 5
-- ������
local g_nMaxPoint				= 40
--���������ݴ�����Ϣ
local g_MaiDianSaveInfo = {}
-- ����¼��Ĵ洢������Ϣ
-- nSaveMD �洢MD nSavePosStart ����ڱ�MD����ʼ���� 
-- nSaveLen ���ռ�õ�bit�� nMaxValue ����������ֵ(�ϸ�С�ڵ���(2^nSaveLen) - 1������������һ���õ��Կռ�)
-- �ο�1 ����Ӣ��֮· #define HEROESRETURNS_TASK_INDEX_0		0	// ���1������ ��
-- �ο�2 ս���� 892664
local g_tabMaiDianSaveInfo = 
{
	[1] 	= {nSaveMDIndex = 1, nSavePosStart = 8, 	nSaveLen = 12, 	nMaxValue = 2500, },-- 1] �ۼ�ɱ������ 4095 cpp���
	[2] 	= {nSaveMDIndex = 1, nSavePosStart = 4, 	nSaveLen = 5, 	nMaxValue = 20, },	-- 2] ������ 31	
	[3] 	= {nSaveMDIndex = 1, nSavePosStart = 4, 	nSaveLen = 5, 	nMaxValue = 15, },	-- 3] ������� 31
	[4] 	= {nSaveMDIndex = 1, nSavePosStart = 2, 	nSaveLen = 5, 	nMaxValue = 10, },	-- 4] ʦ������ 31
	[5] 	= {nSaveMDIndex = 1, nSavePosStart = 3, 	nSaveLen = 5, 	nMaxValue = 9, },	-- 5] ���� 31
	[6] 	= {nSaveMDIndex = 2, nSavePosStart = 4, 	nSaveLen = 3, 	nMaxValue = 4, },	-- 6] ��� 7
	[7] 	= {nSaveMDIndex = 2, nSavePosStart = 4, 	nSaveLen = 3, 	nMaxValue = 4, },	-- 7] ����� 7
	[8] 	= {nSaveMDIndex = 2, nSavePosStart = 2, 	nSaveLen = 3, 	nMaxValue = 2, },	-- 8] ���� 7
	[9] 	= {nSaveMDIndex = 2, nSavePosStart = 2, 	nSaveLen = 3, 	nMaxValue = 2, },	-- 9] �ƾ� 7
	[10] 	= {nSaveMDIndex = 2, nSavePosStart = 2, 	nSaveLen = 3, 	nMaxValue = 2, },	-- 10 ǰ������ 7
	[11] 	= {nSaveMDIndex = 2, nSavePosStart = 2, 	nSaveLen = 3, 	nMaxValue = 2, },	-- 11 ���״�ͼ 7
	[12] 	= {nSaveMDIndex = 2, nSavePosStart = 1, 	nSaveLen = 2, 	nMaxValue = 1, },	-- 12 У������ 3 cpp���
	[13] 	= {nSaveMDIndex = 2, nSavePosStart = 1, 	nSaveLen = 2, 	nMaxValue = 1, },	-- 13 �ٱ����� 3
	[14] 	= {nSaveMDIndex = 2, nSavePosStart = 1, 	nSaveLen = 2, 	nMaxValue = 100, },	-- 14 ��Ծ��
}

-- ÿ����¼���Ϣ ������������id �������ֵ ��õ��ܻ���� ���һ����ʱ����
-- ���и����������⴦����¼���Ŀǰ-1��ÿ�ջ�Ծֵ
--�Ū�˰��� �߼������ˡ���������ʹ��
local g_tabEventInfo = 
{
	-- ��1��
	-- ��ɱ100������	1
	-- �μ�1�����	1
	-- ���1���Ұ����˿����	1
	-- ���5�ΰ������	1
	-- ���ջ�Ծֵ�ﵽ100��	1
	[1] = 
	{
		[1] = {nMaiDianID = 1, 	nMaiDianValue = 100, 	nGetPoint = 1, nEventIndex = 1, 	OverConut = 1},
		[2] = {nMaiDianID = 6, 	nMaiDianValue = 1, 		nGetPoint = 1, nEventIndex = 2, 	OverConut = 1},
		[3] = {nMaiDianID = 7, 	nMaiDianValue = 1, 		nGetPoint = 1, nEventIndex = 3, 	OverConut = 1},
		[4] = {nMaiDianID = 3, 	nMaiDianValue = 1, 		nGetPoint = 1, nEventIndex = 4, 	OverConut = 1},
		[5] = {nMaiDianID = -1, nMaiDianValue = 100, 	nGetPoint = 1, nEventIndex = 5, 	OverConut = 1},
	},
	-- ��2��	
	-- ��ɱ200������	1
	-- ���5��������	1
	-- ���1��У������	1
	-- ���1������	1
	-- ���5�ΰ������	1
	[2] = 
	{
		[1] = {nMaiDianID = 1, 	nMaiDianValue = 200, 	nGetPoint = 1, nEventIndex = 6,  	OverConut = 2},
		[2] = {nMaiDianID = 2, 	nMaiDianValue = 5, 		nGetPoint = 1, nEventIndex = 7,  	OverConut = 1},
		[3] = {nMaiDianID = 12, nMaiDianValue = 1, 		nGetPoint = 1, nEventIndex = 8,  	OverConut = 1},
		[4] = {nMaiDianID = 8, 	nMaiDianValue = 1, 		nGetPoint = 1, nEventIndex = 9,  	OverConut = 1},
		[5] = {nMaiDianID = 3, 	nMaiDianValue = 5, 		nGetPoint = 1, nEventIndex = 10,  	OverConut = 2},
	},

	-- ��3��	
	-- ��ɱ400������	1
	-- ���1�γ��״�ͼ	1
	-- ���1�ΰٱ�����	1
	-- ���2���Ұ����˿����	1
	-- ���3������	1
	[3] = 
	{
		[1] = {nMaiDianID = 1, 	nMaiDianValue = 400, 	nGetPoint = 1, nEventIndex = 11,  	OverConut = 3},
		[2] = {nMaiDianID = 11, nMaiDianValue = 1, 		nGetPoint = 1, nEventIndex = 12,  	OverConut = 1},
		[3] = {nMaiDianID = 13, nMaiDianValue = 1, 		nGetPoint = 1, nEventIndex = 13,  	OverConut = 1},
		[4] = {nMaiDianID = 7, 	nMaiDianValue = 2, 		nGetPoint = 1, nEventIndex = 14,  	OverConut = 2},
		[5] = {nMaiDianID = 5, 	nMaiDianValue = 3, 		nGetPoint = 1, nEventIndex = 15,  	OverConut = 1},
	},

	-- ��4��	
	-- ��ɱ700������	1
	-- ���10��������	1
	-- ���2�����	1
	-- ���1�οƾ�	1
	-- ���1��ǰ������	1
	[4] = 
	{
		[1] = {nMaiDianID = 1, 	nMaiDianValue = 700, 	nGetPoint = 1, nEventIndex = 16,  	OverConut = 4 },
		[2] = {nMaiDianID = 2, 	nMaiDianValue = 10, 	nGetPoint = 1, nEventIndex = 17,  	OverConut = 2 },
		[3] = {nMaiDianID = 6, 	nMaiDianValue = 2, 		nGetPoint = 1, nEventIndex = 18,  	OverConut = 2 },
		[4] = {nMaiDianID = 9, 	nMaiDianValue = 1, 		nGetPoint = 1, nEventIndex = 19,  	OverConut = 1 },
		[5] = {nMaiDianID = 10, nMaiDianValue = 1, 		nGetPoint = 1, nEventIndex = 20,  	OverConut = 1 },
	},

	-- ��5��	
	-- ��ɱ1000������	1
	-- ���5��ʦ������	1
	-- ���2������	1
	-- ���3���Ұ����˿����	1
	-- ���10�ΰ������	1
	[5] = 
	{
		[1] = {nMaiDianID = 1, 	nMaiDianValue = 1000, 	nGetPoint = 1, nEventIndex = 21,  	OverConut = 5 },
		[2] = {nMaiDianID = 4, 	nMaiDianValue = 5, 		nGetPoint = 1, nEventIndex = 22,  	OverConut = 1 },
		[3] = {nMaiDianID = 8, 	nMaiDianValue = 2, 		nGetPoint = 1, nEventIndex = 23,  	OverConut = 2 },
		[4] = {nMaiDianID = 7, 	nMaiDianValue = 3, 		nGetPoint = 1, nEventIndex = 24,  	OverConut = 3 },
		[5] = {nMaiDianID = 3, 	nMaiDianValue = 10, 	nGetPoint = 1, nEventIndex = 25,  	OverConut = 3 },
	},

	-- ��6��	
	-- ��ɱ1500������	1
	-- ���15��������	1
	-- ���3�����	1
	-- ���2�γ��״�ͼ	1
	-- ���6������	1
	[6] = 
	{
		[1] = {nMaiDianID = 1, 	nMaiDianValue = 1500, 	nGetPoint = 1, nEventIndex = 26,  	OverConut = 6 },
		[2] = {nMaiDianID = 2, 	nMaiDianValue = 15, 	nGetPoint = 1, nEventIndex = 27,  	OverConut = 3 },
		[3] = {nMaiDianID = 6, 	nMaiDianValue = 3, 		nGetPoint = 1, nEventIndex = 28,  	OverConut = 3 },
		[4] = {nMaiDianID = 11, nMaiDianValue = 2, 		nGetPoint = 1, nEventIndex = 29,  	OverConut = 2 },
		[5] = {nMaiDianID = 5, 	nMaiDianValue = 6, 		nGetPoint = 1, nEventIndex = 30,  	OverConut = 2 },
	},

	-- ��7��	
	-- ��ɱ2000������
	-- ���10��ʦ������
	-- ���4���Ұ����˿����
	-- ���2�οƾ�
	-- ���2��ǰ������
	[7] = 
	{
		[1] = {nMaiDianID = 1, 	nMaiDianValue = 2000, 	nGetPoint = 1, nEventIndex = 31,   	OverConut = 7},
		[2] = {nMaiDianID = 4, 	nMaiDianValue = 10, 	nGetPoint = 1, nEventIndex = 32,  	OverConut = 2},
		[3] = {nMaiDianID = 7, 	nMaiDianValue = 4, 		nGetPoint = 1, nEventIndex = 33,  	OverConut = 4},
		[4] = {nMaiDianID = 9, 	nMaiDianValue = 2, 		nGetPoint = 1, nEventIndex = 34,   	OverConut = 2},
		[5] = {nMaiDianID = 10, nMaiDianValue = 2, 		nGetPoint = 1, nEventIndex = 35,   	OverConut = 2},
	},

	-- ��8��	
	-- ��ɱ2500������
	-- ���20��������
	-- ���4�����
	-- ���9������
	-- ���15�ΰ������
	[8] = 
	{
		[1] = {nMaiDianID = 1, 	nMaiDianValue = 2500, 	nGetPoint = 1, nEventIndex = 36,   	OverConut = 8},
		[2] = {nMaiDianID = 2, 	nMaiDianValue = 20, 	nGetPoint = 1, nEventIndex = 37,   	OverConut = 4},
		[3] = {nMaiDianID = 6, 	nMaiDianValue = 4, 		nGetPoint = 1, nEventIndex = 38,  	OverConut = 4},
		[4] = {nMaiDianID = 5, 	nMaiDianValue = 9, 		nGetPoint = 1, nEventIndex = 39,   	OverConut = 3},
		[5] = {nMaiDianID = 3, 	nMaiDianValue = 15, 	nGetPoint = 1, nEventIndex = 40,   	OverConut = 4},
	},
}

-- �¼�չʾ
local g_tabEventShowInfo = 
{
	[1] 	= {strDes = "#{XYSHFC_20211229_01}", strTips = "#{XYSHFC_20211229_41}",	strPic = "set:Huodong_7 image:Huodong_7_6"},
	[2] 	= {strDes = "#{XYSHFC_20211229_02}", strTips = "#{XYSHFC_20211229_42}",	strPic = "set:SalaryMission image:SalaryMission_11"},
	[3] 	= {strDes = "#{XYSHFC_20211229_03}", strTips = "#{XYSHFC_20211229_43}",	strPic = "set:SalaryMission image:SalaryMission_13"},
	[4] 	= {strDes = "#{XYSHFC_20211229_04}", strTips = "#{XYSHFC_20211229_44}",	strPic = "set:CircularTaskTool22 image:CircularTaskTool22_2"},
	[5] 	= {strDes = "#{XYSHFC_20211229_05}", strTips = "#{XYSHFC_20211229_45}",	strPic = "set:Huodong_7 image:Huodong_7_2"},
	[6] 	= {strDes = "#{XYSHFC_20211229_06}", strTips = "#{XYSHFC_20211229_46}",	strPic = "set:Huodong_7 image:Huodong_7_6"},
	[7] 	= {strDes = "#{XYSHFC_20211229_07}", strTips = "#{XYSHFC_20211229_47}",	strPic = "set:Huodong_12 image:Huodong_12_5"},
	[8] 	= {strDes = "#{XYSHFC_20211229_08}", strTips = "#{XYSHFC_20211229_48}",	strPic = "set:CircularTaskTool13 image:CircularTaskTool13_1"},
	[9] 	= {strDes = "#{XYSHFC_20211229_09}", strTips = "#{XYSHFC_20211229_49}",	strPic = "set:Huodong image:Huodong_2"},
	[10] 	= {strDes = "#{XYSHFC_20211229_10}", strTips = "#{XYSHFC_20211229_50}",	strPic = "set:CircularTaskTool22 image:CircularTaskTool22_2"},
	[11] 	= {strDes = "#{XYSHFC_20211229_11}", strTips = "#{XYSHFC_20211229_51}",	strPic = "set:Huodong_7 image:Huodong_7_6"},
	[12] 	= {strDes = "#{XYSHFC_20211229_12}", strTips = "#{XYSHFC_20211229_52}",	strPic = "set:Huodong_12 image:Huodong_12_13"},
	[13] 	= {strDes = "#{XYSHFC_20211229_13}", strTips = "#{XYSHFC_20211229_53}",	strPic = "set:Buff5 image:Buff5_9"},
	[14] 	= {strDes = "#{XYSHFC_20211229_14}", strTips = "#{XYSHFC_20211229_54}",	strPic = "set:SalaryMission image:SalaryMission_13"},
	[15] 	= {strDes = "#{XYSHFC_20211229_15}", strTips = "#{XYSHFC_20211229_55}",	strPic = "set:LongZhengWuZai_Icon1 image:LongZhengWuZai_Icon1_16"},
	[16] 	= {strDes = "#{XYSHFC_20211229_16}", strTips = "#{XYSHFC_20211229_56}",	strPic = "set:Huodong_7 image:Huodong_7_6"},
	[17] 	= {strDes = "#{XYSHFC_20211229_17}", strTips = "#{XYSHFC_20211229_57}",	strPic = "set:Huodong_12 image:Huodong_12_5"},
	[18] 	= {strDes = "#{XYSHFC_20211229_18}", strTips = "#{XYSHFC_20211229_58}",	strPic = "set:SalaryMission image:SalaryMission_11"},
	[19] 	= {strDes = "#{XYSHFC_20211229_19}", strTips = "#{XYSHFC_20211229_59}",	strPic = "set:Huodong_8 image:Huodong_8_16"},
	[20] 	= {strDes = "#{XYSHFC_20211229_20}", strTips = "#{XYSHFC_20211229_60}",	strPic = "set:Huodong_3 image:Huodong_3_2"},
	[21] 	= {strDes = "#{XYSHFC_20211229_21}", strTips = "#{XYSHFC_20211229_61}",	strPic = "set:Huodong_7 image:Huodong_7_6"},
	[22] 	= {strDes = "#{XYSHFC_20211229_22}", strTips = "#{XYSHFC_20211229_62}",	strPic = "set:SalaryMission image:SalaryMission_3"},
	[23] 	= {strDes = "#{XYSHFC_20211229_23}", strTips = "#{XYSHFC_20211229_63}",	strPic = "set:Huodong image:Huodong_2"},
	[24] 	= {strDes = "#{XYSHFC_20211229_24}", strTips = "#{XYSHFC_20211229_64}",	strPic = "set:SalaryMission image:SalaryMission_13"},
	[25] 	= {strDes = "#{XYSHFC_20211229_25}", strTips = "#{XYSHFC_20211229_65}",	strPic = "set:CircularTaskTool22 image:CircularTaskTool22_2"},
	[26] 	= {strDes = "#{XYSHFC_20211229_26}", strTips = "#{XYSHFC_20211229_66}",	strPic = "set:Huodong_7 image:Huodong_7_6"},
	[27] 	= {strDes = "#{XYSHFC_20211229_27}", strTips = "#{XYSHFC_20211229_67}",	strPic = "set:Huodong_12 image:Huodong_12_5"},
	[28] 	= {strDes = "#{XYSHFC_20211229_28}", strTips = "#{XYSHFC_20211229_68}",	strPic = "set:SalaryMission image:SalaryMission_11"},
	[29] 	= {strDes = "#{XYSHFC_20211229_29}", strTips = "#{XYSHFC_20211229_69}",	strPic = "set:Huodong_12 image:Huodong_12_13"},
	[30] 	= {strDes = "#{XYSHFC_20211229_30}", strTips = "#{XYSHFC_20211229_70}",	strPic = "set:LongZhengWuZai_Icon1 image:LongZhengWuZai_Icon1_16"},
	[31] 	= {strDes = "#{XYSHFC_20211229_31}", strTips = "#{XYSHFC_20211229_71}",	strPic = "set:Huodong_7 image:Huodong_7_6"},
	[32] 	= {strDes = "#{XYSHFC_20211229_32}", strTips = "#{XYSHFC_20211229_72}",	strPic = "set:SalaryMission image:SalaryMission_3"},
	[33] 	= {strDes = "#{XYSHFC_20211229_33}", strTips = "#{XYSHFC_20211229_73}",	strPic = "set:SalaryMission image:SalaryMission_13"},
	[34] 	= {strDes = "#{XYSHFC_20211229_34}", strTips = "#{XYSHFC_20211229_74}",	strPic = "set:Huodong_8 image:Huodong_8_16"},
	[35] 	= {strDes = "#{XYSHFC_20211229_35}", strTips = "#{XYSHFC_20211229_75}",	strPic = "set:Huodong_3 image:Huodong_3_2"},
	[36] 	= {strDes = "#{XYSHFC_20211229_36}", strTips = "#{XYSHFC_20211229_76}",	strPic = "set:Huodong_7 image:Huodong_7_6"},
	[37] 	= {strDes = "#{XYSHFC_20211229_37}", strTips = "#{XYSHFC_20211229_77}",	strPic = "set:Huodong_12 image:Huodong_12_5"},
	[38] 	= {strDes = "#{XYSHFC_20211229_38}", strTips = "#{XYSHFC_20211229_78}",	strPic = "set:SalaryMission image:SalaryMission_11"},
	[39] 	= {strDes = "#{XYSHFC_20211229_39}", strTips = "#{XYSHFC_20211229_79}",	strPic = "set:LongZhengWuZai_Icon1 image:LongZhengWuZai_Icon1_16"},
	[40] 	= {strDes = "#{XYSHFC_20211229_40}", strTips = "#{XYSHFC_20211229_80}",	strPic = "set:CircularTaskTool22 image:CircularTaskTool22_2"},
}

-- ������밴ť����Ӧ
-- nOpType 1 ������Ŀ��ʾ�� nOpType 2 Ѱ·
local g_tabEventClickInfo = 
{
	[1] 	= {nOpType= 1, nSceneID = 0, nPosX = 0,		nPoxZ = 0,		strNPCName = "", strShow = "#{XYSHFC_20211229_81}", },	-- ������Ŀ��ʾ1
	[2] 	= {nOpType= 2, nSceneID = 2, nPosX = 274,	nPoxZ = 95,		strNPCName = "���ٸ�", strShow = "", },	-- �Զ�Ѱ·������274��95�����ٸ���
	[3] 	= {nOpType= 2, nSceneID = 1, nPosX = 130, 	nPoxZ = 230,	strNPCName = "���º�", strShow = "", },	-- �Զ�Ѱ·�����ݣ�130��230�����º紦
	[4] 	= {nOpType= 1, nSceneID = 0, nPosX = 0, 	nPoxZ = 0,		strNPCName = "", strShow = "#{XYSHFC_20211229_82}", },	-- ������Ŀ��ʾ9
	[5] 	= {nOpType= 1, nSceneID = 0, nPosX = 0,		nPoxZ = 0,		strNPCName = "", strShow = "#{XYSHFC_20211229_83}", },	-- ������Ŀ��ʾ10
	[6] 	= {nOpType= 1, nSceneID = 0, nPosX = 0,		nPoxZ = 0,		strNPCName = "", strShow = "#{XYSHFC_20211229_84}", },	-- ������Ŀ��ʾ2
	[7] 	= {nOpType= 2, nSceneID = 1, nPosX = 62,	nPoxZ = 162,	strNPCName = "Ǯ����", strShow = "", },	-- �Զ�Ѱ·�����ݣ�62��162��Ǯ���
	[8] 	= {nOpType= 1, nSceneID = 0, nPosX = 0, 	nPoxZ = 0,		strNPCName = "", strShow = "#{XYSHFC_20211229_85}", },	-- ������Ŀ��ʾ11
	[9] 	= {nOpType= 1, nSceneID = 0, nPosX = 0,		nPoxZ = 0,		strNPCName = "", strShow = "#{XYSHFC_20211229_86}", },	-- ������Ŀ��ʾ12
	[10] 	= {nOpType= 1, nSceneID = 0, nPosX = 0,		nPoxZ = 0,		strNPCName = "", strShow = "#{XYSHFC_20211229_87}", },	-- ������Ŀ��ʾ9
	[11] 	= {nOpType= 1, nSceneID = 0, nPosX = 0,		nPoxZ = 0,		strNPCName = "", strShow = "#{XYSHFC_20211229_88}", },	-- ������Ŀ��ʾ3
	[12] 	= {nOpType= 2, nSceneID = 1, nPosX = 127,	nPoxZ = 133,	strNPCName = "��d", strShow = "", },	-- �Զ�Ѱ·�����ݣ�127��133����d��
	[13] 	= {nOpType= 2, nSceneID = 1, nPosX = 168,	nPoxZ = 168,	strNPCName = "���岩", strShow = "", },	-- �Զ�Ѱ·�����ݣ�168��168�����岩��
	[14] 	= {nOpType= 2, nSceneID = 1, nPosX = 130, 	nPoxZ = 230,	strNPCName = "���º�", strShow = "", },	-- �Զ�Ѱ·�����ݣ�130��230�����º紦
	[15] 	= {nOpType= 2, nSceneID = 4, nPosX = 70,	nPoxZ = 119,	strNPCName = "���", strShow = "", },	-- �Զ�Ѱ·��̫����70��119����ٴ�
	[16] 	= {nOpType= 1, nSceneID = 0, nPosX = 0,		nPoxZ = 0,		strNPCName = "", strShow = "#{XYSHFC_20211229_89}", },	-- ������Ŀ��ʾ4
	[17] 	= {nOpType= 2, nSceneID = 1, nPosX = 62,	nPoxZ = 162,	strNPCName = "Ǯ����", strShow = "", },	-- �Զ�Ѱ·�����ݣ�62��162��Ǯ���
	[18] 	= {nOpType= 2, nSceneID = 2, nPosX = 274,	nPoxZ = 95,		strNPCName = "���ٸ�", strShow = "", },	-- �Զ�Ѱ·������274��95�����ٸ���
	[19] 	= {nOpType= 2, nSceneID = 2, nPosX = 50,	nPoxZ = 152,	strNPCName = "������", strShow = "", },	-- �Զ�Ѱ·������50��152�������ٴ�
	[20] 	= {nOpType= 2, nSceneID = 0, nPosX = 194,	nPoxZ = 180,	strNPCName = "", strShow = "", },	-- �Զ�Ѱ·��������194��180����������
	[21] 	= {nOpType= 1, nSceneID = 0, nPosX = 0,		nPoxZ = 0,		strNPCName = "", strShow = "#{XYSHFC_20211229_90}", },	-- ������Ŀ��ʾ5
	[22] 	= {nOpType= 1, nSceneID = 0, nPosX = 0,		nPoxZ = 0,		strNPCName = "", strShow = "#{XYSHFC_20211229_91}", },	-- ������Ŀ��ʾ13
	[23] 	= {nOpType= 1, nSceneID = 0, nPosX = 0,		nPoxZ = 0,		strNPCName = "", strShow = "#{XYSHFC_20211229_92}", },	-- ������Ŀ��ʾ12
	[24] 	= {nOpType= 2, nSceneID = 1, nPosX = 130, 	nPoxZ = 230,	strNPCName = "���º�", strShow = "", },	-- �Զ�Ѱ·�����ݣ�130��230�����º紦
	[25] 	= {nOpType= 1, nSceneID = 0, nPosX = 0,		nPoxZ = 0,		strNPCName = "", strShow = "#{XYSHFC_20211229_93}", },	-- ������Ŀ��ʾ9
	[26] 	= {nOpType= 1, nSceneID = 0, nPosX = 0,		nPoxZ = 0,		strNPCName = "", strShow = "#{XYSHFC_20211229_94}", },	-- ������Ŀ��ʾ6
	[27] 	= {nOpType= 2, nSceneID = 1, nPosX = 62,	nPoxZ = 162,	strNPCName = "Ǯ����", strShow = "", },	-- �Զ�Ѱ·�����ݣ�62��162��Ǯ���
	[28] 	= {nOpType= 2, nSceneID = 2, nPosX = 274,	nPoxZ = 95,		strNPCName = "���ٸ�", strShow = "", },	-- �Զ�Ѱ·������274��95�����ٸ���
	[29] 	= {nOpType= 2, nSceneID = 1, nPosX = 127,	nPoxZ = 133,	strNPCName = "��d", strShow = "", },	-- �Զ�Ѱ·�����ݣ�127��133����d��
	[30] 	= {nOpType= 2, nSceneID = 4, nPosX = 70,	nPoxZ = 119,	strNPCName = "���", strShow = "", },	-- �Զ�Ѱ·��̫����70��119����ٴ�
	[31] 	= {nOpType= 1, nSceneID = 0, nPosX = 0,		nPoxZ = 0,		strNPCName = "", strShow = "#{XYSHFC_20211229_95}", },	-- ������Ŀ��ʾ7
	[32] 	= {nOpType= 1, nSceneID = 0, nPosX = 0,		nPoxZ = 0,		strNPCName = "", strShow = "#{XYSHFC_20211229_96}", },	-- ������Ŀ��ʾ13
	[33] 	= {nOpType= 2, nSceneID = 1, nPosX = 130, 	nPoxZ = 230,	strNPCName = "���º�", strShow = "", },	-- �Զ�Ѱ·�����ݣ�130��230�����º紦
	[34] 	= {nOpType= 2, nSceneID = 2, nPosX = 50,	nPoxZ = 152,	strNPCName = "������", strShow = "", },	-- �Զ�Ѱ·������50��152�������ٴ�
	[35] 	= {nOpType= 2, nSceneID = 0, nPosX = 194,	nPoxZ = 180,	strNPCName = "", strShow = "", },	-- �Զ�Ѱ·��������194��180����������
	[36] 	= {nOpType= 1, nSceneID = 0, nPosX = 0,		nPoxZ = 0,		strNPCName = "", strShow = "#{XYSHFC_20211229_97}", },	-- ������Ŀ��ʾ8
	[37] 	= {nOpType= 2, nSceneID = 1, nPosX = 62,	nPoxZ = 162,	strNPCName = "Ǯ����", strShow = "", },	-- �Զ�Ѱ·�����ݣ�62��162��Ǯ���
	[38] 	= {nOpType= 2, nSceneID = 2, nPosX = 274,	nPoxZ = 95,		strNPCName = "���ٸ�", strShow = "", },	-- �Զ�Ѱ·������274��95�����ٸ���
	[39] 	= {nOpType= 2, nSceneID = 4, nPosX = 70,	nPoxZ = 119,	strNPCName = "���", strShow = "", },	-- �Զ�Ѱ·��̫����70��119����ٴ�
	[40] 	= {nOpType= 1, nSceneID = 0, nPosX = 0,		nPoxZ = 0,		strNPCName = "", strShow = "#{XYSHFC_20211229_98}", },	-- ������Ŀ��ʾ9
}

-- �ۼƵ���������Ϣ
local g_tabPointRewardInfo = 
{
	[1] = {nNeedPoint = 5, 	nRewardItemID = 38002535, nRewardItemNum = 2, nNeedBagSpace = 2, nNeedMatSpace = 0, },
	[2] = {nNeedPoint = 10, nRewardItemID = 38002535, nRewardItemNum = 2, nNeedBagSpace = 2, nNeedMatSpace = 0, },
	[3] = {nNeedPoint = 15, nRewardItemID = 38002535, nRewardItemNum = 3, nNeedBagSpace = 3, nNeedMatSpace = 0, },
	[4] = {nNeedPoint = 25, nRewardItemID = 38002535, nRewardItemNum = 3, nNeedBagSpace = 3, nNeedMatSpace = 0, },
	[5] = {nNeedPoint = 35, nRewardItemID = 38002536, nRewardItemNum = 4, nNeedBagSpace = 4, nNeedMatSpace = 0, },
}

--=========================================================
-- PreLoad
--=========================================================
function PetSoul_FengHunLu_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("OBJECT_CARED_EVENT")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
	if 1 == bCaredItem then
		this:RegisterEvent("PACKAGE_ITEM_CHANGED")
	end
	if 1 == bCaredMoney then
		this:RegisterEvent("UNIT_MONEY")
		this:RegisterEvent("MONEYJZ_CHANGE")
	end
	if 1 == bCaredYuanBao then
		this:RegisterEvent("UPDATE_YUANBAO")
	end
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")

	-- ͬ��ˢ����һ�Ծ��Ϣ
	this:RegisterEvent("ZHOUHUOYUE_UPDATE")
end

--=========================================================
-- OnLoad
--=========================================================
function PetSoul_FengHunLu_OnLoad()
	g_PetSoul_FengHunLu_Frame_UnifiedPosition = PetSoul_FengHunLu_FrameFull:GetProperty("UnifiedPosition")

	-- PetSoul_FengHunLu_OK_Button : SetEvent("Clicked", "PetSoul_FengHunLu_ConfirmClick()")

	g_contorlPage[1]				= PetSoul_FengHunLu_Day1
	g_contorlPage[2]				= PetSoul_FengHunLu_Day2
	g_contorlPage[3]				= PetSoul_FengHunLu_Day3
	g_contorlPage[4]				= PetSoul_FengHunLu_Day4
	g_contorlPage[5]				= PetSoul_FengHunLu_Day5
	g_contorlPage[6]				= PetSoul_FengHunLu_Day6
	g_contorlPage[7]				= PetSoul_FengHunLu_Day7
	g_contorlPage[8]				= PetSoul_FengHunLu_Day8

	g_contorlPageTips[1]			= PetSoul_FengHunLu_Day1_tips
	g_contorlPageTips[2]			= PetSoul_FengHunLu_Day2_tips
	g_contorlPageTips[3]			= PetSoul_FengHunLu_Day3_tips
	g_contorlPageTips[4]			= PetSoul_FengHunLu_Day4_tips
	g_contorlPageTips[5]			= PetSoul_FengHunLu_Day5_tips
	g_contorlPageTips[6]			= PetSoul_FengHunLu_Day6_tips
	g_contorlPageTips[7]			= PetSoul_FengHunLu_Day7_tips
	g_contorlPageTips[8]			= PetSoul_FengHunLu_Day8_tips

	g_contorlEventIcon[1]			= PetSoul_FengHunLu_Lace1_Icon
	g_contorlEventIcon[2]			= PetSoul_FengHunLu_Lace2_Icon
	g_contorlEventIcon[3]			= PetSoul_FengHunLu_Lace3_Icon
	g_contorlEventIcon[4]			= PetSoul_FengHunLu_Lace4_Icon
	g_contorlEventIcon[5]			= PetSoul_FengHunLu_Lace5_Icon

	g_contorlEventDes[1]			= PetSoul_FengHunLu_Lace1_Text1
	g_contorlEventDes[2]			= PetSoul_FengHunLu_Lace2_Text1
	g_contorlEventDes[3]			= PetSoul_FengHunLu_Lace3_Text1
	g_contorlEventDes[4]			= PetSoul_FengHunLu_Lace4_Text1
	g_contorlEventDes[5]			= PetSoul_FengHunLu_Lace5_Text1

	g_contorlEventProcess[1]		= PetSoul_FengHunLu_Lace1_Text2
	g_contorlEventProcess[2]		= PetSoul_FengHunLu_Lace2_Text2
	g_contorlEventProcess[3]		= PetSoul_FengHunLu_Lace3_Text2
	g_contorlEventProcess[4]		= PetSoul_FengHunLu_Lace4_Text2
	g_contorlEventProcess[5]		= PetSoul_FengHunLu_Lace5_Text2

	g_contorlEventReward[1]			= PetSoul_FengHunLu_Lace1_Text3
	g_contorlEventReward[2]			= PetSoul_FengHunLu_Lace2_Text3
	g_contorlEventReward[3]			= PetSoul_FengHunLu_Lace3_Text3
	g_contorlEventReward[4]			= PetSoul_FengHunLu_Lace4_Text3
	g_contorlEventReward[5]			= PetSoul_FengHunLu_Lace5_Text3

	g_contorlEventButton[1]			= PetSoul_FengHunLu_Lace1_Go
	g_contorlEventButton[2]			= PetSoul_FengHunLu_Lace2_Go
	g_contorlEventButton[3]			= PetSoul_FengHunLu_Lace3_Go
	g_contorlEventButton[4]			= PetSoul_FengHunLu_Lace4_Go
	g_contorlEventButton[5]			= PetSoul_FengHunLu_Lace5_Go

	g_contorlEventButtonHotP[1]		= PetSoul_FengHunLu_Lace1_Go_tips
	g_contorlEventButtonHotP[2]		= PetSoul_FengHunLu_Lace2_Go_tips
	g_contorlEventButtonHotP[3]		= PetSoul_FengHunLu_Lace3_Go_tips
	g_contorlEventButtonHotP[4]		= PetSoul_FengHunLu_Lace4_Go_tips
	g_contorlEventButtonHotP[5]		= PetSoul_FengHunLu_Lace5_Go_tips

	g_contorlEventGetedPic[1]		= PetSoul_FengHunLu_Lace1_Get
	g_contorlEventGetedPic[2]		= PetSoul_FengHunLu_Lace2_Get
	g_contorlEventGetedPic[3]		= PetSoul_FengHunLu_Lace3_Get
	g_contorlEventGetedPic[4]		= PetSoul_FengHunLu_Lace4_Get
	g_contorlEventGetedPic[5]		= PetSoul_FengHunLu_Lace5_Get

	g_contorlPointReward[1]			= PetSoul_FengHunLu_Award1
	g_contorlPointReward[2]			= PetSoul_FengHunLu_Award2
	g_contorlPointReward[3]			= PetSoul_FengHunLu_Award3
	g_contorlPointReward[4]			= PetSoul_FengHunLu_Award4
	g_contorlPointReward[5]			= PetSoul_FengHunLu_Award5

	g_contorlPointRewardGeted[1]	= PetSoul_FengHunLu_Award1_Get
	g_contorlPointRewardGeted[2]	= PetSoul_FengHunLu_Award2_Get
	g_contorlPointRewardGeted[3]	= PetSoul_FengHunLu_Award3_Get
	g_contorlPointRewardGeted[4]	= PetSoul_FengHunLu_Award4_Get
	g_contorlPointRewardGeted[5]	= PetSoul_FengHunLu_Award5_Get

end

--=========================================================
-- OnEvent
--=========================================================
function PetSoul_FengHunLu_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == g_nUICommandID ) then
		-- 0 �ر�, 1 ��, 2 ˢ��, 3 ����ȷ�Ͽ�
		local nOpType 	= Get_XParam_INT(0)

		-- �رս���
		if 0 == nOpType then	
			if this:IsVisible() then
				PetSoul_FengHunLu_OnClose()
			end
		end

		-- �򿪽���
		if 1 == nOpType then
			-- ��עnpc
			-- if 1 == bCaredObj then
				-- local nServerObjID 	= Get_XParam_INT(1)
				-- if nServerObjID == nil or nServerObjID < 0 then
					-- if this:IsVisible() then
						-- PetSoul_FengHunLu_OnClose()
					-- end
				-- end
				-- g_nServerObjID = nServerObjID
				-- g_nObjCaredIDClient = DataPool : GetNPCIDByServerID(tonumber(nServerObjID))
				-- BeginCareObject_PetSoul_FengHunLu()
			-- end

			-- ��ʾ����
			-- Ϊ�˽�����汻�ڵ������⣬�Ȱѽ������
			-- if this:IsVisible() then
				-- PetSoul_FengHunLu_OnClose()
			-- end
			PetSoul_FengHunLu_Reset()
			PetSoul_FengHunLu_Frame_On_ResetPos()
			this:Show()
			PetSoul_FengHunLu_ParamInit()

			-- ��ʼ��ѡ�з�ҳ
			if g_nFengHunluDayIndex > g_nMaxTotalDay then
				g_nCurPage = g_nMaxTotalDay
			else
				g_nCurPage = g_nFengHunluDayIndex
			end

			PetSoul_FengHunLu_PageClick(g_nCurPage)

			PetSoul_FengHunLu_MoneyUpdate()
			PetSoul_FengHunLu_YuanBaoUpdate()
			PetSoul_FengHunLu_Update(1)
		end
			
		-- ˢ�½���
		if 2 == nOpType then
			-- ��עnpc
			if 1 == bCaredObj then
				local nServerObjID 	= Get_XParam_INT(1)
				if nServerObjID == nil or nServerObjID < 0 then
					if this:IsVisible() then
						PetSoul_FengHunLu_OnClose()
					end
				end
			end
			if this:IsVisible() then
				PetSoul_FengHunLu_ParamInit()
				PetSoul_FengHunLu_Update(0)
			end
		end

		-- ����ȷ�Ͽ�
		if 3 == nOpType then
			local strMsg = Get_XParam_STR(0)
			-- g_nComfirmParam1 = Get_XParam_INT(1)
			-- ["Type"] "Ok" "YesNo"
			MessageBoxSelf3("PetSoul_FengHunLu_OnComfirmedBack", {["Content"] = strMsg,["Type"] = "YesNo", })
		end
	
	-- ͬ��ˢ����һ�Ծ��Ϣ
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 20220604) then
		-- ˢ�½���
		if this:IsVisible() then
			local MaiDianData = Get_XParam_STR(0)
			local L_State = Split(MaiDianData,"|")
			for i = 1,table.getn(L_State) do
				if L_State[i] ~= "" and L_State[i] ~= nil then
					local _,_,PointData,PointLq = string.find(L_State[i],"(.*),(.*)")
					g_MaiDianSaveInfo[i] = {tonumber(PointData),tonumber(PointLq)}
				end
			end
			PetSoul_FengHunLu_Update(0)
		end
	-- ============================================
	-- ͨ���߼�
	elseif ( event == "OBJECT_CARED_EVENT" ) and 1 == bCaredObj then
		if(tonumber(arg0) ~= g_nObjCaredIDClient) then
			return
		end
		-- �����NPC�ľ������һ��������߱�ɾ�����Զ��ر�
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			-- �رս���
			PetSoul_FengHunLu_OnClose()
		end	

	-- ��Ʒ�ı�
	elseif ( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() and 1 == bCaredItem ) then
		-- ˢ�½���
		if this:IsVisible() then
			PetSoul_FengHunLu_Update(0)
		end

	-- ��Ǯ�ı�
	elseif (event == "UNIT_MONEY" or event == "MONEYJZ_CHANGE") and 1 == bCaredMoney then
		PetSoul_FengHunLu_MoneyUpdate()

	-- Ԫ���ı�
	elseif event == "UPDATE_YUANBAO" and 1 == bCaredYuanBao then
		PetSoul_FengHunLu_YuanBaoUpdate()

	elseif event == "HIDE_ON_SCENE_TRANSED" then
		PetSoul_FengHunLu_OnClose()
	
	elseif (event == "ADJEST_UI_POS" ) then
		PetSoul_FengHunLu_Frame_On_ResetPos()

	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		PetSoul_FengHunLu_Frame_On_ResetPos()
		
	end
end

--=========================================================
-- ���������ʼ��
--=========================================================
function PetSoul_FengHunLu_ParamInit()
	g_nFengHunluDayIndex 	= Get_XParam_INT(1)
	-- g_nMDMaiDian01			= Get_XParam_INT(2)
	-- g_nMDMaiDian02 			= Get_XParam_INT(3)
	-- g_nMDReward01 			= Get_XParam_INT(4)
	-- g_nMDReward02 			= Get_XParam_INT(5)
	g_nHuoYuePoint 			= Get_XParam_INT(2)
	local EndDayTime = Get_XParam_INT(3)
	g_AllTotalPoint = Get_XParam_INT(4)
	g_nEndYear,g_nEndMonth,g_nEndDay	=	math.floor(EndDayTime/10000),math.mod((math.floor(EndDayTime/100)),100),math.mod(EndDayTime,100)
	local MaiDianData = Get_XParam_STR(0)
	local L_State = Split(MaiDianData,"|")
	for i = 1,table.getn(L_State) do
		if L_State[i] ~= "" and L_State[i] ~= nil then
			local _,_,PointData,PointLq = string.find(L_State[i],"(.*),(.*)")
			g_MaiDianSaveInfo[i] = {tonumber(PointData),tonumber(PointLq)}
		end
	end
	-- PushDebugMessage("g_nFengHunluDayIndex:"..g_nFengHunluDayIndex)
	-- PushDebugMessage("g_nMDMaiDian01:"..g_nMDMaiDian01..",g_nMDMaiDian02:"..g_nMDMaiDian02)
	-- PushDebugMessage("g_nMDReward01:"..g_nMDReward01..",g_nMDReward02:"..g_nMDReward02)

	if g_nFengHunluDayIndex <= 0 then
		PetSoul_FengHunLu_OnClose()
	end

end

function GetBitValueInUINT(nSavePos)
	-- PushDebugMessage("nSavePos  "..nSavePos)
	-- g_MaiDianSaveInfo[nSavePos][2]
	return 1,g_MaiDianSaveInfo[nSavePos][2]
end

--=========================================================
-- �������
--=========================================================
-- !!!reloadscript =PetSoul_FengHunLu
function PetSoul_FengHunLu_Update(bOpen)
	local nOpenDays = g_nFengHunluDayIndex
	if nOpenDays > g_nMaxTotalDay then
		nOpenDays = g_nMaxTotalDay
	end

	if nil == g_nCurPage or g_nCurPage <= 0 or g_nCurPage > nOpenDays then
		return
	end

	-- ҳǩѡ���߼�
	for i = 1, g_nMaxTotalDay do
		g_contorlPage[i] : SetCheck(0)
	end
	g_contorlPage[g_nCurPage] : SetCheck(1)

	-- ��������չʾ
	for i = 1, table.getn(g_tabPointRewardInfo) do
		tPointRewardInfo = g_tabPointRewardInfo[i]
		-- local theAction = DataPool:CreateBindActionItemForShow(tPointRewardInfo.nRewardItemID, 1)
		local theAction = GemMelting:UpdateProductAction(tPointRewardInfo.nRewardItemID)
		g_contorlPointReward[i]:SetProperty("CornerChar", string.format( "BotRight %s", tPointRewardInfo.nRewardItemNum ));
		g_contorlPointReward[i] : SetActionItem(theAction:GetID())
		local bGeted = PetSoul_FengHunLu_GetPointRewardFlag(i)
		if 1 == bGeted then
			g_contorlPointRewardGeted[i] : Show()
		else
			g_contorlPointRewardGeted[i] : Hide()
		end
	end

	-- ������չʾ
	local nTotalPoint = PetSoul_FengHunLu_GetTotalPoint()
	local strTipsForProgress = string.format("#Y�ѻ��%s���������", tostring(nTotalPoint))
	PetSoul_FengHunLu_EXPTip : SetToolTip(strTipsForProgress)
	PetSoul_FengHunLu_EXP : SetProgress(tonumber(nTotalPoint), g_nMaxPoint)	

	-- ��ֹʱ����ʾ
	PetSoul_FengHunLu_Condition_Text : SetText( string.format("#Y%s��%s��%s��24ʱǰ�����Ŀ����ɻ���������", g_nEndYear, g_nEndMonth, g_nEndDay ))		
	-- ���������з�ҳ�ĺ��
	for i = 1, g_nMaxTotalDay do
		g_contorlPageTips[i] : Hide()
	end
	-- ��ʾ��ҳ�¼���Ϣ
	for i = 1, g_nMaxEventPerDay do
		local nMaiDianID, nCurMaiDianValue, nNeedMaiDianValue, nGetRewardPoint, bEventRewardFlag, bFinish, nEventIndex = PetSoul_FengHunLu_GetEventDetailInfo(g_nCurPage, i)

		-- PushDebugMessage("nMaiDianID"..nMaiDianID.."nCurMaiDianValue"..nCurMaiDianValue)

		local tEventShowInfo 	= g_tabEventShowInfo[nEventIndex]
		local tEventClickInfo 	= g_tabEventClickInfo[nEventIndex]

		if nil == tEventShowInfo or nil == tEventClickInfo then
			return
		end

		g_contorlEventIcon[i] 		: SetProperty("Image", tEventShowInfo.strPic)
		g_contorlEventDes[i] 		: SetText( tEventShowInfo.strDes )
		g_contorlEventProcess[i] 	: SetText( string.format("��ǰ���ȣ�%s/%s", nCurMaiDianValue, nNeedMaiDianValue ))
		g_contorlEventReward[i] 	: SetText( string.format("��ɻ���������%s", nGetRewardPoint ))
		g_contorlEventButton[i] 	: SetToolTip(tEventShowInfo.strTips)

		g_contorlEventButton[i] : Show()
		g_contorlEventGetedPic[i] : Hide()
		g_contorlEventButtonHotP[i] : Hide()
		
		if 0 == bFinish then
			-- ǰ��
			g_contorlEventButton[i] : SetText( "ǰ��" )
		elseif 0 == bEventRewardFlag then
			-- ��ȡ
			g_contorlEventButton[i] : SetText( "#{XYSHFC_20211229_106}" )
			g_contorlEventButtonHotP[i] : Show()
		else
			-- ����ȡ
			g_contorlEventButton[i] : Hide()
			g_contorlEventGetedPic[i] : Show()
		end

	end
	
end

--=========================================================
-- ��ȡ����ֵ
--=========================================================
function PetSoul_FengHunLu_GetMaiDianValue(nMaiDianID)
	return g_MaiDianSaveInfo[nMaiDianID][1]
end

--=========================================================
-- ��ȡ�¼������Ƿ�����ȡ��� nDay ��x��[1,8]�� nIndexOfDay[1,5] ����ĵ�x���¼�
-- MD01 MD02 һ��ʹ�� ÿ�����5���� ���8�� ����40���� �ӵ�1λ��ʼʹ��
-- �����Ƿ�����-1 
--=========================================================
function PetSoul_FengHunLu_GetEventRewardFlag(nDayIndex,nIndexOfDay)
	if nil == nIndexOfDay or nIndexOfDay < 1 or nIndexOfDay > g_nMaxEventPerDay then
		return -1
	end
	-- ��λȡ���[0,31]
	-- g_tabMaiDianSaveInfo
	if g_MaiDianSaveInfo[nIndexOfDay][2] >= g_tabEventInfo[nDayIndex][nIndexOfDay].OverConut then
		return 1
	end
	return 0
end

--**********************************
-- ���ÿ��Ļ�¼���������Ϣ
--**********************************
function PetSoul_FengHunLu_GetEventDetailInfo(nDayIndex, nIndexOfDay)

	if nil == nDayIndex or nDayIndex <= 0 then 
		return 0, 0, 0, 0, 0, 0
	end

	if nil == nIndexOfDay or nIndexOfDay <= 0 then 
		return 0, 0, 0, 0, 0, 0
	end

	local tableDayInfo = g_tabEventInfo[nDayIndex]
	if nil == tableDayInfo then
		return 0, 0, 0, 0, 0, 0
	end

	local tableEventInfo = tableDayInfo[nIndexOfDay]
	if nil == tableEventInfo then
		return 0, 0, 0, 0, 0, 0
	end

	local nMaiDianID 			= tableEventInfo.nMaiDianID
	local nNeedMaiDianValue 	= tableEventInfo.nMaiDianValue
	local nGetRewardPoint 		= tableEventInfo.nGetPoint
	local nEventIndex 			= tableEventInfo.nEventIndex
	local bEventRewardFlag		= PetSoul_FengHunLu_GetEventRewardFlag(nDayIndex,nIndexOfDay)
	local bFinish				= 0
	local nCurMaiDianValue		= 0

	if nMaiDianID > 0 then
		-- �������
		local tableMaiDianInfo = g_tabMaiDianSaveInfo[nMaiDianID]
		if nil == tableMaiDianInfo then
			return 0, 0, 0, 0, 0, 0
		end

		nCurMaiDianValue = PetSoul_FengHunLu_GetMaiDianValue(nIndexOfDay)
	elseif -1 == nMaiDianID then
		-- ��д ÿ�ջ�Ծ����
		nCurMaiDianValue = g_nHuoYuePoint
		-- �Ѿ���ȡ�� ��д�����
		if 1 == bEventRewardFlag then
			nCurMaiDianValue = nNeedMaiDianValue
		end
	else
		return 0, 0, 0, 0, 0, 0
	end

	if nCurMaiDianValue >= nNeedMaiDianValue then
		bFinish = 1
		nCurMaiDianValue = nNeedMaiDianValue
	end

	return nMaiDianID, nCurMaiDianValue, nNeedMaiDianValue, nGetRewardPoint, bEventRewardFlag, bFinish, nEventIndex
end

--**********************************
-- ��������ȡ����
--**********************************
function PetSoul_FengHunLu_GetTotalPoint()
	local nTotalPoint = g_AllTotalPoint
	return nTotalPoint
end

--**********************************
-- ��ȡ�ۻ����ֽ����Ƿ�����ȡ��� nPointRewardLevel[1,10] ��x�����ֽ����ȼ�
-- MD02 ���λ��ʼʹ��
-- �����Ƿ�����-1 
--**********************************
function PetSoul_FengHunLu_GetPointRewardFlag(nPointRewardLevel)
	-- ��λȡ���[0,31]
	local nRet = DataPool:GetPlayerMission_DataRound(463)
	if nRet >= nPointRewardLevel then
		return 1
	end
	return 0
end

--=========================================================
-- ����ȷ�Ͽ�ص� ["Type"] "Ok"�ķ���ֵ��"Ok"�� ["Type"] "YesNo"�ķ���ֵ�� "Yes" "No"
--=========================================================
function PetSoul_FengHunLu_OnComfirmedBack(strRet)
	if nil == strRet then
		return
	end

	if "Yes" == strRet or "Ok" == strRet then

	end

	if "No" == strRet then
		
	end
end

--=========================================================
-- ��ҳ
--=========================================================
function PetSoul_FengHunLu_PageClick(nPage)
	if nil == nPage or nPage <= 0 or nPage > g_nMaxTotalDay then
		return
	end

	if g_nCurPage == nPage then
		return
	end

	-- ��ҳδ����
	local nOpenDays = g_nFengHunluDayIndex
	if nOpenDays > g_nMaxTotalDay then
		nOpenDays = g_nMaxTotalDay
	end
	if nPage > nOpenDays then
		PushDebugMessage(string.format("#H��ҳ���ڵ�%s��ɿ�����", nPage))
		-- ����ҲҪˢ�� ��Ȼ���水ť���Զ���check
		PetSoul_FengHunLu_Update(bOpen)
		return
	end

	g_nCurPage = nPage
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "AskChangeMainUI" ); 	
		Set_XSCRIPT_ScriptID( 791010 );						-- �ű����
		Set_XSCRIPT_Parameter(0,g_nCurPage);
		Set_XSCRIPT_ParamCount( 1 );						-- ��������
	Send_XSCRIPT()	
	-- PetSoul_FengHunLu_Update(0)
end

--=========================================================
-- ��õ����ܽ���
--=========================================================
function PetSoul_FengHunLu_GetAwardClick()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "GetRewardOfPoint" )
		Set_XSCRIPT_ScriptID(791010)
		Set_XSCRIPT_ParamCount(0)
	Send_XSCRIPT()
end

--=========================================================
-- ������ť
--=========================================================
function PetSoul_FengHunLu_OnClickHelp()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "ShowHelp" )
		Set_XSCRIPT_ScriptID(791010)			
		Set_XSCRIPT_ParamCount(0)
	Send_XSCRIPT()
end

--=========================================================
-- ÿ���¼����
--=========================================================
function PetSoul_FengHunLu_Item_Clicked(nIndexOfDay)

	-- PushDebugMessage("PetSoul_FengHunLu_Item_Clicked")

	if nil == nIndexOfDay or nIndexOfDay <=0 or nIndexOfDay > g_nMaxEventPerDay then
		return
	end

	local nOpenDays = g_nFengHunluDayIndex
	if nOpenDays > g_nMaxTotalDay then
		nOpenDays = g_nMaxTotalDay
	end

	if nil == g_nCurPage or g_nCurPage <= 0 or g_nCurPage > nOpenDays then
		return
	end

	local nMaiDianID, nCurMaiDianValue, nNeedMaiDianValue, nGetRewardPoint, bEventRewardFlag, bFinish, nEventIndex = PetSoul_FengHunLu_GetEventDetailInfo(g_nCurPage, nIndexOfDay)

	if 1 == bEventRewardFlag then
		return
	end

	-- PushDebugMessage("PetSoul_FengHunLu_Item_Clicked"..",bFinish:"..bFinish..",bEventRewardFlag:"..bEventRewardFlag)

	if 1 == bFinish then
		-- �콱
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "GetRewardOfEvent" )
			Set_XSCRIPT_ScriptID(791010)
			Set_XSCRIPT_Parameter(0, g_nCurPage)					
			Set_XSCRIPT_Parameter(1, nIndexOfDay)				
			Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT()
	else
		local tEventClickInfo 	= g_tabEventClickInfo[nEventIndex]

		if nil == tEventClickInfo then
			return
		end

		if g_nFengHunluDayIndex < 0 then
			PushDebugMessage("#{XYSHFC_20211229_131}")
		end

		-- ������Ŀ��ʾ
		if 1 == tEventClickInfo.nOpType then
			PushDebugMessage(tEventClickInfo.strShow)
		end

		-- Ѱ·
		if 2 == tEventClickInfo.nOpType then
			PushDebugMessage("�ݲ�֧���Զ�Ѱ·�����ֶ�ǰ��")
		end
	end

end

--=========================================================
-- ���ý���
--=========================================================
function PetSoul_FengHunLu_Reset()
	g_nCurPage 				= 1
	g_nFengHunluDayIndex 	= 0
	g_nMDMaiDian01			= 0
	g_nMDMaiDian02 			= 0
	g_nMDReward01 			= 0
	g_nMDReward02 			= 0
	g_nHuoYuePoint 			= 0
	g_nEndYear 				= 0
	g_nEndMonth 			= 0
	g_nEndDay 				= 0
end

--=========================================================
-- �رս���
--=========================================================
function PetSoul_FengHunLu_OnClose()	
	this:Hide()
	StopCareObject_PetSoul_FengHunLu()
	-- ����
	PetSoul_FengHunLu_Reset()
end

--=========================================================
-- ��������
-- <Event Name="Hidden" Function="PetSoul_FengHunLu_OnHiden();" />
--=========================================================
function PetSoul_FengHunLu_OnHiden()
	StopCareObject_PetSoul_FengHunLu()
	-- ����
	PetSoul_FengHunLu_Reset()
end

--=========================================================
-- ���Ĳ���
--=========================================================
function BeginCareObject_PetSoul_FengHunLu()
	-- ����
	this:CareObject(g_nObjCaredIDClient, 1, "PetSoul_FengHunLu")
end

function StopCareObject_PetSoul_FengHunLu()
	-- ȡ������
	if nil ~= g_nObjCaredIDClient and g_nObjCaredIDClient > 0 then
		this:CareObject(g_nObjCaredIDClient, 0, "PetSoul_FengHunLu")
	end
	g_nServerObjID = -1
end

--=========================================================
-- ��Ǯˢ�£�������µ���һ�� ��Ǯ�¼�����һ��
--=========================================================
function PetSoul_FengHunLu_MoneyUpdate()
	-- PetSoul_FengHunLu_HaveJiaoZiNum : SetProperty( "MoneyNumber", tostring(Player:GetData("MONEY_JZ")) )
	-- PetSoul_FengHunLu_HaveGoldNum : SetProperty( "MoneyNumber", tostring(Player:GetData("MONEY")) )
end

--=========================================================
-- Ԫ��ˢ�£�������µ���һ�� Ԫ���¼�����һ��
--=========================================================
function PetSoul_FengHunLu_YuanBaoUpdate()
	-- PetSoul_FengHunLu_HaveYuanBaoNum : SetText (tostring(Player:GetData("YUANBAO")))
end

--=========================================================
-- ����λ��
--=========================================================
function PetSoul_FengHunLu_Frame_On_ResetPos()
	PetSoul_FengHunLu_FrameFull:SetProperty("UnifiedPosition", g_PetSoul_FengHunLu_Frame_UnifiedPosition)
end