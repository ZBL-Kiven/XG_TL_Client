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
			[1]={ItemID = 38002242, num = 1, needbind =1,},		-- īȾ���������ϡ��3ѡ1,15�죩	1	38002242
			[2]={ItemID = 30501361, num = 3, needbind =1,},		-- ������	3	30501361//��ǿ��	��
			[3]={ItemID = 38000060, num = 1, needbind =1,},		-- 100��Ԫ��	1	38000060��	��
			},
	[2] ={
			[1]={ItemID = 30900045, num = 1, needbind =1,},		-- ���ǿ��¶	1	30900045//��ǿ��
			[2]={ItemID = 30502002, num = 3, needbind =1,},		-- �߼����ǵ�	3	30502002//��ǿ��
			[3]={ItemID = 38000060, num = 1, needbind =1,},		-- 100��Ԫ��	1	38000060��	
			},
	[3] ={
			[1]={ItemID = 38002243, num = 1, needbind =1,},		-- �����ι����������4ѡ1��	1	38002161
			[2]={ItemID = 30008114, num = 1, needbind =1,},		-- �ƽ���	1	30008114//��ǿ��
			[3]={ItemID = 38000060, num = 1, needbind =1,},		-- 100��Ԫ��	1	38000060	��
			},
	[4] ={
			[1]={ItemID = 30008048, num = 1, needbind =1,},		-- ����	1	30008048//��ǿ��
			[2]={ItemID = 30503133, num = 3, needbind =1,},		-- ǧ������	3	��	30503133
			[3]={ItemID = 38000060, num = 1, needbind =1,},		-- 100��Ԫ��	1	��	38000060��
			},
	[5] ={
			[1]={ItemID = 20310168, num = 20,needbind =1,},		-- ���˿	20	��	20310168��
			[2]={ItemID = 20310116, num = 2, needbind =1,},		-- ���޾���	2	20310116//��ǿ��
			[3]={ItemID = 38000060, num = 1, needbind =1,},		-- 100��Ԫ��	1	��	38000060��
			},
	[6] ={
			[1]={ItemID = 30700241, num = 3, needbind =1,},		-- ������ʯ	3	30700241
			[2]={ItemID = 20502003, num = 1, needbind =1,},		-- 3������	1	20502003//��ǿ��
			[3]={ItemID = 38000060, num = 1, needbind =1,},		-- 100��Ԫ��	1	��	38000060
			},
	[7] ={
			[1]={ItemID = 50313004, num = 1, needbind =1,},		-- �챦ʯ3��	1	50313004//��ǿ��
			[2]={ItemID = 20501003, num = 1, needbind =1,},		-- 3���޲�	1	20501003//��ǿ��
			[3]={ItemID = 38000060, num = 1, needbind =1,},		-- 100��Ԫ��	1	��	38000060��
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

-- ����	չʾͼ	��
-- ��1��	XunLong_1	XunLong_Qixi	XunLong_Diewu
-- ��2��	XunLong_2	XunLong_ZhuangbeiBK	XunLong_Zhuangbei
-- ��3��	XunLong_3	XunLong_Mingyu	XunLong_Qianli
-- ��4��	XunLong_4	XunLong_QianghuaBK	XunLong_Qianghua
-- ��5��	XunLong_5	XunLong_Jincansi	XunLong_Diaowen
-- ��6��	XunLong_6	XunLong_Miyin	XunLong_Shougong
-- ��7��	XunLong_7	XunLong_Hongjingshi	XunLong_Baoshi

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
	this:RegisterEvent("PLAYER_LEAVE_WORLD")		-- �뿪����
	this:RegisterEvent("ADJEST_UI_POS",false)			-- ��Ϸ���ڳߴ緢���˱仯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)	        -- ��Ϸ�ֱ��ʷ����˱仯

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
--	elseif (event == "PLAYER_ENTERING_WORLD" ) then				-- ���·������¡������ͺ���&�׳峬ֵ�������¼�����Ʒ����
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
-- ���¸ж�����-begin
--===============================================
function FeelFeedBack300_7Day_Update()
	for i=1,7 do
		g_FeelFeedBack300_7DayButtom[i].Done:Hide()
	end
	local nData1 = g_FeelFeedBack300_MD_Date
	local nData2 = g_FeelFeedBack300_MF_Date
	--Ϊ�˷�ֹ10�汾�Ż�MD��MF��ͬ������server��ͬ��MD
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

	--��ʾһ�½���
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


	--��һ����ҳ�ǲ��ǿ��Դ�
	local nData1 = g_FeelFeedBack300_MD_Date
	local nTimes = math.mod(nData1,100)

	if nIndex > nTimes then
		--��X�տ���ȡ
		FeelFeedBack300_Right_Button1:Disable()
		FeelFeedBack300_Right_Button1:SetProperty("DisabledImage",g_FeelFeedBack300_7DayImage[nIndex][4])
	else
		--���ǲ����Ѿ���ȡ��
		local nData2 = g_FeelFeedBack300_MF_Date
		local nBase = 1
		for i=1,nIndex-1 do
			nBase = nBase * 10
		end

		local nFlag = math.mod(math.floor(nData2/nBase),10)
		if nFlag == 0 then
		--δ��ȡ
			FeelFeedBack300_Right_Button1:Enable()
		elseif nFlag == 1 then
		--����ȡ
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

