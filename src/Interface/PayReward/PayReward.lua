
--writer By UK QQ 2269169441
local PayReward_Button = {}			--�콱��ť
local PayReward_Button_Tip = {}
local PayReward_Frame2_Bk1_IconSuSu = {}	
local PayReward_ButtonState = {			-- ��ť״̬ 0:δ���/1:����ȡ/2:����ȡ
	[1] = 0,
	[2] = 0,
	[3] = 0,
	[4] = 0,
}

local g_PayReward_NeedPrize = {}


--**********************************
-- PRELOAD
--**********************************
function PayReward_PreLoad()

	this:RegisterEvent("OPEN_SHOUKAIKA")		-- ��UI
	this:RegisterEvent("PLAYER_LEAVE_WORLD")	-- �뿪����
	this:RegisterEvent("UI_COMMAND")			-- ����

end


--**********************************
-- ONLOAD
--**********************************
function PayReward_OnLoad()

	PayReward_Button[ 1 ] = PayReward_Frame2_Bk1_Button
	PayReward_Button[ 2 ] = PayReward_Frame2_Bk2_Button
	PayReward_Button[ 3 ] = PayReward_Frame2_Bk3_Button
	PayReward_Button[ 4 ] = PayReward_Frame2_Bk4_Button
	
	
	PayReward_Button_Tip[ 1 ] = PayReward_Frame2_Bk1_Button_tips
	PayReward_Button_Tip[ 2 ] = PayReward_Frame2_Bk2_Button_tips
	PayReward_Button_Tip[ 3 ] = PayReward_Frame2_Bk3_Button_tips
	PayReward_Button_Tip[ 4 ] = PayReward_Frame2_Bk4_Button_tips
	PayReward_Frame2_Bk1_IconSuSu[ 1 ] = {PayReward_Frame2_Bk1_Icon2,PayReward_Frame2_Bk1_Icon3,PayReward_Frame2_Bk1_Icon4,PayReward_Frame2_Bk1_Icon5}
	PayReward_Frame2_Bk1_IconSuSu[ 2 ] = {PayReward_Frame2_Bk2_Icon2,PayReward_Frame2_Bk2_Icon3,PayReward_Frame2_Bk2_Icon4,PayReward_Frame2_Bk2_Icon5}
	PayReward_Frame2_Bk1_IconSuSu[ 3 ] = {PayReward_Frame2_Bk3_Icon2,PayReward_Frame2_Bk3_Icon3,PayReward_Frame2_Bk3_Icon4,PayReward_Frame2_Bk3_Icon5}
	PayReward_Frame2_Bk1_IconSuSu[ 4 ] = {PayReward_Frame2_Bk4_Icon2,PayReward_Frame2_Bk4_Icon3,PayReward_Frame2_Bk4_Icon4,PayReward_Frame2_Bk4_Icon5}
	g_myitemlist[ 1 ] = {30900131,10157001,38000185,0}
	g_myitemlist[ 2 ] = {30900131,38000951,38000448,0}
	g_myitemlist[ 3 ] = {30900132,38000448,38002049,20310197}
	g_myitemlist[ 4 ] = {20310200,20800033,20310198,20310199}
	
	g_PayReward_NeedPrize[1] = PayReward_Frame2_Bk1_Text1_2
	g_PayReward_NeedPrize[2] = PayReward_Frame2_Bk2_Text1_2
	g_PayReward_NeedPrize[3] = PayReward_Frame2_Bk3_Text1_2
	g_PayReward_NeedPrize[4] = PayReward_Frame2_Bk4_Text1_2
	
end


--**********************************
-- ONEvent
--**********************************
function PayReward_OnEvent( event )

	if ( event == "UI_COMMAND" and tonumber( arg0 ) == 201910121 ) then
		if Get_XParam_INT(0) == 12222 then
			GameProduceLogin:OpenURL(Get_XParam_STR(0))
			return
		end	
		PayReward_ButtonState = {0,0,0,0}
		-- if ( IsWindowShow( "PayReward" ) == true ) then
			PayReward_UpdateButton()
			-- return
		-- end
		-- ����
		PayReward_UpdateButtonReq()
		this:Show()
	elseif ( event == "PLAYER_LEAVE_WORLD" ) then
		this:Hide()
	elseif ( event == "UI_COMMAND" and tonumber( arg0 ) == 88985321 ) then

		if ( IsWindowShow( "PayReward" ) == false ) then
			return
		end

		-- PayReward_ButtonState[ 1 ] = Get_XParam_INT( 0 )
		-- PayReward_ButtonState[ 2 ] = Get_XParam_INT( 1 )
		-- PayReward_ButtonState[ 3 ] = Get_XParam_INT( 2 )
		-- PayReward_ButtonState[ 4 ] = Get_XParam_INT( 3 )
		mdExch = Get_XParam_INT( 4 )
		-- ����Btn״̬
		-- PayReward_UpdateButtonAck()
	end

