--!!!reloadscript =FeelFeedBack
local g_FeelFeedBack_Frame_UnifiedPosition;

local g_FeelFeedBack_7DayShowTimes =0;
local g_FeelFeedBack_7DayButtom ={};
local g_FeelFeedBack_MD_Date = 0
local g_FeelFeedBack_MF_Date = 0
local g_FeelFeedBack_MD_LastDay = 0

local g_FeelFeedBack_PrizeList =
{
		[1] ={
				[1]={ItemID = 39920028, num = 1, needbind =0,}, --雪羽霜衣礼包//新增
				[2]={ItemID = 30008027, num = 3, needbind =0,}, --天灵丹
				[3]={ItemID = 39920019, num = 1, needbind =0,}, --100绑元
				},
	[2] ={
				[1]={ItemID = 39920012, num = 1, needbind =0,},--红宝石(3级)
				[2]={ItemID = 39920018, num = 1, needbind =0,},--3级秘银
				[3]={ItemID = 39920019, num = 1, needbind =0,},--100绑元
				},
	[3] ={
				[1]={ItemID = 39920029, num = 1, needbind =0,},--感恩回馈坐骑礼包//新增
				[2]={ItemID = 39920017, num = 1, needbind =0,},--3级棉布
				[3]={ItemID = 39920019, num = 1, needbind =0,},--100绑元
				},
	[4] ={
				[1]={ItemID = 39920014, num = 1, needbind =0,},--天罡强化露
				[2]={ItemID = 39920022, num = 1, needbind =0,},--金刚锉
				[3]={ItemID = 39920019, num = 1, needbind =0,},--100绑元
				},
	[5] ={
				[1]={ItemID = 39920016, num = 25, needbind =0,},--金蚕丝
				[2]={ItemID = 39920031, num = 5, needbind =0,},--千淬神玉
				[3]={ItemID = 39920019, num = 1, needbind =0,},--100绑元
				},
	[6] ={
				[1]={ItemID = 39920015, num = 5, needbind =0,},--回天神石
				[2]={ItemID = 39920018, num = 1, needbind =0,},--3级秘银
				[3]={ItemID = 39920019, num = 1, needbind =0,},--100绑元
				},
	[7] ={
				[1]={ItemID = 39920012, num = 1, needbind =0,},--红宝石(3级)
				[2]={ItemID = 39920017, num = 1, needbind =0,},--3级棉布
				[3]={ItemID = 39920019, num = 1, needbind =0,},--100绑元
				},
};
local g_FeelFeedBack_PrizeButton = {}
local g_FeelFeedBack_Click = -1

local g_FeelFeedBack_7DayImage = {
	[1] ={
				[1]="set:Thanks5 image:Thanks_ShiZhuang2",								--FeelFeedBack_Left_image
				[2]="set:Thanks1 image:Thanks_1",												--FeelFeedBack_Right_imageDay
				[3]="set:Thanks2 image:Thanks_ShiZhuang",					--FeelFeedBack_Right_imageDayItem
				[4]="set:Seven image:Seven_day2",
				},
	[2] ={
				[1]="set:Thanks3 image:Thanks_HongBaoShi",
				[2]="set:Thanks1 image:Thanks_2",
				[3]="set:Thanks2 image:Thanks_BaoShi",
				[4]="set:Seven image:Seven_day2",				
				},
	[3] ={
				[1]="set:Thanks4 image:Thanks_MuMa",
				[2]="set:Thanks1 image:Thanks_3",
				[3]="set:Thanks2 image:Thanks_ZuoJi",
				[4]="set:Seven image:Seven_day3",				
				},
	[4] ={
				[1]="set:Thanks5 image:Thanks_QiangHua2",
				[2]="set:Thanks1 image:Thanks_4",
				[3]="set:Thanks2 image:Thanks_QiangHua",
				[4]="set:Seven image:Seven_day4",				
				},
	[5] ={
				[1]="set:Thanks3 image:Thanks_JinCangSi",
				[2]="set:Thanks1 image:Thanks_5",
				[3]="set:Thanks2 image:Thanks_DiaoWen",
				[4]="set:Seven image:Seven_day5",				
				},
	[6] ={
				[1]="set:Thanks4 image:Thanks_MiYin",
				[2]="set:Thanks1 image:Thanks_6",
				[3]="set:Thanks2 image:Thanks_ShouGong",
				[4]="set:Seven image:Seven_day6",				
				},
	[7] ={
				[1]="set:Thanks3 image:Thanks_HongBaoShi",
				[2]="set:Thanks1 image:Thanks_7",
				[3]="set:Thanks2 image:Thanks_BaoShi",
				[4]="set:Seven image:Seven_day7",				
				},	
};

