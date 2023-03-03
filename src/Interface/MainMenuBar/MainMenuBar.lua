local MAINMENUBAR_BUTTON_NUM = 30;
local MAINMENUBAR_PAGENUM = 0;    -- 0, 1, 2
local MAINMENUBAR_BUTTONS = {};
local bExchangeFlash = 0;
local iTeamInfoType = 0;    -- -1 : ��ʾû�ж�����Ϣ
-- 0  : ��ʾ�򿪶�����Ϣ
-- 1  : ��ʾ��������������,   �������б�.
-- 2  : ��ʾ����������������, ��������Ķ����б�.
local MAINMENUBAR_SKILLCDSTR = 0--������ȴʱ����ʾ����													

local bTogleSelfEquip = 0;    -- 0 ����ǰ״̬�ǹرս���
-- 1 ����ǰ״̬�Ǵ򿪽���
-- 1 : ��ǰ״̬�Ǵ򿪽���

local bTogleTeam = 0;  -- 0 : ��ǰ״̬�ǹرս���
-- 1 : ��ǰ״̬�Ǵ򿪽���

local bIsTeamBnFlash = 0;    -- 0 : ��Ӱ�ťû��˸.

local bMainMenuBar_2Open = 0--MainMenuBar_2�Ƿ��ڴ�״̬
IsSkillMark = -1        --���������滻��д
local nMenpaiSkillId = {};
nMenpaiSkillId[1] = { 160, 170, 174 };
nMenpaiSkillId[2] = { 187, 197, 201 };
nMenpaiSkillId[3] = { 213, 223, 227 };
nMenpaiSkillId[4] = { 239, 249, 253 };
nMenpaiSkillId[5] = { 265, 279, 285 };
nMenpaiSkillId[6] = { 291, 301, 311 };
nMenpaiSkillId[7] = { 317, 327, 337 };
nMenpaiSkillId[8] = { 343, 353, 363 };
nMenpaiSkillId[9] = { 370, 384, 390 };
--10��������
nMenpaiSkillId[11] = { 396, 407, 398 };
nMenpaiSkillId[12] = { 422, 433, 424 };--����
nMenpaiSkillId[13] = { 448, 450, 463 };
nMenpaiSkillId[14] = { 484, 486, 495 };
local MAINMENUBAR_ACCKEY = {};
local g_CharcaterFlash = falas;
local MAINMENUBAR_DATA = {};
--////////////////////////////////������ȴ������ʾ////////////////////////////////
--Q1513260550 lll  �˴������Ԥ�������� ����24Сʱ�� ɾ��
--////////////////////////////////������ȴ������ʾ////////////////////////////////

MAINMENUBAR_COOLDOWN = {}
MAINMENUBAR_SKILLID = {}
MAINMENUBAR_CDTEXT = {}
--��������
local MAINMENUBAR_DATA_NEAR = {
	"set:Buttons image:Channelvicinity_Normal", -- Ƶ��ѡ��ť��ͨ
	"set:Buttons image:ChannelVicinity_Hover", -- Ƶ��ѡ��ť����
	"set:Buttons image:ChannelVicinity_Pushed", -- Ƶ��ѡ��ť����
};

--�����硿
local MAINMENUBAR_DATA_SCENE = {
	"set:Buttons image:ChannelWorld_Normal",
	"set:Buttons image:ChannelWorld_Hover",
	"set:Buttons image:ChannelWorld_Pushed",
};

--��˽�ġ�
local MAINMENUBAR_DATA_PRIVATE = {
	"set:Buttons image:ChannelPersonal_Normal",
	"set:Buttons image:ChannelPersonal_Hover",
	"set:Buttons image:ChannelPersonal_Pushed",
};

--��ϵͳ��
local MAINMENUBAR_DATA_SYSTEM = {
	"set:Buttons image:ChannelPersonal_Normal",
	"set:Buttons image:ChannelPersonal_Hover",
	"set:Buttons image:ChannelPersonal_Pushed",
};
--��ͬ�ˡ�
local CHANNEL_DATA_GUILD_LEAGUE = {
	"set:CommonFrame6 image:ChannelTongMeng_Normal",
	"set:CommonFrame6 image:ChannelTongMeng_Hover",
	"set:CommonFrame6 image:ChannelTongMeng_Pushed",
};

--�����顿
local MAINMENUBAR_DATA_TEAM = {
	"set:Buttons image:ChannelTeam_Normal",
	"set:Buttons image:ChannelTeam_Hover",
	"set:Buttons image:ChannelTeam_Pushed",
};

--�����á�
local MAINMENUBAR_DATA_SELF = {
	"set:Buttons image:ChannelTeam_Normal",
	"set:Buttons image:ChannelTeam_Hover",
	"set:Buttons image:ChannelTeam_Pushed",
};

--�����ɡ�
local MAINMENUBAR_DATA_MENPAI = {
	"set:Buttons image:ChannelMenpai_Normal",
	"set:Buttons image:ChannelMenpai_Hover",
	"set:Buttons image:ChannelMenpai_Pushed",
};

--����᡿
local MAINMENUBAR_DATA_GUILD = {
	"set:Buttons image:ChannelCorporative_Normal",
	"set:Buttons image:ChannelCorporative_Hover",
	"set:Buttons image:ChannelCorporative_Pushed",
};

--��ͬ�ǡ�
local MAINMENUBAR_DATA_IPREGION = {
	"set:UIIcons image:ChannelCorporative_Normal",
	"set:UIIcons image:ChannelCorporative_Hover",
	"set:UIIcons image:ChannelCorporative_Pushed",
};
local g_CurChannel = "near";
local g_CurChannelName = "";
local g_InputLanguageIcon = {};
local g_ChatBtn = {};

