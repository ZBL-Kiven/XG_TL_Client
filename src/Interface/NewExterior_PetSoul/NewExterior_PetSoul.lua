--!!!reloadscript =NewExterior_PetSoul
local g_NewExterior_PetSoul_UnifiedPosition = ""

local EXTERIORFILTTING_TOTALKIND = 6;
local g_TargetExteriorID = 0			--定位的外观ID
local g_TargetExteriorIndex = 0		--定位的外观索引，从1开始

local g_CurSelExteriorID = 1			--当前选择的外观ID，从1开始
local g_CurVisualIndex = 1
local g_CurRHDIndex = 0

local g_NeedChangeScrollSize = 0

local g_Distance = 1
local g_Distance_Ori = 2
local g_Distance_Max = 4
local g_InitList = 0
local g_ExteriorType = 2 --附体
local g_MaxBarNum = 0
local g_BarList = {}
local g_ViewMode = 0
local PetPossJianList = {}
local g_CurPossVisualIndex = 1
local g_EquipPos = -1
local g_RHD_Value = {
	[1] = 0, 	--融合度：0-2
	[2] = 3, 	--融合度：3-5
	[3] = 6, 	--融合度：6-7
	[4] = 8, 	--融合度：8-9
	[5] = 10,	--融合度：10
}
local g_QualStr = {"#{SHRH_20220427_06}", "#{SHRH_20220427_05}", "#{SHRH_20220427_04}"}
local g_RankButtons = {}

local g_FutiVisualBtn = {}
local g_FutiVisualLock = {}
local g_FutiVisualTip = {}
local g_FutiVisualDef = {}
local g_FutiRHDBtn = {}
	
local g_CameraPosition =
{
	--女性相关位置
	[0] = {{fHeight = 0.85, fDistance = 12, fPitch=0.2}, {fHeight = 0.85, fDistance = 7.2, fPitch=0.2}, {fHeight = 1.55, fDistance = 2.5, fPitch=0.20}, {fHeight = 1.55, fDistance = 1.7, fPitch=0.20}},
	--男性相关位置
	[1] = {{fHeight = 0.85, fDistance = 12, fPitch=0.28}, {fHeight = 0.85, fDistance = 7.5, fPitch=0.28}, {fHeight = 1.65, fDistance = 2.7, fPitch=0.28}, {fHeight = 1.70, fDistance = 1.9, fPitch=0.28}},
}
--附体外形列表
local g_Huanse_IconVisList = {
	[1] = {[1]=1, [2]=0, [3]=0, [4]=0, [5]=0, [6]=0, [7]=0, [8]=0, [9]=0 },
	[2] = {[1]=0, [2]=0, [3]=0, [4]=0, [5]=0, [6]=0, [7]=0, [8]=0, [9]=0 },
	[3] = {[1]=0, [2]=0, [3]=0, [4]=0, [5]=0, [6]=0, [7]=0, [8]=0, [9]=0 },
	[4] = {[1]=0, [2]=0, [3]=0, [4]=0, [5]=0, [6]=0, [7]=0, [8]=0, [9]=0 },
	[5] = {[1]=0, [2]=0, [3]=0, [4]=0, [5]=0, [6]=0, [7]=0, [8]=0, [9]=0 },
	[6] = {[1]=0, [2]=0, [3]=0, [4]=0, [5]=0, [6]=0, [7]=0, [8]=0, [9]=0 },
	[7] = {[1]=0, [2]=0, [3]=0, [4]=0, [5]=0, [6]=0, [7]=0, [8]=0, [9]=0 },
	[8] = {[1]=0, [2]=0, [3]=0, [4]=0, [5]=0, [6]=0, [7]=0, [8]=0, [9]=0 },
	[9] = {[1]=0, [2]=0, [3]=0, [4]=0, [5]=0, [6]=0, [7]=0, [8]=0, [9]=0 },
}
local g_strRank = {
	"#{SHRH_20220427_15}",
	"#{SHRH_20220427_16}",
	"#{SHRH_20220427_17}",
}
	
