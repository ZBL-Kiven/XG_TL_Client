--2010南非世界杯皇榜界面脚本
--Added by Jiang Yin. 2010-05-20.

--球队名，此数据在运行时无需修改
local g_WorldCup_Player =
{
	"#{SJB_XML_50}",		"#{SJB_XML_51}",		"#{SJB_XML_52}",		"#{SJB_XML_53}",	--A(1)组
	"#{SJB_XML_54}",		"#{SJB_XML_55}",		"#{SJB_XML_56}",		"#{SJB_XML_57}",	--B(2)组
	"#{SJB_XML_58}",		"#{SJB_XML_59}",		"#{SJB_XML_60}",		"#{SJB_XML_61}",	--C(3)组
	"#{SJB_XML_62}",		"#{SJB_XML_63}",		"#{SJB_XML_64}",		"#{SJB_XML_65}",	--D(4)组
	"#{SJB_XML_66}",		"#{SJB_XML_67}",		"#{SJB_XML_68}",		"#{SJB_XML_69}",	--E(5)组
	"#{SJB_XML_70}",		"#{SJB_XML_71}",		"#{SJB_XML_72}",		"#{SJB_XML_73}",	--F(6)组
	"#{SJB_XML_74}",		"#{SJB_XML_75}",		"#{SJB_XML_76}",		"#{SJB_XML_77}",	--G(7)组
	"#{SJB_XML_78}",		"#{SJB_XML_79}",		"#{SJB_XML_80}",		"#{SJB_XML_81}",	--H(8)组
	"#{SJB_XML_82}",		"#{SJB_XML_83}",		"#{SJB_XML_84}",		"#{SJB_XML_85}",
	"#{SJB_XML_86}",		"#{SJB_XML_87}",		"#{SJB_XML_88}",		"#{SJB_XML_89}",
	"#{SJB_XML_90}",		"#{SJB_XML_91}",		"#{SJB_XML_92}",		"#{SJB_XML_93}",
	"#{SJB_XML_94}",		"#{SJB_XML_95}",		"#{SJB_XML_96}",		"#{SJB_XML_97}",
	"#{SJB_XML_98}",		"#{SJB_XML_99}",		"#{SJB_XML_100}",		"#{SJB_XML_101}",
	"#{SJB_XML_102}",		"#{SJB_XML_103}",		"#{SJB_XML_104}",		"#{SJB_XML_105}",
	"#{SJB_XML_106}",		"#{SJB_XML_107}",		"#{SJB_XML_108}",		"#{SJB_XML_109}",
	"#{SJB_XML_110}",		"#{SJB_XML_111}",		"#{SJB_XML_112}",		"#{SJB_XML_113}",
}
g_WorldCup_Player[0] = ""		--补两个容错用的数据
g_WorldCup_Player[255] = ""
--比赛类型名，此数据在运行时无需修改
local g_WorldCup_MatchTypeName =
{
	"#{SJB_XML_6}",		--1
	"#{SJB_XML_7}",		--2
	"#{SJB_XML_8}",		--3
	"#{SJB_XML_9}",		--4
	"#{SJB_XML_10}",	--5
	"#{SJB_XML_11}",	--6
	"#{SJB_XML_12}",	--7
	"#{SJB_XML_13}",	--8
	"#{SJB_XML_14}",	--9
	"#{SJB_XML_15}",	--10
	"#{SJB_XML_16}",	--11
	"#{SJB_XML_114}",	--12
	"#{SJB_XML_17}",	--13
}
--下注项描述，此数据在运行时无需修改
local g_WorldCup_BidName =
{
	"#{SJB_XML_115}",	--1
	"#{SJB_XML_116}",	--2
	"#{SJB_XML_117}",	--3
}
--比赛类型下注上限，此数据在运行时无需修改
local g_WorldCup_MatchTypeScore =
{
	100,				--1
	100,				--2
	100,				--3
	100,				--4
	100,				--5
	100,				--6
	100,				--7
	100,				--8
	500,				--9
	500,				--10
	1000,				--11
	1000,				--12
	1000,				--13
}
--各场类型，此数据在运行时无需修改
local g_WorldCup_MatchType =
{
	1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8,	1, 1, 2, 2, 4, 3, 3, 4, 5, 5, 6, 6, 7, 7, 8, 8,	1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8,	--小组赛
	9, 9, 9, 9, 9, 9, 9, 9,	--1/8决赛
	10, 10, 10, 10,	--1/4决赛
	11, 11,	--半决赛
	12,	--三四名决赛
	13, --决赛
}

