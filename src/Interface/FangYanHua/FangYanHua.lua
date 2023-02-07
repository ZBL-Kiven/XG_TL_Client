
-- 五一打卡 放烟花 

local g_FangYanHua_Frame_UnifiedPosition;

local g_FangYanHua_IconList = {}
local g_FangYanHua_ImageList = {}
local g_FangYanHua_ButtonList = {}

local g_FangYanHua_PosOkList = {0,0,0,0,0,0} 
local g_FangYanHua_LeftTime = 0
local g_FangYanHua_IsFinish = 0
	
function FangYanHua_PreLoad()

	this:RegisterEvent("UI_COMMAND");
	
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	
end

function FangYanHua_OnLoad()

	g_FangYanHua_Frame_UnifiedPosition = FangYanHua_Frame:GetProperty("UnifiedPosition");
	
	g_FangYanHua_IconList[1] = FangYanHua_Icon1
	g_FangYanHua_IconList[2] = FangYanHua_Icon2
	g_FangYanHua_IconList[3] = FangYanHua_Icon3
	g_FangYanHua_IconList[4] = FangYanHua_Icon4
	g_FangYanHua_IconList[5] = FangYanHua_Icon5
	g_FangYanHua_IconList[6] = FangYanHua_Icon6
	
	g_FangYanHua_ImageList[1] = FangYanHua_Icon1_OK
	g_FangYanHua_ImageList[2] = FangYanHua_Icon2_OK
	g_FangYanHua_ImageList[3] = FangYanHua_Icon3_OK
	g_FangYanHua_ImageList[4] = FangYanHua_Icon4_OK
	g_FangYanHua_ImageList[5] = FangYanHua_Icon5_OK
	g_FangYanHua_ImageList[6] = FangYanHua_Icon6_OK
	
	g_FangYanHua_ButtonList[1] = FangYanHua_BtnGo1
	g_FangYanHua_ButtonList[2] = FangYanHua_BtnGo2
	g_FangYanHua_ButtonList[3] = FangYanHua_BtnGo3
	g_FangYanHua_ButtonList[4] = FangYanHua_BtnGo4
	g_FangYanHua_ButtonList[5] = FangYanHua_BtnGo5
	g_FangYanHua_ButtonList[6] = FangYanHua_BtnGo6
	
end

-- OnEvent
function FangYanHua_OnEvent(event)
	--
	if ( event == "UI_COMMAND" and tonumber(arg0) == 89312101 ) then 
		
		if Get_XParam_INT(0) == 0 then
			FangYanHua_OnHiden()
			return 
		end
		
		for idx = 1, 6 do
			g_FangYanHua_PosOkList[idx] = Get_XParam_INT(idx) 
		end
		g_FangYanHua_IsFinish = Get_XParam_INT(7)
		g_FangYanHua_LeftTime = Get_XParam_INT(8) 
		
		FangYanHua_OnShow()

	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 89312102 ) then 
	
		local nsceneId = Get_XParam_INT(0)
		local PosX = Get_XParam_INT(1)
		local PosZ = Get_XParam_INT(2)
		AutoRunToTargetEx(PosX, PosZ, nsceneId)

	elseif ( event == "HIDE_ON_SCENE_TRANSED" ) then
		FangYanHua_OnHiden()

	elseif (event == "ADJEST_UI_POS" ) then
		FangYanHua_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		FangYanHua_ResetPos()
		
	end
end

function FangYanHua_OnShow()

	for idx = 1, 6 do
		g_FangYanHua_ImageList[idx]:Hide()
		if g_FangYanHua_PosOkList[idx] == 1 then
			g_FangYanHua_ImageList[idx]:Show()
		end
	end
	
	FangYanHua_Time:Hide()
	
	FangYanHua_Image:Hide()
	FangYanHua_Image2:Hide()
	
	if g_FangYanHua_IsFinish == 1 then		
		FangYanHua_TimeText:SetText("#{FYH_220407_127}")
		if g_FangYanHua_LeftTime <= 0 then
			FangYanHua_Image:Show()
		else
			FangYanHua_Image2:Show()
		end
	else
		if g_FangYanHua_LeftTime <= 0 then
			FangYanHua_TimeText:SetText("#{FYH_220407_119}")
		else
			FangYanHua_TimeText:SetText("#{FYH_220407_56}")
			FangYanHua_Time:Show()		
			FangYanHua_Time:SetProperty("Timer", g_FangYanHua_LeftTime);
		end
	end	

	this:Show()
	
end

function FangYanHua_OnTimer()
	
	FangYanHua_TimeText:SetText("#{FYH_220407_119}")
	FangYanHua_Time:Hide()
	
end

function FangYanHua_BtnGo( idx )
	
	if idx < 1 or idx > 6 then
		return
	end
	
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("GoToFirePos")
		Set_XSCRIPT_ScriptID(893121)
		Set_XSCRIPT_Parameter(0, idx)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()	
	
end

function FangYanHua_OnHiden()

	this:Hide()
	
end

function FangYanHua_ResetPos()

  FangYanHua_Frame:SetProperty("UnifiedPosition", g_FangYanHua_Frame_UnifiedPosition);
  
end

