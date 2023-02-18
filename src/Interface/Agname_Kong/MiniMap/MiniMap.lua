local g_CurMap = "Minimap";
local TimeDot = {}
local strNetDelayMessage = nil

local g_myAsk = 0;

--OnLoad
--  0 Animy
--  1 ExpNPC
--  2 Teamate
--  3 OtherPlayer
--  4 ExpObj
function MiniMap_PreLoad()

	
	this:RegisterEvent("SCENE_TRANSED");
	this:RegisterEvent("UPDATE_MAP");
	this:RegisterEvent("OPEN_MINIMAP" );
	this:RegisterEvent("ACCELERATE_KEYSEND");
	this:RegisterEvent("UPDATE_NETSTATUS");
	this:RegisterEvent("PKMODE_CHANGE");
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("SHOW_NEEDREPAIR")
	this:RegisterEvent("LEFTPROTECTTIME_CHANGE")

	this:RegisterEvent("OPEN_MINIMAPEXP");

	this:RegisterEvent("FLAH_MINIMAP");
	
	this:RegisterEvent("STOP_FLAH_MINIMAP");
	
	--add by fangyuan
		this:RegisterEvent("SHOW_ACCOUNT_SAFE_ICON");

	this:RegisterEvent("SHOW_SHIMINGRENZHENG_ANIMATA");

	this:RegisterEvent("MINIMAP_SHOW_SHIMINGRENZHENG_BTN");

	this:RegisterEvent("PLAYERASK_INGAME");

	this:RegisterEvent("MINMAP_PLAYERLIST_SHOW");

	this:RegisterEvent("UPDATE_SKY_TIME");

	this:RegisterEvent("SHOW_BUGFBBTN");
end

function MiniMap_PK_Mode_Show_Menu_Func()
	
	 Player:PVP_ShowMenu();
end;

function MiniMap_OnLoad()
	TimeDot[1] = MiniMap_TimeDot1
	TimeDot[2] = MiniMap_TimeDot2
	TimeDot[3] = MiniMap_TimeDot3
	TimeDot[4] = MiniMap_TimeDot4
	TimeDot[5] = MiniMap_TimeDot5
	TimeDot[6] = MiniMap_TimeDot6
	TimeDot[7] = MiniMap_TimeDot7
	TimeDot[8] = MiniMap_TimeDot8
	TimeDot[9] = MiniMap_TimeDot9
	TimeDot[10] = MiniMap_TimeDot10
	TimeDot[11] = MiniMap_TimeDot11
	TimeDot[12] = MiniMap_TimeDot12
	MiniMap_EquipEndurance:Hide();
	AxTrace(12,12,"MiniMap_OnLoad is called begin");
	MiniMap_AccountSafeBack:Hide();
	
	Minimap_Max();
	MiniMap_Yuanbao:SetToolTip("Ԫ���̵�");
	MiniMap_AutoSearch:SetToolTip("#{INTERFACE_XML_983}");
	MiniMap_NetStatus_Flash:Play( false );

	MiniMap_Fangchengmi_Btn	: Hide()
	MiniMap_Fangchengmi_Flash : Hide();
end
function MiniMap_UpdateSceneName()
	local scenename;
	scenename = GetCurrentSceneName();
	local len = string.len(scenename);
	if( len < 10 ) then	
		MiniMap_Placename:SetProperty( "Font", "YouYuan9.75" );
	else
		MiniMap_Placename:SetProperty( "Font", "SongTiBmp12" );
	end
	MiniMap_Placename:SetText("#gFF0FA0".. scenename );
end

