local g_Frame_UnifiedPosition
--箭簇最大进度
local g_jiancu_max = 18
--秦剑最大进度
local g_qinjian_max = 30
--弩机最大进度
local g_nuji_max = 42

local g_Object = -1
local g_DiWangQi_Table = {}
local g_IsRepaired = 0 --帝王器当日是否修复过 
local g_IsJianCuGotReward = 0
local g_IsQinJianGotReward = 0
local g_IsNuJiGotReward = 0
--=========
--PreLoad==
--=========
function DiWangQi_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
end
--=========
--OnLoad
--=========
function DiWangQi_OnLoad()
	g_Frame_UnifiedPosition = DiWangQi_Frame:GetProperty("UnifiedPosition")
	g_DiWangQi_Table = 
	{
		Low =
		{
			DiWangQi_Frame_Bk1_ImageLow,
			DiWangQi_Frame_Bk2_ImageLow,
			DiWangQi_Frame_Bk3_ImageLow
		},
		Mid =
		{
			DiWangQi_Frame_Bk1_ImageMid,
			DiWangQi_Frame_Bk2_ImageMid,
			DiWangQi_Frame_Bk3_ImageMid
		},
		Done =
		{
			DiWangQi_Frame_Bk1_ImageDone,
			DiWangQi_Frame_Bk2_ImageDone,
			DiWangQi_Frame_Bk3_ImageDone
		},
		-- OpenBox =
		-- {
		-- 	DiWangQi_Frame_Bk1_GiftImage,
		-- 	DiWangQi_Frame_Bk2_GiftImage,
		-- 	DiWangQi_Frame_Bk3_GiftImage
		-- },
		-- CloseBox =
		-- {
		-- 	DiWangQi_Frame_Bk1_GiftBtn,
		-- 	DiWangQi_Frame_Bk2_GiftBtn,
		-- 	DiWangQi_Frame_Bk3_GiftBtn
		-- },
		-- FixButton =
		-- {
		-- 	DiWangQi_Frame_Bk1_Btn,
		-- 	DiWangQi_Frame_Bk2_Btn,
		-- 	DiWangQi_Frame_Bk3_Btn
		-- },
		ProgressLabel =
		{
			DiWangQi_Frame_Bk1_text,
			DiWangQi_Frame_Bk2_text,
			DiWangQi_Frame_Bk3_text
		},
		Progress =
		{
			DiWangQi_Frame_Bk1_EXP,
			DiWangQi_Frame_Bk2_EXP,
			DiWangQi_Frame_Bk3_EXP
		},
		CurProgress = 
		{
			0,0,0
		},
		MaxProgress = 
		{
			[1] = g_jiancu_max,
			[2] = g_qinjian_max,
			[3] = g_nuji_max
		}

	}
	
end
--=========
--OnEvent
--=========
function DiWangQi_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == 2021050801) then
		if( this:IsVisible() == false ) then
			local xx = Get_XParam_INT(0);
			if tonumber(xx) == -1 then
				return
			end
			objCared = -1
			objCared = DataPool : GetNPCIDByServerID(xx);
			if tonumber(objCared)==nil or  tonumber(objCared)== -1 then
				PushDebugMessage("server传过来的数据有问题。");
				return
			end
			this:Show()
			DiWangQi_BeginCareObject(objCared)
		end
		g_DiWangQi_Table.CurProgress[1] = Get_XParam_INT(1)
		g_DiWangQi_Table.CurProgress[2] = Get_XParam_INT(2)
		g_DiWangQi_Table.CurProgress[3] = Get_XParam_INT(3)
		g_IsRepaired = Get_XParam_INT(4)
		g_IsJianCuGotReward = Get_XParam_INT(5)
		g_IsQinJianGotReward = Get_XParam_INT(6)
		g_IsNuJiGotReward = Get_XParam_INT(7)
		DiWangQi_Refresh()
		
	elseif (event == "ADJEST_UI_POS" ) then
		DiWangQi_On_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		DiWangQi_On_ResetPos()
	end
	
end

function DiWangQi_BeginCareObject(objCared)
	g_Object = objCared;
	this:CareObject(tonumber(g_Object), 1, "DiWangQi");
end

function DiWangQi_On_ResetPos()
	DiWangQi_Frame:SetProperty("UnifiedPosition", g_Frame_UnifiedPosition)
