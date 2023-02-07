--�������� PetSoul_Fusion

local g_PetSoul_Fusion_UnifiedPosition;

local MAX_OBJ_DISTANCE = 3.0

local g_PetSoul_Fusion_NpcId = -1;

local g_PetSoul_Fusion_ItemBagIndex1 = -1
local g_PetSoul_Fusion_ItemBagIndex2 = -1

local g_PetSoul_Fusion_ItemID1 = -1
local g_PetSoul_Fusion_ItemID2 = -1

local g_PetSoul_Fusion_QNumber = {
	[0] = "20",
	[1] = "30",
	[2] = "40",
}
local g_PetSoul_Fusion_Item = {
	{39995380,39995379,39995378,39995377,39995376},
	{39995375,39995374,39995373,39995372,39995371},
	{39995370,39995369,39995368,39995367,39995366},
	}
local g_PetSoul_Fusion_QualItem = {
	{38002529,38002528,38002527,38002526,38002525},
	{38002524,38002523,38002522,38002521,38002520},
	{38002519,38002518,38002517,38002516,38002515},
	}

local g_PetSoul_Fusion_TargetId = -1

local g_PetSoul_Fusion_ConfirmBind = 0;

function PetSoul_Fusion_PreLoad()

	this:RegisterEvent("UI_COMMAND");

	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")

    this:RegisterEvent("OBJECT_CARED_EVENT");           --ĳ�߼������ĳЩ�����ı䣬���ھ���NPC��Զ��رս���
    

	this:RegisterEvent("PETSOUL_FUSION_PUTIN_ITEM"); --������Ʒ
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")			--��������Ʒ�ı�
	this:RegisterEvent("RESUME_ENCHASE_GEM"); --��ק�ر���

end

function PetSoul_Fusion_OnLoad()

	g_PetSoul_Fusion_ConfirmBind = 0;

	g_PetSoul_Fusion_UnifiedPosition=PetSoul_Fusion_Frame:GetProperty("UnifiedPosition")
	
end

function PetSoul_Fusion_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == 80012704 ) then
		local bIsShow = Get_XParam_INT(0);
		if bIsShow == 1 then
			g_PetSoul_Fusion_ConfirmBind = 0;
			this:Show()
            OpenWindow("Packet")
        end

        if this:IsVisible() then
			g_PetSoul_Fusion_TargetId = Get_XParam_INT( 1 )
            PetSoul_Fusion_BeginCareObject( g_PetSoul_Fusion_TargetId )
            PetSoul_Fusion_FrameInit()
		end

		return
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 80012724 ) then
		g_PetSoul_Fusion_ConfirmBind = 1;
		return
	--������Ʒ
	elseif event == "UI_COMMAND" and tonumber(arg0) == 201107281 and this:IsVisible() then
		if arg1 ~= nil then
			PetSoul_Fusion_ItemUpdate(tonumber(arg1),3)
			
		end

		return
	elseif( event == "RESUME_ENCHASE_GEM" and this:IsVisible() ) then
		if(arg0~=nil and tonumber(arg0) == 27) then---xml�����õ���W27
			PetSoul_Fusion_Resume_Equip()
		end
		if(arg0~=nil and tonumber(arg0) == 28) then---xml�����õ���W28
			PetSoul_Fusion_Resume_Equip2()
		end

		return
	elseif event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() then
		if not arg0 or tonumber(arg0) == -1 then
			return
		end
		
		local ClearItem1 = 0
		local ClearItem2 = 0
		
		if(tonumber(arg0) == g_PetSoul_Fusion_ItemBagIndex1)  and g_PetSoul_Fusion_ItemBagIndex1 ~= -1 then
			local nItemIndex = PlayerPackage:GetItemTableIndex(g_PetSoul_Fusion_ItemBagIndex1)
			if(nItemIndex == nil or nItemIndex ~= g_PetSoul_Fusion_ItemID1)then
				ClearItem1 = 1;
			end
		end

		if(tonumber(arg0) == g_PetSoul_Fusion_ItemBagIndex2)  and g_PetSoul_Fusion_ItemBagIndex2 ~= -1 then
			local nItemIndex = PlayerPackage:GetItemTableIndex(g_PetSoul_Fusion_ItemBagIndex2)
			if(nItemIndex == nil or nItemIndex ~= g_PetSoul_Fusion_ItemID2)then
				
				ClearItem2 = 1;  
			end
		end
		PetSoul_Fusion_ItemClear(ClearItem1,ClearItem2)

		return
    elseif event == "OBJECT_CARED_EVENT" and this : IsVisible() then
		if(tonumber(arg0) ~= g_PetSoul_Fusion_NpcId) then
			return;
		end
		
		--�����NPC�ľ������һ��������߱�ɾ�����Զ��ر�
		if arg1 == "distance" and tonumber( arg2 ) > MAX_OBJ_DISTANCE or arg1 == "destroy" then
			PetSoul_Fusion_Close()
		end

        return
    elseif event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED"then
		PetSoul_Fusion_On_ResetPos()
		return
	end
