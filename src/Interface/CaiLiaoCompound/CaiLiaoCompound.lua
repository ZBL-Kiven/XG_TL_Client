-- ���Ϻϳɽ��� 2017-8-25 lishilong
--
local MAX_OBJ_DISTANCE = 3.0
local objCared = -1
local npcObjId = -1

local g_CaiLiaoCompound_Num 	= 0		-- ����ѡ���ܸ���
local g_CaiLiaoCompound_Select 	= -1	-- Ĭ��ѡ�ж����˵������±�,��0��ʼ
local g_CaiLiaoCompound_Index 	= {}	-- Ĭ��ѡ�ж����˵��±��Ӧ�����ͺͶ����±�

local g_MaxNum_PerTime 			= 7500	-- �ϳ��������
local g_CurNum_PerTime			= 1		-- ��ǰ�ϳ�����
local g_FunControl				= 0		-- ��ֹѭ�����õĺ������Ʋ���

local g_CaiLiaoCompoundFrame_UnifiedPosition
local g_nHaveCount = 0
-- ѡ����Ϣ
local g_CaiLiaoCompound_Info = 
{
	[1] = {		--		����
		name = "#{CLHC_170824_04}", bShow = 0, bCanCompound = 0,
		[1] = { subname = "#{CLHC_170824_05}", bCanCompound = 0},
		[2] = { subname = "#{CLHC_170824_06}", bCanCompound = 0},
		[3] = { subname = "#{CLHC_170824_07}", bCanCompound = 0},
		[4] = { subname = "#{CLHC_170824_08}", bCanCompound = 0},
		},
	[2] = {		--		�޲�
		name = "#{CLHC_170824_09}", bShow = 0, bCanCompound = 0,
		[1] = { subname = "#{CLHC_170824_10}", bCanCompound = 0},
		[2] = { subname = "#{CLHC_170824_11}", bCanCompound = 0},
		[3] = { subname = "#{CLHC_170824_12}", bCanCompound = 0},
		[4] = { subname = "#{CLHC_170824_13}", bCanCompound = 0},
		},
	[3] = {		--		����
		name = "#{CLHC_170824_14}", bShow = 0, bCanCompound = 0,
		[1] = { subname = "#{CLHC_170824_15}", bCanCompound = 0},
		[2] = { subname = "#{CLHC_170824_16}", bCanCompound = 0},
		[3] = { subname = "#{CLHC_170824_17}", bCanCompound = 0},
		[4] = { subname = "#{CLHC_170824_18}", bCanCompound = 0},
		},
}

-- �ϳ���ֵ
local g_CaiLiaoCompound_Data = 
{
	-- level1Ϊ��Ƭ��level4Ϊ3�����ϣ�����
	[1] = { newlevel = 2, needlevel = 1, needcount = 5, needmoney = 500, },
	[2] = { newlevel = 3, needlevel = 2, needcount = 5, needmoney = 1000, },
	[3] = { newlevel = 4, needlevel = 3, needcount = 5, needmoney = 1500, },
	[4] = { newlevel = 5, needlevel = 4, needcount = 5, needmoney = 5000, },
}

-- ���ϰ�����
local g_CaiLiaoCompound_DataPool = {
	[20502001] = 0,
	[20502002] = 0,
	[20502003] = 0,
	--
	[20501001] = 0,
	[20501002] = 0,
	[20501003] = 0,
	--
	[20500001] = 0,
	[20500002] = 0,
	[20500003] = 0,
}

-- ����
local g_CaiLiaoCompound_Item = 
{
	[1]=
	{
		{nItemID = 20502000, strShowName = "#{CLHC_170904_74}"},	--������Ƭ
		{nItemID = 20502001, strShowName = "#{CLHC_170904_77}"},	--1������
		{nItemID = 20502002, strShowName = "#{CLHC_170904_78}"},	--2������
		{nItemID = 20502003, strShowName = "#{CLHC_170904_79}"},	--3������
		{nItemID = 20502004, strShowName = "#{CLHC_170904_80}"},	--4������
	},
	
	[2]=
	{
		{nItemID = 20501000, strShowName = "#{CLHC_170904_75}"},	--�޲���Ƭ
		{nItemID = 20501001, strShowName = "#{CLHC_170904_81}"},	--1���޲�
		{nItemID = 20501002, strShowName = "#{CLHC_170904_82}"},	--2���޲�
		{nItemID = 20501003, strShowName = "#{CLHC_170904_83}"},	--3���޲�
		{nItemID = 20501004, strShowName = "#{CLHC_170904_84}"},	--4���޲�
	},
	
	[3]=
	{
		{nItemID = 20500000, strShowName = "#{CLHC_170904_76}"},	--������Ƭ
		{nItemID = 20500001, strShowName = "#{CLHC_170904_85}"},	--1������
		{nItemID = 20500002, strShowName = "#{CLHC_170904_86}"},	--2������
		{nItemID = 20500003, strShowName = "#{CLHC_170904_87}"},	--3������
		{nItemID = 20500004, strShowName = "#{CLHC_170904_88}"},	--4������
	},
}

