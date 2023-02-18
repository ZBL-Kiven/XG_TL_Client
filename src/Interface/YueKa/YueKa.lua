local g_YueKa_Frame_UnifiedXPosition;
local g_YueKa_Frame_UnifiedYPosition;

function YueKa_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
	this:RegisterEvent("OBJECT_CARED_EVENT")
	this:RegisterEvent("PLAYER_LEAVE_WORLD")
end

function YueKa_OnEvent(event)
	if (event == "ADJEST_UI_POS") then
		YueKa_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		YueKa_ResetPos()
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		YueKa_Close()
	elseif event == "PLAYER_LEAVE_WORLD" then
		YueKa_Close()
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 2021040101) then
		if (IsWindowShow("YueKa") == false) then
			YueKa_OnShown()
		else
			YueKa_Close()
		end
	end
end

function YueKa_OnLoad()
	-- 保存界面的默认相对位置
	g_YueKa_Frame_UnifiedXPosition = YueKa_Frame:GetProperty("UnifiedXPosition");
	g_YueKa_Frame_UnifiedYPosition = YueKa_Frame:GetProperty("UnifiedYPosition");
end

function YueKa_OnShown()
	YueKa_Text1:SetText(Get_XParam_STR(0))
	YueKa_Text3:SetProperty("Timer", tostring(Get_XParam_STR(1)))
	this:Show();
end

--================================================
-- 界面的默认相对位置
--================================================
function YueKa_ResetPos()
	YueKa_Frame:SetProperty("UnifiedXPosition", g_YueKa_Frame_UnifiedXPosition);
	YueKa_Frame:SetProperty("UnifiedYPosition", g_YueKa_Frame_UnifiedYPosition);
end

function YueKa_Close()
	this:Hide();
end

function YueKa_Btn_Clicked(index)
	Clear_XSCRIPT()
	Set_XSCRIPT_Function_Name("XG_YueKa")
	Set_XSCRIPT_ScriptID(916527)
	Set_XSCRIPT_Parameter(0, index);                    -- 参数一
	Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
	if index ~= 1 and index ~= 5 then
		YueKa_Close()
	end
end