
local g_WeaponLevelUp_Frame_UnifiedPosition
local g_clientNpcId = -1


local g_BarList = {}								-- ����ͼ��ui����
local g_MaxBarNum = 0								-- ͼ������
local g_CurSelExteriorWeaponID = 0					-- Exterior_Weapon���id
local g_CurSelExteriorWeaponLevel = 1				-- ��ǰѡ��Ļ���ȼ�
local g_WeponLevelup_YuanBaoPay = 1					-- Ԫ������ȷ��
local g_CurSelItemIndex = 1
local g_ExteriorType = 5							-- ����
local g_DataListCount = 0
local g_LevelMax = 4								-- ��ߵȼ�
local g_LevelLimit = 1								-- ����������
local g_InitList = 0								-- ��ʼ����ʶ
local g_IdxList = {}								-- ��������

function NewExterior_Weapon_Levelup_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("UNIT_MONEY", false)
	this:RegisterEvent("MONEYJZ_CHANGE", false)
	this:RegisterEvent("ADJEST_UI_POS", false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED", false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED", false)	--�뿪�����رս���
	this:RegisterEvent("ADD_EXTERIOR", false)
	this:RegisterEvent("UPDATE_EXTERIOR", false)
	this:RegisterEvent("EXTERIOR_OUTTIME", false)
	this:RegisterEvent("EXTERIOR_ID_CHANGED", false)
	
	this:RegisterEvent("ADD_EXTERIOR_WEAPON", false)
	this:RegisterEvent("UPDATE_EXTERIOR_WEAPON", false)
	this:RegisterEvent("EXTERIOR_OUTTIME_WEAPON", false)
	this:RegisterEvent("REMOVE_EXTERIOR_WEAPON", false)
	this:RegisterEvent("DEF_EXTERIOR_WEAPON_CHANGED", false)
	
	this:RegisterEvent("DEF_EXTERIOR_WEAPON_LEVEL_CHANGED", false)
	this:RegisterEvent("OPEN_EQUIP", false)
	this:RegisterEvent("OPEN_DRESS_PAINT_FITTING", false)
	this:RegisterEvent("OPEN_DRESS_ENCHASE_FITTING", false)
	
	this:RegisterEvent("YIGUI_OPEN",false);				-- �¹�
end

function NewExterior_Weapon_Levelup_OnLoad() 
	g_WeaponLevelUp_Frame_UnifiedPosition = NewExterior_Weapon_Levelup_Frame:GetProperty("UnifiedPosition")

	g_WeponLevelup_YuanBaoPay = 1
	g_CurSelExteriorWeaponID = 0
	g_CurSelExteriorWeaponLevel = 1
	g_CurSelItemIndex = 1
	for i = 1,7 do
		g_BarList[i] = {Item = _G[string.format("NewExterior_Weapon_Levelup_SuperList_ItemAction%d",i)],lock = _G[string.format("NewExterior_Weapon_Levelup_SuperListItemActionLock%d",i)]}
	end
end

