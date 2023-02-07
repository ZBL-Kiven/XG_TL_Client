--******************************************
--新杀星副本	玩家积分界面
--create by  limengyue 
--2022-07-29
--******************************************

local g_ShaXing_Tips_Frame_UnifiedXPosition;
local g_ShaXing_Tips_Frame_UnifiedYPosition;


--服务器不传字典 直接传编号提示
local g_ShaXing_Tips_BossIdxList = 
{
	[1] = {tips="#{XSX_220705_357}"},--请前往枯竹大师处点击“破禁有法”进行难度选择，并由队长作出最终选择。
	[2] = {tips="#{XSX_220705_358}"},--请前往枯竹大师处沟通下一关的难度，并由队长作出最终选择 
	[3] = {tips="#{XSX_220705_359}"},--本关已放弃，请前往枯竹大师处沟通下一关的难度，并由队长作出最终选择。 
	[4] = {tips="#{XSX_220705_364}"},--#W挑战失败，请前往#R枯竹大师#W处重新沟通，并由队长作出#G最终选择#W。
}


--=========================================================
--PreLoad
--=========================================================
function ShaXing_Tips_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	--距离NPC距离
	this:RegisterEvent("OBJECT_CARED_EVENT",false)
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)	
	--切场景事件
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false);
	this:RegisterEvent("SCENE_TRANSED");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
end

--=========================================================
--OnLoad
--=========================================================
function ShaXing_Tips_OnLoad()
	g_ShaXing_Tips_Frame_UnifiedXPosition	= ShaXing_Tips : GetProperty("UnifiedXPosition");
	g_ShaXing_Tips_Frame_UnifiedYPosition	= ShaXing_Tips : GetProperty("UnifiedYPosition");
end

--=========================================================
--恢复界面的默认相对位置
--=========================================================
function ShaXing_Tips_On_ResetPos()

	
	ShaXing_Tips : SetProperty("UnifiedXPosition", g_ShaXing_Tips_Frame_UnifiedXPosition);
	ShaXing_Tips : SetProperty("UnifiedYPosition", g_ShaXing_Tips_Frame_UnifiedYPosition);

end

--=========================================================
--OnEvent
--=========================================================
function ShaXing_Tips_OnEvent(event)
	if (event == "UI_COMMAND" and tonumber(arg0) == 89331105 ) then
		--打开界面
		if(IsWindowShow("ShaXing_Tips")) then
			CloseWindow("ShaXing_Tips", true)
		end
		ShaXing_Tips_Open(Get_XParam_INT(0))
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 189331105 )	then
		--打开界面
		if(IsWindowShow("ShaXing_Tips")) then
			CloseWindow("ShaXing_Tips", true)
		end
		ShaXing_Tips_Open(tonumber(arg1))		
	end
	-- 窗口变化
	if (event=="PLAYER_LEAVE_WORLD") then
		if( this:IsVisible() ) then
			this:Hide()
		end
	-- 游戏窗口尺寸发生了变化
	elseif (event == "ADJEST_UI_POS" ) then
		ShaXing_Tips_On_ResetPos();
	-- 游戏分辨率发生了变化
	elseif (event == "VIEW_RESOLUTION_CHANGED" ) then	
		ShaXing_Tips_On_ResetPos();
    elseif (event == "HIDE_ON_SCENE_TRANSED" ) then
       ShaXing_Tips_Close()
	elseif (event=="PLAYER_LEAVE_WORLD") then
		if( this:IsVisible() ) then
			this:Hide()
		end
    end	
end

--=========================================================
--打开界面
--=========================================================
function ShaXing_Tips_Open(nTipsIdx)
	if nTipsIdx < 1 then
		--关闭界面
		ShaXing_Tips_Close()
	else
		if g_ShaXing_Tips_BossIdxList[nTipsIdx] then
			ShaXing_Tips_Text:SetText(g_ShaXing_Tips_BossIdxList[nTipsIdx].tips)
			this:Show()
			SetTimer("ShaXing_Tips","ShaXing_Tips_Timer()", 5000)
		end
	end

end

function ShaXing_Tips_Timer()
	ShaXing_Tips_Open(0)
	KillTimer("ShaXing_Tips_Timer()")
end
--=========================================================
--关闭界面
--=========================================================
function ShaXing_Tips_Close()
	this:Hide()
end
