-- 材料合成界面 2017-8-25 lishilong
--
local MAX_OBJ_DISTANCE = 3.0
local objCared = -1
local npcObjId = -1

local g_CaiLiaoCompound_Num 	= 0		-- 二级选项总个数
local g_CaiLiaoCompound_Select 	= -1	-- 默认选中二级菜单的总下标,从0开始
local g_CaiLiaoCompound_Index 	= {}	-- 默认选中二级菜单下标对应的类型和二级下标

local g_MaxNum_PerTime 			= 7500	-- 合成最大数量
local g_CurNum_PerTime			= 1		-- 当前合成数量
local g_FunControl				= 0		-- 防止循环调用的函数控制参数

local g_CaiLiaoCompoundFrame_UnifiedPosition
local g_nHaveCount = 0
-- 选项信息
local g_CaiLiaoCompound_Info = 
{
	[1] = {		--		秘银
		name = "#{CLHC_170824_04}", bShow = 0, bCanCompound = 0,
		[1] = { subname = "#{CLHC_170824_05}", bCanCompound = 0},
		[2] = { subname = "#{CLHC_170824_06}", bCanCompound = 0},
		[3] = { subname = "#{CLHC_170824_07}", bCanCompound = 0},
		[4] = { subname = "#{CLHC_170824_08}", bCanCompound = 0},
		},
	[2] = {		--		棉布
		name = "#{CLHC_170824_09}", bShow = 0, bCanCompound = 0,
		[1] = { subname = "#{CLHC_170824_10}", bCanCompound = 0},
		[2] = { subname = "#{CLHC_170824_11}", bCanCompound = 0},
		[3] = { subname = "#{CLHC_170824_12}", bCanCompound = 0},
		[4] = { subname = "#{CLHC_170824_13}", bCanCompound = 0},
		},
	[3] = {		--		精铁
		name = "#{CLHC_170824_14}", bShow = 0, bCanCompound = 0,
		[1] = { subname = "#{CLHC_170824_15}", bCanCompound = 0},
		[2] = { subname = "#{CLHC_170824_16}", bCanCompound = 0},
		[3] = { subname = "#{CLHC_170824_17}", bCanCompound = 0},
		[4] = { subname = "#{CLHC_170824_18}", bCanCompound = 0},
		},
}

-- 合成数值
local g_CaiLiaoCompound_Data = 
{
	-- level1为碎片，level4为3级材料，这样
	[1] = { newlevel = 2, needlevel = 1, needcount = 5, needmoney = 500, },
	[2] = { newlevel = 3, needlevel = 2, needcount = 5, needmoney = 1000, },
	[3] = { newlevel = 4, needlevel = 3, needcount = 5, needmoney = 1500, },
	[4] = { newlevel = 5, needlevel = 4, needcount = 5, needmoney = 5000, },
}

-- 材料包数据
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

