--*********************
--减抗双属性石头合成界面
--写的太太太恶心了，待整理
--TODO 需要多少钱，什么时候显示，显示有问题
--*********************

local MAX_OBJ_DISTANCE = 3.0
local ObjCaredIDID = -1

local g_Gemzhuoke_Frame_UnifiedPosition

local Gemzhuoke_MainABT = ""
local Gemzhuoke_MainID = -1

local Gemzhuoke_AssistABT = ""
local Gemzhuoke_AssistID = -1

local Gemzhuoke_MaterABT = ""
local Gemzhuoke_MaterPos = -1

local Gemzhuoke_ProductABT = ""
local Gemzhuoke_ProductID = -1--无实物

local g_NeedMoney = 200000 --5J

local g_DummyMainGemLayed = 4
local g_DummySubGemLayed = 5

--暂时不用字典，待确认
local g_TipsKinds={
	"纯净黄晶石",
	"纯净蓝晶石",
	"纯净红晶石",
	"纯净绿晶石",
	"纯净黄晶石·红利",
	"纯净蓝晶石·红利",
	"纯净红晶石·红利",
	"纯净绿晶石·红利",
}

local g_ZhuoKeFu={38000446, 38000445}--不绑定，绑定
local g_ShowBind = 0


function Gemzhuoke_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("UPDATE_DOUBLEGEM_ZHUOKE")
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")				-- 背包中物品改变需要判断…
	this:RegisterEvent("RESUME_ENCHASE_GEM")
	this:RegisterEvent("UNIT_MONEY")
	this:RegisterEvent("MONEYJZ_CHANGE")
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end


function Gemzhuoke_OnLoad()

	Gemzhuoke_MainABT = Gemzhuoke_Object
	Gemzhuoke_AssistABT = Gemzhuoke_Object2
	Gemzhuoke_MaterABT = Gemzhuoke_Object6
	Gemzhuoke_ProductABT = Gemzhuoke_Object7
	g_Gemzhuoke_Frame_UnifiedPosition=Gemzhuoke_Frame:GetProperty("UnifiedPosition")
	
end


function Gemzhuoke_OnEvent( event )
	
	if ( event=="UI_COMMAND" and tonumber(arg0) == 201210120 ) then
	
		local npcObjId = tonumber(Variable:GetVariable("GemNPCObjId"))
		Variable:SetVariable("GemNPCObjId", "", 1)
		if(npcObjId == nil) then
			npcObjId = Get_XParam_INT( 0 )
		end
		
		ObjCaredID = DataPool:GetNPCIDByServerID(npcObjId)
		if ObjCaredID == -1 then
				PushDebugMessage("Error!")
				return
		end
		
		ObjCaredIDID = npcObjId
		Gemzhuoke_BeginCareObject()
		Gemzhuoke_Clear(1)
		Gemzhuoke_ShowMoneyInfo()
		g_ShowBind=0
		local GemUnionPos = Variable:GetVariable("GemUnionPos")
		if(GemUnionPos ~= nil) then
		  Gemzhuoke_Frame:SetProperty("UnifiedPosition", GemUnionPos)
		end
		Gemzhuoke_FenYe4:SetCheck(1)
		this:Show()
		
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 201107281 and this:IsVisible()) then
		
		if arg0 == nil or arg1 == nil  then
			return
		end
		--arg0 是UI的第几个位置
		--arg1 是背包的格子
		g_ShowBind=0
		local pos_packet = tonumber(arg1)
		if Gemzhuoke_MainID ==-1 or Gemzhuoke_AssistID == -1 then 
		Gemzhuoke_Update(1, pos_packet)
		elseif Gemzhuoke_MaterPos ==-1 then
		Gemzhuoke_Update(2, pos_packet)
		else
		Gemzhuoke_Update(1, pos_packet)
		end
	elseif (event=="PACKAGE_ITEM_CHANGED") and this:IsVisible() then
		
		if arg0 ~= nil and -1 == tonumber(arg0) then
			return
		end
		
		--Gemzhuoke_RefreshItem()

		g_ShowBind=0
		
	elseif event=="RESUME_ENCHASE_GEM" and this:IsVisible() then
		
		if arg0~= nil and -1 == tonumber(arg0) then
			return
		end

	--	Gemzhuoke_Resume_RBClick(tonumber(arg0))
		g_ShowBind = 0
		
	elseif event == "OBJECT_CARED_EVENT" and this:IsVisible() then

		if tonumber(arg0) ~= ObjCaredID then
			return
		end

		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if (arg1 == "distance" and tonumber(arg2) > MAX_OBJ_DISTANCE) or arg1 == "destroy" then
			Gemzhuoke_OnHiden()
		end
		
	elseif (event == "UNIT_MONEY" or event =="MONEYJZ_CHANGE") and this:IsVisible() then
		
		
		Gemzhuoke_ShowMoneyInfo()
	elseif event == "ADJEST_UI_POS" then
		
		Gemzhuoke_Frame_On_ResetPos()
		
	elseif event == "VIEW_RESOLUTION_CHANGED" then
		
		Gemzhuoke_Frame_On_ResetPos()
		
	end
