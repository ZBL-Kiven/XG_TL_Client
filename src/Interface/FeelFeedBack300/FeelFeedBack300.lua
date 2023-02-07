--!!!reloadscript =FeelFeedBack300
local g_FeelFeedBack300_Frame_UnifiedPosition;

local g_FeelFeedBack300_7DayShowTimes =0;
local g_FeelFeedBack300_7DayButtom ={};
local g_FeelFeedBack300_MD_Date = 0
local g_FeelFeedBack300_MF_Date = 0
local g_FeelFeedBack300_MD_LastDay = 0

local g_FeelFeedBack300_PrizeList =
{
	[1] ={
			[1]={ItemID = 38002242, num = 1, needbind =1,},		-- 墨染兰香礼包（稀有3选1,15天）	1	38002242
			[2]={ItemID = 30501361, num = 3, needbind =1,},		-- 功力丹	3	30501361//需强绑	　
			[3]={ItemID = 38000060, num = 1, needbind =1,},		-- 100绑定元宝	1	38000060　	　
			},
	[2] ={
			[1]={ItemID = 30900045, num = 1, needbind =1,},		-- 天罡强化露	1	30900045//需强绑
			[2]={ItemID = 30502002, num = 3, needbind =1,},		-- 高级根骨丹	3	30502002//需强绑
			[3]={ItemID = 38000060, num = 1, needbind =1,},		-- 100绑定元宝	1	38000060　	
			},
	[3] ={
			[1]={ItemID = 38002243, num = 1, needbind =1,},		-- 秦月宋光礼包（坐骑4选1）	1	38002161
			[2]={ItemID = 30008114, num = 1, needbind =1,},		-- 黄金马鞍	1	30008114//需强绑
			[3]={ItemID = 38000060, num = 1, needbind =1,},		-- 100绑定元宝	1	38000060	　
			},
	[4] ={
			[1]={ItemID = 30008048, num = 1, needbind =1,},		-- 金刚锉	1	30008048//需强绑
			[2]={ItemID = 30503133, num = 3, needbind =1,},		-- 千淬神玉	3	　	30503133
			[3]={ItemID = 38000060, num = 1, needbind =1,},		-- 100绑定元宝	1	　	38000060　
			},
	[5] ={
			[1]={ItemID = 20310168, num = 20,needbind =1,},		-- 金蚕丝	20	　	20310168　
			[2]={ItemID = 20310116, num = 2, needbind =1,},		-- 灵兽精魄	2	20310116//需强绑
			[3]={ItemID = 38000060, num = 1, needbind =1,},		-- 100绑定元宝	1	　	38000060　
			},
	[6] ={
			[1]={ItemID = 30700241, num = 3, needbind =1,},		-- 回天神石	3	30700241
			[2]={ItemID = 20502003, num = 1, needbind =1,},		-- 3级秘银	1	20502003//需强绑
			[3]={ItemID = 38000060, num = 1, needbind =1,},		-- 100绑定元宝	1	　	38000060
			},
	[7] ={
			[1]={ItemID = 50313004, num = 1, needbind =1,},		-- 红宝石3级	1	50313004//需强绑
			[2]={ItemID = 20501003, num = 1, needbind =1,},		-- 3级棉布	1	20501003//需强绑
			[3]={ItemID = 38000060, num = 1, needbind =1,},		-- 100绑定元宝	1	　	38000060　
			},
};
local g_FeelFeedBack300_PrizeButton = {}
local g_FeelFeedBack300_Click = -1

-- FeelFeedBack300_Left_image	FeelFeedBack300_Right_imageDay	FeelFeedBack300_Right_imageDayItem
-- 1	set:FeelFeedBack03 image:FeelFeedBack_D1Image	set:FeelFeedBack03 image:FeelFeedBack_Number1	set:FeelFeedBack03 image:FeelFeedBack_D1Name
-- 2	set:FeelFeedBack03 image:FeelFeedBack_D2Image	set:FeelFeedBack03 image:FeelFeedBack_Number2	set:FeelFeedBack03 image:FeelFeedBack_D2Name
-- 3	set:FeelFeedBack04 image:FeelFeedBack_D3Image	set:FeelFeedBack04 image:FeelFeedBack_Number3	set:FeelFeedBack04 image:FeelFeedBack_D3Name
-- 4	set:FeelFeedBack04 image:FeelFeedBack_D4Image	set:FeelFeedBack04 image:FeelFeedBack_Number4	set:FeelFeedBack04 image:FeelFeedBack_D4Name
-- 5	set:FeelFeedBack05 image:FeelFeedBack_D5Image	set:FeelFeedBack05 image:FeelFeedBack_Number5	set:FeelFeedBack05 image:FeelFeedBack_D5Name
-- 6	set:FeelFeedBack05 image:FeelFeedBack_D6Image	set:FeelFeedBack05 image:FeelFeedBack_Number6	set:FeelFeedBack05 image:FeelFeedBack_D6Name
-- 7	set:FeelFeedBack06 image:FeelFeedBack_D7Image	set:FeelFeedBack06 image:FeelFeedBack_Number7	set:FeelFeedBack06 image:FeelFeedBack_D7Name

