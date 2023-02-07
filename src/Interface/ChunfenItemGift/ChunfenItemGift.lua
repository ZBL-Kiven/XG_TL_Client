
local g_nSelectIndex = 0;
local g_ActionBtnCtrl1 = {}

--local g_TitleCtrl;
--local g_TextIntroCtrl;

local g_itemids = 
{
	[1] = {50302002, 50302001, 50302003, 50302004},  --晶石3级礼盒
}

local g_boxType = 0;
--===============================================
-- PreLoad()
--===============================================
function ChunfenItemGift_PreLoad()
	this:RegisterEvent("UI_COMMAND",true)
	this:RegisterEvent("PLAYER_LEAVE_WORLD",false)		-- 离开场景
end

--===============================================
-- OnLoad()
--===============================================
function ChunfenItemGift_OnLoad()

	--actionbutton
	g_ActionBtnCtrl1[1] = ChunfenItemGift_Gift1_Icon
	g_ActionBtnCtrl1[2] = ChunfenItemGift_Gift2_Icon
	g_ActionBtnCtrl1[3] = ChunfenItemGift_Gift3_Icon
	g_ActionBtnCtrl1[4] = ChunfenItemGift_Gift4_Icon

	--g_TitleCtrl = ChunfenItemGift_DragTitle
	--g_TextIntroCtrl = ChunfenItemGift_Info

end

function ChunfenItemGift_UpdateUI()
	g_nSelectIndex = 0
	if g_boxType==1 then
		--四选一
		ChunfenItemGift_Gift:Show()
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
		-- g_TitleCtrl:SetText("#{MYGEHK_20110_51}")
		-- g_TextIntroCtrl:SetText("#{MYGEHK_20110_37}")
	else

	end

end

--===============================================
-- OnEvent()
--===============================================
function ChunfenItemGift_OnEvent(event)
	
	if( event == "UI_COMMAND" and tonumber(arg0) == 89112301 ) then--衣服
		local bIsShow = Get_XParam_INT(0);
		g_boxType = 1;
		if bIsShow == 1 then
			ChunfenItemGift_UpdateUI()
			this:Show();
		else
			ChunfenItemGift_OnClose();
		end
	elseif (event == "PLAYER_LEAVE_WORLD") then
		ChunfenItemGift_OnClose()
	end

end

function ChunfenItemGift_Confirm()
	if g_boxType == 1 then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "OnSelectItem" )
			Set_XSCRIPT_ScriptID( 891123 )
			Set_XSCRIPT_Parameter( 0, g_nSelectIndex )
			Set_XSCRIPT_ParamCount( 1 )
		Send_XSCRIPT()
	else

	end
end

function ChunfenItemGift_1_Select(nIndex)
	if g_boxType == 1 then
		for i, v in pairs(g_ActionBtnCtrl1) do
			v:SetPushed(0)
		end
		g_ActionBtnCtrl1[nIndex]:SetPushed(1)
		g_nSelectIndex = nIndex
	end
end

function ChunfenItemGift_OnClose()
	g_boxType = 0
	g_nSelectIndex = 0
	this:Hide();
end
