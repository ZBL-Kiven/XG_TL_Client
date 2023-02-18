--============================================
--宝石系统
--============================================
local theNPC = -1											-- 功能 NPC
local MAX_OBJ_DISTANCE = 3.0

local g_Gemcompose_YuanbaoPay = 1

local g_GemTableIndex = -1
local g_GemTablePos = -1

local g_DummyGemLayed = 0
local g_DummyNewGem = 1

local RuleTable = {
	msgLackMoney = "您身上的金钱不足#{_EXCHG%d}。",
	maxGrade = 9,
	msgGradeLimited = "合成的宝石最高等级为9级，您的宝石不能继续合成。",
	[1] = { SpecialStuff = 30900015, MoneyCost = 5000, CountTable = { [3] = { SuccOdds = 25, SuccOddsWithSpecStuff = 50, }, [4] = { SuccOdds = 50, SuccOddsWithSpecStuff = 75, }, [5] = { SuccOdds = 75, SuccOddsWithSpecStuff = 100, }, }, },
	[2] = { SpecialStuff = 30900015, MoneyCost = 6000, CountTable = { [3] = { SuccOdds = 25, SuccOddsWithSpecStuff = 50, }, [4] = { SuccOdds = 50, SuccOddsWithSpecStuff = 75, }, [5] = { SuccOdds = 75, SuccOddsWithSpecStuff = 100, }, }, },
	[3] = { SpecialStuff = 30900015, MoneyCost = 7000, CountTable = { [3] = { SuccOdds = 25, SuccOddsWithSpecStuff = 50, }, [4] = { SuccOdds = 50, SuccOddsWithSpecStuff = 75, }, [5] = { SuccOdds = 75, SuccOddsWithSpecStuff = 100, }, }, },
	[4] = { SpecialStuff = 30900016, MoneyCost = 8000, CountTable = { [3] = { SuccOdds = 25, SuccOddsWithSpecStuff = 50, }, [4] = { SuccOdds = 50, SuccOddsWithSpecStuff = 75, }, [5] = { SuccOdds = 75, SuccOddsWithSpecStuff = 100, }, }, },
	[5] = { SpecialStuff = 30900016, MoneyCost = 9000, CountTable = { [3] = { SuccOdds = 25, SuccOddsWithSpecStuff = 50, }, [4] = { SuccOdds = 50, SuccOddsWithSpecStuff = 75, }, [5] = { SuccOdds = 75, SuccOddsWithSpecStuff = 100, }, }, },
	[6] = { SpecialStuff = 30900016, MoneyCost = 10000, CountTable = { [3] = { SuccOdds = 25, SuccOddsWithSpecStuff = 50, }, [4] = { SuccOdds = 50, SuccOddsWithSpecStuff = 75, }, [5] = { SuccOdds = 75, SuccOddsWithSpecStuff = 100, }, }, },
	[7] = { SpecialStuff = 30900016, MoneyCost = 11000, CountTable = { [4] = { SuccOdds = 75, SuccOddsWithSpecStuff = 100, }, [5] = { SuccOdds = 75, SuccOddsWithSpecStuff = 100, }, }, },
	[8] = { SpecialStuff = 30900016, MoneyCost = 12000, CountTable = { [3] = { SuccOdds = 25, SuccOddsWithSpecStuff = 50, }, [4] = { SuccOdds = 50, SuccOddsWithSpecStuff = 75, }, [5] = { SuccOdds = 75, SuccOddsWithSpecStuff = 100, }, }, },
}

local g_ActionButton_Gem
local g_ActionButton_GemNew
local g_ActionButton_ComposeItem

local g_Gemcompose_Frame_UnifiedPosition
local npcObjId = -1
local g_GemBagIndex = -1            --待合成宝石索引
local g_ItemBagIndex = -1			--合成符背包索引
local g_ComposeMode = 0				--默认5合1

local g_CurrentOdds = 0

