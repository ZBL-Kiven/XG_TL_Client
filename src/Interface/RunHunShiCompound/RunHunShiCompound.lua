-- ���ʯ�ϳɽ��� 20181120
--
local MAX_OBJ_DISTANCE = 3.0
local objCared = -1
local npcObjId = -1

local g_RunHunShiCompound_Page = 0--Ĭ��ѡ������ѷ�ʽ 1����� 2����ͨ
local g_RunHunShiCompound_Num = 0--����ѡ���ܸ���
local g_RunHunShiCompound_Select = -1--Ĭ��ѡ�ж����˵������±�,��0��ʼ
local g_RunHunShiCompound_Index = {}--Ĭ��ѡ�ж����˵��±��Ӧ�����ͺͶ����±�

-- ѡ����Ϣ
local g_RunHunShiCompound_Info = 
{
	[1] = {
		name = "#gFE7E82���ʯ����", typename = "#{RHSYH_161104_35}", bShow = 0, 
		[1] = { subname = "#{RHSYH_161104_07}", },
		[2] = { subname = "#{RHSYH_161104_08}", },
		[3] = { subname = "#{RHSYH_161104_09}", },
		[4] = { subname = "#{RHSYH_161104_10}", },
		[5] = { subname = "#{RHSYH_161104_11}", },
		[6] = { subname = "#{RHSYH_161104_12}", },
		},
	[2] = {
		name = "#{RHSYH_161104_13}", typename = "#{RHSYH_161104_36}", bShow = 0, 
		[1] = { subname = "#{RHSYH_161104_14}", },
		[2] = { subname = "#{RHSYH_161104_15}", },
		[3] = { subname = "#{RHSYH_161104_16}", },
		[4] = { subname = "#{RHSYH_161104_17}", },
		[5] = { subname = "#{RHSYH_161104_18}", },
		[6] = { subname = "#{RHSYH_161104_19}", },
		},
	[3] = {
		name = "#{RHSYH_161104_20}", typename = "#{RHSYH_161104_37}", bShow = 0, 
		[1] = { subname = "#{RHSYH_161104_21}", },
		[2] = { subname = "#{RHSYH_161104_22}", },
		[3] = { subname = "#{RHSYH_161104_23}", },
		[4] = { subname = "#{RHSYH_161104_24}", },
		[5] = { subname = "#{RHSYH_161104_25}", },
		[6] = { subname = "#{RHSYH_161104_26}", },
		},
	[4] = {
		name = "#{RHSYH_161104_27}", typename = "#{RHSYH_161104_38}", bShow = 0, 
		[1] = { subname = "#{RHSYH_161104_28}", },
		[2] = { subname = "#{RHSYH_161104_29}", },
		[3] = { subname = "#{RHSYH_161104_30}", },
		[4] = { subname = "#{RHSYH_161104_31}", },
		[5] = { subname = "#{RHSYH_161104_32}", },
		[6] = { subname = "#{RHSYH_161104_33}", },
		},
}

-- �ϳ���ֵ
local g_RunHunShiCompound_Data = 
{
	-- ���
	[1] = 
	{
		[1] = { newlevel = 2, needlevel = 1, needcount = 3, needmoney = 5000, },
		[2] = { newlevel = 3, needlevel = 1, needcount = 9, needmoney = 20000, },
		[3] = { newlevel = 4, needlevel = 1, needcount = 27, needmoney = 70000, },
		[4] = { newlevel = 5, needlevel = 1, needcount = 81, needmoney = 220000, },
		[5] = { newlevel = 6, needlevel = 1, needcount = 162, needmoney = 455000, },
		[6] = { newlevel = 7, needlevel = 1, needcount = 324, needmoney = 925000, },
	},
	-- ��ͨ
	[2] = 
	{
		[1] = { newlevel = 2, needlevel = 1, needcount = 3, needmoney = 5000, },
		[2] = { newlevel = 3, needlevel = 2, needcount = 3, needmoney = 10000, },
		[3] = { newlevel = 4, needlevel = 3, needcount = 3, needmoney = 10000, },
		[4] = { newlevel = 5, needlevel = 4, needcount = 3, needmoney = 15000, },
		[5] = { newlevel = 6, needlevel = 5, needcount = 2, needmoney = 15000, },
		[6] = { newlevel = 7, needlevel = 6, needcount = 2, needmoney = 20000, },
	},
}

