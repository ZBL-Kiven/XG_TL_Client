-- HunbingzhuCompound �����ϳ� 2021-10-13 lishilong
-- !!!reloadscript =HunbingzhuCompound
--

local g_HunbingzhuCompound_Frame_UnifiedPosition
local MAX_OBJ_DISTANCE 		= 3.0
local g_nObjCaredIDClient 	= -1
local g_nServerObjID 		= -1
local bCaredItem 			= 1
local bCaredObj 			= 1
local bCaredMoney 			= 1
local bCaredYuanBao			= 0
local g_nComfirmParam1		= 0

local g_nUICommandID		= 79007501
local g_nUICommandIDComfirm	= 79007502

local g_nCurSelectedPage	= 1
local g_nCurSelectedIndex	= 1

local g_controlPageButton	= {}
local g_controlIndexButton	= {}

-- ���ʯ
local g_tableHunBingItemID = 
{
	20310117,	--����飨1����
	20310118,	--����飨2����
	20310119,	--����飨3����
	20310120,	--����飨4����
	20310121,	--����飨5����
}

-- �󶨻��ʯ
local g_tableHunBingBindItemID = 
{
	20310161,	--����飨1����
	20310162,	--����飨2����
	20310163,	--����飨3����
	20310164,	--����飨4����
	20310165,	--����飨5����
}

-- ��������ĵ�������
local g_tableCommonCostItemNum	= {5, 5, 5, 5}
local g_tableQuickCostItemNum 	= {5, 25, 125, 625}

-- ��������Ľ�Ǯ
local g_tableCommonCostMoney 	= {5000 , 5000, 10000, 10000 }
local g_tableQuickCostMoney 	= {5000 , 30000, 160000, 810000 }

--=========================================================
-- PreLoad
--=========================================================
function HunbingzhuCompound_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("OBJECT_CARED_EVENT")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
	if 1 == bCaredItem then
		this:RegisterEvent("PACKAGE_ITEM_CHANGED")
	end
	if 1 == bCaredMoney then
		this:RegisterEvent("UNIT_MONEY")
		this:RegisterEvent("MONEYJZ_CHANGE")
	end
	if 1 == bCaredYuanBao then
		this:RegisterEvent("UPDATE_YUANBAO")
	end
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

--=========================================================
-- OnLoad
--=========================================================
function HunbingzhuCompound_OnLoad()
	g_HunbingzhuCompound_Frame_UnifiedPosition = HunbingzhuCompoundFrame:GetProperty("UnifiedPosition")

	-- HunbingzhuCompound_OK_Button : SetEvent("Clicked", "HunbingzhuCompound_ConfirmClick()")

	g_controlPageButton[1] 		= HunbingzhuCompound_YeQian01
	g_controlPageButton[2] 		= HunbingzhuCompound_YeQian02

	g_controlIndexButton[1] 	= HunbingzhuCompound_2
	g_controlIndexButton[2] 	= HunbingzhuCompound_3
	g_controlIndexButton[3] 	= HunbingzhuCompound_4
	g_controlIndexButton[4] 	= HunbingzhuCompound_5
end

