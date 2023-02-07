--组队平台 zhanglei add

g_GrayColor = "FF00B4FF" 	--用于自己的时候的颜色显示
local MENPAI_NUM = 11; --门派个数，包括任意
local MENPAI_NAME = {
	"#{ZDPT_XML_31}",
	"#{GMGameInterface_Script_DataPool_Info_ShaoLin}",
	"#{GMGameInterface_Script_DataPool_Info_Mingjiao}",
	"#{GMGameInterface_Script_DataPool_Info_GaiBang}",
	"#{GMGameInterface_Script_DataPool_Info_WuDang}",
	"#{GMGameInterface_Script_DataPool_Info_EMei}",
	"#{GMGameInterface_Script_DataPool_Info_XingXiu}",
	"#{GMGameInterface_Script_DataPool_Info_DaLi}",
	"#{GMGameInterface_Script_DataPool_Info_TianShan}",
	"#{GMGameInterface_Script_DataPool_Info_XiaoYao}",
	"#{GMGameInterface_Script_DataPool_Info_GuSu}",
}
local g_Menpai = {
	"#{GMGameInterface_Script_DataPool_Info_ShaoLin}",
	"#{GMGameInterface_Script_DataPool_Info_Mingjiao}",
	"#{GMGameInterface_Script_DataPool_Info_GaiBang}",
	"#{GMGameInterface_Script_DataPool_Info_WuDang}",
	"#{GMGameInterface_Script_DataPool_Info_EMei}",
	"#{GMGameInterface_Script_DataPool_Info_XingXiu}",
	"#{GMGameInterface_Script_DataPool_Info_DaLi}",
	"#{GMGameInterface_Script_DataPool_Info_TianShan}",
	"#{GMGameInterface_Script_DataPool_Info_XiaoYao}",
	"#{GMGameInterface_Script_DataPool_Info_WuMenPai}",
	"#{GMGameInterface_Script_DataPool_Info_GuSu}",
}
-- 稍等点击的提示
local g_strWaitClickTipText = "#{ZYPT_081127_2}"; --"不可连续点击，请稍等片刻后再点击。";

-- 当前频道类别与页码
local g_totalInfoCount = 1 			-- 总的信息数
local g_isTeam = 1							-- 默认显示“队伍”
local g_curPageIndex = 1				-- 默认显示第1页
local g_totalPageCount = 1			-- 信息列表的总页数
local g_ClientPageBegin = 1			-- 客户端缓存的页的开始页码
local g_ClientPageEnd = 1				-- 客户端缓存的结束页码
local g_ClientLocalInfoNum = 0  -- 客户端缓存的信息个数
local g_isFilter = 0 						-- 默认不过滤

local MAXCOUNTPERPAGE 	= 15;					-- 每页最多显示15条
local MAXCLIENTPAGE 	= 5;						-- 客户端缓存的页码数

-- 界面控件
local BtnPageUpDown = {};

-- 冷却时间相关
local g_iLastTime = 0;

local g_Timers = {0, 0, 0, 0, 0}; -- 冷却时间分组
local TIMER_COMMONBTN = 1;				-- 一般按钮
local MIN_COMMON_TIME = 0.5; --点功能按钮的间隔 （秒）
local MIN_SHUAXIN_TIME = 1; --点功能按钮的间隔 （秒） -- 到服务器端拉数据的按钮时间长一些

local g_isSendTeamMsg = -1 --玩家是否发送过队伍信息,用于控制界面打开关闭
local g_isSendUserMsg = -1 --玩家是否发送过玩家信息,用于控制界面打开关闭
local g_PlayerInfoRow = -1;

local g_ColomnIdOfRightClick = 1;	--右键菜单弹出对应的列ID

local g_TeamPT_Frame_UnifiedPosition;

function TeamPT_PreLoad()
	this:RegisterEvent("OPEN_WINDOW");														-- 打开征友平台主窗口
	this:RegisterEvent("TEAMBOARD_UPDATE_LIST");									-- 更新信息列表
	this:RegisterEvent("TEAMBOARD_SEND_SUCCESS");									-- 发送成功
	this:RegisterEvent("TEAMBOARD_DEL_SUCCESS");									-- 删除成功
	this:RegisterEvent("TEAMBOARD_BUTTON_CLICKED");								-- 按钮点击
	this:RegisterEvent("TEAMBOARD_ITEM_RIGHT_CLICKED");						-- 右键点击某行某列的操作
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
end

