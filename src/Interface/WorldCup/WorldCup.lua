--2010�Ϸ����籭�ʰ����ű�
--Added by Jiang Yin. 2010-05-20.

--�������������������ʱ�����޸�
local g_WorldCup_Player =
{
	"#{SJB_XML_50}",		"#{SJB_XML_51}",		"#{SJB_XML_52}",		"#{SJB_XML_53}",	--A(1)��
	"#{SJB_XML_54}",		"#{SJB_XML_55}",		"#{SJB_XML_56}",		"#{SJB_XML_57}",	--B(2)��
	"#{SJB_XML_58}",		"#{SJB_XML_59}",		"#{SJB_XML_60}",		"#{SJB_XML_61}",	--C(3)��
	"#{SJB_XML_62}",		"#{SJB_XML_63}",		"#{SJB_XML_64}",		"#{SJB_XML_65}",	--D(4)��
	"#{SJB_XML_66}",		"#{SJB_XML_67}",		"#{SJB_XML_68}",		"#{SJB_XML_69}",	--E(5)��
	"#{SJB_XML_70}",		"#{SJB_XML_71}",		"#{SJB_XML_72}",		"#{SJB_XML_73}",	--F(6)��
	"#{SJB_XML_74}",		"#{SJB_XML_75}",		"#{SJB_XML_76}",		"#{SJB_XML_77}",	--G(7)��
	"#{SJB_XML_78}",		"#{SJB_XML_79}",		"#{SJB_XML_80}",		"#{SJB_XML_81}",	--H(8)��
	"#{SJB_XML_82}",		"#{SJB_XML_83}",		"#{SJB_XML_84}",		"#{SJB_XML_85}",
	"#{SJB_XML_86}",		"#{SJB_XML_87}",		"#{SJB_XML_88}",		"#{SJB_XML_89}",
	"#{SJB_XML_90}",		"#{SJB_XML_91}",		"#{SJB_XML_92}",		"#{SJB_XML_93}",
	"#{SJB_XML_94}",		"#{SJB_XML_95}",		"#{SJB_XML_96}",		"#{SJB_XML_97}",
	"#{SJB_XML_98}",		"#{SJB_XML_99}",		"#{SJB_XML_100}",		"#{SJB_XML_101}",
	"#{SJB_XML_102}",		"#{SJB_XML_103}",		"#{SJB_XML_104}",		"#{SJB_XML_105}",
	"#{SJB_XML_106}",		"#{SJB_XML_107}",		"#{SJB_XML_108}",		"#{SJB_XML_109}",
	"#{SJB_XML_110}",		"#{SJB_XML_111}",		"#{SJB_XML_112}",		"#{SJB_XML_113}",
}
g_WorldCup_Player[0] = ""		--�������ݴ��õ�����
g_WorldCup_Player[255] = ""
--������������������������ʱ�����޸�
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
--��ע��������������������ʱ�����޸�
local g_WorldCup_BidName =
{
	"#{SJB_XML_115}",	--1
	"#{SJB_XML_116}",	--2
	"#{SJB_XML_117}",	--3
}
--����������ע���ޣ�������������ʱ�����޸�
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
--�������ͣ�������������ʱ�����޸�
local g_WorldCup_MatchType =
{
	1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8,	1, 1, 2, 2, 4, 3, 3, 4, 5, 5, 6, 6, 7, 7, 8, 8,	1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8,	--С����
	9, 9, 9, 9, 9, 9, 9, 9,	--1/8����
	10, 10, 10, 10,	--1/4����
	11, 11,	--�����
	12,	--����������
	13, --����
}

