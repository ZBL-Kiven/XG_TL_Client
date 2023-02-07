---===================================================
--����ϵͳ
---===================================================
local MAX_OBJ_DISTANCE = 3.0
local g_CaredNpc = -1
local g_DWQIANGHUA_Item = -1
local g_DWQIANGHUA_DemandMoney = 0
local g_DWQIANGHUA_GRID_SKIP = 96
-- ���˿, ǿ���õĵ���, ���� �� -> Ԫ������ -> ��㽻�� ˳��ʹ��
local g_DWQIANGHUA_ToolItem = {20310168, 20310166, 20310167}
local g_DWQIANGHUA_ToolItem_Num = 0
local g_DWQIANGHUA_Tool_Num = tonumber(0)
local g_DWQIANGHUA_NUM_LOW = tonumber(0)
local g_DWQIANGHUA_NUM_UP = tonumber(100000)
local g_DWQIANGHUA_Tool_Num1 = tonumber(0)

local g_DWQIANGHUA_Action_Type = 2
local g_DWQIANGHUA_RScript_ID = 900014
local g_DWQIANGHUA_RScript_Name = "DoDiaowenAction"

local g_DWQianghua_Frame_UnifiedPosition;

--=========================================================
-- ע�ᴰ�ڹ��ĵ������¼�
--=========================================================
function DWQianghua_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("UPDATE_DWQIANGHUA")
	this:RegisterEvent("OBJECT_CARED_EVENT")
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")
	this:RegisterEvent("RESUME_ENCHASE_GEM")
	this:RegisterEvent("UNIT_MONEY")
	this:RegisterEvent("MONEYJZ_CHANGE")

	this:RegisterEvent("CONFIRM_DWQIANGHUA")
	
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("DW_QHSJ_UI_CHANGE")
end

--=========================================================
-- �����ʼ��
--=========================================================
function DWQianghua_OnLoad()
	g_DWQIANGHUA_Item = -1
	g_DWQIANGHUA_DemandMoney = 0
	DWQianghua_DemandMoney:SetProperty("MoneyNumber", tostring(g_DWQIANGHUA_DemandMoney))
	g_DWQIANGHUA_Tool_Num = tonumber(0)
	g_DWQIANGHUA_Tool_Num1 = tonumber(0)
	DWQianghua_NumericalValue:SetProperty("Text", tostring(g_DWQIANGHUA_Tool_Num))
	DWQianghua_NumericalValue1:SetProperty("Text", tostring(g_DWQIANGHUA_Tool_Num1))
	DWQianghua_Info3:SetProperty("Text", "")
	DWQianghua_Info4:SetProperty("Text", "")	
	DWQianghua_Info4:Hide()
	DWQianghua_NumericalValue1:Hide()
	DWQianghua_Addition1:Hide()
	DWQianghua_Decrease1:Hide()
	-- ʼ�տ��Ե�� OK ��ť, Ϊ�˷�����ʾ�����Ϣ
	DWQianghua_OK:Enable()
	
	g_DWQianghua_Frame_UnifiedPosition=DWQianghua_Frame:GetProperty("UnifiedPosition");
end

