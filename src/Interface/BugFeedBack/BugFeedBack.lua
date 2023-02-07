

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
	--条件检查
	--1 是否在可以提交bug的服务器（当前只有龙门客栈可以提交）
	local ret = DataPool:CheckCanSubmitBug();
	if(ret == false) then
		PushDebugMessage("#{BUGFK_100506_6}")
		this:Hide();
		return;
	end
	--2 反馈简介不少于5个字
	local str = tostring(BugFeedBack_SimpleEditbox:GetText());
	ret = string.len(str);
	if(ret < 10) then
		PushDebugMessage("#{BUGFK_100506_1}");
		return;
	end
	--3 详细描述不能为空
	str = tostring(BugFeedBack_DetailEditbox:GetText());
	ret = string.len(str)
	if(ret <= 0) then
		PushDebugMessage("#{BUGFK_100506_3}")
		return;
	end
	--4 检查本次上线 发送bug数量以及发送时间间隔是否合法
--~ 	ret = DataPool:GetBugFBcount();
--~ 	if( ret >= 5 ) then
--~ 		PushDebugMessage("#{BUGFK_100506_5}")
--~ 		return;
--~ 	end
	--5 两次发送间隔时间不能小于10秒
	ret = DataPool:CheckBugFBtime(10);
	if(ret == false) then
		PushDebugMessage("#{BUGFK_100506_4}")
		return;
	end

	--检查完毕 整理bug信息
	local simpletext = tostring(BugFeedBack_SimpleEditbox:GetText());	--反馈简介
	local detailtext = tostring(BugFeedBack_DetailEditbox:GetText());	--详细描述
	--将换行符替换为#r
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

	--发送bug信息
	DataPool:SendBugFB("title:"..simpletext.." detail:"..detailtext.." time:"..bugtime.." creater:"..bugcreater);

	--重置发送时间
	DataPool:ResetBugFBtime();
	--增加发送计数
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
