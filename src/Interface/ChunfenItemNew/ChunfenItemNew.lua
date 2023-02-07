--春之计划-命运转盘脚本(客户端)

--//
--控件列表
local m_Controls = {} 				--控件列表
local g_rolltype = 2				--希望转盘类型				
local g_ItemInd = 0					--抽取物品索引
local g_MaxRollCount = 0			--最大抽取次数
local g_levRollCount = 0			--剩余抽取次数

local g_Frame_UnifiedPosition
local g_objCared = -1
local g_targetID = -1
local MAX_OBJ_DISTANCE = 3.0

--转盘控制
local g_Lightindex = 8	--启动起始位置
local g_Step = 1		--启动起始步数
local g_MaxStep = 4		--最大步数
local g_SumStep = 0		--步数累加
local g_RollStep = 1	--抽奖步骤(1:可抽取 2:转动中 3:可领取)
local m_Lights = {}		--闪光灯控件列表
local m_Steps = {}		--步数列表
local m_Rates = {}		--频率列表
local g_AddStep = 0	--需要增加的步数

local g_GiftBox = {}
local g_ItemID = {}
local g_ActionItemID = {}

function ChunfenItemNew_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("OBJECT_CARED_EVENT")
	this:RegisterEvent("SPRINTPLAN_TICKET_UPDATE")
end

function ChunfenItemNew_OnLoad()
	m_Controls = {
		m_RollButton = ChunfenItemNew_Open,
		m_GetButton = ChunfenItemNew_Get,
		--m_Note = ChunfenItemNew_Note,
		m_Frame = ChunfenItemNew_Frame,
	}
	
	m_Lights = {
		ChunfenItemNew_Image1,
		ChunfenItemNew_Image2,
		ChunfenItemNew_Image3,
		ChunfenItemNew_Image4,
		ChunfenItemNew_Image5,
		ChunfenItemNew_Image6,
		ChunfenItemNew_Image7,
		ChunfenItemNew_Image8,
	}
	
	g_GiftBox = {
		ChunfenItemNew_1,
		ChunfenItemNew_2,
		ChunfenItemNew_3,
		ChunfenItemNew_4,
		ChunfenItemNew_5,
		ChunfenItemNew_6,
		ChunfenItemNew_7,
		ChunfenItemNew_8,
	}
	
	g_ItemID =
	{
		[1] = {itemid = 30900006, count = 3, name = "天罡强化精华"},
		[2] = {itemid = 30502002, count = 3, name = "高级根骨丹"},
		[3] = {itemid = 30503133, count = 2, name = "千淬神玉"},
		[4] = {itemid = 30503020, count = 1, name = "超级珍兽还童天书"},
		[5] = {itemid = 30501361, count = 2, name = "功力丹"},
		[6] = {itemid = 10124379, count = 1, name = "蝶舞流芳（15天）"},
		[7] = {itemid = 20502003, count = 1, name = "3级秘银"},
		[8] = {itemid = 20501003, count = 1, name = "3级棉布"},
	}
	
	m_Steps = {
		4,
		25,
		8,
		4
	}
	m_Rates = {
		200,
		50,
		200,
		500
	}
	g_Frame_UnifiedPosition=m_Controls.m_Frame:GetProperty("UnifiedPosition")
	
end

function ChunfenItemNew_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == 892676 ) then
		local operate = Get_XParam_INT(0)	
		if operate == g_rolltype then
			--打开希望之轮
			g_levRollCount = Get_XParam_INT(1)		--剩余抽奖次数
			g_MaxRollCount = Get_XParam_INT(2)		--最大抽奖次数
			g_targetID = Get_XParam_INT(3)		
			g_ItemInd = Get_XParam_INT(4)			--奖品索引
			
			if g_ItemInd > 0 and g_RollStep ~= 2 then
				g_RollStep = 3						--有物品又没有在Roll的步骤则直接走领取流程
			end
			
			g_objCared = DataPool : GetNPCIDByServerID(g_targetID)
			
			if g_objCared == -1 then
				PushDebugMessage("server传过来的数据有问题。")
				return
			end
			ChunfenItemNew_OpenHopeRoll(g_levRollCount, g_MaxRollCount, g_ItemInd)
		elseif operate == 3 then
			--开始抽奖
			local rolltype = Get_XParam_INT(1)
			if rolltype == g_rolltype then
				local itemIndex = Get_XParam_INT(2)
				ChunfenItemNew_TimerBegin(itemIndex)
			end
		elseif operate == 4 then
			--领奖结束通知可以再次领奖
			local rolltype = Get_XParam_INT(1)
			if rolltype == g_rolltype then
				ChunfenItemNew_GainEnd()
			end
		end
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		ChunfenItemNew_Frame_On_ResetPos()
	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if(tonumber(arg0) ~= g_objCared) then
			return
		end
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			ChunfenItemNew_CloseRoll()
		end	
	elseif (event == "SPRINTPLAN_TICKET_UPDATE" and this:IsVisible()) then
		--刷新UI对话
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "NotifyBack" )
			Set_XSCRIPT_ScriptID( 892676 )
			Set_XSCRIPT_Parameter( 0, g_targetID )
			Set_XSCRIPT_Parameter( 1, g_rolltype )
			Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT()
	end
