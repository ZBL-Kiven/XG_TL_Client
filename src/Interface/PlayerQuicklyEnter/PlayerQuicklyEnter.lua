--playerQuicklyEnterUI
--=======================================
local playerQuicklyEnterUI = {}			-- UI����
local playerQuicklyEnterAnimateBtn = {}	-- ��̬��ʾ��ť

--**********************************
-- PRELOAD �仯ʱ
--**********************************
function PlayerQuicklyEnter_PreLoad()
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED");	-- ��Ϸ�ֱ��ʷ����˱仯
	this:RegisterEvent("SCENE_TRANSED")
	this:RegisterEvent("UI_COMMAND")
end
--**********************************
-- ONLOAD
--**********************************
function PlayerQuicklyEnter_OnLoad()--����
	playerQuicklyEnterUI[1] = PlayerQuicklyEnter_Bk8;
	playerQuicklyEnterUI[2] = PlayerQuicklyEnter_Bk6;
	playerQuicklyEnterUI[3] = PlayerQuicklyEnter_Bk3;
	playerQuicklyEnterUI[4] = PlayerQuicklyEnter_Bk2;
	playerQuicklyEnterUI[5] = PlayerQuicklyEnter_Bk1;
	playerQuicklyEnterUI[6] = PlayerQuicklyEnter_Bk1;
	
	playerQuicklyEnterAnimateBtn[1] = PlayerQuicklyEnter_Image1;
	playerQuicklyEnterAnimateBtn[2] = PlayerQuicklyEnter_Image2;
	playerQuicklyEnterAnimateBtn[3] = PlayerQuicklyEnter_Image3;

	for	i, m in playerQuicklyEnterUI do
		m:Show()
	end
	PlayerQuicklyEnter_UpdateButton()
	--****************************************
	-- PlayerQuicklyEnter_Open:Hide()  --����ʾ��ť������
	-- PlayerQuicklyEnter_Close:Show() --�����ذ�ť��ʾ����
end
function PlayerQuicklyEnter_UpdateButton()
--    for i = 8,9 do--��ť����
	-- playerQuicklyEnterUI[10]:Hide();
--	end
	-- g_RedPoint[1]:Show();
	-- for i =2,3 do--С������
	    -- g_RedPoint[i]:Hide()
	-- end
end
--**********************************
-- ONEvent
--**********************************
function PlayerQuicklyEnter_OnEvent( event )
	if ( event == "VIEW_RESOLUTION_CHANGED" ) then
		local xmax, ymax = GetCurClientSize()
		g_nScreenWidth = xmax					--widthΪ��Ϸ��Ļ���
		g_nScreenHeight = ymax		--heightΪ��Ϸ��Ļ���
		g_nScreenWidth = math.floor( g_nScreenWidth );
		g_nScreenHeight = math.floor( g_nScreenHeight );
		-- PlayerQuicklyEnter_UpdateUIPos()
	elseif (event == "SCENE_TRANSED") then
		--this:Hide()--����������
		this:Show();--����������
	elseif ( event == "UI_COMMAND" ) and (arg0 == "201807310")  then
		this:Show();
    end
end
function PlayerQuicklyEnter_UpdateUIPos()
    local nNextIndex = g_nButtonCount
	local nSizeIndex = 1
	if ( g_nScreenWidth <= g_nScreenWidthLimit ) then
		nSizeIndex = 1
	else
		nSizeIndex = 2
	end

	local nMinimapWidth = 278
    PlayerQuicklyEnter_Frame:SetProperty( "UnifiedPosition", "{{1.000000, "..tostring(-1 * ( nNextIndex + 1 ) * BkSize[nSizeIndex][1] - nMinimapWidth).."},{0.000000,3}}" )
	PlayerQuicklyEnter_Frame:SetProperty( "AbsoluteSize", "w:"..( nNextIndex + 1 ) * BkSize[nSizeIndex][1].." h:"..BkSize[nSizeIndex][2].."" )

	-- PlayerQuicklyEnter_Open:SetProperty( "UnifiedPosition", "{{0.000000,"..nNextIndex * BkSize[nSizeIndex][1].."},{0.000000,0}}" )
	-- PlayerQuicklyEnter_Open:SetProperty( "UnifiedSize", "{{0.000000,"..BkSize[nSizeIndex][1].."},{0.000000,"..BkSize[nSizeIndex][2].."}}" )
	-- PlayerQuicklyEnter_OpenButton:SetProperty( "UnifiedSize", "{{0.000000,"..BkSize[nSizeIndex][1].."},{0.000000,"..BkSize[nSizeIndex][2].."}}" )
	-- PlayerQuicklyEnter_Close:SetProperty( "UnifiedPosition", "{{0.000000,"..nNextIndex * BkSize[nSizeIndex][1].."},{0.000000,0}}" )
	-- PlayerQuicklyEnter_Close:SetProperty( "UnifiedSize", "{{0.000000,"..BkSize[nSizeIndex][1].."},{0.000000,"..BkSize[nSizeIndex][2].."}}" )
	-- PlayerQuicklyEnter_CloseButton:SetProperty( "UnifiedSize", "{{0.000000,"..BkSize[nSizeIndex][1].."},{0.000000,"..BkSize[nSizeIndex][2].."}}" )
	
	for i = 1, g_nButtonCount do

