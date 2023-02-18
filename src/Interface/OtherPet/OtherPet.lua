--2020-11-23 新增对方面板珍兽装备显示以及属性 Q546528533
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
local PETSKILL_BUTTONS_NUM = 12;
local PETSKILL_BUTTONS = {};
local PET_POTREMAIN = 0;
local PET_ATTR_COUNT = 5;
local PET_MAX_NUMBER = 6+4;
local PETNUM = 0;
local PET_REST = 1;
local PET_FIGHT= 0;
local PET_CURRENT_SELECT = 0;
local PET_AITYPE = {};
local Changed_Name_Flag = 0;
--			// 创建珍兽(即放出) 0
--			// 收回珍兽					1
--			// 销毁珍兽(即放生)	2
--			// 捕捉珍兽					3
--			可以在被放出后，通过消息，改变该珍兽在listbox中的名字的颜色。
local PET_TAB_TEXT = {};
local PET_ORIGINAL_NAME = "";
local nPetEquipAttrShow = 0
------------------------------------------------------
--珍兽装备按钮数据定义 zchw
local g_Pet_Head; 		--头
local g_Pet_Claw;			--爪
local g_Pet_Body; 		--躯干
local g_Pet_Neck;			--项圈
local g_Pet_Charm;		--护符

local g_OtherPet_Frame_UnifiedPosition;

------------------------------------------------------

function OtherPet_PreLoad()
	this:RegisterEvent("TOGLE_OTHERPET_PAGE");
	this:RegisterEvent("UPDATE_OTHERPET_PAGE");
	this:RegisterEvent("UI_COMMAND");
	
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function OtherPet_OnLoad()

	PETSKILL_BUTTONS[1] = OtherPet_Skill1;
	PETSKILL_BUTTONS[2] = OtherPet_Skill2;
	PETSKILL_BUTTONS[3] = OtherPet_Skill3;
	PETSKILL_BUTTONS[4] = OtherPet_Skill4;
	PETSKILL_BUTTONS[5] = OtherPet_Skill5;
	PETSKILL_BUTTONS[6] = OtherPet_Skill6;
	PETSKILL_BUTTONS[7] = OtherPet_Skill7;
	PETSKILL_BUTTONS[8] = OtherPet_Skill8;
	PETSKILL_BUTTONS[9] = OtherPet_Skill9;
	PETSKILL_BUTTONS[10] = OtherPet_Skill10;
	PETSKILL_BUTTONS[11] = OtherPet_Skill11;
	PETSKILL_BUTTONS[12] = OtherPet_Skill12;

	PET_AITYPE[0] = "胆小";
	PET_AITYPE[1] = "谨慎";
	PET_AITYPE[2] = "忠诚";
	PET_AITYPE[3] = "精明";
	PET_AITYPE[4] = "勇猛";

	PET_TAB_TEXT = {
		[0] = "装备",
		"资料",
		"珍兽",
		"骑乘",
	};
	--------------------------
	-- 珍兽装备与全局变量关联 zchw
	g_Pet_Head = OtherPetEquip_1;
	g_Pet_Claw = OtherPetEquip_2;
	g_Pet_Body = OtherPetEquip_3;
	g_Pet_Neck = OtherPetEquip_4;
	g_Pet_Charm = OtherPetEquip_5;
	---------------------------
	
	g_OtherPet_Frame_UnifiedPosition=OtherPet_Frame:GetProperty("UnifiedPosition");
end

function OtherPet_OnEvent(event)
	OtherPet_SetTabColor(3);
	--this:Show();

	if ( event == "TOGLE_OTHERPET_PAGE" ) then

		if arg0 ~= nil and tonumber(arg0) < PET_MAX_NUMBER and tonumber(arg0) >= 0 then
			PET_CURRENT_SELECT = tonumber(arg0)
		end
		if(IsWindowShow("TargetPet")) then
			CloseWindow("TargetPet", true);
			return;
		end
		
		local obj_id = CachedTarget:GetData("NPCID", 1)
		if (type(obj_id) ~="number") then
			PushDebugMessage ("#{JSCK_90507_1}")				-- 距离该玩家太远，无法查看资料。
			return
		end
		this:CareObject(obj_id , 1)

		OtherPet_OnShown();
		OtherPet_Open();
		return;
	elseif ( event == "UPDATE_OTHERPET_PAGE" and this:IsVisible() ) then
		OtherPet_Update();
		OtherPet_SetStateTooltip(PET_CURRENT_SELECT);
		return;
		
	elseif (event == "ADJEST_UI_POS" ) then
		OtherPet_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		OtherPet_Frame_On_ResetPos()
	elseif (event == "UI_COMMAND" and tonumber(arg0) ==  20201123  ) then
	    nPetEquipAttrShow = Get_XParam_INT(0)
		OtherPet_Refresh_Equip()
		OtherPet_Show_Appoint(PET_CURRENT_SELECT)
	end

