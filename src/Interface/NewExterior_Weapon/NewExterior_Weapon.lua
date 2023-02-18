--!!!reloadscript =NewExterior_Weapon
--增加一个排序
local g_NewExterior_Weapon_UnifiedPosition = ""

local EXTERIORFILTTING_TOTALKIND = 6;
local g_TargetExteriorIndex = 0		--定位的外观索引，从1开始
local g_TargetExteriorID = 0			--定位的外观ID

local g_CurSelExteriorID = 1			--当前选择的外观ID，从1开始
local g_CurSelWeaponLevel = 1
local g_WeaponMaxEquipID = 10102760 --幻饰武器的最后ID，最后一个0ID
local g_NeedChangeScrollSize = 1
local g_Distance = 1
local g_Distance_Ori = 2
local g_Distance_Max = 4
local g_InitList = 0
local g_ExteriorType = 1 --幻武
local g_MaxBarNum = 0
local g_BarList = {}
local g_ViewMode = 0
local g_Weapon_SuperListItem = {}
local g_WeaponLevelAction = {}
local g_WeaponLevelLock = {}
local g_WeaponLevelTip = {}
local g_WeaponLevelDef = {}
local g_WeaponLevelTime = {}
local g_WeaponIndexTable = {}
local Current_Page = 0
local g_CurSelExteriorHave = 0
local g_EquipPos = -1
local STYLE_BUTTON = 20
local g_DecoWeapon_Display = 0
local ButtonIndex = 1

local g_CameraHeight = 1     --摄影机高度
local g_CameraDistance = 2   --摄影机距离
local g_CameraPitch = 3      --摄影机角度

local g_CameraPosition =
{
	--女性相关位置
	[0] = {{fHeight = 0.82, fDistance = 8, fPitch=0.2}, {fHeight = 0.82, fDistance = 6.5, fPitch=0.2}, {fHeight = 1.55, fDistance = 2.5, fPitch=0.20}, {fHeight = 1.55, fDistance = 1.7, fPitch=0.20}},
	--男性相关位置
	[1] = {{fHeight = 0.82, fDistance = 8, fPitch=0.2}, {fHeight = 0.82, fDistance = 6.5, fPitch=0.2}, {fHeight = 1.65, fDistance = 2.7, fPitch=0.28}, {fHeight = 1.70, fDistance = 1.9, fPitch=0.28}},
}