-- ����
local g_RunHunShiCompound_Item = 
{
	[1]=
	{
		20310122,	--���ʯ������1����
		20310123,	--���ʯ������2����
		20310124,	--���ʯ������3����
		20310125,	--���ʯ������4����
		20310126,	--���ʯ������5����
		20310127,	--���ʯ������6����
		20310128,	--���ʯ������7����
		20310129,	--���ʯ������8����
		20310130,	--���ʯ������9����
	},
	[2]=
	{
		20310131,	--���ʯ������1����
		20310132,	--���ʯ������2����
		20310133,	--���ʯ������3����
		20310134,	--���ʯ������4����
		20310135,	--���ʯ������5����
		20310136,	--���ʯ������6����
		20310137,	--���ʯ������7����
		20310138,	--���ʯ������8����
		20310139,	--���ʯ������9����
	},
	[3]=
	{
		20310140,	--���ʯ���ƣ�1����
		20310141,	--���ʯ���ƣ�2����
		20310142,	--���ʯ���ƣ�3����
		20310143,	--���ʯ���ƣ�4����
		20310144,	--���ʯ���ƣ�5����
		20310145,	--���ʯ���ƣ�6����
		20310146,	--���ʯ���ƣ�7����
		20310147,	--���ʯ���ƣ�8����
		20310148,	--���ʯ���ƣ�9����
	},
	[4]=
	{
		20310149,	--���ʯ������1����
		20310150,	--���ʯ������2����
		20310151,	--���ʯ������3����
		20310152,	--���ʯ������4����
		20310153,	--���ʯ������5����
		20310154,	--���ʯ������6����
		20310155,	--���ʯ������7����
		20310156,	--���ʯ������8����
		20310157,	--���ʯ������9����
	},
}

--=========================================================
-- PreLoad
--=========================================================
function RunHunShiCompound_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("OBJECT_CARED_EVENT",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	this:RegisterEvent("PACKAGE_ITEM_CHANGED",false)
	this:RegisterEvent("UNIT_MONEY",false)
	this:RegisterEvent("MONEYJZ_CHANGE",false)
	--this:RegisterEvent("UPDATE_YUANBAO")
end

--=========================================================
-- OnLoad
--=========================================================
function RunHunShiCompound_OnLoad()

end

--=========================================================
-- OnEvent
--=========================================================
function RunHunShiCompound_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == 201811201 ) then
		local objid = Get_XParam_INT(0)
		local nPage = Get_XParam_INT(1)
		-- �رս���
		if objid == nil or objid < 0 or nPage == nil or nPage < 1 or nPage > 2 then
			if this:IsVisible() then
				RunHunShiCompound_Close()
			end
		-- �򿪽���
		else
			-- ��עnpc
			npcObjId = objid
			objCared = DataPool : GetNPCIDByServerID(tonumber(objid))
			this:CareObject(objCared, 1, "RunHunShiCompound")
			-- ��ʾ����
			this:Show()
			--g_RunHunShiCompound_Page = nPage
			RunHunShiCompound_Update(nPage)
		end
	elseif ( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() ) then
		-- ��ˢ�Ҳ�ϳ���Ϣ
		RunHunShiCompound_ShowDetail()
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 201107281 and this:IsVisible()) then
--		if m_Equip_Idx ~= -1 then
--			WuhunMagicUp_Update_Sub( tonumber(arg1) )
--		else 
--			WuhunMagicUp_Update( tonumber(arg1) )
--		end
	elseif ( event == "OBJECT_CARED_EVENT" ) then
		if(tonumber(arg0) ~= objCared) then
			return
		end
		-- �����NPC�ľ������һ��������߱�ɾ�����Զ��ر�
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			-- �رս���
			RunHunShiCompound_Close()
		end	
	elseif ( event == "HIDE_ON_SCENE_TRANSED" ) then
		-- �رս���
		RunHunShiCompound_Close()
	-- ��Ǯ���
	elseif event == "UNIT_MONEY" or event == "MONEYJZ_CHANGE" then
		RunHunShiCompound_MoneyUpdate()
	-- Ԫ�����
	--elseif (event == "UPDATE_YUANBAO" and this:IsVisible()) then
		--RunHunShiCompound_YuanbaoUpdate()
	end
