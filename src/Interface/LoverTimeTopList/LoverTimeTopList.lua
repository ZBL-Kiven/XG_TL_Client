----------------------
-- LoverTimeTopList ---
----------------------
--界面位置
local g_LoverTimeTopList_UnifiedPosition = nil

--计时器
local g_LoverTimeTopList_CooldownDur = 4*1000	--4s冷却
local g_LoverTimeTopList_Cooldown = 
{
	[1] = 0,
	[2] = 0,
	[3] = 0,
	[4] = 0,
}

local g_Present_BarList = {}
local g_Receive_BarList = {}

--页签显示
local g_LoverTimeTopList_CurPage = 0--默认显示页签--注：1-3标示排行榜 4-5标示兑换奖励
local g_LoverTimeTopList_MaxPage = 4--最大页签数

--排行榜相关控件
local g_LoverTimeTopList_Btn_Page = {}
local g_LoverTimeTopList_Present_Name = {}
local g_LoverTimeTopList_Present_Score = {}
local g_LoverTimeTopList_Present_Winner = {}

local g_LoverTimeTopList_Btn_PageImage = {}

local g_LoverTimeTopList_Receive_Name = {}
local g_LoverTimeTopList_Receive_Score = {}
local g_LoverTimeTopList_Receive_Winner = {}

local g_LoverTimeTopList_Btn_ImageList = {
"set:LoverTime01 image:LoverTime_MeiGuiLuDown",
"set:LoverTime02 image:LoverTime_TianQinLeiDown",
"set:LoverTime02 image:LoverTime_ZhongXiaMengDown",
}

--上榜人数
local g_LoverTimeTopList_Count = 20

--活动状态
local g_LoverTimeTopList_State = -1
local g_LoverTimeTopList_StateShow = -1

--榜单信息
local g_LoverTimeTopList_Info = --待修改
{
	[1] = {desc = "#{QRZM_211119_94}", count = 3, sendmd = 659, receivemd = 660, sendtitle = "#{QRZM_211119_96}", receivetitle = "#{QRZM_211119_115}", strsend = "#{QRZM_211119_101}", strreceive = "#{QRZM_211119_103}", strsendNum = "#{QRZM_211119_105}", strreceiveNum = "#{QRZM_211119_255}"},
	[2] = {desc = "#{QRZM_211119_140}", count = 3, sendmd = 661, receivemd = 662, sendtitle = "#{QRZM_211119_96}", receivetitle = "#{QRZM_211119_115}", strsend = "#{QRZM_211119_101}", strreceive = "#{QRZM_211119_103}", strsendNum = "#{QRZM_211119_105}", strreceiveNum = "#{QRZM_211119_255}"},
	[3] = {desc = "#{QRZM_211119_149}", count = 3, sendmd = 663, receivemd = 664, sendtitle = "#{QRZM_211119_96}", receivetitle = "#{QRZM_211119_115}", strsend = "#{QRZM_211119_101}", strreceive = "#{QRZM_211119_103}", strsendNum = "#{QRZM_211119_105}", strreceiveNum = "#{QRZM_211119_255}"},
}

--榜单信息
local g_LoverTimeTopList_Tip = --待修改
{
	[1] = {tip1 = "#{QRZM_211119_277}", tip2 = "#{QRZM_211119_278}", tip3 = "#{QRZM_211119_279}"},
	[2] = {tip1 = "#{QRZM_211119_277}", tip2 = "#{QRZM_211119_297}", tip3 = "#{QRZM_211119_279}"},
	[3] = {tip1 = "#{QRZM_211119_277}", tip2 = "#{QRZM_211119_290}", tip3 = "#{QRZM_211119_279}"},
}

local LoverTimeTopList_Exchange_Qingrenjie_Action = {}
local LoverTimeTopList_Exchange_Qingrenjie_Button = {}
local LoverTimeTopList_Exchange_Qingrenjie_Text = {}
local LoverTimeTopList_Exchange_Qingrenjie_Text2 = {}

