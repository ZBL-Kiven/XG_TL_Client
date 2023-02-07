--CampaignItemTip
local g_pos1;
local g_pos2;

local g_left , g_top , g_right , g_bottom

function CampaignItemTip_PreLoad(  )
	this:RegisterEvent("SHOW_SUPERTOOLTIP");
	this:RegisterEvent("CAMPAIGN_SHOW_ITEM_TIPS");
	--this:RegisterEvent("UPDATE_SUPERTOOLTIP")
end

function CampaignItemTip_OnLoad(  )
	g_left = 0;
	g_top  = 0;
	g_right = 0;
	g_bottom = 0;
end

function CampaignItemTip_OnEvent( event )

	if event == "SHOW_SUPERTOOLTIP" then
		local open = tonumber(arg0)
		if open == 0 then
			CampaignItemTip_OnHide()
		end
	end

	if event == "CAMPAIGN_SHOW_ITEM_TIPS" then
		if CampaignItemTip_Update() == 1 then
			g_pos1, g_pos2 = _CampaignItemTip_:PositionSelf(arg2, arg3, arg4, arg5);
			g_left = arg2;
			g_top  = arg3;
			g_right = arg4;
			g_bottom = arg5;
			this:Show()
		end
	end

	--if event == "UPDATE_SUPERTOOLTIP" and this:IsVisible() then
		--CampaignItemTip_Update();
	--end

end
--����ı�
function CampaignItemTip_ClearText( )
	CampaignItemTip_StaticPart_Title:SetText("") --��������
	CampaignItemTip_StaticPart_Icon:SetImage("") --����ͼ��
	CampaignItemTip_StaticPart_Item1:SetText("") --��Ʒ�ȼ�

	CampaignItemTip_StaticPart_Item2:SetText("") --ʹ�õȼ�
	CampaignItemTip_ShortDesc_Text:SetText("") --��������
	CampaignItemTip_StaticPart_Zhuangtai:SetText("") --�󶨹���
	CampaignItemTip_StaticPart_Yuanbaojiaoyi:SetText("") --Ԫ������
	CampaignItemTip_StaticPart_KvkSpecial:SetText("") --�췽�ž�����
	CampaignItemTip_Explain:SetText("") --����˵��
end

function CampaignItemTip_Update()
	CampaignItemTip_ClearText()
 
	local title, icon, desc1, explain, useLevel, level, takeBound, equipBound, exchangeType, isExchange 
	title, icon, desc1, explain, useLevel, level, takeBound, equipBound, exchangeType, isExchange = SuperTooltips:Campaign_GetItemData()
--	PushDebugMessage(icon)
	local toDisplay = ""

	if title ~= nil and icon ~= nil then
		toDisplay = toDisplay.."CampaignItemTip_PageHeader"
		toDisplay = toDisplay..";CampaignItemTip_StaticPart_Icon"	
	end
    --��������
	if explain ~= nil then
		toDisplay = toDisplay..";CampaignItemTip_ShortDesc"		
	end
	--�󶨹���
	if takeBound ~= nil and takeBound ~= 0 then
		toDisplay = toDisplay..";CampaignItemTip_StaticPart_Zhuangtai"
	end
	--Ԫ������
	if exchangeType ~= nil and exchangeType ~= 0 then
		toDisplay = toDisplay..";CampaignItemTip_StaticPart_Yuanbaojiaoyi"
	end
	--�Ƿ������Ĺž�����
	if isExchange ~= nil and isExchange ~= 0 then
		toDisplay = toDisplay..";CampaignItemTip_StaticPart_KvkSpecial"
	end
	--����˵��
	if desc1 ~= nil then
		toDisplay = toDisplay..";CampaignItemTip_Explain"
	end

	--��ʾ�������
	if(toDisplay=="") then
		this:Hide();
		return 0;
	end;

	_CampaignItemTip_:SetProperty("PageElements",  toDisplay);
	
	if title ~= nil and icon ~= nil then	
		--������
		CampaignItemTip_StaticPart_Title:SetText(title)
		CampaignItemTip_StaticPart_Title:Show()
		--ͼ��
		CampaignItemTip_StaticPart_Icon:SetImage(icon)
		--��Ʒ�ȼ�
		CampaignItemTip_StaticPart_Item1:SetText("#{HDRCDJ_140701_01}"..tostring(level))
		--ʹ�õȼ�
		if useLevel ~= nil and useLevel ~= 0 then
			CampaignItemTip_StaticPart_Item2:SetText("#{HDRCDJ_140701_02}"..tostring(useLevel))
		end
	end
    --��������
	if explain ~= nil then
		CampaignItemTip_ShortDesc_Text:SetText(explain)		
	end
	--�󶨹���
	if takeBound ~= nil and takeBound ~= 0 then
		if takeBound == 1 then
			CampaignItemTip_StaticPart_Zhuangtai:SetText("#{KPWFS_131112_76}") --#cccffffʰȡʱ��
		elseif takeBound == 2 then
			CampaignItemTip_StaticPart_Zhuangtai:SetText("#{KPWFS_131112_77}") --#cccffffװ��ʱ��
		end
	end
	--Ԫ������
	if exchangeType ~= nil and exchangeType ~= 0 then
		if exchangeType == 1 then
			CampaignItemTip_StaticPart_Yuanbaojiaoyi:SetText("#{YBSC_100111_87}")
		elseif exchangeType == 2 then
			CampaignItemTip_StaticPart_Yuanbaojiaoyi:SetText("#{YBSC_100111_88}")
		end
	end
	--�Ƿ������Ĺž�����
	if isExchange ~= nil and isExchange ~= 0 then
		CampaignItemTip_StaticPart_KvkSpecial:SetText("#{KVKGZ_110620_08}")
	end
	--����˵��
	if desc1 ~= nil then
		CampaignItemTip_Explain:SetText(desc1)
	end

	return 1
end

function CampaignItemTip_OnHide()
	g_left = 0;
	g_top  = 0;
	g_right = 0;
	g_bottom = 0;
	this:Hide();
end
