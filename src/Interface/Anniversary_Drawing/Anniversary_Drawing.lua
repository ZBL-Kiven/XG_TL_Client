--Anniversary_Drawing.lua
--领取奖励

local g_Anniversary_DrawingNpcId = -1;
local g_Anniversary_Drawing_targetId = -1;
local g_Anniversary_DrawingConfirm1 = 0
local g_Anniversary_DrawingConfirm2 = 0
local g_Anniversary_DrawingHavePrize = {0, 0, 0, 0};

local g_Anniversary_Drawing_HuaJuanImg={}

local g_Anniversary_Drawing_Button={}

local g_Anniversary_Drawing_Button_PushedImage={
"set:Anniversary01 image:AnniversaryBtn1Push",
"set:Anniversary01 image:AnniversaryBtn2Push",
"set:Anniversary01 image:AnniversaryBtn3Push",
"set:Anniversary02 image:AnniversaryBtn4Push",
}

local g_Anniversary_Drawing_Button_NormalImage={
"set:Anniversary01 image:AnniversaryBtn1Normal",
"set:Anniversary01 image:AnniversaryBtn2Normal",
"set:Anniversary01 image:AnniversaryBtn3Normal",
"set:Anniversary02 image:AnniversaryBtn4Normal",
}

local g_Anniversary_Drawing_Button_HoverImage={
"set:Anniversary01 image:AnniversaryBtn1Hover",
"set:Anniversary01 image:AnniversaryBtn2Hover",
"set:Anniversary01 image:AnniversaryBtn3Hover",
"set:Anniversary02 image:AnniversaryBtn4Hover",
}
local Anniversary_Drawing_GiftBtntips={}

local g_Anniversary_Drawing_ZNQDK_Mount_Stage =0
local g_Anniversary_Drawing_ZNQDK_Bouns_Stage =0


local g_Anniversary_Drawing_StageDes_List ={}
local g_Anniversary_Drawing_StageIamge_List={"set:Anniversary01 image:Anniversary_HuiXing","set:Anniversary01 image:Anniversary_XieYi","set:Anniversary01 image:Anniversary_ChuanShen","set:Anniversary01 image:Anniversary_SuQing"}

function Anniversary_Drawing_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OBJECT_CARED_EVENT");
end

function Anniversary_Drawing_OnLoad()
	g_Anniversary_DrawingConfirm1 = 0;
	g_Anniversary_DrawingConfirm2 = 0;

	g_Anniversary_Drawing_HuaJuanImg[1] = {}
	g_Anniversary_Drawing_HuaJuanImg[1][1] =Anniversary_Drawing_Theme1Image1
	g_Anniversary_Drawing_HuaJuanImg[1][2] =Anniversary_Drawing_Theme1Image2
	g_Anniversary_Drawing_HuaJuanImg[1][3] =Anniversary_Drawing_Theme1Image3
	g_Anniversary_Drawing_HuaJuanImg[1][4] =Anniversary_Drawing_Theme1Image4
--	g_Anniversary_Drawing_HuaJuanImg[1][5] =Anniversary_Drawing_Theme1Show

	g_Anniversary_Drawing_HuaJuanImg[2] = {}
	g_Anniversary_Drawing_HuaJuanImg[2][1] =Anniversary_Drawing_Theme2Image1
	g_Anniversary_Drawing_HuaJuanImg[2][2] =Anniversary_Drawing_Theme2Image2
	g_Anniversary_Drawing_HuaJuanImg[2][3] =Anniversary_Drawing_Theme2Image3
	g_Anniversary_Drawing_HuaJuanImg[2][4] =Anniversary_Drawing_Theme2Image4
--	g_Anniversary_Drawing_HuaJuanImg[2][5] =Anniversary_Drawing_Theme2Show

	g_Anniversary_Drawing_HuaJuanImg[3] = {}
	g_Anniversary_Drawing_HuaJuanImg[3][1] =Anniversary_Drawing_Theme3Image1
	g_Anniversary_Drawing_HuaJuanImg[3][2] =Anniversary_Drawing_Theme3Image2
	g_Anniversary_Drawing_HuaJuanImg[3][3] =Anniversary_Drawing_Theme3Image3
	g_Anniversary_Drawing_HuaJuanImg[3][4] =Anniversary_Drawing_Theme3Image4
