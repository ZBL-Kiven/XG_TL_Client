--PetPropagateSingle.lua
--单人珍兽繁殖界面(两个珍兽)
local firstPet  = { idx = -1, guid = { high = -1, low = -1 } }
local secondPet = { idx = -1, guid = { high = -1, low = -1 } }
local g_currentChoose = -1
local g_wastemoney 	= 20000
--单人珍兽繁殖材料
local g_ItemPos 	= -1
--单人珍兽繁殖材料ID 爱心小窝
local g_ItemTblID   = 30309794
--
local g_clientNpcId = -1
local g_serverNpcId = -1

local g_PetPropagateSingle_Frame_UnifiedPosition;

--*************************************************
--
--*************************************************
function PetPropagateSingle_PreLoad()
	this : RegisterEvent( "UNIT_MONEY" )
	this : RegisterEvent( "UI_COMMAND" )
	this : RegisterEvent( "MONEYJZ_CHANGE" )
	this : RegisterEvent( "REPLY_MISSION_PET" )				-- 玩家从列表选定一只珍兽
	this : RegisterEvent( "UPDATE_PET_PAGE" )				-- 玩家身上的珍兽数据发生变化
	this : RegisterEvent( "DELETE_PET" )					-- 玩家身上减少一只珍兽
	this : RegisterEvent( "OBJECT_CARED_EVENT" )			-- 关心 NPC 的存在和范围
	this : RegisterEvent( "UNIT_MONEY" )
	this : RegisterEvent( "MONEYJZ_CHANGE" )				--交子
	this : RegisterEvent( "PACKAGE_ITEM_CHANGED" )
	this : RegisterEvent( "UPDATE_PET_PROPAGASINGLE" )
	this : RegisterEvent( "TEAM_PETCREATE_OPENED" )
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function PetPropagateSingle_OnLoad()
 	g_PetPropagateSingle_Frame_UnifiedPosition=PetPropagateSingle_Frame:GetProperty("UnifiedPosition");
end

--*************************************************
--
--*************************************************
function PetPropagateSingle_OnEvent(event)

	if ( event == "UI_COMMAND" ) then
		PetPropagateSingle_UICommand(arg0)

	elseif ( event == "UNIT_MONEY" )		then
		PetPropagateSingle_ShowMoney()

	elseif ( event == "MONEYJZ_CHANGE")		then
		PetPropagateSingle_ShowJZ()

	elseif ( event == "REPLY_MISSION_PET" ) then
		PetPropagateSingle_SelectPet(arg0)

	elseif ( event == "UPDATE_PET_PAGE" ) 	then
		PetPropagateSingle_UpdatePetSelected()

	elseif ( event == "DELETE_PET" ) 		then
		PetPropagateSingle_UpdatePetSelected()

	elseif ( event == "OBJECT_CARED_EVENT" )		then
		PetPropagateSingle_CareObj(arg0,arg1,arg2)

	elseif ( event == "PACKAGE_ITEM_CHANGED" ) 		then
		if ( arg0 ~= nil and -1 == tonumber(arg0)) 	then
			return
		end

		if tonumber(arg0) == g_ItemPos then
			PetPropagateSingle_Resume_Object()
		end

	elseif ( event == "UPDATE_PET_PROPAGASINGLE" ) 	then
		PetPropagateSingle_Update(arg0)

	elseif ( event == "TEAM_PETCREATE_OPENED" ) then
		if (this : IsVisible() == false) then
			return
		end

		if (g_clientNpcId ~= -1) then
			this : CareObject(g_clientNpcId, 0, "PetPropagateSingle")
		end

		PetPropagateSingle_Clear()
		Pet : ShowPetList( 1 )
		this : Hide()
		
	elseif (event == "ADJEST_UI_POS" ) then
		PetPropagateSingle_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		PetPropagateSingle_Frame_On_ResetPos()
		
	end
end

--*************************************************
--单人珍兽繁殖界面接受命令
--*************************************************
function PetPropagateSingle_UICommand(arg0)
	local nOpt = tonumber(arg0)
	if (nOpt == 20091025) then
		Pet : CloseTeamPetProCreate()
		PetPropagateSingle_Show()
	end
end