--������ȷУ���ʶ
local g_WorldCup_DataValid = 0
--��ҵ÷֣�ע�������ֻ��ʹ��WorldCup_DataInit�����޸ģ�
local g_WorldCup_Score = 0
--�������ݣ�ע�������ֻ��ʹ��WorldCup_DataInit�����޸ģ�
local g_WorldCup_MatchData = {}
--�������ݣ�ע�������ֻ��ʹ��WorldCup_DataInit�����޸ģ�
local g_WorldCup_PlayerData = {}
--�ܳ�������������������ʱ�����޸�
local g_WorldCup_MaxMatchIndex = 64
--С������������������������ʱ�����޸�
local g_WorldCup_MaxGroupMatchIndex = 48
--�ܶ�������������������ʱ�����޸�
local g_WorldCup_MaxPlayerId = 32
--�����Ĭ�����λ��
local g_WorldCup_Frame_UnifiedXPosition = 0
local g_WorldCup_Frame_UnifiedYPosition = 0
--�������黯
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
	--��Ϸ���ڳߴ緢���˱仯
	this:RegisterEvent("ADJEST_UI_POS")
	--��Ϸ�ֱ��ʷ����˱仯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	--������UI�¼�
	this:RegisterEvent("UI_COMMAND")
	--���籭���ݳ�ʱ
	this:RegisterEvent("WORLDCUP_OVERTIME")
	--���籭���ݵ���
	this:RegisterEvent("WORLDCUP_READY")
end

function WorldCup_OnLoad()
	--��������Ĭ�����λ��
	g_WorldCup_Frame_UnifiedXPosition = WorldCup_Frame:GetProperty("UnifiedXPosition")
	g_WorldCup_Frame_UnifiedYPosition = WorldCup_Frame:GetProperty("UnifiedYPosition")

	--�������黯
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
	--��Ϸ���ڳߴ����Ϸ�ֱ��ʷ����˱仯
	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		WorldCup_Frame:SetProperty("UnifiedXPosition", g_WorldCup_Frame_UnifiedXPosition)
		WorldCup_Frame:SetProperty("UnifiedYPosition", g_WorldCup_Frame_UnifiedYPosition)
	--�����������¼�
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
	--ˢ�������¼�
	elseif event == "WORLDCUP_READY" then
		if WorldCup_DataInit() < 0 then	--���籭��������
			this:Hide()
			return
		end
		WorldCup_UIRefresh()
	end
end

