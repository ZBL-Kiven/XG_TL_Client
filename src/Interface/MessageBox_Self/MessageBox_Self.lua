g_InitiativeClose = 0;
local g_currentList = 0;
local g_currentIndex = 0;
-- ��̯������ʾ���ڣ��������з��͸���������ȷ����ʼ��̯����Ϣ
local Recycle_Type = -1;
local Recycle_CurSelectItem = -1
local g_FrameInfo = -1;
local FrameInfoList = {
	STALL_RENT_FRAME			= 1,
	DISCARD_ITEM_FRAME			= 2,
	CANNT_DISCARD_ITEM			= 3,
	TEAM_ASKJOIN				= 4,	--����������������
    TEAM_MEMBERINVERT			= 5,	--��Ա����ĳ�˼������������ͬ��
    TEAM_SOMEASK				= 6,	--ĳ������������
    TEAM_FOLLOW		 			= 7,	--������Ӹ���ģʽ
    FRAME_AFFIRM_SHOW 			= 8,	--�����������ȷ��ģʽ
    GUILD_CREATE_CONFIRM		= 9, 	--��ᴴ��ȷ��ģʽ
    SYSTEM_TIP_INFO 			= 10,	--ϵͳ��ʾ�Ի���ģʽ
    GUILD_QUIT_CONFIRM 			= 11,	--����˳�ȷ��ģʽ
    GUILD_DESTORY_CONFIRM		= 12,	--���ɾ��ȷ��ģʽ
    CALL_OF						= 13,	--����
    NET_CLOSE_MESSAGE			= 14,	--�Ͽ�����
    PET_FREE_CONFIRM			= 15,	--���޷���ȷ��
    CITY_CONFIRM				= 16,	--�������ȷ��
    SAVE_STALL_INFO				= 17,	--�����̯��Ϣ
    PET_SYNC_CONFIRM			= 18,	--���޷�ֳȷ��
    QUIT_GAME					= 19,	--�˳���Ϸ��ȷ��
    EQUIP_ITEM					= 20,	--װ����Ʒ
    YUANBAO_BUY_ITEM		= 21, --Ԫ���̵깺����Ʒȷ��
    CONFIRM_REMOVE_STALL	= 22,--ȷ�ϳ�̲ add by zchw
    PET_PROCREATE_PROMPT			= 23, -- ���޷�ֳ��ʾ zchw

	--���24һ�����ܸģ����˳���ģ���������Chris
	SERVER_CONTROL				= 24,	--Server���Ƶ�������ʾ��
	DELETE_FRIEND_MESSAGE		= 25,	--ȷ��ɾ�����ѵ���ʾ��

    GEM_COMBINED_CONFIRM		= 88,	-- ȷ�ϱ�ʯ�ϳ�
   	ENCHASE_CONFIRM					= 99,	-- ȷ����Ƕ
   	ENCHASE_FOUR_CONFIRM		= 100,	-- add:lby20080527ȷ��4��Ƕ  
   	 	
   	--CARVE_CONFIRM				= 102,	-- ȷ�ϵ���



    PS_RENAME_MESSAGE			= 116,	--��������̵����
    PS_READ_MESSAGE				= 117,	--��������̵���ܣ���棩
    PS_ADD_BASE_MONEY			= 118,	--���뱾��
    PS_ADD_GAIN_MONEY			= 119,	--����ӯ����
    PS_DEC_GAIN_MONEY			= 120,	--ȡ��ӯ����
    PS_ADD_STALL				= 121,	--���ӹ�̨
    PS_DEL_STALL				= 122,	--���ٹ�̨
    PS_INFO_PANCHU				= 123,	--�̵��̳�
    PS_INFO_PANRU				= 124,	--�̵�����
    PS_INFO_MODIFY_TYPE			= 125,	--�����̵�����
    FREEFORALL					= 201,	--FREEFORALL: ���˻�ս
    FREEFORTEAM					= 202,	--FREEFORTEAM�� ��ӻ�ս
    FREEFORGUILD				= 203,	-- FREEFORGUILD�����ɻ�ս
    MAKESUREPVPCHALLENGE		= 204,
    EXCHANGE_MONEY_OVERFLOW			= 205, --���׺���������Ƿ񵽴�Ǯ���޵��ж�

    GUILD_DEMIS_CONFIRM		= 206, 			--����ȷ��

    CHANGEPROTECTTIME		= 207, 				--��ȫʱ��
    COMMISION_BUY = 208, 							--�����̵깺��ȷ��

    Player_Give_Rose		= 209,
    RECYCLE_DEL_ITEM		=210, 				--ȡ���չ�ȷ��

    OPEN_IS_SELL_TO_RECSHOP	= 211, 		--������Ʒȷ��

    CONFIRM_STENGTH = 212,

    CHAR_RANAME_CONFIRM = 213,

    CITY_RANAME_CONFIRM = 214,

    CONFIRM_RE_IDENTIFY = 215,

    KICK_MEMBER_MSGBOX = 216,
    
		SAFEBOX_LOCK_CONFIRM = 217,						--����������ȷ�Ͽ�
		SAFEBOX_UNLOCK_CONFIRM = 218,					--���������ȷ�Ͽ�
		
		LOCK_ITEM_CONFIRM_FRAME = 219,        --	����ȷ��
    GUILD_LEAGUE_QUIT_CONFIRM = 220,			--	�˳����ͬ��ȷ��
    GUILD_LEAGUE_CREATE_CONFIRM = 221,		--	�������ͬ��ȷ��
		PET_SKILL_STUDY_CONFIRM = 222,				--	����ѧϰ����ȷ��
		EXCHANGE_BANGGONG = 223,							--	�һ��ﹱ��ȷ��
		PUT_GUILDMONEY = 224,									--	����ʽ����
		TLZ_CONFIRM_SETPOS = 225,							--	ȷ�����������¶�λ

		DISMISS_TEAM = 226,										--	��ɢ����						WTT		20090212
		SHENGSICHALLENGE = 227,										--	��ս						WTT		20090212
		CSPS_FANGQI = 228,										--	��ս						WTT		20090212
};

local PVPFLAG = { FREEFORALL = 201, FREEFORTEAM = 202, FREEFORGUILD = 203, MAKESUREPVPCHALLENGE = 204, ACCEPTDUEL = 205, DuelGUID = 0, DuelName = "" }
--FREEFORALL: ���˻�ս FREEFORTEAM�� ��ӻ�ս FREEFORGUILD�����ɻ�ս

--
local g_szData;
local g_nData;
local g_nData1
--

local nChallenge_1
local nChallenge_2
local nChallenge_3

local Quest_Number;
local Pet_Number;
local Server_Script_Function = "";
local Server_Script_ID = "";
local Server_Return_1 = 0;
local Server_Return_2 = 0;
local Server_Return_3 = 0;

local g_CityData = {};						--����upvalue�����ƣ����к����޺ϳɹ������������

local strMessageString = "";		--�Ի����ַ�
local strMessageData   = 0;			--�Ի������ͣ�������ʾʲô�öԻ���
local strMessageArgs = 0;				--��ť����
local strMessageType = "Normal";--��ť���
local strMessageArgs_2 = 0			--��ť����2

local GemCombinedData = {}

local EnchaseData = {}

local SplitData = {}

local CarveData = {}

local CommisionBuyData = {}  --�����̵깺��ȷ�Ͽ������

local MAX_OBJ_DISTANCE = 3.0;

local Client_ItemIndex = -1

function CancelLastOp(str)
	if(this:IsVisible() and str ~= g_FrameInfo) then
		MessageBox_Self_Cancel_Clicked(0);
	end
end
--===============================================
-- OnLoad()
--===============================================
function MessageBox_Self_PreLoad()
	--this:RegisterEvent("MSGBOX_ACCEPTDUEL");
	this:RegisterEvent("MSGBOX_MAKESUREPVPCHALLENGE");
    this:RegisterEvent("MENU_SHOWACCEPTCHANGEPVP");
	this:RegisterEvent("OPEN_STALL_RENT_FRAME");
	this:RegisterEvent("OPEN_DISCARD_ITEM_FRAME");
	this:RegisterEvent("OPEN_CANNT_DISCARD_ITEM");
	this:RegisterEvent("AFFIRM_SHOW");
	this:RegisterEvent("NET_CLOSE");
	this:RegisterEvent("DELETE_FRIEND");
	this:RegisterEvent("TIME_UPDATE");
	this:RegisterEvent("PET_PROCREATE_PROMPT"); -- zchw pet procreate

	-- zchw fix Transfer bug
	this:RegisterEvent("OBJECT_CARED_EVENT");
	---- ����������������
	--this:RegisterEvent("SHOW_TEAM_YES_NO");
	---- ��Ա����ĳ�˼����������ͬ��.
	--this:RegisterEvent("TEAM_MEMBER_INVITE");
	---- ĳ������������.
	--this:RegisterEvent("TEAM_APPLY");
	---- �ӳ����������Ӹ���ģʽ
	--this:RegisterEvent("TEAM_FOLLOW_INVITE");

	-- �������ȷ��
	this:RegisterEvent("GUILD_CREATE_CONFIRM");
	-- ɾ�����ȷ��
	this:RegisterEvent("GUILD_DESTORY_CONFIRM");
	-- �˳����ȷ��
	this:RegisterEvent("GUILD_QUIT_CONFIRM");
	this:RegisterEvent("GUILD_LEAGUE_QUIT_CONFIRM");
	this:RegisterEvent("GUILD_LEAGUE_CREATE_CONFIRM");

	this:RegisterEvent("PET_FREE_CONFIRM");

	this:RegisterEvent("OPEN_PS_MESSAGE_FRAME");

	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("CITY_CONFIRM");
	--add by zchw
	this:RegisterEvent("OPEN_REMOVE_STALL");
	this:RegisterEvent("OPEN_SAVE_STALL_INFO");

	this:RegisterEvent("PET_SYNC_CONFIRM");
	this:RegisterEvent("QUEST_QUIT_GAME");

	this:RegisterEvent( "MESSAGE_BOX" );

	this:RegisterEvent( "GEM_COMBINED_CONFIRM" );
	this:RegisterEvent( "ENCHASE_CONFIRM" );  
	this:RegisterEvent( "ENCHASE_FOUR_CONFIRM" );-- add:lby20080527ȷ��4��Ƕ
	
	--this:RegisterEvent( "CARVE_CONFIRM" );
	this:RegisterEvent( "EXCHANGE_MONEY_OVERFLOW" );
	this:RegisterEvent( "GUILD_DEMIS_CONFIRM" );
	this:RegisterEvent("YUANBAO_BUY_ITEM_CONFIRM");

	this:RegisterEvent("CHANGEPROTECTTIME");
	
	this:RegisterEvent("CONFIRM_COMMISION_BUY"); --�����̵깺��ȷ��

	this:RegisterEvent("PLAYER_GIVE_ROSE");

	this:RegisterEvent( "RECYCLE_DEL_ITEM" );

	this:RegisterEvent( "OPEN_IS_SELL_TO_RECSHOP" );

	this:RegisterEvent( "CLOSE_PS_CHANGETYPE_MSG" );

	this:RegisterEvent( "CONFIRM_STENGTH" );

	this:RegisterEvent( "EXCHANGE_BANGGONG" );
		
	this:RegisterEvent( "PUT_GUILDMONEY" );

	this:RegisterEvent( "CLOSE_STRENGTH_MSGBOX" );

	this:RegisterEvent( "CLOSE_RECYCLESHOP_MSG" );

	this:RegisterEvent( "ENCHASE_CLOSE_MSGBOX" );
	
	this:RegisterEvent( "CITY_RANAME_CONFIRM" );

	this:RegisterEvent( "CHAR_RANAME_CONFIRM" );	

	--��logon�򿪵�ʱ�򣬹ر�����MessageBox
	this:RegisterEvent( "GAMELOGIN_OPEN_COUNT_INPUT" );

	this:RegisterEvent( "CONFIRM_RE_IDENTIFY" );

	this:RegisterEvent( "CLOSE_RE_IDENTIFY_MSGBOX" );
	
	this:RegisterEvent( "KICK_MEMBER_MSGBOX" );
	
	this:RegisterEvent( "CLOSE_KICK_MEMBER_MSGBOX" );
	
	--����������ȷ�Ͽ�
	this:RegisterEvent( "SAFEBOX_LOCK_CONFIRM" );

	--���������ȷ�Ͽ�
	this:RegisterEvent( "SAFEBOX_UNLOCK_CONFIRM" );
	
	this:RegisterEvent( "CLOSE_SAFEBOX_CONFIRM" );
	
	--����ȷ��
	this:RegisterEvent( "LOCK_ITEM_CONFIRM" );
	this:RegisterEvent( "OPEN_PETSKILLSTUDY_MSGBOX" );
	this:RegisterEvent( "CLOSE_PETSKILLSTUDY_MSGBOX" );
	--�����鶨λȷ��
	this:RegisterEvent( "CONFIRM_SETPOS_TLZ" );
	
	-- ������ɢ����Ķ���ȷ�ϴ���			add by WTT	20090212
	this:RegisterEvent( "OPNE_DISMISS_TEAM_MSGBOX" );

