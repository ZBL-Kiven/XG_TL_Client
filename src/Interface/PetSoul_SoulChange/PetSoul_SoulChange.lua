--***********************************************************************************************************************************************
-- 
--***********************************************************************************************************************************************

local g_clientNpcId = -1

local g_PetSoul_SoulChange_Frame_UnifiedPosition;

local g_PetSoul_SoulChange_ACBCtrl = {}

local g_PSC_BagIdx = {0,0,0,0,0,0,0,0}

--兽魂碎片
local g_PSC_MatriID_High ={
38002515,
38002516,
38002517,
38002518,
38002519
}
local g_PSC_SHDNum_High = 8

local g_PSC_MatriID_Mid ={
38002520,
38002521,
38002522,
38002523,
38002524
}
local g_PSC_SHDNum_Mid = 3

local g_PSC_MatriID_Low ={
38002525,
38002526,
38002527,
38002528,
38002529
}
local g_PSC_SHDNum_Low = 1

-- OnLoad
--
--************************************************************************************************************************************************
function PetSoul_SoulChange_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("PETSOUL_EXCHANGE_UI",false);
	this:RegisterEvent("PETSOUL_EXCHANGE_CONFIRMOK",false);
--	this:RegisterEvent("PACKAGE_ITEM_CHANGED",false);
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
end

function PetSoul_SoulChange_OnLoad()
	g_PetSoul_SoulChange_Frame_UnifiedPosition=PetSoul_SoulChange_Frame:GetProperty("UnifiedPosition");
	g_PetSoul_SoulChange_ACBCtrl = {
		PetSoul_SoulChange_Piece1,PetSoul_SoulChange_Piece2,PetSoul_SoulChange_Piece3,PetSoul_SoulChange_Piece4,
		PetSoul_SoulChange_Piece5,PetSoul_SoulChange_Piece6,PetSoul_SoulChange_Piece7,PetSoul_SoulChange_Piece8
	}
end


--***********************************************************************************************************************************************
--
-- 事件响应函数
--
--
--************************************************************************************************************************************************
function PetSoul_SoulChange_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == 89307801 ) then
		local clientNpcId = Get_XParam_INT(0)
		if clientNpcId==-1 then
			this:Hide()
			return
		elseif clientNpcId==-2 then
			PetSoul_SoulChange_ClearData()
			PetSoul_SoulChange_UpdateCurSHZ(Get_XParam_INT(1))
			PetSoul_SoulChange_UpdateText()
		else
			g_clientNpcId = clientNpcId
			local objId = DataPool : GetNPCIDByServerID(g_clientNpcId)
			if objId == -1 then
				return
			end
			PetSoul_SoulChange_ClearData()
			PetSoul_SoulChange_UpdateCurSHZ(Get_XParam_INT(1))
			PetSoul_SoulChange_UpdateText()
			this : CareObject( objId, 1, "PetSoul_SoulChange" )
			this : Show()
		end
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 201107281 and this:IsVisible()) then
		PetSoul_SoulChange_Update(0, tonumber(arg1), 0)
	elseif (event == "PETSOUL_EXCHANGE_CONFIRMOK") then
		PetSoul_SoulChange_Update(arg0, arg1, 1)
--	elseif (event == "PACKAGE_ITEM_CHANGED") then
	elseif (event == "ADJEST_UI_POS" ) then
		PetSoul_SoulChange_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		PetSoul_SoulChange_Frame_On_ResetPos()
	end
end

function PetSoul_SoulChange_UpdateText()
	local shz = 0
	for i=1,8 do
		if g_PSC_BagIdx[i]>0 then
			local nItemTableIndex =  PlayerPackage:GetItemTableIndex(g_PSC_BagIdx[i]-1)
			local nNum = GetBagItemNum(g_PSC_BagIdx[i]-1)
			if IsLowMatri(nItemTableIndex)==1 then
				shz = shz + g_PSC_SHDNum_Low*nNum
			elseif IsMidMatri(nItemTableIndex)==1 then
				shz = shz + g_PSC_SHDNum_Mid*nNum
			elseif IsHighMatri(nItemTableIndex)==1 then
				shz = shz + g_PSC_SHDNum_High*nNum
			end
		end
	end
	PetSoul_SoulChange_Explain_Text:SetText(string.format( "#cfff263归尘后可获得：#G%s#cfff263魂尘", shz))
end
function PetSoul_SoulChange_Update(param0,param1,param2)
	local slot = tonumber(param0)
	local bagPos = tonumber(param1)
	local sureOK = tonumber(param2)
	--验证物品有效性
	local bagItem = EnumAction(bagPos, "packageitem")
	if bagItem:GetID() == 0 then
		return
	end
	if slot==0 then
		--鼠标右键点入
		local bFind = 0
		for i=1,8 do
			if g_PSC_BagIdx[i]==0 then
				bFind = 1
				PetSoul_SoulChange_PutIn(i, bagPos, sureOK)
				break;
			end
		end
		if bFind == 0 then
			PushDebugMessage("#{ZSPVP_211231_55}")
		end
	else
		--拖拽
		PetSoul_SoulChange_PutIn(slot, bagPos, sureOK)
		return
	end
