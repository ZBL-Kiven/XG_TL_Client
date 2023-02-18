--!!!reloadscript =NewExterior_PlayerFrame
local g_NewExterior_PlayerFrame_UnifiedPosition = ""

local EXTERIORFILTTING_TOTALKIND = 6;
local g_TargetExteriorIndex = 0		--定位的外观索引，从1开始
local g_TargetExteriorID = 0			--定位的外观ID

local g_CurSelExteriorID = 0			--当前选择的外观ID，从1开始

local g_CurSelFrameID = 0
local g_TargetFrameIndex = 0
local g_TargetFrameID = 0

local g_Distance = 1
local g_Distance_Ori = 2
local g_Distance_Max = 4
local g_InitList = 0
local g_ExteriorType = 5 --头像
local g_MaxBarNum = 0
local g_BarList = {}
local g_HeadGroup_Icon = {}
local g_Headstyle_Icon = {}
local MAX_OBJ_DISTANCE = 3.0;
local g_nCurSelectGrp = 0
local g_Group_Index = {}
local g_Style_Index = {}
local g_Group_Count = 0
local g_Original_Style = 0
local MAXGROUPSIZE = 35
local g_nCurPage = 1
local g_nAllPage = 1
local g_TotalGroup = 0;
local g_All_Icon = { }
local g_FrameExteriorType = 6
local g_MaxFrameNum = 0
local g_FrameList = {}
local PlayerFrameList ={}
local g_NeedChangeScrollSize = 1
local g_NeedChangeFrameScrollSize = 1
local g_hsgHaveHead = {}
local g_hsgMaxHeadNum = 0
local g_CameraPosition =
{
	--女性相关位置
	[0] = {{fHeight = 0.85, fDistance = 12, fPitch=0.2}, {fHeight = 0.85, fDistance = 7.2, fPitch=0.2}, {fHeight = 1.55, fDistance = 2.5, fPitch=0.20}, {fHeight = 1.55, fDistance = 1.7, fPitch=0.20}},
	--男性相关位置
	[1] = {{fHeight = 0.85, fDistance = 12, fPitch=0.28}, {fHeight = 0.85, fDistance = 7.5, fPitch=0.28}, {fHeight = 1.65, fDistance = 2.7, fPitch=0.28}, {fHeight = 1.70, fDistance = 1.9, fPitch=0.28}},
}

--=========
--PreLoad==
--=========
function NewExterior_PlayerFrame_PreLoad()
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
function NewExterior_PlayerFrame_OnLoad()
	for i = 1,35 do
		table.insert(PlayerFrameList,{_G[string.format("NewExterior_PlayerFrame_SuperListItemAction%d",i)],_G[string.format("NewExterior_PlayerFrame_SuperListItemActionLock%d",i)]})
	end
	for j=1, 5  do
		g_Style_Index[j] = -1
	end	
	g_NewExterior_PlayerFrame_UnifiedPosition = NewExterior_PlayerFrame_Frame:GetProperty("UnifiedPosition")
end
--=========
--OnEvent
--=========
function NewExterior_PlayerFrame_OnEvent(event)
	if event == "UI_COMMAND" and tonumber(arg0) == 2350111 then
		NewExterior_PlayerFrame_FakeObject:SetFakeObject("")
	end
	-- 头像信息改变
	if( (event == "UNIT_FACE_IMAGE") and (arg0 == "player") ) then
		if GetGameMissionData("MD_EXTERIOR") == 7 then
			NewExterior_PlayerFrame_Show()
		end		
		return;
	end
	if event == "UI_COMMAND" and tonumber(arg0) == 122032413 then
		if GetGameMissionData("MD_EXTERIOR") == 7 then
			NewExterior_PlayerFrame_Show()
		end
		return
	end	
	
	if event == "UI_COMMAND" and tonumber(arg0) == 20210805 then
		if(IsWindowShow("NewExterior_DressBox")) then
			CloseWindow("NewExterior_DressBox", true);
		end
		if(IsWindowShow("NewExterior_Facestyle")) then
			CloseWindow("NewExterior_Facestyle", true);
		end
		if(IsWindowShow("NewExterior_HairStyle")) then
			CloseWindow("NewExterior_HairStyle", true);
		end
		if(IsWindowShow("NewExterior_PetSoul")) then
			CloseWindow("NewExterior_PetSoul", true);
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
		SetGameMissionData("MD_EXTERIOR",7)
		g_hsgHaveHead = {}
		g_hsgMaxHeadNum = Get_XParam_INT(0)
		local g_hsg = Get_XParam_STR(0)
		for i = 1,g_hsgMaxHeadNum do
			local nData = string.sub(g_hsg,i,i)
			table.insert(g_hsgHaveHead,tonumber(nData))
		end
		NewExterior_PlayerFrame_SetPosition()
		NewExterior_PlayerFrame_CloseSameGroupWindow()
		this:Show()
		NewExterior_PlayerFrame_Show()
		return
	end
	if event == "ON_SCENE_TRANS" or event == "ON_SERVER_TRANS" or event == "HIDE_ON_SCENE_TRANSED" then
		this:Hide()
	end
	
	-- 游戏窗口尺寸发生了变化 or 游戏分辨率发生了变化
	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		NewExterior_PlayerFrame_Frame:SetProperty("UnifiedPosition", g_NewExterior_PlayerFrame_UnifiedPosition)
	end

