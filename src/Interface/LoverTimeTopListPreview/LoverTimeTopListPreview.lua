----------------------
-- LoverTimeTopListPreview ---
----------------------
local g_LoverTimeTopListPreview_UnifiedPosition = nil

local g_LoverTimeTopListPreview_CurIdx = 1
local g_LoverTimeTopListPreview_CurPage = 1

--¿Ò∫––≈œ¢
local g_LoverTimeTopListPreview_SGift =
{
[1] = {
	[1] = { 30309096, 1 },
	[2] = { 30309097, 1 },
	[3] = { 30309098, 1 },
	[4] = { 30309996, 1 },
	[5] = { 30309989, 1 },
	},
[2] = {
	[1] = { 10124665, 1 },
	[2] = { 10124664, 1 },
	[3] = { 10124663, 1 },
	[4] = { 10124700, 1 },
	[5] = { 10124662, 1 },
	},
[3] = {
	[1] = { 10142023, 1 },
	[2] = { 10142022, 1 },
	[3] = { 10142021, 1 },
	[4] = { 10142025, 1 },
	[5] = { 10142020, 1 },
	},
}
local g_LoverTimeTopListPreview_STitle = 39920099

local g_LoverTimeTopListPreview_Button = {}

local g_LoverTimeTopListPreview_RGift =
{
[1] = {
	[1] = { 30309096, 1 },
	[2] = { 30309097, 1 },
	[3] = { 30309098, 1 },
	[4] = { 30309996, 1 },
	[5] = { 30309989, 1 },
	},
[2] = {
	[1] = { 10124665, 1 },
	[2] = { 10124664, 1 },
	[3] = { 10124663, 1 },
	[4] = { 10124700, 1 },
	[5] = { 10124662, 1 },
	},
[3] = {
	[1] = { 10142023, 1 },
	[2] = { 10142022, 1 },
	[3] = { 10142021, 1 },
	[4] = { 10142025, 1 },
	[5] = { 10142020, 1 },
	},
}
local g_LoverTimeTopListPreview_RTitle = 39920100

local g_LoverTimeTopListPreview_Titlestr = {
"#{QRZM_211119_132}","#{QRZM_211119_164}","#{QRZM_211119_148}",
}

local g_LoverTimeTopListPreview_Image = {
[1] = {"set:LoverTime03 image:LoverTime_SongZhenShou", "set:LoverTime04 image:LoverTime_ShouZhenShou"},
[2] = {"set:LoverTime03 image:LoverTime_SongShiZhuang","set:LoverTime04 image:LoverTime_ShouShiZhuang"},
[3] = {"set:LoverTime03 image:LoverTime_SongZuoQi","set:LoverTime04 image:LoverTime_ShouZuoQi"},
}

function LoverTimeTopListPreview_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("OPEN_QINGRENJIETOPLIST_ZHANSHI")
	
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false);
end

--===============================================
-- OnLoad()
--===============================================
function LoverTimeTopListPreview_OnLoad()
	g_LoverTimeTopListPreview_Button = {
		[1] = LoverTimeTopListPreview_Num6Award1, 
		[2] = LoverTimeTopListPreview_Num2Award1, 
		[3] = LoverTimeTopListPreview_Num3Award1,
		[4] = LoverTimeTopListPreview_Num4Award1, 
		[5] = LoverTimeTopListPreview_Num5Award1,
	}
	
	g_LoverTimeTopListPreview_UnifiedPosition = LoverTimeTopListPreview_Frame:GetProperty("UnifiedPosition")	
end

--===============================================
-- OnEvent()
--===============================================
function LoverTimeTopListPreview_OnEvent(event)
	if (event == "OPEN_QINGRENJIETOPLIST_ZHANSHI") then
		local bShow = tonumber(arg0)
		local nCurPage = tonumber(arg1)
		
		if nCurPage == nil or g_LoverTimeTopListPreview_SGift[nCurPage] == nil or 
								g_LoverTimeTopListPreview_RGift[nCurPage] == nil then
			LoverTimeTopListPreview_Close_Click()
			return
		end
		
		if(IsWindowShow("LoverTimeTopListPreview")) then
			CloseWindow("LoverTimeTopListPreview", true)
			return
		end
		
		LoverTimeTopListPreview_Init(nCurPage, 1, 1)
		
	elseif(event == "VIEW_RESOLUTION_CHANGED") then
		LoverTimeTopListPreview_ResetPos()
	elseif(event == "ADJEST_UI_POS") then
		LoverTimeTopListPreview_ResetPos()
	elseif(event == "HIDE_ON_SCENE_TRANSED") then
		LoverTimeTopListPreview_OnHiden()
	end
end

