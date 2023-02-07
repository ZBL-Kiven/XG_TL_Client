--WuhunMagicUp
--build 2019-7-15 11:09:17 逍遥子 QQ857904341
local m_UI_NUM = 20090721
local m_ObjCared = -1
local m_Equip_Idx = -1
local m_Equip_Item = -1
local g_ItemItm   = -1;
local UI_TYPE_ATTR	= 1--武魂扩展属性学习
local UI_TYPE_COMPOUND	= 2--武魂提升灵力
local UI_TYPE_LIFE	= 3--武魂增加寿命
local UI_TYPE_SLOT	= 4--武魂开辟属性栏

local m_UIType = 0

local m_Money_COMPOUND = {}

local INDEX_ATTRBOOK_BEGIN	= 30700214	--御·折冰属性书
local INDEX_ATTRBOOK_END	= 30700229	--暴·拔毒属性书

local INDEX_ADDLIFE = 30700233 --延寿丹

local INDEX_SLOT_ITEM1 = 20310158 --麟木剑
local INDEX_SLOT_ITEM2 = 20310159 --破天剑

local needMoney = 0

local needConfirm = 1

local g_YBCheck = 1--默认选中
g_WuHun_Material_Buy = -1
local g_EquipData_1 = ""
local g_EquipData_2 = ""

local g_LastTimer = -1 --增加点击扩展武魂属性的冷却时间
local MIN_PASS_TIME = 1 --冷却时间1秒

--PreLoad
function WuhunMagicUp_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("UPDATE_KFS_MAGICUP")
	this:RegisterEvent("UNIT_MONEY",false);
	this:RegisterEvent("MONEYJZ_CHANGE",false);
	this:RegisterEvent("BUY_ITEM")
	this:RegisterEvent("PACKAGE_ITEM_CHANGED_EX",false);
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)	--进场景关闭界面
	this:RegisterEvent("RESUME_ENCHASE_GEM_EX",false)
end

--OnLoad
function WuhunMagicUp_OnLoad()
	--武魂合成消耗Money
	m_Money_COMPOUND[1] = 800000
	m_Money_COMPOUND[2] = 800000
	m_Money_COMPOUND[3] = 800000
	m_Money_COMPOUND[4] = 800000
	m_Money_COMPOUND[5] = 800000
	m_Money_COMPOUND[6] = 800000
	m_Money_COMPOUND[7] = 800000
	m_Money_COMPOUND[8] = 800000
	m_Money_COMPOUND[9] = 800000


end

