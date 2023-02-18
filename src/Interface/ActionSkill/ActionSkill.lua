local Current_Xinfa_Name,Current_Xinfa_Level;

local Current_Xinfa = 1;
local Current_Skill = -1;
local Current_Nuqi = -1;

--local XINFA_LEVEL = {};
local XINFA_INDEX = {};
local XINFA_BUTTONS_NUM = 8;
local XINFA_BUTTONS = {};

local SKILL_INDEX = {};
local SKILL_BUTTONS_NUM = 5;
local SKILL_BUTTONS = {};

--local NUQI_INDEX = {};
--local NUQI_BUTTONS_NUM = 3;
--local NUQI_BUTTONS = {};

--���������Ա�
local MenPai_MainAttr = {
[1] = {image = "set:UIIcons image:Ice_Repellency_Normal", Tooltip = "MPZSX_20071221_11" },
[2] = {image = "set:UIIcons image:Fire_Repellency_Normal", Tooltip = "MPZSX_20071221_12" },
[3] = {image = "set:UIIcons image:Thunder_Repellency_Normal", Tooltip = "MPZSX_20071221_13" },
[4] = {image = "set:UIIcons image:Poison_Repellency_Normal", Tooltip = "MPZSX_20071221_14" } };

local MenPai_UsedAttr = {
[0] = {image = "set:Menpaishuxing image:Shuxing_Dark", Tooltip = "MPZSX_20071221_13", },			--����
[1] = {image = "set:Menpaishuxing image:Shuxing_Fire", Tooltip = "MPZSX_20071221_12",},			--����
[2] = {image = "set:Menpaishuxing image:Shuxing_PoisonFire", Tooltip = "MPZSX_20071221_15",},		--ؤ��
[3] = {image = "set:Menpaishuxing image:Shuxing_DarkIce", Tooltip = "MPZSX_20071221_16",},		--�䵱
[4] = {image = "set:Menpaishuxing image:Shuxing_IceDark", Tooltip = "MPZSX_20071221_17",},		--��ü
[5] = {image = "set:Menpaishuxing image:Shuxing_Poison", Tooltip = "MPZSX_20071221_14",},			--����
[6] = {image = "set:Menpaishuxing image:Shuxing_FIPD", Tooltip = "MPZSX_20071221_18",}, --����
[7] = {image = "set:Menpaishuxing image:Shuxing_Ice", Tooltip = "MPZSX_20071221_11",},			--��ɽ
[8] = {image = "set:Menpaishuxing image:Shuxing_FirePoison", Tooltip = "MPZSX_20071221_19",},		--��ң
[9] = {image = "", Tooltip = "������",},	--������
[10]= {image = "set:CommonFrame38 image:Shuxing_ManTuoDarkPoison", Tooltip = "MPZSX_20071221_20", },			--mtsz
};



function ActionSkill_PreLoad()
	this:RegisterEvent("TOGLE_SKILL_BOOK");
	this:RegisterEvent("TOGLE_COMMONSKILL_PAGE");
	this:RegisterEvent("TOGLE_LIFE_PAGE");
	this:RegisterEvent("SKILL_UPDATE");
	this:RegisterEvent("CLOSE_SKILL_BOOK");
	this:RegisterEvent("JOIN_NEW_MENPAI");
end

function ActionSkill_OnLoad()
	XINFA_BUTTONS[1] = ActionSkill_Xinfa1;
	XINFA_BUTTONS[2] = ActionSkill_Xinfa2;
	XINFA_BUTTONS[3] = ActionSkill_Xinfa3;
	XINFA_BUTTONS[4] = ActionSkill_Xinfa4;
	XINFA_BUTTONS[5] = ActionSkill_Xinfa5;
	XINFA_BUTTONS[6] = ActionSkill_Xinfa6;
	XINFA_BUTTONS[7] = ActionSkill_Xinfa7;
	XINFA_BUTTONS[8] = ActionSkill_Xinfa8;

	SKILL_BUTTONS[1] = ActionSkill_Zhaoshi1;
	SKILL_BUTTONS[2] = ActionSkill_Zhaoshi2;
	SKILL_BUTTONS[3] = ActionSkill_Zhaoshi3;
	SKILL_BUTTONS[4] = ActionSkill_Zhaoshi4;
	SKILL_BUTTONS[5] = ActionSkill_Zhaoshi5;

