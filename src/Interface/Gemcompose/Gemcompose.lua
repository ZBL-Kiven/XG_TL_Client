--============================================
--��ʯϵͳ
--============================================
local theNPC = -1											-- ���� NPC
local MAX_OBJ_DISTANCE = 3.0

local g_Gemcompose_YuanbaoPay = 1

local g_GemTableIndex = -1
local g_GemTablePos = -1

local g_DummyGemLayed = 0
local g_DummyNewGem = 1

local RuleTable = {
	msgLackMoney = "�����ϵĽ�Ǯ����#{_EXCHG%d}��",
	maxGrade = 9,
	msgGradeLimited = "�ϳɵı�ʯ��ߵȼ�Ϊ9�������ı�ʯ���ܼ����ϳɡ�",
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
local g_GemBagIndex = -1            --���ϳɱ�ʯ����
local g_ItemBagIndex = -1			--�ϳɷ���������
local g_ComposeMode = 0				--Ĭ��5��1

local g_CurrentOdds = 0

-- ע���¼�
function Gemcompose_PreLoad()

	this:RegisterEvent("UI_COMMAND")						--��������¼�
	this:RegisterEvent("UPDATE_COMPOSE_GEM")			--��ʯ�ϳɽ���Ž���Ʒ
	this:RegisterEvent("PACKAGE_ITEM_CHANGED",false)			--��������Ʒ�ı���Ҫ�ж�
	this:RegisterEvent("OBJECT_CARED_EVENT",false)				--��עʵʩ�ϳɵ�NPC
	this:RegisterEvent("RESUME_ENCHASE_GEM",false)				--�ϳ����
	this:RegisterEvent("CLOSE_SYNTHESIZE_ENCHASE")			--�رձ�����
	this:RegisterEvent("UNIT_MONEY",false)					--��Ǯ�仯
	this:RegisterEvent("MONEYJZ_CHANGE",false)					--���ӱ仯
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	
end

--��������
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

--��ظ����¼�
function Gemcompose_OnEvent(event)
	
	if event == "UI_COMMAND" and tonumber(arg0) == 23 then	--��ʯ�ϳ�
		
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

		npcObjId = Get_XParam_INT( 0 ) --�����ע���������
		Gemcompose_BeginCareObject( npcObjId )
		Gemcompose_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
		Gemcompose_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
		
		Gemcompose_Special_Choice:ResetList()
		
		Gemcompose_Special_Choice:AddTextItem("���һ",0)
		Gemcompose_Special_Choice:AddTextItem("�ĺ�һ",1)
		Gemcompose_Special_Choice:AddTextItem("����һ",2)
		Gemcompose_Special_Choice:SetCurrentSelect(0)
		return
	end

	if event == "OBJECT_CARED_EVENT" and this : IsVisible() then
		if tonumber( arg0 ) ~= theNPC then
			return
		end

		--�����NPC�ľ������һ��������߱�ɾ�����Զ��ر�
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

--����ϳɰ�ť
function Gemcompose_OK_Clicked()
	
	--���ݵ�ǰ�����Ľ�����м��
	local Notify = 0
	
	if g_GemTableIndex == -1 then
		return
	end
	
	--local nGemCount = PlayerPackage:Lua_GetUnLockItemCount(g_GemTableIndex)
	local nGemLevel = Gemcompose_GetGemLevel(g_GemTableIndex)
	
	--�������Ƿ�����ߵȼ�
	if nGemLevel >= RuleTable.maxGrade then
		PushDebugMessage( RuleTable.msgGradeLimited )
		return
	end
	
	--�ϳ�8��9����ʯ���ܹرգ��ſ�8����ʯ��[LiChengjie]
	if nGemLevel > 8 then
		PushDebugMessage( "#{BSHC_090313_1}" )
		return
	end
	
	local _,nSel = Gemcompose_Special_Choice:GetCurrentSelect()
	
	-- ������ϵĽ�Ǯ�Ƿ��㹻
	local selfMoney = Player : GetData( "MONEY" ) + Player : GetData( "MONEY_JZ" )
	if selfMoney < RuleTable[nGemLevel].MoneyCost then
		PushDebugMessage( string.format( RuleTable.msgLackMoney, RuleTable[nGemLevel].MoneyCost ) )
		return
	end
	--if g_GemTablePos == -1 or g_ItemBagIndex == -1 then
	--	PushDebugMessage( "���������Ĳ��ϣ�" )
	--	return
	--end
	--if tonumber(g_CurrentOdds) ~= 100 then
		--PushEvent("UI_COMMAND",201812021,g_GemTablePos,g_ItemBagIndex,nSel,g_CurrentOdds)
	--else
	--	Gemcompose_Clear() --���������ֹ��������ʱ
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
	--��ʱ�ϳ�
--	Gemcompose_Clear() --���������ֹ��������ʱ
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
--���ȡ�����߹رհ�ť
function Gemcompose_Cancel_Clicked()
	Gemcompose_Close()
	Gemcompose_StopCareObject()
end

--�رս���
function Gemcompose_Close()
	Gemcompose_Clear()
	this:Hide()
end

--��ս���Ԫ��
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

--�õ���ǰ����Ӧ��ƥ���������Ϻ�
--������Ǳ�ʯ�����򷵻� -1
--����Ǳ�ʯ���浫�ǻ�û�з��κα�ʯ�򷵻� -1
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

--�ǲ��Ǻϳɷ�
function Gemcompose_IsComposeItem(bagPos)
	
	local nItemTableIndex =  PlayerPackage:GetItemTableIndex(bagPos)
	if nItemTableIndex == 30900015 or nItemTableIndex == 30900016 or nItemTableIndex == 30900128 then
		return 1
	end
	
	return 0
	
end

--ˢ�ºϳɽ����ϵ���Ʒ
function Gemcompose_Update(pos0, pos1)
	local bagPos = tonumber(pos1)
	if bagPos == -1 then
		return
	end
	--��֤��Ʒ��Ч��
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

--����ʯ�����һ����Ʒ
function Gemcompose_PutInGem(bagPos)
	
	if Gemcompose_IsComposeItem(bagPos) == 1 then
		PushDebugMessage("#{BSQHB_120830_09}")		--����뱦ʯ�ϳɷ���
		return
	elseif PlayerPackage:IsGem(bagPos) ~= 1 then
		PushDebugMessage("#{BSQHB_120830_03}")		--�������Ͳ���
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
	   PushDebugMessage("��ʯ�ȼ��Ѿ��ﵽ��߼�")
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
		if math.mod(NewGemID,1000)>10 then  --����QQ1400003003
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

--����ʯ�ϳɷ������һ����Ʒ
function Gemcompose_PutInComposeItem(bagPos)
	
	if PlayerPackage:IsGem(bagPos) == 1 then
		PushDebugMessage("#{BSQHB_120830_08}")		--����뱦ʯ����
		return
	elseif Gemcompose_IsComposeItem(bagPos) ~= 1 then
		PushDebugMessage("#{BSQHB_120830_03}")		--�������Ͳ���
		return
	end
	
	local composeItem = EnumAction(bagPos, "packageitem")
	if composeItem:GetID() == 0 then
		return
	end
	
	if g_GemTableIndex == -1 then
		PushDebugMessage("#{BSQHB_120830_06}")	--���ȷ��뱦ʯ
		return		
	end
	
	local nGemLevel = Gemcompose_GetGemLevel(g_GemTableIndex)
	local nComposeItemTableIndex = PlayerPackage:GetItemTableIndex(bagPos)
	
	if Gemcompose_GetSpecialMaterial() == -1 then
		PushDebugMessage("#{BSQHB_120830_06}")	--���ȷ��뱦ʯ
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
			PushDebugMessage("#{BSDJ_170811_07}")		--�ϳ�8����ʯֻ��ʹ���ĺ�һģʽ
			Gemcompose_Special_Choice:SetCurrentSelect(1)
			return
		end		
	end
	
	--LifeAbility:Lua_SetGemComposeNotify(1)
	
	Gemcompose_RecalcSuccOdds()

end

--�Ƴ�һ������
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

--���¼���ϳɸ���
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

--���¼����Ǯ����
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
--��ʼ����NPC��
--�ڿ�ʼ����֮ǰ��Ҫ��ȷ����������ǲ����Ѿ��С����ġ���NPC��
--����еĻ�����ȡ���Ѿ��еġ����ġ�
--=========================================================
function Gemcompose_BeginCareObject( objCaredId )
	theNPC = DataPool : GetNPCIDByServerID( objCaredId )
	-- AxTrace( 0, 1, "theNPC0: " .. theNPC )
	if theNPC == -1 then
		PushDebugMessage("δ���� NPC")
		this : Hide()
		g_Gemcompose_YuanbaoPay = Gemcompose_YuanBaoPay:GetCheck()
		return
	end

	this : CareObject( theNPC, 1, "Gemcompose" )
end

--=========================================================
--ֹͣ��ĳNPC�Ĺ���
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

--TAB�����л�����������̫����
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
