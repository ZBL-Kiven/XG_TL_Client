local Enchange_Item1 = -1;
local Enchange_Item2 = -1;
local g_Object = -1;

local g_check = -1;--�Ƿ����ȷ��

local EB_FREE_BIND = 0;				-- �ް�����

local EB_BINDED = 1;				-- �Ѿ���

local	EB_GETUP_BIND =2			-- ʰȡ��

local	EB_EQUIP_BIND =3			-- װ����

local g_EquipName = {

	[0]		="����",
	
	[1]		="ñ��",
	
	[2]		="�·�",
	
	[3]		="����",
	
	[4]		="Ь"  ,
	
	[5]		="����",
	
	[6]		="��ָ",
	
	[7]	  ="����",
	
	[8]		="���",
	
	[9]		="����",
	
	[10]	="���",
	
	[11]	="��ָ",
	
	[12]	="����",
	
	[13]  ="����",
	
	[14]	="����",
	
	[15]  ="����",
	
	[16]	="ʱװ",
	
	[17]  ="����",
	
	[18]  ="���",
	
	[19]  ="����",
	
	}


local g_EquipNewStrengthen_Frame_UnifiedPosition;

function EquipNewStrengthen_PreLoad()

	this:RegisterEvent("UI_COMMAND")

	this:RegisterEvent("PUT_NEW_STENGTHEN_ITEM")
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")
	this:RegisterEvent("TAKE_STENGTHEN_ITEM")
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("MONEYJZ_CHANGE");
end

function EquipNewStrengthen_OnLoad()

	g_EquipNewStrengthen_Frame_UnifiedPosition=EquipNewStrengthen_Frame:GetProperty("UnifiedPosition");
end

function EquipNewStrengthen_OnEvent(event)
	if ( event == "UI_COMMAND" ) and tonumber(arg0) == 20130521 then
	
			EquipNewStrengthen_Clear(0);
			
			local xx = Get_XParam_INT(0);
			
			if tonumber(xx) == -1 then
			
				return
				
			end
			
			objCared = -1
			
			objCared = DataPool : GetNPCIDByServerID(xx);
			
			if tonumber(objCared)==nil or  tonumber(objCared)== -1 then
			
				PushDebugMessage("server�����������������⡣");
				
				return;
				
			end
			
			this:Show();
			
			EquipNewStrengthen_BeginCareObject(objCared);
			
	elseif  (event == "UI_COMMAND" and tonumber(arg0) == 201107281  and  this:IsVisible())  then

		if Enchange_Item1 == -1 then
		   arg0 = 0
		elseif 	Enchange_Item1 ~= -1 and Enchange_Item2 == -1 and Enchange_Item1 ~= tonumber(arg1) then
		   arg0 = 1
		elseif 	Enchange_Item1 ~= -1 and Enchange_Item2 ~= -1 and Enchange_Item1 ~= Enchange_Item2 then
		   arg0 = 2
		end
		if tonumber(arg0) >= 0 and tonumber(arg0) <= 2 then
		
		EquipNewStrengthen_Update(tonumber(arg0),tonumber(arg1));
		
		end
		local playerMoney = Player:GetData("MONEY");
		
		EquipNewStrengthen_SelfMoney:SetProperty("MoneyNumber", playerMoney);
		
		EquipNewStrengthen_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"));

	elseif	( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible()) then
	
	
	
		if (tonumber(Enchange_Item1) == tonumber(arg0)) then
		
		

			
			
			EquipNewStrengthen_Clear(0);
			
			
		end
		if (tonumber(Enchange_Item2) == tonumber(arg0)) then


			EquipNewStrengthen_Clear(1);
			
			
			
		end
		
		
	elseif (event == "TAKE_STENGTHEN_ITEM") then
	
	
	
		if this:IsVisible() then
		
		
		
			EquipNewStrengthen_Clear(0)
			
			

		
		
			EquipNewStrengthen_Clear(1)
			
			
		end
	elseif (event == "ADJEST_UI_POS" ) then
	
	
	
	
		EquipNewStrengthen_Frame_On_ResetPos()
		
		
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
	
	
	
		EquipNewStrengthen_Frame_On_ResetPos()
		
		
	elseif	( event == "UNIT_MONEY" and this:IsVisible()) then
	
	
	
		EquipNewStrengthen_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
		
		
		
	elseif (event == "MONEYJZ_CHANGE" and this:IsVisible()) then
	
	
	
		EquipNewStrengthen_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"));
		
		
	end