end

function OtherPet_OnShown()
	local otherUnionPos = Variable:GetVariable("OtherUnionPos");
	if(otherUnionPos ~= nil) then
		OtherPet_Frame:SetProperty("UnifiedPosition", otherUnionPos);
	end


	OtherPet_SelfEquip : SetCheck(0);
	OtherPet_TargetData : SetCheck(0);
	OtherPet_Pet : SetCheck(1);
	-- OtherPet_Blog : SetCheck(0);
--	OtherPet_OtherInfo : SetCheck(0);
	OtherPet_Page_Clear();
	OtherPet_Update();
	OtherPet_SetStateTooltip(PET_CURRENT_SELECT);

end

function OtherPet_Page_Clear()
	OtherPet_FakeObject:RotateEnd();
	OtherPet_FakeObject:RotateEnd();


	OtherPet_OtherPetName:SetText("")
	OtherPet_Type : SetText("");

	OtherPet_PageHeader : SetText( "#gFF0FA0珍兽" );
	OtherPet_ConsortID : SetText( "" );
	OtherPet_Model_Protect_Text : SetText( "" );
	OtherPet_OtherPetID : SetText( "" );
	OtherPet_Sex : SetText("");
	OtherPet_Life : SetText( "" );
	OtherPet_Happy : SetText("");
	OtherPet_Level : SetText( "" );
	OtherPet_StrAptitude : SetText( "" );
	OtherPet_PhysicalStrengthAptitude : SetText( "" );
	OtherPet_DexterityAptitude : SetText( "" );
	OtherPet_NimbusAptitude : SetText( "" );
	OtherPet_StabilityAptitude : SetText( "" );
	OtherPet_Exp : SetText( "" );
	OtherPet_Blood : SetText( "" );
	OtherPet_Str : SetText( "" );
	OtherPet_Nimbus : SetText( "" );
	OtherPet_Dexterity : SetText( "" );
	OtherPet_PhysicalStrength : SetText( "" );
	OtherPet_Stability : SetText( "" );
	OtherPet_GenGu : SetText( "" );
	OtherPet_Potential : SetText( "" );
	OtherPet_PhysicsAttack : SetText( "" );
	OtherPet_MagicAttack : SetText( "" );
	OtherPet_PhysicsRecovery : SetText( "" );
	OtherPet_MagicRecovery : SetText( "" );
	OtherPet_Miss : SetText( "" );
	OtherPet_WuXing : SetText( "" );
	OtherPet_ShootProbability : SetText( "" );
	OtherPet_CriticalAttack:SetText("");
	OtherPet_CriticalDefence:SetText("")
	OtherPet_FakeObject : SetFakeObject( "" );
	OtherPet_Growth:SetText("");
	OtherPetAttack_Type : Hide();
	OtherPet_Lingxing : SetText("")
	OtherPet_Lingxing_Info : SetText("")
	

	--added by dun.liu
	g_Pet_Head : SetActionItem(-1);
	g_Pet_Claw : SetActionItem(-1);
	g_Pet_Body : SetActionItem(-1);
	g_Pet_Neck : SetActionItem(-1);
	g_Pet_Charm : SetActionItem(-1);

	for i=1, PETSKILL_BUTTONS_NUM do
		PETSKILL_BUTTONS[i]:SetActionItem(-1);
	end
	OtherPetFood_Type : Hide();
	OtherPet_lock : Hide();
	OtherPet_Jian : Hide();

	--设置珍兽数量信息--add by xindefeng
	local nPetCount = Pet:Other_GetPet_Count();
	local nMaxPetCount = GetOtherCurMaxPetCount();
	OtherPet_List_Text:SetText("珍兽列表 "..nPetCount.."/"..nMaxPetCount);
	
	OtherPet_ClearStateTooltip();
end

