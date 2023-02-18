local g_Frame_UnifiedPosition

--=========
-- PreLoad()
--=========
function TalentGuideLetter_PreLoad()

	this:RegisterEvent("UI_COMMAND",true)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)	--�������رս���
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
			--�򿪽���
			this:Show()
		elseif param == 2 then
			--�Զ�Ѱ·����npc
			TalentGuideLetter_GoToFindNpc()
		elseif param == 3 then
			--�رս���
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

--�����ǰ��server�жϣ��Ƿ����Ѱ·��npc
function TalentGuideLetter_Clicked()

	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GotoFindNpc");
		Set_XSCRIPT_ScriptID(891218);
		--Set_XSCRIPT_Parameter(0, 2);
		Set_XSCRIPT_ParamCount(0);
	Send_XSCRIPT();
	
end

--��Ӧ��ͨ��server�жϣ�����Ѱ·��npc
function TalentGuideLetter_GoToFindNpc()
	
	AutoRuntoTargetExWithName(160, 157, 2, "����ʦ")
	
end

--����������λ��
function TalentGuideLetter_ResetPos()

	TalentGuideLetter_Frame:SetProperty("UnifiedPosition", g_Frame_UnifiedPosition)

end

--�رգ�����
function TalentGuideLetter_OnHiden()
	this:Hide()
end

