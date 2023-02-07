--���ƽ̨ zhanglei add

g_GrayColor = "FF00B4FF" 	--�����Լ���ʱ�����ɫ��ʾ
local MENPAI_NUM = 11; --���ɸ�������������
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
-- �Եȵ������ʾ
local g_strWaitClickTipText = "#{ZYPT_081127_2}"; --"����������������Ե�Ƭ�̺��ٵ����";

-- ��ǰƵ�������ҳ��
local g_totalInfoCount = 1 			-- �ܵ���Ϣ��
local g_isTeam = 1							-- Ĭ����ʾ�����顱
local g_curPageIndex = 1				-- Ĭ����ʾ��1ҳ
local g_totalPageCount = 1			-- ��Ϣ�б����ҳ��
local g_ClientPageBegin = 1			-- �ͻ��˻����ҳ�Ŀ�ʼҳ��
local g_ClientPageEnd = 1				-- �ͻ��˻���Ľ���ҳ��
local g_ClientLocalInfoNum = 0  -- �ͻ��˻������Ϣ����
local g_isFilter = 0 						-- Ĭ�ϲ�����

local MAXCOUNTPERPAGE 	= 15;					-- ÿҳ�����ʾ15��
local MAXCLIENTPAGE 	= 5;						-- �ͻ��˻����ҳ����

-- ����ؼ�
local BtnPageUpDown = {};

-- ��ȴʱ�����
local g_iLastTime = 0;

local g_Timers = {0, 0, 0, 0, 0}; -- ��ȴʱ�����
local TIMER_COMMONBTN = 1;				-- һ�㰴ť
local MIN_COMMON_TIME = 0.5; --�㹦�ܰ�ť�ļ�� ���룩
local MIN_SHUAXIN_TIME = 1; --�㹦�ܰ�ť�ļ�� ���룩 -- ���������������ݵİ�ťʱ�䳤һЩ

local g_isSendTeamMsg = -1 --����Ƿ��͹�������Ϣ,���ڿ��ƽ���򿪹ر�
local g_isSendUserMsg = -1 --����Ƿ��͹������Ϣ,���ڿ��ƽ���򿪹ر�
local g_PlayerInfoRow = -1;

local g_ColomnIdOfRightClick = 1;	--�Ҽ��˵�������Ӧ����ID

local g_TeamPT_Frame_UnifiedPosition;

function TeamPT_PreLoad()
	this:RegisterEvent("OPEN_WINDOW");														-- ������ƽ̨������
	this:RegisterEvent("TEAMBOARD_UPDATE_LIST");									-- ������Ϣ�б�
	this:RegisterEvent("TEAMBOARD_SEND_SUCCESS");									-- ���ͳɹ�
	this:RegisterEvent("TEAMBOARD_DEL_SUCCESS");									-- ɾ���ɹ�
	this:RegisterEvent("TEAMBOARD_BUTTON_CLICKED");								-- ��ť���
	this:RegisterEvent("TEAMBOARD_ITEM_RIGHT_CLICKED");						-- �Ҽ����ĳ��ĳ�еĲ���
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
			--����Ѿ���ʾ��Ӧ�ùص�
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

-- ��ʼ�����ƽ̨
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

--��������б�
--�������壺
--strIsTeam : �Ƿ�Ϊ����
--strPageNum : ���ص����ݰ��Ŀ�ʼҳ��
--strTotal : �ܹ�����Ϣ��
--strRetNum : ��ǰ���к��е���Ϣ��
--strIsSearch : �Ƿ�Ϊɸѡ��Ľ��
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

	--���ݴ����������������ҳ��
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
	-- ��������ĺ�����ָ���ļ�����ť״̬
	TeamPT_UpdateBtnStatus();
end

--���شӵ�ǰ���ͻ��˻������ʵҳ�����ͻ��˻Ỻ�沿��ҳ��
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
			--�����б�
			local isMyInfo, strName, Topic, iGoal,strMenpaiList , iMinLevel,iMaxLevel,iTeamMember;
			isMyInfo, strName, Topic, iGoal,strMenpaiList , iMinLevel,iMaxLevel,iTeamMember = TeamBoardDataPool:GetInfoByPos(g_isTeam,g_isFilter, i);

			local textColor = nil;
			if i == 0 and isMyInfo == 1 then  --�Լ�����Ϣ�����ڵ�һ��
				--������ɫ
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
				--���ô�Tooltip��Item
				TeamPT_List:SetItemTooltip(4,iRow,strMenpaiTips);
			end
			local strLevel = iMinLevel.." - "..iMaxLevel;
			TeamPT_List:AddNewItem(strLevel , 5, iRow,textColor);
			TeamPT_List:AddNewItem(iTeamMember.."/6", 6, iRow ,textColor);
			if i == 0 and isMyInfo == 1 then  --�Լ�����Ϣ�����ڵ�һ��
				TeamPT_List:AddNewButtonItem("#{ZDPT_XML_19}",7,iRow);
			else
				TeamPT_List:AddNewButtonItem("#{ZDPT_XML_17}",7,iRow);
			end
			iRow = iRow + 1;
		else
			--����б�
			local isMyInfo, strName, Topic, iGoal,iMenpai, iLevel;
			isMyInfo, strName, Topic, iGoal,iMenpai, iLevel = TeamBoardDataPool:GetInfoByPos(g_isTeam ,g_isFilter , i);

			local textColor = nil;
			if i == 0 and isMyInfo == 1 then  --�Լ�����Ϣ�����ڵ�һ��
				--������ɫ
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
			if i == 0 and isMyInfo == 1 then  --�Լ�����Ϣ�����ڵ�һ��
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