-- 注册事件
function Gemcompose_PreLoad()

	this:RegisterEvent("UI_COMMAND")						--激活界面事件
	this:RegisterEvent("UPDATE_COMPOSE_GEM")			--宝石合成界面放进物品
	this:RegisterEvent("PACKAGE_ITEM_CHANGED",false)			--背包中物品改变需要判断
	this:RegisterEvent("OBJECT_CARED_EVENT",false)				--关注实施合成的NPC
	this:RegisterEvent("RESUME_ENCHASE_GEM",false)				--合成完毕
	this:RegisterEvent("CLOSE_SYNTHESIZE_ENCHASE")			--关闭本界面
	this:RegisterEvent("UNIT_MONEY",false)					--金钱变化
	this:RegisterEvent("MONEYJZ_CHANGE",false)					--交子变化
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	
end

--界面载入
function Gemcompose_OnLoad()
	
	g_ActionButton_Gem = Gemcompose_Space1
	g_ActionButton_GemNew = Gemcompose_Space2
	g_ActionButton_ComposeItem = Gemcompose_Special_Button
	
	g_Gemcompose_YuanbaoPay = 1
	
	g_Gemcompose_Frame_UnifiedPosition=Gemcompose_Frame:GetProperty("UnifiedPosition")
	
    Gemcompose_YuanBaoPay:Hide()
	Gemcompose_YuanBaoPay_TXT:Hide()
	-- Gemcompose_FenYe6:Hide() --
end

--监控各种事件
function Gemcompose_OnEvent(event)
	
	if event == "UI_COMMAND" and tonumber(arg0) == 23 then	--宝石合成
		
		if g_Gemcompose_YuanbaoPay == 1 or g_Gemcompose_YuanbaoPay == 0 then
			Gemcompose_YuanBaoPay:SetCheck(g_Gemcompose_YuanbaoPay)
		end
		Gemcompose_Clear()

		Gemcompose_SuccessValue_Text:SetText("")

		Gemcompose_Info:SetText("#{BSQHB_120830_01}")
		Gemcompose_Static1:Show()
		Gemcompose_Special:Show()
		
		local GemUnionPos = Variable:GetVariable("GemUnionPos")
		if(GemUnionPos ~= nil) then
		  Gemcompose_Frame:SetProperty("UnifiedPosition", GemUnionPos)
		end
		-- Gemcompose_FenYe1:SetCheck(1)
		this:Show()

		npcObjId = Get_XParam_INT( 0 ) --服务端注意参数传递
		Gemcompose_BeginCareObject( npcObjId )
		Gemcompose_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
		Gemcompose_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
		
		Gemcompose_Special_Choice:ResetList()
		
		Gemcompose_Special_Choice:AddTextItem("五合一",0)
		Gemcompose_Special_Choice:AddTextItem("四合一",1)
		Gemcompose_Special_Choice:AddTextItem("三合一",2)
		Gemcompose_Special_Choice:SetCurrentSelect(0)
		return
	end

	if event == "OBJECT_CARED_EVENT" and this : IsVisible() then
		if tonumber( arg0 ) ~= theNPC then
			return
		end

		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if arg1 == "distance" and tonumber( arg2 ) > MAX_OBJ_DISTANCE or arg1 == "destroy" then
			Gemcompose_Cancel_Clicked()
		end
		Gemcompose_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
		Gemcompose_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
		return
	end

	if event == "UPDATE_COMPOSE_GEM" and this:IsVisible() then
		if not arg0 or tonumber(arg0) == -1 then
			return
		end
		Gemcompose_Update(arg0, arg1)
		Gemcompose_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
		Gemcompose_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
		return
	end
	
	if (event == "UI_COMMAND" and tonumber(arg0) == 201107281 and this:IsVisible()) then
		--Gemcompose_Clear() --fixed Sunyan 20181201
		if not arg0 or tonumber(arg0) == -1 then
			return
		end
		Gemcompose_Update(0, arg1)
		Gemcompose_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
		Gemcompose_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
		return
	end

	if event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() then
		
		if not arg0 or tonumber(arg0) == -1 then
			return
		end
		
		--Gemcompose_RefreshItem(arg0)

		Gemcompose_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
		Gemcompose_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
		return
	end

	if event == "RESUME_ENCHASE_GEM" and this : IsVisible() then
		if arg0 then
			Gemcompose_Remove( tonumber( arg0 ) - 6 )
		end
		return
	end

	if event == "CLOSE_SYNTHESIZE_ENCHASE" and this : IsVisible() then
		Gemcompose_Cancel_Clicked()
		Gemcompose_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
		return
	end
	
	if event == "UNIT_MONEY" and this:IsVisible() then
		Gemcompose_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
		return
	end
	
	if event == "MONEYJZ_CHANGE_EX" and this:IsVisible() then
		Gemcompose_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
		return
	end
	
	if event == "ADJEST_UI_POS" then
		Gemcompose_Frame_On_ResetPos()
		return
	end
	
	if event == "VIEW_RESOLUTION_CHANGED" then
		Gemcompose_Frame_On_ResetPos()
		return
	end
	
