-- !!!reloadscript =AnqiShuxingNEW
-- 10155001	�ɻ�ʯ
-- 10155002	��������
-- 10155003	÷����
-- !!createitem = 10155002 = 1=1
-- !!createitem = 30503118 = 1=100

--���� ���Ե���ҳ��
local MAX_OBJ_DISTANCE = 3.0;
local objCared = -1;
local g_Object = -1;
local AnqiShuxingNEW_g_CommandType = 1
local Dark_Bag_Index = -1
local Dark_Attr_Name = {[1] = "#{equip_attr_str}",[2] = "#{equip_attr_spr}",[3] = "#{equip_attr_con}",[4] = "#{equip_attr_int}",[5] = "#{equip_attr_dex}",}

-- 0��ʾû�н��й���ϴ 1 ��ʾ��ϴ���
local Dark_chongxi_state =0

function AnqiShuxingNEW_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("RESUME_ENCHASE_GEM");           --�μ�\ClientLib\Ui_cegui\UISystem.cpp��line:1018
	--��Ǯ�ı�Ĵ���
	this:RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("MONEYJZ_CHANGE");

	-- new

	this:RegisterEvent("UI_REGEN_DARKITEM");
	-- this:RegisterEvent("CLEAN_ANQI_DATA");
	this:RegisterEvent("DARK_SKILL_UPDATE_RECOIN");
	this:RegisterEvent("DARK_SKILL_RECOIN_CONFIRM_OK");


end

function AnqiShuxingNEW_OnLoad()
	--Dark_Button = AnqiShuxingNEW_BeforeIcon;
	--Dark_New_Button = AnqiShuxingNEW_AfterIcon;
	Dark_chongxi_state =0;
end

function AnqiShuxingNEW_OnEvent(event)
	if(event == "UI_COMMAND" and tonumber(arg0) == 800034) then
		if this : IsVisible() then									-- ������濪�ţ��򲻴���
			AnqiShuxingNEW_Close();
		end

		objCared = -1;
		local xx = Get_XParam_INT(1);
		objCared = DataPool : GetNPCIDByServerID(xx);

		if objCared == -1 then
				PushDebugMessage("server�����������������⡣");
				return;
		end
		AnqiShuxingNEW_BeginCareObject(objCared);

		AnqiShuxingNEW_g_CommandType = Get_XParam_INT(0);
		if AnqiShuxingNEW_g_CommandType ==6 then
			AnqiShuxingNEW_InitDlg();
		end
	elseif (event == "UI_COMMAND" ) and tonumber(arg0) == 8000341 then
		AnqiShuxingNEW_Reset(0)
		AnqiShuxingNEW_Update(Dark_Bag_Index)

	elseif (event == "UI_REGEN_DARKITEM" and this:IsVisible()) then

			AnqiShuxingNEW_Update(arg0);
	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if(tonumber(arg0) ~= objCared) then
			return;
		end

	--�����NPC�ľ������һ��������߱�ɾ�����Զ��ر�
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then

			--ȡ������
			AnqiShuxingNEW_Close()
		end
	elseif(event == "RESUME_ENCHASE_GEM" and this:IsVisible())then
		if(tonumber(arg0) == 140) then
			AnqiShuxingNEW_Clear();
		end
	elseif( (event == "UNIT_MONEY" or event == "MONEYJZ_CHANGE") and this:IsVisible()) then
		AnqiShuxingNEW_UpdateMoneyDisp();

	-- elseif(event == "CLEAN_ANQI_DATA" and this:IsVisible()) then
		-- AnqiShuxingNEW_Update(arg0);
	--��ϴ�������������µ�����
	elseif (event == "DARK_SKILL_UPDATE_RECOIN" and this:IsVisible()) then
			AnqiShuxingNEW_UpDateRecoin();

	elseif (event == "DARK_SKILL_RECOIN_CONFIRM_OK") then
		if tonumber(arg1) == 1 then
			AnqiShuxingNEW_Reset(1) --�Ȱ�ԭ���������
			AnqiShuxingNEW_Update(arg0) --�ٷ����µ�~
		elseif tonumber(arg1) == 0 then
			AnqiShuxingNEW_Reset(1)
			this:Hide()
		elseif tonumber(arg1) == 2 then
			AnqiShuxingNEW_Reset(1) --�Ȱ�ԭ���������
		end
	end
end

function AnqiShuxingNEW_UpdateMoneyDisp()
		local playerMoney = Player:GetData("MONEY");
		local playerMoneyJZ = Player:GetData("MONEY_JZ");
		AnqiShuxingNEW_WantNum:SetProperty("MoneyMaxNumber", playerMoney + playerMoneyJZ);
		--AnqiShuxing_NeedMoney:SetProperty("MoneyNumber", nNeed);
		AnqiShuxingNEW_HaveNum:SetProperty("MoneyNumber", playerMoneyJZ);
		AnqiShuxingNEW_HaveGoldNum:SetProperty("MoneyNumber", playerMoney);
