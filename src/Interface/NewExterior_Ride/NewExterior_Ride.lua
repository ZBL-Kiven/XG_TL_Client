--!!!reloadscript =NewExterior_Ride
local g_NewExterior_Ride_UnifiedPosition = ""

local EXTERIORFILTTING_TOTALKIND = 6;
local g_TargetExteriorIndex = 0		--定位的外观索引，从1开始
local g_TargetExteriorID = 0			--定位的外观ID

local g_CurSelExteriorID = 0			--当前选择的外观ID，从1开始

local g_NeedChangeScrollSize = 1

local g_Distance = 1
local g_Distance_Ori = 1
local g_Distance_Max = 3
local g_InitList = 0
local g_ExteriorType = 0 --坐骑
local g_MaxBarNum = 0
local g_BarList = {}
local g_ViewMode = 0 --0是角色骑马1是只有马
local g_PlayerFashionRideList = {}
local g_DecoWeapon_Display = 0
local g_CameraPosition =
{
	--女性相关位置
	[0] = {fHeight = 0.85, fDistance = 7.2, fPitch=0.2},
	--男性相关位置
	[1] = {fHeight = 0.85, fDistance = 7.5, fPitch=0.28},
}
local g_RideBox_SuperListItem = {}

local g_RideBox_Page = 0
local g_RideEconh = {}
local g_RideMaxNum = 0
local g_ExteriorRideMaxPage = 0
--=========
--PreLoad==
--=========
function NewExterior_Ride_PreLoad()	
	this:RegisterEvent("UNIT_LEVEL",false)
	this:RegisterEvent("ON_SCENE_TRANS",false)
	this:RegisterEvent("ON_SERVER_TRANS",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	this:RegisterEvent("ADJEST_UI_POS",false)	
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("UPDATE_EXTERIOR_FASHION", false)
	this:RegisterEvent("UI_COMMAND")
end

--=========
--OnLoad
--=========
function NewExterior_Ride_OnLoad()
	g_NewExterior_Ride_UnifiedPosition = NewExterior_Ride_Frame:GetProperty("UnifiedPosition")
	
	for i = 1,35 do
		table.insert(g_RideBox_SuperListItem,{Lock = _G[string.format("NewExterior_Ride_SuperListItemActionLock%d",i)],Luxury = _G[string.format("NewExterior_Ride_SuperListItemActionLuxury%d",i)],Mark = _G[string.format("NewExterior_Ride_SuperListItemActionMark%d",i)],Button = _G[string.format("NewExterior_Ride_SuperListItemAction_%d",i)],ActionTry = _G[string.format("NewExterior_Ride_SuperListItemActionTry_%d",i)],ActionEqu=_G[string.format("NewExterior_Ride_SuperListItemActionEqu_%d",i)]})
	end	
end
--=========
--OnEvent
--=========
function NewExterior_Ride_OnEvent(event)
	if event == "UI_COMMAND" and tonumber(arg0) == 202107301 then
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
		if(IsWindowShow("NewExterior_PlayerFrame")) then
			CloseWindow("NewExterior_PlayerFrame", true);
		end	
		if(IsWindowShow("NewExterior_Weapon")) then
			CloseWindow("NewExterior_Weapon", true);
		end	
		if(IsWindowShow("NewExterior_Weapon_Levelup")) then
			CloseWindow("NewExterior_Weapon_Levelup", true);
		end	

		SetGameMissionData("MD_EXTERIOR",3)
		g_RideBox_Page = 0
		g_RideEconh = {}
		local ServerEconh = Get_XParam_STR(0)
		g_RideMaxNum = Get_XParam_INT(0)
		--数据缓存一波
		for i = 1,string.len(ServerEconh) do
			local nInfo = string.sub(ServerEconh,i,i)
			g_RideEconh[i] = {i,tonumber(nInfo)}
		end
		--排序，门派需求靠后，拥有的靠前，按新旧排序
		for i = 1,g_RideMaxNum do
			for j = 1,i do
				local nMenpai = LuaFnGetExteriorRideInfo(g_RideEconh[i][1],"nRideIndex")
				local nMenpaj = LuaFnGetExteriorRideInfo(g_RideEconh[j][1],"nRideIndex")
				if nMenpai > nMenpaj then
					local Tmp = g_RideEconh[i]
					g_RideEconh[i] = g_RideEconh[j]
					g_RideEconh[j] = Tmp
				end
			end
		end
		for i = 1,g_RideMaxNum do
			for j = 1,i do
				if g_RideEconh[i][2] > 0 then
					local Tmp = g_RideEconh[i]
					g_RideEconh[i] = g_RideEconh[j]
					g_RideEconh[j] = Tmp
				end
			end
		end		
		local menpai = Player:GetData("MEMPAI");
		if menpai == 9 then
			for i = 1,g_RideMaxNum do
				for j = 1,i do
					local nMenpai = LuaFnGetExteriorRideInfo(g_RideEconh[i][1],"Menpai")
					local nMenpaj = LuaFnGetExteriorRideInfo(g_RideEconh[j][1],"Menpai")
					if nMenpai < nMenpaj then
						local Tmp = g_RideEconh[i]
						g_RideEconh[i] = g_RideEconh[j]
						g_RideEconh[j] = Tmp
					end
				end
			end		
		else
			for i = 1,g_RideMaxNum do
				for j = 1,i do
					local nMenpai = LuaFnGetExteriorRideInfo(g_RideEconh[i][1],"Menpai")
					local nMenpaj = LuaFnGetExteriorRideInfo(g_RideEconh[j][1],"Menpai")
					--自己门派是否已拥有就靠前显示
					if nMenpai ~= menpai and g_RideEconh[i][2] ~= 1 then
						if nMenpai < nMenpaj then
							local Tmp = g_RideEconh[i]
							g_RideEconh[i] = g_RideEconh[j]
							g_RideEconh[j] = Tmp
						end
					end
				end
			end		
		end
		g_ExteriorRideMaxPage = math.ceil(g_RideMaxNum/35)
		NewExterior_Ride_OnHidden()
		NewExterior_Ride_FakeObject : SetFakeObject("");
		-- NewExterior_Ride_FakeObject : SetFakeObject("My_Horse");
		NewExterior_Ride_SetPosition()
		NewExterior_Ride_CloseSameGroupWindow()
		this:Show()
		NewExterior_Ride_Show()	
		return
	end
	if event == "UI_COMMAND" and tonumber(arg0) == 122032413 then
		if GetGameMissionData("MD_EXTERIOR") == 3 then
			NewExterior_Ride_Show()
		end
		return
	end			
	if event == "UI_COMMAND" and tonumber(arg0) == 1000000037 then
		NewExterior_Ride_Weapon_Type:SetCheck(Get_XParam_INT(0))
		return
	end	
	if event == "UI_COMMAND" and tonumber(arg0) == 20210801 then
		NewExterior_Ride_FakeObject: SetFakeObject("");	
		return
	end	
	-- 游戏窗口尺寸发生了变化 or 游戏分辨率发生了变化
	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		NewExterior_Ride_Frame:SetProperty("UnifiedPosition", g_NewExterior_Ride_UnifiedPosition)
	end
end
function NewExterior_Ride_Show()
	NewExterior_Ride_FakeObject : SetFakeObject("");
	--左侧
	NewExterior_Ride_UpdateLeftBtn()	
	--列表
	NewExterior_Ride_UpdateList()
	NewExterior_Ride_Model_Plus:Hide()
	NewExterior_Ride_Model_Subtract:Hide()
	local strTemp = "#cffe1b8当前最高速度：+80%"
	NewExterior_Ride_Text1:SetText(strTemp)
end
--左侧
function NewExterior_Ride_UpdateLeftBtn()
	NewExterior_Ride_CleanUp_LeftButton()	
	--时装
	NewExterior_Ride_Dress_LeftBtn:SetActionItem(-1)
	if GetGameMissionData("MD_DRESS") ~= 0 then
		NewExterior_Ride_Dress_ActionImg:Show()
		NewExterior_Ride_Dress_LockImg:Show()
		local _,Icons = LifeAbility : GetPrescr_Material(GetGameMissionData("MD_DRESS"))
		local strImage = GetIconFullName(Icons)
		NewExterior_Ride_Dress_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_Ride_Dress_LeftBtn:SetProperty("PushedImage", strImage)
		NewExterior_Ride_Dress_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_Ride_Dress_LeftBtn:SetProperty("Empty", "False")
		NewExterior_Ride_Dress_LeftBtn:SetProperty("UseDefaultTooltip", "True")		
	else
		NewExterior_Ride_Dress_LeftBtn:SetProperty("HoverImage", "")
		NewExterior_Ride_Dress_LeftBtn:SetProperty("PushedImage", "")
		NewExterior_Ride_Dress_LeftBtn:SetProperty("NormalImage", "")
		local theAction = EnumAction(2, "equip");
		NewExterior_Ride_Dress_LeftBtn:SetActionItem(theAction:GetID())
		NewExterior_Ride_Dress_ActionImg:Hide()
		NewExterior_Ride_Dress_LockImg:Hide()	
	end
	--坐骑
	theAction = DataPool:GetPlayerMission_DataRound(362)
	local strIcon = LuaFnGetExteriorRideInfo(theAction,"Icon")
	local strName = LuaFnGetExteriorRideInfo(theAction,"Name")
	local strImage = GetIconFullName(strIcon)
	local nRideIndex = LuaFnGetExteriorRideInfo(theAction,"nRideIndex")
	if theAction == 0 then
		Player:SetHorseModel(-1);
		NewExterior_Ride_FakeObject : SetFakeObject("");
	else
		Player:SetHorseModel(nRideIndex);
		NewExterior_Ride_FakeObject : SetFakeObject("My_Horse");
		NewExterior_Ride_Ride_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_Ride_Ride_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_Ride_Ride_LeftBtn:SetProperty("PushedImage", strImage)
		NewExterior_Ride_Ride_LeftBtn:SetToolTip(strName)
		NewExterior_Ride_Ride_LockImg:Hide()
		NewExterior_Ride_Ride_ActionImg:Hide()
		if nRideIndex > 0 then
			fHeight, fDistance = LuaFnGetExteriorRideCameraParam(nRideIndex,1)
			if nRideIndex == 0 then
				fHeight, fDistance = 1,13
			end
			FakeObj_SetCamera( "My_Horse", 1,fHeight);
			FakeObj_SetCamera( "My_Horse", 2,fDistance);
			FakeObj_SetCamera( "My_Horse", 3,0.2);	
		end		
	end
	if GetGameMissionData("MD_RIDA") ~= 0 then
		NewExterior_Ride_Ride_ActionImg:Show()
		NewExterior_Ride_Ride_LockImg:Show()
		strIcon = LuaFnGetExteriorRideInfo(GetGameMissionData("MD_RIDA"), "Icon")
		strImage = GetIconFullName(strIcon)
		strName 	= LuaFnGetExteriorRideInfo(GetGameMissionData("MD_RIDA"), "Name")
		NewExterior_Ride_Ride_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_Ride_Ride_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_Ride_Ride_LeftBtn:SetProperty("PushedImage", strImage)
		NewExterior_Ride_Ride_LeftBtn:SetToolTip(strName)
		nRideIndex = LuaFnGetExteriorRideInfo(GetGameMissionData("MD_RIDA"),"nRideIndex")
		if nRideIndex > 0 then
			-- PushDebugMessage("试穿坐骑："..nRideIndex)
			fHeight, fDistance = LuaFnGetExteriorRideCameraParam(nRideIndex,1)
			if nRideIndex == 0 then
				fHeight, fDistance = 1,13
			end
			Player:SetHorseModel(nRideIndex);
			-- NewExterior_Ride_FakeObject : SetFakeObject("My_Horse");
			FakeObj_SetCamera( "My_Horse", 1,fHeight);
			FakeObj_SetCamera( "My_Horse", 2,fDistance);
			FakeObj_SetCamera( "My_Horse", 3,0.2);	
		end		
	end
	-- 附体
	cacheExteriorID = DataPool:GetPlayerMission_DataRound(387)
	if cacheExteriorID > 0 then
		local strName,iQual,iBloodRank,curPetSoulid,strIcon = NewExterior_PetSoul_DataShow(cacheExteriorID)
		strImage = GetIconFullName(strIcon)
		NewExterior_Ride_PetSoul_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_Ride_PetSoul_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_Ride_PetSoul_LeftBtn:SetToolTip(strName)
		NewExterior_Ride_PetSoul_LockImg:Hide()
		NewExterior_Ride_PetSoul_ActionImg:Hide()
		NewExterior_Ride_PetSoul_LeftBtn:SetProperty("Empty", "False")
		NewExterior_Ride_PetSoul_LeftBtn:SetProperty("UseDefaultTooltip", "True")
	end
	NewExterior_Ride_PetSoul_LockImg:Hide()
	NewExterior_Ride_PetSoul_ActionImg:Hide()
	local TryPoss = GetGameMissionData("MD_PETPOSS")
	if TryPoss ~= 0 then
		TryPoss = math.mod(TryPoss,100)
		local strName,strIcon,iQual = LuaFnGetExteriorPossInfo(TryPoss)
		strImage = GetIconFullName(strIcon)
		NewExterior_Ride_PetSoul_LockImg:Show()
		NewExterior_Ride_PetSoul_ActionImg:Show()
		NewExterior_Ride_PetSoul_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_Ride_PetSoul_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_Ride_PetSoul_LeftBtn:SetToolTip(strName)
		NewExterior_Ride_PetSoul_LeftBtn:SetProperty("Empty", "False")
		NewExterior_Ride_PetSoul_LeftBtn:SetProperty("UseDefaultTooltip", "True")
	end
	--脸型
	cacheExteriorID = DataPool:Get_MyFaceStyle()
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local _,_,_,IconFile,_,StyleName = DataPool : Change_MyFaceStyle_Item(cacheExteriorID);
		local strImage = GetIconFullName(IconFile)			
		NewExterior_Ride_FaceStyle_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_Ride_FaceStyle_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_Ride_FaceStyle_LeftBtn:SetProperty("Empty", "False")
		NewExterior_Ride_FaceStyle_LeftBtn:SetProperty("UseDefaultTooltip", "True")
		NewExterior_Ride_FaceStyle_ActionImg:Hide()
		NewExterior_Ride_FaceStyle_LockImg:Hide()
		local strTemp = StyleName
		NewExterior_Ride_FaceStyle_LeftBtn:SetToolTip(strTemp)
	end
	if GetGameMissionData("MD_FACE") ~= 0 then
		NewExterior_Ride_FaceStyle_ActionImg:Show()
		NewExterior_Ride_FaceStyle_LockImg:Show()
		strIcon 	= LuaFnGetExteriorFaceInfo(GetGameMissionData("MD_FACE"), "Icon")
		strName 	= LuaFnGetExteriorFaceInfo(GetGameMissionData("MD_FACE"), "Name")
		strImage = GetIconFullName(strIcon)
		NewExterior_Ride_FaceStyle_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_Ride_FaceStyle_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_Ride_FaceStyle_LeftBtn:SetProperty("Empty", "False")
		NewExterior_Ride_FaceStyle_LeftBtn:SetProperty("UseDefaultTooltip", "True")
		NewExterior_Ride_FaceStyle_LeftBtn:SetToolTip(strName)
	end		
	--发型
	cacheExteriorID = DataPool : Get_MyHairStyle()
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local strName 	= LuaFnGetExteriorHairInfo(cacheExteriorID, "Name")
		local strIcon 	= LuaFnGetExteriorHairInfo(cacheExteriorID, "Icon")
		local strImage = GetIconFullName(strIcon)		
		NewExterior_Ride_HairStyle_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_Ride_HairStyle_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_Ride_HairStyle_LockImg:Hide()
		NewExterior_Ride_HairStyle_ActionImg:Hide()
		local strTemp = strName
		NewExterior_Ride_HairStyle_LeftBtn:SetToolTip(strTemp)
	end
	if GetGameMissionData("MD_HAIR") ~= 0 then
		strIcon 	= LuaFnGetExteriorHairInfo(GetGameMissionData("MD_HAIR"), "Icon")
		strName 	= LuaFnGetExteriorHairInfo(GetGameMissionData("MD_HAIR"), "Name")
		strImage = GetIconFullName(strIcon)
		NewExterior_Ride_HairStyle_LockImg:Show()
		NewExterior_Ride_HairStyle_ActionImg:Show()
		NewExterior_Ride_HairStyle_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_Ride_HairStyle_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_Ride_HairStyle_LeftBtn:SetProperty("Empty", "False")
		NewExterior_Ride_HairStyle_LeftBtn:SetToolTip(strName)
	end	
	--头像
	local strHeadTip = ""
	cacheExteriorID = DataPool : Get_MyHeadStyle()
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local strName 	= LuaFnGetExteriorPortraitInfo(cacheExteriorID, "Name")
		local strIcon 	= LuaFnGetExteriorPortraitInfo(cacheExteriorID, "Icon")
		local strImage = GetIconFullName(strIcon)		
		NewExterior_Ride_PlayerFrame_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_Ride_PlayerFrame_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_Ride_PlayerFrame_LockImg:Hide()
		NewExterior_Ride_PlayerFrame_ActionImg:Hide()
		local strTemp = strName
		NewExterior_Ride_PlayerFrame_LeftBtn:SetToolTip(strTemp)	
	end	
	if GetGameMissionData("MD_HEAD") ~= 0 then
		NewExterior_Ride_PlayerFrame_LockImg:Show()
		NewExterior_Ride_PlayerFrame_ActionImg:Show()
		strIcon 	= LuaFnGetExteriorPortraitInfo(GetGameMissionData("MD_HEAD"), "Icon")
		strName 	= LuaFnGetExteriorPortraitInfo(GetGameMissionData("MD_HEAD"), "Name")
		strImage = GetIconFullName(strIcon)
		NewExterior_Ride_PlayerFrame_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_Ride_PlayerFrame_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_Ride_PlayerFrame_LeftBtn:SetProperty("Empty", "False")
		NewExterior_Ride_PlayerFrame_LeftBtn:SetToolTip(strName)
	end
	--幻武
	cacheExteriorID = DataPool:GetPlayerMission_DataRound(389)
	if cacheExteriorID ~= 0 then
		local strName 	= LuaFnGetExteriorWeaponInfo(cacheExteriorID, "Name")
		local strIcon 	= LuaFnGetExteriorWeaponInfo(cacheExteriorID, "Icon")
		local strImage = GetIconFullName(strIcon)
		NewExterior_Ride_Weapon_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_Ride_Weapon_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_Ride_Weapon_LeftBtn:SetProperty("Empty", "False")
		NewExterior_Ride_Weapon_LeftBtn:SetProperty("UseDefaultTooltip", "True")
		local strTemp = strName
		NewExterior_Ride_Weapon_LeftBtn:SetToolTip(strTemp)
	else
		NewExterior_Ride_Weapon_LeftBtn:SetProperty("HoverImage", "")
		NewExterior_Ride_Weapon_LeftBtn:SetProperty("NormalImage", "")
	end
	NewExterior_Ride_Weapon_ActionImg:Hide()
	NewExterior_Ride_Weapon_LockImg:Hide()
	if GetGameMissionData("MD_WEAPON") > 0 then
		NewExterior_Ride_Weapon_ActionImg:Show()
		NewExterior_Ride_Weapon_LockImg:Show()
		strIcon 	= LuaFnGetExteriorWeaponInfo(GetGameMissionData("MD_WEAPON"), "Icon")
		strName 	= LuaFnGetExteriorWeaponInfo(GetGameMissionData("MD_WEAPON"), "Name")
		strImage = GetIconFullName(strIcon)
		NewExterior_Ride_Weapon_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_Ride_Weapon_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_Ride_Weapon_LeftBtn:SetToolTip(strName)
	end			
	for i = 1,35 do
		g_RideBox_SuperListItem[i].Button:SetProperty("Empty","False")
		g_RideBox_SuperListItem[i].Button:SetProperty("UseDefaultTooltip","True")
	end
end

function NewExterior_Ride_Page(Index)
	g_RideBox_Page = g_RideBox_Page + Index
	if g_RideBox_Page > g_ExteriorRideMaxPage - 1 then
		g_RideBox_Page = g_ExteriorRideMaxPage - 1
		return
	end
	if g_RideBox_Page < 0 then
		g_RideBox_Page = 0
		return
	end
	for i = 1,35 do
		local ctrlAction = g_RideBox_SuperListItem[i]
		ctrlAction.Button:Hide()
		ctrlAction.ActionTry:Hide()
		ctrlAction.Lock:Hide()
		ctrlAction.ActionEqu:Hide()
		ctrlAction.Luxury:Hide()
	end
	NewExterior_Ride_UpdateList()
end
--列表
function NewExterior_Ride_UpdateList()
	local nIndex = 1
	local nMyMenpai = Player:GetData("MEMPAI")
	for i = g_RideBox_Page * 35 + 1 ,g_RideBox_Page * 35 +35 do
		local nExteriorID 	= g_RideEconh[i][1]
		local ctrlAction = g_RideBox_SuperListItem[nIndex]
		ctrlAction.ActionTry:Hide()
		if i <= g_RideMaxNum then
			local strIcon = LuaFnGetExteriorRideInfo(nExteriorID,"Icon")
			local strName = LuaFnGetExteriorRideInfo(nExteriorID,"Name")
			local strImage = GetIconFullName(strIcon)
			local nLuxury = LuaFnGetExteriorRideInfo(nExteriorID,"Luxury")
			local nMenpai = LuaFnGetExteriorRideInfo(nExteriorID,"Menpai")
			local strTemp = LuaFnGetExteriorRideInfo(nExteriorID,"ToolTip")
			local nSetToolTip = strName.."#r期限：可永久使用#r速度：使用后骑乘速度#G+80%#Y"..strTemp
			ctrlAction.Button:SetProperty("NormalImage", strImage)
			ctrlAction.Button:SetProperty("HoverImage", strImage)
			ctrlAction.Button:Show()
			if nLuxury == 1 then
				ctrlAction.Luxury:Show()
				nSetToolTip = nSetToolTip.."#r#Y【奢侈品】"
			else
				ctrlAction.Luxury:Hide()
			end			
			ctrlAction.Button:SetToolTip(nSetToolTip)
			if g_RideEconh[i][2] ~= 0 then 
				ctrlAction.Lock:Hide()
			else
				ctrlAction.Lock:Show()
			end
			if nMyMenpai == nMenpai or nMenpai == -1 then
				ctrlAction.Mark:Hide()
			else
				ctrlAction.Mark:Show()
			end
			if InUse == nExteriorID then
				ctrlAction.ActionEqu:Show()
			else
				ctrlAction.ActionEqu:Hide()
			end
		else
			ctrlAction.Luxury:Hide()
			ctrlAction.ActionEqu:Hide()
			ctrlAction.Mark:Hide()
			ctrlAction.Lock:Hide()
			ctrlAction.ActionTry:Hide()
			ctrlAction.Button:Hide()
		end	
		nIndex = nIndex + 1
	end
end
function NewExterior_Ride_FashionDisplay()
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

function NewExterior_Ride_ExteriorWeaponDisplay()
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
function NewExterior_RideTakeOut()

end
function NewExterior_Ride_UpdateOpBtn()
	
end
function NewExterior_Ride_ItemClicked(nIndex)

	-- PushDebugMessage("nIndex  "..nIndex)
	-- 显示	
	local nExteriorID = g_RideEconh[nIndex + g_RideBox_Page * 35 ][1]
	local nRideIndex = LuaFnGetExteriorRideInfo(nExteriorID,"nRideIndex")
	NewExterior_Ride_FakeObject : SetFakeObject("");
	-- PushDebugMessage(nRideIndex)
	if nRideIndex >= 0 then
		Player:SetHorseModel(nRideIndex);			
		NewExterior_Ride_FakeObject : SetFakeObject("My_Horse");			
		fHeight, fDistance = LuaFnGetExteriorRideCameraParam(nRideIndex,1)
		if nRideIndex == 0 then
			fHeight, fDistance = 1,13
		end
		FakeObj_SetCamera( "My_Horse", 1,fHeight);
		FakeObj_SetCamera( "My_Horse", 2,fDistance);
		FakeObj_SetCamera( "My_Horse", 3,0.2);		
	end
	for i = 1,table.getn(g_RideBox_SuperListItem) do
		if nIndex == i then
			g_RideBox_SuperListItem[i].ActionTry:Show()
			g_RideBox_SuperListItem[i].Button:SetPushed(1)
		else
			g_RideBox_SuperListItem[i].ActionTry:Hide()
			g_RideBox_SuperListItem[i].Button:SetPushed(0)
		end	
	end
	--试穿黑处理
	local strIcon = LuaFnGetExteriorRideInfo(nExteriorID,"Icon")
	local strImage = GetIconFullName(strIcon)
	NewExterior_Ride_Ride_LeftBtn:SetProperty("NormalImage", strImage)
	NewExterior_Ride_Ride_LeftBtn:SetProperty("Empty", "False")
	NewExterior_Ride_Ride_ActionImg:Show()
	NewExterior_Ride_Ride_LockImg:Show()
	SetGameMissionData("MD_RIDA",nExteriorID)
end
function NewExterior_Ride_TakeOffRide()
    Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("RideSysteam");
		Set_XSCRIPT_ScriptID(830243);
		Set_XSCRIPT_Parameter(0,13);
		Set_XSCRIPT_ParamCount(1);
    Send_XSCRIPT();	
	NewExterior_Ride_Ride_LeftBtn:SetProperty("PushedImage", "")
	NewExterior_Ride_Ride_LeftBtn:SetProperty("NormalImage", "")
	NewExterior_Ride_Ride_LeftBtn:SetProperty("HoverImage", "")
	NewExterior_Ride_Ride_LeftBtn:SetToolTip("")
end

function NewExterior_Ride_TakeOffWeapon()
    Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("RideSysteam");
		Set_XSCRIPT_ScriptID(830243);
		Set_XSCRIPT_Parameter(0,12);
		Set_XSCRIPT_ParamCount(1);
    Send_XSCRIPT();	
	NewExterior_Ride_Weapon_LeftBtn:SetProperty("PushedImage", "")
	NewExterior_Ride_Weapon_LeftBtn:SetProperty("NormalImage", "")
	NewExterior_Ride_Weapon_LeftBtn:SetProperty("HoverImage", "")
	NewExterior_Ride_Weapon_LeftBtn:SetToolTip("")	
end

function NewExterior_Ride_CloseClick()
	NewExterior_Ride_OnHidden()
	NewExterior_Ride_SavePosition()
	this:Hide()
end

function NewExterior_Ride_OnHidden()
	NewExterior_Ride_FakeObject:SetFakeObject("")
	local IsWindow = {"NewExterior_DressBox","NewExterior_Weapon","NewExterior_PetPossJian","NewExterior_Facestyle","NewExterior_HairStyle","NewExterior_PlayerFrame","Ride","SelfEquip"}
	for i = 1,table.getn(IsWindow) do
		if IsWindowShow(IsWindow[i]) == true then
			CloseWindow(IsWindow[i], true)
		end
	end
	NewExterior_Ride_CleanUp()
end
function NewExterior_Ride_TryExterior()
	--预览信息
	SaveAllChange()
	NewExterior_Ride_RemovePreview()
end
function NewExterior_Ride_RemovePreview()
	ClearSaveAllChange()
	NewExterior_Ride_Show()
end
function NewExterior_Ride_CleanUp()
	NewExterior_Ride_CleanUp_LeftButton()
end

function NewExterior_Ride_CleanUp_LeftButton()
	
	local ctrl_list = {
		NewExterior_Ride_FaceStyle_LeftBtn,
		NewExterior_Ride_HairStyle_LeftBtn,
		NewExterior_Ride_PlayerFrame_LeftBtn,
		NewExterior_Ride_Ride_LeftBtn,	
		NewExterior_Ride_PetSoul_LeftBtn,
	}
	
	for i in pairs(ctrl_list) do
		ctrl_list[i]:SetProperty("Empty", "False")
		ctrl_list[i]:SetProperty("UseDefaultTooltip", "True")
		ctrl_list[i]:SetProperty("NormalImage", "")
		ctrl_list[i]:SetProperty("HoverImage", "")
		ctrl_list[i]:SetToolTip("")
	end
	
	
	NewExterior_Ride_Dress_ActionImg:Hide()
	NewExterior_Ride_FaceStyle_ActionImg:Hide()
	NewExterior_Ride_HairStyle_ActionImg:Hide()
	NewExterior_Ride_PlayerFrame_ActionImg:Hide()
	NewExterior_Ride_Ride_ActionImg:Hide()
	NewExterior_Ride_PetSoul_ActionImg:Hide()
	
	NewExterior_Ride_Dress_LockImg:Hide()
	NewExterior_Ride_FaceStyle_LockImg:Hide()
	NewExterior_Ride_HairStyle_LockImg:Hide()
	NewExterior_Ride_PlayerFrame_LockImg:Hide()
	NewExterior_Ride_Ride_LockImg:Hide()
	NewExterior_Ride_PetSoul_LockImg:Hide()
end

function NewExterior_Ride_FakeObject_TurnLeft(start)
	
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		--向左旋转开始
		if(start == 1) then
			NewExterior_Ride_FakeObject:RotateBegin(-0.3);
		--向左旋转结束
		else
			NewExterior_Ride_FakeObject:RotateEnd();
		end
	end
end

function NewExterior_Ride_FakeObject_TurnRight(start)
	
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		--向右旋转开始
		if(start == 1) then
			NewExterior_Ride_FakeObject:RotateBegin(0.3);
		--向右旋转结束
		else
			NewExterior_Ride_FakeObject:RotateEnd();
		end
	end
end
--卸下时装 
function NewExterior_Ride_ActionToDressBox()
	--卸下时装到时装格子
    Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("ExteriorFashion");
		Set_XSCRIPT_ScriptID(830243);
		Set_XSCRIPT_Parameter(0,1);
		Set_XSCRIPT_ParamCount(1);
    Send_XSCRIPT();	
	NewExterior_Ride_Dress_ActionImg:Hide()
	NewExterior_Ride_Dress_LockImg:Hide()
	NewExterior_Ride_Dress_LeftBtn:SetActionItem(-1)	
end
--时装
function NewExterior_Ride_OpenFashion()
	NewExterior_Ride_SavePosition()
	LuaFnAskOpenExterior(1)
end
--幻武
function NewExterior_Ride_OpenWeapon()
	NewExterior_Ride_SavePosition()
	LuaFnAskOpenExterior(2)
end
--附体
function NewExterior_Ride_OpenPoss()
	NewExterior_Ride_SavePosition()
	LuaFnAskOpenExterior(6)
end
--坐骑
function NewExterior_Ride_OpenRide()
end
--发型
function NewExterior_Ride_OpenHair()
	NewExterior_Ride_SavePosition()
	LuaFnAskOpenExterior(5)
end
--脸型
function NewExterior_Ride_OpenFace()
	NewExterior_Ride_SavePosition()	
	LuaFnAskOpenExterior(4)
end
--头像
function NewExterior_Ride_OpenPortrait()
	NewExterior_Ride_SavePosition()	
	LuaFnAskOpenExterior(7)
end

function NewExterior_Ride_OpenInfant()
	NewExterior_Ride_SavePosition()
end

function NewExterior_Ride_CloseSameGroupWindow()
	CloseWindow("SelfEquip", true)
	CloseWindow("WuHun", true)
	CloseWindow("NewExterior_Weapon", true)
	CloseWindow("NewExterior_PetPossJian", true)
	CloseWindow("NewExterior_Facestyle", true)
	CloseWindow("NewExterior_HairStyle", true)
	CloseWindow("NewExterior_PlayerFrame", true)
	CloseWindow("NewExterior_DressBox", true)
end

function NewExterior_Ride_SavePosition()
	Variable:SetVariable("ExteriorUnionPos", NewExterior_Ride_Frame:GetProperty("UnifiedPosition"), 1)
	NewExterior_Ride_CloseSameGroupWindow()
end

function NewExterior_Ride_SetPosition()
	
	local nExteriorUnionPos = Variable:GetVariable("ExteriorUnionPos")
	if nExteriorUnionPos ~= nil then
		NewExterior_Ride_Frame:SetProperty("UnifiedPosition", nExteriorUnionPos)
	end

end

function NewExterior_Ride_OpenAchievement()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("open")
		Set_XSCRIPT_ScriptID(888051)
		Set_XSCRIPT_Parameter(0, -1)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
end

function NewExterior_Ride_OpenAchievementShop()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("open_shop")
		Set_XSCRIPT_ScriptID(888051)
		Set_XSCRIPT_Parameter(0, -1)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
end