--=========================================================
-- �¼�����
--=========================================================
function DWQianghua_OnEvent(event)
	if (event == "UI_COMMAND" and tonumber(arg0) == 3000156) then
		local xx = Get_XParam_INT(0)
		g_DWQIANGHUA_ToolItem_Num = Get_XParam_INT(1)
		g_CaredNpc = DataPool:GetNPCIDByServerID(xx)
		if g_CaredNpc == -1 then
			PushDebugMessage("server�����������������⡣")
			return
		end
		BeginCareObject_DWQianghua()
		DWQianghua_Clear()
		DWQianghua_UpdateBasic()
		DWQianghua_UpdateBasic1()
		this:Show()
	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if (tonumber(arg0) ~= g_CaredNpc) then
			return
		end
		if ((arg1 == "distance" and tonumber(arg2) > MAX_OBJ_DISTANCE) or arg1=="destroy") then
			DWQianghua_Close()
		end
	elseif (event == "PACKAGE_ITEM_CHANGED" and this:IsVisible()) then
		if (arg0~= nil and -1 == tonumber(arg0)) then
			return
		end
		-- ���Ըĳ��������ǿ��, �ǾͲ�Ҫ�������Ƴ���Ʒ
		if tonumber(arg0) == g_DWQIANGHUA_Item then
			-- ǿ���󲻽�װ������������, ֧�ֳ���ǿ�� - 2009-12-07
			--DWQianghua_Resume_Equip()
			DWQianghua_UpdateBasic()
			DWQianghua_UpdateBasic1()
		end
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 201401111 and this:IsVisible()) then
		--������������׵��½��洦������, ����¼��ر��
		--DWQianghua_UpdateBasic()
		if arg1 ~= nil then
			DWQianghua_Update(arg1)
			DWQianghua_UpdateBasic()
			DWQianghua_UpdateBasic1()
		end
	elseif (event == "UNIT_MONEY" or event =="MONEYJZ_CHANGE") then
		DWQianghua_UpdateBasic()
		DWQianghua_UpdateBasic1()
	elseif (event == "RESUME_ENCHASE_GEM" and this:IsVisible()) then
		if arg0 ~= nil and tonumber(arg0) == (g_DWQIANGHUA_GRID_SKIP + 1) then
			DWQianghua_Resume_Equip()
			DWQianghua_UpdateBasic()
			DWQianghua_UpdateBasic1()
		end
	elseif (event == "CONFIRM_DWQIANGHUA") then
		DWQianghua_OK_Clicked(1)
		
	elseif (event == "ADJEST_UI_POS" ) then
		DWQianghua_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		DWQianghua_Frame_On_ResetPos()

	elseif (event == "UI_COMMAND" and tonumber(arg0) == 2019050401) then
		if tonumber(arg1) ~= 1 then
			return
		end
		g_CaredNpc = tonumber(arg2)
		BeginCareObject_DWQianghua()
		DWQianghua_Clear()
		DWQianghua_UpdateBasic()
		DWQianghua_UpdateBasic1()
		--��������λ��
		if tostring(arg3) ~= nil then
			DWQianghua_Frame:SetProperty("UnifiedPosition", tostring(arg3));
		end
		g_DWQIANGHUA_ToolItem_Num = tonumber(arg4)
		this:Show()
	end
end

--=========================================================
-- ���»�����ʾ��Ϣ
-- ����������Ǯ����ʾ
--=========================================================
function DWQianghua_UpdateBasic(nToolNum)
	DWQianghua_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"))
	DWQianghua_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"))

	if nToolNum == nil then
		nToolNum = g_DWQIANGHUA_Tool_Num
	end
	DWQianghua_SetToolNumAndText(nToolNum)

	-- ���������Ǯ
	g_DWQIANGHUA_DemandMoney = 0
	DWQianghua_DemandMoney:SetProperty("MoneyNumber", tostring(g_DWQIANGHUA_DemandMoney))
end

--=========================================================
-- ���»�����ʾ��Ϣ
-- ����������Ǯ����ʾ
--=========================================================
function DWQianghua_UpdateBasic1(nToolNum)
	DWQianghua_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"))
	DWQianghua_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"))

	if nToolNum == nil then
		nToolNum = g_DWQIANGHUA_Tool_Num1
	end
	DWQianghua_SetToolNumAndText1(nToolNum)

	-- ���������Ǯ
	g_DWQIANGHUA_DemandMoney = 0
	DWQianghua_DemandMoney:SetProperty("MoneyNumber", tostring(g_DWQIANGHUA_DemandMoney))
end

--=========================================================
-- ���ý���
--=========================================================
function DWQianghua_Clear()
	if g_DWQIANGHUA_Item ~= -1 then
		DWQianghua_Object:SetActionItem(-1)
		LifeAbility:Lock_Packet_Item(g_DWQIANGHUA_Item, 0)
		g_DWQIANGHUA_Item = -1
	end

	g_DWQIANGHUA_DemandMoney = 0
	DWQianghua_UpdateBasic(g_DWQIANGHUA_NUM_LOW)
	DWQianghua_UpdateBasic1(g_DWQIANGHUA_NUM_LOW)
	DWQianghua_NumericalValue:SetProperty("DefaultEditBox", "True")
	DWQianghua_NumericalValue:SetSelected(0, -1)
	DWQianghua_NumericalValue1:SetProperty("DefaultEditBox", "True")
	DWQianghua_NumericalValue1:SetSelected(0, -1)	
	DWQianghua_Info3:SetProperty("Text", "")
	DWQianghua_Info4:SetProperty("Text", "")	
	DWQianghua_Info4:Hide()
	DWQianghua_NumericalValue1:Hide()
	DWQianghua_Addition1:Hide()
	DWQianghua_Decrease1:Hide()
