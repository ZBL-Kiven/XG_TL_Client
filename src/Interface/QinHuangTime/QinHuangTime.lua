local g_QinHuangTime_Data = {}
local g_QinHuangTime_Scene = 0
local g_QinHuangTime_UnifiedPosition;
function QinHuangTime_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	--离开场景，自动关闭
	this:RegisterEvent("PLAYER_LEAVE_WORLD", false)	
	this:RegisterEvent("QIHUANTIME_SWITCH")
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")	
	this:RegisterEvent("TOGLE_SYSTEMFRAME");
end
--界面21点50到24点显示
function QinHuangTime_OnLoad()	
	g_QinHuangTime_Data[1] = {title = "#{MJXZ_210510_09}",board="#{MJXZ_210510_10}",msg="#{MJXZ_210510_11}"}
	g_QinHuangTime_Data[2] = {title = "#{MJXZ_210510_18}",board="#{MJXZ_210510_19}",msg="#{MJXZ_210510_20}"}
	g_QinHuangTime_Data[3] = {title = "#{MJXZ_210510_21}",board="#{MJXZ_210510_22}",msg="#{MJXZ_210510_23}"}
	g_QinHuangTime_Data[4] = {title = "#{MJXZ_210510_26}",board="#{MJXZ_210510_27}",msg="#{MJXZ_210510_28}"}
	g_QinHuangTime_UnifiedPosition  =QinHuangTime:GetProperty("UnifiedPosition");
end

function QinHuangTime_OnEvent(event)

	if event == "UI_COMMAND" and tonumber(arg0) == 20210510 then
		if this:IsVisible("QinHuangTime") == true then
			QinHuangTimeUpdata()
		else
			this:Show()
			g_QinHuangTime_Scene = 0
			QinHuangTime_Time2:SetProperty("Timer", "60");
		end		
	end
	if event == "UI_COMMAND" and tonumber(arg0) == 20210511 then
			g_QinHuangTime_Scene = 0
			QinHuangTimeUpdata()
	end
	if event == "QIHUANTIME_SWITCH" then
		if tonumber(arg0) == 400 or tonumber(arg0) == 401 then
			this:Show()
		else
			this:Hide()
		end
	end

			-- 游戏窗口尺寸发生了变化
	if (event == "ADJEST_UI_POS" ) then
		QinHuangTime_On_ResetPos()
	-- 游戏分辨率发生了变化
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		QinHuangTime_On_ResetPos()
	elseif (event == "PLAYER_LEAVE_WORLD") then
		this:Hide()
	elseif event == "TOGLE_SYSTEMFRAME" then
		this:Hide()
	end
end

function QinHuangTime_TimeReach(nIndex)
	if nIndex == 1 then
		g_QinHuangTime_Scene = 1
	end
	if nIndex == 2 then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "acme_spend" );
			Set_XSCRIPT_ScriptID(810114);
			Set_XSCRIPT_ParamCount(0);
		Send_XSCRIPT()
		QinHuangTime_Time2:SetProperty("Timer", "60");		
	end
end

function QinHuangTimeUpdata()
	if g_QinHuangTime_Scene == 1 then
		return
	end
	QinHuangTime_Time:SetText(Get_XParam_INT( 0 ))--伤害总量
	QinHuangTime_Num:SetText(Get_XParam_INT( 1 ))
	-- PushDebugMessage(QinHuangTime_Time2:GetText())
end

function QinHuangTime_On_ResetPos()
	QinHuangTime:SetProperty("UnifiedPosition", g_QinHuangTime_UnifiedPosition);
end

function QinHuangTime_InitFrame(index,state,count)

	local showstate = function(state)
		if state == 1 or state == 0 then		--0应该关闭界面先这么写着
			QinHuangTime_Num:SetText("#G20:40")
		elseif state == 2 then
			QinHuangTime_Num:SetText("#G20:50")
		elseif state == 3 then
			QinHuangTime_Num:SetText("#G#{MJXZ_210510_13}")
		elseif state == 4 then
			QinHuangTime_Num:SetText("#G#{MJXZ_210510_14}")
		end
	end
	local strInfo = g_QinHuangTime_Data[index];
	if strInfo then
		QinHuangTime_DragTitle:SetText(strInfo.title)
		QinHuangTime_Text:SetText(strInfo.board)
		QinHuangTime_Pair_Title1:SetText(strInfo.msg)
		QinHuangTime_TimeTitle:SetText("#{MJXZ_210510_15}")
		QinHuangTime_Time:SetText("#G"..count)
		showstate(state)
		
		local sec = Lua_GetDiffTime_InSecond_ServerTime(23,59,0)
		QinHuangTime_Time2:SetProperty("TextColor","FB00FF00")
		QinHuangTime_Time2:SetProperty("Timer",sec)
	end
end

function QinHuangTime_OpenMini()
	PushEvent("QIHUANTIME_SWITCH",0,g_QinHuangTime_Scene)
end