end

--=========================================================
-- �رս��棺�ű����ֹر��߼�����n�� ����رս������һ��
--=========================================================
function RunHunShiCompound_Close()
	-- �������
	g_RunHunShiCompound_Page = 0--Ĭ��ѡ������ѷ�ʽ 1����� 2����ͨ
	g_RunHunShiCompound_Num = 0--����ѡ���ܸ���
	g_RunHunShiCompound_Select = -1--Ĭ��ѡ�ж����˵��±�
	g_RunHunShiCompound_Index = {}--Ĭ��ѡ�ж����˵��±��Ӧ�����ͺͶ����±�
	for i=1, table.getn(g_RunHunShiCompound_Info) do	
		g_RunHunShiCompound_Info[i].bShow = 0
	end
	
	-- �б����
	--RunHunShiCompound_Bk1:CleanAllElement("RunHunShiCompound")
	
	this:Hide()
	-- ȡ������
	this:CareObject(objCared, 0, "RunHunShiCompound")
	npcObjId = -1
end

--=========================================================
-- ��Ǯˢ�£�������µ���һ�� ��Ǯ�¼�����һ��
--=========================================================
function RunHunShiCompound_MoneyUpdate()
	RunHunShiCompound_CurrentlyJiaozi : SetProperty( "MoneyNumber", tostring(Player:GetData("MONEY_JZ")) )
	RunHunShiCompound_CurrentlyMoney : SetProperty( "MoneyNumber", tostring(Player:GetData("MONEY")) )
end

--=========================================================
-- Ԫ��ˢ�£�������µ���һ�� Ԫ���¼�����һ��
--=========================================================
--function RunHunShiCompound_YuanbaoUpdate()
	--RunHunShiCompound_Cost_HaveYuanBaoNum : SetText (tostring(Player:GetData("YUANBAO")))
--end

--=========================================================
-- ������£��������˴򿪻��߸��½������һ��
--=========================================================
function RunHunShiCompound_Update(nPage)	
	-- ��Ǯ��ʾ
	RunHunShiCompound_MoneyUpdate()
	-- Ԫ��
	--RunHunShiCompound_YuanbaoUpdate()
	
	-- �л�ҳǩ
	RunHunShiCompound_SwitchPage(nPage)	
	
	--���ҳǩ
	--g_RunHunShiCompound_Page = 0
	--g_RunHunShiCompound_BtnIndex = 1
	--Ĭ��ѡ�н�Ǯҳ���л�����ҳ
	--local nPage = 1
	--RunHunShiCompound_SwitchPage(nPage)
end

--=========================================================
-- �л���ָ��ҳǩ���򿪽������һ�� ҳǩ��ѡ����һ��
--=========================================================
function RunHunShiCompound_SwitchPage( nPage )
	if nPage == nil or nPage < 1 or nPage > 2 then
		return
	end

	-- ҳǩû��
	if nPage == g_RunHunShiCompound_Page then
		return
	end
	
	-- ȡ��ԭ��ťѡ��
	if g_RunHunShiCompound_Page == 1 then
		RunHunShiCompound_YeQian01:SetCheck(0)
	elseif g_RunHunShiCompound_Page == 2 then
		RunHunShiCompound_YeQian02:SetCheck(0)
	end

	-- �°�ťѡ��
	if nPage == 1 then
		RunHunShiCompound_YeQian01:SetCheck(1)
	elseif nPage == 2 then
		RunHunShiCompound_YeQian02:SetCheck(1)
	end
	
	-- ���浱ǰҳǩ
	g_RunHunShiCompound_Page = nPage
	
	-- ����ҳǩ������Ϣ
	RunHunShiCompound_UpdatePageInfo()
	
	-- ����б����
	RunHunShiCompound_LeftLoad()
end

