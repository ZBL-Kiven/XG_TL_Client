------------------------------------
-- 2022����Ԥ�Ȼ
-- �����
------------------------------------

local g_Frame_UnifiedPosition

--��עnpc
local MAX_OBJ_DISTANCE = 5.0
local objCared = -1
local npcObjId = -1

--����
local g_CtrlList = {}
local g_ItemList = {38002489,38002490,38002491}

--================================================
-- PreLoad()
--================================================
function ZhenShou_HuoDong_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	-- ��Ϸ���ڳߴ緢���˱仯
	this:RegisterEvent("ADJEST_UI_POS")
	-- ��Ϸ�ֱ��ʷ����˱仯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")	
	this:RegisterEvent("PLAYER_LEAVE_WORLD");	
	this:RegisterEvent("OBJECT_CARED_EVENT",false)
end

--================================================
-- OnLoad()
--================================================
function ZhenShou_HuoDong_OnLoad()
	g_Frame_UnifiedPosition = ZhenShou_HuoDong_Frame:GetProperty("UnifiedPosition");
		
	g_CtrlList = 
	{
		[1] = {bk1=ZhenShou_HuoDong_1BK_1,bk2=ZhenShou_HuoDong_1BK_2,btn=ZhenShou_HuoDong_1BK_Btn,finish=ZhenShou_HuoDong_1BK_Btn_D,item=ZhenShou_HuoDong_Item1,},
		[2] = {bk1=ZhenShou_HuoDong_2BK_1,bk2=ZhenShou_HuoDong_2BK_2,btn=ZhenShou_HuoDong_2BK_Btn,finish=ZhenShou_HuoDong_2BK_Btn_D,item=ZhenShou_HuoDong_Item2,},
		[3] = {bk1=ZhenShou_HuoDong_3BK_1,bk2=ZhenShou_HuoDong_3BK_2,btn=ZhenShou_HuoDong_3BK_Btn,finish=ZhenShou_HuoDong_3BK_Btn_D,item=ZhenShou_HuoDong_Item3,},
	}
	
end

--================================================
-- �ָ������Ĭ�����λ��
--================================================
function ZhenShou_HuoDong_ResetPos()
	ZhenShou_HuoDong_Frame:SetProperty("UnifiedPosition", g_Frame_UnifiedPosition);
end

--================================================
-- OnEvent()
--================================================
function ZhenShou_HuoDong_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == 89306903 ) then
		local objid = Get_XParam_INT(0)
		if objid == nil or objid < 0 then
			-- �رս���
			if this:IsVisible() then
				ZhenShou_HuoDong_Close()
			end
		else
			-- ��עnpc
			npcObjId = objid
			objCared = DataPool : GetNPCIDByServerID(tonumber(objid))
			this:CareObject(objCared, 1, "ZhenShou_HuoDong")
			local bUpdate = Get_XParam_INT(1)
			local nData = Get_XParam_INT(2)
			local bFlag1 = Get_XParam_INT(3)
			local bFlag2 = Get_XParam_INT(4)
			local bFlag3 = Get_XParam_INT(5)
			if bUpdate == 1 then--��ˢ��
				if this:IsVisible() then
					ZhenShou_HuoDong_Update(nData,bFlag1,bFlag2,bFlag3)
				end
			else--��+ˢ��
				-- �򿪽���
				this:Show()
				ZhenShou_HuoDong_Update(nData,bFlag1,bFlag2,bFlag3)
			end
		end
	-- ��Ϸ���ڳߴ緢���˱仯
	elseif (event == "ADJEST_UI_POS" ) then
		ZhenShou_HuoDong_ResetPos()
	-- ��Ϸ�ֱ��ʷ����˱仯
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		ZhenShou_HuoDong_ResetPos()
	elseif (event == "PLAYER_LEAVE_WORLD" and this:IsVisible()) then
		ZhenShou_HuoDong_Close()
	elseif ( event == "OBJECT_CARED_EVENT" ) then
		if(tonumber(arg0) ~= objCared) then
			return
		end
		-- �����NPC�ľ������һ��������߱�ɾ�����Զ��ر�
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			-- �رս���
			ZhenShou_HuoDong_Close()
		end
	end
end

--================================================
-- OnHiden()
--================================================
function ZhenShou_HuoDong_OnHiden()
	-- ȡ������
	this:CareObject(objCared, 0, "ZhenShou_HuoDong")
	npcObjId = -1
end

--================================================
-- �رս���
--================================================
function ZhenShou_HuoDong_Close()
	ZhenShou_HuoDong_OnHiden()
	this:Hide()
end

--================================================
-- ���½���
--================================================
function ZhenShou_HuoDong_Update(nData,bFlag1,bFlag2,bFlag3)
	if nData == nil or nData < 0 then return end
	--��ʾ����
	ZhenShou_HuoDong_Num:SetText( ScriptGlobal_Format("#{ZSYR_211227_25}",nData) )
	--��ʾ����
	local bFlag = {bFlag1,bFlag2,bFlag3}--��ɱ��
	for i=1,table.getn(g_CtrlList) do
		--������ʾ
		local theAction = DataPool:CreateActionItemForShow(g_ItemList[i], 1)
		if theAction:GetID() ~= 0 then
			g_CtrlList[i].item:SetActionItem(theAction:GetID())
		end
		--������ʾ
		if i <= nData then--�ѿ���
			g_CtrlList[i].bk1:Show()
			g_CtrlList[i].bk2:Hide()
			if bFlag[i] > 0 then--�����
				g_CtrlList[i].btn:Hide()
				g_CtrlList[i].finish:Show()
			else--δ���
				g_CtrlList[i].btn:Show()
				g_CtrlList[i].finish:Hide()
			end
		else--δ����
			g_CtrlList[i].bk1:Hide()
			g_CtrlList[i].bk2:Show()
		end
	end	
end

--================================================
-- ���Ѱ������
--================================================
function ZhenShou_HuoDong_BtnClicked()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnAccept")
		Set_XSCRIPT_ScriptID(893065)
		Set_XSCRIPT_Parameter(0,npcObjId)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
end

--================================================
-- �����ȡ����
--================================================
function ZhenShou_HuoDong_Clicked(nIndex)
	if nIndex == 1 then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("OnAccept")
			Set_XSCRIPT_ScriptID(893066)
			Set_XSCRIPT_Parameter(0,npcObjId)
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
	elseif nIndex == 2 then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("OnAccept")
			Set_XSCRIPT_ScriptID(893067)
			Set_XSCRIPT_Parameter(0,npcObjId)
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
	elseif nIndex == 3 then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("OnAccept")
			Set_XSCRIPT_ScriptID(893068)
			Set_XSCRIPT_Parameter(0,npcObjId)
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
	end
end
