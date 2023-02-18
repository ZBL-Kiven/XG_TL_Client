--九星神器外形更换
--[BUILD 2019-6-15 18:41:48 XYZ QQ857904341]
local g_SuperWeapon9_Change_WeaponSlot;
local g_SuperWeapon9_Change_WeaponIndex = -1;

local g_SuperWeapon9_Change_CashCost;
local g_SuperWeapon9_Change_PlayerCashJiaoZi;
local g_SuperWeapon9_Change_PlayerCash;

local g_SuperWeapon9_Change_Fram_UnifiedPosition;

local MAX_OBJ_DISTANCE = 3.0;
local g_ObjCared = -1;
local g_EquipData = ""

function SuperWeapon9_Change_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("SUPERWEAPON9_WGCHANGE");
	this:RegisterEvent("SUPERWEAPON9_DRAGEND");--挪出
	this:RegisterEvent("OBJECT_CARED_EVENT",false);
	this:RegisterEvent("ADJEST_UI_POS",false);		--	
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false);	--	窗口大小变换
	this:RegisterEvent("UNIT_MONEY",false);
	this:RegisterEvent("MONEYJZ_CHANGE",false);
	this:RegisterEvent("REFRESH_EQUIP",false);
end

function SuperWeapon9_Change_OnLoad()
	g_SuperWeapon9_Change_CashCost = SuperWeapon9_Change_DemandMoney;
	g_SuperWeapon9_Change_PlayerCashJiaoZi = SuperWeapon9_Change_SelfJiaozi;
	g_SuperWeapon9_Change_PlayerCash = SuperWeapon9_Change_SelfMoney;
	g_SuperWeapon9_Change_WeaponSlot = SuperWeapon9_Change_Object;
	g_SuperWeapon9_Change_Fram_UnifiedPosition = SuperWeapon9_Change_Frame:GetProperty("UnifiedPosition");
end

function SuperWeapon9_Change_OnEvent(event)
	if event == "UI_COMMAND" and tonumber(arg0) == 7020065 then
		local bOpen=Get_XParam_INT(0);
		if bOpen==1 then
			local TargetServerID = Get_XParam_INT(1);
			g_ObjCared = DataPool:GetNPCIDByServerID(TargetServerID);
			if g_ObjCared==-1 then
				return
			end
			this:CareObject(g_ObjCared, 1, "SuperWeapon9_Change");
			SuperWeapon9_Change_UpdataMoney()
			--SuperWeapon9_Change_Choice:SetText("#{JXSQ_170810_160}")
			--SuperWeapon9_Change_Choice:Disable()
			--SuperWeapon9_Change_Choice_Pic:Show()
			SuperWeapon9_Change_Fitting_FakeObject:SetFakeObject("")
			this:Show()
		end
	end

	if event == "UI_COMMAND" and tonumber(arg0) ==  201107281 and this:IsVisible() then
		if arg1 ~= nil then
			local nIndex = tonumber(arg1)
			SuperWeapon9_Change_UpDataFrame(nIndex)
		end
	elseif event == "SUPERWEAPON9_DRAGEND" then
		if arg0 ~= nil and tonumber(arg0)==19 then
			SuperWeapon9_Change_ResetSlot()
		end
	elseif event == "REFRESH_EQUIP" then
		SuperWeapon9_Change_ResetSlot()
	end

	if event == "OBJECT_CARED_EVENT" then
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2) > MAX_OBJ_DISTANCE or arg1=="destroy") then
			SuperWeapon9_Change_CancleEvent()
		end
	end

	if event == "ADJEST_UI_POS" then
		SuperWeapon9_Change_ResetWindowPos();
	elseif event == "VIEW_RESOLUTION_CHANGED" then
		SuperWeapon9_Change_ResetWindowPos()
	elseif (event == "UNIT_MONEY" or event == "MONEYJZ_CHANGE") and this:IsVisible() then
		SuperWeapon9_Change_UpdataMoney();
	end
end

function SuperWeapon9_Change_ResetWindowPos()
	SuperWeapon9_Change_Frame:SetProperty("UnifiedPosition", g_SuperWeapon9_Change_Fram_UnifiedPosition);
end

