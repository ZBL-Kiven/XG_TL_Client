local g_Frame_UnifiedXPosition;
local g_Frame_UnifiedYPosition;

-- �������   author��houzhifang

local g_strWndName = "MissionTrack";
local g_MissionTrack_myjisiji = 1
local g_dlgctrls = {};              --�ؼ�����, noused
local MissionPucker = {};           --���������۵����, 1Ϊ���۵�, 0Ϊ�۵�
local g_nNowCheck = 0;              --0:��ʼ����1:�ѽ�����2���ɽ�����
local g_LockState = 0;              --0:δ������1��������
local LEVEL_TO_MY_LEVEL = 10000;    --�������ȼ�Ϊ��ֵ, ����ҵ�ǰ�ȼ���������ȼ�
local g_Temp_Mylevel = 1;           --һ����ҵȼ�����ʱ����, ��Ҫ������̨����, ��ҵȼ���0�����

local g_DiFu_Scene_Id = 77;         --�ظ�����ID
local g_nMissionNum = 20;           --����������


--���ڱ�������ԭʼ�ߴ��λ����Ϣ
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
		-- ��Ϸ���ڳߴ緢���˱仯
        this:RegisterEvent("NEW_MISSION");
        this:RegisterEvent("DELETE_MISSION");
	this:RegisterEvent("FINISH_MISSION")
        --ˢ������
 	this:RegisterEvent("ADJEST_UI_POS")
	-- ��Ϸ�ֱ��ʷ����˱仯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("SCENE_TRANSED")
	--�뿪�������Զ��ر�
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
end

function MissionTrack_OnLoad()
	-- ��������Ĭ�����λ��
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

	if( event == "PLAYER_LEAVE_WORLD") then --�л��������ر�
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
-- �����Ĭ�����λ��
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
   -- if "MissionTrack" == GetFreshManGuideOwner() then --��������show��������uiָ�򱾽���,����Ҫ��Ӧ
 --       OpenFreshManGuide(2, -1, -1, -1)
  --  end
end
function MissionTrack_OnHidden()
 --   if "MissionTrack" == GetFreshManGuideOwner() then
 --       CloseFreshManGuide()      --������uiָ�򱾽���,����Ҫ��Ӧ
 --   end
		this:Hide();
                --KillTimer("MissionTrack_TimerProc()")
end


function MissionTrack_WillGetFunc()
    PushDebugMessage("��������������ġ��ɽ����񡿰�ť�鿴��ǰ�ɽ�����")
end


--  �������׷�ٵ��Ѿ�����ť, �����б�Ϊ�ѽ�����
--  ������ڰ�ť��״̬�������ʡȥ
function MissionTrack_HaveGetFunc()
   -- MissionTrack_HaveGet:SetCheck(1);
   -- MissionTrack_WillGet:SetCheck(0);
   -- if(g_nNowCheck ~= 1) then
        MissionTrack_UpdateHaveGetMission();
   -- end
end


--function MissionTrack_TimerProc() --Ы��ˢ�¼�ʱ��
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

    --  �ѽ���������ܱ�
    local Sequence_Assemble = {}

    --  �����������͵��ѽ�����, ������������ܱ�
    for j=1, 200 do
        local Sequence_OnefoldGenre = QuestLog_UpdateHaveGetMission( j, {} );
        table.sort(Sequence_OnefoldGenre,QuestLog_CompareTable)
        for i,n in ipairs(Sequence_OnefoldGenre) do
            table.insert(Sequence_Assemble,n)
        end
    end

    --  ���ѽ��������ݲ��������б�
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

    --  ���û������, �������б���ʾ�����ʾ
    --if(HaveGetMissionNum<1) then
    -- MissionTrack_ListBoxTransparent:AddTextElement("#Hû���κ�����")
    --end

    if First_Open == 1 then  --�״δ򿪣�ѡ�����һ��
        First_Open = 0    
        Current_Select = HaveGetMissionNum - 1
    end

    --  ����ԭ��������ѡ����
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

--  ������, ��ʾ����ߴ������
function MissionTrack_Func_MouseEnter()
    --MissionTrack_ShowORHideFunc(1);
    MissionTrack_ShowORHideFunc(0); --һֱӰ��
end

--  ����뿪, ���ؽ���ߴ������
function MissionTrack_Func_MouseLeave()
    MissionTrack_ShowORHideFunc(0);
end

--  ���ػ���ʾ����ߴ������
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