--=========================================================
-- PreLoad
--=========================================================
function CaiLiaoCompound_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("OBJECT_CARED_EVENT",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	this:RegisterEvent("PACKAGE_ITEM_CHANGED",false)
	this:RegisterEvent("UNIT_MONEY",false)
	this:RegisterEvent("MONEYJZ_CHANGE",false)
	
	this : RegisterEvent("ADJEST_UI_POS")
	this : RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

--=========================================================
-- OnLoad
--=========================================================
function CaiLiaoCompound_OnLoad()
	g_CaiLiaoCompoundFrame_UnifiedPosition = CaiLiaoCompoundFrame:GetProperty("UnifiedPosition")
end

--=========================================================
-- OnEvent
--=========================================================
function CaiLiaoCompound_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == 201812031 ) then
		local nOpType 	= Get_XParam_INT(0)
		local objid 	= Get_XParam_INT(1)
		-- ���ϰ����� 2019-10-29 12:19:36 ��ң��
		g_CaiLiaoCompound_DataPool[20502001] = Get_XParam_INT(2)
		g_CaiLiaoCompound_DataPool[20502002] = Get_XParam_INT(3)
		g_CaiLiaoCompound_DataPool[20502003] = Get_XParam_INT(4)
		--
		g_CaiLiaoCompound_DataPool[20501001] = Get_XParam_INT(5)
		g_CaiLiaoCompound_DataPool[20501002] = Get_XParam_INT(6)
		g_CaiLiaoCompound_DataPool[20501003] = Get_XParam_INT(7)
		--
		g_CaiLiaoCompound_DataPool[20500001] = Get_XParam_INT(8)
		g_CaiLiaoCompound_DataPool[20500002] = Get_XParam_INT(9)
		g_CaiLiaoCompound_DataPool[20500003] = Get_XParam_INT(10)
		-- �رս���
		if objid == nil or objid < 0 then
			if this:IsVisible() then
				CaiLiaoCompound_Close()
			end
		else
			-- ��ˢ�½���
			if 2 == nOpType and this:IsVisible() then
				CaiLiaoCompound_Update(0)
				if g_CaiLiaoCompound_Select >= 0 then
					CaiLiaoCompound_List : SetItemSelectByItemID(g_CaiLiaoCompound_Select)
				end
				return
			end
			-- �򿪽���
			-- ��עnpc
			npcObjId = objid
			objCared = DataPool : GetNPCIDByServerID(tonumber(objid))
			this:CareObject(objCared, 1, "CaiLiaoCompound")
			-- ��ʾ����
			this:Show()
			CaiLiaoCompound_Update(1)
		end
	elseif ( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() ) then
		CaiLiaoCompound_Update(0)
		if g_CaiLiaoCompound_Select >= 0 then
			CaiLiaoCompound_List : SetItemSelectByItemID(g_CaiLiaoCompound_Select)
		end
	elseif ( event == "OBJECT_CARED_EVENT" ) then
		if(tonumber(arg0) ~= objCared) then
			return
		end
		-- �����NPC�ľ������һ��������߱�ɾ�����Զ��ر�
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			-- �رս���
			CaiLiaoCompound_Close()
		end	
	elseif ( event == "HIDE_ON_SCENE_TRANSED" ) then
		-- �رս���
		CaiLiaoCompound_Close()
	-- ��Ǯ���
	elseif event == "UNIT_MONEY" or event == "MONEYJZ_CHANGE" then
		CaiLiaoCompound_MoneyUpdate()
	
	elseif (event == "ADJEST_UI_POS" ) then
		CaiLiaoCompoundFrame_On_ResetPos()

	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		CaiLiaoCompoundFrame_On_ResetPos()
	end