g_LoverTimeTopList_Qingrenjie_Bonus =
{
	[1] = {neednum = 2400, itemid = 10124649, count = 1, name = "仲夏夜之梦", LimitMD = -1, LimitNum = -1, LimitStr = nil},
	[2] = {neednum = 1500, itemid = 30309996, count = 1, name = "超级珍兽笼：安琪儿", LimitMD = 688, LimitNum = 3, LimitStr = LoverTimeTopList_Exchange_Item2_Text2},
	[3] = {neednum = 600, itemid = 10124681, count = 1, name = "碧梦莲华", LimitMD = -1, LimitNum = -1, LimitStr = nil},
	[4] = {neednum = 600, itemid = 10124697, count = 1, name = "素挽玄裳", LimitMD = -1, LimitNum = -1, LimitStr = nil},
	[5] = {neednum = 22, itemid = 30503140, count = 1, name = "虹耀石", LimitMD = -1, LimitNum = -1, LimitStr = nil},
}

--===============================================
-- PreLoad()
--===============================================
function LoverTimeTopList_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("OPEN_QINGRENJIE_TOPLIST")
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	this:RegisterEvent("REFRESH_QINGRENJIE_TOPLIST")
end

--===============================================
-- OnLoad()
--===============================================
function LoverTimeTopList_OnLoad()
	g_LoverTimeTopList_UnifiedPosition = LoverTimeTopList_Frame:GetProperty("UnifiedPosition")
		
--排行榜相关控件
	g_LoverTimeTopList_Btn_Page[1]	= LoverTimeTopList_Top_TopList1
	g_LoverTimeTopList_Btn_Page[2]	= LoverTimeTopList_Top_TopList3
	g_LoverTimeTopList_Btn_Page[3]	= LoverTimeTopList_Top_TopList2
	g_LoverTimeTopList_Btn_Page[4]	= LoverTimeTopList_Top_TopList4
	
	g_LoverTimeTopList_Btn_PageImage[1] = LoverTimeTopList_ClientBK1
	g_LoverTimeTopList_Btn_PageImage[2] = LoverTimeTopList_ClientBK3
	g_LoverTimeTopList_Btn_PageImage[3] = LoverTimeTopList_ClientBK2
	
--排行榜兑换相关控件	
	LoverTimeTopList_Exchange_Qingrenjie_Action[1] = LoverTimeTopList_Exchange_Item1_Icon
	LoverTimeTopList_Exchange_Qingrenjie_Action[2] = LoverTimeTopList_Exchange_Item2_Icon
	LoverTimeTopList_Exchange_Qingrenjie_Action[3] = LoverTimeTopList_Exchange_Item3_Icon
	LoverTimeTopList_Exchange_Qingrenjie_Action[4] = LoverTimeTopList_Exchange_Item4_Icon
	LoverTimeTopList_Exchange_Qingrenjie_Action[5] = LoverTimeTopList_Exchange_Item5_Icon
	LoverTimeTopList_Exchange_Qingrenjie_Action[6] = LoverTimeTopList_Exchange_Item6_Icon
	LoverTimeTopList_Exchange_Qingrenjie_Action[7] = LoverTimeTopList_Exchange_Item7_Icon

	LoverTimeTopList_Exchange_Qingrenjie_Button[1] = LoverTimeTopList_Exchange_Item1_Get
	LoverTimeTopList_Exchange_Qingrenjie_Button[2] = LoverTimeTopList_Exchange_Item2_Get
	LoverTimeTopList_Exchange_Qingrenjie_Button[3] = LoverTimeTopList_Exchange_Item3_Get
	LoverTimeTopList_Exchange_Qingrenjie_Button[4] = LoverTimeTopList_Exchange_Item4_Get
	LoverTimeTopList_Exchange_Qingrenjie_Button[5] = LoverTimeTopList_Exchange_Item5_Get
	LoverTimeTopList_Exchange_Qingrenjie_Button[6] = LoverTimeTopList_Exchange_Item6_Get
	LoverTimeTopList_Exchange_Qingrenjie_Button[7] = LoverTimeTopList_Exchange_Item7_Get
	
	LoverTimeTopList_Exchange_Qingrenjie_Text[1] = LoverTimeTopList_Exchange_Item1_Text
	LoverTimeTopList_Exchange_Qingrenjie_Text[2] = LoverTimeTopList_Exchange_Item2_Text
	LoverTimeTopList_Exchange_Qingrenjie_Text[3] = LoverTimeTopList_Exchange_Item3_Text
	LoverTimeTopList_Exchange_Qingrenjie_Text[4] = LoverTimeTopList_Exchange_Item4_Text
	LoverTimeTopList_Exchange_Qingrenjie_Text[5] = LoverTimeTopList_Exchange_Item5_Text
	LoverTimeTopList_Exchange_Qingrenjie_Text[6] = LoverTimeTopList_Exchange_Item6_Text
	LoverTimeTopList_Exchange_Qingrenjie_Text[7] = LoverTimeTopList_Exchange_Item7_Text

	LoverTimeTopList_Exchange_Qingrenjie_Text2[1] = LoverTimeTopList_Exchange_Item2_Text2
	LoverTimeTopList_Exchange_Qingrenjie_Text2[2] = LoverTimeTopList_Exchange_Item2_Text2
	LoverTimeTopList_Exchange_Qingrenjie_Text2[3] = LoverTimeTopList_Exchange_Item2_Text2
	LoverTimeTopList_Exchange_Qingrenjie_Text2[4] = LoverTimeTopList_Exchange_Item2_Text2
	LoverTimeTopList_Exchange_Qingrenjie_Text2[5] = LoverTimeTopList_Exchange_Item2_Text2
	LoverTimeTopList_Exchange_Qingrenjie_Text2[6] = LoverTimeTopList_Exchange_Item2_Text2
	LoverTimeTopList_Exchange_Qingrenjie_Text2[7] = LoverTimeTopList_Exchange_Item2_Text2
