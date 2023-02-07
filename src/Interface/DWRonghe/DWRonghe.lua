---===================================================
--雕纹系统
--Author：Sunyan
--QQ:857904341
---===================================================
local MAX_OBJ_DISTANCE = 3.0
local g_CaredNpc = -1
local g_DWRonghe_DemandMoney = 50000
local g_DWRonghe_Item = {}
local g_DWRonghe_Object = {}
local g_DWRonghe_GRID_SKIP = 162	-- G163 -> G165

local g_DWRonghe_Action_Type = 5
local g_DWRonghe_RScript_ID = 900014
local g_DWRonghe_RScript_Name = "DoDiaowenAction"

local g_DWRonghe_Frame_UnifiedPosition;

local g_TipsTwice = 1

local g_DWRonghe_ItemID 		= 38001002 --雕纹融合符（绑定）
local g_DWRonghe_Bind_ItemID 	= 38001003 --雕纹融合符（非绑定）

--=========================================================
-- 注册窗口关心的所有事件
--=========================================================
function DWRonghe_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("UPDATE_DWRONGHE")
	this:RegisterEvent("OBJECT_CARED_EVENT")
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")
	this:RegisterEvent("RESUME_ENCHASE_GEM")
	this:RegisterEvent("UNIT_MONEY")
	this:RegisterEvent("MONEYJZ_CHANGE")

	this:RegisterEvent("CONFIRM_DWRONGHE")	-- 确认进行雕纹蚀刻的消息

	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

--=========================================================
-- 载入初始化
--=========================================================
function DWRonghe_OnLoad()
	g_DWRonghe_Item[1] = -1
	g_DWRonghe_Item[2] = -1
	g_DWRonghe_Item[3] = -1
	g_DWRonghe_Object[1] = DWRonghe_Item
	g_DWRonghe_Object[2] = DWRonghe_Item1
	g_DWRonghe_Object[3] = DWRonghe_Item2
	-- 始终可以点击 OK 按钮, 为了方便提示玩家信息
	DWRonghe_OK:Enable()

	g_DWRonghe_Frame_UnifiedPosition=DWRonghe_Frame:GetProperty("UnifiedPosition");

end

--=========================================================
-- 事件处理
--=========================================================
function DWRonghe_OnEvent(event)
	if (event == "UI_COMMAND" and tonumber(arg0) == 20140820) then
		local xx = Get_XParam_INT(0)
		g_CaredNpc = DataPool:GetNPCIDByServerID(xx)
		if g_CaredNpc == -1 then
			PushDebugMessage("server传过来的数据有问题。")
			return
		end
		BeginCareObject_DWRonghe()
		DWRonghe_Clear()
		DWRonghe_UpdateBasic()
		this:Show()
	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if (tonumber(arg0) ~= g_CaredNpc) then
			return
		end
		if ((arg1 == "distance" and tonumber(arg2) > MAX_OBJ_DISTANCE) or arg1=="destroy") then
			DWRonghe_Close()
		end
	elseif (event == "PACKAGE_ITEM_CHANGED" and this:IsVisible()) then
		if (arg0 == nil or -1 == tonumber(arg0)) then
			return
		end
		for i = 1, 3 do
			if g_DWRonghe_Item[i] == tonumber(arg0) then
				DWRonghe_Resume_Equip(i + g_DWRonghe_GRID_SKIP)
				DWRonghe_UpdateBasic()
				break
			end
		end
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 201401111 and this:IsVisible()) then
		DWRonghe_UpdateBasic()
		if arg1 ~= nil then
			DWRonghe_Update(arg1)
			DWRonghe_UpdateBasic()
		end
	elseif (event == "UNIT_MONEY" or event =="MONEYJZ_CHANGE") then
		DWRonghe_UpdateBasic()
	elseif (event == "RESUME_ENCHASE_GEM" and this:IsVisible()) then
		if arg0 ~= nil then
			DWRonghe_Resume_Equip(tonumber(arg0))
			DWRonghe_UpdateBasic()
		end
	elseif (event == "CONFIRM_DWRONGHE") then
		if 1 == tonumber(arg0) then
			DWRonghe_OK_Clicked(1)
		elseif 2 == tonumber(arg0) then
			DWRonghe_OK_Clicked(2)
		end

	elseif (event == "ADJEST_UI_POS" ) then
		DWRonghe_Frame_On_ResetPos()

	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		DWRonghe_Frame_On_ResetPos()
	end
end

