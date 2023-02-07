
local NpcServerId = 0
local g_ShowComfirm = 0

function YuanbaoBangdingExchange_PreLoad( )

	this:RegisterEvent( "UI_COMMAND" )
	this:RegisterEvent( "UPDATE_YUANBAO" );
	
end

function YuanbaoBangdingExchange_OnLoad( )
	
end

function YuanbaoBangdingExchange_OnEvent( event )

	if event == "UI_COMMAND" then
		YuanbaoBangdingExchange_OnUICommand( arg0 )
	elseif event == "UPDATE_YUANBAO" then
		if( this : IsVisible( ) ) then
			local holdYuanBao = Player : GetData( "YUANBAO" )
			YuanbaoBangdingExchange_Text1 : SetText( "#{BDYB_XML_090714_05}"..tostring( holdYuanBao ) )
		end
	end

end

function YuanbaoBangdingExchange_OnUICommand( arg0 )
	
	local op = tonumber( arg0 )
	
	if op == 20090717 then
		if( this : IsVisible( ) ) then
			this : Hide( )
			return
		end
		
		this : Show( )
		
		NpcServerId = Get_XParam_INT( 0 )
		
		local npcClientId = DataPool : GetNPCIDByServerID( NpcServerId )
		if npcClientId ~= -1 then
			this:CareObject( npcClientId, 1, "YuanbaoBangdingExchange" )
		end
	end
	
end

function YuanbaoBangdingExchange_OnShown( )

	YuanbaoBangdingExchange_Clear( )
	
	-- 设置焦点
	YuanbaoBangdingExchange_Moral_Value : SetProperty( "DefaultEditBox", "True" )
	YuanbaoBangdingExchange_Moral_Value : SetProperty( "Text", "1" )
	-- 设置选中
	YuanbaoBangdingExchange_Moral_Value : SetSelected( 0, -1 )
	
	local holdYuanBao = Player : GetData( "YUANBAO" )
	YuanbaoBangdingExchange_Text1 : SetText( "#{BDYB_XML_090714_05}"..tostring( holdYuanBao ) )
	
	-- 打开的同时开启物品栏
	OpenWindow( "Packet" )
	
	g_ShowComfirm = 1
end

function YuanbaoBangdingExchange_Clear( )
	
	ShowConfirmBox = 0
	YuanbaoBangdingExchange_Moral_Value : SetProperty( "Text", "1" )
	
	YuanbaoBangdingExchange_OK : Disable( )
	
end

function YuanbaoBangdingExchange_Hide( )

	-- 关闭窗口
	this : Hide( )

end

function YuanbaoBangdingExchange_OnHidden( )
		
	-- 取消NPC关心
	local npcClientId = DataPool : GetNPCIDByServerID( NpcServerId )
	if npcClientId ~= -1 then
		this : CareObject( npcClientId, 0, "YuanbaoBangdingExchange")
	end
	
end

function YuanbaoBangdingExchange_OK_Clicked( )
	
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
	local toBindYuanBaoTxt = YuanbaoBangdingExchange_Moral_Value : GetProperty( "Text" )
	local toBindYuanBao = tonumber( toBindYuanBaoTxt )
	
	-- 玩家输入0，直接关闭
	if toBindYuanBao == 0 then
		YuanbaoBangdingExchange_Hide( )
		return
	end
		
	-- 输入元宝超过本身携带的元宝数量
	local holdYuanBao = Player : GetData( "YUANBAO" )
	if holdYuanBao < toBindYuanBao then
		PushDebugMessage( "#{BDYB_090714_07}" )
		return
	end
	
	-- 超过绑定元宝携带上限
	local holdBindYB = Player : GetData( "BIND_YUANBAO" )
	if DataPool : ScriptPlus( holdBindYB, toBindYuanBao ) > 999999 then
		PushDebugMessage( "#{BDYB_090720_05}" )
		return	
	end
	
	if ( toBindYuanBao > 2000 ) then
		PushDebugMessage( "#{BDYB_090714_08}".."2000".."#{BDYB_090714_09}" )
		return	
	end
	
	if ( g_ShowComfirm == 1 ) then
		GameProduceLogin : ShowMessageBox( "#{BDYB_090911_01}", "Close", "-1" )
		g_ShowComfirm = 0
		return
	end
	
	Player : YuanBaoToBind( toBindYuanBao )
	-- 都执行完了关闭窗口（操作成功由服务器端提示）
	YuanbaoBangdingExchange_Hide( )
end

function YuanbaoBangdingExchange_Count_Change( )
	
	local toBindYuanBao = YuanbaoBangdingExchange_Moral_Value : GetProperty( "Text" )
	
	if toBindYuanBao ~= "" and tonumber( toBindYuanBao ) > 0 then
		YuanbaoBangdingExchange_OK : Enable( )
	else
		YuanbaoBangdingExchange_OK : Disable( )
	end
	
	g_ShowComfirm = 1
end