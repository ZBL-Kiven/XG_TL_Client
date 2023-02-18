--OnLoad
local PlayerZhengyouLB = 0
function PlayerZhengyou_PreLoad()
	this:RegisterEvent("OPEN_WINDOW");
	this:RegisterEvent("CLOSE_WINDOW");
	this:RegisterEvent("UI_COMMAND");
end

function PlayerZhengyou_OnLoad()
    PlayerZhengyou_DragTitle:SetText("#{ZYPT_081103_099}");
end

function PlayerZhengyou_OnEvent(event)
	if(event == "OPEN_WINDOW") then
		if( arg0 == "ZhengyouWindow") then
			PlayerZhengyouLB = 1
			--����Ѿ���ʾ��Ӧ�ùص�
			if ( this:IsVisible() ) then
			   this:Hide();
			   return;
			end
			PlayerZhengyou_Player:SetText("#{ZYPT_081103_004}")
			PlayerZhengyou_Pet:SetText("#{ZYPT_081103_003}")
			PlayerZhengyou_DragTitle:SetText("#{ZYPT_081103_099}")
			this:Show();
		end
	elseif(event == "UI_COMMAND" and tonumber(arg0) == 20210809 ) then
		PlayerZhengyouLB = 2
		--����Ѿ���ʾ��Ӧ�ùص�
		if ( this:IsVisible() ) then
		   this:Hide();
		   return;
		end
		PlayerZhengyou_Player:SetText("���ƹ���")
		PlayerZhengyou_Pet:SetText("�����ƹ���")
		PlayerZhengyou_DragTitle:SetText("#gFF0FA0�����ͺ���")		
		this:Show();
	elseif(event == "CLOSE_WINDOW") then
		if( arg0 == "ZhengyouWindow") then
			this:Hide();
		end	
	end
end

function OnPlayerZhengyouClicked()
    CloseWindow("Show_Pet_Friends");
	if PlayerZhengyouLB == 1 then
		OpenWindow("PlayerZhengyouPTWindow");
	else
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "XiaoXiang_yaoqingma" );
		Set_XSCRIPT_ScriptID( 928775 );	
		Set_XSCRIPT_Parameter( 0, tonumber(10000));
		Set_XSCRIPT_ParamCount( 1 );
	Send_XSCRIPT()		
	end
end

function OnPetZhengyouClicked()
    CloseWindow("PlayerZhengyouPTWindow");
	if PlayerZhengyouLB == 1 then
		OpenWindow("Show_Pet_Friends");
	else
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "XiaoXiang_yaoqingma" );
		Set_XSCRIPT_ScriptID( 928775 );	
		Set_XSCRIPT_Parameter( 0, tonumber(30000));
		Set_XSCRIPT_ParamCount( 1 );
	Send_XSCRIPT()			
	end
end
