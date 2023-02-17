local g_BossTopList_Data = {}
local g_BossTopList_Scene = 0
local g_BossTopList_UnifiedPosition;
local MenPaiName = {"少林","明教","丐帮","武当","峨嵋","星宿","天龙","天山","逍遥","无门派","曼陀山庄"}
function BossTopList_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	--离开场景，自动关闭
	this:RegisterEvent("PLAYER_LEAVE_WORLD", false)	
	this:RegisterEvent("QIHUANTIME_SWITCH")
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")	
	this:RegisterEvent("TOGLE_SYSTEMFRAME");
end
--界面21点50到24点显示
function BossTopList_OnLoad()	
	-- g_BossTopList_Data[1] = {title = "#{MJXZ_210510_09}",board="#{MJXZ_210510_10}",msg="#{MJXZ_210510_11}"}
	-- g_BossTopList_Data[2] = {title = "#{MJXZ_210510_18}",board="#{MJXZ_210510_19}",msg="#{MJXZ_210510_20}"}
	-- g_BossTopList_Data[3] = {title = "#{MJXZ_210510_21}",board="#{MJXZ_210510_22}",msg="#{MJXZ_210510_23}"}
	-- g_BossTopList_Data[4] = {title = "#{MJXZ_210510_26}",board="#{MJXZ_210510_27}",msg="#{MJXZ_210510_28}"}
	g_BossTopList_UnifiedPosition  =BossTopList:GetProperty("UnifiedPosition");
end

function BossTopList_OnEvent(event)

	if event == "UI_COMMAND" and tonumber(arg0) == 20220510 then
		BossTopList_List:RemoveAllItem()
		g_BossTopList_Data = {}
		BossTopList_InitFrame()
		this:Show()
	end
	if event == "UI_COMMAND" and tonumber(arg0) == 20220511 then
			g_BossTopList_Scene = 0
			BossTopListUpdata()
	end
	if event == "QIHUANTIME_SWITCH" then
		if tonumber(arg0) == 400 or tonumber(arg0) == 401 then
			this:Show()
		else
			this:Hide()
		end
	end

			-- 游戏窗口尺寸发生了变化
	if (event == "ADJEST_UI_POS" ) then
		BossTopList_On_ResetPos()
	-- 游戏分辨率发生了变化
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		BossTopList_On_ResetPos()
	elseif (event == "PLAYER_LEAVE_WORLD") then
		this:Hide()
	elseif event == "TOGLE_SYSTEMFRAME" then
		this:Hide()
	end
end

function BossTopList_TimeReach(nIndex)
	if nIndex == 1 then
		g_BossTopList_Scene = 1
	end
	if nIndex == 2 then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "acme_spend" );
			Set_XSCRIPT_ScriptID(810114);
			Set_XSCRIPT_ParamCount(0);
		Send_XSCRIPT()
		BossTopList_Time2:SetProperty("Timer", "60");		
	end
end

function BossTopListUpdata()
	if g_BossTopList_Scene == 1 then
		return
	end
	for i = 1,10 do
		BossTopList_List:AddNewItem(i, 0, i-1);
	end
end

function BossTopList_On_ResetPos()
	BossTopList:SetProperty("UnifiedPosition", g_BossTopList_UnifiedPosition);
end

function BossTopList_InitFrame()
	
	for i = 1,10 do
		if Get_XParam_STR(i-1) ~= "" and Get_XParam_STR(i-1) ~= nil then
			g_BossTopList_Data[i] = Split(Get_XParam_STR(i-1),",")
		end
	end
	for i = 1,10 do
		if g_BossTopList_Data[i] ~= nil then
			BossTopList_List:AddNewItem(i, 0, i-1);
			BossTopList_List:AddNewItem(MenPaiName[tonumber(g_BossTopList_Data[i][1])+1], 1, i-1);
			BossTopList_List:AddNewItem(g_BossTopList_Data[i][2], 2, i-1);
			BossTopList_List:AddNewItem(g_BossTopList_Data[i][3], 3, i-1);
		end
	end
end

function BossTopList_OpenMini()
	PushEvent("QIHUANTIME_SWITCH",0,g_BossTopList_Scene)
end