end

--===============================================
-- OnLoad()
--===============================================
function MessageBox_Self_OnLoad()

end

function  MessageBox_Self_UpdateRect()

	local nWidth, nHeight = MessageBox_Self_Text:GetWindowSize();
	local nTitleHeight = 36;
	local nBottomHeight = 75;
	nWindowHeight = nTitleHeight + nBottomHeight + nHeight;
	MessageBox_Self_Frame:SetProperty( "AbsoluteHeight", tostring( nWindowHeight ) );
end
--===============================================
-- OnEvent()
--===============================================
function MessageBox_Self_OnEventEx(event)

	local objCaredID = -1; -- zchw fix Transfer bug
	if(event == "QUEST_QUIT_GAME") then
		this:Show();
		g_FrameInfo = FrameInfoList.QUIT_GAME;
	-- add by zchw
	elseif event == "OPEN_REMOVE_STALL" then
		CancelLastOp(FrameInfoList.CONFIRM_REMOVE_STALL);
		g_FrameInfo = FrameInfoList.CONFIRM_REMOVE_STALL;
	-- zchw for pet procreate
	elseif event == "PET_PROCREATE_PROMPT" then
		CancelLastOp(FrameInfoList.PET_PROCREATE_PROMPT);
		g_FrameInfo = FrameInfoList.PET_PROCREATE_PROMPT;
	elseif event == "OPEN_SAVE_STALL_INFO"    then
		CancelLastOp(FrameInfoList.SAVE_STALL_INFO);
		g_FrameInfo = FrameInfoList.SAVE_STALL_INFO;
	elseif event == "YUANBAO_BUY_ITEM_CONFIRM" then
		if(arg0 == "close") then
			if(g_FrameInfo == FrameInfoList.YUANBAO_BUY_ITEM and this:IsVisible())then
			--����ǹ��ڹ��ﵯ���Ĵ��ڣ��Źر�
				g_CityData = {};
				this:Hide();
			end
			return -1;
		elseif(arg0 == "open") then
			g_CityData = {};
			g_CityData[1] = tonumber(arg2);	--�ڻ��ܵ�λ��
			g_CityData[2] = tonumber(arg3);	--���̵���ۼ�
			g_CityData[3] = arg1;	--��������
			CancelLastOp(FrameInfoList.YUANBAO_BUY_ITEM);
			g_FrameInfo = FrameInfoList.YUANBAO_BUY_ITEM;
		end
	elseif( event == "PET_SYNC_CONFIRM" ) then
		g_CityData[1] = tonumber(arg0);
		g_CityData[2] = tonumber(arg1);
		CancelLastOp(FrameInfoList.PET_SYNC_CONFIRM);
		g_FrameInfo = FrameInfoList.PET_SYNC_CONFIRM;
	--�����̵깺��ȷ����Ϣ
	elseif event == "CONFIRM_COMMISION_BUY" then
		if(arg0 == "close") then
			if(g_FrameInfo == FrameInfoList.COMMISION_BUY and this:IsVisible())then
			--����Ǽ����̵�ȷ�Ͽ򣬲Źر�
				CommisionBuyData = {};
				this:Hide();
			end
			return -1;
		elseif(arg0 == "open") then
			CommisionBuyData = {};
			CommisionBuyData[1] = arg1;	--��Ʒ����
			CommisionBuyData[2] = arg2;	--�۸�
			CancelLastOp(FrameInfoList.COMMISION_BUY);
			g_FrameInfo = FrameInfoList.COMMISION_BUY;
		end
	elseif event == "TIME_UPDATE" then
		if(this:IsVisible() and g_FrameInfo == FrameInfoList.STALL_RENT_FRAME ) then
			local xNow, yNow;
			xNow, yNow = Player:GetPos();
			
			local askPosX = Variable:GetVariable("AskBaiTanPosX");
			local askPosY = Variable:GetVariable("AskBaiTanPosY");
			
			if(tostring(xNow) ~= askPosX or tostring(yNow) ~= askPosY) then
				MessageBox_Self_Cancel_Clicked(1);
			end
		end

		return -1;
	end
	if g_FrameInfo == FrameInfoList.QUIT_GAME   then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0");
		local msg = "��ȷ��Ҫ�뿪�����˲���Ϸ������";
		MessageBox_Self_Text:SetText(msg);
		MessageBox_Self_UpdateRect();
		this:Show();
	end

	if ( event == "RECYCLE_DEL_ITEM" ) then
		Recycle_Type = tonumber(arg0);
		Recycle_CurSelectItem = tonumber(arg1);
		CancelLastOp(FrameInfoList.RECYCLE_DEL_ITEM);
		g_FrameInfo = FrameInfoList.RECYCLE_DEL_ITEM;
		MessageBox_Self_DragTitle:SetText("#gFF0FA0");
		local msg = "��ȷ��Ҫȡ���˴��չ���";
		MessageBox_Self_Text:SetText(msg);
		MessageBox_Self_UpdateRect();
		this:Show();
	end

	if ( event == "OPEN_IS_SELL_TO_RECSHOP" ) then
		Recycle_Bag_idx = tonumber(arg0);
		Recycle_Shop_idx = tonumber(arg1);
		Recycle_Shop_Num =  tonumber(arg2);
		Recycle_Shop_AllPrice =  tonumber(arg3);
		CancelLastOp(FrameInfoList.OPEN_IS_SELL_TO_RECSHOP);
		g_FrameInfo = FrameInfoList.OPEN_IS_SELL_TO_RECSHOP;
		local name = PlayerShop:GetRecycleItem(Recycle_Shop_idx,3,"name");
		MessageBox_Self_DragTitle:SetText("#gFF0FA0");
		local msg = "#W��Ҫ���۵Ĳ���Ϊ#G"..name.."#W������Ϊ"..Recycle_Shop_Num.."#W,�����ǮΪ#Y#{_MONEY"..Recycle_Shop_AllPrice.."}";
		MessageBox_Self_Text:SetText(msg);
		MessageBox_Self_UpdateRect();
		this:Show();
	end
	if ( event == "CONFIRM_STENGTH" ) then
		Stength_Equip_Idx = tonumber(arg0);
		Stength_Item_Idx = tonumber(arg1);
		CancelLastOp(FrameInfoList.CONFIRM_STENGTH);
		g_FrameInfo = FrameInfoList.CONFIRM_STENGTH;
		MessageBox_Self_DragTitle:SetText("#gFF0FA0");
		local msg = "ǿ��ʱ�����ȿ۳���Ʒ���Ѱ󶨵�ǿ��������ǿ�����װ��Ҳ�������󶨣�ȷ��Ҫ����ǿ����#r��ʾ��������뽫ǿ�����װ���󶨣��뽫�������Ѱ󶨵�ǿ����������ֿ�����ǿ����";
		MessageBox_Self_Text:SetText(msg);
		MessageBox_Self_UpdateRect();
		this:Show();
	end
	
	if ( event == "EXCHANGE_BANGGONG" ) then
		BangGong_Value = tonumber(arg0);
		ObjCaredID = tonumber(arg1); --���ﲻ��Ҫ��ʹ��GetNPCIDByServerID��
		if ObjCaredID ~= -1 then
			--��ʼ����NPC
			this:CareObject(ObjCaredID, 1, "MsgBox");
		end
		local extravalue = math.floor(BangGong_Value*0.1)
		CancelLastOp(FrameInfoList.EXCHANGE_BANGGONG);
		g_FrameInfo = FrameInfoList.EXCHANGE_BANGGONG;
		MessageBox_Self_DragTitle:SetText("#gFF0FA0");
		local msg = "#{BGCH_8922_28}"..BangGong_Value.."#{BGCH_8922_29}"..extravalue.."#{BGCH_8922_30}";
		MessageBox_Self_Text:SetText(msg);
		MessageBox_Self_UpdateRect();
		this:Show();
	end
	
	if ( event == "PUT_GUILDMONEY" ) then
		GuildMoney_Value = tonumber(arg0);
		ObjCaredID = tonumber(arg1); --���ﲻ��Ҫ��ʹ��GetNPCIDByServerID��
		if ObjCaredID ~= -1 then
		--��ʼ����NPC
			this:CareObject(ObjCaredID, 1, "MsgBox");
		end
		local value = math.floor(GuildMoney_Value*0.9)
		CancelLastOp(FrameInfoList.PUT_GUILDMONEY);
		g_FrameInfo = FrameInfoList.PUT_GUILDMONEY;
		MessageBox_Self_DragTitle:SetText("#gFF0FA0");
		local msg = "#{BPZJ_0801014_008}#{_EXCHG"..GuildMoney_Value.."}#{BPZJ_0801014_009}#{_EXCHG"..value.."}#{BPZJ_0801014_013}";
		MessageBox_Self_Text:SetText(msg);
		MessageBox_Self_UpdateRect();
		this:Show();
	end

	if ( event == "CONFIRM_RE_IDENTIFY" ) then
		RID_Equip_Idx = tonumber(arg0);
		--Stength_Item_Idx = tonumber(arg1);
		CancelLastOp(FrameInfoList.CONFIRM_RE_IDENTIFY);
		g_FrameInfo = FrameInfoList.CONFIRM_RE_IDENTIFY;
		MessageBox_Self_DragTitle:SetText("#gFF0FA0");
		local msg = "���¼���װ������ʱ�����ȿ۳���Ʒ�����Ѱ󶨵Ľ��ɰ����ﱣ����¼������ʺ��װ��Ҳ�������󶨣�ȷ��Ҫ����������#r#G��ʾ���������������װ���󶨣��뽫�������Ѱ󶨵Ľ��ɰ�ͽ��ﱷ���ֿ�����������#W";
		MessageBox_Self_Text:SetText(msg);
		MessageBox_Self_UpdateRect();
		this:Show();
	end

	if ( event == "KICK_MEMBER_MSGBOX" ) then
		Member_Idx = tonumber(arg0);
		Member_Name = arg1;
		CancelLastOp(FrameInfoList.KICK_MEMBER_MSGBOX);
		g_FrameInfo = FrameInfoList.KICK_MEMBER_MSGBOX;
		MessageBox_Self_DragTitle:SetText("#gFF0FA0");
		local msg = "��ȷ��Ҫ�����#G"..Member_Name.."#W�����������";
		MessageBox_Self_Text:SetText(msg);
		MessageBox_Self_UpdateRect();
		this:Show();
	end

	
	return 1;
end

--===============================================
-- OnEvent()
--===============================================
function MessageBox_Self_OnEvent(event)
	if event == "GEM_COMBINED_CONFIRM" then
		
		GemCombinedData[1] = tonumber( arg0 )
		GemCombinedData[2] = tonumber( arg1 )
		GemCombinedData[3] = tonumber( arg2 )
		GemCombinedData[4] = tonumber( arg3 )
		GemCombinedData[5] = tonumber( arg4 )
		GemCombinedData[6] = tonumber( arg5 )
		GemCombinedData[7] = arg6
		CancelLastOp(FrameInfoList.GEM_COMBINED_CONFIRM);
		g_FrameInfo = FrameInfoList.GEM_COMBINED_CONFIRM
		MessageBox_Self_UpdateFrame()
		return
	end

	if event == "EXCHANGE_MONEY_OVERFLOW" then
		MessageBox_Self_Text:SetText( "#Y����Ǯ�Ѿ��������ޣ��뾡�촦���ڴ��ڼ䲻Ҫ��#R���߻���ת�Ƴ����Ĳ�����#Y�����ʹ�ó������޵Ľ�Ǯ��ʧ��" );
		
		MessageBox_Self_UpdateRect();
		CancelLastOp(FrameInfoList.EXCHANGE_MONEY_OVERFLOW);
		g_FrameInfo = FrameInfoList.EXCHANGE_MONEY_OVERFLOW
		
		this:Show();
	end
	if event == "GUILD_DEMIS_CONFIRM" then
		local TargetName = tostring( arg0 );
		MessageBox_Self_Text:SetText( "��ȷ��Ҫ��������ְλ���ø�"..TargetName.."���������ְλ��Ϊ��������" );		
		MessageBox_Self_UpdateRect();	
		CancelLastOp(FrameInfoList.GUILD_DEMIS_CONFIRM);
		g_FrameInfo = FrameInfoList.GUILD_DEMIS_CONFIRM
		this:Show();
	end

	if event == "ENCHASE_CONFIRM" then
		MessageBox_Self_Text:SetText( "û��������ϻᵼ����Ƕʧ��֮��ʯ��ʧ����ȷ��Ҫ������Ƕ��" );
		EnchaseData[1] = tonumber( arg0 )
		EnchaseData[2] = tonumber( arg1 )
		EnchaseData[3] = tonumber( arg2 )
		EnchaseData[4] = tonumber( arg3 )
		CancelLastOp(FrameInfoList.ENCHASE_CONFIRM);
		g_FrameInfo = FrameInfoList.ENCHASE_CONFIRM
		this:Show();
	end
	
	if event == "ENCHASE_FOUR_CONFIRM" then  -- add:lby20080527ȷ��4��Ƕ
		MessageBox_Self_Text:SetText( "û��������ϻᵼ����Ƕʧ��֮��ʯ��ʧ����ȷ��Ҫ������Ƕ��" );
		EnchaseData[1] = tonumber( arg0 )
		EnchaseData[2] = tonumber( arg1 )
		EnchaseData[3] = tonumber( arg2 )
		EnchaseData[4] = tonumber( arg3 )
		CancelLastOp(FrameInfoList.ENCHASE_FOUR_CONFIRM);
		g_FrameInfo = FrameInfoList.ENCHASE_FOUR_CONFIRM
		this:Show();
	end

	-- �����޼���ѧϰ�Ķ���ȷ�Ͻ���
	if event == "OPEN_PETSKILLSTUDY_MSGBOX" then
		MessageBox_Self_Text:SetText( "������޼�����������ֶ����ܣ����������Ҫ����#{_EXCHG990000}����ȷ����" );
		CancelLastOp(FrameInfoList.PET_SKILL_STUDY_CONFIRM);
		g_FrameInfo = FrameInfoList.PET_SKILL_STUDY_CONFIRM
		this:Show();
	end
	
	-- �ر����޼���ѧϰ�Ķ���ȷ�Ͻ���
	if(event == "CLOSE_PETSKILLSTUDY_MSGBOX" ) then
		if(this:IsVisible() and  g_FrameInfo == FrameInfoList.PET_SKILL_STUDY_CONFIRM) then
			CancelLastOp(-1);
			this:Hide();
		end
		return;
	end
	
