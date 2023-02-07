local bBeingRadio = 0;                  --
--local MissionType = {};               --  废弃, 而且还继续被重定义, 避免错误, 在此取消定义
local MissionPucker = {};               --  已接任务的分类折叠标志, 1: 非折叠, 0: 折叠
local Current_Select;                   --  当前选择任务
local First_Open = 1;                   --  首次打开?
local MissionParam_Index = 0;           --  任务变量索引
local HaveGetMissionNum = 0;            --  已接任务数量

local LEVEL_TO_MY_LEVEL = 10000;        --  与玩家等级一致的任务等级

local g_nMissionNum = 20;               --  最大可接任务数

local MissionOutlineDeploy = {}         --  未接任务的分类折叠标志, 1: 非折叠, 0: 折叠

local CurList                           -- 1为任务列表,2为任务索引

local Current_Clicked = -1;
--TT53675对所有不符合规范，没有将missionparam第0位做为任务完成标志的任务脚本做特殊处理,需要特殊处理的任务脚本号列表：
local SpecialMissionList = {200006,200031}

-- 界面的默认相对位置
local g_QuestLog_Frame_UnifiedXPosition;
local g_QuestLog_Frame_UnifiedYPosition;

local g_QuestLog_LastSelect=-1;                   --  当前选择任务

local g_MenPai_Special_id = 0

--  界面预加载...
function QuestLog_PreLoad()
    this:RegisterEvent("TOGLE_MISSION");
    this:RegisterEvent("UPDATE_MISSION");
    this:RegisterEvent("PACKAGE_ITEM_CHANGED");
    this:RegisterEvent("UPDATE_DOUBLE_EXP");
    this:RegisterEvent("UPDATE_QUESTTIME");
    this:RegisterEvent("NEW_MISSION");
    this:RegisterEvent("DELETE_MISSION");
    this:RegisterEvent("TOGLE_MISSION_OUTLINE");
    this:RegisterEvent("UI_COMMAND")
    this:RegisterEvent("OPEN_FROM_MISSIONTRACK");
    this:RegisterEvent("UPDATE_QUESTLOG_BY_TRACK");
    this:RegisterEvent("UPDATE_TRACK_STATE_BUTTON");

    -- 游戏窗口尺寸发生了变化
    this:RegisterEvent("ADJEST_UI_POS")

    -- 游戏分辨率发生了变化
    this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

--  界面首次加载初始化, 所有任务类型折叠标志为展开, 记录界面的初始位置
function QuestLog_OnLoad()

    local i=1;
    for i=1,200 do
        MissionPucker[i] = 1;
    end;

    for i=1,200 do
        MissionOutlineDeploy[ i ] = 1  --任务索引默认都为展开
    end

    First_Open = 1;
    CurList = 1

    -- 保存界面的默认相对位置
    g_QuestLog_Frame_UnifiedXPosition    = QuestLog_Frame : GetProperty("UnifiedXPosition");
    g_QuestLog_Frame_UnifiedYPosition    = QuestLog_Frame : GetProperty("UnifiedYPosition");

end

--  界面事件处理
--  因为同一时刻只会有一个事件, 因此不用处理多个if的情况
function QuestLog_OnEvent(event)
--    if(this:IsVisible()) then
--        QuestLog_OnShown();
--        return;
--    end

    --PushDebugMessage("event = " .. event)

	g_MenPai_Special_id = 0

    if(event == "UI_COMMAND" and tonumber(arg0) == 831020) then
        QuestLog_UpdateListbox();
        QuestLog_UpdateMissionOutline();
        QuestLog_ShowWindow();
    elseif(event == "TOGLE_MISSION" or (event == "UI_COMMAND" and tonumber(arg0) == 110921)) then
		if tonumber(arg0) == 110921 then
			g_MenPai_Special_id = 1
		end

        QuestLog_UpdateListbox();
        QuestLog_ShowWindow();
    elseif(event == "TOGLE_MISSION_OUTLINE" ) then
        QuestLog_UpdateMissionOutline();
        QuestLog_ShowWindow();
    elseif(event == "UPDATE_MISSION" ) then
        if not this:IsVisible() then
            return;
        end
        if (CurList == 1) then
            QuestLog_UpdateListbox();
        end
    elseif(event == "PACKAGE_ITEM_CHANGED" ) then
        if not this:IsVisible() then
            return;
        end
        if CurList == 1 then
            QuestLog_UpdateListbox();
        end
    elseif(event == "UPDATE_DOUBLE_EXP" ) then
        local DT = SystemSetup : GetDoubleExp("remaintime");
        QuestLog_Watch:SetProperty("Timer",DT);
    elseif(event == "UPDATE_QUESTTIME") then
        if not this:IsVisible() then
            return;
        end

        if( 2 == CurList ) then
            return    --这个消息是用来更新任务计时的,当当前选中项为任务索引时,则不应该进行更新.
        end

        if arg0 ~= nil and tonumber(arg0) <= 20 and tonumber(arg0) >= 0 then
            if tonumber(arg0) == Current_Select then
                QuestLog_ListBox_SelectChanged()
            end
        end
    elseif(event == "NEW_MISSION" ) then
        Current_Select = tonumber(arg0)
        if not this:IsVisible() then
            return;
        else
            QuestLog_UpdateListbox();
        end
    elseif(event == "DELETE_MISSION") then
        if Current_Select == tonumber(arg0) then
            DataPool:GetPlayerMission_DelActivePos(Current_Select);
            return;
        end
    elseif (event == "OPEN_FROM_MISSIONTRACK") then
        Current_Select = tonumber(arg0)
        if not this:IsVisible() then
            First_Open = 0;

            --全部展开
            for i=1,200 do
                MissionPucker[i] = 1;
            end;

            QuestLog_UpdateListbox();
            QuestLog_ShowWindow();
        else
            --QuestLog_UpdateListbox();
            this:Hide();
        end
    elseif (event == "UPDATE_QUESTLOG_BY_TRACK") then
        if this:IsVisible() then
            QuestLog_UpdateListbox();
        end
    elseif (event == "UPDATE_TRACK_STATE_BUTTON") then
        local nType = tonumber(arg0);
        if not this:IsVisible() then
            return;
        end
    -- 游戏窗口尺寸发生了变化
    elseif (event == "ADJEST_UI_POS" ) then
        -- 更新背包界面位置
        QuestLog_Frame_On_ResetPos()

    -- 游戏分辨率发生了变化
    elseif (event == "VIEW_RESOLUTION_CHANGED") then
        -- 更新背包界面位置
        QuestLog_Frame_On_ResetPos()
    end
end

--2011Q3新手任务ui指引
function QuestLog_OnShown()     
    QuestLog_FreshManGuide(1, 1, 1)
end
function QuestLog_OnMoved()

end
function QuestLog_OnHidden()

end

--  活动日程按钮点击回调
function QuestLog_HitRiCheng()
    OpenTodayCampaignList();
end

