--!!!reloadscript =Friend
--Q546528533 仅供娱乐交流
--好友界面的默认位置
local g_Friend_Frame_UnifiedXPosition
local g_Friend_Frame_UnifiedYPosition

local g_PagePosTop = 0
local g_StepSize = 20
local g_Pages = {}

local g_CurPage = 0
local g_ListHeight = 0

local g_IsTeamOutLine = {}
local g_TeamOutLineStr = {}

local g_imgStar = {}

local g_CurStatus = 0

local g_imgStatus = {}

local g_FriendBlank = "   "		--3个空格缩进
local g_RemarkBlank = "  "		--2个空格缩进

local g_Current_Clicked = -1

local g_GroupTitleColor_WM = "#ce6c3a7#e4e3014"
local g_GroupTitleColor = "#gFE7E82 "

local g_FriendBorderColor = "#e010101"

local g_SpecialFriendOutLine = {}

local g_CurSelListItemID = -1

local currentList = 1 
--===============================================
-- OnLoad()
--===============================================
function Friend_PreLoad()

	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("TOGLE_FRIEND")
	this:RegisterEvent("UPDATE_FRIEND")
	this:RegisterEvent("UPDATE_FRIEND_INFO")
	this:RegisterEvent("FRIENDSEARCH_RESULT")
	this:RegisterEvent("UPDATE_RECENT")
	this:RegisterEvent("UPDATE_GROUPINGNAME")
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
end

function Friend_OnLoad()

	g_Friend_Frame_UnifiedXPosition	= Friend_Frame:GetProperty("UnifiedXPosition")
	g_Friend_Frame_UnifiedYPosition	= Friend_Frame:GetProperty("UnifiedYPosition")

	g_Pages = {
				Friend_List_Page1,
				Friend_List_Page2, 
				Friend_List_Page3,
			}

	g_PagePosTop = Friend_List_Page1:GetProperty("AbsoluteYPosition")
	g_CurPage = 0
	g_ListHeight = Friend_List:GetProperty("AbsoluteHeight")

	g_IsTeamOutLine = {0,0,0,0,0,0,0}
	g_TeamOutLineStr = {
							"#{KDHYYH_211025_37}",
							"#{KDHYYH_211025_38}",
							"#{KDHYYH_211025_39}",
							"#{KDHYYH_211025_40}",
							"黑名单",		--黑名单
							"仇人",		--仇人
							"临时好友",		--临时好友
						}


	g_imgStatus = {
			[0] = { [0] = "#-27" ,[1] = "#-28" ,[2] = "#-29"} ,
			[1] = { [0] = "#-24" ,[1] = "#-25" ,[2] = "#-26"} ,
		}

	g_Current_Clicked = -1

end

--===============================================
-- OnEvent()
--===============================================
function Friend_OnEvent( event )
	if event == "TOGLE_FRIEND" then
		if arg0 == "2" then
			if this:IsVisible() then
				Friend_Hide()
			else
				Friend_Show()
			end
		elseif arg0 == "1" then
			Friend_Show()
		else
			Friend_Hide()
		end
	elseif event == "UPDATE_FRIEND" and this:IsVisible() then
		if g_CurPage == 1 then
			g_Current_Clicked = Friend_List:GetCurrentFirstItem()
			Friend_Update()
		end
	elseif event == "HIDE_ON_SCENE_TRANSED" and this:IsVisible() then
		Friend_Hide()
		return	
	elseif event == "UPDATE_RECENT" and this:IsVisible() then
		if g_CurPage == 2 then
			g_Current_Clicked = Friend_List:GetCurrentFirstItem()
			Friend_Recent_List()
		end
	elseif event == "UPDATE_FRIEND_INFO" and this:IsVisible() then
		if g_CurPage == 1 then
			if tonumber(arg0) == currentList then
				Friend_UpdateFriendInfo(tonumber(arg0), tonumber(arg1))
			end
		elseif g_CurPage == 2 then
			local guid = DataPool:GetFriend(tonumber(arg0), tonumber(arg1), "ID")
			local nIndex = DataPool:GetIMRecentByGUID(guid)
			Friend_Update_Recent(nIndex)
		elseif g_CurPage == 3 then
			local guid = DataPool:GetFriend(tonumber(arg0), tonumber(arg1), "ID")
			local nIndex = DataPool:GetSearchResultByGUID(guid)
			Friend_Update_SearchResult(nIndex)
		end
	elseif event == "UPDATE_GROUPINGNAME" and this:IsVisible() then
		Friend_SetGroupingName()
		if g_CurPage == 1 then
			g_Current_Clicked = Friend_List:GetCurrentFirstItem()
			Friend_Update()
		end
	elseif event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		Friend_ResetPos()
	elseif event == "FRIENDSEARCH_RESULT" then
		if g_CurPage == 3 then
			g_Current_Clicked = -1
			Friend_List_SearchResult()
		else
			Friend_SwitchPage(3)
		end
 
	end
