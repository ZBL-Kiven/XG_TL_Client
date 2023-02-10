--武魂系统
--2021-04-09 极致新增怀旧功能（仅供娱乐交流）
local Kfs_AttrEx_Text = {}
local Kfs_AttrEx_Value = {}
local KFS_ATTREX_MAX_NUM = 9
local Kfs_Base_Original_Text = {}
local Kfs_Base_Original_Value = {}
local Kfs_Base_Text = {}
local Kfs_Base_Value = {}
local Kfs_Skills = {}
local Kfs_Magic
local Kfs_EquipData = ""

local Kfs_Magic_Image = {}
local Kfs_Skill_ID = {}
--风、地、水、火
local Kfs_Magic_tips = {"#{WH_090817_04}" , "#{WH_090817_05}","#{WH_090817_06}","#{WH_090817_07}","#{WH_090817_08}"}
--力量、灵气、体力、身法、平衡
local Kfs_Att_tips = {"#{WH_xml_XX(53)}" , "#{WH_xml_XX(52)}" , "#{WH_xml_XX(54)}"  , "#{WH_xml_XX(60)}" , "#{WH_xml_XX(01)}"}
local Kfs_AttrEx_Mask_L = {}
local Kfs_AttrEx_Mask_R	=	{}
local isYYClicked = 0
local Kfs_AttrType = {
	[10156001] = 0,
	[10156002] = 1,
	[10156003] = 0,
	[10156004] = 1,
}
local g_AttrNameCtrl = {}
local g_AttrValueCtrl = {}
local comLevel = 0
local g_EffectDic = {
	"内功攻击",	--内功攻击
	"外功攻击",	--外功攻击
	"冰属性",	--冰属性
	"火属性",	--火属性
	"玄属性",	--玄属性
	"毒属性",	--毒属性
}
local g_strAttrDic = {
[6]="#{equip_attr_attack_cold}",
[9]="#{equip_attr_attack_fire}",
[12]="#{equip_attr_attack_light}",
[15]="#{equip_attr_attack_poison}",
[19]="#{equip_attr_attack_p}",
[26]="#{equip_attr_attack_m}",
}
local life = 0
-- 界面的默认相对位置
local g_Wuhun_Frame_UnifiedXPosition;
local g_Wuhun_Frame_UnifiedYPosition;

local g_CurrentSelWG = 0
local g_showPage = 0
local g_TupuBtn = {}
local g_TupuMask = {}
local nWuHunWG = {40005001,40005002,40005003,40005004,40005005,40005006}
local g_SwitchYYIndex = 0
function Wuhun_PreLoad()
	this:RegisterEvent("TOGGLE_WUHUN_PAGE");
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false);
	this:RegisterEvent("REFRESH_EQUIP");
    this:RegisterEvent("GEM_CONTAINER_REFRESH");
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("UPDATE_ACTION");
	this:RegisterEvent("UPDATE_WILLGET_MISSION_TRACK");		--升级
	this:RegisterEvent("TOGGLE_UPDATE_INFANT"); --子女有变化 刷新按钮状态
	this:RegisterEvent("FINISH_MISSION");
	this:RegisterEvent("UI_COMMAND");
end

function Wuhun_OnLoad()
	--AttrEx text
	Kfs_AttrEx_Mask_L[1] = Wuhun_Property1_Text
	Kfs_AttrEx_Mask_L[2] = Wuhun_Property2_Text
	Kfs_AttrEx_Mask_L[3] = Wuhun_Property3_Text
	Kfs_AttrEx_Mask_L[4] = Wuhun_Property4_Text
	Kfs_AttrEx_Mask_L[5] = Wuhun_Property5_Text
	Kfs_AttrEx_Mask_L[6] = Wuhun_Property6_Text
	Kfs_AttrEx_Mask_L[7] = Wuhun_Property7_Text
	Kfs_AttrEx_Mask_L[8] = Wuhun_Property8_Text
	Kfs_AttrEx_Mask_L[9] = Wuhun_Property9_Text
	Kfs_AttrEx_Mask_L[10] = Wuhun_Property10_Text
	--AttrEx value
	Kfs_AttrEx_Mask_R[1] = Wuhun_Property1
	Kfs_AttrEx_Mask_R[2] = Wuhun_Property2
	Kfs_AttrEx_Mask_R[3] = Wuhun_Property3
	Kfs_AttrEx_Mask_R[4] = Wuhun_Property4
	Kfs_AttrEx_Mask_R[5] = Wuhun_Property5
	Kfs_AttrEx_Mask_R[6] = Wuhun_Property6
	Kfs_AttrEx_Mask_R[7] = Wuhun_Property7
	Kfs_AttrEx_Mask_R[8] = Wuhun_Property8
	Kfs_AttrEx_Mask_R[9] = Wuhun_Property9
	Kfs_AttrEx_Mask_R[10] = Wuhun_Property10
	g_TupuBtn[1] = Wuhun_TupuItem_1
	g_TupuBtn[2] = Wuhun_TupuItem_2
	g_TupuBtn[3] = Wuhun_TupuItem_3
	g_TupuBtn[4] = Wuhun_TupuItem_4
	g_TupuBtn[5] = Wuhun_TupuItem_5
	g_TupuBtn[6] = Wuhun_TupuItem_6
	
	g_TupuMask[1] = Wuhun_TupuItem_1Mask
	g_TupuMask[2] = Wuhun_TupuItem_2Mask
	g_TupuMask[3] = Wuhun_TupuItem_3Mask
	g_TupuMask[4] = Wuhun_TupuItem_4Mask
	g_TupuMask[5] = Wuhun_TupuItem_5Mask
	g_TupuMask[6] = Wuhun_TupuItem_6Mask

	Kfs_AttrEx_Text[1] = Wuhun_Property1_Text_UnVisible;
	Kfs_AttrEx_Text[2] = Wuhun_Property2_Text_UnVisible;
	Kfs_AttrEx_Text[3] = Wuhun_Property3_Text_UnVisible;
	Kfs_AttrEx_Text[4] = Wuhun_Property4_Text_UnVisible;
	Kfs_AttrEx_Text[5] = Wuhun_Property5_Text_UnVisible;
	Kfs_AttrEx_Text[6] = Wuhun_Property6_Text_UnVisible;
	Kfs_AttrEx_Text[7] = Wuhun_Property7_Text_UnVisible;
	Kfs_AttrEx_Text[8] = Wuhun_Property8_Text_UnVisible;
	Kfs_AttrEx_Text[9] = Wuhun_Property9_Text_UnVisible;
	Kfs_AttrEx_Text[10] = Wuhun_Property10_Text_UnVisible;

	Kfs_AttrEx_Value[1] = Wuhun_Property1_UnVisible;
	Kfs_AttrEx_Value[2] = Wuhun_Property2_UnVisible;
	Kfs_AttrEx_Value[3] = Wuhun_Property3_UnVisible;
	Kfs_AttrEx_Value[4] = Wuhun_Property4_UnVisible;
	Kfs_AttrEx_Value[5] = Wuhun_Property5_UnVisible;
	Kfs_AttrEx_Value[6] = Wuhun_Property6_UnVisible;
	Kfs_AttrEx_Value[7] = Wuhun_Property7_UnVisible;
	Kfs_AttrEx_Value[8] = Wuhun_Property8_UnVisible;
	Kfs_AttrEx_Value[9] = Wuhun_Property9_UnVisible;
	Kfs_AttrEx_Value[10] = Wuhun_Property10_UnVisible;
	--Original five text
	Kfs_Base_Original_Text[1] = Wuhun_OriginalStr_Text
	Kfs_Base_Original_Text[2] = Wuhun_OriginalNimbus_Text
	Kfs_Base_Original_Text[3] = Wuhun_OriginalPhysicalStrength_Text
	Kfs_Base_Original_Text[4] = Wuhun_OriginalStability_Text
	Kfs_Base_Original_Text[5] = Wuhun_OriginalFootwork_Text
	--Original five value
	Kfs_Base_Value[1] = Wuhun_OriginalStr
	Kfs_Base_Value[2] = Wuhun_OriginalNimbus
	Kfs_Base_Value[3] = Wuhun_OriginalPhysicalStrength
	Kfs_Base_Value[4] = Wuhun_OriginalStability
	Kfs_Base_Value[5] = Wuhun_OriginalDexterity
	--five text
	Kfs_Base_Text[1] = Wuhun_Str_Text
	Kfs_Base_Text[2] = Wuhun_Nimbus_Text
	Kfs_Base_Text[3] = Wuhun_PhysicalStrength_Text
	Kfs_Base_Text[4] = Wuhun_Stability_Text
	Kfs_Base_Text[5] = Wuhun_Footwork_Text
	--five value
	Kfs_Base_Original_Value[1] = Wuhun_Str
	Kfs_Base_Original_Value[2] = Wuhun_Nimbus
	Kfs_Base_Original_Value[3] = Wuhun_PhysicalStrength
	Kfs_Base_Original_Value[4] = Wuhun_Stability
	Kfs_Base_Original_Value[5] = Wuhun_Dexterity
	--skills
	Kfs_Skills[1] = Wuhun_Skill2
	Kfs_Skills[2] = Wuhun_Skill3
	Kfs_Skills[3] = Wuhun_Skill4
	--magic
	Kfs_Magic = Wuhun_Skill1
	--magic image

	Kfs_Magic_Image[1] = "set:Wuhun4 image:Wuhun4_2"
	Kfs_Magic_Image[2] = "set:Wuhun4 image:Wuhun4_1"
	Kfs_Magic_Image[3] = "set:Wuhun4 image:Wuhun4_4"
	Kfs_Magic_Image[4] = "set:Wuhun4 image:Wuhun4_3"

    ----Wuhun_BaoShiCheck_tips : Hide()

	-- 保存界面的默认相对位置
	g_Wuhun_Frame_UnifiedXPosition	= Wuhun_Frame : GetProperty("UnifiedXPosition");
	g_Wuhun_Frame_UnifiedYPosition	= Wuhun_Frame : GetProperty("UnifiedYPosition");
    if IsWindowShow("HuanLing") or IsWindowShow("Infant") then
	   CloseWindow("HuanLing", true)
	   CloseWindow("Infant", true)
	end
	if IsWindowShow("PetSoul_Handbook") then
		CloseWindow("PetSoul_Handbook", true)
	end
	g_AttrNameCtrl[1] = Wuhun_BK4_Info2_Info1
	g_AttrNameCtrl[2] = Wuhun_BK4_Info2_Info2
	g_AttrNameCtrl[3] = Wuhun_BK4_Info2_Info3
	g_AttrNameCtrl[4] = Wuhun_BK4_Info2_Info4
	g_AttrNameCtrl[5] = Wuhun_BK4_Info2_Info5
	g_AttrNameCtrl[6] = Wuhun_BK4_Info2_Info6
	g_AttrNameCtrl[7] = Wuhun_BK4_Info2_Info7
	g_AttrNameCtrl[8] = Wuhun_BK4_Info2_Info8
	
	g_AttrValueCtrl[1] = Wuhun_BK4_Info2_Number1
	g_AttrValueCtrl[2] = Wuhun_BK4_Info2_Number2
	g_AttrValueCtrl[3] = Wuhun_BK4_Info2_Number3
	g_AttrValueCtrl[4] = Wuhun_BK4_Info2_Number4
	g_AttrValueCtrl[5] = Wuhun_BK4_Info2_Number5
	g_AttrValueCtrl[6] = Wuhun_BK4_Info2_Number6
	g_AttrValueCtrl[7] = Wuhun_BK4_Info2_Number7
	g_AttrValueCtrl[8] = Wuhun_BK4_Info2_Number8
	