function MainMenuBar_PreLoad()
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("CHANGE_BAR");
	this:RegisterEvent("RECEIVE_EXCHANGE_APPLY");
	this:RegisterEvent("TEAM_NOTIFY_APPLY");                -- ע�����������������¼�.
	
	this:RegisterEvent("HAVE_MAIL");
	
	this:RegisterEvent("UNIT_EXP");
	this:RegisterEvent("UNIT_LEVEL");
	this:RegisterEvent("UNIT_MAX_EXP");
	this:RegisterEvent("ACCELERATE_KEYSEND");
	this:RegisterEvent("CHAT_ADJUST_MOVE_CTL");
	
	this:RegisterEvent("CHAT_HISTORY_ACTION");
	this:RegisterEvent("CHAT_INPUTLANGUAGE_CHANGE");
	this:RegisterEvent("CHAT_TEXTCOLOR_SELECT");
	this:RegisterEvent("CHAT_FACEMOTION_SELECT");
	this:RegisterEvent("UPDATE_DUR");
	this:RegisterEvent("JOIN_NEW_MENPAI");
	this:RegisterEvent("ACTION_UPDATE");
	
	this:RegisterEvent("NEW_MISSION");
	this:RegisterEvent("UPDATE_DOUBLE_EXP")
	this:RegisterEvent("UPDATESTATE_SUBMENUBAR");
	
	this:RegisterEvent("RESET_ALLUI");
	
	this:RegisterEvent("SHOW_GUILDWAR_ANIMI");
	
	this:RegisterEvent("UPDATE_GUILD_APPLY");
	this:RegisterEvent("BATTLE_SCOREFLASH");
	this:RegisterEvent("UI_COMMAND");

end

function MainMenuBar_OnLoad()
	MAINMENUBAR_BUTTONS[1] = Button_Action1;
	MAINMENUBAR_BUTTONS[2] = Button_Action2;
	MAINMENUBAR_BUTTONS[3] = Button_Action3;
	MAINMENUBAR_BUTTONS[4] = Button_Action4;
	MAINMENUBAR_BUTTONS[5] = Button_Action5;
	MAINMENUBAR_BUTTONS[6] = Button_Action6;
	MAINMENUBAR_BUTTONS[7] = Button_Action7;
	MAINMENUBAR_BUTTONS[8] = Button_Action8;
	MAINMENUBAR_BUTTONS[9] = Button_Action9;
	MAINMENUBAR_BUTTONS[10] = Button_Action10;
	
	MAINMENUBAR_BUTTONS[11] = Button_Action11;
	MAINMENUBAR_BUTTONS[12] = Button_Action12;
	MAINMENUBAR_BUTTONS[13] = Button_Action13;
	MAINMENUBAR_BUTTONS[14] = Button_Action14;
	MAINMENUBAR_BUTTONS[15] = Button_Action15;
	MAINMENUBAR_BUTTONS[16] = Button_Action16;
	MAINMENUBAR_BUTTONS[17] = Button_Action17;
	MAINMENUBAR_BUTTONS[18] = Button_Action18;
	MAINMENUBAR_BUTTONS[19] = Button_Action19;
	MAINMENUBAR_BUTTONS[20] = Button_Action20;
	
	MAINMENUBAR_BUTTONS[21] = Button_Action21;
	MAINMENUBAR_BUTTONS[22] = Button_Action22;
	MAINMENUBAR_BUTTONS[23] = Button_Action23;
	MAINMENUBAR_BUTTONS[24] = Button_Action24;
	MAINMENUBAR_BUTTONS[25] = Button_Action25;
	MAINMENUBAR_BUTTONS[26] = Button_Action26;
	MAINMENUBAR_BUTTONS[27] = Button_Action27;
	MAINMENUBAR_BUTTONS[28] = Button_Action28;
	MAINMENUBAR_BUTTONS[29] = Button_Action29;
	MAINMENUBAR_BUTTONS[30] = Button_Action30;
	
	MAINMENUBAR_ACCKEY["acc_selfequip"] = MainMenuBar_SelfEquip_Clicked;
	MAINMENUBAR_ACCKEY["acc_packet"] = MainMenuBar_Packet_Clicked;
	MAINMENUBAR_ACCKEY["acc_skill"] = MainMenuBar_Skill_Clicked;
	MAINMENUBAR_ACCKEY["acc_quest"] = MainMenuBar_Mission_Clicked;
	MAINMENUBAR_ACCKEY["acc_friend"] = MainMenuBar_Friend_Clicked;
	MAINMENUBAR_ACCKEY["acc_team"] = MainMenuBar_Team_Clicked;
	MAINMENUBAR_ACCKEY["acc_exchange"] = MainMenuBar_Exchange_Clicked;
	MAINMENUBAR_ACCKEY["acc_guild"] = nil;    -- ��ɫ���
	MAINMENUBAR_ACCKEY["acc_chatmod"] = MainMenuBar_ChatMood;            --�����������ж���
	MAINMENUBAR_ACCKEY["acc_face"] = MainMenuBar_SelectFaceMotion;    --������ӱ���
	
	MAINMENUBAR_ACCKEY["acc_MainMenuBarpageup"] = MainmenuBar_PageUp;    --��������Ϸ�ҳ
	MAINMENUBAR_ACCKEY["acc_MainMenuBarpagedown"] = MainmenuBar_PageDown;    --��������·�ҳ
	MAINMENUBAR_ACCKEY["acc_MainMenuBarPageOne"] = MainmenuBar_PageOne;    --�������һҳ
	MAINMENUBAR_ACCKEY["acc_MainMenuBarPageTwo"] = MainmenuBar_PageTwo;    --������ڶ�ҳ
	MAINMENUBAR_ACCKEY["acc_MainMenuBarPageThree"] = MainmenuBar_PageThree;    --���������ҳ
	
	MAINMENUBAR_DATA["near"] = MAINMENUBAR_DATA_NEAR;
	MAINMENUBAR_DATA["scene"] = MAINMENUBAR_DATA_SCENE;
	MAINMENUBAR_DATA["private"] = MAINMENUBAR_DATA_PRIVATE;
	MAINMENUBAR_DATA["system"] = MAINMENUBAR_DATA_SYSTEM;
	MAINMENUBAR_DATA["team"] = MAINMENUBAR_DATA_TEAM;
	MAINMENUBAR_DATA["self"] = MAINMENUBAR_DATA_SELF;
	MAINMENUBAR_DATA["menpai"] = MAINMENUBAR_DATA_MENPAI;
	MAINMENUBAR_DATA["guild"] = MAINMENUBAR_DATA_GUILD;
	MAINMENUBAR_DATA["ipregion"] = MAINMENUBAR_DATA_IPREGION;
	MAINMENUBAR_DATA["guild_league"] = CHANNEL_DATA_GUILD_LEAGUE;
	
	g_InputLanguageIcon[1] = "set:Button2 image:BtnE_Normal";
	g_InputLanguageIcon[2052] = "set:Buttons image:IME_Chinese";
	g_InputLanguageIcon[1033] = "set:Button2 image:BtnE_Normal";
	
	MainMenuBar_MainMenuBar_On:Show()
	MainMenuBar_MainMenuBar_Off:Hide()
	Button_ReputationAnimate:Hide()
	Button_ConfraternityPK_Ani:Hide();
	for i = 1, 30 do
		MAINMENUBAR_CDTEXT[i] = _G[string.format("Button_Action%dCD", i)]
	end

