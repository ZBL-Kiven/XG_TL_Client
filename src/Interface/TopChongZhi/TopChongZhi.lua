local g_TopChongZhi_Frame_UnifiedYPosition;
local g_TopChongZhi_Frame_UnifiedYPosition;  
 --===============================================
-- 充值超值赠
--===============================================
local g_TopChongZhi_LoadFirstTime = 1 

local g_TopChongZhi_ButtonState = {
	[1] =0,
	[2] =0,
	[3] =0,
	[4] =0,
	[5] =0,
	[6] =0,
	[7] =0, 
};
--显示奖励物品配表
local g_TopChongZhi_Gifts = {
} 
local g_TopChongZhi_ICON = { 
}
local g_TopChongZhi_Text = { 
}
local g_TopChongZhi_Btn = { 
}
local g_TopChongZhi_GetGiftsCondition =
{
}
local g_TopChongZhi_Cost =0;
local g_TopChongZhi_Exch =0; 
local g_Object =0; 
local g_TopChongZhiObjId =0; 
local MAX_OBJ_DISTANCE = 3.0
-- 
local g_Fuli_LimitedSaveUp_GiftsImage = {
	[1] = {Set ="ZhizunHaoli" , Image = "ZhizunHaoli_1", },
	[2] = {Set ="ZhizunHaoli" , Image = "ZhizunHaoli_2", },
	[3] = {Set ="ZhizunHaoli" , Image = "ZhizunHaoli_3", },
	[4] = {Set ="ZhizunHaoli" , Image = "ZhizunHaoli_4", },
	[5] = {Set ="ZhizunHaoli" , Image = "ZhizunHaoli_5", },
	[6] = {Set ="ZhizunHaoli" , Image = "ZhizunHaoli_6", },
	[7] = {Set ="ZhizunHaoli" , Image = "ZhizunHaoli_7", }, 
}

function TopChongZhi_PreLoad()
	this:RegisterEvent("UI_COMMAND");
		-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED") 
	this:RegisterEvent("OBJECT_CARED_EVENT") 
	this:RegisterEvent("TOGLE_SYSTEMFRAME") 
end

function TopChongZhi_OnEvent(event) 
	if( event == "ADJEST_UI_POS" ) then
		TopChongZhi_ResetPos()
	elseif event == "TOGLE_SYSTEMFRAME" then
		if ( IsWindowShow( "TopChongZhi" ) == true ) then
			TopChongZhi_Close() 
		end 
	elseif( event == "VIEW_RESOLUTION_CHANGED" ) then
		TopChongZhi_ResetPos()
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		this:Hide()	
	elseif (event == "OBJECT_CARED_EVENT") then 
		if(tonumber(arg0) ~= g_TopChongZhi_obj) then
			return;
		end 
		--如果和商人的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			--取消关心
			SetDefaultMouse();  
			TopChongZhi_Close();
		end  
	elseif event == "PLAYER_LEAVE_WORLD" then
		TopChongZhi_Close()
	elseif ( event == "UI_COMMAND" and tonumber( arg0 ) == 18100001 ) then		 
		TopChongZhi_UpdateInfo() 
		-- if ( IsWindowShow( "TopChongZhi" ) == false ) then
			-- TopChongZhi_OnShown() 
		-- end 
	end
end

function TopChongZhi_OnLoad()  
	-- 保存界面的默认相对位置
	g_TopChongZhi_Frame_UnifiedXPosition	= TopChongZhi_Frame:GetProperty("UnifiedXPosition");
	g_TopChongZhi_Frame_UnifiedYPosition	= TopChongZhi_Frame:GetProperty("UnifiedYPosition"); 
end 

function TopChongZhi_OnShown() 
	this:Show();
