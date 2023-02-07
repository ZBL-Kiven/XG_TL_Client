--******************************************
--��ɱ�Ǹ���	bossѡ�����
--create by  limengyue 
--2022-07-28
--******************************************

local g_ShaXing_BossChoice_Frame_UnifiedPosition;
--����NPc
local MAX_OBJ_DISTANCE = 3.0
local objCared = -1
local g_Object = -1


local g_ShaXing_BossChoice_Fenye = {}	--�ĸ�bossѡ���ҳ
local g_ShaXing_BossChoice_FenyeOk = {}	--�ĸ�boss �Ƿ�ͨ�ر��
local g_ShaXing_BossChoice_FenyeAbandon = {}	--�ĸ�boss �Ƿ�ͨ�ر��
local g_ShaXing_BossChoice_BossModeList = {}	--����bossģʽѡ��
local g_ShaXing_BossChoice_BossCheckGrey = {}	--�ĸ�boss״̬ѡ����ͼƬ
local g_ShaXing_BossChoice_BossCheckBtn = {}	--�ĸ�boss״̬ѡ��ť
local g_ShaXing_BossChoice_BossCheckTxt = {}	--�ĸ�boss״̬��ʾ����
local g_ShaXing_BossChoice_RandomShowBtn = {}	--�ĸ�����Ԫ����ʾ����
local g_ShaXing_BossChoice_RandomShowImg= {}	--�ĸ�����Ԫ����ʾͼ��
local g_ShaXing_BossChoice_RandomCheckGrey = {}	--�ĸ�����Ԫ��ѡ��ؼ�
local g_ShaXing_BossChoice_RandomCheckNameTxt = {}	--�ĸ�����Ԫ������
local g_ShaXing_BossChoice_RandomCheckPointTxt = {}	--�ĸ�����Ԫ��ѡ�������ʾ
local g_SXBossImg =	--boss�ѶȲ�ͬͼƬ
{
	[1] = {nName="�ν�",nEasyPoint=1000,nNormalPoint=1000,nHardPoint=1000,nEasyTips="#{XSX_220705_277}",nNormalTips="#{XSX_220705_278}",nHardTips="#{XSX_220705_279}",nEasyImg="set:ShaXing5 image:ShaXing_sj1",nNormalImg="set:ShaXing5 image:ShaXing_sj2",nHardImg="set:ShaXing5 image:ShaXing_sj3"},
	[2] = {nName="¬����",nEasyPoint=1000,nNormalPoint=1000,nHardPoint=1000,nEasyTips="#{XSX_220705_277}",nNormalTips="#{XSX_220705_278}",nHardTips="#{XSX_220705_279}",nEasyImg="set:ShaXing3 image:ShaXing_ljy1",nNormalImg="set:ShaXing3 image:ShaXing_ljy2",nHardImg="set:ShaXing3 image:ShaXing_ljy3"},
	[3] = {nName="���",nEasyPoint=1000,nNormalPoint=1000,nHardPoint=1000,nEasyTips="#{XSX_220705_277}",nNormalTips="#{XSX_220705_278}",nHardTips="#{XSX_220705_279}",nEasyImg="set:ShaXing3 image:ShaXing_lk1",nNormalImg="set:ShaXing4 image:ShaXing_lk2",nHardImg="set:ShaXing4 image:ShaXing_lk3"},
	[4] = {nName="³־��",nEasyPoint=1000,nNormalPoint=1000,nHardPoint=1000,nEasyTips="#{XSX_220705_277}",nNormalTips="#{XSX_220705_278}",nHardTips="#{XSX_220705_279}",nEasyImg="set:ShaXing4 image:ShaXing_lzs1",nNormalImg="set:ShaXing4 image:ShaXing_lzs2",nHardImg="set:ShaXing5 image:ShaXing_lzs3"},
	[5] = {nName="��ʢ",nEasyPoint=1000,nNormalPoint=1000,nHardPoint=1000,nEasyTips="#{XSX_220705_277}",nNormalTips="#{XSX_220705_278}",nHardTips="#{XSX_220705_279}",nEasyImg="set:ShaXing1 image:ShaXing_gs1",nNormalImg="set:ShaXing1 image:ShaXing_gs2",nHardImg="set:ShaXing2 image:ShaXing_gs3"},
	[6] = {nName="����",nEasyPoint=1000,nNormalPoint=1000,nHardPoint=1000,nEasyTips="#{XSX_220705_277}",nNormalTips="#{XSX_220705_278}",nHardTips="#{XSX_220705_279}",nEasyImg="set:ShaXing6 image:ShaXing_wy1",nNormalImg="set:ShaXing6 image:ShaXing_wy2",nHardImg="set:ShaXing6 image:ShaXing_wy3"},
	[7] = {nName="����ʥ",nEasyPoint=1000,nNormalPoint=1000,nHardPoint=1000,nEasyTips="#{XSX_220705_277}",nNormalTips="#{XSX_220705_278}",nHardTips="#{XSX_220705_279}",nEasyImg="set:ShaXing2 image:ShaXing_gss1",nNormalImg="set:ShaXing2 image:ShaXing_gss2",nHardImg="set:ShaXing2 image:ShaXing_gss3"},
}
local g_SXBossBuff = --boss����ѡ��ӷ����
{
	[1] = {nName="���ԷŴ�",nPoint=350,nEnableTips="#{XSX_220705_293}",nDisableTips="#{XSX_220705_294}"},
	[2] = {nName="��Ѫ",nPoint=200,nEnableTips="#{XSX_220705_295}",nDisableTips="#{XSX_220705_296}"},
	[3] = {nName="���ܼӿ�",nPoint=350,nEnableTips="#{XSX_220705_297}",nDisableTips="#{XSX_220705_298}"},
	[4] = {nName="��",nPoint=300,nEnableTips="#{XSX_220705_299}",nDisableTips="#{XSX_220705_300}"},
}
local g_SXRandomImg = --��ͬ����Ԫ��ͼƬ
{
	[1] = {nwarning="��������",nName="#{XSX_220705_262}",nImg="set:FBSkill_2 image:FBSkill_2_6",nPoint=300,Tooltip="XSX_220705_267"},
	[2] = {nwarning="��ѪȦ",nName="#{XSX_220705_263}",nImg="set:FBSkill_2 image:FBSkill_2_8",nPoint=150,Tooltip="XSX_220705_268"},
	[3] = {nwarning="������",nName="#{XSX_220705_264}",nImg="set:FBSkill_2 image:FBSkill_2_5",nPoint=250,Tooltip="XSX_220705_269"},
	[4] = {nwarning="����",nName="#{XSX_220705_265}",nImg="set:FBSkill_2 image:FBSkill_2_9",nPoint=150,Tooltip="XSX_220705_270"},
	[5] = {nwarning="ѣ��",nName="#{XSX_220705_266}",nImg="set:FBSkill_2 image:FBSkill_2_7",nPoint=250,Tooltip="XSX_220705_271"},
}

local g_ShaXing_CloseTick = 1	--����ʱ
local g_ShaXing_FenyeIdx = -1	--�ڼ�����ҳ
local g_ShaXing_FenyeBossIdx = -1	--��ǰ�����ڼ���boss����
local g_SXBossCheck = {0,0,0,0,}--�ĸ�boss״̬ѡ�����
local g_SXRandomCheck = {0,0,0,0,}--�ĸ�����Ԫ��ѡ�����
local g_SXRandomIdxList = {1,2,3,4,}--�ĸ�����Ԫ�������������������
local g_SXBossAbandon = {0,0,0,0,}--boss�������
local g_ShaXing_targetId = -1;
--===============================================
-- OnLoad()
--===============================================
function ShaXing_BossChoice_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	--����NPC����
	this:RegisterEvent("OBJECT_CARED_EVENT",false)
	-- ��Ϸ���ڳߴ緢���˱仯
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- ��Ϸ�ֱ��ʷ����˱仯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)	
	--�г����¼�
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false);
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
end