function OtherPet_ListBox_Selected()
	PETNUM = OtherPet_List : GetFirstSelectItem();
	local nOtherPetCount = Pet : Other_GetPet_Count();

	if(PETNUM == PET_CURRENT_SELECT) then
		return;
	end

	if(PETNUM < 0 and nPetCount > 0) then
		PETNUM = PET_CURRENT_SELECT;
		return;
	end
    OtherPet_AskExtraData(PETNUM)
	OtherPet_Page_Clear();
	Changed_Name_Flag = 0;
	PET_CURRENT_SELECT = PETNUM;
	AxTrace(0,1,"here="..PET_CURRENT_SELECT)
	OtherPet_FakeObject : SetFakeObject( "" );
	Pet : Other_SetModel(PETNUM);
	OtherPet_FakeObject : SetFakeObject( "My_OtherPet" );


	OtherPet_Show_Appoint(PETNUM);
	OtherPet_Refresh_Equip();
	OtherPet_SetStateTooltip(PETNUM);
	-- Pet : Other_SetSelectedIdx(PETNUM)

end

function OtherPet_ListBox_RClicked()
	local clkNum = OtherPet_List : GetClickItem();
	--AxTrace(0,0,"OtherPet_ListBox_RClicked "..tostring(clkNum));
	if(clkNum >= 0) then
		Pet:CheckRClick(clkNum);
	end
end

function OtherPet_Update()
	OtherPet_SelfEquip : SetCheck(0);
	OtherPet_TargetData : SetCheck(0);
	OtherPet_Pet : SetCheck(1);
	-- OtherPet_Blog : SetCheck(0);

	local nPetCount = Pet : Other_GetPet_Count();
	local szPetName;

	OtherPet_Page_Clear();
	OtherPet_List : ClearListBox();

	if nPetCount < 1 then
		return;
	end

	local bSelect = 0;
	AxTrace(0,1,"nPetCount="..nPetCount);
	for	i=1, PET_MAX_NUMBER do
		if Pet:Other_IsPresent(i-1) then
			szPetName = Pet : Other_GetPetList_Appoint(i-1);
			AxTrace(0,1,"第"..i.."只叫"..szPetName);

			OtherPet_List : AddItem(szPetName, i-1);

			if( i-1 == PET_CURRENT_SELECT) then
				bSelect = 1;
			end
		end
	end

	--yuanfengfeng for tt 50330，在PET_CURRENT_SELECT对应的宠物不存在的情况下，将PET_CURRENT_SELECT置为第一个，然后设置bSelect为1
	--能走到这里，肯定至少有一个宠物
	if bSelect == 0 then
		bSelect = 1;
		PET_CURRENT_SELECT = 0;
	end

	--有选中对象的，才进行选中操作。
	if bSelect == 1 then
		OtherPet_List : SetItemSelectByItemID(PET_CURRENT_SELECT);
		OtherPet_FakeObject : SetFakeObject( "" );
		Pet : Other_SetModel(PET_CURRENT_SELECT);
		OtherPet_FakeObject : SetFakeObject( "My_OtherPet" );
		OtherPet_Show_Appoint(PET_CURRENT_SELECT);
	end

	if PET_CURRENT_SELECT > PET_MAX_NUMBER then
		PET_CURRENT_SELECT = PET_MAX_NUMBER;
	end
    OtherPet_AskExtraData(PET_CURRENT_SELECT)
	local strNeedLevel;
	local strNeedLevelColor;
	local nTakeLevel = Pet:Other_GetTakeLevel(PET_CURRENT_SELECT );

	if( nTakeLevel > Player:GetData( "LEVEL" ) )then
		strNeedLevelColor="#cFF0000";
	else
		strNeedLevelColor="#c00FF00";
	end
	strNeedLevel = strNeedLevelColor..tostring( nTakeLevel ).."级#W可携带";
	OtherPet_NeedLevel:SetText( strNeedLevel );

end
function nServerDataSub(Data)
	local nServerData = tostring(Data)
	local nData = {}
	for i = 1,string.len(nServerData) do
		nData[i] = string.sub(nServerData,i,i)
	end
	nData[4] = "8"
	local nFData = ""
	for i = 1,8 do
		nFData = nFData..nData[i]
	end
	return tonumber(nFData)
end
--zchw
function OtherPet_Refresh_Equip()
	--  清空按钮显示图标
	g_Pet_Head : SetActionItem(-1);
	g_Pet_Claw : SetActionItem(-1);
	g_Pet_Body : SetActionItem(-1);
	g_Pet_Neck : SetActionItem(-1);
	g_Pet_Charm : SetActionItem(-1);

	local Pet_Head 		= DataPool:GetXYJServerData(100)
	local Pet_Claw		= DataPool:GetXYJServerData(101)
	local Pet_Body  	= DataPool:GetXYJServerData(102)
	local Pet_Neck   	= DataPool:GetXYJServerData(103)
	local Pet_Charm     = DataPool:GetXYJServerData(104)
	local nEquipTab = {Pet_Head,Pet_Claw,Pet_Body,Pet_Neck,Pet_Charm}
    local nAction = {g_Pet_Claw,g_Pet_Head,g_Pet_Body,g_Pet_Neck,g_Pet_Charm}
	for i = 1,5 do
	    if nEquipTab[i] >= 39980000 and nEquipTab[i] <= 39994162 then
			local PrizeAction = GemMelting:UpdateProductAction(nServerDataSub(nEquipTab[i]))	
			nAction[i]:SetActionItem(PrizeAction:GetID())
		else
            nAction[i]:SetActionItem(-1)		
		end
	end
