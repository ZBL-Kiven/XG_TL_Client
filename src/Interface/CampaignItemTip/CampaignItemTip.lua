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
--清空文本
function CampaignItemTip_ClearText( )
	CampaignItemTip_StaticPart_Title:SetText("") --道具名称
	CampaignItemTip_StaticPart_Icon:SetImage("") --道具图标
	CampaignItemTip_StaticPart_Item1:SetText("") --物品等级

	CampaignItemTip_StaticPart_Item2:SetText("") --使用等级
	CampaignItemTip_ShortDesc_Text:SetText("") --道具类型
	CampaignItemTip_StaticPart_Zhuangtai:SetText("") --绑定规则
	CampaignItemTip_StaticPart_Yuanbaojiaoyi:SetText("") --元宝交易
	CampaignItemTip_StaticPart_KvkSpecial:SetText("") --天方古境交易
	CampaignItemTip_Explain:SetText("") --道具说明
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
    --道具类型
	if explain ~= nil then
		toDisplay = toDisplay..";CampaignItemTip_ShortDesc"		
	end
	--绑定规则
	if takeBound ~= nil and takeBound ~= 0 then
		toDisplay = toDisplay..";CampaignItemTip_StaticPart_Zhuangtai"
	end
	--元宝交易
	if exchangeType ~= nil and exchangeType ~= 0 then
		toDisplay = toDisplay..";CampaignItemTip_StaticPart_Yuanbaojiaoyi"
	end
	--是否可在天荒古境交易
	if isExchange ~= nil and isExchange ~= 0 then
		toDisplay = toDisplay..";CampaignItemTip_StaticPart_KvkSpecial"
	end
	--道具说明
	if desc1 ~= nil then
		toDisplay = toDisplay..";CampaignItemTip_Explain"
	end

	--显示组件内容
	if(toDisplay=="") then
		this:Hide();
		return 0;
	end;

	_CampaignItemTip_:SetProperty("PageElements",  toDisplay);
	
	if title ~= nil and icon ~= nil then	
		--道具名
		CampaignItemTip_StaticPart_Title:SetText(title)
		CampaignItemTip_StaticPart_Title:Show()
		--图标
		CampaignItemTip_StaticPart_Icon:SetImage(icon)
		--物品等级
		CampaignItemTip_StaticPart_Item1:SetText("#{HDRCDJ_140701_01}"..tostring(level))
		--使用等级
		if useLevel ~= nil and useLevel ~= 0 then
			CampaignItemTip_StaticPart_Item2:SetText("#{HDRCDJ_140701_02}"..tostring(useLevel))
		end
	end
    --道具类型
	if explain ~= nil then
		CampaignItemTip_ShortDesc_Text:SetText(explain)		
	end
	--绑定规则
	if takeBound ~= nil and takeBound ~= 0 then
		if takeBound == 1 then
			CampaignItemTip_StaticPart_Zhuangtai:SetText("#{KPWFS_131112_76}") --#cccffff拾取时绑定
		elseif takeBound == 2 then
			CampaignItemTip_StaticPart_Zhuangtai:SetText("#{KPWFS_131112_77}") --#cccffff装备时绑定
		end
	end
	--元宝交易
	if exchangeType ~= nil and exchangeType ~= 0 then
		if exchangeType == 1 then
			CampaignItemTip_StaticPart_Yuanbaojiaoyi:SetText("#{YBSC_100111_87}")
		elseif exchangeType == 2 then
			CampaignItemTip_StaticPart_Yuanbaojiaoyi:SetText("#{YBSC_100111_88}")
		end
	end
	--是否可在天荒古境交易
	if isExchange ~= nil and isExchange ~= 0 then
		CampaignItemTip_StaticPart_KvkSpecial:SetText("#{KVKGZ_110620_08}")
	end
	--道具说明
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
