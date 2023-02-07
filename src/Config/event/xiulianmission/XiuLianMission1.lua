--MisDescBegin
x891274_g_ScriptId = 891274
x891274_g_MainScriptId = 891272--主脚本号
x891274_g_NpcScriptId = 891273--npc脚本号
x891274_g_KDZZID = 1006000536
x891274_g_KDZZSubID = 1

--任务号
x891274_g_MissionId = 2030
x891274_g_MissionKind = 7
x891274_g_MissionLevel = 60
x891274_g_IfMissionElite = 0

--任务名
x891274_g_MissionName="#{XLRW_210725_472}"
x891274_g_MissionTarget=""
x891274_g_Custom = {}

--任务参数
x891274_g_IsMissionOkFail = 0--是否完成
x891274_g_MissionLiuPai = 1-- 流派
x891274_g_MissionMenPai = 2-- 门派
x891274_g_Param_NpcIndex = 3--目标npc索引
x891274_g_Param_QuestionIndex = 4--题目索引
x891274_g_Param_Custom = 5--完成情况

--完成任务NPC
x891274_g_AccomplishNPC = 
{
	[1] = { sname = "#{XLRW_210725_263}", npcname = "#{XLRW_210725_267}", name = "裴宣", sceneid = 0, },
	[2] = { sname = "#{XLRW_210725_263}", npcname = "#{XLRW_210725_268}", name = "周邦彦", sceneid = 0, },
	[3] = { sname = "#{XLRW_210725_263}", npcname = "#{XLRW_210725_269}", name = "王积薪", sceneid = 0, },
	[4] = { sname = "#{XLRW_210725_263}", npcname = "#{XLRW_210725_270}", name = "怀丙", sceneid = 0, },
	[5] = { sname = "#{XLRW_210725_263}", npcname = "#{XLRW_210725_271}", name = "章惇", sceneid = 0, },
	[6] = { sname = "#{XLRW_210725_263}", npcname = "#{XLRW_210725_272}", name = "吕惠卿", sceneid = 0, },
	[7] = { sname = "#{XLRW_210725_264}", npcname = "#{XLRW_210725_273}", name = "枯荣大师", sceneid = 2, },
	[8] = { sname = "#{XLRW_210725_264}", npcname = "#{XLRW_210725_274}", name = "洪大贵", sceneid = 2, },
	[9] = { sname = "#{XLRW_210725_264}", npcname = "#{XLRW_210725_275}", name = "王韶", sceneid = 2, },
	[10] = { sname = "#{XLRW_210725_264}", npcname = "#{XLRW_210725_276}", name = "凤朝阳", sceneid = 2, },
	[11] = { sname = "#{XLRW_210725_264}", npcname = "#{XLRW_210725_277}", name = "木婉清", sceneid = 2, },
	[12] = { sname = "#{XLRW_210725_264}", npcname = "#{XLRW_210725_278}", name = "范骅", sceneid = 2, },
	[13] = { sname = "#{XLRW_210725_265}", npcname = "#{XLRW_210725_279}", name = "张择端", sceneid = 1, },
	[14] = { sname = "#{XLRW_210725_265}", npcname = "#{XLRW_210725_280}", name = "魏真", sceneid = 1, },
	[15] = { sname = "#{XLRW_210725_265}", npcname = "#{XLRW_210725_281}", name = "谢尚", sceneid = 1, },
	[16] = { sname = "#{XLRW_210725_265}", npcname = "#{XLRW_210725_282}", name = "邓百川", sceneid = 1, },
	[17] = { sname = "#{XLRW_210725_265}", npcname = "#{XLRW_210725_283}", name = "朱丹臣", sceneid = 1, },
	[18] = { sname = "#{XLRW_210725_265}", npcname = "#{XLRW_210725_284}", name = "花剑雨", sceneid = 1, },
}

