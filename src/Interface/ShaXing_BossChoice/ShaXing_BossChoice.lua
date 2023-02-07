--******************************************
--新杀星副本	boss选择界面
--create by  limengyue 
--2022-07-28
--******************************************

local g_ShaXing_BossChoice_Frame_UnifiedPosition;
--关心NPc
local MAX_OBJ_DISTANCE = 3.0
local objCared = -1
local g_Object = -1


local g_ShaXing_BossChoice_Fenye = {}	--四个boss选择分页
local g_ShaXing_BossChoice_FenyeOk = {}	--四个boss 是否通关标记
local g_ShaXing_BossChoice_FenyeAbandon = {}	--四个boss 是否通关标记
local g_ShaXing_BossChoice_BossModeList = {}	--三个boss模式选择
local g_ShaXing_BossChoice_BossCheckGrey = {}	--四个boss状态选择标记图片
local g_ShaXing_BossChoice_BossCheckBtn = {}	--四个boss状态选择按钮
local g_ShaXing_BossChoice_BossCheckTxt = {}	--四个boss状态显示文字
local g_ShaXing_BossChoice_RandomShowBtn = {}	--四个场地元素显示内容
local g_ShaXing_BossChoice_RandomShowImg= {}	--四个场地元素显示图标
local g_ShaXing_BossChoice_RandomCheckGrey = {}	--四个场地元素选择控件
local g_ShaXing_BossChoice_RandomCheckNameTxt = {}	--四个场地元素名字
local g_ShaXing_BossChoice_RandomCheckPointTxt = {}	--四个场地元素选择积分显示
local g_SXBossImg =	--boss难度不同图片
{
	[1] = {nName="宋姜",nEasyPoint=1000,nNormalPoint=1000,nHardPoint=1000,nEasyTips="#{XSX_220705_277}",nNormalTips="#{XSX_220705_278}",nHardTips="#{XSX_220705_279}",nEasyImg="set:ShaXing5 image:ShaXing_sj1",nNormalImg="set:ShaXing5 image:ShaXing_sj2",nHardImg="set:ShaXing5 image:ShaXing_sj3"},
	[2] = {nName="卢君逸",nEasyPoint=1000,nNormalPoint=1000,nHardPoint=1000,nEasyTips="#{XSX_220705_277}",nNormalTips="#{XSX_220705_278}",nHardTips="#{XSX_220705_279}",nEasyImg="set:ShaXing3 image:ShaXing_ljy1",nNormalImg="set:ShaXing3 image:ShaXing_ljy2",nHardImg="set:ShaXing3 image:ShaXing_ljy3"},
	[3] = {nName="李魁",nEasyPoint=1000,nNormalPoint=1000,nHardPoint=1000,nEasyTips="#{XSX_220705_277}",nNormalTips="#{XSX_220705_278}",nHardTips="#{XSX_220705_279}",nEasyImg="set:ShaXing3 image:ShaXing_lk1",nNormalImg="set:ShaXing4 image:ShaXing_lk2",nHardImg="set:ShaXing4 image:ShaXing_lk3"},
	[4] = {nName="鲁志生",nEasyPoint=1000,nNormalPoint=1000,nHardPoint=1000,nEasyTips="#{XSX_220705_277}",nNormalTips="#{XSX_220705_278}",nHardTips="#{XSX_220705_279}",nEasyImg="set:ShaXing4 image:ShaXing_lzs1",nNormalImg="set:ShaXing4 image:ShaXing_lzs2",nHardImg="set:ShaXing5 image:ShaXing_lzs3"},
	[5] = {nName="关盛",nEasyPoint=1000,nNormalPoint=1000,nHardPoint=1000,nEasyTips="#{XSX_220705_277}",nNormalTips="#{XSX_220705_278}",nHardTips="#{XSX_220705_279}",nEasyImg="set:ShaXing1 image:ShaXing_gs1",nNormalImg="set:ShaXing1 image:ShaXing_gs2",nHardImg="set:ShaXing2 image:ShaXing_gs3"},
	[6] = {nName="吴永",nEasyPoint=1000,nNormalPoint=1000,nHardPoint=1000,nEasyTips="#{XSX_220705_277}",nNormalTips="#{XSX_220705_278}",nHardTips="#{XSX_220705_279}",nEasyImg="set:ShaXing6 image:ShaXing_wy1",nNormalImg="set:ShaXing6 image:ShaXing_wy2",nHardImg="set:ShaXing6 image:ShaXing_wy3"},
	[7] = {nName="公孙圣",nEasyPoint=1000,nNormalPoint=1000,nHardPoint=1000,nEasyTips="#{XSX_220705_277}",nNormalTips="#{XSX_220705_278}",nHardTips="#{XSX_220705_279}",nEasyImg="set:ShaXing2 image:ShaXing_gss1",nNormalImg="set:ShaXing2 image:ShaXing_gss2",nHardImg="set:ShaXing2 image:ShaXing_gss3"},
}
local g_SXBossBuff = --boss属性选择加分情况
{
	[1] = {nName="不吃放大",nPoint=350,nEnableTips="#{XSX_220705_293}",nDisableTips="#{XSX_220705_294}"},
	[2] = {nName="吸血",nPoint=200,nEnableTips="#{XSX_220705_295}",nDisableTips="#{XSX_220705_296}"},
	[3] = {nName="技能加快",nPoint=350,nEnableTips="#{XSX_220705_297}",nDisableTips="#{XSX_220705_298}"},
	[4] = {nName="狂暴",nPoint=300,nEnableTips="#{XSX_220705_299}",nDisableTips="#{XSX_220705_300}"},
}
local g_SXRandomImg = --不同场地元素图片
{
	[1] = {nwarning="持续陷阱",nName="#{XSX_220705_262}",nImg="set:FBSkill_2 image:FBSkill_2_6",nPoint=300,Tooltip="XSX_220705_267"},
	[2] = {nwarning="加血圈",nName="#{XSX_220705_263}",nImg="set:FBSkill_2 image:FBSkill_2_8",nPoint=150,Tooltip="XSX_220705_268"},
	[3] = {nwarning="减治疗",nName="#{XSX_220705_264}",nImg="set:FBSkill_2 image:FBSkill_2_5",nPoint=250,Tooltip="XSX_220705_269"},
	[4] = {nwarning="吸蓝",nName="#{XSX_220705_265}",nImg="set:FBSkill_2 image:FBSkill_2_9",nPoint=150,Tooltip="XSX_220705_270"},
	[5] = {nwarning="眩晕",nName="#{XSX_220705_266}",nImg="set:FBSkill_2 image:FBSkill_2_7",nPoint=250,Tooltip="XSX_220705_271"},
}

