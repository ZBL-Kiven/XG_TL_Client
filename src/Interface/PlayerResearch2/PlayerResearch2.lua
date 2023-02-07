
--===============================================
-- OnLoad()
--===============================================
function PlayerResearch2_PreLoad()
	this:RegisterEvent("UI_COMMAND")
end

function PlayerResearch2_OnLoad()

end

--===============================================
-- OnEvent()
--===============================================
function PlayerResearch2_OnEvent( event )
	
	if(event == "UI_COMMAND" and tonumber(arg0) == 89268901) then
		local bShow = Get_XParam_INT(0);
		if bShow == 1 then
			this:Show();
		else
			this:Hide()
		end
	end

end

--===============================================
-- Bn2Click()
--===============================================
function PlayerResearch2_ResearchButton_Click()
	--发给服务器
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("AfterOpenUrl")
		Set_XSCRIPT_ScriptID(892689)
		Set_XSCRIPT_ParamCount(0)
	Send_XSCRIPT();

	GameProduceLogin:OpenURL(GetWeblink("WEB_DCWJ"))
	this:Hide()
end








