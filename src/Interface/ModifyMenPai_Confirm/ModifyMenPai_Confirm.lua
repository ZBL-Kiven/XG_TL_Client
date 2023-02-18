--- 转门派属性确认框
--build 2019-8-10 18:03:48 逍遥子
local g_ModifyMenPai_Confirm_Frame_UnifiedXPosition;
local g_ModifyMenPai_Confirm_Frame_UnifiedYPosition;
local g_menpaiId
local g_targetId
local MP_SHAOLIN  = 0
local MP_MINGJIAO = 1
local MP_GAIBANG  = 2
local MP_WUDANG   = 3
local MP_EMEI     = 4
local MP_XINGSU   = 5
local MP_DALI     = 6
local MP_TIANSHAN = 7
local MP_XIAOYAO  = 8
local MP_WUMENPAI = 9
local MP_GUSU     = 10
local MP_TANGMEN  = 11 --xinmenpai
local MP_GUIGU    = 12 --
local MP_TAOHUADAO= 13
local MP_COUNT    = 14  --用来做判断使用的，最大不能超过这个数，如果需要新增门派，在这个宏之前增加，并修改这个宏的值
local g_switchImage = {
  [MP_SHAOLIN] = "set:ModifyMenPai2 image:Modify_ShaoLin",
  [MP_MINGJIAO] = "set:ModifyMenPai2 image:Modify_MingJiao",
  [MP_GAIBANG] = "set:ModifyMenPai image:Modify_GaiBang",
  [MP_WUDANG] = "set:ModifyMenPai4 image:Modify_WuDang",
  [MP_EMEI] = "set:ModifyMenPai image:Modify_Emei",
  [MP_XINGSU] = "set:ModifyMenPai4 image:Modify_XingXiu",
  [MP_DALI] = "set:ModifyMenPai3 image:Modify_TianLong",
  [MP_TIANSHAN] = "set:ModifyMenPai3 image:Modify_TianShan",
  [MP_XIAOYAO] = "set:ModifyMenPai4 image:Modify_XiaoYao",
  [MP_GUSU] = "set:ModifyMenPai2 image:Modify_MuRong",
  [MP_TANGMEN] = "set:ModifyMenPai3 image:Modify_TangMen",
  [MP_GUIGU] = "set:ModifyMenPai image:Modify_GuiGu",
  [MP_TAOHUADAO] = "set:ModifyMenPai14 image:Modify_TaoHuaDao",														   
}

function ModifyMenPai_Confirm_PreLoad()
	this:RegisterEvent("UI_COMMAND")
    this:RegisterEvent("ADJEST_UI_POS", false)
    this:RegisterEvent("VIEW_RESOLUTION_CHANGED", false) -- 游戏分辨率发生了变化
end

function ModifyMenPai_Confirm_OnLoad()
    g_ModifyMenPai_Confirm_Frame_UnifiedXPosition = ModifyMenPai_Confirm_FrameNULL:GetProperty("UnifiedXPosition");
    g_ModifyMenPai_Confirm_Frame_UnifiedYPosition = ModifyMenPai_Confirm_FrameNULL:GetProperty("UnifiedYPosition");
end