--=========
--PreLoad==
--=========
function NewExterior_PetSoul_PreLoad()
	this:RegisterEvent("UNIT_LEVEL",false)	
	this:RegisterEvent("ON_SCENE_TRANS",false)
	this:RegisterEvent("ON_SERVER_TRANS",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	this:RegisterEvent("ADJEST_UI_POS",false)	
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("UPDATE_EXTERIOR_FASHION", false)
	this:RegisterEvent("UI_COMMAND", false)
end
function LuaFnExteriorFashionDepotItemClick()
	--卸下时装到时装格子
    Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("ExteriorFashion");
		Set_XSCRIPT_ScriptID(830243);
		Set_XSCRIPT_Parameter(0,1);
		Set_XSCRIPT_ParamCount(1);
    Send_XSCRIPT();	
	NewExterior_PetSoul_Dress_LeftBtn:SetActionItem(-1)	
end
--=========
--OnLoad
--=========
function NewExterior_PetSoul_OnLoad()
	g_NewExterior_PetSoul_UnifiedPosition = NewExterior_PetSoul_Frame:GetProperty("UnifiedPosition")
	


	g_RankButtons[1] = NewExterior_PetSoul_Level1
	g_RankButtons[2] = NewExterior_PetSoul_Level2
	g_RankButtons[3] = NewExterior_PetSoul_Level3
	
	for i = 1, 3 do		
		local strTip = string.format("#Y点击切换至%s#r魂录继承当前所融魂兽魂的魂境", g_strRank[i])
		g_RankButtons[i]:SetToolTip(strTip)
	end
	
	g_FutiVisualBtn[1] = NewExterior_PetSoul_Style1_RightBtn
	g_FutiVisualBtn[2] = NewExterior_PetSoul_Style2_RightBtn
	g_FutiVisualBtn[3] = NewExterior_PetSoul_Style3_RightBtn
	g_FutiVisualBtn[4] = NewExterior_PetSoul_Style4_RightBtn
	g_FutiVisualBtn[5] = NewExterior_PetSoul_Style5_RightBtn
	g_FutiVisualBtn[6] = NewExterior_PetSoul_Style6_RightBtn
	g_FutiVisualBtn[7] = NewExterior_PetSoul_Style7_RightBtn
	g_FutiVisualBtn[8] = NewExterior_PetSoul_Style8_RightBtn
	g_FutiVisualBtn[9] = NewExterior_PetSoul_Style9_RightBtn
	
	g_FutiVisualLock[1] = NewExterior_PetSoul_Level1_ActionImg
	g_FutiVisualLock[2] = NewExterior_PetSoul_Level2_ActionImg
	g_FutiVisualLock[3] = NewExterior_PetSoul_Level3_ActionImg
	g_FutiVisualLock[4] = NewExterior_PetSoul_Level4_ActionImg
	g_FutiVisualLock[5] = NewExterior_PetSoul_Level5_ActionImg
	g_FutiVisualLock[6] = NewExterior_PetSoul_Level6_ActionImg
	g_FutiVisualLock[7] = NewExterior_PetSoul_Level7_ActionImg
	g_FutiVisualLock[8] = NewExterior_PetSoul_Level8_ActionImg
	g_FutiVisualLock[9] = NewExterior_PetSoul_Level9_ActionImg

	g_FutiVisualTip[1] = NewExterior_PetSoul_Level1_Tip
	g_FutiVisualTip[2] = NewExterior_PetSoul_Level2_Tip
	g_FutiVisualTip[3] = NewExterior_PetSoul_Level3_Tip
	g_FutiVisualTip[4] = NewExterior_PetSoul_Level4_Tip
	g_FutiVisualTip[5] = NewExterior_PetSoul_Level5_Tip
	g_FutiVisualTip[6] = NewExterior_PetSoul_Level6_Tip
	g_FutiVisualTip[7] = NewExterior_PetSoul_Level7_Tip
	g_FutiVisualTip[8] = NewExterior_PetSoul_Level8_Tip
	g_FutiVisualTip[9] = NewExterior_PetSoul_Level9_Tip
	
	g_FutiVisualDef[1] = NewExterior_PetSoul_Level1_Def
	g_FutiVisualDef[2] = NewExterior_PetSoul_Level2_Def
	g_FutiVisualDef[3] = NewExterior_PetSoul_Level3_Def
	g_FutiVisualDef[4] = NewExterior_PetSoul_Level4_Def
	g_FutiVisualDef[5] = NewExterior_PetSoul_Level5_Def
	g_FutiVisualDef[6] = NewExterior_PetSoul_Level6_Def
	g_FutiVisualDef[7] = NewExterior_PetSoul_Level7_Def
	g_FutiVisualDef[8] = NewExterior_PetSoul_Level8_Def
	g_FutiVisualDef[9] = NewExterior_PetSoul_Level9_Def
	
	g_FutiRHDBtn[1] = NewExterior_PetSoul_SkillBind_01
	g_FutiRHDBtn[2] = NewExterior_PetSoul_SkillBind_02
	g_FutiRHDBtn[3] = NewExterior_PetSoul_SkillBind_03
	g_FutiRHDBtn[4] = NewExterior_PetSoul_SkillBind_04
	g_FutiRHDBtn[5] = NewExterior_PetSoul_SkillBind_05
	
	for i = 1,15 do
		table.insert(PetPossJianList,{Button = _G[string.format("NewExterior_PetSoul_SuperListItemAction%d",i)],mark = _G[string.format("NewExterior_PetSoul_SuperListItemActionMark%d",i)],ActionTry = _G[string.format("NewExterior_PetSoul_SuperListItemActionTry%d",i)],ActionEqu=_G[string.format("NewExterior_PetSoul_SuperListItemActionDef%d",i)],Reg=_G[string.format("NewExterior_PetSoul_SuperListItemActionLock%d",i)]})
	end
	
end
--=========
--OnEvent
--=========
function NewExterior_PetSoul_OnEvent(event)

	if event == "UI_COMMAND" and tonumber(arg0) == 2350111 then
		NewExterior_PetSoul_FakeObject:SetFakeObject("")
	end
	if event == "UI_COMMAND" and tonumber(arg0) == 9900143 then
		SetGameMissionData("MD_EXTERIOR",6)
		if(IsWindowShow("NewExterior_PlayerFrame")) then
			CloseWindow("NewExterior_PlayerFrame", true)
		end
		if(IsWindowShow("NewExterior_Facestyle")) then
			CloseWindow("NewExterior_Facestyle", true)
		end
		if(IsWindowShow("NewExterior_HairStyle")) then
			CloseWindow("NewExterior_HairStyle", true)
		end
		if(IsWindowShow("NewExterior_Ride")) then
			CloseWindow("NewExterior_Ride", true)
		end
		if(IsWindowShow("NewExterior_Weapon_Levelup")) then
			CloseWindow("NewExterior_Weapon_Levelup", true)
		end
		if(IsWindowShow("NewExterior_Weapon")) then
			CloseWindow("NewExterior_Weapon", true)
		end
		if(IsWindowShow("NewExterior_DressBox")) then
			CloseWindow("NewExterior_DressBox", true)
		end
		if(IsWindowShow("SelfEquip")) then
			CloseWindow("SelfEquip", true)
		end
		local tempmd = Get_XParam_STR(0)
		--设置数据
		for i = 1, 15 do
			g_Huanse_IconVisList[i] = tonumber(string.sub(tempmd,i,i))
		end			
		NewExterior_PetSoul_SetPosition()
		NewExterior_PetSoul_CloseSameGroupWindow()
		this:Show()
		NewExterior_PetSoul_Show()
		return
	end
	if event == "UI_COMMAND" and tonumber(arg0) == 122032413 then
		if GetGameMissionData("MD_EXTERIOR") == 6 then
			NewExterior_PetSoul_Show()
		end
		return
	end		
	if event == "UI_COMMAND" and tonumber(arg0) == 9900144 then
		LifeAbility:Wear_Equip_VisualID(Get_XParam_INT(0),Get_XParam_INT(1))
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("RideSysteam")
			Set_XSCRIPT_ScriptID(830243)
			Set_XSCRIPT_Parameter(0,8);
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()		
	end	
	if event == "ON_SCENE_TRANS" or event == "ON_SERVER_TRANS" or event == "HIDE_ON_SCENE_TRANSED" then
		this:Hide()
	end
	
	-- 游戏窗口尺寸发生了变化 or 游戏分辨率发生了变化
	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		NewExterior_PetSoul_Frame:SetProperty("UnifiedPosition", g_NewExterior_PetSoul_UnifiedPosition)
	end

end

function NewExterior_PetSoul_Show()
	--列表
	NewExterior_PetSoul_UpdateList()
	--幻色
	-- NewExterior_PetSoul_ShowHuanSeBtn()
	--左侧
	NewExterior_PetSoul_UpdateLeftBtn()
	--模型
	NewExterior_PetSoul_UpdateObj()	
	
	--新增部分内容
	local curPossessionPetIndex = DataPool:GetPlayerMission_DataRound(510)
	if curPossessionPetIndex > 0 then
		
		NewExterior_PetSoul_SuperListNow:Show()
		NewExterior_PetSoul_SuperListNowText1:Show()
		NewExterior_PetSoul_SuperListNowText2:Show()
		NewExterior_PetSoul_SuperListNowText3:Show()
		NewExterior_PetSoul_Frame_RightClientBK:Hide()
		
		local strName,iQual,iBloodRank,curPetSoulid,strIcon = NewExterior_PetSoul_Data()
		if curPetSoulid ~= 0 and icons ~= "" then
			local strImage = GetIconFullName(strIcon)
			NewExterior_PetSoul_SuperListNow:SetToolTip(strName)
			NewExterior_PetSoul_SuperListNow:SetProperty("NormalImage", strImage)
			NewExterior_PetSoul_SuperListNow:SetProperty("HoverImage", strImage)
			NewExterior_PetSoul_SuperListNow:SetProperty("Empty", "False")
			NewExterior_PetSoul_SuperListNow:SetProperty("UseDefaultTooltip", "True")
		end
		local strTemp = string.format("名称：%s", strName)
		NewExterior_PetSoul_SuperListNowText1:SetText(strTemp)
		local strQual = ""
		if iQual == 0 or iQual == 1 or iQual == 2 then
			strQual = g_QualStr[iQual + 1]
		end
		strTemp = string.format("品阶：%s", strQual)
		NewExterior_PetSoul_SuperListNowText2:SetText(strTemp)
		
		strTemp = string.format("魂境：%s", tostring(iBloodRank))
		NewExterior_PetSoul_SuperListNowText3:SetText(strTemp)
	else
		NewExterior_PetSoul_SuperListNow:Hide()
		NewExterior_PetSoul_SuperListNowText1:Hide()
		NewExterior_PetSoul_SuperListNowText2:Hide()
		NewExterior_PetSoul_SuperListNowText3:Hide()
		NewExterior_PetSoul_Frame_RightClientBK:Show()
	end
end


function NewExterior_PetSoul_UpdateLeftBtn()	
	--时装
	if GetGameMissionData("MD_DRESS") ~= 0 then
		NewExterior_PetSoul_Dress_ActionImg:Show()
		NewExterior_PetSoul_Dress_LockImg:Show()
		local _,Icons = LifeAbility : GetPrescr_Material(GetGameMissionData("MD_DRESS"))
		local strImage = GetIconFullName(Icons)
		NewExterior_PetSoul_Dress_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_PetSoul_Dress_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_PetSoul_Dress_LeftBtn:SetProperty("PushedImage", strImage)
		NewExterior_PetSoul_Dress_LeftBtn:SetProperty("Empty", "False")
		NewExterior_PetSoul_Weapon_LeftBtn:SetProperty("UseDefaultTooltip", "False")
	else
		NewExterior_PetSoul_Dress_LeftBtn:SetProperty("NormalImage", "")
		NewExterior_PetSoul_Dress_LeftBtn:SetProperty("HoverImage", "")
		NewExterior_PetSoul_Dress_LeftBtn:SetProperty("PushedImage", "")
		local theAction = EnumAction(2, "equip");
		NewExterior_PetSoul_Dress_LeftBtn:SetActionItem(theAction:GetID())
		NewExterior_PetSoul_Dress_LockImg:Hide()
		NewExterior_PetSoul_Dress_ActionImg:Hide()	
	end	
	--坐骑
	theAction = DataPool:GetPlayerMission_DataRound(362)
	NewExterior_PetSoul_Ride_LockImg:Hide()
	NewExterior_PetSoul_Ride_ActionImg:Hide()
	if theAction ~= 0 then
		local strIcon = LuaFnGetExteriorRideInfo(theAction,"Icon")
		local strName 	= LuaFnGetExteriorRideInfo(theAction, "Name")
		local strImage = GetIconFullName(strIcon)
		NewExterior_PetSoul_Ride_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_PetSoul_Ride_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_PetSoul_Ride_LeftBtn:SetProperty("Empty", "False")
		NewExterior_PetSoul_Ride_LeftBtn:SetProperty("UseDefaultTooltip", "True")
		NewExterior_PetSoul_Ride_LeftBtn:SetToolTip(strName)
	else
		NewExterior_PetSoul_Ride_LeftBtn:SetProperty("NormalImage", "")
		NewExterior_PetSoul_Ride_LeftBtn:SetProperty("HoverImage", "")	
	end
	if GetGameMissionData("MD_RIDA") ~= 0 then
		NewExterior_PetSoul_Ride_ActionImg:Show()
		NewExterior_PetSoul_Ride_LockImg:Show()
		strIcon 	= LuaFnGetExteriorRideInfo(GetGameMissionData("MD_RIDA"), "Icon")
		strImage = GetIconFullName(strIcon)
		strName 	= LuaFnGetExteriorRideInfo(GetGameMissionData("MD_RIDA"), "Name")
		NewExterior_PetSoul_Ride_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_PetSoul_Ride_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_PetSoul_Ride_LeftBtn:SetProperty("Empty", "False")
		NewExterior_PetSoul_Ride_LeftBtn:SetProperty("UseDefaultTooltip", "True")
		NewExterior_PetSoul_Ride_LeftBtn:SetToolTip(strName)
	end		
	--幻武
	cacheExteriorID = DataPool:GetPlayerMission_DataRound(389)
	if cacheExteriorID ~= 0 then
		local strName 	= LuaFnGetExteriorWeaponInfo(cacheExteriorID, "Name")
		local strIcon 	= LuaFnGetExteriorWeaponInfo(cacheExteriorID, "Icon")
		local strImage = GetIconFullName(strIcon)
		NewExterior_PetSoul_Weapon_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_PetSoul_Weapon_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_PetSoul_Weapon_LeftBtn:SetProperty("Empty", "False")
		NewExterior_PetSoul_Weapon_LeftBtn:SetProperty("UseDefaultTooltip", "True")
		local strTemp = strName
		NewExterior_PetSoul_Weapon_LeftBtn:SetToolTip(strTemp)
	else
		NewExterior_PetSoul_Weapon_LeftBtn:SetProperty("HoverImage", "")
		NewExterior_PetSoul_Weapon_LeftBtn:SetProperty("NormalImage", "")
	end
	NewExterior_PetSoul_Weapon_ActionImg:Hide()
	NewExterior_PetSoul_Weapon_LockImg:Hide()
	if GetGameMissionData("MD_WEAPON") > 0 then
		NewExterior_PetSoul_Weapon_ActionImg:Show()
		NewExterior_PetSoul_Weapon_LockImg:Show()
		strIcon 	= LuaFnGetExteriorWeaponInfo(GetGameMissionData("MD_WEAPON"), "Icon")
		strName 	= LuaFnGetExteriorWeaponInfo(GetGameMissionData("MD_WEAPON"), "Name")
		strImage = GetIconFullName(strIcon)
		NewExterior_PetSoul_Weapon_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_PetSoul_Weapon_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_PetSoul_Weapon_LeftBtn:SetToolTip(strName)
	end		
	-- 附体
	cacheExteriorID = DataPool:GetPlayerMission_DataRound(387)
	if cacheExteriorID > 0 then
		local strName,iQual,iBloodRank,curPetSoulid,strIcon = NewExterior_PetSoul_DataShow(cacheExteriorID)
		strImage = GetIconFullName(strIcon)
		NewExterior_PetSoul_PetSoul_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_PetSoul_PetSoul_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_PetSoul_PetSoul_LeftBtn:SetToolTip(strName)
		NewExterior_PetSoul_PetSoul_LeftBtn:SetProperty("Empty", "False")
		NewExterior_PetSoul_PetSoul_LeftBtn:SetProperty("UseDefaultTooltip", "True")
	else
		NewExterior_PetSoul_PetSoul_LeftBtn:SetProperty("NormalImage", "")
		NewExterior_PetSoul_PetSoul_LeftBtn:SetProperty("HoverImage", "")	
	end
	NewExterior_PetSoul_PetSoul_LockImg:Hide()
	NewExterior_PetSoul_PetSoul_ActionImg:Hide()
	local TryPoss = GetGameMissionData("MD_PETPOSS")
	if TryPoss ~= 0 then
		TryPoss = math.mod(TryPoss,100)
		local strName,strIcon,iQual = LuaFnGetExteriorPossInfo(TryPoss)
		strImage = GetIconFullName(strIcon)
		NewExterior_PetSoul_PetSoul_LockImg:Show()
		NewExterior_PetSoul_PetSoul_ActionImg:Show()
		NewExterior_PetSoul_PetSoul_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_PetSoul_PetSoul_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_PetSoul_PetSoul_LeftBtn:SetToolTip(strName)
		NewExterior_PetSoul_PetSoul_LeftBtn:SetProperty("Empty", "False")
		NewExterior_PetSoul_PetSoul_LeftBtn:SetProperty("UseDefaultTooltip", "True")
	end
	--脸型
	cacheExteriorID = DataPool:Get_MyFaceStyle()
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local _,_,_,IconFile,_,StyleName = DataPool : Change_MyFaceStyle_Item(cacheExteriorID);
		local strImage = GetIconFullName(IconFile)			
		NewExterior_PetSoul_FaceStyle_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_PetSoul_FaceStyle_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_PetSoul_FaceStyle_LeftBtn:SetProperty("Empty", "False")
		NewExterior_PetSoul_FaceStyle_LeftBtn:SetProperty("UseDefaultTooltip", "True")
		NewExterior_PetSoul_FaceStyle_ActionImg:Hide()
		NewExterior_PetSoul_FaceStyle_LockImg:Hide()
		local strTemp = StyleName
		NewExterior_PetSoul_FaceStyle_LeftBtn:SetToolTip(strTemp)
	end
	if GetGameMissionData("MD_FACE") ~= 0 then
		NewExterior_PetSoul_FaceStyle_ActionImg:Show()
		NewExterior_PetSoul_FaceStyle_LockImg:Show()
		strIcon 	= LuaFnGetExteriorFaceInfo(GetGameMissionData("MD_FACE"), "Icon")
		strName 	= LuaFnGetExteriorFaceInfo(GetGameMissionData("MD_FACE"), "Name")
		strImage = GetIconFullName(strIcon)
		NewExterior_PetSoul_FaceStyle_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_PetSoul_FaceStyle_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_PetSoul_FaceStyle_LeftBtn:SetProperty("Empty", "False")
		NewExterior_PetSoul_FaceStyle_LeftBtn:SetProperty("UseDefaultTooltip", "True")
		NewExterior_PetSoul_FaceStyle_LeftBtn:SetToolTip(strName)
	end	
	--发型
	cacheExteriorID = DataPool : Get_MyHairStyle()
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local strName 	= LuaFnGetExteriorHairInfo(cacheExteriorID, "Name")
		local strIcon 	= LuaFnGetExteriorHairInfo(cacheExteriorID, "Icon")
		local strImage = GetIconFullName(strIcon)		
		NewExterior_PetSoul_HairStyle_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_PetSoul_HairStyle_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_PetSoul_HairStyle_LeftBtn:SetProperty("Empty", "False")
		NewExterior_PetSoul_HairStyle_LeftBtn:SetProperty("UseDefaultTooltip", "True")
		NewExterior_PetSoul_HairStyle_LockImg:Hide()
		NewExterior_PetSoul_HairStyle_ActionImg:Hide()
		local strTemp = strName
		NewExterior_PetSoul_HairStyle_LeftBtn:SetToolTip(strTemp)
	end
	if GetGameMissionData("MD_HAIR") ~= 0 then
		NewExterior_PetSoul_HairStyle_LockImg:Show()
		NewExterior_PetSoul_HairStyle_ActionImg:Show()
		strIcon 	= LuaFnGetExteriorHairInfo(GetGameMissionData("MD_HAIR"), "Icon")
		strName 	= LuaFnGetExteriorHairInfo(GetGameMissionData("MD_HAIR"), "Name")
		strImage = GetIconFullName(strIcon)
		NewExterior_PetSoul_HairStyle_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_PetSoul_HairStyle_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_PetSoul_HairStyle_LeftBtn:SetProperty("Empty", "False")
		NewExterior_PetSoul_HairStyle_LeftBtn:SetProperty("UseDefaultTooltip", "True")
		NewExterior_PetSoul_HairStyle_LeftBtn:SetToolTip(strName)
	end	
	--头像
	local strHeadTip = ""
	cacheExteriorID = DataPool : Get_MyHeadStyle()
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local strName 	= LuaFnGetExteriorPortraitInfo(cacheExteriorID, "Name")
		local strIcon 	= LuaFnGetExteriorPortraitInfo(cacheExteriorID, "Icon")
		local strImage = GetIconFullName(strIcon)		
		NewExterior_PetSoul_PlayerFrame_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_PetSoul_PlayerFrame_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_PetSoul_PlayerFrame_LeftBtn:SetProperty("Empty", "False")
		NewExterior_PetSoul_PlayerFrame_LeftBtn:SetProperty("UseDefaultTooltip", "True")
		NewExterior_PetSoul_PlayerFrame_LockImg:Hide()
		NewExterior_PetSoul_PlayerFrame_ActionImg:Hide()
		local strTemp = strName
		NewExterior_PetSoul_PlayerFrame_LeftBtn:SetToolTip(strTemp)	
	end	
	if GetGameMissionData("MD_HEAD") ~= 0 then
		NewExterior_PetSoul_PlayerFrame_LockImg:Show()
		NewExterior_PetSoul_PlayerFrame_ActionImg:Show()
		strIcon 	= LuaFnGetExteriorPortraitInfo(GetGameMissionData("MD_HEAD"), "Icon")
		strName 	= LuaFnGetExteriorPortraitInfo(GetGameMissionData("MD_HEAD"), "Name")
		strImage = GetIconFullName(strIcon)
		NewExterior_PetSoul_PlayerFrame_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_PetSoul_PlayerFrame_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_PetSoul_PlayerFrame_LeftBtn:SetProperty("Empty", "False")
		NewExterior_PetSoul_PlayerFrame_LeftBtn:SetProperty("UseDefaultTooltip", "True")
		NewExterior_PetSoul_PlayerFrame_LeftBtn:SetToolTip(strName)
	end	
	--头像框
	-- local headlace = DataPool:GetPlayerMission_DataRound(288)
	-- if headlace > 0 then
		-- local nFrameImg = Lua_GetHeadFrameData(headlace)
		-- nFrameImg = GetIconFullName(nFrameImg)
		-- NewExterior_PetSoul_PlayerFrame_Mask:SetProperty("Image",nFrameImg)
	-- else
		-- NewExterior_PetSoul_PlayerFrame_Mask:SetProperty("Image","set:CharHeadFrame1 image:CharHeadFrame1_DefaultPlayer")
	-- end
end

function LuaFnGetExteriorPossInfo(nIndex)
	local strName,strIcon,iQual
	strName = LuaFnGetFuTiListData("Name",nIndex)
	strIcon = LuaFnGetFuTiListData("Icon",nIndex)
	iQual = LuaFnGetFuTiListData("Quality",nIndex)
	local nSoulID = {{39995376,39995377,39995378,39995379,39995380},{39995371,39995372,39995373,39995374,39995375},{39995366,39995367,39995368,39995369,39995370}}
	for i = 1,3 do
		for j = 1,5 do
			if nSoulID[i][j] == iQual then
				iQual = i-1
				break
			end
		end
	end
	return strName,strIcon,iQual
end

function NewExterior_PetSoul_UpdateList()
	local curPossessionPetIndex = DataPool:GetPlayerMission_DataRound(510)
	local curPossData = DataPool:GetPlayerMission_DataRound(387)
	for i = 1,15 do
		PetPossJianList[i].ActionEqu:Hide()
		PetPossJianList[i].mark:Hide()
		PetPossJianList[i].ActionTry:Hide()
		local strName,strIcon,iQual = LuaFnGetExteriorPossInfo(i)
		local strImage = GetIconFullName(strIcon)
		local NowPossID = math.floor(curPossData/1000)
		local strQual = ""
		if iQual == 0 or iQual == 1 or iQual == 2 then
			strQual = g_QualStr[iQual + 1]
		end
		if i < 6 then
			PetPossJianList[i].Button:SetToolTip(strQual.."#r"..strName.."#r#{SHRH_20220427_03}")
		else
			if g_Huanse_IconVisList[i] == 1 then
				PetPossJianList[i].Button:SetToolTip(strQual.."#r"..strName.."#r#{SHRH_20220427_03}")
			else
				PetPossJianList[i].Button:SetToolTip(strQual.."#r"..strName.."#r#{SHRH_20220427_70}")
			end		
		end
		PetPossJianList[i].Button:SetProperty("Empty","False")
		PetPossJianList[i].Button:SetProperty("UseDefaultTooltip","True")
		PetPossJianList[i].Button:SetProperty("NormalImage", strImage)
		PetPossJianList[i].Button:SetProperty("HoverImage", strImage)
		if g_Huanse_IconVisList[i] ~= 1 then
			PetPossJianList[i].Reg:Show()
		else
			PetPossJianList[i].Reg:Hide()
		end
		if curPossessionPetIndex == 0 and iQual == 0 then
			PetPossJianList[i].mark:Show()
			PetPossJianList[i].Reg:Hide()
			PetPossJianList[i].ActionEqu:Hide()
		elseif curPossessionPetIndex ~= 0 and iQual == 0 then
			PetPossJianList[i].mark:Hide()
			PetPossJianList[i].Reg:Hide()
			PetPossJianList[i].ActionEqu:Hide()
		end
		local ListDataID = LuaFnGetFuTiListData("DataID",i)
		--数据结构忘了考虑到这个问题了，这里修复下
		if NowPossID > 15 then
			NowPossID = NowPossID -5
			if NowPossID == ListDataID then
				PetPossJianList[i].Reg:Hide()
				PetPossJianList[i].Button:SetToolTip(strQual.."#r"..strName.."#r#{SHRH_20220427_03}")
				PetPossJianList[i].ActionEqu:Show()
			end
		else
			if NowPossID == ListDataID then
				PetPossJianList[i].Reg:Hide()
				PetPossJianList[i].Button:SetToolTip(strQual.."#r"..strName.."#r#{SHRH_20220427_03}")
				PetPossJianList[i].ActionEqu:Show()
			end
		end
	end
end

function NewExterior_PetSoul_ZoomIn()
	NewExterior_PetSoul_FakeObject : SetFakeObject( "Player_Head" );
end

function NewExterior_PetSoul_ZoomOut()
	NewExterior_PetSoul_FakeObject : SetFakeObject( "EquipChange_Player" );
end

function NewExterior_PetSoul_UpdateObj()
	NewExterior_PetSoul_FakeObject : SetFakeObject( "" );
	NewExterior_PetSoul_FakeObject : SetFakeObject( "EquipChange_Player" );
	FakeObj_SetCamera( "EquipChange_Player", 1,1);
	FakeObj_SetCamera( "EquipChange_Player", 2,8);
	FakeObj_SetCamera( "EquipChange_Player", 3,0.28);
end

function NewExterior_PetSoul_ShowHuanSeBtn()
	
	for i = 1, 9 do			
		g_FutiVisualBtn[i]:Hide()
		g_FutiVisualBtn[i]:SetProperty("NormalImage", "")
		g_FutiVisualBtn[i]:SetProperty("HoverImage", "")
		g_FutiVisualBtn[i]:SetToolTip("")
		g_FutiVisualBtn[i]:SetPushed(0)
		g_FutiVisualTip[i]:Hide()
		g_FutiVisualDef[i]:Hide()
	end
	for i = 1,9 do
		if g_CurSelExteriorID == 1 then
			if i == 2 then
				break
			end
		end
		local strImage,strName = LuaFnGetExteriorPetPossLevel(g_CurSelExteriorID,i)	
		g_FutiVisualBtn[i]:SetProperty("NormalImage", strImage)
		g_FutiVisualBtn[i]:SetProperty("HoverImage", strImage)
		g_FutiVisualBtn[i]:SetProperty("Empty", "False")
		g_FutiVisualBtn[i]:SetProperty("UseDefaultTooltip", "True")
		g_FutiVisualBtn[i]:SetToolTip(strName)
		g_FutiVisualBtn[i]:Show()
	end
end

function NewExterior_PetSoul_UpdateOpBtn()

end

function NewExterior_PetSoul_ItemClicked(nIndex)
	g_CurSelExteriorID = nIndex
	for j = 1,9 do
		if g_Huanse_IconVisList[nIndex][j] == 1 then
			g_FutiVisualLock[j]:Hide()
		else
			g_FutiVisualLock[j]:Show()
		end
	end		
	NewExterior_PetSoul_ShowHuanSeBtn()
	NewExterior_PetSoul_SetHuanSeSelected(1)
end

function NewExterior_PetSoul_ItemMouseMove(nIndex)

end

function NewExterior_PetSoul_RankClicked(index)
	if g_CurSelExteriorID == 0 then
		NewExterior_PetSoul_UpdateRankButton()
		NewExterior_PetSoul_SetHuanSeSelected(g_CurSelExteriorID)
		return
	end
	if g_CurPossVisualIndex ~= index then
		g_CurPossVisualIndex = index
		NewExterior_PetSoul_UpdateRankButton()
		NewExterior_PetSoul_SetHuanSeSelected(g_CurSelExteriorID)
	end
end

function NewExterior_PetSoul_UpdateRankButton()
	for i = 1, 3 do
		
		if g_CurSelExteriorID == 0 then
			g_RankButtons[i]:SetCheck(0)
			g_RankButtons[i]:Disable()
		else
			g_RankButtons[i]:Enable()
			if i == g_CurPossVisualIndex then
				g_RankButtons[i]:SetCheck(1)
			else
				g_RankButtons[i]:SetCheck(0)
			end
		end		
	end
end

function NewExterior_PetSoul_SetHuanSeSelected(nIndex)
	g_CurSelExteriorID = nIndex
	for i = 1, 15 do		
		if i == nIndex or g_CurSelExteriorID == i then
			PetPossJianList[i].Button:SetPushed(1)
			PetPossJianList[i].ActionTry:Show()
		else
			PetPossJianList[i].Button:SetPushed(0)	
			PetPossJianList[i].ActionTry:Hide()
		end
	end
	local nID = LuaFnGetFuTiListData("POSSWG",nIndex,g_CurPossVisualIndex)
	--外观试用
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("RideSysteam")
		Set_XSCRIPT_ScriptID(830243)
		Set_XSCRIPT_Parameter(0,7);
		Set_XSCRIPT_Parameter(1,nID);
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()
	--设置试用
	SetGameMissionData("MD_PETPOSS",nIndex)
	local strName,strIcon,iQual = LuaFnGetExteriorPossInfo(nIndex)
	local strImage = GetIconFullName(strIcon)
	NewExterior_PetSoul_PetSoul_LeftBtn:SetProperty("NormalImage", strImage)
	NewExterior_PetSoul_PetSoul_LeftBtn:SetProperty("HoverImage", strImage)
	NewExterior_PetSoul_PetSoul_LeftBtn:SetProperty("Empty", "False")
	NewExterior_PetSoul_PetSoul_LeftBtn:SetToolTip(strName)		
	NewExterior_PetSoul_PetSoul_ActionImg:Show()		
	NewExterior_PetSoul_PetSoul_LockImg:Show()		
end

function NewExterior_PetSoul_HusanSeClicked(nIndex)
	g_CurVisualIndex = nIndex
	NewExterior_PetSoul_SetHuanSeSelected(nIndex)	
end

function NewExterior_PetSoul_TryExterior()
	SaveAllChange()
	ClearSaveAllChange()
end

function NewExterior_PetSoul_TakeOffRide()
    Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("RideSysteam");
		Set_XSCRIPT_ScriptID(830243);
		Set_XSCRIPT_Parameter(0,13);
		Set_XSCRIPT_ParamCount(1);
    Send_XSCRIPT();	
	NewExterior_PetSoul_Ride_LeftBtn:SetProperty("PushedImage", "")
	NewExterior_PetSoul_Ride_LeftBtn:SetProperty("NormalImage", "")
	NewExterior_PetSoul_Ride_LeftBtn:SetProperty("HoverImage", "")
	NewExterior_PetSoul_Ride_LeftBtn:SetToolTip("")	
end

function NewExterior_PetSoul_TakeOffWeapon()
   Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("RideSysteam");
		Set_XSCRIPT_ScriptID(830243);
		Set_XSCRIPT_Parameter(0,12);
		Set_XSCRIPT_ParamCount(1);
    Send_XSCRIPT();	
	NewExterior_PetSoul_Weapon_LeftBtn:SetProperty("PushedImage", "")
	NewExterior_PetSoul_Weapon_LeftBtn:SetProperty("NormalImage", "")
	NewExterior_PetSoul_Weapon_LeftBtn:SetProperty("HoverImage", "")
	NewExterior_PetSoul_Weapon_LeftBtn:SetToolTip("")	
end

function NewExterior_PetSoul_RemovePreview()
	ClearSaveAllChange()
	NewExterior_PetSoul_Show()
end

function NewExterior_PetSoul_Goto()
	PushDebugMessage("请前往苏州（92，134）#R云宸宸#I处激活")
end

function NewExterior_PetSoul_CloseClick()	
	NewExterior_PetSoul_FakeObject : SetFakeObject( "" );
	NewExterior_PetSoul_SavePosition()
	this:Hide()
end

function NewExterior_PetSoul_OnHidden()
	NewExterior_PetSoul_FakeObject : SetFakeObject( "" );
	if IsWindowShow("NewExterior_DressBox") 
		or IsWindowShow("NewExterior_Ride") 
		or IsWindowShow("NewExterior_Weapon")  
		or IsWindowShow("NewExterior_Facestyle") 
		or IsWindowShow("NewExterior_HairStyle") 
		or IsWindowShow("NewExterior_PlayerFrame") then
	end	
end

function NewExterior_PetSoul_CleanUp_LeftButton()
	NewExterior_PetSoul_Dress_LeftBtn:SetActionItem(-1)
	
	local ctrl_list = {
		[1] = NewExterior_PetSoul_Weapon_LeftBtn,
		[2] = NewExterior_PetSoul_PetPossJian_LeftBtn,
		[3] = NewExterior_PetSoul_FaceStyle_LeftBtn,
		[4] = NewExterior_PetSoul_HairStyle_LeftBtn,
		[5] = NewExterior_PetSoul_PlayerFrame_LeftBtn,
		[6] = NewExterior_PetSoul_Ride_LeftBtn,	
	}
	
	for i = 1 ,6 do
		ctrl_list[i]:SetProperty("Empty", "False")
		ctrl_list[i]:SetProperty("UseDefaultTooltip", "True")
		ctrl_list[i]:SetProperty("NormalImage", "")
		ctrl_list[i]:SetProperty("HoverImage", "")
		ctrl_list[i]:SetToolTip("")
	end
	
	NewExterior_PetSoul_PlayerFrame_Mask:SetProperty("Image", "")
	
	NewExterior_PetSoul_Dress_ActionImg:Hide()
	NewExterior_PetSoul_Weapon_ActionImg:Hide()
	NewExterior_PetSoul_PetPossJian_ActionImg:Hide()
	NewExterior_PetSoul_FaceStyle_ActionImg:Hide()
	NewExterior_PetSoul_HairStyle_ActionImg:Hide()
	NewExterior_PetSoul_PlayerFrame_ActionImg:Hide()
	NewExterior_PetSoul_Ride_ActionImg:Hide()
	
	NewExterior_PetSoul_Dress_LockImg:Hide()
	NewExterior_PetSoul_Weapon_LockImg:Hide()
	NewExterior_PetSoul_PetPossJian_LockImg:Hide()
	NewExterior_PetSoul_FaceStyle_LockImg:Hide()
	NewExterior_PetSoul_HairStyle_LockImg:Hide()
	NewExterior_PetSoul_PlayerFrame_LockImg:Hide()
	NewExterior_PetSoul_Ride_LockImg:Hide()
	
end

function NewExterior_PetSoul_FakeObject_TurnLeft(idx)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		--向左旋转开始
		if(idx == 1) then
			NewExterior_PetSoul_FakeObject:RotateBegin(-0.3);
		--向左旋转结束
		else
			NewExterior_PetSoul_FakeObject:RotateEnd();
		end
	end
end

function NewExterior_PetSoul_FakeObject_TurnRight(idx)	
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		--向右旋转开始
		if(idx == 1) then
			NewExterior_PetSoul_FakeObject:RotateBegin(0.3);
		--向右旋转结束
		else
			NewExterior_PetSoul_FakeObject:RotateEnd();
		end
	end
end

function NewExterior_PetSoul_UpdateCamera()
	local sex = GetMySelfRaceId()
	if sex ~= 0 and sex ~= 1 then 
		return
	end
		
	if g_Distance < 1 or g_Distance > g_Distance_Max then
		return
	end
	
	local fHeight, fDistance, fPitch = NewExterior_PetSoul_FakeObject:GetCameraEx()
	fHeight = g_CameraPosition[sex][g_Distance].fHeight
	fDistance = g_CameraPosition[sex][g_Distance].fDistance
	fPitch = g_CameraPosition[sex][g_Distance].fPitch
	NewExterior_PetSoul_FakeObject:SetCameraEx(fHeight, fDistance, fPitch)
end

--右键取下时装
function NewExterior_PetSoul_ActionToDressBox()

end
--时装
function NewExterior_PetSoul_OpenFashion()
	NewExterior_PetSoul_SavePosition()
	LuaFnAskOpenExterior(1)
end
--幻武
function NewExterior_PetSoul_OpenWeapon()
	NewExterior_PetSoul_SavePosition()
	LuaFnAskOpenExterior(2)
end
--附体
function NewExterior_PetSoul_OpenFuti()
end
--坐骑
function NewExterior_PetSoul_OpenRide()
	NewExterior_PetSoul_SavePosition()
	LuaFnAskOpenExterior(3)
end
--发型
function NewExterior_PetSoul_OpenHair()
	NewExterior_PetSoul_SavePosition()	
	LuaFnAskOpenExterior(5)
end
--脸型
function NewExterior_PetSoul_OpenFace()
	NewExterior_PetSoul_SavePosition()	
	LuaFnAskOpenExterior(4)
end
--头像
function NewExterior_PetSoul_OpenPortrait()
	NewExterior_PetSoul_SavePosition()	
	LuaFnAskOpenExterior(7)
end

function NewExterior_PetSoul_OpenInfant()
	NewExterior_PetSoul_SavePosition()
	LuaFnInitExteriorFashionList(2, 1)
end

function NewExterior_PetSoul_CloseSameGroupWindow()
	CloseWindow("SelfEquip", true)
	CloseWindow("NewExterior_Ride", true)
	CloseWindow("NewExterior_Weapon", true)
	--CloseWindow("NewExterior_PetSoul", true)
	CloseWindow("NewExterior_Facestyle", true)
	CloseWindow("NewExterior_HairStyle", true)
	CloseWindow("NewExterior_PlayerFrame", true)
	CloseWindow("NewExterior_DressBox", true)
end

function NewExterior_PetSoul_SavePosition()
	NewExterior_PetSoul_FakeObject:SetFakeObject("")
	Variable:SetVariable("ExteriorUnionPos", NewExterior_PetSoul_Frame:GetProperty("UnifiedPosition"), 1)
end

function NewExterior_PetSoul_SetPosition()
	local nExteriorUnionPos = Variable:GetVariable("ExteriorUnionPos")
	if nExteriorUnionPos ~= nil then
		NewExterior_PetSoul_Frame:SetProperty("UnifiedPosition", nExteriorUnionPos)
	end
end
function NewExterior_PetSoul_GetRHDListIndex(rhd)

	if rhd >=0 and rhd <=2 then
		return 0
	elseif rhd >= 3 and rhd <= 5 then
		return 1
	elseif rhd >= 5 and rhd <= 7 then
		return 2
	elseif rhd >= 8 and rhd <= 9 then
		return 3
	end
	return 4
end

function NewExterior_PetSoul_ShowFashionWeaponCheckButton()
	-- local IsDisplay = SystemSetup:LuaFnIsFashionDisplay()
	-- NewExterior_PetSoul_Dress_Type:SetCheck(IsDisplay)
	
	-- IsDisplay = SystemSetup:LuaFnIsExteriorWeaponDisplay()
	-- NewExterior_PetSoul_Weapon_Type:SetCheck(IsDisplay)
end

function NewExterior_PetSoul_FashionDisplay()
	-- local IsDisplay = SystemSetup:LuaFnIsFashionDisplay()
	-- if IsDisplay == 1 then
		-- NewExterior_PetSoul_Dress_Type:SetCheck(0)
		-- SystemSetup:LuaFnCloseFashionDisplay(1)
	-- else
		-- NewExterior_PetSoul_Dress_Type:SetCheck(1)
		-- SystemSetup:LuaFnCloseFashionDisplay(0)
	-- end	
end

function NewExterior_PetSoul_ExteriorWeaponDisplay()
	-- local IsDisplay = SystemSetup:LuaFnIsExteriorWeaponDisplay()
	-- if IsDisplay == 1 then
		-- NewExterior_PetSoul_Weapon_Type:SetCheck(0)
		-- SystemSetup:LuaFnCloseExteriorWeaponDisplay(1)
	-- else
		-- NewExterior_PetSoul_Weapon_Type:SetCheck(1)
		-- SystemSetup:LuaFnCloseExteriorWeaponDisplay(0)
	-- end	
end

--!!!reloadscript =NewExterior_PetSoul