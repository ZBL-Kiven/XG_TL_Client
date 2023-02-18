--潇湘制作QQ1400003003
local g_XiaoXiang_DuiHuanUI2_Frame_UnifiedPosition;
function XiaoXiang_DuiHuanUI2_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("SCENE_TRANSED")
end
function XiaoXiang_DuiHuanUI2_OnLoad()
	XiaoXiang_DuiHuanUI2_Bk_Icon = {
		XiaoXiang_DuiHuanUI2_Bk_Icon1,
		XiaoXiang_DuiHuanUI2_Bk_Icon2,
		XiaoXiang_DuiHuanUI2_Bk_Icon3,
		XiaoXiang_DuiHuanUI2_Bk_Icon4,
		XiaoXiang_DuiHuanUI2_Bk_Icon5,
		XiaoXiang_DuiHuanUI2_Bk_Icon6,
		XiaoXiang_DuiHuanUI2_Bk_Icon7,
		XiaoXiang_DuiHuanUI2_Bk_Icon8,
		XiaoXiang_DuiHuanUI2_Bk_Icon9,
		XiaoXiang_DuiHuanUI2_Bk_Icon10,
		XiaoXiang_DuiHuanUI2_Bk_Icon11,
		XiaoXiang_DuiHuanUI2_Bk_Icon12,
		XiaoXiang_DuiHuanUI2_Bk_Icon13,
		XiaoXiang_DuiHuanUI2_Bk_Icon14,
		XiaoXiang_DuiHuanUI2_Bk_Icon15,
		XiaoXiang_DuiHuanUI2_Bk_Icon16,
		XiaoXiang_DuiHuanUI2_Bk_Icon17,
		XiaoXiang_DuiHuanUI2_Bk_Icon18,
		XiaoXiang_DuiHuanUI2_Bk_Icon19,
		XiaoXiang_DuiHuanUI2_Bk_Icon20,
		XiaoXiang_DuiHuanUI2_Bk_Icon21,
		XiaoXiang_DuiHuanUI2_Bk_Icon22,
		XiaoXiang_DuiHuanUI2_Bk_Icon23,
		XiaoXiang_DuiHuanUI2_Bk_Icon24,
		XiaoXiang_DuiHuanUI2_Bk_Icon25,
		XiaoXiang_DuiHuanUI2_Bk_Icon26,
		XiaoXiang_DuiHuanUI2_Bk_Icon27,
		XiaoXiang_DuiHuanUI2_Bk_Icon28,
		XiaoXiang_DuiHuanUI2_Bk_Icon29,
		XiaoXiang_DuiHuanUI2_Bk_Icon30,
		XiaoXiang_DuiHuanUI2_Bk_Icon31,
		XiaoXiang_DuiHuanUI2_Bk_Icon32,
		XiaoXiang_DuiHuanUI2_Bk_Icon33,
		XiaoXiang_DuiHuanUI2_Bk_Icon34,
		XiaoXiang_DuiHuanUI2_Bk_Icon35,
		XiaoXiang_DuiHuanUI2_Bk_Icon36,
		XiaoXiang_DuiHuanUI2_Bk_Icon37,
		XiaoXiang_DuiHuanUI2_Bk_Icon38,
		XiaoXiang_DuiHuanUI2_Bk_Icon39,
		XiaoXiang_DuiHuanUI2_Bk_Icon40,
		XiaoXiang_DuiHuanUI2_Bk_Icon41,
		XiaoXiang_DuiHuanUI2_Bk_Icon42,
		XiaoXiang_DuiHuanUI2_Bk_Icon43,
		XiaoXiang_DuiHuanUI2_Bk_Icon44,
		XiaoXiang_DuiHuanUI2_Bk_Icon45,
		XiaoXiang_DuiHuanUI2_Bk_Icon46,
		XiaoXiang_DuiHuanUI2_Bk_Icon47,
		XiaoXiang_DuiHuanUI2_Bk_Icon48,
		XiaoXiang_DuiHuanUI2_Bk_Icon49,
		XiaoXiang_DuiHuanUI2_Bk_Icon50,
		XiaoXiang_DuiHuanUI2_Bk_Icon51,
		XiaoXiang_DuiHuanUI2_Bk_Icon52,
		XiaoXiang_DuiHuanUI2_Bk_Icon53,
		XiaoXiang_DuiHuanUI2_Bk_Icon54,
		XiaoXiang_DuiHuanUI2_Bk_Icon55,
		XiaoXiang_DuiHuanUI2_Bk_Icon56,
		XiaoXiang_DuiHuanUI2_Bk_Icon57,
		XiaoXiang_DuiHuanUI2_Bk_Icon58,
		XiaoXiang_DuiHuanUI2_Bk_Icon59,
		XiaoXiang_DuiHuanUI2_Bk_Icon60,
		XiaoXiang_DuiHuanUI2_Bk_Icon61,
		XiaoXiang_DuiHuanUI2_Bk_Icon62,
		XiaoXiang_DuiHuanUI2_Bk_Icon63,
		XiaoXiang_DuiHuanUI2_Bk_Icon64,
		XiaoXiang_DuiHuanUI2_Bk_Icon65,
		XiaoXiang_DuiHuanUI2_Bk_Icon66,
		XiaoXiang_DuiHuanUI2_Bk_Icon67,
		XiaoXiang_DuiHuanUI2_Bk_Icon68,
		XiaoXiang_DuiHuanUI2_Bk_Icon69,
		XiaoXiang_DuiHuanUI2_Bk_Icon70,
	}
	g_XiaoXiang_DuiHuanUI2_Frame_UnifiedPosition = XiaoXiang_DuiHuanUI2_Frame:GetProperty("UnifiedPosition");
