--MisDescBegin
--脚本号
x210248_g_ScriptId 						= 210248

--接受任务NPC属性
x210248_g_Position_X 					= 172.7304
x210248_g_Position_Z 					= 146.4640
x210248_g_SceneID 						= 2
x210248_g_AccomplishNPC_Name	= "孙八爷"
--任务号
x210248_g_MissionId 					= 1153
--目标NPC
x210248_g_Name 								= "孙八爷"
--任务归类
x210248_g_MissionKind 				= 13
--任务环数
--MD_LABORISGLORIOUS_ROUND（288）
x210248_g_MissionRound				= 288
--任务等级
x210248_g_MissionLevel 				= 10000
--是否是精英任务
x210248_g_IfMissionElite 			= 0
--是否完成
x210248_g_IsMissionOkFail			= 0
--任务名
x210248_g_MissionName 				= "劳动最光荣"
--任务描述
x210248_g_MissionInfo					= ""

--任务目标
x210248_g_MissionTarget				= "%f"

x210248_g_StrForePart 				= 4

--用来保存字符串格式化的数据

x210248_g_FormatList = {"大理的%s#W请你去%s附近杀死#G10#W个%s。#r#G注意：这个活动每天只可以参加一次，并且放弃任务今天就不可以再参加劳动最光荣的任务了。",}

x210248_g_StrList = {
	"#R孙八爷#W#{_INFOAIM173,146,2,孙八爷}",
	--1-->14
	"雁南",
	"龙泉",
	"苍山",
	"雁北",
	"石林",
	"武夷",
	"梅岭",
	"草原",
	"辽西",
	"玉溪",
	"南诏",
	"南海",
	"琼州",
	"南海",
	--15-->28
	"秦家寨亲兵#{_INFOAIM68,201,18,}",
	"龙泉豹#{_INFOAIM79,250,31,}",
	"狼族头人#{_INFOAIM138,236,25,}",
	"红枫蜘蛛#{_INFOAIM150,200,19,}",
	"棕熊#{_INFOAIM273,45,26,}",
	"树甲哨兵#{_INFOAIM258,125,32,}",
	"红袍蜘蛛#{_INFOAIM40,250,33,}",
	"弯刀马匪#{_INFOAIM273,156,20,}",
	"白狼王#{_INFOAIM161,268,21,}",
	"偃师护法#{_INFOAIM222,213,27,}",
	"丛林蜂#{_INFOAIM193,95,28,}",
	"南海海盗#{_INFOAIM239,216,34,}",
	"鳄鱼帮杀手#{_INFOAIM160,100,35,}",
	"南海盗神#{_INFOAIM252,63,35,}",
 }

 --控制脚本
x210248_g_ControlScript				= 210248
--任务完成情况,内容动态刷新,占用任务参数的第1位
x210248_g_Custom							= { {id="已杀怪",num=10}}


--MisDescEnd
