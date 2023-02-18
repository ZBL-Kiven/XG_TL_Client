local g_Frame_UnifiedXPosition;
local g_Frame_UnifiedYPosition;
local g_CampaignTrack_myjisiji = 1
local g_campaign_today = 0    --当天所有活动

function CampaignTrack_PreLoad()
    this:RegisterEvent("UI_COMMAND");
    -- 游戏窗口尺寸发生了变化
    this:RegisterEvent("ADJEST_UI_POS")
    -- 游戏分辨率发生了变化
    this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
    this:RegisterEvent("SCENE_TRANSED")
    --离开场景，自动关闭
    this:RegisterEvent("PLAYER_LEAVE_WORLD");
end

function CampaignTrack_OnLoad()
    -- 保存界面的默认相对位置
    g_Frame_UnifiedXPosition = CampaignTrack_Frame:GetProperty("UnifiedXPosition");
    g_Frame_UnifiedYPosition = CampaignTrack_Frame:GetProperty("UnifiedYPosition");
end

function CampaignTrack_OnEvent(event)
    if event == "UI_COMMAND" and tonumber(arg0) == 201705091 then
        CampaignTrack_ListBoxTransparent:ClearAllElement();
        if DataPool:GetPlayerMission_DataRound(186) == 1 then
            this:Show();
            SetTimer("CampaignTrack", "CampaignTrack_TimerProc()", 4000)
            CampaignTrack_ResetPos()
            CampaignTrack_UpdateHaveGetMission();
            CampaignTrack_ShowORHideFunc(0)
            CampaignTrack_UnLock_Func()
        else
            CampaignTrack_CloseFunc()
        end
        return
    end
    if (event == "VIEW_RESOLUTION_CHANGED") then
        CampaignTrack_Frame:SetProperty("UnifiedPosition", "{{1.0,-266},{0,435}}");
        return ;
    end
end

--================================================
-- 界面的默认相对位置
--================================================
function CampaignTrack_ResetPos()
    CampaignTrack_Frame:SetProperty("UnifiedXPosition", g_Frame_UnifiedXPosition);
    CampaignTrack_Frame:SetProperty("UnifiedYPosition", g_Frame_UnifiedYPosition);
end

function CampaignTrackFrame_MouseEnter()
    local _, _, _, _, _, _, _, _, _, f10, _, _, _, _, _, _, _, _, _, _, _, _, _, _ = SystemSetup:GameGetData();
    local alphaStr = string.format("%f", f10)
    CampaignTrack_ListBox:SetProperty("Alpha", alphaStr)
end

function CampaignTrackFrame_MouseLeave()
    local _, _, _, _, _, _, _, _, _, f10, _, _, _, _, _, _, _, _, _, _, _, _, _, _ = SystemSetup:GameGetData();
    local alphaStr = string.format("%f", f10 / 2)
    --CampaignTrack_ListBoxTransparent:SetProperty("Alpha" , alphaStr)
    CampaignTrack_ListBox:SetProperty("Alpha", alphaStr)
end

--*****************----

function CampaignTrack_OnMoved()
end

function CampaignTrack_OnHidden()
    this:Hide();
    KillTimer("CampaignTrack_TimerProc()")
end

function CampaignTrack_WillGetFunc()
    PushDebugMessage("请点击任务面板界面的【可接任务】按钮查看当前可接任务！")
end

--  点击任务追踪的已经任务按钮, 更新列表为已接任务
--  这里关于按钮的状态处理可以省去
function CampaignTrack_HaveGetFunc()
    CampaignTrack_UpdateHaveGetMission();
end

function CampaignTrack_TimerProc()
    --蝎子刷新计时器
    g_CampaignTrack_myjisiji = g_CampaignTrack_myjisiji + 1
    local myjishiqi = math.mod(g_CampaignTrack_myjisiji, 4)
    if myjishiqi == 0 then
        CampaignTrack_UpdateHaveGetMission()
    end
end

function CampaignTrack_UpdateHaveGetMission()

    local nNum = GetCampaignCount(tonumber(g_campaign_today));
    local mTrack2 = ""
    for i = 0, nNum - 1 do
        local strTime = "";
        local strEnd = EnumCampaign(tonumber(g_campaign_today), i, "endtime");
        if (strEnd ~= -1) then
            strTime = EnumCampaign(tonumber(g_campaign_today), i, "starttime") .. "--" .. strEnd;
        else
            strTime = EnumCampaign(tonumber(g_campaign_today), i, "starttime");
        end

        ---名字time_slice
        local strHuodong = EnumCampaign(tonumber(g_campaign_today), i, "name");

        --介绍
        local strDesc = EnumCampaign(tonumber(g_campaign_today), i, "desc");
        AxTrace(5, 3, strDesc);
        local isCur = EnumCampaign(tonumber(g_campaign_today), i, "iscurcampaign");
        if (tonumber(isCur) == 1) then
            mTrack2 = mTrack2 .. "#cffcc00  " .. strTime .. "  #G" .. strHuodong .. "#r    #W" .. strDesc .. "#r"
        end
    end
    CampaignTrack_ListBoxTransparent:ClearAllElement();
    CampaignTrack_ListBoxTransparent:AddTextElement(mTrack2)
end

function CampaignTrack_Lock_Func()
    CampaignTrack_UnLock:Show();
    CampaignTrack_Lock:Hide();
    CampaignTrack_Close:Hide();
    CampaignTrack_DragTitle:Hide()
end

function CampaignTrack_UnLock_Func()
    CampaignTrack_UnLock:Hide();
    CampaignTrack_Lock:Show();
    CampaignTrack_Close:Show();
    CampaignTrack_DragTitle:Show()
end

--  鼠标进入, 显示界面尺寸控制条
function CampaignTrack_Func_MouseEnter()
    CampaignTrack_ShowORHideFunc(0); --一直影藏
end

--  鼠标离开, 隐藏界面尺寸控制条
function CampaignTrack_Func_MouseLeave()
    CampaignTrack_ShowORHideFunc(0);
end

--  隐藏或显示界面尺寸控制条
function CampaignTrack_ShowORHideFunc(nShow)

    if nShow >= 1 then
        CampaignTrack_Extend:Show();
        CampaignTrack_Reduce:Show();
        CampaignTrack_Add:Show();
        CampaignTrack_Sub:Show();
        CampaignTrack_Reset:Show();
        CampaignTrack_Function_FrameBK:Show();
    else
        CampaignTrack_Extend:Hide();
        CampaignTrack_Reduce:Hide();
        CampaignTrack_Add:Hide();
        CampaignTrack_Sub:Hide();
        CampaignTrack_Reset:Hide();
        CampaignTrack_Function_FrameBK:Hide();
        CampaignTrackFrame_MouseLeave()
    end
end

function CampaignTrack_CloseFunc()
    this:Hide();
    KillTimer("CampaignTrack_TimerProc()")
end
