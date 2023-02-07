-- 新比武大会匹配提示
local g_TimerTick = -1
local g_TimerId = -1
local g_HuaShanLunJian_Ing_Animate = {};

function HuaShanLunJian_Ing_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
end


function HuaShanLunJian_Ing_OnLoad()
	g_HuaShanLunJian_Ing_Animate[1] = HuaShanLunJian_Ing_Animate2
	g_HuaShanLunJian_Ing_Animate[2] = HuaShanLunJian_Ing_Animate3
end

function HuaShanLunJian_Ing_OnEvent(event)

	if event == "UI_COMMAND" then
	    if tonumber(arg0) ~= 20180912 then
	        return
	    end
		
		local nIndex = Get_XParam_INT(0);
		if nIndex < 1 or nIndex > table.getn(g_HuaShanLunJian_Ing_Animate) then
			return
		end

		for i=1, table.getn(g_HuaShanLunJian_Ing_Animate) do
			if i == nIndex then
				g_HuaShanLunJian_Ing_Animate[i]:Show()
			else
				g_HuaShanLunJian_Ing_Animate[i]:Hide()
			end
		end

		if g_TimerId > 0 then
			KillTimer("HuaShanLunJian_Ing_Timer()")
			g_TimerId = -1
		end

		g_TimerTick = 6
		g_TimerId = SetTimer("HuaShanLunJian_Ing","HuaShanLunJian_Ing_Timer()", 1*1000)
		this:Show()

	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		KillTimer("HuaShanLunJian_Ing_Timer()")
		g_TimerId = -1
		this:Hide()
	end
end

function HuaShanLunJian_Ing_Timer()
	g_TimerTick = g_TimerTick - 1
	--PushDebugMessage(g_TimerTick)
	if g_TimerTick <= 0 then
		KillTimer("HuaShanLunJian_Ing_Timer()")
		g_TimerId = -1
		this:Hide()
	end
end
