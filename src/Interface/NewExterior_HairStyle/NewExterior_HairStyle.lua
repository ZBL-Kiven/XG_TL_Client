--!!!reloadscript =NewExterior_HairStyle
local g_NewExterior_HairStyle_UnifiedPosition = ""

local EXTERIORFILTTING_TOTALKIND = 6;
local g_TargetExteriorIndex = 0		--定位的外观索引，从1开始
local g_TargetExteriorID = 0			--定位的外观ID
local g_ChangeBy = 0;
local g_CurSelExteriorID = 0			--当前选择的外观ID，从1开始
local g_CurSelColorIndex = 0			--当前选中的颜色
local Style_Index = {};
local g_NeedChangeScrollSize = 1
local STYLE_BUTTON = 20
local g_Distance = 1
local g_Distance_Ori = 4
local g_Distance_Max = 4
local g_InitList = 0
local g_ExteriorType = 4 --发型
local g_MaxBarNum = 0
local g_BarList = {}
local g_ColorList = {}
local g_MaxColor = 20
local g_Hair_SuperListItem = {}
local g_Hair_ColourListItem = {}
local Current_Page = 0
local Current = 0
local g_HaveChange = 0;
local nEquipPos = -1
local nSaveHairID = -1
local Max_Style = 0
local g_HairMaxNum = 0
local g_CameraPosition =
{
	--女性相关位置
	[0] = {{fHeight = 0.85, fDistance = 12, fPitch=0.2}, {fHeight = 0.85, fDistance = 7.2, fPitch=0.2}, {fHeight = 1.55, fDistance = 2.5, fPitch=0.20}, {fHeight = 1.55, fDistance = 1.7, fPitch=0.20}},
	--男性相关位置
	[1] = {{fHeight = 0.85, fDistance = 12, fPitch=0.28}, {fHeight = 0.85, fDistance = 7.5, fPitch=0.28}, {fHeight = 1.65, fDistance = 2.7, fPitch=0.28}, {fHeight = 1.70, fDistance = 1.9, fPitch=0.28}},
}
local g_Hair_ListItem = {}
local Original_Style = 0
local g_DecoWeapon_Display = 0
local g_Original_Red,g_Original_Green,g_Original_Blue,g_Original_Alpha = 0,0,0,0

local Red_List,Green_List,Blue_List,Alpha_List = {},{},{},{}
local nMDIndex = {
		{11,12,13},
		{14,15,16},
		{17,18,19},
		{20,21,22},
		{23,24,25},
		{26,27,28},
		{29,30,31},
		{32,33,34},
		{35,36,37},
		{38,39,40},
		{41,42,43},
		{44,45,46},
		{47,48,49},
		{50,51,52},
		{53,54,55},
		{56,57,58},
		{59,60,61},
		{62,63,64},
		{65,66,67},
		{68,69,70},
	}

--=========
--PreLoad==
--=========

function NewExterior_HairStyle_PreLoad()	
	this:RegisterEvent("UNIT_LEVEL",false)	
	this:RegisterEvent("ON_SCENE_TRANS",false)
	this:RegisterEvent("ON_SERVER_TRANS",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	this:RegisterEvent("ADJEST_UI_POS",false)	
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)	
	this:RegisterEvent("UI_COMMAND", false)	
	this:RegisterEvent("UNIT_FACE_IMAGE");
end

--=========
--OnLoad
--=========
function NewExterior_HairStyle_OnLoad()
	g_NewExterior_HairStyle_UnifiedPosition = NewExterior_HairStyle_Frame:GetProperty("UnifiedPosition")
	for i = 1,20 do
		table.insert(g_Hair_SuperListItem,{Try = _G[string.format("NewExterior_HairStyle_SuperListItemActionTry%d",i)],Lock = _G[string.format("NewExterior_HairStyle_SuperListItemActionLock%d",i)],Button = _G[string.format("NewExterior_HairStyle_SuperListItemAction%d",i)],ActionTry = _G[string.format("NewExterior_HairStyle_SuperListItemActionDef%d",i)]})
	end		
	for i = 1,20 do
		table.insert(g_Hair_ColourListItem,{Button = _G[string.format("NewExterior_HairStyle_ColorListItemAction_%d",i)],Color = _G[string.format("NewExterior_HairStyle_ColorListColor_%d",i)],Lock = _G[string.format("NewExterior_HairStyle_ColorListItemActionLock_%d",i)],Action = _G[string.format("NewExterior_HairStyle_ColorListItemActionDef_%d",i)],Try = _G[string.format("NewExterior_HairStyle_ColorListItemActionTry_%d",i)],})
	end		
end
function NewExterior_HairStyle_ExteriorWeaponDisplay()
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
function NewExterior_HairStyle_FashionDisplay()
	--时装显示控制
	local IsDisplay = SystemSetup:Get_Display_Dress();
	NewExterior_DressBox_Dress_Type : SetCheck(1)--IsDisplay
	if IsDisplay == 1 then
		IsDisplay = 0
	else
		IsDisplay = 1
	end
	SystemSetup:Set_Display_Dress(1);
end

