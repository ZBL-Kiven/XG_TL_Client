--***********************************************************************************************************************************************

--***********************************************************************************************************************************************

local g_clientNpcId = -1

local g_XiaRi_SongBing_Frame_UnifiedPosition;

local g_Page = 1

local g_ShaoGeItem = 38002269

local g_GanZePai_ItemId = 38002273
local g_GanZePai_Count = {1,2,3}

local g_LiBaoList = {38002274, 38002275, 38002276}

local g_LiBaoCtrl = {}
-- OnLoad
--
--************************************************************************************************************************************************
function XiaRi_SongBing_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
end

function XiaRi_SongBing_OnLoad()
	g_XiaRi_SongBing_Frame_UnifiedPosition=XiaRi_SongBing_Frame:GetProperty("UnifiedPosition");
	g_LiBaoCtrl = {
		XiaRi_SongBing_FinishIcon1, XiaRi_SongBing_FinishIcon2, XiaRi_SongBing_FinishIcon3
	}
end


--***********************************************************************************************************************************************
--
-- 事件响应函数
--
--
--************************************************************************************************************************************************
function XiaRi_SongBing_OnEvent(event)

	if ( event == "UI_COMMAND" and tonumber(arg0) == 80702701 ) then
		local clientNpcId = Get_XParam_INT(0)
--		PushDebugMessage("g_clientNpcId="..g_clientNpcId)
		if clientNpcId==-1 then
			this:Hide()
			return
		end

		g_clientNpcId = clientNpcId
		local objId = DataPool : GetNPCIDByServerID(g_clientNpcId)
		if objId == -1 then
			return
		end
		g_Page = Get_XParam_INT(1)
		
		XiaRi_SongBing_Update()
		this : CareObject( objId, 1, "XiaRi_SongBing" )
		this : Show()

	elseif (event == "ADJEST_UI_POS" ) then
		XiaRi_SongBing_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		XiaRi_SongBing_Frame_On_ResetPos()
	end
end

function XiaRi_SongBing_Update()
	if g_Page==1 then
		XiaRi_SongBing_TakeOn:Show()
		XiaRi_SongBing_Finish:Hide()
		--哨鸽
		local showAction = DataPool:CreateBindActionItemForShow(g_ShaoGeItem, 1)
		if showAction:GetID() ~= 0 then
			XiaRi_SongBing_TakeOnIcon:SetActionItem(showAction:GetID())
		end
		XiaRi_SongBing_Image:Show()
		XiaRi_SongBing_Image2:Hide()
	elseif g_Page==2 then
		XiaRi_SongBing_TakeOn:Hide()
		XiaRi_SongBing_Finish:Show()
		for i=1,3 do
			local showAction = DataPool:CreateBindActionItemForShow(g_LiBaoList[i], 1)
			if showAction:GetID() ~= 0 then
				g_LiBaoCtrl[i]:SetActionItem(showAction:GetID())
			end
		end
		local nPaiCount = PlayerPackage:Lua_GetUnLockItemCount(g_GanZePai_ItemId)
		local strTemp = ScriptGlobal_Format("#{SBP_210623_40}", nPaiCount, g_GanZePai_Count[3])	
		XiaRi_SongBing_FinishText:SetText(strTemp)
		XiaRi_SongBing_Image:Hide()
		XiaRi_SongBing_Image2:Show()
	end
end

function XiaRi_SongBing_OnClosed()
	this:Hide()
end

function XiaRi_SongBing_Frame_On_ResetPos()
  XiaRi_SongBing_Frame:SetProperty("UnifiedPosition", g_XiaRi_SongBing_Frame_UnifiedPosition);
end

function XiaRi_SongBing_AcceptClk()
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("OnAcceptClk")
		Set_XSCRIPT_ScriptID(807027);
		Set_XSCRIPT_Parameter(0,g_clientNpcId);
		Set_XSCRIPT_ParamCount(1);
	Send_XSCRIPT();
end

function XiaRi_SongBing_FinishClk()
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("OnFinishClk")
		Set_XSCRIPT_ScriptID(807027);
		Set_XSCRIPT_Parameter(0,g_clientNpcId);
		Set_XSCRIPT_Parameter(1,1);
		Set_XSCRIPT_ParamCount(2);
	Send_XSCRIPT();
end