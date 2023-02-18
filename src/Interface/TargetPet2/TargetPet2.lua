local WuXingTbl = {
			{level =1,	per = "1.0%" ,	maxlevel=1,	color = "#c00D000"},
			{level =2,	per = "1.5%" ,	maxlevel=1,	color = "#c00D000"},
			{level =3,	per = "2.1%" ,	maxlevel=2,	color = "#c00D000"},
			{level =4,	per = "3.0%" ,	maxlevel=2,	color = "#c00D000"},
			{level =5,	per = "8.0%" ,	maxlevel=3,	color = "#c43DBFF"},
			{level =6,	per = "11.0%" ,	maxlevel=3,	color = "#c43DBFF"},
			{level =7,	per = "14.5%" ,	maxlevel=4,	color = "#c43DBFF"},
			{level =8,	per = "23.5%" ,	maxlevel=4,	color = "#cFF8001"},
			{level =9,	per = "30.0%" ,	maxlevel=5,	color = "#cFF8001"},
			{level =10,	per = "39.3%" ,	maxlevel=5,	color = "#cFF8001"},
			{level =11,	per = "42.3%" ,	maxlevel=5,	color = "#cFF8001"},
			{level =12,	per = "46.0%" ,	maxlevel=5,	color = "#cFF8001"},
			{level =13,	per = "50.2%" ,	maxlevel=5,	color = "#cFF8001"},
			{level =14,	per = "54.7%" ,	maxlevel=5,	color = "#cFF8001"},
			{level =15,	per = "59.5%", maxlevel=5,	color = "#cFF8001"},
}
local ShowColor = "#H";
local TargetPet2SKILL_BUTTONS_NUM = 12;
local TargetPet2SKILL_BUTTONS = {};
local Currend_Pet = -1;
local PET_AITYPE = {};

----------------------------
--珍兽装备按钮数据定义 zchw
local g_Pet_Head; 		--头
local g_Pet_Claw;			--爪
local g_Pet_Body; 		--躯干
local g_Pet_Neck;			--项圈
local g_Pet_Charm;		--护符

----------------------------

function TargetPet2_PreLoad()

	this:RegisterEvent("SHOW_CONTEXT_SEL_PET");
	this:RegisterEvent("CLOSE_PET_FRAME")
	this:RegisterEvent("TOGLE_OPEN_PET_PETBANK")
	
end

function TargetPet2_OnLoad()
	TargetPet2SKILL_BUTTONS[1] = TargetPet2_Skill1;
	TargetPet2SKILL_BUTTONS[2] = TargetPet2_Skill2;
	TargetPet2SKILL_BUTTONS[3] = TargetPet2_Skill3;
	TargetPet2SKILL_BUTTONS[4] = TargetPet2_Skill4;
	TargetPet2SKILL_BUTTONS[5] = TargetPet2_Skill5;
	TargetPet2SKILL_BUTTONS[6] = TargetPet2_Skill6;
	TargetPet2SKILL_BUTTONS[7] = TargetPet2_Skill7;
	TargetPet2SKILL_BUTTONS[8] = TargetPet2_Skill8;
	TargetPet2SKILL_BUTTONS[9] = TargetPet2_Skill9;
	TargetPet2SKILL_BUTTONS[10] = TargetPet2_Skill10;
	TargetPet2SKILL_BUTTONS[11] = TargetPet2_Skill11;
	TargetPet2SKILL_BUTTONS[12] = TargetPet2_Skill12;

	PET_AITYPE[0] = "胆小";
	PET_AITYPE[1] = "谨慎";
	PET_AITYPE[2] = "忠诚";
	PET_AITYPE[3] = "精明";
	PET_AITYPE[4] = "勇猛";
	
	--------------------------
	-- 珍兽装备与全局变量关联 zchw
	g_Pet_Head = TargetPetEquip_1;
	g_Pet_Claw = TargetPetEquip_2;	
	g_Pet_Body = TargetPetEquip_3;
	g_Pet_Neck = TargetPetEquip_4;		
	g_Pet_Charm = TargetPetEquip_5;
	---------------------------
end

