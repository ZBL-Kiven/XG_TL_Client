--***********************************************************************************************************************************************
-- �������		
--ע�⣬�˽���Ϊ����ר�ã��벻Ҫ������������;
--***********************************************************************************************************************************************
local Current_status = 0;
local Current_Quest = -1;
-------------------------------------------------------------------------------------------------------------------------------------------------
--
-- �˴�������Ҫ�������ݵľֲ�����
--

--------------------------------------------------------
-- ��ǰ�Ի���Ĳ�������
local g_Event;

local Event_Relive = 0;
local Event_Callof = 1;


--***********************************************************************************************************************************************
--
-- OnLoad
--
--************************************************************************************************************************************************
function Relive_PreLoad()

	this:RegisterEvent("RELIVE_SHOW");
	this:RegisterEvent("RELIVE_HIDE");
	this:RegisterEvent("RELIVE_REFESH_TIME");

	--���˼���
	this:RegisterEvent("OPEN_CALLOF_PLAYER");
	
end

function Relive_OnLoad()
end


--***********************************************************************************************************************************************
--
-- �¼���Ӧ����
--
--
--************************************************************************************************************************************************
function Relive_OnEvent(event)
	AxTrace( 0,0, "here");
	if ( event == "RELIVE_SHOW" ) then
	
		Relive_Text:SetText( "���Ѿ�����������������˼仹��Щ��ִ����Ǽ����ȴ����������ϣ�" );
--		Relive_Time_Text:SetText( arg2 );
		Relive_Time_Text : SetProperty("Timer",tostring(arg2));
		--�и��ť
		if ( arg0 == "1" ) then
			Relive_Fool_Button:Enable();
		--�޸��ť
		else
			Relive_Fool_Button:Disable();
		end
		--�и��ť
		if ( arg1 == "1" ) then
			Relive_Relive_Button:Enable();
		--�޸��ť
		else
			Relive_Relive_Button:Disable();
		end
		
		Question_Help:Disable();
		Question_Close:Disable();
		Current_status = 0;
		Relive_Fool_Button:SetText("����");
		Relive_Release_Button:SetText("����");
		Relive_Relive_Button:SetText("����");

		Question_Text:SetText("#gFF0FA0����");
		this:Show();
		g_Event = Event_Relive;

	elseif ( event == "RELIVE_HIDE" ) then
		Current_status = 0;
		this:Hide();

	elseif ( event == "RELIVE_REFESH_TIME" ) then
	
		Relive_Time_Text : SetProperty("Timer",tostring(arg0));
		Current_status = 0;
	
		
	elseif ( event == "OPEN_CALLOF_PLAYER" )  then
		
		Relive_Text:SetText(arg0 .. "�����ȥ���Ƿ�ͬ�Ⱑ��");
			
		Relive_Release_Button:SetText("ȷ��");
		Relive_Relive_Button:SetText("ȡ��");

		Question_Text:SetText("#gFF0FA0����");

		Relive_Time_Text:SetProperty("Timer",tostring( arg3 ));
		this:Show()
		g_Event = Event_Callof;
		
	end
end



--***********************************************************************************************************************************************
--
-- ������ϰ�ť
--
--
--************************************************************************************************************************************************
function Relive_Out_Ghost()

	if( g_Event == Event_Callof )  then
		Friend:CallOf("ok");
		this:Hide();
	
	elseif(g_Event == Event_Relive)then
		if(Current_status == 1) then
			if(Current_Quest > -1) then
				QuestFrameMissionAbnegate(Current_Quest);
			end
			this:Hide();
			return;
		else
			Player:SendReliveMessage_OutGhost();
		end
		
	end

end


--***********************************************************************************************************************************************
--
-- ������ť
--
--
--***********************************************************************************************************************************************
function Relive_Relive()

	if( g_Event == Event_Relive )  then
		if(Current_status == 1) then
			this:Hide();
			return;
		else
			Player:SendReliveMessage_Relive();
		end;
		 
	elseif(g_Event == Event_Callof)then 
		this:Hide();
	
	end

end

--��ʱ����0
function Relive_Time_Zero()
	if( g_Event == Event_Callof )  then
		this:Hide();
	end;

end

function Relive_Out_Fool()
	Player:SendReliveMessage_Fool();
end