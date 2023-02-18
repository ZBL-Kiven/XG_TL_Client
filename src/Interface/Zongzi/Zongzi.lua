
-- 端午应景 粽子

local g_Zongzi_Frame_UnifiedPosition;

local g_Zongzi_Choose = 0

local g_Zongzi_bagIndex = -1

local g_Zongzi_LeftTime = 0

local g_Zongzi_State = 0

local g_Zongzi_Finish = 0

local g_Zongzi_IsGetGift = 0

local g_Zongzi_Image = {
	[1] = "set:Zongzi1 image:Zongzi_Danhuangzong",
	[2] = "set:Zongzi1 image:Zongzi_Dazaozong",
	[3] = "set:Zongzi1 image:Zongzi_Rouzong",
}
	
function Zongzi_PreLoad()

	this:RegisterEvent("UI_COMMAND");
	
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	
end

function Zongzi_OnLoad()

	g_Zongzi_Frame_UnifiedPosition = Zongzi_Frame:GetProperty("UnifiedPosition");
	
end

-- OnEvent
function Zongzi_OnEvent(event)
	--
	if ( event == "UI_COMMAND" and tonumber(arg0) == 89316102 ) then 
		
		if Get_XParam_INT(0) == 0 then
			Zongzi_OnHidden()
			return 
		end
		
		if IsWindowShow("Zongzi_ThreeChoice") then
			CloseWindow("Zongzi_ThreeChoice", true);
		end
		
		g_Zongzi_bagIndex = Get_XParam_INT(1)
		g_Zongzi_Choose = Get_XParam_INT(2)
		g_Zongzi_State = Get_XParam_INT(3)
		g_Zongzi_Finish = Get_XParam_INT(4)
		g_Zongzi_IsGetGift = Get_XParam_INT(5)
		g_Zongzi_LeftTime = Get_XParam_INT(6)
		
		Zongzi_OnShow()
		
	elseif ( event == "HIDE_ON_SCENE_TRANSED" ) then
		Zongzi_OnHidden()

	elseif (event == "ADJEST_UI_POS" ) then
		Zongzi_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		Zongzi_ResetPos()
		
	end
end

function Zongzi_OnShow()

	this:Show()
	
	Zongzi_Before:Hide()
	Zongzi_Before1:Hide()
	Zongzi_Before2:Hide()
	
	Zongzi_After:Hide()
	Zongzi_After1:Hide()	
	Zongzi_After2:Hide()
	
	-- 未开始 
	if g_Zongzi_State == 0 then
		Zongzi_Close:Show()	
		Zongzi_CloseAnimate:Play(false)
		
		Zongzi_Before:Show()
		Zongzi_Before1:Show()
	else
		Zongzi_Close:Hide()
		Zongzi_CloseAnimate:Play(false)
	end
	
	-- 煮中 开始 或 刷新
	if g_Zongzi_State == 2 or g_Zongzi_State == 1 then	
		if g_Zongzi_LeftTime > 0 then
			Zongzi_Before2_Watch:SetProperty("Timer", g_Zongzi_LeftTime);
		end
		
		Zongzi_Before:Show()
		Zongzi_Before2:Show()
		return
	end
	
	-- 失败 结束
	if g_Zongzi_State == 4 then				
		Zongzi_Close:Show()		
		Zongzi_CloseAnimate:Play(true)
		
		Zongzi_After:Show()
		Zongzi_After1:Show()
		return 
	end
	
	-- 成功 结束
	if g_Zongzi_State == 3 then	
		if g_Zongzi_Image[g_Zongzi_Choose] ~= nil then
			Zongzi_After_Succeed_Get:SetProperty("Image", g_Zongzi_Image[g_Zongzi_Choose])
		end
		
		Zongzi_After:Show()
		Zongzi_After2:Show()	
		return
	end
	
end

function Zongzi_GotoStart()
	
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("BeginZhuZongZi")
		Set_XSCRIPT_ScriptID(893161)
		Set_XSCRIPT_Parameter(0, g_Zongzi_bagIndex)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()	
	
end

function Zongzi_GetGift()
	
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("GetZhuZongZiGift")
		Set_XSCRIPT_ScriptID(893161)
		Set_XSCRIPT_Parameter(0, g_Zongzi_bagIndex)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()	
	
end

function Zongzi_OnHidden()

	this:Hide()
	
end

function Zongzi_StopWatch_TimeOut()

	Zongzi_Before2:Hide()
	
end

function Zongzi_ResetPos()

  Zongzi_Frame:SetProperty("UnifiedPosition", g_Zongzi_Frame_UnifiedPosition);
  
end

