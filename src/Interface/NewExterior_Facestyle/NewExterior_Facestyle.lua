--!!!reloadscript =NewExterior_Facestyle
local g_NewExterior_Facestyle_UnifiedPosition = ""

local EXTERIORFILTTING_TOTALKIND = 6;
local g_TargetExteriorIndex = 0		--定位的外观索引，从1开始
local g_TargetExteriorID = 0			--定位的外观ID
local g_DecoWeapon_Display = 0
local g_CurSelExteriorID = 0			--当前选择的外观ID，从1开始
local g_nCurSelect = 0
local g_NeedChangeScrollSize = 1
local MAX_STYLE = 279
local STYLE_PAGE_BUTTON = 35				-- 每页多少个图标
local g_nCurPage = 0								-- 当前选择的图标在第几页
local g_Distance = 1
local g_Distance_Ori = 4
local g_Distance_Max = 4
local g_InitList = 0
local g_ExteriorType = 3 --脸型
local g_MaxBarNum = 0
local g_BarList = {}
local g_Style_Count = 0							-- 实际上有多少个脸型可供选择
local g_Face_SuperListItem = {}
local g_Original_Style = 0
local g_OldStyle = 0
local g_CameraPosition =
{
	--女性相关位置
	[0] = {{fHeight = 0.85, fDistance = 12, fPitch=0.2}, {fHeight = 0.85, fDistance = 7.2, fPitch=0.2}, {fHeight = 1.55, fDistance = 2.5, fPitch=0.20}, {fHeight = 1.55, fDistance = 1.7, fPitch=0.20}},
	--男性相关位置
	[1] = {{fHeight = 0.85, fDistance = 12, fPitch=0.28}, {fHeight = 0.85, fDistance = 7.5, fPitch=0.28}, {fHeight = 1.65, fDistance = 2.7, fPitch=0.28}, {fHeight = 1.70, fDistance = 1.9, fPitch=0.28}},
}
local g_Face_ListItem = {}
--=========
--PreLoad==
--=========
function NewExterior_Facestyle_PreLoad()
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
function NewExterior_Facestyle_OnLoad()
	g_NewExterior_Facestyle_UnifiedPosition = NewExterior_Facestyle_Frame:GetProperty("UnifiedPosition")
	for i = 1,35 do
		table.insert(g_Face_SuperListItem,{LockImg = _G[string.format("NewExterior_Facestyle_PlayerFrame_LockImg_%d",i)],Button = _G[string.format("NewExterior_Facestyle_SuperListItemAction_%d",i)],ActionTry = _G[string.format("NewExterior_Facestyle_SuperListItemActionTry_%d",i)],ActionEqu = _G[string.format("NewExterior_Facestyle_SuperListItemActionEqu_%d",i)]})
	end		
