local MAX_OBJ_DISTANCE = 3.0

local g_GemTableIndex = -1

local g_NeedItemPos = -1
local g_NeedItemID = -1
local g_NeedItemID2 = -1

local g_NeedMoney = 0

local g_NotifyBind = 1

local g_ActionButton_Gem
local g_ActionButton_GemNew

local ObjCaredID = -1

local npcObjId = -1

local g_GemMelting_Frame_UnifiedPosition

local g_DummyGemLayed = 2
local g_DummyNewGem = 3

function GemMelting_PreLoad()

	this:RegisterEvent("UPDATE_GEMMELTING")
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("OBJECT_CARED_EVENT")
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")
	this:RegisterEvent("UNIT_MONEY")
	this:RegisterEvent("RESUME_ENCHASE_GEM")
	this:RegisterEvent("MONEYJZ_CHANGE")
	
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	
end

function GemMelting_OnLoad()

	g_ActionButton_Gem = GemMelting_GemItem1
	g_ActionButton_GemNew = GemMelting_ProductItem
	g_GemMelting_Frame_UnifiedPosition = GemMelting_Frame:GetProperty("UnifiedPosition")

end

function GemMelting_OnEvent(event)

	if event == "UI_COMMAND" and tonumber(arg0) == 112237 then

		npcObjId = tonumber(Variable:GetVariable("GemNPCObjId"))
		Variable:SetVariable("GemNPCObjId", "", 1)
		if(npcObjId == nil) then
			npcObjId = Get_XParam_INT( 0 )
		end
		
		ObjCaredID = DataPool : GetNPCIDByServerID(npcObjId)
		if ObjCaredID == -1 then
			PushDebugMessage("server传过来的数据有问题。")
			return
		end
		BeginCareObject_GemMelting()
		GemMelting_Clear()
		local GemUnionPos = Variable:GetVariable("GemUnionPos")
		if(GemUnionPos ~= nil) then
		  GemMelting_Frame:SetProperty("UnifiedPosition", GemUnionPos)
		end
		-- GemMelting_FenYe3:SetCheck(1)
		this:Show()

	elseif event == "OBJECT_CARED_EVENT" and this:IsVisible() then

		if(tonumber(arg0) ~= ObjCaredID) then
			return
		end
		
		if(arg1 == "distance" and tonumber(arg2) > MAX_OBJ_DISTANCE or arg1=="destroy") then
			GemMelting_Close()
		end

	elseif event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() then

		if arg0 == nil or tonumber(arg0) == -1 then
			return
		end
		
	--	GemMelting_RefreshItem()

	elseif event == "UPDATE_GEMMELTING" then

		if arg0 == nil or arg1 == nil then
			return
		end
		GemMelting_Update(tonumber(arg0),tonumber(arg1))

	elseif event == "UNIT_MONEY" then

		GemMelting_CurrentMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")) )
	elseif event == "MONEYJZ_CHANGE" then

		GemMelting_CurrentJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")) )   --交子普及 Vega

	elseif event == "RESUME_ENCHASE_GEM" and this:IsVisible() then


		
	elseif event == "ADJEST_UI_POS" then
		GemMelting_Frame_On_ResetPos()
		
	elseif event == "VIEW_RESOLUTION_CHANGED" then
		GemMelting_Frame_On_ResetPos()

	end

end

--重置界面
function GemMelting_Clear()

	if g_NeedItemPos ~= -1 then
		LifeAbility:Lock_Packet_Item(g_NeedItemPos,0)
		g_NeedItemPos = -1
	end
	
	if g_GemTableIndex ~= -1 then
		LifeAbility:Lock_Packet_Item(g_GemTableIndex,0)
		g_GemTableIndex = -1
	end

	g_ActionButton_Gem:SetActionItem(-1)
	g_ActionButton_GemNew:SetActionItem(-1)

	GemMelting_NeedItem:SetToolTip("")
	GemMelting_NeedItem:SetActionItem(-1)
		
	GemMelting_NeedMoney:SetProperty("MoneyNumber", "")
	GemMelting_CurrentMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")) )
	GemMelting_CurrentJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")) )

	
	g_NeedItemID = -1
	g_NeedItemID2 = -1

	g_NeedMoney = 0

	g_NotifyBind = 1

	GemMelting_Accept:Disable()

end

--更新界面
function GemMelting_Update( pos_ui, pos_packet )
	-- pos_ui
	-- 1 = 玩家向第1个宝石格子拖放宝石....
	-- 2 = 玩家向第2个宝石格子拖放宝石....
	-- 3 = 玩家向第3个宝石格子拖放宝石....
	-- 4 = 玩家向需求物品的格子拖放需求物品....
	-- 0 = 玩家在背包中右键点击宝石....需要自动寻找空格将该宝石放到界面上....

	if pos_ui == 0 then-- or pos_ui == 1 or pos_ui == 2 or pos_ui == 3 then
		GemMelting_UpdateGemItem( pos_ui, pos_packet )
	elseif pos_ui == 4 then
		GemMelting_UpdateNeedItem( pos_ui, pos_packet )
	end

