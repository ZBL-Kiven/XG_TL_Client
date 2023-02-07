-- ת������֪����--����ȷ�Ͽ�
-- build 2019-8-10 18:06:05 ��ң��
local g_Frame_UnifiedXPosition
local g_Frame_UnifiedYPosition
local g_menpaiId = -1
local g_targetId = -1
local g_switch = -1

--===============================================
-- PreLoad()
--===============================================
function ModifyMenPai_MessageBox_PreLoad()

	--��ʾ��������
	this:RegisterEvent("UI_COMMAND",true)	
	-- ��Ϸ���ڳߴ緢���˱仯
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- ��Ϸ�ֱ��ʷ����˱仯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)	
	
end

--===============================================
-- OnLoad()
--===============================================
function ModifyMenPai_MessageBox_OnLoad()

	g_Frame_UnifiedXPosition	= ModifyMenPai_MessageBox_Frame:GetProperty("UnifiedXPosition")
	g_Frame_UnifiedYPosition	= ModifyMenPai_MessageBox_Frame:GetProperty("UnifiedYPosition")	
	
end

--===============================================
-- OnEvent()
--===============================================
function ModifyMenPai_MessageBox_OnEvent(event)

	if (event == "UI_COMMAND" and tonumber(arg0) == 2115) then
		g_switch = Get_XParam_INT(0)
		if g_switch == 44 then
			local strMsg = Get_XParam_STR(0)
			g_targetId = Get_XParam_INT(1)
			g_menpaiId = Get_XParam_INT(2)
			ModifyMenPai_MessageBox_Info:SetText(strMsg)
			
      local g_objCared = DataPool : GetNPCIDByServerID(tonumber(g_targetId))
      this:CareObject(g_objCared, 1, "ModifyMenPai_MessageBox");
      if (this:IsVisible()) then  
      	return
      end
            
			this:Show();
		end
		if g_switch == 6 then
			local strMsg = Get_XParam_STR(0)
			g_targetId = Get_XParam_INT(1)
			g_menpaiId = Get_XParam_INT(2)
			ModifyMenPai_MessageBox_Info:SetText(strMsg)
			
      local g_objCared = DataPool : GetNPCIDByServerID(tonumber(g_targetId))
      this:CareObject(g_objCared, 1, "ModifyMenPai_MessageBox");
      if (this:IsVisible()) then  
      	return
      end
            
			this:Show();
		end
	elseif( event == "ADJEST_UI_POS" ) then
		ModifyMenPai_MessageBox_Frame_On_ResetPos()
	elseif( event == "VIEW_RESOLUTION_CHANGED" ) then
		ModifyMenPai_MessageBox_Frame_On_ResetPos()
	end
	
end

--===============================================
-- ȷ��
--===============================================
function ModifyMenPai_MessageBox_OK_Clicked()

	-- ����һ����
	if g_switch == 44 then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("OnConfirmSwitch")
			Set_XSCRIPT_ScriptID(900030)
			Set_XSCRIPT_Parameter(0, g_targetId) 
			Set_XSCRIPT_Parameter(1, g_menpaiId) 
			Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT()	
	elseif g_switch == 6 then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "OnRegretContinueSwitch" );
			Set_XSCRIPT_ScriptID(900030);
			Set_XSCRIPT_Parameter(0, g_targetId);
			Set_XSCRIPT_ParamCount(1);
		Send_XSCRIPT()
	end
	
	-- �رյ�ǰ����
	ModifyMenPai_MessageBox_Cancel_Clicked()
	
end

--===============================================
-- ȡ��
--===============================================
function ModifyMenPai_MessageBox_Cancel_Clicked()

	-- ���
	ModifyMenPai_MessageBox_Clear()
	
	-- ����
	this:Hide()
	
end

--===============================================
-- ���
--===============================================
function ModifyMenPai_MessageBox_Clear()

  g_targetId = -1
  g_menpaiId = -1
  
end

--================================================
-- �ָ������Ĭ�����λ��
--================================================
function ModifyMenPai_MessageBox_Frame_On_ResetPos()

	ModifyMenPai_MessageBox_Frame:SetProperty("UnifiedXPosition", g_Frame_UnifiedXPosition)
	ModifyMenPai_MessageBox_Frame:SetProperty("UnifiedYPosition", g_Frame_UnifiedYPosition)
	
end

