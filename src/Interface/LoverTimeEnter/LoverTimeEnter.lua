----------------------
-- LoverTimeEnter ---
----------------------

local g_Cooldown = 4*1000		--4s��ť��ȴ
local g_InCooldown = 0			--�Ƿ�����ȴ

local g_PlayWarning = 10*1000		--10s��˸��ť��ȴ
local g_InPlayWarning = 1			--�Ƿ�����˸��ȴ

local g_LevelLimit = 15	--��ʾ��ť����С�ȼ�

--===============================================
-- PreLoad()
--===============================================
function LoverTimeEnter_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("HIDE_TLBB_MAIN")
	this:RegisterEvent("HIDE_THIS_UI")
end

--===============================================
-- OnLoad()
--===============================================
function LoverTimeEnter_OnLoad()

end

--===============================================
-- OnEvent()
--===============================================
function LoverTimeEnter_OnEvent(event)
	if (event  == "UI_COMMAND") and (tonumber(arg0) == 89297401) then
		local bFlash = Get_XParam_INT(0)
		LoverTimeEnter_ShowIcon(bFlash)
	end
	
	if ( event == "HIDE_TLBB_MAIN" ) then
		if this:IsVisible() then
			this:Hide()
		end
	end
	
	if event == "HIDE_THIS_UI" then
		if this:IsVisible() then
			this:Hide()
		end
	end
end

--===============================================
-- OnShow()
--===============================================
function LoverTimeEnter_ShowIcon(bFlash)
	if bFlash == nil then
		return
	end
	
	--�رս���
	if bFlash == 2 then
		if this:IsVisible() then
			this:Hide()
		end
	elseif bFlash == 0 or bFlash == 1 then--��ʾ����
		if this:IsVisible() then
			--������
		else
			--������ʾ
			this:Show()
				
			--��˸ʱ���ж�
			if bFlash == 1 then
				--ͼ����˸			
				LoverTimeEnter_Icon : PlayWarning( 1 )
				LoverTimeEnter_Icon : SetToolTip("")
				--������˸��ȴʱ��
				g_InPlayWarning = 1
				SetTimer("LoverTimeEnter", "LoverTimeEnter_PlayWarning()",g_PlayWarning)
			end
		end
	end
end

--===============================================
-- OnClick()
--===============================================
function LoverTimeEnter_OnClick()
		
	--�ȼ��ж�
	local nLevel = Player:GetData( "LEVEL" )
	if( nLevel < g_LevelLimit ) then
		PushDebugMessage("#{QRZM_211119_84}")--����δ�ﵽ15�����޷��μ�õ�崫����
		return
	end
	
	--ͼ����˸��ʧ			
	LoverTimeEnter_Icon : PlayWarning( 0 )
	--����tips��ʧ
	CloseFreshManGuide()
	LoverTimeEnter_Icon : SetToolTip("#{QRZM_211119_276}")
	
	--�ж����а񴰿��Ƿ��
	if(IsWindowShow("LoverTimeTopList")) then
		CloseWindow("LoverTimeTopList", true)
		return
	end
	
	--�ж���ȴʱ��
	if g_InCooldown == 0 then--��ȴʱ���ѵ�
		--�������������
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "ClientAskQingRenJieTopList" )
			Set_XSCRIPT_ScriptID( 892974 )
			Set_XSCRIPT_Parameter(0,0)
			Set_XSCRIPT_Parameter(1,1)
			Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT()
		--������ȴʱ��
		g_InCooldown = 1
		SetTimer("LoverTimeEnter", "LoverTimeEnter_Cooldown()",g_Cooldown)
	else--��ȴʱ��δ��
		PushDebugMessage("#{QRZM_211119_163}")--���Ĳ�������Ƶ�������Ժ����г���
	end
end

--===============================================
-- ��ȴ��ʱ����()
--===============================================
function LoverTimeEnter_Cooldown()
	g_InCooldown = 0
	KillTimer("LoverTimeEnter_Cooldown()")
end

--===============================================
-- ��˸��ʱ����()
--===============================================
function LoverTimeEnter_PlayWarning()
	--ͼ����˸��ʧ			
	LoverTimeEnter_Icon : PlayWarning( 0 )
	--����tips��ʧ
	CloseFreshManGuide()
	LoverTimeEnter_Icon : SetToolTip("#{QRZM_211119_276}")
	--��˸��ʱֹͣ
	g_InPlayWarning = 0
	KillTimer("LoverTimeEnter_PlayWarning()")
end