end

--更新宝石格子
function GemMelting_UpdateGemItem( pos_ui, pos_packet )
     local layedGemItem = EnumAction(pos_packet, "packageitem")
	 if layedGemItem:GetID() == 0 then
		return
	end
	
	--是否加锁....
	if PlayerPackage:IsLock(pos_packet) == 1 then
		PushDebugMessage("#{Item_Locked}")
		return
	end

	--必须是宝石....
	local Item_Class = PlayerPackage:GetItemSubTableIndex(pos_packet,0)
	if Item_Class ~= 5 then
		PushDebugMessage("#{JKBS_081021_006}")
		return
	end

	local nItemTableIndex = PlayerPackage:GetItemTableIndex(pos_packet)

	--获取熔炼的信息....
	local CurProductID = -1
	local CurNeedItemID = -1
	local CurNeedMoney = 0
	local CurNeedItemID2 = -1
	CurProductID, CurNeedItemID, CurNeedMoney, CurNeedItemID2 = GemMelting:GetGemMeltingInfo(nItemTableIndex)
	if -1 == CurProductID then
		PushDebugMessage("#{JKBS_081021_007}")
		return
	end
	
	g_ActionButton_Gem:SetActionItem(-1)
	g_ActionButton_GemNew:SetActionItem(-1)
	if g_GemTableIndex ~= -1 then
		LifeAbility:Lock_Packet_Item(g_GemTableIndex,0)
		g_GemTableIndex = -1
	end

	g_ActionButton_Gem:SetActionItem(layedGemItem:GetID())
	LifeAbility:Lock_Packet_Item(pos_packet,1)
	g_GemTableIndex = pos_packet
	local newGemItem = GemMelting:UpdateProductAction(tonumber(CurProductID))
	if newGemItem:GetID() ~= 0 then
		g_ActionButton_GemNew:SetActionItem(newGemItem:GetID())
	end
	
	GemMelting_Accept:Disable()	
	--判断之前的符是否符合
	if g_NeedItemPos ~= -1 then
		local nNeedItemTableIndex = PlayerPackage:GetItemTableIndex(g_NeedItemPos)
		if CurNeedItemID ~= nNeedItemTableIndex and CurNeedItemID2 ~= nNeedItemTableIndex then
			GemMelting_NeedItem:SetActionItem(-1)
			LifeAbility:Lock_Packet_Item(g_NeedItemPos,0)
			g_NeedItemPos = -1
		else
			local nGemCount = Gemcompose_GetUnLockItemCount(nItemTableIndex)
	
			if nGemCount >= 3 then
				--启用熔炼按钮
				GemMelting_Accept:Enable()
			end
		end
	end
	
	g_NeedItemID = CurNeedItemID
	g_NeedItemID2 = CurNeedItemID2

	--显示所需钱数
	g_NeedMoney = CurNeedMoney
	GemMelting_NeedMoney:SetProperty("MoneyNumber", tostring(g_NeedMoney))

end

function Gemcompose_GetUnLockItemCount(g_GemTableIndex)
	return 3
end

--更新熔炼符格子
function GemMelting_UpdateNeedItem( pos_ui, pos_packet )

	--是否加锁
	if PlayerPackage:IsLock(pos_packet) == 1 then
		PushDebugMessage("#{Item_Locked}")
		return
	end

	--检测是否已经放了宝石
	if g_GemTableIndex == -1 then
		PushDebugMessage("#{JKBS_081022_001}")
		return
	end


	--更新需求物品格的Action
	local theAction = EnumAction(pos_packet, "packageitem");
	if theAction:GetID() == 0 then
		return
	end
    local nNeedsadIndex = PlayerPackage:GetItemTableIndex(pos_packet)
    if nNeedsadIndex ~=30900056 and nNeedsadIndex ~=30900057 then
		PushDebugMessage("#{JKBS_081021_010}")
	return
	end


	if g_NeedItemPos ~= -1 then
		LifeAbility : Lock_Packet_Item(g_NeedItemPos,0)
	end




	g_NeedItemPos = pos_packet;
	LifeAbility:Lock_Packet_Item( g_NeedItemPos, 1 )
	GemMelting_NeedItem:SetActionItem(theAction:GetID())
	
	local nGemCount = Gemcompose_GetUnLockItemCount(PlayerPackage:GetItemTableIndex(g_GemTableIndex))
	
	if nGemCount >= 3 then
		--启用熔炼按钮
		GemMelting_Accept:Enable()
	end
	
	g_NotifyBind = 1


end

--清除ActionButton
function GemMelting_Resume_Item( nIndex )

	--如果是移除宝石格子里的宝石....
	if nIndex == 1 then
		GemMelting_Clear()
		return
	end

	--清除需求物品....
	LifeAbility:Lock_Packet_Item( g_NeedItemPos, 0 )
	GemMelting_NeedItem:SetActionItem(-1)
	g_NeedItemPos = -1

	--禁用熔炼按钮....
	GemMelting_Accept:Disable()

end