--  更新可接任务类型
--  采取短路写法, 尽快返回, 减少缩进
function QuestLog_UpdateMissionType( iMissionType )
    local strOutlineName = ""
    --  构造任务类型名称和显示颜色
    if( 1 == MissionOutlineDeploy[ iMissionType ] ) then
        strOutlineName = "#gFE7E82- " .. DataPool:GetMissionInfo_Kind( iMissionType )
    else
        strOutlineName = "#gFE7E82+ " .. DataPool:GetMissionInfo_Kind( iMissionType )
    end

    --  这句判断永远通过, 而且 不应该是 or 而应该是 and
    --if( strOutlineName ~= "" or strOutlineName ~= 0 ) then
    --  如果是无效的任务名称
    if( strOutlineName == "" or strOutlineName == 0 ) then
        return;
    end

    local iStart = iMissionType*10000;
    local DeployNum = GetMissionOutlineNum( iMissionType )

    --  如果当前任务分类没有可接任务
    if( DeployNum <= 0 ) then
        return;
    end

    --  增加该任务分类的名称显示
    QuestLog_Listbox:AddItem( strOutlineName, iStart )
    --  该任务分类不是展开的
    if( 1 ~= MissionOutlineDeploy[ iMissionType ] ) then
        return;
    end

    --  增加该分类下可接的任务名称和其对应颜色配置
    local nMyLevel = Player:GetData( "LEVEL" )
    for i=1, DeployNum do
        local color= ""
        local MissionLevel, MinLevel, MaxLevel, strNpcName, strNpcPos, strScene, strMissionName = GetMissionOutlineInfo( iMissionType, i )

        if( MissionLevel - nMyLevel < -11 ) then
            color = "FFB9B9B9"; --灰色
        elseif( MissionLevel - nMyLevel <=-6 ) then
            color = "FF0A9605";    --绿色
        elseif( MissionLevel - nMyLevel <= 5 ) then
            color = "FFD9F80A";    --黄色
        elseif( MissionLevel - nMyLevel <= 10 ) then
            color = "FFF8A10A";    --橙色
        else
            color = "FFFA0A0A"; --红色
        end

        QuestLog_Listbox:AddItem( "    "..MissionLevel.." "..strMissionName, (iStart+i), color )
    end
end

--  更新可接任务列表
--  这部分跟重构后的MissionTrack一样... 因此不再做变更了
function QuestLog_UpdateMissionOutline()

    --  从已接任务列表切换到可接任务列表
    if( 1 == CurList ) then
        CurList = 2
        QuestLog_AcceptMission:SetCheck(1);
        QuestLog_Stop:Hide()
        QuestLog_AcceptMission_Button:Hide()
        QuestLog_TargetMission : SetText( "" );
    end

    --  记录当前列表显示位置
    local FirstItem = QuestLog_Listbox : GetCurrentFirstItem();
    --AxTrace( 0, 0, Current_Clicked )

    --  获取所有可接任务, 清除当前列表显示内容
    CollectMissionOutline()
    QuestLog_Listbox:ClearListBox()
    QuestLog_Desc:ClearAllElement();

    --  分类更新200中任务...
    for i=1,200 do             --现任务类型一共200种
        QuestLog_UpdateMissionType( i )
    end

    --QuestLog_Listbox : EnsureItemIsVisable( Current_Clicked );
    QuestLog_Listbox : SetCurrentFirstItem( FirstItem );
    QuestLog_TrackButtonState();
    --AxTrace( 0, 0, Current_Clicked )

end

--  点击可接任务条目
function QuestLog_MissionOutlineClicked()
    local nSelIndex = QuestLog_Listbox:GetFirstSelectItem();

    local iMod = math.mod( nSelIndex, 10000 )
    local iFloor = math.floor( nSelIndex / 10000 );

    --  根据点击选项的id值判断该项目是 任务类型(iMod==0) 还是具体任务(iMod!=0)
    if( 0 == iMod ) then
        --  反转该类型的折叠属性
        if( 0 == MissionOutlineDeploy[ iFloor ] ) then
            MissionOutlineDeploy[ iFloor ] = 1
        else
            MissionOutlineDeploy[ iFloor ] = 0
        end

        --  更新列表显示
        QuestLog_UpdateMissionOutline()
        QuestLog_Desc:ClearAllElement();
        return
        --QuestLog_Listbox:SetItemSelectByItemID( nSelIndex )
    end

    --  如果是具体任务, 在任务描述区显示其描述信息
    QuestLog_Desc:ClearAllElement();
    local MissionLevel, MinLevel, MaxLevel, strNpcName, strNpcPos, strScene, strMissionName, PosX, PosY, SceneID = GetMissionOutlineInfo( iFloor, iMod )
    QuestLog_Desc:AddTextElement("#Y"..strMissionName.."#W")

    strNpcPos = "#{_INFOAIM"..(PosX)..","..(PosY)..","..(SceneID)..","..(strNpcName).."}"
    --strNpcPos = "[["..(PosX)..","..(PosY)..","..(SceneID)..","..(strNpcName).."]]"
    --strNpcPos = "（"..PosX.."，"..PosY.."）"

    if strScene and strScene ~= "" then
            QuestLog_Desc:AddTextElement("任务所在地："..strScene.."  "..strNpcPos )
    end
    QuestLog_Desc:AddTextElement("任务发布人："..strNpcName )
    QuestLog_Desc:AddTextElement("任务等级："..tostring(MissionLevel) )
end

--  更新已接任务列表的指定分类
--  以短路写法重构, 减少缩进
function QuestLog_UpdateHaveGetMission( kind, kindTbl )
    --  单条任务记录
    local Constitutes = {};
    --  玩家当前等级
    local nMyLevel = Player:GetData( "LEVEL" );
    --  是否有该分类的任务
    local bHave = 0;

    --  遍历所有已接任务
    for i=1, g_nMissionNum do
        --  当前位置为无效任务
        if (DataPool:GetPlayerMission_InUse(i-1) ~= 1) then
            continue;
        end

        --  非当前类型的任务
        local MissionKind = DataPool:GetPlayerMission_Kind(i-1);
        if(MissionKind ~= kind) then
            continue;
        end

        AxTrace(0,0,"kind = ".. kind .. " i-1 ="..(i-1));

        --  当前任务类型是非折叠的
        if ( MissionPucker[kind] > 0 ) then
            --  获得任务 g_MissionTarget 字段
            local strInfo = DataPool:GetPlayerMission_Memo(i-1);
            --  获得任务 g_MissionLevel 字段
            local nMissionLevel = DataPool:GetPlayerMission_Level(i-1);

            --  如果任务等级是玩家等级, 将任务等级设置为玩家等级
            --  这里没有向MissionTrack中对擂台的 0 等级做特殊处理
            if nMissionLevel == LEVEL_TO_MY_LEVEL then
                nMissionLevel =  Player:GetData( "LEVEL" );
            end

            --  如果首次有该分类任务, 增加该分类的条目记录
            if(bHave == 0) then
                local str= "#gFE7E82- " .. DataPool:GetMissionInfo_Kind(kind);
                Constitutes = {str,100+kind,"",0}
                table.insert(kindTbl,Constitutes)
                bHave = 1;

                --  for debug only
                local xx;
                for i,xx in ipairs(Constitutes) do
                    AxTrace(3,1,"Constitutes["..i.."]="..xx)
                end
                AxTrace(0,0,"100+kind = ".. (100+kind) .. " name = " ..DataPool:GetMissionInfo_Kind(kind));
            end

            --------------------------------------------------
            local strOKFail = "";
            --显示任务是否已完成或已失败
            local Mission_Variable = DataPool:GetPlayerMission_Variable(i-1,0);

            if QuestLog_IsSpecialMission(i-1) == 1 then
                Mission_Variable = IsMissionSuccess(i-1)
            end

            if(Mission_Variable >0) then
                if(Mission_Variable == 1) then
                    strOKFail = "完成";
                elseif(Mission_Variable == 2) then
                    strOKFail = "失败";
                end
            end

            ----------------------------------------------------
            if(nMissionLevel - nMyLevel < -11) then
                color = "FFB9B9B9"; --灰色
            elseif(nMissionLevel - nMyLevel <=-6) then
                color = "FF0A9605";    --绿色
            elseif(nMissionLevel - nMyLevel <= 5) then
                color = "FFD9F80A";    --黄色
            elseif(nMissionLevel - nMyLevel <= 10) then
                color = "FFF8A10A";    --橙色
            else
                color = "FFFA0A0A"; --红色
            end

            local nMissionTrackType = 0;
            local nIsMissionTrackOpen = 0;
            if (nIsMissionTrackOpen > 0 and nMissionTrackType > 0) then
                Constitutes = {"   √" .. nMissionLevel .." " .. strInfo .. " " .. strOKFail,i-1,color,nMissionLevel}
            else
                Constitutes = {"     " .. nMissionLevel .." " .. strInfo .. " " .. strOKFail,i-1,color,nMissionLevel}
            end
            table.insert(kindTbl,Constitutes)
        else
            --  该任务分类是折叠的, 因此只显示一条任务分类名称
            if(bHave == 0) then
                local str= "#gFE7E82+ " .. DataPool:GetMissionInfo_Kind(kind);

                Constitutes = {str,100+kind,"",0}
                table.insert(kindTbl,Constitutes)

                bHave = 1;
            end
        end
        --  增加已接任务数
        HaveGetMissionNum=HaveGetMissionNum+1;
    end

    --  返回该分类下的任务记录
    return kindTbl;
