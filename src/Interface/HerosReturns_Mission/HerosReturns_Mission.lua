--HerosReturns_Mission.lua
local g_HerosReturns_Mission_Frame_UnifiedPosition

local g_HerosReturns_Mission_FenYe={};
local g_HerosReturns_Mission_RedPoint={};
local g_HerosReturns_Mission_RedPointState = {0,0,0}

local g_HerosReturns_Mission_Day_FenYe={};
local g_HerosReturns_Mission_Day_RedPoint={};
local g_HerosReturns_Mission_Day_RedPointState={};
local g_HerosReturns_Mission_LastClickedId = -1;
local g_HerosReturns_Mission_PrizeFlag = -1;
local g_HerosReturns_Mission_Day_FinishNum={};

local g_HerosReturns_Mission_ActionButton = {}

--预加载函数，可以而且只能在这里注册脚本关心的事件
function HerosReturns_Mission_PreLoad()
	this:RegisterEvent("UI_COMMAND");

	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")	--进场景关闭界面
end

--加载窗口的时候调用的函数，加载窗口时调用一次
function HerosReturns_Mission_OnLoad()
	g_HerosReturns_Mission_Frame_UnifiedPosition = HerosReturns_Mission_FrameFull:GetProperty("UnifiedPosition")
	
	g_HerosReturns_Mission_FenYe[1] = HerosReturns_Mission_Buttontab01;
	g_HerosReturns_Mission_FenYe[2] = HerosReturns_Mission_Buttontab02;
	g_HerosReturns_Mission_FenYe[3] = HerosReturns_Mission_Buttontab03;
	
	g_HerosReturns_Mission_RedPoint[1] = HerosReturns_Mission_Buttontab01_tips;
	g_HerosReturns_Mission_RedPoint[2] = HerosReturns_Mission_Buttontab02_tips;
	g_HerosReturns_Mission_RedPoint[3] = HerosReturns_Mission_Buttontab03_tips;
	
	g_HerosReturns_Mission_Day_FenYe[1] = HerosReturns_Mission_Day1;
	g_HerosReturns_Mission_Day_FenYe[2] = HerosReturns_Mission_Day2;
	g_HerosReturns_Mission_Day_FenYe[3] = HerosReturns_Mission_Day3;
	g_HerosReturns_Mission_Day_FenYe[4] = HerosReturns_Mission_Day4;
	g_HerosReturns_Mission_Day_FenYe[5] = HerosReturns_Mission_Day5;
	g_HerosReturns_Mission_Day_FenYe[6] = HerosReturns_Mission_Day6;
	g_HerosReturns_Mission_Day_FenYe[7] = HerosReturns_Mission_Day7;
	
	g_HerosReturns_Mission_Day_RedPoint[1] = HerosReturns_Mission_Day1_tips;
	g_HerosReturns_Mission_Day_RedPoint[2] = HerosReturns_Mission_Day2_tips;
	g_HerosReturns_Mission_Day_RedPoint[3] = HerosReturns_Mission_Day3_tips;
	g_HerosReturns_Mission_Day_RedPoint[4] = HerosReturns_Mission_Day4_tips;
	g_HerosReturns_Mission_Day_RedPoint[5] = HerosReturns_Mission_Day5_tips;
	g_HerosReturns_Mission_Day_RedPoint[6] = HerosReturns_Mission_Day6_tips;
	g_HerosReturns_Mission_Day_RedPoint[7] = HerosReturns_Mission_Day7_tips;

end

