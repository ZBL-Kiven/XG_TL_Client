--Q546528533 仅供娱乐交流，切勿它用，请浏览后24小时内删除
local g_Frame_UnifiedPosition
local g_NowSelect = 0;

local g_StartTime = 20210930
local g_EndTime = 20211007

local g_ZhouHuoYueItem = {

}
local nItemNewTable = {}
local g_ZhouHuoYueItemGrey = {

}

local g_ZhouHuoYuePageTips = {

}
local g_ZhouHuoYueData_1 = {}

local g_ZhouHuoYue_Item = {}
-- local g_ZhouHuoYue_ScrollBar = {
-- }

local g_ZhouHuoYue_LevelLimit = {
	[1] = 40,
	[2] = 60,
	[3] = 70,
	[4] = 75,
}

local g_ZhouHuoYue_Lock = {
	
}

local g_ZhouHuoYue_Stage = {
	
}

local g_isShowTips = {}
local g_GutLine = {}
local g_AwardTips = 0
local g_ZhouHuoYuePage = 0
local g_ZhouHuoYueItemId = {
	[1] = { item = 30900045, num = 2 },
	[2] = { item = 39901003, num = 1 },
	[3] = { item = 30503133, num = 5 },
	[4] = { item = 39901003, num = 1 },
	[5] = { item = 20310168, num = 20 },
	[6] = { item = 39901003, num = 1 },
	[7] = { item = 30502002, num = 10 },
	[8] = { item = 39901003, num = 1 },
	[9] = { item = 20502008, num = 10 },
	[10] = { item = 39901004, num = 1 },
	[11] = { item = 20501008, num = 10 },
	[12] = { item = 39901004, num = 1 },
	[13] = { item = 50613004, num = 1 },
	[14] = { item = 39901004, num = 1 },
	[15] = { item = 20310168, num = 40 },
	[16] = { item = 39901005, num = 1 },
	[17] = { item = 20800013, num = 50 },
	[18] = { item = 39901006, num = 1 },
	[19] = { item = 38002396, num = 50 },
	[20] = { item = 39901008, num = 1 },
}

local g_ProcessLimit = {
	[1] = { neednum = 200, itemspace = 2, materialspace = 0 },
	[2] = { neednum = 400, itemspace = 2, materialspace = 0 },
	[3] = { neednum = 600, itemspace = 1, materialspace = 1 },
	[4] = { neednum = 800, itemspace = 2, materialspace = 0 },
	[5] = { neednum = 1000, itemspace = 1, materialspace = 1 },
	[6] = { neednum = 1200, itemspace = 1, materialspace = 1 },
	[7] = { neednum = 1400, itemspace = 1, materialspace = 1 },
	[8] = { neednum = 1600, itemspace = 1, materialspace = 1 },
	[9] = { neednum = 1800, itemspace = 1, materialspace = 1 },
	[10] = { neednum = 2000, itemspace = 2, materialspace = 0 },
}

local g_ZhouHuoYueMax = 2200
--=========
-- PreLoad()
--=========
function ZhouHuoYue_PreLoad()
	
	this:RegisterEvent("ZHOUHUOYUE_UPDATE")--打开or刷新界面
	this:RegisterEvent("UI_COMMAND")--打开or刷新界面
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")    --进场景关闭界面
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("ADJEST_UI_POS")

end

