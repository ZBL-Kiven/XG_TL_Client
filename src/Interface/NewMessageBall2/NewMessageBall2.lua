
--最多显示的效果数量
local g_BallIdx = -1;


function NewMessageBall2_PreLoad()
	this:RegisterEvent("MSG_BALL_UPDATE");
end

function NewMessageBall2_OnLoad()

end

function NewMessageBall2_OnEvent(event)

	if ( event == "MSG_BALL_UPDATE" ) then
		NewMsgBallUpadate2();
	end
end

function NewMsgBallUpadate2()		

		this:Show();
		
		local szIconName = ""
		local szToolTips = "";
		local szIndex	 = 0;
		local msgType	 = 0;
		local i = 0;
		local Rt = 0;

		local idx = 1;
		
		NewMessageBall22_Button_Action1_Mask:Hide();
		
		for i=0,3 do
			Rt, szIconName = MsgBall("GetStrAttrByIdx", i, "ICON");
			Rt, szToolTips = MsgBall("GetStrAttrByIdx", i, "TOOLTIP");
			Rt, szIndex    = MsgBall("GetNumAttrByIdx", i, "GUID");
			Rt, msgType    = MsgBall("GetTypeByIdx" , i);
			if Rt == 1  and msgType == 0 then
				NewMessageBall22_Button_Action1_Mask:SetProperty("Animate", szIconName)
				NewMessageBall22_Button_Action1_Mask:SetToolTip(szToolTips);
				NewMessageBall22_Button_Action1_Mask:Show();
				g_BallIdx = szIndex
			end
		end
end

function NewMessageBall22_Button_Action1_Mask_Click()
	MsgBall("OnEventByGuid", g_BallIdx);
end

