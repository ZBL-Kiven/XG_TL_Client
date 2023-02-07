-- Q546528533 仅供娱乐交流，切勿他用 浏览后请尽快删除 切记切记！！
-- Q546528533 仅供娱乐交流，切勿他用 浏览后请尽快删除 切记切记！！
-- Q546528533 仅供娱乐交流，切勿他用 浏览后请尽快删除 切记切记！！
-- Q546528533 仅供娱乐交流，切勿他用 浏览后请尽快删除 切记切记！！
-- Q546528533 仅供娱乐交流，切勿他用 浏览后请尽快删除 切记切记！！
-- Q546528533 仅供娱乐交流，切勿他用 浏览后请尽快删除 切记切记！！
local AotuMainMAIN_3_BUTTONS = {};

local AotuMainMAIN_3_ANIMATES = {};

local AotuMainMAIN_3_HAVE = {}
function AotuMainMenuBar_PreLoad()
	this:RegisterEvent("CHANGE_BAR");
end 
 -- Q546528533 仅供娱乐交流，切勿他用 浏览后请尽快删除 切记切记！！

function AotuMainMenuBar_OnLoad()
	AotuMainMAIN_3_BUTTONS[1] = AotuMainMenuBar_Button_Action1
	AotuMainMAIN_3_BUTTONS[2] = AotuMainMenuBar_Button_Action2
	AotuMainMAIN_3_BUTTONS[3] = AotuMainMenuBar_Button_Action3
	AotuMainMAIN_3_BUTTONS[4] = AotuMainMenuBar_Button_Action4
	AotuMainMAIN_3_BUTTONS[5] = AotuMainMenuBar_Button_Action5
	AotuMainMAIN_3_BUTTONS[6] = AotuMainMenuBar_Button_Action6
	AotuMainMAIN_3_BUTTONS[7] = AotuMainMenuBar_Button_Action7
	AotuMainMAIN_3_BUTTONS[8] = AotuMainMenuBar_Button_Action8
	AotuMainMAIN_3_BUTTONS[9] = AotuMainMenuBar_Button_Action9
	
	AotuMainMAIN_3_ANIMATES[1] = AotuMainMenuBar_Button_Action1_Mask
	AotuMainMAIN_3_ANIMATES[2] = AotuMainMenuBar_Button_Action2_Mask
	AotuMainMAIN_3_ANIMATES[3] = AotuMainMenuBar_Button_Action3_Mask
	AotuMainMAIN_3_ANIMATES[4] = AotuMainMenuBar_Button_Action4_Mask
	AotuMainMAIN_3_ANIMATES[5] = AotuMainMenuBar_Button_Action5_Mask
	AotuMainMAIN_3_ANIMATES[6] = AotuMainMenuBar_Button_Action6_Mask
	AotuMainMAIN_3_ANIMATES[7] = AotuMainMenuBar_Button_Action7_Mask
	AotuMainMAIN_3_ANIMATES[8] = AotuMainMenuBar_Button_Action8_Mask
	AotuMainMAIN_3_ANIMATES[9] = AotuMainMenuBar_Button_Action9_Mask
end 
 -- Q546528533 仅供娱乐交流，切勿他用 浏览后请尽快删除 切记切记！！

-- OnEvent
function AotuMainMenuBar_OnEvent(event)
	if event == "CHANGE_BAR" and arg0 == "main" then
		this:Show()
		local strCharName =  Player:GetData("LEVEL")
		if strCharName == "" or strCharName == nil then
			return
		end
		if strCharName == 0 then
			return
		end
		for i = 1,9 do
			local nMainID = AotuMainMAIN_3_BUTTONS[i]:GetActionItem()
			local nSkillID = LifeAbility:GetLifeAbility_Number(tonumber(nMainID))	
			if tonumber(nSkillID) ~= nil and tonumber(nSkillID) >= 0 then
				return
			end
		end
		--技能填入
		local skilldata = AutoMainMenuBar_GetSkillID()
		-- PushDebugMessage(tostring(skilldata[1]))
		local sumskill = GetActionNum("skill")
		local idx = 1
		for i=1, sumskill do
			local skillaction = EnumAction(i-1, "skill")
			local actionid = skillaction:GetID()
			local skillid = skillaction:GetDefineID()
			for i, v in ipairs(skilldata) do
				if skillid == v then
					AotuMainMAIN_3_BUTTONS[idx]:SetActionItem(actionid)
					AotuMainMAIN_3_HAVE[idx] = 1
					idx = idx + 1
				end 
 -- Q546528533 仅供娱乐交流，切勿他用 浏览后请尽快删除 切记切记！！
			end 
 -- Q546528533 仅供娱乐交流，切勿他用 浏览后请尽快删除 切记切记！！
		end 
 -- Q546528533 仅供娱乐交流，切勿他用 浏览后请尽快删除 切记切记！！
	end 
 -- Q546528533 仅供娱乐交流，切勿他用 浏览后请尽快删除 切记切记！！
end 
 -- Q546528533 仅供娱乐交流，切勿他用 浏览后请尽快删除 切记切记！！

function AotuMainMenuBar_Clicked(nIndex)
	if AotuMainMAIN_3_HAVE[nIndex] == 1 then
		if DataPool:IsCanDoAction() then
			AotuMainMAIN_3_BUTTONS[nIndex]:DoAction();
		end 
	end
 -- Q546528533 仅供娱乐交流，切勿他用 浏览后请尽快删除 切记切记！！
end 
 -- Q546528533 仅供娱乐交流，切勿他用 浏览后请尽快删除 切记切记！！

function AutoMainMenuBar_GetSkillID()
	local nSkillTab = {{160,480,0},{161,0,0},{162,0,0},{170,0,0},{174,0,0},{187,483,1},{188,0,1},{189,0,1},{197,0,1},{201,0,1},{213,481,2},{214,0,2},{215,0,2},{219,0,2},{223,0,2},{227,0,2},{236,0,2},{234,0,2},{235,0,2},{239,0,3},{240,0,3},{241,0,3},{242,0,3},{245,0,3},{249,0,3},{253,0,3},{260,0,3},{262,0,3},{265,0,4},{267,0,4},{268,0,4},{279,0,4},{287,0,4},{270,0,4},{271,0,4},{286,0,4},{291,0,5},{292,0,5},{293,0,5},{297,0,5},{301,0,5},{305,0,5},{312,0,5},{314,0,5},{317,0,6},{318,0,6},{319,0,6},{327,0,6},{331,0,6},{338,0,6},{339,0,6},{343,482,7},{344,0,7},{345,0,7},{350,0,7},{353,0,7},{357,0,7},{359,0,7},{365,0,7},{370,0,8},{372,0,8},{382,0,8},{384,0,8},{391,0,8},{392,0,8},{393,0,8},{696,0,-1},{697,0,-1},{686,0,-1},{687,0,-1},{396,0,10},{397,0,10},{399,0,10},{405,0,10},{407,0,10},{411,0,10},{418,0,10}}
	local strCharMenPai =  Player:GetData("MEMPAI")
	local nIndex = 0
	local nSelfSkill = {}
	for i = 1,table.getn(nSkillTab) do
		if nSkillTab[i][3] == strCharMenPai then
			if nIndex > 8 then
				break
			end
			nIndex = nIndex + 1
			nSelfSkill[nIndex] = nSkillTab[i][1]
		end
	end
	return nSelfSkill
end