--=========================================================
-- 更新基本显示信息
--=========================================================
function DWRonghe_UpdateBasic()
	DWRonghe_CurrentlyMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"))
	DWRonghe_CurrentlyJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"))

	-- 计算所需金钱
	if g_DWRonghe_Item[1] == -1 then
		g_DWRonghe_DemandMoney = 0
	else
		g_DWRonghe_DemandMoney = 50000
	end
	DWRonghe_DemandMoney:SetProperty("MoneyNumber", tostring(g_DWRonghe_DemandMoney))
end

--=========================================================
-- 重置界面
--=========================================================
function DWRonghe_Clear()
	for i = 1, 3 do
		if g_DWRonghe_Item[i] ~= -1 then
			g_DWRonghe_Object[i]:SetActionItem(-1)
			LifeAbility:Lock_Packet_Item(g_DWRonghe_Item[i], 0)
			g_DWRonghe_Item[i] = -1
		end
	end

	DWRonghe_UpdateBasic()
end

--=========================================================
-- 更新界面
--=========================================================
function DWRonghe_Update(itemIndex)
	local i_index = tonumber(itemIndex)
	local itemId = PlayerPackage:GetItemTableIndex(i_index)
	local u_index = -1
	if itemId >= 10100000 and itemId <= 12000000 then
		u_index = 1
	end
	if itemId == 38001002 or itemId == 38001003 then
		u_index = 2
	elseif itemId >= 30110001 and itemId <= 30111600 then
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
			-- 判断物品是否为蚀刻了一个雕纹的装备
			local Icon,IconEx = "",""
			if LifeAbility : Get_Equip_Point(i_index) == 17 then
				_,Icon,IconEx = Lua_GetDWShowMsgEx()
			else
				_,Icon,IconEx = Lua_GetDWShowMsg(SuperTooltips:GetAuthorInfo())
			end
			
			if Icon == "" then
				PushDebugMessage("#{SSXDW_140819_40}")--H请先放入已蚀刻了一个雕纹的装备、雕纹融合符或雕纹。
				return
			end
				
			if IconEx ~= "" and Icon ~= "" then
				PushDebugMessage("#{SSXDW_140819_41}")
				return
			end
		elseif u_index == 2 then
				-- 判断物品是否为雕纹融合符, 如果不是, 直接return
				if PlayerPackage:GetItemTableIndex(i_index) ~= g_DWRonghe_ItemID and PlayerPackage:GetItemTableIndex(i_index) ~= g_DWRonghe_Bind_ItemID then
					PushDebugMessage("#{SSXDW_140819_43}")
					return
				end
				if PlayerPackage:IsLock(i_index) == 1 then
					PushDebugMessage("#{SSXDW_140819_42}")
					return
				end
		elseif u_index == 3 then
			-- 要先放武器
			if g_DWRonghe_Item[1] == -1 then
				PushDebugMessage("#{SSXDW_140819_44}")
				return
			end
			
			-- 判断物品是否为雕纹, 如果不是, 直接return
			if GetDiaowenId(i_index) == -1 then
				PushDebugMessage("#{ZBDW_091105_7}")
				return
			end
			if PlayerPackage:IsLock(i_index) == 1 then
				PushDebugMessage("#{SSXDW_140819_42}")
				return
			end
		else
			-- 不是装备 不是符 不是雕纹 给个提示
			PushDebugMessage("#{SSXDW_140819_40}")
			return
		end

		-- 如果空格内已经有对应物品了, 替换之
		if g_DWRonghe_Item[u_index] ~= -1 then
			LifeAbility:Lock_Packet_Item(g_DWRonghe_Item[u_index], 0)
		end
		g_DWRonghe_Object[u_index]:SetActionItem(theAction:GetID())
		LifeAbility:Lock_Packet_Item(i_index, 1)
		g_DWRonghe_Item[u_index] = i_index
		
		-- 如果是装备替换的话 雕纹摘掉
		if u_index == 1 then
			if g_DWRonghe_Item[3] ~= -1 then
				LifeAbility:Lock_Packet_Item(g_DWRonghe_Item[3], 0)
			end
			g_DWRonghe_Object[3]:SetActionItem(-1)
			g_DWRonghe_Item[3] = -1
		end 
		
	else
		DWRonghe_Clear()
	end
end

