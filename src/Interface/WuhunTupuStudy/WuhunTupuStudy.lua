--!!!reloadscript =WuhunTupuStudy
--Q546528533 极致 仅供娱乐交流 切勿商用
local g_WuhunTupuStudy_UnifiedPosition = ""
local g_MaxBarNum = 100

local g_BarList = {}

local g_CurrentFilter = 0
local g_InitList = 0
local g_CurrentSelWG = 0
local g_MaxCardLevel = 5
local g_NeedChangeScrollSize = 0
local g_TodayLevelupCount = 0
local g_SuccRadom = {100,85,70,55,40,40,40,40,40,40,40}
local nWuhunTupuStudyItem = {}
local nWuhunTupuStudyItem_Mask = {}
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
local nWGID = {40005001,40005002,40005003,40005004,40005005,40005006}
local HunHunCanYe = {
{20800000,20800001},{20800002,20800003},{20800004,20800005},{20800006,20800007},{20800008,20800009},{20800010,20800011}
}
local nServerHaveItemInfo = {}
function WuhunTupuStudy_PreLoad()

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
	this:RegisterEvent("PACKAGE_ITEM_CHANGED", false)

end

function WuhunTupuStudy_OnLoad()	
	g_WuhunTupuStudy_UnifiedPosition = WuhunTupuStudy_Frame:GetProperty("UnifiedPosition")	
	nWuhunTupuStudyItem[1] = WuhunTupuStudy_Item_1
	nWuhunTupuStudyItem[2] = WuhunTupuStudy_Item_2
	nWuhunTupuStudyItem[3] = WuhunTupuStudy_Item_3
	nWuhunTupuStudyItem[4] = WuhunTupuStudy_Item_4
	nWuhunTupuStudyItem[5] = WuhunTupuStudy_Item_5
	nWuhunTupuStudyItem[6] = WuhunTupuStudy_Item_6

	nWuhunTupuStudyItem_Mask[1] = WuhunTupuStudy_Item_Mask_1
	nWuhunTupuStudyItem_Mask[2] = WuhunTupuStudy_Item_Mask_2
	nWuhunTupuStudyItem_Mask[3] = WuhunTupuStudy_Item_Mask_3
	nWuhunTupuStudyItem_Mask[4] = WuhunTupuStudy_Item_Mask_4
	nWuhunTupuStudyItem_Mask[5] = WuhunTupuStudy_Item_Mask_5
	nWuhunTupuStudyItem_Mask[6] = WuhunTupuStudy_Item_Mask_6
end

function WuhunTupuStudy_OnEvent(event)

	if event == "UI_COMMAND" and tonumber(arg0) == 88880002 then
		if IsWindowShow("WuhunTupuActive") or IsWindowShow("WuhunTupuJinjie") then
			CloseWindow("WuhunTupuActive", true);
			CloseWindow("WuhunTupuJinjie", true);
		end		
		nServerHaveItemInfo = {}
		for i = 1,6 do
			nServerHaveItemInfo[i] = Split(Get_XParam_STR(i-1), ",")
		end	
		this:Show()
		g_CurrentSelWG = 1
		--m_ItemBagIndex = -1
		--OpenWindow("Packet")
		local objid= Get_XParam_INT(0)
		if objid~=-1 then
			WuhunTupuStudy_BeginCareObj(objid)
		end
		g_TodayLevelupCount = Get_XParam_INT(1)
		WuhunTupuStudy_Update()
	elseif event == "HIDE_ON_SCENE_TRANSED" then
		this:Hide()

	elseif event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		WuhunTupuStudy_On_ResetPos()
	elseif event == "UNIT_MONEY" then
		WuhunTupuStudy_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
	elseif event == "MONEYJZ_CHANGE" then 
		WuhunTupuStudy_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
	elseif event == "UI_COMMAND" and tonumber(arg0) == 28880002 then
		g_TodayLevelupCount = Get_XParam_INT(0)
		WuhunTupuStudy_Update()
	end
end

function WuhunTupuStudy_InitListBar()	
	-- if g_InitList == 0 then		
		-- g_MaxBarNum = DataPool:LuaFnGetWHWGMaxCount()
		-- for i = 1, g_MaxBarNum do
			-- local bar = WuhunTupuStudy_Item_Lace:AddChild("WuhunTupuStudy_ItemBK")
			-- bar:SetProperty("SuperBarButtonHover","SuperBarHoverSection")
			-- g_BarList[i] = bar	
			-- bar:GetSubItem("WuhunTupuStudy_Item"):SetEvent("MouseLButtonDown", string.format("WuhunTupuStudy_ItemClicked(%d)", i))
		-- end	
		-- g_InitList = 1
	-- end