end

function Friend_ResetPos()
	Friend_Frame:SetProperty("UnifiedXPosition", g_Friend_Frame_UnifiedXPosition)
	Friend_Frame:SetProperty("UnifiedYPosition", g_Friend_Frame_UnifiedYPosition)
end

function Friend_Show()
	
	this:Show()
	local strHead = Player:GetData("PORTRAIT")
	local strName = Player:GetName()
	Friend_SelfHead:SetProperty("Image", strHead)
	Friend_SelfName:SetText(strName)
	Friend_SetGroupingName()
	
	local MyHeadFrameImage = Player:GetData("HEADFRAMEIMAGE")
	local IconFile = GetIconFullName(MyHeadFrameImage)
	Friend_SelfHeadFrame:SetProperty("Image", IconFile)
	
	g_Current_Clicked = Friend_List:GetCurrentFirstItem()
	
	if g_CurPage == 1 then
		Friend_Update()
	elseif g_CurPage == 2 then
		Friend_Recent_List()
	elseif g_CurPage == 3 then
		Friend_List_SearchResult()
	else
		Friend_SwitchPage(1)
	end
end

function Friend_SwitchPage(page)

	if page < 1 or page > 3 then
		return
	end

	if g_CurPage == page then
		
		if page ~= 1 then
			return
		end
		
		local nTeamOutLineValue = 0
		for i = 1, 7 do
			if g_IsTeamOutLine[i] == 0 then
				nTeamOutLineValue = 1
				break
			end
		end		
		
		for i = 1, 7 do
			g_IsTeamOutLine[i] = nTeamOutLineValue
		end
				
		Friend_Update()
		return
	end

	g_CurPage = page

	local pos = 0
	for i = 1, 3 do
		pos = tonumber(g_PagePosTop) + tonumber(g_StepSize) * (i - 1)
		if i > page then
			pos = pos + (tonumber(g_ListHeight))
		end
		g_Pages[i]:SetProperty("AbsoluteYPosition", tostring(pos))
		if i == page then
			Friend_List:SetProperty("AbsoluteYPosition", tostring(pos + g_StepSize))
		end
	end
	
	--页面切换归位
	g_Current_Clicked = -1

	if page == 1 then
		Friend_Update()
	elseif page == 2 then
		Friend_Recent_List()
	elseif page == 3 then
		Friend_List_SearchResult()
	end
end

function Friend_UpdateFriendInfo(nChannel, nIndex)
	local name = DataPool:GetFriend(nChannel, nIndex, "NAME")
	local remark = Friend_GetSpecialRemark(nChannel, nIndex)
	local emotion = DataPool:GetFriend(nChannel, nIndex, "MOOD")
	local friendship = DataPool:GetFriend(nChannel, nIndex, "FRIENDSHIP")
	local relationtype = DataPool:GetFriend(nChannel, nIndex, "RELATION_TYPE")		
	local IMst = 2--DataPool:GetFriend(nChannel, nIndex, "IM_STATUS")
	local Sex = LuaFnFriendGetFriend(nChannel, nIndex, "SEX")
	local haveMsg = DataPool:GetFriend(nChannel, nIndex, "HAVEMSG")
	local guid = DataPool:GetFriend(nChannel, nIndex, "ID")

	local namecolor = "#cC4B299"

	local bShine = ""
	if haveMsg == 1 then
		bShine = "#b"
	end
	
	local moodColor = "#cFFCC7A"
	local playerIcon = g_RemarkBlank

	if DataPool:GetFriend(nChannel, nIndex, "ONLINE") then
		if nChannel == 6 then 								--仇人
			namecolor = "#cFF0000"
		else
			if relationtype == 7 or relationtype == 8 then	-- 7：师傅 8：徒弟
				namecolor = "#cFF6600"
			elseif relationtype == 3 then					-- 3：情侣
				namecolor = "#cF246F0"
			elseif relationtype == 2 then					-- 2：结拜
				namecolor = "#c007EFF"
			elseif friendship >= 10 then
				namecolor = "#c00FF00"
			elseif friendship >= 1 then
				namecolor = "#c00C800"
			elseif friendship == 0 then	
				namecolor = "#cFFFFFF"
			end
		end
		
		if IMst >= 0 and IMst <= 2 and Sex >= 0 and Sex <= 1 then
			playerIcon = g_imgStatus[Sex][IMst]
		end
		
		-- local idx = Friend_List:GetItemNumByItemId(nChannel*10000 + nIndex + 1)
		-- if idx ~= -1 then
			
			local listName = ""
			if remark ~= nil and remark ~= "" then
				listName = g_FriendBlank..playerIcon..bShine..namecolor..name.."#r"..g_FriendBlank..g_RemarkBlank..namecolor.."("..remark..")"
			else
				listName = g_FriendBlank..playerIcon..bShine..namecolor..name
			end
			
			local listmood = g_FriendBlank..g_RemarkBlank..moodColor..emotion

			Friend_List:SetListItemText(nIndex, g_FriendBorderColor..listName.."#r"..listmood)
			
		-- end
	else
		if nChannel == 6 then
			namecolor = "#cc7b299"
		end
		
		-- local idx = Friend_List:GetItemNumByItemId(nChannel*10000 + nIndex + 1)
		-- if idx ~= -1 then
			local listName = ""
			if remark ~= nil and remark ~= "" then
				listName = g_FriendBlank..playerIcon..bShine..namecolor..name.."#r"..g_FriendBlank..g_RemarkBlank..namecolor.."("..remark..")"
			else
				listName = g_FriendBlank..playerIcon..bShine..namecolor..name
			end
			
			Friend_List:SetListItemText(nIndex, g_FriendBorderColor..listName)
		-- end
	end