--	NUQI_BUTTONS[1] = ActionSkill_Nuqi1;
--	NUQI_BUTTONS[2] = ActionSkill_Nuqi2;
--	NUQI_BUTTONS[3] = ActionSkill_Nuqi3;

--	XINFA_LEVEL[1] = ActionSkill_Xinfa1_Level;
--	XINFA_LEVEL[2] = ActionSkill_Xinfa2_Level;
--	XINFA_LEVEL[3] = ActionSkill_Xinfa3_Level;
--	XINFA_LEVEL[4] = ActionSkill_Xinfa4_Level;
--	XINFA_LEVEL[5] = ActionSkill_Xinfa5_Level;
--	XINFA_LEVEL[6] = ActionSkill_Xinfa6_Level;
	ActionSkill_SetTabColor();
end
-- OnEvent
function ActionSkill_OnEvent(event)

	if ( event == "TOGLE_SKILL_BOOK" ) then
			local selfUnionPos = Variable:GetVariable("SkillUnionPos");
			if(selfUnionPos ~= nil) then
				ActionSkill_Frame:SetProperty("UnifiedPosition", selfUnionPos);
			end
			ActionSkill_Open();
			ActionSkill_Update();
	elseif( event == "SKILL_UPDATE" and this:IsVisible()) then
		ActionSkill_Update();
	elseif ( event == "TOGLE_LIFE_PAGE" ) then
		ActionSkill_Close();
	elseif ( event == "TOGLE_COMMONSKILL_PAGE" ) then
		ActionSkill_Close();
	elseif ( event == "CLOSE_SKILL_BOOK" ) then
		ActionSkill_Close();
	elseif( event == "ACTION_UPDATE" ) then
		ActionSkill_NewSkillStudy();
	end
end
--ѧ�����¼�����
function ActionSkill_NewSkillStudy()
	for i=1,6 do
		XINFA_BUTTONS[i]:SetNewFlash();
	end
	for i=1,5 do
		SKILL_BUTTONS[i]:SetNewFlash();
	end
end

function ActionSkill_OnShown()
	ActionSkill_Update();
end

function ActionSkill_Clear()
	Current_Xinfa = -1;

	for i=1, XINFA_BUTTONS_NUM do
		XINFA_BUTTONS[i]:SetActionItem(-1);
		XINFA_INDEX[i] = -1;
--		XINFA_LEVEL[i] : SetText("");
	end

--	for i=1, NUQI_BUTTONS_NUM do
--		NUQI_BUTTONS[i]:SetActionItem(-1);
--		NUQI_INDEX[i] = -1;
--	end

	for i=1, SKILL_BUTTONS_NUM do
		SKILL_BUTTONS[i]:SetActionItem(-1);
		SKILL_INDEX[i] = -1;
	end

end

function ActionSkill_Update()

	local i;
	--ActionSkill_Xinfa_Frame : Hide();
	--ActionSkill_Zhaoshi_Frame : Hide();
	ActionSkill_Use : Hide();
	ActionSkill_Explain : SetText("");
	ActionSkill_Name : SetText("");
	ActionSkill_LifeSkill : SetCheck(0);
	ActionSkill_CommonlySkill : SetCheck(0);
	ActionSkill_ActionSkill : SetCheck(1);

