-- ������������
-- Author: XYZ 2019-6-3
--=========================================================
--��������
--=========================================================
local g_nObjCaredID 		= -1
local g_nItemPos 			= -1
local g_bIsReset 			= 1
local g_nAcceptClickedNum 	= 0
local g_bInputed			= 0
local g_CountAvailableItem = 0
local g_ShenqiSJ_Frame_UnifiedPosition

local MAX_OBJ_DISTANCE 		= 3.0
local EQUIP_SHENQI_BEGIN = 10300000
local EQUIP_SHENQI_END = 10399999
local g_DesLevelTable = {
							[1] = 42,
							[2] = 52,
							[3] = 62,
							[4] = 72,
							[5] = 82,
							[6] = 92,
						}

function ShenqiSJ_PreLoad()
	this : RegisterEvent( "UI_COMMAND" )
	this : RegisterEvent( "OBJECT_CARED_EVENT" )
	this : RegisterEvent( "PACKAGE_ITEM_CHANGED" )
	this : RegisterEvent( "UNIT_MONEY" )
	this : RegisterEvent( "MONEYJZ_CHANGE" )
	this : RegisterEvent( "UPDATE_SHENQI_LEVEL_UP" )
	this : RegisterEvent( "SUPER_ATTR_RECOIN_CONFIRM_OK" )
	this : RegisterEvent("ADJEST_UI_POS")
	this : RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function ShenqiSJ_OnLoad()
	g_ShenqiSJ_Frame_UnifiedPosition = ShenqiSJ_Frame:GetProperty("UnifiedPosition")
	ShenqiSJ_Reset()
end

--=========================================================
--�¼���Ӧ
--=========================================================
function ShenqiSJ_OnEvent( event )

	if event == "UI_COMMAND" and tonumber(arg0) == 920160815 then
		local bIsOpen = Get_XParam_INT(0)
		local targetId = Get_XParam_INT(1)
		--g_CountAvailableItem = Get_XParam_INT(2) --��ç�������
		if 0 == bIsOpen then
			-- �رս���
			ShenqiSJ_Close()
			return
		end
		
		ObjCaredID = DataPool : GetNPCIDByServerID( targetId )
		if ObjCaredID == -1 then
			--PushDebugMessage("server�����������������⡣")
			return
		end
		g_nObjCaredID = targetId
		BeginCareObject_ShenqiSJ()
		ShenqiSJ_Reset()
		ShenqiSJ_MoneyUpdate()
		this : Show()

	elseif event == "UNIT_MONEY" or event == "MONEYJZ_CHANGE" then
		ShenqiSJ_MoneyUpdate()

	elseif event == "OBJECT_CARED_EVENT" then
		if( tonumber(arg0) ~= ObjCaredID ) then
			return
		end
		if( arg1 == "distance" and tonumber( arg2 ) > MAX_OBJ_DISTANCE or arg1=="destroy" ) then
			ShenqiSJ_Close()
		end

	elseif event == "PACKAGE_ITEM_CHANGED" then
		if( arg0~= nil and -1 == tonumber(arg0)) then
			return
		end

		if tonumber(arg0) == g_nItemPos then
			if( this:IsVisible() ) then
				ShenqiSJ_Reset()
			end
		end
	
	-- �Ҽ���Ʒ������ק����Ϣ
	elseif event == "UI_COMMAND" and tonumber(arg0) == 201107281 and this:IsVisible() then
		if arg1 ~= nil then
			ShenqiSJ_Reset()
			ShenqiSJ_Update( arg1 )
		end

	-- ����ȷ�Ͽ�ȷ�� 86����������ȷ�Ͽ�
	elseif event == "UI_COMMAND" and tonumber(arg0) == 2016092992 then
		g_nAcceptClickedNum = 1
		ShenqiSJ_Buttons_Clicked()
	
	-- ����ȷ�Ͽ�ȷ�� 42����������������ȷ�Ͽ�
	elseif event == "UI_COMMAND" and tonumber(arg0) == 2016092993 then
		g_nAcceptClickedNum = 1
		ShenqiSJ_Buttons_Clicked()
	
	elseif (event == "ADJEST_UI_POS" ) then
		ShenqiSJ_Frame_On_ResetPos()

	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		ShenqiSJ_Frame_On_ResetPos()
		
	elseif event == "UI_COMMAND" and tonumber(arg0) == 2019060301 then
		local nMaterialNum = Get_XParam_INT(0)
		g_CountAvailableItem = nMaterialNum
		ShenqiSJ_RefreshMaterialNum(nMaterialNum)
		
	end

