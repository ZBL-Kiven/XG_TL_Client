
local MAIN_2_BUTTONS = {};
local MAIN_2_BUTTON_NUM = 20;

local MAIN_2_ANIMATES = {};
local MAIN_2_ANIMATE_NUM = 20;

--////////////////////////////////技能冷却数字显示////////////////////////////////
	--Q1513260550 lll  此代码仅供预览、交流 请在24小时后 删除
--////////////////////////////////技能冷却数字显示////////////////////////////////
local IsSkillMark = -1		--列子御风替换特写												

function MainMenuBar_2_PreLoad()
	this:RegisterEvent("OPEN_MENUBAR_2");
	this:RegisterEvent("CHANGE_BAR");
	this:RegisterEvent("CHAT_ADJUST_MOVE_CTL");
	this:RegisterEvent("ACTION_UPDATE");
	this:RegisterEvent("UNINSTALL_CHAT_ACTION_BAR2");
	this:RegisterEvent("CLEAR_CHAT_ACTION_BAR");
	this:RegisterEvent("UI_COMMAND");
end

function MainMenuBar_2_OnLoad()
	MAIN_2_BUTTONS[21] = MainMenuBar_2_Button_Action11
	MAIN_2_BUTTONS[22] = MainMenuBar_2_Button_Action12
	MAIN_2_BUTTONS[23] = MainMenuBar_2_Button_Action13
	MAIN_2_BUTTONS[24] = MainMenuBar_2_Button_Action14
	MAIN_2_BUTTONS[25] = MainMenuBar_2_Button_Action15
	MAIN_2_BUTTONS[26] = MainMenuBar_2_Button_Action16
	MAIN_2_BUTTONS[27] = MainMenuBar_2_Button_Action17
	MAIN_2_BUTTONS[28] = MainMenuBar_2_Button_Action18
	MAIN_2_BUTTONS[29] = MainMenuBar_2_Button_Action19
	MAIN_2_BUTTONS[30] = MainMenuBar_2_Button_Action20
	MAIN_2_BUTTONS[31] = MainMenuBar_2_Button_Action1
	MAIN_2_BUTTONS[32] = MainMenuBar_2_Button_Action2
	MAIN_2_BUTTONS[33] = MainMenuBar_2_Button_Action3
	MAIN_2_BUTTONS[34] = MainMenuBar_2_Button_Action4
	MAIN_2_BUTTONS[35] = MainMenuBar_2_Button_Action5
	MAIN_2_BUTTONS[36] = MainMenuBar_2_Button_Action6
	MAIN_2_BUTTONS[37] = MainMenuBar_2_Button_Action7
	MAIN_2_BUTTONS[38] = MainMenuBar_2_Button_Action8
	MAIN_2_BUTTONS[39] = MainMenuBar_2_Button_Action9
	MAIN_2_BUTTONS[40] = MainMenuBar_2_Button_Action10

	MAIN_2_ANIMATES[21] = MainMenuBar_2_Button_Action11_Mask
	MAIN_2_ANIMATES[22] = MainMenuBar_2_Button_Action12_Mask
	MAIN_2_ANIMATES[23] = MainMenuBar_2_Button_Action13_Mask
	MAIN_2_ANIMATES[24] = MainMenuBar_2_Button_Action14_Mask
	MAIN_2_ANIMATES[25] = MainMenuBar_2_Button_Action15_Mask
	MAIN_2_ANIMATES[26] = MainMenuBar_2_Button_Action16_Mask
	MAIN_2_ANIMATES[27] = MainMenuBar_2_Button_Action17_Mask
	MAIN_2_ANIMATES[28] = MainMenuBar_2_Button_Action18_Mask
	MAIN_2_ANIMATES[29] = MainMenuBar_2_Button_Action19_Mask
	MAIN_2_ANIMATES[30] = MainMenuBar_2_Button_Action20_Mask
	MAIN_2_ANIMATES[31] = MainMenuBar_2_Button_Action1_Mask
	MAIN_2_ANIMATES[32] = MainMenuBar_2_Button_Action2_Mask
	MAIN_2_ANIMATES[33] = MainMenuBar_2_Button_Action3_Mask
	MAIN_2_ANIMATES[34] = MainMenuBar_2_Button_Action4_Mask
	MAIN_2_ANIMATES[35] = MainMenuBar_2_Button_Action5_Mask
	MAIN_2_ANIMATES[36] = MainMenuBar_2_Button_Action6_Mask
	MAIN_2_ANIMATES[37] = MainMenuBar_2_Button_Action7_Mask
	MAIN_2_ANIMATES[38] = MainMenuBar_2_Button_Action8_Mask
	MAIN_2_ANIMATES[39] = MainMenuBar_2_Button_Action9_Mask
	MAIN_2_ANIMATES[40] = MainMenuBar_2_Button_Action10_Mask
	
	
	MAINMENUBAR_CDTEXT[21] = MainMenuBar_2_Action11CD
	MAINMENUBAR_CDTEXT[22] = MainMenuBar_2_Action12CD
	MAINMENUBAR_CDTEXT[23] = MainMenuBar_2_Action13CD
	MAINMENUBAR_CDTEXT[24] = MainMenuBar_2_Action14CD
	MAINMENUBAR_CDTEXT[25] = MainMenuBar_2_Action15CD
	MAINMENUBAR_CDTEXT[26] = MainMenuBar_2_Action16CD
	MAINMENUBAR_CDTEXT[27] = MainMenuBar_2_Action17CD
	MAINMENUBAR_CDTEXT[28] = MainMenuBar_2_Action18CD
	MAINMENUBAR_CDTEXT[29] = MainMenuBar_2_Action19CD
	MAINMENUBAR_CDTEXT[30] = MainMenuBar_2_Action20CD
	MAINMENUBAR_CDTEXT[31] = MainMenuBar_2_Action1CD
	MAINMENUBAR_CDTEXT[32] = MainMenuBar_2_Action2CD
	MAINMENUBAR_CDTEXT[33] = MainMenuBar_2_Action3CD
	MAINMENUBAR_CDTEXT[34] = MainMenuBar_2_Action4CD
	MAINMENUBAR_CDTEXT[35] = MainMenuBar_2_Action5CD
	MAINMENUBAR_CDTEXT[36] = MainMenuBar_2_Action6CD
	MAINMENUBAR_CDTEXT[37] = MainMenuBar_2_Action7CD
	MAINMENUBAR_CDTEXT[38] = MainMenuBar_2_Action8CD
	MAINMENUBAR_CDTEXT[39] = MainMenuBar_2_Action9CD
	MAINMENUBAR_CDTEXT[40] = MainMenuBar_2_Action10CD
	

