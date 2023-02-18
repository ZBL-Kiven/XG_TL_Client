local	campaign_today = 0	--当天所有活动
local	campaign_curDaily = 1	--目前日常活动
local	campaign_other	=2	--当天所有其他活动
local	campaign_daily	=3	--当天所有日常活动
local g_AllCampaignDetailDescs = {};	-- 所有活动的详细描述信息列表
function TodayCampaignList_PreLoad()
	this:RegisterEvent("SHOW_TODAY_CAMPAIGN_LIST")
end

function TodayCampaignList_OnLoad()
	
end
-- 鼠标点击具体活动后的相应函数
function TodayCampaignList_List_OnSelectionChanged()

	-- 清除刚才选择的活动信息
	TodayCampaignList_DetailDesc:ClearAllElement();		-- 清除活动描述信息
	
	local nSel = TodayCampaignList_ListCtl:GetSelectItem();	-- 当前选择的行号 (0 ~ g_TodalCampaignCount-1)
	-- TodayCampaignList_TrackButtonState();
	-- 显示当前选中的活动信息	
	if (g_AllCampaignDetailDescs[nSel+1] ~= nil) then
		TodayCampaignList_DetailDesc:AddTextElement(tostring(g_AllCampaignDetailDescs[nSel+1]));
	end
	TodayCampaignList_DetailDesc:Show();	
end

-- OnEvent
function TodayCampaignList_OnEvent(event)
	if ( event == "SHOW_TODAY_CAMPAIGN_LIST" ) then
		this:TogleShow();
		TodayCampaignList_Init()
	end
end

function TodayCampaignList_Init()
	TodayCampaignList_ListCtl:RemoveAllItem();
	local nNum = GetCampaignCount(tonumber(campaign_today));

	for i=0 , nNum-1 do
		local strTime = "";
		local strEnd = EnumCampaign(tonumber(campaign_today),i,"endtime");
		if(strEnd ~= -1) then
			strTime = EnumCampaign(tonumber(campaign_today),i,"starttime").."--"..strEnd;
		else
			strTime = EnumCampaign(tonumber(campaign_today),i,"starttime");
		end
		local strHuodong = EnumCampaign(tonumber(campaign_today),i,"name");
		
		local strDesc = EnumCampaign(tonumber(campaign_today),i,"desc");
		-- local ends = EnumCampaign(tonumber(campaign_today),i,"addtiondesc");
		-- 详细活动描述
		local strDetailDesc = EnumCampaign(tonumber(campaign_today),i,"icon");
		
		-- if(ends and ends~="")then
			-- strDesc = strDesc.."、"..ends;
		-- end
		AxTrace( 5,3, strDesc );
		local isCur  =  EnumCampaign(tonumber(campaign_today),i,"iscurcampaign");
		if(tonumber(isCur) == 1)then
			strTime = "#G" .. strTime;
			strHuodong = "#G" .. strHuodong;
			strDesc = "#G" .. strDesc;
		else
			local isDaliy  =  EnumCampaign(tonumber(campaign_today),i,"timetype");
			if(tonumber(isDaliy) == 1)then
				strTime = "#W" .. strTime;
				strHuodong = "#W" .. strHuodong;
				strDesc = "#W" .. strDesc;
			else
				strTime = "#Y" .. strTime;
				strHuodong = "#Y" .. strHuodong;
				strDesc = "#Y" .. strDesc;			
			end			
		end
		g_AllCampaignDetailDescs[i+1] = strDetailDesc;		-- 记录当前活动的详细描述信息
		TodayCampaignList_ListCtl:AddNewItem(strTime, 0, i);
		TodayCampaignList_ListCtl:AddNewItem(strHuodong, 1, i);
		TodayCampaignList_ListCtl:AddNewItem(strDesc, 2, i);	
	end
end