end

--���갴ť ���µ���
function PetSoul_Fusion_Buttons_Clicked()

	--�������� �绰�ܱ����
	-- if CheckPhoneMibaoAndMinorPassword() ~= 1 then
		-- PushDebugMessage("#{SHXT_20211230_67}")
		-- return
	-- end
	
	--��ǰ������������Ƿ��ѷ������
	if g_PetSoul_Fusion_ItemBagIndex1 < 0 and g_PetSoul_Fusion_ItemBagIndex2 < 0 then
		PushDebugMessage("#{SHXT_20211230_112}")
		return
	end
	
	if(g_PetSoul_Fusion_ItemBagIndex1 >= 0 and g_PetSoul_Fusion_ItemBagIndex2 >= 0 )then
		--�жϵ�ǰ�����Ƿ���ͬһ�޻����Ƭ
		if PlayerPackage:GetItemTableIndex(g_PetSoul_Fusion_ItemBagIndex1) ~= PlayerPackage:GetItemTableIndex(g_PetSoul_Fusion_ItemBagIndex2) then
			PushDebugMessage("#{SHXT_20211230_167}")
			return
		end
	end

	Clear_XSCRIPT()
		Set_XSCRIPT_ScriptID( 742562 )
		Set_XSCRIPT_Function_Name( "OnPetSoulFusion" )
		Set_XSCRIPT_Parameter(0, g_PetSoul_Fusion_TargetId)
		Set_XSCRIPT_Parameter(1, g_PetSoul_Fusion_ItemBagIndex1)
		Set_XSCRIPT_Parameter(2, g_PetSoul_Fusion_ItemBagIndex2)
		Set_XSCRIPT_Parameter(3, g_PetSoul_Fusion_ConfirmBind)
		Set_XSCRIPT_ParamCount(4)
	Send_XSCRIPT()
end

--������Ʒ�� ����Ҽ�����
function PetSoul_Fusion_Resume_Equip()
	PetSoul_Fusion_ItemUpdate(-1,1)
end
function PetSoul_Fusion_Resume_Equip2()
	PetSoul_Fusion_ItemUpdate(-1,2)
end

