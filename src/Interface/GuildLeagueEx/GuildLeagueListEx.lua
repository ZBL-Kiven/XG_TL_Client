--与NPC的距离
local g_clientNpcId = -1;
local MAX_OBJ_DISTANCE = 3.0;

--分页信息
local g_CurPage=0
local g_PageNum=0
local g_NumPerPage=13

--===============================================
-- OnLoad()
--===============================================
function GuildLeagueListEx_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("GUILD_LEAGUE_LIST")
	this:RegisterEvent("UPDATE_GUILD_LEAGUE_LIST")
	this:RegisterEvent("OBJECT_CARED_EVENT");
end

function GuildLeagueListEx_OnLoad()
end

--===============================================
-- OnEvent()
--===============================================
function GuildLeagueListEx_OnEvent( event )
	if (event == "UI_COMMAND" and tonumber(arg0)==20210727) then
		this:Show()
		GuildLeagueListEx_DoReset()
		-- GuildLeague:RequestList()
		g_clientNpcId = Get_XParam_INT(0)
		g_clientNpcId = Target:GetServerId2ClientId(g_clientNpcId)
		this:CareObject(g_clientNpcId, 1, "GuildLeagueListEx")
		GuildLeagueListEx_DoUpdatePageNum()
		GuildLeagueListEx_DoFirstPage()
	elseif event == "UPDATE_GUILD_LEAGUE_LIST" then
		this:Show()
		GuildLeagueListEx_DoUpdatePageNum()
		GuildLeagueListEx_DoFirstPage()
	elseif ( event == "OBJECT_CARED_EVENT") then
		GuildLeagueListEx_CareEventHandle(arg0,arg1,arg2)
	end

end

function GuildLeagueListEx_DoUpdatePageNum()	
	local ct=GuildLeague:GetLeagueCount()
	local pageNum=math.floor(ct/g_NumPerPage)
	if math.mod(ct,g_NumPerPage) > 0 then
		pageNum=pageNum+1
	end
	g_PageNum=pageNum
end

function GuildLeagueListEx_DoUpdatePageButton()	
	if g_CurPage==0 then
		GuildLeagueListEx_PageUp:Disable()
	else
		GuildLeagueListEx_PageUp:Enable()
	end
	
	--PushDebugMessage("g_CurPage:"..tostring(g_CurPage)..",g_PageNum:"..tostring(g_PageNum))
	
	if g_CurPage<g_PageNum-1 then
		GuildLeagueListEx_PageDown:Enable()
	else
		GuildLeagueListEx_PageDown:Disable()
	end
end

function GuildLeagueListEx_DoFirstPage()	
	g_CurPage=0
	GuildLeagueListEx_DoUpdatePageButton()	
	GuildLeagueListEx_DoUpdate()
end

function GuildLeagueListEx_DoPageUp()	
	if g_CurPage>0 then
		g_CurPage=g_CurPage-1
		GuildLeagueListEx_DoUpdatePageButton()		
		GuildLeagueListEx_DoUpdate()	
	end
end

function GuildLeagueListEx_DoPageDown()
	if g_CurPage<g_PageNum-1 then
		g_CurPage=g_CurPage+1
		GuildLeagueListEx_DoUpdatePageButton()		
		GuildLeagueListEx_DoUpdate()	
	end
end

function GuildLeagueListEx_DoUpdate()
	GuildLeagueListEx_List:RemoveAllItem()
	
	local info=""
	local ct=GuildLeague:GetLeagueCount();	
	local startIndex=g_CurPage*g_NumPerPage
	local endIndex=startIndex+g_NumPerPage-1
	if endIndex>=ct then
	endIndex=ct-1
	end
	
	for i=startIndex,endIndex do
		GuildLeagueListEx_List:AddNewItem(tostring(GuildLeague:GetLeagueID(i)),0,i-startIndex)
		GuildLeagueListEx_List:AddNewItem(GuildLeague:GetLeagueName(i),1,i-startIndex)
	end
end

function GuildLeagueListEx_DoReset()
	g_CurPage=0
	GuildLeagueListEx_List:RemoveAllItem()

	GuildLeagueListEx_Name:SetText("#{TM_20080318_25}")
	GuildLeagueListEx_Time:SetText("#{TM_20080318_28}")
	GuildLeagueListEx_Chieftain:SetText("#{TM_20080318_27}")
	GuildLeagueListEx_Member:SetText("#{TM_20080318_26}")
	GuildLeagueListEx_Tenet:SetText("")
end

function GuildLeagueListEx_DoSelected()
	local index=GuildLeagueListEx_List:GetSelectItem()
	if index==-1 then
		return
	end
	
	index=index+g_CurPage*g_NumPerPage
	
	GuildLeagueListEx_Name:SetText("#{TM_20080318_25}"..GuildLeague:GetLeagueName(index))
	GuildLeagueListEx_Time:SetText("#{TM_20080318_28}"..GuildLeague:GetLeagueCreateTime(index))
	GuildLeagueListEx_Chieftain:SetText("#{TM_20080318_27}"..GuildLeague:GetLeagueChieftain(index))
	GuildLeagueListEx_Member:SetText("#{TM_20080318_26}"..tostring(GuildLeague:GetLeagueMemberCount(index)).."/3")
	GuildLeagueListEx_Tenet:SetText(GuildLeague:GetLeagueDescription(index))
end

function GuildLeagueListEx_DoApply()
	local index=GuildLeagueListEx_List:GetSelectItem()
	if index==-1 then
		PushDebugMessage("请先选择一个帮会同盟！")
		return
	end
	
	index=index+g_CurPage*g_NumPerPage
	
	GuildLeague:AskEnter(GuildLeague:GetLeagueID(index))
	this:Hide()
end

function GuildLeagueListEx_OnHidden()
	
end

function GuildLeagueListEx_CareEventHandle(careId, op, distance)
		if(nil == careId or nil == op or nil == distance) then
			return;
		end
		
		if(tonumber(careId) ~= g_clientNpcId) then
			return;
		end
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(op == "distance" and tonumber(distance)>MAX_OBJ_DISTANCE or op=="destroy") then
			this:Hide();
		end
end