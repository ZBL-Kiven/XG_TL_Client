-- 校场观战List

local g_Timers = 0
local g_Seconds = 2

local g_Frame_UnifiedXPosition;
local g_Frame_UnifiedYPosition;

local g_List_PageCount = 20;
local g_Challenge_CurPage = 0;


local CHALLENGE_TYPE_ICON_LEFT = {};		--	比赛类型图标
local CHALLENGE_TYPE_ICON_RIGHT = {};

-- SJBW_210415_01	#H请先将珍兽收回后再进行观战
-- SJBW_210415_02	#H请先取消您的骑乘状态再进行观战
-- SJBW_210415_03	#H组队跟随状态下无法进行观战
-- SJBW_210415_04	少林
-- SJBW_210415_05	明教
-- SJBW_210415_06	丐帮
-- SJBW_210415_07	武当
-- SJBW_210415_08	峨眉
-- SJBW_210415_09	星宿
-- SJBW_210415_10	天龙
-- SJBW_210415_11	天山
-- SJBW_210415_12	逍遥
-- SJBW_210415_13	无门派
-- SJBW_210415_14	#H目前没有挑战的玩家，您无法观战
-- SJBW_210415_15	暂无比赛

local g_MenPaiCount = 9; -- 门派上限 

local CHALLENGE_MENPAISTRINFO = 
{
	[0]	=	"#{SJBW_210415_04}",	--"少林",
	[1]	=	"#{SJBW_210415_05}",	--"明教",
	[2]	=	"#{SJBW_210415_06}",	--"丐帮",
	[3]	=	"#{SJBW_210415_07}",	--"武当",
	[4]	=	"#{SJBW_210415_08}",	--"峨眉",
	[5]	=	"#{SJBW_210415_09}",	--"星宿",
	[6]	=	"#{SJBW_210415_10}",	--"天龙",
	[7]	=	"#{SJBW_210415_11}",	--"天山",
	[8]	=	"#{SJBW_210415_12}",	--"逍遥",
	[9]	=	"#{SJBW_210415_13}",	--"无门派"
	-- [10]="#{}",--"慕容",
	-- [11]="#{}",--"唐门",
	-- [12]="#{}",--"鬼谷",
	-- [13]="#{}",--"桃花岛",
}

function Jiaochang_PK_List_PreLoad()
    this:RegisterEvent("SHOW_CHALLENGE_LIST")
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
end