--=========
--OnEvent
--=========
function NewExterior_HairStyle_OnEvent(event)
	if event == "UI_COMMAND" and tonumber(arg0) == 990014 then
		SetGameMissionData("MD_EXTERIOR",5)
		NewExterior_HairStyle_FakeObject : SetFakeObject( "" );
		if(IsWindowShow("Shop_Dresser")) then
			CloseWindow("Shop_Dresser", true);
		end
		if(IsWindowShow("NewExterior_DressBox")) then
			CloseWindow("NewExterior_DressBox", true);
		end
		if(IsWindowShow("NewExterior_Facestyle")) then
			CloseWindow("NewExterior_Facestyle", true);
		end
		if(IsWindowShow("NewExterior_PetSoul")) then
			CloseWindow("NewExterior_PetSoul", true);
		end
		if(IsWindowShow("NewExterior_PlayerFrame")) then
			CloseWindow("NewExterior_PlayerFrame", true);
		end
		if(IsWindowShow("NewExterior_Ride")) then
			CloseWindow("NewExterior_Ride", true);
		end
		if(IsWindowShow("NewExterior_Weapon")) then
			CloseWindow("NewExterior_Weapon", true);
		end
		if(IsWindowShow("NewExterior_Weapon_Levelup")) then
			CloseWindow("NewExterior_Weapon_Levelup", true);
		end
		if(IsWindowShow("SelectHairstyle")) then
			CloseWindow("SelectHairstyle", true);
		end
		if(IsWindowShow("SelectHairColor")) then
			CloseWindow("SelectHairColor", true);
		end
		if(IsWindowShow("SelectFacestyle")) then
			CloseWindow("SelectFacestyle", true);
		end
		if(this:IsVisible() and tonumber(Original_Style)) then
			DataPool:Change_MyHairStyle(Original_Style);
		end
		g_HairMaxNum = Get_XParam_INT(0)
		g_Hair_ListItem = {}
		local nHairData = Get_XParam_STR(0)
		for i = 1,g_HairMaxNum do
			local nHairHave = string.sub(nHairData,i,i)
			table.insert(g_Hair_ListItem,tonumber(nHairHave))
		end		
		NewExterior_HairStyle_SetPosition()
		NewExterior_HairStyle_CloseSameGroupWindow()
		this:Show()
		NewExterior_HairStyle_Show()
		return		
	end	
	if event == "UI_COMMAND" and tonumber(arg0) == 1000000037 then
		NewExterior_HairStyle_Weapon_Type:SetCheck(Get_XParam_INT(0))
		return
	end	
	if event == "UI_COMMAND" and tonumber(arg0) == 21 and this:IsVisible() then
		DataPool:Change_MyHairStyle(Original_Style);
		return
	end	
	if event == "UI_COMMAND" and tonumber(arg0) == 122032413 then
		if GetGameMissionData("MD_EXTERIOR") == 5 then
			NewExterior_HairStyle_Show()
		end
		return
	end		
	-- 头像信息改变
	if( (event == "UNIT_FACE_IMAGE") and (arg0 == "player") ) then
		if GetGameMissionData("MD_EXTERIOR") == 5 then
			NewExterior_HairStyle_Show()
		end		
		return;
	end
	if event == "ON_SCENE_TRANS" or event == "ON_SERVER_TRANS" or event == "HIDE_ON_SCENE_TRANSED" then
		this:Hide()
	end
	-- 游戏窗口尺寸发生了变化 or 游戏分辨率发生了变化
	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		NewExterior_HairStyle_Frame:SetProperty("UnifiedPosition", g_NewExterior_HairStyle_UnifiedPosition)
	end
end
function NewExterior_HairStyle_Show()
	Original_Style = DataPool:Get_MyHairStyle();
	Current_Page = 0
	--列表
	NewExterior_HairStyle_UpdateList()
	-- 左侧
	NewExterior_HairStyle_UpdateLeftBtn()
	NewExterior_HairStyle_UpdateObj()
end
function NewExterior_HairStyle_Page(nPage)
	Current_Page = Current_Page + nPage;
	NewExterior_HairStyle_UpdateList();
