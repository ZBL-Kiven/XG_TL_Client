-- 界面的默认相对位置
local g_SweepAll_Frame_UnifiedXPosition;
local g_SweepAll_Frame_UnifiedYPosition;

local g_SweepAll_Page = 0
local g_nContentButton = {}

--按照扫荡等级进行排序
local g_SweepAll_Index = {}

local g_SweepAll_DoubleStartTime = 20190506
local g_SweepAll_DoubleEndTime = 20190522

--对应的副本ID
local g_SweepAll_FubenId = {
	[1]={"一个都不能跑",        30,  120,  6,  5,  "set:Huodong_12 image:Huodong_12_1"},
	[2]={"除害",        30,  120,  6,  5,  "set:Huodong_12 image:Huodong_12_2"},
	[3]={"剿匪",              30,  120,  6,  5,  "set:Huodong_12 image:Huodong_12_5"},
	[4]={"黄金之链",        75,  120,  6,  5,  "set:Huodong_12 image:Huodong_12_6"},
	[5]={"玄佛珠",            75,  120,  6,  5,  "set:Huodong_12 image:Huodong_12_3"},
	[6]={"熔岩之地",          75,  120,  6,  5,  "set:Huodong_12 image:Huodong_12_4"},
	[7]={"讨伐燕子坞",  60,  80,  8,  3,  "set:LongZhengWuZai_Icon1 image:LongZhengWuZai_Icon1_16"},
	[8]={"杀星",        70,  80,  8,  2,  "set:SalaryMission image:SalaryMission_12"},
	[9]={"初战缥缈峰",          75,  80,  8,  2,  "set:Huodong_9 image:Huodong_9_6"},
	[10]={"挑战缥缈峰", 90,  80,  8,  3,  "set:Huodong_9 image:Huodong_9_6"},
	[11]={"水月山庄",         80,  80,  8,  2,  "set:Huodong_12 image:Huodong_12_9"},
}

local g_SweepAll_All = {}
local g_SweepAll_Icon = {}
local g_SweepAll_Name = {}
local g_SweepAll_Lev = {}
local g_SweepAll_AllPoint = {}
local g_SweepAll_Point = {}
local g_SweepAll_Sweep = {}
local g_SweepAll_List = {}

local g_mySweepAll_Point = {}
local g_mySweepAlso = {}
local g_mySweepBeing = {}

function SweepAll_PreLoad()
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS",false)

	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false);

	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("SHOW_SECKILL_LIST")
	this:RegisterEvent("OPEN_SECKILL_LIST")
end

