local g_State;
--������ȡ��ʾ��ʱ����
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
        local isPlayerJustLogin = Get_XParam_INT(2)--��ʾ��UICommand����ҵ�½ʱ���͵ģ������콱�ɹ����͵�
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
            FreshmanWatch_Time_Text:SetProperty("Flash", tostring(0));--ֹͣ��˸
            FreshmanWatch_Time_Text:SetProperty("TextColor", "ff00ffff");--��ɫ�Ļ���ɫ
            FreshmanWatch_Time_Text1:SetProperty("TextColor", "ff00ffff");--��ɫ�Ļ���ɫ
            --��������ָ���Լ�������˸��ֻ�����콱��ŷ���
            if state == 3 and isPlayerJustLogin ~= 1 then
                --�ڶ����쵽�������Ҫ��������ָ������
                OpenFreshmanIntro(10) --�������ǵ�10������ָ��
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
    elseif (event == "COUNTDOWN_10SEC") then
        --�������ʮ���ɫ����˸
        if this:IsVisible() then
            FreshmanWatch_Time_Text1:SetProperty("TextColor", "ffff0000");
            FreshmanWatch_Time_Text:SetProperty("TextColor", "ffff0000");
            FreshmanWatch_Time_Text:SetProperty("Flash", tostring(1));
        end
    end
end

function FreshmanWatch_TimeOut()
    if g_State >= 1 and g_State <= 9 then
        FreshmanWatch_Info:SetText(g_Notes[g_State])
    else
        FreshmanWatch_Info:SetText("#{XRLJ_100104_4}")
    end
    FreshmanWatch_Time_Text:SetProperty("Timer", tostring(0));
    FreshmanWatch_Time_Text1:SetProperty("Timer", tostring(0));
    FreshmanWatch_Receive:Show();
    FreshmanWatch_Max()
    FreshmanWatch_Min_Bk:Hide()
    FreshmanWatch_Mini:Hide()
    FreshmanWatch_Maxi:Hide()
    FreshmanWatch_Text:Show()
    PushDebugMessage("#{XRLJ_100104_13}")
    PushDebugMessage("#{XRLJ_100104_14}")
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
    FreshmanWatch_Frame_sub:SetProperty("UnifiedPosition", "{{0.500000,-75.000000},{1.000000,-147.000000}}");
    FreshmanWatch_Frame_sub:SetProperty("UnifiedSize", "{{0.000000,208.000000},{0.000000,38.000000}}");
    FreshmanWatch_Info:Hide()
    FreshmanWatch_Mini:Hide()
    FreshmanWatch_Maxi:Show()
end

function FreshmanWatch_Max()
    FreshmanWatch_Frame_sub:SetProperty("UnifiedPosition", "{{0.500000,-75.000000},{1.000000,-203.000000}}");
    FreshmanWatch_Frame_sub:SetProperty("UnifiedSize", "{{0.000000,208.000000},{0.000000,94.000000}}");
    FreshmanWatch_Info:Show()
    FreshmanWatch_Mini:Show()
    FreshmanWatch_Maxi:Hide()
end

function FreshmanWatch_TimeOut1()
    --�������ʮ���ɫ����˸
    FreshmanWatch_Time_Text1:SetProperty("TextColor", "ffff0000");
    FreshmanWatch_Time_Text:SetProperty("TextColor", "ffff0000");
    FreshmanWatch_Time_Text:SetProperty("Flash", tostring(1));
end