end

--=========================================================
--ȷ����ť
--=========================================================
function ShenqiSJ_Buttons_Clicked()
	
	-- �ж��Ƿ�Ϊ��ȫʱ��
	if (tonumber(DataPool:GetLeftProtectTime()) > 0) then
		PushDebugMessage("#{XSQSJ_160812_18}")
		return
	end
	
	-- �ж��Ƿ��Ѿ�����������
	if -1 == g_nItemPos then
		PushDebugMessage("#{XSQSJ_160812_27}")
		return
	end
	
	local nItemID = PlayerPackage : GetItemTableIndex( g_nItemPos )
	--	�ж��Ƿ�������
	if nItemID < EQUIP_SHENQI_BEGIN or nItemID > EQUIP_SHENQI_END then
		PushDebugMessage("#{XSQSJ_160812_08}")
		return
	end
	
	local strContext, nIndex = ShenqiSJ_Level:GetCurrentSelect()
	if nIndex < 0 then
		PushDebugMessage("�Ƿ�Ŀ��ȼ�ѡ��")
		return
	end 
	
	local nDesLevel = tonumber(strContext)
	if -1 == nDesLevel then
		PushDebugMessage("�Ƿ�Ŀ��ȼ�ѡ��")
		return
	end
	
	-- �ж������Ƿ�С��92��
	local nEquipLevel = tonumber(LifeAbility : Get_Equip_Level(g_nItemPos))
	if nEquipLevel >= 92 then
		PushDebugMessage("#{XSQSJ_160812_09}")
		return
	end
	
	-- �жϾ������Ƿ���������������
	local bRet, nShenqiLevel, nCostMoney, nCostItemID, nCostItemNum = GetShenqiLevelUpInfo(nItemID, nDesLevel)
	if 0 == bRet or nil == bRet then
		PushDebugMessage("�����������ݴ����޴�������Ϣ")
		return
	end
	
	-- �����ȼ����ô���
	if nEquipLevel ~= nShenqiLevel then
		PushDebugMessage("�����������ݴ��������ȼ���һ��")
		return
	end
	
	-- ���������ȼ����ڵ���Ŀ�������ȼ����߻�������
	if nShenqiLevel >= nDesLevel then
		PushDebugMessage("�����������ݴ���Ŀ��ȼ�С��Դ�ȼ�")
		return
	end
	
	-- �ж϶�Ӧ������Ƿ�
	local nHaveNum = g_CountAvailableItem--PlayerPackage:CountAvailableItemByIDTable(nCostItemID)
	if nHaveNum < nCostItemNum then
		local strItemName = LuaFnGetItemName(nCostItemID)
		local strMsg = string.format("#H%s�������㣬�޷�������", strItemName)
		PushDebugMessage(strMsg)
		return
	end
	
	-- �ж�Ǯ�Ƿ���
	local nHaveMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")
	if nCostMoney > nHaveMoney then
		PushDebugMessage("#{XSQSJ_160812_21}")
		return
	end
	
	-- ���÷������ű�
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "OnShenqiLevelUp" )
		Set_XSCRIPT_ScriptID( 500506 )
		Set_XSCRIPT_Parameter( 0, g_nItemPos )
		Set_XSCRIPT_Parameter( 1, nDesLevel )
		Set_XSCRIPT_Parameter( 2, g_nAcceptClickedNum )
		Set_XSCRIPT_ParamCount( 3 )
	Send_XSCRIPT()