function PetSoul_Fusion_ItemClear(nClear1,nClear2)
	if(nClear1 == 1)then
		if g_PetSoul_Fusion_ItemBagIndex1 ~= -1 then
			PetSoul_Fusion_Object:SetActionItem(-1)
			LifeAbility : Lock_Packet_Item(g_PetSoul_Fusion_ItemBagIndex1,0);
			g_PetSoul_Fusion_ItemBagIndex1 = -1;
			g_PetSoul_Fusion_ItemID1 = -1
		end
	end
	if(nClear2 == 1)then
		if g_PetSoul_Fusion_ItemBagIndex2 ~= -1 then
			PetSoul_Fusion_Object2:SetActionItem(-1)
			LifeAbility : Lock_Packet_Item(g_PetSoul_Fusion_ItemBagIndex2,0);
			g_PetSoul_Fusion_ItemBagIndex2 = -1;
			g_PetSoul_Fusion_ItemID2 = -1
		end
	end

	--��ʾ�޻�
	local nItem1Bind , nItem2Bind= 0;
	local nItemIndex = 0;
	local nPsIndex, nPsQual =0;

	if(g_PetSoul_Fusion_ItemBagIndex1 ~= -1)then
		if GetItemBindStatus(g_PetSoul_Fusion_ItemBagIndex1) == 1 then
			nItem1Bind = 1
		end
		nItemIndex = PlayerPackage:GetItemTableIndex(g_PetSoul_Fusion_ItemBagIndex1);
		nPsIndex, nPsQual = LuaFnGetPetSoulPieceInfo( nItemIndex );
	end

	if(g_PetSoul_Fusion_ItemBagIndex2 ~= -1)then
		if GetItemBindStatus(g_PetSoul_Fusion_ItemBagIndex2) == 1 then
			nItem2Bind = 1
		end
		nItemIndex = PlayerPackage:GetItemTableIndex(g_PetSoul_Fusion_ItemBagIndex2);
		nPsIndex, nPsQual = LuaFnGetPetSoulPieceInfo( nItemIndex );
	end

	local nBind = 0;
	if(nItem1Bind == 1) or (nItem2Bind == 1)then
		nBind = 1;
	end

	if(g_PetSoul_Fusion_ItemBagIndex1 ~= -1 or g_PetSoul_Fusion_ItemBagIndex2 ~= -1)then
		if(nPsIndex ~= nil)then
			-- DataPool:ClearActionItemForShow()
			-- g_PetSoul_Fusion_Item
			-- g_PetSoul_Fusion_QualItem
			local ShowID = 0
			for i = 1,3 do
				for j = 1,5 do
					if g_PetSoul_Fusion_Item[i][j] == nItemIndex then
						ShowID = g_PetSoul_Fusion_QualItem[i][j]
						break
					end
				end
			end
			if(nBind == 0)then
				local theAction2 = GemMelting:UpdateProductAction(tonumber(ShowID))
				PetSoul_Fusion_Object3:SetActionItem(theAction2:GetID())
			else
				local theAction2 = GemMelting:UpdateProductAction(tonumber(ShowID))
				PetSoul_Fusion_Object3:SetActionItem(theAction2:GetID())
			end
		end
	end

	--��ʾ��Ҫ���޻���Ƭ��
	if g_PetSoul_Fusion_ItemBagIndex1 ~= -1   then
		local nItemIndex = PlayerPackage:GetItemTableIndex(g_PetSoul_Fusion_ItemBagIndex1);
		local nPsIndex, nPsQual = LuaFnGetPetSoulPieceInfo( nItemIndex );
		if(nPsIndex ~= nil and nPsIndex > 0)then
			local text = string.format("#G%s#cfff263��������#G%s#cfff263������#G%s", LuaFnGetItemNameByTableIndex(nPsIndex),LuaFnGetItemNameByTableIndex( nItemIndex ),g_PetSoul_Fusion_QNumber[nPsQual])
			PetSoul_Fusion_Info4:SetText(text)
		end
	end
	if g_PetSoul_Fusion_ItemBagIndex2 ~= -1   then
		local nItemIndex = PlayerPackage:GetItemTableIndex(g_PetSoul_Fusion_ItemBagIndex2);
		local nPsIndex, nPsQual = LuaFnGetPetSoulPieceInfo( nItemIndex );
		if(nPsIndex ~= nil and nPsIndex > 0)then
			local text = string.format("#G%s#cfff263��������#G%s#cfff263������#G%s", LuaFnGetItemNameByTableIndex(nPsIndex),LuaFnGetItemNameByTableIndex( nItemIndex ),g_PetSoul_Fusion_QNumber[nPsQual])
			PetSoul_Fusion_Info4:SetText(text)
		end
	end

	--ˢ��ȷ�ϰ�ť
	if g_PetSoul_Fusion_ItemBagIndex1 ~= -1 or g_PetSoul_Fusion_ItemBagIndex2 ~= -1 then
		PetSoul_Fusion_OK:Enable()
	else
		PetSoul_Fusion_Info4:SetText("#{SHXT_20211230_201}")
		PetSoul_Fusion_OK:Disable()
		PetSoul_Fusion_Object3:SetActionItem(-1)
	end
