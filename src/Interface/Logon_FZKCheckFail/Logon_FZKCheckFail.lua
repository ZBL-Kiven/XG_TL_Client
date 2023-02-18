--Logon_FZKCheckFail.lua
--

local g_UnifiedPosition;
local g_ActionButton={};
local g_SafeType = -1;
local g_nPhoneLeftTime = 0;

function Logon_FZKCheckFail_PreLoad()
	this:RegisterEvent("UNDER_ASSIST_LOGIN");
	this:RegisterEvent("UNDER_ASSIST_LOGIN_RESULT");
	this:RegisterEvent("UNDER_ASSIST_LOGIN_UNLOCK");
end

function Logon_FZKCheckFail_OnLoad()
				
end

function Logon_FZKCheckFail_OnEvent(event)

	if ( event == "UNDER_ASSIST_LOGIN") then
		local nSafeType = tonumber(arg0); 
		
		--有畅游+
		if nSafeType == 0 then
			Logon_FZKCheckFail_Info_Des:SetText("#{FZK_151230_3}");		--畅游+提示文字
			Logon_FZKCheckFail_Text:SetText("#{FZK_151230_4}");				--畅游+验证码
			Logon_FZKCheckFail_Edit:SetText( "请输入6位数字" );
			Logon_FZKCheckFail_Edit:SetProperty("MaxTextLength", "20");
			Logon_FZKCheckFail_Get:Hide();
		end
		
		--有手机验证
		if nSafeType == 1 then
			Logon_FZKCheckFail_Info_Des:SetText("#{FZK_151230_2}");		--手机验证提示文字
			Logon_FZKCheckFail_Text:SetText("#{FZK_151230_6}");				--手机验证码
			Logon_FZKCheckFail_Edit:SetText( "请输入6位数字" );
			Logon_FZKCheckFail_Edit:SetProperty("MaxTextLength", "20");
			
			Logon_FZKCheckFail_Get:Enable();
			Logon_FZKCheckFail_Get:Show();
			Logon_FZKCheckFail_Get:SetText( "#{FZK_151230_11}" );
		end
		
		g_SafeType = nSafeType;
		OpenWindow( "SoftKeyBoard" );
		SetSoftKeyAim( "Logon_FZKCheckFail_Edit" );
		--SetTimer("Logon_FZKCheckFail","Logon_FZKCheckFail_AutoCloseProc()", 60000)
		Logon_FZKCheckFail_TimeLeft:SetProperty("Timer", "60")
		Logon_FZKCheckFail_TimeLeft:SetProperty("TextColor", "ffff0000")
		Logon_FZKCheckFail_TimeLeft:Show();
		this:Show();
	elseif ( event == "UNDER_ASSIST_LOGIN_RESULT" ) then
		local nRet = tonumber(arg0); --验证结果，0是成功，非0是失败
		if nRet == 1 then
			PushEvent("GAMELOGIN_SHOW_SYSTEM_INFO", "#{FZK_151230_16}")	--内部错误。请稍后再进行尝试01
		elseif nRet == 2 then
			PushEvent("GAMELOGIN_SHOW_SYSTEM_INFO", "#{FZK_151230_17}")	--内部错误。请稍后再进行尝试02
		elseif nRet == 3 then
			PushEvent("GAMELOGIN_SHOW_SYSTEM_INFO", "#{FZK_151230_18}")	--内部错误。请稍后再进行尝试03
		elseif nRet == 4 then
			PushEvent("GAMELOGIN_SHOW_SYSTEM_INFO", "#{FZK_151230_19}")	--验证码错误，请重新进行验证！
		elseif nRet == 5 then
			PushEvent("GAMELOGIN_SHOW_SYSTEM_INFO", "#{FZK_151230_20}")	--该操作需要1分钟的冷却时间，请稍后再进行尝试。
		elseif nRet == 6 then
			PushEvent("GAMELOGIN_SHOW_SYSTEM_INFO", "#{FZK_151230_21}")	--内部错误。请稍后再进行尝试04
		elseif nRet == 7 then
			PushEvent("GAMELOGIN_SHOW_SYSTEM_INFO", "#{FZK_151230_22}")	--内部错误。请稍后再进行尝试05
		elseif nRet == 8 then
			PushEvent("GAMELOGIN_SHOW_SYSTEM_INFO", "#{FZK_151230_23}")	--内部错误。请稍后再进行尝试06
		elseif nRet == 9 then
			PushEvent("GAMELOGIN_SHOW_SYSTEM_INFO", "#{FZK_151230_24}")	--内部错误。请稍后再进行尝试07
		end
		
		--无论怎样，都要关掉
		--Logon_FZKCheckFail_Close();
		
	elseif ( event == "UNDER_ASSIST_LOGIN_UNLOCK" ) then
		local nRet = tonumber(arg0); --验证结果，0是成功，非0是失败
		if nRet == 0 then --功能，则关闭
			PushDebugMessage("#{FZK_151230_29}");
			Logon_FZKCheckFail_Close();
		elseif nRet == 1 then
			PushEvent("GAMELOGIN_SHOW_SYSTEM_INFO", "#{FZK_151230_16}")	--内部错误。请稍后再进行尝试01
		elseif nRet == 2 then
			PushEvent("GAMELOGIN_SHOW_SYSTEM_INFO", "#{FZK_151230_25}")	--内部错误。请稍后再进行尝试08
		elseif nRet == 3 then
			PushEvent("GAMELOGIN_SHOW_SYSTEM_INFO", "#{FZK_151230_26}")	--内部错误。请稍后再进行尝试09
		elseif nRet == 9 then
			PushEvent("GAMELOGIN_SHOW_SYSTEM_INFO", "#{FZK_151230_27}")	--内部错误。请稍后再进行尝试10
		end
	end	
	