--��ʾ�ķ�
	for i=1, XINFA_BUTTONS_NUM do
		local theAction = EnumAction(i-1, "xinfa");

		if theAction:GetID() ~= 0 then
			XINFA_BUTTONS[i]:SetActionItem(theAction:GetID());


			XINFA_INDEX[i] = theAction:GetID();
			local nXinfaId = LifeAbility : GetLifeAbility_Number(XINFA_INDEX[i]);
			local nXinfa_level = Player:GetXinfaInfo(nXinfaId,"level");

			local str = "BotRight "..tostring(nXinfa_level);
			AxTrace(0,1,"botright="..str)
			XINFA_BUTTONS[i]:SetProperty("CornerChar",str);
			AxTrace(0,1,"property="..XINFA_BUTTONS[i]:GetProperty("CornerChar"))

		else
			XINFA_BUTTONS[i]:SetActionItem(-1);
			XINFA_INDEX[i] = -1;
--			XINFA_LEVEL[i] : SetText("û��");
		end
	end
	local Data_ACTION_ADD = {2,6,6,3,3,6,8,1}
	local Data_ACTION_GRADE,Data_EVERY_XF = 0,0
	for i = 1,8 do
		if XINFA_INDEX[i] ~= -1 then
			Data_EVERY_XF = Player:GetXinfaInfo( LifeAbility : GetLifeAbility_Number(XINFA_INDEX[i]) ,"level")*Data_ACTION_ADD[i]
		else
			Data_EVERY_XF = 0
		end
		Data_ACTION_GRADE = Data_ACTION_GRADE + Data_EVERY_XF
	end
	-- ActionSkill_XinfaNotice : SetText("#{DBXF_XML_1}" .. Data_ACTION_GRADE);
	-- ActionSkill_XiulianNotice : SetText("#{DBXF_XML_2}" .. DataPool:GetPlayerMission_DataRound(471));


	if(Current_Xinfa ~= -1 and XINFA_BUTTONS[Current_Xinfa] ~= -1) then
		ActionSkill_Update_Cliecked(Current_Xinfa,1);
	elseif(Current_Skill ~= -1 and SKILL_BUTTONS[Current_Skill] ~= -1) then
		ActionSkill_Update_Cliecked(Current_Skill,2);
	end
	ActionSkill_UpdateMenPaiText();		--������ʾ���֣������Ҹı�������
end
function ActionSkill_IsSepcialSkill(nID)
	if nID == 864 then
		return 1
	end
	if nID == 420 then
		return 1
	end
	if nID == 421 then
		return 1
	end
	if nID >= 756 and nID <= 760 then
		return 1
	end
	--��������
	if nID == 765 then
		return 1
	end
	--����Զ������
	if nID >= 480 and nID <= 483 then
		return 1
	end
	--��꼼��
	if nID >= 1500 and nID <= 1751 then
		return 1
	end
	return 0
end
function ActionSkill_Update_Cliecked(nIndex, Actiontype)
	local i;
	local theAction;
	local strName,strName2;

	if(Actiontype == 1) then

		if(XINFA_INDEX[nIndex] == -1) then
			return;
		end;

		--ActionSkill_Zhaoshi_Frame:Hide();
		ActionSkill_ZhaoshiTarget:Hide();
		--ActionSkill_Xinfa_Frame:Show();
		ActionSkill_XinfaTarget:Show();
		ActionSkill_Use : Hide();

		ActionSkill_XinfaTarget:SetActionItem(XINFA_INDEX[nIndex]);

		local nXinfaId = LifeAbility : GetLifeAbility_Number(XINFA_INDEX[nIndex]);

		strName = Player:GetXinfaInfo(nXinfaId,"name");
		Current_Xinfa_Name = strName;
	 	strName2= Player:GetXinfaInfo(nXinfaId,"level");
	 	Current_Xinfa_Level = strName2;

		ActionSkill_Name : SetText( strName .."\n" .. "�ķ��ȼ�:" .. strName2);
		ActionSkill_Name : SetProperty("TextColours","tl:FFEFEFEF tr:FFEFEFEF bl:FFEFEFEF br:FFEFEFEF");
		ActionSkill_Name : SetProperty("VertFormatting","VertCentred")
		ActionSkill_XinfaTarget : Enable();
