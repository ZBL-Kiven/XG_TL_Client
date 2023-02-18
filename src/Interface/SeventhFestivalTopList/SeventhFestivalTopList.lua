----------------------
-- SeventhFestivalTopList ---
----------------------
--����λ��
local g_SeventhFestivalTopList_UnifiedPosition = nil

--��ʱ��
local g_SeventhFestivalTopList_CooldownDur = 4*1000	--4s��ȴ
local g_SeventhFestivalTopList_Cooldown = 
{
	[1] = 0,
	[2] = 0,
	[3] = 0,
	[4] = 0,
}

local g_Present_BarList = {}
local g_Receive_BarList = {}

--ҳǩ��ʾ
local g_SeventhFestivalTopList_CurPage = 0--Ĭ����ʾҳǩ--ע��1-3��ʾ���а� 4-5��ʾ�һ�����
local g_SeventhFestivalTopList_MaxPage = 4--���ҳǩ��

--���а���ؿؼ�
local g_SeventhFestivalTopList_Btn_Page = {}
local g_SeventhFestivalTopList_Present_Name = {}
local g_SeventhFestivalTopList_Present_Score = {}
local g_SeventhFestivalTopList_Present_Winner = {}

local g_SeventhFestivalTopList_Btn_PageImage = {}

local g_SeventhFestivalTopList_Receive_Name = {}
local g_SeventhFestivalTopList_Receive_Score = {}
local g_SeventhFestivalTopList_Receive_Winner = {}

--�ϰ�����
local g_SeventhFestivalTopList_Count = 20

--�״̬
local g_SeventhFestivalTopList_State = -1
local g_SeventhFestivalTopList_StateShow = -1

--����Ϣ
local g_SeventhFestivalTopList_Info = --���޸�
{
	[1] = {desc = "#{QXHB_20210701_94}", count = 3, sendmd = 605, receivemd = 606, sendtitle = "#{QXHB_20210701_96}", receivetitle = "#{QXHB_20210701_115}", strsend = "#{QXHB_20210701_101}", strreceive = "#{QXHB_20210701_103}", strsendNum = "#{QXHB_20210701_105}", strreceiveNum = "#{QXHB_20210701_255}"},
	[2] = {desc = "#{QXHB_20210701_140}", count = 3, sendmd = 607, receivemd = 608, sendtitle = "#{QXHB_20210701_96}", receivetitle = "#{QXHB_20210701_115}", strsend = "#{QXHB_20210701_101}", strreceive = "#{QXHB_20210701_103}", strsendNum = "#{QXHB_20210701_105}", strreceiveNum = "#{QXHB_20210701_255}"},
	[3] = {desc = "#{QXHB_20210701_149}", count = 3, sendmd = 609, receivemd = 610, sendtitle = "#{QXHB_20210701_96}", receivetitle = "#{QXHB_20210701_115}", strsend = "#{QXHB_20210701_101}", strreceive = "#{QXHB_20210701_103}", strsendNum = "#{QXHB_20210701_105}", strreceiveNum = "#{QXHB_20210701_255}"},
}

--����Ϣ
local g_SeventhFestivalTopList_Tip = --���޸�
{
	[1] = {tip1 = "#{QXLS_150724_71}", tip2 = "#{QXLS_150724_72}", tip3 = "#{QXLS_150724_73}"},
	[2] = {tip1 = "#{QXLS_150724_71}", tip2 = "#{QXLS_150724_126}", tip3 = "#{QXLS_150724_73}"},
	[3] = {tip1 = "#{QXLS_150724_71}", tip2 = "#{QXLS_150724_127}", tip3 = "#{QXLS_150724_73}"},
}

local SeventhFestivalTopList_Exchange_Qingrenjie_Action = {}
local SeventhFestivalTopList_Exchange_Qingrenjie_Button = {}
local SeventhFestivalTopList_Exchange_Qingrenjie_Text = {}

