--Q546528533 仅供娱乐交流，切勿它用，请浏览后24小时内删除

local GOODS_BUTTONS_NUM = 12;
local GOODS_BUTTONS = {};
local GOODS_DESCS = {};
local GOODS_PRICE = {};
local GOOD_BAD    = {};
local GOOD_Animate    = {};

local g_Talent_Shop_nPageNum = 1;
local g_Talent_Shop_maxPage = 1;
local objCared = -1;
local g_ServerCareID = -1;

local MAX_OBJ_DISTANCE = 3.0;

--当前商店的商品数量
local	g_Talent_Shop_nTotalNum		= 0;
local	g_Talent_Shop_nCurItem		= 0;

local g_Talent_Shop_Frame_UnifiedPosition;

--===============================================
-- PreLoad
--===============================================
function Talent_Shop_PreLoad()

	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("OBJECT_CARED_EVENT");
	
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
end

--===============================================
-- OnLoad
--===============================================
function Talent_Shop_OnLoad()
	GOODS_BUTTONS[1] = Talent_Shop_Item1;
	GOODS_BUTTONS[2] = Talent_Shop_Item2;
	GOODS_BUTTONS[3] = Talent_Shop_Item3;
	GOODS_BUTTONS[4] = Talent_Shop_Item4;
	GOODS_BUTTONS[5] = Talent_Shop_Item5;
	GOODS_BUTTONS[6] = Talent_Shop_Item6;
	GOODS_BUTTONS[7] = Talent_Shop_Item7;
	GOODS_BUTTONS[8] = Talent_Shop_Item8;
	GOODS_BUTTONS[9] = Talent_Shop_Item9;
	GOODS_BUTTONS[10]= Talent_Shop_Item10;
	GOODS_BUTTONS[11]= Talent_Shop_Item11;
	GOODS_BUTTONS[12]= Talent_Shop_Item12;
	
	GOODS_DESCS[1] = Talent_Shop_ItemInfo1_Text;
	GOODS_DESCS[2] = Talent_Shop_ItemInfo2_Text;
	GOODS_DESCS[3] = Talent_Shop_ItemInfo3_Text;
	GOODS_DESCS[4] = Talent_Shop_ItemInfo4_Text;
	GOODS_DESCS[5] = Talent_Shop_ItemInfo5_Text;
	GOODS_DESCS[6] = Talent_Shop_ItemInfo6_Text;
	GOODS_DESCS[7] = Talent_Shop_ItemInfo7_Text;
	GOODS_DESCS[8] = Talent_Shop_ItemInfo8_Text;
	GOODS_DESCS[9] = Talent_Shop_ItemInfo9_Text;
	GOODS_DESCS[10]= Talent_Shop_ItemInfo10_Text;
	GOODS_DESCS[11]= Talent_Shop_ItemInfo11_Text;
	GOODS_DESCS[12]= Talent_Shop_ItemInfo12_Text;
	
	GOODS_PRICE[1] = Talent_Shop_ItemInfo1_Price;
	GOODS_PRICE[2] = Talent_Shop_ItemInfo2_Price;
	GOODS_PRICE[3] = Talent_Shop_ItemInfo3_Price;
	GOODS_PRICE[4] = Talent_Shop_ItemInfo4_Price;
	GOODS_PRICE[5] = Talent_Shop_ItemInfo5_Price;
	GOODS_PRICE[6] = Talent_Shop_ItemInfo6_Price;
	GOODS_PRICE[7] = Talent_Shop_ItemInfo7_Price;
	GOODS_PRICE[8] = Talent_Shop_ItemInfo8_Price;
	GOODS_PRICE[9] = Talent_Shop_ItemInfo9_Price;
	GOODS_PRICE[10]= Talent_Shop_ItemInfo10_Price;
	GOODS_PRICE[11]= Talent_Shop_ItemInfo11_Price;
	GOODS_PRICE[12]= Talent_Shop_ItemInfo12_Price;
	
	GOOD_BAD[1]  =     Talent_Shop_ItemInfo1_GB;
	GOOD_BAD[2]  =     Talent_Shop_ItemInfo2_GB;
	GOOD_BAD[3]  =     Talent_Shop_ItemInfo3_GB;
	GOOD_BAD[4]  =     Talent_Shop_ItemInfo4_GB;
	GOOD_BAD[5]  =     Talent_Shop_ItemInfo5_GB;
	GOOD_BAD[6]  =     Talent_Shop_ItemInfo6_GB;
	GOOD_BAD[7]  =     Talent_Shop_ItemInfo7_GB;
	GOOD_BAD[8]  =     Talent_Shop_ItemInfo8_GB;
	GOOD_BAD[9]  =     Talent_Shop_ItemInfo9_GB;
	GOOD_BAD[10] =     Talent_Shop_ItemInfo10_GB;
	GOOD_BAD[11] =     Talent_Shop_ItemInfo11_GB;
	GOOD_BAD[12] =     Talent_Shop_ItemInfo12_GB;
	
	GOOD_Animate[1] = Talent_Shop_Item1Animate
	GOOD_Animate[2] = Talent_Shop_Item2Animate
	GOOD_Animate[3] = Talent_Shop_Item3Animate
	GOOD_Animate[4] = Talent_Shop_Item4Animate
	GOOD_Animate[5] = Talent_Shop_Item5Animate
	GOOD_Animate[6] = Talent_Shop_Item6Animate
	GOOD_Animate[7] = Talent_Shop_Item7Animate
	GOOD_Animate[8] = Talent_Shop_Item8Animate
	GOOD_Animate[9] = Talent_Shop_Item9Animate
	GOOD_Animate[10] = Talent_Shop_Item10Animate
	GOOD_Animate[11] = Talent_Shop_Item11Animate
	GOOD_Animate[12] = Talent_Shop_Item12Animate
	
	 g_Talent_Shop_Frame_UnifiedPosition=Talent_Shop_Frame:GetProperty("UnifiedPosition");
	
