-- ���Ѫ������UI
local g_Frame_UnifiedXPosition;
local g_Frame_UnifiedYPosition;
local g_IsTimerSet = 0
local g_iReconnect = 0
local g_MenPaiNameList =
{
	[0]  ={Name="#{HSSC_191009_128}" , Color="#cff6600", }, --����
	[1]  ={Name="#{HSSC_191009_35}" , Color="#cffcc00", }, --����
	[2]  ={Name="#{HSSC_191009_36}" , Color="#c00ff00", }, --ؤ��
	[3]  ={Name="#{HSSC_191009_31}" , Color="#c0000ff", }, --�䵱
	[4]  ={Name="#{HSSC_191009_32}" , Color="#cff99cc", }, --��ü
	[5]  ={Name="#{HSSC_191009_129}" , Color="#c007700", }, --����
	[6]  ={Name="#{HSSC_191009_130}" , Color="#cffff00", }, --����
	[7]  ={Name="#{HSSC_191009_34}" , Color="#cffffff", }, --��ɽ
	[8]  ={Name="#{HSSC_191009_33}" , Color="#c7700ff", }, --��ң
	[9]  ={Name="������"     , Color="#c999999", },	
}
local g_DuanWei1 = {
	[1] = "#{HSSC_191009_37}",
	[2] = "#{HSSC_191009_38}",
	[3] = "#{HSSC_191009_39}",
	[4] = "#{HSSC_191009_40}",
	[5] = "#{HSSC_191009_41}",
	[6] = "#{HSSC_191009_42}",
}
local g_DieColor = "#cff0000"
local g_DiaoXianColoer = "#ccccccc"

local g_Team_HP_Ctrl_List = {}
local g_Team_DuanWei_Ctrl_List = {}
local g_Team_MenPai_Ctrl_List = {}
local g_Team_Name_Ctrl_List = {}
local g_Team_Level_Ctrl_List = {}
local g_Team_KillNum_Ctrl_List = {}

local g_HuanShanLunJian_Fight_Test

function HuaShanLunJian_Fight_PreLoad()

	-- ��Ϸ���ڳߴ緢���˱仯
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- ��Ϸ�ֱ��ʷ����˱仯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("BWTROOPS_SHOW_FULLDATA_BOX")
	this:RegisterEvent("BWTROOPS_COPYDATA_FIRST_TIME")
	this:RegisterEvent("BWTROOPS_COPYDATA_REFRESH")
	this:RegisterEvent("BWTROOPS_COPYDATA_SYNC_TIME")
	this:RegisterEvent("BWTROOPS_RESULT_SHOW")
	this:RegisterEvent("BWTROOPS_COPYDATA_FULL_INFO")
	this:RegisterEvent("BWTROOPS_UPDATE_STATE")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	this:RegisterEvent("UI_COMMAND")

end

function HuaShanLunJian_Fight_CtrlList_InitData()

	for i=1, 6 do
		g_Team_Name_Ctrl_List[i]:SetText("")
		g_Team_MenPai_Ctrl_List[i]:SetText("")
		g_Team_DuanWei_Ctrl_List[i]:SetText("")
		g_Team_HP_Ctrl_List[i]:SetProgress(0, 100)
		g_Team_Level_Ctrl_List[i]:SetText("")
		g_Team_KillNum_Ctrl_List[i]:SetText("")
	end

	HuaShanLunJian_Fight_Team1FirstKill:Hide()
	HuaShanLunJian_Fight_Team2FirstKill:Hide()
	--HuaShanLunJian_Fight_Team_Left:SetText("")
	--HuaShanLunJian_Fight_Team_Right:SetText("")
	--HuaShanLunJian_Fight_Leave:SetText("")
	HuaShanLunJian_Fight_TimeWatch:Hide()
	HuaShanLunJian_Fight_WatchText:SetText("")
	HuaShanLunJian_Fight_WatchText:Hide()
	HuaShanLunJian_Fight_Team1Win:Hide()
	HuaShanLunJian_Fight_Team1Fail:Hide()
	HuaShanLunJian_Fight_Team2Win:Hide()
	HuaShanLunJian_Fight_Team2Fail:Hide()
	HuaShanLunJian_Fight_Team1Draw:Hide()
	HuaShanLunJian_Fight_Team2Draw:Hide()
	
	-- HuaShanLunJian_Fight_LeftList_TitleBK:Hide()
	-- HuaShanLunJian_Fight_RightList_TitleBK:Hide()

end

