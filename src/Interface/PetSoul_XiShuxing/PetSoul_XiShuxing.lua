
local MAX_OBJ_DISTANCE = 3.0
local g_CaredNpc = -1
local g_PetSoul_XiShuxing_Frame_UnifiedPosition;
local g_BeforeText = {}
local g_AfterText = {}
local g_CheckButton = {}
local g_Already = 0
local g_BagIndex = -1
local g_ItemIndex = -1
local g_MAX = 100
local iQual = 0
local nWashAttr = ""
local g_NeedItem = {
	[0] = 38002534,	--淬魂水
	[1] = 38002533,	--淬魂液
	[2] = 38002532,	--淬魂髓
}
local g_NeedRMBItem = {
	[1] = 38002541,	
	[2] = 38002540,	
}
local g_IsLock = {0,0,0,0,0,0}
local g_DailyLeft = {
	[0] = 0,
	[1] = 0,
	[2] = 0,
}
local g_AvailableLockNum = {0,0}
local g_Total = {0,0}
local g_nBeforePerfect = 0
local g_nAfterPerfect = 0
local g_ShenShouData = {
	[1] = {total = 200,   locknum = 1, needitemcount = 2,},
	[2] = {total = 500,   locknum = 2, needitemcount = 2,},
	[3] = {total = 1000,  locknum = 3, needitemcount = 3,},
	[4] = {total = 2000,  locknum = 4, needitemcount = 3,},
	[5] = {total = 5000,  locknum = 5, needitemcount = 4,},
	[6] = {total = 10000, locknum = 6, needitemcount = 5,},
}
local g_YiShouData = {
	[1] = {total = 100,   locknum = 1, needitemcount = 2,},
	[2] = {total = 200,   locknum = 2, needitemcount = 2,},
	[3] = {total = 500,   locknum = 3, needitemcount = 3,},
	[4] = {total = 1000,  locknum = 4, needitemcount = 3,},
	[5] = {total = 2000,  locknum = 5, needitemcount = 4,},
}
local g_TypeText = {
	[0] = "#{SHCX_20211229_32}";
	[1] = "#{SHCX_20211229_31}";
	[2] = "#{SHCX_20211229_30}";
}
--=========================================================
-- 注册窗口关心的所有事件
--=========================================================
function PetSoul_XiShuxing_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("UPDATE_PETSOUL" ,false)
	this:RegisterEvent("UPDATE_PETSOUL_ITEM" ,false)
	this:RegisterEvent("UPDATE_PETSOUL_AFTERXISHUXING" ,false)
	this:RegisterEvent("PACKAGE_ITEM_CHANGED" ,false)
	this:RegisterEvent("UPDATE_PETSOUL_AFTERSAVE" ,false)
	this:RegisterEvent("PETSOUL_XISHUXING_CONFIRMOK" ,false)	
	this:RegisterEvent("OBJECT_CARED_EVENT" ,false)
	this:RegisterEvent("ADJEST_UI_POS" ,false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED" ,false)
	this:RegisterEvent("UNIT_MONEY" ,false)					--金钱变化
	this:RegisterEvent("MONEYJZ_CHANGE" ,false)					--交子变化
end

--=========================================================
-- 载入初始化
--=========================================================
function PetSoul_XiShuxing_OnLoad()

	g_PetSoul_XiShuxing_Frame_UnifiedPosition = PetSoul_XiShuxing_Frame:GetProperty("UnifiedPosition");
	
	g_BeforeText[1] = PetSoul_XiShuxing_BeforeAttr1
	g_BeforeText[2] = PetSoul_XiShuxing_BeforeAttr2
	g_BeforeText[3] = PetSoul_XiShuxing_BeforeAttr3
	g_BeforeText[4] = PetSoul_XiShuxing_BeforeAttr4
	g_BeforeText[5] = PetSoul_XiShuxing_BeforeAttr5
	g_BeforeText[6] = PetSoul_XiShuxing_BeforeAttr6

	g_AfterText[1] = PetSoul_XiShuxing_AfterAttr1
	g_AfterText[2] = PetSoul_XiShuxing_AfterAttr2
	g_AfterText[3] = PetSoul_XiShuxing_AfterAttr3
	g_AfterText[4] = PetSoul_XiShuxing_AfterAttr4
	g_AfterText[5] = PetSoul_XiShuxing_AfterAttr5
	g_AfterText[6] = PetSoul_XiShuxing_AfterAttr6
	
	g_CheckButton[1] = PetSoul_XiShuxing_Kuang_Type1
	g_CheckButton[2] = PetSoul_XiShuxing_Kuang_Type2
	g_CheckButton[3] = PetSoul_XiShuxing_Kuang_Type3
	g_CheckButton[4] = PetSoul_XiShuxing_Kuang_Type4
	g_CheckButton[5] = PetSoul_XiShuxing_Kuang_Type5
	g_CheckButton[6] = PetSoul_XiShuxing_Kuang_Type6
end

--=========================================================
-- 事件处理
--=========================================================
function PetSoul_XiShuxing_OnEvent(event)
	if (event == "UI_COMMAND" and tonumber(arg0) == 80012708) then
		if Get_XParam_INT(0) == 2 then
			g_DailyLeft[0] = g_MAX - Get_XParam_INT(1);
			g_DailyLeft[1] = g_MAX - Get_XParam_INT(2);
			g_DailyLeft[2] = g_MAX - Get_XParam_INT(3);
			g_Total[1] = Get_XParam_INT(4);
			g_Total[2] = Get_XParam_INT(5);
			PetSoul_XiShuxing_CalcAvailableLockNum()
			PetSoul_XiShuxing_FlushWindow()
			return
		end

		local xx = Get_XParam_INT(1);
		g_CaredNpc = DataPool : GetNPCIDByServerID(xx);
		AxTrace(0,1,"xx="..xx .. " g_CaredNpc="..g_CaredNpc)
		if g_CaredNpc == -1 then
			PushDebugMessage("server传过来的数据有问题。");
			return;
		end

		BeginCareObject_PetSoul_XiShuxing()

		PetSoul_XiShuxing_Clear() 

		g_DailyLeft[0] = g_MAX - Get_XParam_INT(2);
		g_DailyLeft[1] = g_MAX - Get_XParam_INT(3);
		g_DailyLeft[2] = g_MAX - Get_XParam_INT(4);
		g_Total[1] = Get_XParam_INT(5);
		g_Total[2] = Get_XParam_INT(6);
		PetSoul_XiShuxing_CalcAvailableLockNum()
		PetSoul_XiShuxing_ShowFrame() 
		this:Show()
	
	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if (tonumber(arg0) ~= g_CaredNpc) then
			return
		end
		if ((arg1 == "distance" and tonumber(arg2) > MAX_OBJ_DISTANCE) or arg1=="destroy") then
			PetSoul_XiShuxing_OnHiden()
		end

	elseif (event == "UPDATE_PETSOUL") then
		PetSoul_XiShuxing_UpdatePetSoul(tonumber(arg0), 0) 
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 201107281 and this:IsVisible() ) then
		-- PushDebugMessage(g_BagIndex)
		if LuaFnGetPetSoulDataInBag(tonumber(arg1),"QUAL") == -1 then
			PetSoul_XiShuxing_UpdateItem(tonumber(arg1))
		else	
			PetSoul_XiShuxing_UpdatePetSoul(tonumber(arg1), 0)
		end		
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 202205211 and this:IsVisible()) then
		local iQual = LuaFnGetPetSoulDataInBag(g_BagIndex, "QUAL")
		if iQual == 0 then--灵兽
			iRealExtensionCount = 4
		elseif iQual == 1 then--异兽
			iRealExtensionCount = 5
		elseif iQual == 2 then--神兽
			iRealExtensionCount = 6
		end
		local nNewInfo = Get_XParam_STR(0)
		for i = 0, iRealExtensionCount - 1 do
			local tempStr, qual = LuaFnGetPetSoulDataInServer(nNewInfo, i)
			g_BeforeText[i+1]:SetText(tempStr)
		end
		local theAction = EnumAction(g_BagIndex, "packageitem")
		PetSoul_XiShuxing_BeforeIcon:SetActionItem(theAction:GetID())
		LifeAbility:Lock_Packet_Item(g_BagIndex, 1)
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 20220520 and this:IsVisible()) then
		g_DailyLeft[0] = g_MAX - Get_XParam_INT(0);
		g_DailyLeft[1] = g_MAX - Get_XParam_INT(1);
		g_DailyLeft[2] = g_MAX - Get_XParam_INT(2);
		g_Total[1] = Get_XParam_INT(3);
		g_Total[2] = Get_XParam_INT(4);
		nWashAttr = Get_XParam_STR(0)
		PetSoul_XiShuxing_CalcAvailableLockNum()
		PetSoul_XiShuxing_ShowResult()
		PetSoul_XiShuxing_FlushWindow()
	elseif (event == "UPDATE_PETSOUL_AFTERSAVE") then
		--替换
		PushDebugMessage("#{SHCX_20211229_26}")
		g_Already = 0
		PetSoul_XiShuxing_UpdatePetSoul(g_BagIndex, 0) 
		PetSoul_XiShuxing_ClearAfter() 
	elseif (event == "PETSOUL_XISHUXING_CONFIRMOK") then
		local opt = tonumber(arg0)
		if opt == 1 then
			PetSoul_XiShuxing_Clear() 
			PetSoul_XiShuxing_ShowFrame() 
		elseif opt == 2 then
			g_Already = 0
			PetSoul_XiShuxing_OnHiden()
		elseif opt == 3 then
			PetSoul_XiShuxing_UpdatePetSoul(tonumber(arg1), 1) 
		end

	elseif (event == "ADJEST_UI_POS" ) then
		PetSoul_XiShuxing_Frame_On_ResetPos() 

	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		PetSoul_XiShuxing_Frame_On_ResetPos()

	elseif event == "UNIT_MONEY" and this:IsVisible() then
		PetSoul_XiShuxing_HaveGoldNum:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))

	elseif event == "MONEYJZ_CHANGE" and this:IsVisible() then
		PetSoul_XiShuxing_HaveNum:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))

	elseif ( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() ) then
		--PetSoul_XiShuxing_ClearItem()
	end
