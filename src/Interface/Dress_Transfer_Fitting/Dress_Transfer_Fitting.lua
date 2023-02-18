--时装配饰转移试衣间

local g_Dress_Transfer_Fitting_Frame_UnifiedPosition

function Dress_Transfer_Fitting_PreLoad()
	
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("OPEN_DRESS_TRANSFER_FITTING")
	this:RegisterEvent("CLOSE_DRESS_TRANSFER_FITTING")
	this:RegisterEvent("DRESS_TRANSFER_DONE")

	this:RegisterEvent("OPEN_STALL_SALE")
	this:RegisterEvent("PROGRESSBAR_SHOW")
	this:RegisterEvent("OPEN_EQUIP")
	this:RegisterEvent("SEX_CHANGED")
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("YIGUI_OPEN")
end

function Dress_Transfer_Fitting_OnLoad()
	g_Dress_Transfer_Fitting_Frame_UnifiedPosition = Dress_Transfer_Fitting_Frame:GetProperty("UnifiedPosition")
end

function Dress_Transfer_Fitting_OnEvent(event)

	--打开试衣间
	if event == "OPEN_DRESS_TRANSFER_FITTING" then
		--试衣
		local nDressBagPos	= tonumber(arg0)
		local nGem_1	= tonumber(arg1)
		local nGem_2	= tonumber(arg2)
		local nGem_3	= tonumber(arg3)
		if DressEnchasing:Lua_FittingOnDressTransfer(nDressBagPos, nGem_1, nGem_2, nGem_3) ~= 1 then
			DressEnchasing:Lua_FittingOnDressTransferOver()	
			return
		end
		
		this:Show()

		--设置使用哪个模型
		Dress_Transfer_Fitting_FakeObject:SetFakeObject("")
		Dress_Transfer_Fitting_FakeObject:SetFakeObject("DressEnchase_Player")
		return
	end
	
	--关闭试衣间
	if event == "CLOSE_DRESS_TRANSFER_FITTING" and this:IsVisible() then
		Dress_Transfer_Fitting_OnClosed()
		return
	end
	
	--开始摆摊
	if event == "OPEN_STALL_SALE" and this:IsVisible() then
		Dress_Transfer_Fitting_OnClosed()
		return
	end
	
	--读进度条中
	if event == "PROGRESSBAR_SHOW" and this:IsVisible() then
		Dress_Transfer_Fitting_OnClosed()
		return
	end
	
	--试衣的时候不能打开角色资料窗口
	if event == "OPEN_EQUIP" and this:IsVisible() then
		Dress_Transfer_Fitting_OnClosed()
		return
	end
	
	--试衣的时候不能打开衣柜窗口
	if event == "YIGUI_OPEN" and this:IsVisible() then
		Dress_Transfer_Fitting_OnClosed()
		return
	end	
	
	--变性
	if event == "SEX_CHANGED" and this:IsVisible() then
		Dress_Transfer_Fitting_FakeObject:Hide()
		Dress_Transfer_Fitting_FakeObject:Show()
		Dress_Transfer_Fitting_FakeObject:SetFakeObject("DressEnchase_Player")
		return
	end
	
	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		Dress_Transfer_Fitting_Frame_On_ResetPos()
		return
	end
	
	if event == "HIDE_ON_SCENE_TRANSED" and this:IsVisible() then
		Dress_Transfer_Fitting_OnClosed()
		return
	end

end

function Dress_Transfer_Fitting_OnHiden()
	
	Dress_Transfer_Fitting_FakeObject:SetFakeObject("")
	--恢复试衣前的装备参数
	DressEnchasing:RestoreDressEnchaseFitting()
	DressEnchasing:Lua_FittingOnDressTransferOver()	
	
end

--关闭
function Dress_Transfer_Fitting_OnClosed()
	this:Hide()
end

-- 旋转人物头像模型（向左)
function Dress_Transfer_Fitting_TurnLeft(start)
	local mouse_button = CEArg:GetValue("MouseButton")
	if mouse_button == "LeftButton" then
		--向左旋转开始
		if start == 1 then
			Dress_Transfer_Fitting_FakeObject:RotateBegin(-0.3)
		--向左旋转结束
		else
			Dress_Transfer_Fitting_FakeObject:RotateEnd()
		end
	end
end

--旋转人物头像模型（向右)
function Dress_Transfer_Fitting_TurnRight(start)
	local mouse_button = CEArg:GetValue("MouseButton")
	if mouse_button == "LeftButton" then
		--向右旋转开始
		if start == 1 then
			Dress_Transfer_Fitting_FakeObject:RotateBegin(0.3)
		--向右旋转结束
		else
			Dress_Transfer_Fitting_FakeObject:RotateEnd()
		end
	end
end

function Dress_Transfer_Fitting_Frame_On_ResetPos()
  Dress_Transfer_Fitting_Frame:SetProperty("UnifiedPosition", g_Dress_Transfer_Fitting_Frame_UnifiedPosition)
end