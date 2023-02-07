local g_TreasureBox_AwardChoices_UnifiedPosition
local g_TreasureBox_AwardChoices_BagPos
local g_TreasureBox_AwardChoices_LiheType
local g_TreasureBox_AwardChoices_ItemChoice

local g_TreasureBox_AwardChoices_Page = {}
local g_TreasureBox_AwardChoices_Page_Item = {}
local g_TreasureBox_AwardChoices_Page_Text = {}
local g_TreasureBox_AwardChoices_Page_Item_Mask = {}

g_TreasureBox_AwardChoices_ZhanShiItemId = {
	[1] = { [1] = 39922769, [2] = 39922770, [3] = 39922771, [4] = 39922772, [5] = 39922773, [6] = 39922774, [7] = 39922775, [8] = 39922776, [9] = 39922777, },
	[2] = { [1] = 39922535, [2] = 39922531, [3] = 39922532, [4] = 39922533, [5] = 39922534, [6] = 39922527, [7] = 39922528, [8] = 39922529, [9] = 39922530, },
	[3] = { [1] = 39922778, [2] = 39922779, [3] = 39922780, [4] = 39922781, [5] = 39922782, [6] = 39922783, [7] = 39922784, [8] = 39922785, [9] = 39922786, },
	[4] = { [1] = 39922790, [2] = 39922791, [3] = 39922792, [4] = 39922793, [5] = 39922794, [6] = 39922795, [7] = 39922796, [8] = 39922797, [9] = 39922150, },
	[5] = { [1] = 39922818, [2] = 39922822, },
	[6] = { [1] = 39922424, [2] = 39922637, },
	[7] = { [1] = 39922847, [2] = 39922848, [3] = 39922849, [4] = 39922850, [5] = 39922733, [6] = 39922734, [7] = 39922735, [8] = 39922736 },
	[8] = { [1] = 39922787, [2] = 39922788, [3] = 39922789, [4] = 39922790, [5] = 39922791, [6] = 39922792, [7] = 39922793, [8] = 39922794, [9] = 39922795, [10] = 39922796, [11] = 39922797, },
	[9] = { [1] = 39922847, [2] = 39922848, [3] = 39922849, [4] = 39922850, [5] = 39922733, [6] = 39922734, [7] = 39922735, [8] = 39922736, [9] = 39922144, },
}

g_TreasureBox_AwardChoices_LiheItemPage = {
	[1] = 2,
	[2] = 2,
	[3] = 2,
	[4] = 2,
	[5] = 1,
	[6] = 1,
	[7] = 3,
	[8] = 4,
	[9] = 2,
}

g_TreasureBox_AwardChoices_LiheItemID = {
	[1] = "#{RCLS_200731_119}",
	[2] = "#{RCLS_200731_119}",
	[3] = "#{RCLS_200731_120}",
	[4] = "#{RCLS_200731_197}",
	[5] = "#{RCLS_200731_135}",
	[6] = "#{RCLS_200731_135}",
	[7] = "#{RCLS_200731_198}",
	[8] = "#{RCLS_200731_136}",
	[9] = "#{RCLS_200731_196}",
}

g_TreasureBox_AwardChoices_ZhanShiItemNum = {
	[8] = { [1] = 1, [2] = 1, [3] = 10, [4] = 10, [5] = 10, [6] = 10, [7] = 10, [8] = 10, [9] = 10, [10] = 10, [11] = 10, },
}

function TreasureBox_AwardChoices_PreLoad()
	this:RegisterEvent("UI_COMMAND",true);
	
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)	--进场景关闭界面
end

