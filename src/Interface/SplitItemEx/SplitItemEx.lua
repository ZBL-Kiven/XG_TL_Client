--相关的C＋＋代码在“GMGameInterface_Script_Package”中

local g_nItemSum = 0;
local QUCHU_1 = -1
local QUCHU_2 = -1
local QUCHU_3 = -1
--===============================================
-- PreLoad()
--===============================================
function SplitItemEx_PreLoad()

	this:RegisterEvent("SHOW_SPLIT_ITEM");
	this:RegisterEvent("HIDE_SPLIT_ITEM");
	this:RegisterEvent("UI_COMMAND");
	
end

--===============================================
-- OnLoad()
--===============================================
function SplitItemEx_OnLoad()
	
end

--===============================================
-- OnEvent()
--===============================================
function SplitItemEx_OnEvent(event)

	if(event == "UI_COMMAND" and tonumber(arg0) == 88819004 ) then

		-- g_nItemSum = PlayerPackage:GetSplitSum();
		SplitItemEx_Num:SetText("1");
		SplitItemEx_Num:SetSelected( 0, -1 );
		SplitItemEx_MBuy_Update2( tonumber(arg1), tonumber(arg2),tonumber(arg3))
		this:Show();
		
		--设置缺省的光标
		SplitItemEx_Num:SetProperty("DefaultEditBox", "True");
		
		-- SplitItemEx_Update();

	elseif( event == "HIDE_SPLIT_ITEM")	 then
		this:Hide();		
	end

end
function SplitItemEx_MBuy_Update2( tbIndex, shoptype, curpage)
	local theAction = GemCarve:UpdateProductAction( curpage )
	QUCHU_1 = tbIndex
	QUCHU_2 = shoptype
	SplitItemEx_ItemName:SetText(theAction:GetName());
end

--===============================================
-- Update()
--===============================================
function SplitItemEx_Update()

	SplitItemEx_ItemName:SetText(PlayerPackage:GetSplitName());
	
end

--===============================================
-- 点击确定
--===============================================
function SplitItemExAccept_Clicked()

	local szTemp = SplitItemEx_Num:GetText();
	if( szTemp == "" )then 
		this:Hide();
		return ;
	end
	
	local nNum = szTemp + 0;
	if nNum < 1 then
		PushDebugMessage("请输入需要取出的数量")
		return
	end
	-- local num = tonumber(TreasureBox_MBuy_InputNum:GetText())
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("PacketTemporaryTakeout");
		Set_XSCRIPT_ScriptID(900017);
		Set_XSCRIPT_Parameter(0,QUCHU_1)
		Set_XSCRIPT_Parameter(1,QUCHU_2)
		Set_XSCRIPT_Parameter(2,nNum)
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT();
	this:Hide()

end


--===============================================
-- 取消
--===============================================
function SplitItemExRefuse_Clicked()

	-- PlayerPackage:CancelSplitItemEx();
	this:Hide();
	SplitItemEx_Num:SetProperty("DefaultEditBox", "False");
end


--===============================================
-- 输入改变
--===============================================
function SplitItemEx_ChangeNum()

end

--===============================================
-- 个数加1
--===============================================
function SplitItemExAdd_Clicked()
	
	local szNum = SplitItemEx_Num:GetText();
	local nNum = szNum + 0;
	
	-- if( nNum+1 >= g_nItemSum )then
		-- nNum = g_nItemSum-2
	-- end
	
	SplitItemEx_Num:SetText(tostring(nNum+1));
	
end

--===============================================
-- 个数减1
--===============================================
function SplitItemExDecrease_Clicked()
	
	local szNum = SplitItemEx_Num:GetText();
	local nNum = szNum + 0;

	if( nNum-1 < 1 )then
		nNum = 1
	end
	
	SplitItemEx_Num:SetText(tostring(nNum-1));

end
