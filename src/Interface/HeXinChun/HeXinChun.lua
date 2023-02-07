-- 移植-新春签到活动-天禧春华战江湖
--贺新春
-- !!!reloadscript =HeXinChun
local g_HeXinChun_Frame_UnifiedXPosition
local g_HeXinChun_Frame_UnifiedYPosition

--小红点
local g_HeXinChun_FlexTips = {}
local g_HeXinChun_FlexState = 
{
	[1] = 0,
	[2] = 0,
}

--刷数据时间
local g_HeXinChun_DataRefreshTime = 0

--贺新春时间
local g_HeXinChun_BeginTime = 20210211
local g_HeXinChun_EndTime = 20210218

--战江湖时间
local g_HeXinChun_ZhanJiangHuBegin = 20210219
local g_HeXinChun_ZhanJiangHuEnd = 20210226

--领奖按钮
local g_HeXinChun_RewardDayCount = 8
local g_HeXinChun_DayRewardButtons = {}

--除夕到初七领奖状态
local g_HeXinChun_DayRewardState = 
{
	[1] = 0,
	[2] = 0,
	[3] = 0,
	[4] = 0,
	[5] = 0,
	[6] = 0,
	[7] = 0,
	[8] = 0,
}

--除夕到初七日期
local g_HeXinChun_Day = 
{
	[1] = "11",
	[2] = "12",
	[3] = "13",
	[4] = "14",
	[5] = "15",
	[6] = "16",
	[7] = "17",
	[8] = "18",
}
--除夕到初七名称-绿色
local g_HeXinChun_Day2Name = 
{
	[1] = "set:HeXinChun4 image:gchuxi",
	[2] = "set:HeXinChun4 image:g1",
	[3] = "set:HeXinChun4 image:g2",
	[4] = "set:HeXinChun4 image:g3",
	[5] = "set:HeXinChun4 image:g4",
	[6] = "set:HeXinChun4 image:g5",
	[7] = "set:HeXinChun4 image:g6",
	[8] = "set:HeXinChun4 image:g7",
}
--除夕到初七名称-黄色
local g_HeXinChun_Day2NameNor = 
{
	[1] = "set:HeXinChun3 image:chuxi",
	[2] = "set:HeXinChun3 image:chunjie",
	[3] = "set:HeXinChun3 image:2",
	[4] = "set:HeXinChun3 image:3",
	[5] = "set:HeXinChun3 image:4",
	[6] = "set:HeXinChun3 image:5",
	[7] = "set:HeXinChun3 image:6",
	[8] = "set:HeXinChun3 image:7",
}

--除夕到初七奖励
local g_HeXinChun_CampainId = 
{
	[1] = {id=20310168,count=10},
	[2] = {id=50313004,count=1},
	[3] = {id=38002168,count=1},
	[4] = {id=30900045,count=1},
	[5] = {id=20502003,count=1},
	[6] = {id=30008048,count=1},
	[7] = {id=20501003,count=1},
	[8] = {id=38002169,count=1},
}

--===============================================
-- PreLoad()
--===============================================
function HeXinChun_PreLoad()

	this:RegisterEvent("UI_COMMAND")	
	this:RegisterEvent("OPEN_HEXINCHUN")
		
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	
	this:RegisterEvent("XINCHUNYINGJING_FLEX_UPDATE")	
	this:RegisterEvent("PLAYER_ENTERING_WORLD")
		
	this:RegisterEvent("RESET_ALLUI");
		
end