end

--**********************************
-- ��������
--**********************************
function PayReward_UpdateData( )

	-- ����Icon
	-- PayReward_UpdateIcon()
	
	-- PayReward_UpdateButton()
	
	PayReward_UpdateText()

end


--**********************************
-- ����checkbox
--**********************************
function PayReward_UpdateCheckBox( nIndex )


end


--**********************************
-- ����Button
--**********************************
function PayReward_UpdateButton()	
	for nIndex = 1 , 4 do
		if Get_XParam_INT(2) >= nIndex then
			PayReward_Button[ nIndex ] : Disable()
			PayReward_Button[ nIndex ] : SetProperty( "DisabledImage" , "set:ServerNewUI2 image:ServerNewUI_LQ_Disable")
			PayReward_Button_Tip[ nIndex ] : Show()
		else
			if Get_XParam_INT(0) >= Get_XParam_INT(nIndex+2) then
				PayReward_Button[ nIndex ] : Enable()
				PayReward_Button_Tip[ nIndex ] : Hide()				
			else
				PayReward_Button[ nIndex ] : Disable()
				PayReward_Button[ nIndex ] : SetProperty( "DisabledImage" , "set:ServerNewUI2 image:ServerNewUI_LQ_WDC")
				PayReward_Button_Tip[ nIndex ] : Show()
				PayReward_Button_Tip[ nIndex ] : SetToolTip("#{SCJMY_150325_5}")
			end
		end	
	end
end


--**********************************
-- ����Icon
--**********************************
function PayReward_UpdateIcon()
    for i = 1,4 do
	for j = 1,4 do
	PayReward_Frame2_Bk1_IconSuSu[i][j] : SetActionItem( -1 )
	PayReward_Frame2_Bk1_IconSuSu[i][j] : Hide()
	local theAction0  = GemCarve:UpdateProductAction( g_myitemlist[i][j] )
	if ( theAction0 : GetID() ~= 0 ) then
		PayReward_Frame2_Bk1_IconSuSu[i][j] : SetActionItem( theAction0 : GetID() )
		PayReward_Frame2_Bk1_IconSuSu[i][j] : Show()
	end
    end	
	end

end


--**********************************
-- �������Button
--**********************************
function PayReward_UpdateButtonReq()
	
	-- �ȼ�
	--[[
	local nLevel = Player:GetLevel()
	if ( nLevel < 15 ) then
		return
	end
    --]]
	-- ִ�нű�
	-- Clear_XSCRIPT()
		-- Set_XSCRIPT_Function_Name( "UpdateGetPrizeBtnState" ) 
		-- Set_XSCRIPT_ScriptID( 889853 )
		-- Set_XSCRIPT_ParamCount( 0 )
	-- Send_XSCRIPT()
	local g_myitem = {}--����List
	local g_myitemlist = {}
	for i = 1,4 do
		g_myitem[i] = Get_XParam_STR(i-1)
		g_myitemlist[i] = Split(g_myitem[i], ",")
		if g_myitemlist[i] ~= nil and g_myitemlist[i] ~= "" then
			for j = 1,4 do
				PayReward_Frame2_Bk1_IconSuSu[i][j]:Hide()
				local start,ends = j*2-1,j*2
				if g_myitemlist[i][start] ~= "" and g_myitemlist[i][start] ~= nil then
					local PrizeAction = GemMelting:UpdateProductAction(tonumber(g_myitemlist[i][start]))
					PayReward_Frame2_Bk1_IconSuSu[i][j]:SetProperty("CornerChar", string.format( "BotRight %s", g_myitemlist[i][ends] ));
					PayReward_Frame2_Bk1_IconSuSu[i][j]:SetActionItem(PrizeAction:GetID())
					PayReward_Frame2_Bk1_IconSuSu[i][j]:Show()
				end
			end
		end
	end
	local MyDayPrize = DataPool:GetPlayerMission_DataRound(473)
	for i = 1,4 do
		local Point = Get_XParam_INT(i+2)
		if MyDayPrize >= Point  then
			g_PayReward_NeedPrize[i]:SetText(string.format("#G%s/%s��",Point,Point))
		else
			g_PayReward_NeedPrize[i]:SetText(string.format("#cff0000%s/%s��",MyDayPrize,Point))
		end
	end
	PayReward_Blank_Text:SetText(string.format("�����ۼƳ�ֵ��%s��",MyDayPrize))
end


--**********************************
-- ��������Button
--**********************************
function PayReward_UpdateButtonAck()
	PayReward_UpdateData( )
end


