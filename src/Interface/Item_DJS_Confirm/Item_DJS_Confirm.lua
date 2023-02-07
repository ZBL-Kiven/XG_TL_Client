local g_FrameInfo = -1;
local g_Item_DJS_Confirm_Frame_UnifiedPosition;

local FrameInfoList =
{
		DJTS_CONFIRM_SETPOS = 265,							--	ȷ�϶ݼ��������¶�λ
		DJQS_CONFIRM_SETPOS = 266,							--	ȷ�϶ݼ��������¶�λ
		DJTS_CONFIRM_CHUANSONG = 267,						--	ȷ�϶ݼ����鴫��
		DJQS_CONFIRM_CHUANSONG = 268,						--	ȷ�϶ݼ����鴫��
		DJTS_CONFIRM_BUCHONG = 269,							--	ȷ�϶ݼ����鲹�����
		DJQS_CONFIRM_BUCHONG = 270,							--	ȷ�϶ݼ����鲹�����
		
		DJVIP_CONFIRM_SETPOS = 271,							--	ȷ��˲Ӱ�������¶�λ
		DJVIP_CONFIRM_CHUANSONG = 272,						--	ȷ��˲Ӱ��������
		DJTS_CONFIRM_BUCHONG_YUANBAO_BIND = 273,		--�ð�Ԫ�����ӳ��ط����ķ���
		DJTS_CONFIRM_BUCHONG_YUANBAO = 274,		--��Ԫ�����ӳ��ط����ķ���
};

local Client_ItemIndex = -1
local DJS_SelIndex = -1
--===============================================
-- OnLoad()
--===============================================
function Item_DJS_Confirm_OnLoad()
  g_Item_DJS_Confirm_Frame_UnifiedPosition=Item_DJS_Confirm_Frame:GetProperty("UnifiedPosition");
end

function  Item_DJS_Confirm_UpdateRect()
	local nWidth, nHeight = Item_DJS_Confirm_Info:GetWindowSize();
	local nTitleHeight = 36;
	local nBottomHeight = 75;
	nWindowHeight = nTitleHeight + nBottomHeight + nHeight;
end
g_PreLoad = 1
function Item_DJS_Confirm_CancelLastOp(str)
	if(this:IsVisible() and str ~= g_FrameInfo) then
		this:Hide()
	end
end
--===============================================
-- OnLoad()
--===============================================
function Item_DJS_Confirm_PreLoad()

	-- ��Ϸ���ڳߴ緢���˱仯
	this:RegisterEvent("ADJEST_UI_POS")
	-- ��Ϸ�ֱ��ʷ����˱仯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	--�뿪��Ϸ
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	--�л�����
	this:RegisterEvent("SCENE_TRANSED");
	--�л���
	this:RegisterEvent("ON_SCENE_TRANSING");
	this:RegisterEvent("UI_COMMAND");
	--�ݼ����鶨λȷ��
	this:RegisterEvent( "CONFIRM_SETPOS_DJTS" );
	--�ݼ����鴫��ȷ��
	this:RegisterEvent( "CONFIRM_CHUANSONG_DJTS" );
	--�ݼ����鲹�����ȷ��
	this:RegisterEvent( "CONFIRM_BUCHONG_DJTS" );


end

function Shop_Dresser_TimeOut()
	this:Hide()
end

