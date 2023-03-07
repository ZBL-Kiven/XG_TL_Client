local g_PreAlpha = "0.8";
g_NewNewMenu = 1
--===============================================
-- PreLoad()
--===============================================
function GameSetup_PreLoad()

	this:RegisterEvent("TOGLE_GAMESETUP");

	this:RegisterEvent("TOGLE_SYSTEMFRAME");
	this:RegisterEvent("TOGLE_SOUNDSETUP");
	this:RegisterEvent("TOGLE_VIEWSETUP");
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	local n1,n2,n3,n4,n5,n6,n7,n8,n9,f10,n11,n12,n13,n14,n15 = SystemSetup:GameGetData();
	SystemSetup:SaveGameSetup ( n1,n2,n3,n4,n5,n6,n7,1,n9,tonumber(f10),n11,n12,1,n14,0 );
end

--===============================================
-- OnLoad()
--===============================================
function GameSetup_OnLoad()
	GameSetup_ChatBkg_Slider:SetProperty( "DocumentSize","1" );
	GameSetup_ChatBkg_Slider:SetProperty( "PageSize","0.1" );
	GameSetup_ChatBkg_Slider:SetProperty( "StepSize","0.1" );
end

--===============================================
-- OnEvent()
--===============================================
function GameSetup_OnEvent(event)
	
	if ( event == "TOGLE_GAMESETUP" ) then
		this:Show();
		local old = {SystemSetup:GameGetData()};
		g_PreAlpha = tostring(old[10]);
		GameSetup_UpdateFrame();

	elseif(event == "TOGLE_VIEWSETUP" and this:IsVisible()) then
		GameSetup_Cancel_Clicked();

	elseif(event == "TOGLE_SYSTEMFRAME" and this:IsVisible()) then
		GameSetup_Cancel_Clicked();

	elseif(event == "TOGLE_SOUNDSETUP" and this:IsVisible()) then
		GameSetup_Cancel_Clicked();
	elseif(event == "PLAYER_ENTERING_WORLD" ) then
		GameSetup_NewMenu:SetCheck(1)
		GameSetup_AutoFollow:SetCheck(1)
		GameSetup_CoolDown:SetCheck(1)
		--�Զ������ʼд��
		GameSetup_GameSetup_AutoFollow()
		--�Ϸ��¿����
		GameSetup_GameSetup_NewMenu()
		--���ܵ���ʱ
		GameSetup_GameSetup_CoolDown()
	end

end


--===============================================
-- UpdateFrame()
--===============================================
function GameSetup_UpdateFrame()

	local n1,n2,n3,n4,n5,n6,n7,n8,n9,f10,n11,n12,n13,n14,n15 = SystemSetup:GameGetData();
	
	GameSetup_Item1						:SetCheck(n1);					-- �ܾ������ż�
	GameSetup_Item2						:SetCheck(n2);					-- �ܾ����Һ���
	GameSetup_Item3						:SetCheck(n3);					-- �ܾ�Ĭ�����ż�
	GameSetup_Item4						:SetCheck(n4);					-- �ܾ�����
	GameSetup_Item5						:SetCheck(n5);					-- �ܾ���������
	GameSetup_Item6						:SetCheck(n6);					-- �رյ�ǰ���ݿ�
	GameSetup_Item7						:SetCheck(n7);					-- �ܾ��鿴��ż
	GameSetup_Item8						:SetCheck(n8);					-- ��ɫ��ʾñ��
	GameSetup_Item9						:SetCheck(n9);					-- ������ģʽ
	GameSetup_ChatBkg_Slider	:SetPosition(f10);			-- ���챳��͸����
	GameSetup_Item11					:SetCheck(n11);					-- �رտ������ʾ
	GameSetup_Lock						:SetCheck(n12);					-- ���������
	GameSetup_Scene						:SetCheck(n13);					-- �����л�����
	GameSetup_ChatItem				:SetCheck(n15);					-- ��ݼ��鿴����

end

