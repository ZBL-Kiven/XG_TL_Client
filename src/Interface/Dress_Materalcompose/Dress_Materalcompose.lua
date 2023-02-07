local Dress_STUFF_SLOTS = {}									-- 物品槽
local Dress_ITEM_IN_SLOTS = {}									-- 物品槽中的物品背包位置
local Dress_LaskPack = {}
local theNPC =-1
local MAX_OBJ_DISTANCE = 3.0
local Dress_GemQualityType = 0
local Dress_GemLevel = 0
local Dress_NeedMoney = {5000,6000,7000}
local lastItem = {-1,-1,-1,-1,-1,-1}

local g_Dress_Materalcompose_Frame_UnifiedPosition;

function Dress_Materalcompose_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("UPDATE_DRESS_MATERIAL_COMPOSE");
	this:RegisterEvent("PACKAGE_ITEM_CHANGED");	
	this:RegisterEvent("RESUME_ENCHASE_GEM");	
	this:RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("MONEYJZ_CHANGE");
	this:RegisterEvent("OPEN_STALL_SALE")
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function Dress_Materalcompose_OnEvent(event)
	if event == "UI_COMMAND" and tonumber(arg0)==19860143 then
		Dress_Materalcompose_Clear()
		--如果界面开着，就先关闭
		if(this:IsVisible()) then
			Dress_Materalcompose_Close()
		end
		
		Dress_Materalcompose_SuccessValue : SetText("#{SZPR_XML_85}");
		Dress_Materalcompose_Static1 : Show()
		Dress_Materalcompose_Special : Show()
		this:Show()
		
		Dress_GemQualityType = 0
		Dress_GemLevel = 0
		local npcObjId = Get_XParam_INT( 0 )
		Dress_Materalcompose_BeginCareObject(npcObjId)
		Dress_Materalcompose_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
		Dress_Materalcompose_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
		return
		
	elseif event == "OBJECT_CARED_EVENT" and this : IsVisible() then
		if tonumber( arg0 ) ~= theNPC then
			return
		end
		if arg1 == "distance" and tonumber( arg2 ) > MAX_OBJ_DISTANCE or arg1 == "destroy" then
			Dress_Materalcompose_Cancel_Clicked()
		end
		Dress_Materalcompose_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
		Dress_Materalcompose_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
		return
		
	elseif event == "UPDATE_DRESS_MATERIAL_COMPOSE" and this : IsVisible() then
		Dress_Materalcompose_Update( arg0, arg1 )
		Dress_Materalcompose_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
		Dress_Materalcompose_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
		return
		
	elseif( event == "RESUME_ENCHASE_GEM" and this:IsVisible() ) then
		if(arg0~=nil and tonumber(arg0) == 11) then---xml里配置的是D11
			Dress_Materalcompose_Resume_Gem(1);
		elseif(arg0~=nil and tonumber(arg0) == 13) then
			Dress_Materalcompose_Resume_Gem(2)
		elseif(arg0~=nil and tonumber(arg0) == 15) then
			Dress_Materalcompose_Resume_Gem(3)
		elseif(arg0~=nil and tonumber(arg0) == 17) then
			Dress_Materalcompose_Resume_Gem(4)
		elseif(arg0~=nil and tonumber(arg0) == 19) then
			Dress_Materalcompose_Resume_Gem(5)
		elseif(arg0~=nil and tonumber(arg0) == 21) then
			Dress_Materalcompose_Resume_Gem(6)
		end
		return
	
	elseif (event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() ) then 
		for i=1,6 do
			lastItem[i] = -1
		end
		return	
	elseif (event == "UNIT_MONEY" and this:IsVisible()) then
		Dress_Materalcompose_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
	elseif (event == "MONEYJZ_CHANGE" and this:IsVisible()) then
		Dress_Materalcompose_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));

	elseif ( event == "OPEN_STALL_SALE" and this:IsVisible() ) then
		--和摆摊界面互斥
		this:Hide()

	elseif (event == "ADJEST_UI_POS" ) then
		Dress_Materalcompose_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		Dress_Materalcompose_Frame_On_ResetPos()
	end	
	
end


