local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;

local g_Object = -1;
local nBindYuanBao = 0
function BindYuanBaoExchange_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("UPDATE_YUANBAO");
end

function BindYuanBaoExchange_OnLoad()

end

function BindYuanBaoExchange_OnEvent(event)

	if ( event == "UI_COMMAND" and tonumber(arg0) == 2020112002 ) then
			if this:IsVisible() then
				BindYuanBaoExchange_Close();
				return
			end

			g_Object = Get_XParam_INT(0);
			nBindYuanBao = Get_XParam_INT(1);
			BeginCareObject_BindYuanBaoExchange(Target:GetServerId2ClientId(g_Object));
			
			BindYuanBaoExchange_OnShown();
			this:Show();
	elseif ( event == "OBJECT_CARED_EVENT") then
		BindYuanBaoExchange_CareEventHandle(arg0,arg1,arg2);
	elseif (event == "UPDATE_YUANBAO" and this:IsVisible()) then
		BindYuanBaoExchange_Update();
	end

end

function BindYuanBaoExchange_OnShown()
	BindYuanBaoExchange_Clear();
	BindYuanBaoExchange_Update();
end

function BindYuanBaoExchange_Clear()
	BindYuanBaoExchange_Text1 : SetText("")
	BindYuanBaoExchange_Moral_Value : SetText("")
end

function BindYuanBaoExchange_Update()
	BindYuanBaoExchange_Moral_Value:SetProperty("DefaultEditBox", "True");
	BindYuanBaoExchange_Moral_Value:SetSelected( 0, -1 );
	BindYuanBaoExchange_Text1 : SetText("您身上剩余的绑定元宝数量："..tostring(nBindYuanBao))
end

function BindYuanBaoExchange_OK_Clicked()
	local str = BindYuanBaoExchange_Moral_Value : GetText();
	
	if (str==nil or str=="") then
		return
	end
	
	if tonumber(str) > tonumber(nBindYuanBao) then
		PushDebugMessage("您输入的绑定元宝数量大于您拥有的绑定元宝数量。");
		return
	end
	
	if tonumber(str) < 0 or tonumber(str) > 99999 then
		PushDebugMessage("每张绑定元宝票最大面额为99999。");
		return
	end
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("BindYuanBaoExchange"); 
		Set_XSCRIPT_ScriptID(805011);		
		Set_XSCRIPT_Parameter(0,tonumber(str));
		Set_XSCRIPT_ParamCount(1);
	Send_XSCRIPT()		
    
end

function BindYuanBaoExchange_Close()
	BindYuanBaoExchange_OnHiden();
	this:Hide()
end

function BindYuanBaoExchange_Cancel_Clicked()
	BindYuanBaoExchange_Close();
	return;
end

function BindYuanBaoExchange_OnHiden()
	StopCareObject_BindYuanBaoExchange(objCared)
	BindYuanBaoExchange_Clear()
	return
end

function BindYuanBaoExchange_CareEventHandle(careId, op, distance)
		if(nil == careId or nil == op or nil == distance) then
			return;
		end
		
		if(tonumber(careId) ~= g_clientNpcId) then
			return;
		end
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(op == "distance" and tonumber(distance)>MAX_OBJ_DISTANCE or op=="destroy") then
			BindYuanBaoExchange_Close();
		end
end

--=========================================================
--开始关心NPC，
--在开始关心之前需要先确定这个界面是不是已经有“关心”的NPC，
--如果有的话，先取消已经有的“关心”
--=========================================================
function BeginCareObject_BindYuanBaoExchange(objCaredId)

	g_Object = objCaredId;
	--AxTrace(0,0,"LUA___CareObject g_Object =" .. g_Object );
	this:CareObject(g_Object, 1, "BindYuanBaoExchange");

end

--=========================================================
--停止对某NPC的关心
--=========================================================
function StopCareObject_BindYuanBaoExchange(objCaredId)
	this:CareObject(objCaredId, 0, "BindYuanBaoExchange");
	g_Object = -1;

end



function BindYuanBaoExchange_Count_Change()
	local str = BindYuanBaoExchange_Moral_Value : GetText();
	local strNumber = 0;	
	
	if ( str == nil ) then
		return;
	elseif( str == "" ) then
		strNumber = 1;
	else
		strNumber = tonumber( str );
	end
	str = tostring( strNumber );
	BindYuanBaoExchange_Moral_Value:SetTextOriginal( str );
end