end
--=========
--OnEvent
--=========
function NewExterior_Facestyle_OnEvent(event)
	if event == "UI_COMMAND" and tonumber(arg0) == 2350111 then
		NewExterior_Facestyle_FakeObject:SetFakeObject("")
	end
	if event == "UI_COMMAND" and tonumber(arg0) == 9900141 then
		SetGameMissionData("MD_EXTERIOR",4)
		if(IsWindowShow("SelectFacestyle")) then
			CloseWindow("SelectFacestyle", true);
		end	
		if(IsWindowShow("SelectHairColor")) then
			CloseWindow("SelectHairColor", true);
		end	
		if(IsWindowShow("SelectHairstyle")) then
			CloseWindow("SelectHairstyle", true);
		end	
		if(IsWindowShow("NewExterior_HairStyle")) then
			CloseWindow("NewExterior_HairStyle", true);
		end	
		if(IsWindowShow("NewExterior_DressBox")) then
			CloseWindow("NewExterior_DressBox", true);
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
		if(IsWindowShow("NewExterior_PetSoul")) then
			CloseWindow("NewExterior_PetSoul", true);
		end	
		if(IsWindowShow("Shop_Dresser")) then
			CloseWindow("Shop_Dresser", true);
		end
		if(this:IsVisible() and tonumber(g_Original_Style)) then
			DataPool : Change_MyFaceStyle(g_Original_Style);
		end		
		MAX_STYLE = Get_XParam_INT(0)
		g_Face_ListItem = {}
		local nFaceData = Get_XParam_STR(0)
		for i = 1,MAX_STYLE do
			local nFaceHave = string.sub(nFaceData,i,i)
			table.insert(g_Face_ListItem,tonumber(nFaceHave))
		end
		NewExterior_Facestyle_SetPosition()
		NewExterior_Facestyle_CloseSameGroupWindow()
		this:Show()
		NewExterior_Facestyle_Show()
		return
	end
	-- 头像信息改变
	if( (event == "UNIT_FACE_IMAGE") and (arg0 == "player") ) then
		if GetGameMissionData("MD_EXTERIOR") == 5 then
			NewExterior_Facestyle_Show()
		end		
		return;
	end
	if event == "UI_COMMAND" and tonumber(arg0) == 122032413 then
		if GetGameMissionData("MD_EXTERIOR") == 4 then
			NewExterior_Facestyle_Show()
		end
		return
	end	
	if event == "UI_COMMAND" and tonumber(arg0) == 1000000037 then
		NewExterior_Facestyle_Weapon_Type:SetCheck(Get_XParam_INT(0))
		return
	end	
	if event == "ON_SCENE_TRANS" or event == "ON_SERVER_TRANS" or event == "HIDE_ON_SCENE_TRANSED" then
		this:Hide()
	end
	-- 游戏窗口尺寸发生了变化 or 游戏分辨率发生了变化
	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		NewExterior_Facestyle_Frame:SetProperty("UnifiedPosition", g_NewExterior_Facestyle_UnifiedPosition)
	end
end

function NewExterior_Facestyle_Show()
	-- 得到当前的脸型
	g_Original_Style = DataPool : Get_MyFaceStyle();
	g_OldStyle = g_Original_Style
	for i = 1,35 do
		g_Face_SuperListItem[i].Button:SetProperty("Empty","False")
		g_Face_SuperListItem[i].Button:SetProperty("UseDefaultTooltip","True")
		g_Face_SuperListItem[i].ActionTry:Hide()
		g_Face_SuperListItem[i].ActionEqu:Hide()
	end
	--列表
	NewExterior_Facestyle_UpdateList()
	--左侧
	NewExterior_Facestyle_UpdateLeftBtn()
end