function NewExterior_Weapon_Levelup_OnEvent(event)
	if event == "UI_COMMAND" and arg0 ~=nil and tonumber(arg0) == 89334001 then
		local ToData = Get_XParam_STR(0)
		--�������
		for i = 1,7 do
			g_IdxList[i] = tonumber(string.sub(ToData,i,i))
		end
		NewExterior_Weapon_Levelup_OnShow()
	elseif event == "UI_COMMAND" and arg0 ~=nil and tonumber(arg0) == 89334002 then
		local ToData = Get_XParam_STR(0)
		--�������
		for i = 1,7 do
			g_IdxList[i] = tonumber(string.sub(ToData,i,i))
		end
		NewExterior_Weapon_Levelup_ResUpdate()
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 20220829 ) then
		LifeAbility:Wear_Equip_VisualID(Get_XParam_INT(0),Get_XParam_INT(1))
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("RideSysteam")
			Set_XSCRIPT_ScriptID(830243)
			Set_XSCRIPT_Parameter(0,8)
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()			
	elseif (event == "ADJEST_UI_POS" ) then
		NewExterior_Weapon_Levelup_Frame_On_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		NewExterior_Weapon_Levelup_Frame_On_ResetPos()
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		NewExterior_Weapon_Levelup_CloseOnClick()
	elseif (event == "UNIT_MONEY") then
		NewExterior_Weapon_Levelup_MoneyUIUpdate()
	elseif (event == "MONEYJZ_CHANGE") then
		NewExterior_Weapon_Levelup_MoneyUIUpdate()
	elseif event == "ADD_EXTERIOR" or event == "UPDATE_EXTERIOR" or event == "EXTERIOR_OUTTIME" or event == "EXTERIOR_ID_CHANGED" then
		if not this:IsVisible() then
			return
		end
		NewExterior_Weapon_Levelup_Init()
	elseif event == "ADD_EXTERIOR_WEAPON" or event == "UPDATE_EXTERIOR_WEAPON" or event == "EXTERIOR_OUTTIME_WEAPON" or event == "DEF_EXTERIOR_WEAPON_CHANGED" then
		if not this:IsVisible() then
			return
		end

		NewExterior_Weapon_Levelup_Init()		
	elseif event == "DEF_EXTERIOR_WEAPON_LEVEL_CHANGED" then
		if not this:IsVisible() then
			return
		end
		NewExterior_Weapon_Levelup_Init()
	elseif event == "OPEN_EQUIP" or event == "OPEN_DRESS_PAINT_FITTING" or event == "OPEN_DRESS_ENCHASE_FITTING" or event == "YIGUI_OPEN" then
		if this:IsVisible() then
			NewExterior_Weapon_Levelup_CloseOnClick()
		end
	end
		

end

function NewExterior_Weapon_Levelup_Frame_On_ResetPos()
	NewExterior_Weapon_Levelup_Frame:SetProperty("UnifiedPosition", g_WeaponLevelUp_Frame_UnifiedPosition);
end

function NewExterior_Weapon_Levelup_OnShow()
	if this : IsVisible() then	-- ������濪�ţ��򲻴���
		return
	end

	local npcObjId = Get_XParam_INT(0)
	g_clientNpcId = DataPool : GetNPCIDByServerID(npcObjId)
	if g_clientNpcId == -1 then
		NewExterior_Weapon_Levelup_CloseOnClick()
		return
	end

	this:CareObject( g_clientNpcId, 1, "NewExterior_Weapon_Levelup" )

	NewExterior_Weapon_Levelup_CloseSameGroupWindow()

	-- Exterior:LuaFnUpdateExteriorWeaponPlayerData(0, 0)

	this:Show()

	NewExterior_Weapon_Levelup_Init()
end

function NewExterior_Weapon_Levelup_Init()
	-- ��List���г�ʼ��
	-- Exterior:LuaFnInitExteriorWeaponList()
	-- ���չʾģ�� ��ʼ��
	NewExterior_Weapon_Levelup_FakeObject:SetFakeObject("")
	NewExterior_Weapon_Levelup_FakeObject:SetFakeObject("EquipChange_Player")
	-- Ԫ��ȷ�Ͽ�ui״̬
	if g_WeponLevelup_YuanBaoPay == 1 or g_WeponLevelup_YuanBaoPay == 0 then
		--NewExterior_Weapon_Levelup_YuanBao:SetCheck(g_WeponLevelup_YuanBaoPay)
	end

	-- Ǯ��ˢ��
	NewExterior_Weapon_Levelup_MoneyUIUpdate()

	NewExterior_Weapon_Levelup_Update()

	-- NewExterior_Weapon_Levelup_BtnStateUpdate()
end

function NewExterior_Weapon_Levelup_ResUpdate()
	--�Ҳ�����ͼ���б��ʼ��	
	for i = 1,7 do
		--�Ƿ�ӵ�л���
		if g_IdxList[i] ~= nil and g_IdxList[i] ~= 0 then
			g_BarList[i].lock:Hide()
		else
			g_BarList[i].lock:Show()
		end
	end
	NewExterior_Weapon_Levelup_LevelInfoShow(g_CurSelExteriorWeaponID)