--===============================================
-- PreLoad()
--===============================================
function FeelFeedBack_PreLoad()
	this:RegisterEvent("UI_COMMAND",true)
	this:RegisterEvent("PLAYER_LEAVE_WORLD")		-- 离开场景
	this:RegisterEvent("ADJEST_UI_POS",false)			-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)	        -- 游戏分辨率发生了变化
--	this:RegisterEvent("PLAYER_ENTERING_WORLD",true)		-- 进入游戏世界
end

--===============================================
-- OnEvent()
--===============================================
function FeelFeedBack_OnEvent(event)
	if (event == "PLAYER_LEAVE_WORLD") then
		FeelFeedBack_Close()
	elseif (event == "ADJEST_UI_POS") then
		FeelFeedBack_On_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		FeelFeedBack_On_ResetPos()
--	elseif (event == "PLAYER_ENTERING_WORLD" ) then				-- 【新服欢乐月·升级送好礼&首冲超值赠】重新加载物品奖励
--		g_FeelFeedBack_ShouChong_LoadFirstTime =1;
--		FeelFeedBack_SheJiaoNew_Request()
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 88990602 ) then
		local bShow =  Get_XParam_INT( 0 );
		if bShow == 1 then
			g_FeelFeedBack_MD_Date =  Get_XParam_INT( 1 );
			g_FeelFeedBack_MF_Date =  Get_XParam_INT( 2 );
			g_FeelFeedBack_MD_LastDay = Get_XParam_INT( 3 );
			FeelFeedBack_7Day_Update()
			local nMDLast = math.mod(g_FeelFeedBack_MD_LastDay,10000)
			local nMDMonth = math.floor(nMDLast/100)
			local nMDMDay = math.mod(nMDLast,100)
--			PushDebugMessage(g_FeelFeedBack_MD_LastDay.." "..nMDMonth.." "..nMDMDay)
			FeelFeedBack_Text2:SetText( ScriptGlobal_Format("#{MYGEHK_20110_53}",nMDMonth,nMDMDay) )
			this:Show()
		elseif this:IsVisible() then
			g_FeelFeedBack_MD_Date =  Get_XParam_INT( 1 );
			g_FeelFeedBack_MF_Date =  Get_XParam_INT( 2 );
			FeelFeedBack_7Day_Update()
		end	
	end
end

--===============================================
-- OnLoad()
--===============================================
function FeelFeedBack_OnLoad()
	g_FeelFeedBack_Frame_UnifiedPosition = FeelFeedBack_Frame:GetProperty("UnifiedPosition")

	g_FeelFeedBack_7DayButtom[1] ={Button =FeelFeedBack_Top_day1_Button1 , Done = FeelFeedBack_Top_day1_done };
	g_FeelFeedBack_7DayButtom[2] ={Button =FeelFeedBack_Top_day2_Button1 , Done = FeelFeedBack_Top_day2_done };
	g_FeelFeedBack_7DayButtom[3] ={Button =FeelFeedBack_Top_day3_Button1 , Done = FeelFeedBack_Top_day3_done };
	g_FeelFeedBack_7DayButtom[4] ={Button =FeelFeedBack_Top_day4_Button1 , Done = FeelFeedBack_Top_day4_done };
	g_FeelFeedBack_7DayButtom[5] ={Button =FeelFeedBack_Top_day5_Button1 , Done = FeelFeedBack_Top_day5_done };
	g_FeelFeedBack_7DayButtom[6] ={Button =FeelFeedBack_Top_day6_Button1 , Done = FeelFeedBack_Top_day6_done };
	g_FeelFeedBack_7DayButtom[7] ={Button =FeelFeedBack_Top_day7_Button1 , Done = FeelFeedBack_Top_day7_done };

	g_FeelFeedBack_PrizeButton[1] = FeelFeedBack_Right_ShowA;
	g_FeelFeedBack_PrizeButton[2] = FeelFeedBack_Right_ShowB;
	g_FeelFeedBack_PrizeButton[3] = FeelFeedBack_Right_ShowC;
end

