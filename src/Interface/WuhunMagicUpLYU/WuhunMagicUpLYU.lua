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

local INDEX_ATTRBOOK_BEGIN	= 30700214	--�����۱�������
local INDEX_ATTRBOOK_END	= 30700229	--�����ζ�������

local INDEX_ADDLIFE = 30700233 --���ٵ�

local INDEX_SLOT_ITEM1 = 30121003 --��ľ��
local INDEX_SLOT_ITEM2 = 30700238 --���콣

local needMoney = 0

local needConfirm = 1

local g_LastTimer = -1 --���ӵ����չ������Ե���ȴʱ��
local MIN_PASS_TIME = 1 --��ȴʱ��1��

--PreLoad
function WuhunMagicUpLYU_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("MONEYJZ_CHANGE");
	this:RegisterEvent("PACKAGE_ITEM_CHANGED");
end

--OnLoad
function WuhunMagicUpLYU_OnLoad()
	--���ϳ�����Money
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
			WuhunMagicUpLYU_Title:SetText("����ͨ��")	--
			WuhunMagicUpLYU_Info:SetText("#Y��������󣬲��һ�δ����ͨ���106�������ſɽ��д˲�����ͨ����Ҫ#G����ʯ#Yһ�ţ�ͨ��ɹ���������Я���ȼ�����106���䣬��۽���ɸ���������4���������͡�#r#G(ͨ�����������Խ������ϣ�����Ҳ��������)")
			WuhunMagicUpLYU_Info2:SetText("#H�������Ҫ����ͨ�������:")
			WuhunMagicUpLYU_Info3:SetText("��������ʯ:")
		
		elseif m_UIType == UI_TYPE_COMPOUND then
			WuhunMagicUpLYU_Title:SetText("#{WH_xml_XX(18)}")	--�ϳ�
			WuhunMagicUpLYU_Info:SetText("#{WH_xml_XX(19)}")
			WuhunMagicUpLYU_Info2:SetText("#{WH_xml_XX(20)}")
			WuhunMagicUpLYU_Info3:SetText("#{WH_xml_XX(21)}")
		
		elseif m_UIType == UI_TYPE_LIFE then
			WuhunMagicUpLYU_Title:SetText("���ƺϳ�")	-- 
			WuhunMagicUpLYU_Info:SetText("#cffcc00#G2#cffcc00��#cFF0000�ɳ��ȼ�#cffcc00��ͬ�����ƿ��Ժϳ�#G1#cffcc00����������ȼ������ƣ��ϳɺ����Եõ���չ")
			WuhunMagicUpLYU_Info2:SetText("�������Ҫ�ϳɵ�����:")
			WuhunMagicUpLYU_Info3:SetText("�������Ҫ�ϳɵ�����:")
		
		elseif m_UIType == UI_TYPE_SLOT then
			WuhunMagicUpLYU_Title:SetText("#{WH_xml_XX(84)}")	--����������
			WuhunMagicUpLYU_Info:SetText("#{WH_xml_XX(85)}")
			WuhunMagicUpLYU_Info2:SetText("#{WH_xml_XX(86)}")
			WuhunMagicUpLYU_Info3:SetText("#{WH_xml_XX(87)}")
		elseif m_UIType == UI_TYPE_ATTRNew then
			WuhunMagicUpLYU_Title:SetText("#{WH_xml_XX(22)}")	--��չ����ѧϰ
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
			
			--���޸��ˣ�����˧��
			--��TT��78726��
			--���  �ٴ��޸�

		end
		
	end
end

