--******************************************
--��ɱ�Ǹ���	��һ��ֽ���
--create by  limengyue 
--2022-07-29
--******************************************

local g_ShaXingDaojishi_Frame_UnifiedXPosition;
local g_ShaXingDaojishi_Frame_UnifiedYPosition;
local g_ShaXingDaojishi_nGetInfo = ""
--����MDֵ
local g_ShaXingDaojishi_MD = 470
local g_ShaXingDaojishi_SelectBossIdx = -1	--��ǰboss����
--��ע����  ��������
local g_ShaXingDaojishi_BossIdxList = 
{
	[1] = {nName="�ν�"},
	[2] = {nName="¬����"},
	[3] = {nName="���"},
	[4] = {nName="³־��"},
	[5] = {nName="��ʢ"},
	[6] = {nName="����"},
	[7] = {nName="����ʥ"},
}
local g_ShaXingDaojishi_RandomList = 
{
	[1] = {nwarning="��������",nName="#{XSX_220705_262}"},
	[2] = {nwarning="��ѪȦ",nName="#{XSX_220705_263}"},
	[3] = {nwarning="������",nName="#{XSX_220705_264}"},
	[4] = {nwarning="����",nName="#{XSX_220705_265}"},
	[5] = {nwarning="ѣ��",nName="#{XSX_220705_266}"},
}


--=========================================================
--PreLoad
--=========================================================
function ShaXingDaojishi_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("XINSHAXING_MINI");
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
function ShaXingDaojishi_OnLoad()
	g_ShaXingDaojishi_Frame_UnifiedXPosition	= ShaXingDaojishi : GetProperty("UnifiedXPosition");
	g_ShaXingDaojishi_Frame_UnifiedYPosition	= ShaXingDaojishi : GetProperty("UnifiedYPosition");
end

--=========================================================
--�ָ������Ĭ�����λ��
--=========================================================
function ShaXingDaojishi_On_ResetPos()

	
	ShaXingDaojishi : SetProperty("UnifiedXPosition", g_ShaXingDaojishi_Frame_UnifiedXPosition);
	ShaXingDaojishi : SetProperty("UnifiedYPosition", g_ShaXingDaojishi_Frame_UnifiedYPosition);

end

--=========================================================
--OnEvent
--=========================================================
function ShaXingDaojishi_OnEvent(event)
	if (event == "UI_COMMAND" and tonumber(arg0) == 89331103 ) then
		g_ShaXingDaojishi_nGetInfo = arg1
		ShaXingDaojishi_Open(g_ShaXingDaojishi_nGetInfo)
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 89331102 )	then
		--��ǰ�ۼƻ���
		local nMDPoint = DataPool:GetPlayerMission_DataRound(g_ShaXingDaojishi_MD)
		ShaXingDaojishi_Score:SetText(string.format("#cfff263��ǰ�ۼ������#G%s",tostring(nMDPoint)));		
	end
	-- ���ڱ仯
	if (event == "XINSHAXING_MINI" ) then
		if arg0=="1" then
			ShaXingDaojishi_Mini_Show(tonumber(arg1))
		end
	end
	if (event=="PLAYER_LEAVE_WORLD") then
		if( this:IsVisible() ) then
			this:Hide()
		end
	-- ��Ϸ���ڳߴ緢���˱仯
	elseif (event == "ADJEST_UI_POS" ) then
		ShaXingDaojishi_On_ResetPos();
	-- ��Ϸ�ֱ��ʷ����˱仯
	elseif (event == "VIEW_RESOLUTION_CHANGED" ) then	
		ShaXingDaojishi_On_ResetPos();
    elseif (event == "HIDE_ON_SCENE_TRANSED" ) then
       ShaXingDaojishi_Close()
	elseif (event=="PLAYER_LEAVE_WORLD") then
		if( this:IsVisible() ) then
			this:Hide()
		end
    end	
end

--=========================================================
--�򿪽���
--=========================================================
function ShaXingDaojishi_Open(nGetInfo)
	local splittab = Split(nGetInfo, ",")
	local nSelectBossIdx = tonumber(splittab[1])
	local nBossIdx	= tonumber(splittab[2])
	local nPoint	= tonumber(splittab[3])
	local nRandomList	= tonumber(splittab[4])
	local bRandom1	= tonumber(splittab[5])
	local bRandom2	= tonumber(splittab[6])
	local bRandom3	= tonumber(splittab[7])
	local bRandom4	= tonumber(splittab[8])
	g_ShaXingDaojishi_SelectBossIdx = nSelectBossIdx
	--�ؿ���Ϣ
	local nGuanqia = "һ"
	if nSelectBossIdx == 2 then
		nGuanqia = "��"
	elseif nSelectBossIdx == 3 then
		nGuanqia = "��"
	elseif nSelectBossIdx == 4 then
		nGuanqia = "��"
	end
	ShaXingDaojishi_DragTitle:SetText(string.format("#gFF0FA0�ؿ�%s",nGuanqia));
	
	--��ǰ�ۼƻ���
	local nMDPoint = DataPool:GetPlayerMission_DataRound(g_ShaXingDaojishi_MD)
	ShaXingDaojishi_Score:SetText(string.format("#cfff263��ǰ�ۼ������#G%s",tostring(nMDPoint)));
	--Ŀ��
	ShaXingDaojishi_Text:SetText(string.format("#cfff263��ɱboss%s",g_ShaXingDaojishi_BossIdxList[nBossIdx].nName));
	--ͨ�ؽ���
	ShaXingDaojishi_Text2:SetText(string.format("#cfff263���ֵ+#G%s#cfff263��",tostring(nPoint)));
	--������Ϣ
	local g_ShaXing_RandomIdxList={1,2,3,4}
	g_ShaXing_RandomIdxList[1] = math.mod(nRandomList,10)
	g_ShaXing_RandomIdxList[2] = math.mod(math.floor(nRandomList/10),10) 
	g_ShaXing_RandomIdxList[3] = math.mod(math.floor(nRandomList/100),10)   
	g_ShaXing_RandomIdxList[4] = math.mod(math.floor(nRandomList/1000),10) 
	-- PushDebugMessage("test��nRandomList  "..nRandomList)
	local nRandomMSg = ""
	if bRandom1 > 0 then
		nRandomMSg=nRandomMSg..g_ShaXingDaojishi_RandomList[g_ShaXing_RandomIdxList[1]].nName.." "
	end
	if bRandom2 > 0 then
		nRandomMSg=nRandomMSg..g_ShaXingDaojishi_RandomList[g_ShaXing_RandomIdxList[2]].nName.." "
	end
	if bRandom3 > 0 then
		nRandomMSg=nRandomMSg..g_ShaXingDaojishi_RandomList[g_ShaXing_RandomIdxList[3]].nName.." "
	end
	if bRandom4 > 0 then
		nRandomMSg=nRandomMSg..g_ShaXingDaojishi_RandomList[g_ShaXing_RandomIdxList[4]].nName.." "
	end	
	--PushDebugMessage("test name="..nRandomMSg);
	--����Ϊ��ʱ����ʾ����
	if nRandomMSg == "" then
		nRandomMSg = "#{XSX_220705_281}"
	end
	
	ShaXingDaojishi_Text4:SetText(nRandomMSg);
	this:Show()
end
--=========================================================
--�رս���
--=========================================================
function ShaXingDaojishi_Close()

end
--=========================================================
--�л���mini
--=========================================================
function ShaXingDaojishi_OpenMini()

	this:Hide()
	PushEvent("UI_COMMAND",20221207,0,g_ShaXingDaojishi_SelectBossIdx,g_ShaXingDaojishi_nGetInfo)
end