function HuaShanLunJian_Fight_OnLoad()
	-- ��������Ĭ�����λ��
	g_Frame_UnifiedXPosition	= HuaShanLunJian_Fight_Frame:GetProperty("UnifiedXPosition");
	g_Frame_UnifiedYPosition	= HuaShanLunJian_Fight_Frame:GetProperty("UnifiedYPosition");

	--����1��3���һս�ӣ�����4-6���ڵڶ�ս��
	--���߻�С��������ȥ�ˣ��ռ�����level���Ҿ���ΪҲ��level������Ƕ�λ
	g_Team_DuanWei_Ctrl_List[1] = HuaShanLunJian_Fight_Left1Level;
	g_Team_DuanWei_Ctrl_List[2] = HuaShanLunJian_Fight_Left2Level;
	g_Team_DuanWei_Ctrl_List[3] = HuaShanLunJian_Fight_Left3Level;

	g_Team_DuanWei_Ctrl_List[4] = HuaShanLunJian_Fight_Right1Level;
	g_Team_DuanWei_Ctrl_List[5] = HuaShanLunJian_Fight_Right2Level;
	g_Team_DuanWei_Ctrl_List[6] = HuaShanLunJian_Fight_Right3Level;


	g_Team_MenPai_Ctrl_List[1] = HuaShanLunJian_Fight_Left1Career;
	g_Team_MenPai_Ctrl_List[2] = HuaShanLunJian_Fight_Left2Career;
	g_Team_MenPai_Ctrl_List[3] = HuaShanLunJian_Fight_Left3Career;

	g_Team_MenPai_Ctrl_List[4] = HuaShanLunJian_Fight_Right1Career;
	g_Team_MenPai_Ctrl_List[5] = HuaShanLunJian_Fight_Right2Career;
	g_Team_MenPai_Ctrl_List[6] = HuaShanLunJian_Fight_Right3Career;


	g_Team_Name_Ctrl_List[1] = HuaShanLunJian_Fight_Left1Name;
	g_Team_Name_Ctrl_List[2] = HuaShanLunJian_Fight_Left2Name;
	g_Team_Name_Ctrl_List[3] = HuaShanLunJian_Fight_Left3Name;

	g_Team_Name_Ctrl_List[4] = HuaShanLunJian_Fight_Right1Name;
	g_Team_Name_Ctrl_List[5] = HuaShanLunJian_Fight_Right2Name;
	g_Team_Name_Ctrl_List[6] = HuaShanLunJian_Fight_Right3Name;


	g_Team_HP_Ctrl_List[1] = HuaShanLunJian_Fight_Left1PlayerHP;
	g_Team_HP_Ctrl_List[2] = HuaShanLunJian_Fight_Left2PlayerHP;
	g_Team_HP_Ctrl_List[3] = HuaShanLunJian_Fight_Left3PlayerHP;

	g_Team_HP_Ctrl_List[4] = HuaShanLunJian_Fight_Right1PlayerHP;
	g_Team_HP_Ctrl_List[5] = HuaShanLunJian_Fight_Right2PlayerHP;
	g_Team_HP_Ctrl_List[6] = HuaShanLunJian_Fight_Right3PlayerHP;
	
	g_Team_Level_Ctrl_List[1] = HuaShanLunJian_Fight_Left1Score;
	g_Team_Level_Ctrl_List[2] = HuaShanLunJian_Fight_Left2Score;
	g_Team_Level_Ctrl_List[3] = HuaShanLunJian_Fight_Left3Score;

	g_Team_Level_Ctrl_List[4] = HuaShanLunJian_Fight_Right1Score;
	g_Team_Level_Ctrl_List[5] = HuaShanLunJian_Fight_Right2Score;
	g_Team_Level_Ctrl_List[6] = HuaShanLunJian_Fight_Right3Score;
	
	g_Team_KillNum_Ctrl_List[1] = HuaShanLunJian_Fight_Left1Kill;
	g_Team_KillNum_Ctrl_List[2] = HuaShanLunJian_Fight_Left2Kill;
	g_Team_KillNum_Ctrl_List[3] = HuaShanLunJian_Fight_Left3Kill;

	g_Team_KillNum_Ctrl_List[4] = HuaShanLunJian_Fight_Right1Kill;
	g_Team_KillNum_Ctrl_List[5] = HuaShanLunJian_Fight_Right2Kill;
	g_Team_KillNum_Ctrl_List[6] = HuaShanLunJian_Fight_Right3Kill;
	
	g_HuanShanLunJian_Fight_Test = -1
	
	HuaShanLunJian_Fight_CtrlList_InitData()
end