end

function Wuhun_OnEvent(event)

	if ( event == "UPDATE_WILLGET_MISSION_TRACK" ) or (event=="TOGGLE_UPDATE_INFANT")  or (event == "FINISH_MISSION") then
		local nLevel =Player:GetData("LEVEL")
		-- Wuhun_Refresh_Page_Button(nLevel)
	end

	if( event == "HIDE_ON_SCENE_TRANSED") then

		this:Hide();
		return;
	end
    if ( event == "UI_COMMAND" and tonumber(arg0) == 890196 ) or
	   ( event == "UI_COMMAND" and tonumber(arg0) == 890985 )
	then
		if (this:IsVisible()) then
			this:Hide()
			return
		end
	end	
	if (event == "UI_COMMAND" and tonumber(arg0) == 20181030 ) then
		if IsWindowShow("PetSoul_Handbook") then
			CloseWindow("PetSoul_Handbook", true)
		end
		Kfs_EquipData = Get_XParam_STR(0)
		if(this:IsVisible()) then
			this:Hide();
			return;
		end
		g_CurrentSelWG = 0
		g_showPage = 0
		g_SwitchYYIndex = Get_XParam_INT(0)
		local a = DataPool:GetPlayerMission_DataRound(357)
		-- Wuhun_Mode:SetCheck(a)
		Wuhun_FakeObject:SetFakeObject( "" );
		Wuhun_Update()
		this:Show();
		local nLevel =Player:GetData("LEVEL")
		-- Wuhun_Refresh_Page_Button(nLevel)
	end
	if (event == "UI_COMMAND" and tonumber(arg0) == 1000000030 and this:IsVisible() ) then
		Kfs_EquipData = Get_XParam_STR(0)
		Wuhun_Update()
	end
	if (event == "UI_COMMAND" and tonumber(arg0) == 20210417 and this:IsVisible() ) then
		Wuhun_UpdateTupu()
		Wuhun_UpdateSlot()
	end
	if( event == "UPDATE_ACTION" or event == "REFRESH_EQUIP" and this:IsVisible() ) then
		local n1,n2,n3,n4,n5,n6,n7,_,n9,f10,n11,n12,n13,n14,n15 = SystemSetup:GameGetData();
		SystemSetup:SaveGameSetup ( n1,n2,n3,n4,n5,n6,n7,1,n9,tonumber(f10),n11,n12,1,n14,n15 );
		if this:IsVisible() then
			Variable:SetVariable("SelfUnionPos", Wuhun_Frame:GetProperty("UnifiedPosition"), 1);
			Wuhun_Update()
		end
    elseif ( event == "GEM_CONTAINER_REFRESH" ) then
		Wuhun_Update()
	-- 游戏窗口尺寸发生了变化
	elseif (event == "ADJEST_UI_POS" ) then
		-- 更新背包界面位置
		Wuhun_Frame_On_ResetPos()

	-- 游戏分辨率发生了变化
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		-- 更新背包界面位置
		Wuhun_Frame_On_ResetPos()
	end

end

function Wuhun_OnShowClick()
	local bc = Wuhun_Show:GetCheck()
	local n1,n2,n3,n4,n5,n6,n7,_,n9,f10,n11,n12,n13,n14,n15 = SystemSetup:GameGetData();
	if bc == 1 then
		SystemSetup:SaveGameSetup ( n1,n2,n3,n4,n5,n6,n7,1,n9,tonumber(f10),n11,n12,1,n14,n15 );
	else
		SystemSetup:SaveGameSetup ( n1,n2,n3,n4,n5,n6,n7,0,n9,tonumber(f10),n11,n12,1,n14,n15 );
	end
end

--Update
function Wuhun_Update()
    local nFlang = DataPool:GetPlayerMission_DataRound(169)
	if nFlang > 0 then
		Wuhun_FakeObject_ShowCheck:SetCheck(1)
	else	
		Wuhun_FakeObject_ShowCheck:SetCheck(0)
	end
	Wuhun_Wuhun:SetCheck(1)
	--Pos
	local selfUnionPos = Variable:GetVariable("SelfUnionPos");
	if(selfUnionPos ~= nil) then
		Wuhun_Frame:SetProperty("UnifiedPosition", selfUnionPos);
	end
	--Title
	Wuhun_PageHeader:SetText("#gFF0FA0#{WH_xml_XX(95)}")

	local ActionKFS = EnumAction(18,"equip")
	local data = ActionKFS:GetName()
	Kfs_Skills[1]:SetProperty("UseDefaultTooltip", "True")
	Kfs_Skills[2]:SetProperty("UseDefaultTooltip", "True")
	Kfs_Skills[3]:SetProperty("UseDefaultTooltip", "True")
	Kfs_Skills[1]:SetToolTip("")
	Kfs_Skills[2]:SetToolTip("")
	Kfs_Skills[3]:SetToolTip("")

	if data ~= nil then
		Wuhun_PageHeader:SetText("#gFF0FA0"..tostring(data))
		Wuhun_Name:SetText("#gFF0FA0"..tostring(data))
		Kfs_Skills[1]:SetToolTip("#{WU_090908_02}")
		Kfs_Skills[2]:SetToolTip("#{WU_090908_03}")
		Kfs_Skills[3]:SetToolTip("#{WU_090908_04}")
	end
	--KFS data
	local nGrow,nExLevel,nLevel,nExp,nMagic,nExAttrNum,nExAttr,nSkill = LuaGetKfsAttrData(Kfs_EquipData)
	--ICON
	Wuhun_Equip_Mask:Hide()

	Wuhun_Equip:SetActionItem(-1)
	Wuhun_Equip:SetActionItem(ActionKFS:GetID());
	--Model
	Wuhun_FakeObject:SetFakeObject( "" );
	local nVisualID = LifeAbility:Get_UserEquip_VisualID(18);
	if nVisualID ~= -1 and nFlang == 0 then
		nVisualID = nVisualID + nMagic;
		CachedTarget : SetHorseModel(nVisualID);
		Wuhun_FakeObject:SetFakeObject("Other_Horse");
	elseif nVisualID ~= -1 and nFlang ~= 0 then
		CachedTarget : SetHorseModel(DataPool:GetPlayerMission_DataRound(357));
		Wuhun_FakeObject:SetFakeObject("Other_Horse");		
	else
		Wuhun_FakeObject:SetFakeObject( "" );
	end

	--NeedLv
	-- Wuhun_NeedLevel_Text:SetText("")
	
	local _,_,nNeedLv = LifeAbility:GetPrescr_Material_Tooltip(ActionKFS:GetDefineID());
	if nNeedLv ~= nil then
		--百兵精通
		if DataPool:GetPlayerMission_DataRound(309) > 0 then
			nNeedLv = nNeedLv - 10;
		end
		if nNeedLv < 0 then
			nNeedLv = 0;
		end
		if Player:GetData("LEVEL") < nNeedLv then
			Wuhun_Equip_Mask:Show()
		end
		-- Wuhun_NeedLevel_Text:SetText(tostring(nNeedLv))
	end

	--Lv
	Wuhun_Level_Text:SetText("")
	if nLevel ~= nil then
		Wuhun_Level_Text:SetText(tostring(nLevel))
	end

	--ExtraLevel
	Wuhun_ExtraLevel_Text:SetText("")
	if nExLevel ~= nil then
		Wuhun_ExtraLevel_Text:SetText(tostring(nExLevel))
		comLevel = tonumber(nExLevel)
	end

	--AttactType
	Wuhun_Type:SetText("")
	local AttactType = Kfs_AttrType[ActionKFS:GetDefineID()]
	if AttactType ~= nil and AttactType < 5 and AttactType >= 0 then
		Wuhun_Type:SetText(Kfs_Att_tips[AttactType + 1])
	end

	--Life
	Wuhun_Life_Text2:SetText("")

	data = LifeAbility:Get_UserEquip_Current_Durability(18);
	local maxLife = LifeAbility:Get_UserEquip_Maximum_Durability(18);
	if data ~= nil then
		life = data
		if data < 0 then
			data = 0;
		end
		if maxLife < 0 then
			maxLife = 0;
		end
		Wuhun_Life_Text2:SetText(tostring(data).."/"..tostring(maxLife))
		if data < 16 then
			Wuhun_Equip_Mask:Show()
		end
	end

	--Exp
	Wuhun_Exp:SetText("#{WH_xml_XX(76)}")
	if nLevel ~= nil then
		local needexp = Lua_KfsGetLevelUpNeedExp(tonumber(nLevel))
		if nExp ~= nil then
			Wuhun_Exp_Text:SetText(tostring(nExp).."/"..tostring(needexp))
		end
	end
	
	--GrowRate
	Wuhun_Growth1:SetText("")
	Wuhun_Growth1:SetToolTip("")
	Wuhun_Growth:SetText("")
	Wuhun_Growth:SetToolTip("")
	local grade = Lua_GetKfsDataGrade(nGrow)
	local nFixnGrow = nGrow
	if nGrow ~= nil and grade ~= nil and maxLife ~= 0 then
		Wuhun_Growth1:SetText("#{WH_xml_XX(93)}")
		Wuhun_Growth1:SetToolTip("#{WH_090729_43}")
	  if grade == 0 then
			Wuhun_Growth:SetText("#G#{ZSKSSJ_PT}"..tostring(nGrow))
	  elseif grade == 1 then
			Wuhun_Growth:SetText("#G#{ZSKSSJ_YX}"..tostring(nGrow))
	  elseif grade == 2 then
			Wuhun_Growth:SetText("#G#{ZSKSSJ_JC}"..tostring(nGrow))
	  elseif grade == 3 then
			Wuhun_Growth:SetText("#G#{ZSKSSJ_ZY}"..tostring(nGrow))
	  elseif grade == 4 then
			Wuhun_Growth:SetText("#G#{ZSKSSJ_WM}"..tostring(nGrow))
	  end
	end
	Wuhun_UpdateTupu()
	Wuhun_UpdateSlot()

	--AttrEx
	for i = 1,KFS_ATTREX_MAX_NUM do

		Kfs_AttrEx_Text[i]:SetText("")
		Kfs_AttrEx_Value[i]:SetText("")

		if nExAttrNum ~= nil and i <= nExAttrNum then
			Kfs_AttrEx_Text[i]:Show()
			Kfs_AttrEx_Value[i]:Show()
		else
			Kfs_AttrEx_Text[i]:Hide()
			Kfs_AttrEx_Value[i]:Hide()
		end

		local iText , iValue = Lua_GetKfsFixAttrEx(nExAttr,i,nFixnGrow)
		if iText ~= nil and iText ~= "" and iValue ~= nil and iValue > 0 and maxLife ~= 0 then
			Kfs_AttrEx_Text[i]:SetText(iText)
			Kfs_AttrEx_Value[i]:SetText("+"..tostring(iValue))
		end
	end

	--BaseAttr
	for i = 1,5 do
		Kfs_Base_Original_Value[i]:SetText("")
		Kfs_Base_Value[i]:SetText("")
		local nBaseAttr,nOldBaseAttr = Lua_KfsGetAttrAndOldAttr(i,nGrow,AttactType,nLevel)
		if nOldBaseAttr ~= nil then
			Kfs_Base_Original_Value[i]:SetText("+"..tostring(nOldBaseAttr))
		end
		if nBaseAttr ~= nil then
			Kfs_Base_Value[i]:SetText("+"..tostring(nBaseAttr))
		end
	end

	--SKills
	Kfs_Skills[1]:SetActionItem(-1)
	Kfs_Skills[2]:SetActionItem(-1)
	Kfs_Skills[3]:SetActionItem(-1)
	
	local nSumSkill = GetActionNum("skill");
	for i = 1,3 do
		local skillID = Lua_GetKfsSkill(nSkill,i)
		if skillID ~= nil and skillID > 0 then
			Kfs_Skill_ID[i] = skillID
		else
			Kfs_Skill_ID[i] = -1
		end
	end

	for i=1, nSumSkill do
		local theAction = EnumAction(i-1, "skill");
		if theAction:GetOwnerXinfa() == -9999 then
			if theAction:GetDefineID() == Kfs_Skill_ID[1] then
				Kfs_Skills[1]:SetActionItem(theAction:GetID());
				
			elseif theAction:GetDefineID() == Kfs_Skill_ID[2] then
				Kfs_Skills[2]:SetActionItem(theAction:GetID());

			elseif theAction:GetDefineID() == Kfs_Skill_ID[3] then
				Kfs_Skills[3]:SetActionItem(theAction:GetID());
			end
		end
	end
	if g_showPage == 0 then
		Wuhun_Page1:SetCheck(1)
		Wuhun_Page2:SetCheck(0)
		Wuhun_Page1Client:Show()
		Wuhun_Page2Client:Hide()
	else
		Wuhun_Page1:SetCheck(0)
		Wuhun_Page2:SetCheck(1)
		Wuhun_Page1Client:Hide()
		Wuhun_Page2Client:Show()
	end
	--Magic
	-- Kfs_Magic:SetProperty("NormalImage" ,"" )
	-- Kfs_Magic:SetToolTip("")
	--风、地、水、火
	if nMagic ~= nil and nMagic < 5 and nMagic >= 0 and maxLife ~= 0 then
		-- Kfs_Magic:SetProperty("Empty", "False")
		if nMagic > 0 then
			-- Kfs_Magic:SetProperty("NormalImage" , Kfs_Magic_Image[nMagic] )
		end
		-- Kfs_Magic:SetToolTip(Kfs_Magic_tips[nMagic+1])
	end

    --- 更新一键换宝石显示
    Wuhun_UpdateGemContainer( )