--=========================================================
-- ����ҳǩ������Ϣ���л�ҳǩ����һ��
--=========================================================
function RunHunShiCompound_UpdatePageInfo()
	if g_RunHunShiCompound_Page == nil or g_RunHunShiCompound_Page < 1 or g_RunHunShiCompound_Page > 2 then
		return
	end
	
	-- ҳǩ1����ݺϳ�
	if g_RunHunShiCompound_Page == 1 then
		-- ��������
		RunHunShiCompound_ExplainInfo:SetText( "#{RHSYH_161104_04}" )
	-- ҳǩ2����ͨ�ϳ�
	elseif g_RunHunShiCompound_Page == 2 then
		-- ��������
		RunHunShiCompound_ExplainInfo:SetText( "    #cfff263�ϳ�#G5������#cfff263��#G���ʯ#cfff263ʱ����Ҫʹ��#G3��#cfff263��ͬ���͡���ͬ�ȼ���#G�ͼ����ʯ#cfff263���кϳɡ��ϳ�#G5��������#cfff263�ȼ���#G���ʯ#cfff263ʱ����Ҫʹ��#G2��#cfff263��ͬ���͡���ͬ�ȼ���#G�ͼ����ʯ#cfff263���кϳɡ�#r    �ϳɲ���#G100%#cfff263�ɹ������кϳ�ʱ�������ȿ۳�#G�󶨵����ʯ#cfff263���Һϳɺ��#G���ʯ#cfff263Ҳ��#G����#cfff263��" )
	end	
		
end

--=========================================================
-- ����б���أ��л�ҳǩ����һ��
--=========================================================
function RunHunShiCompound_LeftLoad()
	
	-- �б����
	RunHunShiCompound_List:ClearListBox()
	g_RunHunShiCompound_Index = {}
	
	-- ѡ���±�
	local itemNum = 0
	
	-- ��ʾ�б�
	for i=1, table.getn(g_RunHunShiCompound_Info) do	
		-- һ��ѡ��
		local tInfo = g_RunHunShiCompound_Info[i]
		if tInfo ~= nil then
			-- �Ƿ���ʾ����ѡ��
			if tInfo.bShow == 1 then				
				-- ����һ��ѡ��
				RunHunShiCompound_List:AddItem("- "..tInfo.name, 10000+i)
				-- ��ʾ����ѡ��
				for j=1, table.getn(tInfo) do
					-- ����ѡ��
					local tSubInfo = tInfo[j]
					if tSubInfo ~= nil then
						-- ���Ӷ���ѡ��
						RunHunShiCompound_List:AddItem("  "..tSubInfo.subname, itemNum)
						--tSubInfo.btnIndex = itemNum
						--g_RunHunShiCompound_Index[itemNum].nIndex = i
						--g_RunHunShiCompound_Index[itemNum].nSubIndex = j
						local nItem = {}
						nItem.nIndex = i
						nItem.nSubIndex = j
						table.insert(g_RunHunShiCompound_Index,nItem)
						-- ѡ��ѡ��
						--if g_RunHunShiCompound_Select == -1 then
							--g_RunHunShiCompound_Select = itemNum
						--end
						--if g_RunHunShiCompound_Select == itemNum then
							--RunHunShiCompound_List : SetItemSelectByItemID(g_RunHunShiCompound_Select)
						--end
						-- Ĭ��ѡ����
						if itemNum == 0 then
							g_RunHunShiCompound_Select = itemNum
							RunHunShiCompound_List : SetItemSelectByItemID(g_RunHunShiCompound_Select)
						end
						-- ����ѡ���������
						itemNum = itemNum + 1
					end
				end
			else
				-- ����һ��ѡ��
				RunHunShiCompound_List:AddItem("+ "..tInfo.name, 10000+i)
			end		
		end
	end
	
	-- ���¶���ѡ���ܸ���
	g_RunHunShiCompound_Num = itemNum
	-- ��ʾ�Ҳ�ϳ���Ϣ
	RunHunShiCompound_ShowDetail()
	
end

