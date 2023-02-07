--春之计划-转盘票领取脚本(客户端)

local g_TicketGainCount = 0		--当前领取次数
local g_Controls = {} 			--控件列表
local g_Frame_UnifiedPosition = "";

function ChunfenWatch_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("SPRINTPLAN_TICKET_UPDATE")
	this:RegisterEvent("SWITCH_MENU_BUTTON");
	this:RegisterEvent("FRESHMAN_CHANGESTATE");
end

function ChunfenWatch_OnLoad()
	g_Controls = {
					m_Frame = ChunfenWatch_Frame_sub,
					m_DownTickWatch = ChunfenWatch_Time_Text,
					m_DownTickText = ChunfenWatch_Text,
					m_FlashAnimate = ChunfenWatch_BK,
					m_TipText = ChunfenWatch_Remainder,
					m_FinishText = ChunfenWatch_Finish,
					--m_DaoJishi = ChunfenWatch_DaoJiShi,
					
				}	
	g_Frame_UnifiedPosition=g_Controls.m_Frame:GetProperty("UnifiedPosition");
end

function  ChunfenWatch_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == 892675 ) then
			local nGainTicketCount = Get_XParam_INT(0)
			local nDownTick = Get_XParam_INT(1)
			local nOperate = Get_XParam_INT(2) --1更新并显示 0隐藏
			g_TicketGainCount = nGainTicketCount
			if nOperate == 2 then
				--最后一次领奖
				g_Controls.m_DownTickWatch:SetProperty("Timer",tostring(0));
				g_Controls.m_FinishText:Show()
				g_Controls.m_DownTickText:Hide()
				g_Controls.m_FlashAnimate:PlayWarning(0)
				--g_Controls.m_DaoJishi:Hide()
				local strTemp = ScriptGlobal_Format("#{YNZJ_141225_45}",4 - g_TicketGainCount)
				g_Controls.m_TipText:SetText(strTemp)
				this:Show()
				return
			end
			if nOperate == 0 then
				this:Hide();
				g_Controls.m_DownTickWatch:SetProperty("Timer",tostring(0));
				return
			end
			if nOperate == 1 then
				g_Controls.m_DownTickWatch:SetProperty("Timer",tostring(nDownTick));
				if nDownTick <= 0 then
					g_Controls.m_DownTickText:Show()
					g_Controls.m_FlashAnimate:PlayWarning(1)
				else
					g_Controls.m_DownTickText:Hide()
					g_Controls.m_FlashAnimate:PlayWarning(0)
				end
				local strTemp = ScriptGlobal_Format("#{YNZJ_141225_45}",4 - g_TicketGainCount)
				g_Controls.m_TipText:SetText(strTemp)
				g_Controls.m_FinishText:Hide()
				--g_Controls.m_DaoJishi:Show()
				this:Show();
			end	
	elseif (event == "SWITCH_MENU_BUTTON") then
		ChunfenWatch_UpdatePos()
	elseif (event == "FRESHMAN_CHANGESTATE") then
		ChunfenWatch_UpdatePos()
	elseif (event == "SPRINTPLAN_TICKET_UPDATE") then
		--跨天刷新
		--g_TicketGainCount = 0
		--ChunfenWatch_UpdatePos()
		--g_Controls.m_DownTickWatch:SetProperty("Timer",tostring(0));
		--g_Controls.m_DownTickText:Show()
		--g_Controls.m_FlashAnimate:PlayWarning(1)
		--this:Show();
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "ChunfenWatchUpdate" )
			Set_XSCRIPT_ScriptID( 892675 )
		Send_XSCRIPT()
	end
end

function ChunfenWatch_TimeOut()
	--播放按钮闪动动画
	g_Controls.m_FlashAnimate:PlayWarning(1)
	--更新计时器时间
	g_Controls.m_DownTickText:Show()
end

function ChunfenWatch_TimeOut1()
end

-- 领取转盘票
function  ChunfenWatch_Bn2Click()
  --在地府中不能领取
  local isInHell = IsInHell()
  if isInHell == 1 then
    return
  end
  
  --领取奖品请求
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "GainRollTicket" )
		Set_XSCRIPT_ScriptID( 892675 )
		Set_XSCRIPT_Parameter( 0, g_TicketGainCount )
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
end

--鼠标进入
function ChunfenWatch_MouseEnter()
	--显示提示
	g_Controls.m_FlashAnimate:SetToolTip("#{YNZJ_141225_07}")
end

--鼠标离开
function ChunfenWatch_MouseLeave()
	
end

function ChunfenWatch_UpdatePos()
	--暂时留着
	--if IsWindowShow("FreshmanWatch") == true then																					--新人领奖界面已打开
	--	if IsWindowShow("MainMenuBar_4") == true then																				--主快捷栏上有两排快捷栏
	--		g_Controls.m_Frame:SetProperty("UnifiedPosition", "{{0.500000,-60.000000},{1.000000,-345.000000}}");
	--	elseif IsWindowShow("MainMenuBar_2") == true then																			--主快捷栏上有上方快捷栏
	--		g_Controls.m_Frame:SetProperty("UnifiedPosition", "{{0.500000,-60.000000},{1.000000,-309.000000}}");
	--	else 																														--主快捷栏上没有快捷栏
	--		g_Controls.m_Frame:SetProperty("UnifiedPosition", "{{0.500000,-60.000000},{1.000000,-273.000000}}");
	--	end
	--else
	--	if IsWindowShow("MainMenuBar_4") == true then																				--主快捷栏上有两排快捷栏
	--		g_Controls.m_Frame:SetProperty("UnifiedPosition", "{{0.500000,-60.000000},{1.000000,-228.000000}}");
	--	elseif IsWindowShow("MainMenuBar_2") == true then																			--主快捷栏上有上方快捷栏
	--		g_Controls.m_Frame:SetProperty("UnifiedPosition", "{{0.500000,-60.000000},{1.000000,-192.000000}}");
	--	else 																														--主快捷栏上没有快捷栏
	--		g_Controls.m_Frame:SetProperty("UnifiedPosition", "{{0.500000,-60.000000},{1.000000,-156.000000}}");
	--	end
	--end
	g_Controls.m_Frame:SetProperty("UnifiedPosition", g_Frame_UnifiedPosition)
end


