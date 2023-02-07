local FENPING_CUSTOM_BUTTONS = {};
local FENPING_CUSTOM_BUTTONS_NUM = 13;
local g_fenpinglastCity = -1;

local g_fenpingOpen = 0;

local g_ChannelSetFenping_Frame_UnifiedXPosition;
local g_ChannelSetFenping_Frame_UnifiedYPosition;
function ChannelSetFenping_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("ADJEST_UI_POS")

	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end
	
function ChannelSetFenping_OnLoad()
	FENPING_CUSTOM_BUTTONS[3] = ChannelSetFenping_WorldInfo;
	FENPING_CUSTOM_BUTTONS[1] = ChannelSetFenping_VicinityInfo;
	FENPING_CUSTOM_BUTTONS[4] = ChannelSetFenping_PersonalInfo;
	FENPING_CUSTOM_BUTTONS[8] = ChannelSetFenping_MenpaiInfo;
	FENPING_CUSTOM_BUTTONS[7] = ChannelSetFenping_CorporateInfo;
	FENPING_CUSTOM_BUTTONS[2] = ChannelSetFenping_TeamInfo;
	FENPING_CUSTOM_BUTTONS[9] = ChannelSetFenping_SelfInfo;
	FENPING_CUSTOM_BUTTONS[5] = ChannelSetFenping_SystemInfo;			--系统频道
	FENPING_CUSTOM_BUTTONS[6] = ChannelSetFenping_SelfInfo;				--自建频道（现在没有功能）
	FENPING_CUSTOM_BUTTONS[10] = ChannelSetFenping_HelpInfo;				--帮助频道
	FENPING_CUSTOM_BUTTONS[11] = ChannelSetFenping_Speaker;				--喇叭频道 2010-07-21 for:76725
	FENPING_CUSTOM_BUTTONS[12] = ChannelSetFenping_City;				--同城聊天
	FENPING_CUSTOM_BUTTONS[13] = ChannelSetFenping_GuildLeagueInfo;				--同盟聊天


	--填充城市信息
	ChannelSetFenping_ProvinceCity : ResetList();
	local num = DataPool : GetProvincesNum();
	if (num > 0) then
		for i = 0, num-1 do
			local _id,_name =DataPool : EnumProvinces(i);
			ChannelSetFenping_Province:ComboBoxAddItem(_name,_id);
		end
	end
	g_ChannelSetFenping_Frame_UnifiedXPosition	= ChannelSetFenping_Frame:GetProperty("UnifiedXPosition");
	g_ChannelSetFenping_Frame_UnifiedYPosition	= ChannelSetFenping_Frame:GetProperty("UnifiedYPosition");
end

function ChannelSetFenping_ComboListProvinceChanged(cIdx)
	local szName, nIndex = ChannelSetFenping_Province:GetCurrentSelect();
	if(nIndex and nIndex ~= -1 ) then
		ChannelSetFenping_ProvinceCity : ResetList();
		-- local num = DataPool : GetCityNumFromOneProvinceId(nIndex);
		-- if (num > 0) then
			-- for i = 0, num-1 do
				-- local _id,_name = DataPool : NumCityFromOneProvince(nIndex,i)
				ChannelSetFenping_ProvinceCity:ComboBoxAddItem("朝阳区",0);
			-- end
		-- end
		if(tonumber(cIdx) and tonumber(cIdx) > 0 and tonumber(cIdx) < num ) then	
			ChannelSetFenping_ProvinceCity:SetCurrentSelect(tonumber(cIdx));
		else
			ChannelSetFenping_ProvinceCity:SetCurrentSelect(0);
		end
	end
end

function ChannelSetFenping_OnEvent( event )
	if (event == "UI_COMMAND" and tonumber(arg0) == 20220912) then
		if this:IsVisible()  then
			this:Hide();
			return;
		end
		g_fenpingOpen = tonumber(arg1);
		ChannelSetFenping_FenPingAction(arg1,arg2);
	elseif (event == "ADJEST_UI_POS" ) then
		ChannelSetFenping_Frame_ResetPos()

	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		ChannelSetFenping_Frame_ResetPos()
	end
end

--isFenpingAlreadyOpen 分屏是否已经打开
--strCfg 分屏打开的情况下传过来分屏的设置信息
function ChannelSetFenping_FenPingAction( isFenpingAlreadyOpen ,strCfg)
	ChannelSetFenping_CC_BUTTON_Enable(12);
	-- 设置窗体名称
	if ( tonumber(isFenpingAlreadyOpen) == 0 ) then
		ChannelSetFenping_Destory:Hide();
		ChannelSetFenping_Create:Show();
		ChannelSetFenping_Accept:Hide();
		--默认分屏设置信息
		strCfg = '1111111111101';
	else
		ChannelSetFenping_Destory:Show();
		ChannelSetFenping_Create:Hide();
		ChannelSetFenping_Accept:Show();
	end
	local ipRegion = Player:GetData("IPREGION");
	local pIdx = -1;
	local cIdx =  -1;
	local yes = 0 ;
	if(ipRegion and ipRegion > 0) then
		pIdx,cIdx = DataPool:getUINumbersFromIpRegion(ipRegion);
		local count =  DataPool : GetProvincesNum();
		count = tonumber(count);
		if(pIdx < count and count) then
			local num = DataPool : GetCityNumFromOneProvinceId(pIdx);
			num = tonumber(num);
			if(cIdx < num and num) then
				--到这里，确定是有效的ipRegion
				yes = 1;
			end
		end
	end
	
	--同城频道做特殊处理,如果同城频道选中
	if(string.byte(strCfg,12) == 49 ) then
		ChannelSetFenping_ProvinceCity : Enable();
		ChannelSetFenping_Province	  : Enable();
		if(tonumber(yes) == 1)then
			ChannelSetFenping_Province	  : SetCurrentSelect(0);
			ChannelSetFenping_ComboListProvinceChanged(0);
		else
			ChannelSetFenping_Province : SetCurrentSelect(0);
			ChannelSetFenping_ComboListProvinceChanged(0);
		end
	else
		if(tonumber(yes) == 1)then
			ChannelSetFenping_Province	  : SetCurrentSelect(0);
			ChannelSetFenping_ComboListProvinceChanged(0);
		else
			ChannelSetFenping_Province : SetCurrentSelect(0);
			ChannelSetFenping_ComboListProvinceChanged(0);
		end
		ChannelSetFenping_ProvinceCity : Disable();
		ChannelSetFenping_Province	  : Disable();
	end

	for i=1, 13 do
		if(string.byte(strCfg, i) == 48) then -- 0
			ChannelSetFenping_CC_BUTTON_SetCheck(i,0);
		elseif(string.byte(strCfg, i) == 49) then -- 1
			ChannelSetFenping_CC_BUTTON_SetCheck(i,1);
		end
		ChannelSetFenping_CC_BUTTON_Enable(i);
	end

	this:Show();