--		if bPlayerQuicklyEnterUIShow[i] == 1 and
--			( g_bIsFlex == 0 or (g_bIsFlex == 1 and (g_Flex[i].CanHide == 0 or (g_Flex[i].FirstShow == 1 and bPlayerQuicklyEnterUIShow_Old[i] == 0) ) ) )
--		then
			nNextIndex = nNextIndex - 1
			-- BK
			playerQuicklyEnterUI[i]:SetProperty( "UnifiedPosition", "{{0.000000,"..nNextIndex * BkSize[nSizeIndex][1].."},{0.000000,0}}" )
			playerQuicklyEnterUI[i]:SetProperty( "UnifiedSize", "{{0.000000,"..BkSize[nSizeIndex][1].."},{0.000000,"..BkSize[nSizeIndex][2].."}}" )
			-- Image
			playerQuicklyEnterAnimateBtn[i]:SetProperty( "UnifiedSize", "{{0.000000,"..BkSize[nSizeIndex][1].."},{0.000000,"..BkSize[nSizeIndex][2].."}}" )

--		end
	end
end
--**********************************
-- ��ť�¼�
--**********************************
function PlayerQuicklyEnter_Clicked( nIndex )
	if nIndex == 1 then
		--ɨ��
			--PushDebugMessage("��ʱά���޸���")				
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "OpenSecKillList" ); 
			Set_XSCRIPT_ScriptID( 891062 );
			Set_XSCRIPT_ParamCount( 0 );
		Send_XSCRIPT()			
	elseif nIndex == 2 then
		--�ܻ�Ծ
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "OpenZhouHuoYue" ); 
			Set_XSCRIPT_ScriptID( 892002 );
			Set_XSCRIPT_Parameter(0,0);
			Set_XSCRIPT_ParamCount( 1 );
		Send_XSCRIPT()	
	elseif nIndex == 3 then
		--�ܻ�Ծ
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "OpenMingDong" ); 
			Set_XSCRIPT_ScriptID( 900037 );
			Set_XSCRIPT_Parameter(0,0);
			Set_XSCRIPT_ParamCount( 1 );
		Send_XSCRIPT()	
    -- elseif nIndex == 4 then
		-- PushEvent("UI_COMMAND",1000001166)
    -- elseif nIndex == 5 then
	-- Clear_XSCRIPT()
		-- Set_XSCRIPT_Function_Name( "acme_OpenTopList" );
		-- Set_XSCRIPT_ScriptID( 900036 );	
		-- Set_XSCRIPT_Parameter( 0, tonumber(1));
		-- Set_XSCRIPT_ParamCount( 1 );
	-- Send_XSCRIPT()			
    -- elseif nIndex == 6 then
	-- Clear_XSCRIPT()
		-- Set_XSCRIPT_Function_Name( "OpenJiangHuShengWang" );
		-- Set_XSCRIPT_ScriptID( 892037 );	
		-- Set_XSCRIPT_ParamCount( 0 );
	-- Send_XSCRIPT()
    -- elseif nIndex == 7 then
	-- Clear_XSCRIPT()
		-- Set_XSCRIPT_Function_Name( "XiaoXiang_yaoqingma" );
		-- Set_XSCRIPT_ScriptID( 928775 );	
		-- Set_XSCRIPT_Parameter( 0, tonumber(10000));
		-- Set_XSCRIPT_ParamCount( 1 );
	-- Send_XSCRIPT()	
	-- PushEvent("UI_COMMAND",20210809)
    -- elseif nIndex == 8 then
	-- �����
	-- PushEvent("UI_COMMAND",202108091)
    -- elseif nIndex == 9 then
	-- ����
	-- PlayerQuicklyEnter_OpenGuiShi()
    -- elseif nIndex == 10 then
	-- ������
	-- PlayerQuicklyEnter_OpenXingZhen()
    -- elseif nIndex == 11 then
	-- ʢ��ĵ��
    -- elseif nIndex == 12 then
	-- ɽ������

	-- elseif nIndex == 100 then --��ʾ����
		-- for	i, m in playerQuicklyEnterUI do
			-- m:Show()
		-- end
		-- PlayerQuicklyEnter_Open:Hide()  --����ʾ��ť������
		-- PlayerQuicklyEnter_Close:Show() --�����ذ�ť��ʾ����
	-- elseif nIndex == 101 then --��������
	    -- for	i, m in playerQuicklyEnterUI do
			-- if i > 7 then
                -- m:Hide()
			-- end
		-- end
		-- PlayerQuicklyEnter_UpdateButton()
		-- PlayerQuicklyEnter_Close:Hide() --�����ذ�ť������
		-- PlayerQuicklyEnter_Open:Show()  --����ʾ��ť��ʾ����
	end
end













