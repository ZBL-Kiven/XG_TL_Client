--�����չ��������
--build 2019-7-15 16:07:05 ��ң��
local m_UI_NUM = 20090720
local m_ObjCared = -1
local m_Equip_Idx = -1
local m_Equip_Item = -1

local m_sel = -1

local INDEX_ATTRUP_BEGIN	= 20310122	--���ʯ������1����
local INDEX_ATTRUP_END		= 20310157	--���ʯ������9����

local g_RunHunShi = {
	{
		20310122,	--���ʯ������1����
		20310123,	--���ʯ������2����
		20310124,	--���ʯ������3����
		20310125,	--���ʯ������4����
		20310126,	--���ʯ������5����
		20310127,	--���ʯ������6����
		20310128,	--���ʯ������7����
		20310129,	--���ʯ������8����
		20310130,	--���ʯ������9����
	},
	{
		20310131,	--���ʯ������1����
		20310132,	--���ʯ������2����
		20310133,	--���ʯ������3����
		20310134,	--���ʯ������4����
		20310135,	--���ʯ������5����
		20310136,	--���ʯ������6����
		20310137,	--���ʯ������7����
		20310138,	--���ʯ������8����
		20310139,	--���ʯ������9����
	},
	{
		20310140,	--���ʯ���ƣ�1����
		20310141,	--���ʯ���ƣ�2����
		20310142,	--���ʯ���ƣ�3����
		20310143,	--���ʯ���ƣ�4����
		20310144,	--���ʯ���ƣ�5����
		20310145,	--���ʯ���ƣ�6����
		20310146,	--���ʯ���ƣ�7����
		20310147,	--���ʯ���ƣ�8����
		20310148,	--���ʯ���ƣ�9����
	},

	{
		20310149,	--���ʯ������1����
		20310150,	--���ʯ������2����
		20310151,	--���ʯ������3����
		20310152,	--���ʯ������4����
		20310153,	--���ʯ������5����
		20310154,	--���ʯ������6����
		20310155,	--���ʯ������7����
		20310156,	--���ʯ������8����
		20310157,	--���ʯ������9����
	},
}

local g_LevelMax = 8
local g_EquipData = ""
local nGrow = ""
local m_AttrBnList = {}
--PreLoad
function WuhunExtraPropertyUp_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("UPDATE_KFSATTRLEVELUP")
	this:RegisterEvent("UNIT_MONEY",false);
	this:RegisterEvent("MONEYJZ_CHANGE",false);
	this:RegisterEvent("PACKAGE_ITEM_CHANGED_EX",false)
end

--Onload
function WuhunExtraPropertyUp_OnLoad()
	m_AttrBnList[1] = WuhunExtraPropertyUp_Property1
	m_AttrBnList[2] = WuhunExtraPropertyUp_Property2
	m_AttrBnList[3] = WuhunExtraPropertyUp_Property3
	m_AttrBnList[4] = WuhunExtraPropertyUp_Property4
	m_AttrBnList[5] = WuhunExtraPropertyUp_Property5
	m_AttrBnList[6] = WuhunExtraPropertyUp_Property6
	m_AttrBnList[7] = WuhunExtraPropertyUp_Property7
	m_AttrBnList[8] = WuhunExtraPropertyUp_Property8
	m_AttrBnList[9] = WuhunExtraPropertyUp_Property9
	m_AttrBnList[10] = WuhunExtraPropertyUp_Property10
end

--OnEvent
function WuhunExtraPropertyUp_OnEvent(event)
	if (event == "UI_COMMAND" and tonumber(arg0) == m_UI_NUM) then
		
		WuhunExtraPropertyUp_BeginCareObj( Get_XParam_INT(0) );
		
		WuhunExtraPropertyUp_Update(-1)
		WuhunExtraPropertyUp_Update_Sub(-1)
		this:Show();

	elseif (event == "UI_COMMAND" and tonumber(arg0) == 201107281 and this:IsVisible() ) then
		if m_Equip_Idx ~= -1 then
			WuhunExtraPropertyUp_Update_Sub( tonumber(arg1) )
		else 
			local nGrowEx,_,_,_,_,_,nExAttr = LuaGetKfsAttrData(SuperTooltips:GetAuthorInfo())
			g_EquipData = nExAttr
			nGrow = nGrowEx
			WuhunExtraPropertyUp_Update( tonumber(arg1) )
		end
	elseif (event == "UNIT_MONEY") then
		WuhunExtraPropertyUp_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
	
	elseif (event == "MONEYJZ_CHANGE") then 
		WuhunExtraPropertyUp_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
	
	elseif (event == "PACKAGE_ITEM_CHANGED_EX") then
		if arg0 ~= nil and tonumber(arg0) == m_Equip_Idx then
			WuhunExtraPropertyUp_Update(m_Equip_Idx)
		elseif  arg0 ~= nil and tonumber(arg0) == m_Equip_Item then
			WuhunExtraPropertyUp_Update_Sub(m_Equip_Item)
		end 
	end