end 
--================================================
-- 界面的默认相对位置
--================================================
function TopChongZhi_ResetPos()
	TopChongZhi_Frame:SetProperty("UnifiedXPosition", g_TopChongZhiFrame_UnifiedXPosition);
	TopChongZhi_Frame:SetProperty("UnifiedYPosition", g_TopChongZhi_Frame_UnifiedYPosition);
	g_TopChongZhi_ICON[1] = 
	{
		TopChongZhi_BaiBao_Frame3_Bk1_Icon1,
		TopChongZhi_BaiBao_Frame3_Bk1_Icon2,
		TopChongZhi_BaiBao_Frame3_Bk1_Icon3,
		TopChongZhi_BaiBao_Frame3_Bk1_Icon4
	};
	g_TopChongZhi_ICON[2] = 
	{
		TopChongZhi_BaiBao_Frame3_Bk2_Icon1,
		TopChongZhi_BaiBao_Frame3_Bk2_Icon2,
		TopChongZhi_BaiBao_Frame3_Bk2_Icon3,
		TopChongZhi_BaiBao_Frame3_Bk2_Icon4
	};
	g_TopChongZhi_ICON[3] = 
	{
		TopChongZhi_BaiBao_Frame3_Bk3_Icon1,
		TopChongZhi_BaiBao_Frame3_Bk3_Icon2,
		TopChongZhi_BaiBao_Frame3_Bk3_Icon3,
		TopChongZhi_BaiBao_Frame3_Bk3_Icon4
	};
	g_TopChongZhi_ICON[4] = 
	{
		TopChongZhi_BaiBao_Frame3_Bk4_Icon1,
		TopChongZhi_BaiBao_Frame3_Bk4_Icon2,
		TopChongZhi_BaiBao_Frame3_Bk4_Icon3,
		TopChongZhi_BaiBao_Frame3_Bk4_Icon4
	};
	g_TopChongZhi_ICON[5] = 
	{
		TopChongZhi_BaiBao_Frame3_Bk5_Icon1,
		TopChongZhi_BaiBao_Frame3_Bk5_Icon2,
		TopChongZhi_BaiBao_Frame3_Bk5_Icon3,
		TopChongZhi_BaiBao_Frame3_Bk5_Icon4
	};
	g_TopChongZhi_ICON[6] = 
	{
		TopChongZhi_BaiBao_Frame3_Bk6_Icon1,
		TopChongZhi_BaiBao_Frame3_Bk6_Icon2,
		TopChongZhi_BaiBao_Frame3_Bk6_Icon3,
		TopChongZhi_BaiBao_Frame3_Bk6_Icon4
	};
	g_TopChongZhi_ICON[7] = 
	{
		TopChongZhi_BaiBao_Frame3_Bk7_Icon1,
		TopChongZhi_BaiBao_Frame3_Bk7_Icon2,
		TopChongZhi_BaiBao_Frame3_Bk7_Icon3,
		TopChongZhi_BaiBao_Frame3_Bk7_Icon4
	};
	g_TopChongZhi_Text[1] = 
	{
		Exch= TopChongZhi_BaiBao_Frame3_Bk1_Text1_1,
		Cost= TopChongZhi_BaiBao_Frame3_Bk1_Text1_2,
	};
	g_TopChongZhi_Text[2] = 
	{
		Exch= TopChongZhi_BaiBao_Frame3_Bk2_Text1_1,
		Cost= TopChongZhi_BaiBao_Frame3_Bk2_Text1_2,
	};
	g_TopChongZhi_Text[3] = 
	{
		Exch= TopChongZhi_BaiBao_Frame3_Bk3_Text1_1,
		Cost= TopChongZhi_BaiBao_Frame3_Bk3_Text1_2,
	};
	g_TopChongZhi_Text[4] = 
	{
		Exch= TopChongZhi_BaiBao_Frame3_Bk4_Text1_1,
		Cost= TopChongZhi_BaiBao_Frame3_Bk4_Text1_2,
	};
	g_TopChongZhi_Text[5] = 
	{
		Exch= TopChongZhi_BaiBao_Frame3_Bk5_Text1_1,
		Cost= TopChongZhi_BaiBao_Frame3_Bk5_Text1_2,
	};
	g_TopChongZhi_Text[6] = 
	{
		Exch= TopChongZhi_BaiBao_Frame3_Bk6_Text1_1,
		Cost= TopChongZhi_BaiBao_Frame3_Bk6_Text1_2,
	};
	g_TopChongZhi_Text[7] = 
	{
		Exch= TopChongZhi_BaiBao_Frame3_Bk7_Text1_1,
		Cost= TopChongZhi_BaiBao_Frame3_Bk7_Text1_2,
	};
	g_TopChongZhi_Btn ={
		TopChongZhi_BaiBao_Frame3_Bk1_Button1,
		TopChongZhi_BaiBao_Frame3_Bk2_Button1,
		TopChongZhi_BaiBao_Frame3_Bk3_Button1,
		TopChongZhi_BaiBao_Frame3_Bk4_Button1,
		TopChongZhi_BaiBao_Frame3_Bk5_Button1,
		TopChongZhi_BaiBao_Frame3_Bk6_Button1,
		TopChongZhi_BaiBao_Frame3_Bk7_Button1,
	}