--数据正确校验标识
local g_WorldCup_DataValid = 0
--玩家得分，注意此数据只能使用WorldCup_DataInit函数修改！
local g_WorldCup_Score = 0
--比赛数据，注意此数据只能使用WorldCup_DataInit函数修改！
local g_WorldCup_MatchData = {}
--队伍数据，注意此数据只能使用WorldCup_DataInit函数修改！
local g_WorldCup_PlayerData = {}
--总场次数，此数据在运行时无需修改
local g_WorldCup_MaxMatchIndex = 64
--小组赛场次数，此数据在运行时无需修改
local g_WorldCup_MaxGroupMatchIndex = 48
--总队伍数，此数据在运行时无需修改
local g_WorldCup_MaxPlayerId = 32
--界面的默认相对位置
local g_WorldCup_Frame_UnifiedXPosition = 0
local g_WorldCup_Frame_UnifiedYPosition = 0
--界面数组化
local ui_DateFrame_GroupListBox = {}
local ui_DateFrame_PlayerLabel = {}
local ui_DateFrame_WinnerLabel = {}
local ui_ViewFrame_GroupButton = {}
local ui_BetFrame_Set = {}
local ui_BetFrame_DateLabel = {}
local ui_BetFrame_TimeLabel = {}
local ui_BetFrame_NameLabel = {}
local ui_BetFrame_IndexLabel = {}
local ui_BetFrame_BetCheckBoxLabel = {}
local ui_BetFrame_BetCheckBox = {}
local ui_BetFrame_BetLabel = {}
local ui_BetFrame_ScoreTextBox = {}
local ui_BetFrame_ScoreLabel = {}
local ui_BetFrame_SubmitButton = {}

function WorldCup_PreLoad()
	--游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	--游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	--服务器UI事件
	this:RegisterEvent("UI_COMMAND")
	--世界杯数据超时
	this:RegisterEvent("WORLDCUP_OVERTIME")
	--世界杯数据到达
	this:RegisterEvent("WORLDCUP_READY")
end

