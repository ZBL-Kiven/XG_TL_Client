------------------------------------
-- 2022珍兽预热活动
-- 信件界面-前序任务用
------------------------------------

local g_Frame_UnifiedPosition

local g_ZhenShou_YuRe_SceneId = 2
local g_ZhenShou_YuRe_PosX = 265
local g_ZhenShou_YuRe_PosZ = 129
local g_ZhenShou_YuRe_Name = "云飘飘"

--================================================
-- PreLoad()
--================================================
function ZhenShou_YuRe_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")	
	this:RegisterEvent("PLAYER_LEAVE_WORLD");	
end

--================================================
-- OnLoad()
--================================================
function ZhenShou_YuRe_OnLoad()
	g_Frame_UnifiedPosition = ZhenShou_YuRe_Frame:GetProperty("UnifiedPosition");
end

--================================================
-- 恢复界面的默认相对位置
--================================================
function ZhenShou_YuRe_ResetPos()
	ZhenShou_YuRe_Frame:SetProperty("UnifiedPosition", g_Frame_UnifiedPosition);
end

--================================================
-- OnEvent()
--================================================
function ZhenShou_YuRe_OnEvent(event)
	if ( event == "UI_COMMAND" ) then
		local num = tonumber(arg0)
		if num == 89306902 then
			this:Show()
		elseif num == 89306401 then
			AutoRuntoTargetExWithName(g_ZhenShou_YuRe_PosX, g_ZhenShou_YuRe_PosZ, g_ZhenShou_YuRe_SceneId, g_ZhenShou_YuRe_Name)
		end		
	-- 游戏窗口尺寸发生了变化
	elseif (event == "ADJEST_UI_POS" ) then
		ZhenShou_YuRe_ResetPos()
	-- 游戏分辨率发生了变化
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		ZhenShou_YuRe_ResetPos()
	elseif (event == "PLAYER_LEAVE_WORLD" and this:IsVisible()) then
		ZhenShou_YuRe_OnHiden()
	end
end

--================================================
-- 关闭界面
--================================================
function ZhenShou_YuRe_OnHiden()
	this:Hide()
end

--================================================
-- 点击前往
--================================================
function ZhenShou_YuRe_Clicked()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnAccept")
		Set_XSCRIPT_ScriptID(893064)
		Set_XSCRIPT_ParamCount(0)
	Send_XSCRIPT()
	ZhenShou_YuRe_OnHiden()
end
