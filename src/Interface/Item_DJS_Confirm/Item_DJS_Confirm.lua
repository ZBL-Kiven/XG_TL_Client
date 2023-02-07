local g_FrameInfo = -1;
local g_Item_DJS_Confirm_Frame_UnifiedPosition;

local FrameInfoList =
{
		DJTS_CONFIRM_SETPOS = 265,							--	确认遁甲天书重新定位
		DJQS_CONFIRM_SETPOS = 266,							--	确认遁甲奇书重新定位
		DJTS_CONFIRM_CHUANSONG = 267,						--	确认遁甲天书传送
		DJQS_CONFIRM_CHUANSONG = 268,						--	确认遁甲奇书传送
		DJTS_CONFIRM_BUCHONG = 269,							--	确认遁甲天书补充符咒
		DJQS_CONFIRM_BUCHONG = 270,							--	确认遁甲奇书补充符咒
		
		DJVIP_CONFIRM_SETPOS = 271,							--	确认瞬影符箓重新定位
		DJVIP_CONFIRM_CHUANSONG = 272,						--	确认瞬影符箓传送
		DJTS_CONFIRM_BUCHONG_YUANBAO_BIND = 273,		--用绑定元宝增加彻地符箓的符咒
		DJTS_CONFIRM_BUCHONG_YUANBAO = 274,		--用元宝增加彻地符箓的符咒
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

	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	--离开游戏
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	--切换场景
	this:RegisterEvent("SCENE_TRANSED");
	--切换中
	this:RegisterEvent("ON_SCENE_TRANSING");
	this:RegisterEvent("UI_COMMAND");
	--遁甲天书定位确认
	this:RegisterEvent( "CONFIRM_SETPOS_DJTS" );
	--遁甲天书传送确认
	this:RegisterEvent( "CONFIRM_CHUANSONG_DJTS" );
	--遁甲天书补充符咒确认
	this:RegisterEvent( "CONFIRM_BUCHONG_DJTS" );


end

function Shop_Dresser_TimeOut()
	this:Hide()
end

--===============================================
-- OnEvent()
--===============================================
function Item_DJS_Confirm_OnEvent(event)
	-- 游戏窗口尺寸发生了变化
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
		Item_DJS_Confirm_Title:SetProperty("Image","set:Menpaishuxing image:DunJiaShu_Title_Index")--遁甲天书
		local itemIdx = tonumber(arg1)
		local iNum = tonumber(arg2);
    		Client_ItemIndex = itemIdx

		Item_DJS_Confirm_CancelLastOp(FrameInfoList.DJTS_CONFIRM_BUCHONG);
		g_FrameInfo = FrameInfoList.DJTS_CONFIRM_BUCHONG;

		local str;
		--if (iNum>10) then
		--	str= "#c000000您当前的符咒超过#c0f409c50点#c000000，彻地符箓存储的符咒上限为#c0f409c99点#c000000，继续补充符咒会使您的符咒溢出，溢出的符咒将会消失，是否确认补充符咒？"
		--else
			str= "#c000000使用一次“#c0f409c补充符咒#c000000”会消耗一个#c0f409c遁地符#c000000，同时增加#c0f409c20点#c000000符咒，是否确认补充符咒？"
		--end

		Item_DJS_Confirm_Info:SetText(str)
		Item_DJS_Confirm_UpdateRect();
		this:Show()
		return
	end
	
	if (event == "UI_COMMAND" and tonumber(arg0) == 2015111098) then
		Item_DJS_Confirm_Title:SetProperty("Image","set:Menpaishuxing image:DunJiaShu_Title_Index")--遁甲天书
		local itemIdx = tonumber(arg1)
		local iSelIdx = tonumber(arg2);
		local szSceneName = tostring(arg3);
        local iPosX = tonumber(arg4);
        local iPosZ = tonumber(arg5);

		Item_DJS_Confirm_CancelLastOp(FrameInfoList.DJTS_CONFIRM_CHUANSONG);
		g_FrameInfo = FrameInfoList.DJTS_CONFIRM_CHUANSONG;

		Client_ItemIndex = itemIdx
        DJS_SelIndex = iSelIdx

		local str = "#{DJTS_110509_14}".."\n"..szSceneName.."（"..iPosX.."，"..iPosZ.."）";
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
		Item_DJS_Confirm_Title:SetProperty("Image","set:Menpaishuxing image:DunJiaShu_Title_Index")--遁甲天书
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

		local str = "#{DJTS_110509_12}"..szSceneName.."（"..iPosX.."，"..iPosZ.."）".."#r".."#{DJTS_110509_13}"..curSceneName.."当前坐标"
        if (szSceneName == "") then
			str = "#{DJTS_110509_12}这个位置".."#r".."#{DJTS_110509_13}"..curSceneName.."当前坐标"
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
	--遁甲奇书
	if(event == "UI_COMMAND" and tonumber(arg0) == 2019051211) then
        Item_DJS_Confirm_Title:SetText("#{UIGZ_130816_1}") --遁甲奇书
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
        Item_DJS_Confirm_Title:SetText("#{UIGZ_130816_1}") --遁甲奇书
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
		
		local str = "#{DJTS_110509_12}"..szSceneName.."（"..iPosX.."，"..iPosZ.."）".."#r".."#{DJTS_110509_13}"..curSceneName.."当前坐标"
        if (szSceneName == "") then
			str = "#{DJTS_110509_12}这个位置".."#r".."#{DJTS_110509_13}"..curSceneName.."当前坐标"
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
        Item_DJS_Confirm_Title:SetText("#{UIGZ_130816_1}") --遁甲奇书
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
			str= "#{DJTS_110509_27}"..szSceneName.."（"..iPosX.."，"..iPosZ.."）"
		else
			str= "#{DJTS_110509_14}".."\n"..szSceneName.."（"..iPosX.."，"..iPosZ.."）"
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
-- 点击确定（IDOK）
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
		PlayerPackage:UseItem(Client_ItemIndex)	--遁甲天书的默认使用逻辑为传送....
	end
	if (g_FrameInfo == FrameInfoList.DJQS_CONFIRM_CHUANSONG) then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("SetUISelIdx");
			Set_XSCRIPT_ScriptID(330060);
			Set_XSCRIPT_Parameter(0, Client_ItemIndex)
			Set_XSCRIPT_Parameter(1, DJS_SelIndex)
			Set_XSCRIPT_ParamCount(2);
		Send_XSCRIPT();
		PlayerPackage:UseItem(Client_ItemIndex)	--遁甲奇书的默认使用逻辑为传送....
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
-- 恢复界面的默认相对位置
--================================================
function Item_DJS_Confirm_Frame_On_ResetPos()
  Item_DJS_Confirm_Frame:SetProperty("UnifiedPosition", g_Item_DJS_Confirm_Frame_UnifiedPosition);
end
