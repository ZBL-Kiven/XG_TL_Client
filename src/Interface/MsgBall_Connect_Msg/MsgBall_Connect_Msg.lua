

--预加载函数，可以而且只能在这里注册脚本关心的事件
function MsgBall_Connect_Msg_PreLoad()
	this:RegisterEvent("OPENT_MSG_RECONNECT");
end

--加载窗口的时候调用的函数，加载窗口时调用一次
function MsgBall_Connect_Msg_OnLoad()

end

--响应事件的函数，当注册的事件发生时会调用的函数
function MsgBall_Connect_Msg_OnEvent(event)
	if ( event == "OPENT_MSG_RECONNECT" ) then
		this:Show();
	end
end

--以下是用户自定义的函数

function MsgBall_Connect_Msg_Bn1Click()
	this:Hide()
	Delay_Connect();
	DataPool:ReConnect()
end


function MsgBall_Connect_Msg_Bn2Click()
	this:Hide()
end