function SweepAll_OnLoad()
	g_SweepAll_Frame_UnifiedXPosition = SweepAll_Frame : GetProperty("UnifiedXPosition");
	g_SweepAll_Frame_UnifiedYPosition = SweepAll_Frame : GetProperty("UnifiedYPosition");

	g_SweepAll_All[1] = SweepAll_Title_1
	g_SweepAll_All[2] = SweepAll_Title_2
	g_SweepAll_All[3] = SweepAll_Title_3
	g_SweepAll_All[4] = SweepAll_Title_4
	g_SweepAll_All[5] = SweepAll_Title_5
	g_SweepAll_All[6] = SweepAll_Title_6
	g_SweepAll_All[7] = SweepAll_Title_7
	g_SweepAll_All[8] = SweepAll_Title_8

	g_SweepAll_Icon[1] = SweepAll_Title_Icon_1
	g_SweepAll_Icon[2] = SweepAll_Title_Icon_2
	g_SweepAll_Icon[3] = SweepAll_Title_Icon_3
	g_SweepAll_Icon[4] = SweepAll_Title_Icon_4
	g_SweepAll_Icon[5] = SweepAll_Title_Icon_5
	g_SweepAll_Icon[6] = SweepAll_Title_Icon_6
	g_SweepAll_Icon[7] = SweepAll_Title_Icon_7
	g_SweepAll_Icon[8] = SweepAll_Title_Icon_8

	g_SweepAll_Name[1] = SweepAll_Title_activity_1
	g_SweepAll_Name[2] = SweepAll_Title_activity_2
	g_SweepAll_Name[3] = SweepAll_Title_activity_3
	g_SweepAll_Name[4] = SweepAll_Title_activity_4
	g_SweepAll_Name[5] = SweepAll_Title_activity_5
	g_SweepAll_Name[6] = SweepAll_Title_activity_6
	g_SweepAll_Name[7] = SweepAll_Title_activity_7
	g_SweepAll_Name[8] = SweepAll_Title_activity_8

	g_SweepAll_Lev[1] = SweepAll_Title_level_1
	g_SweepAll_Lev[2] = SweepAll_Title_level_2
	g_SweepAll_Lev[3] = SweepAll_Title_level_3
	g_SweepAll_Lev[4] = SweepAll_Title_level_4
	g_SweepAll_Lev[5] = SweepAll_Title_level_5
	g_SweepAll_Lev[6] = SweepAll_Title_level_6
	g_SweepAll_Lev[7] = SweepAll_Title_level_7
	g_SweepAll_Lev[8] = SweepAll_Title_level_8

	g_SweepAll_AllPoint[1] = SweepAll_Title_allpoint_1
	g_SweepAll_AllPoint[2] = SweepAll_Title_allpoint_2
	g_SweepAll_AllPoint[3] = SweepAll_Title_allpoint_3
	g_SweepAll_AllPoint[4] = SweepAll_Title_allpoint_4
	g_SweepAll_AllPoint[5] = SweepAll_Title_allpoint_5
	g_SweepAll_AllPoint[6] = SweepAll_Title_allpoint_6
	g_SweepAll_AllPoint[7] = SweepAll_Title_allpoint_7
	g_SweepAll_AllPoint[8] = SweepAll_Title_allpoint_8

	g_SweepAll_Point[1] = SweepAll_Title_point_1
	g_SweepAll_Point[2] = SweepAll_Title_point_2
	g_SweepAll_Point[3] = SweepAll_Title_point_3
	g_SweepAll_Point[4] = SweepAll_Title_point_4
	g_SweepAll_Point[5] = SweepAll_Title_point_5
	g_SweepAll_Point[6] = SweepAll_Title_point_6
	g_SweepAll_Point[7] = SweepAll_Title_point_7
	g_SweepAll_Point[8] = SweepAll_Title_point_8

	g_SweepAll_Sweep[1] = SweepAll_Title_sweep_1
	g_SweepAll_Sweep[2] = SweepAll_Title_sweep_2
	g_SweepAll_Sweep[3] = SweepAll_Title_sweep_3
	g_SweepAll_Sweep[4] = SweepAll_Title_sweep_4
	g_SweepAll_Sweep[5] = SweepAll_Title_sweep_5
	g_SweepAll_Sweep[6] = SweepAll_Title_sweep_6
	g_SweepAll_Sweep[7] = SweepAll_Title_sweep_7
	g_SweepAll_Sweep[8] = SweepAll_Title_sweep_8

	g_SweepAll_List[1] = SweepAll_List_1
	g_SweepAll_List[2] = SweepAll_List_2
	g_SweepAll_List[3] = SweepAll_List_3
	g_SweepAll_List[4] = SweepAll_List_4
	g_SweepAll_List[5] = SweepAll_List_5
	g_SweepAll_List[6] = SweepAll_List_6
	g_SweepAll_List[7] = SweepAll_List_7
	g_SweepAll_List[8] = SweepAll_List_8

end

-- OnEvent
function SweepAll_OnEvent(event)

	if(event == "UI_COMMAND" ) then
		if tonumber(arg0) == 2015101902 then
			if IsWindowShow("SweepPage") then
				CloseWindow( "SweepPage" , true)
			end		
            local mySweep = {}
            for i = 1,12 do
                mySweep[i] = Get_XParam_INT(i-1)
				g_mySweepAll_Point[i] = math.floor(mySweep[i]/10)
				g_mySweepAlso[i] = math.mod(mySweep[i],10)
				g_mySweepBeing[i] = 0
            end
		   this:Show()
		   SweepAll_On_Open()
		end

	-- 游戏窗口尺寸发生了变化
	elseif (event == "ADJEST_UI_POS" ) then
		-- 更新背包界面位置
		SweepAll_Frame_On_ResetPos()

	-- 游戏分辨率发生了变化
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		-- 更新背包界面位置
		SweepAll_Frame_On_ResetPos()
	elseif ( event == "HIDE_ON_SCENE_TRANSED" ) then
		SweepAll_OnClosed()
	end
end

--================================================
-- 恢复界面的默认相对位置
--================================================
function SweepAll_Frame_On_ResetPos()
	SweepAll_Frame : SetProperty("UnifiedXPosition", g_SweepAll_Frame_UnifiedXPosition);
	SweepAll_Frame : SetProperty("UnifiedYPosition", g_SweepAll_Frame_UnifiedYPosition);