--OnEvent
function WuhunMagicUp_OnEvent(event)

	if (event == "UI_COMMAND" and tonumber(arg0) == m_UI_NUM) then
		
		WuhunMagicUp_BeginCareObj( Get_XParam_INT(0) );
		m_UIType = Get_XParam_INT(1)
		
		-- 元宝确认
		WuhunMagicUp_Blank_QuerenLace:Hide()

		if m_UIType == UI_TYPE_ATTR then
			WuhunMagicUp_Title:SetText("#{WH_xml_XX(22)}")	--扩展属性学习
			WuhunMagicUp_Info:SetText("#{WH_xml_XX(23)}")
			WuhunMagicUp_Info2:SetText("#{WH_xml_XX(24)}")
			WuhunMagicUp_Info3:SetText("#{WH_xml_XX(25)}")
		
		elseif m_UIType == UI_TYPE_COMPOUND then
			WuhunMagicUp_Title:SetText("#{WH_xml_XX(18)}")	--合成
			WuhunMagicUp_Info:SetText("#{WH_xml_XX(19)}")
			WuhunMagicUp_Info2:SetText("#{WH_xml_XX(20)}")
			WuhunMagicUp_Info3:SetText("#{WH_xml_XX(21)}")
		
		elseif m_UIType == UI_TYPE_LIFE then
			if Get_XParam_INT(2) ~= nil and Get_XParam_INT(2) == 1 then
				if this:IsVisible() then
					this:Hide()
				end
				return
			end
			WuhunMagicUp_Title:SetText("#{WH_xml_XX(42)}")	--增加寿命
			WuhunMagicUp_Info:SetText("#{WH_xml_XX(43)}")
			WuhunMagicUp_Info2:SetText("#{WH_xml_XX(44)}")
			WuhunMagicUp_Info3:SetText("#{WH_xml_XX(45)}")
			-- 元宝确认
			WuhunMagicUp_Blank_QuerenLace:Show()
			if g_YBCheck == 1 then
				WuhunMagicUp_Blank_Queren:SetCheck( 1 )
			elseif g_YBCheck == 0 then
				WuhunMagicUp_Blank_Queren:SetCheck( 0 )
			end
		elseif m_UIType == UI_TYPE_SLOT then
			return
			--WuhunMagicUp_Title:SetText("#{WH_xml_XX(84)}")	--开辟属性栏
			--WuhunMagicUp_Info:SetText("#{WH_xml_XX(85)}")
			--WuhunMagicUp_Info2:SetText("#{WH_xml_XX(86)}")
			--WuhunMagicUp_Info3:SetText("#{WH_xml_XX(87)}")
		end		

		WuhunMagicUp_Update(-1)
		WuhunMagicUp_Update_Sub(-1)
		this:Show();
	
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 201107281 and this:IsVisible()) then
		if m_Equip_Idx ~= -1 then
			WuhunMagicUp_Update_Sub( tonumber(arg1) )
		else 
			g_EquipData_1 = SuperTooltips:GetAuthorInfo(); 
			WuhunMagicUp_Update( tonumber(arg1) )
		end
	elseif (event == "RESUME_ENCHASE_GEM_EX" and this:IsVisible()) then
		if(arg0~=nil and tonumber(arg0) == 85) then
			WuhunMagicUp_Resume_Equip()
		elseif(arg0~=nil and tonumber(arg0) == 86) then
			WuhunMagicUp_Resume_Item()
		end
	elseif (event == "UNIT_MONEY") then
		WuhunMagicUp_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
	
	elseif (event == "MONEYJZ_CHANGE") then 
		WuhunMagicUp_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
	
	elseif event == "BUY_ITEM" and this:IsVisible() then
		if m_UIType == UI_TYPE_LIFE and m_Equip_Idx ~= -1 and g_WuHun_Material_Buy > 0 then
			local item = tonumber(arg1)
			if item > 0 then
				if INDEX_ADDLIFE ~= item then 
					return 
				end
				local itemIdx = PlayerPackage:GetBagPosByItemIndex(item)
				if itemIdx >= 0 then
					g_WuHun_Material_Buy = -1
					WuhunMagicUp_Update_Sub(itemIdx)
				end
			end
		end

	elseif (event == "PACKAGE_ITEM_CHANGED_EX") then
		if arg0 ~= nil and tonumber(arg0) == m_Equip_Idx then
			WuhunMagicUp_Update(m_Equip_Idx)
		elseif  arg0 ~= nil and tonumber(arg0) == m_Equip_Item then
--			if (g_ItemItm ~= -1) then
--				local nextItem = PlayerPackage : GetBagPosByItemIndex(g_ItemItm)
--				if nextItem >=0 then
--					WuhunMagicUp_Update_Sub(nextItem)
--				else
--					WuhunMagicUp_Update_Sub(-1)
--				end
--			else
--				WuhunMagicUp_Update_Sub(-1)
--			end
		end
	elseif ( event == "HIDE_ON_SCENE_TRANSED" ) then
		this:Hide()
	end
end

--Update UI
function WuhunMagicUp_Update(itemIdx)
	local theAction = EnumAction(itemIdx, "packageitem");
	if theAction:GetID() ~= 0 then
		if LifeAbility : Get_Equip_Point(itemIdx) ~= 18 then
			PushDebugMessage("#{WH_090729_13}") -- 此处只能放入武魂。
			return
		end
		if m_UIType == UI_TYPE_COMPOUND then
			
		elseif  m_UIType == UI_TYPE_ATTR then
			
		elseif m_UIType == UI_TYPE_LIFE then

		elseif  m_UIType == UI_TYPE_SLOT then
			return
		end
		
		if m_Equip_Idx ~= -1 then
			LifeAbility : Lock_Packet_Item(m_Equip_Idx,0);
		end
		
		WuhunMagicUp_Object1:SetActionItem(theAction:GetID());
		LifeAbility : Lock_Packet_Item(itemIdx,1);
		m_Equip_Idx = itemIdx
		
	else
		WuhunMagicUp_Object1:SetActionItem(-1);			
		LifeAbility : Lock_Packet_Item(m_Equip_Idx,0);		
		m_Equip_Idx = -1;
	end
	WuhunMagicUp_UICheck();

end