end

function GetFriendOnlineNumberCommon(GroupId)
	if GroupId == nil then
		return 0
	end
	if GroupId < 1 or GroupId > 4 then
		return 0
	end
	local onlienCount = 0
	local groupCount = DataPool:GetFriendNumber( tonumber( GroupId ) );--每组人数
	for j = 0,groupCount - 1 do
		if DataPool:GetFriend( GroupId, j, "ONLINE" ) == true then
			onlienCount = onlienCount + 1
		end
	end
	return onlienCount
end

function Friend_Update()
	
	Friend_List:ClearListBox()	
	
	local FriendCount = 0 			--好友总数
	local OnlineFriendCount = 0 	--在线好友总数
	local FriendInfo = {}
	
	--共7组
	for i = 1, 7 do		
		local fGroupIndex = i
		if i == 7 then
			fGroupIndex = 8	--临时好友分组的索引特殊
		end
		
		FriendInfo[i] = ""
		if fGroupIndex >= 1 and fGroupIndex <= 4 then
			local groupCount = DataPool:GetFriendNumber(fGroupIndex)				--每组人数
			local onlienCount= GetFriendOnlineNumberCommon(fGroupIndex)			--每组在线人数
			FriendInfo[fGroupIndex] = "(" .. onlienCount .."/" ..groupCount ..")"
			FriendCount = FriendCount + groupCount
			OnlineFriendCount = OnlineFriendCount + onlienCount
		end

		local strOutlineName = ""
		if g_IsTeamOutLine[i] == 1 then
			strOutlineName = g_GroupTitleColor.."- "..g_TeamOutLineStr[i]..FriendInfo[i]
		else
			strOutlineName = g_GroupTitleColor.."+ "..g_TeamOutLineStr[i]..FriendInfo[i]
		end

		if strOutlineName ~= "" or strOutlineName ~= 0 then
			local iStart = fGroupIndex*10000
			local friendnumber = DataPool:GetFriendNumber(fGroupIndex)
			if friendnumber < 1 then
				strOutlineName = g_GroupTitleColor.."- "..g_TeamOutLineStr[i] .. FriendInfo[i]
			end			

			Friend_List:AddItem(strOutlineName, iStart)
			
			if g_IsTeamOutLine[i] == 1 then
				local index = 0
				while index < friendnumber do
					Friend_AddFriendItem(fGroupIndex, index)
					index = index + 1
				end
			end
		end
	end
	
	g_Pages[1]:SetText("联 系 人".."("..FriendCount.."/" .."80" ..")")

	if g_Current_Clicked ~= -1 then
		Friend_List:SetCurrentFirstItem(g_Current_Clicked)
		g_Current_Clicked = -1
	end
	
	if g_CurSelListItemID >= 0 then
		Friend_List:SetItemSelectByItemID(g_CurSelListItemID)
	end
end

