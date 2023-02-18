--PetPropagateSingle.lua
--�������޷�ֳ����(��������)
local firstPet  = { idx = -1, guid = { high = -1, low = -1 } }
local secondPet = { idx = -1, guid = { high = -1, low = -1 } }
local g_currentChoose = -1
local g_wastemoney 	= 20000
--�������޷�ֳ����
local g_ItemPos 	= -1
--�������޷�ֳ����ID ����С��
local g_ItemTblID   = 30309794
--
local g_clientNpcId = -1
local g_serverNpcId = -1

local g_PetPropagateSingle_Frame_UnifiedPosition;

--*************************************************
--
--*************************************************
function PetPropagateSingle_PreLoad()
	this : RegisterEvent( "UNIT_MONEY" )
	this : RegisterEvent( "UI_COMMAND" )
	this : RegisterEvent( "MONEYJZ_CHANGE" )
	this : RegisterEvent( "REPLY_MISSION_PET" )				-- ��Ҵ��б�ѡ��һֻ����
	this : RegisterEvent( "UPDATE_PET_PAGE" )				-- ������ϵ��������ݷ����仯
	this : RegisterEvent( "DELETE_PET" )					-- ������ϼ���һֻ����
	this : RegisterEvent( "OBJECT_CARED_EVENT" )			-- ���� NPC �Ĵ��ںͷ�Χ
	this : RegisterEvent( "UNIT_MONEY" )
	this : RegisterEvent( "MONEYJZ_CHANGE" )				--����
	this : RegisterEvent( "PACKAGE_ITEM_CHANGED" )
	this : RegisterEvent( "UPDATE_PET_PROPAGASINGLE" )
	this : RegisterEvent( "TEAM_PETCREATE_OPENED" )
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function PetPropagateSingle_OnLoad()
 	g_PetPropagateSingle_Frame_UnifiedPosition=PetPropagateSingle_Frame:GetProperty("UnifiedPosition");
end

--*************************************************
--
--*************************************************
function PetPropagateSingle_OnEvent(event)

	if ( event == "UI_COMMAND" ) then
		PetPropagateSingle_UICommand(arg0)

	elseif ( event == "UNIT_MONEY" )		then
		PetPropagateSingle_ShowMoney()

	elseif ( event == "MONEYJZ_CHANGE")		then
		PetPropagateSingle_ShowJZ()

	elseif ( event == "REPLY_MISSION_PET" ) then
		PetPropagateSingle_SelectPet(arg0)

	elseif ( event == "UPDATE_PET_PAGE" ) 	then
		PetPropagateSingle_UpdatePetSelected()

	elseif ( event == "DELETE_PET" ) 		then
		PetPropagateSingle_UpdatePetSelected()

	elseif ( event == "OBJECT_CARED_EVENT" )		then
		PetPropagateSingle_CareObj(arg0,arg1,arg2)

	elseif ( event == "PACKAGE_ITEM_CHANGED" ) 		then
		if ( arg0 ~= nil and -1 == tonumber(arg0)) 	then
			return
		end

		if tonumber(arg0) == g_ItemPos then
			PetPropagateSingle_Resume_Object()
		end

	elseif ( event == "UPDATE_PET_PROPAGASINGLE" ) 	then
		PetPropagateSingle_Update(arg0)

	elseif ( event == "TEAM_PETCREATE_OPENED" ) then
		if (this : IsVisible() == false) then
			return
		end

		if (g_clientNpcId ~= -1) then
			this : CareObject(g_clientNpcId, 0, "PetPropagateSingle")
		end

		PetPropagateSingle_Clear()
		Pet : ShowPetList( 1 )
		this : Hide()
		
	elseif (event == "ADJEST_UI_POS" ) then
		PetPropagateSingle_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		PetPropagateSingle_Frame_On_ResetPos()
		
	end
end

--*************************************************
--�������޷�ֳ�����������
--*************************************************
function PetPropagateSingle_UICommand(arg0)
	local nOpt = tonumber(arg0)
	if (nOpt == 20091025) then
		Pet : CloseTeamPetProCreate()
		PetPropagateSingle_Show()
	end
end