end

--=========================================
--翻页
--=========================================
function NewExterior_PlayerFrame_Page(nPage)
	
	g_nCurPage = g_nCurPage + nPage;

	NewExterior_PlayerFrame_UpdateList();

end


function NewExterior_PlayerFrame_Show()
	for i = 1,35 do
		PlayerFrameList[i][1]:SetProperty("Empty","False")
		PlayerFrameList[i][1]:SetProperty("UseDefaultTooltip","True")
	end
	NewExterior_PlayerFrame_UpdateList()
	NewExterior_PlayerFrame_UpdateLeftBtn()
	NewExterior_PlayerFrame_UpdateObj()
end

function NewExterior_PlayerFrame_UpdateLeftBtn()
	--时装
	if GetGameMissionData("MD_DRESS") ~= 0 then
		NewExterior_PlayerFrame_Dress_LockImg:Show()
		NewExterior_PlayerFrame_Dress_ActionImg:Show()
		local _,Icons = LifeAbility : GetPrescr_Material(GetGameMissionData("MD_DRESS"))
		local strImage = GetIconFullName(Icons)
		NewExterior_PlayerFrame_Dress_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_PlayerFrame_Dress_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_PlayerFrame_Dress_LeftBtn:SetProperty("PushedImage", strImage)
		NewExterior_PlayerFrame_Dress_LeftBtn:SetProperty("Empty", "False")
		NewExterior_PlayerFrame_Dress_LeftBtn:SetProperty("UseDefaultTooltip", "False")
	else
		NewExterior_PlayerFrame_Dress_LeftBtn:SetProperty("NormalImage", "")
		NewExterior_PlayerFrame_Dress_LeftBtn:SetProperty("HoverImage", "")
		NewExterior_PlayerFrame_Dress_LeftBtn:SetProperty("PushedImage", "")
		local theAction = EnumAction(2, "equip");
		NewExterior_PlayerFrame_Dress_LeftBtn:SetActionItem(theAction:GetID())
		NewExterior_PlayerFrame_Dress_LockImg:Hide()
		NewExterior_PlayerFrame_Dress_ActionImg:Hide()		
	end
	--坐骑
	theAction = DataPool:GetPlayerMission_DataRound(362)
	NewExterior_PlayerFrame_Ride_LockImg:Hide()
	NewExterior_PlayerFrame_Ride_ActionImg:Hide()
	if theAction ~= 0 then
		local strIcon = LuaFnGetExteriorRideInfo(theAction,"Icon")
		local strName 	= LuaFnGetExteriorRideInfo(theAction, "Name")
		local strImage = GetIconFullName(strIcon)
		NewExterior_PlayerFrame_Ride_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_PlayerFrame_Ride_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_PlayerFrame_Ride_LeftBtn:SetProperty("Empty", "False")
		NewExterior_PlayerFrame_Ride_LeftBtn:SetProperty("UseDefaultTooltip", "True")
		NewExterior_PlayerFrame_Ride_LeftBtn:SetToolTip(strName)
	else
		NewExterior_PlayerFrame_Ride_LeftBtn:SetProperty("NormalImage", "")
		NewExterior_PlayerFrame_Ride_LeftBtn:SetProperty("HoverImage", "")	
	end
	if GetGameMissionData("MD_RIDA") ~= 0 then
		NewExterior_PlayerFrame_Ride_ActionImg:Show()
		NewExterior_PlayerFrame_Ride_LockImg:Show()
		strIcon 	= LuaFnGetExteriorRideInfo(GetGameMissionData("MD_RIDA"), "Icon")
		strImage = GetIconFullName(strIcon)
		strName 	= LuaFnGetExteriorRideInfo(GetGameMissionData("MD_RIDA"), "Name")
		NewExterior_PlayerFrame_Ride_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_PlayerFrame_Ride_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_PlayerFrame_Ride_LeftBtn:SetProperty("Empty", "False")
		NewExterior_PlayerFrame_Ride_LeftBtn:SetProperty("UseDefaultTooltip", "True")
		NewExterior_PlayerFrame_Ride_LeftBtn:SetToolTip(strName)
	end		
	--幻武
	cacheExteriorID = DataPool:GetPlayerMission_DataRound(389)
	if cacheExteriorID ~= 0 then
		local strName 	= LuaFnGetExteriorWeaponInfo(cacheExteriorID, "Name")
		local strIcon 	= LuaFnGetExteriorWeaponInfo(cacheExteriorID, "Icon")
		local strImage = GetIconFullName(strIcon)
		NewExterior_PlayerFrame_Weapon_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_PlayerFrame_Weapon_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_PlayerFrame_Weapon_LeftBtn:SetProperty("Empty", "False")
		NewExterior_PlayerFrame_Weapon_LeftBtn:SetProperty("UseDefaultTooltip", "True")
		local strTemp = strName
		NewExterior_PlayerFrame_Weapon_LeftBtn:SetToolTip(strTemp)
	else
		NewExterior_PlayerFrame_Weapon_LeftBtn:SetProperty("HoverImage", "")
		NewExterior_PlayerFrame_Weapon_LeftBtn:SetProperty("NormalImage", "")
	end
	NewExterior_PlayerFrame_Weapon_ActionImg:Hide()
	NewExterior_PlayerFrame_Weapon_LockImg:Hide()
	if GetGameMissionData("MD_WEAPON") > 0 then
		NewExterior_PlayerFrame_Weapon_ActionImg:Show()
		NewExterior_PlayerFrame_Weapon_LockImg:Show()
		strIcon 	= LuaFnGetExteriorWeaponInfo(GetGameMissionData("MD_WEAPON"), "Icon")
		strName 	= LuaFnGetExteriorWeaponInfo(GetGameMissionData("MD_WEAPON"), "Name")
		strImage = GetIconFullName(strIcon)
		NewExterior_PlayerFrame_Weapon_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_PlayerFrame_Weapon_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_PlayerFrame_Weapon_LeftBtn:SetToolTip(strName)
	end		
	-- 附体
	cacheExteriorID = DataPool:GetPlayerMission_DataRound(387)
	if cacheExteriorID > 0 then
		local strName,iQual,iBloodRank,curPetSoulid,strIcon = NewExterior_PetSoul_DataShow(cacheExteriorID)
		strImage = GetIconFullName(strIcon)
		NewExterior_PlayerFrame_PetSoul_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_PlayerFrame_PetSoul_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_PlayerFrame_PetSoul_LeftBtn:SetToolTip(strName)
		NewExterior_PlayerFrame_PetSoul_LeftBtn:SetProperty("Empty", "False")
		NewExterior_PlayerFrame_PetSoul_LeftBtn:SetProperty("UseDefaultTooltip", "True")
	end
	NewExterior_PlayerFrame_PetSoul_LockImg:Hide()
	NewExterior_PlayerFrame_PetSoul_ActionImg:Hide()
	local TryPoss = GetGameMissionData("MD_PETPOSS")
	if TryPoss ~= 0 then
		TryPoss = math.mod(TryPoss,100)
		local strName,strIcon,iQual = LuaFnGetExteriorPossInfo(TryPoss)
		strImage = GetIconFullName(strIcon)
		NewExterior_PlayerFrame_PetSoul_LockImg:Show()
		NewExterior_PlayerFrame_PetSoul_ActionImg:Show()
		NewExterior_PlayerFrame_PetSoul_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_PlayerFrame_PetSoul_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_PlayerFrame_PetSoul_LeftBtn:SetToolTip(strName)
		NewExterior_PlayerFrame_PetSoul_LeftBtn:SetProperty("Empty", "False")
		NewExterior_PlayerFrame_PetSoul_LeftBtn:SetProperty("UseDefaultTooltip", "True")
	end
	--脸型
	cacheExteriorID = DataPool:Get_MyFaceStyle()
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local _,_,_,IconFile,_,StyleName = DataPool : Change_MyFaceStyle_Item(cacheExteriorID);
		local strImage = GetIconFullName(IconFile)			
		NewExterior_PlayerFrame_FaceStyle_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_PlayerFrame_FaceStyle_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_PlayerFrame_FaceStyle_LeftBtn:SetProperty("Empty", "False")
		NewExterior_PlayerFrame_FaceStyle_LeftBtn:SetProperty("UseDefaultTooltip", "True")
		NewExterior_PlayerFrame_FaceStyle_ActionImg:Hide()
		NewExterior_PlayerFrame_FaceStyle_LockImg:Hide()
		local strTemp = StyleName
		NewExterior_PlayerFrame_FaceStyle_LeftBtn:SetToolTip(strTemp)
	end
	if GetGameMissionData("MD_FACE") ~= 0 then
		NewExterior_PlayerFrame_FaceStyle_ActionImg:Show()
		NewExterior_PlayerFrame_FaceStyle_LockImg:Show()
		strIcon 	= LuaFnGetExteriorFaceInfo(GetGameMissionData("MD_FACE"), "Icon")
		strName 	= LuaFnGetExteriorFaceInfo(GetGameMissionData("MD_FACE"), "Name")
		strImage = GetIconFullName(strIcon)
		NewExterior_PlayerFrame_FaceStyle_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_PlayerFrame_FaceStyle_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_PlayerFrame_FaceStyle_LeftBtn:SetProperty("Empty", "False")
		NewExterior_PlayerFrame_FaceStyle_LeftBtn:SetProperty("UseDefaultTooltip", "True")
		NewExterior_PlayerFrame_FaceStyle_LeftBtn:SetToolTip(strName)
	end	
	--发型
	cacheExteriorID = DataPool : Get_MyHairStyle()
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local strName 	= LuaFnGetExteriorHairInfo(cacheExteriorID, "Name")
		local strIcon 	= LuaFnGetExteriorHairInfo(cacheExteriorID, "Icon")
		local strImage = GetIconFullName(strIcon)		
		NewExterior_PlayerFrame_HairStyle_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_PlayerFrame_HairStyle_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_PlayerFrame_HairStyle_LeftBtn:SetProperty("Empty", "False")
		NewExterior_PlayerFrame_HairStyle_LeftBtn:SetProperty("UseDefaultTooltip", "True")
		NewExterior_PlayerFrame_HairStyle_LockImg:Hide()
		NewExterior_PlayerFrame_HairStyle_ActionImg:Hide()
		local strTemp = strName
		NewExterior_PlayerFrame_HairStyle_LeftBtn:SetToolTip(strTemp)
	end
	if GetGameMissionData("MD_HAIR") ~= 0 then
		NewExterior_PlayerFrame_HairStyle_LockImg:Show()
		NewExterior_PlayerFrame_HairStyle_ActionImg:Show()
		strIcon 	= LuaFnGetExteriorHairInfo(GetGameMissionData("MD_HAIR"), "Icon")
		strName 	= LuaFnGetExteriorHairInfo(GetGameMissionData("MD_HAIR"), "Name")
		strImage = GetIconFullName(strIcon)
		NewExterior_PlayerFrame_HairStyle_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_PlayerFrame_HairStyle_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_PlayerFrame_HairStyle_LeftBtn:SetProperty("Empty", "False")
		NewExterior_PlayerFrame_HairStyle_LeftBtn:SetProperty("UseDefaultTooltip", "True")
		NewExterior_PlayerFrame_HairStyle_LeftBtn:SetToolTip(strName)
	end	
	--头像
	local strHeadTip = ""
	cacheExteriorID = DataPool : Get_MyHeadStyle()
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local strName 	= LuaFnGetExteriorPortraitInfo(cacheExteriorID, "Name")
		local strIcon 	= LuaFnGetExteriorPortraitInfo(cacheExteriorID, "Icon")
		local strImage = GetIconFullName(strIcon)		
		NewExterior_PlayerFrame_PlayerFrame_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_PlayerFrame_PlayerFrame_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_PlayerFrame_PlayerFrame_LeftBtn:SetProperty("Empty", "False")
		NewExterior_PlayerFrame_PlayerFrame_LeftBtn:SetProperty("UseDefaultTooltip", "True")
		NewExterior_PlayerFrame_PlayerFrame_LockImg:Hide()
		NewExterior_PlayerFrame_PlayerFrame_ActionImg:Hide()
		local strTemp = strName
		NewExterior_PlayerFrame_PlayerFrame_LeftBtn:SetToolTip(strTemp)	
	end	
	if GetGameMissionData("MD_HEAD") ~= 0 then
		NewExterior_PlayerFrame_PlayerFrame_LockImg:Show()
		NewExterior_PlayerFrame_PlayerFrame_ActionImg:Show()
		strIcon 	= LuaFnGetExteriorPortraitInfo(GetGameMissionData("MD_HEAD"), "Icon")
		strName 	= LuaFnGetExteriorPortraitInfo(GetGameMissionData("MD_HEAD"), "Name")
		strImage = GetIconFullName(strIcon)
		NewExterior_PlayerFrame_PlayerFrame_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_PlayerFrame_PlayerFrame_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_PlayerFrame_PlayerFrame_LeftBtn:SetProperty("Empty", "False")
		NewExterior_PlayerFrame_PlayerFrame_LeftBtn:SetProperty("UseDefaultTooltip", "True")
		NewExterior_PlayerFrame_PlayerFrame_LeftBtn:SetToolTip(strName)
	end	
