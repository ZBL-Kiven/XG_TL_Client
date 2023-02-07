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
local UI_TYPE_SLZY = 8 --����ת��
local m_UIType = 0

local m_Money_COMPOUND = {}

local INDEX_ATTRBOOK_BEGIN	= 30700214	--�����۱�������
local INDEX_ATTRBOOK_END	= 30700229	--�����ζ�������

local INDEX_ADDLIFE = 30700233 --���ٵ�

local INDEX_SLOT_ITEM1 = 20310158 --��ľ��
local INDEX_SLOT_ITEM2 = 20310159 --���콣

local needMoney = 0

local needConfirm = 1

local g_LastTimer = -1 --���ӵ����չ������Ե���ȴʱ��
local MIN_PASS_TIME = 1 --��ȴʱ��1��

--PreLoad
function WuhunMagicUp_p_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("MONEYJZ_CHANGE");
	this:RegisterEvent("PACKAGE_ITEM_CHANGED");
end

--OnLoad
function WuhunMagicUp_p_OnLoad()
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
function WuhunMagicUp_p_OnEvent(event)

	if (event == "UI_COMMAND" and tonumber(arg0) == m_UI_NUM) then
		WuhunMagicUp_p_OnHiden()
		WuhunMagicUp_p_BeginCareObj( Get_XParam_INT(0) );
		m_UIType = Get_XParam_INT(1)
		
		if m_UIType == UI_TYPE_ATTR then
			WuhunMagicUp_p_Title:SetText("����ͨ��")	--
			WuhunMagicUp_p_Info:SetText("#Y��������󣬲��һ�δ����ͨ���106�������ſɽ��д˲�����ͨ����Ҫ#G����ʯ#Yһ�ţ�ͨ��ɹ���������Я���ȼ�����106���䣬��۽���ɸ���������4���������͡�#r#G(ͨ�����������Խ������ϣ�����Ҳ��������)")
			WuhunMagicUp_p_Info2:SetText("#H�������Ҫ����ͨ�������:")
			WuhunMagicUp_p_Info3:SetText("��������ʯ:")
		
		elseif m_UIType == UI_TYPE_COMPOUND then
			WuhunMagicUp_p_Title:SetText("#{WH_xml_XX(18)}")	--�ϳ�
			WuhunMagicUp_p_Info:SetText("#{WH_xml_XX(19)}")
			WuhunMagicUp_p_Info2:SetText("#{WH_xml_XX(20)}")
			WuhunMagicUp_p_Info3:SetText("#{WH_xml_XX(21)}")

		elseif m_UIType == UI_TYPE_HCLV then
			WuhunMagicUp_p_Title:SetText("#gFF0FA0��ʯת��")	--�ϳ�
			WuhunMagicUp_p_Info:SetText("#G��Ҫ��ͬ���͵�װ���ſ��Խ��б�ʯת��,ת����ԭ����װ����ʧ,ԭ��װ���ı�ʯ����ת�Ƶ���װ������#r#cFF0000�м�ԭ����װ������ʧ")
			WuhunMagicUp_p_Info2:SetText("#H��Ҫת�Ƶ�װ��:")
			WuhunMagicUp_p_Info3:SetText("#cfff263ת������װ��:")
	
	        elseif m_UIType == UI_TYPE_XIEZI then
			WuhunMagicUp_p_Title:SetText("#{SLDZ_100805_103}")	--�ϳ�
			WuhunMagicUp_p_Info:SetText("#{SLDZ_100805_104}")
			WuhunMagicUp_p_Info2:SetText("#cfff263����������Ǽ�������:")
			WuhunMagicUp_p_Info3:SetText("#cfff263�������Ϊ���ϵ�����:")	

		elseif m_UIType == UI_TYPE_LIFE then
			WuhunMagicUp_p_Title:SetText("#gFF0FA0����������ϴ")	-- 
			WuhunMagicUp_p_Info:SetText("#Y����#G��ϴ����#W��Ҫ����һ��������#Y����ˮ#W,#G��ͬ�ɳ��ȼ�#W��#Y����#G��ϴ#W���Ժ󣬿��ܳ��ֵ�#G����������ͬ#W#r��ϴ���Ƶ����Ժ����Ƶ�#Gǿ��#W��#G����#W��#G��Ƕ#W��#G����#W��#G����#W��#G�����ܵ��κε�Ӱ��#W��")
			WuhunMagicUp_p_Info2:SetText("��Ҫ��ϴ������:")
			WuhunMagicUp_p_Info3:SetText("#Y����ˮ:")
		
		elseif m_UIType == UI_TYPE_SLOT then
			WuhunMagicUp_p_Title:SetText("#{WH_xml_XX(84)}")	--����������
			WuhunMagicUp_p_Info:SetText("#{WH_xml_XX(85)}")
			WuhunMagicUp_p_Info2:SetText("#{WH_xml_XX(86)}")
			WuhunMagicUp_p_Info3:SetText("#{WH_xml_XX(87)}")

		elseif m_UIType == UI_TYPE_ATTRNew then
			WuhunMagicUp_p_Title:SetText("#{WH_xml_XX(22)}")	--��չ����ѧϰ
			WuhunMagicUp_p_Info:SetText("#{WH_xml_XX(23)}")
			WuhunMagicUp_p_Info2:SetText("#{WH_xml_XX(24)}")
			WuhunMagicUp_p_Info3:SetText("#{WH_xml_XX(25)}")

	        elseif m_UIType == UI_TYPE_SLZY then
			WuhunMagicUp_p_Title:SetText("#gFF0FA0����ȼ�ת��")	--����ת��
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
			
			--���޸��ˣ�����˧��
			--��TT��78726��
			--���  �ٴ��޸�

		end
		
	end
