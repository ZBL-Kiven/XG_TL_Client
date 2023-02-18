--华山论剑 新比武大会

local g_HuaShanLunJian_SceneTrans_UnifiedPosition;
local g_TimerTick = -1
local g_MaxTime = 5 * 60


function HuaShanLunJian_SceneTrans_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
	
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function HuaShanLunJian_SceneTrans_OnLoad()
	g_HuaShanLunJian_SceneTrans_UnifiedPosition = HuaShanLunJian_SceneTrans_Frame:GetProperty("UnifiedPosition")
	
end

-- OnEvent
function HuaShanLunJian_SceneTrans_OnEvent(event)
	--
	if ( event == "UI_COMMAND" and tonumber(arg0) == 89289504 ) then 
		HuaShanLunJian_SceneTrans_Open()

	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 89289505 ) then 
		HuaShanLunJian_SceneTrans_Hide()
		
	elseif ( event == "HIDE_ON_SCENE_TRANSED" ) then
		HuaShanLunJian_SceneTrans_Hide()
		
	elseif (event == "ADJEST_UI_POS" ) then
		HuaShanLunJian_SceneTrans_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		HuaShanLunJian_SceneTrans_ResetPos()
	end
end


function HuaShanLunJian_SceneTrans_Open()
	local openType = Get_XParam_INT(0)
	if openType == 1 then
		HuaShanLunJian_SceneTrans_TargetScene:SetText("#{HSLJ_190919_298}")
	else
		HuaShanLunJian_SceneTrans_TargetScene:SetText("#{HSLJ_190919_299}")
	end
	
	g_TimerTick = g_MaxTime
	SetTimer("HuaShanLunJian_SceneTrans", "HuaShanLunJian_SceneTrans_Timer()", 1*1000)
	this:Show()
end


function HuaShanLunJian_SceneTrans_Hide()
	KillTimer("HuaShanLunJian_SceneTrans_Timer()")
	g_TimerTick = -1
	this:Hide()
end


function HuaShanLunJian_SceneTrans_ResetPos()
  HuaShanLunJian_SceneTrans_Frame:SetProperty("UnifiedPosition", g_HuaShanLunJian_SceneTrans_UnifiedPosition);
end


function HuaShanLunJian_SceneTrans_Timer()
	g_TimerTick = g_TimerTick - 1
	--PushDebugMessage(g_TimerTick)
	if g_TimerTick <= 0 then
		HuaShanLunJian_SceneTrans_Hide()
	end
end