function TeamPT_OnLoad()
	BtnPageUpDown = {TeamPT_PageUp, TeamPT_PageDown};
	 g_TeamPT_Frame_UnifiedPosition=TeamPT_Frame:GetProperty("UnifiedPosition");
end


function TeamPT_OnEvent(event)
	if(event == "OPEN_WINDOW") then
		if( arg0 == "TeamPTWindow") then
			--如果已经显示就应该关掉
			if ( this:IsVisible() ) then
			   this:Hide();
			   return;
			end
			CloseWindow("ZhengyouWindow");
			InitAndShowTeamPTWindow();
		end

	elseif(event == "TEAMBOARD_UPDATE_LIST") then
		TeamPT_UpdateList(arg0, arg1,arg2,arg3,arg4);
		this:Show();
	elseif(event == "TEAMBOARD_BUTTON_CLICKED") then
		TeamPT_MultiColomn_Clicked(arg0);
	elseif(event == "TEAMBOARD_ITEM_RIGHT_CLICKED") then
		TeamPT_Item_Right_Clicked(arg0,arg1);
	elseif(event == "TEAMBOARD_SEND_SUCCESS") then
		if (tonumber(arg0) == 1 ) then
			g_isSendTeamMsg = 1;
		else
			g_isSendUserMsg = 1;
		end
		g_curPageIndex = 1;
	elseif(event == "TEAMBOARD_DEL_SUCCESS") then
		if (tonumber(arg0) == 1 ) then
			g_isSendTeamMsg = -1;
		else
			g_isSendUserMsg = -1;
		end
		
	elseif (event == "ADJEST_UI_POS" ) then
		TeamPT_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		TeamPT_Frame_On_ResetPos()

	elseif (event == "PLAYER_ENTERING_WORLD") then
		this:Hide();
		return;
	end

end

function TeamPT_SendRequest()
	TeamPT_CleanPlayerList();

	local nClientPage = math.floor( (g_curPageIndex -1) / MAXCLIENTPAGE) * MAXCLIENTPAGE + 1;

	TeamBoardDataPool:RequestTeamBoardList(g_isFilter, g_isTeam , nClientPage);
end

-- 初始化组队平台
function InitAndShowTeamPTWindow()
	g_totalPageCount = 0;
	g_PlayerInfoRow = -1;
	g_isSendUserMsg = -1;
	g_isSendTeamMsg = -1;
	TeamPT_Team:SetCheck(1);
	g_curPageIndex = 1;
	TeamPT_User:SetCheck(0);
	g_isTeam = 1;
	g_isFilter = 0;
	TeamPT_List:Show();
	TeamPT_List_Player:Hide();
	this:Show();
	TeamPT_SendRequest();

	TeamPT_Mode:SetCheck(0);
end

--更新玩家列表
--参数意义：
--strIsTeam : 是否为队列
--strPageNum : 返回的数据包的开始页码
--strTotal : 总共的信息数
--strRetNum : 当前包中含有的信息数
--strIsSearch : 是否为筛选后的结果
function TeamPT_UpdateList(strIsTeam, strPageNum, strTotal, strRetNum ,strIsFilter)
	g_PlayerInfoRow = -1;
	TeamPT_CleanPlayerList();

	local iIsTeam = tonumber(strIsTeam);
	local iIsFilter = tonumber(strIsFilter);
	local iTotal = tonumber(strTotal);
	local iRetNum = tonumber(strRetNum);
	if iIsTeam ~= g_isTeam then
		TeamPT_ChannelButtonUpdate(iIsTeam);
		g_isTeam = iIsTeam;
	end
	if iIsFilter ~= g_isFilter then
		TeamPT_Mode:SetCheck(iIsFilter)
		g_isFilter = iIsFilter;
	end

	--根据此类型玩家总数计算页数
	g_totalInfoCount = iTotal;
	g_ClientPageBegin = tonumber(strPageNum);

	if (math.mod(g_totalInfoCount, MAXCOUNTPERPAGE) ~= 0 ) then
		g_totalPageCount = math.floor(g_totalInfoCount / MAXCOUNTPERPAGE) + 1;
	else
		g_totalPageCount = math.floor(g_totalInfoCount / MAXCOUNTPERPAGE);
	end

	g_ClientLocalInfoNum = iRetNum;
	if iRetNum > 0 then
		g_ClientPageEnd = g_ClientPageBegin + math.floor((iRetNum - 1)/ MAXCOUNTPERPAGE) ;
	else
		TeamPT_UpdateBtnStatus();
		return
	end

	if g_curPageIndex < g_ClientPageBegin then
		g_curPageIndex = g_ClientPageBegin;
	end

	if g_curPageIndex > g_ClientPageEnd then
		g_curPageIndex = g_ClientPageEnd ;
	end

	TeamPT_GetInfo_Local();
	-- 更新下面的函数中指定的几个按钮状态
	TeamPT_UpdateBtnStatus();
