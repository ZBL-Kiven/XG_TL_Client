-- 界面的默认相对位置
local SweepPage_Frame_UnifiedXPosition;
local SweepPage_Frame_UnifiedYPosition;

local SweepPage_open_fubenId = -1
local SweepPage_curDay_Count = 0

local SweepPage_Drop = ""
local SweepPage_szSeparator = "," 
local HaveItems = 0
local CanDoubleExp = 0
local BossMaxNum = -1

local SweepPage_DiKeyNum = 0
local SweepPage_TianKeyNum = 0

--格子及其编号
local SweepPage_ITEM_NUM = 10;
local SweepPage_ITEMS = {};

local SweepPage_BossIcon = {}
local SweepPage_BossButton = {}
local SweepPage_BossingAnimate = {}
local SweepPage_BossDieIcon = {}
local SweepPage_BossName = {}
local SeeepPage_Timer = {}

local BossIndex = 0
local SweepPage_MaxBoss = 6
local SweepPage_CheckButton = {}
local SweepPage_GiveUpCheckButton = 1
local SweepPage_curPassIndex = 0
local SweepPage_ItemTable = {}
--对应的副本ID
local g_SweepPage_FubenId = {
[1]={"一个都不能跑",        5, 1,  {{"余毒","set:FightNPCHeader1 image:FightNPCHeader1_17"}}},
[2]={"除害",        5, 1,  {{"红熊王","set:FightNPCHeader7 image:FightNPCHeader7_8"}}},
[3]={"剿匪",              5,1,  {{"葛荣","set:FightNPCHeader7 image:FightNPCHeader7_13"}}},
[4]={"黄金之链",        5, 1,  {{"王阎","set:CommonNPCHeader2 image:CommonNPCHeader2_15"}}},
[5]={"玄佛珠",            5, 1,  {{"洪棘妖王","set:FightNPCHeader8 image:FightNPCHeader8_7"}}},
[6]={"熔岩之地",          5, 1,  {{"火焰妖魔","set:FightNPCHeader8 image:FightNPCHeader8_13"}}},
[7]={"讨伐燕子坞",  3, 3,  {{"段延庆","set:SweepBoss1 image:SweepBoss1_8"},{"鸠摩智","set:SweepBoss1 image:SweepBoss1_15"},{"慕容复","set:SweepBoss2 image:SweepBoss2_2"}}},
[8]={"杀星",        2, 4,  {{"1号BOSS","set:CommonNPCHeader15 image:CommonNPCHeader15_23"},{"2号BOSS","set:CommonNPCHeader16 image:CommonNPCHeader16_3"},{"3号BOSS","set:CommonNPCHeader15 image:CommonNPCHeader15_22"},{"4号BOSS","set:CommonNPCHeader16 image:CommonNPCHeader16_1"},{"5号BOSS","set:CommonNPCHeader16 image:CommonNPCHeader16_7"},{"6号BOSS","set:CommonNPCHeader16 image:CommonNPCHeader16_6"}}},
[9]={"初战缥缈峰",          2, 5,  {{"哈大霸","set:FightNPCHeader9 image:FightNPCHeader9_16"},{"桑土公","set:FightNPCHeader9 image:FightNPCHeader9_18"},{"乌老大","set:FightNPCHeader9 image:FightNPCHeader9_14"},{"任平生","set:CommonNPCHeader14 image:CommonNPCHeader14_17"},{"李秋水","set:FightNPCHeader9 image:FightNPCHeader9_17"}}},
[10]={"挑战缥缈峰", 3, 5,  {{"哈大霸","set:FightNPCHeader9 image:FightNPCHeader9_16"},{"桑土公","set:FightNPCHeader9 image:FightNPCHeader9_18"},{"乌老大","set:FightNPCHeader9 image:FightNPCHeader9_14"},{"任平生","set:CommonNPCHeader14 image:CommonNPCHeader14_17"},{"李秋水","set:FightNPCHeader9 image:FightNPCHeader9_17"}}},
[11]={"水月山庄",         2, 4,  {{"十三","set:FightNPCHeader12 image:FightNPCHeader12_5"},{"梵无救","set:FightNPCHeader12 image:FightNPCHeader12_4"},{"阿莺","set:FightNPCHeader12 image:FightNPCHeader12_6"},{"耶律泓佑","set:FightNPCHeader12 image:FightNPCHeader12_7"}}},
}