function HuaShanLunJian_Fight_OnEvent(event)

	if( event == "ADJEST_UI_POS" ) then
		HuaShanLunJian_Fight_ResetPos()
	elseif( event == "BWTROOPS_SHOW_FULLDATA_BOX") then
		--��ȡ������ʾ
		--HuaShanLunJian_Fight_CtrlList_InitData()
		--HuaShanLunJian_FightFrame_FullFill_Data(0)
		this:Show()
	elseif (event == "BWTROOPS_COPYDATA_FIRST_TIME")	then
		--��ȡ������ʾ
		HuaShanLunJian_Fight_CtrlList_InitData()
		--2.��ʼ��
		g_HuanShanLunJian_Fight_Test = tonumber(arg1)
		g_IsTimerSet = 0
		--g_IsFuckBaby = 0
		HuaShanLunJian_FightFrame_FullFill_Data(0)
		--ֻ�ڸ��¼����棬��ʼ��ʱ����
		HuaShanLunJian_Fight_SetTimer()
		HuaShanLunJian_Fight_ResetPos()
		this:Show()
	elseif (event == "BWTROOPS_COPYDATA_FULL_INFO" )	then
		--��ȡ������ʾ
		HuaShanLunJian_Fight_CtrlList_InitData()
		--2.��ʼ��
		g_HuanShanLunJian_Fight_Test = tonumber(arg1)
		g_IsTimerSet = 0
		--GM������ʱ�򣬻ᴥ���������.�����Ϊ1����˴��ҳ����¼���ִ�С�
		--g_IsFuckBaby = 1
		HuaShanLunJian_FightFrame_FullFill_Data(0)
		--ֻ�ڸ��¼����棬��ʼ��ʱ����
		HuaShanLunJian_Fight_SetTimer()
		g_iReconnect = 1
		HuaShanLunJian_Fight_ResetPos()
		this:Show()
	elseif  (event == "BWTROOPS_COPYDATA_REFRESH" )	 then
		--if (this:IsVisible())  then
			--��ȡ������ʾ����
			g_HuanShanLunJian_Fight_Test = tonumber(arg1)
			HuaShanLunJian_Fight_CtrlList_InitData()
			HuaShanLunJian_FightFrame_FullFill_Data(0)
		--end
	elseif ( event =="BWTROOPS_COPYDATA_SYNC_TIME") then
		--if (this:IsVisible())  then
		g_HuanShanLunJian_Fight_Test = tonumber(arg1)
			HuaShanLunJian_FightFrame_Sync_Time()
		--end

	elseif(event == "BWTROOPS_RESULT_SHOW")	 then
		--if (this:IsVisible())  then
			--��ȡ������ʾ����
			if tonumber(arg1) ~= -1 then
				g_HuanShanLunJian_Fight_Test = 1
			end
			HuaShanLunJian_Fight_CtrlList_InitData()
			HuaShanLunJian_FightFrame_FullFill_Data(1)
			g_iReconnect = 0
		--end
	elseif(event == "BWTROOPS_UPDATE_STATE")	 then
		--if (this:IsVisible())  then
			--��ȡ������ʾ����
			g_HuanShanLunJian_Fight_Test = tonumber(arg1)
			HuaShanLunJian_Fight_CtrlList_InitData()
			HuaShanLunJian_FightFrame_FullFill_Data(0)
		--end
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		if g_iReconnect ==  1 then
			g_iReconnect = 0
		else
			HuaShanLunJian_Fight_CtrlList_InitData()
			this:Hide()
		end
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 89289801) then --�򿪽���
		HuaShanLunJian_FightFrame_CloseWindow()
	end

end

--================================================
-- �ָ������Ĭ�����λ��
--================================================
function HuaShanLunJian_Fight_ResetPos()
	HuaShanLunJian_Fight_Frame:SetProperty("UnifiedXPosition", g_Frame_UnifiedXPosition);
	HuaShanLunJian_Fight_Frame:SetProperty("UnifiedYPosition", g_Frame_UnifiedYPosition);
end

function HuaShanLunJian_FightFrame_CloseWindow()
	this:Hide()
	PushEvent( "BWTROOPS_SHOW_MINI_BOX" )
end

--================================================
-- ˢ��ͬ����ʱ������
--================================================
function HuaShanLunJian_FightFrame_Sync_Time()
	local nCountTimers = XBW:GetBWTroopsPK_LeftTimes()
	if nCountTimers == nil then
		nCountTimers = 0
	end
	HuaShanLunJian_Fight_TimeWatch:SetProperty("Timer", tostring(nCountTimers))
	HuaShanLunJian_Fight_TimeWatch:Show()
