local g_ShowComfirm = 0
local NpcServerId = 0
local FriendActivePoint = 0
local g_MaxActivePoint =500
function HuoyuezhiExchange_PreLoad( )

	this:RegisterEvent( "UI_COMMAND" )
	--this:RegisterEvent( "UPDATE_YUANBAO" );
	
end

function HuoyuezhiExchange_OnLoad( )
	
end

function HuoyuezhiExchange_OnEvent( event )
	if event == "UI_COMMAND" then
		HuoyuezhiExchange_OnUICommand( arg0 )
	end
end

function HuoyuezhiExchange_OnUICommand( arg0 )
	
	local op = tonumber( arg0 )
	
	if op == 889102 then
		if( this : IsVisible( ) ) then
			this : Hide( )
			return
		end
		
		this : Show( )
		HuoyuezhiExchange_OnShown( )
		NpcServerId = Get_XParam_INT( 0 )
		FriendActivePoint = Get_XParam_INT( 1 )
		
		local npcClientId = DataPool : GetNPCIDByServerID( NpcServerId )
		if npcClientId ~= -1 then
			this:CareObject( npcClientId, 1, "HuoyuezhiExchange" )
		end
	end
	
end

function HuoyuezhiExchange_OnShown( )
	-- 设置焦点
	HuoyuezhiExchange_Moral_Value : SetProperty( "DefaultEditBox", "True" )
	HuoyuezhiExchange_Moral_Value : SetProperty( "Text", "1" )
	-- 设置选中
	HuoyuezhiExchange_Moral_Value : SetSelected( 0, -1 )
	
	local humanActivePoint = Player : GetData( "ACTIVEPOINT" )
	HuoyuezhiExchange_Text1 : SetText( "#{HYZ_XML_11}"..humanActivePoint )
	g_ShowComfirm = 1
end



function HuoyuezhiExchange_Hide( )

	-- 关闭窗口
	this : Hide( )

end

function HuoyuezhiExchange_OnHidden( )
		
	-- 取消NPC关心
	local npcClientId = DataPool : GetNPCIDByServerID( NpcServerId )
	if npcClientId ~= -1 then
		this : CareObject( npcClientId, 0, "HuoyuezhiExchange")
	end
	
end

function HuoyuezhiExchange_OK_Clicked( )
	
	-- 如果没有检测过电话和二级密码返回0
	if CheckPhoneMibaoAndMinorPassword() == 0 then
		--PushDebugMessage( "Erji mima" )
		return
	end
	
	-- 是否过了安全时间....
	if( tonumber(DataPool:GetLeftProtectTime( ) ) > 0 ) then
		PushDebugMessage( "#{OR_PILFER_LOCK_FLAG}" )
		return
	end
	
	-- 输入合法相关检查
	local inputActivePointTxt = HuoyuezhiExchange_Moral_Value : GetProperty( "Text" )
	local inputActivePoint = tonumber( inputActivePointTxt )
	
	-- 玩家输入0，直接关闭
	if inputActivePoint == 0 then
		HuoyuezhiExchange_Hide( )
		return
	end
		
	-- 输入活跃值超过本身活跃值数量
	local humanActivePoint = Player : GetData( "ACTIVEPOINT" )
	if humanActivePoint < inputActivePoint then
		PushDebugMessage( "#{HYZ_091210_6}" )
		return
	end
	
	
    if inputActivePoint + FriendActivePoint <= g_MaxActivePoint then
    	g_ShowComfirm = 0
    end
	
	if ( g_ShowComfirm == 1 ) then
		GameProduceLogin : ShowMessageBox( "#{HYZ_XML_13}"..g_MaxActivePoint-FriendActivePoint.."#{HYZ_XML_14}", "Close", "-1" )
		g_ShowComfirm = 0
		return
	end
	
	--Player : ActivePointExchange( inputActivePoint )
	Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "ActivePointExchange" )
			Set_XSCRIPT_ScriptID( 889102 )
			Set_XSCRIPT_Parameter( 0, inputActivePoint )
			Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
	-- 都执行完了关闭窗口（操作成功由服务器端提示）
	HuoyuezhiExchange_Hide( )
end

function HuoyuezhiExchange_Count_Change( )
	
	local inputActivePointTxt = HuoyuezhiExchange_Moral_Value : GetProperty( "Text" )
	
	if inputActivePointTxt ~= "" and tonumber( inputActivePointTxt ) > 0 then
		HuoyuezhiExchange_OK : Enable( )
	else
		HuoyuezhiExchange_OK : Disable( )
	end
	
	g_ShowComfirm = 1
end

function HuoyuezhiExchange_Cancel_Clicked()
	HuoyuezhiExchange_Hide( )
	HuoyuezhiExchange_Clear( )
end

function HuoyuezhiExchange_Clear( )
	HuoyuezhiExchange_Moral_Value : SetProperty( "Text", "1" )
	HuoyuezhiExchange_OK : Disable( )
end