end

--  更新已接任务列表
function QuestLog_UpdateListbox()

    --  从可接任务列表切换为已接任务列表
    if( 2 == CurList ) then
        CurList = 1
        QuestLog_CurrentMission:SetCheck(1);
        QuestLog_Stop:Show()
        QuestLog_AcceptMission_Button:Hide()
    end

    --  切换按钮状态.
    --  JOY: 可接任务列表更新时为什么没有相关切换
    QuestLog_CurrentMission:SetCheck( 1 )
    QuestLog_AcceptMission:SetCheck( 0 )

--    local nMissionNum = DataPool:GetPlayerMission_Num();
    local i;

    QuestLog_Listbox:ClearListBox();

    HaveGetMissionNum = 0
    local color;

    for i=1,g_nMissionNum do
        if (DataPool:GetPlayerMission_InUse(i-1) == 1) then
            DataPool:GetPlayerMission_Description(i-1);
        end
    end;

    --  已接任务分类总表
    local Sequence_Assemble = {}

    --  变量所有类型的已接任务, 分类排序插入总表
    for j=1, 200 do
        local Sequence_OnefoldGenre = QuestLog_UpdateHaveGetMission( j, {} );
        ----
        table.sort(Sequence_OnefoldGenre,QuestLog_CompareTable)

        for i,n in ipairs(Sequence_OnefoldGenre) do
            table.insert(Sequence_Assemble,n)
        end
        ----
    end

    --  将已接任务数据插入任务列表
    local Per_Segment,xxxx,i,j;
    for i,Per_Segment in ipairs(Sequence_Assemble) do
        if Per_Segment[3] ~= "" then
            QuestLog_Listbox:AddItem(Per_Segment[1],Per_Segment[2],Per_Segment[3])
        else
            QuestLog_Listbox:AddItem(Per_Segment[1],Per_Segment[2])
        end

--        for j,xxxx in ipairs(xxx) do
--            AxTrace(3,0,"xxx["..j.."]="..xxxx)
--        end
    end

    --  如果没有任务, 则任务列表显示相关提示
    if(HaveGetMissionNum<1) then
        QuestLog_Listbox:AddItem("没有任何任务。",0);
    end

    if First_Open == 1 then  --首次打开，选中最后一个
        First_Open = 0    
        Current_Select = HaveGetMissionNum - 1
    end

    --  设置原本的任务选择项
	if g_MenPai_Special_id == 1 then
		QuestLog_Listbox : SetItemSelectByItemID(HaveGetMissionNum-1);
	else
		QuestLog_Listbox : SetItemSelectByItemID(Current_Select);
	end

    QuestLog_Amount : SetText( HaveGetMissionNum .. "/" .. g_nMissionNum);

	if g_MenPai_Special_id == 1 then
		QuestLog_Listbox : SetCurrentFirstItem(HaveGetMissionNum-1);
	end

    QuestLog_ListBox_SelectChanged();

    --  更新当前的显示位置
    if Current_Clicked ~= -1 then
        --QuestLog_Listbox : EnsureItemIsVisable(Current_Clicked);
        QuestLog_Listbox : SetCurrentFirstItem(Current_Clicked);
        Current_Clicked = -1
    end
    QuestLog_TrackButtonState();
--
end

--  插入任务类型, 废弃
--function MissionType_Insert(str)
--排序算法在上面已经实现了，理论上讲这个不会被调用到。chris
--        for i=1,table.getn(MissionType) do
--        for i,Per_Segment in ipairs(MissionType) do
--            if(MissionType[i] == str) then
--                return;
--            elseif( MissionType[i] > str ) then
--                    table.insert(MissionType,i,str);
--                    AxTrace(0,0,"MissionType [" ..i.."] =".. MissionType[i]);
--                    return;
--            end
--        end
--        table.insert(MissionType,str);
--        return;
--end

--  变换当前任务选择
--  本身就是使用短路写法, 不用重构, 仅重新调整缩进增加注释
function QuestLog_ListBox_SelectChanged()

    -- 如果当前显示为可接任务, 转向可接任务处理
    if( 2 == CurList ) then
        QuestLog_MissionOutlineClicked()
        return
    end

    --  开始当前选择任务的数据更新
    local MissionParam_Index = 0;
    local nSelIndex = QuestLog_Listbox:GetFirstSelectItem();
    local Mission_Variable;

    --  如果没有接任何任务... Nothing
    if(HaveGetMissionNum<1) then
        QuestLog_Desc:ClearAllElement();
        QuestLog_TargetMission : SetText("");
        return;
    end

    --  如果任务列表记录的当前任务无效, 并且界面本身也没有记录当前选择任务.. Nothing
    if nSelIndex == -1 then
        if Current_Select == -1 then
            QuestLog_Desc:ClearAllElement();
            QuestLog_TargetMission : SetText("");
            return;
        else
            --  将当前选择任务置为界面记录的任务
            nSelIndex = Current_Select;
        end
    end

    --  如果当前点击项目为分类名称项
    if nSelIndex > 20 then

        --  切换其折叠状态, 并更新显示
        if MissionPucker[nSelIndex-100] == 1 then
            MissionPucker[nSelIndex-100] = 0;
        else
            MissionPucker[nSelIndex-100] = 1;
        end
        Current_Clicked = QuestLog_Listbox : GetCurrentFirstItem();
        QuestLog_UpdateListbox();

        return;
    end;

    --  如果当前选中项为无效的任务记录, Nothing
    if (DataPool:GetPlayerMission_InUse(nSelIndex) ~= 1) then
        QuestLog_Desc:ClearAllElement();
        QuestLog_TargetMission : SetText("");
        return;
    end

    --  清除任务描述
    QuestLog_Desc:ClearAllElement();
    QuestLog_TargetMission : SetText("");

    --  获得任务描述
    local desc = DataPool:GetPlayerMission_Description(nSelIndex)
    DataPool:GetPlayerMission_DelActivePos(Current_Select)
    Current_Select = nSelIndex;

    local strInfo,strDesc = DataPool:GetPlayerMission_Memo(nSelIndex);
    local i = 0
    local m = 0
    local nBegin = DataPool:GetPlayerMission_ForePart(nSelIndex);
    AxTrace(5,1,"nBegin="..nBegin)
    AxTrace(5,1,"strDesc="..strDesc)
    local strReplace = ""
    local strOriginal = ""

    --  合并任务的多条描述为1条
    while 1 do
        i = string.find(strDesc,"%%s")
        if i == nil then break end
        local strIndex =  DataPool:GetPlayerMission_VariableByByte(nSelIndex,nBegin,m)
        local strTemp = DataPool : GetPlayerMission_StrList(strIndex)
        AxTrace(5,1,"strIndex="..strIndex.." strTemp="..strTemp.." strDesc="..strDesc)
