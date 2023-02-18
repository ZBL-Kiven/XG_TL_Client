--*********************************************
--珍兽套装拆解界面
--*********************************************
local PetEquipSuitDepartName = "PetEquipSuitDepart"
local g_PetEquipItemPos  = -1
local g_PetEquipItemID	 = -1
local g_ObjCareID		 = -1
local g_ServerCareID	 = -1
local g_ProductNeedMoney =  0
local MAX_OBJ_DISTANCE 	 = 3.0;
local g_PetEquipDepartiIndex = 19831205
local g_PetEquipFunCtrl  = -1	--功能控制
local g_PetlastItem			 = -1 --标记确认按钮状态 by cys
local g_PetEquipSuitDepart_State = 1--默认选中状态为1
local g_check = -1
local g_PetEquipSuitDepart_Frame_UnifiedPosition;
local g_PetEquipSuitIDCount = 50
local g_PetEquipSuitDepartID = {
	39990000,
	39990005,
	39990010,
	39990015,
	39990020,
	39990025,
	39990030,
	39990035,
	39990040,
	39990162,
	39991000,
	39991005,
	39991010,
	39991015,
	39991020,
	39991025,
	39991030,
	39991035,
	39991040,
	39991162,
	39992000,
	39992005,
	39992010,
	39992015,
	39992020,
	39992025,
	39992030,
	39992035,
	39992040,
	39992162,
	39993000,
	39993005,
	39993010,
	39993015,
	39993020,
	39993025,
	39993030,
	39993035,
	39993040,
	39993162,
	39994000,
	39994005,
	39994010,
	39994015,
	39994020,
	39994025,
	39994030,
	39994035,
	39994040,
	39994162}

--**********************************************
--事件注册
--**********************************************
function PetEquipSuitDepart_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("RESUME_ENCHASE_GEM")
	this:RegisterEvent("OBJECT_CARED_EVENT",false)
	this:RegisterEvent("UPDATE_PETEQUIP_DEPART") --新建一个这样的事件
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")
	--this:RegisterEvent("UNIT_MONEY")
	--this:RegisterEvent("MONEYJZ_CHANGE")
	this:RegisterEvent("NEW_DEBUGMESSAGE")
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("PET_EQUIP_DEPART_CANCEL")  --珍兽装备分解取消 by cys
end


--**********************************************
--
--**********************************************
function PetEquipSuitDepart_OnLoad()
	g_PetEquipSuitDepart_Frame_UnifiedPosition=PetEquipSuitDepart_Frame:GetProperty("UnifiedPosition");
end


--**********************************************
--事件响应
--**********************************************
function PetEquipSuitDepart_OnEvent( event )
	if (event == "UI_COMMAND" and tonumber(arg0) == g_PetEquipDepartiIndex) then
		PetEquipSuitDepart_UiCommand()
	elseif (event == "RESUME_ENCHASE_GEM") then
		PetEquipSuitDepart_Resume_Equip(1)
	elseif (event == "OBJECT_CARED_EVENT") then
		PetEquipSuitDepart_CareEvent(arg0,arg1,arg2)
	elseif ( event=="UI_COMMAND" and tonumber(arg0) == 201107281 and this:IsVisible()) then
		PetEquipSuitDepart_Update(arg1)
	elseif (event == "PACKAGE_ITEM_CHANGED") then
		PetEquipSuitDepart_PackageItemChange(arg0)
	--elseif (event == "MONEYJZ_CHANGE") then
	--	PetEquipSuitDepart_JZMChange()
	--elseif (event == "UNIT_MONEY") then
	--	PetEquipSuitDepart_UnitMoney()
	elseif (event == "ADJEST_UI_POS" ) then
		PetEquipSuitDepart_Frame_On_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		PetEquipSuitDepart_Frame_On_ResetPos()
	elseif (event == "PET_EQUIP_DEPART_CANCEL")then
		PetEquipSuitDepart_Clear()
	end
end


--**********************************************
--确定按钮
--**********************************************
function PetEquipSuitDepart_Buttons_Clicked()
	--是否旧宠物装备正常放入
	if (g_PetEquipItemPos == -1) then
		return
	end

	--放入的旧装备的Table中的ID
	if (g_PetEquipItemID == -1) then
		return
	end

	--判断物品是否加锁和足够在服务器端判断
	if (PlayerPackage:IsLock(g_PetEquipItemPos) == 1) then
		PushDebugMessage("#{Item_Locked}")
		return
	end
	
	--====================================================================
	--by cys
	--贵重珍兽套装与拆解申请限制
	--修改原有的逻辑，重新整理
