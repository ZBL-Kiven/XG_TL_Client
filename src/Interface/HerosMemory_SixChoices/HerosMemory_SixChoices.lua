

local HerosMemory_SixChoices_Frame_UnifiedPosition;

local HerosMemory_SixChoices_SelectButtons = {}
local HerosMemory_SixChoices_Text = {}
local HerosMemory_SixChoices_Mask = {}
local g_Image_Man = {
	[1] = {image = "set:CommonNPCHeader12 image:CommonNPCHeader12_2" , name = "#{TLYXH_210223_58}",},
	[2] = {image = "set:CommonNPCHeader12 image:CommonNPCHeader12_3", name = "#{TLYXH_210223_59}", },
	[3] = {image = "set:CommonNPCHeader12 image:CommonNPCHeader12_1", name = "#{TLYXH_210223_60}",},
	[4] = {image = "set:CommonNPCHeader12 image:CommonNPCHeader12_5", name = "#{TLYXH_210223_61}",},
	[5] = {image = "set:CommonNPCHeader12 image:CommonNPCHeader12_6", name = "#{TLYXH_210223_62}",},
	[6] = {image = "set:CommonNPCHeader12 image:CommonNPCHeader12_4", name = "#{TLYXH_210223_63}",},
}
local g_Image_Woman = {
	[1] = {image ="set:CommonNPCHeader12 image:CommonNPCHeader12_11", name = "#{TLYXH_210223_69}",},
	[2] = {image ="set:CommonNPCHeader12 image:CommonNPCHeader12_8", name = "#{TLYXH_210223_70}",},
	[3] = {image ="set:CommonNPCHeader12 image:CommonNPCHeader12_7", name = "#{TLYXH_210223_71}",},
	[4] = {image ="set:CommonNPCHeader12 image:CommonNPCHeader12_9", name = "#{TLYXH_210223_72}",},
	[5] = {image ="set:CommonNPCHeader12 image:CommonNPCHeader12_10", name = "#{TLYXH_210223_73}",},
	[6] = {image ="set:CommonNPCHeader12 image:CommonNPCHeader12_13", name = "#{TLYXH_210223_74}",},
}
local g_Sex = -1
local g_Select = 0
local g_BagPos = -1
--=========================================================
-- 注册窗口关心的所有事件
--=========================================================
function HerosMemory_SixChoices_PreLoad()
	this:RegisterEvent("UI_COMMAND")

	this:RegisterEvent("ADJEST_UI_POS", false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED", false)
	this:RegisterEvent( "HIDE_ON_SCENE_TRANSED" );		-- 离开场景

end

--=========================================================
-- 载入初始化
--=========================================================
function HerosMemory_SixChoices_OnLoad()

	HerosMemory_SixChoices_SelectButtons[1] = HerosMemory_SixChoices_Gift1_Icon
	HerosMemory_SixChoices_SelectButtons[2] = HerosMemory_SixChoices_Gift2_Icon
	HerosMemory_SixChoices_SelectButtons[3] = HerosMemory_SixChoices_Gift3_Icon
	HerosMemory_SixChoices_SelectButtons[4] = HerosMemory_SixChoices_Gift4_Icon
	HerosMemory_SixChoices_SelectButtons[5] = HerosMemory_SixChoices_Gift5_Icon
	HerosMemory_SixChoices_SelectButtons[6] = HerosMemory_SixChoices_Gift6_Icon

	HerosMemory_SixChoices_Text[1] = HerosMemory_SixChoices_Gift1_Text
	HerosMemory_SixChoices_Text[2] = HerosMemory_SixChoices_Gift2_Text
	HerosMemory_SixChoices_Text[3] = HerosMemory_SixChoices_Gift3_Text
	HerosMemory_SixChoices_Text[4] = HerosMemory_SixChoices_Gift4_Text
	HerosMemory_SixChoices_Text[5] = HerosMemory_SixChoices_Gift5_Text
	HerosMemory_SixChoices_Text[6] = HerosMemory_SixChoices_Gift6_Text
	
	HerosMemory_SixChoices_Mask[1] = HerosMemory_SixChoices_Gift1_IconMark
	HerosMemory_SixChoices_Mask[2] = HerosMemory_SixChoices_Gift2_IconMark
	HerosMemory_SixChoices_Mask[3] = HerosMemory_SixChoices_Gift3_IconMark
	HerosMemory_SixChoices_Mask[4] = HerosMemory_SixChoices_Gift4_IconMark
	HerosMemory_SixChoices_Mask[5] = HerosMemory_SixChoices_Gift5_IconMark
	HerosMemory_SixChoices_Mask[6] = HerosMemory_SixChoices_Gift6_IconMark

	HerosMemory_SixChoices_Frame_UnifiedPosition = HerosMemory_SixChoices_Frame:GetProperty("UnifiedPosition");

end

--=========================================================
-- 事件处理
--=========================================================
function HerosMemory_SixChoices_OnEvent(event)

	if (event == "UI_COMMAND" and tonumber(arg0) == 34000501) then --打开界面
		HerosMemory_SixChoices_Clear()
		g_Sex = 0
		HerosMemory_SixChoices_Init()
		this:Show()

	elseif (event == "UI_COMMAND" and tonumber(arg0) == 34000401) then --打开界面
		HerosMemory_SixChoices_Clear()
		g_Sex = 1
		HerosMemory_SixChoices_Init()
		this:Show()

	elseif (event == "UI_COMMAND" and tonumber(arg0) == 34000502) then --关闭界面
		HerosMemory_SixChoices_OnClose()

	elseif (event == "UI_COMMAND" and tonumber(arg0) == 34000402) then --关闭界面
		HerosMemory_SixChoices_OnClose()

	elseif (event == "ADJEST_UI_POS" ) then
		HerosMemory_SixChoices_On_ResetPos()

	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		HerosMemory_SixChoices_On_ResetPos()
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		HerosMemory_SixChoices_OnClose()
	end
end

function HerosMemory_SixChoices_Clear( )
	g_Sex = -1
	g_Select = 0
	for i=1, table.getn(HerosMemory_SixChoices_Text) do
		HerosMemory_SixChoices_Text[i]:SetText("")
		HerosMemory_SixChoices_Mask[i]:Hide()
		--HerosMemory_SixChoices_SelectButtons[i]:SetCheck(0)
	end
end

	
--=========================================================
-- 界面控件数据
--=========================================================
function HerosMemory_SixChoices_Init(sex)
	--
	if g_Sex < 0 then
		return
	end
	if g_Sex == 0 then--girl
		HerosMemory_SixChoices_DragTitle:SetText("#{TLYXH_210223_82}")
		HerosMemory_SixChoices_Info:SetText("#{TLYXH_210223_67}")
		HerosMemory_SixChoices_Info1:SetText("#{TLYXH_210223_68}")
		for i = 1, table.getn(HerosMemory_SixChoices_SelectButtons) do
			HerosMemory_SixChoices_Text[i]:SetText(g_Image_Woman[i].name)
			HerosMemory_SixChoices_SelectButtons[i]:SetProperty("Image",g_Image_Woman[i].image);
		end
	elseif g_Sex == 1 then
		HerosMemory_SixChoices_DragTitle:SetText("#{TLYXH_210223_81}")
		HerosMemory_SixChoices_Info:SetText("#{TLYXH_210223_56}")
		HerosMemory_SixChoices_Info1:SetText("#{TLYXH_210223_57}")
		for i = 1, table.getn(HerosMemory_SixChoices_SelectButtons) do
			HerosMemory_SixChoices_Text[i]:SetText(g_Image_Man[i].name)
			HerosMemory_SixChoices_SelectButtons[i]:SetProperty("Image",g_Image_Man[i].image);
		end
	else
		return
	end

	g_BagPos = Get_XParam_INT(0)
end


--=========================================================
-- 关闭界面
--=========================================================
function HerosMemory_SixChoices_OnClose()
	HerosMemory_SixChoices_Clear()
	this:Hide()
	return
end


function HerosMemory_SixChoices_On_ResetPos()
  	HerosMemory_SixChoices_Frame:SetProperty("UnifiedPosition", HerosMemory_SixChoices_Frame_UnifiedPosition);
end


function HerosMemory_SixChoices_1_Select(idx)

	if idx <= 0 or idx > 6 then
		return
	end
	g_Select = idx

	for i=1, table.getn(HerosMemory_SixChoices_Mask) do
		HerosMemory_SixChoices_Mask[i]:Hide()
	end
	
	HerosMemory_SixChoices_Mask[idx]:Show()
end

function HerosMemory_SixChoices_Confirm()

	-- 判断是否为安全时间
	if (tonumber(DataPool:GetLeftProtectTime()) > 0) then
		PushDebugMessage("#{KPWFS_131112_20}")
		return
	end

	--判断电话密保和二级密码保护
	if CheckPhoneMibaoAndMinorPassword() ~= 1 then
		return
	end

	if g_Select <= 0 or g_Select > 6 then
		PushDebugMessage("#{TLYXH_210223_64}")
		return
	end

	if g_Sex == 0 then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "OnSelectItem" )
			Set_XSCRIPT_ScriptID( 340005 )
			Set_XSCRIPT_Parameter(0, g_BagPos)
			Set_XSCRIPT_Parameter(1, g_Select)
			Set_XSCRIPT_ParamCount( 2 )
		Send_XSCRIPT()
	elseif g_Sex == 1 then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "OnSelectItem" )
			Set_XSCRIPT_ScriptID( 340004 )
			Set_XSCRIPT_Parameter(0, g_BagPos)
			Set_XSCRIPT_Parameter(1, g_Select)
			Set_XSCRIPT_ParamCount( 2 )
		Send_XSCRIPT()
	end

end