function NewExterior_Facestyle_UpdateLeftBtn()
	--时装
	if GetGameMissionData("MD_DRESS") ~= 0 then
		NewExterior_Facestyle_Dress_LockImg:Show()
		NewExterior_Facestyle_Dress_ActionImg:Show()
		local _,Icons = LifeAbility : GetPrescr_Material(GetGameMissionData("MD_DRESS"))
		local strImage = GetIconFullName(Icons)
		NewExterior_Facestyle_Dress_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_Facestyle_Dress_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_Facestyle_Dress_LeftBtn:SetProperty("PushedImage", strImage)
		NewExterior_Facestyle_Dress_LeftBtn:SetProperty("Empty", "False")
		NewExterior_Facestyle_Dress_LeftBtn:SetProperty("UseDefaultTooltip", "False")
	else
		NewExterior_Facestyle_Dress_LeftBtn:SetProperty("NormalImage", "")
		NewExterior_Facestyle_Dress_LeftBtn:SetProperty("HoverImage", "")
		NewExterior_Facestyle_Dress_LeftBtn:SetProperty("PushedImage", "")
		local theAction = EnumAction(2, "equip");
		NewExterior_Facestyle_Dress_LeftBtn:SetActionItem(theAction:GetID())
		NewExterior_Facestyle_Dress_LockImg:Hide()
		NewExterior_Facestyle_Dress_ActionImg:Hide()	
	end	
	--坐骑
	theAction = DataPool:GetPlayerMission_DataRound(362)
	NewExterior_Facestyle_Ride_LockImg:Hide()
	NewExterior_Facestyle_Ride_ActionImg:Hide()
	if theAction ~= 0 then
		local strIcon = LuaFnGetExteriorRideInfo(theAction,"Icon")
		local strImage = GetIconFullName(strIcon)
		local strName 	= LuaFnGetExteriorRideInfo(theAction, "Name")
		NewExterior_Facestyle_Ride_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_Facestyle_Ride_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_Facestyle_Ride_LeftBtn:SetProperty("Empty", "False")
		NewExterior_Facestyle_Ride_LeftBtn:SetProperty("UseDefaultTooltip", "True")
		NewExterior_Facestyle_Ride_LeftBtn:SetToolTip(strName)
	else
		NewExterior_Facestyle_Ride_LeftBtn:SetProperty("NormalImage", "")
		NewExterior_Facestyle_Ride_LeftBtn:SetProperty("HoverImage", "")
		NewExterior_Facestyle_Ride_LeftBtn:SetToolTip("")
	end
	if GetGameMissionData("MD_RIDA") ~= 0 then
		NewExterior_Facestyle_Ride_LockImg:Show()
		NewExterior_Facestyle_Ride_ActionImg:Show()
		strIcon 	= LuaFnGetExteriorRideInfo(GetGameMissionData("MD_RIDA"), "Icon")
		strImage = GetIconFullName(strIcon)
		strName 	= LuaFnGetExteriorRideInfo(GetGameMissionData("MD_RIDA"), "Name")
		NewExterior_Facestyle_Ride_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_Facestyle_Ride_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_Facestyle_Ride_LeftBtn:SetToolTip(strName)
	end					
	--幻武
	cacheExteriorID = DataPool:GetPlayerMission_DataRound(389)
	if cacheExteriorID ~= 0 then
		local strName 	= LuaFnGetExteriorWeaponInfo(cacheExteriorID, "Name")
		local strIcon 	= LuaFnGetExteriorWeaponInfo(cacheExteriorID, "Icon")
		local strImage = GetIconFullName(strIcon)
		NewExterior_Facestyle_Weapon_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_Facestyle_Weapon_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_Facestyle_Weapon_LeftBtn:SetProperty("Empty", "False")
		NewExterior_Facestyle_Weapon_LeftBtn:SetProperty("UseDefaultTooltip", "True")
		local strTemp = strName
		NewExterior_Facestyle_Weapon_LeftBtn:SetToolTip(strTemp)
	else
		NewExterior_Facestyle_Weapon_LeftBtn:SetProperty("HoverImage", "")
		NewExterior_Facestyle_Weapon_LeftBtn:SetProperty("NormalImage", "")
	end
	NewExterior_Facestyle_Weapon_ActionImg:Hide()
	NewExterior_Facestyle_Weapon_LockImg:Hide()
	if GetGameMissionData("MD_WEAPON") > 0 then
		NewExterior_Facestyle_Weapon_ActionImg:Show()
		NewExterior_Facestyle_Weapon_LockImg:Show()
		strIcon 	= LuaFnGetExteriorWeaponInfo(GetGameMissionData("MD_WEAPON"), "Icon")
		strName 	= LuaFnGetExteriorWeaponInfo(GetGameMissionData("MD_WEAPON"), "Name")
		strImage = GetIconFullName(strIcon)
		NewExterior_Facestyle_Weapon_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_Facestyle_Weapon_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_Facestyle_Weapon_LeftBtn:SetToolTip(strName)
	end		
	-- 附体
	cacheExteriorID = DataPool:GetPlayerMission_DataRound(387)
	if cacheExteriorID > 0 then
		local strName,iQual,iBloodRank,curPetSoulid,strIcon = NewExterior_PetSoul_DataShow(cacheExteriorID)
		strImage = GetIconFullName(strIcon)
		NewExterior_Facestyle_PetSoul_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_Facestyle_PetSoul_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_Facestyle_PetSoul_LeftBtn:SetToolTip(strName)
		NewExterior_Facestyle_PetSoul_LeftBtn:SetProperty("Empty", "False")
		NewExterior_Facestyle_PetSoul_LeftBtn:SetProperty("UseDefaultTooltip", "True")
	end
	NewExterior_Facestyle_PetSoul_LockImg:Hide()
	NewExterior_Facestyle_PetSoul_ActionImg:Hide()
	local TryPoss = GetGameMissionData("MD_PETPOSS")
	if TryPoss ~= 0 then
		TryPoss = math.mod(TryPoss,100)
		local strName,strIcon,iQual = LuaFnGetExteriorPossInfo(TryPoss)
		strImage = GetIconFullName(strIcon)
		NewExterior_Facestyle_PetSoul_LockImg:Show()
		NewExterior_Facestyle_PetSoul_ActionImg:Show()
		NewExterior_Facestyle_PetSoul_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_Facestyle_PetSoul_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_Facestyle_PetSoul_LeftBtn:SetToolTip(strName)
		NewExterior_Facestyle_PetSoul_LeftBtn:SetProperty("Empty", "False")
		NewExterior_Facestyle_PetSoul_LeftBtn:SetProperty("UseDefaultTooltip", "True")
	end
	--脸型
	cacheExteriorID = DataPool:Get_MyFaceStyle()
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local _,_,_,IconFile,_,StyleName = DataPool : Change_MyFaceStyle_Item(cacheExteriorID);
		local strImage = GetIconFullName(IconFile)		
		NewExterior_Facestyle_FaceStyle_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_Facestyle_FaceStyle_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_Facestyle_FaceStyle_LeftBtn:SetProperty("Empty", "False")
		NewExterior_Facestyle_FaceStyle_LeftBtn:SetProperty("UseDefaultTooltip", "True")
		NewExterior_Facestyle_FaceStyle_LockImg:Hide()
		NewExterior_Facestyle_FaceStyle_ActionImg:Hide()
		local strTemp = StyleName
		NewExterior_Facestyle_FaceStyle_LeftBtn:SetToolTip(strTemp)
	end
	if GetGameMissionData("MD_FACE") ~= 0 then
		NewExterior_Facestyle_FaceStyle_LockImg:Show()
		NewExterior_Facestyle_FaceStyle_ActionImg:Show()
		-- strIcon 	= LuaFnGetExteriorFaceInfo(GetGameMissionData("MD_FACE"), "Icon")
		-- strName 	= LuaFnGetExteriorFaceInfo(GetGameMissionData("MD_FACE"), "Name")
		local _,_,_,IconFile,_,StyleName = DataPool : Change_MyFaceStyle_Item(GetGameMissionData("MD_FACE"));
		strImage = GetIconFullName(IconFile)
		NewExterior_Facestyle_FaceStyle_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_Facestyle_FaceStyle_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_Facestyle_FaceStyle_LeftBtn:SetProperty("PushedImage", strImage)
		NewExterior_Facestyle_FaceStyle_LeftBtn:SetToolTip(StyleName)
	end	
	--发型
	cacheExteriorID = DataPool : Get_MyHairStyle()
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local strName 	= LuaFnGetExteriorHairInfo(cacheExteriorID, "Name")
		local strIcon 	= LuaFnGetExteriorHairInfo(cacheExteriorID, "Icon")
		local strImage = GetIconFullName(strIcon)		
		NewExterior_Facestyle_HairStyle_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_Facestyle_HairStyle_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_Facestyle_HairStyle_LeftBtn:SetProperty("Empty", "False")
		NewExterior_Facestyle_HairStyle_LeftBtn:SetProperty("UseDefaultTooltip", "True")
		NewExterior_Facestyle_HairStyle_LockImg:Hide()
		NewExterior_Facestyle_HairStyle_ActionImg:Hide()
		local strTemp = strName
		NewExterior_Facestyle_HairStyle_LeftBtn:SetToolTip(strTemp)
	end
	if GetGameMissionData("MD_HAIR") ~= 0 then
		NewExterior_Facestyle_HairStyle_LockImg:Show()
		NewExterior_Facestyle_HairStyle_ActionImg:Show()
		strIcon 	= LuaFnGetExteriorHairInfo(GetGameMissionData("MD_HAIR"), "Icon")
		strName 	= LuaFnGetExteriorHairInfo(GetGameMissionData("MD_HAIR"), "Name")
		strImage = GetIconFullName(strIcon)
		NewExterior_Facestyle_HairStyle_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_Facestyle_HairStyle_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_Facestyle_HairStyle_LeftBtn:SetProperty("Empty", "False")
		NewExterior_Facestyle_HairStyle_LeftBtn:SetProperty("UseDefaultTooltip", "True")
		NewExterior_Facestyle_HairStyle_LeftBtn:SetToolTip(strName)
	end	
	--头像
	local strHeadTip = ""
	cacheExteriorID = DataPool : Get_MyHeadStyle()
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local strName 	= LuaFnGetExteriorPortraitInfo(cacheExteriorID, "Name")
		local strIcon 	= LuaFnGetExteriorPortraitInfo(cacheExteriorID, "Icon")
		local strImage = GetIconFullName(strIcon)		
		NewExterior_Facestyle_PlayerFrame_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_Facestyle_PlayerFrame_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_Facestyle_PlayerFrame_LeftBtn:SetProperty("Empty", "False")
		NewExterior_Facestyle_PlayerFrame_LeftBtn:SetProperty("UseDefaultTooltip", "True")
		NewExterior_Facestyle_PlayerFrame_LockImg:Hide()
		NewExterior_Facestyle_PlayerFrame_ActionImg:Hide()
		local strTemp = strName
		NewExterior_Facestyle_PlayerFrame_LeftBtn:SetToolTip(strTemp)	
	end	
	if GetGameMissionData("MD_HEAD") ~= 0 then
		NewExterior_Facestyle_PlayerFrame_LockImg:Show()
		NewExterior_Facestyle_PlayerFrame_ActionImg:Show()
		strIcon 	= LuaFnGetExteriorPortraitInfo(GetGameMissionData("MD_HEAD"), "Icon")
		strName 	= LuaFnGetExteriorPortraitInfo(GetGameMissionData("MD_HEAD"), "Name")
		strImage = GetIconFullName(strIcon)
		NewExterior_Facestyle_PlayerFrame_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_Facestyle_PlayerFrame_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_Facestyle_PlayerFrame_LeftBtn:SetProperty("Empty", "False")
		NewExterior_Facestyle_PlayerFrame_LeftBtn:SetProperty("UseDefaultTooltip", "True")
		NewExterior_Facestyle_PlayerFrame_LeftBtn:SetToolTip(strName)
	end	