function SweepPage_PreLoad()
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS",false)

	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false);
	
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("REFRESH_SECKILL_PAGE")
	this:RegisterEvent("REFRESH_SECKILL_ITEM")
	this:RegisterEvent("SEND_SECKILL")
	this:RegisterEvent("UPDATE_SECKILL_FUBEN_SECKILLNUM")
end

function SweepPage_OnLoad()
	SweepPage_Frame_UnifiedXPosition	= SweepPage_Frame : GetProperty("UnifiedXPosition");
	SweepPage_Frame_UnifiedYPosition	= SweepPage_Frame : GetProperty("UnifiedYPosition");
	
	SweepPage_ITEMS[1] = SweepPage_Item1
	SweepPage_ITEMS[2] = SweepPage_Item2
	SweepPage_ITEMS[3] = SweepPage_Item3
	SweepPage_ITEMS[4] = SweepPage_Item4
	SweepPage_ITEMS[5] = SweepPage_Item5
	SweepPage_ITEMS[6] = SweepPage_Item6
	SweepPage_ITEMS[7] = SweepPage_Item7
	SweepPage_ITEMS[8] = SweepPage_Item8
	SweepPage_ITEMS[9] = SweepPage_Item9
	SweepPage_ITEMS[10] = SweepPage_Item10
	SweepPage_ITEMS[11] = SweepPage_Item11
	SweepPage_ITEMS[12] = SweepPage_Item12
	
	SweepPage_BossIcon[1] = SweepPage_Boss1
	SweepPage_BossIcon[2] = SweepPage_Boss2
	SweepPage_BossIcon[3] = SweepPage_Boss3
	SweepPage_BossIcon[4] = SweepPage_Boss4
	SweepPage_BossIcon[5] = SweepPage_Boss5
	SweepPage_BossIcon[6] = SweepPage_Boss6
	
	SweepPage_BossButton[1] = SweepPage_Boss1AnimateImage
	SweepPage_BossButton[2] = SweepPage_Boss2AnimateImage
	SweepPage_BossButton[3] = SweepPage_Boss3AnimateImage
	SweepPage_BossButton[4] = SweepPage_Boss4AnimateImage
	SweepPage_BossButton[5] = SweepPage_Boss5AnimateImage
	SweepPage_BossButton[6] = SweepPage_Boss6AnimateImage
	
	SweepPage_BossingAnimate[1] = SweepPage_Boss1doing
	SweepPage_BossingAnimate[2] = SweepPage_Boss2doing
	SweepPage_BossingAnimate[3] = SweepPage_Boss3doing
	SweepPage_BossingAnimate[4] = SweepPage_Boss4doing
	SweepPage_BossingAnimate[5] = SweepPage_Boss5doing
	SweepPage_BossingAnimate[6] = SweepPage_Boss6doing
	
	SweepPage_BossDieIcon[1] = SweepPage_Boss1finish
	SweepPage_BossDieIcon[2] = SweepPage_Boss2finish
	SweepPage_BossDieIcon[3] = SweepPage_Boss3finish
	SweepPage_BossDieIcon[4] = SweepPage_Boss4finish
	SweepPage_BossDieIcon[5] = SweepPage_Boss5finish
	SweepPage_BossDieIcon[6] = SweepPage_Boss6finish
	
	SweepPage_BossName[1] = SweepPage_Boss1Name
	SweepPage_BossName[2] = SweepPage_Boss2Name
	SweepPage_BossName[3] = SweepPage_Boss3Name
	SweepPage_BossName[4] = SweepPage_Boss4Name
	SweepPage_BossName[5] = SweepPage_Boss5Name
	SweepPage_BossName[6] = SweepPage_Boss6Name
	
	SeeepPage_Timer[1] = SweepPage_Boss1_StopWatch
	SeeepPage_Timer[2] = SweepPage_Boss2_StopWatch
	SeeepPage_Timer[3] = SweepPage_Boss3_StopWatch
	SeeepPage_Timer[4] = SweepPage_Boss4_StopWatch
	SeeepPage_Timer[5] = SweepPage_Boss5_StopWatch
	SeeepPage_Timer[6] = SweepPage_Boss6_StopWatch
	
	SweepPage_Double2:Hide()
	SweepPage_Explain4:Hide()
end

