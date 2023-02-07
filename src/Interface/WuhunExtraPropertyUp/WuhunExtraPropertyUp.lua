--武魂拓展属性升级
--build 2019-7-15 16:07:05 逍遥子
local m_UI_NUM = 20090720
local m_ObjCared = -1
local m_Equip_Idx = -1
local m_Equip_Item = -1

local m_sel = -1

local INDEX_ATTRUP_BEGIN	= 20310122	--润魂石·御（1级）
local INDEX_ATTRUP_END		= 20310157	--润魂石·暴（9级）

local g_RunHunShi = {
	{
		20310122,	--润魂石·御（1级）
		20310123,	--润魂石·御（2级）
		20310124,	--润魂石·御（3级）
		20310125,	--润魂石·御（4级）
		20310126,	--润魂石·御（5级）
		20310127,	--润魂石·御（6级）
		20310128,	--润魂石·御（7级）
		20310129,	--润魂石·御（8级）
		20310130,	--润魂石·御（9级）
	},
	{
		20310131,	--润魂石·击（1级）
		20310132,	--润魂石·击（2级）
		20310133,	--润魂石·击（3级）
		20310134,	--润魂石·击（4级）
		20310135,	--润魂石·击（5级）
		20310136,	--润魂石·击（6级）
		20310137,	--润魂石·击（7级）
		20310138,	--润魂石·击（8级）
		20310139,	--润魂石·击（9级）
	},
	{
		20310140,	--润魂石·破（1级）
		20310141,	--润魂石·破（2级）
		20310142,	--润魂石·破（3级）
		20310143,	--润魂石·破（4级）
		20310144,	--润魂石·破（5级）
		20310145,	--润魂石·破（6级）
		20310146,	--润魂石·破（7级）
		20310147,	--润魂石·破（8级）
		20310148,	--润魂石·破（9级）
	},

	{
		20310149,	--润魂石·暴（1级）
		20310150,	--润魂石·暴（2级）
		20310151,	--润魂石·暴（3级）
		20310152,	--润魂石·暴（4级）
		20310153,	--润魂石·暴（5级）
		20310154,	--润魂石·暴（6级）
		20310155,	--润魂石·暴（7级）
		20310156,	--润魂石·暴（8级）
		20310157,	--润魂石·暴（9级）
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
			PushDebugMessage("#{WHYH_161121_33}") -- 此处只能放入武魂。
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
			PushDebugMessage("#{WH_090729_57}")	--没有扩展属性
			return
		end

		if m_Equip_Idx ~= -1 then
			LifeAbility : Lock_Packet_Item(m_Equip_Idx,0);
			WuhunExtraPropertyUp_Update_Sub(-1) -- 更换的时候清空放入材料
		end
		WuhunExtraPropertyUp_Object1:SetActionItem(theAction:GetID());
		LifeAbility : Lock_Packet_Item(itemIdx,1);
		m_Equip_Idx = itemIdx
	else
		WuhunExtraPropertyUp_Object1:SetActionItem(-1);			
		LifeAbility : Lock_Packet_Item(m_Equip_Idx,0);		
		m_Equip_Idx = -1;
		WuhunExtraPropertyUp_Update_Sub(-1) -- 没有武魂的时候清空放入材料
	end
	WuhunExtraPropertyUp_UICheck()
end

function WuhunExtraPropertyUp_Update_Sub(itemIdx)
	
	local theAction = EnumAction(itemIdx, "packageitem");
	if theAction:GetID() ~= 0 then
		
		-- 该界面是否已置入武魂
		if m_Equip_Idx == -1 then
			PushDebugMessage("#{WHYH_161121_35}")
			return
		end
		if LifeAbility : Get_Equip_Point(m_Equip_Idx) ~= 18 then
			PushDebugMessage("#{WHYH_161121_35}")
			return
		end
		
		-- 是否选中属性条目
		if m_sel == -1 then
			PushDebugMessage("#{WHYH_161121_36}")
			return
		end
		
		-- 所需润魂石
		local needItem = Lua_GetKfsFixAttrEx(g_EquipData,100 + m_sel,nGrow)
		if needItem == nil or needItem <= 0 then
			PushDebugMessage("#{WHYH_161121_36}")
			return
		end
		
		local itemID = PlayerPackage:GetItemTableIndex(itemIdx)
		if itemID < INDEX_ATTRUP_BEGIN or itemID > INDEX_ATTRUP_END then
			PushDebugMessage("#{WHYH_161121_37}") -- 此处只能放入润魂石。
			return
		end

		if PlayerPackage:IsLock( itemIdx ) == 1 then
			PushDebugMessage("#{WHYH_161121_38}")	--润魂石上锁了
			return
		end
		
		-- 当前润魂石是否符合已选中属性条目的升级所需
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
				local tips = string.format("升级%s#H属性需要使用一颗%s#H。您当前放入的润魂石不符合升级条目的需要，请重新放置。", iText, needItemName)
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

	-- 判断是否为安全时间
	if (tonumber(DataPool:GetLeftProtectTime()) > 0) then
		PushDebugMessage("#{WHYH_161121_8}")
		return
	end
	
	-- 是否放入武魂
	if m_Equip_Idx == -1 then
		PushDebugMessage("#{WHYH_161121_40}")
		return
	end
	if LifeAbility : Get_Equip_Point(m_Equip_Idx) ~= 18 then
		PushDebugMessage("#{WHYH_161121_40}")
		return
	end
	
	-- 是否选中属性条目
	if m_sel == -1 then
		PushDebugMessage("#{WHYH_161121_41}")
		return
	end

	-- 快捷提升
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("KfsAttrExLevelUp");
		Set_XSCRIPT_ScriptID(900004);
		Set_XSCRIPT_Parameter(0,m_Equip_Idx);
		Set_XSCRIPT_Parameter(1,-1);
		Set_XSCRIPT_Parameter(2,m_sel);
		Set_XSCRIPT_Parameter(3,1);-- 0 普通 1 快捷 2 快捷确认
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
		PushDebugMessage("#{WH_090729_30}")   --请选择需要升级的属性
		return
	end
	local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")
	local needItem,needMoney = Lua_GetKfsFixAttrEx(g_EquipData,100 + m_sel,nGrow)
	
	if selfMoney < needMoney then
		PushDebugMessage("#{WH_090729_18}")   --对不起，你身上金钱不足，无法继续进行。
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
		PushDebugMessage("#{WH_xml_XX(98)}"..needItemName)	 --升级该属性需要道具：XXX
		return
	elseif needItem ~= nil and needItem <= 0 then
		PushDebugMessage("#{WH_090828_01}")	 --该属性已经达到最高等级，不能继续升级！
		return
	end
	
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("KfsAttrExLevelUp");
		Set_XSCRIPT_ScriptID(900004);
		Set_XSCRIPT_Parameter(0,m_Equip_Idx);
		Set_XSCRIPT_Parameter(1,m_Equip_Item);
		Set_XSCRIPT_Parameter(2,m_sel);
		Set_XSCRIPT_Parameter(3,0);-- 0 普通 1 快捷 2 快捷确认
		Set_XSCRIPT_ParamCount(4);
	Send_XSCRIPT();	
	WuhunExtraPropertyUp_Update(-1)
end

--Select 1 Attr
function WuhunExtraPropertyUp_Select_AttrEx(idx)
	-- 相同则不必更新
	if m_sel == idx then
		return
	end
	
	m_sel = idx
	local _,needMoney = Lua_GetKfsFixAttrEx(g_EquipData,100 + m_sel,nGrow)
	WuhunExtraPropertyUp_DemandMoney : SetProperty("MoneyNumber", needMoney)
	
	-- 清空材料栏并在uicheck里更新所需材料
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
	-- 所需润魂石
	WuhunExtraPropertyUp_Object3:SetActionItem(-1)
	-- 快捷提升	
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
		
			-- 所需润魂石<8级
			local needItem,needMoney = Lua_GetKfsFixAttrEx(g_EquipData,100 + m_sel,nGrow)
--			PushDebugMessage("needItem "..needItem)
			if needItem ~= nil and needItem > 0 then
				local needLevel = WuhunExtraPropertyUp_NeedLevel(needItem)
				if needLevel ~= nil and needLevel > 0 and needLevel < g_LevelMax then
					-- 润魂石
					local theAction = GemMelting:UpdateProductAction(needItem)
					if theAction:GetID() ~= 0 then
						WuhunExtraPropertyUp_Object3:SetActionItem(theAction:GetID())
					end
					-- 金钱
					WuhunExtraPropertyUp_DemandMoney : SetProperty("MoneyNumber", needMoney)
				end					
			end
			
			-- 快捷提升	
			WuhunExtraPropertyUp_QuicklyUp:Enable()
			WuhunExtraPropertyUp_QuicklyUp:SetText("#{WHYH_161121_131}")
			WuhunExtraPropertyUp_QuicklyUp_Animate:SetToolTip(string.format("#Y您可通过直接支付元宝的方式，将武魂的扩展属性提升至%s#Y级。提升前的扩展属性等级不同，提升至%s#Y级所需支付的元宝数量也不同。", g_LevelMax, g_LevelMax))--目前只开放到8级--是不是字典配置更好？？
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