--===============================================
-- OnLoad()
--===============================================
function ShaXing_BossChoice_OnLoad()   
	-- ��������Ĭ�����λ��
	g_ShaXing_BossChoice_Frame_UnifiedPosition = ShaXing_BossChoice_Frame:GetProperty("UnifiedPosition");

	--�ؼ�
	--bossѡ���ҳ
	g_ShaXing_BossChoice_Fenye[1] = ShaXing_BossChoice_Boss1
	g_ShaXing_BossChoice_Fenye[2] = ShaXing_BossChoice_Boss2
	g_ShaXing_BossChoice_Fenye[3] = ShaXing_BossChoice_Boss3
	g_ShaXing_BossChoice_Fenye[4] = ShaXing_BossChoice_Boss4
	--�Ƿ�ͨ�ر��
	g_ShaXing_BossChoice_FenyeOk[1] = ShaXing_BossChoice_Boss1_Ok
	g_ShaXing_BossChoice_FenyeOk[2] = ShaXing_BossChoice_Boss2_Ok
	g_ShaXing_BossChoice_FenyeOk[3] = ShaXing_BossChoice_Boss3_Ok
	g_ShaXing_BossChoice_FenyeOk[4] = ShaXing_BossChoice_Boss4_Ok
	g_ShaXing_BossChoice_FenyeAbandon[1] = ShaXing_BossChoice_Boss1_Abandon
	g_ShaXing_BossChoice_FenyeAbandon[2] = ShaXing_BossChoice_Boss2_Abandon
	g_ShaXing_BossChoice_FenyeAbandon[3] = ShaXing_BossChoice_Boss3_Abandon
	g_ShaXing_BossChoice_FenyeAbandon[4] = ShaXing_BossChoice_Boss4_Abandon	
	--����bossģʽѡ��
	g_ShaXing_BossChoice_BossModeList[1] = ShaXing_BossChoiceModel_Bind
	g_ShaXing_BossChoice_BossModeList[2] = ShaXing_BossChoiceModel_Bind2
	g_ShaXing_BossChoice_BossModeList[3] = ShaXing_BossChoiceModel_Bind3
	--�ĸ�boss״̬ѡ��ť
	g_ShaXing_BossChoice_BossCheckBtn[1] = ShaXing_BossChoice_Add1
	g_ShaXing_BossChoice_BossCheckBtn[2] = ShaXing_BossChoice_Add2
	g_ShaXing_BossChoice_BossCheckBtn[3] = ShaXing_BossChoice_Add3
	g_ShaXing_BossChoice_BossCheckBtn[4] = ShaXing_BossChoice_Add4
	--�ĸ�boss״̬��ʾ����
	g_ShaXing_BossChoice_BossCheckTxt[1] = ShaXing_BossChoice_Add1Num
	g_ShaXing_BossChoice_BossCheckTxt[2] = ShaXing_BossChoice_Add2Num
	g_ShaXing_BossChoice_BossCheckTxt[3] = ShaXing_BossChoice_Add3Num
	g_ShaXing_BossChoice_BossCheckTxt[4] = ShaXing_BossChoice_Add4Num
	--boss״̬ѡ��
	g_ShaXing_BossChoice_BossCheckGrey[1] = ShaXing_BossChoice_Add1_Mask
	g_ShaXing_BossChoice_BossCheckGrey[2] = ShaXing_BossChoice_Add2_Mask
	g_ShaXing_BossChoice_BossCheckGrey[3] = ShaXing_BossChoice_Add3_Mask
	g_ShaXing_BossChoice_BossCheckGrey[4] = ShaXing_BossChoice_Add4_Mask
	--����Ԫ����ʾ
	g_ShaXing_BossChoice_RandomShowBtn[1] = ShaXing_BossChoice_Place1
	g_ShaXing_BossChoice_RandomShowBtn[2] = ShaXing_BossChoice_Place2
	g_ShaXing_BossChoice_RandomShowBtn[3] = ShaXing_BossChoice_Place3
	g_ShaXing_BossChoice_RandomShowBtn[4] = ShaXing_BossChoice_Place4
	--�ĸ�����Ԫ����ʾͼ��
	g_ShaXing_BossChoice_RandomShowImg[1] = ShaXing_BossChoice_Place1Image
	g_ShaXing_BossChoice_RandomShowImg[2] = ShaXing_BossChoice_Place2Image
	g_ShaXing_BossChoice_RandomShowImg[3] = ShaXing_BossChoice_Place3Image
	g_ShaXing_BossChoice_RandomShowImg[4] = ShaXing_BossChoice_Place4Image
	--����Ԫ��ѡ��
	g_ShaXing_BossChoice_RandomCheckGrey[1] = ShaXing_BossChoice_Place1_Mask
	g_ShaXing_BossChoice_RandomCheckGrey[2] = ShaXing_BossChoice_Place2_Mask
	g_ShaXing_BossChoice_RandomCheckGrey[3] = ShaXing_BossChoice_Place3_Mask
	g_ShaXing_BossChoice_RandomCheckGrey[4] = ShaXing_BossChoice_Place4_Mask
	--�ĸ�����Ԫ������
	g_ShaXing_BossChoice_RandomCheckNameTxt[1] = ShaXing_BossChoice_Place1Text
	g_ShaXing_BossChoice_RandomCheckNameTxt[2] = ShaXing_BossChoice_Place2Text
	g_ShaXing_BossChoice_RandomCheckNameTxt[3] = ShaXing_BossChoice_Place3Text
	g_ShaXing_BossChoice_RandomCheckNameTxt[4] = ShaXing_BossChoice_Place4Text
	--���ػ�����ʾ
	g_ShaXing_BossChoice_RandomCheckPointTxt[1] = ShaXing_BossChoice_Place1Num
	g_ShaXing_BossChoice_RandomCheckPointTxt[2] = ShaXing_BossChoice_Place2Num
	g_ShaXing_BossChoice_RandomCheckPointTxt[3] = ShaXing_BossChoice_Place3Num
	g_ShaXing_BossChoice_RandomCheckPointTxt[4] = ShaXing_BossChoice_Place4Num
	
end


--================================================
-- �ָ������Ĭ�����λ��
--================================================
function ShaXing_BossChoice_Frame_On_ResetPos()
	ShaXing_BossChoice_Frame:SetProperty("UnifiedPosition", g_ShaXing_BossChoice_Frame_UnifiedPosition);
end

