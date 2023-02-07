--PetSoul_Addlife

local g_PetSoul_Addlife_UnifiedPosition;

local MAX_OBJ_DISTANCE = 3.0

local g_PetSoul_Addlife_NpcId = -1;
local g_PetSoul_Addlife_targetId = -1;
local g_PetSoul_Addlife_PetSoulBagIndex = -1
local g_PetSoul_Addlife_PetSoulPieceBagIndex=-1;

-- �����ṩ����Ԫ
local g_PetSoul_Addlife_LifeValue = {	
	[0] = 50,
	[1] = 100,
	[2] = 200,
}
	
function PetSoul_Addlife_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("PETSOUL_ADDLIFE_PUTIN_ITEM");
	this:RegisterEvent("RESUME_ENCHASE_GEM")
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")			--��������Ʒ�ı���Ҫ�ж�
	this:RegisterEvent("UNIT_MONEY")					--��Ǯ�仯
	this:RegisterEvent("MONEYJZ_CHANGE")					--���ӱ仯
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function PetSoul_Addlife_OnLoad()
	
	g_PetSoul_Addlife_UnifiedPosition=PetSoul_Addlife_Frame:GetProperty("UnifiedPosition")
	
end

function PetSoul_Addlife_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == 80012703 ) then
		
		local bIsShow = Get_XParam_INT(0);
		if bIsShow == 1 then
			PetSoul_Addlife_Clear();
			OpenWindow("Packet")
			this:Show()
		end
		
		if this:IsVisible() then
			g_PetSoul_Addlife_targetId = Get_XParam_INT( 1 )
			PetSoul_Addlife_BeginCareObject( g_PetSoul_Addlife_targetId )
			
			PetSoul_Addlife_Currently_Money:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
			PetSoul_Addlife_Currently_Jiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
		end
		
	elseif event == "PETSOUL_ADDLIFE_PUTIN_ITEM" and this:IsVisible() then
		if arg0 ~= nil and arg1 ~= nil then
			PetSoul_Addlife_Update( tonumber(arg0), tonumber(arg1), 0 )
		end
		
	elseif ( event == "RESUME_ENCHASE_GEM" and this:IsVisible() ) then
		if tonumber(arg0) == 18 then
			PetSoul_Addlife_Resume_PetSoul()
		elseif tonumber(arg0) == 19 then
			PetSoul_Addlife_Resume_Piece();
		end
						
	elseif event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() then
		
		if not arg0 or tonumber(arg0) == -1 then
			return
		end
		
		if tonumber(arg0) == g_PetSoul_Addlife_PetSoulBagIndex then
			PetSoul_Addlife_Update( 0, g_PetSoul_Addlife_PetSoulBagIndex, 1)
		end 
				
		PetSoul_Addlife_Currently_Money:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
		PetSoul_Addlife_Currently_Jiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
		return
		
	elseif event == "UNIT_MONEY" and this:IsVisible() then
		PetSoul_Addlife_Currently_Money:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
		return
	
	elseif event == "MONEYJZ_CHANGE" and this:IsVisible() then
		PetSoul_Addlife_Currently_Jiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
		return
				
	elseif event == "OBJECT_CARED_EVENT" and this : IsVisible() then
		if(tonumber(arg0) ~= g_PetSoul_Addlife_NpcId) then
			return;
		end
		
		--�����NPC�ľ������һ��������߱�ɾ�����Զ��ر�
		if arg1 == "distance" and tonumber( arg2 ) > MAX_OBJ_DISTANCE or arg1 == "destroy" then
			PetSoul_Addlife_Close()
		end
		return
		
	elseif event == "ADJEST_UI_POS" then
		PetSoul_Addlife_On_ResetPos()
		return
	
	elseif event == "VIEW_RESOLUTION_CHANGED" then
		PetSoul_Addlife_On_ResetPos()
		return
	end
	
end

