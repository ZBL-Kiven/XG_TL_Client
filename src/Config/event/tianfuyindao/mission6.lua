--MisDescBegin
--脚本号
x891223_g_ScriptId = 891223

--完成任务NPC属性
-- x891223_g_Position_X=160  --替代
-- x891223_g_Position_Z=157 --替代
-- x891223_g_SceneID=2
-- x891223_g_AccomplishNPC_Name="赵天师"

--任务号
x891223_g_MissionId = 2026

--前置任务
x891223_g_PreMissionId = 2025
x891223_g_PreMissionName = "#{TFYD_210729_308}"

--目标NPC：接任务、交任务，都是这个
x891223_g_AcceptNpcInfo	= {
	[MP_SHAOLIN] = {sceneId=9, name={[1]="玄阅", [2]="玄篱"}},
	[MP_MINGJIAO] = {sceneId=11, name={[1]="莫思归", [2]="林焱"}},
	[MP_GAIBANG] = {sceneId=10, name={[1]="杜少康", [2]="路老大"}},
	[MP_WUDANG] = {sceneId=12, name={[1]="碧落散人", [2]="逐浪散人"}},
	[MP_EMEI] = {sceneId=15, name={[1]="聚落花", [2]="苏戈"}},
	[MP_XINGSU] = {sceneId=16, name={[1]="蒿莱子", [2]="莲舟子"}},
	[MP_DALI] = {sceneId=13, name={[1]="本喜", [2]="本然"}},
	[MP_TIANSHAN] = {sceneId=17, name={[1]="吴森森", [2]="吴淼淼"}},
	[MP_XIAOYAO] = {sceneId=14, name={[1]="艾凉河", [2]="秦烟萝"}},
}

--任务归类
x891223_g_MissionKind = 9

--任务等级
x891223_g_MissionLevel = 60

--是否是精英任务
x891223_g_IfMissionElite = 0

--任务名
x891223_g_MissionName="#{TFYD_210729_376}"
x891223_g_MissionTarget=""
x891223_g_IsMissionOkFail=0
x891223_g_Custom = {}
x891223_g_ContinueInfo = ""
x891223_g_MissionComplete = ""

x891223_g_MoneyJZBonus = 45000
x891223_g_ExpBonus = 420000

--MisDescEnd
