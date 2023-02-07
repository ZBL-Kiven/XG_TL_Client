

function ValentineConfirm_PreLoad()
	this:RegisterEvent("UI_COMMAND")
end

function ValentineConfirm_OnLoad()
	
end

function ValentineConfirm_OnEvent(event)
	if event == "UI_COMMAND" and tonumber(arg0) == 8910322 then
		if Get_XParam_INT(0) == 0 then
			this:Hide()
		else
			if not this:IsVisible() then
				this:Show()
			end
			local bPerfect = Get_XParam_INT(1)
			local t = ScriptGlobal_Format("#{YDSS_15018_148}", "#{YDSS_15018_102}" )
			if bPerfect and bPerfect == 1 then
				t = ScriptGlobal_Format("#{YDSS_15018_148}", "#{YDSS_15018_101}" )
			end
			ValentineConfirm_Text:SetText( t )
		end
	end
end

function ValentineConfirm_OnFinish()
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("OnUserConfirm");
		Set_XSCRIPT_ScriptID(891032);
		Set_XSCRIPT_Parameter(0,1)
		Set_XSCRIPT_ParamCount(1);
	Send_XSCRIPT();
end

function ValentineConfirm_OnRetry()
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("OnUserConfirm");
		Set_XSCRIPT_ScriptID(891032);
		Set_XSCRIPT_Parameter(0,0)
		Set_XSCRIPT_ParamCount(1);
	Send_XSCRIPT();
end
