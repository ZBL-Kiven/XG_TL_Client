--******************************************
--新杀星副本	玩家积分界面
--create by  limengyue 
--2022-07-29
--******************************************

local g_ShaXingDaojishi_Frame_UnifiedXPosition;
local g_ShaXingDaojishi_Frame_UnifiedYPosition;
local g_ShaXingDaojishi_nGetInfo = ""
--积分MD值
local g_ShaXingDaojishi_MD = 470
local g_ShaXingDaojishi_SelectBossIdx = -1	--当前boss索引
--备注看的  并无引用
local g_ShaXingDaojishi_BossIdxList = 
{
	[1] = {nName="宋姜"},
	[2] = {nName="卢君逸"},
	[3] = {nName="李魁"},
	[4] = {nName="鲁志生"},
	[5] = {nName="关盛"},
	[6] = {nName="吴永"},
	[7] = {nName="公孙圣"},
}
local g_ShaXingDaojishi_RandomList = 
{
	[1] = {nwarning="持续陷阱",nName="#{XSX_220705_262}"},
	[2] = {nwarning="加血圈",nName="#{XSX_220705_263}"},
	[3] = {nwarning="减治疗",nName="#{XSX_220705_264}"},
	[4] = {nwarning="吸蓝",nName="#{XSX_220705_265}"},
	[5] = {nwarning="眩晕",nName="#{XSX_220705_266}"},
}


--=========================================================
--PreLoad
--=========================================================
function ShaXingDaojishi_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("XINSHAXING_MINI");
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
function ShaXingDaojishi_OnLoad()
	g_ShaXingDaojishi_Frame_UnifiedXPosition	= ShaXingDaojishi : GetProperty("UnifiedXPosition");
	g_ShaXingDaojishi_Frame_UnifiedYPosition	= ShaXingDaojishi : GetProperty("UnifiedYPosition");
end

--=========================================================
--恢复界面的默认相对位置
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
		--当前累计积分
		local nMDPoint = DataPool:GetPlayerMission_DataRound(g_ShaXingDaojishi_MD)
		ShaXingDaojishi_Score:SetText(string.format("#cfff263当前累计因果：#G%s",tostring(nMDPoint)));		
	end
	-- 窗口变化
	if (event == "XINSHAXING_MINI" ) then
		if arg0=="1" then
			ShaXingDaojishi_Mini_Show(tonumber(arg1))
		end
	end
	if (event=="PLAYER_LEAVE_WORLD") then
		if( this:IsVisible() ) then
			this:Hide()
		end
	-- 游戏窗口尺寸发生了变化
	elseif (event == "ADJEST_UI_POS" ) then
		ShaXingDaojishi_On_ResetPos();
	-- 游戏分辨率发生了变化
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
--打开界面
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
	--关卡信息
	local nGuanqia = "一"
	if nSelectBossIdx == 2 then
		nGuanqia = "二"
	elseif nSelectBossIdx == 3 then
		nGuanqia = "三"
	elseif nSelectBossIdx == 4 then
		nGuanqia = "四"
	end
	ShaXingDaojishi_DragTitle:SetText(string.format("#gFF0FA0关卡%s",nGuanqia));
	
	--当前累计积分
	local nMDPoint = DataPool:GetPlayerMission_DataRound(g_ShaXingDaojishi_MD)
	ShaXingDaojishi_Score:SetText(string.format("#cfff263当前累计因果：#G%s",tostring(nMDPoint)));
	--目标
	ShaXingDaojishi_Text:SetText(string.format("#cfff263击杀boss%s",g_ShaXingDaojishi_BossIdxList[nBossIdx].nName));
	--通关奖励
	ShaXingDaojishi_Text2:SetText(string.format("#cfff263因果值+#G%s#cfff263点",tostring(nPoint)));
	--场地信息
	local g_ShaXing_RandomIdxList={1,2,3,4}
	g_ShaXing_RandomIdxList[1] = math.mod(nRandomList,10)
	g_ShaXing_RandomIdxList[2] = math.mod(math.floor(nRandomList/10),10) 
	g_ShaXing_RandomIdxList[3] = math.mod(math.floor(nRandomList/100),10)   
	g_ShaXing_RandomIdxList[4] = math.mod(math.floor(nRandomList/1000),10) 
	-- PushDebugMessage("test：nRandomList  "..nRandomList)
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
	--名字为空时候显示暂无
	if nRandomMSg == "" then
		nRandomMSg = "#{XSX_220705_281}"
	end
	
	ShaXingDaojishi_Text4:SetText(nRandomMSg);
	this:Show()
end
--=========================================================
--关闭界面
--=========================================================
function ShaXingDaojishi_Close()

end
--=========================================================
--切换到mini
--=========================================================
function ShaXingDaojishi_OpenMini()

	this:Hide()
	PushEvent("UI_COMMAND",20221207,0,g_ShaXingDaojishi_SelectBossIdx,g_ShaXingDaojishi_nGetInfo)
end