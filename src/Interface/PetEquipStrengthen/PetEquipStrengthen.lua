local Enhance_Equip =  -1	--强化的装备
local Enhance_Item = 30900060   --破军强化精华
local Enhance_PJJH = 30505266	--破军强化露
local objCared = -1;
local g_Object = -1;
function PetEquipStrengthen_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("OBJECT_CARED_EVENT")
	this:RegisterEvent("PUT_STENGTHEN_ITEM_PETEQUIP")
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")
	this:RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("TAKE_STENGTHEN_ITEM_PETEQUIP")
	this:RegisterEvent("MONEYJZ_CHANGE"); 

end

function PetEquipStrengthen_OnLoad()

end

function PetEquipStrengthen_OnEvent(event)
	if ( event == "UI_COMMAND" ) then
		if tonumber(arg0) == 20092450 then
			PetEquipStrengthen_Clear();
			Init_PetEquipStrengthen_Frame();
			objCared = -1
			local xx = Get_XParam_INT(0);
			objCared = DataPool : GetNPCIDByServerID(xx);
			if tonumber(objCared)==nil or  tonumber(objCared)== -1 then
				return;
			end
			this:Show();
			BeginCareObject_PetEquipStrengthen(objCared);
		end
	elseif	( event == "UNIT_MONEY" and this:IsVisible()) then
		PetEquipStrengthen_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
	elseif  ( event == "MONEYJZ_CHANGE" and this:IsVisible()) then
		PetEquipStrengthen_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ")); 
	elseif  ( event == "PUT_STENGTHEN_ITEM_PETEQUIP" ) then
		if arg0~= nil then
			PetEquipStrengthen_Update(arg0);
		end
		local playerMoney = Player:GetData("MONEY");
		PetEquipStrengthen_SelfMoney:SetProperty("MoneyNumber", playerMoney);
		PetEquipStrengthen_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ")); --zchw
	elseif (event == "TAKE_STENGTHEN_ITEM_PETEQUIP") then
		PetEquipStrengthen_Clear();
		Init_PetEquipStrengthen_Frame();
	elseif	( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible()) then
		if(tonumber(arg0) and PlayerPackage:GetItemTableIndex(tonumber(arg0)) == Enhance_Item) then
				if(PlayerPackage:IsLock(tonumber(arg0)) == 1) then
					LifeAbility:ClosePetEquipEnhanceMsgBox();
					return;
				end
		end
		if (Enhance_Equip == tonumber(arg0)) then
			PetEquipStrengthen_Update(arg0);
		end
	end
end


function PetEquipStrengthen_Clear()
	if Enhance_Equip ~= -1 then
		PetEquipStrengthen_Object1:SetActionItem(-1);
		LifeAbility : Lock_Packet_Item(Enhance_Equip,0);
		Enhance_Equip = -1
		LifeAbility:CloseStrengthMsgBox();
	end
	PetEquipStrengthen_Money : SetProperty("MoneyNumber", 0)
	PetEquipStrengthen_SelfJiaozi:SetProperty("MoneyNumber", 0)
end

function Init_PetEquipStrengthen_Frame()
	local playerMoney = Player:GetData("MONEY");
	PetEquipStrengthen_SelfMoney:SetProperty("MoneyNumber", playerMoney);
	PetEquipStrengthen_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ")); 
	PetEquipStrengthen_Info2:Hide();
	PetEquipStrengthen_Info6:Hide();
	PetEquipStrengthen_Info5:Hide();
	PetEquipStrengthen_Info8:Hide();
	PetEquipStrengthen_Info7:Hide();
	PetEquipStrengthen_Info9:Hide();
end

function BeginCareObject_PetEquipStrengthen(objCared)
	g_Object = objCared;
	this:CareObject(tonumber(g_Object), 1, "PetEquipStrengthen");
end

function PetEquipStrengthen_OnHiden()
	PetEquipStrengthen_Clear();
end


