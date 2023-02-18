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
		
		--�г���+
		if nSafeType == 0 then
			Logon_FZKCheckFail_Info_Des:SetText("#{FZK_151230_3}");		--����+��ʾ����
			Logon_FZKCheckFail_Text:SetText("#{FZK_151230_4}");				--����+��֤��
			Logon_FZKCheckFail_Edit:SetText( "������6λ����" );
			Logon_FZKCheckFail_Edit:SetProperty("MaxTextLength", "20");
			Logon_FZKCheckFail_Get:Hide();
		end
		
		--���ֻ���֤
		if nSafeType == 1 then
			Logon_FZKCheckFail_Info_Des:SetText("#{FZK_151230_2}");		--�ֻ���֤��ʾ����
			Logon_FZKCheckFail_Text:SetText("#{FZK_151230_6}");				--�ֻ���֤��
			Logon_FZKCheckFail_Edit:SetText( "������6λ����" );
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
		local nRet = tonumber(arg0); --��֤�����0�ǳɹ�����0��ʧ��
		if nRet == 1 then
			PushEvent("GAMELOGIN_SHOW_SYSTEM_INFO", "#{FZK_151230_16}")	--�ڲ��������Ժ��ٽ��г���01
		elseif nRet == 2 then
			PushEvent("GAMELOGIN_SHOW_SYSTEM_INFO", "#{FZK_151230_17}")	--�ڲ��������Ժ��ٽ��г���02
		elseif nRet == 3 then
			PushEvent("GAMELOGIN_SHOW_SYSTEM_INFO", "#{FZK_151230_18}")	--�ڲ��������Ժ��ٽ��г���03
		elseif nRet == 4 then
			PushEvent("GAMELOGIN_SHOW_SYSTEM_INFO", "#{FZK_151230_19}")	--��֤����������½�����֤��
		elseif nRet == 5 then
			PushEvent("GAMELOGIN_SHOW_SYSTEM_INFO", "#{FZK_151230_20}")	--�ò�����Ҫ1���ӵ���ȴʱ�䣬���Ժ��ٽ��г��ԡ�
		elseif nRet == 6 then
			PushEvent("GAMELOGIN_SHOW_SYSTEM_INFO", "#{FZK_151230_21}")	--�ڲ��������Ժ��ٽ��г���04
		elseif nRet == 7 then
			PushEvent("GAMELOGIN_SHOW_SYSTEM_INFO", "#{FZK_151230_22}")	--�ڲ��������Ժ��ٽ��г���05
		elseif nRet == 8 then
			PushEvent("GAMELOGIN_SHOW_SYSTEM_INFO", "#{FZK_151230_23}")	--�ڲ��������Ժ��ٽ��г���06
		elseif nRet == 9 then
			PushEvent("GAMELOGIN_SHOW_SYSTEM_INFO", "#{FZK_151230_24}")	--�ڲ��������Ժ��ٽ��г���07
		end
		
		--������������Ҫ�ص�
		--Logon_FZKCheckFail_Close();
		
	elseif ( event == "UNDER_ASSIST_LOGIN_UNLOCK" ) then
		local nRet = tonumber(arg0); --��֤�����0�ǳɹ�����0��ʧ��
		if nRet == 0 then --���ܣ���ر�
			PushDebugMessage("#{FZK_151230_29}");
			Logon_FZKCheckFail_Close();
		elseif nRet == 1 then
			PushEvent("GAMELOGIN_SHOW_SYSTEM_INFO", "#{FZK_151230_16}")	--�ڲ��������Ժ��ٽ��г���01
		elseif nRet == 2 then
			PushEvent("GAMELOGIN_SHOW_SYSTEM_INFO", "#{FZK_151230_25}")	--�ڲ��������Ժ��ٽ��г���08
		elseif nRet == 3 then
			PushEvent("GAMELOGIN_SHOW_SYSTEM_INFO", "#{FZK_151230_26}")	--�ڲ��������Ժ��ٽ��г���09
		elseif nRet == 9 then
			PushEvent("GAMELOGIN_SHOW_SYSTEM_INFO", "#{FZK_151230_27}")	--�ڲ��������Ժ��ٽ��г���10
		end
	end	
	
end

function Logon_FZKCheckFail_GetCode()
	AccountSafe:SendRequestSafeCodeMsg();
	--KillTimer("Logon_FZKCheckFail_AutoCloseProc()");
	Logon_FZKCheckFail_TimeLeft:Hide();
	
	--60s����ʱ
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
	
	if g_SafeType == 0 then		--����+
		AccountSafe:SendLoginSafeCheckMsg( szCheckCode, 0 );
	elseif g_SafeType == 1 then	--�ֻ���֤
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