end
function NewExterior_HairStyle_UpdateLeftBtn()	
	--时装
	if GetGameMissionData("MD_DRESS") ~= 0 then
		NewExterior_HairStyle_Dress_LockImg:Show()
		NewExterior_HairStyle_Dress_ActionImg:Show()
		local _,Icons = LifeAbility : GetPrescr_Material(GetGameMissionData("MD_DRESS"))
		local strImage = GetIconFullName(Icons)
		NewExterior_HairStyle_Dress_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_HairStyle_Dress_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_HairStyle_Dress_LeftBtn:SetProperty("PushedImage", strImage)
		NewExterior_HairStyle_Dress_LeftBtn:SetProperty("Empty", "False")
		NewExterior_HairStyle_Dress_LeftBtn:SetProperty("UseDefaultTooltip", "False")
	else
		NewExterior_HairStyle_Dress_LeftBtn:SetProperty("NormalImage", "")
		NewExterior_HairStyle_Dress_LeftBtn:SetProperty("HoverImage", "")	
		NewExterior_HairStyle_Dress_LeftBtn:SetProperty("PushedImage", "")	
		local theAction = EnumAction(2, "equip");
		NewExterior_HairStyle_Dress_LeftBtn:SetActionItem(theAction:GetID())
		NewExterior_HairStyle_Dress_LockImg:Hide()
		NewExterior_HairStyle_Dress_ActionImg:Hide()	
	end	
	--坐骑
	theAction = DataPool:GetPlayerMission_DataRound(362)
	NewExterior_HairStyle_Ride_LockImg:Hide()
	NewExterior_HairStyle_Ride_ActionImg:Hide()
	if theAction ~= 0 then
		local strIcon = LuaFnGetExteriorRideInfo(theAction,"Icon")
		local strName 	= LuaFnGetExteriorRideInfo(theAction, "Name")
		local strImage = GetIconFullName(strIcon)
		NewExterior_HairStyle_Ride_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_HairStyle_Ride_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_HairStyle_Ride_LeftBtn:SetProperty("Empty", "False")
		NewExterior_HairStyle_Ride_LeftBtn:SetProperty("UseDefaultTooltip", "True")
		NewExterior_HairStyle_Ride_LeftBtn:SetToolTip(strName)
	end
	if GetGameMissionData("MD_RIDA") ~= 0 then
		NewExterior_HairStyle_Ride_ActionImg:Show()
		NewExterior_HairStyle_Ride_LockImg:Show()
		strIcon 	= LuaFnGetExteriorRideInfo(GetGameMissionData("MD_RIDA"), "Icon")
		strImage = GetIconFullName(strIcon)
		strName 	= LuaFnGetExteriorRideInfo(GetGameMissionData("MD_RIDA"), "Name")
		NewExterior_HairStyle_Ride_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_HairStyle_Ride_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_HairStyle_Ride_LeftBtn:SetProperty("Empty", "False")
		NewExterior_HairStyle_Ride_LeftBtn:SetProperty("UseDefaultTooltip", "True")
		NewExterior_HairStyle_Ride_LeftBtn:SetToolTip(strName)
	end		
	--幻武
	cacheExteriorID = DataPool:GetPlayerMission_DataRound(389)
	if cacheExteriorID ~= 0 then
		local strName 	= LuaFnGetExteriorWeaponInfo(cacheExteriorID, "Name")
		local strIcon 	= LuaFnGetExteriorWeaponInfo(cacheExteriorID, "Icon")
		local strImage = GetIconFullName(strIcon)
		NewExterior_HairStyle_Weapon_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_HairStyle_Weapon_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_HairStyle_Weapon_LeftBtn:SetProperty("Empty", "False")
		NewExterior_HairStyle_Weapon_LeftBtn:SetProperty("UseDefaultTooltip", "True")
		local strTemp = strName
		NewExterior_HairStyle_Weapon_LeftBtn:SetToolTip(strTemp)
	else
		NewExterior_HairStyle_Weapon_LeftBtn:SetProperty("HoverImage", "")
		NewExterior_HairStyle_Weapon_LeftBtn:SetProperty("NormalImage", "")
	end
	NewExterior_HairStyle_Weapon_ActionImg:Hide()
	NewExterior_HairStyle_Weapon_LockImg:Hide()
	if GetGameMissionData("MD_WEAPON") > 0 then
		NewExterior_HairStyle_Weapon_ActionImg:Show()
		NewExterior_HairStyle_Weapon_LockImg:Show()
		strIcon 	= LuaFnGetExteriorWeaponInfo(GetGameMissionData("MD_WEAPON"), "Icon")
		strName 	= LuaFnGetExteriorWeaponInfo(GetGameMissionData("MD_WEAPON"), "Name")
		strImage = GetIconFullName(strIcon)
		NewExterior_HairStyle_Weapon_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_HairStyle_Weapon_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_HairStyle_Weapon_LeftBtn:SetToolTip(strName)
	end		
	-- 附体
	cacheExteriorID = DataPool:GetPlayerMission_DataRound(387)
	if cacheExteriorID > 0 then
		local strName,iQual,iBloodRank,curPetSoulid,strIcon = NewExterior_PetSoul_DataShow(cacheExteriorID)
		strImage = GetIconFullName(strIcon)
		NewExterior_HairStyle_PetSoul_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_HairStyle_PetSoul_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_HairStyle_PetSoul_LeftBtn:SetToolTip(strName)
		NewExterior_HairStyle_PetSoul_LeftBtn:SetProperty("Empty", "False")
		NewExterior_HairStyle_PetSoul_LeftBtn:SetProperty("UseDefaultTooltip", "True")
	end
	NewExterior_HairStyle_PetSoul_LockImg:Hide()
	NewExterior_HairStyle_PetSoul_ActionImg:Hide()
	local TryPoss = GetGameMissionData("MD_PETPOSS")
	if TryPoss ~= 0 then
		TryPoss = math.mod(TryPoss,100)
		local strName,strIcon,iQual = LuaFnGetExteriorPossInfo(TryPoss)
		strImage = GetIconFullName(strIcon)
		NewExterior_HairStyle_PetSoul_LockImg:Show()
		NewExterior_HairStyle_PetSoul_ActionImg:Show()
		NewExterior_HairStyle_PetSoul_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_HairStyle_PetSoul_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_HairStyle_PetSoul_LeftBtn:SetToolTip(strName)
		NewExterior_HairStyle_PetSoul_LeftBtn:SetProperty("Empty", "False")
		NewExterior_HairStyle_PetSoul_LeftBtn:SetProperty("UseDefaultTooltip", "True")
	end
	--脸型
	cacheExteriorID = DataPool:Get_MyFaceStyle()
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local _,_,_,IconFile,_,StyleName = DataPool : Change_MyFaceStyle_Item(cacheExteriorID);
		local strImage = GetIconFullName(IconFile)			
		NewExterior_HairStyle_FaceStyle_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_HairStyle_FaceStyle_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_HairStyle_FaceStyle_LeftBtn:SetProperty("Empty", "False")
		NewExterior_HairStyle_FaceStyle_LeftBtn:SetProperty("UseDefaultTooltip", "True")
		NewExterior_HairStyle_FaceStyle_ActionImg:Hide()
		NewExterior_HairStyle_FaceStyle_LockImg:Hide()
		local strTemp = StyleName
		NewExterior_HairStyle_FaceStyle_LeftBtn:SetToolTip(strTemp)
	end
	if GetGameMissionData("MD_FACE") ~= 0 then
		NewExterior_HairStyle_FaceStyle_ActionImg:Show()
		NewExterior_HairStyle_FaceStyle_LockImg:Show()
		strIcon 	= LuaFnGetExteriorFaceInfo(GetGameMissionData("MD_FACE"), "Icon")
		strName 	= LuaFnGetExteriorFaceInfo(GetGameMissionData("MD_FACE"), "Name")
		strImage = GetIconFullName(strIcon)
		NewExterior_HairStyle_FaceStyle_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_HairStyle_FaceStyle_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_HairStyle_FaceStyle_LeftBtn:SetProperty("Empty", "False")
		NewExterior_HairStyle_FaceStyle_LeftBtn:SetProperty("UseDefaultTooltip", "True")
		NewExterior_HairStyle_FaceStyle_LeftBtn:SetToolTip(strName)
	end	
	--发型
	cacheExteriorID = DataPool : Get_MyHairStyle()
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local strName 	= LuaFnGetExteriorHairInfo(cacheExteriorID, "Name")
		local strIcon 	= LuaFnGetExteriorHairInfo(cacheExteriorID, "Icon")
		local strImage = GetIconFullName(strIcon)		
		NewExterior_HairStyle_HairStyle_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_HairStyle_HairStyle_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_HairStyle_HairStyle_LeftBtn:SetProperty("Empty", "False")
		NewExterior_HairStyle_HairStyle_LeftBtn:SetProperty("UseDefaultTooltip", "True")
		NewExterior_HairStyle_HairStyle_LockImg:Hide()
		NewExterior_HairStyle_HairStyle_ActionImg:Hide()
		local strTemp = strName
		NewExterior_HairStyle_HairStyle_LeftBtn:SetToolTip(strTemp)
	end
	if GetGameMissionData("MD_HAIR") ~= 0 then
		NewExterior_HairStyle_HairStyle_LockImg:Show()
		NewExterior_HairStyle_HairStyle_ActionImg:Show()
		strIcon 	= LuaFnGetExteriorHairInfo(GetGameMissionData("MD_HAIR"), "Icon")
		strName 	= LuaFnGetExteriorHairInfo(GetGameMissionData("MD_HAIR"), "Name")
		strImage = GetIconFullName(strIcon)
		NewExterior_HairStyle_HairStyle_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_HairStyle_HairStyle_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_HairStyle_HairStyle_LeftBtn:SetProperty("Empty", "False")
		NewExterior_HairStyle_HairStyle_LeftBtn:SetProperty("UseDefaultTooltip", "True")
		NewExterior_HairStyle_HairStyle_LeftBtn:SetToolTip(strName)
	end	
	--头像
	local strHeadTip = ""
	cacheExteriorID = DataPool : Get_MyHeadStyle()
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local strName 	= LuaFnGetExteriorPortraitInfo(cacheExteriorID, "Name")
		local strIcon 	= LuaFnGetExteriorPortraitInfo(cacheExteriorID, "Icon")
		local strImage = GetIconFullName(strIcon)		
		NewExterior_HairStyle_PlayerFrame_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_HairStyle_PlayerFrame_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_HairStyle_PlayerFrame_LeftBtn:SetProperty("Empty", "False")
		NewExterior_HairStyle_PlayerFrame_LeftBtn:SetProperty("UseDefaultTooltip", "True")
		NewExterior_HairStyle_PlayerFrame_LockImg:Hide()
		NewExterior_HairStyle_PlayerFrame_ActionImg:Hide()
		local strTemp = strName
		NewExterior_HairStyle_PlayerFrame_LeftBtn:SetToolTip(strTemp)	
	end	
	if GetGameMissionData("MD_HEAD") ~= 0 then
		NewExterior_HairStyle_PlayerFrame_LockImg:Show()
		NewExterior_HairStyle_PlayerFrame_ActionImg:Show()
		strIcon 	= LuaFnGetExteriorPortraitInfo(GetGameMissionData("MD_HEAD"), "Icon")
		strName 	= LuaFnGetExteriorPortraitInfo(GetGameMissionData("MD_HEAD"), "Name")
		strImage = GetIconFullName(strIcon)
		NewExterior_HairStyle_PlayerFrame_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_HairStyle_PlayerFrame_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_HairStyle_PlayerFrame_LeftBtn:SetProperty("Empty", "False")
		NewExterior_HairStyle_PlayerFrame_LeftBtn:SetProperty("UseDefaultTooltip", "True")
		NewExterior_HairStyle_PlayerFrame_LeftBtn:SetToolTip(strName)
	end	
	--隐藏一下控件
	for i = 1,20 do
		g_Hair_SuperListItem[i].Try:Hide()
		g_Hair_SuperListItem[i].ActionTry:Hide()
	end