--=========================================================
-- OnEvent
--=========================================================
function HunbingzhuCompound_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == g_nUICommandID ) then
		-- 0 �ر�, 1 ��, 2 ˢ��, 3 ����ȷ�Ͽ�
		local nOpType 	= Get_XParam_INT(0)

		-- �رս���
		if 0 == nOpType then	
			if this:IsVisible() then
				HunbingzhuCompound_OnClose()
			end
		end

		-- �򿪽���
		if 1 == nOpType then
			-- ��עnpc
			if 1 == bCaredObj then
				local nServerObjID 	= Get_XParam_INT(1)
				if nServerObjID == nil or nServerObjID < 0 then
					if this:IsVisible() then
						HunbingzhuCompound_OnClose()
					end
				end
				g_nServerObjID = nServerObjID
				g_nObjCaredIDClient = DataPool : GetNPCIDByServerID(tonumber(nServerObjID))
				BeginCareObject_HunbingzhuCompound()
			end

			-- ��ʾ����
			-- Ϊ�˽�����汻�ڵ������⣬�Ȱѽ������
			-- if this:IsVisible() then
			-- 	HunbingzhuCompound_OnClose()
			-- end
			HunbingzhuCompound_Reset()
			HunbingzhuCompound_Frame_On_ResetPos()
			this:Show()
			HunbingzhuCompound_ParamInit()
			HunbingzhuCompound_MoneyUpdate()
			HunbingzhuCompound_YuanBaoUpdate()
			HunbingzhuCompound_Update(1)
		end
			
		-- ˢ�½���
		if 2 == nOpType then
			-- ��עnpc
			if 1 == bCaredObj then
				local nServerObjID 	= Get_XParam_INT(1)
				if nServerObjID == nil or nServerObjID < 0 then
					if this:IsVisible() then
						HunbingzhuCompound_OnClose()
					end
				end
			end
			if this:IsVisible() then
				HunbingzhuCompound_ParamInit()
				HunbingzhuCompound_Update(0)
			end
		end

		-- ����ȷ�Ͽ�
		if 3 == nOpType then
			-- local strMsg = Get_XParam_STR(0)
			-- g_nComfirmParam1 = Get_XParam_INT(1)
			-- ["Type"] "Ok" "YesNo"
			-- MessageBoxSelf3("HunbingzhuCompound_OnComfirmedBack", {["Content"] = strMsg,["Type"] = "YesNo", })
		end

	-- ============================================
	-- ͨ���߼�
	elseif ( event == "OBJECT_CARED_EVENT" ) and 1 == bCaredObj then
		if(tonumber(arg0) ~= g_nObjCaredIDClient) then
			return
		end
		-- �����NPC�ľ������һ��������߱�ɾ�����Զ��ر�
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			-- �رս���
			HunbingzhuCompound_OnClose()
		end	

	-- ��Ʒ�ı�
	elseif ( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() and 1 == bCaredItem ) then
		-- ˢ�½���
		if this:IsVisible() then
			HunbingzhuCompound_Update(0)
		end

	-- ��Ǯ�ı�
	elseif (event == "UNIT_MONEY" or event == "MONEYJZ_CHANGE") and 1 == bCaredMoney then
		HunbingzhuCompound_MoneyUpdate()

	-- Ԫ���ı�
	elseif event == "UPDATE_YUANBAO" and 1 == bCaredYuanBao then
		HunbingzhuCompound_YuanBaoUpdate()

	elseif event == "HIDE_ON_SCENE_TRANSED" then
		HunbingzhuCompound_OnClose()
	
	elseif (event == "ADJEST_UI_POS" ) then
		HunbingzhuCompound_Frame_On_ResetPos()

	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		HunbingzhuCompound_Frame_On_ResetPos()
	end
end

--=========================================================
-- ���������ʼ��
--=========================================================
function HunbingzhuCompound_ParamInit()

end

--=========================================================
-- ����ȷ�Ͽ�ص� ["Type"] "Ok"�ķ���ֵ��"Ok"�� ["Type"] "YesNo"�ķ���ֵ�� "Yes" "No"
--=========================================================
function HunbingzhuCompound_OnComfirmedBack(strRet)
	if nil == strRet then
		return
	end

	if "Yes" == strRet or "Ok" == strRet then
		-- HunbingzhuCompound_ConfirmClick(1)
	end

	if "No" == strRet then
		
	end
end

