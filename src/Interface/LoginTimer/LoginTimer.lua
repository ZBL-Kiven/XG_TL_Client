--��¼���̵���ʱ

local timer = 60 * 9	--������¼��������10���ӣ�9����ʱ��ʼ��ʾ��ʾ��Ϣ

function LoginTimer_PreLoad()
	this:RegisterEvent("LOGIN_COUNTDOWN");
	this:RegisterEvent("LOGIN_COUNTDOWN_CLOSE");
end

function LoginTimer_OnLoad()
end

function LoginTimer_OnEvent(event)
	if event == "LOGIN_COUNTDOWN" then
		Login_Time_StopWatch:SetProperty("Timer", tostring(timer))
		Login_Timer_Frame:Hide()
		this:Show()
	elseif event == "LOGIN_COUNTDOWN_CLOSE" then
		Login_Time_StopWatch:SetProperty("Timer", tostring(0))
		Login_Timer_Frame:Hide()
		this:Hide()
	end
end

function LoginTimer_TimeOut()
	Login_Timer_Frame:Show()
end
