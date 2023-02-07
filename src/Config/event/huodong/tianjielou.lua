--MisDescBegin
--脚本号
x808138_g_ScriptId = 808138

--完成任务NPC属性
x808138_g_AccomplishNPC_Name="付劫生"
x808138_g_Position_X=50
x808138_g_Position_Z=175
x808138_g_SceneID=2

--上一个任务的ID
--g_MissionIdPre =

--任务号
x808138_g_MissionId = 1169

--目标NPC
x808138_g_Name	="付劫生"

--任务归类
x808138_g_MissionKind = 13

-- 每天最多领取次数
x808138_g_TakeTimes = 10 
x808138_g_TenTimes =  x808138_g_TakeTimes + 1	-- 最后一环MD中存储的值是11，因为在交任务的时候会加1环，这样最后一环完成就是11

-- 任务当前环数，存放在MissionData  MD_ROUNDMISSION_CHUE_DAYHUAN中，其枚举值为307
x808138_g_MissionRound=308

--任务等级
x808138_g_MissionLevel = 10000

--是否是精英任务
x808138_g_IfMissionElite = 0

--任务文本描述
x808138_g_MissionName="除恶天劫楼"
x808138_g_MissionTarget="#{TJL_090714_04}"
x808138_g_MissionInfo="#{TJL_090714_03}"

-- 任务完成情况,内容动态刷新,从任务参数的第1位开始
x808138_g_Custom	= { {id="已杀死：天劫楼恶人",num=20}}

x808138_g_IsMissionOkFail = 1		--变量的第0位


--MisDescEnd
