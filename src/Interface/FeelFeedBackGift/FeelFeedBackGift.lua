
local g_nSelectIndex = 0;
--local checkBox_items = {}
local g_ActionBtnCtrl2 = {}
local g_ActionBtnCtrl1 = {}

local g_TitleCtrl;
local g_TextIntroCtrl;

local g_itemids = 
{
	[1] = {39920032,39920033,39920034},  --雪羽霜衣
	[2] = {39920035,39920036,39920037,39920038},   --坐骑
}

local g_boxType = 0;
--===============================================
-- PreLoad()
--===============================================
function FeelFeedBackGift_PreLoad()
	this:RegisterEvent("UI_COMMAND",true)
	this:RegisterEvent("PLAYER_LEAVE_WORLD",false)		-- 离开场景
end

--===============================================
-- OnLoad()
--===============================================
function FeelFeedBackGift_OnLoad()
--	checkBox_items[1] =  FeelFeedBackGift_Clinet1_iconAnimate;
--	checkBox_items[2] =  FeelFeedBackGift_Clinet2_iconAnimate;
--	checkBox_items[3] =  FeelFeedBackGift_Clinet3_iconAnimate;
--	checkBox_items[4] =  FeelFeedBackGift_Clinet4_iconAnimate;
	
	--actionbutton
	g_ActionBtnCtrl1[1] = FeelFeedBackGift_Gift1_Icon
	g_ActionBtnCtrl1[2] = FeelFeedBackGift_Gift2_Icon
	g_ActionBtnCtrl1[3] = FeelFeedBackGift_Gift3_Icon
	g_ActionBtnCtrl2[1] = FeelFeedBackGift_GiftT1_Icon
	g_ActionBtnCtrl2[2] = FeelFeedBackGift_GiftT2_Icon
	g_ActionBtnCtrl2[3] = FeelFeedBackGift_GiftT3_Icon
	g_ActionBtnCtrl2[4] = FeelFeedBackGift_GiftT4_Icon

	g_TitleCtrl = FeelFeedBackGift_DragTitle
	g_TextIntroCtrl = FeelFeedBackGift_Info

end

function FeelFeedBackGift_UpdateUI()
	g_nSelectIndex = 0
	if g_boxType==1 then
		--时装 三选一
		FeelFeedBackGift_Gift:Show()
		FeelFeedBackGift_GiftT:Hide()
		for i, v in pairs(g_ActionBtnCtrl1) do
			local theAction = DataPool:CreateActionItemForShow(g_itemids[g_boxType][i], 1)
			if theAction:GetID() ~= 0 then
				v:SetActionItem(theAction:GetID());
				v:Show();
			else
				v:SetActionItem(-1);
				v:Hide()
			end
		end
		g_TitleCtrl:SetText("#{MYGEHK_20110_51}")
		g_TextIntroCtrl:SetText("#{MYGEHK_20110_37}")
	elseif g_boxType==2 then
		--坐骑 四选一
		FeelFeedBackGift_Gift:Hide()
		FeelFeedBackGift_GiftT:Show()
		for i, v in pairs(g_ActionBtnCtrl2) do 
			local theAction = DataPool:CreateActionItemForShow(g_itemids[g_boxType][i], 1)
			if theAction:GetID() ~= 0 then
				v:SetActionItem(theAction:GetID());
				v:Show();
			else
				v:SetActionItem(-1);
				v:Hide()
			end
		end
		g_TitleCtrl:SetText("#{MYGEHK_20110_52}")
		g_TextIntroCtrl:SetText("#{MYGEHK_20110_40}")
	end

--	for i, v in pairs(checkBox_items) do 
--		v:Hide()
--	end

end

--===============================================
-- OnEvent()
--===============================================
function FeelFeedBackGift_OnEvent(event)
	if( event == "UI_COMMAND" and tonumber(arg0) == 88990701 ) then--衣服
		local bIsShow = Get_XParam_INT(0);
		g_boxType = 1;
		if bIsShow == 1 then
			FeelFeedBackGift_UpdateUI()
			this:Show();
		else
			FeelFeedBackGift_OnClose();
		end
	end
	
	if( event == "UI_COMMAND" and tonumber(arg0) == 88990801 ) then
		local bIsShow = Get_XParam_INT(0);
		g_boxType = 2;
		if bIsShow == 1 then
			FeelFeedBackGift_Gift:Hide()
			FeelFeedBackGift_GiftT:Show()
			FeelFeedBackGift_UpdateUI()
			this:Show();
		else
			FeelFeedBackGift_OnClose();
		end
	elseif (event == "PLAYER_LEAVE_WORLD") then
		FeelFeedBackGift_OnClose()
	end
end

function FeelFeedBackGift_Confirm()
	if g_boxType == 1 then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "OnSelectItem" )
			Set_XSCRIPT_ScriptID( 889907 )
			Set_XSCRIPT_Parameter( 0, g_nSelectIndex )
			Set_XSCRIPT_ParamCount( 1 )
		Send_XSCRIPT()
	elseif g_boxType == 2 then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "OnSelectItem" )
			Set_XSCRIPT_ScriptID( 889908 )
			Set_XSCRIPT_Parameter( 0, g_nSelectIndex )
			Set_XSCRIPT_ParamCount( 1 )
		Send_XSCRIPT()
	end
end
function FeelFeedBackGift_1_Select(nIndex)
	if g_boxType == 1 then
		for i, v in pairs(g_ActionBtnCtrl1) do
			v:SetPushed(0)
		end
		g_ActionBtnCtrl1[nIndex]:SetPushed(1)
		g_nSelectIndex = nIndex
	end
end
function FeelFeedBackGift_2_Select(nIndex)
	if g_boxType == 2 then
		for i, v in pairs(g_ActionBtnCtrl2) do
			v:SetPushed(0)
		end
		g_ActionBtnCtrl2[nIndex]:SetPushed(1)
		g_nSelectIndex = nIndex
	end
end
function FeelFeedBackGift_Select(nIndex)
--	if checkBox_items[g_nSelectIndex] then 
--		checkBox_items[g_nSelectIndex]:Hide();
--	end
--	g_nSelectIndex = nIndex;
--	if checkBox_items[g_nSelectIndex] then 
--		checkBox_items[g_nSelectIndex]:Show();
--	end
end

function FeelFeedBackGift_OnClose()
--	FeelFeedBackGift_Select(0)
	g_boxType = 0
	g_nSelectIndex = 0
	this:Hide();
end
