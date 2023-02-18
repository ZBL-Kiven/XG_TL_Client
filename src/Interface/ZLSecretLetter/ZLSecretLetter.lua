
--//2021��������-ypl

local g_ZLSecretLetter_Frame_UnifiedPosition

function ZLSecretLetter_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	-- ��Ϸ���ڳߴ緢���˱仯
	this:RegisterEvent("ADJEST_UI_POS")
	-- ��Ϸ�ֱ��ʷ����˱仯
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
	-- ��Ϸ���ڳߴ緢���˱仯
	elseif (event == "ADJEST_UI_POS" ) then
		ZLSecretLetter_ResetPos()
	-- ��Ϸ�ֱ��ʷ����˱仯
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
-- �ָ������Ĭ�����λ��
--================================================
function ZLSecretLetter_ResetPos()
	ZLSecretLetter_Frame:SetProperty("UnifiedPosition", g_ZLSecretLetter_Frame_UnifiedPosition);
end