--*************************************************
--处理玩家确认要做的事情
--*************************************************
function PetPropagateSingle_OK_Clicked()
	-- 发送 UI_Command 进行合成
	local nName1 = PetPropagateSingle_PetName1 : GetText()
	local nName2 = PetPropagateSingle_PetName2 : GetText()
	if (firstPet.guid.high == -1 or firstPet.guid.low == -1	or secondPet.guid.high == -1 or secondPet.guid.low == -1) then
		PushDebugMessage("请选择珍兽！")
		return
	end

	if (nName1 == nil or nName1 == "" or nName2 == nil or nName2 == "") then
		PushDebugMessage("请选择珍兽！")
		return
	end

	if (g_ItemPos == -1) then
		PushDebugMessage("#{DRFZZC_091013_17}")
		return
	end

	local nItemID = PlayerPackage : GetItemTableIndex( g_ItemPos )
	if (nItemID ~= g_ItemTblID) then
		PushDebugMessage("#{DRFZZC_091013_17}")
		return
	end

	--金钱是否足够
	local nHaveMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")
	if (nHaveMoney < g_wastemoney) then
		PushDebugMessage("#{no_money}")
		return
	end

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "OnSignalPetProcreateRegister" )
		Set_XSCRIPT_ScriptID( 800101 )
		Set_XSCRIPT_Parameter( 0, g_serverNpcId )
		Set_XSCRIPT_Parameter( 1, firstPet.guid.high )
		Set_XSCRIPT_Parameter( 2, firstPet.guid.low )
		Set_XSCRIPT_Parameter( 3, secondPet.guid.high )
		Set_XSCRIPT_Parameter( 4, secondPet.guid.low )
		Set_XSCRIPT_Parameter( 5, g_ItemPos )
		Set_XSCRIPT_ParamCount( 6 )
	Send_XSCRIPT()
end

--*************************************************
--点击X按钮，隐藏窗口。
--*************************************************
function PetPropagateSingle_OnHidden()
	if (this : IsVisible() == false) then
		return
	end

	if (g_clientNpcId ~= -1) then
		this : CareObject(g_clientNpcId, 0, "PetPropagateSingle")
	end

	PetPropagateSingle_Clear()
	Pet : ShowPetList( 0 )
	this : Hide()
end

--*************************************************
--点击取消按钮，窗口隐藏函数
--*************************************************
function PetPropagateSingle_Close_Window()
	if (this : IsVisible() == false) then
		return
	end

	if (g_clientNpcId ~= -1) then
		this : CareObject(g_clientNpcId, 0, "PetPropagateSingle")
	end

	PetPropagateSingle_Clear()
	Pet : ShowPetList( 0 )
	this : Hide()
end

--*************************************************
--关心NPC
--*************************************************
function PetPropagateSingle_CareObj(careId, op, distance)
	if(nil == careId or nil == op or nil == distance) then
		return;
	end

	if(tonumber(careId) ~= g_clientNpcId) then
		return;
	end

	if(op == "distance" and tonumber(distance)>MAX_OBJ_DISTANCE or op=="destroy") then
		PetPropagateSingle_OnHidden()
	end
end

--*************************************************
--打开单人珍兽繁殖界面
--*************************************************
function PetPropagateSingle_Show()
	if (this : IsVisible()) then									-- 如果界面开着，则不处理
		return
	end

	--界面的主人
	g_serverNpcId = Get_XParam_INT(0)
	g_clientNpcId = Target : GetServerId2ClientId(g_serverNpcId)

	if (g_clientNpcId == -1) then
		return
	end

	this : CareObject(g_clientNpcId, 1, "PetPropagateSingle")

	--珍兽显示界面
	PetPropagateSingle_Clear()
	Pet : ShowPetList( 0 )
	this : Show()

	local npcObjId = Get_XParam_INT( 0 )
	BeginCareObject( npcObjId )

	PetPropagateSingle_SelfJiaozi : SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
	PetPropagateSingle_SelfMoney  : SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
	PetPropagateSingle_PetList_Select1 : Enable()
	PetPropagateSingle_PetList_Select2 : Enable()
end


--*************************************************
--选择珍兽
--*************************************************
function PetPropagateSingle_SelectPet_Clicked(type)
	if (type == "first") then
		g_currentChoose = 1
		PetPropagateSingle_PetList_Select1 : Disable()
		PetPropagateSingle_PetList_Select2 : Enable()
	elseif (type == "second") then
		g_currentChoose = 2
		PetPropagateSingle_PetList_Select1 : Enable()
		PetPropagateSingle_PetList_Select2 : Disable()
	else
		return
	end
	-- 关一下再开，清空数据
	Pet : ShowPetList( 0 )
	Pet : ShowPetList( 1 )
end

