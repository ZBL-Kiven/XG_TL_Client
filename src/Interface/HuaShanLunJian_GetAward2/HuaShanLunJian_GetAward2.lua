--测试赛 by yuanpeilong：累积领奖

local g_HuaShanLunJian_GetAward2_ActionItem = {}
local g_HuaShanLunJian_GetAward2_HaveGetFlag = {}
local g_HuaShanLunJian_GetAward2_GetPrizeButton = {}
local g_HuaShanLunJian_GetAward2_PrizeItem = {}
local g_HuaShanLunJian_GetAward2_MF = {}

local g_ServerNpc = -1

local g_HuaShanLunJian_GetAward2_MD
local g_HuaShanLunJian_GetAward2_MF_1
local g_HuaShanLunJian_GetAward2_MF_2
local g_HuaShanLunJian_GetAward2_MF_3
local g_HuaShanLunJian_GetAward2_MF_4
local g_HuaShanLunJian_GetAward2_MF_5

local g_HuaShanLunJian_GetAward2_RedPoint = {}
local g_HuaShanLunJian_GetAward2_NeedNum = {}

-- 界面的默认相对位置
local g_HuaShanLunJian_GetAward2_UnifiedXPosition
local g_HuaShanLunJian_GetAward2_UnifiedYPosition

function HuaShanLunJian_GetAward2_PreLoad()
	this:RegisterEvent("UI_COMMAND", true);
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED", false)
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS", false)
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED", false)	
end

function HuaShanLunJian_GetAward2_OnLoad()
	--this:SetPosAdjustFlag(1)

	g_HuaShanLunJian_GetAward2_ActionItem[1] = {}
	g_HuaShanLunJian_GetAward2_ActionItem[1][1] = HuaShanLunJian_GetAward2_Icon1
	g_HuaShanLunJian_GetAward2_ActionItem[1][2] = HuaShanLunJian_GetAward2_Icon1_2
	g_HuaShanLunJian_GetAward2_ActionItem[2] = {}
	g_HuaShanLunJian_GetAward2_ActionItem[2][1] = HuaShanLunJian_GetAward2_Icon2
	g_HuaShanLunJian_GetAward2_ActionItem[2][2] = HuaShanLunJian_GetAward2_Icon2_2
	g_HuaShanLunJian_GetAward2_ActionItem[3] = {}
	g_HuaShanLunJian_GetAward2_ActionItem[3][1] = HuaShanLunJian_GetAward2_Icon3
	g_HuaShanLunJian_GetAward2_ActionItem[3][2] = HuaShanLunJian_GetAward2_Icon3_2
	g_HuaShanLunJian_GetAward2_ActionItem[4] = {}
	g_HuaShanLunJian_GetAward2_ActionItem[4][1] = HuaShanLunJian_GetAward2_Icon4
	g_HuaShanLunJian_GetAward2_ActionItem[4][2] = HuaShanLunJian_GetAward2_Icon4_2
	g_HuaShanLunJian_GetAward2_ActionItem[5] = {}
	g_HuaShanLunJian_GetAward2_ActionItem[5][1] = HuaShanLunJian_GetAward2_Icon5
	g_HuaShanLunJian_GetAward2_ActionItem[5][2] = HuaShanLunJian_GetAward2_Icon5_2
  
	g_HuaShanLunJian_GetAward2_HaveGetFlag[1] = HuaShanLunJian_GetAward2_Icon1Get
	g_HuaShanLunJian_GetAward2_HaveGetFlag[2] = HuaShanLunJian_GetAward2_Icon2Get
	g_HuaShanLunJian_GetAward2_HaveGetFlag[3] = HuaShanLunJian_GetAward2_Icon3Get
	g_HuaShanLunJian_GetAward2_HaveGetFlag[4] = HuaShanLunJian_GetAward2_Icon4Get
	g_HuaShanLunJian_GetAward2_HaveGetFlag[5] = HuaShanLunJian_GetAward2_Icon5Get
  
	g_HuaShanLunJian_GetAward2_GetPrizeButton[1] = HuaShanLunJian_GetAward2_Pic1Btn
	g_HuaShanLunJian_GetAward2_GetPrizeButton[2] = HuaShanLunJian_GetAward2_Pic2Btn
	g_HuaShanLunJian_GetAward2_GetPrizeButton[3] = HuaShanLunJian_GetAward2_Pic3Btn
	g_HuaShanLunJian_GetAward2_GetPrizeButton[4] = HuaShanLunJian_GetAward2_Pic4Btn
	g_HuaShanLunJian_GetAward2_GetPrizeButton[5] = HuaShanLunJian_GetAward2_Pic5Btn
  
	g_HuaShanLunJian_GetAward2_PrizeItem[1] = {}
 	g_HuaShanLunJian_GetAward2_PrizeItem[1][1] = {id=20310168, num=8} --替代
	g_HuaShanLunJian_GetAward2_PrizeItem[1][2] = {id=30900006, num=4} --替代
	g_HuaShanLunJian_GetAward2_PrizeItem[2] = {}
	g_HuaShanLunJian_GetAward2_PrizeItem[2][1] = {id=20310116, num=3} --替代
	g_HuaShanLunJian_GetAward2_PrizeItem[2][2] = {id=30502002, num=5} --替代
	g_HuaShanLunJian_GetAward2_PrizeItem[3] = {}
	g_HuaShanLunJian_GetAward2_PrizeItem[3][1] = {id=30501361, num=2} --替代
	g_HuaShanLunJian_GetAward2_PrizeItem[3][2] = {id=30700241, num=2} --替代
	g_HuaShanLunJian_GetAward2_PrizeItem[4] = {}
	g_HuaShanLunJian_GetAward2_PrizeItem[4][1] = {id=30503140, num=2} --替代
	g_HuaShanLunJian_GetAward2_PrizeItem[4][2] = {id=30503020, num=1} --替代
	g_HuaShanLunJian_GetAward2_PrizeItem[5] = {}
	g_HuaShanLunJian_GetAward2_PrizeItem[5][1] = {id=50231001, num=1} --替代
	g_HuaShanLunJian_GetAward2_PrizeItem[5][2] = {id=30103064, num=1} --替代
	
	g_HuaShanLunJian_GetAward2_MD = 0
	g_HuaShanLunJian_GetAward2_MF_1 = 0
	g_HuaShanLunJian_GetAward2_MF_2 = 0
	g_HuaShanLunJian_GetAward2_MF_3 = 0
	g_HuaShanLunJian_GetAward2_MF_4 = 0
	g_HuaShanLunJian_GetAward2_MF_5 = 0
	
	g_HuaShanLunJian_GetAward2_MF[1] = 0
	g_HuaShanLunJian_GetAward2_MF[2] = 0
	g_HuaShanLunJian_GetAward2_MF[3] = 0
	g_HuaShanLunJian_GetAward2_MF[4] = 0
	g_HuaShanLunJian_GetAward2_MF[5] = 0
	
	g_HuaShanLunJian_GetAward2_RedPoint[1] = HuaShanLunJian_GetAward2_Pic1Btn_Tips
	g_HuaShanLunJian_GetAward2_RedPoint[2] = HuaShanLunJian_GetAward2_Pic2Btn_Tips
	g_HuaShanLunJian_GetAward2_RedPoint[3] = HuaShanLunJian_GetAward2_Pic3Btn_Tips
	g_HuaShanLunJian_GetAward2_RedPoint[4] = HuaShanLunJian_GetAward2_Pic4Btn_Tips
	g_HuaShanLunJian_GetAward2_RedPoint[5] = HuaShanLunJian_GetAward2_Pic5Btn_Tips
	
	g_HuaShanLunJian_GetAward2_NeedNum[1] = 6
	g_HuaShanLunJian_GetAward2_NeedNum[2] = 12
	g_HuaShanLunJian_GetAward2_NeedNum[3] = 20
	g_HuaShanLunJian_GetAward2_NeedNum[4] = 30
	g_HuaShanLunJian_GetAward2_NeedNum[5] = 40
	
	g_HuaShanLunJian_GetAward2_UnifiedXPosition = HuaShanLunJian_GetAward2_Frame : GetProperty("UnifiedXPosition")
	g_HuaShanLunJian_GetAward2_UnifiedYPosition	= HuaShanLunJian_GetAward2_Frame : GetProperty("UnifiedYPosition")
	
	g_ServerNpc = -1