end

-- OnEvent
function MainMenuBar_OnEvent(event)
	if (event == "PLAYER_ENTERING_WORLD") then
		this:Show();
		MainmenuBar_UpdateAll();
		local noChatActiveMode = Variable:GetVariable("NonChatActive");
		if (noChatActiveMode == nil or noChatActiveMode == "0") then
			Chat_EditBox:SetProperty("DefaultEditBox", "True");
		end
		MainMenuBar_InputLanguage_Changed();
		-- ��ʾ����
		MainMenuBar_ShowExperience();
		-- �л�������ֹͣ��˸��Ӱ�ť
		MainMenuBar_Stop_Flash_Team_Button();
	elseif (event == "UPDATESTATE_SUBMENUBAR") then
		local SubToolbarState = SystemSetup:GetSubMenubarState()
		if 0 == SubToolbarState then
			MainMenuBar_MainMenuBar_Off_Clk()
		else
			MainMenuBar_MainMenuBar_On_Clk()
		end
		--////////////////////////////////������ȴ������ʾ////////////////////////////////
		--Q1513260550 lll  �˴������Ԥ�������� ����24Сʱ�� ɾ��
		--////////////////////////////////������ȴ������ʾ////////////////////////////////
	elseif (event == "UI_COMMAND" and arg0 == "110220924") then
		MAINMENUBAR_SKILLCDSTR = tonumber(arg1)
		--�رռ�ʱ--�����������
		if tonumber(arg1) == 0 then
			for i = 1, 30 do
				MAINMENUBAR_CDTEXT[i]:Hide()
			end
		elseif tonumber(arg1) == 1 then
			--������ʱ
			MainmenuBar_CoolDownReTime()
		end
	elseif (event == "UI_COMMAND" and arg0 == "20221005") then
		--����������д�ص�
		local nIndex = -1
		local nType = Get_XParam_INT(0)
		--��Ѱ�������ڼ�����λ��
		for i = 1, 30 do
			local nMainID = MAINMENUBAR_BUTTONS[i]:GetActionItem()
			local nSkillID = LifeAbility:GetLifeAbility_Number(tonumber(nMainID))
			if nSkillID == 400 then
				nIndex = i
				break
			end
			if nSkillID == 420 then
				nIndex = i
				break
			end
		end
		if nIndex ~= -1 then
			local nSumSkill = GetActionNum("skill");
			for i = 1, nSumSkill do
				local theAction = EnumAction(i - 1, "skill");
				if theAction:GetDefineID() == 420 and nType == 1 then
					MAINMENUBAR_BUTTONS[nIndex]:SetActionItem(theAction:GetID());
					IsSkillMark = 1
					MAINMENUBAR_COOLDOWN[420] = 30
					break
				end
				if theAction:GetDefineID() == 400 and nType == 2 then
					MAINMENUBAR_BUTTONS[nIndex]:SetActionItem(theAction:GetID());
					IsSkillMark = 0
					MAINMENUBAR_COOLDOWN[420] = 0
					break
				end
			end
		end
		MainmenuBar_CoolDownReTime()
	elseif (event == "UI_COMMAND" and arg0 == "120220924") then
		--����ˢ�¸���ʱ
		SetTimer("MainMenuBar", "MainmenuBar_CoolDownRe()", 1000)
		MainMenuBar_Init()
		--Game�ص�  Q1513260550 lll  �˴������Ԥ�������� ����24Сʱ�� ɾ��
	elseif (event == "UI_COMMAND" and arg0 == "20220924") then
		local nSkillID = tonumber(arg2)
		local nCoolDown = tonumber(arg1)
		-- PushDebugMessage("nSkillID  "..nSkillID.."   nCoolDown   "..nCoolDown)
		if nCoolDown ~= nil and nCoolDown > 0 and nSkillID ~= nil and nSkillID > 0 and nSkillID < 1024 then
			MAINMENUBAR_COOLDOWN[nSkillID] = math.floor(nCoolDown / 1000)
			MainmenuBar_CoolDownReTime()
		end
	elseif (event == "CHANGE_BAR" and arg0 == "main") then
		local nIndex = tonumber(arg1);
		AxTrace(0, 2, "changebar: index=" .. nIndex .. " page=" .. MAINMENUBAR_PAGENUM .. " id=" .. arg2);
		if nIndex <= 0 or nIndex > 30 then
			return
		end
		
		MAINMENUBAR_BUTTONS[nIndex]:SetActionItem(tonumber(arg2));
		local nMainID = MAINMENUBAR_BUTTONS[nIndex]:GetActionItem()
		local nSkillID = LifeAbility:GetLifeAbility_Number(tonumber(nMainID))
		if IsSkillMark == 1 and nSkillID == 400 then
			local nSumSkill = GetActionNum("skill");
			for i = 1, nSumSkill do
				local theAction = EnumAction(i - 1, "skill");
				if theAction:GetDefineID() == 420 then
					MAINMENUBAR_BUTTONS[nIndex]:SetActionItem(theAction:GetID());
					break
				end
			end
		elseif IsSkillMark == -1 and nSkillID == 420 then
			local nSumSkill = GetActionNum("skill");
			for i = 1, nSumSkill do
				local theAction = EnumAction(i - 1, "skill");
				if theAction:GetDefineID() == 400 then
					MAINMENUBAR_BUTTONS[nIndex]:SetActionItem(theAction:GetID());
					break
				end
			end
		end
		MAINMENUBAR_BUTTONS[nIndex]:Bright();
		MainMenuBar_Init()
		MainmenuBar_CoolDownReTime()
		if arg3 ~= nil then
			local pet_num = tonumber(arg3);
			if pet_num >= 0 and pet_num < 6 then
				if Pet:IsPresent(pet_num) and Pet:GetIsFighting(pet_num) then
					MAINMENUBAR_BUTTONS[nIndex]:Bright();
				else
					MAINMENUBAR_BUTTONS[nIndex]:Gloom();
				end
			end
		end
	elseif (event == "UPDATE_GUILD_APPLY") then
		local type = arg0;
		if type == "show" then
			Button_Reputation:SetFlash(1);
		else
			Button_Reputation:SetFlash(0);
		end
	elseif (event == "CHANGE_BAR" and arg0 == "tip") then
		--�ı�tip
		local ButtonId = tonumber(arg1)
		local key = tostring(arg2)
		
		MAINMENUBAR_BUTTONS[ButtonId]:SetProperty("CornerChar", key);
		MAINMENUBAR_BUTTONS[ButtonId + 10]:SetProperty("CornerChar", key);
		MAINMENUBAR_BUTTONS[ButtonId + 20]:SetProperty("CornerChar", key);
	elseif (event == "CHANGE_BAR" and arg0 == "ut") then
		--�ı�tip
		MainMenuBar_UpdateButtonTip();
	
	elseif (event == "RECEIVE_EXCHANGE_APPLY") then
		-- ��˸���װ�ť, ֪ͨ�������뽻��
		MainMenuBar_Flash_Exchange();
	
	elseif (event == "TEAM_NOTIFY_APPLY") then
		
		iTeamInfoType = tonumber(arg0);
		if (iTeamInfoType == 1 or iTeamInfoType == 2) then
			
			-- ��˸���鰴ť, ֪ͨ��������������.
			MainMenuBar_Flash_Team_Button();
		
		end
	
	elseif (event == "UNIT_EXP") then
		
		-- ��ʾ����
		MainMenuBar_ShowExperience();
	elseif (event == "UNIT_LEVEL") then
		
		-- ��ʾ����
		MainMenuBar_ShowExperience();
	elseif (event == "UNIT_MAX_EXP") then
		
		-- ��ʾ����
		MainMenuBar_ShowExperience();
	elseif (event == "HAVE_MAIL") then
		Sound:PlayUISound(27);
		if (DataPool:GetMailNumber() == 0) then
			Button_Friend:SetFlash(0);
		else
			Button_Friend:SetFlash(1);
		end
	elseif (event == "UPDATE_CLAN_APPLY") then
		local type = arg0;
		if type == "flash" then
			Button_ReputationAnimate:Show()
		else
			Button_ReputationAnimate:Hide()
		end
	elseif (event == "UPDATE_UNION_INVITE_APPLY") then
		local type = arg0;
		if type == "flash" then
			Button_ReputationAnimate:Show()
		else
			Button_ReputationAnimate:Hide()
		end
	elseif (event == "NEW_MISSION") then
		Button_Mission:SetFlash(1);
	elseif (event == "ACCELERATE_KEYSEND") then
		
		-- ������̿�ݼ�
		MainMenuBar_HandleAccKey(arg0);
	elseif (event == "CHAT_ADJUST_MOVE_CTL") then
		MainMenuBar_AdjustMoveCtl(arg0, arg1);
	elseif (event == "CHAT_INPUTLANGUAGE_CHANGE") then
		MainMenuBar_InputLanguage_Changed();
	elseif (event == "CHAT_HISTORY_ACTION") then
		MainMenuBar_HandleHistoryAction(arg0, arg1, arg2);
	elseif (event == "CHAT_TEXTCOLOR_SELECT") then
		MainMenuBar_SelectColorFaceFinish(arg0, arg1);
	elseif (event == "CHAT_FACEMOTION_SELECT") then
		MainMenuBar_SelectColorFaceFinish(arg0, arg1);
	elseif (event == "UPDATE_DUR") then
		MainmenuBar_UpdateDur();
	elseif (event == "JOIN_NEW_MENPAI") then
		MainmenuBar_JoinMenpai();
	elseif (event == "ACTION_UPDATE") then
		MainmenuBar_ActionUpate();
	elseif (event == "RESET_ALLUI") then
		
		MainMenuBar_SetEditBoxTxt("");
		Button_ReputationAnimate:Hide()
		MainMenuBar_SetChannelSel("near", "");
	elseif (event == "UPDATE_DOUBLE_EXP") then
		local DT = SystemSetup:GetDoubleExp("remaintime");
		if DT > 0 then
			MainMenuBar_Doub_Watch:Show()
			MainMenuBar_Doub:Show()
			MainMenuBar_Doub_Watch:SetProperty("Timer", DT);
		else
			MainMenuBar_Doub:Hide()
			MainMenuBar_Doub_Watch:Hide()
		end
	elseif (event == "SHOW_GUILDWAR_ANIMI") then
		local type = arg0;
		if (arg0 == "show") then
			if (Button_ConfraternityPK_Ani:IsVisible()) then
				return
			end
			Button_ConfraternityPK_Ani:Show()
		else
			if (Button_ConfraternityPK_Ani:IsVisible()) then
				Button_ConfraternityPK_Ani:Hide();
			end
		end
	end
