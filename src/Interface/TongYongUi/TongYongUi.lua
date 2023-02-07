--ͨ�õ���UI���� Q546528533
local MAX_OBJ_DISTANCE = 3.0;
local objCared = -1;
local g_Object = -1;
local TongYongUi_g_CommandType = 1
local Dark_Button = -1
local Equip_Bag_Index = -1

function TongYongUi_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("RESUME_ENCHASE_GEM");
	--��Ǯ�ı�Ĵ���
	this:RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("MONEYJZ_CHANGE");
end

function TongYongUi_OnLoad()
	Dark_Button = TongYongUi_Special_Button;
end

function TongYongUi_OnEvent(event)
	if(event == "UI_COMMAND" and tonumber(arg0) == 20200605) then
		if this : IsVisible() then									-- ������濪�ţ��򲻴���
			TongYongUi_Close();
		end
		
		objCared = -1;
		local xx = Get_XParam_INT(1);
		objCared = DataPool : GetNPCIDByServerID(xx);
		AxTrace(0,0,"xx="..xx .. " objCared="..objCared)
		if objCared == -1 then
				PushDebugMessage("server�����������������⡣");
				return;
		end
		TongYongUi_BeginCareObject(objCared);

		TongYongUi_g_CommandType = Get_XParam_INT(0);
		TongYongUi_InitDlg();
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 201107281 and this:IsVisible()) then
		TongYongUi_Update(arg1);
	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		
		--�����NPC�ľ������һ��������߱�ɾ�����Զ��ر�
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			
			--ȡ������
			TongYongUi_Close()
		end
	elseif(event == "RESUME_ENCHASE_GEM" and this:IsVisible())then
		if(tonumber(arg0) == 72) then
			TongYongUi_Resume();
		end
	elseif( (event == "UNIT_MONEY" or event == "MONEYJZ_CHANGE") and this:IsVisible()) then
		TongYongUi_UpdateMoneyDisp();
	end
end

function TongYongUi_UpdateMoneyDisp()
		local playerMoney = Player:GetData("MONEY");
		local playerMoneyJZ = Player:GetData("MONEY_JZ");
		TongYongUi_NeedMoney:SetProperty("MoneyMaxNumber", playerMoney + playerMoneyJZ);
		--TongYongUi_NeedMoney:SetProperty("MoneyNumber", nNeed);
		TongYongUi_SelfJiaozi:SetProperty("MoneyNumber", playerMoneyJZ);
		TongYongUi_SelfMoney:SetProperty("MoneyNumber", playerMoney);
end

function TongYongUi_InitDlg( )
	if  TongYongUi_g_CommandType == 1 then   --����ʱװ�޸�
		TongYongUi_DragTitle:SetText("#gFF0FA0��¥�ϳ�");
		TongYongUi_Info:SetText("  Ϊ����Ҷ�����¥���˷ѣ��ؿ�����¥�ϳɡ�����4����¥�ɽ�����¥����Ϊ����¥��#G����¥��ʯ�����ƾ�����ʧ");
		TongYongUi_Static2:SetText("������Ҫ��������¥");
		TongYongUi_UpdateMoneyDisp();
		TongYongUi_NeedMoney:SetProperty("MoneyNumber", 10000);
		this:Show();
		TongYongUi_OK:Disable();
	end
	if  TongYongUi_g_CommandType == 2 then   --����ʱװ�޸�
		TongYongUi_DragTitle:SetText("#gFF0FA0������ϴ");
		TongYongUi_Info:SetText("#cFF000082-86����Ҫ5�������1����92-96����Ҫ5�������2����102����Ҫ5�������3��");
		TongYongUi_Static2:SetText("������ϴ������");
		TongYongUi_UpdateMoneyDisp();
		TongYongUi_NeedMoney:SetProperty("MoneyNumber", 5000000);
		this:Show();
		TongYongUi_OK:Disable();
	end
	if  TongYongUi_g_CommandType == 3 then   --����ʱװ�޸�
		TongYongUi_DragTitle:SetText("#gFF0FA0������ϴ");
		TongYongUi_Info:SetText("  ʹ��#G�Ͻ�ɰ#cfff263��#G�Ͻ�ʯ#cfff263�ֱ��#G80#cfff263�������ϵȼ���#G7#cfff263��#G8#cfff263��#G�ֹ�����װ��������������#cfff263��ӵ�е�#G��չ����#cfff263����#G����#cfff263��");
		TongYongUi_Static2:SetText("�����ֹ�");
		TongYongUi_UpdateMoneyDisp();
		TongYongUi_NeedMoney:SetProperty("MoneyNumber", 5000000);
		this:Show();
		TongYongUi_OK:Disable();
	end