g_SeventhFestivalTopList_Qingrenjie_Bonus =
{
	[1] = {neednum = 600, itemid = 10124290, count = 1, name = "�����ǳ"},
	[2] = {neednum = 600, itemid = 10124447, count = 1, name = "��������"},
	[3] = {neednum = 600, itemid = 10124479, count = 1, name = "��������"},
	[4] = {neednum = 600, itemid = 10124495, count = 1, name = "�������"},
	[5] = {neednum = 22, itemid = 30503140, count = 1, name = "��ҫʯ"},
	[6] = {neednum = 2400, itemid = 10124415, count = 1, name = "���Ų�ѩ"},
	[7] = {neednum = 1500, itemid = 30309988, count = 1, name = "��������������·��"},
	--[3] = {neednum = 1500, itemid = 10124463, count = 1, name = "��������"}, --
	--[6] = {neednum = 1500, itemid = 10124511, count = 1, name = "Ǿޱ֮��"}, --
}

--===============================================
-- PreLoad()
--===============================================
function SeventhFestivalTopList_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("OPEN_QIXI_TOPLIST")
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
end

--===============================================
-- OnLoad()
--===============================================
function SeventhFestivalTopList_OnLoad()
	g_SeventhFestivalTopList_UnifiedPosition = SeventhFestivalTopList_Frame:GetProperty("UnifiedPosition")
		
--���а���ؿؼ�
	g_SeventhFestivalTopList_Btn_Page[1]	= SeventhFestivalTopList_Top_TopList1
	g_SeventhFestivalTopList_Btn_Page[2]	= SeventhFestivalTopList_Top_TopList3
	g_SeventhFestivalTopList_Btn_Page[3]	= SeventhFestivalTopList_Top_TopList2
	g_SeventhFestivalTopList_Btn_Page[4]	= SeventhFestivalTopList_Top_TopList4
	
	g_SeventhFestivalTopList_Btn_PageImage[1] = SeventhFestivalTopList_ClientBK1
	g_SeventhFestivalTopList_Btn_PageImage[2] = SeventhFestivalTopList_ClientBK3
	g_SeventhFestivalTopList_Btn_PageImage[3] = SeventhFestivalTopList_ClientBK2
	
--���а�һ���ؿؼ�	
	SeventhFestivalTopList_Exchange_Qingrenjie_Action[1] = SeventhFestivalTopList_Exchange_Item1_Icon
	SeventhFestivalTopList_Exchange_Qingrenjie_Action[2] = SeventhFestivalTopList_Exchange_Item2_Icon
	SeventhFestivalTopList_Exchange_Qingrenjie_Action[3] = SeventhFestivalTopList_Exchange_Item3_Icon
	SeventhFestivalTopList_Exchange_Qingrenjie_Action[4] = SeventhFestivalTopList_Exchange_Item4_Icon
	SeventhFestivalTopList_Exchange_Qingrenjie_Action[5] = SeventhFestivalTopList_Exchange_Item5_Icon
	SeventhFestivalTopList_Exchange_Qingrenjie_Action[6] = SeventhFestivalTopList_Exchange_Item6_Icon
	SeventhFestivalTopList_Exchange_Qingrenjie_Action[7] = SeventhFestivalTopList_Exchange_Item7_Icon

	SeventhFestivalTopList_Exchange_Qingrenjie_Button[1] = SeventhFestivalTopList_Exchange_Item1_Get
	SeventhFestivalTopList_Exchange_Qingrenjie_Button[2] = SeventhFestivalTopList_Exchange_Item2_Get
	SeventhFestivalTopList_Exchange_Qingrenjie_Button[3] = SeventhFestivalTopList_Exchange_Item3_Get
	SeventhFestivalTopList_Exchange_Qingrenjie_Button[4] = SeventhFestivalTopList_Exchange_Item4_Get
	SeventhFestivalTopList_Exchange_Qingrenjie_Button[5] = SeventhFestivalTopList_Exchange_Item5_Get
	SeventhFestivalTopList_Exchange_Qingrenjie_Button[6] = SeventhFestivalTopList_Exchange_Item6_Get
	SeventhFestivalTopList_Exchange_Qingrenjie_Button[7] = SeventhFestivalTopList_Exchange_Item7_Get
	
	SeventhFestivalTopList_Exchange_Qingrenjie_Text[1] = SeventhFestivalTopList_Exchange_Item1_Text
	SeventhFestivalTopList_Exchange_Qingrenjie_Text[2] = SeventhFestivalTopList_Exchange_Item2_Text
	SeventhFestivalTopList_Exchange_Qingrenjie_Text[3] = SeventhFestivalTopList_Exchange_Item3_Text
	SeventhFestivalTopList_Exchange_Qingrenjie_Text[4] = SeventhFestivalTopList_Exchange_Item4_Text
	SeventhFestivalTopList_Exchange_Qingrenjie_Text[5] = SeventhFestivalTopList_Exchange_Item5_Text
	SeventhFestivalTopList_Exchange_Qingrenjie_Text[6] = SeventhFestivalTopList_Exchange_Item6_Text
	SeventhFestivalTopList_Exchange_Qingrenjie_Text[7] = SeventhFestivalTopList_Exchange_Item7_Text