end

--返回从当前到客户端缓存的真实页数，客户端会缓存部分页面
function TeamPT_Get_Local_Page()
	local BeginPage = 0;
	BeginPage = math.mod(g_curPageIndex - 1,MAXCLIENTPAGE) ;
	return BeginPage;
end

function TeamPT_GetInfo_Local()
	TeamPT_CleanPlayerList();
	local BeginPage = TeamPT_Get_Local_Page();
	local iBeginIndex = BeginPage * MAXCOUNTPERPAGE ;
	local iEndIndex = g_curPageIndex * MAXCOUNTPERPAGE ;
	local iBeginSeq = math.floor((g_curPageIndex-1)/MAXCLIENTPAGE) * MAXCLIENTPAGE * MAXCOUNTPERPAGE;
	if iEndIndex >= g_ClientLocalInfoNum then
		iEndIndex = g_ClientLocalInfoNum;
	end
	local i = 0;
	local iRow = 0;
	for i = iBeginIndex, iEndIndex - 1 do
		if g_isTeam == 1 then
			--队伍列表
			local isMyInfo, strName, Topic, iGoal,strMenpaiList , iMinLevel,iMaxLevel,iTeamMember;
			isMyInfo, strName, Topic, iGoal,strMenpaiList , iMinLevel,iMaxLevel,iTeamMember = TeamBoardDataPool:GetInfoByPos(g_isTeam,g_isFilter, i);

			local textColor = nil;
			if i == 0 and isMyInfo == 1 then  --自己的信息总是在第一个
				--设置颜色
				textColor = g_GrayColor;
				g_PlayerInfoRow = iRow;
			else
				textColor = nil;
			end
			TeamPT_List:AddNewItem(iBeginSeq + i + 1, 0, iRow,textColor,2);
			TeamPT_List:AddNewItem(strName, 1, iRow ,textColor);
			TeamPT_List:AddNewItem(Topic, 2, iRow ,textColor);
			TeamPT_List:AddNewItem(TeamPT_GetGoalText(iGoal), 3, iRow, textColor);
			local strMenpai,strMenpaiTips = TeamPT_GetMenPaiDesc(strMenpaiList);
			TeamPT_List:AddNewItem(strMenpai, 4, iRow ,textColor);
			if strMenpaiTips ~= "" then
				--设置带Tooltip的Item
				TeamPT_List:SetItemTooltip(4,iRow,strMenpaiTips);
			end
			local strLevel = iMinLevel.." - "..iMaxLevel;
			TeamPT_List:AddNewItem(strLevel , 5, iRow,textColor);
			TeamPT_List:AddNewItem(iTeamMember.."/6", 6, iRow ,textColor);
			if i == 0 and isMyInfo == 1 then  --自己的信息总是在第一个
				TeamPT_List:AddNewButtonItem("#{ZDPT_XML_19}",7,iRow);
			else
				TeamPT_List:AddNewButtonItem("#{ZDPT_XML_17}",7,iRow);
			end
			iRow = iRow + 1;
		else
			--玩家列表
			local isMyInfo, strName, Topic, iGoal,iMenpai, iLevel;
			isMyInfo, strName, Topic, iGoal,iMenpai, iLevel = TeamBoardDataPool:GetInfoByPos(g_isTeam ,g_isFilter , i);

			local textColor = nil;
			if i == 0 and isMyInfo == 1 then  --自己的信息总是在第一个
				--设置颜色
				textColor = g_GrayColor;
				g_PlayerInfoRow = iRow;
			else
				textColor = nil;
			end
			TeamPT_List_Player:AddNewItem(iBeginSeq + i + 1, 0, iRow ,textColor,2);
			TeamPT_List_Player:AddNewItem(strName, 1, iRow ,textColor );
			TeamPT_List_Player:AddNewItem(Topic, 2, iRow ,textColor);
			TeamPT_List_Player:AddNewItem(TeamPT_GetGoalText(iGoal), 3, iRow , textColor);
			if iMenpai >= 0 and iMenpai < MENPAI_NUM then
				TeamPT_List_Player:AddNewItem(g_Menpai[iMenpai+1], 4, iRow ,textColor);
			end
			TeamPT_List_Player:AddNewItem(iLevel , 5, iRow,textColor);
			if i == 0 and isMyInfo == 1 then  --自己的信息总是在第一个
				TeamPT_List_Player:AddNewButtonItem("#{ZDPT_XML_19}",6,iRow);
			else
				TeamPT_List_Player:AddNewButtonItem("#{ZDPT_XML_18}",6,iRow);
			end
			iRow = iRow + 1;
		end
	end