end
function Wuhun_UpdateSlot()

	Wuhun_BK4_Tupu1_Mask:Hide()
	Wuhun_BK4_Tupu2_Mask:Hide()
	
	Wuhun_BK4_Tupu1:SetActionItem(-1)
	Wuhun_BK4_Tupu2:SetActionItem(-1)
	
	Wuhun_BK4_Tupu1:SetProperty("Empty", "False")
	Wuhun_BK4_Tupu2:SetProperty("Empty", "False")
	
	Wuhun_BK4_Tupu1:SetToolTip("")
	Wuhun_BK4_Tupu2:SetToolTip("")
	
	local bHaveKfs = 1
	
	if tonumber(comLevel) == nil then
		bHaveKfs = 0
	end
	
	if tonumber(life) == nil then
		bHaveKfs = 0
	end
	
	local yangWg = DataPool:GetPlayerMission_DataRound(197)
	local yinWg = DataPool:GetPlayerMission_DataRound(198)
	-- local attr_count = LuaFnGetWHWGAllAttrCount()
	
	local isValid = 1
	Wuhun_BK4_Info3:SetText("")
	if yangWg > 0 or yinWg > 0  then
		if bHaveKfs == 0 or comLevel < 5 or life <= 0 then
			local strTemp = "#cfff263（装备合成等级达5级后生效）"
			Wuhun_BK4_Info3:SetText(strTemp)
			isValid = 0
		end
	end
	
	local errColor = "#c808080"
	if isValid == 1 then
		errColor = "#cfff263"
	end
	
	local myLevel = Player:GetData("LEVEL")
	
	local strYangEffect = ""
	local strYangValue = ""
	local strYangattr = ""
	local strYangattrvalue = ""
	
	local strYinEffect = ""
	local strYinValue = ""
	local strYinattr = ""
	local strYinattrvalue = ""
	
	if yangWg > 0 then
		local theAction = GemMelting:UpdateProductAction(DataPool:GetPlayerMission_DataRound(197))
		if theAction:GetID() ~= 0 then
			Wuhun_BK4_Tupu1:SetActionItem(theAction:GetID())
		end
		yangWg = math.mod(yangWg,10)
		local strName = LuaFnGetWHWGInfo(yangWg, "Name")
		local grade = LuaFnGetWHWGInfo(yangWg, "Grade")
		local level = LuaFnGetWHWGInfo(yangWg, "Level")
		
		-- local strYang, strYin, strFree = DataPool:LuaFnWHWGAttrSTR(yangWg, grade, level)
		
		local attr_yang,attrvalue_yang,effecttype_yang,effectvalue_yang = LuaFnGetWHWGLevelInfo(yangWg, grade, level,"AttrEffectYang")
		if effecttype_yang ~= nil and effecttype_yang >= 0 and effecttype_yang <= 5 then
			strYangEffect = string.format("%s伤害增加", g_EffectDic[effecttype_yang + 1])
			strYangValue = string.format("%.2f%%",effectvalue_yang*0.01)
			strYangattr = g_strAttrDic[attr_yang]
			strYangattrvalue = attrvalue_yang
		end
	else		
		Wuhun_BK4_Tupu1:SetProperty("NormalImage", "")
		Wuhun_BK4_Tupu1:SetProperty("UseDefaultTooltip", "True")
		if myLevel < 80 then
			Wuhun_BK4_Tupu1:SetToolTip("#Y等级达到80级后可进行幻魂填入。")
		else
			Wuhun_BK4_Tupu1:SetToolTip("#Y尚未填入幻魂，无幻魂效果。")
		end		
	end
	
	if yinWg > 0 then
		local theAction = GemMelting:UpdateProductAction(DataPool:GetPlayerMission_DataRound(198))
		if theAction:GetID() ~= 0 then
			Wuhun_BK4_Tupu2:SetActionItem(theAction:GetID())
		end
		yinWg = math.mod(yinWg,10)
		local strName = LuaFnGetWHWGInfo(yinWg, "Name")
		local grade = LuaFnGetWHWGInfo(yinWg, "Grade")
		local level = LuaFnGetWHWGInfo(yinWg, "Level")
		
		-- local strYang, strYin, strFree = LuaFnWHWGAttrSTR(yinWg, grade, level)
		
		local attr_yin,attrvalue_yin,effecttype_yin,effectvalue_yin = LuaFnGetWHWGLevelInfo(yinWg, grade, level,"AttrEffectYin")
		if effecttype_yin ~= nil and effecttype_yin >= 0 and effecttype_yin <= 5 then
			strYinEffect = string.format("受%s伤害降低", g_EffectDic[effecttype_yin + 1])
			strYinValue =string.format("%.2f%%",effectvalue_yin*0.01)
			strYinattr = g_strAttrDic[attr_yin]
			strYinattrvalue = attrvalue_yin
		end
	else		
		Wuhun_BK4_Tupu2:SetProperty("NormalImage", "")
		Wuhun_BK4_Tupu2:SetProperty("UseDefaultTooltip", "True")
		if myLevel < 80 then
			Wuhun_BK4_Tupu2:SetToolTip("#Y等级达到80级后可进行幻魂填入。")
		else
			Wuhun_BK4_Tupu2:SetToolTip("#Y尚未填入幻魂，无幻魂效果。")
		end		
	end

	local nowIndex = 1
	local nMD = {203,204,205,206,207,208}
	local nSolt = {197,198}
	--二级属性
	for i = 1, 8 do
		g_AttrNameCtrl[i]:Hide()
		g_AttrValueCtrl[i]:Hide()
		-- local strAttr, strValue = LuaFnGetWHWGAllAttrDesc(i)
		-- if strAttr == "" then

		-- else
			-- g_AttrNameCtrl[i]:Show()
			-- g_AttrValueCtrl[i]:Show()
			-- g_AttrNameCtrl[i]:SetText(errColor..strAttr)
			-- g_AttrValueCtrl[i]:SetText(errColor..strValue)
			-- nowIndex = nowIndex + 1
		-- end
	end
	--收集属性
	local yang = DataPool:GetPlayerMission_DataRound(197)
	local yin = DataPool:GetPlayerMission_DataRound(198)
	if yang ~= 0 then
		nMD[math.mod(yang,10)] = 0
	end
	if yin ~= 0 then
		nMD[math.mod(yin,10)] = 0
	end
	for i = 1,6 do
		if nMD[i] ~= 0 then
			if DataPool:GetPlayerMission_DataRound(nMD[i]) ~= 0 then
				local nGrade = LuaFnGetWHWGInfo(i,"Grade")
				local nLevel = LuaFnGetWHWGInfo(i,"Level")
				local strAttr,strValue = LuaFnGetWHWGLevelInfo(i,nGrade,nLevel,"wszAttr")
				g_AttrNameCtrl[nowIndex]:Show()
				g_AttrValueCtrl[nowIndex]:Show()
				g_AttrNameCtrl[nowIndex]:SetText(errColor..g_strAttrDic[strAttr])
				g_AttrValueCtrl[nowIndex]:SetText(errColor..strValue)
				nowIndex = nowIndex + 1
			end
		end
	end
	if nowIndex <= 8 then
		if strYangattr ~= "" then
			g_AttrNameCtrl[nowIndex]:Show()
			g_AttrValueCtrl[nowIndex]:Show()
			g_AttrNameCtrl[nowIndex]:SetText(errColor..strYangattr)
			g_AttrValueCtrl[nowIndex]:SetText(errColor..strYangattrvalue)
			nowIndex = nowIndex + 1
		end	
	end	
	if nowIndex <= 8 then
		if strYinattr ~= "" then
			g_AttrNameCtrl[nowIndex]:Show()
			g_AttrValueCtrl[nowIndex]:Show()
			g_AttrNameCtrl[nowIndex]:SetText(errColor..strYinattr)
			g_AttrValueCtrl[nowIndex]:SetText(errColor..strYinattrvalue)
			nowIndex = nowIndex + 1
		end	
	end	
	if nowIndex <= 8 then
		if strYangEffect ~= "" then
			g_AttrNameCtrl[nowIndex]:Show()
			g_AttrValueCtrl[nowIndex]:Show()
			g_AttrNameCtrl[nowIndex]:SetText(errColor..strYangEffect)
			g_AttrValueCtrl[nowIndex]:SetText(errColor..strYangValue)
			nowIndex = nowIndex + 1
		end	
	end	
	if nowIndex <= 8 then
		if strYinEffect ~= "" then
			g_AttrNameCtrl[nowIndex]:Show()
			g_AttrValueCtrl[nowIndex]:Show()
			g_AttrNameCtrl[nowIndex]:SetText(errColor..strYinEffect)
			g_AttrValueCtrl[nowIndex]:SetText(errColor..strYinValue)
		end	
	end
