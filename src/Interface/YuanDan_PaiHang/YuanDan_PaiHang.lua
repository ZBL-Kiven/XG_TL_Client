----------------------
-- 2022Ԫ��ͶƱ
----------------------

local g_UnifiedPosition = nil

--��עnpc
local MAX_OBJ_DISTANCE = 3.0
local objCared = -1
local npcObjId = -1

--ͶƱ��ʾ
local g_VoteCtrl = {}
local g_Images =
{
	[0] = {"set:YuanDan_PaiHang image:YuanDan_PaiHang_R_0","set:YuanDan_PaiHang image:YuanDan_PaiHang_B_0",},
	[1] = {"set:YuanDan_PaiHang image:YuanDan_PaiHang_R_1","set:YuanDan_PaiHang image:YuanDan_PaiHang_B_1",},
	[2] = {"set:YuanDan_PaiHang image:YuanDan_PaiHang_R_2","set:YuanDan_PaiHang image:YuanDan_PaiHang_B_2",},
	[3] = {"set:YuanDan_PaiHang image:YuanDan_PaiHang_R_3","set:YuanDan_PaiHang image:YuanDan_PaiHang_B_3",},
	[4] = {"set:YuanDan_PaiHang image:YuanDan_PaiHang_R_4","set:YuanDan_PaiHang image:YuanDan_PaiHang_B_4",},
	[5] = {"set:YuanDan_PaiHang image:YuanDan_PaiHang_R_5","set:YuanDan_PaiHang image:YuanDan_PaiHang_B_5",},
	[6] = {"set:YuanDan_PaiHang image:YuanDan_PaiHang_R_6","set:YuanDan_PaiHang image:YuanDan_PaiHang_B_6",},
	[7] = {"set:YuanDan_PaiHang image:YuanDan_PaiHang_R_7","set:YuanDan_PaiHang image:YuanDan_PaiHang_B_7",},
	[8] = {"set:YuanDan_PaiHang image:YuanDan_PaiHang_R_8","set:YuanDan_PaiHang image:YuanDan_PaiHang_B_8",},
	[9] = {"set:YuanDan_PaiHang image:YuanDan_PaiHang_R_9","set:YuanDan_PaiHang image:YuanDan_PaiHang_B_9",},
}

--�ۻ�����
local g_PrizeCtrl = {}
local g_PrizeData =
{
	[1] = { count = 2, itemid = 38000119, },
	[2] = { count = 5, itemid = 38000120, },
	[3] = { count = 8, itemid = 38000121, },
}

--===============================================
-- PreLoad()
--===============================================
function YuanDan_PaiHang_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	this:RegisterEvent("OBJECT_CARED_EVENT",false)
end

--===============================================
-- OnLoad()
--===============================================
function YuanDan_PaiHang_OnLoad()
	g_UnifiedPosition = YuanDan_PaiHang_Frame:GetProperty("UnifiedPosition")	
	g_VoteCtrl = 
	{
		[1] = {YuanDan_PaiHang_No6_L,YuanDan_PaiHang_No5_L,YuanDan_PaiHang_No4_L,YuanDan_PaiHang_No3_L,YuanDan_PaiHang_No2_L,YuanDan_PaiHang_No1_L,},
		[2] = {YuanDan_PaiHang_No6_R,YuanDan_PaiHang_No5_R,YuanDan_PaiHang_No4_R,YuanDan_PaiHang_No3_R,YuanDan_PaiHang_No2_R,YuanDan_PaiHang_No1_R,},
	}
	g_PrizeCtrl = 
	{
		[1] = {btn = YuanDan_PaiHang_Item1, flag = YuanDan_PaiHang_ItemOK1, },
		[2] = {btn = YuanDan_PaiHang_Item2, flag = YuanDan_PaiHang_ItemOK2, },
		[3] = {btn = YuanDan_PaiHang_Item3, flag = YuanDan_PaiHang_ItemOK3, },
	}
end

--===============================================
-- OnEvent()
--===============================================
function YuanDan_PaiHang_OnEvent(event)
	if (event  == "UI_COMMAND") and (tonumber(arg0) == 89294711) then
		local objid = Get_XParam_INT(0)
		if objid == nil or objid < 0 then
			-- �ؽ���
			if this:IsVisible() then
				YuanDan_PaiHang_OnClose()
			end
		else
			-- ��עnpc
			npcObjId = objid
			objCared = DataPool : GetNPCIDByServerID(tonumber(objid))
			this:CareObject(objCared, 1, "YuanDan_PaiHang")
			-- ������
			local nGData1 = Get_XParam_INT(1)
			local nGData2 = Get_XParam_INT(2)
			local nData = Get_XParam_INT(3)
			local bFlag1 = Get_XParam_INT(4)
			local bFlag2 = Get_XParam_INT(5)
			local bFlag3 = Get_XParam_INT(6)
			local bResult = Get_XParam_INT(7)
			local nFlag1 = Get_XParam_INT(8)
			local nFlag2 = Get_XParam_INT(9)
			local nIndex = Get_XParam_INT(10)
			YuanDan_PaiHang_Open(nGData1,nGData2,nData,bFlag1,bFlag2,bFlag3,bResult,nFlag1,nFlag2,nIndex)
		end
	elseif (event == "ADJEST_UI_POS") then
		YuanDan_PaiHang_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		YuanDan_PaiHang_ResetPos()
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		YuanDan_PaiHang_OnClose()
	elseif ( event == "OBJECT_CARED_EVENT" ) then
		if(tonumber(arg0) ~= objCared) then
			return
		end
		-- �����NPC�ľ������һ��������߱�ɾ�����Զ��ر�
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			-- �رս���
			YuanDan_PaiHang_OnClose()
		end	
	end