function SuperWeapon9_Change_ResetSlot()
	if g_SuperWeapon9_Change_WeaponIndex > -1 then
		LifeAbility:Lock_Packet_Item(g_SuperWeapon9_Change_WeaponIndex, 0);
		g_SuperWeapon9_Change_WeaponSlot:SetActionItem(-1);
		g_SuperWeapon9_Change_WeaponIndex = -1;
	end
	
	g_SuperWeapon9_Change_CashCost:SetProperty("MoneyNumber", 0);
	--SuperWeapon9_Change_Choice:SetText("#{JXSQ_170810_160}")
	--SuperWeapon9_Change_Choice:Disable()
	--SuperWeapon9_Change_Choice_Pic:Show()
	SuperWeapon9_Change_Fitting_FakeObject:SetFakeObject("")

end

function SuperWeapon9_Change_OKEvent()
	if g_SuperWeapon9_Change_WeaponIndex < 0 then
		PushDebugMessage("#{JXSQ_170810_158}")
		return
	end
	-- 检测安全时间
	if tonumber(DataPool:GetLeftProtectTime()) > 0 then
		PushDebugMessage("#{OR_PILFER_LOCK_FLAG}")
		return
	end
	if SuperWeapon9_Change_EquipChange(g_SuperWeapon9_Change_WeaponIndex)==0 then
		return
	end
	-- local sSel,iSel =  --SuperWeapon9_Change_Choice:GetCurrentSelect()
	local nItemID = PlayerPackage:GetItemTableIndex(g_SuperWeapon9_Change_WeaponIndex)
	local n9WG,needMoney = Lua_GetSuperWeapon9WG(g_SuperWeapon9_Change_WeaponIndex)
	local nPlayerCashMoney = Player:GetData("MONEY");
	local nPlayerCashJiaoZi = Player:GetData("MONEY_JZ");
	if (nPlayerCashMoney+nPlayerCashJiaoZi) < needMoney then
		PushDebugMessage("金钱不足，无法升级神器")
		return
	end
	-- local iSelID=0
	-- if iSel==1 then
		-- iSelID=n9WG
	-- else
		-- PushDebugMessage("#{JXSQ_170810_162}")
		-- return
	-- end
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("DoSuperWeapon9Up")
		Set_XSCRIPT_ScriptID(001085)
		Set_XSCRIPT_Parameter(0, g_SuperWeapon9_Change_WeaponIndex)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()

	SuperWeapon9_Change_ResetSlot()
	SuperWeapon9_Change_UpdataMoney()
end

function SuperWeapon9_Change_CancleEvent()
	SuperWeapon9_Change_ResetSlot()

	this:CareObject(g_ObjCared, 0, "SuperWeapon9_Change");
	g_ObjCared = -1;

	this:Hide();
end

function SuperWeapon9_Change_UpdataMoney()

	if g_SuperWeapon9_Change_WeaponIndex ~= -1 then
		local _,_,_,_,_,_,nMoneyCost = PlayerPackage:GetSuperWeapon9WG(g_SuperWeapon9_Change_WeaponIndex,"tbl")
		if nMoneyCost==nil then
			return
		end
		g_SuperWeapon9_Change_CashCost:SetProperty("MoneyNumber", nMoneyCost);
	end
	--	玩家身上的钱
	local nPlayerCashMoney = Player:GetData("MONEY");
	local nPlayerCashJiaoZi = Player:GetData("MONEY_JZ");
	g_SuperWeapon9_Change_PlayerCashJiaoZi:SetProperty("MoneyNumber", nPlayerCashJiaoZi);
	g_SuperWeapon9_Change_PlayerCash:SetProperty("MoneyNumber", nPlayerCashMoney);
end

function SuperWeapon9_Change_EquipChange(nIndex)
	local theAction = EnumAction(nIndex, "packageitem");
	if theAction:GetID() ~= 0 then
		local EquipPoint = LifeAbility:Get_Equip_Point(nIndex)
		if EquipPoint~=0 then
			PushDebugMessage("#{JXSQ_170810_158}")
			return 0
		end
		local nEquipLevel = LifeAbility:Get_Equip_Level(nIndex);
		if nEquipLevel ~= 102 then
			PushDebugMessage("#{JXSQ_170810_158}")
			return 0
		end
	else
		PushDebugMessage("#{JXSQ_170810_158}")
		return 0
	end
	return 1