--===============================================
-- OnEvent()
--===============================================
function ShaXing_BossChoice_OnEvent(event)

    if(event == "UI_COMMAND" and tonumber(arg0) == 89331101) then
		--�򿪽���
		if(IsWindowShow("ShaXing_BossChoice")) then
			CloseWindow("ShaXing_BossChoice", true)
		end
		--���NPC���� ����Ҫ
		g_ShaXing_targetId = Get_XParam_INT(0)
		-- if g_ShaXing_targetId >= 0 then
			-- objCared = DataPool : GetNPCIDByServerID(g_ShaXing_targetId);
			-- ShaXing_BossChoice_BeginCareObject(objCared)
		-- end
		if Get_XParam_INT(1) > 0 then --�ڼ���boss
			ShaXing_BossChoice_Open(Get_XParam_INT(1),Get_XParam_INT(2),Get_XParam_INT(3),Get_XParam_INT(4),Get_XParam_INT(5),Get_XParam_INT(6),Get_XParam_INT(7),Get_XParam_INT(8))
		end
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 89331104 ) then
		--PushDebugMessage("test idx="..Get_XParam_INT(1))
		if Get_XParam_INT(0) > 0 then --�ڼ���boss
			ShaXing_BossChoice_OpenFenye(Get_XParam_INT(0),Get_XParam_INT(1),Get_XParam_INT(2),Get_XParam_INT(3),Get_XParam_INT(4),Get_XParam_INT(5),Get_XParam_INT(6),Get_XParam_INT(7),Get_XParam_INT(8))
		end
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 89331106 ) then
		--Ԥ�����
		--PushDebugMessage("test Ԥ�����IDx="..Get_XParam_INT(1))
		if Get_XParam_INT(0) > 0 then --�ڼ���boss
			ShaXing_BossChoice_JustShow(Get_XParam_INT(0),Get_XParam_INT(1),Get_XParam_INT(2),Get_XParam_INT(3),Get_XParam_INT(4),Get_XParam_INT(5),Get_XParam_INT(6))
		end
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 89331102 ) then
		--���ֳɹ� �رմ���
		ShaXing_BossChoice_OnClose()
	end
	if (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if(tonumber(arg0) ~= objCared) then
			return
		end

		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			ShaXing_BossChoice_OnClose()
		end
	end
    -- ��Ϸ���ڳߴ緢���˱仯
	if (event == "ADJEST_UI_POS" ) then
		ShaXing_BossChoice_Frame_On_ResetPos()
	-- ��Ϸ�ֱ��ʷ����˱仯
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		ShaXing_BossChoice_Frame_On_ResetPos()
    elseif (event == "HIDE_ON_SCENE_TRANSED" ) then
       ShaXing_BossChoice_OnClose()
	elseif (event=="PLAYER_LEAVE_WORLD") then
		if( this:IsVisible() ) then
			this:Hide()
		end
    end
         
end

--===============================================
-- ShaXing_BossChoice_OnClose()
--===============================================
function ShaXing_BossChoice_OnClose()
	--ShaXing_BossChoice_StopCareObject()
	KillTimer("ShaXing_BossChoice_CloseWindow()")
	this:Hide()
end

--=========================================================
--��ʼ����NPC
--=========================================================
function ShaXing_BossChoice_BeginCareObject(objCaredId)
	-- if g_Object ~= -1 then
		-- this:CareObject(objCaredId, 0, "ShaXing_BossChoice");
	-- end
	-- g_Object = objCaredId
	-- this:CareObject(g_Object, 1, "ShaXing_BossChoice")
end


--=========================================================
--ֹͣ��ĳNPC�Ĺ���
--=========================================================
function ShaXing_BossChoice_StopCareObject()
	-- if g_Object ~= -1 then
		-- this:CareObject(g_Object, 0, "ShaXing_BossChoice");
		-- g_Object = -1;
	-- end
end
--=========================================================
--help
--=========================================================
function ShaXing_BossChoice_Help()

end

--=========================================================
--Ĭ�ϴ򿪽���
--nSelectIdx ѡ�ĵڼ���boss
--nBossIdx boss����
--nRandomList���ڳ���Ԫ���б� ��Ҫ���
--=========================================================
function ShaXing_BossChoice_Open(nSelectIdx,nBossIdx,nBossAbandonList,nRandomList,bLeader,nBossMode,nRandomChoiceList,nBossChoiceList)
	if nSelectIdx < 1 or nSelectIdx > 4 then
		return
	end
	--���ò���
	g_ShaXing_FenyeIdx = nSelectIdx
	g_ShaXing_FenyeBossIdx = nBossIdx
	--ѡ�е�ǰboss��ҳ
	for index=1,table.getn(g_ShaXing_BossChoice_Fenye)  do
		if index == g_ShaXing_FenyeIdx then
			g_ShaXing_BossChoice_Fenye[index]:SetCheck(1);
		else
			g_ShaXing_BossChoice_Fenye[index]:SetCheck(0);
		end
		if index > g_ShaXing_FenyeIdx then
			g_ShaXing_BossChoice_Fenye[index]:Disable();
		else
			g_ShaXing_BossChoice_Fenye[index]:Enable();
		end
		
	end
	--boss�������
	--PushDebugMessage("test ShaXing_BossChoiceModel_open nBossAbandonList="..nBossAbandonList)
	g_SXBossAbandon[1] = math.mod(nBossAbandonList,10)
	g_SXBossAbandon[2] = math.floor(math.mod(nBossAbandonList,100)/10)  
	g_SXBossAbandon[3] = math.floor(math.mod(nBossAbandonList,1000)/100)  
	g_SXBossAbandon[4] = math.floor(math.mod(nBossAbandonList,10000)/1000) 
	
	--�Ƿ�ͨ�ر��
	for index=1,table.getn(g_ShaXing_BossChoice_FenyeAbandon)  do
		if index <  g_ShaXing_FenyeIdx then
			if g_SXBossAbandon[index] == 1 then
				g_ShaXing_BossChoice_FenyeOk[index]:Hide();
				g_ShaXing_BossChoice_FenyeAbandon[index]:Show();
			else
				g_ShaXing_BossChoice_FenyeOk[index]:Show();
				g_ShaXing_BossChoice_FenyeAbandon[index]:Hide();
			end
		else
			g_ShaXing_BossChoice_FenyeOk[index]:Hide();
			g_ShaXing_BossChoice_FenyeAbandon[index]:Hide();
		end	
		
	end
	
	--bossģʽĬ��ѡ��	
	--չʾboss Ĭ��չʾ�Ѷ�1
	ShaXing_BossChoiceFakeObject:SetProperty( "Image", g_SXBossImg[nBossIdx].nEasyImg )
	ShaXing_BossChoice_Num1:SetText(g_SXBossImg[nBossIdx].nEasyTips);
	if nBossMode == 0 then
		nBossMode = 1
	end
	if nBossMode == 2 then
		ShaXing_BossChoiceFakeObject:SetProperty( "Image", g_SXBossImg[nBossIdx].nNormalImg )
		ShaXing_BossChoice_Num1:SetText(g_SXBossImg[nBossIdx].nNormalTips);
	elseif nBossMode == 3 then
		ShaXing_BossChoiceFakeObject:SetProperty( "Image", g_SXBossImg[nBossIdx].nHardImg )
		ShaXing_BossChoice_Num1:SetText(g_SXBossImg[nBossIdx].nHardTips);
	end
	for index=1,table.getn(g_ShaXing_BossChoice_BossModeList)  do
		if index == nBossMode then
			g_ShaXing_BossChoice_BossModeList[index]:SetCheck(1);
		else
			g_ShaXing_BossChoice_BossModeList[index]:SetCheck(0);
		end
	end
	ShaXing_BossChoice_Num1:SetText(g_SXBossImg[nBossIdx].nEasyTips);
	
	--boss״̬Ĭ�ϲ�ѡ
	for index=1,table.getn(g_ShaXing_BossChoice_BossCheckBtn)  do
		g_SXBossCheck[index] = 0
		g_ShaXing_BossChoice_BossCheckBtn[index]:SetCheck(0)
		g_ShaXing_BossChoice_BossCheckGrey[index]:Hide()
		g_ShaXing_BossChoice_BossCheckTxt[index]:SetText(g_SXBossBuff[index].nDisableTips);
	end

	--����Ԫ����Ϣ
	--PushDebugMessage("test ShaXing_BossChoiceModel_open nRandomList="..nRandomList)
	g_SXRandomIdxList[1] = math.mod(nRandomList,10)
	g_SXRandomIdxList[2] = math.mod(math.floor(nRandomList/10),10)  
	g_SXRandomIdxList[3] = math.mod(math.floor(nRandomList/100),10)  
	g_SXRandomIdxList[4] = math.mod(math.floor(nRandomList/1000),10) 
	--��ʼ������Ԫ����ʾͼ��
	for index=1,table.getn(g_ShaXing_BossChoice_RandomShowBtn)  do	
		local nCurRandomIdx = g_SXRandomIdxList[index]
		if nCurRandomIdx > 0 and nCurRandomIdx <= 5 then
			g_ShaXing_BossChoice_RandomShowBtn[index]:Enable()
			g_ShaXing_BossChoice_RandomShowImg[index]:SetProperty("Image",g_SXRandomImg[nCurRandomIdx].nImg);
			g_ShaXing_BossChoice_RandomShowBtn[index]:SetToolTip(GetDictionaryString(g_SXRandomImg[nCurRandomIdx].Tooltip));
		else
			g_ShaXing_BossChoice_RandomShowBtn[index]:Disable()
		end
		g_ShaXing_BossChoice_RandomCheckPointTxt[index]:SetText(string.format("+%s��",tostring(g_SXRandomImg[nCurRandomIdx].nPoint)));
		g_ShaXing_BossChoice_RandomCheckNameTxt[index]:SetText(g_SXRandomImg[nCurRandomIdx].nName);
	end
	--����Ԫ��ѡ��
	local g_RandomChoiceList = {0,0,0,0}
	--PushDebugMessage("test  g_RandomChoiceList="..nRandomChoiceList)
	g_RandomChoiceList[1] = math.mod(nRandomChoiceList,10)
	g_RandomChoiceList[2] = math.floor(math.mod(nRandomChoiceList,100)/10)  
	g_RandomChoiceList[3] = math.floor(math.mod(nRandomChoiceList,1000)/100)  
	g_RandomChoiceList[4] = math.floor(math.mod(nRandomChoiceList,10000)/1000) 
	for index=1,table.getn(g_ShaXing_BossChoice_RandomShowBtn)  do
		local nCurRandomIdx = g_SXRandomIdxList[index]
		if nIsCurBoss == 1 or g_SXBossAbandon[g_ShaXing_FenyeIdx] == 1 then
			g_SXRandomCheck[index] = 0
			g_ShaXing_BossChoice_RandomShowBtn[index]:SetCheck(0)
			g_ShaXing_BossChoice_RandomCheckPointTxt[index]:SetText(string.format("+%s��",tostring(g_SXRandomImg[nCurRandomIdx].nPoint)));
		else
			if g_RandomChoiceList[index] > 0 then
				g_SXRandomCheck[index] = 1
				g_ShaXing_BossChoice_RandomShowBtn[index]:SetCheck(1)
				g_ShaXing_BossChoice_RandomCheckPointTxt[index]:SetText(string.format("#G+%s��",tostring(g_SXRandomImg[nCurRandomIdx].nPoint)));
			else
				g_SXRandomCheck[index] = 0
				g_ShaXing_BossChoice_RandomShowBtn[index]:SetCheck(0)
				g_ShaXing_BossChoice_RandomCheckPointTxt[index]:SetText(string.format("#c8c8c8c+%s��",tostring(g_SXRandomImg[nCurRandomIdx].nPoint)));
			end
		end		
		g_ShaXing_BossChoice_RandomCheckGrey[index]:Hide()
	end

	--�Ѷȿ�ѡ
	for index=1,table.getn(g_ShaXing_BossChoice_BossModeList)  do
		g_ShaXing_BossChoice_BossModeList[index]:Enable();
	end
	--���Կ�ѡ
	for index=1,table.getn(g_ShaXing_BossChoice_BossCheckBtn)  do
		g_ShaXing_BossChoice_BossCheckBtn[index]:Enable();
		g_ShaXing_BossChoice_BossCheckBtn[index]:SetCheck(0)
	end
	--����Ԫ�ؿ�ѡ
	for index=1,table.getn(g_ShaXing_BossChoice_RandomShowBtn)  do	
		g_ShaXing_BossChoice_RandomShowBtn[index]:Enable();
	end
	--���ؼӳ�ѡ��
	local g_BossChoiceList = {0,0,0,0}
	g_BossChoiceList[1] = math.mod(nBossChoiceList,10)
	g_BossChoiceList[2] = math.mod(math.floor(nBossChoiceList/10),10)  
	g_BossChoiceList[3] = math.mod(math.floor(nBossChoiceList/100),10) --����������õ� 12
	g_BossChoiceList[4] = math.mod(math.floor(nBossChoiceList/1000),10) 
	for index=1,table.getn(g_ShaXing_BossChoice_BossCheckBtn)  do
		if nIsCurBoss == 1 or g_SXBossAbandon[g_ShaXing_FenyeIdx] == 1 then
			g_SXBossCheck[index] = 0
			g_ShaXing_BossChoice_BossCheckBtn[index]:SetCheck(0);
			g_ShaXing_BossChoice_BossCheckTxt[index]:SetText(g_SXBossBuff[index].nDisableTips);	
		else
			if g_BossChoiceList[index] > 0 then
				g_SXBossCheck[index] = 1
				g_ShaXing_BossChoice_BossCheckBtn[index]:SetCheck(1);
				g_ShaXing_BossChoice_BossCheckTxt[index]:SetText(g_SXBossBuff[index].nEnableTips);
			else
				g_SXBossCheck[index] = 0
				g_ShaXing_BossChoice_BossCheckBtn[index]:SetCheck(0);
				g_ShaXing_BossChoice_BossCheckTxt[index]:SetText(g_SXBossBuff[index].nDisableTips);
			end
		end		
		g_ShaXing_BossChoice_BossCheckGrey[index]:Hide()
	end		
	--�ӳ���ʾ
	if bLeader == 1 then
		ShaXing_BossChoice_ActionFrame:Show()
		ShaXing_BossChoice_ActionFrame2:Hide()
	else
		ShaXing_BossChoice_ActionFrame:Hide()
		ShaXing_BossChoice_ActionFrame2:Show()
		ShaXing_BossChoice_ActionFrame2_Text:SetText("#{XSX_220705_360}");
	end
	--���¼������
	ShaXing_BossChoice_Point()
	--��������
	KillTimer("ShaXing_BossChoice_CloseWindow()")
	this:Show()
end

--=========================================================
--����������
--nSelectIdx ѡ�ĵڼ���boss
--nBossIdx boss����
--nRandomList���ڳ���Ԫ���б� ��Ҫ���
--=========================================================
function ShaXing_BossChoice_OpenFenye(nKillBossCount,nSelectIdx,nBossIdx,nIsCurBoss,nBossMode,nBossChoiceList,nRandomList,nRandomChoiceList,nBossAbandonList)
	if nSelectIdx < 1 or nSelectIdx > 4 then
		return
	end
	--�ӳ���ʾ
	local iIsLeader = DataPool:IsTeamLeader();
	if iIsLeader == 1 then
		ShaXing_BossChoice_ActionFrame:Show()
		ShaXing_BossChoice_ActionFrame2:Hide()
	else
		ShaXing_BossChoice_ActionFrame:Hide()
		ShaXing_BossChoice_ActionFrame2:Show()
		ShaXing_BossChoice_ActionFrame2_Text:SetText("#{XSX_220705_360}");
	end
	--���ò���
	g_ShaXing_FenyeIdx = nSelectIdx
	g_ShaXing_FenyeBossIdx = nBossIdx
	local nFenyeMax = g_ShaXing_FenyeIdx
	-- PushDebugMessage("nKillBossCount  =  "..nKillBossCount.."  g_ShaXing_FenyeIdx  =  "..g_ShaXing_FenyeIdx)
	if nKillBossCount +1  > g_ShaXing_FenyeIdx then
		nFenyeMax = nKillBossCount +1 
	end
	--PushDebugMessage("test  ShaXing_BossChoice_OpenFenye nSelectIdx="..nSelectIdx.." g_ShaXing_FenyeBossIdx="..g_ShaXing_FenyeBossIdx )
	--ѡ�е�ǰboss��ҳ
	for index=1,table.getn(g_ShaXing_BossChoice_Fenye)  do
		if index == g_ShaXing_FenyeIdx then
			g_ShaXing_BossChoice_Fenye[index]:SetCheck(1);
		else
			g_ShaXing_BossChoice_Fenye[index]:SetCheck(0);
		end
		if index > nFenyeMax  then
			g_ShaXing_BossChoice_Fenye[index]:Disable();
		else
			g_ShaXing_BossChoice_Fenye[index]:Enable();
		end		
	end
	
	--���ΰ�ť
	if nIsCurBoss == 0 then
		--ȷ�ϼ����ɵ�
		ShaXing_BossChoice_ActionFrame:Hide()
		ShaXing_BossChoice_ActionFrame2:Hide()
		--�ѶȲ���ѡ
		for index=1,table.getn(g_ShaXing_BossChoice_BossModeList)  do
			g_ShaXing_BossChoice_BossModeList[index]:Disable();
		end
		--���Բ���ѡ
		for index=1,table.getn(g_ShaXing_BossChoice_BossCheckBtn)  do
			g_ShaXing_BossChoice_BossCheckBtn[index]:Disable();
		end
		--����Ԫ�ز���ѡ
		for index=1,table.getn(g_ShaXing_BossChoice_RandomShowBtn)  do	
			g_ShaXing_BossChoice_RandomShowBtn[index]:Disable();
		end
	else
		--ȷ�ϼ��ɵ�
		ShaXing_BossChoice_ActionFrame:Show()
		ShaXing_BossChoice_ActionFrame2:Hide()
		--�Ѷȿ�ѡ
		for index=1,table.getn(g_ShaXing_BossChoice_BossModeList)  do
			g_ShaXing_BossChoice_BossModeList[index]:Enable();
		end
		--���Կ�ѡ
		for index=1,table.getn(g_ShaXing_BossChoice_BossCheckBtn)  do
			g_ShaXing_BossChoice_BossCheckBtn[index]:Enable();
			g_ShaXing_BossChoice_BossCheckBtn[index]:SetCheck(0)
		end
		--����Ԫ�ؿ�ѡ
		for index=1,table.getn(g_ShaXing_BossChoice_RandomShowBtn)  do	
			g_ShaXing_BossChoice_RandomShowBtn[index]:Enable();
			g_ShaXing_BossChoice_RandomShowBtn[index]:SetCheck(0)
		end
	end
	
	
	--boss�������
	--PushDebugMessage("test fenye nBossAbandonList="..nBossAbandonList.." nKillBossCount="..nKillBossCount)
	g_SXBossAbandon[1] = math.mod(nBossAbandonList,10)
	g_SXBossAbandon[2] = math.floor(math.mod(nBossAbandonList,100)/10)  
	g_SXBossAbandon[3] = math.floor(math.mod(nBossAbandonList,1000)/100)  
	g_SXBossAbandon[4] = math.floor(math.mod(nBossAbandonList,10000)/1000) 
	
	--�Ƿ�ͨ�ر��
	for index=1,table.getn(g_ShaXing_BossChoice_FenyeAbandon)  do
		if index <=  nKillBossCount then
			if g_SXBossAbandon[index] == 1 then
				g_ShaXing_BossChoice_FenyeOk[index]:Hide();
				g_ShaXing_BossChoice_FenyeAbandon[index]:Show();
			else
				g_ShaXing_BossChoice_FenyeOk[index]:Show();
				g_ShaXing_BossChoice_FenyeAbandon[index]:Hide();
			end
		else
			g_ShaXing_BossChoice_FenyeOk[index]:Hide();
			g_ShaXing_BossChoice_FenyeAbandon[index]:Hide();
		end	
	end
	
	if nIsCurBoss == 1 then
		-- ��ǰѡ��boss�ͻ�����ʾ����
		nBossMode = 1 
	end
	
	if g_SXBossAbandon[g_ShaXing_FenyeIdx] == 1 then
		--����boss�ͻ�����ʾ����
		nBossMode = 0 
	end
	
	--չʾboss�Ѷ�
	-- PushDebugMessage("nBossMode = "..nBossMode)
	for index=1,table.getn(g_ShaXing_BossChoice_BossModeList)  do
		if index == nBossMode then
			g_ShaXing_BossChoice_BossModeList[index]:SetCheck(1);
		else
			g_ShaXing_BossChoice_BossModeList[index]:SetCheck(0);
		end
	end
	
	--PushDebugMessage("test  nBossMode="..nBossMode.." nIsCurBoss="..nIsCurBoss)
	ShaXing_BossChoiceFakeObject:SetProperty( "Image", g_SXBossImg[nBossIdx].nEasyImg )
	ShaXing_BossChoice_Num1:SetText(g_SXBossImg[nBossIdx].nEasyTips);
	if nBossMode == 2 then
		ShaXing_BossChoiceFakeObject:SetProperty( "Image", g_SXBossImg[nBossIdx].nNormalImg )
		ShaXing_BossChoice_Num1:SetText(g_SXBossImg[nBossIdx].nNormalTips);
	elseif nBossMode == 3 then
		ShaXing_BossChoiceFakeObject:SetProperty( "Image", g_SXBossImg[nBossIdx].nHardImg )
		ShaXing_BossChoice_Num1:SetText(g_SXBossImg[nBossIdx].nHardTips);
	end
	
	--boss�ӳ�ѡ��
	--PushDebugMessage("test  nBossChoiceList="..nBossChoiceList)
	local g_BossChoiceList = {0,0,0,0}
	g_BossChoiceList[1] = math.mod(nBossChoiceList,10)
	g_BossChoiceList[2] = math.floor(math.mod(nBossChoiceList,100)/10)  
	g_BossChoiceList[3] = math.floor(math.mod(nBossChoiceList,1000)/100) - 1 --����������õ� 12
	g_BossChoiceList[4] = math.floor(math.mod(nBossChoiceList,10000)/1000) 
	for index=1,table.getn(g_ShaXing_BossChoice_BossCheckBtn)  do
		if nIsCurBoss == 1 or g_SXBossAbandon[g_ShaXing_FenyeIdx] == 1 then
			g_SXBossCheck[index] = 0
			g_ShaXing_BossChoice_BossCheckBtn[index]:SetCheck(0);
			g_ShaXing_BossChoice_BossCheckTxt[index]:SetText(g_SXBossBuff[index].nDisableTips);	
		else
			if g_BossChoiceList[index] > 0 then
				g_SXBossCheck[index] = 1
				g_ShaXing_BossChoice_BossCheckBtn[index]:SetCheck(1);
				g_ShaXing_BossChoice_BossCheckTxt[index]:SetText(g_SXBossBuff[index].nEnableTips);
			else
				g_SXBossCheck[index] = 0
				g_ShaXing_BossChoice_BossCheckBtn[index]:SetCheck(0);
				g_ShaXing_BossChoice_BossCheckTxt[index]:SetText(g_SXBossBuff[index].nDisableTips);
			end
		end		
		g_ShaXing_BossChoice_BossCheckGrey[index]:Hide()
	end

	
	--����Ԫ����Ϣ
	--PushDebugMessage("test fenye nRandomList="..nRandomList)
	g_SXRandomIdxList[1] = math.mod(nRandomList,10)
	g_SXRandomIdxList[2] = math.mod(math.floor(nRandomList/10),10)  
	g_SXRandomIdxList[3] = math.mod(math.floor(nRandomList/100),10)  
	g_SXRandomIdxList[4] = math.mod(math.floor(nRandomList/1000),10) 
	--��ʼ������Ԫ����ʾͼ��
	for index=1,table.getn(g_ShaXing_BossChoice_RandomShowBtn)  do	
		local nCurRandomIdx = g_SXRandomIdxList[index]
		if nCurRandomIdx > 0 and nCurRandomIdx <= 5 then
			g_ShaXing_BossChoice_RandomShowImg[index]:SetProperty("Image",g_SXRandomImg[nCurRandomIdx].nImg);
			g_ShaXing_BossChoice_RandomShowBtn[index]:SetToolTip(GetDictionaryString(g_SXRandomImg[nCurRandomIdx].Tooltip));
		end
		g_ShaXing_BossChoice_RandomCheckPointTxt[index]:SetText(string.format("#c8c8c8c+%s��",tostring(g_SXRandomImg[nCurRandomIdx].nPoint)));
		g_ShaXing_BossChoice_RandomCheckNameTxt[index]:SetText(g_SXRandomImg[nCurRandomIdx].nName);
	end
	--����Ԫ��ѡ��
	local g_RandomChoiceList = {0,0,0,0}
	--PushDebugMessage("test  g_RandomChoiceList="..nRandomChoiceList)
	g_RandomChoiceList[1] = math.mod(nRandomChoiceList,10)
	g_RandomChoiceList[2] = math.floor(math.mod(nRandomChoiceList,100)/10)  
	g_RandomChoiceList[3] = math.floor(math.mod(nRandomChoiceList,1000)/100)  
	g_RandomChoiceList[4] = math.floor(math.mod(nRandomChoiceList,10000)/1000) 
	for index=1,table.getn(g_ShaXing_BossChoice_RandomShowBtn)  do
		local nCurRandomIdx = g_SXRandomIdxList[index]
		if nIsCurBoss == 1 or g_SXBossAbandon[g_ShaXing_FenyeIdx] == 1 then
			g_SXRandomCheck[index] = 0
			g_ShaXing_BossChoice_RandomShowBtn[index]:SetCheck(0)
			g_ShaXing_BossChoice_RandomCheckPointTxt[index]:SetText(string.format("+%s��",tostring(g_SXRandomImg[nCurRandomIdx].nPoint)));
		else
			if g_RandomChoiceList[index] > 0 then
				g_SXRandomCheck[index] = 1
				g_ShaXing_BossChoice_RandomShowBtn[index]:SetCheck(1)
				g_ShaXing_BossChoice_RandomCheckPointTxt[index]:SetText(string.format("#G+%s��",tostring(g_SXRandomImg[nCurRandomIdx].nPoint)));
			else
				g_SXRandomCheck[index] = 0
				g_ShaXing_BossChoice_RandomShowBtn[index]:SetCheck(0)
				g_ShaXing_BossChoice_RandomCheckPointTxt[index]:SetText(string.format("#c8c8c8c+%s��",tostring(g_SXRandomImg[nCurRandomIdx].nPoint)));
			end
		end		
		g_ShaXing_BossChoice_RandomCheckGrey[index]:Hide()
	end
	
	--���¼������
	ShaXing_BossChoice_Point()
	--��������
	KillTimer("ShaXing_BossChoice_CloseWindow()")
	this:Show()
end

--=========================================================
--bossģʽѡ��ѡ��
--=========================================================
function ShaXing_BossChoiceModel_ModeClicked(nIndex)
	--����У��
	if nIndex < 1 or nIndex > 3 then
		return
	end
	for index=1,table.getn(g_ShaXing_BossChoice_BossModeList)  do
		if nIndex == index then
			g_ShaXing_BossChoice_BossModeList[index]:SetCheck(1);
		else
			g_ShaXing_BossChoice_BossModeList[index]:SetCheck(0);
		end
	end

	--չʾͼƬ�ͻ���
	if nIndex == 1 then
		--PushDebugMessage("test  ModeClicked nBossIdx="..g_ShaXing_FenyeBossIdx.." img"..g_SXBossImg[g_ShaXing_FenyeBossIdx].nEasyImg)
		ShaXing_BossChoiceFakeObject:SetProperty( "Image", g_SXBossImg[g_ShaXing_FenyeBossIdx].nEasyImg )
		ShaXing_BossChoice_Num1:SetText(g_SXBossImg[g_ShaXing_FenyeBossIdx].nEasyTips);
	elseif nIndex == 2 then
		--PushDebugMessage("test  ModeClicked idx="..nIndex)
		ShaXing_BossChoiceFakeObject:SetProperty( "Image", g_SXBossImg[g_ShaXing_FenyeBossIdx].nNormalImg )	
		ShaXing_BossChoice_Num1:SetText(g_SXBossImg[g_ShaXing_FenyeBossIdx].nNormalTips);
	elseif nIndex == 3 then
		--PushDebugMessage("test  ModeClicked idx="..nIndex)
		ShaXing_BossChoiceFakeObject:SetProperty( "Image", g_SXBossImg[g_ShaXing_FenyeBossIdx].nHardImg )
		ShaXing_BossChoice_Num1:SetText(g_SXBossImg[g_ShaXing_FenyeBossIdx].nHardTips);
	end
	
	--boss״̬����Ϊ��ѡ
	for index=1,table.getn(g_ShaXing_BossChoice_BossCheckBtn)  do
		g_SXBossCheck[index] = 0
		g_ShaXing_BossChoice_BossCheckBtn[index]:SetCheck(0)
		g_ShaXing_BossChoice_BossCheckGrey[index]:Hide()
		g_ShaXing_BossChoice_BossCheckTxt[index]:SetText(g_SXBossBuff[index].nDisableTips);
	end
	
	--���¼������
	ShaXing_BossChoice_Point()
end

--=========================================================
--boss����ѡ��
--=========================================================
function ShaXing_BossChoice_BossClicked(nIndex)
	--PushDebugMessage("test ShaXing_BossChoice_BossClicked  index="..nIndex)
	if nIndex < 1 or nIndex > 4 then
		return
	end

	--��ť״̬ѡ��
	local  mCurBossCheck = g_SXBossCheck[nIndex]
	if mCurBossCheck == 1 then
		g_SXBossCheck[nIndex] = 0
		g_ShaXing_BossChoice_BossCheckTxt[nIndex]:SetText(g_SXBossBuff[nIndex].nDisableTips);
	else
		g_SXBossCheck[nIndex] = 1
		g_ShaXing_BossChoice_BossCheckTxt[nIndex]:SetText(g_SXBossBuff[nIndex].nEnableTips);
	end
	
	--���¼������
	ShaXing_BossChoice_Point()
end


--=========================================================
--����Ԫ��ѡ��
--=========================================================
function ShaXing_BossChoice_RandomClicked(nIndex)
	if nIndex < 1 or nIndex > 4 then
		return
	end
	--��ť״̬ѡ��
	local  mCurRandomCheck = g_SXRandomCheck[nIndex]
	local nCurRandomIdx = g_SXRandomIdxList[nIndex]
	if mCurRandomCheck == 1 then
		g_SXRandomCheck[nIndex] = 0
		g_ShaXing_BossChoice_RandomCheckPointTxt[nIndex]:SetText(string.format("+%s��",tostring(g_SXRandomImg[nCurRandomIdx].nPoint)));
		
	else
		g_SXRandomCheck[nIndex] = 1
		g_ShaXing_BossChoice_RandomCheckPointTxt[nIndex]:SetText(string.format("#G+%s��",tostring(g_SXRandomImg[nCurRandomIdx].nPoint)));	
	end
	
	--���¼������
	ShaXing_BossChoice_Point()
end


--=========================================================
--����Ԫ��˵��
--=========================================================
function ShaXing_BossChoice_RandomTips(nIndex)
	if nIndex < 1 or nIndex > 4 then
		return
	end
	
	--PushDebugMessage("test ShaXing_BossChoice_RandomTips")
end

--=========================================================
--��ҳ���
--=========================================================
function ShaXing_BossChoice_FenyeClicked(nIdex)
	--��ҳ
	--PushDebugMessage("test  FenyeClicked nIdex="..nIdex.." g_ShaXing_FenyeIdx="..g_ShaXing_FenyeIdx)
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "FenyeClicked" )
		Set_XSCRIPT_ScriptID( 750001)
		Set_XSCRIPT_Parameter( 0 ,g_ShaXing_targetId)
		Set_XSCRIPT_Parameter( 1 ,nIdex)
		Set_XSCRIPT_ParamCount( 2 )
	Send_XSCRIPT()

