--  WuhunShuXiangChange
local m_UI_NUM = 20090722
local m_ObjCared = -1
local m_Equip_Idx = -1

--local UI_TYPE_STUDY	= 1
--local UI_TYPE_RESET	= 2
local UI_TYPE_RESET_WX = 3
--local UI_TYPE_RESET_GROWRATE1 = 4 --回天精石重洗武魂成长率
--local UI_TYPE_RESET_GROWRATE2 = 5 --回天神石重洗武魂成长率
local m_UIType = 0

local needMoney = 0

local g_YBCheck = 1--默认选中
local g_EquipData = ""

local g_Wuhun_Wx = -1;
local g_Wuhun_Button = {}

--PreLoad
function WuhunShuXiangChange_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("UPDATE_KFS_SHUXIANG")
	this:RegisterEvent("UNIT_MONEY",false);
	this:RegisterEvent("MONEYJZ_CHANGE",false);
	this:RegisterEvent("PACKAGE_ITEM_CHANGED_EX",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)	--进场景关闭界面
end

--OnLoad
function WuhunShuXiangChange_OnLoad()
	g_Wuhun_Button[1] = WuhunShuXiangChange_ShuXiang1
	g_Wuhun_Button[2] = WuhunShuXiangChange_ShuXiang2
	g_Wuhun_Button[3] = WuhunShuXiangChange_ShuXiang3
	g_Wuhun_Button[4] = WuhunShuXiangChange_ShuXiang4
end

--OnEvent
function WuhunShuXiangChange_OnEvent(event)

	if (event == "UI_COMMAND" and tonumber(arg0) == m_UI_NUM) then

		local objid = Get_XParam_INT(0)
		m_UIType = Get_XParam_INT(1)

		if m_UIType == UI_TYPE_RESET_WX then
		
			if Get_XParam_INT(2) ~= nil and Get_XParam_INT(2) == 1 then
				if this:IsVisible() then
					this:Hide()
				end
				return
			end
			
			WuhunShuXiangChange_BeginCareObj( objid );
			
			local strInfo = Get_XParam_STR(0)		
			WuhunShuXiangChange_Info:SetText(strInfo)
				
			WuhunShuXiangChange_Update(-1)
			
			this:Show();
				
			-- 元宝确认
			if g_YBCheck == 1 then
				WuhunShuXiangChange_Blank_Queren:SetCheck( 1 )
			elseif g_YBCheck == 0 then
				WuhunShuXiangChange_Blank_Queren:SetCheck( 0 )
			end
		end
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 201107281 and this:IsVisible() ) then

		if arg1 ~= nil then
			g_EquipData = SuperTooltips:GetAuthorInfo();
			WuhunShuXiangChange_Update( tonumber(arg1) )
		end

	elseif (event == "UNIT_MONEY") then
		WuhunShuXiangChange_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));

	elseif (event == "MONEYJZ_CHANGE") then
		WuhunShuXiangChange_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))

	elseif (event == "PACKAGE_ITEM_CHANGED_EX") then
		if arg0 ~= nil and tonumber(arg0) == m_Equip_Idx then
			WuhunShuXiangChange_Update(m_Equip_Idx)
		end
	elseif ( event == "HIDE_ON_SCENE_TRANSED" ) then
		this:Hide()
	end
end