-- OnEvent
function SweepPage_OnEvent(event)
	if (event == "UI_COMMAND" ) then
		if tonumber(arg0) == 20150212 then
			if IsWindowShow("SweepAll") then
				CloseWindow( "SweepAll", true)
			end
			SweepPage_ItemTable = {-1,-1,-1,-1,-1,-1,-1,-1,-1,-1}
			SweepPage_open_fubenId = Get_XParam_INT(0)
			SweepPage_curDay_Count = Get_XParam_INT(1) --第几次扫荡
			BossIndex = Get_XParam_INT(2) ---扫荡完第几个boss了
			CanDoubleExp = 1
			SweepPage_Drop = Get_XParam_STR(0)
			SweepPage_Item_Update()
			OpenWindow("Packet")
			this:Show()
            BossMaxNum = g_SweepPage_FubenId[SweepPage_open_fubenId][3]
			SweepPage_Update(SweepPage_open_fubenId)
		end
		
	elseif (event == "REFRESH_SECKILL_PAGE") then
		if this:IsVisible() then
			SweepPage_Update(1)
		end
		
	elseif (event == "REFRESH_SECKILL_ITEM") then
		if this:IsVisible() then
			SweepPage_Item_Update()
		end
	
	-- 游戏窗口尺寸发生了变化
	elseif (event == "ADJEST_UI_POS" ) then
		-- 更新背包界面位置
		SweepPage_Frame_On_ResetPos()

	-- 游戏分辨率发生了变化
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		-- 更新背包界面位置
		SweepPage_Frame_On_ResetPos()
	elseif ( event == "HIDE_ON_SCENE_TRANSED" ) then
		SweepPage_OnClosed()
	end
end

function SweepPage_Frame_On_ResetPos()
	SweepPage_Frame : SetProperty("UnifiedXPosition", SweepPage_Frame_UnifiedXPosition);
	SweepPage_Frame : SetProperty("UnifiedYPosition", SweepPage_Frame_UnifiedYPosition);
end

function SweepPage_OnClosed()
	this:Hide();
	
	for i=1, SweepPage_MaxBoss do
		SeeepPage_Timer[i]:SetProperty("Timer", "-1");
	end
end

function SweepPage_Item_Update()
	--显示物品栏的物品
	for i=1, SweepPage_ITEM_NUM do
		SweepPage_ITEMS[i]:SetActionItem(-1);
		SweepPage_ITEMS[i]:Enable();
	end

	--包内物品数归零
        HaveItems = 0

	--从数据池中使用数据填入背包内的物品
	local SweepPage_MyItem = DailyburdenSP_Split(SweepPage_Drop,SweepPage_szSeparator)
	for i=1,SweepPage_ITEM_NUM  do
		local nActIndex = GemCarve:UpdateProductAction(tonumber(SweepPage_MyItem[i]))
		if nActIndex:GetID() ~= 0 then
			if tonumber(SweepPage_MyItem[i]) ~= -1 then
				SweepPage_ITEMS[i]:SetActionItem(nActIndex:GetID());
				SweepPage_ITEMS[i]:Enable();
				HaveItems = HaveItems + 1
				SweepPage_ItemTable[i] = tonumber(SweepPage_MyItem[i])
			end
		else
			SweepPage_ITEMS[i]:SetActionItem(-1);
		end
	end
end
function DailyburdenSP_Split(szFullString,szSeparator)
	local nFindStartIndex = 1
	local nSplitIndex = 1 
	local nSplitArray = {} 
	while true do
		local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex) 
		if not nFindLastIndex then
			nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString)) 
			break 
		end 
		nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)
		nFindStartIndex = nFindLastIndex + string.len(szSeparator)
		nSplitIndex = nSplitIndex + 1
	end
	return nSplitArray
end

