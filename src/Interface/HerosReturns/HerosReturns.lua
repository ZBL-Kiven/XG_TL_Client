--HerosReturns.lua
local g_Frame_UnifiedPosition

--**********************************
-- PRELOAD
--**********************************
function HerosReturns_PreLoad()

	this:RegisterEvent("VIEW_RESOLUTION_CHANGED");	-- ��Ϸ�ֱ��ʷ����˱仯
	this:RegisterEvent("UI_COMMAND")				-- ����

	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")

end

--**********************************
-- ONLOAD
--**********************************
function HerosReturns_OnLoad()
	g_Frame_UnifiedPosition = HerosReturns_Frame:GetProperty("UnifiedPosition")
end

--**********************************
-- ONEvent
--**********************************
function HerosReturns_OnEvent( event )

	if ( event == "UI_COMMAND" and tonumber( arg0 ) == 80811000 ) then

		local bShow =  Get_XParam_INT( 0 );
		if bShow == 1 then
			this:Show();
		else
			this:Hide();
		end
		
	elseif ( event == "UI_COMMAND" and tonumber( arg0 ) == 80811006 and this:IsVisible() ) then
		this:Hide();
		
	elseif (event == "UI_COMMAND" and tonumber( arg0 ) == 80811005 and this:IsVisible()) then
		--���
		local nRedPointState= Get_XParam_INT( 0 ) + Get_XParam_INT( 1 ) + Get_XParam_INT( 2 )
		if nRedPointState > 0 then
			HerosReturns_Image_tips:Show();
		else
			HerosReturns_Image_tips:Hide();
		end
		
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		HerosReturns_UpdateUIPos()
		
	elseif ( event == "VIEW_RESOLUTION_CHANGED" ) then
		HerosReturns_UpdateUIPos()

	end
	
end

--**********************************
-- UIλ��
--**********************************
function HerosReturns_UpdateUIPos()
	HerosReturns_Frame:SetProperty("UnifiedPosition", g_Frame_UnifiedPosition);
end

--**********************************
-- ��ť�¼�
--**********************************
function HerosReturns_Clicked( nIndex )

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "OnOpenUI" ); 		-- �ű���
		Set_XSCRIPT_ScriptID( 808110 );						-- �ű����
		Set_XSCRIPT_Parameter(0, 1)
		Set_XSCRIPT_ParamCount( 1 );						-- ��������
	Send_XSCRIPT()
	
end