-- 道具
local g_CaiLiaoCompound_Item = 
{
	[1]=
	{
		{nItemID = 20502000, strShowName = "#{CLHC_170904_74}"},	--秘银碎片
		{nItemID = 20502001, strShowName = "#{CLHC_170904_77}"},	--1级秘银
		{nItemID = 20502002, strShowName = "#{CLHC_170904_78}"},	--2级秘银
		{nItemID = 20502003, strShowName = "#{CLHC_170904_79}"},	--3级秘银
		{nItemID = 20502004, strShowName = "#{CLHC_170904_80}"},	--4级秘银
	},
	
	[2]=
	{
		{nItemID = 20501000, strShowName = "#{CLHC_170904_75}"},	--棉布碎片
		{nItemID = 20501001, strShowName = "#{CLHC_170904_81}"},	--1级棉布
		{nItemID = 20501002, strShowName = "#{CLHC_170904_82}"},	--2级棉布
		{nItemID = 20501003, strShowName = "#{CLHC_170904_83}"},	--3级棉布
		{nItemID = 20501004, strShowName = "#{CLHC_170904_84}"},	--4级棉布
	},
	
	[3]=
	{
		{nItemID = 20500000, strShowName = "#{CLHC_170904_76}"},	--精铁碎片
		{nItemID = 20500001, strShowName = "#{CLHC_170904_85}"},	--1级精铁
		{nItemID = 20500002, strShowName = "#{CLHC_170904_86}"},	--2级精铁
		{nItemID = 20500003, strShowName = "#{CLHC_170904_87}"},	--3级精铁
		{nItemID = 20500004, strShowName = "#{CLHC_170904_88}"},	--4级精铁
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
		-- 材料包数据 2019-10-29 12:19:36 逍遥子
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
		-- 关闭界面
		if objid == nil or objid < 0 then
			if this:IsVisible() then
				CaiLiaoCompound_Close()
			end
		else
			-- 仅刷新界面
			if 2 == nOpType and this:IsVisible() then
				CaiLiaoCompound_Update(0)
				if g_CaiLiaoCompound_Select >= 0 then
					CaiLiaoCompound_List : SetItemSelectByItemID(g_CaiLiaoCompound_Select)
				end
				return
			end
			-- 打开界面
			-- 关注npc
			npcObjId = objid
			objCared = DataPool : GetNPCIDByServerID(tonumber(objid))
			this:CareObject(objCared, 1, "CaiLiaoCompound")
			-- 显示界面
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
		-- 如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			-- 关闭界面
			CaiLiaoCompound_Close()
		end	
	elseif ( event == "HIDE_ON_SCENE_TRANSED" ) then
		-- 关闭界面
		CaiLiaoCompound_Close()
	-- 金钱变更
	elseif event == "UNIT_MONEY" or event == "MONEYJZ_CHANGE" then
		CaiLiaoCompound_MoneyUpdate()
	
	elseif (event == "ADJEST_UI_POS" ) then
		CaiLiaoCompoundFrame_On_ResetPos()

	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		CaiLiaoCompoundFrame_On_ResetPos()
	end
end

--=========================================================
-- 关闭界面：脚本各种关闭逻辑调用n次 点击关闭界面调用一次
--=========================================================
function CaiLiaoCompound_Close()
	-- 数据清空
	g_CaiLiaoCompound_Num = 0--二级选项总个数
	g_CaiLiaoCompound_Select = -1--默认选中二级菜单下标
	g_CaiLiaoCompound_Index = {}--默认选中二级菜单下标对应的类型和二级下标
	g_CurNum_PerTime = 1
	for i=1, table.getn(g_CaiLiaoCompound_Info) do	
		g_CaiLiaoCompound_Info[i].bShow = 0
	end
	
	this:Hide()
	-- 取消关心
	this:CareObject(objCared, 0, "CaiLiaoCompound")
	npcObjId = -1
end

--=========================================================
-- 金钱刷新：界面更新调用一次 金钱事件调用一次
--=========================================================
function CaiLiaoCompound_MoneyUpdate()
	CaiLiaoCompound_CurrentlyJiaozi : SetProperty( "MoneyNumber", tostring(Player:GetData("MONEY_JZ")) )
	CaiLiaoCompound_CurrentlyMoney : SetProperty( "MoneyNumber", tostring(Player:GetData("MONEY")) )
end

--=========================================================
-- 界面更新：服务器端打开或者更新界面调用一次
--=========================================================
function CaiLiaoCompound_Update(bInit)	
	-- 金钱显示
	CaiLiaoCompound_MoneyUpdate()
	
	-- 显示左侧列表
	CaiLiaoCompound_LeftLoad(bInit)
end

--=========================================================
-- 显示左侧列表 
--=========================================================
function CaiLiaoCompound_LeftLoad(bInit)
	-- 左侧的控件显示
	CaiLiaoCompound_List:ClearListBox()
	g_CaiLiaoCompound_Index = {}
	
	-- 选项下标
	local itemNum = 0
	
	-- 计算可合成选项
	for nIndex = 1, table.getn(g_CaiLiaoCompound_Item) do
		local tItem = g_CaiLiaoCompound_Item[nIndex]
		if nil == tItem then
			return
		end
		local tInfo = g_CaiLiaoCompound_Info[nIndex]
		if nil == tInfo then
			return
		end
		-- 先清空可合成数据
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
	
	-- 显示列表
	local nHaveShow = 0
	for i=1, table.getn(g_CaiLiaoCompound_Info) do	
		-- 一级选项
		local tInfo = g_CaiLiaoCompound_Info[i]
		if tInfo ~= nil then
			-- 是否显示二级选项
			if tInfo.bShow == 1 then	
				nHaveShow = 1
				-- 增加一级选项
				if 1 == tInfo.bCanCompound then
					CaiLiaoCompound_List:AddItem("- "..tInfo.name.."#{CLHC_170904_73}", 10000+i)
				else	
					CaiLiaoCompound_List:AddItem("- "..tInfo.name, 10000+i)
				end
				-- 显示二级选项
				for j=1, table.getn(tInfo) do
					-- 二级选项
					local tSubInfo = tInfo[j]
					if tSubInfo ~= nil then
						-- 增加二级选项
						if 1 == tSubInfo.bCanCompound then
							CaiLiaoCompound_List:AddItem("  "..tSubInfo.subname.."#{CLHC_170904_73}", itemNum)
						else	
							CaiLiaoCompound_List:AddItem("  "..tSubInfo.subname, itemNum)
						end
						local nItem = {}
						nItem.nIndex = i
						nItem.nSubIndex = j
						table.insert(g_CaiLiaoCompound_Index,nItem)

						-- 默认选中项
						if 1 == bInit and itemNum == 0 then
							g_CaiLiaoCompound_Select = itemNum
							CaiLiaoCompound_List : SetItemSelectByItemID(g_CaiLiaoCompound_Select)
						end
						-- 二级选项计数增加
						itemNum = itemNum + 1
					end
				end
			else
				-- 增加一级选项
				if 1 == tInfo.bCanCompound then
					CaiLiaoCompound_List:AddItem("+ "..tInfo.name.."#{CLHC_170904_73}", 10000+i)
				else	
					CaiLiaoCompound_List:AddItem("+ "..tInfo.name, 10000+i)
				end			
			end		
		end
	end
	
	-- 更新二级选项总个数
	g_CaiLiaoCompound_Num = itemNum
	
	-- 单独更新数量
	if 1 == bInit then
		g_CurNum_PerTime = 1
		g_FunControl = 1
		CaiLiaoCompound_HeChengNum:SetText(tostring(g_CurNum_PerTime))
		g_FunControl = 0
	end
	
	-- 设置数量按钮是否可使用
	if 0 == nHaveShow then
		CaiLiaoCompound_HeChengNum:Disable()
	else
		CaiLiaoCompound_HeChengNum:Enable()
	end
	
	-- 显示右侧合成信息
	CaiLiaoCompound_ShowDetail(bInit)
end

--=========================================================
-- 左侧列表选中：点击选项调用一次
--=========================================================
function CaiLiaoCompound_ListBox_Selected()
	-- 选中项
	local nSelIndex = CaiLiaoCompound_List:GetFirstSelectItem()
	if nSelIndex < 0 then
		return
	end

	-- 选中一级选项
	if nSelIndex > 10000 then
		-- 一级选项下标
		local nIndex = nSelIndex-10000
		-- 一级选项
		local tInfo = g_CaiLiaoCompound_Info[nIndex]
		if tInfo ~= nil then
			-- 改变一级选项打开关闭状态
			if tInfo.bShow == 1 then
				tInfo.bShow = 0
			else
				-- 关闭其他列表
				for i=1, table.getn(g_CaiLiaoCompound_Info) do	
					g_CaiLiaoCompound_Info[i].bShow = 0
				end
				-- 当前列表变为显示
				tInfo.bShow = 1
			end
			-- 重新加载列表
			CaiLiaoCompound_LeftLoad(1)
		end
		return
	end

	-- 更新选项
	g_CaiLiaoCompound_Select = nSelIndex
	
	-- 单独更新数量
	g_CurNum_PerTime = 1
	g_FunControl = 1
	CaiLiaoCompound_HeChengNum:SetText(tostring(g_CurNum_PerTime))
	g_FunControl = 0
	
	-- 显示右侧合成信息
	CaiLiaoCompound_ShowDetail(1)
end

--=========================================================
-- 清空右侧合成信息
--=========================================================
function CaiLiaoCompound_ClearDetail()
	-- 显示空内容
	CaiLiaoCompound_ChoiceInfo:SetText( "#{CLHC_170824_20}" )
	CaiLiaoCompound_Item:SetActionItem(-1)
	CaiLiaoCompound_Need_Info:SetText( "#{CLHC_170824_22}" )
	CaiLiaoCompound_Need_Number:SetText( "" )
	CaiLiaoCompound_Have_Info:SetText( "#{CLHC_170824_24}" )
	CaiLiaoCompound_Have_Info:SetToolTip("#{CLHC_170824_25}")
	CaiLiaoCompound_Have_Number:SetText( "" )
	CaiLiaoCompound_DemandMoney:SetProperty("MoneyNumber", 0)

	-- 按钮置灰
	CaiLiaoCompound_OK:Disable()
	CaiLiaoCompound_HeChengNum:Disable()
	CaiLiaoCompound_HeChengNum_MAX:Disable()
	CaiLiaoCompound_Cancel:Disable()
end

--=========================================================
-- 右侧合成信息：选中左侧列表调用一次
--=========================================================
function CaiLiaoCompound_ShowDetail(bInit)
	-- 清空信息
	CaiLiaoCompound_ClearDetail()
	
	-- 选中项检测
	if g_CaiLiaoCompound_Select == nil or g_CaiLiaoCompound_Select < 0 or g_CaiLiaoCompound_Select >= g_CaiLiaoCompound_Num then
		return
	end
	
	-- 下标检测	
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
		
	-- 合成提示区域
	local szChoiceInfo  = "#cfff263合成"..newItemName
	CaiLiaoCompound_ChoiceInfo:SetText( szChoiceInfo )

	-- 道具展示区域
	local theAction = GemMelting:UpdateProductAction(newItemId)
	if theAction:GetID() ~= 0 then
		CaiLiaoCompound_Item:SetActionItem(theAction:GetID())
	end
	
	-- 拥有个数区域
	local szHaveInfo = "#cfff263拥有#G"..needItemName.."#cfff263："
	CaiLiaoCompound_Have_Info:SetText( szHaveInfo )
	CaiLiaoCompound_Have_Info:SetToolTip("#{CLHC_170824_25}")
	
	local nHaveCount = 0
	if g_CaiLiaoCompound_DataPool[needItemId] ~= nil then
		nHaveCount = g_CaiLiaoCompound_DataPool[needItemId]
	end
	local szHaveCount = ""
	szHaveCount = "#G"..nHaveCount.."#cfff263个"
	CaiLiaoCompound_Have_Number:SetText( szHaveCount )
	
	-- 合成数量区域
	local nCanCompoundNum = math.floor(nHaveCount / 5)
	
	-- local nHaveMoney = 	Player:GetData("MONEY_JZ") + Player:GetData("MONEY")
	-- local nCanCompoundNumByMoney = math.floor(nHaveMoney / needMoney)
	
	-- if nCanCompoundNum > nCanCompoundNumByMoney then
		-- nCanCompoundNum = nCanCompoundNumByMoney
	-- end
	
	-- 数量最小为1 小于1的情况自动转成1
	if nCanCompoundNum < 1 then
		nCanCompoundNum = 1
		-- 拥有个数颜色判断
		if nHaveCount < 5 then
			szHaveCount = "#cff0000"..nHaveCount.."#cfff263个"
			CaiLiaoCompound_Have_Number:SetText( szHaveCount )
		end
		
		-- 最大按钮提示
		if -1 == bInit then
			local strNeedItemName = LuaFnGetItemName(needItemId)
			local strNewItemName = LuaFnGetItemName(newItemId)
			local strTips = "#H背包内所携带的未锁定材料"..strNeedItemName.."数量不足5个，无法合成"..strNewItemName
			PushDebugMessage(strTips)
		end
	end	
	
	-- 自动判断取最大合成数量
	if g_CurNum_PerTime > nCanCompoundNum then		
		g_CurNum_PerTime = nCanCompoundNum
	end
	
	if 1 == bInit then
		-- 初始化操作
		g_CurNum_PerTime = 1
		
		-- 拥有个数颜色判断
		if nHaveCount < 5 then
			szHaveCount = "#cff0000"..nHaveCount.."#cfff263个"
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
				
	-- 需要个数区域
	local szNeedInfo = "#cfff263需要#G"..needItemName.."#cfff263："
	CaiLiaoCompound_Need_Info:SetText( szNeedInfo )
	local szNeedCount = ""
	szNeedCount = "#G"..tostring(g_CurNum_PerTime * 5).."#cfff263个"
	CaiLiaoCompound_Need_Number:SetText( szNeedCount )
	
	-- 合成消耗区域
	CaiLiaoCompound_DemandMoney:SetProperty("MoneyNumber", (needMoney * g_CurNum_PerTime))
	
	-- 按钮启用
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
	-- 特写，为了提示
	CaiLiaoCompound_ShowDetail(-1)
end

function CaiLiaoCompound_OnNumChanged()
	-- 控制为1表示是内部调用导致的变更，不做处理
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
-- 合成事件响应
--=========================================================

function CaiLiaoCompound_OK_Click()
	CaiLiaoCompound_Do()
end

function CaiLiaoCompound_Do()
	-- 选中项检测
	if g_CaiLiaoCompound_Select == nil or g_CaiLiaoCompound_Select < 0 or g_CaiLiaoCompound_Select >= g_CaiLiaoCompound_Num then
		PushDebugMessage("#{CLHC_170824_34}")
		return
	end
	
	-- 下标检测	
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
		
	-- 合成操作
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("TakeGift");
		Set_XSCRIPT_ScriptID(889103);
		Set_XSCRIPT_Parameter(0,tonumber(-99));
		Set_XSCRIPT_Parameter(1,tonumber(g_CurNum_PerTime));--每次合成的数量
		Set_XSCRIPT_Parameter(2,tonumber(nIndex));--类型
		Set_XSCRIPT_Parameter(3,tonumber(nSubIndex))--子类型
		Set_XSCRIPT_ParamCount(4);
	Send_XSCRIPT();
	
end

function CaiLiaoCompoundFrame_On_ResetPos()
  CaiLiaoCompoundFrame:SetProperty("UnifiedPosition", g_CaiLiaoCompoundFrame_UnifiedPosition)
end