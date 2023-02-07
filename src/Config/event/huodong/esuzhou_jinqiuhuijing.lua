--MisDescBegin
-- 脚本号
x891214_g_ScriptId = 891214

--接受任务NPC属性
x891214_g_Position_X = 172
x891214_g_Position_Z = 179
x891214_g_SceneID = 1
x891214_g_AccomplishNPC_Name= "张择端"

--任务号(找策划要)
x891214_g_MissionId = 2020

--任务目标npc
x891214_g_Name = "张择端"

--任务归类(找策划要，对应Client/Config/MissionKind.txt)
x891214_g_MissionKind = 3

--任务等级
x891214_g_MissionLevel = 30

--是否是精英任务
x891214_g_IfMissionElite = 0
x891214_g_IsMissionOkFail = 0		--变量的第0位
--任务名
x891214_g_MissionName="金秋绘景"
--任务描述
x891214_g_MissionInfo  = " "--此处需准备8个场景地点的描述,9.30-10.7每日给出一个地点（待完善）。怕是要写8条
--任务目标
x891214_g_MissionTarget="#{JQHJ_20210730_30}"	--请根据苏州（172，179）张择端的描述，找到美景所在之地并绘于空白宣纸上。
--未完成任务的npc对话
x891214_g_ContinueInfo=" "
--提交时npc的话
x891214_g_MissionComplete="#{JQHJ_20210730_62}"	--让我看看你画得如何……		

x891214_g_ItemBonus ={{id=38002412,num=1},}

x891214_g_Custom	= { {id="使用空白宣纸",num=1} }--变量的第1位

--MisDescEnd