--=========
-- OnLoad()
--=========
function ZhouHuoYue_OnLoad()
	
	g_Frame_UnifiedPosition = ZhouHuoYue_FrameFull:GetProperty("UnifiedPosition")
	
	g_ZhouHuoYueItem[1] = ZhouHuoYue_ItemA_1
	g_ZhouHuoYueItem[2] = ZhouHuoYue_ItemA_2
	g_ZhouHuoYueItem[3] = ZhouHuoYue_ItemB_1
	g_ZhouHuoYueItem[4] = ZhouHuoYue_ItemB_2
	g_ZhouHuoYueItem[5] = ZhouHuoYue_ItemC_1
	g_ZhouHuoYueItem[6] = ZhouHuoYue_ItemC_2
	g_ZhouHuoYueItem[7] = ZhouHuoYue_ItemD_1
	g_ZhouHuoYueItem[8] = ZhouHuoYue_ItemD_2
	g_ZhouHuoYueItem[9] = ZhouHuoYue_ItemE_1
	g_ZhouHuoYueItem[10] = ZhouHuoYue_ItemE_2
	g_ZhouHuoYueItem[11] = ZhouHuoYue_ItemF_1
	g_ZhouHuoYueItem[12] = ZhouHuoYue_ItemF_2
	g_ZhouHuoYueItem[13] = ZhouHuoYue_ItemG_1
	g_ZhouHuoYueItem[14] = ZhouHuoYue_ItemG_2
	g_ZhouHuoYueItem[15] = ZhouHuoYue_ItemH_1
	g_ZhouHuoYueItem[16] = ZhouHuoYue_ItemH_2
	g_ZhouHuoYueItem[17] = ZhouHuoYue_ItemI_1
	g_ZhouHuoYueItem[18] = ZhouHuoYue_ItemI_2
	g_ZhouHuoYueItem[19] = ZhouHuoYue_ItemJ_1
	g_ZhouHuoYueItem[20] = ZhouHuoYue_ItemJ_2
	
	g_ZhouHuoYueItemGrey[1] = ZhouHuoYue_ItemA1_Grey
	g_ZhouHuoYueItemGrey[2] = ZhouHuoYue_ItemA2_Grey
	g_ZhouHuoYueItemGrey[3] = ZhouHuoYue_ItemB1_Grey
	g_ZhouHuoYueItemGrey[4] = ZhouHuoYue_ItemB2_Grey
	g_ZhouHuoYueItemGrey[5] = ZhouHuoYue_ItemC1_Grey
	g_ZhouHuoYueItemGrey[6] = ZhouHuoYue_ItemC2_Grey
	g_ZhouHuoYueItemGrey[7] = ZhouHuoYue_ItemD1_Grey
	g_ZhouHuoYueItemGrey[8] = ZhouHuoYue_ItemD2_Grey
	g_ZhouHuoYueItemGrey[9] = ZhouHuoYue_ItemE1_Grey
	g_ZhouHuoYueItemGrey[10] = ZhouHuoYue_ItemE2_Grey
	g_ZhouHuoYueItemGrey[11] = ZhouHuoYue_ItemF1_Grey
	g_ZhouHuoYueItemGrey[12] = ZhouHuoYue_ItemF2_Grey
	g_ZhouHuoYueItemGrey[13] = ZhouHuoYue_ItemG1_Grey
	g_ZhouHuoYueItemGrey[14] = ZhouHuoYue_ItemG2_Grey
	g_ZhouHuoYueItemGrey[15] = ZhouHuoYue_ItemH1_Grey
	g_ZhouHuoYueItemGrey[16] = ZhouHuoYue_ItemH2_Grey
	g_ZhouHuoYueItemGrey[17] = ZhouHuoYue_ItemI1_Grey
	g_ZhouHuoYueItemGrey[18] = ZhouHuoYue_ItemI2_Grey
	g_ZhouHuoYueItemGrey[19] = ZhouHuoYue_ItemJ1_Grey
	g_ZhouHuoYueItemGrey[20] = ZhouHuoYue_ItemJ2_Grey
	
	g_ZhouHuoYuePageTips[1] = ZhouHuoYue_Daily_tips
	g_ZhouHuoYuePageTips[2] = ZhouHuoYue_Fuben_tips
	g_ZhouHuoYuePageTips[3] = ZhouHuoYue_Huodong_tips
	g_ZhouHuoYuePageTips[4] = ZhouHuoYue_Zhandou_tips
	g_ZhouHuoYuePageTips[5] = ZhouHuoYue_Xiuxian_tips
	g_ZhouHuoYuePageTips[6] = ZhouHuoYue_All_tips
	
	g_ZhouHuoYue_Lock[1] = ZhouHuoYue_Lock1
	g_ZhouHuoYue_Lock[2] = ZhouHuoYue_Lock2
	g_ZhouHuoYue_Lock[3] = ZhouHuoYue_Lock3
	g_ZhouHuoYue_Lock[4] = ZhouHuoYue_Lock4
	
	g_ZhouHuoYue_Stage[1] = ZhouHuoYue_Stage1
	g_ZhouHuoYue_Stage[2] = ZhouHuoYue_Stage2
	g_ZhouHuoYue_Stage[3] = ZhouHuoYue_Stage3
	g_ZhouHuoYue_Stage[4] = ZhouHuoYue_Stage4
	
	g_GutLine[1] = ZhouHuoYue_Section1
	g_GutLine[2] = ZhouHuoYue_Section2
	g_GutLine[3] = ZhouHuoYue_Section3
	g_GutLine[4] = ZhouHuoYue_Section4
	
	g_NowSelect = 0;
	
	for i = 1, 6 do
		g_ZhouHuoYue_Item[i] = {
			_G[string.format("ZhouHuoYue_Item_%d", i)],
			_G[string.format("ZhouHuoYue_CutlineMission_%d", i)],
			_G[string.format("ZhouHuoYue_MissionBK_%d", i)],
			_G[string.format("ZhouHuoYue_Item_Icon1_%d", i)],
			_G[string.format("ZhouHuoYue_Item_Text1_%d", i)],
			_G[string.format("ZhouHuoYue_Item_Text2_%d", i)],
			_G[string.format("ZhouHuoYue_Item_Text3_%d", i)],
			_G[string.format("ZhouHuoYue_Item_Text4_%d", i)],
			_G[string.format("ZhouHuoYue_Item_Text5_%d", i)],
			_G[string.format("ZhouHuoYue_Item_ButtonGet_%d", i)],
			_G[string.format("ZhouHuoYue_Item_ButtonGoto_%d", i)],
			_G[string.format("ZhouHuoYue_Received_%d", i)],
			_G[string.format("ZhouHuoYue_Mission_Help_%d", i)],
		}
	end