end

-- OnEvent
function HuaShanLunJian_GetAward2_OnEvent(event)
	--
	if ( event == "UI_COMMAND" and tonumber(arg0) == 89289103 ) then --打开界面
		HuaShanLunJian_GetAward2_BeginCare( Get_XParam_INT(0) )
		g_HuaShanLunJian_GetAward2_MD = Get_XParam_INT(1)
		g_HuaShanLunJian_GetAward2_MF_1 = Get_XParam_INT(2)
		g_HuaShanLunJian_GetAward2_MF_2 = Get_XParam_INT(3)
		g_HuaShanLunJian_GetAward2_MF_3 = Get_XParam_INT(4)
		g_HuaShanLunJian_GetAward2_MF_4 = Get_XParam_INT(5)
		g_HuaShanLunJian_GetAward2_MF_5 = Get_XParam_INT(6)
		HuaShanLunJian_GetAward2_Init()
		HuaShanLunJian_GetAward2_Update( )
		this:Show()
	elseif ( event == "HIDE_ON_SCENE_TRANSED" ) then
		HuaShanLunJian_GetAward2_Hide()
	-- 游戏窗口尺寸发生了变化
	elseif (event == "ADJEST_UI_POS" ) then
		-- 更新界面位置
		HuaShanLunJian_GetAward2_ResetPos()
	-- 游戏分辨率发生了变化
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		-- 更新界面位置	
		HuaShanLunJian_GetAward2_ResetPos()		
	end
end

