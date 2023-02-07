--===============================================
-- OnLoad()
--===============================================
function PhoenixPlainWarMulti_PreLoad()
	this:RegisterEvent("REFRESH_PHOENIXPLAINWAR_SCORE");
	this:RegisterEvent("SHOW_PHOENIXPLAINWAR_SCORE_M");
	this:RegisterEvent("SCENE_TRANSED");
	this:RegisterEvent("UI_COMMAND");
end

function PhoenixPlainWarMulti_OnLoad()
	--PhoenixPlainWarMulti_List:AddColumn( "#{FHZD_XML_03}", 0, 0.06 );
	--PhoenixPlainWarMulti_List:AddColumn( "#{FHZD_XML_04}", 1, 0.44 );
	--PhoenixPlainWarMulti_List:AddColumn( "#{FHZD_XML_32}", 2, 0.14 );
	--PhoenixPlainWarMulti_List:AddColumn( "#{FHZD_XML_05}", 3, 0.10 );
	--PhoenixPlainWarMulti_List:AddColumn( "#{FHZD_XML_06}", 4, 0.10 );
	--PhoenixPlainWarMulti_List:AddColumn( "#{FHZD_XML_07}", 5, 0.10 );
	--PhoenixPlainWarMulti_List:AddColumn( "#{FHZD_XML_28}", 6, 0.06 );

	PhoenixPlainWarMulti_List:SetProperty( "ColumnsSizable", "False" );
	PhoenixPlainWarMulti_List:SetProperty( "ColumnsAdjust", "True" );
	PhoenixPlainWarMulti_List:SetProperty( "ColumnsMovable", "False" );

end

function PhoenixPlainWarMulti_OnHiden()
    City:ClosePhoenixPlainWarScoreMultiTable();
end


--===============================================
-- OnEvent()
--===============================================
function PhoenixPlainWarMulti_OnEvent(event)
	--PushDebugMessage("PhoenixPlainWarMulti_OnEvent " .. event.. " " .. arg0 );
	if( event == "SHOW_PHOENIXPLAINWAR_SCORE_M" ) then
		if arg0 == "0" and this:IsVisible() then
			this:Hide();
		elseif arg0 == "0" and this:IsVisible() == false then
			--do nothing
		else
			this:Show();
			--PhoenixPlainWarMulti_Button:Show();
			--PhoenixPlainWarMulti_Button:Enable();
			PhoenixPlainWarMulti_GetData();
		end
	elseif ( event == "REFRESH_PHOENIXPLAINWAR_SCORE" and this:IsVisible() ) then
		PhoenixPlainWarMulti_GetData();
	elseif ( event == "SCENE_TRANSED" ) then
		if this:IsVisible() then
			this:Hide();
		end
	elseif ( event == "UI_COMMAND" ) then
		if tonumber(arg0) == 403004 then
			Sound:PlaySoundEffect( Get_XParam_INT(0), false );
		end
	end
end

function PhoenixPlainWarMulti_Close()
	City:ClosePhoenixPlainWarScoreMultiTable();
end

function PhoenixPlainWarMulti_TrimeName(sName, iLen)
	if sName == nil then
		return ""
	end
	if string.len(sName) > iLen * 2 then
		sName = string.sub(sName,1,(iLen-1)*2)
		sName = sName.."…"
	end
	return sName
end

