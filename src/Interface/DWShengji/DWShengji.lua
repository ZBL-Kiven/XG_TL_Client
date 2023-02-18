--****************************
--����ֱ������
--������һ��Ҳ�������ڶ���
--****************************
local MAX_OBJ_DISTANCE = 3.0
local g_CaredNpc = -1

local g_DWShengji_Item = -1--���е��Ƶ�װ�����ڱ����е�λ��

local g_DWShengji_Frame_UnifiedPosition;
local g_DWShengji_BindConfirmed = 0
local g_DWShengji_EquipData = ""
local g_DWShengji_toolNumInBag = 0


-- ���˿, ǿ���õĵ���, ���� �� -> Ԫ������ -> ��㽻�� ˳��ʹ��
local g_DWQIANGHUA_ToolItem = {20310168, 20310166, 20310167}
local g_DWQIANGHUA_UnbindItem = {20310166, 20310167}
--=========================================================
-- ע�ᴰ�ڹ��ĵ������¼�
--=========================================================
function DWShengji_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("UPDATE_EQUIPDWLEVELUP")
	this:RegisterEvent("OBJECT_CARED_EVENT")
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")
	this:RegisterEvent("RESUME_ENCHASE_GEM")
	
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	--Ԫ��
	this:RegisterEvent("UPDATE_YUANBAO");
	this:RegisterEvent("UPDATE_BIND_YUANBAO");
	--��ȷ��
	this:RegisterEvent("BINDSURE_EQUIPDWLEVELUP");
	this:RegisterEvent("DW_QHSJ_UI_CHANGE");
end

--=========================================================
-- �����ʼ��
--=========================================================
function DWShengji_OnLoad()
	g_DWShengji_Item = -1
	g_DWShengji_BindConfirmed = 0

	g_DWShengji_Frame_UnifiedPosition=DWShengji_Frame:GetProperty("UnifiedPosition");
	--��������д��̫�����ˣ���ʱ�ϳ�
	DWShengji_cost:Hide()
	DWShengji_cost_Text:Hide()
end

--=========================================================
-- �¼�����
--=========================================================
function DWShengji_OnEvent(event)
	if (event == "UI_COMMAND" and tonumber(arg0) == 20141204) then
		local xx = Get_XParam_INT(0)
		g_DWShengji_toolNumInBag = Get_XParam_INT(1)
		g_CaredNpc = DataPool:GetNPCIDByServerID(xx)
		if g_CaredNpc == -1 then
			PushDebugMessage("server�����������������⡣")
			return
		end
		BeginCareObject_DWShengji()
		DWShengji_Clear()
		DWShengji_UpdateBasic()
		this:Show()
	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if (tonumber(arg0) ~= g_CaredNpc) then
			return
		end
		if ((arg1 == "distance" and tonumber(arg2) > MAX_OBJ_DISTANCE) or arg1=="destroy") then
			DWShengji_Close()
		end
	elseif (event == "PACKAGE_ITEM_CHANGED" and this:IsVisible()) then
		if (arg0~= nil and -1 == tonumber(arg0)) then
			return
		end
		if (g_DWShengji_Item == tonumber(arg0)) then
			--DWShengji_Resume_DWInfo()
			DWShengji_Update(tonumber(arg0),0)
		end
		DWShengji_UpdateBasic()
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 201401111 and this:IsVisible()) then
		--PushDebugMessage("UPDATE_EQUIPDWLEVELUP")
		if arg1 ~= nil then
			DWShengji_Update(arg1,1)
			DWShengji_UpdateBasic()
		end
	elseif (event == "RESUME_ENCHASE_GEM" and this:IsVisible()) then
		if (arg0 ~= nil) then
			DWShengji_Resume_DWInfo()
			DWShengji_UpdateBasic()
		end
	--Ųק
	elseif (event == "ADJEST_UI_POS" ) then
		DWShengji_Frame_On_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		DWShengji_Frame_On_ResetPos()
	--Ԫ��
	elseif (event == "UPDATE_YUANBAO" and this:IsVisible()) then
		DWShengji_UpdateBasic()
	elseif (event == "UPDATE_BIND_YUANBAO" and this:IsVisible()) then
		DWShengji_UpdateBasic()
	elseif (event == "BINDSURE_EQUIPDWLEVELUP" and this:IsVisible() and tonumber(arg0)==1) then
		g_DWShengji_BindConfirmed=1
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 2019050401 ) then
		if tonumber(arg1) ~= 2 then
			return
		end
		g_CaredNpc = tonumber(arg2)
		BeginCareObject_DWShengji()
		DWShengji_Clear()
		DWShengji_UpdateBasic()
		--��������λ��
		if tostring(arg3) ~= nil then
			DWShengji_Frame:SetProperty("UnifiedPosition", tostring(arg3));
		end
		g_DWShengji_toolNumInBag = tonumber(arg4)
		this:Show()
	end