end

--=========================================================
-- ���½���
--=========================================================
function DWQianghua_Update(itemIndex)
	local index = tonumber(itemIndex)
	local theAction = EnumAction(index, "packageitem")

	if theAction:GetID() ~= 0 then
		-- �ж��Ƿ�Ϊ��ȫʱ��
		if (tonumber(DataPool:GetLeftProtectTime()) > 0) then
			PushDebugMessage("#{JJTZ_090826_26}")
			return
		end
		local Icon,IconEx,nLevel_1,nLevel_2,DWName_1,DWName_2 = "","","","","",""
		if LifeAbility : Get_Equip_Point(index) == 17 then
			_,Icon,IconEx,nLevel_1,nLevel_2,DWName_1,DWName_2 = Lua_GetDWShowMsgEx(theAction:GetID())
		else
			_,Icon,IconEx,nLevel_1,nLevel_2,DWName_1,DWName_2 = Lua_GetDWShowMsg(SuperTooltips:GetAuthorInfo())
		end
		if Icon == "" and IconEx == "" then
			-- ����һ���Ѿ�ʴ���˵��Ƶ�װ��
			PushDebugMessage("#{ZBDW_091105_11}")
			return
		elseif nLevel_1 == 10 and nLevel_2 == 10 then
			-- װ���ϵĵ����Ѿ�ǿ������, ������ǿ��
			PushDebugMessage("�����װ���ϵĵ��Ʋ�����ǿ��.")
			return
		end
		-- ����ո����Ѿ��ж�Ӧ��Ʒ��, �滻֮
		if g_DWQIANGHUA_Item ~= -1 then
			LifeAbility:Lock_Packet_Item(g_DWQIANGHUA_Item, 0)
		end

		DWQianghua_Object:SetActionItem(theAction:GetID())
		LifeAbility:Lock_Packet_Item(index, 1)
		g_DWQIANGHUA_Item = index

		--��Ҫ��ҪӰ��
		local msg1,msg2= DWName_1,DWName_2--LifeAbility:GetEquipDiaowen_Name(index)
		if msg2=="" then
			DWQianghua_Info4:Hide()
			DWQianghua_NumericalValue1:Hide()
			DWQianghua_Addition1:Hide()
			DWQianghua_Decrease1:Hide()
		else
			DWQianghua_Info4:Show()
			DWQianghua_NumericalValue1:Show()
			DWQianghua_Addition1:Show()
			DWQianghua_Decrease1:Show()
		end
		if msg1~="" and msg2~=""then
			DWQianghua_Info3:SetText("#{SSXDW_140819_73}��"..msg1)
			DWQianghua_Info4:SetText("#{SSXDW_140819_73}��"..msg2)
		elseif msg1~="" then
			DWQianghua_Info3:SetText("#cfff263"..msg1)
		end
		-- �趨 OK Ϊ���ǿ��Ե��, �����������
		-- �ж���Ʒ�Ƿ�����Ҫ�����趨����button
		-- DWQianghua_Check_AllItem()
	else
		DWQianghua_Clear()
	end
end

--=========================================================
-- ���ӽ��˿������
--=========================================================
function DWQianghua_Addition_Click()
	DWQianghua_UpdateBasic(g_DWQIANGHUA_Tool_Num + 1)
end

--=========================================================
-- ���ٽ��˿������
--=========================================================
function DWQianghua_Decrease_Click()
	DWQianghua_UpdateBasic(g_DWQIANGHUA_Tool_Num - 1)
end

--=========================================================
-- ���ӽ��˿2������
--=========================================================
function DWQianghua_Addition_Click1()
	DWQianghua_UpdateBasic1(g_DWQIANGHUA_Tool_Num1 + 1)