end
--=========================================
--翻页
--=========================================
function NewExterior_Facestyle_Page(nPage)
	g_nCurPage = g_nCurPage + nPage;
	NewExterior_Facestyle_UpdateList();
end

function NewExterior_Facestyle_UpdateList()
	for i = 1,35 do
		g_Face_SuperListItem[i].Button:SetProperty("NormalImage", "")
		g_Face_SuperListItem[i].Button:SetProperty("HoverImage", "")
		g_Face_SuperListItem[i].Button:Hide()
	end
	local i;
	local k = 1;	
	for i=0, MAX_STYLE do		
		local ItemID,ItemCount,SelectType,IconFile,CostMoney,StyleName = DataPool : Change_MyFaceStyle_Item(i);
		
		-- ItemID == -1，说明Change_MyFaceStyle_Item()函数返回的脸型信息的性别与当前角色不一致。这里只需要和当前角色性别一样的脸型数据。
		-- SelectType == 2，只有在游戏中可选的脸型；SelectType == 3，游戏中、初始时都可选的脸型
		if(ItemID ~= -1 and SelectType >= 2) then
			if k > STYLE_PAGE_BUTTON * (g_nCurPage) and k <= STYLE_PAGE_BUTTON * (g_nCurPage+1) then
				local m = k - STYLE_PAGE_BUTTON * (g_nCurPage);
				IconFile = GetIconFullName(IconFile)
				g_Face_SuperListItem[m].Button:SetProperty("NormalImage",IconFile)
				g_Face_SuperListItem[m].Button:SetProperty("HoverImage",IconFile)
				g_Face_SuperListItem[m].Button:SetToolTip(StyleName)
				g_Face_SuperListItem[m].Button:Show()
				if DataPool:Get_MyFaceStyle() == m then
					g_Face_SuperListItem[m].ActionEqu:Show()
				end
				if g_Face_ListItem[i] == 1 then
					g_Face_SuperListItem[m].LockImg:Hide()
				else
					g_Face_SuperListItem[m].LockImg:Show()
				end
				g_Style_Index[m] = i;
			end
			k = k+1
		end
	end	
	-- 记录表格中总共有多少个脸型
	g_Style_Count = k-1
	if(g_Style_Count <= 0) then
		return;
	end	
	NewExterior_Facestyle_FakeObject : SetFakeObject( "" );
	NewExterior_Facestyle_FakeObject : SetFakeObject( "Player_Head" );