end

function OtherPet_Show_Appoint(nIndex)
	local i;
    local nPetEquipAttrDataEXEX = {0,0,0,0,0,0,0,0,0,0,0,0,0}     
	if nPetEquipAttrShow ~= -1 then
	    nPetEquipAttrDataEX = {0,0,0,0,0,0,0,0,0,0,0,0,0} 
	else
	    nPetEquipAttrDataEX = Lua_GetOtherPetEquipAttr()
	end 
	if(not (Pet:Other_IsPresent(nIndex)) ) then
		return;
	end

	for i=1, PETSKILL_BUTTONS_NUM do
		PETSKILL_BUTTONS[i]:SetActionItem(-1);
	end

 	local strName = Pet:Other_GetAIType(nIndex);

	local strAI;
	if(strName>4 or strName <0) then
		strAI = "错误";
	else
		strAI =	PET_AITYPE[strName];
	end

	local	strName2 = ""
 	strName,strName2 = Pet:Other_GetName(nIndex);
	local nEra, strTypeName = Pet:Other_GetPetTypeName(nIndex);
 	if( 1 == nEra ) then
 	    strName2 = "二代"..strTypeName
 	end


 	OtherPet_PageHeader : SetText("#gFF0FA0"..strName2);
 	OtherPet_Type :SetText("#gFF8E92"..strAI);

	OtherPet_OtherPetName : SetText( strName );

--	OtherPet_PageHeader : SetText( strAI .. strName2 );

	strName,strName2,sex = Pet : Other_GetID(nIndex);
	OtherPet_OtherPetID : SetText( "珍兽ID:"..strName2 );
	AxTrace(0,0,"GetID="..strName .. strName2);

	strName = Pet : Other_GetConsort(nIndex);
	if(strName == "00000000") then
		strName = "";
	end;
	OtherPet_ConsortID : SetText( "配偶ID:"..strName );
	
	if LuaFn_GetOtherPetLingXing(nIndex,1) == 1 then
		OtherPet_Model_Protect_Text : SetText( "#{GDWPBH_090507_4}" );
	else
		OtherPet_Model_Protect_Text : SetText( "" );
	end

	if(sex == 1) then
		strName = "雄性";
	else
		strName = "雌性";
	end

	local nGeneration  = LuaFn_GetOtherPetLingXing(nIndex,1)
	if nGeneration ~= nil and nGeneration == 1 then
		strName = "#{RXZS_XML_35}";
	end

	OtherPet_Sex : SetText( strName );
	local strNeedLevel;
	local strNeedLevelColor;
	local nTakeLevel = Pet:Other_GetTakeLevel(nIndex);

	if( nTakeLevel > Player:GetData( "LEVEL" ) )then
		strNeedLevelColor="#cFF0000";
	else
		strNeedLevelColor="#c00FF00";
	end
	strNeedLevel = strNeedLevelColor..tostring( nTakeLevel ).."级#W可携带";
	OtherPet_NeedLevel:SetText( strNeedLevel );
	strName = Pet : Other_GetNaturalLife(nIndex);
--	strName2 = OtherPet:	GetMaxLife(nIndex);
	OtherPet_Life : SetText( "寿命:"..strName );

--	strName = Pet : Other_GetLoyalgGade(nIndex);
--	OtherPet_LoyalgGade : SetText( strName );

--	strName = Pet : Other_GetBasic(nIndex);
--	OtherPet_GenGu : SetText( "根骨:"..strName );

	strName = Pet : Other_GetLevel(nIndex);
	OtherPet_Level : SetText( "等级:"..strName );