function TargetPet2_OnEvent(event)

	--交易过程中的珍兽显示	
	if (event == "SHOW_CONTEXT_SEL_PET")  then
		if(IsWindowShow("OtherPet")) then
			CloseWindow("OtherPet", true);
		end
		if IsWindowShow("TargetPet") then
			CloseWindow("TargetPet", true);
		end
		TargetPet2_FakeObject : SetFakeObject( "" );
		TargetPet : SetModel2();
		TargetPet2_FakeObject : SetFakeObject( "My_TargetPet2" );		
		TargetPet2_Update();
		TargetPet2_SetStateTooltip();
		this:Show();		
	elseif ( event == "CLOSE_PET_FRAME" and this:IsVisible() ) then
		this:Hide();
		return
	--珍兽银行珍兽显示	
	elseif (event == "TOGLE_OPEN_PET_PETBANK")  then
		if(IsWindowShow("OtherPet")) then
			CloseWindow("OtherPet", true);
		end
		--zchw
		if IsWindowShow("TargetPet") then
			CloseWindow("TargetPet", true);
		end
	  TargetPet2_FakeObject : SetFakeObject( "" );
		TargetPet : SetModel2();
		TargetPet2_FakeObject : SetFakeObject( "My_TargetPet2" );		
		TargetPet2_Update();
		TargetPet2_SetStateTooltip();
		this:Show();

	end
	
end

function TargetPet2_Refresh_Equip()

	g_Pet_Head:SetActionItem(-1)
	g_Pet_Claw:SetActionItem(-1)
	g_Pet_Body:SetActionItem(-1)
	g_Pet_Neck:SetActionItem(-1)
	g_Pet_Charm:SetActionItem(-1)
	
	local ActionClaw = EnumAction(0, "target_pet_equip")
	local ActionHead = EnumAction(1, "target_pet_equip")
	local ActionBody = EnumAction(2, "target_pet_equip")
	local ActionNeck = EnumAction(3, "target_pet_equip")
	local ActionCharm = EnumAction(4, "target_pet_equip")
	
	g_Pet_Head:SetActionItem(ActionHead:GetID())
	g_Pet_Claw:SetActionItem(ActionClaw:GetID())
	g_Pet_Body:SetActionItem(ActionBody:GetID())
	g_Pet_Neck:SetActionItem(ActionNeck:GetID())
	g_Pet_Charm:SetActionItem(ActionCharm:GetID())
	
	TargetPet2_PetSoul_Equip:SetActionItem(-1)
	TargetPet_PetSoul1:SetActionItem(-1)
	TargetPet2_PetSoul2:SetProperty("BackImage", "")
	TargetPet2_PetSoul_Equip_Check:Disable()

	if TargetPet:LuaFnIsPetEquipPetSoul() == 1 then
		local ActionSoul = EnumAction(5, "target_pet_equip")
		TargetPet2_PetSoul_Equip:SetActionItem(ActionSoul:GetID())
	
		local skillAction = TargetPet:LuaFnEnumPetSoulSkillActionOnPet(PET_CURRENT_SELECT)
		if skillAction ~= nil then
			TargetPet_PetSoul1:SetActionItem(skillAction:GetID())
		end

		TargetPet2_PetSoul_Equip_Check:Enable()
		
		local _, szPetPossSkillIcon, _, _ = Pet:LuaFnGetPetSoulPossSkillInfo(-1, 2)
		if szPetPossSkillIcon ~= "" then
			TargetPet2_PetSoul2:SetProperty( "BackImage", szPetPossSkillIcon )
		end
	end
		
end

function TargetPetEquip_Equip_Click(num, type)
end

function TargetPet2_OnShown()

	TargetPet2_Page_Clear();

	if( TargetPet:IsPresent() ) then
		TargetPet2_Update();
		return;
	end;

end

function TargetPet2_Page_Clear()

--	TargetPet2_PetName : SetText( "" );
	TargetPet2_PageHeader : SetText( "#gFF0FA0" );
	TargetPet2_ConsortID : SetText( "" );
	TargetPet2_Model_Protect_Text : SetText( "" );
	TargetPet2_TargetPetID : SetText( "" );
	TargetPet2_Sex : SetText("");
	TargetPet2_Life : SetText( "" );
	TargetPet2_Happy : SetText("");