end

function NewExterior_PlayerFrame_UpdateList()
	local i,j,nID,ItemID,ItemCount,SelectType,IconFile,CostMoney,StyleName,TitleInfo;


	for i,eachGroup in PlayerFrameList do
		eachGroup[1] : SetPushed(0)
		eachGroup[1] : SetProperty("NormalImage","")
		eachGroup[1] : SetProperty("HoverImage","")
		eachGroup[1] : SetToolTip("")
	end

	for j,eachstyle in g_Headstyle_Icon do
		eachstyle : SetPushed(0)
		eachstyle : SetProperty("NormalImage","")
		eachstyle : SetProperty("HoverImage","")
		eachstyle : SetToolTip("")
	end

	j = 1
	for i=1, g_hsgMaxHeadNum do
		nID,ItemID,ItemCount,SelectType,IconFile,CostMoney,StyleName,TitleInfo = DataPool : Change_MyHeadStyle_Item(i, 0);			-- 获得头像组信息
		if(ItemID ~= -1) then
			g_All_Icon[j] = { IconFile = IconFile, StyleName = StyleName, Index = i ,ID = nID};
			j = j+1;
		end
	end

	g_TotalGroup = j-1;

	g_nAllPage = math.floor((g_TotalGroup - 1) / MAXGROUPSIZE) + 1

	if g_nCurPage <= 1 then
		g_nCurPage = 1
	elseif g_nCurPage >= g_nAllPage then
		g_nCurPage = g_nAllPage
	end

	if g_nCurPage == g_nAllPage then
		g_Group_Count = g_TotalGroup - (g_nCurPage - 1) * MAXGROUPSIZE
	else
		g_Group_Count = MAXGROUPSIZE
	end

	for i = 1, g_Group_Count do
		local index = (g_nCurPage - 1) * MAXGROUPSIZE + i;
		index = g_TotalGroup - index + 1
		local IccoFile = GetIconFullName(g_All_Icon[index].IconFile);
		PlayerFrameList[i][1]:SetProperty("NormalImage", IccoFile)
		PlayerFrameList[i][1]:SetProperty("HoverImage", IccoFile)
		PlayerFrameList[i][1]:SetToolTip(g_All_Icon[index].StyleName)
		PlayerFrameList[i][1]:Show()
		g_Group_Index[i] = g_All_Icon[index].Index;
		if g_hsgHaveHead[g_All_Icon[index].ID] ~= 0 then
			PlayerFrameList[i][2]:Hide()
		else
			PlayerFrameList[i][2]:Show()
		end
	end
	for i = g_Group_Count + 1, MAXGROUPSIZE do
		PlayerFrameList[i][1]:Hide()
	end

	if g_nCurPage == 1 then
		NewExterior_PlayerFrame_SuperListItemLast : Disable();
	else
		NewExterior_PlayerFrame_SuperListItemLast : Enable();
	end

	if g_nCurPage == g_nAllPage then
		NewExterior_PlayerFrame_SuperListItemNext : Disable();
	else
		NewExterior_PlayerFrame_SuperListItemNext : Enable();
	end

	if(g_Group_Count <= 0) then
		NewExterior_PlayerFrame_SuperListItemLast : Disable();
		NewExterior_PlayerFrame_SuperListItemNext : Disable();
		return;
	end
	g_nCurSelectGrp = 0