end

--=========================================================
-- ���»�����ʾ��Ϣ
--=========================================================
function DWShengji_UpdateBasic()
	--ӵ�а�Ԫ��
	DWShengji_Bangdingyuangbao_Text:SetText(tostring(Player:GetData("ZENGDIAN")));
	--ӵ��Ԫ��
	DWShengji_Yuanbao_Text:SetText(tostring(Player:GetData("YUANBAO")));
	--������δ�����Ľ��˿
	local toolNumInBag = g_DWShengji_toolNumInBag		-- ������ǿ�����ϵĸ���
	DWShengji_JCSown_Text:SetText(tostring(toolNumInBag))
end

--=========================================================
-- ���ý���
--=========================================================
function DWShengji_Clear()
	if g_DWShengji_Item ~= -1 then
		DWShengji_Object:SetActionItem(-1)
		LifeAbility:Lock_Packet_Item(g_DWShengji_Item, 0)
		g_DWShengji_Item = -1
	end
	DWShengji_Type1_name:SetText("#{DWSJ_141202_51}")
	DWShengji_Type2_name:SetText("#{DWSJ_141202_51}")
	DWShengji_Type1_Level:ResetList()
	DWShengji_Type1_Level:AddTextItem("#{DWSJ_141202_5}" ,0)--��δѡ��
	DWShengji_Type1_Level:SetCurrentSelect(0);
	--DWShengji_Type1_Level:Disable()
	DWShengji_Type2_Level:ResetList()
	DWShengji_Type2_Level:AddTextItem("#{DWSJ_141202_5}" ,0)--��δѡ��
	DWShengji_Type2_Level:SetCurrentSelect(0);
	--DWShengji_Type2_Level:Disable()
	DWShengji_Type1_Info:SetText("")
	DWShengji_Type2_Info:SetText("")
	DWShengji_Type2:Hide()
	--��Ҫ�Ľ��˿����
	DWShengji_JCSneed_Text:SetText("")
	DWShengji_OK:Disable()
	g_DWShengji_BindConfirmed = 0
	--��ť��ʾ
	DWShengji_Type1_Leveltip:Show()
end