--===============================================
-- GameSetup_Accept
-- ȷ��
--===============================================
function GameSetup_Accept_Clicked()

	local n1,n2,n3,n4,n5,n6,n7,n8,n9,f10,n11,n12,n13,n14,n15 = SystemSetup:GameGetData();

	n1 = GameSetup_Item1:GetCheck();									-- �ܾ������ż�
	n2 = GameSetup_Item2:GetCheck();                  -- �ܾ����Һ���       
	n3 = GameSetup_Item3:GetCheck();                  -- �ܾ�Ĭ�����ż�     
	n4 = GameSetup_Item4:GetCheck();                  -- �ܾ�����           
	n5 = GameSetup_Item5:GetCheck();                  -- �ܾ���������       
	n6 = GameSetup_Item6:GetCheck();                  -- �رյ�ǰ���ݿ�     
	n7 = GameSetup_Item7:GetCheck();                  -- �ܾ��鿴��ż       
	n8 = GameSetup_Item8:GetCheck();                  -- ��ɫ��ʾñ��       
	n9 = GameSetup_Item9:GetCheck();                  -- ������ģʽ
	f10 = GameSetup_ChatBkg_Slider:GetPosition();     -- ���챳��͸����
	n11 = GameSetup_Item11:GetCheck();                -- �رտ������ʾ  
	n12 = GameSetup_Lock:GetCheck();                  -- ���������         
	n13 = GameSetup_Scene:GetCheck();                 -- �����л�����       
	n15 = GameSetup_ChatItem:GetCheck();              -- ��ݼ��鿴����
	SystemSetup:SaveGameSetup ( n1,n2,n3,n4,n5,n6,n7,n8,n9,tonumber(f10),n11,n12,n13,n14,n15 );
	g_PreAlpha = f10;
	this:Hide();
end

function GameSetup_GameSetup_Replacement()
	local nBit = GameSetup_ACME:GetCheck()
	LuaFnModelReplacement(nBit)		
end

function GameSetup_GameSetup_AutoFollow()
	SetGameMissionData("MD_AUTOFOLLOW",GameSetup_AutoFollow:GetCheck())
end

function GameSetup_GameSetup_NewMenu()
	g_NewNewMenu = GameSetup_NewMenu:GetCheck()
	if g_NewNewMenu == 0 then
		--֪ͨ�ر�
		PushEvent("UI_COMMAND",202209231)
	else
		--֪ͨ����
		PushEvent("UI_COMMAND",202209232)
	end
end

function GameSetup_GameSetup_CoolDown()
	Lua_SetShowCoolDownTime(GameSetup_CoolDown:GetCheck())
end
--===============================================
-- GameSetup_Cancel
-- ȡ��
--===============================================
function GameSetup_Cancel_Clicked()

	GameSetup_ChatBkg_Slider:SetPosition(g_PreAlpha);
	Talk:HandleMainBarAction("chatbkg",g_PreAlpha);
	this:Hide();

end

--===============================================
-- GameSetup_DefaultSetting
-- �ָ�Ĭ��
--===============================================
function GameSetup_Default_Clicked()

	GameSetup_Item1						:SetCheck(0);							-- �ܾ������ż�
	GameSetup_Item2						:SetCheck(0);             -- �ܾ����Һ���
	GameSetup_Item3						:SetCheck(0);             -- �ܾ�Ĭ�����ż�
	GameSetup_Item4						:SetCheck(0);             -- �ܾ�����
	GameSetup_Item5						:SetCheck(0);             -- �ܾ���������
	GameSetup_Item6						:SetCheck(0);             -- �رյ�ǰ���ݿ�
	GameSetup_Item7						:SetCheck(0);             -- �ܾ��鿴��ż
	GameSetup_Item8						:SetCheck(0);             -- ��ɫ��ʾñ��
	GameSetup_Item9						:SetCheck(0);             -- ������ģʽ
	GameSetup_ChatBkg_Slider	:SetPosition(1);       		-- ���챳��͸����
	GameSetup_Item11					:SetCheck(1);							-- �رտ������ʾ
	GameSetup_Lock						:SetCheck(0);             -- ���������
	GameSetup_Scene						:SetCheck(1);             -- �����л�����
	GameSetup_ChatItem				:SetCheck(0);             -- ��ݼ��鿴����

end

--===============================================
-- GameSetup_ChatBkg_Slider
-- �������챳��͸����
--===============================================
function GameSetup_ChatBkg_Change()
	local pos = GameSetup_ChatBkg_Slider:GetPosition();

	Talk:HandleMainBarAction("chatbkg",pos);
end