
local theNPC = -1											-- ���� NPC
local MAX_OBJ_DISTANCE = 3.0

local g_Gemcompose_YuanbaoPay = 1

local g_GemTableIndex = -1

local g_DummyGemLayed = 0
local g_DummyNewGem = 1

local RuleTable = {
	msgLackMoney = "�����ϵĽ�Ǯ����#{_EXCHG%d}��",
	maxGrade = 9,
	msgGradeLimited = "�ϳɵı�ʯ��ߵȼ�Ϊ7�������ı�ʯ���ܼ����ϳɡ�",
	[1] = { SpecialStuff = 30900015, MoneyCost = 5000, CountTable = { [3] = { SuccOdds = 25, SuccOddsWithSpecStuff = 50, }, [4] = { SuccOdds = 50, SuccOddsWithSpecStuff = 75, }, [5] = { SuccOdds = 75, SuccOddsWithSpecStuff = 100, }, }, },
	[2] = { SpecialStuff = 30900015, MoneyCost = 6000, CountTable = { [3] = { SuccOdds = 25, SuccOddsWithSpecStuff = 50, }, [4] = { SuccOdds = 50, SuccOddsWithSpecStuff = 75, }, [5] = { SuccOdds = 75, SuccOddsWithSpecStuff = 100, }, }, },
	[3] = { SpecialStuff = 30900015, MoneyCost = 7000, CountTable = { [3] = { SuccOdds = 25, SuccOddsWithSpecStuff = 50, }, [4] = { SuccOdds = 50, SuccOddsWithSpecStuff = 75, }, [5] = { SuccOdds = 75, SuccOddsWithSpecStuff = 100, }, }, },
	[4] = { SpecialStuff = 30900015, MoneyCost = 8000, CountTable = { [3] = { SuccOdds = 25, SuccOddsWithSpecStuff = 50, }, [4] = { SuccOdds = 50, SuccOddsWithSpecStuff = 75, }, [5] = { SuccOdds = 75, SuccOddsWithSpecStuff = 100, }, }, },
	[5] = { SpecialStuff = 30900016, MoneyCost = 9000, CountTable = { [3] = { SuccOdds = 25, SuccOddsWithSpecStuff = 50, }, [4] = { SuccOdds = 50, SuccOddsWithSpecStuff = 75, }, [5] = { SuccOdds = 75, SuccOddsWithSpecStuff = 100, }, }, },
	[6] = { SpecialStuff = 30900016, MoneyCost = 10000, CountTable = { [3] = { SuccOdds = 25, SuccOddsWithSpecStuff = 50, }, [4] = { SuccOdds = 50, SuccOddsWithSpecStuff = 75, }, [5] = { SuccOdds = 75, SuccOddsWithSpecStuff = 100, }, }, },
	[7] = { SpecialStuff = 30900016, MoneyCost = 11000, CountTable = { [4] = { SuccOdds = 25, SuccOddsWithSpecStuff = 50, }, [5] = { SuccOdds = 50, SuccOddsWithSpecStuff = 75, }, [5] = { SuccOdds = 75, SuccOddsWithSpecStuff = 100, }, }, },

}

local g_ActionButton_Gem
local g_ActionButton_GemNew
local g_ActionButton_ComposeItem

local g_Gemcompose_Frame_UnifiedPosition
local npcObjId = -1

local g_ItemBagIndex = -1			--�ϳɷ���������
local g_ComposeMode = 0				--Ĭ��5��1

local g_CurrentOdds = 0

-- ע���¼�
function MaterialCompound_PreLoad()
	this:RegisterEvent("UI_COMMAND")						-- ��������¼�

	this:RegisterEvent("UPDATE_COMPOSE_GEM")				-- ˢ�±�ʯ�ϳɽ���
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")				-- ��������Ʒ�ı���Ҫ�жϡ���
	this:RegisterEvent("OBJECT_CARED_EVENT")				-- ��עʵʩ�ϳɵ� NPC
	this:RegisterEvent("RESUME_ENCHASE_GEM")				-- �ϳ����
	this:RegisterEvent("CLOSE_SYNTHESIZE_ENCHASE")			-- �رձ�����
	-- this:RegisterEvent("TOGLE_SKILL_BOOK")				-- �����ɼ��ܽ����Ƿ���Ҫ�رմ˽���
	-- this:RegisterEvent("TOGLE_COMMONSKILL_PAGE")			-- ����ͨ���ܽ����Ƿ���Ҫ�رգ�
	-- this:RegisterEvent("CLOSE_SKILL_BOOK")				-- �ر����ɼ��ܽ���
	-- this:RegisterEvent("DISABLE_ENCHASE_ALL_GEM")		-- ���кϳ���ص���Ʒ��Ҫ����
	-- this:RegisterEvent("UPDATE_COMPOSE_ITEM")			-- ��Ʒ�ϳɽ���򿪣��˽����Ƿ���Ҫ�رգ�
	-- this:RegisterEvent("OPEN_COMPOSE_ITEM")				-- ��Ʒ�ϳɽ���򿪣��˽����Ƿ���Ҫ�رգ�
	this:RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("MONEYJZ_CHANGE")		--�����ռ� Vega
