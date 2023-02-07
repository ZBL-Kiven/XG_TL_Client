--�����޲�ת������
--��ң��
--QQ 857904341
local g_Object = {}
local g_Money
local g_SelfJiaozi
local g_SelfMoney
local g_NpcObjId
local isFillinObj1
local isFillinObj3
local isBind1 = 0
local isBind3 = 0
local zhizunmianbu_bind = 20501008
local zhizunmianbu_notbind = 20501004
local zhizunmiyin_bind = 20502008
local zhizunmiyin_notbind = 20502004
local needJiaoZi = 500000
local obj1_index = -1
local obj3_index = -1
local g_type_miyin = 1
local g_type_mianbu = 2
local g_targetId
local g_maxOptTimes = 5
local g_Position = "{{0.500000,-150.000000},{0.500000,-215.000000}}";
local isConitnue = 0
local g_ComposeCheck = 0
function SJ_CaiLiaoQiangHua_PreLoad()
	this:RegisterEvent("UI_COMMAND"); 				 --���ã��򿪱�ʯת������
	this:RegisterEvent("UPDATE_CAILIAOQIANGHUA"); 
	this:RegisterEvent("UPDATE_CAILIAOQIANGHUA_CONFIRM"); 
	this:RegisterEvent( "VIEW_RESOLUTION_CHANGED" );		-- ��Ϸ�ֱ��ʷ����˱仯
	this:RegisterEvent( "HIDE_ON_SCENE_TRANSED" );		-- �뿪����
	this:RegisterEvent("UNIT_MONEY",false)					--��Ǯ�仯
	this:RegisterEvent("MONEYJZ_CHANGE",false)					--���ӱ仯
end

function SJ_CaiLiaoQiangHua_OnLoad()
	g_Object = {
		[1] = SJ_CaiLiaoQiangHua_Object1,
		[2] = SJ_CaiLiaoQiangHua_Object2,
		[3] = SJ_CaiLiaoQiangHua_Object3,
	}
	g_Money = SJ_CaiLiaoQiangHua_Money
	g_SelfJiaozi = SJ_CaiLiaoQiangHua_SelfJiaozi
	g_SelfMoney = SJ_CaiLiaoQiangHua_SelfMoney
end

function SJ_CaiLiaoQiangHua_OnEvent(event)
	if (event == "UI_COMMAND" and tonumber(arg0) == 2018101301) then
		-- ��UI
		SJ_CaiLiaoQiangHua_Clear()
		g_targetId = tonumber(Get_XParam_INT(0));
		local times = tonumber(Get_XParam_INT(1))
		g_NpcObjId = Target:GetServerId2ClientId(g_targetId);
		this:CareObject(g_NpcObjId, 1, "SJ_CaiLiaoQiangHua");
		local playerMoney = Player:GetData("MONEY");
		local playerMoneyJZ = Player:GetData("MONEY_JZ");
		g_SelfJiaozi:SetProperty("MoneyNumber", playerMoneyJZ)
		g_SelfMoney:SetProperty("MoneyNumber", playerMoney)
		local nIntroduce
		if times == g_maxOptTimes then
			nIntroduce = "    #cfff263�ȼ�#G�ﵽ80��#cfff263��ʹ��#G1#cfff263��#G�����#cfff263��#G1#cfff263��#G3���޲�#cfff263���Ϊ#G1#cfff263��#G�����޲�#cfff263����#G1#cfff263��#G3������#cfff263���Ϊ#G1#cfff263��#G��������#cfff263��������#G100%�ɹ�#cfff263��#G#r    С��ʾ�������ϰ�ʱ������Ĳ���Ϊ�󶨲��ϡ�"
		else
			nIntroduce = "    #cfff263�ȼ�#G�ﵽ80��#cfff263��ʹ��#G1#cfff263��#G�����#cfff263��#G1#cfff263��#G3���޲�#cfff263���Ϊ#G1#cfff263��#G�����޲�#cfff263����#G1#cfff263��#G3������#cfff263���Ϊ#G1#cfff263��#G��������#cfff263��������#G100%�ɹ�#cfff263��#G#r    С��ʾ�������ϰ�ʱ������Ĳ���Ϊ�󶨲��ϡ�"
		end
		
		SJ_CaiLiaoQiangHua_Info1:SetText(nIntroduce)
		this:Show();
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 201401111 and this:IsVisible()) then
		if arg1 ~= nil then
			local nItemID = PlayerPackage:GetItemTableIndex(tonumber(arg1))
			local nType = 0
			if nItemID >= 20502001 and nItemID <= 20502008 then
				nType = 1 --����
			elseif nItemID >= 20501001 and nItemID <= 20501008 then
				nType = 2 --�޲�
			elseif nItemID == 38000952 then
				nType = 3
			end
			SJ_CaiLiaoQiangHua_UpdateCaiLiaoChange(nType,tonumber(arg1),1)
		end
	elseif (event == "UPDATE_CAILIAOQIANGHUA_CONFIRM") then
		isConitnue = 1
	elseif ( event == "VIEW_RESOLUTION_CHANGED" ) then
		-- �ָ�Ĭ��λ��
		SJ_CaiLiaoQiangHua_Frame:SetProperty( "UnifiedPosition", g_Position );
	elseif ( event == "HIDE_ON_SCENE_TRANSED" ) then
		this:Hide();
	elseif event == "UNIT_MONEY" and this:IsVisible() then
		g_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
	elseif event == "MONEYJZ_CHANGE" and this:IsVisible() then
		g_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
	end
