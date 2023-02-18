--征友平台，征友玩家列表 cuiyinjie 2008.10.20
-- 列表请求过程： lua脚本发送请求的类型与页， 服务器返回后客户端pushevent告诉lua，lua然后取数量再一条条取信息显示在列表

-- 频道类型和性别定义
local g_Genders = { "女", "男" };
local g_Channels = {"#{ZYPT_081103_008}", "#{ZYPT_081103_009}", "#{ZYPT_081103_010}", "#{ZYPT_081103_011}",}; --{"郎才女貌", "拉帮结伙", "拜师寻徒", "义结金兰"};
local g_TypesDesc = {"郎才女貌", "拉帮结伙", "拜师寻徒", "义结金兰"};   --发邮件时无法转义
local g_MenPaiName = {"少林", "明教", "丐帮", "武当", "峨嵋", "星宿", "天龙", "天山", "逍遥", "无门派"};
local g_MarryDesc = {"未婚", "已婚"};
--local g_ZhengyouMudi = { {"任意","帮派收人","寻找帮派",}, {"任意","拜师","收徒",},};

-- 此条件和征友要求里定义一致，要同时更改,记得下标加1
local g_Conditions = {
	MenPai = {"全部", "少林", "明教", "丐帮", "武当", "峨嵋", "星宿", "天龙", "天山", "逍遥"},
	Level = {"任意", "10级以下", "10到20级", "20到30级", "30到40级", "40到50级", "50到60级", "60到70级", "70到80级", "80到90级", "90到100级", "100级以上"},
	Sexy = {"不限", "男", "女"},
	Mudi = { {"任意","帮派收人","寻找帮派",}, {"任意","拜师","收徒",},}, 
};

-- 稍等点击的提示
local g_strWaitClickTipText = "#{ZYPT_081127_2}"; --"不可连续点击，请稍等片刻后再点击。";

-- 当前频道类别与页码
local g_totalPlayerCount = 1
local g_curChannel = 0
local g_curPageIndex = 1
local g_totalPageCount = 1

-- 当前玩家管理的征友类型
local g_curZhengyouType = 1; 

-- 当前查询结果类型，用于显示提示信息 
local g_curSearchResultType = -1; 

local MAXPAGECOUNT 		= 200;
local MAXCOUNTPERPAGE 	= 20;
local LEVEL_LIMIT 		= 10;						--10级以下无法打开

-- 执行查询和具体操作的类型
local OPT_FABU 			= 1;
local OPT_CHEXIAO 		= 2;
local OPT_EDIT  		= 3;

local OPT_VOTE			= 1;
local OPT_VIEWVOTE		= 2;

local OPT_CHECK_EDIT	= 3;
local OPT_CHECK_FABU    = 4;
local OPT_CHECK_CHEXIAO = 5;
local OPT_CHECK_GUANLI  = 6;

-- 界面控件
local BtnPageUpDown = {};
local g_Ctrls = {};

-- 冷却时间相关 
local g_iLastTime = 0;

local g_Timers = {0, 0, 0, 0, 0}; -- 冷却时间分组
local TIMER_TAB = 1;     --tab页     timer的索引值
local TIMER_SEARCH = 2;  --查找
local TIMER_UPDATE = 3; --刷新
local TIMER_COMMONBTN = 4; --一般按钮

local MIN_TABTIME = 3; --按tab的时间 
local MIN_SEARCHTIME = 10; 
local MIN_BTNTIME = 3; --点功能按钮的间隔 （秒） 
local MIN_UPDATETIME = 3;

function PlayerZhengyouPT_PreLoad()
	this:RegisterEvent("OPEN_WINDOW");
	this:RegisterEvent("UPDATE_FINDFRIEND_LIST"); -- 总条数，当前页条数
	this:RegisterEvent("ZHENGYOUPT_RESPONSE_PLAYERDETAILINFO");  -- 显示细节信息
	this:RegisterEvent("ZHENGYOUPT_RESPONSE_QUERYRESULT");
	this:RegisterEvent("ZHENGYOUPT_FOCUSROW");
	this:RegisterEvent("ZHENGYOUPT_RESPONSE_SEARCHPLAYERLIST");  -- 显示 

end

function PlayerZhengyouPT_GetTypeName(eType)
	if PlayerZhengyouPT_IsRealType(eType) then
		return g_Channels[eType];
	end
	return "#{ZYPT_081103_007}" --"全部";
end

function PlayerZhengyouPT_GetGenderDesc(eSex)
	if ( 0 == eSex ) then
		return g_Genders[1];
	else
		return g_Genders[2];
	end
end

function PlayerZhengyouPT_GetMarryDesc(iMarry)
	if ( 0 == iMarry ) then
		return g_MarryDesc[1];
	else
		return g_MarryDesc[2];
	end
end

function PlayerZhengyouPT_GetMenpaiName(iMenpai)
	if ( iMenpai >= 0 and iMenpai < 10 ) then
		return g_MenPaiName[iMenpai + 1];
	end
	return "";
end

-- 取得门派需求描述
function  PlayerZhengyouPT_GetMenpaiNeedDesc(iRet)
	local sDesc = g_Conditions.MenPai[iRet + 1];
	if ( nil ~= sDesc ) then
	    return sDesc;
	else
	    return "";
	end
end

-- 取得性别需求描述
function  PlayerZhengyouPT_GetSexyNeedDesc(iRet)
	local sDesc = g_Conditions.Sexy[iRet + 1];
	if ( nil ~= sDesc ) then
	    return sDesc;
	else
	    return "";
	end
end

-- 取得等级需求描述
function  PlayerZhengyouPT_GetLevelNeedDesc(iRet)
	local sDesc = g_Conditions.Level[iRet + 1];
	if ( nil ~= sDesc ) then
	    return sDesc;
	else
	    return "";
	end
end