end


--=========================================================
--boss���ּ���
--=========================================================
function ShaXing_BossChoice_Point()
	local  bBossMode = 0
	for index=1,table.getn(g_ShaXing_BossChoice_BossModeList)  do
		local bBossCheck1 = g_ShaXing_BossChoice_BossModeList[index]:GetCheck();
		if bBossCheck1 > 0 then
			bBossMode = index
		end
	end
	local bBossCheck1 = g_SXBossCheck[1] 
	local bBossCheck2 = g_SXBossCheck[2]
	local bBossCheck3 = g_SXBossCheck[3]
	local bBossCheck4 = g_SXBossCheck[4]
	local bRandomCheck1 = g_SXRandomCheck[1]
	local bRandomCheck2 = g_SXRandomCheck[2]
	local bRandomCheck3 = g_SXRandomCheck[3]
	local bRandomCheck4 = g_SXRandomCheck[4]
	local nCurBossPoint = 0
	local modeUp = 1
	if bBossMode == 1 then
		nCurBossPoint = g_SXBossImg[1].nEasyPoint
		modeUp = 1
	elseif bBossMode == 2 then
		nCurBossPoint = g_SXBossImg[1].nNormalPoint
		modeUp = 1+0.7
	elseif bBossMode == 3 then
		nCurBossPoint = g_SXBossImg[1].nHardPoint
		modeUp = 1+1.5
	end

	
	local nBasePoint = nCurBossPoint + bBossCheck1*g_SXBossBuff[1].nPoint + bBossCheck2*g_SXBossBuff[2].nPoint + bBossCheck3*g_SXBossBuff[3].nPoint +bBossCheck4*g_SXBossBuff[4].nPoint+bRandomCheck1*g_SXRandomImg[g_SXRandomIdxList[1]].nPoint+bRandomCheck2*g_SXRandomImg[g_SXRandomIdxList[2]].nPoint+bRandomCheck3*g_SXRandomImg[g_SXRandomIdxList[3]].nPoint+bRandomCheck4*g_SXRandomImg[g_SXRandomIdxList[4]].nPoint
	-- PushDebugMessage("test ���� all="..nBasePoint*modeUp.."  modeUp="..modeUp.." nBasePoint"..nBasePoint)
	if bBossMode == 1 then
		ShaXing_BossChoice_AllNum:SetText(string.format("#Y%s",tostring(nBasePoint*modeUp)));
		ShaXing_BossChoice_AllNumFrame:SetProperty( "Image", "set:ShaXing1 image:ShaXing_TextBk1" )
	elseif bBossMode == 2 then
		ShaXing_BossChoice_AllNum:SetText(string.format("#Y%s",tostring(nBasePoint*modeUp)));
		ShaXing_BossChoice_AllNumFrame:SetProperty( "Image", "set:ShaXing1 image:ShaXing_TextBk2" )
	elseif bBossMode == 3 then
		ShaXing_BossChoice_AllNum:SetText(string.format("#Y%s",tostring(nBasePoint*modeUp)));
		ShaXing_BossChoice_AllNumFrame:SetProperty( "Image", "set:ShaXing1 image:ShaXing_TextBk3" )
	else
		ShaXing_BossChoice_AllNum:SetText(string.format("#Y%s0",tostring(nBasePoint*modeUp)));
		ShaXing_BossChoice_AllNumFrame:SetProperty( "Image", "set:ShaXing1 image:ShaXing_TextBk1" )
	end
	ShaXing_BossChoice_AllNum:Show();
