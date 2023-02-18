local g_Frame_UnifiedPosition

--=========
-- PreLoad()
--=========
function TalentGuideLetter_PreLoad()

	this:RegisterEvent("UI_COMMAND",true)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)	--进场景关闭界面
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("ADJEST_UI_POS",false)

end

--=========
-- OnLoad()
--=========
function TalentGuideLetter_OnLoad()

	g_Frame_UnifiedPosition = TalentGuideLetter_Frame:GetProperty("UnifiedPosition")
	
end

--=========
-- Event
--=========
function TalentGuideLetter_OnEvent(event)

	if event == "UI_COMMAND" and tonumber(arg0) == 89121801 then

		local param = Get_XParam_INT(0)
		if param == 1 then
			--打开界面
			this:Show()
		elseif param == 2 then
			--自动寻路：找npc
			TalentGuideLetter_GoToFindNpc()
		elseif param == 3 then
			--关闭界面
			TalentGuideLetter_OnHiden()
		end

	elseif event == "HIDE_ON_SCENE_TRANSED" then

		TalentGuideLetter_OnHiden()

	elseif event == "VIEW_RESOLUTION_CHANGED" then

		TalentGuideLetter_ResetPos()

	elseif event == "ADJEST_UI_POS" then

		TalentGuideLetter_ResetPos()
	
	end

end

--点击：前往server判断，是否可以寻路找npc
function TalentGuideLetter_Clicked()

	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GotoFindNpc");
		Set_XSCRIPT_ScriptID(891218);
		--Set_XSCRIPT_Parameter(0, 2);
		Set_XSCRIPT_ParamCount(0);
	Send_XSCRIPT();
	
end

--响应：通过server判断，可以寻路找npc
function TalentGuideLetter_GoToFindNpc()
	
	AutoRuntoTargetExWithName(160, 157, 2, "赵天师")
	
end

--调整：界面位置
function TalentGuideLetter_ResetPos()

	TalentGuideLetter_Frame:SetProperty("UnifiedPosition", g_Frame_UnifiedPosition)

end

--关闭：界面
function TalentGuideLetter_OnHiden()
	this:Hide()
end