--=========================================================
-- ����б�ѡ�У��л�ҳǩ����һ�� ���ѡ�����һ��
--=========================================================
function RunHunShiCompound_ListBox_Selected()
	-- ѡ����
	local nSelIndex = RunHunShiCompound_List:GetFirstSelectItem()
	if nSelIndex < 0 then
		return
	end

	-- ѡ��һ��ѡ��
	if nSelIndex > 10000 then
		-- һ��ѡ���±�
		local nIndex = nSelIndex-10000
		-- һ��ѡ��
		local tInfo = g_RunHunShiCompound_Info[nIndex]
		if tInfo ~= nil then
			-- �ı�һ��ѡ��򿪹ر�״̬
			if tInfo.bShow == 1 then
				tInfo.bShow = 0
			else
				-- �ر������б�
				for i=1, table.getn(g_RunHunShiCompound_Info) do	
					g_RunHunShiCompound_Info[i].bShow = 0
				end
				-- ��ǰ�б��Ϊ��ʾ
				tInfo.bShow = 1
			end
			-- ���¼����б�
			RunHunShiCompound_LeftLoad()
		end
		return
	end

	-- ����ѡ��
	g_RunHunShiCompound_Select = nSelIndex
	
	-- ��ʾ�Ҳ�ϳ���Ϣ
	RunHunShiCompound_ShowDetail()
end

--=========================================================
-- ����Ҳ�ϳ���Ϣ
--=========================================================
function RunHunShiCompound_ClearDetail()
	-- ��ʾ������
	RunHunShiCompound_ChoiceInfo:SetText( "#{RHSYH_161104_39}" )
	RunHunShiCompound_Item:SetActionItem(-1)
	RunHunShiCompound_Need_Info:SetText( "#{RHSYH_161104_40}" )
	RunHunShiCompound_Need_Number:SetText( "" )
	RunHunShiCompound_Have_Info:SetText( "#{RHSYH_161104_41}" )
	RunHunShiCompound_Have_Number:SetText( "" )
	RunHunShiCompound_DemandMoney:SetProperty("MoneyNumber", 0)
	-- ��ť�û�
	RunHunShiCompound_OK:Disable()
	RunHunShiCompound_Cancel:Disable()
end

--=========================================================
-- ���һ������ѡ���±�
--=========================================================
function RunHunShiCompound_GetSubIndex(nBtnIndex)
	if nBtnIndex == nil or nBtnIndex < 0 or nBtnIndex >= g_RunHunShiCompound_Num then
		return 0,0
	end
	
	-- ��ʾ�б�
	for i=1, table.getn(g_RunHunShiCompound_Info) do	
		-- һ��ѡ��
		local tInfo = g_RunHunShiCompound_Info[i]
		if tInfo ~= nil then
			-- ��ʾ����ѡ��
			for j=1, table.getn(tInfo) do
				-- ����ѡ��
				local tSubInfo = tInfo[j]
				if tSubInfo ~= nil then
					if tSubInfo.btnIndex == nBtnIndex then
						return i,j
					end
				end
			end
		end
	end

	return 0,0
end

