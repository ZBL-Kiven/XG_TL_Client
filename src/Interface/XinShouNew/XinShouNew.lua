--!!!reloadscript =XinShouNew
local g_XinShouNew_Frame_UnifiedPosition;

local g_XinShouNew_7DayShowTimes =0;
local g_XinShouNew_7DayButtom ={};
local g_XinShouNew_MD_Date = 0
local g_XinShouNew_MF_Date = 0

local g_XinShouNew_7DayPrize =
{
	[1] ={
				[1]={ItemID = 10141041, num = 1,}, --��������ܣ�15�죩
				[2]={ItemID = 39901003, num = 1,}, --���ǿ������
				[3]={ItemID = 30900056, num = 1,}, --100��Ԫ//��������
				},
	[2] ={
				[1]={ItemID = 39901003, num = 1,},--�������޵�������ţ
				[2]={ItemID = 30900056, num = 1,},--�ͼ����ǵ�
				[3]={ItemID = 39901004, num = 1,},--1000Ԫ��//�������ߣ�ͬ��
				},
	[3] ={
				[1]={ItemID = 20310166, num = 5,},--ʱװ�����������15�죩//����
				[2]={ItemID = 30900056, num = 1,},--���ɰ
				[3]={ItemID = 39901004, num = 1,},--1000Ԫ��//�������ߣ�ͬ��
				},
	[4] ={
				[1]={ItemID = 30008048, num = 1,},--�챦ʯ(3��)
				[2]={ItemID = 30900056, num = 1,},--�ٴ�����
				[3]={ItemID = 39901005, num = 1,},--1000Ԫ��//�������ߣ�ͬ��
				},
	[5] ={
				[1]={ItemID = 20310166, num = 10,},--���ǿ��¶
				[2]={ItemID = 30900056, num = 1,},--������ʯ
				[3]={ItemID = 39901005, num = 1,},--1000Ԫ��//�������ߣ�ͬ��
				},
	[6] ={
				[1]={ItemID = 20501008, num = 5,},--���˿
				[2]={ItemID = 20502004, num = 5,},--3������
				[3]={ItemID = 39901006, num = 5,},--1000Ԫ��//�������ߣ�ͬ��
				},
	[7] ={
				[1]={ItemID = 20501008, num = 5,},--�챦ʯ(3��)
				[2]={ItemID = 20502004, num = 5,},--3���޲�
				[3]={ItemID = 39901008, num = 1,},--1000Ԫ��//�������ߣ�ͬ��
				},	
};
local g_XinShouNew_7DayPrize_Button = {}
local g_XinShouNew_7DayPrize_ButtonNum = {}
local g_XinShouNew_7DayPrize_Click = -1

local g_XinShouNew_7DayImage = {
	[1] ={
				[1]="set:Seven5 image:Seven2_qicheng",								--XinShouNew_SevenDay_Left_image
				[2]="set:Seven image:Seven_1",												--XinShouNew_SevenDay_Right_imageDay
				[3]="set:Seven image:Seven_zuoqi",					--XinShouNew_SevenDay_Right_imageDayItem
				[4]="set:Seven image:Seven_day2",
				},
	[2] ={
				[1]="set:Seven7 image:Seven2_zhenshou",
				[2]="set:Seven image:Seven_2",
				[3]="set:Seven image:Seven_zhenshou",
				[4]="set:Seven image:Seven_day2",				
				},
	[3] ={
				[1]="set:Seven6 image:Seven2_shizhuang",
				[2]="set:Seven image:Seven_3",
				[3]="set:Seven image:Seven_shizhuang",
				[4]="set:Seven image:Seven_day3",				
				},
	[4] ={
				[1]="set:Seven3 image:Seven2_hongbaoshi",
				[2]="set:Seven image:Seven_4",
				[3]="set:Seven image:Seven_baoshi",
				[4]="set:Seven image:Seven_day4",				
				},
	[5] ={
				[1]="set:Seven2 image:Seven2_duanzao",
				[2]="set:Seven image:Seven_5",
				[3]="set:Seven4 image:Seven_QiangHua",
				[4]="set:Seven image:Seven_day5",				
				},
	[6] ={
				[1]="set:Seven4 image:Seven2_qianghua",
				[2]="set:Seven image:Seven_6",
				[3]="set:Seven4 image:Seven_DiaoWen",
				[4]="set:Seven image:Seven_day6",				
				},
	[7] ={
				[1]="set:Seven3 image:Seven2_hongbaoshi",
				[2]="set:Seven image:Seven_7",
				[3]="set:Seven image:Seven_baoshi",
				[4]="set:Seven image:Seven_day7",				
				},	
};