end

function PetSoul_Fusion_ItemPut(bagPos,nItemIndex,theAction)
	if(nItemIndex == 1)then
		--�����ǰ�ĸ����Ѿ�����Ʒ�������һ���ɺ�
		if g_PetSoul_Fusion_ItemBagIndex1 ~= -1 then
			LifeAbility : Lock_Packet_Item(g_PetSoul_Fusion_ItemBagIndex1,0);
			g_PetSoul_Fusion_ItemBagIndex1 = -1;
		end 
		g_PetSoul_Fusion_ItemBagIndex1 = bagPos;
		PetSoul_Fusion_Object:SetActionItem(theAction:GetID());
		LifeAbility : Lock_Packet_Item(bagPos,1);
		g_PetSoul_Fusion_ItemID1 = PlayerPackage:GetItemTableIndex(bagPos)
	elseif(nItemIndex == 2)then
		--�����ǰ�ĸ����Ѿ�����Ʒ�������һ���ɺ�
		if g_PetSoul_Fusion_ItemBagIndex2 ~= -1 then
			LifeAbility : Lock_Packet_Item(g_PetSoul_Fusion_ItemBagIndex2,0);
			g_PetSoul_Fusion_ItemBagIndex2 = -1;
		end 
		g_PetSoul_Fusion_ItemBagIndex2 = bagPos;
		PetSoul_Fusion_Object2:SetActionItem(theAction:GetID());
		LifeAbility : Lock_Packet_Item(bagPos,1);
		g_PetSoul_Fusion_ItemID2 = PlayerPackage:GetItemTableIndex(bagPos)
	end
end