end

--===============================================
-- OnEvent
--===============================================
function Talent_Shop_OnEvent(event)
	
	if ( event == "UI_COMMAND" and tonumber(arg0) == 89127101 ) then	
	
		if Get_XParam_INT( 0 ) <= 0 then
			Talent_Shop_Close()
			return
		end
		
		for i=1, GOODS_BUTTONS_NUM  do
			GOOD_BAD[i]:Hide()
			GOODS_PRICE[i]:Show();
		end
		
		g_Talent_Shop_nTotalNum	= 0;
		this:Show();

		--关心商人Obj
		g_ServerCareID = Get_XParam_INT(1)
		objCared = DataPool:GetNPCIDByServerID(g_ServerCareID);
		if( 0 > objCared ) then
			PushDebugMessage("server传过来的数据有问题。");
			return
		end
		this:CareObject(objCared, 1, "Talent_Shop");
		
		g_Talent_Shop_nTotalNum = Get_XParam_INT(2)
		g_Talent_Shop_nCurItem = Get_XParam_INT(3)
		local curPage = Get_XParam_INT(4)
		
		Talent_Shop_UpdatePage(curPage);
		
		OpenWindow("Packet")
		
		SetDefaultMouse();
		
	elseif (event == "OBJECT_CARED_EVENT") then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		
		--如果和商人的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			--取消关心
			SetDefaultMouse();
			this:CareObject(objCared, 0, "Talent_Shop");
			this:Hide();			
		end
			
	elseif (event == "ADJEST_UI_POS" ) then
		Talent_Shop_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		Talent_Shop_Frame_On_ResetPos()

	elseif ( event == "PLAYER_ENTERING_WORLD" ) then
		Talent_Shop_Close();
		
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		Talent_Shop_Close();
		
	end
	
end