end

--=========================================================
--��������
--=========================================================
function ShaXing_BossChoice_GiveUp()
	--��������ȷ��
	PushEvent("UI_COMMAND",20221123,g_ShaXing_targetId,g_ShaXing_FenyeIdx)
end

--=========================================================
--bossѡ��ȷ��
--=========================================================
function ShaXing_BossChoice_Confirm()
	--��ť״̬ѡ��
	local  bBossMode = 1
	for index=1,table.getn(g_ShaXing_BossChoice_BossModeList)  do
		local bBossCheck1 = g_ShaXing_BossChoice_BossModeList[index]:GetCheck();
		if bBossCheck1 > 0 then
			bBossMode = index
		end
	end
	
	local bBossCheck1 = g_SXBossCheck[1]
	local bBossCheck2 = g_SXBossCheck[2]
	local bBossCheck3 = g_SXBossCheck[3]
	local bBossCheck4 = g_SXBossCheck[4]
	local bRandomCheck1 = g_SXRandomCheck[1]
	local bRandomCheck2 = g_SXRandomCheck[2]
	local bRandomCheck3 = g_SXRandomCheck[3]
	local bRandomCheck4 = g_SXRandomCheck[4]	
	--PushDebugMessage("test bBossMode="..bBossMode.." Boss1="..bBossCheck1.." Boss2="..bBossCheck2.." Boss3="..bBossCheck3.." Boss4="..bBossCheck4.." Random1="..bRandomCheck1.." Random2="..bRandomCheck2.." Random3="..bRandomCheck3.." Random4="..bRandomCheck4)
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "BossChoiceConfirm" )
		Set_XSCRIPT_ScriptID( 750001)	
		Set_XSCRIPT_Parameter( 0 ,g_ShaXing_targetId)
		Set_XSCRIPT_Parameter( 1 ,g_ShaXing_FenyeIdx)
		Set_XSCRIPT_Parameter( 2 ,bBossMode)
		Set_XSCRIPT_Parameter( 3 ,bBossCheck4*1000+bBossCheck3*100+bBossCheck2*10+bBossCheck1)
		Set_XSCRIPT_Parameter( 4 ,bRandomCheck4*1000+bRandomCheck3*100+bRandomCheck2*10+bRandomCheck1)
		Set_XSCRIPT_ParamCount( 5 )
	Send_XSCRIPT()