end

function NewExterior_Facestyle_UpdateObj()	
	local cacheExteriorID = LuaFnGetCurrentExteriorSetInfo("FACE")
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then			
		LuaFnUpdateExteriorAvatarFace(cacheExteriorID)		
		LuaFnUpdateExteriorPlayerData()
		NewExterior_Facestyle_UpdateCamera()
	end		
end
		
function NewExterior_Facestyle_UpdateOpBtn()	

end

function NewExterior_Facestyle_ItemClicked(nIndex)
	for i = 1,35 do
		g_Face_SuperListItem[i].ActionTry:Hide()
	end
	-- 选中无效图标时的处理
	if ((nIndex < 0) or (nIndex + STYLE_PAGE_BUTTON * (g_nCurPage) > g_Style_Count))  then
		g_HaveChange = 0
		if(g_nCurSelect > 0 )then
			g_Face_SuperListItem[g_nCurSelect].Button:SetPushed(0);
		end
		g_nCurSelect = 0
		DataPool : Change_MyFaceStyle(g_Original_Style);
		return
	end
	for i = 1,35 do
		g_Face_SuperListItem[i].Button:SetPushed(0)
	end
	if(g_nCurSelect > 0 )then
		g_Face_SuperListItem[nIndex].Button:SetPushed(0);
	end
	g_nCurSelect = nIndex
	g_Face_SuperListItem[nIndex].Button:SetPushed(1);
	g_Face_SuperListItem[nIndex].ActionTry:Show();
	local ItemID,ItemCount,SelectType,IconFile,CostMoney,strName = DataPool : Change_MyFaceStyle_Item(g_Style_Index[nIndex]);
	local name,icon = LifeAbility : GetPrescr_Material(ItemID);
	DataPool : Change_MyFaceStyle(g_Style_Index[nIndex])
	g_HaveChange = 1
	SetGameMissionData("MD_FACE",g_Style_Index[nIndex])
	--试穿切换
	-- local strName 	= LuaFnGetExteriorFaceInfo(g_Style_Index[nIndex], "Name")
	-- local strIcon 	= LuaFnGetExteriorFaceInfo(g_Style_Index[nIndex], "Icon")
	local strImage = GetIconFullName(IconFile)		
	NewExterior_Facestyle_FaceStyle_LeftBtn:SetProperty("NormalImage", strImage)
	NewExterior_Facestyle_FaceStyle_LeftBtn:SetProperty("HoverImage", strImage)
	NewExterior_Facestyle_FaceStyle_LeftBtn:SetToolTip(strName)
	NewExterior_Facestyle_FaceStyle_LockImg:Show()
	NewExterior_Facestyle_FaceStyle_ActionImg:Show()