end
 
function PetSoul_XiShuxing_FlushWindow() 
	
	local iQual = LuaFnGetPetSoulDataInBag(g_BagIndex, "QUAL")
	if iQual == 0 then--灵兽
		iRealExtensionCount = 4
	elseif iQual == 1 then--异兽
		iRealExtensionCount = 5
	elseif iQual == 2 then--神兽
		iRealExtensionCount = 6
	end	
	PetSoul_XiShuxing_Num:SetText(string.format("#cfff263今日#G%s#cfff263剩余洗练次数：#G%s", g_TypeText[iQual], g_DailyLeft[iQual]))
	for i = 1, iRealExtensionCount do
		g_CheckButton[i]:SetProperty("Disabled", "False");
		if iQual == 0 then--灵兽
			g_CheckButton[i]:SetToolTip("#{SHCX_20211229_34}")
		elseif iQual == 1 then--异兽
			g_CheckButton[i]:SetToolTip(string.format("#Y您已消耗#G淬魂液#Y和#G高级淬魂液%s个#Y，可锁定#G%s#Y条扩展属性，具体规则详见上方小问号。", g_Total[iQual], g_AvailableLockNum[iQual]))
		elseif iQual == 2 then--神兽
			g_CheckButton[i]:SetToolTip(string.format("#Y您已消耗#G淬魂髓#Y和#G高级淬魂髓%s个#Y，可锁定#G%s#Y条扩展属性，具体规则详见上方小问号。", g_Total[iQual], g_AvailableLockNum[iQual]))
		end	
	end
	PetSoul_XiShuxing_Num:SetToolTip(string.format("#Y今日剩余洗练次数：神兽魂#G%s#Y次，荒兽魂#G%s#Y次，灵兽魂#G%s#Y次", g_DailyLeft[2], g_DailyLeft[1], g_DailyLeft[0]))

