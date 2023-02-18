--���޻��� PetSoul_Smash

local g_PetSoul_Smash_UnifiedPosition;

local MAX_OBJ_DISTANCE = 3.0

local g_PetSoul_Smash_NpcId = -1;

local g_PetSoul_Smash_ItemBagIndex = -1

local g_PetSoul_Smash_TargetId = -1

local g_PetSoul_Smash_CostList ={
	[0] = {piecesNumber = 20,moneyCost =100000},
	[1] = {piecesNumber = 30,moneyCost =300000},
	[2] = {piecesNumber = 40,moneyCost =1000000},
}

function PetSoul_Smash_PreLoad()

	this:RegisterEvent("UI_COMMAND");

	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")

    this:RegisterEvent("OBJECT_CARED_EVENT");           --ĳ�߼������ĳЩ�����ı䣬���ھ���NPC��Զ��رս���

    this:RegisterEvent("UNIT_MONEY")					--��Ǯ�仯
	this:RegisterEvent("MONEYJZ_CHANGE")			    --���ӱ仯
	
	this:RegisterEvent("PETSOUL_SMASH_PUTIN_ITEM"); --������Ʒ
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")			--��������Ʒ�ı�
	this:RegisterEvent("RESUME_ENCHASE_GEM"); --��ק�ر���
end

function PetSoul_Smash_OnLoad()
    
    g_PetSoul_Smash_UnifiedPosition=PetSoul_Smash_Frame:GetProperty("UnifiedPosition")
	
end

function PetSoul_Smash_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == 80012706 ) then
		local bIsShow = Get_XParam_INT(0);
		if bIsShow == 1 then
			this:Show()--�򿪽���
            OpenWindow("Packet")--�򿪱���
        end

        if this:IsVisible() then
			g_PetSoul_Smash_TargetId = Get_XParam_INT( 1 )
            PetSoul_Smash_BeginCareObject( g_PetSoul_Smash_TargetId )
            PetSoul_Smash_FrameInit() 
            PetSoul_Smash_MoneyUpdate()--��Ǯ���� ����ˢ��
		end

		return
	elseif event == "UI_COMMAND" and tonumber(arg0) == 201107281 and this:IsVisible() then
		if arg1 ~= nil then
			PetSoul_Smash_ItemUpdate(tonumber(arg1))
		end

		return
	elseif( event == "RESUME_ENCHASE_GEM" and this:IsVisible() ) then
		if(arg0~=nil) then---xml�����õ���W31
			PetSoul_Smash_Resume_Equip()
		end

		return
	elseif event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() then
		if not arg0 or tonumber(arg0) == -1 then
			return
		end
		
		if tonumber(arg0) == g_PetSoul_Smash_ItemBagIndex then
			PetSoul_Smash_ItemUpdate(-1)
		end 
		
		PetSoul_Smash_MoneyUpdate()--����Ǯ��ˢ��

		return
    elseif event == "OBJECT_CARED_EVENT" and this : IsVisible() then
		if(tonumber(arg0) ~= g_PetSoul_Smash_NpcId) then
			return;
		end
		
		--�����NPC�ľ������һ��������߱�ɾ�����Զ��ر�
		if arg1 == "distance" and tonumber( arg2 ) > MAX_OBJ_DISTANCE or arg1 == "destroy" then
			PetSoul_Smash_Close()
		end

        return
    elseif event == "UNIT_MONEY" or event == "MONEYJZ_CHANGE" then
        PetSoul_Smash_MoneyUpdate()--��Ǯ���� ����ˢ��
        return
    elseif event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		PetSoul_Smash_On_ResetPos()
		return
	end
end

function PetSoul_Smash_Buttons_Clicked()

	-- local nQual=PlayerPackage:LuaFnGetPetSoulDataInBag( g_PetSoul_Smash_ItemBagIndex, "QUAL")
	-- if nQual == nil or g_PetSoul_Smash_ItemBagIndex < 0 then
		-- PushDebugMessage("#{SHXT_20211230_68}")
	-- end

	Clear_XSCRIPT()
		Set_XSCRIPT_ScriptID( 742562 )
		Set_XSCRIPT_Function_Name( "OnPetSoulSmash" )
		Set_XSCRIPT_Parameter(0, g_PetSoul_Smash_TargetId)
		Set_XSCRIPT_Parameter(1, g_PetSoul_Smash_ItemBagIndex)
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()
end

function PetSoul_Smash_Resume_Equip()
	PetSoul_Smash_ItemUpdate(-1)
end