end 

function TopChongZhi_Close()
	-- StopCareObject_YuanbaoExchange()
	this:Hide();
end
 
function TopChongZhi_UpdateInfo()
	local acme_ItemList = {}
	for i = 1,7 do
		acme_ItemList[i] = Split(Get_XParam_STR(i-1),",")
		local nIndex = 0
		local LinShiData = {}
		for j = 1,table.getn(acme_ItemList[i]) do
			if acme_ItemList[i][nIndex*2+1] ~= nil and acme_ItemList[i][nIndex*2+1] ~= "" then
				table.insert(LinShiData,nIndex+1,{GiftItemID = tonumber(acme_ItemList[i][nIndex*2+1]) ,num = tonumber(acme_ItemList[i][nIndex*2+2])})
				nIndex = nIndex + 1
			end
		end
		table.insert(g_TopChongZhi_Gifts,i,LinShiData)
	end
	g_TopChongZhi_GetGiftsCondition = Split(Get_XParam_STR(7),",")
	for i = 1,7 do
		g_TopChongZhi_GetGiftsCondition[i] = tonumber(g_TopChongZhi_GetGiftsCondition[i])
	end
	-- g_TopChongZhiObjId	= Get_XParam_INT(0)
	g_TopChongZhi_Exch  = DataPool:GetPlayerMission_DataRound(475)
	-- g_TopChongZhi_Cost  = Get_XParam_INT(2)
	local acme_state = DataPool:GetPlayerMission_DataRound(476)
	local acme_value = {1,10,100,1000,10000,100000,1000000}
	for i=1,table.getn(g_TopChongZhi_ButtonState) do
		g_TopChongZhi_ButtonState[i] = math.mod(math.floor(acme_state/acme_value[i]),10)
	end
	-- TopChongZhi_BeginCareObject(Target:GetServerId2ClientId(g_TopChongZhiObjId))
	TopChongZhi_FlushWindow()
end

function TopChongZhi_BeginCareObject(objCaredId)
	g_Object = objCaredId;
	this:CareObject(g_Object, 1, "TopChongZhi")
end

--=========================================================
--停止对某NPC的关心
--=========================================================
function StopCareObject_YuanbaoExchange()
	if g_Object ~= -1 then
		this:CareObject(g_Object, 0, "TopChongZhi")
		g_Object = -1
	end
end

