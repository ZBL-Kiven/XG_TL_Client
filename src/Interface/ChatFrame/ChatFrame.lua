local g_KeepHeight = 105; --��Ļ�Ϸ����ɸ��ǵ�������ռ�ĸ߶�
local g_MinHeight = 107; --��������߶ȵ���Сֵ --����������Сֵ
local g_FenpingMinHeight = 112; --�������߶���Сֵ
local g_FenpingMaxHeight = 196; --�������߶����ֵ
local g_MaxHeight = 449 - 28; --��������߶ȵ����ֵ
local g_MinWidth = 320;    --���������ȵ���Сֵ
local g_MaxWidth = 800 - 180;    --���������ȵ����ֵ

local g_MoveUpHeight = 70; --��Ļ�ֱ��ʱ仯ʱ�������߶�
local g_CurSpeakerName = "";
local channel_config = {};
local CHANNEL_DATA = {};

local channel_select = 0;     --Ĭ��ѡ��ȫ����
local channel_tab = {};
local CHANNEL_TAB_MAX = 7;    --����м���ҳ��Tab
local channel_tab_total_default = 6;  --Ĭ���м���ҳ��Tab
local g_channel_fenping = 7;  --����ID

local channel_sendhis = 0;    --0 ���Ǵӷ�����ʷ���ȡ���ִ�
--1 �Ǵӷ�����ʷ���ȡ���ִ�
local channel_sendhis2 = 0;

local g_CurFlashTab = -1;
local channel_tab_total = 6;  --Ĭ���м���ҳ��Tab
local channel_flash = {};
local CHANNEL_DATA_NEAR = {
	"set:Buttons image:Channelvicinity_Normal", -- Ƶ��ѡ��ť��ͨ
	"set:Buttons image:ChannelVicinity_Hover", -- Ƶ��ѡ��ť����
	"set:Buttons image:ChannelVicinity_Pushed", -- Ƶ��ѡ��ť����
	"#cFFFFFF", -- ����������ɫ
	"#e010101#cFFFFFF", -- ���ơ�������
	--		"#91#e010101#cFFFFFF",
};

local CHANNEL_DATA_SCENE = {
	"set:Buttons image:ChannelWorld_Normal",
	"set:Buttons image:ChannelWorld_Hover",
	"set:Buttons image:ChannelWorld_Pushed",
	"#cFFFFFF",
	"#e010101#c00FFCC", --�����硿
	--		"#92#e010101#c00FF00",
};

local CHANNEL_DATA_PRIVATE = {
	"set:Buttons image:ChannelPersonal_Normal",
	"set:Buttons image:ChannelPersonal_Hover",
	"set:Buttons image:ChannelPersonal_Pushed",
	"#cFFFFFF",
	"#e010101#cFF7C80", --��˽�ġ�
	--		"#98#e010101#c99CC00",
};

local CHANNEL_DATA_SYSTEM = {
	"set:Buttons image:ChannelPersonal_Normal",
	"set:Buttons image:ChannelPersonal_Hover",
	"set:Buttons image:ChannelPersonal_Pushed",
	"#cFF0000",
	"#e010101#cFF0000", --��ϵͳ��
	--		"#96#e010101#cFFFF00",
};

local CHANNEL_DATA_TEAM = {
	"set:Buttons image:ChannelTeam_Normal",
	"set:Buttons image:ChannelTeam_Hover",
	"set:Buttons image:ChannelTeam_Pushed",
	"#cFFFFFF",
	"#e010101#cCC99FF", --�����顿
	--	"#93#e010101#cFFFF00",
};

local CHANNEL_DATA_SELF = {
	"set:Buttons image:ChannelTeam_Normal",
	"set:Buttons image:ChannelTeam_Hover",
	"set:Buttons image:ChannelTeam_Pushed",
	"#e010101#cFFFFFF",
	--		"#e010101#cFFFF00",				--�����á�
	"nouse",
};

local CHANNEL_DATA_HELP = {
	"set:Buttons image:ChannelTeam_Normal",
	"set:Buttons image:ChannelTeam_Hover",
	"set:Buttons image:ChannelTeam_Pushed",
	"#e010101#cFFFFFF",
	--		"#e010101#cFFFF00",				--��������
	"nouse",
};

local CHANNEL_DATA_MENPAI = {
	"set:Buttons image:ChannelMenpai_Normal",
	"set:Buttons image:ChannelMenpai_Hover",
	"set:Buttons image:ChannelMenpai_Pushed",
	"#cFFFFFF",
	"#e010101#cFFFF00", --�����ɡ�
	--		"#94#e010101#cFFFF00",
};

local CHANNEL_DATA_GUILD = {
	"set:Buttons image:ChannelCorporative_Normal",
	"set:Buttons image:ChannelCorporative_Hover",
	"set:Buttons image:ChannelCorporative_Pushed",
	"#cFFFFFF",
	"#e010101#cFFCC99", --����᡿
	--		"#95#e010101#cFFFF00",
};

local CHANNEL_DATA_GUILD_LEAGUE = {
	"set:CommonFrame6 image:ChannelTongMeng_Normal",
	"set:CommonFrame6 image:ChannelTongMeng_Hover",
	"set:CommonFrame6 image:ChannelTongMeng_Pushed",
	"#cFFFFFF",
	"#e010101#c66c4fc", --�����ͬ�ˡ�
	--		"#95#e010101#cFFFF00",
};

local CHANNEL_DATA_IPREGION = {
	"set:UIIcons image:ChannelCorporative_Normal",
	"set:UIIcons image:ChannelCorporative_Hover",
	"set:UIIcons image:ChannelCorporative_Pushed",
	"#e010101#cFFFFFF",
	--		"#e010101#cFFFF00",				--��ͬ�ǡ�
	"nouse",
};

local g_theCurrentChannel = "near";
local g_theCurrentChannelName = "";
local g_MoveCtl;

function ChatFrame_PreLoad()
	this:RegisterEvent("APPLICATION_INITED");
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("CHAT_MESSAGE");
	this:RegisterEvent("CHAT_CHANNEL_CHANGED");
	this:RegisterEvent("CHAT_CHANGE_PRIVATENAME");
	this:RegisterEvent("CHAT_TAB_CREATE_FINISH");
	this:RegisterEvent("CHAT_TAB_CONFIG_FINISH");
	this:RegisterEvent("ACCELERATE_KEYSEND");
	this:RegisterEvent("CHAT_CONTEX_MENU");
	this:RegisterEvent("CHAT_ACTSET");
	this:RegisterEvent("CHAT_ADJUST_MOVE_CTL");
	this:RegisterEvent("CHAT_LOAD_TAB_CONFIG");
	this:RegisterEvent("CHAT_MENUBAR_ACTION");
	this:RegisterEvent("RESET_ALLUI");
	this:RegisterEvent("SHOW_SPEAKER");
	this:RegisterEvent("FLASH_TAB");
	this:RegisterEvent("UI_COMMAND");
