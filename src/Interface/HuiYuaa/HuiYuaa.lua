local g_Frame_UnifiedXPosition;
local g_Frame_UnifiedYPosition;
function HuiYuaa_PreLoad()
	this:RegisterEvent("UI_COMMAND");
		-- ��Ϸ���ڳߴ緢���˱仯
--	this:RegisterEvent("ADJEST_UI_POS")
	-- ��Ϸ�ֱ��ʷ����˱仯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("SCENE_TRANSED")
end
function HuiYuaa_OnLoad()
	-- ��������Ĭ�����λ��
	--g_Frame_UnifiedXPosition	= HuiYuaa_Frame:GetProperty("UnifiedXPosition");
	--g_Frame_UnifiedYPosition	= HuiYuaa_Frame:GetProperty("UnifiedYPosition");
end
function HuiYuaa_OnEvent(event)
	if event == "UI_COMMAND"  and tonumber(arg0) == 89056178 then
		
		chou_s0 = Get_XParam_STR(0);
		choufu = Get_XParam_STR(1)
HuiYuaa10_txt:SetText(chou_s0)
HuiYuaa11_txt:SetText(choufu)
		this:Show();		
	elseif( event == "VIEW_RESOLUTION_CHANGED" ) then
	--	HuiYuaa_ResetPos()
	elseif (event == "SCENE_TRANSED") then
		HuiYuaa_OnHiden()
	end
end

--================================================
-- �����Ĭ�����λ��
--================================================
function HuiYuaa_ResetPos()
	--HuiYuaa_Frame:SetProperty("UnifiedXPosition", g_Frame_UnifiedXPosition);
	--HuiYuaa_Frame:SetProperty("UnifiedYPosition", g_Frame_UnifiedYPosition);
end
function HuiYuaa_OnHiden()
	this:Hide();
end


function HuiYuaa_Btn_MouseLeave(dix)
	
	
end

function HuiYuaa_Btn_Clicked(nIndexx)

end