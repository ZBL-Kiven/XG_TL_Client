--PetSoul_LevelUp

local g_PetSoul_LevelUp_UnifiedPosition;

local MAX_OBJ_DISTANCE = 3.0

local g_PetSoul_LevelUp_MaxPetSoulLevel=100
local g_PetSoul_LevelUp_NpcId = -1;
local g_PetSoul_LevelUp_targetId = -1;
local g_PetSoul_LevelUp_ItemBagIndex = -1
local g_PetSoul_LevelUp_ConfirmBind = 0;

function PetSoul_LevelUp_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("PETSOUL_LEVELUP_CONFIRM");
	this:RegisterEvent("PETSOUL_LEVELUP_PUTIN_ITEM");
	this:RegisterEvent("RESUME_ENCHASE_GEM")
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")			--背包中物品改变需要判断
	this:RegisterEvent("UNIT_MONEY")					--金钱变化
	this:RegisterEvent("MONEYJZ_CHANGE")					--交子变化
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function PetSoul_LevelUp_OnLoad()
	
	g_PetSoul_LevelUp_UnifiedPosition=PetSoul_LevelUp_Frame:GetProperty("UnifiedPosition")
	
	g_PetSoul_LevelUp_ConfirmBind = 0;
end

function PetSoul_LevelUp_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == 80012701 ) then
		
		local bIsShow = Get_XParam_INT(0);
		if bIsShow == 1 then
			PetSoul_LevelUp_Update(-1, 0);
			OpenWindow("Packet")
			g_PetSoul_LevelUp_ConfirmBind = 0;
			this:Show()
		end
		
		if this:IsVisible() then
			g_PetSoul_LevelUp_targetId = Get_XParam_INT( 1 )
			PetSoul_LevelUp_BeginCareObject( g_PetSoul_LevelUp_targetId )
			
			PetSoul_LevelUp_Currently_Money:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
			PetSoul_LevelUp_Currently_Jiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
		end
		
	elseif event == "UI_COMMAND" and tonumber(arg0) == 201107281 and this:IsVisible() then
		if arg1 ~= nil then
			PetSoul_LevelUp_Update( tonumber(arg1), 0 )
		end
		
	elseif ( event == "RESUME_ENCHASE_GEM" and this:IsVisible() ) then
		PetSoul_LevelUp_Update( -1, 0 )
		
	elseif event == "PETSOUL_LEVELUP_CONFIRM" and this:IsVisible() then
		g_PetSoul_LevelUp_ConfirmBind = 1;
		return
						
	elseif event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() then
		
		if not arg0 or tonumber(arg0) == -1 then
			return
		end
		
		if tonumber(arg0) == g_PetSoul_LevelUp_ItemBagIndex then
			PetSoul_LevelUp_Update(g_PetSoul_LevelUp_ItemBagIndex, 1)
		end 
		
		PetSoul_LevelUp_Currently_Money:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
		PetSoul_LevelUp_Currently_Jiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
		return
		
	elseif event == "UNIT_MONEY" and this:IsVisible() then
		PetSoul_LevelUp_Currently_Money:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
		return
	
	elseif event == "MONEYJZ_CHANGE" and this:IsVisible() then
		PetSoul_LevelUp_Currently_Jiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
		return
				
	elseif event == "OBJECT_CARED_EVENT" and this : IsVisible() then
		if(tonumber(arg0) ~= g_PetSoul_LevelUp_NpcId) then
			return;
		end
		
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if arg1 == "distance" and tonumber( arg2 ) > MAX_OBJ_DISTANCE or arg1 == "destroy" then
			PetSoul_LevelUp_Close()
		end
		return
		
	elseif event == "ADJEST_UI_POS" then
		PetSoul_LevelUp_On_ResetPos()
		return
	
	elseif event == "VIEW_RESOLUTION_CHANGED" then
		PetSoul_LevelUp_On_ResetPos()
		return
	end
	
end
function PetSoul_LevelUpToNewItemID(nPetSoulIndex)
	local A1 = math.mod(nPetSoulIndex,100)
	local A2 = A1 - 66
	local A2str = tostring(A2)
	if A2 < 10 then
		A2str = "0"..A2
	end
	local newstr = "706000"..A2str
	return tonumber(newstr)
end

