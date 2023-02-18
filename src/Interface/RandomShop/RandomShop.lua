
--***********************************
-- Q546528533 原创 高自由 高还原
-- 所有规则由服务端控制
--***********************************
local GOODS_BUTTONS_NUM = 12;
local GOODS_BUTTONS = {};
local GOODS_DESCS = {};
local GOODS_PRICE = {};
local GOOD_BAD    = {};
local RandomShop_ItemMark    = {};
local RandomShop_ItemText    = {};

local CALLBACK_BUTTON_FRAME = {};
local CALLBACK_BUTTON = {};

local objCared = -1;

local CU_MONEY			= 1	-- 钱
local CU_YUANBAO		= 5	-- 元宝
local CU_ZENGDIAN		= 6 -- 赠点

local RandomShop_nInfo_1 = {}
local RandomShop_nInfo_2 = {}
local RandomShop_nInfo_3 = {}
local RandomShop_nInfo_4 = {}

local MAX_OBJ_DISTANCE = 3.0;

--存储随机排序的索引值
local	g_tOrderPool	= {};
--当前商店的商品数量
local	g_nTotalNum		= 0;

--===============================================
-- PreLoad
--===============================================
function RandomShop_PreLoad()
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("OPEN_BOOTH");
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("UPDATE_BOOTH");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("CLOSE_BOOTH");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
end

--===============================================
-- OnLoad
--===============================================
function RandomShop_OnLoad()
	GOODS_BUTTONS[1] = RandomShop_Item1;
	GOODS_BUTTONS[2] = RandomShop_Item2;
	GOODS_BUTTONS[3] = RandomShop_Item3;
	GOODS_BUTTONS[4] = RandomShop_Item4;
	GOODS_BUTTONS[5] = RandomShop_Item5;
	GOODS_BUTTONS[6] = RandomShop_Item6;
	GOODS_BUTTONS[7] = RandomShop_Item7;
	GOODS_BUTTONS[8] = RandomShop_Item8;
	GOODS_BUTTONS[9] = RandomShop_Item9;
	GOODS_BUTTONS[10]= RandomShop_Item10;
	GOODS_BUTTONS[11]= RandomShop_Item11;
	GOODS_BUTTONS[12]= RandomShop_Item12;
	
	GOODS_DESCS[1] = RandomShop_ItemInfo1_Text;
	GOODS_DESCS[2] = RandomShop_ItemInfo2_Text;
	GOODS_DESCS[3] = RandomShop_ItemInfo3_Text;
	GOODS_DESCS[4] = RandomShop_ItemInfo4_Text;
	GOODS_DESCS[5] = RandomShop_ItemInfo5_Text;
	GOODS_DESCS[6] = RandomShop_ItemInfo6_Text;
	GOODS_DESCS[7] = RandomShop_ItemInfo7_Text;
	GOODS_DESCS[8] = RandomShop_ItemInfo8_Text;
	GOODS_DESCS[9] = RandomShop_ItemInfo9_Text;
	GOODS_DESCS[10]= RandomShop_ItemInfo10_Text;
	GOODS_DESCS[11]= RandomShop_ItemInfo11_Text;
	GOODS_DESCS[12]= RandomShop_ItemInfo12_Text;
	
	GOODS_PRICE[1] = RandomShop_ItemInfo1_Price;
	GOODS_PRICE[2] = RandomShop_ItemInfo2_Price;
	GOODS_PRICE[3] = RandomShop_ItemInfo3_Price;
	GOODS_PRICE[4] = RandomShop_ItemInfo4_Price;
	GOODS_PRICE[5] = RandomShop_ItemInfo5_Price;
	GOODS_PRICE[6] = RandomShop_ItemInfo6_Price;
	GOODS_PRICE[7] = RandomShop_ItemInfo7_Price;
	GOODS_PRICE[8] = RandomShop_ItemInfo8_Price;
	GOODS_PRICE[9] = RandomShop_ItemInfo9_Price;
	GOODS_PRICE[10]= RandomShop_ItemInfo10_Price;
	GOODS_PRICE[11]= RandomShop_ItemInfo11_Price;
	GOODS_PRICE[12]= RandomShop_ItemInfo12_Price;
	
	GOOD_BAD[1]  =     RandomShop_ItemInfo1_GB;
	GOOD_BAD[2]  =     RandomShop_ItemInfo2_GB;
	GOOD_BAD[3]  =     RandomShop_ItemInfo3_GB;
	GOOD_BAD[4]  =     RandomShop_ItemInfo4_GB;
	GOOD_BAD[5]  =     RandomShop_ItemInfo5_GB;
	GOOD_BAD[6]  =     RandomShop_ItemInfo6_GB;
	GOOD_BAD[7]  =     RandomShop_ItemInfo7_GB;
	GOOD_BAD[8]  =     RandomShop_ItemInfo8_GB;
	GOOD_BAD[9]  =     RandomShop_ItemInfo9_GB;
	GOOD_BAD[10] =     RandomShop_ItemInfo10_GB;
	GOOD_BAD[11] =     RandomShop_ItemInfo11_GB;
	GOOD_BAD[12] =     RandomShop_ItemInfo12_GB;
	
	CALLBACK_BUTTON[1] = RandomShop_Callback1;
	CALLBACK_BUTTON[2] = RandomShop_Callback2;
	CALLBACK_BUTTON[3] = RandomShop_Callback3;
	CALLBACK_BUTTON[4] = RandomShop_Callback4;
	CALLBACK_BUTTON[5] = RandomShop_Callback5;
	
	CALLBACK_BUTTON_FRAME[1] = RandomShop_Callback1_Frame;
	CALLBACK_BUTTON_FRAME[2] = RandomShop_Callback2_Frame;
	CALLBACK_BUTTON_FRAME[3] = RandomShop_Callback3_Frame;
	CALLBACK_BUTTON_FRAME[4] = RandomShop_Callback4_Frame;
	CALLBACK_BUTTON_FRAME[5] = RandomShop_Callback5_Frame;
	
	for i = 1,12 do
	    RandomShop_ItemMark[i] = _G[string.format("RandomShop_Item%d_Mask",i)]
	    RandomShop_ItemText[i] = _G[string.format("RandomShop_Item%d_Text",i)]
	end
	
    RandomShop_querengoumai_Text:SetText("购买确认")	
    RandomShop_Text:SetText("#gFF0FA0神秘商人")	