end

--刷新
function WuhunTupuStudy_Update()	
	
	-- WuhunTupuStudy_InitListBar()
	
	WuhunTupuStudy_ListCleanUpAction()
	-- DataPool:LuaFnInitWHWGList()
	local nCount = 6
	
	for i = 1, 6 do
		local nItemID = LuaFnGetWHWGIDFromList(i)
		local nUnLocked = LuaFnGetWHWGInfo(i, "UnLocked")
		local theAction = GemMelting:UpdateProductAction(nItemID)
		if nUnLocked == 0 then
			nWuhunTupuStudyItem_Mask[i]:Show()
		else
			nWuhunTupuStudyItem_Mask[i]:Hide()
		end
		if theAction ~= 0 then
			nWuhunTupuStudyItem[i]:SetActionItem(theAction:GetID())
		end
		-- WuhunTupuStudy_SetItem(i, nCount)
	end
	
	-- if g_NeedChangeScrollSize == 1 then		
	--	WuhunTupuStudy_Item_Lace:RefreshLayout()
		-- WuhunTupuStudy_Item_Lace:SetScrollPosition(0)
		-- g_NeedChangeScrollSize = 0
	-- end
	
	WuhunTupuStudy_UpdateSel()
	
	WuhunTupuStudy_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
	WuhunTupuStudy_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
end

