function HardwareNeedAdjust_PreLoad()
	this:RegisterEvent("OPEN_HEARDWARE_ADJUST_DLG");
end

function HardwareNeedAdjust_OnLoad()
end

-- OnEvent
function HardwareNeedAdjust_OnEvent(event)
	if (event == "OPEN_HEARDWARE_ADJUST_DLG") then
		HardwareNeedAdjust_InfoWindow:SetText("#{YJMB_090116_008}")
		this:Show()
	end
end

--ЭЌвт
function HardwareNeedAdjust_Bn2Click()
	if(Variable:GetVariable("System_CodePage") == "1258") then
		--do nothing
	else
		GameProduceLogin:OpenURL(GetWeblink("WEB_BINDPASSPOD"))
	end
	
	this:Hide()
end