-- 征友目的描述
-- 输入：征友类型，目的 
function  PlayerZhengyouPT_GetZhengyouMudiDesc(iAdtype, iMudi)
    local iIdx = 0;
    if ( 2 == tonumber(iAdtype) ) then 
       PlayerZhengyouPT_Text4:Show();
       iIdx = 1;
       iMudi = iMudi - 1;
    elseif( 3 == tonumber(iAdtype) ) then
       PlayerZhengyouPT_Text4:Show();
       iIdx = 2;
       iMudi = iMudi - 4;
    else
       PlayerZhengyouPT_Text4:Hide();
       return "征友交际";
    end
	local sDesc = g_Conditions.Mudi[iIdx][iMudi + 1];
	if ( nil ~= sDesc ) then
	    return sDesc;
	else
	    return "征友交际";
	end
end 


function PlayerZhengyouPT_OnLoad()
    BtnPageUpDown = {PlayerZhengyouPT_PageUp, PlayerZhengyouPT_PageDown};
    g_Ctrls = {
        TxtName 	= PlayerZhengyouPT_Info2,     -- 个人信息
        TxtSexy 	= PlayerZhengyouPT_Info3,
        TxtLevel 	= PlayerZhengyouPT_Info4,
        TxtMenpai 	= PlayerZhengyouPT_Info5,
        
 		TxtBangpai 	= PlayerZhengyouPT_Info6,
        TxtMarry 	= PlayerZhengyouPT_Info7,
        TxtFabuTime	= PlayerZhengyouPT_Info8,   -- 发布时间
        TxtShyuTime = PlayerZhengyouPT_Info9,   -- 剩余时间
        
		TxtSexyNeed   = PlayerZhengyouPT_Text1,   -- 个人要求
		TxtLevelNeed  = PlayerZhengyouPT_Text2,
		TxtMenpaiNeed = PlayerZhengyouPT_Text3,
		TxtZhengyouMudi = PlayerZhengyouPT_Text4,
		
		TxtRenqi1     = PlayerZhengyouPT_Info_1,  -- 人气显示
		TxtRenqi2     = PlayerZhengyouPT_Info_2,
		TxtRenqi3     = PlayerZhengyouPT_Info_3,
		TxtRenqi4     = PlayerZhengyouPT_Info_4,
		
		CtrlList	  = PlayerZhengyouPT_List,
		
		BtnChangeInfo = PlayerZhengyouPT_Change,
		
		TabSearch	  = PlayerZhengyouPT_Tab6,
		
		TxtVoteFull	  = PlayerZhengyouPT_Info12,
		
		TxtSearchResultTip = PlayerZhengyouPT_ResultInfo,
		
		Tabs		  = {
						 PlayerZhengyouPT_Tab1,
						 PlayerZhengyouPT_Tab2,
						 PlayerZhengyouPT_Tab3,
						 PlayerZhengyouPT_Tab4,
						 PlayerZhengyouPT_Tab5,
						 PlayerZhengyouPT_Tab6,
						 },
    };
    
    g_Ctrls.TxtVoteFull:Hide(); --投票已满信息要隐藏 
    PlayerZhengyouPT_PageHeader:SetText("#{ZYPT_081103_006}");
end

-- 通知脚本去客户端取详细信息
function PlayerZhengyouPT_NotifyPlayerDetailInfo(sResult, sMyInfo, sType)
	if ( "ok" ~= sResult ) then
	   -- 没有正常返回细节信息则需清空显示
	   PlayerZhengyouPT_CleanDetailInfo();
	   PushDebugMessage("对不起，无此玩家信息");    -- 调试信息，应该不会执行到
	   return;
	end
	if ( "myinfo" == sMyInfo ) then
	   g_curZhengyouType = tonumber(sType);
	   g_Ctrls.BtnChangeInfo:Show();
	else
	   g_Ctrls.BtnChangeInfo:Hide();
	end
	local iSexy = FindFriendDataPool:GetDetailInfo("SEX");
	local iMenpai = FindFriendDataPool:GetDetailInfo("MENPAI");
	local iMarry = FindFriendDataPool:GetDetailInfo("MARRY");
	local sFabuTime, sSpareTime = FindFriendDataPool:GetDetailInfo("SENDTIME");
	local iLevelNeed, iMenpaiNeed, iSexyNeed, iZhengyouMudi = FindFriendDataPool:GetDetailInfo("CONDITION");
	local iRenqi1, iRenqi2, iRenqi3, iRenqi4 = FindFriendDataPool:GetDetailInfo("HOTLEVEL");
	
    g_Ctrls.TxtName:SetText( "#{ZYPT_081103_024}" .. FindFriendDataPool:GetDetailInfo("NAME") );
    g_Ctrls.TxtSexy:SetText( "#{ZYPT_081103_035}" .. PlayerZhengyouPT_GetGenderDesc(iSexy) );
    g_Ctrls.TxtMarry:SetText( "#{ZYPT_081103_027}" .. PlayerZhengyouPT_GetMarryDesc(iMarry) );
    g_Ctrls.TxtLevel:SetText( "#{ZYPT_081103_025}" .. FindFriendDataPool:GetDetailInfo("LEVEL") );
    g_Ctrls.TxtMenpai:SetText( "#{ZYPT_081103_026}" .. PlayerZhengyouPT_GetMenpaiName(iMenpai) );
	g_Ctrls.TxtBangpai:SetText( "#{ZYPT_081103_028}" .. FindFriendDataPool:GetDetailInfo("GUILD") );
	g_Ctrls.TxtFabuTime:SetText( "#{ZYPT_081103_029}" .. sFabuTime );
	g_Ctrls.TxtShyuTime:SetText( "#{ZYPT_081103_030}" .. sSpareTime .."天");
	
	g_Ctrls.TxtSexyNeed:SetText( "#{ZYPT_081103_035}" .. PlayerZhengyouPT_GetSexyNeedDesc(iSexyNeed) );
    g_Ctrls.TxtLevelNeed:SetText( "#{ZYPT_081103_036}" .. PlayerZhengyouPT_GetLevelNeedDesc(iLevelNeed) );
    g_Ctrls.TxtMenpaiNeed:SetText( "#{ZYPT_081103_037}" .. PlayerZhengyouPT_GetMenpaiNeedDesc(iMenpaiNeed) );
    g_Ctrls.TxtZhengyouMudi:SetText( "目的：" .. PlayerZhengyouPT_GetZhengyouMudiDesc(sType, iZhengyouMudi) );
    
    g_Ctrls.TxtRenqi1:SetText( tostring(iRenqi1) );
    g_Ctrls.TxtRenqi2:SetText( tostring(iRenqi2) );
    g_Ctrls.TxtRenqi3:SetText( tostring(iRenqi3) );
    g_Ctrls.TxtRenqi4:SetText( tostring(iRenqi4) );
