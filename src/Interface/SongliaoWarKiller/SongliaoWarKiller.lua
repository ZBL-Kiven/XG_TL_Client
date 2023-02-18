
local SongliaoWarKiller_LastScore = 0


local g_SongliaoWarKiller_decade = {}
function SongliaoWarKiller_PreLoad()
	this:RegisterEvent("SONGLIAOSINGLE_MINI");
	this:RegisterEvent("SCENE_TRANSED");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	this:RegisterEvent("REFRESH_SONGLIAOWAR_SCORE_FRAME");
end

function SongliaoWarKiller_OnLoad()
	for i = 0,9 do 
		local image = "set:SongLiao01 image:SL_Kill_"..i
		table.insert(g_SongliaoWarKiller_decade,i,image)
	end
end

function SongliaoWarKiller_OnEvent(event)

	if (event=="SCENE_TRANSED") then
		if(548~=GetSceneID()) then
			SongliaoWarKiller_Hide()
		else
	
		end
	elseif (event=="PLAYER_LEAVE_WORLD") then
		if( this:IsVisible() ) then
			SongliaoWarKiller_Hide()
		end
	elseif (event=="REFRESH_SONGLIAOWAR_SCORE_FRAME") then
		SongliaoWarKiller_Open()
	end
end

function SongliaoWarKiller_Open()
	local myRet, myName, myCamp, myScore, mykillNum, myGUID,mySuccKill,LastScore = CSongliaoWarData:GetMyScore()

	if LastScore ~= myScore then
		
		local minu = myScore - LastScore
		local hundred = math.mod(minu ,1000)
		hundred = math.floor(hundred / 100)

		local decade = math.mod(minu , 100)
		decade = math.floor(decade / 10)

		local unit = math.mod(minu , 10)

		

		SongliaoWarKiller_Image2:SetProperty("Image",g_SongliaoWarKiller_decade[hundred])
		SongliaoWarKiller_Image3:SetProperty("Image",g_SongliaoWarKiller_decade[decade])
		SongliaoWarKiller_Image4:SetProperty("Image",g_SongliaoWarKiller_decade[unit])

		CSongliaoWarData:SetMyScore(tonumber(myScore))
		this:Show()	
		SetTimer("SongliaoWarKiller", "SongliaoWarKiller_Hide()", 3000)
	end

end

function SongliaoWarKiller_Hide()
	KillTimer("SongliaoWarKiller_Hide()")
	this:Hide()
end