--        string.format(strDesc,strTemp)
        AxTrace(5,1,"strIndex="..strIndex.." strTemp="..strTemp.." strDesc="..strDesc)
        strReplace = strReplace .. string.sub(strDesc,1,i-1) .. strTemp
        AxTrace(5,1,"strReplace="..strReplace)
        AxTrace(5,1,"i="..i)
        strDesc = string.sub(strDesc,i+2)
        m = m + 1;
        AxTrace(5,1,"m="..m)
    end

    --  显示任务描述
    strReplace = strReplace .. strDesc
    strDesc = strReplace
    QuestLog_TargetMission : SetText("#gFF0FA0" ..strInfo);
    QuestLog_Desc:AddTextElement("#Y任务目标：#W")
    QuestLog_Desc:AddTextElement("" .. strDesc);

    --  特殊处理
    if(DataPool:GetPlayerMission_Display(nSelIndex,7) == 500510) then
        QuestLog_Desc:AddTextElement("" .. QuestLog_GetSCMTarget(nSelIndex));
    end

    if(DataPool:GetPlayerMission_Display(nSelIndex,7) == 889265) then
        QuestLog_Desc:AddTextElement("" .. QuestLog_GetHLXQJTarget(nSelIndex));
    end

--    QuestLog_Desc:AddTextElement("" .. strReplace);

    DataPool:GetPlayerMission_ActivePos(nSelIndex);

    --显示是否双倍时间
    local nDoubleExp = DataPool:GetPlayerMission_Display(nSelIndex,6)

    local DoubleExp_Text = "";
    if nDoubleExp > 0 then
        local IsDouble = DataPool:GetPlayerMission_DataRound(nDoubleExp);

        if IsDouble > 0 then
            DoubleExp_Text = "#B多倍奖励"
            QuestLog_Desc:AddTextElement(DoubleExp_Text);
        end
    end

    --        AxTrace(0, 0, "strInfo= " .. strInfo );
    --前面是否有一位显示任务是否已完成,第一位为完成信息
    if QuestLog_IsSpecialMission(nSelIndex)==0 then
        MissionParam_Index = MissionParam_Index + 1;
    end

--        for i =0,7 do
--            AxTrace(0,0, "variable [" .. i .."] = " .. DataPool:GetPlayerMission_Variable(nSelIndex,i) );
--        end

    --显示任务剩余时间
    local nTotalTime = DataPool:GetPlayerMission_Display(nSelIndex,2);
    AxTrace(1,1,"nTotalTime="..nTotalTime)
    if( nTotalTime > 0 ) then
        --73637【天龙服务器组】QuestLog中剩余时间定时器逻辑
        local nRemainTime = DataPool:GetPlayerMission_RemainTime(nSelIndex);
        AxTrace(1,1,"nRemainTime="..nRemainTime)
        --不好意思，加点注释，怕以后忘了，当然您如果一看就明白，那就跳过
        --73637的改造是为了避免服务端每次响应任务ontimer时都向客户端发包，以告知倒计时的变化
        --改造以后，任务7号参数不存倒计时时间，存任务启动timer或者说是接受任务的时间
        --服务端在接受任务、切场景、登录，都会下发此时间值，客户端根据这个自己tick倒计时
        --GetPlayerMission_RemainTime获取的就是7号参数，GetPlayerMission_RemainTimeEx是客户端自己算的，也是改造后界面显示真正使用的
        --而nTotalTime是限时时间，所以下面这个判断其实是比较取巧的
        if(nRemainTime == 0 or nRemainTime > nTotalTime ) then
            --nRemainTime = nTotalTime - DataPool:GetPlayerMission_RemainTimeEx(nSelIndex);
        end
        if(nTotalTime >0) then
--          QuestLog_Desc:AddTextElement(" ");
            local strRemainTime,strTotalTime,nSecond,nMinute,nHour; --Dengxx

            if(nTotalTime >= 60000*60) then
                nHour = math.floor(nTotalTime/60000/60)
                nMinute = math.floor((math.mod(nTotalTime,60000*60))/60000)
                nSecond = math.floor((math.mod(nTotalTime,60000))/1000)
                strTotalTime = nHour .. "小时"..nMinute.."分"..nSecond.."秒"
            elseif(nTotalTime >= 60000) then
                nMinute = nTotalTime/60000;
                strTotalTime = nMinute .. "分"
                nSecond = (nTotalTime - nMinute * 60000)/1000;
                strTotalTime = strTotalTime .. nSecond .."秒"
            elseif(nTotalTime >= 1000) then
                strTotalTime = nTotalTime/1000 .."秒"
            end

            if(nRemainTime >= 60000*60) then
                nHour = math.floor(nRemainTime/60000/60)
                nMinute = math.floor((math.mod(nRemainTime,60000*60))/60000)
                nSecond = math.floor((math.mod(nRemainTime,60000))/1000)
                strRemainTime = nHour .. "小时"..nMinute.."分"..nSecond.."秒"
            elseif(nRemainTime >= 60000) then
                nMinute = math.floor(nRemainTime/60000);
                strRemainTime = nMinute .. "分"
                nSecond = math.floor((nRemainTime - nMinute * 60000)/1000);
                strRemainTime = strRemainTime .. nSecond .."秒"
            elseif(nRemainTime >= 1000) then
                strRemainTime = math.floor(nRemainTime/1000) .."秒"
            else
                strRemainTime = "0秒"
            end

--          QuestLog_Desc:AddTextElement("剩余时间： " .. strRemainTime .."/".. strTotalTime);
            local remainTimeColor = "#c00ff00"
            if (nRemainTime <= 5*60000) then
                remainTimeColor = "#cff0000"
            end
            QuestLog_Desc:AddTextElement("#Y剩余时间： " .. remainTimeColor .. strRemainTime );
            --QuestLog_TargetMission : SetText("#cFF0FA0" ..strInfo .. "  #cff0000[剩余:" .. strRemainTime .. "]");
--          AxTrace(0,0, "时间 [" .. nSelIndex .."] = " .. strRemainTime .. " param_index = "..MissionParam_Index);
        end
    end

    --显示任务当前环数，misInfo的第三号参数为环数，通过mission data显示
    --yanghui，设置标志，通过mission data显示环数还是mission param显示环数
    local bShowByMD = 0;
    local nRound = DataPool:GetPlayerMission_Display(nSelIndex,3);
    if( nRound >= 0 ) then
        Mission_Variable = DataPool:GetPlayerMission_DataRound(nRound);

        if(Mission_Variable >= 0) then
            QuestLog_Desc:AddTextElement("#r#Y任务当前环数：#W"..Mission_Variable);
            bShowByMD = 1;
        end
    end

    --yanghui，千寻任务使用mission param增加环数显示
    if (bShowByMD == 0) then
        Mission_Variable = DataPool:GetPlayerMission_Variable(nSelIndex, 2);
        if (Mission_Variable == 229024) then
            Mission_Variable = DataPool:GetPlayerMission_Variable(nSelIndex, 5);
            if(Mission_Variable >= 0) then
                QuestLog_Desc:AddTextElement("#r#Y任务当前环数：#W"..Mission_Variable);
            end
        end
    end

    --TT76649，老带新使用mission param增加连续完成天数显示
    if( DataPool:GetPlayerMission_Display(nSelIndex,7) == 210254 ) then --如果任务处理脚本是210254（老带新活动）
        Mission_Variable = DataPool:GetPlayerMission_DataRound(511);--老带新活动的连续天数存储在missiondata的
        																														--MD_HELPNEWBIE_SUBMIT_TIMES_SEQUENCE = 511 --帮助新人任务连续完成天数
        local strseqdays = string.format("#{LDX_100726_05}%d",Mission_Variable)
 				QuestLog_Desc:AddTextElement(strseqdays);
    end


    --显示任务银票数量
    if( DataPool:GetPlayerMission_Display(nSelIndex,4) > 0 ) then
        Mission_Variable = DataPool:GetPlayerMission_Variable(nSelIndex,MissionParam_Index);
        MissionParam_Index = MissionParam_Index + 1;

        if(Mission_Variable >0) then
