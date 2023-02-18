-- ��ֲ װ������ת��

local Divert_Item1 = -1;
local Divert_Item2 = -1;
local g_Object = -1;
local g_check = -1;--�Ƿ����ȷ��

local EB_FREE_BIND = 0;				-- �ް�����
local EB_BINDED = 1;				-- �Ѿ���
local	EB_GETUP_BIND =2			-- ʰȡ��
local	EB_EQUIP_BIND =3			-- װ����

local g_EquipDWDivert_Frame_UnifiedPosition;

function EquipDWDivert_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("EQUIP_DW_DIVERT")
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")
	this:RegisterEvent("TAKE_STENGTHEN_ITEM")
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("MONEYJZ_CHANGE");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("RESUME_ENCHASE_GEM")
end

function EquipDWDivert_OnLoad()

	g_EquipDWDivert_Frame_UnifiedPosition=EquipDWDivert_Frame:GetProperty("UnifiedPosition");
end

function EquipDWDivert_OnEvent(event)
	if ( event == "UI_COMMAND" ) then
		if tonumber(arg0) == 20141216 then	--�򿪽���
			local type = Get_XParam_INT(0);
			if tonumber(type) == 1 then
				--�򿪴���
				local targetid = Get_XParam_INT(1);
				local objCared = DataPool : GetNPCIDByServerID(targetid);
				if tonumber(objCared)==nil or  tonumber(objCared)== -1 then
					PushDebugMessage("server�����������������⡣");
					return;
				end
				EquipDWDivert_BeginCareObject(objCared);
				EquipDWDivert_Clear(0);
				this:Show();
				return
			elseif tonumber(type) == 2 then
				return
			end
		end
		
	elseif event == "OBJECT_CARED_EVENT" then
	
		if(g_Object ~= DataPool:GetCurDialogNpcId()) then
			return;
		end
		--�����NPC�ľ������һ��������߱�ɾ�����Զ��ر�
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			g_Object = -1;
			this:CareObject(tonumber(g_Object), 0, "EquipDWDivert");
			EquipDWDivert_OnHiden()
		end
	elseif  ( event == "EQUIP_DW_DIVERT" and this:IsVisible()) then
		--���´����ϵ�װ��
		if tonumber(arg0) == 0 or tonumber(arg0) == 1 or tonumber(arg0) == 2 then
			EquipDWDivert_Update(arg0,arg1);
		end

		local playerMoney = Player:GetData("MONEY");
		EquipDWDivert_SelfMoney:SetProperty("MoneyNumber", playerMoney);
		EquipDWDivert_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ")); --zchw

	elseif	( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible()) then
		if (tonumber(Divert_Item1) == tonumber(arg0)) then
			EquipDWDivert_Clear(0);
		end
		if (tonumber(Divert_Item2) == tonumber(arg0)) then
			EquipDWDivert_Clear(2);
		end
	elseif (event == "TAKE_STENGTHEN_ITEM" and this:IsVisible()) then
		if arg0 == "G167" then		--�Ƴ����,Ҫ��ͬ�ұ�һ���Ƴ�
			EquipDWDivert_Clear(0)
		elseif arg0 == "G168" then		--�Ƴ��ұ�,����Ҫ������
			EquipDWDivert_Clear(2)
		end
	elseif (event == "RESUME_ENCHASE_GEM" and this:IsVisible()) then
		if arg0 == "167" then		--�Ƴ����,Ҫ��ͬ�ұ�һ���Ƴ�
			EquipDWDivert_Clear(0)
		elseif arg0 == "168" then		--�Ƴ��ұ�,����Ҫ������
			EquipDWDivert_Clear(2)
		end
	elseif (event == "ADJEST_UI_POS" ) then
		EquipDWDivert_Frame_On_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		EquipDWDivert_Frame_On_ResetPos()
	elseif	( event == "UNIT_MONEY" and this:IsVisible()) then
		EquipDWDivert_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
	elseif (event == "MONEYJZ_CHANGE" and this:IsVisible()) then
		EquipDWDivert_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"));
	end
end

function EquipDWDivert_BeginCareObject(objCared)
	g_Object = objCared;
	this:CareObject(tonumber(g_Object), 1, "EquipDWDivert");
end

