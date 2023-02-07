--˵���������lua��ͷ��ֻ���������������ҵ���Ϣ��ֱ����
--      ��ҵĽ�����ֱ�ӵ���Ҫ��ȷ�϶Ի�������

--1��ϵͳ��ʾ
--2�����˼���
--3����Ա����ĳ�˼���������㣨�ӳ���ͬ��
--4���ӳ����������Ӹ���ģʽ


g_InitiativeClose = 0;

local g_FrameInfo
local STALL_RENT_FRAME			= 1;
local DISCARD_ITEM_FRAME		= 2;
local CANNT_DISCARD_ITEM		= 3;
local TEAM_ASKJOIN					= 4;	--����������������
local TEAM_MEMBERINVERT			= 5;	--��Ա����ĳ�˼������������ͬ��
local TEAM_SOMEASK					= 6;	--ĳ������������
local TEAM_FOLLOW		 				= 7;	--������Ӹ���ģʽ
local FRAME_AFFIRM_SHOW 		= 8;	--�����������ȷ��ģʽ
local GUILD_CREATE_CONFIRM	= 9; 	--��ᴴ��ȷ��ģʽ
local SYSTEM_TIP_INFO 			= 10; --ϵͳ��ʾ�Ի���ģʽ
local GUILD_QUIT_CONFIRM 		= 11; --����˳�ȷ��ģʽ
local GUILD_DESTORY_CONFIRM = 12; --���ɾ��ȷ��ģʽ
local CALL_OF								= 13;	--����
local INVITE_RIDE						= 14;  --����˫��
local Quest_Number;

--===============================================
-- OnLoad()
--===============================================
function MessageBox_Other_PreLoad()

	this:RegisterEvent("OPEN_SYSTEM_TIP_INFO_DLG");
	--this:RegisterEvent("OPEN_CALLOF_PLAYER");
		
	-- ����������������
	this:RegisterEvent("SHOW_TEAM_YES_NO");
	-- ��Ա����ĳ�˼����������ͬ��.
	--this:RegisterEvent("TEAM_MEMBER_INVITE");
	-- ĳ������������.
	this:RegisterEvent("TEAM_APPLY");
	-- �ӳ����������Ӹ���ģʽ
	this:RegisterEvent("TEAM_FOLLOW_INVITE");
	
	this:RegisterEvent("RECIVE_RIDE");
end

function MessageBox_Other_OnLoad()
	-- �����м�İ�ť
	MessageBox_Other_Info_Button:Hide();
		
end

--===============================================
-- OnEvent()
--===============================================
function MessageBox_Other_OnEvent(event)

	-- ����������������
	if ( event == "SHOW_TEAM_YES_NO" ) then

		g_FrameInfo = TEAM_ASKJOIN;
		MessageBox_Other_Text:SetText(arg0.."������������");
		this:Show();
		MessageBox_Other_Show_single_Info( 0 );
		g_InitiativeClose = 0;

	-- ��Ա����ĳ�˼����������ͬ��
	elseif ( event == "TEAM_MEMBER_INVITE" ) then

		g_FrameInfo = TEAM_MEMBERINVERT;
		MessageBox_Other_Text:SetText(arg0.."����" .. arg1 .. "�������, ͬ����?");
		this:Show();
		MessageBox_Other_Show_single_Info( 0 );
		g_InitiativeClose = 0;

	-- ĳ������������
	elseif ( event == "TEAM_APPLY" ) then

		g_FrameInfo = TEAM_SOMEASK;
		MessageBox_Other_Text:SetText(arg0.."����������, ͬ����?");
		this:Show();
		MessageBox_Other_Show_single_Info( 0 );
		g_InitiativeClose = 0;

	-- �ӳ����������Ӹ���ģʽ
	elseif ( event == "TEAM_FOLLOW_INVITE" ) then
		if GetGameMissionData("MD_AUTOFOLLOW") == 1 then
			Player:SendAgreeTeamFollow();
			return
		end
		g_FrameInfo = TEAM_FOLLOW;
		AxTrace( 0, 0, "�ӳ����������Ӹ���ģʽ" );
		MessageBox_Other_Text:SetText(arg0.."ϣ����������, ͬ����?");
		this:Show();
		MessageBox_Other_Show_single_Info( 0 );
		g_InitiativeClose = 0;

	-- ��ʾϵͳ��Ϣ��
	elseif( event == "OPEN_SYSTEM_TIP_INFO_DLG" ) then
	
		-- ��ʾϵͳ��Ϣ��
		MessageBox_Other_Show_single_Info(1);
		MessageBox_Other_Text:SetText(tostring(arg0));
		this:Show();
		
	elseif( event == "OPEN_CALLOF_PLAYER" )   then 
		g_FrameInfo = CALL_OF;
		local szName = arg0;
		
		MessageBox_Other_Text:SetText(szName .. "���㣬ͬ�ⲻ��");
		this:Show();
		MessageBox_Other_Show_single_Info( 0 );
		g_InitiativeClose = 0;
	elseif( event == "RECIVE_RIDE" ) then
		g_FrameInfo = INVITE_RIDE;
		local szName = arg0;
		MessageBox_Other_Text:SetText(szName .. "������ͬ��");	
		this:Show();
		MessageBox_Other_Show_single_Info( 0 );
		g_InitiativeClose = 0;
	end
	
	MessageBox_Other_UpdateFrame();

