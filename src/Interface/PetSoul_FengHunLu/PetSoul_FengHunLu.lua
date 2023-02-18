-- PetSoul_FengHunLu 封魂录 2022-1-5 lishilong
-- !!!reloadscript =PetSoul_FengHunLu
-- !!!reloadscript =MiniMap
-- !!uiopentest = 791010 调指定脚本号的AskOpenMainUI
--Q546528533  仅供娱乐交流，切勿他用！！！
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

-- 每个玩家封魂录的持续时间
local g_nTotalDays				= 14
-- 最大活动天数	
local g_nMaxTotalDay			= 8 
-- 每天最大Event数量	
local g_nMaxEventPerDay			= 5
-- 最大MD存储量	
local g_nMaxSavePos				= 32
-- 最大点数奖励等级
local g_nMaxPointRewardLevel	= 5
-- 最大点数
local g_nMaxPoint				= 40
--服务器数据传递信息
local g_MaiDianSaveInfo = {}
-- 埋点事件的存储索引信息
-- nSaveMD 存储MD nSavePosStart 埋点在本MD的起始索引 
-- nSaveLen 埋点占用的bit数 nMaxValue 埋点数据最大值(严格小于等于(2^nSaveLen) - 1，并且留出了一定得弹性空间)
-- 参考1 回流英雄之路 #define HEROESRETURNS_TASK_INDEX_0		0	// 添加1个好友 等
-- 参考2 战江湖 892664
local g_tabMaiDianSaveInfo = 
{
	[1] 	= {nSaveMDIndex = 1, nSavePosStart = 8, 	nSaveLen = 12, 	nMaxValue = 2500, },-- 1] 累计杀怪数量 4095 cpp埋点
	[2] 	= {nSaveMDIndex = 1, nSavePosStart = 4, 	nSaveLen = 5, 	nMaxValue = 20, },	-- 2] 老三环 31	
	[3] 	= {nSaveMDIndex = 1, nSavePosStart = 4, 	nSaveLen = 5, 	nMaxValue = 15, },	-- 3] 帮会任务 31
	[4] 	= {nSaveMDIndex = 1, nSavePosStart = 2, 	nSaveLen = 5, 	nMaxValue = 10, },	-- 4] 师门任务 31
	[5] 	= {nSaveMDIndex = 1, nSavePosStart = 3, 	nSaveLen = 5, 	nMaxValue = 9, },	-- 5] 燕子 31
	[6] 	= {nSaveMDIndex = 2, nSavePosStart = 4, 	nSaveLen = 3, 	nMaxValue = 4, },	-- 6] 棋局 7
	[7] 	= {nSaveMDIndex = 2, nSavePosStart = 4, 	nSaveLen = 3, 	nMaxValue = 4, },	-- 7] 快活三 7
	[8] 	= {nSaveMDIndex = 2, nSavePosStart = 2, 	nSaveLen = 3, 	nMaxValue = 2, },	-- 8] 跑商 7
	[9] 	= {nSaveMDIndex = 2, nSavePosStart = 2, 	nSaveLen = 3, 	nMaxValue = 2, },	-- 9] 科举 7
	[10] 	= {nSaveMDIndex = 2, nSavePosStart = 2, 	nSaveLen = 3, 	nMaxValue = 2, },	-- 10 前世今生 7
	[11] 	= {nSaveMDIndex = 2, nSavePosStart = 2, 	nSaveLen = 3, 	nMaxValue = 2, },	-- 11 逞凶打图 7
	[12] 	= {nSaveMDIndex = 2, nSavePosStart = 1, 	nSaveLen = 2, 	nMaxValue = 1, },	-- 12 校场比武 3 cpp埋点
	[13] 	= {nSaveMDIndex = 2, nSavePosStart = 1, 	nSaveLen = 2, 	nMaxValue = 1, },	-- 13 百变脸谱 3
	[14] 	= {nSaveMDIndex = 2, nSavePosStart = 1, 	nSaveLen = 2, 	nMaxValue = 100, },	-- 14 活跃度
}