--=========================================================
-- ���½���
--=========================================================
function DWShengji_Update(itemIndex,bNotice)
	g_DWShengji_BindConfirmed = 0
	local index = tonumber(itemIndex)--����λ��
	local theAction = EnumAction(index, "packageitem")

	if theAction:GetID() ~= 0 then
		--�Ƿ�Ϊʴ���˵��Ƶ�װ��
		g_DWShengji_EquipData = SuperTooltips:GetAuthorInfo()
		local Icon,IconEx,nLevel_1,nLevel_2,DWName_1,DWName_2 = "","","","","",""
		if LifeAbility : Get_Equip_Point(index) == 17 then
			_,Icon,IconEx,nLevel_1,nLevel_2,DWName_1,DWName_2,g_DWShengji_EquipData = Lua_GetDWShowMsgEx()
		else
			_,Icon,IconEx,nLevel_1,nLevel_2,DWName_1,DWName_2 = Lua_GetDWShowMsg(g_DWShengji_EquipData)
		end
		if Icon == "" then
			-- ����һ���Ѿ�ʴ���˵��Ƶ�װ��
			PushDebugMessage("#{DWSJ_141202_18}")
			return
		end
		if nLevel_1 == 10 and nLevel_2 == 10 then
			--����
			if bNotice==1 then
				PushDebugMessage("#{DWSJ_141202_19}")
			else
				DWShengji_Type1_Level:ResetList()
				DWShengji_Type1_Level:AddTextItem("#{DWSJ_141202_6}" ,0)--����������
				DWShengji_Type1_Level:SetCurrentSelect(0);
				--DWShengji_Type1_Level:Disable()
				DWShengji_Type2_Level:ResetList()
				DWShengji_Type2_Level:AddTextItem("#{DWSJ_141202_6}" ,0)--����������
				DWShengji_Type2_Level:SetCurrentSelect(0);
				--DWShengji_Type2_Level:Disable()
				DWShengji_Type1_Info:SetText("")
				DWShengji_Type2_Info:SetText("")
			end
			return
		end
		-- if nLevel_1 == 10 then
			-- --����
			-- if bNotice==1 then
				-- PushDebugMessage("#{DWSJ_141202_19}")
			-- else
				-- DWShengji_Type1_Level:ResetList()
				-- DWShengji_Type1_Level:AddTextItem("#{DWSJ_141202_6}" ,0)--����������
				-- DWShengji_Type1_Level:SetCurrentSelect(0);
				-- --DWShengji_Type1_Level:Disable()
				-- DWShengji_Type1_Info:SetText("")
			-- end
			-- return
		-- end
		--��������

		-- ����ո����Ѿ���ͼ����, �滻֮
		if g_DWShengji_Item ~= -1 then
			LifeAbility:Lock_Packet_Item(g_DWShengji_Item, 0)
		end

		DWShengji_Object:SetActionItem(theAction:GetID())
		LifeAbility:Lock_Packet_Item(index, 1)
		g_DWShengji_Item = index
		--���ذ�ť
		DWShengji_Type1_Leveltip:Hide()

		--�������߰���Ķ���
		local msg1,msg2= DWName_1,DWName_2--LifeAbility:GetEquipDiaowen_Name(index)
		--��������
		if msg2 == "" then
			DWShengji_Type2:Hide()
		else
			DWShengji_Type2:Show()
		end
		--����and so on
		if msg1 ~= "" and msg2 ~= ""then
			--˫���Ե���
			local strname1 = string.format("#G˫����%s",msg1)
			DWShengji_Type1_name:SetText(strname1)--"#{SSXDW_140819_73}��"..
			local strname2 = string.format("#G˫����%s",msg2)
			DWShengji_Type2_name:SetText(strname2)--"#{SSXDW_140819_73}��"..
			--level
			local dwlevel = nLevel_1--LifeAbility:GetEquitDiaowenID(index)
			local dwlevelEx = nLevel_2--LifeAbility:GetEquitDiaowenIDEx(index)
			if dwlevel<=0 then return end;
			if dwlevelEx<=0 then return end;
			--��һ������10��
			if dwlevel==10 then
				DWShengji_Type1_Level:ResetList()
				DWShengji_Type1_Level:AddTextItem("#{DWSJ_141202_6}" ,0)--����������
				DWShengji_Type1_Level:SetCurrentSelect(0);
				--DWShengji_Type1_Level:Disable()
			else
				DWShengji_Type1_Level:ResetList()
				DWShengji_Type1_Level:AddTextItem("#{DWSJ_141202_5}" ,0)--��δѡ��
				for i=dwlevel+1,10 do
					DWShengji_Type1_Level:AddTextItem(tostring(i) ,i)
				end
				DWShengji_Type1_Level:SetCurrentSelect(0);
				--DWShengji_Type1_Level:Enable()
			end
			--�ڶ�������10��
			if dwlevelEx==10 then
				DWShengji_Type2_Level:ResetList()
				DWShengji_Type2_Level:AddTextItem("#{DWSJ_141202_6}" ,0)--����������
				DWShengji_Type2_Level:SetCurrentSelect(0);
				--DWShengji_Type2_Level:Disable()
			else
				DWShengji_Type2_Level:ResetList()
				DWShengji_Type2_Level:AddTextItem("#{DWSJ_141202_5}" ,0)--��δѡ��
				for i=dwlevelEx+1,10 do
					DWShengji_Type2_Level:AddTextItem(tostring(i) ,i)
				end
				DWShengji_Type2_Level:SetCurrentSelect(0);
				--DWShengji_Type2_Level:Enable()
			end
			DWShengji_Type1_Info:SetText("")
			DWShengji_Type2_Info:SetText("")
		elseif msg1~="" then
			--�����Ե���
			local strname1 = string.format("#G%s����",msg1)
			DWShengji_Type1_name:SetText(strname1)--"#cfff263"..
			--level
			local dwlevel = nLevel_1--LifeAbility:GetEquitDiaowenID(index)
			if dwlevel<=0 then return end;
			--10��
			if dwlevel==10 then
				DWShengji_Type1_Level:ResetList()
				DWShengji_Type1_Level:AddTextItem("#{DWSJ_141202_6}" ,0)--����������
				DWShengji_Type1_Level:SetCurrentSelect(0);
				--DWShengji_Type1_Level:Disable()
			else
				DWShengji_Type1_Level:ResetList()
				DWShengji_Type1_Level:AddTextItem("#{DWSJ_141202_5}" ,0)--��δѡ��
				for i=dwlevel+1,10 do
					DWShengji_Type1_Level:AddTextItem(tostring(i) ,i)
				end
				DWShengji_Type1_Level:SetCurrentSelect(0);
				--DWShengji_Type1_Level:Enable()

				DWShengji_Type1_Info:SetText("")
			end
		end

		--�����Ҫ���˿��Ϣ
		DWShengji_JCSneed_Text:SetText("")
		
		DWShengji_OK:Enable()

	else
		DWShengji_Clear()
	end
