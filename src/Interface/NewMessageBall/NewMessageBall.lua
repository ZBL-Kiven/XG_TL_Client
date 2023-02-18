
--最多显示的效果数量
local MESSAGE_BALL_GUIDS = {0,0,0};
local MESSAGE_BALL_BUTTONS = {};

function NewMessageBall_PreLoad()
	this:RegisterEvent("MSG_BALL_UPDATE")
	this:RegisterEvent("SWITCH_MENU_BUTTON")
end

function NewMessageBall_OnLoad()

	MESSAGE_BALL_BUTTONS[1] = NewMessageBall_Button_Action1_Mask;
	MESSAGE_BALL_BUTTONS[2] = NewMessageBall_Button_Action2_Mask;
	MESSAGE_BALL_BUTTONS[3] = NewMessageBall_Button_Action3_Mask;
end

function NewMessageBall_OnEvent(event)

	if ( event == "MSG_BALL_UPDATE" ) then
		NewMsgBallUpadate();
	end
	
	if event == "SWITCH_MENU_BUTTON" then
		NewMessageBall_UpdatePos()
	end
end

function NewMsgBallUpadate()		

		this:Show();
		
		local szIconName = ""
		local szToolTips = "";
		local szIndex	 = 0;
		local msgType	= 0;
		local i = 0;
		local Rt = 0;

		local idx = 1;
		
		MESSAGE_BALL_BUTTONS[1]:Hide()
		MESSAGE_BALL_BUTTONS[2]:Hide()
		MESSAGE_BALL_BUTTONS[3]:Hide()

		for i=0,3 do
			Rt, szIconName = MsgBall("GetStrAttrByIdx", i, "ICON");
			Rt, szToolTips = MsgBall("GetStrAttrByIdx", i, "TOOLTIP");
			Rt, szIndex    = MsgBall("GetNumAttrByIdx", i, "GUID");
			Rt, msgType    = MsgBall("GetTypeByIdx" , i);
			if(Rt == 1 ) then
				if msgType > 0 and msgType < 4 then
					MESSAGE_BALL_BUTTONS[msgType]:SetProperty("Animate", szIconName)
					MESSAGE_BALL_BUTTONS[msgType]:SetToolTip(szToolTips);
					MESSAGE_BALL_BUTTONS[msgType]:Show();
					MESSAGE_BALL_GUIDS[msgType] = szIndex
				end
				
--				if msgType ~= 0  and idx < 4 then
--					MESSAGE_BALL_BUTTONS[idx]:SetProperty("Animate", szIconName)
--					MESSAGE_BALL_BUTTONS[idx]:SetToolTip(szToolTips);
--					MESSAGE_BALL_BUTTONS[idx]:Show();
--					MESSAGE_BALL_GUIDS[idx] = szIndex
--					idx = idx + 1
--				end
--			else
--				if idx < 4 then
--					MESSAGE_BALL_BUTTONS[idx]:Hide();
--					idx = idx + 1
--				end
			end

		end
end

function NewMessageBall_Button_Action1_Mask_Click()
	MsgBall("OnEventByGuid", MESSAGE_BALL_GUIDS[1]);
end

function NewMessageBall_Button_Action2_Mask_Click()
	MsgBall("OnEventByGuid", MESSAGE_BALL_GUIDS[2]);
end

function NewMessageBall_Button_Action3_Mask_Click()
	MsgBall("OnEventByGuid", MESSAGE_BALL_GUIDS[3]);
end

function NewMessageBall_UpdatePos()
	if IsWindowShow("MainMenuBar_4") == true then
		NewMessageBall_Frame:SetProperty("UnifiedPosition", "{{0.500000,-50.000000},{1.000000,-227.000000}}")
	elseif IsWindowShow("MainMenuBar_2") == true then
		NewMessageBall_Frame:SetProperty("UnifiedPosition", "{{0.500000,-50.000000},{1.000000,-175.000000}}")
	else
		NewMessageBall_Frame:SetProperty("UnifiedPosition", "{{0.500000,-50.000000},{1.000000,-147.000000}}")
	end
end