-- 每天的事件信息 完成依赖的埋点id 埋点数据值 活得的总活动点数 最后一个暂时废弃
-- 所有负数都是特殊处理的事件，目前-1是每日活跃值
--额，弄了半天 逻辑整错了。。。将错就错吧
local g_tabEventInfo = 
{
	-- 第1天
	-- 击杀100个怪物	1
	-- 参加1次棋局	1
	-- 完成1次我爱幸运快活三	1
	-- 完成5次帮会任务	1
	-- 今日活跃值达到100点	1
	[1] = 
	{
		[1] = {nMaiDianID = 1, 	nMaiDianValue = 100, 	nGetPoint = 1, nEventIndex = 1, 	OverConut = 1},
		[2] = {nMaiDianID = 6, 	nMaiDianValue = 1, 		nGetPoint = 1, nEventIndex = 2, 	OverConut = 1},
		[3] = {nMaiDianID = 7, 	nMaiDianValue = 1, 		nGetPoint = 1, nEventIndex = 3, 	OverConut = 1},
		[4] = {nMaiDianID = 3, 	nMaiDianValue = 1, 		nGetPoint = 1, nEventIndex = 4, 	OverConut = 1},
		[5] = {nMaiDianID = -1, nMaiDianValue = 100, 	nGetPoint = 1, nEventIndex = 5, 	OverConut = 1},
	},
	-- 第2天	
	-- 击杀200个怪物	1
	-- 完成5次老三环	1
	-- 完成1次校场比武	1
	-- 完成1次跑商	1
	-- 完成5次帮会任务	1
	[2] = 
	{
		[1] = {nMaiDianID = 1, 	nMaiDianValue = 200, 	nGetPoint = 1, nEventIndex = 6,  	OverConut = 2},
		[2] = {nMaiDianID = 2, 	nMaiDianValue = 5, 		nGetPoint = 1, nEventIndex = 7,  	OverConut = 1},
		[3] = {nMaiDianID = 12, nMaiDianValue = 1, 		nGetPoint = 1, nEventIndex = 8,  	OverConut = 1},
		[4] = {nMaiDianID = 8, 	nMaiDianValue = 1, 		nGetPoint = 1, nEventIndex = 9,  	OverConut = 1},
		[5] = {nMaiDianID = 3, 	nMaiDianValue = 5, 		nGetPoint = 1, nEventIndex = 10,  	OverConut = 2},
	},

	-- 第3天	
	-- 击杀400个怪物	1
	-- 完成1次逞凶打图	1
	-- 完成1次百变脸谱	1
	-- 完成2次我爱幸运快活三	1
	-- 完成3次燕子	1
	[3] = 
	{
		[1] = {nMaiDianID = 1, 	nMaiDianValue = 400, 	nGetPoint = 1, nEventIndex = 11,  	OverConut = 3},
		[2] = {nMaiDianID = 11, nMaiDianValue = 1, 		nGetPoint = 1, nEventIndex = 12,  	OverConut = 1},
		[3] = {nMaiDianID = 13, nMaiDianValue = 1, 		nGetPoint = 1, nEventIndex = 13,  	OverConut = 1},
		[4] = {nMaiDianID = 7, 	nMaiDianValue = 2, 		nGetPoint = 1, nEventIndex = 14,  	OverConut = 2},
		[5] = {nMaiDianID = 5, 	nMaiDianValue = 3, 		nGetPoint = 1, nEventIndex = 15,  	OverConut = 1},
	},

	-- 第4天	
	-- 击杀700个怪物	1
	-- 完成10次老三环	1
	-- 完成2次棋局	1
	-- 完成1次科举	1
	-- 完成1次前世今生	1
	[4] = 
	{
		[1] = {nMaiDianID = 1, 	nMaiDianValue = 700, 	nGetPoint = 1, nEventIndex = 16,  	OverConut = 4 },
		[2] = {nMaiDianID = 2, 	nMaiDianValue = 10, 	nGetPoint = 1, nEventIndex = 17,  	OverConut = 2 },
		[3] = {nMaiDianID = 6, 	nMaiDianValue = 2, 		nGetPoint = 1, nEventIndex = 18,  	OverConut = 2 },
		[4] = {nMaiDianID = 9, 	nMaiDianValue = 1, 		nGetPoint = 1, nEventIndex = 19,  	OverConut = 1 },
		[5] = {nMaiDianID = 10, nMaiDianValue = 1, 		nGetPoint = 1, nEventIndex = 20,  	OverConut = 1 },
	},

	-- 第5天	
	-- 击杀1000个怪物	1
	-- 完成5个师门任务	1
	-- 完成2次跑商	1
	-- 完成3次我爱幸运快活三	1
	-- 完成10次帮会任务	1
	[5] = 
	{
		[1] = {nMaiDianID = 1, 	nMaiDianValue = 1000, 	nGetPoint = 1, nEventIndex = 21,  	OverConut = 5 },
		[2] = {nMaiDianID = 4, 	nMaiDianValue = 5, 		nGetPoint = 1, nEventIndex = 22,  	OverConut = 1 },
		[3] = {nMaiDianID = 8, 	nMaiDianValue = 2, 		nGetPoint = 1, nEventIndex = 23,  	OverConut = 2 },
		[4] = {nMaiDianID = 7, 	nMaiDianValue = 3, 		nGetPoint = 1, nEventIndex = 24,  	OverConut = 3 },
		[5] = {nMaiDianID = 3, 	nMaiDianValue = 10, 	nGetPoint = 1, nEventIndex = 25,  	OverConut = 3 },
	},

	-- 第6天	
	-- 击杀1500个怪物	1
	-- 完成15次老三环	1
	-- 完成3次棋局	1
	-- 完成2次逞凶打图	1
	-- 完成6次燕子	1
	[6] = 
	{
		[1] = {nMaiDianID = 1, 	nMaiDianValue = 1500, 	nGetPoint = 1, nEventIndex = 26,  	OverConut = 6 },
		[2] = {nMaiDianID = 2, 	nMaiDianValue = 15, 	nGetPoint = 1, nEventIndex = 27,  	OverConut = 3 },
		[3] = {nMaiDianID = 6, 	nMaiDianValue = 3, 		nGetPoint = 1, nEventIndex = 28,  	OverConut = 3 },
		[4] = {nMaiDianID = 11, nMaiDianValue = 2, 		nGetPoint = 1, nEventIndex = 29,  	OverConut = 2 },
		[5] = {nMaiDianID = 5, 	nMaiDianValue = 6, 		nGetPoint = 1, nEventIndex = 30,  	OverConut = 2 },
	},

	-- 第7天	
	-- 击杀2000个怪物
	-- 完成10个师门任务
	-- 完成4次我爱幸运快活三
	-- 完成2次科举
	-- 完成2次前世今生
	[7] = 
	{
		[1] = {nMaiDianID = 1, 	nMaiDianValue = 2000, 	nGetPoint = 1, nEventIndex = 31,   	OverConut = 7},
		[2] = {nMaiDianID = 4, 	nMaiDianValue = 10, 	nGetPoint = 1, nEventIndex = 32,  	OverConut = 2},
		[3] = {nMaiDianID = 7, 	nMaiDianValue = 4, 		nGetPoint = 1, nEventIndex = 33,  	OverConut = 4},
		[4] = {nMaiDianID = 9, 	nMaiDianValue = 2, 		nGetPoint = 1, nEventIndex = 34,   	OverConut = 2},
		[5] = {nMaiDianID = 10, nMaiDianValue = 2, 		nGetPoint = 1, nEventIndex = 35,   	OverConut = 2},
	},

	-- 第8天	
	-- 击杀2500个怪物
	-- 完成20次老三环
	-- 完成4次棋局
	-- 完成9次燕子
	-- 完成15次帮会任务
	[8] = 
	{
		[1] = {nMaiDianID = 1, 	nMaiDianValue = 2500, 	nGetPoint = 1, nEventIndex = 36,   	OverConut = 8},
		[2] = {nMaiDianID = 2, 	nMaiDianValue = 20, 	nGetPoint = 1, nEventIndex = 37,   	OverConut = 4},
		[3] = {nMaiDianID = 6, 	nMaiDianValue = 4, 		nGetPoint = 1, nEventIndex = 38,  	OverConut = 4},
		[4] = {nMaiDianID = 5, 	nMaiDianValue = 9, 		nGetPoint = 1, nEventIndex = 39,   	OverConut = 3},
		[5] = {nMaiDianID = 3, 	nMaiDianValue = 15, 	nGetPoint = 1, nEventIndex = 40,   	OverConut = 4},
	},
}

