-- 移植 装备雕文转移

local Divert_Item1 = -1;
local Divert_Item2 = -1;
local g_Object = -1;
local g_check = -1;--是否二次确认

local EB_FREE_BIND = 0;				-- 无绑定限制
local EB_BINDED = 1;				-- 已经绑定
local	EB_GETUP_BIND =2			-- 拾取绑定
local	EB_EQUIP_BIND =3			-- 装备绑定

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
		if tonumber(arg0) == 20141216 then	--打开界面
			local type = Get_XParam_INT(0);
			if tonumber(type) == 1 then
				--打开窗口
				local targetid = Get_XParam_INT(1);
				local objCared = DataPool : GetNPCIDByServerID(targetid);
				if tonumber(objCared)==nil or  tonumber(objCared)== -1 then
					PushDebugMessage("server传过来的数据有问题。");
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
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			g_Object = -1;
			this:CareObject(tonumber(g_Object), 0, "EquipDWDivert");
			EquipDWDivert_OnHiden()
		end
	elseif  ( event == "EQUIP_DW_DIVERT" and this:IsVisible()) then
		--更新窗口上的装备
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
		if arg0 == "G167" then		--移除左边,要连同右边一起移除
			EquipDWDivert_Clear(0)
		elseif arg0 == "G168" then		--移除右边,不需要理会左边
			EquipDWDivert_Clear(2)
		end
	elseif (event == "RESUME_ENCHASE_GEM" and this:IsVisible()) then
		if arg0 == "167" then		--移除左边,要连同右边一起移除
			EquipDWDivert_Clear(0)
		elseif arg0 == "168" then		--移除右边,不需要理会左边
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

	--源装备口, 因为提示不一样,所以要和目标装备口分开判断
	--判断电话密保和二级密码保护
	if CheckPhoneMibaoAndMinorPassword() ~= 1 then
		return
	end
	-- -- 判断是否为安全时间
	-- if (tonumber(DataPool:GetLeftProtectTime()) > 0) then
	-- 	PushDebugMessage("#{ZYXT_120528_16}")
	-- 	return
	-- end
	
	local i_index = tonumber(Item_index)
	local theAction = EnumAction(i_index, "packageitem");
	local msg = ""

	local EquipPoint = LifeAbility : Get_Equip_Point(i_index)
	if EquipPoint == -1 then	--如果不是装备,代码里已经有返回的错误信息
		return
	end
	
	if EquipPoint == 8 or EquipPoint == 9 or EquipPoint == 10 or EquipPoint == 16 then
		PushDebugMessage("#{DWZY_141216_13}")	--无法进行强化转移
		return
	end
	
	if tonumber(boxpos) == 0 then
		-- 判断左边的
		
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
		--判断右边的
		
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
	
		-- 移植特写 怀旧不允许50级以下的神器暗器上雕文
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
		--右键点击背包的物品
		if tonumber(Divert_Item1) >= 0 then
			--左边有了,无条件放右边
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
			-- 移植特写 怀旧不允许50级以下的神器暗器上雕文
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
			--左边没有,无条件放左边
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
		--刷新消耗
		local msg1,msg2= LifeAbility:GetEquipDiaowen_Name(Divert_Item1)
		-- if msg1~="" and msg2~=""then
		-- 	local dwId,dwlevel = LifeAbility:GetEquitDiaowenID(Divert_Item1)
		-- 	local dwIdEx,dwlevelEx = LifeAbility:GetEquitDiaowenIDEx(Divert_Item1)
		-- 	local msg = "#{SSXDW_140819_09}："..msg1.."·"..msg2.."("..dwlevel.."#{SSXDW_140819_67}·"..dwlevelEx.."#{SSXDW_140819_67})"
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

	--源装备口, 因为提示不一样,所以要和目标装备口分开判断
	--判断电话密保和二级密码保护
	if CheckPhoneMibaoAndMinorPassword() ~= 1 then
		return
	end
	-- -- 判断是否为安全时间
	-- if (tonumber(DataPool:GetLeftProtectTime()) > 0) then
	-- 	PushDebugMessage("#{ZYXT_120528_16}")
	-- 	return
	-- end

	if tonumber(Divert_Item1) < 0 then
		PushDebugMessage("#{DWZY_141216_19}")
		return
	end

	local EquipPoint1 = LifeAbility : Get_Equip_Point(Divert_Item1)
	if EquipPoint1 == -1 then	--如果不是装备,代码里已经有返回的错误信息
		return
	end
	if EquipPoint1 == 8 or EquipPoint1 == 9 or EquipPoint1 == 10 or EquipPoint1 == 16 then
			PushDebugMessage("#{DWZY_141216_30}")	--不是装备
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
		if EquipPoint2 == -1 then	--如果不是装备,代码里已经有返回的错误信息
			return
		end
	if EquipPoint2 == 8 or EquipPoint2 == 9 or EquipPoint2 == 10 or EquipPoint2 > 21 then
			PushDebugMessage("#{DWZY_141216_34}")	--不是装备 和上边的提示不一样
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

	-- 移植特写 怀旧不允许50级以下的神器暗器上雕文
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
		--绑定提示
		if IsUnbindChongLouEquip(PlayerPackage:GetItemTableIndex(tonumber(Divert_Item2))) ~= 1 then
			--非绑定重楼以外的非绑定装备,需要弹出二次确认	
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
		Set_XSCRIPT_Parameter(2,0);--2015 VIP随身移功能 By YuanPeiLong
		Set_XSCRIPT_ParamCount(3);--2015 VIP随身移功能 By YuanPeiLong
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