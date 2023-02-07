--******************************************
--��ɱ�Ǹ���	��һ��ֽ���
--create by  limengyue 
--2022-07-29
--******************************************

local g_ShaXing_Tips_Frame_UnifiedXPosition;
local g_ShaXing_Tips_Frame_UnifiedYPosition;


--�����������ֵ� ֱ�Ӵ������ʾ
local g_ShaXing_Tips_BossIdxList = 
{
	[1] = {tips="#{XSX_220705_357}"},--��ǰ�������ʦ��������ƽ��з��������Ѷ�ѡ�񣬲��ɶӳ���������ѡ��
	[2] = {tips="#{XSX_220705_358}"},--��ǰ�������ʦ����ͨ��һ�ص��Ѷȣ����ɶӳ���������ѡ�� 
	[3] = {tips="#{XSX_220705_359}"},--�����ѷ�������ǰ�������ʦ����ͨ��һ�ص��Ѷȣ����ɶӳ���������ѡ�� 
	[4] = {tips="#{XSX_220705_364}"},--#W��սʧ�ܣ���ǰ��#R�����ʦ#W�����¹�ͨ�����ɶӳ�����#G����ѡ��#W��
}


--=========================================================
--PreLoad
--=========================================================
function ShaXing_Tips_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	--����NPC����
	this:RegisterEvent("OBJECT_CARED_EVENT",false)
	-- ��Ϸ���ڳߴ緢���˱仯
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- ��Ϸ�ֱ��ʷ����˱仯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)	
	--�г����¼�
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
--�ָ������Ĭ�����λ��
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
		--�򿪽���
		if(IsWindowShow("ShaXing_Tips")) then
			CloseWindow("ShaXing_Tips", true)
		end
		ShaXing_Tips_Open(Get_XParam_INT(0))
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 189331105 )	then
		--�򿪽���
		if(IsWindowShow("ShaXing_Tips")) then
			CloseWindow("ShaXing_Tips", true)
		end
		ShaXing_Tips_Open(tonumber(arg1))		
	end
	-- ���ڱ仯
	if (event=="PLAYER_LEAVE_WORLD") then
		if( this:IsVisible() ) then
			this:Hide()
		end
	-- ��Ϸ���ڳߴ緢���˱仯
	elseif (event == "ADJEST_UI_POS" ) then
		ShaXing_Tips_On_ResetPos();
	-- ��Ϸ�ֱ��ʷ����˱仯
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
--�򿪽���
--=========================================================
function ShaXing_Tips_Open(nTipsIdx)
	if nTipsIdx < 1 then
		--�رս���
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
--�رս���
--=========================================================
function ShaXing_Tips_Close()
	this:Hide()
end