local g_ShaXing_CloseTick = 1	--倒计时
local g_ShaXing_FenyeIdx = -1	--第几个分页
local g_ShaXing_FenyeBossIdx = -1	--当前副本第几个boss索引
local g_SXBossCheck = {0,0,0,0,}--四个boss状态选择情况
local g_SXRandomCheck = {0,0,0,0,}--四个场地元素选择情况
local g_SXRandomIdxList = {1,2,3,4,}--四个场地元素索引（服务器随机）
local g_SXBossAbandon = {0,0,0,0,}--boss放弃情况
local g_ShaXing_targetId = -1;
--===============================================
-- OnLoad()
--===============================================
function ShaXing_BossChoice_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	--距离NPC距离
	this:RegisterEvent("OBJECT_CARED_EVENT",false)
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)	
	--切场景事件
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false);
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
end

--===============================================
-- OnLoad()
--===============================================
function ShaXing_BossChoice_OnLoad()   
	-- 保存界面的默认相对位置
	g_ShaXing_BossChoice_Frame_UnifiedPosition = ShaXing_BossChoice_Frame:GetProperty("UnifiedPosition");

	--控件
	--boss选择分页
	g_ShaXing_BossChoice_Fenye[1] = ShaXing_BossChoice_Boss1
	g_ShaXing_BossChoice_Fenye[2] = ShaXing_BossChoice_Boss2
	g_ShaXing_BossChoice_Fenye[3] = ShaXing_BossChoice_Boss3
	g_ShaXing_BossChoice_Fenye[4] = ShaXing_BossChoice_Boss4
	--是否通关标记
	g_ShaXing_BossChoice_FenyeOk[1] = ShaXing_BossChoice_Boss1_Ok
	g_ShaXing_BossChoice_FenyeOk[2] = ShaXing_BossChoice_Boss2_Ok
	g_ShaXing_BossChoice_FenyeOk[3] = ShaXing_BossChoice_Boss3_Ok
	g_ShaXing_BossChoice_FenyeOk[4] = ShaXing_BossChoice_Boss4_Ok
	g_ShaXing_BossChoice_FenyeAbandon[1] = ShaXing_BossChoice_Boss1_Abandon
	g_ShaXing_BossChoice_FenyeAbandon[2] = ShaXing_BossChoice_Boss2_Abandon
	g_ShaXing_BossChoice_FenyeAbandon[3] = ShaXing_BossChoice_Boss3_Abandon
	g_ShaXing_BossChoice_FenyeAbandon[4] = ShaXing_BossChoice_Boss4_Abandon	
	--三个boss模式选择
	g_ShaXing_BossChoice_BossModeList[1] = ShaXing_BossChoiceModel_Bind
	g_ShaXing_BossChoice_BossModeList[2] = ShaXing_BossChoiceModel_Bind2
	g_ShaXing_BossChoice_BossModeList[3] = ShaXing_BossChoiceModel_Bind3
	--四个boss状态选择按钮
	g_ShaXing_BossChoice_BossCheckBtn[1] = ShaXing_BossChoice_Add1
	g_ShaXing_BossChoice_BossCheckBtn[2] = ShaXing_BossChoice_Add2
	g_ShaXing_BossChoice_BossCheckBtn[3] = ShaXing_BossChoice_Add3
	g_ShaXing_BossChoice_BossCheckBtn[4] = ShaXing_BossChoice_Add4
	--四个boss状态显示文字
	g_ShaXing_BossChoice_BossCheckTxt[1] = ShaXing_BossChoice_Add1Num
	g_ShaXing_BossChoice_BossCheckTxt[2] = ShaXing_BossChoice_Add2Num
	g_ShaXing_BossChoice_BossCheckTxt[3] = ShaXing_BossChoice_Add3Num
	g_ShaXing_BossChoice_BossCheckTxt[4] = ShaXing_BossChoice_Add4Num
	--boss状态选择
	g_ShaXing_BossChoice_BossCheckGrey[1] = ShaXing_BossChoice_Add1_Mask
	g_ShaXing_BossChoice_BossCheckGrey[2] = ShaXing_BossChoice_Add2_Mask
	g_ShaXing_BossChoice_BossCheckGrey[3] = ShaXing_BossChoice_Add3_Mask
	g_ShaXing_BossChoice_BossCheckGrey[4] = ShaXing_BossChoice_Add4_Mask
	--场地元素显示
	g_ShaXing_BossChoice_RandomShowBtn[1] = ShaXing_BossChoice_Place1
	g_ShaXing_BossChoice_RandomShowBtn[2] = ShaXing_BossChoice_Place2
	g_ShaXing_BossChoice_RandomShowBtn[3] = ShaXing_BossChoice_Place3
	g_ShaXing_BossChoice_RandomShowBtn[4] = ShaXing_BossChoice_Place4
	--四个场地元素显示图标
	g_ShaXing_BossChoice_RandomShowImg[1] = ShaXing_BossChoice_Place1Image
	g_ShaXing_BossChoice_RandomShowImg[2] = ShaXing_BossChoice_Place2Image
	g_ShaXing_BossChoice_RandomShowImg[3] = ShaXing_BossChoice_Place3Image
	g_ShaXing_BossChoice_RandomShowImg[4] = ShaXing_BossChoice_Place4Image
	--场地元素选择
	g_ShaXing_BossChoice_RandomCheckGrey[1] = ShaXing_BossChoice_Place1_Mask
	g_ShaXing_BossChoice_RandomCheckGrey[2] = ShaXing_BossChoice_Place2_Mask
	g_ShaXing_BossChoice_RandomCheckGrey[3] = ShaXing_BossChoice_Place3_Mask
	g_ShaXing_BossChoice_RandomCheckGrey[4] = ShaXing_BossChoice_Place4_Mask
	--四个场地元素名字
	g_ShaXing_BossChoice_RandomCheckNameTxt[1] = ShaXing_BossChoice_Place1Text
	g_ShaXing_BossChoice_RandomCheckNameTxt[2] = ShaXing_BossChoice_Place2Text
	g_ShaXing_BossChoice_RandomCheckNameTxt[3] = ShaXing_BossChoice_Place3Text
	g_ShaXing_BossChoice_RandomCheckNameTxt[4] = ShaXing_BossChoice_Place4Text
	--场地积分显示
	g_ShaXing_BossChoice_RandomCheckPointTxt[1] = ShaXing_BossChoice_Place1Num
	g_ShaXing_BossChoice_RandomCheckPointTxt[2] = ShaXing_BossChoice_Place2Num
	g_ShaXing_BossChoice_RandomCheckPointTxt[3] = ShaXing_BossChoice_Place3Num
	g_ShaXing_BossChoice_RandomCheckPointTxt[4] = ShaXing_BossChoice_Place4Num
	
