----------------------
-- ValentineRoseTopList ---
----------------------
--界面位置
local g_ValentineRoseTopList_UnifiedPosition = nil

--计时器
local g_ValentineRoseTopList_CooldownDur = 4*1000	--4s冷却
local g_ValentineRoseTopList_Cooldown = 
{
	[1] = 0,
	[2] = 0,
	[3] = 0,
	[4] = 0,
	[5] = 0,
}

--页签显示
local g_ValentineRoseTopList_CurPage = 0--默认显示页签--注：1-3标示排行榜 4-5标示兑换奖励
local g_ValentineRoseTopList_MaxPage = 4--最大页签数

--排行榜相关控件
local g_ValentineRoseTopList_Btn_Page = {}
local g_ValentineRoseTopList_Present_Name = {}
local g_ValentineRoseTopList_Present_Score = {}
local g_ValentineRoseTopList_Present_Winner = {}

local g_ValentineRoseTopList_Receive_Name = {}
local g_ValentineRoseTopList_Receive_Score = {}
local g_ValentineRoseTopList_Receive_Winner = {}

--上榜人数
local g_ValentineRoseTopList_Count = 5

--活动状态
local g_ValentineRoseTopList_State = -1

--榜单信息
local g_ValentineRoseTopList_Info = --待修改
{
--三生挚恋送花榜 三生挚恋收花榜
	[1] = {desc = "#{MGCQ_151230_38}", count = 3, sendmd = 546, receivemd = 547, 
			sendtitle = "#{MGCQ_151230_39}", receivetitle = "#{MGCQ_151230_40}", 
			strsend = "#{MGCQ_151230_23}", strreceive = "#{MGCQ_151230_24}", 
			strsendNum = "#{MGCQ_151230_41}", strreceiveNum = "#{MGCQ_151230_42}", 
			stateing = "#{MGCQ_151230_149}", stateend = "#{MGCQ_151230_150}"
			},
--耀世传情送花榜 耀世传情收花榜
	[2] = {desc = "#{MGCQ_151230_12}", count = 3, sendmd = 550, receivemd = 551, 
			sendtitle = "#{MGCQ_151230_19}", receivetitle = "#{MGCQ_151230_20}", 
			strsend = "#{MGCQ_151230_23}", strreceive = "#{MGCQ_151230_24}", 
			strsendNum = "#{MGCQ_151230_25}", strreceiveNum = "#{MGCQ_151230_26}", 
			stateing = "#{MGCQ_151230_13}", stateend = "#{MGCQ_151230_18}"
			},
--万千宠爱送花榜 万千宠爱收花榜
	[3] = {desc = "#{MGCQ_151230_31}", count = 3, sendmd = 548, receivemd = 549, 
			sendtitle = "#{MGCQ_151230_34}", receivetitle = "#{MGCQ_151230_35}", 
			strsend = "#{MGCQ_151230_23}", strreceive = "#{MGCQ_151230_24}", 
			strsendNum = "#{MGCQ_151230_36}", strreceiveNum = "#{MGCQ_151230_37}", 
			stateing = "#{MGCQ_151230_32}", stateend = "#{MGCQ_151230_33}"
			},
}

--榜单信息
local g_ValentineRoseTopList_Tip = --待修改
{
--MGCQ_151230_127	活动正在进行中，请于2021年2月10日24点后再来领取！
--MGCQ_151230_72	活动正在进行中，请于2021年2月13日24点后再来领取！
--MGCQ_151230_126	活动正在进行中，请于2021年2月14日24点后再来领取！
	[1] = {tip1 = "#{MGCQ_151230_71}", tip2 = "#{MGCQ_151230_127}", tip3 = "#{MGCQ_151230_73}"},
	[2] = {tip1 = "#{MGCQ_151230_71}", tip2 = "#{MGCQ_151230_72}", tip3 = "#{MGCQ_151230_73}"},
	[3] = {tip1 = "#{MGCQ_151230_71}", tip2 = "#{MGCQ_151230_126}", tip3 = "#{MGCQ_151230_73}"},
}

--榜单奖励
local g_ValentineRoseTopList_SendJiangli = {}--送花奖励显示隐藏
local g_ValentineRoseTopList_ReceiveJiangli = {}--收花奖励显示隐藏
local g_ValentineRoseTopList_SendBonus = --送花奖励具体物品
{
	[1] = {action = "", itemid = 39920061, count = 3},--1
	[2] = {action = "", itemid = 39920061, count = 2},
	[3] = {action = "", itemid = 39920061, count = 1},
	
	[4] = {action = "", itemid = 39920057, count = 1},--2
	[5] = {action = "", itemid = 39920059, count = 1},
	[6] = {action = "", itemid = 39920058, count = 1},
	
	[7] = {action = "", itemid = 39920060, count = 1},--3 坐骑：梦灵仙驹（永久）
	[8] = {action = "", itemid = 39920068, count = 1},		--痴心不忘·醉世情圣	
	[9] = {action = "", itemid = 39920080, count = 1},
	[10] = {action = "", itemid = 39920079, count = 1},
}
local g_ValentineRoseTopList_ReceiveBonus = --收花奖励具体物品
{
	[1] = {action = "", itemid = 39920061, count = 3},--1
	[2] = {action = "", itemid = 39920061, count = 2},
	[3] = {action = "", itemid = 39920061, count = 1},
	
	[4] = {action = "", itemid = 39920057, count = 1},--2
	[5] = {action = "", itemid = 39920059, count = 1},
	[6] = {action = "", itemid = 39920058, count = 1},
	
	[7] = {action = "", itemid = 39920060, count = 1},--3 坐骑：梦灵仙驹（永久）
	[8] = {action = "", itemid = 39920069, count = 1},		--韶华绮梦·玫瑰情人	
	[9] = {action = "", itemid = 39920080, count = 1},
	[10] = {action = "", itemid = 39920079, count = 1},
}

