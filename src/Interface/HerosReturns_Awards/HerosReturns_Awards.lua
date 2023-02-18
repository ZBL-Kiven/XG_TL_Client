--HerosReturns_Awards.lua
local g_HerosReturns_Awards_Frame_UnifiedPosition

local g_HerosReturns_Awards_7DayShowTimes =0;
local g_HerosReturns_Awards_7DayButtom ={};
local g_HerosReturns_Awards_LeftTime = 0
local g_HerosReturns_Awards_LoginDays = 0
local g_HerosReturns_Awards_PrizeFlag = 0

local g_HerosReturns_Awards_FenYe={};
local g_HerosReturns_Awards_RedPoint={};
local g_HerosReturns_Awards_RedPointState = {0,0,0}

local g_HerosReturns_Awards_7DayPrize =
{
	[1] ={
				[1]={ItemID = 39920039, num = 1,}, --ѩ��˪��7��
				[2]={ItemID = 39920051, num = 1,}, --70��Ԫ
				[3]={ItemID = 39920050, num = 1,}, --��������				
				},
	[2] ={
				[1]={ItemID = 39920041, num = 2,}, --���鵤*2
				[2]={ItemID = 39920052, num = 1,}, --75��Ԫ
				[3]={ItemID = 39920050, num = 1,}, --��������
				},
	[3] ={
				[1]={ItemID = 39920040, num = 1,}, --���ڤ��7��
				[2]={ItemID = 39920053, num = 1,}, --80��Ԫ
				[3]={ItemID = 39920050, num = 1,}, --��������				
				},
	[4] ={
				[1]={ItemID = 39920042, num = 2,}, --������*2
				[2]={ItemID = 39920054, num = 1,}, --85��Ԫ
				[3]={ItemID = 39920050, num = 1,}, --��������				
				},
	[5] ={
				[1]={ItemID = 39920016, num = 10,}, --���˿*10
				[2]={ItemID = 39920055, num = 1,}, --90��Ԫ
				[3]={ItemID = 39920050, num = 1,}, --��������				
				},
	[6] ={
				[1]={ItemID = 39920014, num = 1,}, --���ǿ��¶
				[2]={ItemID = 39920056, num = 1,}, --95��Ԫ
				[3]={ItemID = 39920050, num = 1,}, --��������				
				},
	[7] ={
				[1]={ItemID = 39920012, num = 1,}, --�챦ʯ��3����
				[2]={ItemID = 39920019, num = 1,}, --100��Ԫ
				[3]={ItemID = 39920050, num = 1,}, --��������				
				},	
};
local g_HerosReturns_Awards_7DayPrize_Button = {}
local g_HerosReturns_Awards_7DayPrize_Click = -1

local g_HerosReturns_Awards_7DayImage = {
	[1] ={
				[1]="set:HerosReturns03 image:HerosReturns_D1Image",								--HerosReturns_Awards_SevenDay_Left_image
				[2]="set:Seven image:Seven_1",												--HerosReturns_Awards_SevenDay_Right_imageDay
				[3]="set:HerosReturns03 image:HerosReturns_D1Name",					--HerosReturns_Awards_SevenDay_Right_imageDayItem
				[4]="set:Seven image:Seven_day2",
				},
	[2] ={
				[1]="set:HerosReturns03 image:HerosReturns_D2Image",
				[2]="set:Seven image:Seven_2",
				[3]="set:HerosReturns03 image:HerosReturns_D2Name",
				[4]="set:Seven image:Seven_day2",				
				},
	[3] ={
				[1]="set:HerosReturns04 image:HerosReturns_D3Image",
				[2]="set:Seven image:Seven_3",
				[3]="set:HerosReturns04 image:HerosReturns_D3Name",
				[4]="set:Seven image:Seven_day3",				
				},
	[4] ={
				[1]="set:HerosReturns04 image:HerosReturns_D4Image",
				[2]="set:Seven image:Seven_4",
				[3]="set:HerosReturns04 image:HerosReturns_D4Name",
				[4]="set:Seven image:Seven_day4",				
				},
	[5] ={
				[1]="set:HerosReturns05 image:HerosReturns_D5Image",
				[2]="set:Seven image:Seven_5",
				[3]="set:HerosReturns05 image:HerosReturns_D5Name",
				[4]="set:Seven image:Seven_day5",				
				},
	[6] ={
				[1]="set:HerosReturns05 image:HerosReturns_D6Image",
				[2]="set:Seven image:Seven_6",
				[3]="set:HerosReturns05 image:HerosReturns_D6Name",
				[4]="set:Seven image:Seven_day6",				
				},
	[7] ={
				[1]="set:HerosReturns06 image:HerosReturns_D7Image",
				[2]="set:Seven image:Seven_7",
				[3]="set:HerosReturns06 image:HerosReturns_D7Name",
				[4]="set:Seven image:Seven_day7",				
				},	
};