end


--================================================
-- 恢复界面的默认相对位置
--================================================
function ShaXing_BossChoice_Frame_On_ResetPos()
	ShaXing_BossChoice_Frame:SetProperty("UnifiedPosition", g_ShaXing_BossChoice_Frame_UnifiedPosition);
end

--===============================================
-- OnEvent()
--===============================================
function ShaXing_BossChoice_OnEvent(event)

    if(event == "UI_COMMAND" and tonumber(arg0) == 89331101) then
		--打开界面
		if(IsWindowShow("ShaXing_BossChoice")) then
			CloseWindow("ShaXing_BossChoice", true)
		end
		--添加NPC关心 不需要
		g_ShaXing_targetId = Get_XParam_INT(0)
		-- if g_ShaXing_targetId >= 0 then
			-- objCared = DataPool : GetNPCIDByServerID(g_ShaXing_targetId);
			-- ShaXing_BossChoice_BeginCareObject(objCared)
		-- end
		if Get_XParam_INT(1) > 0 then --第几个boss
			ShaXing_BossChoice_Open(Get_XParam_INT(1),Get_XParam_INT(2),Get_XParam_INT(3),Get_XParam_INT(4),Get_XParam_INT(5),Get_XParam_INT(6),Get_XParam_INT(7),Get_XParam_INT(8))
		end
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 89331104 ) then
		--PushDebugMessage("test idx="..Get_XParam_INT(1))
		if Get_XParam_INT(0) > 0 then --第几个boss
			ShaXing_BossChoice_OpenFenye(Get_XParam_INT(0),Get_XParam_INT(1),Get_XParam_INT(2),Get_XParam_INT(3),Get_XParam_INT(4),Get_XParam_INT(5),Get_XParam_INT(6),Get_XParam_INT(7),Get_XParam_INT(8))
		end
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 89331106 ) then
		--预告界面
		--PushDebugMessage("test 预告界面IDx="..Get_XParam_INT(1))
		if Get_XParam_INT(0) > 0 then --第几个boss
			ShaXing_BossChoice_JustShow(Get_XParam_INT(0),Get_XParam_INT(1),Get_XParam_INT(2),Get_XParam_INT(3),Get_XParam_INT(4),Get_XParam_INT(5),Get_XParam_INT(6))
		end
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 89331102 ) then
		--开怪成功 关闭窗口
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
    -- 游戏窗口尺寸发生了变化
	if (event == "ADJEST_UI_POS" ) then
		ShaXing_BossChoice_Frame_On_ResetPos()
	-- 游戏分辨率发生了变化
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
--开始关心NPC
--=========================================================
function ShaXing_BossChoice_BeginCareObject(objCaredId)
	-- if g_Object ~= -1 then
		-- this:CareObject(objCaredId, 0, "ShaXing_BossChoice");
	-- end
	-- g_Object = objCaredId
	-- this:CareObject(g_Object, 1, "ShaXing_BossChoice")