end

--===============================================
-- OnEvent()
--===============================================
function LoverTimeTopList_OnEvent(event)
	if (event  == "UI_COMMAND") and (tonumber(arg0) == 892974) then
		--设置当前页
		local npage = Get_XParam_INT(0)
		if npage == 4 then
			--显示界面
			g_LoverTimeTopList_CurPage = npage
			g_LoverTimeTopList_Btn_Page[g_LoverTimeTopList_CurPage] : SetCheck(1)
			this:Show()
			LoverTimeTopList_Exchange_Qingrenjie_Update()
		else
			if npage < 1 or npage > 3 then
				return
			end
			g_LoverTimeTopList_CurPage = npage
			g_LoverTimeTopList_Btn_Page[g_LoverTimeTopList_CurPage] : SetCheck(1)
			--显示状态
			local state = Get_XParam_INT(1)
			if state ~= nil and state >= 0 then
				LoverTimeTopList_Rank_ShowState(state)
			end
			--显示倒计时
			local strTime = Get_XParam_STR(0)
			if strTime ~= nil then
				LoverTimeTopList_CountDown:SetText(strTime)
			end
		end
		
		--g_LoverTimeTopList_StateShow = Get_XParam_INT(2)
		--for i = 1, 3 do
			--g_LoverTimeTopList_Btn_PageImage[i]:Hide()
			--if i == g_LoverTimeTopList_StateShow then
			--	g_LoverTimeTopList_Btn_PageImage[i]:Show()
			--end
		--end
		
	elseif (event == "OPEN_QINGRENJIE_TOPLIST") then
		--显示排行榜
		LoverTimeTopList_Rank_ShowTopList()
		
	elseif (event == "REFRESH_QINGRENJIE_TOPLIST") then
		if tonumber(arg0) == 1 then
			--显示排行榜
			LoverTimeTopList_Rank_ShowTopList()
		else
			if this:IsVisible() then
				--显示排行榜
				LoverTimeTopList_Rank_ShowTopList()
			end
		end
		
	elseif (event == "ADJEST_UI_POS") then
		LoverTimeTopList_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		LoverTimeTopList_ResetPos()
		
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		LoverTimeTopList_Close_Click()
	end
end

--===============================================
-- 以下为界面更新显示
--===============================================
--显示排行榜状态
function LoverTimeTopList_Rank_ShowState(state)	
	g_LoverTimeTopList_State = state