end

function ChunfenItemNew_OpenHopeRoll(tLvCount, tMaxCount, tItemInd)
	if g_objCared ~= -1 then
		this:CareObject(g_objCared, 0, "ChunfenItemNew")
		this:CareObject(g_objCared, 1, "ChunfenItemNew")
	else
		return
	end

	--PushDebugMessage(tItemInd)
	for i = 1, 8 do
		m_Lights[i] : PlayWarning( 0 )
	end
	
	--msgStr = ScriptGlobal_Format("#{YNZJ_141225_32}",tLvCount,tMaxCount)
	
	--m_Controls.m_Note:SetText(msgStr)
	if tItemInd > 0 then
		if g_RollStep ~= 2 then
			m_Controls.m_RollButton:SetProperty( "Visible", "False" )
			m_Controls.m_GetButton:SetProperty( "Visible", "True" )
			g_RollStep = 3
			local g_Lightnow = tItemInd
			if g_Lightnow < 9 then
				m_Lights[g_Lightnow] : PlayWarning( 1 )
			end		
		end
	else
		m_Controls.m_RollButton:SetProperty( "Visible", "True" )
		m_Controls.m_GetButton:SetProperty( "Visible", "False" )
		g_RollStep = 1
	end
								
	local theAction1 = DataPool:CreateBindActionItemForShow(g_ItemID[1].itemid, g_ItemID[1].count)
	local theAction2 = DataPool:CreateBindActionItemForShow(g_ItemID[2].itemid, g_ItemID[2].count)
	local theAction3 = DataPool:CreateBindActionItemForShow(g_ItemID[3].itemid, g_ItemID[3].count)
	local theAction4 = DataPool:CreateBindActionItemForShow(g_ItemID[4].itemid, g_ItemID[4].count)
	local theAction5 = DataPool:CreateBindActionItemForShow(g_ItemID[5].itemid, g_ItemID[5].count)
	local theAction6 = DataPool:CreateBindActionItemForShow(g_ItemID[6].itemid, g_ItemID[6].count)
	local theAction7 = DataPool:CreateBindActionItemForShow(g_ItemID[7].itemid, g_ItemID[7].count)
	local theAction8 = DataPool:CreateBindActionItemForShow(g_ItemID[8].itemid, g_ItemID[8].count)
	
	g_ActionItemID[1] = theAction1:GetID()
	g_ActionItemID[2] = theAction2:GetID()
	g_ActionItemID[3] = theAction3:GetID()
	g_ActionItemID[4] = theAction4:GetID()
	g_ActionItemID[5] = theAction5:GetID()
	g_ActionItemID[6] = theAction6:GetID()
	g_ActionItemID[7] = theAction7:GetID()
	g_ActionItemID[8] = theAction8:GetID()
	
	g_GiftBox[1]:SetActionItem(g_ActionItemID[1])
	g_GiftBox[2]:SetActionItem(g_ActionItemID[2])
	g_GiftBox[3]:SetActionItem(g_ActionItemID[3])
	g_GiftBox[4]:SetActionItem(g_ActionItemID[4])
	g_GiftBox[5]:SetActionItem(g_ActionItemID[5])
	g_GiftBox[6]:SetActionItem(g_ActionItemID[6])
	g_GiftBox[7]:SetActionItem(g_ActionItemID[7])
	g_GiftBox[8]:SetActionItem(g_ActionItemID[8])
	
	this:Show()
end

function ChunfenItemNew_CloseRoll()
	if g_objCared ~= -1 then
		this:CareObject(g_objCared, 0, "ChunfenItemNew")
		g_objCared = -1
	end
	
	this:Hide()
end

function ChunfenItemNew_Frame_On_ResetPos()
	 m_Controls.m_Frame:SetProperty("UnifiedPosition", g_Frame_UnifiedPosition)
end

