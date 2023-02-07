--0 鉴定装备资质
--1 重新鉴定装备资质
local Current = 0;
local PetIdentify_Item = -1
local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;

local Tjs_idx = 30900061;
local Tjc_idx = 30505267
local g_Object = -1;

local g_PetIdentify_Frame_UnifiedPosition;

function PetIdentify_PreLoad()

	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("OBJECT_CARED_EVENT",false)
	this:RegisterEvent("UPDATE_IDENTIFY_PET")
	this:RegisterEvent("RESUME_ENCHASE_GEM_EX",false)
	this:RegisterEvent("PACKAGE_ITEM_CHANGED_EX",false)
	this:RegisterEvent("UNIT_MONEY",false);
	this:RegisterEvent("MONEYJZ_CHANGE",false);
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
end

function PetIdentify_OnLoad()
	g_PetIdentify_Frame_UnifiedPosition=PetIdentify_Frame:GetProperty("UnifiedPosition");

end

function PetIdentify_OnEvent(event)

	if ( event == "UI_COMMAND" ) then
	
		if tonumber(arg0) == 20092461 then
			Current = 0;
			PetIdentify_Title:SetText( "#{ZSZB_090421_16}" );
			PetIdentify_Info:SetText( "#{ZSZB_090421_17}" );
			PetIdentify_Info2:SetText( "#{ZSZB_090421_18}" );
		elseif tonumber(arg0) == 20092462 then
			--Current = 1;
			--PetIdentify_Title:SetText( "#{ZSZB_090421_26}" );
			--PetIdentify_Info:SetText( "#{ZSZB_090421_27}" );
			--PetIdentify_Info2:SetText( "#{ZSZB_090421_28}" );
			return;
		elseif  tonumber(arg0) == 201107281 and this:IsVisible() then
			local playerMoney = Player:GetData("MONEY");
			PetIdentify_SelfMoney:SetProperty("MoneyNumber", playerMoney);
			PetIdentify_DemandJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"));
			if arg1 ~= nil then
				PetIdentify_Update(arg1)
			end
			return;
		else
			return;
		end
			
		if this:IsVisible() then
			PetIdentify_Close();
		end

		this:Show();
		objCared = -1
		local xx = Get_XParam_INT(0);
		objCared = DataPool : GetNPCIDByServerID(xx);

		if objCared == nil or objCared == -1 then
			return;
		end
		
		local playerMoney = Player:GetData("MONEY");
		PetIdentify_SelfMoney:SetProperty("MoneyNumber", playerMoney);
		PetIdentify_DemandJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"));
		
		BeginCareObject_PetIdentify(objCared)

	elseif( event == "RESUME_ENCHASE_GEM_EX" and this:IsVisible() ) then
		local playerMoney = Player:GetData("MONEY");
		PetIdentify_SelfMoney:SetProperty("MoneyNumber", playerMoney);
		--zchw
		PetIdentify_DemandJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"));
		if(arg0~=nil and tonumber(arg0) == 74 ) then
			PetIdentify_Resume_Equip_Gem(1)
		end
	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		--距离过远
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			
			PetIdentify_Close()
		end

	elseif ( event == "PACKAGE_ITEM_CHANGED_EX" and this:IsVisible() ) then
		
		local playerMoney = Player:GetData("MONEY");
		PetIdentify_SelfMoney:SetProperty("MoneyNumber", playerMoney);
		PetIdentify_DemandJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"));
		
		if( arg0~= nil and -1 == tonumber(arg0)) then
			return;
		end

		if( arg0~= nil and Current~=1) then	--重新鉴定装备资质不用移除装备
			if (PetIdentify_Item == tonumber(arg0) ) then
				PetIdentify_Resume_Equip_Gem(1)			
			end
		end
		if( arg0~= nil and Current==1) then
			if(tonumber(arg0)) then
				local itemIdx = PlayerPackage:GetItemTableIndex(tonumber(arg0))
				if (itemIdx == Tjs_idx or itemIdx == Tjc_idx) then
					if(PlayerPackage:IsLock(tonumber(arg0)) == 1) then
						LifeAbility:CloseReIdentifyMsgBox();
						return;
					end
				end
			end
		end
	elseif (event == "UNIT_MONEY" and this:IsVisible()) then
		PetIdentify_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
	--zchw
	elseif (event == "MONEYJZ_CHANGE" and this:IsVisible()) then
		PetIdentify_DemandJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
		
	elseif (event == "ADJEST_UI_POS" ) then
		PetIdentify_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		PetIdentify_Frame_On_ResetPos()
		
	end


