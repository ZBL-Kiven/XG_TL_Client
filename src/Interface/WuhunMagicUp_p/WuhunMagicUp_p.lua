local m_UI_NUM = 20090721
local m_ObjCared = -1
local m_Equip_Idx = -1
local m_Equip_Item = -1
local g_ItemItm   = -1;
local UI_TYPE_ATTR	= 1
local UI_TYPE_COMPOUND	= 2
local UI_TYPE_LIFE	= 3
local UI_TYPE_SLOT	= 4
local UI_TYPE_ATTRNew = 5
local UI_TYPE_HCLV = 6
local UI_TYPE_XIEZI = 7
local UI_TYPE_SLZY = 8 --升灵转移
local m_UIType = 0

local m_Money_COMPOUND = {}

local INDEX_ATTRBOOK_BEGIN	= 30700214	--御·折冰属性书
local INDEX_ATTRBOOK_END	= 30700229	--暴·拔毒属性书

local INDEX_ADDLIFE = 30700233 --延寿丹

local INDEX_SLOT_ITEM1 = 20310158 --麟木剑
local INDEX_SLOT_ITEM2 = 20310159 --破天剑

local needMoney = 0

local needConfirm = 1

local g_LastTimer = -1 --增加点击扩展武魂属性的冷却时间
local MIN_PASS_TIME = 1 --冷却时间1秒

--PreLoad
function WuhunMagicUp_p_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("MONEYJZ_CHANGE");
	this:RegisterEvent("PACKAGE_ITEM_CHANGED");
end