end
function Wuhun_UpdateSwitch()
	
	if isYYClicked == 1 then
		isYYClicked = 0
		return
	end
	
	if g_showPage == 0 then
		Wuhun_Page1:SetCheck(1)
		Wuhun_Page2:SetCheck(0)
	else
		Wuhun_Page1:SetCheck(0)
		Wuhun_Page2:SetCheck(1)
	end
end
function Wuhun_UpdateTupu()
	
	local nCount = 6
	
	local yangWg = math.mod(DataPool:GetPlayerMission_DataRound(197),10)
	local yinWg = math.mod(DataPool:GetPlayerMission_DataRound(198),10)
	
	for idx = 1, 6 do
		
		g_TupuBtn[idx]:SetProperty("DraggingEnabled", "False")
		
		if idx <= nCount then	
			local wgID = LuaFnGetWHWGIDFromList(idx)
			local nUnLocked = LuaFnGetWHWGInfo(wgID, "UnLocked")
			local nLevel = LuaFnGetWHWGInfo(wgID, "Level")
			local nGrade = LuaFnGetWHWGInfo(wgID, "Grade")
			local strName = LuaFnGetWHWGInfo(wgID, "Name")
		
			--激活锁
			if nUnLocked == 1 then
				g_TupuMask[idx]:Hide()
			else
				g_TupuMask[idx]:Show()
			end

			g_TupuBtn[idx]:SetActionItem(-1)
			local theAction = GemMelting:UpdateProductAction(wgID)
			if theAction:GetID() ~= 0 then
				g_TupuBtn[idx]:SetActionItem(theAction:GetID())
			end

			-- if wgID == g_CurrentSelWG then
				-- g_TupuBtn[idx]:SetPushed(1)
			-- else
				-- g_TupuBtn[idx]:SetPushed(0)
			-- end
		else
			g_TupuBtn[idx]:SetActionItem(-1)	
			g_TupuMask[idx]:Hide()		
		end
	end
	
	if g_CurrentSelWG == 0 then
		Wuhun_BK4_OK1:SetText("#cfff263填入乾位")
		Wuhun_BK4_OK1:SetToolTip("#Y选中已激活的幻魂填入至乾位。")
		
		Wuhun_BK4_OK2:SetText("#cfff263填入坤位")
		Wuhun_BK4_OK2:SetToolTip("#Y选中已激活的幻魂填入至坤位。")
	else
		local nUnLocked = LuaFnGetWHWGInfo(g_CurrentSelWG, "UnLocked")
		if nUnLocked ~= 1 then
			Wuhun_BK4_OK1:SetText("#cfff263填入乾位")
			Wuhun_BK4_OK1:SetToolTip("#Y选中已激活的幻魂填入至乾位。")
		
			Wuhun_BK4_OK2:SetText("#cfff263填入坤位")
			Wuhun_BK4_OK2:SetToolTip("#Y选中已激活的幻魂填入至坤位。")
		else
			if g_CurrentSelWG ~= yangWg then
				Wuhun_BK4_OK1:SetText("#cfff263填入乾位")
				Wuhun_BK4_OK1:SetToolTip("#Y点击后，将已选中幻魂填入至乾位。")
			else
				Wuhun_BK4_OK1:SetText("#cfff263取出乾位")
				Wuhun_BK4_OK1:SetToolTip("#Y点击后，将已选中幻魂从乾位中取出。")
			end
			
			if g_CurrentSelWG ~= yinWg then
				Wuhun_BK4_OK2:SetText("#cfff263填入坤位")
				Wuhun_BK4_OK2:SetToolTip("#Y选中已激活的幻魂填入至坤位。")
			else
				Wuhun_BK4_OK2:SetText("#cfff263取出坤位")
				Wuhun_BK4_OK2:SetToolTip("#Y点击后，将已选中幻魂从坤位中取出。")
			end
		end
	end
	if g_TupuBtn[g_CurrentSelWG] ~= nil then
		g_TupuBtn[g_CurrentSelWG]:SetPushed(1)
	end
end
function Wuhun_SwitchRightPage(index)
	
	isYYClicked = 1
	
	if g_showPage == index then
		isYYClicked = 0
		return
	end
	
	if index == 1 then
		local myLevel = Player:GetData("LEVEL")
		if myLevel < 80 then
			-- PushDebugMessage("#H等级达80级后可开启幻魂功能。")
			-- isYYClicked = 0
			-- return 
		end		
	end

	g_showPage = index
	
	if g_showPage == 0 then
		Wuhun_Page1:SetCheck(1)
		Wuhun_Page2:SetCheck(0)
		Wuhun_Page1Client:Show()
		Wuhun_Page2Client:Hide()
	else
		Wuhun_Page1:SetCheck(0)
		Wuhun_Page2:SetCheck(1)
		Wuhun_Page1Client:Hide()
		Wuhun_Page2Client:Show()
	end
end
--kfs equippoint clicked event
function Wuhun_Equip_Clicked( buttonIn )
	local button = tonumber( buttonIn );
	if( button == 1 ) then
		Wuhun_Equip:DoAction();
	else
		Wuhun_Equip:DoSubAction();
	end

end

--model turn left
function Wuhun_Model_TurnLeft(start)
	--start
	if(start == 1 and CEArg:GetValue("MouseButton")=="LeftButton") then
		Wuhun_FakeObject:RotateBegin(-0.3);
	--stop
	else
		Wuhun_FakeObject:RotateEnd();
	end
end

--model turn right
function Wuhun_Model_TurnRight(start)
	--start
	if(start == 1 and CEArg:GetValue("MouseButton")=="LeftButton") then
		Wuhun_FakeObject:RotateBegin(0.3);
	--stop
	else
		Wuhun_FakeObject:RotateEnd();
	end
end

--kfs hidden event
function Wuhun_OnHiden()
	Wuhun_FakeObject:SetFakeObject("");
end

--player's other info
function Wuhun_OtherInfo_Page_Switch()
	Variable:SetVariable("SelfUnionPos", Wuhun_Frame:GetProperty("UnifiedPosition"), 1);
	OtherInfoPage();
end

--神木王鼎
function Wuhun_ShenDing_Page_Switch()
	Variable:SetVariable("SelfUnionPos", Wuhun_Frame:GetProperty("UnifiedPosition"), 1);
	OpenShengDingLayout()
	Wuhun_Wuhun:SetCheck(0)
end

--player's ride
function Wuhun_Ride_Page_Switch()
	Variable:SetVariable("SelfUnionPos", Wuhun_Frame:GetProperty("UnifiedPosition"), 1);
	OpenRidePage();
end

--player's pet
function Wuhun_Pet_Page_Switch()
	Variable:SetVariable("SelfUnionPos", Wuhun_Frame:GetProperty("UnifiedPosition"), 1);
	TogglePetPage();
end

--player's info
function Wuhun_SelfData_Page_Switch()
	Variable:SetVariable("SelfUnionPos", Wuhun_Frame:GetProperty("UnifiedPosition"), 1);
	SystemSetup:OpenPrivatePage("self");
end

--player's equip
function Wuhun_SelfEquip_Page_Switch()
	Variable:SetVariable("SelfUnionPos", Wuhun_Frame:GetProperty("UnifiedPosition"), 1);
	OpenEquip(1);
end
function Wuhun_Talent_Page_Switch()
	-- if DataPool:Lua_CheckOpenTalent() == 1 then
		Variable:SetVariable("SelfUnionPos", Wuhun_Frame:GetProperty("UnifiedPosition"), 1);
		ToggleTalentPage();
		this:Hide()
	-- else
		-- Wuhun_Talent : SetCheck(0)
	-- end
end
--xiu lian
function Wuhun_Xiulian_Page_Switch()
    local nLevel = Player:GetData("LEVEL")
	if(nLevel >= 70) then
		Variable:SetVariable("SelfUnionPos", Wuhun_Frame:GetProperty("UnifiedPosition"), 1);
		XiuLianPage();
		this:Hide()
	else
	    Wuhun_Xiulian:SetCheck(0)
	    PushDebugMessage("#{XL_090707_62}")
	end
end

function Wuhun_JingMai_Page_Switch()
	Variable:SetVariable("SelfUnionPos", Wuhun_Frame:GetProperty("UnifiedPosition"), 1);
	OpenJingMaiLayout()
	Wuhun_Wuhun:SetCheck(0)
end

--================================================
-- 恢复界面的默认相对位置
--================================================
function Wuhun_Frame_On_ResetPos()

	Wuhun_Frame : SetProperty("UnifiedXPosition", g_Wuhun_Frame_UnifiedXPosition);
	Wuhun_Frame : SetProperty("UnifiedYPosition", g_Wuhun_Frame_UnifiedYPosition);

end

function Wuhun_ZhenYuan_Page_Switch()
	Variable:SetVariable("SelfUnionPos", Wuhun_Frame:GetProperty("UnifiedPosition"), 1);
	OpenZhenYuanLayout()
	this:Hide()
end

