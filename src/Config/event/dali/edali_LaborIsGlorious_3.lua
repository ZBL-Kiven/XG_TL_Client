--MisDescBegin
--脚本号
x210249_g_ScriptId 						= 210249

--接受任务NPC属性
x210249_g_Position_X 					= 172.7304
x210249_g_Position_Z 					= 146.4640
x210249_g_SceneID 						= 2
x210249_g_AccomplishNPC_Name	= "孙八爷"
--任务号
x210249_g_MissionId 					= 1154
--目标NPC
x210249_g_Name 								= "孙八爷"
--任务归类
x210249_g_MissionKind 				= 13
--任务环数
--MD_LABORISGLORIOUS_ROUND（288）
x210249_g_MissionRound				= 288
--任务等级
x210249_g_MissionLevel 				= 10000
--是否是精英任务
x210249_g_IfMissionElite 			= 0
--是否完成
x210249_g_IsMissionOkFail			= 0		
--任务名
x210249_g_MissionName 				= "劳动最光荣"
--任务描述
x210249_g_MissionInfo					= ""

--任务目标
x210249_g_MissionTarget				= "%f"

x210249_g_StrForePart 				= 4

--用来保存字符串格式化的数据
--x210249_g_FormatList = {"#{WYHD_090410_33}%s#{WYHD_090410_34}",}
x210249_g_FormatList = {"请你前往%s处种植这颗希望的种子，完成之后到大理孙八爷处领取劳动最光荣活动的奖励。#r#G注意：这个活动每天只可以参加一次，并且放弃任务今天就不可以再参加劳动最光荣的任务了。",}

x210249_g_StrList = {
	"剑阁#{_INFOAIM58,189,7,}",
	"雁南#{_INFOAIM168,114,18,}",
	"无量山#{_INFOAIM249,42,6,}",
	"太湖#{_INFOAIM97,177,4,}",
	"嵩山#{_INFOAIM132,198,3,}",
 }

 --控制脚本
x210249_g_ControlScript				= 210249
--任务完成情况,内容动态刷新,占用任务参数的第1位
x210249_g_Custom							= { {id="已种植种子",num=1}}


--MisDescEnd