--            QuestLog_Desc:AddTextElement(" ");
            silverdesc = DataPool:GetPlayerMission_BillName(nSelIndex);
            QuestLog_Desc:AddTextElement(silverdesc .. ":");
            QuestLog_Desc:AddMoneyElement(Mission_Variable);
            AxTrace(0,0, "银票 [" .. nSelIndex .."] =" ..MissionParam_Index );
        end
    end
    QuestLog_Desc:AddTextElement(" ");
    if( DataPool:GetPlayerMission_Display(nSelIndex,5) <= 0 ) then
        QuestLog_Desc:AddTextElement("#Y完成情况：#W")
    end

    if(DataPool:GetPlayerMission_Display(nSelIndex,7) == 500510) then
        QuestLog_Desc:AddTextElement("" .. QuestLog_GetSCMComplete(nSelIndex));
    end

    if(DataPool:GetPlayerMission_Display(nSelIndex,7) == 889265) then
        QuestLog_Desc:AddTextElement("" .. QuestLog_GetHLXQJComplete(nSelIndex));
    end

    --任务需要杀的npc
    local nDemandKillNum,Kill_Random_Type = DataPool:GetPlayerMissionDemandKill_Num(nSelIndex);
    if( nDemandKillNum > 0 ) then
--        QuestLog_Desc:AddTextElement(" ");
        QuestLog_Desc:AddTextElement("已杀死：");
    end

    for i=1, nDemandKillNum do
        --    需要的NPC, 需要的数量
        local nNPCName, nNum = DataPool:GetPlayerMissionDemand_NPC(i-1,Kill_Random_Type,nSelIndex);
        Mission_Variable = DataPool:GetPlayerMission_Variable(nSelIndex,MissionParam_Index,Kill_Random_Type,i-1);
        MissionParam_Index = MissionParam_Index + 1;
        AxTrace(0, 0, "nNPCName:" .. nNPCName);
        AxTrace(0, 0, "num:" .. nNum);

        QuestLog_Desc:AddTextElement(nNPCName .. " ： "..Mission_Variable.. " / " .. nNum);
        AxTrace(0,0, "NPC [" .. nSelIndex .."] =" ..MissionParam_Index );
    end

    --任务需要的物品
    local nDemandNum,Item_Random_Type = DataPool:GetPlayerMissionDemand_Num(nSelIndex);
    if( nDemandNum > 0 ) then
--      QuestLog_Desc:AddTextElement(" ");
        if(Item_Random_Type == -100) then
            QuestLog_Desc:AddTextElement("已提交：");
            Item_Random_Type = 0
        else
            QuestLog_Desc:AddTextElement("已得到：");
        end
    end

    for i=1, nDemandNum do
        --    需要的类型，需要物品ID，需要多少个
        local szName,nItemID, nNum = DataPool:GetPlayerMissionDemand_Item(i-1,Item_Random_Type,nSelIndex);
--      Mission_Variable = DataPool:GetPlayerMission_Variable(nSelIndex,MissionParam_Index);
--      MissionParam_Index = MissionParam_Index + 1
        Mission_Variable = DataPool : GetPlayerMission_ItemCountNow(nItemID)
        --71435 “寻找万灵石”任务逻辑的修改
        if nItemID == 20309012 then
            Mission_Variable = Mission_Variable + DataPool : GetPlayerMission_ItemCountNow(20309020)
        end
        AxTrace(0, 0, "itemid:" .. nItemID)
        AxTrace(0, 0, "szName:" .. szName)
        AxTrace(0, 0, "num:" .. nNum)

        if Mission_Variable > nNum then
            Mission_Variable = nNum
        end


--      QuestLog_Desc:AddItemElement(nItemID, nNum, 0);
        local Mission_Variable2 = DataPool:GetPlayerMission_Variable(nSelIndex,0);
        if Mission_Variable2 > 0 then
            Mission_Variable = nNum
        end
        QuestLog_Desc:AddTextElement(szName .. " ： " .. Mission_Variable .. " / " .. nNum);
    end

    -----------------------------------------------------------------------------------
    --任务自定义的物品
    local nCustomNum = DataPool:GetPlayerMissionCustom_Num(nSelIndex);
    if( nCustomNum > 0 ) then
        QuestLog_Desc:AddTextElement(" ");
    end

    for i=1, nCustomNum do
        --    需要的NPC，需要NPC ID，需要多少个
        local strCustom, nNum = DataPool:GetPlayerMissionCustom(i-1);
        Mission_Variable = DataPool:GetPlayerMission_Variable(nSelIndex,MissionParam_Index);
        MissionParam_Index = MissionParam_Index + 1;
        AxTrace(0, 0, "strCustom = " .. strCustom);
        AxTrace(0, 0, "nNum = " .. nNum);

        if nNum == 0 then
            QuestLog_Desc:AddTextElement(strCustom);
        else
            QuestLog_Desc:AddTextElement(strCustom .. " ： ".. Mission_Variable .. " / " .. nNum);
        end
    end

    -----------------------------------------------------------------------------------
    --任务自定义的随机物品 zz添加
    local nRandomCustomNum = DataPool:GetPlayerMissionRandomCustom_Num(nSelIndex);
    if( nRandomCustomNum > 0 ) then
            --QuestLog_Desc:AddTextElement(" ");
    end
    for i=1,nRandomCustomNum do
        local strCustom, nNeedNum,nCompleteNum = DataPool:GetPlayerMissionRandomCustom(i-1,nSelIndex);
        if nNeedNum == 0 then
            QuestLog_Desc:AddTextElement(strCustom);
        else
            QuestLog_Desc:AddTextElement(strCustom .. " ： ".. nCompleteNum .. " / " .. nNeedNum);
        end
    end


    ----------------------------------------------------------------------------------
    --  任务奖励说明
    QuestLog_Desc:AddTextElement(" ");
    local nBonusNum = DataPool:GetPlayerMissionBonus_Num();

    if( nBonusNum > 0 ) then
        QuestLog_Desc:AddTextElement("#Y奖励：#W");
    end
    local nRadio = 1;
    local nRand = 1;

    for i=1, nBonusNum do
        --奖励的类型，奖励物品ID，奖励多少个
        local strType, nItemID, nNum = DataPool:GetPlayerMissionBonus_Item(i-1);
        if(strType == "money" and nNum > 0 )then
