--playerQuicklyEnterUI
--=======================================
local playerQuicklyEnterUI = {}            -- UI名称
local playerQuicklyEnterAnimateBtn = {}    -- 动态提示按钮

--**********************************
-- PRELOAD 变化时
--**********************************
function PlayerQuicklyEnter_PreLoad()
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED");    -- 游戏分辨率发生了变化
	this:RegisterEvent("SCENE_TRANSED")
	this:RegisterEvent("UI_COMMAND")
end
--**********************************
-- ONLOAD
--**********************************
function PlayerQuicklyEnter_OnLoad()
	--载入
	playerQuicklyEnterUI[1] = PlayerQuicklyEnter_Bk8;
	playerQuicklyEnterUI[2] = PlayerQuicklyEnter_Bk6;
	playerQuicklyEnterUI[3] = PlayerQuicklyEnter_Bk3;
	playerQuicklyEnterUI[4] = PlayerQuicklyEnter_Bk2;
	playerQuicklyEnterUI[5] = PlayerQuicklyEnter_Bk1;
	playerQuicklyEnterUI[6] = PlayerQuicklyEnter_Bk1;
	playerQuicklyEnterAnimateBtn[1] = PlayerQuicklyEnter_Image1;
	playerQuicklyEnterAnimateBtn[2] = PlayerQuicklyEnter_Image2;
	playerQuicklyEnterAnimateBtn[3] = PlayerQuicklyEnter_Image3;
	
	for i, m in playerQuicklyEnterUI do
		m:Show()
	end
	PlayerQuicklyEnter_UpdateButton()
end
function PlayerQuicklyEnter_UpdateButton()

end
--**********************************
-- ONEvent
--**********************************
function PlayerQuicklyEnter_OnEvent(event)
	if (event == "VIEW_RESOLUTION_CHANGED") then
		local xmax, ymax = GetCurClientSize()
		g_nScreenWidth = xmax                    --width为游戏屏幕宽度
		g_nScreenHeight = ymax        --height为游戏屏幕宽度
		g_nScreenWidth = math.floor(g_nScreenWidth);
		g_nScreenHeight = math.floor(g_nScreenHeight);
	elseif (event == "SCENE_TRANSED") then
		--this:Hide()--隐藏主窗口
		this:Show();--载入主窗口
	elseif (event == "UI_COMMAND") and (arg0 == "201807310") then
		this:Show();
	end
end
function PlayerQuicklyEnter_UpdateUIPos()
	local nNextIndex = g_nButtonCount
	local nSizeIndex = 1
	if (g_nScreenWidth <= g_nScreenWidthLimit) then
		nSizeIndex = 1
	else
		nSizeIndex = 2
	end
	local nMinimapWidth = 278
	PlayerQuicklyEnter_Frame:SetProperty("UnifiedPosition", "{{1.000000, " .. tostring(-1 * (nNextIndex + 1) * BkSize[nSizeIndex][1] - nMinimapWidth) .. "},{0.000000,3}}")
	PlayerQuicklyEnter_Frame:SetProperty("AbsoluteSize", "w:" .. (nNextIndex + 1) * BkSize[nSizeIndex][1] .. " h:" .. BkSize[nSizeIndex][2] .. "")
	for i = 1, g_nButtonCount do
		nNextIndex = nNextIndex - 1
		-- BK
		playerQuicklyEnterUI[i]:SetProperty("UnifiedPosition", "{{0.000000," .. nNextIndex * BkSize[nSizeIndex][1] .. "},{0.000000,0}}")
		playerQuicklyEnterUI[i]:SetProperty("UnifiedSize", "{{0.000000," .. BkSize[nSizeIndex][1] .. "},{0.000000," .. BkSize[nSizeIndex][2] .. "}}")
		-- Image
		playerQuicklyEnterAnimateBtn[i]:SetProperty("UnifiedSize", "{{0.000000," .. BkSize[nSizeIndex][1] .. "},{0.000000," .. BkSize[nSizeIndex][2] .. "}}")
	end
end
--**********************************
-- 按钮事件
--**********************************
function PlayerQuicklyEnter_Clicked(nIndex)
	if nIndex == 1 then
		--扫荡
		Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OpenSecKillList");
		Set_XSCRIPT_ScriptID(891062);
		Set_XSCRIPT_ParamCount(0);
		Send_XSCRIPT()
	elseif nIndex == 2 then
		--周活跃
		Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OpenZhouHuoYue");
		Set_XSCRIPT_ScriptID(892002);
		Set_XSCRIPT_Parameter(0, 0);
		Set_XSCRIPT_ParamCount(1);
		Send_XSCRIPT()
	end
end













