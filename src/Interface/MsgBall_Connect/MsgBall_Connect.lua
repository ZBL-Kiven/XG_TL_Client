

--Ԥ���غ��������Զ���ֻ��������ע��ű����ĵ��¼�
function MsgBall_Connect_PreLoad()
	this:RegisterEvent("BAD_NET_STATUS");
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
end

--���ش��ڵ�ʱ����õĺ��������ش���ʱ����һ��
function MsgBall_Connect_OnLoad()

end

--��Ӧ�¼��ĺ�������ע����¼�����ʱ����õĺ���
function MsgBall_Connect_OnEvent(event)
	if ( event == "BAD_NET_STATUS" ) then
		if this:IsVisible() then
			return;
		end
		this:Show();
	end
end

--�������û��Զ���ĺ���

function MsgBall_Connect_Action_Click()
	Open_Reconnect_Msg()
	this:Hide()
end