function Jiaochang_PK_List_OnLoad()
	-- 保存界面的默认相对位置
	g_Frame_UnifiedXPosition	= Jiaochang_PK_List_Frame:GetProperty("UnifiedXPosition");
	g_Frame_UnifiedYPosition	= Jiaochang_PK_List_Frame:GetProperty("UnifiedYPosition");
	
	CHALLENGE_TYPE_ICON_LEFT[1] = Jiaochang_TeamImage1_1
	CHALLENGE_TYPE_ICON_LEFT[2] = Jiaochang_TeamImage2_1
	CHALLENGE_TYPE_ICON_LEFT[3] = Jiaochang_TeamImage3_1
	CHALLENGE_TYPE_ICON_LEFT[4] = Jiaochang_TeamImage4_1
	CHALLENGE_TYPE_ICON_LEFT[5] = Jiaochang_TeamImage5_1
	CHALLENGE_TYPE_ICON_LEFT[6] = Jiaochang_TeamImage6_1
	CHALLENGE_TYPE_ICON_LEFT[7] = Jiaochang_TeamImage7_1
	CHALLENGE_TYPE_ICON_LEFT[8] = Jiaochang_TeamImage8_1
	CHALLENGE_TYPE_ICON_LEFT[9] = Jiaochang_TeamImage9_1
	CHALLENGE_TYPE_ICON_LEFT[10] = Jiaochang_TeamImage10_1
	CHALLENGE_TYPE_ICON_LEFT[11] = Jiaochang_TeamImage11_1
	CHALLENGE_TYPE_ICON_LEFT[12] = Jiaochang_TeamImage12_1
	CHALLENGE_TYPE_ICON_LEFT[13] = Jiaochang_TeamImage13_1
	CHALLENGE_TYPE_ICON_LEFT[14] = Jiaochang_TeamImage14_1
	CHALLENGE_TYPE_ICON_LEFT[15] = Jiaochang_TeamImage15_1
	CHALLENGE_TYPE_ICON_LEFT[16] = Jiaochang_TeamImage16_1
	CHALLENGE_TYPE_ICON_LEFT[17] = Jiaochang_TeamImage17_1
	CHALLENGE_TYPE_ICON_LEFT[18] = Jiaochang_TeamImage18_1
	CHALLENGE_TYPE_ICON_LEFT[19] = Jiaochang_TeamImage19_1
	CHALLENGE_TYPE_ICON_LEFT[20] = Jiaochang_TeamImage20_1
	
	CHALLENGE_TYPE_ICON_RIGHT[1] = Jiaochang_TeamImage1_2
	CHALLENGE_TYPE_ICON_RIGHT[2] = Jiaochang_TeamImage2_2
	CHALLENGE_TYPE_ICON_RIGHT[3] = Jiaochang_TeamImage3_2
	CHALLENGE_TYPE_ICON_RIGHT[4] = Jiaochang_TeamImage4_2
	CHALLENGE_TYPE_ICON_RIGHT[5] = Jiaochang_TeamImage5_2
	CHALLENGE_TYPE_ICON_RIGHT[6] = Jiaochang_TeamImage6_2
	CHALLENGE_TYPE_ICON_RIGHT[7] = Jiaochang_TeamImage7_2
	CHALLENGE_TYPE_ICON_RIGHT[8] = Jiaochang_TeamImage8_2
	CHALLENGE_TYPE_ICON_RIGHT[9] = Jiaochang_TeamImage9_2
	CHALLENGE_TYPE_ICON_RIGHT[10] = Jiaochang_TeamImage10_2
	CHALLENGE_TYPE_ICON_RIGHT[11] = Jiaochang_TeamImage11_2
	CHALLENGE_TYPE_ICON_RIGHT[12] = Jiaochang_TeamImage12_2
	CHALLENGE_TYPE_ICON_RIGHT[13] = Jiaochang_TeamImage13_2
	CHALLENGE_TYPE_ICON_RIGHT[14] = Jiaochang_TeamImage14_2
	CHALLENGE_TYPE_ICON_RIGHT[15] = Jiaochang_TeamImage15_2
	CHALLENGE_TYPE_ICON_RIGHT[16] = Jiaochang_TeamImage16_2
	CHALLENGE_TYPE_ICON_RIGHT[17] = Jiaochang_TeamImage17_2
	CHALLENGE_TYPE_ICON_RIGHT[18] = Jiaochang_TeamImage18_2
	CHALLENGE_TYPE_ICON_RIGHT[19] = Jiaochang_TeamImage19_2
	CHALLENGE_TYPE_ICON_RIGHT[20] = Jiaochang_TeamImage20_2

end

function Jiaochang_PK_List_OnEvent(event)
	if( event == "ADJEST_UI_POS" ) then
		Jiaochang_PK_List_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		Jiaochang_PK_List_ResetPos()
	elseif( event == "SHOW_CHALLENGE_LIST" ) then
		Jiaochang_PK_List_FirstFillData()
	elseif( event == "HIDE_ON_SCENE_TRANSED") then
		this:Hide()
	end
end
function Jiaochang_PK_List_ClearItemList()
	Jiaochang_PK_List_PkList:RemoveAllItem()
	for i = 1,20 do
		CHALLENGE_TYPE_ICON_LEFT[i]:Hide()
		CHALLENGE_TYPE_ICON_RIGHT[i]:Hide()
	end
	Jiaochang_PK_List_UpButton:Disable()
	Jiaochang_PK_List_DownButton:Disable()
end

function Jiaochang_PK_List_FirstFillData()
	Jiaochang_PK_List_ClearItemList()
	local nCount = DataPool:GetChallengeCount()
	if nCount <= 0 then
		-- SJBW_210415_15	暂无比赛
		PushDebugMessage("#{SJBW_210415_15}")
		g_Challenge_CurPage = 0
		Jiaochang_PK_List_ClearItemList()
		Jiaochang_PK_List_CountFenye : SetText("")
	else
		g_Challenge_CurPage = 0
		Jiaochang_PK_List_FillListData()
	end

	this:Show()
