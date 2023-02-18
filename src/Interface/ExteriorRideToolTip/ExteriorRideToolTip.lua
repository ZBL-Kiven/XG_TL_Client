
-- local g_ExteriorRideToolTip_Frame_UnifiedPosition
local g_ExteriorRideId = -1
local g_ExteriorType = 0 --坐骑
local g_LeftTime = 0 --剩余时间
--=========
--PreLoad==
--=========
function ExteriorRideToolTip_PreLoad()
	this:RegisterEvent("EXTERIOR_RIDE_TOOLTIP")
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")	--离开场景关闭界面
end

--=========
--OnLoad
--=========
function ExteriorRideToolTip_OnLoad()
	-- g_ExteriorRideToolTip_Frame_UnifiedPosition = ExteriorRideToolTip_Frame:GetProperty("UnifiedPosition")
end
--=========
--OnEvent
--=========
function ExteriorRideToolTip_OnEvent(event)
	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		ExteriorRideToolTip_Frame:CenterWindow()
	elseif event == "HIDE_ON_SCENE_TRANSED" then
		ExteriorRideToolTip_CloseBtnClick()
	elseif event == "EXTERIOR_RIDE_TOOLTIP" then
		g_ExteriorRideId = tonumber(arg0)
		g_LeftTime = tonumber(arg1)
		if g_ExteriorRideId>=0 then
			ExteriorRideToolTip_Show()
		end
	end
	

end

function ExteriorRideToolTip_Show()
	this:Show()
	--显示静态头
	local toDisplay = "ExteriorRideToolTip_PageHeader";
	--详细解释
	toDisplay = toDisplay .. ";ExteriorRideToolTip_ShortDesc";
	toDisplay = toDisplay .. ";ExteriorRideToolTip_StaticPart_Yuanbaojiaoyi";
	toDisplay = toDisplay .. ";ExteriorRideToolTip_deadline_Text";
	toDisplay = toDisplay .. ";ExteriorRideToolTip_Tujian_Tips";
	-- toDisplay = toDisplay .. ";ExteriorRideToolTip_Tujian_Tips2";
	--显示组件内容
	_ExteriorRideToolTip_:SetProperty("PageElements", toDisplay);


	local strName = Exterior:LuaFnGetExteriorRideInfo(g_ExteriorRideId, "Name")

	-- local strIcon = Exterior:LuaFnGetExteriorRideInfo(g_ExteriorRideId,"Icon")
	local strTemp = ScriptGlobal_Format("#{WGTJ_201222_133}", strName)
	ExteriorRideToolTip_Title:SetText(strTemp)
	local strIcon = Exterior:LuaFnGetExteriorRideInfo(g_ExteriorRideId, "Icon")
	local strImage = GetIconFullName(strIcon)
	ExteriorRideToolTip_StaticPart_Icon:SetProperty("Image", strImage)
	-- PushDebugMessage(strImage)
	-- ExteriorRideToolTip_StaticPart_Icon:SetProperty("NormalImage", strImage)
	-- ExteriorRideToolTip_StaticPart_Icon:SetProperty("HoverImage", strImage)

	local strSpeed = Exterior:LuaFnGetExteriorRideInfo(g_ExteriorRideId, "Speed")
	local strContext = Exterior:LuaFnGetExteriorRideInfo(g_ExteriorRideId, "strContext")
	-- PushDebugMessage(strSpeed)
	local strTemp = ScriptGlobal_Format("#{WGTJ_201222_135}", strSpeed)

	

	-- local strTemp = Exterior:LuaFnGetRideToolTip(g_ExteriorRideId)
	strTemp = strTemp..ScriptGlobal_Format("#{WGTJ_201222_136}", strContext)
	-- local strTemp = ScriptGlobal_Format("#{WGTJ_201222_136}", strContext)
	local isLuxury = Exterior:LuaFnGetExteriorRideInfo(g_ExteriorRideId, "Luxury")
	if isLuxury == 1 then
		strTemp = strTemp.."#r#{WGTJ_201222_131}"
	end
	ExteriorRideToolTip_Tujian_Tips:SetText(strTemp)
	-- ExteriorRideToolTip_Tujian_Tips2:SetText(strTemp)

	local nLeftTime = g_LeftTime--Exterior:LuaFnGetExteriorLeftTime(g_ExteriorType, g_ExteriorRideId)
	if nLeftTime<0 then
		ExteriorRideToolTip_deadline_Text:SetText("#{WGTJ_201222_140}")
	else
		if nLeftTime>= 86400 then
			local days = math.floor(nLeftTime / 86400)
			local strTemp = ScriptGlobal_Format("#{WGTJ_201222_141}", days)
			ExteriorRideToolTip_deadline_Text:SetText(strTemp)
		elseif nLeftTime < 3600 then
			ExteriorRideToolTip_deadline_Text:SetText("#{WGTJ_201222_143}")
		else
			local nHours = math.floor(nLeftTime / 3600)
			local strTemp = ScriptGlobal_Format("#{WGTJ_201222_142}", nHours)
			ExteriorRideToolTip_deadline_Text:SetText(strTemp)
		end
	end
	
	_ExteriorRideToolTip_:PositionSelf(0, 0, 1, 1);
	local rH = _ExteriorRideToolTip_:GetProperty("AbsoluteHeight");
	_ExteriorRideToolTip_:SetProperty("AbsoluteXPosition",0)
	_ExteriorRideToolTip_:SetProperty("AbsoluteYPosition",0)
	_ExteriorRideToolTip_:SetProperty("AbsoluteHeight", tostring(rH));
	
end

-- function ExteriorRideToolTip_Frame_On_ResetPos()
-- 	ExteriorRideToolTip_Frame:SetProperty("UnifiedPosition", g_ExteriorRideToolTip_Frame_UnifiedPosition);
-- end

function ExteriorRideToolTip_OnMoved()
end


function ExteriorRideToolTip_OnHide()
	g_ExteriorRideId = -1
	g_LeftTime = 0 
end

function ExteriorRideToolTip_CloseBtnClick()
	this:Hide()
end