end

--===============================================
-- ����
--===============================================
function YuanDan_PaiHang_ResetPos()
	YuanDan_PaiHang_Frame:SetProperty("UnifiedPosition",g_UnifiedPosition)
end

--===============================================
-- ������
--===============================================
function YuanDan_PaiHang_Clear()
	-- ȡ������
	this:CareObject(objCared, 0, "YuanDan_PaiHang")
	npcObjId = -1
end

--===============================================
-- �ؽ���
--===============================================
function YuanDan_PaiHang_OnClose()
	--�������
	YuanDan_PaiHang_Clear()
	--���ؽ���
	this:Hide()
end

--===============================================
-- ������
--===============================================
function YuanDan_PaiHang_Open(nGData1,nGData2,nData,bFlag1,bFlag2,bFlag3,bResult,nFlag1,nFlag2,nIndex)
	--��ʾ����
	this:Show()
	--ͶƱ��ʾ
	YuanDan_PaiHang_ShowVote(1,nGData1)
	YuanDan_PaiHang_ShowVote(2,nGData2)	
	--ͶƱ���
	if bResult == 1 then
		YuanDan_PaiHang_Niu_Win:Show()
		YuanDan_PaiHang_Ji_Win:Hide()
	elseif bResult == 2 then
		YuanDan_PaiHang_Niu_Win:Hide()
		YuanDan_PaiHang_Ji_Win:Show()
	else
		YuanDan_PaiHang_Niu_Win:Hide()
		YuanDan_PaiHang_Ji_Win:Hide()
	end
	--ͶƱ��ť
	YuanDan_PaiHang_Niu_Btn:Enable()
	if nFlag1 == 1 then
		YuanDan_PaiHang_Niu_Btn:Disable()
	end
	YuanDan_PaiHang_Ji_Btn:Enable()
	if nFlag2 == 1 then
		YuanDan_PaiHang_Ji_Btn:Disable()
	end
	--ͶƱЧ��
	if nIndex == 1 then
		YuanDan_PaiHang_R_Animate:Show()
		YuanDan_PaiHang_R_Animate:Play(true)
	elseif nIndex == 2 then
		YuanDan_PaiHang_B_Animate:Show()
		YuanDan_PaiHang_B_Animate:Play(true)
	else
		YuanDan_PaiHang_R_Animate:Hide()
		YuanDan_PaiHang_R_Animate:Play(false)
		YuanDan_PaiHang_B_Animate:Hide()
		YuanDan_PaiHang_B_Animate:Play(false)
	end
	--������ʾ
	local bFlag = {bFlag1,bFlag2,bFlag3}
	YuanDan_PaiHang_LeiJiCiShu:SetText( ScriptGlobal_Format("#{YDPHB_20211111_08}",nData) )
	for i=1,table.getn(g_PrizeData) do
		local theAction = DataPool:CreateActionItemForShow(g_PrizeData[i].itemid, 1)
		if theAction:GetID() ~= 0 then
			g_PrizeCtrl[i].btn:SetActionItem(theAction:GetID())
			if bFlag[i] == 1 then
				g_PrizeCtrl[i].flag:Show()
			else
				g_PrizeCtrl[i].flag:Hide()
			end
		end
	end
end

--===============================================
-- ��ʾƱ��
--===============================================
function YuanDan_PaiHang_ShowVote(nIndex,nData)
	if nIndex == nil then
		return
	end
	local tVoteCtrl = g_VoteCtrl[nIndex]
	if tVoteCtrl == nil then
		return
	end
	for i = 1, table.getn(tVoteCtrl) do
		tVoteCtrl[i]:Hide()
	end
	--0Ʊ��д
	if nData == nil or nData <= 0 then
		tVoteCtrl[1]:SetProperty("Image", g_Images[0][nIndex])
		tVoteCtrl[1]:Show()
		return
	end
	--����λ��ʾ
	local ctrlIndex = 1--Ĭ�ϸ�λ
	while nData > 0 do
		local imageIndex = math.mod(nData, 10)--��ĩλ
		tVoteCtrl[ctrlIndex]:SetProperty("Image", g_Images[imageIndex][nIndex])
		tVoteCtrl[ctrlIndex]:Show()
		nData = math.floor(nData/10)
		ctrlIndex = ctrlIndex+1
	end
end

--===============================================
-- ͶƱ
--===============================================
function YuanDan_PaiHang_VoteClicked(nIndex)
	if nIndex == nil then
		return
	end
	if g_VoteCtrl[nIndex] == nil then
		return
	end
	Clear_XSCRIPT()
		Set_XSCRIPT_ScriptID(892947)
		Set_XSCRIPT_Function_Name("OnVote")
		Set_XSCRIPT_Parameter(0, npcObjId)
		Set_XSCRIPT_Parameter(1, nIndex)
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()
end

--===============================================
-- �콱
--===============================================
function YuanDan_PaiHang_PrizeClicked(nIndex)
	if nIndex == nil then
		return
	end
	if g_PrizeCtrl[nIndex] == nil then
		return
	end
	Clear_XSCRIPT()
		Set_XSCRIPT_ScriptID(892947)
		Set_XSCRIPT_Function_Name("OnPrize")
		Set_XSCRIPT_Parameter(0, npcObjId)
		Set_XSCRIPT_Parameter(1, nIndex)
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()
end

