--UI COMMAND ID 103
local g_clientNpcId = -1;
local MAX_OBJ_DISTANCE = 3.0;

local g_GuildListCtl = {};
local g_GuildNum = -1;
local CurPage = 0;
local MaxNum = 128;
local g_GuildNumAll = -1;

local g_GuildListIndex = {};

local MAX_CITY_PORT_GROUP = 54;
local city_num_color_1 = "#G";
local city_num_1 = 72;
local city_num_color_2 = "#cffcc00";
local city_num_2 = 36;
local city_num_color_3 = "#cFF0000";

function GetColorBoomValueStr(boom)
    local strPrefix = "";
    if tonumber(boom) <= 200 then
        strPrefix = "#cFF0000";
    elseif tonumber(boom) <= 300 then
    	strPrefix = "#cFF8001";
    elseif tonumber(boom) <= 400 then
        strPrefix = "#cff80ff";
    elseif tonumber(boom) <= 500 then
        strPrefix = "#cFFFF00";
    elseif tonumber(boom) <= 700 then
        strPrefix = "#c00ffff";
    elseif tonumber(boom) <= 999 then
        strPrefix = "#c00FF00";
    end
    
    return strPrefix..boom
end

function ConfraternityList_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	
	this:RegisterEvent("GUILD_SHOW_LIST");
end

function ConfraternityList_OnLoad()
end
function PageUp()
 if CurPage <=0 then
	return
 end
  CurPage = CurPage-1
 if(g_GuildListIndex[CurPage] and g_GuildListIndex[CurPage]>=0) then
	Guild:AskGuildList4Page(g_GuildListIndex[CurPage]);
	Guild_List_Clear();
 end;
end
function PageDown()
 if (CurPage+1)*MaxNum >=g_GuildNumAll then
	return
 end
 CurPage = CurPage+1

	local guildId	 = Guild:GetGuildInfo(g_GuildNum-1, "ID");
	Guild:AskGuildList4Page(guildId+1);
	Guild_List_Clear();

end
function ConfraternityList_OnEvent(event)
	Guild_SetCtl();
	
	if(event == "GUILD_SHOW_LIST") then
		Guild_List_Clear();
		Guild_List_Update();
		this:CareObject(g_clientNpcId, 1, "GuildList");
		this:Show();
	elseif(event == "UI_COMMAND" and tonumber(arg0) == 103) then
		CurPage =0;
		g_GuildListIndex ={};
		g_clientNpcId = Get_XParam_INT(0);
		g_clientNpcId = Target:GetServerId2ClientId(g_clientNpcId);
	elseif ( event == "OBJECT_CARED_EVENT") then
		Guild_List_CareEventHandle(arg0,arg1,arg2);
	end
end

function Guild_SetCtl()
	g_GuildListCtl =	{
											info = ValidCity_Info,
											list = ConfraternityList_List,
											
											name = ConfraternityList_Info1,
											level = ConfraternityList_Info2,
											foundtime = ConfraternityList_Info3,
											leader = ConfraternityList_Info4,
											count = ConfraternityList_Info5,
											city = ConfraternityList_Info6,
											guildleague = ConfraternityList_Info7,
											
											desc = ConfraternityList_Tenet,
										};
end

function Guild_List_Clear()
	g_GuildNum = -1;
	g_GuildNumAll = -1;
	g_GuildListCtl.list:RemoveAllItem();
	ConfraternityList_PageUp:Disable();
	ConfraternityList_PageDown:Disable();
	Guild_List_Detail_Clear();
end

function Guild_List_Detail_Clear()
	g_GuildListCtl.name:SetText("");
	g_GuildListCtl.level:SetText("");
	g_GuildListCtl.foundtime:SetText("");
	g_GuildListCtl.leader:SetText("");
	g_GuildListCtl.count:SetText("");
	g_GuildListCtl.city:SetText("");
	g_GuildListCtl.guildleague:SetText("");
	
	g_GuildListCtl.desc:SetText("");
end

function Guild_Valid_City_Info_Update()
	local i = 0;
	local num = 0;
	while i < MAX_CITY_PORT_GROUP do
		if(City:GetPortInfo(i, "Name") == "") then 
			break; 
		end
		--AxTrace(0,0,"City Port Name:"..City:GetPortInfo(i, "Name"));
		local n = tonumber(City:GetPortInfo(i, "Valid"));
		if n > 0 then
			num = num + n;
		end		
		i = i + 1;
	end
	local color = "";
	if num > city_num_1 then
		color = city_num_color_1;
	elseif num >city_num_2 then
		color = city_num_color_2;
	else
		color = city_num_color_3;
	end
	g_GuildListCtl.info:SetText("��ǰ������������İ��ɳ���������"..color..tostring(num).."#cfff263                 ������108");
end