end



--��������
function MaterialCompound_OnLoad()
	
	g_ActionButton_Gem = Gemcompose_Space1
	g_ActionButton_GemNew = Gemcompose_Space2
	g_ActionButton_ComposeItem = Gemcompose_Special_Button
	
	g_Gemcompose_YuanbaoPay = 1
	
	g_Gemcompose_Frame_UnifiedPosition=Gemcompose_Frame:GetProperty("UnifiedPosition")

end

--��ظ����¼�
function MaterialCompound_OnEvent( event )
	
	if event == "UI_COMMAND" and tonumber(arg0) == 23 then	--��ʯ�ϳ�
		
		if g_Gemcompose_YuanbaoPay == 1 or g_Gemcompose_YuanbaoPay == 0 then
			Gemcompose_YuanBaoPay:SetCheck(g_Gemcompose_YuanbaoPay)
		end
		Gemcompose_Clear()

		Gemcompose_SuccessValue_Text:SetText("")

		-- Gemcompose_Info:SetText("#{BSQHB_120830_01}")
		Gemcompose_Static1:Show()
		Gemcompose_Special:Show()
		
		local GemUnionPos = Variable:GetVariable("GemUnionPos")
		if(GemUnionPos ~= nil) then
		  Gemcompose_Frame:SetProperty("UnifiedPosition", GemUnionPos)
		end
		Gemcompose_FenYe1:SetCheck(1)
		this:Show()

		npcObjId = tonumber(Variable:GetVariable("GemNPCObjId"))
		Variable:SetVariable("GemNPCObjId", "", 1)
		if(npcObjId == nil) then
			npcObjId = Get_XParam_INT( 0 )
		end
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
		Gemcompose_Update(arg0, arg1)
		Gemcompose_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
		Gemcompose_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
		return
	end
	
	if event == "BUY_ITEM" and this:IsVisible() then	--��ݹ��򣬸��½���
		local itemId = tonumber(arg1)
		if itemId == Gemcompose_GetSpecialMaterial() then
			Gemcompose_Update(0,tonumber(PlayerPackage:GetBagPosByItemIndex(itemId)))	
			Gemcompose_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
			Gemcompose_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
		end
		return
	end

	if event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() then
		
		if not arg0 or tonumber(arg0) == -1 then
			return
		end
		
	--	Gemcompose_RefreshItem()

		Gemcompose_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
		Gemcompose_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
		return
	end

	if event == "RESUME_ENCHASE_GEM" and this : IsVisible() then
		if arg0 then
			--Gemcompose_Remove( tonumber( arg0 ) - 6 )
		end
		return
	end

	if event == "CLOSE_SYNTHESIZE_ENCHASE" and this : IsVisible() then
		--Gemcompose_Cancel_Clicked()
		Gemcompose_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
		return
	end
	
	if event == "UNIT_MONEY" and this:IsVisible() then
		Gemcompose_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
		return
	end
	
	if event == "MONEYJZ_CHANGE" and this:IsVisible() then
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

	--�ж��Ƿ�Ϊ��ȫʱ��
	if tonumber(DataPool:GetLeftProtectTime()) > 0 then
		PushDebugMessage("#{ZYXT_120528_16}")
		return
	end
	

	
	if g_GemTableIndex == -1 then
		return
	end
	local nItemTableIndex =  PlayerPackage:GetItemTableIndex(g_GemTableIndex)
	
	
	local nGemCount =Gemcompose_GetUnLockItemCount(nItemTableIndex)
	local nGemLevel = Gemcompose_GetGemLevel(nItemTableIndex)
	
	--�������Ƿ�����ߵȼ�
	if nGemLevel >= RuleTable.maxGrade then
		PushDebugMessage( RuleTable.msgGradeLimited )
		return
	end
	
	--�ϳ�8��9����ʯ���ܹرգ��ſ�8����ʯ��[LiChengjie]
	if nGemLevel > 7 then
		PushDebugMessage( "#{BSHC_090313_1}" )
		return
	end
	
	local _,nSel = Gemcompose_Special_Choice:GetCurrentSelect()
	
	if nSel == 0 and nGemCount < 5 then
		local msg =string.format( "��ʯ��������%d�ţ���ȷ�Ϻ��ٳ��ԡ�", "5")
		PushDebugMessage(msg)
		return
	elseif nSel == 1 and nGemCount < 4 then
		local msg =string.format( "��ʯ��������%d�ţ���ȷ�Ϻ��ٳ��ԡ�", "4")
		PushDebugMessage(msg)
		return
	elseif nSel == 2 and nGemCount < 3 then
		local msg =string.format( "��ʯ��������%d�ţ���ȷ�Ϻ��ٳ��ԡ�", "3")
		PushDebugMessage(msg)
		return
	end
	
	-- ������ϵĽ�Ǯ�Ƿ��㹻
	local selfMoney = Player : GetData( "MONEY" ) + Player : GetData( "MONEY_JZ" )
	if selfMoney < RuleTable[nGemLevel].MoneyCost then
		PushDebugMessage( string.format( RuleTable.msgLackMoney, RuleTable[nGemLevel].MoneyCost ) )
		return
	end
	g_ItemBagIndex= Gemcompose_PutInCompdasdoseItem(nGemLevel)
	--����Ǳ�ʯ�ϳɽ��棬�����û�з���������Ͻ�����������ʾ
	if g_ItemBagIndex == -1 then
		PushDebugMessage("#{KXYH_170608_03}")
		return
	end
	
	
        Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("GemCompctoound")
			Set_XSCRIPT_ScriptID(701602)
			Set_XSCRIPT_Parameter(0, 1)
			Set_XSCRIPT_Parameter(1, tonumber(g_GemTableIndex) )
			Set_XSCRIPT_Parameter(2, nSel )
			Set_XSCRIPT_ParamCount(3)
		Send_XSCRIPT()	
		Gemcompose_Clear()