function Friend_AddFriendItem(nChannel, nIndex)

	local name = DataPool:GetFriend(nChannel, nIndex, "NAME")
	local remark = Friend_GetSpecialRemark(nChannel, nIndex)
	local emotion = DataPool:GetFriend(nChannel, nIndex, "MOOD")
	local friendship = DataPool:GetFriend(nChannel, nIndex, "FRIENDSHIP")
	local relationtype = DataPool:GetFriend(nChannel, nIndex, "RELATION_TYPE")
	local IMst = 2--DataPool:GetFriend(nChannel, nIndex, "IM_STATUS")
	local Sex = LuaFnFriendGetFriend(nChannel, nIndex, "SEX")
	local haveMsg = DataPool:GetFriend(nChannel, nIndex, "HAVEMSG")
	local guid = DataPool:GetFriend(nChannel, nIndex, "ID")
	local nLevel = DataPool:GetFriend(nChannel, nIndex, "LEVEL")
	local namecolor = "#cC4B299"
	
	local bShine = ""
	if haveMsg == 1 then
		bShine = "#b"
	end
	
	local moodColor = "#cFFCC7A"
	local playerIcon = g_RemarkBlank	
	
	local isbindapp = 0--DataPool:GetFriend(nChannel, nIndex, "FRIEND_ISAPPBIND") --0未绑定，1绑定
	
	if DataPool:GetFriend(nChannel, nIndex, "ONLINE") then
		if nChannel == 6 then 								--仇人
			namecolor = "#cFF0000"
		else
			if relationtype == 7 or relationtype == 8 then	-- 7：师傅 8：徒弟
				namecolor = "#cFF6600"
			elseif relationtype == 3 then					-- 3：情侣
				namecolor = "#cF246F0"
			elseif relationtype == 2 then					-- 2：结拜
				namecolor = "#c007EFF"
			elseif friendship >= 10 then
				namecolor = "#c00FF00"
			elseif friendship >= 1 then
				namecolor = "#c00C800"
			elseif friendship == 0 then	
				namecolor = "#cFFFFFF"
			end
		end
		
		if IMst >= 0 and IMst <= 2 and Sex >= 0 and Sex <= 1 then
			playerIcon = g_imgStatus[Sex][IMst]
		end
		
		local listName = ""
		if remark ~= nil and remark ~= "" then
			listName = g_FriendBlank..playerIcon..bShine..namecolor..name.."#r"..g_FriendBlank..g_RemarkBlank..namecolor.."("..remark..")"
		else
			listName = g_FriendBlank..playerIcon..bShine..namecolor..name
		end
		
		local listmood = g_FriendBlank..g_RemarkBlank..moodColor..emotion
	
		if nChannel > 0 and nChannel < 5 and nIndex >= 0 then
			Friend_List:AddItem(g_FriendBorderColor..listName.."#r"..listmood, nChannel*10000 + nIndex + 1, "FFFFFFFF", 4 )
		else
			Friend_List:AddItem(g_FriendBorderColor..listName.."#r"..listmood , nChannel*10000 + nIndex + 1 , "FFFFFFFF", 4 )
		end

	else
		if nChannel == 6 then
			namecolor = "#cc7b299"		--仇人
		end
		
		local listName = ""
		if remark ~= nil and remark ~= "" then
			listName = g_FriendBlank..playerIcon..bShine..namecolor..name.."#r"..g_FriendBlank..g_RemarkBlank..namecolor.."("..remark..")"
		else
			listName = g_FriendBlank..playerIcon..bShine..namecolor..name
		end

		if nChannel == 1 or nChannel == 2 or nChannel == 3 or nChannel == 4 then
			Friend_List:AddItem(g_FriendBorderColor..listName, nChannel*10000 + nIndex + 1 , "FFFFFFFF", 4 )
		else
			Friend_List:AddItem(g_FriendBorderColor..listName, nChannel*10000 + nIndex + 1, "FFFFFFFF", 4  )
		end
	end

end

function Friend_OnHelp()
	Helper:GotoHelper("*Friend")
end

function Friend_OnCloseClick()
	this:Hide()
end

function Friend_Hide()
	this:Hide()
end

function Friend_OnHidden()
	Friend_List:ClearListBox()
	g_CurSelListItemID = -1
end
--双击
function Friend_FriendSelect()
	if g_CurPage == 1 then
		
		local index = Friend_List:GetFirstSelectItem()
		if index == -1 then
			return
		end
		
		local iMod = math.mod(index, 10000)
		local iFloor = math.floor(index / 10000)
		if iFloor == 5 then		--黑名单
			return			
		end
		
		if iFloor == 6 then		--仇人
			PushDebugMessage("与对方为仇人关系，仅可以使用右键菜单。")
			return
		end
		
		-- DataPool:OpenIMChat(iFloor, iMod - 1)
		PushEvent("UI_COMMAND",2022070501,iFloor, iMod - 1)
	elseif g_CurPage == 2 then
		local nIndex = Friend_List:GetFirstSelectItem()
		local guid, sName = DataPool:GetIMRecentByIndex(nIndex)
		local nChannel, nIndex = DataPool:GetFriendByName(sName)

		if (nChannel > 0 and nChannel < 5 and nIndex >= 0) or (nChannel == 8 and nIndex >= 0) then
			-- DataPool:OpenIMChat(nChannel , nIndex)
			PushEvent("UI_COMMAND",2022070501,nChannel , nIndex)
		end
	elseif g_CurPage == 3 then
		local index = Friend_List:GetFirstSelectItem()
		if index == -1 then
			return
		end
		
		local sGuid, sName = DataPool:GetSearchResultByIndex(index)
		if sGuid ~= "" and sName ~= "" then
			local nChannel, nIndex = DataPool:GetFriendByName(sName)
			if (nChannel > 0 and nChannel < 5 and nIndex >= 0) or (nChannel == 8 and nIndex >= 0) then
				-- DataPool:OpenIMChat(nChannel , nIndex)
				PushEvent("UI_COMMAND",2022070501,nChannel , nIndex)
			end
		end
	end