end

function Jiaochang_PK_List_NextPage()
	local nCount = DataPool:GetChallengeCount()
	if g_Challenge_CurPage * g_List_PageCount + g_List_PageCount >= nCount then
		return
	end
	g_Challenge_CurPage = g_Challenge_CurPage + 1
	Jiaochang_PK_List_FillListData()
end
function Jiaochang_PK_List_PrePage()
	if g_Challenge_CurPage <= 0 then
		return
	end
	g_Challenge_CurPage = g_Challenge_CurPage - 1
	Jiaochang_PK_List_FillListData()
end
function Jiaochang_PK_List_FillListData()
	
	Jiaochang_PK_List_ClearItemList()
	local startpos = g_Challenge_CurPage * g_List_PageCount
	local endpos = startpos + 20
	local nCount = DataPool:GetChallengeCount()
	if startpos >= nCount then
		return
	end
	
	if startpos > 0 then
		Jiaochang_PK_List_UpButton:Enable()
	else	
		Jiaochang_PK_List_UpButton:Disable()
	end
	
	if endpos < nCount then
		Jiaochang_PK_List_DownButton:Enable()
	else
		Jiaochang_PK_List_DownButton:Disable()
	end
	
	local maxpages = math.ceil( tonumber(nCount/g_List_PageCount) )
	Jiaochang_PK_List_CountFenye : SetText(tostring(g_Challenge_CurPage+1).."/"..tostring(maxpages))

	for i=startpos, endpos-1 do
	
		local curpos = i - startpos
		if curpos < 0 or curpos >= 20 then
			break
		end
		
		local ret,nameA,typeA,menpaiA,levelA,zoneWorldIdA,nameB,typeB,menpaiB,levelB,zoneWorldIdB = DataPool:GetChallengeInfo(i)
		
		if ret == 0 then
			break
		end
		
		-- 10TL 不存在赏金战 这里统一用默认的
		-- SJBW_130823_31	组队挑战
		-- CHALLENGE_TYPE_ICON_LEFT[curpos+1]:SetProperty("Image","set:UIIcons image:LeaderOpening")
		-- CHALLENGE_TYPE_ICON_LEFT[curpos+1]:SetToolTip( "#{SJBW_130823_31}" )
		-- CHALLENGE_TYPE_ICON_LEFT[curpos+1]:Show()

		-- if typeA == 2 then
		-- 	CHALLENGE_TYPE_ICON_LEFT[curpos+1]:SetProperty("Image","set:Button2 image:Icon_GoldCoin")
		-- 	CHALLENGE_TYPE_ICON_LEFT[curpos+1]:SetToolTip( "#{SJBW_130823_27}" )
		-- 	CHALLENGE_TYPE_ICON_LEFT[curpos+1]:Show()
		if typeA == 1 then
		 	CHALLENGE_TYPE_ICON_LEFT[curpos+1]:SetProperty("Image","set:UIIcons image:LeaderOpening")
		 	CHALLENGE_TYPE_ICON_LEFT[curpos+1]:SetToolTip( "#{SJBW_130823_31}" )
		 	CHALLENGE_TYPE_ICON_LEFT[curpos+1]:Show()
		end

		-- 10TL 还没有天外，这块逻辑暂时注释掉
		-- local selfZoneWorldID = DataPool:GetSelfZoneWorldID()
		-- if selfZoneWorldID ~= 0 and selfZoneWorldID ~= zoneWorldIdA then
		-- 	local serverName = DataPool:GetServerName( zoneWorldIdA )
		-- 	nameA = nameA.."@"..tostring(serverName)
		-- end
		
		Jiaochang_PK_List_PkList:AddNewItem("",0,curpos)
		Jiaochang_PK_List_PkList:AddNewItem(nameA,1,curpos)
		if menpaiA >= 0 and menpaiA <= g_MenPaiCount then
			Jiaochang_PK_List_PkList:AddNewItem(CHALLENGE_MENPAISTRINFO[menpaiA],2,curpos)
		else
			Jiaochang_PK_List_PkList:AddNewItem("",2,curpos)
		end
		Jiaochang_PK_List_PkList:AddNewItem(tostring(levelA),3,curpos)
		Jiaochang_PK_List_PkList:AddNewItem("#RVS",4,curpos)
		
		-- 10TL 不存在赏金战 这里统一用默认的
		-- SJBW_130823_31	组队挑战
		-- CHALLENGE_TYPE_ICON_RIGHT[curpos+1]:SetProperty("Image","set:UIIcons image:LeaderOpening")
		-- CHALLENGE_TYPE_ICON_RIGHT[curpos+1]:SetToolTip( "#{SJBW_130823_31}" )
		-- CHALLENGE_TYPE_ICON_RIGHT[curpos+1]:Show()

		-- if typeB == 2 then
		-- 	CHALLENGE_TYPE_ICON_RIGHT[curpos+1]:SetProperty("Image","set:Button2 image:Icon_GoldCoin")
		-- 	CHALLENGE_TYPE_ICON_RIGHT[curpos+1]:SetToolTip( "#{SJBW_130823_27}" )
		-- 	CHALLENGE_TYPE_ICON_RIGHT[curpos+1]:Show()
		if typeB == 1 then
		 	CHALLENGE_TYPE_ICON_RIGHT[curpos+1]:SetProperty("Image","set:UIIcons image:LeaderOpening")
		 	CHALLENGE_TYPE_ICON_RIGHT[curpos+1]:SetToolTip( "#{SJBW_130823_31}" )
		 	CHALLENGE_TYPE_ICON_RIGHT[curpos+1]:Show()
		end
		
		-- 10TL 还没有天外，这块逻辑暂时注释掉
		-- if selfZoneWorldID ~= 0 and selfZoneWorldID ~= zoneWorldIdB then
		-- 	local serverName = DataPool:GetServerName( zoneWorldIdB )
		-- 	nameB = nameB.."@"..tostring(serverName)
		-- end

		Jiaochang_PK_List_PkList:AddNewItem("",5,curpos)
		Jiaochang_PK_List_PkList:AddNewItem(nameB,6,curpos)
		if menpaiB >= 0 and menpaiB <= g_MenPaiCount then
			Jiaochang_PK_List_PkList:AddNewItem(CHALLENGE_MENPAISTRINFO[menpaiB],7,curpos)
		else
			Jiaochang_PK_List_PkList:AddNewItem("",7,curpos)
		end
		Jiaochang_PK_List_PkList:AddNewItem(tostring(levelB),8,curpos)
	end