--	Pet_LoyalgGade : SetText( "" );
	TargetPet2_Level : SetText( "" );
--	Pet_Type : SetText( "" );
	TargetPet2_StrAptitude : SetText( "" );
	TargetPet2_PhysicalStrengthAptitude : SetText( "" );
	TargetPet2_DexterityAptitude : SetText( "" );
	TargetPet2_NimbusAptitude : SetText( "" );
	TargetPet2_StabilityAptitude : SetText( "" );
	TargetPet2_Exp : SetText( "" );
	TargetPet2_Blood : SetText( "" .. "  " .. "" );
--	Pet_MP : SetText( "" .. " / " .. "" );
	TargetPet2_Str : SetText( "" );
	TargetPet2_Str : SetProperty("TextColours","tl:FFEFEFEF tr:FFEFEFEF bl:FFEFEFEF br:FFEFEFEF");
	TargetPet2_Nimbus : SetText( "" );
	TargetPet2_Nimbus : SetProperty("TextColours","tl:FFEFEFEF tr:FFEFEFEF bl:FFEFEFEF br:FFEFEFEF");
	TargetPet2_Dexterity : SetText( "" );
	TargetPet2_Dexterity : SetProperty("TextColours","tl:FFEFEFEF tr:FFEFEFEF bl:FFEFEFEF br:FFEFEFEF");
	TargetPet2_PhysicalStrength : SetText( "" );
	TargetPet2_PhysicalStrength : SetProperty("TextColours","tl:FFEFEFEF tr:FFEFEFEF bl:FFEFEFEF br:FFEFEFEF");
	TargetPet2_Stability : SetText( "" );
	TargetPet2_Stability : SetProperty("TextColours","tl:FFEFEFEF tr:FFEFEFEF bl:FFEFEFEF br:FFEFEFEF");
	TargetPet2_GenGu : SetText( "" );
	TargetPet2_WuXing : SetText( "" );
	TargetPet2_Potential : SetText( "" );
	TargetPet2_Potential : SetProperty("TextColours","tl:FFEFEFEF tr:FFEFEFEF bl:FFEFEFEF br:FFEFEFEF");
	TargetPet2_PhysicsAttack : SetText( "" );
	TargetPet2_MagicAttack : SetText( "" );
	TargetPet2_PhysicsRecovery : SetText( "" );
	TargetPet2_MagicRecovery : SetText( "" );
	TargetPet2_Miss : SetText( "" );
	TargetPet2_ShootProbability : SetText( "" );
	TargetPet2_CriticalAttack:SetText("");
	TargetPet2_CriticalDefence:SetText("");
	TargetPet2_Growth:SetText("")
	TargetPet2_Lingxing : SetText("")
	TargetPet2_Lingxing_Info:SetText("")
	--TargetPet2_FakeObject : SetFakeObject( "" );

	g_Pet_Head : SetActionItem(-1);
	g_Pet_Claw : SetActionItem(-1);
	g_Pet_Body : SetActionItem(-1);
	g_Pet_Neck : SetActionItem(-1);
	g_Pet_Charm : SetActionItem(-1);
	for i=1, TargetPet2SKILL_BUTTONS_NUM do
		TargetPet2SKILL_BUTTONS[i]:SetActionItem(-1);
	end
	TargetPet2Food_Type : Hide()
	TargetPet2_NeedLevel : SetText("")
	TargetPet2_lock:Hide();
	TargetPet2Attack_Type:Hide();
	TargetPet2_Jian : Hide();
	TargetPet2_ClearStateTooltip();
end

