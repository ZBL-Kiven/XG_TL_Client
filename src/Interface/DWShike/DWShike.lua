--雕纹系统
--Author：逍遥子
--QQ:857904341
local MAX_OBJ_DISTANCE = 3.0
local g_CaredNpc = -1
local g_DWSHIKE_DemandMoney = 50000
local g_DWSHIKE_Item = {}
local g_DWSHIKE_Object = {}
local g_DWSHIKE_GRID_SKIP = 97	-- G98 -> G100

local g_DWSHIKE_Action_Type = 1
local g_DWSHIKE_RScript_ID = 900014
local g_DWSHIKE_RScript_Name = "DoDiaowenAction"

local g_DWShike_Frame_UnifiedPosition;

local g_TipsTwice = 1
local g_DWShikeDirectly = 1;

--=========================================================
-- 注册窗口关心的所有事件
--=========================================================
function DWShike_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("UPDATE_DWSHIKE")
	this:RegisterEvent("OBJECT_CARED_EVENT")
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")
	this:RegisterEvent("RESUME_ENCHASE_GEM")
	this:RegisterEvent("UNIT_MONEY")
	this:RegisterEvent("MONEYJZ_CHANGE")

	this:RegisterEvent("CONFIRM_DWSHIKE")	-- 确认进行雕纹蚀刻的消息

	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

--=========================================================
-- 载入初始化
--=========================================================
function DWShike_OnLoad()
	g_DWSHIKE_Item[1] = -1
	g_DWSHIKE_Item[2] = -1
	g_DWSHIKE_Item[3] = -1
	g_DWSHIKE_Object[1] = DWShike_Object
	g_DWSHIKE_Object[2] = DWShike_Object2
	g_DWSHIKE_Object[3] = DWShike_Object3
	-- 始终可以点击 OK 按钮, 为了方便提示玩家信息
	DWShike_OK:Enable()

	g_DWShike_Frame_UnifiedPosition=DWShike_Frame:GetProperty("UnifiedPosition");

end

--=========================================================
-- 事件处理
--=========================================================
function DWShike_OnEvent(event)
	if (event == "UI_COMMAND" and tonumber(arg0) == 2000156) then
		local xx = Get_XParam_INT(0)
		g_CaredNpc = DataPool:GetNPCIDByServerID(xx)
		if g_CaredNpc == -1 then
			PushDebugMessage("server传过来的数据有问题。")
			return
		end
		BeginCareObject_DWShike()
		DWShike_Clear()
		DWShike_UpdateBasic()
		this:Show()
		PushEvent("OPEN_WINDOW","Packet")
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 201401111 and this:IsVisible()) then
		DWShike_UpdateBasic()
		if arg1 ~= nil then
			DWShike_Update(arg1)
			DWShike_UpdateBasic()
		end

	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if (tonumber(arg0) ~= g_CaredNpc) then
			return
		end
		if ((arg1 == "distance" and tonumber(arg2) > MAX_OBJ_DISTANCE) or arg1=="destroy") then
			DWShike_Close()
		end
	elseif (event == "PACKAGE_ITEM_CHANGED" and this:IsVisible()) then
		if (arg0 == nil or -1 == tonumber(arg0)) then
			return
		end
		for i = 1, 3 do
			if g_DWSHIKE_Item[i] == tonumber(arg0) then
				DWShike_Resume_Equip(i + g_DWSHIKE_GRID_SKIP)
				DWShike_UpdateBasic()
				break
			end
		end
	elseif (event == "UPDATE_DWSHIKE") then
		DWShike_UpdateBasic()
		if arg0 ~= nil and arg1 ~= nil then
			DWShike_Update(arg0, arg1)
			DWShike_UpdateBasic()
		end
	elseif (event == "UNIT_MONEY" or event =="MONEYJZ_CHANGE") then
		DWShike_UpdateBasic()
	elseif (event == "RESUME_ENCHASE_GEM" and this:IsVisible()) then
		if arg0 ~= nil then
			DWShike_Resume_Equip(tonumber(arg0))
			DWShike_UpdateBasic()
		end
	elseif (event == "CONFIRM_DWSHIKE") then
		if 1 == tonumber(arg0) then
			DWShike_OK_Clicked(1)
		elseif 2 == tonumber(arg0) then
			DWShike_OK_Clicked(2)
		end

	elseif (event == "ADJEST_UI_POS" ) then
		DWShike_Frame_On_ResetPos()

	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		DWShike_Frame_On_ResetPos()
	end
end

--=========================================================
-- 更新基本显示信息
--=========================================================
function DWShike_UpdateBasic()
	DWShike_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"))
	DWShike_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"))

	-- 计算所需金钱
	if g_DWSHIKE_Item[1] == -1 then
		g_DWSHIKE_DemandMoney = 0
	else
		g_DWSHIKE_DemandMoney = 50000
	end
	DWShike_DemandMoney:SetProperty("MoneyNumber", tostring(g_DWSHIKE_DemandMoney))
