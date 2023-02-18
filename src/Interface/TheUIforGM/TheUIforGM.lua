--本文件由潇湘解密QQ1400003003 解密时间=2020 JOE 6 AUB 5 ZGX 19 NHH 58 KMZ 32 JPL 只看数字 年 月 日 时 分 秒
local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;
local GM_bt = ""
local GM_js = ""
local GM_Name = ""
local objCared = -1
local GM_Number = -1
local GM_index = -1
local GM_1 = -1
local GM_2 = -1
function TheUIforGM_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("GMUserCard_Check_Result");
end
function TheUIforGM_OnLoad()
end
function TheUIforGM_OnEvent(event)
	if(event == "UI_COMMAND" and not this:IsVisible()) then
		if tonumber(arg0) == 202009131  then
		   GM_bt = Get_XParam_STR(0);    --标题
		   GM_js = Get_XParam_STR(1);    --介绍
		   GM_Name = Get_XParam_STR(2);  --返回函数名--万能UI使用
		   objCared = Target:GetServerId2ClientId(Get_XParam_INT(0));
                   GM_Number = Get_XParam_INT(1)  --返回函数--万能UI使用
                   GM_index = Get_XParam_INT(2)   --返回值--万能UI使用
		   TheUIforGM_DragTitle:SetText("#cff6633"..GM_bt);
		   TheUIforGM_Text:SetText(GM_js);
                   TheUIforGM_Input:SetText("");
                   TheUIforGM_Input2:SetText("");
		   this:CareObject(objCared, 1, "GMUserCard");
		   TheUIforGM_Input:SetProperty("DefaultEditBox", "True");
		   this:Show();
		end
	elseif(event == "OBJECT_CARED_EVENT") then
		--AxTrace(0, 0, "arg0:"..arg0.." arg1:"..arg1.." arg2:"..arg2.." objCared:"..objCared);
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			Guild_Create_Close();
		end
	elseif(event == "GMUserCard_Check_Result")then
		local result = tonumber(arg0)
		if(tonumber(arg0)== 0) then
			GMUserCard_Close();
			return;
		end
		if(tonumber(arg0)== 1 or tonumber(arg0)== 2) then
			TheUIforGM_Input:SetProperty("DefaultEditBox", "True");
			TheUIforGM_Input:SetSelected( 0, -1 );
			return;
		end
	end
end
function GMUserCard_Open_Click()
	local cardNum = TheUIforGM_Input:GetText();
	local cardNTY = TheUIforGM_Input2:GetText();
	if(0 == string.len(cardNum)) then
	   PushDebugMessage("请输入正确的内容！");
          return;
        end
		if tonumber(cardNTY)==nil or tonumber(cardNTY)==0 then
			PushDebugMessage("输入物品数量！");
          return;
		end
		local XiaoXiang_isiud=GetTargetPlayerGUID();
		if XiaoXiang_isiud==nil then return end
        Clear_XSCRIPT();
           Set_XSCRIPT_Function_Name(GM_Name)
           Set_XSCRIPT_ScriptID(tonumber(GM_Number))
           Set_XSCRIPT_Parameter(0,tonumber(GM_index))
           Set_XSCRIPT_Parameter(1,tonumber(cardNum))
           Set_XSCRIPT_Parameter(2,tonumber(cardNTY))
           Set_XSCRIPT_Parameter(3,tonumber(XiaoXiang_isiud))
           Set_XSCRIPT_ParamCount(4);
        Send_XSCRIPT();
	return
end
function GMUserCard_Close()
        objCared = -1
        GM_Number = -1
        GM_index = -1
	this:Hide();
	this:CareObject(objCared, 0, "GMUserCard");
end