end

function NewExterior_Weapon_Levelup_MoneyUIUpdate()
	local playerMoney = Player:GetData("MONEY")
	NewExterior_Weapon_Levelup_SelfMoney:SetProperty("MoneyNumber", playerMoney)

	local playerJZ = Player:GetData("MONEY_JZ")
	NewExterior_Weapon_Levelup_SelfJiaozi:SetProperty("MoneyNumber", playerJZ)
end

function NewExterior_Weapon_Levelup_BtnStateUpdate()
	-- �Ƿ�ѡ��
	if g_CurSelExteriorWeaponID <= 0 then
		NewExterior_Weapon_Levelup_OK:Disable()
	else
		if Exterior:LuaFnIsHaveExteriorWeapon(g_CurSelExteriorWeaponID) == 1 then
			local maxLevel = Exterior:LuaFnGetExteriorWeaponInfo(g_CurSelExteriorWeaponID, "MaxLevel")
			if g_CurSelExteriorWeaponLevel < maxLevel - 1 then
				NewExterior_Weapon_Levelup_OK:Enable()
			else
				NewExterior_Weapon_Levelup_OK:Disable()
			end
		else
			NewExterior_Weapon_Levelup_OK:Disable()
		end
	end

	--NewExterior_Weapon_Levelup_OK:SetToolTip("#{HWSJ_201218_13}")
end

function NewExterior_Weapon_Levelup_Update()

	--�Ҳ�����ͼ���б��ʼ��	
	for i = 1,7 do
		local strIcon 	= LuaFnGetExteriorWeaponInfo(i, "Icon")
		local strTemp = LuaFnGetExteriorWeaponInfo(i, "ToolTips")
		local strName 	= LuaFnGetExteriorWeaponInfo(i, "Name")
		local strImage = GetIconFullName(strIcon)
		g_BarList[i].Item:SetProperty("NormalImage", strImage)
		g_BarList[i].Item:SetProperty("HoverImage", strImage)
		g_BarList[i].Item:SetToolTip(strName.."#r"..strTemp)
		g_BarList[i].Item:SetProperty("Empty", "False")
		g_BarList[i].Item:SetProperty("UseDefaultTooltip", "True")
		--�Ƿ�ӵ�л���
		if g_IdxList[i] ~= nil and g_IdxList[i] ~= 0 then
			g_BarList[i].lock:Hide()
		else
			g_BarList[i].lock:Show()
		end
	end
	NewExterior_Weapon_Levelup_LevelMax_Text:SetText("�������ͼ�꼴��Ԥ��")
	-- NewExterior_Weapon_Levelup_ItemClicked(g_CurSelItemIndex)
	
end

--��ʼ��ÿ��ͼ��item
function NewExterior_Weapon_Levelup_SetItem(index)
	local bar = g_BarList[index]
	if bar == nil then
		return
	end

	if index > g_DataListCount then
		g_BarList[index]:Hide()
		return
	end

	local idx = g_IdxList[index]
	if idx == nil then
		g_BarList[index]:Hide()
		return
	end

	bar:Show()

	local nExteriorID = Exterior:LuaFnGetExteriorWeaponIDFromList(idx - 1)
	local strName = Exterior:LuaFnGetExteriorWeaponInfo(nExteriorID, "Name")
	local strIcon = Exterior:LuaFnGetExteriorWeaponInfo(nExteriorID, "Icon")
	local strImage = GetIconFullName(strIcon)
	local ctrlAction = bar:GetSubItem("NewExterior_Weapon_Levelup_SuperList_ItemAction")
	if ctrlAction ~= nil then	
		ctrlAction:SetProperty("NormalImage", strImage)
		ctrlAction:SetProperty("HoverImage", strImage)
		local strTip = Exterior:LuaFnGetExteriorWeaponToolTip(nExteriorID)
		ctrlAction:SetToolTip(strTip)
	end

	--��
	if Exterior:LuaFnIsHaveExteriorWeapon(nExteriorID) == 1 then
		bar:GetSubItem("NewExterior_Weapon_Levelup_SuperListItemActionLock"):Hide()
		local nLeftTime = Exterior:LuaFnGetExteriorWeaponLeftTime(nExteriorID)
		if nLeftTime and nLeftTime < 0 then
			bar:GetSubItem("NewExterior_Weapon_Levelup_SuperListItemActionTime"):Hide()
		elseif nLeftTime and nLeftTime == 0 then
			bar:GetSubItem("NewExterior_Weapon_Levelup_SuperListItemActionTime"):Show()
		elseif nLeftTime and nLeftTime > 0 then
			bar:GetSubItem("NewExterior_Weapon_Levelup_SuperListItemActionTime"):Show()
		end
	else
		bar:GetSubItem("NewExterior_Weapon_Levelup_SuperListItemActionTime"):Hide()
		bar:GetSubItem("NewExterior_Weapon_Levelup_SuperListItemActionLock"):Show()
	end
