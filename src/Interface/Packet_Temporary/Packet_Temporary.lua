--**************************
--��ʱ����
--**************************
--���Ӽ�����
local GRID_BUTTONS_NUM = 60;
local GRID_BUTTONS = {};
local Packet_Temporary_ItemID = {}
local Packet_Temporary_ItemNum = {};
local TimeLimited = 0
local nIsMbuy = 0
local Packet_Temporary_ItemNum_Data = {};
local g_Packet_Temporary_Frame_UnifiedPosition
local Packet_Temporary_Index = 0

function Packet_Temporary_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("UPDATE_TEMBANK",false)
	-- ��Ϸ���ڳߴ緢���˱仯
	this:RegisterEvent("ADJEST_UI_POS",true)
	-- ��Ϸ�ֱ��ʷ����˱仯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",true)
	-- ��ʼ����ͽ�������
	this:RegisterEvent("BEGIN_PACKUP_TEMBANK",false)
	this:RegisterEvent("END_PACKUP_TEMBANK",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false);
end

function Packet_Temporary_OnLoad()
	GRID_BUTTONS={
		Packet_Temporary_Space_Line1_Row1_button,
		Packet_Temporary_Space_Line1_Row2_button,
		Packet_Temporary_Space_Line1_Row3_button,
		Packet_Temporary_Space_Line1_Row4_button,
		Packet_Temporary_Space_Line1_Row5_button,
		Packet_Temporary_Space_Line1_Row6_button,
		Packet_Temporary_Space_Line1_Row7_button,
		Packet_Temporary_Space_Line1_Row8_button,
		Packet_Temporary_Space_Line1_Row9_button,
		Packet_Temporary_Space_Line1_Row10_button,
		Packet_Temporary_Space_Line2_Row1_button,
		Packet_Temporary_Space_Line2_Row2_button,
		Packet_Temporary_Space_Line2_Row3_button,
		Packet_Temporary_Space_Line2_Row4_button,
		Packet_Temporary_Space_Line2_Row5_button,
		Packet_Temporary_Space_Line2_Row6_button,
		Packet_Temporary_Space_Line2_Row7_button,
		Packet_Temporary_Space_Line2_Row8_button,
		Packet_Temporary_Space_Line2_Row9_button,
		Packet_Temporary_Space_Line2_Row10_button,
		Packet_Temporary_Space_Line3_Row1_button,
		Packet_Temporary_Space_Line3_Row2_button,
		Packet_Temporary_Space_Line3_Row3_button,
		Packet_Temporary_Space_Line3_Row4_button,
		Packet_Temporary_Space_Line3_Row5_button,
		Packet_Temporary_Space_Line3_Row6_button,
		Packet_Temporary_Space_Line3_Row7_button,
		Packet_Temporary_Space_Line3_Row8_button,
		Packet_Temporary_Space_Line3_Row9_button,
		Packet_Temporary_Space_Line3_Row10_button,
		Packet_Temporary_Space_Line4_Row1_button,
		Packet_Temporary_Space_Line4_Row2_button,
		Packet_Temporary_Space_Line4_Row3_button,
		Packet_Temporary_Space_Line4_Row4_button,
		Packet_Temporary_Space_Line4_Row5_button,
		Packet_Temporary_Space_Line4_Row6_button,
		Packet_Temporary_Space_Line4_Row7_button,
		Packet_Temporary_Space_Line4_Row8_button,
		Packet_Temporary_Space_Line4_Row9_button,
		Packet_Temporary_Space_Line4_Row10_button,
		Packet_Temporary_Space_Line5_Row1_button,
		Packet_Temporary_Space_Line5_Row2_button,
		Packet_Temporary_Space_Line5_Row3_button,
		Packet_Temporary_Space_Line5_Row4_button,
		Packet_Temporary_Space_Line5_Row5_button,
		Packet_Temporary_Space_Line5_Row6_button,
		Packet_Temporary_Space_Line5_Row7_button,
		Packet_Temporary_Space_Line5_Row8_button,
		Packet_Temporary_Space_Line5_Row9_button,
		Packet_Temporary_Space_Line5_Row10_button,
		Packet_Temporary_Space_Line6_Row1_button,
		Packet_Temporary_Space_Line6_Row2_button,
		Packet_Temporary_Space_Line6_Row3_button,
		Packet_Temporary_Space_Line6_Row4_button,
		Packet_Temporary_Space_Line6_Row5_button,
		Packet_Temporary_Space_Line6_Row6_button,
		Packet_Temporary_Space_Line6_Row7_button,
		Packet_Temporary_Space_Line6_Row8_button,
		Packet_Temporary_Space_Line6_Row9_button,
		Packet_Temporary_Space_Line6_Row10_button,
	}
	for ItemNum = 1,60 do
		Packet_Temporary_ItemNum[ItemNum] = _G[string.format("Packet_Temporary_Num%d",ItemNum)]
	end
	Packet_Temporary_DeleteButton:Hide()
	g_Packet_Temporary_Frame_UnifiedPosition=Packet_Temporary_Frame:GetProperty("UnifiedPosition");
