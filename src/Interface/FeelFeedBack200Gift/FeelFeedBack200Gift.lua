
local g_nSelectIndex = 0;
--local checkBox_items = {}
local g_ActionBtnCtrl2 = {}
local g_ActionBtnCtrl1 = {}

local g_TitleCtrl;
local g_TextIntroCtrl;

-- ����������15��ϡ��ɫ������3ѡ1	
-- ����	����ID
-- �����������������15�죬��ȡ�󶨣�	10124345
-- ����������������15�죬��ȡ�󶨣�	10124346
-- �����������õ����15�죬��ȡ�󶨣�	10124347

-- ������У�����4ѡ1	
-- ����	����ID
-- ���ڤ��15�죬��ȡ�󶨣�	10141872
-- ���ѩ��15�죬��ȡ�󶨣�	10141258
-- �����Գ��15�죬��ȡ�󶨣�	10141211
-- ������컢��15�죬��ȡ�󶨣�	10141213

-- ���ڤ��15�죬��ȡ��ʰȡ�󶨣�	10141918
-- ���ѩ��15�죬��ȡ��ʰȡ�󶨣�	10141919
-- �����Գ��15�죬��ȡ��ʰȡ�󶨣�	10141920
-- ������컢��15�죬��ȡ��ʰȡ�󶨣�	10141250

-- ������ʯ3����У�����4ѡ1	
-- ����	����ID
-- �����ƾ�ʯ3��	50302005
-- ��������ʯ3��	50302006
-- �����쾧ʯ3��	50302007
-- �����̾�ʯ3��	50302008

local g_itemids = 
{
	[1] = {10124345,10124346,10124347},
	[2] = {10141918,10141919,10141920,10141250},
	[3] = {50302005,50302006,50302007,50302008},
}

local g_boxType = 0;
--===============================================
-- PreLoad()
--===============================================
function FeelFeedBack200Gift_PreLoad()
	this:RegisterEvent("UI_COMMAND",true)
	this:RegisterEvent("PLAYER_LEAVE_WORLD",false)		-- �뿪����
end

--===============================================
-- OnLoad()
--===============================================
function FeelFeedBack200Gift_OnLoad()
--	checkBox_items[1] =  FeelFeedBack200Gift_Clinet1_iconAnimate;
--	checkBox_items[2] =  FeelFeedBack200Gift_Clinet2_iconAnimate;
--	checkBox_items[3] =  FeelFeedBack200Gift_Clinet3_iconAnimate;
--	checkBox_items[4] =  FeelFeedBack200Gift_Clinet4_iconAnimate;
	
	--actionbutton
	g_ActionBtnCtrl1[1] = FeelFeedBack200Gift_Gift1_Icon
	g_ActionBtnCtrl1[2] = FeelFeedBack200Gift_Gift2_Icon
	g_ActionBtnCtrl1[3] = FeelFeedBack200Gift_Gift3_Icon
	g_ActionBtnCtrl2[1] = FeelFeedBack200Gift_GiftT1_Icon
	g_ActionBtnCtrl2[2] = FeelFeedBack200Gift_GiftT2_Icon
	g_ActionBtnCtrl2[3] = FeelFeedBack200Gift_GiftT3_Icon
	g_ActionBtnCtrl2[4] = FeelFeedBack200Gift_GiftT4_Icon

	g_TitleCtrl = FeelFeedBack200Gift_DragTitle
	g_TextIntroCtrl = FeelFeedBack200Gift_Info

end

function FeelFeedBack200Gift_UpdateUI()
	g_nSelectIndex = 0
	if g_boxType==1 then
		--ʱװ ��ѡһ
		FeelFeedBack200Gift_Gift:Show()
		FeelFeedBack200Gift_GiftT:Hide()
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
		g_TitleCtrl:SetText("#{XLYXY_210126_51}")
		g_TextIntroCtrl:SetText("#{XLYXY_210126_37}")
	elseif g_boxType==2 then
		--���� ��ѡһ
		FeelFeedBack200Gift_Gift:Hide()
		FeelFeedBack200Gift_GiftT:Show()
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
		g_TitleCtrl:SetText("#{XLYXY_210126_52}")
		g_TextIntroCtrl:SetText("#{XLYXY_210126_40}")

		FeelFeedBack200Gift_GiftT1_Text : SetText("#{XLYXY_210126_46}")
		FeelFeedBack200Gift_GiftT2_Text : SetText("#{XLYXY_210126_47}")
		FeelFeedBack200Gift_GiftT3_Text : SetText("#{XLYXY_210126_48}")
		FeelFeedBack200Gift_GiftT4_Text : SetText("#{XLYXY_210126_49}")

	elseif g_boxType==3 then
		--��ʯ ��ѡһ
		FeelFeedBack200Gift_Gift:Hide()
		FeelFeedBack200Gift_GiftT:Show()
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
		g_TitleCtrl:SetText("#{XLYXY_210126_55}")
		g_TextIntroCtrl:SetText("#{XLYXY_210126_57}")

		FeelFeedBack200Gift_GiftT1_Text : SetText("#{XLYXY_210126_02}")
		FeelFeedBack200Gift_GiftT2_Text : SetText("#{XLYXY_210126_03}")
		FeelFeedBack200Gift_GiftT3_Text : SetText("#{XLYXY_210126_04}")
		FeelFeedBack200Gift_GiftT4_Text : SetText("#{XLYXY_210126_05}")
	end