end	
	
function NewExterior_PlayerFrame_UpdateFrameList()
	
	NewExterior_PlayerFrame_UpdateCheckButton()
	NewExterior_PlayerFrame_UpdateRedPoint()
	
	LuaFnInitExteriorList(g_FrameExteriorType)
	local count = LuaFnGetExteriorListCount(g_FrameExteriorType, 0)
	
	for i = 1, g_MaxFrameNum do	
		NewExterior_PlayerFrame_SetFrameItem(i, count)
	end
	
	if g_NeedChangeFrameScrollSize == 1 then
		NewExterior_PlayerFrame_FrameList:RefreshLayout()
		g_NeedChangeFrameScrollSize = 0
	end
	
	if g_TargetFrameIndex ~= 0 then
		NewExterior_PlayerFrame_FrameList:SetScrollPosition4Index(g_TargetFrameIndex - 1)
		g_TargetFrameID = 0
		g_TargetFrameIndex = 0
	else
		NewExterior_PlayerFrame_FrameList:SetScrollPosition4Index(0)
	end

end
function NewExterior_PlayerFrame_ZoomIn()
	NewExterior_PlayerFrame_FakeObject : SetFakeObject( "Player_Head" );
end

function NewExterior_PlayerFrame_ZoomOut()
	NewExterior_PlayerFrame_FakeObject : SetFakeObject( "EquipChange_Player" );