-- 数字	展示图	字
-- 第1天	XunLong_1	XunLong_Qixi	XunLong_Diewu
-- 第2天	XunLong_2	XunLong_ZhuangbeiBK	XunLong_Zhuangbei
-- 第3天	XunLong_3	XunLong_Mingyu	XunLong_Qianli
-- 第4天	XunLong_4	XunLong_QianghuaBK	XunLong_Qianghua
-- 第5天	XunLong_5	XunLong_Jincansi	XunLong_Diaowen
-- 第6天	XunLong_6	XunLong_Miyin	XunLong_Shougong
-- 第7天	XunLong_7	XunLong_Hongjingshi	XunLong_Baoshi

local g_FeelFeedBack300_7DayImage = {
	[1] ={
				[1]="set:KaoGuShou1 image:KaoGuShou_Shizhuang",			--FeelFeedBack300_Left_image
				[2]="set:XunLong1 image:XunLong_1",				--FeelFeedBack300_Right_imageDay
				[3]="set:KaoGuShou1 image:KaoGuShou_Text_Moran",			--FeelFeedBack300_Right_imageDayItem
				[4]="set:Seven image:Seven_day2",
				},
	[2] ={
				[1]="set:KaoGuShou1 image:KaoGuShou_Zhuangbei",
				[2]="set:XunLong1 image:XunLong_2",
				[3]="set:KaoGuShou1 image:KaoGuShou_Text_Zhuangbei",
				[4]="set:Seven image:Seven_day2",				
				},
	[3] ={
				[1]="set:KaoGuShou1 image:KaoGuShou_Qianli",
				[2]="set:XunLong1 image:XunLong_3",
				[3]="set:KaoGuShou1 image:KaoGuShou_Text_Qianli",
				[4]="set:Seven image:Seven_day3",				
				},
	[4] ={
				[1]="set:KaoGuShou1 image:KaoGuShou_Qianghua",
				[2]="set:XunLong1 image:XunLong_4",
				[3]="set:KaoGuShou1 image:KaoGuShou_Text_Qianghua",
				[4]="set:Seven image:Seven_day4",				
				},
	[5] ={
				[1]="set:KaoGuShou1 image:KaoGuShou_Jincansi",
				[2]="set:XunLong1 image:XunLong_5",
				[3]="set:KaoGuShou1 image:KaoGuShou_Text_Diaowen",
				[4]="set:Seven image:Seven_day5",				
				},
	[6] ={
				[1]="set:KaoGuShou1 image:KaoGuShou_Miyin",
				[2]="set:XunLong1 image:XunLong_6",
				[3]="set:KaoGuShou1 image:KaoGuShou_Text_Shougong",
				[4]="set:Seven image:Seven_day6",				
				},
	[7] ={
				[1]="set:KaoGuShou1 image:KaoGuShou_Hongbaoshi",
				[2]="set:XunLong1 image:XunLong_7",
				[3]="set:KaoGuShou1 image:KaoGuShou_Text_Baoshi",
				[4]="set:Seven image:Seven_day7",				
				},	
};

--===============================================
-- PreLoad()
--===============================================
function FeelFeedBack300_PreLoad()
	this:RegisterEvent("UI_COMMAND",true)
	this:RegisterEvent("PLAYER_LEAVE_WORLD")		-- 离开场景
	this:RegisterEvent("ADJEST_UI_POS",false)			-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)	        -- 游戏分辨率发生了变化

end