end

function Packet_Temporary_SetFramePos()
	local PacketUnionXPos = Variable:GetVariable("PacketUnionXPos");
	local PacketUnionYPos = Variable:GetVariable("PacketUnionYPos");
	if(PacketUnionXPos == nil or PacketUnionYPos ==nil) then
		return
	end
	local xi = string.find(PacketUnionXPos,"{")
	local xj = string.find(PacketUnionXPos,",")
	local xk = string.find(PacketUnionXPos,"}")
	local yi = string.find(PacketUnionYPos,"{")
	local yj = string.find(PacketUnionYPos,",")
	local yk = string.find(PacketUnionYPos,"}")
	if xi==nil or xj==nil or xk==nil or yi==nil or yj==nil or yk==nil then return	end;

	local xscale = string.sub(PacketUnionXPos,xi+1,xj-1)
	local xpos = string.sub(PacketUnionXPos,xj+1,xk-1)
	local yscale = string.sub(PacketUnionYPos,yi+1,yj-1)
	local ypos = string.sub(PacketUnionYPos,yj+1,yk-1)
	if xscale==nil or xpos==nil or yscale==nil or ypos==nil then return end;

--	local curResolution = Variable:GetVariable( "View_Resoution" );
	local xmax, ymax = GetCurClientSize()
	local PacketXPos=xscale*xmax + xpos	--��������
	local PacketYPos=yscale*ymax + ypos	--������

	--Packet ���261 �߶�464 xλ��-261 yλ��-580
	--TemPacket ���450 �߶�353 xλ��-711 yλ��-530
	local dist=450
	if PacketXPos>dist then--��ʱ���������
		Packet_Temporary_Frame:SetProperty("UnifiedXPosition", "{0,"..(PacketXPos-450).."}");
		Packet_Temporary_Frame:SetProperty("UnifiedYPosition", "{0,"..(PacketYPos+50).."}");--50=580-530
	elseif xmax-(PacketXPos+261)>dist then--��ʱ�������Ҳ�
		Packet_Temporary_Frame:SetProperty("UnifiedXPosition", "{0,"..(PacketXPos+261).."}");
		Packet_Temporary_Frame:SetProperty("UnifiedYPosition", "{0,"..(PacketYPos+50).."}");
	else
		--Ĭ��λ��
		Packet_Temporary_Frame_On_ResetPos()
	end