end

--===============================================
-- OnEvent()
--===============================================
function SeventhFestivalTopList_OnEvent(event)
	if (event  == "UI_COMMAND") and (tonumber(arg0) == 891396) then
		--���õ�ǰҳ
		local npage = Get_XParam_INT(0)
		if npage == 4 then
			--��ʾ����
			g_SeventhFestivalTopList_CurPage = npage
			g_SeventhFestivalTopList_Btn_Page[g_SeventhFestivalTopList_CurPage] : SetCheck(1)
			this:Show()
			SeventhFestivalTopList_Exchange_Qingrenjie_Update()
		else
			if npage < 1 or npage > 3 then
				return
			end
			g_SeventhFestivalTopList_CurPage = npage
			g_SeventhFestivalTopList_Btn_Page[g_SeventhFestivalTopList_CurPage] : SetCheck(1)
			--��ʾ״̬
			local state = Get_XParam_INT(1)
			if state ~= nil and state >= 0 then
				SeventhFestivalTopList_Rank_ShowState(state)
			end
			--��ʾ����ʱ
			local strTime = Get_XParam_STR(0)
			if strTime ~= nil then
				SeventhFestivalTopList_CountDown:SetText(strTime)
			end
		end
		
		g_SeventhFestivalTopList_StateShow = Get_XParam_INT(2)
		for i = 1, 3 do
			g_SeventhFestivalTopList_Btn_PageImage[i]:Hide()
			if i == g_SeventhFestivalTopList_StateShow then
				g_SeventhFestivalTopList_Btn_PageImage[i]:Show()
			end
		end
		
	elseif (event == "OPEN_QIXI_TOPLIST") then
		--��ʾ���а�
		SeventhFestivalTopList_Rank_ShowTopList()
	elseif (event == "ADJEST_UI_POS") then
		SeventhFestivalTopList_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		SeventhFestivalTopList_ResetPos()
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		SeventhFestivalTopList_Close_Click()
	end
end

--===============================================
-- ����Ϊ���������ʾ
--===============================================
--��ʾ���а�״̬
function SeventhFestivalTopList_Rank_ShowState(state)	
	g_SeventhFestivalTopList_State = state
end

