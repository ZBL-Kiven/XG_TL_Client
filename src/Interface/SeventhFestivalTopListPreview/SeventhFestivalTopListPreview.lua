----------------------
-- SeventhFestivalTopListPreview ---
----------------------
local g_SeventhFestivalTopListPreview_UnifiedPosition = nil

local g_SeventhFestivalTopListPreview_CurIdx = 1
local g_SeventhFestivalTopListPreview_CurPage = 1

--¿Ò∫––≈œ¢
local g_SeventhFestivalTopListPreview_SGift =
{
[1] = {
	[1] = { 30309086, 1 },
	[2] = { 30309087, 1 },
	[3] = { 30309088, 1 },
	[4] = { 30309988, 1 },
	[5] = { 30309989, 1 },
	},
[2] = {
	[1] = { 10124519, 1 },
	[2] = { 10124518, 1 },
	[3] = { 10124517, 1 },
	[4] = { 10124543, 1 },
	[5] = { 10124516, 1 },
	},
[3] = {
	[1] = { 10141985, 1 },
	[2] = { 10141984, 1 },
	[3] = { 10141983, 1 },
	[4] = { 10141979, 1 },
	[5] = { 10141982, 1 },
	},
}
local g_SeventhFestivalTopListPreview_STitle = 39920096

local g_SeventhFestivalTopListPreview_Button = {}

local g_SeventhFestivalTopListPreview_RGift =
{
[1] = {
	[1] = { 30309086, 1 },
	[2] = { 30309087, 1 },
	[3] = { 30309088, 1 },
	[4] = { 30309988, 1 },
	[5] = { 30309989, 1 },
	},
[2] = {
	[1] = { 10124519, 1 },
	[2] = { 10124518, 1 },
	[3] = { 10124517, 1 },
	[4] = { 10124543, 1 },
	[5] = { 10124516, 1 },
	},
[3] = {
	[1] = { 10141985, 1 },
	[2] = { 10141984, 1 },
	[3] = { 10141983, 1 },
	[4] = { 10141979, 1 },
	[5] = { 10141982, 1 },
	},
}
local g_SeventhFestivalTopListPreview_RTitle = 39920097

local g_SeventhFestivalTopListPreview_Titlestr = {
"#{QXHB_20210701_132}","#{QXHB_20210701_164}","#{QXHB_20210701_148}",
}

local g_SeventhFestivalTopListPreview_Image = {
"set:QiXi_HuaBang2 image:QiXi_HuaBang2Image2",
"set:QiXi_HuaBang2 image:QiXi_HuaBang2Image3",
"set:QiXi_HuaBang2 image:QiXi_HuaBang2Image1",
}

function SeventhFestivalTopListPreview_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("OPEN_QIXITOPLIST_ZHANSHI")
	
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false);
end

--===============================================
-- OnLoad()
--===============================================
function SeventhFestivalTopListPreview_OnLoad()
	g_SeventhFestivalTopListPreview_Button = {
		[1] = SeventhFestivalTopListPreview_Num6Award1, 
		[2] = SeventhFestivalTopListPreview_Num2Award1, 
		[3] = SeventhFestivalTopListPreview_Num3Award1,
		[4] = SeventhFestivalTopListPreview_Num4Award1, 
		[5] = SeventhFestivalTopListPreview_Num5Award1,
	}
	
	g_SeventhFestivalTopListPreview_UnifiedPosition = SeventhFestivalTopListPreview_Frame:GetProperty("UnifiedPosition")	
end

--===============================================
-- OnEvent()
--===============================================
function SeventhFestivalTopListPreview_OnEvent(event)
	if (event == "OPEN_QIXITOPLIST_ZHANSHI") then
		local bShow = tonumber(arg0)
		local nCurPage = tonumber(arg1)
		
		if nCurPage == nil or g_SeventhFestivalTopListPreview_SGift[nCurPage] == nil or 
								g_SeventhFestivalTopListPreview_RGift[nCurPage] == nil then
			SeventhFestivalTopListPreview_Close_Click()
			return
		end
		
		if(IsWindowShow("SeventhFestivalTopListPreview")) then
			CloseWindow("SeventhFestivalTopListPreview", true)
			return
		end
		
		SeventhFestivalTopListPreview_Init(nCurPage, 1, 1)
		
	elseif(event == "VIEW_RESOLUTION_CHANGED") then
		SeventhFestivalTopListPreview_ResetPos()
	elseif(event == "ADJEST_UI_POS") then
		SeventhFestivalTopListPreview_ResetPos()
	elseif(event == "HIDE_ON_SCENE_TRANSED") then
		SeventhFestivalTopListPreview_OnHiden()
	end
end