function MiniMap_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == 1238 ) then
			local sceneId = Get_XParam_INT(0)
			return
	end
	
	if ( event == "SCENE_TRANSED" ) then
		MiniMap_Update( arg0 );
		MiniMap_UpdateSceneName();
		UpdateMinimapState();

	elseif ( event == "UPDATE_MAP" ) then
		if( tonumber( arg0 ) == 1 ) then
			MiniMap_UpdateSceneName();
		end
		MiniMap_PosModify();
		Minimap_CoordinateUpdate();
	elseif( event == "OPEN_MINIMAP" ) then
		Variable:SetVariable( "MinimapState","mini", 1 );
		UpdateMinimapState();	
	elseif( event == "ACCELERATE_KEYSEND" ) then
		MiniMap_HandleAccKey(arg0);
	elseif( event =="UPDATE_NETSTATUS") then
	  local strNetState = ""
	  local strOnlineTime = ""
		if tonumber(arg0) < 250 then
			MiniMap_MiniMap_NetStatus : SetProperty("SetCurrentImage","NetState1")
			strNetState = "����ɲ鿴���ջ�б�#r����״��:����".."("..tostring(arg0).."ms)"
		elseif tonumber(arg0) < 500 then
			MiniMap_MiniMap_NetStatus : SetProperty("SetCurrentImage","NetState2")
			strNetState = "����ɲ鿴���ջ�б�#r����״��:����".."("..tostring(arg0).."ms)"
		elseif tonumber(arg0) < 2000 then
			MiniMap_MiniMap_NetStatus : SetProperty("SetCurrentImage","NetState3")
			strNetState = "����ɲ鿴���ջ�б�#r����״��:ӵ��".."("..tostring(arg0).."ms)"
		elseif tonumber(arg0) < 3000 then
		    MiniMap_MiniMap_NetStatus : SetProperty("SetCurrentImage","NetState4")
			strNetState = "����ɲ鿴���ջ�б�#r����״��:����".."("..tostring(arg0).."ms)"
		else
			MiniMap_MiniMap_NetStatus : SetProperty("SetCurrentImage","NetState4")
			strNetState = "����ɲ鿴���ջ�б�#r����״��:����(����3000ms)"
		end
		
		local nFatigueState = tonumber( arg1 )
		local IsNeedFatigue = tonumber( arg2 );
		local OnlineTime = tonumber( arg3 ) 
		local strOnlineState = "(����)"
		
		if( IsNeedFatigue == 1 ) then --�����Ҫ���������
			if( nFatigueState == 1 ) then
				strOnlineState = "(ƣ��)"
			elseif( nFatigueState == 2 ) then
				strOnlineState = "(������)"
			end
			strOnlineTime = "#r�ۼ�����ʱ��:"..tostring( OnlineTime ).."Сʱ"..strOnlineState
		else
			strOnlineState = "";
		end

		strNetDelayMessage = strNetState .. strOnlineTime
		MiniMap_MiniMap_NetStatus : SetToolTip( strNetDelayMessage )
	elseif( event =="SHOW_NEEDREPAIR") then
		if tonumber(arg0) == 1 then
			MiniMap_EquipEndurance:Show();
			MiniMap_EquipEndurance:SetToolTip("#{ZBXL_081009_01}");
		else
			MiniMap_EquipEndurance:Hide();
		end;
		
	elseif( event == "PKMODE_CHANGE" ) then
		Minimap_UpdatePKMode();
	elseif(event == "LEFTPROTECTTIME_CHANGE")then
		
		local DT = math.floor( tonumber(arg0)/1000);
		if(DT>0)then
			MiniMap_SafeTime_Frame:Show();
			MiniMap_SafeTimeAnimate:Show();
			MiniMap_SafeTime_StopWatch:SetProperty("Timer",tostring(DT));
		else
			MiniMap_SafeTime_Frame:Hide();
			MiniMap_SafeTimeAnimate:Hide();
			CloseFangDaohao();--�ر����Ʊ�����ʾ����
		end
	elseif( event == "OPEN_MINIMAPEXP" ) then
		MiniMap_UpdateLockFlag();
	elseif( event == "FLAH_MINIMAP" ) then
		MiniMap_FlashHuodong();
	elseif( event == "STOP_FLAH_MINIMAP" ) then
		MiniMap_StopFlashHuodong();	
	elseif( event == "SHOW_ACCOUNT_SAFE_ICON") then
		MiniMap_AccountSafeBack:Show();
		MiniMap_AccountSafe:SetProperty( "SetCurrentImage","red" );
		MiniMap_AccountSafeState:SetProperty( "SetCurrentImage","SafeIcon" );
		SetTimer("MiniMap","MiniMap_TimerProc()",60000);		--���ö�ʱ��һ���Ӻ�رմ���
		MiniMap_AccountSafeFlash : Show();		--ȷ������˸
	elseif event == "UPDATE_SKY_TIME" then
		local skyTime = tonumber(arg0)
		local skyHour = math.floor(skyTime / 3600)
		local skyMinute = math.floor(math.mod(skyTime, 3600) / 60)
		local skySecond = math.mod(skyTime, 60)
		local skyTimeString = "��ǰʱ��: "
		if skyHour < 10 then
			skyTimeString = skyTimeString .. "0"
		end
		skyTimeString = skyTimeString .. tostring(skyHour) .. ":"
		if skyMinute < 10 then
			skyTimeString = skyTimeString .. "0"
		end
		skyTimeString = skyTimeString .. tostring(skyMinute) .. ":"
		if skySecond < 10 then
			skyTimeString = skyTimeString .. "0"
		end
		skyTimeString = skyTimeString .. tostring(skySecond)
		if strNetDelayMessage ~= nil then
			MiniMap_MiniMap_NetStatus:SetToolTip(strNetDelayMessage .. "#r" .. skyTimeString)
		else
			MiniMap_MiniMap_NetStatus:SetToolTip(skyTimeString)
		end
	end

	if( event == "SHOW_SHIMINGRENZHENG_ANIMATA" ) then
		if((not this:IsVisible())) then
			return;
		end

		if(tonumber(arg0) == 1)then
		  if(Variable:GetVariable("System_CodePage") ~= "1258") then
				MiniMap_Fangchengmi_Flash : Show();
				MiniMap_Fangchengmi_Btn :SetToolTip("#{FCMX_90609_2}");
			end
			MiniMap_Fangchengmi_Flash1 : Hide()
			MiniMap_Fangchengmi_Flash1 :SetProperty( "AlwaysOnTop","False" );
			MiniMap_Fangchengmi_Flash : SetProperty( "AlwaysOnTop","True" );
		elseif(tonumber(arg0) == 2)then
		  if(Variable:GetVariable("System_CodePage") ~= "1258") then
				MiniMap_Fangchengmi_Flash1 : Show();
				MiniMap_Fangchengmi_Btn :SetToolTip("#{FCMX_90609_3}");
			end
			MiniMap_Fangchengmi_Flash : Hide();
			MiniMap_Fangchengmi_Flash :SetProperty( "AlwaysOnTop","False" );
			MiniMap_Fangchengmi_Flash1 : SetProperty( "AlwaysOnTop","True" );
		else
			MiniMap_Fangchengmi_Btn :SetToolTip("#{FCMX_90609_1}");
			MiniMap_Fangchengmi_Flash1 : Hide();
			MiniMap_Fangchengmi_Flash : Hide();	
		end
	end
	if( event == "MINIMAP_SHOW_SHIMINGRENZHENG_BTN" ) then
		if(not this:IsVisible() ) then
			return;
		end
		if(tonumber(arg0) == 1)then
		  if(Variable:GetVariable("System_CodePage") ~= "1258") then
				MiniMap_Fangchengmi_Btn : Show();
			end
		else
			MiniMap_Fangchengmi_Btn : Hide();
		end
	end

	if (event == "PLAYERASK_INGAME" )  then
		MiniMap_SuperHelp2:Hide();
		MiniMap_PlayerAsk_Bn:Show();
		MiniMap_PlayerAsk:Show();
		g_myAsk = tonumber(arg0)
	end

	if (event == "MINMAP_PLAYERLIST_SHOW") then
		MiniMap_LiebiaoFunc();
	end

	if (event == "SHOW_BUGFBBTN") then
		if(tonumber(arg0) == 1) then
			MiniMap_BugUpdate:Show();
		elseif(tonumber(arg0) == 0) then
			MiniMap_BugUpdate:Hide();
		end
	end