--===============================================
-- OnEvent()
--===============================================
function FeelFeedBack300_OnEvent(event)
	if (event == "PLAYER_LEAVE_WORLD") then
		FeelFeedBack300_Close()
	elseif (event == "ADJEST_UI_POS") then
		FeelFeedBack300_On_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		FeelFeedBack300_On_ResetPos()
--	elseif (event == "PLAYER_ENTERING_WORLD" ) then				-- 【新服欢乐月·升级送好礼&首冲超值赠】重新加载物品奖励
--		g_FeelFeedBack300_ShouChong_LoadFirstTime =1;
--		FeelFeedBack300_SheJiaoNew_Request()
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 79200002 ) then
		local bShow =  Get_XParam_INT( 0 );
		if bShow == 1 then
			g_FeelFeedBack300_MD_Date =  Get_XParam_INT( 1 );
			g_FeelFeedBack300_MF_Date =  Get_XParam_INT( 2 );
			g_FeelFeedBack300_MD_LastDay = Get_XParam_INT( 3 );
			FeelFeedBack300_7Day_Update()
			local nMDLast = math.mod(g_FeelFeedBack300_MD_LastDay,10000)
			local nMDMonth = math.floor(nMDLast/100)
			local nMDMDay = math.mod(nMDLast,100)
			-- PushDebugMessage(g_FeelFeedBack300_MD_LastDay.." "..nMDMonth.." "..nMDMDay)
			FeelFeedBack300_Text2:SetText( ScriptGlobal_Format("#{XLYXY_210126_53}",nMDMonth,nMDMDay) )
			this:Show()
		elseif this:IsVisible() then
			g_FeelFeedBack300_MD_Date =  Get_XParam_INT( 1 );
			g_FeelFeedBack300_MF_Date =  Get_XParam_INT( 2 );
			FeelFeedBack300_7Day_Update()
		end	
	end
end

--===============================================
-- OnLoad()
--===============================================
function FeelFeedBack300_OnLoad()
	g_FeelFeedBack300_Frame_UnifiedPosition = FeelFeedBack300_Frame:GetProperty("UnifiedPosition")

	g_FeelFeedBack300_7DayButtom[1] ={Button =FeelFeedBack300_Top_day1_Button1 , Done = FeelFeedBack300_Top_day1_done };
	g_FeelFeedBack300_7DayButtom[2] ={Button =FeelFeedBack300_Top_day2_Button1 , Done = FeelFeedBack300_Top_day2_done };
	g_FeelFeedBack300_7DayButtom[3] ={Button =FeelFeedBack300_Top_day3_Button1 , Done = FeelFeedBack300_Top_day3_done };
	g_FeelFeedBack300_7DayButtom[4] ={Button =FeelFeedBack300_Top_day4_Button1 , Done = FeelFeedBack300_Top_day4_done };
	g_FeelFeedBack300_7DayButtom[5] ={Button =FeelFeedBack300_Top_day5_Button1 , Done = FeelFeedBack300_Top_day5_done };
	g_FeelFeedBack300_7DayButtom[6] ={Button =FeelFeedBack300_Top_day6_Button1 , Done = FeelFeedBack300_Top_day6_done };
	g_FeelFeedBack300_7DayButtom[7] ={Button =FeelFeedBack300_Top_day7_Button1 , Done = FeelFeedBack300_Top_day7_done };

	g_FeelFeedBack300_PrizeButton[1] = FeelFeedBack300_Right_ShowA;
	g_FeelFeedBack300_PrizeButton[2] = FeelFeedBack300_Right_ShowB;
	g_FeelFeedBack300_PrizeButton[3] = FeelFeedBack300_Right_ShowC;
end

--===============================================
-- Hide()
--===============================================
function FeelFeedBack300_Hide() 
	FeelFeedBack300_Close()
end

--===============================================
-- Close()
--===============================================
function FeelFeedBack300_Close()
	g_FeelFeedBack300_Click = -1
	for i=1,3 do
		g_FeelFeedBack300_PrizeButton[i]:SetActionItem( -1 );
	end
	this:Hide()
end
--===============================================
-- ResetPos()
--===============================================
function FeelFeedBack300_On_ResetPos()
	FeelFeedBack300_Frame:SetProperty("UnifiedPosition", g_FeelFeedBack300_Frame_UnifiedPosition)
end