end


--=========================================================
--停止对某NPC的关心
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
--默认打开界面
--nSelectIdx 选的第几个boss
--nBossIdx boss索引
--nRandomList本期场地元素列表 需要拆分
--=========================================================
function ShaXing_BossChoice_Open(nSelectIdx,nBossIdx,nBossAbandonList,nRandomList,bLeader,nBossMode,nRandomChoiceList,nBossChoiceList)
	if nSelectIdx < 1 or nSelectIdx > 4 then
		return
	end
	--设置参数
	g_ShaXing_FenyeIdx = nSelectIdx
	g_ShaXing_FenyeBossIdx = nBossIdx
	--选中当前boss分页
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
	--boss放弃情况
	--PushDebugMessage("test ShaXing_BossChoiceModel_open nBossAbandonList="..nBossAbandonList)
	g_SXBossAbandon[1] = math.mod(nBossAbandonList,10)
	g_SXBossAbandon[2] = math.floor(math.mod(nBossAbandonList,100)/10)  
	g_SXBossAbandon[3] = math.floor(math.mod(nBossAbandonList,1000)/100)  
	g_SXBossAbandon[4] = math.floor(math.mod(nBossAbandonList,10000)/1000) 
	
	--是否通关标记
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
	
	--boss模式默认选简单	
	--展示boss 默认展示难度1
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
	
	--boss状态默认不选
	for index=1,table.getn(g_ShaXing_BossChoice_BossCheckBtn)  do
		g_SXBossCheck[index] = 0
		g_ShaXing_BossChoice_BossCheckBtn[index]:SetCheck(0)
		g_ShaXing_BossChoice_BossCheckGrey[index]:Hide()
		g_ShaXing_BossChoice_BossCheckTxt[index]:SetText(g_SXBossBuff[index].nDisableTips);
	end

	--场地元素信息
	--PushDebugMessage("test ShaXing_BossChoiceModel_open nRandomList="..nRandomList)
	g_SXRandomIdxList[1] = math.mod(nRandomList,10)
	g_SXRandomIdxList[2] = math.mod(math.floor(nRandomList/10),10)  
	g_SXRandomIdxList[3] = math.mod(math.floor(nRandomList/100),10)  
	g_SXRandomIdxList[4] = math.mod(math.floor(nRandomList/1000),10) 
	--初始化场地元素显示图标
	for index=1,table.getn(g_ShaXing_BossChoice_RandomShowBtn)  do	
		local nCurRandomIdx = g_SXRandomIdxList[index]
		if nCurRandomIdx > 0 and nCurRandomIdx <= 5 then
			g_ShaXing_BossChoice_RandomShowBtn[index]:Enable()
			g_ShaXing_BossChoice_RandomShowImg[index]:SetProperty("Image",g_SXRandomImg[nCurRandomIdx].nImg);
			g_ShaXing_BossChoice_RandomShowBtn[index]:SetToolTip(GetDictionaryString(g_SXRandomImg[nCurRandomIdx].Tooltip));
		else
			g_ShaXing_BossChoice_RandomShowBtn[index]:Disable()
		end
		g_ShaXing_BossChoice_RandomCheckPointTxt[index]:SetText(string.format("+%s分",tostring(g_SXRandomImg[nCurRandomIdx].nPoint)));
		g_ShaXing_BossChoice_RandomCheckNameTxt[index]:SetText(g_SXRandomImg[nCurRandomIdx].nName);
	end
	--场地元素选择
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
			g_ShaXing_BossChoice_RandomCheckPointTxt[index]:SetText(string.format("+%s分",tostring(g_SXRandomImg[nCurRandomIdx].nPoint)));
		else
			if g_RandomChoiceList[index] > 0 then
				g_SXRandomCheck[index] = 1
				g_ShaXing_BossChoice_RandomShowBtn[index]:SetCheck(1)
				g_ShaXing_BossChoice_RandomCheckPointTxt[index]:SetText(string.format("#G+%s分",tostring(g_SXRandomImg[nCurRandomIdx].nPoint)));
			else
				g_SXRandomCheck[index] = 0
				g_ShaXing_BossChoice_RandomShowBtn[index]:SetCheck(0)
				g_ShaXing_BossChoice_RandomCheckPointTxt[index]:SetText(string.format("#c8c8c8c+%s分",tostring(g_SXRandomImg[nCurRandomIdx].nPoint)));
			end
		end		
		g_ShaXing_BossChoice_RandomCheckGrey[index]:Hide()
	end

	--难度可选
	for index=1,table.getn(g_ShaXing_BossChoice_BossModeList)  do
		g_ShaXing_BossChoice_BossModeList[index]:Enable();
	end
	--属性可选
	for index=1,table.getn(g_ShaXing_BossChoice_BossCheckBtn)  do
		g_ShaXing_BossChoice_BossCheckBtn[index]:Enable();
		g_ShaXing_BossChoice_BossCheckBtn[index]:SetCheck(0)
	end
	--场地元素可选
	for index=1,table.getn(g_ShaXing_BossChoice_RandomShowBtn)  do	
		g_ShaXing_BossChoice_RandomShowBtn[index]:Enable();
	end
	--场地加成选择
	local g_BossChoiceList = {0,0,0,0}
	g_BossChoiceList[1] = math.mod(nBossChoiceList,10)
	g_BossChoiceList[2] = math.mod(math.floor(nBossChoiceList/10),10)  
	g_BossChoiceList[3] = math.mod(math.floor(nBossChoiceList/100),10) --这个服务器用的 12
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
	--队长显示
	if bLeader == 1 then
		ShaXing_BossChoice_ActionFrame:Show()
		ShaXing_BossChoice_ActionFrame2:Hide()
	else
		ShaXing_BossChoice_ActionFrame:Hide()
		ShaXing_BossChoice_ActionFrame2:Show()
		ShaXing_BossChoice_ActionFrame2_Text:SetText("#{XSX_220705_360}");
	end
	--重新计算积分
	ShaXing_BossChoice_Point()
	--动画重置
	KillTimer("ShaXing_BossChoice_CloseWindow()")
	this:Show()