end

function Logon_FZKCheckFail_GetCode()
	AccountSafe:SendRequestSafeCodeMsg();
	--KillTimer("Logon_FZKCheckFail_AutoCloseProc()");
	Logon_FZKCheckFail_TimeLeft:Hide();
	
	--60s倒计时
	g_nPhoneLeftTime = 60;
	Logon_FZKCheckFail_Get:Disable();
	SetTimer("Logon_FZKCheckFail","Logon_FZKCheckFail_ShowCountDownProc()", 1000)
end

function Logon_FZKCheckFail_CheckCode()

	local szCheckCode = Logon_FZKCheckFail_Edit:GetText();
	local nCodeLen = string.len(szCheckCode);
	if ( nCodeLen ~= 6 ) then
		PushEvent("GAMELOGIN_SHOW_SYSTEM_INFO", "#{FZK_151230_8}")
		--Logon_FZKCheckFail_Close();
	end
	
	if g_SafeType == 0 then		--畅游+
		AccountSafe:SendLoginSafeCheckMsg( szCheckCode, 0 );
	elseif g_SafeType == 1 then	--手机认证
		AccountSafe:SendLoginSafeCheckMsg( szCheckCode, 1 );
	end
end

function Logon_FZKCheckFail_Close()
	GameProduceLogin:RefreshAccountDlg();
	--KillTimer("Logon_FZKCheckFail_AutoCloseProc()");
	KillTimer("Logon_FZKCheckFail_ShowCountDownProc()");
	this:Hide();
end

function Logon_FZKCheckFail_OnActive()
	local MaxLength = Logon_FZKCheckFail_Edit:GetProperty("MaxTextLength");
	if tonumber(MaxLength) > 6 then
		Logon_FZKCheckFail_Edit:SetText( "" );
		Logon_FZKCheckFail_Edit:SetProperty("MaxTextLength", "6");
	end
end

--function Logon_FZKCheckFail_AutoCloseProc()
--	PushEvent("GAMELOGIN_SHOW_SYSTEM_INFO", "#{DHYZ_140507_07}")
--	Logon_FZKCheckFail_Close();
--end

function Logon_FZKCheckFail_TimeReach()
	PushDebugMessage("#{FZK_151230_30}");
	Logon_FZKCheckFail_Close();
end

function Logon_FZKCheckFail_ShowCountDownProc()
	
	if g_nPhoneLeftTime <= 0 then
		--Logon_FZKCheckFail_Get:Enable();
		--Logon_FZKCheckFail_Get:SetText( "#{FZK_151230_11}" );
		--KillTimer("Logon_FZKCheckFail_ShowCountDownProc()");
		PushDebugMessage("#{FZK_151230_30}");
		Logon_FZKCheckFail_Close();
		return
	end
	
	g_nPhoneLeftTime = g_nPhoneLeftTime -1;
	Logon_FZKCheckFail_Get:SetText( tostring(g_nPhoneLeftTime) );
	
end

