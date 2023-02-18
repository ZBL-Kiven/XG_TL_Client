--3v3排行榜

local g_nCurSel_MatchID = -1
local g_myMatchId = -1
local g_nCurSel_MatchBtn ={}
local g_nMyInfo = {}
local g_nListType = {}
local g_nObjID = -1 --关心obj 
local g_isGetAward = -1
local g_myLevel = -1
local g_startLevel = 60
local g_mid1Level = 79
local g_mid2Level = 89
local g_endLevel = 119
local g_TopListType = 1 -- 0,原服排行榜，1,t服排行榜
local g_NewMatchLevelName={
[0]="#{HSPH_191120_09}", --侠士
[1]="#{HSPH_191120_10}", --豪侠
[2]="#{HSPH_191120_11}", --宗师
}

local g_NoneText={
[0]="#{HSPH_191120_50}", --侠士
[1]="#{HSPH_191120_51}", --豪侠
[2]="#{HSPH_191120_52}", --宗师
}

local g_Image = {
						[1] = "set:HSLJ_01 image:HSLJ_One",
						[2] = "set:HSLJ_01 image:HSLJ_Two",
						[3] = "set:HSLJ_01 image:HSLJ_Three",
					
}
local g_DuanWei1 = {
	[1] = "#{HSPH_191120_24}",
	[2] = "#{HSPH_191120_25}",
	[3] = "#{HSPH_191120_26}",
	[4] = "#{HSPH_191120_27}",
	[5] = "#{HSPH_191120_28}",
	[6] = "#{HSSC_191009_42}",
}
local g_DuanWei2 = {
	[1] = "#{HSLJ_190919_154}",
	[2] = "#{HSLJ_190919_153}",
	[3] = "#{HSLJ_190919_152}",
	[4] = "#{HSLJ_190919_151}",
	[5] = "#{HSLJ_190919_150}",
}