end

function EquipNewStrengthen_BeginCareObject(objCared)



	g_Object = objCared;
	
	
	this:CareObject(tonumber(g_Object), 1, "EquipNewStrengthen");
	
	
end

function EquipNewStrengthen_Update(boxpos,Item_index)



	-- �ж��Ƿ�Ϊ��ȫʱ��
	if (tonumber(DataPool:GetLeftProtectTime()) > 0) then
	
		PushDebugMessage("#{ZYXT_120528_16}")
		
		return
	end

	--���õ� ��Ϊ������������ʾ�ӵ�N����ж�,�Բв߻�
	--����ô���򵥵Ĺ��ܵ��ж�, д��10ҳ�߻���, ��ÿ����ʾ����һ��, ��˵ʲôд�����ܼ�
	--�Ͱ�������һ��һ��Щ,�ҿ�������ű�������д�����ж�

	local i_index = tonumber(Item_index)
	
	local theAction = EnumAction(i_index, "packageitem");
	
	local msg = ""

	if tonumber(boxpos) == 0 then
	
		-- �ж���ߵ�
		local EquipPoint = LifeAbility : Get_Equip_Point(i_index)
		
		if EquipPoint == -1 then	--�������װ��,�������Ѿ��з��صĴ�����Ϣ
		
			return
		end
		if EquipPoint == 8 or EquipPoint == 9 or EquipPoint == 10 or EquipPoint > 19 then
		
				--PushDebugMessage("#{ZBQH_130521_10}")	--����װ��
				
				return
		end


		local curlevel = LifeAbility:Get_Equip_CurStrengthLevel(i_index);
		
		if tonumber(curlevel) <= 0 then
			PushDebugMessage("#{ZBQH_130521_12}")
			return
		end
		if PlayerPackage:IsLock(i_index) == 1 then
			PushDebugMessage("#{ZBQH_130521_13}");
			return
		end

		EquipNewStrengthen_Clear(0)
		local curlevel = LifeAbility:Get_Equip_CurStrengthLevel(i_index)
		EquipNewStrengthen_Info4:SetText(""..tonumber(curlevel));
		if tonumber(Enchange_Item1) ~= -1 then
			LifeAbility : Lock_Packet_Item(Enchange_Item1,0);
		end

		EquipNewStrengthen_Object1:SetActionItem(theAction:GetID());
		LifeAbility : Lock_Packet_Item(i_index,1);
		Enchange_Item1 = i_index
	end

	if tonumber(boxpos) == 1 then
		--�ж��ұߵ�
		local EquipPoint2 = LifeAbility : Get_Equip_Point(i_index)
		if EquipPoint2 == -1 then	--�������װ��,�������Ѿ��з��صĴ�����Ϣ
			return
		end
		if EquipPoint2 == 8 or EquipPoint2 == 9 or EquipPoint2 == 10 or EquipPoint2 > 19 then
				PushDebugMessage("#{ZBQH_130521_14}")	--����װ�� ���ϱߵ���ʾ��һ��
				return
		end



		if tonumber(Enchange_Item1) < 0 then
			PushDebugMessage("#{ZBQH_130521_16}")
			return
		end

		local EquipPoint1 = LifeAbility : Get_Equip_Point(Enchange_Item1)
		local Equip_Level1 = LifeAbility : Get_Equip_Level(Enchange_Item1);
		local Equip_Level2 = LifeAbility : Get_Equip_Level(i_index);
		local curlevel1 = LifeAbility:Get_Equip_CurStrengthLevel(Enchange_Item1);
		local curlevel2 = LifeAbility:Get_Equip_CurStrengthLevel(i_index);

		if tonumber(EquipPoint1) ~= tonumber(EquipPoint2) then			--���ֶ�����ʾ

			local theAction1 = EnumAction(Enchange_Item1, "packageitem");
			local leftItemName = theAction1:GetName()

			if tonumber(Equip_Level1) < 40 then
				msg =  string.format("#H���ɽ�%s#H��ǿ���ȼ�ת����װ���ȼ�����40����%s#H֮�ϡ�",leftItemName, g_EquipName[EquipPoint1])
			end

			if tonumber(Equip_Level1) >= 40 then
				msg =  string.format("#H���ɽ�%s#H��ǿ���ȼ�ת����װ���ȼ��ﵽ40�������ϵȼ���%s#H֮�ϡ�",leftItemName, g_EquipName[EquipPoint1])
			end

			PushDebugMessage(msg)
			return
		end

		if tonumber(Equip_Level1) < 40 and tonumber(Equip_Level2) >= 40 then
			local theAction1 = EnumAction(Enchange_Item1, "packageitem");
			local leftItemName = theAction1:GetName()
			msg =  string.format("#H���ɽ�%s#H��ǿ���ȼ�ת����װ���ȼ�����40����%s#H֮�ϡ�",leftItemName, g_EquipName[EquipPoint1])
			PushDebugMessage(msg)
			return
		end

		if tonumber(Equip_Level1) >= 40 and tonumber(Equip_Level2) < 40 then
			local theAction1 = EnumAction(Enchange_Item1, "packageitem");
			local leftItemName = theAction1:GetName()
			msg =  string.format("#H���ɽ�%s#H��ǿ���ȼ�ת����װ���ȼ��ﵽ40�������ϵȼ���%s#H֮�ϡ�",leftItemName, g_EquipName[EquipPoint1])
			PushDebugMessage(msg)
			return
		end

		if tonumber(curlevel1) <= tonumber(curlevel2) then
			msg =  string.format("#H��װ����ǿ���ȼ��Ѵﵽ�򳬹�Դװ����ǿ���ȼ���%s#H�����޷�����ת�ơ�",curlevel1)
			PushDebugMessage(msg)
			return
		end

		EquipNewStrengthen_Clear(1)
		EquipNewStrengthen_Info7:SetText(""..tonumber(curlevel2));

		EquipNewStrengthen_Object2:SetActionItem(theAction:GetID());
		LifeAbility : Lock_Packet_Item(i_index,1);
		Enchange_Item2 = i_index
	end

	if tonumber(boxpos) == 2 then
		--�Ҽ������������Ʒ
		local EquipPoint2 = LifeAbility : Get_Equip_Point(i_index)
		if EquipPoint2 == -1 then	--�������װ��,�������Ѿ��з��صĴ�����Ϣ
			return
		end
		if  EquipPoint2 == 8 or EquipPoint2 == 9 or EquipPoint2 == 10 or EquipPoint2 > 19 then
				PushDebugMessage("#{ZBQH_130521_14}")	--����װ��
				return
		end



		if tonumber(Enchange_Item1) >= 0 then
			--�Ҽ�����ŵ��ұ�
			local EquipPoint1 = LifeAbility : Get_Equip_Point(Enchange_Item1)
			local Equip_Level1 = LifeAbility : Get_Equip_Level(Enchange_Item1);
			local Equip_Level2 = LifeAbility : Get_Equip_Level(i_index);
			local curlevel1 = LifeAbility:Get_Equip_CurStrengthLevel(Enchange_Item1);
			local curlevel2 = LifeAbility:Get_Equip_CurStrengthLevel(i_index);

			if tonumber(EquipPoint1) ~= tonumber(EquipPoint2) then			--���ֶ�����ʾ
				local theAction1 = EnumAction(Enchange_Item1, "packageitem");
				local leftItemName = theAction1:GetName()

				if tonumber(Equip_Level1) < 40 then
					msg =  string.format("#H���ɽ�%s#H��ǿ���ȼ�ת����װ���ȼ�����40����%s#H֮�ϡ�",leftItemName, g_EquipName[EquipPoint1])
				end

				if tonumber(Equip_Level1) >= 40 then
					msg =  string.format("#H���ɽ�%s#H��ǿ���ȼ�ת����װ���ȼ��ﵽ40�������ϵȼ���%s#H֮�ϡ�",leftItemName, g_EquipName[EquipPoint1])
				end

				PushDebugMessage(msg)
				return
			end

			if tonumber(Equip_Level1) < 40 and tonumber(Equip_Level2) >= 40 then
				local theAction1 = EnumAction(Enchange_Item1, "packageitem");
				local leftItemName = theAction1:GetName()
				msg =  string.format("#H���ɽ�%s#H��ǿ���ȼ�ת����װ���ȼ�����40����%s#H֮�ϡ�",leftItemName, g_EquipName[EquipPoint1])
				PushDebugMessage(msg)
				return
			end

			if tonumber(Equip_Level1) >= 40 and tonumber(Equip_Level2) < 40 then
				local theAction1 = EnumAction(Enchange_Item1, "packageitem");
				local leftItemName = theAction1:GetName()
				msg =  string.format("#H���ɽ�%s#H��ǿ���ȼ�ת����װ���ȼ��ﵽ40�������ϵȼ���%s#H֮�ϡ�",leftItemName, g_EquipName[EquipPoint1])
				PushDebugMessage(msg)
				return
			end

			if tonumber(curlevel1) <= tonumber(curlevel2) then
				msg =  string.format("#H��װ����ǿ���ȼ��Ѵﵽ�򳬹�Դװ����ǿ���ȼ���%s#H�����޷�����ת�ơ�",curlevel1)
				PushDebugMessage(msg)
				return
			end

			EquipNewStrengthen_Clear(1)
			EquipNewStrengthen_Info7:SetText(""..tonumber(curlevel2));

			EquipNewStrengthen_Object2:SetActionItem(theAction:GetID());
			LifeAbility : Lock_Packet_Item(i_index,1);
			Enchange_Item2 = i_index

		else
			--�Ҽ�����ŵ����
			local curlevel = LifeAbility:Get_Equip_CurStrengthLevel(i_index);
			if tonumber(curlevel) <= 0 then
				PushDebugMessage("#{ZBQH_130521_21}")
				return
			end
			if PlayerPackage:IsLock(i_index) == 1 then
				PushDebugMessage("#{ZBQH_130521_20}");
				return
			end

			EquipNewStrengthen_Clear(0)
			local curlevel = LifeAbility:Get_Equip_CurStrengthLevel(i_index)
			EquipNewStrengthen_Info4:SetText(""..tonumber(curlevel));
			if tonumber(Enchange_Item1) ~= -1 then
				LifeAbility : Lock_Packet_Item(Enchange_Item1,0);
			end

			EquipNewStrengthen_Object1:SetActionItem(theAction:GetID());
			LifeAbility : Lock_Packet_Item(i_index,1);
			Enchange_Item1 = i_index
		end
	end

	if tonumber(Enchange_Item1) >= 0 and tonumber(Enchange_Item2) >= 0 then
		EquipNewStrengthen_OK:Enable()
		g_check = -1
	else
		EquipNewStrengthen_OK:Disable()
	end

	if tonumber(Enchange_Item1) >= 0 then
		local lv = LifeAbility:Get_Equip_CurStrengthLevel(Enchange_Item1);
		local NeedMoney = lv*5
		if tonumber(NeedMoney) > 100 then
			NeedMoney = 100
		end
		EquipNewStrengthen_Money : SetProperty("MoneyNumber", tostring(NeedMoney*10000));
	else
		EquipNewStrengthen_Money : SetProperty("MoneyNumber", "0");
	end