-- 事件展示
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

-- 点击参与按钮的响应
-- nOpType 1 返回醒目提示， nOpType 2 寻路
local g_tabEventClickInfo = 
{
	[1] 	= {nOpType= 1, nSceneID = 0, nPosX = 0,		nPoxZ = 0,		strNPCName = "", strShow = "#{XYSHFC_20211229_81}", },	-- 返回醒目提示1
	[2] 	= {nOpType= 2, nSceneID = 2, nPosX = 274,	nPoxZ = 95,		strNPCName = "刘仲甫", strShow = "", },	-- 自动寻路至大理（274，95）刘仲甫处
	[3] 	= {nOpType= 2, nSceneID = 1, nPosX = 130, 	nPoxZ = 230,	strNPCName = "柳月虹", strShow = "", },	-- 自动寻路至苏州（130，230）柳月虹处
	[4] 	= {nOpType= 1, nSceneID = 0, nPosX = 0, 	nPoxZ = 0,		strNPCName = "", strShow = "#{XYSHFC_20211229_82}", },	-- 返回醒目提示9
	[5] 	= {nOpType= 1, nSceneID = 0, nPosX = 0,		nPoxZ = 0,		strNPCName = "", strShow = "#{XYSHFC_20211229_83}", },	-- 返回醒目提示10
	[6] 	= {nOpType= 1, nSceneID = 0, nPosX = 0,		nPoxZ = 0,		strNPCName = "", strShow = "#{XYSHFC_20211229_84}", },	-- 返回醒目提示2
	[7] 	= {nOpType= 2, nSceneID = 1, nPosX = 62,	nPoxZ = 162,	strNPCName = "钱宏宇", strShow = "", },	-- 自动寻路至苏州（62，162）钱宏宇处
	[8] 	= {nOpType= 1, nSceneID = 0, nPosX = 0, 	nPoxZ = 0,		strNPCName = "", strShow = "#{XYSHFC_20211229_85}", },	-- 返回醒目提示11
	[9] 	= {nOpType= 1, nSceneID = 0, nPosX = 0,		nPoxZ = 0,		strNPCName = "", strShow = "#{XYSHFC_20211229_86}", },	-- 返回醒目提示12
	[10] 	= {nOpType= 1, nSceneID = 0, nPosX = 0,		nPoxZ = 0,		strNPCName = "", strShow = "#{XYSHFC_20211229_87}", },	-- 返回醒目提示9
	[11] 	= {nOpType= 1, nSceneID = 0, nPosX = 0,		nPoxZ = 0,		strNPCName = "", strShow = "#{XYSHFC_20211229_88}", },	-- 返回醒目提示3
	[12] 	= {nOpType= 2, nSceneID = 1, nPosX = 127,	nPoxZ = 133,	strNPCName = "吴玠", strShow = "", },	-- 自动寻路至苏州（127，133）吴玠处
	[13] 	= {nOpType= 2, nSceneID = 1, nPosX = 168,	nPoxZ = 168,	strNPCName = "文彦博", strShow = "", },	-- 自动寻路至苏州（168，168）文彦博处
	[14] 	= {nOpType= 2, nSceneID = 1, nPosX = 130, 	nPoxZ = 230,	strNPCName = "柳月虹", strShow = "", },	-- 自动寻路至苏州（130，230）柳月虹处
	[15] 	= {nOpType= 2, nSceneID = 4, nPosX = 70,	nPoxZ = 119,	strNPCName = "李纲", strShow = "", },	-- 自动寻路至太湖（70，119）李纲处
	[16] 	= {nOpType= 1, nSceneID = 0, nPosX = 0,		nPoxZ = 0,		strNPCName = "", strShow = "#{XYSHFC_20211229_89}", },	-- 返回醒目提示4
	[17] 	= {nOpType= 2, nSceneID = 1, nPosX = 62,	nPoxZ = 162,	strNPCName = "钱宏宇", strShow = "", },	-- 自动寻路至苏州（62，162）钱宏宇处
	[18] 	= {nOpType= 2, nSceneID = 2, nPosX = 274,	nPoxZ = 95,		strNPCName = "刘仲甫", strShow = "", },	-- 自动寻路至大理（274，95）刘仲甫处
	[19] 	= {nOpType= 2, nSceneID = 2, nPosX = 50,	nPoxZ = 152,	strNPCName = "主考官", strShow = "", },	-- 自动寻路至大理（50，152）主考官处
	[20] 	= {nOpType= 2, nSceneID = 0, nPosX = 194,	nPoxZ = 180,	strNPCName = "", strShow = "", },	-- 自动寻路至洛阳（194，180）诸葛孔亮处
	[21] 	= {nOpType= 1, nSceneID = 0, nPosX = 0,		nPoxZ = 0,		strNPCName = "", strShow = "#{XYSHFC_20211229_90}", },	-- 返回醒目提示5
	[22] 	= {nOpType= 1, nSceneID = 0, nPosX = 0,		nPoxZ = 0,		strNPCName = "", strShow = "#{XYSHFC_20211229_91}", },	-- 返回醒目提示13
	[23] 	= {nOpType= 1, nSceneID = 0, nPosX = 0,		nPoxZ = 0,		strNPCName = "", strShow = "#{XYSHFC_20211229_92}", },	-- 返回醒目提示12
	[24] 	= {nOpType= 2, nSceneID = 1, nPosX = 130, 	nPoxZ = 230,	strNPCName = "柳月虹", strShow = "", },	-- 自动寻路至苏州（130，230）柳月虹处
	[25] 	= {nOpType= 1, nSceneID = 0, nPosX = 0,		nPoxZ = 0,		strNPCName = "", strShow = "#{XYSHFC_20211229_93}", },	-- 返回醒目提示9
	[26] 	= {nOpType= 1, nSceneID = 0, nPosX = 0,		nPoxZ = 0,		strNPCName = "", strShow = "#{XYSHFC_20211229_94}", },	-- 返回醒目提示6
	[27] 	= {nOpType= 2, nSceneID = 1, nPosX = 62,	nPoxZ = 162,	strNPCName = "钱宏宇", strShow = "", },	-- 自动寻路至苏州（62，162）钱宏宇处
	[28] 	= {nOpType= 2, nSceneID = 2, nPosX = 274,	nPoxZ = 95,		strNPCName = "刘仲甫", strShow = "", },	-- 自动寻路至大理（274，95）刘仲甫处
	[29] 	= {nOpType= 2, nSceneID = 1, nPosX = 127,	nPoxZ = 133,	strNPCName = "吴玠", strShow = "", },	-- 自动寻路至苏州（127，133）吴玠处
	[30] 	= {nOpType= 2, nSceneID = 4, nPosX = 70,	nPoxZ = 119,	strNPCName = "李纲", strShow = "", },	-- 自动寻路至太湖（70，119）李纲处
	[31] 	= {nOpType= 1, nSceneID = 0, nPosX = 0,		nPoxZ = 0,		strNPCName = "", strShow = "#{XYSHFC_20211229_95}", },	-- 返回醒目提示7
	[32] 	= {nOpType= 1, nSceneID = 0, nPosX = 0,		nPoxZ = 0,		strNPCName = "", strShow = "#{XYSHFC_20211229_96}", },	-- 返回醒目提示13
	[33] 	= {nOpType= 2, nSceneID = 1, nPosX = 130, 	nPoxZ = 230,	strNPCName = "柳月虹", strShow = "", },	-- 自动寻路至苏州（130，230）柳月虹处
	[34] 	= {nOpType= 2, nSceneID = 2, nPosX = 50,	nPoxZ = 152,	strNPCName = "主考官", strShow = "", },	-- 自动寻路至大理（50，152）主考官处
	[35] 	= {nOpType= 2, nSceneID = 0, nPosX = 194,	nPoxZ = 180,	strNPCName = "", strShow = "", },	-- 自动寻路至洛阳（194，180）诸葛孔亮处
	[36] 	= {nOpType= 1, nSceneID = 0, nPosX = 0,		nPoxZ = 0,		strNPCName = "", strShow = "#{XYSHFC_20211229_97}", },	-- 返回醒目提示8
	[37] 	= {nOpType= 2, nSceneID = 1, nPosX = 62,	nPoxZ = 162,	strNPCName = "钱宏宇", strShow = "", },	-- 自动寻路至苏州（62，162）钱宏宇处
	[38] 	= {nOpType= 2, nSceneID = 2, nPosX = 274,	nPoxZ = 95,		strNPCName = "刘仲甫", strShow = "", },	-- 自动寻路至大理（274，95）刘仲甫处
	[39] 	= {nOpType= 2, nSceneID = 4, nPosX = 70,	nPoxZ = 119,	strNPCName = "李纲", strShow = "", },	-- 自动寻路至太湖（70，119）李纲处
	[40] 	= {nOpType= 1, nSceneID = 0, nPosX = 0,		nPoxZ = 0,		strNPCName = "", strShow = "#{XYSHFC_20211229_98}", },	-- 返回醒目提示9
}

