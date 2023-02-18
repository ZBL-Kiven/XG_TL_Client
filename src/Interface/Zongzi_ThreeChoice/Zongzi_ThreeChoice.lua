
-- ¶ËÎçÓ¦¾° ÖóôÕ×Ó

local g_Zongzi_ThreeChoice_Frame_UnifiedPosition;

local g_Zongzi_ThreeChoice_IconList = {}
local g_Zongzi_ThreeChoice_IconMask = {}

local g_Zongzi_ThreeChoice_Choose = 0

local g_Zongzi_ThreeChoice_bagIndex = -1
	
function Zongzi_ThreeChoice_PreLoad()

	this:RegisterEvent("UI_COMMAND");
	
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	
end

function Zongzi_ThreeChoice_OnLoad()

	g_Zongzi_ThreeChoice_Frame_UnifiedPosition = Zongzi_ThreeChoice_Frame:GetProperty("UnifiedPosition");
	
	g_Zongzi_ThreeChoice_IconList[1] = Zongzi_ThreeChoice_Gift1_Icon
	g_Zongzi_ThreeChoice_IconList[2] = Zongzi_ThreeChoice_Gift2_Icon
	g_Zongzi_ThreeChoice_IconList[3] = Zongzi_ThreeChoice_Gift3_Icon
	
	g_Zongzi_ThreeChoice_IconMask[1] = Zongzi_ThreeChoice_Gift1_Icon_Mask
	g_Zongzi_ThreeChoice_IconMask[2] = Zongzi_ThreeChoice_Gift2_Icon_Mask
	g_Zongzi_ThreeChoice_IconMask[3] = Zongzi_ThreeChoice_Gift3_Icon_Mask
	
end

-- OnEvent
function Zongzi_ThreeChoice_OnEvent(event)
	--
	if ( event == "UI_COMMAND" and tonumber(arg0) == 89316101 ) then 
		
		if Get_XParam_INT(0) == 0 then
			Zongzi_ThreeChoice_OnClose()
			return 
		end
		
		if IsWindowShow("Zongzi") then
			CloseWindow("Zongzi", true);
		end
		
		g_Zongzi_ThreeChoice_bagIndex = Get_XParam_INT(1)
		
		Zongzi_ThreeChoice_OnShow()

	elseif ( event == "HIDE_ON_SCENE_TRANSED" ) then
		Zongzi_ThreeChoice_OnClose()

	elseif (event == "ADJEST_UI_POS" ) then
		Zongzi_ThreeChoice_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		Zongzi_ThreeChoice_ResetPos()
		
	end
end

function Zongzi_ThreeChoice_OnShow()

	for i = 1, 3 do
		g_Zongzi_ThreeChoice_IconMask[i]:Hide()
	end
	
	g_Zongzi_ThreeChoice_Choose = 0

	this:Show()
	
end

function Zongzi_ThreeChoice_Confirm()
	
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnPlayerModelTrans")
		Set_XSCRIPT_ScriptID(893161)
		Set_XSCRIPT_Parameter(0, g_Zongzi_ThreeChoice_bagIndex)
		Set_XSCRIPT_Parameter(1, g_Zongzi_ThreeChoice_Choose)
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()	
	
end

function Zongzi_ThreeChoice_Select( nChoice )
	
	if nChoice < 1 or nChoice > 3 then
		return
	end
	
	if g_Zongzi_ThreeChoice_Choose == nChoice then
		return
	end
	
	g_Zongzi_ThreeChoice_Choose = nChoice
	
	for i = 1, 3 do
		g_Zongzi_ThreeChoice_IconMask[i]:Hide()
		--g_Zongzi_ThreeChoice_IconList[i]:SetPushed(0)
		if g_Zongzi_ThreeChoice_Choose == i then
			g_Zongzi_ThreeChoice_IconMask[i]:Show()
			--g_Zongzi_ThreeChoice_IconList[i]:SetPushed(1)
		end
	end
	
end

function Zongzi_ThreeChoice_OnHelp()
end

function Zongzi_ThreeChoice_OnClose()

	g_Zongzi_ThreeChoice_Choose = 0

	this:Hide()
	
end

function Zongzi_ThreeChoice_ResetPos()

  Zongzi_ThreeChoice_Frame:SetProperty("UnifiedPosition", g_Zongzi_ThreeChoice_Frame_UnifiedPosition);
  
end

