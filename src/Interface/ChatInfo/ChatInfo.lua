function ChatInfo_PreLoad()
	this:RegisterEvent("CHAT_SHOWUSERINFO");
end

function ChatInfo_OnLoad()
end

--===============================================
-- OnEvent()
--===============================================
function ChatInfo_OnEvent( event )
	if(event == "CHAT_SHOWUSERINFO") then
		ChatInfo_Show();
	end
end


--===============================================
-- UpdateFrame()
-- 第几个频道的第几个人
--===============================================
function ChatInfo_Update()
	--AxTrace( 0,0,"char PORTRAIT" );
	local strFaceImage = DataPool:GetFriend( "chat", "PORTRAIT" );
	ChatInfo_PlayerHead:SetProperty("Image", tostring(strFaceImage));
	--AxTrace( 0,0,"char ID" );
	ChatInfo_ID:SetText( "ID:"..tostring( DataPool:GetFriend( "chat", "ID_TEXT" ) ) );
	--AxTrace( 0,0,"char NAME" );
	ChatInfo_Name:SetText( "姓名:"..DataPool:GetFriend( "chat", "NAME"  ) );
	--AxTrace( 0,0,"char LEVEL" );
	ChatInfo_Level:SetText( "级别:"..tostring( DataPool:GetFriend( "chat", "LEVEL" ) ) );
	--AxTrace( 0,0,"char MENPAI_TEXT" );
	ChatInfo_MenPai:SetText( "门派:"..DataPool:GetFriend( "chat", "MENPAI_TEXT" ) );
	--AxTrace( 0,0,"char GUID_NAME" );
	ChatInfo_Confraternity:SetText( "帮会名称:"..DataPool:GetFriend( "chat", "GUID_NAME" ) );
	ChatInfo_GuildLeague:SetText( "#{TM_20080311_30}"..DataPool:GetFriend( "chat", "GUILD_LEAGUE_NAME" ) );
	--AxTrace( 0,0,"char MOOD" );
	ChatInfo_Explain:SetText( "心情:"..DataPool:GetFriend( "chat", "MOOD" ) );
	--AxTrace( 0,0,"char TITLE" );
	ChatInfo_Agname:SetText( "称号:"..DataPool:GetFriend( "chat", "TITLE" ) );
end

function ChatInfo_Show()
	
	ChatInfo_Update();
	this:Show();
end

function ChatInfo_OnHide()
	this:Hide();
end

function ChatInfo_OnHelp()
end

function ChatInfo_AddFriend()
	local szName = DataPool:GetFriend( "chat", "NAME"  );
	if(nil ~= szName and "" ~= szName) then
		DataPool:AddFriend( Friend:GetCurrentTeam(), szName);
	end
end

function ChatInfo_SetPrivateName()
	local szName = DataPool:GetFriend( "chat", "NAME"  );
	if(nil ~= szName and "" ~= szName) then
		Talk:ContexMenuTalk(szName);
	end
end

function ChatInfo_ShengQingTeam()
	local szName = DataPool:GetFriend( "chat", "NAME"  );
	if(nil ~= szName and "" ~= szName) then
		Target:SendTeamApply(szName);
	end
end
function GetXiuLian(nType)
    local DataPoolTable = {301,302,303,304,305,471,472,473,474,475,476}
    if nType == "XiuLianLevel" then
	    for i = 1,table.getn(DataPoolTable) do
		    local nData = DataPool:GetPlayerMission_DataRound(DataPoolTable[i])
		    if nData > 0 then			    
			    return 1
			end
		end
	    return 0
	end
    if nType == "XIULIAN_STR" then
		local nData = DataPool:GetPlayerMission_DataRound(301)
	    return nData*3
	end
    if nType == "XIULIAN_SPR" then
		local nData = DataPool:GetPlayerMission_DataRound(302)
	    return nData*3
	end
    if nType == "XIULIAN_CON" then
		local nData = DataPool:GetPlayerMission_DataRound(303)
	    return nData*5
	end
    if nType == "XIULIAN_INT" then
		local nData = DataPool:GetPlayerMission_DataRound(304)
	    return nData*1
	end
    if nType == "XIULIAN_DEX" then
		local nData = DataPool:GetPlayerMission_DataRound(305)
	    return nData*4
	end
    if nType == "XIULIAN_ATTP" then
		local nData = DataPool:GetPlayerMission_DataRound(471)
	    return nData*57
	end
    if nType == "XIULIAN_DEFP" then
		local nData = DataPool:GetPlayerMission_DataRound(472)
	    return nData*57
	end
    if nType == "XIULIAN_ATTM" then
		local nData = DataPool:GetPlayerMission_DataRound(473)
	    return nData*45
	end
    if nType == "XIULIAN_DEFM" then
		local nData = DataPool:GetPlayerMission_DataRound(474)
	    return nData*45
	end
    if nType == "XIULIAN_HIT" then
		local nData = DataPool:GetPlayerMission_DataRound(475)
	    return nData*50
	end
    if nType == "XIULIAN_MISS" then
		local nData = DataPool:GetPlayerMission_DataRound(476)
	    return nData*35
	end
end

function ChatInfo_YaoQingTeam()
	local szName = DataPool:GetFriend( "chat", "NAME"  );
	if(nil ~= szName and "" ~= szName) then
		Target:SendTeamRequest(szName);
	end
end