--答题列表
x891274_g_QuestionList = 
{
	[1] = { question = "#{XLRW_210725_225}", answer1 = "#{XLRW_210725_410}", answer2 = "#{XLRW_210725_411}", answer3 = "#{XLRW_210725_412}", answerid = 2, },
	[2] = { question = "#{XLRW_210725_226}", answer1 = "#{XLRW_210725_413}", answer2 = "#{XLRW_210725_414}", answer3 = "#{XLRW_210725_415}", answerid = 1, },
	[3] = { question = "#{XLRW_210725_227}", answer1 = "#{XLRW_210725_416}", answer2 = "#{XLRW_210725_417}", answer3 = "#{XLRW_210725_418}", answerid = 3, },
	[4] = { question = "#{XLRW_210725_228}", answer1 = "#{XLRW_210725_419}", answer2 = "#{XLRW_210725_420}", answer3 = "#{XLRW_210725_421}", answerid = 2, },
	[5] = { question = "#{XLRW_210725_229}", answer1 = "#{XLRW_210725_422}", answer2 = "#{XLRW_210725_423}", answer3 = "#{XLRW_210725_424}", answerid = 1, },
	[6] = { question = "#{XLRW_210725_230}", answer1 = "#{XLRW_210725_425}", answer2 = "#{XLRW_210725_426}", answer3 = "#{XLRW_210725_427}", answerid = 1, },
	[7] = { question = "#{XLRW_210725_231}", answer1 = "#{XLRW_210725_428}", answer2 = "#{XLRW_210725_429}", answer3 = "#{XLRW_210725_430}", answerid = 3, },
	[8] = { question = "#{XLRW_210725_232}", answer1 = "#{XLRW_210725_431}", answer2 = "#{XLRW_210725_432}", answer3 = "#{XLRW_210725_433}", answerid = 3, },
	[9] = { question = "#{XLRW_210725_233}", answer1 = "#{XLRW_210725_434}", answer2 = "#{XLRW_210725_435}", answer3 = "#{XLRW_210725_436}", answerid = 2, },
	[10] = { question = "#{XLRW_210725_234}", answer1 = "#{XLRW_210725_437}", answer2 = "#{XLRW_210725_438}", answer3 = "#{XLRW_210725_439}", answerid = 1, },
	[11] = { question = "#{XLRW_210725_235}", answer1 = "#{XLRW_210725_440}", answer2 = "#{XLRW_210725_441}", answer3 = "#{XLRW_210725_442}", answerid = 1, },
	[12] = { question = "#{XLRW_210725_236}", answer1 = "#{XLRW_210725_443}", answer2 = "#{XLRW_210725_444}", answer3 = "#{XLRW_210725_445}", answerid = 2, },
	[13] = { question = "#{XLRW_210725_237}", answer1 = "#{XLRW_210725_446}", answer2 = "#{XLRW_210725_447}", answer3 = "#{XLRW_210725_448}", answerid = 3, },
	[14] = { question = "#{XLRW_210725_238}", answer1 = "#{XLRW_210725_449}", answer2 = "#{XLRW_210725_450}", answer3 = "#{XLRW_210725_451}", answerid = 2, },
	[15] = { question = "#{XLRW_210725_239}", answer1 = "#{XLRW_210725_452}", answer2 = "#{XLRW_210725_453}", answer3 = "#{XLRW_210725_454}", answerid = 1, },
	[16] = { question = "#{XLRW_210725_240}", answer1 = "#{XLRW_210725_455}", answer2 = "#{XLRW_210725_456}", answer3 = "#{XLRW_210725_457}", answerid = 3, },
	[17] = { question = "#{XLRW_210725_241}", answer1 = "#{XLRW_210725_458}", answer2 = "#{XLRW_210725_459}", answer3 = "#{XLRW_210725_460}", answerid = 2, },
	[18] = { question = "#{XLRW_210725_242}", answer1 = "#{XLRW_210725_461}", answer2 = "#{XLRW_210725_462}", answer3 = "#{XLRW_210725_463}", answerid = 1, },
	[19] = { question = "#{XLRW_210725_243}", answer1 = "#{XLRW_210725_464}", answer2 = "#{XLRW_210725_465}", answer3 = "#{XLRW_210725_466}", answerid = 3, },
	[20] = { question = "#{XLRW_210725_244}", answer1 = "#{XLRW_210725_467}", answer2 = "#{XLRW_210725_468}", answer3 = "#{XLRW_210725_469}", answerid = 3, },
}

--npc距离
x891274_g_NpcDist = 5
--背包空位
x891274_g_BagSpace = 1

--奖励
--x891274_g_MoneyJZBonus					=	30000
--x891274_g_ExpBonus						= 250000

--MisDescEnd