function Dress_Materalcompose_OnLoad()
	Dress_STUFF_SLOTS[1] = Dress_Materalcompose_Space1
	Dress_STUFF_SLOTS[2] = Dress_Materalcompose_Space2
	Dress_STUFF_SLOTS[3] = Dress_Materalcompose_Space3
	Dress_STUFF_SLOTS[4] = Dress_Materalcompose_Space4
	Dress_STUFF_SLOTS[5] = Dress_Materalcompose_Space5
	Dress_STUFF_SLOTS[6] = Dress_Materalcompose_Special_Button

	Dress_ITEM_IN_SLOTS[1] = -1
	Dress_ITEM_IN_SLOTS[2] = -1
	Dress_ITEM_IN_SLOTS[3] = -1
	Dress_ITEM_IN_SLOTS[4] = -1
	Dress_ITEM_IN_SLOTS[5] = -1
	Dress_ITEM_IN_SLOTS[6] = -1
	
	Dress_LaskPack[1] = -1
	Dress_LaskPack[2] = -1
	Dress_LaskPack[3] = -1
	Dress_LaskPack[4] = -1
	Dress_LaskPack[5] = -1
	Dress_LaskPack[6] = -1
	
	Dress_GemLevel = 0
	Dress_GemQualityType = 0
	
	g_Dress_Materalcompose_Frame_UnifiedPosition=Dress_Materalcompose_Frame:GetProperty("UnifiedPosition");
end

function Dress_Materalcompose_Clear()
	Dress_Materalcompose_SuccessValue : SetText("#{SZPR_XML_85}")
	Dress_Materalcompose_NeedMoney : SetProperty( "MoneyNumber", tostring( 0 ) )
	Dress_Materalcompose_OK : Disable()

	for i = 1, 6 do
		Dress_STUFF_SLOTS[i] : SetActionItem(-1)

		if Dress_ITEM_IN_SLOTS[i] ~= -1 then
			LifeAbility : Lock_Packet_Item( Dress_ITEM_IN_SLOTS[i], 0 )
		end

		Dress_STUFF_SLOTS[i] : Enable()
		Dress_ITEM_IN_SLOTS[i] = -1
		
		lastItem[i] = -1
	end
	
	LaskPack[1] = -1
	LaskPack[2] = -1
	LaskPack[3] = -1
	LaskPack[4] = -1
	LaskPack[5] = -1
	LaskPack[6] = -1

end

function Dress_Materalcompose_Close()
	this : Hide()
	Dress_Materalcompose_Clear()
end

function Dress_Materalcompose_BeginCareObject(objCaredId )
	theNPC = DataPool : GetNPCIDByServerID( objCaredId )
	-- AxTrace( 0, 1, "theNPC0: " .. theNPC )
	if theNPC == -1 then
		this : Hide()
		return
	end

	this : CareObject( theNPC, 1, "Dress_Materalcompose" )
end

function Dress_Materalcompose_Cancel_Clicked()
	Dress_Materalcompose_Close()
	Dress_Materalcompose_StopCareObject()
end

function Dress_Materalcompose_StopCareObject()
	this : CareObject( theNPC, 0, "Dress_Materalcompose" )
	theNPC = -1
end

