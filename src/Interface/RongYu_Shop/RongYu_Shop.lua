local objCared = -1
local g_obj_target = -1
local MAX_OBJ_DISTANCE 	 = 3.0
local g_clientNpcId


local g_RongYuItemName={}
local g_RongYuItemIntr1={}
local g_RongYuItemIntr2={}
local g_RongYuSellOut={}


local g_RongYuItemActionSet={}
local g_AutoClick_FunList = {}

local g_CurSelect = 0
local g_CurPage = 1
local g_CntPerPage = 12
local g_AutoClick_BtnFlag=-1
local g_AutoClick_Going = -1
local g_CurType = 0


local GOODS_BUTTONS_NUM = 12;
local GOODS_BUTTONS = {};
local GOODS_DESCS = {};
local GOODS_PRICE = {};
local GOOD_BAD    = {};


local g_RongYu_Shop_Frame_UnifiedPosition
function RongYu_Shop_PreLoad()
	this:RegisterEvent("UI_COMMAND",true)
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)	
	this:RegisterEvent("OBJECT_CARED_EVENT",false)
	this:RegisterEvent("UPDATE_RONGYU",false)
	this:RegisterEvent("UPDATE_RYSHOP",false)
end


function RongYu_Shop_OnLoad()
	
	GOODS_BUTTONS[1] = RongYu_Shop_Item1;
	GOODS_BUTTONS[2] = RongYu_Shop_Item2;
	GOODS_BUTTONS[3] = RongYu_Shop_Item3;
	GOODS_BUTTONS[4] = RongYu_Shop_Item4;
	GOODS_BUTTONS[5] = RongYu_Shop_Item5;
	GOODS_BUTTONS[6] = RongYu_Shop_Item6;
	GOODS_BUTTONS[7] = RongYu_Shop_Item7;
	GOODS_BUTTONS[8] = RongYu_Shop_Item8;
	GOODS_BUTTONS[9] = RongYu_Shop_Item9;
	GOODS_BUTTONS[10]= RongYu_Shop_Item10;
	GOODS_BUTTONS[11]= RongYu_Shop_Item11;
	GOODS_BUTTONS[12]= RongYu_Shop_Item12;
	
	GOODS_DESCS[1] = RongYu_Shop_ItemInfo1_Text;
	GOODS_DESCS[2] = RongYu_Shop_ItemInfo2_Text;
	GOODS_DESCS[3] = RongYu_Shop_ItemInfo3_Text;
	GOODS_DESCS[4] = RongYu_Shop_ItemInfo4_Text;
	GOODS_DESCS[5] = RongYu_Shop_ItemInfo5_Text;
	GOODS_DESCS[6] = RongYu_Shop_ItemInfo6_Text;
	GOODS_DESCS[7] = RongYu_Shop_ItemInfo7_Text;
	GOODS_DESCS[8] = RongYu_Shop_ItemInfo8_Text;
	GOODS_DESCS[9] = RongYu_Shop_ItemInfo9_Text;
	GOODS_DESCS[10]= RongYu_Shop_ItemInfo10_Text;
	GOODS_DESCS[11]= RongYu_Shop_ItemInfo11_Text;
	GOODS_DESCS[12]= RongYu_Shop_ItemInfo12_Text;
	
	GOODS_PRICE[1] = RongYu_Shop_ItemInfo1_Price;
	GOODS_PRICE[2] = RongYu_Shop_ItemInfo2_Price;
	GOODS_PRICE[3] = RongYu_Shop_ItemInfo3_Price;
	GOODS_PRICE[4] = RongYu_Shop_ItemInfo4_Price;
	GOODS_PRICE[5] = RongYu_Shop_ItemInfo5_Price;
	GOODS_PRICE[6] = RongYu_Shop_ItemInfo6_Price;
	GOODS_PRICE[7] = RongYu_Shop_ItemInfo7_Price;
	GOODS_PRICE[8] = RongYu_Shop_ItemInfo8_Price;
	GOODS_PRICE[9] = RongYu_Shop_ItemInfo9_Price;
	GOODS_PRICE[10]= RongYu_Shop_ItemInfo10_Price;
	GOODS_PRICE[11]= RongYu_Shop_ItemInfo11_Price;
	GOODS_PRICE[12]= RongYu_Shop_ItemInfo12_Price;
	
	GOOD_BAD[1]  =     RongYu_Shop_ItemInfo1_GB;
	GOOD_BAD[2]  =     RongYu_Shop_ItemInfo2_GB;
	GOOD_BAD[3]  =     RongYu_Shop_ItemInfo3_GB;
	GOOD_BAD[4]  =     RongYu_Shop_ItemInfo4_GB;
	GOOD_BAD[5]  =     RongYu_Shop_ItemInfo5_GB;
	GOOD_BAD[6]  =     RongYu_Shop_ItemInfo6_GB;
	GOOD_BAD[7]  =     RongYu_Shop_ItemInfo7_GB;
	GOOD_BAD[8]  =     RongYu_Shop_ItemInfo8_GB;
	GOOD_BAD[9]  =     RongYu_Shop_ItemInfo9_GB;
	GOOD_BAD[10] =     RongYu_Shop_ItemInfo10_GB;
	GOOD_BAD[11] =     RongYu_Shop_ItemInfo11_GB;
	GOOD_BAD[12] =     RongYu_Shop_ItemInfo12_GB;

	g_RongYu_Shop_Frame_UnifiedPosition=RongYu_Shop_Frame:GetProperty("UnifiedPosition");