end

--=========
-- Event
--=========
function ZhouHuoYue_OnEvent(event)
	
	if (event == "UI_COMMAND" and tonumber(arg0) == 20211124) then
		local nType = Get_XParam_INT(0)
		g_StartTime = Get_XParam_INT(1)
		g_EndTime = Get_XParam_INT(2)
		local nHuoYueZhi = Get_XParam_INT(3)
		local nAwardProcess = Get_XParam_INT(4)
		local nHuoYueZhiDay = Get_XParam_INT(5)
		local nPlayerLevel = Player:GetData("LEVEL")
		if nType == 0 then
			g_ZhouHuoYueData_1 = {}
			g_ZhouHuoYuePage = 0
			ZhouHuoYue_InIt()
			ZhouHuoYue_UpdataTop(nHuoYueZhi, nAwardProcess, nHuoYueZhiDay)
			ZhouHuoYue_UpdataBottom(0, nPlayerLevel)
			ZhouHuoYue_All:SetCheck(1)
			g_NowSelect = 0
			this:Show()
		else
			if this:IsVisible() then
				ZhouHuoYue_UpdataTop(nHuoYueZhi, nAwardProcess, nHuoYueZhiDay)
				ZhouHuoYue_UpdataBottom(g_NowSelect, nPlayerLevel)
			end
		end
	elseif event == "HIDE_ON_SCENE_TRANSED" then
		
		ZhouHuoYue_Close()
	
	elseif event == "VIEW_RESOLUTION_CHANGED" then
		
		ZhouHuoYue_On_ResetPos()
	
	elseif event == "ADJEST_UI_POS" then
		
		ZhouHuoYue_On_ResetPos()
	
	end

end

function ZhouHuoYue_Close()
	g_NowSelect = 0
	this:Hide()
	for i = 1, 5 do
		g_isShowTips[i] = 0
	end
	g_AwardTips = 0
	for i = 1, table.getn(g_ZhouHuoYue_Lock) do
		g_ZhouHuoYue_Lock[i]:Hide()
		g_ZhouHuoYue_Stage[i]:Hide()
		g_GutLine[i]:Hide()
	end
end

--=========
-- 重置
--=========
function ZhouHuoYue_On_ResetPos()
	
	ZhouHuoYue_FrameFull:SetProperty("UnifiedPosition", g_Frame_UnifiedPosition)