end

--Update UI
function WuhunExtraPropertyUp_Update(itemIdx)
	
	local theAction = EnumAction(itemIdx, "packageitem");
	if theAction:GetID() ~= 0 then
		
		if LifeAbility : Get_Equip_Point(itemIdx) ~= 18 then
			PushDebugMessage("#{WHYH_161121_33}") -- �˴�ֻ�ܷ�����ꡣ
			return
		end

		local attrNum = Lua_GetKfsFixAttrEx(g_EquipData,0,nGrow)
		if attrNum ~= nil and attrNum <= 0 then
			if m_Equip_Idx == itemIdx then
				WuhunExtraPropertyUp_Object1:SetActionItem(-1);			
				LifeAbility : Lock_Packet_Item(m_Equip_Idx,0);		
				m_Equip_Idx = -1;
				return
			end
			PushDebugMessage("#{WH_090729_57}")	--û����չ����
			return
		end

		if m_Equip_Idx ~= -1 then
			LifeAbility : Lock_Packet_Item(m_Equip_Idx,0);
			WuhunExtraPropertyUp_Update_Sub(-1) -- ������ʱ����շ������
		end
		WuhunExtraPropertyUp_Object1:SetActionItem(theAction:GetID());
		LifeAbility : Lock_Packet_Item(itemIdx,1);
		m_Equip_Idx = itemIdx
	else
		WuhunExtraPropertyUp_Object1:SetActionItem(-1);			
		LifeAbility : Lock_Packet_Item(m_Equip_Idx,0);		
		m_Equip_Idx = -1;
		WuhunExtraPropertyUp_Update_Sub(-1) -- û������ʱ����շ������
	end
	WuhunExtraPropertyUp_UICheck()
end

function WuhunExtraPropertyUp_Update_Sub(itemIdx)
	
	local theAction = EnumAction(itemIdx, "packageitem");
	if theAction:GetID() ~= 0 then
		
		-- �ý����Ƿ����������
		if m_Equip_Idx == -1 then
			PushDebugMessage("#{WHYH_161121_35}")
			return
		end
		if LifeAbility : Get_Equip_Point(m_Equip_Idx) ~= 18 then
			PushDebugMessage("#{WHYH_161121_35}")
			return
		end
		
		-- �Ƿ�ѡ��������Ŀ
		if m_sel == -1 then
			PushDebugMessage("#{WHYH_161121_36}")
			return
		end
		
		-- �������ʯ
		local needItem = Lua_GetKfsFixAttrEx(g_EquipData,100 + m_sel,nGrow)
		if needItem == nil or needItem <= 0 then
			PushDebugMessage("#{WHYH_161121_36}")
			return
		end
		
		local itemID = PlayerPackage:GetItemTableIndex(itemIdx)
		if itemID < INDEX_ATTRUP_BEGIN or itemID > INDEX_ATTRUP_END then
			PushDebugMessage("#{WHYH_161121_37}") -- �˴�ֻ�ܷ������ʯ��
			return
		end

		if PlayerPackage:IsLock( itemIdx ) == 1 then
			PushDebugMessage("#{WHYH_161121_38}")	--���ʯ������
			return
		end
		
		-- ��ǰ���ʯ�Ƿ������ѡ��������Ŀ����������
		if itemID ~= needItem then
			if m_Equip_Item == itemIdx then
				WuhunExtraPropertyUp_Object2:SetActionItem(-1);			
				LifeAbility : Lock_Packet_Item(m_Equip_Item,0);		
				m_Equip_Item = -1;
				return
			end
			local needItemName = LuaFnGetItemName(needItem)
			local iText , iValue = Lua_GetKfsFixAttrEx(g_EquipData,m_sel,nGrow)
			if iValue ~= nil and iValue > 0 and iText ~= nil then
				local tips = string.format("����%s#H������Ҫʹ��һ��%s#H������ǰ��������ʯ������������Ŀ����Ҫ�������·��á�", iText, needItemName)
				PushDebugMessage(tips)
			end
			return
		end

		if m_Equip_Item ~= -1 then
			LifeAbility : Lock_Packet_Item(m_Equip_Item,0);
		end

		WuhunExtraPropertyUp_Object2:SetActionItem(theAction:GetID());
		LifeAbility : Lock_Packet_Item(itemIdx,1);
		m_Equip_Item = itemIdx
	else
		WuhunExtraPropertyUp_Object2:SetActionItem(-1);			
		LifeAbility : Lock_Packet_Item(m_Equip_Item,0);		
		m_Equip_Item = -1;
	end
	WuhunExtraPropertyUp_UICheck()