end
--================================================
-- �������
--================================================
function HuaShanLunJian_FightFrame_FullFill_Data(index)


	local mUIDir = XBW:GetMyUIDirInfo()
	if mUIDir == nil then
		return 
	end
	
	local strtest = ""
	if g_HuanShanLunJian_Fight_Test == 1 then
		strtest = "#{HSLJ_190919_313}"
	else
		strtest = "#{HSSC_191009_30}"
	end
	HuaShanLunJian_Fight_LeftList_Title4:SetText(strtest)	
	HuaShanLunJian_Fight_RightList_Title4:SetText(strtest)
	
	if mUIDir == 0 then
		for i=1, 6 do
			if g_HuanShanLunJian_Fight_Test == 1 then
-------------
				local nGuid,nHP,nDuanWei,nMenPai,szName,nkill,nstate, nlevel = XBW:GetCopySceneBWPlayerInfoByIdx(i-1)
				--local nCalcBattleScire,nDuanWei = BWDH2018:GetCalcBattleScoreAndDuanweiInfoByIdx2018(i-1)
				--�������Ϸ���GUID��˵��6����û����
				--PushDebugMessage(nDuanWei)
				if nGuid ~= "" and nlevel > 0 then

					--���״̬�� ��
					if nstate == 0 then      --0-����
							g_Team_Name_Ctrl_List[i]:SetText(g_MenPaiNameList[nMenPai].Color..szName)  --����
							g_Team_MenPai_Ctrl_List[i]:SetText(g_MenPaiNameList[nMenPai].Color..g_MenPaiNameList[nMenPai].Name)  --����
							g_Team_DuanWei_Ctrl_List[i]:SetText(g_MenPaiNameList[nMenPai].Color..nDuanWei)  --duanewi
							g_Team_Level_Ctrl_List[i]:SetText(g_MenPaiNameList[nMenPai].Color..nlevel)
							g_Team_KillNum_Ctrl_List[i]:SetText(g_MenPaiNameList[nMenPai].Color..nkill)
							g_Team_HP_Ctrl_List[i]:SetProgress(nHP, 100)--Ѫ���ٷֱ�
					elseif nstate == 1 then  --1-����
							g_Team_Name_Ctrl_List[i]:SetText(g_DieColor..szName)  --����
							g_Team_MenPai_Ctrl_List[i]:SetText(g_DieColor..g_MenPaiNameList[nMenPai].Name)  --����
							g_Team_DuanWei_Ctrl_List[i]:SetText(g_DieColor..nDuanWei)  --�ȼ�
							g_Team_Level_Ctrl_List[i]:SetText(g_DieColor..nlevel)
							g_Team_KillNum_Ctrl_List[i]:SetText(g_DieColor..nkill)
							g_Team_HP_Ctrl_List[i]:SetProgress(0, 100)--Ѫ���ٷֱ�
					elseif nstate == 2 then  --2-����
							g_Team_Name_Ctrl_List[i]:SetText("")
							g_Team_MenPai_Ctrl_List[i]:SetText("")
							g_Team_DuanWei_Ctrl_List[i]:SetText("")
							g_Team_Level_Ctrl_List[i]:SetText("")
							g_Team_KillNum_Ctrl_List[i]:SetText("")
							g_Team_HP_Ctrl_List[i]:SetProgress(0, 100)
					end

				end
-------------			
			else