end


--=========================================================
--Ԥ�����
--nBossIdx boss����
--nRandomList���ڳ���Ԫ���б� ��Ҫ���
--=========================================================
function ShaXing_BossChoice_JustShow(nSelectIdx,nBossIdx,nBossMode,nBossChoiceList,nRandomList,nRandomChoiceList,nBossAbandonList)
	if nSelectIdx < 1 or nSelectIdx > 4 then
		return
	end
	--��������
	KillTimer("ShaXing_BossChoice_CloseWindow()")
	-- PushDebugMessage("test JustShow nSelectIdx="..nSelectIdx.." nBossIdx="..nBossIdx.." nBossMode="..nBossMode.." nBossChoiceList="..nBossChoiceList.." nRandomList="..nRandomList.." nRandomChoiceList="..nRandomChoiceList.." nBossAbandonList="..nBossAbandonList)
	--���ò���
	g_ShaXing_FenyeIdx = nSelectIdx
	g_ShaXing_FenyeBossIdx = nBossIdx
	--PushDebugMessage("test  ShaXing_BossChoice_OpenFenye g_ShaXing_FenyeBossIdx="..g_ShaXing_FenyeBossIdx )
	--ѡ�е�ǰboss��ҳ ����ѡ
	for index=1,table.getn(g_ShaXing_BossChoice_Fenye)  do
		if index == g_ShaXing_FenyeIdx then
			g_ShaXing_BossChoice_Fenye[index]:SetCheck(1);
		else
			g_ShaXing_BossChoice_Fenye[index]:SetCheck(0);
		end
		g_ShaXing_BossChoice_Fenye[index]:Disable();
	end
	
	--ȷ�ϼ����ɵ�
	ShaXing_BossChoice_ActionFrame:Hide()
	ShaXing_BossChoice_ActionFrame2:Hide()
	--�ѶȲ���ѡ
	for index=1,table.getn(g_ShaXing_BossChoice_BossModeList)  do
		g_ShaXing_BossChoice_BossModeList[index]:Disable();
	end
	--���Բ���ѡ
	for index=1,table.getn(g_ShaXing_BossChoice_BossCheckBtn)  do
		g_ShaXing_BossChoice_BossCheckBtn[index]:Disable();
	end
	--����Ԫ�ز���ѡ
	for index=1,table.getn(g_ShaXing_BossChoice_RandomShowBtn)  do	
		g_ShaXing_BossChoice_RandomShowBtn[index]:Disable();
	end
	
	--boss�������
	--PushDebugMessage("test JustShow nBossAbandonList="..nBossAbandonList.." nSelectIdx="..nSelectIdx)
	g_SXBossAbandon[1] = math.mod(nBossAbandonList,10)
	g_SXBossAbandon[2] = math.mod(math.floor(nBossAbandonList/10),10)  
	g_SXBossAbandon[3] = math.mod(math.floor(nBossAbandonList/100),10)  
	g_SXBossAbandon[4] = math.mod(math.floor(nBossAbandonList/1000),10) 
	
	--�Ƿ�ͨ�ر��
	for index=1,table.getn(g_ShaXing_BossChoice_FenyeAbandon)  do
		if index <  g_ShaXing_FenyeIdx then
			if g_SXBossAbandon[index] == 1 then
				g_ShaXing_BossChoice_FenyeOk[index]:Hide();
				g_ShaXing_BossChoice_FenyeAbandon[index]:Show();
			else
				g_ShaXing_BossChoice_FenyeOk[index]:Show();
				g_ShaXing_BossChoice_FenyeAbandon[index]:Hide();
			end
		else
			g_ShaXing_BossChoice_FenyeOk[index]:Hide();
			g_ShaXing_BossChoice_FenyeAbandon[index]:Hide();
		end	
	end
	
	--չʾboss�Ѷ�
	for index=1,table.getn(g_ShaXing_BossChoice_BossModeList)  do
		if index == nBossMode then
			g_ShaXing_BossChoice_BossModeList[index]:SetCheck(1);
		else
			g_ShaXing_BossChoice_BossModeList[index]:SetCheck(0);
		end
	end
	
	--PushDebugMessage("test  nBossMode="..nBossMode)
	ShaXing_BossChoiceFakeObject:SetProperty( "Image", g_SXBossImg[nBossIdx].nEasyImg )
	ShaXing_BossChoice_Num1:SetText(g_SXBossImg[nBossIdx].nEasyTips);
	if nBossMode == 2 then
		ShaXing_BossChoiceFakeObject:SetProperty( "Image", g_SXBossImg[nBossIdx].nNormalImg )
		ShaXing_BossChoice_Num1:SetText(g_SXBossImg[nBossIdx].nNormalTips);
	elseif nBossMode == 3 then
		ShaXing_BossChoiceFakeObject:SetProperty( "Image", g_SXBossImg[nBossIdx].nHardImg )
		ShaXing_BossChoice_Num1:SetText(g_SXBossImg[nBossIdx].nHardTips);
	end
	
	--boss�ӳ�ѡ��
	--PushDebugMessage("test  nBossChoiceList="..nBossChoiceList)
	local g_BossChoiceList = {0,0,0,0}
	g_BossChoiceList[1] = math.mod(nBossChoiceList,10)
	g_BossChoiceList[2] = math.mod(math.floor(nBossChoiceList/10),10)  
	g_BossChoiceList[3] = math.mod(math.floor(nBossChoiceList/100),10)--����������õ� 12
	g_BossChoiceList[4] = math.mod(math.floor(nBossChoiceList/1000),10) 
	for index=1,table.getn(g_ShaXing_BossChoice_BossCheckBtn)  do
		if g_BossChoiceList[index] > 0 then
			g_SXBossCheck[index] = 1
			g_ShaXing_BossChoice_BossCheckBtn[index]:SetCheck(1);
			g_ShaXing_BossChoice_BossCheckGrey[index]:Hide()
			g_ShaXing_BossChoice_BossCheckTxt[index]:SetText(g_SXBossBuff[index].nEnableTips);
		else
			g_SXBossCheck[index] = 0
			g_ShaXing_BossChoice_BossCheckBtn[index]:SetCheck(0);
			g_ShaXing_BossChoice_BossCheckGrey[index]:Show()
			g_ShaXing_BossChoice_BossCheckTxt[index]:SetText(g_SXBossBuff[index].nDisableTips);
		end
	end
	
	--����Ԫ����Ϣ
	-- PushDebugMessage("test JustShow nRandomList="..nRandomList)
	g_SXRandomIdxList[1] = math.mod(nRandomList,10)
	g_SXRandomIdxList[2] = math.mod(math.floor(nRandomList/10),10)  
	g_SXRandomIdxList[3] = math.mod(math.floor(nRandomList/100),10)  
	g_SXRandomIdxList[4] = math.mod(math.floor(nRandomList/1000),10) 
	--��ʼ������Ԫ����ʾͼ��
	for index=1,table.getn(g_ShaXing_BossChoice_RandomShowBtn)  do	
		local nCurRandomIdx = g_SXRandomIdxList[index]
		if nCurRandomIdx > 0 and nCurRandomIdx <= 5 then
			g_ShaXing_BossChoice_RandomShowImg[index]:SetProperty("Image",g_SXRandomImg[nCurRandomIdx].nImg);
			g_ShaXing_BossChoice_RandomShowBtn[index]:SetToolTip(GetDictionaryString(g_SXRandomImg[nCurRandomIdx].Tooltip));
		end
		g_ShaXing_BossChoice_RandomCheckPointTxt[index]:SetText(string.format("+%s��",tostring(g_SXRandomImg[nCurRandomIdx].nPoint)));
		g_ShaXing_BossChoice_RandomCheckNameTxt[index]:SetText(g_SXRandomImg[nCurRandomIdx].nName);
	end
	--����Ԫ��ѡ��
	local g_RandomChoiceList = {0,0,0,0}
	-- PushDebugMessage("test  g_RandomChoiceList="..nRandomChoiceList)
	g_RandomChoiceList[1] = math.mod(nRandomChoiceList,10)
	g_RandomChoiceList[2] = math.floor(math.mod(nRandomChoiceList,100)/10)  
	g_RandomChoiceList[3] = math.floor(math.mod(nRandomChoiceList,1000)/100)  
	g_RandomChoiceList[4] = math.floor(math.mod(nRandomChoiceList,10000)/1000) 
	for index=1,table.getn(g_ShaXing_BossChoice_RandomShowBtn)  do
		local nCurRandomIdx = g_SXRandomIdxList[index]
		if g_RandomChoiceList[index] > 0 then
			g_SXRandomCheck[index] = 1
			g_ShaXing_BossChoice_RandomShowBtn[index]:SetCheck(1);
			g_ShaXing_BossChoice_RandomCheckGrey[index]:Hide()
			g_ShaXing_BossChoice_RandomCheckPointTxt[index]:SetText(string.format("#G+%s��",tostring(g_SXRandomImg[nCurRandomIdx].nPoint)));
		else
			g_SXRandomCheck[index] = 0
			g_ShaXing_BossChoice_RandomShowBtn[index]:SetCheck(0);
			g_ShaXing_BossChoice_RandomCheckGrey[index]:Show()
			g_ShaXing_BossChoice_RandomCheckPointTxt[index]:SetText(string.format("#c8c8c8c+%s��",tostring(g_SXRandomImg[nCurRandomIdx].nPoint)));
		end
	end
	
	--���¼������
	ShaXing_BossChoice_Point()
	--��ʾ
	ShaXing_BossChoice_ActionFrame:Hide()
	ShaXing_BossChoice_ActionFrame2:Show()

	--����ʱ
	SetTimer("ShaXing_BossChoice","ShaXing_BossChoice_CloseWindow()", 1000);		--���ö�ʱ��5���ӵ���ʱ
	g_ShaXing_CloseTick = 5
	ShaXing_BossChoice_ActionFrame2_Text:SetText(string.format("#W�ӳ���ѡ����ϣ�ɱ�ǽ���#G%s#W�����֡�",g_ShaXing_CloseTick));

	this:Show()
