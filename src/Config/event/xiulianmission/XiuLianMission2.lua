--MisDescBegin
x891275_g_ScriptId = 891275
x891275_g_MainScriptId = 891272--主脚本号
x891275_g_NpcScriptId = 891273--npc脚本号
x891275_g_KDZZID = 1006000536
x891275_g_KDZZSubID = 2

--任务号
x891275_g_MissionId = 2031
x891275_g_MissionKind = 7
x891275_g_MissionLevel = 60
x891275_g_IfMissionElite = 0

--任务名
x891275_g_MissionName="#{XLRW_210725_473}"
x891275_g_MissionTarget=""
x891275_g_Custom = {}

--任务参数
x891275_g_IsMissionOkFail = 0--是否完成
x891275_g_MissionLiuPai = 1-- 流派
x891275_g_MissionMenPai = 2-- 门派
x891275_g_Param_ItemIndex = 3--目标采集物品索引
x891275_g_Param_Custom = 4--完成情况

--完成任务NPC
x891275_g_AccomplishNPC = {}

--采集列表
x891275_g_ItemList = 
{
	[0] = { 	sceneid = 9, --少林
		list = { 	{npcid=49325,num=3,posx=149,posz=51,name="#{XLRW_210725_291}",posname="#{XLRW_210725_612}",},
							{npcid=49326,num=3,posx=36,posz=155,name="#{XLRW_210725_292}",posname="#{XLRW_210725_613}",},
							{npcid=49327,num=1,posx=47,posz=40,name="#{XLRW_210725_293}",posname="#{XLRW_210725_614}",}, },  },
	[1] = { 	sceneid = 11, --明教
		list = { 	{npcid=49331,num=3,posx=38,posz=33,name="#{XLRW_210725_297}",posname="#{XLRW_210725_618}",},
							{npcid=49332,num=3,posx=32,posz=142,name="#{XLRW_210725_298}",posname="#{XLRW_210725_619}",},
							{npcid=49333,num=1,posx=27,posz=102,name="#{XLRW_210725_299}",posname="#{XLRW_210725_620}",}, },  },
	[2] = { 	sceneid = 10, --丐帮
		list = { 	{npcid=49328,num=3,posx=156,posz=156,name="#{XLRW_210725_294}",posname="#{XLRW_210725_615}",},
							{npcid=49329,num=3,posx=34,posz=123,name="#{XLRW_210725_295}",posname="#{XLRW_210725_616}",},
							{npcid=49330,num=1,posx=157,posz=54,name="#{XLRW_210725_296}",posname="#{XLRW_210725_617}",}, },  },
	[3] = { 	sceneid = 12, --武当
		list = { 	{npcid=49334,num=3,posx=112,posz=162,name="#{XLRW_210725_300}",posname="#{XLRW_210725_621}",},
							{npcid=49335,num=3,posx=114,posz=124,name="#{XLRW_210725_301}",posname="#{XLRW_210725_622}",},
							{npcid=49336,num=1,posx=39,posz=138,name="#{XLRW_210725_302}",posname="#{XLRW_210725_623}",}, },  },
	[4] = { 	sceneid = 15, --峨嵋
		list = { 	{npcid=49343,num=3,posx=149,posz=96,name="#{XLRW_210725_309}",posname="#{XLRW_210725_630}",},
							{npcid=49344,num=3,posx=48,posz=92,name="#{XLRW_210725_310}",posname="#{XLRW_210725_631}",},
							{npcid=49345,num=1,posx=155,posz=35,name="#{XLRW_210725_311}",posname="#{XLRW_210725_632}",}, },  },
	[5] = { 	sceneid = 16, --星宿
		list = { 	{npcid=49346,num=3,posx=82,posz=44,name="#{XLRW_210725_312}",posname="#{XLRW_210725_633}",},
							{npcid=49347,num=3,posx=153,posz=142,name="#{XLRW_210725_313}",posname="#{XLRW_210725_634}",},
							{npcid=49348,num=1,posx=49,posz=129,name="#{XLRW_210725_314}",posname="#{XLRW_210725_635}",}, },  },
	[6] = { 	sceneid = 13, --天龙
		list = { 	{npcid=49337,num=3,posx=163,posz=84,name="#{XLRW_210725_303}",posname="#{XLRW_210725_624}",},
							{npcid=49338,num=3,posx=32,posz=83,name="#{XLRW_210725_304}",posname="#{XLRW_210725_625}",},
							{npcid=49339,num=1,posx=49,posz=138,name="#{XLRW_210725_305}",posname="#{XLRW_210725_626}",}, },  },
	[7] = { 	sceneid = 17, --天山
		list = { 	{npcid=49349,num=3,posx=157,posz=149,name="#{XLRW_210725_315}",posname="#{XLRW_210725_636}",},
							{npcid=49350,num=3,posx=31,posz=155,name="#{XLRW_210725_316}",posname="#{XLRW_210725_637}",},
							{npcid=49351,num=1,posx=78,posz=126,name="#{XLRW_210725_317}",posname="#{XLRW_210725_638}",}, },  },
	[8] = { 	sceneid = 14, --逍遥
		list = { 	{npcid=49340,num=3,posx=155,posz=63,name="#{XLRW_210725_306}",posname="#{XLRW_210725_627}",},
							{npcid=49341,num=3,posx=50,posz=150,name="#{XLRW_210725_307}",posname="#{XLRW_210725_628}",},
							{npcid=49342,num=1,posx=69,posz=141,name="#{XLRW_210725_308}",posname="#{XLRW_210725_629}",}, },  },
}

--npc距离
x891275_g_NpcDist = 5
--背包空位
x891275_g_BagSpace = 1

x891275_g_NPCStr = {
	"#{XLRW_210725_675}", "#{XLRW_210725_720}", "#{XLRW_210725_721}"
}

--奖励
--x891275_g_MoneyJZBonus					=	30000
--x891275_g_ExpBonus						= 250000

--MisDescEnd