--		XINFA_LEVEL[nIndex] : SetText(tostring(strName2));
		AxTrace(0,1,"XINFA_LEVEL["..nIndex.."] �ȼ�="..strName2);
--		AxTrace(0,1,"GET XINFA_LEVEL["..nIndex.."] �ȼ�="..XINFA_LEVEL[nIndex]:GetText());

	 	strName = Player:GetXinfaInfo(nXinfaId,"explain");
	 	ActionSkill_Explain : SetText(strName);

		for i=1, XINFA_BUTTONS_NUM do
			local theAction = EnumAction(i-1, "xinfa");

			if theAction:GetID() ~= 0 then
				XINFA_BUTTONS[i]:SetActionItem(theAction:GetID());
				XINFA_INDEX[i] = theAction:GetID();
				local nXinfaId = LifeAbility : GetLifeAbility_Number(XINFA_INDEX[i]);
				local nXinfa_level = Player:GetXinfaInfo(nXinfaId,"level");

--				XINFA_LEVEL[i] : SetText(tostring(nXinfa_level));
--				XINFA_LEVEL[i] : Show();
--				AxTrace(0,1,"XINFA_LEVEL["..i.."] �ȼ�="..nXinfa_level);
			else
				XINFA_BUTTONS[i]:SetActionItem(-1);
				XINFA_INDEX[i] = -1;
--				XINFA_LEVEL[i] : SetText("û��");
			end
		end

		for i=1, SKILL_BUTTONS_NUM do
			SKILL_BUTTONS[i]:SetActionItem(-1);
			SKILL_INDEX[i] = -1;
		end

		local nSumSkill = GetActionNum("skill");
		local nSkillIndex = 1;
		--AxTrace(0, 0, "nSumSkill=" .. nSumSkill);
		for i=1, nSumSkill do
			theAction = EnumAction(i-1, "skill");
			if theAction:GetOwnerXinfa() == XINFA_INDEX[nIndex] and ActionSkill_IsSepcialSkill(theAction:GetDefineID()) == 0 then
				SKILL_BUTTONS[nSkillIndex]:SetActionItem(theAction:GetID());
				SKILL_INDEX[nSkillIndex] = theAction:GetID();
				nSkillIndex = nSkillIndex+1;
			end
		end

		if(Current_Xinfa ~= -1) then
			XINFA_BUTTONS[Current_Xinfa] : SetPushed(0);
		elseif(Current_Skill ~= -1) then
			SKILL_BUTTONS[Current_Skill] : SetPushed(0);
		elseif(Current_Nuqi ~= -1) then
			NUQI_BUTTONS[Current_Nuqi] : SetPushed(0);
		end;

		Current_Xinfa = nIndex;
		Current_Skill = -1;
		Current_Nuqi = -1;

		XINFA_BUTTONS[Current_Xinfa]:SetPushed(1);

		--���
	elseif(Actiontype == 2) then

		if(SKILL_INDEX[nIndex] == -1) then
			return;
		end;

		if(Current_Skill ~= -1) then
			SKILL_BUTTONS[Current_Skill] : SetPushed(0);
		end

		Current_Skill = nIndex;
--		Current_Xinfa = -1;
		Current_Nuqi = -1;

		SKILL_BUTTONS[Current_Skill]:SetPushed(1);

		--ActionSkill_Xinfa_Frame:Hide();
		ActionSkill_XinfaTarget:Hide();
		--ActionSkill_Zhaoshi_Frame:Show();
		ActionSkill_ZhaoshiTarget:Show();

		ActionSkill_ZhaoshiTarget:SetActionItem(SKILL_INDEX[nIndex]);
		local nSkillId = LifeAbility : GetLifeAbility_Number(SKILL_INDEX[nIndex]);

		if( Player:GetSkillInfo(nSkillId,"passivity") == 1) then
	 		ActionSkill_Use : Hide();
	 	else
		 	ActionSkill_Use : Show();
		end

		strName = Player:GetSkillInfo(nSkillId,"name");

	 	if( Player:GetSkillInfo(nSkillId,"learn") ) then