-- 累计点数奖励信息
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

	-- 同步刷新玩家活跃信息
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
		-- 0 关闭, 1 打开, 2 刷新, 3 二次确认框
		local nOpType 	= Get_XParam_INT(0)

		-- 关闭界面
		if 0 == nOpType then	
			if this:IsVisible() then
				PetSoul_FengHunLu_OnClose()
			end
		end

		-- 打开界面
		if 1 == nOpType then
			-- 关注npc
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

			-- 显示界面
			-- 为了解决界面被遮挡的问题，先把界面关了
			-- if this:IsVisible() then
				-- PetSoul_FengHunLu_OnClose()
			-- end
			PetSoul_FengHunLu_Reset()
			PetSoul_FengHunLu_Frame_On_ResetPos()
			this:Show()
			PetSoul_FengHunLu_ParamInit()

			-- 初始化选中分页
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
			
		-- 刷新界面
		if 2 == nOpType then
			-- 关注npc
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

		-- 二次确认框
		if 3 == nOpType then
			local strMsg = Get_XParam_STR(0)
			-- g_nComfirmParam1 = Get_XParam_INT(1)
			-- ["Type"] "Ok" "YesNo"
			MessageBoxSelf3("PetSoul_FengHunLu_OnComfirmedBack", {["Content"] = strMsg,["Type"] = "YesNo", })
		end
	
	-- 同步刷新玩家活跃信息
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 20220604) then
		-- 刷新界面
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
	-- 通用逻辑
	elseif ( event == "OBJECT_CARED_EVENT" ) and 1 == bCaredObj then
		if(tonumber(arg0) ~= g_nObjCaredIDClient) then
			return
		end
		-- 如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			-- 关闭界面
			PetSoul_FengHunLu_OnClose()
		end	

	-- 物品改变
	elseif ( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() and 1 == bCaredItem ) then
		-- 刷新界面
		if this:IsVisible() then
			PetSoul_FengHunLu_Update(0)
		end

	-- 金钱改变
	elseif (event == "UNIT_MONEY" or event == "MONEYJZ_CHANGE") and 1 == bCaredMoney then
		PetSoul_FengHunLu_MoneyUpdate()

	-- 元宝改变
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
-- 界面参数初始化
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
-- 界面更新
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

	-- 页签选中逻辑
	for i = 1, g_nMaxTotalDay do
		g_contorlPage[i] : SetCheck(0)
	end
	g_contorlPage[g_nCurPage] : SetCheck(1)

	-- 点数奖励展示
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

	-- 进度条展示
	local nTotalPoint = PetSoul_FengHunLu_GetTotalPoint()
	local strTipsForProgress = string.format("#Y已获得%s个玉魂铢。", tostring(nTotalPoint))
	PetSoul_FengHunLu_EXPTip : SetToolTip(strTipsForProgress)
	PetSoul_FengHunLu_EXP : SetProgress(tonumber(nTotalPoint), g_nMaxPoint)	

	-- 截止时间显示
	PetSoul_FengHunLu_Condition_Text : SetText( string.format("#Y%s年%s月%s日24时前，完成目标均可获得玉魂铢。", g_nEndYear, g_nEndMonth, g_nEndDay ))		
	-- 先隐藏所有分页的红点
	for i = 1, g_nMaxTotalDay do
		g_contorlPageTips[i] : Hide()
	end
	-- 显示分页事件信息
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
		g_contorlEventProcess[i] 	: SetText( string.format("当前进度：%s/%s", nCurMaiDianValue, nNeedMaiDianValue ))
		g_contorlEventReward[i] 	: SetText( string.format("完成获得玉魂铢：%s", nGetRewardPoint ))
		g_contorlEventButton[i] 	: SetToolTip(tEventShowInfo.strTips)

		g_contorlEventButton[i] : Show()
		g_contorlEventGetedPic[i] : Hide()
		g_contorlEventButtonHotP[i] : Hide()
		
		if 0 == bFinish then
			-- 前往
			g_contorlEventButton[i] : SetText( "前往" )
		elseif 0 == bEventRewardFlag then
			-- 领取
			g_contorlEventButton[i] : SetText( "#{XYSHFC_20211229_106}" )
			g_contorlEventButtonHotP[i] : Show()
		else
			-- 已领取
			g_contorlEventButton[i] : Hide()
			g_contorlEventGetedPic[i] : Show()
		end

	end
	
