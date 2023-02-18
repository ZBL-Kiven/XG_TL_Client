-- �±�����������

local g_Frame_UnifiedPosition ={}
local g_HuaShanLunJian_FightEnd2_Timer

function HuaShanLunJian_FightEnd2_PreLoad()

	-- ��Ϸ���ڳߴ緢���˱仯
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- ��Ϸ�ֱ��ʷ����˱仯
	this:RegisterEvent("BWTROOPS_RESULT_SHOW")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
end

function HuaShanLunJian_FightEnd2_OnLoad()
	-- ��������Ĭ�����λ��
	g_Frame_UnifiedPosition[1]	= HuaShanLunJian_FightEnd2_Frame:GetProperty("UnifiedXPosition");
	g_Frame_UnifiedPosition[2]	= HuaShanLunJian_FightEnd2_Frame:GetProperty("UnifiedYPosition");

	HuaShanLunJian_FightEnd2_ImageShengChang:Hide()
	HuaShanLunJian_FightEnd2_ImageShengChang:Play(false)

	g_HuaShanLunJian_FightEnd2_Timer = 0
	KillTimer("HuaShanLunJian_FightEnd2_30STimer()")
end

function HuaShanLunJian_FightEnd2_OnEvent(event)

	if( event == "ADJEST_UI_POS" ) then
		HuaShanLunJian_FightEnd2_ResetPos()
	elseif ( event == "BWTROOPS_RESULT_SHOW" ) then
		--������ by yuanpeilong
		if tonumber(arg1) == -1 then
			this:Hide()
			return
		end	
		local result = tonumber(arg0) --0��ʤ����1��ʧ�ܡ�
		local score = tonumber(arg1) --�ۻ�ʤ������
		HuaShanLunJian_FightEnd2_TextShengChang:SetText(ScriptGlobal_Format("#{HSSC_191009_108}", score))
		if (result == 0) then
			HuaShanLunJian_FightEnd2_ImageShengChang:Show()
			HuaShanLunJian_FightEnd2_ImageShengChang:Play(true)
			g_HuaShanLunJian_FightEnd2_Timer = 3
			SetTimer("HuaShanLunJian_FightEnd2","HuaShanLunJian_FightEnd2_30STimer()", 1000)
			this:Show()
		else
			this:Hide()
		end
		
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		this:Hide()
	end
	
end

function HuaShanLunJian_FightEnd2_30STimer()

	g_HuaShanLunJian_FightEnd2_Timer = g_HuaShanLunJian_FightEnd2_Timer - 1 
	if g_HuaShanLunJian_FightEnd2_Timer == 0 then
		KillTimer("HuaShanLunJian_FightEnd2_30STimer()")
		HuaShanLunJian_FightEnd2_Close()
		return
	end

end
--================================================
-- �ָ������Ĭ�����λ��
--================================================
function HuaShanLunJian_FightEnd2_ResetPos()
	HuaShanLunJian_FightEnd2_Frame:SetProperty("UnifiedXPosition", g_Frame_UnifiedPosition[1]);
	HuaShanLunJian_FightEnd2_Frame:SetProperty("UnifiedYPosition", g_Frame_UnifiedPosition[2]);
end
-- �رպ���
function HuaShanLunJian_FightEnd2Frame_CloseWindow()
	this:Hide()
end

function HuaShanLunJian_FightEnd2_Close()
	KillTimer("HuaShanLunJian_FightEnd2_30STimer()")
	this:Hide()
end