end

function RongYu_Shop_OnEvent(event)
	if 	 event == "UI_COMMAND" and tonumber(arg0) == 502023 then	
		g_CurSelect = 1
		g_obj_target = Get_XParam_INT(0)
		objCared = DataPool : GetNPCIDByServerID(g_obj_target); --targetid ：客户端
		RongYu_Shop_BeginCareObject()
		RongYu_Shop_Clear()
		RongYu_Shop_OnShow()
	        this:Show()


	elseif ( event == "OBJECT_CARED_EVENT") then
		RongYu_Shop_CareEvent(arg0,arg1,arg2)
	elseif (event == "ADJEST_UI_POS") then
		RongYu_Shop_Frame_On_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		RongYu_Shop_Frame_On_ResetPos()
	elseif (event == "UPDATE_RONGYU") then
		RongYu_Shop_RYUpdate()
	elseif (event == "UPDATE_RYSHOP") then
		RongYu_Shop_OnShow()
	elseif event == "HIDE_ON_SCENE_TRANSED" then
		RongYuTitle_OnClosed()
		RongYu_Shop_StopCareObject()
	end
end

function RongYu_Shop_OnShow()
	if this:IsVisible() == 0 then
		return
	end
	-- RongYu_Shop_querengoumai:Show()
	-- local check  = tonumber(RongYu_Shop_querengoumai:GetCheck())
	-- if check >= 1 then
	-- 	RongYu_Shop_querengoumai:SetCheck(0)
	-- else
	-- 	RongYu_Shop_querengoumai:SetCheck(1)
	-- end

	for i = 1, GOODS_BUTTONS_NUM do
		GOOD_BAD[i]:Show()
		GOODS_PRICE[i]:Hide()
	end

	RongYu_Shop_BeginCareObject()

	RongYu_Shop_RYUpdate()
	local TotalCnt= RongYuUI:GetRongYuShopItemNum()
	local nTotalPage=math.ceil(TotalCnt/g_CntPerPage)
	local nStartIdx=(g_CurPage-1)*g_CntPerPage

	local uiIdx=1
	for i=nStartIdx,nStartIdx+g_CntPerPage-1 do

		local theAction, isSoldOut = RongYuUI:EnumRongYuShop( i );
		if theAction:GetID() ~= 0 then

			GOODS_BUTTONS[uiIdx]:SetActionItem(theAction:GetID());
			local contribute = RongYuUI:GetRongYuShopInfo( i, "price" )
			local nStr = ScriptGlobal_Format("#{XSLDZ_210128_32}",contribute)
			GOOD_BAD[uiIdx]:SetText(nStr)
			GOODS_PRICE[uiIdx]:Hide()
			GOODS_DESCS[uiIdx]:SetText(theAction:GetName());	
		else
			GOODS_BUTTONS[uiIdx]:SetActionItem(-1);
			GOODS_DESCS[uiIdx]:SetText("");
			GOODS_PRICE[uiIdx]:Hide()
			GOOD_BAD[uiIdx]:SetText("")
		end
		uiIdx=uiIdx+1
	end
	
	
