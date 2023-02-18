-- 转门派引导手册
-- build 2019-8-10 18:05:45 逍遥子
local g_Frame_UnifiedXPosition;
local g_Frame_UnifiedYPosition;

local g_HandBookFrameList = {}

local g_ModifyMenPai_HandBook_CurPage = 1;

local g_ModifyMenPai_HandBook_MaxPage = 4;

local g_HandBookID = 38002562;

function ModifyMenPai_HandBook_PreLoad()

	this:RegisterEvent("UI_COMMAND")
	
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS",false)

	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
end

function ModifyMenPai_HandBook_OnLoad()
	-- 保存界面的默认相对位置
	g_Frame_UnifiedXPosition	= ModifyMenPai_HandBook_Frame:GetProperty("UnifiedXPosition");
	g_Frame_UnifiedYPosition	= ModifyMenPai_HandBook_Frame:GetProperty("UnifiedYPosition");


	g_HandBookFrameList[1] = ModifyMenPai_HandBook_ZhiYin1;
	g_HandBookFrameList[2] = ModifyMenPai_HandBook_ZhiYin2;
	g_HandBookFrameList[3] = ModifyMenPai_HandBook_ZhiYin3;
	g_HandBookFrameList[4] = ModifyMenPai_HandBook_ZhiYin4;
	
	g_ModifyMenPai_HandBook_CurPage = 1;
end

function ModifyMenPai_HandBook_OnEvent(event)

	if( event == "ADJEST_UI_POS" ) then
		ModifyMenPai_HandBook_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		ModifyMenPai_HandBook_ResetPos()
	elseif( event == "UI_COMMAND" and tonumber(arg0) == 810209111) then		
		if(IsWindowShow("ModifyMenPai_HandBook")) then
			CloseWindow("ModifyMenPai_HandBook", true)
			return
		end
		
		if g_ModifyMenPai_HandBook_CurPage == 1 then
			ModifyMenPai_HandBook_UpPage:Disable()
		else 
			ModifyMenPai_HandBook_UpPage:Enable()
		end
		
		if g_ModifyMenPai_HandBook_CurPage == g_ModifyMenPai_HandBook_MaxPage then
			ModifyMenPai_HandBook_DownPage:Disable()
		else 
			ModifyMenPai_HandBook_DownPage:Enable()
		end
		
		for idx = 1, g_ModifyMenPai_HandBook_MaxPage do
			if idx == g_ModifyMenPai_HandBook_CurPage then
				g_HandBookFrameList[idx]:Show()
			else
				g_HandBookFrameList[idx]:Hide()
			end
		end
	
		this:Show()
	end
end
--================================================
-- 恢复界面的默认相对位置
--================================================
function ModifyMenPai_HandBook_ResetPos()
	ModifyMenPai_HandBook_Frame:SetProperty("UnifiedXPosition", g_Frame_UnifiedXPosition);
	ModifyMenPai_HandBook_Frame:SetProperty("UnifiedYPosition", g_Frame_UnifiedYPosition);
end

function ModifyMenPai_HandBook_CloseWindow()
	this:Hide()
	g_ModifyMenPai_HandBook_CurPage = 1;
end
function ModifyMenPai_HandBook_OnHiden()
	this:Hide()
	g_ModifyMenPai_HandBook_CurPage = 1;
end


function ModifyMenPai_HandBook_Pre_Click()
	ModifyMenPai_HandBook_DownPage:Enable()
    if g_ModifyMenPai_HandBook_CurPage < 1 or g_ModifyMenPai_HandBook_CurPage > g_ModifyMenPai_HandBook_MaxPage then
		g_ModifyMenPai_HandBook_CurPage = 1
    end
	
	if g_ModifyMenPai_HandBook_CurPage - 1 <= 1 then
		g_ModifyMenPai_HandBook_CurPage = 1
		ModifyMenPai_HandBook_UpPage:Disable()
	else
		g_ModifyMenPai_HandBook_CurPage = g_ModifyMenPai_HandBook_CurPage - 1
	end	
   
	for idx = 1, g_ModifyMenPai_HandBook_MaxPage do
		if idx == g_ModifyMenPai_HandBook_CurPage then
			g_HandBookFrameList[idx]:Show()
		else
			g_HandBookFrameList[idx]:Hide()
		end
	end
end

function ModifyMenPai_HandBook_Next_Click()
	ModifyMenPai_HandBook_UpPage:Enable();
    if g_ModifyMenPai_HandBook_CurPage < 1 or g_ModifyMenPai_HandBook_CurPage > g_ModifyMenPai_HandBook_MaxPage then
		g_ModifyMenPai_HandBook_CurPage = g_ModifyMenPai_HandBook_MaxPage
    end
	
	if g_ModifyMenPai_HandBook_CurPage + 1 >= g_ModifyMenPai_HandBook_MaxPage then
		g_ModifyMenPai_HandBook_CurPage = g_ModifyMenPai_HandBook_MaxPage
		ModifyMenPai_HandBook_DownPage:Disable()
	else
		g_ModifyMenPai_HandBook_CurPage = g_ModifyMenPai_HandBook_CurPage + 1
	end	
   
	for idx = 1, g_ModifyMenPai_HandBook_MaxPage do
		if idx == g_ModifyMenPai_HandBook_CurPage then
			g_HandBookFrameList[idx]:Show()
		else
			g_HandBookFrameList[idx]:Hide()
		end
	end
end