--=========================================================
-- �������
--=========================================================
-- !!!reloadscript =HunbingzhuCompound
function HunbingzhuCompound_Update(bOpen)

	if g_nCurSelectedPage < 1 or g_nCurSelectedPage > 2 then
		HunbingzhuCompound_OnClose()	
		return
	end

	if g_nCurSelectedIndex < 1 or g_nCurSelectedIndex > 4 then
		HunbingzhuCompound_OnClose()	
		return
	end

	-- ҳǩ
	if 2 == g_nCurSelectedPage then
		g_controlPageButton[1] : SetCheck(0)
		g_controlPageButton[2] : SetCheck(1)
		HunbingzhuCompound_ExplainInfo : SetText( "#{HBZHC_210923_35}" )
	else
		g_controlPageButton[1] : SetCheck(1)
		g_controlPageButton[2] : SetCheck(0)
		HunbingzhuCompound_ExplainInfo : SetText( "#{HBZHC_210923_4}" )
	end

	-- ѡ��ť 
	for i = 1, table.getn(g_controlIndexButton) do
		g_controlIndexButton[i] : SetCheck(0)
	end

	g_controlIndexButton[g_nCurSelectedIndex] : SetCheck(1)

	-- �Ҳ���ʾ
	-- �Ҳ�����ϳ���ʾ����
	local nTargetLevel =  g_nCurSelectedIndex + 1
	HunbingzhuCompound_ChoiceInfo : SetText( ScriptGlobal_Format("#{HBZHC_210923_10}", nTargetLevel) )
	if 2 == g_nCurSelectedPage then
		HunbingzhuCompound_ChoiceInfo : SetText( ScriptGlobal_Format("#{HBZHC_210923_37}", nTargetLevel) )
	end

	-- ����չʾ����
	local theAction = DataPool:CreateActionItemForShow(g_tableHunBingItemID[nTargetLevel], 1)
	if 0 ~= theAction:GetID() then
		HunbingzhuCompound_Item : SetActionItem(theAction:GetID())
	end

	local nNeedItemLevel	= g_nCurSelectedIndex
	local nNeedItemID 		= g_tableHunBingItemID[g_nCurSelectedIndex]
	local nNeedBindItemID 	= g_tableHunBingBindItemID[g_nCurSelectedIndex]
	local nNeedItemNum		= g_tableCommonCostItemNum[g_nCurSelectedIndex]
	local nNeedMoney		= g_tableCommonCostMoney[g_nCurSelectedIndex]
	-- ��ݺϳɣ�����������ͽ�Ǯ
	if 2 == g_nCurSelectedPage then
		nNeedItemLevel		= 1
		nNeedItemID 		= g_tableHunBingItemID[1]
		nNeedBindItemID 	= g_tableHunBingBindItemID[1]
		nNeedItemNum 		= g_tableQuickCostItemNum[g_nCurSelectedIndex]
		nNeedMoney 			= g_tableQuickCostMoney[g_nCurSelectedIndex]
	end

	-- ��Ҫ��������
	HunbingzhuCompound_Need_Info : SetText( ScriptGlobal_Format("#{HBZHC_210923_13}", nNeedItemLevel) )
	HunbingzhuCompound_Need_Number : SetText( ScriptGlobal_Format("#{HBZHC_210923_38}", nNeedItemNum) )

	-- ӵ�и�������
	local nHaveCount = PlayerPackage:CountAvailableItemByIDTable(nNeedItemID) + PlayerPackage:CountAvailableItemByIDTable(nNeedBindItemID)
	local strHaveCount = ""
	-- %s0��       HBZHC_210923_39   //%s0��ʾΪ��ɫ
	-- %s0��       HBZHC_210923_40   //%s0��ʾΪ��ɫ
	if nHaveCount >= nNeedItemNum then
		strHaveCount = ScriptGlobal_Format("#{HBZHC_210923_39}", nHaveCount)
	else
		strHaveCount = ScriptGlobal_Format("#{HBZHC_210923_40}", nHaveCount)
	end
	HunbingzhuCompound_Have_Info 	: SetText( ScriptGlobal_Format("#{HBZHC_210923_15}", nNeedItemLevel) )
	HunbingzhuCompound_Have_Number	: SetText( strHaveCount )
	
	-- �ϳ���������
	HunbingzhuCompound_DemandMoney 		: SetProperty("MoneyNumber", nNeedMoney)
	HunbingzhuCompound_MoneyUpdate()