end

--=========================================================
-- 获取埋点的值
--=========================================================
function PetSoul_FengHunLu_GetMaiDianValue(nMaiDianID)
	return g_MaiDianSaveInfo[nMaiDianID][1]
end

--=========================================================
-- 获取事件奖励是否已领取标记 nDay 第x天[1,8]； nIndexOfDay[1,5] 本天的第x个事件
-- MD01 MD02 一起使用 每天最大5个点 最多8天 共计40个点 从低1位开始使用
-- 参数非法返回-1 
--=========================================================
function PetSoul_FengHunLu_GetEventRewardFlag(nDayIndex,nIndexOfDay)
	if nil == nIndexOfDay or nIndexOfDay < 1 or nIndexOfDay > g_nMaxEventPerDay then
		return -1
	end
	-- 按位取标记[0,31]
	-- g_tabMaiDianSaveInfo
	if g_MaiDianSaveInfo[nIndexOfDay][2] >= g_tabEventInfo[nDayIndex][nIndexOfDay].OverConut then
		return 1
	end
	return 0
end

--**********************************
-- 获得每天的活动事件的所有信息
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
		-- 正常埋点
		local tableMaiDianInfo = g_tabMaiDianSaveInfo[nMaiDianID]
		if nil == tableMaiDianInfo then
			return 0, 0, 0, 0, 0, 0
		end

		nCurMaiDianValue = PetSoul_FengHunLu_GetMaiDianValue(nIndexOfDay)
	elseif -1 == nMaiDianID then
		-- 特写 每日活跃点数
		nCurMaiDianValue = g_nHuoYuePoint
		-- 已经领取了 特写成完成
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
-- 计算已领取点数
--**********************************
function PetSoul_FengHunLu_GetTotalPoint()
	local nTotalPoint = g_AllTotalPoint
	return nTotalPoint
