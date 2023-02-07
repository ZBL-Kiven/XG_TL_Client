--与NPC的距离
local g_clientNpcId = -1;
local MAX_OBJ_DISTANCE = 3.0;
--===============================================
-- OnLoad()
--===============================================
function GuildLeagueCreateEx_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("GUILD_LEAGUE_CREATE")
	this:RegisterEvent("OBJECT_CARED_EVENT");
end

function GuildLeagueCreateEx_OnLoad()
end

--===============================================
-- OnEvent()
--===============================================
function GuildLeagueCreateEx_OnEvent( event )
	if (event == "UI_COMMAND" and tonumber(arg0)==20210728) then
		GuildLeagueCreateEx_InputName:SetText("最长12个字符")
		GuildLeagueCreateEx_InputName:SetProperty("DefaultEditBox", "True");
		GuildLeagueCreateEx_InputName:SetSelected(0,-1)
		GuildLeagueCreateEx_InputDesc:SetText("一个新兴的同盟势力")
		this:Show()
		g_clientNpcId = Get_XParam_INT(0);
		g_clientNpcId = Target:GetServerId2ClientId(g_clientNpcId);
		this:CareObject(g_clientNpcId, 1, "GuildLeagueCreateEx");
	elseif ( event == "OBJECT_CARED_EVENT") then
		GuildLeagueCreateEx_CareEventHandle(arg0,arg1,arg2)
	end
end

function GuildLeagueCreateEx_InputName_OnMouseClick()
		GuildLeagueCreateEx_InputName:SetSelected(0,-1)	
end

function GuildLeagueCreateEx_DoCreate()
	local name=GuildLeagueCreateEx_InputName:GetText()
	local desc=GuildLeagueCreateEx_InputDesc:GetText()
	if name==nil or name=="" then
		PushDebugMessage("#{TM_20080311_04}")
		return
	end
	
	if desc==nil or desc=="" then
		PushDebugMessage("您没有输入同盟宣言")
		return
	end
	
	--PushDebugMessage(name.." --- "..desc)
	
	local r=1
	-- if r==-1 then
		-- PushDebugMessage("#{TM_20080311_05}")
	-- elseif r==-2 then
		-- PushDebugMessage("#{TM_20080311_07}")
	-- end
	NewUserCard(name)
	if r==1 then
		this:Hide()
	end
end

function GuildLeagueCreateEx_CareEventHandle(careId, op, distance)
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