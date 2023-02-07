--���ֽ�������ʱ
--Q546528533
local g_State;
--������ȡ��ʾ��ʱ����
local g_Notes = {"#{XRLJ_100104_1}","#{XRLJ_100104_2}","#{XRLJ_100104_3}","#{XRLJ_100104_10}","#{XRLJ_100104_15}","#{XRLJ_100104_16}","#{XRLJ_100104_17}","#{XRLJ_100104_18}","#{XRLJ_100104_19}",}
local g_CanReceive = 0--�콱����
local FreshmanWatch_MinOrMax = 0
function FreshmanWatch_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OPEN_NORMAL_WATCH");
	this:RegisterEvent("COUNTDOWN_10SEC");
	--����ϵͳ����
	this:RegisterEvent("SWITCH_MENU_BUTTON")
	this:RegisterEvent("HIDE_TLBB_MAIN")
	--this:RegisterEvent("UPDATE_FRESHMAN_POSITION")
	this:RegisterEvent("PLAYERBONUS_CHANGESTATE")
end

function FreshmanWatch_OnLoad()
	FreshmanWatch_UpdatePos(0)
end

function FreshmanWatch_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == 889103 ) then
			local state = Get_XParam_INT(0)
			local countDownMinute = Get_XParam_INT(1)
			local isPlayerJustLogin = Get_XParam_INT(2)--��ʾ��UICommand����ҵ�½ʱ���͵ģ������콱�ɹ����͵�
			g_State = state
			if state == 0 then
				this:Hide();
				PushEvent("FRESHMAN_CHANGESTATE")
				FreshmanWatch_Time_Text:SetProperty("Timer",tostring(0));
				FreshmanWatch_Time_Text1:SetProperty("Timer",tostring(0));
				g_CanReceive = 0 --�ر���ȡ����
				return
			end
			this:Show();
			PushEvent("FRESHMAN_CHANGESTATE")
			if countDownMinute == 0 then
				FreshmanWatch_TimeOut()
			else
				g_CanReceive = 0 --�ر���ȡ����
				FreshmanWatch_Text:Hide()
				-- FreshmanWatch_BK_Anmite:Play(false)
				FreshmanWatch_Time_Text1:SetProperty("Timer",tostring(countDownMinute*60 - 10));
				FreshmanWatch_Time_Text:SetProperty("Timer",tostring(countDownMinute*60));
				FreshmanWatch_Time_Text:SetProperty("TextColor","00ffff");--��ɫ�Ļ���ɫ
				FreshmanWatch_Time_Text1:SetProperty("TextColor","00ffff");--��ɫ�Ļ���ɫ
				FreshmanWatch_Time_Text1:Hide()
				FreshmanWatch_Time_Text:SetToolTip("#{XRLJ_100104_5}")
				-- FreshmanWatch_Receive:Hide()
	            FreshmanWatch_Min_Bk:Show()
			end
	elseif ( event == "OPEN_NORMAL_WATCH") then
		if g_State ~= nil and g_State >= 1 and g_State <=10 then
			this:Show()
			PushEvent("FRESHMAN_CHANGESTATE")
		end
	elseif ( event == "SWITCH_MENU_BUTTON" ) then
		FreshmanWatch_UpdatePos(0)
	elseif ( event == "UI_COMMAND" and arg0 == "1000000125" ) then
		this:Hide()
		PushEvent("FRESHMAN_CHANGESTATE")
	elseif ( event == "PLAYERBONUS_CHANGESTATE" ) then
		FreshmanWatch_UpdatePos(0)
	end
end

function FreshmanWatch_TimeOut()
	--���Ű�ť��������
	-- FreshmanWatch_BK_Anmite:Play(true)
	--���¼�ʱ��ʱ��
	FreshmanWatch_Time_Text:SetProperty("Timer",tostring(0));
	FreshmanWatch_Time_Text1:SetProperty("Timer",tostring(0));
	FreshmanWatch_Text:Show()
	-- FreshmanWatch_Receive:Show()
	----��ʾ����ȡ������
	--����tips����
	if g_State >= 1 and g_State <=9 then
		FreshmanWatch_Time_Text:SetToolTip(g_Notes[g_State])
	else
		FreshmanWatch_Time_Text:SetToolTip("#{XRLJ_100104_4}")
	end
	--��Ŀ��ʾ-ע�⣺��Ŀ��ʾ��Ҫ�޸�
	PushDebugMessage("#{XRLJ_100104_13}")
	PushDebugMessage("#{XRLJ_100104_14}")
	--��������
	Sound:PlayUISound(38);
	--������ȡ����
	g_CanReceive = 1
end

function FreshmanWatch_TimeOut1()
	--�������ʮ���ɫ����˸
	FreshmanWatch_Time_Text:SetProperty("TextColor","ffff0000");
end

function FreshmanWatch_Bn2Click()
  --û���콱ʱ�䲻����ȡ��Ʒ
	if g_CanReceive ~= 1 then
		PushDebugMessage("#{XRLJ_130806_2}")
		return
	end
	--��ȡ��Ʒ����
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "TakeGift" )
		Set_XSCRIPT_ScriptID( 889103 )
		Set_XSCRIPT_Parameter( 0, g_State )
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
end

--������
function FreshmanWatch_MouseEnter()
	local pleft,pright,ptop,pbottom = FreshmanWatch_BK:GetPixelRect()
	PushEvent("UI_COMMAND",1000000124, 1, g_State, pleft,ptop,pright,pbottom)
end

--����뿪
function FreshmanWatch_MouseLeave()
	PushEvent("UI_COMMAND",1000000124, 0, g_State)	--index����ǰ���콱�׶�
end

function FreshmanWatch_UpdatePos( nValue )
	-- if IsWindowShow("PlayerBonus") == true then		--��������Ѵ�
		-- if IsWindowShow("MainMenuBar_4") == true then		--��������������ſ����
			-- FreshmanWatch_Frame_sub:SetProperty("UnifiedPosition", "{{0.500000,-120.000000},{1.000000,-200.000000}}");
		-- elseif IsWindowShow("MainMenuBar_2") == true then		--������������Ϸ������
			-- FreshmanWatch_Frame_sub:SetProperty("UnifiedPosition", "{{0.500000,-120.000000},{1.000000,-221.000000}}");
		-- else 																							--���������û�п����
			-- FreshmanWatch_Frame_sub:SetProperty("UnifiedPosition", "{{0.500000,-120.000000},{1.000000,-185.000000}}");
		-- end
	-- else
		-- if IsWindowShow("MainMenuBar") == true then		--��������������ſ����
			FreshmanWatch_Frame_sub:SetProperty("UnifiedPosition", "{{0.500000,-60.000000},{1.000000,-200.000000}}");
		-- elseif IsWindowShow("MainMenuBar_2") == true then		--������������Ϸ������
			-- FreshmanWatch_Frame_sub:SetProperty("UnifiedPosition", "{{0.500000,-60.000000},{1.000000,-221.000000}}");
		-- else 																							--���������û�п����
			-- FreshmanWatch_Frame_sub:SetProperty("UnifiedPosition", "{{0.500000,-60.000000},{1.000000,-185.000000}}");
		-- end
	-- end
	-- FreshmanWatch_DaoJiShi:SetText("#{XRLJ_130717_1}")
end