end
function Packet_Temporary_OnEvent(event)
	if event == "UI_COMMAND" and tonumber(arg0) == 201901051 then
		local Data1 = tostring(Get_XParam_STR(0))
		local Data2 = tostring(Get_XParam_STR(1))
		local Data3 = tostring(Get_XParam_STR(2))
		local Data4 = tostring(Get_XParam_STR(3))
		local Data5 = tostring(Get_XParam_STR(4))
		Packet_Temporary_Index = Get_XParam_INT(0)
		local FinalData = Data1..Data2..Data3..Data4..Data5
		if FinalData ~= nil and FinalData ~= "" and BoxData ~= "" then
		    TempData = Split(FinalData, ",")
			for i = 1,50 do
			    Packet_Temporary_ItemID[i] = tonumber(TempData[i])
			end
		else
			PushDebugMessage("ERROR:�����������쳣")
		end
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("OpenPacketTemp2");
			Set_XSCRIPT_ScriptID(900017);
			Set_XSCRIPT_Parameter(0, Packet_Temporary_Index)
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT();
		if(IsWindowShow("Packet_Temporary")) then
			Packet_Temporary_Update()
		else
			Packet_Temporary_SetFramePos()
			Packet_Temporary_Update()
			this:Show()
			PushEvent("UI_COMMAND",2019051902)
		end
	elseif event == "UI_COMMAND" and tonumber(arg0) == 201901052 then
		local Data1 = tostring(Get_XParam_STR(0))
		local DataNum = tostring(Get_XParam_STR(1));--��������
		local FinalData = Data1
		if FinalData ~= nil and FinalData ~= "" and DataNum ~= nil then
		    TempData = Split(FinalData, ",")
			TempData_Num = Split(DataNum, ",")
			for i = 51,60 do
			    Packet_Temporary_ItemID[i] = tonumber(TempData[i - 50])
			end
			for i = 1,60 do
			    Packet_Temporary_ItemNum_Data[i] = tonumber(TempData_Num[i])
			end
		else
			PushDebugMessage("ERROR:�����������쳣")
		end
		Packet_Temporary_Update_II()
	elseif ( event == "UPDATE_TEMBANK") then
		Packet_Temporary_Update()
	elseif event == "UI_COMMAND" and tonumber(arg0) == 1000000006 then
		local theActionID = tonumber(Get_XParam_INT(0))
		local theActionNum = tonumber(Get_XParam_INT(1))
		local theActionPos = tonumber(Get_XParam_INT(2))
		Packet_Temporary_ItemID[theActionPos] = tonumber(theActionID)
		Packet_Temporary_Update_Pos(theActionPos,theActionID,theActionNum)
		return
	elseif event == "UI_COMMAND" and tonumber(arg0) == 1000000007 then
		--ռλ
	end
	if (event == "UI_COMMAND" and tonumber(arg0) == 201107281 and this:IsVisible()) then
		if tonumber(arg1) ~= nil and tonumber(arg1) ~= -1 then
		    Packet_Temporary_PutInItem(tonumber(arg1))
		end
	end
	if (event == "ADJEST_UI_POS" ) then
		Packet_Temporary_Frame_On_ResetPos()
	-- ��Ϸ�ֱ��ʷ����˱仯
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		Packet_Temporary_Frame_On_ResetPos()
	--Disable������
	elseif ( event == "BEGIN_PACKUP_TEMBANK" )   then
		Packet_Temporary_CleanButton:Disable()
	--Enable������
	elseif ( event == "END_PACKUP_TEMBANK" )	    then
		Packet_Temporary_CleanButton:Enable()
	elseif(event == "HIDE_ON_SCENE_TRANSED" ) then
		this:Hide()
	end
end

--================================================
-- �ָ������Ĭ�����λ��
--================================================
function Packet_Temporary_Frame_On_ResetPos()
  Packet_Temporary_Frame:SetProperty("UnifiedPosition", g_Packet_Temporary_Frame_UnifiedPosition);
end

function Packet_Temporary_Update()
	for i=1, GRID_BUTTONS_NUM do
		GRID_BUTTONS[i]:SetActionItem(-1);
		GRID_BUTTONS[i]:Enable();
	end
	local Lock_Flag = 0
	for i=1, table.getn(Packet_Temporary_ItemID)do
		local theAction, bLocked = GemMelting:UpdateProductAction(Packet_Temporary_ItemID[i]),false
		if theAction:GetID() ~= 0 then
			GRID_BUTTONS[i]:SetActionItem(theAction:GetID());
			if(bLocked == true) then
				-- GRID_BUTTONS[i]:Disable();
				Lock_Flag = 1
			else
				GRID_BUTTONS[i]:Enable();
			end
		else
			GRID_BUTTONS[i]:SetActionItem(-1);
		end
	end
	if Lock_Flag == 0 then
		Packet_Temporary_CleanButton:Enable()
	else
		Packet_Temporary_CleanButton:Disable()
	end