end
--打开菜单
function Friend_OpenMenu()
	if g_CurPage == 1 then
		local index = Friend_List:GetFirstSelectItem()
		if index == -1 then
			return
		end
		
		local iMod = math.mod(index, 10000)
		local iFloor = math.floor(index / 10000)
		Friend:SetCurrentSelect( iMod - 1);
		Friend:SetCurrentTeam( iFloor );
	
		Friend:OpenMenu(tostring(iFloor), tostring(iMod - 1))

	elseif g_CurPage == 2 then
		
		local nIndex = Friend_List:GetFirstSelectItem()
		local guid, sName = DataPool:GetIMRecentByIndex(nIndex)
		local nChannel , nIndex = DataPool:GetFriendByName(sName)

		if nChannel > 0 and nIndex >= 0 then
			Friend:OpenMenu(tostring(nChannel), tostring(nIndex))
		end
		Friend:SetCurrentSelect( iMod - 1);
		Friend:SetCurrentTeam( iFloor );

	elseif g_CurPage == 3 then
		local index = Friend_List:GetFirstSelectItem()
		if index == -1 then
			return
		end
		
		local sGuid, sName = DataPool:GetSearchResultByIndex(index)
		if sGuid ~= "" and sName ~= "" then
			local nChannel, nIndex = DataPool:GetFriendByName(sName)
			if nChannel > 0 and nIndex >= 0 then
				Friend:OpenMenu(tostring(nChannel), tostring(nIndex))
			end
		end	
	end
end

function Friend_List_SelectChanged()

	if g_CurPage == 1 then
		
		local nSelIndex = Friend_List:GetFirstSelectItem()
		currentList = nSelIndex
		local iMod = math.mod(nSelIndex, 10000)
		local iFloor = math.floor(nSelIndex / 10000)
		if 0 == iMod then
		
			local outLineIndex = iFloor
			if iFloor == 8 then
				outLineIndex = 7
			end
			
			if 0 == g_IsTeamOutLine[outLineIndex] then
				g_IsTeamOutLine[outLineIndex] = 1
			else
				g_IsTeamOutLine[outLineIndex] = 0
			end
			
			g_Current_Clicked = Friend_List:GetCurrentFirstItem()			
			Friend_Update()
			return
		else
			g_CurSelListItemID = nSelIndex
		end
	end
end