end


--=========
-- 填充上半部分数据
--=========
function ZhouHuoYue_UpdataTop(num, nAwardProcess, nHuoYueZhiDay)
	
	local nLevel = Player:GetData("LEVEL")
	
	for i = 1, table.getn(g_ZhouHuoYueItem) do
		g_ZhouHuoYueItem[i]:SetActionItem(-1)
	end
	
	for i = 1, table.getn(g_ZhouHuoYueItem) do
		local theAction = GemCarve:UpdateProductAction(g_ZhouHuoYueItemId[i].item)
		if theAction:GetID() ~= 0 then
			g_ZhouHuoYueItem[i]:SetActionItem(theAction:GetID());
			g_ZhouHuoYueItem[i]:SetProperty("CornerChar", string.format("BotRight %s", g_ZhouHuoYueItemId[i].num));
		end
		if nAwardProcess * 2 >= i then
			g_ZhouHuoYueItemGrey[i]:Show()
		else
			g_ZhouHuoYueItemGrey[i]:Hide()
		end
	end
	
	if num > g_ZhouHuoYueMax then
		ZhouHuoYue_Text2:SetText("#G" .. num)
		ZhouHuoYue_EXP:SetProgress(g_ZhouHuoYueMax, g_ZhouHuoYueMax)
		ZhouHuoYue_EXPTip:SetToolTip(string.format("本周已累计获得活跃%s。", num))
	else
		ZhouHuoYue_Text2:SetText("#G" .. num)
		ZhouHuoYue_EXP:SetProgress(num, g_ZhouHuoYueMax)
		ZhouHuoYue_EXPTip:SetToolTip(string.format("本周已累计获得活跃%s。", num))
	end
	
	local mark = 0
	for i = 1, table.getn(g_ProcessLimit) do
		if num >= g_ProcessLimit[i].neednum and nAwardProcess == i - 1 then
			ZhouHuoYue_GetAward_tips:Show()
			g_AwardTips = 1
			mark = 1
			break
		else
			ZhouHuoYue_GetAward_tips:Hide()
		end
	end
	
	if mark == 0 then
		g_AwardTips = 0
	end
	
	for i = 1, table.getn(g_ZhouHuoYue_LevelLimit) do
		--if nLevel < g_ZhouHuoYue_LevelLimit[i] then
		g_ZhouHuoYue_Lock[i]:Hide()
		g_ZhouHuoYue_Stage[i]:Hide()
		g_GutLine[i]:Hide()
		--end
	end
	ZhouHuoYue_Condition_Text:SetText(string.format("#cfff263下方为#G今日#cfff263可获得#G活跃值#cfff263的活动列表，您可根据喜好，自行选择完成。#r#cfff263今日活跃值：#G%s/500", nHuoYueZhiDay))

end

function ZhouHuoYue_InIt()
	for i = 1, 53 do
		local nIndex, nBigClass, nSmallClass, nSmallClassIndex, strName, strDesc, strTubiao, nNeedTimes, nHuoYueZhi, nGotoType, nParam1, nParam2, nParam3, nParam4, nLevel = Lua_GetZhouHuoYueInfo(i - 1)
		g_ZhouHuoYueData_1[i] = { nIndex, nBigClass, nSmallClass, nSmallClassIndex, strName, strDesc, strTubiao, nNeedTimes, nHuoYueZhi, nGotoType, nParam1, nParam2, nParam3, nParam4, nLevel }
	end
end
--=========
-- 翻页
--=========
function ZhouHuoYue_PageChange(idx)
	g_ZhouHuoYuePage = g_ZhouHuoYuePage + idx
	local nPageNum = { 4, 1, 1, 0, 0, 0 }
	if g_ZhouHuoYuePage <= 0 then
		g_ZhouHuoYuePage = 0
	elseif g_ZhouHuoYuePage >= nPageNum[g_NowSelect + 1] then
		g_ZhouHuoYuePage = nPageNum[g_NowSelect + 1]
	end
	ZhouHuoYue_UpdataBottom(g_NowSelect, Player:GetData("LEVEL"))