--===============================================
-- PreLoad()
--===============================================
function XinShouNew_PreLoad()
	this:RegisterEvent("UI_COMMAND",true)
	this:RegisterEvent("PLAYER_LEAVE_WORLD")		-- �뿪����
	this:RegisterEvent("ADJEST_UI_POS",false)			-- ��Ϸ���ڳߴ緢���˱仯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)	        -- ��Ϸ�ֱ��ʷ����˱仯
--	this:RegisterEvent("PLAYER_ENTERING_WORLD",true)		-- ������Ϸ����
end

--===============================================
-- OnEvent()
--===============================================
function XinShouNew_OnEvent(event)
	if (event == "PLAYER_LEAVE_WORLD") then
		XinShouNew_Close()
	elseif (event == "ADJEST_UI_POS") then
		XinShouNew_On_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		XinShouNew_On_ResetPos()
--	elseif (event == "PLAYER_ENTERING_WORLD" ) then				-- ���·������¡������ͺ���&�׳峬ֵ�������¼�����Ʒ����
--		g_XinShouNew_ShouChong_LoadFirstTime =1;
--		XinShouNew_SheJiaoNew_Request()
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 89267902 ) then
		local bShow =  Get_XParam_INT( 0 );
		g_XinShouNew_7DayPrize_Click = -1
		if bShow == 1 then
			g_XinShouNew_MD_Date =  Get_XParam_INT( 1 );
			g_XinShouNew_MF_Date =  Get_XParam_INT( 2 );
			XinShouNew_7Day_Update()
			this:Show()
		elseif this:IsVisible() then
			g_XinShouNew_MD_Date =  Get_XParam_INT( 1 );
			g_XinShouNew_MF_Date =  Get_XParam_INT( 2 );
			XinShouNew_7Day_Update()
		end	
	end
end

--===============================================
-- OnLoad()
--===============================================
function XinShouNew_OnLoad()
	g_XinShouNew_Frame_UnifiedPosition = XinShouNew_Frame:GetProperty("UnifiedPosition")

	g_XinShouNew_7DayButtom[1] ={Button =XinShouNew_SevenDay_Top_day1_Button1 , Done = XinShouNew_SevenDay_Top_day1_done };
	g_XinShouNew_7DayButtom[2] ={Button =XinShouNew_SevenDay_Top_day2_Button1 , Done = XinShouNew_SevenDay_Top_day2_done };
	g_XinShouNew_7DayButtom[3] ={Button =XinShouNew_SevenDay_Top_day3_Button1 , Done = XinShouNew_SevenDay_Top_day3_done };
	g_XinShouNew_7DayButtom[4] ={Button =XinShouNew_SevenDay_Top_day4_Button1 , Done = XinShouNew_SevenDay_Top_day4_done };
	g_XinShouNew_7DayButtom[5] ={Button =XinShouNew_SevenDay_Top_day5_Button1 , Done = XinShouNew_SevenDay_Top_day5_done };
	g_XinShouNew_7DayButtom[6] ={Button =XinShouNew_SevenDay_Top_day6_Button1 , Done = XinShouNew_SevenDay_Top_day6_done };
	g_XinShouNew_7DayButtom[7] ={Button =XinShouNew_SevenDay_Top_day7_Button1 , Done = XinShouNew_SevenDay_Top_day7_done };

	g_XinShouNew_7DayPrize_Button[1] = XinShouNew_SevenDay_Right_ShowA;
	g_XinShouNew_7DayPrize_Button[2] = XinShouNew_SevenDay_Right_ShowB;
	g_XinShouNew_7DayPrize_Button[3] = XinShouNew_SevenDay_Right_ShowC;
	g_XinShouNew_7DayPrize_Button[4] = XinShouNew_SevenDay_Right_ShowD;

	g_XinShouNew_7DayPrize_ButtonNum[1] = XinShouNew_SevenDay_Right_ShowAA;
	g_XinShouNew_7DayPrize_ButtonNum[2] = XinShouNew_SevenDay_Right_ShowBB;
	g_XinShouNew_7DayPrize_ButtonNum[3] = XinShouNew_SevenDay_Right_ShowCC;
	g_XinShouNew_7DayPrize_ButtonNum[4] = XinShouNew_SevenDay_Right_ShowDD;
end

--===============================================
-- Hide()
--===============================================
function XinShouNew_Hide() 
	XinShouNew_Close()
end

--===============================================
-- Close()
--===============================================
function XinShouNew_Close()
	g_XinShouNew_7DayPrize_Click = -1
	this:Hide()
