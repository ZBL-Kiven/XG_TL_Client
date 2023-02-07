--!!!reloadscript =Dress_Transfer
local g_ObjServerID = -1

local m_ActionButton_DressGem_A = {}
local m_ActionButton_DressGem_B = {}

local m_DressBagIndex_A = -1
local m_DressBagIndex_B = -1

local m_ActionButton_Dress_A
local m_ActionButton_Dress_B

local m_Bind_Confirmed = 0
local m_YuanbaoPay = 1

--=========
--PreLoad==
--=========
function Dress_Transfer_PreLoad()
	this:RegisterEvent("OPEN_DRESS_TRANSFER")
	
	this:RegisterEvent("CLOSE_DRESS_TRANSFER")
	this:RegisterEvent("DRESS_TRANSFER_PUTIN_DRESS")
	this:RegisterEvent("DRESS_TRANSFER_REMOVE_DRESS")
	this:RegisterEvent("DRESS_TRANSFER_RCLICK")
	this:RegisterEvent("DRESS_TRANSFER_FITTING_HIDDEN")
	this:RegisterEvent("DRESS_TRANSFER_BIND_CONFIRMED")
	this:RegisterEvent("DRESS_TRANSFER_DONE")	
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
end

--=========
--OnLoad
--=========
function Dress_Transfer_OnLoad()

	m_ActionButton_Dress_A = Dress_Transfer_Special_Button
	m_ActionButton_Dress_B = Dress_Transfer_Special_Button5
	
	m_ActionButton_DressGem_A[1] = Dress_Transfer_Special_Button1
	m_ActionButton_DressGem_A[2] = Dress_Transfer_Special_Button2
	m_ActionButton_DressGem_A[3] = Dress_Transfer_Special_Button3
	
	m_ActionButton_DressGem_B[1] = Dress_Transfer_Special_Button6
	m_ActionButton_DressGem_B[2] = Dress_Transfer_Special_Button7
	m_ActionButton_DressGem_B[3] = Dress_Transfer_Special_Button8

	
end
--=========
--OnEvent
--=========
function Dress_Transfer_OnEvent(event)
	
	if event == "OPEN_DRESS_TRANSFER" then
		
		local nObjServerID = tonumber(arg0)
		local nObjCaredID = DataPool:GetNPCIDByServerID(nObjServerID)
		if nObjCaredID and nObjCaredID >= 0 then
			g_ObjServerID = nObjServerID
			Dress_Transfer_Show()
			this:CareObject(nObjCaredID, 1)
		end
		return
	end
	
	if event == "DRESS_TRANSFER_PUTIN_DRESS"  and this:IsVisible() then
		if tonumber(arg0) ~= nil and tonumber(arg1) ~= nil then
			Dress_Transfer_OnItemDragedDropFromBag(tonumber(arg0) ,tonumber(arg1))
		end
		return
	end
	
	if event == "DRESS_TRANSFER_RCLICK"  and this:IsVisible() then
		if tonumber(arg0) ~= nil then
			Dress_Transfer_OnBagItemRClicked(tonumber(arg0))
		end
		return
	end
	
	if event == "DRESS_TRANSFER_REMOVE_DRESS" and this:IsVisible() then
		if tonumber(arg0) ~= nil then
			Dress_Transfer_OnItemDragedDropAway(tonumber(arg0))
		end
		return
	end
	
	if event == "DRESS_TRANSFER_FITTING_HIDDEN" and this:IsVisible() then
		Dress_Transfer_NoPreview()
		return
	end
	
	if event == "DRESS_TRANSFER_BIND_CONFIRMED" and this:IsVisible() then
		m_Bind_Confirmed = 1
		return
	end
	
	if event == "DRESS_TRANSFER_DONE" and this:IsVisible() then
		--关闭“配饰转移”试衣间
		if IsWindowShow("Dress_Transfer_Fitting") then
			CloseWindow("Dress_Transfer_Fitting", true)
		end
		Dress_Transfer_CleanUp()
		return
	end
	
	if event == "HIDE_ON_SCENE_TRANSED" then
		this:Hide()
		return
	end

