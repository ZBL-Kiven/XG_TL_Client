-- PetSoul_FengHunLuGift ���¼��� 2022-1-12 lishilong
-- !!!reloadscript =PetSoul_FengHunLuGift
--

local g_PetSoul_FengHunLuGift_Frame_UnifiedPosition
local MAX_OBJ_DISTANCE 		= 3.0
local g_nObjCaredIDClient 	= -1
local g_nServerObjID 		= -1
local bCaredItem 			= 0
local bCaredObj 			= 0
local bCaredMoney 			= 0
local bCaredYuanBao			= 0
local g_nComfirmParam1		= 0

local g_nUICommandID		= 79101101
local g_nUIComfirmCommandID	= 79101102

local g_nUseItemBagPos		= -1

-- �����������
local g_tableRewardInfo	=
{
	[1] = {nGiveItemID = 38002528, nGiveItemNum = 2, nGiveAddItemID = 0, nGiveAddItemNum = 0, nLogType = 0, nYBLogItemID = -1,  nNeedBagSpace = 1, nNeedMatSpace = 0, nCostYuanBao = 0, },
	[2] = {nGiveItemID = 38002528, nGiveItemNum = 2, nGiveAddItemID = 38002524, nGiveAddItemNum = 3, nLogType = 1, nYBLogItemID = 40004852, nNeedBagSpace = 2, nNeedMatSpace = 0, nCostYuanBao = 500, },
	[3] = {nGiveItemID = 38002528, nGiveItemNum = 2, nGiveAddItemID = 38002519, nGiveAddItemNum = 4, nLogType = 2, nYBLogItemID = 40004853, nNeedBagSpace = 2, nNeedMatSpace = 0, nCostYuanBao = 2000, },
}
local g_contorlActionButton		= {}
local g_contorlActionButton2	= {}
-- ����ѡ�����ֵ
local g_nMaxSelectedIndex		= 3

--=========================================================
-- PreLoad
--=========================================================
function PetSoul_FengHunLuGift_PreLoad()
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
function PetSoul_FengHunLuGift_OnLoad()
	g_PetSoul_FengHunLuGift_Frame_UnifiedPosition = PetSoul_FengHunLuGift_Frame:GetProperty("UnifiedPosition")

	-- PetSoul_FengHunLuGift_OK_Button : SetEvent("Clicked", "PetSoul_FengHunLuGift_ConfirmClick()")
	g_contorlActionButton[1] = PetSoul_FengHunLuGift_Gift1_Icon
	g_contorlActionButton[2] = PetSoul_FengHunLuGift_Gift2_Icon
	g_contorlActionButton[3] = PetSoul_FengHunLuGift_Gift3_Icon

	g_contorlActionButton2[1] = PetSoul_FengHunLuGift_Gift2_Icon2
	g_contorlActionButton2[2] = PetSoul_FengHunLuGift_Gift3_Icon2
end

--=========================================================
-- OnEvent
--=========================================================
function PetSoul_FengHunLuGift_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == g_nUICommandID ) then
		-- 0 �ر�, 1 ��, 2 ˢ��, 3 ����ȷ�Ͽ�
		local nOpType 	= Get_XParam_INT(0)

		-- �رս���
		if 0 == nOpType then	
			if this:IsVisible() then
				PetSoul_FengHunLuGift_OnClose()
			end
		end

		-- �򿪽���
		if 1 == nOpType then
			-- ��עnpc
			if 1 == bCaredObj then
				local nServerObjID 	= Get_XParam_INT(1)
				if nServerObjID == nil or nServerObjID < 0 then
					if this:IsVisible() then
						PetSoul_FengHunLuGift_OnClose()
					end
				end
				g_nServerObjID = nServerObjID
				g_nObjCaredIDClient = DataPool : GetNPCIDByServerID(tonumber(nServerObjID))
				BeginCareObject_PetSoul_FengHunLuGift()
			end

			-- ��ʾ����
			-- Ϊ�˽�����汻�ڵ������⣬�Ȱѽ������
			-- if this:IsVisible() then
			-- 	PetSoul_FengHunLuGift_OnClose()
			-- end
			PetSoul_FengHunLuGift_Reset()
			PetSoul_FengHunLuGift_Frame_On_ResetPos()
			this:Show()
			PetSoul_FengHunLuGift_ParamInit()
			PetSoul_FengHunLuGift_MoneyUpdate()
			PetSoul_FengHunLuGift_YuanBaoUpdate()
			PetSoul_FengHunLuGift_Update(1)
		end
			
		-- ˢ�½���
		if 2 == nOpType then
			-- ��עnpc
			if 1 == bCaredObj then
				local nServerObjID 	= Get_XParam_INT(1)
				if nServerObjID == nil or nServerObjID < 0 then
					if this:IsVisible() then
						PetSoul_FengHunLuGift_OnClose()
					end
				end
			end
			if this:IsVisible() then
				PetSoul_FengHunLuGift_ParamInit()
				PetSoul_FengHunLuGift_Update(0)
			end
		end

		-- ����ȷ�Ͽ�
		if 3 == nOpType then
			local strMsg = Get_XParam_STR(0)
			-- g_nComfirmParam1 = Get_XParam_INT(1)
			-- ["Type"] "Ok" "YesNo"
			MessageBoxSelf3("PetSoul_FengHunLuGift_OnComfirmedBack", {["Content"] = strMsg,["Type"] = "YesNo", })
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
			PetSoul_FengHunLuGift_OnClose()
		end	

	-- ��Ʒ�ı�
	elseif ( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() and 1 == bCaredItem ) then
		-- ˢ�½���
		if this:IsVisible() then
			PetSoul_FengHunLuGift_Update(0)
		end

	-- ��Ǯ�ı�
	elseif (event == "UNIT_MONEY" or event == "MONEYJZ_CHANGE") and 1 == bCaredMoney then
		PetSoul_FengHunLuGift_MoneyUpdate()

	-- Ԫ���ı�
	elseif event == "UPDATE_YUANBAO" and 1 == bCaredYuanBao then
		PetSoul_FengHunLuGift_YuanBaoUpdate()

	elseif event == "HIDE_ON_SCENE_TRANSED" then
		PetSoul_FengHunLuGift_OnClose()
	
	elseif (event == "ADJEST_UI_POS" ) then
		PetSoul_FengHunLuGift_Frame_On_ResetPos()

	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		PetSoul_FengHunLuGift_Frame_On_ResetPos()
	end