end


function EquipNewStrengthen_Buttons_Clicked()
	local msg = "";


	-- �ж��Ƿ�Ϊ��ȫʱ��
	if (tonumber(DataPool:GetLeftProtectTime()) > 0) then
		PushDebugMessage("#{ZYXT_120528_16}")
		return
	end

	if tonumber(Enchange_Item1) < 0 then
		PushDebugMessage("#{ZBQH_130521_21}")
		return
	end

	local EquipPoint1 = LifeAbility : Get_Equip_Point(Enchange_Item1)
		if EquipPoint1 == -1 then	--�������װ��,�������Ѿ��з��صĴ�����Ϣ
			return
		end
	if  EquipPoint1 == 8 or EquipPoint1 == 9 or EquipPoint1 == 10 or EquipPoint1 > 19 then
			PushDebugMessage("#{ZBQH_130521_21}")	--����װ��
			return
	end



	local curlevel = LifeAbility:Get_Equip_CurStrengthLevel(Enchange_Item1);
	if tonumber(curlevel) <= 0 then
		PushDebugMessage("#{ZBQH_130521_22}")
		return
	end

	if PlayerPackage:IsLock(Enchange_Item1) == 1 then
		PushDebugMessage("#{ZBQH_130521_20}");
		return
	end

	if tonumber(Enchange_Item2) < 0 then
		PushDebugMessage("#{ZBQH_130521_23}")
		return
	end

	local EquipPoint2 = LifeAbility : Get_Equip_Point(Enchange_Item2)
		if EquipPoint2 == -1 then	--�������װ��,�������Ѿ��з��صĴ�����Ϣ
			return
		end
	if EquipPoint2 == 8 or EquipPoint2 == 9 or EquipPoint2 == 10 or EquipPoint2 > 19 then
			PushDebugMessage("#{ZBQH_130521_23}")	--����װ�� ���ϱߵ���ʾ��һ��
			return
	end



	local Equip_Level1 = LifeAbility : Get_Equip_Level(Enchange_Item1);
	local Equip_Level2 = LifeAbility : Get_Equip_Level(Enchange_Item2);
	local curlevel1 = LifeAbility:Get_Equip_CurStrengthLevel(Enchange_Item1);
	local curlevel2 = LifeAbility:Get_Equip_CurStrengthLevel(Enchange_Item2);

	if tonumber(EquipPoint1) ~= tonumber(EquipPoint2) then			--���ֶ�����ʾ
		local theAction1 = EnumAction(Enchange_Item1, "packageitem");
		local leftItemName = theAction1:GetName()

		if tonumber(Equip_Level1) < 40 then
			msg =  string.format("#H���ɽ�%s#H��ǿ���ȼ�ת����װ���ȼ�����40����%s#H֮�ϡ�",leftItemName, g_EquipName[EquipPoint1])
		end

		if tonumber(Equip_Level1) >= 40 then
			msg =  string.format("#H���ɽ�%s#H��ǿ���ȼ�ת����װ���ȼ��ﵽ40�������ϵȼ���%s#H֮�ϡ�",leftItemName, g_EquipName[EquipPoint1])
		end

		PushDebugMessage(msg)
		return
	end

	if tonumber(Equip_Level1) < 40 and tonumber(Equip_Level2) >= 40 then
		local theAction1 = EnumAction(Enchange_Item1, "packageitem");
		local leftItemName = theAction1:GetName()
		msg =  string.format("#H���ɽ�%s#H��ǿ���ȼ�ת����װ���ȼ�����40����%s#H֮�ϡ�",leftItemName, g_EquipName[EquipPoint1])
		PushDebugMessage(msg)
		return
	end

	if tonumber(Equip_Level1) >= 40 and tonumber(Equip_Level2) < 40 then
		local theAction1 = EnumAction(Enchange_Item1, "packageitem");
		local leftItemName = theAction1:GetName()
		msg =  string.format("#H���ɽ�%s#H��ǿ���ȼ�ת����װ���ȼ��ﵽ40�������ϵȼ���%s#H֮�ϡ�",leftItemName, g_EquipName[EquipPoint1])
		PushDebugMessage(msg)
		return
	end

	if tonumber(curlevel1) <= tonumber(curlevel2) then
		msg =  string.format("#H��װ����ǿ���ȼ��Ѵﵽ�򳬹�Դװ����ǿ���ȼ���%s#H�����޷�����ת�ơ�",curlevel1)
		PushDebugMessage(msg)
		return
	end

	local NeedMoney = curlevel1*5
	if tonumber(NeedMoney) > 100 then
		NeedMoney = 100
	end

	local playerMoney = Player:GetData("MONEY");
	local playerMoney_JZ = Player:GetData("MONEY_JZ");
	if playerMoney+playerMoney_JZ < NeedMoney*10000 then
		PushDebugMessage("#{ZBQH_130521_24}")
		return
	end

	local BindState1 = PlayerPackage:GetItemBindStatusByIndex(tonumber(Enchange_Item1));
	local BindState2 = PlayerPackage:GetItemBindStatusByIndex(tonumber(Enchange_Item2));

	if BindState1 == EB_BINDED and BindState2 ~= EB_BINDED and tonumber(g_check) ~= 1 then
		--����ʾ
		local ItemId =tonumber(PlayerPackage:GetItemTableIndex(tonumber(Enchange_Item2)))
		local theAction2 = EnumAction(Enchange_Item2, "packageitem");
		local leftItemName = theAction2:GetName()
		local xpos1,zpos1 = string.find(leftItemName, "��¥")
		if xpos1 ~= nil and zpos1 ~= nil  then
			PushDebugMessage("#{ZBQH_130521_45}")
			return
		end

		msg =  string.format("#cfff263���ڽ�Ҫת��ǿ���ȼ���#GԴװ��#cfff263���ڰ�״̬���ɹ�����ǿ��ת�ƺ�#GĿ��װ��#cfff263����ǿ�ư󶨡�ͬʱ��#GԴװ��#cfff263��ǿ���ȼ����������#GĿ��װ��#cfff263��ǿ���ȼ�����������#G%s#cfff263����#r#GС��ʾ�������ȷ��Ҫ����ת�ƣ����ڹرձ���ʾ���ٴε��ȷ����ť��", curlevel1)
		GameProduceLogin:GameLoginShowSystemInfo(msg)
		g_check = 1;
		return
	end

	if tonumber(curlevel2) > 0 and tonumber(g_check) ~= 1 then
		--�ȼ�������ʾ
		msg =  string.format("#cfff263�ɹ�����ǿ��ת�ƺ�#GԴװ��#cfff263��ǿ���ȼ����������#GĿ��װ��#cfff263��ǿ���ȼ�����������#G%s#cfff263����#r#GС��ʾ�������ȷ��Ҫ����ת�ƣ����ڹرձ���ʾ���ٴε��ȷ����ť��", curlevel1)
		GameProduceLogin:GameLoginShowSystemInfo(msg)
		g_check = 1;
		return
	end
	g_check = -1;
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("FinishMoveEnhance");
		Set_XSCRIPT_ScriptID(809262);
		Set_XSCRIPT_Parameter(0,tonumber(Enchange_Item1));
		Set_XSCRIPT_Parameter(1,tonumber(Enchange_Item2));
		Set_XSCRIPT_Parameter(2,0);
		Set_XSCRIPT_ParamCount(3);
	Send_XSCRIPT();
	EquipNewStrengthen_Clear(0)
	EquipNewStrengthen_Clear(1)