--Update UI
function WuhunShuXiangChange_Update(itemIdx)
	WuhunShuXiangChange_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"));
	WuhunShuXiangChange_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"));
	
	local theAction = EnumAction(itemIdx, "packageitem");
	if theAction:GetID() ~= 0 then

		if LifeAbility : Get_Equip_Point(itemIdx) ~= 18 then
			PushDebugMessage("#{WHYH_161121_33}")--此处只能放入武魂。
			return
		end
		
		local _,_,_,_,nWx = LuaGetKfsAttrData(g_EquipData);
		if nWx == 0 then
			PushDebugMessage("#{WHYH_161121_101}")--还没有领悟五行
			return
		end

		if m_Equip_Idx ~= -1 then
			LifeAbility : Lock_Packet_Item(m_Equip_Idx,0);
		end

		WuhunShuXiangChange_Object:SetActionItem(theAction:GetID());
		LifeAbility : Lock_Packet_Item(itemIdx,1);
		m_Equip_Idx = itemIdx

		WuhunShuXiangChange_OK:Enable()
			
		-- 属相按钮
		g_Wuhun_Wx = 1--默认选中
		for i=1, table.getn(g_Wuhun_Button) do
			g_Wuhun_Button[i]:Enable();
			if i == g_Wuhun_Wx then
				g_Wuhun_Button[i]:SetCheck(1)
			else
				g_Wuhun_Button[i]:SetCheck(0)
			end
		end
	else
		WuhunShuXiangChange_Object:SetActionItem(-1);
		LifeAbility : Lock_Packet_Item(m_Equip_Idx,0);
		m_Equip_Idx = -1;
	end

	if m_Equip_Idx ~= -1 then
		needMoney = 50000
		WuhunShuXiangChange_DemandMoney:SetProperty("MoneyNumber", needMoney);
	else
		WuhunShuXiangChange_DemandMoney:SetProperty("MoneyNumber", 0);
		
	  WuhunShuXiangChange_OK:Disable()
	  g_Wuhun_Wx = -1--默认选中
		for i=1, table.getn(g_Wuhun_Button) do
			g_Wuhun_Button[i]:Disable()
			g_Wuhun_Button[i]:SetCheck(0)
		end
	end
end

--OnOK
function WuhunShuXiangChange_OK_Clicked()

	-- 判断是否为安全时间
	if (tonumber(DataPool:GetLeftProtectTime()) > 0) then
		PushDebugMessage("#{WHYH_161121_8}")
		return
	end
	
	if m_Equip_Idx == -1 then
		PushDebugMessage("#{WHYH_161121_127}")
		return
	end
	if LifeAbility : Get_Equip_Point(m_Equip_Idx) ~= 18 then
		PushDebugMessage("#{WHYH_161121_127}")
		return
	end
	
	local _,_,_,_,nWx = LuaGetKfsAttrData(g_EquipData);
	if nWx == 0 then
		PushDebugMessage("#{WHYH_161121_101}")	--还没有领悟五行
		return
	end
	
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("KfsChangeMagic");
		Set_XSCRIPT_ScriptID(900004);
		Set_XSCRIPT_Parameter(0,m_Equip_Idx);
		Set_XSCRIPT_Parameter(1,g_Wuhun_Wx);
		Set_XSCRIPT_Parameter(2,g_YBCheck);
		Set_XSCRIPT_ParamCount(3);
	Send_XSCRIPT();
	--this:Hide();
	WuhunShuXiangChange_Resume_Equip()
end

--Right button clicked
function WuhunShuXiangChange_Resume_Equip()

	WuhunShuXiangChange_Update(-1)

end

--Care Obj
function WuhunShuXiangChange_BeginCareObj(obj_id)

	m_ObjCared = DataPool : GetNPCIDByServerID(obj_id);
	this:CareObject(m_ObjCared, 1);
end

--handle Hide Event
function WuhunShuXiangChange_OnHiden()

	WuhunShuXiangChange_Update(-1)

end

function WuhunShuXiangChange_ShuXiang_Clicked(nIndex)
	if nIndex == nil or nIndex <= 0 or nIndex > table.getn(g_Wuhun_Button) then
		return
	end
	
	if nIndex == g_Wuhun_Wx then
		return
	end
	
	g_Wuhun_Wx = nIndex
	
	for i=1, table.getn(g_Wuhun_Button) do
		if i == g_Wuhun_Wx then
			g_Wuhun_Button[i]:SetCheck(1)
		else
			g_Wuhun_Button[i]:SetCheck(0)
		end
	end
end

function WuhunShuXiangChange_Queren_Clicked()
	local bCheck = WuhunShuXiangChange_Blank_Queren:GetCheck();
	if ( bCheck == 1 ) then
		g_YBCheck = 1
		WuhunShuXiangChange_Blank_Queren:SetCheck( 1 )
	elseif ( bCheck == 0 ) then
		g_YBCheck = 0
		WuhunShuXiangChange_Blank_Queren:SetCheck( 0 )
	end
end

function WuhunShuXiangChange_Help_Clicked()
	if m_UIType == UI_TYPE_RESET_WX then
		Helper:GotoHelper("whsx")
	else
		Helper:GotoHelper("*WuhunShuXiangChange")
	end
end