end
function NewExterior_HairStyle_Clicked(nIndex)
	if( nIndex < 0 or nIndex + STYLE_BUTTON * (Current_Page) > Max_Style ) then
		return
	end
	for i = 1,20 do
		g_Hair_SuperListItem[i].Button : SetPushed(0);
		g_Hair_SuperListItem[i].ActionTry : Hide()
	end
	Current = nIndex
	g_Hair_SuperListItem[Current].Button : SetPushed(1);
	nSaveHairID = Style_Index[nIndex]
	local ItemID,ItemCount,SelectType,IconFile,CostMoney = DataPool : Change_MyHairStyle_Item(Style_Index[nIndex]);
	local name,icon = LifeAbility : GetPrescr_Material(ItemID);
	DataPool : Change_MyHairStyle(Style_Index[nIndex]);
	if DataPool : Get_MyHairStyle() == Style_Index[nIndex] then
		g_Hair_SuperListItem[Current].ActionTry : Show()
	end
	for i,v in g_Hair_SuperListItem do
		if i == nIndex then
			v.Try:Show()
		else
			v.Try:Hide()
		end
	end
	g_HaveChange = 1;	
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("RideSysteam");
		Set_XSCRIPT_ScriptID(830243);
		Set_XSCRIPT_Parameter(0,4);
		Set_XSCRIPT_Parameter(1,1);
		Set_XSCRIPT_Parameter(2,Style_Index[nIndex]);
		Set_XSCRIPT_ParamCount(3);
	Send_XSCRIPT();
	SetGameMissionData("MD_HAIR",nSaveHairID)
	--设置试穿标记
	local strName 	= LuaFnGetExteriorHairInfo(nSaveHairID, "Name")
	local strIcon 	= LuaFnGetExteriorHairInfo(nSaveHairID, "Icon")
	local strImage = GetIconFullName(strIcon)		
	NewExterior_HairStyle_HairStyle_LeftBtn:SetProperty("NormalImage", strImage)
	NewExterior_HairStyle_HairStyle_LeftBtn:SetProperty("HoverImage", strImage)
	NewExterior_HairStyle_HairStyle_LeftBtn:SetProperty("PushedImage", strImage)
	NewExterior_HairStyle_HairStyle_LeftBtn:SetToolTip(strName)	
	NewExterior_HairStyle_HairStyle_LockImg:Show()
	NewExterior_HairStyle_HairStyle_ActionImg:Show()	