end

--�������ͼ��item
function NewExterior_Weapon_Levelup_ItemClicked(nIndex)
	for i = 1,7 do
		if i == nIndex then
			g_BarList[i].Item:SetPushed(1)
		else
			g_BarList[i].Item:SetPushed(0)
		end
	end
	g_CurSelItemIndex = nIndex
	g_CurSelExteriorWeaponID = nIndex
	NewExterior_Weapon_Levelup_LevelInfoShow(nIndex)
	
	local DefWeapon = LuaFnGetExteriorWeaponInfo(nIndex,"WG",g_IdxList[nExteriorID])
	SetGameMissionData("MD_WEAPONYULAN",DefWeapon)
	--����Ԥ��
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("RideSysteam")
		Set_XSCRIPT_ScriptID(830243)
		Set_XSCRIPT_Parameter(0,14);
		Set_XSCRIPT_Parameter(1,DefWeapon);
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()	
end

--�������ȼ�item
function NewExterior_Weapon_Levelup_LevelInfoShow(nExteriorID)
	
	local lv, nextlv, money, item, itemnum = LuaFnGetExteriorWeaponLevelData(nExteriorID,g_IdxList[nExteriorID])
	if lv < 0 then
		-- ID����
		return
	end
	if lv == nextlv then 	-- ����
		-- ��ʾ����
		NewExterior_Weapon_Levelup_DemandMoney:SetProperty("MoneyNumber", 0)
		-- ��ʾ������
		NewExterior_Weapon_Levelup_LevelMax_Text:Show()
		NewExterior_Weapon_Levelup_LevelMax_Text:SetText("#{HSWQ_20220607_30}")
		-- ���ػ�����
		NewExterior_Weapon_Levelup_BigText:Hide()
	else
		if g_IdxList[nExteriorID] < 1 then
			-- δ����
			NewExterior_Weapon_Levelup_Level_Text:SetText("��ǰ������δ�������������")
			-- ��ʾ����
			NewExterior_Weapon_Levelup_DemandMoney:SetProperty("MoneyNumber", 0)
			NewExterior_Weapon_Levelup_LevelMax_Text:Hide()
			NewExterior_Weapon_Levelup_Cailiao_Text:SetText("")
			NewExterior_Weapon_Levelup_CailiaoNum_Text:SetText("")
			NewExterior_Weapon_Levelup_BigText:Show()
			return
		else
			-- δ����
			NewExterior_Weapon_Levelup_Level_Text:SetText(string.format("���εȼ���%s", tostring(lv)))
			-- ��ʾ����
			NewExterior_Weapon_Levelup_DemandMoney:SetProperty("MoneyNumber", tostring(money))
		end
		-- ��ʾ�������
		NewExterior_Weapon_Levelup_Cailiao_Text:SetText(string.format("����������ߣ�%s",LuaFnGetItemName(item)))
		-- ��ʾ��������
		NewExterior_Weapon_Levelup_CailiaoNum_Text:SetText(string.format("�����������������%s",itemnum))
		-- ��ʾ������
		NewExterior_Weapon_Levelup_BigText:Show()
		-- ����������
		NewExterior_Weapon_Levelup_LevelMax_Text:Hide()
	end