end

function PetSoul_SoulChange_PutIn(destPos, bagPos, sureOK)
	local nItemTableIndex =  PlayerPackage:GetItemTableIndex(bagPos)
	if IsHighMatri(nItemTableIndex)==0 and
			IsMidMatri(nItemTableIndex)==0 and
			IsLowMatri(nItemTableIndex)==0 then
		PushDebugMessage("#{ZSPVP_211231_32}")
		return
	end

	-- if IsMidMatri(nItemTableIndex)==1 and sureOK==0 then
		--圣兽品质
		-- PushEvent("PETSOUL_EXCHANGE_CONFIRM", 2, destPos, bagPos)
		-- return
	-- elseif IsHighMatri(nItemTableIndex)==1 and sureOK==0 then
		--神兽品质
		-- PushEvent("PETSOUL_EXCHANGE_CONFIRM", 3, destPos, bagPos)
		-- return
	-- end
	local matItem = EnumAction(bagPos, "packageitem")
	if matItem:GetID() == 0 then
		return
	end
	if g_PSC_BagIdx[destPos] > 0 then
		LifeAbility:Lock_Packet_Item(g_PSC_BagIdx[destPos]-1, 0)
	end
	g_PetSoul_SoulChange_ACBCtrl[destPos]:SetActionItem(matItem:GetID())
	g_PSC_BagIdx[destPos] = bagPos+1
	LifeAbility:Lock_Packet_Item(bagPos, 1)
	PetSoul_SoulChange_UpdateText()
end

function PetSoul_SoulChange_ACBRemove(nIdx)
	if g_PSC_BagIdx[nIdx] > 0 then
		g_PetSoul_SoulChange_ACBCtrl[nIdx]:SetActionItem(-1)
		LifeAbility:Lock_Packet_Item(g_PSC_BagIdx[nIdx]-1,0)
		g_PSC_BagIdx[nIdx] = 0
		PetSoul_SoulChange_UpdateText()
	end
end
function PetSoul_SoulChange_OnClose()
	PetSoul_SoulChange_ClearData()
	this:Hide()
end


function PetSoul_SoulChange_Frame_On_ResetPos()
  PetSoul_SoulChange_Frame:SetProperty("UnifiedPosition", g_PetSoul_SoulChange_Frame_UnifiedPosition);
end

function PetSoul_SoulChange_OnHiden()
	PetSoul_SoulChange_ClearData()
end

function PetSoul_SoulChange_ClearData()
	for i=1,8 do
		if g_PSC_BagIdx[i] > 0 then
			g_PetSoul_SoulChange_ACBCtrl[i]:SetActionItem(-1)
			LifeAbility:Lock_Packet_Item(g_PSC_BagIdx[i]-1,0)
			g_PSC_BagIdx[i] = 0
		end
	end
	PetSoul_SoulChange_Explain_Text:SetText(string.format( "#cfff263归尘后可获得：#G%s#cfff263魂尘", 0))
end

function PetSoul_SoulChange_Buttons_Clicked()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnPetYunJueJue")
		Set_XSCRIPT_ScriptID(742564)
		Set_XSCRIPT_Parameter(0,1)
		Set_XSCRIPT_Parameter(1,g_PSC_BagIdx[1] * 1000000 + g_PSC_BagIdx[2] * 10000+ g_PSC_BagIdx[3] * 100+g_PSC_BagIdx[4])
		Set_XSCRIPT_Parameter(2,g_PSC_BagIdx[5] * 1000000 + g_PSC_BagIdx[6] * 10000+ g_PSC_BagIdx[7] * 100+g_PSC_BagIdx[8])
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
	for i = 1,8 do
		g_PSC_BagIdx[i] = 0
	end
end
function IsHighMatri(nItemTableIndex)
	local nCount=table.getn(g_PSC_MatriID_High)
	for i=1,nCount do
		if nItemTableIndex == g_PSC_MatriID_High[i] then
			return 1
		end
	end
	return 0
end
function IsMidMatri(nItemTableIndex)
	local nCount=table.getn(g_PSC_MatriID_Mid)
	for i=1,nCount do
		if nItemTableIndex == g_PSC_MatriID_Mid[i] then
			return 1
		end
	end
	return 0
end
function IsLowMatri(nItemTableIndex)
	local nCount=table.getn(g_PSC_MatriID_Low)
	for i=1,nCount do
		if nItemTableIndex == g_PSC_MatriID_Low[i] then
			return 1
		end
	end
	return 0
end

function PetSoul_SoulChange_UpdateCurSHZ(nVal)
	PetSoul_SoulChange_Explain_HaveText:SetText(string.format( "#cfff263已有魂尘：#G%s#cfff263魂尘", nVal))
end