function WuhunMagicUp_Update_Sub(itemIdx)
	local theAction = EnumAction(itemIdx, "packageitem");
	if theAction:GetID() ~= 0 then
		
		if m_UIType == UI_TYPE_ATTR then
			local itemID = PlayerPackage:GetItemTableIndex(itemIdx)
			if itemID < INDEX_ATTRBOOK_BEGIN or itemID > INDEX_ATTRBOOK_END then
				PushDebugMessage("#{WH_090729_20}")  --此处只能放入武魂属性书。
				return
			end

			if PlayerPackage:IsLock( itemIdx ) == 1 then
				PushDebugMessage("#{WH_090729_07}")	--道具上锁。
				return
			end
	
		elseif m_UIType == UI_TYPE_COMPOUND then
			if LifeAbility : Get_Equip_Point(itemIdx) ~= 18 then
				PushDebugMessage("#{WH_090729_13}")	--此处只能放入武魂。
				return
			end
			
			if PlayerPackage:IsLock( itemIdx ) == 1 then
				PushDebugMessage("#{WH_090729_15}")	--被上锁的武魂不能作材料武魂。
				return
			end

			
			local gem_count = LifeAbility : GetEquip_GemCount( itemIdx )
			if gem_count ~= nil and gem_count > 0 then
				PushDebugMessage("#{WH_20090904_01}")	--WH_20090904_01 镶嵌有宝石的武魂不能作为合成材料！
				return
			end
			
		elseif m_UIType == UI_TYPE_LIFE then
			local itemID = PlayerPackage:GetItemTableIndex(itemIdx)
			if itemID ~=  INDEX_ADDLIFE then
				PushDebugMessage("#{WH_090729_36}") --此处只能放入武魂延寿丹。
				return
			end

			if PlayerPackage:IsLock( itemIdx ) == 1 then
				PushDebugMessage("#{WH_090729_07}")	--道具已上锁
				return
			end
		elseif m_UIType == UI_TYPE_SLOT then
			return
		end  

		if m_Equip_Item ~= -1 then
			LifeAbility : Lock_Packet_Item(m_Equip_Item,0);
		end
		WuhunMagicUp_Object2:SetActionItem(theAction:GetID());
		LifeAbility : Lock_Packet_Item(itemIdx,1);
		m_Equip_Item = itemIdx
	else
		WuhunMagicUp_Object2:SetActionItem(-1);			
		LifeAbility : Lock_Packet_Item(m_Equip_Item,0);		
		m_Equip_Item = -1;
	end

	WuhunMagicUp_UICheck()
end

--Care Obj
function WuhunMagicUp_BeginCareObj(obj_id)
	
	m_ObjCared = DataPool : GetNPCIDByServerID(obj_id);
	this:CareObject(m_ObjCared, 1);
end

--add by kaibin for tt86633 2010-12-9
--点击增加扩展属性cooldown时间检查
function AddExtAttr_PassTime()
   local iCur = Exchange:GetTickCount();

	if g_LastTimer == -1 then
		g_LastTimer = iCur;
		return 1
	end

   if ( iCur - g_LastTimer < MIN_PASS_TIME * 1000) then
      return 0
   else
      g_LastTimer = iCur;
   	  return 1
   end
end

--OnOK
function WuhunMagicUp_Life_OK_Clicked()
	if m_UIType ~= UI_TYPE_LIFE then
		return
	end

	-- 是否放入武魂
	if m_Equip_Idx == -1 then
		PushDebugMessage("#{WHYH_161121_87}")
		return
	end
	if LifeAbility : Get_Equip_Point(m_Equip_Idx) ~= 18  then
		PushDebugMessage("#{WHYH_161121_87}")
		return
	end
		
	-- 玩家身上的金钱是否足够
	local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")	
	if selfMoney < needMoney then
		PushDebugMessage("#{WHYH_161121_88}")  --对不起，你身上金钱不足，无法继续进行。
		return
	end

	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("AddKfsLife");
		Set_XSCRIPT_ScriptID(900004);
		Set_XSCRIPT_Parameter(0,m_Equip_Idx);
		Set_XSCRIPT_Parameter(1,m_Equip_Item);
		Set_XSCRIPT_Parameter(2,g_YBCheck);
		Set_XSCRIPT_ParamCount(3);
	Send_XSCRIPT();	
	
	-- 关闭界面
	-- this:Hide();
end