function TargetPet2_Update()

	local i;

	if(not (TargetPet:IsPresent()) ) then
		return;
	end
	
	TargetPet2_Page_Clear();
	strName = TargetPet:GetAIType(nIndex);
 	
	local strAI,strIcon;
	if(strName>4 or strName <0) then
		strAI = "错误的";
	else
		strAI =	PET_AITYPE[strName];
	end
	
 	strName,strName2 = TargetPet:GetName();
	local nEra, strTypeName = TargetPet:GetPetTypeName(nIndex);
 	if( 1 == nEra ) then
 	    strName2 = "二代"..strTypeName
 	end
	TargetPet2_PetName : SetText( strName );
	TargetPet2_PageHeader : SetText( "#gFF0FA0"..strName2 );
	TargetPet2_Type : SetText("#gFF8E92"..strAI)

	strName,strName2,sex = TargetPet : GetID();
	TargetPet2_TargetPetID : SetText( "珍兽ID:"..strName2 );
	AxTrace(0,0,"GetID="..strName .. strName2);
	
	strName = TargetPet : GetConsort();
	if tonumber(strName) == 0 then
		TargetPet2_ConsortID : SetText( "尚无配偶" );
	else
		TargetPet2_ConsortID : SetText( "配偶ID:".. strName );
	end
	
	if TargetPet : GetGoodsProtect_Pet() == 1 then
		TargetPet2_Model_Protect_Text : SetText( "#{GDWPBH_090507_4}" );
	else
		TargetPet2_Model_Protect_Text : SetText( "" );
	end
	
	if(sex == 1) then 
		strName = "雄性";
	else
		strName = "雌性";
	end

	local nGeneration  = TargetPet : GetGeneration()
	if nGeneration ~= nil and nGeneration >= 100 then
		strName = "#{RXZS_XML_35}";
	end

	TargetPet2_Sex : SetText( strName );
	
	strName = TargetPet : GetNaturalLife();
	TargetPet2_Life : SetText( "寿命:"..strName );

	strName = TargetPet : GetLevel();
	TargetPet2_Level : SetText( "等级:"..strName.."级" );
	
	strName = TargetPet : GetHappy();
	TargetPet2_Happy : SetText( "快乐:"..strName );
	
	strName = TargetPet : GetBasic();
	TargetPet2_GenGu : SetText( "根骨:"..strName );
	
	strName = TargetPet : GetLixing(nIndex);
	TargetPet2_Lingxing : SetText("#{RXZS_XML_28}"..strName)

	strName = TargetPet : GetPercent_Lx()
	if tonumber(strName) ~= nil and tonumber(strName) > 0 then
		local rateStr = string.format("%0.1f" , strName / 10.0)
		TargetPet2_Lingxing_Info:SetText("#cFF00FF(+"..rateStr.."%)")
	end

	local iSavvy = TargetPet:GetSavvy()
	TargetPet2_WuXing:SetText("悟性:".. tostring(iSavvy))
	
	local iStrAptitude = TargetPet:GetStrAptitude()
	local iSprAptitude = TargetPet:GetIntAptitude()
	local iConAptitude = TargetPet:GetPFAptitude()
	local iIntAptitude = TargetPet:GetStaAptitude()
	local iDexAptitude = TargetPet:GetDexAptitude()
	
	local bHavePetSoul = TargetPet:LuaFnIsPetEquipPetSoul()
	local iStrAptitude_ps = TargetPet:LuaFnGetStrAptitude_ps()
	local iSprAptitude_ps = TargetPet:LuaFnGetSprAptitude_ps()
	local iConAptitude_ps = TargetPet:LuaFnGetConAptitude_ps()
	local iIntAptitude_ps = TargetPet:LuaFnGetIntAptitude_ps()
	local iDexAptitude_ps = TargetPet:LuaFnGetDexAptitude_ps()
	
	if WuXingTbl[iSavvy] ~= nil then
		if bHavePetSoul == 1 then
			TargetPet2_StrAptitude:SetText(WuXingTbl[iSavvy].color..tostring(iStrAptitude)..ShowColor.."(+"..WuXingTbl[iSavvy].per..")".."#cFFCC99(+"..tostring(iStrAptitude_ps)..")")
			TargetPet2_NimbusAptitude:SetText(WuXingTbl[iSavvy].color..tostring(iSprAptitude)..ShowColor.."(+"..WuXingTbl[iSavvy].per..")".."#cFFCC99(+"..tostring(iSprAptitude_ps)..")")
			TargetPet2_PhysicalStrengthAptitude:SetText(WuXingTbl[iSavvy].color..tostring(iConAptitude)..ShowColor.."(+"..WuXingTbl[iSavvy].per..")".."#cFFCC99(+"..tostring(iConAptitude_ps)..")")
			TargetPet2_StabilityAptitude:SetText(WuXingTbl[iSavvy].color..tostring(iIntAptitude)..ShowColor.."(+"..WuXingTbl[iSavvy].per..")".."#cFFCC99(+"..tostring(iIntAptitude_ps)..")")
			TargetPet2_DexterityAptitude:SetText(WuXingTbl[iSavvy].color..tostring(iDexAptitude)..ShowColor.."(+"..WuXingTbl[iSavvy].per..")".."#cFFCC99(+"..tostring(iDexAptitude_ps)..")")
		else
			TargetPet2_StrAptitude:SetText(WuXingTbl[iSavvy].color..tostring(iStrAptitude)..ShowColor.."(+"..WuXingTbl[iSavvy].per..")")
			TargetPet2_NimbusAptitude:SetText(WuXingTbl[iSavvy].color..tostring(iSprAptitude)..ShowColor.."(+"..WuXingTbl[iSavvy].per..")")
			TargetPet2_PhysicalStrengthAptitude:SetText(WuXingTbl[iSavvy].color..tostring(iConAptitude)..ShowColor.."(+"..WuXingTbl[iSavvy].per..")")
			TargetPet2_StabilityAptitude:SetText(WuXingTbl[iSavvy].color..tostring(iIntAptitude)..ShowColor.."(+"..WuXingTbl[iSavvy].per..")")
			TargetPet2_DexterityAptitude:SetText(WuXingTbl[iSavvy].color..tostring(iDexAptitude)..ShowColor.."(+"..WuXingTbl[iSavvy].per..")")
	end
	else
		if bHavePetSoul == 1 then
			TargetPet2_StrAptitude:SetText(tostring(iStrAptitude).."#cFFCC99(+"..tostring(iStrAptitude_ps)..")")
			TargetPet2_NimbusAptitude:SetText(tostring(iSprAptitude).."#cFFCC99(+"..tostring(iSprAptitude_ps)..")")
			TargetPet2_PhysicalStrengthAptitude:SetText(tostring(iConAptitude).."#cFFCC99(+"..tostring(iConAptitude_ps)..")")
			TargetPet2_StabilityAptitude:SetText(tostring(iIntAptitude).."#cFFCC99(+"..tostring(iIntAptitude_ps)..")")
			TargetPet2_DexterityAptitude:SetText(tostring(iDexAptitude).."#cFFCC99(+"..tostring(iDexAptitude_ps)..")")
		else
			TargetPet2_StrAptitude:SetText(tostring(iStrAptitude))
			TargetPet2_NimbusAptitude:SetText(tostring(iSprAptitude))
			TargetPet2_PhysicalStrengthAptitude:SetText(tostring(iConAptitude))
			TargetPet2_StabilityAptitude:SetText(tostring(iIntAptitude))
			TargetPet2_DexterityAptitude:SetText(tostring(iDexAptitude))		
	end
	end
	
	strName = TargetPet : GetExp();
	TargetPet2_Exp : SetText( "经验:"..strName );
	
	strName = TargetPet : GetHP(nIndex);
	strName2 = TargetPet:	GetMaxHP(nIndex);
	TargetPet2_Blood : SetText( "血:"..strName .." / ".. strName2);

	strName = TargetPet : GetStr();
	TargetPet2_Str : SetText( strName );
	TargetPet2_Str : SetProperty("TextColours","tl:FFEFEFEF tr:FFEFEFEF bl:FFEFEFEF br:FFEFEFEF");
	
	strName = TargetPet : GetInt();
	TargetPet2_Nimbus : SetText( tonumber(strName) );
	TargetPet2_Nimbus : SetProperty("TextColours","tl:FFEFEFEF tr:FFEFEFEF bl:FFEFEFEF br:FFEFEFEF");
	
	strName = TargetPet : GetDex();
	TargetPet2_Dexterity : SetText( tonumber(strName) );
	TargetPet2_Dexterity : SetProperty("TextColours","tl:FFEFEFEF tr:FFEFEFEF bl:FFEFEFEF br:FFEFEFEF");
	
	strName = TargetPet : GetPF();
	TargetPet2_PhysicalStrength : SetText( tonumber(strName) );
	TargetPet2_PhysicalStrength : SetProperty("TextColours","tl:FFEFEFEF tr:FFEFEFEF bl:FFEFEFEF br:FFEFEFEF");
	
	strName = TargetPet : GetSta();
	TargetPet2_Stability : SetText( tonumber(strName) );
	TargetPet2_Stability : SetProperty("TextColours","tl:FFEFEFEF tr:FFEFEFEF bl:FFEFEFEF br:FFEFEFEF");
	
