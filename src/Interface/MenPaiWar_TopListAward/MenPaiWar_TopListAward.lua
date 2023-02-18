---门派闯关 排行榜奖励展示
       
local g_MenPaiWar_TopListAward_Frame_UnifiedXPosition;
local g_MenPaiWar_TopListAward_Frame_UnifiedYPosition;

local g_MenPaiWar_TopListAward_Award = {}
local g_TargetId = -1
local g_nType = -1
local g_AwardIndex = {0, 1, 2, 3, 5}

function MenPaiWar_TopListAward_PreLoad()
	this:RegisterEvent("UI_COMMAND"); 
	
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	
	this:RegisterEvent("ADJEST_UI_POS");
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED");
end

function MenPaiWar_TopListAward_OnLoad()
	--
	g_MenPaiWar_TopListAward_Frame_UnifiedXPosition	= MenPaiWar_TopListAward_Frame : GetProperty("UnifiedXPosition");
	g_MenPaiWar_TopListAward_Frame_UnifiedYPosition	= MenPaiWar_TopListAward_Frame : GetProperty("UnifiedYPosition");
	
	g_MenPaiWar_TopListAward_Award[1] = MenPaiWar_TopListAward_Icon1
	g_MenPaiWar_TopListAward_Award[2] = MenPaiWar_TopListAward_Icon2
	g_MenPaiWar_TopListAward_Award[3] = MenPaiWar_TopListAward_Icon3
	g_MenPaiWar_TopListAward_Award[4] = MenPaiWar_TopListAward_Icon4
	g_MenPaiWar_TopListAward_Award[5] = MenPaiWar_TopListAward_Icon5

	g_MenPaiWar_TopListAward_Award[6] = MenPaiWar_TopListAward_Icon1_2
	g_MenPaiWar_TopListAward_Award[7] = MenPaiWar_TopListAward_Icon2_2
	g_MenPaiWar_TopListAward_Award[8] = MenPaiWar_TopListAward_Icon3_2
	
end

function MenPaiWar_TopListAward_OnEvent(event)

	if ( event=="UI_COMMAND" and tonumber(arg0) == 120221012) then
		
		MenPaiWar_TopListAward_BeginCareObject( tonumber(arg1) )
		MenPaiWar_TopListAward_Info( )
		this:Show()

	elseif (event=="PLAYER_LEAVE_WORLD") then 
		MenPaiWar_TopListAward_Hide()
		
	elseif (event == "ADJEST_UI_POS" ) then	
		MenPaiWar_TopListAward_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED" ) then
		MenPaiWar_TopListAward_Frame_On_ResetPos()
		
	end
end


function MenPaiWar_TopListAward_Init( )
	
end


function MenPaiWar_TopListAward_Info( )
	MenPaiWar_TopListAward_Init( )
	
	local showAction1 = GemMelting:UpdateProductAction(38002659)
	if showAction1:GetID() ~= 0 then
		g_MenPaiWar_TopListAward_Award[1]:SetActionItem(showAction1:GetID())
	end

	local showAction2 = GemMelting:UpdateProductAction(38002660)
	if showAction2:GetID() ~= 0 then
		g_MenPaiWar_TopListAward_Award[2]:SetActionItem(showAction2:GetID())
	end

	local showAction3 = GemMelting:UpdateProductAction(38002661)
	if showAction3:GetID() ~= 0 then
		g_MenPaiWar_TopListAward_Award[3]:SetActionItem(showAction3:GetID())
	end

	local showAction4 = GemMelting:UpdateProductAction(38002662)
	if showAction4:GetID() ~= 0 then
		g_MenPaiWar_TopListAward_Award[4]:SetActionItem(showAction4:GetID())
	end

	local showAction5 = GemMelting:UpdateProductAction(38002663)
	if showAction5:GetID() ~= 0 then
		g_MenPaiWar_TopListAward_Award[5]:SetActionItem(showAction5:GetID())
	end

	local showAction1_2 = GemMelting:UpdateProductAction(38000283)
	if showAction1_2:GetID() ~= 0 then
		g_MenPaiWar_TopListAward_Award[6]:SetActionItem(showAction1_2:GetID())
	end

	local showAction2_2 = GemMelting:UpdateProductAction(38000284)
	if showAction2_2:GetID() ~= 0 then
		g_MenPaiWar_TopListAward_Award[7]:SetActionItem(showAction2_2:GetID())
	end

	local showAction3_2 = GemMelting:UpdateProductAction(38000285)
	if showAction3_2:GetID() ~= 0 then
		g_MenPaiWar_TopListAward_Award[8]:SetActionItem(showAction3_2:GetID())
	end
end


function MenPaiWar_TopListAward_Frame_On_ResetPos()

	MenPaiWar_TopListAward_Frame : SetProperty("UnifiedXPosition", g_MenPaiWar_TopListAward_Frame_UnifiedXPosition);
	MenPaiWar_TopListAward_Frame : SetProperty("UnifiedYPosition", g_MenPaiWar_TopListAward_Frame_UnifiedYPosition);

end


function MenPaiWar_TopListAward_Hide()
	this:Hide()	
end


--=========================================================
--开始关心NPC
--=========================================================
function MenPaiWar_TopListAward_BeginCareObject(objCaredId)
	
	g_TargetId = objCaredId
	if g_TargetId <= -1 then
		MenPaiWar_TopList_Close()
		return
	end

	local objId = DataPool : GetNPCIDByServerID(g_TargetId)
	if objId <= -1 then
		return
	end
		
	this : CareObject( objId, 1, "MenPaiWar_TopListAward" )
end