--- 一键换宝石的界面
local g_Wuhun_TypeList =
{
	[1]  = { name="#{WBSS_120727_34}", gemConIndex=0,  equipIndex=0,  },    --- 武器
	[2]  = { name="#{WBSS_120727_26}", gemConIndex=11, equipIndex=14, },    --- 护腕
	[3]  = { name="#{WBSS_120727_30}", gemConIndex=6,  equipIndex=6,  },    --- 戒指（上）
	[4]  = { name="#{WBSS_120727_31}", gemConIndex=8,  equipIndex=11, },    --- 戒指（下）
	[5]  = { name="#{WBSS_120727_32}", gemConIndex=9,  equipIndex=12, },    --- 护符（上）
	[6]  = { name="#{WBSS_120727_33}", gemConIndex=10, equipIndex=13, },    --- 护符（下）
	[7]  = { name="#{WBSS_120727_35}", gemConIndex=2,  equipIndex=16,  },    --- 衣服
	[8]  = { name="#{WBSS_120727_24}", gemConIndex=1,  equipIndex=1,  },    --- 帽子
	[9]  = { name="#{WBSS_120727_25}", gemConIndex=12, equipIndex=15, },    --- 肩膀
	[10] = { name="#{WBSS_120727_27}", gemConIndex=3,  equipIndex=3,  },    --- 手套
	[11] = { name="#{WBSS_120727_28}", gemConIndex=5,  equipIndex=5,  },    --- 腰带
	[12] = { name="#{WBSS_120727_29}", gemConIndex=4,  equipIndex=4,  },    --- 鞋子
	[13] = { name="#{WBSS_120727_36}", gemConIndex=7,  equipIndex=7,  },    --- 项链
	[14] = { name="#{WBSS_120727_37}", gemConIndex=13, equipIndex=17, },    --- 暗器
	[15] = { name="#{WBSS_120727_39}", gemConIndex=15, equipIndex=18, },    --- 龙纹
	[16] = { name="#{WBSS_120727_38}", gemConIndex=14, equipIndex=10, },    --- 武魂
	[17] = { name="#{BHZB_140521_241}", gemConIndex=16, equipIndex=9, },    --- 符石传说

}
--- 更新一键换宝石显示
function Wuhun_UpdateGemContainer( )

    --- 当玩家未学会万宝随身互换时，装备位宝石查看按钮为灰态
    local gemSwitchSkillID = 121

	if( Player:GetSkillInfo( gemSwitchSkillID, "learn") ) then
        ----Wuhun_BaoShiCheck_tips : Hide()
	else
        --Wuhun_BaoShiCheck      : Hide()
        --Wuhun_BaoShiCheckGreen : Hide()
        ----Wuhun_BaoShiCheck_tips : Show()
        return
	end

    local ret = Wuhun_Can_SwitchGem(16)
    if ret == 1 then
        --- 正常态：玩家学会万宝随身互换，装备位上存在装备且所有装备位上的宝石都可以进行互换时
        --Wuhun_BaoShiCheckGreen : Enable()
        --Wuhun_BaoShiCheckGreen : Show()
        --Wuhun_BaoShiCheckGreen : SetToolTip( "#{WBSS_120727_44}" )
        --Wuhun_BaoShiCheck      : Hide()
    else
        --- 异常态：玩家学会万宝随身互换，装备位上不存在装备或非所有装备位上的宝石都可以进行互换时
        --Wuhun_BaoShiCheck       : Enable()
        --Wuhun_BaoShiCheck       : Show()
        --Wuhun_BaoShiCheck       : SetToolTip( "#{WBSS_120727_44}" )
        --Wuhun_BaoShiCheckGreen  : Hide()
    end
end

function Wuhun_BaoShiCheck_Clicked( btnIndex )
    if btnIndex < 0 or btnIndex > 17 then
        return
    end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("Gem_Containter_Check");
		Set_XSCRIPT_ScriptID(889955);
		Set_XSCRIPT_Parameter(0,btnIndex);
		Set_XSCRIPT_ParamCount(1);
    Send_XSCRIPT();

end
function Wuhun_ChangeYYSel(idx)
	g_SwitchYYIndex = idx
	if idx == 1 then
		Wuhun_BK4_Tupu1:SetPushed(1)
		Wuhun_BK4_Tupu2:SetPushed(0)
	elseif idx == 2 then
		Wuhun_BK4_Tupu1:SetPushed(0)
		Wuhun_BK4_Tupu2:SetPushed(1)	
	end
end
function Wuhun_ChangeYY()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("SwitchYY")
		Set_XSCRIPT_ScriptID(900004)
		Set_XSCRIPT_Parameter(0, g_SwitchYYIndex)
		Set_XSCRIPT_Parameter(1, Wuhun_FakeObject_ShowCheck:GetCheck())
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()
end
function Wuhun_Can_SwitchGem( curSel)
    local conPos     = g_Wuhun_TypeList[curSel].gemConIndex
    local equipPoint = g_Wuhun_TypeList[curSel].equipIndex

    --- 得到装备上的宝石
    local equipTypeList = {}
    local isHaveEquip, gemIndex1, gemIndex2, gemIndex3, gemIndex4 = Lua_SplitWearedEquipGem( equipPoint )
    local gemIndexList  = {}
    gemIndexList[1] = gemIndex1
    gemIndexList[2] = gemIndex2
    gemIndexList[3] = gemIndex3
    gemIndexList[4] = gemIndex4
    if isHaveEquip == 1 then
        for i = 1, 4 do
            if gemIndexList[i] > 0 then
                equipTypeList[i] = SelfEquip_GetGemTypeByIndex( gemIndexList[i] )
            else
                equipTypeList[i] = -1
            end
        end
    else
        --- 没有装备
        return 0
    end

    --- 其次得到装备位上的宝石类型
    local gemConTypeList  = { }
    local bHaveGemCon     = 0       --- 装备位上是否有宝石
	local gemIndex1, gemIndex2, gemIndex3, gemIndex4 = Lua_GetGemContainer_Gem(conPos)
	local nEquipGemData = {-1,-1,-1,-1}
	nEquipGemData[1] = gemIndex1
	nEquipGemData[2] = gemIndex2
	nEquipGemData[3] = gemIndex3
	nEquipGemData[4] = gemIndex4
    for i = 1, 4 do
        local nItemID, tmpGemType
        nItemID, _, tmpGemType = nEquipGemData[i],_,EquipBaoshiChange_GetGemTypeByIndex( nEquipGemData[i] )
        if nItemID ~= -1 then
            gemConTypeList[i] = tmpGemType
            bHaveGemCon       = 1
        else
            gemConTypeList[i] = -1
        end
    end
    if bHaveGemCon == 0 then
        return 0
    end

    --- 判断装备位上的所有宝石对应的当前装备上的孔位是否都存在宝石
    for i = 1, 4 do
        --- 如果装备位上有宝石
        if gemConTypeList[i] > 0 then
            -- 判断装备位上的所有宝石对应的当前装备上的孔位是否都存在宝石
            if equipTypeList[i] <= 0 then
                --return 0
            end
            equipTypeList[i] = gemConTypeList[i]
        end
    end

    --- 判断互换后，当前装备前三孔是否会出现同类型宝石
--    if equipTypeList[1] > 0 then
--        if ( equipTypeList[1] == equipTypeList[2] ) or ( equipTypeList[1] == equipTypeList[3] ) then
--            return 0
--        end
--    end
--
--    if equipTypeList[2] > 0 then
--        if ( equipTypeList[1] == equipTypeList[2] ) or ( equipTypeList[2] == equipTypeList[3] ) then
--            return 0
--        end
--    end
--
--    if equipTypeList[3] > 0 then
--        if ( equipTypeList[1] == equipTypeList[3] ) or ( equipTypeList[2] == equipTypeList[3] ) then
--            return 0
--        end
--    end

    return 1
end

function Wuhun_ChangeWG(nsel)
	if g_CurrentSelWG == 0 or g_CurrentSelWG > 6 then
		return
	end
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("WearWg")
		Set_XSCRIPT_ScriptID(900004)
		Set_XSCRIPT_Parameter(0, g_CurrentSelWG)
		Set_XSCRIPT_Parameter(1, nsel)
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()
	Wuhun_UpdateTupu()
end

function Wuhun_TupuItemClicked(idx)
	g_CurrentSelWG = idx
	for i = 1,6 do
		if i == idx then
			g_TupuBtn[i]:SetPushed(1)
		else
			g_TupuBtn[i]:SetPushed(0)
		end
	end
	-- g_TupuBtn[g_CurrentSelWG]:SetPushed(1)
	Wuhun_UpdateTupu()
end

--- 根据物品序列号来获得物品的类型
function Wuhun_GetGemTypeByIndex( itemTblIdx )
    if itemTblIdx == nil or itemTblIdx <= 0 then
        return -1
    end

    local tmpValue = math.mod( itemTblIdx, 100000 )
    local itemType = math.floor( tmpValue / 1000 )
    return itemType
end

function Wuhun_Miji_Page_Switch()
	Variable:SetVariable("SelfUnionPos", Wuhun_Frame:GetProperty("UnifiedPosition"), 1);
	OpenMijiLayout()
	this:Hide()
end

function Wuhun_Infant_Switch()
	Variable:SetVariable("SelfUnionPos", Wuhun_Frame:GetProperty("UnifiedPosition"), 1);
OpenInfantLayout()	--if bRet == 1 then
		this:Hide()
	--end
end

function Wuhun_JueWei_Page_Switch()
	-- 等级限制
	if ( Player:GetData("LEVEL") < 85 ) then
		PushDebugMessage( "#{JXJW_140822_20}" );
		return
	end
	Variable:SetVariable("SelfUnionPos", Wuhun_Frame:GetProperty("UnifiedPosition"), 1);
	OpenJunXianPage();
	this:Hide();
end

function Wuhun_OpenBaoJian()

	local nLevel =Player:GetData("LEVEL")
	if nLevel < 85 then
		PushDebugMessage("#{ZZZB_150811_114}")
		return
	end

	Variable:SetVariable("SelfUnionPos", Wuhun_Frame:GetProperty("UnifiedPosition"), 1)
	OpenBaoJianLayout()

end


function Wuhun_Refresh_Page_Button( nLevel)

	--神鼎
	if ( nLevel < 15 ) then
		Wuhun_ShenDing:Disable()
		Wuhun_ShenDing_tips:Show()
	--	Wuhun_ShenDing:SetToolTip("#{RWYQ_150707_07}")
	else
		Wuhun_ShenDing:Enable()
		Wuhun_ShenDing_tips:Hide()
	end
	--子女
--	local InfantCount = Infant:GetInfantCount();
	-- if ( nLevel < 50 )  then
		-- Wuhun_Infant:Disable()
		-- Wuhun_Infant_tips:Show()
		-- Wuhun_Infant:SetToolTip("#{RWYQ_150707_01}")
    -- else
		-- Wuhun_Infant:Enable()
		-- Wuhun_Infant_tips:Hide()
	-- end
	--武魂
--	if ( nLevel < 65 ) then
--		Wuhun_Wuhun:Disable()
--		Wuhun_Wuhun_tips:Show()
--		Infant_Wuhun:SetToolTip("#{RWYQ_150707_02}")
--	else
		Wuhun_Wuhun:Enable()
		Wuhun_Wuhun_tips:Hide()
--	end
	--修炼
	if ( nLevel < 70 ) then
		Wuhun_Xiulian:Disable()
		Wuhun_Xiulian_tips:Show()
	--	Wuhun_Xiulian:SetToolTip("#{RWYQ_150707_03}")
	else
		Wuhun_Xiulian:Enable()
		Wuhun_Xiulian_tips:Hide()
	end
	--秘籍
	if nLevel < 75 then
		Wuhun_Miji:Disable()
		Wuhun_Miji_tips:Show()
	--	Wuhun_Miji:SetToolTip("#{RWYQ_150707_04}")
	else
		Wuhun_Miji:Enable()
		Wuhun_Miji_tips:Hide()
	end
	--真元
	if nLevel < 80 then
		Wuhun_ZhenYuan:Disable()
		Wuhun_ZhenYuan_tips:Show()
	--	Wuhun_ZhenYuan:SetToolTip("#{RWYQ_150707_05}")
	else
		Wuhun_ZhenYuan:Enable()
		Wuhun_ZhenYuan_tips:Hide()
	end
	--侠印 2019-11-8 15:08:39 逍遥子开放
	if ( nLevel < 85 ) then
		Wuhun_JueWei:Disable()
		Wuhun_JueWei_tips:Show()
	else
		Wuhun_JueWei:Enable()
		Wuhun_JueWei_tips:Hide()
	end
	--经脉
	if nLevel < 90 then
		Wuhun_JingMai:Disable()
		Wuhun_JingMai_tips:Show()
	else
		Wuhun_JingMai:Enable()
		Wuhun_JingMai_tips:Hide()
	end

	if ( nLevel < 85 ) then
		Wuhun_BaoJian:Disable()
		Wuhun_BaoJian_tips:Show()
	else
		Wuhun_BaoJian:Enable()
		Wuhun_BaoJian_tips:Hide()
	end
	
	--武意
	if nLevel >= 85 then
		Wuhun_WuYi:Enable()
		Wuhun_WuYi_tips:Hide()
	else
		Wuhun_WuYi:Disable()
		Wuhun_WuYi_tips:Show()
	end
	--九星神器DIY技能
	if nLevel >= 85 then
		Wuhun_ShenQi:Enable()
		Wuhun_ShenQi_tips:Hide()
	else
		Wuhun_ShenQi:Disable()
		Wuhun_ShenQi_tips:Show()
	end