end

--=========================================================
--打开其他界面
--nSelectIdx 选的第几个boss
--nBossIdx boss索引
--nRandomList本期场地元素列表 需要拆分
--=========================================================
function ShaXing_BossChoice_OpenFenye(nKillBossCount,nSelectIdx,nBossIdx,nIsCurBoss,nBossMode,nBossChoiceList,nRandomList,nRandomChoiceList,nBossAbandonList)
	if nSelectIdx < 1 or nSelectIdx > 4 then
		return
	end
	--队长显示
	local iIsLeader = DataPool:IsTeamLeader();
	if iIsLeader == 1 then
		ShaXing_BossChoice_ActionFrame:Show()
		ShaXing_BossChoice_ActionFrame2:Hide()
	else
		ShaXing_BossChoice_ActionFrame:Hide()
		ShaXing_BossChoice_ActionFrame2:Show()
		ShaXing_BossChoice_ActionFrame2_Text:SetText("#{XSX_220705_360}");
	end
	--设置参数
	g_ShaXing_FenyeIdx = nSelectIdx
	g_ShaXing_FenyeBossIdx = nBossIdx
	local nFenyeMax = g_ShaXing_FenyeIdx
	-- PushDebugMessage("nKillBossCount  =  "..nKillBossCount.."  g_ShaXing_FenyeIdx  =  "..g_ShaXing_FenyeIdx)
	if nKillBossCount +1  > g_ShaXing_FenyeIdx then
		nFenyeMax = nKillBossCount +1 
	end
	--PushDebugMessage("test  ShaXing_BossChoice_OpenFenye nSelectIdx="..nSelectIdx.." g_ShaXing_FenyeBossIdx="..g_ShaXing_FenyeBossIdx )
	--选中当前boss分页
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
	
	--屏蔽按钮
	if nIsCurBoss == 0 then
		--确认键不可点
		ShaXing_BossChoice_ActionFrame:Hide()
		ShaXing_BossChoice_ActionFrame2:Hide()
		--难度不可选
		for index=1,table.getn(g_ShaXing_BossChoice_BossModeList)  do
			g_ShaXing_BossChoice_BossModeList[index]:Disable();
		end
		--属性不可选
		for index=1,table.getn(g_ShaXing_BossChoice_BossCheckBtn)  do
			g_ShaXing_BossChoice_BossCheckBtn[index]:Disable();
		end
		--场地元素不可选
		for index=1,table.getn(g_ShaXing_BossChoice_RandomShowBtn)  do	
			g_ShaXing_BossChoice_RandomShowBtn[index]:Disable();
		end
	else
		--确认键可点
		ShaXing_BossChoice_ActionFrame:Show()
		ShaXing_BossChoice_ActionFrame2:Hide()
		--难度可选
		for index=1,table.getn(g_ShaXing_BossChoice_BossModeList)  do
			g_ShaXing_BossChoice_BossModeList[index]:Enable();
		end
		--属性可选
		for index=1,table.getn(g_ShaXing_BossChoice_BossCheckBtn)  do
			g_ShaXing_BossChoice_BossCheckBtn[index]:Enable();
			g_ShaXing_BossChoice_BossCheckBtn[index]:SetCheck(0)
		end
		--场地元素可选
		for index=1,table.getn(g_ShaXing_BossChoice_RandomShowBtn)  do	
			g_ShaXing_BossChoice_RandomShowBtn[index]:Enable();
			g_ShaXing_BossChoice_RandomShowBtn[index]:SetCheck(0)
		end
	end
	
	
	--boss放弃情况
	--PushDebugMessage("test fenye nBossAbandonList="..nBossAbandonList.." nKillBossCount="..nKillBossCount)
	g_SXBossAbandon[1] = math.mod(nBossAbandonList,10)
	g_SXBossAbandon[2] = math.floor(math.mod(nBossAbandonList,100)/10)  
	g_SXBossAbandon[3] = math.floor(math.mod(nBossAbandonList,1000)/100)  
	g_SXBossAbandon[4] = math.floor(math.mod(nBossAbandonList,10000)/1000) 
	
	--是否通关标记
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
		-- 当前选择boss客户端显示修正
		nBossMode = 1 
	end
	
	if g_SXBossAbandon[g_ShaXing_FenyeIdx] == 1 then
		--放弃boss客户端显示修正
		nBossMode = 0 
	end
	
	--展示boss难度
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
	
	--boss加成选择
	--PushDebugMessage("test  nBossChoiceList="..nBossChoiceList)
	local g_BossChoiceList = {0,0,0,0}
	g_BossChoiceList[1] = math.mod(nBossChoiceList,10)
	g_BossChoiceList[2] = math.floor(math.mod(nBossChoiceList,100)/10)  
	g_BossChoiceList[3] = math.floor(math.mod(nBossChoiceList,1000)/100) - 1 --这个服务器用的 12
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

	
	--场地元素信息
	--PushDebugMessage("test fenye nRandomList="..nRandomList)
	g_SXRandomIdxList[1] = math.mod(nRandomList,10)
	g_SXRandomIdxList[2] = math.mod(math.floor(nRandomList/10),10)  
	g_SXRandomIdxList[3] = math.mod(math.floor(nRandomList/100),10)  
	g_SXRandomIdxList[4] = math.mod(math.floor(nRandomList/1000),10) 
	--初始化场地元素显示图标
	for index=1,table.getn(g_ShaXing_BossChoice_RandomShowBtn)  do	
		local nCurRandomIdx = g_SXRandomIdxList[index]
		if nCurRandomIdx > 0 and nCurRandomIdx <= 5 then
			g_ShaXing_BossChoice_RandomShowImg[index]:SetProperty("Image",g_SXRandomImg[nCurRandomIdx].nImg);
			g_ShaXing_BossChoice_RandomShowBtn[index]:SetToolTip(GetDictionaryString(g_SXRandomImg[nCurRandomIdx].Tooltip));
		end
		g_ShaXing_BossChoice_RandomCheckPointTxt[index]:SetText(string.format("#c8c8c8c+%s分",tostring(g_SXRandomImg[nCurRandomIdx].nPoint)));
		g_ShaXing_BossChoice_RandomCheckNameTxt[index]:SetText(g_SXRandomImg[nCurRandomIdx].nName);
	end
	--场地元素选择
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
			g_ShaXing_BossChoice_RandomCheckPointTxt[index]:SetText(string.format("+%s分",tostring(g_SXRandomImg[nCurRandomIdx].nPoint)));
		else
			if g_RandomChoiceList[index] > 0 then
				g_SXRandomCheck[index] = 1
				g_ShaXing_BossChoice_RandomShowBtn[index]:SetCheck(1)
				g_ShaXing_BossChoice_RandomCheckPointTxt[index]:SetText(string.format("#G+%s分",tostring(g_SXRandomImg[nCurRandomIdx].nPoint)));
			else
				g_SXRandomCheck[index] = 0
				g_ShaXing_BossChoice_RandomShowBtn[index]:SetCheck(0)
				g_ShaXing_BossChoice_RandomCheckPointTxt[index]:SetText(string.format("#c8c8c8c+%s分",tostring(g_SXRandomImg[nCurRandomIdx].nPoint)));
			end
		end		
		g_ShaXing_BossChoice_RandomCheckGrey[index]:Hide()
	end
	
	--重新计算积分
	ShaXing_BossChoice_Point()
	--动画重置
	KillTimer("ShaXing_BossChoice_CloseWindow()")
	this:Show()