end

--=========================================================
-- �رս��棺�ű����ֹر��߼�����n�� ����رս������һ��
--=========================================================
function CaiLiaoCompound_Close()
	-- �������
	g_CaiLiaoCompound_Num = 0--����ѡ���ܸ���
	g_CaiLiaoCompound_Select = -1--Ĭ��ѡ�ж����˵��±�
	g_CaiLiaoCompound_Index = {}--Ĭ��ѡ�ж����˵��±��Ӧ�����ͺͶ����±�
	g_CurNum_PerTime = 1
	for i=1, table.getn(g_CaiLiaoCompound_Info) do	
		g_CaiLiaoCompound_Info[i].bShow = 0
	end
	
	this:Hide()
	-- ȡ������
	this:CareObject(objCared, 0, "CaiLiaoCompound")
	npcObjId = -1
end

--=========================================================
-- ��Ǯˢ�£�������µ���һ�� ��Ǯ�¼�����һ��
--=========================================================
function CaiLiaoCompound_MoneyUpdate()
	CaiLiaoCompound_CurrentlyJiaozi : SetProperty( "MoneyNumber", tostring(Player:GetData("MONEY_JZ")) )
	CaiLiaoCompound_CurrentlyMoney : SetProperty( "MoneyNumber", tostring(Player:GetData("MONEY")) )
end

--=========================================================
-- ������£��������˴򿪻��߸��½������һ��
--=========================================================
function CaiLiaoCompound_Update(bInit)	
	-- ��Ǯ��ʾ
	CaiLiaoCompound_MoneyUpdate()
	
	-- ��ʾ����б�
	CaiLiaoCompound_LeftLoad(bInit)
end

--=========================================================
-- ��ʾ����б� 
--=========================================================
function CaiLiaoCompound_LeftLoad(bInit)
	-- ���Ŀؼ���ʾ
	CaiLiaoCompound_List:ClearListBox()
	g_CaiLiaoCompound_Index = {}
	
	-- ѡ���±�
	local itemNum = 0
	
	-- ����ɺϳ�ѡ��
	for nIndex = 1, table.getn(g_CaiLiaoCompound_Item) do
		local tItem = g_CaiLiaoCompound_Item[nIndex]
		if nil == tItem then
			return
		end
		local tInfo = g_CaiLiaoCompound_Info[nIndex]
		if nil == tInfo then
			return
		end
		-- ����տɺϳ�����
		tInfo.bCanCompound = 0
		for nLevel = 1, table.getn(tItem) - 1 do
			local nHaveCount = g_nHaveCount
			local tSubInfo = tInfo[nLevel]
			if nil == tSubInfo then
				return
			end
				
			if nHaveCount >= 5 then
				tInfo.bCanCompound = 1
				tSubInfo.bCanCompound = 1
			else
				tSubInfo.bCanCompound = 0
			end
		end
	end
	
	-- ��ʾ�б�
	local nHaveShow = 0
	for i=1, table.getn(g_CaiLiaoCompound_Info) do	
		-- һ��ѡ��
		local tInfo = g_CaiLiaoCompound_Info[i]
		if tInfo ~= nil then
			-- �Ƿ���ʾ����ѡ��
			if tInfo.bShow == 1 then	
				nHaveShow = 1
				-- ����һ��ѡ��
				if 1 == tInfo.bCanCompound then
					CaiLiaoCompound_List:AddItem("- "..tInfo.name.."#{CLHC_170904_73}", 10000+i)
				else	
					CaiLiaoCompound_List:AddItem("- "..tInfo.name, 10000+i)
				end
				-- ��ʾ����ѡ��
				for j=1, table.getn(tInfo) do
					-- ����ѡ��
					local tSubInfo = tInfo[j]
					if tSubInfo ~= nil then
						-- ���Ӷ���ѡ��
						if 1 == tSubInfo.bCanCompound then
							CaiLiaoCompound_List:AddItem("  "..tSubInfo.subname.."#{CLHC_170904_73}", itemNum)
						else	
							CaiLiaoCompound_List:AddItem("  "..tSubInfo.subname, itemNum)
						end
						local nItem = {}
						nItem.nIndex = i
						nItem.nSubIndex = j
						table.insert(g_CaiLiaoCompound_Index,nItem)

						-- Ĭ��ѡ����
						if 1 == bInit and itemNum == 0 then
							g_CaiLiaoCompound_Select = itemNum
							CaiLiaoCompound_List : SetItemSelectByItemID(g_CaiLiaoCompound_Select)
						end
						-- ����ѡ���������
						itemNum = itemNum + 1
					end
				end
			else
				-- ����һ��ѡ��
				if 1 == tInfo.bCanCompound then
					CaiLiaoCompound_List:AddItem("+ "..tInfo.name.."#{CLHC_170904_73}", 10000+i)
				else	
					CaiLiaoCompound_List:AddItem("+ "..tInfo.name, 10000+i)
				end			
			end		
		end
	end
	
	-- ���¶���ѡ���ܸ���
	g_CaiLiaoCompound_Num = itemNum
	
	-- ������������
	if 1 == bInit then
		g_CurNum_PerTime = 1
		g_FunControl = 1
		CaiLiaoCompound_HeChengNum:SetText(tostring(g_CurNum_PerTime))
		g_FunControl = 0
	end
	
	-- ����������ť�Ƿ��ʹ��
	if 0 == nHaveShow then
		CaiLiaoCompound_HeChengNum:Disable()
	else
		CaiLiaoCompound_HeChengNum:Enable()
	end
	
	-- ��ʾ�Ҳ�ϳ���Ϣ
	CaiLiaoCompound_ShowDetail(bInit)