--��ʾ���а�
function SeventhFestivalTopList_Rank_ShowTopList()
	--��Ч���ж�
	if g_SeventhFestivalTopList_CurPage < 1 or g_SeventhFestivalTopList_CurPage > 3 then
		PushDebugMessage("��ǰҳǩ�������а�")
		return
	end
	
	--��ʾ����
	this:Show()
	
	--���ضҽ�
	SeventhFestivalTopList_Exchange_Frame:Hide()
	
	--��ʾ���а�
	SeventhFestivalTopList_Ranking_Frame:Show()
	
	--��ʾ�˵��
	SeventhFestivalTopList_Explain_Text:SetText(g_SeventhFestivalTopList_Info[g_SeventhFestivalTopList_CurPage].desc)
	
	--��ʾ�ͻ������Ϣ
	SeventhFestivalTopList_Ranking_Present_Title:SetText(g_SeventhFestivalTopList_Info[g_SeventhFestivalTopList_CurPage].sendtitle)
	local nSendNum =  DataPool:GetPlayerMission_DataRound(g_SeventhFestivalTopList_Info[g_SeventhFestivalTopList_CurPage].sendmd)
	local nNumStr = ScriptGlobal_Format(g_SeventhFestivalTopList_Info[g_SeventhFestivalTopList_CurPage].strsendNum, nSendNum)
	SeventhFestivalTopList_Ranking_Present_Rose:SetText(nNumStr)
	
	--��ʾ�ջ�����
	SeventhFestivalTopList_Ranking_Receive_Title:SetText(g_SeventhFestivalTopList_Info[g_SeventhFestivalTopList_CurPage].receivetitle)
	local nReceiveNum =  DataPool:GetPlayerMission_DataRound(g_SeventhFestivalTopList_Info[g_SeventhFestivalTopList_CurPage].receivemd)
	local nReceiveNumStr = ScriptGlobal_Format(g_SeventhFestivalTopList_Info[g_SeventhFestivalTopList_CurPage].strreceiveNum, nReceiveNum)
	SeventhFestivalTopList_Ranking_Receive_Rose:SetText(nReceiveNumStr)

	SeventhFestivalTopList_Ranking_Present_ListContent:Clear()
	
	local MyInfoS = 0
	local MyInfoR = 0
	--��ʾ��
	local strDefName = SeventhFestivalTopList_Rank_DefaultName()
	for i=1, g_SeventhFestivalTopList_Count do
		local bar = SeventhFestivalTopList_Ranking_Present_ListContent:AddChild("SeventhFestivalTopList_Ranking_Present_List_CoinAItem")
		
		local strN = ScriptGlobal_Format("#{QXHB_20210701_97}", i)
		bar:GetSubItem("SeventhFestivalTopList_Ranking_Present_List_NumText"):SetText(strN)
				
		bar:GetSubItem("SeventhFestivalTopList_Ranking_Present_List_NameText"):SetText(strDefName)
				
		bar:GetSubItem("SeventhFestivalTopList_Ranking_Present_List_Num"):SetText("")	
			
		--��������
		local index,guid,name,score = DataPool:Lua_GetQixiSendTopListInfo(i-1)
		if index ~= nil and index >= 0 and name ~= "" then
			local strname = ScriptGlobal_Format("#{QXHB_20210701_98}", name)
			bar:GetSubItem("SeventhFestivalTopList_Ranking_Present_List_NameText"):SetText(strname)
			local scoreStr = ScriptGlobal_Format(g_SeventhFestivalTopList_Info[g_SeventhFestivalTopList_CurPage].strsend, tostring(score))
			bar:GetSubItem("SeventhFestivalTopList_Ranking_Present_List_Num"):SetText(scoreStr)	
			
			if Player:GetGUID() == guid then
				MyInfoS = index + 1
			end
		end	

		g_Present_BarList[i] = bar
	end
		
	SeventhFestivalTopList_Ranking_Receive_ListContent:Clear()
	for i=1, g_SeventhFestivalTopList_Count do
		local bar = SeventhFestivalTopList_Ranking_Receive_ListContent:AddChild("SeventhFestivalTopList_Ranking_Receive_List_CoinAItem")
			
		local strN = ScriptGlobal_Format("#{QXHB_20210701_97}", i)
		bar:GetSubItem("SeventhFestivalTopList_Ranking_Receive_List_NumText"):SetText(strN)
			
		bar:GetSubItem("SeventhFestivalTopList_Ranking_Receive_List_NameText"):SetText(strDefName)
			
		bar:GetSubItem("SeventhFestivalTopList_Ranking_Receive_List_Num"):SetText("")	
		
		--��������
		local index,guid,name,score = DataPool:Lua_GetQixiReceiveTopListInfo(i-1)
		if index ~= nil and index >= 0 and name ~= "" then
			local strname = ScriptGlobal_Format("#{QXHB_20210701_98}", name)
			bar:GetSubItem("SeventhFestivalTopList_Ranking_Receive_List_NameText"):SetText(strname)
			local scoreStr = ScriptGlobal_Format(g_SeventhFestivalTopList_Info[g_SeventhFestivalTopList_CurPage].strreceive, tostring(score))
			bar:GetSubItem("SeventhFestivalTopList_Ranking_Receive_List_Num"):SetText(scoreStr)	
			
			if Player:GetGUID() == guid then
				MyInfoR = index + 1
			end
		end
		
		g_Receive_BarList[i] = bar
	end
	
	if MyInfoS > 0 then
		local str = ScriptGlobal_Format("#{QXHB_20210701_103}", MyInfoS)
		SeventhFestivalTopList_Ranking_Present_MeNum:SetText(str)
	else
		SeventhFestivalTopList_Ranking_Present_MeNum:SetText("#{QXHB_20210701_104}")	
	end
	
	if MyInfoR > 0 then
		local str = ScriptGlobal_Format("#{QXHB_20210701_103}", MyInfoR)
		SeventhFestivalTopList_Ranking_Receive_MeNum:SetText(str)
	else
		SeventhFestivalTopList_Ranking_Receive_MeNum:SetText("#{QXHB_20210701_104}")	
	end
	
