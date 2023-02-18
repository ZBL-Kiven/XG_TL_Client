local m_UI_NUM = 20090726
local m_ObjCared = -1
local m_Equip_Idx = -1
local m_Equip_Item = -1
local g_ItemItm   = -1;
local UI_TYPE_ATTR	= 1
local UI_TYPE_COMPOUND	= 2
local UI_TYPE_LIFE	= 3
local UI_TYPE_SLOT	= 4
local UI_TYPE_ATTRNew = 5
local m_UIType = 0

local m_Money_COMPOUND = {}

local INDEX_ATTRBOOK_BEGIN	= 30700214	--御·折冰属性书
local INDEX_ATTRBOOK_END	= 30700229	--暴·拔毒属性书

local INDEX_ADDLIFE = 30700233 --延寿丹

local INDEX_SLOT_ITEM1 = 30121003 --麟木剑
local INDEX_SLOT_ITEM2 = 30700238 --破天剑

local needMoney = 0

local needConfirm = 1

local g_LastTimer = -1 --增加点击扩展武魂属性的冷却时间
local MIN_PASS_TIME = 1 --冷却时间1秒

--PreLoad
function WuhunMagicUpLYU_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("MONEYJZ_CHANGE");
	this:RegisterEvent("PACKAGE_ITEM_CHANGED");
end

--OnLoad
function WuhunMagicUpLYU_OnLoad()
	--武魂合成消耗Money
	m_Money_COMPOUND[1] = 10000
	m_Money_COMPOUND[2] = 10000
	m_Money_COMPOUND[3] = 15000
	m_Money_COMPOUND[4] = 15000
	m_Money_COMPOUND[5] = 20000
	m_Money_COMPOUND[6] = 20000
	m_Money_COMPOUND[7] = 25000
	m_Money_COMPOUND[8] = 25000
	m_Money_COMPOUND[9] = 30000


end

--OnEvent
function WuhunMagicUpLYU_OnEvent(event)

	if (event == "UI_COMMAND" and tonumber(arg0) == m_UI_NUM) then
		
		WuhunMagicUpLYU_BeginCareObj( Get_XParam_INT(0) );
		m_UIType = Get_XParam_INT(1)
		
		if m_UIType == UI_TYPE_ATTR then
			WuhunMagicUpLYU_Title:SetText("神器通灵")	--
			WuhunMagicUpLYU_Info:SetText("#Y仅有炼魂后，并且还未进行通灵的106级神器才可进行此操作，通灵需要#G聚灵石#Y一颗，通灵成功后，神器的携带等级保持106不变，外观将变成更加炫丽的4代神器造型。#r#G(通灵后的神器可以进行契合，属性也会大大提升)")
			WuhunMagicUpLYU_Info2:SetText("#H请放入需要进行通灵的神器:")
			WuhunMagicUpLYU_Info3:SetText("请放入聚灵石:")
		
		elseif m_UIType == UI_TYPE_COMPOUND then
			WuhunMagicUpLYU_Title:SetText("#{WH_xml_XX(18)}")	--合成
			WuhunMagicUpLYU_Info:SetText("#{WH_xml_XX(19)}")
			WuhunMagicUpLYU_Info2:SetText("#{WH_xml_XX(20)}")
			WuhunMagicUpLYU_Info3:SetText("#{WH_xml_XX(21)}")
		
		elseif m_UIType == UI_TYPE_LIFE then
			WuhunMagicUpLYU_Title:SetText("龙纹合成")	-- 
			WuhunMagicUpLYU_Info:SetText("#cffcc00#G2#cffcc00个#cFF0000成长等级#cffcc00相同的龙纹可以合成#G1#cffcc00个高于自身等级的龙纹，合成后属性得到扩展")
			WuhunMagicUpLYU_Info2:SetText("请放入需要合成的龙纹:")
			WuhunMagicUpLYU_Info3:SetText("请放入需要合成的龙纹:")
		
		elseif m_UIType == UI_TYPE_SLOT then
			WuhunMagicUpLYU_Title:SetText("#{WH_xml_XX(84)}")	--开辟属性栏
			WuhunMagicUpLYU_Info:SetText("#{WH_xml_XX(85)}")
			WuhunMagicUpLYU_Info2:SetText("#{WH_xml_XX(86)}")
			WuhunMagicUpLYU_Info3:SetText("#{WH_xml_XX(87)}")
		elseif m_UIType == UI_TYPE_ATTRNew then
			WuhunMagicUpLYU_Title:SetText("#{WH_xml_XX(22)}")	--扩展属性学习
			WuhunMagicUpLYU_Info:SetText("#{WH_xml_XX(23)}")
			WuhunMagicUpLYU_Info2:SetText("#{WH_xml_XX(24)}")
			WuhunMagicUpLYU_Info3:SetText("#{WH_xml_XX(25)}")	
		end		

		WuhunMagicUpLYU_Update(-1)
		WuhunMagicUpLYU_Update_Sub(-1)
		this:Show();
		 elseif (event == "UI_COMMAND" and tonumber(arg0) == 201107281 and this:IsVisible()) then
				if m_Equip_Idx ~= -1 then
					 WuhunMagicUpLYU_Update_Sub( tonumber(arg1) )
				          else 
					 WuhunMagicUpLYU_Update( tonumber(arg1) )
			             end
		
	
	elseif (event == "UNIT_MONEY" and this:IsVisible()) then
		WuhunMagicUpLYU_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
	
	elseif (event == "MONEYJZ_CHANGE" and this:IsVisible()) then 
		WuhunMagicUpLYU_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
	
	elseif (event == "PACKAGE_ITEM_CHANGED" and this:IsVisible()) then
		if arg0 ~= nil and tonumber(arg0) ~= -1 and tonumber(arg0) == m_Equip_Idx and -1 ~= m_Equip_Idx then
			WuhunMagicUpLYU_Update(m_Equip_Idx)
			
			--【修改人：陈永帅】
			--【TT：78726】
			--虚幻  再次修改

		end
		
	end