end

function ChannelSetFenping_CC_BUTTON_SetCheck(idx,val)
	if not idx then return; end
	if not val then return; end
	
	if FENPING_CUSTOM_BUTTONS[idx] then
		FENPING_CUSTOM_BUTTONS[idx]:SetCheck(val);
	end
end

function ChannelSetFenping_CC_BUTTON_GetSelected(idx)
	if not idx then return "False"; end
	if FENPING_CUSTOM_BUTTONS[idx] then
		return FENPING_CUSTOM_BUTTONS[idx]:GetProperty("Selected");
	end
	return "False";
end

function ChannelSetFenping_CC_BUTTON_Disable(idx)
	if not idx then return "False"; end
	if FENPING_CUSTOM_BUTTONS[idx] then
		FENPING_CUSTOM_BUTTONS[idx]:Disable();
	end
end

function ChannelSetFenping_CC_BUTTON_Enable(idx)
	if not idx then return "False"; end
	if FENPING_CUSTOM_BUTTONS[idx] then
		FENPING_CUSTOM_BUTTONS[idx]:Enable();
	end
end

function ChannelSetFenping_Create_Clicked()
	local strConfig = "";
	
	if g_fenpingOpen == 1 then
	--分屏已经打开
		return
	end
	-- config
	local i;
	for i=1, FENPING_CUSTOM_BUTTONS_NUM do
		if("False" == ChannelSetFenping_CC_BUTTON_GetSelected(i)) then
			strConfig = strConfig .. "0";
		elseif("True" == ChannelSetFenping_CC_BUTTON_GetSelected(i)) then
			strConfig = strConfig .. "1";
		end
	end
	
	if("True" == ChannelSetFenping_CC_BUTTON_GetSelected(12)) then
		local _name,_id = ChannelSetFenping_ProvinceCity:GetCurrentSelect();
		if(_id == nil or tonumber(_id) == nil)then
			_id = -1;
		end
		if(_id < 0)then
			PushDebugMessage("#{LTFP_091016_3}")
			this : Hide()
			return;
		end
		Player:SetIPRegion(tonumber(_id));
	end
	--创建分屏
	ConfigFenping(strConfig);
	SetFenPingOpen(1)
	PushEvent("UI_COMMAND",202209131,strConfig)
	this:Hide();
end

function ChannelSetFenping_Accept_Clicked()
	local strConfig = "";

	if g_fenpingOpen == 0 then
	--分屏未打开
		return
	end
	-- config
	local i;
	for i=1, FENPING_CUSTOM_BUTTONS_NUM do
		if("False" == ChannelSetFenping_CC_BUTTON_GetSelected(i)) then
			strConfig = strConfig .. "0";
		elseif("True" == ChannelSetFenping_CC_BUTTON_GetSelected(i)) then
			strConfig = strConfig .. "1";
		end
	end
	
	if("True" == ChannelSetFenping_CC_BUTTON_GetSelected(12)) then
		local _name,_id = ChannelSetFenping_ProvinceCity:GetCurrentSelect();
		if(_id == nil or tonumber(_id) == nil)then
			_id = -1;
		end
		if(_id < 0)then
			PushDebugMessage("#{LTFP_091016_3}")
			this : Hide()
			return;
		end
		Player:SetIPRegion(tonumber(_id));
	end
	ConfigFenping(strConfig);
	
	this:Hide();
end

function ChannelSetFenping_Cancel_Clicked()
	this:Hide();
end

function ChannelSetFenping_Destory_Clicked()
	PushEvent("UI_COMMAND",202209132)
	SetFenPingOpen(0)
	this:Hide();
end

function ChannelSetFenping_Close_Clicked()
	ChannelSetFenping_Cancel_Clicked();
end

function ChannelSetFenping_ComboListProvinceCityChanged()
	-- do nothing
end

function ChannelSetFenping_City_Click()
	if("False" == ChannelSetFenping_City:GetProperty("Selected"))then
		ChannelSetFenping_Province : Disable()
		ChannelSetFenping_ProvinceCity : Disable();

	else

		ChannelSetFenping_Province : Enable()
		ChannelSetFenping_ProvinceCity : Enable();
	end
end
function ChannelSetFenping_Frame_ResetPos()
	ChannelSetFenping_Frame:SetProperty("UnifiedXPosition", g_ChannelSetFenping_Frame_UnifiedXPosition);
	ChannelSetFenping_Frame:SetProperty("UnifiedYPosition", g_ChannelSetFenping_Frame_UnifiedYPosition);

end