end

--=========================================================
-- 重置界面
--=========================================================
function DWShike_Clear()
	for i = 1, 3 do
		if g_DWSHIKE_Item[i] ~= -1 then
			g_DWSHIKE_Object[i]:SetActionItem(-1)
			LifeAbility:Lock_Packet_Item(g_DWSHIKE_Item[i], 0)
			g_DWSHIKE_Item[i] = -1
		end
	end

	DWShike_UpdateBasic()
end
--=========================================================
-- 重置界面
--=========================================================
function DWShike_Clear()
	for i = 1, 3 do
		if g_DWSHIKE_Item[i] ~= -1 then
			g_DWSHIKE_Object[i]:SetActionItem(-1)
			LifeAbility:Lock_Packet_Item(g_DWSHIKE_Item[i], 0)
			g_DWSHIKE_Item[i] = -1
		end
	end

	DWShike_UpdateBasic()
end
function Can_Diaowen(i_index,nType)
	local EquipPoint = LifeAbility:Get_Equip_Point(i_index)
	if EquipPoint == 2 or EquipPoint == 8 then
		return -2
	end
	return 1
end

--=========================================================
-- 更新界面
--=========================================================
function DWShike_Update(itemIndex)
	local i_index = tonumber(itemIndex)
	local itemId = PlayerPackage:GetItemTableIndex(i_index)
	local u_index = -1
	if itemId >= 10100000 and itemId <= 12000000 then
		u_index = 1
	end
	if itemId == 30503149 or  itemId == 30121001 then
		u_index = 2
	end
	if itemId >= 30110001 and itemId <= 30111600 then
		u_index = 3
	end
	local theAction = EnumAction(i_index, "packageitem")

	--add by kaibin 2010-11-26 tt85427
	g_TipsTwice = 1

	if theAction:GetID() ~= 0 then
		-- 判断是否为安全时间
		if (tonumber(DataPool:GetLeftProtectTime()) > 0) then
			PushDebugMessage("#{XZBDW_130730_02}")
			return
		end

		if u_index == 1 then
			-- 判断物品是否已经鉴定(未鉴定的禁止放入)

			-- 判断物品是否为可以雕纹的装备, 如果不是, 直接return
			-- 这里放入装备的时候可能没有放入雕纹, 所以不对装备的等级判断, 放到后面判断
			local EquipPoint = Can_Diaowen(i_index, -1)
			if EquipPoint == -2 then
				PushDebugMessage("#{ZBDW_091105_5}")
				return
			end
		elseif u_index == 2 then
			-- 判断物品是否为雕纹蚀刻符, 如果不是, 直接return
			if PlayerPackage:GetItemTableIndex(i_index) ~= 30503149 and PlayerPackage:GetItemTableIndex(i_index) ~= 30121001 then
				PushDebugMessage("#{ZBDW_091105_6}")
				return
			end
		elseif u_index == 3 then
			-- 判断物品是否为雕纹, 如果不是, 直接return
			if GetDiaowenId(i_index) == -1 then
				PushDebugMessage("#{ZBDW_091105_7}")
				return
			end
		else
			-- 异常情况
			PushDebugMessage("请放入正确的物品。")
			DWShike_Clear()
			return
		end

		-- 雕纹蚀刻不判断装备是否加锁了 - 2009-12-07
		-- 判断物品是否加锁(在这个逻辑之前程序已经判断了)
		if u_index ~= 1 and PlayerPackage:IsLock(i_index) == 1 then
			PushDebugMessage("#{SSXDW_140819_42}")
			return
		end

		-- 如果空格内已经有对应物品了, 替换之
		if g_DWSHIKE_Item[u_index] ~= -1 then
			LifeAbility:Lock_Packet_Item(g_DWSHIKE_Item[u_index], 0)
		end
		g_DWSHIKE_Object[u_index]:SetActionItem(theAction:GetID())
		LifeAbility:Lock_Packet_Item(i_index, 1)
		g_DWSHIKE_Item[u_index] = i_index

		-- 判断所有物品是否都已经放入
		-- DWShike_Check_AllItem()
	else
		DWShike_Clear()
	end
end

--=========================================================
-- 取出窗口内放入的物品
--=========================================================
function DWShike_Resume_Equip(nIndex)
	if nIndex <= g_DWSHIKE_GRID_SKIP or nIndex > g_DWSHIKE_GRID_SKIP + 3 then
		return
	end

	nIndex = nIndex - g_DWSHIKE_GRID_SKIP
	if this:IsVisible() then
		if g_DWSHIKE_Item[nIndex] ~= -1 then
			g_DWSHIKE_Object[nIndex]:SetActionItem(-1)
			LifeAbility:Lock_Packet_Item(g_DWSHIKE_Item[nIndex], 0)
			g_DWSHIKE_Item[nIndex] = -1
		end
	end
	DWShike_Check_AllItem()
