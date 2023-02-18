local g_TreasureBox_AwardPreview_UnifiedPosition
local g_TreasureBox_AwardPreview_ActionButton = {}
local g_TreasureBox_AwardPreview_ActionButton_Num = {}
local g_TreasureBox_exchange_ActionBtn = {}
local g_TreasureBox_exchange_ActionBtnNum = {}
local g_TreasureBox_AwardPreview_ItemList = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
local g_TreasureBox_AwardPreview_ItemListNum = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }

function TreasureBox_AwardPreview_PreLoad()
	this:RegisterEvent("UI_COMMAND", true);
	this:RegisterEvent("ADJEST_UI_POS", false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED", false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED", false)    --进场景关闭界面
end

function TreasureBox_AwardPreview_OnLoad()
	g_TreasureBox_AwardPreview_ItemList = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
	g_TreasureBox_AwardPreview_ItemListNum = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
	g_TreasureBox_AwardPreview_UnifiedPosition = TreasureBox_AwardPreview_Frame:GetProperty("UnifiedPosition")
	g_TreasureBox_exchange_ActionBtn[1] = TreasureBox_AwardPreview_Page1_Item1_Icon1
	g_TreasureBox_exchange_ActionBtn[2] = TreasureBox_AwardPreview_Page1_Item1_Icon2
	g_TreasureBox_exchange_ActionBtn[3] = TreasureBox_AwardPreview_Page1_Item1_Icon3
	g_TreasureBox_exchange_ActionBtn[4] = TreasureBox_AwardPreview_Page1_Item1_Icon4
	g_TreasureBox_exchange_ActionBtnNum[1] = TreasureBox_AwardPreview_Page1_Item1_Icon1_txt
	g_TreasureBox_exchange_ActionBtnNum[2] = TreasureBox_AwardPreview_Page1_Item1_Icon2_txt
	g_TreasureBox_exchange_ActionBtnNum[3] = TreasureBox_AwardPreview_Page1_Item1_Icon3_txt
	g_TreasureBox_exchange_ActionBtnNum[4] = TreasureBox_AwardPreview_Page1_Item1_Icon4_txt
	g_TreasureBox_AwardPreview_ActionButton[1] = TreasureBox_AwardPreview_Page2_Item1_Icon1
	g_TreasureBox_AwardPreview_ActionButton[2] = TreasureBox_AwardPreview_Page2_Item1_Icon2
	g_TreasureBox_AwardPreview_ActionButton[3] = TreasureBox_AwardPreview_Page2_Item1_Icon3
	g_TreasureBox_AwardPreview_ActionButton[4] = TreasureBox_AwardPreview_Page2_Item1_Icon4
	g_TreasureBox_AwardPreview_ActionButton[5] = TreasureBox_AwardPreview_Page2_Item1_Icon5
	g_TreasureBox_AwardPreview_ActionButton[6] = TreasureBox_AwardPreview_Page2_Item2_Icon1
	g_TreasureBox_AwardPreview_ActionButton[7] = TreasureBox_AwardPreview_Page2_Item2_Icon2
	g_TreasureBox_AwardPreview_ActionButton[8] = TreasureBox_AwardPreview_Page2_Item2_Icon3
	g_TreasureBox_AwardPreview_ActionButton[9] = TreasureBox_AwardPreview_Page2_Item2_Icon4
	g_TreasureBox_AwardPreview_ActionButton[10] = TreasureBox_AwardPreview_Page2_Item2_Icon5
	g_TreasureBox_AwardPreview_ActionButton[11] = TreasureBox_AwardPreview_Page2_Item3_Icon1
	g_TreasureBox_AwardPreview_ActionButton[12] = TreasureBox_AwardPreview_Page2_Item3_Icon2
	g_TreasureBox_AwardPreview_ActionButton[13] = TreasureBox_AwardPreview_Page2_Item3_Icon3
	g_TreasureBox_AwardPreview_ActionButton[14] = TreasureBox_AwardPreview_Page2_Item3_Icon4
	g_TreasureBox_AwardPreview_ActionButton[15] = TreasureBox_AwardPreview_Page2_Item3_Icon5
	g_TreasureBox_AwardPreview_ActionButton[16] = TreasureBox_AwardPreview_Page2_Item4_Icon1
	g_TreasureBox_AwardPreview_ActionButton[17] = TreasureBox_AwardPreview_Page2_Item4_Icon2
	g_TreasureBox_AwardPreview_ActionButton[18] = TreasureBox_AwardPreview_Page2_Item4_Icon3
	g_TreasureBox_AwardPreview_ActionButton[19] = TreasureBox_AwardPreview_Page2_Item4_Icon4
	g_TreasureBox_AwardPreview_ActionButton[20] = TreasureBox_AwardPreview_Page2_Item4_Icon5
	g_TreasureBox_AwardPreview_ActionButton_Num[1] = TreasureBox_AwardPreview_Page2_Item1_Icon1_txt
	g_TreasureBox_AwardPreview_ActionButton_Num[2] = TreasureBox_AwardPreview_Page2_Item1_Icon2_txt
	g_TreasureBox_AwardPreview_ActionButton_Num[3] = TreasureBox_AwardPreview_Page2_Item1_Icon3_txt
	g_TreasureBox_AwardPreview_ActionButton_Num[4] = TreasureBox_AwardPreview_Page2_Item1_Icon4_txt
	g_TreasureBox_AwardPreview_ActionButton_Num[5] = TreasureBox_AwardPreview_Page2_Item1_Icon5_txt
	g_TreasureBox_AwardPreview_ActionButton_Num[6] = TreasureBox_AwardPreview_Page2_Item2_Icon1_txt
	g_TreasureBox_AwardPreview_ActionButton_Num[7] = TreasureBox_AwardPreview_Page2_Item2_Icon2_txt
	g_TreasureBox_AwardPreview_ActionButton_Num[8] = TreasureBox_AwardPreview_Page2_Item2_Icon3_txt
	g_TreasureBox_AwardPreview_ActionButton_Num[9] = TreasureBox_AwardPreview_Page2_Item2_Icon4_txt
	g_TreasureBox_AwardPreview_ActionButton_Num[10] = TreasureBox_AwardPreview_Page2_Item2_Icon5_txt
	g_TreasureBox_AwardPreview_ActionButton_Num[11] = TreasureBox_AwardPreview_Page2_Item3_Icon1_txt
	g_TreasureBox_AwardPreview_ActionButton_Num[12] = TreasureBox_AwardPreview_Page2_Item3_Icon2_txt
	g_TreasureBox_AwardPreview_ActionButton_Num[13] = TreasureBox_AwardPreview_Page2_Item3_Icon3_txt
	g_TreasureBox_AwardPreview_ActionButton_Num[14] = TreasureBox_AwardPreview_Page2_Item3_Icon4_txt
	g_TreasureBox_AwardPreview_ActionButton_Num[15] = TreasureBox_AwardPreview_Page2_Item3_Icon5_txt
	g_TreasureBox_AwardPreview_ActionButton_Num[16] = TreasureBox_AwardPreview_Page2_Item4_Icon1_txt
	g_TreasureBox_AwardPreview_ActionButton_Num[17] = TreasureBox_AwardPreview_Page2_Item4_Icon2_txt
	g_TreasureBox_AwardPreview_ActionButton_Num[18] = TreasureBox_AwardPreview_Page2_Item4_Icon3_txt
	g_TreasureBox_AwardPreview_ActionButton_Num[19] = TreasureBox_AwardPreview_Page2_Item4_Icon4_txt
	g_TreasureBox_AwardPreview_ActionButton_Num[20] = TreasureBox_AwardPreview_Page2_Item4_Icon5_txt