--	g_Anniversary_Drawing_HuaJuanImg[3][5] =Anniversary_Drawing_Theme3Show

	g_Anniversary_Drawing_HuaJuanImg[4] = {}
	g_Anniversary_Drawing_HuaJuanImg[4][1] =Anniversary_Drawing_Theme4Image1
	g_Anniversary_Drawing_HuaJuanImg[4][2] =Anniversary_Drawing_Theme4Image2
	g_Anniversary_Drawing_HuaJuanImg[4][3] =Anniversary_Drawing_Theme4Image3
	g_Anniversary_Drawing_HuaJuanImg[4][4] =Anniversary_Drawing_Theme4Image4
--	g_Anniversary_Drawing_HuaJuanImg[4][5] =Anniversary_Drawing_Theme4Show

	g_Anniversary_Drawing_HuaJuanImg[5] = {}
	g_Anniversary_Drawing_HuaJuanImg[5][1] =Anniversary_Drawing_Theme5Image1
	g_Anniversary_Drawing_HuaJuanImg[5][2] =Anniversary_Drawing_Theme5Image2
	g_Anniversary_Drawing_HuaJuanImg[5][3] =Anniversary_Drawing_Theme5Image3
	g_Anniversary_Drawing_HuaJuanImg[5][4] =Anniversary_Drawing_Theme5Image4
--	g_Anniversary_Drawing_HuaJuanImg[5][5] =Anniversary_Drawing_Theme5Show

	g_Anniversary_Drawing_HuaJuanImg[6] = {}
	g_Anniversary_Drawing_HuaJuanImg[6][1] =Anniversary_Drawing_Theme6Image1
	g_Anniversary_Drawing_HuaJuanImg[6][2] =Anniversary_Drawing_Theme6Image2
	g_Anniversary_Drawing_HuaJuanImg[6][3] =Anniversary_Drawing_Theme6Image3
	g_Anniversary_Drawing_HuaJuanImg[6][4] =Anniversary_Drawing_Theme6Image4
--	g_Anniversary_Drawing_HuaJuanImg[6][5] =Anniversary_Drawing_Theme6Show

	g_Anniversary_Drawing_Button[1] = Anniversary_Drawing_Gift1Btn
	g_Anniversary_Drawing_Button[2] = Anniversary_Drawing_Gift2Btn
	g_Anniversary_Drawing_Button[3] = Anniversary_Drawing_Gift3Btn
	g_Anniversary_Drawing_Button[4] = Anniversary_Drawing_Gift4Btn

	g_Anniversary_Drawing_ButtonOK[1] = Anniversary_Drawing_Gift1BtnOK
	g_Anniversary_Drawing_ButtonOK[2] = Anniversary_Drawing_Gift2BtnOK
	g_Anniversary_Drawing_ButtonOK[3] = Anniversary_Drawing_Gift3BtnOK
	g_Anniversary_Drawing_ButtonOK[4] = Anniversary_Drawing_Gift4BtnOK

	g_Anniversary_Drawing_StageDes_List[1] =Anniversary_Drawing_Theme1TitleBK
	g_Anniversary_Drawing_StageDes_List[2] =Anniversary_Drawing_Theme2TitleBK
	g_Anniversary_Drawing_StageDes_List[3] =Anniversary_Drawing_Theme3TitleBK
	g_Anniversary_Drawing_StageDes_List[4] =Anniversary_Drawing_Theme4TitleBK
	g_Anniversary_Drawing_StageDes_List[5] =Anniversary_Drawing_Theme5TitleBK
	g_Anniversary_Drawing_StageDes_List[6] =Anniversary_Drawing_Theme6TitleBK

	Anniversary_Drawing_GiftBtntips[1] = Anniversary_Drawing_Gift1Btntips
	Anniversary_Drawing_GiftBtntips[2] = Anniversary_Drawing_Gift2Btntips
	Anniversary_Drawing_GiftBtntips[3] = Anniversary_Drawing_Gift3Btntips
	Anniversary_Drawing_GiftBtntips[4] = Anniversary_Drawing_Gift4Btntips

end

