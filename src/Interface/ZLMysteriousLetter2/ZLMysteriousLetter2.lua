
--//2021剧情任务-ypl

local g_ZLMysteriousLetter2_Frame_UnifiedPosition

function ZLMysteriousLetter2_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")		
	this:RegisterEvent("PLAYER_LEAVE_WORLD");	
end

function ZLMysteriousLetter2_OnLoad()
	g_ZLMysteriousLetter2_Frame_UnifiedPosition = ZLMysteriousLetter2_Frame:GetProperty("UnifiedPosition");
end

function ZLMysteriousLetter2_OnEvent(event)

	if ( event == "UI_COMMAND" ) then
		local num = tonumber(arg0)
		if num == 8910950 then
			this:Show()
		end
	-- 游戏窗口尺寸发生了变化
	elseif (event == "ADJEST_UI_POS" ) then
		ZLMysteriousLetter2_ResetPos()
	-- 游戏分辨率发生了变化
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		ZLMysteriousLetter2_ResetPos()
	elseif (event == "PLAYER_LEAVE_WORLD" and this:IsVisible()) then
		this:Hide()		
	end
end

function ZLMysteriousLetter2_Frame_OnHiden()
	ZLMysteriousLetter2_Hide()
end

function ZLMysteriousLetter2_Hide()
	this:Hide()
end

function ZLMysteriousLetter2_Clicked()
	ZLMysteriousLetter2_Hide()
end

--================================================
-- 恢复界面的默认相对位置
--================================================
function ZLMysteriousLetter2_ResetPos()
	ZLMysteriousLetter2_Frame:SetProperty("UnifiedPosition", g_ZLMysteriousLetter2_Frame_UnifiedPosition);
end