--===============================================
-- 满月感恩回馈-begin
--===============================================
function FeelFeedBack300_7Day_Update()
	for i=1,7 do
		g_FeelFeedBack300_7DayButtom[i].Done:Hide()
	end
	local nData1 = g_FeelFeedBack300_MD_Date
	local nData2 = g_FeelFeedBack300_MF_Date
	--为了防止10版本优化MD和MF的同步，从server端同步MD
	local nTimes = math.mod(nData1,100)
	for i=1,nTimes do
		g_FeelFeedBack300_7DayButtom[i].Done:Hide()
	end

	local nDate = 1
	for i=1,nTimes do
		if math.mod(nData2,10) == 1 then
			g_FeelFeedBack300_7DayButtom[i].Done:Show()
		end
		nData2 = math.floor(nData2/10)
	end

	if g_FeelFeedBack300_Click == -1 then
		FeelFeedBack300_Click(nTimes)
	else
		FeelFeedBack300_Click(g_FeelFeedBack300_Click)
	end
	
end

function FeelFeedBack300_Click(nIndex)

	if nIndex<1 or nIndex>7 then
		return
	end


	FeelFeedBack300_Left_image:SetProperty( "Image", g_FeelFeedBack300_7DayImage[nIndex][1] )
	FeelFeedBack300_Right_imageDay:SetProperty( "Image", g_FeelFeedBack300_7DayImage[nIndex][2] )
	FeelFeedBack300_Right_imageDayItem:SetProperty( "Image", g_FeelFeedBack300_7DayImage[nIndex][3] )

	for i=1, 7 do
		g_FeelFeedBack300_7DayButtom[i].Button:SetCheck(0)
	end

	g_FeelFeedBack300_Click = nIndex

	--显示一下奖励
	for i=1, 3 do
		g_FeelFeedBack300_PrizeButton[i]:SetActionItem( -1 );
	end

	local nCount = table.getn(g_FeelFeedBack300_PrizeList[nIndex])
	for i=1,nCount do
		if 1 == g_FeelFeedBack300_PrizeList[nIndex][i].needbind then
			local theAction = DataPool:CreateBindActionItemForShow(g_FeelFeedBack300_PrizeList[nIndex][i].ItemID, g_FeelFeedBack300_PrizeList[nIndex][i].num)
			if theAction:GetID() ~= 0 then
				g_FeelFeedBack300_PrizeButton[i]:SetActionItem( theAction:GetID() );
			else
				g_FeelFeedBack300_PrizeButton[i]:SetActionItem( -1 );
			end
		else
			local theAction = DataPool:CreateActionItemForShow(g_FeelFeedBack300_PrizeList[nIndex][i].ItemID, g_FeelFeedBack300_PrizeList[nIndex][i].num)
			if theAction:GetID() ~= 0 then
				g_FeelFeedBack300_PrizeButton[i]:SetActionItem( theAction:GetID() );
			else
				g_FeelFeedBack300_PrizeButton[i]:SetActionItem( -1 );
			end
		end

	end

	g_FeelFeedBack300_7DayButtom[nIndex].Button:SetCheck(1)


	--看一下这页是不是可以打开
	local nData1 = g_FeelFeedBack300_MD_Date
	local nTimes = math.mod(nData1,100)

	if nIndex > nTimes then
		--第X日可领取
		FeelFeedBack300_Right_Button1:Disable()
		FeelFeedBack300_Right_Button1:SetProperty("DisabledImage",g_FeelFeedBack300_7DayImage[nIndex][4])
	else
		--看是不是已经领取了
		local nData2 = g_FeelFeedBack300_MF_Date
		local nBase = 1
		for i=1,nIndex-1 do
			nBase = nBase * 10
		end

		local nFlag = math.mod(math.floor(nData2/nBase),10)
		if nFlag == 0 then
		--未领取
			FeelFeedBack300_Right_Button1:Enable()
		elseif nFlag == 1 then
		--已领取
			FeelFeedBack300_Right_Button1:Disable()
			FeelFeedBack300_Right_Button1: SetProperty("DisabledImage","set:Seven image:Seven_lingquDis")
		end
	end

end

function FeelFeedBack300_GetPrize()
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("GetPrize");
			Set_XSCRIPT_ScriptID(792000);
			Set_XSCRIPT_Parameter(0,g_FeelFeedBack300_Click)
			Set_XSCRIPT_ParamCount(1);
		Send_XSCRIPT();
end

