--!!!reloadscript =FeelFeedBack600
local g_FeelFeedBack600_Frame_UnifiedPosition;

local g_FeelFeedBack600_7DayShowTimes =0;
local g_FeelFeedBack600_7DayButtom ={};
local g_FeelFeedBack600_MD_Date = 0
local g_FeelFeedBack600_MF_Date = 0
local g_FeelFeedBack600_MD_LastDay = 0

local g_FeelFeedBack600_PrizeList =
{
	[1] ={
			[1]={ItemID = 38002492, num = 1, needbind =1,},		-- ������Ե�����ϡ��3ѡ1,15�죩	
			[2]={ItemID = 30501361, num = 3, needbind =1,},		-- ������	
			[3]={ItemID = 38000060, num = 1, needbind =1,},		-- 100��Ԫ��
			},
	[2] ={
			[1]={ItemID = 30900045, num = 1, needbind =1,},		-- ���ǿ��¶	
			[2]={ItemID = 30502002, num = 3, needbind =1,},		-- �߼����ǵ�	
			[3]={ItemID = 38000060, num = 1, needbind =1,},		-- 100��Ԫ��
			},
	[3] ={
			[1]={ItemID = 38002493, num = 1, needbind =1,},		-- �����������������4ѡ1��	
			[2]={ItemID = 30008114, num = 1, needbind =1,},		-- �ƽ���
			[3]={ItemID = 38000060, num = 1, needbind =1,},		-- 100��Ԫ��
			},
	[4] ={
			[1]={ItemID = 30008048, num = 1, needbind =1,},		-- ����
			[2]={ItemID = 30503133, num = 3, needbind =1,},		-- ǧ������
			[3]={ItemID = 38000060, num = 1, needbind =1,},		-- 100��Ԫ��	
			},
	[5] ={
			[1]={ItemID = 20310168, num = 20,needbind =1,},		-- ���˿	
			[2]={ItemID = 38002530, num = 5, needbind =1,},		-- ���굤
			[3]={ItemID = 38000060, num = 1, needbind =1,},		-- 100��Ԫ��	
			},
	[6] ={
			[1]={ItemID = 30700241, num = 3, needbind =1,},		-- ������ʯ	
			[2]={ItemID = 20502003, num = 1, needbind =1,},		-- 3������
			[3]={ItemID = 38000060, num = 1, needbind =1,},		-- 100��Ԫ��
			},
	[7] ={
			[1]={ItemID = 50313004, num = 1, needbind =1,},		-- �챦ʯ3��	
			[2]={ItemID = 20501003, num = 1, needbind =1,},		-- 3���޲�
			[3]={ItemID = 38000060, num = 1, needbind =1,},		-- 100��Ԫ��
			},
}
local g_FeelFeedBack600_PrizeButton = {}
local g_FeelFeedBack600_Click = -1

-- FeelFeedBack400_Left_image	FeelFeedBack400_Right_imageDay	FeelFeedBack400_Right_imageDayItem
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

local g_FeelFeedBack600_7DayImage = {
	[1] ={
				[1]="set:FeelFeedBack600_2 image:FeelFeedBack600_Right1",			--FeelFeedBack400_Left_image ����ͼƬ
				[2]="set:FeelFeedBack600_1 image:FeelFeedBack600_Num1",				--FeelFeedBack400_Right_imageDay ����������
				[3]="set:FeelFeedBack600_1 image:FeelFeedBack600_Gift1",			--FeelFeedBack400_Right_imageDayItem �������
				[4]="set:Seven image:Seven_day2",
				},
	[2] ={
				[1]="set:FeelFeedBack600_2 image:FeelFeedBack600_Right2",
				[2]="set:FeelFeedBack600_1 image:FeelFeedBack600_Num2",
				[3]="set:FeelFeedBack600_1 image:FeelFeedBack600_Gift2",
				[4]="set:Seven image:Seven_day2",				
				},
	[3] ={
				[1]="set:FeelFeedBack600_2 image:FeelFeedBack600_Right3",
				[2]="set:FeelFeedBack600_1 image:FeelFeedBack600_Num3",
				[3]="set:FeelFeedBack600_1 image:FeelFeedBack600_Gift3",
				[4]="set:Seven image:Seven_day3",				
				},
	[4] ={
				[1]="set:FeelFeedBack600_2 image:FeelFeedBack600_Right4",
				[2]="set:FeelFeedBack600_1 image:FeelFeedBack600_Num4",
				[3]="set:FeelFeedBack600_1 image:FeelFeedBack600_Gift4",
				[4]="set:Seven image:Seven_day4",				
				},
	[5] ={
				[1]="set:FeelFeedBack600_2 image:FeelFeedBack600_Right5",
				[2]="set:FeelFeedBack600_1 image:FeelFeedBack600_Num5",
				[3]="set:FeelFeedBack600_1 image:FeelFeedBack600_Gift5",
				[4]="set:Seven image:Seven_day5",				
				},
	[6] ={
				[1]="set:FeelFeedBack600_2 image:FeelFeedBack600_Right6",
				[2]="set:FeelFeedBack600_1 image:FeelFeedBack600_Num6",
				[3]="set:FeelFeedBack600_1 image:FeelFeedBack600_Gift6",
				[4]="set:Seven image:Seven_day6",				
				},
	[7] ={
				[1]="set:FeelFeedBack600_2 image:FeelFeedBack600_Right7",
				[2]="set:FeelFeedBack600_1 image:FeelFeedBack600_Num7",
				[3]="set:FeelFeedBack600_1 image:FeelFeedBack600_Gift7",
				[4]="set:Seven image:Seven_day7",				
				},	
}