end

--=========================================================
--ѡ��Ŀ�������ȼ�
--=========================================================
function ShenqiSJ_SelectLevel()
	if 0 == g_bInputed then
		--PushDebugMessage("#{XSQSJ_160812_19}")
		return
	end
	ShenqiSJ_Update( g_nItemPos )
end

--=========================================================
--ѡ��Ŀ�������ȼ�
--=========================================================
function ShenqiSJ_SelectLevelClick()
	if 0 == g_bInputed then
		PushDebugMessage("#{XSQSJ_160812_19}")
		return
	end
end

--=========================================================
--���½���
--=========================================================
function ShenqiSJ_Update( nPacketPos )

	local nBagIndex = tonumber( nPacketPos )
	
	if -1 == nBagIndex then
		return
	end
	
	local theAction = EnumAction( nBagIndex, "packageitem" )

	if 0 == theAction : GetID() then
		return
	end
	
	-- ��ȡ��ƷID
	local nItemID = PlayerPackage : GetItemTableIndex( nBagIndex )
	if nItemID <= 0 then
		PushDebugMessage("�Ƿ�����")
		return
	end
	
	--	�ж��Ƿ�������
	if nItemID < EQUIP_SHENQI_BEGIN or nItemID > EQUIP_SHENQI_END then
		PushDebugMessage("#{XSQSJ_160812_08}")
		return
	end
	
	-- �ж������Ƿ�С��92��
	local nEquipLevel = tonumber(LifeAbility : Get_Equip_Level(nBagIndex))
	if nEquipLevel >= 92 then
		PushDebugMessage("#{XSQSJ_160812_09}")
		return
	end
	
	-- ���Ŀ��level������
	if 1 == g_bIsReset then
		ShenqiSJ_Level:ResetList()
		
		if 86 == nEquipLevel then
			-- 86������ֻ��������Ϊ96��
			ShenqiSJ_Level:AddTextItem(96, 0)
			ShenqiSJ_Level:SetCurrentSelect(0)
		else
			local nCount = 0 
			for i = 1, table.getn( g_DesLevelTable ) do
				if g_DesLevelTable[i] > nEquipLevel then
					ShenqiSJ_Level:AddTextItem(g_DesLevelTable[i], nCount)
					nCount = nCount + 1 
				end
			end
			if nCount > 0 then
				ShenqiSJ_Level:SetCurrentSelect(0)
			end
		end
			
		g_bIsReset = 0
	end
	
	local strContext, nIndex = ShenqiSJ_Level:GetCurrentSelect()
	if nIndex < 0 then
		return
	end
	local nDesLevel = tonumber(strContext)
	if -1 == nDesLevel then
		return
	end
	
	-- �жϾ������Ƿ���������������
	local bRet, nShenqiLevel, nCostMoney, nCostItemID, nCostItemNum = GetShenqiLevelUpInfo(nItemID, nDesLevel)
	if 0 == bRet or nil == bRet then
		ShenqiSJ_Reset()
		PushDebugMessage("�����������ݴ����޴�������Ϣ")
		return
	end
	
	-- �����ȼ����ô���
	if nEquipLevel ~= nShenqiLevel then
		ShenqiSJ_Reset()
		PushDebugMessage("�����������ݴ��������ȼ���һ��")
		return
	end
	
	-- ���������ȼ����ڵ���Ŀ�������ȼ����߻�������
	if nShenqiLevel >= nDesLevel then
		ShenqiSJ_Reset()
		PushDebugMessage("�����������ݴ���Ŀ��ȼ�С��Դ�ȼ�")
		return
	end

	-- ����ActionButton�����ı�����
	if g_nItemPos ~= -1 then
		LifeAbility : Lock_Packet_Item( g_nItemPos, 0 )
	end
	LifeAbility : Lock_Packet_Item( nBagIndex, 1 )
	g_nItemPos = nBagIndex
	
	-- ����ͼ��
	ShenqiSJ_Wuqi_Button : SetActionItem( theAction : GetID() )
	
	-- ������Ҫ�Ľ�Ǯ
	ShenqiSJ_Spend_DemandMoney : SetProperty( "MoneyNumber", tostring( nCostMoney ) )
	
	-- ������Ҫ���ϵ�actionbutton
	local theAction = GemCarve:UpdateProductAction(nCostItemID)
	if nil ~= theAction and nil ~= theAction:GetID() and 0 ~= theAction:GetID() then
		ShenqiSJ_Shenfu_Button:SetActionItem(theAction:GetID())
	end
	
	-- ����ӵ�в�������
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "GetMaterialNum" )
		Set_XSCRIPT_ScriptID( 500506 )
		Set_XSCRIPT_Parameter( 0, nCostItemID )
		Set_XSCRIPT_ParamCount( 1 )
	Send_XSCRIPT()

	-- ������Ҫ���ϵ�����
	if nil ~= nCostItemNum then
		ShenqiSJ_ShenfuNeed_Num:SetText(tostring( nCostItemNum ))
	end
	
	-- ����ȷ������
	g_nAcceptClickedNum = 0

	-- ȡ���û�
	ShenqiSJ_OK:Enable()
	--ShenqiSJ_Level:Enable()
	g_bInputed = 1