--	if event == "CARVE_CONFIRM" then
--		MessageBox_Self_Text:SetText( "ע�⣡#��Ҫ�����ı�ʯ�������Ϊ�Ѱ���Ʒ��������ı�ʯҲ�������󶨣�ȷ��Ҫ���������Ļ����ٴε��������ť��" );
--		CarveData[1] = tostring( arg0 )
--		CarveData[2] = tonumber( arg1 )
--		CarveData[3] = tonumber( arg2 )
--		CarveData[4] = tonumber( arg3 )
--		CarveData[5] = tonumber( arg4 )
--		CancelLastOp(FrameInfoList.CARVE_CONFIRM);
--		g_FrameInfo = FrameInfoList.CARVE_CONFIRM
--		this:Show();
--	end
	
	if(event == "OPEN_STALL_RENT_FRAME") then
		CancelLastOp(FrameInfoList.STALL_RENT_FRAME);
		--��¼��ǰλ��
		local xPos, yPos;
		xPos, yPos = Player:GetPos();
		Variable:SetVariable("AskBaiTanPosX", tostring(xPos), 1);
		Variable:SetVariable("AskBaiTanPosY", tostring(yPos), 1);
		
		this:Show();
		g_InitiativeClose = 0;
		g_FrameInfo = FrameInfoList.STALL_RENT_FRAME;
		

	elseif ( event == "MSGBOX_MAKESUREPVPCHALLENGE" ) then
	    local TargetName = tostring( arg0 )
	    --AxTrace(0,0,"MSGBOX_MAKESUREPVPCHALLENGE");
		CancelLastOp(FrameInfoList.MAKESUREPVPCHALLENGE);
		g_FrameInfo = FrameInfoList.MAKESUREPVPCHALLENGE;
	    MessageBox_Self_Text:SetText( "��ȷ����"..TargetName.."�����սô��ɱ���Է�֮�����������ɱ��ֵ��ɱ��������������ʱ�ᵼ�¶�����ʧ" );
		MessageBox_Self_UpdateRect();
		this:Show();

	elseif ( event == "MENU_SHOWACCEPTCHANGEPVP" ) then
		local Mode = tonumber( arg0 )
		local ModeText = ""
		if( 1 == Mode ) then
			CancelLastOp(FrameInfoList.FREEFORALL);
		    --AxTrace(0,0,FrameInfoList.FREEFORALL);
		    g_FrameInfo = FrameInfoList.FREEFORALL;
		    ModeText = "��ģʽ�½��ṥ�����Լ�֮���������ң���ȷ�Ͽ���"
		end
		if( 2 == Mode ) then
			CancelLastOp(FrameInfoList.FREEFORTEAM);
		    --AxTrace(0,0,FrameInfoList.FREEFORTEAM);
		    g_FrameInfo = FrameInfoList.FREEFORTEAM;
		    ModeText = "��ģʽ�½��ṥ��������֮���������ң���ȷ�Ͽ���"
		end
		if( 3 == Mode ) then
			CancelLastOp(FrameInfoList.FREEFORGUILD)
		    --AxTrace(0,0,FrameInfoList.FREEFORGUILD);
		    g_FrameInfo = FrameInfoList.FREEFORGUILD;
		    ModeText = "#{TM_20080311_18}"
		end
		if( Mode >= 1 and Mode <= 3 ) then
		    MessageBox_Self_Text:SetText( ModeText );
			MessageBox_Self_UpdateRect();
		    this:Show();
		end

	elseif ( event == "MSGBOX_ACCEPTDUEL" ) then
	    local Name = tostring( arg0 )
	    local GUID = tostring( arg1 )
	    PVPFLAG.DuelName = Name
	    PVPFLAG.DuelGUID = GUID
	    g_FrameInfo = PVPFLAG.ACCEPTDUEL;
	    local MsgText = Name.."����������������Ƿ�ͬ�⣿ע�⣺�ھ��������������гͷ���"
	    MessageBox_Self_Text:SetText( MsgText )
		MessageBox_Self_UpdateRect();
	    this:Show();

	elseif(event == "OPEN_DISCARD_ITEM_FRAME") then
		argDISCARD_ITEM_FRAME0 = arg0;
		CancelLastOp(FrameInfoList.DISCARD_ITEM_FRAME);
		this:Show();
		g_InitiativeClose = 0;
		g_FrameInfo = FrameInfoList.DISCARD_ITEM_FRAME;

	elseif(event == "OPEN_CANNT_DISCARD_ITEM") then
		argCANNT_DISCARD_ITEM0 = arg0
		CancelLastOp(FrameInfoList.CANNT_DISCARD_ITEM);
		this:Show();
		g_InitiativeClose = 0;
		g_FrameInfo = FrameInfoList.CANNT_DISCARD_ITEM;
		
	elseif(event == "LOCK_ITEM_CONFIRM") then
		argLOCK_ITEM_FRAME0 = arg0;
		CancelLastOp(FrameInfoList.LOCK_ITEM_CONFIRM_FRAME);
		this:Show();
		g_InitiativeClose = 0;
		g_FrameInfo = FrameInfoList.LOCK_ITEM_CONFIRM_FRAME;

	elseif(event == "AFFIRM_SHOW") then
		this:Show();
		g_InitiativeClose = 0;
		Quest_Number = tonumber(arg2);
		argFRAME_AFFIRM_SHOW0 = arg0;
		CancelLastOp(FrameInfoList.FRAME_AFFIRM_SHOW);
		g_FrameInfo = FrameInfoList.FRAME_AFFIRM_SHOW;


	-- �����������ȷ��
	elseif ( event == "GUILD_CREATE_CONFIRM" ) then
		argCREATE_CONFIRM0 = arg0
		CancelLastOp(FrameInfoList.GUILD_CREATE_CONFIRM);
		g_FrameInfo = FrameInfoList.GUILD_CREATE_CONFIRM;
		MessageBox_Self_Text:SetText("��Ҫ����" .. argCREATE_CONFIRM0 .. "��?");
		MessageBox_Self_UpdateRect();
		this:Show();

	-- ���ɾ�������ȷ��
	elseif ( event == "GUILD_DESTORY_CONFIRM" ) then
		argDESTORY_CONFIRM0 = arg0
		CancelLastOp(FrameInfoList.GUILD_DESTORY_CONFIRM);
		g_FrameInfo = FrameInfoList.GUILD_DESTORY_CONFIRM;
		MessageBox_Self_Text:SetText("��Ҫɾ��" .. argDESTORY_CONFIRM0 .. "��?");
		MessageBox_Self_UpdateRect();
		this:Show();

	-- ����˳������ȷ��
	elseif ( event == "GUILD_QUIT_CONFIRM" ) then
		argQUIT_CONFIRM0 = arg0
		CancelLastOp(FrameInfoList.GUILD_QUIT_CONFIRM);
		g_FrameInfo = FrameInfoList.GUILD_QUIT_CONFIRM;
		MessageBox_Self_Text:SetText("��Ҫ�˳�" .. argQUIT_CONFIRM0 .. "��?");
		MessageBox_Self_UpdateRect();
		this:Show();
	
	--���ͬ���˳�ȷ��
	elseif event == "GUILD_LEAGUE_QUIT_CONFIRM" then
		argQUIT_LEAGUE_CONFIRM0 = arg0;
		CancelLastOp(FrameInfoList.GUILD_LEAGUE_QUIT_CONFIRM);
		g_FrameInfo = FrameInfoList.GUILD_LEAGUE_QUIT_CONFIRM
		MessageBox_Self_Text:SetText( "��ȷ��Ҫ�˳�"..argQUIT_LEAGUE_CONFIRM0.."ͬ����" );		
		MessageBox_Self_UpdateRect();	
		this:Show();
		
	--���ͬ�˴���ȷ��
	elseif event == "GUILD_LEAGUE_CREATE_CONFIRM" then
		argCREATE_LEAGUE_CONFIRM0 = arg0;
		argCREATE_LEAGUE_CONFIRM1 = arg1;
		CancelLastOp(FrameInfoList.GUILD_LEAGUE_CREATE_CONFIRM);
		g_FrameInfo = FrameInfoList.GUILD_LEAGUE_CREATE_CONFIRM
		MessageBox_Self_Text:SetText( "#{TM_20080331_09}#{_EXCHG1000000}#{TM_20080331_02}" );		
		MessageBox_Self_UpdateRect();	
		this:Show();
		

	-- ����������
	elseif ( event == "NET_CLOSE" ) then
		argNET_CLOSE0 = arg0 
		CancelLastOp(FrameInfoList.NET_CLOSE_MESSAGE);
		g_FrameInfo = FrameInfoList.NET_CLOSE_MESSAGE;
		this:Show();

	elseif ( event == "PET_FREE_CONFIRM") then
		Pet_Number = tonumber(arg0);
		CancelLastOp(FrameInfoList.PET_FREE_CONFIRM);
		g_FrameInfo = FrameInfoList.PET_FREE_CONFIRM;
		this:Show();

	elseif ( event == "OPEN_PS_MESSAGE_FRAME" )  then


		AxTrace(0,0,"arg0 = " .. arg0);


		if( arg0 == "name" )    then
			g_szData = arg1;
			g_nData = tonumber(arg2);
			CancelLastOp(FrameInfoList.PS_RENAME_MESSAGE);
			g_FrameInfo = FrameInfoList.PS_RENAME_MESSAGE;

		elseif( arg0 == "ad" )  then
			g_szData = arg1;
			g_nData = tonumber(arg2);
			CancelLastOp(FrameInfoList.PS_READ_MESSAGE);
			g_FrameInfo = FrameInfoList.PS_READ_MESSAGE;

		elseif( arg0 == "immitbase" )		then -- ����
			g_szData = arg1;
			g_nData  = tonumber(arg2);
			g_nData1 = tonumber(arg3);
			CancelLastOp(FrameInfoList.PS_ADD_BASE_MONEY);
			g_FrameInfo = FrameInfoList.PS_ADD_BASE_MONEY;

		elseif( arg0 == "immit" )				then -- ӯ�������
			g_szData = arg1;
			g_nData  = tonumber(arg2);
			g_nData1 = tonumber(arg3);
			CancelLastOp(FrameInfoList.PS_ADD_GAIN_MONEY);
			g_FrameInfo = FrameInfoList.PS_ADD_GAIN_MONEY;

		elseif( arg0 == "draw" )				then -- ӯ����ȡ��
			g_szData = arg1;
			g_nData  = tonumber(arg2);
			g_nData1 = tonumber(arg3);
			CancelLastOp(FrameInfoList.PS_DEC_GAIN_MONEY);
			g_FrameInfo = FrameInfoList.PS_DEC_GAIN_MONEY;

		elseif( arg0 == "add_stall" )		then --
			g_szData = arg1;
			g_nData  = tonumber(arg2);
			CancelLastOp(FrameInfoList.PS_ADD_STALL);
			g_FrameInfo = FrameInfoList.PS_ADD_STALL;


		elseif( arg0 == "del_stall" )		then --
			g_szData = arg1;
			g_nData  = tonumber(arg2);
			CancelLastOp(FrameInfoList.PS_DEL_STALL);
			g_FrameInfo = FrameInfoList.PS_DEL_STALL;
			

		elseif( arg0 == "sale" )     	then 	-- �̳�
			g_szData = tonumber(arg2);
			g_nData  = tonumber(arg3);
			CancelLastOp(FrameInfoList.PS_INFO_PANCHU);
			g_FrameInfo = FrameInfoList.PS_INFO_PANCHU;
			

		elseif( arg0 == "back" )     	then	-- ȡ���̳�
			g_szData = tonumber(arg2);
			g_nData  = tonumber(arg3);
			CancelLastOp(FrameInfoList.PS_INFO_PANRU);
			g_FrameInfo = FrameInfoList.PS_INFO_PANRU;

		elseif( arg0 == "ps_type" )		then	-- ��������̵��������ʾ��Ϣ
			g_szData = tonumber(arg2);
			g_nData  = tonumber(arg3);
			CancelLastOp(FrameInfoList.PS_INFO_MODIFY_TYPE);
			g_FrameInfo = FrameInfoList.PS_INFO_MODIFY_TYPE;


		end
	elseif ( event == "UI_COMMAND" ) then
		--AxTrace(0,1,"tonumber(arg0)="..tonumber(arg0))
		if tonumber(arg0) == FrameInfoList.SERVER_CONTROL then
				CancelLastOp(FrameInfoList.SERVER_CONTROL);
				g_FrameInfo = FrameInfoList.SERVER_CONTROL;
				-- zchw fix Transfer bug
				local xx = Get_XParam_INT(1);
				ObjCaredID = DataPool : GetNPCIDByServerID(xx);
				if ObjCaredID ~= -1 then	
					--��ʼ����NPC
					this:CareObject(ObjCaredID, 1, "MsgBox");
				end
		elseif tonumber(arg0) == 202105232 then
			nChallenge_1 = arg1--����
			nChallenge_2 = tonumber(arg2)--Ԫ��
			nChallenge_3 = tonumber(arg3)--ID
			g_FrameInfo = FrameInfoList.SHENGSICHALLENGE
			MessageBox_Self_Text:SetText(nChallenge_1);
			MessageBox_Self_DragTitle:SetText("#gFF0FA0��ս����");
			MessageBox_Self_UpdateRect();
			this:Show();
			MessageBox_Self_OK_Button:Show();
			MessageBox_Self_Cancel_Button:Show();
			return
		elseif tonumber(arg0) == 20221123 then
			nChallenge_1 = tonumber(arg1)	--NPC ID
			nChallenge_2 = tonumber(arg2)	--NPC ID
			g_FrameInfo = FrameInfoList.CSPS_FANGQI
			MessageBox_Self_Text:SetText("#{XSX_220705_109}");
			MessageBox_Self_DragTitle:SetText("#{XSX_220705_324}");
			MessageBox_Self_UpdateRect();
			this:Show();
			MessageBox_Self_OK_Button:Show();
			MessageBox_Self_Cancel_Button:Show();
			return			
		else
				return;
		end
	-- zchw fix Transfer bug
	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if(tonumber(arg0) ~= ObjCaredID) then
			return;
		end
		--�����NPC�ľ������һ��������߱�ɾ�����Զ��ر�
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			if ObjCaredID ~= -1 then	
				this:CareObject(ObjCaredID, 0, "MsgBox");
			end
			this:Hide();
		end
	elseif( event == "DELETE_FRIEND" ) then
		g_currentList = tonumber(arg0);
		g_currentIndex = tonumber(arg1);
		CancelLastOp(FrameInfoList.DELETE_FRIEND_MESSAGE);
		g_FrameInfo = FrameInfoList.DELETE_FRIEND_MESSAGE;
	elseif( event == "CITY_CONFIRM" ) then
		g_CityData[1] = tonumber(arg0);
		g_CityData[2] = tonumber(arg1);
		g_CityData[3] = arg2;
		g_CityData[4] = arg3;
		g_CityData[5] = arg4;
		g_CityData[6] = arg5;
		g_CityData[7] = arg6;
		g_CityData[8] = arg7;
		CancelLastOp(FrameInfoList.CITY_CONFIRM);
		g_FrameInfo = FrameInfoList.CITY_CONFIRM;
	elseif( event == "MESSAGE_BOX" ) then
		MeesageBox_Init();
		return;
	elseif( event == "CHANGEPROTECTTIME" ) then
		g_ChangeTiemArg0 = tonumber(arg0);
		g_ChangeTiemArg1 = tonumber(arg1);
		CancelLastOp(FrameInfoList.CHANGEPROTECTTIME);
		g_FrameInfo = FrameInfoList.CHANGEPROTECTTIME;
		MessageBox_Self_DragTitle:SetText("#gFF0FA0��ȫʱ��");
		if(g_ChangeTiemArg0 == 0)then
			MessageBox_Self_Text:SetText("һ�����ð�ȫʱ�䣬�´�����ʱ�ڰ�ȫʱ�����޷����кܶ������������������������İ�ȫʱ�䡣ȷ��Ҫ������");
		else
			MessageBox_Self_Text:SetText("���Ӱ�ȫʱ����ʹ�����˺Ÿ���ȫ�������´�����ʱ�ڰ�ȫʱ����Ҳ�޷����кܶ������������������������İ�ȫʱ�䡣��ȷ��Ҫ�������Ӱ�ȫʱ����");
			--�ʺ�  to  �˺�
		end
		MessageBox_Self_UpdateRect();
		this:Show();
		return;
	elseif(event == "PLAYER_GIVE_ROSE")then
		g_RoseArg0 = arg0;
		g_RoseArg1 = arg1;
		g_RoseArg2 = arg2;
		g_RoseArg3 = arg3;
		g_RoseArg4 = arg4;
		if(g_RoseArg0==nil or g_RoseArg1 == nil )then
			return;
		end
		CancelLastOp(FrameInfoList.Player_Give_Rose);
		g_FrameInfo = FrameInfoList.Player_Give_Rose;
		MessageBox_Self_Text:SetText("#cFFF263�Ƿ���#c00ff00999��õ��#cFFF263��#c00ff00"..g_RoseArg0.."#cFFF263?");
		MessageBox_Self_UpdateRect();
		this:Show();
		return;
	end

	if(event == "CLOSE_PS_CHANGETYPE_MSG" ) then
		if(this:IsVisible() and g_FrameInfo == FrameInfoList.PS_INFO_MODIFY_TYPE)then
			this:Hide();
		end
		return;
	end
	if(event == "CLOSE_STRENGTH_MSGBOX" ) then
		if(this:IsVisible()) then
			if g_FrameInfo == FrameInfoList.CONFIRM_STENGTH  then 
				this:Hide();
			elseif g_FrameInfo == FrameInfoList.SERVER_CONTROL then
				this:Hide();
			end
		end
		return;
	end
	
	if(event == "CLOSE_RE_IDENTIFY_MSGBOX" ) then
		if(this:IsVisible()) then
			if g_FrameInfo == FrameInfoList.CONFIRM_RE_IDENTIFY  then 
				this:Hide();
			end
		end
		return;
	end
	
	if(event == "CLOSE_KICK_MEMBER_MSGBOX" ) then
		if(this:IsVisible()) then
			if g_FrameInfo == FrameInfoList.KICK_MEMBER_MSGBOX  then 
				this:Hide();
			end
		end
		return;
	end

	if(event == "CLOSE_SAFEBOX_CONFIRM" ) then
		if(this:IsVisible()) then
			if (g_FrameInfo == FrameInfoList.SAFEBOX_LOCK_CONFIRM or g_FrameInfo == FrameInfoList.SAFEBOX_UNLOCK_CONFIRM) then 
				this:Hide();
			end
		end
		return;
	end	
	

	if(event == "CLOSE_RECYCLESHOP_MSG" ) then
		if(this:IsVisible()) then
			
			if g_FrameInfo == FrameInfoList.RECYCLE_DEL_ITEM  then 
				CancelLastOp(-1);
				this:Hide();
			elseif g_FrameInfo == FrameInfoList.OPEN_IS_SELL_TO_RECSHOP then
				CancelLastOp(-1);
				this:Hide();
			end
		end
		return;
	end

	if(event == "ENCHASE_CLOSE_MSGBOX" ) then
		if(this:IsVisible() and  g_FrameInfo == FrameInfoList.ENCHASE_CONFIRM) then
			CancelLastOp(-1);
			this:Hide();
		end
		return;
	end
	
	
	
	-- add:lby20080527ȷ��4��ǶENCHASE_FOUR_CONFIRM
	if(event == "ENCHASE_CLOSE_MSGBOX" ) then
		if(this:IsVisible() and  g_FrameInfo == FrameInfoList.ENCHASE_FOUR_CONFIRM) then
			CancelLastOp(-1);
			this:Hide();
		end
		return;
	end

	if(event == "CHAR_RANAME_CONFIRM" ) then
		g_arg_chrc = arg0;
		MessageBox_Self_DragTitle:SetText("#gFF0FA0��ɫ����");
		MessageBox_Self_Text:SetText("ע�⣬��ֻ��һ�θ����Ļ��ᡣ#r��ȷ��Ҫ�޸�����Ϊ#G"..g_arg_chrc.."#cFFF263ô��");	
		CancelLastOp(FrameInfoList.CHAR_RANAME_CONFIRM);
		g_FrameInfo = FrameInfoList.CHAR_RANAME_CONFIRM
		MessageBox_Self_UpdateRect();
		this:Show();
		return;
	end
	
	if(event == "CITY_RANAME_CONFIRM" ) then
		g_arg_circ = arg0;
		MessageBox_Self_DragTitle:SetText("#gFF0FA0������");
		MessageBox_Self_Text:SetText("ע�⣬��ֻ��һ�θ����Ļ��ᡣ#r��ȷ��Ҫ�޸İ����Ϊ#G"..g_arg_circ.."#cFFF263ô��");	
		CancelLastOp(FrameInfoList.CITY_RANAME_CONFIRM);
		g_FrameInfo = FrameInfoList.CITY_RANAME_CONFIRM
		MessageBox_Self_UpdateRect();
		this:Show();
		return;
	end

	if(event == "GAMELOGIN_OPEN_COUNT_INPUT") then
		if(this:IsVisible()) then
			CancelLastOp(-1);
			this:Hide();
		end
		return;
	end
		
	if(event == "SAFEBOX_LOCK_CONFIRM") then
		CancelLastOp(FrameInfoList.SAFEBOX_LOCK_CONFIRM);
		g_FrameInfo = FrameInfoList.SAFEBOX_LOCK_CONFIRM;
		MessageBox_Self_DragTitle:SetText("#gFF0FA0����������");
		MessageBox_Self_Text:SetText("#{YHBXX_20071220_10}");
		MessageBox_Self_UpdateRect();
		this:Show();
		return;
	end
	
	if(event == "SAFEBOX_UNLOCK_CONFIRM") then
		CancelLastOp(FrameInfoList.SAFEBOX_UNLOCK_CONFIRM);
		g_FrameInfo = FrameInfoList.SAFEBOX_UNLOCK_CONFIRM;
		MessageBox_Self_DragTitle:SetText("#gFF0FA0���������");
		MessageBox_Self_Text:SetText("#{YHBXX_20071220_07}");
		MessageBox_Self_UpdateRect();
		this:Show();
		return;
	end
	
	if (event == "CONFIRM_SETPOS_TLZ") then
		CancelLastOp(FrameInfoList.TLZ_CONFIRM_SETPOS);
		g_FrameInfo = FrameInfoList.TLZ_CONFIRM_SETPOS;
		
		local itemIdx = tonumber(arg0)
		local szSceneName = tostring(arg1);
		local iPosX = tonumber(arg2);
		local iPosZ = tonumber(arg3);
		
		Client_ItemIndex = itemIdx
		
		if (szSceneName ~= "") then
			MessageBox_Self_Text:SetText("#{TLZ_081114_1}"..szSceneName.."��"..iPosX.."��"..iPosZ.."��".."#{TLZ_081114_2}")
			MessageBox_Self_UpdateRect();
			this:Show();
		else
			MessageBox_Self_OK_Clicked()
			this:Hide()
			return
		end
		
	end
	
	-- ������ɢ����Ķ���ȷ�ϴ���			add by WTT	20090212
	if (event == "OPNE_DISMISS_TEAM_MSGBOX")	then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0��ɢ����");			-- ���ñ���
		MessageBox_Self_Text:SetText( "#{TeamDismiss_090912_1}" );	-- ��������
		CancelLastOp(FrameInfoList.DISMISS_TEAM);
		g_FrameInfo = FrameInfoList.DISMISS_TEAM;
		MessageBox_Self_UpdateRect();																-- �ָ����ڴ�С����ʼ��С
		this:Show();
		return;
	end

	if(MessageBox_Self_OnEventEx(event) > 0) then
		MessageBox_Self_UpdateFrame();
	end

