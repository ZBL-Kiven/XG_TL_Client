--排行榜
local g_acme_TopList_Frame_UnifiedPosition;

local g_acme_TopList = {}

local g_acme_TopListIndex = 1
local acme_toplistdata = {}
local MenPaiName = {"少林","明教","丐帮","武当","峨嵋","星宿","天龙","天山","逍遥","无门派","曼陀山庄"}

function acme_TopList_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("UPDATE_NOTIFY");
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("TOGLE_SYSTEMFRAME");
end

function acme_TopList_OnLoad()
	g_acme_TopList_Frame_UnifiedPosition=acme_TopList_Frame:GetProperty("UnifiedPosition");
	g_acme_TopList = {acme_TopList_LevelList,acme_TopList_PrizeList,acme_TopList_LabaList,acme_TopList_SongHuaList,acme_TopList_ShouHuaList,acme_TopList_ShaRenList}
end


function acme_TopList_OnEvent(event)
	
	if(event == "UI_COMMAND" and tonumber(arg0) == 202107101) then
		g_acme_TopListIndex = Get_XParam_INT(0)
		acme_toplistdata = {}
		local LinShiData = {}
		for i = 1,10 do
			LinShiData[i] = Get_XParam_STR(i-1)
		end
		for i = 1,10 do
			if LinShiData[i] ~= nil and LinShiData[i] ~= "" then
				acme_toplistdata[i] = Split(LinShiData[i],",")
			end
		end		
		acme_TopList_Init()
		this:Show();
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 202107102) then
		acme_TopList_GetString()
	end
	if event == "TOGLE_SYSTEMFRAME" then
		this:Hide()
	end
	if event == "UPDATE_NOTIFY" then
		acme_TopList_Init()
		this:Show();
	elseif (event == "ADJEST_UI_POS" ) then
		acme_TopList_Frame_On_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		acme_TopList_Frame_On_ResetPos()
	end
end

function acme_TopList_GetString()
	acme_TopList_info:SetText(Get_XParam_STR(0))
end

function acme_TopList_Init()
	for i = 1,6 do
		g_acme_TopList[i]:RemoveAllItem();
		if i == g_acme_TopListIndex then
			g_acme_TopList[i]:Show()
		else
			g_acme_TopList[i]:Hide()
		end
	end
	for i = 1,10 do
		if acme_toplistdata[i] ~= nil and acme_toplistdata[i] ~= "" then
			g_acme_TopList[g_acme_TopListIndex]:AddNewItem(i, 0, i-1);
			g_acme_TopList[g_acme_TopListIndex]:AddNewItem(MenPaiName[tonumber(acme_toplistdata[i][1])+1],1, i-1);
			g_acme_TopList[g_acme_TopListIndex]:AddNewItem(acme_toplistdata[i][2],2, i-1);
			if acme_toplistdata[i][3] ~= "无帮会" then
				g_acme_TopList[g_acme_TopListIndex]:AddNewItem(acme_toplistdata[i][3],3, i-1);
			end
			g_acme_TopList[g_acme_TopListIndex]:AddNewItem(acme_toplistdata[i][4],4, i-1);
		end
	end
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "acme_Toplistspendstring" );
		Set_XSCRIPT_ScriptID(900036);
		Set_XSCRIPT_Parameter(0,g_acme_TopListIndex);
		Set_XSCRIPT_ParamCount(1);
	Send_XSCRIPT()	
	--说明
	-- acme_TopList_info:SetText(g_acme_TopListInfo[g_acme_TopListIndex])
end


function acme_TopList_ItemSelectChanged(acme_Index)
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "acme_OpenTopList" );
		Set_XSCRIPT_ScriptID(900036);
		Set_XSCRIPT_Parameter(0,acme_Index);
		Set_XSCRIPT_ParamCount(1);
	Send_XSCRIPT()
end

function acme_TopList_Frame_On_ResetPos()
	acme_TopList_Frame:SetProperty("UnifiedPosition", g_acme_TopList_Frame_UnifiedPosition);
end

function acme_TopList_Frame_OnHiden()
	this:Hide()
end