--=========================================================
-- 取出窗口内放入的物品
--=========================================================
function DWRonghe_Resume_Equip(nIndex)
	if nIndex <= g_DWRonghe_GRID_SKIP or nIndex > g_DWRonghe_GRID_SKIP + 3 then
		return
	end

	nIndex = nIndex - g_DWRonghe_GRID_SKIP
	if this:IsVisible() then
		if g_DWRonghe_Item[nIndex] ~= -1 then
			g_DWRonghe_Object[nIndex]:SetActionItem(-1)
			LifeAbility:Lock_Packet_Item(g_DWRonghe_Item[nIndex], 0)
			g_DWRonghe_Item[nIndex] = -1
		end
		--取装备的时候 把雕纹也摘了
		if nIndex==1 then
			if g_DWRonghe_Item[3] ~= -1 then
				g_DWRonghe_Object[3]:SetActionItem(-1)
				LifeAbility:Lock_Packet_Item(g_DWRonghe_Item[3], 0)
				g_DWRonghe_Item[3] = -1
			end
		end
	end
	DWRonghe_Check_AllItem()
end

--=========================================================
-- 判断是否所有物品都已放好
-- 只在点击 OK 按钮的时候调用这个函数
--=========================================================
function DWRonghe_Check_AllItem()
	DWRonghe_UpdateBasic()
	for i = 1, 3 do
		if g_DWRonghe_Item[i] == -1 then
			return i
		end
	end
		
	-- 查看融合符和雕纹是否是绑定的
	local isRongheBind	= 0
	local isDiaowenBind	= 0
	if(GetItemBindStatus(g_DWRonghe_Item[2]) == 1) then
		isRongheBind = 1
	end
	if(GetItemBindStatus(g_DWRonghe_Item[3]) == 1) then
		isDiaowenBind = 1
	end

	local equipTableIndex	= PlayerPackage : GetItemTableIndex( g_DWRonghe_Item[1] )
	local isEquipBind	= GetItemBindStatus( g_DWRonghe_Item[1] )

	local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")
	if selfMoney < g_DWRonghe_DemandMoney then
		return 44
	end

	DWRonghe_OK:Enable()
	return 0
end

local EB_BINDED = 1;				-- 已经绑定
--=========================================================
-- 确定执行功能
--=========================================================
function DWRonghe_OK_Clicked(okFlag)
	local ret = DWRonghe_Check_AllItem()
	if ret == 1 then
		PushDebugMessage("#{SSXDW_140819_44}")
		return
	elseif ret == 2 then
		PushDebugMessage("#{SSXDW_140819_43}")
		return
	elseif ret == 3 then
		PushDebugMessage("#{SSXDW_140819_46}")
		return
	elseif ret == 4 then
		PushDebugMessage("#{ZBDW_091105_23}")
		return
	elseif ret == 5 then
		PushDebugMessage("#{SSXDW_140819_44}")
		return
	elseif ret == 6 then
		ShowSystemInfo("CLBD_091211_9");	--不能使用绑定物品对重楼进行雕纹
		return
	elseif ret == 9 then
		PushDebugMessage("#{SSXDW_140819_47}")
		return
	elseif ret == 44 then
		PushDebugMessage("#{GMGameInterface_Script_PlayerMySelf_Info_Money_Not_Enough}")
		return
	end

	if ret == 0 then
		-- 执行雕纹蚀刻功能
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name(g_DWRonghe_RScript_Name)
			Set_XSCRIPT_ScriptID(g_DWRonghe_RScript_ID)
			Set_XSCRIPT_Parameter(0, g_DWRonghe_Action_Type)
			for i = 1, 3 do
				Set_XSCRIPT_Parameter(i, g_DWRonghe_Item[i])
			end
			Set_XSCRIPT_ParamCount(4)
		Send_XSCRIPT()
	end
end

--=========================================================
-- 关闭界面
--=========================================================
function DWRonghe_Close()
	DWRonghe_OnHiden()
	this:Hide()
	return
end

--=========================================================
-- 界面隐藏
--=========================================================
function DWRonghe_OnHiden()
	StopCareObject_DWRonghe()
	DWRonghe_Clear()
	return
end

--=========================================================
-- 开始关心NPC，
-- 在开始关心之前需要先确定这个界面是不是已经有“关心”的NPC，
-- 如果有的话，先取消已经有的“关心”
--=========================================================
function BeginCareObject_DWRonghe()

	this:CareObject(g_CaredNpc, 1, "DWRonghe")
	return
end

--=========================================================
-- 停止对某NPC的关心
--=========================================================
function StopCareObject_DWRonghe()
	this:CareObject(g_CaredNpc, 0, "DWRonghe")
	g_CaredNpc = -1
	return
end

--=========================================================
-- 玩家金钱变化
--=========================================================
function DWRonghe_UserMoneyChanged()
	local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")
	-- 判断金钱够不够
	if selfMoney < g_DWRonghe_DemandMoney then
		return -1
	end
	return 1
end

function DWRonghe_Frame_On_ResetPos()
	DWRonghe_Frame:SetProperty("UnifiedPosition", g_DWRonghe_Frame_UnifiedPosition);
end