--	local Equip_Level = LifeAbility : Get_PetEquip_Level(g_PetEquipItemPos);
--	if Equip_Level ~= nil and Equip_Level >= 95 and g_PetEquipFunCtrl~=2 then
--		if g_PetEquipFunCtrl==0 then
--			PushDebugMessage("#{ZSCJ_101208_03}")
--		elseif g_PetEquipFunCtrl==1 then
--			PushDebugMessage("#{ZSCJ_101208_04}")
--		elseif g_PetEquipFunCtrl==3 then
--			PushDebugMessage("#{ZSCJ_101208_03}")
--		end
--		PetEquipSuitDepart_Clear()
--		return
--	end
	
	-- if g_PetEquipSuitDepart_State ~= 1 then
		--直接拆解
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("OnPetEquipSuitDepart")
			Set_XSCRIPT_ScriptID(800109)
			Set_XSCRIPT_Parameter(0,g_PetEquipItemPos)
			Set_XSCRIPT_Parameter(1,g_ServerCareID)
			Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT()
	-- else
		-- 二次确认
		-- local itemName = LuaFnGetItemNameEx(g_PetEquipItemPos)
		-- local strText = string.format("#{ZSCJ_101208_13}%s#{ZSCJ_101208_14}%s#{ZSCJ_101208_15}",itemName,itemName)
		-- if g_check ~= 1 then
			-- GameProduceLogin:GameLoginShowSystemInfo(strText)
			-- g_check = 1;
			-- return
		-- end
		-- g_check = -1;
		-- Clear_XSCRIPT()
			-- Set_XSCRIPT_Function_Name("OnPetEquipSuitDepart")
			-- Set_XSCRIPT_ScriptID(800109)
			-- Set_XSCRIPT_Parameter(0,g_PetEquipItemPos)
			-- Set_XSCRIPT_Parameter(1,g_ServerCareID)
			-- Set_XSCRIPT_ParamCount(2)
		-- Send_XSCRIPT()
	-- end
	
end


--*************************************************
--重置界面
--*************************************************
function PetEquipSuitDepart_Clear()
	if (g_PetEquipItemPos ~= -1) then
		LifeAbility : Lock_Packet_Item(g_PetEquipItemPos,0);
	end

	PetEquipSuitDepart_OK:Disable()
	PetEquipSuitDepart_Object:SetActionItem(-1)
	PetEquipSuitDepart_Explain_Text1:SetText("#G0%")
	PetEquipSuitDepart_Explain_Text3:SetText("#G0")
	--PetEquipSuitDepart_Demand_Jiaozi:SetProperty("MoneyNumber", "")

	g_PetEquipItemPos  = -1
	g_PetEquipItemID   = -1
	g_ProductNeedMoney = 0
	g_PetlastItem			 = -1
end


--*************************************************
--处理UI_COMMAND逻辑
--*************************************************
function PetEquipSuitDepart_UiCommand()
	PetEquipSuitDepart_Clear()

	--是否过了安全时间....
	if( tonumber(DataPool:GetLeftProtectTime()) >0 ) then
		PushDebugMessage("#{OR_PILFER_LOCK_FLAG}")
		return
	end

	--关心当前对话的NPC
	local targetId = Get_XParam_INT(0)
	g_ServerCareID = targetId
	g_ObjCareID = DataPool:GetNPCIDByServerID(targetId);
	if (g_ObjCareID == -1) then
		PushDebugMessage("server传过来的数据有问题。");
		return
	end

	--获取是那个分支功能的控制符
	--1 为珍兽装备升星功能
	local parm2 = Get_XParam_INT(1)
	if (parm2 == -100) then
		PetEquipSuitDepart_AutoAdd()
		return
	end
	
	g_PetEquipFunCtrl = parm2
	PetEquipSuitDepart_BeginCareObject()
	PetEquipSuitDepart_Clear()
	-- PetEquipSuitDepart_Queren:SetCheck(g_PetEquipSuitDepart_State)
	this:Show();	
end

--*************************************************
--更换确认选中状态
--*************************************************
function PetEquipSuitDepart_QuerenClick()
	if g_PetEquipSuitDepart_State == 1 then
		g_PetEquipSuitDepart_State = 0
	else
		g_PetEquipSuitDepart_State = 1
	end
end

--*************************************************
--处理RESUME_ENCHASE_GEM逻辑
--*************************************************
function PetEquipSuitDepart_Resume_Equip(Index)
	if (Index ~= 1) then
		return
	end

	LifeAbility:Lock_Packet_Item(g_PetEquipItemPos, 0)
	PetEquipSuitDepart_Object:SetActionItem(-1)
	g_PetEquipItemPos=-1
	PetEquipSuitDepart_Clear()
	--PetEquipSuitDepart_Demand_Jiaozi:SetProperty("MoneyNumber", "")
	PetEquipSuitDepart_OK:Disable()
	--PetEquipSuitDepart_AutoAdd()	
end

--*************************************************
--处理OBJECT_CARED_EVENT逻辑
--*************************************************
function PetEquipSuitDepart_CareEvent(arg0,arg1,arg2)
	local ObjCaredID = tonumber(arg0)
	if( ObjCaredID ~= g_ObjCareID) then
		return
	end

	local ObjDistance = tonumber(arg2)
	if( (arg1 == "distance" and ObjDistance>MAX_OBJ_DISTANCE) or arg1=="destroy") then
		PetEquipSuitDepart_Close()
	end
end