end

function  PlayerZhengyouPT_CleanDetailInfo()
    g_Ctrls.TxtName:SetText( "#{ZYPT_081103_024}" );
    g_Ctrls.TxtSexy:SetText( "#{ZYPT_081103_035}" );
    g_Ctrls.TxtMarry:SetText( "#{ZYPT_081103_027}" );
    g_Ctrls.TxtLevel:SetText( "#{ZYPT_081103_025}" );
    g_Ctrls.TxtMenpai:SetText( "#{ZYPT_081103_026}" );
	g_Ctrls.TxtBangpai:SetText( "#{ZYPT_081103_028}" );
	g_Ctrls.TxtFabuTime:SetText( "#{ZYPT_081103_029}" );
	g_Ctrls.TxtShyuTime:SetText( "#{ZYPT_081103_030}" );

	g_Ctrls.TxtSexyNeed:SetText( "#{ZYPT_081103_035}" );
    g_Ctrls.TxtLevelNeed:SetText( "#{ZYPT_081103_036}"  );
    g_Ctrls.TxtMenpaiNeed:SetText( "#{ZYPT_081103_037}"  );
    g_Ctrls.TxtZhengyouMudi:SetText( "" );

    g_Ctrls.TxtRenqi1:SetText( "" );
    g_Ctrls.TxtRenqi2:SetText( "" );
    g_Ctrls.TxtRenqi3:SetText( "" );
    g_Ctrls.TxtRenqi4:SetText( "" );
    
    g_Ctrls.BtnChangeInfo:Hide();
end

function PlayerZhengyouPT_OnEvent(event)
	if(event == "OPEN_WINDOW") then
		if( arg0 == "PlayerZhengyouPTWindow") then
			--如果已经显示就应该关掉
			if ( this:IsVisible() ) then
			   this:Hide();
			   return;
			end
			CloseWindow("ZhengyouWindow");
			InitAndShowZhengyouWindow();
		end
	
	elseif(event == "CLOSE_WINDOW") then
		if( arg0 == "PlayerZhengyouPTWindow") then
			this:Hide();
		end	
	elseif(event == "UPDATE_FINDFRIEND_LIST") then
		PlayerZhengyouPT_UpdateFriendList(arg0, arg1);	
	elseif (event == "ZHENGYOUPT_RESPONSE_QUERYRESULT") then
	    PlayerZhengyouPT_OnQueryResponse(arg0, arg1, arg2, arg3);
	elseif ("ZHENGYOUPT_RESPONSE_PLAYERDETAILINFO" 	== event) then
	    PlayerZhengyouPT_NotifyPlayerDetailInfo(arg0, arg1, arg2);
	elseif ("ZHENGYOUPT_FOCUSROW" == event) then
	    PlayerZhengyouPT_SetFocusRowAndPageNo(arg0, arg1);
	elseif ("ZHENGYOUPT_RESPONSE_SEARCHPLAYERLIST" == event ) then
		PlayerZhengyouPT_OnSearchPlayerResponse(arg0, arg2); -- 第3个参数表示类型，为int值
	end
end

function InitAndShowZhengyouWindow()
	PlayerZhengyouPT_UpdateBtnStatus();
	PlayerZhengyouPT_CleanPlayerList(); --需要先清除列表，防止显示无用的
	PlayerZhengyouPT_SetCurrentTab(0);
	this:Show();
	-- 此处请求显示全部类型的列表
	RequestFindFriendList(g_curChannel, g_curPageIndex); -- 0类型，第1页
end

--更新玩家列表
function PlayerZhengyouPT_UpdateFriendList(iTotal, iTotalOfCurPage)
    PlayerZhengyouPT_CleanPlayerList();
	g_totalPlayerCount = iTotal; --根据此类型玩家总数计算页数
	g_totalPageCount = math.floor(g_totalPlayerCount / MAXCOUNTPERPAGE) + 1;
	if(g_totalPageCount > MAXPAGECOUNT) then
		g_totalPageCount = MAXPAGECOUNT;
	end
	local playercount = iTotalOfCurPage;
	local i = 0;
	for i = 0, playercount -1 do
		local iGuid, strName, iGender, iRenqi, iType, iLevel = PlayerZhengyouPT_GetPlayerSimpleInfo(i);
		--AxTrace(0,0,"".. iGuid.." "..strName.." "..iGender.." "..iRenqi.." "..iType.." "..iLevel);
		PlayerZhengyouPT_List:AddNewItem(strName, 0, i);
		-- 全部和查找时显示类型， 具体类型里显示等级 
		if ( 0 == g_curChannel or 5 == g_curChannel ) then
		    PlayerZhengyouPT_List:AddNewItem(PlayerZhengyouPT_GetTypeName(iType), 1, i);
		else
		    PlayerZhengyouPT_List:AddNewItem(iLevel, 1, i);			
		end
		
		PlayerZhengyouPT_List:AddNewItem(PlayerZhengyouPT_GetGenderDesc(iGender), 2, i);
		-- 根据人气加标记
		local strRenqi;
		if (iRenqi >= 80) then
		    strRenqi = tostring(iRenqi) .. "" .. "#cff0000（满）";
		elseif ( iRenqi >= 60 ) then
		    strRenqi = tostring(iRenqi) .. "" .. "#cff6633（热）";
		else
            strRenqi = tostring(iRenqi);
		end
		PlayerZhengyouPT_List:AddNewItem(strRenqi, 3, i);
		
	end
	PlayerZhengyouPT_UpdateBtnStatus();