--OnLoad
function WuhunMagicUp_p_OnLoad()
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
function WuhunMagicUp_p_OnEvent(event)

	if (event == "UI_COMMAND" and tonumber(arg0) == m_UI_NUM) then
		WuhunMagicUp_p_OnHiden()
		WuhunMagicUp_p_BeginCareObj( Get_XParam_INT(0) );
		m_UIType = Get_XParam_INT(1)
		
		if m_UIType == UI_TYPE_ATTR then
			WuhunMagicUp_p_Title:SetText("神器通灵")	--
			WuhunMagicUp_p_Info:SetText("#Y仅有炼魂后，并且还未进行通灵的106级神器才可进行此操作，通灵需要#G聚灵石#Y一颗，通灵成功后，神器的携带等级保持106不变，外观将变成更加炫丽的4代神器造型。#r#G(通灵后的神器可以进行契合，属性也会大大提升)")
			WuhunMagicUp_p_Info2:SetText("#H请放入需要进行通灵的神器:")
			WuhunMagicUp_p_Info3:SetText("请放入聚灵石:")
		
		elseif m_UIType == UI_TYPE_COMPOUND then
			WuhunMagicUp_p_Title:SetText("#{WH_xml_XX(18)}")	--合成
			WuhunMagicUp_p_Info:SetText("#{WH_xml_XX(19)}")
			WuhunMagicUp_p_Info2:SetText("#{WH_xml_XX(20)}")
			WuhunMagicUp_p_Info3:SetText("#{WH_xml_XX(21)}")

		elseif m_UIType == UI_TYPE_HCLV then
			WuhunMagicUp_p_Title:SetText("#gFF0FA0宝石转移")	--合成
			WuhunMagicUp_p_Info:SetText("#G需要相同类型的装备才可以进行宝石转换,转换后原来的装备消失,原来装备的宝石将会转移的新装备上面#r#cFF0000切记原来的装备会消失")
			WuhunMagicUp_p_Info2:SetText("#H需要转移的装备:")
			WuhunMagicUp_p_Info3:SetText("#cfff263转换到的装备:")
	
	        elseif m_UIType == UI_TYPE_XIEZI then
			WuhunMagicUp_p_Title:SetText("#{SLDZ_100805_103}")	--合成
			WuhunMagicUp_p_Info:SetText("#{SLDZ_100805_104}")
			WuhunMagicUp_p_Info2:SetText("#cfff263请放入提升星级的六博:")
			WuhunMagicUp_p_Info3:SetText("#cfff263请放入作为材料的六博:")	

		elseif m_UIType == UI_TYPE_LIFE then
			WuhunMagicUp_p_Title:SetText("#gFF0FA0龙纹属性重洗")	-- 
			WuhunMagicUp_p_Info:SetText("#Y龙纹#G重洗属性#W需要消耗一定数量的#Y净云水#W,#G不同成长等级#W的#Y龙纹#G重洗#W属性后，可能出现的#G属性条数不同#W#r重洗龙纹的属性后，龙纹的#G强化#W、#G刻铭#W、#G镶嵌#W、#G资质#W、#G雕纹#W都#G不会受到任何的影响#W。")
			WuhunMagicUp_p_Info2:SetText("需要重洗的龙纹:")
			WuhunMagicUp_p_Info3:SetText("#Y净云水:")
		
		elseif m_UIType == UI_TYPE_SLOT then
			WuhunMagicUp_p_Title:SetText("#{WH_xml_XX(84)}")	--开辟属性栏
			WuhunMagicUp_p_Info:SetText("#{WH_xml_XX(85)}")
			WuhunMagicUp_p_Info2:SetText("#{WH_xml_XX(86)}")
			WuhunMagicUp_p_Info3:SetText("#{WH_xml_XX(87)}")

		elseif m_UIType == UI_TYPE_ATTRNew then
			WuhunMagicUp_p_Title:SetText("#{WH_xml_XX(22)}")	--扩展属性学习
			WuhunMagicUp_p_Info:SetText("#{WH_xml_XX(23)}")
			WuhunMagicUp_p_Info2:SetText("#{WH_xml_XX(24)}")
			WuhunMagicUp_p_Info3:SetText("#{WH_xml_XX(25)}")

	        elseif m_UIType == UI_TYPE_SLZY then
			WuhunMagicUp_p_Title:SetText("#gFF0FA0升灵等级转移")	--升灵转移
			WuhunMagicUp_p_Info:SetText("#{ZZZB_150811_304}")
			WuhunMagicUp_p_Info2:SetText("#{ZZZB_150811_305}")
			WuhunMagicUp_p_Info3:SetText("#{ZZZB_150811_306}")
		end		

		WuhunMagicUp_p_Update(-1)
		WuhunMagicUp_p_Update_Sub(-1)
		this:Show();
		 elseif (event == "UI_COMMAND" and tonumber(arg0) == 201107281 and this:IsVisible()) then
				if m_Equip_Idx ~= -1 then
					 WuhunMagicUp_p_Update_Sub( tonumber(arg1) )
				          else 
					 WuhunMagicUp_p_Update( tonumber(arg1) )
			             end
		
	
	elseif (event == "UNIT_MONEY" and this:IsVisible()) then
		WuhunMagicUp_p_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
	
	elseif (event == "MONEYJZ_CHANGE" and this:IsVisible()) then 
		WuhunMagicUp_p_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
	
	elseif (event == "PACKAGE_ITEM_CHANGED" and this:IsVisible()) then
		if arg0 ~= nil and tonumber(arg0) ~= -1 and tonumber(arg0) == m_Equip_Idx and -1 ~= m_Equip_Idx then
			WuhunMagicUp_p_Update(m_Equip_Idx)
			
			--【修改人：陈永帅】
			--【TT：78726】
			--虚幻  再次修改

		end
		
	end
end

