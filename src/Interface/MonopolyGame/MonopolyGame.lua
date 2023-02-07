--!!!reloadscript =MonopolyGame

local g_MonopolyGame_UnifiedPosition = ""

local g_Playing = 0
local g_curStep = 0

local g_DicePoint = 1
local g_StepCount = 0
local g_StopStep = 0

local g_Step_Bonus = {
	{item_index = 20310168, item_count = 3},
	{item_index = 50213004, item_count = 2},
	{item_index = 20502003, item_count = 1},
	{item_index = 30501361, item_count = 1},
	{item_index = 30503140, item_count = 1},
	{item_index = 30503133, item_count = 1},
	{item_index = 10124360, item_count = 1},
	{item_index = 30700241, item_count = 1},
	{item_index = 30505217, item_count = 1},
	{item_index = 30900006, item_count = 2},
	{item_index = 20501003, item_count = 1},
	{item_index = 30008034, item_count = 2},
	{item_index = 20310116, item_count = 1},
	{item_index = 30502002, item_count = 3},
	{item_index = 10141247, item_count = 1},
	{item_index = 30503020, item_count = 1},
}

local g_StepButton = {}
local g_StepAnimate = {}
local g_StepImage = {}

local g_DiceImage = {
	"set:JiCheShen image:Qian1",
	"set:JiCheShen image:Qian2",
	"set:JiCheShen image:Qian3",
	"set:JiCheShen image:Qian4",
	"set:JiCheShen image:Qian5",
	"set:JiCheShen image:Qian6",
}