end
--发色填充
function NewExterior_HairStyle_ColourUpdateList()
	Red_List,Green_List,Blue_List,Alpha_List = {},{},{},{}
	g_Original_Red,g_Original_Green,g_Original_Blue,g_Original_Alpha = DataPool : Get_MyHairColor();
	local Number =  DataPool:GetXYJServerData(71);
	for i = 1,20 do
		local nRed = DataPool:GetXYJServerData(nMDIndex[i][1]);
		local Green = DataPool:GetXYJServerData(nMDIndex[i][2]);
		local Blue = DataPool:GetXYJServerData(nMDIndex[i][3]);
		local Alpha = g_Original_Alpha
		table.insert(Red_List,nRed)
		table.insert(Green_List,Green)
		table.insert(Blue_List,Blue)
		table.insert(Alpha_List,Alpha)
		g_Hair_ColourListItem[i].Action:Hide()
		g_Hair_ColourListItem[i].Try:Hide()
		-- g_Hair_ColourListItem
		if nRed ~= 0 and Green ~= 0 and Blue ~= 0 then
			local curIcon = string.format("%02X",255)..string.format("%02X",nRed)..string.format("%02X",Green)..string.format("%02X",Blue)
			g_Hair_ColourListItem[i].Color:SetImageColor(curIcon)
			g_Hair_ColourListItem[i].Lock:Hide()
		else
			g_Hair_ColourListItem[i].Lock:Show()
		end
	end
end
--发色切换
function NewExterior_HairStyle_ChangeColour(nIndex)
	local nRed = Red_List[nIndex]
	local nGreen = Green_List[nIndex]
	local nBlue = Blue_List[nIndex]
	local nAlpha = g_Original_Alpha	
	DataPool : Change_MyHairColor(nRed,nGreen,nBlue,nAlpha);
	for i,v in g_Hair_ColourListItem do
		if i == nIndex then
			g_Hair_ColourListItem[i].Try:Show()
		else
			g_Hair_ColourListItem[i].Try:Hide()
		end
	end
	SetGameMissionData("MD_HAIRCLOLOUR",nIndex)
end

