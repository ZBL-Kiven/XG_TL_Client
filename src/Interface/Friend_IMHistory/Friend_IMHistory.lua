--!!!reloadscript =Friend_IMHistory
-- �����Ĭ��λ��
local g_UnifiedXPosition
local g_UnifiedYPosition

local curHistroyPointer = 0
local maxHistroyNumber = 0
local curFriendGroup = 0
local curFriendIndex = 0
local numberPerPage = 10
local maxHistroyPage = 0
local g_IsTeamOutLine = {}
local g_TeamOutLineStr = {}
local g_IsGroupShow = false
local curChatGroupID = 0
local g_curFirstPos = -1   --��¼λ�� ��ֹˢ��list λ�ûع�

local g_FriendBlank = "   "		--3���ո�����
local g_TitleBlank = "     " 	--����5���ո�����
local g_ListTeamColor = "#gFE7E82"
local g_CurSelListItemID = -1
local g_KeepSelState = 0
local g_FromAppIcon = "#-30"

function Friend_IMHistory_PreLoad()	
	this:RegisterEvent("OPEN_IM_CHAT_HISTORY")
	this:RegisterEvent("OPEN_IM_GROUP_HISTORY")
	-- ��Ϸ���ڳߴ緢���˱仯
	this:RegisterEvent("ADJEST_UI_POS")
	-- ��Ϸ�ֱ��ʷ����˱仯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	-- ˢ�½���
	this:RegisterEvent("UPDATE_CHAT_HISTORY")
end

function Friend_IMHistory_OnLoad()
	
	g_UnifiedXPosition = Friend_IMHistory_Frame:GetProperty("UnifiedXPosition")
	g_UnifiedYPosition = Friend_IMHistory_Frame:GetProperty("UnifiedYPosition")
	
	g_IsTeamOutLine = {0,0,0,0,0}
	g_TeamOutLineStr = {
							"#{KDHYYH_211025_37}",
							"#{KDHYYH_211025_38}",
							"#{KDHYYH_211025_39}",
							"#{KDHYYH_211025_40}",
						--	"#{KDHYYH_20211025_11}",		--������
						--	"#{KDHYYH_20211025_12}",		--����
							"#{KDHYYH_20211025_10}",		--��ʱ����
						}
	g_curFirstPos = -1
	
end

function Friend_IMHistory_OnEvent( event )

	if event == "OPEN_IM_CHAT_HISTORY" then
		g_IsTeamOutLine = {0,0,0,0,0}
		local nGroup = tonumber(arg0)
		local nIndex = tonumber(arg1)
		
		if nGroup >=1 and nGroup <= 4 then
			g_IsTeamOutLine[nGroup] = 1
			Friend_IMHistory_ListUpdate()		
			Friend_IMHistory_FriendList:SetItemSelectByItemID(nGroup*10000 + nIndex + 1)
			Friend_IMHistory_Chat_Show(nGroup, nIndex)
		elseif nGroup == 8 then
			g_IsTeamOutLine[5] = 1
			Friend_IMHistory_ListUpdate()			
			Friend_IMHistory_FriendList:SetItemSelectByItemID(nGroup*10000 + nIndex + 1)			
			Friend_IMHistory_Chat_Show(nGroup, nIndex)
		else
			Friend_IMHistory_ListUpdate()
			Friend_IMHistory_Chat_Show(0, 0)
			return
		end
	end

	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		Friend_IMHistory_ResetPos()
	end

end

function Friend_IMHistory_ResetPos()
	Friend_IMHistory_Frame:SetProperty("UnifiedXPosition", g_UnifiedXPosition)
	Friend_IMHistory_Frame:SetProperty("UnifiedYPosition", g_UnifiedYPosition)
end

--��ʾ˽����Ϣ
function Friend_IMHistory_Chat_Show(nChannel, nIndex)
	curFriendGroup = tonumber(nChannel)
	curFriendIndex = tonumber(nIndex)
	maxHistroyNumber = DataPool:GetIMChatNumber(curFriendGroup, curFriendIndex)
	curHistroyPointer = maxHistroyNumber
	Friend_IMHistory_ContentUpdate()
	this:Show()