--===============================================
-- PreLoad()
--===============================================
function FeelFeedBack600_PreLoad()
	this:RegisterEvent("UI_COMMAND",true)
	this:RegisterEvent("PLAYER_LEAVE_WORLD")		-- �뿪����
	this:RegisterEvent("ADJEST_UI_POS",false)			-- ��Ϸ���ڳߴ緢���˱仯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)	        -- ��Ϸ�ֱ��ʷ����˱仯

end

--===============================================
-- OnEvent()
--===============================================
function FeelFeedBack600_OnEvent(event)
	if (event == "PLAYER_LEAVE_WORLD") then
		FeelFeedBack600_Close()
	elseif (event == "ADJEST_UI_POS") then
		FeelFeedBack600_On_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		FeelFeedBack600_On_ResetPos()
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 79200602 ) then
		local bShow =  Get_XParam_INT( 0 );
		if bShow == 1 then
			g_FeelFeedBack600_MD_Date =  Get_XParam_INT( 1 );
			g_FeelFeedBack600_MF_Date =  Get_XParam_INT( 2 );
			g_FeelFeedBack600_MD_LastDay = Get_XParam_INT( 3 );
			FeelFeedBack600_7Day_Update()
			local nMDLast = math.mod(g_FeelFeedBack600_MD_LastDay,10000)
			local nMDMonth = math.floor(nMDLast/100)
			local nMDMDay = math.mod(nMDLast,100)
			FeelFeedBack600_Text2:SetText( ScriptGlobal_Format("#{QRDL_20211229_18}",nMDMonth,nMDMDay) )
			this:Show()
		elseif this:IsVisible() then
			g_FeelFeedBack600_MD_Date =  Get_XParam_INT( 1 );
			g_FeelFeedBack600_MF_Date =  Get_XParam_INT( 2 );
			FeelFeedBack600_7Day_Update()
		end	
	end
end

--===============================================
-- OnLoad()
--===============================================
function FeelFeedBack600_OnLoad()
	g_FeelFeedBack600_Frame_UnifiedPosition = FeelFeedBack600_Frame:GetProperty("UnifiedPosition")

	g_FeelFeedBack600_7DayButtom[1] ={Button =FeelFeedBack600_Top_day1_Button1 , Done = FeelFeedBack600_Top_day1_done };
	g_FeelFeedBack600_7DayButtom[2] ={Button =FeelFeedBack600_Top_day2_Button1 , Done = FeelFeedBack600_Top_day2_done };
	g_FeelFeedBack600_7DayButtom[3] ={Button =FeelFeedBack600_Top_day3_Button1 , Done = FeelFeedBack600_Top_day3_done };
	g_FeelFeedBack600_7DayButtom[4] ={Button =FeelFeedBack600_Top_day4_Button1 , Done = FeelFeedBack600_Top_day4_done };
	g_FeelFeedBack600_7DayButtom[5] ={Button =FeelFeedBack600_Top_day5_Button1 , Done = FeelFeedBack600_Top_day5_done };
	g_FeelFeedBack600_7DayButtom[6] ={Button =FeelFeedBack600_Top_day6_Button1 , Done = FeelFeedBack600_Top_day6_done };
	g_FeelFeedBack600_7DayButtom[7] ={Button =FeelFeedBack600_Top_day7_Button1 , Done = FeelFeedBack600_Top_day7_done };

	g_FeelFeedBack600_PrizeButton[1] = FeelFeedBack600_Right_ShowA;
	g_FeelFeedBack600_PrizeButton[2] = FeelFeedBack600_Right_ShowB;
	g_FeelFeedBack600_PrizeButton[3] = FeelFeedBack600_Right_ShowC;
end

--===============================================
-- Hide()
--===============================================
function FeelFeedBack600_Hide() 
	FeelFeedBack600_Close()
end

--===============================================
-- Close()
--===============================================
function FeelFeedBack600_Close()
	g_FeelFeedBack600_Click = -1
	for i=1,3 do
		g_FeelFeedBack600_PrizeButton[i]:SetActionItem( -1 );
	end
	this:Hide()