end

--=========================================================
-- 重置界面
--=========================================================
function PetSoul_XiShuxing_Clear() 

	if g_BagIndex >= 0 then
		LifeAbility:Lock_Packet_Item(g_BagIndex, 0)
		g_BagIndex = -1
	end

	if g_ItemIndex >= 0 then
		LifeAbility:Lock_Packet_Item(g_ItemIndex, 0)
		g_ItemIndex = -1
	end

	g_nBeforePerfect = 0
	g_nAfterPerfect = 0
	g_Already = 0
	g_DailyLeft[0] = 0
	g_DailyLeft[1] = 0
	g_DailyLeft[2] = 0
	g_Total = {0,0}
	g_AvailableLockNum = {0,0}
	for i = 1, 6 do
		g_BeforeText[i]:SetText("")
		g_AfterText[i]:SetText("")
		g_IsLock[i] = 0
		g_CheckButton[i]:SetCheck(0)
		g_CheckButton[i]:SetToolTip("#{SHCX_20211229_34}")
	end
	PetSoul_XiShuxing_Num:SetText("")
	PetSoul_XiShuxing_Num:SetToolTip("")
	PetSoul_XiShuxing_BeforeIcon:SetActionItem(-1)
	PetSoul_XiShuxing_AfterIcon:SetProperty("Image","set:CommonItem image:ActionBK")
	PetSoul_XiShuxing_NeedIcon:SetActionItem(-1)
	PetSoul_XiShuxing_NeedNum:SetText("")
	PetSoul_XiShuxing_NeedNumBK:Hide()
	PetSoul_XiShuxing_WantNum:SetProperty("MoneyNumber", tostring(0))
	PetSoul_XiShuxing_HaveNum:SetProperty("MoneyNumber", tostring(0))
	PetSoul_XiShuxing_HaveGoldNum:SetProperty("MoneyNumber", tostring(0))

	PetSoul_XiShuxing_OK:SetProperty("Disabled", "True");

	-- Pet:LuaFnClearPetSoulExValue()