end

function SJ_CaiLiaoQiangHua_Clear()
	g_Object[1]:SetActionItem(-1)
	g_Object[2]:SetActionItem(-1)
	g_Object[3]:SetActionItem(-1)
    isBind1 = 0
    isBind3 = 0
	isFillinObj1 = 0
	isFillinObj3 = 0
	g_NpcObjId = 0
	g_targetId = 0
	isConitnue = 0
	g_Money:SetProperty("MoneyNumber", 0)
	g_SelfJiaozi:SetProperty("MoneyNumber", 0)
	g_SelfMoney:SetProperty("MoneyNumber", 0)
	SJ_CaiLiaoQiangHua_OK:Disable()
	if obj1_index ~= -1 then
		LifeAbility:Lock_Packet_Item(obj1_index,0)
		obj1_index = -1
	end
	if obj3_index ~= -1 then
		LifeAbility:Lock_Packet_Item(obj3_index,0)
		obj3_index = -1
	end
end

function SJ_CaiLiaoQiangHua_Close()
	SJ_CaiLiaoQiangHua_Clear()
	this:Hide()
end

function SJ_CaiLiaoQiangHua_ClearObj(index)
	g_Object[index]:SetActionItem(-1)
	if index == 1 then
		isFillinObj1 = 0
		isBind1 = 0
	elseif index == 3 then
		isFillinObj3 = 0
		isBind3 = 0
	end
	g_Object[2]:SetActionItem(-1)
	SJ_CaiLiaoQiangHua_OK:Disable()
	if index == 1 and obj1_index ~= -1 then
		LifeAbility:Lock_Packet_Item(obj1_index,0)
		obj1_index = -1
	end
	if index == 3 and obj3_index ~= -1 then
		LifeAbility:Lock_Packet_Item(obj3_index,0)
		obj3_index = -1
		SJ_CaiLiaoQiangHua_ShowResult(isFillinObj1, isBind1) --�������1Ϊ��Ҳ��Ҫ�� 
	end
	isConitnue = 0
end

