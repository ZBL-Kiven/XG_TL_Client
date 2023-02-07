--魂兽凝魂 PetSoul_Fusion

local g_PetSoul_Fusion_UnifiedPosition;

local MAX_OBJ_DISTANCE = 3.0

local g_PetSoul_Fusion_NpcId = -1;

local g_PetSoul_Fusion_ItemBagIndex1 = -1
local g_PetSoul_Fusion_ItemBagIndex2 = -1

local g_PetSoul_Fusion_ItemID1 = -1
local g_PetSoul_Fusion_ItemID2 = -1

local g_PetSoul_Fusion_QNumber = {
	[0] = "20",
	[1] = "30",
	[2] = "40",
}
local g_PetSoul_Fusion_Item = {
	{39995380,39995379,39995378,39995377,39995376},
	{39995375,39995374,39995373,39995372,39995371},
	{39995370,39995369,39995368,39995367,39995366},
	}
local g_PetSoul_Fusion_QualItem = {
	{38002529,38002528,38002527,38002526,38002525},
	{38002524,38002523,38002522,38002521,38002520},
	{38002519,38002518,38002517,38002516,38002515},
	}

local g_PetSoul_Fusion_TargetId = -1

local g_PetSoul_Fusion_ConfirmBind = 0;

function PetSoul_Fusion_PreLoad()

	this:RegisterEvent("UI_COMMAND");

	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")

    this:RegisterEvent("OBJECT_CARED_EVENT");           --某逻辑对象的某些发生改变，用于距离NPC够远则关闭界面
    

	this:RegisterEvent("PETSOUL_FUSION_PUTIN_ITEM"); --放入物品
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")			--背包中物品改变
	this:RegisterEvent("RESUME_ENCHASE_GEM"); --拖拽回背包

end

function PetSoul_Fusion_OnLoad()

	g_PetSoul_Fusion_ConfirmBind = 0;

	g_PetSoul_Fusion_UnifiedPosition=PetSoul_Fusion_Frame:GetProperty("UnifiedPosition")
	
end

function PetSoul_Fusion_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == 80012704 ) then
		local bIsShow = Get_XParam_INT(0);
		if bIsShow == 1 then
			g_PetSoul_Fusion_ConfirmBind = 0;
			this:Show()
            OpenWindow("Packet")
        end

        if this:IsVisible() then
			g_PetSoul_Fusion_TargetId = Get_XParam_INT( 1 )
            PetSoul_Fusion_BeginCareObject( g_PetSoul_Fusion_TargetId )
            PetSoul_Fusion_FrameInit()
		end

		return
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 80012724 ) then
		g_PetSoul_Fusion_ConfirmBind = 1;
		return
	--放入物品
	elseif event == "UI_COMMAND" and tonumber(arg0) == 201107281 and this:IsVisible() then
		if arg1 ~= nil then
			PetSoul_Fusion_ItemUpdate(tonumber(arg1),3)
			
		end

		return
	elseif( event == "RESUME_ENCHASE_GEM" and this:IsVisible() ) then
		if(arg0~=nil and tonumber(arg0) == 27) then---xml里配置的是W27
			PetSoul_Fusion_Resume_Equip()
		end
		if(arg0~=nil and tonumber(arg0) == 28) then---xml里配置的是W28
			PetSoul_Fusion_Resume_Equip2()
		end

		return
	elseif event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() then
		if not arg0 or tonumber(arg0) == -1 then
			return
		end
		
		local ClearItem1 = 0
		local ClearItem2 = 0
		
		if(tonumber(arg0) == g_PetSoul_Fusion_ItemBagIndex1)  and g_PetSoul_Fusion_ItemBagIndex1 ~= -1 then
			local nItemIndex = PlayerPackage:GetItemTableIndex(g_PetSoul_Fusion_ItemBagIndex1)
			if(nItemIndex == nil or nItemIndex ~= g_PetSoul_Fusion_ItemID1)then
				ClearItem1 = 1;
			end
		end

		if(tonumber(arg0) == g_PetSoul_Fusion_ItemBagIndex2)  and g_PetSoul_Fusion_ItemBagIndex2 ~= -1 then
			local nItemIndex = PlayerPackage:GetItemTableIndex(g_PetSoul_Fusion_ItemBagIndex2)
			if(nItemIndex == nil or nItemIndex ~= g_PetSoul_Fusion_ItemID2)then
				
				ClearItem2 = 1;  
			end
		end
		PetSoul_Fusion_ItemClear(ClearItem1,ClearItem2)

		return
    elseif event == "OBJECT_CARED_EVENT" and this : IsVisible() then
		if(tonumber(arg0) ~= g_PetSoul_Fusion_NpcId) then
			return;
		end
		
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if arg1 == "distance" and tonumber( arg2 ) > MAX_OBJ_DISTANCE or arg1 == "destroy" then
			PetSoul_Fusion_Close()
		end

        return
    elseif event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED"then
		PetSoul_Fusion_On_ResetPos()
		return
	end