end

function NewExterior_PlayerFrame_UpdateObj()
	NewExterior_PlayerFrame_FakeObject : SetFakeObject( "" );
	NewExterior_PlayerFrame_FakeObject : SetFakeObject( "EquipChange_Player" );		
	FakeObj_SetCamera( "EquipChange_Player", 1,1);
	FakeObj_SetCamera( "EquipChange_Player", 2,8);
	FakeObj_SetCamera( "EquipChange_Player", 3,0.28);
end

function NewExterior_PlayerFrame_UpdateOpBtn()

end

function NewExterior_PlayerFrame_ItemClicked(nIndex)
	for i = 1,35 do
		if i == nIndex  then
			PlayerFrameList[i][1]:SetPushed(1)
		else
			PlayerFrameList[i][1]:SetPushed(0)	
		end
	end
	g_nCurSelectGrp = nIndex
	local nItemIdx = 0
	local nCostMoney = 0
	local n = 1
	local GroupName = ""
	for i=1, 5 do
		local nID,ItemID,ItemCount,SelectType,IconFile,CostMoney,StyleName,TitleInfo = DataPool : Change_MyHeadStyle_Item(g_Group_Index[nIndex], i-1);
		if(ItemID ~= -1) then
			if i == 1 then
				GroupName = TitleInfo
			end
			IconFile = GetIconFullName(IconFile)
			g_Style_Index[n] = i-1
			n = n + 1
			nItemIdx = ItemID
			nCostMoney = CostMoney
		end
	end
	local nID,ItemID,ItemCount,SelectType,IconFile,CostMoney,StyleName,_ = DataPool : Change_MyHeadStyle_Item(g_Group_Index[g_nCurSelectGrp], g_Style_Index[1]);
	SetGameMissionData("MD_HEAD",nID)
	NewExterior_PlayerFrame_PlayerFrame_LockImg:Show()
	NewExterior_PlayerFrame_PlayerFrame_ActionImg:Show()
	strIcon 	= LuaFnGetExteriorPortraitInfo(nID, "Icon")
	strName 	= LuaFnGetExteriorPortraitInfo(nID, "Name")
	strImage = GetIconFullName(strIcon)
	NewExterior_PlayerFrame_PlayerFrame_LeftBtn:SetProperty("NormalImage", strImage)
	NewExterior_PlayerFrame_PlayerFrame_LeftBtn:SetProperty("HoverImage", strImage)
	NewExterior_PlayerFrame_PlayerFrame_LeftBtn:SetProperty("Empty", "False")
	NewExterior_PlayerFrame_PlayerFrame_LeftBtn:SetToolTip(strName)	
	if nItemIdx <= 0 or nCostMoney <= 0 then
		return 0
	end		
