local g_Frame_UnifiedXPosition;
local g_Frame_UnifiedYPosition;

-- �������   author��houzhifang

local g_strWndName = "CampaignTrack";
local g_CampaignTrack_myjisiji = 1
local g_dlgctrls = {};              --�ؼ�����, noused
local MissionPucker = {};           --���������۵����, 1Ϊ���۵�, 0Ϊ�۵�
local g_nNowCheck = 0;              --0:��ʼ����1:�ѽ�����2���ɽ�����
local g_LockState = 0;              --0:δ������1��������
local LEVEL_TO_MY_LEVEL = 10000;    --�������ȼ�Ϊ��ֵ, ����ҵ�ǰ�ȼ���������ȼ�
local g_Temp_Mylevel = 1;           --һ����ҵȼ�����ʱ����, ��Ҫ������̨����, ��ҵȼ���0�����

local g_DiFu_Scene_Id = 77;         --�ظ�����ID
local g_nMissionNum = 20;           --����������
local g_campaign_today = 0	--�������л


--���ڱ�������ԭʼ�ߴ��λ����Ϣ
local g_CampaignTrack_Frame_UnifiedSize;
local g_CampaignTrack_Frame_UnifiedXPosition;
local g_CampaignTrack_Frame_UnifiedYPosition;
local g_CampaignTrack__Frame_AbsolutePosition;
local g_CampaignTrack__Frame_AbsoluteSize;
local g_CampaignTrack_Function_Frame_AbsolutePosition;
local g_CampaignTrack_DragTitle_AbsolutePosition;
local g_CampaignTrack_Close_AbsolutePosition;
local g_CampaignTrack__CheckBox_Frame_AbsolutePosition;
local g_CampaignTrack_Lock_AbsolutePosition;
local g_CampaignTrack_UnLock_AbsolutePosition;


function CampaignTrack_PreLoad()
	this:RegisterEvent("UI_COMMAND");
		-- ��Ϸ���ڳߴ緢���˱仯
 	this:RegisterEvent("ADJEST_UI_POS")
	-- ��Ϸ�ֱ��ʷ����˱仯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("SCENE_TRANSED")
	--�뿪�������Զ��ر�
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
end

function CampaignTrack_OnLoad()
	-- ��������Ĭ�����λ��
	g_Frame_UnifiedXPosition = CampaignTrack_Frame:GetProperty("UnifiedXPosition");
	g_Frame_UnifiedYPosition = CampaignTrack_Frame:GetProperty("UnifiedYPosition");

        --CampaignTrack_Song:Hide();
        --CampaignTrack_Liao:Hide();
end

function CampaignTrack_OnEvent(event)
	if event == "UI_COMMAND"  and tonumber(arg0) == 201705091 then
           CampaignTrack_ListBoxTransparent : ClearAllElement();
	   this:Show();
           SetTimer("CampaignTrack","CampaignTrack_TimerProc()", 4000)
           CampaignTrack_ResetPos()
           CampaignTrack_UpdateHaveGetMission();
           CampaignTrack_ShowORHideFunc(0)
           CampaignTrack_UnLock_Func()  --Ы�Ӽ������
	    return;
            end

	if( event == "PLAYER_LEAVE_WORLD") then
		--SelfEquip_CloseFunction();
		--this:Hide();
	    --return;
            end

	if( event == "VIEW_RESOLUTION_CHANGED" ) then
	    CampaignTrack_Frame:SetProperty( "UnifiedPosition", "{{1.0,-266},{0,435}}" );
	    return;
            end

	if (event == "SCENE_TRANSED") then
	end
end

--================================================
-- �����Ĭ�����λ��
--================================================
function CampaignTrack_ResetPos()
	CampaignTrack_Frame:SetProperty("UnifiedXPosition", g_Frame_UnifiedXPosition);
	CampaignTrack_Frame:SetProperty("UnifiedYPosition", g_Frame_UnifiedYPosition);
end

function CampaignTrack_OnHiden()
	this:Hide();
end

function CampaignTrack_CleanupUIControls()
end

function CampaignTrack_Btn_MouseLeave(dix)	
end

function CampaignTrack_Btn_Clicked(nIndexx)
end

function CampaignTrack_OpenPaiMing_Clicked(nIndex)
end