end

function EquipNewStrengthen_Clear(pos)
	if tonumber(pos) == 0 then
		if Enchange_Item1 ~= -1 then
			EquipNewStrengthen_Object1:SetActionItem(-1);
			LifeAbility : Lock_Packet_Item(Enchange_Item1,0);
			Enchange_Item1 = -1
		end
		EquipNewStrengthen_Info4:SetText("");
		EquipNewStrengthen_Money : SetProperty("MoneyNumber", "0");
	end
	if Enchange_Item2 ~= -1 then
		EquipNewStrengthen_Object2:SetActionItem(-1);
		LifeAbility : Lock_Packet_Item(Enchange_Item2,0);
		Enchange_Item2 = -1
	end
	EquipNewStrengthen_Info7:SetText("");
	g_check = -1;
	EquipNewStrengthen_OK:Disable()
	local playerMoney = Player:GetData("MONEY");
	EquipNewStrengthen_SelfMoney:SetProperty("MoneyNumber", playerMoney);
	EquipNewStrengthen_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"));
end
function EquipNewStrengthen_OnHiden()
	EquipNewStrengthen_Clear(0);
end
function EquipNewStrengthen_Frame_On_ResetPos()
	EquipNewStrengthen_Frame:SetProperty("UnifiedPosition", g_EquipNewStrengthen_Frame_UnifiedPosition);
end
function EquipNewStrengthen_Object1_RClicked()
	EquipNewStrengthen_Clear(0);
end
function EquipNewStrengthen_Object2_RClicked()
	EquipNewStrengthen_Clear(1);
end
