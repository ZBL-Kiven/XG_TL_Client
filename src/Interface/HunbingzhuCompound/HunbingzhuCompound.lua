-- HunbingzhuCompound 魂冰珠合成 2021-10-13 lishilong
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

-- 魂冰石
local g_tableHunBingItemID = 
{
	20310117,	--魂冰珠（1级）
	20310118,	--魂冰珠（2级）
	20310119,	--魂冰珠（3级）
	20310120,	--魂冰珠（4级）
	20310121,	--魂冰珠（5级）
}

-- 绑定魂冰石
local g_tableHunBingBindItemID = 
{
	20310161,	--魂冰珠（1级）
	20310162,	--魂冰珠（2级）
	20310163,	--魂冰珠（3级）
	20310164,	--魂冰珠（4级）
	20310165,	--魂冰珠（5级）
}

-- 魂冰珠消耗道具数量
local g_tableCommonCostItemNum	= {5, 5, 5, 5}
local g_tableQuickCostItemNum 	= {5, 25, 125, 625}

-- 魂冰珠消耗金钱
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
		-- 0 关闭, 1 打开, 2 刷新, 3 二次确认框
		local nOpType 	= Get_XParam_INT(0)

		-- 关闭界面
		if 0 == nOpType then	
			if this:IsVisible() then
				HunbingzhuCompound_OnClose()
			end
		end

		-- 打开界面
		if 1 == nOpType then
			-- 关注npc
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

			-- 显示界面
			-- 为了解决界面被遮挡的问题，先把界面关了
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
			
		-- 刷新界面
		if 2 == nOpType then
			-- 关注npc
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

		-- 二次确认框
		if 3 == nOpType then
			-- local strMsg = Get_XParam_STR(0)
			-- g_nComfirmParam1 = Get_XParam_INT(1)
			-- ["Type"] "Ok" "YesNo"
			-- MessageBoxSelf3("HunbingzhuCompound_OnComfirmedBack", {["Content"] = strMsg,["Type"] = "YesNo", })
		end

	-- ============================================
	-- 通用逻辑
	elseif ( event == "OBJECT_CARED_EVENT" ) and 1 == bCaredObj then
		if(tonumber(arg0) ~= g_nObjCaredIDClient) then
			return
		end
		-- 如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			-- 关闭界面
			HunbingzhuCompound_OnClose()
		end	

	-- 物品改变
	elseif ( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() and 1 == bCaredItem ) then
		-- 刷新界面
		if this:IsVisible() then
			HunbingzhuCompound_Update(0)
		end

	-- 金钱改变
	elseif (event == "UNIT_MONEY" or event == "MONEYJZ_CHANGE") and 1 == bCaredMoney then
		HunbingzhuCompound_MoneyUpdate()

	-- 元宝改变
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
-- 界面参数初始化
--=========================================================
function HunbingzhuCompound_ParamInit()

end