local ValentineRoseTopList_Exchange_Qingrenjie_Action = {}
local ValentineRoseTopList_Exchange_Qingrenjie_Button = {}
local ValentineRoseTopList_Exchange_Qingrenjie_Text = {}
local ValentineRoseTopList_Exchange_Chiqingyu_Action = {}
local ValentineRoseTopList_Exchange_Chiqingyu_Button = {}
local ValentineRoseTopList_Exchange_Chiqingyu_Text = {}

local g_ValentineRoseTopList_Qingrenjie_Bonus =
{
	[1] = {neednum = 1314, itemid = 39920078, count = 1, name = "珍兽笼：七巧狸猫"},
	[2] = {neednum = 521, itemid = 39920062, count = 1, name = "珍兽蛋：七巧狸猫"},
	[3] = {neednum = 300, itemid = 39920063, count = 1, name = "山楂冰糖葫芦"},
	[4] = {neednum = 300, itemid = 39920064, count = 1, name = "大风车"},
	[5] = {neednum = 120, itemid = 39920065, count = 1, name = "漫天花雨"},
	[6] = {neednum = 120, itemid = 39920083, count = 1, name = "漫天花雨·心相印"},
}

local g_ValentineRoseTopList_Chiqingyu_Bonus =
{
	[1] = {neednum = 1, itemid = 39920070, itemid2 = 39920074, count = 1, name = "气宇不凡", namewoman = "如花似玉"},
	[2] = {neednum = 3, itemid = 39920071, itemid2 = 39920075, count = 1, name = "风流倜傥", namewoman = "国色天香"},
	[3] = {neednum = 10, itemid = 39920072, itemid2 = 39920076, count = 1, name = "玉树临风", namewoman = "倾国倾城"},
	[4] = {neednum = 16, itemid = 39920073, itemid2 = 39920077, count = 1, name = "龙章凤姿", namewoman = "绝世佳人"},
}

--===============================================
-- PreLoad()
--===============================================
function ValentineRoseTopList_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("OPEN_ROSE_TOPLIST")
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	this:RegisterEvent("UPDATA_ROSE_TOPLIST",false)
end

--===============================================
-- OnLoad()
--===============================================
function ValentineRoseTopList_OnLoad()
	g_ValentineRoseTopList_UnifiedPosition = ValentineRoseTopList_Frame:GetProperty("UnifiedPosition")
		