function WorldCup_OnLoad()
	--保存界面的默认相对位置
	g_WorldCup_Frame_UnifiedXPosition = WorldCup_Frame:GetProperty("UnifiedXPosition")
	g_WorldCup_Frame_UnifiedYPosition = WorldCup_Frame:GetProperty("UnifiedYPosition")

	--界面数组化
	ui_DateFrame_GroupListBox[1] = WorldCup_Frame_DateFrame_Team1
	ui_DateFrame_GroupListBox[2] = WorldCup_Frame_DateFrame_Team2
	ui_DateFrame_GroupListBox[3] = WorldCup_Frame_DateFrame_Team3
	ui_DateFrame_GroupListBox[4] = WorldCup_Frame_DateFrame_Team4
	ui_DateFrame_GroupListBox[5] = WorldCup_Frame_DateFrame_Team5
	ui_DateFrame_GroupListBox[6] = WorldCup_Frame_DateFrame_Team6
	ui_DateFrame_GroupListBox[7] = WorldCup_Frame_DateFrame_Team7
	ui_DateFrame_GroupListBox[8] = WorldCup_Frame_DateFrame_Team8
	ui_DateFrame_PlayerLabel[1] = WorldCup_Frame_DateFrame_VTeam1
	ui_DateFrame_PlayerLabel[2] = WorldCup_Frame_DateFrame_VTeam2
	ui_DateFrame_PlayerLabel[3] = WorldCup_Frame_DateFrame_VTeam3
	ui_DateFrame_PlayerLabel[4] = WorldCup_Frame_DateFrame_VTeam4
	ui_DateFrame_PlayerLabel[5] = WorldCup_Frame_DateFrame_VTeam5
	ui_DateFrame_PlayerLabel[6] = WorldCup_Frame_DateFrame_VTeam6
	ui_DateFrame_PlayerLabel[7] = WorldCup_Frame_DateFrame_VTeam7
	ui_DateFrame_PlayerLabel[8] = WorldCup_Frame_DateFrame_VTeam8
	ui_DateFrame_PlayerLabel[9] = WorldCup_Frame_DateFrame_VTeam9
	ui_DateFrame_PlayerLabel[10] = WorldCup_Frame_DateFrame_VTeam10
	ui_DateFrame_PlayerLabel[11] = WorldCup_Frame_DateFrame_VTeam11
	ui_DateFrame_PlayerLabel[12] = WorldCup_Frame_DateFrame_VTeam12
	ui_DateFrame_PlayerLabel[13] = WorldCup_Frame_DateFrame_VTeam13
	ui_DateFrame_PlayerLabel[14] = WorldCup_Frame_DateFrame_VTeam14
	ui_DateFrame_PlayerLabel[15] = WorldCup_Frame_DateFrame_VTeam15
	ui_DateFrame_PlayerLabel[16] = WorldCup_Frame_DateFrame_VTeam16
	ui_DateFrame_WinnerLabel[1] = WorldCup_Frame_DateFrame_Explain1
	ui_DateFrame_WinnerLabel[2] = WorldCup_Frame_DateFrame_Explain2
	ui_DateFrame_WinnerLabel[3] = WorldCup_Frame_DateFrame_Explain3
	ui_DateFrame_WinnerLabel[4] = WorldCup_Frame_DateFrame_Explain4
	ui_DateFrame_WinnerLabel[5] = WorldCup_Frame_DateFrame_Explain5
	ui_DateFrame_WinnerLabel[6] = WorldCup_Frame_DateFrame_Explain6
	ui_DateFrame_WinnerLabel[7] = WorldCup_Frame_DateFrame_Explain7
	ui_DateFrame_WinnerLabel[8] = WorldCup_Frame_DateFrame_Explain8
	ui_DateFrame_WinnerLabel[9] = WorldCup_Frame_DateFrame_Explain9
	ui_DateFrame_WinnerLabel[10] = WorldCup_Frame_DateFrame_Explain10
	ui_DateFrame_WinnerLabel[11] = WorldCup_Frame_DateFrame_Explain11
	ui_DateFrame_WinnerLabel[12] = WorldCup_Frame_DateFrame_Explain12
	ui_DateFrame_WinnerLabel[13] = WorldCup_Frame_DateFrame_Explain13
	ui_DateFrame_WinnerLabel[14] = WorldCup_Frame_DateFrame_Explain14
	ui_DateFrame_WinnerLabel[15] = WorldCup_Frame_DateFrame_Winner

	ui_ViewFrame_GroupButton[1] = WorldCup_Frame_ViewFrame_A
	ui_ViewFrame_GroupButton[2] = WorldCup_Frame_ViewFrame_B
	ui_ViewFrame_GroupButton[3] = WorldCup_Frame_ViewFrame_C
	ui_ViewFrame_GroupButton[4] = WorldCup_Frame_ViewFrame_D
	ui_ViewFrame_GroupButton[5] = WorldCup_Frame_ViewFrame_E
	ui_ViewFrame_GroupButton[6] = WorldCup_Frame_ViewFrame_F
	ui_ViewFrame_GroupButton[7] = WorldCup_Frame_ViewFrame_G
	ui_ViewFrame_GroupButton[8] = WorldCup_Frame_ViewFrame_H

	ui_BetFrame_Set[1] = WorldCup_Frame_BetSet1
	ui_BetFrame_Set[2] = WorldCup_Frame_BetSet2
	ui_BetFrame_Set[3] = WorldCup_Frame_BetSet3
	ui_BetFrame_Set[4] = WorldCup_Frame_BetSet4
	ui_BetFrame_DateLabel[1] = WorldCup_Frame_BetSet1_DateText
	ui_BetFrame_DateLabel[2] = WorldCup_Frame_BetSet2_DateText
	ui_BetFrame_DateLabel[3] = WorldCup_Frame_BetSet3_DateText
	ui_BetFrame_DateLabel[4] = WorldCup_Frame_BetSet4_DateText
	ui_BetFrame_TimeLabel[1] = WorldCup_Frame_BetSet1_TimeText
	ui_BetFrame_TimeLabel[2] = WorldCup_Frame_BetSet2_TimeText
	ui_BetFrame_TimeLabel[3] = WorldCup_Frame_BetSet3_TimeText
	ui_BetFrame_TimeLabel[4] = WorldCup_Frame_BetSet4_TimeText
	ui_BetFrame_NameLabel[1] = WorldCup_Frame_BetSet1_TeamText
	ui_BetFrame_NameLabel[2] = WorldCup_Frame_BetSet2_TeamText
	ui_BetFrame_NameLabel[3] = WorldCup_Frame_BetSet3_TeamText
	ui_BetFrame_NameLabel[4] = WorldCup_Frame_BetSet4_TeamText
	ui_BetFrame_IndexLabel[1] = WorldCup_Frame_BetSet1_SessionText
	ui_BetFrame_IndexLabel[2] = WorldCup_Frame_BetSet2_SessionText
	ui_BetFrame_IndexLabel[3] = WorldCup_Frame_BetSet3_SessionText
	ui_BetFrame_IndexLabel[4] = WorldCup_Frame_BetSet4_SessionText
	ui_BetFrame_BetCheckBoxLabel[1] = {}
	ui_BetFrame_BetCheckBoxLabel[1][1] = WorldCup_Frame_BetSet1_Text1
	ui_BetFrame_BetCheckBoxLabel[1][2] = WorldCup_Frame_BetSet1_Text
	ui_BetFrame_BetCheckBoxLabel[1][3] = WorldCup_Frame_BetSet1_Text3
	ui_BetFrame_BetCheckBoxLabel[2] = {}
	ui_BetFrame_BetCheckBoxLabel[2][1] = WorldCup_Frame_BetSet2_Text1
	ui_BetFrame_BetCheckBoxLabel[2][2] = WorldCup_Frame_BetSet2_Text
	ui_BetFrame_BetCheckBoxLabel[2][3] = WorldCup_Frame_BetSet2_Text3
	ui_BetFrame_BetCheckBoxLabel[3] = {}
	ui_BetFrame_BetCheckBoxLabel[3][1] = WorldCup_Frame_BetSet3_Text1
	ui_BetFrame_BetCheckBoxLabel[3][2] = WorldCup_Frame_BetSet3_Text
	ui_BetFrame_BetCheckBoxLabel[3][3] = WorldCup_Frame_BetSet3_Text3
	ui_BetFrame_BetCheckBoxLabel[4] = {}
	ui_BetFrame_BetCheckBoxLabel[4][1] = WorldCup_Frame_BetSet4_Text1
	ui_BetFrame_BetCheckBoxLabel[4][2] = WorldCup_Frame_BetSet4_Text
	ui_BetFrame_BetCheckBoxLabel[4][3] = WorldCup_Frame_BetSet4_Text3
	ui_BetFrame_BetLabel[1] = WorldCup_Frame_BetSet1_Text4
	ui_BetFrame_BetLabel[2] = WorldCup_Frame_BetSet2_Text4
	ui_BetFrame_BetLabel[3] = WorldCup_Frame_BetSet3_Text4
	ui_BetFrame_BetLabel[4] = WorldCup_Frame_BetSet4_Text4
	ui_BetFrame_BetCheckBox[1] = {}
	ui_BetFrame_BetCheckBox[1][1] = WorldCup_Frame_BetSet1_Check1
	ui_BetFrame_BetCheckBox[1][2] = WorldCup_Frame_BetSet1_Check2
	ui_BetFrame_BetCheckBox[1][3] = WorldCup_Frame_BetSet1_Check3
	ui_BetFrame_BetCheckBox[2] = {}
	ui_BetFrame_BetCheckBox[2][1] = WorldCup_Frame_BetSet2_Check1
	ui_BetFrame_BetCheckBox[2][2] = WorldCup_Frame_BetSet2_Check2
	ui_BetFrame_BetCheckBox[2][3] = WorldCup_Frame_BetSet2_Check3
	ui_BetFrame_BetCheckBox[3] = {}
	ui_BetFrame_BetCheckBox[3][1] = WorldCup_Frame_BetSet3_Check1
	ui_BetFrame_BetCheckBox[3][2] = WorldCup_Frame_BetSet3_Check2
	ui_BetFrame_BetCheckBox[3][3] = WorldCup_Frame_BetSet3_Check3
	ui_BetFrame_BetCheckBox[4] = {}
	ui_BetFrame_BetCheckBox[4][1] = WorldCup_Frame_BetSet4_Check1
	ui_BetFrame_BetCheckBox[4][2] = WorldCup_Frame_BetSet4_Check2
	ui_BetFrame_BetCheckBox[4][3] = WorldCup_Frame_BetSet4_Check3
	ui_BetFrame_ScoreTextBox[1] = WorldCup_Frame_BetSet1_EditBox
	ui_BetFrame_ScoreTextBox[2] = WorldCup_Frame_BetSet2_EditBox
	ui_BetFrame_ScoreTextBox[3] = WorldCup_Frame_BetSet3_EditBox
	ui_BetFrame_ScoreTextBox[4] = WorldCup_Frame_BetSet4_EditBox
	ui_BetFrame_ScoreLabel[1] = WorldCup_Frame_BetSet1_Explain
	ui_BetFrame_ScoreLabel[2] = WorldCup_Frame_BetSet2_Explain
	ui_BetFrame_ScoreLabel[3] = WorldCup_Frame_BetSet3_Explain
	ui_BetFrame_ScoreLabel[4] = WorldCup_Frame_BetSet4_Explain
	ui_BetFrame_SubmitButton[1] = WorldCup_Frame_BetSet1_OK
	ui_BetFrame_SubmitButton[2] = WorldCup_Frame_BetSet2_OK
	ui_BetFrame_SubmitButton[3] = WorldCup_Frame_BetSet3_OK
	ui_BetFrame_SubmitButton[4] = WorldCup_Frame_BetSet4_OK