end

--=========================================================
--开始关心NPC，
--在开始关心之前需要先确定这个界面是不是已经有“关心”的NPC，
--如果有的话，先取消已经有的“关心”
--=========================================================
function Gemzhuoke_BeginCareObject()
	this:CareObject(ObjCaredID, 1, "Gemzhuoke")
end

--=========================================================
--停止对某NPC的关心
--=========================================================
function Gemzhuoke_StopCareObject()
	this:CareObject(ObjCaredID, 0, "Gemzhuoke")
end

--=========================================================
--重置界面
--=========================================================
function Gemzhuoke_Clear(all)

	if Gemzhuoke_MainID ~= -1 then
		LifeAbility:Lock_Packet_Item(Gemzhuoke_MainID,0)
		Gemzhuoke_MainID = -1
	end
	Gemzhuoke_MainABT:SetActionItem(-1)

	if Gemzhuoke_AssistID ~= -1 then
		LifeAbility:Lock_Packet_Item(Gemzhuoke_AssistID,0)
		Gemzhuoke_AssistID = -1
	end
	Gemzhuoke_AssistABT:SetActionItem(-1)

	if all == 1 then
		if Gemzhuoke_MaterPos ~= -1 then
			LifeAbility:Lock_Packet_Item(Gemzhuoke_MaterPos,0)
			Gemzhuoke_MaterPos = -1
		end
		Gemzhuoke_MaterABT:SetActionItem(-1)
	end
	
	Gemzhuoke_ProductABT:SetActionItem(-1)
	Gemzhuoke_ProductID = -1

	Gemzhuoke_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"))
	Gemzhuoke_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"))

	Gemzhuoke_OK:Disable()
	g_ShowBind = 0
end