end

--��ʾĬ�ϵ�����
function SeventhFestivalTopList_Rank_DefaultName()
	local strMsg=""
	
	if g_SeventhFestivalTopList_State < 6 then 
		strMsg = "#{QXHB_20210701_99}"
	elseif g_SeventhFestivalTopList_State >= 6 then 
		strMsg = "#{QXHB_20210701_100}"	
	end
		
	return strMsg
end

--===============================================
-- ����Ϊ�¼���Ӧ
--===============================================
--����ر�
function SeventhFestivalTopList_Close_Click()
	--�ر�Ԥ������	
	if(IsWindowShow("SeventhFestivalTopListPreview")) then
		CloseWindow("SeventhFestivalTopListPreview", true)
	end
	--�������
	SeventhFestivalTopList_Clear()
	--��������
	this:Hide()
end

--���ҳǩ
function SeventhFestivalTopList_Page_Click(index)
	--��Ч���ж�
	if index <= 0 or index > g_SeventhFestivalTopList_MaxPage then
		PushDebugMessage("ҳǩ����������ѡ��")
		return
	end
		
	if(IsWindowShow("SeventhFestivalTopListPreview")) then
		CloseWindow("SeventhFestivalTopListPreview", true)
	end
	
	local nPage = g_SeventhFestivalTopList_CurPage
	g_SeventhFestivalTopList_CurPage = index
	
	--ҳ�����ݸ���
	if g_SeventhFestivalTopList_CurPage >= 1 and g_SeventhFestivalTopList_CurPage <= 3 then
		--ˢ�����а�
		local flag = SeventhFestivalTopList_RankClick_Refresh()
		if flag == 0 and nPage >= 1 and nPage <= g_SeventhFestivalTopList_MaxPage then
			g_SeventhFestivalTopList_Btn_Page[nPage]:SetCheck(1)--�л�ԭ��ҳ��
		end
	elseif g_SeventhFestivalTopList_CurPage == 4 then
		SeventhFestivalTopList_Exchange_Qingrenjie_Update()
	end
end

--���ˢ��
function SeventhFestivalTopList_RankClick_Refresh()
	--��Ч���ж�
	if g_SeventhFestivalTopList_CurPage < 1 or g_SeventhFestivalTopList_CurPage > 3 then
		PushDebugMessage("��ǰҳǩ�������а�")
		return 0
	end
	--�ж���ȴʱ��
	local nCooldown = g_SeventhFestivalTopList_Cooldown[g_SeventhFestivalTopList_CurPage]
	local iCur = FindFriendDataPool:GetTickCount()
	if ( iCur - nCooldown < g_SeventhFestivalTopList_CooldownDur) then
		PushDebugMessage("#{QXHB_20210701_163}")
	  return 0
	end
	g_SeventhFestivalTopList_Cooldown[g_SeventhFestivalTopList_CurPage] = iCur
	
	--�������������
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "ClientAskQixiTopList" )
		Set_XSCRIPT_ScriptID( 891396 )--���޸Ľű��ţ�891396
		Set_XSCRIPT_Parameter(0,g_SeventhFestivalTopList_CurPage)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
	
	return 1