end

function WorldCup_OnEvent(event)
	--游戏窗口尺寸或游戏分辨率发生了变化
	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		WorldCup_Frame:SetProperty("UnifiedXPosition", g_WorldCup_Frame_UnifiedXPosition)
		WorldCup_Frame:SetProperty("UnifiedYPosition", g_WorldCup_Frame_UnifiedYPosition)
	--服务器发来事件
	elseif event == "UI_COMMAND" and tonumber(arg0) == 220 then
		local code = Get_XParam_INT(0)
		if code == 220 then
			if g_WorldCup_DataValid > 0 then
				this:Show()
				WorldCup_Frame_DateFrame:Show()
				WorldCup_UIRefresh()
				local targetId = tonumber(Get_XParam_INT(1))
				local careObject = DataPool:GetNPCIDByServerID(targetId)
				if careObject ~= -1 then
					this:CareObject(careObject, 1)
				end
			else
				PushDebugMessage("#{SJB_100520_30}")
			end
		elseif code == 410 then
			this:Hide()
		end
	--刷新数据事件
	elseif event == "WORLDCUP_READY" then
		if WorldCup_DataInit() < 0 then	--世界杯数据有误
			this:Hide()
			return
		end
		WorldCup_UIRefresh()
	end
end

function WorldCup_DataInit()
	g_WorldCup_DataValid = 0
	--玩家积分
	g_WorldCup_Score = GetWorldCupScore()

	--比赛数据
	g_WorldCup_MatchData = {}
	for i = 1, g_WorldCup_MaxMatchIndex do
		local index, month, day, hour, minute, player1, player2, score1, score2, started, finished, display1, display2, bidResult, bidScore = GetWorldCupMatch(i - 1)	--下标从0开始
		if index <= 0 then
			return -1
		end
		g_WorldCup_MatchData[i] = {}
		g_WorldCup_MatchData[i]["Index"] = index			--场次 1~64
		g_WorldCup_MatchData[i]["Month"] = month			--比赛日期（月）
		g_WorldCup_MatchData[i]["Day"] = day				--比赛日期（日）
		g_WorldCup_MatchData[i]["Hour"] = hour				--比赛时间（时）
		g_WorldCup_MatchData[i]["Minute"] = minute			--比赛时间（分）
		g_WorldCup_MatchData[i]["Player1"] = player1		--主场队伍索引
		g_WorldCup_MatchData[i]["Player2"] = player2		--客场队伍索引
		g_WorldCup_MatchData[i]["Score1"] = score1			--主场队伍得分
		g_WorldCup_MatchData[i]["Score2"] = score2			--客场队伍得分
		g_WorldCup_MatchData[i]["Started"] = started		--比赛是否开始标记
		g_WorldCup_MatchData[i]["Finished"] = finished		--比赛是否完成标记
		g_WorldCup_MatchData[i]["Display1"] = display1		--比赛是否显示在竞猜区
		g_WorldCup_MatchData[i]["Display2"] = display2		--比赛是否显示在观战区
		g_WorldCup_MatchData[i]["BidResult"] = bidResult	--玩家竞猜这场比赛的结果，若没有竞猜返回-1
		g_WorldCup_MatchData[i]["BidScore"] = bidScore		--玩家竞猜这场比赛的下注，若没有竞猜返回-1
		g_WorldCup_MatchData[i]["Result"] = 0				--比赛的真实结果 0 比赛未完成 1 主场胜 2 主场负 3 平局
		g_WorldCup_MatchData[i]["Winner"] = ""				--胜利者的名字，用于淘汰赛
		if finished > 0 then	--比赛已完成，可以计算结果
			if score1 > score2 then
				g_WorldCup_MatchData[i]["Result"] = 1
				g_WorldCup_MatchData[i]["Winner"] = g_WorldCup_Player[player1]
			elseif score1 < score2 then
				g_WorldCup_MatchData[i]["Result"] = 2
				g_WorldCup_MatchData[i]["Winner"] = g_WorldCup_Player[player2]
			else
				g_WorldCup_MatchData[i]["Result"] = 3
			end
		end
		g_WorldCup_MatchData[i]["Name1"] = g_WorldCup_Player[player1]											--主场队名
		g_WorldCup_MatchData[i]["Name2"] = g_WorldCup_Player[player2]											--客场队名
		g_WorldCup_MatchData[i]["Name"] = g_WorldCup_Player[player1] .. " VS " .. g_WorldCup_Player[player2]	--对战双方名，如 XXXX VS YYYY
		g_WorldCup_MatchData[i]["Type"] = g_WorldCup_MatchType[index]											--比赛类型值
		g_WorldCup_MatchData[i]["TypeName"] = g_WorldCup_MatchTypeName[g_WorldCup_MatchType[index]]				--比赛类型名
		g_WorldCup_MatchData[i]["MaxScore"] = g_WorldCup_MatchTypeScore[g_WorldCup_MatchType[index]]			--比赛下注上限
		g_WorldCup_MatchData[i]["BidName"] = g_WorldCup_BidName[bidResult]										--下注项描述
		local scoreStr = "#{SJB_XML_47}"
		if started > 0 then	--比赛已经开始，可以显示比分
			scoreStr = tostring(score1) .. " : " .. tostring(score2)
		end
		g_WorldCup_MatchData[i]["Score"] = scoreStr																--对战双方得分，如 3 : 0
		local dateStr = tostring(month) .. "#{SJB_XML_49}"
		if day < 10 then
			dateStr = dateStr .. " "
		end
		dateStr = dateStr .. tostring(day) .. "#{SJB_XML_48}"
		g_WorldCup_MatchData[i]["Date"] = dateStr																--比赛日期，如 7月 1日
		local timeStr = ""
		if hour < 10 then
			timeStr = timeStr .. "0"
		end
		timeStr = timeStr .. tostring(hour) .. ":"
		if minute < 10 then
			timeStr = timeStr .. "0"
		end
		timeStr = timeStr .. tostring(minute)
		g_WorldCup_MatchData[i]["Time"] = timeStr																--比赛时间，如02:30
	end

	--队伍数据
	g_WorldCup_PlayerData = {}
	for id = 1, g_WorldCup_MaxPlayerId do
		g_WorldCup_PlayerData[id] = {}
		g_WorldCup_PlayerData[id]["Id"] = id							--队伍编号（内部使用）
		g_WorldCup_PlayerData[id]["Name"] = g_WorldCup_Player[id]		--队伍名称
		g_WorldCup_PlayerData[id]["Group"] = math.floor((id + 3) / 4)	--队伍所在小组
		local playerMatch = 0
		local playerScore = 0
		local playerGoal = 0
		local otherGoal = 0
		for i = 1, g_WorldCup_MaxMatchIndex do	--计算已参加小组赛场数、积分和净胜球
			if g_WorldCup_MatchData[i]["Type"] <= 8 and g_WorldCup_MatchData[i]["Finished"] > 0 and (g_WorldCup_MatchData[i]["Player1"] == id or g_WorldCup_MatchData[i]["Player2"] == id) then	--是已经比完的小组赛且有这个队伍的比赛
				playerMatch = playerMatch + 1
				if g_WorldCup_MatchData[i]["Player1"] == id then	--俺是主场滴~ PS: 世界杯不分主客场，暂且这么叫吧，前面那个叫主场(^-^)
					playerGoal = playerGoal + g_WorldCup_MatchData[i]["Score1"]
					otherGoal = otherGoal + g_WorldCup_MatchData[i]["Score2"]
					if g_WorldCup_MatchData[i]["Result"] == 1 then	--俺（主场）赢了
						playerScore = playerScore + 3
					elseif g_WorldCup_MatchData[i]["Result"] == 3 then	--平了
						playerScore = playerScore + 1
					end
				else	--俺是客场滴~
					playerGoal = playerGoal + g_WorldCup_MatchData[i]["Score2"]
					otherGoal = otherGoal + g_WorldCup_MatchData[i]["Score1"]
					if g_WorldCup_MatchData[i]["Result"] == 2 then	--对方（主场）输了
						playerScore = playerScore + 3
					elseif g_WorldCup_MatchData[i]["Result"] == 3 then	--平了
						playerScore = playerScore + 1
					end
				end
			end
		end
		g_WorldCup_PlayerData[id]["Match"] = playerMatch				--已参加小组赛场数
		g_WorldCup_PlayerData[id]["Score"] = playerScore				--小组赛积分
		g_WorldCup_PlayerData[id]["PlayerGoal"] = playerGoal			--小组赛进球数
		g_WorldCup_PlayerData[id]["OtherGoal"] = otherGoal				--小组赛失球数
		g_WorldCup_PlayerData[id]["Goal"] = playerGoal - otherGoal		--小组赛净胜球
	end

	--所有数据成功准备完毕
	g_WorldCup_DataValid = 1
	return 1
