----------------------
-- ValentineRosePrizePreview ---
----------------------
local g_ValentineRosePrizePreview_UnifiedPosition = nil
local g_ValentineRosePrizePreview_CurIndex = 0
local g_ValentineRosePrizePreview_CurPage = 0
--礼盒信息
local g_ValentineRosePrizePreview_Gift =
{
	[1] = {title = "", icon = "set:RosebangUI3 image:Rosebang_shizhuang"},
	[2] = {title = "", icon = "set:RosebangUI4 image:Rosebang_zuoqi"},
	[3] = {title = "", icon = "set:RosebangUI5 image:Rosebang_zenshou"},
}

function ValentineRosePrizePreview_PreLoad()
	this:RegisterEvent("OPEN_ROSETOPLIST_ZHANSHI")
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
end

--===============================================
-- OnLoad()
--===============================================
function ValentineRosePrizePreview_OnLoad()
	g_ValentineRosePrizePreview_UnifiedPosition = ValentineRosePrizePreview_Frame:GetProperty("UnifiedPosition")	
end

--===============================================
-- OnEvent()
--===============================================
function ValentineRosePrizePreview_OnEvent(event)
	if (event == "OPEN_ROSETOPLIST_ZHANSHI") then
		local index = tonumber(arg0)
		local ipage = tonumber(arg1)
		if index == nil or index < 1 or index > 3 then
			return
		end
		
		if ipage < 1 or ipage > 3 then
			return
		end
		if this:IsVisible() then
			if g_ValentineRosePrizePreview_CurIndex == index  and g_ValentineRosePrizePreview_CurPage == ipage then
				ValentineRosePrizePreview_OnHiden()
				return
			end
		end
		g_ValentineRosePrizePreview_CurIndex = index
		g_ValentineRosePrizePreview_CurPage = ipage
		--local strTitle = g_ValentineRosePrizePreview_Gift[index].title
		if g_ValentineRosePrizePreview_CurPage == 2 then
			local strIcon = g_ValentineRosePrizePreview_Gift[1].icon
			--ValentineRosePrizePreview_Client:SetText(strTitle)
			ValentineRosePrizePreview_Pic:SetProperty("Image",strIcon)--显示指定图片
		elseif g_ValentineRosePrizePreview_CurPage == 3 then
			local strIcon = g_ValentineRosePrizePreview_Gift[2].icon
			--ValentineRosePrizePreview_Client:SetText(strTitle)
			ValentineRosePrizePreview_Pic:SetProperty("Image",strIcon)--显示指定图片
		else
			local strIcon = g_ValentineRosePrizePreview_Gift[3].icon
			--ValentineRosePrizePreview_Client:SetText(strTitle)
			ValentineRosePrizePreview_Pic:SetProperty("Image",strIcon)--显示指定图片
		end
		this:Show()
	elseif(event == "VIEW_RESOLUTION_CHANGED") then
		ValentineRosePrizePreview_ResetPos()
	elseif(event == "ADJEST_UI_POS") then
		ValentineRosePrizePreview_ResetPos()
	elseif(event == "HIDE_ON_SCENE_TRANSED") then
		ValentineRosePrizePreview_OnHiden()
	end
end

function ValentineRosePrizePreview_ResetPos()
		ValentineRosePrizePreview_Frame:SetProperty("UnifiedPosition",g_ValentineRosePrizePreview_UnifiedPosition)
end

function ValentineRosePrizePreview_OnHiden()
	g_ValentineRosePrizePreview_CurIndex = 0
	g_ValentineRosePrizePreview_CurPage = 0
	this:Hide()
end