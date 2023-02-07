--秀场通知提示
local g_ShowNoticeBall_timerID = 0
local g_ShowNoticeBall_timerTick = 0
local g_ShowNoticeBall_timerMaxTick = 300

function ShowNoticeBall_PreLoad()
	this:RegisterEvent("UPDATE_XIUCHANG_NOTIFY");
end

function ShowNoticeBall_OnLoad()

end

function ShowNoticeBall_OnEvent(event)
	--PushDebugMessage("ShowNoticeBall_OnEvent")
	if ( event == "UPDATE_XIUCHANG_NOTIFY" ) then

		ShowNoticeBall_NoticeShow()
		PushEvent("UPDATE_XIUCHANG_LIST")
	end
end

function ShowNoticeBall_NoticeShow()		
		--没有关注秀场直接返回
		if 1 > 0 then
			return
		end
		
		local _,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,n34 = SystemSetup:GameGetData()
		if n34 ~= 1 then
			return
		end
		
		this:Show()
		ShowNoticeBall_Button:Show()
		ShowNoticeBall_Button:Play(true)
		ShowNoticeBall_Button:SetProperty("Animate", "MsgBall_Show")
		if g_ShowNoticeBall_timerID == 0 then
			g_ShowNoticeBall_timerID = SetTimer("ShowNoticeBall","ShowNoticeBall_Tick()", 1000)
		else
			g_ShowNoticeBall_timerTick = 0
		end
		Lua_TDU_Log("ShowNoticeBall_NoticeShow,g_ShowNoticeBall_timerID="..g_ShowNoticeBall_timerID.." g_ShowNoticeBall_timerTick="..g_ShowNoticeBall_timerTick)
end

function ShowNoticeBall_ButtonClick()
		this:Hide()
		ShowNoticeBall_Button:Hide()
		ShowNoticeBall_Button:Play(false)
		if g_ShowNoticeBall_timerID ~= 0 then
			KillTimer(g_ShowNoticeBall_timerID)
			g_ShowNoticeBall_timerID = 0
			g_ShowNoticeBall_timerTick = 0
		end
		
		PushEvent("OPEN_XIUCHANG_LIST")
end

function ShowNoticeBall_Tick()
	g_ShowNoticeBall_timerTick = g_ShowNoticeBall_timerTick + 1
	if g_ShowNoticeBall_timerTick >= g_ShowNoticeBall_timerMaxTick then
			this:Hide()
			ShowNoticeBall_Button:Hide()
			ShowNoticeBall_Button:Play(false)
			if g_ShowNoticeBall_timerID ~= 0 then
				KillTimer(g_ShowNoticeBall_timerID)
				g_ShowNoticeBall_timerID = 0
				g_ShowNoticeBall_timerTick = 0
			end
	end 
end

