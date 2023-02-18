--华山论剑 新比武大会
local g_HuaShanLunJian_Lounge_UnifiedPosition;
local g_bUpdate = 1
local g_bShow = 1


function HuaShanLunJian_Lounge_PreLoad()
	this:RegisterEvent("XBW_LOBBY_INFO")
	this:RegisterEvent("XBW_OPEN_LOUNGE_NORMAL")
	
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
	this:RegisterEvent("UI_COMMAND");
	
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function HuaShanLunJian_Lounge_OnLoad()
	g_HuaShanLunJian_Lounge_UnifiedPosition = HuaShanLunJian_Lounge_Frame:GetProperty("UnifiedPosition");

end

-- OnEvent
function HuaShanLunJian_Lounge_OnEvent(event)
	--
	if ( event == "XBW_LOBBY_INFO" ) then
		HuaShanLunJian_Lounge_Update()
		HuaShanLunJian_Lounge_Show()

	elseif ( event == "XBW_OPEN_LOUNGE_NORMAL" ) then
		g_bShow = 1
		HuaShanLunJian_Lounge_Show()
		
	elseif ( event == "HIDE_ON_SCENE_TRANSED" ) then
		HuaShanLunJian_Lounge_Reset()
		HuaShanLunJian_Lounge_Close()

	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 20200507 ) then
		g_bUpdate = 0

	elseif (event == "ADJEST_UI_POS" ) then
		HuaShanLunJian_Lounge_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		HuaShanLunJian_Lounge_ResetPos()
		
	end
end


function HuaShanLunJian_Lounge_Update( )
	if g_bUpdate == 0 then
		return
	end

	HuaShanLunJian_Lounge_SetTeamInfo( )
	HuaShanLunJian_Lounge_SetTimeInfo( )
end

function HuaShanLunJian_Lounge_SetTeamInfo( )
	local bHaveTeam = XBW:GetLobbyInfo("bHaveTeam")
	if bHaveTeam <= 0 then

		HuaShanLunJianFight_Lounge_Member02:SetText("#{HSLJ_190919_77}")
		HuaShanLunJianFight_Lounge_Level02:SetText("#{HSLJ_190919_77}")
		HuaShanLunJianFight_Lounge_Wait02:SetText("#{HSLJ_190919_77}")
		return
	end

	local teamNum = XBW:GetLobbyInfo("teamNum")

	if teamNum == 3 then
		HuaShanLunJianFight_Lounge_Member02:SetText("#{HSLJ_190919_76}")
	else
		HuaShanLunJianFight_Lounge_Member02:SetText("#{HSLJ_190919_77}")
	end

	local bMenPaiFit = XBW:GetLobbyInfo("bMenPaiFit")
	if bMenPaiFit == 1 then
		HuaShanLunJianFight_Lounge_Level02:SetText("#{HSLJ_190919_76}")
	else
		HuaShanLunJianFight_Lounge_Level02:SetText("#{HSLJ_190919_77}")
	end

	local bInLobby = XBW:GetLobbyInfo("bInLobby")
	if bInLobby == 1 then
		HuaShanLunJianFight_Lounge_Wait02:SetText("#{HSLJ_190919_76}")
	else
		HuaShanLunJianFight_Lounge_Wait02:SetText("#{HSLJ_190919_77}")
	end
end

function HuaShanLunJian_Lounge_SetTimeInfo( )
	local timeType = XBW:GetLobbyInfo("timeType")
	
	local nextMatchTime = XBW:GetLobbyInfo("nextMatchTime")
	local showHour = math.floor(nextMatchTime / 10000)
	local showMin = math.mod ( math.floor(nextMatchTime / 100), 100 )
	local add0Hour = string.format("%02d", showHour)
	local add0Min = string.format("%02d", showMin)
	
	local text = ScriptGlobal_Format("#{HSLJ_190919_327}", tostring(add0Hour), tostring(add0Min))
	
	-- //1-未开始 2-已开始 3-已结束
	if timeType == 1 then
		HuaShanLunJian_Lounge_Pair03:SetText(text)
		HuaShanLunJian_Lounge_Pair03:Show()
		HuaShanLunJian_Lounge_Pair05:Hide()
		
	elseif timeType == 2 then
		HuaShanLunJian_Lounge_Pair03:SetText(text)
		HuaShanLunJian_Lounge_Pair03:Show()
		HuaShanLunJian_Lounge_Pair05:Hide()
		
	elseif timeType == 3 then
		HuaShanLunJian_Lounge_Pair03:Hide()
		HuaShanLunJian_Lounge_Pair05:Show()
	end

	local nRound = XBW:GetLobbyInfo("round")
	local roundText = ScriptGlobal_Format("#{HSLJ_190919_80}", tostring(nRound))
	HuaShanLunJian_Lounge_Pair04:SetText(roundText)
		
	local dayWinCnt = XBW:GetLobbyInfo("dayWinCnt")
	local winText = ScriptGlobal_Format("#{HSLJ_190919_267}", tostring(dayWinCnt))
	HuaShanLunJian_Lounge_Pair07:SetText(winText)
end


function HuaShanLunJian_Lounge_Close()
	this:Hide()
end

function HuaShanLunJian_Lounge_Show()
	if g_bShow == 1 then
		this:Show()
	end
end

function HuaShanLunJian_Lounge_Reset()
	g_bUpdate = 1
	g_bShow = 1
end

function HuaShanLunJian_Lounge_ResetPos()
  HuaShanLunJian_Lounge_Frame:SetProperty("UnifiedPosition", g_HuaShanLunJian_Lounge_UnifiedPosition);
end


function HuaShanLunJian_Show_Mini()
	PushEvent( "XBW_OPEN_LOUNGE_MINI")
	
	g_bShow = 0
	HuaShanLunJian_Lounge_Close()
end