end

--=========================================================
-- ����б�ѡ�У����ѡ�����һ��
--=========================================================
function CaiLiaoCompound_ListBox_Selected()
	-- ѡ����
	local nSelIndex = CaiLiaoCompound_List:GetFirstSelectItem()
	if nSelIndex < 0 then
		return
	end

	-- ѡ��һ��ѡ��
	if nSelIndex > 10000 then
		-- һ��ѡ���±�
		local nIndex = nSelIndex-10000
		-- һ��ѡ��
		local tInfo = g_CaiLiaoCompound_Info[nIndex]
		if tInfo ~= nil then
			-- �ı�һ��ѡ��򿪹ر�״̬
			if tInfo.bShow == 1 then
				tInfo.bShow = 0
			else
				-- �ر������б�
				for i=1, table.getn(g_CaiLiaoCompound_Info) do	
					g_CaiLiaoCompound_Info[i].bShow = 0
				end
				-- ��ǰ�б��Ϊ��ʾ
				tInfo.bShow = 1
			end
			-- ���¼����б�
			CaiLiaoCompound_LeftLoad(1)
		end
		return
	end

	-- ����ѡ��
	g_CaiLiaoCompound_Select = nSelIndex
	
	-- ������������
	g_CurNum_PerTime = 1
	g_FunControl = 1
	CaiLiaoCompound_HeChengNum:SetText(tostring(g_CurNum_PerTime))
	g_FunControl = 0
	
	-- ��ʾ�Ҳ�ϳ���Ϣ
	CaiLiaoCompound_ShowDetail(1)
end

--=========================================================
-- ����Ҳ�ϳ���Ϣ
--=========================================================
function CaiLiaoCompound_ClearDetail()
	-- ��ʾ������
	CaiLiaoCompound_ChoiceInfo:SetText( "#{CLHC_170824_20}" )
	CaiLiaoCompound_Item:SetActionItem(-1)
	CaiLiaoCompound_Need_Info:SetText( "#{CLHC_170824_22}" )
	CaiLiaoCompound_Need_Number:SetText( "" )
	CaiLiaoCompound_Have_Info:SetText( "#{CLHC_170824_24}" )
	CaiLiaoCompound_Have_Info:SetToolTip("#{CLHC_170824_25}")
	CaiLiaoCompound_Have_Number:SetText( "" )
	CaiLiaoCompound_DemandMoney:SetProperty("MoneyNumber", 0)

	-- ��ť�û�
	CaiLiaoCompound_OK:Disable()
	CaiLiaoCompound_HeChengNum:Disable()
	CaiLiaoCompound_HeChengNum_MAX:Disable()
	CaiLiaoCompound_Cancel:Disable()
end