end

function TongYongUi_OK_Clicked()
	if (Equip_Bag_Index ~= -1) then
		local EquipPoint = LifeAbility : Get_Equip_Point(Equip_Bag_Index)
		  -- if TongYongUi_g_CommandType == 1 then
		    -- if (EquipPoint ~= 2) then
			    -- PushDebugMessage("�˴�ֻ�ܷ���ʱװ")
			   -- return
		    -- end
		  -- end
		--�ͻ���Ԥ���жϽ�Ǯ�����������ѹ��
		local nHave = TongYongUi_NeedMoney:GetProperty("MoneyMaxNumber");
		local nNeed = TongYongUi_NeedMoney:GetProperty("MoneyNumber");
		if (tonumber(nNeed) > tonumber(nHave)) then
			 PushDebugMessage("#{FBSJ_081209_25}");
			 return;
		end
		if TongYongUi_g_CommandType == 1 then --��������ʱװ����
					Clear_XSCRIPT();
						Set_XSCRIPT_Function_Name("OnShenqiLevelUp");
						Set_XSCRIPT_ScriptID(500506);
						Set_XSCRIPT_Parameter(0,Equip_Bag_Index)
						Set_XSCRIPT_Parameter(1,-99)
						Set_XSCRIPT_ParamCount(2)
					Send_XSCRIPT();
		end
		if TongYongUi_g_CommandType == 2 then --��������ʱװ����
					Clear_XSCRIPT();
						Set_XSCRIPT_Function_Name("OnShenqiUpgrade");
						Set_XSCRIPT_ScriptID(500505);
						Set_XSCRIPT_Parameter(0,Equip_Bag_Index)
						Set_XSCRIPT_ParamCount(1)
					Send_XSCRIPT();
		end
		if TongYongUi_g_CommandType == 3 then --��������ʱװ����
					Clear_XSCRIPT();
						Set_XSCRIPT_Function_Name("DoRefreshSuperAttr");
						Set_XSCRIPT_ScriptID(500505);
						Set_XSCRIPT_Parameter(0,Equip_Bag_Index)
						Set_XSCRIPT_ParamCount(1)
					Send_XSCRIPT();
		end
		
		--LifeAbility : Lock_Packet_Item(Equip_Bag_Index,0);
		--Equip_Bag_Index = -1;
		--Dark_Button:SetActionItem(-1);
	end
	--TongYongUi_Close();
end


function TongYongUi_Cancel_Clicked()
	TongYongUi_Close();
end

function TongYongUi_Clear()
	 TongYongUi_Resume();
end


function TongYongUi_Update(Item_index)
	local i_index = tonumber(Item_index)
	local theAction = EnumAction(i_index, "packageitem");
	
	--�ȰѶ��������
	TongYongUi_Resume();
	
	AxTrace(0,0,tostring(i_index));
	if theAction:GetID() ~= 0 then
		Dark_Button:SetActionItem(theAction:GetID());
		Equip_Bag_Index = i_index;
		LifeAbility : Lock_Packet_Item(i_index,1);
		TongYongUi_OK:Enable();
	end
end


function TongYongUi_Resume()
	Dark_Button:SetActionItem(-1);
	TongYongUi_OK:Disable();
	if (Equip_Bag_Index ~= -1) then
		LifeAbility : Lock_Packet_Item(Equip_Bag_Index,0);
		Equip_Bag_Index = -1;
	end
end

function TongYongUi_Close()
	this:Hide()
	StopCareObject_Enchase(objCared)
end


--=========================================================
--��ʼ����NPC��
--�ڿ�ʼ����֮ǰ��Ҫ��ȷ����������ǲ����Ѿ��С����ġ���NPC��
--����еĻ�����ȡ���Ѿ��еġ����ġ�
--=========================================================
function TongYongUi_BeginCareObject(objCaredId)

	g_Object = objCaredId;
	AxTrace(0,0,"LUA___CareObject g_Object =" .. g_Object );
	this:CareObject(g_Object, 1, "TongYongUi");

end

--=========================================================
--ֹͣ��ĳNPC�Ĺ���
--=========================================================
function TongYongUi_StopCareObject(objCaredId)
	this:CareObject(objCaredId, 0, "TongYongUi");
	g_Object = -1;
	

end