end

function ChatFrame_OnLoad()
	channel_tab_total = channel_tab_total_default
	CHANNEL_DATA["near"] = CHANNEL_DATA_NEAR;
	CHANNEL_DATA["scene"] = CHANNEL_DATA_SCENE;
	CHANNEL_DATA["private"] = CHANNEL_DATA_PRIVATE;
	CHANNEL_DATA["system"] = CHANNEL_DATA_SYSTEM;
	CHANNEL_DATA["team"] = CHANNEL_DATA_TEAM;
	CHANNEL_DATA["self"] = CHANNEL_DATA_SELF;
	CHANNEL_DATA["menpai"] = CHANNEL_DATA_MENPAI;
	CHANNEL_DATA["guild"] = CHANNEL_DATA_GUILD;
	CHANNEL_DATA["guild_league"] = CHANNEL_DATA_GUILD_LEAGUE;
	CHANNEL_DATA["help"] = CHANNEL_DATA_HELP;
	CHANNEL_DATA["ipregion"] = CHANNEL_DATA_IPREGION;
	
	--TABҳ��������Ϣ
	channel_tab[1] = Chat_SystemChk;
	channel_tab[2] = Chat_Country;
	channel_tab[3] = Chat_CommonChk;
	channel_tab[4] = Chat_SelfChk;
	channel_tab[5] = Chat_Family;
	channel_tab[6] = Chat_Team;
	channel_tab[7] = Chat_CreateChk1;
	
	-- ����GameDefine2.h �� ENUM_CHAT_TYPE ˳��
	--���������飬���磬˽�ģ�ϵͳ���Խ�����ᣬ���ɣ����ã����������ȣ�ͬ�ǣ�ͬ�ˣ�����
	channel_config[0] = { "����", 1, 0, 1, 0, 1, 0, 0, 1, 0, 1, 0, 0, 0, 0 };
	channel_config[1] = { "����", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0 };
	channel_config[2] = { "ϵͳ", 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, 0, 0, 0, 0 };
	channel_config[3] = { "����", 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
	channel_config[4] = { "����", 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0 };
	channel_config[5] = { "���", 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
	channel_config[6] = { "�Խ�", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
	--����
	channel_config[7] = { "", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
	channel_config[8] = { "", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
	
	--����С����
	Chat_ChatSpeaker_StarWindow:SetText("");
	Chat_ChatSpeaker_StarWindow:SetProperty("Name", "");
	Chat_ChatSpeaker_StarWindow:Hide();
	Chat_ChatSpeaker_StarWindow2:Hide();
	Chat_Frame_FenpingFrame:Hide();
	NotFlashAllTab()
end

function ChatFrame_OnEvent(event)
	if (event == "PLAYER_ENTERING_WORLD") then
		this:Show();
		--������ʷ��Ϣ��¼��������ֵ
		Talk:SetMaxSaveNumber(tonumber(Chat_Frame_History:GetProperty("ChatBoardNumber")));
		Talk:SetMaxSaveNumber(tonumber(Chat_Frame_Fenping:GetProperty("ChatBoardNumber")));
		--����ϵͳ��Ϣ���Զ���ʧʱ����
		Talk:SetDisappearTime(tonumber(Chat_Frame_History:GetProperty("BoardKillTimer")));
		Talk:SetCurTab(0);
		ChatFrame_SetTabConfig(0);
		ChatFrame_SetTabConfig(1);
		ChatFrame_SetTabConfig(2);
		ChatFrame_SetTabConfig(3);
		ChatFrame_SetTabConfig(4);
		ChatFrame_SetTabConfig(5);
		Talk:HandleHistoryAction("listChange", g_theCurrentChannel, g_theCurrentChannelName);
	elseif (event == "CHAT_MESSAGE") then
		--ChatFrame_InsertChatContent(arg0, arg1, arg2);
	elseif (event == "CHAT_CHANNEL_CHANGED") then
		ChatFrame_ChannelChanged(arg0);
	elseif (event == "CHAT_TAB_CREATE_FINISH") then
		ChatFrame_CreateTabFinish(arg0, arg1, arg2);
	elseif (event == "CHAT_TAB_CONFIG_FINISH") then
		ChatFrame_ConfigTabFinish(arg0, arg1, arg2);
	elseif (event == "ACCELERATE_KEYSEND") then
		ChatFrame_HandleAccKey(arg0, arg1, arg2);
	elseif (event == "CHAT_CHANGE_PRIVATENAME") then
		ChatFrame_ChangePrivateName(arg0);
	elseif (event == "CHAT_CONTEX_MENU") then
		ChatFrame_ContexMenu_Open(arg0, arg1);
	elseif (event == "CHAT_ACTSET") then
		ChatFrame_ActSetMessage(arg0);
	elseif (event == "CHAT_ADJUST_MOVE_CTL") then
		ChatFrame_AdjustMoveCtl(arg0, arg1);
	elseif (event == "CHAT_LOAD_TAB_CONFIG") then
		ChatFrame_LoadTabConfig(arg2, arg0, arg1);
	elseif (event == "CHAT_MENUBAR_ACTION") then
		ChatFrame_HandleMenuBarAction(arg0, arg1, arg2);
	elseif (event == "RESET_ALLUI") then
		channel_tab_total = channel_tab_total_default
		for i = channel_tab_total, CHANNEL_TAB_MAX - 1 do
			ChatFrame_SetTabMouseRButtonHollow(i, 1);
			channel_tab[i]:Hide();
		end
		g_theCurrentChannel = "near";
		g_theCurrentChannelName = "";
		channel_select = 0;
		--����С����
		Chat_ChatSpeaker_StarWindow:SetText("");
		Chat_ChatSpeaker_StarWindow:SetProperty("Name", "");
		Chat_ChatSpeaker_StarWindow:Hide();
		Chat_ChatSpeaker_StarWindow2:Hide();
		Chat_SystemChk:SetCheck(1)
		NotFlashAllTab()
	elseif (event == "SHOW_SPEAKER") then
		g_CurSpeakerName = arg0;
		g_CurSpeakerContex = arg1;
		if (Player:GetName() == g_CurSpeakerName) then
			Chat_ChatSpeaker_StarWindow:SetText("#e010101[" .. tostring(arg0) .. "]#W:" .. tostring(arg1));
		else
			Chat_ChatSpeaker_StarWindow:SetText("#e010101#c00ccff[" .. tostring(arg0) .. "]#W:" .. tostring(arg1));
		end
		Chat_ChatSpeaker_StarWindow:SetProperty("Name", tostring(arg0));
		Chat_ChatSpeaker_StarWindow:SetProperty("Reset", "false");
		Chat_ChatSpeaker_StarWindow2:SetProperty("Reset", "false");
		Talk:HideContexMenu4Speaker();
	elseif (event == "UI_COMMAND") then
		--	���÷�������
		if tonumber(arg0) == 202209131 then
			ChatFrame_CreateFenping(arg1)
		end
		--	�رշ�������
		if tonumber(arg0) == 202209132 then
			ChatFrame_CloseFenping(arg1)
		end
	end
end
--�������� added by zhanglei 
--strCfg ��������
function ChatFrame_CreateFenping(strCfg)
	ChatFrame_PrepareMove();
	
	local absFrameHeight = g_MoveCtl.frame:GetProperty("AbsoluteHeight");
	local absHistoryHeight = g_MoveCtl.history:GetProperty("AbsoluteHeight");
	local absCheckHeight = g_MoveCtl.check:GetProperty("AbsoluteHeight");
	local absFenpingHeight = g_FenpingMinHeight;
	local udimStr = g_MoveCtl.frame:GetProperty("UnifiedYPosition");
	if tonumber(absFrameHeight) < g_FenpingMinHeight + absHistoryHeight then
		--����û����ʾ�����������ʾ����˵������� �ղ�ѡ�񡰷��ص�¼���浼�µġ�
		--���������ؼ���С
		--frame ����frame��λ��
		if absFenpingHeight + absFrameHeight > g_MaxHeight then
			--����frame�����ֵ�ˣ���СHistory�Ĵ�С ���Ķ�Frame�Ĵ�С
			local step = math.ceil((absFrameHeight + absFenpingHeight - g_MaxHeight) / 28) * 28;
			local udimScale;
			local udimFrameYPos;
			_, _, udimScale = string.find(udimStr, "{(%d+%.%d+),");
			_, _, udimFrameYPos = string.find(udimStr, ",([+-]?[0-9]+%.[0-9]+)}");
			udimScale = tonumber(udimScale);
			
			udimFrameYPos = tonumber(udimFrameYPos) - (absFenpingHeight - step); --����С��0�����촰�������½ǰ󶨵�
			g_MoveCtl.frame:SetProperty("AbsoluteHeight", absFrameHeight + absFenpingHeight - step);
			udimStr = string.format("{%f,%f}", udimScale, udimFrameYPos);
			g_MoveCtl.frame:SetProperty("UnifiedYPosition", udimStr);
			g_MoveCtl.history:SetProperty("AbsoluteHeight", absHistoryHeight - step);
		else
			--û�г�����ֱ��create����
			local udimScale;
			local udimFrameYPos;
			_, _, udimScale = string.find(udimStr, "{(%d+%.%d+),");
			_, _, udimFrameYPos = string.find(udimStr, ",([+-]?[0-9]+%.[0-9]+)}");
			udimScale = tonumber(udimScale);
			
			udimFrameYPos = tonumber(udimFrameYPos) - absFenpingHeight; --����С��0�����촰�������½ǰ󶨵�
			g_MoveCtl.frame:SetProperty("AbsoluteHeight", absFrameHeight + absFenpingHeight);
			udimStr = string.format("{%f,%f}", udimScale, udimFrameYPos);
			g_MoveCtl.frame:SetProperty("UnifiedYPosition", udimStr);
			
			g_MoveCtl.history:SetProperty("AbsoluteHeight", absHistoryHeight);
			local starPos;
			strPos = "{1.0," .. tostring(udimFrameYPos - 83) .. ".0}";
			Chat_ChatSpeaker:SetProperty("UnifiedYPosition", strPos);
		end
		
		g_MoveCtl.fenping:SetProperty("AbsoluteHeight", absFenpingHeight);
		local udimStr_fenping = string.format("{%f,%f}", 1.000000, -absFenpingHeight);
		g_MoveCtl.fenping:SetProperty("UnifiedYPosition", udimStr_fenping);
		g_MoveCtl.fenping:Show();
	end
	
	ChatFrame_FenpingCreateConfig(strCfg);
	
	Chat_Frame_History:ScrollToEnd();
	Chat_Frame_Fenping:ScrollToEnd();
end

--����������ʱ�����õı��棬��ʷ���ݵ�д��
function ChatFrame_FenpingCreateConfig(tabCfg)
	local tabName = "FP";
	local old_channel = channel_select;
	channel_select = g_channel_fenping;
	ChatFrame_ChangeTabConfig(tabCfg);
	channel_config[channel_select][1] = tabName;
	
	--��������
	FenPingSaveTab(channel_select, tabName, tabCfg);
	ChatFrame_SetTabConfig(channel_select);
	
	ChatFrame_AddFenpingMsg(channel_select);
	
	channel_select = old_channel;
end

-- ��������ʷ���ݵĴ���
-- ����ʷ��Ϣ��ʾ������
function ChatFrame_AddFenpingMsg(nIndex)
	Chat_Frame_Fenping:RemoveAllChatString();
	
	if channel_config[nIndex] == nil then
		Talk:InsertHistory(nIndex, "");
	else
		local i = 2;
		local strConfig = "";
		while channel_config[nIndex][i] ~= nil do
			strConfig = strConfig .. tostring(channel_config[nIndex][i]);
			i = i + 1;
		end
		Talk:InsertHistory(nIndex, strConfig);
	end
	
	Chat_Frame_Fenping:ScrollToEnd();
end
--���÷������� added by zhanglei 
--strCfg ��������
function ChatFrame_CloseFenping(strCfg)
	ChatFrame_PrepareMove();
	
	--�ȹرշ���
	g_MoveCtl.fenping:Hide();
	
	local absFrameHeight = g_MoveCtl.frame:GetProperty("AbsoluteHeight");
	local absHistoryHeight = g_MoveCtl.history:GetProperty("AbsoluteHeight");
	local absCheckHeight = g_MoveCtl.check:GetProperty("AbsoluteHeight");
	local absFenpingHeight = g_MoveCtl.fenping:GetProperty("AbsoluteHeight");
	local udimStr = g_MoveCtl.frame:GetProperty("UnifiedYPosition");
	
	local udimScale;
	local udimFrameYPos;
	_, _, udimScale = string.find(udimStr, "{(%d+%.%d+),");
	_, _, udimFrameYPos = string.find(udimStr, ",([+-]?[0-9]+%.[0-9]+)}");
	udimScale = tonumber(udimScale);
	
	udimFrameYPos = tonumber(udimFrameYPos) + absFenpingHeight; --����С��0�����촰�������½ǰ󶨵�
	
	--���������ؼ���С
	g_MoveCtl.frame:SetProperty("AbsoluteHeight", absFrameHeight - absFenpingHeight);
	g_MoveCtl.history:SetProperty("AbsoluteHeight", absHistoryHeight);
	--frame ����frame��λ��
	udimStr = string.format("{%f,%f}", udimScale, udimFrameYPos);
	g_MoveCtl.frame:SetProperty("UnifiedYPosition", udimStr);
	
	local starPos;
	strPos = "{1.0," .. tostring(udimFrameYPos - 83) .. ".0}";
	AxTrace(0, 0, "Position=" .. tostring(strPos));
	Chat_ChatSpeaker:SetProperty("UnifiedYPosition", strPos);
	
	Talk:ClearTab(g_channel_fenping);
	
	-- ����ChatHistory�������
	-- Talk:ClearFenpingHisQue();
	Chat_Frame_History:ScrollToEnd();
end

--�ı������ʾ����
function ChatFrame_ConfigFenping(tabCfg)
	if (tabCfg == nil) then
		return ;
	end
	local old_channel = channel_select;
	channel_select = g_channel_fenping --����ID
	ChatFrame_ChangeTabConfig(tabCfg);
	
	--��������
	FenPingSaveTab(channel_select, channel_config[channel_select][1], tabCfg);
	ChatFrame_SetTabConfig(channel_select);
	
	channel_select = old_channel;
end

function ChatFrame_OpenFenpingDlg(isFenpingOpen)
	-- if tonumber(isFenpingOpen) == 0 then
	-- Talk:OpenFenpingConfigDlg("");
	-- else
	-- ��õ�ǰ����
	-- local i = 2;
	-- local strConfig = "";
	-- while channel_config[g_channel_fenping][i] ~= nil do
	-- strConfig = strConfig .. tostring(channel_config[g_channel_fenping][i]);
	-- i = i+1;
	-- end
	-- Talk:OpenFenpingConfigDlg(strConfig);
	-- end
end

function NotFlashTab(idx)
	for i = 2, 6 do
		if (idx == i and channel_flash[i]) then
			g_CurFlashTab = -1;
			channel_flash[i]:Play(false);
		end
	end
end

function FlashTab(idx)
	for i = 2, 6 do
		if (idx == i and channel_flash[i]) then
			g_CurFlashTab = idx;
			channel_flash[i]:Play(true);
		end
	end
end

function NotFlashAllTab()
	for i = 2, 6 do
		if (channel_flash[i]) then
			
			channel_flash[i]:Play(false);
		end
	
	end
	
	g_CurFlashTab = -1;
end

function ChatFrame_TextAccepted(arg)
	-- ��ĳ��˽�ģ�arg��/Name
	local prvname = arg;
	if ("" ~= prvname) then
		Talk:HandleHistoryAction("editbox", prvname, "");
	else
		Talk:HandleHistoryAction("editbox", "", "");
	end
end

function ChatFrame_ChannelSelect(pos)
	ChatFrame_ChannelSelect_ChangePosition(pos);
	Chat_Frame_ChannelFrame:Show();
	local nChannelNum = Talk:GetChannelNumber();
	Chat_Frame_Channel:ClearAllChannel();
	local i = 1;
	local FoundPrv = -1;
	while i <= nChannelNum do
		local strChannelType, strChannelName = Talk:GetChannel(i - 1);
		if (strChannelType == "-" or CHANNEL_DATA[strChannelType] == nil) then
			return ;
		end
		--AxTrace(0,0, "i=" .. i .. "strChannelType=" .. strChannelType .. "strChannelName=" .. strChannelName);
		if (strChannelType ~= "private") then
			Chat_Frame_Channel:AddChannel(strChannelType, CHANNEL_DATA[strChannelType][1], strChannelName);
		else
			FoundPrv = i - 1;
		end
		
		i = i + 1;
	end
	
	-- ˽�Ķ����б���룬todo_yangjun
	if (-1 ~= FoundPrv) then
		local strPrvType, strPrvName1, strPrvName2, strPrvName3 = Talk:GetChannel(FoundPrv);
		if (CHANNEL_DATA[strPrvType] == nil) then
			return ;
		end
		if (strPrvName1 ~= "" and strPrvName1 ~= nil) then
			Chat_Frame_Channel:AddChannel(strPrvType, CHANNEL_DATA[strPrvType][1], strPrvName1);
		end
		if (strPrvName2 ~= "" and strPrvName2 ~= nil) then
			Chat_Frame_Channel:AddChannel(strPrvType, CHANNEL_DATA[strPrvType][1], strPrvName2);
		end
		if (strPrvName3 ~= "" and strPrvName3 ~= nil) then
			Chat_Frame_Channel:AddChannel(strPrvType, CHANNEL_DATA[strPrvType][1], strPrvName3);
		end
	end
end

function ChatFrame_ChannelListSelect()
	Chat_Frame_ChannelFrame:Hide();
	local selCh = Chat_Frame_Channel:GetProperty("HoverChannel");
	local prv = Chat_Frame_Channel:GetHoverChannelName();
	ChatFrame_ChannelListChange(selCh, prv);
end

function ChatFrame_ChannelListChange(selChannel, prvtxt)
	if (CHANNEL_DATA[selChannel] == nil) then
		return ;
	end
	g_theCurrentChannel = selChannel;
	g_theCurrentChannelName = prvtxt;
	
	Talk:HandleHistoryAction("listChange", g_theCurrentChannel, g_theCurrentChannelName);
	Talk:HandleHistoryAction("modifyTxt", "", "");
end

function ChatFrame_ChangePrivateName(newname)
	if (ChatFrame_IsNameMySelf(newname) > 0) then
		return ;
	end
	Talk:HandleHistoryAction("privateChange", newname, "");
end

function ChatFrame_InsertChatContent(chatType, chatTalkerName, chatContent)
	-- if (CHANNEL_DATA[chatType] == nil) then
	-- 	return
	-- end
	-- --if(chatContent == "@" or chatContent == "*") then return; end
	--
	-- local strFinal;
	-- local strHeader = Talk:GetChannelHeader(chatType, chatTalkerName);
	-- if (nil == strHeader) then
	-- 	--AxTrace(0,0,"Err!!! ChatFrame Type:"..chatType);
	-- 	return
	-- end
	-- if (chatTalkerName == "" and chatType ~= "self") then
	-- 	strFinal = CHANNEL_DATA[chatType][5];
	-- 	strFinal = strFinal .. "[" .. strHeader .. "]";
	-- 	strFinal = strFinal .. CHANNEL_DATA[chatType][4] .. chatContent;
	-- else
	-- 	if (chatType ~= "self") then
	-- 		strFinal = CHANNEL_DATA[chatType][5];
	-- 		if (string.byte(chatContent, 1) ~= 64 and string.byte(chatContent, 1) ~= 42) then
	-- 			-- '@' ���ֱ������
	-- 			local countryName = DataPool:GetFriend("chat", "GUILD_LEAGUE_NAME") or "Error"
	-- 			strFinal = strFinal .. "[" .. strHeader .. "]" .. "[" .. countryName .. "]";
	-- 			if (ChatFrame_IsNameMySelf(chatTalkerName) > 0) then
	-- 				strFinal = strFinal .. "#W[" .. chatTalkerName .. "]";
	-- 			else
	-- 				--strFinal = strFinal .. "#c00CCFF[#aB{" .. chatTalkerName .. "}" .. chatTalkerName .. "#aE]";
	-- 				strFinal = strFinal .. Talk:GetHyperLinkString(chatType, chatTalkerName);
	-- 			end
	-- 			strFinal = strFinal .. CHANNEL_DATA[chatType][4] .. "��" .. chatContent;
	-- 		else
	-- 			local strTemplate = Talk:GetTalkTemplateString(chatTalkerName, chatContent);
	-- 			local countryName = DataPool:GetFriend("chat", "GUILD_LEAGUE_NAME") or "Error"
	-- 			strFinal = strFinal .. "[" .. strHeader .. "]" .. "[" .. countryName .. "]";
	-- 			strFinal = strFinal .. strTemplate;
	-- 		end
	-- 	else
	-- 		strFinal = CHANNEL_DATA[chatType][4] .. chatContent;
	-- 	end
	-- end
	-- PushDebugMessage("����")
	--AxTrace(0, 0, strFinal);
	--if( 0 == channel_seltab ) then
	--Chat_Frame_History:InsertChatString(strFinal);
	--else
	--local pos = Talk:GetChannelType(chatType);
	-- todo_yangjun
	--if( 1 == channel_config[channel_seltab][pos+2]) then
	--Chat_Frame_History:InsertChatString(strFinal);
	--end
	--end

end

function ChatFrame_PrepareMove()
	g_MoveCtl = {
		frame = Chat_Frame,
		check = Chat_CheckBox_Frame,
		history = Chat_Frame_HistoryFrame,
		fenping = Chat_Frame_FenpingFrame,
		--nomove = Chat_Frame_NoMoveFrame,
	};
end

--���������߶�
function ChatFrame_MoveCtl(dir)
	ChatFrame_PrepareMove();
	local absFrameHeight = g_MoveCtl.frame:GetProperty("AbsoluteHeight");
	local absFenpingHeight = g_MoveCtl.fenping:GetProperty("AbsoluteHeight");
	local absHistoryHeight = g_MoveCtl.history:GetProperty("AbsoluteHeight");
	local absCheckHeight = g_MoveCtl.check:GetProperty("AbsoluteHeight");
	local step;
	local bMoveFenping = 0;
	local bMoveFrame = 0;
	--ע�⣬�߻�Ҫ�������������ܺ������ֵ��
	--���� ������������Сֵ�Ƿֿ�
	if (dir > 0) then
		step = -28
		if (absFrameHeight - step > g_MaxHeight) then
			--�������ֵ
			if g_MoveCtl.fenping:IsVisible() then
				--�������ˣ���С����
				if absFenpingHeight + step < g_FenpingMinHeight then
					--��������Ѿ�����Сֵ��������С
					return ;
				else
					--��С����ģ��Ŵ������
					bMoveFenping = 1;
				end
			else
				--����û��
				return
			end
		else
			bMoveFrame = 1;
		end
	else
		step = 28;
		bMoveFrame = 1;
		--��Сֵ�ж�ʹ�õ����ĸ߶�
		if (absHistoryHeight + absCheckHeight - step < g_MinHeight) then
			return ;
		end
	end
	local udimStr = g_MoveCtl.frame:GetProperty("UnifiedYPosition");
	local udimScale;
	local udimFrameYPos;
	_, _, udimScale = string.find(udimStr, "{(%d+%.%d+),");
	_, _, udimFrameYPos = string.find(udimStr, ",([+-]?[0-9]+%.[0-9]+)}");
	udimScale = tonumber(udimScale);
	udimFrameYPos = tonumber(udimFrameYPos) + step; --����С��0�����촰�������½ǰ󶨵�
	absCheckHeight = g_MoveCtl.check:GetProperty("AbsoluteHeight");
	--frame
	udimStr = string.format("{%f,%f}", udimScale, udimFrameYPos);
	if bMoveFrame == 1 then
		g_MoveCtl.frame:SetProperty("UnifiedYPosition", udimStr);
		g_MoveCtl.frame:SetProperty("AbsoluteHeight", absFrameHeight - step);
	end
	
	if bMoveFenping == 1 then
		g_MoveCtl.fenping:SetProperty("AbsoluteHeight", absFenpingHeight + step);
		local udimStr_fenping = string.format("{%f,%f}", 1.000000, -(absFenpingHeight + step));
		g_MoveCtl.fenping:SetProperty("UnifiedYPosition", udimStr_fenping);
		Chat_Frame_Fenping:ScrollToEnd();
	end
	absFrameHeight = g_MoveCtl.frame:GetProperty("AbsoluteHeight");
	
	--	udimStr = string.format("{%f,-%f}", udimScale,absCheckHeight + 100);
	
	--check
	g_MoveCtl.check:SetProperty("AbsoluteHeight", absCheckHeight);
	
	--bakimg
	--history
	g_MoveCtl.history:SetProperty("AbsoluteHeight", absHistoryHeight - step);
	g_MoveCtl.history:SetProperty("AbsoluteYPosition", absCheckHeight);
	
	local starPos;
	strPos = "{1.0," .. tostring(udimFrameYPos - 83) .. ".0}";
	AxTrace(0, 0, "Position=" .. tostring(strPos));
	Chat_ChatSpeaker:SetProperty("UnifiedYPosition", strPos);
	Chat_Frame_History:ScrollToEnd();
end

--���������߶�
function ChatFrame_MoveCtl_Fenping(dir)
	ChatFrame_PrepareMove();
	local absFrameHeight = g_MoveCtl.frame:GetProperty("AbsoluteHeight");
	local absFenpingHeight = g_MoveCtl.fenping:GetProperty("AbsoluteHeight");
	local absHistoryHeight = g_MoveCtl.history:GetProperty("AbsoluteHeight");
	local absCheckHeight = g_MoveCtl.check:GetProperty("AbsoluteHeight");
	
	local step;
	--����3λ��ʾ�Ƿ���Ҫ�ƶ��ؼ���λ��
	local bMoveFrame = 0
	local bMoveHistory = 0
	local bMoveFenping = 0
	--ע�⣬�߻�Ҫ�������������ܺ������ֵ�������������߶�Ϊg_FenpingMaxHeight,�������ܺʹﵽ���ֵ��ʱ����������ᶥ���������
	if (dir > 0) then
		step = -28
		if absFenpingHeight - step > g_FenpingMaxHeight then
			--�����ĸ߶ȳ������ֵ������ԭ��ֵ
			step = g_FenpingMaxHeight - g_FenpingMinHeight;
			bMoveFrame = 1;
			bMoveFenping = 1;
		else
			--�����߶�û�������ֵ
			if absFrameHeight - step > g_MaxHeight then
				--�����ܺͳ������ֵ����С����
				bMoveHistory = 1;
				bMoveFenping = 1;
			else
				--�����ܺ�Ϊ�ﵽ���ֵ��ֱ�ӽ���������
				bMoveFrame = 1;
				bMoveFenping = 1;
			end
		end
	else
		step = 28;
		--��Сֵ�ж�ʹ�õ����ĸ߶�
		if (absFenpingHeight - step < g_FenpingMinHeight) then
			return ;
		end
	end
	
	local udimStr = g_MoveCtl.frame:GetProperty("UnifiedYPosition");
	
	local udimScale;
	local udimFrameYPos;
	_, _, udimScale = string.find(udimStr, "{(%d+%.%d+),");
	_, _, udimFrameYPos = string.find(udimStr, ",([+-]?[0-9]+%.[0-9]+)}");
	udimScale = tonumber(udimScale);
	udimFrameYPos = tonumber(udimFrameYPos) + step; --����С��0�����촰�������½ǰ󶨵�
	
	--frame
	udimStr = string.format("{%f,%f}", udimScale, udimFrameYPos);
	if bMoveFrame == 1 then
		g_MoveCtl.frame:SetProperty("UnifiedYPosition", udimStr);
		g_MoveCtl.frame:SetProperty("AbsoluteHeight", absFrameHeight - step);
		
		local starPos;
		strPos = "{1.0," .. tostring(udimFrameYPos - 83) .. ".0}";
		AxTrace(0, 0, "Position=" .. tostring(strPos));
		Chat_ChatSpeaker:SetProperty("UnifiedYPosition", strPos);
	end
	
	--�������Ͻ�Yֵ
	udimStr = string.format("{%f,%f}", 1.000000, -(absFenpingHeight - step));
	
	--bakimg
	if bMoveFenping == 1 then
		g_MoveCtl.fenping:SetProperty("AbsoluteHeight", absFenpingHeight - step);
		g_MoveCtl.fenping:SetProperty("UnifiedYPosition", udimStr);
	end
	
	if bMoveHistory == 1 then
		g_MoveCtl.history:SetProperty("AbsoluteHeight", absHistoryHeight + step);
	end
	
	Chat_Frame_History:ScrollToEnd();
	Chat_Frame_Fenping:ScrollToEnd();
end


--���������Ŀ��
function ChatFrame_WidthCtl(dir)
	ChatFrame_PrepareMove();
	local absFrameWidth = g_MoveCtl.frame:GetProperty("AbsoluteWidth");
	
	local step;
	if (dir > 0) then
		step = -18
		if (absFrameWidth - step > g_MaxWidth) then
			return ;
		end
	else
		step = 18;
		if (absFrameWidth - step < g_MinWidth) then
			return ;
		end
	end
	
	--frame
	g_MoveCtl.frame:SetProperty("AbsoluteWidth", absFrameWidth - step);
	absFrameWidth = g_MoveCtl.frame:GetProperty("AbsoluteWidth");
	
	--history
	g_MoveCtl.history:SetProperty("AbsoluteWidth", absFrameWidth);
	g_MoveCtl.fenping:SetProperty("AbsoluteWidth", absFrameWidth);
	
	Chat_Frame_History:ScrollToEnd();
	Chat_Frame_Fenping:ScrollToEnd();
end

function ChatFrame_AdjustMoveCtl(screenWidth, screenHeight)
	ChatFrame_PrepareMove();
	Chat_Frame_ChannelFrame:Hide();
	
	local tolHeight = tonumber(screenHeight);
	if (tolHeight < 480) then
		return
	end
	local absMoveUpHeight = 0;
	--if(tonumber(screenWidth) < 1080) then
	absMoveUpHeight = g_MoveUpHeight;
	--end
	local absCheckHeight = g_MoveCtl.check:GetProperty("AbsoluteHeight");
	local absFrameHeight = g_MoveCtl.frame:GetProperty("AbsoluteHeight");
	--�������ڵĸ߶��ǲ��ǳ�����ʾ��Χ�ˡ�
	local udimStr = g_MoveCtl.frame:GetProperty("UnifiedYPosition");
	
	local udimScale;
	local udimFrameYPos;
	_, _, udimScale = string.find(udimStr, "{(%d+%.%d+),");
	_, _, udimFrameYPos = string.find(udimStr, ",([+-]?[0-9]+%.[0-9]+)}");
	udimScale = tonumber(udimScale);
	udimFrameYPos = tonumber(udimFrameYPos); --����С��0�����촰�������½ǰ󶨵�
	
	if ((absFrameHeight + g_KeepHeight + absMoveUpHeight) > tolHeight) then
		local newFrameYPos = (tolHeight - g_KeepHeight - absMoveUpHeight) * -1;
		local newFrameHeight = tolHeight - g_KeepHeight - absMoveUpHeight;
		--frame
		udimStr = string.format("{%f,%f}", udimScale, newFrameYPos);
		g_MoveCtl.frame:SetProperty("UnifiedYPosition", udimStr);
		g_MoveCtl.frame:SetProperty("AbsoluteHeight", newFrameHeight);
	else
		local newFrameYPos = (absFrameHeight + absMoveUpHeight) * -1;
		--frame
		udimStr = string.format("{%f,%f}", udimScale, newFrameYPos);
		g_MoveCtl.frame:SetProperty("UnifiedYPosition", udimStr);
	end
	
	--�����Ӵ����λ��
	absFrameHeight = g_MoveCtl.frame:GetProperty("AbsoluteHeight");
	
	--check
	if (tonumber(absCheckHeight) ~= 0) then
		g_MoveCtl.check:SetProperty("AbsoluteHeight", absCheckHeight);
	end
	--history
	--g_MoveCtl.history:SetProperty("AbsoluteHeight", absFrameHeight-absCheckHeight);
	g_MoveCtl.history:SetProperty("AbsoluteYPosition", absCheckHeight);
	
	Chat_Frame_History:ScrollToEnd();
end

function ChatFrame_AskFrameSizeUP()
	ChatFrame_MoveCtl(1);
end

function ChatFrame_AskFrameSizeDown()
	ChatFrame_MoveCtl(-1);
end

function ChatFrame_AskFrameWidthUP()
	ChatFrame_WidthCtl(1);
end

function ChatFrame_AskFrameWidthDown()
	ChatFrame_WidthCtl(-1);
end

function ChatFrame_ChannelChanged(force)
	if (force == "force_near") then
		g_theCurrentChannel = "near"
		Talk:HandleHistoryAction("listChange", g_theCurrentChannel, "");
	elseif (force == "close_team" and g_theCurrentChannel == "team") then
		g_theCurrentChannel = "near"
		Talk:HandleHistoryAction("listChange", g_theCurrentChannel, "");
	elseif (force == "close_menpai" and g_theCurrentChannel == "menpai") then
		g_theCurrentChannel = "near"
		Talk:HandleHistoryAction("listChange", g_theCurrentChannel, "");
	elseif (force == "close_guild" and g_theCurrentChannel == "guild") then
		g_theCurrentChannel = "near"
		Talk:HandleHistoryAction("listChange", g_theCurrentChannel, "");
	elseif (force == "close_guild_league" and g_theCurrentChannel == "guild_league") then
		g_theCurrentChannel = "near"
		Talk:HandleHistoryAction("listChange", g_theCurrentChannel, "");
	elseif (g_theCurrentChannel == "private") then
		g_theCurrentChannel = "near"
		Talk:HandleHistoryAction("listChange", g_theCurrentChannel, "");
	end
end

function Chat_ChangeTabIndex(nIndex)
	Chat_Frame_History:RemoveAllChatString();
	if nIndex < 0 then
		nIndex = 0
	end
	channel_select = nIndex;
	Talk:SetCurTab(channel_select);
	
	if channel_config[nIndex] == nil then
		Talk:InsertHistory(nIndex, "");
	else
		local i = 2;
		local strConfig = "";
		while channel_config[nIndex][i] ~= nil do
			strConfig = strConfig .. tostring(channel_config[nIndex][i]);
			i = i + 1;
		end
		Talk:InsertHistory(nIndex, strConfig);
		-- if nIndex == 2 then
		-- 	--����Ƶ��ϵͳ��Ϣ��ʾ�Ƿ�ѡ
		-- 	if channel_config[nIndex][5] == 0 then
		-- 		SetDisappearShow(1)
		-- 	else
		-- 		--�Ǹ���Ƶ����ʾϵͳ��Ϣ
		-- 		SetDisappearShow(0)
		-- 	end
		-- else
		-- 	SetDisappearShow(0)
		-- end
	end
	
	Chat_Frame_History:ScrollToEnd();
	
	if (g_CurFlashTab == channel_select and channel_select > 0) then
		NotFlashTab(g_CurFlashTab);
	end
end

function ChatFrame_CreateTab(pos)
	if (channel_tab_total + 1 > CHANNEL_TAB_MAX) then
		PushDebugMessage("���ܴ�������Ƶ��");
	else
		Talk:CreateTab(pos);
	end
end

function ChatFrame_CreateTabFinish(tabName, tabCfg, strFlg)
	if (tabName == nil or tabCfg == nil or strFlg == nil) then
		return ;
	end
	if (strFlg == "sucess") then
		channel_tab_total = channel_tab_total + 1;
		if (tabName == "") then
			tabName = "�Խ�" .. tostring(channel_tab_total - channel_tab_total_default);
		end
		channel_select = channel_tab_total - 1;
		ChatFrame_ChangeTabConfig(tabCfg);
		channel_config[channel_select][1] = tabName;
		--��������
		Talk:SaveTab(channel_select, tabName, tabCfg);
		ChatFrame_SetTabConfig(channel_select);
		ChatFrame_SetTabMouseRButtonHollow(channel_select, 0);
		channel_tab[channel_tab_total]:Show();
		channel_tab[channel_tab_total]:SetCheck(1);
		channel_tab[channel_tab_total]:SetText(channel_config[channel_select][1]);
		Chat_ChangeTabIndex(channel_select);
	end
end

function ChatFrame_ConfigTab(pos)
	if (channel_select < channel_tab_total_default) then
		PushDebugMessage("��Ƶ����������");
		return ;
	end
	local i = 2;
	local strConfig = "";
	while channel_config[channel_select][i] ~= nil do
		strConfig = strConfig .. tostring(channel_config[channel_select][i]);
		i = i + 1;
	end
	Talk:ConfigTab(channel_config[channel_select][1], strConfig, pos);
end

function ChatFrame_ConfigTabFinish(tabName, tabCfg, strFlg)
	if (tabName == nil or tabCfg == nil or strFlg == nil) then
		return ;
	end
	if (strFlg == "cancel") then
	elseif (strFlg == "delete") then
		Chat_DestoryTabIndex(channel_select);
	elseif (strFlg == "sucess") then
		if (channel_select ~= 0) then
			ChatFrame_ChangeTabConfig(tabCfg);
			--Chat_ChangeTabIndex(channel_seltab);
			Talk:SaveTab(channel_select, channel_config[channel_select][1], tabCfg);
			ChatFrame_SetTabConfig(channel_select);
		end
	end
end

-- ��������ҳ��Tab����
function ChatFrame_ChangeTabConfig(tabCfg)
	local k = 1;
	for i = 2, table.getn(channel_config[channel_select]) do
		if (string.byte(tabCfg, k) == 48) then
			-- 0
			channel_config[channel_select][i] = 0;
		elseif (string.byte(tabCfg, k) == 49) then
			-- 1
			channel_config[channel_select][i] = 1;
		else
			channel_config[channel_select][i] = 0;
		end
		
		k = k + 1;
	end
end

-- ɾ������ҳ��Tab
function Chat_DestoryTabIndex(nIndex)
	if (nIndex <= channel_tab_total_default - 1) then
		PushDebugMessage("��Ƶ������ɾ��");
		return ;
	end
	-- ���ض����Tab����
	for i = channel_tab_total, CHANNEL_TAB_MAX do
		ChatFrame_SetTabMouseRButtonHollow(i, 1);
		channel_tab[i]:Hide();
	end
	channel_tab_total = channel_tab_total - 1
	Talk:ClearTab(channel_tab_total);
	
	-- ����ChatHistory�������
	Talk:MoveTabHisQue(nIndex, channel_tab_total);
	channel_tab[channel_tab_total]:SetCheck(1)
	Chat_ChangeTabIndex(channel_select - 1);
end

function ChatFrame_HandleAccKey(op, msg)
	if (nil == op) then
		return ;
	end
	
	--AxTrace(0, 0, op .. " " .. msg);
	if (channel_sendhis == 0 and op == "save_old") then
	elseif (op == "shift_up" or op == "shift_down") then
		Talk:HandleHistoryAction("changMsg", msg, "");
	elseif (op == "acc_prevchannel") then
		ChatFrame_ChangeCurrentChannel(1); --��ǰƵ����ǰһƵ��
	elseif (op == "acc_nextchannel") then
		ChatFrame_ChangeCurrentChannel(-1);    --��ǰƵ���ĺ�һƵ��
	elseif (op == "acc_clearchat") then
		ChatFrame_extendRegionTest();
	end
end

function ChatFrame_extendRegionTest()
	Chat_Frame_History:ExtendClearRegion();
end

function ChatFrame_ClearSendHis()
	if (1 ~= channel_sendhis2) then
		channel_sendhis = 0;
	end
	
	channel_sendhis2 = 0;
end

function ChatFrame_ChangeCurrentChannel(dir)
	local newtype, newname = Talk:ChangeCurrentChannel(g_theCurrentChannel, g_theCurrentChannelName, dir);
	ChatFrame_ChannelListChange(newtype, newname);
end

function ChatFrame_ContexMenu_Open(strLink, msgid)
	if (nil == strLink or ChatFrame_IsNameMySelf(strLink) > 0) then
		return ;
	end
	
	Talk:ShowContexMenu(strLink, tonumber(msgid));
end

function ChatFrame_ActSetMessage(strAct)
	if (strAct == nil or strAct == "") then
		return ;
	end
	
	local strKey = "*" .. strAct;
	Talk:SendChatMessage(g_theCurrentChannel, strKey);
end

function ChatFrame_IsNameMySelf(strName)
	if (strName == nil or strName == "") then
		return -1;
	end
	
	local myselfName = Player:GetName();
	if (myselfName == strName) then
		return 1;
	else
		return -1;
	end
end

function ChatFrame_LoadTabConfig(tabIdx, tabName, tabConfig)
	if (nil == tabIdx or nil == tabName or nil == tabConfig) then
		return ;
	end
	local selbak = channel_select;
	
	local tabId = tonumber(tabIdx);
	if (tabId > 0 and tabId < CHANNEL_TAB_MAX) then
		channel_select = tabId;
		ChatFrame_ChangeTabConfig(tabConfig);
		-- channel_config[channel_select][1] = tabName;
		ChatFrame_SetTabMouseRButtonHollow(channel_select, 0);
		--XG1 channel_tab[channel_select]:SetText(channel_config[channel_select][1]);
		channel_tab[channel_select]:Show();
		if (tabId > channel_tab_total_default) then
			channel_tab_total = channel_tab_total + 1;
		end
		ChatFrame_SetTabConfig(tabId);
	end
	channel_select = selbak;
end

function ChatFrame_SetTabConfig(tabIdx)
	if (channel_config[tabIdx] ~= nil) then
		--������д��Ϣ����
		if tabIdx == g_channel_fenping then
			local i = 2;
			local strConfig = "";
			while channel_config[tabIdx][i] ~= nil do
				strConfig = strConfig .. tostring(channel_config[tabIdx][i]);
				i = i + 1;
			end
			SetTabFPCfg(tabIdx, strConfig);
			return
		end
		local i = 2;
		local strConfig = "";
		while channel_config[tabIdx][i] ~= nil do
			strConfig = strConfig .. tostring(channel_config[tabIdx][i]);
			i = i + 1;
		end
		Talk:SetTabCfg(tabIdx, strConfig);
	end
end

function ChatFrame_SetTabMouseRButtonHollow(tabIdx, op)
	if (nil == tabIdx or tabIdx < channel_tab_total_default or tabIdx >= CHANNEL_TAB_MAX) then
		return
	end ;
	
	if (0 == tonumber(op)) then
		channel_tab[tabIdx + 1]:SetProperty("MouseRButtonHollow", "False");
	elseif (1 == tonumber(op)) then
		channel_tab[tabIdx + 1]:SetProperty("MouseRButtonHollow", "True");
	end
end

function ChatFrame_HandleMenuBarAction(op, arg, new)
	if (op == "extendRegion") then
		ChatFrame_extendRegionTest();
	elseif (op == "createTab") then
		ChatFrame_CreateTab(arg);
	elseif (op == "configTab") then
		ChatFrame_ConfigTab(arg);
	elseif (op == "sizeUp") then
		ChatFrame_AskFrameSizeUP();
	elseif (op == "sizeDown") then
		ChatFrame_AskFrameSizeDown();
	elseif (op == "widthUp") then
		ChatFrame_AskFrameWidthUP();
	elseif (op == "widthDown") then
		ChatFrame_AskFrameWidthDown();
	elseif (op == "channelSelect") then
		ChatFrame_ChannelSelect(arg);
	elseif (op == "txtAccept") then
		ChatFrame_TextAccepted(arg);
	elseif (op == "saveChatLog") then
		Talk:SaveChatHistory(channel_select);
	elseif (op == "chatbkg") then
		ChatFrame_ChangeChatBkgAlpha(arg);
	elseif (op == "infochannel") then
		ChatFrame_ChannelListChange(arg, new);
	end
end

function ChatFrame_ChannelSelect_ChangePosition(pos)
	Chat_Frame_Channel:SetProperty("AnchorPosition", "x:" .. tostring(pos - 2) .. " y:23.0");
end

function ChatFrame_ChangeChatBkgAlpha(val)
	Chat_Frame_HistoryFrame:SetProperty("Alpha", val);
	Chat_Frame_FenpingFrame:SetProperty("Alpha", val);
end

function Chat_ChatSpeaker_NameLClick()
	ChatFrame_ChangePrivateName(g_CurSpeakerName);
end

function Chat_ChatSpeaker_NameRClick()
	if (nil == g_CurSpeakerName or ChatFrame_IsNameMySelf(g_CurSpeakerName) > 0) then
		return ;
	end
	Talk:ShowContexMenu4Speaker(g_CurSpeakerName, g_CurSpeakerContex);
end