end


-- OnEvent
function MainMenuBar_2_OnEvent(event)
	if ( event == "OPEN_MENUBAR_2" ) then
		
		AxTrace(0,0,"OPEN_MENUBAR_2" .. arg0)
			
		if arg0 == "1" then
			this:Show()
			MainMenuBar_2_PlayAnimate()
			PushEvent("UI_COMMAND",2020122201)
		else
			this:Hide()
			PushEvent("UI_COMMAND",2020122201)
		end
		-- 显示经验
	elseif( event == "CHANGE_BAR" and arg0 == "main") then
		
		AxTrace(0,0,"arg1 =" .. tostring(arg1))
	
		if( tonumber(arg1) >= 21 and tonumber(arg1) <41 )  then
			local nIndex = tonumber(arg1) ;

			MAIN_2_BUTTONS[nIndex]:SetActionItem(tonumber(arg2));
			MAIN_2_BUTTONS[nIndex]:Bright();
			--//////////////////////////////////////
			local nMainID = MAIN_2_BUTTONS[nIndex]:GetActionItem()
			local nSkillID = LifeAbility:GetLifeAbility_Number(tonumber(nMainID))			
			if IsSkillMark == 1 and nSkillID == 400 then
				local nSumSkill = GetActionNum("skill");
				for i=1, nSumSkill do
					local theAction = EnumAction(i-1, "skill");
					if theAction:GetDefineID() == 420 then
						MAIN_2_BUTTONS[nIndex]:SetActionItem(theAction:GetID());
						break
					end
				end
			elseif IsSkillMark == -1 and nSkillID == 420 then
				local nSumSkill = GetActionNum("skill");
				for i=1, nSumSkill do
					local theAction = EnumAction(i-1, "skill");
					if theAction:GetDefineID() == 400 then
						MAIN_2_BUTTONS[nIndex]:SetActionItem(theAction:GetID());
						break
					end
				end				
			end
			MainMenuBar_2_Init()
			MainMenuBar_2_CoolDownReTime()	
			--//////////////////////////////////////			
			if arg3~=nil then
				
				local pet_num = tonumber(arg3);
				
				if pet_num >= 0 and pet_num < 6 then
				
					AxTrace(0,1,"nIndex="..nIndex .." pet_num="..pet_num)
				
					if Pet : IsPresent(pet_num) and Pet : GetIsFighting(pet_num) then
							MAIN_2_BUTTONS[nIndex]:Bright();
					else
							MAIN_2_BUTTONS[nIndex]:Gloom();
					end
				end
			end
		end	
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 202209231) then
		for i = 21,30 do
			MAIN_2_BUTTONS[i]:Hide()
			MAIN_2_ANIMATES[i]:Hide()
		end
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 202209232) then
		for i = 21,30 do
			MAIN_2_BUTTONS[i]:Show()
			MAIN_2_ANIMATES[i]:Show()
		end