end

--点击合成按钮
function Gemcompose_OK_Clicked()
	
	--根据当前所处的界面进行检查
	local Notify = 0
	
	if g_GemTableIndex == -1 then
		return
	end
	
	--local nGemCount = PlayerPackage:Lua_GetUnLockItemCount(g_GemTableIndex)
	local nGemLevel = Gemcompose_GetGemLevel(g_GemTableIndex)
	
	--检查材料是否是最高等级
	if nGemLevel >= RuleTable.maxGrade then
		PushDebugMessage( RuleTable.msgGradeLimited )
		return
	end
	
	--合成8，9级宝石功能关闭；放开8级宝石。[LiChengjie]
	if nGemLevel > 8 then
		PushDebugMessage( "#{BSHC_090313_1}" )
		return
	end
	
	local _,nSel = Gemcompose_Special_Choice:GetCurrentSelect()
	
	-- 检查身上的金钱是否足够
	local selfMoney = Player : GetData( "MONEY" ) + Player : GetData( "MONEY_JZ" )
	if selfMoney < RuleTable[nGemLevel].MoneyCost then
		PushDebugMessage( string.format( RuleTable.msgLackMoney, RuleTable[nGemLevel].MoneyCost ) )
		return
	end
	--if g_GemTablePos == -1 or g_ItemBagIndex == -1 then
	--	PushDebugMessage( "请放入所需的材料！" )
	--	return
	--end
	--if tonumber(g_CurrentOdds) ~= 100 then
		--PushEvent("UI_COMMAND",201812021,g_GemTablePos,g_ItemBagIndex,nSel,g_CurrentOdds)
	--else
	--	Gemcompose_Clear() --先清除，防止服务器延时
	    Gemcompose_ClearNew()
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("GemCompose");
			Set_XSCRIPT_ScriptID(900011);
			Set_XSCRIPT_Parameter(0,tonumber(g_GemTablePos));
			Set_XSCRIPT_Parameter(1,tonumber(g_ItemBagIndex));
			Set_XSCRIPT_Parameter(2,tonumber(nSel));
			Set_XSCRIPT_Parameter(3,tonumber(g_CurrentOdds));
			Set_XSCRIPT_ParamCount(4);
		Send_XSCRIPT();
	--end
	Gemcompose_Clear()
	--LifeAbility:Do_Combine(g_GemTableIndex,g_ItemBagIndex,nSel,g_CurrentOdds)
end
function Gemcompose_OK_Clicked_II(g_GemTablePos,g_ItemBagIndex,nSel,g_CurrentOdds)
	--暂时废除
--	Gemcompose_Clear() --先清除，防止服务器延时
--	Clear_XSCRIPT();
--		Set_XSCRIPT_Function_Name("XYJCall");
--		Set_XSCRIPT_ScriptID(990000);
--		Set_XSCRIPT_Parameter(0,tonumber(2009));
--		Set_XSCRIPT_Parameter(1,tonumber(g_GemTablePos));
--		Set_XSCRIPT_Parameter(2,tonumber(g_ItemBagIndex));
--		Set_XSCRIPT_Parameter(3,tonumber(nSel));
--		Set_XSCRIPT_Parameter(4,tonumber(g_CurrentOdds));
--		Set_XSCRIPT_ParamCount(5);
--	Send_XSCRIPT();
end
--点击取消或者关闭按钮
function Gemcompose_Cancel_Clicked()
	Gemcompose_Close()
	Gemcompose_StopCareObject()
end

--关闭界面
function Gemcompose_Close()
	Gemcompose_Clear()
	this:Hide()
end