-------------
				local nGuid,nHP,nDuanWei,nMenPai,szName,nkill,nstate, nlevel = XBW:GetCopySceneBWPlayerInfoByIdx(i-1)
				--local nCalcBattleScire,nDuanWei = BWDH2018:GetCalcBattleScoreAndDuanweiInfoByIdx2018(i-1)
				--�������Ϸ���GUID��˵��6����û����
				--PushDebugMessage(nDuanWei)
				if nGuid ~= "" and nDuanWei >= 1 and nDuanWei <= 6 then

					--���״̬�� ��
					if nstate == 0 then      --0-����
							g_Team_Name_Ctrl_List[i]:SetText(g_MenPaiNameList[nMenPai].Color..szName)  --����
							g_Team_MenPai_Ctrl_List[i]:SetText(g_MenPaiNameList[nMenPai].Color..g_MenPaiNameList[nMenPai].Name)  --����
							g_Team_DuanWei_Ctrl_List[i]:SetText(g_MenPaiNameList[nMenPai].Color..g_DuanWei1[nDuanWei])  --duanewi
							g_Team_Level_Ctrl_List[i]:SetText(g_MenPaiNameList[nMenPai].Color..nlevel)
							g_Team_KillNum_Ctrl_List[i]:SetText(g_MenPaiNameList[nMenPai].Color..nkill)
							g_Team_HP_Ctrl_List[i]:SetProgress(nHP, 100)--Ѫ���ٷֱ�
					elseif nstate == 1 then  --1-����
							g_Team_Name_Ctrl_List[i]:SetText(g_DieColor..szName)  --����
							g_Team_MenPai_Ctrl_List[i]:SetText(g_DieColor..g_MenPaiNameList[nMenPai].Name)  --����
							g_Team_DuanWei_Ctrl_List[i]:SetText(g_DieColor..g_DuanWei1[nDuanWei])  --�ȼ�
							g_Team_Level_Ctrl_List[i]:SetText(g_DieColor..nlevel)
							g_Team_KillNum_Ctrl_List[i]:SetText(g_DieColor..nkill)
							g_Team_HP_Ctrl_List[i]:SetProgress(0, 100)--Ѫ���ٷֱ�
					elseif nstate == 2 then  --2-����
							g_Team_Name_Ctrl_List[i]:SetText("")
							g_Team_MenPai_Ctrl_List[i]:SetText("")
							g_Team_DuanWei_Ctrl_List[i]:SetText("")
							g_Team_Level_Ctrl_List[i]:SetText("")
							g_Team_KillNum_Ctrl_List[i]:SetText("")
							g_Team_HP_Ctrl_List[i]:SetProgress(0, 100)
					end

				end

-------------			
			end

		end
	elseif mUIDir == 1 then
		for i=1, 6 do
			if g_HuanShanLunJian_Fight_Test == 1 then
-------------	
				if i <= 3 then
					local nGuid,nHP,nDuanWei,nMenPai,szName,nkill,nstate ,nlevel = XBW:GetCopySceneBWPlayerInfoByIdx(i-1)
					--�������Ϸ���GUID��˵��6����û����
					--local nCalcBattleScire,nDuanWei = BWDH2018:GetCalcBattleScoreAndDuanweiInfoByIdx2018(i-1)
					--PushDebugMessage(nDuanWei)
					if nGuid ~= "" and nlevel > 0 then

						--���״̬�� ��
						if nstate == 0 then      --0-����
								g_Team_Name_Ctrl_List[i+3]:SetText(g_MenPaiNameList[nMenPai].Color..szName)  --����
								g_Team_MenPai_Ctrl_List[i+3]:SetText(g_MenPaiNameList[nMenPai].Color..g_MenPaiNameList[nMenPai].Name)  --����
								g_Team_DuanWei_Ctrl_List[i+3]:SetText(g_MenPaiNameList[nMenPai].Color..nDuanWei)  --�ȼ�
								g_Team_Level_Ctrl_List[i+3]:SetText(g_MenPaiNameList[nMenPai].Color..nlevel)
								g_Team_KillNum_Ctrl_List[i+3]:SetText(g_MenPaiNameList[nMenPai].Color..nkill)
								g_Team_HP_Ctrl_List[i+3]:SetProgress(nHP, 100)--Ѫ���ٷֱ�
						elseif nstate == 1 then  --1-����
								g_Team_Name_Ctrl_List[i+3]:SetText(g_DieColor..szName)  --����
								g_Team_MenPai_Ctrl_List[i+3]:SetText(g_DieColor..g_MenPaiNameList[nMenPai].Name)  --����
								g_Team_DuanWei_Ctrl_List[i+3]:SetText(g_DieColor..nDuanWei)  --�ȼ�
								g_Team_Level_Ctrl_List[i+3]:SetText(g_DieColor..nlevel)
								g_Team_KillNum_Ctrl_List[i+3]:SetText(g_DieColor..nkill)
								g_Team_HP_Ctrl_List[i+3]:SetProgress(0, 100)--Ѫ���ٷֱ�
						elseif nstate == 2 then  --2-����
								g_Team_Name_Ctrl_List[i+3]:SetText("")
								g_Team_MenPai_Ctrl_List[i+3]:SetText("")
								g_Team_DuanWei_Ctrl_List[i+3]:SetText("")
								g_Team_Level_Ctrl_List[i+3]:SetText("")
								g_Team_KillNum_Ctrl_List[i+3]:SetText("")
								g_Team_HP_Ctrl_List[i+3]:SetProgress(0, 100)
						end

					end
				end
				if i > 3 then
					local nGuid,nHP,nDuanWei,nMenPai,szName,nkill,nstate ,nlevel = XBW:GetCopySceneBWPlayerInfoByIdx(i-1)
					--local nCalcBattleScire,nDuanWei = BWDH2018:GetCalcBattleScoreAndDuanweiInfoByIdx2018(i-1)
					--�������Ϸ���GUID��˵��6����û����
					--PushDebugMessage(nDuanWei)
					if nGuid ~= "" then

						--���״̬�� ��
						if nstate == 0 then      --0-����
								g_Team_Name_Ctrl_List[i-3]:SetText(g_MenPaiNameList[nMenPai].Color..szName)  --����
								g_Team_MenPai_Ctrl_List[i-3]:SetText(g_MenPaiNameList[nMenPai].Color..g_MenPaiNameList[nMenPai].Name)  --����
								g_Team_DuanWei_Ctrl_List[i-3]:SetText(g_MenPaiNameList[nMenPai].Color..nDuanWei)  --�ȼ�
								g_Team_Level_Ctrl_List[i-3]:SetText(g_MenPaiNameList[nMenPai].Color..nlevel)
								g_Team_KillNum_Ctrl_List[i-3]:SetText(g_MenPaiNameList[nMenPai].Color..nkill)
								g_Team_HP_Ctrl_List[i-3]:SetProgress(nHP, 100)--Ѫ���ٷֱ�
						elseif nstate == 1 then  --1-����
								g_Team_Name_Ctrl_List[i-3]:SetText(g_DieColor..szName)  --����
								g_Team_MenPai_Ctrl_List[i-3]:SetText(g_DieColor..g_MenPaiNameList[nMenPai].Name)  --����
								g_Team_DuanWei_Ctrl_List[i-3]:SetText(g_DieColor..nDuanWei)  --�ȼ�
								g_Team_Level_Ctrl_List[i-3]:SetText(g_DieColor..nlevel)
								g_Team_KillNum_Ctrl_List[i-3]:SetText(g_DieColor..nkill)
								g_Team_HP_Ctrl_List[i-3]:SetProgress(0, 100)--Ѫ���ٷֱ�
						elseif nstate == 2 then  --2-����
								g_Team_Name_Ctrl_List[i-3]:SetText("")
								g_Team_MenPai_Ctrl_List[i-3]:SetText("")
								g_Team_DuanWei_Ctrl_List[i-3]:SetText("")
								g_Team_Level_Ctrl_List[i-3]:SetText("")
								g_Team_KillNum_Ctrl_List[i-3]:SetText("")
								g_Team_HP_Ctrl_List[i-3]:SetProgress(0, 100)
						end

					end
				end