end

--显示排行榜
function LoverTimeTopList_Rank_ShowTopList()
	--有效性判断
	if g_LoverTimeTopList_CurPage < 1 or g_LoverTimeTopList_CurPage > 3 then
		PushDebugMessage("当前页签不是排行榜")
		return
	end
	
	LoverTimeTopList_BK1:Show()
	LoverTimeTopList_BK2:Hide()
	if g_LoverTimeTopList_Btn_ImageList[g_LoverTimeTopList_CurPage] ~= nil then
		LoverTimeTopList_BK1Down:SetProperty("Image", g_LoverTimeTopList_Btn_ImageList[g_LoverTimeTopList_CurPage])
	end
	
	--显示界面
	this:Show()
	
	--隐藏兑奖
	LoverTimeTopList_Exchange_Frame:Hide()
	
	--显示排行榜
	LoverTimeTopList_Ranking_Frame:Show()
	
	--显示活动说明
	LoverTimeTopList_Explain_Text:SetText(g_LoverTimeTopList_Info[g_LoverTimeTopList_CurPage].desc)
	
	--显示送花相关信息
	--LoverTimeTopList_Ranking_Present_Title:SetText(g_LoverTimeTopList_Info[g_LoverTimeTopList_CurPage].sendtitle)
	local nSendNum =  DataPool:GetPlayerMission_DataRound(g_LoverTimeTopList_Info[g_LoverTimeTopList_CurPage].sendmd)
	local nNumStr = ScriptGlobal_Format(g_LoverTimeTopList_Info[g_LoverTimeTopList_CurPage].strsendNum, nSendNum)
	LoverTimeTopList_Ranking_Present_Rose:SetText(nNumStr)
	
	--显示收花数量
	--LoverTimeTopList_Ranking_Receive_Title:SetText(g_LoverTimeTopList_Info[g_LoverTimeTopList_CurPage].receivetitle)
	local nReceiveNum =  DataPool:GetPlayerMission_DataRound(g_LoverTimeTopList_Info[g_LoverTimeTopList_CurPage].receivemd)
	local nReceiveNumStr = ScriptGlobal_Format(g_LoverTimeTopList_Info[g_LoverTimeTopList_CurPage].strreceiveNum, nReceiveNum)
	LoverTimeTopList_Ranking_Receive_Rose:SetText(nReceiveNumStr)

	LoverTimeTopList_Ranking_Present_ListContent:Clear()
	
	local MyInfoS = 0
	local MyInfoR = 0
	--显示榜单
	local strDefName = LoverTimeTopList_Rank_DefaultName()
	for i=1, g_LoverTimeTopList_Count do
		local bar = LoverTimeTopList_Ranking_Present_ListContent:AddChild("LoverTimeTopList_Ranking_Present_List_CoinAItem")
		
		local strN = ScriptGlobal_Format("#{QRZM_211119_97}", i)
		bar:GetSubItem("LoverTimeTopList_Ranking_Present_List_NumText"):SetText(strN)
				
		bar:GetSubItem("LoverTimeTopList_Ranking_Present_List_NameText"):SetText(strDefName)
				
		bar:GetSubItem("LoverTimeTopList_Ranking_Present_List_Num"):SetText("")	
			
		--更新数据
		local index,guid,name,score = DataPool:Lua_GetQingRenJieSendTopListInfo(i-1)
		if index ~= nil and index >= 0 and name ~= "" then
			local strname = ScriptGlobal_Format("#{QRZM_211119_98}", name)
			bar:GetSubItem("LoverTimeTopList_Ranking_Present_List_NameText"):SetText(strname)
			local scoreStr = ScriptGlobal_Format(g_LoverTimeTopList_Info[g_LoverTimeTopList_CurPage].strsend, tostring(score))
			bar:GetSubItem("LoverTimeTopList_Ranking_Present_List_Num"):SetText(scoreStr)	
			
			if Player:GetGUID() == guid then
				MyInfoS = index + 1
			end
		end	

		g_Present_BarList[i] = bar
	end
		
	LoverTimeTopList_Ranking_Receive_ListContent:Clear()
	for i=1, g_LoverTimeTopList_Count do
		local bar = LoverTimeTopList_Ranking_Receive_ListContent:AddChild("LoverTimeTopList_Ranking_Receive_List_CoinAItem")
			
		local strN = ScriptGlobal_Format("#{QRZM_211119_97}", i)
		bar:GetSubItem("LoverTimeTopList_Ranking_Receive_List_NumText"):SetText(strN)
			
		bar:GetSubItem("LoverTimeTopList_Ranking_Receive_List_NameText"):SetText(strDefName)
			
		bar:GetSubItem("LoverTimeTopList_Ranking_Receive_List_Num"):SetText("")	
		
		--更新数据
		local index,guid,name,score = DataPool:Lua_GetQingRenJieReceiveTopListInfo(i-1)
		if index ~= nil and index >= 0 and name ~= "" then
			local strname = ScriptGlobal_Format("#{QRZM_211119_98}", name)
			bar:GetSubItem("LoverTimeTopList_Ranking_Receive_List_NameText"):SetText(strname)
			local scoreStr = ScriptGlobal_Format(g_LoverTimeTopList_Info[g_LoverTimeTopList_CurPage].strreceive, tostring(score))
			bar:GetSubItem("LoverTimeTopList_Ranking_Receive_List_Num"):SetText(scoreStr)	
			
			if Player:GetGUID() == guid then
				MyInfoR = index + 1
			end
		end
		
		g_Receive_BarList[i] = bar
	end
	
	if MyInfoS > 0 then
		local str = ScriptGlobal_Format("#{QRZM_211119_103}", MyInfoS)
		LoverTimeTopList_Ranking_Present_MeNum:SetText(str)
	else
		LoverTimeTopList_Ranking_Present_MeNum:SetText("#{QRZM_211119_104}")	
	end
	
	if MyInfoR > 0 then
		local str = ScriptGlobal_Format("#{QRZM_211119_103}", MyInfoR)
		LoverTimeTopList_Ranking_Receive_MeNum:SetText(str)
	else
		LoverTimeTopList_Ranking_Receive_MeNum:SetText("#{QRZM_211119_104}")	
	end
	
