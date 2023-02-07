--Anniversary_Show.lua
--领取奖励

local g_Anniversary_Show_Iamge ={}

local g_Anniversary_Show_Animate ={}

local g_Anniversary_Show_Iamge_Index = 1

local g_Anniversary_Show_Iamge_UnifiedXPosition = {}
local g_Anniversary_Show_Iamge_UnifiedYPosition = {}

local curPage =1

function Anniversary_Show_PreLoad()
	this:RegisterEvent("OPEN_ANNIVERSARY_IMAGE");
	this:RegisterEvent("UI_COMMAND");
end

function Anniversary_Show_OnLoad()

	g_Anniversary_Show_Iamge[1] = Anniversary_Show_Image1
	g_Anniversary_Show_Iamge[2] = Anniversary_Show_Image2
	g_Anniversary_Show_Iamge[3] = Anniversary_Show_Image3
	g_Anniversary_Show_Iamge[4] = Anniversary_Show_Image4
	g_Anniversary_Show_Iamge[5] = Anniversary_Show_Image5
	g_Anniversary_Show_Iamge[6] = Anniversary_Show_Image6

	g_Anniversary_Show_Animate[1] = Anniversary_Show_Image1Animate
	g_Anniversary_Show_Animate[2] = Anniversary_Show_Image2Animate
	g_Anniversary_Show_Animate[3] = Anniversary_Show_Image3Animate
	g_Anniversary_Show_Animate[4] = Anniversary_Show_Image4Animate
	g_Anniversary_Show_Animate[5] = Anniversary_Show_Image5Animate
	g_Anniversary_Show_Animate[6] = Anniversary_Show_Image6Animate

	g_Anniversary_Show_Iamge_UnifiedXPosition[1] = g_Anniversary_Show_Iamge[1]:GetProperty("UnifiedXPosition")
	g_Anniversary_Show_Iamge_UnifiedXPosition[2] = g_Anniversary_Show_Iamge[2]:GetProperty("UnifiedXPosition")
	g_Anniversary_Show_Iamge_UnifiedXPosition[3] = g_Anniversary_Show_Iamge[3]:GetProperty("UnifiedXPosition")
	g_Anniversary_Show_Iamge_UnifiedXPosition[4] = g_Anniversary_Show_Iamge[4]:GetProperty("UnifiedXPosition")
	g_Anniversary_Show_Iamge_UnifiedXPosition[5] = g_Anniversary_Show_Iamge[5]:GetProperty("UnifiedXPosition")
	g_Anniversary_Show_Iamge_UnifiedXPosition[6] = g_Anniversary_Show_Iamge[6]:GetProperty("UnifiedXPosition")

	g_Anniversary_Show_Iamge_UnifiedYPosition[1] = g_Anniversary_Show_Iamge[1]:GetProperty("UnifiedYPosition")
	g_Anniversary_Show_Iamge_UnifiedYPosition[2] = g_Anniversary_Show_Iamge[2]:GetProperty("UnifiedYPosition")
	g_Anniversary_Show_Iamge_UnifiedYPosition[3] = g_Anniversary_Show_Iamge[3]:GetProperty("UnifiedYPosition")
	g_Anniversary_Show_Iamge_UnifiedYPosition[4] = g_Anniversary_Show_Iamge[4]:GetProperty("UnifiedYPosition")
	g_Anniversary_Show_Iamge_UnifiedYPosition[5] = g_Anniversary_Show_Iamge[5]:GetProperty("UnifiedYPosition")
	g_Anniversary_Show_Iamge_UnifiedYPosition[6] = g_Anniversary_Show_Iamge[6]:GetProperty("UnifiedYPosition")


end

function Anniversary_Show_OnEvent(event)

	if ( event == "OPEN_ANNIVERSARY_IMAGE"  ) then

		g_Anniversary_Show_Iamge_Index = tonumber(arg0)
		Anniversary_Show_FreshWindow(tonumber(arg0))
		this:Show()
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 89118101 ) then
		g_Anniversary_Show_Iamge_Index =  Get_XParam_INT(0)
		Anniversary_Show_FreshWindowDynamic(g_Anniversary_Show_Iamge_Index)
		this:Show()
	end

end

--刷新界面
function Anniversary_Show_FreshWindow(nIndex)

	for i =1,6 do
		if i == nIndex then

			g_Anniversary_Show_Iamge[i]:Show()

		--	g_Anniversary_Show_Iamge[i]:Tween_SetInfo("Position", "curve:Liner mode:Once duration:2.0 startx:-800 starty:0 endx:0 endy:0")

		--	g_Anniversary_Show_Iamge[i]:Tween_Play("Position", true, true)

		--	curPage = i
		--	SetTimer("Anniversary_Show","Anniversary_Show_OnTweenTimer()", 2*1000)

		else
			g_Anniversary_Show_Iamge[i]:Hide()
		end
	end

end

function Anniversary_Show_OnTweenTimer()
	g_Anniversary_Show_Animate[curPage]:Play(true)
	KillTimer("Anniversary_Show_OnTweenTimer()")
end

function Anniversary_Show_FreshWindowDynamic(nIndex)
	for i =1,6 do
		if i == nIndex then

			g_Anniversary_Show_Iamge[i]:Show()

			g_Anniversary_Show_Iamge[i]:Tween_SetInfo("Position", "curve:Liner mode:Once duration:2.0 startx:-800 starty:0 endx:0 endy:0")

			g_Anniversary_Show_Iamge[i]:Tween_Play("Position", true, true)

			curPage = i
			SetTimer("Anniversary_Show","Anniversary_Show_OnTweenTimer()", 2*1000)

		else
			g_Anniversary_Show_Iamge[i]:Hide()
		end
	end

end


function Anniversary_Show_OnHiden()
	Anniversary_Show_Close()
end

function Anniversary_Show_Close()
	for i =1,6 do
		g_Anniversary_Show_Iamge[i]:Tween_Reset("Position",true)
		g_Anniversary_Show_Iamge[i] : SetProperty("UnifiedXPosition", g_Anniversary_Show_Iamge_UnifiedXPosition[i]);
		g_Anniversary_Show_Iamge[i] : SetProperty("UnifiedYPosition", g_Anniversary_Show_Iamge_UnifiedYPosition[i]);

	end
	KillTimer("Anniversary_Show_OnTweenTimer()")
	this:Hide()
end
