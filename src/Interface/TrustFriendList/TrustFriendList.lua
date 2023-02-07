
local g_TrustFriendList_Frame_UnifiedPosition;

function TrustFriendList_PreLoad()

	this:RegisterEvent("UPDATE_TRUST_FRIEND");
	this:RegisterEvent("TOGGLE_TRUST_FRIEND_LIST");
	
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	
end

function TrustFriendList_OnLoad()

g_TrustFriendList_Frame_UnifiedPosition=TrustFriendList_Frame:GetProperty("UnifiedPosition");

	
end


function TrustFriendList_OnEvent( event )

	if ( event == "UPDATE_TRUST_FRIEND" ) then
		TrustFriendList_Update()
	elseif ( event == "TOGGLE_TRUST_FRIEND_LIST" ) then
		TrustFriendList_Toggle();
		
	elseif (event == "ADJEST_UI_POS" ) then
		TrustFriendList_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		TrustFriendList_Frame_On_ResetPos()
	end
end


function TrustFriendList_Update()
	
	TrustFriendList_List : ClearListBox();
		
	local trustFriendNumber = DataPool : GetTrustFriendNumber( );
	local index = 0;
	while ( index < trustFriendNumber ) do
		local name = DataPool : GetTrustFriend( index, "NAME" )
		local leftTime = DataPool : GetTrustFriend( index, "LEFT_TIME" )
		local isEachOther = DataPool : GetTrustFriend( index, "ISEACHOTHER" )
		
		local icon = ""
		if ( leftTime > 0 ) then						-- 时间还未到
			icon="#-21"
		elseif( isEachOther ~= 0 ) then			-- 是互为信任伙伴
			icon="#-19"
		else																-- 本方时间到，但是是单向
			icon="#-20"				
		end
		
		local str = string.format( "%s %s", icon, name)
		TrustFriendList_List : AddItem( str, index, "FFFFFFFF", 4 );
		
		index = index + 1;
	end
	
	--不需要自动选中第一个50733
	--if ( trustFriendNumber > 0 ) then
	--	TrustFriendList_List : SetItemSelect( 0 )
	--end
	
end

function TrustFriendList_Toggle()
	
	if( this : IsVisible( ) ) then
		this : Hide();
	else
		this : Show();
		TrustFriendList_Update();
	end
end

function TrustFriendList_Add()

	local guid = TrustFriendList_FriendID : GetText( );
	if ( guid == "" ) then
		PushDebugMessage("#{XRHB_09515_09}");		
	end
	DataPool : AddTrustFriend( guid );
	TrustFriendList_FriendID : SetText( "" )
end

function TrustFriendList_Del( )
	
	local selIndex = TrustFriendList_List : GetFirstSelectItem();
	if ( selIndex == -1 ) then
		return
	end
	
	DataPool : OpenDelTrustFriendCheckBox( selIndex );
--	DataPool : DelTrustFriend( selIndex );

end

function TrustFriendList_Close( )

	this : Hide();

end

function TrustFriendList_OpenMenu( )

	local selIndex = TrustFriendList_List : GetFirstSelectItem( );
	if ( selIndex == -1 ) then
		return
	end
			
	local name = DataPool : GetTrustFriend( selIndex, "NAME" );
	local guid = DataPool : GetTrustFriend( selIndex, "GUID" );
		
	ShowCommonMenu( "TrustFriend", name, guid );
	
end


function TrustFriendList_Frame_On_ResetPos()
  TrustFriendList_Frame:SetProperty("UnifiedPosition", g_TrustFriendList_Frame_UnifiedPosition);
end