--bagPosΪ�ӱ�������������Ʒ���ڱ�����λ��
--interfaceIndexΪ����Ľ���Ŀ�ı�ʶ  3��ʾ�Ҽ�������벻������
function PetSoul_Fusion_ItemUpdate(bagPos,interfaceIndex)

	--bagPosΪ-1����ʾҪ��ʼ������  �رս��� �Ҽ�ȡ����Ʒʱ����
	if bagPos == -1 then
		--�ɺ���Ʒ����
		if interfaceIndex == 1 then
			PetSoul_Fusion_ItemClear(1,0)
		elseif interfaceIndex == 2 then
			PetSoul_Fusion_ItemClear(0,1)
		elseif interfaceIndex == 3 then
			PetSoul_Fusion_ItemClear(1,1)
		end
		return
	end

	--bagPosΪ������ƷBagIndex����ʾ������Ʒ
	local theAction = EnumAction( bagPos, "packageitem");
	if theAction:GetID() ~= 0 then

		--�ж��ǲ��ǻ���
		local nItemIndex = PlayerPackage:GetItemTableIndex(bagPos);
		-- local nItemCount = PlayerPackage:GetBagItemNum(bagPos);
		local nPsIndex, nPsQual = LuaFnGetPetSoulPieceInfo( nItemIndex );
		if nItemIndex == nil or nPsIndex == nil or nPsQual == nil then
			PushDebugMessage("#{SHXT_20211230_111}")
			return
		end

		--����Ƿ����
		if PlayerPackage:IsLock( bagPos ) == 1 then
			PushDebugMessage("#{SHXT_20211230_65}")	--��Ʒ���������޷�����
			return
		end
		
		if interfaceIndex == 1 then --���ұ߿�������Ʒ
			PetSoul_Fusion_ItemPut(bagPos,1,theAction)
		elseif interfaceIndex == 2 then --����߿�������Ʒ
			PetSoul_Fusion_ItemPut(bagPos,2,theAction)
		elseif interfaceIndex == 3 then --����Ҽ������Ʒ
			--����������
			if g_PetSoul_Fusion_ItemBagIndex1 == -1 then
				PetSoul_Fusion_ItemPut(bagPos,1,theAction)
			--��񲻿գ��Ҹ�գ�����ұ�
			elseif g_PetSoul_Fusion_ItemBagIndex1 ~= -1 and g_PetSoul_Fusion_ItemBagIndex2 == -1 then
				PetSoul_Fusion_ItemPut(bagPos,2,theAction)
			--�������Ӷ����գ������
			elseif g_PetSoul_Fusion_ItemBagIndex1 ~= -1 and g_PetSoul_Fusion_ItemBagIndex2 ~= -1 then
				LifeAbility : Lock_Packet_Item(g_PetSoul_Fusion_ItemBagIndex1,0);
				PetSoul_Fusion_ItemPut(bagPos,1,theAction)
			end
		end
		
	else
		PetSoul_Fusion_ItemClear(1,1)
	end
	
	if(g_PetSoul_Fusion_ItemBagIndex1 >= 0 and g_PetSoul_Fusion_ItemBagIndex2 >= 0 )then
		--�жϵ�ǰ�����Ƿ���ͬһ�޻����Ƭ
		if PlayerPackage:GetItemTableIndex(g_PetSoul_Fusion_ItemBagIndex1) ~= PlayerPackage:GetItemTableIndex(g_PetSoul_Fusion_ItemBagIndex2) then
			--PushDebugMessage("#{SHXT_20211230_167}")
			PetSoul_Fusion_Info4:SetText("#{SHXT_20211230_203}")
			PetSoul_Fusion_Object3:SetActionItem(-1)
			PetSoul_Fusion_OK:Disable()
			return
		end
	end

	--ˢ��ȷ�ϰ�ť
	if g_PetSoul_Fusion_ItemBagIndex1 ~= -1 or g_PetSoul_Fusion_ItemBagIndex2 ~= -1 then
		PetSoul_Fusion_OK:Enable()
	else
		PetSoul_Fusion_OK:Disable()
		PetSoul_Fusion_Object3:SetActionItem(-1)
	end
	
	--��ʾ�޻�
	local nItem1Bind , nItem2Bind= 0;
	local nItemIndex = 0;
	local nPsIndex, nPsQual =0;

	if(g_PetSoul_Fusion_ItemBagIndex1 ~= -1)then
		if GetItemBindStatus(g_PetSoul_Fusion_ItemBagIndex1) == 1 then
			nItem1Bind = 1
		end
		nItemIndex = PlayerPackage:GetItemTableIndex(g_PetSoul_Fusion_ItemBagIndex1);
		nPsIndex, nPsQual = LuaFnGetPetSoulPieceInfo( nItemIndex );
	end

	if(g_PetSoul_Fusion_ItemBagIndex2 ~= -1)then
		if GetItemBindStatus(g_PetSoul_Fusion_ItemBagIndex2) == 1 then
			nItem2Bind = 1
		end
		nItemIndex = PlayerPackage:GetItemTableIndex(g_PetSoul_Fusion_ItemBagIndex2);
		nPsIndex, nPsQual = LuaFnGetPetSoulPieceInfo( nItemIndex );
	end

	local nBind = 0;
	if(nItem1Bind == 1) or (nItem2Bind == 1)then
		nBind = 1;
	end
	if(nBind == 0)then
		local theAction2 = GemMelting:UpdateProductAction(tonumber(nPsIndex))
		PetSoul_Fusion_Object3:SetActionItem(theAction2:GetID())
	else
		local theAction2 = GemMelting:UpdateProductAction(tonumber(nPsIndex))
		PetSoul_Fusion_Object3:SetActionItem(theAction2:GetID())
	end

	--��ʾ��Ҫ���޻���Ƭ��
	if g_PetSoul_Fusion_ItemBagIndex1 ~= -1   then
		local nItemIndex = PlayerPackage:GetItemTableIndex(g_PetSoul_Fusion_ItemBagIndex1);
		local nPsIndex, nPsQual = LuaFnGetPetSoulPieceInfo( nItemIndex );
		if(nPsIndex ~= nil and nPsIndex > 0)then
			local text = string.format("#G%s#cfff263��������#G%s#cfff263������#G%s", LuaFnGetItemNameByTableIndex(nPsIndex),LuaFnGetItemNameByTableIndex( nItemIndex ),g_PetSoul_Fusion_QNumber[nPsQual])
			PetSoul_Fusion_Info4:SetText(text)
		end
	end
	if g_PetSoul_Fusion_ItemBagIndex2 ~= -1   then
		local nItemIndex = PlayerPackage:GetItemTableIndex(g_PetSoul_Fusion_ItemBagIndex2);
		local nPsIndex, nPsQual = LuaFnGetPetSoulPieceInfo( nItemIndex );
		if(nPsIndex ~= nil and nPsIndex > 0)then
			local text = string.format("#G%s#cfff263��������#G%s#cfff263������#G%s", LuaFnGetItemNameByTableIndex(nPsIndex),LuaFnGetItemNameByTableIndex( nItemIndex ),g_PetSoul_Fusion_QNumber[nPsQual])
			PetSoul_Fusion_Info4:SetText(text)
		end
	end