--*************************************************
--�������ȷ��Ҫ��������
--*************************************************
function PetPropagateSingle_OK_Clicked()
	-- ���� UI_Command ���кϳ�
	local nName1 = PetPropagateSingle_PetName1 : GetText()
	local nName2 = PetPropagateSingle_PetName2 : GetText()
	if (firstPet.guid.high == -1 or firstPet.guid.low == -1	or secondPet.guid.high == -1 or secondPet.guid.low == -1) then
		PushDebugMessage("��ѡ�����ޣ�")
		return
	end

	if (nName1 == nil or nName1 == "" or nName2 == nil or nName2 == "") then
		PushDebugMessage("��ѡ�����ޣ�")
		return
	end

	if (g_ItemPos == -1) then
		PushDebugMessage("#{DRFZZC_091013_17}")
		return
	end

	local nItemID = PlayerPackage : GetItemTableIndex( g_ItemPos )
	if (nItemID ~= g_ItemTblID) then
		PushDebugMessage("#{DRFZZC_091013_17}")
		return
	end

	--��Ǯ�Ƿ��㹻
	local nHaveMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")
	if (nHaveMoney < g_wastemoney) then
		PushDebugMessage("#{no_money}")
		return
	end

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "OnSignalPetProcreateRegister" )
		Set_XSCRIPT_ScriptID( 800101 )
		Set_XSCRIPT_Parameter( 0, g_serverNpcId )
		Set_XSCRIPT_Parameter( 1, firstPet.guid.high )
		Set_XSCRIPT_Parameter( 2, firstPet.guid.low )
		Set_XSCRIPT_Parameter( 3, secondPet.guid.high )
		Set_XSCRIPT_Parameter( 4, secondPet.guid.low )
		Set_XSCRIPT_Parameter( 5, g_ItemPos )
		Set_XSCRIPT_ParamCount( 6 )
	Send_XSCRIPT()
end

--*************************************************
--���X��ť�����ش��ڡ�
--*************************************************
function PetPropagateSingle_OnHidden()
	if (this : IsVisible() == false) then
		return
	end

	if (g_clientNpcId ~= -1) then
		this : CareObject(g_clientNpcId, 0, "PetPropagateSingle")
	end

	PetPropagateSingle_Clear()
	Pet : ShowPetList( 0 )
	this : Hide()
end

--*************************************************
--���ȡ����ť���������غ���
--*************************************************
function PetPropagateSingle_Close_Window()
	if (this : IsVisible() == false) then
		return
	end

	if (g_clientNpcId ~= -1) then
		this : CareObject(g_clientNpcId, 0, "PetPropagateSingle")
	end

	PetPropagateSingle_Clear()
	Pet : ShowPetList( 0 )
	this : Hide()
end

--*************************************************
--����NPC
--*************************************************
function PetPropagateSingle_CareObj(careId, op, distance)
	if(nil == careId or nil == op or nil == distance) then
		return;
	end

	if(tonumber(careId) ~= g_clientNpcId) then
		return;
	end

	if(op == "distance" and tonumber(distance)>MAX_OBJ_DISTANCE or op=="destroy") then
		PetPropagateSingle_OnHidden()
	end
end

--*************************************************
--�򿪵������޷�ֳ����
--*************************************************
function PetPropagateSingle_Show()
	if (this : IsVisible()) then									-- ������濪�ţ��򲻴���
		return
	end

	--���������
	g_serverNpcId = Get_XParam_INT(0)
	g_clientNpcId = Target : GetServerId2ClientId(g_serverNpcId)

	if (g_clientNpcId == -1) then
		return
	end

	this : CareObject(g_clientNpcId, 1, "PetPropagateSingle")

	--������ʾ����
	PetPropagateSingle_Clear()
	Pet : ShowPetList( 0 )
	this : Show()

	local npcObjId = Get_XParam_INT( 0 )
	BeginCareObject( npcObjId )

	PetPropagateSingle_SelfJiaozi : SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
	PetPropagateSingle_SelfMoney  : SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
	PetPropagateSingle_PetList_Select1 : Enable()
	PetPropagateSingle_PetList_Select2 : Enable()
end


--*************************************************
--ѡ������
--*************************************************
function PetPropagateSingle_SelectPet_Clicked(type)
	if (type == "first") then
		g_currentChoose = 1
		PetPropagateSingle_PetList_Select1 : Disable()
		PetPropagateSingle_PetList_Select2 : Enable()
	elseif (type == "second") then
		g_currentChoose = 2
		PetPropagateSingle_PetList_Select1 : Enable()
		PetPropagateSingle_PetList_Select2 : Disable()
	else
		return
	end
	-- ��һ���ٿ����������
	Pet : ShowPetList( 0 )
	Pet : ShowPetList( 1 )
end