end

function NewExterior_Facestyle_ItemMouseMove(nIndex)

end

function NewExterior_Facestyle_SetItemSelected(nIndex)
	for i = 1, g_MaxBarNum do		
		if g_BarList[i] ~= nil then	
			local ctrlAction = g_BarList[i]:GetSubItem("NewExterior_Facestyle_SuperListItemAction")
			if ctrlAction ~= nil then
				if i == nIndex then
					ctrlAction:SetPushed(1)
					g_BarList[i]:GetSubItem("NewExterior_Facestyle_SuperListItemActionTry"):Show()
					if LuaFnGetExteriorInUse(g_ExteriorType) == g_CurSelExteriorID then
						g_BarList[i]:GetSubItem("NewExterior_Facestyle_SuperListItemActionTry"):Hide()
					end
				else
					ctrlAction:SetPushed(0)	
					g_BarList[i]:GetSubItem("NewExterior_Facestyle_SuperListItemActionTry"):Hide()
				end
			end
		end
	end
end

function NewExterior_Facestyle_TryExterior()
	SaveAllChange()
	NewExterior_Facestyle_RemovePreview()
end

function NewExterior_Facestyle_TakeOffRide()
    Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("RideSysteam");
		Set_XSCRIPT_ScriptID(830243);
		Set_XSCRIPT_Parameter(0,13);
		Set_XSCRIPT_ParamCount(1);
    Send_XSCRIPT();	
	NewExterior_Facestyle_Ride_LeftBtn:SetProperty("PushedImage", "")
	NewExterior_Facestyle_Ride_LeftBtn:SetProperty("NormalImage", "")
	NewExterior_Facestyle_Ride_LeftBtn:SetProperty("HoverImage", "")
	NewExterior_Facestyle_Ride_LeftBtn:SetToolTip("")	