--	for i, v in pairs(checkBox_items) do 
--		v:Hide()
--	end

end

--===============================================
-- OnEvent()
--===============================================
function FeelFeedBack200Gift_OnEvent(event)

	-- �·�
	if( event == "UI_COMMAND" and tonumber(arg0) == 79100601 ) then
		local bIsShow = Get_XParam_INT(0);
		g_boxType = 1;
		if bIsShow == 1 then
			FeelFeedBack200Gift_UpdateUI()
			this:Show();
		else
			FeelFeedBack200Gift_OnClose();
		end
	end
	
	-- ����
	if( event == "UI_COMMAND" and tonumber(arg0) == 79100701 ) then
		local bIsShow = Get_XParam_INT(0);
		g_boxType = 2;
		if bIsShow == 1 then
			FeelFeedBack200Gift_Gift:Hide()
			FeelFeedBack200Gift_GiftT:Show()
			FeelFeedBack200Gift_UpdateUI()
			this:Show();
		else
			FeelFeedBack200Gift_OnClose();
		end
	end 

	-- ��ʯ
	if( event == "UI_COMMAND" and tonumber(arg0) == 79100801 ) then
		local bIsShow = Get_XParam_INT(0);
		g_boxType = 3;
		if bIsShow == 1 then
			FeelFeedBack200Gift_Gift:Hide()
			FeelFeedBack200Gift_GiftT:Show()
			FeelFeedBack200Gift_UpdateUI()
			this:Show();
		else
			FeelFeedBack200Gift_OnClose();
		end
	end 

	if (event == "PLAYER_LEAVE_WORLD") then
		FeelFeedBack200Gift_OnClose()
	end
end

function FeelFeedBack200Gift_Confirm()
	if g_boxType == 1 then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "OnSelectItem" )
			Set_XSCRIPT_ScriptID( 791006 )
			Set_XSCRIPT_Parameter( 0, g_nSelectIndex )
			Set_XSCRIPT_ParamCount( 1 )
		Send_XSCRIPT()
	elseif g_boxType == 2 then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "OnSelectItem" )
			Set_XSCRIPT_ScriptID( 791007 )
			Set_XSCRIPT_Parameter( 0, g_nSelectIndex )
			Set_XSCRIPT_ParamCount( 1 )
		Send_XSCRIPT()
	elseif g_boxType == 3 then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "OnSelectItem" )
			Set_XSCRIPT_ScriptID( 791008 )
			Set_XSCRIPT_Parameter( 0, g_nSelectIndex )
			Set_XSCRIPT_ParamCount( 1 )
		Send_XSCRIPT()
	end
end
function FeelFeedBack200Gift_1_Select(nIndex)
	if g_boxType == 1 then
		for i, v in pairs(g_ActionBtnCtrl1) do
			v:SetPushed(0)
		end
		g_ActionBtnCtrl1[nIndex]:SetPushed(1)
		g_nSelectIndex = nIndex
	end
end
function FeelFeedBack200Gift_2_Select(nIndex)
	if g_boxType == 2 or g_boxType == 3 then
		for i, v in pairs(g_ActionBtnCtrl2) do
			v:SetPushed(0)
		end
		g_ActionBtnCtrl2[nIndex]:SetPushed(1)
		g_nSelectIndex = nIndex
	end
end

function FeelFeedBack200Gift_Select(nIndex)
--	if checkBox_items[g_nSelectIndex] then 
--		checkBox_items[g_nSelectIndex]:Hide();
--	end
--	g_nSelectIndex = nIndex;
--	if checkBox_items[g_nSelectIndex] then 
--		checkBox_items[g_nSelectIndex]:Show();
--	end
end

function FeelFeedBack200Gift_OnClose()
--	FeelFeedBack200Gift_Select(0)
	g_boxType = 0
	g_nSelectIndex = 0
	this:Hide();
end