end

--���ȡ�����߹رհ�ť
function Gemcompose_Cancel_Clicked()
	Gemcompose_Close()
	Gemcompose_StopCareObject()
end

--�رս���
function Gemcompose_Close()
	this:Hide()
	Gemcompose_Clear()
end

--��ս���Ԫ��
function Gemcompose_Clear()

	g_Gemcompose_YuanbaoPay = Gemcompose_YuanBaoPay:GetCheck()

	Gemcompose_SuccessValue_Text:SetText("")
	Gemcompose_NeedMoney:SetProperty( "MoneyNumber", "0" )

	g_ActionButton_Gem:SetActionItem(-1)
	g_ActionButton_GemNew:SetActionItem(-1)
	g_ActionButton_ComposeItem:SetActionItem(-1)
	
	if g_GemTableIndex ~= -1 then
		LifeAbility:Lock_Packet_Item(g_GemTableIndex,0)
	
		g_GemTableIndex = -1
	end	
	
	if g_ItemBagIndex ~=  -1 then
		--LifeAbility:Lock_Packet_Item(g_ItemBagIndex,0)
		g_ItemBagIndex = -1
	end
	


end

--�õ���ǰ����Ӧ��ƥ���������Ϻ�
--������Ǳ�ʯ�����򷵻� -1
--����Ǳ�ʯ���浫�ǻ�û�з��κα�ʯ�򷵻� -1
function Gemcompose_GetSpecialMaterial()
	
	if g_GemTableIndex == -1 then
		return -1
	end
	
	local nItemTableIndex =  PlayerPackage:GetItemTableIndex(g_GemTableIndex)
	local nGemLevel = Gemcompose_GetGemLevel(nItemTableIndex)

	if RuleTable[nGemLevel] ~= nil then
		return RuleTable[nGemLevel].SpecialStuff
	end

	return -1
end

--�ǲ��Ǻϳɷ�
function Gemcompose_IsComposeItem(bagPos)
	
	local nItemTableIndex =  PlayerPackage:GetItemTableIndex(bagPos)
	if nItemTableIndex == 30900015 or nItemTableIndex == 30900016  then
		return 1
	end
	
	return 0
	
end