function WuhunTupuStudy_UpdateSel()

	if g_CurrentSelWG ~= 0 then
		--图谱名字
		local strName = LuaFnGetWHWGInfo(g_CurrentSelWG, "Name")
		local strTemp = strName
		local strText = "#cfff263幻魂名称："..strTemp
		WuhunTupuStudy_ItemInfo1:SetText(strText)
		local nItemID = LuaFnGetWHWGIDFromList(g_CurrentSelWG)
		local theAction = GemMelting:UpdateProductAction(nItemID)
		if theAction:GetID() ~= 0 then
			WuhunTupuStudy_ItemIcon:SetActionItem(theAction:GetID())
		end
		
		--本次成功率
		strText = string.format("#cfff263本次成功率：%s%%", g_SuccRadom[g_TodayLevelupCount+1])
		WuhunTupuStudy_ItemInfo2:SetText(strText)
		--今日升级次数
		WuhunTupuStudy_ItemInfo3:SetText( string.format("#cfff263今日升级次数：%s/10", g_TodayLevelupCount) )

		local nTPGrade = LuaFnGetWHWGInfo(g_CurrentSelWG, "Grade")
		local nTPLevel = LuaFnGetWHWGInfo(g_CurrentSelWG, "Level")
		--激活与否
		local nUnLocked = LuaFnGetWHWGInfo(g_CurrentSelWG, "UnLocked")
		if nUnLocked == 0 then
			WuhunTupuStudy_Item_EffectBK:Hide()
			WuhunTupuStudy_EffectNone:SetText("#cfff263未激活该幻魂")
			WuhunTupuStudy_Need_Object_Number:SetText("")
			WuhunTupuStudy_Need_Object:SetActionItem(-1)
			WuhunTupuStudy_DemandMoney:SetProperty("MoneyNumber", "0")
		else
			if nTPGrade==10 and nTPLevel==10 then
				WuhunTupuStudy_Item_EffectBK:Hide()
				WuhunTupuStudy_EffectNone:SetText("#cfff263该幻魂已达满级。")
				WuhunTupuStudy_Need_Object_Number:SetText("")
				WuhunTupuStudy_Need_Object:SetActionItem(-1)
				WuhunTupuStudy_DemandMoney:SetProperty("MoneyNumber", "0")
			elseif nTPLevel==10 then
				WuhunTupuStudy_Item_EffectBK:Hide()
				WuhunTupuStudy_EffectNone:SetText("#cfff263该幻魂需进阶。")
				WuhunTupuStudy_Need_Object_Number:SetText("")
				WuhunTupuStudy_Need_Object:SetActionItem(-1)
				WuhunTupuStudy_DemandMoney:SetProperty("MoneyNumber", "0")
			else
				WuhunTupuStudy_Item_EffectBK:Show()
				WuhunTupuStudy_EffectNone:SetText("")
				--
				WuhunTupuStudy_EffectLevel:SetText( string.format("#cfff263%s阶%s级", nTPGrade, nTPLevel) )--"当前等级："..
				--属性
				local attr_yang,attrvalue_yang,effecttype_yang,effectvalue_yang = LuaFnGetWHWGLevelInfo(g_CurrentSelWG,nTPGrade,nTPLevel,"AttrEffectYang")
				local attr_yin,attrvalue_yin,effecttype_yin,effectvalue_yin = LuaFnGetWHWGLevelInfo(g_CurrentSelWG,nTPGrade,nTPLevel,"AttrEffectYin")
				local wszattr,wszattrvalue = LuaFnGetWHWGLevelInfo(g_CurrentSelWG,nTPGrade,nTPLevel,"wszAttr")
				WuhunTupuStudy_Effect1:SetText(g_strAttrDic[attr_yang].."+"..attrvalue_yang)			
				WuhunTupuStudy_Effect2:SetText( string.format("%s伤害增加%.2f%%", g_strEffectDic[effecttype_yang],tostring(0.01*effectvalue_yang)))
				WuhunTupuStudy_Effect3:SetText(g_strAttrDic[attr_yin].."+"..attrvalue_yin)
				WuhunTupuStudy_Effect4:SetText( string.format("受%s伤害降低%.2f%%", g_strEffectDic[effecttype_yin],tostring(0.01*effectvalue_yin)) )
				WuhunTupuStudy_Effect5:SetText(g_strAttrDic[wszattr].."+"..wszattrvalue)
				--下一级属性
				attr_yang,attrvalue_yang,effecttype_yang,effectvalue_yang = LuaFnGetWHWGLevelInfo(g_CurrentSelWG,nTPGrade,nTPLevel+1,"nExtAttrEffectYang")
				attr_yin,attrvalue_yin,effecttype_yin,effectvalue_yin = LuaFnGetWHWGLevelInfo(g_CurrentSelWG,nTPGrade,nTPLevel+1,"nExtAttrEffectYin")
				wszattr,wszattrvalue = LuaFnGetWHWGLevelInfo(g_CurrentSelWG,nTPGrade,nTPLevel+1,"nExtwszAttr")
				WuhunTupuStudy_Effect1Plus:SetText( string.format("%s", attrvalue_yang) )
				WuhunTupuStudy_Effect2Plus:SetText( string.format("%.2f%%", 0.01*effectvalue_yang) )
				WuhunTupuStudy_Effect3Plus:SetText( string.format("%s", attrvalue_yin) )
				WuhunTupuStudy_Effect4Plus:SetText( string.format("%.2f%%", 0.01*effectvalue_yin) )
				WuhunTupuStudy_Effect5Plus:SetText("+"..wszattrvalue)
				WuhunTupuStudy_EffectLevelPluse:SetText( string.format("#cfff263%s阶%s级", nTPGrade, nTPLevel+1) )--"升级等级："..
				--道具
				local need_itembind,need_itemunbind = LuaFnGetWHWGLevelInfo(g_CurrentSelWG,nTPGrade,nTPLevel,"LevelItem")
				local need_itemcount = LuaFnGetWHWGLevelInfo(g_CurrentSelWG,nTPGrade,nTPLevel,"LevelItemCount")
				local need_money = LuaFnGetWHWGLevelInfo(g_CurrentSelWG,nTPGrade,nTPLevel,"LevelCost")
	
				WuhunTupuStudy_DemandMoney:SetProperty("MoneyNumber", tostring(need_money))
				
				--有没有道具
				local nHaveCount1 = tonumber(nServerHaveItemInfo[g_CurrentSelWG][1])
				local nHaveCount2 = tonumber(nServerHaveItemInfo[g_CurrentSelWG][2])
				if nHaveCount1>0 then
					local showAction = GemMelting:UpdateProductAction(need_itembind)
					if showAction:GetID() ~= 0 then
						WuhunTupuStudy_Need_Object:SetActionItem(showAction:GetID())
					end
				else
					local showAction = GemMelting:UpdateProductAction(need_itemunbind)
					if showAction:GetID() ~= 0 then
						WuhunTupuStudy_Need_Object:SetActionItem(showAction:GetID())
					end
				end
				local szHaveCount = ""
				if nHaveCount1+nHaveCount2 >= need_itemcount then
					szHaveCount = string.format("#G%s", need_itemcount)
				else
					szHaveCount = string.format("#cff0000%s", need_itemcount)
				end
				WuhunTupuStudy_Need_Object_Number:SetText(szHaveCount)
			end
			
		end
	else
		WuhunTupuStudy_ItemInfo1:SetText("#cfff263幻魂名称：")
		local strText = string.format("#cfff263本次成功率：%s%%", g_SuccRadom[g_TodayLevelupCount+1])
		WuhunTupuStudy_ItemInfo2:SetText(strText)
		WuhunTupuStudy_ItemInfo3:SetText( string.format("#cfff263今日升级次数：%s/10", g_TodayLevelupCount) )
		WuhunTupuStudy_Item_EffectBK:Hide()
		WuhunTupuStudy_EffectNone:SetText("#cfff263未激活该幻魂")
		WuhunTupuStudy_Need_Object_Number:SetText("")
		WuhunTupuStudy_Need_Object:SetActionItem(-1)
		WuhunTupuStudy_DemandMoney:SetProperty("MoneyNumber", "0")

		WuhunTupuStudy_ItemIcon:SetActionItem(-1)
		
		WuhunTupuStudy_Need_Object:SetActionItem(-1)
		WuhunTupuStudy_Need_Object_Number:SetText("")
	end
