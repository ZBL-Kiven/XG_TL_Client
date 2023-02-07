--!!!reloadscript =NewExterior_DressBox
--ȡ�������Դ������Ǽ�ʱ��Ч ����Ҫ����
local EXTERIORFILTTING_TOTALKIND = 6;
local g_NewExterior_DressBox_UnifiedPosition = ""
local g_CameraHeight = 1;     --��Ӱ���߶�
local g_CameraDistance = 2;   --��Ӱ������
local g_CameraPitch = 3;      --��Ӱ���Ƕ�

local g_TargetExteriorIndex = 0		--��λ�������������1��ʼ
local g_TargetExteriorID = 0		--��λ�����ID

local g_NeedChangeScrollSize = 1

local g_CurSelExteriorIndex = 0		--��ǰѡ��������������1��ʼ
local g_CurSelExteriorID = 0		--��ǰѡ������ID����1��ʼ
local g_actionVisualID = 0

local g_Distance = 1
local g_Distance_Ori = 2
local g_Distance_Max = 4
local g_InitList = 0
local m_PlayerfashionDepotType = 1 	--�ֿ����� 1 ���ʱװ�ֿ� 2 ��Ůʱװ�ֿ�
local g_ExteriorType = 8 --ʱװ
local g_MaxBarNum = 200
local g_BarList = {}
local g_DecoWeapon_Display = 0
local g_NowPossVisual = 0
local g_DressPage = 0
g_PlayerFashionInfoList = {}
g_PlayerString = ""

local g_ActionButtonList = {}

