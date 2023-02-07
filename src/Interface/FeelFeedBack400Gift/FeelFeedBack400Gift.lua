
local g_nSelectIndex = 0;
--local checkBox_items = {}
local g_ActionBtnCtrl2 = {}
local g_ActionBtnCtrl1 = {}

local g_TitleCtrl;
local g_TextIntroCtrl;

--与子同袍（15天稀有色）自主3选1	
--道具	ID
--与子同袍（清寂风格，15天，获取绑定）	10124544
--与子同袍（灼耀风格，15天，获取绑定）	10124545
--与子同袍（青花风格，15天，获取绑定）	10124546

--坐骑礼包，自主4选1	
--道具	ID
--坐骑：六合舆（15天，获取绑定）	10141965
--坐骑：雪羽（15天，获取绑定）	10141919
--坐骑：巨猿（15天，获取绑定）	10141920
--坐骑：年兽（15天，获取绑定）	10141987


local g_itemids = 
{
	[1] = {10124544,10124545,10124546},
	[2] = {10141965,10141919,10141920,10141987},
}

local g_boxType = 0;
--===============================================
-- PreLoad()
--===============================================
function FeelFeedBack400Gift_PreLoad()
	this:RegisterEvent("UI_COMMAND",true)
	this:RegisterEvent("PLAYER_LEAVE_WORLD",false)		-- 离开场景
end

--===============================================
-- OnLoad()
--===============================================
function FeelFeedBack400Gift_OnLoad()
--	checkBox_items[1] =  FeelFeedBack400Gift_Clinet1_iconAnimate;
--	checkBox_items[2] =  FeelFeedBack400Gift_Clinet2_iconAnimate;
--	checkBox_items[3] =  FeelFeedBack400Gift_Clinet3_iconAnimate;
--	checkBox_items[4] =  FeelFeedBack400Gift_Clinet4_iconAnimate;
	
	--actionbutton
	g_ActionBtnCtrl1[1] = FeelFeedBack400Gift_Gift1_Icon
	g_ActionBtnCtrl1[2] = FeelFeedBack400Gift_Gift2_Icon
	g_ActionBtnCtrl1[3] = FeelFeedBack400Gift_Gift3_Icon
	g_ActionBtnCtrl2[1] = FeelFeedBack400Gift_GiftT1_Icon
	g_ActionBtnCtrl2[2] = FeelFeedBack400Gift_GiftT2_Icon
	g_ActionBtnCtrl2[3] = FeelFeedBack400Gift_GiftT3_Icon
	g_ActionBtnCtrl2[4] = FeelFeedBack400Gift_GiftT4_Icon

	g_TitleCtrl = FeelFeedBack400Gift_DragTitle
	g_TextIntroCtrl = FeelFeedBack400Gift_Info

end

function FeelFeedBack400Gift_UpdateUI()
	g_nSelectIndex = 0
	if g_boxType==1 then
		--时装 三选一
		FeelFeedBack400Gift_Gift:Show()
		FeelFeedBack400Gift_GiftT:Hide()
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
		g_TitleCtrl:SetText("#{ZNQQD_210629_51}")
		g_TextIntroCtrl:SetText("#{ZNQQD_210629_37}")
	elseif g_boxType==2 then
		--坐骑 四选一
		FeelFeedBack400Gift_Gift:Hide()
		FeelFeedBack400Gift_GiftT:Show()
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
		g_TitleCtrl:SetText("#{ZNQQD_210629_52}")
		g_TextIntroCtrl:SetText("#{ZNQQD_210629_40}")
	end

--	for i, v in pairs(checkBox_items) do 
--		v:Hide()
--	end

end

--===============================================
-- OnEvent()
--===============================================
function FeelFeedBack400Gift_OnEvent(event)

	-- 衣服
	if( event == "UI_COMMAND" and tonumber(arg0) == 79200401 ) then
		local bIsShow = Get_XParam_INT(0);
		g_boxType = 1;
		if bIsShow == 1 then
			FeelFeedBack400Gift_UpdateUI()
			this:Show();
		else
			FeelFeedBack400Gift_OnClose();
		end
	end
	
	-- 坐骑
	if( event == "UI_COMMAND" and tonumber(arg0) == 79200501 ) then
		local bIsShow = Get_XParam_INT(0);
		g_boxType = 2;
		if bIsShow == 1 then
			FeelFeedBack400Gift_Gift:Hide()
			FeelFeedBack400Gift_GiftT:Show()
			FeelFeedBack400Gift_UpdateUI()
			this:Show();
		else
			FeelFeedBack400Gift_OnClose();
		end
	end

	if (event == "PLAYER_LEAVE_WORLD") then
		FeelFeedBack400Gift_OnClose()
	end
end

function FeelFeedBack400Gift_Confirm()
	if g_boxType == 1 then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "OnSelectItem" )
			Set_XSCRIPT_ScriptID( 792004 )
			Set_XSCRIPT_Parameter( 0, g_nSelectIndex )
			Set_XSCRIPT_ParamCount( 1 )
		Send_XSCRIPT()
	elseif g_boxType == 2 then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "OnSelectItem" )
			Set_XSCRIPT_ScriptID( 792005 )
			Set_XSCRIPT_Parameter( 0, g_nSelectIndex )
			Set_XSCRIPT_ParamCount( 1 )
		Send_XSCRIPT()
	end
end
function FeelFeedBack400Gift_1_Select(nIndex)
	if g_boxType == 1 then
		for i, v in pairs(g_ActionBtnCtrl1) do
			v:SetPushed(0)
		end
		g_ActionBtnCtrl1[nIndex]:SetPushed(1)
		g_nSelectIndex = nIndex
	end
end
function FeelFeedBack400Gift_2_Select(nIndex)
	if g_boxType == 2 then
		for i, v in pairs(g_ActionBtnCtrl2) do
			v:SetPushed(0)
		end
		g_ActionBtnCtrl2[nIndex]:SetPushed(1)
		g_nSelectIndex = nIndex
	end
end

function FeelFeedBack400Gift_Select(nIndex)
--	if checkBox_items[g_nSelectIndex] then 
--		checkBox_items[g_nSelectIndex]:Hide();
--	end
--	g_nSelectIndex = nIndex;
--	if checkBox_items[g_nSelectIndex] then 
--		checkBox_items[g_nSelectIndex]:Show();
--	end
end

function FeelFeedBack400Gift_OnClose()
--	FeelFeedBack400Gift_Select(0)
	g_boxType = 0
	g_nSelectIndex = 0
	this:Hide();
end