end
function XiaoXiang_DuiHuanUI2_ResetPos()
	XiaoXiang_DuiHuanUI2_Frame:SetProperty("UnifiedPosition", g_XiaoXiang_DuiHuanUI2_Frame_UnifiedPosition);
end
function XiaoXiang_DuiHuanUI2_qingchushuju()
	for i = 1, table.getn(XiaoXiang_DuiHuanUI2_Bk_Icon) do
		XiaoXiang_DuiHuanUI2_Bk_Icon[i]:Hide()
	end
	for i = 1, table.getn(XiaoXiang_DuiHuanUI2_Bk_Icon) do
		_G["XiaoXiang_DuiHuanUI2_Bk" .. i .. "_ItemBK"]:Hide()
	end
	if Get_XParam_STR(5) ~= nil then
		XiaoXiang_DuiHuanUI2_BK1:SetProperty(Get_XParam_STR(5), Get_XParam_STR(2))
		XiaoXiang_DuiHuanUI2_BK2:SetProperty(Get_XParam_STR(5), Get_XParam_STR(3))
		XiaoXiang_DuiHuanUI2_FrameNULL_Title:SetProperty(Get_XParam_STR(5), Get_XParam_STR(4))
	end
end
local szSeparator = ","
local yixuanzeID = 0
local fanhuiID = 0
local shuzu = {}
local shuzu2 = {}
function XiaoXiang_DuiHuanUI2_Split(szFullString, szSeparator)
	local nFindStartIndex = 1
	local nSplitIndex = 1
	local nSplitArray = {}
	while true do
		local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)
		if not nFindLastIndex then
			nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))
			break
		end
		nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)
		nFindStartIndex = nFindLastIndex + string.len(szSeparator)
		nSplitIndex = nSplitIndex + 1
	end
	return nSplitArray
end
function XiaoXiang_DuiHuanUI2_OnEvent(event)
	if event == "UI_COMMAND" and tonumber(arg0) == 202202111 then
		fanhuiID = Get_XParam_INT(0)
		XiaoXiang_DuiHuanUI2_qingchushuju()
		if Get_XParam_STR(1) ~= nil then
			shuzu = XiaoXiang_DuiHuanUI2_Split(Get_XParam_STR(1), szSeparator)
		end
		for i = 1, table.getn(shuzu) do
			if shuzu[i] ~= "" then
				shuzu[i] = tostring(tonumber("0x" .. shuzu[i], 16))
			end
		end
		for i = 1, table.getn(shuzu) do
			if shuzu[i] ~= nil and shuzu[i] ~= "" and tonumber(shuzu[i]) > 10000000 then
				XiaoXiang_DuiHuanUI2_Bk_Icon[i]:Show();
				_G["XiaoXiang_DuiHuanUI2_Bk" .. i .. "_ItemBK"]:Show()
				local PrizeAction = GemMelting:UpdateProductAction(tonumber(shuzu[i]))
				XiaoXiang_DuiHuanUI2_Bk_Icon[i]:SetActionItem(PrizeAction:GetID());
			end
		end
		XiaoXiang_DuiHuanUI2_Frame_Texta3:SetText("#e336600#gFFF0F5请选择要兑换的物品")
		XiaoXiang_DuiHuanUI2_OK:Disable();
		this:Show();
	elseif event == "UI_COMMAND" and tonumber(arg0) == 202202112 then
		if Get_XParam_STR(0) ~= nil then
			shuzu2 = XiaoXiang_DuiHuanUI2_Split(Get_XParam_STR(0), szSeparator)
		end
		yixuanzeID = Get_XParam_INT(0)
		XiaoXiang_DuiHuanUI2_Clicked2(yixuanzeID)
	elseif (event == "ADJEST_UI_POS") then
		XiaoXiang_DuiHuanUI2_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		XiaoXiang_DuiHuanUI2_ResetPos()
	elseif (event == "SCENE_TRANSED") then
		this:Hide()
	end
end
function XiaoXiang_DuiHuanUI2_Clicked(nIndex)
	for i = 1, table.getn(XiaoXiang_DuiHuanUI2_Bk_Icon) do
		XiaoXiang_DuiHuanUI2_Bk_Icon[i]:SetPushed(0);
	end
	Clear_XSCRIPT()
	Set_XSCRIPT_Function_Name("DuiHuan33");
	Set_XSCRIPT_ScriptID(955555);
	Set_XSCRIPT_Parameter(0, 1);
	Set_XSCRIPT_Parameter(1, tonumber(nIndex));
	Set_XSCRIPT_Parameter(2, tonumber(shuzu[nIndex]));
	Set_XSCRIPT_ParamCount(3);
	Send_XSCRIPT()
end
function XiaoXiang_DuiHuanUI2_Clicked2(nIndex)
	XiaoXiang_DuiHuanUI2_Bk_Icon[nIndex]:SetPushed(1);
	XiaoXiang_DuiHuanUI2_OK:Enable();
	XiaoXiang_DuiHuanUI2_Frame_Texta3:SetText("#e336600#gFFF0F5兑换[" .. shuzu2[1] .. "]  " .. "  需要[" .. shuzu2[2] .. "]" .. "    [" .. shuzu2[3] .. "]个")
end
function XiaoXiang_DuiHuanUI2_OK_Clicked(nIndex)
	Clear_XSCRIPT()
	Set_XSCRIPT_Function_Name("DuiHuan33");
	Set_XSCRIPT_ScriptID(955555);
	Set_XSCRIPT_Parameter(0, 2);
	Set_XSCRIPT_Parameter(1, tonumber(yixuanzeID));
	Set_XSCRIPT_Parameter(2, tonumber(shuzu[yixuanzeID]));
	Set_XSCRIPT_ParamCount(3);
	Send_XSCRIPT()
end