end
--UI恢复到第一次打开时的状态
function Dress_Transfer_Init()
	if m_YuanbaoPay == 1 or m_YuanbaoPay == 0 then
		Dress_Transfer_YuanBaoPay:SetCheck(m_YuanbaoPay)
	end
end
--=========
--Show UI
--=========
function Dress_Transfer_Show()	
	Dress_Transfer_Init()
	Dress_Transfer_CleanUp()
	this:Show()	
end
--关闭 或 打开 UI时 ，清空一次
function Dress_Transfer_CleanUp()

	m_ActionButton_Dress_A:SetActionItem(-1)
	m_ActionButton_Dress_B:SetActionItem(-1)
	
	for i = 1 , 3 do
		m_ActionButton_DressGem_A[ i ]:SetActionItem(-1)
		m_ActionButton_DressGem_B[ i ]:SetActionItem(-1)
		m_ActionButton_DressGem_A[i]:SetProperty("BackImage", "")
		m_ActionButton_DressGem_B[i]:SetProperty("BackImage", "")
	end
	
	if m_DressBagIndex_A ~= -1 then
		LifeAbility:Lock_Packet_Item(m_DressBagIndex_A,0)
	end
	
	if m_DressBagIndex_B ~= -1 then
		LifeAbility:Lock_Packet_Item(m_DressBagIndex_B,0)
	end

	m_DressBagIndex_A = -1
	m_DressBagIndex_B = -1
	Dress_Transfer_OK:Disable()
	Dress_Transfer_shuoming1:SetText("")
	Dress_Transfer_zhuanyi:Disable()
	Dress_Transfer_zhuanyi:Show()
	Dress_Transfer_huifu:Hide()
	
	m_Bind_Confirmed = 0
	
