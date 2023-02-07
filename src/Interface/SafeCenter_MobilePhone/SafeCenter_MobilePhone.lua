local g_SafeCenter_MobilePhone_Frame_UnifiedPosition;
local g_SafeCenter_MobilePhone_SecurityCodeTime = 0;

--===============================================
-- PreLoad
--===============================================
function SafeCenter_MobilePhone_PreLoad()
	--��������
	this:RegisterEvent("OPEN_SAFECENTER_MOBILEPHONE");
	this:RegisterEvent("MOBILEAPPROVE_SECURITYCODE")
	this:RegisterEvent("MOBILEAPPROVE_APPROVE")
	this:RegisterEvent("MOBILEAPPROVE_GETPRIZE")
	-- ��Ϸ���ڳߴ緢���˱仯
	this:RegisterEvent("ADJEST_UI_POS")
	-- ��Ϸ�ֱ��ʷ����˱仯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")	
end

--===============================================
-- OnLoad
--===============================================
function SafeCenter_MobilePhone_OnLoad()
  g_SafeCenter_MobilePhone_Frame_UnifiedPosition=SafeCenter_MobilePhone_Frame:GetProperty("UnifiedPosition");	
end

--===============================================
-- OnEvent
--===============================================
function SafeCenter_MobilePhone_OnEvent(event)

	if ( event == "OPEN_SAFECENTER_MOBILEPHONE") then
		if( this:IsVisible() ) then
			return
		else
			SafeCenter_MobilePhone_Show(0);
		end
	--�ֻ���֤-��ȡ��֤��
	elseif (event == "MOBILEAPPROVE_SECURITYCODE" ) then
		if ( tonumber(arg0) == 1 ) then
			PushDebugMessage("#{SJRZ_180827_16}");
			SafeCenter_MobilePhone_Show(1);
		else
			SafeCenter_MobilePhone_SecurityCode_Msg(tonumber(arg1));
		end		
	
	--�ֻ���֤-��֤
	elseif (event == "MOBILEAPPROVE_APPROVE" ) then
		if ( tonumber(arg0) == 1 ) then
			PushDebugMessage("#{SJRZ_180827_24}");
			SafeCenter_MobilePhone_Show(0);
		else
			PushDebugMessage("#{SJRZ_180827_18}");
		end
	
	--�ֻ���֤-�콱
	elseif (event == "MOBILEAPPROVE_GETPRIZE" ) then
		if ( tonumber(arg0) == 1 ) then
			SafeCenter_MobilePhone_Show(0);
		end
	end

	-- ��Ϸ���ڳߴ緢���˱仯
	if (event == "ADJEST_UI_POS" ) then
		SafeCenter_MobilePhone_Frame_On_ResetPos()
	-- ��Ϸ�ֱ��ʷ����˱仯
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		SafeCenter_MobilePhone_Frame_On_ResetPos()
	end			
end