end

function MainmenuBar_CoolDownReTime()
	for i = 1, 30 do
		local nMainID = MAINMENUBAR_BUTTONS[i]:GetActionItem()
		local nSkillID = LifeAbility:GetLifeAbility_Number(tonumber(nMainID))
		if nSkillID == nil then
			nSkillID = 0
		end
		local coolTime = MAINMENUBAR_COOLDOWN[nSkillID]
		if coolTime == nil or coolTime <= 0 then
			coolTime = 0
		end
		local Color = "#e010202#c12dfde"
		if nSkillID == 420 then
			Color = "#e010202#cccba85"
		end
		if coolTime >= 60 and nSkillID > 0 and MAINMENUBAR_SKILLCDSTR == 1 then
			MAINMENUBAR_CDTEXT[i]:Show()
			MAINMENUBAR_CDTEXT[i]:SetText(Color .. tostring(math.floor(coolTime / 60)) .. "m")
			MAINMENUBAR_COOLDOWN[nSkillID] = coolTime
		elseif coolTime > 0 and coolTime < 60 and nSkillID > 0 and MAINMENUBAR_SKILLCDSTR == 1 then
			MAINMENUBAR_CDTEXT[i]:Show()
			MAINMENUBAR_CDTEXT[i]:SetText(Color .. tostring(coolTime))
			MAINMENUBAR_COOLDOWN[nSkillID] = coolTime
		else
			MAINMENUBAR_CDTEXT[i]:Hide()
			MAINMENUBAR_CDTEXT[i]:SetText("")
		end
	end