--	strName = TargetPet : GetBasic();
--	TargetPet2_Basic : SetText( tonumber(strName) );

	strName = TargetPet : GetCriticalAttack();
	TargetPet2_CriticalAttack : SetText( tonumber(strName) );

	strName = TargetPet : GetCriticalDefence();
	TargetPet2_CriticalDefence : SetText( tonumber(strName) );

	strName = TargetPet : GetPotential();
	strName2 = tonumber(strName);
	TargetPet2_Potential : SetText( strName2 );
	TargetPet2_Potential : SetProperty("TextColours","tl:FFEFEFEF tr:FFEFEFEF bl:FFEFEFEF br:FFEFEFEF");

	strName = TargetPet : GetPhysicsAttack();
	TargetPet2_PhysicsAttack : SetText( strName );
	
	strName = TargetPet : GetMagicAttack();
	TargetPet2_MagicAttack : SetText( strName );
	
	strName = TargetPet : GetPhysicsRecovery();
	TargetPet2_PhysicsRecovery : SetText( strName );
	
	strName = TargetPet : GetMagicRecovery ();
	TargetPet2_MagicRecovery : SetText( strName );

	--闪避率
	strName = TargetPet : GetMiss();
	TargetPet2_Miss : SetText( strName );

	--命中率
	strName = TargetPet : GetShootProbability();
	TargetPet2_ShootProbability : SetText( strName );
	
	local SumPetSkill = GetActionNum("petskill");
	local k=1;
	
	for i=1, SumPetSkill+TargetPet2SKILL_BUTTONS_NUM do
		local theSkillAction = Pet : EnumPetSkill( 100, i-1, "petskill");
		if( theSkillAction ~= nil and (theSkillAction : GetPetSkillOwner() == 100) and (k <= TargetPet2SKILL_BUTTONS_NUM ) ) then
			TargetPet2SKILL_BUTTONS[k]:SetActionItem(theSkillAction:GetID());
			k = k + 1;
		end
	end
	
	--zchw
	TargetPet2_Refresh_Equip();
	
	local strNeedLevel;
	local strNeedLevelColor;
	local nTakeLevel = TargetPet:GetTakeLevel();
	
	if( nTakeLevel > Player:GetData( "LEVEL" ) )then
		strNeedLevelColor="#cFF0000";
	else
		strNeedLevelColor="#c00FF00";
	end
	strNeedLevel = strNeedLevelColor..tostring( nTakeLevel ).."级#W可携带";

	TargetPet2_NeedLevel : SetText(strNeedLevel)

	strName = TargetPet : GetGrowRate();
	TargetPet2_Growth : SetText("#G未知")
	local nGrowLevel = TargetPet : GetPetGrowLevel(tonumber(strName));
	local strTbl = {"普通","优秀","杰出","卓越","完美"};
	
	if(nGrowLevel >= 0) then
		nGrowLevel = nGrowLevel + 1;	--c里是从0开始的枚举
		local nGrowRate = TargetPet : GetGrowRate();
		if(strTbl[nGrowLevel]) then
			TargetPet2_Growth : SetText("#G"..strTbl[nGrowLevel]..nGrowRate)
		end
	end

	local food = TargetPet : GetFoodType();
	strName = "";
	AxTrace(0,1,"food="..food);
	if(food >= 1000) then
		strName = strName .. "肉";
		food = food - 1000;
		if food > 0 then
			strName = strName .. ",";
		end
	end
	if(food >= 100) then
		strName = strName .. "草";
		food = food - 100;
		if food > 0 then
			strName = strName .. ",";
		end
	end
	if(food >= 10) then
		strName = strName .. "虫";
		food = food - 10;
		if food > 0 then
			strName = strName .. ",";
		end
	end
	
	if(food >= 1) then
		strName = strName .. "谷";
	end
	TargetPet2Food_Type : Show();
	TargetPet2Food_Type : SetToolTip( strName );
	
	strName,strIcon = TargetPet : GetAttackTrait();
	AxTrace(0,0,"strIcon="..strIcon)
	AxTrace(0,0,"strName="..strName)
	if strIcon ~= "" then
		TargetPet2Attack_Type : SetProperty( "Image", "set:Button6 image:"..strIcon )
		TargetPet2Attack_Type : SetToolTip(strName)
		TargetPet2Attack_Type : Show();
	end

	TargetPet2_Jian : Show();