end

--=========================================================
-- 判断是否所有物品都已放好
-- 只在点击 OK 按钮的时候调用这个函数
--=========================================================
function DWShike_Check_AllItem()
	DWShike_UpdateBasic()
	for i = 1, 3 do
		if g_DWSHIKE_Item[i] == -1 then
			return i
		end
	end

	-- 查看蚀刻符和雕纹是否是绑定的
	local isShikeBind	= 0
	local isDiaowenBind	= 0
	if(GetItemBindStatus(g_DWSHIKE_Item[2]) == 1) then
		isShikeBind = 1
	end

	if(GetItemBindStatus(g_DWSHIKE_Item[3]) == 1) then
		isDiaowenBind = 1
	end

	local equipTableIndex	= PlayerPackage : GetItemTableIndex( g_DWSHIKE_Item[1] )
	local isEquipBind	= GetItemBindStatus( g_DWSHIKE_Item[1] )

	local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")
	if selfMoney < g_DWSHIKE_DemandMoney then
		return 44
	end

	DWShike_OK:Enable()
	return 0
end

local EB_BINDED = 1;				-- 已经绑定
--=========================================================
-- 确定执行功能
--=========================================================
function DWShike_OK_Clicked(okFlag)
	local ret = DWShike_Check_AllItem()
	if ret == 1 then
		PushDebugMessage("#{ZBDW_091105_9}")
		return
	elseif ret == 2 then
		PushDebugMessage("#{ZBDW_091105_8}")
		return
	elseif ret == 3 then
		PushDebugMessage("#{ZBDW_091105_10}")
		return
	elseif ret == 4 then
		PushDebugMessage("#{ZBDW_091105_23}")
		return
	elseif ret == 5 then
		PushDebugMessage("#{ZBDW_091105_24}")
		return
	elseif ret == 6 then
		ShowSystemInfo("CLBD_091211_9");	--不能使用绑定物品对重楼进行雕纹
		return
	elseif ret == 44 then
		PushDebugMessage("#{GMGameInterface_Script_PlayerMySelf_Info_Money_Not_Enough}")
		return
	elseif ret == 2 then
		DWShike_YuanbaoPay()
		return
	end

	if ret == 0 then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name(g_DWSHIKE_RScript_Name)
			Set_XSCRIPT_ScriptID(g_DWSHIKE_RScript_ID)
			Set_XSCRIPT_Parameter(0, g_DWSHIKE_Action_Type)
			for i = 1, 3 do
				Set_XSCRIPT_Parameter(i, g_DWSHIKE_Item[i])
			end
			Set_XSCRIPT_ParamCount(4)
		Send_XSCRIPT()
	end
end

--=========================================================
-- 元宝购买溶剂
--=========================================================
function DWShike_YuanbaoPay()

	if DWShike_Blank_Queren:GetCheck() == 0 then
		--不提示 自动购买
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("DWShikeBeginPay")
			Set_XSCRIPT_ScriptID(g_DWSHIKE_RScript_ID)
			Set_XSCRIPT_Parameter(0,0)
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
	elseif DWShike_Blank_Queren:GetCheck() == 1 then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("DWShikeBeginPay")
			Set_XSCRIPT_ScriptID(g_DWSHIKE_RScript_ID)
			Set_XSCRIPT_Parameter(0,1)
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
	end
end
function DWShike_Blank_Queren_Clicked()
	if(g_DWShikeDirectly == 0)then
		DWShike_Blank_Queren:SetCheck(0);
		g_DWShikeDirectly = 1;
	else
		DWShike_Blank_Queren:SetCheck(1);
		g_DWShikeDirectly = 0;
	end
end
--=========================================================
-- 关闭界面
--=========================================================
function DWShike_Close()
	this:Hide()
	return
end

--=========================================================
-- 界面隐藏
--=========================================================
function DWShike_OnHiden()
	StopCareObject_DWShike()
	DWShike_Clear()
	return
end

--=========================================================
-- 开始关心NPC，
-- 在开始关心之前需要先确定这个界面是不是已经有“关心”的NPC，
-- 如果有的话，先取消已经有的“关心”
--=========================================================
function BeginCareObject_DWShike()
	this:CareObject(g_CaredNpc, 1, "DWShike")
	return
end

--=========================================================
-- 停止对某NPC的关心
--=========================================================
function StopCareObject_DWShike()
	this:CareObject(g_CaredNpc, 0, "DWShike")
	g_CaredNpc = -1
	return
end

--=========================================================
-- 玩家金钱变化
--=========================================================
function DWShike_UserMoneyChanged()
	local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")
	-- 判断金钱够不够
	if selfMoney < g_DWSHIKE_DemandMoney then
		return -1
	end
	return 1
end

function DWShike_Frame_On_ResetPos()
	DWShike_Frame:SetProperty("UnifiedPosition", g_DWShike_Frame_UnifiedPosition);
end

