local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;
local g_uicmd = 0;

function NewbieCardActivation_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("NewUserCard_Check_Result");
end

function NewbieCardActivation_OnLoad()
end

function NewbieCardActivation_OnEvent(event)
	if (event == "UI_COMMAND" ) then
		if (tonumber(arg0) == 2004 or tonumber(arg0) == 20170430 or tonumber(arg0) == 20170431 or tonumber(arg0) == 20170432 or tonumber(arg0) == 20080819 or
			tonumber(arg0) == 2005 or tonumber(arg0) == 20181001 or tonumber(arg0) == 20181008 or tonumber(arg0) == 2007 or tonumber(arg0) == 2008 or tonumber(arg0) == 2007950) then
			--objCared = Get_XParam_INT(0);
			--objCared = Target:GetServerId2ClientId(objCared);
			NewUserCard_SetText(tonumber(arg0));
			--this:CareObject(objCared, 1, "NewUserCard");
			NewbieCardActivation_Input:SetProperty("DefaultEditBox", "True");
			this:Show();
			g_uicmd = tonumber(arg0);
		end
	elseif (event == "OBJECT_CARED_EVENT") then
		--AxTrace(0, 0, "arg0:"..arg0.." arg1:"..arg1.." arg2:"..arg2.." objCared:"..objCared);
		--if (tonumber(arg0) ~= objCared) then
		--	return;
		--end
		--�����NPC�ľ������һ��������߱�ɾ�����Զ��ر�
		--if (arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
		--	Guild_Create_Close();
		--end
		
	elseif (event == "NewUserCard_Check_Result")then
		local result = tonumber(arg0)
		if (tonumber(arg0)== 0) then
			NewUserCard_Close();
			return;
		end
		if (tonumber(arg0)== 1 or tonumber(arg0)== 2) then
			NewbieCardActivation_Input:SetProperty("DefaultEditBox", "True");
			NewbieCardActivation_Input:SetSelected( 0, -1 );
			return;
		end
	end
	
end

function NewUserCard_Open_Click()
	local cardNum = NewbieCardActivation_Input:GetText();
	if (0 == string.len(cardNum)) then
		return;
	end
	
	--'k' �Ƹ���
	--	if(string.byte(cardNum) == 116 and g_uicmd == 2004) then
	--		NewUserCard(cardNum);
	--'t' ������
	--	elseif(string.byte(cardNum) == 107 and g_uicmd == 2005) then
	--		NewUserCard(cardNum);
	--'s' ���ۿ�
	--	elseif(string.byte(cardNum) == 115 and g_uicmd == 2006) then
	--		NewUserCard(cardNum);
	--'w' �����ƹ㿨
	--	elseif(string.byte(cardNum) == 119 and g_uicmd == 2007) then
	--		NewUserCard(cardNum);
	--'q' ���뵰��
	--	elseif(string.byte(cardNum) == 113 and g_uicmd == 2008) then
	--		NewUserCard(cardNum);
	--'q' ̨�忨
	--	elseif(string.byte(cardNum) == 113 and g_uicmd == 2007950) then
	--		NewUserCard(cardNum);
	--	else
	--		PushDebugMessage("���Ų���ȷ������");
	--	end
	--NewUserCard_Close();
	
	if (g_uicmd == 20181001 ) then
		cardNum = tonumber(cardNum)
		local ccccs = string.len(cardNum)
	   if string.len(cardNum) ~= 11 then
			PushDebugMessage("�绰���벻��ȷ��������11λ����"..ccccs);
			return
	   end
	   
        local ccccb = string.sub(cardNum,1,1)
       if  ccccb ~="1" then 
		   PushDebugMessage("�绰���벻��ȷ������������"..ccccb);
		   return
	   end
       
       Set_XSCRIPT_Function_Name("XuKaJiHuo1")
	   Set_XSCRIPT_ScriptID(tonumber(999997))
	   Set_XSCRIPT_Parameter(0, tonumber(9999))
	   Set_XSCRIPT_Parameter(1, tonumber(string.sub(cardNum,1,4)))
	   Set_XSCRIPT_Parameter(2, tonumber(string.sub(cardNum,5,8)))
	   Set_XSCRIPT_Parameter(3, tonumber(string.sub(cardNum,9,11)))
	   Set_XSCRIPT_ParamCount(4);
	   Send_XSCRIPT();
	   return 
	end
	
	
	if (g_uicmd == 20181008 ) then
		Clear_XSCRIPT();   
		Set_XSCRIPT_Function_Name("XuKaJiHuo1")
		Set_XSCRIPT_ScriptID(tonumber(999997))
		Set_XSCRIPT_Parameter(0, tonumber(cardNum))
	    Set_XSCRIPT_Parameter(1, tonumber(-1))
		Set_XSCRIPT_ParamCount(2);
		Send_XSCRIPT();
		return
	end
	
	
	
	
	
	if (g_uicmd == 20170430 ) then
		if string.len(cardNum) ~= 8 then
			PushDebugMessage("���Ų���ȷ������");
			return
		end
		local K1 = tonumber(string.byte(string.sub(cardNum,1,1)))
		local K2 = tonumber(string.byte(string.sub(cardNum,2,2)))
		if K1 ~= 76 or K2 ~= 89 then
			PushDebugMessage("���Ų���ȷ������");
			return
		end
		Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("XuKaJiHuo1")
		Set_XSCRIPT_ScriptID(tonumber(999997))
		Set_XSCRIPT_Parameter(0, tonumber(string.byte(string.sub(cardNum,3,3))))
		Set_XSCRIPT_Parameter(1, tonumber(string.byte(string.sub(cardNum,4,4))))
		Set_XSCRIPT_Parameter(2, tonumber(string.byte(string.sub(cardNum,5,5))))
		Set_XSCRIPT_Parameter(3, tonumber(string.byte(string.sub(cardNum,6,6))))
		Set_XSCRIPT_Parameter(4, tonumber(string.byte(string.sub(cardNum,7,7))))
		Set_XSCRIPT_Parameter(5, tonumber(string.byte(string.sub(cardNum,8,8))))
		Set_XSCRIPT_ParamCount(6);
		Send_XSCRIPT();
		return
	end
	
	
	if (g_uicmd == 20170431 ) then
		if string.len(cardNum) ~= 8 then
			PushDebugMessage("���Ų���ȷ������");
			return
		end
		local K1 = tonumber(string.byte(string.sub(cardNum,1,1)))
		local K2 = tonumber(string.byte(string.sub(cardNum,2,2)))
		if K1 ~= 84 or K2 ~= 76 then
			PushDebugMessage("���Ų���ȷ������");
			return
		end
		Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("XuKaJiHuo2")
		Set_XSCRIPT_ScriptID(tonumber(999997))
		Set_XSCRIPT_Parameter(0, tonumber(string.byte(string.sub(cardNum,3,3))))
		Set_XSCRIPT_Parameter(1, tonumber(string.byte(string.sub(cardNum,4,4))))
		Set_XSCRIPT_Parameter(2, tonumber(string.byte(string.sub(cardNum,5,5))))
		Set_XSCRIPT_Parameter(3, tonumber(string.byte(string.sub(cardNum,6,6))))
		Set_XSCRIPT_Parameter(4, tonumber(string.byte(string.sub(cardNum,7,7))))
		Set_XSCRIPT_Parameter(5, tonumber(string.byte(string.sub(cardNum,8,8))))
		Set_XSCRIPT_ParamCount(6);
		Send_XSCRIPT();
		this:Hide()
		return
	end
	
	
	if (g_uicmd == 20170432 ) then
		if string.len(cardNum) ~= 8 then
			PushDebugMessage("���Ų���ȷ������");
			return
		end
		local K1 = tonumber(string.byte(string.sub(cardNum,1,1)))
		local K2 = tonumber(string.byte(string.sub(cardNum,2,2)))
		if K1 ~= 89 or K2 ~= 81 then
			PushDebugMessage("���Ų���ȷ������  ��һλ��"..K1.."   ��һλ��"..K2.."  ");
			return
		end
		Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("XuKaJiHuo2")
		Set_XSCRIPT_ScriptID(tonumber(999997))
		Set_XSCRIPT_Parameter(0, tonumber(string.byte(string.sub(cardNum,3,3))))
		Set_XSCRIPT_Parameter(1, tonumber(string.byte(string.sub(cardNum,4,4))))
		Set_XSCRIPT_Parameter(2, tonumber(string.byte(string.sub(cardNum,5,5))))
		Set_XSCRIPT_Parameter(3, tonumber(string.byte(string.sub(cardNum,6,6))))
		Set_XSCRIPT_Parameter(4, tonumber(string.byte(string.sub(cardNum,7,7))))
		Set_XSCRIPT_Parameter(5, tonumber(string.byte(string.sub(cardNum,8,8))))
		Set_XSCRIPT_ParamCount(6);
		Send_XSCRIPT();
		return
	end
	
	--�ж����ֿ�558��666�������Ƿ���Ч
	local firstbyte = string.byte(cardNum)
	--PushDebugMessage(firstbyte..111111);
	if (g_uicmd == 2006 and (firstbyte == 116 or firstbyte == 99 or firstbyte ==67 or firstbyte ==83 or firstbyte == 84  or firstbyte == 115)) then
		PushDebugMessage("#{CFK_081027_2}");
		return;
	end
	
	if (g_uicmd == 2004 and (firstbyte ==83 or firstbyte == 84)) then
		PushDebugMessage("#{CFK_081027_1}");
		return;
	end
	
	if (g_uicmd == 20080819 and firstbyte == 67) then
		PushDebugMessage("#{CFK_081027_1}");
		return;
	end
	
	if(g_uicmd == 2004 and firstbyte ~= 116 and firstbyte ~= 115 ) then     --588�Ƹ���'t','s''T','S'
		PushDebugMessage("#{CFK_081027_2}");
		return;
	elseif(g_uicmd == 20080819 and firstbyte ~= 99) then --666�Ƹ���'c','C'
		PushDebugMessage("#{CFK_081027_2}");
		return;
	end
	
	NewUserCard(cardNum);
end

function NewUserCard_Close()
	this:Hide();
	this:CareObject(objCared, 0, "NewUserCard");
	g_uicmd = 0;
end

function NewUserCard_SetText(uicmd)

	if uicmd == 2004 then
		NewbieCardActivation_DragTitle:SetText("#{INTERFACE_XML_73}");
		NewbieCardActivation_Text:SetText("#{INTERFACE_XML_536}");
	elseif uicmd == 20170430 then
		NewbieCardActivation_DragTitle:SetText("#Y�����˲���ʥ������");
		NewbieCardActivation_Text:SetText("���ڿ������������˲���ʥ��CD-key���к�");
	elseif uicmd == 20170431 then
		NewbieCardActivation_DragTitle:SetText("#Y�����˲�CDK����");
		NewbieCardActivation_Text:SetText("#Y�һ�["..Get_XParam_STR(0).."]  #Y����CDK");
	elseif uicmd == 20170432 then
		NewbieCardActivation_DragTitle:SetText("#Y�����˲����뿨����");
		NewbieCardActivation_Text:SetText("���ڿ������������˲����뿨CD-key���к�");
	elseif uicmd == 20080819 then--666�Ƹ���
		NewbieCardActivation_DragTitle:SetText("#{INTERFACE_XML_73}");
		NewbieCardActivation_Text:SetText("#{INTERFACE_XML_536}");
	elseif uicmd == 2005 then
		NewbieCardActivation_DragTitle:SetText("����");
		NewbieCardActivation_Text:SetText("������������������������õ�CD-Key");
	elseif uicmd == 2006 then
		NewbieCardActivation_DragTitle:SetText("#{CJ_20080321_01}");
		NewbieCardActivation_Text:SetText("#{CJ_20080321_02}");
	elseif uicmd == 2007 then
		NewbieCardActivation_DragTitle:SetText("����");
		NewbieCardActivation_Text:SetText("������������������������õ�CD-Key");
	elseif uicmd == 2008 then
		NewbieCardActivation_DragTitle:SetText("����");
		NewbieCardActivation_Text:SetText("������������������������õ�CD-Key");
	elseif uicmd == 20181001 then	
		NewbieCardActivation_DragTitle:SetText("�绰��");
		NewbieCardActivation_Text:SetText("�����������������������ĵ绰���루Ψһ��");
	elseif uicmd == 2007950 then
		NewbieCardActivation_DragTitle:SetText("#{CB_XUBAO_LINGQU_2}");
		NewbieCardActivation_Text:SetText("#{CB_XUBAO_LINGQU_3}");
	elseif uicmd == 20181008 then
		NewbieCardActivation_DragTitle:SetText("#{CB_XUBAO_LINGQU_2}");
		NewbieCardActivation_Text:SetText("#{CB_XUBAO_LINGQU_3}");	
	end
	
	
	NewbieCardActivation_Input:SetText("");
end