end

function PetSoul_XiShuxing_ClearIcon()
	if g_Already == 1 then
		PushEvent("PETSOUL_XISHUXING_CONFIRM", 1, g_BagIndex)
	else
		if g_BagIndex >= 0 then
			LifeAbility:Lock_Packet_Item(g_BagIndex, 0)
			g_BagIndex = -1
		end

		if g_ItemIndex >= 0 then
			LifeAbility:Lock_Packet_Item(g_ItemIndex, 0)
			g_ItemIndex = -1
		end

		g_nBeforePerfect = 0
		g_nAfterPerfect = 0
		g_Already = 0

		for i = 1, 6 do
			g_BeforeText[i]:SetText("")
			g_AfterText[i]:SetText("")
			g_IsLock[i] = 0
			g_CheckButton[i]:SetCheck(0)
			g_CheckButton[i]:SetToolTip("#{SHCX_20211229_34}")
		end

		PetSoul_XiShuxing_Num:SetText("")
		PetSoul_XiShuxing_Num:SetToolTip("")
		PetSoul_XiShuxing_BeforeIcon:SetActionItem(-1)
		PetSoul_XiShuxing_AfterIcon:SetProperty("Image","set:CommonItem image:ActionBK")
		PetSoul_XiShuxing_NeedIcon:SetActionItem(-1)
		PetSoul_XiShuxing_NeedNum:SetText("")
		PetSoul_XiShuxing_NeedNumBK:Hide()
		PetSoul_XiShuxing_WantNum:SetProperty("MoneyNumber", tostring(0))

		PetSoul_XiShuxing_OK:SetProperty("Disabled", "True");

		Pet:LuaFnClearPetSoulExValue()
		PetSoul_XiShuxing_ShowFrame() 
	end
end


function PetSoul_XiShuxing_ClearItem()

	if g_ItemIndex >= 0 then
		LifeAbility:Lock_Packet_Item(g_ItemIndex, 0)
		g_ItemIndex = -1
	end

	PetSoul_XiShuxing_NeedIcon:SetActionItem(-1)

	PetSoul_XiShuxing_NeedNum:SetText("")
	PetSoul_XiShuxing_NeedNumBK:Hide()
end

function PetSoul_XiShuxing_ShowFrame() 

	PetSoul_XiShuxing_HaveNum:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
	PetSoul_XiShuxing_HaveGoldNum:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))

	PetSoul_XiShuxing_OK:SetProperty("Disabled", "True");
	PetSoul_XiShuxing_Num:SetText("#{SHCX_20211229_28}")
	PetSoul_XiShuxing_Num:SetToolTip(string.format("#Y今日剩余洗练次数：神兽魂#G%s#Y次，荒兽魂#G%s#Y次，灵兽魂#G%s#Y次", g_DailyLeft[2], g_DailyLeft[1], g_DailyLeft[0]))
end

function LuaFnIsPetSoul(itemIndex)
	local nItemIndex = PlayerPackage:GetItemTableIndex(itemIndex);
	if nItemIndex >= 39995366 and nItemIndex <= 39995380 then
		return 1
	end
	return 0