end

function Jiaochang_PK_List_PkList_On_SelectionChanged()

end

function Jiaochang_PK_List_CloseClicked()
    this:Hide()
end

function Jiaochang_PK_List_RefreshButtonClicked()
	if not Jiaochang_PK_List_PassTime(g_Seconds) then
		PushDebugMessage("#{SJBW_130823_52}");
		return
	end

	--this:Hide()
	--Jiaochang_PK_List_ClearItemList()
	DataPool:AskChallengeList();

end

function Jiaochang_PK_List_WatchButtonClicked()
	local nIndex = Jiaochang_PK_List_PkList:GetSelectItem()
	if nIndex == -1 then
		-- SJBW_210415_14	#H目前没有挑战的玩家，您无法观战
		PushDebugMessage("#{SJBW_210415_14}")
		return
	end

	local ret = DataPool:EnterChallengeView(g_Challenge_CurPage * g_List_PageCount+nIndex)
	--if ret == 1 then
	--	this:Hide();
	--end
end

--================================================
-- 恢复界面的默认相对位置
--================================================
function Jiaochang_PK_List_ResetPos()
	Jiaochang_PK_List_Frame:SetProperty("UnifiedXPosition", g_Frame_UnifiedXPosition);
	Jiaochang_PK_List_Frame:SetProperty("UnifiedYPosition", g_Frame_UnifiedYPosition);
end

function Jiaochang_PK_List_PassTime(iSeconds)
   local iCur = FindFriendDataPool:GetTickCount()
   if ( iCur - g_Timers < iSeconds * 1000) then
      return false;
   else
      g_Timers = iCur;
   	  return true;
   end
end