--////////////////////////////////技能冷却数字显示////////////////////////////////
	--Q1513260550 lll  此代码仅供预览、交流 请在24小时后 删除
--////////////////////////////////技能冷却数字显示////////////////////////////////
	elseif( event == "UI_COMMAND" and arg0 == "110220924") then
		MAINMENUBAR_SKILLCDSTR = tonumber(arg1)
		--关闭计时--清空所有数据
		if tonumber(arg1) == 0 then
			for i = 21,40 do
				MAINMENUBAR_CDTEXT[i]:Hide()
			end
		elseif tonumber(arg1) == 1 then	--开启计时
			MainMenuBar_2_CoolDownReTime()
		end
	elseif( event == "UI_COMMAND" and arg0 == "20221005") then--列子御风特写回调
		local nIndex = -1
		local nType = Get_XParam_INT(0)
		--找寻技能所在技能栏位置
		for i = 21,40 do
			local nMainID = MAIN_2_BUTTONS[i]:GetActionItem()
			local nSkillID = LifeAbility:GetLifeAbility_Number(tonumber(nMainID))
			if nSkillID == 400 then
				nIndex = i
				break
			end
			if nSkillID == 420 then
				nIndex = i
				break
			end
		end
		if nIndex ~= -1 then
			local nSumSkill = GetActionNum("skill");
			for i=1, nSumSkill do
				local theAction = EnumAction(i-1, "skill");
				if theAction:GetDefineID() == 420 and nType == 1 then
					MAIN_2_BUTTONS[nIndex]:SetActionItem(theAction:GetID());
					IsSkillMark = 1
					MAINMENUBAR_COOLDOWN[420] = 30
					break
				end
				if theAction:GetDefineID() == 400 and nType == 2 then
					MAIN_2_BUTTONS[nIndex]:SetActionItem(theAction:GetID());
					IsSkillMark = 0
					MAINMENUBAR_COOLDOWN[420] = 0
					break
				end
			end
		end
		MainMenuBar_2_CoolDownReTime()
	elseif( event == "UI_COMMAND" and arg0 == "120220924") then--上线刷新给计时
		SetTimer("MainMenuBar_2","MainMenuBar_2_CoolDownRe()", 1000)
		MainMenuBar_2_Init()
		--Game回调  Q1513260550 lll  此代码仅供预览、交流 请在24小时后 删除
	elseif( event == "UI_COMMAND" and arg0 == "20220924") then
		local nSkillID = tonumber(arg2)
		local nCoolDown = tonumber(arg1)
		if nCoolDown ~= nil and nCoolDown > 0 and nSkillID ~= nil and nSkillID > 0 and nSkillID < 1024 then
			MAINMENUBAR_COOLDOWN[nSkillID] = math.floor(nCoolDown/1000)
			MainMenuBar_2_CoolDownReTime()
		end
--////////////////////////////////技能冷却数字显示////////////////////////////////
	--Q1513260550 lll  此代码仅供预览、交流 请在24小时后 删除
--////////////////////////////////技能冷却数字显示////////////////////////////////		
	elseif (event == "CHAT_ADJUST_MOVE_CTL") then
		MainMenuBar_2_AdjustMoveCtl(arg0, arg1);
	elseif( event == "ACTION_UPDATE" ) then
		MainMenuBar_2_NewSkillStudy();
	end
	
end
--////////////////////////////////技能冷却数字显示////////////////////////////////
	--Q1513260550 lll  此代码仅供预览、交流 请在24小时后 删除
--////////////////////////////////技能冷却数字显示////////////////////////////////
function MainMenuBar_2_CoolDownReTime()
	for i = 21,40 do
		local nMainID = MAIN_2_BUTTONS[i]:GetActionItem()
		local nSkillID = LifeAbility:GetLifeAbility_Number(tonumber(nMainID))
		if nSkillID == nil then
			nSkillID = 0
		end
		local coolTime = MAINMENUBAR_COOLDOWN[nSkillID]
		if coolTime == nil or coolTime <= 0 then
			coolTime = 0
		end
		local Color = "#e010202#c12dfde"
		if nSkillID == 420 then
			Color = "#e010202#cccba85"
		end
		if coolTime >= 60 and nSkillID > 0 and MAINMENUBAR_SKILLCDSTR == 1 then
			MAINMENUBAR_CDTEXT[i]:Show()
			MAINMENUBAR_CDTEXT[i]:SetText(Color..tostring(math.floor(coolTime/60)).."m")		
			MAINMENUBAR_COOLDOWN[nSkillID] = coolTime
		elseif coolTime > 0 and coolTime < 60 and nSkillID > 0 and MAINMENUBAR_SKILLCDSTR == 1 then
			MAINMENUBAR_CDTEXT[i]:Show()	
			MAINMENUBAR_CDTEXT[i]:SetText(Color..tostring(coolTime))			
			MAINMENUBAR_COOLDOWN[nSkillID] = coolTime
		else
			MAINMENUBAR_CDTEXT[i]:Hide()
			MAINMENUBAR_CDTEXT[i]:SetText("")
		end
	end	
