--秀场列表选择界面(客户端)

--控件列表
local m_Controls = {}
local g_Frame_UnifiedPosition
local g_selectIndex = -1

function ShowNotice_PreLoad()
	this:RegisterEvent("OPEN_XIUCHANG_LIST")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("UPDATE_XIUCHANG_LIST")
end

function ShowNotice_OnLoad()
	m_Controls = {
		m_Frame = ShowNotice_Frame,
		m_List = ShowNotice_InfoList,
		m_Notice = ShowNotice_Desc,
		m_HeadIcon = ShowNotice_PlayerHead,
		m_Name = ShowNotice_Name,
		m_Charm = ShowNotice_Value
	}
	
	g_Frame_UnifiedPosition=m_Controls.m_Frame:GetProperty("UnifiedPosition")
	m_Controls.m_Notice:AddTextElement("#{XCZB_160105_7}")	
end

function ShowNotice_OnEvent(event)
	if ( event == "OPEN_XIUCHANG_LIST" ) then
		ShowNotice_Open()	
	elseif (event == "UPDATE_XIUCHANG_LIST" ) then
		ShowNotice_Update()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		ShowNotice_Frame_On_ResetPos()
	elseif( event == "ADJEST_UI_POS" ) then
		ShowNotice_Frame_On_ResetPos()
	end
end

function ShowNotice_Open()
	--local isInHell = IsInHell()
	--if isInHell == 1 then
	--	return
	--end

	ShowNotice_Update()
	this:Show()
end

function ShowNotice_Close()
	this:Hide()
end

function ShowNotice_Frame_On_ResetPos()
	m_Controls.m_Frame:SetProperty("UnifiedPosition", g_Frame_UnifiedPosition)
end

function ShowNotice_Update()
	ShowNotice_ClearUI()
	local m_DataCount = DataPool:GetXiuChangRoomCount()
	if m_DataCount > 0 then
		for ind = 0, m_DataCount - 1 do
				local tName,tCharm,tTimeStr,tSex=DataPool:GetXiuChangRoomInfo(ind)
				if tName == nil then
					return
				end
				m_Controls.m_List:AddNewItem(tTimeStr, 0 , ind)
				m_Controls.m_List:AddNewItem(tName, 1 , ind)	
		end
		g_selectIndex = DataPool:GetXiuChangSelectRoomInd()
		m_Controls.m_List:SetSelectItem(g_selectIndex)
		ShowNotice_SetUI()
	end
	
end

--关闭按钮回调
function ShowNotice_Quit_Clicked()
	ShowNotice_Close()
end

--观看直播按钮回调
function ShowNotice_Show_Clicked()
	if g_selectIndex ~= -1 then
		OpenXiuChangRoom(g_selectIndex)
	end
end

--列表项点击事件回调
function ShowNotice_OnSelectionChanged()
	g_selectIndex = m_Controls.m_List:GetSelectItem()
	DataPool:SetXiuChangSelectRoomInd(g_selectIndex)
	ShowNotice_SetUI()
end

--清空UI
function ShowNotice_ClearUI()
	m_Controls.m_List:RemoveAllItem()
	m_Controls.m_Name:SetText(" ")
	m_Controls.m_Charm:SetText(" ")
end

--设置UI
function ShowNotice_SetUI()
	if g_selectIndex == -1 then
		return
	end
	local tName,tCharm,tTimeStr,tSex=DataPool:GetXiuChangRoomInfo(g_selectIndex)
	m_Controls.m_Name:SetText(tName)
	local sCharm = ScriptGlobal_Format("#{XCZB_160105_6}",tCharm)
	m_Controls.m_Charm:SetText(sCharm)
	if tSex == 1 then
		m_Controls.m_HeadIcon:SetProperty("Image", "set:ManProtagonist1 image:ManProtagonist1_20")
	else
		m_Controls.m_HeadIcon:SetProperty("Image", "set:GirlProtagonist1 image:GirlProtagonist1_20")
	end
end