--Update UI
function WuhunMagicUp_p_Update(itemIdx)
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
                 WuhunMagicUp_p_Resume_Item()
		 PushDebugMessage( "请放入主武魂" )
		 return
		 end
        if PlayerPackage:IsLock( itemIdx ) == 1 then
		PushDebugMessage("主[武魂] 已上锁")	--道具上锁。
		return
		end
		elseif (m_UIType == UI_TYPE_HCLV) or (m_UIType == UI_TYPE_XIEZI) or (m_UIType == UI_TYPE_SLZY) then
		local itemID = PlayerPackage:GetItemTableIndex(itemIdx)
		    if ( itemID < 10000001 or itemID > 20000000 ) then
		PushDebugMessage("此处只能放入装备")  
			return
		end
		elseif m_UIType == UI_TYPE_SLOT then
		local EquipPoint = LifeAbility : Get_Equip_Point(itemIdx)	
        if (EquipPoint ~= 18) then
                 WuhunMagicUp_p_Resume_Item()
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
                 WuhunMagicUp_p_Resume_Item()
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
                 WuhunMagicUp_p_Resume_Item()
		 PushDebugMessage( "请放入要通灵的神器" )
		 return
		 end
		local itemID = PlayerPackage:GetItemTableIndex(itemIdx)
           if ( itemID > 10558591 or itemID < 10558559 )  then
		PushDebugMessage("此处只能放入106级炼魂过的神器")  
			return
		end		
                if PlayerPackage:IsLock( itemIdx ) == 1 then
		PushDebugMessage("[神器] 已上锁")	--道具上锁。
		return
		end		

		elseif m_UIType == UI_TYPE_LIFE then

			if PlayerPackage:IsLock( itemIdx ) == 1 then
				PushDebugMessage("[龙纹] 已上锁")	--道具已上锁
				return
			end
		local itemID = PlayerPackage:GetItemTableIndex(itemIdx)
                if ( itemID < 10157001 or itemID >10157100 ) then
		PushDebugMessage("此处只能放入龙纹")  
			return
		end
                
                  end
		if m_Equip_Idx ~= -1 then
		WuhunMagicUp_p_Object1:SetActionItem(-1);			
		LifeAbility : Lock_Packet_Item(m_Equip_Idx,0);		
		m_Equip_Idx = -1;
		end
		
		WuhunMagicUp_p_Object1:SetActionItem(theAction:GetID());
		LifeAbility : Lock_Packet_Item(itemIdx,1);
		m_Equip_Idx = itemIdx
		
	else
	
		WuhunMagicUp_p_Object1:SetActionItem(-1);			
		LifeAbility : Lock_Packet_Item(m_Equip_Idx,0);		
		m_Equip_Idx = -1;
	end
	WuhunMagicUp_p_UICheck();

end

function WuhunMagicUp_p_Update_Sub(itemIdx)
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
                 WuhunMagicUp_p_Resume_Item()
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
			
			local gem_count = LifeAbility : GetEquip_GemCount( itemIdx )
			if gem_count ~= nil and gem_count > 0 then
				PushDebugMessage("#{WH_20090904_01}")	--WH_20090904_01 镶嵌有宝石的武魂不能作为合成材料！
				return
			end
			
	    elseif (m_UIType == UI_TYPE_HCLV) or (m_UIType == UI_TYPE_XIEZI) or (m_UIType == UI_TYPE_SLZY) then
		local itemID = PlayerPackage:GetItemTableIndex(itemIdx)
        if ( itemID < 10000001 or itemID > 20000000 ) then
		PushDebugMessage("此处只能放入装备")  
			return
		end
		
		elseif m_UIType == UI_TYPE_LIFE then
			if PlayerPackage:IsLock( itemIdx ) == 1 then
				PushDebugMessage("参与合成的[龙纹] 已上锁")	--道具已上锁
				return
			end
		local itemID = PlayerPackage:GetItemTableIndex(itemIdx)
                if ( itemID ~= 20310180  ) then
		PushDebugMessage("净云水")  
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
		WuhunMagicUp_p_Object2:SetActionItem(-1);			
		LifeAbility : Lock_Packet_Item(m_Equip_Item,0);		
		m_Equip_Item = -1;
		end

		WuhunMagicUp_p_Object2:SetActionItem(theAction:GetID());
		LifeAbility : Lock_Packet_Item(itemIdx,1);
		m_Equip_Item = itemIdx

	else
		WuhunMagicUp_p_Object2:SetActionItem(-1);			
		LifeAbility : Lock_Packet_Item(m_Equip_Item,0);		
		m_Equip_Item = -1;
	end

	WuhunMagicUp_p_UICheck()
