local g_ZLHeroMeeting_Frame_UnifiedYPosition;
local g_ZLHeroMeeting_Frame_UnifiedYPosition;  
local g_ZLHeroMeeting_yxz_total = 0;
local g_ZLHeroMeeting_yxz_cur = 0; 
local g_ZLHeroMeeting_state = {
    0,0,0,0, 0,0,0,0
}
local g_ZLheroMeeting_needyxz = {
    30,60,100,150, 220,300,400,550,
}
local g_ZLHeroMeeting_needtext_ctl={    
}
local g_ZLHeroMeeting_needtext_check={    
}
local g_ZLHeroMeeting_needtext_tips={    
} 
local g_ZLHeroMeeting_needtext_actbtn={
}
local g_ZLHeroMeeting_item={    
    [1] = {30008027,1},
    [2] = {20800013,2},
    [3] = {39920091,60},
    [4] = {20310168,5},
    [5] = {20800013,3},
    [6] = {39920091,100},
    [7] = {20501003,1},
    [8] = {20502003,1},
} 
local g_ZLheroMeeting_maxyxz = 550

function ZLHeroMeeting_PreLoad()
	this:RegisterEvent("UI_COMMAND");
		-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED") 
	this:RegisterEvent("OBJECT_CARED_EVENT") 
	this:RegisterEvent("UPDATE_DOUBLE_EXP") 
end

function ZLHeroMeeting_OnEvent(event) 
	if( event == "ADJEST_UI_POS" ) then
		ZLHeroMeeting_ResetPos()
	elseif( event == "VIEW_RESOLUTION_CHANGED" ) then
		ZLHeroMeeting_ResetPos()
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		ZLHeroMeeting_Close()    
	elseif event == "PLAYER_LEAVE_WORLD" then
		ZLHeroMeeting_Close()
	elseif ( event == "UI_COMMAND" and tonumber( arg0 ) == 89111901 ) then		  
		if ( IsWindowShow( "ZLHeroMeeting" ) == false ) then
            ZLHeroMeeting_OnShown()
        else
            ZLHeroMeeting_Close()    
        end  
	elseif ( event == "UI_COMMAND" and tonumber( arg0 ) == 89111902 ) then
        ZLHeroMeeting_Update()
	elseif ( event == "UI_COMMAND" and tonumber( arg0 ) == 89111903 ) then
        ZLHeroMeeting_Close()
	end
end

function ZLHeroMeeting_OnLoad()  
	-- 保存界面的默认相对位置
	g_ZLHeroMeeting_Frame_UnifiedXPosition	= ZLHeroMeeting_Frame:GetProperty("UnifiedXPosition");
    g_ZLHeroMeeting_Frame_UnifiedYPosition	= ZLHeroMeeting_Frame:GetProperty("UnifiedYPosition"); 
    
    g_ZLHeroMeeting_needtext_ctl[1] = ZLHeroMeeting_oneText
    g_ZLHeroMeeting_needtext_ctl[2] = ZLHeroMeeting_twoText
    g_ZLHeroMeeting_needtext_ctl[3] = ZLHeroMeeting_threeText
    g_ZLHeroMeeting_needtext_ctl[4] = ZLHeroMeeting_fourText
    g_ZLHeroMeeting_needtext_ctl[5] = ZLHeroMeeting_fiveText
    g_ZLHeroMeeting_needtext_ctl[6] = ZLHeroMeeting_sixText
    g_ZLHeroMeeting_needtext_ctl[7] = ZLHeroMeeting_sevenText
    g_ZLHeroMeeting_needtext_ctl[8] = ZLHeroMeeting_eightText

    g_ZLHeroMeeting_needtext_check[1] = ZLHeroMeeting_Page1_oneMark
    g_ZLHeroMeeting_needtext_check[2] = ZLHeroMeeting_Page1_twoMark
    g_ZLHeroMeeting_needtext_check[3] = ZLHeroMeeting_Page1_threeMark
    g_ZLHeroMeeting_needtext_check[4] = ZLHeroMeeting_Page1_fourMark
    g_ZLHeroMeeting_needtext_check[5] = ZLHeroMeeting_Page1_fiveMark
    g_ZLHeroMeeting_needtext_check[6] = ZLHeroMeeting_Page1_sixMark
    g_ZLHeroMeeting_needtext_check[7] = ZLHeroMeeting_Page1_sevenMark
    g_ZLHeroMeeting_needtext_check[8] = ZLHeroMeeting_Page1_eightMark
    
    g_ZLHeroMeeting_needtext_tips[1] = ZLHeroMeeting_oneTips
    g_ZLHeroMeeting_needtext_tips[2] = ZLHeroMeeting_twoTips
    g_ZLHeroMeeting_needtext_tips[3] = ZLHeroMeeting_threeTips
    g_ZLHeroMeeting_needtext_tips[4] = ZLHeroMeeting_fourTips
    g_ZLHeroMeeting_needtext_tips[5] = ZLHeroMeeting_fiveTips
    g_ZLHeroMeeting_needtext_tips[6] = ZLHeroMeeting_sixTips
    g_ZLHeroMeeting_needtext_tips[7] = ZLHeroMeeting_sevenTips
    g_ZLHeroMeeting_needtext_tips[8] = ZLHeroMeeting_eightTips
 
    g_ZLHeroMeeting_needtext_actbtn[1] = ZLHeroMeeting_Page1_one
    g_ZLHeroMeeting_needtext_actbtn[2] = ZLHeroMeeting_Page1_two
    g_ZLHeroMeeting_needtext_actbtn[3] = ZLHeroMeeting_Page1_three
    g_ZLHeroMeeting_needtext_actbtn[4] = ZLHeroMeeting_Page1_four
    g_ZLHeroMeeting_needtext_actbtn[5] = ZLHeroMeeting_Page1_five
    g_ZLHeroMeeting_needtext_actbtn[6] = ZLHeroMeeting_Page1_six
    g_ZLHeroMeeting_needtext_actbtn[7] = ZLHeroMeeting_Page1_seven
    g_ZLHeroMeeting_needtext_actbtn[8] = ZLHeroMeeting_Page1_eight
    