--=========================================================
--更新界面
--=========================================================
function Gemzhuoke_Update( moveType, pos_packet )

	local theAction = EnumAction(pos_packet, "packageitem")
	if (theAction:GetID() == 0) then
		return
	end

	--宝石槽位
    if moveType ==1 then 
		local Item_Class = PlayerPackage:GetItemSubTableIndex(pos_packet,0)
		if Item_Class ~= 5 then
			return
		end
		local GemLevel = PlayerPackage:GetItemSubTableIndex(pos_packet,1)--等级
		local GemType = PlayerPackage:GetItemSubTableIndex(pos_packet,2)
		local GemIndex = PlayerPackage:GetItemSubTableIndex(pos_packet,3)--小index
		local GemCarryID = PlayerPackage:GetItemTableIndex( pos_packet )
		
		--胜利宝石流程 减抗性石头
		if GemType == 21 then
			--玩家点击的胜利宝石是否是一个尚未琢刻的3级或3级以上的胜利宝石
			if GemLevel<3 or GemIndex>100 then
				PushDebugMessage( "#{BSZK_121012_16}" )--仅可对3级或3级以上的减抗宝石进行琢刻
				return
			end
			--重置界面....
			Gemzhuoke_Clear(1)
			--玩家是否已经在1号位置放置了一个尚未琢刻的3级或3级以上的胜利宝石
			if Gemzhuoke_MainID ~= -1 then--有石头
				Gemzhuoke_MainABT:SetActionItem(-1)
				LifeAbility:Lock_Packet_Item(Gemzhuoke_MainID,0)
				Gemzhuoke_MainID = -1
			end
			
			if theAction:GetID() ~= 0 then
				Gemzhuoke_MainABT:SetActionItem(theAction:GetID())
				Gemzhuoke_MainID = pos_packet
				LifeAbility:Lock_Packet_Item(Gemzhuoke_MainID,1)
				
			end
			
			Gemzhuoke_LightZhuoKeBTN()
		--智慧宝石流程 属性攻击石头
		elseif GemType == 2 then
			--玩家是否已经在1号位置放置了一个尚未琢刻的3级或3级以上的胜利宝石
			if Gemzhuoke_MainID == -1 then
				PushDebugMessage( "#{BSZK_121012_18}" )--请先放入一颗将要进行琢刻的3级或3级以上的减抗宝石
				return
			end
			local GemMainLevel = Gemzhuoke_GetGemLevel(Gemzhuoke_MainID)	--等级
			local GemMainIndex = Gemzhuoke_GetGemIndex(Gemzhuoke_MainID) 	--小index索引
			--主宝石名字
			if GemMainIndex < 1 or GemMainIndex > 8 then
				return
			end
			
			
			
			if GemLevel > GemMainLevel then
				local gemName ="#{_ITEM" ..tostring(PlayerPackage:GetItemTableIndex( Gemzhuoke_MainID )).."}" --DataPool:Lua_GetItemNameByIndex( Gemzhuoke_MainID )
				local szShow = string.format( "%s只可琢刻%s级和%s级以下的%s。", gemName, GemMainLevel, GemMainLevel, g_TipsKinds[GemMainIndex])
				PushDebugMessage(szShow)
				return
			end
			
			local zProductID = PlayerPackage:GetItemTableIndex( Gemzhuoke_MainID )
			local fProductID = PlayerPackage:GetItemTableIndex( pos_packet )
			if math.mod(zProductID,10) ~= math.mod(fProductID,10) -4  then
			--是否可以合成
				local gemName ="#{_ITEM" ..tostring(PlayerPackage:GetItemTableIndex( Gemzhuoke_MainID )).."}" --DataPool:Lua_GetItemNameByIndex( Gemzhuoke_MainID )
				local szShow = string.format( "%s只可琢刻%s级和%s级以下的%s。", gemName, GemMainLevel, GemMainLevel, g_TipsKinds[GemMainIndex])
				PushDebugMessage(szShow)
				return
			end
			--可以合成了，那就放进去蒙红吧
			if Gemzhuoke_AssistID ~= -1 then
				Gemzhuoke_AssistABT:SetActionItem(-1)
				LifeAbility:Lock_Packet_Item(Gemzhuoke_AssistID,0)
				Gemzhuoke_AssistID = -1
			end
			
			if theAction:GetID() ~= 0 then
				Gemzhuoke_AssistABT:SetActionItem(theAction:GetID())
				Gemzhuoke_AssistID = pos_packet
				LifeAbility:Lock_Packet_Item(Gemzhuoke_AssistID,1)
			end
			Gemzhuoke_LightZhuoKeBTN()
		--其他宝石
		else
			PushDebugMessage( "#{BSZK_121012_23}" )--该物品不可进行琢刻
			return
		end
	elseif moveType ==2 then 	
		--非宝石类逻辑
		local itemID = PlayerPackage:GetItemTableIndex(pos_packet)
		--不是需求的物品....
		
		if itemID ~= g_ZhuoKeFu[1] and itemID ~= g_ZhuoKeFu[2] then
			PushDebugMessage( "#{BSZK_121012_23}" )--该物品不可进行琢刻
			return
		end

		--更换ActionButton....
		if Gemzhuoke_MaterPos ~= -1 then
			Gemzhuoke_MaterABT:SetActionItem(-1)
			LifeAbility:Lock_Packet_Item(Gemzhuoke_MaterPos, 0)
			Gemzhuoke_MaterPos = -1
		end
			
		Gemzhuoke_MaterABT:SetActionItem(theAction:GetID())
		LifeAbility:Lock_Packet_Item(Gemzhuoke_MaterPos,1)
		Gemzhuoke_MaterPos = pos_packet	

		Gemzhuoke_MaterID = itemID

		Gemzhuoke_LightZhuoKeBTN()

    end