end

--Care Obj
function WuhunMagicUp_p_BeginCareObj(obj_id)
	
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
function WuhunMagicUp_p_OK_Clicked()
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
	        Set_XSCRIPT_Function_Name("GetWh_XinXT")
	        Set_XSCRIPT_ScriptID(892108)
	        Set_XSCRIPT_Parameter(0,m_Equip_Idx)
	        Set_XSCRIPT_Parameter(1,m_Equip_Item)
	        Set_XSCRIPT_ParamCount(2)
	        Send_XSCRIPT();
	elseif m_UIType == UI_TYPE_HCLV then
			Clear_XSCRIPT();
	        Set_XSCRIPT_Function_Name("WuhunMagicUp")  
	        Set_XSCRIPT_ScriptID(895111)
			Set_XSCRIPT_Parameter(0,27)
	        Set_XSCRIPT_Parameter(1,m_Equip_Idx)
	        Set_XSCRIPT_Parameter(2,m_Equip_Item)
	        Set_XSCRIPT_ParamCount(3)
	        Send_XSCRIPT();
			this:Hide()
	elseif m_UIType == UI_TYPE_XIEZI then
			Clear_XSCRIPT();
	        Set_XSCRIPT_Function_Name("WuhunMagicUp")  
	        Set_XSCRIPT_ScriptID(895111)
			Set_XSCRIPT_Parameter(0,31)
	        Set_XSCRIPT_Parameter(1,m_Equip_Idx)
	        Set_XSCRIPT_Parameter(2,m_Equip_Item)
	        Set_XSCRIPT_ParamCount(3)
	        Send_XSCRIPT();
			this:Hide()
	elseif m_UIType == UI_TYPE_SLZY then
			Clear_XSCRIPT();
	        Set_XSCRIPT_Function_Name("MsgBox32")  
	        Set_XSCRIPT_ScriptID(391060)
	        Set_XSCRIPT_Parameter(0,m_Equip_Idx)
		Set_XSCRIPT_Parameter(1,400)
	        Set_XSCRIPT_Parameter(2,m_Equip_Item)
	        Set_XSCRIPT_ParamCount(3)
	        Send_XSCRIPT();
			this:Hide()
	elseif m_UIType == UI_TYPE_ATTRNew then
		Clear_XSCRIPT();
	        Set_XSCRIPT_Function_Name("GetWh_XinXT")
	        Set_XSCRIPT_ScriptID(892101)
			Set_XSCRIPT_Parameter(0,13)
	        Set_XSCRIPT_Parameter(1,m_Equip_Idx)
	        Set_XSCRIPT_Parameter(2,m_Equip_Item)
	        Set_XSCRIPT_ParamCount(3)
	        Send_XSCRIPT();		
	elseif m_UIType == UI_TYPE_COMPOUND then  --合成1

		Clear_XSCRIPT();
	        Set_XSCRIPT_Function_Name("GetWh_XinXT")
	        Set_XSCRIPT_ScriptID(892101)
			Set_XSCRIPT_Parameter(0,10)
	        Set_XSCRIPT_Parameter(1,m_Equip_Idx)
	        Set_XSCRIPT_Parameter(2,m_Equip_Item)
	        Set_XSCRIPT_ParamCount(3)
	        Send_XSCRIPT();
	elseif m_UIType == UI_TYPE_LIFE then
		Clear_XSCRIPT();
	Set_XSCRIPT_Function_Name("ResetProperty")
	Set_XSCRIPT_ScriptID(892003)
	Set_XSCRIPT_Parameter(0,2)
	        Set_XSCRIPT_Parameter(1,m_Equip_Idx)
	        Set_XSCRIPT_Parameter(2,m_Equip_Item)
	        Set_XSCRIPT_ParamCount(3)
	        Send_XSCRIPT();
	elseif m_UIType == UI_TYPE_SLOT then
		--add by kaibin 增加点击增加武魂扩展属性冷却时间判断
		if AddExtAttr_PassTime() == 0 then
			return
		end
		Clear_XSCRIPT();
	        Set_XSCRIPT_Function_Name("GetWh_XinXT")
	        Set_XSCRIPT_ScriptID(892101)
			Set_XSCRIPT_Parameter(0,12)
	        Set_XSCRIPT_Parameter(1,m_Equip_Idx)
	        Set_XSCRIPT_Parameter(2,m_Equip_Item)
	        Set_XSCRIPT_ParamCount(3)
	        Send_XSCRIPT();	
	end
