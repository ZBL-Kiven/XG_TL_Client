local g_SongliaoWarDaojishi_Frame_UnifiedXPosition;
local g_SongliaoWarDaojishi_Frame_UnifiedYPosition;

function SongliaoWarDaojishi_PreLoad()
	this:RegisterEvent("SCENE_TRANSED");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("SONGLIAOSINGLE_XXS_MINI");
	this:RegisterEvent("ADJEST_UI_POS");
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED");
end

function SongliaoWarDaojishi_OnLoad()
	g_SongliaoWarDaojishi_Frame_UnifiedXPosition	= SongliaoWarDaojishi : GetProperty("UnifiedXPosition");
	g_SongliaoWarDaojishi_Frame_UnifiedYPosition	= SongliaoWarDaojishi : GetProperty("UnifiedYPosition");
end

function SongliaoWarDaojishi_On_ResetPos()

	
	SongliaoWarDaojishi : SetProperty("UnifiedXPosition", g_SongliaoWarDaojishi_Frame_UnifiedXPosition);
	SongliaoWarDaojishi : SetProperty("UnifiedYPosition", g_SongliaoWarDaojishi_Frame_UnifiedYPosition);

end

function SongliaoWarDaojishi_OnEvent(event)
	if (event=="SCENE_TRANSED") then
		-- if(301==GetSceneID()) then
			-- return
		-- end
		-- if arg0=="songliao_xiuxi" then
			-- SongliaoWarDaojishi_TimeTitle:SetToolTip("#{XSLDZ_180424_16}")
			-- SongliaoWarDaojishi_Time:SetProperty("Timer", tonumber(0));
			-- SongliaoWarDaojishi_Time2:SetProperty("Timer", tonumber(0));
			-- SongliaoWarDaojishi_Num:SetText("")
			-- SongliaoWarDaojishi_Text:SetText("")
			-- this:Show()
		-- else
			-- this:Hide()
		-- end
	elseif (event=="PLAYER_LEAVE_WORLD") then
		if( this:IsVisible() ) then
			this:Hide()
		end
	elseif (event=="SONGLIAOSINGLE_XXS_MINI") then
		if arg0=="1" then
			SongliaoWarDaojishi_TimeTitle:SetToolTip("#{XSLDZ_180424_16}")
			SongliaoWarDaojishi_Time:SetProperty("Timer", tonumber(0));
			SongliaoWarDaojishi_Time2:SetProperty("Timer", tonumber(0));
			SongliaoWarDaojishi_Num:SetText("")
			SongliaoWarDaojishi_Text:SetText("")
			this:Show()
		else
			this:Hide()
		end
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 20180613 ) then
			if 550 == GetSceneID() then
				SongliaoWarDaojishi_Text:SetText("#{XSLDZ_180521_292}")
			end
			local time = Get_XParam_INT(0)
			local memcount = Get_XParam_INT(1)
			SongliaoWarDaojishi_Time:SetProperty("Timer", tonumber(time));
			SongliaoWarDaojishi_Num:SetText(memcount)
			this:Show()
			local sec = Get_XParam_INT(2)
			SongliaoWarDaojishi_Time2:SetProperty("Timer", tonumber(sec));
	elseif (event == "ADJEST_UI_POS" ) then
		
		SongliaoWarDaojishi_On_ResetPos();
	elseif (event == "VIEW_RESOLUTION_CHANGED" ) then
		
		SongliaoWarDaojishi_On_ResetPos();
	end
end

function SongliaoWarDaojishi_Open()

end

function SongliaoWarDaojishi_Close()

end

function SongliaoWarDaojishi_OpenMini()

	this:Hide()
	PushEvent("UI_COMMAND",20211231,0)
end