--WuhunSkillStudy
--build 2019-7-15 19:44:56 逍遥子
local m_UI_NUM = 20090722
local m_ObjCared = -1
local m_Equip_Idx = -1

local UI_TYPE_STUDY	= 1
local UI_TYPE_RESET	= 2
local UI_TYPE_RESET_WX = 3
local UI_TYPE_RESET_GROWRATE1 = 4 --回天精石重洗武魂成长率
local UI_TYPE_RESET_GROWRATE2 = 5 --回天神石重洗武魂成长率
local m_UIType = 0

local needMoney = 0

local resetConfirm = 0
local nKfsData = ""

local g_YBCheck = 1--默认选中

local g_Wuhun_Wx = -1;
--PreLoad
function WuhunSkillStudy_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("UPDATE_KFS_SKILL")
	this:RegisterEvent("UNIT_MONEY",false);
	this:RegisterEvent("MONEYJZ_CHANGE",false);
	this:RegisterEvent("PACKAGE_ITEM_CHANGED_EX",false)
end

--OnLoad
function WuhunSkillStudy_OnLoad()

end

--OnEvent
function WuhunSkillStudy_OnEvent(event)

	if (event == "UI_COMMAND" and tonumber(arg0) == m_UI_NUM) then

		WuhunSkillStudy_BeginCareObj( Get_XParam_INT(0) );
		m_UIType = Get_XParam_INT(1)
		g_Wuhun_Wx = Get_XParam_INT(2)
		
		-- 元宝确认
		-- WuhunSkillStudy_Blank_QuerenLace:Hide()

		if m_UIType == UI_TYPE_STUDY then
			WuhunSkillStudy_Title:SetText("#{WH_xml_XX(26)}")
			WuhunSkillStudy_Info:SetText("#{WH_xml_XX(27)}")
			WuhunSkillStudy_Info2:SetText("#{WH_xml_XX(28)}")

		elseif m_UIType == UI_TYPE_RESET then
			return
		elseif m_UIType == UI_TYPE_RESET_WX then
			return
		elseif m_UIType == UI_TYPE_RESET_GROWRATE1 then
			WuhunSkillStudy_Title:SetText("#{WHXCZL_xml_XX(06)}")
			WuhunSkillStudy_Info:SetText("#{WHXCZL_xml_XX(07)}")
			WuhunSkillStudy_Info2:SetText("#{WHXCZL_xml_XX(08)}")
		elseif m_UIType == UI_TYPE_RESET_GROWRATE2 then
			WuhunSkillStudy_Title:SetText("#{WHXCZL_xml_XX(06)}")
			WuhunSkillStudy_Info:SetText("#{WHXCZL_xml_XX(09)}")
			WuhunSkillStudy_Info2:SetText("#{WHXCZL_xml_XX(08)}")
			-- 元宝确认
			-- WuhunSkillStudy_Blank_QuerenLace:Show()
			if g_YBCheck == 1 then
				-- WuhunSkillStudy_Blank_Queren:SetCheck( 1 )
			elseif g_YBCheck == 0 then
				-- WuhunSkillStudy_Blank_Queren:SetCheck( 0 )
			end
		end

		WuhunSkillStudy_Update(-1)
		this:Show();
		WuhunSkillStudy_OK:Disable();
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 201107281 and this:IsVisible() ) then
		if arg1 ~= nil then
			nKfsData = SuperTooltips:GetAuthorInfo();
			WuhunSkillStudy_Update( tonumber(arg1) )
		end
	elseif (event == "UNIT_MONEY") then
		WuhunSkillStudy_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));

	elseif (event == "MONEYJZ_CHANGE") then
		WuhunSkillStudy_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))

	elseif (event == "PACKAGE_ITEM_CHANGED_EX") then
		if arg0 ~= nil and tonumber(arg0) == m_Equip_Idx then
			WuhunSkillStudy_Update(m_Equip_Idx)
		end
	end
end

--Update UI
function WuhunSkillStudy_Update(itemIdx)
	WuhunSkillStudy_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"));
	WuhunSkillStudy_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"));
	resetConfirm = 0

	local theAction = EnumAction(itemIdx, "packageitem");
	if theAction:GetID() ~= 0 then
		local nGrow,nExLevel,nLevel,nExp,nMagic,nExAttrNum,nExAttr,nSkill = LuaGetKfsAttrData(nKfsData)
		if LifeAbility : Get_Equip_Point(itemIdx) ~= 18 then
			PushDebugMessage("#{WH_090729_13}")	--此处只能放入武魂。
			return
		end

		if m_UIType == UI_TYPE_STUDY then
			local skillNum = Lua_GetBagKfsSkillNum(nSkill)
			if skillNum == 3 then
				if itemIdx == m_Equip_Idx then
					WuhunSkillStudy_Object:SetActionItem(-1);
					LifeAbility : Lock_Packet_Item(m_Equip_Idx,0);
					m_Equip_Idx = -1;
					return
				end
				PushDebugMessage("#{WH_090729_22}")	--已经有3个技能了
				return
			end
		elseif m_UIType == UI_TYPE_RESET then

			if PlayerPackage:IsLock( itemIdx ) == 1 then
				PushDebugMessage("#{WH_090729_07}")	--道具已上锁
				return
			end

			local skillNum = Lua_GetBagKfsSkillNum(nSkill)
			if skillNum == 0 then
				PushDebugMessage("#{WH_090729_33}")	--还没有领悟技能
				return
			end
		elseif m_UIType == UI_TYPE_RESET_WX then
			return
		end

		if m_Equip_Idx ~= -1 then
			LifeAbility : Lock_Packet_Item(m_Equip_Idx,0);
		end

		WuhunSkillStudy_Object:SetActionItem(theAction:GetID());
		LifeAbility : Lock_Packet_Item(itemIdx,1);
		m_Equip_Idx = itemIdx

		WuhunSkillStudy_OK:Enable();

	else
		WuhunSkillStudy_Object:SetActionItem(-1);
		LifeAbility : Lock_Packet_Item(m_Equip_Idx,0);
		m_Equip_Idx = -1;
	end

	if m_Equip_Idx ~= -1 then
		if m_UIType == UI_TYPE_STUDY then
			local skillNum = Lua_GetBagKfsSkillNum(nSkill)

			needMoney = 0
			if skillNum == 0 then
				needMoney = 50000			--第一个技能5金
			elseif 	skillNum == 1 then
				needMoney = 100000			--第二个技能10金
			elseif 	skillNum == 2 then
				needMoney = 150000			--第三个技能15金
			elseif	skillNum == 3 then
				needMoney = 0
				WuhunSkillStudy_OK:Disable();
			end
			WuhunSkillStudy_DemandMoney:SetProperty("MoneyNumber", needMoney);

		elseif m_UIType == UI_TYPE_RESET then--or m_UIType == UI_TYPE_RESET_WX then
			needMoney = 50000
			WuhunSkillStudy_DemandMoney:SetProperty("MoneyNumber", needMoney);
		elseif m_UIType == UI_TYPE_RESET_GROWRATE1 or m_UIType == UI_TYPE_RESET_GROWRATE2 then
			needMoney =50000
			WuhunSkillStudy_DemandMoney:SetProperty("MoneyNumber", needMoney);
		end
	else

		WuhunSkillStudy_DemandMoney:SetProperty("MoneyNumber", 0);
	end