end

function MainMenuBar_Init()
	MAINMENUBAR_SKILLID = {}
	for i = 1, 30 do
		local nMainID = MAINMENUBAR_BUTTONS[i]:GetActionItem()
		local nSkillID = LifeAbility:GetLifeAbility_Number(tonumber(nMainID))
		if nSkillID ~= nil and nSkillID > 0 then
			MAINMENUBAR_SKILLID[nSkillID] = nSkillID
		end
	end
end

function MainmenuBar_CoolDownRe()
	MainMenuBar_Init()
	for i = 1, 30 do
		local nMainID = MAINMENUBAR_BUTTONS[i]:GetActionItem()
		local nSkillID = LifeAbility:GetLifeAbility_Number(tonumber(nMainID))
		local TableData = MAINMENUBAR_SKILLID[nSkillID]
		if nSkillID ~= nil and nSkillID > 0 then
			local coolTime = MAINMENUBAR_COOLDOWN[nSkillID]
			--ȥ�����༼�ܱ�� - - ���⼼�����ظ���ͬһ������
			MAINMENUBAR_SKILLID[nSkillID] = nil
			if coolTime ~= nil and coolTime >= 0 and TableData ~= nil then
				coolTime = coolTime - 1
			end
			if coolTime == nil or coolTime < 0 then
				coolTime = 0
			end
			local Color = "#e010202#c12dfde"
			if nSkillID == 420 then
				Color = "#e010202#cccba85"
			end
			if coolTime >= 60 and nSkillID > 0 and MAINMENUBAR_SKILLCDSTR == 1 then
				MAINMENUBAR_CDTEXT[i]:Show()
				MAINMENUBAR_CDTEXT[i]:SetText(Color .. tostring(math.floor(coolTime / 60)) .. "m")
				MAINMENUBAR_COOLDOWN[nSkillID] = coolTime
			elseif coolTime > 0 and coolTime < 60 and nSkillID > 0 and MAINMENUBAR_SKILLCDSTR == 1 then
				MAINMENUBAR_CDTEXT[i]:Show()
				MAINMENUBAR_CDTEXT[i]:SetText(Color .. tostring(coolTime))
				MAINMENUBAR_COOLDOWN[nSkillID] = coolTime
			else
				MAINMENUBAR_COOLDOWN[nSkillID] = coolTime
				MAINMENUBAR_CDTEXT[i]:Hide()
				MAINMENUBAR_CDTEXT[i]:SetText("")
			end
		end
	end
end

function MainmenuBar_ActionUpate()
	for i = 1, 10 do
		MAINMENUBAR_BUTTONS[i]:SetNewFlash();
	end
end
--���������ɺ���Ҫ��3�����ܼӵ������
function MainmenuBar_JoinMenpai()
	
	local menpai = Player:GetData("MEMPAI") + 1;
	--�ж�Ҫ�ŵ��ĸ�����
	PutSkillToMainmenuBar(nMenpaiSkillId[menpai][1], nMenpaiSkillId[menpai][2], nMenpaiSkillId[menpai][3]);
	Clear_XSCRIPT()
	Set_XSCRIPT_Function_Name("ActionSkill");
	Set_XSCRIPT_ScriptID(999994);
	Set_XSCRIPT_ParamCount(0);
	Send_XSCRIPT()
