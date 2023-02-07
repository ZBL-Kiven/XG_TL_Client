local Enchange_Item1 = -1;
local Enchange_Item2 = -1;
local g_Object = -1;

local g_check = -1;--是否二次确认

local EB_FREE_BIND = 0;				-- 无绑定限制

local EB_BINDED = 1;				-- 已经绑定

local	EB_GETUP_BIND =2			-- 拾取绑定

local	EB_EQUIP_BIND =3			-- 装备绑定

local g_EquipName = {

	[0]		="武器",
	
	[1]		="帽子",
	
	[2]		="衣服",
	
	[3]		="手套",
	
	[4]		="鞋"  ,
	
	[5]		="腰带",
	
	[6]		="戒指",
	
	[7]	  ="项链",
	
	[8]		="骑乘",
	
	[9]		="行囊",
	
	[10]	="箱格",
	
	[11]	="戒指",
	
	[12]	="护符",
	
	[13]  ="护符",
	
	[14]	="护腕",
	
	[15]  ="护肩",
	
	[16]	="时装",
	
	[17]  ="暗器",
	
	[18]  ="武魂",
	
	[19]  ="龙纹",
	
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
			
				PushDebugMessage("server传过来的数据有问题。");
				
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



	-- 判断是否为安全时间
	if (tonumber(DataPool:GetLeftProtectTime()) > 0) then
	
		PushDebugMessage("#{ZYXT_120528_16}")
		
		return
	end

	--你妹的 就为你这个乱遭的提示加的N多的判断,脑残策划
	--就这么个简单的功能的判断, 写了10页策划案, 还每步提示都不一样, 还说什么写起来很简单
	--就按案子里一步一步些,我看看这个脚本到底能写多少判断

	local i_index = tonumber(Item_index)
	
	local theAction = EnumAction(i_index, "packageitem");
	
	local msg = ""

	if tonumber(boxpos) == 0 then
	
		-- 判断左边的
		local EquipPoint = LifeAbility : Get_Equip_Point(i_index)
		
		if EquipPoint == -1 then	--如果不是装备,代码里已经有返回的错误信息
		
			return
		end
		if EquipPoint == 8 or EquipPoint == 9 or EquipPoint == 10 or EquipPoint > 19 then
		
				--PushDebugMessage("#{ZBQH_130521_10}")	--不是装备
				
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
		--判断右边的
		local EquipPoint2 = LifeAbility : Get_Equip_Point(i_index)
		if EquipPoint2 == -1 then	--如果不是装备,代码里已经有返回的错误信息
			return
		end
		if EquipPoint2 == 8 or EquipPoint2 == 9 or EquipPoint2 == 10 or EquipPoint2 > 19 then
				PushDebugMessage("#{ZBQH_130521_14}")	--不是装备 和上边的提示不一样
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

		if tonumber(EquipPoint1) ~= tonumber(EquipPoint2) then			--各种恶心提示

			local theAction1 = EnumAction(Enchange_Item1, "packageitem");
			local leftItemName = theAction1:GetName()

			if tonumber(Equip_Level1) < 40 then
				msg =  string.format("#H仅可将%s#H的强化等级转移至装备等级不足40级的%s#H之上。",leftItemName, g_EquipName[EquipPoint1])
			end

			if tonumber(Equip_Level1) >= 40 then
				msg =  string.format("#H仅可将%s#H的强化等级转移至装备等级达到40级及以上等级的%s#H之上。",leftItemName, g_EquipName[EquipPoint1])
			end

			PushDebugMessage(msg)
			return
		end

		if tonumber(Equip_Level1) < 40 and tonumber(Equip_Level2) >= 40 then
			local theAction1 = EnumAction(Enchange_Item1, "packageitem");
			local leftItemName = theAction1:GetName()
			msg =  string.format("#H仅可将%s#H的强化等级转移至装备等级不足40级的%s#H之上。",leftItemName, g_EquipName[EquipPoint1])
			PushDebugMessage(msg)
			return
		end

		if tonumber(Equip_Level1) >= 40 and tonumber(Equip_Level2) < 40 then
			local theAction1 = EnumAction(Enchange_Item1, "packageitem");
			local leftItemName = theAction1:GetName()
			msg =  string.format("#H仅可将%s#H的强化等级转移至装备等级达到40级及以上等级的%s#H之上。",leftItemName, g_EquipName[EquipPoint1])
			PushDebugMessage(msg)
			return
		end

		if tonumber(curlevel1) <= tonumber(curlevel2) then
			msg =  string.format("#H该装备的强化等级已达到或超过源装备的强化等级：%s#H级，无法接受转移。",curlevel1)
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
		--右键点击背包的物品
		local EquipPoint2 = LifeAbility : Get_Equip_Point(i_index)
		if EquipPoint2 == -1 then	--如果不是装备,代码里已经有返回的错误信息
			return
		end
		if  EquipPoint2 == 8 or EquipPoint2 == 9 or EquipPoint2 == 10 or EquipPoint2 > 19 then
				PushDebugMessage("#{ZBQH_130521_14}")	--不是装备
				return
		end



		if tonumber(Enchange_Item1) >= 0 then
			--右键点击放到右边
			local EquipPoint1 = LifeAbility : Get_Equip_Point(Enchange_Item1)
			local Equip_Level1 = LifeAbility : Get_Equip_Level(Enchange_Item1);
			local Equip_Level2 = LifeAbility : Get_Equip_Level(i_index);
			local curlevel1 = LifeAbility:Get_Equip_CurStrengthLevel(Enchange_Item1);
			local curlevel2 = LifeAbility:Get_Equip_CurStrengthLevel(i_index);

			if tonumber(EquipPoint1) ~= tonumber(EquipPoint2) then			--各种恶心提示
				local theAction1 = EnumAction(Enchange_Item1, "packageitem");
				local leftItemName = theAction1:GetName()

				if tonumber(Equip_Level1) < 40 then
					msg =  string.format("#H仅可将%s#H的强化等级转移至装备等级不足40级的%s#H之上。",leftItemName, g_EquipName[EquipPoint1])
				end

				if tonumber(Equip_Level1) >= 40 then
					msg =  string.format("#H仅可将%s#H的强化等级转移至装备等级达到40级及以上等级的%s#H之上。",leftItemName, g_EquipName[EquipPoint1])
				end

				PushDebugMessage(msg)
				return
			end

			if tonumber(Equip_Level1) < 40 and tonumber(Equip_Level2) >= 40 then
				local theAction1 = EnumAction(Enchange_Item1, "packageitem");
				local leftItemName = theAction1:GetName()
				msg =  string.format("#H仅可将%s#H的强化等级转移至装备等级不足40级的%s#H之上。",leftItemName, g_EquipName[EquipPoint1])
				PushDebugMessage(msg)
				return
			end

			if tonumber(Equip_Level1) >= 40 and tonumber(Equip_Level2) < 40 then
				local theAction1 = EnumAction(Enchange_Item1, "packageitem");
				local leftItemName = theAction1:GetName()
				msg =  string.format("#H仅可将%s#H的强化等级转移至装备等级达到40级及以上等级的%s#H之上。",leftItemName, g_EquipName[EquipPoint1])
				PushDebugMessage(msg)
				return
			end

			if tonumber(curlevel1) <= tonumber(curlevel2) then
				msg =  string.format("#H该装备的强化等级已达到或超过源装备的强化等级：%s#H级，无法接受转移。",curlevel1)
				PushDebugMessage(msg)
				return
			end

			EquipNewStrengthen_Clear(1)
			EquipNewStrengthen_Info7:SetText(""..tonumber(curlevel2));

			EquipNewStrengthen_Object2:SetActionItem(theAction:GetID());
			LifeAbility : Lock_Packet_Item(i_index,1);
			Enchange_Item2 = i_index

		else
			--右键点击放到左边
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


	-- 判断是否为安全时间
	if (tonumber(DataPool:GetLeftProtectTime()) > 0) then
		PushDebugMessage("#{ZYXT_120528_16}")
		return
	end

	if tonumber(Enchange_Item1) < 0 then
		PushDebugMessage("#{ZBQH_130521_21}")
		return
	end

	local EquipPoint1 = LifeAbility : Get_Equip_Point(Enchange_Item1)
		if EquipPoint1 == -1 then	--如果不是装备,代码里已经有返回的错误信息
			return
		end
	if  EquipPoint1 == 8 or EquipPoint1 == 9 or EquipPoint1 == 10 or EquipPoint1 > 19 then
			PushDebugMessage("#{ZBQH_130521_21}")	--不是装备
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
		if EquipPoint2 == -1 then	--如果不是装备,代码里已经有返回的错误信息
			return
		end
	if EquipPoint2 == 8 or EquipPoint2 == 9 or EquipPoint2 == 10 or EquipPoint2 > 19 then
			PushDebugMessage("#{ZBQH_130521_23}")	--不是装备 和上边的提示不一样
			return
	end



	local Equip_Level1 = LifeAbility : Get_Equip_Level(Enchange_Item1);
	local Equip_Level2 = LifeAbility : Get_Equip_Level(Enchange_Item2);
	local curlevel1 = LifeAbility:Get_Equip_CurStrengthLevel(Enchange_Item1);
	local curlevel2 = LifeAbility:Get_Equip_CurStrengthLevel(Enchange_Item2);

	if tonumber(EquipPoint1) ~= tonumber(EquipPoint2) then			--各种恶心提示
		local theAction1 = EnumAction(Enchange_Item1, "packageitem");
		local leftItemName = theAction1:GetName()

		if tonumber(Equip_Level1) < 40 then
			msg =  string.format("#H仅可将%s#H的强化等级转移至装备等级不足40级的%s#H之上。",leftItemName, g_EquipName[EquipPoint1])
		end

		if tonumber(Equip_Level1) >= 40 then
			msg =  string.format("#H仅可将%s#H的强化等级转移至装备等级达到40级及以上等级的%s#H之上。",leftItemName, g_EquipName[EquipPoint1])
		end

		PushDebugMessage(msg)
		return
	end

	if tonumber(Equip_Level1) < 40 and tonumber(Equip_Level2) >= 40 then
		local theAction1 = EnumAction(Enchange_Item1, "packageitem");
		local leftItemName = theAction1:GetName()
		msg =  string.format("#H仅可将%s#H的强化等级转移至装备等级不足40级的%s#H之上。",leftItemName, g_EquipName[EquipPoint1])
		PushDebugMessage(msg)
		return
	end

	if tonumber(Equip_Level1) >= 40 and tonumber(Equip_Level2) < 40 then
		local theAction1 = EnumAction(Enchange_Item1, "packageitem");
		local leftItemName = theAction1:GetName()
		msg =  string.format("#H仅可将%s#H的强化等级转移至装备等级达到40级及以上等级的%s#H之上。",leftItemName, g_EquipName[EquipPoint1])
		PushDebugMessage(msg)
		return
	end

	if tonumber(curlevel1) <= tonumber(curlevel2) then
		msg =  string.format("#H该装备的强化等级已达到或超过源装备的强化等级：%s#H级，无法接受转移。",curlevel1)
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
		--绑定提示
		local ItemId =tonumber(PlayerPackage:GetItemTableIndex(tonumber(Enchange_Item2)))
		local theAction2 = EnumAction(Enchange_Item2, "packageitem");
		local leftItemName = theAction2:GetName()
		local xpos1,zpos1 = string.find(leftItemName, "重楼")
		if xpos1 ~= nil and zpos1 ~= nil  then
			PushDebugMessage("#{ZBQH_130521_45}")
			return
		end

		msg =  string.format("#cfff263由于将要转移强化等级的#G源装备#cfff263处于绑定状态，成功进行强化转移后，#G目标装备#cfff263将被强制绑定。同时，#G源装备#cfff263的强化等级将被清除，#G目标装备#cfff263的强化等级将被提升至#G%s#cfff263级。#r#G小提示：如果您确定要进行转移，请在关闭本提示后再次点击确定按钮。", curlevel1)
		GameProduceLogin:GameLoginShowSystemInfo(msg)
		g_check = 1;
		return
	end

	if tonumber(curlevel2) > 0 and tonumber(g_check) ~= 1 then
		--等级覆盖提示
		msg =  string.format("#cfff263成功进行强化转移后，#G源装备#cfff263的强化等级将被清除，#G目标装备#cfff263的强化等级将被提升至#G%s#cfff263级。#r#G小提示：如果您确定要进行转移，请在关闭本提示后再次点击确定按钮。", curlevel1)
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