end

function MeesageBox_Init()
	strMessageString = tostring( arg0 );
	strMessageData	= tostring( arg1 );
	strMessageArgs = tostring(arg2);
	strMessageType	= tostring(arg3);
	strMessageArgs_2 = tostring(arg4)
	CancelLastOp(FrameInfoList.EQUIP_ITEM);
	g_FrameInfo = FrameInfoList.EQUIP_ITEM;
	MessageBox_Update();
end

function MessageBox_Update()
	this:Show();
	MessageBox_Self_OK_Button:Hide();
	MessageBox_Self_Cancel_Button:Hide();
	MessageBox_Self_Text:SetText( strMessageString );
	MessageBox_Self_DragTitle:SetText("#gFF0FA0#gFF0FA0ȷ ��")
	if( strMessageType == "Normal" ) then
		MessageBox_Self_OK_Button:Show();
		MessageBox_Self_Cancel_Button:Show();
	elseif( strMessageType == "OK" ) then
		MessageBox_Self_OK_Button:Show();
	elseif( strMessageType == "Cancel" ) then
		MessageBox_Self_Cancel_Button:Show();
	elseif( strMessageType == "NoButton" ) then
	elseif( strMessageType == "Hide" ) then
		this:Hide();
	end
	MessageBox_Self_UpdateRect();
