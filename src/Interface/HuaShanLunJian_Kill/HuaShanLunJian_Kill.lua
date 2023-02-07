-- 击杀播报UI
local g_Frame_UnifiedXPosition;
local g_Frame_UnifiedYPosition;

local g_Image = {
						[1] = "set:HSLJ_Match1  image:Killnamered",
						[2] = "set:HSLJ_Match1  image:Killnameblue",
}

local g_Timer = -1

function HuaShanLunJian_Kill_PreLoad()

	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("BWTROOPS_KILL_SHOW")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)

end

function HuaShanLunJian_Kill_OnLoad()
	-- 保存界面的默认相对位置
	g_Frame_UnifiedXPosition	= HuaShanLunJian_Kill:GetProperty("UnifiedXPosition");
	g_Frame_UnifiedYPosition	= HuaShanLunJian_Kill:GetProperty("UnifiedYPosition");
	HuaShanLunJian_Kill_CtrlList_InitData()
	g_Timer = 3
	
end

function HuaShanLunJian_Kill_CtrlList_InitData()

	HuaShanLunJian_Kill_Left_Text:SetText("")
	HuaShanLunJian_Kill_Right_Text:SetText("")
	
end

function HuaShanLunJian_Kill_OnEvent(event)

	if( event == "ADJEST_UI_POS" ) then
		HuaShanLunJian_Kill_ResetPos()
	elseif( event == "BWTROOPS_KILL_SHOW") then
		--读取数据显示
		--PushDebugMessage("11111")
		if g_Timer > 0 then
			KillTimer("HuaShanLunJian_Kill_Timer()")
		end
		g_Timer = 3
		HuaShanLunJian_Kill_CtrlList_InitData()
		HuaShanLunJian_Kill_Left_Text:SetText("#W"..arg1)
		HuaShanLunJian_Kill_Right_Text:SetText("#W"..arg2)
		-- local nKillHead = GetIconFullName(tostring(XBW:LuaGetPortraitInfo(tonumber(arg4)))) 
		-- local nBeKillHead = GetIconFullName(tostring(XBW:LuaGetPortraitInfo(tonumber(arg5)))) 
		
		-- HuaShanLunJian_Kill_Left_HeadIcon:SetProperty("Image", tostring(XBW:LuaGetPortraitInfo(tonumber(arg4))));	
		-- HuaShanLunJian_Kill_Right_HeadIcon:SetProperty("Image", tostring(XBW:LuaGetPortraitInfo(tonumber(arg5))));	
		SetTimer("HuaShanLunJian_Kill","HuaShanLunJian_Kill_Timer()", 1*1000)
		this:Show()
		if tonumber(arg3) == 0 then -- 首杀
			HuaShanLunJian_Kill_FirstKill:Show()
			HuaShanLunJian_Kill_Middle:Hide()
		else
			HuaShanLunJian_Kill_Middle:Show()
			HuaShanLunJian_Kill_FirstKill:Hide()
		end
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		HuaShanLunJian_Kill_CtrlList_InitData()
		this:Hide()
	end

end

--================================================
-- 恢复界面的默认相对位置
--================================================
function HuaShanLunJian_Kill_ResetPos()
	HuaShanLunJian_Kill:SetProperty("UnifiedXPosition", g_Frame_UnifiedXPosition);
	HuaShanLunJian_Kill:SetProperty("UnifiedYPosition", g_Frame_UnifiedYPosition);
end

function HuaShanLunJian_Kill_Timer()
	g_Timer = g_Timer - 1 
	if g_Timer == 0 then
		KillTimer("HuaShanLunJian_Kill_Timer()")
		this:Hide()
	end
end
