

--===============================================
-- OnLoad()
--===============================================
function BugFeedBack_PreLoad()

 	this:RegisterEvent("OPEN_BUGFEEDBACK");

end

function BugFeedBack_OnLoad()
end

--===============================================
-- OnEvent()
--===============================================
function BugFeedBack_OnEvent( event )

	if ( event == "OPEN_BUGFEEDBACK" ) then
		if(IsWindowShow("BugFeedBack")) then
			return;
		end

--~ 		local count = DataPool:GetBugFBcount();
--~ 		if( count >= 5 ) then
--~ 			PushDebugMessage("#{BUGFK_100506_5}")
--~ 			return;
--~ 		end

 		this:Show();
		BugFeedBack_Clear();
	end

end

function BugFeedBack_Submit()
	--�������
	--1 �Ƿ��ڿ����ύbug�ķ���������ǰֻ�����ſ�ջ�����ύ��
	local ret = DataPool:CheckCanSubmitBug();
	if(ret == false) then
		PushDebugMessage("#{BUGFK_100506_6}")
		this:Hide();
		return;
	end
	--2 ������鲻����5����
	local str = tostring(BugFeedBack_SimpleEditbox:GetText());
	ret = string.len(str);
	if(ret < 10) then
		PushDebugMessage("#{BUGFK_100506_1}");
		return;
	end
	--3 ��ϸ��������Ϊ��
	str = tostring(BugFeedBack_DetailEditbox:GetText());
	ret = string.len(str)
	if(ret <= 0) then
		PushDebugMessage("#{BUGFK_100506_3}")
		return;
	end
	--4 ��鱾������ ����bug�����Լ�����ʱ�����Ƿ�Ϸ�
--~ 	ret = DataPool:GetBugFBcount();
--~ 	if( ret >= 5 ) then
--~ 		PushDebugMessage("#{BUGFK_100506_5}")
--~ 		return;
--~ 	end
	--5 ���η��ͼ��ʱ�䲻��С��10��
	ret = DataPool:CheckBugFBtime(10);
	if(ret == false) then
		PushDebugMessage("#{BUGFK_100506_4}")
		return;
	end

	--������ ����bug��Ϣ
	local simpletext = tostring(BugFeedBack_SimpleEditbox:GetText());	--�������
	local detailtext = tostring(BugFeedBack_DetailEditbox:GetText());	--��ϸ����
	--�����з��滻Ϊ#r
	detailtext = string.gsub(detailtext, "\n", "#r");

	local bugtime = "";
	local bugcreater = "";

	if(BugFeedBack_Checktime1:GetCheck() == 1) then
		bugtime = tostring(os.date("%c"));
		--bugtime = "now";
	elseif(BugFeedBack_Checktime2:GetCheck() == 1) then
		bugtime = tostring(BugFeedBack_TimeEditbox:GetText());
	end

	if(BugFeedBack_Checkname1:GetCheck() == 1) then
		bugcreater = Player:GetName();
	elseif(BugFeedBack_Checkname2:GetCheck() == 1) then
		bugcreater = tostring(BugFeedBack_NameEditbox:GetText());
	end

	--����bug��Ϣ
	DataPool:SendBugFB("title:"..simpletext.." detail:"..detailtext.." time:"..bugtime.." creater:"..bugcreater);

	--���÷���ʱ��
	DataPool:ResetBugFBtime();
	--���ӷ��ͼ���
--~ 	ret = DataPool:GetBugFBcount();
--~ 	DataPool:SetBugFBcount(ret+1);
	this:Hide();
end


function BugFeedBack_OnHidden()

end


function BugFeedBack_Clear()
	BugFeedBack_SimpleEditbox:SetText("");
	BugFeedBack_DetailEditbox:SetText("");
	BugFeedBack_Check_Clicked(0);
end

function BugFeedBack_Check_Clicked(index)
	if(index == 1)   then
		BugFeedBack_Checktime1:SetCheck(1);
		BugFeedBack_Checktime2:SetCheck(0);
		BugFeedBack_TimeEditbox:Hide();
	end
	if(index == 2)   then
		BugFeedBack_Checktime2:SetCheck(1);
		BugFeedBack_Checktime1:SetCheck(0);
		BugFeedBack_TimeEditbox:SetText("");
		BugFeedBack_TimeEditbox:Show();
	end
	if(index == 3)   then
		BugFeedBack_Checkname1:SetCheck(1);
		BugFeedBack_Checkname2:SetCheck(0);
		BugFeedBack_NameEditbox:Hide();
	end
	if(index == 4)   then
		BugFeedBack_Checkname2:SetCheck(1);
		BugFeedBack_Checkname1:SetCheck(0);
		BugFeedBack_NameEditbox:SetText("");
		BugFeedBack_NameEditbox:Show();
	end
	if(index == 0)   then
		BugFeedBack_Checktime1:SetCheck(0);
		BugFeedBack_Checktime2:SetCheck(0);
		BugFeedBack_TimeEditbox:SetText("");
		BugFeedBack_TimeEditbox:Hide();

		BugFeedBack_Checkname1:SetCheck(0);
		BugFeedBack_Checkname2:SetCheck(0);
		BugFeedBack_NameEditbox:SetText("");
		BugFeedBack_NameEditbox:Hide();
	end
end
