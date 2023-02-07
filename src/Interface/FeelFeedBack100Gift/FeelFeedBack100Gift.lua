
local g_nSelectIndex = 0;
--local checkBox_items = {}
local g_ActionBtnCtrl2 = {}
local g_ActionBtnCtrl1 = {}

local g_TitleCtrl;
local g_TextIntroCtrl;

local g_itemids = 
{
	[1] = {10124310,10124311,10124312},
	[2] = {10141818,10141834,10141251,10141252},
}

local g_boxType = 0;
--===============================================
-- PreLoad()
--===============================================
function FeelFeedBack100Gift_PreLoad()
	this:RegisterEvent("UI_COMMAND",true)
	this:RegisterEvent("PLAYER_LEAVE_WORLD",false)		-- 离开场景
end

--===============================================
-- OnLoad()
--===============================================
function FeelFeedBack100Gift_OnLoad()
--	checkBox_items[1] =  FeelFeedBack100Gift_Clinet1_iconAnimate;
--	checkBox_items[2] =  FeelFeedBack100Gift_Clinet2_iconAnimate;
--	checkBox_items[3] =  FeelFeedBack100Gift_Clinet3_iconAnimate;
--	checkBox_items[4] =  FeelFeedBack100Gift_Clinet4_iconAnimate;
	
	--actionbutton
	g_ActionBtnCtrl1[1] = FeelFeedBack100Gift_Gift1_Icon
	g_ActionBtnCtrl1[2] = FeelFeedBack100Gift_Gift2_Icon
	g_ActionBtnCtrl1[3] = FeelFeedBack100Gift_Gift3_Icon
	g_ActionBtnCtrl2[1] = FeelFeedBack100Gift_GiftT1_Icon
	g_ActionBtnCtrl2[2] = FeelFeedBack100Gift_GiftT2_Icon
	g_ActionBtnCtrl2[3] = FeelFeedBack100Gift_GiftT3_Icon
	g_ActionBtnCtrl2[4] = FeelFeedBack100Gift_GiftT4_Icon

	g_TitleCtrl = FeelFeedBack100Gift_DragTitle
	g_TextIntroCtrl = FeelFeedBack100Gift_Info

end

function FeelFeedBack100Gift_UpdateUI()
	g_nSelectIndex = 0
	if g_boxType==1 then
		--时装 三选一
		FeelFeedBack100Gift_Gift:Show()
		FeelFeedBack100Gift_GiftT:Hide()
		for i, v in pairs(g_ActionBtnCtrl1) do
			local theAction = DataPool:CreateBindActionItemForShow(g_itemids[g_boxType][i], 1)
			if theAction:GetID() ~= 0 then
				v:SetActionItem(theAction:GetID());
				v:Show();
			else
				v:SetActionItem(-1);
				v:Hide()
			end
		end
		g_TitleCtrl:SetText("#{HJHL_201220_51}")
		g_TextIntroCtrl:SetText("#{HJHL_201220_37}")
	elseif g_boxType==2 then
		--坐骑 四选一
		FeelFeedBack100Gift_Gift:Hide()
		FeelFeedBack100Gift_GiftT:Show()
		for i, v in pairs(g_ActionBtnCtrl2) do 
			local theAction = DataPool:CreateBindActionItemForShow(g_itemids[g_boxType][i], 1)
			if theAction:GetID() ~= 0 then
				v:SetActionItem(theAction:GetID());
				v:Show();
			else
				v:SetActionItem(-1);
				v:Hide()
			end
		end
		g_TitleCtrl:SetText("#{HJHL_201220_52}")
		g_TextIntroCtrl:SetText("#{HJHL_201220_40}")
	end

--	for i, v in pairs(checkBox_items) do 
--		v:Hide()
--	end

end

--===============================================
-- OnEvent()
--===============================================
function FeelFeedBack100Gift_OnEvent(event)
	if( event == "UI_COMMAND" and tonumber(arg0) == 79100201 ) then--衣服
		local bIsShow = Get_XParam_INT(0);
		g_boxType = 1;
		if bIsShow == 1 then
			FeelFeedBack100Gift_UpdateUI()
			this:Show();
		else
			FeelFeedBack100Gift_OnClose();
		end
	end
	
	if( event == "UI_COMMAND" and tonumber(arg0) == 79100301 ) then
		local bIsShow = Get_XParam_INT(0);
		g_boxType = 2;
		if bIsShow == 1 then
			FeelFeedBack100Gift_Gift:Hide()
			FeelFeedBack100Gift_GiftT:Show()
			FeelFeedBack100Gift_UpdateUI()
			this:Show();
		else
			FeelFeedBack100Gift_OnClose();
		end
	elseif (event == "PLAYER_LEAVE_WORLD") then
		FeelFeedBack100Gift_OnClose()
	end
end

function FeelFeedBack100Gift_Confirm()
	if g_boxType == 1 then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "OnSelectItem" )
			Set_XSCRIPT_ScriptID( 791002 )
			Set_XSCRIPT_Parameter( 0, g_nSelectIndex )
			Set_XSCRIPT_ParamCount( 1 )
		Send_XSCRIPT()
	elseif g_boxType == 2 then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "OnSelectItem" )
			Set_XSCRIPT_ScriptID( 791003 )
			Set_XSCRIPT_Parameter( 0, g_nSelectIndex )
			Set_XSCRIPT_ParamCount( 1 )
		Send_XSCRIPT()
	end
end
function FeelFeedBack100Gift_1_Select(nIndex)
	if g_boxType == 1 then
		for i, v in pairs(g_ActionBtnCtrl1) do
			v:SetPushed(0)
		end
		g_ActionBtnCtrl1[nIndex]:SetPushed(1)
		g_nSelectIndex = nIndex
	end
end
function FeelFeedBack100Gift_2_Select(nIndex)
	if g_boxType == 2 then
		for i, v in pairs(g_ActionBtnCtrl2) do
			v:SetPushed(0)
		end
		g_ActionBtnCtrl2[nIndex]:SetPushed(1)
		g_nSelectIndex = nIndex
	end
end
function FeelFeedBack100Gift_Select(nIndex)
--	if checkBox_items[g_nSelectIndex] then 
--		checkBox_items[g_nSelectIndex]:Hide();
--	end
--	g_nSelectIndex = nIndex;
--	if checkBox_items[g_nSelectIndex] then 
--		checkBox_items[g_nSelectIndex]:Show();
--	end
end

function FeelFeedBack100Gift_OnClose()
--	FeelFeedBack100Gift_Select(0)
	g_boxType = 0
	g_nSelectIndex = 0
	this:Hide();
end