local g_RankList_nContentButton = {}
local g_MenPaiNameList =
{
	[0]  ={Name="#{HSSC_191009_128}" , Color="#cff6600", }, --少林
	[1]  ={Name="#{HSSC_191009_35}" , Color="#cffcc00", }, --明教
	[2]  ={Name="#{HSSC_191009_36}" , Color="#c00ff00", }, --丐帮
	[3]  ={Name="#{HSSC_191009_31}" , Color="#c0000ff", }, --武当
	[4]  ={Name="#{HSSC_191009_32}" , Color="#cff99cc", }, --峨眉
	[5]  ={Name="#{HSSC_191009_129}" , Color="#c007700", }, --星宿
	[6]  ={Name="#{HSSC_191009_130}" , Color="#cffff00", }, --天龙
	[7]  ={Name="#{HSSC_191009_34}" , Color="#cffffff", }, --天山
	[8]  ={Name="#{HSSC_191009_33}" , Color="#c7700ff", }, --逍遥
	[9]  ={Name="无门派"     , Color="#c999999", },	
}
-- 闭合图片
local g_Image1 = {
						[1] = "set:Button14  image:Xingui_Pushed",
						[2] = "set:Button14  image:Xingui_Normal",
						[3] = "set:Button14  image:Xingui_Hover",
						[4] = "set:Button14  image:Xingui_Disable",
						[5] = "set:Button14  image:Zungui_Pushed",
						[6] = "set:Button14  image:Zungui_Normal",
						[7] = "set:Button14  image:Zungui_Hover",
						[8] = "set:Button14  image:Zungui_Disable",
						[9] = "set:Button14  image:Huagui_Pushed",
						[10] = "set:Button14  image:Huagui_Normal",
						[11] = "set:Button14  image:Huagui_Hover",
						[12] = "set:Button14  image:Huagui_Disable",
						[13] = "set:Button14  image:Xingui_Pushed",
						[14] = "set:Button14  image:Xingui_Normal",
						[15] = "set:Button14  image:Xingui_Hover",
						[16] = "set:Button14  image:Xingui_Disable",
						[17] = "set:Button14  image:Fugui_Pushed",
						[18] = "set:Button14  image:Fugui_Normal",
						[19] = "set:Button14  image:Fugui_Hover",
						[20] = "set:Button14  image:Fugui_Disable",
						[21] = "set:Button14  image:Huagui_Pushed",
						[22] = "set:Button14  image:Huagui_Normal",
						[23] = "set:Button14  image:Huagui_Hover",
						[24] = "set:Button14  image:Huagui_Disable",
					
}
--打开图片
local g_Image2 = {
						[1] = "set:Button15  image:Xingui_kong_Pushed",
						[2] = "set:Button15  image:Xingui_kong_Normal",
						[3] = "set:Button15  image:Xingui_kong_Hover",
						[4] = "set:Button15  image:Xingui_kong_Disable",
						[5] = "set:Button15  image:Zungui_kong_Pushed",
						[6] = "set:Button15  image:Zungui_kong_Normal",
						[7] = "set:Button15  image:Zungui_kong_Hover",
						[8] = "set:Button15  image:Zungui_kong_Disable",
						[9] = "set:Button15  image:Huagui_kong_Pushed",
						[10] = "set:Button15  image:Huagui_kong_Normal",
						[11] = "set:Button15  image:Huagui_kong_Hover",
						[12] = "set:Button15  image:Huagui_kong_Disable",
						[13] = "set:Button15  image:Xingui_kong_Pushed",
						[14] = "set:Button15  image:Xingui_kong_Normal",
						[15] = "set:Button15  image:Xingui_kong_Hover",
						[16] = "set:Button15  image:Xingui_kong_Disable",
						[17] = "set:Button15  image:Huagui_kong_Pushed",
						[18] = "set:Button15  image:Fugui_kong_Normal",
						[19] = "set:Button15  image:Fugui_kong_Hover",
						[20] = "set:Button15  image:Huagui_kong_Disable",
						[21] = "set:Button15  image:Huagui_kong_Pushed",
						[22] = "set:Button15  image:Huagui_kong_Normal",
						[23] = "set:Button15  image:Huagui_kong_Hover",
						[24] = "set:Button15  image:Huagui_kong_Disable",
					
}
function HuaShanLunJian_TopList_PreLoad()
	 this:RegisterEvent("UI_COMMAND")
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("BWTROOP_UPDATE_RANKINGCHARTS")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
end

function HuaShanLunJian_TopList_OnLoad()
	g_nCurSel_MatchBtn={
	[0]=HuaShanLunJian_TopList_Page01,
	[1]=HuaShanLunJian_TopList_Page02,
	[2]=HuaShanLunJian_TopList_Page03,
	}
	g_nMyInfo = {
	[0]=HuaShanLunJian_TopList_MyNumber,
	[1]=HuaShanLunJian_TopList_MyName,
	[2]=HuaShanLunJian_TopList_MyDuan,
	[3]=HuaShanLunJian_TopList_MyLevel,
	[4]=HuaShanLunJian_TopList_MySchool,
	[5]=HuaShanLunJian_TopList_MyWin,
	[6]=HuaShanLunJian_TopList_MyWinRate,
	[7]=HuaShanLunJian_TopList_MyNumberImage,
	--[7]=HuaShanLunJian_TopList_MyClient_WinReward,
	}
	
	g_nListType = {
	[0] = HuaShanLunJian_TopList_Buttontab01,
	[1] = HuaShanLunJian_TopList_Buttontab02,
	}
	
end

function HuaShanLunJian_TopList_OnEvent(event)

	if event == "UI_COMMAND" and tonumber(arg0) == 89293001 then
	    
	--	PushDebugMessage("22222")
		HuaShanLunJian_TopList_ResetControl()
		local targetId=Get_XParam_INT(0)
        g_nObjID = Target:GetServerId2ClientId(targetId)
        if not g_nObjID or g_nObjID < 0 then
            return
        end
		this:CareObject(g_nObjID, 1)
		local nMatchID=Get_XParam_INT(1)
		HuaShanLunJian_TopList_SetColor(nMatchID)