--            QuestLog_Desc:AddTextElement("奖励金钱：");
            --这里有对剧情循环任务的特殊处理
            local nScriptId = DataPool:GetPlayerMission_Display(nSelIndex,7)
            if (nScriptId >= 890000 and nScriptId <= 890005) then
                QuestLog_Desc:AddJiaoZiElement(nNum)
            else
                if (nScriptId >= 1010243 and nScriptId <= 1010250) or
                    (nScriptId >= 1010402 and nScriptId <= 1010409) or
                    (nScriptId >= 1018000 and nScriptId <= 1018033) or
                    (nScriptId >= 1018050 and nScriptId <= 1018084) or
                    (nScriptId >= 1018100 and nScriptId <= 1018155) or
                    (nScriptId >= 1018200 and nScriptId <= 1018235) or
                    (nScriptId >= 1018300 and nScriptId <= 1018311) or
                    (nScriptId >= 1018350 and nScriptId <= 1018352) or
                    (nScriptId >= 1018360 and nScriptId <= 1018367) or
                    (nScriptId >= 1018400 and nScriptId <= 1018455) or
                    (nScriptId >= 1018500 and nScriptId <= 1018504) or
                    (nScriptId >= 1018530 and nScriptId <= 1018541) or
                    (nScriptId >= 1018560 and nScriptId <= 1018566) or
                    (nScriptId >= 1038000 and nScriptId <= 1038040) or
                    (nScriptId >= 1038110 and nScriptId <= 1038114) or
                    (nScriptId >= 1039000 and nScriptId <= 1039011) or
                    (nScriptId >= 1039020 and nScriptId <= 1039024) or
                    (nScriptId >= 1039100 and nScriptId <= 1039104) or
                    (nScriptId >= 1038100 and nScriptId <= 1038104) or
                    (nScriptId >= 1039110 and nScriptId <= 1039126) or
                    (nScriptId >= 1039200 and nScriptId <= 1039211) or
                    (nScriptId >= 1039250 and nScriptId <= 1039259) or
                    (nScriptId >= 1039300 and nScriptId <= 1039312) or
                    (nScriptId >= 1039350 and nScriptId <= 1039357) or
                    (nScriptId >= 1039400 and nScriptId <= 1039412) or
                    (nScriptId >= 1039450 and nScriptId <= 1039462) or
                    (nScriptId >= 1039500 and nScriptId <= 1039511) or
                    (nScriptId >= 1039550 and nScriptId <= 1039554) or
                    (nScriptId >= 1039600 and nScriptId <= 1039612) or
                    (nScriptId >= 1009000 and nScriptId <= 1009027) or
                    (nScriptId >= 1009100 and nScriptId <= 1009103) then

                    -- 使用玩家自己的等级来计算得到的奖励
                    nNum = tonumber(Player:GetData("LEVEL") * 18 -101)
                end

                QuestLog_Desc:AddMoneyElement(nNum);
            end
        elseif(strType == "moneyjz" and nNum > 0) then
            QuestLog_Desc:AddJiaoZiElement(nNum)
        elseif(strType == "item") then
--            QuestLog_Desc:AddTextElement("固定奖励物品：");
            local ActionID = DataPool:EnumPlayerMission_ItemAction(nItemID);
            QuestLog_Desc:AddActionElement(ActionID, nNum, 0);
        elseif(strType == "itemrand") then
            if (nRand == 1) then
                nRand = 0;
                QuestLog_Desc:AddTextElement("随机奖励物品：");
                local ActionID = DataPool:EnumPlayerMission_ItemAction(nItemID);
                QuestLog_Desc:AddActionElement(ActionID, nNum, 0);
            end
--          local ActionID = DataPool:EnumPlayerMission_ItemAction(nItemID);
--          QuestLog_Desc:AddActionElement(ActionID, nNum, 0);
--          QuestLog_Desc:AddItemElement(-1, nNum, 0);
        elseif(strType == "itemradio") then
            bBeingRadio = 1;
            if (nRadio == 1) then
                nRadio = 0;
                QuestLog_Desc:AddTextElement("在下列物品中选择一项作为奖励");
            end
            AxTrace(0, 0, "nItemID:" .. nItemID);
            local ActionID = DataPool:EnumPlayerMission_ItemAction(nItemID);
            AxTrace(0, 0, "ActionID:" .. ActionID);
            QuestLog_Desc:AddActionElement(ActionID,nNum, 0 ,0);
--            QuestLog_Desc:AddItemElement(nItemID, nNum, 1 ,1);
        end
    end

    --------------------------------------------------------------------------------
    --2009圣诞日常活动的特殊处理
    --Add by Jiang Yin
    --------------------------------------------------------------------------------
    local nScriptId = DataPool:GetPlayerMission_Display(nSelIndex, 7)
    if nScriptId == 808200 then
        local strIndex = DataPool:GetPlayerMission_Variable(nSelIndex, 1)
        local strTemp = DataPool:GetPlayerMission_StrList(strIndex)
        local pos = string.find(strTemp, "%%s")
        if pos ~= nil then
            strTemp = string.sub(strTemp, 1, pos - 1) .. DataPool:GetPlayerMission_Variable(nSelIndex, 2) .. string.sub(strTemp,  pos + 2)
        end
        QuestLog_Desc:AddTextElement(strTemp)
    end
    --------------------------------------------------------------------------------
    --2009圣诞日常活动的特殊处理完毕
    --------------------------------------------------------------------------------
    QuestLog_TrackButtonState();
end

--  放弃任务 按钮点击回调
function Abnegate_Quest()
    if(HaveGetMissionNum<1 or QuestLog_Listbox:GetFirstSelectItem() < 0) then
        return;
    end
    if(Current_Select < 100) then
        DataPool : Mission_Abnegate_Popup( Current_Select, DataPool:GetPlayerMission_Memo(Current_Select));
    end
end

--  已接任务分类排序函数
function QuestLog_CompareTable(table_a,table_b)
    if table_a[4] < table_b[4] then
        return true
    else
        return false
    end
end

--  任务追踪复选框点击回调
function QuestLog_MissionTrack_Clicked()
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GetGiftsForUI");
		Set_XSCRIPT_ScriptID(900012);
		Set_XSCRIPT_Parameter(0,15);
		Set_XSCRIPT_Parameter(1,1);
		Set_XSCRIPT_ParamCount(2);
	Send_XSCRIPT();	
end

--  活动追踪复选框点击回调
function QuestLog_CampaignTrack_Clicked()
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GetGiftsForUI");
		Set_XSCRIPT_ScriptID(900012);
		Set_XSCRIPT_Parameter(0,15);
		Set_XSCRIPT_Parameter(1,2);
		Set_XSCRIPT_ParamCount(2);
	Send_XSCRIPT();	
end

--  显示任务列表
function QuestLog_ShowWindow()
    this:TogleShow();
    local nMissionTrackShow = 0;
    local nCampaignTrackShow = 0;
    if (nMissionTrackShow > 0) then
        QuestLog_Mode1:SetCheck(1);
    else
        QuestLog_Mode1:SetCheck(0);
    end
    if (nCampaignTrackShow > 0) then
        QuestLog_Mode2:SetCheck(1);
    else
        QuestLog_Mode2:SetCheck(0);
    end
    g_QuestLog_LastSelect=-1
end

--  更新任务的追踪选项按钮, 设置追踪按钮为 取消追踪/开始追踪
function QuestLog_TrackButtonState()

end

--  开启任务追踪或者取消任务追踪
function QuestLog_TrackCancelOrOpen()

end

