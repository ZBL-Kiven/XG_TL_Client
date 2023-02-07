--***********************************************************************************************************************************************
-- 秦驰道主界面
--***********************************************************************************************************************************************

local g_clientNpcId = -1

local g_QinChiDao_Frame_UnifiedPosition;

local g_QinChiDao_MyTopRank = -1
local g_BarList={}

-- OnLoad
--
--************************************************************************************************************************************************
function QinChiDao_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("QINCHIDAO_TOPLIST",false)
end

function QinChiDao_OnLoad()
	g_QinChiDao_Frame_UnifiedPosition=QinChiDao_Frame:GetProperty("UnifiedPosition");
end


--***********************************************************************************************************************************************
--
-- 事件响应函数
--
--
--************************************************************************************************************************************************
function QinChiDao_OnEvent(event)

	if ( event == "UI_COMMAND" and tonumber(arg0) == 80702001 ) then
		local clientNpcId = Get_XParam_INT(0)
--		PushDebugMessage("g_clientNpcId="..g_clientNpcId)
		if clientNpcId==-1 then
			this:Hide()
			return
		end
		
		if clientNpcId==-2 then
			local MDRecordData = Get_XParam_INT(1)
			g_QinChiDao_MyTopRank = Get_XParam_INT(2)
			local nUseTime = Get_XParam_INT(3)
			local nLastStu = Get_XParam_INT(4)
			QinChiDao_Update(MDRecordData, nUseTime, nLastStu)
		else
			g_clientNpcId = clientNpcId
			local objId = DataPool : GetNPCIDByServerID(g_clientNpcId)
			if objId == -1 then
				return
			end
			local MDRecordData = Get_XParam_INT(1)
			g_QinChiDao_MyTopRank = Get_XParam_INT(2)
			local nUseTime = Get_XParam_INT(3)
			local nLastStu = Get_XParam_INT(4)
			QinChiDao_Update(MDRecordData, nUseTime, nLastStu)
			this : CareObject( objId, 1, "QinChiDao" )
			this : Show()
		end
	elseif (event == "ADJEST_UI_POS" ) then
		QinChiDao_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		QinChiDao_Frame_On_ResetPos()
	elseif (event == "QINCHIDAO_TOPLIST") then
		QinChiDao_InitListBar()
	end
end

function QinChiDao_StartClicked()
--PushDebugMessage("QinChiDao_StartClicked")
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("OnStartClk")
		Set_XSCRIPT_ScriptID(807020);
		Set_XSCRIPT_Parameter(0,g_clientNpcId);
		Set_XSCRIPT_ParamCount(1);
	Send_XSCRIPT();
end

function QinChiDao_AwardClicked()
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("OnAwardClk")
		Set_XSCRIPT_ScriptID(807020);
		Set_XSCRIPT_Parameter(0,g_clientNpcId);
		Set_XSCRIPT_ParamCount(1);
	Send_XSCRIPT();
end

function QinChiDao_TopListAwardClicked()
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("OnTopListAwardClk")
		Set_XSCRIPT_ScriptID(807020);
		Set_XSCRIPT_Parameter(0,g_clientNpcId);
		Set_XSCRIPT_ParamCount(1);
	Send_XSCRIPT();
end

function QinChiDao_OnClosed()
	this:Hide()
end
function QinChiDao_TodayScnClicked()
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("OnTodayScnClk")
		Set_XSCRIPT_ScriptID(807020);
		Set_XSCRIPT_Parameter(0,g_clientNpcId);
		Set_XSCRIPT_ParamCount(1);
	Send_XSCRIPT();

end

function QinChiDao_Frame_On_ResetPos()
  QinChiDao_Frame:SetProperty("UnifiedPosition", g_QinChiDao_Frame_UnifiedPosition);
end

function QinChiDao_Update(MDRecordData, nUseTime, nLastStu)
	local nCurTime = tonumber(DataPool:GetServerDayTime());
	local nMDDay = math.floor(MDRecordData/10)
	local nAwardFlag = math.mod(MDRecordData,10)
