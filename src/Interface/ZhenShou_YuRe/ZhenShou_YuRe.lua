------------------------------------
-- 2022����Ԥ�Ȼ
-- �ż�����-ǰ��������
------------------------------------

local g_Frame_UnifiedPosition

local g_ZhenShou_YuRe_SceneId = 2
local g_ZhenShou_YuRe_PosX = 265
local g_ZhenShou_YuRe_PosZ = 129
local g_ZhenShou_YuRe_Name = "��ƮƮ"

--================================================
-- PreLoad()
--================================================
function ZhenShou_YuRe_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	-- ��Ϸ���ڳߴ緢���˱仯
	this:RegisterEvent("ADJEST_UI_POS")
	-- ��Ϸ�ֱ��ʷ����˱仯
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
-- �ָ������Ĭ�����λ��
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
	-- ��Ϸ���ڳߴ緢���˱仯
	elseif (event == "ADJEST_UI_POS" ) then
		ZhenShou_YuRe_ResetPos()
	-- ��Ϸ�ֱ��ʷ����˱仯
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		ZhenShou_YuRe_ResetPos()
	elseif (event == "PLAYER_LEAVE_WORLD" and this:IsVisible()) then
		ZhenShou_YuRe_OnHiden()
	end
end

--================================================
-- �رս���
--================================================
function ZhenShou_YuRe_OnHiden()
	this:Hide()
end

--================================================
-- ���ǰ��
--================================================
function ZhenShou_YuRe_Clicked()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnAccept")
		Set_XSCRIPT_ScriptID(893064)
		Set_XSCRIPT_ParamCount(0)
	Send_XSCRIPT()
	ZhenShou_YuRe_OnHiden()
end