function NewExterior_HairStyle_UpdateList()
	NewExterior_HairStyle_ColourUpdateList()
	local i,RaceID,ItemID,ItemCount,SelectType,k,IconFile;
	k = 1;
	Current = 1
	for i = 1,20 do
		g_Hair_SuperListItem[i].Button:SetProperty("NormalImage","")
		g_Hair_SuperListItem[i].Button:Hide()
	end
	for i=0, g_HairMaxNum-1 do
		ItemID,ItemCount,SelectType,IconFile,CostMoney,StyleName = DataPool : Change_MyHairStyle_Item(i);		
		if(ItemID ~= -1 and SelectType >= 2) then
			if k > STYLE_BUTTON * (Current_Page) and k <= STYLE_BUTTON * (Current_Page+1) then
				local m = k - STYLE_BUTTON * (Current_Page);
				Style_Index[m] = i;
				IconFile = GetIconFullName(IconFile)
				g_Hair_SuperListItem[m].Button:SetProperty("NormalImage",IconFile)
				g_Hair_SuperListItem[m].Button:SetProperty("HoverImage",IconFile)
				g_Hair_SuperListItem[m].Button:Show()
				g_Hair_SuperListItem[m].Button:SetToolTip(StyleName)
				if g_Hair_ListItem[i] == 1 then
					g_Hair_SuperListItem[m].Lock:Hide()
				else
					g_Hair_SuperListItem[m].Lock:Show()
				end
			end
			Max_Style = k
			k = k+1;
		end
	end
	if Current_Page == 0 then
		NewExterior_HairStyle_SuperListItemLast : Disable();
	else
		NewExterior_HairStyle_SuperListItemLast : Enable();
	end
	
	if (Current_Page+1)*STYLE_BUTTON <= Max_Style then
		NewExterior_HairStyle_SuperListItemNext : Enable();
	else
		NewExterior_HairStyle_SuperListItemNext : Disable();
	end	
	for i,v in g_Hair_SuperListItem do
		v.Try:Hide()
	end	
end

function Text_Lost()
	NewExterior_HairStyle_Update()
end

function NewExterior_HairStyle_UpdateObj()
	NewExterior_HairStyle_FakeObject : SetFakeObject( "" );
	NewExterior_HairStyle_FakeObject : SetFakeObject( "Player_Head" );
end

function NewExterior_HairStyle_ZoomIn()
	NewExterior_HairStyle_FakeObject : SetFakeObject( "Player_Head" );
end

function NewExterior_HairStyle_ZoomOut()
	NewExterior_HairStyle_FakeObject : SetFakeObject( "EquipChange_Player" );
end

function NewExterior_HairStyle_Goto()
	PushDebugMessage("请前往洛阳（250，130）#R燕如雪#I处")
end

function NewExterior_HairStyle_UpdateOpBtn()

end

function NewExterior_HairStyle_ItemClicked(nIndex)
	local nExteriorID 	= LuaFnGetExteriorIDFromList(g_ExteriorType, nIndex - 1)	
	if g_CurSelExteriorID ~= nExteriorID then
		g_CurSelExteriorID = nExteriorID
		LuaFnSetCurrentExteriorSetInfo("HAIR", g_CurSelExteriorID, g_CurSelColorIndex)
		NewExterior_HairStyle_SetItemSelected(nIndex)
		NewExterior_HairStyle_UpdateObj()
		NewExterior_HairStyle_UpdateLeftBtn()
		NewExterior_HairStyle_RemoveTip(g_CurSelExteriorID)
		NewExterior_HairStyle_UpdateRedPoint()
	else
		local defExteriorID = LuaFnGetExteriorInUse(g_ExteriorType)
		LuaFnSetCurrentExteriorSetInfo("HAIR", defExteriorID, g_CurSelColorIndex)		
		NewExterior_HairStyle_Show()
	end
end

function NewExterior_HairStyle_TakeOffRide()
    Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("RideSysteam");
		Set_XSCRIPT_ScriptID(830243);
		Set_XSCRIPT_Parameter(0,13);
		Set_XSCRIPT_ParamCount(1);
    Send_XSCRIPT();	
	NewExterior_HairStyle_Ride_LeftBtn:SetProperty("PushedImage", "")
	NewExterior_HairStyle_Ride_LeftBtn:SetProperty("NormalImage", "")
	NewExterior_HairStyle_Ride_LeftBtn:SetProperty("HoverImage", "")
	NewExterior_HairStyle_Ride_LeftBtn:SetToolTip("")
end

function NewExterior_HairStyle_TakeOffWeapon()
    Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("RideSysteam");
		Set_XSCRIPT_ScriptID(830243);
		Set_XSCRIPT_Parameter(0,12);
		Set_XSCRIPT_ParamCount(1);
    Send_XSCRIPT();	
	NewExterior_HairStyle_Weapon_LeftBtn:SetProperty("PushedImage", "")
	NewExterior_HairStyle_Weapon_LeftBtn:SetProperty("NormalImage", "")
	NewExterior_HairStyle_Weapon_LeftBtn:SetProperty("HoverImage", "")
	NewExterior_HairStyle_Weapon_LeftBtn:SetToolTip("")
end

function NewExterior_HairStyle_TryExterior()
	--预览信息
	SaveAllChange()
	NewExterior_HairStyle_RemovePreview()