end

function TargetPet2_Skill_Button_Clicked(nIndex)
--将来主动技能和被动技能，可以在表里查到。
--	if(nIndex < 3) then
		
--	end

--	PETSKILL_BUTTONS[nIndex] : DoAction();

--	local SumPetSkill = GetActionNum("petskill");
--	local k=1;
--	for i=1, SumPetSkill do
--		local theSkillAction = EnumAction( i-1, "petskill");
--		if( (theSkillAction : GetPetSkillOwner() == nIndex) and (k <= TargetPet2SKILL_BUTTONS_NUM ) ) then
--			PETSKILL_BUTTONS[k]:SetActionItem(theSkillAction:GetID());
--			k = k + 1;
--		end
--	end
end

----------------------------------------------------------------------------------
--
-- 旋转珍兽模型（向左)
--
function TargetPet2_Modle_TurnLeft(start)
	--向左旋转开始
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		--向左旋转开始
		if(start == 1) then
			TargetPet2_FakeObject:RotateBegin(-0.3);
		--向左旋转结束
		else
			TargetPet2_FakeObject:RotateEnd();
		end
	end
end

----------------------------------------------------------------------------------
--
--旋转珍兽模型（向右)
--
function TargetPet2_Modle_TurnRight(start)
	--向右旋转开始
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		--向右旋转开始
		if(start == 1) then
			TargetPet2_FakeObject:RotateBegin(0.3);
		--向右旋转结束
		else
			TargetPet2_FakeObject:RotateEnd();
		end
	end