function EquipDWDivert_Update(boxpos,Item_index)

	--Դװ����, ��Ϊ��ʾ��һ��,����Ҫ��Ŀ��װ���ڷֿ��ж�
	--�жϵ绰�ܱ��Ͷ������뱣��
	if CheckPhoneMibaoAndMinorPassword() ~= 1 then
		return
	end
	-- -- �ж��Ƿ�Ϊ��ȫʱ��
	-- if (tonumber(DataPool:GetLeftProtectTime()) > 0) then
	-- 	PushDebugMessage("#{ZYXT_120528_16}")
	-- 	return
	-- end
	
	local i_index = tonumber(Item_index)
	local theAction = EnumAction(i_index, "packageitem");
	local msg = ""

	local EquipPoint = LifeAbility : Get_Equip_Point(i_index)
	if EquipPoint == -1 then	--�������װ��,�������Ѿ��з��صĴ�����Ϣ
		return
	end
	
	if EquipPoint == 8 or EquipPoint == 9 or EquipPoint == 10 or EquipPoint == 16 then
		PushDebugMessage("#{DWZY_141216_13}")	--�޷�����ǿ��ת��
		return
	end
	
	if tonumber(boxpos) == 0 then
		-- �ж���ߵ�
		
		local IsHaveDiaowen = LifeAbility:IsEquipHaveDiaowen(i_index)
		
		if IsHaveDiaowen~=1 then
			PushDebugMessage("#{DWZY_141216_14}")
			return
		end			

		if PlayerPackage:IsLock(i_index) == 1 then
			PushDebugMessage("#{DWZY_141216_15}");
			return
		end

		EquipDWDivert_Clear(0)
		EquipDWDivert_Object1:SetActionItem(theAction:GetID());
		LifeAbility : Lock_Packet_Item(i_index,1);
		Divert_Item1 = i_index
		
	end

	if tonumber(boxpos) == 1 then
		--�ж��ұߵ�
		
		if tonumber(Divert_Item1) < 0 then
			PushDebugMessage("#{DWZY_141216_19}")
			return
		end
		
		local IsHaveDiaowen = LifeAbility:IsEquipHaveDiaowen(i_index)
	
		if IsHaveDiaowen == 1 then
			PushDebugMessage("#{DWZY_141216_18}")
			return
		end
		
		local EquipPoint1 = LifeAbility : Get_Equip_Point(Divert_Item1)
		if EquipPoint ~= EquipPoint1 then
			PushDebugMessage("#{DWZY_141216_20}")
			return
		end
				
		if tonumber(Divert_Item1) < 0 then
			PushDebugMessage("#{ZBQH_130521_16}")
			return
		end
		
		local haveIndentify = LifeAbility:IsIndentify(i_index)
		if haveIndentify ~= 1 then
			PushDebugMessage("#{DWZY_141216_43}")
			return
		end

		local EquipIndex2 = PlayerPackage:GetItemTableIndex(i_index)
		local Equip_Level2 = LifeAbility : Get_Equip_Level(i_index);
		local isSuperWeapon = 0
		if EquipIndex2 >= 10300000 and EquipIndex2 <= 10309999 then
			isSuperWeapon = 1
		end
	
		-- ��ֲ��д ���ɲ�����50�����µ����������ϵ���
		-- if Equip_Level2 < 50 and EquipPoint ~= 17 and isSuperWeapon == 0 then
		if Equip_Level2 < 50 then
			PushDebugMessage("#{DWZY_141216_37}")
			return
		end

		EquipDWDivert_Clear(2)

		EquipDWDivert_Object2:SetActionItem(theAction:GetID());
		LifeAbility : Lock_Packet_Item(i_index,1);
		Divert_Item2 = i_index
	end

	if tonumber(boxpos) == 2 then
		--�Ҽ������������Ʒ
		if tonumber(Divert_Item1) >= 0 then
			--�������,���������ұ�
			local IsHaveDiaowen = LifeAbility:IsEquipHaveDiaowen(i_index)
			if IsHaveDiaowen == 1 then
				PushDebugMessage("#{DWZY_141216_18}")
				return
			end
			
			local EquipPoint1 = LifeAbility : Get_Equip_Point(Divert_Item1)
			if EquipPoint ~= EquipPoint1 then
				PushDebugMessage("#{DWZY_141216_20}")
				return
			end
			
			local haveIndentify = LifeAbility:IsIndentify(i_index)
			if haveIndentify ~= 1 then
				PushDebugMessage("#{DWZY_141216_43}")
				return
			end

			
			local EquipIndex2 = PlayerPackage:GetItemTableIndex(i_index)
			local Equip_Level2 = LifeAbility : Get_Equip_Level(i_index);
			local isSuperWeapon = 0
			if EquipIndex2 >= 10300000 and EquipIndex2 <= 10309999 then
				isSuperWeapon = 1
			end
		
			-- if Equip_Level2 < 50 and EquipPoint ~= 17 and isSuperWeapon == 0 then
			-- ��ֲ��д ���ɲ�����50�����µ����������ϵ���
			if Equip_Level2 < 50 then
				PushDebugMessage("#{DWZY_141216_37}")
				return
			end
	
			EquipDWDivert_Clear(2)
	
			EquipDWDivert_Object2:SetActionItem(theAction:GetID());
			LifeAbility : Lock_Packet_Item(i_index,1);
			Divert_Item2 = i_index
		end
		
		if tonumber(Divert_Item1) < 0 then
			--���û��,�����������
			local IsHaveDiaowen = LifeAbility:IsEquipHaveDiaowen(i_index)
			
			if IsHaveDiaowen~=1 then
				PushDebugMessage("#{DWZY_141216_14}")
				return
			end				
	
			if PlayerPackage:IsLock(i_index) == 1 then
				PushDebugMessage("#{DWZY_141216_15}");
				return
			end
	
			EquipDWDivert_Clear(0)
			EquipDWDivert_Object1:SetActionItem(theAction:GetID());
			LifeAbility : Lock_Packet_Item(i_index,1);
			Divert_Item1 = i_index
		end
	
	end

	if tonumber(Divert_Item1) >= 0 then
		--ˢ������
		local msg1,msg2= LifeAbility:GetEquipDiaowen_Name(Divert_Item1)
		-- if msg1~="" and msg2~=""then
		-- 	local dwId,dwlevel = LifeAbility:GetEquitDiaowenID(Divert_Item1)
		-- 	local dwIdEx,dwlevelEx = LifeAbility:GetEquitDiaowenIDEx(Divert_Item1)
		-- 	local msg = "#{SSXDW_140819_09}��"..msg1.."��"..msg2.."("..dwlevel.."#{SSXDW_140819_67}��"..dwlevelEx.."#{SSXDW_140819_67})"
		-- 	EquipDWDivert_Info4:SetText( msg )

		-- elseif msg1 ~= "" then
		-- 	local dwId,dwlevel = LifeAbility:GetEquitDiaowenID(Divert_Item1)
		-- 	local strName = LifeAbility:GetWearedDiaoWenName(dwId)
		-- 	EquipDWDivert_Info4:SetText( "#cFF0000"..strName )
		-- end

		if msg1 ~= "" then
			local dwId,dwlevel = LifeAbility:GetEquitDiaowenID(Divert_Item1)
			local strName = LifeAbility:GetWearedDiaoWenName(dwId)
			EquipDWDivert_Info4:SetText( "#cFF0000"..strName )
		end

		if msg1 == "" then
			EquipDWDivert_Clear(0)
			return
		end
		local costMoney = 100000
		if msg2~="" then
			costMoney = 200000
		end
	
		EquipDWDivert_Money : SetProperty("MoneyNumber", tostring(costMoney));
	else
		EquipDWDivert_Money : SetProperty("MoneyNumber", "0");
	end

	if tonumber(Divert_Item1) >= 0 and tonumber(Divert_Item2) >= 0 then
		EquipDWDivert_OK:Enable()
		g_check = -1
	else
		EquipDWDivert_OK:Disable()
	end