end

function MiniMap_TimerProc()
	KillTimer("MiniMap_TimerProc()");		--�رն�ʱ��
	--MiniMap_AccountSafeBack:Hide();
	MiniMap_AccountSafeFlash :Hide();

end

function MiniMap_FlashHuodong()
	--AxTrace( 8,3,"init minimap" );
	MiniMap_NetStatus_Flash:Play( true );
end

function MiniMap_StopFlashHuodong()
	MiniMap_NetStatus_Flash:Play( false );
end

function MiniMap_UpdateLockFlag()
	local level = Player:GetData( "LEVEL" );
	if( Player:IsHavePassword() == nil ) then
		return
	elseif( Player:IsHavePassword() == 0 ) then --�����û�������أ�����˸
		MiniMap_SafeLock:SetProperty( "SetCurrentImage","red" );
		MiniMap_SafeLockState:SetProperty( "SetCurrentImage","Unlock" );
		MiniMap_SafeLockFlash:Show();
	else
		MiniMap_SafeLock:SetProperty( "SetCurrentImage","green" );
		MiniMap_SafeLockFlash:Hide();
	
		--û����������ʾ����������ͼƬ
		if ( Player:IsLocked() == nil ) then
			return
		elseif ( Player:IsLocked() == 0 ) then
			MiniMap_SafeLockState:SetProperty( "SetCurrentImage","Lock" );
		else 
			MiniMap_SafeLockState:SetProperty( "SetCurrentImage","Unlock" );
		end
	end
	--���ӿ���
	if( tonumber( level ) <= 15 ) then
		MiniMap_SafeLock:SetProperty( "SetCurrentImage","gray" );
		MiniMap_SafeLockState:SetProperty( "SetCurrentImage","Unlock" );
		MiniMap_SafeLockFlash:Hide();
	end
	
	if( tonumber( IsInStall() ) == 1 ) then
		MiniMap_SafeLock:SetProperty( "SetCurrentImage","gray" );
		MiniMap_SafeLockFlash:Hide();
	end