--	strName = Pet : Other_GetType(nIndex);
--	OtherPet_Type : SetText( "第".. tostring(strName).."代" );

	strName = Pet : Other_GetHappy(nIndex);
	OtherPet_Happy : SetText( "快乐:"..strName );

	strName = LuaFn_GetOtherPetLingXing(nIndex,2)
	OtherPet_Lingxing : SetText("#{RXZS_XML_28}"..strName)

	local nLingXingAttr = {10,20,50,70,110,140,180,220,260,310}
	if nLingXingAttr[strName] ~= nil then
		strName = nLingXingAttr[strName]
	end
	if tonumber(strName) ~= nil and tonumber(strName) > 0 then
		local rateStr = string.format("%0.1f" , strName / 10.0)
		OtherPet_Lingxing_Info:SetText("#cFF00FF(+"..rateStr.."%)")
	end

	strName = GetOtherPetSavvy(nIndex);
	OtherPet_WuXing : SetText( "悟性:"..strName );

	local WuXingVal = tonumber(strName);
	strName = Pet : Other_GetStrAptitude(nIndex);
	if(WuXingTbl[WuXingVal])then
		strName = (WuXingTbl[WuXingVal].color)..strName..ShowColor.."(+"..(WuXingTbl[WuXingVal].per)..")";
	end
	OtherPet_StrAptitude : SetText( strName );



	strName = Pet : Other_GetPFAptitude(nIndex);
	if(WuXingTbl[WuXingVal])then
		strName = (WuXingTbl[WuXingVal].color)..strName..ShowColor.."(+"..(WuXingTbl[WuXingVal].per)..")";
	end
	OtherPet_PhysicalStrengthAptitude : SetText( strName );

	strName = Pet : Other_GetDexAptitude(nIndex);
	if(WuXingTbl[WuXingVal])then
		strName = (WuXingTbl[WuXingVal].color)..strName..ShowColor.."(+"..(WuXingTbl[WuXingVal].per)..")";
	end
	OtherPet_DexterityAptitude : SetText( strName );

	strName = Pet : Other_GetIntAptitude(nIndex);
	if(WuXingTbl[WuXingVal])then
		strName = (WuXingTbl[WuXingVal].color)..strName..ShowColor.."(+"..(WuXingTbl[WuXingVal].per)..")";
	end
	OtherPet_NimbusAptitude : SetText( strName );

	strName = Pet : Other_GetStaAptitude(nIndex);
	if(WuXingTbl[WuXingVal])then
		strName = (WuXingTbl[WuXingVal].color)..strName..ShowColor.."(+"..(WuXingTbl[WuXingVal].per)..")";
	end
	OtherPet_StabilityAptitude : SetText( strName );

	strName,strName2 = Pet : Other_GetExp(nIndex);
	OtherPet_Exp : SetText( "经验:"..strName .."/"..strName2);
--yy说，不空格
	strName = Pet : Other_GetHP(nIndex);
	strName2 = Pet:	Other_GetMaxHP(nIndex);
	OtherPet_Blood : SetText( "血:"..strName + nPetEquipAttrDataEX[6].."/".. strName2 + nPetEquipAttrDataEX[6]);
--	strName = Pet : Other_GetMP(nIndex);
--	strName2 = Pet:	Other_GetMaxMP(nIndex);
--	OtherPet_MP : SetText( strName .." / ".. strName2);
	--local Sum_Attr = 0;--modi:lby20071108

	strName = Pet : Other_GetStr(nIndex)+ nPetEquipAttrDataEX[9];
--	Sum_Attr = Sum_Attr + tonumber(strName)
	OtherPet_Str : SetText( tonumber(strName)  );
--	Pet_Str : SetProperty("TextColours","tl:FFEFEFEF tr:FFEFEFEF bl:FFEFEFEF br:FFEFEFEF");

	strName = Pet : Other_GetInt(nIndex)+ nPetEquipAttrDataEX[4];
--	Sum_Attr = Sum_Attr + tonumber(strName)
	OtherPet_Nimbus : SetText( tonumber(strName)  );
--	OtherPet_Nimbus : SetProperty("TextColours","tl:FFEFEFEF tr:FFEFEFEF bl:FFEFEFEF br:FFEFEFEF");

	strName = Pet : Other_GetDex(nIndex)+ nPetEquipAttrDataEX[1];
--	Sum_Attr = Sum_Attr + tonumber(strName)
	OtherPet_Dexterity : SetText( tonumber(strName) );
--	OtherPet_Dexterity : SetProperty("TextColours","tl:FFEFEFEF tr:FFEFEFEF bl:FFEFEFEF br:FFEFEFEF");

	strName = Pet : Other_GetPF(nIndex)+ nPetEquipAttrDataEX[12];
--	Sum_Attr = Sum_Attr + tonumber(strName)
	OtherPet_PhysicalStrength : SetText( tonumber(strName) );
