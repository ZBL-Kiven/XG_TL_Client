
--//2021��������-ypl

local g_ZLMysteriousLetter2_Frame_UnifiedPosition

function ZLMysteriousLetter2_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	-- ��Ϸ���ڳߴ緢���˱仯
	this:RegisterEvent("ADJEST_UI_POS")
	-- ��Ϸ�ֱ��ʷ����˱仯
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
	-- ��Ϸ���ڳߴ緢���˱仯
	elseif (event == "ADJEST_UI_POS" ) then
		ZLMysteriousLetter2_ResetPos()
	-- ��Ϸ�ֱ��ʷ����˱仯
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
-- �ָ������Ĭ�����λ��
--================================================
function ZLMysteriousLetter2_ResetPos()
	ZLMysteriousLetter2_Frame:SetProperty("UnifiedPosition", g_ZLMysteriousLetter2_Frame_UnifiedPosition);
end