--TT53675对所有不符合规范，没有将missionparam第0位做为任务完成标志的任务脚本做特殊处理，判断任务是否完成
function IsMissionSuccess(nSelIndex)
    local MissionParam_Index = 0
    local Mission_Variable = 0

    --任务需要杀的npc
    local nDemandKillNum,Kill_Random_Type = DataPool:GetPlayerMissionDemandKill_Num(nSelIndex);
    if( nDemandKillNum > 0 ) then
        for i=1, nDemandKillNum do
            --  需要的NPC, 需要的数量
            local nNPCName, nNum = DataPool:GetPlayerMissionDemand_NPC(i-1,Kill_Random_Type,nSelIndex);
            --  完成的数量
            Mission_Variable = DataPool:GetPlayerMission_Variable(nSelIndex,MissionParam_Index,Kill_Random_Type,i-1);
            MissionParam_Index = MissionParam_Index + 1;
            if Mission_Variable < nNum then
                return 0
            end
        end
    end

    --任务需要的物品
    local nDemandNum,Item_Random_Type= DataPool:GetPlayerMissionDemand_Num(nSelIndex);
    if( nDemandNum > 0 ) then
        for i=1, nDemandNum do
            --    需要的类型，需要物品ID，需要多少个
            local szName,nItemID, nNum = DataPool:GetPlayerMissionDemand_Item(i-1,Item_Random_Type,nSelIndex);
            --  完成的数量
            Mission_Variable = DataPool : GetPlayerMission_ItemCountNow(nItemID)
            if Mission_Variable < nNum then
                return 0
            end
        end
    end

    -----------------------------------------------------------------------------------
    --任务自定义的物品
    local nCustomNum = DataPool:GetPlayerMissionCustom_Num(nSelIndex);
    if( nCustomNum > 0 ) then
        for i=1, nCustomNum do
            --    需要的类型, 需要的数量
            local strCustom, nNum = DataPool:GetPlayerMissionCustom(i-1);
            --  完成的数量
            Mission_Variable = DataPool:GetPlayerMission_Variable(nSelIndex,MissionParam_Index);
            MissionParam_Index = MissionParam_Index + 1;
            if Mission_Variable < nNum then
                return 0
            end
        end
    end

    -----------------------------------------------------------------------------------
    --任务自定义的随机物品 zz添加
    local nRandomCustomNum = DataPool:GetPlayerMissionRandomCustom_Num(nSelIndex);
    if( nRandomCustomNum > 0 ) then
        for i=1,nRandomCustomNum do
            --  需要的类型, 需要的数量, 完成的数量
            local strCustom, nNeedNum,nCompleteNum = DataPool:GetPlayerMissionRandomCustom(i-1,nSelIndex);
            if nCompleteNum < nNeedNum then
                return 0
            end
        end
    end

    return 1
end

--================================================
-- 恢复界面的默认相对位置
--================================================
function QuestLog_Frame_On_ResetPos()

    QuestLog_Frame : SetProperty("UnifiedXPosition", g_QuestLog_Frame_UnifiedXPosition);
    QuestLog_Frame : SetProperty("UnifiedYPosition", g_QuestLog_Frame_UnifiedYPosition);

end

function QuestLog_GetSCMTarget(nSelIndex)
    --第五位的第一字节存任务类型，第二字节场景序号
    local missionType = DataPool:GetPlayerMission_VariableByByte(nSelIndex, 5, 0) - 1
    local sceneIndex = DataPool:GetPlayerMission_VariableByByte(nSelIndex, 5, 1) - 1
    local strScript = DataPool:GetPlayerMission_StrList(missionType)
    local strTarget = ParserString(strScript,"Color")
    local strReplace = ""
    if missionType < 2 and  missionType >= 0 then
        strReplace = DataPool:GetPlayerMission_StrList(missionType*33 + 3 + sceneIndex)--这里的33是场景数量，如果要增加需要修改这个数字
    elseif missionType == 2 then--读表
        local monster={}
        local killNumber = 0
        killNumber,monster[1],monster[2],monster[3],monster[4],monster[5],monster[6],monster[7],monster[8] = DataPool:GetSCMKillMonsterInfo(sceneIndex+1)
        for i=1,8 do
            if monster[i]~=nil and monster[i]~="" then
                strReplace = strReplace .. monster[i] .. "#{SDHDRW_091216_02}"
            end
        end
        --去掉最后一个逗号
        strReplace = string.sub(strReplace, 1, string.len(strReplace) - string.len("#{SDHDRW_091216_02}"))
        strReplace = strReplace .. "#{CJXH_100517_14}" .. tostring(killNumber)
    end

    local pos = string.find(strTarget,"%%s")

    if(pos~=nil) then
        strTarget = string.sub(strTarget, 1 ,pos-1)..strReplace..string.sub(strTarget,pos+2)
    end

    local SceneList = {170,169,171,156,173,176,445,174,157,177,175,178,517,519,520,179,427,434,432,202,400,401,
                        402,203,159,160,161,162,163,164,165,166,167}
    local sceneId = SceneList[sceneIndex + 1]
    strReplace = GetSceneNameByID(sceneId)
    pos = string.find(strTarget,"%%t")
    if(pos~=nil and strReplace~=nil) then
	    strTarget = string.sub(strTarget, 1 ,pos-1)..strReplace..string.sub(strTarget,pos+2)
    end
    return strTarget
end

function QuestLog_GetSCMComplete(nSelIndex)
    local missionType = DataPool:GetPlayerMission_VariableByByte(nSelIndex, 5, 0) - 1
    local sceneIndex = DataPool:GetPlayerMission_VariableByByte(nSelIndex, 5, 1) - 1
    local strComplete = ""
    if(missionType==0) then
        strComplete = strComplete.."#{CJXH_100517_17}"
        local alreadyKill = DataPool:GetPlayerMission_Variable(nSelIndex, 1)
        local needKill = DataPool:GetPlayerMission_Variable(nSelIndex, 2)
	if alreadyKill > needKill then
		alreadyKill = needKill
	end
        strComplete = strComplete..tostring(alreadyKill).." / "..tostring(needKill)
    elseif (missionType == 1) then
        local itemName = PlayerPackage:GetItemName(40004526)
        strComplete = strComplete.."#{CJXH_100517_21}\n"..itemName.."："
        local alreadyObtain = DataPool:GetPlayerMission_Variable(nSelIndex, 1)
        local needObtain = DataPool:GetPlayerMission_Variable(nSelIndex, 2)
	if alreadyObtain > needObtain then
		alreadyObtain = needObtain
	end
        strComplete = strComplete..tostring(alreadyObtain).." / "..tostring(needObtain)
    elseif(missionType == 2) then
        strComplete = strComplete.."#{CJXH_100517_24}\n"
        local monster={}
        local killNumber = 0
        local alreadyKill = {}
        alreadyKill[1] = DataPool:GetSCMAlreadyKillNumber(DataPool:GetPlayerMission_Variable(nSelIndex, 1),1)
        alreadyKill[2] = DataPool:GetSCMAlreadyKillNumber(DataPool:GetPlayerMission_Variable(nSelIndex, 1),2)
        alreadyKill[3] = DataPool:GetSCMAlreadyKillNumber(DataPool:GetPlayerMission_Variable(nSelIndex, 2),1)
        alreadyKill[4] = DataPool:GetSCMAlreadyKillNumber(DataPool:GetPlayerMission_Variable(nSelIndex, 2),2)
        alreadyKill[5] = DataPool:GetSCMAlreadyKillNumber(DataPool:GetPlayerMission_Variable(nSelIndex, 3),1)
        alreadyKill[6] = DataPool:GetSCMAlreadyKillNumber(DataPool:GetPlayerMission_Variable(nSelIndex, 3),2)
        alreadyKill[7] = DataPool:GetSCMAlreadyKillNumber(DataPool:GetPlayerMission_Variable(nSelIndex, 4),1)
        alreadyKill[8] = DataPool:GetSCMAlreadyKillNumber(DataPool:GetPlayerMission_Variable(nSelIndex, 4),2)
        killNumber,monster[1],monster[2],monster[3],monster[4],monster[5],monster[6],monster[7],monster[8] = DataPool:GetSCMKillMonsterInfo(sceneIndex+1)
        for i=1,8 do
            if monster[i]~=nil and monster[i]~="" then
                strComplete = strComplete .. monster[i] .."：" .. tostring(alreadyKill[i]) .. " / " .. tostring(killNumber) .. "\n"
            end
        end
    end
    return strComplete