end

--=========================================================
-- ���������ʼ��
--=========================================================
function PetSoul_FengHunLuGift_ParamInit()
	g_nUseItemBagPos = Get_XParam_INT(1)
end

--=========================================================
-- ����ȷ�Ͽ�ص� ["Type"] "Ok"�ķ���ֵ��"Ok"�� ["Type"] "YesNo"�ķ���ֵ�� "Yes" "No"
--=========================================================
function PetSoul_FengHunLuGift_OnComfirmedBack(strRet)
	if nil == strRet then
		return
	end

	if "Yes" == strRet or "Ok" == strRet then

	end

	if "No" == strRet then
		
	end
end

--=========================================================
-- �������
--=========================================================
-- !!!reloadscript =PetSoul_FengHunLuGift
function PetSoul_FengHunLuGift_Update(bOpen)
	for i = 1, g_nMaxSelectedIndex do

		local tRewardInfo = g_tableRewardInfo[i]
		local nGiveItemID = tRewardInfo.nGiveItemID
		local nGiveItemNum = tRewardInfo.nGiveItemNum
		local nGiveAddItemID = tRewardInfo.nGiveAddItemID
		local nGiveAddItemNum = tRewardInfo.nGiveAddItemNum
		local theAction = DataPool:CreateBindActionItemForShow(nGiveItemID, nGiveItemNum)
		local theAction2 = DataPool:CreateBindActionItemForShow(nGiveAddItemID, nGiveAddItemNum)
		-- local theAction = DataPool:CreateActionItemForShow(tPointRewardInfo.nRewardItemID, 1)
		g_contorlActionButton[i] : SetActionItem(theAction:GetID())
		if nGiveAddItemID > 0 and nGiveAddItemNum > 0 then
			g_contorlActionButton2[i-1] : SetActionItem(theAction2:GetID())
		end
		
	end
end

--=========================================================
-- ���ý���
--=========================================================
function PetSoul_FengHunLuGift_Reset()
	g_nUseItemBagPos = -1
end

--=========================================================
-- ����ȷ�ϰ�ť
--=========================================================
function PetSoul_FengHunLuGift_ConfirmClick(nSelectedIndex)
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "OnUIClickCallBack" )
		Set_XSCRIPT_ScriptID(791011)
		Set_XSCRIPT_Parameter(0, g_nUseItemBagPos)					
		Set_XSCRIPT_Parameter(1, nSelectedIndex)				
		Set_XSCRIPT_Parameter(2, 0)				
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
end

--=========================================================
-- �رս���
--=========================================================
function PetSoul_FengHunLuGift_OnClose()	
	this:Hide()
	StopCareObject_PetSoul_FengHunLuGift()
	-- ����
	PetSoul_FengHunLuGift_Reset()
end

--=========================================================
-- ��������
-- <Event Name="Hidden" Function="PetSoul_FengHunLuGift_OnHiden();" />
--=========================================================
function PetSoul_FengHunLuGift_OnHiden()
	StopCareObject_PetSoul_FengHunLuGift()
	-- ����
	PetSoul_FengHunLuGift_Reset()
end

--=========================================================
-- ���Ĳ���
--=========================================================
function BeginCareObject_PetSoul_FengHunLuGift()
	-- ����
	this:CareObject(g_nObjCaredIDClient, 1, "PetSoul_FengHunLuGift")
end

function StopCareObject_PetSoul_FengHunLuGift()
	-- ȡ������
	if nil ~= g_nObjCaredIDClient and g_nObjCaredIDClient > 0 then
		this:CareObject(g_nObjCaredIDClient, 0, "PetSoul_FengHunLuGift")
	end
	g_nServerObjID = -1
end

--=========================================================
-- ��Ǯˢ�£�������µ���һ�� ��Ǯ�¼�����һ��
--=========================================================
function PetSoul_FengHunLuGift_MoneyUpdate()
	-- PetSoul_FengHunLuGift_HaveJiaoZiNum : SetProperty( "MoneyNumber", tostring(Player:GetData("MONEY_JZ")) )
	-- PetSoul_FengHunLuGift_HaveGoldNum : SetProperty( "MoneyNumber", tostring(Player:GetData("MONEY")) )
end

--=========================================================
-- Ԫ��ˢ�£�������µ���һ�� Ԫ���¼�����һ��
--=========================================================
function PetSoul_FengHunLuGift_YuanBaoUpdate()
	-- PetSoul_FengHunLuGift_HaveYuanBaoNum : SetText (tostring(Player:GetData("YUANBAO")))
end

--=========================================================
-- ����λ��
--=========================================================
function PetSoul_FengHunLuGift_Frame_On_ResetPos()
	PetSoul_FengHunLuGift_Frame:SetProperty("UnifiedPosition", g_PetSoul_FengHunLuGift_Frame_UnifiedPosition)
end