end

function WorldCup_UIRefresh()
	if this:IsVisible() then
		WorldCup_Frame_Score:SetText("#{SJB_XML_5}" .. tostring(g_WorldCup_Score))
		if WorldCup_Frame_DateFrame:IsVisible() then
			WorldCup_DateFrame_Show()
		elseif WorldCup_Frame_ViewFrame:IsVisible() then
			WorldCup_ViewFrame_Show()
		elseif WorldCup_Frame_BetFrame:IsVisible() then
			WorldCup_BetFrame_Show()
		end
	end
end

function WorldCup_AskData()
	--向服务器发送数据请求刷新界面
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("AddBid")
		Set_XSCRIPT_ScriptID(808300)
		Set_XSCRIPT_Parameter(0, 0)
		Set_XSCRIPT_Parameter(1, 0)
		Set_XSCRIPT_Parameter(2, 0)
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
end

function WorldCup_DateFrame_Show()
	WorldCup_Frame_BtnDate:SetCheck(1)
	WorldCup_Frame_DateView:SetCheck(0)
	WorldCup_Frame_BtnBet:SetCheck(0)
	WorldCup_Frame_DateFrame:Show()
	WorldCup_Frame_ViewFrame:Hide()
	WorldCup_Frame_BetFrame:Hide()

	for group = 1, 8 do
		local firstGroupPlayer = 4 * group  - 3
		ui_DateFrame_GroupListBox[group]:ClearListBox()
		ui_DateFrame_GroupListBox[group]:Disable()
		for i = 0, 3 do
			local playerData = WorldCup_GetPlayer(firstGroupPlayer + i)
			if playerData == nil then
				return
			end
			ui_DateFrame_GroupListBox[group]:AddItem(playerData["Name"], i)
		end
	end

	WorldCup_SetDateFrame_Player(49, 1, 2)
	WorldCup_SetDateFrame_Player(50, 3, 4)
	WorldCup_SetDateFrame_Player(51, 11, 12)
	WorldCup_SetDateFrame_Player(52, 9, 10)
	WorldCup_SetDateFrame_Player(53, 5, 6)
	WorldCup_SetDateFrame_Player(54, 7, 8)
	WorldCup_SetDateFrame_Player(55, 13, 14)
	WorldCup_SetDateFrame_Player(56, 15, 16)

	WorldCup_SetDateFrame_Winner(49, 1)
	WorldCup_SetDateFrame_Winner(50, 2)
	WorldCup_SetDateFrame_Winner(51, 6)
	WorldCup_SetDateFrame_Winner(52, 5)
	WorldCup_SetDateFrame_Winner(53, 3)
	WorldCup_SetDateFrame_Winner(54, 4)
	WorldCup_SetDateFrame_Winner(55, 7)
	WorldCup_SetDateFrame_Winner(56, 8)
	WorldCup_SetDateFrame_Winner(57, 10)
	WorldCup_SetDateFrame_Winner(58, 9)
	WorldCup_SetDateFrame_Winner(59, 11)
	WorldCup_SetDateFrame_Winner(60, 12)
	WorldCup_SetDateFrame_Winner(61, 13)
	WorldCup_SetDateFrame_Winner(62, 14)
	--WorldCup_SetDateFrame_Winner(63, -1)	--第三名争夺赛没有对应控件，不写了
	WorldCup_SetDateFrame_Winner(64, 15)