end

--=========================================================
-- ��Ǯˢ�£�������µ���һ�� ��Ǯ�¼�����һ��
--=========================================================
function HunbingzhuCompound_MoneyUpdate()
	HunbingzhuCompound_CurrentlyJiaozi 	: SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")) )
	HunbingzhuCompound_CurrentlyMoney 	: SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")) )
end

--=========================================================
-- ���ý���
--=========================================================
function HunbingzhuCompound_Reset()
	g_nCurSelectedPage = 1
	g_nCurSelectedIndex = 1
end

--=========================================================
-- �л�ҳ��
--=========================================================
function HunbingzhuCompound_SwitchPage(nPage)
	if nil == nPage or nPage < 1 or nPage > 2 then
		return
	end

	g_nCurSelectedPage = nPage
	HunbingzhuCompound_Update(0)
end

--=========================================================
-- ѡ��ť
--=========================================================
function HunbingzhuCompound_SelectTargetLevel(nIndex)
	if nil == nIndex or nIndex < 1 or nIndex > 4 then
		return
	end

	g_nCurSelectedIndex = nIndex
	HunbingzhuCompound_Update(0)
end

--=========================================================
-- ����ȷ�ϰ�ť
--=========================================================
function HunbingzhuCompound_ConfirmClick(bComfirmed)

	if nil == bComfirmed then
		bComfirmed = 0
	end

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "OnHunBingZhuCompoundNew" )
		Set_XSCRIPT_ScriptID(790075)
		Set_XSCRIPT_Parameter(0, g_nServerObjID)					
		Set_XSCRIPT_Parameter(1, g_nCurSelectedPage)					
		Set_XSCRIPT_Parameter(2, g_nCurSelectedIndex)				
		Set_XSCRIPT_Parameter(3, bComfirmed)	
		Set_XSCRIPT_ParamCount(4)
	Send_XSCRIPT()
end

--=========================================================
-- �رս���
--=========================================================
function HunbingzhuCompound_OnClose()	
	this:Hide()
	StopCareObject_HunbingzhuCompound()
	-- ����
	HunbingzhuCompound_Reset()
end

--=========================================================
-- ��������
-- <Event Name="Hidden" Function="HunbingzhuCompound_OnHiden();" />
--=========================================================
function HunbingzhuCompound_OnHiden()
	StopCareObject_HunbingzhuCompound()
	-- ����
	HunbingzhuCompound_Reset()
end

--=========================================================
-- ���Ĳ���
--=========================================================
function BeginCareObject_HunbingzhuCompound()
	-- ����
	this:CareObject(g_nObjCaredIDClient, 1, "HunbingzhuCompound")
end

function StopCareObject_HunbingzhuCompound()
	-- ȡ������
	if nil ~= g_nObjCaredIDClient and g_nObjCaredIDClient > 0 then
		this:CareObject(g_nObjCaredIDClient, 0, "HunbingzhuCompound")
	end
	g_nServerObjID = -1
end

--=========================================================
-- Ԫ��ˢ�£�������µ���һ�� Ԫ���¼�����һ��
--=========================================================
function HunbingzhuCompound_YuanBaoUpdate()
	-- HunbingzhuCompound_HaveYuanBaoNum : SetText (tostring(Player:GetData("YUANBAO")))
end

--=========================================================
-- ����λ��
--=========================================================
function HunbingzhuCompound_Frame_On_ResetPos()
	HunbingzhuCompoundFrame:SetProperty("UnifiedPosition", g_HunbingzhuCompound_Frame_UnifiedPosition)
end