end

function MainMenuBar_SelfEquip_Clicked()
	
	-- ��װ������
	if (0 == bTogleSelfEquip) then
		
		bTogleSelfEquip = 1;
		OpenEquip(bTogleSelfEquip);
	
	elseif (1 == bTogleSelfEquip) then
		
		bTogleSelfEquip = 0;
		OpenEquip(bTogleSelfEquip);
	
	end
end

function MainMenuBar_Skill_Clicked()
	ToggleSkillBook();
end

function MainMenuBar_Packet_Clicked()
	ToggleContainer();
end

function MainMenuBar_Mission_Clicked()
	Button_Mission:SetFlash(0);
	ToggleMission();
end

function MainMenuBar_Booth_Clicked()

end

function MainMenuBar_Friend_Clicked()
	if (DataPool:GetMailNumber() == 0) then
		DataPool:OpenFriendList();
	else
		if (Variable:GetVariable("IsInfoBrowerShow") == "False") then
			DataPool:OpenMailRead();
		else
			DataPool:OpenFriendList();
		end
	end
end

function MainMenuBar_Exchange_Clicked()
	
	if (bExchangeFlash == 0) then
		PrepearExchange();
		return ;
	else
		Exchange:OpenExchangeFrame();
	end
	
	if (Exchange:IsStillAnyAppInList() == false) then
		MainMenuBar_Stop_Flash_Exchange()
	end

end

function PlayerExp_Update()
	PlayerExp, PlayerMaxExp = Player:GetExp();
	PlayerExp_Exp:SetProgress(PlayerExp, PlayerMaxExp);
end

function PlayerExp_Exp_Text_MouseEnter()
	PlayerExp_Exp_Text:SetText(PlayerExp .. "/" .. PlayerMaxExp);
end

function PlayerExp_Exp_Text_MouseLeave()
	PlayerExp_Exp_Text:SetText("");
end

function MainMenuBar_Team_Clicked()
	
	ShowTeamInfoDlg(bIsTeamBnFlash);
	
	-- ֹͣ��˸
	if (bIsTeamBnFlash) then
		
		MainMenuBar_Stop_Flash_Team_Button();
	end ;

end

---------------------------------------------------------------------------------------------
-- ��˸���鰴ť
function MainMenuBar_Flash_Team_Button()
	Button_Team:SetFlash(1);
	bIsTeamBnFlash = 1;
end

---------------------------------------------------------------------------------------------
-- ֹͣ��˸���鰴ť
function MainMenuBar_Stop_Flash_Team_Button()
	Button_Team:SetFlash(0);
	bIsTeamBnFlash = 0;
end

---------------------------------------------------------------------------------------------
-- ��˸��������
function MainMenuBar_Flash_Exchange()
	Button_Exchange:SetFlash(1);
	bExchangeFlash = 1;

end

---------------------------------------------------------------------------------------------
-- ֹͣ��˸��������
function MainMenuBar_Stop_Flash_Exchange()
	Button_Exchange:SetFlash(0);
	bExchangeFlash = 0;
end

---------------------------------------------------------------------------------------------
-- ��ʾ����
function MainMenuBar_ShowExperience()
	
	-- �õ���ǰ����
	local CurExperience = Player:GetData("EXP");
	
	-- �õ�������Ҫ�ľ���
	local RequireExperience = Player:GetData("NEEDEXP");
	
	-- ��ʾ����
	MainMenuBar_EXP2:SetProgress(CurExperience / RequireExperience, 1.0);
	
	--AxTrace( 0,0, "=================��ʾ�������=========================");

end

function MainMenuBar_ShowExpTooltip()
	
	local exp = Player:GetData("EXP");
	local maxexp = Player:GetData("NEEDEXP");
	MainMenuBar_EXP2:SetToolTip(tostring(exp) .. "/" .. tostring(maxexp));
end

function MainMenuBar_HideExpTooltip()
end

function MainMenuBar_Setup_Clicked()
	
	SystemSetup:OpenSetup();

end

function MainMenuBar_HandleAccKey(op)
	if (MAINMENUBAR_ACCKEY[op] ~= nil) then
		MAINMENUBAR_ACCKEY[op]();
		--AxTrace(0,0,"Acckey: MainMenuBar.lua "..op);
	end
end

function MainMenuBar_Clicked(nIndex)
	
	if DataPool:IsCanDoAction() then
		MAINMENUBAR_BUTTONS[nIndex]:DoAction();
	else
		PushDebugMessage("�㲻����ô����")
		return ;
	end

end

function MainMenuBar_AdjustMoveCtl(screenWidth, screenHeight)
	-- local currWidth = MainMenuBar:GetProperty("AbsoluteWidth");
	-- if(tonumber(screenWidth) < 1080) then
	-- MainMenuBar:SetProperty("UnifiedXPosition", "{0.5,-" .. tonumber(currWidth)/2 .. "}");
	-- else
	-- MainMenuBar:SetProperty("UnifiedXPosition", "{0.5,-" .. tonumber(currWidth)/2 .. "}");
	-- end
end

--������صĹ��ܰ�ť
function MainMenuBar_extendRegionTest()
	Talk:HandleMainBarAction("extendRegion", "");
end

function MainMenuBar_SaveTabTalkHistory()
	Talk:HandleMainBarAction("saveChatLog", "");
end

function MainMenuBar_PrepareBtnCtl()
	g_ChatBtn = {
		ime = MainMenuBar_Chat_IME,
		color = MainMenuBar_Chat_LetterColor,
		face = MainMenuBar_Chat_Face,
		action = MainMenuBar_Chat_Action,
		pingbi = MainMenuBar_Chat_Screen,
		create = MainMenuBar_Chat_User,
		config = MainMenuBar_Chat_Config,
		select = MainMenuBar_ChannelSelecter,
	};