end


function EquipDWDivert_OK_Clicked()
	local msg = "";

	--Դװ����, ��Ϊ��ʾ��һ��,����Ҫ��Ŀ��װ���ڷֿ��ж�
	--�жϵ绰�ܱ��Ͷ������뱣��
	if CheckPhoneMibaoAndMinorPassword() ~= 1 then
		return
	end
	-- -- �ж��Ƿ�Ϊ��ȫʱ��
	-- if (tonumber(DataPool:GetLeftProtectTime()) > 0) then
	-- 	PushDebugMessage("#{ZYXT_120528_16}")
	-- 	return
	-- end

	if tonumber(Divert_Item1) < 0 then
		PushDebugMessage("#{DWZY_141216_19}")
		return
	end

	local EquipPoint1 = LifeAbility : Get_Equip_Point(Divert_Item1)
	if EquipPoint1 == -1 then	--�������װ��,�������Ѿ��з��صĴ�����Ϣ
		return
	end
	if EquipPoint1 == 8 or EquipPoint1 == 9 or EquipPoint1 == 10 or EquipPoint1 == 16 then
			PushDebugMessage("#{DWZY_141216_30}")	--����װ��
			return
	end

	if PlayerPackage:IsLock(Divert_Item1) == 1 then
		PushDebugMessage("#{DWZY_141216_32}");
		return
	end

	if tonumber(Divert_Item2) < 0 then
		PushDebugMessage("#{DWZY_141216_33}")
		return
	end

	local EquipPoint2 = LifeAbility : Get_Equip_Point(Divert_Item2)
		if EquipPoint2 == -1 then	--�������װ��,�������Ѿ��з��صĴ�����Ϣ
			return
		end
	if EquipPoint2 == 8 or EquipPoint2 == 9 or EquipPoint2 == 10 or EquipPoint2 > 21 then
			PushDebugMessage("#{DWZY_141216_34}")	--����װ�� ���ϱߵ���ʾ��һ��
			return
	end

	if tonumber(EquipPoint1) ~= tonumber(EquipPoint2) then			--
		PushDebugMessage("#{DWZY_141216_36}")
		return
	end

	local haveIndentify = LifeAbility:IsIndentify(Divert_Item2)
	if haveIndentify ~= 1 then
		PushDebugMessage("#{DWZY_141216_43}")
		return
	end
	
	local EquipIndex2 = PlayerPackage:GetItemTableIndex(Divert_Item2)
	local Equip_Level2 = LifeAbility : Get_Equip_Level(Divert_Item2);
	local isSuperWeapon = 0
	if EquipIndex2 >= 10300000 and EquipIndex2 <= 10309999 then
		isSuperWeapon = 1
	end

	-- ��ֲ��д ���ɲ�����50�����µ����������ϵ���
	-- if Equip_Level2 < 50 and EquipPoint2 ~= 17 and isSuperWeapon == 0 then
	if Equip_Level2 < 50 then
		PushDebugMessage("#{DWZY_141216_37}")
		return
	end


	local costMoney = 100000
	-- local IsDiaowenEx = LifeAbility:IsEquipHaveDiaowenEx(Divert_Item1)
	-- if IsDiaowenEx == 1 then
	-- 	costMoney = 200000
	-- end

	local playerMoney = Player:GetData("MONEY");
	local playerMoney_JZ = Player:GetData("MONEY_JZ");
	if playerMoney+playerMoney_JZ < costMoney then
		PushDebugMessage("#{DWZY_141216_40}")
		return
	end

	local BindState2 = PlayerPackage:GetItemBindStatusByIndex(tonumber(Divert_Item2));

	if BindState2 ~= EB_BINDED and tonumber(g_check) ~= 1 then
		--����ʾ
		if IsUnbindChongLouEquip(PlayerPackage:GetItemTableIndex(tonumber(Divert_Item2))) ~= 1 then
			--�ǰ���¥����ķǰ�װ��,��Ҫ��������ȷ��	
			GameProduceLogin : ShowMessageBox( "#{DWZY_141216_38}", "Close", "-1")
			g_check = 1;
			return
		end
	end

	g_check = -1;

	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("DoDiaowenDivert");
		Set_XSCRIPT_ScriptID(809272);
		Set_XSCRIPT_Parameter(0,Divert_Item1);
		Set_XSCRIPT_Parameter(1,Divert_Item2);
		Set_XSCRIPT_Parameter(2,0);--2015 VIP�����ƹ��� By YuanPeiLong
		Set_XSCRIPT_ParamCount(3);--2015 VIP�����ƹ��� By YuanPeiLong
	Send_XSCRIPT();