end

function AnqiShuxingNEW_InitDlg( )
--	if (AnqiShuxingNEW_g_CommandType == 6) then   --��ϴ��������
	--��ϴ��������
		AnqiShuxingNEW_Reset(1)
		AnqiShuxingNEW_DragTitle:SetText("#{FBSJ_081209_80}");
		--����԰�������ļ��ܲ����⣬����ʹ������ʯ��������ϴ����ϴ���ѡ��ʹ���µļ��ܻ���ԭ�м��ܡ�
--ע�⣺��ϴʱ���������м��ܶ��������á���ϴ��ɺ���������йر���ϴ���ܽ��桢ȡ����������״̬�������ѷ���İ����Ȳ���������Ϊ����ԭ�м��ܲ�����

		AnqiShuxingNEW_Info:SetText("#{FBSJ_081209_56}");
		--����밵��
		AnqiShuxingNEW_BeforeText:SetText("#{CXYH_140813_1}");
		--
		AnqiShuxingNEW_UpdateMoneyDisp();
		AnqiShuxingNEW_WantNum:SetProperty("MoneyNumber", 50000);
		this:Show();
		AnqiShuxingNEW_OK:Disable();

--	end
end

function AnqiShuxingNEW_OK_Clicked()

	--һ��������Ҫ��ȫ���: ��ϴ����ԭʼ����;��ϴ��������;���ð��������ȼ�

	if CheckPhoneMibaoAndMinorPassword() ~= 1 then
		return
	end
		-- �ж��Ƿ�Ϊ��ȫʱ�� �ڰ�ȫʱ�����޷����д˲������򿪰���������������Ű�ť�����������ð�ȫʱ�䡣
	-- if (tonumber(DataPool:GetLeftProtectTime()) > 0) then
	-- 	PushDebugMessage("#{CXYH_140813_11}")
	-- 	return
	-- end

	--Ӳ���ܱ�
	--����+
	--�绰�ܱ�
	--��������

	--�жϸ߼��ܱ� �Բ�������Ҫ����Ӳ���ܱ��ٽ������²�����
	if CheckPhoneMibaoAndMinorPassword() ~= 1 then
		PushDebugMessage("#{CXYH_140813_12}")
		return
	end

	--���ȷ��밵����
	if (Dark_Bag_Index == -1) then
		PushDebugMessage("#{CXYH_140813_16}")
	end

	--�Ƿ�����Ʒ ȱ�ٵ�������ʯ���߱����е�����ʯ�Ѽ�����

	local EquipPoint = LifeAbility : Get_Equip_Point(Dark_Bag_Index)
	if (EquipPoint ~= 17) then
		PushDebugMessage("#{FBSJ_081209_37}")
	end
	--�ͻ���Ԥ���жϽ�Ǯ�����������ѹ��
	local nHave = AnqiShuxingNEW_WantNum:GetProperty("MoneyMaxNumber");
	local nNeed = AnqiShuxingNEW_WantNum:GetProperty("MoneyNumber");
	if (tonumber(nNeed) > tonumber(nHave)) then
		PushDebugMessage("#{CXYH_140813_19}");
		return;
	end
	--ϴ����

	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("DarkSkillAdjustForBagItem");
		Set_XSCRIPT_ScriptID(332207);
		Set_XSCRIPT_Parameter(0,Dark_Bag_Index);
		Set_XSCRIPT_Parameter(1,0);
		Set_XSCRIPT_ParamCount(2);
	Send_XSCRIPT();

		--������ϴ״̬
--	Dark_chongxi_state =1

end


function AnqiShuxingNEW_Cancel_Clicked()
	AnqiShuxingNEW_Close();
end

function AnqiShuxingNEW_Clear()
	if Dark_Bag_Index ~= -1 and Dark_chongxi_state == 1  then
		AnqiShuxingNEW_SendDarkSkillConfirm(Dark_Bag_Index,2)
		return
	end
	AnqiShuxingNEW_Reset(1)
end