end

--===============================================
-- UpdateFrame
--===============================================
function MessageBox_Other_UpdateFrame()
	
	local nWidth, nHeight = MessageBox_Other_Text:GetWindowSize();
	local nTitleHeight = 36;
	local nBottomHeight = 75;
	nWindowHeight = nTitleHeight + nBottomHeight + nHeight;
	MessageBox_Other_Frame:SetProperty( "AbsoluteHeight", tostring( nWindowHeight ) );
end

--===============================================
-- ���ȷ����IDOK��
--===============================================
function MessageBox_Other_OK_Clicked()
	
	if(g_FrameInfo == TEAM_ASKJOIN) then
		--0 ����������������
		Player:AgreeJoinTeam();
		g_InitiativeClose = 1;
		this:Hide();

	elseif(g_FrameInfo == TEAM_MEMBERINVERT) then
		--1 ĳ������������
		Player:SendAgreeJoinTeam_TeamMemberInvite();
		g_InitiativeClose = 1;
		this:Hide();

	elseif(g_FrameInfo == TEAM_SOMEASK) then
		--��������������
		Player:SendAgreeJoinTeam_Apply();
		g_InitiativeClose = 1;
		this:Hide(); 

	elseif(g_FrameInfo == TEAM_FOLLOW) then
		--�ӳ����������Ӹ���ģʽ
		Player:SendAgreeTeamFollow();
		g_InitiativeClose = 1;
		this:Hide();

	elseif(g_FrameInfo == CALL_OF)  then
		Friend:CallOf("ok");
		this:Hide();
	elseif( g_FrameInfo == INVITE_RIDE ) then
		AcceptRide(1);
		this:Hide();
	end
	
	this:Hide();
	g_FrameInfo = 0;
end

--===============================================
-- ������̯(IDCONCEL)
--===============================================
function MessageBox_Other_Cancel_Clicked()
	
	-- ������Ϣ��ť2006��3��27
	MessageBox_Other_Show_single_Info(0);
	
	if(g_InitiativeClose == 1)  then
		return;
	end

	if ( g_FrameInfo == TEAM_ASKJOIN ) then 
		--֪ͨ�������
		Player:RejectJoinTeam();

	elseif ( g_FrameInfo == TEAM_MEMBERINVERT ) then 
		--��������������������
		Player:SendRejectJoinTeam_TeamMemberInvite();

	elseif ( g_FrameInfo == TEAM_SOMEASK ) then 
		--��������������
		Player:SendRejectJoinTeam_Apply();

	elseif ( g_FrameInfo == TEAM_FOLLOW ) then 
		--�ӳ����������Ӹ���ģʽ
		Player:SendRefuseTeamFollow();
		
	elseif(g_FrameInfo == CALL_OF)  then
		Friend:CallOf("cancel");
	
	elseif( g_FrameInfo == INVITE_RIDE ) then
		AcceptRide(0);
		this:Hide();
	
	end
	

	this:Hide();
	g_FrameInfo = 0;
	
end



--------------------------------------------------------------------------------------------------------
--
-- ��һ��ʾ��Ϣ
--
function MessageBox_Other_Info_Clicked()

	-- �ر���Ϣ�Ի���
	MessageBox_Other_Show_single_Info(0);
	this:Hide();
end


function MessageBox_Other_Show_single_Info(bShow)

	if(1 == bShow) then
		MessageBox_Other_OK_Button:SetText( "ȷ��" );
		MessageBox_Other_Cancel_Button:SetText( "ȡ��" );
		MessageBox_Other_OK_Button:Hide();
		MessageBox_Other_Info_Button:Show();
		MessageBox_Other_Cancel_Button:Hide();
		
	elseif(0 == bShow) then
		MessageBox_Other_OK_Button:SetText( "ͬ��" );
		MessageBox_Other_Cancel_Button:SetText( "�ܾ�" );
		MessageBox_Other_OK_Button:Show();
		MessageBox_Other_Info_Button:Hide();
		MessageBox_Other_Cancel_Button:Show();
	end;


end;