--Update UI
function WuhunMagicUpLYU_Update(itemIdx)
	local theAction = EnumAction(itemIdx, "packageitem");
	if theAction:GetID() ~= 0 then
		local myequi = PlayerPackage:GetItemTableIndex(itemIdx)
	    if 20000000 <= myequi then
		PushDebugMessage( "ֻ��װ���ſ��Խ��������������" )
		return
		end	
		if m_UIType == UI_TYPE_COMPOUND then
	        local EquipPoint = LifeAbility : Get_Equip_Point(itemIdx)	
         	 if (EquipPoint ~= 18) then
                 WuhunMagicUpLYU_Resume_Item()
		 PushDebugMessage( "����������" )
		 return
		 end
        if PlayerPackage:IsLock( itemIdx ) == 1 then
		PushDebugMessage("��[���] ������")	--����������
		return
		end
		
		elseif m_UIType == UI_TYPE_SLOT then
		local EquipPoint = LifeAbility : Get_Equip_Point(itemIdx)	
        if (EquipPoint ~= 18) then
                 WuhunMagicUpLYU_Resume_Item()
		 PushDebugMessage( "�����Ҫ������չ�����������" )
		 return
		 end
        if PlayerPackage:IsLock( itemIdx ) == 1 then
		PushDebugMessage("[���] ������")	--����������
		return
		end
		elseif m_UIType == UI_TYPE_ATTRNew then
			        local EquipPoint = LifeAbility : Get_Equip_Point(itemIdx)	
         	 if (EquipPoint ~= 18) then
                 WuhunMagicUpLYU_Resume_Item()
		 PushDebugMessage( "�����Ҫѧϰ��չ���Ե����" )
		 return
		 end
                if PlayerPackage:IsLock( itemIdx ) == 1 then
		PushDebugMessage("[���] ������")	--����������
		return
		end

        elseif m_UIType == UI_TYPE_ATTR then 
	         local EquipPoint = LifeAbility : Get_Equip_Point(itemIdx)	
         	 if (EquipPoint ~= 0) then
                 WuhunMagicUpLYU_Resume_Item()
		 PushDebugMessage( "�����Ҫͨ�������" )
		 return
		 end
		local itemID = PlayerPackage:GetItemTableIndex(itemIdx)
           if ( itemID > 10558591 or itemID < 10558559 )  then
		PushDebugMessage("�˴�ֻ�ܷ���106��δͨ���������")  
			return
		end		
                if PlayerPackage:IsLock( itemIdx ) == 1 then
		PushDebugMessage("[����] ������")	--����������
		return
		end		

		elseif m_UIType == UI_TYPE_LIFE then
                 local EquipPoint = LifeAbility : Get_Equip_Point(itemIdx)
         	 if (EquipPoint ~= 18) then
                      WuhunMagicUpLYU_Resume_Item()
		       PushDebugMessage( "�����������" )
		       return
		       end

			if PlayerPackage:IsLock( itemIdx ) == 1 then
				PushDebugMessage("[����] ������")	--����������
				return
			end
		local itemID = PlayerPackage:GetItemTableIndex(itemIdx)
                if ( itemID < 10170001 or itemID > 10170900 ) then
		PushDebugMessage("�˴�ֻ�ܷ�������")  
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
			  	PushDebugMessage("�˴�ֻ�ܷ��� [#{_ITEM30505818}]")  
			 	return
			  end

			if PlayerPackage:IsLock( itemIdx ) == 1 then
				PushDebugMessage("[#{_ITEM30505818}] ������")	--����������
				return
			end
	    elseif m_UIType == UI_TYPE_ATTRNew then
			local itemID = PlayerPackage:GetItemTableIndex(itemIdx)
			if itemID < INDEX_ATTRBOOK_BEGIN or itemID > INDEX_ATTRBOOK_END then
				PushDebugMessage("#{WH_090729_20}")  --�˴�ֻ�ܷ�����������顣
				return
			end

			if PlayerPackage:IsLock( itemIdx ) == 1 then
				PushDebugMessage("#{WH_090729_07}")	--����������
				return
			end
		elseif m_UIType == UI_TYPE_COMPOUND then

        local EquipPoint = LifeAbility : Get_Equip_Point(itemIdx)
         	 if (EquipPoint ~= 18) then
                 WuhunMagicUpLYU_Resume_Item()
		 PushDebugMessage( "��������ϳɵ����" )
		 return
		 end			
		if PlayerPackage:IsLock( itemIdx ) == 1 then
		PushDebugMessage("����ϳɵ�[���] ������")	--����������
		return
		end
		local gem_count = LifeAbility : GetEquip_GemCount( itemIdx )
		if gem_count ~= nil and gem_count > 0 then
		PushDebugMessage("��Ƕ�б�ʯ��[���]���ܲ���ϳɣ�")	
			return
		 end

	
		elseif m_UIType == UI_TYPE_LIFE then
                 local EquipPoint = LifeAbility : Get_Equip_Point(itemIdx)
         	 if (EquipPoint ~= 18) then
                      WuhunMagicUpLYU_Resume_Item()
		       PushDebugMessage( "��������ϳɵ�����" )
		       return
		       end

			if PlayerPackage:IsLock( itemIdx ) == 1 then
				PushDebugMessage("����ϳɵ�[����] ������")	--����������
				return
			end
		local itemID = PlayerPackage:GetItemTableIndex(itemIdx)
                if ( itemID < 10170001 or itemID > 10170900 ) then
		PushDebugMessage("�˴�ֻ�ܷ�������")  
			return
		end
		local gem_count = LifeAbility : GetEquip_GemCount( itemIdx )
		if gem_count ~= nil and gem_count > 0 then
		PushDebugMessage("��Ƕ�б�ʯ��[����]���ܲ���ϳɣ�")	
			return
		 end
		elseif m_UIType == UI_TYPE_SLOT then
			local itemID = PlayerPackage:GetItemTableIndex(itemIdx)
			if itemID ~=  INDEX_SLOT_ITEM1 and itemID ~= INDEX_SLOT_ITEM2 then
				PushDebugMessage("#{WH_090729_51}") --�˴�ֻ�ܷ�����ľ�������콣
				return
			end

			if PlayerPackage:IsLock( itemIdx ) == 1 then
				PushDebugMessage("#{WH_090729_52}")	--����������
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
--���������չ����cooldownʱ����
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
		PushDebugMessage("#{WH_090729_18}")  --�Բ��������Ͻ�Ǯ���㣬�޷��������С�
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
	elseif m_UIType == UI_TYPE_COMPOUND then  --�ϳ�
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
		--add by kaibin ���ӵ�����������չ������ȴʱ���ж�
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