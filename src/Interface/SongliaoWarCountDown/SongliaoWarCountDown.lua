local SongliaoWarCountDown_Battle_YuBei_Begin = 30  
function SongliaoWarCountDown_PreLoad()
	this:RegisterEvent("SONGLIAOSINGLE_MINI");
	this:RegisterEvent("SCENE_TRANSED");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	this:RegisterEvent("REFRESH_SONGLIAOWAR_SINGLE_SCORE");
end

function SongliaoWarCountDown_OnLoad()
end

function SongliaoWarCountDown_OnEvent(event)
	if (event=="SCENE_TRANSED") then
		if(548~=GetSceneID()) then
			SongliaoWarCountDown_Hide()
		end
	elseif (event=="PLAYER_LEAVE_WORLD") then
		if( this:IsVisible() ) then
			SongliaoWarCountDown_Hide()
		end
	elseif (event=="REFRESH_SONGLIAOWAR_SINGLE_SCORE") then
		local nTick = CSongliaoWarData:GetTick()
		if   nTick == SongliaoWarCountDown_Battle_YuBei_Begin-3 then
			this:Show()
			SongliaoWarCountDown_Animate:Play(true)
		elseif nTick >= SongliaoWarCountDown_Battle_YuBei_Begin + 1 then
			this:Hide()
		end
	end
end

function SongliaoWarCountDown_Open()

	this:Show()

end

function SongliaoWarCountDown_Hide()
	

	this:Hide()
end