end

function PetIdentify_OnShown()
	PetIdentify_Clear();
end

function PetIdentify_Clear()
	if PetIdentify_Item ~= -1 then
		PetIdentify_Object:SetActionItem(-1);
		LifeAbility : Lock_Packet_Item(PetIdentify_Item,0);
		PetIdentify_Item = -1
		--push事件干掉msgbox
		LifeAbility:CloseReIdentifyMsgBox();
		PetIdentify_DemandMoney : SetProperty("MoneyNumber", 0);
	end

end

function PetIdentify_Update(Item_index)
	local index = tonumber(Item_index)
	local theAction = EnumAction(index, "packageitem");
	
	if theAction:GetID() ~= 0 then
		local ItemID = PlayerPackage:GetItemTableIndex(index)
	--珍兽装备
		if (ItemID < 39990000 or ItemID > 39994162) then
			return
		end
		if PetIdentify_Item ~= -1 then
			LifeAbility : Lock_Packet_Item(PetIdentify_Item,0);
		end
		LifeAbility:CloseReIdentifyMsgBox();
		PetIdentify_Object:SetActionItem(theAction:GetID());
		LifeAbility : Lock_Packet_Item(index,1);
		PetIdentify_Item = index
		local Equip_Level = 85--LifeAbility:Get_Equip_Level(index);
		local NeedMoney 
		
		if Current == 0 then
			if Equip_Level >= 1 and Equip_Level <= 9 then
					NeedMoney = 10 
				elseif Equip_Level >= 10 and Equip_Level <= 19 then
					NeedMoney = 100 
				elseif Equip_Level >= 20 and Equip_Level <= 29 then
					NeedMoney = 1000 
				elseif Equip_Level >= 30 and Equip_Level <= 39 then
					NeedMoney = 3000 
				elseif Equip_Level >= 40 and Equip_Level <= 49 then
					NeedMoney = 4000 
				elseif Equip_Level >= 50 and Equip_Level <= 59 then
					NeedMoney = 5000 
				elseif Equip_Level >= 60 and Equip_Level <= 69 then
					NeedMoney = 6000 
				elseif Equip_Level >= 70 and Equip_Level <= 79 then
					NeedMoney = 7000 
				elseif Equip_Level >= 80 and Equip_Level <= 89 then
					NeedMoney = 8000 
				elseif Equip_Level >= 90 and Equip_Level <= 99 then
					NeedMoney = 10000 
				elseif Equip_Level < 110 then
					NeedMoney = 20000
				elseif Equip_Level < 120 then
					NeedMoney = 30000
				else
					NeedMoney = 40000
				end
		elseif Current == 1 then
			NeedMoney = Equip_Level * 20 + 50;
		end
		
		PetIdentify_DemandMoney : SetProperty("MoneyNumber", tostring(NeedMoney));
			
	else
		PetIdentify_Object:SetActionItem(-1);			
		LifeAbility : Lock_Packet_Item(PetIdentify_Item,0);		
		PetIdentify_Item = -1;
		--push事件干掉msgbox
		LifeAbility:CloseReIdentifyMsgBox();
	end
	