WuhunMagicUp_p_OnHiden()
end

--Right button clicked
function WuhunMagicUp_p_Resume_Equip()

	WuhunMagicUp_p_Update(-1)

end

--Right button clicked
function WuhunMagicUp_p_Resume_Item()
	
	WuhunMagicUp_p_Update_Sub(-1)

end

--handle Hide Event
function WuhunMagicUp_p_OnHiden()
	WuhunMagicUp_p_Object2:SetActionItem(-1);			
	LifeAbility : Lock_Packet_Item(m_Equip_Item,0);		
	m_Equip_Item = -1;
		WuhunMagicUp_p_Object1:SetActionItem(-1);			
		LifeAbility : Lock_Packet_Item(m_Equip_Idx,0);		
		m_Equip_Idx = -1;


	WuhunMagicUp_p_Update(-1)
	WuhunMagicUp_p_Update_Sub(-1)

end

function WuhunMagicUp_p_UICheck()
	WuhunMagicUp_p_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"));
	WuhunMagicUp_p_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ")); 
	WuhunMagicUp_p_DemandMoney : SetProperty("MoneyNumber", 0)
	WuhunMagicUp_p_OK:Disable()
	needConfirm = 1

	if m_Equip_Idx ~= -1 then
	
		if m_UIType == UI_TYPE_ATTR then
			needMoney = 800000
		elseif m_UIType == UI_TYPE_ATTRNew then
		    needMoney = 50000
		elseif m_UIType == UI_TYPE_COMPOUND then
			needMoney = 800000
                elseif m_UIType ==   UI_TYPE_HCLV then
	            needMoney = 2000000
		elseif m_UIType == UI_TYPE_LIFE then
			needMoney = 500000
		elseif m_UIType == UI_TYPE_SLOT then
			needMoney = 800000
		elseif m_UIType == UI_TYPE_SLZY then
			needMoney = 500000
	        elseif m_UIType == UI_TYPE_XIEZI then
			needMoney = 500000
		end
		WuhunMagicUp_p_DemandMoney : SetProperty("MoneyNumber", needMoney)
	end
	
	if m_Equip_Idx ~= -1 and m_Equip_Item ~= -1 then
		WuhunMagicUp_p_OK:Enable()
		if m_UIType == UI_TYPE_ATTR then
			needMoney = 800000
		elseif m_UIType == UI_TYPE_ATTRNew then
		    needMoney = 50000
		elseif m_UIType == UI_TYPE_COMPOUND then
			needMoney = 800000
                elseif m_UIType ==   UI_TYPE_HCLV then
	            needMoney = 2000000
		elseif m_UIType == UI_TYPE_LIFE then
			needMoney = 500000
		elseif m_UIType == UI_TYPE_SLOT then
			needMoney = 800000
		elseif m_UIType == UI_TYPE_SLZY then
			needMoney = 500000
	        elseif m_UIType == UI_TYPE_XIEZI then
			needMoney = 500000
		end
		WuhunMagicUp_p_DemandMoney : SetProperty("MoneyNumber", needMoney)
	end
end


--Help
function WuhunMagicUp_p_Help_Clicked()

end