end

--显示默认的名字
function LoverTimeTopList_Rank_DefaultName()
	local strMsg=""
	
	if g_LoverTimeTopList_State < 6 then 
		strMsg = "#{QRZM_211119_99}"
	elseif g_LoverTimeTopList_State >= 6 then 
		strMsg = "#{QRZM_211119_100}"	
	end
		
	return strMsg
end

--===============================================
-- 以下为事件响应
--===============================================
--点击关闭
function LoverTimeTopList_Close_Click()
	--关闭预览界面	
	if(IsWindowShow("LoverTimeTopListPreview")) then
		CloseWindow("LoverTimeTopListPreview", true)
	end
	--数据清空
	LoverTimeTopList_Clear()
	--界面隐藏
	this:Hide()
end

--点击页签
function LoverTimeTopList_Page_Click(index)
	--有效性判断
	if index <= 0 or index > g_LoverTimeTopList_MaxPage then
		PushDebugMessage("页签错误，请重新选择")
		return
	end
		
	if(IsWindowShow("LoverTimeTopListPreview")) then
		CloseWindow("LoverTimeTopListPreview", true)
	end
	
	local nPage = g_LoverTimeTopList_CurPage
	g_LoverTimeTopList_CurPage = index
	
	--页面内容更新
	if g_LoverTimeTopList_CurPage >= 1 and g_LoverTimeTopList_CurPage <= 3 then
		--刷新排行榜
		local flag = LoverTimeTopList_RankClick_Refresh()
		if flag == 0 and nPage >= 1 and nPage <= g_LoverTimeTopList_MaxPage then
			g_LoverTimeTopList_Btn_Page[nPage]:SetCheck(1)--切回原来页面
		end
	elseif g_LoverTimeTopList_CurPage == 4 then
		LoverTimeTopList_Exchange_Qingrenjie_Update()
	end
end