end

function NewExterior_HairStyle_RemovePreview()
	ClearSaveAllChange()
	NewExterior_HairStyle_Show()
end

function NewExterior_HairStyle_ColorClicked(nIndex)
	local uColorCount = LuaFnGetExteriorHairColorCount()
	if nIndex > uColorCount then
		return
	end
	if g_CurSelColorIndex ~= nIndex - 1 then
		g_CurSelColorIndex = nIndex - 1
		LuaFnSetCurrentExteriorSetInfo("HAIR", g_CurSelExteriorID, g_CurSelColorIndex)
		NewExterior_HairStyle_SetColorSelected(nIndex)
		NewExterior_HairStyle_UpdateObj()
		NewExterior_HairStyle_UpdateLeftBtn()
		NewExterior_HairStyle_RemoveColorTip(g_CurSelColorIndex)
		NewExterior_HairStyle_UpdateRedPoint()
	else
		local defColorIndex = LuaFnGetExteriorHairColorIndex()
		LuaFnSetCurrentExteriorSetInfo("HAIR", g_CurSelExteriorID, defColorIndex)
		NewExterior_HairStyle_Show()
	end	
end

function NewExterior_HairStyle_CloseClick()	
	NewExterior_HairStyle_FakeObject : SetFakeObject( "" );
	DataPool : Change_MyHairStyle(Original_Style);
	NewExterior_HairStyle_SavePosition()
	this:Hide()
end
function NewExterior_HairStyle_OnHidden()
	NewExterior_HairStyle_FakeObject : SetFakeObject( "" );
	DataPool:Change_MyHairStyle(Original_Style);
	if IsWindowShow("NewExterior_DressBox") 
		or IsWindowShow("NewExterior_Ride") 
		or IsWindowShow("NewExterior_Weapon")  
		or IsWindowShow("NewExterior_PetPossJian")
		or IsWindowShow("NewExterior_Facestyle") 
		or IsWindowShow("NewExterior_PlayerFrame") then
	end	
	NewExterior_HairStyle_CleanUp()
	NewExterior_HairStyle_SavePosition()
	this:Hide()
end

function NewExterior_HairStyle_CleanUp()
	NewExterior_HairStyle_CleanUp_LeftButton()
end

function NewExterior_HairStyle_CleanUp_LeftButton()
	NewExterior_HairStyle_Dress_LeftBtn:SetActionItem(-1)
end

function NewExterior_HairStyle_FakeObject_TurnLeft(start)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		--向左旋转开始
		if(start == 1) then
			NewExterior_HairStyle_FakeObject:RotateBegin(-0.3);
		--向左旋转结束
		else
			NewExterior_HairStyle_FakeObject:RotateEnd();
		end
	end
end

function NewExterior_HairStyle_FakeObject_TurnRight(start)
	
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		--向右旋转开始
		if(start == 1) then
			NewExterior_HairStyle_FakeObject:RotateBegin(0.3);
		--向右旋转结束
		else
			NewExterior_HairStyle_FakeObject:RotateEnd();
		end
	end
end

function NewExterior_HairStyle_UpdateCamera()
	local sex = GetMySelfRaceId()
	if sex ~= 0 and sex ~= 1 then 
		return
	end
		
	if g_Distance < 1 or g_Distance > g_Distance_Max then
		return
	end
	
	local fHeight, fDistance, fPitch = NewExterior_HairStyle_FakeObject:GetCameraEx()
	fHeight = g_CameraPosition[sex][g_Distance].fHeight
	fDistance = g_CameraPosition[sex][g_Distance].fDistance
	fPitch = g_CameraPosition[sex][g_Distance].fPitch
	NewExterior_HairStyle_FakeObject:SetCameraEx(fHeight, fDistance, fPitch)
end

function NewExterior_HairStyle_SwithViewMode()
	local cacheExteriorID = LuaFnGetCurrentExteriorSetInfo("RIDE")
	if cacheExteriorID > 0 then
		if g_ViewMode == 0 then
			g_ViewMode = 1
		else
			g_ViewMode = 0
		end	
		NewExterior_HairStyle_UpdateObj()
	end	
end
--右键取下时装
function NewExterior_HairStyle_ActionToDressBox()
	--卸下时装到时装格子
    Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("ExteriorFashion");
		Set_XSCRIPT_ScriptID(830243);
		Set_XSCRIPT_Parameter(0,1);
		Set_XSCRIPT_ParamCount(1);
    Send_XSCRIPT();	
	NewExterior_HairStyle_Dress_LockImg:Hide()
	NewExterior_HairStyle_Dress_ActionImg:Hide()
	NewExterior_HairStyle_Dress_LeftBtn:SetActionItem(-1)	
end
--时装
function NewExterior_HairStyle_OpenFashion()
	NewExterior_HairStyle_SavePosition()
	LuaFnAskOpenExterior(1)
end
--幻武
function NewExterior_HairStyle_OpenWeapon()
	NewExterior_HairStyle_SavePosition()
	LuaFnAskOpenExterior(2)
end
--附体
function NewExterior_HairStyle_OpenFuti()
	NewExterior_HairStyle_SavePosition()
	LuaFnAskOpenExterior(6)
