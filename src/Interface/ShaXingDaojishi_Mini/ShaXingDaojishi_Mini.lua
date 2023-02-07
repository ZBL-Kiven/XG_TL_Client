--******************************************
--��ɱ�Ǹ���	��һ��ֽ���mini
--create by  limengyue 
--2022-07-29
--******************************************

local g_ShaXingDaojishi_SelectBossIdx = -1	--��ǰboss����
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
--�¼�
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
--�¼�
--=========================================================
function ShaXingDaojishi_Mini_Show(nSelectBossIdx)
	this:Show()
	g_ShaXingDaojishi_SelectBossIdx = nSelectBossIdx
	local MsgText = "һ"
	if nSelectBossIdx == 2 then
		MsgText = "��"
	elseif nSelectBossIdx == 3 then
		MsgText = "��"
	elseif nSelectBossIdx == 4 then
		MsgText = "��"
	end
	ShaXingDaojishi_Mini_PageHeader:SetText( string.format("#gFF0FA0�ؿ�%s", MsgText) )
end


--=========================================================
--�¼�
--=========================================================
function ShaXingDaojishi_Mini_Open()
	this:Hide()
	PushEvent("UI_COMMAND",89331103,g_ShaXingDaojishi_Mini_nGetInfo)
end