end

function TargetPet2_Jian_Clicked()
	if(not (TargetPet:IsPresent()) ) then
		return;
	end
	Pet:PetOpenPetJian(-1,"target");
end

function TargetPet2_SetStateTooltip( )

	-- 得到状态属性
	local iIceAttack  		= TargetPet : GetAttackCold( nIndex );
	local iFireAttack 		= TargetPet : GetAttackFire( nIndex );
	local iThunderAttack	= TargetPet : GetAttackLight( nIndex );
	local iPoisonAttack		= TargetPet : GetAttackPoison( nIndex );

	local iIceDefine  		= TargetPet : GetDefenceCold( nIndex );
	local iFireDefine 		= TargetPet : GetDefenceFire( nIndex );
	local iThunderDefine	= TargetPet : GetDefenceLight( nIndex );
	local iPoisonDefine		= TargetPet : GetDefencePoison( nIndex );

	local iIceResistOther		= TargetPet : GetResistCold( nIndex );
	local iFireResistOther		= TargetPet : GetResistFire( nIndex );
	local iThunderResistOther	= TargetPet : GetResistLight( nIndex );
	local iPoisonResistOther	= TargetPet : GetResistPoison( nIndex );
	
	------------------------------
	if( iIceAttack == nil ) then
		iIceAttack = 0;
	end
	if( iFireAttack == nil ) then
		iFireAttack = 0;
	end
	if( iThunderAttack == nil ) then
		iThunderAttack = 0;
	end
	if( iPoisonAttack == nil ) then
		iPoisonAttack = 0;
	end
	------------------------------
	if( iIceDefine == nil ) then
		iIceDefine = 0;
	end
	
	if( iFireDefine == nil ) then
		iFireDefine = 0;
	end
	
	if( iPoisonDefine == nil ) then
		iPoisonDefine = 0;
	end
	if( iThunderDefine == nil ) then
		iThunderDefine = 0;
	end
	------------------------------
	if( iIceResistOther == nil ) then
		iIceResistOther = 0;
	end
	if( iFireResistOther == nil ) then
		iFireResistOther = 0;
	end
	if( iThunderResistOther == nil ) then
		iThunderResistOther = 0;
	end
	if( iPoisonResistOther == nil ) then
		iPoisonResistOther = 0;
	end


	Pet2_IceFastness:SetToolTip("冰攻:"..tostring(iIceAttack).."#r冰抗:"..tostring(iIceDefine).."#r减冰抗:"..tostring(iIceResistOther) );
	Pet2_FireFastness:SetToolTip("火攻:"..tostring(iFireAttack).."#r火抗:"..tostring(iFireDefine).."#r减火抗:"..tostring(iFireResistOther) );
	Pet2_ThunderFastness:SetToolTip("玄攻:"..tostring(iThunderAttack).."#r玄抗:"..tostring(iThunderDefine).."#r减玄抗:"..tostring(iThunderResistOther) );
	Pet2_PoisonFastness:SetToolTip("毒攻:"..tostring(iPoisonAttack).."#r毒抗:"..tostring(iPoisonDefine).."#r减毒抗:"..tostring(iPoisonResistOther) );