function SweepPage_UpdateControl(isSanShen)
	if isSanShen == 1 then
		SweepPage_Explain:Hide()
		--SweepPage_ExplainBK:Hide()
		SweepPage_Explain3:Show()
	
		SweepPage_Boss4:Hide()
		SweepPage_BossIcon[4] = SweepPage_Boss4_SanShen
		SweepPage_BossButton[4] = SweepPage_Boss4AnimateImage_SanShen
		SweepPage_BossingAnimate[4] = SweepPage_Boss4doing_SanShen
		SweepPage_BossDieIcon[4] = SweepPage_Boss4finish_SanShen
	
		SweepPage_Boss5:Hide()
		SweepPage_BossIcon[5] = SweepPage_Boss5_SanShen
		SweepPage_BossButton[5] = SweepPage_Boss5AnimateImage_SanShen
		SweepPage_BossingAnimate[5] = SweepPage_Boss5doing_SanShen
		SweepPage_BossDieIcon[5] = SweepPage_Boss5finish_SanShen
	
		SweepPage_Boss6:Hide()
		SweepPage_BossIcon[6] = SweepPage_Boss6_SanShen
		SweepPage_BossButton[6] = SweepPage_Boss6AnimateImage_SanShen
		SweepPage_BossingAnimate[6] = SweepPage_Boss6doing_SanShen
		SweepPage_BossDieIcon[6] = SweepPage_Boss6finish_SanShen
		
	else
		SweepPage_Explain:Show()
		SweepPage_Explain:SetText("#{FBSD_150126_27}")
		SweepPage_DoubleCheck:SetToolTip("#{FBSD_150126_25}")
		-- if SweepPage_open_fubenId == 7 then
			-- SweepPage_Explain:SetText("#{FMCS_180705_18}")
			-- SweepPage_DoubleCheck:SetToolTip("#{FMCS_180705_20}")
		-- elseif SweepPage_open_fubenId == 3 then
			-- SweepPage_Explain:SetText("#{XPMCS_180827_1}")
			-- SweepPage_DoubleCheck:SetToolTip("#{DPMCS_180827_15}")
		-- elseif SweepPage_open_fubenId == 8 then
			-- SweepPage_Explain:SetText("#{DPMCS_180827_1}")
			-- SweepPage_DoubleCheck:SetToolTip("#{YZCS_180827_8}")
		-- elseif SweepPage_open_fubenId == 0 then
			-- SweepPage_Explain:SetText("#{YZCS_180827_2}")
			-- SweepPage_DoubleCheck:SetToolTip("#{YZCS_180827_8}")
		-- end		
		--SweepPage_ExplainBK:Show()
		SweepPage_Explain3:Hide()
	
		SweepPage_Boss4_SanShen:Hide()
		SweepPage_BossIcon[4] = SweepPage_Boss4
		SweepPage_BossButton[4] = SweepPage_Boss4AnimateImage
		SweepPage_BossingAnimate[4] = SweepPage_Boss4doing
		SweepPage_BossDieIcon[4] = SweepPage_Boss4finish
	
		SweepPage_Boss5_SanShen:Hide()
		SweepPage_BossIcon[5] = SweepPage_Boss5
		SweepPage_BossButton[5] = SweepPage_Boss5AnimateImage
		SweepPage_BossingAnimate[5] = SweepPage_Boss5doing
		SweepPage_BossDieIcon[5] = SweepPage_Boss5finish
	
		SweepPage_Boss6_SanShen:Hide()
		SweepPage_BossIcon[6] = SweepPage_Boss6
		SweepPage_BossButton[6] = SweepPage_Boss6AnimateImage
		SweepPage_BossingAnimate[6] = SweepPage_Boss6doing
		SweepPage_BossDieIcon[6] = SweepPage_Boss6finish
	end
end

function SweepPage_state()
	if BossIndex < BossMaxNum and BossIndex >0 then
		return 1     --处于扫荡中
	elseif 	SweepPage_curDay_Count >= g_SweepPage_FubenId[SweepPage_open_fubenId][2]  then
		return 2     --今天已经扫荡过了
	else
		return 3     --当天还未扫荡
	end
end