end
--=========================================================
-- 更新界面
--=========================================================
function PetSoul_XiShuxing_UpdatePetSoul(itemIndex, isConfirm)

	if itemIndex == nil or itemIndex < 0 then
		return
	end
	for i = 1, table.getn(g_CheckButton) do
		g_IsLock[i] = 0
		g_CheckButton[i]:SetCheck(0)
		g_CheckButton[i]:SetProperty("Disabled", "True");
	end

	local theAction = EnumAction(itemIndex, "packageitem")
	if theAction:GetID() ~= 0 then

		if LuaFnIsPetSoul(itemIndex) ~= 1 then
			PushDebugMessage("#{SHCX_20211229_17}")
			return
		end
		PetSoul_XiShuxing_Num:SetText("")
		PetSoul_XiShuxing_OK:SetProperty("Disabled", "True");
		g_nBeforePerfect = 0
		local iRealExtensionCount = 0
		local iQual = LuaFnGetPetSoulDataInBag(itemIndex, "QUAL")
		if iQual == 0 then--灵兽
			iRealExtensionCount = 4
		elseif iQual == 1 then--异兽
			iRealExtensionCount = 5
		elseif iQual == 2 then--神兽
			iRealExtensionCount = 6
		end	
		PetSoul_XiShuxing_Num:SetText(string.format("#cfff263今日#G%s#cfff263剩余洗练次数：#G%s", g_TypeText[iQual], g_DailyLeft[iQual]))

		for i = 1, iRealExtensionCount do
			g_CheckButton[i]:SetProperty("Disabled", "False");
			if iQual == 0 then--灵兽
				g_CheckButton[i]:SetToolTip("#{SHCX_20211229_34}")
			elseif iQual == 1 then--异兽
				g_CheckButton[i]:SetToolTip(string.format("#Y您已消耗#G淬魂液#Y和#G高级淬魂液%s个#Y，可锁定#G%s#Y条扩展属性，具体规则详见上方小问号。", g_Total[iQual], g_AvailableLockNum[iQual]))
			elseif iQual == 2 then--神兽
				g_CheckButton[i]:SetToolTip(string.format("#Y您已消耗#G淬魂髓#Y和#G高级淬魂髓%s个#Y，可锁定#G%s#Y条扩展属性，具体规则详见上方小问号。", g_Total[iQual], g_AvailableLockNum[iQual]))
			end	
		end

		
		----------------------------------------------------------------------------------没洗过且槽位空
		if g_Already ~= 1 and g_BagIndex < 0 then
			PetSoul_XiShuxing_BeforeIcon:SetActionItem(theAction:GetID())
			if g_BagIndex ~= itemIndex then
				g_BagIndex = itemIndex
				PetSoul_XiShuxing_ClearItem()
			end
			LifeAbility:Lock_Packet_Item(g_BagIndex, 1)

			PetSoul_XiShuxing_OK:SetProperty("Disabled", "False");

			for i = 0, iRealExtensionCount - 1 do
				local tempStr, qual = LuaFnGetPetSoulDataInBag(g_BagIndex, "TIPS", i)
				g_BeforeText[i+1]:SetText(tempStr)
				if qual == 4 then
					g_nBeforePerfect = g_nBeforePerfect + 1
				end
			end
			
		----------------------------------------------------------------------------------没洗过且槽位已经放了 替换
		elseif g_Already ~= 1 and g_BagIndex >= 0 then
			LifeAbility:Lock_Packet_Item(g_BagIndex, 0)
			if g_BagIndex ~= itemIndex then
				g_BagIndex = itemIndex
				PetSoul_XiShuxing_ClearItem()
			end
			LifeAbility:Lock_Packet_Item(g_BagIndex, 1)

			PetSoul_XiShuxing_BeforeIcon:SetActionItem(theAction:GetID())

			PetSoul_XiShuxing_OK:SetProperty("Disabled", "False");

			for i = 1, table.getn(g_BeforeText) do
				g_BeforeText[i]:SetText("")
			end

			for i = 0, iRealExtensionCount - 1 do
				local tempStr, qual = LuaFnGetPetSoulDataInBag(g_BagIndex, "TIPS", i)
				g_BeforeText[i+1]:SetText(tempStr)
				if qual == 4 then
					g_nBeforePerfect = g_nBeforePerfect + 1
				end
			end
			g_Already = 0
		------------------------------------------------------------------------------------------已经洗了
		elseif g_Already == 1 and g_BagIndex >= 0 then
			if isConfirm == 0 then--二次确认
				PushEvent("PETSOUL_XISHUXING_CONFIRM", 3, itemIndex)
			else
				LifeAbility:Lock_Packet_Item(g_BagIndex, 0)
				PetSoul_XiShuxing_BeforeIcon:SetActionItem(-1)
				PetSoul_XiShuxing_BeforeIcon:SetActionItem(theAction:GetID())
				PetSoul_XiShuxing_AfterIcon:SetProperty("Image","set:CommonItem image:ActionBK")
				if g_BagIndex ~= itemIndex then
					g_BagIndex = itemIndex
					PetSoul_XiShuxing_ClearItem()
				end
				LifeAbility:Lock_Packet_Item(g_BagIndex, 1)
				

				PetSoul_XiShuxing_OK:SetProperty("Disabled", "False");

				for i = 1, table.getn(g_BeforeText) do
					g_BeforeText[i]:SetText("")
					g_AfterText[i]:SetText("")
				end

				for i = 0, iRealExtensionCount - 1 do
				local tempStr, qual = LuaFnGetPetSoulDataInBag(g_BagIndex, "TIPS", i)
					g_BeforeText[i+1]:SetText(tempStr)
					if qual == 4 then
						g_nBeforePerfect = g_nBeforePerfect + 1
					end
				end
				g_Already = 0
			end
		end
	
		PetSoul_XiShuxing_WantNum:SetProperty("MoneyNumber", tostring(50000))
		
	else
		PetSoul_XiShuxing_Clear()
	end