--排行榜相关控件
	g_ValentineRoseTopList_Btn_Page[1]	= ValentineRoseTopList_Top_TopList1
	g_ValentineRoseTopList_Btn_Page[2]	= ValentineRoseTopList_Top_TopList2
	g_ValentineRoseTopList_Btn_Page[3]	= ValentineRoseTopList_Top_TopList3
	g_ValentineRoseTopList_Btn_Page[4]	= ValentineRoseTopList_Top_Exchange1
	
	g_ValentineRoseTopList_Present_Name[1]	= ValentineRoseTopList_Present_Top1_Name
	g_ValentineRoseTopList_Present_Name[2]	= ValentineRoseTopList_Present_Top2_Name
	g_ValentineRoseTopList_Present_Name[3]	= ValentineRoseTopList_Present_Top3_Name
	g_ValentineRoseTopList_Present_Name[4]	= ValentineRoseTopList_Present_Top4_Name
	g_ValentineRoseTopList_Present_Name[5]	= ValentineRoseTopList_Present_Top5_Name
	
	g_ValentineRoseTopList_Present_Score[1]	= ValentineRoseTopList_Present_Top1_Num
	g_ValentineRoseTopList_Present_Score[2]	= ValentineRoseTopList_Present_Top2_Num
	g_ValentineRoseTopList_Present_Score[3]	= ValentineRoseTopList_Present_Top3_Num
	g_ValentineRoseTopList_Present_Score[4]	= ValentineRoseTopList_Present_Top4_Num
	g_ValentineRoseTopList_Present_Score[5]	= ValentineRoseTopList_Present_Top5_Num
	
	g_ValentineRoseTopList_Receive_Name[1]	= ValentineRoseTopList_Receive_Top1_Name
	g_ValentineRoseTopList_Receive_Name[2]	= ValentineRoseTopList_Receive_Top2_Name
	g_ValentineRoseTopList_Receive_Name[3]	= ValentineRoseTopList_Receive_Top3_Name
	g_ValentineRoseTopList_Receive_Name[4]	= ValentineRoseTopList_Receive_Top4_Name
	g_ValentineRoseTopList_Receive_Name[5]	= ValentineRoseTopList_Receive_Top5_Name
	
	g_ValentineRoseTopList_Receive_Score[1]	= ValentineRoseTopList_Receive_Top1_Num
	g_ValentineRoseTopList_Receive_Score[2]	= ValentineRoseTopList_Receive_Top2_Num
	g_ValentineRoseTopList_Receive_Score[3]	= ValentineRoseTopList_Receive_Top3_Num
	g_ValentineRoseTopList_Receive_Score[4]	= ValentineRoseTopList_Receive_Top4_Num
	g_ValentineRoseTopList_Receive_Score[5]	= ValentineRoseTopList_Receive_Top5_Num
	
	g_ValentineRoseTopList_SendBonus[1].action = ValentineRoseTopList_Prize_Present_Top1_Item
	g_ValentineRoseTopList_SendBonus[2].action = ValentineRoseTopList_Prize_Present_Top2_Item
	g_ValentineRoseTopList_SendBonus[3].action = ValentineRoseTopList_Prize_Present_Top3_Item
	
	g_ValentineRoseTopList_SendBonus[4].action = ValentineRoseTopList_Prize_Present_Top1_Item
	g_ValentineRoseTopList_SendBonus[5].action = ValentineRoseTopList_Prize_Present_Top2_Item
	g_ValentineRoseTopList_SendBonus[6].action = ValentineRoseTopList_Prize_Present_Top3_Item
		
	g_ValentineRoseTopList_SendBonus[7].action = ValentineRoseTopList_Prize1_Present_Top1_Item
	g_ValentineRoseTopList_SendBonus[8].action = ValentineRoseTopList_Prize1_Present_Top1_Item2
	g_ValentineRoseTopList_SendBonus[9].action = ValentineRoseTopList_Prize1_Present_Top2_Item
	g_ValentineRoseTopList_SendBonus[10].action = ValentineRoseTopList_Prize1_Present_Top3_Item

	g_ValentineRoseTopList_ReceiveBonus[1].action = ValentineRoseTopList_Prize_Receive_Top1_Item
	g_ValentineRoseTopList_ReceiveBonus[2].action = ValentineRoseTopList_Prize_Receive_Top2_Item
	g_ValentineRoseTopList_ReceiveBonus[3].action = ValentineRoseTopList_Prize_Receive_Top3_Item

	g_ValentineRoseTopList_ReceiveBonus[4].action = ValentineRoseTopList_Prize_Receive_Top1_Item
	g_ValentineRoseTopList_ReceiveBonus[5].action = ValentineRoseTopList_Prize_Receive_Top2_Item
	g_ValentineRoseTopList_ReceiveBonus[6].action = ValentineRoseTopList_Prize_Receive_Top3_Item
	
	g_ValentineRoseTopList_ReceiveBonus[7].action = ValentineRoseTopList_Prize1_Receive_Top1_Item
	g_ValentineRoseTopList_ReceiveBonus[8].action = ValentineRoseTopList_Prize1_Receive_Top1_Item2
	g_ValentineRoseTopList_ReceiveBonus[9].action = ValentineRoseTopList_Prize1_Receive_Top2_Item
	g_ValentineRoseTopList_ReceiveBonus[10].action = ValentineRoseTopList_Prize1_Receive_Top3_Item
	
--排行榜兑换相关控件
	ValentineRoseTopList_Exchange_Qingrenjie_Action[1] = ValentineRoseTopList_ExchangeFrame_BK1_Icon
	ValentineRoseTopList_Exchange_Qingrenjie_Action[2] = ValentineRoseTopList_ExchangeFrame_BK2_Icon
	ValentineRoseTopList_Exchange_Qingrenjie_Action[3] = ValentineRoseTopList_ExchangeFrame_BK3_Icon
	ValentineRoseTopList_Exchange_Qingrenjie_Action[4] = ValentineRoseTopList_ExchangeFrame_BK4_Icon
	ValentineRoseTopList_Exchange_Qingrenjie_Action[5] = ValentineRoseTopList_ExchangeFrame_BK5_Icon
	ValentineRoseTopList_Exchange_Qingrenjie_Action[6] = ValentineRoseTopList_ExchangeFrame_BK6_Icon

	ValentineRoseTopList_Exchange_Qingrenjie_Button[1] = ValentineRoseTopList_ExchangeFrame_BK1_Button
	ValentineRoseTopList_Exchange_Qingrenjie_Button[2] = ValentineRoseTopList_ExchangeFrame_BK2_Button
	ValentineRoseTopList_Exchange_Qingrenjie_Button[3] = ValentineRoseTopList_ExchangeFrame_BK3_Button
	ValentineRoseTopList_Exchange_Qingrenjie_Button[4] = ValentineRoseTopList_ExchangeFrame_BK4_Button
	ValentineRoseTopList_Exchange_Qingrenjie_Button[5] = ValentineRoseTopList_ExchangeFrame_BK5_Button
	ValentineRoseTopList_Exchange_Qingrenjie_Button[6] = ValentineRoseTopList_ExchangeFrame_BK6_Button

	ValentineRoseTopList_Exchange_Qingrenjie_Text[1] = ValentineRoseTopList_ExchangeFrame_BK1_Text
	ValentineRoseTopList_Exchange_Qingrenjie_Text[2] = ValentineRoseTopList_ExchangeFrame_BK2_Text
	ValentineRoseTopList_Exchange_Qingrenjie_Text[3] = ValentineRoseTopList_ExchangeFrame_BK3_Text
	ValentineRoseTopList_Exchange_Qingrenjie_Text[4] = ValentineRoseTopList_ExchangeFrame_BK4_Text
	ValentineRoseTopList_Exchange_Qingrenjie_Text[5] = ValentineRoseTopList_ExchangeFrame_BK5_Text
	ValentineRoseTopList_Exchange_Qingrenjie_Text[6] = ValentineRoseTopList_ExchangeFrame_BK6_Text

	ValentineRoseTopList_Exchange_Chiqingyu_Action[1] = ValentineRoseTopList_ExchangeFrame1_BK1_Icon
	ValentineRoseTopList_Exchange_Chiqingyu_Action[2] = ValentineRoseTopList_ExchangeFrame1_BK2_Icon
	ValentineRoseTopList_Exchange_Chiqingyu_Action[3] = ValentineRoseTopList_ExchangeFrame1_BK3_Icon
	ValentineRoseTopList_Exchange_Chiqingyu_Action[4] = ValentineRoseTopList_ExchangeFrame1_BK4_Icon	

	ValentineRoseTopList_Exchange_Chiqingyu_Button[1] = ValentineRoseTopList_ExchangeFrame1_BK1_Button
	ValentineRoseTopList_Exchange_Chiqingyu_Button[2] = ValentineRoseTopList_ExchangeFrame1_BK2_Button
	ValentineRoseTopList_Exchange_Chiqingyu_Button[3] = ValentineRoseTopList_ExchangeFrame1_BK3_Button
	ValentineRoseTopList_Exchange_Chiqingyu_Button[4] = ValentineRoseTopList_ExchangeFrame1_BK4_Button

	ValentineRoseTopList_Exchange_Chiqingyu_Text[1] = ValentineRoseTopList_ExchangeFrame1_BK1_Text
	ValentineRoseTopList_Exchange_Chiqingyu_Text[2] = ValentineRoseTopList_ExchangeFrame1_BK2_Text
	ValentineRoseTopList_Exchange_Chiqingyu_Text[3] = ValentineRoseTopList_ExchangeFrame1_BK3_Text
	ValentineRoseTopList_Exchange_Chiqingyu_Text[4] = ValentineRoseTopList_ExchangeFrame1_BK4_Text
		
