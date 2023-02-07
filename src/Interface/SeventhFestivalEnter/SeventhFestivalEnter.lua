----------------------
-- SeventhFestivalEnter ---
----------------------

local g_Cooldown = 4*1000		--4s��ť��ȴ
local g_InCooldown = 0			--�Ƿ�����ȴ

local g_PlayWarning = 10*1000		--10s��˸��ť��ȴ
local g_InPlayWarning = 1			--�Ƿ�����˸��ȴ

local g_LevelLimit = 15	--��ʾ��ť����С�ȼ�

--===============================================
-- PreLoad()
--===============================================
function SeventhFestivalEnter_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("HIDE_TLBB_MAIN")
	this:RegisterEvent("HIDE_THIS_UI")
end

--===============================================
-- OnLoad()
--===============================================
function SeventhFestivalEnter_OnLoad()

end

--===============================================
-- OnEvent()
--===============================================
function SeventhFestivalEnter_OnEvent(event)
	if (event  == "UI_COMMAND") and (tonumber(arg0) == 89139601) then
		local bFlash = Get_XParam_INT(0)
		SeventhFestivalEnter_ShowIcon(bFlash)
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
function SeventhFestivalEnter_ShowIcon(bFlash)
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
				SeventhFestivalEnter_Icon : PlayWarning( 1 )
				--����tips
				--local fX, fY = this:GetChildOffset("PlayerFrame_SongjincansiButton")
				--OpenFreshManGuide(1, 82, fX + 39, fY + 39, "SeventhFestivalEnter", "northeast")
				SeventhFestivalEnter_Icon : SetToolTip("")
				--������˸��ȴʱ��
				g_InPlayWarning = 1
				SetTimer("SeventhFestivalEnter", "SeventhFestivalEnter_g_PlayWarning()",g_PlayWarning)
			end
		end
	end
end

--===============================================
-- OnClick()
--===============================================
function SeventhFestivalEnter_OnClick()
		
	--�ȼ��ж�
	local nLevel = Player:GetData( "LEVEL" )
	if( nLevel < g_LevelLimit ) then
		PushDebugMessage("#{QXHB_20210701_84}")--����δ�ﵽ15�����޷��μ�õ�崫����
		return
	end
	
	--ͼ����˸��ʧ			
	SeventhFestivalEnter_Icon : PlayWarning( 0 )
	--����tips��ʧ
	CloseFreshManGuide()
	SeventhFestivalEnter_Icon : SetToolTip("#{QXLS_150724_03}")
	
	--�ж����а񴰿��Ƿ��
	if(IsWindowShow("SeventhFestivalTopList")) then
		CloseWindow("SeventhFestivalTopList", true)
		return
	end
	
	--�ж���ȴʱ��
	if g_InCooldown == 0 then--��ȴʱ���ѵ�
		--�������������
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "ClientAskQixiTopList" )
			Set_XSCRIPT_ScriptID( 891396 )--���޸Ľű��ţ�891049
			Set_XSCRIPT_Parameter(0,0)
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
		--������ȴʱ��
		g_InCooldown = 1
		SetTimer("SeventhFestivalEnter", "SeventhFestivalEnter_g_Cooldown()",g_Cooldown)
	else--��ȴʱ��δ��
		PushDebugMessage("#{QXHB_20210701_163}")--���Ĳ�������Ƶ�������Ժ����г���
	end
end

--===============================================
-- ��ȴ��ʱ����()
--===============================================
function SeventhFestivalEnter_g_Cooldown()
	g_InCooldown = 0
	KillTimer("SeventhFestivalEnter_g_Cooldown()")
end

--===============================================
-- ��˸��ʱ����()
--===============================================
function SeventhFestivalEnter_g_PlayWarning()
	--ͼ����˸��ʧ			
	SeventhFestivalEnter_Icon : PlayWarning( 0 )
	--����tips��ʧ
	CloseFreshManGuide()
	SeventhFestivalEnter_Icon : SetToolTip("#{QXLS_150724_03}")
	--��˸��ʱֹͣ
	g_InPlayWarning = 0
	KillTimer("SeventhFestivalEnter_g_PlayWarning()")
end