end

--凝魂按钮 按下调用
function PetSoul_Fusion_Buttons_Clicked()

	--二级密码 电话密保检查
	-- if CheckPhoneMibaoAndMinorPassword() ~= 1 then
		-- PushDebugMessage("#{SHXT_20211230_67}")
		-- return
	-- end
	
	--当前魂玉输入框中是否已放入魂玉
	if g_PetSoul_Fusion_ItemBagIndex1 < 0 and g_PetSoul_Fusion_ItemBagIndex2 < 0 then
		PushDebugMessage("#{SHXT_20211230_112}")
		return
	end
	
	if(g_PetSoul_Fusion_ItemBagIndex1 >= 0 and g_PetSoul_Fusion_ItemBagIndex2 >= 0 )then
		--判断当前魂玉是否是同一兽魂的碎片
		if PlayerPackage:GetItemTableIndex(g_PetSoul_Fusion_ItemBagIndex1) ~= PlayerPackage:GetItemTableIndex(g_PetSoul_Fusion_ItemBagIndex2) then
			PushDebugMessage("#{SHXT_20211230_167}")
			return
		end
	end

	Clear_XSCRIPT()
		Set_XSCRIPT_ScriptID( 742562 )
		Set_XSCRIPT_Function_Name( "OnPetSoulFusion" )
		Set_XSCRIPT_Parameter(0, g_PetSoul_Fusion_TargetId)
		Set_XSCRIPT_Parameter(1, g_PetSoul_Fusion_ItemBagIndex1)
		Set_XSCRIPT_Parameter(2, g_PetSoul_Fusion_ItemBagIndex2)
		Set_XSCRIPT_Parameter(3, g_PetSoul_Fusion_ConfirmBind)
		Set_XSCRIPT_ParamCount(4)
	Send_XSCRIPT()
end

--界面物品栏 鼠标右键调用
function PetSoul_Fusion_Resume_Equip()
	PetSoul_Fusion_ItemUpdate(-1,1)
end
function PetSoul_Fusion_Resume_Equip2()
	PetSoul_Fusion_ItemUpdate(-1,2)
end

