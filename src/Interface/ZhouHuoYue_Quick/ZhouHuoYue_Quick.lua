local g_Frame_UnifiedPosition


--=========
-- PreLoad()
--=========
function ZhouHuoYue_Quick_PreLoad()

	this:RegisterEvent("UI_COMMAND")--打开or刷新界面
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")	--进场景关闭界面
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("ZHOUHUOYUE_HOTPOINT")
	
end

--=========
-- OnLoad()
--=========
function ZhouHuoYue_Quick_OnLoad()

	g_Frame_UnifiedPosition = ZhouHuoYue_Quick_Frame:GetProperty("UnifiedPosition")
	

end

--=========
-- Event
--=========
function ZhouHuoYue_Quick_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0)== 80012101 ) then
		
		local isShowUI = Get_XParam_INT( 0 )
		if isShowUI == 1 then
			this:Show()
		else
			this:Hide()
		end
	
		local isShowHotPoint = Get_XParam_INT( 1 )
		if isShowHotPoint == 1 then
			ZhouHuoYue_Quick_tips:Show()
		else
			ZhouHuoYue_Quick_tips:Hide()
		end

	elseif event == "HIDE_ON_SCENE_TRANSED" then

	elseif event == "VIEW_RESOLUTION_CHANGED" then
	
		ZhouHuoYue_Quick_On_ResetPos()

	elseif event == "ADJEST_UI_POS" then

		ZhouHuoYue_Quick_On_ResetPos()
		
	elseif event == "ZHOUHUOYUE_HOTPOINT" then
	
		local nType = tonumber(arg0)
		if nType == 1 then
			ZhouHuoYue_Quick_tips:Show()
		else
			ZhouHuoYue_Quick_tips:Hide()
		end
		
	end

end

function ZhouHuoYue_Quick_Click()

	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("OpenUI");
		Set_XSCRIPT_ScriptID(800121);
		Set_XSCRIPT_ParamCount(0);
	Send_XSCRIPT();
	

end

--=========
-- 重置
--=========
function ZhouHuoYue_Quick_On_ResetPos()

	ZhouHuoYue_Quick_Frame:SetProperty("UnifiedPosition", g_Frame_UnifiedPosition)

end




