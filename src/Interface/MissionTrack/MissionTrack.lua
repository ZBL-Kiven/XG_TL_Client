local g_Frame_UnifiedXPosition;
local g_Frame_UnifiedYPosition;

-- 任务跟踪   author：houzhifang

local g_strWndName = "MissionTrack";
local g_MissionTrack_myjisiji = 1
local g_dlgctrls = {};              --控件集合, noused
local MissionPucker = {};           --任务类型折叠标记, 1为不折叠, 0为折叠
local g_nNowCheck = 0;              --0:初始化，1:已接任务，2：可接任务
local g_LockState = 0;              --0:未锁定，1：已锁定
local LEVEL_TO_MY_LEVEL = 10000;    --如果任务等级为该值, 则玩家当前等级就是任务等级
local g_Temp_Mylevel = 1;           --一个玩家等级的临时变量, 主要用于擂台场景, 玩家等级是0的情况

local g_DiFu_Scene_Id = 77;         --地府场景ID
local g_nMissionNum = 20;           --最大任务个数


--用于保留界面原始尺寸和位置信息
local g_MissionTrack_Frame_UnifiedSize;
local g_MissionTrack_Frame_UnifiedXPosition;
local g_MissionTrack_Frame_UnifiedYPosition;
local g_MissionTrack__Frame_AbsolutePosition;
local g_MissionTrack__Frame_AbsoluteSize;
local g_MissionTrack_Function_Frame_AbsolutePosition;
local g_MissionTrack_DragTitle_AbsolutePosition;
local g_MissionTrack_Close_AbsolutePosition;
local g_MissionTrack__CheckBox_Frame_AbsolutePosition;
local g_MissionTrack_Lock_AbsolutePosition;
local g_MissionTrack_UnLock_AbsolutePosition;


function MissionTrack_PreLoad()
	this:RegisterEvent("UI_COMMAND");
		-- 游戏窗口尺寸发生了变化
        this:RegisterEvent("NEW_MISSION");
        this:RegisterEvent("DELETE_MISSION");
	this:RegisterEvent("FINISH_MISSION")
        --刷新任务
 	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("SCENE_TRANSED")
	--离开场景，自动关闭
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
end

function MissionTrack_OnLoad()
	-- 保存界面的默认相对位置
	g_Frame_UnifiedXPosition = MissionTrack_Frame:GetProperty("UnifiedXPosition");
	g_Frame_UnifiedYPosition = MissionTrack_Frame:GetProperty("UnifiedYPosition");

        --MissionTrack_Song:Hide();
        --MissionTrack_Liao:Hide();
end

function MissionTrack_OnEvent(event)
	if event == "UI_COMMAND"  and tonumber(arg0) == 201705081 then
           MissionTrack_ListBoxTransparent : ClearAllElement();
	   this:Show();
           --SetTimer("MissionTrack","MissionTrack_TimerProc()", 5000)
           MissionTrack_ResetPos()
           MissionTrack_UpdateHaveGetMission();
           MissionTrack_ShowORHideFunc(0)
           MissionTrack_On_UnLock()
	    return;
            end

	if( event == "PLAYER_LEAVE_WORLD") then --切换场景不关闭
		--SelfEquip_CloseFunction();
		--this:Hide();
	    --return;
            end
	if( event == "NEW_MISSION") or ( event == "DELETE_MISSION") or ( event == "FINISH_MISSION") then
            MissionTrack_UpdateHaveGetMission()
        end

	if( event == "VIEW_RESOLUTION_CHANGED" ) then
	    MissionTrack_Frame:SetProperty( "UnifiedPosition", "{{1.0,-266},{0,269}}" );
	    return;
            end

	if (event == "SCENE_TRANSED") then
	end
end

--================================================
-- 界面的默认相对位置
--================================================
function MissionTrack_ResetPos()
	MissionTrack_Frame:SetProperty("UnifiedXPosition", g_Frame_UnifiedXPosition);
	MissionTrack_Frame:SetProperty("UnifiedYPosition", g_Frame_UnifiedYPosition);
end

function MissionTrack_OnHiden()
	this:Hide();
end

function MissionTrack_CleanupUIControls()
end

function MissionTrack_Btn_MouseLeave(dix)	
end

function MissionTrack_Btn_Clicked(nIndexx)
end

function MissionTrack_OpenPaiMing_Clicked(nIndex)
end


function MissionTrackFrame_MouseEnter()
	local _,_,_,_,_,_,_,_,_,f10,_,_,_,_,_,_,_,_,_,_,_,_,_,_ = SystemSetup:GameGetData();
	local alphaStr = string.format("%f" , f10 )
        MissionTrack_ListBox:SetProperty("Alpha" , alphaStr)
end

function MissionTrackFrame_MouseLeave()
	local _,_,_,_,_,_,_,_,_,f10,_,_,_,_,_,_,_,_,_,_,_,_,_,_ = SystemSetup:GameGetData();
	local alphaStr = string.format("%f" , f10 / 2 )
        --MissionTrack_ListBoxTransparent:SetProperty("Alpha" , alphaStr)
        MissionTrack_ListBox:SetProperty("Alpha" , alphaStr)
end


--*****************----

function MissionTrack_OnMoved()
   -- if "MissionTrack" == GetFreshManGuideOwner() then --当本界面show并且引导ui指向本界面,才需要响应
 --       OpenFreshManGuide(2, -1, -1, -1)
  --  end
