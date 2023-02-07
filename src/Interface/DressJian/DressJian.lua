local g_dressNum = 9
local g_CurSel = -1
local g_Icon = ""
local bagPos = -1
local DressVisualID ={}
local DressNames = {}
local DressRate = {}

-- 界面的默认相对位置
local g_DressJian_Frame_UnifiedXPosition
local g_DressJian_Frame_UnifiedYPosition

function DressJian_PreLoad()
	this:RegisterEvent("OPEN_DRESSJIAN_DLG")
	this:RegisterEvent("CLOSE_DRESSJIAN_DLG")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("UPDATE_FAKE_OBJECT")
end

function DressJian_OnLoad()

	-- 保存界面的默认相对位置
	g_DressJian_Frame_UnifiedXPosition	= DressJian_Frame : GetProperty("UnifiedXPosition")
	g_DressJian_Frame_UnifiedYPosition	= DressJian_Frame : GetProperty("UnifiedYPosition")

end

function DressJian_OnEvent(event)
	if ( event == "OPEN_DRESSJIAN_DLG" ) then
		bagPos = tonumber(arg0)
		DressJian_Init()
		this:Show()

	elseif ( event == "HIDE_ON_SCENE_TRANSED" ) then
		this:Hide()
		DressJian_DataCleanUp()
	-- 游戏窗口尺寸发生了变化
	elseif (event == "ADJEST_UI_POS" ) then
		-- 更新背包界面位置
		DressJian_Frame_On_ResetPos()
	-- 游戏分辨率发生了变化
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		-- 更新背包界面位置
		DressJian_Frame_On_ResetPos()
	elseif( event == "UPDATE_FAKE_OBJECT") then
		if (arg0 == "PlayerDressJian" and this:IsVisible() ) then
			DressJian_SetFakeCamera()
		end
	elseif (event == "CLOSE_DRESSJIAN_DLG")	then
		DressJian_OnHiden()
	end

end

function DressJian_Init()
	DressJian_List : ClearListBox()
	DressJian_FakeObject : SetFakeObject( "" )
	g_CurSel = -1
	--------------------------------------------------
	for i=1 ,g_dressNum do
		local nVisual,ndesc,nRate = DressReplaceColor:GetDressDesc(i-1)
		DressVisualID[i] = nVisual
		if nRate == 23000 then
			DressNames[i] = ScriptGlobal_Format("#{SZRSYH_120912_07}", ndesc)
		elseif nRate == 14000 then
			DressNames[i] = ScriptGlobal_Format("#{SZRSYH_120912_08}", ndesc)
		elseif nRate == 1000 then
			DressNames[i] = ScriptGlobal_Format("#{SZRSYH_120912_09}", ndesc)
		elseif nRate == -1 then
			DressNames[i] = ndesc
		end
		DressRate[i] = nRate
	end
	DressJian_List : AddItem(DressNames[9], 0)
	for i = 1 , g_dressNum-1 do
		DressJian_List : AddItem(DressNames[i], i)
	end

	-- 设置使用哪个模型
	DressReplaceColor : FittingOnDressByDressJian(bagPos,DressVisualID[g_dressNum-1])
	DressJian_FakeObject : SetFakeObject("");
	DressJian_FakeObject : SetFakeObject("PlayerDressJian")
	DressJian_SetFakeCamera()

end

function DressJian_Onshow()
	-- 设置使用哪个模型
	DressReplaceColor : FittingOnDressByDressJian(bagPos,DressVisualID[g_CurSel])
	DressJian_FakeObject : SetFakeObject("")
	DressJian_FakeObject : SetFakeObject("PlayerDressJian")
	DressJian_SetFakeCamera()
end

function DressJian_SelectOneType(typeIdx)
	if(g_CurSel + 1 == typeIdx or typeIdx < 1 or typeIdx > g_dressNum) then
		return
	end
	if typeIdx == 1 then
		typeIdx = g_dressNum
	else
		typeIdx = typeIdx - 1
	end
	g_CurSel = typeIdx
	DressJian_Onshow()
end

function DressJian_List_Click()
	local typeIdx =  DressJian_List : GetFirstSelectItem()
	DressJian_SelectOneType(typeIdx + 1)
end

----------------------------------------------------------------------------------
--
-- 旋转人物头像模型（向左)
--
function DressJian_Modle_TurnLeft(start)
	local mouse_button = CEArg:GetValue("MouseButton")
	if(mouse_button == "LeftButton") then
		--向左旋转开始
		if(start == 1) then
			DressJian_FakeObject:RotateBegin(-0.3)
		--向左旋转结束
		else
			DressJian_FakeObject:RotateEnd()
		end
	end
end

----------------------------------------------------------------------------------
--
--旋转人物头像模型（向右)
--
function DressJian_Modle_TurnRight(start)
	local mouse_button = CEArg:GetValue("MouseButton")
	if(mouse_button == "LeftButton") then
		--向右旋转开始
		if(start == 1) then
			DressJian_FakeObject:RotateBegin(0.3)
		--向右旋转结束
		else
			DressJian_FakeObject:RotateEnd()
		end
	end
end

--================================================
-- 恢复界面的默认相对位置
--================================================
function DressJian_Frame_On_ResetPos()

	DressJian_Frame : SetProperty("UnifiedXPosition", g_DressJian_Frame_UnifiedXPosition)
	DressJian_Frame : SetProperty("UnifiedYPosition", g_DressJian_Frame_UnifiedYPosition)

end

function DressJian_CloseOnclick()
	this : Hide()
end

function DressJian_SetFakeCamera()
	FakeObj_SetCamera( "PlayerDressJian", 2,7)
end

function DressJian_OnHiden()
	DressJian_List:ClearListBox()
	--Pet:ClearUpPetJianColorRate()
	DressJian_FakeObject:SetFakeObject("")

	this:Hide()
end

function DressJian_DataCleanUp()
	g_CurSel = -1
	g_Icon = ""
	bagPos = -1
	DressVisualID ={}
	DressNames = {}
	DressRate = {}
end