function Dress_Materalcompose_Update( arg0, arg1 )
	local slot = tonumber(arg0)
	local bagPos = tonumber(arg1)
	if slot ~=0 then
		slot = math.floor((slot-10)/2+1)
	end
	if not this : IsVisible() then					-- 界面未打开
		return
	end
	
	-- 验证物品有效性
	local bagItem = EnumAction( bagPos, "packageitem" )
	if bagItem : GetID() == 0 then
		return
	end
	
	if slot == 6 then--如果是配饰合成符
		if PlayerPackage:GetItemTableIndex(bagPos) == 30503137 then--时装配饰合成符
			--将原来的解锁
			if Dress_ITEM_IN_SLOTS[6] ~= -1 then
				LifeAbility : Lock_Packet_Item(Dress_ITEM_IN_SLOTS[6],0);
			end
			LifeAbility : Lock_Packet_Item(bagPos,1);
			Dress_STUFF_SLOTS[6]:SetActionItem(bagItem:GetID());					
			Dress_ITEM_IN_SLOTS[6] = bagPos
		else
			PushDebugMessage("#{SZPR_091023_64}")
			return
		end
	else----配饰
		local Dress_GemType = DressEnchasing : Get_Dress_Gem_Level(bagPos,2);
		if(Dress_GemType ~= 31 and Dress_GemType ~= 32 and Dress_GemType ~= 33 ) then--不是配饰
			PushDebugMessage("#{SZPR_091023_60}")
			return
		end
		
		--如果是第一次放入配饰
		if Dress_GemQualityType==0 then
			local curDress_GemLevel = DressEnchasing : Get_Dress_Gem_Level(bagPos,1);
			if curDress_GemLevel == 4 then
				PushDebugMessage("#{SZPR_091023_63}")
				return
			end
			local curDress_GemQualityType = PlayerPackage : GetItemTableIndex( bagPos )
			--取模操作
			Dress_GemQualityType = math.floor(curDress_GemQualityType / 100000)
			Dress_GemQualityType = curDress_GemQualityType - Dress_GemQualityType*100000
			
			Dress_GemLevel = DressEnchasing : Get_Dress_Gem_Level(bagPos,1);
		else--不是第一次
			local curDress_GemIndex = PlayerPackage : GetItemTableIndex( bagPos )
			local curDress_GemQualityType = math.floor(curDress_GemIndex/100000)
			local curDress_GemLevel = DressEnchasing : Get_Dress_Gem_Level(bagPos,1);
			curDress_GemQualityType = curDress_GemIndex - curDress_GemQualityType*100000
			if(curDress_GemQualityType ~= Dress_GemQualityType) then
				PushDebugMessage("#{SZPR_091023_61}")
				return 
			end
			
			if curDress_GemLevel ~= Dress_GemLevel then
				PushDebugMessage("#{SZPR_091023_62}")
				return
			end
		end
		--自动寻找孔位
		if slot == 0 then
			for i = 1, 5 do
				if Dress_ITEM_IN_SLOTS[i] == -1 then
					slot = i
					break
				end
			end
			
			if slot == 0 then 
				return
			end
		else
			if slot < 1 or slot > 5 then
				return
			end
		end
		
		if Dress_ITEM_IN_SLOTS[slot] ~= -1 then
			LifeAbility : Lock_Packet_Item( Dress_ITEM_IN_SLOTS[slot], 0 )
		end
		Dress_ITEM_IN_SLOTS[slot] = bagPos
		LifeAbility : Lock_Packet_Item(bagPos,1);
		Dress_STUFF_SLOTS[slot]:SetActionItem(bagItem:GetID());			
		
		Dress_Materalcompose_NeedMoney:SetProperty( "MoneyNumber", Dress_NeedMoney[Dress_GemLevel])
	
	end		
	
	--置确定按钮为可点击
	local Dress_Gem_Count = 0
	for i = 1,5 do 
		if Dress_ITEM_IN_SLOTS[i] ~= -1 then
					Dress_Gem_Count = Dress_Gem_Count + 1					
		end
	end
	
	--更新成功率	
	MaterialCompound_RecalcSuccRate()
end


function Dress_Materalcompose_Resume_Gem(index)
	if index <1 or index >6 then
		return
	end	
	if( this:IsVisible() ) then
		if Dress_ITEM_IN_SLOTS[index] ~= nil and Dress_ITEM_IN_SLOTS[index] ~=-1 then
			Dress_STUFF_SLOTS[index]:SetActionItem(-1)		
			LifeAbility : Lock_Packet_Item(Dress_ITEM_IN_SLOTS[index],0);
			Dress_ITEM_IN_SLOTS[index] = -1
		end
	end

	local Dress_Gem_Count = 0
	for i = 1,5 do 
		if Dress_ITEM_IN_SLOTS[i] ~= -1 then
					Dress_Gem_Count = Dress_Gem_Count + 1					
		end
	end
	
	if Dress_Gem_Count < 3 then 
		if Dress_Gem_Count==0 then
			Dress_GemQualityType = 0
			Dress_GemLevel = 0
			Dress_Materalcompose_NeedMoney:SetProperty( "MoneyNumber", tostring(0))
		end
		Dress_Materalcompose_OK : Disable()
		Dress_Materalcompose_SuccessValue : SetText("#{SZPR_XML_85}");
	end
	MaterialCompound_RecalcSuccRate()
end