--=========================================================
-- 二次确认框回调 ["Type"] "Ok"的返回值有"Ok"； ["Type"] "YesNo"的返回值有 "Yes" "No"
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
-- 界面更新
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

	-- 页签
	if 2 == g_nCurSelectedPage then
		g_controlPageButton[1] : SetCheck(0)
		g_controlPageButton[2] : SetCheck(1)
		HunbingzhuCompound_ExplainInfo : SetText( "#{HBZHC_210923_35}" )
	else
		g_controlPageButton[1] : SetCheck(1)
		g_controlPageButton[2] : SetCheck(0)
		HunbingzhuCompound_ExplainInfo : SetText( "#{HBZHC_210923_4}" )
	end

	-- 选择按钮 
	for i = 1, table.getn(g_controlIndexButton) do
		g_controlIndexButton[i] : SetCheck(0)
	end

	g_controlIndexButton[g_nCurSelectedIndex] : SetCheck(1)

	-- 右侧显示
	-- 右侧魂冰珠合成提示区域
	local nTargetLevel =  g_nCurSelectedIndex + 1
	HunbingzhuCompound_ChoiceInfo : SetText( ScriptGlobal_Format("#{HBZHC_210923_10}", nTargetLevel) )
	if 2 == g_nCurSelectedPage then
		HunbingzhuCompound_ChoiceInfo : SetText( ScriptGlobal_Format("#{HBZHC_210923_37}", nTargetLevel) )
	end

	-- 道具展示区域
	local theAction = DataPool:CreateActionItemForShow(g_tableHunBingItemID[nTargetLevel], 1)
	if 0 ~= theAction:GetID() then
		HunbingzhuCompound_Item : SetActionItem(theAction:GetID())
	end

	local nNeedItemLevel	= g_nCurSelectedIndex
	local nNeedItemID 		= g_tableHunBingItemID[g_nCurSelectedIndex]
	local nNeedBindItemID 	= g_tableHunBingBindItemID[g_nCurSelectedIndex]
	local nNeedItemNum		= g_tableCommonCostItemNum[g_nCurSelectedIndex]
	local nNeedMoney		= g_tableCommonCostMoney[g_nCurSelectedIndex]
	-- 快捷合成，重新算次数和金钱
	if 2 == g_nCurSelectedPage then
		nNeedItemLevel		= 1
		nNeedItemID 		= g_tableHunBingItemID[1]
		nNeedBindItemID 	= g_tableHunBingBindItemID[1]
		nNeedItemNum 		= g_tableQuickCostItemNum[g_nCurSelectedIndex]
		nNeedMoney 			= g_tableQuickCostMoney[g_nCurSelectedIndex]
	end

	-- 需要个数区域
	HunbingzhuCompound_Need_Info : SetText( ScriptGlobal_Format("#{HBZHC_210923_13}", nNeedItemLevel) )
	HunbingzhuCompound_Need_Number : SetText( ScriptGlobal_Format("#{HBZHC_210923_38}", nNeedItemNum) )

	-- 拥有个数区域
	local nHaveCount = PlayerPackage:CountAvailableItemByIDTable(nNeedItemID) + PlayerPackage:CountAvailableItemByIDTable(nNeedBindItemID)
	local strHaveCount = ""
	-- %s0个       HBZHC_210923_39   //%s0显示为绿色
	-- %s0个       HBZHC_210923_40   //%s0显示为红色
	if nHaveCount >= nNeedItemNum then
		strHaveCount = ScriptGlobal_Format("#{HBZHC_210923_39}", nHaveCount)
	else
		strHaveCount = ScriptGlobal_Format("#{HBZHC_210923_40}", nHaveCount)
	end
	HunbingzhuCompound_Have_Info 	: SetText( ScriptGlobal_Format("#{HBZHC_210923_15}", nNeedItemLevel) )
	HunbingzhuCompound_Have_Number	: SetText( strHaveCount )
	
	-- 合成消耗区域
	HunbingzhuCompound_DemandMoney 		: SetProperty("MoneyNumber", nNeedMoney)
	HunbingzhuCompound_MoneyUpdate()

end

--=========================================================
-- 金钱刷新：界面更新调用一次 金钱事件调用一次
--=========================================================
function HunbingzhuCompound_MoneyUpdate()
	HunbingzhuCompound_CurrentlyJiaozi 	: SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")) )
	HunbingzhuCompound_CurrentlyMoney 	: SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")) )
end

--=========================================================
-- 重置界面
--=========================================================
function HunbingzhuCompound_Reset()
	g_nCurSelectedPage = 1
	g_nCurSelectedIndex = 1
end

--=========================================================
-- 切换页面
--=========================================================
function HunbingzhuCompound_SwitchPage(nPage)
	if nil == nPage or nPage < 1 or nPage > 2 then
		return
	end

	g_nCurSelectedPage = nPage
	HunbingzhuCompound_Update(0)
end

--=========================================================
-- 选择按钮
--=========================================================
function HunbingzhuCompound_SelectTargetLevel(nIndex)
	if nil == nIndex or nIndex < 1 or nIndex > 4 then
		return
	end

	g_nCurSelectedIndex = nIndex
	HunbingzhuCompound_Update(0)
end

--=========================================================
-- 界面确认按钮
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
-- 关闭界面
--=========================================================
function HunbingzhuCompound_OnClose()	
	this:Hide()
	StopCareObject_HunbingzhuCompound()
	-- 重置
	HunbingzhuCompound_Reset()
end

--=========================================================
-- 界面隐藏
-- <Event Name="Hidden" Function="HunbingzhuCompound_OnHiden();" />
--=========================================================
function HunbingzhuCompound_OnHiden()
	StopCareObject_HunbingzhuCompound()
	-- 重置
	HunbingzhuCompound_Reset()
end

--=========================================================
-- 关心操作
--=========================================================
function BeginCareObject_HunbingzhuCompound()
	-- 关心
	this:CareObject(g_nObjCaredIDClient, 1, "HunbingzhuCompound")
end

function StopCareObject_HunbingzhuCompound()
	-- 取消关心
	if nil ~= g_nObjCaredIDClient and g_nObjCaredIDClient > 0 then
		this:CareObject(g_nObjCaredIDClient, 0, "HunbingzhuCompound")
	end
	g_nServerObjID = -1
end

--=========================================================
-- 元宝刷新：界面更新调用一次 元宝事件调用一次
--=========================================================
function HunbingzhuCompound_YuanBaoUpdate()
	-- HunbingzhuCompound_HaveYuanBaoNum : SetText (tostring(Player:GetData("YUANBAO")))
end

--=========================================================
-- 界面位置
--=========================================================
function HunbingzhuCompound_Frame_On_ResetPos()
	HunbingzhuCompoundFrame:SetProperty("UnifiedPosition", g_HunbingzhuCompound_Frame_UnifiedPosition)
end