--=========================================================
-- �Ҳ�ϳ���Ϣ��ѡ������б����һ��
--=========================================================
function CaiLiaoCompound_ShowDetail(bInit)
	-- �����Ϣ
	CaiLiaoCompound_ClearDetail()
	
	-- ѡ������
	if g_CaiLiaoCompound_Select == nil or g_CaiLiaoCompound_Select < 0 or g_CaiLiaoCompound_Select >= g_CaiLiaoCompound_Num then
		return
	end
	
	-- �±���	
	local tIndex = g_CaiLiaoCompound_Index[g_CaiLiaoCompound_Select+1]
	if tIndex == nil then
		return
	end	
	local nIndex = tIndex.nIndex
	local nSubIndex = tIndex.nSubIndex
	if nIndex == nil or nIndex <= 0 or nSubIndex == nil or nSubIndex <= 0 then
		return
	end

	local tSubData = g_CaiLiaoCompound_Data[nSubIndex]
	if tSubData == nil then
		return
	end	
	local tItem = g_CaiLiaoCompound_Item[nIndex]
	if tItem == nil then
		return
	end	
	local needCount = tSubData.needcount
	if needCount == nil or needCount <= 0 then
		return
	end
	local needMoney = tSubData.needmoney
	if needMoney == nil or needMoney <= 0 then
		return
	end
	local needLevel = tSubData.needlevel
	if needLevel == nil or needLevel <= 0 then
		return
	end
	local needItemId = tItem[needLevel].nItemID
	if needItemId == nil or needItemId <= 0 then
		return
	end
	local newLevel = tSubData.newlevel
	if newLevel == nil or newLevel <= 0 then
		return
	end
	local newItemId = tItem[newLevel].nItemID
	if newItemId == nil or newItemId <= 0 then
		return
	end
	
	local needItemName = tItem[needLevel].strShowName
	if needItemName == nil then
		return
	end
	
	local newItemName = tItem[newLevel].strShowName
	if newItemName == nil then
		return
	end
		
	-- �ϳ���ʾ����
	local szChoiceInfo  = "#cfff263�ϳ�"..newItemName
	CaiLiaoCompound_ChoiceInfo:SetText( szChoiceInfo )

	-- ����չʾ����
	local theAction = GemMelting:UpdateProductAction(newItemId)
	if theAction:GetID() ~= 0 then
		CaiLiaoCompound_Item:SetActionItem(theAction:GetID())
	end
	
	-- ӵ�и�������
	local szHaveInfo = "#cfff263ӵ��#G"..needItemName.."#cfff263��"
	CaiLiaoCompound_Have_Info:SetText( szHaveInfo )
	CaiLiaoCompound_Have_Info:SetToolTip("#{CLHC_170824_25}")
	
	local nHaveCount = 0
	if g_CaiLiaoCompound_DataPool[needItemId] ~= nil then
		nHaveCount = g_CaiLiaoCompound_DataPool[needItemId]
	end
	local szHaveCount = ""
	szHaveCount = "#G"..nHaveCount.."#cfff263��"
	CaiLiaoCompound_Have_Number:SetText( szHaveCount )
	
	-- �ϳ���������
	local nCanCompoundNum = math.floor(nHaveCount / 5)
	
	-- local nHaveMoney = 	Player:GetData("MONEY_JZ") + Player:GetData("MONEY")
	-- local nCanCompoundNumByMoney = math.floor(nHaveMoney / needMoney)
	
	-- if nCanCompoundNum > nCanCompoundNumByMoney then
		-- nCanCompoundNum = nCanCompoundNumByMoney
	-- end
	
	-- ������СΪ1 С��1������Զ�ת��1
	if nCanCompoundNum < 1 then
		nCanCompoundNum = 1
		-- ӵ�и�����ɫ�ж�
		if nHaveCount < 5 then
			szHaveCount = "#cff0000"..nHaveCount.."#cfff263��"
			CaiLiaoCompound_Have_Number:SetText( szHaveCount )
		end
		
		-- ���ť��ʾ
		if -1 == bInit then
			local strNeedItemName = LuaFnGetItemName(needItemId)
			local strNewItemName = LuaFnGetItemName(newItemId)
			local strTips = "#H��������Я����δ��������"..strNeedItemName.."��������5�����޷��ϳ�"..strNewItemName
			PushDebugMessage(strTips)
		end
	end	
	
	-- �Զ��ж�ȡ���ϳ�����
	if g_CurNum_PerTime > nCanCompoundNum then		
		g_CurNum_PerTime = nCanCompoundNum
	end
	
	if 1 == bInit then
		-- ��ʼ������
		g_CurNum_PerTime = 1
		
		-- ӵ�и�����ɫ�ж�
		if nHaveCount < 5 then
			szHaveCount = "#cff0000"..nHaveCount.."#cfff263��"
			CaiLiaoCompound_Have_Number:SetText( szHaveCount )
		end
	end

	local num = tonumber(CaiLiaoCompound_HeChengNum:GetText())
	
	--PushDebugMessage("g_CurNum_PerTime"..g_CurNum_PerTime.."nCanCompoundNum"..nCanCompoundNum.."num"..num)
	if num ~= g_CurNum_PerTime then
		g_FunControl = 1
		CaiLiaoCompound_HeChengNum:SetText(tostring(g_CurNum_PerTime))
		g_FunControl = 0
	end
				
	-- ��Ҫ��������
	local szNeedInfo = "#cfff263��Ҫ#G"..needItemName.."#cfff263��"
	CaiLiaoCompound_Need_Info:SetText( szNeedInfo )
	local szNeedCount = ""
	szNeedCount = "#G"..tostring(g_CurNum_PerTime * 5).."#cfff263��"
	CaiLiaoCompound_Need_Number:SetText( szNeedCount )
	
	-- �ϳ���������
	CaiLiaoCompound_DemandMoney:SetProperty("MoneyNumber", (needMoney * g_CurNum_PerTime))
	
	-- ��ť����
	CaiLiaoCompound_OK:Enable()
	CaiLiaoCompound_HeChengNum:Enable()
	CaiLiaoCompound_HeChengNum_MAX:Enable()
	CaiLiaoCompound_Cancel:Enable()
	
	if 0 == g_CurNum_PerTime then
		CaiLiaoCompound_OK:Disable()
	end