function MaterialCompound_RecalcSuccRate()
	local Dress_Gem_Count = 0
	for i = 1,5 do 
		if Dress_ITEM_IN_SLOTS[i] ~= -1 then
					Dress_Gem_Count = Dress_Gem_Count + 1					
		end
	end
	
	if Dress_Gem_Count > 2 then 
		Dress_Materalcompose_OK : Enable()
		if Dress_Gem_Count == 3 and Dress_ITEM_IN_SLOTS[6] == -1 then
			Dress_Materalcompose_SuccessValue : SetText("#{SZPR_XML_55}")
		elseif (Dress_Gem_Count == 3 and Dress_ITEM_IN_SLOTS[6] ~= -1) or (Dress_Gem_Count == 4 and Dress_ITEM_IN_SLOTS[6] == -1)then
			Dress_Materalcompose_SuccessValue : SetText("#{SZPR_XML_56}")
		elseif (Dress_Gem_Count == 4 and Dress_ITEM_IN_SLOTS[6] ~= -1) or (Dress_Gem_Count == 5 and Dress_ITEM_IN_SLOTS[6] == -1)then
			Dress_Materalcompose_SuccessValue : SetText("#{SZPR_XML_57}")
		elseif (Dress_Gem_Count == 5 and Dress_ITEM_IN_SLOTS[6] ~= -1) then
			Dress_Materalcompose_SuccessValue : SetText("#{INTERFACE_XML_176}")
		end
	else
		if Dress_Gem_Count==0 then
			Dress_GemQualityType = 0
			Dress_GemLevel = 0
		end
		Dress_Materalcompose_SuccessValue : SetText("#{SZPR_XML_85}");
	end
end

function Dress_Materalcompose_OK_Clicked()
	if Dress_ITEM_IN_SLOTS[6] == -1 or PlayerPackage:GetItemTableIndex(Dress_ITEM_IN_SLOTS[6]) ~= 30503137 then
		PushDebugMessage("#{SZPR_091023_64}")
		return 
	end


	local needMoney = Dress_NeedMoney[Dress_GemLevel]--这里Dress_GemLevel必然是合法值，否则合成按钮为灰色
	local userMoney = Player:GetData("MONEY_JZ")+Player:GetData("MONEY")
	if userMoney < needMoney then
		PushDebugMessage("#{RXZS_090804_11}")
		return
	end

	local Notify = 0 
	
	if lastItem[1] ~= Dress_ITEM_IN_SLOTS[1] or  lastItem[2] ~= Dress_ITEM_IN_SLOTS[2] or  lastItem[3] ~= Dress_ITEM_IN_SLOTS[3] or  lastItem[4] ~= Dress_ITEM_IN_SLOTS[4] or  lastItem[5] ~= Dress_ITEM_IN_SLOTS[5] or  lastItem[6] ~= Dress_ITEM_IN_SLOTS[6] then
		for i = 1,6 do
			lastItem[i] = Dress_ITEM_IN_SLOTS[i]
		end
		Notify = 1
	end
	if Notify == 1 then
		local slotDressGemCount = 0
		local composeGemName = ""
		local composeRate = 0

		DressEnchasing : Dress_ComposeShowInfo(Dress_ITEM_IN_SLOTS[1],Dress_ITEM_IN_SLOTS[2],Dress_ITEM_IN_SLOTS[3],
		Dress_ITEM_IN_SLOTS[4],Dress_ITEM_IN_SLOTS[5],Dress_ITEM_IN_SLOTS[6])					

		return
	end
	
	--调用server脚本
	
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("Dress_GemCompose");
			Set_XSCRIPT_ScriptID(830015);
			Set_XSCRIPT_Parameter(0,Dress_ITEM_IN_SLOTS[1]);
			Set_XSCRIPT_Parameter(1,Dress_ITEM_IN_SLOTS[2]);
			Set_XSCRIPT_Parameter(2,Dress_ITEM_IN_SLOTS[3]);
			Set_XSCRIPT_Parameter(3,Dress_ITEM_IN_SLOTS[4]);
			Set_XSCRIPT_Parameter(4,Dress_ITEM_IN_SLOTS[5]);
			Set_XSCRIPT_Parameter(5,Dress_ITEM_IN_SLOTS[6]);
			Set_XSCRIPT_ParamCount(6);
		Send_XSCRIPT();
	 
	 --清空界面
	  for i = 1,6 do
	 		Dress_ITEM_IN_SLOTS[i] = -1	 		
			Dress_LaskPack[i] = -1
			Dress_STUFF_SLOTS[i] : SetActionItem(-1)
		end
		Dress_GemLevel = 0
		Dress_GemQualityType = 0
		Dress_Materalcompose_NeedMoney : SetProperty( "MoneyNumber", tostring( 0 ) )
		
		Dress_Materalcompose_OK : Disable()
		Dress_Materalcompose_SuccessValue : SetText("#{SZPR_XML_85}");
		DressEnchasing : Dress_PlayUISoundFuncNew()
end

function Dress_Materalcompose_Frame_On_ResetPos()
  Dress_Materalcompose_Frame:SetProperty("UnifiedPosition", g_Dress_Materalcompose_Frame_UnifiedPosition);
end