end
function MessageBox_Self_City_UpdateFrame()
	--AxTrace(0,0,"MessageBox_Self_City_UpdateFrame:"..tostring(g_CityData[1]));
	--ȡ����ǰ���轨�����ȷ����Ϣ
	if(g_CityData[1] == 0) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0ȡ����ǰ����");
		local szName, bLevel, bId = City:GetCityManageInfo("CurBuilding");
		local szExist = City:GetBuildingInfo(bId, "exist");
		if(tonumber(szExist) > 0) then szExist = "����"; else szExist = "�޽�"; end
		local szCurPro = tostring(City:GetCityManageInfo("CurProgress"));
		local szAttr = (City:GetBuildingInfo(bId, "condattrname"));

		local msg = "����Ŀǰ����"..szExist..szName.."�У��Ѿ�����˽���"..szCurPro.."����ֹ��";
		msg = msg..szExist.."��ʧ�ܣ����н��Ƚ�Ϊ0�����˻��κΰ��ʽ��"..szAttr.."����ȷ��Ҫ��ֹ��ǰ��";
		msg = msg..szExist.."��?";
		MessageBox_Self_Text:SetText(msg);
		MessageBox_Self_UpdateRect();
		this:Show();
	--�������ȷ����Ϣ
	elseif(g_CityData[1] == 1) then
		local szPortName = City:GetPortInfo(g_CityData[2], "Name");
		MessageBox_Self_DragTitle:SetText("#gFF0FA0�������");
		--��ȷ��Ҫ����������AA�ġ�BB�������������Ϊ��Ҫ����1000����ҡ�
		local msg = "#cFFF263��ȷ��Ҫ����������#cFE7E82"..tostring(szPortName).."#cFFF263��#H"..g_CityData[3].."#cFFF263";
		msg = msg.."�����������Ϊ��Ҫ����1000#-14����һ�齨�����ơ�";
		MessageBox_Self_Text:SetText(msg);
		MessageBox_Self_UpdateRect();
		this:Show();
	--�޽�������������
	elseif(g_CityData[1] == 2 or g_CityData[1] == 3) then
		local szName, bLevel, bId = City:GetCityManageInfo("CurBuilding");
		if(bLevel == -1 or bId == -1) then
			local szExist = "";
			if(g_CityData[1] == 2) then
				MessageBox_Self_DragTitle:SetText("#gFF0FA0�����½���");
				szExist = "�޽�";
			else
				MessageBox_Self_DragTitle:SetText("#gFF0FA0��������");
				szExist = "����";
			end

			local szName = (City:GetBuildingInfo(g_CityData[2], "name"));
			--��������
			local cd = {City:GetBuildingInfo(g_CityData[2], "condition")};
			--0.��Ǯ
			local money = cd[1];
			local txt = "";
			if(0 ~= tonumber(money)) then
				txt = txt.."#{_MONEY"..tostring(money).."}";
			else
				txt = txt.."0#-02";
			end
			money = txt;
			--1.����ֵ
			local szAttr = (City:GetBuildingInfo(g_CityData[2], "condattrname"));
			local szAttrVal = tostring(cd[4]);
			--2.������
			local mn = tostring(cd[2]);

			local msg = szExist..szName.."��Ҫ���ʽ�"..money.."������"..szAttr..szAttrVal;
			msg = msg.."�㣬ͬʱ��������"..mn.."������ȷ����?";
			MessageBox_Self_Text:SetText(msg);
			MessageBox_Self_UpdateRect();
			this:Show();
		else
			City:DoConfirm(0);	--ȡ����ǰ������ȷ����Ϣ
		end
	--�������ٽ�����
	elseif(g_CityData[1] == 4 or g_CityData[1] == 5) then
		local szExist = "";
		if(g_CityData[1] == 4) then
			MessageBox_Self_DragTitle:SetText("#gFF0FA0��������");
			szExist = "����";
		else
			MessageBox_Self_DragTitle:SetText("#gFF0FA0��ٽ���");
			szExist = "���";
		end

		local szName = (City:GetBuildingInfo(g_CityData[2], "name"));
		local szPreAttr = "";
		_,szPreAttr = City:GetBuildingInfo(g_CityData[2], "condattrname");
		local msg = szExist..szName.."����ʹ�������������ü��٣��Ҳ��˻��κΰ��ʽ���";
		msg = msg..szPreAttr.."����ȷ��Ҫ��������?";
		MessageBox_Self_Text:SetText(msg);
		MessageBox_Self_UpdateRect();
		this:Show();
	--�޸ĳ��з�չ��������ֵ
	elseif(g_CityData[1] == 6) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0�޸ķ�չ����");
		local msg = "�޸ķ�չ���򽫻����İ���ʽ�50#-02����ȷ��Ҫ��������?"
		MessageBox_Self_Text:SetText(msg);
		MessageBox_Self_UpdateRect();
		this:Show();
	--ȡ���о���ȷ����Ϣ
	elseif(g_CityData[1] == 7) then
		local rName, _, rIdx = City:GetResearchInfo("CurResearch");
		local szCurPro = tostring(City:GetResearchInfo("ResearchProcess"));

		MessageBox_Self_DragTitle:SetText("#gFF0FA0��ֹ�о�");
		local msg = "����Ŀǰ�����о�"..rName.."�У��Ѿ�����˽���"..szCurPro.."����ֹ��";
		msg = msg.."�о���ʧ�ܣ����н��Ƚ�Ϊ0�����˻��κΰ��ʽ������ֵ����ȷ��Ҫ��ֹ��ǰ���о���?";
		MessageBox_Self_Text:SetText(msg);
		MessageBox_Self_UpdateRect();		
		this:Show();
	--��ʼ�о���ȷ����Ϣ
	elseif(g_CityData[1] == 8) then
		local rName = City:GetResearchInfo("CurResearch");
		if("" == rName) then
			local bIdx = tonumber(g_CityData[2]);
			local rIdx = tonumber(g_CityData[3]);
			MessageBox_Self_DragTitle:SetText("#gFF0FA0�о��䷽");
			local szResearchName = City:GetResearchInfo("ResearchName", bIdx, rIdx);
			--��������
			local cd = {City:GetResearchInfo("ResearchCondition", bIdx, rIdx)};
			--0.��Ǯ
			local money = cd[1];
			local txt = "";
			if(0 ~= tonumber(money)) then
				txt = txt.."#{_MONEY"..tostring(money).."}";
			else
				txt = txt.."0#-02";
			end
			money = txt;
			--1.����ֵ
			local szAttr = City:GetResearchInfo("RCAttrName", bIdx, rIdx);
			local szAttrVal = tostring(cd[4]);
			--2.������
			local mn = tostring(cd[2]);
			local msg = "�о�"..szResearchName.."��Ҫ���ʽ�"..money.."������";
			msg = msg..szAttr..szAttrVal.."��ͬʱ��������"..mn.."������ȷ����?";
			MessageBox_Self_Text:SetText(msg);
			MessageBox_Self_UpdateRect();
			this:Show();
		else
			City:DoConfirm(7);	--ȡ����ǰ�о���ȷ����Ϣ
		end
	--������ҵ·�ߵ�ȷ����Ϣ
	elseif(g_CityData[1] == 9) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0������ҵ·��");
		local msg = "�˲���������Ϊ"..tostring(g_CityData[2]).."�İ�Ὠ�����ߣ�ֻ��˫���������ߣ����߲Ż���Ч����ȷ��Ҫ������?";
		MessageBox_Self_Text:SetText(msg);
		MessageBox_Self_UpdateRect();
		this:Show();
	--ȡ����ҵ·�ߵ�ȷ����Ϣ
	elseif(g_CityData[1] == 10) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0ȡ����ҵ·��");
		local dt = {City:GetCityRoadInfo("RoadDetail", g_CityData[2])};
		local msg = "";
		if(dt[4]) then
			msg = "�˲�����ʹ������Է�������ҵ��Ϊ��������ֹ����ȷ��Ҫ�������в�����?";
		else
			msg = "�˲�����ʹ������Է���᲻�����л������ߵĿ��ܣ���ȷ��Ҫ�������в�����?";
		end
		MessageBox_Self_Text:SetText(msg);
		MessageBox_Self_UpdateRect();
		this:Show();
	end
end

function MessageBox_Self_City_OK_Clicked()
	if(g_CityData[1] == 0) then
		local nBuildingId;
		_,_,nBuildingId = City:GetCityManageInfo("CurBuilding");
		City:DoBuilding(nBuildingId, "cancelup");
	elseif(g_CityData[1] == 1) then
		City:CreateCity(g_CityData[2],g_CityData[3]);
	elseif(g_CityData[1] == 2) then
		City:DoBuilding(g_CityData[2], "create");
	elseif(g_CityData[1] == 3) then
		City:DoBuilding(g_CityData[2], "up");
	elseif(g_CityData[1] == 4) then
		City:DoBuilding(g_CityData[2], "down");
	elseif(g_CityData[1] == 5) then
		City:DoBuilding(g_CityData[2], "destory");
	elseif(g_CityData[1] == 6) then
		local k;
		local valTab = {};
		for k = 2, 8 do
			valTab[k-1] = tonumber(g_CityData[k]);
		end
		City:FixCityTrend(
												valTab[1],valTab[2],valTab[3],valTab[4],
												valTab[5],valTab[6],valTab[7],valTab[8]
										 );
	elseif(g_CityData[1] == 7) then
		local rName, bIdx, rIdx = City:GetResearchInfo("CurResearch");
		City:DoResearch(bIdx, rIdx, "cancelresearch");
	elseif(g_CityData[1] == 8) then
		City:DoResearch(tonumber(g_CityData[2]), tonumber(g_CityData[3]), "research");
	elseif(g_CityData[1] == 9) then
		City:DoCityRoad("create", g_CityData[2]);
	elseif(g_CityData[1] == 10) then
		City:DoCityRoad("cancel", g_CityData[2]);
	end
	g_CityData = {};
end

function MessageBox_Self_City_Cancel_Clicked()
	g_CityData = {};
end


--===============================================
-- UpdateFrame
--===============================================
function MessageBox_Self_UpdateFrameEx()

	if( g_FrameInfo==FrameInfoList.SAVE_STALL_INFO) then
		
		MessageBox_Self_DragTitle:SetText("#gFF0FA0����̯λ����");
		local szInfo;
		szInfo = "#{INTERFACE_XML_681}";
		MessageBox_Self_Text:SetText(szInfo);
		this:Show();
	-- add by zchw
	elseif (g_FrameInfo == FrameInfoList.CONFIRM_REMOVE_STALL) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0��̯");
		local szInfo;
		szInfo = "�����Ҫ��̯��";
		MessageBox_Self_Text:SetText(szInfo);
		this:Show();
	-- zchw for pet procreate
	elseif (g_FrameInfo == FrameInfoList.PET_PROCREATE_PROMPT) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0ע��");
		MessageBox_Self_Text:SetText("#{PET_FANZHI_20080313_01}");
		this:Show();
	elseif(g_FrameInfo == FrameInfoList.YUANBAO_BUY_ITEM) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0������Ʒ");
		local szInfo;
		szInfo = "����"..g_CityData[3].."��Ҫ����"..tostring(g_CityData[2]).."��Ԫ������ȷ����";
		MessageBox_Self_Text:SetText(szInfo);
		this:Show();
	elseif(g_FrameInfo == FrameInfoList.COMMISION_BUY) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0������Ʒ");
		local szInfo;
		szInfo = "����"..CommisionBuyData[1].."��Ҫ����"..CommisionBuyData[2].."����ȷ����";
		MessageBox_Self_Text:SetText(szInfo);
		this:Show();
		
	end

