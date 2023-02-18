--!!!reloadscript =GXHcolorstyle

local g_Select_Index = 0
local g_SelectHairstyle_Frame_UnifiedPosition

local GXHcolorstyle_Color = {}
local GXHcolorstyle_Item = {}

local g_Red = {}
local g_Green = {}
local g_Blue = {}
local g_Alpha = {}

local g_Change_Color = 0
local g_YB_Confirm = 0

function GXHcolorstyle_PreLoad()	
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("ADJEST_UI_POS", false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED", false)
end

function GXHcolorstyle_OnLoad()
	
	GXHcolorstyle_Color[1] = GXHcolorstyle_BKG1
	GXHcolorstyle_Color[2] = GXHcolorstyle_BKG2
	GXHcolorstyle_Color[3] = GXHcolorstyle_BKG3
	GXHcolorstyle_Color[4] = GXHcolorstyle_BKG4
	GXHcolorstyle_Color[5] = GXHcolorstyle_BKG5
	GXHcolorstyle_Color[6] = GXHcolorstyle_BKG6
	GXHcolorstyle_Color[7] = GXHcolorstyle_BKG7
	GXHcolorstyle_Color[8] = GXHcolorstyle_BKG8
	GXHcolorstyle_Color[9] = GXHcolorstyle_BKG9
	GXHcolorstyle_Color[10] = GXHcolorstyle_BKG10
	GXHcolorstyle_Color[11] = GXHcolorstyle_BKG11
	GXHcolorstyle_Color[12] = GXHcolorstyle_BKG12
	GXHcolorstyle_Color[13] = GXHcolorstyle_BKG13
	GXHcolorstyle_Color[14] = GXHcolorstyle_BKG14
	GXHcolorstyle_Color[15] = GXHcolorstyle_BKG15
	GXHcolorstyle_Color[16] = GXHcolorstyle_BKG16
	GXHcolorstyle_Color[17] = GXHcolorstyle_BKG17
	GXHcolorstyle_Color[18] = GXHcolorstyle_BKG18
	GXHcolorstyle_Color[19] = GXHcolorstyle_BKG19
	GXHcolorstyle_Color[20] = GXHcolorstyle_BKG20
	
	GXHcolorstyle_Item[1] = GXHcolorstyle_Item1
	GXHcolorstyle_Item[2] = GXHcolorstyle_Item2
	GXHcolorstyle_Item[3] = GXHcolorstyle_Item3
	GXHcolorstyle_Item[4] = GXHcolorstyle_Item4
	GXHcolorstyle_Item[5] = GXHcolorstyle_Item5
	GXHcolorstyle_Item[6] = GXHcolorstyle_Item6
	GXHcolorstyle_Item[7] = GXHcolorstyle_Item7
	GXHcolorstyle_Item[8] = GXHcolorstyle_Item8
	GXHcolorstyle_Item[9] = GXHcolorstyle_Item9
	GXHcolorstyle_Item[10] = GXHcolorstyle_Item10
	GXHcolorstyle_Item[11] = GXHcolorstyle_Item11
	GXHcolorstyle_Item[12] = GXHcolorstyle_Item12
	GXHcolorstyle_Item[13] = GXHcolorstyle_Item13
	GXHcolorstyle_Item[14] = GXHcolorstyle_Item14
	GXHcolorstyle_Item[15] = GXHcolorstyle_Item15
	GXHcolorstyle_Item[16] = GXHcolorstyle_Item16
	GXHcolorstyle_Item[17] = GXHcolorstyle_Item17
	GXHcolorstyle_Item[18] = GXHcolorstyle_Item18
	GXHcolorstyle_Item[19] = GXHcolorstyle_Item19
	GXHcolorstyle_Item[20] = GXHcolorstyle_Item20
	
	g_GXHcolorstyle_Frame_UnifiedPosition = GXHcolorstyle_Frame:GetProperty("UnifiedPosition")
end

function GXHcolorstyle_OnEvent(event)
	if event == "UI_COMMAND" then		
		if tonumber(arg0) == 80101102 then
			g_Change_Color = Get_XParam_INT(0)
			g_YB_Confirm = Get_XParam_INT(1)
			
			this:Show()
			GXHcolorstyle_OnShown()
		elseif tonumber(arg0) == 80101103 then
			this:Hide()
		end
	end
	
	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		GXHcolorstyle_Frame_On_ResetPos()
	end
	
end

function GXHcolorstyle_Frame_On_ResetPos()
	GXHcolorstyle_Frame:SetProperty("UnifiedPosition", g_GXHcolorstyle_Frame_UnifiedPosition)
end

function GXHcolorstyle_OnShown()	
	for i = 1, 20 do
		GXHcolorstyle_Color[i]:SetImageColor("00FFFFFF")
		GXHcolorstyle_Item[i]:SetPushed(0)
	end
			
	GXHcolorstyle_Text:SetText("#{GXHDZ_141121_45}")
	
	Original_gxh_count = Exterior:LuaFnGetExteriorHairColorCount()
	
	for i = 1, Original_gxh_count do
		g_Red[i], g_Green[i], g_Blue[i], g_Alpha[i] = Exterior:LuaFnEnumExteriorHairColor(i - 1)
		curIcon = string.format("%02X", 255)..string.format("%02X", g_Red[i])..string.format("%02X", g_Green[i])..string.format("%02X", g_Blue[i])
		GXHcolorstyle_Color[i]:SetImageColor(curIcon)
	end
end

function GXHcolorstyle_Clicked(nIndex)
	
	for i = 1, 20 do
		GXHcolorstyle_Item[i]:SetPushed(0)
	end
	GXHcolorstyle_Item[nIndex]:SetPushed(1)
		
	g_Select_Index = nIndex
	DataPool:Change_MyHairColor(g_Red[nIndex], g_Green[nIndex], g_Blue[nIndex], 255)
end

function GXHcolorstyle_OnClose()
	this:Hide()
end

function GXHcolorstyle_Cancel_Clicked()
	this:Hide()
end

function GXHcolorstyle_OK_Clicked()
	
	if g_Select_Index == 0 then
		PushDebugMessage("#{GXHDZ_141121_55}")
		return
	end			
	
	Set_XSCRIPT_Function_Name("SaveNewHairColor")
		Set_XSCRIPT_ScriptID(801011)
		Set_XSCRIPT_Parameter(0, g_Change_Color)
		Set_XSCRIPT_Parameter(1, g_YB_Confirm)
		Set_XSCRIPT_Parameter(2, g_Select_Index - 1)
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
end

function GXHcolorstyle_OnHidden()
	if g_Select_Index ~= -1 then
		GXHcolorstyle_ChangeHairColorByValue(g_Change_Color)
	end
	GXHcolorstyle_CleanUp()
end

function GXHcolorstyle_CleanUp()
	g_Select_Index = 0
	g_Change_Color = 0
end

function GXHcolorstyle_ChangeHairColorByValue(ColorValue)
	
	local color = ColorValue
	if color < 0 then
		color = color + 4294967296			--将INT传过来的负值转化为对应UINT的正值
	end

	color = math.floor(color / 256)
	local color_b = math.mod(color, 256) 
	color = math.floor(color / 256)
	local color_g = math.mod(color, 256) 
	color = math.floor(color / 256)
	local color_r = math.mod(color, 256) 

	DataPool:Change_MyHairColor(color_r, color_g, color_b, 255)
	
end