--===============================================
-- OnLoad()
--===============================================
function HeXinChun_OnLoad()

	g_HeXinChun_DayRewardButtons = 
	{
		[1] = {
			Btn=HeXinChun_Page1_one_Button,text=HeXinChun_Page1_one_LotteryButtonText,resign=HeXinChun_Page1_oneResign,
			Icon=HeXinChun_Page1_one,FinshFlag=HeXinChun_Page1_oneMark,FlexTip=HeXinChun_one_ButtonTip,date=HeXinChun_Page1_one_Date,
			},
		[2] = {
			Btn=HeXinChun_Page1_two_Button,text=HeXinChun_Page1_two_LotteryButtonText,resign=HeXinChun_Page1_twoResign,
			Icon=HeXinChun_Page1_two,FinshFlag=HeXinChun_Page1_twoMark,FlexTip=HeXinChun_two_ButtonTip,date=HeXinChun_Page1_two_Date,
			},
		[3] = {
			Btn=HeXinChun_Page1_three_Button,text=HeXinChun_Page1_three_LotteryButtonText,resign=HeXinChun_Page1_threeResign,
			Icon=HeXinChun_Page1_three,FinshFlag=HeXinChun_Page1_threeMark,FlexTip=HeXinChun_three_ButtonTip,date=HeXinChun_Page1_three_Date,
			},
		[4] = {
			Btn=HeXinChun_Page1_four_Button,text=HeXinChun_Page1_four_LotteryButtonText,resign=HeXinChun_Page1_fourResign,
			Icon=HeXinChun_Page1_four,FinshFlag=HeXinChun_Page1_fourMark,FlexTip=HeXinChun_four_ButtonTip,date=HeXinChun_Page1_four_Date,
			},
		[5] = {
			Btn=HeXinChun_Page1_five_Button,text=HeXinChun_Page1_five_LotteryButtonText,resign=HeXinChun_Page1_fiveResign,
			Icon=HeXinChun_Page1_five,FinshFlag=HeXinChun_Page1_fiveMark,FlexTip=HeXinChun_five_ButtonTip,date=HeXinChun_Page1_five_Date,
			},
		[6] = {
			Btn=HeXinChun_Page1_six_Button,text=HeXinChun_sixText,resign=HeXinChun_Page1_sixResign,
			Icon=HeXinChun_Page1_six,FinshFlag=HeXinChun_Page1_sixMark,FlexTip=HeXinChun_six_ButtonTip,date=HeXinChun_Page1_six_Date,
			},
		[7] = {
			Btn=HeXinChun_Page1_seven_Button,text=HeXinChun_sevenText,resign=HeXinChun_Page1_sevevResign,
			Icon=HeXinChun_Page1_seven,FinshFlag=HeXinChun_Page1_sevenMark,FlexTip=HeXinChun_seven_ButtonTip,date=HeXinChun_Page1_seven_Date,
			},
		[8] = {
			Btn=HeXinChun_Page1_eight_Button,text=HeXinChun_eightText,resign=HeXinChun_Page1_eightResign,
			Icon=HeXinChun_Page1_eight,FinshFlag=HeXinChun_Page1_eightMark,FlexTip=HeXinChun_eight_ButtonTip,date=HeXinChun_Page1_eight_Date,
			},
	}
	g_HeXinChun_FlexTips = 
	{
		[1] = HeXinChun_FenYe1_Tips,
		[2] = HeXinChun_FenYe2_Tips,
	}
	-- 保存界面的默认相对位置
	g_HeXinChun_Frame_UnifiedXPosition	= HeXinChun_Frame : GetProperty("UnifiedXPosition");
	g_HeXinChun_Frame_UnifiedYPosition	= HeXinChun_Frame : GetProperty("UnifiedYPosition");
	-- 小红点状态
	g_HeXinChun_FlexState[1] = 0
	g_HeXinChun_FlexState[2] = 0
	
end