--***************************************************
--
--***************************************************
function PetPropagateSingle_SelectPet( arg0 )

	--�жϵ������޷�ֳ
	if (not (this : IsVisible())) then
		return
	end

	--��������
	local petIdx = tonumber(arg0)
	if (-1 == petIdx) then
		return
	end
	
	--�����ѱ���������ѡ�����ų��������޷�ֳ���棬�ɺ����ж�
	if (Pet:GetPetLocation(petIdx) ~= -1 and Pet:GetPetLocation(petIdx) ~= 2) then
		return;
	end

	--�ж��Ƿ����޼���
	if (PlayerPackage:IsPetLock(petIdx) == 1) then
		PushDebugMessage("#{DRFZZC_091013_09}")
		return
	end

	--�ж��Ƿ����޳�ս
	if (Pet : GetIsFighting(petIdx) == 1) then
		PushDebugMessage("#{DRFZZC_091013_10}")
		return
	end

	--�ж��Ƿ�Ϊ���ޱ���
	--if (Pet : GetPetType(petIdx) ~= 0) then
	--	PushDebugMessage("#{DRFZZC_091013_11}")
	--	return
	--end

	--�ж������Ƿ�Ϊ�û�
	if (Pet : GetGeneration(petIdx) >= 100 ) then
		PushDebugMessage("#{DRFZZC_091013_12}")
		return
	end

	--�ж������Ƿ���ֶ�Ϊ100
	if (Pet : GetHappy(petIdx) ~= 100) then
		PushDebugMessage("#{DRFZZC_091013_13}")
		return
	end

	--�ж������Ƿ���װ��
	if (Pet : IsPetHaveEquip(petIdx) == 1) then
		PushDebugMessage("#{DRFZZC_091013_14}")
		return
	end

	--�ж����������Ƿ�Ϊ1000
	if (Pet : GetNaturalLife(petIdx) < 1000) then
		PushDebugMessage("#{DRFZZC_091013_15}")
		return
	end

	local petName = Pet : GetPetList_Appoint( petIdx )
	local guidH, guidL = Pet : GetGUID( petIdx )

	if (g_currentChoose == 1) then
		--�ж��Ƿ��һ�����޺͵ڶ���������ͬһ������
		if (secondPet.idx ~= -1 and secondPet.idx == petIdx) then
			ShowSystemTipInfo( "�������ֻ��ͬ�����ޡ�" )
			return
		end

		--��������������ˣ����
		PetPropagateSingle_RemoveFirstPet()

		firstPet.idx = petIdx
		firstPet.guid.high = guidH
		firstPet.guid.low  = guidL

		--��д��һ����������
		PetPropagateSingle_PetName1 : SetText( petName )
		Pet : SetPetLocation( petIdx , 2 )
		Pet : UpdatePetList()

	elseif (g_currentChoose == 2) then
		--�ж��Ƿ��һ�����޺͵ڶ���������ͬһ������
		if (firstPet.idx ~= -1 and firstPet.idx == petIdx) then
			ShowSystemTipInfo( "�������ֻ��ͬ�����ޡ�" )
			return
		end

		--��������������ˣ����
		PetPropagateSingle_RemoveSecondPet()

		secondPet.idx = petIdx
		secondPet.guid.high = guidH
		secondPet.guid.low  = guidL

		--��д�ڶ������޵�����
		PetPropagateSingle_PetName2 : SetText( petName )
		Pet : SetPetLocation( petIdx , 2 )
		Pet : UpdatePetList()
	end

	--��ʾ���Ķ��ٽ�Ǯ
	PetPropagateSingle_CalcCost()
end

--***************************************************
--��յ�һ������
--***************************************************
function PetPropagateSingle_RemoveFirstPet()
	if (firstPet.idx ~= -1) then
		Pet : SetPetLocation( firstPet.idx, -1 )
		-- ���������б����
		Pet : UpdatePetList()
	end

	firstPet.idx = -1
	firstPet.guid.high = -1
	firstPet.guid.low  = -1
	PetPropagateSingle_PetName1 : SetText( "" )
end


--***************************************************
--��յڶ�������
--***************************************************
function PetPropagateSingle_RemoveSecondPet()
	if (secondPet.idx ~= -1) then
		Pet : SetPetLocation( secondPet.idx, -1 )
		-- ���������б����
		Pet : UpdatePetList()
	end

	secondPet.idx = -1
	secondPet.guid.high = -1
	secondPet.guid.low  = -1
	PetPropagateSingle_PetName2 : SetText( "" )
end


--****************************************************
--�����Ǯ����
--****************************************************
function PetPropagateSingle_CalcCost()
	PetPropagateSingle_Money : SetProperty( "MoneyNumber", tostring( g_wastemoney ) )
end