end
function Packet_Temporary_Update_II()
	-- for i=51, 60 do
		-- GRID_BUTTONS[i]:SetActionItem(-1);
		-- GRID_BUTTONS[i]:Enable();
	-- end
	local Lock_Flag = 0
	for i= 51, 60 do
		local theAction, bLocked = GemMelting:UpdateProductAction(Packet_Temporary_ItemID[i]),false
		if theAction:GetID() ~= 0 then
			GRID_BUTTONS[i]:SetActionItem(theAction:GetID());
			if(bLocked == true) then
				-- GRID_BUTTONS[i]:Disable();
				Lock_Flag = 1
			else
				GRID_BUTTONS[i]:Enable();
			end
		else
			GRID_BUTTONS[i]:SetActionItem(-1);
		end
	end
	
	--/////////////////////////////////ˢ����������/////////////////////////////////
	for i = 1,60 do
	    Packet_Temporary_ItemNum[i]:SetText("")
	    Packet_Temporary_ItemNum[i]:Hide()
		if Packet_Temporary_ItemNum_Data[i] ~= 0 and Packet_Temporary_ItemNum_Data[i] ~= nil and Packet_Temporary_ItemNum_Data[i] > 1 then
		    Packet_Temporary_ItemNum[i]:SetText("#e010101"..tostring(Packet_Temporary_ItemNum_Data[i]))
		    if Packet_Temporary_ItemNum_Data[i] > 9999 then
				Packet_Temporary_ItemNum[i]:SetText("#e010101��")
			end
			Packet_Temporary_ItemNum[i]:Show()
		end
	end
	--/////////////////////////////////ˢ����������/////////////////////////////////
end

function Packet_Temporary_Update_Pos(nPos,nItemID,nItemNum)
	-- PushDebugMessage("nPos��"..nPos..",nItemID��"..nItemID..",nItemNum��"..nItemNum)
	if nItemID == nil or nItemNum == nil or nItemNum < 0 then
		return
	end
	local theAction = 0--GemMelting:UpdateProductAction(nItemID)
	if nItemID <= 0 then
		GRID_BUTTONS[nPos]:SetActionItem(-1);		
	else
		theAction = GemMelting:UpdateProductAction(nItemID)
	end
	if nItemID > 0 then
		if GRID_BUTTONS[nPos] ~= nil and theAction:GetID() ~= 0 then
			GRID_BUTTONS[nPos]:SetActionItem(theAction:GetID());		
		end
	end
	for i = 1,60 do
	    GRID_BUTTONS[i]:Enable();
	end
	if nItemNum > 1 then
		Packet_Temporary_ItemNum[nPos]:SetText("#e010101"..tostring(nItemNum))
		if nItemNum > 9999 then
			Packet_Temporary_ItemNum[nPos]:SetText("#e010101��")
		end
		Packet_Temporary_ItemNum[nPos]:Show()
	else
		Packet_Temporary_ItemNum[nPos]:Hide()
	end
	if nItemNum < 1 then
		-- GRID_BUTTONS[nPos]:Hide()
		Packet_Temporary_ItemNum[nPos]:Hide()
	end
	PushEvent("UI_COMMAND",20220315,nPos)
end

--����ȡ��
function Packet_Temporary_MoveBulletItemToPacket()
	if nIsMbuy == 1 then
		SetDefaultMouse();
	else
		nIsMbuy = 1
		MouseCmd_ShopFittingSet();
		PushDebugMessage("������Ҫ����ȡ������Ʒ�ϵ���Ҽ���")
	end
	return