--		PushDebugMessage("2="..Get_XParam_INT(2))
		g_nCurSel_MatchID = nMatchID
		g_myMatchId = nMatchID
		--local isGetAward = Get_XParam_INT(2)
		--g_isGetAward = isGetAward
		local mLevel = Get_XParam_INT(2)
		g_myLevel = mLevel
		--g_nSelf_TroopID =	Get_XParam_INT(3)
		--show myteaminfo
		--HuaShanLunJian_TopList_ShowMyTeam()
		--HuaShanLunJian_TopList_IsGetAward()
		g_TopListType = 1
		this:Show()
		g_nListType[0]:SetCheck(1)
	-- elseif event == "UI_COMMAND" and tonumber(arg0) == 180910 then
		-- local isGetAward = Get_XParam_INT(0)
		-- g_isGetAward = isGetAward
		-- HuaShanLunJian_TopList_Update()
	elseif event == "BWTROOP_UPDATE_RANKINGCHARTS" then
		--PushDebugMessage("2222")
	    if not this:IsVisible() then
	        return
	    end
		g_RankList_nContentButton = {}
		--PushDebugMessage("11111")
	    HuaShanLunJian_TopList_Update()
	    --show myteaminfo
	    --HuaShanLunJian_TopList_ShowMyTeam()
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		this:Hide()
	elseif event == "UI_COMMAND" and tonumber(arg0) == 89293002 then
		local mDW1 = Get_XParam_INT(0)
		local mDW2 = Get_XParam_INT(1)
		local mDW3 = Get_XParam_INT(2)
		local mTotalCnt = Get_XParam_INT(3)
		local mWinCnt = Get_XParam_INT(4)
		HuaShanLunJian_TopList_UpdateSelf(mDW1,mDW2,mDW3,mWinCnt,mTotalCnt)
		return
	end
end

--清空信息
function HuaShanLunJian_TopList_ResetControl()
	--HuaShanLunJian_TopList_List1_Frame:CleanAllElement("HuaShanLunJian_TopList")
	HuaShanLunJian_TopList:Clear()
	for i = 0, 6 do
		g_nMyInfo[i]: SetText("")
	end
	g_nMyInfo[7]:Hide()
end

function HuaShanLunJian_TopList_SetCheck()
	local nMatchID = XBW:GetRankMatchID()
	--PushDebugMessage(nMatchID)
	if g_nCurSel_MatchID~=nMatchID then
		HuaShanLunJian_TopList_SetColor(nMatchID)
	end
end