--===============================================
-- UpdatePage
--===============================================
function Talent_Shop_UpdatePage(thePage)
	
	--使用什么作为货币
	for i=1, GOODS_BUTTONS_NUM  do
		GOOD_BAD[i]:Hide()
		GOODS_PRICE[i]:Show();
		GOOD_Animate[i]:Hide()
	end

	local i = 1;
		
	-- 计算总页数
	local nTotalPage;
	if( g_Talent_Shop_nTotalNum < 1 ) then
		nTotalPage = 1;
	else
		nTotalPage = math.floor((g_Talent_Shop_nTotalNum-1)/GOODS_BUTTONS_NUM)+1;
	end

	g_Talent_Shop_maxPage = nTotalPage;
	
	if(thePage < 1 or thePage > nTotalPage) then 
		return;	
	end
	
	g_Talent_Shop_nPageNum = thePage;

	local nStartIndex = (thePage-1)*GOODS_BUTTONS_NUM;

	local nActIndex = nStartIndex+1;
	i = 1;
	while i <= GOODS_BUTTONS_NUM do
		local nRet, itemid, itemnum, itemcost  = NpcShop:GetQianWuShopItemByIdx(nActIndex)
		if nRet == nil or nRet <= 0 then
			GOODS_BUTTONS[i]:SetActionItem(-1);
			GOODS_DESCS[i]:SetText("");
			GOODS_PRICE[i]:Hide();			
		else
			local theAction = DataPool:CreateBindActionItemForShow(itemid, itemnum)
			if theAction:GetID() ~= 0 then
				GOODS_BUTTONS[i]:SetActionItem(theAction:GetID());
				
				local item_name = DataPool:LuaFnGetItemNameByTableIndex(itemid)
				GOODS_DESCS[i]:SetText(item_name);
					
				GOODS_PRICE[i]:SetProperty("GoldIcon", "set:Button6 image:Lace_JiaoziJin")
				GOODS_PRICE[i]:SetProperty("SilverIcon", "set:Button6 image:Lace_JiaoziYin")
				GOODS_PRICE[i]:SetProperty("CopperIcon", "set:Button6 image:Lace_JiaoziTong")
				GOODS_PRICE[i]:SetProperty("MoneyNumber", tostring(itemcost))
				
				if DataPool:Lua_IsHaveMission(2035) > 0 then					
					if itemid == g_Talent_Shop_nCurItem then
						GOOD_Animate[i]:Show()
					end
				end
			else				
				GOODS_BUTTONS[i]:SetActionItem(-1);
				GOODS_DESCS[i]:SetText("");
				GOODS_PRICE[i]:Hide();		
			end
		end
				
		i = i + 1;	
		nActIndex = nActIndex+1;
	end
	
	if( nTotalPage == 1 ) then
		Talent_Shop_UpPage:Hide();
		Talent_Shop_DownPage:Hide();
		Talent_Shop_CurrentlyPage:Hide();
	else
		Talent_Shop_UpPage:Show();
		Talent_Shop_DownPage:Show();
		Talent_Shop_CurrentlyPage:Show();
		
		Talent_Shop_UpPage:Enable();
		Talent_Shop_DownPage:Enable();

		if ( g_Talent_Shop_nPageNum == nTotalPage ) then
			Talent_Shop_DownPage:Disable();
		end
		
		if ( g_Talent_Shop_nPageNum == 1 ) then
			Talent_Shop_UpPage:Disable()
		end

		Talent_Shop_CurrentlyPage:SetText(tostring(g_Talent_Shop_nPageNum) .. "/" .. tostring(nTotalPage) );
	end
end

--===============================================
-- Button_Clicked
--===============================================
function Talent_Shop_GoodButton_Clicked(nIndex)
	if(nIndex < 1 or nIndex > 12) then 
		return;
	end
	GOODS_BUTTONS[nIndex]:DoAction();
		
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("DoBuyFromShop")
		Set_XSCRIPT_ScriptID(891271)
		Set_XSCRIPT_Parameter( 0, g_ServerCareID )
		Set_XSCRIPT_Parameter( 1, g_Talent_Shop_nPageNum )
		Set_XSCRIPT_Parameter( 2, nIndex )
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
end

--===============================================
-- PageUp
--===============================================
function Talent_Shop_PageUp()
	local curPage = g_Talent_Shop_nPageNum - 1;
	if ( curPage < 0 )  then
		curPage = 1;
	end
	
	Talent_Shop_UpdatePage( curPage );
end

--===============================================
-- PageDown
--===============================================
function Talent_Shop_PageDown()
	local curPage = g_Talent_Shop_nPageNum + 1;
	
	if ( curPage >= g_Talent_Shop_maxPage ) then
		curPage = g_Talent_Shop_maxPage;
	end
	
	Talent_Shop_UpdatePage( curPage );
end

--===============================================
-- Close
--===============================================
function Talent_Shop_Close()
	
	SetDefaultMouse();
	
	--取消关心
	this:CareObject(objCared, 0, "Talent_Shop");
	
	this:Hide();
	
end

function Talent_Shop_Frame_On_ResetPos()
  Talent_Shop_Frame:SetProperty("UnifiedPosition", g_Talent_Shop_Frame_UnifiedPosition);
end