--Ԥ���غ��������Զ���ֻ��������ע��ű����ĵ��¼�
function HerosReturns_Awards_PreLoad()
	this:RegisterEvent("UI_COMMAND");

	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")	--�������رս���
end

--���ش��ڵ�ʱ����õĺ��������ش���ʱ����һ��
function HerosReturns_Awards_OnLoad()
	g_HerosReturns_Awards_Frame_UnifiedPosition = HerosReturns_Awards_FrameFull:GetProperty("UnifiedPosition")
	
	g_HerosReturns_Awards_7DayButtom[1] ={Button =HerosReturns_Awards_SevenDay_Top_day1_Button1 , Done = HerosReturns_Awards_SevenDay_Top_day1_done };
	g_HerosReturns_Awards_7DayButtom[2] ={Button =HerosReturns_Awards_SevenDay_Top_day2_Button1 , Done = HerosReturns_Awards_SevenDay_Top_day2_done };
	g_HerosReturns_Awards_7DayButtom[3] ={Button =HerosReturns_Awards_SevenDay_Top_day3_Button1 , Done = HerosReturns_Awards_SevenDay_Top_day3_done };
	g_HerosReturns_Awards_7DayButtom[4] ={Button =HerosReturns_Awards_SevenDay_Top_day4_Button1 , Done = HerosReturns_Awards_SevenDay_Top_day4_done };
	g_HerosReturns_Awards_7DayButtom[5] ={Button =HerosReturns_Awards_SevenDay_Top_day5_Button1 , Done = HerosReturns_Awards_SevenDay_Top_day5_done };
	g_HerosReturns_Awards_7DayButtom[6] ={Button =HerosReturns_Awards_SevenDay_Top_day6_Button1 , Done = HerosReturns_Awards_SevenDay_Top_day6_done };
	g_HerosReturns_Awards_7DayButtom[7] ={Button =HerosReturns_Awards_SevenDay_Top_day7_Button1 , Done = HerosReturns_Awards_SevenDay_Top_day7_done };

	g_HerosReturns_Awards_7DayPrize_Button[1] = HerosReturns_Awards_SevenDay_Right_ShowA;
	g_HerosReturns_Awards_7DayPrize_Button[2] = HerosReturns_Awards_SevenDay_Right_ShowB;
	g_HerosReturns_Awards_7DayPrize_Button[3] = HerosReturns_Awards_SevenDay_Right_ShowC;
	g_HerosReturns_Awards_7DayPrize_Button[4] = HerosReturns_Awards_SevenDay_Right_ShowD;
	
	g_HerosReturns_Awards_FenYe[1] = HerosReturns_Awards_Buttontab01;
	g_HerosReturns_Awards_FenYe[2] = HerosReturns_Awards_Buttontab02;
	g_HerosReturns_Awards_FenYe[3] = HerosReturns_Awards_Buttontab03;
	
	g_HerosReturns_Awards_RedPoint[1] = HerosReturns_Awards_Buttontab01_tips;
	g_HerosReturns_Awards_RedPoint[2] = HerosReturns_Awards_Buttontab02_tips;
	g_HerosReturns_Awards_RedPoint[3] = HerosReturns_Awards_Buttontab03_tips;
	
end