--��ʾ�ֻ���֤��������
function SafeCenter_MobilePhone_Show( bUpdate )
	
	--MOBILEAPPROVE_STATUS_NOT_BIND	= 0,	// δ���ֻ�
	--MOBILEAPPROVE_STATUS_BIND		= 1,	// ���ֻ���δ��֤
	--MOBILEAPPROVE_STATUS_APPROVED	= 2,	// ����֤��δ�콱
	--MOBILEAPPROVE_STATUS_GETPRIZE	= 3,	// ����֤�����콱
	local nMobileApproveStatus = DataPool:GetMobileApproveStatus();
	
	local theAction = DataPool:CreateActionItemForShow(39920093, 1)
	
	SafeCenter_Bindingphone_BackgroundDown_Frame:Hide();
	SafeCenter_MobilePhone_BackgroundDown_Frame:Hide();
	SafeCenter_AuthenticationPhone_BackgroundDown_Frame:Hide();
				
	if nMobileApproveStatus == 0 then		--δ���ֻ�
		
		if theAction:GetID() ~= 0 then		
			SafeCenter_Bindingphone_ItemA_1:SetActionItem(theAction:GetID());
		end
		SafeCenter_Bindingphone_BackgroundDown_Frame:Show();
		
	elseif nMobileApproveStatus == 1 then	--��Ҫ��֤�ֻ�
		
		if theAction:GetID() ~= 0 then		
			SafeCenter_MobilePhone_ItemA_1:SetActionItem(theAction:GetID());
		end
		
		local szPhoneNumber = DataPool:GetMobilePhoneNumber();
		SafeCenter_MobilePhone_Frame3_Lace2_Text1:SetText(szPhoneNumber);
		
		if bUpdate == 0 then
			SafeCenter_MobilePhone_Frame3_Button1:SetText("#{SJRZ_180827_07}");
			SafeCenter_MobilePhone_Frame3_Button1:Show();
			
			local szText = SafeCenter_MobilePhone_Edit1:GetText();
			if szText == nil or szText == "" then
				SafeCenter_MobilePhone_Edit1:SetProperty("MaxTextLength", "20")
				SafeCenter_MobilePhone_Edit1:SetText("�����������֤��");
			end		
		end
				
		SafeCenter_MobilePhone_BackgroundDown_Frame:Show();
	
	else  --����֤�ֻ�
		SafeCenter_AuthenticationPhone_BackgroundDown_Frame:Show();
		if theAction:GetID() ~= 0 then		
			SafeCenter_AuthenticationPhone_ItemA_1:SetActionItem(theAction:GetID());
		end
				
		if nMobileApproveStatus == 2 then	--���콱
			SafeCenter_AuthenticationPhone_Frame3_Lace2_Text1:SetText("#{SJRZ_180827_25}");
			SafeCenter_AuthenticationPhone_ItemA_1_Mask:Hide();
			PlayerFrame_Authenticationphone_tips:Show();
		else
			SafeCenter_AuthenticationPhone_Frame3_Lace2_Text1:SetText("#{SJRZ_180827_26}");
			SafeCenter_AuthenticationPhone_ItemA_1_Mask:Show();
			PlayerFrame_Authenticationphone_tips:Hide();
		end
	end
	
	this:Show()
	
end

-- ��֤���ֻ�
function SafeCenter_Bindingphone_OnClicked()
	local nMobileApproveStatus = DataPool:GetMobileApproveStatus();
	if nMobileApproveStatus == 0 then				--δ���ֻ�
		if GameProduceLogin:IsWeGameClient() > 0 then
			GameProduceLogin:OpenURL(GetWeblink("WEB_WEGAME_SJRZ"))
		else
			GameProduceLogin:OpenURL(GetWeblink("WEB_SJRZ"))
		end
	end
end

-- ��ȡ������֤��
function SafeCenter_MobilePhone_OnClicked()
	local nMobileApproveStatus = DataPool:GetMobileApproveStatus();
	if nMobileApproveStatus == 0 then   --δ��״̬
		PushDebugMessage("#{SJRZ_180827_13}")
		return
	end
	if nMobileApproveStatus > 1 then 	--����֤
		PushDebugMessage("#{SJRZ_180827_14}")
		return
	end
	
	DataPool:GetMobileApproveSecurityCode()
	
	SafeCenter_MobilePhone_Edit1:SetProperty("DefaultEditBox", "True");
	SafeCenter_MobilePhone_InputCode_OnActived();
	SafeCenter_MobilePhone_Frame3_Button1:Disable();
	g_SafeCenter_MobilePhone_SecurityCodeTime = 60;
	SafeCenter_MobilePhone_ApproveTimerProc();
	KillTimer( "SafeCenter_MobilePhone_ApproveTimerProc()" );
	SetTimer("SafeCenter_MobilePhone","SafeCenter_MobilePhone_ApproveTimerProc()", 1000)
end