end

function PetSoul_XiShuxing_ShowResult()

	g_Already = 1
	PetSoul_XiShuxing_AfterIcon:SetProperty("Image","set:CommonItem image:ActionBK")
	
	local theAction = EnumAction(g_BagIndex, "packageitem")

	if theAction:GetID() ~= 0 then
		if LuaFnIsPetSoul(g_BagIndex) ~= 1 then
			return
		end
		local _,icon =  LifeAbility : GetPrescr_Material(theAction:GetDefineID())
		PetSoul_XiShuxing_AfterIcon:SetProperty("Image",GetIconFullName(icon))

		for i = 1, table.getn(g_AfterText) do
			g_AfterText[i]:SetText("")
		end

	    --根据品质获得条目数量
		local iRealExtensionCount = 0
		local iQual = LuaFnGetPetSoulDataInBag(g_BagIndex, "QUAL")
		if iQual == 0 then
			iRealExtensionCount = 4
		elseif iQual == 1 then
			iRealExtensionCount = 5
		elseif iQual == 2 then
			iRealExtensionCount = 6
		end	
		
		for i = 0, iRealExtensionCount - 1 do
			local tempStr = LuaFnGetPetSoulExDesc(nWashAttr,i)
			g_AfterText[i+1]:SetText(tempStr)
		end
	end
	PetSoul_XiShuxing_HaveNum:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
	PetSoul_XiShuxing_HaveGoldNum:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
	
	--刷新道具
	if g_ItemIndex >= 0 then

		local itemId = PlayerPackage : GetItemTableIndex(g_ItemIndex) --没有了返回-1
		if itemId <= 0 then
			if g_ItemIndex >= 0 then
				LifeAbility:Lock_Packet_Item(g_ItemIndex, 0)
				g_ItemIndex = -1
			end
			PetSoul_XiShuxing_NeedIcon:SetActionItem(-1)
			PetSoul_XiShuxing_NeedNum:SetText("")
			PetSoul_XiShuxing_NeedNumBK:Hide()
		else
			local iQual = LuaFnGetPetSoulDataInBag(g_BagIndex, "QUAL")
			local nItemNum = GetBagItemNum(g_ItemIndex)
			local nNeedNum = PetSoul_XiShuxing_CalcNeedItemNum(iQual)
			local text = ""
			if nItemNum > 999 then
				text = "999+".."/"..nNeedNum
			else
				if nItemNum >= nNeedNum  then
					text = nItemNum.."/"..nNeedNum
				else
					text = "#cff0000"..nItemNum.."/"..nNeedNum
				end	
			end 
			PetSoul_XiShuxing_NeedNum:SetText(text)
			PetSoul_XiShuxing_NeedNumBK:Show()
		end
	end
end

function PetSoul_XiShuxing_UpdateItem(nIndex)

	if (nIndex == nil or nIndex < 0 ) then
		return
	end

	local itemId = PlayerPackage : GetItemTableIndex(nIndex)
	if itemId ~= g_NeedItem[0] and itemId ~= g_NeedItem[1] and itemId ~= g_NeedItem[2] and itemId ~= g_NeedRMBItem[1] and itemId ~= g_NeedRMBItem[2] then
		PushDebugMessage("#{SHCX_20211229_41}")
		return 
	end 
 	--显示需要的材料
 	if g_BagIndex < 0 then
 		PushDebugMessage("#{SHCX_20211229_19}")
 		return
 	end

 	local iQual = LuaFnGetPetSoulDataInBag(g_BagIndex, "QUAL")
	-- PushDebugMessage("iQual   "..iQual)
 	if (iQual > 0 and itemId ~= g_NeedItem[iQual] and itemId ~= g_NeedRMBItem[iQual] ) or 
 		(iQual == 0 and itemId ~= g_NeedItem[iQual]) then
 		local theAction = EnumAction(g_BagIndex, "packageitem") 
 		local szPetSoul = theAction:GetName()
 		local szItemName = LuaFnGetItemNameByTableIndex(g_NeedItem[iQual])
 		PushDebugMessage(string.format("#H洗练%s，需要%s。", szPetSoul, szItemName))
 		return
 	end

 	if g_ItemIndex >= 0 then
		LifeAbility:Lock_Packet_Item(g_ItemIndex, 0)
	end
 	g_ItemIndex = nIndex
 	-- local isBind = GetItemBindStatus(g_ItemIndex)
 	local theAction
 	-- if isBind == 1 then
 		theAction = GemMelting:UpdateProductAction(tonumber(itemId))
 	-- else
 		-- theAction = DataPool:CreateActionItemForShow(itemId, 1)
 	-- end
	
	if theAction:GetID() ~= 0 then
		PetSoul_XiShuxing_NeedIcon:SetActionItem(theAction:GetID())

		if g_ItemIndex >= 0 then
			LifeAbility:Lock_Packet_Item(g_ItemIndex, 1)
		end

	end

	local nItemNum = GetBagItemNum(g_ItemIndex)
	local nNeedNum = PetSoul_XiShuxing_CalcNeedItemNum(iQual)
	local text = ""
	if nItemNum > 999 then
		text = "999+".."/"..nNeedNum
	else
		if nItemNum > nNeedNum  then
			text = nItemNum.."/"..nNeedNum
		else
			text = "#cff0000"..nItemNum.."/"..nNeedNum
		end
		
	end 
	PetSoul_XiShuxing_NeedNum:SetText(text)
	PetSoul_XiShuxing_NeedNumBK:Show()
 end