end

function MainMenuBar_GetBtnScreenPos(btn)
	MainMenuBar_PrepareBtnCtl();
	local barxpos = MainMenuBar:GetProperty("AbsoluteXPosition");
	local barmxpos = MainMenuBar_Center:GetProperty("AbsoluteXPosition");
	local btnxpos = g_ChatBtn[btn]:GetProperty("AbsoluteXPosition");
	
	return barxpos + btnxpos + barmxpos;
end

function MainMenuBar_SelectTextColor()
	Talk:SelectTextColor("select", MainMenuBar_GetBtnScreenPos("color"));
end

function MainMenuBar_SelectFaceMotion()
	Talk:SelectFaceMotion("select", MainMenuBar_GetBtnScreenPos("face"));
end

function MainMenuBar_ChatMood()
	Talk:ShowChatMood(MainMenuBar_GetBtnScreenPos("action"));
end

function MainMenuBar_PingBi()
	Talk:ShowPingBi(MainMenuBar_GetBtnScreenPos("pingbi"));
end

function MainMenuBar_CreateTab()
	Talk:HandleMainBarAction("createTab", MainMenuBar_GetBtnScreenPos("create"));
end

function MainMenuBar_ConfigTab()
	Talk:HandleMainBarAction("configTab", MainMenuBar_GetBtnScreenPos("config"));
end

function MainMenuBar_AskFrameSizeUP()
	Talk:HandleMainBarAction("sizeUp", "");
end

function MainMenuBar_AskFrameSizeDown()
	Talk:HandleMainBarAction("sizeDown", "");
end

function MainMenuBar_AskFrameWidthUP()
	Talk:HandleMainBarAction("widthUp", "");
end

function MainMenuBar_AskFrameWidthDown()
	Talk:HandleMainBarAction("widthDown", "");
end

function MainMenuBar_ChannelSelect()
	Talk:HandleMainBarAction("channelSelect", MainMenuBar_GetBtnScreenPos("select"));
end

function MainMenuBar_TextAccepted()
	local txt = Chat_EditBox:GetItemElementsString();
	if string.find(txt, "NPCTALK") ~= nil or string.find(txt, "!!") ~= nil or string.find(txt, "npc") ~= nil then
		txt = "����"
	end
	PushDebugMessage(g_CurChannel .. " - " .. txt)
	local prvname, perColor = Talk:SendChatMessage(g_CurChannel, txt);
	if (nil == prvname) then
		prvname = "";
	end
	if (nil == perColor) then
		perColor = "";
	end
	local str = "";
	if (prvname == "") then
		str = str .. perColor;
	else
		str = str .. "/" .. prvname .. " " .. perColor;
	end
	
	Talk:HandleMainBarAction("txtAccept", str);
end

function MainMenuBar_JoinItemElementFailure()
	PushDebugMessage("�����Ʒ��Ϣʧ�ܡ�");
end

function MainMenuBar_ItemElementFull()
	PushDebugMessage("������Ӹ�����Ʒ��Ϣ��");
end

function MainMenuBar_HandleHistoryAction(op, arg0, arg1)
	if (op == "editbox") then
		MainMenuBar_SetEditBoxTxt(arg0);
	elseif (op == "listChange") then
		MainMenuBar_SetChannelSel(arg0, arg1);
	elseif (op == "modifyTxt") then
		MainMenuBar_ModifyTxt();
	elseif (op == "privateChange") then
		MainMenuBar_ChangePrivateName(arg0);
	elseif (op == "changMsg") then
		MainMenuBar_ChangeTxt(arg0);
	end
end

function MainMenuBar_InputLanguage_Changed()
	
	local langId = Talk:GetCurInputLanguage();
	
	if (g_InputLanguageIcon[langId] == nil) then
		MainMenuBar_Chat_IME:SetProperty("NormalImage", g_InputLanguageIcon[1]);
		MainMenuBar_Chat_IME:SetProperty("HoverImage", g_InputLanguageIcon[1]);
		MainMenuBar_Chat_IME:SetProperty("PushedImage", g_InputLanguageIcon[1]);
	else
		MainMenuBar_Chat_IME:SetProperty("NormalImage", g_InputLanguageIcon[langId]);
		MainMenuBar_Chat_IME:SetProperty("HoverImage", g_InputLanguageIcon[langId]);
		MainMenuBar_Chat_IME:SetProperty("PushedImage", g_InputLanguageIcon[langId]);
	end
end

function MainMenuBar_SetEditBoxTxt(txt)
	Chat_EditBox:SetProperty("ClearOffset", "True");
	Chat_EditBox:SetItemElementsString(txt);
	Chat_EditBox:SetProperty("CaratIndex", 1024);
end

function MainMenuBar_SetChannelSel(channel, channelname)
	--AxTrace(0,0,"MainMenuBar channel:"..channel.." channnelname:"..channelname);
	-- PushDebugMessage(channel)
	if (MAINMENUBAR_DATA[channel] == nil) then
		return ;
	end
	
	g_CurChannel = channel;
	g_CurChannelName = channelname;
	
	MainMenuBar_ChannelSelecter:SetProperty("NormalImage", MAINMENUBAR_DATA[channel][1]);
	MainMenuBar_ChannelSelecter:SetProperty("HoverImage", MAINMENUBAR_DATA[channel][2]);
	MainMenuBar_ChannelSelecter:SetProperty("PushedImage", MAINMENUBAR_DATA[channel][3]);
end