end


function Minimap_UpdatePKMode()
	local nPKMode = Player:GetPKMode();
	if( tonumber( nPKMode ) == 0 ) then
		MiniMap_PK_Mode:SetProperty( "SetCurrentImage", "Peace" );
	else
		MiniMap_PK_Mode:SetProperty( "SetCurrentImage", "War" );
	end
	
	local strPKMode = ""
	if( tonumber( nPKMode ) == 0 ) then
		--MiniMap_PK_Mode:SetToolTip( "��ƽ" );
		strPKMode = "��ƽ\n��ģʽ��ֻ�ܷ��������Լ�����ң�������������������ҡ�"
	elseif( tonumber( nPKMode ) == 1 ) then
		--MiniMap_PK_Mode:SetToolTip( "PK_FREE_FOR_ALL" );
		strPKMode = "���˻�ս"
		
	elseif( tonumber( nPKMode ) == 2 ) then
		--MiniMap_PK_Mode:SetToolTip( "PK_FREE_FOR_MORAL" );
		strPKMode = "�ƶ�ģʽ\n��ģʽ�¿��Թ���ɱ������0����ҡ�"
		
	elseif( tonumber( nPKMode ) == 3 ) then
		--MiniMap_PK_Mode:SetToolTip( "PK_FREE_FOR_TEAM" );
		strPKMode = "��ӻ�ս"
		
	elseif( tonumber( nPKMode ) == 4 ) then
		--MiniMap_PK_Mode:SetToolTip( "PK_FREE_FOR_GUILD" );
		strPKMode = "����ͬ�˻�ս"
		
	elseif( tonumber( nPKMode ) == 5 ) then
		strPKMode = "#{TDGZ_XML_19}"
	end
	
	local strTime = ""
	local iTime = Player:GetTimeToPeace()

	if( -1 ~= iTime ) then
	    iTime = math.floor( iTime / 1000 )
	    local iSec = math.mod( iTime, 60 )
	    local iMin = math.floor( iTime / 60 )
	    
	    --strTime = "#r("..( tonumber(iTime) ).."����л�����ƽ���ƶ�ģʽ)"
	    if( iMin > 0 ) then
	        strTime = "#r"..(iMin).."��"..( tonumber(iSec) ).."����л�����ƽ���ƶ�ģʽ"
	    else
	        strTime = "#r"..( tonumber(iSec) ).."����л�����ƽ���ƶ�ģʽ"
	    end
	    
	end

	MiniMap_PK_Mode:SetToolTip( strPKMode..strTime )

	
