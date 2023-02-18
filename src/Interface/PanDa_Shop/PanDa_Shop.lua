--熊猫商店
local PanDa_Shop_Frame_UnifiedPosition;

local g_RewardStep1 = 
{
	[1] = {itemId = 30502002, num = 4,},
	[2] = {itemId = 30503133, num = 2,},
	[3] = {itemId = 30700241, num = 2,},
	[4] = {itemId = 20800013, num = 4,},
	[5] = {itemId = 38002524, num = 2,},
}

local g_RewardStep2 = 
{
	[1] = {itemId = 38002551, num = 1,},
	[2] = {itemId = 50313004, num = 1,},
	[3] = {itemId = 38002551, num = 1,},
	[4] = {itemId = 38002221, num = 1,},
	[5] = {itemId = 38002551, num = 1,},
	[6] = {itemId = 38002536, num = 1,},
	[7] = {itemId = 20501003, num = 1,},
	[8] = {itemId = 20502003, num = 1,},
}

local g_Button1 = {}
local g_Button2 = {}
local g_MaskOK1 = {}
local g_MaskOK2 = {}

local g_LimitLv = 30

local g_TargetId = -1
local g_ObjCared = -1
local g_Step1 = 0
local g_Step2 = 0

--=========================================================
-- 注册窗口关心的所有事件
--=========================================================
function PanDa_Shop_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("ADJEST_UI_POS", false)
	this:RegisterEvent("OBJECT_CARED_EVENT", false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED", false)
	this:RegisterEvent( "HIDE_ON_SCENE_TRANSED" );		-- 离开场景

end

--=========================================================
-- 载入初始化
--=========================================================
function PanDa_Shop_OnLoad()
	g_Button1[1] = PanDa_Shop_DownIcon1
	g_Button1[2] = PanDa_Shop_DownIcon2
	g_Button1[3] = PanDa_Shop_DownIcon3
	g_Button1[4] = PanDa_Shop_DownIcon4
	g_Button1[5] = PanDa_Shop_DownIcon5

	g_Button2[1] = PanDa_Shop_HighIcon1
	g_Button2[2] = PanDa_Shop_HighIcon2
	g_Button2[3] = PanDa_Shop_HighIcon3
	g_Button2[4] = PanDa_Shop_HighIcon4
	g_Button2[5] = PanDa_Shop_HighIcon5
	g_Button2[6] = PanDa_Shop_HighIcon6
	g_Button2[7] = PanDa_Shop_HighIcon7
	g_Button2[8] = PanDa_Shop_HighIcon8

	g_MaskOK1[1] = PanDa_Shop_DownIcon1BtnOK
	g_MaskOK1[2] = PanDa_Shop_DownIcon2BtnOK
	g_MaskOK1[3] = PanDa_Shop_DownIcon3BtnOK
	g_MaskOK1[4] = PanDa_Shop_DownIcon4BtnOK
	g_MaskOK1[5] = PanDa_Shop_DownIcon5BtnOK

	g_MaskOK2[1] = PanDa_Shop_HighIcon1BtnOK
	g_MaskOK2[2] = PanDa_Shop_HighIcon2BtnOK
	g_MaskOK2[3] = PanDa_Shop_HighIcon3BtnOK
	g_MaskOK2[4] = PanDa_Shop_HighIcon4BtnOK
	g_MaskOK2[5] = PanDa_Shop_HighIcon5BtnOK
	g_MaskOK2[6] = PanDa_Shop_HighIcon6BtnOK
	g_MaskOK2[7] = PanDa_Shop_HighIcon7BtnOK
	g_MaskOK2[8] = PanDa_Shop_HighIcon8BtnOK

	PanDa_Shop_Frame_UnifiedPosition = PanDa_ShopFrame:GetProperty("UnifiedPosition");
end

--=========================================================
-- 事件处理
--=========================================================
function PanDa_Shop_OnEvent(event)

	if (event == "UI_COMMAND" and tonumber(arg0) == 89312001) then --打开界面
		g_Step1 = Get_XParam_INT(0)
		g_Step2 = Get_XParam_INT(1)
		g_TargetId = Get_XParam_INT(2)
		g_ObjCared = DataPool : GetNPCIDByServerID(g_TargetId)
		this:Show()
		PanDa_Shop_ShowFrame()

	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if(tonumber(arg0) ~= g_ObjCared) then
			return
		end
		if(arg1 == "distance" and tonumber(arg2) > MAX_OBJ_DISTANCE or arg1 == "destroy") then
			PanDa_ShopOnHiden()
		end	
	elseif (event == "ADJEST_UI_POS" ) then
		PanDa_Shop_On_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		PanDa_Shop_On_ResetPos()
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		PanDa_ShopOnHiden()
	end
end

function PanDa_Shop_Clear()
	for i = 1, table.getn(g_Button1) do
		g_MaskOK1[i]:Hide()
		g_Button1[i]:SetActionItem(-1);
	end

	for i = 1, table.getn(g_Button2) do
		g_MaskOK2[i]:Hide()
		g_Button2[i]:SetActionItem(-1);
	end

	g_TargetId = -1
	g_ObjCared = -1
	g_Step1 = 0
	g_Step2 = 0

end

--=========================================================
-- 界面控件数据
--=========================================================
function PanDa_Shop_ShowFrame()
	if g_objCared ~= -1 then
		this:CareObject(g_ObjCared, 0, "PanDa_Shop")
		this:CareObject(g_ObjCared, 1, "PanDa_Shop")
	else
		return
	end
	PanDa_Shop_ExpendText:SetText(ScriptGlobal_Format("#{XMBJ_220406_10}", tostring(1)))
	PanDa_Shop_ExpendText2:SetText(ScriptGlobal_Format("#{XMBJ_220406_10}", tostring(6)))
	for i = 1, table.getn(g_Button1) do
		local itemAction = DataPool:CreateBindActionItemForShow(g_RewardStep1[i].itemId, g_RewardStep1[i].num)
		if itemAction:GetID() ~= 0 then
			g_Button1[i]:SetActionItem( itemAction:GetID() );
		else
			g_Button1[i]:SetActionItem( -1 );
		end

		if g_Step1 >= i then
			g_MaskOK1[i]:Show()
		end
	end

	for i = 1, table.getn(g_Button2) do
		local itemAction = DataPool:CreateBindActionItemForShow(g_RewardStep2[i].itemId, g_RewardStep2[i].num)
		if itemAction:GetID() ~= 0 then
			g_Button2[i]:SetActionItem( itemAction:GetID() );
		else
			g_Button2[i]:SetActionItem( -1 );
		end

		if g_Step2 >= i then
			g_MaskOK2[i]:Show()
		end
	end

	--local tipstr = ScriptGlobal_Format("#{ZQWYT_20210712_23}", tostring(g_Total))
end


--=========================================================
-- 关闭界面
--=========================================================
function PanDa_ShopOnHiden()
	if g_ObjCared ~= -1 then
		this:CareObject(g_ObjCared, 0, "PanDa_Shop")
		g_ObjCared = -1
	end
	PanDa_Shop_Clear()
	this:Hide()
	return
end


function PanDa_Shop_On_ResetPos()
  	PanDa_ShopFrame:SetProperty("UnifiedPosition", PanDa_Shop_Frame_UnifiedPosition);
end

function PanDa_Shop_Btn(idx)
	
	if idx <= 0 or idx > 2 then
		return 
	end

	local nLevel = Player:GetData("LEVEL")
	if nLevel < g_LimitLv  then
		PushDebugMessage("#{ZQWYT_20210712_10}")
		return
	end

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("GetReward")
		Set_XSCRIPT_ScriptID(893120)
		Set_XSCRIPT_Parameter(0, g_TargetId)
		Set_XSCRIPT_Parameter(1, idx)
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()

end

function PanDa_Shop_ShowHelp()
	--Clear_XSCRIPT()
		--Set_XSCRIPT_Function_Name("ShowHelp")
		--Set_XSCRIPT_ScriptID(893120)
		--Set_XSCRIPT_Parameter(0, g_TargetId)
		--Set_XSCRIPT_ParamCount(1)
	--Send_XSCRIPT()
end