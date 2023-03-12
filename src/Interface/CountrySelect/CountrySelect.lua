---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by ZJJ.
--- DateTime: 2023/3/3 19:08

local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;
local g_Country_selected = -1
local g_Country_Ctrl = {}

function CountrySelect_PreLoad()
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("UI_COMMAND");
end

function CountrySelect_OnLoad()
	g_Country_Ctrl[1] = CountrySelect_Song
	g_Country_Ctrl[2] = CountrySelect_Liao
	g_Country_Ctrl[3] = CountrySelect_Yan
end

function CountrySelect_OnEvent(event)
	if event == "UI_COMMAND" and tonumber(arg0) == 919001 then
		local xx = Get_XParam_INT(0);
		objCared = DataPool:GetNPCIDByServerID(xx);
		this:CareObject(objCared, 1, "Country")
		this:Show()
	elseif (event == "OBJECT_CARED_EVENT") then
		if (tonumber(arg0) ~= objCared) then
			return
		end
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if (arg1 == "distance" and tonumber(arg2) > MAX_OBJ_DISTANCE or arg1 == "destroy") then
			CountrySelect_Cancel_Click()
		end
	end
end

function CountrySelect_Confirm_Click()
	if (g_Country_selected or -1) <= 0 then
		PushDebugMessage("请先选择一个国家!")
		return
	end
	Clear_XSCRIPT()
	Set_XSCRIPT_Function_Name("updateUserCountry");
	Set_XSCRIPT_ScriptID(2302251);
	Set_XSCRIPT_Parameter(0, g_Country_selected);
	Set_XSCRIPT_ParamCount(1);
	Send_XSCRIPT()
	CountrySelect_Cancel_Click()
end

function CountrySelect_Cancel_Click()
	for i = 1, table.getn(g_Country_Ctrl) do
		g_Country_Ctrl[i]:SetProperty("Disabled", "False")
	end
	g_Country_selected = -1
	this:CareObject(objCared, 0, "Country")
	this:Hide()
end

function CountrySelect_Click(index)
	for i = 1, table.getn(g_Country_Ctrl) do
		if index == i then
			g_Country_Ctrl[i]:SetProperty("Disabled", "True")
		else
			g_Country_Ctrl[i]:SetProperty("Disabled", "False")
		end
	end
	g_Country_selected = 10000 + index
end