end

--=========================================================
-- ���ٽ��˿2������
--=========================================================
function DWQianghua_Decrease_Click1()
	DWQianghua_UpdateBasic1(g_DWQIANGHUA_Tool_Num1 - 1)
end

--=========================================================
-- ���˿�����ı�
--=========================================================
function DWQianghua_ToolNumChange()
	local num = DWQianghua_NumericalValue:GetProperty("Text")
	-- �����ı���, ��Ҫ�ٸı�����������, ��Ȼ�û���û�������������������
	-- ���������޸ĵ��ı�
	if num == nil or (not num) or num == "" or tonumber(num) < g_DWQIANGHUA_NUM_LOW then
		g_DWQIANGHUA_Tool_Num = g_DWQIANGHUA_NUM_LOW
		DWQianghua_NumericalValue:SetProperty("Text", tostring(g_DWQIANGHUA_Tool_Num))
		return
	end
	-- ����û�ɾ����������������, tonumber �Ľ���ȽϹ���, �޷��Զ�����Ϊĳ��ֵ
	num = tonumber(num)
	if num == g_DWQIANGHUA_Tool_Num then
		return
	end
	-- ��������ı�: ���ȶ���Ч num ���б���, ��Ȼ����Ӱ���������
	if tonumber(num) >= g_DWQIANGHUA_NUM_LOW and tonumber(num) <= g_DWQIANGHUA_NUM_UP then
		g_DWQIANGHUA_Tool_Num = tonumber(num)
	elseif tonumber(num) > g_DWQIANGHUA_NUM_UP then
		g_DWQIANGHUA_Tool_Num = g_DWQIANGHUA_NUM_UP
		DWQianghua_NumericalValue:SetProperty("Text", tostring(g_DWQIANGHUA_Tool_Num))
		--DWQianghua_SetToolNumAndText(g_DWQIANGHUA_NUM_UP)
	else
		g_DWQIANGHUA_Tool_Num = g_DWQIANGHUA_NUM_LOW
		DWQianghua_NumericalValue:SetProperty("Text", tostring(g_DWQIANGHUA_Tool_Num))
		--DWQianghua_SetToolNumAndText(g_DWQIANGHUA_NUM_LOW)
	end
	--�����׵�����ѭ��, ���ڽ�Ǯ��ǿ�������޹�, ����Ҫ������.
	--DWQianghua_UpdateBasic(num)
end

--=========================================================
-- ���˿����2�ı�
--=========================================================
function DWQianghua_ToolNumChange1()
	local num = DWQianghua_NumericalValue1:GetProperty("Text")
	-- �����ı���, ��Ҫ�ٸı�����������, ��Ȼ�û���û�������������������
	-- ���������޸ĵ��ı�
	if num == nil or (not num) or num == "" or tonumber(num) < g_DWQIANGHUA_NUM_LOW then
		g_DWQIANGHUA_Tool_Num1 = g_DWQIANGHUA_NUM_LOW
		DWQianghua_NumericalValue1:SetProperty("Text", tostring(g_DWQIANGHUA_Tool_Num1))
		return
	end
	-- ����û�ɾ����������������, tonumber �Ľ���ȽϹ���, �޷��Զ�����Ϊĳ��ֵ
	num = tonumber(num)
	if num == g_DWQIANGHUA_Tool_Num1 then
		return
	end
	-- ��������ı�: ���ȶ���Ч num ���б���, ��Ȼ����Ӱ���������
	if tonumber(num) >= g_DWQIANGHUA_NUM_LOW and tonumber(num) <= g_DWQIANGHUA_NUM_UP then
		g_DWQIANGHUA_Tool_Num1 = tonumber(num)
	elseif tonumber(num) > g_DWQIANGHUA_NUM_UP then
		g_DWQIANGHUA_Tool_Num1 = g_DWQIANGHUA_NUM_UP
		DWQianghua_NumericalValue1:SetProperty("Text", tostring(g_DWQIANGHUA_Tool_Num1))
	else
		g_DWQIANGHUA_Tool_Num1 = g_DWQIANGHUA_NUM_LOW
		DWQianghua_NumericalValue1:SetProperty("Text", tostring(g_DWQIANGHUA_Tool_Num1))
	end

