--ProtectGoodsDel.lua
--���ٹ�����Ʒ�Ի���

local	g_btnItem				--��Ʒ��
local	g_posItem	= -1	--��Ʒ�ڱ����е�λ��

local	MAX_OBJ_DISTANCE	= 3.0
local	g_objCared 				= -1

function ProtectGoodsDel_PreLoad()
	this:RegisterEvent( "UI_COMMAND" )
	this:RegisterEvent( "UPDATE_PROTECTGOODSDEL" )
	this:RegisterEvent( "OBJECT_CARED_EVENT" )
	this:RegisterEvent( "PACKAGE_ITEM_CHANGED" )
end

function ProtectGoodsDel_OnLoad()
	g_btnItem	= ProtectGoodsDel_Item
end

function ProtectGoodsDel_OnEvent( event )
	--�򿪽���
	if( event == "UI_COMMAND" and tonumber(arg0) == 43 ) then
		ProtectGoodsDel_OnOpen()
		
		local	xx		= Get_XParam_INT( 0 )
		g_objCared	= DataPool : GetNPCIDByServerID( xx )
		AxTrace( 0, 1, "xx="..xx .. " objCared="..g_objCared )
		if g_objCared == -1 then
				return
		end

		BeginCareObject_ProtectGoodsDel( g_objCared )
		return
	end

	--��Ʒ��ק������
	if( event == "UPDATE_PROTECTGOODSDEL" ) then
		AxTrace( 0, 1, "arg0="..arg0 )
		if arg0 ~= nil then
			ProtectGoodsDel_Clear()
			ProtectGoodsDel_Update( tonumber(arg0) )
		end
		return
	end
	
	--����NPC
	if( event == "OBJECT_CARED_EVENT" and this:IsVisible() ) then
		if( tonumber(arg0) ~= g_objCared ) then
			return;
		end
		--�����NPC�ľ������һ��������߱�ɾ�����Զ��ر�
		if( arg1 == "distance" and tonumber(arg2) > MAX_OBJ_DISTANCE or arg1 == "destroy" ) then
			ProtectGoodsDel_OnClose()
		end
		return
	end
	
	--���������Ʒ�����仯
	if( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() ) then
		if( arg0 ~= nil and -1 == tonumber(arg0) ) then
			return
		end

		if( arg0 ~= nil and g_posItem == tonumber(arg0) ) then
				ProtectGoodsDel_Clear()
				ProtectGoodsDel_Update( tonumber(arg0) )
		end
		return
	end
end

--�򿪽���
function ProtectGoodsDel_OnOpen()
	if not this:IsVisible() then
		this:Show()
	end
	
	--��õ�ǰ����ɾ��������Ʒ��״̬��0��δ���룻1���������룻2�����ɾ���ʸ�
	local	state = Get_XParam_INT( 1 )
	DelProtectGoodsOps("SET_STATE", state)
	if state == 1 or state == 2 then
		ProtectGoodsDel_Button_Apply:Disable()
		ProtectGoodsDel_Button_CancelApply:Enable()
	else
		ProtectGoodsDel_Button_Apply:Enable()
		ProtectGoodsDel_Button_CancelApply:Disable()
	end
	ProtectGoodsDel_Clear()
end

--�رս���
function ProtectGoodsDel_OnClose()
	this:Hide()
	
	StopCareObject_ProtectGoodsDel( g_objCared )
	g_objCared	= -1
end

--���ٰ�ť
function ProtectGoodsDel_OnDestroy()
	if g_posItem ~= -1 then
		--��ȷ�Ͻ���
		DelProtectGoodsOps("OPEN_CONFIRM", g_objCared, g_posItem)
	end
end

--ȡ����ť
function ProtectGoodsDel_OnCancel()
	ProtectGoodsDel_OnClose()
end

--������Ʒ
function ProtectGoodsDel_Clear()
	g_btnItem : SetActionItem( -1 );
	LifeAbility : Lock_Packet_Item( g_posItem, 0 )
	g_posItem	= -1
	ProtectGoodsDel_Button_Accept:Disable()
end

--ˢ����Ʒ
function ProtectGoodsDel_Update( pos_taskitem )
	local	pos	= tonumber( pos_taskitem )
	local	theAction	= EnumAction( pos, "packageitem" )
	
	if theAction:GetID() ~= 0 then
		if PlayerPackage : IsLock( pos ) == 1 then
			PushDebugMessage( "#{SZPR_091023_16}" )
			return
		end
		
		local state = DelProtectGoodsOps("GET_STATE")
		if state ~=2 then
			if state == 0 then
				PushDebugMessage( "#{SCGZ_091119_09}" )
				return
			elseif state == 1 then
				PushDebugMessage( "#{SCGZ_091119_08}" )
				return
			else
				return
			end
		end
		
		if PlayerPackage : IsProtectGoods( pos ) ~= 1 then
			PushDebugMessage( "#{SCGZ_091119_10}" )
			return
		end

		g_btnItem : SetActionItem( theAction:GetID() )
		if g_posItem ~= -1 then
			LifeAbility : Lock_Packet_Item( g_posItem, 0 )
		end

		--�ڱ�������ס�����Ʒ
		g_posItem	= pos
		LifeAbility : Lock_Packet_Item( g_posItem, 1 )
		ProtectGoodsDel_Button_Accept:Enable()

	else
		ProtectGoodsDel_Clear()
		return
	end

end

--=========================================================
--��ʼ����NPC��
--�ڿ�ʼ����֮ǰ��Ҫ��ȷ����������ǲ����Ѿ��С����ġ���NPC��
--����еĻ�����ȡ���Ѿ��еġ����ġ�
--=========================================================
function BeginCareObject_ProtectGoodsDel( objCaredId )
	this:CareObject( objCaredId, 1, "ProtectGoodsDel" )
end

--=========================================================
--ֹͣ��ĳNPC�Ĺ���
--=========================================================
function StopCareObject_ProtectGoodsDel( objCaredId )
	this:CareObject( objCaredId, 0, "ProtectGoodsDel" )
end

function ProtectGoodsDel_OnHide()
	ProtectGoodsDel_Clear();
end

function ProtectGoodsDel_OnApply()
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("ApplyDelProtectGoods");
		Set_XSCRIPT_ScriptID(124);
		Set_XSCRIPT_Parameter(0,tonumber(g_objCared));
		Set_XSCRIPT_Parameter(1,tonumber(1));
		Set_XSCRIPT_ParamCount(2);
	Send_XSCRIPT();
end

function ProtectGoodsDel_OnCancelApply()
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("ApplyDelProtectGoods");
		Set_XSCRIPT_ScriptID(124);
		Set_XSCRIPT_Parameter(0,tonumber(g_objCared));
		Set_XSCRIPT_Parameter(1,tonumber(0));
		Set_XSCRIPT_ParamCount(2);
	Send_XSCRIPT();
end