function SJ_CaiLiaoQiangHua_UpdateCaiLiaoChange(nType, nItemIndex, isBind)
	local playerMoney = Player:GetData("MONEY");
	local playerMoneyJZ = Player:GetData("MONEY_JZ");
	g_SelfJiaozi:SetProperty("MoneyNumber", playerMoneyJZ)
	g_SelfMoney:SetProperty("MoneyNumber", playerMoney)
	SJ_CaiLiaoQiangHua_OK:Disable()
	local theAction = EnumAction(nItemIndex, "packageitem");
	isConitnue = 0
	if nType == g_type_miyin then
		if theAction:GetID() ~= 0 then
			g_Object[1]:SetActionItem(theAction:GetID())
			isFillinObj1 = 1
			LifeAbility:Lock_Packet_Item(nItemIndex,1)
			if obj1_index ~= nItemIndex then
				LifeAbility:Lock_Packet_Item(obj1_index,0)
			end
			obj1_index = nItemIndex
			SJ_CaiLiaoQiangHua_ShowResult(g_type_miyin, isBind)
		end

	elseif nType == g_type_mianbu then
		if theAction:GetID() ~= 0 then
			g_Object[1]:SetActionItem(theAction:GetID())
			isFillinObj1 = 2
			LifeAbility:Lock_Packet_Item(nItemIndex,1)
			if obj1_index ~= nItemIndex then
				LifeAbility:Lock_Packet_Item(obj1_index,0)
			end
			obj1_index = nItemIndex
			SJ_CaiLiaoQiangHua_ShowResult(g_type_mianbu, isBind)
		end
	elseif nType == 3 then
		if theAction:GetID() ~= 0 then
			g_Object[3]:SetActionItem(theAction:GetID())
			isFillinObj3 = 1
			LifeAbility:Lock_Packet_Item(nItemIndex,1)
			if obj3_index ~= nItemIndex then
				LifeAbility:Lock_Packet_Item(obj3_index,0)
			end
			obj3_index = nItemIndex
		end
	end

	if isFillinObj1 == 1 and isFillinObj3 == 1 then --���������͵��ʯ
		SJ_CaiLiaoQiangHua_ShowResult(g_type_miyin, isBind)
		SJ_CaiLiaoQiangHua_OK:Enable()
		g_Money:SetProperty("MoneyNumber", tostring(needJiaoZi))
	end
	if isFillinObj1 == 2 and isFillinObj3 == 1 then --�����޲��͵��ʯ
		SJ_CaiLiaoQiangHua_ShowResult(g_type_mianbu, isBind)
		SJ_CaiLiaoQiangHua_OK:Enable()
		g_Money:SetProperty("MoneyNumber", tostring(needJiaoZi))
	end
end

function SJ_CaiLiaoQiangHua_DianJin()	
	if obj1_index == -1 or obj3_index == -1 then
		return
	end
	
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name( "MaterialLeveUpEx" ); 	-- �ű���������
		Set_XSCRIPT_ScriptID( 900011 );				-- �ű����
		Set_XSCRIPT_Parameter( 0, 107 );		-- ����һ
		Set_XSCRIPT_Parameter(1, obj1_index);  		
		Set_XSCRIPT_Parameter(2, obj3_index); 			
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT();
	return
end

function SJ_CaiLiaoQiangHua_ShowResult(nType, isBind)
	if nType == 1 then
		if isBind == 1 then--�������֮һ�а�����ʾ�󶨽��
			local theAction = GemMelting:UpdateProductAction(zhizunmiyin_bind)
			if theAction:GetID() ~= 0 then
	  		g_Object[2]:SetActionItem(theAction:GetID())
			end
		else
			local theAction = GemMelting:UpdateProductAction(zhizunmiyin_notbind)
			if theAction:GetID() ~= 0 then
	  		g_Object[2]:SetActionItem(theAction:GetID())
			end
		end
	elseif nType == 2 then
		if isBind == 1 then--�������֮һ�а�����ʾ�󶨽��
			local theAction = GemMelting:UpdateProductAction(zhizunmianbu_bind)
			if theAction:GetID() ~= 0 then
	  		g_Object[2]:SetActionItem(theAction:GetID())
			end
		else
			local theAction = GemMelting:UpdateProductAction(zhizunmianbu_notbind)
			if theAction:GetID() ~= 0 then
	  		g_Object[2]:SetActionItem(theAction:GetID())
			end
		end
	end
end