function CampaignTrackFrame_MouseEnter()
	local _,_,_,_,_,_,_,_,_,f10,_,_,_,_,_,_,_,_,_,_,_,_,_,_ = SystemSetup:GameGetData();
	local alphaStr = string.format("%f" , f10 )
        CampaignTrack_ListBox:SetProperty("Alpha" , alphaStr)
end

function CampaignTrackFrame_MouseLeave()
	local _,_,_,_,_,_,_,_,_,f10,_,_,_,_,_,_,_,_,_,_,_,_,_,_ = SystemSetup:GameGetData();
	local alphaStr = string.format("%f" , f10 / 2 )
        --CampaignTrack_ListBoxTransparent:SetProperty("Alpha" , alphaStr)
        CampaignTrack_ListBox:SetProperty("Alpha" , alphaStr)
end


--*****************----

function CampaignTrack_OnMoved()
   -- if "CampaignTrack" == GetFreshManGuideOwner() then --��������show��������uiָ�򱾽���,����Ҫ��Ӧ
 --       OpenFreshManGuide(2, -1, -1, -1)
  --  end
end
function CampaignTrack_OnHidden()
 --   if "CampaignTrack" == GetFreshManGuideOwner() then
 --       CloseFreshManGuide()      --������uiָ�򱾽���,����Ҫ��Ӧ
 --   end
		this:Hide();
                KillTimer("CampaignTrack_TimerProc()")
end


function CampaignTrack_WillGetFunc()
    PushDebugMessage("��������������ġ��ɽ����񡿰�ť�鿴��ǰ�ɽ�����")
end


--  �������׷�ٵ��Ѿ�����ť, �����б�Ϊ�ѽ�����
--  ������ڰ�ť��״̬�������ʡȥ
function CampaignTrack_HaveGetFunc()
   -- CampaignTrack_HaveGet:SetCheck(1);
   -- CampaignTrack_WillGet:SetCheck(0);
   -- if(g_nNowCheck ~= 1) then
        CampaignTrack_UpdateHaveGetMission();
   -- end
end


function CampaignTrack_TimerProc() --Ы��ˢ�¼�ʱ��
  g_CampaignTrack_myjisiji = g_CampaignTrack_myjisiji+1
    local myjishiqi = math.mod(g_CampaignTrack_myjisiji,4)
       if myjishiqi == 0 then
          CampaignTrack_UpdateHaveGetMission()
       end
end


function CampaignTrack_UpdateHaveGetMission()

	local nNum = GetCampaignCount(tonumber(g_campaign_today));
        local xieziTrack2 = ""
	for i=0 , nNum-1 do
		local strTime = "";
		local strEnd = EnumCampaign(tonumber(g_campaign_today),i,"endtime");
		if(strEnd ~= -1) then
			strTime = EnumCampaign(tonumber(g_campaign_today),i,"starttime").."--"..strEnd;
		else
			strTime = EnumCampaign(tonumber(g_campaign_today),i,"starttime");
		end
		
		---����time_slice
		local strHuodong = EnumCampaign(tonumber(g_campaign_today),i,"name");
		
		--����
		local strDesc = EnumCampaign(tonumber(g_campaign_today),i,"desc");
		local ends = EnumCampaign(tonumber(g_campaign_today),i,"addtiondesc");
		
		--if(ends and ends~="")then
		 --strDesc = strDesc
		--end
			AxTrace( 5,3, strDesc );
		local isCur  =  EnumCampaign(tonumber(g_campaign_today),i,"iscurcampaign");
		if(tonumber(isCur) == 1)then
                       xieziTrack2 = xieziTrack2.."#cffcc00  "..strTime.."  #G"..strHuodong.."#r    #W"..strDesc.."#r"
                end
          end
            CampaignTrack_ListBoxTransparent : ClearAllElement();
            CampaignTrack_ListBoxTransparent : AddTextElement(xieziTrack2) 
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

--  ������, ��ʾ����ߴ������
function CampaignTrack_Func_MouseEnter()
    --CampaignTrack_ShowORHideFunc(1);
    CampaignTrack_ShowORHideFunc(0); --һֱӰ��
end

--  ����뿪, ���ؽ���ߴ������
function CampaignTrack_Func_MouseLeave()
    CampaignTrack_ShowORHideFunc(0);
end

--  ���ػ���ʾ����ߴ������
function CampaignTrack_ShowORHideFunc( nShow )

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
   -- DataPool:SetTrackFuncShow(1, 0);
  -- DataPool:UpdateTrackStateButton(0);
end
