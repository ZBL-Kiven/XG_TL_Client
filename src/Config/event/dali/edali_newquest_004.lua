--MisDescBegin
--脚本号
x210257_g_ScriptId  = 210257
x210257_g_NextScriptId = 210258

--接受任务NPC属性
x210257_g_Position_X=238
x210257_g_Position_Z=172
x210257_g_SceneID=2
x210257_g_AccomplishNPC_Name="黄公道"

--上一个任务的ID
x210257_g_MissionIdPre = 1402

--任务号
x210257_g_MissionId = 1403

--目标NPC
x210257_g_Name	="黄公道"

--任务归类
x210257_g_MissionKind = 13

--任务等级
x210257_g_MissionLevel = 2
x210257_g_MinMissionLevel = 2

--是否是精英任务
x210257_g_IfMissionElite = 0

--任务文本描述
x210257_g_MissionName="第一次杀怪"
x210257_g_MissionTarget="#{XSRW_100111_65}"	--任务目标
x210257_g_MissionInfo="#{XSRW_100111_8}" --任务描述
x210257_g_ContinueInfo="#{XSRW_100111_83}"	--未完成任务的npc对话
x210257_g_MissionComplete="#{XSRW_100111_9}"	--完成任务npc说话的话
x210257_g_SignPost = {x = 238, z = 172, tip = "黄公道"}
--任务奖励
x210257_g_MoneyJZBonus=30
x210257_g_ExpBonus=390
x210257_g_ItemBonus={{id=10110000,num=1}}
x210257_g_RadioItemBonus={}

x210257_g_DemandTrueKill ={{name="高山白猿",num=4}}
--下面几项是动态显示的内容，用于在任务列表中动态显示任务情况**********************
--任务是否已经完成
x210257_g_IsMissionOkFail = 0		--变量的第0位

--任务需要杀死的怪
x210257_g_DemandKill ={{id=708,num=4}}		--变量第1位

--以上是动态**************************************************************


--MisDescEnd
