
--***********************************
-- Q546528533 原创 高自由 高还原
-- 所有规则由服务端控制
--***********************************
local GOODS_BUTTONS_NUM = 12;
local GOODS_BUTTONS = {};
local GOODS_DESCS = {};
local GOODS_PRICE = {};
local GOOD_BAD    = {};
local BaiBaoShop_ItemMark    = {};
local BaiBaoShop_ItemText    = {};

local CALLBACK_BUTTON_FRAME = {};
local CALLBACK_BUTTON = {};

local objCared = -1;

local CU_MONEY			= 1	-- 钱
local CU_YUANBAO		= 5	-- 元宝
local CU_ZENGDIAN		= 6 -- 赠点

local BaiBaoShop_nInfo_1 = {}
local BaiBaoShop_nInfo_2 = {}
local BaiBaoShop_nInfo_3 = {}
local BaiBaoShop_nInfo_4 = {}

local MAX_OBJ_DISTANCE = 3.0;

--存储随机排序的索引值
local	g_tOrderPool	= {};
--当前商店的商品数量
local	g_nTotalNum		= 0;

--===============================================
-- PreLoad
--===============================================
function BaiBaoShop_PreLoad()
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
function BaiBaoShop_OnLoad()
	GOODS_BUTTONS[1] = BaiBaoShop_Item1;
	GOODS_BUTTONS[2] = BaiBaoShop_Item2;
	GOODS_BUTTONS[3] = BaiBaoShop_Item3;
	GOODS_BUTTONS[4] = BaiBaoShop_Item4;
	GOODS_BUTTONS[5] = BaiBaoShop_Item5;
	GOODS_BUTTONS[6] = BaiBaoShop_Item6;
	GOODS_BUTTONS[7] = BaiBaoShop_Item7;
	GOODS_BUTTONS[8] = BaiBaoShop_Item8;
	GOODS_BUTTONS[9] = BaiBaoShop_Item9;
	GOODS_BUTTONS[10]= BaiBaoShop_Item10;
	GOODS_BUTTONS[11]= BaiBaoShop_Item11;
	GOODS_BUTTONS[12]= BaiBaoShop_Item12;
	
	GOODS_DESCS[1] = BaiBaoShop_ItemInfo1_Text;
	GOODS_DESCS[2] = BaiBaoShop_ItemInfo2_Text;
	GOODS_DESCS[3] = BaiBaoShop_ItemInfo3_Text;
	GOODS_DESCS[4] = BaiBaoShop_ItemInfo4_Text;
	GOODS_DESCS[5] = BaiBaoShop_ItemInfo5_Text;
	GOODS_DESCS[6] = BaiBaoShop_ItemInfo6_Text;
	GOODS_DESCS[7] = BaiBaoShop_ItemInfo7_Text;
	GOODS_DESCS[8] = BaiBaoShop_ItemInfo8_Text;
	GOODS_DESCS[9] = BaiBaoShop_ItemInfo9_Text;
	GOODS_DESCS[10]= BaiBaoShop_ItemInfo10_Text;
	GOODS_DESCS[11]= BaiBaoShop_ItemInfo11_Text;
	GOODS_DESCS[12]= BaiBaoShop_ItemInfo12_Text;
	
	GOODS_PRICE[1] = BaiBaoShop_ItemInfo1_Price;
	GOODS_PRICE[2] = BaiBaoShop_ItemInfo2_Price;
	GOODS_PRICE[3] = BaiBaoShop_ItemInfo3_Price;
	GOODS_PRICE[4] = BaiBaoShop_ItemInfo4_Price;
	GOODS_PRICE[5] = BaiBaoShop_ItemInfo5_Price;
	GOODS_PRICE[6] = BaiBaoShop_ItemInfo6_Price;
	GOODS_PRICE[7] = BaiBaoShop_ItemInfo7_Price;
	GOODS_PRICE[8] = BaiBaoShop_ItemInfo8_Price;
	GOODS_PRICE[9] = BaiBaoShop_ItemInfo9_Price;
	GOODS_PRICE[10]= BaiBaoShop_ItemInfo10_Price;
	GOODS_PRICE[11]= BaiBaoShop_ItemInfo11_Price;
	GOODS_PRICE[12]= BaiBaoShop_ItemInfo12_Price;
	
	GOOD_BAD[1]  =     BaiBaoShop_ItemInfo1_GB;
	GOOD_BAD[2]  =     BaiBaoShop_ItemInfo2_GB;
	GOOD_BAD[3]  =     BaiBaoShop_ItemInfo3_GB;
	GOOD_BAD[4]  =     BaiBaoShop_ItemInfo4_GB;
	GOOD_BAD[5]  =     BaiBaoShop_ItemInfo5_GB;
	GOOD_BAD[6]  =     BaiBaoShop_ItemInfo6_GB;
	GOOD_BAD[7]  =     BaiBaoShop_ItemInfo7_GB;
	GOOD_BAD[8]  =     BaiBaoShop_ItemInfo8_GB;
	GOOD_BAD[9]  =     BaiBaoShop_ItemInfo9_GB;
	GOOD_BAD[10] =     BaiBaoShop_ItemInfo10_GB;
	GOOD_BAD[11] =     BaiBaoShop_ItemInfo11_GB;
	GOOD_BAD[12] =     BaiBaoShop_ItemInfo12_GB;
	
	CALLBACK_BUTTON[1] = BaiBaoShop_Callback1;
	CALLBACK_BUTTON[2] = BaiBaoShop_Callback2;
	CALLBACK_BUTTON[3] = BaiBaoShop_Callback3;
	CALLBACK_BUTTON[4] = BaiBaoShop_Callback4;
	CALLBACK_BUTTON[5] = BaiBaoShop_Callback5;
	
	CALLBACK_BUTTON_FRAME[1] = BaiBaoShop_Callback1_Frame;
	CALLBACK_BUTTON_FRAME[2] = BaiBaoShop_Callback2_Frame;
	CALLBACK_BUTTON_FRAME[3] = BaiBaoShop_Callback3_Frame;
	CALLBACK_BUTTON_FRAME[4] = BaiBaoShop_Callback4_Frame;
	CALLBACK_BUTTON_FRAME[5] = BaiBaoShop_Callback5_Frame;
	
	for i = 1,12 do
	    BaiBaoShop_ItemMark[i] = _G[string.format("BaiBaoShop_Item%d_Mask",i)]
	    BaiBaoShop_ItemText[i] = _G[string.format("BaiBaoShop_Item%d_Text",i)]
	end
	
    BaiBaoShop_querengoumai_Text:SetText("购买确认")	
    BaiBaoShop_Text:SetText("#gFF0FA0帮贡商店")	
