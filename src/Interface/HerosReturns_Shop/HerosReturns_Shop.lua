--HerosReturns_Shop.lua
local g_HerosReturns_Shop_Frame_UnifiedPosition

local HerosReturns_Shop_BuyItem_Num = {}
local g_HerosReturns_Shop_ItemNumMax = 999

local g_HerosReturns_Shop_FenYe={};
local g_HerosReturns_Shop_RedPoint={};
local g_HerosReturns_Shop_RedPointState = {0,0,0}

local g_HerosReturns_IsHuiliu = 0

local g_HerosReturns_Shop_ActionButton = {}
local g_HerosReturns_Shop_ScrollBar = {}

local g_HerosReturns_Shop_Limit_MD = {}
local g_HerosReturns_Shop_Limit_Count = 0

local g_HerosReturns_Shop_LeftTime = 0;
local g_HerosReturns_Shop_HYDaibi = 0;

--预加载函数，可以而且只能在这里注册脚本关心的事件
function HerosReturns_Shop_PreLoad()
	this:RegisterEvent("UI_COMMAND");

	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")	--进场景关闭界面
end

--加载窗口的时候调用的函数，加载窗口时调用一次
function HerosReturns_Shop_OnLoad()
	g_HerosReturns_Shop_Frame_UnifiedPosition = HerosReturns_Shop_FrameFull:GetProperty("UnifiedPosition")
	
	g_HerosReturns_Shop_FenYe[1] = HerosReturns_Shop_Buttontab01;
	g_HerosReturns_Shop_FenYe[2] = HerosReturns_Shop_Buttontab02;
	g_HerosReturns_Shop_FenYe[3] = HerosReturns_Shop_Buttontab03;
	
	g_HerosReturns_Shop_RedPoint[1] = HerosReturns_Shop_Buttontab01_tips;
	g_HerosReturns_Shop_RedPoint[2] = HerosReturns_Shop_Buttontab02_tips;
	g_HerosReturns_Shop_RedPoint[3] = HerosReturns_Shop_Buttontab03_tips;
	
end

--响应事件的函数，当注册的事件发生时会调用的函数
function HerosReturns_Shop_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0)== 80811003 ) then
		if(IsWindowShow("YuanbaoShop")) then
			CloseWindow("YuanbaoShop", true)
		end
		
		g_HerosReturns_Shop_LeftTime = Get_XParam_INT(1)
		g_HerosReturns_Shop_HYDaibi = Get_XParam_INT(2)
			
		HerosReturns_Shop_Update()
		HerosReturns_Shop_UpdateDaibi()
		HerosReturns_Shop_On_SetLastPos();
		this:Show()
		
		return
		
	elseif ( event == "UI_COMMAND" and tonumber( arg0 ) == 80811006 and this:IsVisible() ) then
		HerosReturns_Shop_Close()
		
	elseif (event == "UI_COMMAND" and tonumber( arg0 ) == 80811005 and this:IsVisible()) then
		--红点
		g_HerosReturns_Shop_RedPointState[1] = Get_XParam_INT( 0 )
		g_HerosReturns_Shop_RedPointState[2] = Get_XParam_INT( 1 )
		g_HerosReturns_Shop_RedPointState[3] = Get_XParam_INT( 2 )
		HerosReturns_Shop_UpdateRedPoint()	
		
	elseif (event == "UI_COMMAND" and tonumber( arg0 ) == 80811031 and this:IsVisible()) then
		g_HerosReturns_Shop_Limit_Count = Get_XParam_INT_Count()
		for i = 1, g_HerosReturns_Shop_Limit_Count do
			g_HerosReturns_Shop_Limit_MD[i] = Get_XParam_INT(i-1)
		end	
		HerosReturns_Shop_UpdateItemLimit()	
		
	elseif (event == "UI_COMMAND" and tonumber( arg0 ) == 80811032 and this:IsVisible()) then
		g_HerosReturns_Shop_HYDaibi = Get_XParam_INT(0)
		HerosReturns_Shop_UpdateDaibi()

	elseif (event == "ADJEST_UI_POS" ) then
		HerosReturns_Shop_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		HerosReturns_Shop_Frame_On_ResetPos()
		
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		HerosReturns_Shop_Close()
	end
end