--��Ӧ�¼��ĺ�������ע����¼�����ʱ����õĺ���
function HerosReturns_Awards_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0)== 80811001 ) then
		
		local bShow =  Get_XParam_INT( 0 );
		if bShow == 1 then
			g_HerosReturns_Awards_LeftTime  =  Get_XParam_INT( 1 );
			g_HerosReturns_Awards_LoginDays =  Get_XParam_INT( 2 );
			g_HerosReturns_Awards_PrizeFlag =  Get_XParam_INT( 3 );
			HerosReturns_Awards_Update()
			this:Show()
		elseif this:IsVisible() then
			g_HerosReturns_Awards_LeftTime  =  Get_XParam_INT( 1 );
			g_HerosReturns_Awards_LoginDays =  Get_XParam_INT( 2 );
			g_HerosReturns_Awards_PrizeFlag =  Get_XParam_INT( 3 );
			HerosReturns_Awards_Update()
		end
		
		HerosReturns_Awards_On_SetLastPos()
		
	elseif ( event == "UI_COMMAND" and tonumber( arg0 ) == 80811006 and this:IsVisible() ) then
		HerosReturns_Awards_Close();
		
	elseif (event == "UI_COMMAND" and tonumber( arg0 ) == 80811005 and this:IsVisible()) then
		--���
		g_HerosReturns_Awards_RedPointState[1] = Get_XParam_INT( 0 )
		g_HerosReturns_Awards_RedPointState[2] = Get_XParam_INT( 1 )
		g_HerosReturns_Awards_RedPointState[3] = Get_XParam_INT( 2 )
		HerosReturns_Awards_UpdateRedPoint()	
		
	elseif (event == "ADJEST_UI_POS" ) then
		HerosReturns_Awards_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		HerosReturns_Awards_Frame_On_ResetPos()
		
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		HerosReturns_Awards_Close()
	end
end

function HerosReturns_Awards_Update()

	-- ˢ�°�ť״̬
	g_HerosReturns_Awards_FenYe[1]:SetProperty("Selected", "True")
	g_HerosReturns_Awards_FenYe[2]:SetProperty("Selected", "False")
	g_HerosReturns_Awards_FenYe[3]:SetProperty("Selected", "False")

	-- ˢ��ʣ��ʱ�� 
	local nLeftTime = tonumber(g_HerosReturns_Awards_LeftTime);
	if nLeftTime > 0 then
		local nDay = math.floor(nLeftTime / (3600 * 24));
		local nHour = math.ceil( math.mod( nLeftTime, 3600*24)/ 3600 )
		
		HerosReturns_AwardsText2:SetText( ScriptGlobal_Format("#{HJHL_201224_29}", nDay, nHour) );
		HerosReturns_AwardsText2:Show();
	end
		
	for i=1,7 do
		g_HerosReturns_Awards_7DayButtom[i].Done:Hide()
	end
	local nData1 = g_HerosReturns_Awards_LoginDays
	local nData2 = g_HerosReturns_Awards_PrizeFlag
	
	local nTimes = math.mod(nData1,100)
	if nTimes > 7 then
		nTimes = 7;
	end
	for i=1,nTimes do
		g_HerosReturns_Awards_7DayButtom[i].Done:Hide()
	end

	local nDate = 1
	for i=1,nTimes do
		if math.mod(nData2,10) == 1 then
			g_HerosReturns_Awards_7DayButtom[i].Done:Show()
		end
		nData2 = math.floor(nData2/10)
	end
	
	if g_HerosReturns_Awards_7DayPrize_Click == -1 then
		HerosReturns_Awards_SevenDay_Click(nTimes)
	else
		HerosReturns_Awards_SevenDay_Click(g_HerosReturns_Awards_7DayPrize_Click)
	end
	
end