end
--=========================================================
--ˢ����ç�������
--=========================================================
function ShenqiSJ_RefreshMaterialNum(nItemNumber)
	if nil ~= nItemNumber then
		strMsg = string.format("#e000001%s", nItemNumber)
		ShenqiSJ_Shenfu_Num:SetText(strMsg)
	end
end
--=========================================================
--���ý���
--=========================================================
function ShenqiSJ_Reset()
	g_nAcceptClickedNum =0
	g_bIsReset = 1
	
	ShenqiSJ_Level:ResetList()
	ShenqiSJ_Level:AddTextItem("", 0)
	ShenqiSJ_Level:SetCurrentSelect(0)
	--ShenqiSJ_Level:Disable()
	g_bInputed = 0
	
	-- �����ȥ�� ����
	--ShenqiSJ_MaterialNeed:SetText("")
	--ShenqiSJ_Material:SetText("")
	
	-- �����Ǯ��0
	ShenqiSJ_Spend_DemandMoney : SetProperty( "MoneyNumber", tostring( 0 ) )
	
	-- ��Ҫ���ϵ�ͼ���ӵ�С������������
	ShenqiSJ_Shenfu_Button : SetActionItem(-1)
	ShenqiSJ_Shenfu_Num : SetText("")
	ShenqiSJ_ShenfuNeed_Num : SetText("")
	
	ShenqiSJ_OK:Disable()
	
	if -1 ~= g_nItemPos then
		ShenqiSJ_Wuqi_Button:SetActionItem(-1)
		LifeAbility:Lock_Packet_Item(g_nItemPos, 0)
		g_nItemPos = -1
	end
end

--=========================================================
--�ر�
--=========================================================
function ShenqiSJ_Close()
	this : Hide()
	StopCareObject_ShenqiSJ()
	ShenqiSJ_Reset()
end

--=========================================================
--��������
--=========================================================
function ShenqiSJ_OnHiden()
	StopCareObject_ShenqiSJ()
	ShenqiSJ_Reset()
end

--=========================================================
--��ʼ����NPC��
--�ڿ�ʼ����֮ǰ��Ҫ��ȷ����������ǲ����Ѿ��С����ġ���NPC��
--����еĻ�����ȡ���Ѿ��еġ����ġ�
--=========================================================
function BeginCareObject_ShenqiSJ()
	this : CareObject( ObjCaredID, 1, "ShenqiSJ" )
end

