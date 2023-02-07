--月湮云落兽魂生 版本7日登陆礼包

local g_nSelectIndex = 0;
--local checkBox_items = {}
local g_ActionBtnCtrl2 = {}
local g_ActionBtnCtrl1 = {}

local g_TitleCtrl;
local g_TextIntroCtrl;




local g_itemids = 
{
	[1] = {10124631,10124632,10124633},
	[2] = {10141965,10141919,10141920,10141987},
}

local g_boxType = 0;
--===============================================
-- PreLoad()
--===============================================
function FeelFeedBack600Gift_PreLoad()
	this:RegisterEvent("UI_COMMAND",true)
	this:RegisterEvent("PLAYER_LEAVE_WORLD",false)		-- 离开场景
end

--===============================================
-- OnLoad()
--===============================================
function FeelFeedBack600Gift_OnLoad()
	
	--actionbutton
	g_ActionBtnCtrl1[1] = FeelFeedBack600Gift_Gift1_Icon
	g_ActionBtnCtrl1[2] = FeelFeedBack600Gift_Gift2_Icon
	g_ActionBtnCtrl1[3] = FeelFeedBack600Gift_Gift3_Icon
	g_ActionBtnCtrl2[1] = FeelFeedBack600Gift_GiftT1_Icon
	g_ActionBtnCtrl2[2] = FeelFeedBack600Gift_GiftT2_Icon
	g_ActionBtnCtrl2[3] = FeelFeedBack600Gift_GiftT3_Icon
	g_ActionBtnCtrl2[4] = FeelFeedBack600Gift_GiftT4_Icon

	g_TitleCtrl = FeelFeedBack600Gift_DragTitle
	g_TextIntroCtrl = FeelFeedBack600Gift_Info

end

function FeelFeedBack600Gift_UpdateUI()
	g_nSelectIndex = 0
	if g_boxType==1 then
		--时装 三选一
		FeelFeedBack600Gift_Gift:Show()
		FeelFeedBack600Gift_GiftT:Hide()
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
		g_TitleCtrl:SetText("#{QRDL_20211229_45}")
		g_TextIntroCtrl:SetText("#{QRDL_20211229_32}")
	elseif g_boxType==2 then
		--坐骑 四选一
		FeelFeedBack600Gift_Gift:Hide()
		FeelFeedBack600Gift_GiftT:Show()
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
		g_TitleCtrl:SetText("#{QRDL_20211229_46}")
		g_TextIntroCtrl:SetText("#{QRDL_20211229_39}")
	end

end

--===============================================
-- OnEvent()
--===============================================
function FeelFeedBack600Gift_OnEvent(event)

	-- 衣服
	if( event == "UI_COMMAND" and tonumber(arg0) == 79200701 ) then
		local bIsShow = Get_XParam_INT(0);
		g_boxType = 1;
		if bIsShow == 1 then
			FeelFeedBack600Gift_UpdateUI()
			this:Show();
		else
			FeelFeedBack600Gift_OnClose();
		end
	end
	
	-- 坐骑
	if( event == "UI_COMMAND" and tonumber(arg0) == 79200801 ) then
		local bIsShow = Get_XParam_INT(0);
		g_boxType = 2;
		if bIsShow == 1 then
			FeelFeedBack600Gift_Gift:Hide()
			FeelFeedBack600Gift_GiftT:Show()
			FeelFeedBack600Gift_UpdateUI()
			this:Show();
		else
			FeelFeedBack600Gift_OnClose();
		end
	end

	if (event == "PLAYER_LEAVE_WORLD") then
		FeelFeedBack600Gift_OnClose()
	end
end

function FeelFeedBack600Gift_Confirm()
	if g_boxType == 1 then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "OnSelectItem" )
			Set_XSCRIPT_ScriptID( 792007 )
			Set_XSCRIPT_Parameter( 0, g_nSelectIndex )
			Set_XSCRIPT_ParamCount( 1 )
		Send_XSCRIPT()
	elseif g_boxType == 2 then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "OnSelectItem" )
			Set_XSCRIPT_ScriptID( 792008 )
			Set_XSCRIPT_Parameter( 0, g_nSelectIndex )
			Set_XSCRIPT_ParamCount( 1 )
		Send_XSCRIPT()
	end
end
function FeelFeedBack600Gift_1_Select(nIndex)
	if g_boxType == 1 then
		for i, v in pairs(g_ActionBtnCtrl1) do
			v:SetPushed(0)
		end
		g_ActionBtnCtrl1[nIndex]:SetPushed(1)
		g_nSelectIndex = nIndex
	end
end
function FeelFeedBack600Gift_2_Select(nIndex)
	if g_boxType == 2 then
		for i, v in pairs(g_ActionBtnCtrl2) do
			v:SetPushed(0)
		end
		g_ActionBtnCtrl2[nIndex]:SetPushed(1)
		g_nSelectIndex = nIndex
	end
end

function FeelFeedBack600Gift_Select(nIndex)
--	if checkBox_items[g_nSelectIndex] then 
--		checkBox_items[g_nSelectIndex]:Hide();
--	end
--	g_nSelectIndex = nIndex;
--	if checkBox_items[g_nSelectIndex] then 
--		checkBox_items[g_nSelectIndex]:Show();
--	end
end

function FeelFeedBack600Gift_OnClose()
--	FeelFeedBack400Gift_Select(0)
	g_boxType = 0
	g_nSelectIndex = 0
	this:Hide();
end