--响应事件的函数，当注册的事件发生时会调用的函数
function HerosReturns_Mission_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0)== 80811002 ) then
		if(IsWindowShow("YuanbaoShop")) then
			CloseWindow("YuanbaoShop", true)
		end
		
		local nDefaultDay = Get_XParam_INT( 1 )
		local nLeftTime = Get_XParam_INT( 2 )
		local nCurDaibi = Get_XParam_INT( 3 )
		g_HerosReturns_Mission_PrizeFlag = Get_XParam_INT( 4 )
		local nCount = Get_XParam_INT( 5 )
		for i=1, nCount do
			g_HerosReturns_Mission_Day_FinishNum[i] = Get_XParam_INT( 5 + i )
		end
		
		HerosReturns_Mission_Open( nDefaultDay, nLeftTime, nCurDaibi )
		HerosReturns_Mission_On_SetLastPos()
		
	elseif ( event == "UI_COMMAND" and tonumber( arg0 ) == 80811006 and this:IsVisible() ) then
		HerosReturns_Mission_Close()
				
	elseif ( event == "UI_COMMAND" and tonumber(arg0)== 80811021 and this:IsVisible() ) then
		local nDay = Get_XParam_INT( 0 )
		if nDay <= 0 then
			nDay = g_HerosReturns_Mission_LastClickedId;
		else
			local nLeftTime = Get_XParam_INT( 1 )
			local nCurDaibi = Get_XParam_INT( 2 )
			g_HerosReturns_Mission_PrizeFlag = Get_XParam_INT( 3 )
			local nCount = Get_XParam_INT( 4 )
			for i=1, nCount do
				g_HerosReturns_Mission_Day_FinishNum[i] = Get_XParam_INT( 4 + i )
			end
		
			HerosReturns_Mission_UpdateTimeAndDaibi( nDay, nLeftTime, nCurDaibi )	
		end
		
		HerosReturns_Mission_OnSwitchPage( nDay )
		
		
	elseif (event == "UI_COMMAND" and tonumber( arg0 ) == 80811005 and this:IsVisible()) then
		--红点
		g_HerosReturns_Mission_RedPointState[1] = Get_XParam_INT( 0 )
		g_HerosReturns_Mission_RedPointState[2] = Get_XParam_INT( 1 )
		g_HerosReturns_Mission_RedPointState[3] = Get_XParam_INT( 2 )
		for i=1, 7 do
			g_HerosReturns_Mission_Day_RedPointState[i] = Get_XParam_INT( 2 + i )
		end
		HerosReturns_Mission_UpdateRedPoint()	

	elseif (event == "ADJEST_UI_POS" ) then
		HerosReturns_Mission_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		HerosReturns_Mission_Frame_On_ResetPos()
		
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		HerosReturns_Mission_Close()
	end
end

--===============================================
-- Open()
--===============================================
function  HerosReturns_Mission_Open( nDefaultDay, nLeftTime, nCurDaibi )

	-- 刷新按钮状态
	g_HerosReturns_Mission_FenYe[1]:SetProperty("Selected", "False")
	g_HerosReturns_Mission_FenYe[2]:SetProperty("Selected", "True")
	g_HerosReturns_Mission_FenYe[3]:SetProperty("Selected", "False")
	
	if nDefaultDay < 1 then
		nDefaultDay = 1
	end	
	if nDefaultDay > 7 then
		nDefaultDay = 7
	end	
	
	HerosReturns_Mission_UpdateTimeAndDaibi( nDefaultDay, nLeftTime, nCurDaibi )
	HerosReturns_Mission_OnSwitchPage( nDefaultDay )
	
end

function HerosReturns_Mission_UpdateTimeAndDaibi( nDefaultDay, nLeftTime, nCurDaibi )
	-- 剩余时间
	nLeftTime = tonumber(nLeftTime);
	if nLeftTime > 0 then
		local nDay = math.floor(nLeftTime / (3600 * 24));
		local nHour = math.ceil( math.mod( nLeftTime, 3600*24)/ 3600 )
		
		HerosReturns_MissionText2:SetText( ScriptGlobal_Format("#{HJHL_201224_29}", nDay, nHour) );
		HerosReturns_MissionText2:Show();
	end
	
	HerosReturns_Mission_Text2:SetText( ScriptGlobal_Format("#{HJHL_201224_40}", nCurDaibi) );
end

