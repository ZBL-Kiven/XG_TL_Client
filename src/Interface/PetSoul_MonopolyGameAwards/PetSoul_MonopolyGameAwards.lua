--***********************************************************************************************************************************************
-- 
--***********************************************************************************************************************************************

local g_clientNpcId = -1

local g_PetSoul_MonopolyGameAwards_Frame_UnifiedPosition;

local g_PetSoul_MonopolyGameAwards_ACBCtr={}

local g_PSM_ItemList = {
[1]={id=38002496, num=1},	--����������ͼ
[2]={id=38002497, num=1},	--�������䱦ͼ
[3]={id=38002498, num=1},	--���ް׻���ͼ
[4]={id=38002499, num=1},	--������ȸ��ͼ
[5]={id=38002500, num=1},	--���޽��۱�ͼ
[6]={id=38002501, num=1},	--���޻õ���ͼ
[7]={id=38002502, num=1},	--����˪�ױ�ͼ
[8]={id=38002503, num=1},	--���޽��ڱ�ͼ
[9]={id=38002504, num=1},	--����
}
-- OnLoad
--
--************************************************************************************************************************************************
function PetSoul_MonopolyGameAwards_PreLoad()
	this:RegisterEvent("OPEN_PETSOUL_MONOPOLYGAMEAWARDS");
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
end

function PetSoul_MonopolyGameAwards_OnLoad()
	g_PetSoul_MonopolyGameAwards_Frame_UnifiedPosition=PetSoul_MonopolyGameAwards_Frame:GetProperty("UnifiedPosition");
	g_PetSoul_MonopolyGameAwards_ACBCtr={
		PetSoul_MonopolyGameAwards_ShenIcon1,PetSoul_MonopolyGameAwards_ShenIcon2,PetSoul_MonopolyGameAwards_ShenIcon3,PetSoul_MonopolyGameAwards_ShenIcon4,
		PetSoul_MonopolyGameAwards_YiIcon1,PetSoul_MonopolyGameAwards_YiIcon2,PetSoul_MonopolyGameAwards_YiIcon3,PetSoul_MonopolyGameAwards_YiIcon4,
		PetSoul_MonopolyGameAwards_YaoIcon
	}
end


--***********************************************************************************************************************************************
--
-- �¼���Ӧ����
--
--
--************************************************************************************************************************************************
function PetSoul_MonopolyGameAwards_OnEvent(event)
	if ( event == "OPEN_PETSOUL_MONOPOLYGAMEAWARDS" ) then
		PetSoul_MonopolyGameAwards_Update()
		this : Show()
	elseif (event == "ADJEST_UI_POS" ) then
		PetSoul_MonopolyGameAwards_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		PetSoul_MonopolyGameAwards_Frame_On_ResetPos()
	end
end

function PetSoul_MonopolyGameAwards_Update(nShouHunDian)
	for i=1,8 do
		local showAction = DataPool:CreateActionItemForShow(g_PSM_ItemList[i].id, g_PSM_ItemList[i].num)
		if showAction:GetID() ~= 0 then
			g_PetSoul_MonopolyGameAwards_ACBCtr[i]:SetActionItem(showAction:GetID())
		end
	end
	local showAction = DataPool:CreateBindActionItemForShow(g_PSM_ItemList[9].id, g_PSM_ItemList[9].num)
	if showAction:GetID() ~= 0 then
		g_PetSoul_MonopolyGameAwards_ACBCtr[9]:SetActionItem(showAction:GetID())
	end
end

function PetSoul_MonopolyGameAwards_OnClose()
	this:Hide()
end


function PetSoul_MonopolyGameAwards_Frame_On_ResetPos()
  PetSoul_MonopolyGameAwards_Frame:SetProperty("UnifiedPosition", g_PetSoul_MonopolyGameAwards_Frame_UnifiedPosition);
end

function PetSoul_MonopolyGameAwards_OnHiden()
end