end

function MainMenuBar_2_Init()
	MAINMENUBAR_SKILLID = {}
	for i = 21,40 do
		local nMainID = MAIN_2_BUTTONS[i]:GetActionItem()
		local nSkillID = LifeAbility:GetLifeAbility_Number(tonumber(nMainID))
		if nSkillID ~= nil and nSkillID > 0 then
			MAINMENUBAR_SKILLID[nSkillID] = nSkillID
		end
	end
end

function MainMenuBar_2_CoolDownRe()
	MainMenuBar_2_Init()
	for i = 21,40 do
		local nMainID = MAIN_2_BUTTONS[i]:GetActionItem()
		local nSkillID = LifeAbility:GetLifeAbility_Number(tonumber(nMainID))		
		local TableData = MAINMENUBAR_SKILLID[nSkillID]
		if nSkillID ~= nil and nSkillID > 0 then
			local coolTime = MAINMENUBAR_COOLDOWN[nSkillID]
			--去除多余技能标记 - - 避免技能栏重复放同一个技能
			MAINMENUBAR_SKILLID[nSkillID] = nil
			if coolTime ~= nil and coolTime >= 0 and TableData ~= nil then
				coolTime = coolTime - 1
			end
			if coolTime == nil or coolTime < 0 then
				coolTime = 0
			end
			local Color = "#e010202#c12dfde"
			if nSkillID == 420 then
				Color = "#e010202#cccba85"
			end
			if coolTime >= 60 and nSkillID > 0 and MAINMENUBAR_SKILLCDSTR == 1 then
				MAINMENUBAR_CDTEXT[i]:Show()
				MAINMENUBAR_CDTEXT[i]:SetText(Color..tostring(math.floor(coolTime/60)).."m")		
				MAINMENUBAR_COOLDOWN[nSkillID] = coolTime
			elseif coolTime > 0 and coolTime < 60 and nSkillID > 0 and MAINMENUBAR_SKILLCDSTR == 1 then
				MAINMENUBAR_CDTEXT[i]:Show()	
				MAINMENUBAR_CDTEXT[i]:SetText(Color..tostring(coolTime))			
				MAINMENUBAR_COOLDOWN[nSkillID] = coolTime
			else
				MAINMENUBAR_COOLDOWN[nSkillID] = coolTime
				MAINMENUBAR_CDTEXT[i]:Hide()
				MAINMENUBAR_CDTEXT[i]:SetText("")
			end
		end
	end
end
--////////////////////////////////技能冷却数字显示////////////////////////////////
	--Q1513260550 lll  此代码仅供预览、交流 请在24小时后 删除
	-- //遗留问题  MAINMENUBAR_SKILLCDSTR 控制开关未完成
--////////////////////////////////技能冷却数字显示////////////////////////////////

function MainMenuBar_2_NewSkillStudy()
	for j=1,20 do
		MAIN_2_BUTTONS[j+20]:SetNewFlash();
	end
end

function MainMenuBar_2_Clicked(nIndex)
	if DataPool:IsCanDoAction() then
		MAIN_2_BUTTONS[nIndex]:DoAction();
	else
		PushDebugMessage("你不能这么做。")
		return;
	end
end

function MainMenuBar_2_AdjustMoveCtl( screenWidth, screenHeight )
	local currWidth = MainMenuBar_2_Frame:GetProperty("AbsoluteWidth");
	if(tonumber(screenWidth) < 1080) then
		MainMenuBar_2_Frame:SetProperty("UnifiedXPosition", "{0.5,-" .. tonumber(currWidth)/2 .. "}");
	else
		MainMenuBar_2_Frame:SetProperty("UnifiedXPosition", "{0.5,-" .. tonumber(currWidth)/2 .. "}"); --297+207
	end
end

function MainMenuBar_2_PlayAnimate()
	for j=1,20 do
		MAIN_2_ANIMATES[j+20]:Show();
		MAIN_2_ANIMATES[j+20]:Play(true);
	end
end