end

--===============================================
-- UpdateTitle
--===============================================
function UpdateTitle()
    --��Ϊ��MessageBox_Self_UpdateFrame������,"upvalue"���س�Ա,���������������������msgbox�ı���
    if ( PVPFLAG.FREEFORALL == g_FrameInfo ) then
        MessageBox_Self_DragTitle:SetText("#gFF0FA0����PKģʽ");
    elseif ( PVPFLAG.FREEFORTEAM == g_FrameInfo ) then
        MessageBox_Self_DragTitle:SetText("#gFF0FA0����PKģʽ");
    elseif ( PVPFLAG.FREEFORGUILD == g_FrameInfo ) then
        MessageBox_Self_DragTitle:SetText("#gFF0FA0����PKģʽ");
    elseif ( PVPFLAG.MAKESUREPVPCHALLENGE == g_FrameInfo ) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0��սȷ��");
    elseif ( FrameInfoList.SHENGSICHALLENGE == g_FrameInfo ) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0��ս����");
    elseif ( FrameInfoList.CSPS_FANGQI == g_FrameInfo ) then
		MessageBox_Self_DragTitle:SetText("#{XSX_220705_324}");
	end
	MessageBox_Self_UpdateRect();

end

--===============================================
-- UpdateFrame
--===============================================
function MessageBox_Self_UpdateFrame()

	MessageBox_Self_DragTitle:SetText("#gFF0FA0");
	UpdateTitle()

	if g_FrameInfo == FrameInfoList.GEM_COMBINED_CONFIRM then
		this : Show()
		MessageBox_Self_Text : SetText( GemCombinedData[7] )
		MessageBox_Self_UpdateRect();
		return
	end

	if(g_FrameInfo == FrameInfoList.STALL_RENT_FRAME) then
		--��ʾ���ķ���
		local nPosTax = StallSale:GetPosTax();
		local nTradeTax = StallSale:GetTradeTax();

		local nGoldCoin;
		local nSilverCoin;
		local nCopperCoin;

		nGoldCoin, nSilverCoin, nCopperCoin = Bank:TransformCoin(nPosTax);

		local szMoneyPosTax = "";
		if(nGoldCoin ~= 0)   then
		 	szMoneyPosTax = tostring(nGoldCoin) .. "#-14";
		end
		if(nSilverCoin ~= 0)   then
		 	szMoneyPosTax = szMoneyPosTax .. tostring(nSilverCoin) .. "#-15";
		end
		if(nCopperCoin ~= 0)   then
			szMoneyPosTax = szMoneyPosTax .. tostring(nCopperCoin) .. "#-16";
		end

		local nCoinType = StallSale:GetStallType()
		if (nCoinType == 1) then --Ԫ����̯
			local szInfo = "#{YBBT_081031_1}".. szMoneyPosTax .."#{YBBT_081031_2}1#{YBBT_081031_3}";
			MessageBox_Self_Text:SetText(szInfo);
		else
			local szInfo = "#{YBBT_081031_4}".. szMoneyPosTax .."#{YBBT_081031_5}".. tostring(nTradeTax) .."#{YBBT_081031_6}";
			MessageBox_Self_Text:SetText(szInfo);
		end

	elseif(g_FrameInfo == FrameInfoList.DISCARD_ITEM_FRAME) then
		--֪ͨ�������
		MessageBox_Self_DragTitle:SetText("#gFF0FA0������Ʒ");
		local szStr = "�����Ҫ����".. argDISCARD_ITEM_FRAME0 .."?"
		MessageBox_Self_Text:SetText(szStr);

	elseif(g_FrameInfo == FrameInfoList.CANNT_DISCARD_ITEM) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0������Ʒ");
		local szStr = argCANNT_DISCARD_ITEM0.."��������Ʒ����������";
		MessageBox_Self_Text:SetText(szStr);
		
	elseif(g_FrameInfo == FrameInfoList.LOCK_ITEM_CONFIRM_FRAME) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0����");
		local szStr = "".."#cff0000ע�⣡#r#YΪ�˱������ĲƲ���ȫ��һ����Ʒ�����޳ɹ����������ٴν�������Ҫ�ȴ�#G3��#Y����ȷ��Ҫ��������ô��";
		MessageBox_Self_Text:SetText(szStr);

	elseif(g_FrameInfo == FrameInfoList.FRAME_AFFIRM_SHOW) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0��������");
		local szStr = "#cFFF263�����Ҫ����#R����:"..argFRAME_AFFIRM_SHOW0.."#cFFF263��";
		MessageBox_Self_Text:SetText(szStr);

	elseif(g_FrameInfo == FrameInfoList.GUILD_CREATE_CONFIRM) then
		-- �����������ȷ��
		MessageBox_Self_DragTitle:SetText("#gFF0FA0������");
		local szStr = "��ȷ�ϴ���" .. argCREATE_CONFIRM0 .. "�����";
		MessageBox_Self_Text:SetText(szStr);
	elseif(g_FrameInfo == FrameInfoList.GUILD_DESTORY_CONFIRM) then
	  MessageBox_Self_DragTitle:SetText("#gFF0FA0����ɢ");
		local szStr = "��ȷ��ɾ��" .. argDESTORY_CONFIRM0 .. "�����";
		MessageBox_Self_Text:SetText(szStr);
	elseif(g_FrameInfo == FrameInfoList.GUILD_QUIT_CONFIRM) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0����˳�");
		local szStr = "��ȷ���˳�" .. argQUIT_CONFIRM0 .. "�����";
		MessageBox_Self_Text:SetText(szStr);
	elseif(g_FrameInfo == FrameInfoList.GUILD_LEAGUE_QUIT_CONFIRM) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0ͬ���˳�");
		local szStr = "��ȷ���˳�" .. argQUIT_LEAGUE_CONFIRM0 .. "ͬ����";
		MessageBox_Self_Text:SetText(szStr);
	elseif(g_FrameInfo == FrameInfoList.GUILD_LEAGUE_CREATE_CONFIRM) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0ͬ�˴���");
		local szStr = "#{TM_20080331_09}#{_EXCHG1000000}#{TM_20080331_02}";
		MessageBox_Self_Text:SetText(szStr);
	elseif(g_FrameInfo == FrameInfoList.NET_CLOSE_MESSAGE) then
		MessageBox_Self_Text:SetText(argNET_CLOSE0);
	elseif(g_FrameInfo == FrameInfoList.PET_FREE_CONFIRM) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0���޷���");
		local petname = Pet:GetPetList_Appoint(Pet_Number) ;
		local strname, pettype = Pet:GetName(Pet_Number);
		petname = string_name(petname)
		local szStr = "�Ƿ�ȷ�Ϸ���["..petname.."]("..pettype..")?" ;
		MessageBox_Self_Text:SetText(szStr);

	elseif(g_FrameInfo == FrameInfoList.PS_RENAME_MESSAGE)  then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0�޸ĵ���");
		--����̵������Ҫ�Ľ�Ǯ����
		local nGoldCoin;
		local nSilverCoin;
		local nCopperCoin;

		nGoldCoin, nSilverCoin, nCopperCoin = Bank:TransformCoin(g_nData);

		local szMoney = "";
		if(nGoldCoin ~= 0)   then
		 	szMoney = tostring(nGoldCoin) .. "#-02";
		end
		if(nSilverCoin ~= 0)   then
		 	szMoney = szMoney .. tostring(nSilverCoin) .. "#-03";
		end
		if(nCopperCoin ~= 0)   then
			szMoney = szMoney .. tostring(nCopperCoin) .. "#-04";
		end

		local szInfo = "�޸ĵ�����Ҫ֧�����ҽ��ַ�2".."#-02".. "����ҵָ������ǰ����ҵָ��Ϊ".. PlayerShop:GetCommercialFactor().."��Ҫ֧��"..szMoney.."����ȷ��Ҫ�޸���"
		MessageBox_Self_Text:SetText(szInfo);

		this:Show()

	elseif(g_FrameInfo == FrameInfoList.PS_READ_MESSAGE)    then
		--����̵�������̵�˵����Ҫ�Ľ�Ǯ����
		MessageBox_Self_DragTitle:SetText("#gFF0FA0�޸ĵ�������");
		local nGoldCoin;
		local nSilverCoin;
		local nCopperCoin;

		nGoldCoin, nSilverCoin, nCopperCoin = Bank:TransformCoin(g_nData);

		local szMoney = "";
		if(nGoldCoin ~= 0)   then
		 	szMoney = tostring(nGoldCoin) .. "#-02";
		end
		if(nSilverCoin ~= 0)   then
		 	szMoney = szMoney .. tostring(nSilverCoin) .. "#-03";
		end
		if(nCopperCoin ~= 0)   then
			szMoney = szMoney .. tostring(nCopperCoin) .. "#-04";
		end

		local szInfo = "�޸ĵ�������Ҫ֧����ī��".."50#-03".. "����ҵָ������ǰ����ҵָ��Ϊ".. PlayerShop:GetCommercialFactor().."��Ҫ֧��"..szMoney.."����ȷ��Ҫ�޸���"
		MessageBox_Self_Text:SetText(szInfo);

		this:Show()

	elseif(g_FrameInfo == FrameInfoList.PS_ADD_BASE_MONEY)    then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0���뱾��");
		local nGoldCoin;
		local nSilverCoin;
		local nCopperCoin;

		nGoldCoin, nSilverCoin, nCopperCoin = Bank:TransformCoin(g_nData);

		local szMoney = "";
		if(nGoldCoin ~= 0)   then
		 	szMoney = tostring(nGoldCoin) .. "#-02";
		end
		if(nSilverCoin ~= 0)   then
		 	szMoney = szMoney .. tostring(nSilverCoin) .. "#-03";
		end
		if(nCopperCoin ~= 0)   then
			szMoney = szMoney .. tostring(nCopperCoin) .. "#-04";
		end

		nGoldCoin, nSilverCoin, nCopperCoin = Bank:TransformCoin(g_nData1);

		local szMoney1 = "";
		if(nGoldCoin ~= 0)   then
		 	szMoney1 = tostring(nGoldCoin) .. "#-02";
		end
		if(nSilverCoin ~= 0)   then
		 	szMoney1 = szMoney1 .. tostring(nSilverCoin) .. "#-03";
		end
		if(nCopperCoin ~= 0)   then
			szMoney1 = szMoney1 .. tostring(nCopperCoin) .. "#-04";
		end

		local szInfo = "�㽫����" .. szMoney .. "��ϵͳ������ȡ��3%��Ͷ��˰���㽫��Ҫ����֧��" .. szMoney1 .. "����ȷ��Ҫ������";

		MessageBox_Self_Text:SetText(szInfo);

	elseif(g_FrameInfo == FrameInfoList.PS_ADD_GAIN_MONEY)    then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0����ӯ����");
		local nGoldCoin;
		local nSilverCoin;
		local nCopperCoin;

		nGoldCoin, nSilverCoin, nCopperCoin = Bank:TransformCoin(g_nData);

		local szMoney = "";
		if(nGoldCoin ~= 0)   then
		 	szMoney = tostring(nGoldCoin) .. "#-02";
		end
		if(nSilverCoin ~= 0)   then
		 	szMoney = szMoney .. tostring(nSilverCoin) .. "#-03";
		end
		if(nCopperCoin ~= 0)   then
			szMoney = szMoney .. tostring(nCopperCoin) .. "#-04";
		end

		nGoldCoin, nSilverCoin, nCopperCoin = Bank:TransformCoin(g_nData1);

		local szMoney1 = "";
		if(nGoldCoin ~= 0)   then
		 	szMoney1 = tostring(nGoldCoin) .. "#-02";
		end
		if(nSilverCoin ~= 0)   then
		 	szMoney1 = szMoney1 .. tostring(nSilverCoin) .. "#-03";
		end
		if(nCopperCoin ~= 0)   then
			szMoney1 = szMoney1 .. tostring(nCopperCoin) .. "#-04";
		end

		local szInfo = "�㽫����" .. szMoney .. "��ϵͳ������ȡ��3%��Ͷ��˰���㽫��Ҫ����֧��" .. szMoney1 .. "����ȷ��Ҫ������";

		MessageBox_Self_Text:SetText(szInfo);

	

	elseif(g_FrameInfo == FrameInfoList.PS_DEC_GAIN_MONEY)    then

	elseif(g_FrameInfo == FrameInfoList.SERVER_CONTROL)    then
		Server_Script_Function = Get_XParam_STR(0);
		Server_Script_ID = Get_XParam_INT(0);
		Server_Return_1 = Get_XParam_INT(1);
		Server_Return_2 = Get_XParam_INT(2);

		MessageBox_Self_Text:SetText(Get_XParam_STR(1));

	elseif(g_FrameInfo == FrameInfoList.PS_ADD_STALL)   then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0���Ź�̨");
		local nGoldCoin;
		local nSilverCoin;
		local nCopperCoin;

		nGoldCoin, nSilverCoin, nCopperCoin = Bank:TransformCoin(g_nData);

		local szMoney = "";
		if(nGoldCoin ~= 0)   then
		 	szMoney = tostring(nGoldCoin) .. "#-02";
		end
		if(nSilverCoin ~= 0)   then
		 	szMoney = szMoney .. tostring(nSilverCoin) .. "#-03";
		end
		if(nCopperCoin ~= 0)   then
			szMoney = szMoney .. tostring(nCopperCoin) .. "#-04";
		end

		local szInfo = "���Ź�̨��Ҫ֧��30#-02����ҵָ����2��103%����ǰ����ҵָ��Ϊ".. PlayerShop:GetCommercialFactor() .."����Ҫ֧��" .. szMoney .. "����ȷ��Ҫ������"

		MessageBox_Self_Text:SetText(szInfo);

	elseif(g_FrameInfo == FrameInfoList.PS_DEL_STALL)   then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0������̨");
		MessageBox_Self_Text:SetText("������̨�����ڷŵ���̨�еĻ���Ҳ����ϵͳ���ա���ȷ��Ҫ��������");

	elseif(g_FrameInfo == FrameInfoList.PS_INFO_PANCHU)  then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0�̳�����");
		local nGoldCoin;
		local nSilverCoin;
		local nCopperCoin;

		nGoldCoin, nSilverCoin, nCopperCoin = Bank:TransformCoin(g_szData);

		local szMoney = "";
		if(nGoldCoin ~= 0)   then
		 	szMoney = tostring(nGoldCoin) .. "#-02";
		end
		if(nSilverCoin ~= 0)   then
		 	szMoney = szMoney .. tostring(nSilverCoin) .. "#-03";
		end
		if(nCopperCoin ~= 0)   then
			szMoney = szMoney .. tostring(nCopperCoin) .. "#-04";
		end

		local szInfo = "�̳�������Ҫ֧��15#-02����ҵָ������ǰ����ҵָ��Ϊ".. PlayerShop:GetCommercialFactor() .."����Ҫ֧��" .. szMoney .. "����ȷ��Ҫ�̳�������"
		MessageBox_Self_Text:SetText(szInfo);

	elseif(g_FrameInfo == FrameInfoList.PS_INFO_PANRU)  then   --����

		MessageBox_Self_DragTitle:SetText("#gFF0FA0�������");
		local nGoldCoin;
		local nSilverCoin;
		local nCopperCoin;

		nGoldCoin, nSilverCoin, nCopperCoin = Bank:TransformCoin(g_szData);

		local szMoney = "";
		if(nGoldCoin ~= 0)   then
		 	szMoney = tostring(nGoldCoin) .. "#-02";
		end
		if(nSilverCoin ~= 0)   then
		 	szMoney = szMoney .. tostring(nSilverCoin) .. "#-03";
		end
		if(nCopperCoin ~= 0)   then
			szMoney = szMoney .. tostring(nCopperCoin) .. "#-04";
		end

		local szInfo = "ȡ���̳���̨��Ҫ֧��5#-02����ҵָ������ǰ����ҵָ��Ϊ".. PlayerShop:GetCommercialFactor() .."����Ҫ֧��" .. szMoney .. "����ȷ��Ҫ���������"

		MessageBox_Self_Text:SetText(szInfo);

	elseif( g_FrameInfo == FrameInfoList.PS_INFO_MODIFY_TYPE ) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0�޸ĵ�������");
		local nGoldCoin;
		local nSilverCoin;
		local nCopperCoin;

		nGoldCoin, nSilverCoin, nCopperCoin = Bank:TransformCoin(g_szData);
		local szMoney = "";
		if(nGoldCoin ~= 0)   then
		 	szMoney = tostring(nGoldCoin) .. "#-02";
		end
		if(nSilverCoin ~= 0)   then
		 	szMoney = szMoney .. tostring(nSilverCoin) .. "#-03";
		end
		if(nCopperCoin ~= 0)   then
			szMoney = szMoney .. tostring(nCopperCoin) .. "#-04";
		end

		local szInfo = "�޸ĵ�������Ҫ֧�����˷ѣ�5#-02 ����ҵָ������ǰ����ҵָ��Ϊ".. PlayerShop:GetCommercialFactor() .."����Ҫ֧��" .. szMoney .. "����ȷ��Ҫ�޸���"

		MessageBox_Self_Text:SetText(szInfo);
	elseif( g_FrameInfo == FrameInfoList.DELETE_FRIEND_MESSAGE ) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0ɾ��ȷ��");
		local szInfo;
		local relationtype = DataPool:GetFriend(g_currentList,g_currentIndex, "RELATION_TYPE" )
		if relationtype == 7 then
			szInfo = "#cFFF263��ȷ��Ҫɾ��".."#R"..DataPool:GetFriend(g_currentList,g_currentIndex, "NAME"  ) .."#cFFF263".."��ɾ���󽫲�����Է������κ�ʦͽ��صĻ��";
		else
			szInfo = "#cFFF263��ȷ��Ҫɾ��".."#R"..DataPool:GetFriend(g_currentList,g_currentIndex, "NAME"  ) .."#cFFF263".."��";
		end
		MessageBox_Self_Text:SetText(szInfo);
	elseif( g_FrameInfo == FrameInfoList.CITY_CONFIRM ) then
		MessageBox_Self_City_UpdateFrame();
	elseif( g_FrameInfo == FrameInfoList.PET_SYNC_CONFIRM ) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0���޺ϳ�");
		local msg = "��ȷ��������ֻ���޺ϳ�Ϊһֻ��?";
		MessageBox_Self_Text:SetText(msg);
	elseif( g_FrameInfo == FrameInfoList.EXCHANGE_BANGGONG ) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0�ﹱ�ƶһ�");
	elseif( g_FrameInfo == FrameInfoList.PUT_GUILDMONEY ) then
		MessageBox_Self_DragTitle:SetText("#{BPZJ_0801014_020}");
	end

	MessageBox_Self_UpdateFrameEx();
	MessageBox_Self_UpdateRect();	
	this:Show();