--点击刷新
function LoverTimeTopList_RankClick_Refresh()
	--有效性判断
	if g_LoverTimeTopList_CurPage < 1 or g_LoverTimeTopList_CurPage > 3 then
		PushDebugMessage("当前页签不是排行榜")
		return 0
	end
	--判断冷却时间
	local nCooldown = g_LoverTimeTopList_Cooldown[g_LoverTimeTopList_CurPage]
	local iCur = FindFriendDataPool:GetTickCount()
	if ( iCur - nCooldown < g_LoverTimeTopList_CooldownDur) then
		PushDebugMessage("#{QRZM_211119_163}")
	  return 0
	end
	g_LoverTimeTopList_Cooldown[g_LoverTimeTopList_CurPage] = iCur
	
	--请求服务器数据
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "ClientAskQingRenJieTopList" )
		Set_XSCRIPT_ScriptID( 892974 )
		Set_XSCRIPT_Parameter(0, g_LoverTimeTopList_CurPage)
		Set_XSCRIPT_Parameter(1, 1)
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()
	
	return 1
end

--点击送花榜领奖
function LoverTimeTopList_Prize_Present()

	--有效性判断
	if g_LoverTimeTopList_CurPage < 1 or g_LoverTimeTopList_CurPage > 3 then
		PushDebugMessage("当前页签不是排行榜")
		return
	end	
	
	--判断领奖时间
	if g_LoverTimeTopList_State == 0 then--理论上不存在
		PushDebugMessage(g_LoverTimeTopList_Tip[g_LoverTimeTopList_CurPage].tip1)
		return
	elseif g_LoverTimeTopList_State >= 1 and g_LoverTimeTopList_State <= 5 then--排行榜计时中
		PushDebugMessage(g_LoverTimeTopList_Tip[g_LoverTimeTopList_CurPage].tip2)
		return
	elseif g_LoverTimeTopList_State == 6 then--可以领奖
	else--理论上不存在
		PushDebugMessage(g_LoverTimeTopList_Tip[g_LoverTimeTopList_CurPage].tip3)
		return
	end
	
	--判断安全时间
	if (tonumber(DataPool:GetLeftProtectTime()) > 0) then
		return
	end
	
	--判断电话密保和二级密码保护
	if CheckPhoneMibaoAndMinorPassword() ~= 1 then	
		return
	end
	
	--领奖
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "GetQingRenJieSendTopListPrize" )
		Set_XSCRIPT_ScriptID( 892974 )
		Set_XSCRIPT_Parameter(0,g_LoverTimeTopList_CurPage)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()

end

--点击收花榜领奖
function LoverTimeTopList_Prize_Receive()

	--有效性判断
	if g_LoverTimeTopList_CurPage < 1 or g_LoverTimeTopList_CurPage > 3 then
		PushDebugMessage("当前页签不是排行榜")
		return
	end	
	
	--判断领奖时间
	if g_LoverTimeTopList_State == 0 then--理论上不存在
		PushDebugMessage(g_LoverTimeTopList_Tip[g_LoverTimeTopList_CurPage].tip1)
		return
	elseif g_LoverTimeTopList_State >= 1 and g_LoverTimeTopList_State <= 5 then--排行榜计时中
		PushDebugMessage(g_LoverTimeTopList_Tip[g_LoverTimeTopList_CurPage].tip2)
		return
	elseif g_LoverTimeTopList_State == 6 then--可以领奖
	else--理论上不存在
		PushDebugMessage(g_LoverTimeTopList_Tip[g_LoverTimeTopList_CurPage].tip3)
		return
	end
	
	--判断安全时间
	if (tonumber(DataPool:GetLeftProtectTime()) > 0) then
		return
	end
	
	--判断电话密保和二级密码保护
	if CheckPhoneMibaoAndMinorPassword() ~= 1 then	
		return
	end
	
	--领奖
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "GetQingRenJieReceiveTopListPrize" )
		Set_XSCRIPT_ScriptID( 892974 )
		Set_XSCRIPT_Parameter(0,g_LoverTimeTopList_CurPage)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()

end

--===============================================
-- 以下为基础函数
--===============================================
--状态清空
function LoverTimeTopList_Clear()
 	--当前页码清空
	g_LoverTimeTopList_CurPage = 0
	--活动状态清空
	g_LoverTimeTopList_State = -1
