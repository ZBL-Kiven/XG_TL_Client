--MisDescBegin
--脚本号
x890001_g_ScriptId	= 890001

--前续任务号
x890001_g_MissionIdPre 	= 750
--任务号
x890001_g_MissionId		= 751
--下一个任务的ID
x890001_g_MissionIdNext	= 752

--下一个任务的ScriptId
x890001_g_NextScriptId	= 890002

--任务归类
x890001_g_MissionKind		= 4
--任务等级
x890001_g_MissionLevel		= 45
--是否是精英任务
x890001_g_IfMissionElite	= 0
--任务是否已经完成
x890001_g_IsMissionOkFail	= 0		--任务参数的第0位

--任务文本描述
x890001_g_MissionName		= "#{TSXF_090408_05}"
--任务描述
x890001_g_MissionInfo_1		= "#{TSXF_090408_19}"
x890001_g_MissionInfo_2		= "#{TSXF_090408_38}"
--任务目标
x890001_g_MissionTarget		= "%f"
--用来保存字符串格式化的数据
x890001_g_FormatList = {
								"#{TSXF_090408_35}#Y%s#W#{TSXF_090408_36}#{TSXF_090408_14}#Y%s#W#{TSXF_090408_15}",
							}

--格式字符串中的索引, 表示从4开始,后多少位视SetMissionByIndex(...)的多少而定
x890001_g_StrForePart=4
--x890001_g_ShimenPet_Index = 1

x890001_g_StrList = {
						"龙树心经",
						"烈焰大法",
						"控鹤功",
						"太极拳法",
						"君子剑法",
						"圣水经",
						"段家剑法",
						"天山折梅手",
						"丹青引",
						"慧方#{_INFOAIM96,82,9,慧方}",
						"林岩#{_INFOAIM98,105,11,林岩}",
						"洪通#{_INFOAIM92,77,10,洪通}",
						"张中行#{_INFOAIM78,95,12,张中行}",
						"孟龙#{_INFOAIM96,86,15,孟龙}",
						"王彦#{_INFOAIM96,92,16,王彦}",
						"本凡#{_INFOAIM96,88,13,本凡}",
						"符敏仪#{_INFOAIM95,60,17,符敏仪}",
						"秦观#{_INFOAIM119,152,14,秦观}",
						"霜岭剑术",                      --newmenpai
						"慕容胜#{_INFOAIM69,125,284,慕容胜}", 
						}
--未完成任务的npc对话
x890001_g_ContinueInfo_1	= "#{TSXF_090408_12}"
x890001_g_ContinueInfo_2	= "#{TSXF_090408_13}"
--完成任务npc说的话
x890001_g_MissionComplete_1	= "#{TSXF_090408_12}"
x890001_g_MissionComplete_2	= "#{TSXF_090408_17}"
x890001_g_MissionComplete_3	= "#{TSXF_090408_41}"
--可以完成的环数
x890001_g_MaxRound	= 1
--心法等级要求
x890001_g_MissionXinFa	= 35	

-- 任务完成情况,内容动态刷新,占用任务参数的第1位
x890001_g_Custom	= { {id="已练到35级",num=1} }
--奖励
x890001_g_MoneyBonus		=	70000
x890001_g_ItemBonus={id=30505148, num=1}

--MisDescEnd
