
--//2021��������-ypl

local g_ZLMysteriousLetter1_Frame_UnifiedPosition

function ZLMysteriousLetter1_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	-- ��Ϸ���ڳߴ緢���˱仯
	this:RegisterEvent("ADJEST_UI_POS")
	-- ��Ϸ�ֱ��ʷ����˱仯
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
	-- ��Ϸ���ڳߴ緢���˱仯
	elseif (event == "ADJEST_UI_POS" ) then
		ZLMysteriousLetter1_ResetPos()
	-- ��Ϸ�ֱ��ʷ����˱仯
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
-- �ָ������Ĭ�����λ��
--================================================
function ZLMysteriousLetter1_ResetPos()
	ZLMysteriousLetter1_Frame:SetProperty("UnifiedPosition", g_ZLMysteriousLetter1_Frame_UnifiedPosition);
end