end

function Wuhun_OpenWuYi()
	local nLevel =Player:GetData("LEVEL")
	if(nLevel < 85) then
		PushDebugMessage("尚未开启武意系统")
		return
	end
	Variable:SetVariable("SelfUnionPos", Wuhun_Frame:GetProperty("UnifiedPosition"), 1);
	OpenWuyiLayout()
end

-- 九星神器DIY技能
function Wuhun_OpenShenQi()
	Variable:SetVariable("SelfUnionPos", Wuhun_Frame:GetProperty("UnifiedPosition"), 1);
	OpenShengQiLayout()
end

function Lua_GetKfsSkillName(nSkillID)
	local Kfs_SkillTableEx = {[1500] = "A1",[1501] = "A2",[1502] = "A3",[1503] = "A4",[1504] = "A5",[1505] = "A6",[1506] = "B1",[1507] = "B2",[1508] = "B3",[1509] = "B4",[1510] = "B5",[1511] = "B6",[1512] = "C1",[1513] = "C2",[1514] = "C3",[1515] = "C4",[1516] = "C5",[1517] = "C6",[1518] = "D1",[1519] = "D2",[1520] = "D3",[1521] = "D4",[1522] = "D5",[1523] = "D6",[1524] = "E1",[1525] = "E2",[1526] = "E3",[1527] = "E4",[1528] = "E5",[1529] = "E6",[1644] = "F1",[1645] = "F2",[1646] = "F3",[1647] = "F4",[1648] = "F5",[1649] = "F6",[1566] = "G1",[1567] = "G2",[1568] = "G3",[1569] = "G4",[1570] = "G5",[1571] = "G6",[1572] = "H1",[1573] = "H2",[1574] = "H3",[1575] = "H4",[1576] = "H5",[1577] = "H6",[1578] = "I1",[1579] = "I2",[1580] = "I3",[1581] = "I4",[1582] = "I5",[1583] = "I6",[1584] = "J1",[1585] = "J2",[1586] = "J3",[1587] = "J4",[1588] = "J5",[1589] = "J6",[1590] = "K1",[1591] = "K2",[1592] = "K3",[1593] = "K4",[1594] = "K5",[1595] = "K6",[1650] = "L1",[1651] = "L2",[1652] = "L3",[1653] = "L4",[1654] = "L5",[1655] = "L6",[1530] = "M1",[1531] = "M2",[1532] = "M3",[1533] = "M4",[1534] = "M5",[1535] = "M6",[1536] = "N1",[1537] = "N2",[1538] = "N3",[1539] = "N4",[1540] = "N5",[1541] = "N6",[1542] = "O1",[1543] = "O2",[1544] = "O3",[1545] = "O4",[1546] = "O5",[1547] = "O6",[1548] = "P1",[1549] = "P2",[1550] = "P3",[1551] = "P4",[1552] = "P5",[1553] = "P6",[1554] = "Q1",[1555] = "Q2",[1556] = "Q3",[1557] = "Q4",[1558] = "Q5",[1559] = "Q6",[1560] = "R1",[1561] = "R2",[1562] = "R3",[1563] = "R4",[1564] = "R5",[1565] = "R6",[1596] = "S1",[1597] = "S2",[1598] = "S3",[1599] = "S4",[1600] = "S5",[1601] = "S6",[1602] = "T1",[1603] = "T2",[1604] = "T3",[1605] = "T4",[1606] = "T5",[1607] = "T6",[1608] = "U1",[1609] = "U2",[1610] = "U3",[1611] = "U4",[1612] = "U5",[1613] = "U6",[1614] = "V1",[1615] = "V2",[1616] = "V3",[1617] = "V4",[1618] = "V5",[1619] = "V6",[1620] = "W1",[1621] = "W2",[1622] = "W3",[1623] = "W4",[1624] = "W5",[1625] = "W6",[1626] = "X1",[1627] = "X2",[1628] = "X3",[1629] = "X4",[1630] = "X5",[1631] = "X6",[1632] = "Y1",[1633] = "Y2",[1634] = "Y3",[1635] = "Y4",[1636] = "Y5",[1637] = "Y6",[1638] = "Z1",[1639] = "Z2",[1640] = "Z3",[1641] = "Z4",[1642] = "Z5",[1643] = "Z6",[1698] = "a1",[1699] = "a2",[1700] = "a3",[1701] = "a4",[1702] = "a5",[1703] = "a6",[1704] = "b1",[1705] = "b2",[1706] = "b3",[1707] = "b4",[1708] = "b5",[1709] = "b6",[1710] = "c1",[1711] = "c2",[1712] = "c3",[1713] = "c4",[1714] = "c5",[1715] = "c6",[1716] = "d1",[1717] = "d2",[1718] = "d3",[1719] = "d4",[1720] = "d5",[1721] = "d6",[1722] = "e1",[1723] = "e2",[1724] = "e3",[1725] = "e4",[1726] = "e5",[1727] = "e6",[1728] = "f1",[1729] = "f2",[1730] = "f3",[1731] = "f4",[1732] = "f5",[1733] = "f6",[1734] = "g1",[1735] = "g2",[1736] = "g3",[1737] = "g4",[1738] = "g5",[1739] = "g6",[1656] = "h1",[1657] = "h2",[1658] = "h3",[1659] = "h4",[1660] = "h5",[1661] = "h6",[1662] = "i1",[1663] = "i2",[1664] = "i3",[1665] = "i4",[1666] = "i5",[1667] = "i6",[1668] = "j1",[1669] = "j2",[1670] = "j3",[1671] = "j4",[1672] = "j5",[1673] = "j6",[1674] = "k1",[1675] = "k2",[1676] = "k3",[1677] = "k4",[1678] = "k5",[1679] = "k6",[1680] = "l1",[1681] = "l2",[1682] = "l3",[1683] = "l4",[1684] = "l5",[1685] = "l6",[1686] = "m1",[1687] = "m2",[1688] = "m3",[1689] = "m4",[1690] = "m5",[1691] = "m6",[1692] = "n1",[1693] = "n2",[1694] = "n3",[1695] = "n4",[1696] = "n5",[1697] = "n6",[1740] = "o1",[1741] = "o2",[1742] = "o3",[1743] = "o4",[1744] = "o5",[1745] = "o6",[1746] = "p1",[1747] = "p2",[1748] = "p3",[1749] = "p4",[1750] = "p5",[1751] = "p6",}
	if Kfs_SkillTableEx[nSkillID] ~= nil then
		return "#{XYJ_KFS_SKILL_NAME_"..Kfs_SkillTableEx[nSkillID].."}"
	else
		return ""
	end
end

function Lua_GetKfsSkill(nSkill,nIndex)
	local nKfs_SkillTable = {["A1"]=1500,["A2"]=1501,["A3"]=1502,["A4"]=1503,["A5"]=1504,["A6"]=1505,["B1"]=1506,["B2"]=1507,["B3"]=1508,["B4"]=1509,["B5"]=1510,["B6"]=1511,["C1"]=1512,["C2"]=1513,["C3"]=1514,["C4"]=1515,["C5"]=1516,["C6"]=1517,["D1"]=1518,["D2"]=1519,["D3"]=1520,["D4"]=1521,["D5"]=1522,["D6"]=1523,["E1"]=1524,["E2"]=1525,["E3"]=1526,["E4"]=1527,["E5"]=1528,["E6"]=1529,["F1"]=1644,["F2"]=1645,["F3"]=1646,["F4"]=1647,["F5"]=1648,["F6"]=1649,["G1"]=1566,["G2"]=1567,["G3"]=1568,["G4"]=1569,["G5"]=1570,["G6"]=1571,["H1"]=1572,["H2"]=1573,["H3"]=1574,["H4"]=1575,["H5"]=1576,["H6"]=1577,["I1"]=1578,["I2"]=1579,["I3"]=1580,["I4"]=1581,["I5"]=1582,["I6"]=1583,["J1"]=1584,["J2"]=1585,["J3"]=1586,["J4"]=1587,["J5"]=1588,["J6"]=1589,["K1"]=1590,["K2"]=1591,["K3"]=1592,["K4"]=1593,["K5"]=1594,["K6"]=1595,["L1"]=1650,["L2"]=1651,["L3"]=1652,["L4"]=1653,["L5"]=1654,["L6"]=1655,["M1"]=1530,["M2"]=1531,["M3"]=1532,["M4"]=1533,["M5"]=1534,["M6"]=1535,["N1"]=1536,["N2"]=1537,["N3"]=1538,["N4"]=1539,["N5"]=1540,["N6"]=1541,["O1"]=1542,["O2"]=1543,["O3"]=1544,["O4"]=1545,["O5"]=1546,["O6"]=1547,["P1"]=1548,["P2"]=1549,["P3"]=1550,["P4"]=1551,["P5"]=1552,["P6"]=1553,["Q1"]=1554,["Q2"]=1555,["Q3"]=1556,["Q4"]=1557,["Q5"]=1558,["Q6"]=1559,["R1"]=1560,["R2"]=1561,["R3"]=1562,["R4"]=1563,["R5"]=1564,["R6"]=1565,["S1"]=1596,["S2"]=1597,["S3"]=1598,["S4"]=1599,["S5"]=1600,["S6"]=1601,["T1"]=1602,["T2"]=1603,["T3"]=1604,["T4"]=1605,["T5"]=1606,["T6"]=1607,["U1"]=1608,["U2"]=1609,["U3"]=1610,["U4"]=1611,["U5"]=1612,["U6"]=1613,["V1"]=1614,["V2"]=1615,["V3"]=1616,["V4"]=1617,["V5"]=1618,["V6"]=1619,["W1"]=1620,["W2"]=1621,["W3"]=1622,["W4"]=1623,["W5"]=1624,["W6"]=1625,["X1"]=1626,["X2"]=1627,["X3"]=1628,["X4"]=1629,["X5"]=1630,["X6"]=1631,["Y1"]=1632,["Y2"]=1633,["Y3"]=1634,["Y4"]=1635,["Y5"]=1636,["Y6"]=1637,["Z1"]=1638,["Z2"]=1639,["Z3"]=1640,["Z4"]=1641,["Z5"]=1642,["Z6"]=1643,["a1"]=1698,["a2"]=1699,["a3"]=1700,["a4"]=1701,["a5"]=1702,["a6"]=1703,["b1"]=1704,["b2"]=1705,["b3"]=1706,["b4"]=1707,["b5"]=1708,["b6"]=1709,["c1"]=1710,["c2"]=1711,["c3"]=1712,["c4"]=1713,["c5"]=1714,["c6"]=1715,["d1"]=1716,["d2"]=1717,["d3"]=1718,["d4"]=1719,["d5"]=1720,["d6"]=1721,["e1"]=1722,["e2"]=1723,["e3"]=1724,["e4"]=1725,["e5"]=1726,["e6"]=1727,["f1"]=1728,["f2"]=1729,["f3"]=1730,["f4"]=1731,["f5"]=1732,["f6"]=1733,["g1"]=1734,["g2"]=1735,["g3"]=1736,["g4"]=1737,["g5"]=1738,["g6"]=1739,["h1"]=1656,["h2"]=1657,["h3"]=1658,["h4"]=1659,["h5"]=1660,["h6"]=1661,["i1"]=1662,["i2"]=1663,["i3"]=1664,["i4"]=1665,["i5"]=1666,["i6"]=1667,["j1"]=1668,["j2"]=1669,["j3"]=1670,["j4"]=1671,["j5"]=1672,["j6"]=1673,["k1"]=1674,["k2"]=1675,["k3"]=1676,["k4"]=1677,["k5"]=1678,["k6"]=1679,["l1"]=1680,["l2"]=1681,["l3"]=1682,["l4"]=1683,["l5"]=1684,["l6"]=1685,["m1"]=1686,["m2"]=1687,["m3"]=1688,["m4"]=1689,["m5"]=1690,["m6"]=1691,["n1"]=1692,["n2"]=1693,["n3"]=1694,["n4"]=1695,["n5"]=1696,["n6"]=1697,["o1"]=1740,["o2"]=1741,["o3"]=1742,["o4"]=1743,["o5"]=1744,["o6"]=1745,["p1"]=1746,["p2"]=1747,["p3"]=1748,["p4"]=1749,["p5"]=1750,["p6"]=1751,}
	local nSign = {
		string.sub(nSkill,1,2),
		string.sub(nSkill,3,4),
		string.sub(nSkill,5,6),
	}
	if nKfs_SkillTable[nSign[nIndex]] ~= nil then
		return nKfs_SkillTable[nSign[nIndex]]
	end
	return -1
