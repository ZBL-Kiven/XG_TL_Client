

--Ԥ���غ��������Զ���ֻ��������ע��ű����ĵ��¼�
function MsgBall_Connect_Msg_PreLoad()
	this:RegisterEvent("OPENT_MSG_RECONNECT");
end

--���ش��ڵ�ʱ����õĺ��������ش���ʱ����һ��
function MsgBall_Connect_Msg_OnLoad()

end

--��Ӧ�¼��ĺ�������ע����¼�����ʱ����õĺ���
function MsgBall_Connect_Msg_OnEvent(event)
	if ( event == "OPENT_MSG_RECONNECT" ) then
		this:Show();
	end
end

--�������û��Զ���ĺ���

function MsgBall_Connect_Msg_Bn1Click()
	this:Hide()
	Delay_Connect();
	DataPool:ReConnect()
end


function MsgBall_Connect_Msg_Bn2Click()
	this:Hide()
end