--ˢ�ºϳɽ����ϵ���Ʒ
function Gemcompose_Update(pos0, pos1)
	
	local slot = tonumber(pos0)
	local bagPos = tonumber(pos1)

	--��֤��Ʒ��Ч��
	local bagItem = EnumAction(bagPos, "packageitem")
	if bagItem:GetID() == 0 then
		return
	end
	
	if slot == 0 then
		
		if PlayerPackage:IsGem(bagPos) == 1 then
			
			Gemcompose_PutInGem(bagPos)
		elseif Gemcompose_IsComposeItem(bagPos) == 1 then
			
			--Gemcompose_PutInComposeItem(bagPos)
		else
			PushDebugMessage("#{BSQHB_120830_03}")
			return
		end--]]
	
	elseif slot == 1 then
		
		Gemcompose_PutInGem(bagPos)
		
	elseif slot == 2 then
	
		--Gemcompose_PutInComposeItem(bagPos)
	
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
	local bDoubleGem = PlayerPackage : GetItemSubTableIndex(bagPos,3)
	if bDoubleGem >=101 then
		PushDebugMessage("#{BSZK_121012_43}")
		return
	end
	--[[
	--���ڸ��ʯ
	local bBP_Gem = BudgetPlanGem:IsBudgetPlanGem(bagPos)
	if bBP_Gem > 0 then
		PushDebugMessage("#{FQBS_140508_55}")
		return
	end--]]
	
	local nGemLevel = PlayerPackage:GetItemSubTableIndex(bagPos, 1)
	if nGemLevel >= 7 then
		PushDebugMessage("#{BSQHB_120830_04}")		--��8����ʯ�ϳ�9����ʯ����Ŀǰ��δ����
		return
	end
	
	local gemItem = EnumAction(bagPos, "packageitem")
	if gemItem:GetID() == 0 then
		return
	end
	
	
	
	
	g_ActionButton_Gem:SetActionItem(-1)
	g_ActionButton_GemNew:SetActionItem(-1)
	
	if g_GemTableIndex ~= -1 then
		LifeAbility:Lock_Packet_Item(g_GemTableIndex,0)
		g_GemTableIndex = -1
	end
	
	 nItemTableIndex =  PlayerPackage:GetItemTableIndex(bagPos)
	
	local layedGemItem =EnumAction(bagPos, "packageitem")
	if layedGemItem:GetID() ~= 0 then
		g_ActionButton_Gem:SetActionItem(layedGemItem:GetID())
		LifeAbility:Lock_Packet_Item(nItemTableIndex,1)
		g_GemTableIndex =bagPos
	end
	
	
	local nGemLevel = Gemcompose_GetGemLevel(nItemTableIndex)
	
	
	local newg_GemTableIndex = -1 
	if nItemTableIndex >0 then 
	newg_GemTableIndex = string.gsub(tostring(nItemTableIndex),"(%w%w)%w(%w%w%w%w%w)","%1"..tostring(nGemLevel+1).."%2")
	end
	if string.len(newg_GemTableIndex) ==8 then
	local newGemItem = GemCarve:UpdateProductAction(tonumber(newg_GemTableIndex))
	if newGemItem:GetID() ~= 0 then
		g_ActionButton_GemNew:SetActionItem(newGemItem:GetID())
	end
	end
	

	
	
--[[	if g_ItemBagIndex ~= -1 then
		local nComposeItemTableIndex = PlayerPackage:GetItemTableIndex(g_ItemBagIndex)
		if Gemcompose_GetSpecialMaterial() ~= nComposeItemTableIndex then
			g_ActionButton_ComposeItem:SetActionItem(-1)
			LifeAbility:Lock_Packet_Item(g_ItemBagIndex,0)
			g_ItemBagIndex = -1

		end
	end--]]
	
	if nGemLevel == 7 then
		Gemcompose_Special_Choice:SetCurrentSelect(0) --ѡ�񼸺�һ
	else
		Gemcompose_Special_Choice:SetCurrentSelect(0)
	end
	

    



	
	Gemcompose_RecalcCost()
	Gemcompose_RecalcSuccOdds()
	
end


function Gemcompose_PutInCompdasdoseItem(nGemLevel)
	local shuchu = -1 
	if nGemLevel < 4 then 
		local index,BindState = PlayerPackage:FindFirstBindedItemIdxByIDTable(30900015);	
		if index ==-1 then 
		index,BindState = PlayerPackage:FindFirstBindedItemIdxByIDTable(30900815);	
		end
		if index ~=-1 then 
		shuchu=1	
		end
		
	else
		local index,BindState = PlayerPackage:FindFirstBindedItemIdxByIDTable(30900016);	
		if index ==-1 then 
		index,BindState = PlayerPackage:FindFirstBindedItemIdxByIDTable(30900816);	
		end
		
		if index ~=-1 then 
		shuchu=1	
		end	
	end
	return shuchu
	
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
	
	local nItemTableIndex =  PlayerPackage:GetItemTableIndex(g_GemTableIndex)
	local nGemLevel = Gemcompose_GetGemLevel(nItemTableIndex)
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
			PushDebugMessage( "#{BSQHB_120830_07}" )
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

	
	Gemcompose_RecalcSuccOdds()
	