end

function TreasureBox_AwardPreview_OnEvent(event)
	if (event == "UI_COMMAND" and tonumber(arg0) == 88819005) then
		TreasureBox_AwardPreview_UpDate()
		this:Show()
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 20201214) then
		GameProduceLogin:OpenURL(Get_XParam_STR(0))
	elseif (event == "ADJEST_UI_POS") then
		TreasureBox_AwardPreview_On_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		TreasureBox_AwardPreview_On_ResetPos()
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		this:Hide()
	end
end

function TreasureBox_AwardPreview_UpDate()
	local nServerData_1 = Split(Get_XParam_STR(0), ",")
	local nServerData_2 = Split(Get_XParam_STR(1), ",")
	local ActionIds = { 30000006, 30000007, 30000008, 30000009 }
	for j = 1, 4 do
		local actionItem = GemMelting:UpdateProductAction(ActionIds[j])
		g_TreasureBox_exchange_ActionBtn[j]:SetActionItem(actionItem:GetID())
		g_TreasureBox_exchange_ActionBtnNum[j]:SetText("1")
	end
	for i = 1, 20 do
		g_TreasureBox_AwardPreview_ActionButton_Num[i]:Hide()
		g_TreasureBox_AwardPreview_ActionButton[i]:Hide()
		if nServerData_1[i] ~= nil and nServerData_1[i] ~= "" then
			local theAction = GemMelting:UpdateProductAction(tonumber(nServerData_1[i]));
			g_TreasureBox_AwardPreview_ActionButton[i]:SetActionItem(theAction:GetID());
			g_TreasureBox_AwardPreview_ActionButton[i]:Show()
			g_TreasureBox_AwardPreview_ActionButton_Num[i]:Show()
			g_TreasureBox_AwardPreview_ActionButton_Num[i]:SetText(nServerData_2[i])
		end
	end
end

function TreasureBox_AwardPreview_InputOK()
	local cardNum = TreasureBox_AwardPreview_Input:GetText();
	if cardNum == nil then
		PushDebugMessage("请输入狩猎码。");
		return
	end
	NewUserCard(cardNum)
end

function TreasureBox_AwardPreview_InputOK_test()
	Clear_XSCRIPT()
	Set_XSCRIPT_Function_Name("CheckExchangeItem");
	Set_XSCRIPT_ScriptID(2302121);
	Set_XSCRIPT_ParamCount(0);
	Send_XSCRIPT()
end

function TreasureBox_AwardPreview_On_ResetPos()
	TreasureBox_AwardPreview_Frame:SetProperty("UnifiedPosition", g_TreasureBox_AwardPreview_UnifiedPosition);
end

function TreasureBox_AwardPreview_OnClose()
	this:Hide()
end

function TreasureBox_AwardPreview_OnHiden()
	this:Hide()
end