end
			--IMAGE_TYPE_Animy	= 0, // ����
			--IMAGE_TYPE_ExpNpc	= 1, // ����npc
			--IMAGE_TYPE_Team		= 2, // ����
			--IMAGE_TYPE_Player	= 3, // ������
			--IMAGE_TYPE_ExpObj	= 4, // ������
			--IMAGE_TYPE_Active	= 5, // ������
			--IMAGE_TYPE_ScenePos = 6, // ������ת��
			--IMAGE_TYPE_Flash	= 7, // �����
			--IMAGE_TYPE_Pet		= 8, // ����
			--IMAGE_TYPE_Direction = 9,// �����ͷ	
function UpdateMinimapState()
		
		this:Show();
		MiniMap_PosModify();
		Minimap_CoordinateUpdate();
		Minimap_UpdatePKMode();	
end

function MiniMap_Update( filename )
	--AxTrace( 0,0,"init minimap" );
	local sceneX, sceneY;
	sceneX,sceneY = GetSceneSize();
	MiniMap_MapArea:SetSceneFileName( sceneX,sceneY,filename );
	MiniMap_Frame:SetForce();
end

function MiniMap_PosModify()
	if( this:IsVisible() ) then
		MiniMap_MapArea:UpdateFlag();
	end
end

function  MiniMap_OpenMinimapExp()
	
	OpenMinimap( "MinimapExp" );
	this:Hide();
	

end

function Minimap_Max()
	MiniMap_CloseButtons:Show()
	MiniMap_OpenButtons:Hide()
	MiniMap_Background_Frame:Show();
end

function Minimap_Min()
	MiniMap_CloseButtons:Hide()
	MiniMap_OpenButtons:Show()
	MiniMap_Background_Frame:Hide();
end

function Minimap_CoordinateUpdate()

	local coordinatex,coordinatey,direct;
	coordinatex, coordinatey = MiniMap_MapArea:GetMouseScenePos();
	MiniMap_Coordinate:SetText( "#cFDFF73"..tostring( coordinatex ).."  "..tostring( coordinatey ) );

	for i=1,12 do
		TimeDot[i]:Hide()
	end
	local hour = GetCurrentTime() + 1;
	MiniMap_ChineseTime:SetProperty("SetCurrentImage", "Time"..tostring( hour ) );
	--AxTrace( 8,0,"��ǰʱ��"..tostring( hour ) );
	TimeDot[ hour ]:Show();
	
end

function MiniMap_HandleAccKey( op )
	if(op == "acc_zoommap" and this:IsVisible()) then
		MiniMap_OpenMinimapExp();
	elseif(op == "acc_resetcamera") then
		ResetCamera();
	elseif(op == "acc_worldmap") then
		ToggleLargeMap();
	end
end

function Do_OpenAutoSearch()
	OpenAutoSearch();
end

function MiniMap_YuanBaoFunc()
	if (IsWindowShow("XuanShop")) then
		CloseWindow("XuanShop", true);
	else
		ToggleYuanbaoShop()
	end
end

function MiniMap_OpenSafeTimeDlg()
	OpenDlg4ProtectTime();
end

