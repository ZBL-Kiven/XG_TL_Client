--相关的C＋＋代码在“GMGameInterface_Script_Package”中

local g_nItemSum = 0;
local nServerstring_1 = ""
local nServerstring_2 = ""
--===============================================
-- PreLoad()
--===============================================
function PuTongChallenge_PreLoad()
	this:RegisterEvent("SHOW_SPLIT_ITEM");
	this:RegisterEvent("HIDE_SPLIT_ITEM");
	this:RegisterEvent("UI_COMMAND");
end

--===============================================
-- OnLoad()
--===============================================
function PuTongChallenge_OnLoad()
	
end

--===============================================
-- OnEvent()
--===============================================
function PuTongChallenge_OnEvent(event)

	if(event == "UI_COMMAND" and tonumber(arg0) == 20220523 ) then
		PuTongChallenge_Num:SetText("1");
		PuTongChallenge_Num:SetSelected( 0, -1 );
		PuTongChallenge_ItemName:SetText("输入挑战者ID")
		this:Show();		
		--设置缺省的光标
		PuTongChallenge_Num:SetProperty("DefaultEditBox", "True");
		
		-- PuTongChallenge_Update();

	elseif( event == "HIDE_SPLIT_ITEM")	 then
		this:Hide();		
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 202205231 ) then
		PushEvent("UI_COMMAND",202105232,Get_XParam_STR(0),Get_XParam_INT(0),Get_XParam_INT(1))
	end

end
function PuTongChallenge_MBuy_Update2( tbIndex, shoptype, curpage)
	
end

--===============================================
-- Update()
--===============================================
function PuTongChallenge_Update()

	PuTongChallenge_ItemName:SetText(PlayerPackage:GetSplitName());
	
end

--===============================================
-- 点击确定
--===============================================
function PuTongChallengeAccept_Clicked()

	local szTemp = PuTongChallenge_Num:GetText();
	if( szTemp == "" )then 
		this:Hide();
		return ;
	end	
	if szTemp == "" then
		PushDebugMessage("请输入需要挑战的ID")
		return
	end
	if tonumber(szTemp,16) == nil then
		PushDebugMessage("请输入需要挑战的ID")
		return
	end
	-- local num = tonumber(TreasureBox_MBuy_InputNum:GetText())
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("Challenge");
		Set_XSCRIPT_ScriptID(900034);
		Set_XSCRIPT_Parameter(0,tonumber(szTemp,16))--ID
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT();
	this:Hide()

end


--===============================================
-- 取消
--===============================================
function PuTongChallengeRefuse_Clicked()

	-- PlayerPackage:CancelPuTongChallenge();
	this:Hide();
	PuTongChallenge_Num:SetProperty("DefaultEditBox", "False");
end


--===============================================
-- 输入改变
--===============================================
function PuTongChallenge_ChangeNum()

end

--===============================================
-- 个数加1
--===============================================
function PuTongChallengeAdd_Clicked()
	
	local szNum = PuTongChallenge_Num:GetText();
	local nNum = szNum + 0;
	
	-- if( nNum+1 >= g_nItemSum )then
		-- nNum = g_nItemSum-2
	-- end
	
	PuTongChallenge_Num:SetText(tostring(nNum+1));
	
end

--===============================================
-- 个数减1
--===============================================
function PuTongChallengeDecrease_Clicked()
	
	local szNum = PuTongChallenge_Num:GetText();
	local nNum = szNum + 0;

	if( nNum-1 < 1 )then
		nNum = 1
	end
	
	PuTongChallenge_Num:SetText(tostring(nNum-1));

end