function Anniversary_Drawing_OnEvent(event)

	if ( event == "UI_COMMAND" and tonumber(arg0) == 891180 ) then

		g_Anniversary_Drawing_ZNQDK_Mount_Stage =  Get_XParam_INT(0)
		g_Anniversary_Drawing_ZNQDK_Bouns_Stage =  Get_XParam_INT(1)
		Anniversary_Drawing_Update(g_Anniversary_Drawing_ZNQDK_Mount_Stage,g_Anniversary_Drawing_ZNQDK_Bouns_Stage);
	--	PushDebugMessage("Mount="..g_Anniversary_Drawing_ZNQDK_Mount_Stage);
	--	PushDebugMessage("Boun="..g_Anniversary_Drawing_ZNQDK_Bouns_Stage);
		this:Show()
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 891181 ) then
		if this:IsVisible() then
			g_Anniversary_Drawing_ZNQDK_Mount_Stage =  Get_XParam_INT(0)
			g_Anniversary_Drawing_ZNQDK_Bouns_Stage =  Get_XParam_INT(1)
			Anniversary_Drawing_Update(g_Anniversary_Drawing_ZNQDK_Mount_Stage,g_Anniversary_Drawing_ZNQDK_Bouns_Stage);
		end
	end

end

--刷新界面
function Anniversary_Drawing_Update()

	Anniversary_Drawing_Update_HuaJuan(g_Anniversary_Drawing_ZNQDK_Mount_Stage)
	Anniversary_Drawing_Update_Button(g_Anniversary_Drawing_ZNQDK_Bouns_Stage)
end

--画卷部分刷新
function Anniversary_Drawing_Update_HuaJuan(g_Anniversary_Drawing_ZNQDK_Mount_Stage)


	for i=1,6 do
		local nCurStage = Anniversary_Drawing_GetMount_StageByIndex(g_Anniversary_Drawing_ZNQDK_Mount_Stage,i);
		--nCurStage = 3
		for j=1,4 do
			if nCurStage == j then
				g_Anniversary_Drawing_HuaJuanImg[i][j]:Show()
			else
			--	PushDebugMessage(g_Anniversary_Drawing_HuaJuanImg[i][j])
				g_Anniversary_Drawing_HuaJuanImg[i][j]:Hide()
			end
		end
		if nCurStage == 0 then
			--g_Anniversary_Drawing_StageDes_List[i]:Hide()
			g_Anniversary_Drawing_StageDes_List[i]:SetProperty("Image","")
		else
			--g_Anniversary_Drawing_StageDes_List[i]:Show()
			g_Anniversary_Drawing_StageDes_List[i]:SetProperty("Image",g_Anniversary_Drawing_StageIamge_List[nCurStage])

		end
	end
end

--领奖按钮部分刷新
function Anniversary_Drawing_Update_Button(g_Anniversary_Drawing_ZNQDK_Bouns_Stage)


	local nCompleteStage = Anniversary_Drawing_GetCurBounsStage(g_Anniversary_Drawing_ZNQDK_Mount_Stage)

	for i=1,4 do
		if i > nCompleteStage then
			Anniversary_Drawing_GiftBtntips[i]:Show()
			g_Anniversary_Drawing_Button[i]:Disable()
		else
			Anniversary_Drawing_GiftBtntips[i]:Hide()
			g_Anniversary_Drawing_Button[i]:Enable()
		end
	end

	for i=1,4 do
		local nBounsFlag = Anniversary_Drawing_GetMount_BounsFlagByIndex(g_Anniversary_Drawing_ZNQDK_Bouns_Stage,i)
		if nBounsFlag == 0 then
			--g_Anniversary_Drawing_Button[i]:Enable()
			g_Anniversary_Drawing_ButtonOK[i]:Hide()
			g_Anniversary_Drawing_Button[i]:SetProperty("NormalImage",g_Anniversary_Drawing_Button_NormalImage[i])
			g_Anniversary_Drawing_Button[i]:SetProperty("HoverImage",g_Anniversary_Drawing_Button_HoverImage[i])
		elseif nBounsFlag == 1 then
			--g_Anniversary_Drawing_Button[i]:Disable()
			g_Anniversary_Drawing_ButtonOK[i]:Show()
			g_Anniversary_Drawing_Button[i]:SetProperty("NormalImage",g_Anniversary_Drawing_Button_PushedImage[i])
			g_Anniversary_Drawing_Button[i]:SetProperty("HoverImage",g_Anniversary_Drawing_Button_PushedImage[i])
		end
	end

end