end

--=========================================================
--boss模式选择选择
--=========================================================
function ShaXing_BossChoiceModel_ModeClicked(nIndex)
	--参数校验
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

	--展示图片和积分
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
	
	--boss状态更新为不选
	for index=1,table.getn(g_ShaXing_BossChoice_BossCheckBtn)  do
		g_SXBossCheck[index] = 0
		g_ShaXing_BossChoice_BossCheckBtn[index]:SetCheck(0)
		g_ShaXing_BossChoice_BossCheckGrey[index]:Hide()
		g_ShaXing_BossChoice_BossCheckTxt[index]:SetText(g_SXBossBuff[index].nDisableTips);
	end
	
	--重新计算积分
	ShaXing_BossChoice_Point()
end

--=========================================================
--boss属性选择
--=========================================================
function ShaXing_BossChoice_BossClicked(nIndex)
	--PushDebugMessage("test ShaXing_BossChoice_BossClicked  index="..nIndex)
	if nIndex < 1 or nIndex > 4 then
		return
	end

	--按钮状态选择
	local  mCurBossCheck = g_SXBossCheck[nIndex]
	if mCurBossCheck == 1 then
		g_SXBossCheck[nIndex] = 0
		g_ShaXing_BossChoice_BossCheckTxt[nIndex]:SetText(g_SXBossBuff[nIndex].nDisableTips);
	else
		g_SXBossCheck[nIndex] = 1
		g_ShaXing_BossChoice_BossCheckTxt[nIndex]:SetText(g_SXBossBuff[nIndex].nEnableTips);
	end
	
	--重新计算积分
	ShaXing_BossChoice_Point()
