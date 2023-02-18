--***********************************************************************************************************************************************
-- 
--***********************************************************************************************************************************************

local g_clientNpcId = -1

local g_PetSoul_MonopolyGameGet_Frame_UnifiedPosition;

local g_PetSoul_MonopolyGameGet_ACBCtr={}

local g_PSM_ItemList = {
[1]={id=38002496, bBind=0},	--ÉñÊÞÇàÁú±¦Í¼
[2]={id=38002497, bBind=0},	--ÉñÊÞÐþÎä±¦Í¼
[3]={id=38002498, bBind=0},	--ÉñÊÞ°×»¢±¦Í¼
[4]={id=38002499, bBind=0},	--ÉñÊÞÖìÈ¸±¦Í¼
[5]={id=38002500, bBind=0},	--»ÄÊÞ½õÁÛ±¦Í¼
[6]={id=38002501, bBind=0},	--»ÄÊÞ»Ãµû±¦Í¼
[7]={id=38002502, bBind=0},	--»ÄÊÞËªº×±¦Í¼
[8]={id=38002503, bBind=0},	--»ÄÊÞ½ðÎÚ±¦Í¼
[9]={id=38002504, bBind=1},	--ÁéÊÞ
}
-- OnLoad
--
--************************************************************************************************************************************************
function PetSoul_MonopolyGameGet_PreLoad()
	this:RegisterEvent("OPEN_PETSOUL_MONOPOLYGAMEGET");
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
end

function PetSoul_MonopolyGameGet_OnLoad()
	g_PetSoul_MonopolyGameGet_Frame_UnifiedPosition=PetSoul_MonopolyGameGet_Frame:GetProperty("UnifiedPosition");
end


--***********************************************************************************************************************************************
--
-- ÊÂ¼þÏìÓ¦º¯Êý
--
--
--************************************************************************************************************************************************
function PetSoul_MonopolyGameGet_OnEvent(event)
	if ( event == "OPEN_PETSOUL_MONOPOLYGAMEGET" ) then
		PetSoul_MonopolyGameGet_Update(tonumber(arg0))
		this : Show()
	elseif (event == "ADJEST_UI_POS" ) then
		PetSoul_MonopolyGameGet_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		PetSoul_MonopolyGameGet_Frame_On_ResetPos()
	end
end

function PetSoul_MonopolyGameGet_Update(idx)
	if g_PSM_ItemList[idx]==nil then return end;
	if g_PSM_ItemList[idx].bBind == 1 then
		local showAction = DataPool:CreateBindActionItemForShow(g_PSM_ItemList[idx].id, 1)
		if showAction:GetID() ~= 0 then
			PetSoul_MonopolyGameGet_Award:SetActionItem(showAction:GetID())
		end
	else
		local showAction = DataPool:CreateActionItemForShow(g_PSM_ItemList[idx].id, 1)
		if showAction:GetID() ~= 0 then
			PetSoul_MonopolyGameGet_Award:SetActionItem(showAction:GetID())
		end
	end
	local itemname = PlayerPackage:GetItemName( g_PSM_ItemList[idx].id )
	local tip = ScriptGlobal_Format( "#{ZSPVP_211231_71}", itemname)
	PetSoul_MonopolyGameGet_Text:SetText(tip)
end

function PetSoul_MonopolyGameGet_RollDice()
	this:Hide()
end

function PetSoul_MonopolyGameGet_Frame_On_ResetPos()
  PetSoul_MonopolyGameGet_Frame:SetProperty("UnifiedPosition", g_PetSoul_MonopolyGameGet_Frame_UnifiedPosition);
end

function PetSoul_MonopolyGameGet_OnHiden()
end