function TopChongZhi_FlushWindow() 
	TopChongZhi_CleanActionItemInfo()  
	for i = 1,  7 do  
		for j = 1,  table.getn(g_TopChongZhi_Gifts[i]) do 
			local GiftItemID	=	g_TopChongZhi_Gifts[i][j].GiftItemID
			local GiftItemNum	= 	g_TopChongZhi_Gifts[i][j].num
			local theAction 	= 	GemMelting:UpdateProductAction(GiftItemID)
			if theAction:GetID() ~= 0 then
				g_TopChongZhi_ICON[i][j]:SetActionItem(theAction:GetID())
				g_TopChongZhi_ICON[i][j]:Show()
				g_TopChongZhi_ICON[i][j]:SetProperty("CornerChar", string.format( "TopRight %s", GiftItemNum ));
			end
		end
 
		--未达成
		if g_TopChongZhi_ButtonState[i] == 0 then 
			if g_TopChongZhi_Exch < g_TopChongZhi_GetGiftsCondition[i] then
				local Text1 = string.format("#cff0000累计兑换：%s/%s元", g_TopChongZhi_Exch,g_TopChongZhi_GetGiftsCondition[i])
				g_TopChongZhi_Text[i].Exch:SetText(Text1)
			else
				local Text1 = string.format("#G累计兑换：%s/%s元", g_TopChongZhi_GetGiftsCondition[i],g_TopChongZhi_GetGiftsCondition[i])
				g_TopChongZhi_Text[i].Exch:SetText(Text1)
			end
			-- if g_TopChongZhi_Cost < g_TopChongZhi_GetGiftsCondition[i].Cost then
				-- local Text2 = string.format("#{XSJNH_180111_72}", g_TopChongZhi_Cost,g_TopChongZhi_GetGiftsCondition[i].Cost)
				-- g_TopChongZhi_Text[i].Cost:SetText(Text2)
			-- else
				-- local Text2 = string.format("#{XSJNH_180111_74}", g_TopChongZhi_GetGiftsCondition[i].Cost,g_TopChongZhi_GetGiftsCondition[i].Cost)
				-- g_TopChongZhi_Text[i].Cost:SetText(Text2)
			-- end 
			g_TopChongZhi_Btn[i]:SetProperty("DisabledImage", "set:XinShouNewBK image:XinShouNew_WDC") 
			g_TopChongZhi_Btn[i]:Disable()
		--可以领取
		elseif g_TopChongZhi_ButtonState[i] == 1 then 
			local Text1 = string.format("#G累计兑换：%s/%s元", g_TopChongZhi_GetGiftsCondition[i],g_TopChongZhi_GetGiftsCondition[i])
			g_TopChongZhi_Text[i].Exch:SetText(Text1)
			-- local Text2 = string.format("#{XSJNH_180111_74}", g_TopChongZhi_GetGiftsCondition[i].Cost,g_TopChongZhi_GetGiftsCondition[i].Cost)
			-- g_TopChongZhi_Text[i].Cost:SetText(Text2) 
			g_TopChongZhi_Btn[i]:Enable() 
			--g_TopChongZhi_Btn[i]:SetProperty("NormalImage", "set:ServerNewUI4 image:XinShouYueUI_GM_Normal")
			--g_TopChongZhi_Btn[i]:SetProperty("HoverImage",  "set:ServerNewUI4 image:XinShouYueUI_GM_Hover")
			--g_TopChongZhi_Btn[i]:SetProperty("PushedImage", "set:ServerNewUI4 image:XinShouYueUI_GM_Pushed")
		--已领取
		elseif g_TopChongZhi_ButtonState[i] == 2 then
			local Text1 = string.format("#G累计兑换：%s/%s元", g_TopChongZhi_GetGiftsCondition[i],g_TopChongZhi_GetGiftsCondition[i])
			g_TopChongZhi_Text[i].Exch:SetText(Text1)
			-- local Text2 = string.format("#{XSJNH_180111_74}", g_TopChongZhi_GetGiftsCondition[i].Cost,g_TopChongZhi_GetGiftsCondition[i].Cost)
			-- g_TopChongZhi_Text[i].Cost:SetText(Text2) 
			g_TopChongZhi_Btn[i]:SetProperty("DisabledImage", "set:XinShouNewBK image:XinShouNew_YLQ") 
			g_TopChongZhi_Btn[i]:Disable()
		end 
	end
	this:Show()
end

function TopChongZhi_CleanActionItemInfo() 
	for i = 1, table.getn(g_TopChongZhi_ICON) do
		for j = 1, table.getn(g_TopChongZhi_ICON[i]) do
			g_TopChongZhi_ICON[i][j]:SetActionItem(-1)
			g_TopChongZhi_ICON[i][j]:Hide()
		end 
	end 
end 

function TopChongZhi_BaiBao_Frame3_GetGift( Index )
	-- 执行脚本
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "YBCost_GetPrize" ); 	-- 脚本函数名称
		Set_XSCRIPT_ScriptID( 318319 );						-- 脚本编号
		Set_XSCRIPT_Parameter( 0, Index );					-- 参数一
		Set_XSCRIPT_ParamCount( 1 );						-- 参数个数
	Send_XSCRIPT()
end  
--===============================================
-- 充值超值赠 -end
--===============================================