function ChunfenItemNew_Roll_Effect()	
	-- 正常转动
	local lightnow = g_Lightindex
	local lightnext = g_Lightindex + 1
	if lightnext == 9 then
		lightnext = 1
	end
	
	m_Lights[lightnow] : PlayWarning( 0 )
	m_Lights[lightnext] : PlayWarning( 1 )
	
	g_Lightindex = lightnext
	
	-- 转动控制
	g_SumStep = g_SumStep + 1
	local maxStep = m_Steps[g_Step]
	if g_Step == 2 then
		maxStep = m_Steps[g_Step] + g_AddStep
	end
	if g_SumStep >= maxStep then
		g_Step = g_Step + 1
		g_SumStep = 0
		KillTimer("ChunfenItemNew_Tick()")
		if g_Step <= g_MaxStep then
			SetTimer("ChunfenItemNew","ChunfenItemNew_Tick()", m_Rates[g_Step])
		else
			-- 转动结束,奖品可领取状态
			g_RollStep = 3
			m_Controls.m_RollButton:SetProperty( "Visible", "False" )
			m_Controls.m_GetButton:SetProperty( "Visible", "True" )
			
			-- 通知服务器
			Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "LuckyRollEnd" )
			Set_XSCRIPT_ScriptID( 892676 )
			Set_XSCRIPT_Parameter( 0, g_targetID )
			Set_XSCRIPT_Parameter( 1, g_rolltype )
			Set_XSCRIPT_ParamCount(2)
			Send_XSCRIPT()
			
			if this:IsVisible() then
				Clear_XSCRIPT()
				Set_XSCRIPT_Function_Name( "NotifyBack" )
				Set_XSCRIPT_ScriptID( 892676 )
				Set_XSCRIPT_Parameter( 0, g_targetID )
				Set_XSCRIPT_Parameter( 1, g_rolltype )
				Set_XSCRIPT_ParamCount(2)
				Send_XSCRIPT()
			end
		end
		
	end
end

function ChunfenItemNew_TimerBegin( ind )
	if g_RollStep == 2 then
		PushDebugMessage("#{YNZJ_141225_30}")
		return
	end
	--更新界面次数显示
	g_levRollCount = g_levRollCount - 1
	--msgStr = ScriptGlobal_Format("#{YNZJ_141225_24}",g_levRollCount,g_MaxRollCount)
	--m_Controls.m_Note:SetText(msgStr)
	
	ChunfenItemNew_CalcAddStep(ind)
	g_RollStep = 2 --摇奖中
	m_Lights[g_Lightindex] : PlayWarning( 0 )
	g_Lightindex = 8
	g_Step = 1
	g_SumStep = 0
	KillTimer("ChunfenItemNew_Tick()")
	SetTimer("ChunfenItemNew","ChunfenItemNew_Tick()", m_Rates[g_Step])
end

function ChunfenItemNew_GainEnd()
	g_RollStep = 1
	for i = 1, 8 do
		m_Lights[i] : PlayWarning( 0 )
	end
	--m_Lights[g_Lightindex] : PlayWarning( 0 )
	m_Controls.m_RollButton:SetProperty( "Visible", "True" )
	m_Controls.m_GetButton:SetProperty( "Visible", "False" )
end

--Tick
function ChunfenItemNew_Tick()
	ChunfenItemNew_Roll_Effect()
end

--Calc
function ChunfenItemNew_CalcAddStep(Ind)
	local sumStep = 0
	for i, v in m_Steps do
		sumStep = sumStep + v
	end
	local currInd = math.mod(sumStep, 8)
	g_AddStep = math.mod((8 + (Ind - currInd)), 8)
end

--回调函数-关闭
function ChunfenItemNew_OnClosed()
	ChunfenItemNew_CloseRoll()
end

--回调函数-摇起来~~
function ChunfenItemNew_Roll()
	local isInHell = IsInHell()
	if isInHell == 1 then
		return
	end

	if g_RollStep == 2 then
		PushDebugMessage("#{YNZJ_141225_30}")
		return
	end
	
	if g_RollStep == 3 then
		--请求领奖
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "GivePrize" )
			Set_XSCRIPT_ScriptID( 892676 )
			Set_XSCRIPT_Parameter( 0, g_rolltype )
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
		
	elseif g_RollStep == 1 then
		--请求摇奖
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "ChunfenItemRoll" )
			Set_XSCRIPT_ScriptID( 892676 )
			Set_XSCRIPT_Parameter( 0, g_rolltype )
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
	end
end

function FunChunfenItemNew_Get()
	ChunfenItemNew_Roll()
end