function SweepPage_Update(FubenID)
	
	if SweepPage_open_fubenId == 9 then
		SweepPage_UpdateControl(1)
		return
	end
	SweepPage_UpdateControl(0)
	
	SweepPage_Boss4_SanShen:Hide()
	SweepPage_Boss5_SanShen:Hide()
	SweepPage_Boss6_SanShen:Hide()

	SweepPage_GoOn:Disable()
	SweepPage_GoOn_tips:Show()

	if DoubleExp == 1 then
		SweepPage_DoubleText2:SetText("#{FBSD_150126_74}")
	else
		SweepPage_DoubleText2:SetText("#{FBSD_150126_83}")
	end

	local strTemp = "#gFF0FA0扫荡"..g_SweepPage_FubenId[FubenID][1]
	SweepPage_DragTitle:SetText(strTemp)

	local state = SweepPage_state()
	local KillBossIndex = 1
	if state == 1 then
		KillBossIndex = BossIndex + 1
	elseif BossIndex >= BossMaxNum or state == 2 then --表示最后一个boss也扫荡完成
		KillBossIndex = BossMaxNum + 1
		SweepPage_GoOn:Enable()
		SweepPage_GoOn_tips:Hide()
	end
	
	local Msg = ""
        local shengy = g_SweepPage_FubenId[FubenID][2] - SweepPage_curDay_Count

	if shengy ~= 0 then
	 Msg = "#cfff263副本剩余扫荡次数：#G"..shengy.."/"..g_SweepPage_FubenId[FubenID][2]
	else
	 Msg = "#cfff263副本剩余扫荡次数：#cff00000/"..g_SweepPage_FubenId[FubenID][2]
	end
	SweepPage_Explain_times:SetText(Msg)
		
	for i=1, BossMaxNum do
		SweepPage_BossIcon[i]:Show()
		SweepPage_BossName[i]:Show()
		SweepPage_BossName[i]:SetText("#cfff263"..g_SweepPage_FubenId[FubenID][4][i][1])
		SweepPage_BossIcon[i]:SetProperty("Image", g_SweepPage_FubenId[FubenID][4][i][2])


		if i < KillBossIndex then
			if KillBossIndex == i + 1 and SweepPage_curPassIndex ~= KillBossIndex then
				SweepPage_BossingAnimate[i]:Show()
				SweepPage_BossingAnimate[i]:SetToolTip("#{FBSD_150126_30}")
				SweepPage_BossDieIcon[i]:Hide()
				SeeepPage_Timer[i]:SetProperty("Timer", "1.8");
			else
				SweepPage_BossingAnimate[i]:Hide()
				SweepPage_BossDieIcon[i]:Show()
				SweepPage_BossDieIcon[i]:SetToolTip("#{FBSD_150126_30}")
			end
			
			SweepPage_BossButton[i]:Hide()
		elseif i == KillBossIndex then
			SweepPage_BossDieIcon[i]:Hide()
			SweepPage_BossButton[i]:Show()
			SweepPage_BossButton[i]:Enable()
			SweepPage_BossButton[i]:SetToolTip("#{FBSD_150126_29}")
			--SweepPage_BossButton[i]:PlayWarning(1)
			SweepPage_BossingAnimate[i]:Hide()
			local strTemp = "#cfff263你当前可扫荡BOSS：#G"..g_SweepPage_FubenId[FubenID][4][i][1]
			SweepPage_Explain1:SetText(strTemp)
		else
			SweepPage_BossDieIcon[i]:Hide()
			SweepPage_BossButton[i]:Hide()
			SweepPage_BossIcon[i]:SetToolTip("#{FBSD_150126_28}")
			SweepPage_BossingAnimate[i]:Hide()
		end
	end
    if BossMaxNum < SweepPage_MaxBoss then
	    for i = BossMaxNum + 1, SweepPage_MaxBoss do
		    SweepPage_BossIcon[i]:Hide()
		    SweepPage_BossName[i]:Hide()
	    end
	end

	if SweepPage_CheckButton[SweepPage_open_fubenId] == 1 then
		SweepPage_DoubleCheck:SetCheck(1)
	else
		SweepPage_DoubleCheck:SetCheck(0)
	end
	
	-- if SweepPage_GiveUpCheckButton == 1 then
		-- SweepPage_AbandonCheckButton:SetCheck(1)
	-- else
		-- SweepPage_AbandonCheckButton:SetCheck(0)
	-- end
	
	if CanDoubleExp == 1 then
		SweepPage_DoubleCheck:Show()
		SweepPage_DoubleText1:Show()
		SweepPage_DoubleText2:Show()
		SweepPage_DoubleCheck:Enable()
	else
		SweepPage_DoubleCheck:Hide()
		SweepPage_DoubleText1:Hide()
		SweepPage_DoubleText2:Hide()
		SweepPage_DoubleCheck:Disable()
	end
end


function SweepPage_SendSecKill(index)
	if HaveItems ~= 0 then
		PushDebugMessage("#H请把扫荡背包内的物品全部放入背包内，再开启扫荡")
		return
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("OnFuBenSecKill");
		Set_XSCRIPT_ScriptID(891062);
		Set_XSCRIPT_Parameter(0,SweepPage_open_fubenId);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,SweepPage_DoubleCheck:GetCheck());
		Set_XSCRIPT_ParamCount(3);
	Send_XSCRIPT();
end


function SweepPage_OnOkClicked() ---全部拾取
	if HaveItems == 0 then
		PushDebugMessage("你的扫荡背包内没有任何物品。")
		return
	end
	HaveItems = 0
	SweepPage_ItemTable = {-1,-1,-1,-1,-1,-1,-1,-1,-1,-1}
	for i=1,SweepPage_ITEM_NUM  do
		SweepPage_ITEMS[i]:SetActionItem(-1);
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("OnOkClicked");
		Set_XSCRIPT_ScriptID(891062);
		Set_XSCRIPT_Parameter(0,SweepPage_open_fubenId);
		Set_XSCRIPT_ParamCount(1);
	Send_XSCRIPT();