end
--刷新界面
function Dress_Transfer_Refresh()
	
	--关闭“配饰转移”试衣间
	if IsWindowShow("Dress_Transfer_Fitting") then
		CloseWindow("Dress_Transfer_Fitting", true)
	end
	
	--没有源装备直接清空
	if m_DressBagIndex_A == -1 then
		
		m_ActionButton_Dress_A:SetActionItem(-1)
		
		for i = 1 , 3 do
			m_ActionButton_DressGem_A[ i ]:SetActionItem(-1)
			m_ActionButton_DressGem_A[i]:SetProperty("BackImage", "")
		end	
	else
	
		local theAction_A = EnumAction(m_DressBagIndex_A, "packageitem")
		if theAction_A:GetID() == 0 then
			
			m_ActionButton_Dress_A:SetActionItem(-1)
		
			for i = 1 , 3 do
				m_ActionButton_DressGem_A[ i ]:SetActionItem(-1)
				m_ActionButton_DressGem_A[i]:SetProperty("BackImage", "")
			end
		else
		
			m_ActionButton_Dress_A:SetActionItem(theAction_A:GetID())
			LifeAbility:Lock_Packet_Item(m_DressBagIndex_A,1)
			
			if DataPool:Lua_DressGemListA_Update(m_DressBagIndex_A) == 1 then
				
				for i = 1 , 3 do
					
					m_ActionButton_DressGem_A[ i ]:SetActionItem(-1)
					
					local gemAction = EnumAction(i - 1 , "DressTransfer_Gem_A")
					if gemAction:GetID() ~= 0 then
						m_ActionButton_DressGem_A[ i ]:SetActionItem(gemAction:GetID())
					end

				end
			
			end
		
		end
	
	end
		
	--没有目标装备直接清空
	if m_DressBagIndex_B == -1 then
		
		m_ActionButton_Dress_B:SetActionItem(-1)
		
		for i = 1 , 3 do
			m_ActionButton_DressGem_B[ i ]:SetActionItem(-1)
			m_ActionButton_DressGem_B[i]:SetProperty("BackImage", "")
		end
	else

		local theAction_B = EnumAction(m_DressBagIndex_B, "packageitem")
		if theAction_B:GetID() == 0 then
			
			m_ActionButton_Dress_B:SetActionItem(-1)
			
			for i = 1 , 3 do
				m_ActionButton_DressGem_B[ i ]:SetActionItem(-1)
				m_ActionButton_DressGem_B[i]:SetProperty("BackImage", "")
			end
			
		else

			m_ActionButton_Dress_B:SetActionItem(theAction_B:GetID())
			LifeAbility:Lock_Packet_Item(m_DressBagIndex_B,1)
			
			if DataPool:Lua_DressGemListB_Update(m_DressBagIndex_B) == 1 then
				
				for i = 1 , 3 do
					
					m_ActionButton_DressGem_B[ i ]:SetActionItem(-1)
					
					local gemAction = EnumAction(i - 1 , "DressTransfer_Gem_B")
					
					if gemAction:GetID() ~= 0 then
						m_ActionButton_DressGem_B[ i ]:SetActionItem(gemAction:GetID())
					end

				end
			
			end
		
		end
	end
	
	
	
	
	if m_DressBagIndex_A ~= -1 and m_DressBagIndex_B ~= -1 then
		
		Dress_Transfer_OK:Enable()
		Dress_Transfer_zhuanyi:Enable()
		
		local nHoleCount_A = LifeAbility:GetEquip_HoleCount(m_DressBagIndex_A)
		local nHoleCount_B = LifeAbility:GetEquip_HoleCount(m_DressBagIndex_B)
	
		local nGemCount_A = LifeAbility:GetEquip_GemCount(m_DressBagIndex_A)
		local nGemCount_B = LifeAbility:GetEquip_GemCount(m_DressBagIndex_B)
		
		local bSamePosGem = 0
		for i = 1 , nHoleCount_A do
		
			local nGem_Type_A,_ = LifeAbility:LuaFnGetEquipGemType(m_DressBagIndex_A , i - 1)
			
			if nGem_Type_A > 0 then
				
				for j = 1 , nHoleCount_B do
				
					local nGem_Type_B,_ = LifeAbility:LuaFnGetEquipGemType(m_DressBagIndex_B , j - 1)
				
					if nGem_Type_A == nGem_Type_B then
						bSamePosGem = 1
					end
				
				end
			
			end
			
		end
		
		if bSamePosGem == 1 then
			Dress_Transfer_shuoming1:SetText("#{SZPSZY_160314_40}")
		else
			if (nHoleCount_B - nGemCount_B) < nGemCount_A then
				local strTemp = ScriptGlobal_Format("#{SZPSZY_160314_38}",tostring(nGemCount_A),tostring(nHoleCount_B - nGemCount_B))	
				Dress_Transfer_shuoming1:SetText(strTemp)
			else
				local strTemp = ScriptGlobal_Format("#{SZPSZY_160314_10}",tostring(nGemCount_A),tostring(nHoleCount_B - nGemCount_B))	
				Dress_Transfer_shuoming1:SetText(strTemp)
			end		
		end

		
	else
		Dress_Transfer_OK:Disable()
		Dress_Transfer_shuoming1:SetText("")
		Dress_Transfer_zhuanyi:Disable()
	end
	
	Dress_Transfer_zhuanyi:Show()
	Dress_Transfer_huifu:Hide()
	
end
--从背包内右键点击
function Dress_Transfer_OnBagItemRClicked(iBagIndex)
	
	--源装备槽空着 ，相当于拖入源装备槽
	if m_DressBagIndex_A == -1 then
		Dress_Transfer_OnItemDragedDropFromBag(iBagIndex , 0)
		return
	else
		--源装备没空 ，相当于拖入目标装备槽
		Dress_Transfer_OnItemDragedDropFromBag(iBagIndex , 1)
		return
	end
	