end

function NewExterior_PlayerFrame_ItemMouseMove(nIndex)

end

function NewExterior_PlayerFrame_SetItemSelected(nIndex)
	for i = 1, g_MaxBarNum do		
		if g_BarList[i] ~= nil then	
			local ctrlAction = g_BarList[i]:GetSubItem("NewExterior_PlayerFrame_SuperListItemAction")
			if ctrlAction ~= nil then
				if i == nIndex then
					ctrlAction:SetPushed(1)
					g_BarList[i]:GetSubItem("NewExterior_PlayerFrame_SuperListItemActionTry"):Show()
					if LuaFnGetExteriorInUse(g_ExteriorType) == g_CurSelExteriorID then
						g_BarList[i]:GetSubItem("NewExterior_PlayerFrame_SuperListItemActionTry"):Hide()
					end
				else
					ctrlAction:SetPushed(0)	
					g_BarList[i]:GetSubItem("NewExterior_PlayerFrame_SuperListItemActionTry"):Hide()
				end
			end
		end
	end
end

function NewExterior_PlayerFrame_FrameClicked(nIndex)
	local nExteriorID = LuaFnGetExteriorIDFromList(g_FrameExteriorType, nIndex - 1)	
	if g_CurSelFrameID ~= nExteriorID then
		g_CurSelFrameID = nExteriorID
		LuaFnSetCurrentExteriorSetInfo("FRAME", g_CurSelFrameID)
		
		NewExterior_PlayerFrame_SetFrameSelected(nIndex)
	--	NewExterior_PlayerFrame_UpdateObj()
	
		NewExterior_PlayerFrame_UpdateLeftBtn()

	NewExterior_PlayerFrame_RemoveFrameTip(g_CurSelFrameID)
		NewExterior_PlayerFrame_UpdateRedPoint()
	else
		local defExteriorID = LuaFnGetExteriorInUse(g_FrameExteriorType)
		LuaFnSetCurrentExteriorSetInfo("FRAME", defExteriorID)
		
		g_CurSelFrameID = defExteriorID
		NewExterior_PlayerFrame_UpdateFrameList()	
		NewExterior_PlayerFrame_UpdateLeftBtn()	
	end	

