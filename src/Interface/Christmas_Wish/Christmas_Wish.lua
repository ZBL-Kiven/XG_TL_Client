--***********************************************************************************************************************************************
-- 
--***********************************************************************************************************************************************

local g_clientNpcId = -1

local g_Christmas_Wish_Frame_UnifiedPosition;

local g_CW_PrizeList = {
10124610,10141337,38000114
}
local g_PrizeItemCtrl = {}
--local g_PrizeMaskCtrl = {}
local g_PrizeSel = -1


-- OnLoad
--
--************************************************************************************************************************************************
function Christmas_Wish_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
--	this:RegisterEvent("Christmas_Wish_TOPLIST",false)
end

function Christmas_Wish_OnLoad()
	g_Christmas_Wish_Frame_UnifiedPosition=Christmas_Wish_Frame:GetProperty("UnifiedPosition");
	g_PrizeItemCtrl = {
		Christmas_Wish_Item1_Icon,Christmas_Wish_Item2_Icon,Christmas_Wish_Item3_Icon,Christmas_Wish_Item4_Icon
	}
--	g_PrizeMaskCtrl = {
--	 Christmas_Wish_Item1_Mask,Christmas_Wish_Item2_Mask,Christmas_Wish_Item3_Mask,Christmas_Wish_Item4_Mask
--	}
end


--***********************************************************************************************************************************************
--
-- 事件响应函数
--
--
--************************************************************************************************************************************************
function Christmas_Wish_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == 88877301 ) then
		local clientNpcId = Get_XParam_INT(0)
		if clientNpcId==-1 then
			this:Hide()
			return
		end
		

		g_clientNpcId = clientNpcId
		local objId = DataPool : GetNPCIDByServerID(g_clientNpcId)
		if objId == -1 then
			return
		end
		Christmas_Wish_Update()
		this : CareObject( objId, 1, "Christmas_Wish" )
		this : Show()

	elseif (event == "ADJEST_UI_POS" ) then
		Christmas_Wish_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		Christmas_Wish_Frame_On_ResetPos()
	end
end

function Christmas_Wish_SelectClicked()
	if g_PrizeSel == -1 then
		PushDebugMessage("#{SDXY_211103_17}")
		return
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("OnShengDanSelectOK")
		Set_XSCRIPT_ScriptID(888773);
		Set_XSCRIPT_Parameter(0,g_clientNpcId);
		Set_XSCRIPT_Parameter(1,g_PrizeSel);
		Set_XSCRIPT_ParamCount(2);
	Send_XSCRIPT();
end

--function Christmas_Wish_OnClosed()
--	this:Hide()
--end


function Christmas_Wish_Frame_On_ResetPos()
  Christmas_Wish_Frame:SetProperty("UnifiedPosition", g_Christmas_Wish_Frame_UnifiedPosition);
end

function Christmas_Wish_Update()
	--前一天的奖励
	for i=1,3 do
		local showAction = DataPool:CreateBindActionItemForShow(g_CW_PrizeList[i], 1)
		if showAction:GetID() ~= 0 then
			g_PrizeItemCtrl[i]:SetActionItem(showAction:GetID())
		end
		g_PrizeItemCtrl[i]:SetPushed(0)
--		g_PrizeMaskCtrl[i]:SetCheck(0)
	end
	g_PrizeSel = -1
end

function Christmas_Wish_MaskClk(nIdx)
	for i=1,3 do
--		g_PrizeMaskCtrl[i]:SetCheck(0)
		g_PrizeItemCtrl[i]:SetPushed(0)
	end
	g_PrizeSel = nIdx
--	g_PrizeMaskCtrl[g_PrizeSel]:SetCheck(0)
	g_PrizeItemCtrl[g_PrizeSel]:SetPushed(1)
end

function Christmas_Wish_OnHiden()
	g_PrizeSel = -1
end
--function Christmas_Wish_HelpClicked()
--	PushEvent("QUEST_HELPINFO","#{QCD_20210524_09}")
--end
function Christmas_Wish_Close()
	this:Hide()
end