end

function WuhunTupuStudy_SetItem(idx, max_count)

	if g_BarList[idx] == nil then
		return
	end
	
	if idx > max_count then
		g_BarList[idx]:Hide()
		return
	end
	
	local bar = g_BarList[idx]
	bar:Show()
	
	-- local wgID = LuaFnGetWHWGIDFromList(idx - 1)
	-- local nUnLocked = LuaFnGetWHWGInfo(wgID, "UnLocked")
	-- local nLevel = LuaFnGetWHWGInfo(wgID, "Level")
	-- local nGrade = LuaFnGetWHWGInfo(wgID, "Grade")
	-- local strName = LuaFnGetWHWGInfo(wgID, "Name")

	--todo 控件右下角显示已拥有的图谱的等级：%s0/10级 WH_210223_169 ，%s0为当前等级，%s1为下一阶前的等级上限
	--激活锁
	if nUnLocked == 1 then
		bar:GetSubItem("WuhunTupuStudy_Item_Mask"):Hide()
	else
		bar:GetSubItem("WuhunTupuStudy_Item_Mask"):Show()
	end

	local ctrlAction = bar:GetSubItem("WuhunTupuStudy_Item")
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

function WuhunTupuStudy_ItemClicked(nIndex)
	
	-- local wgID = LuaFnGetWHWGIDFromList(nIndex - 1)
	-- if g_CurrentSelWG == wgID then
		-- return
	-- end
	
	g_CurrentSelWG = nIndex
	
	for i = 1, 6 do		
		-- if g_BarList[i] ~= nil then	
			-- local ctrlAction = g_BarList[i]:GetSubItem("WuhunTupuStudy_Item")
			-- if ctrlAction ~= nil then
				if i == nIndex then
					nWuhunTupuStudyItem[i]:SetPushed(1)
				else
					nWuhunTupuStudyItem[i]:SetPushed(0)	
				end
			-- end			
		-- end
	end
	
	WuhunTupuStudy_UpdateSel()
	
end

function WuhunTupuStudy_UpLevel_Clicked()
	-- 判断电话密保和二级密码保护
	-- if CheckPhoneMibaoAndMinorPassword() ~= 1 then
		-- return
	-- end
	if g_CurrentSelWG == 0 then
		PushDebugMessage("#H请先选中需要升级的幻魂，再进行该操作。")
		return
	end
	
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("LevelUpWg")
		Set_XSCRIPT_ScriptID(900004)
		Set_XSCRIPT_Parameter(0, g_CurrentSelWG)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
end

function WuhunTupuStudy_DoCancel()
	WuhunTupuStudy_OnCloseClicked()
end

function WuhunTupuStudy_OnCloseClicked()
	this:Hide()
end

function WuhunTupuStudy_OnHidden()
	g_CurrentSelWG = 0
	WuhunTupuStudy_ListCleanUpAction()
	WuhunTupuStudy_ItemIcon:SetActionItem(-1)
	WuhunTupuStudy_Need_Object:SetActionItem(-1)
end

function WuhunTupuStudy_ListCleanUpAction()	
	for i = 1, g_MaxBarNum do
		if g_BarList[i] then			
			local ctrlAction = g_BarList[i]:GetSubItem("WuhunTupuStudy_Item")			
			if ctrlAction then
				ctrlAction:SetActionItem(-1)
			end
		end	
	end
end

function WuhunTupuStudy_On_ResetPos()
	if g_WuhunTupuStudy_UnifiedPosition ~= nil then
		WuhunTupuStudy_Frame:SetProperty("UnifiedPosition", g_WuhunTupuStudy_UnifiedPosition)
	end
end

function WuhunTupuStudy_BeginCareObj(obj_id)	
	m_ObjCared = DataPool:GetNPCIDByServerID(obj_id)
	this:CareObject(m_ObjCared, 1)
end

function WuhunTupuStudy_Close_Cilcked()
	this:Hide()
end