end
--从背包拖拽到UI
function Dress_Transfer_OnItemDragedDropFromBag(iBagIndex , iSlotIdx)
	
	--拖到源装备槽
	if iSlotIdx == 0 then

		--不是时装
		if PlayerPackage:LuaFnGetBagItemEquipPoint(iBagIndex) ~= 16 then
			PushDebugMessage("#{SZPSZY_160314_06}")	
			return
		end

		--加锁
		if PlayerPackage:IsLock(iBagIndex) == 1 then
			PushDebugMessage("#{SZPSZY_160314_07}")	
			return
		end

		--时装上没有配饰可以转移，无法进行放入
		local nHoleCount = LifeAbility:GetEquip_HoleCount(iBagIndex)
		if nHoleCount < 1 then
			PushDebugMessage("#{SZPSZY_160314_08}")	
			return
		end

		--时装上没有配饰可以转移，无法进行放入
		local nGemCount = LifeAbility:GetEquip_GemCount(iBagIndex)
		if nGemCount < 1 then
			PushDebugMessage("#{SZPSZY_160314_08}")	
			return
		end

		--释放原来的装备
		if m_DressBagIndex_A ~= -1 then
			LifeAbility:Lock_Packet_Item(m_DressBagIndex_A, 0)
		end

		m_DressBagIndex_A = iBagIndex

		--刷新界面
		Dress_Transfer_Refresh()
		m_Bind_Confirmed = 0
		return
	end

	--拖到目标装备槽
	if iSlotIdx == 1 then
		
		--不是时装
		if PlayerPackage:LuaFnGetBagItemEquipPoint(iBagIndex) ~= 16 then
			PushDebugMessage("#{SZPSZY_160314_06}")	
			return
		end

		--加锁
		if PlayerPackage:IsLock(iBagIndex) == 1 then
			PushDebugMessage("#{SZPSZY_160314_07}")	
			return
		end
		
		--该时装上没有配饰点缀位，无法进行配饰转移
		local nHoleCount = LifeAbility:GetEquip_HoleCount(iBagIndex)
		if nHoleCount < 1 then
			PushDebugMessage("#{SZPSZY_160314_11}")	
			return
		end

		--该时装上没有空的配饰点缀位，无法进行配饰转移
		local nGemCount = LifeAbility:GetEquip_GemCount(iBagIndex)
		if nGemCount >= nHoleCount then
			PushDebugMessage("#{SZPSZY_160314_22}")	
			return
		end
		
		--释放原来的装备
		if m_DressBagIndex_B ~= -1 then
			LifeAbility:Lock_Packet_Item(m_DressBagIndex_B,0)
		end

		m_DressBagIndex_B = iBagIndex

		--刷新界面
		Dress_Transfer_Refresh()
		m_Bind_Confirmed = 0		
		return
	end	
end

--从ActionItem拖拽到Window之外
function Dress_Transfer_OnItemDragedDropAway(iSlotIdx)
	Dress_Transfer_NoDress(iSlotIdx)
end

--右键单击ActionItem
function Dress_Transfer_OnActionItemRClicked(iSlotIdx)
	Dress_Transfer_NoDress(iSlotIdx)
end

--UI没有装备的状态
function Dress_Transfer_NoDress(iSlotIdx)

	if iSlotIdx == 0 then
		
		if m_DressBagIndex_A ~= -1 then
			LifeAbility:Lock_Packet_Item(m_DressBagIndex_A, 0)
		end

		m_DressBagIndex_A = -1
		Dress_Transfer_Refresh()
		m_Bind_Confirmed = 0		
		return
	end
	
	if iSlotIdx == 1 then

		if m_DressBagIndex_B ~= -1 then
			LifeAbility:Lock_Packet_Item(m_DressBagIndex_B, 0)
		end

		m_DressBagIndex_B = -1
		Dress_Transfer_Refresh()
		m_Bind_Confirmed = 0		
		return		
	end
	
end