-------------				
			else
-------------	
				if i <= 3 then
					local nGuid,nHP,nDuanWei,nMenPai,szName,nkill,nstate ,nlevel = XBW:GetCopySceneBWPlayerInfoByIdx(i-1)
					--�������Ϸ���GUID��˵��6����û����
					--local nCalcBattleScire,nDuanWei = BWDH2018:GetCalcBattleScoreAndDuanweiInfoByIdx2018(i-1)
					--PushDebugMessage(nDuanWei)
					if nGuid ~= "" and nDuanWei >= 1 and nDuanWei <= 6 then

						--���״̬�� ��
						if nstate == 0 then      --0-����
								g_Team_Name_Ctrl_List[i+3]:SetText(g_MenPaiNameList[nMenPai].Color..szName)  --����
								g_Team_MenPai_Ctrl_List[i+3]:SetText(g_MenPaiNameList[nMenPai].Color..g_MenPaiNameList[nMenPai].Name)  --����
								g_Team_DuanWei_Ctrl_List[i+3]:SetText(g_MenPaiNameList[nMenPai].Color..g_DuanWei1[nDuanWei])  --�ȼ�
								g_Team_Level_Ctrl_List[i+3]:SetText(g_MenPaiNameList[nMenPai].Color..nlevel)
								g_Team_KillNum_Ctrl_List[i+3]:SetText(g_MenPaiNameList[nMenPai].Color..nkill)
								g_Team_HP_Ctrl_List[i+3]:SetProgress(nHP, 100)--Ѫ���ٷֱ�
						elseif nstate == 1 then  --1-����
								g_Team_Name_Ctrl_List[i+3]:SetText(g_DieColor..szName)  --����
								g_Team_MenPai_Ctrl_List[i+3]:SetText(g_DieColor..g_MenPaiNameList[nMenPai].Name)  --����
								g_Team_DuanWei_Ctrl_List[i+3]:SetText(g_DieColor..g_DuanWei1[nDuanWei])  --�ȼ�
								g_Team_Level_Ctrl_List[i+3]:SetText(g_DieColor..nlevel)
								g_Team_KillNum_Ctrl_List[i+3]:SetText(g_DieColor..nkill)
								g_Team_HP_Ctrl_List[i+3]:SetProgress(0, 100)--Ѫ���ٷֱ�
						elseif nstate == 2 then  --2-����
								g_Team_Name_Ctrl_List[i+3]:SetText("")
								g_Team_MenPai_Ctrl_List[i+3]:SetText("")
								g_Team_DuanWei_Ctrl_List[i+3]:SetText("")
								g_Team_Level_Ctrl_List[i+3]:SetText("")
								g_Team_KillNum_Ctrl_List[i+3]:SetText("")
								g_Team_HP_Ctrl_List[i+3]:SetProgress(0, 100)
						end

					end
				end
				if i > 3 then
					local nGuid,nHP,nDuanWei,nMenPai,szName,nkill,nstate ,nlevel = XBW:GetCopySceneBWPlayerInfoByIdx(i-1)
					--local nCalcBattleScire,nDuanWei = BWDH2018:GetCalcBattleScoreAndDuanweiInfoByIdx2018(i-1)
					--�������Ϸ���GUID��˵��6����û����
					--PushDebugMessage(nDuanWei)
					if nGuid ~= "" and nDuanWei >= 1 and nDuanWei <= 6 then

						--���״̬�� ��
						if nstate == 0 then      --0-����
								g_Team_Name_Ctrl_List[i-3]:SetText(g_MenPaiNameList[nMenPai].Color..szName)  --����
								g_Team_MenPai_Ctrl_List[i-3]:SetText(g_MenPaiNameList[nMenPai].Color..g_MenPaiNameList[nMenPai].Name)  --����
								g_Team_DuanWei_Ctrl_List[i-3]:SetText(g_MenPaiNameList[nMenPai].Color..g_DuanWei1[nDuanWei])  --�ȼ�
								g_Team_Level_Ctrl_List[i-3]:SetText(g_MenPaiNameList[nMenPai].Color..nlevel)
								g_Team_KillNum_Ctrl_List[i-3]:SetText(g_MenPaiNameList[nMenPai].Color..nkill)
								g_Team_HP_Ctrl_List[i-3]:SetProgress(nHP, 100)--Ѫ���ٷֱ�
						elseif nstate == 1 then  --1-����
								g_Team_Name_Ctrl_List[i-3]:SetText(g_DieColor..szName)  --����
								g_Team_MenPai_Ctrl_List[i-3]:SetText(g_DieColor..g_MenPaiNameList[nMenPai].Name)  --����
								g_Team_DuanWei_Ctrl_List[i-3]:SetText(g_DieColor..g_DuanWei1[nDuanWei])  --�ȼ�
								g_Team_Level_Ctrl_List[i-3]:SetText(g_DieColor..nlevel)
								g_Team_KillNum_Ctrl_List[i-3]:SetText(g_DieColor..nkill)
								g_Team_HP_Ctrl_List[i-3]:SetProgress(0, 100)--Ѫ���ٷֱ�
						elseif nstate == 2 then  --2-����
								g_Team_Name_Ctrl_List[i-3]:SetText("")
								g_Team_MenPai_Ctrl_List[i-3]:SetText("")
								g_Team_DuanWei_Ctrl_List[i-3]:SetText("")
								g_Team_Level_Ctrl_List[i-3]:SetText("")
								g_Team_KillNum_Ctrl_List[i-3]:SetText("")
								g_Team_HP_Ctrl_List[i-3]:SetProgress(0, 100)
						end

					end
				end

