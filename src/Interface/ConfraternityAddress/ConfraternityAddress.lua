--UI COMMAND ID 101
local g_clientNpcId = -1;
local MAX_OBJ_DISTANCE = 3.0;
local g_InvalidHeader = "#cFF0000";
local g_ProductHeader = "#Y";

--doing 28327 2007.11.30 by alan
--�򿪰���б�ʱ��Ҫ�����б����ݣ�Ҳ�ᴥ����������еĽ��棬����ʱ���ܴ򿪴˴���
--���Ǽ�¼UI COMMAND ID��ʶ���Ƿ���Ҫ��������еĽ���
local g_CurUICommandID = 0;

local g_CityPortCtl = {};
local MAX_CITY_PORT_GROUP = 54;

function ConfraternityAddress_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("CITY_SHOW_PORT_LIST");
end

function ConfraternityAddress_OnLoad()
end


function ConfraternityAddress_OnEvent(event)
	City_Port_PrepareCtl();
	if event == "UI_COMMAND" then
		if tonumber(arg0) == 101 then
			g_clientNpcId = Get_XParam_INT(0);
			g_clientNpcId = Target:GetServerId2ClientId(g_clientNpcId);
			g_CurUICommandID = 101
		else
			g_CurUICommandID = 0
		end
	elseif(event == "CITY_SHOW_PORT_LIST" and arg0 == "open") then
		if g_CurUICommandID==101 then
			this:CareObject(g_clientNpcId, 1, "CityPort");
			City_Port_ClearListBox();
			City_Port_ClearInfo();
			City_Port_Update();
			this:Show();
		end
	elseif(event == "CITY_SHOW_PORT_LIST" and arg0 == "close") then
		this:Hide();
	elseif ( event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		City_Port_CareEventHandle(arg0,arg1,arg2);
	end
end

function City_Port_PrepareCtl()
	g_CityPortCtl = {
								--�����б�
								list			= ConfraternityAddress_MemberList,
								--������Ϣ
								name 			= ConfraternityAddress_Info1,
								com 			= ConfraternityAddress_Info2,
								product 	= ConfraternityAddress_Info3,
								product1	= ConfraternityAddress_Info4,
								product2	= ConfraternityAddress_Info5,
								product3	= ConfraternityAddress_Info6,
							};
end

function City_Port_ClearListBox()
	g_CityPortCtl.list:ClearListBox();
end

function City_Port_ClearInfo()
	g_CityPortCtl.name:SetText("");
	g_CityPortCtl.com:SetText("");
	g_CityPortCtl.product:SetText("");
	g_CityPortCtl.product1:SetText("");
	g_CityPortCtl.product2:SetText("");
	g_CityPortCtl.product3:SetText("");
end

function City_Port_Update()
	local i = 0;
	while i < MAX_CITY_PORT_GROUP do
		if(City:GetPortInfo(i, "Name") == "") then break; end
		--AxTrace(0,0,"City Port Name:"..City:GetPortInfo(i, "Name"));
		if(tonumber(City:GetPortInfo(i, "Valid")) < 0) then
			g_CityPortCtl.list:AddItem(g_InvalidHeader..City:GetPortInfo(i, "Name"),i);
		else
			g_CityPortCtl.list:AddItem(City:GetPortInfo(i, "Name"),i);
		end
		
		i = i + 1;
	end
end

function City_Port_Selected()
	local idx = g_CityPortCtl.list:GetFirstSelectItem();
	if(idx < 0) then return; end
	
	City_Port_ClearInfo();
	--����
	g_CityPortCtl.name:SetText("��أ�"..City:GetPortInfo(idx, "Name"));
	--��Ȧ
	g_CityPortCtl.com:SetText("����������"..City:GetPortInfo(idx, "ComName"));
	--�ز�
	g_CityPortCtl.product:SetText("����ӵ���ز���");
	--�ز�1
	local szItemName = City:GetPortInfo(idx, "Product1");
	if("" ~= szItemName) then
		g_CityPortCtl.product1:SetText(g_ProductHeader..szItemName);
	end
	--�ز�1
	szItemName = City:GetPortInfo(idx, "Product2");
	if("" ~= szItemName) then
		g_CityPortCtl.product2:SetText(g_ProductHeader..szItemName);
	end
	--�ز�1
	szItemName = City:GetPortInfo(idx, "Product3");
	if("" ~= szItemName) then
		g_CityPortCtl.product3:SetText(g_ProductHeader..szItemName);
	end
end

function City_Port_CreateCity()
	local idx = g_CityPortCtl.list:GetFirstSelectItem();
	if(idx < 0) then return; end
	
	local valid = tonumber(City:GetPortInfo(idx, "Valid"));
	if(valid < 0) then
		if(valid == -1) then
			PushDebugMessage("�������ѱ��������ռ�졣");
		end
		return;
	end
	--�������
	--City:CreateCity(idx);
	City:InputCityName(idx, g_clientNpcId);
	this:Hide();
end

function City_Port_CareEventHandle(careId, op, distance)
		if(nil == careId or nil == op or nil == distance) then
			return;
		end
		
		if(tonumber(careId) ~= g_clientNpcId) then
			return;
		end
		--�����NPC�ľ������һ��������߱�ɾ�����Զ��ر�
		if(op == "distance" and tonumber(distance)>MAX_OBJ_DISTANCE or op=="destroy") then
			this:Hide();
		end
end