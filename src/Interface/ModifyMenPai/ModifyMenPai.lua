--- 转门派确认框
--- 2019-8-10 18:02:51 逍遥子
local g_ModifyMenPai_Frame_UnifiedXPosition;
local g_ModifyMenPai_Frame_UnifiedYPosition;
local g_menpaiId
local g_switch
local g_targetId

function ModifyMenPai_PreLoad()
	  --this:RegisterEvent("UI_COMMAND")
    --this:RegisterEvent("ADJEST_UI_POS", false)
    --this:RegisterEvent("VIEW_RESOLUTION_CHANGED", false) -- 游戏分辨率发生了变化
end

function ModifyMenPai_OnLoad()
    g_ModifyMenPai_Frame_UnifiedXPosition = ModifyMenPai_Frame:GetProperty("UnifiedXPosition");
    g_ModifyMenPai_Frame_UnifiedYPosition = ModifyMenPai_Frame:GetProperty("UnifiedYPosition");
end

-- OnEvent
function ModifyMenPai_OnEvent(event)
    if ( event == "UI_COMMAND" and tonumber(arg0) == 2115 ) then
        ModifyMenPai_Clear()
        g_switch = Get_XParam_INT(0)
        if g_switch == 5 or g_switch == 7 then --反悔
            local text1 = Get_XParam_STR(0)
            local text2 = Get_XParam_STR(1)
            local text3 = Get_XParam_STR(2)
            local text4 = Get_XParam_STR(3)
            local text5 = Get_XParam_STR(4)         
            ModifyMenPai_DragTitle:SetText(text1)
            ModifyMenPai_HowTo_Title:SetText(text2)
            ModifyMenPai_HowTo_Explain1:SetText(text3)
            ModifyMenPai_Change_Title:SetText(text4)
            ModifyMenPai_HowTo_Explain2:SetText(text5)
            g_menpaiId = Get_XParam_INT(1)
            g_targetId = Get_XParam_INT(2)
            local g_objCared = DataPool : GetNPCIDByServerID(tonumber(g_targetId))
            this:CareObject(g_objCared, 1, "ModifyMenPai");
            if (this:IsVisible()) then  
                return
            end
            ModifyMenPai_Button_Cancel:Show()
            ModifyMenPai_Button_Confirm:Show()
            ModifyMenPai_Button_Confirm:SetText("#{MPZH_180719_119}")
            ModifyMenPai_Button_Cancel:SetText("#{MPZH_180719_34}")
            this:Show()
        end
    elseif (event == "ADJEST_UI_POS") then
        ModifyMenPai_ResetPos()
    elseif (event == "VIEW_RESOLUTION_CHANGED") then
        -- 恢复默认位置
        ModifyMenPai_ResetPos()
	end
end

function ModifyMenPai_ResetPos()
   ModifyMenPai_Frame : SetProperty("UnifiedXPosition", g_ModifyMenPai_Frame_UnifiedXPosition);
   ModifyMenPai_Frame : SetProperty("UnifiedYPosition", g_ModifyMenPai_Frame_UnifiedYPosition);
end

function ModifyMenPai_Clear()
    g_menpaiId = 9
    g_switch = 0
    g_targetId = 0
end

function ModifyMenPai_OnClosed()
    ModifyMenPai_Clear()
    this:Hide()
    return
end

function ModifyMenPai_OK_Clicked()
    if g_switch == 5 then
        Clear_XSCRIPT();
          Set_XSCRIPT_Function_Name( "OnRegretContinueSwitch" );
          Set_XSCRIPT_ScriptID(900030);
          Set_XSCRIPT_Parameter(0, g_targetId);
          Set_XSCRIPT_Parameter(1, g_menpaiId);
          Set_XSCRIPT_ParamCount(2);
        Send_XSCRIPT();
    elseif g_switch ==  7 then
        Clear_XSCRIPT();
          Set_XSCRIPT_Function_Name( "OnFinalConfirmRegret" );
          Set_XSCRIPT_ScriptID(900030);
          Set_XSCRIPT_Parameter(0, g_targetId);
          Set_XSCRIPT_ParamCount(1);
        Send_XSCRIPT(); 
        ModifyMenPai_OnClosed();
    end
    
    return
end

function ModifyMenPai_Cancel_Clicked()
    ModifyMenPai_OnClosed()
    return
end

function ModifyMenPai_OnHiden()
    this:Hide()
end