function PetSoul_Fusion_ItemClear(nClear1,nClear2)
	if(nClear1 == 1)then
		if g_PetSoul_Fusion_ItemBagIndex1 ~= -1 then
			PetSoul_Fusion_Object:SetActionItem(-1)
			LifeAbility : Lock_Packet_Item(g_PetSoul_Fusion_ItemBagIndex1,0);
			g_PetSoul_Fusion_ItemBagIndex1 = -1;
			g_PetSoul_Fusion_ItemID1 = -1
		end
	end
	if(nClear2 == 1)then
		if g_PetSoul_Fusion_ItemBagIndex2 ~= -1 then
			PetSoul_Fusion_Object2:SetActionItem(-1)
			LifeAbility : Lock_Packet_Item(g_PetSoul_Fusion_ItemBagIndex2,0);
			g_PetSoul_Fusion_ItemBagIndex2 = -1;
			g_PetSoul_Fusion_ItemID2 = -1
		end
	end

	--显示兽魂
	local nItem1Bind , nItem2Bind= 0;
	local nItemIndex = 0;
	local nPsIndex, nPsQual =0;

	if(g_PetSoul_Fusion_ItemBagIndex1 ~= -1)then
		if GetItemBindStatus(g_PetSoul_Fusion_ItemBagIndex1) == 1 then
			nItem1Bind = 1
		end
		nItemIndex = PlayerPackage:GetItemTableIndex(g_PetSoul_Fusion_ItemBagIndex1);
		nPsIndex, nPsQual = LuaFnGetPetSoulPieceInfo( nItemIndex );
	end

	if(g_PetSoul_Fusion_ItemBagIndex2 ~= -1)then
		if GetItemBindStatus(g_PetSoul_Fusion_ItemBagIndex2) == 1 then
			nItem2Bind = 1
		end
		nItemIndex = PlayerPackage:GetItemTableIndex(g_PetSoul_Fusion_ItemBagIndex2);
		nPsIndex, nPsQual = LuaFnGetPetSoulPieceInfo( nItemIndex );
	end

	local nBind = 0;
	if(nItem1Bind == 1) or (nItem2Bind == 1)then
		nBind = 1;
	end

	if(g_PetSoul_Fusion_ItemBagIndex1 ~= -1 or g_PetSoul_Fusion_ItemBagIndex2 ~= -1)then
		if(nPsIndex ~= nil)then
			-- DataPool:ClearActionItemForShow()
			-- g_PetSoul_Fusion_Item
			-- g_PetSoul_Fusion_QualItem
			local ShowID = 0
			for i = 1,3 do
				for j = 1,5 do
					if g_PetSoul_Fusion_Item[i][j] == nItemIndex then
						ShowID = g_PetSoul_Fusion_QualItem[i][j]
						break
					end
				end
			end
			if(nBind == 0)then
				local theAction2 = GemMelting:UpdateProductAction(tonumber(ShowID))
				PetSoul_Fusion_Object3:SetActionItem(theAction2:GetID())
			else
				local theAction2 = GemMelting:UpdateProductAction(tonumber(ShowID))
				PetSoul_Fusion_Object3:SetActionItem(theAction2:GetID())
			end
		end
	end

	--显示需要的兽魂碎片数
	if g_PetSoul_Fusion_ItemBagIndex1 ~= -1   then
		local nItemIndex = PlayerPackage:GetItemTableIndex(g_PetSoul_Fusion_ItemBagIndex1);
		local nPsIndex, nPsQual = LuaFnGetPetSoulPieceInfo( nItemIndex );
		if(nPsIndex ~= nil and nPsIndex > 0)then
			local text = string.format("#G%s#cfff263凝魂所需#G%s#cfff263数量：#G%s", LuaFnGetItemNameByTableIndex(nPsIndex),LuaFnGetItemNameByTableIndex( nItemIndex ),g_PetSoul_Fusion_QNumber[nPsQual])
			PetSoul_Fusion_Info4:SetText(text)
		end
	end
	if g_PetSoul_Fusion_ItemBagIndex2 ~= -1   then
		local nItemIndex = PlayerPackage:GetItemTableIndex(g_PetSoul_Fusion_ItemBagIndex2);
		local nPsIndex, nPsQual = LuaFnGetPetSoulPieceInfo( nItemIndex );
		if(nPsIndex ~= nil and nPsIndex > 0)then
			local text = string.format("#G%s#cfff263凝魂所需#G%s#cfff263数量：#G%s", LuaFnGetItemNameByTableIndex(nPsIndex),LuaFnGetItemNameByTableIndex( nItemIndex ),g_PetSoul_Fusion_QNumber[nPsQual])
			PetSoul_Fusion_Info4:SetText(text)
		end
	end

	--刷新确认按钮
	if g_PetSoul_Fusion_ItemBagIndex1 ~= -1 or g_PetSoul_Fusion_ItemBagIndex2 ~= -1 then
		PetSoul_Fusion_OK:Enable()
	else
		PetSoul_Fusion_Info4:SetText("#{SHXT_20211230_201}")
		PetSoul_Fusion_OK:Disable()
		PetSoul_Fusion_Object3:SetActionItem(-1)
	end
end

function PetSoul_Fusion_ItemPut(bagPos,nItemIndex,theAction)
	if(nItemIndex == 1)then
		--如果当前的格子已经有物品，则清除一下蒙红
		if g_PetSoul_Fusion_ItemBagIndex1 ~= -1 then
			LifeAbility : Lock_Packet_Item(g_PetSoul_Fusion_ItemBagIndex1,0);
			g_PetSoul_Fusion_ItemBagIndex1 = -1;
		end 
		g_PetSoul_Fusion_ItemBagIndex1 = bagPos;
		PetSoul_Fusion_Object:SetActionItem(theAction:GetID());
		LifeAbility : Lock_Packet_Item(bagPos,1);
		g_PetSoul_Fusion_ItemID1 = PlayerPackage:GetItemTableIndex(bagPos)
	elseif(nItemIndex == 2)then
		--如果当前的格子已经有物品，则清除一下蒙红
		if g_PetSoul_Fusion_ItemBagIndex2 ~= -1 then
			LifeAbility : Lock_Packet_Item(g_PetSoul_Fusion_ItemBagIndex2,0);
			g_PetSoul_Fusion_ItemBagIndex2 = -1;
		end 
		g_PetSoul_Fusion_ItemBagIndex2 = bagPos;
		PetSoul_Fusion_Object2:SetActionItem(theAction:GetID());
		LifeAbility : Lock_Packet_Item(bagPos,1);
		g_PetSoul_Fusion_ItemID2 = PlayerPackage:GetItemTableIndex(bagPos)
	end
end