end

--===============================================
-- OnEvent()
--===============================================
function ValentineRoseTopList_OnEvent(event)
	if (event  == "UI_COMMAND") and (tonumber(arg0) == 891049) then
		--设置当前页
		local npage = Get_XParam_INT(0)
		if npage == 4 then
			--显示界面
			g_ValentineRoseTopList_CurPage = npage
			g_ValentineRoseTopList_Btn_Page[g_ValentineRoseTopList_CurPage] : SetCheck(1)
			this:Show()
			ValentineRoseTopList_Exchange_Qingrenjie_Update()
			ValentineRoseTopList_Exchange_Chiqingyu_Update()
		else
			if npage < 1 or npage > 3 then
				return
			end
			g_ValentineRoseTopList_CurPage = npage
			g_ValentineRoseTopList_Btn_Page[g_ValentineRoseTopList_CurPage] : SetCheck(1)
			--显示状态
			local state = Get_XParam_INT(1)
			if state ~= nil and state >= 0 then
				ValentineRoseTopList_Rank_ShowState(state)
			end
			--显示倒计时
			local strTime = Get_XParam_STR(0)
			if strTime ~= nil then
				ValentineRoseTopList_Ranking_CountDown:SetText("#{QRPHB_150113_9}"..strTime)
			end
		end
	elseif (event == "UPDATA_ROSE_TOPLIST") then
		--更新MD
		ValentineRoseTopList_Rank_ShowRoseNum()
	elseif (event == "OPEN_ROSE_TOPLIST") then
		--显示排行榜
		ValentineRoseTopList_Rank_ShowTopList()
	elseif (event == "ADJEST_UI_POS") then
		ValentineRoseTopList_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		ValentineRoseTopList_ResetPos()
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		ValentineRoseTopList_Close_Click()
	end
end

--===============================================
-- 以下为界面更新显示
--===============================================
--显示排行榜状态
function ValentineRoseTopList_Rank_ShowState(state)	
	g_ValentineRoseTopList_State = state
end

--显示收送花数量
function ValentineRoseTopList_Rank_ShowRoseNum()
	if g_ValentineRoseTopList_CurPage < 1 or g_ValentineRoseTopList_CurPage > 3 then
		--PushDebugMessage("当前页签不是排行榜")
		return
	end
	
	local nSendNum =  DataPool:GetPlayerMission_DataRound(g_ValentineRoseTopList_Info[g_ValentineRoseTopList_CurPage].sendmd)
	local nNumStr = ScriptGlobal_Format(g_ValentineRoseTopList_Info[g_ValentineRoseTopList_CurPage].strsendNum, nSendNum)
	ValentineRoseTopList_Present_Me:SetText(nNumStr)
	
	local nReceiveNum =  DataPool:GetPlayerMission_DataRound(g_ValentineRoseTopList_Info[g_ValentineRoseTopList_CurPage].receivemd)
	local nReceiveNumStr = ScriptGlobal_Format(g_ValentineRoseTopList_Info[g_ValentineRoseTopList_CurPage].strreceiveNum, nReceiveNum)
	ValentineRoseTopList_Receive_Me:SetText(nReceiveNumStr)
end