--	PushDebugMessage(MDRecordData.." "..nMDDay.." "..nAwardFlag.." "..nCurTime)
	local showAction = DataPool:CreateBindActionItemForShow(38002266, 1)
	if showAction:GetID() ~= 0 then
		QinChiDao_OKBtn:SetActionItem(showAction:GetID())
	end
	if nCurTime==nMDDay then
		QinChiDao_ChallBtn:Show()
		QinChiDao_ActionBtn:Hide()
		if nAwardFlag>=1 then
			QinChiDao_OKBtnOK:Show()--对勾
			QinChiDao_OKBtnAnimate:Hide()
		else
			QinChiDao_OKBtnOK:Hide()
			QinChiDao_OKBtnAnimate:Show()
		end
		nUseTime = math.floor(nUseTime/1000)
		local nMinute=math.floor(nUseTime/60)
		local nSecond=math.mod(nUseTime,60)
		local strMsg = string.format("%02d:%02d", nMinute, nSecond )
		if g_QinChiDao_MyTopRank~=-1 then
			QinChiDao_Explain3NowNum:SetText( ScriptGlobal_Format("#{QCD_20210524_57}",g_QinChiDao_MyTopRank+1) )
		else
			QinChiDao_Explain3NowNum:SetText( ScriptGlobal_Format("#{QCD_20210524_57}","#{QCD_20210524_75}") )
		end
		local strMsg = string.format("%02d:%02d", nMinute, nSecond )
		QinChiDao_Explain3NowTime:SetText( ScriptGlobal_Format("#{QCD_20210524_58}",strMsg) )
	else
		QinChiDao_ChallBtn:Hide()
		QinChiDao_ActionBtn:Show()
		QinChiDao_OKBtnOK:Hide()
		QinChiDao_OKBtnAnimate:Hide()

		QinChiDao_Explain3NowNum:SetText( ScriptGlobal_Format("#{QCD_20210524_57}","#{QCD_20210524_75}") )
		QinChiDao_Explain3NowTime:SetText( ScriptGlobal_Format("#{QCD_20210524_58}","#{QCD_20210524_76}") )
	end
	--前一天的奖励
	local showAction = DataPool:CreateBindActionItemForShow(20310168, 5)
	if showAction:GetID() ~= 0 then
		QinChiDao_Explain3NumAward:SetActionItem(showAction:GetID())
	end
	if nLastStu==-1 then
		--已经领奖了
		QinChiDao_Explain3NumAwardAnimate:Hide()
		QinChiDao_Explain3NumAwardOK:Show()
	elseif nLastStu==-2 then
		--不在排行榜
		QinChiDao_Explain3NumAwardAnimate:Hide()
		QinChiDao_Explain3NumAwardOK:Hide()
	else
		QinChiDao_Explain3NumAwardAnimate:Show()
		QinChiDao_Explain3NumAwardOK:Hide()
	end
end

function QinChiDao_InitListBar()
--PushDebugMessage("QinChiDao_InitListBar")
	QinChiDao_Explain3List:Clear()
	local MaxBarNum = DataPool:GetQinChiDaoTopListCount()
	for i = 1, MaxBarNum do
		local strName,nTime = DataPool:GetQinChiDaoTopListInfo(i-1)
		if strName==-1 then
			return
		end
--PushDebugMessage("i="..i.." strName="..strName.." nTime="..nTime)
		local bar = QinChiDao_Explain3List:AddChild("QinChiDao_Explain3ListItem")
		bar:SetProperty("SuperBarButtonHover","SuperBarHoverSection")
		g_BarList[i] = bar
		if i==g_QinChiDao_MyTopRank+1 then
			bar:GetSubItem("QinChiDao_Explain3ListItemNumImage"):Show()
		else
			bar:GetSubItem("QinChiDao_Explain3ListItemNumImage"):Hide()
		end
		bar:GetSubItem("QinChiDao_Explain3ListItemNum"):SetText(i)
		bar:GetSubItem("QinChiDao_Explain3ListItemName"):SetText(strName)
		nTime=math.floor(nTime/1000)
		local nMinute = math.floor(nTime/60)
		local nSecond = math.mod(nTime,60)
		local strMsg = string.format("%02d:%02d", nMinute, nSecond )
		bar:GetSubItem("QinChiDao_Explain3ListItemTime"):SetText(strMsg)
--		bar:GetSubItem("QinChiDao_Explain3ListItem"):SetEvent("MouseLButtonDown", string.format("QinChiDao_ItemClicked(%d)", i))
	end
end

--function QinChiDao_ItemClicked(nIndex)
--PushDebugMessage("aaa")
--	local MaxBarNum = DataPool:GetQinChiDaoTopListCount()
--	for i = 1, MaxBarNum do		
--		if g_BarList[i] ~= nil then	
--			local ctrlAction = g_BarList[i]:GetSubItem("QinChiDao_Explain3ListItem")
--			if ctrlAction ~= nil then
--				if i == nIndex then
--					ctrlAction:SetCheck(1)
--				else
--					ctrlAction:SetCheck(0)	
--				end
--			end			
--		end
--	end
--end

function QinChiDao_OnHidden()
	QinChiDao_OKBtn:SetActionItem(-1)
	QinChiDao_Explain3NumAward:SetActionItem(-1)
end
function QinChiDao_HelpClicked()
	PushEvent("QUEST_HELPINFO","#{QCD_20210524_09}")
end
