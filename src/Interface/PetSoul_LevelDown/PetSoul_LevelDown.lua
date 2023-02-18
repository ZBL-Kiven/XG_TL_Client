--���޷��� PetSoul_LevelDown

local g_PetSoul_LevelDown_UnifiedPosition;

local MAX_OBJ_DISTANCE = 3.0

local g_PetSoul_LevelDown_NpcId = -1;

local g_PetSoul_LevelDown_ItemBagIndex = -1

local g_PetSoul_LevelDown_TargetId = -1


function PetSoul_LevelDown_PreLoad()

	this:RegisterEvent("UI_COMMAND");

	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")

    this:RegisterEvent("OBJECT_CARED_EVENT");           --ĳ�߼������ĳЩ�����ı䣬���ھ���NPC��Զ��رս���
    
    this:RegisterEvent("UNIT_MONEY")					--��Ǯ�仯
	this:RegisterEvent("MONEYJZ_CHANGE")			    --���ӱ仯

	this:RegisterEvent("PETSOUL_LEVELDOWN_PUTIN_ITEM"); --������Ʒ
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")			--��������Ʒ�ı�
	this:RegisterEvent("RESUME_ENCHASE_GEM"); --��ק�ر���
	
end

function PetSoul_LevelDown_OnLoad()
    
    g_PetSoul_LevelDown_UnifiedPosition=PetSoul_LevelDown_Frame:GetProperty("UnifiedPosition")
	
end

function PetSoul_LevelDown_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == 80012705 ) then
		local bIsShow = Get_XParam_INT(0);
		if bIsShow == 1 then
			this:Show()
            OpenWindow("Packet")
        end

        if this:IsVisible() then
			g_PetSoul_LevelDown_TargetId = Get_XParam_INT( 1 )
            PetSoul_LevelDown_BeginCareObject( g_PetSoul_LevelDown_TargetId )
            PetSoul_LevelDown_FrameInit()
            PetSoul_LevelDown_MoneyUpdate()
		end

		return
	elseif event == "UI_COMMAND" and tonumber(arg0) == 201107281 and this:IsVisible() then
		if arg1 ~= nil then 
			PetSoul_LevelDown_ItemUpdate(tonumber(arg1))
		end

		return
	elseif( event == "RESUME_ENCHASE_GEM" and this:IsVisible() ) then
		if(arg0~=nil and tonumber(arg0) == 29) then---xml�����õ��� �޻�W29 
			PetSoul_LevelDown_Resume_Equip()
		end
		
		return
	elseif event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() then
		if not arg0 or tonumber(arg0) == -1 then
			return
		end
		
		if tonumber(arg0) == g_PetSoul_LevelDown_ItemBagIndex then
			PetSoul_LevelDown_ItemUpdate(-1)
		end 
		
		PetSoul_LevelDown_MoneyUpdate()--����Ǯ��ˢ��

		return
    elseif event == "OBJECT_CARED_EVENT" and this : IsVisible() then
		if(tonumber(arg0) ~= g_PetSoul_LevelDown_NpcId) then
			return;
		end
		
		--�����NPC�ľ������һ��������߱�ɾ�����Զ��ر�
		if arg1 == "distance" and tonumber( arg2 ) > MAX_OBJ_DISTANCE or arg1 == "destroy" then
			PetSoul_LevelDown_Close()
		end

        return
    elseif event == "UNIT_MONEY" or event == "MONEYJZ_CHANGE" then
        PetSoul_LevelDown_MoneyUpdate()--��Ǯ���� ����ˢ��
        return
    elseif event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED"then
		PetSoul_LevelDown_On_ResetPos()
		return
	end
end