-- uiPos:0�ŵ��޻��; 1~8 �ŵ������; -1 Ѱ�ҿ��еĻ����
function PetSoul_Addlife_Update( uiPos, bagPos, bItemChanged )

	if bItemChanged == nil then
		bItemChanged = 0;
	end
	
	local theAction = EnumAction( bagPos, "packageitem");
	if theAction:GetID() == 0 then
		return
	end
		
	-- Ѱ�ҿ��еĻ����
	if uiPos == -1 then
		if g_PetSoul_Addlife_PetSoulBagIndex >= 0 then
			uiPos = 1;
		else
			uiPos = 0;
		end
	end
	
	if uiPos == 0 then
		--����Ƿ�Ϊ�޻�
		local nPsIndex = PlayerPackage:GetItemTableIndex(bagPos);
		local nPsLife =PlayerPackage:LuaFnGetPetSoulDataInBag( bagPos, "LIFE")
		if nPsIndex == nil or nPsLife == nil then
			PushDebugMessage("#{SHXT_20211230_98}")
			return
		end
				
		--����޻���Ԫ�Ƿ�����
		local nMaxLife = Pet:LuaFnGetPetSoulMaxLife(nPsIndex)
		if nPsLife >= nMaxLife then
			if bItemChanged == 0 then
				PushDebugMessage("#{SHXT_20211230_99}" )
			else
				PetSoul_Addlife_Resume_Piece();
				PetSoul_Addlife_Refresh_UI()
			end
			return
		end
		
		if g_PetSoul_Addlife_PetSoulBagIndex ~= -1 then
			LifeAbility : Lock_Packet_Item(g_PetSoul_Addlife_PetSoulBagIndex,0);
		end
		
		if g_PetSoul_Addlife_PetSoulPieceBagIndex ~= nil and g_PetSoul_Addlife_PetSoulPieceBagIndex >= 0 then
			PetSoul_Addlife_Resume_Piece()
		end
		
		PetSoul_Addlife_Object:SetActionItem(theAction:GetID());
		LifeAbility : Lock_Packet_Item(bagPos,1);
		g_PetSoul_Addlife_PetSoulBagIndex = bagPos
		
	elseif uiPos == 1  then
	
		--����Ƿ�Ϊ����
		local nItemIndex = PlayerPackage:GetItemTableIndex(bagPos);
		local nPsIndex, nPsQual = Pet:LuaFnGetPetSoulPieceInfo( nItemIndex );
		if nItemIndex == nil or nPsIndex == nil or nPsQual == nil then
			PushDebugMessage("#{SHXT_20211230_100}")
			return
		end
		
		--����Ƿ����
		if PlayerPackage:IsLock( bagPos ) == 1 then
			PushDebugMessage("#{SHXT_20211230_65}")	--����������
			return
		end
				
		--�Ƿ��ѷ��뱻�����޻�
		if g_PetSoul_Addlife_PetSoulBagIndex < 0 then
			PushDebugMessage("#{SHXT_20211230_101}" )
			return
		end
		local nPetSoulQual =PlayerPackage:LuaFnGetPetSoulDataInBag( g_PetSoul_Addlife_PetSoulBagIndex, "QUAL")
		if nPetSoulQual == nil or nPsQual > nPetSoulQual then
			PushDebugMessage("#{SHXT_20211230_102}" )
			return
		end
		
		--����޻���Ԫ�Ƿ�����
		local nPsIndex = PlayerPackage:GetItemTableIndex(g_PetSoul_Addlife_PetSoulBagIndex);
		local nPsLife =PlayerPackage:LuaFnGetPetSoulDataInBag( g_PetSoul_Addlife_PetSoulBagIndex, "LIFE")
		local nMaxLife = Pet:LuaFnGetPetSoulMaxLife(nPsIndex)
		if nPsLife == nil or nMaxLife == nil or nPsLife >= nMaxLife then
			PushDebugMessage("#{SHXT_20211230_103}" )
			return
		end
				
		if g_PetSoul_Addlife_PetSoulPieceBagIndex ~= -1 then
			LifeAbility : Lock_Packet_Item(g_PetSoul_Addlife_PetSoulPieceBagIndex,0);
		end
		
		PetSoul_Addlife_Piece1:SetActionItem(theAction:GetID());
		LifeAbility : Lock_Packet_Item(bagPos,1);
		g_PetSoul_Addlife_PetSoulPieceBagIndex = bagPos
		
	end
		
	PetSoul_Addlife_Refresh_UI()
end

function PetSoul_Addlife_Resume_PetSoul()
	if g_PetSoul_Addlife_PetSoulBagIndex ~= -1 then
		LifeAbility : Lock_Packet_Item(g_PetSoul_Addlife_PetSoulBagIndex,0);
		PetSoul_Addlife_Object:SetActionItem(-1);
		g_PetSoul_Addlife_PetSoulBagIndex = -1;
	end
	
	PetSoul_Addlife_Resume_Piece();
end

function PetSoul_Addlife_Resume_Piece()
	
	if g_PetSoul_Addlife_PetSoulPieceBagIndex ~= nil and g_PetSoul_Addlife_PetSoulPieceBagIndex >= 0 then
		LifeAbility : Lock_Packet_Item(g_PetSoul_Addlife_PetSoulPieceBagIndex,0);
		PetSoul_Addlife_Piece1:SetActionItem(-1);
		g_PetSoul_Addlife_PetSoulPieceBagIndex = -1;
	end
	
	PetSoul_Addlife_Refresh_UI()
end

function PetSoul_Addlife_Clear()
	PetSoul_Addlife_Resume_PetSoul()
	PetSoul_Addlife_Resume_Piece()
	
	PetSoul_Addlife_Refresh_UI()
	
end