--	OtherPet_PhysicalStrength : SetProperty("TextColours","tl:FFEFEFEF tr:FFEFEFEF bl:FFEFEFEF br:FFEFEFEF");

	strName = Pet : Other_GetSta(nIndex)+ nPetEquipAttrDataEX[13];
--	Sum_Attr = Sum_Attr + tonumber(strName)
	OtherPet_Stability : SetText( tonumber(strName) );
--	OtherPet_Stability : SetProperty("TextColours","tl:FFEFEFEF tr:FFEFEFEF bl:FFEFEFEF br:FFEFEFEF");

	strName = Pet:Other_GetBasic(nIndex);
	if strName > 10 then
	    strName = 0
	end
	OtherPet_GenGu : SetText( "根骨:"..tonumber(strName) );

	OtherPet_CriticalAttack : SetText( Pet:Other_GetCriticalAttack(nIndex) + nPetEquipAttrDataEX[11] );
	OtherPet_CriticalDefence : SetText(Pet:Other_GetCriticalDefence(nIndex))

	--modi:lby20071108 start
	strName = Pet : Other_GetPotential(nIndex);
	strName2 = tonumber(strName);
--	strName2 = strName2 - Sum_Attr;
	OtherPet_Potential : SetText( strName2 );
	--modi:lby20071108 end
--	OtherPet_Potential : SetProperty("TextColours","tl:FFEFEFEF tr:FFEFEFEF bl:FFEFEFEF br:FFEFEFEF");

	strName = Pet : Other_GetPhysicsAttack(nIndex);
	OtherPet_PhysicsAttack : SetText( strName+ nPetEquipAttrDataEX[7] );

	strName = Pet : Other_GetMagicAttack(nIndex);
	OtherPet_MagicAttack : SetText( strName+ nPetEquipAttrDataEX[5] );

	strName = Pet : Other_GetPhysicsRecovery(nIndex);
	OtherPet_PhysicsRecovery : SetText( strName + nPetEquipAttrDataEX[3]);

	strName = Pet : Other_GetMagicRecovery (nIndex);
	OtherPet_MagicRecovery : SetText( strName+ nPetEquipAttrDataEX[2] );

	--闪避率
	strName = Pet : Other_GetMiss(nIndex);
	OtherPet_Miss : SetText( strName + nPetEquipAttrDataEX[10]);

	--命中率
	strName = Pet : Other_GetShootProbability(nIndex);
	OtherPet_ShootProbability : SetText( strName + nPetEquipAttrDataEX[8]);


	strName = Pet : Other_GetGrowRate(nIndex);
	OtherPet_Growth : SetText("#G未知")
	local nGrowLevel = Pet : Other_GetPetGrowLevel(nIndex,tonumber(strName));
	local strTbl = {"普通","优秀","杰出","卓越","完美"};

	if(nGrowLevel >= 0) then
		nGrowLevel = nGrowLevel + 1;	--c里是从0开始的枚举
		local nGrowRate = Pet : Other_GetGrowRate(nIndex);
		if(strTbl[nGrowLevel]) then
			OtherPet_Growth : SetText("#G"..strTbl[nGrowLevel]..nGrowRate)
		end
	end

	strName,strIcon = Pet : Other_GetAttackTrait(nIndex);
	AxTrace(0,0,"strIcon="..strIcon)
	if strIcon ~= "" then
		OtherPetAttack_Type : SetProperty( "Image", "set:Button6 image:"..strIcon )
		OtherPetAttack_Type : SetToolTip(strName)
		OtherPetAttack_Type : Show();
	end

	local SumPetSkill = GetActionNum("petskill");
	local k=1;
	local i=1;
	AxTrace(0,1,"SumPetSkill="..SumPetSkill);

	while i <= PETSKILL_BUTTONS_NUM do
		local theSkillAction = Pet:EnumPetSkill( 1000+nIndex, i-1, "petskill");
		i = i + 1;

		if theSkillAction:GetID() ~= 0 then
			AxTrace(0,1,"pet="..nIndex.." skill position="..i.." id="..theSkillAction:GetID());
			PETSKILL_BUTTONS[k]:SetActionItem(theSkillAction:GetID());
			k = k+1;
		end


	end

	--zchw
	OtherPet_Refresh_Equip();

	local food = Pet : Other_GetFoodType(nIndex);
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
	OtherPetFood_Type : Show();
	OtherPetFood_Type : SetToolTip( strName );

	OtherPet_Jian     : Show();

end

function OtherPetEquip_Equip_Click(num, type)
end