--清空界面元素
function Gemcompose_Clear()

	--g_Gemcompose_YuanbaoPay = Gemcompose_YuanBaoPay:GetCheck()

	Gemcompose_SuccessValue_Text:SetText("")
	Gemcompose_NeedMoney:SetProperty( "MoneyNumber", "0" )

	g_ActionButton_Gem:SetActionItem(-1)
	g_ActionButton_GemNew:SetActionItem(-1)
	g_ActionButton_ComposeItem:SetActionItem(-1)
	
	if g_ItemBagIndex ~=  -1 then
		LifeAbility:Lock_Packet_Item(g_ItemBagIndex,0)
		g_ItemBagIndex = -1
	end
	--fix 001576 Sunyan 20181130
	if g_GemBagIndex ~= -1 then
	    LifeAbility:Lock_Packet_Item(g_GemBagIndex,0)
		g_GemBagIndex = -1
	end
	--g_GemTablePos = -1
    --g_ItemBagIndex = -1
end
function Gemcompose_ClearNew()

	g_ActionButton_Gem:SetActionItem(-1)
	g_ActionButton_GemNew:SetActionItem(-1)
	g_ActionButton_ComposeItem:SetActionItem(-1)
	
	if g_ItemBagIndex ~=  -1 then
		LifeAbility:Lock_Packet_Item(g_ItemBagIndex,0)
	end
	--fix 001576 Sunyan 20181130
	if g_GemBagIndex ~= -1 then
	    LifeAbility:Lock_Packet_Item(g_GemBagIndex,0)
	end
end

--得到当前界面应该匹配的特殊材料号
--如果不是宝石界面则返回 -1
--如果是宝石界面但是还没有放任何宝石则返回 -1
function Gemcompose_GetSpecialMaterial()
	
	if g_GemTableIndex == -1 then
		return -1
	end
	
	local nGemLevel = Gemcompose_GetGemLevel(g_GemTableIndex)

	if RuleTable[nGemLevel] ~= nil then
		return RuleTable[nGemLevel].SpecialStuff
	end

	return -1
end

--是不是合成符
function Gemcompose_IsComposeItem(bagPos)
	
	local nItemTableIndex =  PlayerPackage:GetItemTableIndex(bagPos)
	if nItemTableIndex == 30900015 or nItemTableIndex == 30900016 or nItemTableIndex == 30900128 then
		return 1
	end
	
	return 0
	
end

--刷新合成界面上的物品
function Gemcompose_Update(pos0, pos1)
	local bagPos = tonumber(pos1)
	if bagPos == -1 then
		return
	end
	--验证物品有效性
--	local bagItem = EnumAction(bagPos, "packageitem")
--	if bagItem:GetID() == 0 then
--		return
--	end
		
	if PlayerPackage:IsGem(bagPos) == 1 then
		Gemcompose_Clear()
		Gemcompose_PutInGem(bagPos)
	elseif Gemcompose_IsComposeItem(bagPos) == 1 then
		Gemcompose_PutInComposeItem(bagPos)
	else
		PushDebugMessage("#{BSQHB_120830_03}")
		return
	end

end