end

--����ͻ����콱
function SeventhFestivalTopList_Prize_Present()

	--��Ч���ж�
	if g_SeventhFestivalTopList_CurPage < 1 or g_SeventhFestivalTopList_CurPage > 3 then
		PushDebugMessage("��ǰҳǩ�������а�")
		return
	end	
	
	--�ж��콱ʱ��
	if g_SeventhFestivalTopList_State == 0 then--�����ϲ�����
		PushDebugMessage(g_SeventhFestivalTopList_Tip[g_SeventhFestivalTopList_CurPage].tip1)
		return
	elseif g_SeventhFestivalTopList_State >= 1 and g_SeventhFestivalTopList_State <= 5 then--���а��ʱ��
		PushDebugMessage(g_SeventhFestivalTopList_Tip[g_SeventhFestivalTopList_CurPage].tip2)
		return
	elseif g_SeventhFestivalTopList_State == 6 then--�����콱
	else--�����ϲ�����
		PushDebugMessage(g_SeventhFestivalTopList_Tip[g_SeventhFestivalTopList_CurPage].tip3)
		return
	end
	
	--�жϰ�ȫʱ��
	if (tonumber(DataPool:GetLeftProtectTime()) > 0) then
		return
	end
	
	--�жϵ绰�ܱ��Ͷ������뱣��
	if CheckPhoneMibaoAndMinorPassword() ~= 1 then	
		return
	end
	
	--�콱
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "ClientGetQixiSendTopListPrize" )
		Set_XSCRIPT_ScriptID( 891396 )--���޸Ľű��ţ�891396
		Set_XSCRIPT_Parameter(0,g_SeventhFestivalTopList_CurPage)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()

end

--����ջ����콱
function SeventhFestivalTopList_Prize_Receive()

	--��Ч���ж�
	if g_SeventhFestivalTopList_CurPage < 1 or g_SeventhFestivalTopList_CurPage > 3 then
		PushDebugMessage("��ǰҳǩ�������а�")
		return
	end	
	
	--�ж��콱ʱ��
	if g_SeventhFestivalTopList_State == 0 then--�����ϲ�����
		PushDebugMessage(g_SeventhFestivalTopList_Tip[g_SeventhFestivalTopList_CurPage].tip1)
		return
	elseif g_SeventhFestivalTopList_State >= 1 and g_SeventhFestivalTopList_State <= 5 then--���а��ʱ��
		PushDebugMessage(g_SeventhFestivalTopList_Tip[g_SeventhFestivalTopList_CurPage].tip2)
		return
	elseif g_SeventhFestivalTopList_State == 6 then--�����콱
	else--�����ϲ�����
		PushDebugMessage(g_SeventhFestivalTopList_Tip[g_SeventhFestivalTopList_CurPage].tip3)
		return
	end
	
	--�жϰ�ȫʱ��
	if (tonumber(DataPool:GetLeftProtectTime()) > 0) then
		return
	end
	
	--�жϵ绰�ܱ��Ͷ������뱣��
	if CheckPhoneMibaoAndMinorPassword() ~= 1 then	
		return
	end
	
	--�콱
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "ClientGetQixiReceiveTopListPrize" )
		Set_XSCRIPT_ScriptID( 891396 )--���޸Ľű��ţ�891396
		Set_XSCRIPT_Parameter(0,g_SeventhFestivalTopList_CurPage)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()

end