end

function TargetPet2_ClearStateTooltip()
	-- 得到状态属性
	local iIceAttack  		= 0;
	local iFireAttack 		= 0;
	local iThunderAttack	= 0;
	local iPoisonAttack		= 0;

	local iIceDefine  		= 0;
	local iFireDefine 		= 0;
	local iThunderDefine	= 0;
	local iPoisonDefine		= 0;

	local iIceResistOther		= 0;
	local iFireResistOther		= 0;
	local iThunderResistOther	= 0;
	local iPoisonResistOther	= 0;

	Pet2_IceFastness:SetToolTip("冰攻:"..tostring(iIceAttack).."#r冰抗:"..tostring(iIceDefine).."#r减冰抗:"..tostring(iIceResistOther) );
	Pet2_FireFastness:SetToolTip("火攻:"..tostring(iFireAttack).."#r火抗:"..tostring(iFireDefine).."#r减火抗:"..tostring(iFireResistOther) );
	Pet2_ThunderFastness:SetToolTip("玄攻:"..tostring(iThunderAttack).."#r玄抗:"..tostring(iThunderDefine).."#r减玄抗:"..tostring(iThunderResistOther) );
	Pet2_PoisonFastness:SetToolTip("毒攻:"..tostring(iPoisonAttack).."#r毒抗:"..tostring(iPoisonDefine).."#r减毒抗:"..tostring(iPoisonResistOther) );

end

function TargetPet2_OnHidden()
	Pet:LuaFnClosePetSoulInfo(2)
end

function TargetPet2_PetSoul_ShowInfo()
	
	if TargetPet:LuaFnIsPetEquipPetSoul() ~= 1 then
		return
	end
	
	Pet:LuaFnShowPetSoulInfo(2, -1)

end

function TargetPet2_PetSoul2_MouseEnter()
	
	if TargetPet:LuaFnIsPetEquipPetSoul() ~= 1 then
		return
	end
	
	local left, right, top, bottom = TargetPet2_PetSoul2:GetPixelRect()
	
	TargetPet:LuaFnShowPetSoulPossSkillInfo(1, left, top, right, bottom)
	
end

function TargetPet2_PetSoul2_MouseLeave()
	
	local left, right, top, bottom = TargetPet2_PetSoul2:GetPixelRect()
	TargetPet:LuaFnShowPetSoulPossSkillInfo(0, left, top, right, bottom)

end