function TreasureBox_AwardChoices_OnLoad()	
	g_TreasureBox_AwardChoices_UnifiedPosition = TreasureBox_AwardChoices_Frame:GetProperty("UnifiedPosition")

	g_TreasureBox_AwardChoices_Page = {
		[1] = TreasureBox_AwardChoices_Page2_Client,
		[2] = TreasureBox_AwardChoices_Page3_Client,
		[3] = TreasureBox_AwardChoices_Page4_Client,
		[4] = TreasureBox_AwardChoices_Page5_Client,
	}

	g_TreasureBox_AwardChoices_Page_Item = {
		[1] = {
			[1] = TreasureBox_AwardChoices_Page2_Lace1Item,
			[2] = TreasureBox_AwardChoices_Page2_Lace2Item,
		},

		[2] = {
			[1] = TreasureBox_AwardChoices_Page3_Lace1Item,
			[2] = TreasureBox_AwardChoices_Page3_Lace2Item,
			[3] = TreasureBox_AwardChoices_Page3_Lace3Item,
			[4] = TreasureBox_AwardChoices_Page3_Lace4Item,
			[5] = TreasureBox_AwardChoices_Page3_Lace5Item,
			[6] = TreasureBox_AwardChoices_Page3_Lace6Item,
			[7] = TreasureBox_AwardChoices_Page3_Lace7Item,
			[8] = TreasureBox_AwardChoices_Page3_Lace8Item,
			[9] = TreasureBox_AwardChoices_Page3_Lace9Item,
		},

		[3] = {
			[1] = TreasureBox_AwardChoices_Page4_Lace1Item,
			[2] = TreasureBox_AwardChoices_Page4_Lace2Item,
			[3] = TreasureBox_AwardChoices_Page4_Lace3Item,
			[4] = TreasureBox_AwardChoices_Page4_Lace4Item,
			[5] = TreasureBox_AwardChoices_Page4_Lace5Item,
			[6] = TreasureBox_AwardChoices_Page4_Lace6Item,
			[7] = TreasureBox_AwardChoices_Page4_Lace7Item,
			[8] = TreasureBox_AwardChoices_Page4_Lace8Item,
		},

		[4] = {
			[1] = TreasureBox_AwardChoices_Page5_Lace1Item,
			[2] = TreasureBox_AwardChoices_Page5_Lace2Item,
			[3] = TreasureBox_AwardChoices_Page5_Lace3Item,
			[4] = TreasureBox_AwardChoices_Page5_Lace4Item,
			[5] = TreasureBox_AwardChoices_Page5_Lace5Item,
			[6] = TreasureBox_AwardChoices_Page5_Lace6Item,
			[7] = TreasureBox_AwardChoices_Page5_Lace7Item,
			[8] = TreasureBox_AwardChoices_Page5_Lace8Item,
			[9] = TreasureBox_AwardChoices_Page5_Lace9Item,
			[10] = TreasureBox_AwardChoices_Page5_Lace10Item,
			[11] = TreasureBox_AwardChoices_Page5_Lace11Item,
		},
	}

	g_TreasureBox_AwardChoices_Page_Text = {
		[1] = {
			[1] = TreasureBox_AwardChoices_Page2_Lace1Item_Tip,
			[2] = TreasureBox_AwardChoices_Page2_Lace2Item_Tip,
		},
		[2] = {
			[1] = TreasureBox_AwardChoices_Page3_Lace1Item_Tip,
			[2] = TreasureBox_AwardChoices_Page3_Lace2Item_Tip,
			[3] = TreasureBox_AwardChoices_Page3_Lace3Item_Tip,
			[4] = TreasureBox_AwardChoices_Page3_Lace4Item_Tip,
			[5] = TreasureBox_AwardChoices_Page3_Lace5Item_Tip,
			[6] = TreasureBox_AwardChoices_Page3_Lace6Item_Tip,
			[7] = TreasureBox_AwardChoices_Page3_Lace7Item_Tip,
			[8] = TreasureBox_AwardChoices_Page3_Lace8Item_Tip,
			[9] = TreasureBox_AwardChoices_Page3_Lace9Item_Tip,
		},
		[3] = {
			[1] = TreasureBox_AwardChoices_Page4_Lace1Item_Tip,
			[2] = TreasureBox_AwardChoices_Page4_Lace2Item_Tip,
			[3] = TreasureBox_AwardChoices_Page4_Lace3Item_Tip,
			[4] = TreasureBox_AwardChoices_Page4_Lace4Item_Tip,
			[5] = TreasureBox_AwardChoices_Page4_Lace5Item_Tip,
			[6] = TreasureBox_AwardChoices_Page4_Lace6Item_Tip,
			[7] = TreasureBox_AwardChoices_Page4_Lace7Item_Tip,
			[8] = TreasureBox_AwardChoices_Page4_Lace8Item_Tip,
		},
		[4] = {
			[1] = TreasureBox_AwardChoices_Page5_Lace1Item_Tip,
			[2] = TreasureBox_AwardChoices_Page5_Lace2Item_Tip,
			[3] = TreasureBox_AwardChoices_Page5_Lace3Item_Tip,
			[4] = TreasureBox_AwardChoices_Page5_Lace4Item_Tip,
			[5] = TreasureBox_AwardChoices_Page5_Lace5Item_Tip,
			[6] = TreasureBox_AwardChoices_Page5_Lace6Item_Tip,
			[7] = TreasureBox_AwardChoices_Page5_Lace7Item_Tip,
			[8] = TreasureBox_AwardChoices_Page5_Lace8Item_Tip,
			[9] = TreasureBox_AwardChoices_Page5_Lace9Item_Tip,
			[10] = TreasureBox_AwardChoices_Page5_Lace10Item_Tip,
			[11] = TreasureBox_AwardChoices_Page5_Lace11Item_Tip,
		},
	}

	g_TreasureBox_AwardChoices_Page_Item_Mask = {
		[1] = {
			[1] = TreasureBox_AwardChoices_Page2_Lace1Item_Mask,
			[2] = TreasureBox_AwardChoices_Page2_Lace2Item_Mask,
		},
		[2] = {
			[1] = TreasureBox_AwardChoices_Page3_Lace1Item_Mask,
			[2] = TreasureBox_AwardChoices_Page3_Lace2Item_Mask,
			[3] = TreasureBox_AwardChoices_Page3_Lace3Item_Mask,
			[4] = TreasureBox_AwardChoices_Page3_Lace4Item_Mask,
			[5] = TreasureBox_AwardChoices_Page3_Lace5Item_Mask,
			[6] = TreasureBox_AwardChoices_Page3_Lace6Item_Mask,
			[7] = TreasureBox_AwardChoices_Page3_Lace7Item_Mask,
			[8] = TreasureBox_AwardChoices_Page3_Lace8Item_Mask,
			[9] = TreasureBox_AwardChoices_Page3_Lace9Item_Mask,
		},
		[3] = {
			[1] = TreasureBox_AwardChoices_Page4_Lace1Item_Mask,
			[2] = TreasureBox_AwardChoices_Page4_Lace2Item_Mask,
			[3] = TreasureBox_AwardChoices_Page4_Lace3Item_Mask,
			[4] = TreasureBox_AwardChoices_Page4_Lace4Item_Mask,
			[5] = TreasureBox_AwardChoices_Page4_Lace5Item_Mask,
			[6] = TreasureBox_AwardChoices_Page4_Lace6Item_Mask,
			[7] = TreasureBox_AwardChoices_Page4_Lace7Item_Mask,
			[8] = TreasureBox_AwardChoices_Page4_Lace8Item_Mask,
		},
		[4] = {
			[1] = TreasureBox_AwardChoices_Page5_Lace1Item_Mask,
			[2] = TreasureBox_AwardChoices_Page5_Lace2Item_Mask,
			[3] = TreasureBox_AwardChoices_Page5_Lace3Item_Mask,
			[4] = TreasureBox_AwardChoices_Page5_Lace4Item_Mask,
			[5] = TreasureBox_AwardChoices_Page5_Lace5Item_Mask,
			[6] = TreasureBox_AwardChoices_Page5_Lace6Item_Mask,
			[7] = TreasureBox_AwardChoices_Page5_Lace7Item_Mask,
			[8] = TreasureBox_AwardChoices_Page5_Lace8Item_Mask,
			[9] = TreasureBox_AwardChoices_Page5_Lace9Item_Mask,
			[10] = TreasureBox_AwardChoices_Page5_Lace10Item_Mask,
			[11] = TreasureBox_AwardChoices_Page5_Lace11Item_Mask,
		},
	}

	g_TreasureBox_AwardChoices_BagPos = -1
	g_TreasureBox_AwardChoices_ItemChoice = 0
