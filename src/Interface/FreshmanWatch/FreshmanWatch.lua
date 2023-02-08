local g_State;
--用于领取提示的时间间隔
local g_Notes = { "#{XRLJ_100104_1}", "#{XRLJ_100104_2}", "#{XRLJ_100104_3}", "#{XRLJ_100104_11}", "#{XRLJ_100104_12}", "#{XRLJ_100104_13}", "#{XRLJ_100104_14}", "#{XRLJ_100104_15}", "#{XRLJ_100104_16}", }
local g_Icons = { "set:taiwanzhuanyong2 image:taiwanzhuanyong2_2", "set:taiwanzhuanyong2 image:taiwanzhuanyong2_3", "set:taiwanzhuanyong2 image:taiwanzhuanyong2_4",
                  "set:taiwanzhuanyong2 image:taiwanzhuanyong2_5", "set:taiwanzhuanyong2 image:taiwanzhuanyong2_6", "set:taiwanzhuanyong2 image:taiwanzhuanyong2_7",
                  "set:taiwanzhuanyong2 image:taiwanzhuanyong2_8", "set:Charm5 image:Charm5_14", "set:Charm5 image:Charm5_15", "set:Charm5 image:Charm5_16" }

function FreshmanWatch_PreLoad()
    this:RegisterEvent("UI_COMMAND");
    this:RegisterEvent("OPEN_NORMAL_WATCH");
    this:RegisterEvent("COUNTDOWN_10SEC");
end

function FreshmanWatch_OnLoad()
end

function FreshmanWatch_OnEvent(event)
    if (event == "UI_COMMAND" and tonumber(arg0) == 889103) then
        local state = Get_XParam_INT(0)
        local countDownMinute = Get_XParam_INT(1)
        local isPlayerJustLogin = Get_XParam_INT(2)--表示该UICommand是玩家登陆时发送的，还是领奖成功后发送的
        g_State = state
        if state == 0 then
            this:Hide();
            FreshmanWatch_Time_Text:SetProperty("Timer", tostring(0));
            FreshmanWatch_Time_Text1:SetProperty("Timer", tostring(0));
            FlashPacketButton()
            return
        end
        this:Show();
        if countDownMinute == 0 then
            FreshmanWatch_TimeOut()
        else
            if g_State >= 1 and g_State <= 9 then
                FreshmanWatch_Icon:SetProperty("Image", g_Icons[state])
            end
            FreshmanWatch_Info:SetText("#{XRLJ_100104_5}")
            FreshmanWatch_Receive:Hide();
            FreshmanWatch_Text:Hide()
            FreshmanWatch_Min_Bk:Show()
            FreshmanWatch_Max()
            FreshmanWatch_Time_Text1:SetProperty("Timer", tostring(countDownMinute * 60));
            FreshmanWatch_Time_Text:SetProperty("Timer", tostring(countDownMinute * 60));
            FreshmanWatch_Time_Text:SetProperty("TextColor", "ff00ffff");--颜色改回蓝色
            FreshmanWatch_Time_Text1:SetProperty("TextColor", "ff00ffff");--颜色改回蓝色
            SetTimer("FreshmanWatch", "OnTimer10Sec()", countDownMinute * 60000 - 10000)
            --弹出新手指引以及背包闪烁，只能在领奖后才发生
            if state == 3 and isPlayerJustLogin ~= 1 then
                --第二次领到坐骑后，需要弹出新手指引界面
                OpenFreshmanIntro(10) --弹出的是第10套新手指引
            end
            if state ~= 1 and isPlayerJustLogin ~= 1 then
                FlashPacketButton()
                this:Hide()
            end
        end
    elseif (event == "UI_COMMAND" and arg0 == "1000000125") then
        this:Hide()
    elseif (event == "OPEN_NORMAL_WATCH") then
        this:Show()
    end
end

function FreshmanWatch_TimeOut()
    local textInfo = ""
    if g_State >= 1 and g_State <= 9 then
        textInfo = g_Notes[g_State]
    else
        textInfo = "#{XRLJ_100104_4}"
    end
    FreshmanWatch_Info:SetText(textInfo)
    FreshmanWatch_Time_Text:SetProperty("Timer", tostring(0));
    FreshmanWatch_Time_Text1:SetProperty("Timer", tostring(0));
    FreshmanWatch_Receive:Show();
    FreshmanWatch_Max()
    FreshmanWatch_Min_Bk:Hide()
    FreshmanWatch_Mini:Hide()
    FreshmanWatch_Maxi:Hide()
    FreshmanWatch_Text:Show()
    PushDebugMessage(textInfo)
    Sound:PlayUISound(38);
end

function FreshmanWatch_Bn2Click()
    Clear_XSCRIPT()
    Set_XSCRIPT_Function_Name("TakeGift")
    Set_XSCRIPT_ScriptID(889103)
    Set_XSCRIPT_Parameter(0, g_State)
    Set_XSCRIPT_ParamCount(1)
    Send_XSCRIPT()
end

function FreshmanWatch_Min()
    FreshmanWatch_Frame_sub:SetProperty("UnifiedPosition", "{{0.500000,-75.000000},{1.000000,-197.000000}}");
    FreshmanWatch_Frame_sub:SetProperty("UnifiedSize", "{{0.000000,208.000000},{0.000000,38.000000}}");
    FreshmanWatch_Info:Hide()
    FreshmanWatch_Mini:Hide()
    FreshmanWatch_Maxi:Show()
end

function FreshmanWatch_Max()
    FreshmanWatch_Frame_sub:SetProperty("UnifiedPosition", "{{0.500000,-75.000000},{1.000000,-253.000000}}");
    FreshmanWatch_Frame_sub:SetProperty("UnifiedSize", "{{0.000000,208.000000},{0.000000,94.000000}}");
    FreshmanWatch_Info:Show()
    FreshmanWatch_Mini:Show()
    FreshmanWatch_Maxi:Hide()
end

function OnTimer10Sec()
    if this:IsVisible() then
        FreshmanWatch_Time_Text1:SetProperty("TextColor", "ffff0000");
        FreshmanWatch_Time_Text:SetProperty("TextColor", "ffff0000");
    end
    KillTimer("OnTimer10Sec()")
end