end


function RongYu_Shop_CareEvent(arg0,arg1,arg2)
	local ObjCaredID = tonumber(arg0)
	if( ObjCaredID ~= g_ObjCareID) then
		return
	end
	local ObjDistance = tonumber(arg2)
	if( (arg1 == "distance" and ObjDistance>MAX_OBJ_DISTANCE) or arg1=="destroy") then
		RongYu_Shop_Hide()
	end
end

function RongYu_Shop_OnClose()
	RongYu_Shop_Hide()
end

function RongYu_Shop_Hide()
	RongYu_Shop_Clear()
	g_clientNpcId=-1
	this:Hide()
end


function RongYu_Shop_Buy(name)
	if g_CurSelect == 0 then
		--PushDebugMessage("#{FBZZ_180505_14}")
		return
	end
	
	local nItemIdx=g_CurSelect+(g_CurPage-1)*g_CntPerPage
	local nRealIdx=(g_CurPage-1)*g_CntPerPage + g_CurSelect - 1

	local theAction, isSoldOut = RongYuUI:EnumRongYuShop(nRealIdx)
	if isSoldOut == 0 and theAction:GetID() ~= 0 then
		PushDebugMessage("#{XSLDZ_180521_218}")
		return
	end

	-- local check  = tonumber(RongYu_Shop_querengoumai:GetCheck())
	-- if 1 == check then
	-- 	local contribute = RongYuUI:GetRongYuShopInfo( nRealIdx, "price" )	
	-- 	PushEvent("RONGYU_BUY_ITEM_CONFIRM",tostring(name),nItemIdx-1,contribute)
	-- else
		RongYuUI:DoRongYuShopBuy(nItemIdx-1, 1)
	-- end
	
end

function RongYu_Shop_Frame_On_ResetPos()
	RongYu_Shop_Frame:SetProperty("UnifiedPosition", g_RongYu_Shop_Frame_UnifiedPosition);
end

function RongYu_Shop_RYUpdate()
	local zg = Player:GetData("RONGYU")
	local nStr = ScriptGlobal_Format("#{XSLDZ_210128_23}",zg)
	RongYu_Shop_Total_Text:SetText(nStr)
end



--=========================================================
--开始关心NPC
--=========================================================
function RongYu_Shop_BeginCareObject()
	if objCared ~= -1 then
		this:CareObject(objCared, 0, "RongYu_Shop");
	end
	this:CareObject(objCared, 1, "RongYu_Shop")
end

--=========================================================
--停止对某NPC的关心
--=========================================================
function RongYu_Shop_StopCareObject()
	if objCared ~= -1 then
		this:CareObject(objCared, 0, "RongYu_Shop");
		objCared = -1;
	end
end



-- function RongYu_Shop_querengoumai_Clicked()
-- 	local check =RongYu_Shop_querengoumai:GetCheck() 

-- 	if(RongYu_Shop_querengoumai:GetCheck() == 0)then
-- 		RongYu_Shop_querengoumai:SetCheck(0)
-- 	else
-- 		RongYu_Shop_querengoumai:SetCheck(1)
-- 	end
-- end

function RongYu_Shop_ItemClicked(nIndex)
	if(nIndex < 1 or nIndex > 12) then
		return
	end
				
	local nRealIdx=(g_CurPage-1)*g_CntPerPage + nIndex - 1
	local theAction, isSoldOut = RongYuUI:EnumRongYuShop(nRealIdx);

	if theAction:GetID() ~= 0 then
		--?è??ActionItem
		g_CurSelect = nIndex
		RongYu_Shop_Buy(theAction:GetName())
	end

end
function RongYu_Shop_Clear()
	g_CurPage = 1
	SetDefaultMouse()
end
