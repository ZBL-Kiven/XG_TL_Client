
local MAIN_4_BUTTONS = {};
local MAIN_4_BUTTON_NUM = 10;

local MAIN_4_ANIMATES = {};
local MAIN_4_ANIMATE_NUM = 10;
local NeedUpdateAction = {}
local NeedUpdateActionNum = 0

function MainMenuBar_4_PreLoad()
	--变身系统增加
	this:RegisterEvent("SWITCH_MENU_BUTTON")
	this:RegisterEvent("SHOW_TRANSFIGURATION_SKILL");
end

function MainMenuBar_4_OnLoad()
	MAIN_4_BUTTONS[81] = MainMenuBar_4_Button_Action1
	MAIN_4_BUTTONS[82] = MainMenuBar_4_Button_Action2
	MAIN_4_BUTTONS[83] = MainMenuBar_4_Button_Action3
	MAIN_4_BUTTONS[84] = MainMenuBar_4_Button_Action4
	MAIN_4_BUTTONS[85] = MainMenuBar_4_Button_Action5
	MAIN_4_BUTTONS[86] = MainMenuBar_4_Button_Action6
	MAIN_4_BUTTONS[87] = MainMenuBar_4_Button_Action7
	MAIN_4_BUTTONS[88] = MainMenuBar_4_Button_Action8
	MAIN_4_BUTTONS[89] = MainMenuBar_4_Button_Action9
	MAIN_4_BUTTONS[90] = MainMenuBar_4_Button_Action10

	MAIN_4_ANIMATES[81] = MainMenuBar_4_Button_Action1_Mask
	MAIN_4_ANIMATES[82] = MainMenuBar_4_Button_Action2_Mask
	MAIN_4_ANIMATES[83] = MainMenuBar_4_Button_Action3_Mask
	MAIN_4_ANIMATES[84] = MainMenuBar_4_Button_Action4_Mask
	MAIN_4_ANIMATES[85] = MainMenuBar_4_Button_Action5_Mask
	MAIN_4_ANIMATES[86] = MainMenuBar_4_Button_Action6_Mask
	MAIN_4_ANIMATES[87] = MainMenuBar_4_Button_Action7_Mask
	MAIN_4_ANIMATES[88] = MainMenuBar_4_Button_Action8_Mask
	MAIN_4_ANIMATES[89] = MainMenuBar_4_Button_Action9_Mask
	MAIN_4_ANIMATES[90] = MainMenuBar_4_Button_Action10_Mask
end


