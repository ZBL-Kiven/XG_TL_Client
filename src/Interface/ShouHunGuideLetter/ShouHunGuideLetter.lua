local g_Frame_UnifiedPosition

--=========
-- PreLoad()
--=========
function ShouHunGuideLetter_PreLoad()

	this:RegisterEvent("UI_COMMAND",true)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)	--进场景关闭界面
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("ADJEST_UI_POS",false)

end

--=========
-- OnLoad()
--=========
function ShouHunGuideLetter_OnLoad()

	g_Frame_UnifiedPosition = ShouHunGuideLetter_Frame:GetProperty("UnifiedPosition")
	
end

--=========
-- Event
--=========
function ShouHunGuideLetter_OnEvent(event)

	if event == "UI_COMMAND" and tonumber(arg0) == 8930401 then

		local param = Get_XParam_INT(0)
		if param == 1 then
			--打开界面
			this:Show()
		elseif param == 2 then
			--自动寻路：找npc
			ShouHunGuideLetter_GoToFindNpc()
			--关闭界面
			ShouHunGuideLetter_OnHiden()			
		elseif param == 3 then
			--关闭界面
			ShouHunGuideLetter_OnHiden()
		elseif param == 4 then
			--打开珍兽界面
			PushEvent("TOGLE_PET_PAGE", -1)
		end

	elseif event == "HIDE_ON_SCENE_TRANSED" then

		ShouHunGuideLetter_OnHiden()

	elseif event == "VIEW_RESOLUTION_CHANGED" then

		ShouHunGuideLetter_ResetPos()

	elseif event == "ADJEST_UI_POS" then

		ShouHunGuideLetter_ResetPos()
	
	end

end

--点击：前往server判断，是否可以寻路找npc
function ShouHunGuideLetter_Clicked()

	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("OpenUI");
		Set_XSCRIPT_ScriptID(893040);
		Set_XSCRIPT_Parameter(0, 2);
		Set_XSCRIPT_ParamCount(1);
	Send_XSCRIPT();
	
end

--响应：通过server判断，可以寻路找npc
function ShouHunGuideLetter_GoToFindNpc()
	
	AutoRuntoTargetExWithName(265, 128, 2, "云飘飘")
	
end

--调整：界面位置
function ShouHunGuideLetter_ResetPos()

	ShouHunGuideLetter_Frame:SetProperty("UnifiedPosition", g_Frame_UnifiedPosition)

end

--关闭：界面
function ShouHunGuideLetter_OnHiden()
	this:Hide()
end