end

function NewExterior_PlayerFrame_TryExterior()
	SaveAllChange()
	NewExterior_PlayerFrame_RemovePreview()
end
	
function NewExterior_PlayerFrame_TakeOffRide()
   Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("RideSysteam");
		Set_XSCRIPT_ScriptID(830243);
		Set_XSCRIPT_Parameter(0,13);
		Set_XSCRIPT_ParamCount(1);
    Send_XSCRIPT();	
	NewExterior_PlayerFrame_Ride_LeftBtn:SetProperty("PushedImage", "")
	NewExterior_PlayerFrame_Ride_LeftBtn:SetProperty("NormalImage", "")
	NewExterior_PlayerFrame_Ride_LeftBtn:SetProperty("HoverImage", "")
	NewExterior_PlayerFrame_Ride_LeftBtn:SetToolTip("")
end

function NewExterior_PlayerFrame_TakeOffWeapon()
   Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("RideSysteam");
		Set_XSCRIPT_ScriptID(830243);
		Set_XSCRIPT_Parameter(0,12);
		Set_XSCRIPT_ParamCount(1);
    Send_XSCRIPT();	
	NewExterior_PlayerFrame_Weapon_LeftBtn:SetProperty("PushedImage", "")
	NewExterior_PlayerFrame_Weapon_LeftBtn:SetProperty("NormalImage", "")
	NewExterior_PlayerFrame_Weapon_LeftBtn:SetProperty("HoverImage", "")
	NewExterior_PlayerFrame_Weapon_LeftBtn:SetToolTip("")
end

function NewExterior_PlayerFrame_RemovePreview()
	ClearSaveAllChange()
	NewExterior_PlayerFrame_Show()
end

function NewExterior_PlayerFrame_Goto()
	PushDebugMessage("请前往洛阳（252，130）#R颜如玉#I处")
end

function NewExterior_PlayerFrame_CloseClick()	
	NewExterior_PlayerFrame_FakeObject : SetFakeObject( "" );
	NewExterior_PlayerFrame_SavePosition()
	this:Hide()
end

function NewExterior_PlayerFrame_OnHidden()
	NewExterior_PlayerFrame_FakeObject : SetFakeObject( "" );
	if IsWindowShow("NewExterior_DressBox") 
		or IsWindowShow("NewExterior_Ride") 
		or IsWindowShow("NewExterior_Weapon") 
		or IsWindowShow("NewExterior_PetPossJian")
		or IsWindowShow("NewExterior_Facestyle") 
		or IsWindowShow("NewExterior_HairStyle") then
	end	
