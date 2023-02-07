--ProtectGoodsDel.lua
--销毁贵重物品对话框

local	g_btnItem				--物品栏
local	g_posItem	= -1	--物品在背包中的位置

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
	--打开界面
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

	--物品拖拽到栏内
	if( event == "UPDATE_PROTECTGOODSDEL" ) then
		AxTrace( 0, 1, "arg0="..arg0 )
		if arg0 ~= nil then
			ProtectGoodsDel_Clear()
			ProtectGoodsDel_Update( tonumber(arg0) )
		end
		return
	end
	
	--关心NPC
	if( event == "OBJECT_CARED_EVENT" and this:IsVisible() ) then
		if( tonumber(arg0) ~= g_objCared ) then
			return;
		end
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if( arg1 == "distance" and tonumber(arg2) > MAX_OBJ_DISTANCE or arg1 == "destroy" ) then
			ProtectGoodsDel_OnClose()
		end
		return
	end
	
	--背包里的物品发生变化
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

--打开界面
function ProtectGoodsDel_OnOpen()
	if not this:IsVisible() then
		this:Show()
	end
	
	--获得当前申请删除贵重物品的状态，0：未申请；1：正在申请；2：获得删除资格
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

--关闭界面
function ProtectGoodsDel_OnClose()
	this:Hide()
	
	StopCareObject_ProtectGoodsDel( g_objCared )
	g_objCared	= -1
end

--销毁按钮
function ProtectGoodsDel_OnDestroy()
	if g_posItem ~= -1 then
		--打开确认界面
		DelProtectGoodsOps("OPEN_CONFIRM", g_objCared, g_posItem)
	end
end

--取消按钮
function ProtectGoodsDel_OnCancel()
	ProtectGoodsDel_OnClose()
end

--清理物品
function ProtectGoodsDel_Clear()
	g_btnItem : SetActionItem( -1 );
	LifeAbility : Lock_Packet_Item( g_posItem, 0 )
	g_posItem	= -1
	ProtectGoodsDel_Button_Accept:Disable()
end

--刷新物品
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

		--在背包中锁住这个物品
		g_posItem	= pos
		LifeAbility : Lock_Packet_Item( g_posItem, 1 )
		ProtectGoodsDel_Button_Accept:Enable()

	else
		ProtectGoodsDel_Clear()
		return
	end

end

--=========================================================
--开始关心NPC，
--在开始关心之前需要先确定这个界面是不是已经有“关心”的NPC，
--如果有的话，先取消已经有的“关心”
--=========================================================
function BeginCareObject_ProtectGoodsDel( objCaredId )
	this:CareObject( objCaredId, 1, "ProtectGoodsDel" )
end

--=========================================================
--停止对某NPC的关心
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