end

function TreasureBox_AwardChoices_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == 88819001 ) then
		g_TreasureBox_AwardChoices_BagPos = Get_XParam_INT(0)
		g_TreasureBox_AwardChoices_LiheType = Get_XParam_INT(1)

		TreasureBox_AwardChoices_On_Update(g_TreasureBox_AwardChoices_LiheType)
	elseif (event == "ADJEST_UI_POS" ) then
		TreasureBox_AwardChoices_On_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		TreasureBox_AwardChoices_On_ResetPos()
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		this:Hide()
	end
end

function TreasureBox_AwardChoices_On_ResetPos()
	TreasureBox_AwardChoices_Frame:SetProperty("UnifiedPosition", g_TreasureBox_AwardChoices_UnifiedPosition);
end

function TreasureBox_AwardChoices_On_Update(nIndex)
	local nPageNum = g_TreasureBox_AwardChoices_LiheItemPage[nIndex]
	if nPageNum == nil then
		return
	end

	TreasureBox_AwardChoices_DragTitle:SetText(g_TreasureBox_AwardChoices_LiheItemID[nIndex])

	for i = 1, table.getn(g_TreasureBox_AwardChoices_Page) do
		if i == nPageNum then
			g_TreasureBox_AwardChoices_Page[i]:Show()
		else
			g_TreasureBox_AwardChoices_Page[i]:Hide()
		end
	end

	for i = 1, table.getn(g_TreasureBox_AwardChoices_Page_Item[nPageNum]) do
		local nItemnum = 1
		if g_TreasureBox_AwardChoices_ZhanShiItemNum[g_TreasureBox_AwardChoices_LiheType] ~= nil then
			if g_TreasureBox_AwardChoices_ZhanShiItemNum[g_TreasureBox_AwardChoices_LiheType][i] ~= nil then
				nItemnum = g_TreasureBox_AwardChoices_ZhanShiItemNum[g_TreasureBox_AwardChoices_LiheType][i]
			end
		end

		local theAction = DataPool:CreateActionItemForShow( g_TreasureBox_AwardChoices_ZhanShiItemId[g_TreasureBox_AwardChoices_LiheType][i], nItemnum )
		g_TreasureBox_AwardChoices_Page_Item[nPageNum][i]:SetActionItem(theAction:GetID())
		g_TreasureBox_AwardChoices_Page_Text[nPageNum][i]:SetText("#L"..theAction:GetName())

		g_TreasureBox_AwardChoices_Page_Item_Mask[nPageNum][i]:Hide()
	end

	g_TreasureBox_AwardChoices_ItemChoice = 0

	this:Show()