--bagPos为从背包放入界面的物品的在背包的位置
--interfaceIndex为放入的界面的框的标识  3表示右键点击放入不分左右
function PetSoul_Fusion_ItemUpdate(bagPos,interfaceIndex)

	--bagPos为-1，表示要初始化界面  关闭界面 右键取出物品时调用
	if bagPos == -1 then
		--蒙红物品解锁
		if interfaceIndex == 1 then
			PetSoul_Fusion_ItemClear(1,0)
		elseif interfaceIndex == 2 then
			PetSoul_Fusion_ItemClear(0,1)
		elseif interfaceIndex == 3 then
			PetSoul_Fusion_ItemClear(1,1)
		end
		return
	end

	--bagPos为正常物品BagIndex，表示放入物品
	local theAction = EnumAction( bagPos, "packageitem");
	if theAction:GetID() ~= 0 then

		--判断是不是魂玉
		local nItemIndex = PlayerPackage:GetItemTableIndex(bagPos);
		-- local nItemCount = PlayerPackage:GetBagItemNum(bagPos);
		local nPsIndex, nPsQual = LuaFnGetPetSoulPieceInfo( nItemIndex );
		if nItemIndex == nil or nPsIndex == nil or nPsQual == nil then
			PushDebugMessage("#{SHXT_20211230_111}")
			return
		end

		--检查是否加锁
		if PlayerPackage:IsLock( bagPos ) == 1 then
			PushDebugMessage("#{SHXT_20211230_65}")	--物品已上锁，无法放入
			return
		end
		
		if interfaceIndex == 1 then --向右边框拖入物品
			PetSoul_Fusion_ItemPut(bagPos,1,theAction)
		elseif interfaceIndex == 2 then --向左边框拖入物品
			PetSoul_Fusion_ItemPut(bagPos,2,theAction)
		elseif interfaceIndex == 3 then --点击右键添加物品
			--左格空则放左边
			if g_PetSoul_Fusion_ItemBagIndex1 == -1 then
				PetSoul_Fusion_ItemPut(bagPos,1,theAction)
			--左格不空，右格空，则放右边
			elseif g_PetSoul_Fusion_ItemBagIndex1 ~= -1 and g_PetSoul_Fusion_ItemBagIndex2 == -1 then
				PetSoul_Fusion_ItemPut(bagPos,2,theAction)
			--两个格子都不空，放左边
			elseif g_PetSoul_Fusion_ItemBagIndex1 ~= -1 and g_PetSoul_Fusion_ItemBagIndex2 ~= -1 then
				LifeAbility : Lock_Packet_Item(g_PetSoul_Fusion_ItemBagIndex1,0);
				PetSoul_Fusion_ItemPut(bagPos,1,theAction)
			end
		end
		
	else
		PetSoul_Fusion_ItemClear(1,1)
	end
	
	if(g_PetSoul_Fusion_ItemBagIndex1 >= 0 and g_PetSoul_Fusion_ItemBagIndex2 >= 0 )then
		--判断当前魂玉是否是同一兽魂的碎片
		if PlayerPackage:GetItemTableIndex(g_PetSoul_Fusion_ItemBagIndex1) ~= PlayerPackage:GetItemTableIndex(g_PetSoul_Fusion_ItemBagIndex2) then
			--PushDebugMessage("#{SHXT_20211230_167}")
			PetSoul_Fusion_Info4:SetText("#{SHXT_20211230_203}")
			PetSoul_Fusion_Object3:SetActionItem(-1)
			PetSoul_Fusion_OK:Disable()
			return
		end
	end

	--刷新确认按钮
	if g_PetSoul_Fusion_ItemBagIndex1 ~= -1 or g_PetSoul_Fusion_ItemBagIndex2 ~= -1 then
		PetSoul_Fusion_OK:Enable()
	else
		PetSoul_Fusion_OK:Disable()
		PetSoul_Fusion_Object3:SetActionItem(-1)
	end
	
	--显示兽魂
	local nItem1Bind , nItem2Bind= 0;
	local nItemIndex = 0;
	local nPsIndex, nPsQual =0;

	if(g_PetSoul_Fusion_ItemBagIndex1 ~= -1)then
		if GetItemBindStatus(g_PetSoul_Fusion_ItemBagIndex1) == 1 then
			nItem1Bind = 1
		end
		nItemIndex = PlayerPackage:GetItemTableIndex(g_PetSoul_Fusion_ItemBagIndex1);
		nPsIndex, nPsQual = LuaFnGetPetSoulPieceInfo( nItemIndex );
	end

	if(g_PetSoul_Fusion_ItemBagIndex2 ~= -1)then
		if GetItemBindStatus(g_PetSoul_Fusion_ItemBagIndex2) == 1 then
			nItem2Bind = 1
		end
		nItemIndex = PlayerPackage:GetItemTableIndex(g_PetSoul_Fusion_ItemBagIndex2);
		nPsIndex, nPsQual = LuaFnGetPetSoulPieceInfo( nItemIndex );
	end

	local nBind = 0;
	if(nItem1Bind == 1) or (nItem2Bind == 1)then
		nBind = 1;
	end
	if(nBind == 0)then
		local theAction2 = GemMelting:UpdateProductAction(tonumber(nPsIndex))
		PetSoul_Fusion_Object3:SetActionItem(theAction2:GetID())
	else
		local theAction2 = GemMelting:UpdateProductAction(tonumber(nPsIndex))
		PetSoul_Fusion_Object3:SetActionItem(theAction2:GetID())
	end

	--显示需要的兽魂碎片数
	if g_PetSoul_Fusion_ItemBagIndex1 ~= -1   then
		local nItemIndex = PlayerPackage:GetItemTableIndex(g_PetSoul_Fusion_ItemBagIndex1);
		local nPsIndex, nPsQual = LuaFnGetPetSoulPieceInfo( nItemIndex );
		if(nPsIndex ~= nil and nPsIndex > 0)then
			local text = string.format("#G%s#cfff263凝魂所需#G%s#cfff263数量：#G%s", LuaFnGetItemNameByTableIndex(nPsIndex),LuaFnGetItemNameByTableIndex( nItemIndex ),g_PetSoul_Fusion_QNumber[nPsQual])
			PetSoul_Fusion_Info4:SetText(text)
		end
	end
	if g_PetSoul_Fusion_ItemBagIndex2 ~= -1   then
		local nItemIndex = PlayerPackage:GetItemTableIndex(g_PetSoul_Fusion_ItemBagIndex2);
		local nPsIndex, nPsQual = LuaFnGetPetSoulPieceInfo( nItemIndex );
		if(nPsIndex ~= nil and nPsIndex > 0)then
			local text = string.format("#G%s#cfff263凝魂所需#G%s#cfff263数量：#G%s", LuaFnGetItemNameByTableIndex(nPsIndex),LuaFnGetItemNameByTableIndex( nItemIndex ),g_PetSoul_Fusion_QNumber[nPsQual])
			PetSoul_Fusion_Info4:SetText(text)
		end
	end
