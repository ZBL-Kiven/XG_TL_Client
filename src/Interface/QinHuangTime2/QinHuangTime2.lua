local g_QinHuangTime2_Data = {}
local g_QinHuangTime2_Scene = 0
local g_QinHuangTime2_UnifiedPosition;
function QinHuangTime2_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	--离开场景，自动关闭
	this:RegisterEvent("PLAYER_LEAVE_WORLD", false)	
	this:RegisterEvent("QIHUANTIME_SWITCH")
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")		
end
--界面21点50到24点显示
function QinHuangTime2_OnLoad()	
	g_QinHuangTime2_Data[1] = {title = "#{MJXZ_210510_09}",board="#{MJXZ_210510_10}",msg="#{MJXZ_210510_11}"}
	g_QinHuangTime2_Data[2] = {title = "#{MJXZ_210510_18}",board="#{MJXZ_210510_19}",msg="#{MJXZ_210510_20}"}
	g_QinHuangTime2_Data[3] = {title = "#{MJXZ_210510_21}",board="#{MJXZ_210510_22}",msg="#{MJXZ_210510_23}"}
	g_QinHuangTime2_Data[4] = {title = "#{MJXZ_210510_26}",board="#{MJXZ_210510_27}",msg="#{MJXZ_210510_28}"}
	g_QinHuangTime2_UnifiedPosition  =QinHuangTime2:GetProperty("UnifiedPosition");
end

function QinHuangTime2_OnEvent(event)

	if event == "UI_COMMAND" and tonumber(arg0) == 20210510 then
		local sceneId =  Get_XParam_INT( 0 );
		local state = Get_XParam_INT(1)
		local count = Get_XParam_INT(2)
		--PushDebugMessage("ssss="..sceneId)		

		if sceneId == 402 then 
			QinHuangTime2_InitFrame(3,state,count)
			if IsWindowShow("QinHuangTime_Mini") == false then
				this:Show()
			end
		else
			this:Hide()
		end

		g_QinHuangTime2_Scene = sceneId
		
	end

	if event == "QIHUANTIME_SWITCH" then
		if tonumber(arg0) == 402 then
			this:Show()
		else
			this:Hide()
		end
	end
			-- 游戏窗口尺寸发生了变化
		if (event == "ADJEST_UI_POS" ) then
			QinHuangTime2_On_ResetPos()
		-- 游戏分辨率发生了变化
		elseif (event == "VIEW_RESOLUTION_CHANGED") then
			QinHuangTime2_On_ResetPos()
		elseif (event == "PLAYER_LEAVE_WORLD") then
			this:Hide()
		end	

end


function QinHuangTime2_On_ResetPos()
	QinHuangTime2:SetProperty("UnifiedPosition", g_QinHuangTime2_UnifiedPosition);
end


function QinHuangTime2_InitFrame(index,state,count)

	local showstate = function(state)
		if state == 1 or state == 0 then		--0应该关闭界面先这么写着
			QinHuangTime2_Num:SetText("#G20:40")
		elseif state == 2 then
			QinHuangTime2_Num:SetText("#G20:50")
		elseif state == 3 then
			QinHuangTime2_Num:SetText("#G#{MJXZ_210510_13}")
		elseif state == 4 then
			QinHuangTime2_Num:SetText("#G#{MJXZ_210510_14}")
		end
	end
	local strInfo = g_QinHuangTime2_Data[index];
	if strInfo then
		QinHuangTime2_DragTitle:SetText(strInfo.title)
		QinHuangTime2_Text:SetText(strInfo.board)
		QinHuangTime2_Pair_Title1:SetText(strInfo.msg)
		QinHuangTime2_TimeTitle:SetText("#{MJXZ_210510_15}")
		QinHuangTime2_Time:SetText("#G"..count)
		showstate(state)
		
		local sec = Lua_GetDiffTime_InSecond_ServerTime(23,59,0)
		QinHuangTime2_Time2:SetProperty("TextColor","FB00FF00")
		QinHuangTime2_Time2:SetProperty("Timer",sec)
	end
end

function QinHuangTime2_OpenMini()
	PushEvent("QIHUANTIME_SWITCH",0,g_QinHuangTime2_Scene)
end

function QinHuangTime2_Goto()
	AutoRunToTarget( 132.9, 39.8 );
end