end

--**********************************
-- 获取累积积分奖励是否已领取标记 nPointRewardLevel[1,10] 第x个积分奖励等级
-- MD02 最高位开始使用
-- 参数非法返回-1 
--**********************************
function PetSoul_FengHunLu_GetPointRewardFlag(nPointRewardLevel)
	-- 按位取标记[0,31]
	local nRet = DataPool:GetPlayerMission_DataRound(463)
	if nRet >= nPointRewardLevel then
		return 1
	end
	return 0
end

--=========================================================
-- 二次确认框回调 ["Type"] "Ok"的返回值有"Ok"； ["Type"] "YesNo"的返回值有 "Yes" "No"
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
-- 翻页
--=========================================================
function PetSoul_FengHunLu_PageClick(nPage)
	if nil == nPage or nPage <= 0 or nPage > g_nMaxTotalDay then
		return
	end

	if g_nCurPage == nPage then
		return
	end

	-- 分页未开启
	local nOpenDays = g_nFengHunluDayIndex
	if nOpenDays > g_nMaxTotalDay then
		nOpenDays = g_nMaxTotalDay
	end
	if nPage > nOpenDays then
		PushDebugMessage(string.format("#H该页面在第%s天可开启。", nPage))
		-- 这里也要刷新 不然界面按钮会自动被check
		PetSoul_FengHunLu_Update(bOpen)
		return
	end

	g_nCurPage = nPage
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "AskChangeMainUI" ); 	
		Set_XSCRIPT_ScriptID( 791010 );						-- 脚本编号
		Set_XSCRIPT_Parameter(0,g_nCurPage);
		Set_XSCRIPT_ParamCount( 1 );						-- 参数个数
	Send_XSCRIPT()	
	-- PetSoul_FengHunLu_Update(0)
