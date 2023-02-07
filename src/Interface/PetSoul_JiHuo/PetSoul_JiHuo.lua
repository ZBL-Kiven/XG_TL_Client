--!!!reloadscript =PetSoul_JiHuo

local g_PetSoul_JiHuo_Frame_UnifiedPosition

local g_clientNpcId = -1
local g_ExteriorType = 4 						--融魂外观

local g_InitList = 0
local g_NeedChangeScrollSize = 1

local g_MaxBarNum = 0
local g_BarList = {}
local g_CurSelExteriorID = 0					--当前选择的外观ID，从1开始
local g_QualStr = {"#{SHRH_20220427_06}", "#{SHRH_20220427_05}", "#{SHRH_20220427_04}"}
local PetHunLuData = {}
--==================================
-- PetSoul_JiHuo_PreLoad
--==================================
function PetSoul_JiHuo_PreLoad()
	this:RegisterEvent("UI_COMMAND", true)
	this:RegisterEvent("ADJEST_UI_POS", false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED", false)
	this:RegisterEvent("ADD_EXTERIOR", false)
end

--==================================
-- PetSoul_JiHuo_OnLoad
--==================================
function PetSoul_JiHuo_OnLoad()
	g_PetSoul_JiHuo_Frame_UnifiedPosition = PetSoul_JiHuo_Frame:GetProperty("UnifiedPosition")
	g_CurSelExteriorID = 0
	for i = 1,15 do
		table.insert(g_BarList,{A1 = _G[string.format("PetSoul_JiHuo_SuperListItemAction%d",i)],A2 = _G[string.format("PetSoul_JiHuo_SuperListItemActionLock%d",i)],A3 = _G[string.format("PetSoul_JiHuo_SuperListItemActionTry%d",i)],A4=_G[string.format("PetSoul_JiHuo_SuperListItemActionDef%d",i)]})
	end	
end

function PetSoul_JiHuo_Frame_On_ResetPos()
	PetSoul_JiHuo_Frame:SetProperty("UnifiedPosition", g_PetSoul_JiHuo_Frame_UnifiedPosition)
end
--==================================
-- PetSoul_JiHuo_OnEvent
--==================================
function PetSoul_JiHuo_OnEvent(event)
	
	if event == "UI_COMMAND" then
		if tonumber(arg0) == 99990301 then			
			if this:IsVisible() then
				return
			end
			
			local npcObjId = Get_XParam_INT(0)
			g_clientNpcId = DataPool:GetNPCIDByServerID(npcObjId)
			if g_clientNpcId ~= -1 then
				this:CareObject(g_clientNpcId, 1, "PetSoul_JiHuo")
			end
			local nData = Get_XParam_STR(0)
			PetHunLuData = {}
			for i = 1,15 do
				PetHunLuData[i] = tonumber(string.sub(nData,i,i))
			end
			this:Show()
			PetSoul_JiHuo_OnShown()
		end
		if tonumber(arg0) == 20220905 and this:IsVisible() then
			PetHunLuData = {}
			local nData = Get_XParam_STR(0)
			for i = 1,15 do
				PetHunLuData[i] = tonumber(string.sub(nData,i,i))
			end			
			PetSoul_JiHuo_UpdateList()
			PetSoul_JiHuo_ShowDetail()			
		end
	elseif event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		PetSoul_JiHuo_Frame_On_ResetPos()
	end

end
function PetSoul_JiHuo_OnShown()
	
	g_NeedChangeScrollSize = 1	
	
	PetSoul_JiHuo_UpdateList()
	
	PetSoul_JiHuo_ShowDetail()
end

function PetSoul_JiHuo_UpdateList()
	for i = 1, 15 do
		PetSoul_JiHuo_SetItem(i, 15)
	end
	PetSoul_JiHuo_ShowDetail()
end

function PetSoul_JiHuo_SetItem(index, max_count)
	local strName,strIcon,iQual = LuaFnGetExteriorPossInfo(index)
	local strImage = GetIconFullName(strIcon)
	local strQual = ""
	if iQual == 0 or iQual == 1 or iQual == 2 then
		strQual = g_QualStr[iQual + 1]
	end
	g_BarList[index].A1:SetProperty("Empty","False")
	g_BarList[index].A1:SetProperty("UseDefaultTooltip","True")
	g_BarList[index].A1:SetProperty("NormalImage", strImage)
	g_BarList[index].A1:SetProperty("HoverImage", strImage)
	local strTemp = string.format("兽魂：%s", strName)
	if PetHunLuData[index] == 1 and index > 6 then
		g_BarList[index].A1:SetToolTip(strQual.."#r"..strTemp.."#r#{SHRH_20220427_03}")
	else
		g_BarList[index].A1:SetToolTip(strQual.."#r"..strTemp)
	end
	g_BarList[index].A1:SetPushed(0)
	g_BarList[index].A3:Hide()
	g_BarList[index].A4:Hide()
	PushDebug(tostring(PetHunLuData[index]))
	if PetHunLuData[index] == 1 then
		g_BarList[index].A2:Hide()
	else
		g_BarList[index].A2:Show()
	end
	if iQual == 0 then
		g_BarList[index].A2:Hide()
	end
end

function PetSoul_JiHuo_SetItemSelected(nIndex)
	for i = 1,15 do
		if i == nIndex then
			g_BarList[i].A1:SetPushed(1)
		else
			g_BarList[i].A1:SetPushed(0)
		end
	end
	g_CurSelExteriorID = nIndex
	PetSoul_JiHuo_ShowDetail()
end

function PetSoul_JiHuo_ItemClicked(nIndex)
	
	local nExteriorID 	= Exterior:LuaFnGetExteriorIDFromList(g_ExteriorType, nIndex - 1)	
	if g_CurSelExteriorID == nExteriorID then
		return
	end	

	g_CurSelExteriorID = nExteriorID
	
	PetSoul_JiHuo_SetItemSelected(nIndex)
	
	PetSoul_JiHuo_ShowDetail()
end

function PetSoul_JiHuo_ShowDetail()
	
	if g_CurSelExteriorID == 0 then
		PetSoul_JiHuo_SelectPoss:Hide()
		PetSoul_JiHuo_WarningText:SetText("#{SHRH_20220427_61}")
		return
	end
	
	local strName,strIcon,iQual = LuaFnGetExteriorPossInfo(g_CurSelExteriorID)
	local strImage = GetIconFullName(strIcon)
	
	PetSoul_JiHuo_SelectPoss:Show()
	PetSoul_JiHuo_SelectPoss:SetProperty("NormalImage", strImage)
	PetSoul_JiHuo_SelectPoss:SetProperty("HoverImage", strImage)
	local name = ""
	if iQual == 1 then
		name = "荒兽绘形云墨"
	elseif iQual == 2 then
		name = "神兽绘形云墨"
	else
		PetSoul_JiHuo_WarningText:SetText("#{SHRH_20220427_62}")
		return
	end
	local need_money = 50000	
	if PetHunLuData[g_CurSelExteriorID] == 1 then
		PetSoul_JiHuo_WarningText:SetText("#{SHRH_20220427_62}")
	else
		local strTemp = string.format("你当前选中的#G魂卷#W是：#G%s#W#r需要道具：#Y%s#W*#G%s#W#r需要金钱：#{_EXCHG%s}", strName, name, tostring(1), tostring(need_money))		
		PetSoul_JiHuo_WarningText:SetText(strTemp)
	end
end

function PetSoul_JiHuo_OK_Clicked()

	if g_CurSelExteriorID == 0 then
		PushDebugMessage("#{SHRH_20220427_45}")
		return
	end

	if PetHunLuData[g_CurSelExteriorID] == 1 then
		PushDebugMessage("#{SHRH_20220427_46}")
		return
	end

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("UnlockExteriorPoss")
		Set_XSCRIPT_ScriptID(830243)
		Set_XSCRIPT_Parameter(0, g_CurSelExteriorID)
		Set_XSCRIPT_Parameter(1, 0)
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()

end

function PetSoul_JiHuo_ItemMouseMove(nIndex)

end


function PetSoul_JiHuo_OnCancel()
	this:Hide()
end

function PetSoul_JiHuo_OnClose()
	this:Hide()	
end

function PetSoul_JiHuo_OnHidden()	
	PetSoul_JiHuo_CleanUp()
end

function PetSoul_JiHuo_CleanUp()
	g_CurSelExteriorID = 0
	this:CareObject(g_clientNpcId, 0, "PetSoul_JiHuo")
	g_clientNpcId = -1
end