--=========================================================
-- 确定执行功能
--=========================================================
function PetSoul_XiShuxing_OK_Clicked() 

  	if g_BagIndex <= -1 then
  		PushDebugMessage("#{SHCX_20211229_19}");
		return
  	end 

  	if g_ItemIndex <= -1 then
  		PushDebugMessage("#{SHCX_20211229_41}");
		return
  	end 

  	local nLockState = g_IsLock[6]+g_IsLock[5]*10+g_IsLock[4]*100+g_IsLock[3]*1000+g_IsLock[2]*10000+g_IsLock[1]*100000

	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("PetSoulCenter");
		Set_XSCRIPT_ScriptID(742563);
		Set_XSCRIPT_Parameter(0, 3);
		Set_XSCRIPT_Parameter(1, g_BagIndex);
		Set_XSCRIPT_Parameter(2, g_ItemIndex);
		Set_XSCRIPT_Parameter(3, nLockState);
		Set_XSCRIPT_ParamCount(4); 
	Send_XSCRIPT();	  
	
end

--=========================================================
-- 关闭界面
--=========================================================
--=========================================================
-- 界面隐藏
--=========================================================
function PetSoul_XiShuxing_OnHiden()
	-- if g_Already > 0 then
		-- PushEvent("UI_COMMAND", 80012707,2, g_BagIndex)
		-- return
	-- else
		PetSoul_XiShuxing_Clear()
	-- end

	StopCareObject_PetSoul_XiShuxing()
	this:Hide()
	return
end

function PetSoul_XiShuxing_OnEsc()

	PetSoul_XiShuxing_Clear()
	StopCareObject_PetSoul_XiShuxing()
	this:Hide()
	return
end

--=========================================================
-- 开始关心NPC，
-- 在开始关心之前需要先确定这个界面是不是已经有“关心”的NPC，
-- 如果有的话，先取消已经有的“关心”
--=========================================================
function BeginCareObject_PetSoul_XiShuxing()

	this:CareObject(g_CaredNpc, 1, "PetSoul_XiShuxing")
	return

end

--=========================================================
-- 停止对某NPC的关心
--=========================================================
function StopCareObject_PetSoul_XiShuxing()
	this:CareObject(g_CaredNpc, 0, "PetSoul_XiShuxing")
	g_CaredNpc = -1
	return
end
 

function PetSoul_XiShuxing_Frame_On_ResetPos()
  	PetSoul_XiShuxing_Frame:SetProperty("UnifiedPosition", g_PetSoul_XiShuxing_Frame_UnifiedPosition);
end

function PetSoul_XiShuxing_SaveChange_Clicked()

	if g_BagIndex == nil or g_BagIndex < 0 then
		PushDebugMessage("#{SHCX_20211229_19}");
		return
	end

	if g_Already ~= 1 then
		PushDebugMessage("#{SHCX_20211229_23}");
		return
	end
	--判断完美
	-- local count = LuaFnGetPetSoulPerfectExCount(g_BagIndex)
	-- if count >= 3 then
		-- 二次
		-- PushEvent("UI_COMMAND", 2015101514,g_BagIndex)
		-- return
	-- end
	-- LuaFnSavePetSoulExValue(g_BagIndex)
	Clear_XSCRIPT()
		Set_XSCRIPT_ScriptID( 742563 )
		Set_XSCRIPT_Function_Name( "PetSoulCenter" )
		Set_XSCRIPT_Parameter(0, 4)
		Set_XSCRIPT_Parameter(1, g_BagIndex)
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()	
end	

