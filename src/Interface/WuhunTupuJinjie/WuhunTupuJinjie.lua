--!!!reloadscript =WuhunTupuJinjie

local g_WuhunTupuJinjie_UnifiedPosition = ""
local g_MaxBarNum = 100

local g_BarList = {}

local g_CurrentFilter = 0
local g_InitList = 0
local g_CurrentSelWG = 0
local g_MaxCardLevel = 5
local g_NeedChangeScrollSize = 0

local g_strAttrDic = {
[6]="#{equip_attr_attack_cold}",
[9]="#{equip_attr_attack_fire}",
[12]="#{equip_attr_attack_light}",
[15]="#{equip_attr_attack_poison}",
[19]="#{equip_attr_attack_p}",
[26]="#{equip_attr_attack_m}",
}
local g_strEffectDic = {
[0] = "内功攻击",--内功攻击
[1] = "外功攻击",--外功攻击
[2] = "冰属性",--冰属性
[3] = "火属性",--火属性
[4] = "玄属性",--玄属性
[5] = "毒属性",--毒属性
}
local nSpendnMsg = 0
local nWuhunTupuJinjieItem = {}
local nWuhunTupuJinjieItem_Mask = {}
local nServerHaveItemInfo = {}
local nWGID = {40005001,40005002,40005003,40005004,40005005,40005006}
local HunHunCanYe = {
{20800000,20800001},{20800002,20800003},{20800004,20800005},{20800006,20800007},{20800008,20800009},{20800010,20800011}
}
function WuhunTupuJinjie_PreLoad()

	--this:RegisterEvent("OPEN_WHWG")
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("XINGZHEN_UPDATE", false)
	
	this:RegisterEvent("UNIT_MONEY", false)
	this:RegisterEvent("MONEYJZ_CHANGE", false)
	
	--离开场景，自动关闭
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED", false)

	this:RegisterEvent("ADJEST_UI_POS", false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED", false)
	this:RegisterEvent("MONEYJZ_CHANGE", false)

end

function WuhunTupuJinjie_OnLoad()	
	g_WuhunTupuJinjie_UnifiedPosition = WuhunTupuJinjie_Frame:GetProperty("UnifiedPosition")	

	nWuhunTupuJinjieItem[1] = WuhunTupuJinjie_Item_1
	nWuhunTupuJinjieItem[2] = WuhunTupuJinjie_Item_2
	nWuhunTupuJinjieItem[3] = WuhunTupuJinjie_Item_3
	nWuhunTupuJinjieItem[4] = WuhunTupuJinjie_Item_4
	nWuhunTupuJinjieItem[5] = WuhunTupuJinjie_Item_5
	nWuhunTupuJinjieItem[6] = WuhunTupuJinjie_Item_6

	nWuhunTupuJinjieItem_Mask[1] = WuhunTupuJinjie_Item_Mask_1
	nWuhunTupuJinjieItem_Mask[2] = WuhunTupuJinjie_Item_Mask_2
	nWuhunTupuJinjieItem_Mask[3] = WuhunTupuJinjie_Item_Mask_3
	nWuhunTupuJinjieItem_Mask[4] = WuhunTupuJinjie_Item_Mask_4
	nWuhunTupuJinjieItem_Mask[5] = WuhunTupuJinjie_Item_Mask_5
	nWuhunTupuJinjieItem_Mask[6] = WuhunTupuJinjie_Item_Mask_6	
end

function WuhunTupuJinjie_OnEvent(event)

	if event == "UI_COMMAND" and tonumber(arg0) == 88880003 then
		if IsWindowShow("WuhunTupuActive") or IsWindowShow("WuhunTupuStudy") then
			CloseWindow("WuhunTupuActive", true);
			CloseWindow("WuhunTupuStudy", true);
		end	
		nServerHaveItemInfo = {}
		for i = 1,6 do
			nServerHaveItemInfo[i] = Split(Get_XParam_STR(i-1), ",")
		end	
		this:Show()
		--g_CurrentSelWG = 0
		--m_ItemBagIndex = -1
		--OpenWindow("Packet")
		local objid= Get_XParam_INT(0)
		if objid~=-1 then
			WuhunTupuJinjie_BeginCareObj(objid)
		end
		WuhunTupuJinjie_Update()
	elseif event == "HIDE_ON_SCENE_TRANSED" then
		this:Hide()
	elseif event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		WuhunTupuJinjie_On_ResetPos()
	elseif event == "UNIT_MONEY" then
		WuhunTupuJinjie_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
	elseif event == "MONEYJZ_CHANGE" then 
		WuhunTupuJinjie_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
	elseif event == "UI_COMMAND" and tonumber(arg0) == 38880003 then
		WuhunTupuJinjie_Update()
	end
end

function WuhunTupuJinjie_InitListBar()	
	if g_InitList == 0 then		
		g_MaxBarNum = DataPool:LuaFnGetWHWGMaxCount()
		for i = 1, g_MaxBarNum do
			local bar = WuhunTupuJinjie_Item_Lace:AddChild("WuhunTupuJinjie_ItemBK")
			bar:SetProperty("SuperBarButtonHover","SuperBarHoverSection")
			g_BarList[i] = bar	
			bar:GetSubItem("WuhunTupuJinjie_Item"):SetEvent("MouseLButtonDown", string.format("WuhunTupuJinjie_ItemClicked(%d)", i))
		end	
		g_InitList = 1
	end
end

--刷新
function WuhunTupuJinjie_Update()	
	
	-- WuhunTupuJinjie_InitListBar()
	
	WuhunTupuJinjie_ListCleanUpAction()
	-- DataPool:LuaFnInitWHWGList()
	local nCount = 6
	
	for i = 1, 6 do
		-- WuhunTupuJinjie_SetItem(i, nCount)
		local nItemID = LuaFnGetWHWGIDFromList(i)
		local nUnLocked = LuaFnGetWHWGInfo(i, "UnLocked")
		local theAction = GemMelting:UpdateProductAction(nItemID)
		if nUnLocked == 0 then
			nWuhunTupuJinjieItem_Mask[i]:Show()
		else
			nWuhunTupuJinjieItem_Mask[i]:Hide()
		end
		if theAction ~= 0 then
			nWuhunTupuJinjieItem[i]:SetActionItem(theAction:GetID())
		end		
	end
	
	-- if g_NeedChangeScrollSize == 1 then		
		-- WuhunTupuJinjie_Item_Lace:RefreshLayout()
		-- WuhunTupuJinjie_Item_Lace:SetScrollPosition(0)
		-- g_NeedChangeScrollSize = 0
	-- end
	WuhunTupuJinjie_UpdateSel()
	
	WuhunTupuJinjie_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
	WuhunTupuJinjie_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
end

function WuhunTupuJinjie_UpdateSel()

	if g_CurrentSelWG ~= 0 then

		--图谱名字
		local strName =LuaFnGetWHWGInfo(g_CurrentSelWG, "Name")
		local strTemp = strName
		local strText = "#cfff263幻魂名称："..strTemp
		WuhunTupuJinjie_ItemInfo1:SetText(strText)
		local nItemID = LuaFnGetWHWGIDFromList(g_CurrentSelWG)
		local theAction = GemMelting:UpdateProductAction(nItemID)
		if theAction:GetID() ~= 0 then
			WuhunTupuJinjie_ItemIcon:SetActionItem(theAction:GetID())
		end

		local nTPGrade = LuaFnGetWHWGInfo(g_CurrentSelWG, "Grade")
		local nTPLevel = LuaFnGetWHWGInfo(g_CurrentSelWG, "Level")
		--激活与否
		local nUnLocked = LuaFnGetWHWGInfo(g_CurrentSelWG, "UnLocked")
		if nUnLocked == 0 then
			WuhunTupuJinjie_Need_Object_Number:SetText("")
			WuhunTupuJinjie_Need_Object:SetActionItem(-1)
			WuhunTupuJinjie_DemandMoney:SetProperty("MoneyNumber", "0")
			WuhunTupuJinjie_Item_EffectBK:Hide()
			WuhunTupuJinjie_EffectNone:SetText("#cfff263未激活该幻魂")
		else
			if nTPGrade==10 then
				WuhunTupuJinjie_DemandMoney:SetProperty("MoneyNumber", tostring(0))
				WuhunTupuJinjie_Need_Object:SetActionItem(-1)
				WuhunTupuJinjie_Need_Object_Number:SetText("")
				WuhunTupuJinjie_Item_EffectBK:Hide()
				WuhunTupuJinjie_EffectNone:SetText("#cfff263该幻魂已达满级。")
			elseif nTPLevel==10 then
				--正常显示
				WuhunTupuJinjie_Item_EffectBK:Show()
				WuhunTupuJinjie_EffectNone:SetText("")

				WuhunTupuJinjie_EffectLevel:SetText( string.format("#cfff263%s阶%s级", nTPGrade, nTPLevel) )
				local need_itembind,need_itemunbind = LuaFnGetWHWGLevelInfo(g_CurrentSelWG,nTPGrade,10,"LevelItem")
				local need_itemcount = LuaFnGetWHWGLevelInfo(g_CurrentSelWG,nTPGrade,10,"LevelItemCount")
				local need_money = LuaFnGetWHWGLevelInfo(g_CurrentSelWG,nTPGrade,10,"LevelCost")

				WuhunTupuJinjie_DemandMoney:SetProperty("MoneyNumber", tostring(need_money))
				--当前等级属性
				local attr_yang,attrvalue_yang,effecttype_yang,effectvalue_yang = LuaFnGetWHWGLevelInfo(g_CurrentSelWG,nTPGrade,10,"AttrEffectYang")
				local attr_yin,attrvalue_yin,effecttype_yin,effectvalue_yin = LuaFnGetWHWGLevelInfo(g_CurrentSelWG,nTPGrade,10,"AttrEffectYin")
				local wszattr,wszattrvalue = LuaFnGetWHWGLevelInfo(g_CurrentSelWG,nTPGrade,10,"wszAttr")
				WuhunTupuJinjie_Effect1:SetText(g_strAttrDic[attr_yang].."+"..attrvalue_yang)
				WuhunTupuJinjie_Effect2:SetText( string.format("%s伤害增加%.2f%%", g_strEffectDic[effecttype_yang],tostring(0.01*effectvalue_yang)) )
				WuhunTupuJinjie_Effect3:SetText(g_strAttrDic[attr_yin].."+"..attrvalue_yin)
				WuhunTupuJinjie_Effect4:SetText( string.format("受%s伤害降低%.2f%%", g_strEffectDic[effecttype_yin],tostring(0.01*effectvalue_yin)) )
				WuhunTupuJinjie_Effect5:SetText(g_strAttrDic[wszattr].."+"..wszattrvalue)
				--有没有道具
				local nHaveCount1 = tonumber(nServerHaveItemInfo[g_CurrentSelWG][1])
				local nHaveCount2 = tonumber(nServerHaveItemInfo[g_CurrentSelWG][2])
				if nHaveCount1>0 then
					local showAction = GemMelting:UpdateProductAction(HunHunCanYe[g_CurrentSelWG][1])
					if showAction:GetID() ~= 0 then
						WuhunTupuJinjie_Need_Object:SetActionItem(showAction:GetID())
					end
				else
					local showAction = GemMelting:UpdateProductAction(HunHunCanYe[g_CurrentSelWG][2])
					if showAction:GetID() ~= 0 then
						WuhunTupuJinjie_Need_Object:SetActionItem(showAction:GetID())
					end
				end
				local szHaveCount = ""
				if nHaveCount1+nHaveCount2 >= need_itemcount then
					szHaveCount = string.format("#G%s", need_itemcount)
				else
					szHaveCount = string.format("#cff0000%s", need_itemcount)
				end
				WuhunTupuJinjie_Need_Object_Number:SetText(szHaveCount)
				--下一阶
				local attr_yang,attrvalue_yang,effecttype_yang,effectvalue_yang = LuaFnGetWHWGLevelInfo(g_CurrentSelWG,nTPGrade+1,0,"nExtAttrEffectYang")
				local attr_yin,attrvalue_yin,effecttype_yin,effectvalue_yin = LuaFnGetWHWGLevelInfo(g_CurrentSelWG,nTPGrade+1,0,"nExtAttrEffectYin")
				local wszattr,wszattrvalue = LuaFnGetWHWGLevelInfo(g_CurrentSelWG,nTPGrade+1,0,"nExtwszAttr")
				WuhunTupuJinjie_Effect1Plus:SetText( string.format("%s", attrvalue_yang) )
				WuhunTupuJinjie_Effect2Plus:SetText( string.format("%.2f%%", tostring(0.01*effectvalue_yang)) )
				WuhunTupuJinjie_Effect3Plus:SetText( string.format("%s", attrvalue_yin) )
				WuhunTupuJinjie_Effect4Plus:SetText( string.format("%.2f%%", tostring(0.01*effectvalue_yin)) )
				WuhunTupuJinjie_Effect5Plus:SetText("+"..wszattrvalue)
				WuhunTupuJinjie_EffectNone:SetText("")
				WuhunTupuJinjie_EffectLevelPluse:SetText( string.format("#cfff263%s阶%s级", nTPGrade+1, 0) )
			else
				WuhunTupuJinjie_Need_Object_Number:SetText("")
				WuhunTupuJinjie_Need_Object:SetActionItem(-1)
				WuhunTupuJinjie_DemandMoney:SetProperty("MoneyNumber", "0")
				WuhunTupuJinjie_Item_EffectBK:Hide()
				WuhunTupuJinjie_EffectNone:SetText(string.format("#cfff263%s阶%s级可进阶", nTPGrade, 10))
			end
		end
	else
		WuhunTupuJinjie_ItemInfo1:SetText("#cfff263幻魂名称：")

		WuhunTupuJinjie_EffectLevel:SetText("")--当前等级：空
		WuhunTupuJinjie_EffectLevelPluse:SetText("")--升级等级：空
		
		WuhunTupuJinjie_Item_EffectBK:Hide()
		WuhunTupuJinjie_EffectNone:SetText("")
		
		WuhunTupuJinjie_ItemIcon:SetActionItem(-1)
		WuhunTupuJinjie_DemandMoney:SetProperty("MoneyNumber", "0")
		WuhunTupuJinjie_Need_Object:SetActionItem(-1)
		WuhunTupuJinjie_Need_Object_Number:SetText("")
	end
end

function WuhunTupuJinjie_SetItem(idx, max_count)

	if g_BarList[idx] == nil then
		return
	end
	
	if idx > max_count then
		g_BarList[idx]:Hide()
		return
	end
	
	local bar = g_BarList[idx]
	bar:Show()
	
	local wgID = DataPool:LuaFnGetWHWGIDFromList(idx - 1)
	local nUnLocked = DataPool:LuaFnGetWHWGInfo(wgID, "UnLocked")
	local nLevel = DataPool:LuaFnGetWHWGInfo(wgID, "Level")
	local nGrade = DataPool:LuaFnGetWHWGInfo(wgID, "Grade")
	local strName = DataPool:LuaFnGetWHWGInfo(wgID, "Name")

	--激活锁
	if nUnLocked == 1 then
		bar:GetSubItem("WuhunTupuJinjie_Item_Mask"):Hide()
	else
		bar:GetSubItem("WuhunTupuJinjie_Item_Mask"):Show()
	end

	local ctrlAction = bar:GetSubItem("WuhunTupuJinjie_Item")
	if ctrlAction ~= nil then

		ctrlAction:SetActionItem(-1)
		
		local theAction = EnumAction(wgID, "whwg")
		if theAction:GetID() ~= 0 then
			ctrlAction:SetActionItem(theAction:GetID())
		end
	
		ctrlAction:SetProperty("DraggingEnabled", "False")
		
		if wgID == g_CurrentSelWG then
			ctrlAction:SetPushed(1)
		else
			ctrlAction:SetPushed(0)
		end
	end
end

function WuhunTupuJinjie_ItemClicked(nIndex)
	
	-- local wgID = DataPool:LuaFnGetWHWGIDFromList(nIndex - 1)
	-- if g_CurrentSelWG == wgID then
		-- return
	-- end
	
	g_CurrentSelWG = nIndex
	
	for i = 1, 6 do		
		-- if g_BarList[i] ~= nil then	
			-- local ctrlAction = g_BarList[i]:GetSubItem("WuhunTupuJinjie_Item")
			-- if ctrlAction ~= nil then
				if i == nIndex then
					nWuhunTupuJinjieItem[i]:SetPushed(1)
				else
					nWuhunTupuJinjieItem[i]:SetPushed(0)	
				end
			-- end			
		-- end
	end
	
	WuhunTupuJinjie_UpdateSel()
	
end

function WuhunTupuJinjie_GradeUp_Clicked()
	
	-- 判断电话密保和二级密码保护
	-- if CheckPhoneMibaoAndMinorPassword() ~= 1 then			
		-- return
	-- end
	if g_CurrentSelWG == 0 then
		PushDebugMessage("#H请先选中需要进阶的幻魂，再进行该操作。")
		return
	end
	--激活与否
	local nUnLocked = LuaFnGetWHWGInfo(g_CurrentSelWG, "UnLocked")
	if nUnLocked==0 then
		PushDebugMessage("#H该幻魂尚未激活，无法进阶。")
		return
	end
	local nTPGrade = LuaFnGetWHWGInfo(g_CurrentSelWG, "Grade")
	local nTPLevel = LuaFnGetWHWGInfo(g_CurrentSelWG, "Level")
	if nTPGrade==10 then
		PushDebugMessage("#H您选择的幻魂已进阶至满级，无法继续进行进阶操作。")
		return
	end
	if nTPLevel<10 then
		PushDebugMessage("#H该幻魂未达该阶等级上限，无法进阶。")
		return
	end

	local need_itembind,need_itemunbind = LuaFnGetWHWGLevelInfo(g_CurrentSelWG,nTPGrade,nTPLevel,"LevelItem")
	local need_itemcount = LuaFnGetWHWGLevelInfo(g_CurrentSelWG,nTPGrade,nTPLevel,"LevelItemCount")
	local nHaveCount1 = tonumber(nServerHaveItemInfo[g_CurrentSelWG][1])
	local nHaveCount2 = tonumber(nServerHaveItemInfo[g_CurrentSelWG][2])
	if (nHaveCount1+nHaveCount2)<need_itemcount then
		PushDebugMessage("#H进阶材料不足或已加锁。")
		return
	end

	local need_money = LuaFnGetWHWGLevelInfo(g_CurrentSelWG,nTPGrade,nTPLevel,"LevelCost")
	local nHaveMoney = Player:GetData("MONEY")
	local nHaveJiaoZi = Player:GetData("MONEY_JZ")
	if (nHaveMoney+nHaveJiaoZi)<need_money then
		PushDebugMessage("对不起，你身上金钱不足，无法继续进行。")
		return
	end
	
	--二次确认
	local strName = LuaFnGetWHWGInfo(g_CurrentSelWG, "Name")
	local needItemName = LuaFnGetItemName( need_itembind )
	if nSpendnMsg == 0 then
		GameProduceLogin:GameLoginShowSystemInfo(string.format("#cfff263您正在进阶#G%s#cfff263，将消耗#G%s#cfff263个#G%s#cfff263，以及#G#{_EXCHG%s}#cfff263，您确定进阶吗？",strName,need_itemcount,needItemName,need_money))
		nSpendnMsg = 1
		return
	end
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("JinJieWg")
		Set_XSCRIPT_ScriptID(900004)
		Set_XSCRIPT_Parameter(0, g_CurrentSelWG)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
end

function WuhunTupuJinjie_DoCancel()
	WuhunTupuJinjie_OnCloseClicked()
end

function WuhunTupuJinjie_OnCloseClicked()
	this:Hide()
end

function WuhunTupuJinjie_OnHidden()
	g_CurrentSelWG = 0
	WuhunTupuJinjie_ListCleanUpAction()
	WuhunTupuJinjie_ItemIcon:SetActionItem(-1)
	WuhunTupuJinjie_Need_Object:SetActionItem(-1)
end

function WuhunTupuJinjie_ListCleanUpAction()	
	for i = 1, g_MaxBarNum do
		if g_BarList[i] then			
			local ctrlAction = g_BarList[i]:GetSubItem("WuhunTupuJinjie_Item")			
			if ctrlAction then
				ctrlAction:SetActionItem(-1)
			end
		end	
	end
end

function WuhunTupuJinjie_On_ResetPos()
	if g_WuhunTupuJinjie_UnifiedPosition ~= nil then
		WuhunTupuJinjie_Frame:SetProperty("UnifiedPosition", g_WuhunTupuJinjie_UnifiedPosition)
	end
end

function WuhunTupuJinjie_BeginCareObj(obj_id)	
	m_ObjCared = DataPool:GetNPCIDByServerID(obj_id)
	this:CareObject(m_ObjCared, 1)
end

function WuhunTupuJinjie_Close_Cilcked()
	this:Hide()
end