--搜索结果页面
function Friend_List_SearchResult()

	Friend_List:ClearListBox()
	-- local rtNum = DataPool:GetSearchResultNum()
	
	-- for i = 0, rtNum - 1 do
		
		-- local guid, sName = DataPool:GetSearchResultByIndex(i)
		-- local nChannel, nIndex = DataPool:GetFriendByName(sName)
		
		-- if (nChannel >= 1 and nChannel <= 5 and nIndex >= 0) or (nChannel == 8 and nIndex >= 0) then
			-- local name = DataPool:GetFriend(nChannel, nIndex, "NAME")
			-- local remark = Friend_GetSpecialRemark(nChannel, nIndex)
			-- local emotion = DataPool:GetFriend(nChannel, nIndex, "MOOD")
			-- local friendship = DataPool:GetFriend(nChannel, nIndex, "FRIENDSHIP")
			-- local relationtype = DataPool:GetFriend(nChannel, nIndex, "RELATION_TYPE")
			-- local haveMsg = DataPool:GetFriend(nChannel, nIndex, "HAVEMSG")

			-- local namecolor = "#cC4B299"

			-- local bShine = ""
			-- if haveMsg == 1 then
				-- bShine = "#b"
			-- end
			-- local moodColor = "#cFFCC7A"				

			-- local IMst = 2--DataPool:GetFriend(nChannel, nIndex, "IM_STATUS")
			-- local Sex = LuaFnFriendGetFriend(nChannel, nIndex, "SEX")
			-- local playerIcon = g_RemarkBlank

			-- if DataPool:GetFriend(nChannel, nIndex, "ONLINE") then
				-- if nChannel == 6 then 								--仇人
					-- namecolor = "#cFF0000"
				-- else
					-- if relationtype == 7 or relationtype == 8 then	-- 7：师傅 8：徒弟
						-- namecolor = "#cFF6600"
					-- elseif relationtype == 3 then					-- 3：情侣
						-- namecolor = "#cF246F0"
					-- elseif relationtype == 2 then					-- 2：结拜
						-- namecolor = "#c007EFF"
					-- elseif friendship >= 10 then
						-- namecolor = "#c00FF00"
					-- elseif friendship >= 1 then
						-- namecolor = "#c00C800"
					-- elseif friendship == 0 then	
						-- namecolor = "#cFFFFFF"
					-- end
				-- end
				
				-- if IMst >= 0 and IMst <= 2 and Sex >=0 and Sex <= 1 then
					-- playerIcon = g_imgStatus[Sex][IMst]
				-- end
				
				-- local listName = ""
				-- if remark ~=nil and remark ~= "" then
					-- listName = playerIcon..bShine..namecolor..name.."#r"..g_RemarkBlank..namecolor.."("..remark..")"
				-- else
					-- listName = playerIcon..bShine..namecolor..name
				-- end
				
				-- local listmood = g_RemarkBlank..moodColor..emotion
				-- Friend_List:AddItem(g_FriendBorderColor..listName.."#r"..listmood, i, "FFFFFFFF", 4)					
			-- else
				-- if nChannel == 6 then
					-- namecolor = "#cc7b299"
				-- end
				
				-- local listName = ""
				-- if remark ~=nil and remark ~= "" then
					-- listName = playerIcon..bShine..namecolor..name.."#r"..g_RemarkBlank..namecolor.."("..remark..")"
				-- else
					-- listName = playerIcon..bShine..namecolor..name
				-- end
				-- Friend_List:AddItem(g_FriendBorderColor..listName, i,"FFFFFFFF", 4)
			-- end
		-- end

	-- end
	
	-- if g_Current_Clicked ~= -1 then
		-- Friend_List:SetCurrentFirstItem(g_Current_Clicked)
		-- g_Current_Clicked = -1
	-- end
end

--更新搜索结果页面某一个玩家
function Friend_Update_SearchResult(nIndex)
	
	local idx = Friend_List:GetItemNumByItemId(nIndex)
	if idx == -1 then
		return
	end
	
	local guid, sName = DataPool:GetSearchResultByIndex(nIndex)
	local nChannel, nIndex = DataPool:GetFriendByName(sName)
	if (nChannel >= 1 and nChannel <= 5 and nIndex >= 0) or (nChannel == 8 and nIndex >= 0) then
		local name = DataPool:GetFriend(nChannel, nIndex, "NAME")
		local remark = Friend_GetSpecialRemark(nChannel, nIndex)
		local emotion = DataPool:GetFriend(nChannel, nIndex, "MOOD")
		local friendship = DataPool:GetFriend(nChannel, nIndex, "FRIENDSHIP")
		local relationtype = DataPool:GetFriend(nChannel, nIndex, "RELATION_TYPE")
		local haveMsg = DataPool:GetFriend(nChannel, nIndex, "HAVEMSG")

		local namecolor = "#cC4B299"

		local bShine = ""
		if haveMsg == 1 then
			bShine = "#b"
		end
		local moodColor = "#cFFCC7A"				

		local IMst = 2--DataPool:GetFriend(nChannel, nIndex, "IM_STATUS")
		local Sex = LuaFnFriendGetFriend(nChannel, nIndex, "SEX")
		local playerIcon = g_RemarkBlank

		if DataPool:GetFriend(nChannel, nIndex, "ONLINE") then
			if nChannel == 6 then 								--仇人
				namecolor = "#cFF0000"
			else
				if relationtype == 7 or relationtype == 8 then	-- 7：师傅 8：徒弟
					namecolor = "#cFF6600"
				elseif relationtype == 3 then					-- 3：情侣
					namecolor = "#cF246F0"
				elseif relationtype == 2 then					-- 2：结拜
					namecolor = "#c007EFF"
				elseif friendship >= 10 then
					namecolor = "#c00FF00"
				elseif friendship >= 1 then
					namecolor = "#c00C800"
				elseif friendship == 0 then	
					namecolor = "#cFFFFFF"
				end
			end
			
			if IMst >= 0 and IMst <= 2 and Sex >=0 and Sex <= 1 then
				playerIcon = g_imgStatus[Sex][IMst]
			end
			
			local listName = ""
			if remark ~= nil and remark ~= "" then
				listName = playerIcon..bShine..namecolor..name.."#r"..g_RemarkBlank..namecolor.."("..remark..")"
			else
				listName = playerIcon..bShine..namecolor..name
			end
				
			local listmood = g_RemarkBlank..moodColor..emotion
			Friend_List:SetListItemText(idx, g_FriendBorderColor..listName.."#r"..listmood)
			
		else
			if nChannel == 6 then
				namecolor = "#cc7b299"
			end
				
			local listName = ""
			if remark ~=nil and remark ~= "" then
				listName = playerIcon..bShine..namecolor..name.."#r"..g_RemarkBlank..namecolor.."("..remark..")"
			else
				listName = playerIcon..bShine..namecolor..name
			end
			Friend_List:SetListItemText(idx, g_FriendBorderColor..listName );
		end
	end