end

function TeamPT_GetGoalText(iGoal)
	local _id,_name =DataPool : EnumTeamBoardGoal(iGoal);
	return _name;
end

--获取门派list对应的文字
--返回值，第一个为缩写，第二个为tips
function TeamPT_GetMenPaiDesc(strMenpaiList)
	local Menpai = ""; --框中显示的内容
	local TipsMenpai =""; --tips
	local Num = 0;
	for i=1, MENPAI_NUM do
		if string.byte(strMenpaiList,i) == 49 then  --对应字符为1
			if Num == 0 then
				Menpai = MENPAI_NAME[i];
				TipsMenpai = MENPAI_NAME[i];
			else
				if Num < 3 then
					Menpai = Menpai..","..MENPAI_NAME[i];
					TipsMenpai = TipsMenpai..","..MENPAI_NAME[i];
				elseif Num == 3 then
					Menpai = Menpai.."...";
					TipsMenpai = TipsMenpai..","..MENPAI_NAME[i];
				elseif Num > 3 then
					TipsMenpai = TipsMenpai..","..MENPAI_NAME[i];
				end
			end
			Num = Num + 1;
		end
	end
	return Menpai,TipsMenpai;
end

-- 翻页
function OnTeamPT_PageUpClicked()
	if not TeamPT_PassTime(TIMER_COMMONBTN, MIN_COMMON_TIME) then
		PushDebugMessage(g_strWaitClickTipText);
		return
	end

	g_curPageIndex = g_curPageIndex - 1;
	TeamPT_UpdateBtnStatus();
	if ( g_curPageIndex < 1 ) then
		g_curPageIndex = 1;
	end

	if g_curPageIndex >= g_ClientPageBegin and g_curPageIndex < g_ClientPageEnd then
		TeamPT_GetInfo_Local();
	else
		TeamPT_SendRequest();
	end

end

function OnTeamPT_PageDownClicked()
	if not TeamPT_PassTime(TIMER_COMMONBTN, MIN_COMMON_TIME) then
		PushDebugMessage(g_strWaitClickTipText);
		return
	end

	g_curPageIndex = g_curPageIndex + 1;
	TeamPT_UpdateBtnStatus();

	if g_curPageIndex >= g_ClientPageBegin and g_curPageIndex < g_ClientPageEnd then
		TeamPT_GetInfo_Local();
	else
		TeamPT_SendRequest();
	end
end

-- 更新“首页”、“末页”、“前一页”、“后一页”这4个按钮和页码显示的状态
function TeamPT_UpdateBtnStatus()
	-- 当前第1页：禁用“前一页”、“首页”
	if( g_curPageIndex <= 1 ) then
		BtnPageUpDown[1]:Disable();
		TeamPT_FirstPage:Disable();
	end

	-- 当前最后一页：禁用“后一页”、“末页”
	if( g_curPageIndex >= g_totalPageCount ) then
		BtnPageUpDown[2]:Disable();
		TeamPT_LastPage:Disable();
	end

	-- 当前不是第1页：激活“前一页”、“首页”
	if (g_curPageIndex > 1 ) then
		BtnPageUpDown[1]:Enable();
		TeamPT_FirstPage:Enable();
	end

	-- 当前不是最后一页：激活“后一页”、“末页”
	if (g_curPageIndex < g_totalPageCount ) then
		BtnPageUpDown[2]:Enable();
		TeamPT_LastPage:Enable();
	end

	local curPage = g_curPageIndex;
	if ( curPage > g_totalPageCount ) then
		curPage = g_totalPageCount;
	end

	-- 更新Amount控件显示的“当前页/所有页”
	TeamPT_Amount:SetText(curPage.."/"..g_totalPageCount);

	-- 更新GotoEditBox控件显示的需要前往的页码
	TeamPT_GotoEditBox:SetText(tostring(g_curPageIndex));