end

--===============================================
-- ���ȷ����IDOK��
--===============================================
function MessageBox_Self_OK_Clicked_Ex()
    AxTrace( 0, 0, "MessageBox_OnOKClick" )
	if( g_FrameInfo == FrameInfoList.FREEFORALL ) then --ͬ�⿪�����˻�ս
        AxTrace( 0, 0, "FrameInfoList.FREEFORALL" )
        Player:ChangePVPMode( 1 );
    end
    if( g_FrameInfo == FrameInfoList.FREEFORTEAM ) then --ͬ�⿪�������ս
        AxTrace( 0, 0, "FrameInfoList.FREEFORTEAM" )
        Player:ChangePVPMode( 3 );
    end
    if( g_FrameInfo == FrameInfoList.FREEFORGUILD ) then  --ͬ�⿪�����ɻ�ս
        AxTrace( 0, 0, "FrameInfoList.FREEFORGUILD" )
        Player:ChangePVPMode( 4 );
    end
    if( g_FrameInfo == FrameInfoList.MAKESUREPVPCHALLENGE ) then  --ȷ����ս
        AxTrace( 0, 0, "FrameInfoList.MAKESUREPVPCHALLENGE" )
        Player:PVP_Challenge( 2 );     --2Ϊ��սȷ�϶Ի���ȷ��
    end
    
    if(g_FrameInfo == FrameInfoList.CHANGEPROTECTTIME)then
	if(g_ChangeTiemArg1 ~= nil)then
		SendSetProtectTimeMsg(g_ChangeTiemArg1);
		g_ChangeTiemArg1 =nil;
	end
    end
    if( PVPFLAG.ACCEPTDUEL == g_FrameInfo ) then
        DuelAccept( tostring( PVPFLAG.DuelName ),tostring( PVPFLAG.DuelGUID ), 1 )
    end


	if( g_FrameInfo == FrameInfoList.SAVE_STALL_INFO ) then
		StallSale:CloseStall("ok");
	-- add by zchw	
		StallSale:CloseStallMessage();
	elseif g_FrameInfo == FrameInfoList.CONFIRM_REMOVE_STALL then
		StallSale:CloseStall("ask");
	-- zchw for pet procreate
	elseif g_FrameInfo == FrameInfoList.PET_PROCREATE_PROMPT then
		PushEvent(462, 0); --PETPROCREATE_KEY_STATE 
		Pet:ConfirmPetProcreate(1);
		
	elseif  g_FrameInfo == FrameInfoList.QUIT_GAME  then
		EnterQuitWait(0);
		--QuitApplication("quit");
	elseif(g_FrameInfo == FrameInfoList.PS_DEL_STALL)    then
		PlayerShop:ChangeShopNum("del_ok");
	elseif(g_FrameInfo == FrameInfoList.PS_INFO_PANCHU)    then
		PlayerShop:Transfer("apply", "sale", g_nData);
	elseif(g_FrameInfo == FrameInfoList.PS_INFO_PANRU)    then
		PlayerShop:Transfer("apply", "back", g_nData);
	elseif( g_FrameInfo == FrameInfoList.PS_INFO_MODIFY_TYPE ) then
		PlayerShop:ModifySubType("ps_type_ok", tonumber(g_nData));
	elseif( g_FrameInfo == FrameInfoList.DELETE_FRIEND_MESSAGE ) then
		DataPool:DelFriend( g_currentList, g_currentIndex );
	elseif( g_FrameInfo == FrameInfoList.CITY_CONFIRM ) then
		MessageBox_Self_City_OK_Clicked();
	elseif( g_FrameInfo == FrameInfoList.PET_SYNC_CONFIRM ) then
		MessageBox_Self_PetSyn_OK_Clicked();
	elseif(g_FrameInfo ==FrameInfoList.GUILD_DEMIS_CONFIRM) then
		Guild:DemisGuildOK();
	elseif(g_FrameInfo ==FrameInfoList.GUILD_LEAGUE_QUIT_CONFIRM) then
		GuildLeague:Quit();
	elseif(g_FrameInfo ==FrameInfoList.GUILD_LEAGUE_CREATE_CONFIRM) then
		local r=GuildLeague:Create(argCREATE_LEAGUE_CONFIRM0,argCREATE_LEAGUE_CONFIRM1)
		if r==-1 then
			PushDebugMessage("#{TM_20080311_05}")
		elseif r==-2 then
			PushDebugMessage("#{TM_20080311_07}")	
		end
	elseif(g_FrameInfo == FrameInfoList.YUANBAO_BUY_ITEM) then
		NpcShop:BulkBuyItem(g_CityData[1],1);
	elseif(g_FrameInfo == FrameInfoList.COMMISION_BUY) then
		CommisionShop:OnBuyConfrimed();
	end
	if( FrameInfoList.Player_Give_Rose == g_FrameInfo ) then
		Player:UseRose(tonumber(g_RoseArg1),tonumber(g_RoseArg2),tonumber(g_RoseArg3),tonumber(g_RoseArg4))
	end

	if(g_FrameInfo == FrameInfoList.RECYCLE_DEL_ITEM) then
		if(Recycle_Type<0 or Recycle_CurSelectItem<0) then
			return
		end
		PlayerShop:SendCancelRecItemMsg(Recycle_Type,Recycle_CurSelectItem);
		Recycle_Type =-1;
		Recycle_CurSelectItem = -1;
	end

	if(g_FrameInfo == FrameInfoList.OPEN_IS_SELL_TO_RECSHOP) then
		if(Recycle_Bag_idx<0 or Recycle_Shop_idx<0) then
			return
		end
		PlayerShop:SendSellItem2RecycleShopMsg(Recycle_Bag_idx,Recycle_Shop_idx);
		Recycle_Bag_idx =-1;
		Recycle_Shop_idx = -1;
	end
	if(g_FrameInfo == FrameInfoList.CONFIRM_STENGTH) then
		if(Stength_Equip_Idx<0 or Stength_Item_Idx<0) then
			return
		end
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("FinishEnhance");
			Set_XSCRIPT_ScriptID(809262);
			Set_XSCRIPT_Parameter(0,tonumber(Stength_Equip_Idx));
			Set_XSCRIPT_Parameter(1,tonumber(Stength_Item_Idx));
			Set_XSCRIPT_ParamCount(2);
		Send_XSCRIPT();
		Stength_Equip_Idx =-1;
		Stength_Item_Idx = -1;
	end
	if(g_FrameInfo == FrameInfoList.EXCHANGE_BANGGONG) then
		if(BangGong_Value < 0) then
			return
		end
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("BanggongExchange");
			Set_XSCRIPT_ScriptID(805009);
			Set_XSCRIPT_Parameter(0,BangGong_Value);
			Set_XSCRIPT_ParamCount(1);
		Send_XSCRIPT();
		BangGong_Value =-1;
	end
	if(g_FrameInfo == FrameInfoList.SHENGSICHALLENGE) then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("JieShouChallenge");
			Set_XSCRIPT_ScriptID(900034);
			Set_XSCRIPT_Parameter(0,nChallenge_2);
			Set_XSCRIPT_Parameter(1,nChallenge_3);
			Set_XSCRIPT_ParamCount(2);
		Send_XSCRIPT();	
	end
	if(g_FrameInfo == FrameInfoList.CSPS_FANGQI) then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("GiveUpTheBoss");
			Set_XSCRIPT_ScriptID(750001);
			Set_XSCRIPT_Parameter(0,nChallenge_1);
			Set_XSCRIPT_Parameter(1,nChallenge_2);
			Set_XSCRIPT_ParamCount(2);
		Send_XSCRIPT();	
	end
	if(g_FrameInfo == FrameInfoList.PUT_GUILDMONEY) then
		if(GuildMoney_Value < 0) then
			return
		end
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("PutGuildMoney");
			Set_XSCRIPT_ScriptID(805012);
			Set_XSCRIPT_Parameter(0,GuildMoney_Value);
			Set_XSCRIPT_ParamCount(1);
		Send_XSCRIPT();
		GuildMoney_Value =-1;
	end
	if(g_FrameInfo == FrameInfoList.CONFIRM_RE_IDENTIFY) then
		if(RID_Equip_Idx<0) then
			return
		end
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("FinishReAdjust");
			Set_XSCRIPT_ScriptID(809261);
			Set_XSCRIPT_Parameter(0,tonumber(RID_Equip_Idx));
			Set_XSCRIPT_ParamCount(1);
		Send_XSCRIPT();
		RID_Equip_Idx =-1;
	end
	if(g_FrameInfo == FrameInfoList.KICK_MEMBER_MSGBOX) then
		if(Member_Idx < 0) then
			return
		end
		Guild:SureKickGuild(tonumber(Member_Idx));
		Member_Idx =-1;
		Member_Name = "";
	end
	
	if (g_FrameInfo == FrameInfoList.TLZ_CONFIRM_SETPOS) then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("SetPosition");
			Set_XSCRIPT_ScriptID(330001);
			Set_XSCRIPT_Parameter(0, Client_ItemIndex);
			Set_XSCRIPT_ParamCount(1);
		Send_XSCRIPT();
	end
	