end

--最近联系人界面
function Friend_Recent_List()
	
	Friend_List:ClearListBox()
	
	-- for i = 0, 19 do
	
		-- local guid, sName = DataPool:GetIMRecentByIndex(i)			
		-- local nChannel, nIndex = DataPool:GetFriendByName(sName)
		-- if nChannel ~= -1 and nIndex ~= -1 then
			-- local name = DataPool:GetFriend(nChannel, nIndex, "NAME")
			-- local remark = Friend_GetSpecialRemark(nChannel, nIndex)
			-- local emotion = DataPool:GetFriend(nChannel, nIndex, "MOOD")
			-- local friendship = DataPool:GetFriend(nChannel, nIndex, "FRIENDSHIP")
			-- local relationtype = DataPool:GetFriend(nChannel, nIndex, "RELATION_TYPE")
			-- local haveMsg = DataPool:GetFriend(nChannel, nIndex, "HAVEMSG")

			-- local namecolor = "#cC4B299"

			-- local bShine = ""
			-- if haveMsg == 1 then
				-- bShine = "#b"
			-- end
			
			-- local moodColor = "#cFFCC7A"
				
			-- local IMst = 2--DataPool:GetFriend(nChannel, nIndex, "IM_STATUS")
			-- local Sex = LuaFnFriendGetFriend(nChannel, nIndex, "SEX")
			-- local playerIcon = g_RemarkBlank

			-- if DataPool:GetFriend(nChannel, nIndex, "ONLINE") then
				-- if nChannel == 6 then 								--仇人
					-- namecolor = "#cFF0000"
				-- else
					-- if relationtype == 7 or relationtype == 8 then	-- 7：师傅 8：徒弟
						-- namecolor = "#cFF6600"
					-- elseif relationtype == 3 then					-- 3：情侣
						-- namecolor = "#cF246F0"
					-- elseif relationtype == 2 then					-- 2：结拜
						-- namecolor = "#c007EFF"
					-- elseif friendship >= 10 then
						-- namecolor = "#c00FF00"
					-- elseif friendship >= 1 then
						-- namecolor = "#c00C800"
					-- elseif friendship == 0 then	
						-- namecolor = "#cFFFFFF"
					-- end
				-- end
				
				-- if IMst >= 0 and IMst <= 2 and Sex >=0 and Sex <= 1 then
					-- playerIcon = g_imgStatus[Sex][IMst]
				-- end
				
				-- local listName = ""
				-- if remark ~= nil and remark ~= "" then
					-- listName = playerIcon..bShine..namecolor..name.."#r"..g_RemarkBlank..namecolor.."("..remark..")"
				-- else
					-- listName = playerIcon..bShine..namecolor..name
				-- end
				
				-- local listmood = g_RemarkBlank..moodColor..emotion
				-- Friend_List:AddItem(g_FriendBorderColor..listName.."#r"..listmood, i, "FFFFFFFF", 4)
				
			-- else
				-- if nChannel == 6 then
					-- namecolor="#cc7b299"
				-- end
					
				-- local listName = ""
				-- if remark ~= nil and remark ~= "" then
					-- listName = playerIcon..bShine..namecolor..name.."#r"..g_RemarkBlank..namecolor.."("..remark..")"
				-- else
					-- listName = playerIcon..bShine..namecolor..name
				-- end
				-- Friend_List:AddItem(g_FriendBorderColor..listName, i)
			-- end
		-- end
	-- end
	
	-- if g_Current_Clicked ~= -1 then
		-- Friend_List:SetCurrentFirstItem(g_Current_Clicked)
		-- g_Current_Clicked = -1
	-- end
end