end


function SweepPage_OnCheckClick()	
	if SweepPage_open_fubenId >= 0  and SweepPage_open_fubenId < table.getn(SweepPage_CheckButton) then
		if SweepPage_CheckButton[SweepPage_open_fubenId] == 1 then
			SweepPage_CheckButton[SweepPage_open_fubenId] = 0
		else
			SweepPage_CheckButton[SweepPage_open_fubenId] = 1
		end
	end
end

function SweepPage_GetItemLeftClick()
	PushDebugMessage("请使用右键点击扫荡物品放入背包内。")
end

function SweepPage_GetItemRightClick(arg)
	if HaveItems == 0 then
		PushDebugMessage("你的扫荡背包内没有任何物品。")
		return
	end
	if arg < 1 or arg > 12 then
		PushDebugMessage("请正确选择扫荡栏里面的物品。")
		return
	end
	if SweepPage_ItemTable[arg] > 10000000 then
		SweepPage_ITEMS[arg]:SetActionItem(-1);		
		HaveItems = HaveItems - 1
		SweepPage_ItemTable[arg] = -1
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("OnPutInPacketByPos");
		Set_XSCRIPT_ScriptID(891062);
		Set_XSCRIPT_Parameter(0,SweepPage_open_fubenId);
		Set_XSCRIPT_Parameter(1,arg);
		Set_XSCRIPT_ParamCount(2);
	Send_XSCRIPT();
end

function SweepPage_OnGiveUpCheckClick()---丢弃确认
	-- if SweepPage_GiveUpCheckButton == 1 then
		-- SweepPage_GiveUpCheckButton = 0
	-- else
		-- SweepPage_GiveUpCheckButton = 1
	-- end
end


function SweepPage_OnTimer(index)
	 SweepPage_BossingAnimate[index]:Hide()
	 SweepPage_BossDieIcon[index]:Show()

	 SweepPage_BossDieIcon[index]:SetToolTip("#{FBSD_150126_30}")
	 SeeepPage_Timer[index]:SetProperty("Timer", "-1")
end	


function SweepPage_OnBossButton(index)
	if HaveItems ~= 0 then
		PushDebugMessage("#H请把福利扫荡背包内的物品全部放入背包内，再开启福利扫荡")
		return
	end
	SweepPage_SendSecKill(index)
	SweepPage_curPassIndex = index
end

function SweepPage_OnGotoSweepAll()---扫荡其他副本
	if HaveItems ~= 0 then
		PushDebugMessage("#H请把福利扫荡背包内的物品全部放入背包内，再开启福利扫荡")
		return
	end
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "OpenSecKillList" ); 
		Set_XSCRIPT_ScriptID( 891062 );
		Set_XSCRIPT_ParamCount( 0 );
	Send_XSCRIPT()	
end

function SweepPage_OnGiveUp()---全部丢弃
	if HaveItems == 0 then
		PushDebugMessage("你的扫荡背包内没有任何物品。")
		return
	end
	-- if SweepPage_GiveUpCheckButton == 1  then
		-- PushEvent( "UI_COMMAND",1000000094,SweepPage_open_fubenId)
	-- else
		HaveItems = 0
		SweepPage_ItemTable = {-1,-1,-1,-1,-1,-1,-1,-1,-1,-1}
		for i=1,SweepPage_ITEM_NUM  do
			SweepPage_ITEMS[i]:SetActionItem(-1);
		end
		Clear_XSCRIPT()
			Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("SecKillGiveUpItem");
			Set_XSCRIPT_ScriptID(891062);
			Set_XSCRIPT_Parameter(0,SweepPage_open_fubenId)
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
	-- end
end

function SweepPage_OnContinue()---再次扫荡
	if HaveItems ~= 0 then
		PushDebugMessage("#H请把福利扫荡背包内的物品全部放入背包内，再开启福利扫荡")
		return
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("OnContinueFuBenSecKill");
		Set_XSCRIPT_ScriptID(891062);
		Set_XSCRIPT_Parameter(0,SweepPage_open_fubenId);
		Set_XSCRIPT_ParamCount(1);
	Send_XSCRIPT();
end

function SweepPage_Button_Clicked()--查看VIP扫荡特权
	OpenYBShopReference("#{FBSD_170509_03}")
end