end

function TeamPT_PassTime(iIdx, iSeconds)
   local iCur = FindFriendDataPool:GetTickCount();
   if ( iCur - g_Timers[iIdx] < iSeconds * 1000) then
      return false;
   else
      g_Timers[iIdx] = iCur;
   	  return true;
   end
end

--修改tab的状态，并将对应的list放到前面
function TeamPT_ChannelButtonUpdate(iChannel)
	-- 点击当前选中的标签应该无操作
	if (g_isTeam == iChannel) then
		return;
	end


	TeamPT_CleanPlayerList();

	g_isTeam = iChannel;
	g_curPageIndex 		= 1;
	g_totalPageCount 	= 0;

	if g_isTeam == 1 then
		TeamPT_Team:SetCheck(1);
		TeamPT_User:SetCheck(0);
		TeamPT_List:Show();
		TeamPT_List_Player:Hide();
	else
		TeamPT_Team:SetCheck(0);
		TeamPT_User:SetCheck(1)
		TeamPT_List:Hide();
		TeamPT_List_Player:Show();
	end

	TeamPT_UpdateBtnStatus(); --防止点到空页时按钮没变灰
end

-- 选择不同的标签的显示 ,  此处应延时，防止连续点击
function TeamPT_ChannelChange(iChannel)
	-- 不能过频切换标签
	if not TeamPT_PassTime(TIMER_COMMONBTN, MIN_SHUAXIN_TIME) then
		-- 选中当前频道
		PushDebugMessage(g_strWaitClickTipText);

		--恢复为正常状态，因为这个操作之前已经修改状态了
		if g_isTeam == 1 then
			TeamPT_Team:SetCheck(1);
			TeamPT_User:SetCheck(0);
			TeamPT_List:Show();
			TeamPT_List_Player:Hide();
		else
			TeamPT_Team:SetCheck(0);
			TeamPT_User:SetCheck(1)
			TeamPT_List:Hide();
			TeamPT_List_Player:Show();
		end
		return
	end

	TeamPT_Mode:SetCheck(0);

	TeamPT_ChannelButtonUpdate(iChannel)
	TeamPT_SendRequest();
end

function TeamPT_CleanPlayerList()
	TeamPT_List:RemoveAllItem();
	TeamPT_List_Player:RemoveAllItem();
end

-- 刷新
function OnTeamPT_ShuaxinClicked()
	if not TeamPT_PassTime(TIMER_COMMONBTN, MIN_SHUAXIN_TIME) then
		PushDebugMessage(g_strWaitClickTipText);
		return
	end
	TeamPT_UpdateBtnStatus();
	if ( g_curPageIndex < 1 ) then
		g_curPageIndex = 1;
	end

	TeamPT_SendRequest();
end

--招募队员
function OnTeamPT_ZhaomuClicked()
	if g_PlayerInfoRow ~= -1 or g_isSendUserMsg == 1 or g_isSendTeamMsg == 1 then
		PushDebugMessage("#{ZDPT_091028_2}")
		return;
	end
	if( tonumber( Player:IsLeader() ) ~= 1 ) then
		--不是队长
		PushDebugMessage("#{ZDPT_091028_3}");
		return;
	end
	OpenWindow("TeamPTZhaomuWindow")
end

--寻求组队
function OnTeamPT_XunqiuClicked()
	if g_PlayerInfoRow ~= -1 or g_isSendUserMsg == 1 or g_isSendTeamMsg == 1 then
		PushDebugMessage("#{ZDPT_091028_2}")
		return;
	end
	if( tonumber( Player:IsInTeam() ) == 1 ) then
		PushDebugMessage("#{ZDPT_091028_5}");
		return;
	end
	OpenWindow("TeamPTFindWindow")
end

-- 前往
function OnTeamPT_GotoClicked()
	if not TeamPT_PassTime(TIMER_COMMONBTN, MIN_COMMON_TIME) then
		PushDebugMessage(g_strWaitClickTipText);
		return
	end

	local nPage = TeamPT_GotoEditBox:GetText();
	if(nPage~=nil and tonumber(nPage)~=nil) then
		if (tonumber(nPage)>g_totalPageCount or tonumber(nPage) < 1) then
			PushDebugMessage("#{ZDPT_091028_1}")
		else
			g_curPageIndex = tonumber(nPage);
			TeamPT_UpdateBtnStatus();
			if g_curPageIndex >= g_ClientPageBegin and g_curPageIndex < g_ClientPageEnd then
				TeamPT_GetInfo_Local();
			else
				TeamPT_SendRequest();
			end
		end
	end