end

function PlayerZhengyouPT_GetPlayerSimpleInfo(iIdx)
	return FindFriendDataPool:GetSimpleInfoByPos(iIdx);
end

--	翻页
function OnPlayerZhengyouPT_PageUpClicked()
	if not PlayerZhengyouPT_PassTime(TIMER_COMMONBTN, MIN_BTNTIME) then
		PushDebugMessage(g_strWaitClickTipText);
		return
	end
	
	g_curPageIndex = g_curPageIndex - 1;
	PlayerZhengyouPT_UpdateBtnStatus();
	if ( g_curPageIndex < 1 ) then g_curPageIndex = 1; end
	RequestFindFriendList(g_curChannel, g_curPageIndex);
end

function OnPlayerZhengyouPT_PageDownClicked()
	if not PlayerZhengyouPT_PassTime(TIMER_COMMONBTN, MIN_BTNTIME) then
		PushDebugMessage(g_strWaitClickTipText);
		return
	end
	
	g_curPageIndex = g_curPageIndex + 1;
	PlayerZhengyouPT_UpdateBtnStatus();
	RequestFindFriendList(g_curChannel, g_curPageIndex);
end

function PlayerZhengyouPT_UpdateBtnStatus()
	if( g_curPageIndex <= 1 ) then
		BtnPageUpDown[1]:Disable();
		PlayerZhengyouPT_FirstPage:Disable();
	end
	if( g_curPageIndex >= g_totalPageCount ) then
		BtnPageUpDown[2]:Disable();
		PlayerZhengyouPT_LastPage:Disable();
	end
	if (g_curPageIndex > 1 ) then 
		BtnPageUpDown[1]:Enable(); 
		PlayerZhengyouPT_FirstPage:Enable();
	end
	if (g_curPageIndex < g_totalPageCount ) then 
		BtnPageUpDown[2]:Enable(); 
		PlayerZhengyouPT_LastPage:Enable();
	end
	
	local curPage = g_curPageIndex;
	if ( curPage > g_totalPageCount ) then curPage = g_totalPageCount; end
	PlayerZhengyouPT_Amount:SetText(curPage.."/"..g_totalPageCount);
	PlayerZhengyouPT_GotoEditBox:SetText(tostring(g_curPageIndex));
end

function PlayerZhengyouPT_PassTime(iIdx, iSeconds)
   local iCur = FindFriendDataPool:GetTickCount();
   if ( iCur - g_Timers[iIdx] < iSeconds * 1000) then
      return false;
   else
      g_Timers[iIdx] = iCur;
   	  return true;
   end
end 

-- 选择不同的标签的显示 ,  此处应延时，防止连续点击
function PlayerZhengyouPT_ChannalChange(iChannel)
	-- 点击当前选中的标签应该无操作
	if (g_curChannel == iChannel) then
		return;
	end
	-- 不能过频切换标签
	if not PlayerZhengyouPT_PassTime(TIMER_TAB, MIN_TABTIME) then
		--PlayerZhengyouPT_SetCurrentTab(g_curChannel);
       		g_Ctrls.Tabs[g_curChannel + 1]:SetCheck(1);
		PushDebugMessage(g_strWaitClickTipText);
		return
	end
	
	PlayerZhengyouPT_CleanPlayerList();
	
	-- 点到查询tab时应清除列表但不提交请求
	--if ( 5 == iChannel ) then
	   --return;
	--end 
	
	g_curChannel 		= iChannel;
	g_curPageIndex 		= 1;
	g_totalPageCount 	= 0;
	
	PlayerZhengyouPT_UpdateBtnStatus(); --防止点到空页时按钮没变灰 
	
	PlayerZhengyouPT_SetCurrentTab(iChannel);
	
	RequestFindFriendList(g_curChannel, g_curPageIndex); -- 类型，页
end

-- 全部的状态下打开发布信息界面，在具体类型标签下打开条件设定界面
function OnPlayerZhengyouPT_FabuClicked()
	local level = Player:GetData("LEVEL");
	if level < LEVEL_LIMIT then
		PushDebugMessage("对不起，必须等级达到" .. LEVEL_LIMIT .. "级才可以发布" .. PlayerZhengyouPT_GetTypeName(g_curChannel) .. "信息。");
		return;
	end
	-- 选择了具体类型则直接查询是否满足发布条件，否则打开类型选择界面
	if ( not PlayerZhengyouPT_SendCheckRequest(g_curChannel, OPT_CHECK_FABU) ) then
		OpenWindow("ZhengyouInfoFabu_fabu"); --没选择操作类型
	end
end

-- 全部的状态下打开发布信息界面，在具体类型标签下打开条件设定界面
function OnPlayerZhengyouPT_ChexiaoClicked()
	if ( not PlayerZhengyouPT_SendCheckRequest(g_curChannel, OPT_CHECK_CHEXIAO) ) then
		OpenWindow("ZhengyouInfoFabu_chexiao");
	end
end