end

--===============================================
-- OnEvent
--===============================================
function BaiBaoShop_OnEvent(event)
	if ( event == "PLAYER_ENTERING_WORLD" ) then
		Booth_Close();
		-- 显示经验
	end

	if ( event == "UI_COMMAND" and arg0 == "20201124" ) then
        local xx = Get_XParam_INT(0)
		local ZheKouLevel = Get_XParam_INT(1)
		BaiBaoShop_Info_Text:SetText("#W帮贡可通过帮会任务获得")
        objCared = DataPool:GetNPCIDByServerID(xx)
		if objCared == -1 then
			PushDebugMessage("server传过来的数据有问题。")
			return
		end
        BaiBaoShop_nInfo_1,BaiBaoShop_nInfo_2,BaiBaoShop_nInfo_3,BaiBaoShop_nInfo_4 = {},{},{},{}	
        BaiBaoShop_Update(Get_XParam_STR(0),Get_XParam_STR(1),Get_XParam_STR(2),Get_XParam_STR(3))	
		this:Show()		
	elseif ( event == "UI_COMMAND" and arg0 == "120201124" ) then --刷新
	    BaiBaoShop_nInfo_1,BaiBaoShop_nInfo_2,BaiBaoShop_nInfo_3,BaiBaoShop_nInfo_4 = {},{},{},{}
	    BaiBaoShop_Update(Get_XParam_STR(0),Get_XParam_STR(1),Get_XParam_STR(2),Get_XParam_STR(3))		
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
function BaiBaoShop_Update(Server_1,Server_2,Server_3,Server_4)
    local ServerData = {Server_1,Server_2,Server_3,Server_4}
	-- BaiBaoShop_nInfo_1
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
		    BaiBaoShop_nInfo_1[i] = tonumber(nItemIndex[1][i])
		end
	    if nItemIndex[2][i] ~= nil and nItemIndex[2][i] ~= "" then
		    BaiBaoShop_nInfo_2[i] = tonumber(nItemIndex[2][i])
		end	    
	    if nItemIndex[3][i] ~= nil and nItemIndex[3][i] ~= "" then
		    BaiBaoShop_nInfo_3[i] = tonumber(nItemIndex[3][i])
		end	    
	    if nItemIndex[4][i] ~= nil and nItemIndex[4][i] ~= "" then
		    BaiBaoShop_nInfo_4[i] = tonumber(nItemIndex[4][i])
		end	    
	end
	BaiBaoShop_UpdatePage()