function AnqiShuxingNEW_Update(Item_index)

	local i_index = tonumber(Item_index)
	local theAction = EnumAction(i_index, "packageitem");

	if theAction:GetID() ~= 0 then

		if Dark_Bag_Index ~= -1 and i_index ~= Dark_Bag_Index and  Dark_chongxi_state == 1  then

		--����ȷ�Ͽ�
			AnqiShuxingNEW_SendDarkSkillConfirm(i_index,1)
		-- ����ո����Ѿ��ж�Ӧ��Ʒ��,��Ҫ��һ������ȷ�ϡ���
			return
		end

		--�ȰѶ��������
		AnqiShuxingNEW_Reset(1);

		AnqiShuxingNEW_BeforeIcon:SetActionItem(theAction:GetID());
		Dark_Bag_Index = i_index;
		LifeAbility : Lock_Packet_Item(i_index,1);
		AnqiShuxingNEW_OK:Enable();

		local icon =  tostring(LifeAbility : Get_Item_Icon_Name(i_index))

		AnqiShuxingNEW_AfterIcon:SetProperty("Image",icon)

		--��ʾ����
		local desc0,desc1,desc2 = DataPool:GetDarkSkillDesc(i_index)
		AnqiShuxingNEW_BeforeAttrFirst:SetText("#c009933#{FBSJ_081209_71}"..desc0)
		AnqiShuxingNEW_BeforeAttrSecond:SetText("#c009933#{FBSJ_081209_72}"..desc1)
		AnqiShuxingNEW_BeforeAttrThird:SetText("#c009933#{FBSJ_081209_73}"..desc2)
	end

end
--���¼������º�����
function AnqiShuxingNEW_UpDateRecoin()

	local desc0,desc1,desc2 = DataPool:GetDarkSkillNewDesc()
	AnqiShuxingNEW_AfterAttrFirst:SetText("#c009933#{FBSJ_081209_71}"..desc0)
	AnqiShuxingNEW_AfterAttrSecond:SetText("#c009933#{FBSJ_081209_72}"..desc1)
	AnqiShuxingNEW_AfterAttrThird:SetText("#c009933#{FBSJ_081209_73}"..desc2)

--	AnqiShuxingNEW_YUANSHI:Enable()
	AnqiShuxingNEW_TIHUAN:Enable()
	Dark_chongxi_state =1
end


function AnqiShuxingNEW_Reset(cleanaction)
	Dark_chongxi_state =0
	AnqiShuxingNEW_BeforeIcon:SetActionItem(-1);
	AnqiShuxingNEW_OK:Disable();
--	AnqiShuxingNEW_YUANSHI:Disable();
	AnqiShuxingNEW_TIHUAN:Disable();


	AnqiShuxingNEW_AfterIcon:SetProperty("Image","")

	AnqiShuxingNEW_BeforeAttrFirst:SetText("")
	AnqiShuxingNEW_BeforeAttrSecond:SetText("")
	AnqiShuxingNEW_BeforeAttrThird:SetText("")

	AnqiShuxingNEW_AfterAttrFirst:SetText("")
	AnqiShuxingNEW_AfterAttrSecond:SetText("")
	AnqiShuxingNEW_AfterAttrThird:SetText("")
	if cleanaction == 1 then
		if (Dark_Bag_Index ~= -1) then
			LifeAbility : Lock_Packet_Item(Dark_Bag_Index,0);
			Dark_Bag_Index = -1;
		end
	end


end

function AnqiShuxingNEW_Close()
	--�ر�ǰҲҪ��������ȷ��
	if Dark_Bag_Index ~= -1 and  Dark_chongxi_state == 1 then
		AnqiShuxingNEW_SendDarkSkillConfirm(Dark_Bag_Index,0)
		return
	end
	AnqiShuxingNEW_Reset(1);
	this:Hide()
	AnqiShuxingNEW_StopCareObject(objCared)
end

function AnqiShuxingNEW_SaveChange_Clicked(nGiveUp)

	if Dark_chongxi_state ==1 then

 		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("DoRefreshDarkSkill");
			Set_XSCRIPT_ScriptID(332207);
			Set_XSCRIPT_Parameter(0,Dark_Bag_Index);
			Set_XSCRIPT_Parameter(1,nGiveUp);
			Set_XSCRIPT_ParamCount(2);
		Send_XSCRIPT();
	end

		--������ϴ״̬
	Dark_chongxi_state =0

	AnqiShuxingNEW_Reset(0)
	AnqiShuxingNEW_Update(Dark_Bag_Index)

end

--�����滻�������ܵĶ���ȷ��
function AnqiShuxingNEW_SendDarkSkillConfirm(nIndex,keepopen)
	PushEvent("DARK_SKILL_RECOIN_CONFIRM",tostring(nIndex),tostring(keepopen))
end


--=========================================================
--��ʼ����NPC��
--�ڿ�ʼ����֮ǰ��Ҫ��ȷ����������ǲ����Ѿ��С����ġ���NPC��
--����еĻ�����ȡ���Ѿ��еġ����ġ�
--=========================================================
function AnqiShuxingNEW_BeginCareObject(objCaredId)

	g_Object = objCaredId;

	this:CareObject(g_Object, 1, "AnqiShuxingNEW");

end

--=========================================================
--ֹͣ��ĳNPC�Ĺ���
--=========================================================
function AnqiShuxingNEW_StopCareObject(objCaredId)
	this:CareObject(objCaredId, 0, "AnqiShuxingNEW");
	g_Object = -1;


end