--显示排行榜
function ValentineRoseTopList_Rank_ShowTopList()
	--有效性判断
	if g_ValentineRoseTopList_CurPage < 1 or g_ValentineRoseTopList_CurPage > 3 then
		--PushDebugMessage("当前页签不是排行榜")
		return
	end
	
	--显示界面
	this:Show()
	
	--隐藏兑奖
	ValentineRoseTopList_Exchange_Client:Hide()
	
	--显示排行榜
	ValentineRoseTopList_Ranking_Frame:Show()	

	--显示活动说明
	ValentineRoseTopList_Ranking_Info:SetText(g_ValentineRoseTopList_Info[g_ValentineRoseTopList_CurPage].desc)
	
	--显示送花相关信息
	ValentineRoseTopList_Present_TitleName:SetText(g_ValentineRoseTopList_Info[g_ValentineRoseTopList_CurPage].sendtitle)
	local nSendNum =  DataPool:GetPlayerMission_DataRound(g_ValentineRoseTopList_Info[g_ValentineRoseTopList_CurPage].sendmd)
	local nNumStr = ScriptGlobal_Format(g_ValentineRoseTopList_Info[g_ValentineRoseTopList_CurPage].strsendNum, nSendNum)
	ValentineRoseTopList_Present_Me:SetText(nNumStr)
	
	--显示收花数量
	ValentineRoseTopList_Receive_TitleName:SetText(g_ValentineRoseTopList_Info[g_ValentineRoseTopList_CurPage].receivetitle)
	local nReceiveNum =  DataPool:GetPlayerMission_DataRound(g_ValentineRoseTopList_Info[g_ValentineRoseTopList_CurPage].receivemd)
	local nReceiveNumStr = ScriptGlobal_Format(g_ValentineRoseTopList_Info[g_ValentineRoseTopList_CurPage].strreceiveNum, nReceiveNum)
	ValentineRoseTopList_Receive_Me:SetText(nReceiveNumStr)

	--显示奖励列表
	ValentineRoseTopList_Rank_ShowBonusList()

	--显示榜单
	local strDefName = ValentineRoseTopList_Rank_DefaultName()
	for i=1, g_ValentineRoseTopList_Count do
		--初始化默认值
		g_ValentineRoseTopList_Present_Name[i]:SetText(strDefName)--“虚位以待”或者“未能决出”
		g_ValentineRoseTopList_Present_Score[i]:SetText("#{QRPHB_150113_21}")--“送花朵数：”或者“收花朵数：”
		--更新数据
		local index,name,score = DataPool:Lua_GetRoseSendTopListInfo(i-1)
		if index ~= nil and index >= 0 and name ~= "" then
			g_ValentineRoseTopList_Present_Name[i]:SetText("#cfff263"..name)
			local scoreStr = ScriptGlobal_Format(g_ValentineRoseTopList_Info[g_ValentineRoseTopList_CurPage].strsend, tostring(score))
			g_ValentineRoseTopList_Present_Score[i]:SetText(scoreStr)--“送花朵数：XXX”或者“收花朵数：XXX”
		end
	end
	
	for i=1, g_ValentineRoseTopList_Count do
		--初始化默认值
		g_ValentineRoseTopList_Receive_Name[i]:SetText(strDefName)--“虚位以待”或者“未能决出”
		g_ValentineRoseTopList_Receive_Score[i]:SetText("#{QRPHB_150113_30}")--“送花朵数：”或者“收花朵数：”
		--更新数据
		local index,name,score = DataPool:Lua_GetRoseReceiveTopListInfo(i-1)
		if index ~= nil and index >= 0 and name ~= "" then
			g_ValentineRoseTopList_Receive_Name[i]:SetText("#cfff263"..name)
			local scoreStr = ScriptGlobal_Format(g_ValentineRoseTopList_Info[g_ValentineRoseTopList_CurPage].strreceive, tostring(score))
			g_ValentineRoseTopList_Receive_Score[i]:SetText(scoreStr)--“送花朵数：XXX”或者“收花朵数：XXX”
		end
	end
end