end

function Lua_GetKfsDataGrade(nGrow)
	if nGrow < 650 then
		return 0
	elseif nGrow >= 650 and nGrow < 700 then
		return 1
	elseif nGrow >= 700 and nGrow < 750 then
		return 2
	elseif nGrow >= 750 and nGrow < 820 then
		return 3
	elseif nGrow >= 820 and nGrow <= 900 then
		return 4
	elseif nGrow > 900 then
		return 5
	end
end

function LuaGetKfsAttrData(nEquipData)
	local Pos1,Pos2,nGrow,nExLevel,nLevel,nExp,nMagic,nExAttrNum,nExAttr,nSkill = 0,0,0,0,0,0,0,0,"",""
	if nEquipData == nil then
		nGrow = 600
		nExLevel = 1
		nLevel = 1
		nExp = 0
		nMagic = 0
		nExAttrNum = 1
		nExAttr = "A1"..string.rep("0",12)
		nSkill = string.rep("0",6)
	else
		Pos1,Pos2,nGrow,nExLevel,nLevel,nExp,nMagic,nExAttrNum,nExAttr,nSkill = string.find(nEquipData,"&W(%w%w%w)(%w)(%w%w%w)(%w%w%w%w%w)(%w)(%w)("..string.rep("%w",14)..")".."("..string.rep("%w",6)..")")
		if Pos1 == nil or Pos2 == nil then
			nGrow = 600
			nExLevel = 1
			nLevel = 1
			nExp = 0
			nMagic = 0
			nExAttrNum = 1
			nExAttr = "A1"..string.rep("0",12)
			nSkill = string.rep("0",6)
		end
	end
	return tonumber(nGrow),tonumber(nExLevel),tonumber(nLevel),tonumber(nExp),tonumber(nMagic),tonumber(nExAttrNum),nExAttr,nSkill
end

function Lua_GetKfsAttrNum(nExAttr)
	local nExAttrNum = 0;
	if nExAttr ~= nil then
		for i = 1,20 do
			if tonumber(string.sub(nExAttr,i,i)) == nil then
				nExAttrNum = nExAttrNum + 1
			end
		end
	end
	return nExAttrNum
end

function Lua_KfsGetLevelUpNeedExp(nLevel)
	local nExp = 0
	local nExpTable = {1500,1510,1540,1580,1640,1710,1800,1890,2000,2120,2250,2390,2540,2700,2870,3060,3250,3450,3660,3880,4120,4360,4610,4870,5130,5410,5700,5990,6300,6610,6930,7260,7600,7950,8310,8670,9040,9430,9820,10210,10620,11040,11460,11890,12330,12780,13230,13690,14170,14640,15130,15630,16130,16640,17160,17680,18220,18760,19310,19860,20430,21000,21580,22170,22760,23360,23970,24590,25210,25840,26480,27130,27780,28440,29110,29790,30470,31160,31860,32560,33270,33990,34720,35450,36190,36940,37690,38450,39220,40000,40780,41570,42360,43170,43980,44790,45620,46450,47280,48130,48980,49840,50700,51580,52450,53340,54230,55130,56040,56950,57870,58790,59730,60660,61610,62560,63520,64490,65460,66440,}
	if nExpTable[nLevel] ~= nil then
		nExp = nExpTable[nLevel]
	end
	return nExp
end

function Lua_GetBagKfsSkillNum(nSkill)
	local nSkillType,nSkillValue = {},{}
	local nSign = {}
	local nSkillNum = 0;
	if nSkill ~= nil then
		for i = 1,3 do
			nSkillType[i] = string.sub(nSkill, (i*2) - 1,(i*2) - 1)
			if nSkillType[i] ~= "0" then
				nSkillNum = nSkillNum + 1
			end
			nSkillValue[i] = tonumber(string.sub(nSkill, i*2,i*2))
		end
	end
	return nSkillNum
end

function Wuhun_OpenWG()
	PushEvent("UI_COMMAND",202104151)
end

function WuHun_OnAndOffMode()
	local a = Wuhun_Mode:GetCheck();
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "WuHunModel" );
		Set_XSCRIPT_ScriptID(900004);
		Set_XSCRIPT_Parameter(0,a);
		Set_XSCRIPT_ParamCount(1);
	Send_XSCRIPT()	
end

function Lua_KfsGetAttrAndOldAttr(nType,nGrow,nAttrType,nKFS_Level)
	local nBaseAttr,nOldBaseAttr = 0,0
	local nAttrTable = {
		[0] = {2,1,1,1,1},
		[1] = {1,2,1,1,1},
		}
	if nType >= 1 and nType <= 5 and nAttrType ~= nil and nAttrType >= 0 and nAttrType <= 1 then
		nBaseAttr = math.ceil(nAttrTable[nAttrType][nType] * ((nGrow/100) + 1) * (nKFS_Level/10))
		nOldBaseAttr = math.ceil(nBaseAttr * ((nGrow/1000) + 1))
	end
	return nBaseAttr,nOldBaseAttr
end