end
function LuaFnGetItemNameByTableIndex(ItemID)
	return LifeAbility : GetPrescr_Material(ItemID)
end
function PetSoul_Fusion_OnHiden()
	PetSoul_Fusion_StopCareObject();
	PetSoul_Fusion_Close()
end

function PetSoul_Fusion_Close()
	PetSoul_Fusion_ItemUpdate(-1,3)
	this:Hide()
end

function PetSoul_Fusion_On_ResetPos()
    PetSoul_Fusion_Frame:SetProperty("UnifiedPosition", g_PetSoul_Fusion_UnifiedPosition)
end

function PetSoul_Fusion_FrameInit()
    --界面文字显示初始化
    PetSoul_Fusion_Title:SetText("#{SHXT_20211230_107}")
    PetSoul_Fusion_Info:SetText("#{SHXT_20211230_108}")
	PetSoul_Fusion_Info2:SetText("#{SHXT_20211230_109}")
	PetSoul_Fusion_Info4:SetText("#{SHXT_20211230_201}")
    --按钮文字显示初始化
    PetSoul_Fusion_OK:SetText("#{SHXT_20211230_61}")
    PetSoul_Fusion_Cancel:SetText("#{SHXT_20211230_63}")
    --按钮是否能用初始化
    PetSoul_Fusion_OK:Disable()
end

--=========================================================
--开始关心NPC，
--在开始关心之前需要先确定这个界面是不是已经有“关心”的NPC，
--如果有的话，先取消已经有的“关心”
--=========================================================
function PetSoul_Fusion_BeginCareObject( objCaredId )
	g_PetSoul_Fusion_NpcId = DataPool : GetNPCIDByServerID( objCaredId )
	if g_PetSoul_Fusion_NpcId == -1 then
		this : Hide()
		return
	end

	this : CareObject( g_PetSoul_Fusion_NpcId, 1, "PetSoul_Fusion" )
end

--=========================================================
--停止对某NPC的关心
--=========================================================
function PetSoul_Fusion_StopCareObject()
	this : CareObject( g_PetSoul_Fusion_NpcId, 0, "PetSoul_Fusion" )
	g_PetSoul_Fusion_NpcId = -1
end