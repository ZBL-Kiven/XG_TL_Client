local g_Frame_UnifiedXPosition;
local g_Frame_UnifiedYPosition;


function HuaShanLunJian_FightMini_PreLoad()

	--this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	this:RegisterEvent("BWTROOPS_SHOW_MINI_BOX")
	this:RegisterEvent("BWTROOPS_COPYDATA_FIRST_TIME")
	this:RegisterEvent("BWTROOPS_RESULT_SHOW",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	-- ��Ϸ���ڳߴ緢���˱仯
	this:RegisterEvent("ADJEST_UI_POS",false)

	-- ��Ϸ�ֱ��ʷ����˱仯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
end

function HuaShanLunJian_FightMini_OnLoad()
	-- ��������Ĭ�����λ��
	g_Frame_UnifiedXPosition	= HuaShanLunJian_FightMini_Frame:GetProperty("UnifiedXPosition");
	g_Frame_UnifiedYPosition	= HuaShanLunJian_FightMini_Frame:GetProperty("UnifiedYPosition");
end

function HuaShanLunJian_FightMini_OnEvent(event)

	if( event == "ADJEST_UI_POS" ) then
		HuaShanLunJian_FightMini_ResetPos()

	--elseif( event == "HIDE_ON_SCENE_TRANSED" ) then
	--	this:Hide();
	elseif( event == "BWTROOPS_SHOW_MINI_BOX" ) then
		this:Show();
	elseif(event == "BWTROOPS_COPYDATA_FIRST_TIME"	) then
		--��֤����UI�ǻ�����ʾ�ġ�
		if (this:IsVisible())  then
			this:Hide()
		end
	elseif(event == "BWTROOPS_RESULT_SHOW")	 then
		if (this:IsVisible())  then
			HuaShanLunJian_FightMini_OnShowNormalUI()
		end
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		this:Hide()
	end
	
end

function HuaShanLunJian_FightMini_ResetPos()

	HuaShanLunJian_FightMini_Frame:SetProperty("UnifiedXPosition", g_Frame_UnifiedXPosition);
	HuaShanLunJian_FightMini_Frame:SetProperty("UnifiedYPosition", g_Frame_UnifiedYPosition);

end

function HuaShanLunJian_FightMini_OnShowNormalUI()
	this:Hide()
	PushEvent( "BWTROOPS_SHOW_FULLDATA_BOX" )
end