function MiniMap_LockFunc()
	local leader = Player:IsLeader();
  if(leader == 1) then 
  else
		if(Player:InTeamFollowMode()) then
			PushDebugMessage("#{GMAI_Base_Info_Team_Follow_Staus}")
			PushDebugMessage("#{GMAI_Base_Info_Not_Allow_Operate}")
			return
		end
	end

	--AxTrace( 9,0,"IsIdleLogic = "..tostring( IsIdleLogic() ) );
	if( tonumber( IsInStall() ) == 0 ) then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("OnDefaultEvent");
			Set_XSCRIPT_ScriptID(808007);
			Set_XSCRIPT_Parameter(0,808007);
			Set_XSCRIPT_ParamCount(1);
		Send_XSCRIPT();
	end
end

function MiniMap_GotoDirectly()
	local coordinatex,coordinatey;
	coordinatex, coordinatey = MiniMap_MapArea:GetMouseScenePos();
	AutoRunToTarget(coordinatex, coordinatey);
end

function MiniMap_NetStatus_MouseEnter()
end

function MiniMap_NetStatus_MouseLeave()
	
end

function MiniMap_NetStatus_MouseLButtonDown()
	OpenTodayCampaignList();
	MiniMap_NetStatus_Flash:Play( false );
end

function MiniMap_AccountSafeFunc()
	--MiniMap_AccountSafeBack:Hide();
	MiniMap_AccountSafeFlash : Hide();
	OpenWordrefence("AccountSafe");
end

function MiniMap_Fangchengmi_Click()
	OpenFangChenMiInfoDlg();
end

function MiniMap_PlayerAsk_Bn_Clicked()
	local menpai = Player:GetData("MEMPAI");
	local strName = "";
	
	-- �õ���������.
	if(0 == menpai) then
		strName = "����";
		
	elseif(1 == menpai) then
		strName = "����";
		
	elseif(2 == menpai) then
		strName = "ؤ��";
		
	elseif(3 == menpai) then
		strName = "�䵱";
	
	elseif(4 == menpai) then
		strName = "����";
	
	elseif(5 == menpai) then
		strName = "����";
	
	elseif(6 == menpai) then
		strName = "����";
	
	elseif(7 == menpai) then
		strName = "��ɽ";
	
	elseif(8 == menpai) then
		strName = "��ң";
	
	elseif(9 == menpai) then
		strName = "������";

	elseif(10== menpai) then
		strName = "Ľ��";

	end
	
	local urlStr = "cn="..Player:GetData("ACCOUNTNAME")
	urlStr = urlStr.."&v="..Player:GetAccMD5String()
	
	local idWorld = Variable:GetVariable("Login_World")
	if idWorld == nil then
		urlStr = urlStr.."&serverid="
	else
		urlStr = urlStr.."&serverid="..idWorld
	end

	urlStr = urlStr.."&level="..Player:GetData("LEVEL")
	urlStr = urlStr.."&roleName="..Player:GetName()
	urlStr = urlStr.."&clan="..strName
	urlStr = ConvertStringToURLCoding(urlStr)
	GameProduceLogin:OpenURL( GetWeblink("WEB_ACTIVITY_SEARCH")..tostring(g_myAsk)..".jsp?"..urlStr );
	MiniMap_PlayerAsk_Bn:Hide();
	MiniMap_PlayerAsk:Hide();
	MiniMap_SuperHelp2:Show();
end

function MiniMap_LiebiaoFunc()
	Guild:AskGuildNameList();
end

function MiniMap_KeFu()
	local urlStr = GetWeblink("WEB_CHANGYOU_GM");
	urlStr = ConvertStringToURLCoding(urlStr);
	GameProduceLogin:OpenURL( urlStr );

	--��Server������־ͳ������
	local ASKCG_LOG_TYPE = 1;	--CGAskNoteLog��Ϣ��������
	RequestServerNoteLog(ASKCG_LOG_TYPE);
end
--bug����
function MiniMap_BugFeedBack()
	OpenBugFeedBack();
end