local g_SpecialFashionCamera = {
-- �һ���
[1] = {startid = 10126405, endid = 10126420, fHeight = 1.9, fDistance = 20, fPitch = -1, timecount = 21000},
-- ǧ�ｭɽ
[2] = {startid = 10126295, endid = 10126310, fHeight = -1, fDistance = -1, fPitch = -1, timecount = 42000},
}
local g_DressBox_SuperListItem = {}
--=========
--PreLoad==
--=========
function NewExterior_DressBox_PreLoad()	
	this:RegisterEvent("ON_SCENE_TRANS",false)
	this:RegisterEvent("ON_SERVER_TRANS",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	this:RegisterEvent("ADJEST_UI_POS",false)	
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("UI_COMMAND")
	
end

--=========
--OnLoad
--=========
function NewExterior_DressBox_OnLoad()
	g_NewExterior_DressBox_UnifiedPosition = NewExterior_DressBox_Frame:GetProperty("UnifiedPosition")
	
	g_ActionButtonList = {
		NewExterior_DressBox_FashionAction_MidBtn1,
		NewExterior_DressBox_FashionAction_MidBtn2,
		NewExterior_DressBox_FashionAction_MidBtn3,
		NewExterior_DressBox_FashionAction_MidBtn4,
		NewExterior_DressBox_FashionAction_MidBtn5,
	}
	for i = 1,35 do
		table.insert(g_DressBox_SuperListItem,{Button = _G[string.format("NewExterior_DressBox_SuperListItemAction_%d",i)],ActionTry = _G[string.format("NewExterior_DressBox_SuperListItemActionTry_%d",i)],ActionEqu=_G[string.format("NewExterior_DressBox_SuperListItemActionEqu_%d",i)]})
	end
end

--=========
--OnEvent
--=========
function NewExterior_DressBox_OnEvent(event)
	
	if event == "UI_COMMAND" and tonumber(arg0) == 202107291 then
		SetGameMissionData("MD_EXTERIOR",1)
		g_PlayerFashionInfoList = {}
		g_PlayerFashionInfoList = Split(Get_XParam_STR(0),",")
		g_CurSelExteriorIndex = 0
		g_DressPage = 0
		if this:IsVisible() then
			this:Hide()
		else
			--�ر�Ԫ���̵���ؽ���
			if IsWindowShow("VIP_Shop") then
				CloseWindow("VIP_Shop", true)
			end
			if(IsWindowShow("YuanbaoShop")) then
				CloseWindow("YuanbaoShop", true)
			end
			if(IsWindowShow("ShowShop")) then
				CloseWindow("ShowShop", true)
			end
			if(IsWindowShow("XuanShop")) then
				CloseWindow("XuanShop", true)
			end
			if(IsWindowShow("WuHun")) then
				CloseWindow("WuHun", true)
			end
			if(IsWindowShow("SelfEquip")) then
				CloseWindow("SelfEquip", true)
			end
			if(IsWindowShow("NewExterior_Facestyle")) then
				CloseWindow("NewExterior_Facestyle", true)
			end
			if(IsWindowShow("NewExterior_HairStyle")) then
				CloseWindow("NewExterior_HairStyle", true)
			end
			if(IsWindowShow("NewExterior_PetSoul")) then
				CloseWindow("NewExterior_PetSoul", true)
			end
			if(IsWindowShow("NewExterior_PlayerFrame")) then
				CloseWindow("NewExterior_PlayerFrame", true)
			end
			if(IsWindowShow("NewExterior_Ride")) then
				CloseWindow("NewExterior_Ride", true)
			end
			if(IsWindowShow("NewExterior_Weapon")) then
				CloseWindow("NewExterior_Weapon", true)
			end
			if(IsWindowShow("NewExterior_Weapon_Levelup")) then
				CloseWindow("NewExterior_Weapon_Levelup", true)
			end
			NewExterior_DressBox_SetPosition()
			NewExterior_DressBox_CloseSameGroupWindow()
			this:Show()
			NewExterior_DressBox_Show()
		end	
		return
	end
	if event == "UI_COMMAND" and tonumber(arg0) == 202107292 then
		--�������¶�ȡ
		g_PlayerFashionInfoList = {}
		g_PlayerFashionInfoList = Split(Get_XParam_STR(0),",")		
		--����ˢ��
		NewExterior_DressBox_Show()
		return
	end
	if event == "UI_COMMAND" and tonumber(arg0) == 202107293 then
		if GetGameMissionData("MD_EXTERIOR") == 1 then
			g_PlayerString = ""
			local theAction = EnumAction(2, "equip");
			NewExterior_DressBox_Dress_LeftBtn:SetActionItem(theAction:GetID())
			NewExterior_DressBox_Show()
		end
		return
	end
	if event == "UI_COMMAND" and tonumber(arg0) == 122032413 then
		-- PushDebugMessage(GetGameMissionData("MD_EXTERIOR"))
		if GetGameMissionData("MD_EXTERIOR") == 1 then
			NewExterior_DressBox_Show()
		end
		return
	end
	if event == "UI_COMMAND" and tonumber(arg0) == 202107294 then
		g_PlayerString = Get_XParam_STR(0)
		PushEvent("UI_COMMAND",202107295)
		return
	end
	if event == "UI_COMMAND" and tonumber(arg0) == 1000000037 then
		NewExterior_DressBox_Weapon_Type:SetCheck(Get_XParam_INT(0))
		return
	end	
	if event == "UI_COMMAND" and tonumber(arg0) == 20220214 then
		LifeAbility:Wear_Equip_VisualID(Get_XParam_INT(0),Get_XParam_INT(1))
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("RideSysteam")
			Set_XSCRIPT_ScriptID(830243)
			Set_XSCRIPT_Parameter(0,8);
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()			
		return
	end	
	-- FakeObjectģ�ͽ��滥��
	if ( event == "UI_COMMAND" and tonumber(arg0) == 120203161 ) then   --ʱװԤ��
		if (this:IsVisible()) then
			NewExterior_DressBox_CloseClick()
			return
		end
	end
	
	if event == "ON_SCENE_TRANS" or event == "ON_SERVER_TRANS" or event == "HIDE_ON_SCENE_TRANSED" then
		this:Hide()
	end
	
	-- ��Ϸ���ڳߴ緢���˱仯 or ��Ϸ�ֱ��ʷ����˱仯
	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		NewExterior_DressBox_Frame:SetProperty("UnifiedPosition", g_NewExterior_DressBox_UnifiedPosition)
	end

end

function NewExterior_DressBox_Show()
	
	g_Distance = g_Distance_Ori
	g_NeedChangeScrollSize = 1
	g_CurSelExteriorID = 0
	g_CurSelExteriorIndex = -1
	g_TargetExteriorID = 0
	g_TargetExteriorIndex = -1
			
	--�б� ����
	NewExterior_DressBox_UpdateList()
	--���
	NewExterior_DressBox_UpdateLeftBtn()
	--ģ��
	NewExterior_DressBox_UpdateObj()
		
	NewExterior_DressBox_ShowFashionWeaponCheckButton()
end
--���
function NewExterior_DressBox_UpdateLeftBtn()
	for i = 1, table.getn(g_ActionButtonList) do
		g_ActionButtonList[i]:Hide()
	end
	--ʱװ����
	NewExterior_DressBox_CleanUp_LeftButton()	
	--ʱװ
	if GetGameMissionData("MD_DRESS") ~= 0 then
		NewExterior_DressBox_Dress_ActionImg:Show()
		NewExterior_DressBox_Dress_LockImg:Show()
		local _,Icons = LifeAbility : GetPrescr_Material(GetGameMissionData("MD_DRESS"))
		local strImage = GetIconFullName(Icons)
		NewExterior_DressBox_Dress_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_DressBox_Dress_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_DressBox_Dress_LeftBtn:SetProperty("PushedImage", strImage)	
		NewExterior_DressBox_Dress_LeftBtn:SetProperty("Empty", "False")
		NewExterior_DressBox_Dress_LeftBtn:SetProperty("UseDefaultTooltip", "True")
	else
		NewExterior_DressBox_Dress_LockImg:Hide()
		NewExterior_DressBox_Dress_ActionImg:Hide()
		NewExterior_DressBox_Dress_LeftBtn:SetProperty("NormalImage", "")
		NewExterior_DressBox_Dress_LeftBtn:SetProperty("HoverImage", "")
		NewExterior_DressBox_Dress_LeftBtn:SetProperty("PushedImage", "")
		local theAction = EnumAction(2, "equip");
		NewExterior_DressBox_Dress_LeftBtn:SetActionItem(theAction:GetID())		
	end	
	--����
	theAction = DataPool:GetPlayerMission_DataRound(362)
	NewExterior_DressBox_Ride_LockImg:Hide()
	NewExterior_DressBox_Ride_ActionImg:Hide()
	if theAction ~= 0 then
		local strIcon = LuaFnGetExteriorRideInfo(theAction,"Icon")
		local strName 	= LuaFnGetExteriorRideInfo(theAction, "Name")
		local strImage = GetIconFullName(strIcon)
		NewExterior_DressBox_Ride_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_DressBox_Ride_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_DressBox_Ride_LeftBtn:SetProperty("Empty", "False")
		NewExterior_DressBox_Ride_LeftBtn:SetProperty("UseDefaultTooltip", "True")
		NewExterior_DressBox_Ride_LeftBtn:SetToolTip(strName)
	end
	if GetGameMissionData("MD_RIDA") ~= 0 then
		NewExterior_DressBox_Ride_ActionImg:Show()
		NewExterior_DressBox_Ride_LockImg:Show()
		strIcon 	= LuaFnGetExteriorRideInfo(GetGameMissionData("MD_RIDA"), "Icon")
		strImage = GetIconFullName(strIcon)
		strName 	= LuaFnGetExteriorRideInfo(GetGameMissionData("MD_RIDA"), "Name")
		NewExterior_DressBox_Ride_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_DressBox_Ride_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_DressBox_Ride_LeftBtn:SetProperty("Empty", "False")
		NewExterior_DressBox_Ride_LeftBtn:SetProperty("UseDefaultTooltip", "True")
		NewExterior_DressBox_Ride_LeftBtn:SetToolTip(strName)
	end		
	--����
	cacheExteriorID = DataPool:GetPlayerMission_DataRound(389)
	if cacheExteriorID ~= 0 then
		local strName 	= LuaFnGetExteriorWeaponInfo(cacheExteriorID, "Name")
		local strIcon 	= LuaFnGetExteriorWeaponInfo(cacheExteriorID, "Icon")
		local strImage = GetIconFullName(strIcon)
		NewExterior_DressBox_Weapon_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_DressBox_Weapon_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_DressBox_Weapon_LeftBtn:SetProperty("Empty", "False")
		NewExterior_DressBox_Weapon_LeftBtn:SetProperty("UseDefaultTooltip", "True")
		local strTemp = strName
		NewExterior_DressBox_Weapon_LeftBtn:SetToolTip(strTemp)
	else
		NewExterior_DressBox_Weapon_LeftBtn:SetProperty("HoverImage", "")
		NewExterior_DressBox_Weapon_LeftBtn:SetProperty("NormalImage", "")
	end
	NewExterior_DressBox_Weapon_ActionImg:Hide()
	NewExterior_DressBox_Weapon_LockImg:Hide()
	if GetGameMissionData("MD_WEAPON") > 0 then
		NewExterior_DressBox_Weapon_ActionImg:Show()
		NewExterior_DressBox_Weapon_LockImg:Show()
		strIcon 	= LuaFnGetExteriorWeaponInfo(GetGameMissionData("MD_WEAPON"), "Icon")
		strName 	= LuaFnGetExteriorWeaponInfo(GetGameMissionData("MD_WEAPON"), "Name")
		strImage = GetIconFullName(strIcon)
		NewExterior_DressBox_Weapon_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_DressBox_Weapon_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_DressBox_Weapon_LeftBtn:SetToolTip(strName)
	end		
	--����
	cacheExteriorID = DataPool:Get_MyFaceStyle()
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local _,_,_,IconFile,_,StyleName = DataPool : Change_MyFaceStyle_Item(cacheExteriorID);
		local strImage = GetIconFullName(IconFile)			
		NewExterior_DressBox_FaceStyle_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_DressBox_FaceStyle_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_DressBox_FaceStyle_LeftBtn:SetProperty("Empty", "False")
		NewExterior_DressBox_FaceStyle_LeftBtn:SetProperty("UseDefaultTooltip", "True")
		NewExterior_DressBox_FaceStyle_ActionImg:Hide()
		NewExterior_DressBox_FaceStyle_LockImg:Hide()
		local strTemp = StyleName
		NewExterior_DressBox_FaceStyle_LeftBtn:SetToolTip(strTemp)
	end
	if GetGameMissionData("MD_FACE") ~= 0 then
		NewExterior_DressBox_FaceStyle_ActionImg:Show()
		NewExterior_DressBox_FaceStyle_LockImg:Show()
		strIcon 	= LuaFnGetExteriorFaceInfo(GetGameMissionData("MD_FACE"), "Icon")
		strName 	= LuaFnGetExteriorFaceInfo(GetGameMissionData("MD_FACE"), "Name")
		strImage = GetIconFullName(strIcon)
		NewExterior_DressBox_FaceStyle_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_DressBox_FaceStyle_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_DressBox_FaceStyle_LeftBtn:SetProperty("Empty", "False")
		NewExterior_DressBox_FaceStyle_LeftBtn:SetProperty("UseDefaultTooltip", "True")
		NewExterior_DressBox_FaceStyle_LeftBtn:SetToolTip(strName)
	end	
	--����
	cacheExteriorID = DataPool : Get_MyHairStyle()
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local strName 	= LuaFnGetExteriorHairInfo(cacheExteriorID, "Name")
		local strIcon 	= LuaFnGetExteriorHairInfo(cacheExteriorID, "Icon")
		local strImage = GetIconFullName(strIcon)		
		NewExterior_DressBox_HairStyle_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_DressBox_HairStyle_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_DressBox_HairStyle_LeftBtn:SetProperty("Empty", "False")
		NewExterior_DressBox_HairStyle_LeftBtn:SetProperty("UseDefaultTooltip", "True")
		NewExterior_DressBox_HairStyle_LockImg:Hide()
		NewExterior_DressBox_HairStyle_ActionImg:Hide()
		local strTemp = strName
		NewExterior_DressBox_HairStyle_LeftBtn:SetToolTip(strTemp)
	end
	if GetGameMissionData("MD_HAIR") ~= 0 then
		NewExterior_DressBox_HairStyle_LockImg:Show()
		NewExterior_DressBox_HairStyle_ActionImg:Show()
		strIcon 	= LuaFnGetExteriorHairInfo(GetGameMissionData("MD_HAIR"), "Icon")
		strName 	= LuaFnGetExteriorHairInfo(GetGameMissionData("MD_HAIR"), "Name")
		strImage = GetIconFullName(strIcon)
		NewExterior_DressBox_HairStyle_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_DressBox_HairStyle_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_DressBox_HairStyle_LeftBtn:SetProperty("Empty", "False")
		NewExterior_DressBox_HairStyle_LeftBtn:SetProperty("UseDefaultTooltip", "True")
		NewExterior_DressBox_HairStyle_LeftBtn:SetToolTip(strName)
	end	
	--ͷ��
	local strHeadTip = ""
	cacheExteriorID = DataPool : Get_MyHeadStyle()
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local strName 	= LuaFnGetExteriorPortraitInfo(cacheExteriorID, "Name")
		local strIcon 	= LuaFnGetExteriorPortraitInfo(cacheExteriorID, "Icon")
		local strImage = GetIconFullName(strIcon)		
		NewExterior_DressBox_PlayerFrame_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_DressBox_PlayerFrame_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_DressBox_PlayerFrame_LeftBtn:SetProperty("Empty", "False")
		NewExterior_DressBox_PlayerFrame_LeftBtn:SetProperty("UseDefaultTooltip", "True")
		NewExterior_DressBox_PlayerFrame_LockImg:Hide()
		NewExterior_DressBox_PlayerFrame_ActionImg:Hide()
		local strTemp = strName
		NewExterior_DressBox_PlayerFrame_LeftBtn:SetToolTip(strTemp)	
	end	
	if GetGameMissionData("MD_HEAD") ~= 0 then
		NewExterior_DressBox_PlayerFrame_LockImg:Show()
		NewExterior_DressBox_PlayerFrame_ActionImg:Show()
		strIcon 	= LuaFnGetExteriorPortraitInfo(GetGameMissionData("MD_HEAD"), "Icon")
		strName 	= LuaFnGetExteriorPortraitInfo(GetGameMissionData("MD_HEAD"), "Name")
		strImage = GetIconFullName(strIcon)
		NewExterior_DressBox_PlayerFrame_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_DressBox_PlayerFrame_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_DressBox_PlayerFrame_LeftBtn:SetProperty("Empty", "False")
		NewExterior_DressBox_PlayerFrame_LeftBtn:SetProperty("UseDefaultTooltip", "True")
		NewExterior_DressBox_PlayerFrame_LeftBtn:SetToolTip(strName)
	end	
	-- ����
	cacheExteriorID = DataPool:GetPlayerMission_DataRound(387)
	if cacheExteriorID > 0 then
		local strName,iQual,iBloodRank,curPetSoulid,strIcon = NewExterior_PetSoul_DataShow(cacheExteriorID)
		strImage = GetIconFullName(strIcon)
		NewExterior_DressBox_PetSoul_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_DressBox_PetSoul_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_DressBox_PetSoul_LeftBtn:SetToolTip(strName)
		NewExterior_DressBox_PetSoul_LeftBtn:SetProperty("Empty", "False")
		NewExterior_DressBox_PetSoul_LeftBtn:SetProperty("UseDefaultTooltip", "True")
	end
	NewExterior_DressBox_PetSoul_LockImg:Hide()
	NewExterior_DressBox_PetSoul_ActionImg:Hide()
	local TryPoss = GetGameMissionData("MD_PETPOSS")
	if TryPoss ~= 0 then
		TryPoss = math.mod(TryPoss,100)
		local strName,strIcon,iQual = LuaFnGetExteriorPossInfo(TryPoss)
		strImage = GetIconFullName(strIcon)
		NewExterior_DressBox_PetSoul_LockImg:Show()
		NewExterior_DressBox_PetSoul_ActionImg:Show()
		NewExterior_DressBox_PetSoul_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_DressBox_PetSoul_LeftBtn:SetProperty("HoverImage", strImage)
		NewExterior_DressBox_PetSoul_LeftBtn:SetToolTip(strName)
		NewExterior_DressBox_PetSoul_LeftBtn:SetProperty("Empty", "False")
		NewExterior_DressBox_PetSoul_LeftBtn:SetProperty("UseDefaultTooltip", "True")
	end
end

--ģ��
function NewExterior_DressBox_UpdateObj()
	NewExterior_DressBox_FakeObject : SetFakeObject("");
	NewExterior_DressBox_FakeObject : SetFakeObject("EquipChange_Player");
	FakeObj_SetCamera( "EquipChange_Player", 1,1);
	FakeObj_SetCamera( "EquipChange_Player", 2,8);
	FakeObj_SetCamera( "EquipChange_Player", 3,0.28);
end

--�б�
function NewExterior_DressBox_UpdateList()
	
	-- ��ʾ
	local SlefDress = EnumAction(2,"equip")
	for i = 1,35 do
		g_DressBox_SuperListItem[i].Button:SetActionItem(-1)
		g_DressBox_SuperListItem[i].ActionEqu:Hide()
		g_DressBox_SuperListItem[i].ActionTry:Hide()
		if g_PlayerFashionInfoList[i] ~= "" and g_PlayerFashionInfoList[i] ~= nil then
			local theAction = GemMelting:UpdateProductAction(tonumber(g_PlayerFashionInfoList[i]))
			if theAction:GetID() ~= 0 then
				g_DressBox_SuperListItem[i].Button:SetActionItem(theAction:GetID())
			end
			if SlefDress:GetDefineID() == tonumber(g_PlayerFashionInfoList[i]) then
				g_DressBox_SuperListItem[i].ActionEqu:Show()
			end
		end
	end
end

function NewExterior_DressBox_ItemBtnClicked(nIndex)
	
	local tabInfo = g_PlayerFashionInfoList[nIndex]
	if not tabInfo or tabInfo < 0 then 
		return
	end
end

--ʱװ����
function NewExterior_DressBox_onAction(nIndex)
	if not nIndex then 
		return
	end
	
	local tabInfo = g_PlayerFashionInfoList[g_CurSelExteriorIndex]
	if not tabInfo or tabInfo.nExteriorID < 0 then 
		return
	end
	
	for i = 1, table.getn(g_SpecialFashionCamera) do
		if tabInfo.nExteriorID >= g_SpecialFashionCamera[i].startid and tabInfo.nExteriorID <= g_SpecialFashionCamera[i].endid then
			local fHeight, fDistance, fPitch = NewExterior_DressBox_FakeObject:GetCameraEx()
			if g_SpecialFashionCamera[i].fDistance ~= -1 then
				fDistance = g_SpecialFashionCamera[i].fDistance
			end
			if g_SpecialFashionCamera[i].fHeight ~= -1 then
				fHeight = g_SpecialFashionCamera[i].fHeight
			end
			if g_SpecialFashionCamera[i].fPitch ~= -1 then
				fPitch = g_SpecialFashionCamera[i].fPitch
			end
			NewExterior_DressBox_FakeObject:SetCameraEx(fHeight, fDistance, fPitch)
			NewExterior_DressBox_Model_Plus:Disable()
			NewExterior_DressBox_Model_Subtract:Disable()
			NewExterior_DressBox_Model_TurnLeft:Disable()
			NewExterior_DressBox_Model_TurnRight:Disable()
			
			SetTimer("NewExterior_DressBox","NewExterior_DressBox_ActionEnd()", g_SpecialFashionCamera[i].timecount)
		end		
	end
	
	Exterior:LuaFnExteriorAvatarPlayAction(1, g_CurSelExteriorIndex-1, nIndex-1)
end

function NewExterior_DressBox_ActionEnd()
	KillTimer("NewExterior_DressBox_ActionEnd()");
	
	NewExterior_DressBox_Model_Plus:Enable()
	NewExterior_DressBox_Model_Subtract:Enable()
	NewExterior_DressBox_Model_TurnLeft:Enable()
	NewExterior_DressBox_Model_TurnRight:Enable()
	
	-- NewExterior_DressBox_UpdateCamera()
end

function NewExterior_DressBox_MakeHyperlink(nVecIndex)
	local ret = Exterior:LuaFnExteriorFashionDepotItemClick(m_PlayerfashionDepotType, nVecIndex)
	return ret
end

function NewExterior_DressBox_ItemClicked(nIndex)
	local tabInfo = tonumber(g_PlayerFashionInfoList[nIndex])
	if not tabInfo or tabInfo <= 0 then 
		return
	end
	for i = 1,35 do
		if i == nIndex then 
			g_DressBox_SuperListItem[i].ActionTry:Show()
		else
			g_DressBox_SuperListItem[i].ActionTry:Hide()
		end
	end
	g_CurSelExteriorIndex = nIndex
	local SlefDress = EnumAction(2,"equip")
	if tabInfo == SlefDress:GetDefineID() then
		NewExterior_DressBox_Dress_ActionImg:Hide()
		NewExterior_DressBox_Dress_LockImg:Hide()
		NewExterior_DressBox_Dress_LeftBtn:SetActionItem(SlefDress:GetID())
	else
		NewExterior_DressBox_Dress_ActionImg:Show()
		NewExterior_DressBox_Dress_LockImg:Show()
		local _,Icons = LifeAbility : GetPrescr_Material(tabInfo)
		local strImage = GetIconFullName(Icons)
		NewExterior_DressBox_Dress_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_DressBox_Dress_LeftBtn:SetProperty("Empty", "False")
	end	
	--�����Դ���Ϣ
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("ExteriorFashion")
		Set_XSCRIPT_ScriptID(830243)
		Set_XSCRIPT_Parameter(0,5)
		Set_XSCRIPT_Parameter(1,tabInfo)
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()
	SetGameMissionData("MD_DRESS",tabInfo)
end

function NewExterior_DressBox_SetItemSelected(nIndex)

	local tabInfo = g_PlayerFashionInfoList[nIndex]
	if not tabInfo or tabInfo.nExteriorID < 0 then 
		return
	end
	
	for i = 1, 210 do		
		if g_BarList[i] ~= nil then	
			g_BarList[i]:GetSubItem("NewExterior_DressBox_SuperListItemActionTry"):Hide()
			
			local ctrlAction = g_BarList[i]:GetSubItem("NewExterior_DressBox_SuperListItemAction")
			if ctrlAction ~= nil then
				if i == nIndex then
					ctrlAction:SetPushed(1)
					if tabInfo.bDressUp == 0 then
						g_BarList[i]:GetSubItem("NewExterior_DressBox_SuperListItemActionTry"):Show()
					end
	
					local nCurFashionId, nCurFashionIdx = Exterior:LuaFnGetExteriorFashionInUse()
					if nCurFashionId ~= nil and nCurFashionId > 0 then
						if nCurFashionIdx == tabInfo.nVecIndex then
						g_BarList[i]:GetSubItem("NewExterior_DressBox_SuperListItemActionTry"):Hide()
						end
					end
					
				else
					ctrlAction:SetPushed(0)	
				end
			end
		end
	end
end

function NewExterior_DressBox_CloseClick()	
	NewExterior_DressBox_FakeObject:SetFakeObject("")
	NewExterior_DressBox_SavePosition()
	this:Hide()
end

function NewExterior_DressBox_OnHidden()
	NewExterior_DressBox_FakeObject:SetFakeObject("")
	NewExterior_DressBox_CleanUp()
end
	
function NewExterior_DressBox_CleanUp_LeftButton()

	NewExterior_DressBox_Dress_LeftBtn:SetActionItem(-1)
	
	local ctrl_list = {
		NewExterior_DressBox_Ride_LeftBtn,
		NewExterior_DressBox_FaceStyle_LeftBtn,
		NewExterior_DressBox_HairStyle_LeftBtn,
		NewExterior_DressBox_PlayerFrame_LeftBtn,
	}
	
	for i in pairs(ctrl_list) do
		ctrl_list[i]:SetProperty("Empty", "False")
		ctrl_list[i]:SetProperty("UseDefaultTooltip", "True")
		ctrl_list[i]:SetProperty("NormalImage", "")
		ctrl_list[i]:SetProperty("HoverImage", "")
		ctrl_list[i]:SetToolTip("")
	end
	
	NewExterior_DressBox_PlayerFrame_Mask:SetProperty("Image", "")
	
	NewExterior_DressBox_Dress_ActionImg:Hide()
	NewExterior_DressBox_Ride_ActionImg:Hide()
	NewExterior_DressBox_FaceStyle_ActionImg:Hide()
	NewExterior_DressBox_HairStyle_ActionImg:Hide()
	NewExterior_DressBox_PlayerFrame_ActionImg:Hide()


	NewExterior_DressBox_Dress_LockImg:Hide()
	NewExterior_DressBox_Ride_LockImg:Hide()
	NewExterior_DressBox_FaceStyle_LockImg:Hide()
	NewExterior_DressBox_HairStyle_LockImg:Hide()
	NewExterior_DressBox_PlayerFrame_LockImg:Hide()
end

function NewExterior_DressBox_CleanUp()
	NewExterior_DressBox_FakeObject:SetFakeObject("")
end

--��ת
function NewExterior_DressBox_FakeObject_TurnLeft(idx)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		--������ת��ʼ
		if(idx == 1) then
			NewExterior_DressBox_FakeObject:RotateBegin(-0.3);
		--������ת����
		else
			NewExterior_DressBox_FakeObject:RotateEnd();
		end
	end	
end

--��ת
function NewExterior_DressBox_FakeObject_TurnRight(idx)
	
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		--������ת��ʼ
		if(idx == 1) then
			NewExterior_DressBox_FakeObject:RotateBegin(0.3);
		--������ת����
		else
			NewExterior_DressBox_FakeObject:RotateEnd();
		end
	end	
end

--��С
function NewExterior_DressBox_ZoomOut(start)
	NewExterior_DressBox_FakeObject: SetFakeObject( "EquipChange_Player" );
end

--�Ŵ�
function NewExterior_DressBox_ZoomIn(start)
	NewExterior_DressBox_FakeObject: SetFakeObject( "Player_Head" );
	FakeObj_SetCamera( "EquipChange_Player", 1,1);
	FakeObj_SetCamera( "EquipChange_Player", 2,8);
	FakeObj_SetCamera( "EquipChange_Player", 3,0.28);
end

function NewExterior_DressBox_MouseEnter(Index)
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("DressTooltips")
		Set_XSCRIPT_ScriptID(830243)
		Set_XSCRIPT_Parameter(0,Index)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()		
end

function NewExterior_DressBox_MouseLeave()
	g_PlayerString = ""
end

function NewExterior_DressBox_UpdateCamera()

	local sex = GetMySelfRaceId()
	if sex ~= 0 and sex ~= 1 then 
		return
	end
		
	if g_Distance < 1 or g_Distance > g_Distance_Max then
		return
	end
	
	local fHeight, fDistance, fPitch = NewExterior_DressBox_FakeObject:GetCameraEx()
	fHeight = g_CameraPosition[sex][g_Distance].fHeight
	fDistance = g_CameraPosition[sex][g_Distance].fDistance
	fPitch = g_CameraPosition[sex][g_Distance].fPitch
	NewExterior_DressBox_FakeObject:SetCameraEx(fHeight, fDistance, fPitch)
	
end

--ʱװ�ֿ⵽����
function NewExterior_DressBox_FashionDepotToBag(nSourcePos)
    Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("ExteriorFashion");
		Set_XSCRIPT_ScriptID(830243);
		Set_XSCRIPT_Parameter(0,4);
		Set_XSCRIPT_Parameter(1,nSourcePos);
		Set_XSCRIPT_ParamCount(2);
    Send_XSCRIPT();
end

--������ʱװ�ֿ�
function NewExterior_DressBox_BagToFashionDepot(opType, nSourcePos, targetPos)

	local theAction, bLocked, bProtect, nElapsedTime = PlayerPackage:EnumItem("base", nSourcePos);
	if theAction:GetID() ~= 0  then 
		local opResult = FashionDepot:LuaFnJudgeBagItem(m_PlayerfashionDepotType, nSourcePos)
		if opResult == 2 then --����ʱװ
			PushDebugMessage("#{HCG_190117_18}")
			return
		end
		
		if opResult == 5 then --�����������ʱ�� -ʹ���˶�����������˽��� ��Ҫ����ȷ��
			PushEvent("EXTERIOR_FASHION_CONFIRM", 1000, m_PlayerfashionDepotType, opType, nSourcePos, targetPos) --����ȷ��
			return
		end
		
		--��Ƕ�� �����˿ --��ʱʱװ 
		if opResult == 3 or opResult == 4 or opResult == 1 then 
			Exterior:LuaFnExteriorFashionOperation(m_PlayerfashionDepotType, opType, nSourcePos, targetPos)
		end
	end
	
end

--ж��ʱװ 
function NewExterior_DressBox_ActionToDressBox()
	--ж��ʱװ��ʱװ����
    Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("ExteriorFashion");
		Set_XSCRIPT_ScriptID(830243);
		Set_XSCRIPT_Parameter(0,1);
		Set_XSCRIPT_ParamCount(1);
    Send_XSCRIPT();	
	NewExterior_DressBox_Dress_ActionImg:Hide()
	NewExterior_DressBox_Dress_LockImg:Hide()
	NewExterior_DressBox_Dress_LeftBtn:SetActionItem(-1)	
end
function SaveAllChange()
    Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("SaveAllChange");
		Set_XSCRIPT_ScriptID(830243);
		Set_XSCRIPT_Parameter(0,GetGameMissionData("MD_DRESS"));
		Set_XSCRIPT_Parameter(1,GetGameMissionData("MD_WEAPON"));
		Set_XSCRIPT_Parameter(2,GetGameMissionData("MD_RIDA"));
		Set_XSCRIPT_Parameter(3,GetGameMissionData("MD_FACE"));
		Set_XSCRIPT_Parameter(4,GetGameMissionData("MD_HAIR")*100+GetGameMissionData("MD_HAIRCLOLOUR"));
		Set_XSCRIPT_Parameter(5,GetGameMissionData("MD_PETPOSS")*1000 + GetGameMissionData("MD_HEAD"));
		Set_XSCRIPT_ParamCount(6);
    Send_XSCRIPT();
	ClearSaveAllChange()
end
function ClearSaveAllChange()
	SetGameMissionData("MD_DRESS",0)
	SetGameMissionData("MD_WEAPON",0)
	SetGameMissionData("MD_RIDA",0)
	SetGameMissionData("MD_FACE",0)
	SetGameMissionData("MD_HAIR",0)
	SetGameMissionData("MD_PETPOSS",0)
	SetGameMissionData("MD_HEAD",0)
	SetGameMissionData("MD_HAIRCLOLOUR",0)
	LifeAbility:Update_Equip_VisualID()
end
--����
function NewExterior_DressBox_DressChange_Save()
	--Ԥ����Ϣ
	SaveAllChange()
	NewExterior_DressBox_Undo()
end

--��ԭ
function NewExterior_DressBox_Undo()
	ClearSaveAllChange()
	--��ԭ����ʱװ����
	NewExterior_DressBox_Show()
end

function NewExterior_DressBox_Page(nIndex)
	g_DressPage = g_DressPage + nIndex
	if g_DressPage >= 5 then
		g_DressPage = 5
	end
	if g_DressPage < 0 then
		g_DressPage = 0
		return
	end
	NewExterior_DressBox_GetServerInfo()
end

function NewExterior_DressBox_GetServerInfo()
    Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("OpenDress");
		Set_XSCRIPT_ScriptID(830243);
		Set_XSCRIPT_Parameter(0,g_DressPage);
		Set_XSCRIPT_Parameter(1,1);
		Set_XSCRIPT_ParamCount(2);
    Send_XSCRIPT();	
end

--����
function NewExterior_DressBox_ClickClearUpBtn()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("ExteriorFashion")
		Set_XSCRIPT_ScriptID(830243)
		Set_XSCRIPT_Parameter(0,3);
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
end

--�л���Ůʱװ
function NewExterior_DressBox_OpenInfant()	
end

--ʱװ
function NewExterior_DressBox_OpenFashion()
end

--����
function NewExterior_DressBox_OpenWeapon()
	NewExterior_DressBox_SavePosition()
	LuaFnAskOpenExterior(2)
end

--����
function NewExterior_DressBox_OpenPoss()
	NewExterior_DressBox_SavePosition()
	LuaFnAskOpenExterior(6)
end

--����
function NewExterior_DressBox_OpenRide()
	NewExterior_DressBox_SavePosition()
	LuaFnAskOpenExterior(3)
end

--����
function NewExterior_DressBox_OpenHair()
	NewExterior_DressBox_SavePosition()
	LuaFnAskOpenExterior(5)	
end

--����
function NewExterior_DressBox_OpenFace()
	NewExterior_DressBox_SavePosition()	
	LuaFnAskOpenExterior(4)
end

--ͷ��
function NewExterior_DressBox_OpenPortrait()
	NewExterior_DressBox_SavePosition()	
	LuaFnAskOpenExterior(7)
end

--ͷ���
function NewExterior_DressBox_OpenFrame()
end

function NewExterior_DressBox_TakeOffRide()
    Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("RideSysteam");
		Set_XSCRIPT_ScriptID(830243);
		Set_XSCRIPT_Parameter(0,13);
		Set_XSCRIPT_ParamCount(1);
    Send_XSCRIPT();	
	NewExterior_DressBox_Ride_LeftBtn:SetProperty("PushedImage", "")
	NewExterior_DressBox_Ride_LeftBtn:SetProperty("NormalImage", "")
	NewExterior_DressBox_Ride_LeftBtn:SetProperty("HoverImage", "")
	NewExterior_DressBox_Ride_LeftBtn:SetToolTip("")
end

function NewExterior_DressBox_TakeOffWeapon()
    Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("RideSysteam");
		Set_XSCRIPT_ScriptID(830243);
		Set_XSCRIPT_Parameter(0,12);
		Set_XSCRIPT_ParamCount(1);
    Send_XSCRIPT();	
	NewExterior_DressBox_Weapon_LeftBtn:SetProperty("PushedImage", "")
	NewExterior_DressBox_Weapon_LeftBtn:SetProperty("NormalImage", "")
	NewExterior_DressBox_Weapon_LeftBtn:SetProperty("HoverImage", "")
	NewExterior_DressBox_Weapon_LeftBtn:SetToolTip("")
end

function NewExterior_DressBox_CloseSameGroupWindow()
	CloseWindow("SelfEquip", true)
	CloseWindow("NewExterior_Ride", true)
	CloseWindow("NewExterior_Weapon", true)
	CloseWindow("NewExterior_PetPossJian", true)
	CloseWindow("NewExterior_Facestyle", true)
	CloseWindow("NewExterior_HairStyle", true)
	CloseWindow("NewExterior_PlayerFrame", true)
	CloseWindow("WuHun", true)
end

function NewExterior_DressBox_SavePosition()
	NewExterior_DressBox_FakeObject:SetFakeObject("")
	Variable:SetVariable("ExteriorUnionPos", NewExterior_DressBox_Frame:GetProperty("UnifiedPosition"), 1)
	NewExterior_DressBox_CloseSameGroupWindow()
end

function NewExterior_DressBox_SetPosition()
	
	local nExteriorUnionPos = Variable:GetVariable("ExteriorUnionPos")
	if nExteriorUnionPos ~= nil then
		NewExterior_DressBox_Frame:SetProperty("UnifiedPosition", nExteriorUnionPos)
	end

end

function NewExterior_DressBox_ShowFashionWeaponCheckButton()
end

function NewExterior_DressBox_FashionDisplay()
	--ʱװ��ʾ����
	local IsDisplay = SystemSetup:Get_Display_Dress();
	NewExterior_DressBox_Dress_Type : SetCheck(1)--IsDisplay
	if IsDisplay == 1 then
		IsDisplay = 0
	else
		IsDisplay = 1
	end
	SystemSetup:Set_Display_Dress(1);
end

function NewExterior_DressBox_ExteriorWeaponDisplay()
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
function LuaFnAskOpenExterior(nIndex)
	if nIndex == 1 then	--ʱװ
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("OpenDress");
			Set_XSCRIPT_ScriptID(830243);
			Set_XSCRIPT_Parameter(0,0);
			Set_XSCRIPT_Parameter(1,0);
			Set_XSCRIPT_ParamCount(2);
		Send_XSCRIPT();	
	elseif nIndex == 2 then	--����
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("ExteriorWeapon")
			Set_XSCRIPT_ScriptID(830243)
			Set_XSCRIPT_Parameter(0,1);
			Set_XSCRIPT_Parameter(1,0);
			Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT()	
	elseif nIndex == 3 then	--����
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("RideSysteam")
			Set_XSCRIPT_ScriptID(830243)
			Set_XSCRIPT_Parameter(0,1);
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()	
	elseif nIndex == 4 then	--����
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("RideSysteam")
			Set_XSCRIPT_ScriptID(830243)
			Set_XSCRIPT_Parameter(0,2);
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()	
	elseif nIndex == 5 then	--����
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("RideSysteam")
			Set_XSCRIPT_ScriptID(830243)
			Set_XSCRIPT_Parameter(0,3);
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
	elseif nIndex == 6 then	--����
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("RideSysteam")
			Set_XSCRIPT_ScriptID(830243)
			Set_XSCRIPT_Parameter(0,6);
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
	elseif nIndex == 7 then	--ͷ��
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("RideSysteam")
			Set_XSCRIPT_ScriptID(830243)
			Set_XSCRIPT_Parameter(0,9);
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()	
	end
end
--!!!reloadscript =NewExterior_DressBox