end

function WorldCup_ViewFrame_Show()
	WorldCup_Frame_BtnDate:SetCheck(0)
	WorldCup_Frame_DateView:SetCheck(1)
	WorldCup_Frame_BtnBet:SetCheck(0)
	WorldCup_Frame_DateFrame:Hide()
	WorldCup_Frame_ViewFrame:Show()
	WorldCup_Frame_BetFrame:Hide()

	WorldCup_Frame_ViewFrame_ResultSet:RemoveAllItem()
	for i = 1, g_WorldCup_MaxMatchIndex do
		local matchData = g_WorldCup_MatchData[i]
		local textColor = "#W"	--文字颜色
		if matchData["Finished"] > 0 then		--已完成的用绿色
			textColor = "#G"
		elseif matchData["Started"] > 0 then	--已开始未完成的用红色
			textColor = "#Y"
		end
		--注：列表控件要求行数和列数从下标0开始
		WorldCup_Frame_ViewFrame_ResultSet:AddNewItem(" " .. textColor .. matchData["Date"], 0, i - 1)
		WorldCup_Frame_ViewFrame_ResultSet:AddNewItem(textColor .. matchData["Time"], 1, i - 1)
		WorldCup_Frame_ViewFrame_ResultSet:AddNewItem(textColor .. matchData["Name"], 2, i - 1)
		WorldCup_Frame_ViewFrame_ResultSet:AddNewItem(textColor .. matchData["Score"], 3, i - 1)
		WorldCup_Frame_ViewFrame_ResultSet:AddNewItem(textColor .. matchData["Index"], 4, i - 1)
		WorldCup_Frame_ViewFrame_ResultSet:AddNewItem(textColor .. matchData["TypeName"], 5, i - 1)
	end

	WorldCup_ViewFrame_GroupButton_Click(1)