end
--===============================================
-- ResetPos()
--===============================================
function FeelFeedBack600_On_ResetPos()
	FeelFeedBack600_Frame:SetProperty("UnifiedPosition", g_FeelFeedBack600_Frame_UnifiedPosition)
end


--===============================================
-- ���¸ж�����-begin
--===============================================
function FeelFeedBack600_7Day_Update()
	for i=1,7 do
		g_FeelFeedBack600_7DayButtom[i].Done:Hide()
	end
	local nData1 = g_FeelFeedBack600_MD_Date
	local nData2 = g_FeelFeedBack600_MF_Date
	--Ϊ�˷�ֹ10�汾�Ż�MD��MF��ͬ������server��ͬ��MD
	local nTimes = math.mod(nData1,100)
	for i=1,nTimes do
		g_FeelFeedBack600_7DayButtom[i].Done:Hide()
	end

	local nDate = 1
	for i=1,nTimes do
		if math.mod(nData2,10) == 1 then
			g_FeelFeedBack600_7DayButtom[i].Done:Show()
		end
		nData2 = math.floor(nData2/10)
	end

	if g_FeelFeedBack600_Click == -1 then
		FeelFeedBack600_Click(nTimes)
	else
		FeelFeedBack600_Click(g_FeelFeedBack600_Click)
	end
	
end

function FeelFeedBack600_Click(nIndex)

	if nIndex<1 or nIndex>7 then
		return
	end


	FeelFeedBack600_Left_image:SetProperty( "Image", g_FeelFeedBack600_7DayImage[nIndex][1] )
	FeelFeedBack600_Right_imageDay:SetProperty( "Image", g_FeelFeedBack600_7DayImage[nIndex][2] )
	FeelFeedBack600_Right_imageDayItem:SetProperty( "Image", g_FeelFeedBack600_7DayImage[nIndex][3] )

	for i=1, 7 do
		g_FeelFeedBack600_7DayButtom[i].Button:SetCheck(0)
	end

	g_FeelFeedBack600_Click = nIndex

	--��ʾһ�½���
	for i=1, 3 do
		g_FeelFeedBack600_PrizeButton[i]:SetActionItem( -1 );
	end

	local nCount = table.getn(g_FeelFeedBack600_PrizeList[nIndex])
	for i=1,nCount do
		if 1 == g_FeelFeedBack600_PrizeList[nIndex][i].needbind then
			local theAction = DataPool:CreateBindActionItemForShow(g_FeelFeedBack600_PrizeList[nIndex][i].ItemID, g_FeelFeedBack600_PrizeList[nIndex][i].num)
			if theAction:GetID() ~= 0 then
				g_FeelFeedBack600_PrizeButton[i]:SetActionItem( theAction:GetID() );
			else
				g_FeelFeedBack600_PrizeButton[i]:SetActionItem( -1 );
			end
		else
			local theAction = DataPool:CreateActionItemForShow(g_FeelFeedBack600_PrizeList[nIndex][i].ItemID, g_FeelFeedBack600_PrizeList[nIndex][i].num)
			if theAction:GetID() ~= 0 then
				g_FeelFeedBack600_PrizeButton[i]:SetActionItem( theAction:GetID() );
			else
				g_FeelFeedBack600_PrizeButton[i]:SetActionItem( -1 );
			end
		end

	end

	g_FeelFeedBack600_7DayButtom[nIndex].Button:SetCheck(1)


	--��һ����ҳ�ǲ��ǿ��Դ�
	local nData1 = g_FeelFeedBack600_MD_Date
	local nTimes = math.mod(nData1,100)

	if nIndex > nTimes then
		--��X�տ���ȡ
		FeelFeedBack600_Right_Button1:Disable()
		FeelFeedBack600_Right_Button1:SetProperty("DisabledImage",g_FeelFeedBack600_7DayImage[nIndex][4])
	else
		--���ǲ����Ѿ���ȡ��
		local nData2 = g_FeelFeedBack600_MF_Date
		local nBase = 1
		for i=1,nIndex-1 do
			nBase = nBase * 10
		end

		local nFlag = math.mod(math.floor(nData2/nBase),10)
		if nFlag == 0 then
		--δ��ȡ
			FeelFeedBack600_Right_Button1:Enable()
		elseif nFlag == 1 then
		--����ȡ
			FeelFeedBack600_Right_Button1:Disable()
			FeelFeedBack600_Right_Button1: SetProperty("DisabledImage","set:Seven image:Seven_lingquDis")
		end
	end

end

function FeelFeedBack600_GetPrize()
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("GetPrize");
			Set_XSCRIPT_ScriptID(792006);
			Set_XSCRIPT_Parameter(0,g_FeelFeedBack600_Click)
			Set_XSCRIPT_ParamCount(1);
		Send_XSCRIPT();
end