--填充数据
function HuaShanLunJian_TopList_Update()
	HuaShanLunJian_TopList:Clear()
	HuaShanLunJian_TopList_SetCheck()
	local nListNum = XBW:GetRankListNum()
	--PushDebugMessage(nListNum)
	if nListNum ~= nil and nListNum ~= 0 then
		--HuaShanLunJian_TopList_NullFrame:Hide()
		for i = 0, nListNum-1 do
		--PushDebugMessage("0")
			local szName,nDuanWei,nLevel,nMenPai,nTotalCnt,nTotalWinCnt,nDuanWei1,nStar,nZoneWorldId = XBW:GetRankListInfoByIndex(i)
			if nZoneWorldId ~= -1 then
				local top_world_name = DataPool:GetServerName(tonumber(nZoneWorldId))
				szName = szName.."@"..tostring(top_world_name)
			end
			--PushDebugMessage("1")
			local ItemBar = HuaShanLunJian_TopList:AddChild( "HuaShanLunJian_TopList_Item")
			if ItemBar == nil then
				return 
			end
			--PushDebugMessage("2")
			if g_TopListType == 0 then
				ItemBar:SetEvent( "MouseRClick", string.format("HuaShanLunJian_TopList_OnItemRClick(%d)", i))
			end
			local nameButton = ItemBar:GetSubItem("HuaShanLunJian_TopList_Name")
			nameButton:SetText(szName)
			local duanweiButton = ItemBar:GetSubItem("HuaShanLunJian_TopList_Duan")
			if nDuanWei == 6 then
				duanweiButton:SetText(g_DuanWei1[nDuanWei].."#{HSPH_191120_53}"..nStar.."#{HSPH_191120_30}")
			else
				duanweiButton:SetText(g_DuanWei1[nDuanWei]..g_DuanWei2[nDuanWei1].."#{HSPH_191120_53}"..nStar.."#{HSPH_191120_30}")
			end
			local levelButton = ItemBar:GetSubItem("HuaShanLunJian_TopList_Level")
			levelButton:SetText(nLevel)
			local menpaiButton = ItemBar:GetSubItem("HuaShanLunJian_TopList_School")
			menpaiButton:SetText(g_MenPaiNameList[nMenPai].Name)
			local wincntButton = ItemBar:GetSubItem("HuaShanLunJian_TopList_Win")
			wincntButton:SetText(nTotalWinCnt)
			local winningButton = ItemBar:GetSubItem("HuaShanLunJian_TopList_WinRate")
			if nTotalCnt == 0 then
				winningButton:SetText(nTotalCnt.."%")
			else
				
				winningButton:SetText((math.floor((nTotalWinCnt/nTotalCnt)*100)).."%")
			end
			
			if i == 0 or i == 1 or i == 2 then
				local numimageButton = ItemBar:GetSubItem("HuaShanLunJian_TopList_NumberImage")
				numimageButton:Show()
				if i == 0 then
					numimageButton:SetProperty("Image","set:HSLJ_01 image:HSLJ_One")
				elseif i == 1 then
					numimageButton:SetProperty("Image","set:HSLJ_01 image:HSLJ_Two")
				else
					numimageButton:SetProperty("Image","set:HSLJ_01 image:HSLJ_Three")
				end
				local numButton = ItemBar:GetSubItem("HuaShanLunJian_TopList_Number")
				numButton:Hide()
			else
				local numimageButton = ItemBar:GetSubItem("HuaShanLunJian_TopList_NumberImage")
				numimageButton:Hide()
				local numButton = ItemBar:GetSubItem("HuaShanLunJian_TopList_Number")
				numButton:SetText(i+1)
			end
		
			table.insert(g_RankList_nContentButton,ItemBar)
		end
	-- elseif nListNum == 0 then
		-- HuaShanLunJian_TopList_NullFrame:Show()
		-- HuaShanLunJian_TopList_NullFrame_Text:SetText(g_NoneText[g_nCurSel_MatchID])
	end
	
	local mRank,mName,mLevel,nMenPai = XBW:GetSelfInfo()
	
	if g_myMatchId ~= -1 and g_myMatchId == g_nCurSel_MatchID then
		if mRank < 0 or mRank >= 200 then
			g_nMyInfo[0]:SetText("#{HSPH_191120_19}")
			g_nMyInfo[0]:Show()
			g_nMyInfo[7]:Hide()
		else
			if mRank == 0 then
				g_nMyInfo[7]:SetProperty("Image","set:HSLJ_01 image:HSLJ_One")
				g_nMyInfo[7]:Show()
				g_nMyInfo[0]:Hide()
			elseif mRank == 1 then
				g_nMyInfo[7]:SetProperty("Image","set:HSLJ_01 image:HSLJ_Two")
				g_nMyInfo[7]:Show()
				g_nMyInfo[0]:Hide()
			elseif mRank == 2 then
				g_nMyInfo[7]:SetProperty("Image","set:HSLJ_01 image:HSLJ_Three")
				g_nMyInfo[7]:Show()
				g_nMyInfo[0]:Hide()
			else
				g_nMyInfo[0]:SetText(mRank+1)
				g_nMyInfo[0]:Show()
				g_nMyInfo[7]:Hide()
			end
		end
	else
		g_nMyInfo[0]:SetText("#{HSPH_191120_19}")
		g_nMyInfo[0]:Show()
		g_nMyInfo[7]:Hide()
	end
	
	
