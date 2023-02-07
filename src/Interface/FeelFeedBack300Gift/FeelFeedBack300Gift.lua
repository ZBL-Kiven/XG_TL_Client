
local g_nSelectIndex = 0;
--local checkBox_items = {}
local g_ActionBtnCtrl2 = {}
local g_ActionBtnCtrl1 = {}

local g_TitleCtrl;
local g_TextIntroCtrl;

--īȾ���㣨15��ϡ��ɫ������3ѡ1	
--����	����ID
--īȾ���㣨������15�죬��ȡ�󶨣�	��10124365
--īȾ���㣨������15�죬��ȡ�󶨣�	��10124366
--īȾ���㣨��ڤ���15�죬��ȡ�󶨣�	��10124367

--�������������4ѡ1	
--����	����ID
--���ڤ��15�죬��ȡ�󶨣�	��10141918
--���ѩ��15�죬��ȡ�󶨣�	��10141919
--�����Գ��15�죬��ȡ�󶨣�	��10141920
--������컢��15�죬��ȡ�󶨣�	10141250


local g_itemids = 
{
	[1] = {10124365,10124366,10124367},
	[2] = {10141918,10141919,10141920,10141250},
}

local g_boxType = 0;
--===============================================
-- PreLoad()
--===============================================
function FeelFeedBack300Gift_PreLoad()
	this:RegisterEvent("UI_COMMAND",true)
	this:RegisterEvent("PLAYER_LEAVE_WORLD",false)		-- �뿪����
end

--===============================================
-- OnLoad()
--===============================================
function FeelFeedBack300Gift_OnLoad()
--	checkBox_items[1] =  FeelFeedBack300Gift_Clinet1_iconAnimate;
--	checkBox_items[2] =  FeelFeedBack300Gift_Clinet2_iconAnimate;
--	checkBox_items[3] =  FeelFeedBack300Gift_Clinet3_iconAnimate;
--	checkBox_items[4] =  FeelFeedBack300Gift_Clinet4_iconAnimate;
	
	--actionbutton
	g_ActionBtnCtrl1[1] = FeelFeedBack300Gift_Gift1_Icon
	g_ActionBtnCtrl1[2] = FeelFeedBack300Gift_Gift2_Icon
	g_ActionBtnCtrl1[3] = FeelFeedBack300Gift_Gift3_Icon
	g_ActionBtnCtrl2[1] = FeelFeedBack300Gift_GiftT1_Icon
	g_ActionBtnCtrl2[2] = FeelFeedBack300Gift_GiftT2_Icon
	g_ActionBtnCtrl2[3] = FeelFeedBack300Gift_GiftT3_Icon
	g_ActionBtnCtrl2[4] = FeelFeedBack300Gift_GiftT4_Icon

	g_TitleCtrl = FeelFeedBack300Gift_DragTitle
	g_TextIntroCtrl = FeelFeedBack300Gift_Info

end

function FeelFeedBack300Gift_UpdateUI()
	g_nSelectIndex = 0
	if g_boxType==1 then
		--ʱװ ��ѡһ
		FeelFeedBack300Gift_Gift:Show()
		FeelFeedBack300Gift_GiftT:Hide()
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
		g_TitleCtrl:SetText("#{QHKG_210329_51}")
		g_TextIntroCtrl:SetText("#{QHKG_210329_37}")
	elseif g_boxType==2 then
		--���� ��ѡһ
		FeelFeedBack300Gift_Gift:Hide()
		FeelFeedBack300Gift_GiftT:Show()
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
		g_TitleCtrl:SetText("#{QHKG_210329_52}")
		g_TextIntroCtrl:SetText("#{QHKG_210329_40}")
	end

--	for i, v in pairs(checkBox_items) do 
--		v:Hide()
--	end

end

--===============================================
-- OnEvent()
--===============================================
function FeelFeedBack300Gift_OnEvent(event)

	-- �·�
	if( event == "UI_COMMAND" and tonumber(arg0) == 79200101 ) then
		local bIsShow = Get_XParam_INT(0);
		g_boxType = 1;
		if bIsShow == 1 then
			FeelFeedBack300Gift_UpdateUI()
			this:Show();
		else
			FeelFeedBack300Gift_OnClose();
		end
	end
	
	-- ����
	if( event == "UI_COMMAND" and tonumber(arg0) == 79200201 ) then
		local bIsShow = Get_XParam_INT(0);
		g_boxType = 2;
		if bIsShow == 1 then
			FeelFeedBack300Gift_Gift:Hide()
			FeelFeedBack300Gift_GiftT:Show()
			FeelFeedBack300Gift_UpdateUI()
			this:Show();
		else
			FeelFeedBack300Gift_OnClose();
		end
	end

	if (event == "PLAYER_LEAVE_WORLD") then
		FeelFeedBack300Gift_OnClose()
	end
end

function FeelFeedBack300Gift_Confirm()
	if g_boxType == 1 then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "OnSelectItem" )
			Set_XSCRIPT_ScriptID( 792001 )
			Set_XSCRIPT_Parameter( 0, g_nSelectIndex )
			Set_XSCRIPT_ParamCount( 1 )
		Send_XSCRIPT()
	elseif g_boxType == 2 then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "OnSelectItem" )
			Set_XSCRIPT_ScriptID( 792002 )
			Set_XSCRIPT_Parameter( 0, g_nSelectIndex )
			Set_XSCRIPT_ParamCount( 1 )
		Send_XSCRIPT()
	end
end
function FeelFeedBack300Gift_1_Select(nIndex)
	if g_boxType == 1 then
		for i, v in pairs(g_ActionBtnCtrl1) do
			v:SetPushed(0)
		end
		g_ActionBtnCtrl1[nIndex]:SetPushed(1)
		g_nSelectIndex = nIndex
	end
end
function FeelFeedBack300Gift_2_Select(nIndex)
	if g_boxType == 2 then
		for i, v in pairs(g_ActionBtnCtrl2) do
			v:SetPushed(0)
		end
		g_ActionBtnCtrl2[nIndex]:SetPushed(1)
		g_nSelectIndex = nIndex
	end
end

function FeelFeedBack300Gift_Select(nIndex)
--	if checkBox_items[g_nSelectIndex] then 
--		checkBox_items[g_nSelectIndex]:Hide();
--	end
--	g_nSelectIndex = nIndex;
--	if checkBox_items[g_nSelectIndex] then 
--		checkBox_items[g_nSelectIndex]:Show();
--	end
end

function FeelFeedBack300Gift_OnClose()
--	FeelFeedBack300Gift_Select(0)
	g_boxType = 0
	g_nSelectIndex = 0
	this:Hide();
end
