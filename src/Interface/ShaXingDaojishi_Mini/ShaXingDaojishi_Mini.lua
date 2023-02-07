--******************************************
--新杀星副本	玩家积分界面mini
--create by  limengyue 
--2022-07-29
--******************************************

local g_ShaXingDaojishi_SelectBossIdx = -1	--当前boss索引
local g_ShaXingDaojishi_Mini_nGetInfo = ""
--=========================================================
--PreLoad
--=========================================================
function ShaXingDaojishi_Mini_PreLoad()
	this:RegisterEvent("XINSHAXING_MINI");
	this:RegisterEvent("SCENE_TRANSED");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	this:RegisterEvent("UI_COMMAND");
end

--=========================================================
--OnLoad
--=========================================================
function ShaXingDaojishi_Mini_OnLoad()
end

--=========================================================
--事件
--=========================================================
function ShaXingDaojishi_Mini_OnEvent(event)
	if (event=="SCENE_TRANSED") then
		this:Hide()
	elseif (event=="PLAYER_LEAVE_WORLD") then
		if( this:IsVisible() ) then
			this:Hide()
		end
	elseif (event=="UI_COMMAND" and tonumber(arg0) == 20221207) then
		g_ShaXingDaojishi_Mini_nGetInfo = arg3
		if arg1=="0" then
			ShaXingDaojishi_Mini_Show(tonumber(arg2))
		else
			this:Hide()
		end
		
	end
end

--=========================================================
--事件
--=========================================================
function ShaXingDaojishi_Mini_Show(nSelectBossIdx)
	this:Show()
	g_ShaXingDaojishi_SelectBossIdx = nSelectBossIdx
	local MsgText = "一"
	if nSelectBossIdx == 2 then
		MsgText = "二"
	elseif nSelectBossIdx == 3 then
		MsgText = "三"
	elseif nSelectBossIdx == 4 then
		MsgText = "四"
	end
	ShaXingDaojishi_Mini_PageHeader:SetText( string.format("#gFF0FA0关卡%s", MsgText) )
end


--=========================================================
--事件
--=========================================================
function ShaXingDaojishi_Mini_Open()
	this:Hide()
	PushEvent("UI_COMMAND",89331103,g_ShaXingDaojishi_Mini_nGetInfo)
end