function LoverTimeTopListPreview_Init(nCurPage, bSend, nCurIdx)

	if nCurPage == nil or g_LoverTimeTopListPreview_SGift[nCurPage] == nil or g_LoverTimeTopListPreview_RGift[nCurPage] == nil then
		LoverTimeTopListPreview_Close_Click()
		return
	end
	
	g_LoverTimeTopListPreview_CurPage = nCurPage
	
	LoverTimeTopListPreview_Clear()
	
	g_LoverTimeTopListPreview_CurIdx = nCurIdx
	if nCurIdx == 1 then
		LoverTimeTopListPreview_PresentBtn:SetCheck(1)
		LoverTimeTopListPreview_ReceiveBtn:SetCheck(0)
	else
		LoverTimeTopListPreview_PresentBtn:SetCheck(0)
		LoverTimeTopListPreview_ReceiveBtn:SetCheck(1)
	end
	
	if g_LoverTimeTopListPreview_Titlestr[nCurPage] ~= nil then
		LoverTimeTopListPreview_DragTitle:SetText(g_LoverTimeTopListPreview_Titlestr[nCurPage])
	end
	
	if bSend == 1 then
		if nCurPage == 2 then			
			local theAction = DataPool:CreateActionItemForShow(g_LoverTimeTopListPreview_STitle, 1)
			if theAction:GetID() ~= 0 then
				LoverTimeTopListPreview_Num1Award2:SetActionItem(theAction:GetID())
			end
			LoverTimeTopListPreview_Num1BK:Show()
			LoverTimeTopListPreview_Num6BK:Hide()
		else
			LoverTimeTopListPreview_Num1BK:Hide()
			LoverTimeTopListPreview_Num6BK:Show()
		end
		for i = 1, 5 do
			local itemid = g_LoverTimeTopListPreview_SGift[nCurPage][i][1]
			local itemnum = g_LoverTimeTopListPreview_SGift[nCurPage][i][2]
			local theAction = DataPool:CreateActionItemForShow(itemid, itemnum)
			if theAction:GetID() ~= 0 then
				if nCurPage == 2 and i == 1 then
					LoverTimeTopListPreview_Num1Award1:SetActionItem(theAction:GetID())	
				else
					g_LoverTimeTopListPreview_Button[i]:SetActionItem(theAction:GetID())
				end
			end
		end
		
		if g_LoverTimeTopListPreview_Image[nCurPage][1] ~= nil then
			LoverTimeTopListPreview_Pic:SetProperty("Image", g_LoverTimeTopListPreview_Image[nCurPage][1])
		end
	else
		if nCurPage == 2 then			
			local theAction = DataPool:CreateActionItemForShow(g_LoverTimeTopListPreview_RTitle, 1)
			if theAction:GetID() ~= 0 then
				LoverTimeTopListPreview_Num1Award2:SetActionItem(theAction:GetID())
			end
			LoverTimeTopListPreview_Num1BK:Show()
			LoverTimeTopListPreview_Num6BK:Hide()
		else
			LoverTimeTopListPreview_Num1BK:Hide()
			LoverTimeTopListPreview_Num6BK:Show()
		end
		for i = 1, 5 do
			local itemid = g_LoverTimeTopListPreview_RGift[nCurPage][i][1]
			local itemnum = g_LoverTimeTopListPreview_RGift[nCurPage][i][2]
			local theAction = DataPool:CreateActionItemForShow(itemid, itemnum)
			if theAction:GetID() ~= 0 then
				if nCurPage == 2 and i == 1 then
					LoverTimeTopListPreview_Num1Award1:SetActionItem(theAction:GetID())	
				else
					g_LoverTimeTopListPreview_Button[i]:SetActionItem(theAction:GetID())
				end
			end
		end
		
		if g_LoverTimeTopListPreview_Image[nCurPage][2] ~= nil then
			LoverTimeTopListPreview_Pic:SetProperty("Image", g_LoverTimeTopListPreview_Image[nCurPage][2])
		end
	end
	
	this:Show()
end

function LoverTimeTopListPreview_ResetPos()
	LoverTimeTopListPreview_Frame:SetProperty("UnifiedPosition", g_LoverTimeTopListPreview_UnifiedPosition)
end

function LoverTimeTopListPreview_OnHiden()
	this:Hide()
end

function LoverTimeTopListPreview_Close_Click()
	this:Hide()
end

function LoverTimeTopListPreview_Clear()
	for i = 1, 5 do
		g_LoverTimeTopListPreview_Button[i]:SetActionItem(-1)		
	end
	LoverTimeTopListPreview_Num1Award1:SetActionItem(-1)		
	LoverTimeTopListPreview_Num1Award2:SetActionItem(-1)	
end

function LoverTimeTopListPreview_Present_Click()
	if g_LoverTimeTopListPreview_CurIdx == 1 then
		return
	end
	
	g_LoverTimeTopListPreview_CurIdx = 1
	LoverTimeTopListPreview_PresentBtn:SetCheck(1)
	LoverTimeTopListPreview_ReceiveBtn:SetCheck(0)
	
	LoverTimeTopListPreview_Init(g_LoverTimeTopListPreview_CurPage, 1, 1)
end

function LoverTimeTopListPreview_Receive_Click()
	if g_LoverTimeTopListPreview_CurIdx == 2 then
		return
	end
	
	g_LoverTimeTopListPreview_CurIdx = 2
	LoverTimeTopListPreview_ReceiveBtn:SetCheck(1)
	LoverTimeTopListPreview_PresentBtn:SetCheck(0)
	
	LoverTimeTopListPreview_Init(g_LoverTimeTopListPreview_CurPage, 0, 2)
end

