local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;

local g_Object = -1;

function YuanbaopiaoExchange_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("UPDATE_YUANBAO");
end

function YuanbaopiaoExchange_OnLoad()

end

function YuanbaopiaoExchange_OnEvent(event)

	if ( event == "UI_COMMAND" and tonumber(arg0) == 2002 ) then
			if this:IsVisible() then
				YuanbaopiaoExchange_Close();
				return
			end

			g_Object = Get_XParam_INT(0);
			BeginCareObject_YuanbaopiaoExchange(Target:GetServerId2ClientId(g_Object));
			
			YuanbaopiaoExchange_OnShown();
			this:Show();
	elseif ( event == "OBJECT_CARED_EVENT") then
		YuanbaopiaoExchange_CareEventHandle(arg0,arg1,arg2);
	elseif (event == "UPDATE_YUANBAO" and this:IsVisible()) then
		YuanbaopiaoExchange_Update();
	end

end

function YuanbaopiaoExchange_OnShown()
	YuanbaopiaoExchange_Clear();
	YuanbaopiaoExchange_Update();
end

function YuanbaopiaoExchange_Clear()
	YuanbaopiaoExchange_Text1 : SetText("")
	YuanbaopiaoExchange_Moral_Value : SetText("")
end

function YuanbaopiaoExchange_Update()
	YuanbaopiaoExchange_Moral_Value:SetProperty("DefaultEditBox", "True");
	YuanbaopiaoExchange_Moral_Value:SetSelected( 0, -1 );
	YuanbaopiaoExchange_Text1 : SetText("������ʣ���Ԫ��������"..tostring(Player:GetData("YUANBAO")))
end

function YuanbaopiaoExchange_OK_Clicked()
	local str = YuanbaopiaoExchange_Moral_Value : GetText();
	
	if (str==nil or str=="") then
		return
	end
	
	if tonumber(str) > tonumber(Player:GetData("YUANBAO")) then
		PushDebugMessage("�������Ԫ������������ӵ�е�Ԫ��������");
		return
	end
	
	if tonumber(str) < 0 or tonumber(str) > 2000 then
		PushDebugMessage("ÿ��Ԫ��Ʊ������Ϊ2000��");
		return
	end
	
	local ret = Player:YuanBaoToTicket(tonumber(str));
	if(-1 == ret) then
		PushDebugMessage("�������Ԫ����������");
	else
		YuanbaopiaoExchange_Close();
	end
end

function YuanbaopiaoExchange_Close()
	YuanbaopiaoExchange_OnHiden();
	this:Hide()
end

function YuanbaopiaoExchange_Cancel_Clicked()
	YuanbaopiaoExchange_Close();
	return;
end

function YuanbaopiaoExchange_OnHiden()
	StopCareObject_YuanbaopiaoExchange(objCared)
	YuanbaopiaoExchange_Clear()
	return
end

function YuanbaopiaoExchange_CareEventHandle(careId, op, distance)
		if(nil == careId or nil == op or nil == distance) then
			return;
		end
		
		if(tonumber(careId) ~= g_clientNpcId) then
			return;
		end
		--�����NPC�ľ������һ��������߱�ɾ�����Զ��ر�
		if(op == "distance" and tonumber(distance)>MAX_OBJ_DISTANCE or op=="destroy") then
			YuanbaopiaoExchange_Close();
		end
end

--=========================================================
--��ʼ����NPC��
--�ڿ�ʼ����֮ǰ��Ҫ��ȷ����������ǲ����Ѿ��С����ġ���NPC��
--����еĻ�����ȡ���Ѿ��еġ����ġ�
--=========================================================
function BeginCareObject_YuanbaopiaoExchange(objCaredId)

	g_Object = objCaredId;
	--AxTrace(0,0,"LUA___CareObject g_Object =" .. g_Object );
	this:CareObject(g_Object, 1, "YuanbaopiaoExchange");

end

--=========================================================
--ֹͣ��ĳNPC�Ĺ���
--=========================================================
function StopCareObject_YuanbaopiaoExchange(objCaredId)
	this:CareObject(objCaredId, 0, "YuanbaopiaoExchange");
	g_Object = -1;

end



function YuanbaoPiaoExchange_Count_Change()
	local str = YuanbaopiaoExchange_Moral_Value : GetText();
	local strNumber = 0;	
	
	if ( str == nil ) then
		return;
	elseif( str == "" ) then
		strNumber = 1;
	else
		strNumber = tonumber( str );
	end
	str = tostring( strNumber );
	YuanbaopiaoExchange_Moral_Value:SetTextOriginal( str );
end