--===============================================
-- OnEvent()
--===============================================
function HeXinChun_OnEvent(event)

	if(event == "UI_COMMAND" and tonumber(arg0) == 2018010601) then	
		local bOpen = Get_XParam_INT(0)
		local nIndex = 1
		local nFlexFlag = 0
		--g_HeXinChun_FlexState[1] = 0
		for i=1,g_HeXinChun_RewardDayCount do
			g_HeXinChun_DayRewardState[i] = Get_XParam_INT(nIndex)
			if(g_HeXinChun_DayRewardState[i] == 1) then
				nFlexFlag = 1
			end
			nIndex = nIndex + 1
		end
		if(bOpen == 1) then
			HeXinChun_FenYe1:SetCheck(1)
			HeXinChun_FenYe2:SetCheck(0)
			if(IsWindowShow("ZhanJiangHu") == true) then
				CloseWindow("ZhanJiangHu",true)
			end
			this:Show()
		end
		local bRrefrshTip = 0
		if(nFlexFlag ~= g_HeXinChun_FlexState[1]) then
			bRrefrshTip = 1
			g_HeXinChun_FlexState[1] = nFlexFlag
		end
		g_HeXinChun_DataRefreshTime = OSAPI:GetTickCount()
		if(this:IsVisible()) then
			HeXinChun_RefreshAll()
		end
		if(bRrefrshTip == 1) then
			PushEvent("XINCHUNYINGJING_FLEX_UPDATE",1,g_HeXinChun_FlexState[1])
		end

	elseif(event == "OPEN_HEXINCHUN") then
		local bOpen = tonumber(arg0)
		if(bOpen == 0) then
			HeXinChun_OnHiden()
			return
		end
		if(tonumber(arg1) ~= -1 and tonumber(arg2) ~= -1) then
			g_HeXinChun_Frame_UnifiedXPosition = arg1
			g_HeXinChun_Frame_UnifiedYPosition = arg2
			HeXinChun_Frame_On_ResetPos()
		end
		local nCur = OSAPI:GetTickCount()
		if((g_HeXinChun_DataRefreshTime <= 0) or (nCur - g_HeXinChun_DataRefreshTime >= 300000)) then
			HeXinChun_AskData(1)
			return
		end
		if(IsWindowShow("ZhanJiangHu") == true) then
			CloseWindow("ZhanJiangHu",true)
		end
		HeXinChun_FenYe1:SetCheck(1)
		HeXinChun_FenYe2:SetCheck(0)
		this:Show()
		HeXinChun_RefreshAll()
		
	elseif (event == "XINCHUNYINGJING_FLEX_UPDATE") then
		if(tonumber(arg0) ~= 2 )then
			return
		end
		g_HeXinChun_FlexState[2] = tonumber(arg1)
		if(this:IsVisible()) then
			HeXinChun_RefreshAll()
		end
	-- 游戏窗口尺寸发生了变化
	elseif (event == "ADJEST_UI_POS" ) then
		-- 更新背包界面位置
		HeXinChun_Frame_On_ResetPos()

	-- 游戏分辨率发生了变化
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		-- 更新背包界面位置
		HeXinChun_Frame_On_ResetPos()
	elseif (event == "PLAYER_ENTERING_WORLD") then
		HeXinChun_AskData(0)
		HeXinChun_OnHiden()
	elseif(event == "RESET_ALLUI") then
		g_HeXinChun_DataRefreshTime = 0
		g_HeXinChun_FlexState[1] = 0
		g_HeXinChun_FlexState[2] = 0
	end
	
end

--===============================================
-- OnHiden()
--===============================================
function HeXinChun_OnHiden()
	this:Hide()
end

--===============================================
-- OnClose
--===============================================
function HeXinChun_Close()
	HeXinChun_OnHiden()
end

--================================================
-- 恢复界面的默认相对位置
--================================================
function HeXinChun_Frame_On_ResetPos()
	HeXinChun_Frame : SetProperty("UnifiedXPosition", g_HeXinChun_Frame_UnifiedXPosition);
	HeXinChun_Frame : SetProperty("UnifiedYPosition", g_HeXinChun_Frame_UnifiedYPosition);
end