--****************************************************
--���½���
--****************************************************
function PetPropagateSingle_Update( pos_packet )
	if (pos_packet == nil) then
		return
	end

	local BagPos = tonumber( pos_packet )

	--�Ƿ����....
	if (PlayerPackage:IsLock(BagPos) == 1) then
		PushDebugMessage("#{Item_Locked}")
		return
	end

	--���µ������޷�ֳ���Ͻ���
	local ItemID = PlayerPackage : GetItemTableIndex( BagPos )
	if ( ItemID <= 0) then
		PushDebugMessage("#{GMActionSystem_Item_CantUseInPetSkillStudy}")
		return
	end

	--�鿴��Ʒ�Ƿ��ǡ�����С�ѡ�
	if ( ItemID ~= g_ItemTblID) then
		PushDebugMessage("#{DRFZZC_091013_17}")
		return
	end

	--������Ʒλ���Ƿ�Ϸ�
	if (g_ItemPos ~= -1) then
		LifeAbility : Lock_Packet_Item( g_ItemPos, 0 )
	end

	LifeAbility : Lock_Packet_Item( BagPos, 1 )
	g_ItemPos = BagPos

	--�������޻�ͯ�����޽���
	local theAction = EnumAction( BagPos, "packageitem" )
	if (theAction : GetID() == 0) then
		return
	end

	PetPropagateSingle_Object : SetActionItem( theAction : GetID() )
	PetPropagateSingle_CalcCost()
end


--*************************************************
--
--*************************************************
function PetPropagateSingle_Resume_Object()
	PetPropagateSingle_ClearActionItem()
end

--*************************************************
--
--*************************************************
function PetPropagateSingle_Clear()
	PetPropagateSingle_ClearPetName()
	PetPropagateSingle_ClearActionItem()
	PetPropagateSingle_ClearMoney()
end

--*************************************************
--���������������
--*************************************************
function PetPropagateSingle_ClearPetName()
	PetPropagateSingle_RemoveFirstPet()
	PetPropagateSingle_RemoveSecondPet()
end

--*************************************************
--��շ�ֳ��Ʒ
--*************************************************
function PetPropagateSingle_ClearActionItem()
	if g_ItemPos ~= -1 then
		LifeAbility : Lock_Packet_Item( g_ItemPos, 0 )
		PetPropagateSingle_Object : SetActionItem( -1 )
		g_ItemPos = -1
	end
end

--*************************************************
--��ս�Ǯ
--*************************************************
function PetPropagateSingle_ClearMoney()
	PetPropagateSingle_Money : SetProperty( "MoneyNumber", 0 )
	PetPropagateSingle_SelfJiaozi : SetProperty( "MoneyNumber", 0 )
	PetPropagateSingle_SelfMoney  : SetProperty( "MoneyNumber", 0 )
end

--*************************************************
--ѡ�����޸���
--*************************************************
function PetPropagateSingle_UpdatePetSelected()
	-- �жϱ�ѡ�е������Ƿ��ڱ�����
	if (firstPet.idx ~= -1) then
		local newIdx = Pet : GetPetIndexByGUID( firstPet.guid.high, firstPet.guid.low )
		Pet : SetPetLocation( firstPet.idx, -1 )
		-- ���������ɾ��
		if (newIdx == -1) then
			firstPet.idx = -1
			firstPet.guid.high = -1
			firstPet.guid.low  = -1
			PetPropagateSingle_PetName1 : SetText( "" )
		-- �����ж����޵�λ���Ƿ����仯
		elseif (newIdx ~= firstPet.idx) then
			-- ��������仯���λ�ý��и���
			firstPet.idx = newIdx
		end
	end

	-- �жϱ�ѡ�е������Ƿ��ڱ�����
	if (secondPet.idx ~= -1) then
		local newIdx = Pet : GetPetIndexByGUID( secondPet.guid.high, secondPet.guid.low )
		Pet : SetPetLocation( secondPet.idx, -1 )
		-- ���������ɾ��
		if (newIdx == -1) then
			secondPet.idx = -1
			secondPet.guid.high = -1
			secondPet.guid.low  = -1
			PetPropagateSingle_PetName2 : SetText( "" )
		-- �����ж����޵�λ���Ƿ����仯
		elseif (newIdx ~= secondPet.idx) then
			-- ��������仯���λ�ý��и���
			secondPet.idx = newIdx
		end
	end
end

--********************************************
--��ʾ����ӵ�еĽ�Ǯ
--********************************************
function PetPropagateSingle_ShowMoney()
	PetPropagateSingle_SelfMoney : SetProperty( "MoneyNumber", tostring(Player:GetData("MONEY")) )
end

--********************************************
--��ʾ����ӵ�еĽ���
--********************************************
function PetPropagateSingle_ShowJZ()
	PetPropagateSingle_SelfJiaozi : SetProperty( "MoneyNumber", tostring(Player:GetData("MONEY_JZ")) )
end

function PetPropagateSingle_Frame_On_ResetPos()
  PetPropagateSingle_Frame:SetProperty("UnifiedPosition", g_PetPropagateSingle_Frame_UnifiedPosition);
end