end

--Update UI
function WuhunMagicUpLYU_Update(itemIdx)
	local theAction = EnumAction(itemIdx, "packageitem");
	if theAction:GetID() ~= 0 then
		local myequi = PlayerPackage:GetItemTableIndex(itemIdx)
	    if 20000000 <= myequi then
		PushDebugMessage( "只有装备才可以进行这个操作！！" )
		return
		end	
		if m_UIType == UI_TYPE_COMPOUND then
	        local EquipPoint = LifeAbility : Get_Equip_Point(itemIdx)	
         	 if (EquipPoint ~= 18) then
                 WuhunMagicUpLYU_Resume_Item()
		 PushDebugMessage( "请放入主武魂" )
		 return
		 end
        if PlayerPackage:IsLock( itemIdx ) == 1 then
		PushDebugMessage("主[武魂] 已上锁")	--道具上锁。
		return
		end
		
		elseif m_UIType == UI_TYPE_SLOT then
		local EquipPoint = LifeAbility : Get_Equip_Point(itemIdx)	
        if (EquipPoint ~= 18) then
                 WuhunMagicUpLYU_Resume_Item()
		 PushDebugMessage( "请放入要开辟扩展属性栏的武魂" )
		 return
		 end
        if PlayerPackage:IsLock( itemIdx ) == 1 then
		PushDebugMessage("[武魂] 已上锁")	--道具上锁。
		return
		end
		elseif m_UIType == UI_TYPE_ATTRNew then
			        local EquipPoint = LifeAbility : Get_Equip_Point(itemIdx)	
         	 if (EquipPoint ~= 18) then
                 WuhunMagicUpLYU_Resume_Item()
		 PushDebugMessage( "请放入要学习扩展属性的武魂" )
		 return
		 end
                if PlayerPackage:IsLock( itemIdx ) == 1 then
		PushDebugMessage("[武魂] 已上锁")	--道具上锁。
		return
		end

        elseif m_UIType == UI_TYPE_ATTR then 
	         local EquipPoint = LifeAbility : Get_Equip_Point(itemIdx)	
         	 if (EquipPoint ~= 0) then
                 WuhunMagicUpLYU_Resume_Item()
		 PushDebugMessage( "请放入要通灵的神器" )
		 return
		 end
		local itemID = PlayerPackage:GetItemTableIndex(itemIdx)
           if ( itemID > 10558591 or itemID < 10558559 )  then
		PushDebugMessage("此处只能放入106级未通灵过的神器")  
			return
		end		
                if PlayerPackage:IsLock( itemIdx ) == 1 then
		PushDebugMessage("[神器] 已上锁")	--道具上锁。
		return
		end		

		elseif m_UIType == UI_TYPE_LIFE then
                 local EquipPoint = LifeAbility : Get_Equip_Point(itemIdx)
         	 if (EquipPoint ~= 18) then
                      WuhunMagicUpLYU_Resume_Item()
		       PushDebugMessage( "请放入主龙纹" )
		       return
		       end

			if PlayerPackage:IsLock( itemIdx ) == 1 then
				PushDebugMessage("[龙纹] 已上锁")	--道具已上锁
				return
			end
		local itemID = PlayerPackage:GetItemTableIndex(itemIdx)
                if ( itemID < 10170001 or itemID > 10170900 ) then
		PushDebugMessage("此处只能放入龙纹")  
			return
		end
                
                  end
		if m_Equip_Idx ~= -1 then
		WuhunMagicUpLYU_Object1:SetActionItem(-1);			
		LifeAbility : Lock_Packet_Item(m_Equip_Idx,0);		
		m_Equip_Idx = -1;
		end
		
		WuhunMagicUpLYU_Object1:SetActionItem(theAction:GetID());
		LifeAbility : Lock_Packet_Item(itemIdx,1);
		m_Equip_Idx = itemIdx
		
	else
	
		WuhunMagicUpLYU_Object1:SetActionItem(-1);			
		LifeAbility : Lock_Packet_Item(m_Equip_Idx,0);		
		m_Equip_Idx = -1;
	end
	WuhunMagicUpLYU_UICheck();