end

function EquipDWDivert_Clear(pos)
	if tonumber(pos) == 0 or tonumber(pos) == 1 then
		if Divert_Item1 ~= -1 then
			EquipDWDivert_Object1:SetActionItem(-1);
			LifeAbility : Lock_Packet_Item(Divert_Item1,0);
			Divert_Item1 = -1
		end
		EquipDWDivert_Info4:SetText("");
		EquipDWDivert_Money : SetProperty("MoneyNumber", "0");
	end
	if tonumber(pos) == 0 or tonumber(pos) == 2 then
		if Divert_Item2 ~= -1 then
			EquipDWDivert_Object2:SetActionItem(-1);
			LifeAbility : Lock_Packet_Item(Divert_Item2,0);
			Divert_Item2 = -1
		end
	end

	g_check = -1;
	EquipDWDivert_OK:Disable()

	local playerMoney = Player:GetData("MONEY");
	EquipDWDivert_SelfMoney:SetProperty("MoneyNumber", playerMoney);
	EquipDWDivert_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"));
end

function EquipDWDivert_OnHiden()
	EquipDWDivert_Clear(0);
	this:Hide()
end

function EquipDWDivert_Frame_On_ResetPos()
  EquipDWDivert_Frame:SetProperty("UnifiedPosition", g_EquipDWDivert_Frame_UnifiedPosition);
end

function EquipDWDivert_Object1_RClicked()
			EquipDWDivert_Clear(0);
end

function EquipDWDivert_Object2_RClicked()
			EquipDWDivert_Clear(2);
end