-- 全部的状态下打开发布信息界面，在具体类型标签下打开条件设定界面
function OnPlayerZhengyouPT_GuanliClicked()
	if not PlayerZhengyouPT_PassTime(TIMER_COMMONBTN, MIN_BTNTIME) then
		PushDebugMessage(g_strWaitClickTipText);
		return
	end
	
	if ( not PlayerZhengyouPT_SendCheckRequest(g_curChannel, OPT_CHECK_GUANLI) ) then
		OpenWindow("ZhengyouInfoFabu_guanli");
	end
end

-- 执行发布，撤销或管理的请求
-- eType : 征友类型
-- opt   : 执行的请求类型： 发布, 撤销 ,管理
function PlayerZhengyouPT_SendCheckRequest(eType, opt)
	if (not PlayerZhengyouPT_IsRealType(eType) ) then
	    return false;
	end
	
	-- 发送具体查询请求
	FindFriendQuery(opt, eType);
	return true;
end

-- 玩家确认要撤销
function PlayerZhengyouPT_MessageChexiaoOK(eType)
    RequestDeleteFindFriendInfo(tonumber(eType));
end

function PlayerZhengyouPT_MessageChexiaoCancel()

end

-- 查询或执行操作的反馈处理 
function PlayerZhengyouPT_OnQueryResponse(sOptType, sRet, eType, iReserve)
	local iType = tonumber(eType);
	if ( nil == iType ) then
	    PushDebugMessage("征友操作返回了错误信息");
	    return;
	end
	if ( "check_guanli" == sOptType ) then
	    if ( "ok" == sRet ) then
			--定位到管理的相应类型标签
			PlayerZhengyouPT_SetCurrentTab(iType); 
	    elseif ( "noinfo" == sRet ) then
	        PushDebugMessage("#{ZYPT_081103_068}" .. PlayerZhengyouPT_GetTypeName(iType) .. "#{ZYPT_081103_073}");
	    else
	    
	    end
	elseif ( "check_chexiao" == sOptType ) then
	    if ("sure"  == sRet ) then -- 要求确认删除
	        --PushDebugMessage("您确定要撤消" .. PlayerZhengyouPT_GetTypeName(iType) .. "信息吗？撤销后如果离您发布消息的时间不足24小时，将无法再次发布。");
	        MessageBoxCommon("#{ZYPT_081103_101}", "#{ZYPT_081103_070}" .. PlayerZhengyouPT_GetTypeName(iType) .. "#{ZYPT_081103_071}",
				"PlayerZhengyouPT", "MessageChexiaoOK(" .. iType .. ")", "MessageChexiaoCancel()");
	    elseif ("noinfo" == sRet) then
	        PushDebugMessage("#{ZYPT_081103_068}" .. PlayerZhengyouPT_GetTypeName(iType) .. "#{ZYPT_081103_069}");
	    end
	elseif ( "check_fabu" == sOptType ) then
	    if ( "ok" == sRet) then
	        --PushDebugMessage("提示发布条件");
	    elseif ( "in24hours" == sRet ) then
	        PushDebugMessage("#{ZYPT_081103_060}" .. PlayerZhengyouPT_GetTypeName(iType) .. "#{ZYPT_081103_061}");
	    elseif ( "exist" == sRet ) then
	        PushDebugMessage("#{ZYPT_081103_058}" .. PlayerZhengyouPT_GetTypeName(iType) .. "#{ZYPT_081103_059}");
	    elseif ( "full" == sRet ) then
	        PushDebugMessage("#{ZYPT_081103_062}" .. PlayerZhengyouPT_GetTypeName(iType) .. "#{ZYPT_081103_063}");
	    end
	elseif ( "fabu" == sOptType ) then
		if ( "ok" == sRet ) then
		   PushDebugMessage("#{ZYPT_081103_106}" .. PlayerZhengyouPT_GetTypeName(iType) .. "#{ZYPT_081103_107}");    -- 发布成功的提示 
		   PlayerZhengyouPT_SetCurrentTab(iType); 
		end
	elseif ("view_vote" == sOptType) then
		if ( "noinfo" == sRet ) then 
		    PushDebugMessage("对不起，目前还没有人在此选项上投票。");
		end
    elseif ("vote" == sOptType) then
        if ("done" == sRet) then
            PushDebugMessage("#{ZYPT_081103_080}"); --("对不起，您已经对本条信息投过票了，无需再次投票。");
        elseif("full" == sRet) then
            PushDebugMessage("#{ZYPT_081103_079}"); --("对不起，本条信息投票人数已满，无法进行投票。");
		elseif("ok" == sRet) then
		    -- 切tab和给提示
        	if (g_curChannel == 5) then
        		PlayerZhengyouPT_SetCurrentTab(iType); 
        	end
		    --PushDebugMessage(PlayerZhengyouPT_GetTypeName(iType));
		    local sVoteOkTip = string.format("您已经成功投票给%s", FindFriendDataPool:GetDetailInfo("NAME") );
		    PushDebugMessage( sVoteOkTip );
        end
    elseif ("delete" == sOptType) then
	    if( "ok" == sRet ) then
    		PlayerZhengyouPT_SetCurrentTab(iType);
	        PushDebugMessage("您成功撤销了" .. PlayerZhengyouPT_GetTypeName(iType) .. "#{ZYPT_081103_107}");
	    end
	elseif ("editcondition" == sOptType ) then
		if( "ok" == sRet ) then
    		PlayerZhengyouPT_SetCurrentTab(iType);
	        PushDebugMessage("修改信息成功");
	    end
	end