function Lua_GetKfsFixAttrEx(nExAttr,nIndex,nGrow)
	local nAttrExTable = {
	["A1"] = {"冰攻击(1级)",20310131,5000,30},
	["A2"] = {"冰攻击(2级)",20310132,5000,41},
	["A3"] = {"冰攻击(3级)",20310133,10000,63},
	["A4"] = {"冰攻击(4级)",20310134,10000,93},
	["A5"] = {"冰攻击(5级)",20310135,15000,131},
	["A6"] = {"冰攻击(6级)",20310136,15000,174},
	["A7"] = {"冰攻击(7级)",20310137,20000,223},
	["A8"] = {"冰攻击(8级)",20310138,20000,277},
	["A9"] = {"冰攻击(9级)",20310139,25000,336},
	["A0"] = {"冰攻击(10级)",-1,0,400},
	["B1"] = {"冰抗性(1级)",20310122,5000,8},
	["B2"] = {"冰抗性(2级)",20310123,5000,11},
	["B3"] = {"冰抗性(3级)",20310124,10000,16},
	["B4"] = {"冰抗性(4级)",20310125,10000,24},
	["B5"] = {"冰抗性(5级)",20310126,15000,33},
	["B6"] = {"冰抗性(6级)",20310127,15000,44},
	["B7"] = {"冰抗性(7级)",20310128,20000,56},
	["B8"] = {"冰抗性(8级)",20310129,20000,70},
	["B9"] = {"冰抗性(9级)",20310130,25000,84},
	["B0"] = {"冰抗性(10级)",-1,0,100},
	["C1"] = {"火攻击(1级)",20310131,5000,30},
	["C2"] = {"火攻击(2级)",20310132,5000,41},
	["C3"] = {"火攻击(3级)",20310133,10000,63},
	["C4"] = {"火攻击(4级)",20310134,10000,93},
	["C5"] = {"火攻击(5级)",20310135,15000,131},
	["C6"] = {"火攻击(6级)",20310136,15000,174},
	["C7"] = {"火攻击(7级)",20310137,20000,223},
	["C8"] = {"火攻击(8级)",20310138,20000,277},
	["C9"] = {"火攻击(9级)",20310139,25000,336},
	["C0"] = {"火攻击(10级)",-1,0,400},
	["D1"] = {"火抗性(1级)",20310122,5000,8},
	["D2"] = {"火抗性(2级)",20310123,5000,11},
	["D3"] = {"火抗性(3级)",20310124,10000,16},
	["D4"] = {"火抗性(4级)",20310125,10000,24},
	["D5"] = {"火抗性(5级)",20310126,15000,33},
	["D6"] = {"火抗性(6级)",20310127,15000,44},
	["D7"] = {"火抗性(7级)",20310128,20000,56},
	["D8"] = {"火抗性(8级)",20310129,20000,70},
	["D9"] = {"火抗性(9级)",20310130,25000,84},
	["D0"] = {"火抗性(10级)",-1,0,100},
	["E1"] = {"玄攻击(1级)",20310131,5000,30},
	["E2"] = {"玄攻击(2级)",20310132,5000,41},
	["E3"] = {"玄攻击(3级)",20310133,10000,63},
	["E4"] = {"玄攻击(4级)",20310134,10000,93},
	["E5"] = {"玄攻击(5级)",20310135,15000,131},
	["E6"] = {"玄攻击(6级)",20310136,15000,174},
	["E7"] = {"玄攻击(7级)",20310137,20000,223},
	["E8"] = {"玄攻击(8级)",20310138,20000,277},
	["E9"] = {"玄攻击(9级)",20310139,25000,336},
	["E0"] = {"玄攻击(10级)",-1,0,400},
	["F1"] = {"玄抗性(1级)",20310122,5000,8},
	["F2"] = {"玄抗性(2级)",20310123,5000,11},
	["F3"] = {"玄抗性(3级)",20310124,10000,16},
	["F4"] = {"玄抗性(4级)",20310125,10000,24},
	["F5"] = {"玄抗性(5级)",20310126,15000,33},
	["F6"] = {"玄抗性(6级)",20310127,15000,44},
	["F7"] = {"玄抗性(7级)",20310128,20000,56},
	["F8"] = {"玄抗性(8级)",20310129,20000,70},
	["F9"] = {"玄抗性(9级)",20310130,25000,84},
	["F0"] = {"玄抗性(10级)",-1,0,100},
	["G1"] = {"毒攻击(1级)",20310131,5000,30},
	["G2"] = {"毒攻击(2级)",20310132,5000,41},
	["G3"] = {"毒攻击(3级)",20310133,10000,63},
	["G4"] = {"毒攻击(4级)",20310134,10000,93},
	["G5"] = {"毒攻击(5级)",20310135,15000,131},
	["G6"] = {"毒攻击(6级)",20310136,15000,174},
	["G7"] = {"毒攻击(7级)",20310137,20000,223},
	["G8"] = {"毒攻击(8级)",20310138,20000,277},
	["G9"] = {"毒攻击(9级)",20310139,25000,336},
	["G0"] = {"毒攻击(10级)",-1,0,400},
	["H1"] = {"毒抗性(1级)",20310122,5000,8},
	["H2"] = {"毒抗性(2级)",20310123,5000,11},
	["H3"] = {"毒抗性(3级)",20310124,10000,16},
	["H4"] = {"毒抗性(4级)",20310125,10000,24},
	["H5"] = {"毒抗性(5级)",20310126,15000,33},
	["H6"] = {"毒抗性(6级)",20310127,15000,44},
	["H7"] = {"毒抗性(7级)",20310128,20000,56},
	["H8"] = {"毒抗性(8级)",20310129,20000,70},
	["H9"] = {"毒抗性(9级)",20310130,25000,84},
	["H0"] = {"毒抗性(10级)",-1,0,100},
	["I1"] = {"忽略目标冰抗(1级)",20310140,5000,8},
	["I2"] = {"忽略目标冰抗(2级)",20310141,5000,11},
	["I3"] = {"忽略目标冰抗(3级)",20310142,10000,16},
	["I4"] = {"忽略目标冰抗(4级)",20310143,10000,24},
	["I5"] = {"忽略目标冰抗(5级)",20310144,15000,33},
	["I6"] = {"忽略目标冰抗(6级)",20310145,15000,44},
	["I7"] = {"忽略目标冰抗(7级)",20310146,20000,56},
	["I8"] = {"忽略目标冰抗(8级)",20310147,20000,70},
	["I9"] = {"忽略目标冰抗(9级)",20310148,25000,84},
	["I0"] = {"忽略目标冰抗(10级)",-1,0,100},
	["J1"] = {"忽略目标火抗(1级)",20310140,5000,8},
	["J2"] = {"忽略目标火抗(2级)",20310141,5000,11},
	["J3"] = {"忽略目标火抗(3级)",20310142,10000,16},
	["J4"] = {"忽略目标火抗(4级)",20310143,10000,24},
	["J5"] = {"忽略目标火抗(5级)",20310144,15000,33},
	["J6"] = {"忽略目标火抗(6级)",20310145,15000,44},
	["J7"] = {"忽略目标火抗(7级)",20310146,20000,56},
	["J8"] = {"忽略目标火抗(8级)",20310147,20000,70},
	["J9"] = {"忽略目标火抗(9级)",20310148,25000,84},
	["J0"] = {"忽略目标火抗(10级)",-1,0,100},
	["K1"] = {"忽略目标玄抗(1级)",20310140,5000,8},
	["K2"] = {"忽略目标玄抗(2级)",20310141,5000,11},
	["K3"] = {"忽略目标玄抗(3级)",20310142,10000,16},
	["K4"] = {"忽略目标玄抗(4级)",20310143,10000,24},
	["K5"] = {"忽略目标玄抗(5级)",20310144,15000,33},
	["K6"] = {"忽略目标玄抗(6级)",20310145,15000,44},
	["K7"] = {"忽略目标玄抗(7级)",20310146,20000,56},
	["K8"] = {"忽略目标玄抗(8级)",20310147,20000,70},
	["K9"] = {"忽略目标玄抗(9级)",20310148,25000,84},
	["K0"] = {"忽略目标玄抗(10级)",-1,0,100},
	["L1"] = {"忽略目标毒抗(1级)",20310140,5000,8},
	["L2"] = {"忽略目标毒抗(2级)",20310141,5000,11},
	["L3"] = {"忽略目标毒抗(3级)",20310142,10000,16},
	["L4"] = {"忽略目标毒抗(4级)",20310143,10000,24},
	["L5"] = {"忽略目标毒抗(5级)",20310144,15000,33},
	["L6"] = {"忽略目标毒抗(6级)",20310145,15000,44},
	["L7"] = {"忽略目标毒抗(7级)",20310146,20000,56},
	["L8"] = {"忽略目标毒抗(8级)",20310147,20000,70},
	["L9"] = {"忽略目标毒抗(9级)",20310148,25000,84},
	["L0"] = {"忽略目标毒抗(10级)",-1,0,100},
	["M1"] = {"降低目标冰抗下限(1级)",20310149,5000,2},
	["M2"] = {"降低目标冰抗下限(2级)",20310150,5000,3},
	["M3"] = {"降低目标冰抗下限(3级)",20310151,10000,4},
	["M4"] = {"降低目标冰抗下限(4级)",20310152,10000,5},
	["M5"] = {"降低目标冰抗下限(5级)",20310153,15000,7},
	["M6"] = {"降低目标冰抗下限(6级)",20310154,15000,9},
	["M7"] = {"降低目标冰抗下限(7级)",20310155,20000,12},
	["M8"] = {"降低目标冰抗下限(8级)",20310156,20000,14},
	["M9"] = {"降低目标冰抗下限(9级)",20310157,25000,17},
	["M0"] = {"降低目标冰抗下限(10级)",-1,0,20},
	["N1"] = {"降低目标火抗下限(1级)",20310149,5000,2},
	["N2"] = {"降低目标火抗下限(2级)",20310150,5000,3},
	["N3"] = {"降低目标火抗下限(3级)",20310151,10000,4},
	["N4"] = {"降低目标火抗下限(4级)",20310152,10000,5},
	["N5"] = {"降低目标火抗下限(5级)",20310153,15000,7},
	["N6"] = {"降低目标火抗下限(6级)",20310154,15000,9},
	["N7"] = {"降低目标火抗下限(7级)",20310155,20000,12},
	["N8"] = {"降低目标火抗下限(8级)",20310156,20000,14},
	["N9"] = {"降低目标火抗下限(9级)",20310157,25000,17},
	["N0"] = {"降低目标火抗下限(10级)",-1,0,20},
	["O1"] = {"降低目标玄抗下限(1级)",20310149,5000,2},
	["O2"] = {"降低目标玄抗下限(2级)",20310150,5000,3},
	["O3"] = {"降低目标玄抗下限(3级)",20310151,10000,4},
	["O4"] = {"降低目标玄抗下限(4级)",20310152,10000,5},
	["O5"] = {"降低目标玄抗下限(5级)",20310153,15000,7},
	["O6"] = {"降低目标玄抗下限(6级)",20310154,15000,9},
	["O7"] = {"降低目标玄抗下限(7级)",20310155,20000,12},
	["O8"] = {"降低目标玄抗下限(8级)",20310156,20000,14},
	["O9"] = {"降低目标玄抗下限(9级)",20310157,25000,17},
	["O0"] = {"降低目标玄抗下限(10级)",-1,0,20},
	["P1"] = {"降低目标毒抗下限(1级)",20310149,5000,2},
	["P2"] = {"降低目标毒抗下限(2级)",20310150,5000,3},
	["P3"] = {"降低目标毒抗下限(3级)",20310151,10000,4},
	["P4"] = {"降低目标毒抗下限(4级)",20310152,10000,5},
	["P5"] = {"降低目标毒抗下限(5级)",20310153,15000,7},
	["P6"] = {"降低目标毒抗下限(6级)",20310154,15000,9},
	["P7"] = {"降低目标毒抗下限(7级)",20310155,20000,12},
	["P8"] = {"降低目标毒抗下限(8级)",20310156,20000,14},
	["P9"] = {"降低目标毒抗下限(9级)",20310157,25000,17},
	["P0"] = {"降低目标毒抗下限(10级)",-1,0,20},
	}
	local iText , iValue = "",0
	local nAttrExType,nAttrExValue = {},{}
	local nAttrExNum = 0;
	--优先计算成长率加成
	local nGrowAttr = 0
	local nTest_1 = {550,600,650,700,750,800,850,900}
	nGrow = tonumber(nGrow)
	for i = 1,table.getn(nTest_1) do
	    if nGrow >= nTest_1[i] and nGrow < nTest_1[i] + 50 then
		    nGrowAttr = i
		    break
		end
	end
	nGrowAttr = nGrowAttr/10
	-- nGrow
	if nIndex >= 1 and nIndex <= 7 and nExAttr ~= nil then
		--nExAttr nIndex
		for i = 1,7 do
			nAttrExType[i] = string.sub(nExAttr, (i*2) - 1,(i*2) - 1)
			if nAttrExType[i] ~= "0" then
				nAttrExNum = nAttrExNum + 1;
			end
			nAttrExValue[i] = tonumber(string.sub(nExAttr, i*2,i*2))
		end
		local nAttrExIndex = nAttrExType[nIndex]..tostring(nAttrExValue[nIndex])
		if nAttrExTable[nAttrExIndex] ~= nil then
			iText = nAttrExTable[nAttrExIndex][1]
			iValue = math.ceil(nAttrExTable[nAttrExIndex][4]*(1 + nGrowAttr))
		end
	end
	if nIndex == 0 and nExAttr ~= nil then
		for i = 1,7 do
			nAttrExType[i] = string.sub(nExAttr, (i*2) - 1,(i*2) - 1)
			if nAttrExType[i] ~= "0" then
				nAttrExNum = nAttrExNum + 1;
			end
		end
		return nAttrExNum
	end
	if nIndex >= 100 and nExAttr ~= nil then
		for i = 1,7 do
			nAttrExType[i] = string.sub(nExAttr, (i*2) - 1,(i*2) - 1)
			nAttrExValue[i] = tonumber(string.sub(nExAttr, i*2,i*2))
		end
		nIndex = nIndex - 100
		local nFinalIndex = nAttrExType[nIndex]..nAttrExValue[nIndex]
		if nAttrExTable[nFinalIndex] ~= nil then
			return nAttrExTable[nFinalIndex][2],nAttrExTable[nFinalIndex][3]
		else
			return 0,-1
		end
	end
	return iText,iValue,nAttrExNum
end