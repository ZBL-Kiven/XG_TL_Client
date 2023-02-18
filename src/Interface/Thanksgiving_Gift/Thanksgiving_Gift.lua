--*************************************
--2021Q4活动  南瓜精灵送好礼
--lmy 2021-11-01
--感恩南瓜包裹
--礼盒道具四选一
--*************************************

local g_Thanksgiving_Gift_Frame_UnifiedPosition;
--关心NPc
local MAX_OBJ_DISTANCE = 3.0
local objCared = -1
local g_Object = -1

local g_Thanksgiving_Gift_Index 	= -1 	--默认不选中任何兑换物品
local g_Thanksgiving_Gift_ItemList = {}		--四个item
local g_Thanksgiving_Gift_CheckList = {}	--四个选中图标
local g_Thanksgiving_Gift_ItemIDList =
{
	[1] ={id=10141258,num =1},  
	[2] ={id=10124269,num =1},  
	[3] ={id=20310168,num =5}, 
	[4] ={id=30501361,num =1},    
}
--===============================================
-- OnLoad()
--===============================================
function Thanksgiving_Gift_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	--距离NPC距离
	this:RegisterEvent("OBJECT_CARED_EVENT",false)
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)	
	--切场景事件
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false);
end

--===============================================
-- OnLoad()
--===============================================
function Thanksgiving_Gift_OnLoad()   
	-- 保存界面的默认相对位置
	g_Thanksgiving_Gift_Frame_UnifiedPosition = Thanksgiving_Gift_Frame:GetProperty("UnifiedPosition");

	--四个道具
	g_Thanksgiving_Gift_ItemList[1] = Thanksgiving_Gift_GiftT1_Icon
	g_Thanksgiving_Gift_ItemList[2] = Thanksgiving_Gift_GiftT2_Icon
	g_Thanksgiving_Gift_ItemList[3] = Thanksgiving_Gift_GiftT3_Icon
	g_Thanksgiving_Gift_ItemList[4] = Thanksgiving_Gift_GiftT4_Icon
	--四个选中图标
	g_Thanksgiving_Gift_CheckList[1] = Thanksgiving_Gift_GiftT1_OKBtnOK
	g_Thanksgiving_Gift_CheckList[2] = Thanksgiving_Gift_GiftT2_OKBtnOK
	g_Thanksgiving_Gift_CheckList[3] = Thanksgiving_Gift_GiftT3_OKBtnOK
	g_Thanksgiving_Gift_CheckList[4] = Thanksgiving_Gift_GiftT4_OKBtnOK
end


--================================================
-- 恢复界面的默认相对位置
--================================================
function Thanksgiving_Gift_Frame_On_ResetPos()
	Thanksgiving_Gift_Frame : SetProperty("UnifiedPosition", g_Thanksgiving_Gift_Frame_UnifiedPosition);
end

--===============================================
-- OnEvent()
--===============================================
function Thanksgiving_Gift_OnEvent(event)

    if(event == "UI_COMMAND" and tonumber(arg0) == 88875801) then
		--打开界面
		if(IsWindowShow("Thanksgiving_Gift")) then
			CloseWindow("Thanksgiving_Gift", true)
		end
		--添加NPC关心
		if Get_XParam_INT(0) >= 0 then
			objCared = DataPool : GetNPCIDByServerID(Get_XParam_INT(0));
			Thanksgiving_Gift_BeginCareObject(objCared)
		end
		Thanksgiving_Gift_Open()
		this:Show()
	elseif(event == "UI_COMMAND" and tonumber(arg0) == 88875802) then
		Thanksgiving_Gift_Close()
	end
	if (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if(tonumber(arg0) ~= objCared) then
			return
		end

		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			Thanksgiving_Gift_Close()
		end
	end
    -- 游戏窗口尺寸发生了变化
	if (event == "ADJEST_UI_POS" ) then
		Thanksgiving_Gift_Frame_On_ResetPos()
	-- 游戏分辨率发生了变化
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		Thanksgiving_Gift_Frame_On_ResetPos()
    elseif (event == "HIDE_ON_SCENE_TRANSED" ) then
       Thanksgiving_Gift_Close()
    end
         
end

--===============================================
-- Thanksgiving_Gift_Close()
--===============================================
function Thanksgiving_Gift_Close()
	Thanksgiving_Gift_StopCareObject()
	g_Thanksgiving_Gift_Index 	= -1
	this:Hide()
end


--===============================================
-- 界面关闭按钮
--===============================================
function Thanksgiving_Gift_OnClose()
	g_Thanksgiving_Gift_Index 	= -1
	this:Hide()
end


--=========================================================
--开始关心NPC
--=========================================================
function Thanksgiving_Gift_BeginCareObject(objCaredId)
	if g_Object ~= -1 then
		this:CareObject(objCaredId, 0, "Thanksgiving_Gift");
	end
	g_Object = objCaredId
	this:CareObject(g_Object, 1, "Thanksgiving_Gift")
end


--=========================================================
--停止对某NPC的关心
--=========================================================
function Thanksgiving_Gift_StopCareObject()
	if g_Object ~= -1 then
		this:CareObject(g_Object, 0, "Thanksgiving_Gift");
		g_Object = -1;
	end
end

--=========================================================
--打开界面
--初始化界面
--=========================================================
function Thanksgiving_Gift_Open()
	--初始化四个物品显示
	for index=1,table.getn(g_Thanksgiving_Gift_ItemList)  do
		local theAction
		if index>= 2 and index <= 3 then
			theAction = DataPool:CreateActionItemForShow(g_Thanksgiving_Gift_ItemIDList[index].id, g_Thanksgiving_Gift_ItemIDList[index].num)
		else
			theAction = DataPool:CreateBindActionItemForShow(g_Thanksgiving_Gift_ItemIDList[index].id, g_Thanksgiving_Gift_ItemIDList[index].num)
		end
		if theAction:GetID() ~= 0 then
			g_Thanksgiving_Gift_ItemList[index]:SetActionItem(theAction:GetID());
			g_Thanksgiving_Gift_ItemList[index]:Show()
		else
			g_Thanksgiving_Gift_ItemList[index]:Hide()
		end
		g_Thanksgiving_Gift_CheckList[index]:Hide()
	end
	
	--默认赋值
	g_Thanksgiving_Gift_Index = -1
end

--=========================================================
--物品选择
--=========================================================
function Thanksgiving_Gift_2_Select(nIndex)
	--选中状态切换
	for index=1,table.getn(g_Thanksgiving_Gift_ItemList)  do
		if index == nIndex then
			g_Thanksgiving_Gift_CheckList[index]:Show()
		else
			g_Thanksgiving_Gift_CheckList[index]:Hide()
		end
	end
	g_Thanksgiving_Gift_Index = nIndex
end


--=========================================================
--确认兑换
--=========================================================
function Thanksgiving_Gift_Confirm()
	--检验
	if g_Thanksgiving_Gift_Index < 0 or g_Thanksgiving_Gift_Index > 4 then
		PushDebugMessage("#{GEWH_211025_78}")
		return
	end
	 
	
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OpenBoxByIndex")
		Set_XSCRIPT_ScriptID(888758)
		Set_XSCRIPT_Parameter( 0 ,g_Thanksgiving_Gift_Index)
		Set_XSCRIPT_ParamCount( 1 )
	Send_XSCRIPT()
end