function PetSoul_XiShuxing_ClearAfter() 

	for i = 1, 6 do
		g_AfterText[i]:SetText("")
	end

	PetSoul_XiShuxing_AfterIcon:SetProperty("Image","set:CommonItem image:ActionBK")

	PetSoul_XiShuxing_OK:SetProperty("Disabled", "False");

	Pet:LuaFnClearPetSoulExValue()

end

function PetSoul_XiShuxing_CalcAvailableLockNum()

	for i = 1, table.getn(g_YiShouData) do
		if g_YiShouData[i].total <= g_Total[1] then
			g_AvailableLockNum[1] = g_YiShouData[i].locknum
		end
	end

	for i = 1, table.getn(g_ShenShouData) do
		if g_ShenShouData[i].total <= g_Total[2] then
			g_AvailableLockNum[2] = g_ShenShouData[i].locknum
		end
	end

end

function PetSoul_XiShuxing_CalcNeedItemNum(iQual)

	local nLock = 0
	for i = 1, table.getn(g_IsLock) do
		if g_IsLock[i] == 1 then
			nLock = nLock + 1
		end
	end
	-- PushDebugMessage("nLock   "..nLock)
	if iQual == 0 then
		return 1
	elseif iQual == 1 then
		for i = 1, table.getn(g_YiShouData) do
			if g_YiShouData[i].locknum == nLock then
				return g_YiShouData[i].needitemcount
			end
		end
	elseif iQual == 2 then
		for i = 1, table.getn(g_ShenShouData) do
			if g_ShenShouData[i].locknum == nLock then
				return g_ShenShouData[i].needitemcount
			end
		end
	end

	return 1
end

function PetSoul_XiShuxing_CheckButtonClicked( idx )
	--坑里是否有道具
	if g_BagIndex < 0 then
		PushDebugMessage("#{SHCX_20211229_19}")
		g_CheckButton[idx]:SetCheck(0)
		return
	end
	--坑里是否有兽魂道具
	local theAction = EnumAction(g_BagIndex, "packageitem")
	if theAction:GetID() ~= 0 then
		if LuaFnIsPetSoul(g_BagIndex) ~= 1 then
			PushDebugMessage("#{SHCX_20211229_19}")
			g_CheckButton[idx]:SetCheck(0)
			return
		end
	end
	--是否是神兽异兽
	local iRealExtensionCount = 0
	local iQual = LuaFnGetPetSoulDataInBag(g_BagIndex, "QUAL")
	if iQual == 0 then--灵兽
		g_CheckButton[idx]:SetCheck(0)
		PushDebugMessage("#{SHCX_20211229_37}")
		return
	elseif iQual == 1 then--异兽
		iRealExtensionCount = 5
	elseif iQual == 2 then--神兽
		iRealExtensionCount = 6
	end	
	--是否可以点
	if idx > iRealExtensionCount then
		g_CheckButton[idx]:SetCheck(0)
		return
	end
	--已经点了清空
	if g_IsLock[idx] == 1 then
		g_IsLock[idx] = 0
		g_CheckButton[idx]:SetCheck(0)
		return
	end
	--是否选多了
	local nLockNum = 0
	for i = 1, 6 do
		if g_IsLock[i] == 1 then
			nLockNum = nLockNum + 1
		end
	end
	nLockNum = nLockNum + 1
	if nLockNum > g_AvailableLockNum[iQual] then
		PushDebugMessage(string.format("#H超出可锁定的扩展条目数量，您当前最多锁定%s条扩展属性。", g_AvailableLockNum[iQual]))
		g_CheckButton[idx]:SetCheck(0)
		return
	end
	--点上
	g_IsLock[idx] = 1
	g_CheckButton[idx]:SetCheck(1)
	--刷新需要的道具
	local itemId = PlayerPackage : GetItemTableIndex(g_ItemIndex)
	local nItemNum = GetBagItemNum(g_ItemIndex)
	local nNeedNum = PetSoul_XiShuxing_CalcNeedItemNum(iQual)
	local text = ""
	if nItemNum > 999 then
		text = "999+".."/"..nNeedNum
	else
		if nItemNum >= nNeedNum  then
			text = nItemNum.."/"..nNeedNum
		else
			text = "#cff0000"..nItemNum.."/"..nNeedNum
		end	
	end 
	PetSoul_XiShuxing_NeedNum:SetText(text)
	PetSoul_XiShuxing_NeedNumBK:Show()
end

function PetSoul_XiShuxing_Help()
	PushEvent("UI_COMMAND",20220517,5)
end