end

function Packet_Temporary_TimerProc()
    TimeLimited = 0
	KillTimer("Packet_Temporary_TimerProc()")
end

function Packet_Temporary_PutInItem(pos)
	if TimeLimited == 1 then
	    PushDebugMessage("����̫��Ƶ�������Ժ����ԣ�")
		return
	end
    local itemID = PlayerPackage:GetItemTableIndex(pos)
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("PutInItem");
		Set_XSCRIPT_ScriptID(900017);
		Set_XSCRIPT_Parameter(0,pos)
		Set_XSCRIPT_Parameter(1,Packet_Temporary_Index)
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT();
	TimeLimited = 1
	SetTimer("Packet_Temporary","Packet_Temporary_TimerProc()", 500)
end

function Packet_Temporary_MoveAllItemToPacket()
    if Packet_Temporary_Index == 5 then return end
	if TimeLimited == 1 then
	    PushDebugMessage("����̫��Ƶ�������Ժ����ԣ�")
		return
	end	
    Packet_Temporary_Index = Packet_Temporary_Index + 1
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("OpenPacketTemp");
		Set_XSCRIPT_ScriptID(900017);
		Set_XSCRIPT_Parameter(0, Packet_Temporary_Index)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT();
	TimeLimited = 1
	SetTimer("Packet_Temporary","Packet_Temporary_TimerProc()", 500)
end

function Packet_Temporary_Select(nIndex)
	if nIndex < 0 or nIndex > 60 then
	    return
	end
	if Packet_Temporary_ItemID[nIndex] == nil or Packet_Temporary_ItemID[nIndex] == 0 or Packet_Temporary_ItemID[nIndex] < 10000000 then
		return
	end
	-- if nIsMbuy == 1 then --[ADD 2019-6-28 18:39:35 XYZ ����ȡ��]
		-- Clear_XSCRIPT();
			-- Set_XSCRIPT_Function_Name("TakeOutMToParcket");
			-- Set_XSCRIPT_ScriptID(900017);
			-- Set_XSCRIPT_Parameter(0,nIndex + (Packet_Temporary_Index*50))
			-- Set_XSCRIPT_Parameter(1,11)
			-- Set_XSCRIPT_ParamCount(2)
		-- Send_XSCRIPT();
		-- nIsMbuy = 0
		-- return
	-- end
	--�Ż��İ�
	PushEvent("UI_COMMAND",88819004,nIndex,Packet_Temporary_Index,Packet_Temporary_ItemID[nIndex])
	-- Clear_XSCRIPT();
		-- Set_XSCRIPT_Function_Name("PacketTemporaryTakeout");
		-- Set_XSCRIPT_ScriptID(900017);
		-- Set_XSCRIPT_Parameter(0,nIndex)
		-- Set_XSCRIPT_Parameter(1,Packet_Temporary_Index)
		-- Set_XSCRIPT_ParamCount(2)
	-- Send_XSCRIPT();
end

function Packet_Temporary_OnHiden()
	PushEvent("UI_COMMAND",2019051901)
	nIsMbuy = 0
	--ȡ���������״̬
	SetDefaultMouse()
end
function Packet_Temporary_CloseFunction()
	this:Hide()
end
function Packet_Temporary_CleanButtonClk()
    if Packet_Temporary_Index == 0 then return end
	if TimeLimited == 1 then
	    PushDebugMessage("����̫��Ƶ�������Ժ����ԣ�")
		return
	end	
    Packet_Temporary_Index = Packet_Temporary_Index - 1
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("OpenPacketTemp");
		Set_XSCRIPT_ScriptID(900017);
		Set_XSCRIPT_Parameter(0, Packet_Temporary_Index)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT();
	TimeLimited = 1
	SetTimer("Packet_Temporary","Packet_Temporary_TimerProc()", 500)
end

function Packet_Temporary_CleanAllItem()
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("DelAllItem");
		Set_XSCRIPT_ScriptID(900017);
	Send_XSCRIPT();
end