--��֤
function SafeCenter_MobilePhone_Approve_OnClicked()
	local nMobileApproveStatus = DataPool:GetMobileApproveStatus();
	if nMobileApproveStatus == 0 then   --δ��״̬
		PushDebugMessage("#{SJRZ_180827_13}")
		return
	end
	if nMobileApproveStatus > 1 then 	--����֤
		PushDebugMessage("#{SJRZ_180827_14}")
		return
	end
		
	local szText = SafeCenter_MobilePhone_Edit1:GetText();
	local nCode = tonumber(szText);
	if nCode == nil then
		PushDebugMessage("#{SJRZ_180827_17}")
		return
	end
	DataPool:DoMobileApprove( tostring(szText) )
	
end

--�콱
function SafeCenter_AuthenticationPhone_GetPrize_Clicked()
	local nMobileApproveStatus = DataPool:GetMobileApproveStatus();
	if nMobileApproveStatus == 0 then   --δ��״̬
		PushDebugMessage("#{SJRZ_180827_19}")
		return
	end
	if nMobileApproveStatus == 1 then 	--δ��֤
		PushDebugMessage("#{SJRZ_180827_20}")
		return
	end
	if nMobileApproveStatus == 3 then 	--���콱
		PushDebugMessage("#{SJRZ_180827_21}")
		return
	end
	
	DataPool:GetMobileApprovePrize()
	
end

function SafeCenter_MobilePhone_InputCode_OnActived()
	local szText = SafeCenter_MobilePhone_Edit1:GetText();
	if tonumber(szText) == nil then
		SafeCenter_MobilePhone_Edit1:SetText("");
		SafeCenter_MobilePhone_Edit1:SetProperty("MaxTextLength", "6")
	end
end

function SafeCenter_MobilePhone_ApproveTimerProc()
	local strBtnText = ScriptGlobal_Format( "#{SJRZ_180827_08}", g_SafeCenter_MobilePhone_SecurityCodeTime )
	g_SafeCenter_MobilePhone_SecurityCodeTime = g_SafeCenter_MobilePhone_SecurityCodeTime -1;
	if g_SafeCenter_MobilePhone_SecurityCodeTime < 0 then
		SafeCenter_MobilePhone_Frame3_Button1:SetText( "#{SJRZ_180827_07}" )
		SafeCenter_MobilePhone_Frame3_Button1:Enable();
		KillTimer( "SafeCenter_MobilePhone_ApproveTimerProc()" );
		return
	end
	SafeCenter_MobilePhone_Frame3_Button1:SetText( strBtnText )
end

function SafeCenter_MobilePhone_SecurityCode_Msg( nErrCode )

	if nErrCode == 6 then		--һ��50�γ�����
		PushDebugMessage( "#{SJRZ_180827_29}");
	elseif nErrCode == 88 then --������ŷ��͹��ܱ��ر�
		PushDebugMessage( "#{SJRZ_180827_30}")
	elseif nErrCode == 90 then --�ֻ��Ŵ��ں�����
		PushDebugMessage( "#{SJRZ_180827_31}")
	elseif nErrCode == 98 then --������IP���ڰ������л��߷��Ͷ��ŵ�IP����
		PushDebugMessage( "#{SJRZ_180827_32}")
	else
		local strMsg =	ScriptGlobal_Format( "#{SJRZ_180827_28}", nErrCode)	
		PushDebugMessage(strMsg);
	end
	
end

function SafeCenter_MobilePhone_OnHidden()
	KillTimer( "SafeCenter_MobilePhone_ApproveTimerProc()" );
	SafeCenter_Bindingphone_ItemA_1:SetActionItem(-1);
	SafeCenter_MobilePhone_ItemA_1:SetActionItem(-1);
	SafeCenter_AuthenticationPhone_ItemA_1:SetActionItem(-1);
end

--================================================
-- �ָ������Ĭ�����λ��
--================================================
function SafeCenter_MobilePhone_Frame_On_ResetPos()
  SafeCenter_MobilePhone_Frame:SetProperty("UnifiedPosition", g_SafeCenter_MobilePhone_Frame_UnifiedPosition);
end