end

--Care Obj
function WuhunExtraPropertyUp_BeginCareObj(obj_id)
	
	m_ObjCared = DataPool : GetNPCIDByServerID(obj_id);
	this:CareObject(m_ObjCared, 1);
end

-- quick ok
function WuhunExtraPropertyUp_Quick_OK_Clicked()

	-- �ж��Ƿ�Ϊ��ȫʱ��
	if (tonumber(DataPool:GetLeftProtectTime()) > 0) then
		PushDebugMessage("#{WHYH_161121_8}")
		return
	end
	
	-- �Ƿ�������
	if m_Equip_Idx == -1 then
		PushDebugMessage("#{WHYH_161121_40}")
		return
	end
	if LifeAbility : Get_Equip_Point(m_Equip_Idx) ~= 18 then
		PushDebugMessage("#{WHYH_161121_40}")
		return
	end
	
	-- �Ƿ�ѡ��������Ŀ
	if m_sel == -1 then
		PushDebugMessage("#{WHYH_161121_41}")
		return
	end

	-- �������
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("KfsAttrExLevelUp");
		Set_XSCRIPT_ScriptID(900004);
		Set_XSCRIPT_Parameter(0,m_Equip_Idx);
		Set_XSCRIPT_Parameter(1,-1);
		Set_XSCRIPT_Parameter(2,m_sel);
		Set_XSCRIPT_Parameter(3,1);-- 0 ��ͨ 1 ��� 2 ���ȷ��
		Set_XSCRIPT_ParamCount(4);
	Send_XSCRIPT();	
	WuhunExtraPropertyUp_Update(-1)
end

--OK
function WuhunExtraPropertyUp_OK_Clicked()

	if m_Equip_Idx == -1 or m_Equip_Item == -1 then
		return
	end
	
	if m_sel == -1 then
		PushDebugMessage("#{WH_090729_30}")   --��ѡ����Ҫ����������
		return
	end
	local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")
	local needItem,needMoney = Lua_GetKfsFixAttrEx(g_EquipData,100 + m_sel,nGrow)
	
	if selfMoney < needMoney then
		PushDebugMessage("#{WH_090729_18}")   --�Բ��������Ͻ�Ǯ���㣬�޷��������С�
		return
	end
	
	local itemIndex = PlayerPackage:GetItemTableIndex(m_Equip_Item)
	
	if needItem == nil then
		return
	end
	
	if needItem <= 0 then
		return
	end

	if needItem ~= nil and needItem > 0 and itemIndex ~= needItem then
		local needItemName = LuaFnGetItemName(needItem)
		PushDebugMessage("#{WH_xml_XX(98)}"..needItemName)	 --������������Ҫ���ߣ�XXX
		return
	elseif needItem ~= nil and needItem <= 0 then
		PushDebugMessage("#{WH_090828_01}")	 --�������Ѿ��ﵽ��ߵȼ������ܼ���������
		return
	end
	
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("KfsAttrExLevelUp");
		Set_XSCRIPT_ScriptID(900004);
		Set_XSCRIPT_Parameter(0,m_Equip_Idx);
		Set_XSCRIPT_Parameter(1,m_Equip_Item);
		Set_XSCRIPT_Parameter(2,m_sel);
		Set_XSCRIPT_Parameter(3,0);-- 0 ��ͨ 1 ��� 2 ���ȷ��
		Set_XSCRIPT_ParamCount(4);
	Send_XSCRIPT();	
	WuhunExtraPropertyUp_Update(-1)
end

--Select 1 Attr
function WuhunExtraPropertyUp_Select_AttrEx(idx)
	-- ��ͬ�򲻱ظ���
	if m_sel == idx then
		return
	end
	
	m_sel = idx
	local _,needMoney = Lua_GetKfsFixAttrEx(g_EquipData,100 + m_sel,nGrow)
	WuhunExtraPropertyUp_DemandMoney : SetProperty("MoneyNumber", needMoney)
	
	-- ��ղ���������uicheck������������
	WuhunExtraPropertyUp_Update_Sub(-1)
						