function GemMelting_RefreshItem()
		--[[
	if g_GemTableIndex ~= -1 then
		
		g_ActionButton_Gem:SetActionItem(-1)
		g_ActionButton_GemNew:SetActionItem(-1)
		LifeAbility:Lock_Packet_Item(g_GemTableIndex,0)
	

		local layedGemItem = EnumAction(g_DummyGemLayed, "Gem_Layed")
		if layedGemItem:GetID() ~= 0 then
			g_ActionButton_Gem:SetActionItem(layedGemItem:GetID())
			LifeAbility:Lock_Packet_Item(g_GemTableIndex,1)
		end

		local newGemItem = EnumAction(g_DummyNewGem, "Gem_Layed")
		if newGemItem:GetID() ~= 0 then
			g_ActionButton_GemNew:SetActionItem(newGemItem:GetID())
		end		
		
		if g_NeedItemPos ~=  -1 then
			
			local nGemMeltingItemTableIndex = PlayerPackage:GetItemTableIndex(g_NeedItemPos)
			
			local CurProductID, CurNeedItemID, CurNeedMoney, CurNeedItemID2 = GemMelting:GetGemMeltingInfo( g_GemTableIndex )
			
			if CurNeedItemID ~= nGemMeltingItemTableIndex and CurNeedItemID2 ~= nGemMeltingItemTableIndex then
				GemMelting_NeedItem:SetActionItem(-1)
				LifeAbility:Lock_Packet_Item(g_NeedItemPos,0)
				g_NeedItemPos = -1
				GemMelting_Accept:Disable()
			else
				local nGemCount = Gemcompose_GetUnLockItemCount(g_GemTableIndex)
	
				if nGemCount >= 3 then
					GemMelting_Accept:Enable()
				else
					GemMelting_Accept:Disable()
				end
			end
		else
			GemMelting_Accept:Disable()
		end
	
	else
		GemMelting_Clear()
	end
--]]
end

--确定
function GemMelting_Buttons_Clicked()

	--判断电话密保和二级密码保护

	
	--判断是否为安全时间
	if tonumber(DataPool:GetLeftProtectTime()) > 0 then
		PushDebugMessage("#{ZYXT_120528_16}")
		return
	end
	
	--检测是否已经放了宝石
	if g_GemTableIndex == -1 then
		return
	end
	
	--钱是否够
	local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")
	if selfMoney < g_NeedMoney then
		PushDebugMessage( "#{JKBS_081021_011}" )
		return
	end

	--检测绑定状态
	local bHaveBind = 0
	if GetItemBindStatus(g_NeedItemPos) == 1 then
		bHaveBind = 1
	end
	
	local nBindGemCount = GetItemBindStatus(g_GemTableIndex)
	if nBindGemCount > 0 then
		bHaveBind = 1	
	end

	--如果有绑定的则需要提示
	if bHaveBind == 1 and g_NotifyBind == 1 then
		ShowSystemInfo("JKBS_081022_003")
		g_NotifyBind = 0
		return
	end

	--熔炼
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnGemMelting")
		Set_XSCRIPT_ScriptID(800118)
		Set_XSCRIPT_Parameter(0,g_GemTableIndex)
		Set_XSCRIPT_Parameter(1,g_NeedItemPos)
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()

end

--关闭
function GemMelting_Close()
	this:Hide();
	StopCareObject_GemMelting()
	GemMelting_Clear();
end

--界面隐藏
function GemMelting_OnHide()
	StopCareObject_GemMelting()
	GemMelting_Clear();
end

--=========================================================
--开始关心NPC，
--在开始关心之前需要先确定这个界面是不是已经有“关心”的NPC，
--如果有的话，先取消已经有的“关心”
--=========================================================
function BeginCareObject_GemMelting()
	this:CareObject(ObjCaredID, 1, "GemMelting");
end

--=========================================================
--停止对某NPC的关心
--=========================================================
function StopCareObject_GemMelting()
	this:CareObject(ObjCaredID, 0, "GemMelting");
end

function GemMelting_Frame_On_ResetPos()
	GemMelting_Frame:SetProperty("UnifiedPosition", g_GemMelting_Frame_UnifiedPosition);
end

--TAB界面切换
function GemMelting_ChangeTabIndex( nIndex )
	
	if nIndex == 5 or nIndex == 4 or nIndex == 3 then
	
	end
	
	local nUI = 0
	if 1 == nIndex then
		nUI = 23
	elseif 2 == nIndex then
		nUI = 112236
	elseif 3 == nIndex then
		return 0
	elseif 4 == nIndex then
		nUI = 19830424
	elseif 5 == nIndex then
		nUI = 27
	elseif 6 == nIndex then
		nUI = 201408140
	end
	if nUI ~= 0 then
		Variable:SetVariable("GemUnionPos", GemMelting_Frame:GetProperty("UnifiedPosition"), 1)
		Variable:SetVariable("GemNPCObjId", tostring(npcObjId), 1)
		PushEvent("UI_COMMAND", nUI)
		GemMelting_Close()
	end
end