end

--===============================================
-- OnEvent
--===============================================
function RandomShop_OnEvent(event)
	if ( event == "PLAYER_ENTERING_WORLD" ) then
		Booth_Close();
		-- 显示经验
	end

	if ( event == "UI_COMMAND" and arg0 == "20201117" ) then
        local xx = Get_XParam_INT(0)
        objCared = DataPool:GetNPCIDByServerID(xx)
		if objCared == -1 then
			PushDebugMessage("server传过来的数据有问题。")
			return
		end
        RandomShop_nInfo_1,RandomShop_nInfo_2,RandomShop_nInfo_3,RandomShop_nInfo_4 = {},{},{},{}	
        RandomShop_Update(Get_XParam_STR(0),Get_XParam_STR(1),Get_XParam_STR(2),Get_XParam_STR(3))	
		this:Show()		
	elseif ( event == "UI_COMMAND" and arg0 == "120201117" ) then --刷新
	    RandomShop_nInfo_1,RandomShop_nInfo_2,RandomShop_nInfo_3,RandomShop_nInfo_4 = {},{},{},{}
	    RandomShop_Update(Get_XParam_STR(0),Get_XParam_STR(1),Get_XParam_STR(2),Get_XParam_STR(3))		
	elseif (event == "OBJECT_CARED_EVENT") then
		if(tonumber(arg0) ~= objCared) then
			return;
		end		
		--如果和商人的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			Booth_Close()			
		end	
	end