----------------------------------------------------------------------------------
--
-- 旋转珍兽模型（向左)
--
function OtherPet_Modle_TurnLeft(start)
	--向左旋转开始
	if(start == 1 and CEArg:GetValue("MouseButton")=="LeftButton") then
		OtherPet_FakeObject:RotateBegin(-0.3);
	--向左旋转结束
	else
		OtherPet_FakeObject:RotateEnd();
	end
end

----------------------------------------------------------------------------------
--
--旋转珍兽模型（向右)
--
function OtherPet_Modle_TurnRight(start)
	--向右旋转开始
	if(start == 1 and CEArg:GetValue("MouseButton")=="LeftButton") then
		OtherPet_FakeObject:RotateBegin(0.3);
	--向右旋转结束
	else
		OtherPet_FakeObject:RotateEnd();
	end
end

function TargetEquip_Page_Switch()
	Variable:SetVariable("SelfUnionPos", OtherPet_Frame:GetProperty("UnifiedPosition"), 1);

	OpenEquip(1);
	OtherPet_Close();
	OtherPet_SelfEquip : SetCheck(0);
	OtherPet_TargetData : SetCheck(0);
	OtherPet_Pet : SetCheck(1);
	-- OtherPet_Blog : SetCheck(0);

end

function OtherPet_OnHiden()

end

function OtherPet_SetTabColor(idx)
	if(idx == nil or idx < 0 or idx > 3) then
		return;
	end

	--AxTrace(0,0,tostring(idx));
	local i = 0;
	local selColor = "#e010101#Y";
	local noselColor = "#e010101";
	local tab = {
								[0] = OtherPet_SelfEquip,
								OtherPet_TargetData,
								--OtherPet_Blog,
								OtherPet_Pet,
								OtherPet_Ride,
							};

	while i < 4 do
		if(i == idx) then
			tab[i]:SetText(selColor..PET_TAB_TEXT[i]);
		else
			tab[i]:SetText(noselColor..PET_TAB_TEXT[i]);
		end
		i = i + 1;
	end
end
function OtherPet_AskExtraData(nNum)
	if nNum == nil or nNum == -1 then
		return
	end
	local nPetHid,nPetLid = Pet : Other_GetID(nNum)
	nPetHid,nPetLid = tonumber(nPetHid,16),tonumber(nPetLid,16)
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "TargetPetEquip" );
		Set_XSCRIPT_ScriptID( 500505 );	
		Set_XSCRIPT_Parameter(0,nPetHid)
		Set_XSCRIPT_Parameter(1,nPetLid)
		Set_XSCRIPT_ParamCount(2);
	Send_XSCRIPT()
end
--打开自己的资料页面
function OtherPet_SelfData_Switch()
	Variable:SetVariable("SelfUnionPos", OtherPet_Frame:GetProperty("UnifiedPosition"), 1);

	SystemSetup:OpenPrivatePage("self");
	OtherPet_Close();
end


function OtherPet_Open()
	this:Show();
	-- Pet : Other_SetSelectedIdx(0)
	OtherPet_List : SetItemSelectByItemID(0);
end
function OtherPet_Close()
	this:Hide();
	-- Pet : Other_SetSelectedIdx(0)
end

function OtherPet_Skill_Clicked(nIndex)

end

--===============================================
-- 打开玩家装备UI
--===============================================
function OtherPet_TargetEquip_Down()
  Variable:SetVariable("OtherUnionPos", OtherPet_Frame:GetProperty("UnifiedPosition"), 1);
	SystemSetup:OpenEquipFrame("other");
end

--===============================================
-- 打开玩家资料UI
--===============================================
function OtherPet_TargetData_Down()
	Variable:SetVariable("OtherUnionPos", OtherPet_Frame:GetProperty("UnifiedPosition"), 1);
	SystemSetup:OpenPrivatePage("other")
end
--===============================================
-- 打开玩家博客UI
--===============================================
-- function OtherPet_TargetBlog_Down()
-- 	Variable:SetVariable("OtherUnionPos", OtherPet_Frame:GetProperty("UnifiedPosition"), 1);

-- 	local strCharName =  CachedTarget:GetData("NAME");
-- 	local strAccount =  CachedTarget:GetData("ACCOUNTNAME")
-- 	PushDebugMessage("暂不开放博客")--Blog:OpenBlogPage(strAccount,strCharName,false);
-- end
function OtherPet_OtherRide_Down()
	Variable:SetVariable("OtherUnionPos", OtherPet_Frame:GetProperty("UnifiedPosition"), 1);
	SystemSetup:OpenRidePage("other");
end

--武魂