--��ȡ����list��Ӧ������
--����ֵ����һ��Ϊ��д���ڶ���Ϊtips
function TeamPT_GetMenPaiDesc(strMenpaiList)
	local Menpai = ""; --������ʾ������
	local TipsMenpai =""; --tips
	local Num = 0;
	for i=1, MENPAI_NUM do
		if string.byte(strMenpaiList,i) == 49 then  --��Ӧ�ַ�Ϊ1
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

-- ��ҳ
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

-- ���¡���ҳ������ĩҳ������ǰһҳ��������һҳ����4����ť��ҳ����ʾ��״̬
function TeamPT_UpdateBtnStatus()
	-- ��ǰ��1ҳ�����á�ǰһҳ��������ҳ��
	if( g_curPageIndex <= 1 ) then
		BtnPageUpDown[1]:Disable();
		TeamPT_FirstPage:Disable();
	end

	-- ��ǰ���һҳ�����á���һҳ������ĩҳ��
	if( g_curPageIndex >= g_totalPageCount ) then
		BtnPageUpDown[2]:Disable();
		TeamPT_LastPage:Disable();
	end

	-- ��ǰ���ǵ�1ҳ�����ǰһҳ��������ҳ��
	if (g_curPageIndex > 1 ) then
		BtnPageUpDown[1]:Enable();
		TeamPT_FirstPage:Enable();
	end

	-- ��ǰ�������һҳ�������һҳ������ĩҳ��
	if (g_curPageIndex < g_totalPageCount ) then
		BtnPageUpDown[2]:Enable();
		TeamPT_LastPage:Enable();
	end

	local curPage = g_curPageIndex;
	if ( curPage > g_totalPageCount ) then
		curPage = g_totalPageCount;
	end

	-- ����Amount�ؼ���ʾ�ġ���ǰҳ/����ҳ��
	TeamPT_Amount:SetText(curPage.."/"..g_totalPageCount);

	-- ����GotoEditBox�ؼ���ʾ����Ҫǰ����ҳ��
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

--�޸�tab��״̬��������Ӧ��list�ŵ�ǰ��
function TeamPT_ChannelButtonUpdate(iChannel)
	-- �����ǰѡ�еı�ǩӦ���޲���
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

	TeamPT_UpdateBtnStatus(); --��ֹ�㵽��ҳʱ��ťû���
end

-- ѡ��ͬ�ı�ǩ����ʾ ,  �˴�Ӧ��ʱ����ֹ�������
function TeamPT_ChannelChange(iChannel)
	-- ���ܹ�Ƶ�л���ǩ
	if not TeamPT_PassTime(TIMER_COMMONBTN, MIN_SHUAXIN_TIME) then
		-- ѡ�е�ǰƵ��
		PushDebugMessage(g_strWaitClickTipText);

		--�ָ�Ϊ����״̬����Ϊ�������֮ǰ�Ѿ��޸�״̬��
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

-- ˢ��
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

--��ļ��Ա
function OnTeamPT_ZhaomuClicked()
	if g_PlayerInfoRow ~= -1 or g_isSendUserMsg == 1 or g_isSendTeamMsg == 1 then
		PushDebugMessage("#{ZDPT_091028_2}")
		return;
	end
	if( tonumber( Player:IsLeader() ) ~= 1 ) then
		--���Ƕӳ�
		PushDebugMessage("#{ZDPT_091028_3}");
		return;
	end
	OpenWindow("TeamPTZhaomuWindow")
end

--Ѱ�����
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

-- ǰ��
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

-- ��ҳ
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

-- ĩҳ
function OnTeamPT_LastPageClicked()
	if not TeamPT_PassTime(TIMER_COMMONBTN, MIN_COMMON_TIME) then
		PushDebugMessage(g_strWaitClickTipText);
		return
	end

	g_curPageIndex = g_totalPageCount;

	TeamPT_UpdateBtnStatus();
	TeamPT_SendRequest();
end

-- �ر�
function OnTeamPT_CloseClicked()
	this:Hide();
	g_curPageIndex = 1;
end

function TeamPT_Filter_Clicked()

	--�Ƿ���Ե�
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
	--CDʱ��
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

--ѡ��ĳһ��
function TeamPT_List_OnSelectionChanged()
end

--�б��а�ť
function TeamPT_MultiColomn_Clicked(rowID)
	local nRowId = tonumber(rowID);
	if  g_isTeam == 1 then
		--���б�
		if g_PlayerInfoRow == nRowId then
			--�Լ�����Ϣ�������޸�
			TeamBoardDataPool:ModifyInfo(g_isTeam);
		else
			--�������
			local BeginPage = TeamPT_Get_Local_Page();
			TeamBoardDataPool:ApplyTeam( BeginPage * MAXCOUNTPERPAGE + nRowId ,g_isFilter);
		end
	else
		--��ұ�
		if g_PlayerInfoRow == nRowId then
			--�Լ�����Ϣ�������޸�
			TeamBoardDataPool:ModifyInfo(g_isTeam);
		else
			--�������
			local BeginPage = TeamPT_Get_Local_Page();
			TeamBoardDataPool:RequestTeam( BeginPage * MAXCOUNTPERPAGE + nRowId ,g_isFilter);
		end
	end
end

function TeamPT_Item_Right_Clicked(rowID,colomnID)
	if tonumber(rowID) == g_PlayerInfoRow then
		--�Լ�����Ϣ��û���Ҽ��˵�
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