function PetSoul_Smash_ItemUpdate(bagPos)

	--bagPosΪ-1����ʾҪ��ʼ������  �رս��� �Ҽ�ȡ����Ʒʱ����
	if bagPos == -1 then
		--ȷ�ϰ�ť������
		PetSoul_Smash_OK:Disable()
		--��Ʒ�ÿ�
		PetSoul_Smash_Object:SetActionItem(-1);
		if g_PetSoul_Smash_ItemBagIndex ~= -1 then
			LifeAbility : Lock_Packet_Item(g_PetSoul_Smash_ItemBagIndex,0);
			g_PetSoul_Smash_ItemBagIndex = -1
		end
		--�ÿɻ����Ƭ����
		PetSoul_Smash_Explain:SetText("#{SHXT_20211230_134}")
		--����������
		PetSoul_Smash_Demand_Jiaozi:SetProperty("MoneyNumber", "0")
		return
	end

	local theAction = EnumAction( bagPos, "packageitem");
	if theAction:GetID() ~= 0 then
		
		--�ж��ǲ��ǻ���
		-- local nLevel=PlayerPackage:LuaFnGetPetSoulDataInBag( bagPos, "LEVEL")
		local nQual=LuaFnGetPetSoulDataInBag( bagPos, "QUAL")
		-- local nPetSoulIndex = PlayerPackage:GetItemTableIndex(bagPos);
		if nQual == nil then
			PushDebugMessage("#{SHXT_20211230_136}")
			return
		end

		--�ж���Ʒ�Ƿ����� 
		if PlayerPackage:IsLock(bagPos) == 1 then
			PushDebugMessage("#{SHXT_20211230_65}")
			return
		end

		--�����Ʒ��������Ʒ����ȡ����Ʒ�ɺ�
		if g_PetSoul_Smash_ItemBagIndex ~= -1 then
			LifeAbility : Lock_Packet_Item(g_PetSoul_Smash_ItemBagIndex,0);
			g_PetSoul_Smash_ItemBagIndex = -1
		end
		PetSoul_Smash_Object:SetActionItem(theAction:GetID());
		g_PetSoul_Smash_ItemBagIndex = bagPos
		LifeAbility : Lock_Packet_Item(bagPos,1);

		--���ݻ���Ʒ�ʻ�ȡ�ɻ����Ƭ����������������
		if(nQual == nil)then
			return
		end

		--��������
		PetSoul_Smash_Demand_Jiaozi:SetProperty("MoneyNumber", g_PetSoul_Smash_CostList[nQual].moneyCost)

		local piecesNumber = g_PetSoul_Smash_CostList[nQual].piecesNumber
		--�ÿɻ����Ƭ����
		PetSoul_Smash_Explain:SetText(string.format("�ɵõ��Ļ���������#G%s#cfff263",tostring(piecesNumber)))

		PetSoul_Smash_OK:Enable()--ȷ�ϰ�ť����
	end
end

function PetSoul_Smash_OnHiden()
	PetSoul_Smash_StopCareObject();
	PetSoul_Smash_Close()
end

function PetSoul_Smash_Close()
	PetSoul_Smash_ItemUpdate(-1)
	this:Hide()
end

function PetSoul_Smash_On_ResetPos()
    PetSoul_Smash_Frame:SetProperty("UnifiedPosition", g_PetSoul_Smash_UnifiedPosition)
end

function PetSoul_Smash_FrameInit()
    --����������ʾ��ʼ��
    PetSoul_Smash_Title:SetText("#{SHXT_20211230_131}")
    PetSoul_Smash_Info:SetText("#{SHXT_20211230_132}")
    PetSoul_Smash_Info2:SetText("#{SHXT_20211230_133}")
    --��ť������ʾ��ʼ��
    PetSoul_Smash_OK:SetText("#{SHXT_20211230_61}")
    PetSoul_Smash_Cancel:SetText("#{SHXT_20211230_63}")
    --��ť�Ƿ����ó�ʼ��
	PetSoul_Smash_OK:Disable()
	--������������ʼ��
	PetSoul_Smash_Demand_Jiaozi:SetProperty("MoneyNumber", "0")
end

--��Ǯ���� ����ˢ��
function PetSoul_Smash_MoneyUpdate()

    PetSoul_Smash_Currently_Money:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
	PetSoul_Smash_Currently_Jiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))

end

--=========================================================
--��ʼ����NPC��
--�ڿ�ʼ����֮ǰ��Ҫ��ȷ����������ǲ����Ѿ��С����ġ���NPC��
--����еĻ�����ȡ���Ѿ��еġ����ġ�
--=========================================================
function PetSoul_Smash_BeginCareObject( objCaredId )
	g_PetSoul_Smash_NpcId = DataPool : GetNPCIDByServerID( objCaredId )
	if g_PetSoul_Smash_NpcId == -1 then
		this : Hide()
		return
	end

	this : CareObject( g_PetSoul_Smash_NpcId, 1, "PetSoul_Smash" )
end

--=========================================================
--ֹͣ��ĳNPC�Ĺ���
--=========================================================
function PetSoul_Smash_StopCareObject()
	this : CareObject( g_PetSoul_Smash_NpcId, 0, "PetSoul_Smash" )
	g_PetSoul_Smash_NpcId = -1
end