end

--=========================================================
-- ȡ�������ڷ������Ʒ
--=========================================================
function DWShengji_Resume_DWInfo()
	if this:IsVisible() then
		DWShengji_Clear()
	end
end

--=========================================================
-- ȷ��ִ�й���
--=========================================================
function DWShengji_OK_Clicked()
	-- ��ȫʱ��
	if (tonumber(DataPool:GetLeftProtectTime()) > 0) then
		PushDebugMessage("#{DWSJ_141202_20}")
		return
	end

	if g_DWShengji_Item==-1 then
		PushDebugMessage("#{DWSJ_141202_21}") --�����һ������Ƕ�˵��Ƶ�װ����
		return
	end
	--�Ƿ��е���
	-- �ж���Ʒ�Ƿ�Ϊʴ����һ�����Ƶ�װ��
	local Icon,IconEx,nLevel_1,nLevel_2,DWName_1,DWName_2 = "","","","","",""
	if LifeAbility : Get_Equip_Point(g_DWShengji_Item) == 17 then
		_,Icon,IconEx,nLevel_1,nLevel_2,DWName_1,DWName_2 = Lua_GetDWShowMsgEx()
	else
		_,Icon,IconEx,nLevel_1,nLevel_2,DWName_1,DWName_2 = Lua_GetDWShowMsg(g_DWShengji_EquipData)
	end
	--ԭ���Ͽ���������һ����Ҳ���������ڶ�����Ҳ����ͬʱ������һ�ڶ��������ǵ������ڶ�����ʱ��Ҫ����һ�������е���
	if Icon == "" then
		PushDebugMessage("#{DWSJ_141202_21}")
		return
	end

	--�����Ƿ�����
	if nLevel_1 == 10 and nLevel_2 == 10 then
		--����
		PushDebugMessage("#{DWSJ_141202_22}")
		return
	end
	if IconEx ~= "" and ret == -3 then
		PushDebugMessage("#{DWSJ_141202_22}")
		return
	end
	--���Ƶĵ�ǰ�ȼ�
	local dwlevel = nLevel_1--LifeAbility:GetEquitDiaowenID(g_DWShengji_Item)
	local dwlevelEx = nLevel_2--LifeAbility:GetEquitDiaowenIDEx(g_DWShengji_Item)
	--ѡ��ȼ�
	local sToLevelSel,iToLevelSel =  DWShengji_Type1_Level:GetCurrentSelect()
	local sToLevelSelEx,iToLevelSelEx =  DWShengji_Type2_Level:GetCurrentSelect()
	if iToLevelSelEx>0 and IconEx == "" then--2��δ����Ƶ�ѡ������2�ŵ���
		return
	end
	if iToLevelSel<=0 and iToLevelSelEx <=0 then--δѡ�������ĸ�
		PushDebugMessage("#{DWSJ_141202_23}")
		return
	end
	if iToLevelSel>0 and iToLevelSelEx>0 then
		--��������
		if iToLevelSel<=dwlevel or iToLevelSelEx<=dwlevelEx then
			PushDebugMessage("#{DWSJ_141202_24}")
			return
		end
	elseif iToLevelSel>0 then
		--����1�ŵ���
		if iToLevelSel<=dwlevel then
			PushDebugMessage("#{DWSJ_141202_24}")
			return
		end
	elseif iToLevelSelEx>0 then
		--����2�ŵ���
		if iToLevelSelEx<=dwlevelEx then
			PushDebugMessage("#{DWSJ_141202_24}")
			return
		end
	end
	--require for jcs count
	--���������˷�����ֱ��������
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("DoDiaowenAction")
		Set_XSCRIPT_ScriptID(900014)
		Set_XSCRIPT_Parameter(0, 99)
		Set_XSCRIPT_Parameter(1, g_DWShengji_Item)
		Set_XSCRIPT_Parameter(2, iToLevelSel)
		Set_XSCRIPT_Parameter(3, iToLevelSelEx)
		Set_XSCRIPT_ParamCount(4)
	Send_XSCRIPT()
	return