end

function WorldCup_ViewFrame_GroupButton_Click(group)
	for i = 1, 8 do
		if i == group then
			ui_ViewFrame_GroupButton[i]:SetCheck(1)
		else
			ui_ViewFrame_GroupButton[i]:SetCheck(0)
		end
	end
	local firstGroupPlayer = 4 * group  - 3
	WorldCup_Frame_ViewFrame_TeamScore:RemoveAllItem()
	for i = 0, 3 do
		local playerData = WorldCup_GetPlayer(firstGroupPlayer + i)
		if playerData == nil then
			return
		end
		WorldCup_Frame_ViewFrame_TeamScore:AddNewItem(" " .. playerData["Name"], 0, i)
		WorldCup_Frame_ViewFrame_TeamScore:AddNewItem(playerData["Match"], 1, i)
		WorldCup_Frame_ViewFrame_TeamScore:AddNewItem(playerData["Goal"], 2, i)
		WorldCup_Frame_ViewFrame_TeamScore:AddNewItem(playerData["Score"], 3, i)
	end
end

function WorldCup_BetFrame_Show()
	WorldCup_Frame_BtnDate:SetCheck(0)
	WorldCup_Frame_DateView:SetCheck(0)
	WorldCup_Frame_BtnBet:SetCheck(1)
	WorldCup_Frame_DateFrame:Hide()
	WorldCup_Frame_ViewFrame:Hide()
	WorldCup_Frame_BetFrame:Show()

	local counter1 = 0
	local counter2 = 0
	WorldCup_Frame_BetFrame_ResultTitle:RemoveAllItem()
	for i = 1, g_WorldCup_MaxMatchIndex do
		local matchData = g_WorldCup_MatchData[i]
		if matchData == nil then
			return
		end
		if matchData["Display1"] > 0 then
			counter1 = counter1 + 1
			if counter1 > 4 then
				break
			end
			ui_BetFrame_Set[counter1]:Show()
			ui_BetFrame_DateLabel[counter1]:SetText(matchData["Date"])
			ui_BetFrame_TimeLabel[counter1]:SetText(matchData["Time"])
			ui_BetFrame_NameLabel[counter1]:SetText(matchData["Name"])
			ui_BetFrame_IndexLabel[counter1]:SetText(matchData["Index"])
			if matchData["BidScore"] > 0 then	--已竞猜
				for j = 1, 3 do
					ui_BetFrame_BetCheckBoxLabel[counter1][j]:Hide()
					ui_BetFrame_BetCheckBox[counter1][j]:Hide()
				end
				ui_BetFrame_BetLabel[counter1]:Show()
				ui_BetFrame_BetLabel[counter1]:SetText(matchData["BidName"])
				ui_BetFrame_ScoreTextBox[counter1]:Hide()
				ui_BetFrame_ScoreLabel[counter1]:SetText(matchData["BidScore"])
				ui_BetFrame_SubmitButton[counter1]:Hide()
			else	--未竞猜
				for j = 1, 3 do
					ui_BetFrame_BetCheckBoxLabel[counter1][j]:Show()
					ui_BetFrame_BetCheckBox[counter1][j]:Show()
					ui_BetFrame_BetCheckBox[counter1][j]:Enable()
					ui_BetFrame_BetCheckBox[counter1][j]:SetCheck(0)
					if matchData["Index"] > g_WorldCup_MaxGroupMatchIndex then	--淘汰赛没有平局
						ui_BetFrame_BetCheckBox[counter1][3]:Disable()
					end
				end
				ui_BetFrame_BetLabel[counter1]:Hide()
				ui_BetFrame_BetLabel[counter1]:SetText("")
				ui_BetFrame_ScoreTextBox[counter1]:Show()
				ui_BetFrame_ScoreTextBox[counter1]:SetText("")
				ui_BetFrame_ScoreLabel[counter1]:SetText("/" .. tostring(matchData["MaxScore"]))
				ui_BetFrame_SubmitButton[counter1]:Show()
			end
		end
		if matchData["Display2"] > 0 then
			counter2 = counter2 + 1
			if counter2 > 4 then
				break
			end
			local textColor = "#W"	--文字颜色
			if matchData["Finished"] > 0 then		--已完成的用绿色
				textColor = "#G"
			elseif matchData["Started"] > 0 then	--已开始未完成的用红色
				textColor = "#Y"
			end
			WorldCup_Frame_BetFrame_ResultTitle:AddNewItem(" " .. textColor .. matchData["Date"], 0, counter2 - 1)
			WorldCup_Frame_BetFrame_ResultTitle:AddNewItem(textColor .. matchData["Time"], 1, counter2 - 1)
			WorldCup_Frame_BetFrame_ResultTitle:AddNewItem(textColor .. matchData["Name"], 2, counter2 - 1)
			WorldCup_Frame_BetFrame_ResultTitle:AddNewItem(textColor .. matchData["Index"], 3, counter2 - 1)
			WorldCup_Frame_BetFrame_ResultTitle:AddNewItem(textColor .. matchData["Score"], 4, counter2 - 1)
			if matchData["BidScore"] > 0 then
				WorldCup_Frame_BetFrame_ResultTitle:AddNewItem(textColor .. matchData["BidScore"], 5, counter2 - 1)
				WorldCup_Frame_BetFrame_ResultTitle:AddNewItem(textColor .. matchData["BidName"], 6, counter2 - 1)
				if matchData["Result"] > 0 then
					if matchData["BidResult"] == matchData["Result"] then
						WorldCup_Frame_BetFrame_ResultTitle:AddNewItem(textColor .. "+" .. tostring(2 * matchData["BidScore"]), 7, counter2 - 1)
					else
						WorldCup_Frame_BetFrame_ResultTitle:AddNewItem(textColor .. "0", 7, counter2 - 1)
					end
				else
					WorldCup_Frame_BetFrame_ResultTitle:AddNewItem(textColor .. matchData["BidName"], 6, counter2 - 1)
					WorldCup_Frame_BetFrame_ResultTitle:AddNewItem(textColor .. "#{SJB_XML_47}", 7, counter2 - 1)
				end
			else
				WorldCup_Frame_BetFrame_ResultTitle:AddNewItem(textColor .. "#{SJB_XML_47}", 5, counter2 - 1)
				WorldCup_Frame_BetFrame_ResultTitle:AddNewItem(textColor .. "#{SJB_XML_47}", 6, counter2 - 1)
				WorldCup_Frame_BetFrame_ResultTitle:AddNewItem(textColor .. "0", 7, counter2 - 1)
			end
		end
	end
	for i = counter1 + 1, 4 do
		ui_BetFrame_Set[i]:Hide()
	end