--放入了珍兽装备
function PetEquipStrengthen_Update(Item_index)
	local i_index = tonumber(Item_index)
	local theAction = EnumAction(i_index, "packageitem");
	local NeedMoney
	local Property
	
	if theAction:GetID() ~= 0 then
			local EquipPoint = LifeAbility : Get_PetEquip_Point(i_index)
			if EquipPoint == -1  then
				return
			end
			NeedMoney,Property = LifeAbility : Get_PetEquip_EnhanceLevel(i_index);
			
			if(NeedMoney<=0 or tonumber(Property)==nil or tonumber(Property)<0) then
				if Enhance_Equip ~= -1 then
					NeedMoney = 0
					PetEquipStrengthen_OK:Disable()
				else
					return
				end
			else				
				PetEquipStrengthen_OK:Enable()
			end

			if Enhance_Equip ~= -1 then
				LifeAbility : Lock_Packet_Item(Enhance_Equip,0);
			end
			
			LifeAbility:ClosePetEquipEnhanceMsgBox();
			
			PetEquipStrengthen_Info5:Show();
			PetEquipStrengthen_Info5:SetText(""..tonumber(Property).."%");
			local Equip_Level = LifeAbility : Get_PetEquip_Level(i_index);
			PetEquipStrengthen_Object1:SetActionItem(theAction:GetID());
			LifeAbility : Lock_Packet_Item(i_index,1);
			Enhance_Equip = i_index
			PetEquipStrengthen_Money : SetProperty("MoneyNumber", tostring(NeedMoney));
			
			local StrongLevel = LifeAbility:Get_PetEquip_CurStrengthLevel(i_index);
			
			if(tonumber(StrongLevel)~=nil and tonumber(StrongLevel)>=0)then
				PetEquipStrengthen_Info2:Show();
				PetEquipStrengthen_Info6:Show();
				if(tonumber(StrongLevel) == 0)then
					PetEquipStrengthen_Info6:SetText("0");
				else
					PetEquipStrengthen_Info6:SetText(""..tonumber(StrongLevel));
				end
			end

			local Equip_Level = LifeAbility : Get_PetEquip_Level(i_index);
			
			PetEquipStrengthen_Info8:Show();
			PetEquipStrengthen_Info7:Show();
			PetEquipStrengthen_Info7 : SetText("#{ZSZB_090421_49}")
			PetEquipStrengthen_Info9:Show();
	else			
			return;
	end	
end

--点击确定按钮强化装备
local EB_FREE_BIND = 0;				-- 无绑定限制
local EB_BINDED = 1;				-- 已经绑定
local	EB_GETUP_BIND =2			-- 拾取绑定
local	EB_EQUIP_BIND =3			-- 装备绑定
function PetEquipStrengthen_Buttons_Clicked()
	if Enhance_Equip == -1 then
		PushDebugMessage("#{ZSZB_090421_43}")
		return
	end
	--找强化精华
	local isExist = IsItemExist_NoLimit(tonumber(Enhance_Item))
	local isExist1 = IsItemExist_NoLimit(tonumber(Enhance_PJJH))
	if isExist ~= 1 and isExist1 ~= 1 then
		PushDebugMessage("#{ZSZB_090421_44}");
		return
	end

	local index,BindState = PlayerPackage:FindFirstBindedItemIdxByIDTable(tonumber(Enhance_Item));
	local indexPJJH, BindStatePJJH = PlayerPackage:FindFirstBindedItemIdxByIDTable(tonumber(Enhance_PJJH));
	if(index == -1 and indexPJJH == -1)then
		PushDebugMessage("#{ZSZB_090421_45}");
		return
	end
	
	if(BindState == EB_BINDED)then
		--如果已绑定
		local tmp = PlayerPackage:GetItemBindStatusByIndex(Enhance_Equip);
		if(tmp == EB_BINDED)then
			Clear_XSCRIPT();
				Set_XSCRIPT_Function_Name("FinishEnhance");
				Set_XSCRIPT_ScriptID(809269);
				Set_XSCRIPT_Parameter(0,Enhance_Equip);
				Set_XSCRIPT_ParamCount(1);
			Send_XSCRIPT();
		else
			PlayerPackage:OpenPetEquipEnhanceMsgBox(tonumber(Enhance_Equip));
		end
	else	
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("FinishEnhance");
			Set_XSCRIPT_ScriptID(809269);
			Set_XSCRIPT_Parameter(0,Enhance_Equip);
			Set_XSCRIPT_ParamCount(1);
		Send_XSCRIPT();
	end
end