--===============================================
-- OnEvent()
--===============================================
function Item_DJS_Confirm_OnEvent(event)
	-- ��Ϸ���ڳߴ緢���˱仯
	if (event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED") then
		Item_DJS_Confirm_Frame_On_ResetPos()
		return
	end
	if event == "PLAYER_LEAVE_WORLD" or event == "SCENE_TRANSED" or event == "ON_SCENE_TRANSING" then
		if( this:IsVisible() ) then
			this:Hide()
			return
		end
	end
	
	if (event == "UI_COMMAND" and tonumber(arg0) == 2015111097) then
		Item_DJS_Confirm_Title:SetProperty("Image","set:Menpaishuxing image:DunJiaShu_Title_Index")--�ݼ�����
		local itemIdx = tonumber(arg1)
		local iNum = tonumber(arg2);
    		Client_ItemIndex = itemIdx

		Item_DJS_Confirm_CancelLastOp(FrameInfoList.DJTS_CONFIRM_BUCHONG);
		g_FrameInfo = FrameInfoList.DJTS_CONFIRM_BUCHONG;

		local str;
		--if (iNum>10) then
		--	str= "#c000000����ǰ�ķ��䳬��#c0f409c50��#c000000�����ط����洢�ķ�������Ϊ#c0f409c99��#c000000��������������ʹ���ķ������������ķ��佫����ʧ���Ƿ�ȷ�ϲ�����䣿"
		--else
			str= "#c000000ʹ��һ�Ρ�#c0f409c�������#c000000��������һ��#c0f409c�ݵط�#c000000��ͬʱ����#c0f409c20��#c000000���䣬�Ƿ�ȷ�ϲ�����䣿"
		--end

		Item_DJS_Confirm_Info:SetText(str)
		Item_DJS_Confirm_UpdateRect();
		this:Show()
		return
	end
	
	if (event == "UI_COMMAND" and tonumber(arg0) == 2015111098) then
		Item_DJS_Confirm_Title:SetProperty("Image","set:Menpaishuxing image:DunJiaShu_Title_Index")--�ݼ�����
		local itemIdx = tonumber(arg1)
		local iSelIdx = tonumber(arg2);
		local szSceneName = tostring(arg3);
        local iPosX = tonumber(arg4);
        local iPosZ = tonumber(arg5);

		Item_DJS_Confirm_CancelLastOp(FrameInfoList.DJTS_CONFIRM_CHUANSONG);
		g_FrameInfo = FrameInfoList.DJTS_CONFIRM_CHUANSONG;

		Client_ItemIndex = itemIdx
        DJS_SelIndex = iSelIdx

		local str = "#{DJTS_110509_14}".."\n"..szSceneName.."��"..iPosX.."��"..iPosZ.."��";
		if (szSceneName ~= "") then
			Item_DJS_Confirm_Info:SetText(str)
			Item_DJS_Confirm_UpdateRect();
			this:Show();
			return
		else
		   PushDebugMessage("#{DJTS_110509_31}")
		   this:Hide()
		   return
		end
	end
	
	if (event == "UI_COMMAND" and tonumber(arg0) == 2015111099) then
		Item_DJS_Confirm_Title:SetProperty("Image","set:Menpaishuxing image:DunJiaShu_Title_Index")--�ݼ�����
		local itemIdx = tonumber(arg1)
		local iSelIdx = tonumber(arg2);
		local szSceneName = tostring(arg3);
        local iPosX = tonumber(arg4);
        local iPosZ = tonumber(arg5);

		Item_DJS_Confirm_CancelLastOp(FrameInfoList.DJTS_CONFIRM_SETPOS)

		g_FrameInfo = FrameInfoList.DJTS_CONFIRM_SETPOS

		Client_ItemIndex = itemIdx
		DJS_SelIndex = iSelIdx

		local curSceneName = GetCurrentSceneName()

		local str = "#{DJTS_110509_12}"..szSceneName.."��"..iPosX.."��"..iPosZ.."��".."#r".."#{DJTS_110509_13}"..curSceneName.."��ǰ����"
        if (szSceneName == "") then
			str = "#{DJTS_110509_12}���λ��".."#r".."#{DJTS_110509_13}"..curSceneName.."��ǰ����"
		end
		if (szSceneName ~= "") then
			Item_DJS_Confirm_Info:SetText(str);
			Item_DJS_Confirm_UpdateRect();
			this:Show();
		  return
		  else
			Item_DJS_Confirm_Info:SetText(str);
			Item_DJS_Confirm_UpdateRect();
			this:Show()
			return
		end
	end
	--�ݼ�����
	if(event == "UI_COMMAND" and tonumber(arg0) == 2019051211) then
        Item_DJS_Confirm_Title:SetText("#{UIGZ_130816_1}") --�ݼ�����
		local itemIdx = tonumber(arg1)
		local iNum = tonumber(arg2);
    		Client_ItemIndex = itemIdx

		Item_DJS_Confirm_CancelLastOp(FrameInfoList.DJQS_CONFIRM_BUCHONG);
		g_FrameInfo = FrameInfoList.DJQS_CONFIRM_BUCHONG;

		local str;
		if (iNum>10) then
			str= "#{DJTS_110509_11}"
		else
			str= "#{DJTS_110509_10}"
		end

		Item_DJS_Confirm_Info:SetText(str)
		Item_DJS_Confirm_UpdateRect()
		this:Show()
		return
	end
	if (event == "UI_COMMAND" and tonumber(arg0) == 2019051212) then
        Item_DJS_Confirm_Title:SetText("#{UIGZ_130816_1}") --�ݼ�����
		local itemIdx = tonumber(arg1)
		local iSelIdx = tonumber(arg2);
		local szSceneName = tostring(arg3);
        local iPosX = tonumber(arg4);
        local iPosZ = tonumber(arg5);

		Item_DJS_Confirm_CancelLastOp(FrameInfoList.DJQS_CONFIRM_SETPOS)

		g_FrameInfo = FrameInfoList.DJQS_CONFIRM_SETPOS

		Client_ItemIndex = itemIdx
		DJS_SelIndex = iSelIdx

		local curSceneName = GetCurrentSceneName()
		
		local str = "#{DJTS_110509_12}"..szSceneName.."��"..iPosX.."��"..iPosZ.."��".."#r".."#{DJTS_110509_13}"..curSceneName.."��ǰ����"
        if (szSceneName == "") then
			str = "#{DJTS_110509_12}���λ��".."#r".."#{DJTS_110509_13}"..curSceneName.."��ǰ����"
		end
		if (szSceneName ~= "") then
			Item_DJS_Confirm_Info:SetText(str);
			Item_DJS_Confirm_UpdateRect();
			this:Show();
		  return
		  else
			Item_DJS_Confirm_Info:SetText(str);
			Item_DJS_Confirm_UpdateRect();
			this:Show()
			return
		end
	end
	if (event == "UI_COMMAND" and tonumber(arg0) == 2019051213) then
        Item_DJS_Confirm_Title:SetText("#{UIGZ_130816_1}") --�ݼ�����
		local itemIdx = tonumber(arg1)
		local iSelIdx = tonumber(arg2);
		local szSceneName = tostring(arg3);
        local iPosX = tonumber(arg4);
        local iPosZ = tonumber(arg5);

		Item_DJS_Confirm_CancelLastOp(FrameInfoList.DJQS_CONFIRM_CHUANSONG);
		g_FrameInfo = FrameInfoList.DJQS_CONFIRM_CHUANSONG;

		Client_ItemIndex = itemIdx
        DJS_SelIndex = iSelIdx
		
		local str;
		local iIsLeader = Player:IsLeader()
		if (1 == iIsLeader) then
			str= "#{DJTS_110509_27}"..szSceneName.."��"..iPosX.."��"..iPosZ.."��"
		else
			str= "#{DJTS_110509_14}".."\n"..szSceneName.."��"..iPosX.."��"..iPosZ.."��"
		end
		if (szSceneName ~= "") then
			Item_DJS_Confirm_Info:SetText(str)
			Item_DJS_Confirm_UpdateRect();
			this:Show();
			return
		else
		   PushDebugMessage("#{DJTS_110509_31}")
		   this:Hide()
		   return
		end
	end
end

--===============================================
-- ���ȷ����IDOK��
--===============================================
function Item_DJS_Confirm_Queding_Clicked()

	if (g_FrameInfo == FrameInfoList.DJTS_CONFIRM_SETPOS) then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("SetPosition");
			Set_XSCRIPT_ScriptID(330060);
			Set_XSCRIPT_Parameter(0, Client_ItemIndex)
			Set_XSCRIPT_Parameter(1, DJS_SelIndex)
			Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT();
	end
	if (g_FrameInfo == FrameInfoList.DJQS_CONFIRM_SETPOS) then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("SetPosition");
			Set_XSCRIPT_ScriptID(330060);
			Set_XSCRIPT_Parameter(0, Client_ItemIndex)
			Set_XSCRIPT_Parameter(1, DJS_SelIndex)
			Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT();
	end

	if (g_FrameInfo == FrameInfoList.DJTS_CONFIRM_CHUANSONG) then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("SetUISelIdx");
			Set_XSCRIPT_ScriptID(330060);
			Set_XSCRIPT_Parameter(0, Client_ItemIndex)
			Set_XSCRIPT_Parameter(1, DJS_SelIndex)
			Set_XSCRIPT_ParamCount(2);
		Send_XSCRIPT();
		PlayerPackage:UseItem(Client_ItemIndex)	--�ݼ������Ĭ��ʹ���߼�Ϊ����....
	end
	if (g_FrameInfo == FrameInfoList.DJQS_CONFIRM_CHUANSONG) then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("SetUISelIdx");
			Set_XSCRIPT_ScriptID(330060);
			Set_XSCRIPT_Parameter(0, Client_ItemIndex)
			Set_XSCRIPT_Parameter(1, DJS_SelIndex)
			Set_XSCRIPT_ParamCount(2);
		Send_XSCRIPT();
		PlayerPackage:UseItem(Client_ItemIndex)	--�ݼ������Ĭ��ʹ���߼�Ϊ����....
	end
	if (g_FrameInfo == FrameInfoList.DJTS_CONFIRM_BUCHONG) then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("AddFuZhou");
			Set_XSCRIPT_ScriptID(330060);
			Set_XSCRIPT_Parameter(0, Client_ItemIndex)
			Set_XSCRIPT_ParamCount(1);
		Send_XSCRIPT();
	end
	if (g_FrameInfo == FrameInfoList.DJQS_CONFIRM_BUCHONG) then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("AddFuZhou");
			Set_XSCRIPT_ScriptID(330060);
			Set_XSCRIPT_Parameter(0, Client_ItemIndex)
			Set_XSCRIPT_ParamCount(1);
		Send_XSCRIPT();
	end
	this:Hide();
end

--================================================
-- �ָ������Ĭ�����λ��
--================================================
function Item_DJS_Confirm_Frame_On_ResetPos()
  Item_DJS_Confirm_Frame:SetProperty("UnifiedPosition", g_Item_DJS_Confirm_Frame_UnifiedPosition);
end