--往宝石框放入一个物品
function Gemcompose_PutInGem(bagPos)
	
	if Gemcompose_IsComposeItem(bagPos) == 1 then
		PushDebugMessage("#{BSQHB_120830_09}")		--请放入宝石合成符框
		return
	elseif PlayerPackage:IsGem(bagPos) ~= 1 then
		PushDebugMessage("#{BSQHB_120830_03}")		--材料类型不符
		return
	end
	
	local gemItem = EnumAction(bagPos, "packageitem")
	if gemItem:GetID() == 0 then
		return
	end
	
	g_ActionButton_Gem:SetActionItem(-1)
	g_ActionButton_GemNew:SetActionItem(-1)
	
	if g_GemTableIndex ~= -1 then
		LifeAbility:Lock_Packet_Item(bagPos,0)
		g_GemTableIndex = -1
	end
	
	local nItemTableIndex =  PlayerPackage:GetItemTableIndex(bagPos)
	if math.mod(math.floor(nItemTableIndex/100000),10) == 9 then
	   PushDebugMessage("宝石等级已经达到最高级")
	   return
	end
	--DataPool:Lua_GemComposeLayedItem_Update(nItemTableIndex)
	g_GemBagIndex = bagPos --fix 20181130 SUNYAN
	local layedGemItem = EnumAction(bagPos, "packageitem")
	if layedGemItem:GetID() ~= 0 then
		g_ActionButton_Gem:SetActionItem(layedGemItem:GetID())
		LifeAbility:Lock_Packet_Item(bagPos,1)
		g_GemTableIndex = nItemTableIndex
		g_GemTablePos = bagPos
	end
	local NewGemID = PlayerPackage:GetItemTableIndex(bagPos)
	local nNewGemData_1 = tostring(math.mod(NewGemID,10000))	
	local nNewGemData_2 = tostring(math.floor(NewGemID/10000) + 10)
	if math.mod(math.floor(NewGemID/1000),100) == 21  then
		if math.mod(NewGemID,1000)>10 then  --潇湘QQ1400003003
			nNewGemData_1 = tostring(math.mod(NewGemID,10000)+1)
		end
	end	
	NewGemID = tonumber(nNewGemData_2..nNewGemData_1)
	local newGemItem = GemMelting:UpdateProductAction(NewGemID)
	if newGemItem:GetID() ~= 0 then
		g_ActionButton_GemNew:SetActionItem(newGemItem:GetID())
	end
	
	if g_ItemBagIndex ~= -1 then
	
		local nComposeItemTableIndex = PlayerPackage:GetItemTableIndex(g_ItemBagIndex)
		
		if Gemcompose_GetSpecialMaterial() ~= nComposeItemTableIndex then
			
			g_ActionButton_ComposeItem:SetActionItem(-1)
			LifeAbility:Lock_Packet_Item(bagPos,0)
			g_ItemBagIndex = -1

		end
	end
	
	if nGemLevel == 9 then
		Gemcompose_Special_Choice:SetCurrentSelect(1)
	else
		Gemcompose_Special_Choice:SetCurrentSelect(0)
	end
	
	--LifeAbility:Lua_SetGemComposeNotify(1)
	
	Gemcompose_RecalcCost()
	Gemcompose_RecalcSuccOdds()
	
end

--往宝石合成符框放入一个物品
function Gemcompose_PutInComposeItem(bagPos)
	
	if PlayerPackage:IsGem(bagPos) == 1 then
		PushDebugMessage("#{BSQHB_120830_08}")		--请放入宝石框中
		return
	elseif Gemcompose_IsComposeItem(bagPos) ~= 1 then
		PushDebugMessage("#{BSQHB_120830_03}")		--材料类型不符
		return
	end
	
	local composeItem = EnumAction(bagPos, "packageitem")
	if composeItem:GetID() == 0 then
		return
	end
	
	if g_GemTableIndex == -1 then
		PushDebugMessage("#{BSQHB_120830_06}")	--请先放入宝石
		return		
	end
	
	local nGemLevel = Gemcompose_GetGemLevel(g_GemTableIndex)
	local nComposeItemTableIndex = PlayerPackage:GetItemTableIndex(bagPos)
	
	if Gemcompose_GetSpecialMaterial() == -1 then
		PushDebugMessage("#{BSQHB_120830_06}")	--请先放入宝石
		return	
	elseif Gemcompose_GetSpecialMaterial() ~= nComposeItemTableIndex then
		
		if nGemLevel < 4 then
			PushDebugMessage( "#{BSQHB_120830_12}" )
		elseif nGemLevel < 7 then
			PushDebugMessage( "#{BSQHB_120830_13}" )
		elseif nGemLevel < 8 then
			PushDebugMessage( "#{BSQHB_120830_02}" )
		end
		return
	end
	
	if g_ItemBagIndex == -1 then
		
		g_ActionButton_ComposeItem:SetActionItem(composeItem:GetID())
		g_ItemBagIndex = bagPos
		LifeAbility:Lock_Packet_Item(g_ItemBagIndex, 1)	
		
	else
	
		g_ActionButton_ComposeItem:SetActionItem(-1)
		LifeAbility:Lock_Packet_Item(g_ItemBagIndex,0)
		
		g_ActionButton_ComposeItem:SetActionItem(composeItem:GetID())
		g_ItemBagIndex = bagPos
		LifeAbility:Lock_Packet_Item(g_ItemBagIndex, 1)
	end
	
	--LifeAbility:Lua_SetGemComposeNotify(1)
	
	Gemcompose_RecalcSuccOdds()
	
end