end

function WuhunMagicUpLYU_Update_Sub(itemIdx)
	local theAction = EnumAction(itemIdx, "packageitem");
	if theAction:GetID() ~= 0 then
		
		if m_UIType == UI_TYPE_ATTR then
			  local itemID = PlayerPackage:GetItemTableIndex(itemIdx)
			  if itemID ~= 30505818 then
			  	PushDebugMessage("此处只能放入 [#{_ITEM30505818}]")  
			 	return
			  end

			if PlayerPackage:IsLock( itemIdx ) == 1 then
				PushDebugMessage("[#{_ITEM30505818}] 已上锁")	--道具上锁。
				return
			end
	    elseif m_UIType == UI_TYPE_ATTRNew then
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

        local EquipPoint = LifeAbility : Get_Equip_Point(itemIdx)
         	 if (EquipPoint ~= 18) then
                 WuhunMagicUpLYU_Resume_Item()
		 PushDebugMessage( "请放入参与合成的武魂" )
		 return
		 end			
		if PlayerPackage:IsLock( itemIdx ) == 1 then
		PushDebugMessage("参与合成的[武魂] 已上锁")	--道具上锁。
		return
		end
		local gem_count = LifeAbility : GetEquip_GemCount( itemIdx )
		if gem_count ~= nil and gem_count > 0 then
		PushDebugMessage("镶嵌有宝石的[武魂]不能参与合成！")	
			return
		 end

	
		elseif m_UIType == UI_TYPE_LIFE then
                 local EquipPoint = LifeAbility : Get_Equip_Point(itemIdx)
         	 if (EquipPoint ~= 18) then
                      WuhunMagicUpLYU_Resume_Item()
		       PushDebugMessage( "请放入参与合成的龙纹" )
		       return
		       end

			if PlayerPackage:IsLock( itemIdx ) == 1 then
				PushDebugMessage("参与合成的[龙纹] 已上锁")	--道具已上锁
				return
			end
		local itemID = PlayerPackage:GetItemTableIndex(itemIdx)
                if ( itemID < 10170001 or itemID > 10170900 ) then
		PushDebugMessage("此处只能放入龙纹")  
			return
		end
		local gem_count = LifeAbility : GetEquip_GemCount( itemIdx )
		if gem_count ~= nil and gem_count > 0 then
		PushDebugMessage("镶嵌有宝石的[龙纹]不能参与合成！")	
			return
		 end
		elseif m_UIType == UI_TYPE_SLOT then
			local itemID = PlayerPackage:GetItemTableIndex(itemIdx)
			if itemID ~=  INDEX_SLOT_ITEM1 and itemID ~= INDEX_SLOT_ITEM2 then
				PushDebugMessage("#{WH_090729_51}") --此处只能放入麟木箭、破天剑
				return
			end

			if PlayerPackage:IsLock( itemIdx ) == 1 then
				PushDebugMessage("#{WH_090729_52}")	--道具已上锁
				return
			end
		end  

		if m_Equip_Item ~= -1 then
		WuhunMagicUpLYU_Object2:SetActionItem(-1);			
		LifeAbility : Lock_Packet_Item(m_Equip_Item,0);		
		m_Equip_Item = -1;
		end

		WuhunMagicUpLYU_Object2:SetActionItem(theAction:GetID());
		LifeAbility : Lock_Packet_Item(itemIdx,1);
		m_Equip_Item = itemIdx

	else
		WuhunMagicUpLYU_Object2:SetActionItem(-1);			
		LifeAbility : Lock_Packet_Item(m_Equip_Item,0);		
		m_Equip_Item = -1;
	end

	WuhunMagicUpLYU_UICheck()