--***************************************************
--
--***************************************************
function PetPropagateSingle_SelectPet( arg0 )

	--判断单人珍兽繁殖
	if (not (this : IsVisible())) then
		return
	end

	--珍兽索引
	local petIdx = tonumber(arg0)
	if (-1 == petIdx) then
		return
	end
	
	--珍兽已被其它界面选中且排除单人珍兽繁殖界面，由后面判断
	if (Pet:GetPetLocation(petIdx) ~= -1 and Pet:GetPetLocation(petIdx) ~= 2) then
		return;
	end

	--判断是否珍兽加锁
	if (PlayerPackage:IsPetLock(petIdx) == 1) then
		PushDebugMessage("#{DRFZZC_091013_09}")
		return
	end

	--判断是否珍兽出战
	if (Pet : GetIsFighting(petIdx) == 1) then
		PushDebugMessage("#{DRFZZC_091013_10}")
		return
	end

	--判断是否为珍兽宝宝
	--if (Pet : GetPetType(petIdx) ~= 0) then
	--	PushDebugMessage("#{DRFZZC_091013_11}")
	--	return
	--end

	--判断珍兽是否为幻化
	if (Pet : GetGeneration(petIdx) >= 100 ) then
		PushDebugMessage("#{DRFZZC_091013_12}")
		return
	end

	--判断珍兽是否快乐度为100
	if (Pet : GetHappy(petIdx) ~= 100) then
		PushDebugMessage("#{DRFZZC_091013_13}")
		return
	end

	--判断珍兽是否穿了装备
	if (Pet : IsPetHaveEquip(petIdx) == 1) then
		PushDebugMessage("#{DRFZZC_091013_14}")
		return
	end

	--判断珍兽寿命是否为1000
	if (Pet : GetNaturalLife(petIdx) < 1000) then
		PushDebugMessage("#{DRFZZC_091013_15}")
		return
	end

	local petName = Pet : GetPetList_Appoint( petIdx )
	local guidH, guidL = Pet : GetGUID( petIdx )

	if (g_currentChoose == 1) then
		--判断是否第一个珍兽和第二个珍兽是同一个珍兽
		if (secondPet.idx ~= -1 and secondPet.idx == petIdx) then
			ShowSystemTipInfo( "请放入两只不同的珍兽。" )
			return
		end

		--如果其中有珍兽了，清空
		PetPropagateSingle_RemoveFirstPet()

		firstPet.idx = petIdx
		firstPet.guid.high = guidH
		firstPet.guid.low  = guidL

		--填写第一个珍兽名字
		PetPropagateSingle_PetName1 : SetText( petName )
		Pet : SetPetLocation( petIdx , 2 )
		Pet : UpdatePetList()

	elseif (g_currentChoose == 2) then
		--判断是否第一个珍兽和第二个珍兽是同一个珍兽
		if (firstPet.idx ~= -1 and firstPet.idx == petIdx) then
			ShowSystemTipInfo( "请放入两只不同的珍兽。" )
			return
		end

		--如果其中有珍兽了，清空
		PetPropagateSingle_RemoveSecondPet()

		secondPet.idx = petIdx
		secondPet.guid.high = guidH
		secondPet.guid.low  = guidL

		--填写第二个珍兽的名字
		PetPropagateSingle_PetName2 : SetText( petName )
		Pet : SetPetLocation( petIdx , 2 )
		Pet : UpdatePetList()
	end

	--显示消耗多少金钱
	PetPropagateSingle_CalcCost()
end

--***************************************************
--清空第一个珍兽
--***************************************************
function PetPropagateSingle_RemoveFirstPet()
	if (firstPet.idx ~= -1) then
		Pet : SetPetLocation( firstPet.idx, -1 )
		-- 更新珍兽列表界面
		Pet : UpdatePetList()
	end

	firstPet.idx = -1
	firstPet.guid.high = -1
	firstPet.guid.low  = -1
	PetPropagateSingle_PetName1 : SetText( "" )
end


--***************************************************
--清空第二个珍兽
--***************************************************
function PetPropagateSingle_RemoveSecondPet()
	if (secondPet.idx ~= -1) then
		Pet : SetPetLocation( secondPet.idx, -1 )
		-- 更新珍兽列表界面
		Pet : UpdatePetList()
	end

	secondPet.idx = -1
	secondPet.guid.high = -1
	secondPet.guid.low  = -1
	PetPropagateSingle_PetName2 : SetText( "" )
end


--****************************************************
--计算金钱消耗
--****************************************************
function PetPropagateSingle_CalcCost()
	PetPropagateSingle_Money : SetProperty( "MoneyNumber", tostring( g_wastemoney ) )
end


