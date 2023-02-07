local PetSoulEffectSelfTipsX
local PetSoulEffectSelfTipsY

function PetSoulEffectSelfTips_PreLoad()

	this:RegisterEvent("UI_COMMAND")
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	
end

function PetSoulEffectSelfTips_OnLoad()
	PetSoulEffectSelfTipsX = PetSoulEffectSelfTips_Frame:GetProperty("UnifiedXPosition")
	PetSoulEffectSelfTipsY = PetSoulEffectSelfTips_Frame:GetProperty("UnifiedYPosition")
end

function PetSoulEffectSelfTips_OnEvent(event)

	if( event == "UI_COMMAND" ) and tonumber(arg0) == 201901201 then
		PetSoulEffectSelfTips_AdjustPosition(tonumber(arg1),tonumber(arg2),arg3)
		this:Show()
	end
	if( event == "UI_COMMAND" ) and tonumber(arg0) == 201901202 then
		this:Hide()
	end
    if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		this:Hide()
	end	
end

--自动设置Tips位置
function PetSoulEffectSelfTips_AdjustPosition(SetX,SetY,Tips)
	PetSoulEffectSelfTipsText:SetText(Tips)
	local nHeight = PetSoulEffectSelfTipsText:GetProperty("AbsoluteHeight");	
	nWindowHeight =  nHeight+10
	PetSoulEffectSelfTips_Frame:SetProperty("AbsoluteHeight",tostring(nWindowHeight));
	-- PushDebugMessage(SetY)
	PetSoulEffectSelfTips_Frame:SetProperty("AbsoluteYPosition",SetY);
	PetSoulEffectSelfTips_Frame:SetProperty("AbsoluteXPosition",SetX);
	PetSoulEffectSelfTipsX = PetSoulEffectSelfTips_Frame:GetProperty("UnifiedXPosition")
	PetSoulEffectSelfTipsY = PetSoulEffectSelfTips_Frame:GetProperty("UnifiedYPosition")	
end

-- g_PetSoulEffectTips