end

function CaiLiaoCompound_OnMaxNum()
	g_CurNum_PerTime = g_MaxNum_PerTime
	-- ��д��Ϊ����ʾ
	CaiLiaoCompound_ShowDetail(-1)
end

function CaiLiaoCompound_OnNumChanged()
	-- ����Ϊ1��ʾ���ڲ����õ��µı������������
	if(1 == g_FunControl) then
		g_FunControl = 0
		return
	end
	
	local num = tonumber(CaiLiaoCompound_HeChengNum:GetText())
	if(nil == num or (num and num < 0)) then
		g_CurNum_PerTime = 0
		return
	end
	if(num > g_MaxNum_PerTime) then
		num = g_MaxNum_PerTime
	end
	g_CurNum_PerTime = num
	CaiLiaoCompound_ShowDetail(0)
end

--=========================================================
-- �ϳ��¼���Ӧ
--=========================================================

function CaiLiaoCompound_OK_Click()
	CaiLiaoCompound_Do()
end

function CaiLiaoCompound_Do()
	-- ѡ������
	if g_CaiLiaoCompound_Select == nil or g_CaiLiaoCompound_Select < 0 or g_CaiLiaoCompound_Select >= g_CaiLiaoCompound_Num then
		PushDebugMessage("#{CLHC_170824_34}")
		return
	end
	
	-- �±���	
	local tIndex = g_CaiLiaoCompound_Index[g_CaiLiaoCompound_Select+1]
	if tIndex == nil then
		PushDebugMessage("#{CLHC_170824_34}")
		return
	end	
	local nIndex = tIndex.nIndex
	local nSubIndex = tIndex.nSubIndex
	if nIndex == nil or nIndex <= 0 or nSubIndex == nil or nSubIndex <= 0 then
		PushDebugMessage("#{CLHC_170824_34}")
		return
	end
		
	-- �ϳɲ���
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("TakeGift");
		Set_XSCRIPT_ScriptID(889103);
		Set_XSCRIPT_Parameter(0,tonumber(-99));
		Set_XSCRIPT_Parameter(1,tonumber(g_CurNum_PerTime));--ÿ�κϳɵ�����
		Set_XSCRIPT_Parameter(2,tonumber(nIndex));--����
		Set_XSCRIPT_Parameter(3,tonumber(nSubIndex))--������
		Set_XSCRIPT_ParamCount(4);
	Send_XSCRIPT();
	
end

function CaiLiaoCompoundFrame_On_ResetPos()
  CaiLiaoCompoundFrame:SetProperty("UnifiedPosition", g_CaiLiaoCompoundFrame_UnifiedPosition)
end