function WorldCup_DataInit()
	g_WorldCup_DataValid = 0
	--��һ���
	g_WorldCup_Score = GetWorldCupScore()

	--��������
	g_WorldCup_MatchData = {}
	for i = 1, g_WorldCup_MaxMatchIndex do
		local index, month, day, hour, minute, player1, player2, score1, score2, started, finished, display1, display2, bidResult, bidScore = GetWorldCupMatch(i - 1)	--�±��0��ʼ
		if index <= 0 then
			return -1
		end
		g_WorldCup_MatchData[i] = {}
		g_WorldCup_MatchData[i]["Index"] = index			--���� 1~64
		g_WorldCup_MatchData[i]["Month"] = month			--�������ڣ��£�
		g_WorldCup_MatchData[i]["Day"] = day				--�������ڣ��գ�
		g_WorldCup_MatchData[i]["Hour"] = hour				--����ʱ�䣨ʱ��
		g_WorldCup_MatchData[i]["Minute"] = minute			--����ʱ�䣨�֣�
		g_WorldCup_MatchData[i]["Player1"] = player1		--������������
		g_WorldCup_MatchData[i]["Player2"] = player2		--�ͳ���������
		g_WorldCup_MatchData[i]["Score1"] = score1			--��������÷�
		g_WorldCup_MatchData[i]["Score2"] = score2			--�ͳ�����÷�
		g_WorldCup_MatchData[i]["Started"] = started		--�����Ƿ�ʼ���
		g_WorldCup_MatchData[i]["Finished"] = finished		--�����Ƿ���ɱ��
		g_WorldCup_MatchData[i]["Display1"] = display1		--�����Ƿ���ʾ�ھ�����
		g_WorldCup_MatchData[i]["Display2"] = display2		--�����Ƿ���ʾ�ڹ�ս��
		g_WorldCup_MatchData[i]["BidResult"] = bidResult	--��Ҿ����ⳡ�����Ľ������û�о��·���-1
		g_WorldCup_MatchData[i]["BidScore"] = bidScore		--��Ҿ����ⳡ��������ע����û�о��·���-1
		g_WorldCup_MatchData[i]["Result"] = 0				--��������ʵ��� 0 ����δ��� 1 ����ʤ 2 ������ 3 ƽ��
		g_WorldCup_MatchData[i]["Winner"] = ""				--ʤ���ߵ����֣�������̭��
		if finished > 0 then	--��������ɣ����Լ�����
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
		g_WorldCup_MatchData[i]["Name1"] = g_WorldCup_Player[player1]											--��������
		g_WorldCup_MatchData[i]["Name2"] = g_WorldCup_Player[player2]											--�ͳ�����
		g_WorldCup_MatchData[i]["Name"] = g_WorldCup_Player[player1] .. " VS " .. g_WorldCup_Player[player2]	--��ս˫�������� XXXX VS YYYY
		g_WorldCup_MatchData[i]["Type"] = g_WorldCup_MatchType[index]											--��������ֵ
		g_WorldCup_MatchData[i]["TypeName"] = g_WorldCup_MatchTypeName[g_WorldCup_MatchType[index]]				--����������
		g_WorldCup_MatchData[i]["MaxScore"] = g_WorldCup_MatchTypeScore[g_WorldCup_MatchType[index]]			--������ע����
		g_WorldCup_MatchData[i]["BidName"] = g_WorldCup_BidName[bidResult]										--��ע������
		local scoreStr = "#{SJB_XML_47}"
		if started > 0 then	--�����Ѿ���ʼ��������ʾ�ȷ�
			scoreStr = tostring(score1) .. " : " .. tostring(score2)
		end
		g_WorldCup_MatchData[i]["Score"] = scoreStr																--��ս˫���÷֣��� 3 : 0
		local dateStr = tostring(month) .. "#{SJB_XML_49}"
		if day < 10 then
			dateStr = dateStr .. " "
		end
		dateStr = dateStr .. tostring(day) .. "#{SJB_XML_48}"
		g_WorldCup_MatchData[i]["Date"] = dateStr																--�������ڣ��� 7�� 1��
		local timeStr = ""
		if hour < 10 then
			timeStr = timeStr .. "0"
		end
		timeStr = timeStr .. tostring(hour) .. ":"
		if minute < 10 then
			timeStr = timeStr .. "0"
		end
		timeStr = timeStr .. tostring(minute)
		g_WorldCup_MatchData[i]["Time"] = timeStr																--����ʱ�䣬��02:30
	end

	--��������
	g_WorldCup_PlayerData = {}
	for id = 1, g_WorldCup_MaxPlayerId do
		g_WorldCup_PlayerData[id] = {}
		g_WorldCup_PlayerData[id]["Id"] = id							--�����ţ��ڲ�ʹ�ã�
		g_WorldCup_PlayerData[id]["Name"] = g_WorldCup_Player[id]		--��������
		g_WorldCup_PlayerData[id]["Group"] = math.floor((id + 3) / 4)	--��������С��
		local playerMatch = 0
		local playerScore = 0
		local playerGoal = 0
		local otherGoal = 0
		for i = 1, g_WorldCup_MaxMatchIndex do	--�����Ѳμ�С�������������ֺ;�ʤ��
			if g_WorldCup_MatchData[i]["Type"] <= 8 and g_WorldCup_MatchData[i]["Finished"] > 0 and (g_WorldCup_MatchData[i]["Player1"] == id or g_WorldCup_MatchData[i]["Player2"] == id) then	--���Ѿ������С���������������ı���
				playerMatch = playerMatch + 1
				if g_WorldCup_MatchData[i]["Player1"] == id then	--����������~ PS: ���籭�������ͳ���������ô�аɣ�ǰ���Ǹ�������(^-^)
					playerGoal = playerGoal + g_WorldCup_MatchData[i]["Score1"]
					otherGoal = otherGoal + g_WorldCup_MatchData[i]["Score2"]
					if g_WorldCup_MatchData[i]["Result"] == 1 then	--����������Ӯ��
						playerScore = playerScore + 3
					elseif g_WorldCup_MatchData[i]["Result"] == 3 then	--ƽ��
						playerScore = playerScore + 1
					end
				else	--���ǿͳ���~
					playerGoal = playerGoal + g_WorldCup_MatchData[i]["Score2"]
					otherGoal = otherGoal + g_WorldCup_MatchData[i]["Score1"]
					if g_WorldCup_MatchData[i]["Result"] == 2 then	--�Է�������������
						playerScore = playerScore + 3
					elseif g_WorldCup_MatchData[i]["Result"] == 3 then	--ƽ��
						playerScore = playerScore + 1
					end
				end
			end
		end
		g_WorldCup_PlayerData[id]["Match"] = playerMatch				--�Ѳμ�С��������
		g_WorldCup_PlayerData[id]["Score"] = playerScore				--С��������
		g_WorldCup_PlayerData[id]["PlayerGoal"] = playerGoal			--С����������
		g_WorldCup_PlayerData[id]["OtherGoal"] = otherGoal				--С����ʧ����
		g_WorldCup_PlayerData[id]["Goal"] = playerGoal - otherGoal		--С������ʤ��
	end

	--�������ݳɹ�׼�����
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
	--�������������������ˢ�½���
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
	--WorldCup_SetDateFrame_Winner(63, -1)	--������������û�ж�Ӧ�ؼ�����д��
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
		local textColor = "#W"	--������ɫ
		if matchData["Finished"] > 0 then		--����ɵ�����ɫ
			textColor = "#G"
		elseif matchData["Started"] > 0 then	--�ѿ�ʼδ��ɵ��ú�ɫ
			textColor = "#Y"
		end
		--ע���б�ؼ�Ҫ���������������±�0��ʼ
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
			if matchData["BidScore"] > 0 then	--�Ѿ���
				for j = 1, 3 do
					ui_BetFrame_BetCheckBoxLabel[counter1][j]:Hide()
					ui_BetFrame_BetCheckBox[counter1][j]:Hide()
				end
				ui_BetFrame_BetLabel[counter1]:Show()
				ui_BetFrame_BetLabel[counter1]:SetText(matchData["BidName"])
				ui_BetFrame_ScoreTextBox[counter1]:Hide()
				ui_BetFrame_ScoreLabel[counter1]:SetText(matchData["BidScore"])
				ui_BetFrame_SubmitButton[counter1]:Hide()
			else	--δ����
				for j = 1, 3 do
					ui_BetFrame_BetCheckBoxLabel[counter1][j]:Show()
					ui_BetFrame_BetCheckBox[counter1][j]:Show()
					ui_BetFrame_BetCheckBox[counter1][j]:Enable()
					ui_BetFrame_BetCheckBox[counter1][j]:SetCheck(0)
					if matchData["Index"] > g_WorldCup_MaxGroupMatchIndex then	--��̭��û��ƽ��
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
			local textColor = "#W"	--������ɫ
			if matchData["Finished"] > 0 then		--����ɵ�����ɫ
				textColor = "#G"
			elseif matchData["Started"] > 0 then	--�ѿ�ʼδ��ɵ��ú�ɫ
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
	--���������������
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
--����������ʼ--
----------------