--===============================================
-- ����Ϊ��������
--===============================================
--״̬���
function SeventhFestivalTopList_Clear()
	--ȡ����ť��ѡ��״̬
 	--if g_SeventhFestivalTopList_CurPage >= 1 or g_SeventhFestivalTopList_CurPage <= 6 then
 		--g_RoseBtn_Page[g_SeventhFestivalTopList_CurPage]:SetCheck(0)
 	--end
 	--��ǰҳ�����
	g_SeventhFestivalTopList_CurPage = 0
	--�״̬���
	g_SeventhFestivalTopList_State = -1
end

--����λ��
function SeventhFestivalTopList_ResetPos()
	SeventhFestivalTopList_Frame:SetProperty("UnifiedPosition",g_SeventhFestivalTopList_UnifiedPosition)
end

--�����һ�����
function SeventhFestivalTopList_Exchange_Click(nIndex)
	if g_SeventhFestivalTopList_CurPage == 4 then
		SeventhFestivalTopList_Exchange_Qingrenjie_Click(nIndex)
	end
end

--���˽�һ���������
function SeventhFestivalTopList_Exchange_Qingrenjie_Update()
	SeventhFestivalTopList_Ranking_Frame:Hide()
	SeventhFestivalTopList_Exchange_Frame:Show()
	
	SeventhFestivalTopList_Explain_Text:SetText( "#{QXHB_20210701_165}" )

	for i = 1, table.getn(g_SeventhFestivalTopList_Qingrenjie_Bonus) do
		local theAction = DataPool:CreateBindActionItemForShow(g_SeventhFestivalTopList_Qingrenjie_Bonus[i].itemid, g_SeventhFestivalTopList_Qingrenjie_Bonus[i].count)
		if theAction:GetID() ~= 0 then
			SeventhFestivalTopList_Exchange_Qingrenjie_Action[i]:SetActionItem(theAction:GetID())
		end
		
		local strText = ScriptGlobal_Format("#{QXHB_20210701_167}", g_SeventhFestivalTopList_Qingrenjie_Bonus[i].neednum)
		--local strTips = ScriptGlobal_Format("#{QXLS_150724_104}", g_SeventhFestivalTopList_Qingrenjie_Bonus[i].neednum, g_SeventhFestivalTopList_Qingrenjie_Bonus[i].name)
		SeventhFestivalTopList_Exchange_Qingrenjie_Text[i]:SetText( strText )
		--SeventhFestivalTopList_Exchange_Qingrenjie_Text[i]:SetToolTip( strTips )
		--SeventhFestivalTopList_Exchange_Qingrenjie_Button[i]:SetToolTip( strTips )
	end
	
end

--���˽�һ�����
function SeventhFestivalTopList_Exchange_Qingrenjie_Click(i)
	--local str = ScriptGlobal_Format("#{QRPHB_150113_194}", g_SeventhFestivalTopList_Qingrenjie_Bonus[i].neednum, g_SeventhFestivalTopList_Qingrenjie_Bonus[i].name)
	--PushEvent("QIXIRANK_EXCHANGE_CONFIRM", 1, i, str)
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "Qingrenjie_Exchange" )
		Set_XSCRIPT_ScriptID( 891396 )
		Set_XSCRIPT_Parameter(0, i)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
end

--��Ԫ���̵ꡪ�������˼䡪�����ǰٻ�
function SeventhFestivalTopList_BuyRose()
	SeventhFestivalTopList_Shop_Goto(0, 6, 5)
end

function SeventhFestivalTopList_Shop_Goto(Fenye, Tag, Shop)
	if(IsWindowShow("YuanbaoShop")) then
		CloseWindow("YuanbaoShop", true)
	end
	PushEvent("TOGGLE_YUANBAOSHOP", Fenye, -1, -1, Tag, Shop)
end

--����Ԥ��
function SeventhFestivalTopList_RankClick_Award()
	PushEvent("OPEN_QIXITOPLIST_ZHANSHI", 1, g_SeventhFestivalTopList_CurPage)
end

--˵��
function SeventhFestivalTopList_HelpClicked()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "SeventhFestivalTopListHelp" )
		Set_XSCRIPT_ScriptID( 891396 )
		Set_XSCRIPT_Parameter(0, g_SeventhFestivalTopList_CurPage)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
end