end


	--*****************************************
	--CEGUI有一处写的不合理的地方(Bug?)....导致多列列表设置属性时会出现一些错误....
	--具体为：
	--在XML中给多列列表配置了ColumnsSizable=True....就会设置该控件的ColumnsSizable=True....还会设置其所有列的ColumnsSizable=True....
	--有些多列列表如本窗口的需要在脚本中动态的插入列....这时XML中配置的ColumnsSizable=True只会设置该控件的ColumnsSizable=True....不会设置列的ColumnsSizable=True(因为当时一个列都没有)....
	--因此在脚本中动态插入列后列的ColumnsSizable因为没被设置过就不是True....
	--如果想在动态插入列后在脚本里再重新给多列列表设置ColumnsSizable=True也不行....
	--因为设置该属性的值时会判断是否与当前该属性的值一样....如果一样就直接返回....而该控件的ColumnsSizable在初始化XML的时候被设成True了所以会直接返回....也就不会给它的列设置该属性....
	--因此如果想动态插入列就需要在动态插入后再设置和列有关的属性....同时在XML中不能对和列有关的属性进行设置....
	--*****************************************
	
	-- 注： 上边的解释引自AutoSearch.lua, 此处尝试在脚本里先设置成自己要设置成的属性值的相反值，再设置成目标值，证明是可行的。 by cuiyinjie 2008-10-29 
    -- 注意要先调用此函数再往listctrl里插入，否则会删掉1列的信息。 
-- 激活指定的标签 
function PlayerZhengyouPT_SetCurrentTab(iTab)
   local sText = "#{ZYPT_081103_014}"; --"类型";

   if ( 0 == iTab ) then
        
   elseif ( iTab > 0 and iTab < 5 ) then
   		sText = "等级";       
   elseif( 5 == iTab ) then
   
   end
   
   g_Ctrls.CtrlList:SetProperty("ColumnsSizable", "True");
   g_Ctrls.CtrlList:SetProperty("ColumnsMovable", "True");
   g_Ctrls.CtrlList:SetProperty("ColumnsAdjust", "False");
   
   --local sTmpInfo = {};
   --local i = 1;
   --local iTmpSel = g_Ctrls.CtrlList:GetSelectItem();
   --for i = 0, g_Ctrls.CtrlList:GetItemCount() - 1 do
   --     sTmpInfo[i + 1] = g_Ctrls.CtrlList:GetItemText(i, 1);
   --end
   
   PlayerZhengyouPT_CleanPlayerList(); --先清掉，防止新数据回来晚出现空列
   g_Ctrls.CtrlList:RemoveColumnByPos(1);
   g_Ctrls.CtrlList:InsertColumn(sText, 1, 0.23, 1);
   
   --for i = 0, g_Ctrls.CtrlList:GetItemCount() - 1 do
   --      g_Ctrls.CtrlList:AddNewItem(sTmpInfo[i + 1], 1, i);
   --end
   
   g_Ctrls.CtrlList:SetProperty("ColumnsSizable", "False");
   g_Ctrls.CtrlList:SetProperty("ColumnsMovable", "False");
   g_Ctrls.CtrlList:SetProperty("ColumnsAdjust", "True");
   
   if ( iTab >= 0 and iTab < 6 ) then
       g_Ctrls.Tabs[iTab + 1]:SetCheck(1);
       g_curChannel = iTab;
   end
   PlayerZhengyouPT_UpdateSearchTip();
   --g_Ctrls.CtrlList:SetSelectItem(iTmpSel);
end

-- 是否具体类型
function PlayerZhengyouPT_IsRealType(eType)
    local iType = tonumber(eType);
	if ( nil == iType ) then
	    PushDebugMessage("征友操作返回了错误信息");
	end
	
    if ( iType > 0 and iType < 5 ) then
       return true;
    end
    return false;
end

-- 列表中选择
function PlayerZhengyouPT_List_OnSelectionChanged()
   local nSel = PlayerZhengyouPT_List:GetSelectItem();
   local nSearchTab = g_Ctrls.TabSearch:GetCheck();
   if ( nSel < 0 ) then
		return;
   else
      RequestFindFriendDetailInfo(nSel, nSearchTab); -- 调用c++的函数,要区分是否在查找结果里选择，客户端要从不同的结果池里返回结果 
   end
end

-- 设置选中行和当前页号 
function PlayerZhengyouPT_SetFocusRowAndPageNo(iRowIndex, iPageNo)
   local iRow = tonumber(iRowIndex);
   if (PlayerZhengyouPT_List:GetItemCount() > iRow) then
		PlayerZhengyouPT_List:SetSelectItem(iRow);
	end
	g_curPageIndex = tonumber(iPageNo);
	PlayerZhengyouPT_UpdateBtnStatus();
end

function PlayerZhengyouPT_CleanPlayerList()
   PlayerZhengyouPT_List:RemoveAllItem();
   PlayerZhengyouPT_CleanDetailInfo();
end

-- 打开查找条件界面
function OnPlayerZhengyouPT_ChazhaoClicked()
	
	if not PlayerZhengyouPT_PassTime(TIMER_SEARCH, MIN_SEARCHTIME) then
		PushDebugMessage(g_strWaitClickTipText);
		return
	end
	
	OpenWindow("ZhengyouSearch" .. g_curChannel);
end

-- 打开投票查看界面
function OnPlayerZhengyouPT_Chakan1Clicked(iVoteViewId)
	if not PlayerZhengyouPT_PassTime(TIMER_TAB, MIN_TABTIME) then
		PushDebugMessage(g_strWaitClickTipText);
		return
	end
	
	if( iVoteViewId < 0 or iVoteViewId > 3 ) then
		return;
	end 
	--OpenWindow("VotedPlayer");
	PlayerZhengyouPT_CloseOtherWindow();
	
	local  nRowIndex =  PlayerZhengyouPT_List:GetSelectItem();
	if (nRowIndex < 0 ) then 
   		return; 
    end
    --local nSearchTab = g_Ctrls.TabSearch:GetCheck();
    local nSearchTab = g_curChannel;
	RequestVoteFindFriendInfo( OPT_VIEWVOTE, nRowIndex, iVoteViewId , nSearchTab);
end

