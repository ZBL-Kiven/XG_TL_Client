--华山论剑 新比武大会

local g_HuaShanLunJian_Join_Frame_UnifiedPosition;
local g_HuaShanLunJian_Join_LevelClient = {}
local g_HuaShanLunJian_Join_TeamFitButton = {}
local g_HuaShanLunJian_Join_LevelFitButton = {}
local g_HuaShanLunJian_Join_MenPaiFitButton = {}
local g_HuaShanLunJian_Join_DisableButton = {}
local g_ServerNpc = -1

local g_YesImage = "set:HSLJ_Match18 image:HSLJ_Dui"
local g_NoImage = "set:HSLJ_Match18 image:HSLJ_X"

function HuaShanLunJian_Join_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
	
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function HuaShanLunJian_Join_OnLoad()
	g_HuaShanLunJian_Join_Frame_UnifiedPosition = HuaShanLunJian_Join_Frame:GetProperty("UnifiedPosition");
	
	g_HuaShanLunJian_Join_LevelClient[1] = HuaShanLunJian_Join_Pic1TextClient
	g_HuaShanLunJian_Join_LevelClient[2] = HuaShanLunJian_Join_Pic2TextClient
	g_HuaShanLunJian_Join_LevelClient[3] = HuaShanLunJian_Join_Pic3TextClient
	
	g_HuaShanLunJian_Join_TeamFitButton[1] = HuaShanLunJian_Join_Pic1Image1
	g_HuaShanLunJian_Join_TeamFitButton[2] = HuaShanLunJian_Join_Pic2Image1
	g_HuaShanLunJian_Join_TeamFitButton[3] = HuaShanLunJian_Join_Pic3Image1
	
	g_HuaShanLunJian_Join_LevelFitButton[1] = HuaShanLunJian_Join_Pic1Image2
	g_HuaShanLunJian_Join_LevelFitButton[2] = HuaShanLunJian_Join_Pic2Image2
	g_HuaShanLunJian_Join_LevelFitButton[3] = HuaShanLunJian_Join_Pic3Image2
	
	g_HuaShanLunJian_Join_MenPaiFitButton[1] = HuaShanLunJian_Join_Pic1Image3
	g_HuaShanLunJian_Join_MenPaiFitButton[2] = HuaShanLunJian_Join_Pic2Image3
	g_HuaShanLunJian_Join_MenPaiFitButton[3] = HuaShanLunJian_Join_Pic3Image3
	
	g_HuaShanLunJian_Join_DisableButton[1] = HuaShanLunJian_Join_Pic1ClientDis
	g_HuaShanLunJian_Join_DisableButton[2] = HuaShanLunJian_Join_Pic2ClientDis
	g_HuaShanLunJian_Join_DisableButton[3] = HuaShanLunJian_Join_Pic3ClientDis
end

-- OnEvent
function HuaShanLunJian_Join_OnEvent(event)
	--
	if ( event == "UI_COMMAND" and tonumber(arg0) == 89289502 ) then 
		HuaShanLunJian_Join_Open()

	elseif ( event == "HIDE_ON_SCENE_TRANSED" ) then
		HuaShanLunJian_Join_Hide()
		
	elseif (event == "ADJEST_UI_POS" ) then
		HuaShanLunJian_Join_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		HuaShanLunJian_Join_ResetPos()
	end
end

function HuaShanLunJian_Join_Init()
	for index=1, table.getn(g_HuaShanLunJian_Join_LevelClient) do
		g_HuaShanLunJian_Join_LevelClient[index]:Hide()
	end
	
	for index=1, table.getn(g_HuaShanLunJian_Join_DisableButton) do
		g_HuaShanLunJian_Join_DisableButton[index]:Show()
	end
end

function HuaShanLunJian_Join_Open()
	HuaShanLunJian_Join_Init()
	HuaShanLunJian_Join_BeginCare( Get_XParam_INT(0) )
	
	local levelIndex = Get_XParam_INT(1)
	local bTeamYes = Get_XParam_INT(2)
	local bLevelYes = Get_XParam_INT(3)
	local bMenPaiYes = Get_XParam_INT(4)
	
	g_HuaShanLunJian_Join_LevelClient[levelIndex + 1]:Show()
	g_HuaShanLunJian_Join_DisableButton[levelIndex + 1]:Hide()
	
	if bTeamYes == 1 then
		g_HuaShanLunJian_Join_TeamFitButton[levelIndex + 1]:SetProperty( "Image", g_YesImage )
	else
		g_HuaShanLunJian_Join_TeamFitButton[levelIndex + 1]:SetProperty( "Image", g_NoImage )
	end
	
	if bLevelYes == 1 then
		g_HuaShanLunJian_Join_LevelFitButton[levelIndex + 1]:SetProperty( "Image", g_YesImage )
	else
		g_HuaShanLunJian_Join_LevelFitButton[levelIndex + 1]:SetProperty( "Image", g_NoImage )
	end
	
	if bMenPaiYes == 1 then
		g_HuaShanLunJian_Join_MenPaiFitButton[levelIndex + 1]:SetProperty( "Image", g_YesImage )
	else
		g_HuaShanLunJian_Join_MenPaiFitButton[levelIndex + 1]:SetProperty( "Image", g_NoImage )
	end
	
	this:Show()
end

function HuaShanLunJian_Join_BeginCare( serverObjId )
	g_ServerNpc = serverObjId
	local objCared = DataPool : GetNPCIDByServerID(serverObjId)
	this:CareObject(objCared, 1)
end

function HuaShanLunJian_Join_Hide()
	this:Hide()
end

function HuaShanLunJian_Join_GoToLobby()
	--
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("EnterLobby")
		Set_XSCRIPT_ScriptID(892895)
		Set_XSCRIPT_Parameter( 0, g_ServerNpc )
		Set_XSCRIPT_ParamCount( 1 )
	Send_XSCRIPT()
end

function HuaShanLunJian_Join_ResetPos()
  HuaShanLunJian_Join_Frame:SetProperty("UnifiedPosition", g_HuaShanLunJian_Join_Frame_UnifiedPosition);
end