function MonopolyGame_PreLoad()

	this:RegisterEvent("UI_COMMAND")
	
	--离开场景，自动关闭
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED", false)

	this:RegisterEvent("ADJEST_UI_POS", false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED", false)


end

function MonopolyGame_OnLoad()	
	g_MonopolyGame_UnifiedPosition = MonopolyGame_Frame:GetProperty("UnifiedPosition")
	
	g_StepButton[0] 	= MonopolyGame_List1
	g_StepButton[1] 	= MonopolyGame_List2
	g_StepButton[2] 	= MonopolyGame_List3
	g_StepButton[3] 	= MonopolyGame_List4
	g_StepButton[4] 	= MonopolyGame_List5
	g_StepButton[5] 	= MonopolyGame_List6
	g_StepButton[6] 	= MonopolyGame_List7
	g_StepButton[7] 	= MonopolyGame_List8
	g_StepButton[8] 	= MonopolyGame_List9
	g_StepButton[9] 	= MonopolyGame_List10
	g_StepButton[10] 	= MonopolyGame_List11
	g_StepButton[11] 	= MonopolyGame_List12
	g_StepButton[12] 	= MonopolyGame_List13
	g_StepButton[13] 	= MonopolyGame_List14
	g_StepButton[14] 	= MonopolyGame_List15
	g_StepButton[15] 	= MonopolyGame_List16
	g_StepButton[16] 	= MonopolyGame_List17
	
	g_StepAnimate[0] 	= MonopolyGame_Image1
	g_StepAnimate[1] 	= MonopolyGame_Image2
	g_StepAnimate[2] 	= MonopolyGame_Image3
	g_StepAnimate[3] 	= MonopolyGame_Image4
	g_StepAnimate[4] 	= MonopolyGame_Image5
	g_StepAnimate[5] 	= MonopolyGame_Image6
	g_StepAnimate[6] 	= MonopolyGame_Image7
	g_StepAnimate[7] 	= MonopolyGame_Image8
	g_StepAnimate[8] 	= MonopolyGame_Image9
	g_StepAnimate[9] 	= MonopolyGame_Image10
	g_StepAnimate[10] 	= MonopolyGame_Image11
	g_StepAnimate[11] 	= MonopolyGame_Image12
	g_StepAnimate[12] 	= MonopolyGame_Image13
	g_StepAnimate[13] 	= MonopolyGame_Image14
	g_StepAnimate[14] 	= MonopolyGame_Image15
	g_StepAnimate[15] 	= MonopolyGame_Image16
	g_StepAnimate[16] 	= MonopolyGame_Image17
	
	g_StepImage[0] 		= MonopolyGame_Icon1
	g_StepImage[1] 		= MonopolyGame_Icon2
	g_StepImage[2] 		= MonopolyGame_Icon3
	g_StepImage[3] 		= MonopolyGame_Icon4
	g_StepImage[4] 		= MonopolyGame_Icon5
	g_StepImage[5] 		= MonopolyGame_Icon6
	g_StepImage[6] 		= MonopolyGame_Icon7
	g_StepImage[7] 		= MonopolyGame_Icon8
	g_StepImage[8] 		= MonopolyGame_Icon9
	g_StepImage[9] 		= MonopolyGame_Icon10
	g_StepImage[10] 	= MonopolyGame_Icon11
	g_StepImage[11] 	= MonopolyGame_Icon12
	g_StepImage[12] 	= MonopolyGame_Icon13
	g_StepImage[13] 	= MonopolyGame_Icon14
	g_StepImage[14] 	= MonopolyGame_Icon15
	g_StepImage[15] 	= MonopolyGame_Icon16
	g_StepImage[16] 	= MonopolyGame_Icon17
	
end

function MonopolyGame_OnEvent(event)

	if event == "UI_COMMAND" and tonumber(arg0) == 88880401 then
		
		if this:IsVisible() then
			return
		else		
			local objID = Get_XParam_INT(0)
			g_curStep = Get_XParam_INT(1)
		
			this:Show()
			MonopolyGame_InitList()
			MonopolyGame_Show()
			MonopolyGame_BeginCareObj(objID)
		end
	end
	
	if event == "UI_COMMAND" and tonumber(arg0) == 88880402 then
		
		if not this:IsVisible() then
			return
		else
			g_StartStep = Get_XParam_INT(0)
			g_StopStep = Get_XParam_INT(1)
			g_DicePoint = Get_XParam_INT(2)
			g_curStep = g_StopStep
			MonopolyGame_StarPlayAnimate()
		end
	end
	
	if event == "HIDE_ON_SCENE_TRANSED" then
		this:Hide()
		return
	end

	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		MonopolyGame_On_ResetPos()
	end
	
end

function MonopolyGame_RollDice()

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("RollDice")
		Set_XSCRIPT_ScriptID(888804)
	--	Set_XSCRIPT_Parameter(0, 1)
		Set_XSCRIPT_ParamCount(0)
	Send_XSCRIPT()
end

function MonopolyGame_InitList()	
	for i = 1, 16 do
		g_StepButton[i]:SetActionItem(-1)
		local showAction = DataPool:CreateBindActionItemForShow(g_Step_Bonus[i].item_index, g_Step_Bonus[i].item_count)
		if showAction:GetID() ~= 0 then
			g_StepButton[i]:SetActionItem(showAction:GetID())
		end
	end
end

--显示
function MonopolyGame_Show()	
	
	for i = 0, 16 do
		g_StepAnimate[i]:Play(false)
		if i > 0 then
			g_StepButton[i]:SetPushed(0)
		end
		g_StepImage[i]:Hide()
		if i == g_curStep then
			if i > 0 then
				g_StepButton[i]:SetPushed(1)
			end
			g_StepImage[i]:Show()
		end
	end
	
	MonopolyGame_Animate:Hide()
	MonopolyGame_Animate:Play(false)
	MonopolyGame_Image:Show()
	
	local rnd = math.random(1, 6)
	MonopolyGame_Image:SetProperty("Image", g_DiceImage[rnd])
	
	MonopolyGame_OKButton:Enable()
end

function MonopolyGame_StarPlayAnimate()
	if g_Playing == 1 then
		for i = 0, 16 do
			g_StepAnimate[i]:Play(false)
			if i > 0 then
				g_StepButton[i]:SetPushed(0)
			end
			g_StepImage[i]:Hide()
			if i == g_curStep then
				if i > 0 then
					g_StepButton[i]:SetPushed(1)
				end
				g_StepImage[i]:Show()
			end
		end
	end
	
	g_Playing = 1
	MonopolyGame_OKButton:Disable()
	MonopolyGame_Image:Hide()
	MonopolyGame_Animate:Show()
	MonopolyGame_Animate:Play(true)
	g_Playing = 0
	
end

function MonopolyGame_OnDiceStop()

	MonopolyGame_Animate:Hide()
	MonopolyGame_Animate:Play(false)
	MonopolyGame_Image:Show()
	
	MonopolyGame_Image:SetProperty("Image", g_DiceImage[g_DicePoint])
	
	for i = 0, 16 do
		if i > 0 then
			g_StepButton[i]:SetPushed(0)
		end
		g_StepImage[i]:Hide()
		g_StepAnimate[i]:Play(false)
	end
	
	g_StepCount = 0
	g_StepAnimate[g_StartStep]:Play(true)
	
end

function MonopolyGame_StepNext()

	g_StepCount = g_StepCount + 1
	if g_StepCount >= g_DicePoint then
		if g_StopStep > 0 then
			g_StepButton[g_StopStep]:SetPushed(1)
		end
		g_StepImage[g_StopStep]:Show()
		MonopolyGame_OKButton:Enable()
		return
	end

	local nowStep = g_StartStep + g_StepCount
	if nowStep > 16 then
		nowStep = nowStep - 16
	end
	
	g_StepAnimate[nowStep]:Play(true)	
end

function MonopolyGame_OnHidden()
	for i = 1, 16 do
		g_StepButton[i]:SetActionItem(-1)
	end
	g_curStep = 0
end

function MonopolyGame_On_ResetPos()
	if g_MonopolyGame_UnifiedPosition ~= nil then
		MonopolyGame_Frame:SetProperty("UnifiedPosition", g_MonopolyGame_UnifiedPosition)
	end
end

function MonopolyGame_BeginCareObj(obj_id)	
	local m_ObjCared = DataPool:GetNPCIDByServerID(obj_id)
	this:CareObject(m_ObjCared, 1)
end


--!!!reloadscript =MonopolyGame