--显示奖励列表--特写--慎改
function ValentineRoseTopList_Rank_ShowBonusList()
	--有效性判断
	if g_ValentineRoseTopList_CurPage < 1 or g_ValentineRoseTopList_CurPage > 3 then
		--PushDebugMessage("当前页签不是排行榜")
		return
	end
	
	--特定奖励显示
	if g_ValentineRoseTopList_CurPage == 1 then
		--设置图标
		for i = 1, 3 do
			local theAction = DataPool:CreateActionItemForShow(g_ValentineRoseTopList_SendBonus[i].itemid, g_ValentineRoseTopList_SendBonus[i].count)
			if theAction:GetID() ~= 0 then
				g_ValentineRoseTopList_SendBonus[i].action:SetActionItem(theAction:GetID())
			end
		end		
		for i = 1, 3 do
			local theAction = DataPool:CreateActionItemForShow(g_ValentineRoseTopList_ReceiveBonus[i].itemid, g_ValentineRoseTopList_ReceiveBonus[i].count)
			if theAction:GetID() ~= 0 then
				g_ValentineRoseTopList_ReceiveBonus[i].action:SetActionItem(theAction:GetID())
			end
		end

		--显示隐藏
		ValentineRoseTopList_Ranking_Prize_Frame:Show()
		ValentineRoseTopList_Ranking_Prize1_Frame:Hide()
		ValentineRoseTopList_Prize_Present_Top1_ItemPreview:Show()
		ValentineRoseTopList_Prize_Present_Top2_ItemPreview:Show()
		ValentineRoseTopList_Prize_Present_Top3_ItemPreview:Show()
		ValentineRoseTopList_Prize_Receive_Top1_ItemPreview:Show()
		ValentineRoseTopList_Prize_Receive_Top2_ItemPreview:Show()
		ValentineRoseTopList_Prize_Receive_Top3_ItemPreview:Show()		
	elseif g_ValentineRoseTopList_CurPage == 2 then
		--设置图标
		for i = 4, 6 do
			local theAction = DataPool:CreateActionItemForShow(g_ValentineRoseTopList_SendBonus[i].itemid, g_ValentineRoseTopList_SendBonus[i].count)
			if theAction:GetID() ~= 0 then
				g_ValentineRoseTopList_SendBonus[i].action:SetActionItem(theAction:GetID())
			end
		end		
		for i = 4, 6 do
			local theAction = DataPool:CreateActionItemForShow(g_ValentineRoseTopList_ReceiveBonus[i].itemid, g_ValentineRoseTopList_ReceiveBonus[i].count)
			if theAction:GetID() ~= 0 then
				g_ValentineRoseTopList_ReceiveBonus[i].action:SetActionItem(theAction:GetID())
			end
		end
		
		--显示隐藏
		ValentineRoseTopList_Ranking_Prize_Frame:Show()
		ValentineRoseTopList_Ranking_Prize1_Frame:Hide()
		ValentineRoseTopList_Prize_Present_Top1_ItemPreview:Show()
		ValentineRoseTopList_Prize_Present_Top2_ItemPreview:Show()
		ValentineRoseTopList_Prize_Present_Top3_ItemPreview:Show()
		ValentineRoseTopList_Prize_Receive_Top1_ItemPreview:Show()
		ValentineRoseTopList_Prize_Receive_Top2_ItemPreview:Show()
		ValentineRoseTopList_Prize_Receive_Top3_ItemPreview:Show()		
	elseif g_ValentineRoseTopList_CurPage == 3 then
		--设置图标
		for i = 7, 10 do
			local theAction = DataPool:CreateActionItemForShow(g_ValentineRoseTopList_SendBonus[i].itemid, g_ValentineRoseTopList_SendBonus[i].count)
			if theAction:GetID() ~= 0 then
				g_ValentineRoseTopList_SendBonus[i].action:SetActionItem(theAction:GetID())
			end
		end
		
		for i = 7, 10 do
			local theAction = DataPool:CreateActionItemForShow(g_ValentineRoseTopList_ReceiveBonus[i].itemid, g_ValentineRoseTopList_ReceiveBonus[i].count)
			if theAction:GetID() ~= 0 then
				g_ValentineRoseTopList_ReceiveBonus[i].action:SetActionItem(theAction:GetID())
			end
		end		
	
		--显示隐藏
		ValentineRoseTopList_Ranking_Prize_Frame:Hide()
		ValentineRoseTopList_Ranking_Prize1_Frame:Show()
	end

end

--显示默认的名字
function ValentineRoseTopList_Rank_DefaultName()
	local strMsg=""
	
	if g_ValentineRoseTopList_State < 6 then 
		strMsg = "#{MGCQ_151230_21}"
	elseif g_ValentineRoseTopList_State >= 6 then 
		strMsg = "#{MGCQ_151230_22}"	
	end
		
	return strMsg
end

--===============================================
-- 以下为事件响应
--===============================================
--点击关闭
function ValentineRoseTopList_Close_Click()
	--数据清空
	ValentineRoseTopList_Clear()
	--界面隐藏
	this:Hide()
end

--点击页签
function ValentineRoseTopList_Page_Click(index)
	--有效性判断
	if index <= 0 or index > g_ValentineRoseTopList_MaxPage then
		--PushDebugMessage("页签错误，请重新选择")
		return
	end
	
	local nPage = g_ValentineRoseTopList_CurPage
	g_ValentineRoseTopList_CurPage = index
	
	--页面内容更新
	if g_ValentineRoseTopList_CurPage >= 1 and g_ValentineRoseTopList_CurPage <= 3 then
		--刷新排行榜
		local flag = ValentineRoseTopList_RankClick_Refresh()
		if flag == 0 and nPage >= 1 and nPage <= 5 then
			g_ValentineRoseTopList_Btn_Page[nPage]:SetCheck(1)--切回原来页面
		end
	elseif g_ValentineRoseTopList_CurPage == 4 then
		ValentineRoseTopList_Exchange_Qingrenjie_Update()
		ValentineRoseTopList_Exchange_Chiqingyu_Update()
	--elseif g_ValentineRoseTopList_CurPage == 5 then
	--	ValentineRoseTopList_Exchange_Chiqingyu_Update()
	end
end

--点击刷新
function ValentineRoseTopList_RankClick_Refresh()
	--有效性判断
	if g_ValentineRoseTopList_CurPage < 1 or g_ValentineRoseTopList_CurPage > 3 then
		--PushDebugMessage("当前页签不是排行榜")
		return 0
	end
	--判断冷却时间
	local nCooldown = g_ValentineRoseTopList_Cooldown[g_ValentineRoseTopList_CurPage]
	local iCur = FindFriendDataPool:GetTickCount()
	if ( iCur - nCooldown < g_ValentineRoseTopList_CooldownDur) then
		PushDebugMessage("#{MGCQ_151230_01}")
	  return 0
	end
	g_ValentineRoseTopList_Cooldown[g_ValentineRoseTopList_CurPage] = iCur
	
	--请求服务器数据
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "ClientAskRoseTopList" )
		Set_XSCRIPT_ScriptID( 891049 )--待修改脚本号：891049
		Set_XSCRIPT_Parameter(0,g_ValentineRoseTopList_CurPage)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
	
	return 1