end
--=========
-- 填充下半部分数据 index 为分类 全部 副本 活动 .........
--=========
function ZhouHuoYue_UpdataBottom(index, nPlayerLevel)
	
	
	-- ZhouHuoYue_Lace:Clear()
	local nMinRecord, nMaxRecord = g_ZhouHuoYuePage * 6 + 1, g_ZhouHuoYuePage * 6 + 6
	if nMinRecord <= 0 then
		return
	end
	
	local curDay = tonumber(GetServerDayTime());
	local times = 1
	--这里是是否开启双倍活跃度
	if curDay >= g_StartTime and curDay <= g_EndTime then
		times = 2
	end
	local bar = 1
	for i = 1, 6 do
		g_ZhouHuoYue_Item[i][1]:Hide()
	end
	local nIndex = 0
	nItemNewTable = {}
	if index == 0 then
		--已完成未领取		
		for i = 1, 53 do
			if nPlayerLevel >= g_ZhouHuoYueData_1[i][15] then
				local nGetAwardInfo = Lua_GetZhouHuoYueNum(g_ZhouHuoYueData_1[i][3] - 1)--完成数
				local nProcessInfo = Lua_GetZhouHuoYueProcess(g_ZhouHuoYueData_1[i][3] - 1)--层级
				local nSmallClassMaxIndex = Lua_GetZhouHuoYueSmallClassMax(g_ZhouHuoYueData_1[i][3])--每日可完成次数
				if nProcessInfo == g_ZhouHuoYueData_1[i][4] - 1 and nGetAwardInfo >= g_ZhouHuoYueData_1[i][8] then
					table.insert(nItemNewTable, g_ZhouHuoYueData_1[i])
				end
			end
		end
		--未完成未领取
		for i = 1, 53 do
			if nPlayerLevel >= g_ZhouHuoYueData_1[i][15] then
				local nGetAwardInfo = Lua_GetZhouHuoYueNum(g_ZhouHuoYueData_1[i][3] - 1)
				local nProcessInfo = Lua_GetZhouHuoYueProcess(g_ZhouHuoYueData_1[i][3] - 1)--完成次数
				local nSmallClassMaxIndex = Lua_GetZhouHuoYueSmallClassMax(g_ZhouHuoYueData_1[i][3])
				if nProcessInfo == g_ZhouHuoYueData_1[i][4] - 1 and nGetAwardInfo < g_ZhouHuoYueData_1[i][8] then
					table.insert(nItemNewTable, g_ZhouHuoYueData_1[i])
				end
			end
		end
		--所有层完成
		for i = 1, 53 do
			if nPlayerLevel >= g_ZhouHuoYueData_1[i][15] then
				local nGetAwardInfo = Lua_GetZhouHuoYueNum(g_ZhouHuoYueData_1[i][3] - 1)
				local nProcessInfo = Lua_GetZhouHuoYueProcess(g_ZhouHuoYueData_1[i][3] - 1)
				local nSmallClassMaxIndex = Lua_GetZhouHuoYueSmallClassMax(g_ZhouHuoYueData_1[i][3])
				if nProcessInfo == nSmallClassMaxIndex and g_ZhouHuoYueData_1[i][4] == nSmallClassMaxIndex then
					table.insert(nItemNewTable, g_ZhouHuoYueData_1[i])
				end
			end
		end
		for i = nMinRecord, nMaxRecord do
			if nItemNewTable[i] == nil or nItemNewTable[i] == "" then
				break
			end
			nGetAwardInfo = Lua_GetZhouHuoYueNum(nItemNewTable[i][3] - 1)
			nProcessInfo = Lua_GetZhouHuoYueProcess(nItemNewTable[i][3] - 1)
			nSmallClassMaxIndex = Lua_GetZhouHuoYueSmallClassMax(nItemNewTable[i][3])
			if nItemNewTable[i][5] == -1 then
				break
			end
			nIndex = nIndex + 1
			g_ZhouHuoYue_Item[nIndex][1]:Show()
			g_ZhouHuoYue_Item[nIndex][5]:SetText(nItemNewTable[i][5]);
			g_ZhouHuoYue_Item[nIndex][6]:SetText(nItemNewTable[i][6]);
			if nProcessInfo == nItemNewTable[i][4] - 1 and nGetAwardInfo >= nItemNewTable[i][8] then
				g_ZhouHuoYue_Item[nIndex][7]:SetText(tostring(nItemNewTable[i][8]) .. "/" .. tostring(nItemNewTable[i][8]));
				g_ZhouHuoYue_Item[nIndex][11]:Hide();
				g_ZhouHuoYue_Item[nIndex][10]:Show();
				g_ZhouHuoYue_Item[nIndex][12]:Hide()
				g_ZhouHuoYue_Item[nIndex][13]:Show()
			elseif nProcessInfo == nItemNewTable[i][4] - 1 and nGetAwardInfo < nItemNewTable[i][8] then
				g_ZhouHuoYue_Item[nIndex][7]:SetText(tostring(nGetAwardInfo) .. "/" .. tostring(nItemNewTable[i][8]))
				g_ZhouHuoYue_Item[nIndex][11]:Show();
				g_ZhouHuoYue_Item[nIndex][10]:Hide();
				g_ZhouHuoYue_Item[nIndex][12]:Hide()
				g_ZhouHuoYue_Item[nIndex][13]:Show()
			elseif nProcessInfo == nSmallClassMaxIndex and nItemNewTable[i][4] == nSmallClassMaxIndex then
				g_ZhouHuoYue_Item[nIndex][7]:SetText(tostring(nItemNewTable[i][8]) .. "/" .. tostring(nItemNewTable[i][8]));
				g_ZhouHuoYue_Item[nIndex][11]:Hide();
				g_ZhouHuoYue_Item[nIndex][10]:Hide();
				g_ZhouHuoYue_Item[nIndex][12]:Show()
				g_ZhouHuoYue_Item[nIndex][13]:Show()
			end
			g_ZhouHuoYue_Item[nIndex][8]:SetText("#G" .. nItemNewTable[i][9] * times);
			g_ZhouHuoYue_Item[nIndex][4]:SetProperty("Image", nItemNewTable[i][7]);
		end
	else
		local nIndexMax = LuaFnGetIndexMaxNum(index)
		for i = 1, 53 do
			if nPlayerLevel >= g_ZhouHuoYueData_1[i][15] then
				if g_ZhouHuoYueData_1[i][2] == index then
					local nGetAwardInfo = Lua_GetZhouHuoYueNum(g_ZhouHuoYueData_1[i][3] - 1)
					local nProcessInfo = Lua_GetZhouHuoYueProcess(g_ZhouHuoYueData_1[i][3] - 1)
					local nSmallClassMaxIndex = Lua_GetZhouHuoYueSmallClassMax(g_ZhouHuoYueData_1[i][3])
					if nProcessInfo == g_ZhouHuoYueData_1[i][4] - 1 and nGetAwardInfo >= g_ZhouHuoYueData_1[i][8] then
						table.insert(nItemNewTable, g_ZhouHuoYueData_1[i])
					end
				end
			end
		end
		for i = 1, 53 do
			if nPlayerLevel >= g_ZhouHuoYueData_1[i][15] then
				if g_ZhouHuoYueData_1[i][2] == index then
					local nGetAwardInfo = Lua_GetZhouHuoYueNum(g_ZhouHuoYueData_1[i][3] - 1)
					local nProcessInfo = Lua_GetZhouHuoYueProcess(g_ZhouHuoYueData_1[i][3] - 1)
					local nSmallClassMaxIndex = Lua_GetZhouHuoYueSmallClassMax(g_ZhouHuoYueData_1[i][3])
					if nProcessInfo == g_ZhouHuoYueData_1[i][4] - 1 and nGetAwardInfo < g_ZhouHuoYueData_1[i][8] then
						table.insert(nItemNewTable, g_ZhouHuoYueData_1[i])
					end
				end
			end
		end
		for i = 1, 53 do
			if nPlayerLevel >= g_ZhouHuoYueData_1[i][15] then
				if g_ZhouHuoYueData_1[i][2] == index then
					local nGetAwardInfo = Lua_GetZhouHuoYueNum(g_ZhouHuoYueData_1[i][3] - 1)
					local nProcessInfo = Lua_GetZhouHuoYueProcess(g_ZhouHuoYueData_1[i][3] - 1)
					local nSmallClassMaxIndex = Lua_GetZhouHuoYueSmallClassMax(g_ZhouHuoYueData_1[i][3])
					if nProcessInfo == nSmallClassMaxIndex and g_ZhouHuoYueData_1[i][4] == nSmallClassMaxIndex then
						table.insert(nItemNewTable, g_ZhouHuoYueData_1[i])
					end
				end
			end
		end
		for i = nMinRecord, nMaxRecord do
			if nItemNewTable[i] == nil or nItemNewTable[i] == "" then
				break
			end
			nGetAwardInfo = Lua_GetZhouHuoYueNum(nItemNewTable[i][3] - 1)
			nProcessInfo = Lua_GetZhouHuoYueProcess(nItemNewTable[i][3] - 1)
			nSmallClassMaxIndex = Lua_GetZhouHuoYueSmallClassMax(nItemNewTable[i][3])
			if nItemNewTable[i][5] == -1 then
				break
			end
			nIndex = nIndex + 1
			g_ZhouHuoYue_Item[nIndex][1]:Show()
			g_ZhouHuoYue_Item[nIndex][5]:SetText(nItemNewTable[i][5]);
			g_ZhouHuoYue_Item[nIndex][6]:SetText(nItemNewTable[i][6]);
			if nProcessInfo == nItemNewTable[i][4] - 1 and nGetAwardInfo >= nItemNewTable[i][8] then
				g_ZhouHuoYue_Item[nIndex][7]:SetText(tostring(nItemNewTable[i][8]) .. "/" .. tostring(nItemNewTable[i][8]));
				g_ZhouHuoYue_Item[nIndex][11]:Hide();
				g_ZhouHuoYue_Item[nIndex][10]:Show();
				g_ZhouHuoYue_Item[nIndex][12]:Hide()
				g_ZhouHuoYue_Item[nIndex][13]:Show()
			elseif nProcessInfo == nItemNewTable[i][4] - 1 and nGetAwardInfo < nItemNewTable[i][8] then
				g_ZhouHuoYue_Item[nIndex][7]:SetText(tostring(nGetAwardInfo) .. "/" .. tostring(nItemNewTable[i][8]))
				g_ZhouHuoYue_Item[nIndex][11]:Show();
				g_ZhouHuoYue_Item[nIndex][10]:Hide();
				g_ZhouHuoYue_Item[nIndex][12]:Hide()
				g_ZhouHuoYue_Item[nIndex][13]:Show()
			elseif nProcessInfo == nSmallClassMaxIndex and nItemNewTable[i][4] == nSmallClassMaxIndex then
				g_ZhouHuoYue_Item[nIndex][7]:SetText(tostring(nItemNewTable[i][8]) .. "/" .. tostring(nItemNewTable[i][8]));
				g_ZhouHuoYue_Item[nIndex][11]:Hide();
				g_ZhouHuoYue_Item[nIndex][10]:Hide();
				g_ZhouHuoYue_Item[nIndex][12]:Show()
				g_ZhouHuoYue_Item[nIndex][13]:Show()
			end
			g_ZhouHuoYue_Item[nIndex][8]:SetText("#G" .. nItemNewTable[i][9] * times);
			g_ZhouHuoYue_Item[nIndex][4]:SetProperty("Image", nItemNewTable[i][7]);
		end
	end


