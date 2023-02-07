local g_Frame_UnifiedPosition

--=========
-- PreLoad()
--=========
function ShouHunGuideLetter_PreLoad()

	this:RegisterEvent("UI_COMMAND",true)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)	--�������رս���
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
			--�򿪽���
			this:Show()
		elseif param == 2 then
			--�Զ�Ѱ·����npc
			ShouHunGuideLetter_GoToFindNpc()
			--�رս���
			ShouHunGuideLetter_OnHiden()			
		elseif param == 3 then
			--�رս���
			ShouHunGuideLetter_OnHiden()
		elseif param == 4 then
			--�����޽���
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

--�����ǰ��server�жϣ��Ƿ����Ѱ·��npc
function ShouHunGuideLetter_Clicked()

	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("OpenUI");
		Set_XSCRIPT_ScriptID(893040);
		Set_XSCRIPT_Parameter(0, 2);
		Set_XSCRIPT_ParamCount(1);
	Send_XSCRIPT();
	
end

--��Ӧ��ͨ��server�жϣ�����Ѱ·��npc
function ShouHunGuideLetter_GoToFindNpc()
	
	AutoRuntoTargetExWithName(265, 128, 2, "��ƮƮ")
	
end

--����������λ��
function ShouHunGuideLetter_ResetPos()

	ShouHunGuideLetter_Frame:SetProperty("UnifiedPosition", g_Frame_UnifiedPosition)

end

--�رգ�����
function ShouHunGuideLetter_OnHiden()
	this:Hide()
end