end


--=========================================================
--场地元素选择
--=========================================================
function ShaXing_BossChoice_RandomClicked(nIndex)
	if nIndex < 1 or nIndex > 4 then
		return
	end
	--按钮状态选择
	local  mCurRandomCheck = g_SXRandomCheck[nIndex]
	local nCurRandomIdx = g_SXRandomIdxList[nIndex]
	if mCurRandomCheck == 1 then
		g_SXRandomCheck[nIndex] = 0
		g_ShaXing_BossChoice_RandomCheckPointTxt[nIndex]:SetText(string.format("+%s分",tostring(g_SXRandomImg[nCurRandomIdx].nPoint)));
		
	else
		g_SXRandomCheck[nIndex] = 1
		g_ShaXing_BossChoice_RandomCheckPointTxt[nIndex]:SetText(string.format("#G+%s分",tostring(g_SXRandomImg[nCurRandomIdx].nPoint)));	
	end
	
	--重新计算积分
	ShaXing_BossChoice_Point()
end


--=========================================================
--场地元素说明
--=========================================================
function ShaXing_BossChoice_RandomTips(nIndex)
	if nIndex < 1 or nIndex > 4 then
		return
	end
	
	--PushDebugMessage("test ShaXing_BossChoice_RandomTips")
end

--=========================================================
--分页点击
--=========================================================
function ShaXing_BossChoice_FenyeClicked(nIdex)
	--分页
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
--boss积分计算
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
	-- PushDebugMessage("test 积分 all="..nBasePoint*modeUp.."  modeUp="..modeUp.." nBasePoint"..nBasePoint)
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
--放弃本关
--=========================================================
function ShaXing_BossChoice_GiveUp()
	--弹个二次确认
	PushEvent("UI_COMMAND",20221123,g_ShaXing_targetId,g_ShaXing_FenyeIdx)
end

