
--//2021剧情任务-ypl

local g_ZLHeroicPosts_Frame_UnifiedPosition

local g_ZLHeroicPosts_state

local g_ZLHeroicPosts_SceneId = 2
local g_ZLHeroicPosts_PosX = 160  --替代
local g_ZLHeroicPosts_PosZ = 157 --替代
local g_ZLHeroicPosts_Name = "赵天师"

function ZLHeroicPosts_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")	
	this:RegisterEvent("PLAYER_LEAVE_WORLD");	
end

function ZLHeroicPosts_OnLoad()
	g_ZLHeroicPosts_Frame_UnifiedPosition = ZLHeroicPosts_Frame:GetProperty("UnifiedPosition");
	g_ZLHeroicPosts_state = -1
end

function ZLHeroicPosts_OnEvent(event)
	if ( event == "UI_COMMAND" ) then
		local num = tonumber(arg0)
		if num == 8910801 then
			g_ZLHeroicPosts_state = 1
			ZLHeroicPosts_GotoBtn:SetText("#{YXDHYD_210223_07}")
			this:Show()
		elseif num == 8910802 then
			g_ZLHeroicPosts_state = 2
			ZLHeroicPosts_GotoBtn:SetText("#{YXDHYD_210223_08}")
			this:Show()
		elseif num == 8910804 then
			AutoRuntoTargetExWithName(g_ZLHeroicPosts_PosX, g_ZLHeroicPosts_PosZ, g_ZLHeroicPosts_SceneId, g_ZLHeroicPosts_Name)
		end
		
	-- 游戏窗口尺寸发生了变化
	elseif (event == "ADJEST_UI_POS" ) then
		ZLHeroicPosts_ResetPos()
	-- 游戏分辨率发生了变化
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		ZLHeroicPosts_ResetPos()
	elseif (event == "PLAYER_LEAVE_WORLD" and this:IsVisible()) then
		this:Hide()
	end
end

function ZLHeroicPosts_Frame_OnHiden()
	ZLHeroicPosts_Hide()
end

function ZLHeroicPosts_Hide()
	this:Hide()
end

function ZLHeroicPosts_Clicked()
	if g_ZLHeroicPosts_state == 1 then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("OnAccept")
			Set_XSCRIPT_ScriptID(891080)
			Set_XSCRIPT_ParamCount(0)
		Send_XSCRIPT()
	end
	
	ZLHeroicPosts_Hide()
end

--================================================
-- 恢复界面的默认相对位置
--================================================
function ZLHeroicPosts_ResetPos()
	ZLHeroicPosts_Frame:SetProperty("UnifiedPosition", g_ZLHeroicPosts_Frame_UnifiedPosition);
end