end
function NewExterior_PlayerFrame_CleanUp_LeftButton()	
	
	
	local ctrl_list = {
		[1] = NewExterior_PlayerFrame_Weapon_LeftBtn,
		[2] = NewExterior_PlayerFrame_PetPossJian_LeftBtn,
		[3] = NewExterior_PlayerFrame_FaceStyle_LeftBtn,
		[4] = NewExterior_PlayerFrame_HairStyle_LeftBtn,
		[5] = NewExterior_PlayerFrame_PlayerFrame_LeftBtn,
		[6] = NewExterior_PlayerFrame_Ride_LeftBtn,	
	}
	
	for i = 1 ,6 do
		ctrl_list[i]:SetProperty("Empty", "False")
		ctrl_list[i]:SetProperty("UseDefaultTooltip", "True")
		ctrl_list[i]:SetProperty("NormalImage", "")
		ctrl_list[i]:SetProperty("HoverImage", "")
		ctrl_list[i]:SetToolTip("")
	end
	
	NewExterior_PlayerFrame_PlayerFrame_Mask:SetProperty("Image", "")
	
	NewExterior_PlayerFrame_Dress_ActionImg:Hide()
	NewExterior_PlayerFrame_Weapon_ActionImg:Hide()
	NewExterior_PlayerFrame_PetPossJian_ActionImg:Hide()
	NewExterior_PlayerFrame_FaceStyle_ActionImg:Hide()
	NewExterior_PlayerFrame_HairStyle_ActionImg:Hide()
	NewExterior_PlayerFrame_PlayerFrame_ActionImg:Hide()
	NewExterior_PlayerFrame_Ride_ActionImg:Hide()
	
	NewExterior_PlayerFrame_Dress_LockImg:Hide()
	NewExterior_PlayerFrame_Weapon_LockImg:Hide()
	NewExterior_PlayerFrame_PetPossJian_LockImg:Hide()
	NewExterior_PlayerFrame_FaceStyle_LockImg:Hide()
	NewExterior_PlayerFrame_HairStyle_LockImg:Hide()
	NewExterior_PlayerFrame_PlayerFrame_LockImg:Hide()
	NewExterior_PlayerFrame_Ride_LockImg:Hide()
end

function NewExterior_PlayerFrame_FakeObject_TurnLeft(idx)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		--向左旋转开始
		if(idx == 1) then
			NewExterior_PlayerFrame_FakeObject:RotateBegin(-0.3);
		--向左旋转结束
		else
			NewExterior_PlayerFrame_FakeObject:RotateEnd();
		end
	end
end

function NewExterior_PlayerFrame_FakeObject_TurnRight(idx)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		--向右旋转开始
		if(idx == 1) then
			NewExterior_PlayerFrame_FakeObject:RotateBegin(0.3);
		--向右旋转结束
		else
			NewExterior_PlayerFrame_FakeObject:RotateEnd();
		end
	end
end

--右键取下时装
function NewExterior_PlayerFrame_ActionToDressBox()
	LuaFnExteriorFashionDepotItemClick()
end
--时装
function NewExterior_PlayerFrame_OpenFashion()
	NewExterior_PlayerFrame_SavePosition()
	LuaFnAskOpenExterior(1)
end
--幻武
function NewExterior_PlayerFrame_OpenWeapon()
	NewExterior_PlayerFrame_SavePosition()
	LuaFnAskOpenExterior(2)
end
--附体
function NewExterior_PlayerFrame_OpenPoss()
	NewExterior_PlayerFrame_SavePosition()
	LuaFnAskOpenExterior(6)
end
--坐骑
function NewExterior_PlayerFrame_OpenRide()
	NewExterior_PlayerFrame_SavePosition()
	LuaFnAskOpenExterior(3)
end
--发型
function NewExterior_PlayerFrame_OpenHair()
	NewExterior_PlayerFrame_SavePosition()	
	LuaFnAskOpenExterior(5)
end
--脸型
function NewExterior_PlayerFrame_OpenFace()
	NewExterior_PlayerFrame_SavePosition()	
	LuaFnAskOpenExterior(4)
end
--头像
function NewExterior_PlayerFrame_OpenPortrait()
end

function NewExterior_PlayerFrame_OpenInfant()
end

function NewExterior_PlayerFrame_CloseSameGroupWindow()
	CloseWindow("SelfEquip", true)
	CloseWindow("NewExterior_Ride", true)
	CloseWindow("NewExterior_Weapon", true)
	CloseWindow("NewExterior_PetPossJian", true)
	CloseWindow("NewExterior_Facestyle", true)
	CloseWindow("NewExterior_HairStyle", true)
	CloseWindow("NewExterior_DressBox", true)
end

function NewExterior_PlayerFrame_SavePosition()
	NewExterior_PlayerFrame_FakeObject:SetFakeObject("")
	Variable:SetVariable("ExteriorUnionPos", NewExterior_PlayerFrame_Frame:GetProperty("UnifiedPosition"), 1)
end

function NewExterior_PlayerFrame_SetPosition()
	local nExteriorUnionPos = Variable:GetVariable("ExteriorUnionPos")
	if nExteriorUnionPos ~= nil then
		NewExterior_PlayerFrame_Frame:SetProperty("UnifiedPosition", nExteriorUnionPos)
	end
end

function NewExterior_PlayerFrame_ShowFashionWeaponCheckButton()

end

function NewExterior_PlayerFrame_FashionDisplay()

end

function NewExterior_PlayerFrame_ExteriorWeaponDisplay()

end


--!!!reloadscript =NewExterior_PlayerFrame