end

--送花点击预览
function ValentineRoseTopList_Present_Zhanshi(index)
	--参数判断
	if index < 1 or index > 3 then
		return
	end
	--显示预览界面
	PushEvent("OPEN_ROSETOPLIST_ZHANSHI",index, g_ValentineRoseTopList_CurPage)
end

--收花点击预览
function ValentineRoseTopList_Receive_Zhanshi(index)
	--参数判断
	if index < 1 or index > 3 then
		return
	end
	--显示预览界面
	PushEvent("OPEN_ROSETOPLIST_ZHANSHI",index, g_ValentineRoseTopList_CurPage)
end

--点击送花榜领奖
function ValentineRoseTopList_Prize_Present(pos)
	--有效性判断
	if g_ValentineRoseTopList_CurPage < 1 or g_ValentineRoseTopList_CurPage > 3 then
		--PushDebugMessage("当前页签不是排行榜")
		return
	end	
	
	--参数判断
	if pos < 1 or pos > 3 then
		return
	end
	
	--判断领奖时间
	if g_ValentineRoseTopList_State == 0 then--理论上不存在
		PushDebugMessage(g_ValentineRoseTopList_Tip[g_ValentineRoseTopList_CurPage].tip1)
		return
	elseif g_ValentineRoseTopList_State >= 1 and g_ValentineRoseTopList_State <= 5 then--排行榜计时中
		PushDebugMessage(g_ValentineRoseTopList_Tip[g_ValentineRoseTopList_CurPage].tip2)
		return
	elseif g_ValentineRoseTopList_State == 6 then--可以领奖
	else--理论上不存在
		PushDebugMessage(g_ValentineRoseTopList_Tip[g_ValentineRoseTopList_CurPage].tip3)
		return
	end
	
	--判断安全时间
	if (tonumber(DataPool:GetLeftProtectTime()) > 0) then
		PushDebugMessage("#{MGCQ_151230_77}")--在安全时间内无法进行此操作。打开包裹栏，点击防盗号按钮可以自行设置安全时间。
		return
	end
	
	--判断电话密保和二级密码保护
  if CheckPhoneMibaoAndMinorPassword() ~= 1 then	
    return
  end
	
	--领奖
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "ClientGetRoseSendTopListPrize" )
		Set_XSCRIPT_ScriptID( 891049 )--待修改脚本号：891049
		Set_XSCRIPT_Parameter(0,g_ValentineRoseTopList_CurPage)
		Set_XSCRIPT_Parameter(1,pos)
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()

end

--点击收花榜领奖
function ValentineRoseTopList_Prize_Receive(pos)
	--有效性判断
	if g_ValentineRoseTopList_CurPage < 1 or g_ValentineRoseTopList_CurPage > 3 then
		--PushDebugMessage("当前页签不是排行榜")
		return
	end	
	
	--参数判断
	if pos < 1 or pos > 3 then
		return
	end
	
	--判断领奖时间
	if g_ValentineRoseTopList_State == 0 then--理论上不存在
		PushDebugMessage(g_ValentineRoseTopList_Tip[g_ValentineRoseTopList_CurPage].tip1)
		return
	elseif g_ValentineRoseTopList_State >= 1 and g_ValentineRoseTopList_State <= 5 then--排行榜计时中
		PushDebugMessage(g_ValentineRoseTopList_Tip[g_ValentineRoseTopList_CurPage].tip2)
		return
	elseif g_ValentineRoseTopList_State == 6 then--可以领奖
	else--理论上不存在
		PushDebugMessage(g_ValentineRoseTopList_Tip[g_ValentineRoseTopList_CurPage].tip3)
		return
	end
	
	--判断安全时间
	if (tonumber(DataPool:GetLeftProtectTime()) > 0) then
		PushDebugMessage("#{MGCQ_151230_77}")--在安全时间内无法进行此操作。打开包裹栏，点击防盗号按钮可以自行设置安全时间。
		return
	end
	
	--判断电话密保和二级密码保护
  if CheckPhoneMibaoAndMinorPassword() ~= 1 then	
    return
  end
	
	--领奖
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "ClientGetRoseReceiveTopListPrize" )
		Set_XSCRIPT_ScriptID( 891049 )--待修改脚本号：891049
		Set_XSCRIPT_Parameter(0,g_ValentineRoseTopList_CurPage)
		Set_XSCRIPT_Parameter(1,pos)
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()

end

--===============================================
-- 以下为基础函数
--===============================================
--状态清空
function ValentineRoseTopList_Clear()
 	--当前页码清空
	g_ValentineRoseTopList_CurPage = 0
	--活动状态清空
	g_ValentineRoseTopList_State = -1
end

--重置位置
function ValentineRoseTopList_ResetPos()
	ValentineRoseTopList_Frame:SetProperty("UnifiedPosition",g_ValentineRoseTopList_UnifiedPosition)
end


