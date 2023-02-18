
--//2021剧情任务-ypl

local g_ZLMysteriousLetter1_Frame_UnifiedPosition

function ZLMysteriousLetter1_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("PLAYER_LEAVE_WORLD");		
end

function ZLMysteriousLetter1_OnLoad()
	g_ZLMysteriousLetter1_Frame_UnifiedPosition = ZLMysteriousLetter1_Frame:GetProperty("UnifiedPosition");
end

function ZLMysteriousLetter1_OnEvent(event)

	if ( event == "UI_COMMAND" ) then
		local num = tonumber(arg0)
		if num == 8910810 then
			this:Show()
		end
	-- 游戏窗口尺寸发生了变化
	elseif (event == "ADJEST_UI_POS" ) then
		ZLMysteriousLetter1_ResetPos()
	-- 游戏分辨率发生了变化
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		ZLMysteriousLetter1_ResetPos()
	elseif (event == "PLAYER_LEAVE_WORLD" and this:IsVisible()) then
		this:Hide()		
	end
end

function ZLMysteriousLetter1_Frame_OnHiden()
	ZLMysteriousLetter1_Hide()
end

function ZLMysteriousLetter1_Hide()
	this:Hide()
end

function ZLMysteriousLetter1_Clicked()
	ZLMysteriousLetter1_Hide()
end

--================================================
-- 恢复界面的默认相对位置
--================================================
function ZLMysteriousLetter1_ResetPos()
	ZLMysteriousLetter1_Frame:SetProperty("UnifiedPosition", g_ZLMysteriousLetter1_Frame_UnifiedPosition);
end
