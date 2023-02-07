--华山论剑 新比武大会
local g_HuaShanLunJian_LoungeMini_UnifiedPosition;

function HuaShanLunJian_LoungeMini_PreLoad()
	this:RegisterEvent("XBW_OPEN_LOUNGE_MINI")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
	
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function HuaShanLunJian_LoungeMini_OnLoad()
	g_HuaShanLunJian_LoungeMini_UnifiedPosition = HuaShanLunJian_LoungeMini_Frame:GetProperty("UnifiedPosition");

end

-- OnEvent
function HuaShanLunJian_LoungeMini_OnEvent(event)
	--
	if ( event == "XBW_OPEN_LOUNGE_MINI" ) then
		HuaShanLunJian_LoungeMini_Show()

	elseif ( event == "HIDE_ON_SCENE_TRANSED" ) then
		HuaShanLunJian_LoungeMini_Close()

	elseif (event == "ADJEST_UI_POS" ) then
		HuaShanLunJian_LoungeMini_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		HuaShanLunJian_LoungeMini_ResetPos()
		
	end
end


function HuaShanLunJian_LoungeMini_Show( )
	this:Show()
end


function HuaShanLunJian_LoungeMini_Close()
	this:Hide()
end


function HuaShanLunJian_LoungeMini_ResetPos()
  HuaShanLunJian_LoungeMini_Frame:SetProperty("UnifiedPosition", g_HuaShanLunJian_LoungeMini_UnifiedPosition);
end


function HuaShanLunJian_LoungeMini_OnShowNormalUI()
	PushEvent( "XBW_OPEN_LOUNGE_NORMAL")
	HuaShanLunJian_LoungeMini_Close()
end

