local g_Frame_UnifiedXPosition;
local g_Frame_UnifiedYPosition;
local g_OnlyChangyoujia_Logon_OnlineOrLogin = 1;		--1是Online，2是Login

function OnlyChangyoujia_Logon_PreLoad()

	this:RegisterEvent("OPEN_RECHECK_APPWARE_UI")
	this:RegisterEvent("OPEN_LOGIN_APPWARE_UI")
	this:RegisterEvent("OPEN_RECHECK_CLOSE_ALL_UI")
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("LOGIN_OVER_TIME");

end

function OnlyChangyoujia_Logon_OnLoad()
	-- 保存界面的默认相对位置
	g_Frame_UnifiedXPosition	= OnlyChangyoujia_Logon_Frame:GetProperty("UnifiedXPosition");
	g_Frame_UnifiedYPosition	= OnlyChangyoujia_Logon_Frame:GetProperty("UnifiedYPosition");
	OnlyChangyoujia_Logon_Clear()

end

function OnlyChangyoujia_Logon_OnEvent(event)

	if( event == "ADJEST_UI_POS" ) then
		OnlyChangyoujia_Logon_ResetPos()
	elseif( event == "VIEW_RESOLUTION_CHANGED") then
		OnlyChangyoujia_Logon_ResetPos()
	elseif ( event == "OPEN_RECHECK_APPWARE_UI") then	--已在线，验证畅游+
		OnlyChangyoujia_Logon_Clear()
		g_OnlyChangyoujia_Logon_OnlineOrLogin = 1;
		OnlyChangyoujia_Logon_Text:SetText("#{DHYZ_140507_01}");
		OnlyChangyoujia_Logon_ChangyoujiaBox:SetProperty("DefaultEditBox", "True");
		this:Show()
	elseif ( event == "OPEN_LOGIN_APPWARE_UI") then --登录时，验证畅游+
		PushEvent("GAMELOGIN_HIDEUI_LOGON");
		OnlyChangyoujia_Logon_Clear()
		OnlyChangyoujia_Logon_Text:SetText("#{DLLC_170814_27}");
		g_OnlyChangyoujia_Logon_OnlineOrLogin = 2;
		OnlyChangyoujia_Logon_ChangyoujiaBox:SetProperty("DefaultEditBox", "True");
		this:Show()
	elseif (event == "OPEN_RECHECK_CLOSE_ALL_UI" ) then
		this:Hide()
	elseif( event == "LOGIN_OVER_TIME" ) then
		this:Hide()
	end
end

function OnlyChangyoujia_Logon_OnAccepted()
	OnlyChangyoujia_Logon_CheckButton_Clicked()
end

function OnlyChangyoujia_Logon_Clear()
	OnlyChangyoujia_Logon_ChangyoujiaBox:SetText("")
end
--================================================
-- 恢复界面的默认相对位置
--================================================
function OnlyChangyoujia_Logon_ResetPos()
	OnlyChangyoujia_Logon_Frame:SetProperty("UnifiedXPosition", g_Frame_UnifiedXPosition);
	OnlyChangyoujia_Logon_Frame:SetProperty("UnifiedYPosition", g_Frame_UnifiedYPosition);
end

function OnlyChangyoujia_Logon_CheckButton_Clicked()
	local nReCheckStr = OnlyChangyoujia_Logon_ChangyoujiaBox:GetText()
	if ( nReCheckStr == nil or nReCheckStr == "" or string.len(nReCheckStr) ~= 6 )then
		PushDebugMessage("#{DLLC_171122_109}")
		--this:Hide()
		return
	end

	--调用客户端lua接口
	PushEvent("GAMELOGIN_SHOW_SYSTEM_INFO_NO_BUTTON", "#{DLLC_180306_137}")
	Lua_SendRecheckInfo(nReCheckStr, g_OnlyChangyoujia_Logon_OnlineOrLogin);
	this:Hide()
end

function OnlyChangyoujia_Logon_CloseButton_Clicked()
	ChangeToAccountInputDlgForReCheckMibao()
	this:Hide()
end