--=========
--Care Obj
--=========
function HuaShanLunJian_GetAward2_BeginCare( serverObjId )
	g_ServerNpc = serverObjId
	local objCared = DataPool : GetNPCIDByServerID(serverObjId)
	this:CareObject(objCared, 1)
end

function HuaShanLunJian_GetAward2_Init( )
	for i=1, table.getn(g_HuaShanLunJian_GetAward2_HaveGetFlag) do
		g_HuaShanLunJian_GetAward2_HaveGetFlag[i]:Hide()
	end
	
	for i=1, table.getn(g_HuaShanLunJian_GetAward2_GetPrizeButton) do
		g_HuaShanLunJian_GetAward2_GetPrizeButton[i]:SetText("#{HSLJ_190919_290}")
	end
	
	g_HuaShanLunJian_GetAward2_MF[1] = g_HuaShanLunJian_GetAward2_MF_1
	g_HuaShanLunJian_GetAward2_MF[2] = g_HuaShanLunJian_GetAward2_MF_2
	g_HuaShanLunJian_GetAward2_MF[3] = g_HuaShanLunJian_GetAward2_MF_3
	g_HuaShanLunJian_GetAward2_MF[4] = g_HuaShanLunJian_GetAward2_MF_4
	g_HuaShanLunJian_GetAward2_MF[5] = g_HuaShanLunJian_GetAward2_MF_5	
	
	g_HuaShanLunJian_GetAward2_RedPoint[1]:Hide()
	g_HuaShanLunJian_GetAward2_RedPoint[2]:Hide()
	g_HuaShanLunJian_GetAward2_RedPoint[3]:Hide()
	g_HuaShanLunJian_GetAward2_RedPoint[4]:Hide()
	g_HuaShanLunJian_GetAward2_RedPoint[5]:Hide()
end


function HuaShanLunJian_GetAward2_Update( )

	local value = g_HuaShanLunJian_GetAward2_MD
	local dayCntText = ScriptGlobal_Format("#{HSLJ_190919_288}", value)
	if value == 0 then
		dayCntText = "#{HSLJ_190919_314}"
	end
	HuaShanLunJian_GetAward2_Text:SetText(dayCntText)
	
	for i=1, table.getn(g_HuaShanLunJian_GetAward2_ActionItem) do
		for j=1, 2 do
			local itemId = g_HuaShanLunJian_GetAward2_PrizeItem[i][j].id
			local itemNum = g_HuaShanLunJian_GetAward2_PrizeItem[i][j].num
			local theAction = DataPool:CreateBindActionItemForShow(itemId, itemNum)
			if theAction:GetID() ~= 0 then
				g_HuaShanLunJian_GetAward2_ActionItem[i][j]:SetActionItem(theAction:GetID())
			end
		end
		local bGetAward = g_HuaShanLunJian_GetAward2_MF[i]
		if bGetAward >= 1 then
			g_HuaShanLunJian_GetAward2_HaveGetFlag[i]:Show()
			g_HuaShanLunJian_GetAward2_GetPrizeButton[i]:SetText("#{HSLJ_190919_291}")
			g_HuaShanLunJian_GetAward2_GetPrizeButton[i]:Disable()
			g_HuaShanLunJian_GetAward2_RedPoint[i]:Hide()
		else
			g_HuaShanLunJian_GetAward2_GetPrizeButton[i]:Enable()
			if (g_HuaShanLunJian_GetAward2_MD >= g_HuaShanLunJian_GetAward2_NeedNum[i]) then
				g_HuaShanLunJian_GetAward2_RedPoint[i]:Show()
			end
		end	
	end
	
end


function HuaShanLunJian_GetAward2_GetAward( index )
	if index == nil then
		return
	end

	if index < 1 or index > 5 then
		return
	end

	local level = Player:GetData("LEVEL")
	if level < 60 then
		HuaShanLunJian_GetAward2_Hide()
		PushDebugMessage( "#{HSLJ_190919_195}" )
		return
	end

	local bGetAward = g_HuaShanLunJian_GetAward2_MF[index]
	if bGetAward >= 1 then
		PushDebugMessage( "#{HSLJ_190919_39}" )
		return
	end

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("GiveTestPrize_Total")
		Set_XSCRIPT_ScriptID( 892891 )
		Set_XSCRIPT_Parameter( 0, index-1 )
		Set_XSCRIPT_Parameter( 1,  g_ServerNpc)
		Set_XSCRIPT_ParamCount(2)		
	Send_XSCRIPT()

end

function HuaShanLunJian_GetAward2_Hide()
	this:Hide()
end

--================================================
-- 恢复界面的默认相对位置
--================================================
function HuaShanLunJian_GetAward2_ResetPos()

	HuaShanLunJian_GetAward2_Frame : SetProperty("UnifiedXPosition", g_HuaShanLunJian_GetAward2_UnifiedXPosition);
	HuaShanLunJian_GetAward2_Frame : SetProperty("UnifiedYPosition", g_HuaShanLunJian_GetAward2_UnifiedYPosition);

end