end

function DWShengji_Type1_Changed()
	if g_DWShengji_Item==-1 then
		return
	end
	local sToLevelSel,iToLevelSel = DWShengji_Type1_Level:GetCurrentSelect()
	local nAttr_ec_1,nAttr_ecName_1 = Lua_GetDWLeveUpMsg(g_DWShengji_EquipData,iToLevelSel,0)
	if nAttr_ec_1 > 0 then
		local str = string.format("#G%s+%s",nAttr_ecName_1,nAttr_ec_1)
		DWShengji_Type1_Info:SetText(str)
	else
		DWShengji_Type1_Info:SetText("")
	end
	DWShengji_UpdateRequireMat()
end

function DWShengji_Type2_Changed()
	if g_DWShengji_Item==-1 then
		return
	end
	local sToLevelSel,iToLevelSel =  DWShengji_Type1_Level:GetCurrentSelect()
	local sToLevelSelEx,iToLevelSelEx =  DWShengji_Type2_Level:GetCurrentSelect()
	local _,_,nAttr_ec_2,nAttr_ecName_2 = Lua_GetDWLeveUpMsg(g_DWShengji_EquipData,iToLevelSel,iToLevelSelEx)
	if nAttr_ec_2 > 0 then
		local str = string.format("#G%s+%s",nAttr_ecName_2,nAttr_ec_2)
		DWShengji_Type2_Info:SetText(str)
	else
		DWShengji_Type2_Info:SetText("")
	end
	--����������˿��
	DWShengji_UpdateRequireMat()
end

function DWShengji_UpdateRequireMat()
	local sToLevelSel,iToLevelSel =  DWShengji_Type1_Level:GetCurrentSelect()
	local sToLevelSelEx,iToLevelSelEx =  DWShengji_Type2_Level:GetCurrentSelect()
	local _,_,_,_,requireJCS1,requireJCS2 = Lua_GetDWLeveUpMsg(g_DWShengji_EquipData,iToLevelSel,iToLevelSelEx)
	local cntTotal = requireJCS1+requireJCS2
	if cntTotal>0 then
		DWShengji_JCSneed_Text:SetText(cntTotal)
	end
end
--=========================================================
-- �رս���
--=========================================================
function DWShengji_Close()
	this:Hide()
	return
end

--=========================================================
-- ��������
--=========================================================
function DWShengji_OnHiden()
	StopCareObject_DWShengji()
	DWShengji_Clear()
	return
end

--=========================================================
-- ��ʼ����NPC��
-- �ڿ�ʼ����֮ǰ��Ҫ��ȷ����������ǲ����Ѿ��С����ġ���NPC��
-- ����еĻ�����ȡ���Ѿ��еġ����ġ�
--=========================================================
function BeginCareObject_DWShengji()
	this:CareObject(g_CaredNpc, 1, "DWShengji")
	return
end

--=========================================================
-- ֹͣ��ĳNPC�Ĺ���
--=========================================================
function StopCareObject_DWShengji()
	this:CareObject(g_CaredNpc, 0, "DWShengji")
	g_CaredNpc = -1
	return
end


function DWShengji_Frame_On_ResetPos()
  DWShengji_Frame:SetProperty("UnifiedPosition", g_DWShengji_Frame_UnifiedPosition);
end

function DWShengji_ItemBtnRBClicked()
	DWShengji_Resume_DWInfo()
end

function DWShengji_Type1_Leveltip_Click()
	if g_DWShengji_Item==-1 then
		PushDebugMessage("#{DWSJ_141202_54}")
	end
end

--�򿪵���ǿ������
function DWShengji_ChangeTabIndex()
	--����2:1-ǿ����2-����
	PushEvent("UI_COMMAND",2019050401, 1,g_CaredNpc,DWShengji_Frame:GetProperty("UnifiedPosition"),g_DWShengji_toolNumInBag)
	DWShengji_Close()
end
