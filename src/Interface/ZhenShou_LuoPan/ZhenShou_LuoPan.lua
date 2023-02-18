------------------------------------
-- 2022珍兽预热活动
-- 罗盘界面
------------------------------------
local g_UnifiedPosition;

local g_IsInLimitDis;
local g_NowDistance;

local g_TargetPosx;
local g_TargetPosy;

local g_Offsetx;
local g_Offsety;

--===============================================
-- PreLoad()
--===============================================
function ZhenShou_LuoPan_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("UPDATE_MAP",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
end

--===============================================
-- OnLoad()
--===============================================
function ZhenShou_LuoPan_OnLoad()

	g_UnifiedPosition = ZhenShou_LuoPan_Frame:GetProperty("UnifiedPosition")
		
	local pwidth, pheight = ZhenShou_LuoPan_Client:GetWindowSize()
	local swidth, sheight = ZhenShou_LuoPan_Point:GetWindowSize()
		
	g_Offsetx = pwidth/2 - swidth/2
	g_Offsety = pheight/2 - sheight/2
	
	ZhenShou_LuoPan_FrameBK_Arrival:Play(false)

end

--===============================================
-- OnEvent(event)
--===============================================
function ZhenShou_LuoPan_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == 89306501 ) then
		local x = Get_XParam_INT( 0 )
		local z = Get_XParam_INT( 1 )
		if x > 0 and z > 0 then
			-- 打开界面
			this:Show()
			g_IsInLimitDis = false;
			ZhenShou_LuoPan_FrameBK_Arrival:Play(false)
			ZhenShou_LuoPan_Point:Play(true)
			g_TargetPosx = x
			g_TargetPosy = z
		else
			-- 关闭界面
			if this:IsVisible() then
				ZhenShou_LuoPan_OnClose()
			end
		end
	elseif ( event == "UPDATE_MAP") then 
		ZhenShou_LuoPan_Update()
	elseif ( event == "HIDE_ON_SCENE_TRANSED") then 
		ZhenShou_LuoPan_OnClose()
	elseif (event == "ADJEST_UI_POS") then
		ZhenShou_LuoPan_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		ZhenShou_LuoPan_ResetPos()
	end
end

--===============================================
-- 重置
--===============================================
function ZhenShou_LuoPan_ResetPos()
	ZhenShou_LuoPan_Frame:SetProperty("UnifiedPosition",g_UnifiedPosition)
end

--===============================================
-- OnHiden()
--===============================================
function ZhenShou_LuoPan_OnHiden()
end

--===============================================
-- 关闭界面
--===============================================
function ZhenShou_LuoPan_OnClose()
	this:Hide()
end

--===============================================
-- 获得距离
--===============================================
function ZhenShou_LuoPan_GetDistance()
	local myPosx, myPosz, _ = Target:GetMyPos()
	local cameraDir = GetCameraDir();
	local deltax = myPosx - g_TargetPosx
	local deltay = myPosz - g_TargetPosy
	if deltax == 0 then deltax = 1 end
	local offsetDir = math.atan(deltay/deltax);
	if deltax < 0 then 
		offsetDir = offsetDir + math.pi;
	end
	local distance = math.floor(math.sqrt(deltax*deltax+deltay*deltay));
	local radis = g_Offsety - 2
	ZhenShou_LuoPan_Point:SetProperty("UnifiedPosition", string.format("{{0,%s},{0,%s}}", g_Offsetx-2+radis*math.cos(offsetDir+cameraDir), g_Offsety-4+radis*math.sin(offsetDir+cameraDir)))
	return distance
end

--===============================================
-- 更新
--===============================================
function ZhenShou_LuoPan_Update()
	if( this:IsVisible() ) then
		g_NowDistance = ZhenShou_LuoPan_GetDistance()
		if g_NowDistance < 1 then
			g_NowDistance = 1
		end
		ZhenShou_LuoPan_Distance:SetText(ScriptGlobal_Format("#{ZSYR_211227_301}", g_NowDistance))
		if g_NowDistance >= 5 then 
			if true == g_IsInLimitDis then 
				g_IsInLimitDis = false
				ZhenShou_LuoPan_FrameBK_Arrival:Play(false)
				ZhenShou_LuoPan_Point:Play(true)
			end
		else
			if false == g_IsInLimitDis then
				g_IsInLimitDis = true
				ZhenShou_LuoPan_FrameBK_Arrival:Play(true)
				ZhenShou_LuoPan_Point:Play(false)
			end
		end
	end
end