--===============================================
-- 刷新界面领奖状态
--===============================================
function HeXinChun_RefreshAll()
	local nCurDay = tonumber(DataPool:GetServerDayTime());
	for i=1,g_HeXinChun_RewardDayCount do
		local nState = g_HeXinChun_DayRewardState[i]
		g_HeXinChun_DayRewardButtons[i].Btn:SetToolTip("")
		g_HeXinChun_DayRewardButtons[i].Btn:SetProperty("NormalImage", "set:HeXinChun2 image:DenglongDark")
		g_HeXinChun_DayRewardButtons[i].text:SetText("")
		g_HeXinChun_DayRewardButtons[i].resign:Hide()
		g_HeXinChun_DayRewardButtons[i].FinshFlag:Hide()
		g_HeXinChun_DayRewardButtons[i].FlexTip:Hide()
		--已领取
		if(nState == 2) then
			g_HeXinChun_DayRewardButtons[i].FinshFlag:Show()
			g_HeXinChun_DayRewardButtons[i].text:SetText("#{CJYJ_201222_10}")
			g_HeXinChun_DayRewardButtons[i].Btn:SetToolTip("#{CJYJ_180129_168}")
		end
		--可领取且未领取
		if(nState == 1) then
			g_HeXinChun_DayRewardButtons[i].FlexTip:Show()
			g_HeXinChun_DayRewardButtons[i].text:SetText("#{CJYJ_201222_09}")
			g_HeXinChun_DayRewardButtons[i].Btn:SetToolTip("#{CJYJ_180104_31}")
			g_HeXinChun_DayRewardButtons[i].Btn:SetProperty("NormalImage", "set:HeXinChun2 image:DenglongHover")
		else
			--不可领取
			if(nState == 0) then
				local nCurDay = tonumber(DataPool:GetServerDayTime());
				local nIndexDay = DataPool:DiffDayCount(g_HeXinChun_BeginTime,nCurDay) + 1
				if(i < nIndexDay) then
					g_HeXinChun_DayRewardButtons[i].resign:Show()
					g_HeXinChun_DayRewardButtons[i].text:SetText("#{CJYJ_201222_11}")
					g_HeXinChun_DayRewardButtons[i].Btn:SetToolTip("#{CJYJ_180129_169}")
				else
					g_HeXinChun_DayRewardButtons[i].Btn:SetToolTip(ScriptGlobal_Format("#{CJYJ_201222_01}","2",g_HeXinChun_Day[i]))
				end
			end
		end
		--显示奖励
		local theAction = DataPool:CreateBindActionItemForShow(g_HeXinChun_CampainId[i].id, g_HeXinChun_CampainId[i].count)
		if theAction:GetID() ~= 0 then
			g_HeXinChun_DayRewardButtons[i].Icon:SetActionItem(theAction:GetID())
		end
		--显示日期
		if(DataPool:DiffDayCount(g_HeXinChun_BeginTime,nCurDay) + 1 == i) then
			g_HeXinChun_DayRewardButtons[i].date:SetProperty("Image",g_HeXinChun_Day2Name[i])
		else
			g_HeXinChun_DayRewardButtons[i].date:SetProperty("Image",g_HeXinChun_Day2NameNor[i])
		end
	end
	
	--页签小红点
	for i=1,table.getn(g_HeXinChun_FlexTips) do
		if(g_HeXinChun_FlexState[i] == 1) then
			g_HeXinChun_FlexTips[i]:Show()
		else
			g_HeXinChun_FlexTips[i]:Hide()
		end
	end
	
end

--================================================
-- 点击领奖
--================================================
function HeXinChun_OnClick(nIndex)
	if(nIndex == nil or nIndex <= 0 or nIndex > g_HeXinChun_RewardDayCount) then
		return
	end

	--可领奖
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("GetReward")
		Set_XSCRIPT_ScriptID(892663)
		Set_XSCRIPT_Parameter(0,nIndex)
		Set_XSCRIPT_Parameter(1,0)
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()
end

--================================================
-- 切换页签
--================================================
function HeXinChun_ChangeTabIndex()
	if(HeXinChun_ZhanJiangHuIsOpen() ~= 1) then
		PushDebugMessage("#{CJYJ_180119_133}")
		HeXinChun_FenYe1:SetCheck(1)
		HeXinChun_FenYe2:SetCheck(0)
		return
	end
	local X = HeXinChun_Frame : GetProperty("UnifiedXPosition");
	local Y = HeXinChun_Frame : GetProperty("UnifiedYPosition");	
	PushEvent("OPEN_ZHANJIANGHU",1,X,Y)
	--HeXinChun_OnHiden()
end

--================================================
-- 请求刷新界面
--================================================
function HeXinChun_AskData(bOpen)
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnOpenUI")
		Set_XSCRIPT_ScriptID(892663)
		Set_XSCRIPT_Parameter(0,bOpen)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
end

--================================================
-- 是否战江湖活动时间
--================================================
function HeXinChun_ZhanJiangHuIsOpen()
	local curDay = tonumber(DataPool:GetServerDayTime());
	if(curDay < g_HeXinChun_ZhanJiangHuBegin or curDay > g_HeXinChun_ZhanJiangHuEnd) then
		return 0
	end
	return 1
end

--================================================
-- 小问号
--================================================
function HeXinChun_HelpClicked()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("NpcText")
		Set_XSCRIPT_ScriptID(892663)
		Set_XSCRIPT_ParamCount(0)
	Send_XSCRIPT()
end