--=========================================================
--更新界面
--=========================================================
function HerosReturns_Shop_Update()

	-- 刷新按钮状态
	g_HerosReturns_Shop_FenYe[1]:SetProperty("Selected", "False")
	g_HerosReturns_Shop_FenYe[2]:SetProperty("Selected", "False")
	g_HerosReturns_Shop_FenYe[3]:SetProperty("Selected", "True")
	
	-- 刷新剩余时间 
	local nLeftTime = tonumber(g_HerosReturns_Shop_LeftTime);
	if nLeftTime > 0 then
		local nDay = math.floor(nLeftTime / (3600 * 24));
		local nHour = math.ceil( math.mod( nLeftTime, 3600*24)/ 3600 )
		
		HerosReturns_ShopText2:SetText( ScriptGlobal_Format("#{HJHL_201224_29}", nDay, nHour) );
		HerosReturns_ShopText2:Show();
	end
	
	for i = 1, table.getn(g_HerosReturns_Shop_ActionButton) do
		if g_HerosReturns_Shop_ActionButton[i] ~= nil then
			g_HerosReturns_Shop_ActionButton[i]:SetActionItem(-1)
			g_HerosReturns_Shop_ActionButton[i] = nil
		end
	end
	
	for i = 1, table.getn(g_HerosReturns_Shop_ScrollBar) do
		if g_HerosReturns_Shop_ScrollBar[i] ~= nil then
			g_HerosReturns_Shop_ScrollBar[i] = nil
		end
	end
	--DataPool:ClearActionItemForShow()	
	HerosReturns_Shop_Lace:Clear()
	
	local nCount = GetHerosReturnsShopItemCount()

	for i = 1, nCount do
		--第一列
		local bar1 = HerosReturns_Shop_Lace:AddChild("HerosReturns_Shop_CoinAItem1")
		if not bar1 then
    	break
  	end
		local nIndex, nItemId, nItemShowId, nItemNum, nCredit, nLimit = GetHerosReturnsShopItem(i)
		if nIndex == nil or nItemShowId == nil then
			break;
		end
		local theAction = DataPool:CreateActionItemForShow(nItemShowId, nItemNum)
		if theAction:GetID() ~= 0 then
			local oActionBtn = bar1:GetSubItem("HerosReturns_Shop_CoinAItem1_Icon");
			if oActionBtn ~= nil then
				oActionBtn:SetActionItem( theAction:GetID() );
				g_HerosReturns_Shop_ActionButton[i] = oActionBtn
				oActionBtn:SetEvent( "Clicked", string.format("HerosReturns_Shop_ActionItem_Clicked(%d)", nIndex))
			end
		end
		bar1:GetSubItem("HerosReturns_Shop_CoinAItem1_Name"):SetText("#G"..theAction:GetName())
		bar1:GetSubItem("HerosReturns_Shop_CoinAItem1_Cost"):SetText(ScriptGlobal_Format("#{HJHL_201224_57}", nCredit))
		
		bar1:GetSubItem("HerosReturns_Shop_CoinAItem1_IconMark"):Hide()
		bar1:GetSubItem("HerosReturns_Shop_CoinAItem1_Num"):Hide()
		g_HerosReturns_Shop_ScrollBar[i] = bar1
	end
	
end


--刷新代币数
function HerosReturns_Shop_UpdateDaibi()

	HerosReturns_ShopText3:SetText(ScriptGlobal_Format("#{HJHL_201224_54}", g_HerosReturns_Shop_HYDaibi))

end

--刷新限购
function HerosReturns_Shop_UpdateItemLimit()
	--限购次数
	for i = 1, table.getn(g_HerosReturns_Shop_ScrollBar) do
		if g_HerosReturns_Shop_ScrollBar[i] ~= nil then
			local nIndex, nItemId, nItemShowId, nItemNum, nCredit, nLimit = GetHerosReturnsShopItem(i)
			if nIndex == nil or nItemShowId == nil or nLimit == nil then
				break;
			end
						
			local nBuyCnt = HerosReturns_Shop_GetLimitCount(nIndex)
			--PushDebugMessage("LLL.."..nIndex.." "..nBuyCnt.." "..nLimit)
			local str = ScriptGlobal_Format("#{HJHL_201224_58}", nLimit-nBuyCnt, nLimit)
			if nBuyCnt >= nLimit then
				g_HerosReturns_Shop_ScrollBar[i]:GetSubItem("HerosReturns_Shop_CoinAItem1_IconMark"):Show()
				g_HerosReturns_Shop_ScrollBar[i]:GetSubItem("HerosReturns_Shop_CoinAItem1_Num"):Show()
				g_HerosReturns_Shop_ScrollBar[i]:GetSubItem("HerosReturns_Shop_CoinAItem1_Num"):SetText("#cFF0000"..str)
			else
				g_HerosReturns_Shop_ScrollBar[i]:GetSubItem("HerosReturns_Shop_CoinAItem1_IconMark"):Hide()
				g_HerosReturns_Shop_ScrollBar[i]:GetSubItem("HerosReturns_Shop_CoinAItem1_Num"):Show()
				g_HerosReturns_Shop_ScrollBar[i]:GetSubItem("HerosReturns_Shop_CoinAItem1_Num"):SetText("#G"..str)
			end
		end
	end