end

--OnOK
function WuhunSkillStudy_Growrate2_OK_Clicked()
	
	if m_UIType ~= UI_TYPE_RESET_GROWRATE2 then
		return
	end
	
	-- 判断是否为安全时间
	if (tonumber(DataPool:GetLeftProtectTime()) > 0) then
		PushDebugMessage("#{WHYH_161121_8}")
		return
	end

	-- 是否放入武魂
	if m_Equip_Idx == -1 then
		PushDebugMessage("#{WHYH_161121_116}")
		return
	end
	if LifeAbility : Get_Equip_Point(m_Equip_Idx) ~= 18 then
		PushDebugMessage("#{WHYH_161121_116}")
		return
	end
	
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("KfsReWashGrowEx");
		Set_XSCRIPT_ScriptID(900004);
		Set_XSCRIPT_Parameter(0,m_Equip_Idx);
		Set_XSCRIPT_Parameter(1,1);
		Set_XSCRIPT_Parameter(2,g_YBCheck);
		Set_XSCRIPT_ParamCount(3);
	Send_XSCRIPT();	
end

--OnOK
function WuhunSkillStudy_OK_Clicked()

	if m_UIType == UI_TYPE_RESET_GROWRATE2 then
		WuhunSkillStudy_Growrate2_OK_Clicked()
		return
	end

	if m_Equip_Idx == -1 then
		return
	end

	local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")

	if selfMoney < needMoney then
		PushDebugMessage("#{WH_090729_18}")  --对不起，你身上金钱不足，无法继续进行
		return
	end

	if m_UIType == UI_TYPE_STUDY then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("KfsStudySkill");
			Set_XSCRIPT_ScriptID(900004);
			Set_XSCRIPT_Parameter(0,m_Equip_Idx);
			Set_XSCRIPT_ParamCount(1);
		Send_XSCRIPT();	
	elseif m_UIType == UI_TYPE_RESET then
		PlayerPackage:Kfs_Op_Do(6 , m_Equip_Idx, 0, 0, 0)--默认0，貌似这里根本走不到，保险还是加上吧
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("KfsTypeReset");
			Set_XSCRIPT_ScriptID(900004);
			Set_XSCRIPT_Parameter(0,m_Equip_Idx);
			Set_XSCRIPT_ParamCount(1);
		Send_XSCRIPT();	
    elseif m_UIType == UI_TYPE_RESET_GROWRATE1 then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("KfsReWashGrowEx");
			Set_XSCRIPT_ScriptID(900004);
			Set_XSCRIPT_Parameter(0,m_Equip_Idx);
			Set_XSCRIPT_Parameter(1,0);
			Set_XSCRIPT_ParamCount(2);
		Send_XSCRIPT();	
	end
end

--Right button clicked
function WuhunSkillStudy_Resume_Equip()

	WuhunSkillStudy_Update(-1)
    WuhunSkillStudy_OK:Disable();
end

--Care Obj
function WuhunSkillStudy_BeginCareObj(obj_id)

	m_ObjCared = DataPool : GetNPCIDByServerID(obj_id);
	this:CareObject(m_ObjCared, 1);
end

--handle Hide Event
function WuhunSkillStudy_OnHiden()

	WuhunSkillStudy_Update(-1)
	resetConfirm = 0

end

function WuhunSkillStudy_Queren_Clicked()
	-- local bCheck = WuhunSkillStudy_Blank_Queren:GetCheck();
	-- if ( bCheck == 1 ) then
		-- g_YBCheck = 1
		-- WuhunSkillStudy_Blank_Queren:SetCheck( 1 )
	-- elseif ( bCheck == 0 ) then
		-- g_YBCheck = 0
		-- WuhunSkillStudy_Blank_Queren:SetCheck( 0 )
	-- end
end

function WuhunSkillStudy_Help_Clicked()
	if m_UIType == UI_TYPE_RESET_WX then
		Helper:GotoHelper("whsx")
	else
		Helper:GotoHelper("*WuhunSkillStudy")
	end
end