end



function QuestLog_GetHLXQJComplete( nSelIndex )
	local AlreadyPlay = {}

	AlreadyPlay[1] = DataPool:GetPlayerMission_Variable( nSelIndex, 1 )
	AlreadyPlay[2] = DataPool:GetPlayerMission_Variable( nSelIndex, 2 )
	AlreadyPlay[3] = DataPool:GetPlayerMission_Variable( nSelIndex, 3 )
	AlreadyPlay[4] = DataPool:GetPlayerMission_Variable( nSelIndex, 4 )
	AlreadyPlay[5] = DataPool:GetPlayerMission_Variable( nSelIndex, 5 )

	local MenPaiList = {
		[0] = { id = 0, rate = 10, name = "#{XQ_MP_1}" },    --少林
		[1] = { id = 1, rate = 20, name = "#{XQ_MP_2}" },    --明教
		[2] = { id = 2, rate = 30, name = "#{XQ_MP_3}" },    --丐帮
		[3] = { id = 3, rate = 40, name = "#{XQ_MP_4}" },    --武当
		[4] = { id = 4, rate = 50, name = "#{XQ_MP_5}" },    --峨眉
		[5] = { id = 5, rate = 60, name = "#{XQ_MP_6}" },    --星宿
		[6] = { id = 6, rate = 70, name = "#{XQ_MP_7}" },    --天龙
		[7] = { id = 7, rate = 80, name = "#{XQ_MP_8}" },    --天山
		[8] = { id = 8, rate = 90, name = "#{XQ_MP_9}" },    --逍遥
        [9] = { id = 9, rate = 100, name = "#{XQ_MP_10}" },         --无门派
		[10] = { id = 10, rate = 100, name = "#{XQ_MP_10}" },  --慕容
	}

	local strComplete = ""

	for i = 1, 5 do
		local aimMenpai = 0
		local isDone = 1
		if AlreadyPlay[i] >= 100 then
			aimMenpai = 1
			AlreadyPlay[i] = AlreadyPlay[i] - 100
		end
        local temp_str = "#{XQ_MP_11}"..MenPaiList[AlreadyPlay[i]].name.."#{XQ_MP_12}".." "..tostring( aimMenpai ).."/"..tostring( isDone )
        strComplete = strComplete..temp_str.."\n"
	end

	return strComplete
end

function QuestLog_GetHLXQJTarget( nSelIndex )
	local AlreadyPlay = {}

    AlreadyPlay[1] = DataPool:GetPlayerMission_Variable( nSelIndex, 1 )
	AlreadyPlay[2] = DataPool:GetPlayerMission_Variable( nSelIndex, 2 )
	AlreadyPlay[3] = DataPool:GetPlayerMission_Variable( nSelIndex, 3 )
	AlreadyPlay[4] = DataPool:GetPlayerMission_Variable( nSelIndex, 4 )
	AlreadyPlay[5] = DataPool:GetPlayerMission_Variable( nSelIndex, 5 )

    for i = 1, 5 do
        if AlreadyPlay[i] >= 100 then
            AlreadyPlay[i] = AlreadyPlay[i] - 100
        end
    end

	local MenPaiList = {
		[0] = { id = 0, rate = 10, name = "#{XQ_MP_1}" },    --少林
		[1] = { id = 1, rate = 20, name = "#{XQ_MP_2}" },    --明教
		[2] = { id = 2, rate = 30, name = "#{XQ_MP_3}" },    --丐帮
		[3] = { id = 3, rate = 40, name = "#{XQ_MP_4}" },    --武当
		[4] = { id = 4, rate = 50, name = "#{XQ_MP_5}" },    --峨眉
		[5] = { id = 5, rate = 60, name = "#{XQ_MP_6}" },    --星宿
		[6] = { id = 6, rate = 70, name = "#{XQ_MP_7}" },    --天龙
		[7] = { id = 7, rate = 80, name = "#{XQ_MP_8}" },    --天山
		[8] = { id = 8, rate = 90, name = "#{XQ_MP_9}" },    --逍遥
        [9] = { id = 9, rate = 100, name = "#{XQ_MP_10}" },         --无门派
		[10] = { id = 10, rate = 100, name = "#{XQ_MP_10}" },  --慕容
	}

	local strComplete = ""

	strComplete = "#{XQHLJ_101108_59}"..MenPaiList[AlreadyPlay[1]].name.."#{XQHLJ_101108_65}"..MenPaiList[AlreadyPlay[2]].name.."#{XQHLJ_101108_65}"..MenPaiList[AlreadyPlay[3]].name.."#{XQHLJ_101108_65}"..MenPaiList[AlreadyPlay[4]].name.."#{XQHLJ_101108_65}"..MenPaiList[AlreadyPlay[5]].name.."#{XQHLJ_101108_60}"

	return strComplete
end


--  是否是特殊任务, 任务状态不是记录在0号位置的.
function QuestLog_IsSpecialMission( index )
    --TT53675对于所有没有用missionparam第0位表示任务是否完成的任务，使用IsMissionSuccess判断任务是否完成
    local IsSpecial = 0
    local nScriptId = DataPool:GetPlayerMission_Display(index,7);

    for i, findId in SpecialMissionList do
          if nScriptId == findId then
             IsSpecial = 1
            break
        end
    end

    if nScriptId >= 1020000 and nScriptId <= 1029999 then --所有的探索配表任务都需要特殊处理
          IsSpecial = 1
    end

    return IsSpecial;
end

--!!!reloadscript =QuestLog
function QuestLog_FreshManGuide(nType, nTextID, nPosID)
    if nType ~= 1 and      --1 is reset and open
        nType ~= 2 then    --2 is modify
        return
    end
    if 1 ~= CurList then   --不是可接任务列表不管
        return
    end
    if Player:GetData("LEVEL") > 10 then
        return
    end
    local nSelIndex = QuestLog_Listbox:GetFirstSelectItem()
    if nSelIndex < 0 then
        return
    end 
    local nScriptId = DataPool:GetPlayerMission_Display(nSelIndex, 7)
    if nScriptId ~= 210262 and   --初涉江湖
        nScriptId ~= 210255 and  --第一把武器 
        nScriptId ~= 210256 then --第一件防具
        return  
    end  
    
    local nTipPosX = 0
    local nTipPosY = 0
    if 1 == nPosID then  --QuestLog_Desc
        nTipPosX = QuestLog_Frame:GetProperty("AbsoluteXPosition") + QuestLog_MainFrame:GetProperty("AbsoluteXPosition") +
            QuestLog_Frame_Client:GetProperty("AbsoluteXPosition") + QuestLog_Bk:GetProperty("AbsoluteXPosition") +
            QuestLog_Desc:GetProperty("AbsoluteXPosition") + QuestLog_Desc:GetProperty("AbsoluteWidth") / 2
        nTipPosY = QuestLog_Frame:GetProperty("AbsoluteYPosition") + QuestLog_MainFrame:GetProperty("AbsoluteYPosition") + 
            QuestLog_Frame_Client:GetProperty("AbsoluteYPosition") + QuestLog_Bk:GetProperty("AbsoluteYPosition") +
            QuestLog_Desc:GetProperty("AbsoluteYPosition") + 30
    else 
        return           --unkown position
    end  
    OpenFreshManGuide(nType, nTextID, nTipPosX, nTipPosY, "QuestLog", nPosID, "northeast")
end