end

--=========================================================
-- ���˿�����������ʧȥ����?
--=========================================================
function DWQianghua_TextLost()
	DWQianghua_ToolNumChange()
end

function DWQianghua_TextLost1()
	DWQianghua_ToolNumChange1()
end

--=========================================================
-- ���Ľ��˿���������ñ���
-- Ϊ�˱�֤����������ʼ��ͳһ
--=========================================================
function DWQianghua_SetToolNumAndText(count)
	local num = tonumber(count)
	-- ע�����ﲻҪ�� DWQianghua_ToolNumChange() ������ѭ����
	if count == nil or count == "" or num < g_DWQIANGHUA_NUM_LOW then
		-- ����̫С����
		g_DWQIANGHUA_Tool_Num = g_DWQIANGHUA_NUM_LOW
	elseif num > g_DWQIANGHUA_NUM_UP then
		g_DWQIANGHUA_Tool_Num = g_DWQIANGHUA_NUM_UP
	elseif num == g_DWQIANGHUA_Tool_Num then
		return
	else
		g_DWQIANGHUA_Tool_Num = num
	end

	DWQianghua_NumericalValue:SetProperty("Text", tostring(g_DWQIANGHUA_Tool_Num))
end

--=========================================================
-- ���Ľ��˿���������ñ���
-- Ϊ�˱�֤����������ʼ��ͳһ
--=========================================================
function DWQianghua_SetToolNumAndText1(count)
	local num = tonumber(count)
	-- ע�����ﲻҪ�� DWQianghua_ToolNumChange() ������ѭ����
	if count == nil or count == "" or num < g_DWQIANGHUA_NUM_LOW then
		-- ����̫С����
		g_DWQIANGHUA_Tool_Num1 = g_DWQIANGHUA_NUM_LOW
	elseif num > g_DWQIANGHUA_NUM_UP then
		g_DWQIANGHUA_Tool_Num1 = g_DWQIANGHUA_NUM_UP
	elseif num == g_DWQIANGHUA_Tool_Num1 then
		return
	else
		g_DWQIANGHUA_Tool_Num1 = num
	end

	DWQianghua_NumericalValue1:SetProperty("Text", tostring(g_DWQIANGHUA_Tool_Num1))
end

--=========================================================
-- ȡ�������ڷ������Ʒ
--=========================================================
function DWQianghua_Resume_Equip()
	if this:IsVisible() then
		if g_DWQIANGHUA_Item ~= -1 then
			LifeAbility:Lock_Packet_Item(g_DWQIANGHUA_Item, 0)
			DWQianghua_Object:SetActionItem(-1)
			g_DWQIANGHUA_Item = -1
		end
	end

	-- ���³�ʼ�����˿������
	DWQianghua_UpdateBasic(g_DWQIANGHUA_NUM_LOW)
	DWQianghua_UpdateBasic1(g_DWQIANGHUA_NUM_LOW)
	DWQianghua_Info3:SetProperty("Text", "")
	DWQianghua_Info4:SetProperty("Text", "")
	DWQianghua_Info4:Hide()
	DWQianghua_NumericalValue1:Hide()
	DWQianghua_Addition1:Hide()
	DWQianghua_Decrease1:Hide()	
end

--=========================================================
-- �ж��Ƿ�������Ʒ���ѷź�
-- ֻ�ڵ�� OK ��ť��ʱ������������
--=========================================================
function DWQianghua_Check_AllItem()
	DWQianghua_UpdateBasic()
	DWQianghua_UpdateBasic1()

	if g_DWQIANGHUA_Item == -1 then
		g_DWQIANGHUA_DemandMoney = 0
		DWQianghua_DemandMoney:SetProperty("MoneyNumber", tostring(g_DWQIANGHUA_DemandMoney))
		return 1
	end

	-- �жϽ��˿����, ����Ľ��˿����
	-- �� Server �ж�

	-- �жϽ�Ǯ�Ƿ��㹻
	local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")
	if selfMoney < g_DWQIANGHUA_DemandMoney then
		return 44
	end

	DWQianghua_OK:Enable()
	return 0
end