end
--坐骑
function NewExterior_HairStyle_OpenRide()
	NewExterior_HairStyle_SavePosition()
	LuaFnAskOpenExterior(3)
end
--发型
function NewExterior_HairStyle_OpenHair()
end
--脸型
function NewExterior_HairStyle_OpenFace()
	NewExterior_HairStyle_SavePosition()	
	LuaFnAskOpenExterior(4)
end
--头像
function NewExterior_HairStyle_OpenPortrait()
	NewExterior_HairStyle_SavePosition()	
	LuaFnAskOpenExterior(7)
end

function NewExterior_HairStyle_CloseSameGroupWindow()
	CloseWindow("SelfEquip", true)
	CloseWindow("NewExterior_Ride", true)
	CloseWindow("NewExterior_Weapon", true)
	CloseWindow("NewExterior_PetPossJian", true)
	CloseWindow("NewExterior_Facestyle", true)
	CloseWindow("NewExterior_PlayerFrame", true)
	CloseWindow("NewExterior_DressBox", true)
end

function NewExterior_HairStyle_SavePosition()
	NewExterior_HairStyle_FakeObject:SetFakeObject("")
	Variable:SetVariable("ExteriorUnionPos", NewExterior_HairStyle_Frame:GetProperty("UnifiedPosition"), 1)
end

function NewExterior_HairStyle_SetPosition()
	
	local nExteriorUnionPos = Variable:GetVariable("ExteriorUnionPos")
	if nExteriorUnionPos ~= nil then
		NewExterior_HairStyle_Frame:SetProperty("UnifiedPosition", nExteriorUnionPos)
	end

end

function NewExterior_HairStyle_RemoveTip(nExteriorID)
	local nTip = LuaFnGetExteriorTip(g_ExteriorType, nExteriorID)
	if nTip == 1 then
		LuaFnRemoveExteriorTip(g_ExteriorType, nExteriorID)
		
		for i = 1, g_MaxBarNum do
			if g_BarList[i] then
				local nID = LuaFnGetExteriorIDFromList(g_ExteriorType, i - 1)
				if LuaFnGetExteriorTip(g_ExteriorType, nID) == 1 then
					g_BarList[i]:GetSubItem("NewExterior_HairStyle_SuperListItemActionTip"):Show()
				else
					g_BarList[i]:GetSubItem("NewExterior_HairStyle_SuperListItemActionTip"):Hide()
				end
			end
		end
	end	
	end
	
function NewExterior_HairStyle_RemoveColorTip(index)
	local nTip = LuaFnEnumExteriorHairColorTip(index)
	if nTip == 1 then
		LuaFnRemoveHairColorTip(index)
	
		for i = 1, g_MaxColor do
			if g_ColorList[i] then
				if LuaFnEnumExteriorHairColorTip(i - 1) == 1 then
					g_ColorList[i]:GetSubItem("NewExterior_HairStyle_ColorListItemActionTip"):Show()
				else
					g_ColorList[i]:GetSubItem("NewExterior_HairStyle_ColorListItemActionTip"):Hide()
				end
			end
		end
	end	
end

function NewExterior_HairStyle_UpdateRedPoint()

	NewExterior_HairStyle_Dress_Tip:Hide()
	
	if LuaFnIsHaveExteriorShowTip(0) == 1 then
		NewExterior_HairStyle_Ride_Tip:Show()
	else
		NewExterior_HairStyle_Ride_Tip:Hide()
	end
	
	if LuaFnIsHaveExteriorShowTip(1) == 1 then
		NewExterior_HairStyle_Weapon_Tip:Show()
	else
		NewExterior_HairStyle_Weapon_Tip:Hide()
	end
	
	if LuaFnIsHaveExteriorShowTip(2) == 1 then
		NewExterior_HairStyle_PetPossJian_Tip:Show()
	else
		NewExterior_HairStyle_PetPossJian_Tip:Hide()
	end
	
	if LuaFnIsHaveExteriorShowTip(3) == 1 then
		NewExterior_HairStyle_FaceStyle_Tip:Show()
	else
		NewExterior_HairStyle_FaceStyle_Tip:Hide()
	end
	
	if LuaFnIsHaveExteriorShowTip(4) == 1 or LuaFnIsHaveHairColorShowTip() == 1 then
		NewExterior_HairStyle_HairStyle_Tip:Show()
	else
		NewExterior_HairStyle_HairStyle_Tip:Hide()
	end
	
	if LuaFnIsHaveExteriorShowTip(5) == 1 or LuaFnIsHaveExteriorShowTip(6) == 1 then
		NewExterior_HairStyle_PlayerFrame_Tip:Show()
	else
		NewExterior_HairStyle_PlayerFrame_Tip:Hide()
	end
	
	if Pneuma:GetMF(2959)== 1 or LuaFnIsHaveExteriorShowTip(7) == 1 or LuaFnIsHaveInfantHairColorShowTip() == 1 then 
		NewExterior_HairStyle_SwitchBtn_Tip:Show()
	else
		NewExterior_HairStyle_SwitchBtn_Tip:Hide()
	end
end

function NewExterior_HairStyle_OpenInfant()
	NewExterior_HairStyle_SavePosition()
	LuaFnInitExteriorFashionList(2, 1)
end