function PetSoul_Addlife_Refresh_UI()

	PetSoul_Addlife_Demand_Jiaozi:SetProperty("MoneyNumber", "0");
	--����ֵ��ʾ����
	local szText = "#{SHXT_20211230_95}";
	if g_PetSoul_Addlife_PetSoulBagIndex >= 0 then
	
		local nPsItemIndex = PlayerPackage:GetItemTableIndex(g_PetSoul_Addlife_PetSoulBagIndex);
		if nPsItemIndex == nil then
			return
		end
		
		local nNeedMoney = 0;
		local nPieceLife = 0;		
		if g_PetSoul_Addlife_PetSoulPieceBagIndex >= 0 then
			local nItemIndex = PlayerPackage:GetItemTableIndex(g_PetSoul_Addlife_PetSoulPieceBagIndex);
			local nPsIndex, nPsQual = Pet:LuaFnGetPetSoulPieceInfo( nItemIndex );
			if nItemIndex == nil or nPsIndex == nil or nPsQual == nil or g_PetSoul_Addlife_LifeValue[nPsQual] == nil then
				return
			end
			
			nPieceLife = g_PetSoul_Addlife_LifeValue[nPsQual];
			nNeedMoney = 30000;
		end
				
		local nPsLife =PlayerPackage:LuaFnGetPetSoulDataInBag( g_PetSoul_Addlife_PetSoulBagIndex, "LIFE")
		local nMaxLife = Pet:LuaFnGetPetSoulMaxLife(nPsItemIndex)
		if nPsLife == nil or nMaxLife == nil then
			return 
		end
		
		--���㵱ǰ���ӵĻ���ֵ
		if nPieceLife > 0 then
			szText = ScriptGlobal_Format("#{SHXT_20211230_97}", nPsLife, nPieceLife, nMaxLife )						
		else
			szText = ScriptGlobal_Format("#{SHXT_20211230_96}", nPsLife, nMaxLife )			
		end
		
		PetSoul_Addlife_Demand_Jiaozi:SetProperty("MoneyNumber", nNeedMoney );
	end
	PetSoul_Addlife_Explain_Text1:SetText(szText);
	
	--ȷ�ϰ�ť
	if g_PetSoul_Addlife_PetSoulBagIndex >= 0 and g_PetSoul_Addlife_PetSoulPieceBagIndex >= 0 then
		PetSoul_Addlife_OK:Enable()
	else
		PetSoul_Addlife_OK:Disable();
	end
end

function PetSoul_Addlife_Buttons_Clicked()

	--�������� �绰�ܱ����
	if CheckPhoneMibaoAndMinorPassword() ~= 1 then
		return
	end
	
	--�޻���������Ƿ��ѷ����޻�
	if g_PetSoul_Addlife_PetSoulBagIndex < 0 then
		PushDebugMessage("#{SHXT_20211230_101}")
		return
	end
	
	Clear_XSCRIPT()
		Set_XSCRIPT_ScriptID( 800127 )
		Set_XSCRIPT_Function_Name( "OnPetSoulAddlife" )
		Set_XSCRIPT_Parameter(0, g_PetSoul_Addlife_targetId)
		Set_XSCRIPT_Parameter(1, g_PetSoul_Addlife_PetSoulBagIndex)
		Set_XSCRIPT_Parameter(2, 0)
		Set_XSCRIPT_Parameter(3, g_PetSoul_Addlife_PetSoulPieceBagIndex)
		Set_XSCRIPT_ParamCount(4)
	Send_XSCRIPT()
	
end

--=========================================================
--��ʼ����NPC��
--�ڿ�ʼ����֮ǰ��Ҫ��ȷ����������ǲ����Ѿ��С����ġ���NPC��
--����еĻ�����ȡ���Ѿ��еġ����ġ�
--=========================================================
function PetSoul_Addlife_BeginCareObject( objCaredId )
	g_PetSoul_Addlife_NpcId = DataPool : GetNPCIDByServerID( objCaredId )
	if g_PetSoul_Addlife_NpcId == -1 then
		this : Hide()
		return
	end

	this : CareObject( g_PetSoul_Addlife_NpcId, 1, "PetSoul_Addlife" )
end

--=========================================================
--ֹͣ��ĳNPC�Ĺ���
--=========================================================
function PetSoul_Addlife_StopCareObject()
	this : CareObject( g_PetSoul_Addlife_NpcId, 0, "PetSoul_Addlife" )
	g_PetSoul_Addlife_NpcId = -1
end

function PetSoul_Addlife_On_ResetPos()
  PetSoul_Addlife_Frame:SetProperty("UnifiedPosition", g_PetSoul_Addlife_UnifiedPosition)
end

function PetSoul_Addlife_OnHiden()
	PushEvent("CLOSE_PETSOULADDLIFE_MSGBOX");
	PetSoul_Addlife_StopCareObject();
	PetSoul_Addlife_Clear();
end

function PetSoul_Addlife_Close()
	this:Hide()
end