end

function NewExterior_Facestyle_TakeOffWeapon()
    Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("RideSysteam");
		Set_XSCRIPT_ScriptID(830243);
		Set_XSCRIPT_Parameter(0,12);
		Set_XSCRIPT_ParamCount(1);
    Send_XSCRIPT();	
	NewExterior_Facestyle_Weapon_LeftBtn:SetProperty("PushedImage", "")
	NewExterior_Facestyle_Weapon_LeftBtn:SetProperty("NormalImage", "")
	NewExterior_Facestyle_Weapon_LeftBtn:SetProperty("HoverImage", "")
	NewExterior_Facestyle_Weapon_LeftBtn:SetToolTip("")	
end
function NewExterior_Facestyle_ZoomIn()
	NewExterior_Facestyle_FakeObject : SetFakeObject( "Player_Head" );
end

function NewExterior_Facestyle_ZoomOut()
	NewExterior_Facestyle_FakeObject : SetFakeObject( "EquipChange_Player" );
end

function NewExterior_Facestyle_RemovePreview()
	ClearSaveAllChange()
	NewExterior_Facestyle_Show()
end

function NewExterior_Facestyle_Goto()
	PushDebugMessage("请前往洛阳（252，130）#R颜如玉#I处")
end

function NewExterior_Facestyle_CloseClick()
	DataPool:Change_MyFaceStyle(g_Original_Style);
	NewExterior_Facestyle_FakeObject : SetFakeObject( "" );
	NewExterior_Facestyle_SavePosition()
	this:Hide()
end

function NewExterior_Facestyle_OnHidden()
	NewExterior_Facestyle_FakeObject : SetFakeObject( "" );
	DataPool:Change_MyFaceStyle(g_Original_Style);
	if IsWindowShow("NewExterior_DressBox") 
		or IsWindowShow("NewExterior_Ride") 
		or IsWindowShow("NewExterior_Weapon")  
		or IsWindowShow("NewExterior_PetPossJian")
		or IsWindowShow("NewExterior_HairStyle") 
		or IsWindowShow("NewExterior_PlayerFrame") then
	end	
end
function NewExterior_Facestyle_CleanUp_LeftButton()
	
	NewExterior_Facestyle_Dress_LeftBtn:SetActionItem(-1)
	
	local ctrl_list = {
		[1] = NewExterior_Facestyle_Weapon_LeftBtn,
		[2] = NewExterior_Facestyle_PetPossJian_LeftBtn,
		[3] = NewExterior_Facestyle_FaceStyle_LeftBtn,
		[4] = NewExterior_Facestyle_HairStyle_LeftBtn,
		[5] = NewExterior_Facestyle_PlayerFrame_LeftBtn,
		[6] = NewExterior_Facestyle_Ride_LeftBtn,	
	}
	
	for i = 1 ,6 do
		ctrl_list[i]:SetProperty("Empty", "False")
		ctrl_list[i]:SetProperty("UseDefaultTooltip", "True")
		ctrl_list[i]:SetProperty("NormalImage", "")
		ctrl_list[i]:SetProperty("HoverImage", "")
		ctrl_list[i]:SetToolTip("")
	end
	
	NewExterior_Facestyle_PlayerFrame_Mask:SetProperty("Image", "")
	
	NewExterior_Facestyle_Dress_ActionImg:Hide()
	NewExterior_Facestyle_Weapon_ActionImg:Hide()
	NewExterior_Facestyle_PetPossJian_ActionImg:Hide()
	NewExterior_Facestyle_FaceStyle_ActionImg:Hide()
	NewExterior_Facestyle_HairStyle_ActionImg:Hide()
	NewExterior_Facestyle_PlayerFrame_ActionImg:Hide()
	NewExterior_Facestyle_Ride_ActionImg:Hide()
	
	NewExterior_Facestyle_Dress_LockImg:Hide()
	NewExterior_Facestyle_Weapon_LockImg:Hide()
	NewExterior_Facestyle_PetPossJian_LockImg:Hide()
	NewExterior_Facestyle_FaceStyle_LockImg:Hide()
	NewExterior_Facestyle_HairStyle_LockImg:Hide()
	NewExterior_Facestyle_PlayerFrame_LockImg:Hide()
	NewExterior_Facestyle_Ride_LockImg:Hide()