--=========================================================
--boss选择确认
--=========================================================
function ShaXing_BossChoice_Confirm()
	--按钮状态选择
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
--预告界面
--nBossIdx boss索引
--nRandomList本期场地元素列表 需要拆分
--=========================================================
function ShaXing_BossChoice_JustShow(nSelectIdx,nBossIdx,nBossMode,nBossChoiceList,nRandomList,nRandomChoiceList,nBossAbandonList)
	if nSelectIdx < 1 or nSelectIdx > 4 then
		return
	end
	--动画重置
	KillTimer("ShaXing_BossChoice_CloseWindow()")
	-- PushDebugMessage("test JustShow nSelectIdx="..nSelectIdx.." nBossIdx="..nBossIdx.." nBossMode="..nBossMode.." nBossChoiceList="..nBossChoiceList.." nRandomList="..nRandomList.." nRandomChoiceList="..nRandomChoiceList.." nBossAbandonList="..nBossAbandonList)
	--设置参数
	g_ShaXing_FenyeIdx = nSelectIdx
	g_ShaXing_FenyeBossIdx = nBossIdx
	--PushDebugMessage("test  ShaXing_BossChoice_OpenFenye g_ShaXing_FenyeBossIdx="..g_ShaXing_FenyeBossIdx )
	--选中当前boss分页 不可选
	for index=1,table.getn(g_ShaXing_BossChoice_Fenye)  do
		if index == g_ShaXing_FenyeIdx then
			g_ShaXing_BossChoice_Fenye[index]:SetCheck(1);
		else
			g_ShaXing_BossChoice_Fenye[index]:SetCheck(0);
		end
		g_ShaXing_BossChoice_Fenye[index]:Disable();
	end
	
	--确认键不可点
	ShaXing_BossChoice_ActionFrame:Hide()
	ShaXing_BossChoice_ActionFrame2:Hide()
	--难度不可选
	for index=1,table.getn(g_ShaXing_BossChoice_BossModeList)  do
		g_ShaXing_BossChoice_BossModeList[index]:Disable();
	end
	--属性不可选
	for index=1,table.getn(g_ShaXing_BossChoice_BossCheckBtn)  do
		g_ShaXing_BossChoice_BossCheckBtn[index]:Disable();
	end
	--场地元素不可选
	for index=1,table.getn(g_ShaXing_BossChoice_RandomShowBtn)  do	
		g_ShaXing_BossChoice_RandomShowBtn[index]:Disable();
	end
	
	--boss放弃情况
	--PushDebugMessage("test JustShow nBossAbandonList="..nBossAbandonList.." nSelectIdx="..nSelectIdx)
	g_SXBossAbandon[1] = math.mod(nBossAbandonList,10)
	g_SXBossAbandon[2] = math.mod(math.floor(nBossAbandonList/10),10)  
	g_SXBossAbandon[3] = math.mod(math.floor(nBossAbandonList/100),10)  
	g_SXBossAbandon[4] = math.mod(math.floor(nBossAbandonList/1000),10) 
	
	--是否通关标记
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
	
	--展示boss难度
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
	
	--boss加成选择
	--PushDebugMessage("test  nBossChoiceList="..nBossChoiceList)
	local g_BossChoiceList = {0,0,0,0}
	g_BossChoiceList[1] = math.mod(nBossChoiceList,10)
	g_BossChoiceList[2] = math.mod(math.floor(nBossChoiceList/10),10)  
	g_BossChoiceList[3] = math.mod(math.floor(nBossChoiceList/100),10)--这个服务器用的 12
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
	
	--场地元素信息
	-- PushDebugMessage("test JustShow nRandomList="..nRandomList)
	g_SXRandomIdxList[1] = math.mod(nRandomList,10)
	g_SXRandomIdxList[2] = math.mod(math.floor(nRandomList/10),10)  
	g_SXRandomIdxList[3] = math.mod(math.floor(nRandomList/100),10)  
	g_SXRandomIdxList[4] = math.mod(math.floor(nRandomList/1000),10) 
	--初始化场地元素显示图标
	for index=1,table.getn(g_ShaXing_BossChoice_RandomShowBtn)  do	
		local nCurRandomIdx = g_SXRandomIdxList[index]
		if nCurRandomIdx > 0 and nCurRandomIdx <= 5 then
			g_ShaXing_BossChoice_RandomShowImg[index]:SetProperty("Image",g_SXRandomImg[nCurRandomIdx].nImg);
			g_ShaXing_BossChoice_RandomShowBtn[index]:SetToolTip(GetDictionaryString(g_SXRandomImg[nCurRandomIdx].Tooltip));
		end
		g_ShaXing_BossChoice_RandomCheckPointTxt[index]:SetText(string.format("+%s分",tostring(g_SXRandomImg[nCurRandomIdx].nPoint)));
		g_ShaXing_BossChoice_RandomCheckNameTxt[index]:SetText(g_SXRandomImg[nCurRandomIdx].nName);
	end
	--场地元素选择
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
			g_ShaXing_BossChoice_RandomCheckPointTxt[index]:SetText(string.format("#G+%s分",tostring(g_SXRandomImg[nCurRandomIdx].nPoint)));
		else
			g_SXRandomCheck[index] = 0
			g_ShaXing_BossChoice_RandomShowBtn[index]:SetCheck(0);
			g_ShaXing_BossChoice_RandomCheckGrey[index]:Show()
			g_ShaXing_BossChoice_RandomCheckPointTxt[index]:SetText(string.format("#c8c8c8c+%s分",tostring(g_SXRandomImg[nCurRandomIdx].nPoint)));
		end
	end
	
	--重新计算积分
	ShaXing_BossChoice_Point()
	--显示
	ShaXing_BossChoice_ActionFrame:Hide()
	ShaXing_BossChoice_ActionFrame2:Show()

	--倒计时
	SetTimer("ShaXing_BossChoice","ShaXing_BossChoice_CloseWindow()", 1000);		--设置定时器5秒钟倒计时
	g_ShaXing_CloseTick = 5
	ShaXing_BossChoice_ActionFrame2_Text:SetText(string.format("#W队长已选择完毕，杀星将在#G%s#W秒后出现。",g_ShaXing_CloseTick));

	this:Show()
end


--================================================
-- 倒计时界面
--================================================
function ShaXing_BossChoice_CloseWindow()
	KillTimer("ShaXing_BossChoice_CloseWindow()")
	g_ShaXing_CloseTick = g_ShaXing_CloseTick - 1
	ShaXing_BossChoice_ActionFrame2_Text:SetText(string.format("#W队长已选择完毕，杀星将在#G%s#W秒后出现。",g_ShaXing_CloseTick));
	--PushDebugMessage("test  ShaXing_BossChoice_CloseWindow  g_ShaXing_CloseTick="..g_ShaXing_CloseTick)
	if g_ShaXing_CloseTick > 0 then
		SetTimer("ShaXing_BossChoice","ShaXing_BossChoice_CloseWindow()", 1000)
	else
		--关闭界面
		ShaXing_BossChoice_OnClose()
	end
end


--=========================================================
--各种说明
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

