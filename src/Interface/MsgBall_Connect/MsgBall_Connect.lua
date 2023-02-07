

--预加载函数，可以而且只能在这里注册脚本关心的事件
function MsgBall_Connect_PreLoad()
	this:RegisterEvent("BAD_NET_STATUS");
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
end

--加载窗口的时候调用的函数，加载窗口时调用一次
function MsgBall_Connect_OnLoad()

end

--响应事件的函数，当注册的事件发生时会调用的函数
function MsgBall_Connect_OnEvent(event)
	if ( event == "BAD_NET_STATUS" ) then
		if this:IsVisible() then
			return;
		end
		this:Show();
	end
end

--以下是用户自定义的函数

function MsgBall_Connect_Action_Click()
	Open_Reconnect_Msg()
	this:Hide()
end