end

function Gemzhuoke_OnShow()

end

function Gemzhuoke_OK_Clicked()
	
	if Gemzhuoke_MainID == -1 then
		return
	end
	
	--检测
	local nItemTableIndex =  PlayerPackage:GetItemTableIndex(Gemzhuoke_AssistID)
	local nGemCount = Gemcompose_GetUnLockItemCount(nItemTableIndex)
	local GemLevel = PlayerPackage : GetItemSubTableIndex(Gemzhuoke_AssistID,1)--等级
	local nAssistGemCount=4 -- DoubleGem:GetDoubleGemInfo(Gemzhuoke_MainID, Gemzhuoke_AssistID)
	if GemLevel >6 then
	 nAssistGemCount=3
	end
	
	
	if nAssistGemCount <= 0 or nGemCount < nAssistGemCount then
		return
	end
	


	
	-- 判断是否为安全时间
	if tonumber(DataPool:GetLeftProtectTime()) > 0 then
		PushDebugMessage("#{OR_PILFER_LOCK_FLAG}")
		return
	end
	
	--钱数
	-- 检查身上的金钱是否足够
	local selfMoney = Player:GetData( "MONEY" ) + Player:GetData( "MONEY_JZ" )
	if selfMoney < g_NeedMoney then
		PushDebugMessage( "#{BSZK_121012_25}" )
		return
	end
	


	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnDoubleGemZhuoKe")
		Set_XSCRIPT_ScriptID(290205)
		Set_XSCRIPT_Parameter(0,Gemzhuoke_MainID)
		Set_XSCRIPT_Parameter(1,Gemzhuoke_AssistID)
		Set_XSCRIPT_Parameter(2,Gemzhuoke_MaterPos)
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
	Gemzhuoke_Clear(1)

end

function Gemzhuoke_GetGemLevel(nSN)
	local GemCarryID = PlayerPackage:GetItemTableIndex( nSN )
	if GemCarryID < 0 then
		return 0
	end

	local nLevel = math.floor(math.mod(GemCarryID,10000000) / 100000)
	return nLevel

end

function Gemzhuoke_GetGemIndex(nSN)
	local GemCarryID = PlayerPackage:GetItemTableIndex( nSN )
	if GemCarryID < 0 then
		return 0
	end

	local nIndex = math.mod(GemCarryID,1000)
	return nIndex

end

function Gemzhuoke_GetBindStatus()
	
	if Gemzhuoke_MainID ~= -1 then
		local nBindGemCount = PlayerPackage:Lua_GetUnLockBindItemCount(Gemzhuoke_MainID)
		if nBindGemCount > 0 then
			return 1
		end
	end
	
	if Gemzhuoke_AssistID ~= -1 then
		local nBindGemCount = PlayerPackage:Lua_GetUnLockBindItemCount(Gemzhuoke_AssistID)
		if nBindGemCount > 0 then
			return 1
		end
	end
	
	if Gemzhuoke_MaterPos ~= -1 then
		local Bind = GetItemBindStatus(Gemzhuoke_MaterPos)
		if Bind == 1 then
			return 1
		end
	end

	return 0
end

function Gemzhuoke_OnHiden()
	Gemzhuoke_Clear(1)
	Gemzhuoke_StopCareObject()
	this:Hide()
end

function Gemzhuoke_Resume_RBClick(nIdx)
	
	if nIdx == nil then
		return
	end
	
	if nIdx == 0 then	--主宝石
		
		Gemzhuoke_Clear(0)
		
	elseif nIdx == 1 then	--副宝石
		
		--副宝石 拿下来的时候只清空 副宝石和符
		if Gemzhuoke_AssistID ~= -1 then
			LifeAbility:Lock_Packet_Item(Gemzhuoke_AssistID,0)
			Gemzhuoke_AssistID = -1
		end
		
		Gemzhuoke_AssistABT:SetActionItem(-1)
		Gemzhuoke_ProductABT:SetActionItem(-1)

		Gemzhuoke_OK:Disable()
		
	elseif nIdx == 2 then	--琢刻符
	
		if Gemzhuoke_MaterPos ~= -1 then
			LifeAbility:Lock_Packet_Item(Gemzhuoke_MaterPos,0)
			Gemzhuoke_MaterABT:SetActionItem(-1)
			Gemzhuoke_MaterPos = -1
		end
		Gemzhuoke_OK:Disable()
	end