end

function NewExterior_Facestyle_FakeObject_TurnLeft(start)
	
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		if(start == 1) then
			NewExterior_Facestyle_FakeObject:RotateBegin(-0.3);
		else
			NewExterior_Facestyle_FakeObject:RotateEnd();
		end
	end
end

function NewExterior_Facestyle_ExteriorWeaponDisplay()
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

function NewExterior_Facestyle_FashionDisplay()
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

function NewExterior_Facestyle_FakeObject_TurnRight(start)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		if(start == 1) then
			NewExterior_Facestyle_FakeObject:RotateBegin(0.3);
		else
			NewExterior_Facestyle_FakeObject:RotateEnd();
		end
	end
end
--右键取下时装
function NewExterior_Facestyle_ActionToDressBox()
	--卸下时装到时装格子
    Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("ExteriorFashion");
		Set_XSCRIPT_ScriptID(830243);
		Set_XSCRIPT_Parameter(0,1);
		Set_XSCRIPT_ParamCount(1);
    Send_XSCRIPT();	
	NewExterior_Facestyle_Dress_ActionImg:Hide()
	NewExterior_Facestyle_Dress_LockImg:Hide()
	NewExterior_Facestyle_Dress_LeftBtn:SetActionItem(-1)	
end
--时装
function NewExterior_Facestyle_OpenFashion()
	NewExterior_Facestyle_SavePosition()
	LuaFnAskOpenExterior(1)
end
--幻武
function NewExterior_Facestyle_OpenWeapon()
	NewExterior_Facestyle_SavePosition()
	LuaFnAskOpenExterior(2)
end
--附体
function NewExterior_Facestyle_OpenFuti()
	NewExterior_Facestyle_SavePosition()
	LuaFnAskOpenExterior(6)
end
--坐骑
function NewExterior_Facestyle_OpenRide()
	NewExterior_Facestyle_SavePosition()
	LuaFnAskOpenExterior(3)
end
--发型
function NewExterior_Facestyle_OpenHair()
	NewExterior_Facestyle_SavePosition()	
	LuaFnAskOpenExterior(5)
end
--脸型
function NewExterior_Facestyle_OpenFace()
end
--头像
function NewExterior_Facestyle_OpenPortrait()
	NewExterior_Facestyle_SavePosition()	
	LuaFnAskOpenExterior(7)
end

function NewExterior_Facestyle_OpenInfant()
end

function NewExterior_Facestyle_CloseSameGroupWindow()
	CloseWindow("SelfEquip", true)
	CloseWindow("NewExterior_Ride", true)
	CloseWindow("NewExterior_Weapon", true)
	CloseWindow("NewExterior_PetPossJian", true)
	CloseWindow("NewExterior_HairStyle", true)
	CloseWindow("NewExterior_PlayerFrame", true)
	CloseWindow("NewExterior_DressBox", true)
	g_Original_Style = DataPool:Get_MyFaceStyle();
	DataPool:Change_MyFaceStyle(g_Original_Style);
end

function NewExterior_Facestyle_SavePosition()
	NewExterior_Facestyle_FakeObject:SetFakeObject( "" );
	Variable:SetVariable("ExteriorUnionPos", NewExterior_Facestyle_Frame:GetProperty("UnifiedPosition"), 1)
end

function NewExterior_Facestyle_SetPosition()
	
	local nExteriorUnionPos = Variable:GetVariable("ExteriorUnionPos")
	if nExteriorUnionPos ~= nil then
		NewExterior_Facestyle_Frame:SetProperty("UnifiedPosition", nExteriorUnionPos)
	end

end