-- OnEvent
function ModifyMenPai_Confirm_OnEvent(event)
    if ( event == "UI_COMMAND" and tonumber(arg0) == 2115 ) then
        --ModifyMenPai_Confirm_Clear()
        g_switch = Get_XParam_INT(0)
			if g_switch == 77 then
            local tip = Get_XParam_STR(0)  
            local str = Get_XParam_STR(1)  
            g_targetId = Get_XParam_INT(1)
            local g_oldmenpaiId = Get_XParam_INT(2)
            g_menpaiId = Get_XParam_INT(3)
				local nCold = Get_XParam_INT(4)
				local nFire = Get_XParam_INT(5)
				local nLight = Get_XParam_INT(6)
				local nPoison = Get_XParam_INT(7)
            --ModifyMenPai_Confirm_DragTitle:SetText("#{MPZH_180719_100}")         
            --ModifyMenPai_Confirm_Text:SetText(text)
            ModifyMenPai_Confirm_ConfirmText:SetText(tip)
            ModifyMenPai_Confirm_CurrentAttribute1:SetText(string.format("#cfff263冰攻：#G%s#cfff263", nCold))
            ModifyMenPai_Confirm_CurrentAttribute2:SetText(string.format("#cfff263火攻：#G%s#cfff263", nFire))
            ModifyMenPai_Confirm_CurrentAttribute3:SetText(string.format("#cfff263玄攻：#G%s#cfff263", nLight))
            ModifyMenPai_Confirm_CurrentAttribute4:SetText(string.format("#cfff263毒攻：#G%s#cfff263", nPoison))
            ModifyMenPai_Confirm_ChangeAttribute:SetText(str)
            ModifyMenPai_Confirm_Button1_BK:SetProperty("Image", g_switchImage[g_oldmenpaiId])
            ModifyMenPai_Confirm_Button1_BK2:SetProperty("Image", g_switchImage[g_menpaiId])

            local g_objCared = DataPool : GetNPCIDByServerID(tonumber(g_targetId))
            this:CareObject(g_objCared, 1, "ModifyMenPai_Confirm");
            if (this:IsVisible()) then  
                return
            end
            this:Show()
        elseif g_switch == 8 then
            local tip = Get_XParam_STR(0)  
            local str = Get_XParam_STR(1)  
            g_targetId = Get_XParam_INT(1)
            local g_oldmenpaiId = Get_XParam_INT(2)
            g_menpaiId = Get_XParam_INT(3)
						local nCold = Get_XParam_INT(4)
						local nFire = Get_XParam_INT(5)
						local nLight = Get_XParam_INT(6)
						local nPoison = Get_XParam_INT(7)
            --ModifyMenPai_Confirm_DragTitle:SetText("#{MPZH_180719_100}")         
            --ModifyMenPai_Confirm_Text:SetText(text)
            ModifyMenPai_Confirm_ConfirmText:SetText(tip)
            ModifyMenPai_Confirm_CurrentAttribute1:SetText(string.format("#cfff263冰攻：#G%s#cfff263", nCold))
            ModifyMenPai_Confirm_CurrentAttribute2:SetText(string.format("#cfff263火攻：#G%s#cfff263", nFire))
            ModifyMenPai_Confirm_CurrentAttribute3:SetText(string.format("#cfff263玄攻：#G%s#cfff263", nLight))
            ModifyMenPai_Confirm_CurrentAttribute4:SetText(string.format("#cfff263毒攻：#G%s#cfff263", nPoison))
            ModifyMenPai_Confirm_ChangeAttribute:SetText(str)
            ModifyMenPai_Confirm_Button1_BK:SetProperty("Image", g_switchImage[g_oldmenpaiId])
            ModifyMenPai_Confirm_Button1_BK2:SetProperty("Image", g_switchImage[g_menpaiId])

            local g_objCared = DataPool : GetNPCIDByServerID(tonumber(g_targetId))
            this:CareObject(g_objCared, 1, "ModifyMenPai_Confirm");
            if (this:IsVisible()) then  
                return
            end
            this:Show()
        end
    elseif (event == "ADJEST_UI_POS" ) then
        ModifyMenPai_Confirm_ResetPos()
    elseif ( event == "VIEW_RESOLUTION_CHANGED" ) then
            -- 恢复默认位置
        ModifyMenPai_Confirm_ResetPos()
	  end
end

function ModifyMenPai_Confirm_ResetPos()
   ModifyMenPai_Confirm_FrameNULL : SetProperty("UnifiedXPosition", g_ModifyMenPai_Confirm_Frame_UnifiedXPosition);
   ModifyMenPai_Confirm_FrameNULL : SetProperty("UnifiedYPosition", g_ModifyMenPai_Confirm_Frame_UnifiedYPosition);
end

function ModifyMenPai_Confirm_Clear()
   g_targetId = 0
   g_menpaiId = 9
end

function ModifyMenPai_Confirm_OnClosed()
    ModifyMenPai_Confirm_Clear()
    this:Hide()
    return
end

function ModifyMenPai_Confirm_Close_Clicked()
    ModifyMenPai_Confirm_OnClosed()
    return
end

function ModifyMenPai_Confirm_OK_Clicked()
		if g_switch == 77 then
        Clear_XSCRIPT();
            Set_XSCRIPT_Function_Name("OnFinalConfirmSwitch");
            Set_XSCRIPT_ScriptID(900030);
            Set_XSCRIPT_Parameter(0, g_targetId);
            Set_XSCRIPT_Parameter(1, g_menpaiId);
            Set_XSCRIPT_ParamCount(2);
        Send_XSCRIPT();
        ModifyMenPai_Confirm_OnClosed()
    elseif g_switch == 8 then
        Clear_XSCRIPT();
            Set_XSCRIPT_Function_Name("OnFinalConfirmRegret");
            Set_XSCRIPT_ScriptID(900030);
            Set_XSCRIPT_Parameter(0, g_targetId);
            Set_XSCRIPT_ParamCount(1);
        Send_XSCRIPT();
        ModifyMenPai_Confirm_OnClosed()
    end
    
    return
end

function ModifyMenPai_ConfirmFrame_CloseWindow()
    ModifyMenPai_Confirm_OnClosed()
    return
end
