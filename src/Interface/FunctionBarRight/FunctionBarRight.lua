
local RIGHTBAR_BUTTONS = {};
local RIGHTBAR_BUTTON_NUM = 9;

--////////////////////////////////技能冷却数字显示////////////////////////////////
	--Q1513260550 lll  此代码仅供预览、交流 请在24小时后 删除
--////////////////////////////////技能冷却数字显示////////////////////////////////


function FunctionBarRight_PreLoad()
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("CHANGE_BAR");
	this:RegisterEvent("ACTION_UPDATE");
	this:RegisterEvent("UI_COMMAND");
end

function FunctionBarRight_OnLoad()
	RIGHTBAR_BUTTONS[41] = FunctionBarRight_Button_Action1;
	RIGHTBAR_BUTTONS[42] = FunctionBarRight_Button_Action2;
	RIGHTBAR_BUTTONS[43] = FunctionBarRight_Button_Action3;
	RIGHTBAR_BUTTONS[44] = FunctionBarRight_Button_Action4;
	RIGHTBAR_BUTTONS[45] = FunctionBarRight_Button_Action5;
	RIGHTBAR_BUTTONS[46] = FunctionBarRight_Button_Action6;
	RIGHTBAR_BUTTONS[47] = FunctionBarRight_Button_Action7;
	RIGHTBAR_BUTTONS[48] = FunctionBarRight_Button_Action8;
	RIGHTBAR_BUTTONS[49] = FunctionBarRight_Button_Action9;
	
	
	MAINMENUBAR_CDTEXT[41] = FunctionBarRight_Action1CD;
	MAINMENUBAR_CDTEXT[42] = FunctionBarRight_Action2CD;
	MAINMENUBAR_CDTEXT[43] = FunctionBarRight_Action3CD;
	MAINMENUBAR_CDTEXT[44] = FunctionBarRight_Action4CD;
	MAINMENUBAR_CDTEXT[45] = FunctionBarRight_Action5CD;
	MAINMENUBAR_CDTEXT[46] = FunctionBarRight_Action6CD;
	MAINMENUBAR_CDTEXT[47] = FunctionBarRight_Action7CD;
	MAINMENUBAR_CDTEXT[48] = FunctionBarRight_Action8CD;
	MAINMENUBAR_CDTEXT[49] = FunctionBarRight_Action9CD;
end


-- OnEvent
function FunctionBarRight_OnEvent(event)
	if ( event == "PLAYER_ENTERING_WORLD" ) then
		this:Show();
		-- 显示经验
	elseif( event == "CHANGE_BAR" and arg0 == "main") then
		if( tonumber(arg1) > 40 and tonumber(arg1) <50 )  then
			--AxTrace(0,0,"arg1= ".. arg1 .. "arg2 =" .. arg2)
			local nIndex = tonumber(arg1) ;

			--AxTrace(0,0,"arg1= ".. arg1 .. "arg2 =" .. arg2)
			RIGHTBAR_BUTTONS[nIndex]:SetActionItem(tonumber(arg2));
			local nMainID = RIGHTBAR_BUTTONS[nIndex]:GetActionItem()
			local nSkillID = LifeAbility:GetLifeAbility_Number(tonumber(nMainID))			
			if IsSkillMark == 1 and nSkillID == 400 then
				local nSumSkill = GetActionNum("skill");
				for i=1, nSumSkill do
					local theAction = EnumAction(i-1, "skill");
					if theAction:GetDefineID() == 420 then
						RIGHTBAR_BUTTONS[nIndex]:SetActionItem(theAction:GetID());
						break
					end
				end
			elseif IsSkillMark == -1 and nSkillID == 420 then
				local nSumSkill = GetActionNum("skill");
				for i=1, nSumSkill do
					local theAction = EnumAction(i-1, "skill");
					if theAction:GetDefineID() == 400 then
						RIGHTBAR_BUTTONS[nIndex]:SetActionItem(theAction:GetID());
						break
					end
				end
			end
			FunctionBarRight_Init()
			FunctionBarRight_CoolDownReTime()		
			RIGHTBAR_BUTTONS[nIndex] : Bright();
			
			if arg3~=nil then
				
				local pet_num = tonumber(arg3);
				
				if pet_num >= 0 and pet_num < 6 then
					AxTrace(0,1,"nIndex="..nIndex .." pet_num="..pet_num)
					if Pet : IsPresent(pet_num) and Pet : GetIsFighting(pet_num) then
							RIGHTBAR_BUTTONS[nIndex] : Bright();
					else
							RIGHTBAR_BUTTONS[nIndex] : Gloom();
					end
						
				end
				
			end
			
		end