-- 投票 0 ~ 3 
function PlayerZhengyouPT_Toupiao(iSel)
	if not PlayerZhengyouPT_PassTime(TIMER_COMMONBTN, MIN_TABTIME) then
		PushDebugMessage(g_strWaitClickTipText);
		return
	end
	
	local szName = FindFriendDataPool:GetDetailInfo("NAME"); 
	local player = Player:GetName();   
	if(szName == player) then
		PushDebugMessage(" 不能给自己投票。");
		return;
	end
		
   if ( iSel < 0 or iSel > 3 ) then
      return;
   end
   -- 发送投票请求 
   local  nRowIndex =  PlayerZhengyouPT_List:GetSelectItem();
   if (nRowIndex < 0 ) then 
   		return; 
   end
   --local nSearchTab = g_Ctrls.TabSearch:GetCheck();
   local nSearchTab = g_curChannel;
   RequestVoteFindFriendInfo( OPT_VOTE, nRowIndex, iSel , nSearchTab);
end

-- 更改玩家征友要求 
function PlayerZhengyouPT_Change_OnClick()
	if not PlayerZhengyouPT_PassTime(TIMER_COMMONBTN, MIN_TABTIME) then
		PushDebugMessage(g_strWaitClickTipText);
		return
	end
	
	FindFriendQuery(OPT_CHECK_EDIT, g_curZhengyouType);
end


function PlayerZhengyouPT_OnSearchPlayerResponse(sRet, eType)
   local iType = tonumber(eType);
   if ( "ok" ==  sRet ) then
        g_Ctrls.TxtSearchResultTip:SetText(PlayerZhengyouPT_GetTypeName(iType) .. "#{ZYPT_081103_012}");   -- 注意，只有返回ok时才能更新查询结果提示
        --g_Ctrls.TabSearch:SetCheck(1); --选中查找结果标签
   		PlayerZhengyouPT_CleanPlayerList();
   		g_curChannel 		= 5;
   		g_curPageIndex    = 1;
	    g_totalPageCount = 1;
	    PlayerZhengyouPT_SetCurrentTab(5);   --选中查找结果标签
      	PlayerZhengyouPT_ShowSearchPlayerResult();
      	PlayerZhengyouPT_UpdateBtnStatus();
      	PlayerZhengyouPT_UpdateSearchTip();
   elseif( "noinfo" == sRet ) then
      PushDebugMessage("没有找到符合条件的玩家。");
   end
end

-- 显示查找玩家结果 
function PlayerZhengyouPT_ShowSearchPlayerResult()
   local iCount = FindFriendDataPool:GetSearchRetInfoNum();
   	local i = 0;
	for i = 0, iCount -1 do
		local iGuid, strName, iGender, iRenqi, iType, iLevel = FindFriendDataPool:GetSearchRetInfoByPos(i);
		PlayerZhengyouPT_List:AddNewItem(strName, 0, i);
		PlayerZhengyouPT_List:AddNewItem(PlayerZhengyouPT_GetTypeName(iType), 1, i);
		PlayerZhengyouPT_List:AddNewItem(PlayerZhengyouPT_GetGenderDesc(iGender), 2, i);
		PlayerZhengyouPT_List:AddNewItem(iRenqi, 3, i);
	end
end

-- 查看玩家资料
function PlayerZhengyouPT_View_OnClick()

   local nSel = PlayerZhengyouPT_List:GetSelectItem();
   if ( nSel < 0 ) then
		return;
   end
   
    -- 关闭所有已经打开的二级征友界面
    CloseWindow("VotedPlayer");
    PlayerZhengyouPT_CloseOtherWindow();
   
	-- 根据玩家名字来取资料 
    local szName = FindFriendDataPool:GetDetailInfo("NAME"); 
	if(nil ~= szName) then
		if( Friend:IsPlayerIsFriend( szName ) == 1 ) then
			local nGroup,nIndex;
			nGroup,nIndex = DataPool:GetFriendByName( szName );
			DataPool:ShowFriendInfo( szName );
		else
			DataPool:ShowChatInfo( szName );
		end
	end
end 

function PlayerZhengyouPT_CloseOtherWindow()
   local OtherWindows = {
   		"ZhengyouInfoFabu",
   		"ZhengyouYaoqiu",
   		"ZhengyouSearch",
   };
   local i = 1;
   for i = 1, table.getn( OtherWindows ) do
      CloseWindow( OtherWindows[i] );
   end
end