--	 		strName2 = "�Ѿ�ѧ��";
	 		ActionSkill_Name : SetProperty("TextColours","tl:FFEFEFEF tr:FFEFEFEF bl:FFEFEFEF br:FFEFEFEF");
	 		ActionSkill_Name : SetProperty("VertFormatting","TopAligned")
	 		ActionSkill_ZhaoshiTarget : Enable();
	 	else
--		 	strName2 = "��δѧ��";
		 	ActionSkill_Name : SetProperty("TextColours","tl:FFFF0000 tr:FFFF0000 bl:FFFF0000 br:FFFF0000");
		 	ActionSkill_Name : SetProperty("VertFormatting","TopAligned")
		 	ActionSkill_ZhaoshiTarget : Disable();
		end

		if nil ~= strName then
--			ActionSkill_Name : SetText( strName .."\n" .. "" .. Current_Xinfa_Name .. "  " .. Current_Xinfa_Level .. "��");
--С��˵�ĵģ���ҫ��֤��
			ActionSkill_Name : SetText( strName );

	 	end
	 	strName = Player:GetSkillInfo(nSkillId,"explain");
	 	strName2 = Player:GetSkillInfo(nSkillId,"skilldata");
	 	if nil~=strName or nil~=strName2 then
	 		ActionSkill_Explain : SetText(strName.."\n"..strName2);
	 	end

	elseif(Actiontype == 3) then

		if(NUQI_INDEX[nIndex] == -1) then
			return;
		end;

		if(Current_Xinfa ~= -1) then
			XINFA_BUTTONS[Current_Xinfa] : SetPushed(0);
		elseif(Current_Skill ~= -1) then
			SKILL_BUTTONS[Current_Skill] : SetPushed(0);
		elseif(Current_Nuqi ~= -1) then
			NUQI_BUTTONS[Current_Nuqi] : SetPushed(0);
		end;

		Current_Nuqi = nIndex;
		Current_Xinfa = -1;
		Current_Skill = -1;

		NUQI_BUTTONS[Current_Nuqi]:SetPushed(1);

		--ActionSkill_Xinfa_Frame:Hide();
		ActionSkill_XinfaTarget:Hide();
		--ActionSkill_Zhaoshi_Frame:Show();
		ActionSkill_ZhaoshiTarget:Show();

		ActionSkill_ZhaoshiTarget:SetActionItem(NUQI_INDEX[nIndex]);
		local nNuqiId = LifeAbility : GetLifeAbility_Number(NUQI_INDEX[nIndex]);

		if( Player:GetSkillInfo(nSkillId,"passivity") == 1) then
	 		ActionSkill_Use : Hide();
	 	else
		 	ActionSkill_Use : Show();
		end

		strName = Player:GetSkillInfo(nNuqiId,"name");

	 	if( Player:GetSkillInfo(nNuqiId,"learn") ) then
--	 		strName2 = "�Ѿ�ѧ��";
	 		ActionSkill_Name : SetProperty("TextColor","FFEFEFEF");
	 		ActionSkill_ZhaoshiTarget : Enable();
	 	else
--		 	strName2 = "��δѧ��";
		 	ActionSkiActionSkill_Name : SetProperty("TextColor","FFFF0000");
		 	ActionSkill_ZhaoshiTarget : Disable();
		end

	 	ActionSkill_Name : SetText( strName .."\n" .. "ŭ������");

	 	strName = Player:GetSkillInfo(nNuqiId,"explain");
	 	strName2 = Player:GetSkillInfo(nNuqiId,"skilldata");
	 	ActionSkill_Explain : SetText(strName.."\n"..strName2);
	end