end

function ZhouHuoYue_GotoClick(index)
	index = g_ZhouHuoYuePage * 6 + index
	if nItemNewTable[index] == nil then
		return
	end
	local nIndex, nBigClass, nSmallClass, nSmallClassIndex, strName, strDesc, strTubiao, nNeedTimes, nHuoYueZhi, nGotoType, nParam1, nParam2, nParam3, nParam4, nLevel = nItemNewTable[index][1], nItemNewTable[index][2], nItemNewTable[index][3], nItemNewTable[index][4], nItemNewTable[index][5], nItemNewTable[index][6], nItemNewTable[index][7], nItemNewTable[index][8], nItemNewTable[index][9], nItemNewTable[index][10], nItemNewTable[index][11], nItemNewTable[index][12], nItemNewTable[index][13], nItemNewTable[index][14], nItemNewTable[index][15]
	-- 1需要特殊处理 因为是打开界面
	if nGotoType == 1 then
		if nSmallClass == 7 then
			-- 打开元宝商店
			ToggleYuanbaoShop()
		elseif nSmallClass == 8 then
			-- 打开绑定元宝商店
			ToggleYuanbaoShop()
			-- YuanbaoShop_ChangeTabIndex(1)
		end
	elseif nGotoType == 2 then
		
		-- if Player:GetLevel() < g_LevelLimit then
		local nScnenName = LuaFnGetSceneName(nParam1)
		PushDebugMessage("暂不支持跨地图传送，后续更新,请前往" .. nScnenName .. "#{_INFOAIM" .. nParam2 .. "," .. nParam3 .. "," .. nParam1 .. "," .. nParam4 .. "}" .. nParam4)
		-- return
		-- end
		-- AutoRunToTargetEx(nParam2,nParam3,nParam1)
		-- SetAutoRunTargetNPCName( nParam4 )
		-- PushDebugMessage("")
	elseif nGotoType == 3 then
		PushDebugMessage(nParam4)
	end

