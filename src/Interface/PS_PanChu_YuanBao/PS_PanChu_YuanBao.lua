-- Ĭ��ѡ��ʽ
local g_SelectType = -1

-- �̳���ʽ
local SALETYPE_MONEY = 0
local SALETYPE_YUANBAO = 1

-- �����Ĭ�����λ��
local g_PS_PanChu_YuanBao_Frame_UnifiedXPosition
local g_PS_PanChu_YuanBao_Frame_UnifiedYPosition

-- npc��ע
local objCared = -1
local MAX_OBJ_DISTANCE = 3.0

--===============================================
-- PreLoad()
--===============================================
function PS_PanChu_YuanBao_PreLoad()
	this:RegisterEvent("PLAYERSHOP_PANCHU_INPUT_OPEN")
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("OBJECT_CARED_EVENT",false)
	this:RegisterEvent("PLAYERSHOP_PANCHU_INPUT_CLOSE")
	this:RegisterEvent("PS_CLOSE_SHOP_MAG")
end

--===============================================
-- OnLoad()
--===============================================
function PS_PanChu_YuanBao_OnLoad()
	-- ��������Ĭ�����λ��
	g_PS_PanChu_YuanBao_Frame_UnifiedXPosition	= PS_PanChu_YuanBao_Frame : GetProperty("UnifiedXPosition")
	g_PS_PanChu_YuanBao_Frame_UnifiedYPosition	= PS_PanChu_YuanBao_Frame : GetProperty("UnifiedYPosition")
end

--===============================================
-- OnEvent
--===============================================
function PS_PanChu_YuanBao_OnEvent(event)
	-- �򿪽���
	if(event == "PLAYERSHOP_PANCHU_INPUT_OPEN") then
		this:Show()			
		-- npc��ע
		objCared = PlayerShop:GetNpcId()
		this:CareObject(objCared, 1, "PS_PanChu_YuanBao")
		-- ���ý���
		PS_PanChu_YuanBao_ChangeMode(SALETYPE_MONEY)--Ĭ�Ͻ���̳���ʽ
	end
	
	-- ��Ϸ���ڳߴ緢���˱仯
	if (event == "ADJEST_UI_POS" ) then
		PS_PanChu_YuanBao_ResetPos()
	end
	
	-- ��Ϸ�ֱ��ʷ����˱仯
	if (event == "VIEW_RESOLUTION_CHANGED") then
		PS_PanChu_YuanBao_ResetPos()
	end
	
	-- �뿪npc�رս���
	if ( event == "OBJECT_CARED_EVENT" )   then
		if(tonumber(arg0) ~= objCared) then
			return
		end		
		-- �����NPC�ľ������һ��������߱�ɾ�����Զ��ر�
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			PS_PanChu_YuanBao_OnHiden()
		end	
	end
	
	-- �رս���
	if( event == "PLAYERSHOP_PANCHU_INPUT_CLOSE")	 then
		PS_PanChu_YuanBao_OnHiden()
	end
	
	-- �رս���
	if( event == "PS_CLOSE_SHOP_MAG")	 then
		PS_PanChu_YuanBao_OnHiden()
	end

end

--===============================================
-- ����
--===============================================
function PS_PanChu_YuanBao_OnHiden()
	--��������
	g_SelectType = -1
	--�ؼ����
	PS_PanChu_YuanBao_Clear()
	--��������
	this:Hide()
	--ȡ������
	this:CareObject(objCared, 0, "PS_PanChu_YuanBao")
end

--================================================
-- �ָ������Ĭ�����λ��
--================================================
function PS_PanChu_YuanBao_ResetPos()
	PS_PanChu_YuanBao_Frame : SetProperty("UnifiedXPosition", g_PS_PanChu_YuanBao_Frame_UnifiedXPosition)
	PS_PanChu_YuanBao_Frame : SetProperty("UnifiedYPosition", g_PS_PanChu_YuanBao_Frame_UnifiedYPosition)
end

--===============================================
-- ���
--===============================================
function PS_PanChu_YuanBao_Clear()
	--�����������
	PS_PanChu_YuanBao_Gold:SetText("")
	PS_PanChu_YuanBao_Silver:SetText("")
	PS_PanChu_YuanBao_CopperCoin:SetText("")
	PS_PanChu_YuanBao_InputYuanBao:SetText("")
	--���Ĭ��λ��
	PS_PanChu_YuanBao_Gold:SetProperty("DefaultEditBox", "False")
	PS_PanChu_YuanBao_Silver:SetProperty("DefaultEditBox", "False")	
	PS_PanChu_YuanBao_CopperCoin:SetProperty("DefaultEditBox", "False")
	PS_PanChu_YuanBao_InputYuanBao:SetProperty("DefaultEditBox", "False")	
	--ȷ�ϰ�ťĬ�Ͻ���
	PS_PanChu_YuanBao_Accept:Disable()	
end