--**********************************
-- ����Text
--**********************************
function PayReward_UpdateText()

	local txtInfo = string.format( "#cfff263�������Ѿ��ۼƶһ���#G%s��ֵ��#cfff263��", mdExch)
	PayReward_Blank_Text : SetText( txtInfo )
	

	if PayReward_ButtonState[ 1 ] == 1 or PayReward_ButtonState[ 1 ] == 2 then	
		PayReward_Frame2_Bk1_Text1_1:SetText("#{SCJMY_150325_10}")
		PayReward_Frame2_Bk1_Text1_2:SetText("#{SCJMY_150325_4}")

	
	else
		
		if mdExch >= 50 then
			PayReward_Frame2_Bk1_Text1_1:SetText("#{SCJMY_150325_10}")	
			PayReward_Frame2_Bk1_Text1_2:SetText("#{SCJMY_150325_4}")	
		else
			PayReward_Frame2_Bk1_Text1_1:SetText("#{SCJMY_150325_1}")	
			txtInfo = string.format( "#cff0000%s/50Ԫ", mdExch )
			PayReward_Frame2_Bk1_Text1_2:SetText(txtInfo)
		end
		
	end	
	
	if PayReward_ButtonState[ 2 ] == 1 or PayReward_ButtonState[ 2 ] == 2 then	
		PayReward_Frame2_Bk2_Text1_1:SetText("#{SCJMY_150325_10}")
		PayReward_Frame2_Bk2_Text1_2:SetText("#{SCJMY_150325_12}")
	
	else
		
		if mdExch >= 100 then
			PayReward_Frame2_Bk2_Text1_1:SetText("#{SCJMY_150325_10}")	
			PayReward_Frame2_Bk2_Text1_2:SetText("#{SCJMY_150325_12}")	
		else
			PayReward_Frame2_Bk2_Text1_1:SetText("#{SCJMY_150325_1}")	
			txtInfo = string.format( "#cff0000%s/100Ԫ", mdExch )
			PayReward_Frame2_Bk2_Text1_2:SetText(txtInfo)
		end
		
	end
	
	
	if PayReward_ButtonState[ 3 ] == 1 or PayReward_ButtonState[ 3 ] == 2 then	
		PayReward_Frame2_Bk3_Text1_1:SetText("#{SCJMY_150325_10}")
		PayReward_Frame2_Bk3_Text1_2:SetText("#{SCJMY_150325_15}")

	
	else
		
		local nValue = mdExch
		if mdExch >= 300 then
			PayReward_Frame2_Bk3_Text1_1:SetText("#{SCJMY_150325_10}")
			PayReward_Frame2_Bk3_Text1_2:SetText("#{SCJMY_150325_15}")
		else
			PayReward_Frame2_Bk3_Text1_1:SetText("#{SCJMY_150325_1}")
			txtInfo = string.format( "#cff0000%s/300Ԫ", mdExch )
			PayReward_Frame2_Bk3_Text1_2:SetText(txtInfo)
		end
		

	end



	if PayReward_ButtonState[ 4 ] == 1 or PayReward_ButtonState[ 4 ] == 2 then	
		PayReward_Frame2_Bk4_Text1_1:SetText("#{SCJMY_150325_10}")
		PayReward_Frame2_Bk4_Text1_2:SetText("#{SCJMY_150325_18}")
	
	else
		
		local nValue = mdExch
		if mdExch >= 500 then
			PayReward_Frame2_Bk4_Text1_1:SetText("#{SCJMY_150325_10}")
			PayReward_Frame2_Bk4_Text1_2:SetText("#{SCJMY_150325_18}")
		else
			PayReward_Frame2_Bk4_Text1_1:SetText("#{SCJMY_150325_1}")
			txtInfo = string.format( "#cff0000%s/500Ԫ", mdExch )
			PayReward_Frame2_Bk4_Text1_2:SetText(txtInfo)
		end
		

	end	


end


--**********************************
-- CheckBox
--**********************************
function PayReward_CheckBoxClicked( nIdx )

	

end


--**********************************
-- ��ť
--**********************************
function PayReward_Clicked( nIdx )

	-- ִ�нű�
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "UpdateGetPrizeBtnState" )				-- �ű���
		Set_XSCRIPT_ScriptID( 889853 );											-- �ű����
		Set_XSCRIPT_Parameter( 0, 2 )					-- ����һ
		Set_XSCRIPT_Parameter( 1, tonumber( nIdx ) )					-- ����һ
		Set_XSCRIPT_ParamCount( 2 )												-- ��������
	Send_XSCRIPT()
end


--**********************************
-- �ر�
--**********************************
function PayReward_OnHiden()
    for i = 1,4 do
	for j = 1,4 do
	PayReward_Frame2_Bk1_IconSuSu[i][j] : SetActionItem( -1 )
    end	
	end
	
end