--===============================================
-- Hide()
--===============================================
function FeelFeedBack_Hide() 
	FeelFeedBack_Close()
end

--===============================================
-- Close()
--===============================================
function FeelFeedBack_Close()
	g_FeelFeedBack_Click = -1
	for i=1,3 do
		g_FeelFeedBack_PrizeButton[i]:SetActionItem( -1 );
	end
	this:Hide()
end
--===============================================
-- ResetPos()
--===============================================
function FeelFeedBack_On_ResetPos()
	FeelFeedBack_Frame:SetProperty("UnifiedPosition", g_FeelFeedBack_Frame_UnifiedPosition)
end


--===============================================
-- 满月感恩回馈-begin
--===============================================
function FeelFeedBack_7Day_Update()
	for i=1,7 do
		g_FeelFeedBack_7DayButtom[i].Done:Hide()
	end
	local nData1 = g_FeelFeedBack_MD_Date
	local nData2 = g_FeelFeedBack_MF_Date
	--为了防止10版本优化MD和MF的同步，从server端同步MD
	local nTimes = math.mod(nData1,100)
	for i=1,nTimes do
		g_FeelFeedBack_7DayButtom[i].Done:Hide()
	end

	local nDate = 1
	for i=1,nTimes do
		if math.mod(nData2,10) == 1 then
			g_FeelFeedBack_7DayButtom[i].Done:Show()
		end
		nData2 = math.floor(nData2/10)
	end

	if g_FeelFeedBack_Click == -1 then
		FeelFeedBack_Click(nTimes)
	else
		FeelFeedBack_Click(g_FeelFeedBack_Click)
	end
	
end

function FeelFeedBack_Click(nIndex)

	if nIndex<1 or nIndex>7 then
		return
	end


	FeelFeedBack_Left_image:SetProperty( "Image", g_FeelFeedBack_7DayImage[nIndex][1] )
	FeelFeedBack_Right_imageDay:SetProperty( "Image", g_FeelFeedBack_7DayImage[nIndex][2] )
	FeelFeedBack_Right_imageDayItem:SetProperty( "Image", g_FeelFeedBack_7DayImage[nIndex][3] )

	for i=1, 7 do
		g_FeelFeedBack_7DayButtom[i].Button:SetCheck(0)
	end

	g_FeelFeedBack_Click = nIndex

	--显示一下奖励
	for i=1, 3 do
		g_FeelFeedBack_PrizeButton[i]:SetActionItem( -1 );
	end

	local nCount = table.getn(g_FeelFeedBack_PrizeList[nIndex])
	for i=1,nCount do
		local theAction = DataPool:CreateActionItemForShow(g_FeelFeedBack_PrizeList[nIndex][i].ItemID, g_FeelFeedBack_PrizeList[nIndex][i].num)
		if theAction:GetID() ~= 0 then
			g_FeelFeedBack_PrizeButton[i]:SetActionItem( theAction:GetID() );
		else
			g_FeelFeedBack_PrizeButton[i]:SetActionItem( -1 );
		end
	end

	g_FeelFeedBack_7DayButtom[nIndex].Button:SetCheck(1)


	--看一下这页是不是可以打开
	local nData1 = g_FeelFeedBack_MD_Date
	local nTimes = math.mod(nData1,100)

	if nIndex > nTimes then
		--第X日可领取
		FeelFeedBack_Right_Button1:Disable()
		FeelFeedBack_Right_Button1:SetProperty("DisabledImage",g_FeelFeedBack_7DayImage[nIndex][4])
	else
		--看是不是已经领取了
		local nData2 = g_FeelFeedBack_MF_Date
		local nBase = 1
		for i=1,nIndex-1 do
			nBase = nBase * 10
		end

		local nFlag = math.mod(math.floor(nData2/nBase),10)
		if nFlag == 0 then
		--未领取
			FeelFeedBack_Right_Button1:Enable()
		elseif nFlag == 1 then
		--已领取
			FeelFeedBack_Right_Button1:Disable()
			FeelFeedBack_Right_Button1: SetProperty("DisabledImage","set:Seven image:Seven_lingquDis")
		end
	end

end

function FeelFeedBack_GetPrize()
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("GetMYGEHKPrize");
			Set_XSCRIPT_ScriptID(889906);
			Set_XSCRIPT_Parameter(0,g_FeelFeedBack_Click)
			Set_XSCRIPT_ParamCount(1);
		Send_XSCRIPT();
end

