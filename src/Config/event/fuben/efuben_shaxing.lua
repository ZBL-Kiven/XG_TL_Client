--MisDescBegin

-- 脚本号
x402048_g_ScriptId 				= 402048

--角色活跃值副本的index
x402048_g_activePointIndex = 14

---- 任务号
x402048_g_MissionId 			= 1146					--杀星任务

---- 任务目标 NPC
x402048_g_Name 				= "枯荣大师"

--任务归类
x402048_g_MissionKind 		= 8

--接取任务的最低等级
x402048_g_minLevel 			= 70
x402048_g_minXinFaLevel		= 45

x402048_g_MissionLevel		= 10000

-- 任务文本描述
x402048_g_MissionName 		= "#{SXRW_090119_002}"
x402048_g_MissionInfo 		= ""										-- 任务描述
x402048_g_MissionTarget 	= "#{SXRW_090119_139}"						-- 任务目标
x402048_g_SubmitInfo 		= "#{SXRW_090119_042}"						-- 提交时的答复
x402048_g_AcceptInfo 		= "#{SXRW_090119_014}"						-- 接受任务是的答复
x402048_g_MissionComplete 	= "#{SXRW_090119_042}"					 	--完成任务npc说的话

x402048_g_IsMissionOkFail = 0			-- 0号索引：当前任务是否完成(0未完成；1完成；2失败)
x402048_g_KillMonsterNum 	= 1			-- 1 号索引：杀十二煞星的个数
x402048_g_Param_sceneid 	= 2			-- 2号索引：当前任务数据的2位置设置为场景ID
--~ x402048_g_Parameter_Kill_CountRandom = { { id = 1700152, numNeeded = 6, numKilled = 1 } }
x402048_g_Custom	= { {id="已完成杀星任务",num=1} }


--MisDescEnd