function PhoenixPlainWarMulti_GetData()
	PhoenixPlainWarMulti_List:RemoveAllItem();
	for i = 0, 9 do
		local ret, leagueId, guildId1, guildId2, guildId3, crystalHoldScore, flagCaptureScore, leagueName, guildName1, guildName2, guildName3 = City:GetPhoenixPlainWarScore(i);
		local leagueNamePrint = ""
		local guildNamePrint = ""
		local blink = ""
		local myGuildName = ""
		local myLeagueName = ""

		myGuildName = Guild:GetMyGuildInfo("Name")
		myLeagueName = Guild:GetMyGuildInfo("LeagueName")
		if leagueName ~= nil and leagueName ~= "" then
			if leagueName == myLeagueName then
				blink = "#b"
			end
		end
		if guildName1 ~= nil and guildName1 ~= "" then
			if guildName1 == myGuildName then
				blink = "#b"
			end
		end
		if guildName2 ~= nil and guildName2 ~= "" then
			if guildName2 == myGuildName then
				blink = "#b"
			end
		end
		if guildName3 ~= nil and guildName3 ~= "" then
			if guildName3 == myGuildName then
				blink = "#b"
			end
		end
		
		--PushDebugMessage(ret.." "..leagueId.." "..guildId1.." "..guildId2.." "..guildId3.." "..crystalHoldScore.." "..flagCaptureScore.." "..leagueName.." "..guildName1.." "..guildName2.." "..guildName3 );
		if ret == 1 then
			--PushDebugMessage("1");
			--local totlaScore = crystalHoldScore + flagCaptureScore;
			--totlaScore = totlaScore.. "/"..maxScore
			--如果是盟，那么leagueId应该有效，如果是独立帮，那么guildId1应该有效
			--if leagueId == -1 or leagueId == nil then
			--	if guildId1 == -1 or guildId1 == nil then
			--		--PushDebugMessage("3");
			--		leagueName = ""
			--		crystalHoldScore = 0
			--		flagCaptureScore = 0
			--	else
					--leagueName = PhoenixPlainWarMulti_TrimeName(guildName1,18)
			--		leagueNamePrint = "#G"..leagueName
			--	end
			--end

			leagueNamePrint = blink.."#B"..leagueName
			--if 1 == 1 then
				--local hasGuild = 0
				--PushDebugMessage("1guildName3="..guildName3);
				--guildName1 = PhoenixPlainWarMulti_TrimeName(guildName1,5)
				--guildName2 = PhoenixPlainWarMulti_TrimeName(guildName2,5)
				--guildName3 = PhoenixPlainWarMulti_TrimeName(guildName3,5)
				--leagueName = PhoenixPlainWarMulti_TrimeName(leagueName,5)
				--PushDebugMessage("2guildName3="..guildName3);
				--guildNamePrint = "#B"..leagueName
				if guildName1 ~= "" or guildName2 ~= "" or guildName3 ~= "" then
					--leagueName = leagueName.."："
					if guildName1 ~= "" then
						guildNamePrint = blink.."#G"..guildName1
					end
					if guildName2 ~= "" then
						guildNamePrint = guildNamePrint.."，"..blink.."#G"..guildName2
					end
					if guildName3 ~= "" then
						guildNamePrint = guildNamePrint.."，"..blink.."#G"..guildName3
					end
				end
			--end
			if crystalHoldScore + flagCaptureScore ~= 0 then
				PhoenixPlainWarMulti_SetInterface( i, guildNamePrint, leagueNamePrint, crystalHoldScore, flagCaptureScore, crystalHoldScore + flagCaptureScore )
			end
		else
			--PushDebugMessage("2");
			--PhoenixPlainWarMulti_SetInterface(i, "", "", "", "")
		end
	end
end

function PhoenixPlainWarMulti_SetInterface(index, guildName, leagueName, crystalHoldScore, flagCaptureScore, totlaScore)
	--PushDebugMessage( index.." "..leagueName .." "..guildName .." ".. crystalHoldScore .." ".. flagCaptureScore .." ".. totlaScore);
	local maxScore = 10000;
	local scoreClolor, jiaoZiAddon
	if index == 0 then
		jiaoZiAddon = "#{_EXCHG500000}"
	elseif index == 1 then
		jiaoZiAddon = "#{_EXCHG450000}"
	elseif index == 2 then
		jiaoZiAddon = "#{_EXCHG400000}"
	elseif index == 3 then
		jiaoZiAddon = "#{_EXCHG350000}"
	elseif index == 4 then
		jiaoZiAddon = "#{_EXCHG300000}"
	elseif index == 5 then
		jiaoZiAddon = "#{_EXCHG250000}"
	elseif index == 6 then
		jiaoZiAddon = "#{_EXCHG200000}"
	elseif index == 7 then
		jiaoZiAddon = "#{_EXCHG160000}"
	elseif index == 8 then
		jiaoZiAddon = "#{_EXCHG120000}"
	elseif index == 9 then
		jiaoZiAddon = "#{_EXCHG100000}"
	else
		jiaoZiAddon = "#{_EXCHG30000}"
	end

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

	PhoenixPlainWarMulti_List:AddNewItem( "#Y"..index+1, 0, index );
	PhoenixPlainWarMulti_List:AddNewItem( guildName, 1, index );
	PhoenixPlainWarMulti_List:AddNewItem( leagueName, 2, index );
	PhoenixPlainWarMulti_List:AddNewItem( "#G"..crystalHoldScore, 3, index );
	PhoenixPlainWarMulti_List:AddNewItem( "#G"..flagCaptureScore, 4, index );
	PhoenixPlainWarMulti_List:AddNewItem( scoreClolor..totlaScore.. "#W/"..maxScore, 5, index );
	PhoenixPlainWarMulti_List:AddNewItem( jiaoZiAddon, 6, index );
end