end
function MissionTrack_OnHidden()
 --   if "MissionTrack" == GetFreshManGuideOwner() then
 --       CloseFreshManGuide()      --当引导ui指向本界面,才需要响应
 --   end
		this:Hide();
                --KillTimer("MissionTrack_TimerProc()")
end


function MissionTrack_WillGetFunc()
    PushDebugMessage("请点击任务面板界面的【可接任务】按钮查看当前可接任务！")
end


--  点击任务追踪的已经任务按钮, 更新列表为已接任务
--  这里关于按钮的状态处理可以省去
function MissionTrack_HaveGetFunc()
   -- MissionTrack_HaveGet:SetCheck(1);
   -- MissionTrack_WillGet:SetCheck(0);
   -- if(g_nNowCheck ~= 1) then
        MissionTrack_UpdateHaveGetMission();
   -- end
end


--function MissionTrack_TimerProc() --蝎子刷新计时器
  --g_MissionTrack_myjisiji = g_MissionTrack_myjisiji+1
    --local myjishiqi = math.mod(g_MissionTrack_myjisiji,4)
       --if myjishiqi == 0 then
         -- MissionTrack_UpdateHaveGetMission()
       --end
--end


function MissionTrack_UpdateHaveGetMission()
    local nMissionNum = DataPool:GetPlayerMission_Num();
    local i;

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
        table.sort(Sequence_OnefoldGenre,QuestLog_CompareTable)
        for i,n in ipairs(Sequence_OnefoldGenre) do
            table.insert(Sequence_Assemble,n)
        end
    end

    --  将已接任务数据插入任务列表
    local Per_Segment,xxxx,i,j;
    local xieziTrack = ""
    for i,Per_Segment in ipairs(Sequence_Assemble) do
        if Per_Segment[3] ~= "" then
            --MissionTrack_ListBoxTransparent:AddItem(Per_Segment[1],Per_Segment[2],Per_Segment[3])
            local strInfo,strDesc = DataPool:GetPlayerMission_Memo(Per_Segment[2]);
            xieziTrack = xieziTrack.."#cffcc00"..tostring(Per_Segment[1]).."#r#W"..strDesc.."#r"
        --else
            --MissionTrack_ListBoxTransparent : SetText("#H"..tostring(Per_Segment[1])..tostring(Per_Segment[2]).."")
        end
    end

            MissionTrack_ListBoxTransparent : ClearAllElement();
            MissionTrack_ListBoxTransparent : AddTextElement(xieziTrack) 

    --  如果没有任务, 则任务列表显示相关提示
    --if(HaveGetMissionNum<1) then
    -- MissionTrack_ListBoxTransparent:AddTextElement("#H没有任何任务。")
    --end

    if First_Open == 1 then  --首次打开，选中最后一个
        First_Open = 0    
        Current_Select = HaveGetMissionNum - 1
    end

    --  设置原本的任务选择项
	if g_MenPai_Special_id == 1 then
		--MissionTrack_ListBoxTransparent : SetItemSelectByItemID(HaveGetMissionNum-1);
	else
		--MissionTrack_ListBoxTransparent : SetItemSelectByItemID(Current_Select);
	end

   -- QuestLog_Amount : SetText( HaveGetMissionNum .. "/" .. g_nMissionNum);
	if g_MenPai_Special_id == 1 then
		--MissionTrack_ListBoxTransparent : SetCurrentFirstItem(HaveGetMissionNum-1);
	end
end


function MissionTrack_On_Lock()
    MissionTrack_UnLock:Show();
    MissionTrack_Lock:Hide();
    MissionTrack_Close:Hide();
    MissionTrack_DragTitle:Hide()
end

function MissionTrack_On_UnLock()
    MissionTrack_UnLock:Hide();
    MissionTrack_Lock:Show();
    MissionTrack_Close:Show();
    MissionTrack_DragTitle:Show()
end

--  鼠标进入, 显示界面尺寸控制条
function MissionTrack_Func_MouseEnter()
    --MissionTrack_ShowORHideFunc(1);
    MissionTrack_ShowORHideFunc(0); --一直影藏
end

--  鼠标离开, 隐藏界面尺寸控制条
function MissionTrack_Func_MouseLeave()
    MissionTrack_ShowORHideFunc(0);
end

--  隐藏或显示界面尺寸控制条
function MissionTrack_ShowORHideFunc( nShow )

   if nShow >= 1 then
        MissionTrack_Height_Add:Show();
        MissionTrack_Height_Reduce:Show();
        MissionTrack_Width_Add:Show();
        MissionTrack_Width_Reduce:Show();
        MissionTrack_Reset:Show();
	MissionTrack_Function_FrameBK:Show();
   else
        MissionTrack_Height_Add:Hide();
        MissionTrack_Height_Reduce:Hide();
        MissionTrack_Width_Add:Hide();
        MissionTrack_Width_Reduce:Hide();
        MissionTrack_Reset:Hide();
	MissionTrack_Function_FrameBK:Hide();
MissionTrackFrame_MouseLeave()
    end
end

function MissionTrack_CloseFunc()
    this:Hide();
    KillTimer("MissionTrack_TimerProc()")
   -- DataPool:SetTrackFuncShow(1, 0);
  -- DataPool:UpdateTrackStateButton(0);
end