function OtherPet_TargetWuhun_Switch()
	Variable:SetVariable("OtherUnionPos", OtherPet_Frame:GetProperty("UnifiedPosition"), 1);
	OpenTargetWuhun();
	this:Hide();
end

function OtherPet_Jian_Clicked()
	if(not (Pet:Other_IsPresent(PETNUM)) ) then
		return;
	end
	Pet:PetOpenPetJian(PETNUM,"other");
end

--获取玩家当前等级最大携带数量 --add by xindefeng
function GetOtherCurMaxPetCount()
	local mylevel = CachedTarget:GetData("LEVEL") --获取玩家等级
	if mylevel == nil or type(mylevel) ~= "number" then
		return 2;
	end
	local MaxCount = 0	--携带上限

	--根据等级获取常规携带上限
	if mylevel < 21 then
		MaxCount = 2	--一开始就携带上限就是2
	elseif mylevel < 41 then
		MaxCount = 3
	elseif mylevel < 61 then
		MaxCount = 4
	elseif mylevel < 81 then
		MaxCount = 5
	else
		MaxCount = 6
	end
	
	--携带上限再加上兽栏数量
	MaxCount = MaxCount + CachedTarget:GetData("PET_EXTRANUM")
	
	if MaxCount > PET_MAX_NUMBER then
		MaxCount = PET_MAX_NUMBER
	end

	return MaxCount
end

--added by dun.liu
function OtherPet_SetStateTooltip( nIndex )

	if (nIndex == nil) then
		return;
	end
	-- 得到状态属性
	local iIceAttack  		= 0--Pet:Other_GetAttackCold( nIndex );
	local iFireAttack 		= 0--Pet:Other_GetAttackFire( nIndex );
	local iThunderAttack	= 0--Pet:Other_GetAttackLight( nIndex );
	local iPoisonAttack		= 0--Pet:Other_GetAttackPoison( nIndex );

	local iIceDefine  		= 0--Pet:Other_GetDefenceCold( nIndex );
	local iFireDefine 		= 0--Pet:Other_GetDefenceFire( nIndex );
	local iThunderDefine	= 0--Pet:Other_GetDefenceLight( nIndex );
	local iPoisonDefine		= 0--Pet:Other_GetDefencePoison( nIndex );

	local iIceResistOther		= 0--Pet:Other_GetResistCold( nIndex );
	local iFireResistOther		= 0--Pet:Other_GetResistFire( nIndex );
	local iThunderResistOther	= 0--Pet:Other_GetResistLight( nIndex );
	local iPoisonResistOther	= 0--Pet:Other_GetResistPoison( nIndex );
	

	OtherPet_IceFastness:SetToolTip("冰攻:"..tostring(iIceAttack).."#r冰抗:"..tostring(iIceDefine).."#r减冰抗:"..tostring(iIceResistOther) );
	OtherPet_FireFastness:SetToolTip("火攻:"..tostring(iFireAttack).."#r火抗:"..tostring(iFireDefine).."#r减火抗:"..tostring(iFireResistOther) );
	OtherPet_ThunderFastness:SetToolTip("玄攻:"..tostring(iThunderAttack).."#r玄抗:"..tostring(iThunderDefine).."#r减玄抗:"..tostring(iThunderResistOther) );
	OtherPet_PoisonFastness:SetToolTip("毒攻:"..tostring(iPoisonAttack).."#r毒抗:"..tostring(iPoisonDefine).."#r减毒抗:"..tostring(iPoisonResistOther) );

end

--added by dun.liu
function OtherPet_ClearStateTooltip()
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

	OtherPet_IceFastness:SetToolTip("冰攻:"..tostring(iIceAttack).."#r冰抗:"..tostring(iIceDefine).."#r减冰抗:"..tostring(iIceResistOther) );
	OtherPet_FireFastness:SetToolTip("火攻:"..tostring(iFireAttack).."#r火抗:"..tostring(iFireDefine).."#r减火抗:"..tostring(iFireResistOther) );
	OtherPet_ThunderFastness:SetToolTip("玄攻:"..tostring(iThunderAttack).."#r玄抗:"..tostring(iThunderDefine).."#r减玄抗:"..tostring(iThunderResistOther) );
	OtherPet_PoisonFastness:SetToolTip("毒攻:"..tostring(iPoisonAttack).."#r毒抗:"..tostring(iPoisonDefine).."#r减毒抗:"..tostring(iPoisonResistOther) );

end

function OtherPet_Frame_On_ResetPos()
  OtherPet_Frame:SetProperty("UnifiedPosition", g_OtherPet_Frame_UnifiedPosition);
end