local g_WeaponHaveInfo = {}
--=========
--PreLoad==
--=========
function NewExterior_Weapon_PreLoad()
	this:RegisterEvent("UNIT_LEVEL",false)	
	this:RegisterEvent("ON_SCENE_TRANS",false)
	this:RegisterEvent("ON_SERVER_TRANS",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	this:RegisterEvent("ADJEST_UI_POS",false)	
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("UI_COMMAND", false)
end

--=========
--OnLoad
--=========
function NewExterior_Weapon_OnLoad()
	for i = 1,25 do
		table.insert(g_Weapon_SuperListItem,{zhuangbei = _G[string.format("NewExterior_Weapon_SuperListItemActionDef%d",i)],DongZuo = _G[string.format("NewExterior_Weapon_SuperListItemActionButton%d",i)],Button = _G[string.format("NewExterior_Weapon_SuperListItemAction%d",i)],Lock = _G[string.format("NewExterior_Weapon_SuperListItemActionLock%d",i)],Mark = _G[string.format("NewExterior_Weapon_SuperListItemActionMark%d",i)]})
	end	
	g_NewExterior_Weapon_UnifiedPosition = NewExterior_Weapon_Frame:GetProperty("UnifiedPosition")
	
	g_WeaponLevelAction[1] = NewExterior_Weapon_Level1
	g_WeaponLevelAction[2] = NewExterior_Weapon_Level2
	g_WeaponLevelAction[3] = NewExterior_Weapon_Level3
	g_WeaponLevelAction[4] = NewExterior_Weapon_Level4
	
	g_WeaponLevelLock[1] = NewExterior_Weapon_Level1_ActionImg
	g_WeaponLevelLock[2] = NewExterior_Weapon_Level2_ActionImg
	g_WeaponLevelLock[3] = NewExterior_Weapon_Level3_ActionImg
	g_WeaponLevelLock[4] = NewExterior_Weapon_Level4_ActionImg
	g_WeaponLevelLock[5] = NewExterior_Weapon_Level5_ActionImg
	
	g_WeaponLevelTip[1] = NewExterior_Weapon_Level1_Tip
	g_WeaponLevelTip[2] = NewExterior_Weapon_Level2_Tip
	g_WeaponLevelTip[3] = NewExterior_Weapon_Level3_Tip
	g_WeaponLevelTip[4] = NewExterior_Weapon_Level4_Tip
	g_WeaponLevelTip[5] = NewExterior_Weapon_Level5_Tip
	
	g_WeaponLevelDef[1] = NewExterior_Weapon_Level1_Def
	g_WeaponLevelDef[2] = NewExterior_Weapon_Level2_Def
	g_WeaponLevelDef[3] = NewExterior_Weapon_Level3_Def
	g_WeaponLevelDef[4] = NewExterior_Weapon_Level4_Def
	g_WeaponLevelDef[5] = NewExterior_Weapon_Level5_Def
	
	g_WeaponLevelTime[1] = NewExterior_Weapon_Level1_Time
	g_WeaponLevelTime[2] = NewExterior_Weapon_Level2_Time
	g_WeaponLevelTime[3] = NewExterior_Weapon_Level3_Time
	g_WeaponLevelTime[4] = NewExterior_Weapon_Level4_Time
	g_WeaponLevelTime[5] = NewExterior_Weapon_Level5_Time
	NewExterior_Weapon_Level4:Hide()
	
end
--=========
--OnEvent
--=========
function NewExterior_Weapon_OnEvent(event)
	if event == "UI_COMMAND" and tonumber(arg0) == 2350111 then
		NewExterior_Weapon_FakeObject:SetFakeObject("")
	end
	if event == "UI_COMMAND" and tonumber(arg0) == 120213569 then
		if GetGameMissionData("MD_EXTERIOR") == 2 then
			NewExterior_Weapon_Show()
		end
	end
	if event == "UI_COMMAND" and tonumber(arg0) == 122032413 then
		if GetGameMissionData("MD_EXTERIOR") == 2 then
			NewExterior_Weapon_Show()
		end
		return
	end			
	if event == "UI_COMMAND" and tonumber(arg0) == 120213567 then
		SetGameMissionData("MD_EXTERIOR",2)
		if(IsWindowShow("NewExterior_PetSoul")) then
			CloseWindow("NewExterior_PetSoul", true)
		end
		if(IsWindowShow("NewExterior_PlayerFrame")) then
			CloseWindow("NewExterior_PlayerFrame", true)
		end
		if(IsWindowShow("NewExterior_Ride")) then
			CloseWindow("NewExterior_Ride", true)
		end
		if(IsWindowShow("NewExterior_Weapon_Levelup")) then
			CloseWindow("NewExterior_Weapon_Levelup", true)
		end
		if(IsWindowShow("NewExterior_Facestyle")) then
			CloseWindow("NewExterior_Facestyle", true)
		end
		if(IsWindowShow("NewExterior_HairStyle")) then
			CloseWindow("NewExterior_HairStyle", true)
		end
		if(IsWindowShow("NewExterior_DressBox")) then
			CloseWindow("NewExterior_DressBox", true)
		end
		if(IsWindowShow("SelfEquip")) then
			CloseWindow("SelfEquip", true)
		end
		Current_Page = 0
		g_WeaponHaveInfo = {}
		local nWeapon = Get_XParam_STR(0)
		for i = 1,string.len(nWeapon) do
			g_WeaponHaveInfo[i] = string.sub(nWeapon,i,i)
		end
		-- g_EquipPos = Get_XParam_INT(0)
		NewExterior_Weapon_SetPosition()
		NewExterior_Weapon_CloseSameGroupWindow()
		this:Show()
		NewExterior_Weapon_Show()
		NewExterior_Weapon_UpdateList()
		return
	end
	if event == "UI_COMMAND" and tonumber(arg0) == 1000000037 then
		NewExterior_Weapon_Weapon_Type:SetCheck(Get_XParam_INT(0))
		return
	end	
	if event == "UI_COMMAND" and tonumber(arg0) == 1022032415 then
		LifeAbility:Wear_Equip_VisualID(Get_XParam_INT(0),Get_XParam_INT(1))
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("RideSysteam")
			Set_XSCRIPT_ScriptID(830243)
			Set_XSCRIPT_Parameter(0,8)
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()		
		return
	end	
	if event == "ON_SCENE_TRANS" or event == "ON_SERVER_TRANS" or event == "HIDE_ON_SCENE_TRANSED" then
		this:Hide()
	end
	-- 游戏窗口尺寸发生了变化 or 游戏分辨率发生了变化
	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		NewExterior_Weapon_Frame:SetProperty("UnifiedPosition", g_NewExterior_Weapon_UnifiedPosition)
	end
end

function NewExterior_Weapon_Show()	
	for i = 1,25 do
		g_Weapon_SuperListItem[i].Button:SetProperty("Empty","False")
		g_Weapon_SuperListItem[i].Button:SetProperty("UseDefaultTooltip","True")
		if i > 7 then
			g_Weapon_SuperListItem[i].Button:Hide()
		end
	end
	--左侧
	NewExterior_Weapon_UpdateLeftBtn()
	-- 模型
	NewExterior_Weapon_UpdateObj()	
	NewExterior_Weapon_UpdateList()	
end
--左侧
function NewExterior_Weapon_UpdateLeftBtn()	
	--时装
	if GetGameMissionData("MD_DRESS") ~= 0 then
		NewExterior_Weapon_Dress_LockImg:Show()
		NewExterior_Weapon_Dress_ActionImg:Show()
		local _,Icons = LifeAbility : GetPrescr_Material(GetGameMissionData("MD_DRESS"))
		local strImage = GetIconFullName(Icons)
		NewExterior_Weapon_Dress_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_Weapon_Dress_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_Weapon_Dress_LeftBtn:SetProperty("PushedImage", strImage)
		NewExterior_Weapon_Dress_LeftBtn:SetProperty("Empty", "False")
	else
		NewExterior_Weapon_Dress_LeftBtn:SetProperty("NormalImage", "")
		NewExterior_Weapon_Dress_LeftBtn:SetProperty("HoverImage", "")
		NewExterior_Weapon_Dress_LeftBtn:SetProperty("PushedImage", "")
		local theAction = EnumAction(2, "equip");
		NewExterior_Weapon_Dress_LeftBtn:SetActionItem(theAction:GetID())
		NewExterior_Weapon_Dress_LockImg:Hide()
		NewExterior_Weapon_Dress_ActionImg:Hide()	
	end	
	--坐骑
	theAction = DataPool:GetPlayerMission_DataRound(362)
	NewExterior_Weapon_Ride_LockImg:Hide()
	NewExterior_Weapon_Ride_ActionImg:Hide()
	if theAction ~= 0 then
		local strIcon = LuaFnGetExteriorRideInfo(theAction,"Icon")
		local strName 	= LuaFnGetExteriorRideInfo(theAction, "Name")
		local strImage = GetIconFullName(strIcon)
		NewExterior_Weapon_Ride_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_Weapon_Ride_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_Weapon_Ride_LeftBtn:SetProperty("Empty", "False")
		NewExterior_Weapon_Ride_LeftBtn:SetProperty("UseDefaultTooltip", "True")
		NewExterior_Weapon_Ride_LeftBtn:SetToolTip(strName)
	else
		NewExterior_Weapon_Ride_LeftBtn:SetProperty("NormalImage", "")
		NewExterior_Weapon_Ride_LeftBtn:SetProperty("HoverImage", "")	
	end
	if GetGameMissionData("MD_RIDA") ~= 0 then
		NewExterior_Weapon_Ride_ActionImg:Show()
		NewExterior_Weapon_Ride_LockImg:Show()
		strIcon 	= LuaFnGetExteriorRideInfo(GetGameMissionData("MD_RIDA"), "Icon")
		strImage = GetIconFullName(strIcon)
		strName 	= LuaFnGetExteriorRideInfo(GetGameMissionData("MD_RIDA"), "Name")
		NewExterior_Weapon_Ride_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_Weapon_Ride_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_Weapon_Ride_LeftBtn:SetProperty("Empty", "False")
		NewExterior_Weapon_Ride_LeftBtn:SetProperty("UseDefaultTooltip", "True")
		NewExterior_Weapon_Ride_LeftBtn:SetToolTip(strName)
	end		
	--幻武
	cacheExteriorID = DataPool:GetPlayerMission_DataRound(389)
	if cacheExteriorID ~= 0 then
		local strName 	= LuaFnGetExteriorWeaponInfo(cacheExteriorID, "Name")
		local strIcon 	= LuaFnGetExteriorWeaponInfo(cacheExteriorID, "Icon")
		local strImage = GetIconFullName(strIcon)
		NewExterior_Weapon_Weapon_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_Weapon_Weapon_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_Weapon_Weapon_LeftBtn:SetProperty("Empty", "False")
		NewExterior_Weapon_Weapon_LeftBtn:SetProperty("UseDefaultTooltip", "True")
		local strTemp = strName
		NewExterior_Weapon_Weapon_LeftBtn:SetToolTip(strTemp)
	else
		NewExterior_Weapon_Weapon_LeftBtn:SetProperty("HoverImage", "")
		NewExterior_Weapon_Weapon_LeftBtn:SetProperty("NormalImage", "")
	end
	NewExterior_Weapon_Weapon_ActionImg:Hide()
	NewExterior_Weapon_Weapon_LockImg:Hide()
	if GetGameMissionData("MD_WEAPON") > 0 then
		NewExterior_Weapon_Weapon_ActionImg:Show()
		NewExterior_Weapon_Weapon_LockImg:Show()
		strIcon 	= LuaFnGetExteriorWeaponInfo(GetGameMissionData("MD_WEAPON"), "Icon")
		strName 	= LuaFnGetExteriorWeaponInfo(GetGameMissionData("MD_WEAPON"), "Name")
		strImage = GetIconFullName(strIcon)
		NewExterior_Weapon_Weapon_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_Weapon_Weapon_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_Weapon_Weapon_LeftBtn:SetToolTip(strName)
	end		
	-- 附体
	cacheExteriorID = DataPool:GetPlayerMission_DataRound(387)
	if cacheExteriorID > 0 then
		local strName,iQual,iBloodRank,curPetSoulid,strIcon = NewExterior_PetSoul_DataShow(cacheExteriorID)
		strImage = GetIconFullName(strIcon)
		NewExterior_Weapon_PetSoul_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_Weapon_PetSoul_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_Weapon_PetSoul_LeftBtn:SetToolTip(strName)
		NewExterior_Weapon_PetSoul_LeftBtn:SetProperty("Empty", "False")
		NewExterior_Weapon_PetSoul_LeftBtn:SetProperty("UseDefaultTooltip", "True")
	end
	NewExterior_Weapon_PetSoul_LockImg:Hide()
	NewExterior_Weapon_PetSoul_ActionImg:Hide()
	local TryPoss = GetGameMissionData("MD_PETPOSS")
	if TryPoss ~= 0 then
		TryPoss = math.mod(TryPoss,100)
		local strName,strIcon,iQual = LuaFnGetExteriorPossInfo(TryPoss)
		strImage = GetIconFullName(strIcon)
		NewExterior_Weapon_PetSoul_LockImg:Show()
		NewExterior_Weapon_PetSoul_ActionImg:Show()
		NewExterior_Weapon_PetSoul_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_Weapon_PetSoul_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_Weapon_PetSoul_LeftBtn:SetToolTip(strName)
		NewExterior_Weapon_PetSoul_LeftBtn:SetProperty("Empty", "False")
		NewExterior_Weapon_PetSoul_LeftBtn:SetProperty("UseDefaultTooltip", "True")
	end
	--脸型
	cacheExteriorID = DataPool:Get_MyFaceStyle()
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local _,_,_,IconFile,_,StyleName = DataPool : Change_MyFaceStyle_Item(cacheExteriorID);
		local strImage = GetIconFullName(IconFile)			
		NewExterior_Weapon_FaceStyle_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_Weapon_FaceStyle_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_Weapon_FaceStyle_LeftBtn:SetProperty("Empty", "False")
		NewExterior_Weapon_FaceStyle_LeftBtn:SetProperty("UseDefaultTooltip", "True")
		NewExterior_Weapon_FaceStyle_ActionImg:Hide()
		NewExterior_Weapon_FaceStyle_LockImg:Hide()
		local strTemp = StyleName
		NewExterior_Weapon_FaceStyle_LeftBtn:SetToolTip(strTemp)
	end
	if GetGameMissionData("MD_FACE") ~= 0 then
		NewExterior_Weapon_FaceStyle_ActionImg:Show()
		NewExterior_Weapon_FaceStyle_LockImg:Show()
		strIcon 	= LuaFnGetExteriorFaceInfo(GetGameMissionData("MD_FACE"), "Icon")
		strName 	= LuaFnGetExteriorFaceInfo(GetGameMissionData("MD_FACE"), "Name")
		strImage = GetIconFullName(strIcon)
		NewExterior_Weapon_FaceStyle_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_Weapon_FaceStyle_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_Weapon_FaceStyle_LeftBtn:SetProperty("Empty", "False")
		NewExterior_Weapon_FaceStyle_LeftBtn:SetProperty("UseDefaultTooltip", "True")
		NewExterior_Weapon_FaceStyle_LeftBtn:SetToolTip(strName)
	end	
	--发型
	cacheExteriorID = DataPool : Get_MyHairStyle()
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local strName 	= LuaFnGetExteriorHairInfo(cacheExteriorID, "Name")
		local strIcon 	= LuaFnGetExteriorHairInfo(cacheExteriorID, "Icon")
		local strImage = GetIconFullName(strIcon)		
		NewExterior_Weapon_HairStyle_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_Weapon_HairStyle_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_Weapon_HairStyle_LeftBtn:SetProperty("Empty", "False")
		NewExterior_Weapon_HairStyle_LeftBtn:SetProperty("UseDefaultTooltip", "True")
		NewExterior_Weapon_HairStyle_LockImg:Hide()
		NewExterior_Weapon_HairStyle_ActionImg:Hide()
		local strTemp = strName
		NewExterior_Weapon_HairStyle_LeftBtn:SetToolTip(strTemp)
	end
	if GetGameMissionData("MD_HAIR") ~= 0 then
		NewExterior_Weapon_HairStyle_LockImg:Show()
		NewExterior_Weapon_HairStyle_ActionImg:Show()
		strIcon 	= LuaFnGetExteriorHairInfo(GetGameMissionData("MD_HAIR"), "Icon")
		strName 	= LuaFnGetExteriorHairInfo(GetGameMissionData("MD_HAIR"), "Name")
		strImage = GetIconFullName(strIcon)
		NewExterior_Weapon_HairStyle_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_Weapon_HairStyle_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_Weapon_HairStyle_LeftBtn:SetProperty("Empty", "False")
		NewExterior_Weapon_HairStyle_LeftBtn:SetProperty("UseDefaultTooltip", "True")
		NewExterior_Weapon_HairStyle_LeftBtn:SetToolTip(strName)
	end	
	--头像
	local strHeadTip = ""
	cacheExteriorID = DataPool : Get_MyHeadStyle()
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local strName 	= LuaFnGetExteriorPortraitInfo(cacheExteriorID, "Name")
		local strIcon 	= LuaFnGetExteriorPortraitInfo(cacheExteriorID, "Icon")
		local strImage = GetIconFullName(strIcon)		
		NewExterior_Weapon_PlayerFrame_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_Weapon_PlayerFrame_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_Weapon_PlayerFrame_LeftBtn:SetProperty("Empty", "False")
		NewExterior_Weapon_PlayerFrame_LeftBtn:SetProperty("UseDefaultTooltip", "True")
		NewExterior_Weapon_PlayerFrame_LockImg:Hide()
		NewExterior_Weapon_PlayerFrame_ActionImg:Hide()
		local strTemp = strName
		NewExterior_Weapon_PlayerFrame_LeftBtn:SetToolTip(strTemp)	
	end	
	if GetGameMissionData("MD_HEAD") ~= 0 then
		NewExterior_Weapon_PlayerFrame_LockImg:Show()
		NewExterior_Weapon_PlayerFrame_ActionImg:Show()
		strIcon 	= LuaFnGetExteriorPortraitInfo(GetGameMissionData("MD_HEAD"), "Icon")
		strName 	= LuaFnGetExteriorPortraitInfo(GetGameMissionData("MD_HEAD"), "Name")
		strImage = GetIconFullName(strIcon)
		NewExterior_Weapon_PlayerFrame_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_Weapon_PlayerFrame_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_Weapon_PlayerFrame_LeftBtn:SetProperty("Empty", "False")
		NewExterior_Weapon_PlayerFrame_LeftBtn:SetProperty("UseDefaultTooltip", "True")
		NewExterior_Weapon_PlayerFrame_LeftBtn:SetToolTip(strName)
	end	
	--头像框
	-- local headlace = DataPool:GetPlayerMission_DataRound(288)
	-- if headlace > 0 then
		-- local nFrameImg = Lua_GetHeadFrameData(headlace)
		-- nFrameImg = GetIconFullName(nFrameImg)
		-- NewExterior_Weapon_PlayerFrame_Mask:SetProperty("Image",nFrameImg)
	-- else
		-- NewExterior_Weapon_PlayerFrame_Mask:SetProperty("Image","set:CharHeadFrame1 image:CharHeadFrame1_DefaultPlayer")
	-- end
end
function NewExterior_Weapon_Page(Index)
	Current_Page = Current_Page + Index
	if Current_Page == 0 then
		NewExterior_Weapon_SuperListItemLast : Disable();
	else
		NewExterior_Weapon_SuperListItemLast : Enable();
	end
	
	if Current_Page == 4 then
		NewExterior_Weapon_SuperListItemNext : Enable();
	else
		NewExterior_Weapon_SuperListItemNext : Disable();
	end	
	NewExterior_Weapon_CurrentlyPage:SetText(Current_Page+1 .."/4")
	NewExterior_Weapon_UpdateList()	
end

function NewExterior_Weapon_ZoomIn()
	NewExterior_Weapon_FakeObject : SetFakeObject( "Player_Head" );
end

function NewExterior_Weapon_ZoomOut()
	NewExterior_Weapon_FakeObject : SetFakeObject( "EquipChange_Player" );
end

function NewExterior_Weapon_FashionDisplay()
	--时装显示控制
	local IsDisplay = SystemSetup:Get_Display_Dress();
	NewExterior_Weapon_Dress_Type : SetCheck(1)--IsDisplay
	if IsDisplay == 1 then
		IsDisplay = 0
	else
		IsDisplay = 1
	end
	SystemSetup:Set_Display_Dress(1);
end

function NewExterior_Weapon_ExteriorWeaponDisplay()
	if g_DecoWeapon_Display == 1 then
		g_DecoWeapon_Display = 0
	else
		g_DecoWeapon_Display = 1
	end
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("RideSysteam")
		Set_XSCRIPT_ScriptID(830243)
		Set_XSCRIPT_Parameter(0,10)
		Set_XSCRIPT_Parameter(1,g_DecoWeapon_Display)
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()
end
--列表
function NewExterior_Weapon_UpdateList()
	for i = 1,25 do
		g_Weapon_SuperListItem[i].Button:Hide()
	end
	--当前装备的幻饰ID 
	local weaponID = DataPool:GetPlayerMission_DataRound(389)
	for i = 1,7 do
			local strIcon 	= LuaFnGetExteriorWeaponInfo(i, "Icon")
			local strTemp = LuaFnGetExteriorWeaponInfo(i, "ToolTips")
			local strName 	= LuaFnGetExteriorWeaponInfo(i, "Name")
			local strImage = GetIconFullName(strIcon)
			g_Weapon_SuperListItem[i].DongZuo:Hide()
			if strIcon ~= "" and strIcon ~= nil then	
				if tonumber(g_WeaponHaveInfo[i]) ~= 0 then
					g_Weapon_SuperListItem[i].Lock:Hide()
				else
					g_Weapon_SuperListItem[i].Lock:Show()
				end
				if weaponID == i then
					g_Weapon_SuperListItem[i].zhuangbei:Show()
				else
					g_Weapon_SuperListItem[i].zhuangbei:Hide()
				end
				g_Weapon_SuperListItem[i].Button:SetProperty("NormalImage", strImage)
				g_Weapon_SuperListItem[i].Button:SetProperty("HoverImage", strImage)
				g_Weapon_SuperListItem[i].Button:SetToolTip(strName.."#r"..strTemp)
				g_Weapon_SuperListItem[i].Button:Show()
				g_Weapon_SuperListItem[i].Mark:Hide()
			end
	end
	g_CurSelExteriorID = g_WeaponHaveInfo[1 + ( Current_Page*25 )][1]
	g_CurSelExteriorHave = g_WeaponHaveInfo[1 + ( Current_Page*25 )][2]
end
--模型
function NewExterior_Weapon_UpdateObj()
	NewExterior_Weapon_FakeObject : SetFakeObject( "" );
	NewExterior_Weapon_FakeObject : SetFakeObject( "EquipChange_Player" );	
	FakeObj_SetCamera( "EquipChange_Player", 1,1);
	FakeObj_SetCamera( "EquipChange_Player", 2,8);
	FakeObj_SetCamera( "EquipChange_Player", 3,0.28);		
end
function NewExterior_Weapon_TakeOffWeapon()
    Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("RideSysteam");
		Set_XSCRIPT_ScriptID(830243);
		Set_XSCRIPT_Parameter(0,12);
		Set_XSCRIPT_ParamCount(1);
    Send_XSCRIPT();	
	NewExterior_Weapon_Weapon_LeftBtn:SetProperty("PushedImage", "")
	NewExterior_Weapon_Weapon_LeftBtn:SetProperty("NormalImage", "")
	NewExterior_Weapon_Weapon_LeftBtn:SetProperty("HoverImage", "")
	NewExterior_Weapon_Weapon_LeftBtn:SetToolTip("")
end
--等级部分
function NewExterior_Weapon_ShowLevelBtn(nIndex)
	--承接上次外观等级预览
	local DefWeapon = LuaFnGetExteriorWeaponInfo(nIndex,"WG",g_CurSelWeaponLevel)
	
	--这里试穿信息
	local strIcon 	= LuaFnGetExteriorWeaponInfo(g_CurSelExteriorID, "Icon")
	local strImage = GetIconFullName(strIcon)
	NewExterior_Weapon_Weapon_LeftBtn:SetProperty("NormalImage", strImage)
	NewExterior_Weapon_Weapon_LeftBtn:SetProperty("HoverImage", strImage)
	NewExterior_Weapon_Weapon_LeftBtn:SetProperty("Empty", "False")
	NewExterior_Weapon_Weapon_LockImg:Show()
	NewExterior_Weapon_Weapon_ActionImg:Show()
	SetGameMissionData("MD_WEAPON",g_CurSelExteriorID)
	SetGameMissionData("MD_WEAPONYULAN",DefWeapon)
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("RideSysteam")
		Set_XSCRIPT_ScriptID(830243)
		Set_XSCRIPT_Parameter(0,11);
		Set_XSCRIPT_Parameter(1,DefWeapon);
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()	
end

function NewExterior_Weapon_MakeHyperlink(nGroupID)
	local tempWeaponLevel = 1
	for i = 1, 5 do
		local nID = LuaFnGetWeaponIDFromGroup(nGroupID, i - 1)
		if LuaFnIsHaveExterior(g_ExteriorType, nID) == 1 then
			tempWeaponLevel = i
		end
	end
	local nExteriorWeaponID = LuaFnGetWeaponIDFromGroup(nGroupID, tempWeaponLevel - 1)

	local ret = LuaFnExteriorWeaponItemClick(nExteriorWeaponID)
	if ret == 2 then
		PushDebugMessage("#{WGTJ_201222_132}")
	end
	return ret
end

function NewExterior_Weapon_ItemClicked(nIndex)
	for i = 1,25 do
		if i == nIndex then
			g_Weapon_SuperListItem[i].Button:SetPushed(1)
			g_Weapon_SuperListItem[i].DongZuo:Show()
		else
			g_Weapon_SuperListItem[i].Button:SetPushed(0)
			g_Weapon_SuperListItem[i].DongZuo:Hide()		
		end
	end
	g_CurSelExteriorID = nIndex
	g_CurSelExteriorHave = g_WeaponHaveInfo[nIndex]
	ButtonIndex = nIndex
	NewExterior_Weapon_ShowLevelBtn(nIndex)
end

function NewExterior_Weapon_MakeHyperlink2(nLevel)
	local nExteriorWeaponID = LuaFnGetWeaponIDFromGroup(g_CurSelExteriorID, nLevel - 1)
	if nExteriorWeaponID <= 0 then
		return
	end
	local ret = LuaFnExteriorWeaponItemClick(nExteriorWeaponID)
	if ret == 2 then
		PushDebugMessage("#{WGTJ_201222_132}")
	end
	return ret
end
function NewExterior_Weapon_RankClicked(nLevel)
	-- local nExteriorWeaponID = LuaFnGetWeaponIDFromGroup(g_CurSelExteriorID, nLevel - 1)
	-- if nExteriorWeaponID <= 0 then
		-- return
	-- end
	local EquipWG = LuaFnGetExteriorWeaponInfo(g_CurSelExteriorID,"WG",nLevel)
	g_CurSelWeaponLevel = nLevel
	NewExterior_Weapon_SetWeaponLevelSelected(nLevel)
	-- if g_EquipPos ~= -1 then
		-- LifeAbility:Wear_Equip_VisualID(g_EquipPos,EquipWG)
	-- end
	--请求试穿信息
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("RideSysteam")
		Set_XSCRIPT_ScriptID(830243)
		Set_XSCRIPT_Parameter(0,11);
		Set_XSCRIPT_Parameter(1,EquipWG);
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()	
end

function NewExterior_Weapon_SetWeaponLevelSelected(nIndex)
	for i = 1, 4 do		
		if i == nIndex then
			g_WeaponLevelAction[i]:SetCheck(1)
		else
			g_WeaponLevelAction[i]:SetCheck(0)	
		end
	end
end

function NewExterior_Weapon_TryExterior()
	--预览信息
	SaveAllChange()
	NewExterior_Weapon_RemovePreview()
end

function NewExterior_Weapon_TakeOffRide()
    Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("RideSysteam");
		Set_XSCRIPT_ScriptID(830243);
		Set_XSCRIPT_Parameter(0,13);
		Set_XSCRIPT_ParamCount(1);
    Send_XSCRIPT();	
	NewExterior_Weapon_Ride_LeftBtn:SetProperty("PushedImage", "")
	NewExterior_Weapon_Ride_LeftBtn:SetProperty("NormalImage", "")
	NewExterior_Weapon_Ride_LeftBtn:SetProperty("HoverImage", "")
	NewExterior_Weapon_Ride_LeftBtn:SetToolTip("")
end
function NewExterior_Weapon_RemovePreview()
	ClearSaveAllChange()
	NewExterior_Weapon_Show()
end

function NewExterior_Weapon_Goto()
	AutoRuntoTargetExWithName(338, 270, 0, "庄舞诗")
end

function NewExterior_Weapon_CloseClick()
	SetGameMissionData("MD_WEAPONYULAN",0)
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("RideSysteam")
		Set_XSCRIPT_ScriptID(830243)
		Set_XSCRIPT_Parameter(0,11);
		Set_XSCRIPT_Parameter(1,-99);
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()	
	NewExterior_Weapon_FakeObject:SetFakeObject("")
	NewExterior_Weapon_SavePosition()
	this:Hide()
end

function IsTargetEquip()
	local nIsOpen = 0
	if(IsWindowShow("TargetEquip")) then
		nIsOpen = 1
	end	
	return nIsOpen
end

function NewExterior_Weapon_OnHidden()	
	SetGameMissionData("MD_WEAPONYULAN",0)
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("RideSysteam")
		Set_XSCRIPT_ScriptID(830243)
		Set_XSCRIPT_Parameter(0,11);
		Set_XSCRIPT_Parameter(1,-99);
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()	
	if IsWindowShow("NewExterior_DressBox") 
		or IsWindowShow("NewExterior_Ride") 
		or IsWindowShow("NewExterior_PetPossJian")
		or IsWindowShow("NewExterior_Facestyle") 
		or IsWindowShow("NewExterior_HairStyle") 
		or IsWindowShow("NewExterior_PlayerFrame") then
	end	
	NewExterior_Weapon_FakeObject:SetFakeObject("")
end

function NewExterior_Weapon_CleanUp_LeftButton()
	NewExterior_Weapon_Dress_LeftBtn:SetActionItem(-1)
	
	local ctrl_list = {
		[1] = NewExterior_Weapon_Weapon_LeftBtn,
		[2] = NewExterior_Weapon_PetPossJian_LeftBtn,
		[3] = NewExterior_Weapon_FaceStyle_LeftBtn,
		[4] = NewExterior_Weapon_HairStyle_LeftBtn,
		[5] = NewExterior_Weapon_PlayerFrame_LeftBtn,
		[6] = NewExterior_Weapon_Ride_LeftBtn,	
	}
	
	for i = 1 ,6 do
		ctrl_list[i]:SetProperty("Empty", "False")
		ctrl_list[i]:SetProperty("UseDefaultTooltip", "True")
		ctrl_list[i]:SetProperty("NormalImage", "")
		ctrl_list[i]:SetProperty("HoverImage", "")
		ctrl_list[i]:SetToolTip("")
	end
	
	NewExterior_Weapon_PlayerFrame_Mask:SetProperty("Image", "")
	
	NewExterior_Weapon_Dress_ActionImg:Hide()
	NewExterior_Weapon_Weapon_ActionImg:Hide()
	NewExterior_Weapon_PetPossJian_ActionImg:Hide()
	NewExterior_Weapon_FaceStyle_ActionImg:Hide()
	NewExterior_Weapon_HairStyle_ActionImg:Hide()
	NewExterior_Weapon_PlayerFrame_ActionImg:Hide()
	NewExterior_Weapon_Ride_ActionImg:Hide()	
	
	NewExterior_Weapon_Dress_LockImg:Hide()
	NewExterior_Weapon_Weapon_LockImg:Hide()
	NewExterior_Weapon_PetPossJian_LockImg:Hide()
	NewExterior_Weapon_FaceStyle_LockImg:Hide()
	NewExterior_Weapon_HairStyle_LockImg:Hide()
	NewExterior_Weapon_PlayerFrame_LockImg:Hide()
	NewExterior_Weapon_Ride_LockImg:Hide()

end

function NewExterior_Weapon_FakeObject_TurnLeft(idx)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		--向左旋转开始
		if(idx == 1) then
			NewExterior_Weapon_FakeObject:RotateBegin(-0.3);
		--向左旋转结束
		else
			NewExterior_Weapon_FakeObject:RotateEnd();
		end
	end
end

function NewExterior_Weapon_FakeObject_TurnRight(idx)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		--向右旋转开始
		if(idx == 1) then
			NewExterior_Weapon_FakeObject:RotateBegin(0.3);
		--向右旋转结束
		else
			NewExterior_Weapon_FakeObject:RotateEnd();
		end
	end
end

function Exterior_Weapon_DoAction(index)	
	local cacheExteriorID = LuaFnGetCurrentExteriorSetInfo("WEAPON")
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		LuaFnExteriorAvatarPlayAction(0, cacheExteriorID, index - 1)
	end	
end

function NewExterior_Weapon_UpdateCheckButton()

end
--右键取下时装
function NewExterior_Weapon_ActionToDressBox()
	--卸下时装到时装格子
    Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("ExteriorFashion");
		Set_XSCRIPT_ScriptID(830243);
		Set_XSCRIPT_Parameter(0,1);
		Set_XSCRIPT_Parameter(1,1);
		Set_XSCRIPT_ParamCount(2);
    Send_XSCRIPT();	
	NewExterior_Weapon_Dress_LockImg:Hide()
	NewExterior_Weapon_Dress_ActionImg:Hide()
	NewExterior_Weapon_Dress_LeftBtn:SetActionItem(-1)
end
--时装
function NewExterior_Weapon_OpenFashion()
	NewExterior_Weapon_SavePosition()
	LuaFnAskOpenExterior(1)
end
--幻武
function NewExterior_Weapon_OpenWeapon()

end
--附体
function NewExterior_Weapon_OpenFuti()
	NewExterior_Weapon_SavePosition()
	LuaFnAskOpenExterior(6)
end
--坐骑
function NewExterior_Weapon_OpenRide()
	NewExterior_Weapon_SavePosition()
	LuaFnAskOpenExterior(3)
end
--发型
function NewExterior_Weapon_OpenHair()
	NewExterior_Weapon_SavePosition()	
	LuaFnAskOpenExterior(5)
end
--脸型
function NewExterior_Weapon_OpenFace()
	NewExterior_Weapon_SavePosition()	
	LuaFnAskOpenExterior(4)
end
--头像
function NewExterior_Weapon_OpenPortrait()
	NewExterior_Weapon_SavePosition()	
	LuaFnAskOpenExterior(7)
end

function NewExterior_Weapon_OpenInfant()
end

function NewExterior_Weapon_CloseSameGroupWindow()
	CloseWindow("SelfEquip", true)
	CloseWindow("NewExterior_Ride", true)
	--CloseWindow("NewExterior_Weapon", true)
	CloseWindow("NewExterior_PetPossJian", true)
	CloseWindow("NewExterior_Facestyle", true)
	CloseWindow("NewExterior_HairStyle", true)
	CloseWindow("NewExterior_PlayerFrame", true)
	CloseWindow("NewExterior_DressBox", true)
end

function NewExterior_Weapon_SavePosition()
	NewExterior_Weapon_FakeObject:SetFakeObject("")
	Variable:SetVariable("ExteriorUnionPos", NewExterior_Weapon_Frame:GetProperty("UnifiedPosition"), 1)
end

function NewExterior_Weapon_SetPosition()	
	local nExteriorUnionPos = Variable:GetVariable("ExteriorUnionPos")
	if nExteriorUnionPos ~= nil then
		NewExterior_Weapon_Frame:SetProperty("UnifiedPosition", nExteriorUnionPos)
	end
end

function NewExterior_Weapon_RemoveTip(nExteriorID)	
	local nTip = LuaFnGetExteriorTip(g_ExteriorType, nExteriorID)
	if nTip == 1 then
		LuaFnRemoveExteriorTip(g_ExteriorType, nExteriorID)
	--	NewExterior_Ride_UpdateCheckButton()
		
		for i = 1, 5 do	
			local nExteriorWeaponID = LuaFnGetWeaponIDFromGroup(g_CurSelExteriorID, i - 1)
			if nExteriorWeaponID == nExteriorID then
				g_WeaponLevelTip[i]:Hide()			
			end
		end

		NewExterior_Weapon_UpdateGroupTip()
	end	
end

function NewExterior_Weapon_ShowFashionWeaponCheckButton()
	local IsDisplay = SystemSetup:LuaFnIsFashionDisplay()
	NewExterior_Weapon_Dress_Type:SetCheck(IsDisplay)
	
	IsDisplay = SystemSetup:LuaFnIsExteriorWeaponDisplay()
	NewExterior_Weapon_Weapon_Type:SetCheck(IsDisplay)
end
