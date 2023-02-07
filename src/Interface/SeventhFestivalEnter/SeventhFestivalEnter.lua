----------------------
-- SeventhFestivalEnter ---
----------------------

local g_Cooldown = 4*1000		--4s按钮冷却
local g_InCooldown = 0			--是否在冷却

local g_PlayWarning = 10*1000		--10s闪烁按钮冷却
local g_InPlayWarning = 1			--是否在闪烁冷却

local g_LevelLimit = 15	--显示按钮的最小等级

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
	
	--关闭界面
	if bFlash == 2 then
		if this:IsVisible() then
			this:Hide()
		end
	elseif bFlash == 0 or bFlash == 1 then--显示界面
		if this:IsVisible() then
			--不处理
		else
			--界面显示
			this:Show()
				
			--闪烁时间判断
			if bFlash == 1 then
				--图标闪烁			
				SeventhFestivalEnter_Icon : PlayWarning( 1 )
				--开启tips
				--local fX, fY = this:GetChildOffset("PlayerFrame_SongjincansiButton")
				--OpenFreshManGuide(1, 82, fX + 39, fY + 39, "SeventhFestivalEnter", "northeast")
				SeventhFestivalEnter_Icon : SetToolTip("")
				--设置闪烁冷却时间
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
		
	--等级判断
	local nLevel = Player:GetData( "LEVEL" )
	if( nLevel < g_LevelLimit ) then
		PushDebugMessage("#{QXHB_20210701_84}")--您尚未达到15级，无法参加玫瑰传情活动。
		return
	end
	
	--图标闪烁消失			
	SeventhFestivalEnter_Icon : PlayWarning( 0 )
	--浮动tips消失
	CloseFreshManGuide()
	SeventhFestivalEnter_Icon : SetToolTip("#{QXLS_150724_03}")
	
	--判断排行榜窗口是否打开
	if(IsWindowShow("SeventhFestivalTopList")) then
		CloseWindow("SeventhFestivalTopList", true)
		return
	end
	
	--判断冷却时间
	if g_InCooldown == 0 then--冷却时间已到
		--请求服务器数据
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "ClientAskQixiTopList" )
			Set_XSCRIPT_ScriptID( 891396 )--待修改脚本号：891049
			Set_XSCRIPT_Parameter(0,0)
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
		--设置冷却时间
		g_InCooldown = 1
		SetTimer("SeventhFestivalEnter", "SeventhFestivalEnter_g_Cooldown()",g_Cooldown)
	else--冷却时间未到
		PushDebugMessage("#{QXHB_20210701_163}")--您的操作过于频繁，请稍后再行尝试
	end
end

--===============================================
-- 冷却计时结束()
--===============================================
function SeventhFestivalEnter_g_Cooldown()
	g_InCooldown = 0
	KillTimer("SeventhFestivalEnter_g_Cooldown()")
end

--===============================================
-- 闪烁计时结束()
--===============================================
function SeventhFestivalEnter_g_PlayWarning()
	--图标闪烁消失			
	SeventhFestivalEnter_Icon : PlayWarning( 0 )
	--浮动tips消失
	CloseFreshManGuide()
	SeventhFestivalEnter_Icon : SetToolTip("#{QXLS_150724_03}")
	--闪烁计时停止
	g_InPlayWarning = 0
	KillTimer("SeventhFestivalEnter_g_PlayWarning()")
end