--*************************************************
--处理UPDATE_PETEQUIP_UP逻辑 界面更新
--*************************************************
function PetEquipSuitDepart_Update(pos_packet)
	if (pos_packet == nil) then
		return
	end

	local BagPos = tonumber(pos_packet)
	--是否加锁....
	if (PlayerPackage:IsLock(BagPos) == 1) then
		PushDebugMessage("#{Item_Locked}")
		return
	end

	--更新生成物品的Action
	local ItemID = PlayerPackage:GetItemTableIndex(BagPos)
	--通过表获取生成材料ID、材料数目、材料名称、升级几率、需要金钱数目、
	local _,_,_,_,_,_,_,nMaterialNum,nPercent = Lua_EnumPetEquip(ItemID)
	if (0 == nMaterialNum) then
		PushDebugMessage("#{ZSZBSJ_090706_08}")
		return
	end

	--更新需求物品格的Action....
	local theAction = EnumAction(BagPos, "packageitem");
	if (theAction:GetID() == 0) then
		return
	end

	if (g_PetEquipItemPos ~= -1) then
		LifeAbility:Lock_Packet_Item(g_PetEquipItemPos, 0)
	end

	LifeAbility:Lock_Packet_Item(BagPos, 1)
	PetEquipSuitDepart_Object:SetActionItem(theAction:GetID())

	g_PetEquipItemPos=BagPos


	g_PetEquipItemID	= ItemID
	g_ProductNeedMoney  = 0
	PetEquipSuitDepart_Explain_Text1:SetText("#G"..tostring(nPercent).."%")
	PetEquipSuitDepart_Explain_Text3:SetText("#G"..tostring(nMaterialNum))

	PetEquipSuitDepart_OK:Enable()
end


--*************************************************
--处理PACKAGE_ITEM_CHANGED逻辑
--*************************************************
function PetEquipSuitDepart_PackageItemChange(arg0)

	g_PetlastItem = -1
	
	if (this:IsVisible() == 0) then
		return
	end

	local NumArg0 = tonumber(arg0)
	if (arg0~= nil and -1 == NumArg0) then
		return
	end

	if (g_PetEquipItemPos == NumArg0) then
		PetEquipSuitDepart_Resume_Equip(1)
	end
end

--*************************************************
--处理UNIT_MONEY逻辑
--*************************************************
--function PetEquipSuitDepart_UnitMoney()
--	PetEquipSuitDepart_Currently_Money:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
--end

--*************************************************
--处理MONEYJZ_CHANGE逻辑
--*************************************************
--function PetEquipSuitDepart_JZMChange()
--	PetEquipSuitDepart_Currently_Jiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
--end

--*************************************************
--开始关心NPC，就是确认玩家当前操作的NPC，如果离NPC
--太远就会关闭窗口在开始关心之前需要先确定这个界面
--是不是已经有“关心”的NPC，如果有的话，先取消已经
--有的“关心”
--*************************************************
function PetEquipSuitDepart_BeginCareObject()
	this:CareObject(g_ObjCareID, 1, "PetEquipSuitDepart");
end


--*************************************************
--停止对某NPC的关心
--*************************************************
function PetEquipSuitDepart_StopCareObject()
	this:CareObject(g_ObjCareID, 0, "PetEquipSuitDepart");
end

--*************************************************
--关闭界面
--*************************************************
function PetEquipSuitDepart_Close()
	this:Hide()
	PetEquipSuitDepart_StopCareObject()
	PetEquipSuitDepart_Clear()
end

function PetEquipSuitDepart_OnHiden()
	PetEquipSuitDepart_Close()
end

function PetEquipSuitDepart_Frame_On_ResetPos()
	PetEquipSuitDepart_Frame:SetProperty("UnifiedPosition", g_PetEquipSuitDepart_Frame_UnifiedPosition);
end

function PetEquipSuitDepart_GetAvailablePetSuitID()
	for i=1, g_PetEquipSuitIDCount do
		local itemIndex = g_PetEquipSuitDepartID[i]
		local itemPos, BindState = PlayerPackage:FindFirstBindedItemIdxByIDTable(tonumber(itemIndex))
		if itemPos >= 0 then
			return itemPos
		end
	end
	
	return -1
end

function PetEquipSuitDepart_GetAvailablePetSuitIDWithBind()
	for i=1, g_PetEquipSuitIDCount do
		local itemIndex = g_PetEquipSuitDepartID[i]
		local itemPos, BindState = PlayerPackage:FindFirstBindedItemIdxByIDTable(tonumber(itemIndex))
		if itemPos >= 0 and BindState == 1 then
			return itemPos
		end
	end
	
	return -1
end

--*************************************************
--自动添加套装
--*************************************************
function PetEquipSuitDepart_AutoAdd()
	local itemPos = PetEquipSuitDepart_GetAvailablePetSuitIDWithBind()
	if itemPos ~= -1 then
		PetEquipSuitDepart_Update(itemPos)
	elseif itemPos == -1 then
		itemPos = PetEquipSuitDepart_GetAvailablePetSuitID()
		if itemPos ~= -1 then
			PetEquipSuitDepart_Update(itemPos)
		end
	end
end