end 

function ZLHeroMeeting_OnShown()  
    ZLHeroMeeting_Update()
	this:Show();
end 

function ZLHeroMeeting_Update() 
	 	
    g_ZLHeroMeeting_yxz_total  = Get_XParam_INT( 0 );
    g_ZLHeroMeeting_yxz_cur    = Get_XParam_INT( 1 );
    for i = 1, table.getn(g_ZLHeroMeeting_state) do
        g_ZLHeroMeeting_state[i] = Get_XParam_INT( 2 + i - 1 );
    end

    ZLHeroMeeting_BottomText:SetText(ScriptGlobal_Format("#{YXDHGN_210222_10}",g_ZLHeroMeeting_yxz_total))
   
    for index=1 , table.getn(g_ZLheroMeeting_needyxz) do
        g_ZLHeroMeeting_needtext_ctl[index]:SetText(g_ZLheroMeeting_needyxz[index])
    end

    for index=1, table.getn(g_ZLheroMeeting_needyxz) do
        if g_ZLHeroMeeting_state[index] == 1 then
            g_ZLHeroMeeting_needtext_check[index]:Show()
        else
            g_ZLHeroMeeting_needtext_check[index]:Hide()
        end
        if g_ZLHeroMeeting_yxz_total >= g_ZLheroMeeting_needyxz[index] and g_ZLHeroMeeting_state[index] == 0 then
            g_ZLHeroMeeting_needtext_tips[index]:Show()
        else
            g_ZLHeroMeeting_needtext_tips[index]:Hide()
        end
        
        local theAction = DataPool:CreateActionItemForShow(g_ZLHeroMeeting_item[index][1], g_ZLHeroMeeting_item[index][2])
		if theAction:GetID() ~= 0 then
			g_ZLHeroMeeting_needtext_actbtn[index]:SetActionItem( theAction:GetID() );
		else
			g_ZLHeroMeeting_needtext_actbtn[index]:SetActionItem( -1 );
		end
    end 
    ZLHeroMeeting_EXP:SetProgress(tonumber(g_ZLHeroMeeting_yxz_total),g_ZLheroMeeting_maxyxz)	
    ZLHeroMeeting_EXP:SetToolTip(ScriptGlobal_Format("#{YXDHGN_210222_09}",g_ZLHeroMeeting_yxz_total));

end 
--================================================
-- 界面的默认相对位置
--================================================
function ZLHeroMeeting_ResetPos()
	ZLHeroMeeting_Frame:SetProperty("UnifiedXPosition", g_ZLHeroMeetingFrame_UnifiedXPosition);
	ZLHeroMeeting_Frame:SetProperty("UnifiedYPosition", g_ZLHeroMeeting_Frame_UnifiedYPosition); 
end 

function ZLHeroMeeting_OnHiden()
    ZLHeroMeeting_Close();
end
function ZLHeroMeeting_Close() 
	this:Hide();
end
 

function ZLHeroMeeting_OnClick(index)    
	Clear_XSCRIPT()
	Set_XSCRIPT_Function_Name("GetGift_YXZ")
	Set_XSCRIPT_ScriptID(891119) 
    Set_XSCRIPT_Parameter( 0, index ); -- 参数一 
	Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
end