--���ڷ���һ�����������ã�ע����ʹ�ù����в�Ҫ�޸Ĵ����õ����ݣ�
function WorldCup_GetMatch(index)
	for i = 1, g_WorldCup_MaxMatchIndex do
		if g_WorldCup_MatchData[i]["Index"] == index then
			return g_WorldCup_MatchData[i]
		end
	end
	return nil
end

--���ڷ���һ����������ã�ע����ʹ�ù����в�Ҫ�޸Ĵ����õ����ݣ�
function WorldCup_GetPlayer(id)
	if id >= 1 and id <= g_WorldCup_MaxPlayerId then
		return g_WorldCup_PlayerData[id]
	end
	return nil
end

--��ĳ��������ս˫��������д�������ؼ���ȥ
function WorldCup_SetDateFrame_Player(matchIndex, control1, control2)
	if matchIndex > g_WorldCup_MaxGroupMatchIndex and matchIndex <= 56 then	--ֻ��1/8��������ʹ���������������δ����Ҳд
		local matchData = WorldCup_GetMatch(matchIndex)
		if matchData == nil then
			return
		end
		ui_DateFrame_PlayerLabel[control1]:SetText(matchData["Name1"])
		ui_DateFrame_PlayerLabel[control2]:SetText(matchData["Name2"])
	end
end

--��ĳ��������ʤ��������д��һ���ؼ���ȥ
function WorldCup_SetDateFrame_Winner(matchIndex, control)
	if matchIndex > g_WorldCup_MaxGroupMatchIndex and matchIndex <= g_WorldCup_MaxMatchIndex then	--ֻ����̭������ʹ���������������δ������д
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
--������������--
----------------