function HerosReturns_Mission_OnSwitchPage( nDay )
	
	-- 刷新按钮状态
	for i=1, 7 do
		if i==nDay then
			g_HerosReturns_Mission_Day_FenYe[i]:SetProperty("Selected", "True")
		else
			g_HerosReturns_Mission_Day_FenYe[i]:SetProperty("Selected", "False")
		end
	end
		
	for i = 1, table.getn(g_HerosReturns_Mission_ActionButton) do
		if g_HerosReturns_Mission_ActionButton[i] ~= nil then
			g_HerosReturns_Mission_ActionButton[i]:SetActionItem(-1)
			g_HerosReturns_Mission_ActionButton[i] = nil
		end
	end
	HerosReturns_Mission_Lace:Clear()
	
	local sortData={};
				
	-- 提取数据
	local nCount = GetHerosReturnsRoadCountByDay( nDay-1 )  --需要新接口
	for i=1, nCount do
		
		local nIndex, Desc,TargetNum,BounsNum,Isspecial,Image1,Image2,nType,param0,param1,param2 = GetHerosReturnsRoadInfo(nDay-1, i-1)
		if nIndex < 0 then
			break;
		end
		
		local nFinishNum = g_HerosReturns_Mission_Day_FinishNum[i];
		if nFinishNum == nil or nFinishNum < 0 then
			nFinishNum = 0;
		end
		
		local bGotPrize = HerosReturns_Mission_GetPrizeFlag( i-1 );
		
		sortData[i] = {};
		sortData[i].nDayIdx = i;
		sortData[i].nIndex = nIndex;
		sortData[i].Desc = Desc;
		sortData[i].TargetNum = TargetNum;
		sortData[i].BounsNum = BounsNum;
		sortData[i].Image1 = Image1;
		sortData[i].Image2 = Image2;
		sortData[i].nType = nType;
		sortData[i].nFinishNum = nFinishNum;
		sortData[i].bGotPrize = bGotPrize;
		
	end
	
	-- 排序
	sortData = HerosReturns_Mission_SortUI( sortData );
	
	-- 显示
	for i=1, nCount do
	
		if sortData[i] == nil then
			break;
		end
		
		--第一列
		local bar1 = HerosReturns_Mission_Lace:AddChild("HerosReturns_Mission_CoinAItem")
		if not bar1 then
    	break
  	end
				
		-- 图片更换
		bar1:GetSubItem("HerosReturns_Mission_CoinAItem_Icon"):SetProperty("Image", "set:"..sortData[i].Image1.." image:"..sortData[i].Image2);
		
		bar1:GetSubItem("HerosReturns_Mission_CoinAItemText"):SetText( sortData[i].Desc );

		bar1:GetSubItem("HerosReturns_Mission_CoinAItemText2"):SetText( ScriptGlobal_Format("#{HJHL_201224_42}", sortData[i].nFinishNum, sortData[i].TargetNum) );		
		bar1:GetSubItem("HerosReturns_Mission_CoinAItemText3"):SetText( ScriptGlobal_Format("#{HJHL_201224_43}", sortData[i].BounsNum) );
		
		-- 图片更换
		if sortData[i].nFinishNum >= sortData[i].TargetNum then
			if sortData[i].bGotPrize > 0 then 	-- 已领取
				bar1:GetSubItem("HerosReturns_Mission_CoinAItemButton"):SetProperty("DisabledImage", "set:XinShouNewBK image:XinShouNew_YLQ");	
				bar1:GetSubItem("HerosReturns_Mission_CoinAItemButton"):Disable();
			else	-- 领取
				bar1:GetSubItem("HerosReturns_Mission_CoinAItemButton"):Enable();
			end
			bar1:GetSubItem("HerosReturns_Mission_CoinAItemButton"):SetEvent( "Clicked", string.format("HerosReturns_Mission_GetPrize_Clicked(%d)", sortData[i].nIndex))
			bar1:GetSubItem("HerosReturns_Mission_CoinAItemGoto"):Hide();
			bar1:GetSubItem("HerosReturns_Mission_CoinAItemButton"):Show();
		else
			if sortData[i].nType > 0 then	--前往
				bar1:GetSubItem("HerosReturns_Mission_CoinAItemGoto"):SetEvent( "Clicked", string.format("HerosReturns_Mission_GoTo_Clicked(%d,%d)", nDay-1, sortData[i].nDayIdx-1))
				bar1:GetSubItem("HerosReturns_Mission_CoinAItemGoto"):Show();
				bar1:GetSubItem("HerosReturns_Mission_CoinAItemButton"):Hide();
			else	-- 未达成
				bar1:GetSubItem("HerosReturns_Mission_CoinAItemButton"):SetProperty("DisabledImage", "set:XinShouNewBK image:XinShouNew_WDC");	
				bar1:GetSubItem("HerosReturns_Mission_CoinAItemButton"):SetEvent( "Clicked", string.format("HerosReturns_Mission_GetPrize_Clicked(%d)", sortData[i].nIndex))
				bar1:GetSubItem("HerosReturns_Mission_CoinAItemButton"):Disable();
				bar1:GetSubItem("HerosReturns_Mission_CoinAItemButton"):Show();
				bar1:GetSubItem("HerosReturns_Mission_CoinAItemGoto"):Hide();
			end
		end
		
	end
	
	g_HerosReturns_Mission_LastClickedId = nDay;
	this:Show()
end

function HerosReturns_Mission_GetPrizeFlag( index )
	local nFlag = math.floor( g_HerosReturns_Mission_PrizeFlag / math.pow(10, index) )
	return math.mod( nFlag, 10 )
end

function HerosReturns_Mission_SortUI( sortData )

	local newSortData={};
	local newIndex = 1;
	local nCount = table.getn(sortData)
	-- 领取
	for i=1, nCount do
		if sortData[i] ~= nil and sortData[i].nFinishNum >= sortData[i].TargetNum and sortData[i].bGotPrize <= 0 then
			newSortData[newIndex] = sortData[i];
			newIndex = newIndex + 1;
			sortData[i] = nil;
		end
	end
	
	-- 前往
	for i=1, nCount do
		if sortData[i] ~= nil and sortData[i].nFinishNum < sortData[i].TargetNum then
			newSortData[newIndex] = sortData[i];
			newIndex = newIndex + 1;
			sortData[i] = nil;
		end
	end
	
	-- 已完成
	for i=1, nCount do
		if sortData[i] ~= nil and sortData[i].bGotPrize > 0 then
			newSortData[newIndex] = sortData[i];
			newIndex = newIndex + 1;
			sortData[i] = nil;
		end
	end
	
	return newSortData;
	