--获取当前的装裱可以领取哪个奖励
function Anniversary_Drawing_GetCurBounsStage(nBounsParam)
	local nCompleteStage =4
	for i=1,6 do
		local nCurStage = Anniversary_Drawing_GetMount_StageByIndex(nBounsParam,i);
	--	nCurStage =3
		if nCurStage < nCompleteStage then
			nCompleteStage = nCurStage
		end
	end
	return nCompleteStage
end

--获取装裱标记
function Anniversary_Drawing_GetMount_StageByIndex(g_Anniversary_Drawing_ZNQDK_Mount_Stage,nIndex)
	local nMountData = g_Anniversary_Drawing_ZNQDK_Mount_Stage;
	local nMountStage = 0
	if nIndex == 1 then
		nMountStage = math.mod(nMountData,10)
	elseif nIndex == 2 then
		local nParam = math.floor(nMountData/10)
		nMountStage = math.mod(nParam,10)
	elseif nIndex == 3 then
		local nParam = math.floor(nMountData/100)
		nMountStage = math.mod(nParam,10)
	elseif nIndex == 4 then
		local nParam = math.floor(nMountData/1000)
		nMountStage = math.mod(nParam,10)
	elseif nIndex == 5 then
		local nParam = math.floor(nMountData/10000)
		nMountStage = math.mod(nParam,10)
	elseif nIndex == 6 then
		local nParam = math.floor(nMountData/100000)
		nMountStage = math.mod(nParam,10)
	end
	return nMountStage
end

--设置装裱标记
function Anniversary_Drawing_SetMount_StageByIndex(nIndex)
end

--获取领奖标记
function Anniversary_Drawing_GetMount_BounsFlagByIndex(g_Anniversary_Drawing_ZNQDK_Bouns_Stage,nIndex)
	local nMountData = g_Anniversary_Drawing_ZNQDK_Bouns_Stage;
	local nMountStage = 0
	if nIndex == 1 then
		nMountStage = math.mod(nMountData,10)
	elseif nIndex == 2 then
		local nParam = math.floor(nMountData/10)
		nMountStage = math.mod(nParam,10)
	elseif nIndex == 3 then
		local nParam = math.floor(nMountData/100)
		nMountStage = math.mod(nParam,10)
	elseif nIndex == 4 then
		local nParam = math.floor(nMountData/1000)
		nMountStage = math.mod(nParam,10)
	end
	return nMountStage
end
--设置领奖标记
function Anniversary_Drawing_SetMount_BounsFlagByIndex(nIndex)
end

--打开画卷（装裱达到阶段4）
function Anniversary_Drawing_OpenHuaJuan(nIndex)

	local nCurStage = Anniversary_Drawing_GetMount_StageByIndex(g_Anniversary_Drawing_ZNQDK_Mount_Stage,nIndex);
	if nCurStage ~= 4 then
		PushDebugMessage("#{ZLDQ_20210713_36}")
	else
		PushEvent("OPEN_ANNIVERSARY_IMAGE", nIndex)
	end
end

--获得奖励
function Anniversary_Drawing_GiftBtn(nIndex)
	--等级
	local level = Player:GetData("LEVEL");
	if level < 30 then
		PushDebugMessage("#{ZLDQ_20210713_08}");
		return;
	end
	--已经领取过
	local ret = Anniversary_Drawing_GetMount_BounsFlagByIndex(g_Anniversary_Drawing_ZNQDK_Bouns_Stage,nIndex)
	if ret == 1 then
		PushDebugMessage("#{ZLDQ_20210713_37}");
		return;
	end
	--是否达成领取当前奖励的条件
--	ret = Anniversary_Drawing_GetCurBounsStage(g_Anniversary_Drawing_ZNQDK_Mount_Stage)
--	if nIndex > ret then
--		PushDebugMessage("#{ZLDQ_20210713_38}");
--		return;
--	end
	-- 执行服务器脚本，请求更新打劫数据
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GetDrawingBouns");
		Set_XSCRIPT_ScriptID(891180);
		Set_XSCRIPT_Parameter(0,nIndex)
		Set_XSCRIPT_ParamCount(1);
	Send_XSCRIPT();

end

function Anniversary_Drawing_OnHiden()
	Anniversary_Drawing_Close()
end

function Anniversary_Drawing_Close()
	this:Hide()
end