-- 结识玩家
function PlayerZhengyouPT_Jieshi_OnClick()
     --对不起，您不能和自己结识。
     --您刚刚已经和该玩家结识过了，请在临时好友列表中查找。
     --该玩家已经在您的仇人列表中，无法结识。
     --该玩家已经在您的好友列表中，请在好友列表中查找。
     --该玩家已经在您的临时好友列表中，请在临时好友列表中查找。
     --结识成功，您已经将该玩家加入临时好友列表。
     --玩家XXX看到了您发布的征婚信息，想与您结识，已经在您的临时好友列表中。
     
        local nSel = PlayerZhengyouPT_List:GetSelectItem();
   		if ( nSel < 0 ) then
			return;      --如果没有选中的用户，不能结识
  		end
     -- 首先判断是否自己     
     	local owner = FindFriendDataPool:GetDetailInfo("NAME"); 
		local player = Player:GetName();
		if(owner == player) then
			PushDebugMessage("#{ZYPT_081103_046}"); --("对不起，您不能和自己结识。");
			return;
		end
	 --  判断是否仇人 
	 	local currentList = 6; -- 仇人 
	 	local friendnumber = DataPool:GetFriendNumber( tonumber( currentList ) );
	 	local index = 0;
	 	while index < friendnumber  do
	 		local name =  DataPool:GetFriend( currentList, tonumber( index ), "NAME" );	
	 		if (name == owner) then
	 		    PushDebugMessage("#{ZYPT_081103_048}"); --("该玩家已经在您的仇人列表中，无法结识。");
	 			return;
	 		end
	 		index = index + 1;
	    end
	--  判断是否黑名单
	 	local currentList = 5; -- 黑名单 
	 	local friendnumber = DataPool:GetFriendNumber( tonumber( currentList ) );
	 	local index = 0;
	 	while index < friendnumber  do
	 		local name =  DataPool:GetFriend( currentList, tonumber( index ), "NAME" );	
	 		if (name == owner) then
	 		    PushDebugMessage("该玩家已经在您的黑名单中，无法结识。");
	 			return;
	 		end
	 		index = index + 1;
	    end
	-- 判断是否在临时好友列表 
	    currentList = 8; -- temp friend 
	 	friendnumber = DataPool:GetFriendNumber( tonumber( currentList ) );
	 	index = 0;
	 	while index < friendnumber  do
	 		local name =  DataPool:GetFriend( currentList, tonumber( index ), "NAME" );	
	 		if (name == owner) then
	 		    PushDebugMessage("#{ZYPT_081103_050}"); --("该玩家已经在您的临时好友列表中，请在临时好友列表中查找。");
	 			return;
	 		end
	 		index = index + 1;
	    end
	-- 判断是否好友
	local iTmp = 1;
	for iTmp = 1, 4 do
	   	currentList = iTmp; -- friend 
	 	friendnumber = DataPool:GetFriendNumber( tonumber( currentList ) );
	 	index = 0;
	 	while index < friendnumber  do
	 		local name =  DataPool:GetFriend( currentList, tonumber( index ), "NAME" );	
	 		if (name == owner) then
	 		    PushDebugMessage("#{ZYPT_081103_049}"); --("该玩家已经在您的好友列表中，请在好友列表中查找。");
	 			return;
	 		end
	 		index = index + 1;
	    end
	end
		-- 把对方加入自己临时好友列表
		DataPool:AddFriend(8, owner);
		PushDebugMessage("#{ZYPT_081103_051}"); --结识成功，您已经将该玩家加入临时好友列表。
	-- 发送邮件 
	    local iAdType = FindFriendDataPool:GetDetailInfo("ADTYPE");
		local sType = g_TypesDesc[iAdType];
		if ( nil == sType ) then sType = ""; end
		
		DataPool:OpenMail( owner,"您好，我看到了您发布的" .. sType .. "征友信息，想与您结识!" );
	  
end 

-- 在切换标签时处理查询提示和玩家列表窗口大小 
function  PlayerZhengyouPT_UpdateSearchTip()
	 -- 无提示时玩家列表top = 23, height = 272  
	 -- <Property Name="UnifiedPosition" Value="{{0.000000,1.000000},{0.000000,23.000000}" />
	 -- <Property Name="AbsoluteSize" Value="w:399 h:272" />
	 -- 有提示时
	 --<Property Name="UnifiedPosition" Value="{{0.000000,1.000000},{0.000000,47.000000}" />
     --<Property Name="AbsoluteSize" Value="w:399 h:248" />
     if ( 5 == g_curChannel ) then
         --PlayerZhengyouPT_Result:Show();
         g_Ctrls.CtrlList:SetProperty("UnifiedPosition", "{{0.000000,1.000000},{0.000000,47.000000}");
         g_Ctrls.CtrlList:SetProperty("AbsoluteSize", "w:399 h:248");
     else
         --PlayerZhengyouPT_Result:Hide();
         g_Ctrls.CtrlList:SetProperty("UnifiedPosition", "{{0.000000,1.000000},{0.000000,23.000000}");
         g_Ctrls.CtrlList:SetProperty("AbsoluteSize", "w:399 h:272");
     end
end

function OnPlayerZhengyouPT_RefreshClicked()
	if not PlayerZhengyouPT_PassTime(TIMER_UPDATE, MIN_UPDATETIME) then
		PushDebugMessage(g_strWaitClickTipText);
		return
	end
	
	if (g_curChannel == 5) then      --查找结果中不让刷新
		return;
	end
	PlayerZhengyouPT_UpdateBtnStatus();
	if ( g_curPageIndex < 1 ) then g_curPageIndex = 1; end
	RequestFindFriendList(g_curChannel, g_curPageIndex);	
end

function OnPlayerZhengyouPT_GotoClicked()
	if not PlayerZhengyouPT_PassTime(TIMER_COMMONBTN, MIN_TABTIME) then
		PushDebugMessage(g_strWaitClickTipText);
		return
	end
	
	local nPage = PlayerZhengyouPT_GotoEditBox:GetText();
	if(nPage~=nil and tonumber(nPage)~=nil) then 
		if(tonumber(nPage)>g_totalPageCount or tonumber(nPage) < 1) then
			PushDebugMessage("请输入正确的页数。")
		else
			g_curPageIndex = tonumber(nPage);
			PlayerZhengyouPT_UpdateBtnStatus();
			RequestFindFriendList(g_curChannel, g_curPageIndex);	
		end
	end
	
end

function OnPlayerZhengyouPT_FirstPageClicked()
	if not PlayerZhengyouPT_PassTime(TIMER_UPDATE, MIN_TABTIME) then
		PushDebugMessage(g_strWaitClickTipText);
		return
	end
	
	g_curPageIndex = 1;
	PlayerZhengyouPT_UpdateBtnStatus();
	RequestFindFriendList(g_curChannel, g_curPageIndex);	
end

function OnPlayerZhengyouPT_LastPageClicked()
	if not PlayerZhengyouPT_PassTime(TIMER_UPDATE, MIN_TABTIME) then
		PushDebugMessage(g_strWaitClickTipText);
		return
	end
	
	g_curPageIndex = g_totalPageCount;
	PlayerZhengyouPT_UpdateBtnStatus();
	RequestFindFriendList(g_curChannel, g_curPageIndex);	
end
