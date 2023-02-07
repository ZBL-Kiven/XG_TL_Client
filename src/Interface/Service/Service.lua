local EQUIP_BUTTONS;
local EQUIP_QUALITY = -1;
local Need_Item = 0
local Need_Money =0
local Need_Item_Count = 0
local Bore_Count=0
local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;
local Current = 0;

local g_Object = -1;
local Prompt_Text = {}

function Service_PreLoad()

	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("PACKAGE_ITEM_CHANGED");
	this:RegisterEvent("UPDATE_SERVICE");
	this:RegisterEvent("RESUME_ENCHASE_GEM");

end

function Service_OnLoad()
	EQUIP_BUTTONS = Service_Item
	Prompt_Text[1] = "  �����������̨�����;ý��͵�������Ҫ���������������ȼ�����Ҫ>=40����40���������������ۻ�����ֱ������#r  ����������Ҫ������켼�ܵȼ�*12��С������������ȼ���#r  �����п���ʧ�ܣ��ۼ�ʧ��3���������ϡ�������켼�ܵȼ�Խ�ߣ�ʧ�ܵĿ�����ԽС��#r  ���Ҫ����������϶����������Ʒ���У������������#r  ÿ���������Ļ���=�����ȼ�+4��#r  �����ȼ�=��������ȼ�/10+1��ȡ����"
	Prompt_Text[2] = "  ������ڷ���̨�����;ý��͵ķ��ߡ�Ҫ����ķ��ߵ�����ȼ�����Ҫ>=40����40�����·��������ۻ�����ֱ������#r  ���������Ҫ��ķ��Ҽ��ܵȼ�*12��С�ڷ��ߵ�����ȼ���#r  �����п���ʧ�ܣ��ۼ�ʧ��3�η��߱��ϡ���ķ��Ҽ��ܵȼ�Խ�ߣ�ʧ�ܵĿ�����ԽС��#r  ���Ҫ����ķ����϶����������Ʒ���У������������#r  ÿ���������Ļ���=���ߵȼ�+4��#r  ���ߵȼ�=��������ȼ�/10+1��ȡ����"
	Prompt_Text[3] = "  ������ڹ���̨�����;ý��͵���Ʒ��Ҫ�������Ʒ������ȼ�����Ҫ>=40����40��������Ʒ�����ۻ�����ֱ������#r  ������ƷҪ����Ĺ��ռ��ܵȼ�*12��С����Ʒ������ȼ���#r  �����п���ʧ�ܣ��ۼ�ʧ��3����Ʒ���ϡ���Ĺ��ռ��ܵȼ�Խ�ߣ�ʧ�ܵĿ�����ԽС��#r  ���Ҫ�������Ʒ�϶����������Ʒ���У������������#r  ÿ���������Ļ���=��Ʒ�ȼ�+4��#r  ��Ʒ�ȼ�=��Ʒ����ȼ�/10+1��ȡ����"
end

function Service_OnEvent(event)

	if ( event == "UI_COMMAND" and tonumber(arg0) == 41) then
			this:Show();

			local xx = Get_XParam_INT(0);
			objCared = DataPool : GetNPCIDByServerID(xx);
			AxTrace(0,1,"xx="..xx .. " objCared="..objCared)
			if objCared == -1 then
					PushDebugMessage("server�����������������⡣");
					return;
			end
			BeginCareObject_Service(objCared)
			Current = Get_XParam_INT(1);
			Service_Text:SetText(Prompt_Text[Current]);
	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		
		--�����NPC�ľ������һ��������߱�ɾ�����Զ��ر�
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			
			--ȡ������
			Service_Cancel_Clicked()
		end

	elseif ( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() ) then

		if( arg0~= nil and -1 == tonumber(arg0)) then
			return;
		end

		if( arg0~= nil ) then
			if (EQUIP_QUALITY == tonumber(arg0) ) then
				Service_Clear()
				Service_Update(tonumber(arg0))
			end
		end
	elseif( event == "UPDATE_SERVICE") then
		AxTrace(0,1,"arg0="..arg0)
		if arg0 ~= nil then
			Service_Clear()
			Service_Update(tonumber(arg0));
		end
	elseif( event == "RESUME_ENCHASE_GEM" and this:IsVisible() ) then
		if(arg0~=nil and tonumber(arg0) == 5) then
			Service_Clear()
		end
		
	end
	
end

function Service_OnShown()
	Service_Clear()
end

function Service_Clear()

	EQUIP_BUTTONS : SetActionItem(-1);
	Service_Item_Explain:SetText("")
	LifeAbility : Lock_Packet_Item(EQUIP_QUALITY,0);
	EQUIP_QUALITY = -1;

end

function Service_Update(pos0)
	local pos_packet;
	pos_packet = tonumber(pos0);

	local theAction = EnumAction(pos_packet, "packageitem");
	
	if theAction:GetID() ~= 0 then
		EQUIP_BUTTONS:SetActionItem(theAction:GetID());
		Service_Item_Explain:SetText(theAction:GetName());
		if EQUIP_QUALITY ~= -1 then
			LifeAbility : Lock_Packet_Item(EQUIP_QUALITY,0);
		end
		--��֮ǰ�Ķ�������
		EQUIP_QUALITY = pos_packet;
		LifeAbility : Lock_Packet_Item(EQUIP_QUALITY,1);
	else
		EQUIP_BUTTONS:SetActionItem(-1);
		Service_Item_Explain:SetText("")
		LifeAbility : Lock_Packet_Item(EQUIP_QUALITY,0);
		EQUIP_QUALITY = -1;
		return;
	end

--add here
end

function Service_Buttons_Clicked()

	if EQUIP_QUALITY ~= -1 then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("OnService");
			Set_XSCRIPT_ScriptID(801015);
			Set_XSCRIPT_Parameter(0,EQUIP_QUALITY);
			Set_XSCRIPT_Parameter(1,Current);
			Set_XSCRIPT_ParamCount(2);
		Send_XSCRIPT();
	else
		PushDebugMessage("���Ҫ�����װ���϶�����Ʒ���С�")
	end
	
end

function Service_Close()
	--�����ã��ñ������λ�ñ���
	if( this:IsVisible() ) then
		if(EQUIP_QUALITY ~= -1) then
			LifeAbility : Lock_Packet_Item(EQUIP_QUALITY,0);
		end
	end
	this:Hide();
	Service_Clear();
	StopCareObject_Service(objCared)
end

function Service_Cancel_Clicked()
	Service_Close();
	return;
end

--=========================================================
--��ʼ����NPC��
--�ڿ�ʼ����֮ǰ��Ҫ��ȷ����������ǲ����Ѿ��С����ġ���NPC��
--����еĻ�����ȡ���Ѿ��еġ����ġ�
--=========================================================
function BeginCareObject_Service(objCaredId)

	g_Object = objCaredId;
	this:CareObject(g_Object, 1, "Service");

end

--=========================================================
--ֹͣ��ĳNPC�Ĺ���
--=========================================================
function StopCareObject_Service(objCaredId)
	this:CareObject(objCaredId, 0, "Service");
	g_Object = -1;

end

function Resume_Equip()

	if( this:IsVisible() ) then

		if(EQUIP_QUALITY ~= -1) then
			LifeAbility : Lock_Packet_Item(EQUIP_QUALITY,0);
			EQUIP_BUTTONS : SetActionItem(-1);
			Service_Item_Explain:SetText("")
			EQUIP_QUALITY	= -1;
		end	
	end
	
end