end

function HerosReturns_Mission_Day_Clicked( nDay )
	if nDay <1 or nDay > 7 then
		return
	end
	
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("OnAskHeroesRoadInfo");
		Set_XSCRIPT_ScriptID(808110);
		Set_XSCRIPT_Parameter(0,nDay)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT();
end

function HerosReturns_Mission_GetPrize_Clicked( index )
	
	Clear_XSCRIPT()
				Set_XSCRIPT_Function_Name("OnGetGaoLingPrize")
				Set_XSCRIPT_ScriptID(808110)
				Set_XSCRIPT_Parameter(0,index)
				Set_XSCRIPT_ParamCount(1)
			Send_XSCRIPT()
end

function HerosReturns_Mission_GoTo_Clicked( nDay, nDayIdx )

	-- 检查回流状态
	--提示 HJHL_201224_46

	local nIndex, Desc,TargetNum,BounsNum,Isspecial,Image1,Image2,nType,param0,param1,param2 = GetHerosReturnsRoadInfo(nDay, nDayIdx)
	if nIndex < 0 then
		return
	end
	
	--固定场景坐标的自动寻路
	if nType == 2 then
		AutoRunToTargetEx(param1,param2,param0)
	end
end

--刷新红点
function HerosReturns_Mission_UpdateRedPoint()

	for i = 1, 3 do
		if g_HerosReturns_Mission_RedPointState[i] == 1 then
			g_HerosReturns_Mission_RedPoint[i]:Show()
		else
			g_HerosReturns_Mission_RedPoint[i]:Hide()
		end
	end
		
	for i=1, 7 do
		if g_HerosReturns_Mission_Day_RedPointState[i] == 1 then
			g_HerosReturns_Mission_Day_RedPoint[i]:Show()
		else
			g_HerosReturns_Mission_Day_RedPoint[i]:Hide()
		end
	end
	
end

--页面切换 1、归来礼馈 2、江湖告令 3、荣归阁
function HerosReturns_Mission_FenYe_Clicked(index)
	if index < 1 or index > 3 then
		return
	end
	
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "OnOpenUI" ); 		-- 脚本号
		Set_XSCRIPT_ScriptID( 808110 );						-- 脚本编号
		Set_XSCRIPT_Parameter(0, index)
		Set_XSCRIPT_ParamCount( 1 );						-- 参数个数
	Send_XSCRIPT()
	
	
	Variable:SetVariable("HerosReturnsUIPos", HerosReturns_Mission_FrameFull:GetProperty("UnifiedPosition"), 1)
end

function HerosReturns_Mission_OnClickHelp()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "OnShowHelp" ); 		-- 脚本号
		Set_XSCRIPT_ScriptID( 808110 );						-- 脚本编号
		Set_XSCRIPT_Parameter(0, 1)
		Set_XSCRIPT_ParamCount( 1 );						-- 参数个数
	Send_XSCRIPT()
end

function HerosReturns_Mission_Close()
	this:Hide()
end

function HerosReturns_Mission_OnHidden()
	for i = 1, table.getn(g_HerosReturns_Mission_ActionButton) do
		if g_HerosReturns_Mission_ActionButton[i] ~= nil then
			g_HerosReturns_Mission_ActionButton[i]:SetActionItem(-1)
			g_HerosReturns_Mission_ActionButton[i] = nil
		end
	end
	HerosReturns_Mission_Lace:Clear()
	g_HerosReturns_Mission_Day_FinishNum = {};
	g_HerosReturns_Mission_LastClickedId = -1;
	Variable:SetVariable("HerosReturnsUIPos", HerosReturns_Mission_FrameFull:GetProperty("UnifiedPosition"), 1)
end

function HerosReturns_Mission_Frame_On_ResetPos()
  HerosReturns_Mission_FrameFull:SetProperty("UnifiedPosition", g_HerosReturns_Mission_Frame_UnifiedPosition);
end

function HerosReturns_Mission_On_SetLastPos()
	local CurUIPos = Variable:GetVariable("HerosReturnsUIPos")
	if( CurUIPos ~= nil) then
	    HerosReturns_Mission_FrameFull:SetProperty("UnifiedPosition", CurUIPos )
	end
end