--=========================================================
--ֹͣ��ĳNPC�Ĺ���
--=========================================================
function StopCareObject_ShenqiSJ()
	this : CareObject( ObjCaredID, 0, "ShenqiSJ" )
end

--�Ҽ����ȡ��
function ShenqiSJ_Item_cancel()
	if( this:IsVisible() ) then
		ShenqiSJ_Reset()
	end
end

function ShenqiSJ_MoneyUpdate()
	ShenqiSJ_SelfMoney : SetProperty( "MoneyNumber", tostring(Player:GetData("MONEY")) )
	ShenqiSJ_SelfJiaozi : SetProperty( "MoneyNumber", tostring(Player:GetData("MONEY_JZ")) )
end

function ShenqiSJ_Frame_On_ResetPos()
	ShenqiSJ_Frame:SetProperty("UnifiedPosition", g_ShenqiSJ_Frame_UnifiedPosition)
end

function GetShenqiLevelUpInfo(nItemID,nDesLevel)
	local nShenqiLevelInfo = {
		--�������������
	{10306200,15,42,10305000,50000,30505800,5},
	{10306200,15,52,10305001,50000,30505801,10},
	{10306200,15,62,10305002,50000,30505802,15},
	{10306200,15,72,10305003,50000,30505803,20},
	{10306200,15,82,10305004,50000,30505804,20},
	{10306200,15,92,10305005,50000,30505805,20},
	{10305000,42,52,10305001,50000,30505801,10},
	{10305000,42,62,10305002,50000,30505802,15},
	{10305000,42,72,10305003,50000,30505803,20},
	{10305000,42,82,10305004,50000,30505804,20},
	{10305000,42,92,10305005,50000,30505805,20},
	{10305001,52,62,10305002,50000,30505802,15},
	{10305001,52,72,10305003,50000,30505803,20},
	{10305001,52,82,10305004,50000,30505804,20},
	{10305001,52,92,10305005,50000,30505805,20},
	{10305002,62,72,10305003,50000,30505803,20},
	{10305002,62,82,10305004,50000,30505804,20},
	{10305002,62,92,10305005,50000,30505805,20},
	{10305003,72,82,10305004,50000,30505804,20},
	{10305003,72,92,10305005,50000,30505805,20},
	{10305004,82,92,10305005,50000,30505805,20},

	--���������������
	{10306201,15,42,10306000,50000,30505800,5},
	{10306201,15,52,10306001,50000,30505801,10},
	{10306201,15,62,10306002,50000,30505802,15},
	{10306201,15,72,10306003,50000,30505803,20},
	{10306201,15,82,10306004,50000,30505804,20},
	{10306201,15,92,10306005,50000,30505805,20},
	{10306000,42,52,10306001,50000,30505801,10},
	{10306000,42,62,10306002,50000,30505802,15},
	{10306000,42,72,10306003,50000,30505803,20},
	{10306000,42,82,10306004,50000,30505804,20},
	{10306000,42,92,10306005,50000,30505805,20},
	{10306001,52,62,10306002,50000,30505802,15},
	{10306001,52,72,10306003,50000,30505803,20},
	{10306001,52,82,10306004,50000,30505804,20},
	{10306001,52,92,10306005,50000,30505805,20},
	{10306002,62,72,10306003,50000,30505803,20},
	{10306002,62,82,10306004,50000,30505804,20},
	{10306002,62,92,10306005,50000,30505805,20},
	{10306003,72,82,10306004,50000,30505804,20},
	{10306003,72,92,10306005,50000,30505805,20},
	{10306004,82,92,10306005,50000,30505805,20},
	{10300422,15,42,10300000,50000,30505800,5},
	{10300422,15,52,10300001,50000,30505801,10},
	{10300422,15,62,10300002,50000,30505802,15},
	{10300422,15,72,10300003,50000,30505803,20},
	{10300422,15,82,10300004,50000,30505804,20},
	{10300422,15,92,10300005,50000,30505805,20},
	{10300000,42,52,10300001,50000,30505801,10},
	{10300000,42,62,10300002,50000,30505802,15},
	{10300000,42,72,10300003,50000,30505803,20},
	{10300000,42,82,10300004,50000,30505804,20},
	{10300000,42,92,10300005,50000,30505805,20},
	{10300001,52,62,10300002,50000,30505802,15},
	{10300001,52,72,10300003,50000,30505803,20},
	{10300001,52,82,10300004,50000,30505804,20},
	{10300001,52,92,10300005,50000,30505805,20},
	{10300002,62,72,10300003,50000,30505803,20},
	{10300002,62,82,10300004,50000,30505804,20},
	{10300002,62,92,10300005,50000,30505805,20},
	{10300003,72,82,10300004,50000,30505804,20},
	{10300003,72,92,10300005,50000,30505805,20},
	{10300004,82,92,10300005,50000,30505805,20},
	{10300006,86,96,10300007,50000,30505805,20},
	{10300400,86,96,10300402,50000,30505805,20},
	{10300401,86,96,10300403,50000,30505805,20},
	{10301000,86,96,10301001,50000,30505805,20},
	{10301198,86,96,10301199,50000,30505805,20},
	{10301400,86,96,10301404,50000,30505805,20},
	{10301401,86,96,10301405,50000,30505805,20},
	{10301402,86,96,10301406,50000,30505805,20},
	{10301403,86,96,10301407,50000,30505805,20},
	{10302448,15,42,10302000,50000,30505800,5},
	{10302448,15,52,10302001,50000,30505801,10},
	{10302448,15,62,10302002,50000,30505802,15},
	{10302448,15,72,10302003,50000,30505803,20},
	{10302448,15,82,10302004,50000,30505804,20},
	{10302448,15,92,10302005,50000,30505805,20},
	{10302000,42,52,10302001,50000,30505801,10},
	{10302000,42,62,10302002,50000,30505802,15},
	{10302000,42,72,10302003,50000,30505803,20},
	{10302000,42,82,10302004,50000,30505804,20},
	{10302000,42,92,10302005,50000,30505805,20},
	{10302001,52,62,10302002,50000,30505802,15},
	{10302001,52,72,10302003,50000,30505803,20},
	{10302001,52,82,10302004,50000,30505804,20},
	{10302001,52,92,10302005,50000,30505805,20},
	{10302002,62,72,10302003,50000,30505803,20},
	{10302002,62,82,10302004,50000,30505804,20},
	{10302002,62,92,10302005,50000,30505805,20},
	{10302003,72,82,10302004,50000,30505804,20},
	{10302003,72,92,10302005,50000,30505805,20},
	{10302004,82,92,10302005,50000,30505805,20},
	{10302006,86,96,10302007,50000,30505805,20},
	{10302008,86,96,10302009,50000,30505805,20},
	{10302010,86,96,10302011,50000,30505805,20},
	{10302400,86,96,10302406,50000,30505805,20},
	{10302401,86,96,10302407,50000,30505805,20},
	{10302402,86,96,10302408,50000,30505805,20},
	{10302403,86,96,10302409,50000,30505805,20},
	{10302404,86,96,10302410,50000,30505805,20},
	{10302405,86,96,10302411,50000,30505805,20},
	{10303000,86,96,10303001,50000,30505805,20},
	{10303400,86,96,10303402,50000,30505805,20},
	{10303401,86,96,10303403,50000,30505805,20},
	{10304426,15,42,10304000,50000,30505800,5},
	{10304426,15,52,10304001,50000,30505801,10},
	{10304426,15,62,10304002,50000,30505802,15},
	{10304426,15,72,10304003,50000,30505803,20},
	{10304426,15,82,10304004,50000,30505804,20},
	{10304426,15,92,10304005,50000,30505805,20},
	{10304000,42,52,10304001,50000,30505801,10},
	{10304000,42,62,10304002,50000,30505802,15},
	{10304000,42,72,10304003,50000,30505803,20},
	{10304000,42,82,10304004,50000,30505804,20},
	{10304000,42,92,10304005,50000,30505805,20},
	{10304001,52,62,10304002,50000,30505802,15},
	{10304001,52,72,10304003,50000,30505803,20},
	{10304001,52,82,10304004,50000,30505804,20},
	{10304001,52,92,10304005,50000,30505805,20},
	{10304002,62,72,10304003,50000,30505803,20},
	{10304002,62,82,10304004,50000,30505804,20},
	{10304002,62,92,10304005,50000,30505805,20},
	{10304003,72,82,10304004,50000,30505804,20},
	{10304003,72,92,10304005,50000,30505805,20},
	{10304004,82,92,10304005,50000,30505805,20},
	{10304006,86,96,10304007,50000,30505805,20},
	{10304008,86,96,10304009,50000,30505805,20},
	{10304400,86,96,10304404,50000,30505805,20},
	{10304401,86,96,10304405,50000,30505805,20},
	{10304402,86,96,10304406,50000,30505805,20},
	{10304403,86,96,10304407,50000,30505805,20},
	{10305444,15,42,10305000,50000,30505800,5},
	{10305444,15,52,10305001,50000,30505801,10},
	{10305444,15,62,10305002,50000,30505802,15},
	{10305444,15,72,10305003,50000,30505803,20},
	{10305444,15,82,10305004,50000,30505804,20},
	{10305444,15,92,10305005,50000,30505805,20},
	{10305000,42,52,10305001,50000,30505801,10},
	{10305000,42,62,10305002,50000,30505802,15},
	{10305000,42,72,10305003,50000,30505803,20},
	{10305000,42,82,10305004,50000,30505804,20},
	{10305000,42,92,10305005,50000,30505805,20},
	{10305001,52,62,10305002,50000,30505802,15},
	{10305001,52,72,10305003,50000,30505803,20},
	{10305001,52,82,10305004,50000,30505804,20},
	{10305001,52,92,10305005,50000,30505805,20},
	{10305002,62,72,10305003,50000,30505803,20},
	{10305002,62,82,10305004,50000,30505804,20},
	{10305002,62,92,10305005,50000,30505805,20},
	{10305003,72,82,10305004,50000,30505804,20},
	{10305003,72,92,10305005,50000,30505805,20},
	{10305004,82,92,10305005,50000,30505805,20},
	{10305006,86,96,10305007,50000,30505805,20},
	{10305008,86,96,10305009,50000,30505805,20},
	{10305400,86,96,10305404,50000,30505805,20},
	{10305401,86,96,10305405,50000,30505805,20},
	{10305402,86,96,10305406,50000,30505805,20},
	{10305403,86,96,10305407,50000,30505805,20},
	{10306042,15,42,10306000,50000,30505800,5},
	{10306042,15,52,10306001,50000,30505801,10},
	{10306042,15,62,10306002,50000,30505802,15},
	{10306042,15,72,10306003,50000,30505803,20},
	{10306042,15,82,10306004,50000,30505804,20},
	{10306042,15,92,10306005,50000,30505805,20},
	{10306000,42,52,10306001,50000,30505801,10},
	{10306000,42,62,10306002,50000,30505802,15},
	{10306000,42,72,10306003,50000,30505803,20},
	{10306000,42,82,10306004,50000,30505804,20},
	{10306000,42,92,10306005,50000,30505805,20},
	{10306001,52,62,10306002,50000,30505802,15},
	{10306001,52,72,10306003,50000,30505803,20},
	{10306001,52,82,10306004,50000,30505804,20},
	{10306001,52,92,10306005,50000,30505805,20},
	{10306002,62,72,10306003,50000,30505803,20},
	{10306002,62,82,10306004,50000,30505804,20},
	{10306002,62,92,10306005,50000,30505805,20},
	{10306003,72,82,10306004,50000,30505804,20},
	{10306003,72,92,10306005,50000,30505805,20},
	{10306004,82,92,10306005,50000,30505805,20},
	{10306006,86,96,10306007,50000,30505805,20},
	{10306008,86,96,10306009,50000,30505805,20},
	{10306010,86,96,10306011,50000,30505805,20},
	{10307042,15,42,10307000,50000,30505800,5},
	{10307042,15,52,10307001,50000,30505801,10},
	{10307042,15,62,10307002,50000,30505802,15},
	{10307042,15,72,10307003,50000,30505803,20},
	{10307042,15,82,10307004,50000,30505804,20},
	{10307042,15,92,10307005,50000,30505805,20},
	{10307000,42,52,10307001,50000,30505801,10},
	{10307000,42,62,10307002,50000,30505802,15},
	{10307000,42,72,10307003,50000,30505803,20},
	{10307000,42,82,10307004,50000,30505804,20},
	{10307000,42,92,10307005,50000,30505805,20},
	{10307001,52,62,10307002,50000,30505802,15},
	{10307001,52,72,10307003,50000,30505803,20},
	{10307001,52,82,10307004,50000,30505804,20},
	{10307001,52,92,10307005,50000,30505805,20},
	{10307002,62,72,10307003,50000,30505803,20},
	{10307002,62,82,10307004,50000,30505804,20},
	{10307002,62,92,10307005,50000,30505805,20},
	{10307003,72,82,10307004,50000,30505804,20},
	{10307003,72,92,10307005,50000,30505805,20},
	{10307004,82,92,10307005,50000,30505805,20},
	{10307006,86,96,10307007,50000,30505805,20},
	{10307008,86,96,10307009,50000,30505805,20},
	{10307010,86,96,10307011,50000,30505805,20},
	--2019-12-4 20:32:51 ��ң�� �һ����������
	{10308042,15,42,10308000,50000,30505800,5},
	{10308042,15,52,10308001,50000,30505801,10},
	{10308042,15,62,10308002,50000,30505802,15},
	{10308042,15,72,10308003,50000,30505803,20},
	{10308042,15,82,10308004,50000,30505804,20},
	{10308042,15,92,10308005,50000,30505805,20},
	{10308000,42,52,10308001,50000,30505801,10},
	{10308000,42,62,10308002,50000,30505802,15},
	{10308000,42,72,10308003,50000,30505803,20},
	{10308000,42,82,10308004,50000,30505804,20},
	{10308000,42,92,10308005,50000,30505805,20},
	{10308001,52,62,10308002,50000,30505802,15},
	{10308001,52,72,10308003,50000,30505803,20},
	{10308001,52,82,10308004,50000,30505804,20},
	{10308001,52,92,10308005,50000,30505805,20},
	{10308002,62,72,10308003,50000,30505803,20},
	{10308002,62,82,10308004,50000,30505804,20},
	{10308002,62,92,10308005,50000,30505805,20},
	{10308003,72,82,10308004,50000,30505804,20},
	{10308003,72,92,10308005,50000,30505805,20},
	{10308004,82,92,10308005,50000,30505805,20},
	{10308006,86,96,10308007,50000,30505805,20},
	{10308008,86,96,10308009,50000,30505805,20},
	{10308010,86,96,10308011,50000,30505805,20},
	}
	local bRet, nShenqiLevel, nCostMoney, nCostItemID, nCostItemNum = 0,0,0,0,0
	for i = 1,table.getn(nShenqiLevelInfo) do
		if nShenqiLevelInfo[i][1] == nItemID and nShenqiLevelInfo[i][3] == nDesLevel then
			bRet = i
			nShenqiLevel = nShenqiLevelInfo[i][2]
			nCostMoney = nShenqiLevelInfo[i][5]
			nCostItemID = nShenqiLevelInfo[i][6]
			nCostItemNum = nShenqiLevelInfo[i][7]
		end
	end
	return bRet, nShenqiLevel, nCostMoney, nCostItemID, nCostItemNum
end