--OnOK
function Dress_Transfer_OnOKClicked()
	
	--没有源装备和目标装备
	if m_DressBagIndex_A == -1 or m_DressBagIndex_B == -1 then
		return	
	end
	
	--不是时装
	if PlayerPackage:LuaFnGetBagItemEquipPoint(m_DressBagIndex_A) ~= 16 then
		return		
	end
	
	--不是时装
	if PlayerPackage:LuaFnGetBagItemEquipPoint(m_DressBagIndex_B) ~= 16 then
		return		
	end
	
	local nHoleCount_A = LifeAbility:GetEquip_HoleCount(m_DressBagIndex_A)
	local nHoleCount_B = LifeAbility:GetEquip_HoleCount(m_DressBagIndex_B)
	
	local nGemCount_A = LifeAbility:GetEquip_GemCount(m_DressBagIndex_A)
	local nGemCount_B = LifeAbility:GetEquip_GemCount(m_DressBagIndex_B)
	
	if nHoleCount_A < 1 then
		return
	end
	
	--对不起，对应转移的目标时装点缀位孔位不足
	if nHoleCount_B - nGemCount_B < nGemCount_A then
		PushDebugMessage("#{SZPSZY_160314_27}")
		return
	end
	
	for i = 1, nHoleCount_A do

		local nGem_Type_A = LifeAbility:LuaFnGetEquipGemType(m_DressBagIndex_A, i - 1)		
		if nGem_Type_A > 0 then

			for j = 1 , nHoleCount_B do

				local nGem_Type_B = LifeAbility:LuaFnGetEquipGemType(m_DressBagIndex_B, j - 1)			
				if nGem_Type_A == nGem_Type_B then
					PushDebugMessage("#{SZPSZY_160314_41}")
					return
				end
			end
		end
	end
	
	local bBuyConfirm = Dress_Transfer_YuanBaoPay:GetCheck()
	
	if m_Bind_Confirmed == 0 then

		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("DressGemTransfer")
			Set_XSCRIPT_ScriptID(888805)
			Set_XSCRIPT_Parameter(0, m_DressBagIndex_A)
			Set_XSCRIPT_Parameter(1, m_DressBagIndex_B)
			Set_XSCRIPT_Parameter(2, 1)
			Set_XSCRIPT_Parameter(3, tonumber(bBuyConfirm))
			Set_XSCRIPT_ParamCount(4)
		Send_XSCRIPT()
	else

		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("DressGemTransfer")
			Set_XSCRIPT_ScriptID(888805)
			Set_XSCRIPT_Parameter(0, m_DressBagIndex_A)
			Set_XSCRIPT_Parameter(1, m_DressBagIndex_B)
			Set_XSCRIPT_Parameter(2, 0)
			Set_XSCRIPT_Parameter(3, tonumber(bBuyConfirm))
			Set_XSCRIPT_ParamCount(4)
		Send_XSCRIPT()
	end
end

--OnCancel
function Dress_Transfer_OnCancelClicked()
	this:Hide()
end

--OnClose "X"
function Dress_Transfer_OnCloseClicked()
	this:Hide()
end

function Dress_Transfer_OnHiden()

	Dress_Transfer_CleanUp()
	
	--关闭“配饰转移”试衣间
	if IsWindowShow("Dress_Transfer_Fitting") then
		CloseWindow("Dress_Transfer_Fitting", true)
	end
	
	m_YuanbaoPay = Dress_Transfer_YuanBaoPay:GetCheck()
end

