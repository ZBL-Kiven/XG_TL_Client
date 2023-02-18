
--//2021剧情任务-ypl

local g_ZLSecretLetter_Frame_UnifiedPosition

function ZLSecretLetter_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")		
	this:RegisterEvent("PLAYER_LEAVE_WORLD");	
end

function ZLSecretLetter_OnLoad()
	g_ZLSecretLetter_Frame_UnifiedPosition = ZLSecretLetter_Frame:GetProperty("UnifiedPosition");
end

function ZLSecretLetter_OnEvent(event)

	if ( event == "UI_COMMAND" ) then
		local num = tonumber(arg0)
		if num == 8910850 then
			this:Show()
		end
	-- 游戏窗口尺寸发生了变化
	elseif (event == "ADJEST_UI_POS" ) then
		ZLSecretLetter_ResetPos()
	-- 游戏分辨率发生了变化
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		ZLSecretLetter_ResetPos()
	elseif (event == "PLAYER_LEAVE_WORLD" and this:IsVisible()) then
		this:Hide()		
	end
end

function ZLSecretLetter_Frame_OnHiden()
	ZLSecretLetter_Hide()
end

function ZLSecretLetter_Hide()
	this:Hide()
end

function ZLSecretLetter_Clicked()
	ZLSecretLetter_Hide()
end

--================================================
-- 恢复界面的默认相对位置
--================================================
function ZLSecretLetter_ResetPos()
	ZLSecretLetter_Frame:SetProperty("UnifiedPosition", g_ZLSecretLetter_Frame_UnifiedPosition);
end