end

function TreasureBox_AwardChoices_Choice(nIndex)
	local nPageNum = g_TreasureBox_AwardChoices_LiheItemPage[g_TreasureBox_AwardChoices_LiheType]
	if nPageNum == nil then
		return
	end

	local LiheChoice = math.floor(nIndex/100)
	local itemChoice = math.mod(nIndex,100)

	if nPageNum ~= LiheChoice then
		return
	end

	for i = 1, table.getn(g_TreasureBox_AwardChoices_Page_Item_Mask[nPageNum]) do
		if i == itemChoice then
			g_TreasureBox_AwardChoices_Page_Item_Mask[nPageNum][i]:Show()
		else
			g_TreasureBox_AwardChoices_Page_Item_Mask[nPageNum][i]:Hide()
		end
	end

	g_TreasureBox_AwardChoices_ItemChoice = itemChoice
end

function TreasureBox_AwardChoices_GetClick()
	if g_TreasureBox_AwardChoices_ItemChoice == 0 then
		PushDebugMessage("#{RCLS_200731_126}")
		return
	end

	if g_TreasureBox_AwardChoices_BagPos == -1 then
		return
	end

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "GetSelectedItem" )
		Set_XSCRIPT_ScriptID(888190)
		Set_XSCRIPT_Parameter(0,g_TreasureBox_AwardChoices_LiheType)
		Set_XSCRIPT_Parameter(1,g_TreasureBox_AwardChoices_BagPos)
		Set_XSCRIPT_Parameter(2,g_TreasureBox_AwardChoices_ItemChoice)
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()

	this:Hide()
end

function TreasureBox_AwardChoices_Close()
	this:Hide()
end