end

--获取物品已兑换数
function HerosReturns_Shop_GetLimitCount(nIndex)
	if nIndex < 1 then
		return -1
	end 	
	
	local MDData = nil
	for i = 1, table.getn(g_HerosReturns_Shop_Limit_MD) do
		if nIndex > 3*(i-1) and nIndex <= 3*i then
			MDData = g_HerosReturns_Shop_Limit_MD[i]
			break
		end
	end

	local ret = -1
	if MDData ~= nil then
		local temp = math.mod(nIndex-1, 3) --0,1,2
		if temp == 0 then
			ret = math.mod(MDData, 1000)
		elseif temp == 1 then
			ret = math.mod(math.floor(MDData/1000), 1000)
		elseif temp == 2 then
			ret = math.mod(math.floor(MDData/1000000),1000)
		end
	end
	
	return ret
end


function HerosReturns_Shop_ActionItem_Clicked( index )
	local nCount = GetHerosReturnsShopItemCount()
	if index < 1 or index > nCount then
		return
	end
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "OnBuyShopItem" )
		Set_XSCRIPT_ScriptID(808110)
		Set_XSCRIPT_Parameter(0,index)
		Set_XSCRIPT_Parameter(1,0)
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()

end

--刷新红点
function HerosReturns_Shop_UpdateRedPoint()

	for i = 1, 3 do
		if g_HerosReturns_Shop_RedPointState[i] == 1 then
			g_HerosReturns_Shop_RedPoint[i]:Show()
		else
			g_HerosReturns_Shop_RedPoint[i]:Hide()
		end
	end
	
end

--页面切换 1、归来礼馈 2、江湖告令 3、荣归阁
function HerosReturns_Shop_FenYe_Clicked(index)
	if index < 1 or index > 3 then
		return
	end
	
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "OnOpenUI" ); 		-- 脚本号
		Set_XSCRIPT_ScriptID( 808110 );						-- 脚本编号
		Set_XSCRIPT_Parameter(0, index)
		Set_XSCRIPT_ParamCount( 1 );						-- 参数个数
	Send_XSCRIPT()
	
	
	Variable:SetVariable("HerosReturnsUIPos", HerosReturns_Shop_FrameFull:GetProperty("UnifiedPosition"), 1)
end

function HerosReturns_Shop_OnHidden()
	for i = 1, table.getn(g_HerosReturns_Shop_ActionButton) do
		if g_HerosReturns_Shop_ActionButton[i] ~= nil then
			g_HerosReturns_Shop_ActionButton[i]:SetActionItem(-1)
			g_HerosReturns_Shop_ActionButton[i] = nil
		end
	end
	for i = 1, table.getn(g_HerosReturns_Shop_ScrollBar) do
		if g_HerosReturns_Shop_ScrollBar[i] ~= nil then
			g_HerosReturns_Shop_ScrollBar[i] = nil
		end
	end
	HerosReturns_Shop_Lace:Clear()
	Variable:SetVariable("HerosReturnsUIPos", HerosReturns_Shop_FrameFull:GetProperty("UnifiedPosition"), 1)
end

function HerosReturns_Shop_Close()
	this:Hide()
end

function HerosReturns_Shop_Frame_On_ResetPos()
  HerosReturns_Shop_FrameFull:SetProperty("UnifiedPosition", g_HerosReturns_Shop_Frame_UnifiedPosition);
end

function HerosReturns_Shop_On_SetLastPos()
	local CurUIPos = Variable:GetVariable("HerosReturnsUIPos")
	if( CurUIPos ~= nil) then
	    HerosReturns_Shop_FrameFull:SetProperty("UnifiedPosition", CurUIPos )
	end
end