end

function WorldCup_BetFrame_BetCheckBox_Click(index, value)
	for i = 1, 3 do
		if i == value then
			ui_BetFrame_BetCheckBox[index][i]:SetCheck(1)
		else
			ui_BetFrame_BetCheckBox[index][i]:SetCheck(0)
		end
	end
end

function WorldCup_BetFrame_SubmitButton_Click(pos)
	local bidIndex = tonumber(ui_BetFrame_IndexLabel[pos]:GetText())
	local matchData = WorldCup_GetMatch(bidIndex)
	if matchData == nil then
		return
	end
	local bidResult = 0
	for i = 1, 3 do
		if ui_BetFrame_BetCheckBox[pos][i]:GetCheck() == 1 then
			bidResult = i
			break
		end
	end
	if bidResult == 0 then
		PushDebugMessage("#{SJB_100520_5}")
		return
	end
	local bidScore = ui_BetFrame_ScoreTextBox[pos]:GetText()
	if bidScore == "" then
		PushDebugMessage("#{SJB_100520_6}")
		return
	end
	bidScore = tonumber(bidScore)
	if bidScore <= 0 then
		PushDebugMessage("#{SJB_100520_28}")
		return
	end
	if bidScore > matchData["MaxScore"] then
		PushDebugMessage("#{SJB_100520_29}")
		return
	end
	if bidScore > g_WorldCup_Score then
		PushDebugMessage("#{SJB_100520_7}")
		return
	end
	--向服务器发送数据
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("AddBid")
		Set_XSCRIPT_ScriptID(808300)
		Set_XSCRIPT_Parameter(0, bidIndex)
		Set_XSCRIPT_Parameter(1, bidResult)
		Set_XSCRIPT_Parameter(2, bidScore)
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
end

----------------
--辅助函数开始--
----------------

--用于返回一场比赛的引用，注意在使用过程中不要修改此引用的数据！
function WorldCup_GetMatch(index)
	for i = 1, g_WorldCup_MaxMatchIndex do
		if g_WorldCup_MatchData[i]["Index"] == index then
			return g_WorldCup_MatchData[i]
		end
	end
	return nil
end

--用于返回一个队伍的引用，注意在使用过程中不要修改此引用的数据！
function WorldCup_GetPlayer(id)
	if id >= 1 and id <= g_WorldCup_MaxPlayerId then
		return g_WorldCup_PlayerData[id]
	end
	return nil
end

--将某场比赛对战双方的名字写到两个控件上去
function WorldCup_SetDateFrame_Player(matchIndex, control1, control2)
	if matchIndex > g_WorldCup_MaxGroupMatchIndex and matchIndex <= 56 then	--只有1/8决赛才能使用这个函数，比赛未结束也写
		local matchData = WorldCup_GetMatch(matchIndex)
		if matchData == nil then
			return
		end
		ui_DateFrame_PlayerLabel[control1]:SetText(matchData["Name1"])
		ui_DateFrame_PlayerLabel[control2]:SetText(matchData["Name2"])
	end
end

--将某场比赛的胜利者名字写到一个控件上去
function WorldCup_SetDateFrame_Winner(matchIndex, control)
	if matchIndex > g_WorldCup_MaxGroupMatchIndex and matchIndex <= g_WorldCup_MaxMatchIndex then	--只有淘汰赛才能使用这个函数，比赛未结束不写
		local matchData = WorldCup_GetMatch(matchIndex)
		if matchData == nil then
			return
		end
		if matchData["Finished"] > 0 then
			ui_DateFrame_WinnerLabel[control]:SetText(matchData["Winner"])
		end
	end
end

----------------
--辅助函数结束--
----------------