end

--=========================================================
-- 活得点数总奖励
--=========================================================
function PetSoul_FengHunLu_GetAwardClick()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "GetRewardOfPoint" )
		Set_XSCRIPT_ScriptID(791010)
		Set_XSCRIPT_ParamCount(0)
	Send_XSCRIPT()
end

--=========================================================
-- 帮助按钮
--=========================================================
function PetSoul_FengHunLu_OnClickHelp()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "ShowHelp" )
		Set_XSCRIPT_ScriptID(791010)			
		Set_XSCRIPT_ParamCount(0)
	Send_XSCRIPT()
end

--=========================================================
-- 每日事件点击
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
		-- 领奖
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

		-- 返回醒目提示
		if 1 == tEventClickInfo.nOpType then
			PushDebugMessage(tEventClickInfo.strShow)
		end

		-- 寻路
		if 2 == tEventClickInfo.nOpType then
			PushDebugMessage("暂不支持自动寻路，请手动前往")
		end
	end

end

--=========================================================
-- 重置界面
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
-- 关闭界面
--=========================================================
function PetSoul_FengHunLu_OnClose()	
	this:Hide()
	StopCareObject_PetSoul_FengHunLu()
	-- 重置
	PetSoul_FengHunLu_Reset()
end

--=========================================================
-- 界面隐藏
-- <Event Name="Hidden" Function="PetSoul_FengHunLu_OnHiden();" />
--=========================================================
function PetSoul_FengHunLu_OnHiden()
	StopCareObject_PetSoul_FengHunLu()
	-- 重置
	PetSoul_FengHunLu_Reset()