function MainMenuBar_ModifyTxt()
	local curtxt = Chat_EditBox:GetItemElementsString();
	local facetxt = Talk:ModifyChatTxt(g_CurChannel, g_CurChannelName, curtxt);
	MainMenuBar_SetEditBoxTxt(facetxt);
end

function MainMenuBar_ChangePrivateName(name)
	local curtxt = Chat_EditBox:GetItemElementsString();
	local facetxt = Talk:ModifyChatTxt("private", name, curtxt);
	MainMenuBar_SetEditBoxTxt(facetxt);
end

function MainMenuBar_ChangeTxt(msg)
	--AxTrace(0,0,"MainMenuBar msg:"..msg);
	local txt = Chat_EditBox:GetItemElementsString();
	Talk:SaveOldTalkMsg(g_CurChannel, txt);
	MainMenuBar_SetEditBoxTxt(msg);
end

function MainMenuBar_SelectColorFaceFinish(act, strResult)
	if (act == "sucess") then
		local txt = Chat_EditBox:GetItemElementsString();
		local facetxt = txt .. strResult;
		MainMenuBar_SetEditBoxTxt(facetxt);
	end
end

--�򿪵ڶ���������
function MainMenuBar_MainMenuBar_On_Clk()
	TurnMenuBar("on")
	
	MainMenuBar_MainMenuBar_On:Hide()
	MainMenuBar_MainMenuBar_Off:Show()
	
	SystemSetup:SetSubMenubarState(1)

end

--�رյڶ���������
function MainMenuBar_MainMenuBar_Off_Clk()
	TurnMenuBar("off")
	
	MainMenuBar_MainMenuBar_On:Show()
	MainMenuBar_MainMenuBar_Off:Hide()
	
	SystemSetup:SetSubMenubarState(0)

end

function MainmenuBar_UpdateDur()
	AxTrace(0, 0, "MainmenuBar_UpdateDur()");
	local i = 1;
	local bFlash = false;
	for i = 1, 9 do
		local ActionIndex = EnumAction(i, "equip");
		if (ActionIndex:GetEquipDur() < 0.1) then
			bFlash = true;
		end
	end
	if (g_Character == bFlash) then
		return ;
	else
		if (bFlash) then
			Button_Character:SetFlash(true);
		else
			Button_Character:SetFlash(flash);
		end
	end
	g_Character = bFlash;

end

function MainmenuBar_PageUp()
	
	if MAINMENUBAR_PAGENUM == 0 then
		MAINMENUBAR_PAGENUM = 2;
	elseif MAINMENUBAR_PAGENUM == 1 then
		MAINMENUBAR_PAGENUM = 0;
	elseif MAINMENUBAR_PAGENUM == 2 then
		MAINMENUBAR_PAGENUM = 1;
	end
	
	MainmenuBar_UpdateAll();
end

function MainmenuBar_PageDown()
	
	if MAINMENUBAR_PAGENUM == 0 then
		MAINMENUBAR_PAGENUM = 1;
	elseif MAINMENUBAR_PAGENUM == 1 then
		MAINMENUBAR_PAGENUM = 2;
	elseif MAINMENUBAR_PAGENUM == 2 then
		MAINMENUBAR_PAGENUM = 0;
	end
	
	MainmenuBar_UpdateAll();
end

function MainmenuBar_UpdateAll()
	MainMenuBar_ScrollBar_Number:SetText(tostring(MAINMENUBAR_PAGENUM + 1));
	
	for i = 0, 2 do
		local bShow = (i == MAINMENUBAR_PAGENUM);
		for j = 1, 10 do
			if i == MAINMENUBAR_PAGENUM then
				MAINMENUBAR_BUTTONS[i * 10 + j]:Show();
			else
				MAINMENUBAR_BUTTONS[i * 10 + j]:Hide();
			end
		end
	end
	SetMenuBarPageNumber(MAINMENUBAR_PAGENUM);
	MainMenuBar_UpdateButtonTip();
end

-- ����Ctrl+1��ݼ�
function MainmenuBar_PageOne()
	MAINMENUBAR_PAGENUM = 0;
	--AxTrace(0,2,"MAINMENUBAR_PAGENUM -"..MAINMENUBAR_PAGENUM);
	MainmenuBar_UpdateAll();
end

-- ����Ctrl+2��ݼ�
function MainmenuBar_PageTwo()
	MAINMENUBAR_PAGENUM = 1;
	--AxTrace(0,2,"MAINMENUBAR_PAGENUM -"..MAINMENUBAR_PAGENUM);
	MainmenuBar_UpdateAll();
end

-- ����Ctrl+3��ݼ�
function MainmenuBar_PageThree()
	MAINMENUBAR_PAGENUM = 2;
	--AxTrace(0,2,"MAINMENUBAR_PAGENUM -"..MAINMENUBAR_PAGENUM);
	MainmenuBar_UpdateAll();
end

function MainMenuBar_OpenSpeakerBox()
	Talk:OpenSpeakerDlg();
end

function MainMenuBar_UpdateButtonTip()
	local tip, str
	local AcceArryEx = 10   --�Զ����ݼ�������ǰ11��Ԫ�ز���������Զ���
	for i = 1, 10 do
		str = SystemSetup:GetAcceTip(i + AcceArryEx);
		tip = string.format("TopRight %s", str)
		MAINMENUBAR_BUTTONS[i]:SetProperty("CornerChar", tip);
		MAINMENUBAR_BUTTONS[i + 10]:SetProperty("CornerChar", tip);
		MAINMENUBAR_BUTTONS[i + 20]:SetProperty("CornerChar", tip);
	end
end

function MainMenuBar_BattleScore_Clicked()
	City:AskGuildBattleScore();
end

function MainMenuBar_Open_Fenping_Config()
	PushEvent("UI_COMMAND", 20220912, LuaFnisFenpingAlreadyOpen())
end