function Gemcompose_Special_ChoiceChanged()
	
	local _,nSel = Gemcompose_Special_Choice:GetCurrentSelect()
	
	if g_GemTableIndex ~= -1 then
	
		local nGemLevel = Gemcompose_GetGemLevel(g_GemTableIndex)
		if nGemLevel == 7 and nSel ~= 1 then
			PushDebugMessage("#{BSDJ_170811_07}")		--合成8级宝石只能使用四合一模式
			Gemcompose_Special_Choice:SetCurrentSelect(1)
			return
		end		
	end
	
	--LifeAbility:Lua_SetGemComposeNotify(1)
	
	Gemcompose_RecalcSuccOdds()

end

--移除一个材料
function Gemcompose_Remove(slot)
	
	if slot == 1 then
	
		Gemcompose_Clear()
		
	elseif slot == 2 then
	
		g_ActionButton_ComposeItem:SetActionItem(-1)
		if g_ItemBagIndex ~=  -1 then
			LifeAbility:Lock_Packet_Item(g_ItemBagIndex,0)
			g_ItemBagIndex = -1
		end
		
		--LifeAbility:Lua_SetGemComposeNotify(1)
		
		Gemcompose_RecalcCost()
		Gemcompose_RecalcSuccOdds()
	end	
	
end

--重新计算合成概率
function Gemcompose_RecalcSuccOdds()
	
	g_CurrentOdds = 0
	
	if g_GemTableIndex == -1 then
		Gemcompose_SuccessValue_Text:SetText("")
		return
	end	
	
	local nGemLevel = Gemcompose_GetGemLevel(g_GemTableIndex)
	local nGemCount = 5

	local str = "#cFF0000"
	
	local _,nSel = Gemcompose_Special_Choice:GetCurrentSelect()
	
	if nSel == 0 and RuleTable[nGemLevel] ~= nil and RuleTable[nGemLevel].CountTable[5] ~= nil then
		
		if nGemCount < 5 then
			Gemcompose_SuccessValue_Text:SetText("#{BSDJ_170811_37}")
		else
		
			local nOdds = RuleTable[nGemLevel].CountTable[5].SuccOdds
			
			if g_ItemBagIndex ~= -1 then
				nOdds = RuleTable[nGemLevel].CountTable[5].SuccOddsWithSpecStuff
			end
			str = str..tostring(nOdds).."%"
			
			Gemcompose_SuccessValue_Text:SetText(str)
			
			g_CurrentOdds = nOdds
		end
		
	elseif nSel == 1 and RuleTable[nGemLevel].CountTable[4] ~= nil  then
		
		if nGemCount < 4 then		
			Gemcompose_SuccessValue_Text:SetText("#{BSDJ_170811_37}")
		else
			local nOdds = RuleTable[nGemLevel].CountTable[4].SuccOdds
			
			if g_ItemBagIndex ~= -1 then
				nOdds = RuleTable[nGemLevel].CountTable[4].SuccOddsWithSpecStuff
			end
			str = str..tostring(nOdds).."%"
			
			Gemcompose_SuccessValue_Text:SetText(str)
			
			g_CurrentOdds = nOdds
		end
	
	elseif nSel == 2 and RuleTable[nGemLevel].CountTable[3] ~= nil then
	
		if nGemCount < 3 then
			Gemcompose_SuccessValue_Text:SetText("#{BSDJ_170811_37}")
		else
		
			local nOdds = RuleTable[nGemLevel].CountTable[3].SuccOdds
			
			if g_ItemBagIndex ~= -1 then
				nOdds = RuleTable[nGemLevel].CountTable[3].SuccOddsWithSpecStuff
			end
			str = str..tostring(nOdds).."%"
			
			Gemcompose_SuccessValue_Text:SetText(str)
			
			g_CurrentOdds = nOdds
		end
	end	
end

--重新计算金钱消耗
function Gemcompose_RecalcCost()
	
	if g_GemTableIndex == -1 then
		Gemcompose_NeedMoney:SetProperty("MoneyNumber", "0")
		return 
	end

	local nGemLevel = Gemcompose_GetGemLevel(g_GemTableIndex)

	if RuleTable[nGemLevel] ~= nil then
		Gemcompose_NeedMoney:SetProperty("MoneyNumber", tostring(RuleTable[nGemLevel].MoneyCost) )
		return
	end

	Gemcompose_NeedMoney:SetProperty("MoneyNumber", "0")