function PetSoul_LevelDown_ItemUpdate(bagPos)

	--bagPosΪ-1����ʾҪ��ʼ������  �رս��� �Ҽ�ȡ����Ʒʱ����
	if bagPos == -1 then
		--������Ʒ���ÿ�
		PetSoul_LevelDown_Object:SetActionItem(-1)
		--�ɺ���Ʒ����
		if g_PetSoul_LevelDown_ItemBagIndex ~= -1 then
			LifeAbility : Lock_Packet_Item(g_PetSoul_LevelDown_ItemBagIndex,0);
			g_PetSoul_LevelDown_ItemBagIndex = -1;
		end

		PetSoul_LevelDown_Explain:SetText("#{SHXT_20211230_122}")
		PetSoul_LevelDown_NeedYuanBaoObject:SetText("#{SHXT_20211230_121}")
		PetSoul_LevelDown_Demand_Jiaozi:SetProperty("MoneyNumber", "0")

		--ˢ��ȷ�ϰ�ť
		if g_PetSoul_LevelDown_ItemBagIndex ~= -1 then
			PetSoul_LevelDown_OK:Enable()
		else
			PetSoul_LevelDown_OK:Disable()
		end
		
		return
	end
	
	--bagPosΪ������ƷBagIndex����ʾ������Ʒ
	local theAction = EnumAction( bagPos, "packageitem");
	if theAction:GetID() ~= 0 then

		--����Ƿ�Ϊ�޻�
		local nLevel=LuaFnGetPetSoulDataInBag( bagPos, "LEVEL")
		if nLevel == nil  then
			PushDebugMessage("#{SHXT_20211230_124}")
			return
		end

		--�ж���Ʒ�Ƿ����� 
		if PlayerPackage:IsLock(bagPos) == 1 then
			PushDebugMessage("#{SHXT_20211230_65}")
			return
		end

		--����޻�ȼ��Ƿ����1
		if(nLevel <= 1)then
			PushDebugMessage("#{SHXT_20211230_125}")
			return
		end

		--�ɺ���Ʒ����
		if g_PetSoul_LevelDown_ItemBagIndex ~= -1 then
			LifeAbility : Lock_Packet_Item(g_PetSoul_LevelDown_ItemBagIndex,0);
			g_PetSoul_LevelDown_ItemBagIndex = -1;
		end
		g_PetSoul_LevelDown_ItemBagIndex = bagPos;
		PetSoul_LevelDown_Object:SetActionItem(theAction:GetID());
		LifeAbility : Lock_Packet_Item(bagPos,1);

		local nQual=LuaFnGetPetSoulDataInBag( bagPos, "QUAL")
		local nGiveItemCount,nItemCount,nMoneyCount = LuaFnGetPetSoulLeveldownCost(nLevel,nQual)

		PetSoul_LevelDown_NeedYuanBaoObject:SetText(string.format("#cfff263��Ҫ���ķ��굤��#G%s#cfff263��",tostring(nItemCount)))
		PetSoul_LevelDown_Explain:SetText(string.format("�ɵõ������굤������#G%s#cfff263��",tostring(nGiveItemCount)))
		PetSoul_LevelDown_Demand_Jiaozi:SetProperty("MoneyNumber", tostring(nMoneyCount))
	else
		--������Ʒ���ÿ�
		PetSoul_LevelDown_Object:SetActionItem(-1)
		--�ɺ���Ʒ����
		if g_PetSoul_LevelDown_ItemBagIndex ~= -1 then
			LifeAbility : Lock_Packet_Item(g_PetSoul_LevelDown_ItemBagIndex,0);
			g_PetSoul_LevelDown_ItemBagIndex = -1;
		end
	end

	--ˢ��ȷ�ϰ�ť
	if g_PetSoul_LevelDown_ItemBagIndex ~= -1 then
		PetSoul_LevelDown_OK:Enable()
	else
		PetSoul_LevelDown_OK:Disable()
	end
end

function PetSoul_LevelDown_Buttons_Clicked()
	--�������� �绰�ܱ����
	-- if CheckPhoneMibaoAndMinorPassword() ~= 1 then
		-- PushDebugMessage("#{SHXT_20211230_67}")
		-- return
	-- end
	
	--�Ƿ�����޻�
	if g_PetSoul_LevelDown_ItemBagIndex < 0 then
		PushDebugMessage("#{SHXT_20211230_68}")
		return
	end

	Clear_XSCRIPT()
		Set_XSCRIPT_ScriptID( 742563 )
		Set_XSCRIPT_Function_Name( "PetSoulCenter" )
		Set_XSCRIPT_Parameter(0, 2)
		Set_XSCRIPT_Parameter(1, g_PetSoul_LevelDown_TargetId)
		Set_XSCRIPT_Parameter(2, g_PetSoul_LevelDown_ItemBagIndex)
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
end

function PetSoul_LevelDown_Resume_Equip()

	PetSoul_LevelDown_ItemUpdate(-1)
end


function PetSoul_LevelDown_OnHiden()
	PetSoul_LevelDown_StopCareObject();
	PetSoul_LevelDown_Close()
end

function PetSoul_LevelDown_Close()
	PetSoul_LevelDown_ItemUpdate(-1)
	this:Hide()
end

function PetSoul_LevelDown_On_ResetPos()
    PetSoul_LevelDown_Frame:SetProperty("UnifiedPosition", g_PetSoul_LevelDown_UnifiedPosition)
end

function PetSoul_LevelDown_FrameInit()
    --����������ʾ��ʼ��
    PetSoul_LevelDown_Title:SetText("#{SHXT_20211230_118}")
    PetSoul_LevelDown_Info:SetText("#{SHXT_20211230_119}")
	PetSoul_LevelDown_Info2:SetText("#{SHXT_20211230_120}")
	PetSoul_LevelDown_Explain:SetText("#{SHXT_20211230_122}")
    --��ť������ʾ��ʼ��
    PetSoul_LevelDown_OK:SetText("#{SHXT_20211230_61}")
	PetSoul_LevelDown_Cancel:SetText("#{SHXT_20211230_63}")
    --��ť�Ƿ����ó�ʼ��
    PetSoul_LevelDown_OK:Disable()
end

--��Ǯ���� ����ˢ��
function PetSoul_LevelDown_MoneyUpdate()
    PetSoul_LevelDown_Currently_Money:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
	PetSoul_LevelDown_Currently_Jiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
end

--=========================================================
--��ʼ����NPC��
--�ڿ�ʼ����֮ǰ��Ҫ��ȷ����������ǲ����Ѿ��С����ġ���NPC��
--����еĻ�����ȡ���Ѿ��еġ����ġ�
--=========================================================
function PetSoul_LevelDown_BeginCareObject( objCaredId )
	g_PetSoul_LevelDown_NpcId = DataPool : GetNPCIDByServerID( objCaredId )
	if g_PetSoul_LevelDown_NpcId == -1 then
		this : Hide()
		return
	end
	this : CareObject( g_PetSoul_LevelDown_NpcId, 1, "PetSoul_LevelDown" )
end

--=========================================================
--ֹͣ��ĳNPC�Ĺ���
--=========================================================
function PetSoul_LevelDown_StopCareObject()
	this : CareObject( g_PetSoul_LevelDown_NpcId, 0, "PetSoul_LevelDown" )
	g_PetSoul_LevelDown_NpcId = -1
end