end

--Care Obj
function WuhunMagicUpLYU_BeginCareObj(obj_id)
	
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
function WuhunMagicUpLYU_OK_Clicked()
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
	        Set_XSCRIPT_Function_Name("WuhunMagicUpLYU")
	        Set_XSCRIPT_ScriptID(892108)
	        Set_XSCRIPT_Parameter(0,m_Equip_Idx)
	        Set_XSCRIPT_Parameter(1,m_Equip_Item)
	        Set_XSCRIPT_ParamCount(2)
	        Send_XSCRIPT();
	elseif m_UIType == UI_TYPE_ATTRNew then
		Clear_XSCRIPT();
	        Set_XSCRIPT_Function_Name("WuhunMagicUpLYU")
	        Set_XSCRIPT_ScriptID(892101)
	        Set_XSCRIPT_Parameter(0,m_Equip_Idx)
	        Set_XSCRIPT_Parameter(1,m_Equip_Item)
			Set_XSCRIPT_Parameter(2,-998)
	        Set_XSCRIPT_ParamCount(3)
	        Send_XSCRIPT();		
	elseif m_UIType == UI_TYPE_COMPOUND then  --合成
		Clear_XSCRIPT();
	        Set_XSCRIPT_Function_Name("WuhunMagicUpLYU")
	        Set_XSCRIPT_ScriptID(892101)
	        Set_XSCRIPT_Parameter(0,m_Equip_Idx)
	        Set_XSCRIPT_Parameter(1,m_Equip_Item)
			Set_XSCRIPT_Parameter(2,11)
	        Set_XSCRIPT_ParamCount(3)
	        Send_XSCRIPT();
	elseif m_UIType == UI_TYPE_LIFE then
		Clear_XSCRIPT();
	        Set_XSCRIPT_Function_Name("LongWenMagicUp")
	        Set_XSCRIPT_ScriptID(892003)
	        Set_XSCRIPT_Parameter(0,m_Equip_Idx)
	        Set_XSCRIPT_Parameter(1,m_Equip_Item)
	        Set_XSCRIPT_ParamCount(2)
	        Send_XSCRIPT();
	elseif m_UIType == UI_TYPE_SLOT then
		--add by kaibin 增加点击增加武魂扩展属性冷却时间判断
		if AddExtAttr_PassTime() == 0 then
			return
		end
		Clear_XSCRIPT();
	        Set_XSCRIPT_Function_Name("WuhunMagicUpLYU")
	        Set_XSCRIPT_ScriptID(892101)
	        Set_XSCRIPT_Parameter(0,m_Equip_Idx)
	        Set_XSCRIPT_Parameter(1,m_Equip_Item)
			Set_XSCRIPT_Parameter(2,-999)
	        Set_XSCRIPT_ParamCount(3)
	        Send_XSCRIPT();	
	end
	WuhunMagicUpLYU_Resume_Item()	
end

--Right button clicked
function WuhunMagicUpLYU_Resume_Equip()

	WuhunMagicUpLYU_Update(-1)

end

--Right button clicked
function WuhunMagicUpLYU_Resume_Item()
	
	WuhunMagicUpLYU_Update_Sub(-1)

end

--handle Hide Event
function WuhunMagicUpLYU_OnHiden()

	WuhunMagicUpLYU_Update(-1)
	WuhunMagicUpLYU_Update_Sub(-1)

end

function WuhunMagicUpLYU_UICheck()
	WuhunMagicUpLYU_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"));
	WuhunMagicUpLYU_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ")); 
	WuhunMagicUpLYU_DemandMoney : SetProperty("MoneyNumber", 0)
	WuhunMagicUpLYU_OK:Disable()
	needConfirm = 1
	if m_Equip_Idx ~= -1 then
		if m_UIType == UI_TYPE_ATTR then
			needMoney = 800000
		elseif m_UIType == UI_TYPE_ATTRNew then
		    needMoney = 50000
		elseif m_UIType == UI_TYPE_COMPOUND then
			needMoney = 800000
		elseif m_UIType == UI_TYPE_LIFE then
			needMoney = 500000
		elseif m_UIType == UI_TYPE_SLOT then
			needMoney = 800000
		end
		WuhunMagicUpLYU_DemandMoney : SetProperty("MoneyNumber", needMoney)
	end
	
	if m_Equip_Idx ~= -1 and m_Equip_Item ~= -1 then
		WuhunMagicUpLYU_OK:Enable()
	end
end


--Help
function WuhunMagicUpLYU_Help_Clicked()

end