end

function ActionSkill_Button_Clicked()

--	if (Current_Skill ~= -1) or (Current_Nuqi ~= -1) then
	if (Current_Skill ~= -1) then
		ActionSkill_ZhaoshiTarget:DoAction();
	end

end

--function Skill_Page_Switch()
--	OpenLifePage();
--	ActionSkill_Close();
--	ActionSkill_LifeSkill : SetCheck(0);
--	ActionSkill_ActionSkill : SetCheck(1);
--end

function Action_Common_Page_Switch()
	OpenCommonSkillPage();
	ActionSkill_OnClose();
	ActionSkill_CommonlySkill : SetCheck(0);
	ActionSkill_LifeSkill : SetCheck(0);
	ActionSkill_ActionSkill : SetCheck(1);
end

function Action_Life_Page_Switch()
	OpenLifePage();
	ActionSkill_OnClose();
	ActionSkill_CommonlySkill : SetCheck(0);
	ActionSkill_LifeSkill : SetCheck(0);
	ActionSkill_ActionSkill : SetCheck(1);
end

function ActionSkill_SetTabColor()

	--AxTrace(0,0,tostring(idx));
	local selColor = "#e010101#Y";
	local noselColor = "#e010101";
	local tab = {
								[0] = ActionSkill_CommonlySkill,
								ActionSkill_ActionSkill,
								ActionSkill_LifeSkill,
							};

	local TAB_TEXT = {
		[0] = "��ͨ",
		"����",
		"����",
	};

	tab[0]:SetText(noselColor..TAB_TEXT[0]);
	tab[1]:SetText(selColor..TAB_TEXT[1]);
	tab[2]:SetText(noselColor..TAB_TEXT[2]);
end

function ActionSkill_AutoAttack_Page_Switch()
	local myLevel = Player:GetData("LEVEL")
	if myLevel >= 30 then
		PushEvent("UI_COMMAND",202206041)
		ActionSkill_OnClose()
	else
		PushDebugMessage("#{ZDZD_200724_54}")
	end
	ActionSkill_AutoAttack : SetCheck(0)
	ActionSkill_CommonlySkill : SetCheck(0)
	ActionSkill_LifeSkill : SetCheck(0)
	ActionSkill_ActionSkill : SetCheck(1)
end

function ActionSkill_OnClose()
	Variable:SetVariable("SkillUnionPos", ActionSkill_Frame:GetProperty("UnifiedPosition"), 1);
	ActionSkill_Close();
end

function ActionSkill_ClearStaticImage()
	ActionSkill_MenPai_ICON : SetProperty("Tooltip", "");
	ActionSkill_MenPai_ICON : SetProperty("Image","");
end

function ActionSkill_UpdateMenPaiText()
	local menpaiID = Player : GetData("MEMPAI");		--��ȡ�������ID
	if menpaiID ~= nil and menpaiID >=0 and menpaiID <=10 then
		if (menpaiID == 9) then
			ActionSkill_ClearStaticImage();
			ActionSkill_MenPai_Attr_Intro : SetText(""); --һ����˵���ﲻ�ᱻ����
			return;
		end
		local	str = GetDictionaryString( "MPZSX_20071221_0" .. (menpaiID +1) );
		ActionSkill_MenPai_Attr_Intro : SetText("#Y" .. str);
		--ActionSkill_ClearStaticImage();

		ActionSkill_MenPai_ICON : SetToolTip(GetDictionaryString(MenPai_UsedAttr[menpaiID].Tooltip));
		ActionSkill_MenPai_ICON : SetProperty("Image",MenPai_UsedAttr[menpaiID].image);
	end
end


function ActionSkill_Open()
	--ActionSkill_UpdateMenPaiText();
	this:Show();
end
function ActionSkill_Close()
	this:Hide();
end