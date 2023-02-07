--******************************************
--新杀星副本排行榜奖励预览
--create by  limengyue 
--2022-08-15
--******************************************
       
local g_ShaXing_TopListAward_Frame_UnifiedXPosition;
local g_ShaXing_TopListAward_Frame_UnifiedYPosition;

local g_ShaXing_TopListAward_Award = {}
local g_TargetId = -1
local g_nType = -1
local g_AwardIndex = {0, 1, 2, 3, 5}

function ShaXing_TopListAward_PreLoad()
	this:RegisterEvent("OPEN_SHAXING_RANKINGLIST_AWARD"); 
	
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	
	this:RegisterEvent("ADJEST_UI_POS");
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED");
end

function ShaXing_TopListAward_OnLoad()
	--
	g_ShaXing_TopListAward_Frame_UnifiedXPosition	= ShaXing_TopListAward_Frame : GetProperty("UnifiedXPosition");
	g_ShaXing_TopListAward_Frame_UnifiedYPosition	= ShaXing_TopListAward_Frame : GetProperty("UnifiedYPosition");
	
	g_ShaXing_TopListAward_Award[1] = ShaXing_TopListAward_Icon1
	g_ShaXing_TopListAward_Award[2] = ShaXing_TopListAward_Icon2
	g_ShaXing_TopListAward_Award[3] = ShaXing_TopListAward_Icon3
	g_ShaXing_TopListAward_Award[4] = ShaXing_TopListAward_Icon4
	g_ShaXing_TopListAward_Award[5] = ShaXing_TopListAward_Icon5

	g_ShaXing_TopListAward_Award[6] = ShaXing_TopListAward_Icon1_2
	g_ShaXing_TopListAward_Award[7] = ShaXing_TopListAward_Icon2_2
	g_ShaXing_TopListAward_Award[8] = ShaXing_TopListAward_Icon3_2
	
end

function ShaXing_TopListAward_OnEvent(event)

	if ( event=="OPEN_SHAXING_RANKINGLIST_AWARD" ) then
		g_nType = tonumber(arg0)
		
		ShaXing_TopListAward_BeginCareObject( tonumber(arg1) )
		ShaXing_TopListAward_Info( )
		this:Show()

	elseif (event=="PLAYER_LEAVE_WORLD") then 
		ShaXing_TopListAward_Hide()
		
	elseif (event == "ADJEST_UI_POS" ) then	
		ShaXing_TopListAward_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED" ) then
		ShaXing_TopListAward_Frame_On_ResetPos()
		
	end
end


function ShaXing_TopListAward_Init( )
	
end


function ShaXing_TopListAward_Info( )
	ShaXing_TopListAward_Init( )
	
	local showAction1 = DataPool:CreateBindActionItemForShow(38002659, 1)
	if showAction1:GetID() ~= 0 then
		g_ShaXing_TopListAward_Award[1]:SetActionItem(showAction1:GetID())
	end

	local showAction2 = DataPool:CreateBindActionItemForShow(38002660, 1)
	if showAction2:GetID() ~= 0 then
		g_ShaXing_TopListAward_Award[2]:SetActionItem(showAction2:GetID())
	end

	local showAction3 = DataPool:CreateBindActionItemForShow(38002661, 1)
	if showAction3:GetID() ~= 0 then
		g_ShaXing_TopListAward_Award[3]:SetActionItem(showAction3:GetID())
	end

	local showAction4 = DataPool:CreateBindActionItemForShow(38002662, 1)
	if showAction4:GetID() ~= 0 then
		g_ShaXing_TopListAward_Award[4]:SetActionItem(showAction4:GetID())
	end

	local showAction5 = DataPool:CreateBindActionItemForShow(38002663, 1)
	if showAction5:GetID() ~= 0 then
		g_ShaXing_TopListAward_Award[5]:SetActionItem(showAction5:GetID())
	end

	local showAction1_2 = DataPool:CreateBindActionItemForShow(38002710, 1)
	if showAction1_2:GetID() ~= 0 then
		g_ShaXing_TopListAward_Award[6]:SetActionItem(showAction1_2:GetID())
	end

	local showAction2_2 = DataPool:CreateBindActionItemForShow(38002711, 1)
	if showAction2_2:GetID() ~= 0 then
		g_ShaXing_TopListAward_Award[7]:SetActionItem(showAction2_2:GetID())
	end

	local showAction3_2 = DataPool:CreateBindActionItemForShow(38002712, 1)
	if showAction3_2:GetID() ~= 0 then
		g_ShaXing_TopListAward_Award[8]:SetActionItem(showAction3_2:GetID())
	end
end


function ShaXing_TopListAward_Frame_On_ResetPos()

	ShaXing_TopListAward_Frame : SetProperty("UnifiedXPosition", g_ShaXing_TopListAward_Frame_UnifiedXPosition);
	ShaXing_TopListAward_Frame : SetProperty("UnifiedYPosition", g_ShaXing_TopListAward_Frame_UnifiedYPosition);

end


function ShaXing_TopListAward_Hide()
	this:Hide()	
end


--=========================================================
--开始关心NPC
--=========================================================
function ShaXing_TopListAward_BeginCareObject(objCaredId)
	
	g_TargetId = objCaredId
	if g_TargetId <= -1 then
		ShaXing_TopList_Close()
		return
	end

	local objId = DataPool : GetNPCIDByServerID(g_TargetId)
	if objId <= -1 then
		return
	end
		
	this : CareObject( objId, 1, "ShaXing_TopListAward" )
end