function Guild_List_Update()
	--��ȡ��Ч���е�����
	Guild_Valid_City_Info_Update();
	--��ð������
	local num = Guild:GetGuildNumCurPage();
	local numAll = Guild:GetGuildNum();
	if(0 == num or nil == num) then
		return;
	end
	if(CurPage>0)then
		ConfraternityList_PageUp:Enable();
	end
	if((CurPage+1)*MaxNum <numAll ) then
		ConfraternityList_PageDown:Enable();
	end
	g_GuildNum = num;
	g_GuildNumAll = numAll;
	--������а�������
	local i = 0;
	while i < g_GuildNum do
		local guildName = Guild:GetGuildInfo(i, "Name");
		local guildId	 = Guild:GetGuildInfo(i, "ID");
		if(i==0)then
			g_GuildListIndex[CurPage] = guildId;
		end
		local szNewGuild = "";
		local szHasCity = "";
		local yes = Guild:IsGuildKeptOneWeed(i);
		if(tonumber(yes) == 0) then
			szNewGuild = "#G���£�#W"
		end
		local szInfo = Guild:GetGuildInfo(i, "CityName");
		if not (nil == szInfo or 0 == string.len(szInfo)) then
			szHasCity = "#c0066FF���ǡ�#W"
		end
		
		--�弶��������ʾΪ��ɫ--add by xindefeng
		local guildLevel = Guild:GetGuildInfo(i, "Level")		
		if(tonumber(guildLevel) >= 5)then
			guildName = "#gFF0FA0"..guildName.."#W"
		end
		
		g_GuildListCtl.list:AddNewItem(tostring(guildId),0,i);
		g_GuildListCtl.list:AddNewItem(szHasCity..szNewGuild..guildName,1,i);
		
		local boomValue = Guild:GetGuildInfo(i, "Boom");
		g_GuildListCtl.list:AddNewItem( GetColorBoomValueStr(boomValue), 2, i);
		g_GuildListCtl.list:AddNewItem( guildLevel, 3, i);
			
		--local weekScore		= Guild:GetGuildInfo(i,"WeekScore");
		--g_GuildListCtl.list:AddNewItem( tostring(weekScore), 4, i);
		i = i + 1;
	end
	
	--Ĭ��ѡ�е�һ�����
	g_GuildListCtl.list:SetSelectItem(0);
	
	--��ʾ��һ��������Ϣ
	Guild_List_Detail_Change(0);
end

function Guild_List_Detail_Change( idx )
	if(nil == idx or idx >= g_GuildNum or idx < 0) then
		return;
	end
	
	Guild_List_Detail_Clear();
	
	local szInfo = Guild:GetGuildInfo(idx, "Name");
	local szId	 = Guild:GetGuildInfo(idx, "ID");
	g_GuildListCtl.name:SetText("����:"..szInfo.."("..tostring(szId)..")");
	
	local leagueName = Guild:GetGuildInfo(idx, "LeagueName");
	g_GuildListCtl.guildleague:SetText("#{TM_20080331_03}"..leagueName);
	
	local szInfo = Guild:GetGuildInfo(idx, "Level");
	g_GuildListCtl.level:SetText("�ȼ�:"..szInfo);
	
	local szInfo = Guild:GetGuildInfo(idx, "FoundTime");
	g_GuildListCtl.foundtime:SetText("����ʱ��:"..szInfo);
	
	local szInfo = Guild:GetGuildInfo(idx, "ChiefName");
	g_GuildListCtl.leader:SetText("����:"..szInfo);
	
	local szInfo = Guild:GetGuildInfo(idx, "Count");
	g_GuildListCtl.count:SetText("����:"..szInfo);
	
	local szInfo = Guild:GetGuildInfo(idx, "CityName");
	if(nil == szInfo or 0 == string.len(szInfo)) then
	g_GuildListCtl.city:SetText("����:".."û�г���");
	else
		g_GuildListCtl.city:SetText("����:"..szInfo);
	end
	
	--local szInfo = Guild:GetGuildInfo(idx, "Name");
	--g_GuildListCtl.locate:SetText(szInfo);
	
	local szInfo = Guild:GetGuildInfo(idx, "Desc");
	g_GuildListCtl.desc:SetText(szInfo);
end

function Guild_List_Selected()
	local selidx = g_GuildListCtl.list:GetSelectItem();
	if( -1 == selidx ) then
		return;
	end
	
	Guild_List_Detail_Clear();
	Guild_List_Detail_Change(selidx);
end

function Guild_List_Join()
	local selidx = g_GuildListCtl.list:GetSelectItem();
	if( -1 == selidx ) then
		return;
	end
	
	if( -1 == Player:GetData("GUILD")) then
		Guild:JoinGuild(selidx);
	else
		local szGuildName = Guild:GetMyGuildInfo("Name");
		PushDebugMessage("���Ѿ���"..szGuildName.."��Ա�ˣ������뿪����ٽ������롣");
		return;
	end
		
	--this:Hide();
end

function Guild_List_CareEventHandle(careId, op, distance)
		if(nil == careId or nil == op or nil == distance) then
			return;
		end
		
		if(tonumber(careId) ~= g_clientNpcId) then
			return;
		end
		--�����NPC�ľ������һ��������߱�ɾ�����Զ��ر�
		if(op == "distance" and tonumber(distance)>MAX_OBJ_DISTANCE or op=="destroy") then
			this:Hide();
		end
end

--"�鿴��ϸ��Ϣ"��ť��Ӧ����--add by xindefeng
function Guild_List_CheckDetail()
	--��ȡ��ǰѡ����Index
	local Index = g_GuildListCtl.list:GetSelectItem()		
	if( -1 == Index ) then
		return
	end
	
	local GuildID = g_GuildListCtl.list:GetItemText(Index, 0)--�õ�ѡ���е�һ������(���ID)
	
	Guild:AskAnyGuildDetailInfo(tonumber(GuildID)) --��ѯָ��ID�����ϸ��Ϣ
	Guild:CloseKickGuildBox()
end

--"��Ա�б�"��ť��Ӧ����--add by xindefeng
function Guild_List_CheckOfficial()
	--��ȡ��ǰѡ����Index
	local Index = g_GuildListCtl.list:GetSelectItem()
	if( -1 == Index ) then
		return
	end
	
	local GuildID = g_GuildListCtl.list:GetItemText(Index, 0)--�õ�ѡ���е�һ������(���ID)
		
	Guild:AskAnyGuildMembersInfo(tonumber(GuildID), tonumber(Index)) --��ѯָ��ID�����ϸ��Ϣ,ConfraternityOfficial.lua��ҪIndex����ѯ
	Guild:CloseKickGuildBox()
end