end
function HuaShanLunJian_TopList_UpdateSelf(mDW1,mDW2,mDW3,mWinCnt,mTotalCnt)
	local mRank,mName,mLevel,nMenPai = XBW:GetSelfInfo()
	if g_myMatchId ~= -1 and g_myMatchId == g_nCurSel_MatchID then
		if mRank < 0 or mRank >= 200 then
			g_nMyInfo[0]:SetText("未上榜")
			g_nMyInfo[0]:Show()
			g_nMyInfo[7]:Hide()
		else
			if mRank == 0 then
				g_nMyInfo[7]:SetProperty("Image","set:HSLJ_01 image:HSLJ_One")
				g_nMyInfo[7]:Show()
				g_nMyInfo[0]:Hide()
			elseif mRank == 1 then
				g_nMyInfo[7]:SetProperty("Image","set:HSLJ_01 image:HSLJ_Two")
				g_nMyInfo[7]:Show()
				g_nMyInfo[0]:Hide()
			elseif mRank == 2 then
				g_nMyInfo[7]:SetProperty("Image","set:HSLJ_01 image:HSLJ_Three")
				g_nMyInfo[7]:Show()
				g_nMyInfo[0]:Hide()
			else
				g_nMyInfo[0]:SetText(mRank+1)
				g_nMyInfo[0]:Show()
				g_nMyInfo[7]:Hide()
			end
		end
	else
		g_nMyInfo[0]:SetText("#{HSPH_191120_19}")
		g_nMyInfo[0]:Show()
		g_nMyInfo[7]:Hide()
	end
	g_nMyInfo[1]:SetText(mName)
	g_nMyInfo[3]:SetText(mLevel)
	g_nMyInfo[4]:SetText(g_MenPaiNameList[nMenPai].Name)
	
	local nMyLevel = Player:GetData( "LEVEL" )
	local nLevelIndex = -1
	if g_startLevel <= nMyLevel and nMyLevel <= g_mid1Level then
		nLevelIndex = 0
	elseif g_mid1Level < nMyLevel and nMyLevel <= g_mid2Level then
		nLevelIndex = 1
	elseif g_mid2Level < nMyLevel and nMyLevel <= g_endLevel then
		nLevelIndex = 2
	end
	
	if nLevelIndex >= 0 and  nLevelIndex < 3 then
		if mDW1 ~= 6 then
			if mDW3 == 0 then
				g_nMyInfo[2]:SetText(g_NewMatchLevelName[nLevelIndex]..g_DuanWei1[mDW1]..g_DuanWei2[mDW2].."#{HSPH_191120_29}")--.."零".."星")
			else
				g_nMyInfo[2]:SetText(g_NewMatchLevelName[nLevelIndex]..g_DuanWei1[mDW1]..g_DuanWei2[mDW2].."#{HSPH_191120_29}")--..g_DuanWei3[mDW3].."星")
			end
		else
			if mDW3 == 0 then
				g_nMyInfo[2]:SetText(g_NewMatchLevelName[nLevelIndex]..g_DuanWei1[mDW1].."#{HSPH_191120_53}".."0".."#{HSPH_191120_30}")
			else
				g_nMyInfo[2]:SetText(g_NewMatchLevelName[nLevelIndex]..g_DuanWei1[mDW1].."#{HSPH_191120_53}"..mDW3.."#{HSPH_191120_30}")
			end
		end
	else
		g_nMyInfo[2]:SetText("无")
	end
	g_nMyInfo[5]:SetText(mWinCnt)
	if mTotalCnt ~= 0 then
		g_nMyInfo[6]:SetText((math.floor((mWinCnt/mTotalCnt)*100)).."%")
	else
		g_nMyInfo[6]:SetText(mTotalCnt.."%")
	end
end