-- OnEvent
function MainMenuBar_4_OnEvent(event)
	if ( event == "SHOW_TRANSFIGURATION_SKILL" ) then
		if arg0 == "1" then
			this:Hide();
			local count =Transfiguration:GetTransfigeActionItemCount();
			local canbeCancel = Transfiguration:TransfigeActionCanbeCancel()
			if canbeCancel == 1 then
				if(count <=1)then--至少有两个action才会显示这个窗口，因为一个为取消变身技能的ACTION
					--
				else
					local lastAction = count
					count = count - 1--最后一个固定在MAIN_4_BUTTONS[90]位置，为取消变身技能action
					if(count >= MAIN_4_BUTTON_NUM)then
						count = MAIN_4_BUTTON_NUM - 1
					end
					local idx = 1;
					for i=0,count-1 do
						local act = Transfiguration:EnumTransfigeAction(tonumber(i));
						if act and act:GetID() ~= 0 then
							MAIN_4_BUTTONS[idx + 80]:SetActionItem(act:GetID());
							idx = idx +1;
							if(idx>MAIN_4_BUTTON_NUM)then
								break;
							end
						end
					end
					if(idx>1)then
						this:Show()
						MainMenuBar_4_ShowItems(idx-1);
						MainMenuBar_4_PlayAnimate(idx-1);
						--MAIN_4_BUTTONS[90]位置特殊处理
						if lastAction > MAIN_4_BUTTON_NUM then
							lastAction = MAIN_4_BUTTON_NUM
						end
						local action = Transfiguration:EnumTransfigeAction(tonumber(lastAction) - 1);
						if action and action:GetID() ~= 0 then
							MAIN_4_BUTTONS[90]:SetActionItem(action:GetID());
							MAIN_4_BUTTONS[90]:Show()
							MAIN_4_BUTTONS[90]:Bright();
							MAIN_4_ANIMATES[90]:Show();
							MAIN_4_ANIMATES[90]:Play(true);
						end
						MainMenuBar_4_Frame:SetProperty("UnifiedPosition", "{{0.500000,-178.000000},{1.000000,-138.000000}}");
						PushEvent("SWITCH_MENU_BUTTON", tostring(3))
					end
					if (IsWindowShow("MainMenuBar_2")) ~= true then
						MainMenuBar_4_Frame:SetProperty("UnifiedPosition", "{{0.500000,-178.000000},{1.000000,-102.000000}}");
						PushEvent("SWITCH_MENU_BUTTON", tostring(4))
					end
				end
			else
				if(count <=0)then
					--
				else
					if(count > MAIN_4_BUTTON_NUM)then
						count = MAIN_4_BUTTON_NUM
					end
					local idx = 1;
					for i=0,count-1 do
						local act = Transfiguration:EnumTransfigeAction(tonumber(i));
						if act and act:GetID() ~= 0 then
							MAIN_4_BUTTONS[idx + 80]:SetActionItem(act:GetID());
							idx = idx +1;
							if(idx>MAIN_4_BUTTON_NUM)then
								break;
							end
						end
					end
					if(idx>1)then
						this:Show()
						MainMenuBar_4_ShowItems(idx-1);
						MainMenuBar_4_PlayAnimate(idx-1);
						MainMenuBar_4_Frame:SetProperty("UnifiedPosition", "{{0.500000,-178.000000},{1.000000,-138.000000}}");
						PushEvent("SWITCH_MENU_BUTTON", tostring(3))
					end
					if (IsWindowShow("MainMenuBar_2")) ~= true then
						MainMenuBar_4_Frame:SetProperty("UnifiedPosition", "{{0.500000,-178.000000},{1.000000,-102.000000}}");
						PushEvent("SWITCH_MENU_BUTTON", tostring(4))
					end
				end
			end
		else
			this:Hide()
			PushEvent("SWITCH_MENU_BUTTON", tostring(4))
		end
	elseif ( event == "SWITCH_MENU_BUTTON" ) then
		if (IsWindowShow("MainMenuBar_4")) == true then
			if arg0 == "1" then
				MainMenuBar_4_Frame:SetProperty("UnifiedPosition", "{{0.500000,-178.000000},{1.000000,-102.000000}}");
				PushEvent("SWITCH_MENU_BUTTON", tostring(4))
			elseif arg0 == "0" then
				MainMenuBar_4_Frame:SetProperty("UnifiedPosition", "{{0.500000,-178.000000},{1.000000,-138.000000}}");
				PushEvent("SWITCH_MENU_BUTTON", tostring(3))
			end
		end
	end
end


function MainMenuBar_4_Clicked(nIndex)
	if DataPool:IsCanDoAction() then
		MAIN_4_BUTTONS[nIndex]:DoAction();
	else
		PushDebugMessage("你不能这么做。")
		return;
	end
end

function MainMenuBar_4_PlayAnimate(idx)
	for j=1,idx do
		MAIN_4_ANIMATES[j+80]:Show();
		MAIN_4_ANIMATES[j+80]:Play(true);
	end
end

function MainMenuBar_4_ShowItems(idx)
	for j=1,MAIN_4_BUTTON_NUM do
		if(j<=idx)then
			MAIN_4_BUTTONS[j+80]:Show();
			MAIN_4_BUTTONS[j+80]:Bright();
		else
			MAIN_4_BUTTONS[j+80]:Hide();
		end
	end
end
