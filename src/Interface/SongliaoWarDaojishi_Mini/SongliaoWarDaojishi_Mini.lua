
function SongliaoWarDaojishi_Mini_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("SCENE_TRANSED");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
end

function SongliaoWarDaojishi_Mini_OnLoad()
end

function SongliaoWarDaojishi_Mini_OnEvent(event)
	if (event=="SCENE_TRANSED") then
		this:Hide()
	elseif (event=="PLAYER_LEAVE_WORLD") then
		if( this:IsVisible() ) then
			this:Hide()
		end
	elseif (event=="UI_COMMAND" and tonumber(arg0) == 20211231) then
		
		if tonumber(arg1) == 0 then
			this:Show()
		else
			this:Hide()
		end
	end
end

function SongliaoWarDaojishi_Mini_Open()
	this:Hide()
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name( "ReWarTime" );
		Set_XSCRIPT_ScriptID(502019);
        Set_XSCRIPT_ParamCount(1);
    Send_XSCRIPT(); 
end