end
--===============================================
-- UpdatePage
--===============================================
function BaiBaoShop_UpdatePage()
	for i=1, GOODS_BUTTONS_NUM  do
		GOOD_BAD[i]:Hide()
		BaiBaoShop_ItemMark[i]:Hide()
		BaiBaoShop_ItemText[i]:Hide()
		GOODS_PRICE[i]:Hide();
		GOODS_BUTTONS[i]:SetActionItem(-1);
		GOODS_BUTTONS[i]:Disable()
		GOODS_DESCS[i]:SetText("");
		GOODS_PRICE[i]:SetText("");
		GOOD_BAD[i]:SetText("");
	end   	
	for i = 1,table.getn(BaiBaoShop_nInfo_1) do		
		--物品显示
		local theAction = GemMelting:UpdateProductAction(BaiBaoShop_nInfo_1[i])
		if theAction:GetID() ~= 0 then
		    GOODS_DESCS[i]:SetText( "#Y"..theAction:GetName() );
			GOODS_BUTTONS[i]:SetActionItem(theAction:GetID());
			GOODS_BUTTONS[i]:Enable()
			--使用什么作为货币
			if BaiBaoShop_nInfo_3[i] == 1 then
			    BaiBaoShop_ItemText[i]:Hide()
			else
			    BaiBaoShop_ItemText[i]:Show()
			    BaiBaoShop_ItemText[i]:SetText(BaiBaoShop_nInfo_3[i])
			end			
			if BaiBaoShop_nInfo_3[i] == 0 then
			    BaiBaoShop_ItemMark[i]:Show()
				GOODS_BUTTONS[i]:Disable()
			end
			if BaiBaoShop_nInfo_2[i] == 1 then
            	GOOD_BAD[i]:SetText("元宝:" .. tostring(BaiBaoShop_nInfo_4[i]))	
                GOOD_BAD[i]:Show()				
			elseif BaiBaoShop_nInfo_2[i] == 3 then
			    GOOD_BAD[i]:SetText("绑定元宝:" .. tostring(BaiBaoShop_nInfo_4[i]))
				GOOD_BAD[i]:Show()
			elseif BaiBaoShop_nInfo_2[i] == 4 then
			    GOOD_BAD[i]:SetText("帮贡:" .. tostring(BaiBaoShop_nInfo_4[i]))
				GOOD_BAD[i]:Show()
			elseif BaiBaoShop_nInfo_2[i] == 2 then
				GOODS_PRICE[i]:SetProperty("GoldIcon", "set:Button6 image:Lace_JiaoziJin")
				GOODS_PRICE[i]:SetProperty("SilverIcon", "set:Button6 image:Lace_JiaoziYin")
				GOODS_PRICE[i]:SetProperty("CopperIcon", "set:Button6 image:Lace_JiaoziTong")
			    GOODS_PRICE[i]:SetProperty("MoneyNumber", tostring(BaiBaoShop_nInfo_4[i]))
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
	this:CareObject(objCared, 0, "BaiBaoShop");
	this:Hide();
end

--===============================================
-- Goods_Clicked
--===============================================
function BaiBaoShop_Clicked(nIndex)
	if nIndex < 1 or nIndex > 12 then
	    return
	end
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("BuyBangGongShopItem"); 
		Set_XSCRIPT_ScriptID(805011);		
		Set_XSCRIPT_Parameter(0,nIndex);
		Set_XSCRIPT_ParamCount(1);
	Send_XSCRIPT()	
end

