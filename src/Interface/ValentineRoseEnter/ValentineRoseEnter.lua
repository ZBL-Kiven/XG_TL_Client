----------------------
-- ValentineRoseEnter ---
----------------------

local g_Cooldown = 4*1000		--4s��ť��ȴ
local g_InCooldown = 0			--�Ƿ�����ȴ

local g_PlayWarning = 10*1000		--10s��˸��ť��ȴ
local g_InPlayWarning = 1			--�Ƿ�����˸��ȴ

local g_LevelLimit = 15	--��ʾ��ť����С�ȼ�

--===============================================
-- PreLoad()
--===============================================
function ValentineRoseEnter_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("HIDE_TLBB_MAIN")
	this:RegisterEvent("HIDE_THIS_UI")
end

--===============================================
-- OnLoad()
--===============================================
function ValentineRoseEnter_OnLoad()

end

--===============================================
-- OnEvent()
--===============================================
function ValentineRoseEnter_OnEvent(event)
	if (event  == "UI_COMMAND") and (tonumber(arg0) == 89104901) then
		local bFlash = Get_XParam_INT(0)
		ValentineRoseEnter_ShowIcon(bFlash)
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
function ValentineRoseEnter_ShowIcon(bFlash)
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
				ValentineRoseEnter_Icon : PlayWarning( 1 )
				--����tips
				--local fX, fY = this:GetChildOffset("PlayerFrame_SongjincansiButton")
				--OpenFreshManGuide(1, 92, fX + 39, fY + 39, "ValentineRoseEnter", "northeast")
				ValentineRoseEnter_Icon : SetToolTip("")
				--������˸��ȴʱ��
				g_InPlayWarning = 1
				SetTimer("ValentineRoseEnter", "ValentineRoseEnter_g_PlayWarning()",g_PlayWarning)
			end
		end
	end
end

--===============================================
-- OnClick()
--===============================================
function ValentineRoseEnter_OnClick()
	--�ȼ��ж�
	local nLevel = Player:GetData( "LEVEL" )
	if( nLevel < g_LevelLimit ) then
		PushDebugMessage("#{MGCQ_151230_02}")--����δ�ﵽ15�����޷��μ�õ�崫����
		return
	end
	
	--ͼ����˸��ʧ			
	ValentineRoseEnter_Icon : PlayWarning( 0 )
	--����tips��ʧ
	--if "ValentineRoseEnter" == GetFreshManGuideOwner() then
	--	CloseFreshManGuide()      --������uiָ�򱾽���,����Ҫ��Ӧ
	--end
	ValentineRoseEnter_Icon : SetToolTip("#{MGCQ_151230_03}")
	
	--�ж����а񴰿��Ƿ��
	if(IsWindowShow("ValentineRoseTopList")) then
		CloseWindow("ValentineRoseTopList", true)
		return
	end
	
	--�ж���ȴʱ��
	if g_InCooldown == 0 then--��ȴʱ���ѵ�
		--�������������
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "ClientAskRoseTopList" )
			Set_XSCRIPT_ScriptID( 891049 )--���޸Ľű��ţ�891049
			Set_XSCRIPT_Parameter(0,0)
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
		--������ȴʱ��
		g_InCooldown = 1
		SetTimer("ValentineRoseEnter", "ValentineRoseEnter_g_Cooldown()",g_Cooldown)
	else--��ȴʱ��δ��
		PushDebugMessage("#{MGCQ_151230_01}")--���Ĳ�������Ƶ�������Ժ����г���
	end
end

--===============================================
-- ��ȴ��ʱ����()
--===============================================
function ValentineRoseEnter_g_Cooldown()
	g_InCooldown = 0
	KillTimer("ValentineRoseEnter_g_Cooldown()")
end

--===============================================
-- ��˸��ʱ����()
--===============================================
function ValentineRoseEnter_g_PlayWarning()
	--ͼ����˸��ʧ			
	ValentineRoseEnter_Icon : PlayWarning( 0 )
	--����tips��ʧ
	--if "ValentineRoseEnter" == GetFreshManGuideOwner() then
	--	CloseFreshManGuide()      --������uiָ�򱾽���,����Ҫ��Ӧ
	--end
	ValentineRoseEnter_Icon : SetToolTip("#{MGCQ_151230_03}")
	--��˸��ʱֹͣ
	g_InPlayWarning = 0
	KillTimer("ValentineRoseEnter_g_PlayWarning()")
end