end

function Gemcompose_Special_ChoiceChanged()
	
	local _,nSel = Gemcompose_Special_Choice:GetCurrentSelect()
	
	if g_GemTableIndex ~= -1 then
		local nItemTableIndex =  PlayerPackage:GetItemTableIndex(g_GemTableIndex)
		local nGemLevel = Gemcompose_GetGemLevel(nItemTableIndex)
		if nGemLevel == 8 and nSel ~= 1 then
			PushDebugMessage("#{BSDJ_170811_07}")		--�ϳ�8����ʯֻ��ʹ���ĺ�һģʽ
			Gemcompose_Special_Choice:SetCurrentSelect(1)
			return
		end		
	end
	

	
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
		Gemcompose_RecalcCost()
		Gemcompose_RecalcSuccOdds()
	end	
	
end

function Gemcompose_GetUnLockItemCount(g_GemTableIndex)
local shuliang =0
for v=30,60 do 
	local nItemTableIndex =  PlayerPackage:GetItemTableIndex(v)
	if nItemTableIndex ==nil then 
		nItemTableIndex=-1
	end
	local Lock = PlayerPackage:IsLock(v) 
	if g_GemTableIndex == nItemTableIndex and Lock ~=  1 then 
		shuliang=shuliang+1
	end
end
	return shuliang
end


--���¼���ϳɸ���
function Gemcompose_RecalcSuccOdds()
	
	g_CurrentOdds = 0
	
	if g_GemTableIndex == -1 then
		Gemcompose_SuccessValue_Text:SetText("")
		return
	end	
	local nItemTableIndex =  PlayerPackage:GetItemTableIndex(g_GemTableIndex)
	local nGemLevel = Gemcompose_GetGemLevel(nItemTableIndex)
	local nGemCount = Gemcompose_GetUnLockItemCount(nItemTableIndex)
    g_ItemBagIndex = Gemcompose_PutInCompdasdoseItem(nGemLevel)
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
	local nItemTableIndex =  PlayerPackage:GetItemTableIndex(g_GemTableIndex)
	local nGemLevel = Gemcompose_GetGemLevel(nItemTableIndex)
	if RuleTable[nGemLevel] ~= nil then
		Gemcompose_NeedMoney:SetProperty("MoneyNumber", tostring(RuleTable[nGemLevel].MoneyCost) )
		return
	end

	Gemcompose_NeedMoney:SetProperty("MoneyNumber", "0")
end

function Gemcompose_RefreshItem()
		
	if g_GemTableIndex ~= -1 then
		
		g_ActionButton_Gem:SetActionItem(-1)
		g_ActionButton_GemNew:SetActionItem(-1)
		LifeAbility:Lock_Packet_Item(g_GemTableIndex,0)
	
		local  nGemItemTableIndex=PlayerPackage:GetItemTableIndex(g_GemTableIndex)

		local layedGemItem = EnumAction(g_GemTableIndex, "packageitem")
		if layedGemItem:GetID() ~= 0 then
			g_ActionButton_Gem:SetActionItem(layedGemItem:GetID())
			LifeAbility:Lock_Packet_Item(g_GemTableIndex,1)
		end
         
		local newGemItem = GemCarve:UpdateProductAction(nGemItemTableIndex)
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

--�ж��Ƿ������ʯ������ʹ���˱Ƚϵ��۵��жϷ������������������Ƿ���"��ͨ"
function Gemcompose_IsLiJinGem( bagIdx )
    if bagIdx == nil or bagIdx == -1 then
        return 1
    end

    local specStr = "��ͨ"
    local itemName = PlayerPackage:GetBagItemName( bagIdx )
    if itemName == nil then
        return 1
    end

    local sPos, ePos = string.find( itemName, specStr )
    if sPos == nil or ePos == nil then
        return 0
    end

    return 1
end

--TAB�����л�����������̫����
function Gemcompose_ChangeTabIndex( nIndex )
	if nIndex == nil then
		return
	end
	
	if nIndex == 5 or nIndex == 4 or nIndex == 3 then

	end
	
	local nUI = 0
	if 1 == nIndex then
		return
	elseif 2 == nIndex then
		nUI = 112236
	elseif 3 == nIndex then
		nUI = 112237
	elseif 4 == nIndex then
		nUI = 19830424
	elseif 5 == nIndex then
		nUI = 27
	elseif 6 == nIndex then
		nUI = 27
	else
		return
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