end


--================================================
-- ����ʱ����
--================================================
function ShaXing_BossChoice_CloseWindow()
	KillTimer("ShaXing_BossChoice_CloseWindow()")
	g_ShaXing_CloseTick = g_ShaXing_CloseTick - 1
	ShaXing_BossChoice_ActionFrame2_Text:SetText(string.format("#W�ӳ���ѡ����ϣ�ɱ�ǽ���#G%s#W�����֡�",g_ShaXing_CloseTick));
	--PushDebugMessage("test  ShaXing_BossChoice_CloseWindow  g_ShaXing_CloseTick="..g_ShaXing_CloseTick)
	if g_ShaXing_CloseTick > 0 then
		SetTimer("ShaXing_BossChoice","ShaXing_BossChoice_CloseWindow()", 1000)
	else
		--�رս���
		ShaXing_BossChoice_OnClose()
	end
end


--=========================================================
--����˵��
--=========================================================
function ShaXing_BossChoice_Help2Clicked()
	PushEvent("UI_COMMAND", 20211201,6)
end

function ShaXing_BossChoice_Help3Clicked()
	PushEvent("UI_COMMAND", 20211201,7)
end

function ShaXing_BossChoice_Help4Clicked()
	PushEvent("UI_COMMAND", 20211201,8)
end