end
local EB_FREE_BIND = 0;				-- 无绑定限制
local EB_BINDED = 1;				-- 已经绑定
local	EB_GETUP_BIND =2			-- 拾取绑定
local	EB_EQUIP_BIND =3			-- 装备绑定
function PetIdentify_Buttons_Clicked()
	if PetIdentify_Item ~= -1 and PlayerPackage : GetItemTableIndex( PetIdentify_Item ) ~= -1 then
		
		if Current == 0 then
			Clear_XSCRIPT();
				Set_XSCRIPT_Function_Name("FinishAdjust");
				Set_XSCRIPT_ScriptID(809268);
				Set_XSCRIPT_Parameter(0,PetIdentify_Item);
				Set_XSCRIPT_ParamCount(1);
			Send_XSCRIPT();
		elseif Current == 1 then

			-- 判断是否为安全时间2012.6.12-LIUBO
			if (tonumber(DataPool:GetLeftProtectTime()) > 0) then
				PushDebugMessage("#{ZYXT_120528_16}")
				return
			end
	
			local isExist1 = IsItemExist(tonumber(Tjc_idx))
			local isExist2 = IsItemExist(tonumber(Tjs_idx))
			if isExist1 ~= 1 and isExist2 ~= 1 then
				PushDebugMessage("#{ZSZB_090421_34}");
				return
			end

			local indexTJC,BindStateTJC = PlayerPackage:FindFirstBindedItemIdxByIDTable(tonumber(Tjc_idx));
			local index,BindState = PlayerPackage:FindFirstBindedItemIdxByIDTable(tonumber(Tjs_idx));
			if index == -1 and indexTJC == -1 then
				PushDebugMessage("#{ZSZB_090421_35}");
				return
			end
			if BindState == EB_BINDED then
				--如果已绑定
				local tmp = PlayerPackage:GetItemBindStatusByIndex(PetIdentify_Item);
				if(tmp == EB_BINDED)then
					Clear_XSCRIPT();
						Set_XSCRIPT_Function_Name("FinishReAdjust");
						Set_XSCRIPT_ScriptID(809268);
						Set_XSCRIPT_Parameter(0,PetIdentify_Item);
						Set_XSCRIPT_ParamCount(1);
					Send_XSCRIPT();
				else
					PlayerPackage:OpenPetEquipReIdentifyMsgBox(tonumber(PetIdentify_Item));
				end
			else
				Clear_XSCRIPT();
					Set_XSCRIPT_Function_Name("FinishReAdjust");
					Set_XSCRIPT_ScriptID(809268);
					Set_XSCRIPT_Parameter(0,PetIdentify_Item);
					Set_XSCRIPT_ParamCount(1);
				Send_XSCRIPT();
			end
		end

	else
		PushDebugMessage("#{ZSZB_090421_20}")
	end
end

function PetIdentify_Close()
	this:Hide()
end

function PetIdentify_Cancel_Clicked()
	PetIdentify_Close();
	return;
end

function PetIdentify_OnHiden()
	StopCareObject_PetIdentify(objCared)
	PetIdentify_Clear()
	return
end


function BeginCareObject_PetIdentify(objCaredId)
	
	g_Object = objCaredId;
	this:CareObject(g_Object, 1, "PetIdentify");

end

--=========================================================
--停止对某NPC的关心
--=========================================================
function StopCareObject_PetIdentify(objCaredId)
	this:CareObject(objCaredId, 0, "PetIdentify");
	g_Object = -1;

end

function PetIdentify_Resume_Equip_Gem(nIndex)

	if( this:IsVisible() ) then
		if nIndex == 1 then
			if(PetIdentify_Item ~= -1) then
				LifeAbility : Lock_Packet_Item(PetIdentify_Item,0);
				PetIdentify_Object : SetActionItem(-1);
				PetIdentify_Item	= -1;
				PetIdentify_DemandMoney : SetProperty("MoneyNumber", 0);
				LifeAbility:CloseReIdentifyMsgBox();
			end
		end
	end

end


function PetIdentify_Frame_On_ResetPos()
  PetIdentify_Frame:SetProperty("UnifiedPosition", g_PetIdentify_Frame_UnifiedPosition);
end