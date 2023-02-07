--===============================================
-- OnLoad()
--===============================================
function PhoenixPlainWarSingle_PreLoad()
	this:RegisterEvent("REFRESH_PHOENIXPLAINWAR_SCORE");
	this:RegisterEvent("SHOW_PHOENIXPLAINWAR_SCORE_S");
	this:RegisterEvent("SHOW_PHOENIXPLAINWAR_SCORE_M");
	this:RegisterEvent("SCENE_TRANSED");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
end

function PhoenixPlainWarSingle_OnLoad()
	--PhoenixPlainWarSingle_Close:Hide();
end


--===============================================
-- OnEvent()
--===============================================
function PhoenixPlainWarSingle_OnEvent(event)
	--PushDebugMessage("PhoenixPlainWarSingle_OnEvent " .. event.. " " .. arg0 );
	if( event == "SHOW_PHOENIXPLAINWAR_SCORE_M" ) then
		if arg0 == "0" then
			PhoenixPlainWarSingleOpen:Show();
	       PhoenixPlainWarSingleClose:Hide();
	    end	
	elseif event == "PLAYER_LEAVE_WORLD"  then
		if( this:IsVisible() ) then
			this:Hide()
		end
	elseif( event == "SHOW_PHOENIXPLAINWAR_SCORE_S" ) then
		if arg0 == "0" and this:IsVisible() then
			this:Hide();
		elseif arg0 == "1" and this:IsVisible()==false then 
			this:Show();
			City:ClearPhoenixPlainWarScore();
			--PhoenixPlainWarSingle_Button:Show();
			--PhoenixPlainWarSingle_Button:Enable();
		elseif arg0 == "2" and this:IsVisible() then 
			this:Hide();
			this:Show()
		end
	elseif ( event == "REFRESH_PHOENIXPLAINWAR_SCORE" and this:IsVisible() ) then
		local ret, leagueId, guildId1, guildId2, guildId3, crystalHoldScore, flagCaptureScore, leagueName, guildName1, guildName2, guildIName3 = City:GetPhoenixPlainWarScore(0);
		--PushDebugMessage("score refresh, ret "..ret.." leagueId "..leagueId.." guild "..guildId.." crystal "..crystalHoldScore.." flag "..flagCaptureScore );
		if ret == 1 then
			local totlaScore = crystalHoldScore + flagCaptureScore;
			if leagueName == nil or leagueName == "" then
				if guildName1 == nil or guildName1 == "" then
					leagueName = ""
				else
					leagueName = guildName1--PhoenixPlainWarMulti_TrimeName(guildName1,5)
				end
			else
				leagueName = leagueName--PhoenixPlainWarMulti_TrimeName(leagueName,5)
			end
			--PushDebugMessage( "guild name " ..leagueName )
			PhoenixPlainWarSingle_Position:SetText("#Y1");
			PhoenixPlainWarSingle_GuildText:SetText("#B"..leagueName);

			local scoreClolor
			if totlaScore >= 0 and totlaScore <= 2000 then
				scoreClolor = "#G"
			elseif totlaScore >= 2001 and totlaScore <= 4000 then
				scoreClolor = "#Y"
			elseif totlaScore >= 4001 and totlaScore <= 8000 then
				scoreClolor = "#cff9900"
			elseif totlaScore >= 8001 and totlaScore <= 10000 then
				scoreClolor = "#cFF0000"
			else
				scoreClolor = ""
			end

			PhoenixPlainWarSingle_ScoreText:SetText( scoreClolor..totlaScore);
		end
	elseif ( event == "SCENE_TRANSED" ) then
		City:ClearPhoenixPlainWarScore();
		if ( arg0 == "PhoenixPlain" ) then
			this:Show();	
			--PhoenixPlainWarSingle_Button:Show();
			PhoenixPlainWarSingle_GuildText:SetText("");
			PhoenixPlainWarSingle_Position:SetText("");
			PhoenixPlainWarSingle_ScoreText:SetText("");
			--PhoenixPlainWarSingle_Button:Enable();
		else
			this:Hide();
		end
	end
end

function PhoenixPlainWarSingle_Close()
	City:ClosePhoenixPlainWarScoreMultiTable();
	PhoenixPlainWarSingleOpen:Show();
	PhoenixPlainWarSingleClose:Hide();
end

function PhoenixPlainWarSingle_Open()
	City:OpenPhoenixPlainWarScoreMultiTable();
	PhoenixPlainWarSingleOpen:Hide();
	PhoenixPlainWarSingleClose:Show();
end