end

function Friend_IMHistory_ContentUpdate()
	local i = curHistroyPointer - 1
	local minHistroyPointer = curHistroyPointer - numberPerPage;
	if minHistroyPointer < 0 then
		minHistroyPointer = 0
	end

	if minHistroyPointer == 0 then
		Friend_IMHistory_GotoNextPage:Disable()
	else
		Friend_IMHistory_GotoNextPage:Enable()
	end
	
	if curHistroyPointer == maxHistroyNumber then
		Friend_IMHistory_GotofrontPage:Disable()
	else
		Friend_IMHistory_GotofrontPage:Enable()
	end

	Friend_IMHistory_HistoryContent:ClearListBox()

	local str = ""
	while i >= minHistroyPointer do
		str = "#cfff263"
		str = str..DataPool:GetIMChatData(tonumber(curFriendGroup), tonumber(curFriendIndex), tonumber(i), "TIME")
		
		local bFromApp = DataPool:GetIMChatData(tonumber(curFriendGroup), tonumber(curFriendIndex), tonumber(i), "FROMAPP")
		if bFromApp == 1 then
			str = str.." "..g_FromAppIcon..DataPool:GetIMChatData(tonumber(curFriendGroup), tonumber(curFriendIndex), tonumber(i), "SENDER")
		else
			str = str.." "..DataPool:GetIMChatData(tonumber(curFriendGroup), tonumber(curFriendIndex), tonumber(i), "SENDER")
		end
		str = str.."#r#W"
		str = str..DataPool:GetIMChatData(tonumber(curFriendGroup), tonumber(curFriendIndex), tonumber(i), "CONTEX")
		Friend_IMHistory_HistoryContent:AddItem(str, i, "FFFFFFFF", 4)
		i = i - 1
	end
	
	--����ҳ����ʾ
	local curpage = tonumber((maxHistroyNumber - curHistroyPointer) / numberPerPage)
	curpage = math.floor( curpage ) + 1
	if maxHistroyNumber == 0 then
		curpage = 0
	end
	maxHistroyPage = math.ceil(tonumber(maxHistroyNumber / numberPerPage))
	Friend_IMHistory_CurPageNumber:SetText(tostring(curpage .. "/" .. maxHistroyPage))

end

function Friend_IMHistory_ListUpdate()

	Friend_IMHistory_FriendList:ClearListBox()
	--һ��7�� ����ʱ���ѵ�������
	Friend_IMHistory_FriendList:AddItem(g_TitleBlank..g_ListTeamColor.."#{KDHYYH_20211025_6}", 0)
	
	for i = 1, 5 do
		local j = i
		if i == 5 then
			j = 8
		end

		local strOutlineName = ""
		local strTitle = ""
		if i >= 1 and i <= 4 then
			strTitle = DataPool:GetGroupingName(i - 1)
		else
			strTitle = g_TeamOutLineStr[i]
		end

		if g_IsTeamOutLine[i] == 1 then
			strOutlineName = g_ListTeamColor.." - "..strTitle
		else
			strOutlineName = g_ListTeamColor.." + "..strTitle
		end

		if strOutlineName ~= "" or strOutlineName ~= 0 then
			local iStart = j*10000
			local friendnumber = DataPool:GetFriendNumber(j)
			if friendnumber < 1 then
				strOutlineName = g_ListTeamColor.." - "..strTitle
			end
			
			Friend_IMHistory_FriendList:AddItem(strOutlineName, iStart)
			
			if g_IsTeamOutLine[i] == 1 then
				local index = 0
				while index < friendnumber do
					local name = DataPool:GetFriend(j, index, "NAME")
					Friend_IMHistory_FriendList:AddItem(g_FriendBlank..name, iStart + index + 1, "FFFFFFFF", 4)
					index = index + 1
				end
			end
		end
	end

	if g_curFirstPos ~= -1 then
		Friend_IMHistory_FriendList:SetCurrentFirstItem(g_curFirstPos)
		g_curFirstPos = -1
	end
	
	if g_CurSelListItemID >= 0 then
		Friend_IMHistory_FriendList:SetItemSelectByItemID(g_CurSelListItemID)
	else
		g_KeepSelState = 0
	end