end

function Gemcompose_RefreshItem(bagPos)
		
	if g_GemTableIndex ~= -1 then
		
		g_ActionButton_Gem:SetActionItem(-1)
		g_ActionButton_GemNew:SetActionItem(-1)
		LifeAbility:Lock_Packet_Item(g_ItemBagIndex,0)
	
		--DataPool:Lua_GemComposeLayedItem_Update(g_GemTableIndex)

		local layedGemItem = EnumAction(bagPos, "packageitem")
		if layedGemItem:GetID() ~= 0 then
			g_ActionButton_Gem:SetActionItem(layedGemItem:GetID())
			LifeAbility:Lock_Packet_Item(g_ItemBagIndex,1)
		end
        local NewGemID = PlayerPackage:GetItemTableIndex(bagPos)
		local nNewGemData_1 = tostring(math.mod(NewGemID,10000))
		local nNewGemData_2 = tostring(math.floor(NewGemID/10000) + 10)
		NewGemID = tonumber(nNewGemData_2..nNewGemData_1)
		local newGemItem = GemMelting:UpdateProductAction(tonumber(NewGemID))
		if newGemItem:GetID() ~= 0 then
			g_ActionButton_GemNew:SetActionItem(newGemItem:GetID())
		end		
		
		if g_ItemBagIndex ~=  -1 then
			
			local nComposeItemTableIndex = PlayerPackage:GetItemTableIndex(g_ItemBagIndex)
			
			if Gemcompose_GetSpecialMaterial() ~= nComposeItemTableIndex then
				g_ActionButton_ComposeItem:SetActionItem(-1)
				LifeAbility:Lock_Packet_Item(g_ItemBagIndex,0)
				g_ItemBagIndex = -1
			end
		end
		
		Gemcompose_RecalcCost()
		Gemcompose_RecalcSuccOdds()
	
	end

end

function Gemcompose_GetGemLevel(nSN)
	
	if nSN < 0 then
		return 0
	end

	local nLevel = math.floor(math.mod(nSN,10000000) / 100000)
	return nLevel

end
--=========================================================
--开始关心NPC，
--在开始关心之前需要先确定这个界面是不是已经有“关心”的NPC，
--如果有的话，先取消已经有的“关心”
--=========================================================
function Gemcompose_BeginCareObject( objCaredId )
	theNPC = DataPool : GetNPCIDByServerID( objCaredId )
	-- AxTrace( 0, 1, "theNPC0: " .. theNPC )
	if theNPC == -1 then
		PushDebugMessage("未发现 NPC")
		this : Hide()
		g_Gemcompose_YuanbaoPay = Gemcompose_YuanBaoPay:GetCheck()
		return
	end

	this : CareObject( theNPC, 1, "Gemcompose" )
end

--=========================================================
--停止对某NPC的关心
--=========================================================
function Gemcompose_StopCareObject()
	this : CareObject( theNPC, 0, "Gemcompose" )
	theNPC = -1
end

function Gemcompose_Help_Clicked()
	Helper:GotoHelper("*Gemcompose")
end

function Gemcompose_Frame_On_ResetPos()
  Gemcompose_Frame:SetProperty("UnifiedPosition", g_Gemcompose_Frame_UnifiedPosition)
end

--TAB界面切换，界面名字太坑了
function Gemcompose_ChangeTabIndex( nIndex )
	if nIndex == nil then
		return
	end
	
	local nUI = 0
	if 1 == nIndex then
		return
	elseif 2 == nIndex then
		nUI = 112236
	elseif 3 == nIndex then
		nUI = 112237
	elseif 4 == nIndex then
		nUI = 201210120
	elseif 5 == nIndex then
		nUI = 27
	elseif 6 == nIndex then
		nUI = 201408140
	end
	if nUI ~= 0 then
		Variable:SetVariable("GemUnionPos", Gemcompose_Frame:GetProperty("UnifiedPosition"), 1)
		Variable:SetVariable("GemNPCObjId", tostring(npcObjId), 1)
		PushEvent("UI_COMMAND", nUI)
		Gemcompose_Close()
	end
end

function Gemcompose_Yuanbao_Click()

end