end

-- 首页
function OnTeamPT_FirstPageClicked()
	if not TeamPT_PassTime(TIMER_COMMONBTN, MIN_COMMON_TIME) then
		PushDebugMessage(g_strWaitClickTipText);
		return
	end

	g_curPageIndex = 1;
	if g_curPageIndex >= g_ClientPageBegin and g_curPageIndex < g_ClientPageEnd then
		TeamPT_GetInfo_Local();
	else
		TeamPT_SendRequest();
	end
	TeamPT_UpdateBtnStatus();
end

-- 末页
function OnTeamPT_LastPageClicked()
	if not TeamPT_PassTime(TIMER_COMMONBTN, MIN_COMMON_TIME) then
		PushDebugMessage(g_strWaitClickTipText);
		return
	end

	g_curPageIndex = g_totalPageCount;

	TeamPT_UpdateBtnStatus();
	TeamPT_SendRequest();
end

-- 关闭
function OnTeamPT_CloseClicked()
	this:Hide();
	g_curPageIndex = 1;
end

function TeamPT_Filter_Clicked()

	--是否可以点
	if TeamPT_Mode:GetProperty("Selected") == "True" then
		if g_isTeam == 1 then
			if g_isSendTeamMsg == 1 then
				PushDebugMessage("#{ZDPT_091028_22}");
				TeamPT_Mode:SetCheck(0);
				return;
			end
		else
			if g_isSendUserMsg == 1 then
				PushDebugMessage("#{ZDPT_091028_23}");
				TeamPT_Mode:SetCheck(0);
				return;
			end
			if g_isSendUserMsg == -1 and g_isSendTeamMsg == -1 then
				PushDebugMessage("#{ZDPT_091028_21}");
				TeamPT_Mode:SetCheck(0);
				return;
			end
		end
	end
	--CD时间
	if not TeamPT_PassTime(TIMER_COMMONBTN, MIN_SHUAXIN_TIME) then
		PushDebugMessage(g_strWaitClickTipText);
		if TeamPT_Mode:GetProperty("Selected") == "True" then
			TeamPT_Mode:SetCheck(0);
		else
			TeamPT_Mode:SetCheck(1);
		end
		return
	end
	g_curPageIndex = 1;
	if TeamPT_Mode:GetProperty("Selected") == "True" then
		g_isFilter = 1;
		TeamPT_SendRequest();
	else
		g_isFilter = 0;
		TeamPT_SendRequest();
	end
end

--选择某一行
function TeamPT_List_OnSelectionChanged()
end

--列表中按钮
function TeamPT_MultiColomn_Clicked(rowID)
	local nRowId = tonumber(rowID);
	if  g_isTeam == 1 then
		--队列表
		if g_PlayerInfoRow == nRowId then
			--自己的信息，处理修改
			TeamBoardDataPool:ModifyInfo(g_isTeam);
		else
			--申请进组
			local BeginPage = TeamPT_Get_Local_Page();
			TeamBoardDataPool:ApplyTeam( BeginPage * MAXCOUNTPERPAGE + nRowId ,g_isFilter);
		end
	else
		--玩家表
		if g_PlayerInfoRow == nRowId then
			--自己的信息，处理修改
			TeamBoardDataPool:ModifyInfo(g_isTeam);
		else
			--邀请进组
			local BeginPage = TeamPT_Get_Local_Page();
			TeamBoardDataPool:RequestTeam( BeginPage * MAXCOUNTPERPAGE + nRowId ,g_isFilter);
		end
	end
end

function TeamPT_Item_Right_Clicked(rowID,colomnID)
	if tonumber(rowID) == g_PlayerInfoRow then
		--自己的信息，没有右键菜单
		return
	end
	if tonumber(colomnID) == g_ColomnIdOfRightClick then
		local BeginPage = TeamPT_Get_Local_Page();
		local name,guid = TeamBoardDataPool:GetCharNameByRowID( BeginPage*MAXCOUNTPERPAGE + tonumber(rowID),g_isTeam, g_isFilter);
		if name ~= "" and guid ~= -1 then
			Talk:ShowContexMenuFromTeamBoard(name,guid);
		end
	end
end

function TeamPT_Frame_On_ResetPos()
  TeamPT_Frame:SetProperty("UnifiedPosition", g_TeamPT_Frame_UnifiedPosition);
end