end

function ZhouHuoYue_GetAwardClick()
	
	Clear_XSCRIPT();
	Set_XSCRIPT_Function_Name("GetZhouHuoYueAward");
	Set_XSCRIPT_ScriptID(892002);
	Set_XSCRIPT_ParamCount(0);
	Send_XSCRIPT();
end

function ZhouHuoYue_GetZhouHuoYueAddHuoYueZhi(index)
	index = g_ZhouHuoYuePage * 6 + index
	local nIndex, nBigClass, nSmallClass, nSmallClassIndex, strName, strDesc, strTubiao, nNeedTimes, nHuoYueZhi, nGotoType, nParam1, nParam2, nParam3, nParam4, nLevel = nItemNewTable[index][1], nItemNewTable[index][2], nItemNewTable[index][3], nItemNewTable[index][4], nItemNewTable[index][5], nItemNewTable[index][6], nItemNewTable[index][7], nItemNewTable[index][8], nItemNewTable[index][9], nItemNewTable[index][10], nItemNewTable[index][11], nItemNewTable[index][12], nItemNewTable[index][13], nItemNewTable[index][14], nItemNewTable[index][15]
	Clear_XSCRIPT();
	Set_XSCRIPT_Function_Name("AddHuoYueZhi");
	Set_XSCRIPT_ScriptID(892002);
	Set_XSCRIPT_Parameter(0, nSmallClass);
	Set_XSCRIPT_Parameter(1, nIndex);
	Set_XSCRIPT_ParamCount(2);
	Send_XSCRIPT();