end

function Gemzhuoke_LightZhuoKeBTN()
	
	if Gemzhuoke_MainID == -1 then
		return
	end
	
	if Gemzhuoke_AssistID == -1 then
		return
	end
	local NemLevel = PlayerPackage : GetItemSubTableIndex(Gemzhuoke_MainID,1)--等级
	local GemLevel = PlayerPackage : GetItemSubTableIndex(Gemzhuoke_AssistID,1)--等级
    local itemID = PlayerPackage : GetItemTableIndex( Gemzhuoke_MainID )
	--计算新ID
	local idx =0 
	idx =math.mod(itemID,10)
    if idx <1 or idx >4 then 
	return
	end
	ddfw,k = string.gsub(itemID,"(%d%d%d%d%d)%d(%d)%d","%1"..tostring(idx).."%2"..GemLevel)
	if k ==0 then 
		return
	end
    nProductID=tonumber( ddfw)
    local nAssistGemCount =4 
	if NemLevel >6 then 
		nAssistGemCount=3
	end


	
	
	
	
	--显示产出物
	if 	Gemzhuoke_ProductID == -1 then
		local ProductAction = GemCarve:UpdateProductAction(nProductID)
		if ProductAction and ProductAction:GetID() ~= 0 then
			Gemzhuoke_ProductABT:SetActionItem(ProductAction:GetID())
			Gemzhuoke_ProductID = nProductID
		else
			Gemzhuoke_ProductABT:SetActionItem(-1)
			Gemzhuoke_ProductID = -1
		end
	end
	local aaGemTableIndex =PlayerPackage : GetItemTableIndex( Gemzhuoke_AssistID )
	local nGemCount = Gemcompose_GetUnLockItemCount(aaGemTableIndex)--PlayerPackage:Lua_GetUnLockItemCount(Gemzhuoke_AssistID)


	if nGemCount < nAssistGemCount then
		return
	end	
	
	if Gemzhuoke_MaterPos == -1 then
		return
	end

	Gemzhuoke_OK:Enable()

end

function Gemzhuoke_ShowMoneyInfo()
	--设置所需钱数....
	Gemzhuoke_DemandMoney:SetProperty("MoneyNumber", tostring(g_NeedMoney))
	Gemzhuoke_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"))
	Gemzhuoke_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"))
end

