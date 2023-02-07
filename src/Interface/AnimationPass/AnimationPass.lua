
local g_server_movie_id = 0;

function AnimationPass_PreLoad()
	this:RegisterEvent("MOVIE_LISTENER_EVENT",true);
	this:RegisterEvent("MOVIE_OPERATE",true);
end

function AnimationPass_OnLoad()
	
end

function AnimationPass_Operate( op, name, callbackid )
	if op == "Play" then
		g_server_movie_id = tonumber(callbackid)
		if not g_server_movie_id or type(g_server_movie_id) ~= "number" then
			g_server_movie_id = -1
		end
		ClientMovie:Play( name )
	elseif op == "Stop" then
		ClientMovie:Stop()
	end
end

function AnimationPass_OnEvent( event )
	if event == "MOVIE_OPERATE" then
		AnimationPass_Operate( arg0, arg1, arg2 )
		return
	elseif event == "MOVIE_LISTENER_EVENT" then
		local fn = _G["AnimationPass_cb_"..arg0]
		if fn then
			fn( arg0, arg1 )
		end
		return
	end
end

function AnimationPass_OnClick()
	this:Hide()
	if ClientMovie:IsPlaying() then
		PushEvent("MOVIE_OPERATE","Stop")
	end
end

function AnimationPass_cb_stop( ev, name )
	this:Hide()
	--回调服务器脚本
	if g_server_movie_id >= 0 then
		Clear_XSCRIPT();				
			Set_XSCRIPT_Function_Name("OnMovieEnd");
			Set_XSCRIPT_ScriptID(410001);		
			Set_XSCRIPT_Parameter(0,g_server_movie_id)
			Set_XSCRIPT_ParamCount(1);
		Send_XSCRIPT();
	end
	g_server_movie_id = -1
end

function AnimationPass_cb_start( ev, name )
	this:Show()
end

function AnimationPass_cb_playing( ev, name )

end

function AnimationPass_cb_pause( ev, name )

end