--=========================================================
-- �Ҳ�ϳ���Ϣ��ѡ������б����һ��
--=========================================================
function RunHunShiCompound_ShowDetail()
	-- �����Ϣ
	RunHunShiCompound_ClearDetail()
	
	-- ҳǩ���
	if g_RunHunShiCompound_Page == nil or g_RunHunShiCompound_Page < 1 or g_RunHunShiCompound_Page > 2 then
		return
	end
	
	-- ѡ������
	if g_RunHunShiCompound_Select == nil or g_RunHunShiCompound_Select < 0 or g_RunHunShiCompound_Select >= g_RunHunShiCompound_Num then
		return
	end
	
	-- �±���	
	local tIndex = g_RunHunShiCompound_Index[g_RunHunShiCompound_Select+1]
	if tIndex == nil then
		return
	end	
	local nIndex = tIndex.nIndex
	local nSubIndex = tIndex.nSubIndex
	if nIndex == nil or nIndex <= 0 or nSubIndex == nil or nSubIndex <= 0 then
		return
	end
	
	-- ���ݼ��
	--local tInfo = g_RunHunShiCompound_Info[nIndex]
	--if tInfo == nil then
		--return
	--end	
	--local tSubInfo = tInfo[nSubIndex]
	--if tSubInfo == nil then
		--return
	--end
	local tData = g_RunHunShiCompound_Data[g_RunHunShiCompound_Page]
	if tData == nil then
		return
	end	
	local tSubData = tData[nSubIndex]
	if tSubData == nil then
		return
	end	
	local tItem = g_RunHunShiCompound_Item[nIndex]
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
	local needItemId = tItem[needLevel]
	if needItemId == nil or needItemId <= 0 then
		return
	end
	local newLevel = tSubData.newlevel
	if newLevel == nil or newLevel <= 0 then
		return
	end
	local newItemId = tItem[newLevel]
	if newItemId == nil or newItemId <= 0 then
		return
	end
	local needItemName = LuaFnGetItemName(needItemId)
    local newItemName = LuaFnGetItemName(newItemId)
	--PushDebugMessage(needItemId)	
    --PushDebugMessage(newItemId)	
	
	--�ϳ���ʾ����
	local szChoiceInfo = ""
	if g_RunHunShiCompound_Page == 1 then
		szChoiceInfo = "#cfff263��ݺϳ�"..newItemName
	elseif g_RunHunShiCompound_Page == 2 then
		szChoiceInfo = "#cfff263�ϳ�"..newItemName
	end
	RunHunShiCompound_ChoiceInfo:SetText( szChoiceInfo )

	--����չʾ����
	local theAction = GemMelting:UpdateProductAction(newItemId)
	if theAction:GetID() ~= 0 then
		RunHunShiCompound_Item:SetActionItem(theAction:GetID())
	end
			
	-- ��Ҫ��������
	RunHunShiCompound_Need_Info:SetText( "#{RHSYH_161104_40}" )
	local szNeedCount = "#G"..needCount.."#cfff263��#G"..needItemName.."#cfff263"
	RunHunShiCompound_Need_Number:SetText( szNeedCount )
	
	--ӵ����Ⱥ������
	RunHunShiCompound_Have_Info:SetText( "#cfff263��Ҫ������Ⱥ�ң�" )
	local nHaveCount = DataPool:GetPlayerMission_DataRound(289)--��ȡ��Ⱥ��
	local szHaveCount = ""
	if nHaveCount >= needCount then
		szHaveCount = "#G"..needCount.."#cfff263��"
	else
		szHaveCount = "#cff0000"..needCount.."#cfff263��"
	end
	RunHunShiCompound_Have_Number:SetText( szHaveCount )
	
	-- �ϳ���������
	RunHunShiCompound_DemandMoney:SetProperty("MoneyNumber", needMoney)
	
	-- ��ť����
	RunHunShiCompound_OK:Enable()
	RunHunShiCompound_Cancel:Enable()

end

--=========================================================
-- �ϳ��¼���Ӧ
--=========================================================
function RunHunShiCompound_HeCheng()
	-- ҳǩ���
	if g_RunHunShiCompound_Page == nil or g_RunHunShiCompound_Page < 1 or g_RunHunShiCompound_Page > 2 then
		PushDebugMessage("#{RHSYH_161104_48}")
		return
	end
	
	-- ѡ������
	if g_RunHunShiCompound_Select == nil or g_RunHunShiCompound_Select < 0 or g_RunHunShiCompound_Select >= g_RunHunShiCompound_Num then
		PushDebugMessage("#{RHSYH_161104_48}")
		return
	end
	
	-- �±���	
	local tIndex = g_RunHunShiCompound_Index[g_RunHunShiCompound_Select+1]
	if tIndex == nil then
		PushDebugMessage("#{RHSYH_161104_48}")
		return
	end	
	local nIndex = tIndex.nIndex
	local nSubIndex = tIndex.nSubIndex
	if nIndex == nil or nIndex <= 0 or nSubIndex == nil or nSubIndex <= 0 then
		PushDebugMessage("#{RHSYH_161104_48}")
		return
	end
		
	-- �ϳɲ���
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("RunHunShiCompound");
		Set_XSCRIPT_ScriptID(900004);
		Set_XSCRIPT_Parameter(0,tonumber(g_RunHunShiCompound_Page));--1���2��ͨ
		Set_XSCRIPT_Parameter(1,tonumber(nIndex));--����
		Set_XSCRIPT_Parameter(2,tonumber(nSubIndex))--������
		Set_XSCRIPT_ParamCount(3);
	Send_XSCRIPT();
end