-- 点击换页
function HuaShanLunJian_TopList_ChangeTabIndex(nIdx)
	if nIdx==g_nCurSel_MatchID then
		return
	end
	--g_nCurSel_MatchID = nIdx
	local ClickFlag=XBW:CanQueryRankingAgain()
	if ClickFlag ~= 1 then
	    --PushDebugMessage("#{ZBS_YXS_120301_86}")--字典共同吧
	    return
	end
	if nIdx>=0 and nIdx<=2 then
		HuaShanLunJian_TopList_SetColor(nIdx)
		--BWDH:RequsetRankingCharts(nIdx,0)
		--在这地方去调服务端的脚本的函数,请求排行榜数据
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("QueryRankList")
			Set_XSCRIPT_ScriptID(892930)
			Set_XSCRIPT_Parameter(0, nIdx)
			Set_XSCRIPT_Parameter(1, g_TopListType)
			Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT();
		HuaShanLunJian_TopList_ResetControl()
	end
end

function HuaShanLunJian_TopList_SetColor(index)
	if index>=0 and index<=2 then
		g_nCurSel_MatchID = index
		for i=0,2 do
			if i==index then
				g_nCurSel_MatchBtn[i]:SetText(g_NewMatchLevelName[i])
				g_nCurSel_MatchBtn[i]:SetCheck(1)
			else
				g_nCurSel_MatchBtn[i]:SetText(g_NewMatchLevelName[i])
				g_nCurSel_MatchBtn[i]:SetCheck(0)
			end
		end
	end
end

function HuaShanLunJian_TopList_Close()
	this:Hide()
end

-- 原服和t服切换排行榜
function HuaShanLunJian_TopList_ChangeTopList(index)
	if index < 0 or index > 1 then
		return
	end
	if index == 0 then
		g_TopListType = 1
	else 
		g_TopListType = 0
	end
	for i = 0, 1 do
		g_nListType[i]:SetCheck(0)
	end
	g_nListType[index]:SetCheck(1)
	HuaShanLunJian_TopList_SetColor(g_myMatchId)
	--BWDH:RequsetRankingCharts(nIdx,0)
	--在这地方去调服务端的脚本的函数,请求排行榜数据
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("QueryRankList")
		Set_XSCRIPT_ScriptID(892930)
		Set_XSCRIPT_Parameter(0, g_myMatchId)
		Set_XSCRIPT_Parameter(1, g_TopListType)
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT();
	HuaShanLunJian_TopList_ResetControl()
	
end

function HuaShanLunJian_TopList_OnItemRClick(nIndex)
	
	local mRank,mName,mLevel,nMenPai = XBW:GetSelfInfo()
	if g_myMatchId ~= -1 and g_myMatchId == g_nCurSel_MatchID and mRank == nIndex then
		return 
	else
		if nIndex >= 0 and nIndex < 50 then
			XBW:Show_PopMemu(nIndex)
		end
	end

end

function HuaShanLunJian_TopList_OnCheckButton1Click()
end

-- 领奖
-- function HuaShanLunJian_TopList_OnButton1Click()

	-- if g_nCurSel_MatchID > 0 and g_nCurSel_MatchID <= 2 then 
		-- BWDH2018:GetRankAward(g_nCurSel_MatchID)
	-- end
	-- --PushDebugMessage("恭喜云端小哥哥点到了我")
-- end

-- function HuaShanLunJian_TopList_OnItemClick()
	
	-- local sPos,ePos = string.find(arg0, "_auto_element")
	-- local nIndex = tonumber(string.sub(arg0, ePos + 1, -1)) + 1
	
	-- if nIndex >= 0 then
		-- local nNum = table.getn(g_RankList_nContentButton)
		-- for nButtonIndex = 1,nNum do
			-- if nil ~= g_RankList_nContentButton[nButtonIndex] then
				-- if nButtonIndex ~= nIndex then
					-- g_RankList_nContentButton[nButtonIndex]:SetBarButtonSelected(false)
				-- else
					-- g_RankList_nContentButton[nButtonIndex]:SetBarButtonSelected(true)
				-- end
			-- end
		-- end
	-- end
	
-- end

-- function HuaShanLunJian_TopList_IsGetAward()

	-- Clear_XSCRIPT();
		-- Set_XSCRIPT_Function_Name("IsGetAward")
		-- Set_XSCRIPT_ScriptID(892897)
		-- Set_XSCRIPT_ParamCount(0)
	-- Send_XSCRIPT();

-- end