--===============================================
-- ȷ��
--===============================================
function PS_PanChu_YuanBao_Accept_Clicked()
	--�������
	if g_SelectType ~= SALETYPE_MONEY and g_SelectType ~= SALETYPE_YUANBAO then
		return
	end

	--����̳�
	if g_SelectType == SALETYPE_MONEY then
		local szGold = PS_PanChu_YuanBao_Gold:GetText()
		local szSilver = PS_PanChu_YuanBao_Silver:GetText()
		local szCopperCoin = PS_PanChu_YuanBao_CopperCoin:GetText()
		--�ڳ�����ͷ�ټ�������ַ�����Ч�Ժ���ֵ
		local bAvailability,nMoney = Bank:GetInputMoney(szGold,szSilver,szCopperCoin)		
		--ʲô�����ʧ����Ҫ�ٶ�
		if(bAvailability == true) then
			--���벻�Ϸ�
			if (tonumber(nMoney) < 1) then
				PS_PanChu_YuanBao_Gold:SetText("")
				PS_PanChu_YuanBao_Silver:SetText("")
				PS_PanChu_YuanBao_CopperCoin:SetText("")
				PS_PanChu_YuanBao_Gold:SetProperty("DefaultEditBox", "True")
				PushDebugMessage("�̳��̵�۸���С��1ͭ������������")
				return
			elseif (tonumber(nMoney) > 100000000) then
				PS_PanChu_YuanBao_Gold:SetText("")
				PS_PanChu_YuanBao_Silver:SetText("")
				PS_PanChu_YuanBao_CopperCoin:SetText("")
				PS_PanChu_YuanBao_Gold:SetProperty("DefaultEditBox", "True")
				PushDebugMessage("�̳��̵�۸��ܳ���10000������������")
				return
			end
			--ȷ���̳�
			PlayerShop:Transfer("info", "sale", nMoney, g_SelectType)
			--�رս���
			PS_PanChu_YuanBao_OnHiden()
		end
	elseif g_SelectType == SALETYPE_YUANBAO then
		local szYuanbao = PS_PanChu_YuanBao_InputYuanBao:GetText()
		--���벻�Ϸ�
		if (tonumber(szYuanbao) < 1) then
			PS_PanChu_YuanBao_InputYuanBao:SetText("")
			PS_PanChu_YuanBao_InputYuanBao:SetProperty("DefaultEditBox", "True")		
			PushDebugMessage("�̳��̵�۸���С��1Ԫ��������������")
			return
		elseif (tonumber(szYuanbao) > 100000) then
			PS_PanChu_YuanBao_InputYuanBao:SetText("")
			PS_PanChu_YuanBao_InputYuanBao:SetProperty("DefaultEditBox", "True")		
			PushDebugMessage("�̳��̵�۸��ܳ���100000Ԫ��������������")
			return
		end
		--ȷ���̳�
		PlayerShop:Transfer("info", "sale", tonumber(szYuanbao), g_SelectType)
		--�رս���
		PS_PanChu_YuanBao_OnHiden()		
	end
end

--===============================================
-- ȡ��
--===============================================
function PS_PanChu_YuanBao_Cancel_Clicked()
	PS_PanChu_YuanBao_OnHiden();
end

--===============================================
-- ����ı�
--===============================================
function PS_PanChu_YuanBao_ChangeMoney()	
	--����̳�
	if g_SelectType == SALETYPE_MONEY then
		local szGold = PS_PanChu_YuanBao_Gold:GetText()
		local szSilver = PS_PanChu_YuanBao_Silver:GetText()
		local szCopperCoin = PS_PanChu_YuanBao_CopperCoin:GetText()		
		if szGold == "" and szSilver == "" and szCopperCoin == "" then
			PS_PanChu_YuanBao_Accept:Disable()
		else
			PS_PanChu_YuanBao_Accept:Enable()
		end
	--Ԫ���̳�
	elseif g_SelectType == SALETYPE_YUANBAO then
		local szYuanbao = PS_PanChu_YuanBao_InputYuanBao:GetText()	
		if szYuanbao == "" then
			PS_PanChu_YuanBao_Accept:Disable()
		else
			PS_PanChu_YuanBao_Accept:Enable()
		end
	end
end

--===============================================
-- ѡ��ı�
--===============================================
function PS_PanChu_YuanBao_ChangeMode(type)
	--�������
	if type ~= SALETYPE_MONEY and type ~= SALETYPE_YUANBAO then
		return
	end
	
	--ģʽ����
	if g_SelectType == type then
		return
	end
	g_SelectType = type
	
	--�ؼ����
	PS_PanChu_YuanBao_Clear()
		
	--״̬�޸�
	if g_SelectType == SALETYPE_MONEY then
		--��ѡ��ť
		PS_PanChu_YuanBao_YuanBao:SetCheck(0)
		PS_PanChu_YuanBao_Money:SetCheck(1)

		PS_PanChu_YuanBao_Gold:SetText("")
		PS_PanChu_YuanBao_Silver:SetText("")
		PS_PanChu_YuanBao_CopperCoin:SetText("")
		PS_PanChu_YuanBao_InputYuanBao:SetText("")
		--���Ĭ��λ��
		PS_PanChu_YuanBao_Gold:SetProperty("DefaultEditBox", "True")		
	elseif g_SelectType == SALETYPE_YUANBAO then
		--��ѡ��ť
		PS_PanChu_YuanBao_Money:SetCheck(0)
		PS_PanChu_YuanBao_YuanBao:SetCheck(1)

		PS_PanChu_YuanBao_Gold:SetText("")
		PS_PanChu_YuanBao_Silver:SetText("")
		PS_PanChu_YuanBao_CopperCoin:SetText("")
		PS_PanChu_YuanBao_InputYuanBao:SetText("")
		--���Ĭ��λ��
		PS_PanChu_YuanBao_InputYuanBao:SetProperty("DefaultEditBox", "True")
	end
end