--更新最近联系人里的一个玩家信息
function Friend_Update_Recent(nIndex)
	
	local idx = Friend_List:GetItemNumByItemId(nIndex)
	if idx == -1 then
		return
	end

	local guid, sName = DataPool:GetIMRecentByIndex(nIndex)
	local nChannel, nIndex = DataPool:GetFriendByName(sName)
	if nChannel ~= -1 and nIndex ~= -1 then
		local name = DataPool:GetFriend(nChannel, nIndex, "NAME")
		local remark = Friend_GetSpecialRemark(nChannel, nIndex)
		local emotion = DataPool:GetFriend(nChannel, nIndex, "MOOD")
		local friendship = DataPool:GetFriend(nChannel, nIndex, "FRIENDSHIP")
		local relationtype = DataPool:GetFriend(nChannel, nIndex, "RELATION_TYPE")
		local haveMsg = DataPool:GetFriend(nChannel, nIndex, "HAVEMSG")

		local namecolor = "#cC4B299"

		local bShine = ""
		if haveMsg == 1 then
			bShine = "#b"
		end
		
		local moodColor = "#cFFCC7A"
		
		local IMst = 2--DataPool:GetFriend(nChannel, nIndex, "IM_STATUS")
		local Sex = LuaFnFriendGetFriend(nChannel, nIndex, "SEX")
		local playerIcon = g_RemarkBlank

		if DataPool:GetFriend(nChannel, nIndex, "ONLINE") then
			if nChannel == 6 then 								--仇人
				namecolor = "#cFF0000"
			else
				if relationtype == 7 or relationtype == 8 then	-- 7：师傅 8：徒弟
					namecolor = "#cFF6600"
				elseif relationtype == 3 then					-- 3：情侣
					namecolor = "#cF246F0"
				elseif relationtype == 2 then					-- 2：结拜
					namecolor = "#c007EFF"
				elseif friendship >= 10 then
					namecolor = "#c00FF00"
				elseif friendship >= 1 then
					namecolor = "#c00C800"
				elseif friendship == 0 then	
					namecolor = "#cFFFFFF"
				end
			end
			
			if IMst >= 0 and IMst <= 2 and Sex >=0 and Sex <= 1 then
				playerIcon = g_imgStatus[Sex][IMst]
			end
					
			local listName = ""
			if remark ~= nil and remark ~= "" then
				listName = playerIcon..bShine..namecolor..name.."#r"..g_RemarkBlank..namecolor.."("..remark..")"
			else
				listName = playerIcon..bShine..namecolor..name
			end
					
			local listmood = g_RemarkBlank..moodColor..emotion
					
			Friend_List:SetListItemText(idx, g_FriendBorderColor..listName.."#r"..listmood)

		else
			if nChannel == 6 then
				namecolor="#cc7b299"
			end
			
			local listName = ""					
			if remark ~= nil and remark ~= "" then
				listName = playerIcon..bShine..namecolor..name.."#r"..g_RemarkBlank..namecolor.."("..remark..")"
			else
				listName = playerIcon..bShine..namecolor..name
			end
			Friend_List:SetListItemText(idx, g_FriendBorderColor..listName, i)
		end
	end

end
function Friend_OpenTitleList()
	-- Clear_XSCRIPT()
	-- 	Set_XSCRIPT_Function_Name( "OpenAgname" );
	-- 	Set_XSCRIPT_ScriptID(992004);
	-- 	Set_XSCRIPT_Parameter(0,0);
	-- 	Set_XSCRIPT_ParamCount(1);
	-- Send_XSCRIPT()
end

--点击搜索按钮
function Friend_Search_Friends()
	local strText = Friend_SearchEdit:GetText()
	if strText == nil or tostring(strText)== "" then
		return
	end
	DataPool:SearchFriends(tostring(strText))
end
--编辑心情
function Friend_EditMood()
	DataPool:EditMood()
end
--设置
function Friend_IMSet_Clicked()
	PushEvent("UI_COMMAND",2022070511)
end
--搜索
function Friend_Search()
	-- if DataPool:Lua_IsInTServer() == 1 then
		-- PushDebugMessage("#{HSLJ_190919_268}")
		-- return
	-- end	
	local nNumber = Player:GetData("LEVEL")
	if(nNumber~=nil and nNumber>=10) then
		FriendSearcher:OpenFriendSearch()
	else
		PushDebugMessage("#{KDHYYH_211025_48}")
	end
end
--历史消息
function Friend_ViewHistory()
	-- PushEvent("OPEN_IM_CHAT_HISTORY", 0, 0)
end
--消息球历史
function Friend_NewMsgBallHistory_Clicked()
	-- ToggleMsgHistory()
end
--邮件消息
function Friend_SystemInfo()
	DataPool:OpenSystemHistroy()
end

--信任伙伴
function Friend_TrustFriendBtn_OnClicked()
	-- DataPool:ToggleTrustFriendWindow()
end

function Friend_GetSpecialRemark(nChannel, nIndex)
	local remark = DataPool:GetFriend(nChannel, nIndex, "REMARK")
	return remark
end

function Friend_SetGroupingName()
	local strGroupName = ""
	for i = 1, 4 do
		strGroupName = GetGroupingName(i)
		if strGroupName ~= "" then
			g_TeamOutLineStr[i] = strGroupName
		end
	end
end

