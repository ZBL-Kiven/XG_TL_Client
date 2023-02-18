--华山论剑 参赛奖励
local g_HuaShanLunJian_GetAward_Frame_UnifiedPosition;

local g_HuaShanLunJian_GetAward_ActionItem = {}
local g_HuaShanLunJian_GetAward_HaveGetFlag = {}
local g_HuaShanLunJian_GetAward_GetPrizeButton = {}
local g_HuaShanLunJian_GetAward_Point = {}

local g_DayNeedParCnt = { 4, 8 }

function HuaShanLunJian_GetAward_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("XBW_DAY_AWARD_UPDATE")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
	
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function HuaShanLunJian_GetAward_OnLoad()
  g_HuaShanLunJian_GetAward_Frame_UnifiedPosition = HuaShanLunJian_GetAward_Frame:GetProperty("UnifiedPosition");

  g_HuaShanLunJian_GetAward_ActionItem[1] = HuaShanLunJian_GetAward_Icon1
  g_HuaShanLunJian_GetAward_ActionItem[2] = HuaShanLunJian_GetAward_Icon2

  g_HuaShanLunJian_GetAward_HaveGetFlag[1] = HuaShanLunJian_GetAward_Icon1Get
  g_HuaShanLunJian_GetAward_HaveGetFlag[2] = HuaShanLunJian_GetAward_Icon2Get

  
  g_HuaShanLunJian_GetAward_GetPrizeButton[1] = HuaShanLunJian_GetAward_Pic1Btn
  g_HuaShanLunJian_GetAward_GetPrizeButton[2] = HuaShanLunJian_GetAward_Pic2Btn
  
  g_HuaShanLunJian_GetAward_Point[1] = HuaShanLunJian_GetAward_Pic1Btn_Tips
  g_HuaShanLunJian_GetAward_Point[2] = HuaShanLunJian_GetAward_Pic2Btn_Tips
end

-- OnEvent
function HuaShanLunJian_GetAward_OnEvent(event)
	--
	if ( event == "UI_COMMAND" and tonumber(arg0) == 89289101 ) then --打开界面
		HuaShanLunJian_GetAward_BeginCare( Get_XParam_INT(0) )
		this:Show()
		
	elseif ( event == "XBW_DAY_AWARD_UPDATE" ) then
		HuaShanLunJian_GetAward_Init()
		HuaShanLunJian_GetAward_Update( )
		
	elseif ( event == "HIDE_ON_SCENE_TRANSED" ) then
		HuaShanLunJian_GetAward_Hide()

	elseif (event == "ADJEST_UI_POS" ) then
		HuaShanLunJian_GetAward_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		HuaShanLunJian_GetAward_ResetPos()
	end
end

--=========
--Care Obj
--=========
function HuaShanLunJian_GetAward_BeginCare( serverObjId )
	local objCared = DataPool : GetNPCIDByServerID(serverObjId)
	this:CareObject(objCared, 1)
end

function HuaShanLunJian_GetAward_Init( )
	for i=1, table.getn(g_HuaShanLunJian_GetAward_HaveGetFlag) do
		g_HuaShanLunJian_GetAward_HaveGetFlag[i]:Hide()
	end
	
	for i=1, table.getn(g_HuaShanLunJian_GetAward_GetPrizeButton) do
		g_HuaShanLunJian_GetAward_GetPrizeButton[i]:SetText("#{HSLJ_190919_200}")
		g_HuaShanLunJian_GetAward_GetPrizeButton[i]:Enable()
	end
	
	for i=1, table.getn(g_HuaShanLunJian_GetAward_Point) do
		g_HuaShanLunJian_GetAward_Point[i]:Hide()
	end
end


function HuaShanLunJian_GetAward_Update( )

	local nDayTotalCnt = Player:Lua_GetXbwData( "DayTotalCnt" )
	if nDayTotalCnt == 0 then
		local dayCntText = ScriptGlobal_Format("#{HSLJ_190919_254}", nDayTotalCnt)
		HuaShanLunJian_GetAward_Text:SetText(dayCntText)
	else
		local dayCntText = ScriptGlobal_Format("#{HSLJ_190919_198}", nDayTotalCnt)
		HuaShanLunJian_GetAward_Text:SetText(dayCntText)
	end
	
	local nDayTotalCnt = Player:Lua_GetXbwData( "DayTotalCnt" )
	
	for i=1, table.getn(g_HuaShanLunJian_GetAward_ActionItem) do
		local itemId, itemNum = XBW:GetXbwDayAward(i-1)
		local theAction = DataPool:CreateActionItemForShow(itemId, itemNum)
		if theAction:GetID() ~= 0 then
			g_HuaShanLunJian_GetAward_ActionItem[i]:SetActionItem(theAction:GetID())
		end
	
		--
		if nDayTotalCnt >= g_DayNeedParCnt[i] then
			g_HuaShanLunJian_GetAward_Point[i]:Show()
		end
		
		local bGetAward = Player:Lua_GetXbwData( "GetDayReward", i-1 )
		if bGetAward >= 1 then
			g_HuaShanLunJian_GetAward_HaveGetFlag[i]:Show()
			g_HuaShanLunJian_GetAward_GetPrizeButton[i]:SetText("#{HSLJ_190919_201}")
			g_HuaShanLunJian_GetAward_GetPrizeButton[i]:Disable()
			g_HuaShanLunJian_GetAward_Point[i]:Hide()
		end
	
	end
	
end


function HuaShanLunJian_GetAward_GetAward( index )
	if index == nil then
		return
	end

	if index < 1 or index > 2 then
		return
	end

	local levelIndex = Player:Lua_GetXbwData( "LevelIndex" )
	if levelIndex < 0 then
		PushDebugMessage( "#{HSLJ_190919_195}" )
		return
	end

	local bGetAward = Player:Lua_GetXbwData( "GetDayReward", index-1 )
	if bGetAward >= 1 then
		PushDebugMessage( "#{HSLJ_190919_39}" )
		return
	end

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("TryToTakePrize_Day")
		Set_XSCRIPT_ScriptID( 892891 )
		Set_XSCRIPT_Parameter( 0, index-1 )
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()

end

function HuaShanLunJian_GetAward_Hide()
	this:Hide()
end

function HuaShanLunJian_GetAward_ResetPos()
  HuaShanLunJian_GetAward_Frame:SetProperty("UnifiedPosition", g_HuaShanLunJian_GetAward_Frame_UnifiedPosition);
end