end
--===============================================
-- ResetPos()
--===============================================
function XinShouNew_On_ResetPos()
	XinShouNew_Frame:SetProperty("UnifiedPosition", g_XinShouNew_Frame_UnifiedPosition)
end


--===============================================
-- ����7�պ���-begin
--===============================================
function XinShouNew_7Day_Update()
	for i=1,7 do
		g_XinShouNew_7DayButtom[i].Done:Hide()
	end
	local nData1 = g_XinShouNew_MD_Date
	local nData2 = g_XinShouNew_MF_Date
	--Ϊ�˷�ֹ10�汾�Ż�MD��MF��ͬ������server��ͬ��MD
	local nTimes = nData1
	for i=1,nTimes do
		g_XinShouNew_7DayButtom[i].Done:Hide()
	end

	local nDate = 1
	for i=1,nTimes do
		if math.mod(nData2,10) == 1 then
			g_XinShouNew_7DayButtom[i].Done:Show()
		end
		nData2 = math.floor(nData2/10)
	end
	
	-- if g_XinShouNew_7DayPrize_Click == -1 then
		XinShouNew_SevenDay_Click(nTimes)
	-- else
		-- XinShouNew_SevenDay_Click(g_XinShouNew_7DayPrize_Click)
	-- end
end

function XinShouNew_SevenDay_Click(nIndex)

	if nIndex<1 or nIndex>7 then
		return
	end


	XinShouNew_SevenDay_Left_image:SetProperty( "Image", g_XinShouNew_7DayImage[nIndex][1] )
	XinShouNew_SevenDay_Right_imageDay:SetProperty( "Image", g_XinShouNew_7DayImage[nIndex][2] )
	XinShouNew_SevenDay_Right_imageDayItem:SetProperty( "Image", g_XinShouNew_7DayImage[nIndex][3] )

	for i=1, 7 do
		g_XinShouNew_7DayButtom[i].Button:SetCheck(0)
	end

	g_XinShouNew_7DayPrize_Click = nIndex

	--��ʾһ�½���
	for i=1, 4 do
		g_XinShouNew_7DayPrize_Button[i]:SetActionItem( -1 );
	end

	local nCount = table.getn(g_XinShouNew_7DayPrize[nIndex])
	for i=1,nCount do
		local theAction = GemCarve:UpdateProductAction(g_XinShouNew_7DayPrize[nIndex][i].ItemID)
		if theAction:GetID() ~= 0 then
			g_XinShouNew_7DayPrize_Button[i]:SetActionItem( theAction:GetID() );
			g_XinShouNew_7DayPrize_ButtonNum[i]:SetText(g_XinShouNew_7DayPrize[nIndex][i].num)
			if g_XinShouNew_7DayPrize[nIndex][i].num == 1 then
			    g_XinShouNew_7DayPrize_ButtonNum[i]:Hide()
			else
			    g_XinShouNew_7DayPrize_ButtonNum[i]:Show()
			end
		else
			g_XinShouNew_7DayPrize_Button[i]:SetActionItem( -1 );
		end
	end

	g_XinShouNew_7DayButtom[nIndex].Button:SetCheck(1)


	--��һ����ҳ�ǲ��ǿ��Դ�
	local nData1 = g_XinShouNew_MD_Date
	local nTimes = math.mod(nData1,100)

	if nIndex > nTimes then
		--��X�տ���ȡ
		XinShouNew_SevenDay_Right_Button1:Disable()
		XinShouNew_SevenDay_Right_Button1:SetProperty("DisabledImage",g_XinShouNew_7DayImage[nIndex][4])
	else
		--���ǲ����Ѿ���ȡ��
		local nData2 = g_XinShouNew_MF_Date
		local nBase = 1
		for i=1,nIndex-1 do
			nBase = nBase * 10
		end

		local nFlag = math.mod(math.floor(nData2/nBase),10)
		if nFlag == 0 then
		--δ��ȡ
			XinShouNew_SevenDay_Right_Button1:Enable()
		elseif nFlag == 1 then
		--����ȡ
			XinShouNew_SevenDay_Right_Button1:Disable()
			XinShouNew_SevenDay_Right_Button1: SetProperty("DisabledImage","set:Seven image:Seven_lingquDis")
		end
	end

end

function XinShouNew_SevenDay_GetPrize()
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("Get7DayPrize");
			Set_XSCRIPT_ScriptID(318318);
			Set_XSCRIPT_Parameter(0,g_XinShouNew_7DayPrize_Click)
			Set_XSCRIPT_ParamCount(1);
		Send_XSCRIPT();
end

--===============================================
-- ����7�պ��� -end
--===============================================