--预览
function Dress_Transfer_Preview()
	
	--没有源装备和目标装备
	if m_DressBagIndex_A == -1 or m_DressBagIndex_B == -1 then
		return	
	end
	
	--不是时装
	if PlayerPackage:LuaFnGetBagItemEquipPoint(m_DressBagIndex_A) ~= 16 then
		return		
	end
	
	--不是时装
	if PlayerPackage:LuaFnGetBagItemEquipPoint(m_DressBagIndex_B) ~= 16 then
		return		
	end
	
	local nHoleCount_A = LifeAbility:GetEquip_HoleCount(m_DressBagIndex_A)
	local nHoleCount_B = LifeAbility:GetEquip_HoleCount(m_DressBagIndex_B)
	
	local nGemCount_A = LifeAbility:GetEquip_GemCount(m_DressBagIndex_A)
	local nGemCount_B = LifeAbility:GetEquip_GemCount(m_DressBagIndex_B)
	
	if nHoleCount_A < 1 then
		return
	end
	
	--对不起，对应转移的目标时装点缀位孔位不足
	if (nHoleCount_B - nGemCount_B) < nGemCount_A then
		PushDebugMessage("#{SZPSZY_160314_27}")
		return
	end
	
	for i = 1, nHoleCount_A do
		
		local nGem_Type_A = LifeAbility:LuaFnGetEquipGemType(m_DressBagIndex_A, i - 1)		
		if nGem_Type_A > 0 then
			
			for j = 1, nHoleCount_B do			
				local nGem_Type_B = LifeAbility:LuaFnGetEquipGemType(m_DressBagIndex_B, j - 1)
				if nGem_Type_A == nGem_Type_B then
					PushDebugMessage("#{SZPSZY_160314_41}")
					return
				end
			end
		end
	end
	
	local nGemID_Fitting = {0, 0, 0}
	for i = 1, 3 do
		
		m_ActionButton_DressGem_A[i]:SetActionItem(-1)
		m_ActionButton_DressGem_B[i]:SetActionItem(-1)
		
		local gemActionA = EnumAction(i - 1, "DressTransfer_Gem_A")
		if gemActionA:GetID() ~= 0 then
			m_ActionButton_DressGem_B[i]:SetActionItem(gemActionA:GetID())
		else
			local gemActionB = EnumAction(i - 1, "DressTransfer_Gem_B")
			if gemActionB:GetID() ~= 0 then
				m_ActionButton_DressGem_B[i]:SetActionItem(gemActionB:GetID())
			end
		end
			
		local nGem_ID_A = LifeAbility:LuaFnGetEquipGemId(m_DressBagIndex_A, i - 1)
		local nGem_ID_B = LifeAbility:LuaFnGetEquipGemId(m_DressBagIndex_B, i - 1)
			
		if nGem_ID_A > 0 then
			local gemAction = EnumAction(i - 1, "DressTransfer_Gem_A")
			if gemAction:GetID() ~= 0 then
				m_ActionButton_DressGem_B[i]:SetActionItem(gemAction:GetID())
			end
			nGemID_Fitting[i] = nGem_ID_A
		else
			local gemAction = EnumAction(i - 1, "DressTransfer_Gem_B")
			if gemAction:GetID() ~= 0 then
				m_ActionButton_DressGem_B[i]:SetActionItem(gemAction:GetID())
			end
			nGemID_Fitting[i] = nGem_ID_B				
		end
		
	end
	
	local nGemID_Fitting = {0 , 0 , 0}
	local nGemCount_Sum = 0
	for i = 1, 3 do
		if nGemCount_Sum < 3 then
			local nGem_ID_A = LifeAbility:LuaFnGetEquipGemId(m_DressBagIndex_A, i - 1)	
			if nGem_ID_A > 0 then
				nGemCount_Sum = nGemCount_Sum + 1
				nGemID_Fitting[nGemCount_Sum] = nGem_ID_A
			end
		end
	end
	
	for i = 1, 3 do
		if nGemCount_Sum < 3 then
			local nGem_ID_B = LifeAbility:LuaFnGetEquipGemId(m_DressBagIndex_B, i - 1)	
			if nGem_ID_B > 0 then
				nGemCount_Sum = nGemCount_Sum + 1
				nGemID_Fitting[nGemCount_Sum] = nGem_ID_B
			end
		end
	end
	
	Dress_Transfer_zhuanyi:Hide()
	Dress_Transfer_huifu:Show()
	
	DressEnchasing:Lua_OpenDressTransferFitting(m_DressBagIndex_B, nGemID_Fitting[1], nGemID_Fitting[2], nGemID_Fitting[3])
	
end

--取消预览
function Dress_Transfer_NoPreview()
	Dress_Transfer_zhuanyi:Show()
	Dress_Transfer_huifu:Hide()
	Dress_Transfer_Refresh()	
end