end
function LuaFnGetItemNameByTableIndex(ItemID)
	return LifeAbility : GetPrescr_Material(ItemID)
end
function PetSoul_Fusion_OnHiden()
	PetSoul_Fusion_StopCareObject();
	PetSoul_Fusion_Close()
end

function PetSoul_Fusion_Close()
	PetSoul_Fusion_ItemUpdate(-1,3)
	this:Hide()
end

function PetSoul_Fusion_On_ResetPos()
    PetSoul_Fusion_Frame:SetProperty("UnifiedPosition", g_PetSoul_Fusion_UnifiedPosition)
end

function PetSoul_Fusion_FrameInit()
    --����������ʾ��ʼ��
    PetSoul_Fusion_Title:SetText("#{SHXT_20211230_107}")
    PetSoul_Fusion_Info:SetText("#{SHXT_20211230_108}")
	PetSoul_Fusion_Info2:SetText("#{SHXT_20211230_109}")
	PetSoul_Fusion_Info4:SetText("#{SHXT_20211230_201}")
    --��ť������ʾ��ʼ��
    PetSoul_Fusion_OK:SetText("#{SHXT_20211230_61}")
    PetSoul_Fusion_Cancel:SetText("#{SHXT_20211230_63}")
    --��ť�Ƿ����ó�ʼ��
    PetSoul_Fusion_OK:Disable()
end

--=========================================================
--��ʼ����NPC��
--�ڿ�ʼ����֮ǰ��Ҫ��ȷ����������ǲ����Ѿ��С����ġ���NPC��
--����еĻ�����ȡ���Ѿ��еġ����ġ�
--=========================================================
function PetSoul_Fusion_BeginCareObject( objCaredId )
	g_PetSoul_Fusion_NpcId = DataPool : GetNPCIDByServerID( objCaredId )
	if g_PetSoul_Fusion_NpcId == -1 then
		this : Hide()
		return
	end

	this : CareObject( g_PetSoul_Fusion_NpcId, 1, "PetSoul_Fusion" )
end

--=========================================================
--ֹͣ��ĳNPC�Ĺ���
--=========================================================
function PetSoul_Fusion_StopCareObject()
	this : CareObject( g_PetSoul_Fusion_NpcId, 0, "PetSoul_Fusion" )
	g_PetSoul_Fusion_NpcId = -1
end