end

--Update UI
function WuhunMagicUp_p_Update(itemIdx)
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
                 WuhunMagicUp_p_Resume_Item()
		 PushDebugMessage( "����������" )
		 return
		 end
        if PlayerPackage:IsLock( itemIdx ) == 1 then
		PushDebugMessage("��[���] ������")	--����������
		return
		end
		elseif (m_UIType == UI_TYPE_HCLV) or (m_UIType == UI_TYPE_XIEZI) or (m_UIType == UI_TYPE_SLZY) then
		local itemID = PlayerPackage:GetItemTableIndex(itemIdx)
		    if ( itemID < 10000001 or itemID > 20000000 ) then
		PushDebugMessage("�˴�ֻ�ܷ���װ��")  
			return
		end
		elseif m_UIType == UI_TYPE_SLOT then
		local EquipPoint = LifeAbility : Get_Equip_Point(itemIdx)	
        if (EquipPoint ~= 18) then
                 WuhunMagicUp_p_Resume_Item()
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
                 WuhunMagicUp_p_Resume_Item()
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
                 WuhunMagicUp_p_Resume_Item()
		 PushDebugMessage( "�����Ҫͨ�������" )
		 return
		 end
		local itemID = PlayerPackage:GetItemTableIndex(itemIdx)
           if ( itemID > 10558591 or itemID < 10558559 )  then
		PushDebugMessage("�˴�ֻ�ܷ���106�������������")  
			return
		end		
                if PlayerPackage:IsLock( itemIdx ) == 1 then
		PushDebugMessage("[����] ������")	--����������
		return
		end		

		elseif m_UIType == UI_TYPE_LIFE then

			if PlayerPackage:IsLock( itemIdx ) == 1 then
				PushDebugMessage("[����] ������")	--����������
				return
			end
		local itemID = PlayerPackage:GetItemTableIndex(itemIdx)
                if ( itemID < 10157001 or itemID >10157100 ) then
		PushDebugMessage("�˴�ֻ�ܷ�������")  
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
                 WuhunMagicUp_p_Resume_Item()
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
			
			local gem_count = LifeAbility : GetEquip_GemCount( itemIdx )
			if gem_count ~= nil and gem_count > 0 then
				PushDebugMessage("#{WH_20090904_01}")	--WH_20090904_01 ��Ƕ�б�ʯ����겻����Ϊ�ϳɲ��ϣ�
				return
			end
			
	    elseif (m_UIType == UI_TYPE_HCLV) or (m_UIType == UI_TYPE_XIEZI) or (m_UIType == UI_TYPE_SLZY) then
		local itemID = PlayerPackage:GetItemTableIndex(itemIdx)
        if ( itemID < 10000001 or itemID > 20000000 ) then
		PushDebugMessage("�˴�ֻ�ܷ���װ��")  
			return
		end
		
		elseif m_UIType == UI_TYPE_LIFE then
			if PlayerPackage:IsLock( itemIdx ) == 1 then
				PushDebugMessage("����ϳɵ�[����] ������")	--����������
				return
			end
		local itemID = PlayerPackage:GetItemTableIndex(itemIdx)
                if ( itemID ~= 20310180  ) then
		PushDebugMessage("����ˮ")  
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
function WuhunMagicUp_p_OK_Clicked()
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
	elseif m_UIType == UI_TYPE_COMPOUND then  --�ϳ�1

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
		--add by kaibin ���ӵ�����������չ������ȴʱ���ж�
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