function SeventhFestivalTopListPreview_Init(nCurPage, bSend, nCurIdx)

	if nCurPage == nil or g_SeventhFestivalTopListPreview_SGift[nCurPage] == nil or g_SeventhFestivalTopListPreview_RGift[nCurPage] == nil then
		SeventhFestivalTopListPreview_Close_Click()
		return
	end
	
	g_SeventhFestivalTopListPreview_CurPage = nCurPage
	
	SeventhFestivalTopListPreview_Clear()
	
	g_SeventhFestivalTopListPreview_CurIdx = nCurIdx
	if nCurIdx == 1 then
		SeventhFestivalTopListPreview_PresentBtn:SetCheck(1)
		SeventhFestivalTopListPreview_ReceiveBtn:SetCheck(0)
	else
		SeventhFestivalTopListPreview_PresentBtn:SetCheck(0)
		SeventhFestivalTopListPreview_ReceiveBtn:SetCheck(1)
	end
	
	if g_SeventhFestivalTopListPreview_Titlestr[nCurPage] ~= nil then
		SeventhFestivalTopListPreview_DragTitle:SetText(g_SeventhFestivalTopListPreview_Titlestr[nCurPage])
	end
	
	if g_SeventhFestivalTopListPreview_Image[nCurPage] ~= nil then
		SeventhFestivalTopListPreview_Pic:SetProperty("Image", g_SeventhFestivalTopListPreview_Image[nCurPage])
	end
	
	if bSend == 1 then
		if nCurPage == 2 then			
			local theAction = DataPool:CreateActionItemForShow(g_SeventhFestivalTopListPreview_STitle, 1)
			if theAction:GetID() ~= 0 then
				SeventhFestivalTopListPreview_Num1Award2:SetActionItem(theAction:GetID())
			end
			SeventhFestivalTopListPreview_Num1BK:Show()
			SeventhFestivalTopListPreview_Num6BK:Hide()
		else
			SeventhFestivalTopListPreview_Num1BK:Hide()
			SeventhFestivalTopListPreview_Num6BK:Show()
		end
		for i = 1, 5 do
			local itemid = g_SeventhFestivalTopListPreview_SGift[nCurPage][i][1]
			local itemnum = g_SeventhFestivalTopListPreview_SGift[nCurPage][i][2]
			local theAction = DataPool:CreateActionItemForShow(itemid, itemnum)
			if theAction:GetID() ~= 0 then
				if nCurPage == 2 and i == 1 then
					SeventhFestivalTopListPreview_Num1Award1:SetActionItem(theAction:GetID())	
				else
					g_SeventhFestivalTopListPreview_Button[i]:SetActionItem(theAction:GetID())
				end
			end
		end
	else
		if nCurPage == 2 then			
			local theAction = DataPool:CreateActionItemForShow(g_SeventhFestivalTopListPreview_RTitle, 1)
			if theAction:GetID() ~= 0 then
				SeventhFestivalTopListPreview_Num1Award2:SetActionItem(theAction:GetID())
			end
			SeventhFestivalTopListPreview_Num1BK:Show()
			SeventhFestivalTopListPreview_Num6BK:Hide()
		else
			SeventhFestivalTopListPreview_Num1BK:Hide()
			SeventhFestivalTopListPreview_Num6BK:Show()
		end
		for i = 1, 5 do
			local itemid = g_SeventhFestivalTopListPreview_RGift[nCurPage][i][1]
			local itemnum = g_SeventhFestivalTopListPreview_RGift[nCurPage][i][2]
			local theAction = DataPool:CreateActionItemForShow(itemid, itemnum)
			if theAction:GetID() ~= 0 then
				if nCurPage == 2 and i == 1 then
					SeventhFestivalTopListPreview_Num1Award1:SetActionItem(theAction:GetID())	
				else
					g_SeventhFestivalTopListPreview_Button[i]:SetActionItem(theAction:GetID())
				end
			end
		end
	end
	
	this:Show()
end

function SeventhFestivalTopListPreview_ResetPos()
	SeventhFestivalTopListPreview_Frame:SetProperty("UnifiedPosition", g_SeventhFestivalTopListPreview_UnifiedPosition)
end

function SeventhFestivalTopListPreview_OnHiden()
	this:Hide()
end

function SeventhFestivalTopListPreview_Close_Click()
	this:Hide()
end

function SeventhFestivalTopListPreview_Clear()
	for i = 1, 5 do
		g_SeventhFestivalTopListPreview_Button[i]:SetActionItem(-1)		
	end
	SeventhFestivalTopListPreview_Num1Award1:SetActionItem(-1)		
	SeventhFestivalTopListPreview_Num1Award2:SetActionItem(-1)	
end

function SeventhFestivalTopListPreview_Present_Click()
	if g_SeventhFestivalTopListPreview_CurIdx == 1 then
		return
	end
	
	g_SeventhFestivalTopListPreview_CurIdx = 1
	SeventhFestivalTopListPreview_PresentBtn:SetCheck(1)
	SeventhFestivalTopListPreview_ReceiveBtn:SetCheck(0)
	
	SeventhFestivalTopListPreview_Init(g_SeventhFestivalTopListPreview_CurPage, 1, 1)
end

function SeventhFestivalTopListPreview_Receive_Click()
	if g_SeventhFestivalTopListPreview_CurIdx == 2 then
		return
	end
	
	g_SeventhFestivalTopListPreview_CurIdx = 2
	SeventhFestivalTopListPreview_ReceiveBtn:SetCheck(1)
	SeventhFestivalTopListPreview_PresentBtn:SetCheck(0)
	
	SeventhFestivalTopListPreview_Init(g_SeventhFestivalTopListPreview_CurPage, 0, 2)
end

