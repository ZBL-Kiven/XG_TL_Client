local INVALID_GUID64 = -1
local Song = "set:SongLiao02 image:HJ_Guangbo_song"
local Liao = "set:SongLiao02 image:HJ_Guangbo_Liao"
local g_SongliaoWarReport_decade = {}
function SongliaoWarReport_PreLoad()
	this:RegisterEvent("SONGLIAOSINGLE_MINI");
	this:RegisterEvent("SCENE_TRANSED");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	this:RegisterEvent("RESET_ALLUI")
end

function SongliaoWarReport_OnLoad()
	for i = 0,9 do 
		local image = "set:SongLiao01 image:SL_Kill_"..i
		table.insert(g_SongliaoWarReport_decade,i,image)
	end
end

function SongliaoWarReport_OnEvent(event)
	if (event=="SCENE_TRANSED") then
		
		if(548~=GetSceneID()) then
			SongliaoWarReport_Hide()
		end
		if arg0=="songliao_dazhan" then
			SetTimer("SongliaoWarReport", "SongliaoWarReport_Open()", 4000)
		else
			SongliaoWarReport_Hide()
		end
	elseif (event=="PLAYER_LEAVE_WORLD") then
		if( this:IsVisible() ) then
			SongliaoWarReport_Hide()
		end
	elseif (event=="RESET_ALLUI") then
		SongliaoWarReport_Hide()
	end
end

function SongliaoWarReport_Open()
	
	local killerguid,killguid,succkillnum,killertrait= DataPool:Lua_GetSongLiaoGuidFromlist()
	if killerguid == INVALID_GUID64 or killguid == INVALID_GUID64 or killerguid == "" then
		this:Hide()
		return 
	end

	local killerret,killername,killercamp,killerscore,killernum,killerguid = CSongliaoWarData:GetSongliaoKillInfoByGuid(killerguid)
	local killret,name,camp,score,killnum,guid = CSongliaoWarData:GetSongliaoKillInfoByGuid(killguid)
	if killerret == 0 then
		this:Hide()
		return
	end

	if killercamp == 156 then
		SongliaoWarReport_School:SetProperty("Image",Song)
	elseif killercamp ==  157 then
		SongliaoWarReport_School:SetProperty("Image",Liao)
	end
	local minu = succkillnum
	local hundred = math.mod(minu ,1000)
	hundred = math.floor(hundred / 100)
	local decade = math.mod(minu , 100)
	decade = math.floor(decade / 10)
	local unit = math.mod(minu , 10)

	SongliaoWarReport_Image1:SetProperty("Image",g_SongliaoWarReport_decade[hundred])
	SongliaoWarReport_Image2:SetProperty("Image",g_SongliaoWarReport_decade[decade])
	SongliaoWarReport_Image3:SetProperty("Image",g_SongliaoWarReport_decade[unit])
	SongliaoWarReport_Text:SetText(killername)

	local szPortrait = DataPool:GetPortraitByID(killertrait)
	SongliaoWarReportFrame_HeadIcon:SetProperty("Image", GetIconFullName(tostring(szPortrait)))

	this:Show()

end

function SongliaoWarReport_Hide()
	
	KillTimer("SongliaoWarReport_Open()")
	--Lua_CloseHelpTips("RongYu_Shop")	
	
	this:Hide()
end
function SongliaoWarReport_OnHide()
	SongliaoWarReport_Hide()
end