end

function MessageBox_OnOKClick()
	if( strMessageData == "EquipBind" ) then -- ��
		EquipItem( tonumber( strMessageArgs ),tonumber(strMessageArgs_2) );
	end
	this:Hide();
end
--===============================================
-- ���ȷ����IDOK��
--===============================================
function MessageBox_Self_OK_Clicked()
	
	if g_FrameInfo == FrameInfoList.SAFEBOX_LOCK_CONFIRM then
		SafeBox("reallock");
		this : Hide()
		return
	end

	if g_FrameInfo == FrameInfoList.SAFEBOX_UNLOCK_CONFIRM then
		SafeBox("realunlock");
		this : Hide()
		return
	end
	
	if g_FrameInfo == FrameInfoList.CITY_RANAME_CONFIRM then
		Guild : SendCityRnameMsg( g_arg_circ )
		this : Hide()
		return
	end

	if g_FrameInfo == FrameInfoList.CHAR_RANAME_CONFIRM then
		Target : SendCharRnameMsg( g_arg_chrc )
		this : Hide()
		return
	end	
	
	if g_FrameInfo == FrameInfoList.GEM_COMBINED_CONFIRM then
		LifeAbility : Do_Combine( GemCombinedData[1], GemCombinedData[2],
			GemCombinedData[3], GemCombinedData[4],
			GemCombinedData[5], GemCombinedData[6], 1 )
		this : Hide()
		return
	end
	
	if g_FrameInfo == FrameInfoList.ENCHASE_CONFIRM then
		LifeAbility : Do_Enchase( EnchaseData[1], EnchaseData[2],EnchaseData[3], EnchaseData[4])
		this:Hide()
		return
	end

-- add:lby20080527ȷ��4��ǶENCHASE_FOUR_CONFIRM
	if g_FrameInfo == FrameInfoList.ENCHASE_FOUR_CONFIRM then
		LifeAbility : Do_Enchase_Four( EnchaseData[1], EnchaseData[2],EnchaseData[3], EnchaseData[4])
		this:Hide()
		return
	end

	-- ����ѧϰ����ȷ�ϣ������ֶ�����ѧϰ
	if g_FrameInfo == FrameInfoList.PET_SKILL_STUDY_CONFIRM then
		Pet:ConfirmPetSkillStudy()
		this:Hide()
		return
	end

--	if g_FrameInfo == FrameInfoList.CARVE_CONFIRM then
--	  Clear_XSCRIPT();
--		Set_XSCRIPT_Function_Name(CarveData[1]);
--		Set_XSCRIPT_ScriptID(CarveData[2]);
--		Set_XSCRIPT_Parameter(0,CarveData[3]);
--		Set_XSCRIPT_Parameter(1,CarveData[4]);
--		Set_XSCRIPT_ParamCount(CarveData[5]);
--	  Send_XSCRIPT();
--		this:Hide()
--		return
--	end
	

	if(g_FrameInfo == FrameInfoList.STALL_RENT_FRAME) then
		--֪ͨ������������ʼ�������̯
		StallSale:AgreeBeginStall();

	elseif(g_FrameInfo == FrameInfoList.DISCARD_ITEM_FRAME) then
		--֪ͨ������Ʒ
		DiscardItem();

	elseif(g_FrameInfo == FrameInfoList.CANNT_DISCARD_ITEM) then
		--������Ʒ��������
		g_InitiativeClose = 1;
		this:Hide();
	
	elseif(g_FrameInfo == FrameInfoList.LOCK_ITEM_CONFIRM_FRAME) then
		--֪ͨ������Ʒ
		LockAfterConfirm();

	elseif(g_FrameInfo == FrameInfoList.FRAME_AFFIRM_SHOW) then
		--��������
		if(Quest_Number > -1) then
			QuestFrameMissionAbnegate(Quest_Number);
		end
		g_InitiativeClose = 1;
		this:Hide();


	elseif(g_FrameInfo == FrameInfoList.GUILD_CREATE_CONFIRM) then
		-- �����������ȷ��
		Guild:CreateGuildConfirm(1);
		this:Hide();
	elseif(g_FrameInfo == FrameInfoList.GUILD_DESTORY_CONFIRM) then
		-- �����������ȷ��
		Guild:CreateGuildConfirm(2);
		this:Hide();
	elseif(g_FrameInfo == FrameInfoList.GUILD_QUIT_CONFIRM) then
		-- �����������ȷ��
		Guild:CreateGuildConfirm(3);
		this:Hide();

	elseif(g_FrameInfo == FrameInfoList.NET_CLOSE_MESSAGE) then
		QuitApplication("quit");
		this:Hide();

	elseif(g_FrameInfo == FrameInfoList.PET_FREE_CONFIRM) then
		Pet : Go_Free(Pet_Number);
		this:Hide();

	elseif(g_FrameInfo == FrameInfoList.PS_RENAME_MESSAGE)  then
		--����̵������Ҫ�Ľ�Ǯ����
		PlayerShop:Modify("name_ok",g_szData);

	elseif(g_FrameInfo == FrameInfoList.PS_READ_MESSAGE)    then
		--����̵�������̵�˵����Ҫ�Ľ�Ǯ����
		PlayerShop:Modify("ad_ok",g_szData);

	elseif(g_FrameInfo == FrameInfoList.PS_ADD_BASE_MONEY)    then
		PlayerShop:ApplyMoney("immitbase_ok", g_nData);

	elseif(g_FrameInfo == FrameInfoList.PS_ADD_GAIN_MONEY)    then
		PlayerShop:ApplyMoney("immit_ok", g_nData);

	elseif(g_FrameInfo == FrameInfoList.SERVER_CONTROL)    then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name(Server_Script_Function);
			Set_XSCRIPT_ScriptID(Server_Script_ID);
			Set_XSCRIPT_Parameter(0,Server_Return_1);
			Set_XSCRIPT_Parameter(1,Server_Return_2);
			Set_XSCRIPT_ParamCount(2);
		Send_XSCRIPT();
	elseif(g_FrameInfo == FrameInfoList.PS_ADD_STALL)    then
		PlayerShop:ChangeShopNum("add_ok");
	end
	
	if( g_FrameInfo == FrameInfoList.EQUIP_ITEM ) then
		MessageBox_OnOKClick();
		return;
	end
	
	-- ȷ�Ͻ�ɢ����			add by WTT	20090212
	if g_FrameInfo == FrameInfoList.DISMISS_TEAM then
		Player:ConfirmDismissTeam()
		this:Hide()
		return
	end

	MessageBox_Self_OK_Clicked_Ex();
	this:Hide();
end

function MessageBox_Self_PetSyn_OK_Clicked()
	Pet:Syn_Do(g_CityData[1], g_CityData[2]);
	g_CityData = {};
end
--===============================================
-- ������̯(IDCONCEL)
--===============================================
function MessageBox_Self_Cancel_Clicked(bClick)
	if( 1 == bClick ) then
		--AxTrace( 0, 0, bClick )
		if( PVPFLAG.ACCEPTDUEL == g_FrameInfo ) then
			DuelAccept( tostring( PVPFLAG.DuelName ), tostring( PVPFLAG.DuelGUID ), 0 )
		end
    end

	if ( g_FrameInfo == FrameInfoList.DISCARD_ITEM_FRAME ) then
		--֪ͨ�������
		DiscardItemCancelLocked();

    elseif ( g_FrameInfo == FrameInfoList.LOCK_ITEM_CONFIRM_FRAME ) then
		--֪ͨ�������
		CancelLockAfterConfirm();

	elseif ( g_FrameInfo == FrameInfoList.GUILD_CREATE_CONFIRM ) then
		Guild:CreateGuildConfirm(0);
	elseif ( g_FrameInfo == FrameInfoList.GUILD_DESTORY_CONFIRM ) then
		Guild:CreateGuildConfirm(0);
	elseif ( g_FrameInfo == FrameInfoList.GUILD_QUIT_CONFIRM ) then
		Guild:CreateGuildConfirm(0);

	elseif(g_FrameInfo == FrameInfoList.NET_CLOSE_MESSAGE) then
		QuitApplication("quit");
	elseif( g_FrameInfo == FrameInfoList.CITY_CONFIRM ) then
		MessageBox_Self_City_Cancel_Clicked();
	elseif(g_FrameInfo == FrameInfoList.YUANBAO_BUY_ITEM) then
		g_CityData = {};
	-- add by zchw
	elseif g_FrameInfo == FrameInfoList.CONFIRM_REMOVE_STALL then
		this:Hide();
	-- zchw for pet procreate
	elseif g_FrameInfo == FrameInfoList.PET_PROCREATE_PROMPT then
		if bClick == 1 then
			PushEvent(462, 1); --PETPROCREATE_KEY_STATE
		end
		this:Hide();
	elseif( g_FrameInfo == FrameInfoList.SAVE_STALL_INFO ) then
		if bClick == 1 then
			StallSale:CloseStall("cancel");
			-- add by zchw
			StallSale:CloseStallMessage();
		end
		-- add by zchw
		StallSale:CloseStallMessage();
	elseif( g_FrameInfo == FrameInfoList.PET_SYNC_CONFIRM ) then
		g_CityData = {};
--	elseif( g_FrameInfo == FrameInfoList.SERVER_CONTROL ) then
--		Clear_XSCRIPT();
--			Set_XSCRIPT_Function_Name(Server_Script_Function);
--			Set_XSCRIPT_ScriptID(Server_Script_ID);
--			Set_XSCRIPT_Parameter(0,Server_Return_1);
--			Set_XSCRIPT_Parameter(1,-1);
--			Set_XSCRIPT_ParamCount(2);
--		Send_XSCRIPT();
	elseif(g_FrameInfo == FrameInfoList.OPEN_IS_SELL_TO_RECSHOP) then
		if(Recycle_Bag_idx ~=nil and tonumber(Recycle_Bag_idx)>0) then
			PlayerShop:CancelSellItem2RecycleShop(Recycle_Bag_idx);
		end
	end

	this:Hide();


end

function MessageBox_Self_Help()
	if( g_FrameInfo == FrameInfoList.NET_CLOSE_MESSAGE ) then
		Helper:GotoHelper( "61" );
	else
		Helper:GotoHelper("*MessageBox_Self");
	end
end