end

function ZhouHuoYue_MissionHelpClick(index)
	index = g_ZhouHuoYuePage * 6 + index
	local nIndex, nBigClass, nSmallClass, nSmallClassIndex, strName, strDesc, strTubiao, nNeedTimes, nHuoYueZhi, nGotoType, nParam1, nParam2, nParam3, nParam4, nLevel = nItemNewTable[index][1], nItemNewTable[index][2], nItemNewTable[index][3], nItemNewTable[index][4], nItemNewTable[index][5], nItemNewTable[index][6], nItemNewTable[index][7], nItemNewTable[index][8], nItemNewTable[index][9], nItemNewTable[index][10], nItemNewTable[index][11], nItemNewTable[index][12], nItemNewTable[index][13], nItemNewTable[index][14], nItemNewTable[index][15]
	PushEvent("UI_COMMAND", 20211202, nIndex)
end

--=========
-- 问号帮助
--=========
function ZhouHuoYue_OnClickHelp()
	PushEvent("UI_COMMAND", 20211201, 1)
end


--=========
-- 分页切换
--=========
function ZhouHuoYue_PageClick(index)
	local nLevel = Player:GetData("LEVEL")
	g_ZhouHuoYuePage = 0
	ZhouHuoYue_UpdataBottom(index, nLevel)
	g_NowSelect = index
end