end

--Close UI
function WuhunExtraPropertyUp_Close()
	this:Hide();
end

--Handle UI Closed
function WuhunExtraPropertyUp_OnHiden()
	WuhunExtraPropertyUp_Update(-1)
	WuhunExtraPropertyUp_Update_Sub(-1)
end

--
function WuhunExtraPropertyUp_Resume_Equip()
	WuhunExtraPropertyUp_Update(-1)
end

function WuhunExtraPropertyUp_Resume_Item()
	WuhunExtraPropertyUp_Update_Sub(-1)
end


function WuhunExtraPropertyUp_UICheck()
	WuhunExtraPropertyUp_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"));
	WuhunExtraPropertyUp_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ")); 
	WuhunExtraPropertyUp_DemandMoney : SetProperty("MoneyNumber", 0)
	WuhunExtraPropertyUp_OK:Disable()
	-- �������ʯ
	WuhunExtraPropertyUp_Object3:SetActionItem(-1)
	-- �������	
	WuhunExtraPropertyUp_QuicklyUp:Disable()
	WuhunExtraPropertyUp_QuicklyUp:SetText("#{WHYH_161121_31}")
	WuhunExtraPropertyUp_QuicklyUp_Animate:SetToolTip("")
	WuhunExtraPropertyUp_QuicklyUp_Animate:Play(false)

	for i = 1 , 10 do
		m_AttrBnList[i]:Disable()
		m_AttrBnList[i]:SetText("")
		m_AttrBnList[i]:SetCheck(0)
	end

	if m_Equip_Idx ~= -1 then
		local attrNum = Lua_GetKfsFixAttrEx(g_EquipData,0,nGrow)
		if attrNum ~= nil and attrNum > 0 then
			for i = 1 , attrNum do
				local iText , iValue = Lua_GetKfsFixAttrEx(g_EquipData,i,nGrow)
				if iValue ~= nil and iValue > 0 and iText ~= nil then
					m_AttrBnList[i]:Enable()
					m_AttrBnList[i]:SetText(iText)
				end
			end
			if m_sel <= 0 or m_sel > attrNum then
				m_sel = 1
				m_AttrBnList[1]:SetCheck(1)
			else
				m_AttrBnList[m_sel]:SetCheck(1)
			end
		
			-- �������ʯ<8��
			local needItem,needMoney = Lua_GetKfsFixAttrEx(g_EquipData,100 + m_sel,nGrow)
--			PushDebugMessage("needItem "..needItem)
			if needItem ~= nil and needItem > 0 then
				local needLevel = WuhunExtraPropertyUp_NeedLevel(needItem)
				if needLevel ~= nil and needLevel > 0 and needLevel < g_LevelMax then
					-- ���ʯ
					local theAction = GemMelting:UpdateProductAction(needItem)
					if theAction:GetID() ~= 0 then
						WuhunExtraPropertyUp_Object3:SetActionItem(theAction:GetID())
					end
					-- ��Ǯ
					WuhunExtraPropertyUp_DemandMoney : SetProperty("MoneyNumber", needMoney)
				end					
			end
			
			-- �������	
			WuhunExtraPropertyUp_QuicklyUp:Enable()
			WuhunExtraPropertyUp_QuicklyUp:SetText("#{WHYH_161121_131}")
			WuhunExtraPropertyUp_QuicklyUp_Animate:SetToolTip(string.format("#Y����ͨ��ֱ��֧��Ԫ���ķ�ʽ����������չ����������%s#Y��������ǰ����չ���Եȼ���ͬ��������%s#Y������֧����Ԫ������Ҳ��ͬ��", g_LevelMax, g_LevelMax))--Ŀǰֻ���ŵ�8��--�ǲ����ֵ����ø��ã���
			WuhunExtraPropertyUp_QuicklyUp_Animate:Play(true)
		end
	else
		m_sel = -1
	end
	
	if m_Equip_Idx ~= -1 and m_Equip_Item ~= -1 then
		WuhunExtraPropertyUp_OK:Enable()
	end
end

function WuhunExtraPropertyUp_NeedLevel(needItem)
	if needItem == nil or needItem <= 0 then
		return 0
	end
	
	for i = 1, 4 do
		if needItem >= g_RunHunShi[i][1] and needItem <= g_RunHunShi[i][9] then
			for j = 1, 9 do
				if g_RunHunShi[i][j] == needItem then
					return j
				end
			end
		end
	end
	
	return 0
end
