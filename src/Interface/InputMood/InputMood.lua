
--===============================================
-- OnLoad
--===============================================
function InputMood_PreLoad()
	this:RegisterEvent("MOOD_SET");
end

function InputMood_OnLoad()
end

--===============================================
-- OnEvent
--===============================================
function InputMood_OnEvent(event)
	if ( event == "MOOD_SET" ) then
		InputMood_Input:SetText( "" );
		this:Show();
		InputMood_Input:SetProperty("DefaultEditBox", "True");
		InputMood_Input:SetText(DataPool:GetMood());
		InputMood_Input:SetSelected( 0, -1 );
	end
end

--��ʾ�Լ�������
function InputMood_ViewMood_Clicked()
	Friend:ViewFeel();
end

--�����밴ť
function InputMood_ViewMood_MouseEnter()
	InputMood_ViewMood:SetToolTip("�����������ͷ����ʾ/������������")
end
--===============================================
-- ȷ��
--===============================================
function InputMood_EventOK()
	local strMood = InputMood_Input:GetText();
	if( strMood == "" ) then 
		PushDebugMessage("���鲻��Ϊ��");
		return;
	end
	DataPool:SetMood( strMood );
	this:Hide();
end

--===============================================
-- ȡ��
--===============================================
function InputMood_EventCancel()
	this:Hide();
end

--===============================================
-- �ر��Զ�ִ��
--===============================================
function InputMood_OnHiden()
	InputMood_Input:SetProperty("DefaultEditBox", "False");
end