--===============================================
-- 以下为兑换奖励
--===============================================
--情人结兑换奖励窗口
function ValentineRoseTopList_Exchange_Qingrenjie_Update()
	ValentineRoseTopList_Ranking_Frame:Hide()
	ValentineRoseTopList_Exchange_Client:Show()
	--ValentineRoseTopList_Exchange_GiftFrame:Show()
	--ValentineRoseTopList_Exchange_GiftFrame1:Show()
	
	ValentineRoseTopList_Exchange_Info:SetText( "#{MGCQ_151230_101}" )
	
	for i = 1, table.getn(g_ValentineRoseTopList_Qingrenjie_Bonus) do
		local theAction = DataPool:CreateActionItemForShow(g_ValentineRoseTopList_Qingrenjie_Bonus[i].itemid, g_ValentineRoseTopList_Qingrenjie_Bonus[i].count)
		if theAction:GetID() ~= 0 then
			ValentineRoseTopList_Exchange_Qingrenjie_Action[i]:SetActionItem(theAction:GetID())
		end
		
		local strText = ScriptGlobal_Format("#{MGCQ_151230_103}", g_ValentineRoseTopList_Qingrenjie_Bonus[i].neednum)
		local strTips = ScriptGlobal_Format("#{MGCQ_151230_104}", g_ValentineRoseTopList_Qingrenjie_Bonus[i].neednum, g_ValentineRoseTopList_Qingrenjie_Bonus[i].name)
		ValentineRoseTopList_Exchange_Qingrenjie_Text[i]:SetText( strText )
		ValentineRoseTopList_Exchange_Qingrenjie_Text[i]:SetToolTip( strTips )
		ValentineRoseTopList_Exchange_Qingrenjie_Button[i]:SetToolTip( strTips )
	end
	
end

--痴情玉兑换奖励窗口
function ValentineRoseTopList_Exchange_Chiqingyu_Update()
	--ValentineRoseTopList_Ranking_Frame:Hide()
	--ValentineRoseTopList_Exchange_Client:Show()
	--ValentineRoseTopList_Exchange_GiftFrame:Hide()
	--ValentineRoseTopList_Exchange_GiftFrame1:Show()
	
	--ValentineRoseTopList_Exchange_Info:SetText( "#{MGCQ_151230_105}" )
	
	local MySex =Player:GetMySex()
	for i = 1, table.getn(g_ValentineRoseTopList_Chiqingyu_Bonus) do
		
		local itemId
		if MySex == 0 then
			itemId = g_ValentineRoseTopList_Chiqingyu_Bonus[i].itemid2
		elseif MySex == 1 then
			itemId = g_ValentineRoseTopList_Chiqingyu_Bonus[i].itemid
		end
		
		local theAction = DataPool:CreateActionItemForShow(itemId, g_ValentineRoseTopList_Chiqingyu_Bonus[i].count)
		if theAction:GetID() ~= 0 then
			ValentineRoseTopList_Exchange_Chiqingyu_Action[i]:SetActionItem(theAction:GetID())
		end
		
		local itemname
		if MySex == 0 then
			itemname = g_ValentineRoseTopList_Chiqingyu_Bonus[i].namewoman
		elseif MySex == 1 then
			itemname = g_ValentineRoseTopList_Chiqingyu_Bonus[i].name
		end
		
		local strText = ScriptGlobal_Format("#{MGCQ_151230_107}", g_ValentineRoseTopList_Chiqingyu_Bonus[i].neednum)
		local strTips = ScriptGlobal_Format("#{MGCQ_151230_108}", g_ValentineRoseTopList_Chiqingyu_Bonus[i].neednum, itemname)
		ValentineRoseTopList_Exchange_Chiqingyu_Text[i]:SetText( strText )
		ValentineRoseTopList_Exchange_Chiqingyu_Text[i]:SetToolTip( strTips )
		ValentineRoseTopList_Exchange_Chiqingyu_Button[i]:SetToolTip( strTips )
	end
	
end

--情人结兑换奖励
function ValentineRoseTopList_Exchange_Qingrenjie_Click(i)
	local str = ScriptGlobal_Format("#{MGCQ_151230_177}", g_ValentineRoseTopList_Qingrenjie_Bonus[i].neednum, g_ValentineRoseTopList_Qingrenjie_Bonus[i].name)
	PushEvent("ROSERANK_EXCHANGE_CONFIRM", 1, i, str)
end

--痴情玉兑换奖励
function ValentineRoseTopList_Exchange_Chiqingyu_Click(i)
	local MySex =Player:GetMySex()
	local itemname
	if MySex == 0 then
		itemname = g_ValentineRoseTopList_Chiqingyu_Bonus[i].namewoman
	elseif MySex == 1 then
		itemname = g_ValentineRoseTopList_Chiqingyu_Bonus[i].name
	end
	
	local str = ScriptGlobal_Format("#{MGCQ_151230_178}", g_ValentineRoseTopList_Chiqingyu_Bonus[i].neednum, itemname)
	PushEvent("ROSERANK_EXCHANGE_CONFIRM", 2, i, str)
end

--打开元宝商店——花舞人间——春城百花
function ValentineRoseTopList_BuyRose()
	ValentineRoseTopList_Shop_Goto(0, 6, 5)
end

function ValentineRoseTopList_Shop_Goto(Fenye, Tag, Shop)
	if(IsWindowShow("YuanbaoShop")) then
		CloseWindow("YuanbaoShop", true)
	end
	PushEvent("TOGGLE_YUANBAOSHOP", Fenye, -1, -1, Tag, Shop)
end