--OnOK
function WuhunMagicUp_OK_Clicked()
	-- 延寿特殊处理
	if m_UIType == UI_TYPE_LIFE then
		WuhunMagicUp_Life_OK_Clicked()
		return
	end
	
	if m_Equip_Idx == -1 or m_Equip_Item == -1 then
		return
	end
	
	local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")
	
	if selfMoney < needMoney then
		PushDebugMessage("#{WH_090729_18}")  --对不起，你身上金钱不足，无法继续进行。
		return
	end
	

	if m_UIType == UI_TYPE_ATTR then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("KfsAttrExStudy");
			Set_XSCRIPT_ScriptID(900004);
			Set_XSCRIPT_Parameter(0,m_Equip_Idx);
			Set_XSCRIPT_Parameter(1,m_Equip_Item);
			Set_XSCRIPT_ParamCount(2);
		Send_XSCRIPT();	
		WuhunMagicUp_Object1:SetActionItem(-1);	
		WuhunMagicUp_Object2:SetActionItem(-1);
		LifeAbility : Lock_Packet_Item(m_Equip_Idx,0);
		LifeAbility : Lock_Packet_Item(m_Equip_Item,0);
		m_Equip_Item = -1
		m_Equip_Idx = -1

	elseif m_UIType == UI_TYPE_COMPOUND then
		
		-- if needConfirm == 1 then
			-- GameProduceLogin:GameLoginShowSystemInfo("#{WH_090825_01}")  --由于材料武魂是绑定的，合成后的武魂也将与您绑定
			-- needConfirm = 0
			-- return
		-- end
		
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("KfsCompoud");
			Set_XSCRIPT_ScriptID(900004);
			Set_XSCRIPT_Parameter(0,m_Equip_Idx);
			Set_XSCRIPT_Parameter(1,m_Equip_Item);
			Set_XSCRIPT_ParamCount(2);
		Send_XSCRIPT();	
		
		WuhunMagicUp_Object1:SetActionItem(-1);	
		WuhunMagicUp_Object2:SetActionItem(-1);
		LifeAbility : Lock_Packet_Item(m_Equip_Idx,0);
		LifeAbility : Lock_Packet_Item(m_Equip_Item,0);
		m_Equip_Item = -1
		m_Equip_Idx = -1
	end
end

--Right button clicked
function WuhunMagicUp_Resume_Equip()

	WuhunMagicUp_Update(-1)

end

--Right button clicked
function WuhunMagicUp_Resume_Item()
	
	WuhunMagicUp_Update_Sub(-1)

end

--handle Hide Event
function WuhunMagicUp_OnHiden()

	WuhunMagicUp_Update(-1)
	WuhunMagicUp_Update_Sub(-1)

end

function WuhunMagicUp_UICheck()
	WuhunMagicUp_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"));
	WuhunMagicUp_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ")); 
	WuhunMagicUp_DemandMoney : SetProperty("MoneyNumber", 0)
	WuhunMagicUp_OK:Disable()
	needConfirm = 1

	if m_Equip_Idx ~= -1 then
	
		if m_UIType == UI_TYPE_ATTR then
			needMoney = 80000
		
		elseif m_UIType == UI_TYPE_COMPOUND then
			local _,comLevel = LuaGetKfsAttrData(g_EquipData_1)
			if comLevel ~= nil and comLevel > 0 and comLevel < 10 then
				needMoney = m_Money_COMPOUND[comLevel]
			end

		elseif m_UIType == UI_TYPE_LIFE then
			needMoney = 50000
		end
		WuhunMagicUp_DemandMoney : SetProperty("MoneyNumber", needMoney)
	end
	
	if m_Equip_Idx ~= -1 and ( m_UIType == UI_TYPE_LIFE or m_Equip_Item ~= -1 )then
		WuhunMagicUp_OK:Enable()
	end
end

function WuhunMagicUp_Queren_Clicked()
	local bCheck = WuhunMagicUp_Blank_Queren:GetCheck();
	if ( bCheck == 1 ) then
		g_YBCheck = 1
		WuhunMagicUp_Blank_Queren:SetCheck( 1 )
	elseif ( bCheck == 0 ) then
		g_YBCheck = 0
		WuhunMagicUp_Blank_Queren:SetCheck( 0 )
	end
end

--Help
function WuhunMagicUp_Help_Clicked()
	if m_UIType == UI_TYPE_ATTR then
		Helper:GotoHelper("*WuhunExtraPropertyUp")
	elseif m_UIType == UI_TYPE_COMPOUND then
		Helper:GotoHelper("*WuhunMagicUp")
	elseif m_UIType == UI_TYPE_LIFE then
		Helper:GotoHelper("*Wuhun")
	elseif m_UIType == UI_TYPE_SLOT then
		Helper:GotoHelper("*WuhunExtraPropertyUp")
	end	

end