--////////////////////////////////技能冷却数字显示////////////////////////////////
	--Q1513260550 lll  此代码仅供预览、交流 请在24小时后 删除
--////////////////////////////////技能冷却数字显示////////////////////////////////
	elseif( event == "UI_COMMAND" and arg0 == "110220924") then
		MAINMENUBAR_SKILLCDSTR = tonumber(arg1)
		--关闭计时--清空所有数据
		if tonumber(arg1) == 0 then
			for i = 41,49 do
				MAINMENUBAR_CDTEXT[i]:Hide()
			end
		elseif tonumber(arg1) == 1 then	--开启计时
			FunctionBarRight_CoolDownReTime()
		end
	elseif( event == "UI_COMMAND" and arg0 == "20221005") then--列子御风特写回调
		local nIndex = -1
		local nType = Get_XParam_INT(0)
		--找寻技能所在技能栏位置
		for i = 41,49 do
			local nMainID = RIGHTBAR_BUTTONS[i]:GetActionItem()
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
					RIGHTBAR_BUTTONS[nIndex]:SetActionItem(theAction:GetID());
					IsSkillMark = 1
					MAINMENUBAR_COOLDOWN[420] = 30
					break
				end
				if theAction:GetDefineID() == 400 and nType == 2 then
					RIGHTBAR_BUTTONS[nIndex]:SetActionItem(theAction:GetID());
					IsSkillMark = 0
					MAINMENUBAR_COOLDOWN[420] = 0
					break
				end
			end
		end
		FunctionBarRight_CoolDownReTime()
	elseif( event == "UI_COMMAND" and arg0 == "120220924") then--上线刷新给计时
		SetTimer("FunctionBarRight","FunctionBarRight_CoolDownRe()", 1000)
		FunctionBarRight_Init()
		--Game回调  Q1513260550 lll  此代码仅供预览、交流 请在24小时后 删除
	elseif( event == "UI_COMMAND" and arg0 == "20220924") then
		local nSkillID = tonumber(arg2)
		local nCoolDown = tonumber(arg1)
		if nCoolDown ~= nil and nCoolDown > 0 and nSkillID ~= nil and nSkillID > 0 and nSkillID < 1024 then
			MAINMENUBAR_COOLDOWN[nSkillID] = math.floor(nCoolDown/1000)
			FunctionBarRight_CoolDownReTime()
		end
--////////////////////////////////技能冷却数字显示////////////////////////////////
	--Q1513260550 lll  此代码仅供预览、交流 请在24小时后 删除
--////////////////////////////////技能冷却数字显示////////////////////////////////	
	elseif( event == "ACTION_UPDATE" ) then
		FunctionBarRight_ActionUpdate();
	end
	
end
--////////////////////////////////技能冷却数字显示////////////////////////////////
	--Q1513260550 lll  此代码仅供预览、交流 请在24小时后 删除
--////////////////////////////////技能冷却数字显示////////////////////////////////
function FunctionBarRight_CoolDownReTime()
	for i = 41,49 do
		local nMainID = RIGHTBAR_BUTTONS[i]:GetActionItem()
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

function FunctionBarRight_Init()
	MAINMENUBAR_SKILLID = {}
	for i = 41,49 do
		local nMainID = RIGHTBAR_BUTTONS[i]:GetActionItem()
		local nSkillID = LifeAbility:GetLifeAbility_Number(tonumber(nMainID))
		if nSkillID ~= nil and nSkillID > 0 then
			MAINMENUBAR_SKILLID[nSkillID] = nSkillID
		end
	end
end

function FunctionBarRight_CoolDownRe()
	FunctionBarRight_Init()
	for i = 41,49 do
		local nMainID = RIGHTBAR_BUTTONS[i]:GetActionItem()
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

function FunctionBarRight_ActionUpdate()
	for j=1,9 do
		RIGHTBAR_BUTTONS[j+40]:SetNewFlash();
	end
end

function FunctionBarRight_Clicked(nIndex)
	if DataPool:IsCanDoAction() then
		
		RIGHTBAR_BUTTONS[nIndex]:DoAction();
	else
		PushDebugMessage("你不能这么做。")
		return;
	end
end