local EB_FREE_BIND = 0;				-- �ް�����
local EB_BINDED = 1;				-- �Ѿ���
local EB_GETUP_BIND =2			-- ʰȡ��
local EB_EQUIP_BIND =3			-- װ����
--=========================================================
-- ȷ��ִ�й���
--=========================================================
function DWQianghua_OK_Clicked(okFlag)
	local ret = DWQianghua_Check_AllItem()
	if ret == 1 or ret == 2 then
		PushDebugMessage("#{ZBDW_091105_12}")
		return
	elseif ret == 3 then
		PushDebugMessage("�����װ���ϵĵ��Ʋ�����ǿ��.")
		return
	elseif ret == 44 then
		PushDebugMessage("#{GMGameInterface_Script_PlayerMySelf_Info_Money_Not_Enough}")
		return
	end

	if ret == 0 then
		-- ��Ϊ0 ����
		if g_DWQIANGHUA_Tool_Num+g_DWQIANGHUA_Tool_Num1 <= g_DWQIANGHUA_NUM_LOW then
			PushDebugMessage("#{SSXDW_140819_59}")
			return
		end
		
		
		-- �ж�ǿ�������Ƿ��㹻
		if tonumber(g_DWQIANGHUA_ToolItem_Num) < g_DWQIANGHUA_Tool_Num+g_DWQIANGHUA_Tool_Num1 then
			PushDebugMessage("#{ZBDW_091105_13}")
			return
		end

		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name(g_DWQIANGHUA_RScript_Name)
			Set_XSCRIPT_ScriptID(g_DWQIANGHUA_RScript_ID)
			Set_XSCRIPT_Parameter(0, g_DWQIANGHUA_Action_Type)
			Set_XSCRIPT_Parameter(1, g_DWQIANGHUA_Item)
			-- ����Ҫ�� tonumber, �������Ī�����������....
			Set_XSCRIPT_Parameter(2, tonumber(g_DWQIANGHUA_Tool_Num))
			Set_XSCRIPT_Parameter(3, tonumber(g_DWQIANGHUA_Tool_Num1))
			Set_XSCRIPT_ParamCount(4)
		Send_XSCRIPT()
		-- ����������������, ��Ȼ�ƺ�����ʲô��û�б仯��
		DWQianghua_UpdateBasic(g_DWQIANGHUA_NUM_LOW)
		DWQianghua_UpdateBasic1(g_DWQIANGHUA_NUM_LOW)
	end

end

--=========================================================
-- �رս���
--=========================================================
function DWQianghua_Close()
	this:Hide()
	return
end

--=========================================================
-- ��������
--=========================================================
function DWQianghua_OnHiden()
	StopCareObject_DWQianghua()
	DWQianghua_Clear()
	return
end

--=========================================================
-- ��ʼ����NPC��
-- �ڿ�ʼ����֮ǰ��Ҫ��ȷ����������ǲ����Ѿ��С����ġ���NPC��
-- ����еĻ�����ȡ���Ѿ��еġ����ġ�
--=========================================================
function BeginCareObject_DWQianghua()

	this:CareObject(g_CaredNpc, 1, "DWQianghua")
	return
end

--=========================================================
-- ֹͣ��ĳNPC�Ĺ���
--=========================================================
function StopCareObject_DWQianghua()
	this:CareObject(g_CaredNpc, 0, "DWQianghua")
	g_CaredNpc = -1
	return
end

--=========================================================
-- ��ҽ�Ǯ�仯
--=========================================================
function DWQianghua_UserMoneyChanged()
	local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")
	-- �жϽ�Ǯ������
	if selfMoney < g_DWQIANGHUA_DemandMoney then
		--DWQianghua_OK:Disable()
		return -1
	end
	return 1
end

function DWQianghua_Frame_On_ResetPos()
	DWQianghua_Frame:SetProperty("UnifiedPosition", g_DWQianghua_Frame_UnifiedPosition);
end

function DWQianghua_ChangeTabIndex()
	--����2:1-ǿ����2-����
	PushEvent("UI_COMMAND",2019050401, 2,g_CaredNpc,DWQianghua_Frame:GetProperty("UnifiedPosition"),g_DWQIANGHUA_ToolItem_Num)
	DWQianghua_Close()
end