--****************************************************
--更新界面
--****************************************************
function PetPropagateSingle_Update( pos_packet )
	if (pos_packet == nil) then
		return
	end

	local BagPos = tonumber( pos_packet )

	--是否加锁....
	if (PlayerPackage:IsLock(BagPos) == 1) then
		PushDebugMessage("#{Item_Locked}")
		return
	end

	--更新单人珍兽繁殖材料界面
	local ItemID = PlayerPackage : GetItemTableIndex( BagPos )
	if ( ItemID <= 0) then
		PushDebugMessage("#{GMActionSystem_Item_CantUseInPetSkillStudy}")
		return
	end

	--查看物品是否是“爱心小窝”
	if ( ItemID ~= g_ItemTblID) then
		PushDebugMessage("#{DRFZZC_091013_17}")
		return
	end

	--珍兽物品位置是否合法
	if (g_ItemPos ~= -1) then
		LifeAbility : Lock_Packet_Item( g_ItemPos, 0 )
	end

	LifeAbility : Lock_Packet_Item( BagPos, 1 )
	g_ItemPos = BagPos

	--更新珍兽还童的珍兽界面
	local theAction = EnumAction( BagPos, "packageitem" )
	if (theAction : GetID() == 0) then
		return
	end

	PetPropagateSingle_Object : SetActionItem( theAction : GetID() )
	PetPropagateSingle_CalcCost()
end


--*************************************************
--
--*************************************************
function PetPropagateSingle_Resume_Object()
	PetPropagateSingle_ClearActionItem()
end

--*************************************************
--
--*************************************************
function PetPropagateSingle_Clear()
	PetPropagateSingle_ClearPetName()
	PetPropagateSingle_ClearActionItem()
	PetPropagateSingle_ClearMoney()
end

--*************************************************
--清空两个珍兽名字
--*************************************************
function PetPropagateSingle_ClearPetName()
	PetPropagateSingle_RemoveFirstPet()
	PetPropagateSingle_RemoveSecondPet()
end

--*************************************************
--清空繁殖物品
--*************************************************
function PetPropagateSingle_ClearActionItem()
	if g_ItemPos ~= -1 then
		LifeAbility : Lock_Packet_Item( g_ItemPos, 0 )
		PetPropagateSingle_Object : SetActionItem( -1 )
		g_ItemPos = -1
	end
end

--*************************************************
--清空金钱
--*************************************************
function PetPropagateSingle_ClearMoney()
	PetPropagateSingle_Money : SetProperty( "MoneyNumber", 0 )
	PetPropagateSingle_SelfJiaozi : SetProperty( "MoneyNumber", 0 )
	PetPropagateSingle_SelfMoney  : SetProperty( "MoneyNumber", 0 )
end

--*************************************************
--选择珍兽更新
--*************************************************
function PetPropagateSingle_UpdatePetSelected()
	-- 判断被选中的珍兽是否还在背包里
	if (firstPet.idx ~= -1) then
		local newIdx = Pet : GetPetIndexByGUID( firstPet.guid.high, firstPet.guid.low )
		Pet : SetPetLocation( firstPet.idx, -1 )
		-- 如果不在则删掉
		if (newIdx == -1) then
			firstPet.idx = -1
			firstPet.guid.high = -1
			firstPet.guid.low  = -1
			PetPropagateSingle_PetName1 : SetText( "" )
		-- 否则判断珍兽的位置是否发生变化
		elseif (newIdx ~= firstPet.idx) then
			-- 如果发生变化则对位置进行更新
			firstPet.idx = newIdx
		end
	end

	-- 判断被选中的珍兽是否还在背包里
	if (secondPet.idx ~= -1) then
		local newIdx = Pet : GetPetIndexByGUID( secondPet.guid.high, secondPet.guid.low )
		Pet : SetPetLocation( secondPet.idx, -1 )
		-- 如果不在则删掉
		if (newIdx == -1) then
			secondPet.idx = -1
			secondPet.guid.high = -1
			secondPet.guid.low  = -1
			PetPropagateSingle_PetName2 : SetText( "" )
		-- 否则判断珍兽的位置是否发生变化
		elseif (newIdx ~= secondPet.idx) then
			-- 如果发生变化则对位置进行更新
			secondPet.idx = newIdx
		end
	end
end

--********************************************
--显示自身拥有的金钱
--********************************************
function PetPropagateSingle_ShowMoney()
	PetPropagateSingle_SelfMoney : SetProperty( "MoneyNumber", tostring(Player:GetData("MONEY")) )
end

--********************************************
--显示自身拥有的交子
--********************************************
function PetPropagateSingle_ShowJZ()
	PetPropagateSingle_SelfJiaozi : SetProperty( "MoneyNumber", tostring(Player:GetData("MONEY_JZ")) )
end

function PetPropagateSingle_Frame_On_ResetPos()
  PetPropagateSingle_Frame:SetProperty("UnifiedPosition", g_PetPropagateSingle_Frame_UnifiedPosition);
end