end
function SuperWeapon9_Change_UpDataFrame(nIndex)
	if nIndex < 0 then
		return
	end
	g_EquipData = SuperTooltips:GetAuthorInfo()
	local theAction = EnumAction(nIndex, "packageitem");
	if theAction:GetID() ~= 0 then
		if SuperWeapon9_Change_EquipChange(nIndex)==0 then
			return
		end
		local nItemID = PlayerPackage:GetItemTableIndex(nIndex)
		local n9WG,needMoney = Lua_GetSuperWeapon9WG(nIndex)
		-- if n9WG == nil or n9WG == -1 then
			-- PushDebugMessage("#{JXSQ_170810_158}")
			-- return
		-- end
		g_SuperWeapon9_Change_CashCost:SetProperty("MoneyNumber", needMoney);
		if g_SuperWeapon9_Change_WeaponIndex > -1 then
			LifeAbility:Lock_Packet_Item(g_SuperWeapon9_Change_WeaponIndex, 0);
		end
		g_SuperWeapon9_Change_WeaponSlot:SetActionItem(theAction:GetID());
		g_SuperWeapon9_Change_WeaponIndex = nIndex;
		LifeAbility:Lock_Packet_Item(g_SuperWeapon9_Change_WeaponIndex, 1);
		--更新 TLBB_ComboList
		local nCurWGID = LifeAbility:Get_Equip_VisualID(nIndex)
		--SuperWeapon9_Change_Choice:Enable()
		--SuperWeapon9_Change_Choice:SetText("#{JXSQ_170810_160}")
		--SuperWeapon9_Change_Choice:ResetList()

--		--SuperWeapon9_Change_Choice:AddTextItem("sel", 0)
		--SuperWeapon9_Change_Choice:AddTextItem(str9WG, 1)
--		if nCurWGID==n9ID then
--			--SuperWeapon9_Change_Choice:AddTextItem(str5WG, 1)
--			--SuperWeapon9_Change_Choice:AddTextItem(str8WG, 2)
--		elseif nCurWGID==n8ID then
--			--SuperWeapon9_Change_Choice:AddTextItem(str5WG, 1)
--			--SuperWeapon9_Change_Choice:AddTextItem(str9WG, 3)
--		elseif nCurWGID==n5ID then
--			--SuperWeapon9_Change_Choice:AddTextItem(str8WG, 2)
--			--SuperWeapon9_Change_Choice:AddTextItem(str9WG, 3)
--		else
--		end
--		--SuperWeapon9_Change_Choice:SetCurrentSelect(-1);
		--SuperWeapon9_Change_Choice_Pic:Hide()
		--当前外形 
		SuperWeapon9_Change_Fitting_FakeObject:SetFakeObject("");	
		SuperWeapon9_Change_Fitting_FakeObject:SetFakeObject("EquipChange_Player");	
		--让人穿上
		LifeAbility : Wear_Equip_VisualID(g_SuperWeapon9_Change_WeaponIndex,n9WG)
	end
end

function SuperWeapon9_Change_SelChanged()
	if g_SuperWeapon9_Change_WeaponIndex==-1 then
		return
	end
	-- local sSel,iSel =  --SuperWeapon9_Change_Choice:GetCurrentSelect()
	local nItemID = PlayerPackage:GetItemTableIndex(g_SuperWeapon9_Change_WeaponIndex)
	local n9WG,needMoney = Lua_GetSuperWeapon9WG(g_SuperWeapon9_Change_WeaponIndex)
	if n9ID==nil or n9ID==-1 then
		return
	end
	local iSelID=0
	if iSel==1 then
		iSelID=n9WG
	end
	if iSelID==0 then
		return
	end
	--当前外形
	SuperWeapon9_Change_Fitting_FakeObject:SetFakeObject("");	
	SuperWeapon9_Change_Fitting_FakeObject:SetFakeObject("EquipChange_Player");	
	--让人穿上
	LifeAbility : Wear_Equip_VisualID(g_SuperWeapon9_Change_WeaponIndex, iSelID)
end

function Lua_GetSuperWeapon9WG(nIndex)
	local n9WG,needMoney = -1,-1,-1,-1
	local nVisualID = LifeAbility:Get_Equip_VisualID(nIndex);
	if nVisualID ~= nil and nVisualID > 0 then
		n9WG = nVisualID
		needMoney = 200000
	end
	return n9WG,needMoney
end

function SuperWeapon9_Change_Fitting_TurnLeft(start)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		--向左旋转开始
		if(start == 1) then
			SuperWeapon9_Change_Fitting_FakeObject:RotateBegin(-0.3);
		--向左旋转结束
		else
			SuperWeapon9_Change_Fitting_FakeObject:RotateEnd();
		end
	end
end

function SuperWeapon9_Change_Fitting_TurnRight(start)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		--向右旋转开始
		if(start == 1) then
			SuperWeapon9_Change_Fitting_FakeObject:RotateBegin(0.3);
		--向右旋转结束
		else
			SuperWeapon9_Change_Fitting_FakeObject:RotateEnd();
		end
	end
end
