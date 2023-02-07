--!!!reloadscript =Friend_IMGrouping
local  g_TeamOutLineStr = {}
local  g_Name = ""

function Friend_IMGrouping_PreLoad()
	this:RegisterEvent("OPEN_ADDFRIEND_GROUPING")
end

function Friend_IMGrouping_OnLoad()
	g_TeamOutLineStr = {
							{str = "#{KDHYYH_211025_37}", nIndex = 1},
							{str = "#{KDHYYH_211025_38}", nIndex = 2},
							{str = "#{KDHYYH_211025_39}", nIndex = 3},
							{str = "#{KDHYYH_211025_40}", nIndex = 4},
							{str = "#{KDHYYH_20211025_10}", nIndex = 8},
						}
end

function Friend_IMGrouping_OnEvent(event)	
	if event == "OPEN_ADDFRIEND_GROUPING" then
		g_Name = tostring(arg0)
		Friend_IMGrouping_Show()
	end
end

function Friend_IMGrouping_Show()

	PushEvent("UPDATE_FRIEND")

	--如果不满足条件则不显示
	local iTmp = 1
	local currentList = 0
	local friendnumber = 0
	for iTmp = 1, 4 do
		currentList = iTmp
		local number = DataPool:GetFriendNumber(tonumber(currentList))
		local index = 0
		while index < number do
		 	local name =  DataPool:GetFriend(currentList, tonumber(index), "NAME")
		 	if name == g_Name then
				PushDebugMessage("#{GCRelationHandler_Info_Is_Firend}") --("该玩家已经是您的好友。")
		 		return
		 	end
			index = index + 1
		end
		friendnumber = friendnumber + number
	end
		
	if friendnumber >= 80 then	--好友已达上限
		PushDebugMessage("#{KDHYYH_20211025_1}")
		return
	end
		
	Friend_IMGrouping_Select:ResetList()
	local strGroupName = ""
	for i = 0, 3 do
		strGroupName = DataPool:GetGroupingName(i)
		if strGroupName ~= "" then
			Friend_IMGrouping_Select:AddTextItem(strGroupName, i + 1);
		else
			Friend_IMGrouping_Select:AddTextItem(g_TeamOutLineStr[i+1].str, g_TeamOutLineStr[i+1].nIndex);
		end
	end
		
	Friend_IMGrouping_Select:AddTextItem(g_TeamOutLineStr[5].str  , g_TeamOutLineStr[5].nIndex);
	
	Friend_IMGrouping_Select:SetCurrentSelect(0)
	
	local strMsg =  ScriptGlobal_Format("#{KDHYYH_211025_42}", g_Name)
	Friend_IMGrouping_Text:SetText(strMsg)
	
	this:Show()

end

function Friend_IMGrouping_Hide()
	g_Name = ""
	this:Hide()
end

function Friend_IMGrouping_OK_Clicked()
	local str, nIndex = Friend_IMGrouping_Select:GetCurrentSelect()
	if g_Name ~= "" then
		DataPool:AddFriend(tonumber(nIndex) ,g_Name)
	end
	Friend_IMGrouping_Hide()
end