function PetSoul_LevelUp_Update( bagPos, bItemChanged )
	
	if bItemChanged == nil then
		bItemChanged = 0;
	end
	local theAction = EnumAction( bagPos, "packageitem");
	if bagPos >= 0 and theAction:GetID() ~= 0 then
	
		--检查是否为兽魂
		local nLevel=LuaFnGetPetSoulDataInBag( bagPos, "LEVEL")
		local nQual=LuaFnGetPetSoulDataInBag( bagPos, "QUAL")
		local nPetSoulIndex = PlayerPackage:GetItemTableIndex(bagPos);
		if nQual == nil or nLevel == nil then
			PushDebugMessage("#{SHXT_20211230_64}")
			return
		end
						
		--检查是否满级
		if nLevel >= g_PetSoul_LevelUp_MaxPetSoulLevel then
			if bItemChanged == 1 then
				PetSoul_LevelUp_Explain3_Info:SetText( "#{SHXT_20211230_213}" )
				PetSoul_LevelUp_Refresh_Bn_and_Money( 0 )
			else
				PushDebugMessage("#{SHXT_20211230_66}")
			end
			return
		end		
		
		--得到升级消耗及提升资质信息
		local nCostItemCount, nCostMoney = LuaFnGetPetSoulLevelupCost( nLevel, nQual )
		local nStr, nSpr, nCon, nInt, nDex = LuaFnGetPetSoulLevelupData( PetSoul_LevelUpToNewItemID(nPetSoulIndex), nLevel )
		if nCostItemCount == nil or nCostMoney == nil or nStr == nil then
			PushDebugMessage("#{SHXT_20211230_64}")
			return
		end
			
		if g_PetSoul_LevelUp_ItemBagIndex ~= -1 then
			LifeAbility : Lock_Packet_Item(g_PetSoul_LevelUp_ItemBagIndex,0);
		end
		
		PetSoul_LevelUp_ProductItem:SetActionItem(theAction:GetID());
		LifeAbility : Lock_Packet_Item(bagPos,1);
		g_PetSoul_LevelUp_ItemBagIndex = bagPos
		
		local szStr = string.format("%0.2f%%", nStr/100 );
		local szSpr = string.format("%0.2f%%", nSpr/100 );
		local szCon = string.format("%0.2f%%", nCon/100 );
		local szInt = string.format("%0.2f%%", nInt/100 );
		local szDex = string.format("%0.2f%%", nDex/100 );
		local szText = string.format("#cfff263升级需要消耗：#G升魂丹%s个#cfff263。#r本次升级可提升：#G力量资质+%s；灵气资质+%s；体力资质+%s；定力资质+%s；身法资质+%s", nCostItemCount, szStr, szSpr, szCon, szInt, szDex )
		
		
		PetSoul_LevelUp_Explain3_Info:SetText( szText )
		PetSoul_LevelUp_Refresh_Bn_and_Money( nCostMoney )
	else
		PetSoul_LevelUp_ProductItem:SetActionItem(-1);			
		LifeAbility : Lock_Packet_Item(g_PetSoul_LevelUp_ItemBagIndex,0);		
		g_PetSoul_LevelUp_ItemBagIndex = -1;
		
		PetSoul_LevelUp_Explain3_Info:SetText("#{SHXT_20211230_59}")
		PetSoul_LevelUp_Refresh_Bn_and_Money(0)
	end
	
end

function PetSoul_LevelUp_Refresh_Bn_and_Money( nMoney )
	if g_PetSoul_LevelUp_ItemBagIndex ~= -1 and nMoney ~= nil and tonumber(nMoney) > 0 then
		PetSoul_LevelUp_Accept:Enable()
		PetSoul_LevelUp_Demand_Jiaozi:SetProperty("MoneyNumber", tostring(nMoney));
	else
		PetSoul_LevelUp_Demand_Jiaozi:SetProperty("MoneyNumber", "0");
		PetSoul_LevelUp_Accept:Disable();
	end
end

function PetSoul_LevelUp_Buttons_Clicked()

	--二级密码 电话密保检查
	-- if CheckPhoneMibaoAndMinorPassword() ~= 1 then
		-- return
	-- end
	
	--兽魂输入框中是否已放入兽魂
	if g_PetSoul_LevelUp_ItemBagIndex < 0 then
		PushDebugMessage("#{SHXT_20211230_68}")
		return
	end
			
	Clear_XSCRIPT()
		Set_XSCRIPT_ScriptID( 742563 )
		Set_XSCRIPT_Function_Name( "PetSoulCenter" )
		Set_XSCRIPT_Parameter(0, 1)
		Set_XSCRIPT_Parameter(1, g_PetSoul_LevelUp_targetId)
		Set_XSCRIPT_Parameter(2, g_PetSoul_LevelUp_ItemBagIndex)
		Set_XSCRIPT_Parameter(3, g_PetSoul_LevelUp_ConfirmBind)
		Set_XSCRIPT_ParamCount(4)
	Send_XSCRIPT()
end

--=========================================================
--开始关心NPC，
--在开始关心之前需要先确定这个界面是不是已经有“关心”的NPC，
--如果有的话，先取消已经有的“关心”
--=========================================================
function PetSoul_LevelUp_BeginCareObject( objCaredId )
	g_PetSoul_LevelUp_NpcId = DataPool : GetNPCIDByServerID( objCaredId )
	if g_PetSoul_LevelUp_NpcId == -1 then
		this : Hide()
		return
	end

	this : CareObject( g_PetSoul_LevelUp_NpcId, 1, "PetSoul_LevelUp" )
end

--=========================================================
--停止对某NPC的关心
--=========================================================
function PetSoul_LevelUp_StopCareObject()
	this : CareObject( g_PetSoul_LevelUp_NpcId, 0, "PetSoul_LevelUp" )
	g_PetSoul_LevelUp_NpcId = -1
end

function PetSoul_LevelUp_On_ResetPos()
  PetSoul_LevelUp_Frame:SetProperty("UnifiedPosition", g_PetSoul_LevelUp_UnifiedPosition)
end

function PetSoul_LevelUp_OnHiden()
	PetSoul_LevelUp_StopCareObject();
	
	PetSoul_LevelUp_ProductItem:SetActionItem(-1);
	if g_PetSoul_LevelUp_ItemBagIndex ~= -1 then		
		LifeAbility:Lock_Packet_Item(g_PetSoul_LevelUp_ItemBagIndex,0)
		g_PetSoul_LevelUp_ItemBagIndex = -1
	end
	
end

function PetSoul_LevelUp_Close()
	this:Hide()
end