end
--=========
--Show UI
--=========
function DiWangQi_Refresh()
	for i=1,3 do 
		local progressText = ScriptGlobal_Format("#{DWQ_210428_20}", g_DiWangQi_Table.CurProgress[i], g_DiWangQi_Table.MaxProgress[i])
		g_DiWangQi_Table.ProgressLabel[i]:SetText(progressText)
	end
	-- if g_IsRepaired ==1 then
	-- 	DiWangQi_Frame_Bk1_Btn:Disable()
	-- 	DiWangQi_Frame_Bk2_Btn:Disable()
	-- 	DiWangQi_Frame_Bk3_Btn:Disable()
	-- else
	-- 	DiWangQi_Frame_Bk1_Btn:Enable()
	-- 	DiWangQi_Frame_Bk2_Btn:Enable()
	-- 	DiWangQi_Frame_Bk3_Btn:Enable()
	-- end
	if g_IsJianCuGotReward == 1 then
		DiWangQi_Frame_Bk1_GiftBtn:Hide()
		DiWangQi_Frame_Bk1_GiftImage:Show()
	else
		DiWangQi_Frame_Bk1_GiftBtn:Show()
		DiWangQi_Frame_Bk1_GiftImage:Hide()
	end
	if g_IsQinJianGotReward == 1 then
		DiWangQi_Frame_Bk2_GiftBtn:Hide()
		DiWangQi_Frame_Bk2_GiftImage:Show()
	else
		DiWangQi_Frame_Bk2_GiftBtn:Show()
		DiWangQi_Frame_Bk2_GiftImage:Hide()
	end
	if g_IsNuJiGotReward == 1 then
		DiWangQi_Frame_Bk3_GiftBtn:Hide()
		DiWangQi_Frame_Bk3_GiftImage:Show()
	else
		DiWangQi_Frame_Bk3_GiftBtn:Show()
		DiWangQi_Frame_Bk3_GiftImage:Hide()
	end
	for i=1,3 do 
		g_DiWangQi_Table.Low[i]:Hide()
		g_DiWangQi_Table.Mid[i]:Hide()
		g_DiWangQi_Table.Done[i]:Hide()
	end
	for i=1,3 do
		if g_DiWangQi_Table.CurProgress[i] >= g_DiWangQi_Table.MaxProgress[i] then
			g_DiWangQi_Table.Done[i]:Show()
		elseif math.floor(g_DiWangQi_Table.CurProgress[i]*100/g_DiWangQi_Table.MaxProgress[i])>=40	then
			g_DiWangQi_Table.Mid[i]:Show()
		else
			g_DiWangQi_Table.Low[i]:Show()
		end

		if g_DiWangQi_Table.CurProgress[i] >= g_DiWangQi_Table.MaxProgress[i] then
			g_DiWangQi_Table.Progress[i]:SetProgress(g_DiWangQi_Table.MaxProgress[i], g_DiWangQi_Table.MaxProgress[i])
		else
			g_DiWangQi_Table.Progress[i]:SetProgress(g_DiWangQi_Table.CurProgress[i], g_DiWangQi_Table.MaxProgress[i])

		end
	end
	
end

--=========
--OnClose "X"
--=========
function DiWangQi_Close()
	this:Hide()
end
--=========
--handle Hide Event
--=========
function DiWangQi_OnHiden()
	this:CareObject(tonumber(g_Object), 0, "DiWangQi");
	g_Object = -1
	g_IsRepaired = 0 
	g_IsJianCuGotReward = 0
	g_IsQinJianGotReward = 0
	g_IsNuJiGotReward = 0
end

function DiWangQi_XiuFu(index)
	-- PushDebugMessage("index1:"..tostring(index))
	Clear_XSCRIPT();
	Set_XSCRIPT_Function_Name("RepaireDiWangQi")
	Set_XSCRIPT_ScriptID(891145);
	Set_XSCRIPT_Parameter(0,index)
	Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT();
end

function DiWangQi_GetReward(index)
	-- PushDebugMessage("index2:"..tostring(index))
	Clear_XSCRIPT();
	Set_XSCRIPT_Function_Name("GetRewardDiWangQi")
	Set_XSCRIPT_ScriptID(891145);
	Set_XSCRIPT_Parameter(0,index)
	Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT();
	
end