end


--��������ͼ��item
function NewExterior_Weapon_Levelup_ItemMouseMove(nIndex)

end

--�������������ť
function NewExterior_Weapon_Levelup_OnOK()

	if g_CurSelExteriorWeaponID <= 0 then
		return
	end
	
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("TryExteriorWeaponLevelUp")
		Set_XSCRIPT_ScriptID(900018)
		Set_XSCRIPT_Parameter(0, g_CurSelExteriorWeaponID)
		Set_XSCRIPT_Parameter(1, 1)
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()
end


--��������
function NewExterior_Weapon_Levelup_OnHiden()
	this:CareObject( g_clientNpcId, 0, "NewExterior_Weapon_Levelup" )
	g_clientNpcId = -1
	NewExterior_Weapon_Levelup_FakeObject:SetFakeObject("")

	SetGameMissionData("MD_WEAPONYULAN",0)
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("RideSysteam")
		Set_XSCRIPT_ScriptID(830243)
		Set_XSCRIPT_Parameter(0,11);
		Set_XSCRIPT_Parameter(1,-99);
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()	
	g_WeponLevelup_YuanBaoPay = 1--NewExterior_Weapon_Levelup_YuanBao:GetCheck()
	g_CurSelExteriorWeaponID = 0
	g_CurSelExteriorWeaponLevel = 1
	g_CurSelItemIndex = 1

end

--����رհ�ť
function NewExterior_Weapon_Levelup_CloseOnClick()
	SetGameMissionData("MD_WEAPONYULAN",0)
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("RideSysteam")
		Set_XSCRIPT_ScriptID(830243)
		Set_XSCRIPT_Parameter(0,11);
		Set_XSCRIPT_Parameter(1,-99);
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()	
	this:Hide()
end


function NewExterior_Weapon_Levelup_TurnLeft(start)
	local mouse_button = CEArg:GetValue("MouseButton")
	if(mouse_button == "LeftButton") then
		--������ת��ʼ
		if(start == 1) then
			NewExterior_Weapon_Levelup_FakeObject:RotateBegin(-0.3)
		--������ת����
		else
			NewExterior_Weapon_Levelup_FakeObject:RotateEnd()
		end
	end
end


function NewExterior_Weapon_Levelup_TurnRight(start)
	local mouse_button = CEArg:GetValue("MouseButton")
	if(mouse_button == "LeftButton") then
		--������ת��ʼ
		if(start == 1) then
			NewExterior_Weapon_Levelup_FakeObject:RotateBegin( 0.3)
		--������ת����
		else
			NewExterior_Weapon_Levelup_FakeObject:RotateEnd()
		end
	end
end

function NewExterior_Weapon_Levelup_CloseSameGroupWindow()
	CloseWindow("SelfEquip", true)
	CloseWindow("NewExterior_Ride", true)
	CloseWindow("NewExterior_Facestyle", true)
	CloseWindow("NewExterior_HairStyle", true)
	CloseWindow("NewExterior_PlayerFrame", true)
	CloseWindow("NewExterior_DressBox", true)
	CloseWindow("NewExterior_PetSoul", true)
	CloseWindow("NewExterior_Weapon", true)
	--CloseWindow("NewExterior_Weapon_Levelup", true)
	for i = 1,7 do
		if i == 0 then
			g_BarList[i].Item:SetPushed(1)
		else
			g_BarList[i].Item:SetPushed(0)
		end
	end
	g_CurSelItemIndex = 0
	g_CurSelExteriorWeaponID = 0
end

-- �Ƿ���������
function NewExterior_Weapon_Levelup_IsLevelUpLimit(idx)
	if idx <= 0 then
		return 0
	end

	local nExteriorID = Exterior:LuaFnGetExteriorWeaponIDFromList(idx - 1)
	local nMaxLevel = Exterior:LuaFnGetExteriorWeaponInfo(nExteriorID, "MaxLevel")
	if nMaxLevel ~= nil and nMaxLevel == g_LevelLimit then
		return 1
	end

	return 0
end