function Gemzhuoke_RefreshItem()
	
	Gemzhuoke_OK:Disable()
	
	if Gemzhuoke_MainID ~= -1 then
		
		Gemzhuoke_MainABT:SetActionItem(-1)
		LifeAbility:Lock_Packet_Item(Gemzhuoke_MainID,0)
	
		local nMainGemCount = PlayerPackage:Lua_GetUnLockItemCount(Gemzhuoke_MainID)
		
		if nMainGemCount > 0 then


			local layedGemItem = EnumAction(g_DummyMainGemLayed, "Gem_Layed")
			if layedGemItem:GetID() ~= 0 then
				Gemzhuoke_MainABT:SetActionItem(layedGemItem:GetID())
				LifeAbility:Lock_Packet_Item(Gemzhuoke_MainID,1)
			end
			
			if Gemzhuoke_AssistID ~= 1 then
				Gemzhuoke_AssistABT:SetActionItem(-1)
				LifeAbility:Lock_Packet_Item(Gemzhuoke_AssistID,0)
				
				local nAssistGemCount = PlayerPackage:Lua_GetUnLockItemCount(Gemzhuoke_AssistID)
				
				if nAssistGemCount > 0 then

					
					local layedAssistGemItem = EnumAction(g_DummySubGemLayed, "Gem_Layed")
					if layedAssistGemItem:GetID() ~= 0 then
						Gemzhuoke_AssistABT:SetActionItem(layedAssistGemItem:GetID())
						LifeAbility:Lock_Packet_Item(Gemzhuoke_AssistID,1)
					end
					
					g_ShowBind = 0
				else
					Gemzhuoke_AssistABT:SetActionItem(-1)
					Gemzhuoke_AssistID = -1
					
					Gemzhuoke_ProductABT:SetActionItem(-1)
					Gemzhuoke_ProductID = -1

					Gemzhuoke_OK:Disable()
					g_ShowBind = 0
				end
			else
				
				Gemzhuoke_AssistABT:SetActionItem(-1)
				
				Gemzhuoke_ProductABT:SetActionItem(-1)
				Gemzhuoke_ProductID = -1

				Gemzhuoke_OK:Disable()
				g_ShowBind = 0
		
			end
		
		else
			Gemzhuoke_MainABT:SetActionItem(-1)
			Gemzhuoke_MainID = -1
			
			Gemzhuoke_AssistABT:SetActionItem(-1)
			if Gemzhuoke_AssistID ~= -1 then
				LifeAbility:Lock_Packet_Item(Gemzhuoke_AssistID,0)			
			end
			Gemzhuoke_AssistID = -1
			
			Gemzhuoke_ProductABT:SetActionItem(-1)
			Gemzhuoke_ProductID = -1

			Gemzhuoke_OK:Disable()
			g_ShowBind = 0
		end
		
	else	

		Gemzhuoke_MainABT:SetActionItem(-1)
		Gemzhuoke_MainID = -1
		
		Gemzhuoke_AssistABT:SetActionItem(-1)
		if Gemzhuoke_AssistID ~= -1 then
			LifeAbility:Lock_Packet_Item(Gemzhuoke_AssistID,0)			
		end
		Gemzhuoke_AssistID = -1
		
		Gemzhuoke_ProductABT:SetActionItem(-1)
		Gemzhuoke_ProductID = -1

		Gemzhuoke_OK:Disable()
		g_ShowBind = 0
		
	end
	
	if Gemzhuoke_MaterPos ~= -1 then
		
		Gemzhuoke_MaterABT:SetActionItem(-1)
		LifeAbility:Lock_Packet_Item(Gemzhuoke_MaterPos, 0)
		
		local itemID = PlayerPackage:GetItemTableIndex(Gemzhuoke_MaterPos)
		--不是需求的物品....
		if itemID ~= g_ZhuoKeFu[1] and itemID ~= g_ZhuoKeFu[2] then
			Gemzhuoke_MaterPos = -1
		else
	
			local theAction = EnumAction(Gemzhuoke_MaterPos, "packageitem")
			if theAction:GetID() ~= 0 then
				Gemzhuoke_MaterABT:SetActionItem(theAction:GetID())
				LifeAbility:Lock_Packet_Item(Gemzhuoke_MaterPos,1)
			else
				Gemzhuoke_MaterPos = -1
			end
		end
	
	else	
		Gemzhuoke_MaterABT:SetActionItem(-1)
		LifeAbility:Lock_Packet_Item(Gemzhuoke_MaterPos, 0)	
	end
	
	Gemzhuoke_LightZhuoKeBTN()

end

function Gemzhuoke_Frame_On_ResetPos()
	Gemzhuoke_Frame:SetProperty("UnifiedPosition", g_Gemzhuoke_Frame_UnifiedPosition)
end

--TAB界面切换
function Gemzhuoke_ChangeTabIndex( nIndex )
	
	if nIndex == 5 or nIndex == 4 or nIndex == 3 then

	end
	
	local nUI = 0
	if 1 == nIndex then
		nUI = 23
	elseif 2 == nIndex then
		nUI = 112236
	elseif 3 == nIndex then
		nUI = 112237
	elseif 4 == nIndex then
		return 0
	elseif 5 == nIndex then
		nUI = 201210121
	elseif 6 == nIndex then
		nUI = 201408140
	end
	if nUI ~= 0 then
		Variable:SetVariable("GemUnionPos", Gemzhuoke_Frame:GetProperty("UnifiedPosition"), 1)
		Variable:SetVariable("GemNPCObjId", tostring(ObjCaredIDID), 1)
		PushEvent("UI_COMMAND", nUI)
		Gemzhuoke_OnHiden()
	end
end

