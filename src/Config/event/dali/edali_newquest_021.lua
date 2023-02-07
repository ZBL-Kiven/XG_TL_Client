--MisDescBegin
--脚本号
x210269_g_ScriptId  = 210269
x210269_g_NextScriptId = 210268

--接受任务NPC属性
x210269_g_Position_X=160
x210269_g_Position_Z=158
x210269_g_SceneID=2
x210269_g_AccomplishNPC_Name="赵天师"

--上一个任务的ID
x210269_g_MissionIdPre = 1419

--任务号
x210269_g_MissionId = 1420

--目标NPC
x210269_g_Name	="赵天师"

--任务归类
x210269_g_MissionKind = 13

--任务等级
x210269_g_MissionLevel = 9
x210269_g_MinMissionLevel = 9

--是否是精英任务
x210269_g_IfMissionElite = 0

--任务文本描述
x210269_g_MissionName="最后的试炼"
x210269_g_MissionTarget="#{XSRW_100111_93}"	--任务目标
x210269_g_MissionInfo="#{XSRW_100111_46}" --任务描述
x210269_g_ContinueInfo="#{XSRW_100111_85}"	--未完成任务的npc对话
x210269_g_MissionComplete="#{XSRW_100111_47}"	--完成任务npc说话的话
x210269_g_SignPost = {x = 160, z = 157, tip = "赵天师"}
--任务奖励
x210269_g_MoneyJZBonus=100
x210269_g_ExpBonus=3215
x210269_g_ItemBonus={}
x210269_g_RadioItemBonus={}

x210269_g_DemandTrueKill ={{name="木头人",num=5}}
--下面几项是动态显示的内容，用于在任务列表中动态显示任务情况**********************
--任务是否已经完成
x210269_g_IsMissionOkFail = 0		--变量的第0位

--任务需要杀死的怪
x210269_g_DemandKill ={{id=703,num=5}}		--变量第1位

--以上是动态**************************************************************


--MisDescEnd