end
--===============================================
-- 服务端数据解析
--===============================================
function RandomShop_Update(Server_1,Server_2,Server_3,Server_4)
    local ServerData = {Server_1,Server_2,Server_3,Server_4}
	-- RandomShop_nInfo_1
    --解析开始
    --解析ID开始
	
	local nItemIndex = {}
	for i = 1,4 do
	    nItemIndex[i] = Split(ServerData[i], ",")
	end
	for i = 1,50 do
	    --减少循环提高效率
	    if nItemIndex[1][i] == nil or nItemIndex[1][i] == "" then
		    break
		end
	    if nItemIndex[1][i] ~= nil and nItemIndex[1][i] ~= "" then
		    RandomShop_nInfo_1[i] = tonumber(nItemIndex[1][i])
		end
	    if nItemIndex[2][i] ~= nil and nItemIndex[2][i] ~= "" then
		    RandomShop_nInfo_2[i] = tonumber(nItemIndex[2][i])
		end	    
	    if nItemIndex[3][i] ~= nil and nItemIndex[3][i] ~= "" then
		    RandomShop_nInfo_3[i] = tonumber(nItemIndex[3][i])
		end	    
	    if nItemIndex[4][i] ~= nil and nItemIndex[4][i] ~= "" then
		    RandomShop_nInfo_4[i] = tonumber(nItemIndex[4][i])
		end	    
	end
	RandomShop_UpdatePage()
end
--===============================================
-- UpdatePage
--===============================================
function RandomShop_UpdatePage()
	for i=1, GOODS_BUTTONS_NUM  do
		GOOD_BAD[i]:Hide()
		RandomShop_ItemMark[i]:Hide()
		RandomShop_ItemText[i]:Hide()
		GOODS_PRICE[i]:Hide();
		GOODS_BUTTONS[i]:SetActionItem(-1);
		GOODS_BUTTONS[i]:Disable()
		GOODS_DESCS[i]:SetText("");
		GOODS_PRICE[i]:SetText("");
		GOOD_BAD[i]:SetText("");
	end   	
	for i = 1,table.getn(RandomShop_nInfo_1) do		
		--物品显示
		local theAction = GemMelting:UpdateProductAction(RandomShop_nInfo_1[i])
		if theAction:GetID() ~= 0 then
		    GOODS_DESCS[i]:SetText( "#Y"..theAction:GetName() );
			GOODS_BUTTONS[i]:SetActionItem(theAction:GetID());
			GOODS_BUTTONS[i]:Enable()
			--使用什么作为货币
			if RandomShop_nInfo_3[i] == 1 then
			    RandomShop_ItemText[i]:Hide()
			else
			    RandomShop_ItemText[i]:Show()
			    RandomShop_ItemText[i]:SetText(RandomShop_nInfo_3[i])
			end			
			if RandomShop_nInfo_3[i] == 0 then
			    RandomShop_ItemMark[i]:Show()
				GOODS_BUTTONS[i]:Disable()
			end
			if RandomShop_nInfo_2[i] == 1 then
            	GOOD_BAD[i]:SetText("元宝:" .. tostring(RandomShop_nInfo_4[i]))	
                GOOD_BAD[i]:Show()				
			elseif RandomShop_nInfo_2[i] == 3 then
			    GOOD_BAD[i]:SetText("绑定元宝:" .. tostring(RandomShop_nInfo_4[i]))
				GOOD_BAD[i]:Show()
			elseif RandomShop_nInfo_2[i] == 2 then
				GOODS_PRICE[i]:SetProperty("GoldIcon", "set:Button2 image:Icon_GoldCoin")
				GOODS_PRICE[i]:SetProperty("SilverIcon", "set:Button2 image:Icon_SilverCoin")
				GOODS_PRICE[i]:SetProperty("CopperIcon", "set:Button2 image:Icon_CopperCoin")
			    GOODS_PRICE[i]:SetProperty("MoneyNumber", tostring(RandomShop_nInfo_4[i]))
                GOODS_PRICE[i]:Show()				
			end
		end
	end
end

--===============================================
-- Close
--===============================================
function Booth_Close()
	--取消关心
	this:CareObject(objCared, 0, "RandomShop");
	this:Hide();
end

--===============================================
-- Goods_Clicked
--===============================================
function RandomShop_Clicked(nIndex)
	if nIndex < 1 or nIndex > 12 then
	    return
	end
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("BuyRandomShop"); 
		Set_XSCRIPT_ScriptID(900013);		
		Set_XSCRIPT_Parameter(0,nIndex);
		Set_XSCRIPT_ParamCount(1);
	Send_XSCRIPT()	
end