-------------				
			end
			

		end
	end

	local nKillerType = XBW:GetCopySceneBWFirstKillerType()
	local nResultType = XBW:GetBWTroopsPK_Result_Info()
	if mUIDir == 0 then
		-- HuaShanLunJian_Fight_LeftList_TitleBK:Show()
		-- HuaShanLunJian_Fight_RightList_TitleBK:Show()
		-- HuaShanLunJian_Fight_LeftList_TitleBK:SetProperty("Image", "set:BW_Match5 image:Red")
		-- HuaShanLunJian_Fight_RightList_TitleBK:SetProperty("Image", "set:BW_Match5 image:Blue")
		if nKillerType == 1 then
			HuaShanLunJian_Fight_Team1FirstKill:Show()
			HuaShanLunJian_Fight_Team2FirstKill:Hide()
		elseif nKillerType == 2 then
			HuaShanLunJian_Fight_Team1FirstKill:Hide()
			HuaShanLunJian_Fight_Team2FirstKill:Show()
		else
			HuaShanLunJian_Fight_Team1FirstKill:Hide()
			HuaShanLunJian_Fight_Team2FirstKill:Hide()
		end
		if nResultType == 1 and index == 1 then	
			HuaShanLunJian_Fight_Team1Win:Show()
			--HuaShanLunJian_Fight_Team2Fail:Show()
		elseif nResultType == 2 and index == 1 then
	
			HuaShanLunJian_Fight_Team2Win:Show()
			--HuaShanLunJian_Fight_Team1Fail:Show()
		elseif nResultType == 3 and index == 1 then
			HuaShanLunJian_Fight_Team1Draw:Show()
			HuaShanLunJian_Fight_Team2Draw:Show()
		end

	else
		-- HuaShanLunJian_Fight_LeftList_TitleBK:Show()
		-- HuaShanLunJian_Fight_RightList_TitleBK:Show()
		-- HuaShanLunJian_Fight_LeftList_TitleBK:SetProperty("Image", "set:BW_Match5 image:Blue")
		-- HuaShanLunJian_Fight_RightList_TitleBK:SetProperty("Image", "set:BW_Match5 image:Red")
		if nKillerType == 1 then
			HuaShanLunJian_Fight_Team1FirstKill:Hide()
			HuaShanLunJian_Fight_Team2FirstKill:Show()
		elseif nKillerType == 2 then
			HuaShanLunJian_Fight_Team1FirstKill:Show()
			HuaShanLunJian_Fight_Team2FirstKill:Hide()
		else
			HuaShanLunJian_Fight_Team1FirstKill:Hide()
			HuaShanLunJian_Fight_Team2FirstKill:Hide()
		end
		if nResultType == 1  and index == 1 then	
			HuaShanLunJian_Fight_Team2Win:Show()
			--HuaShanLunJian_Fight_Team1Fail:Show()
		elseif nResultType == 2 and index == 1 then
	
			HuaShanLunJian_Fight_Team1Win:Show()
			--HuaShanLunJian_Fight_Team2Fail:Show()
		elseif nResultType == 3 and index == 1 then
			HuaShanLunJian_Fight_Team1Draw:Show()
			HuaShanLunJian_Fight_Team2Draw:Show()
		end
	end
	-- local sNameA, sNameB = BWDH:GetTwoBWTroopsNameInCopyScene()
	-- if sNameA == nil then sNameA ="" end
	-- if sNameB == nil then sNameB = "" end
	-- HuaShanLunJian_Fight_Team1Name:SetText(sNameA)
	-- HuaShanLunJian_Fight_Team2Name:SetText(sNameB)
	if index == 0 then
		if g_IsTimerSet == 0 then
			--��Ϊֻ���������ʱ��ͬ��һ��ʱ�䣻���⣬������Ҷ�������ͬ��һ��ʱ��
			--����ʱ���ͻ�����Ϊ����ȻServer���м�ʱ��������ͻ���ͬ���ˡ�	
			HuaShanLunJian_Fight_Leave:SetText("#{HSSC_191009_43}")
			g_IsTimerSet = 1
			HuaShanLunJian_Fight_SetTimer()
		else
			HuaShanLunJian_Fight_TimeWatch:Show()
		end
	elseif index == 1 then
		HuaShanLunJian_Fight_Leave:SetText("#{HSLJ_190919_246}")
		HuaShanLunJian_Fight_TimeWatch:SetProperty("Timer", 10)
		HuaShanLunJian_Fight_TimeWatch:Show()	
	end
end

function HuaShanLunJian_Fight_SetTimer()

	local nCountTimers = XBW:GetBWTroopsPK_LeftTimes()
	if nCountTimers == nil then
		nCountTimers = 0
	end
	if nCountTimers <= 0 then
		return
	end
	HuaShanLunJian_Fight_TimeWatch:SetProperty("Timer", tostring(nCountTimers))
	HuaShanLunJian_Fight_TimeWatch:Show()

end

function HuaShanLunJian_Fight_OnTimer()
	HuaShanLunJian_Fight_TimeWatch:Hide()
	HuaShanLunJian_Fight_WatchText:SetText("����")
	HuaShanLunJian_Fight_WatchText:Show()
end

function HuaShanLunJian_Fight_Raid_Click(idx)
    if idx < 1 or idx > 6 then
        return
    end
	local mUIDir = XBW:GetMyUIDirInfo()
	if mUIDir == nil then
		return 
	end 
	if mUIDir == 0 then
		XBW:SetBMMainTargetByUIIdx(idx)
	elseif mUIDir == 1 then
		if idx <=3 then
			XBW:SetBMMainTargetByUIIdx(idx+3)
		elseif idx > 3 then
			XBW:SetBMMainTargetByUIIdx(idx-3)
		end
	end
    
end