end

--=================================================
--打开扫荡界面
--==================================================
function SweepAll_On_Open()
    g_SweepAll_Page = 0
	for i = 1,8 do
		g_SweepAll_All[i]:Show()
		g_SweepAll_Icon[i]:SetProperty("Image",g_SweepAll_FubenId[i][6])
		g_SweepAll_Name[i]:SetText("#G"..g_SweepAll_FubenId[i][1])
		g_SweepAll_Lev[i]:SetText("#G"..g_SweepAll_FubenId[i][2])
		if g_mySweepAll_Point[i] < tonumber(g_SweepAll_FubenId[i][4]) then
			g_SweepAll_AllPoint[i]:SetText( "#cff0000"..tostring(g_mySweepAll_Point[i]).."/"..tostring(g_SweepAll_FubenId[i][3]) )
		else
			g_SweepAll_AllPoint[i]:SetText( "#G"..tostring(g_mySweepAll_Point[i]).."/"..tostring(g_SweepAll_FubenId[i][3]) )
		end
		g_SweepAll_Point[i]:SetText("#G"..tostring(g_SweepAll_FubenId[i][4]))
		local Number = tostring(g_SweepAll_FubenId[i][5]) --一共可以刷几次
		local Micount = Number - g_mySweepAlso[i] ---------------------------还剩几次
		if Micount <= 0 then
			g_SweepAll_Sweep[i]:SetText( "#cff0000"..tostring(Micount).."/"..tostring(Number) )
		else
			g_SweepAll_Sweep[i]:SetText( "#G"..tostring(Micount).."/"..tostring(Number) )
		end
		if g_mySweepBeing[i] == 1 then
			g_SweepAll_List[i]:SetText("#G扫荡中")
		else
			g_SweepAll_List[i]:SetText("扫荡")
		end
	end
end


function SweepAll_On_Open2()
    g_SweepAll_Page = 1
	for i = 1,8 do
		g_SweepAll_All[i]:Hide()
	end
	for i = 1,3 do
		g_SweepAll_All[i]:Show()
		g_SweepAll_Icon[i]:SetProperty("Image",g_SweepAll_FubenId[i+8][6])
		g_SweepAll_Name[i]:SetText("#G"..g_SweepAll_FubenId[i+8][1])
		g_SweepAll_Lev[i]:SetText("#G"..g_SweepAll_FubenId[i+8][2])

		if g_mySweepAll_Point[i+8] < tonumber(g_SweepAll_FubenId[i+8][4]) then
			g_SweepAll_AllPoint[i]:SetText( "#cff0000"..tostring(g_mySweepAll_Point[i+8]).."/"..tostring(g_SweepAll_FubenId[i+8][3]) )
		else
			g_SweepAll_AllPoint[i]:SetText( "#G"..tostring(g_mySweepAll_Point[i+8]).."/"..tostring(g_SweepAll_FubenId[i+8][3]) )
		end
		g_SweepAll_Point[i]:SetText("#G"..tostring(g_SweepAll_FubenId[i+8][4]))

		local Number = tostring(g_SweepAll_FubenId[i+8][5]) --一共可以刷几次
		local Micount = Number - g_mySweepAlso[i+8]  ---------------------------还剩几次

		if Micount <= 0 then
			g_SweepAll_Sweep[i]:SetText( "#cff0000"..tostring(Micount).."/"..tostring(Number) )
		else
			g_SweepAll_Sweep[i]:SetText( "#G"..tostring(Micount).."/"..tostring(Number) )
		end
		if g_mySweepBeing[i+8] == 1 then
			g_SweepAll_List[i]:SetText("#G扫荡中")
		else
			g_SweepAll_List[i]:SetText("扫荡")
		end
	end
end



--点击扫荡按钮
function SweepAll_OnButtonClick(index)
	local nlszhi = tonumber(g_SweepAll_Page*8+index)
	if nlszhi < 1 or nlszhi > 12 then
		PushDebugMessage("请选择你要扫荡的副本。")
		return
	end
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OpenSecKillPage");
		Set_XSCRIPT_ScriptID(891062);
		Set_XSCRIPT_Parameter(0,nlszhi)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
end


function SweepAll_OnClosed()
    g_SweepAll_Page = 0
	this:Hide();
end

function SweepAll_turn_MoveUp()
    SweepAll_On_Open()
end

function SweepAll_turn_MoveDown()
    SweepAll_On_Open2()
end
