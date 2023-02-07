--相关的C＋＋代码在“GMGameInterface_Script_Package”中

local g_nItemSum = 0;
local nServerstring_1 = ""
local nServerstring_2 = ""
--===============================================
-- PreLoad()
--===============================================
function ShengSiChallenge_PreLoad()
	this:RegisterEvent("SHOW_SPLIT_ITEM");
	this:RegisterEvent("HIDE_SPLIT_ITEM");
	this:RegisterEvent("UI_COMMAND");
end

--===============================================
-- OnLoad()
--===============================================
function ShengSiChallenge_OnLoad()
	
end

--===============================================
-- OnEvent()
--===============================================
function ShengSiChallenge_OnEvent(event)

	if(event == "UI_COMMAND" and tonumber(arg0) == 20210523 ) then
		nServerstring_1 =  Get_XParam_STR(0)
		nServerstring_2 =  Get_XParam_STR(1)
		ShengSiChallenge_Num:SetText("1");
		ShengSiChallenge_NID:SetText("");
		ShengSiChallenge_Num:SetSelected( 0, -1 );
		ShengSiChallenge_NID:SetSelected( 0, -1 );
		ShengSiChallenge_ItemName:SetText("输入元宝")
		ShengSiChallenge_ItemName2:SetText("输入挑战者ID")
		this:Show();		
		--设置缺省的光标
		ShengSiChallenge_Num:SetProperty("DefaultEditBox", "True");
		
		-- ShengSiChallenge_Update();

	elseif( event == "HIDE_SPLIT_ITEM")	 then
		this:Hide();		
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 202105231 ) then
		PushEvent("UI_COMMAND",202105232,Get_XParam_STR(0),Get_XParam_INT(0),Get_XParam_INT(1))
	end

end
function ShengSiChallenge_MBuy_Update2( tbIndex, shoptype, curpage)
	
end

--===============================================
-- Update()
--===============================================
function ShengSiChallenge_Update()

	ShengSiChallenge_ItemName:SetText(PlayerPackage:GetSplitName());
	
end

--===============================================
-- 点击确定
--===============================================
function ShengSiChallengeAccept_Clicked()

	local szTemp = ShengSiChallenge_Num:GetText();
	local szTeID = ShengSiChallenge_NID:GetText();
	if( szTemp == "" )then 
		this:Hide();
		return ;
	end	
	if( szTeID == "" )then 
		this:Hide();
		return ;
	end	
	local nNum = szTemp + 0;
	if nNum < 1 then
		PushDebugMessage(nServerstring_2)
		return
	end
	if szTeID == "" then
		PushDebugMessage("请输入需要挑战的ID")
		return
	end
	if tonumber(szTeID,16) == nil then
		return
	end
	-- local num = tonumber(TreasureBox_MBuy_InputNum:GetText())
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("Challenge");
		Set_XSCRIPT_ScriptID(900034);
		Set_XSCRIPT_Parameter(0,nNum)--元宝
		Set_XSCRIPT_Parameter(1,tonumber(szTeID,16))--ID
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT();
	this:Hide()

end


--===============================================
-- 取消
--===============================================
function ShengSiChallengeRefuse_Clicked()

	-- PlayerPackage:CancelShengSiChallenge();
	this:Hide();
	ShengSiChallenge_Num:SetProperty("DefaultEditBox", "False");
end


--===============================================
-- 输入改变
--===============================================
function ShengSiChallenge_ChangeNum()

end

--===============================================
-- 个数加1
--===============================================
function ShengSiChallengeAdd_Clicked()
	
	local szNum = ShengSiChallenge_Num:GetText();
	local nNum = szNum + 0;
	
	-- if( nNum+1 >= g_nItemSum )then
		-- nNum = g_nItemSum-2
	-- end
	
	ShengSiChallenge_Num:SetText(tostring(nNum+1));
	
end

--===============================================
-- 个数减1
--===============================================
function ShengSiChallengeDecrease_Clicked()
	
	local szNum = ShengSiChallenge_Num:GetText();
	local nNum = szNum + 0;

	if( nNum-1 < 1 )then
		nNum = 1
	end
	
	ShengSiChallenge_Num:SetText(tostring(nNum-1));

end
