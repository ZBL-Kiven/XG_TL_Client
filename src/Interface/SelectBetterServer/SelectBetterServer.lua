--- 推荐服务器优化界面

local g_SelectBetterServer_Frame_UnifiedPosition

function SelectBetterServer_PreLoad()
	--排队发短信请求手机号
	this:RegisterEvent("GAMELOGIN_SHOW_QUEUEMSG_ASK_PHONE");
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	-- 关闭界面
	this:RegisterEvent("GAMELOGIN_CLOSE_COUNT_INPUT");
	this:RegisterEvent("GAMELOGIN_SHOW_SYSTEM_INFO_NO_BUTTON");
end

function SelectBetterServer_OnLoad()
	g_SelectBetterServer_Frame_UnifiedPosition = SelectBetterServer_Frame:GetProperty( "UnifiedPosition" )
end


function SelectBetterServer_OnEvent(event)
	if ( event == "GAMELOGIN_SHOW_QUEUEMSG_ASK_PHONE" ) then
		if( nil ~= arg0 ) then
			if(IsWindowShow("OtherQuest")) then
				return
			end
			SelectBetterServer_Sever:SetText(tostring(arg1))									
			SelectBetterServer_InfoWindow:SetText(tostring(arg0))
					
			this:Show()
		end
	elseif( event == "GAMELOGIN_SHOW_SYSTEM_INFO_NO_BUTTON") then
		SelectBetterServer_Closed();
	elseif( event == "GAMELOGIN_CLOSE_COUNT_INPUT" ) then
		SelectBetterServer_Closed()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		SelectBetterServer_On_ResetPos()
	end
end

function SelectBetterServer_QuitClick()
	GameProduceLogin:ReturnToAccountDlg();
	SelectBetterServer_Closed()
end

function SelectBetterServer_BetterServerOnClick()
	GameProduceLogin:ExitToSelectServer();
	SelectBetterServer_Closed()
end

function SelectBetterServer_On_ResetPos()
	SelectBetterServer_Frame:SetProperty("UnifiedPosition", g_SelectBetterServer_Frame_UnifiedPosition)
end

function SelectBetterServer_Closed()
	this:Hide();
end