end

--��һҳ
function Friend_IMHistory_OnPageDown()
	curHistroyPointer = curHistroyPointer - numberPerPage
	if curHistroyPointer < 0 then
		curHistroyPointer = 0
	end
	Friend_IMHistory_ContentUpdate()
end
--��һҳ
function Friend_IMHistory_OnPageUp()
	curHistroyPointer = curHistroyPointer + numberPerPage
	if curHistroyPointer > maxHistroyNumber then
		curHistroyPointer = maxHistroyNumber
	end
	Friend_IMHistory_ContentUpdate()
end
--ת��
function Friend_IMHistory_GotoPage()
	
	local nPage = tonumber(Friend_IMHistory_GotoPageNumber:GetText())
	if nPage == nil then
		return
	end
	
	if nPage > maxHistroyPage then
		nPage = maxHistroyPage
	elseif nPage <= 0 then
		nPage = 1
	end
	
	Friend_IMHistory_GotoPageNumber:SetText(nPage)
	curHistroyPointer = maxHistroyNumber - (nPage - 1) * numberPerPage
	if curHistroyPointer < 0 then
		curHistroyPointer = 0
	elseif curHistroyPointer > maxHistroyNumber then
		curHistroyPointer = maxHistroyNumber
	end

	Friend_IMHistory_ContentUpdate()
end

--ˢ��
function Friend_IMHistory_Refresh()
	Friend_IMHistory_Chat_Show(curFriendGroup, curFriendIndex)
end

function Friend_IMHistory_OnHidden()
	Friend_IMHistory_FriendList:ClearListBox()
	Friend_IMHistory_HistoryContent:ClearListBox()
	g_CurSelListItemID = -1
	g_KeepSelState = 0
end

--ѡ���б�
function Friend_IMHistory_ListSelectChanged()
	
	local nSelIndex = Friend_IMHistory_FriendList:GetFirstSelectItem()
	local friend_index = math.mod(nSelIndex, 10000)
	local group_index = math.floor(nSelIndex / 10000)	

	if 0 == friend_index then
		
		local title_index = group_index
		if title_index == 8 then
			title_index = 5		
		end

		if g_IsTeamOutLine[title_index] == 0 then
			g_IsTeamOutLine[title_index] = 1
		else
			g_IsTeamOutLine[title_index] = 0
		end
		
		g_curFirstPos = Friend_IMHistory_FriendList:GetCurrentFirstItem()
		g_KeepSelState = 1
		Friend_IMHistory_ListUpdate()		
	else
		g_CurSelListItemID = nSelIndex
		if g_KeepSelState == 0 then
			Friend_IMHistory_Chat_Show(group_index, friend_index - 1)
		else
			g_KeepSelState = 0
		end
	end
end

--˫��
function Friend_IMHistory_ListDoubleClick()
	local nSelIndex = Friend_IMHistory_FriendList:GetFirstSelectItem()

	local friend_index = math.mod(nSelIndex, 10000)
	local group_index = math.floor(nSelIndex / 10000)

	if 0 ~= friend_index then
		DataPool:OpenIMChat(group_index, friend_index - 1)
	end
end

--�Ҽ�
function Friend_IMHistory_OpenMenu()

	local nSelIndex = Friend_IMHistory_FriendList:GetFirstSelectItem()

	local friend_index = math.mod(nSelIndex, 10000)
	local group_index = math.floor(nSelIndex / 10000)

	if friend_index ~= 0 then
		if nSelIndex > -1 then
			Friend:OpenMenu(tostring(group_index), tostring(friend_index - 1))
		end
	end
end