end

--=========================================================
-- 关心操作
--=========================================================
function BeginCareObject_PetSoul_FengHunLu()
	-- 关心
	this:CareObject(g_nObjCaredIDClient, 1, "PetSoul_FengHunLu")
end

function StopCareObject_PetSoul_FengHunLu()
	-- 取消关心
	if nil ~= g_nObjCaredIDClient and g_nObjCaredIDClient > 0 then
		this:CareObject(g_nObjCaredIDClient, 0, "PetSoul_FengHunLu")
	end
	g_nServerObjID = -1
end

--=========================================================
-- 金钱刷新：界面更新调用一次 金钱事件调用一次
--=========================================================
function PetSoul_FengHunLu_MoneyUpdate()
	-- PetSoul_FengHunLu_HaveJiaoZiNum : SetProperty( "MoneyNumber", tostring(Player:GetData("MONEY_JZ")) )
	-- PetSoul_FengHunLu_HaveGoldNum : SetProperty( "MoneyNumber", tostring(Player:GetData("MONEY")) )
end

--=========================================================
-- 元宝刷新：界面更新调用一次 元宝事件调用一次
--=========================================================
function PetSoul_FengHunLu_YuanBaoUpdate()
	-- PetSoul_FengHunLu_HaveYuanBaoNum : SetText (tostring(Player:GetData("YUANBAO")))
end

--=========================================================
-- 界面位置
--=========================================================
function PetSoul_FengHunLu_Frame_On_ResetPos()
	PetSoul_FengHunLu_FrameFull:SetProperty("UnifiedPosition", g_PetSoul_FengHunLu_Frame_UnifiedPosition)
end