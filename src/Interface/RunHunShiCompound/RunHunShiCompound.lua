-- 润魂石合成界面 20181120
--
local MAX_OBJ_DISTANCE = 3.0
local objCared = -1
local npcObjId = -1

local g_RunHunShiCompound_Page = 0--默认选择的消费方式 1：快捷 2：普通
local g_RunHunShiCompound_Num = 0--二级选项总个数
local g_RunHunShiCompound_Select = -1--默认选中二级菜单的总下标,从0开始
local g_RunHunShiCompound_Index = {}--默认选中二级菜单下标对应的类型和二级下标

-- 选项信息
local g_RunHunShiCompound_Info = 
{
	[1] = {
		name = "#gFE7E82润魂石·御", typename = "#{RHSYH_161104_35}", bShow = 0, 
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

-- 合成数值
local g_RunHunShiCompound_Data = 
{
	-- 快捷
	[1] = 
	{
		[1] = { newlevel = 2, needlevel = 1, needcount = 3, needmoney = 5000, },
		[2] = { newlevel = 3, needlevel = 1, needcount = 9, needmoney = 20000, },
		[3] = { newlevel = 4, needlevel = 1, needcount = 27, needmoney = 70000, },
		[4] = { newlevel = 5, needlevel = 1, needcount = 81, needmoney = 220000, },
		[5] = { newlevel = 6, needlevel = 1, needcount = 162, needmoney = 455000, },
		[6] = { newlevel = 7, needlevel = 1, needcount = 324, needmoney = 925000, },
	},
	-- 普通
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

-- 道具
local g_RunHunShiCompound_Item = 
{
	[1]=
	{
		20310122,	--润魂石·御（1级）
		20310123,	--润魂石·御（2级）
		20310124,	--润魂石·御（3级）
		20310125,	--润魂石·御（4级）
		20310126,	--润魂石·御（5级）
		20310127,	--润魂石·御（6级）
		20310128,	--润魂石·御（7级）
		20310129,	--润魂石·御（8级）
		20310130,	--润魂石·御（9级）
	},
	[2]=
	{
		20310131,	--润魂石·击（1级）
		20310132,	--润魂石·击（2级）
		20310133,	--润魂石·击（3级）
		20310134,	--润魂石·击（4级）
		20310135,	--润魂石·击（5级）
		20310136,	--润魂石·击（6级）
		20310137,	--润魂石·击（7级）
		20310138,	--润魂石·击（8级）
		20310139,	--润魂石·击（9级）
	},
	[3]=
	{
		20310140,	--润魂石·破（1级）
		20310141,	--润魂石·破（2级）
		20310142,	--润魂石·破（3级）
		20310143,	--润魂石·破（4级）
		20310144,	--润魂石·破（5级）
		20310145,	--润魂石·破（6级）
		20310146,	--润魂石·破（7级）
		20310147,	--润魂石·破（8级）
		20310148,	--润魂石·破（9级）
	},
	[4]=
	{
		20310149,	--润魂石·暴（1级）
		20310150,	--润魂石·暴（2级）
		20310151,	--润魂石·暴（3级）
		20310152,	--润魂石·暴（4级）
		20310153,	--润魂石·暴（5级）
		20310154,	--润魂石·暴（6级）
		20310155,	--润魂石·暴（7级）
		20310156,	--润魂石·暴（8级）
		20310157,	--润魂石·暴（9级）
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
		-- 关闭界面
		if objid == nil or objid < 0 or nPage == nil or nPage < 1 or nPage > 2 then
			if this:IsVisible() then
				RunHunShiCompound_Close()
			end
		-- 打开界面
		else
			-- 关注npc
			npcObjId = objid
			objCared = DataPool : GetNPCIDByServerID(tonumber(objid))
			this:CareObject(objCared, 1, "RunHunShiCompound")
			-- 显示界面
			this:Show()
			--g_RunHunShiCompound_Page = nPage
			RunHunShiCompound_Update(nPage)
		end
	elseif ( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() ) then
		-- 重刷右侧合成信息
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
		-- 如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			-- 关闭界面
			RunHunShiCompound_Close()
		end	
	elseif ( event == "HIDE_ON_SCENE_TRANSED" ) then
		-- 关闭界面
		RunHunShiCompound_Close()
	-- 金钱变更
	elseif event == "UNIT_MONEY" or event == "MONEYJZ_CHANGE" then
		RunHunShiCompound_MoneyUpdate()
	-- 元宝变更
	--elseif (event == "UPDATE_YUANBAO" and this:IsVisible()) then
		--RunHunShiCompound_YuanbaoUpdate()
	end
end

--=========================================================
-- 关闭界面：脚本各种关闭逻辑调用n次 点击关闭界面调用一次
--=========================================================
function RunHunShiCompound_Close()
	-- 数据清空
	g_RunHunShiCompound_Page = 0--默认选择的消费方式 1：快捷 2：普通
	g_RunHunShiCompound_Num = 0--二级选项总个数
	g_RunHunShiCompound_Select = -1--默认选中二级菜单下标
	g_RunHunShiCompound_Index = {}--默认选中二级菜单下标对应的类型和二级下标
	for i=1, table.getn(g_RunHunShiCompound_Info) do	
		g_RunHunShiCompound_Info[i].bShow = 0
	end
	
	-- 列表清空
	--RunHunShiCompound_Bk1:CleanAllElement("RunHunShiCompound")
	
	this:Hide()
	-- 取消关心
	this:CareObject(objCared, 0, "RunHunShiCompound")
	npcObjId = -1
end

--=========================================================
-- 金钱刷新：界面更新调用一次 金钱事件调用一次
--=========================================================
function RunHunShiCompound_MoneyUpdate()
	RunHunShiCompound_CurrentlyJiaozi : SetProperty( "MoneyNumber", tostring(Player:GetData("MONEY_JZ")) )
	RunHunShiCompound_CurrentlyMoney : SetProperty( "MoneyNumber", tostring(Player:GetData("MONEY")) )
end

--=========================================================
-- 元宝刷新：界面更新调用一次 元宝事件调用一次
--=========================================================
--function RunHunShiCompound_YuanbaoUpdate()
	--RunHunShiCompound_Cost_HaveYuanBaoNum : SetText (tostring(Player:GetData("YUANBAO")))
--end

--=========================================================
-- 界面更新：服务器端打开或者更新界面调用一次
--=========================================================
function RunHunShiCompound_Update(nPage)	
	-- 金钱显示
	RunHunShiCompound_MoneyUpdate()
	-- 元宝
	--RunHunShiCompound_YuanbaoUpdate()
	
	-- 切换页签
	RunHunShiCompound_SwitchPage(nPage)	
	
	--清空页签
	--g_RunHunShiCompound_Page = 0
	--g_RunHunShiCompound_BtnIndex = 1
	--默认选中金钱页并切换到该页
	--local nPage = 1
	--RunHunShiCompound_SwitchPage(nPage)
end

--=========================================================
-- 切换到指定页签：打开界面调用一次 页签点选调用一次
--=========================================================
function RunHunShiCompound_SwitchPage( nPage )
	if nPage == nil or nPage < 1 or nPage > 2 then
		return
	end

	-- 页签没变
	if nPage == g_RunHunShiCompound_Page then
		return
	end
	
	-- 取消原按钮选中
	if g_RunHunShiCompound_Page == 1 then
		RunHunShiCompound_YeQian01:SetCheck(0)
	elseif g_RunHunShiCompound_Page == 2 then
		RunHunShiCompound_YeQian02:SetCheck(0)
	end

	-- 新按钮选中
	if nPage == 1 then
		RunHunShiCompound_YeQian01:SetCheck(1)
	elseif nPage == 2 then
		RunHunShiCompound_YeQian02:SetCheck(1)
	end
	
	-- 保存当前页签
	g_RunHunShiCompound_Page = nPage
	
	-- 加载页签具体信息
	RunHunShiCompound_UpdatePageInfo()
	
	-- 左侧列表加载
	RunHunShiCompound_LeftLoad()
end

--=========================================================
-- 加载页签具体信息：切换页签调用一次
--=========================================================
function RunHunShiCompound_UpdatePageInfo()
	if g_RunHunShiCompound_Page == nil or g_RunHunShiCompound_Page < 1 or g_RunHunShiCompound_Page > 2 then
		return
	end
	
	-- 页签1：快捷合成
	if g_RunHunShiCompound_Page == 1 then
		-- 介绍文字
		RunHunShiCompound_ExplainInfo:SetText( "#{RHSYH_161104_04}" )
	-- 页签2：普通合成
	elseif g_RunHunShiCompound_Page == 2 then
		-- 介绍文字
		RunHunShiCompound_ExplainInfo:SetText( "    #cfff263合成#G5级以下#cfff263的#G润魂石#cfff263时，需要使用#G3颗#cfff263相同类型、相同等级的#G低级润魂石#cfff263进行合成。合成#G5级及以上#cfff263等级的#G润魂石#cfff263时，需要使用#G2颗#cfff263相同类型、相同等级的#G低级润魂石#cfff263进行合成。#r    合成操作#G100%#cfff263成功。进行合成时，将优先扣除#G绑定的润魂石#cfff263，且合成后的#G润魂石#cfff263也将#G被绑定#cfff263。" )
	end	
		
end

--=========================================================
-- 左侧列表加载：切换页签调用一次
--=========================================================
function RunHunShiCompound_LeftLoad()
	
	-- 列表清空
	RunHunShiCompound_List:ClearListBox()
	g_RunHunShiCompound_Index = {}
	
	-- 选项下标
	local itemNum = 0
	
	-- 显示列表
	for i=1, table.getn(g_RunHunShiCompound_Info) do	
		-- 一级选项
		local tInfo = g_RunHunShiCompound_Info[i]
		if tInfo ~= nil then
			-- 是否显示二级选项
			if tInfo.bShow == 1 then				
				-- 增加一级选项
				RunHunShiCompound_List:AddItem("- "..tInfo.name, 10000+i)
				-- 显示二级选项
				for j=1, table.getn(tInfo) do
					-- 二级选项
					local tSubInfo = tInfo[j]
					if tSubInfo ~= nil then
						-- 增加二级选项
						RunHunShiCompound_List:AddItem("  "..tSubInfo.subname, itemNum)
						--tSubInfo.btnIndex = itemNum
						--g_RunHunShiCompound_Index[itemNum].nIndex = i
						--g_RunHunShiCompound_Index[itemNum].nSubIndex = j
						local nItem = {}
						nItem.nIndex = i
						nItem.nSubIndex = j
						table.insert(g_RunHunShiCompound_Index,nItem)
						-- 选中选项
						--if g_RunHunShiCompound_Select == -1 then
							--g_RunHunShiCompound_Select = itemNum
						--end
						--if g_RunHunShiCompound_Select == itemNum then
							--RunHunShiCompound_List : SetItemSelectByItemID(g_RunHunShiCompound_Select)
						--end
						-- 默认选中项
						if itemNum == 0 then
							g_RunHunShiCompound_Select = itemNum
							RunHunShiCompound_List : SetItemSelectByItemID(g_RunHunShiCompound_Select)
						end
						-- 二级选项计数增加
						itemNum = itemNum + 1
					end
				end
			else
				-- 增加一级选项
				RunHunShiCompound_List:AddItem("+ "..tInfo.name, 10000+i)
			end		
		end
	end
	
	-- 更新二级选项总个数
	g_RunHunShiCompound_Num = itemNum
	-- 显示右侧合成信息
	RunHunShiCompound_ShowDetail()
	
end

--=========================================================
-- 左侧列表选中：切换页签调用一次 点击选项调用一次
--=========================================================
function RunHunShiCompound_ListBox_Selected()
	-- 选中项
	local nSelIndex = RunHunShiCompound_List:GetFirstSelectItem()
	if nSelIndex < 0 then
		return
	end

	-- 选中一级选项
	if nSelIndex > 10000 then
		-- 一级选项下标
		local nIndex = nSelIndex-10000
		-- 一级选项
		local tInfo = g_RunHunShiCompound_Info[nIndex]
		if tInfo ~= nil then
			-- 改变一级选项打开关闭状态
			if tInfo.bShow == 1 then
				tInfo.bShow = 0
			else
				-- 关闭其他列表
				for i=1, table.getn(g_RunHunShiCompound_Info) do	
					g_RunHunShiCompound_Info[i].bShow = 0
				end
				-- 当前列表变为显示
				tInfo.bShow = 1
			end
			-- 重新加载列表
			RunHunShiCompound_LeftLoad()
		end
		return
	end

	-- 更新选项
	g_RunHunShiCompound_Select = nSelIndex
	
	-- 显示右侧合成信息
	RunHunShiCompound_ShowDetail()
end

--=========================================================
-- 清空右侧合成信息
--=========================================================
function RunHunShiCompound_ClearDetail()
	-- 显示空内容
	RunHunShiCompound_ChoiceInfo:SetText( "#{RHSYH_161104_39}" )
	RunHunShiCompound_Item:SetActionItem(-1)
	RunHunShiCompound_Need_Info:SetText( "#{RHSYH_161104_40}" )
	RunHunShiCompound_Need_Number:SetText( "" )
	RunHunShiCompound_Have_Info:SetText( "#{RHSYH_161104_41}" )
	RunHunShiCompound_Have_Number:SetText( "" )
	RunHunShiCompound_DemandMoney:SetProperty("MoneyNumber", 0)
	-- 按钮置灰
	RunHunShiCompound_OK:Disable()
	RunHunShiCompound_Cancel:Disable()
end

--=========================================================
-- 获得一级二级选项下标
--=========================================================
function RunHunShiCompound_GetSubIndex(nBtnIndex)
	if nBtnIndex == nil or nBtnIndex < 0 or nBtnIndex >= g_RunHunShiCompound_Num then
		return 0,0
	end
	
	-- 显示列表
	for i=1, table.getn(g_RunHunShiCompound_Info) do	
		-- 一级选项
		local tInfo = g_RunHunShiCompound_Info[i]
		if tInfo ~= nil then
			-- 显示二级选项
			for j=1, table.getn(tInfo) do
				-- 二级选项
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
-- 右侧合成信息：选中左侧列表调用一次
--=========================================================
function RunHunShiCompound_ShowDetail()
	-- 清空信息
	RunHunShiCompound_ClearDetail()
	
	-- 页签检测
	if g_RunHunShiCompound_Page == nil or g_RunHunShiCompound_Page < 1 or g_RunHunShiCompound_Page > 2 then
		return
	end
	
	-- 选中项检测
	if g_RunHunShiCompound_Select == nil or g_RunHunShiCompound_Select < 0 or g_RunHunShiCompound_Select >= g_RunHunShiCompound_Num then
		return
	end
	
	-- 下标检测	
	local tIndex = g_RunHunShiCompound_Index[g_RunHunShiCompound_Select+1]
	if tIndex == nil then
		return
	end	
	local nIndex = tIndex.nIndex
	local nSubIndex = tIndex.nSubIndex
	if nIndex == nil or nIndex <= 0 or nSubIndex == nil or nSubIndex <= 0 then
		return
	end
	
	-- 数据检测
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
	
	--合成提示区域
	local szChoiceInfo = ""
	if g_RunHunShiCompound_Page == 1 then
		szChoiceInfo = "#cfff263快捷合成"..newItemName
	elseif g_RunHunShiCompound_Page == 2 then
		szChoiceInfo = "#cfff263合成"..newItemName
	end
	RunHunShiCompound_ChoiceInfo:SetText( szChoiceInfo )

	--道具展示区域
	local theAction = GemMelting:UpdateProductAction(newItemId)
	if theAction:GetID() ~= 0 then
		RunHunShiCompound_Item:SetActionItem(theAction:GetID())
	end
			
	-- 需要个数区域
	RunHunShiCompound_Need_Info:SetText( "#{RHSYH_161104_40}" )
	local szNeedCount = "#G"..needCount.."#cfff263个#G"..needItemName.."#cfff263"
	RunHunShiCompound_Need_Number:SetText( szNeedCount )
	
	--拥有利群币区域
	RunHunShiCompound_Have_Info:SetText( "#cfff263需要花费利群币：" )
	local nHaveCount = DataPool:GetPlayerMission_DataRound(289)--获取利群币
	local szHaveCount = ""
	if nHaveCount >= needCount then
		szHaveCount = "#G"..needCount.."#cfff263点"
	else
		szHaveCount = "#cff0000"..needCount.."#cfff263点"
	end
	RunHunShiCompound_Have_Number:SetText( szHaveCount )
	
	-- 合成消耗区域
	RunHunShiCompound_DemandMoney:SetProperty("MoneyNumber", needMoney)
	
	-- 按钮启用
	RunHunShiCompound_OK:Enable()
	RunHunShiCompound_Cancel:Enable()

end

--=========================================================
-- 合成事件响应
--=========================================================
function RunHunShiCompound_HeCheng()
	-- 页签检测
	if g_RunHunShiCompound_Page == nil or g_RunHunShiCompound_Page < 1 or g_RunHunShiCompound_Page > 2 then
		PushDebugMessage("#{RHSYH_161104_48}")
		return
	end
	
	-- 选中项检测
	if g_RunHunShiCompound_Select == nil or g_RunHunShiCompound_Select < 0 or g_RunHunShiCompound_Select >= g_RunHunShiCompound_Num then
		PushDebugMessage("#{RHSYH_161104_48}")
		return
	end
	
	-- 下标检测	
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
		
	-- 合成操作
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("RunHunShiCompound");
		Set_XSCRIPT_ScriptID(900004);
		Set_XSCRIPT_Parameter(0,tonumber(g_RunHunShiCompound_Page));--1快捷2普通
		Set_XSCRIPT_Parameter(1,tonumber(nIndex));--类型
		Set_XSCRIPT_Parameter(2,tonumber(nSubIndex))--子类型
		Set_XSCRIPT_ParamCount(3);
	Send_XSCRIPT();
end