function HerosReturns_Awards_SevenDay_Click(nIndex)

	if nIndex<1 or nIndex>7 then
		return
	end

	HerosReturns_Awards_SevenDay_Left_image:SetProperty( "Image", g_HerosReturns_Awards_7DayImage[nIndex][1] )
	HerosReturns_Awards_SevenDay_Right_imageDay:SetProperty( "Image", g_HerosReturns_Awards_7DayImage[nIndex][2] )
	HerosReturns_Awards_SevenDay_Right_imageDayItem:SetProperty( "Image", g_HerosReturns_Awards_7DayImage[nIndex][3] )

	for i=1, 7 do
		g_HerosReturns_Awards_7DayButtom[i].Button:SetCheck(0)
	end

	g_HerosReturns_Awards_7DayPrize_Click = nIndex

	--��ʾһ�½���
	for i=1, 4 do
		g_HerosReturns_Awards_7DayPrize_Button[i]:SetActionItem( -1 );
	end

	local nCount = table.getn(g_HerosReturns_Awards_7DayPrize[nIndex])
	for i=1,nCount do
		local theAction = DataPool:CreateActionItemForShow(g_HerosReturns_Awards_7DayPrize[nIndex][i].ItemID, g_HerosReturns_Awards_7DayPrize[nIndex][i].num)
		if theAction:GetID() ~= 0 then
			g_HerosReturns_Awards_7DayPrize_Button[i]:SetActionItem( theAction:GetID() );
		else
			g_HerosReturns_Awards_7DayPrize_Button[i]:SetActionItem( -1 );
		end
	end

	g_HerosReturns_Awards_7DayButtom[nIndex].Button:SetCheck(1)


	--��һ����ҳ�ǲ��ǿ��Դ�
	local nData1 = g_HerosReturns_Awards_LoginDays
	local nTimes = math.mod(nData1,100)

	if nIndex > nTimes then
		--��X�տ���ȡ
		HerosReturns_Awards_SevenDay_Right_Button1:Disable()
		HerosReturns_Awards_SevenDay_Right_Button1:SetProperty("DisabledImage",g_HerosReturns_Awards_7DayImage[nIndex][4])
	else
		--���ǲ����Ѿ���ȡ��
		local nData2 = g_HerosReturns_Awards_PrizeFlag
		local nBase = 1
		for i=1,nIndex-1 do
			nBase = nBase * 10
		end

		local nFlag = math.mod(math.floor(nData2/nBase),10)
		if nFlag == 0 then
		--δ��ȡ
			HerosReturns_Awards_SevenDay_Right_Button1:Enable()
		elseif nFlag == 1 then
		--����ȡ
			HerosReturns_Awards_SevenDay_Right_Button1:Disable()
			HerosReturns_Awards_SevenDay_Right_Button1: SetProperty("DisabledImage","set:Seven image:Seven_lingquDis")
		end
	end

end

function HerosReturns_Awards_SevenDay_GetPrize()
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("Get7DayPrize");
			Set_XSCRIPT_ScriptID(808110);
			Set_XSCRIPT_Parameter(0,g_HerosReturns_Awards_7DayPrize_Click)
			Set_XSCRIPT_ParamCount(1);
		Send_XSCRIPT();
end

--ˢ�º��
function HerosReturns_Awards_UpdateRedPoint()

	for i = 1, 3 do
		if g_HerosReturns_Awards_RedPointState[i] == 1 then
			g_HerosReturns_Awards_RedPoint[i]:Show()
		else
			g_HerosReturns_Awards_RedPoint[i]:Hide()
		end
	end
	
end

--ҳ���л� 1���������� 2���������� 3���ٹ��
function HerosReturns_Awards_FenYe_Clicked(index)

	if index < 1 or index > 3 then
		return
	end
	
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "OnOpenUI" ); 		-- �ű���
		Set_XSCRIPT_ScriptID( 808110 );						-- �ű����
		Set_XSCRIPT_Parameter(0, index)
		Set_XSCRIPT_ParamCount( 1 );						-- ��������
	Send_XSCRIPT()
		
	Variable:SetVariable("HerosReturnsUIPos", HerosReturns_Awards_FrameFull:GetProperty("UnifiedPosition"), 1)
end

function HerosReturns_Awards_OnHidden()
	g_HerosReturns_Awards_7DayPrize_Click = -1
	for i=1,4 do
		g_HerosReturns_Awards_7DayPrize_Button[i]:SetActionItem( -1 );
	end
	Variable:SetVariable("HerosReturnsUIPos", HerosReturns_Awards_FrameFull:GetProperty("UnifiedPosition"), 1)
end

function HerosReturns_Awards_Close()
	this:Hide()
end

function HerosReturns_Awards_Frame_On_ResetPos()
  HerosReturns_Awards_FrameFull:SetProperty("UnifiedPosition", g_HerosReturns_Awards_Frame_UnifiedPosition);
end

function HerosReturns_Awards_On_SetLastPos()
	local CurUIPos = Variable:GetVariable("HerosReturnsUIPos")
	if( CurUIPos ~= nil) then
	    HerosReturns_Awards_FrameFull:SetProperty("UnifiedPosition", CurUIPos )
	end
end