end

--重置位置
function LoverTimeTopList_ResetPos()
	LoverTimeTopList_Frame:SetProperty("UnifiedPosition",g_LoverTimeTopList_UnifiedPosition)
end

--奖励兑换窗口
function LoverTimeTopList_Exchange_Click(nIndex)
	if g_LoverTimeTopList_CurPage == 4 then
		LoverTimeTopList_Exchange_Qingrenjie_Click(nIndex)
	end
end

--情人结兑换奖励窗口
function LoverTimeTopList_Exchange_Qingrenjie_Update()
	LoverTimeTopList_Ranking_Frame:Hide()
	LoverTimeTopList_Exchange_Frame:Show()
	
	LoverTimeTopList_BK1:Hide()
	LoverTimeTopList_BK2:Show()
	
	LoverTimeTopList_Explain_Text:SetText( "#{QRZM_211119_165}" )

	for i = 1, table.getn(g_LoverTimeTopList_Qingrenjie_Bonus) do
		local theAction = DataPool:CreateBindActionItemForShow(g_LoverTimeTopList_Qingrenjie_Bonus[i].itemid, g_LoverTimeTopList_Qingrenjie_Bonus[i].count)
		if theAction:GetID() ~= 0 then
			LoverTimeTopList_Exchange_Qingrenjie_Action[i]:SetActionItem(theAction:GetID())
		end
		
		local strText = ScriptGlobal_Format("#{QRZM_211119_167}", g_LoverTimeTopList_Qingrenjie_Bonus[i].neednum)
		LoverTimeTopList_Exchange_Qingrenjie_Text[i]:SetText( strText )
		
		local nLimitNum = g_LoverTimeTopList_Qingrenjie_Bonus[i].LimitNum
		local nLimitMD = g_LoverTimeTopList_Qingrenjie_Bonus[i].LimitMD
		if nLimitMD > 0 and nLimitNum > 0 then
			local nLastNum = nLimitNum - DataPool:GetPlayerMission_DataRound(nLimitMD)
			if nLastNum <= 0 then
				nLastNum = 0
				
				local str = ScriptGlobal_Format("#{QRZM_211119_307}", nLastNum)
				LoverTimeTopList_Exchange_Qingrenjie_Text2[i]:SetText(str)
			else
				local str = ScriptGlobal_Format("#{QRZM_211119_305}", nLastNum)
				LoverTimeTopList_Exchange_Qingrenjie_Text2[i]:SetText(str)
			end
		end
	end
	
end

--情人结兑换奖励
function LoverTimeTopList_Exchange_Qingrenjie_Click(i)
	--local str = ScriptGlobal_Format("#{QRPHB_150113_194}", g_LoverTimeTopList_Qingrenjie_Bonus[i].neednum, g_LoverTimeTopList_Qingrenjie_Bonus[i].name)
	--PushEvent("QIXIRANK_EXCHANGE_CONFIRM", 1, i, str)
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "Qingrenjie_Exchange" )
		Set_XSCRIPT_ScriptID( 892974 )
		Set_XSCRIPT_Parameter(0, i)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
end

--打开元宝商店——花舞人间——春城百花
function LoverTimeTopList_BuyRose()
	LoverTimeTopList_Shop_Goto(0, 6, 5)
end

function LoverTimeTopList_Shop_Goto(Fenye, Tag, Shop)
	if(IsWindowShow("YuanbaoShop")) then
		CloseWindow("YuanbaoShop", true)
	end
	PushEvent("TOGGLE_YUANBAOSHOP", Fenye, -1, -1, Tag, Shop)
end

--奖励预览
function LoverTimeTopList_RankClick_Award()
	PushEvent("OPEN_QINGRENJIETOPLIST_ZHANSHI", 1, g_LoverTimeTopList_CurPage)
end

--说明
function LoverTimeTopList_HelpClicked()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "QingRenJieTopListHelp" )
		Set_XSCRIPT_ScriptID( 892974 )
		Set_XSCRIPT_Parameter(0, g_LoverTimeTopList_CurPage)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
end

