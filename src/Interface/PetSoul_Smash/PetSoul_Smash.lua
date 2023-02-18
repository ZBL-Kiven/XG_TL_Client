--魂兽化玉 PetSoul_Smash

local g_PetSoul_Smash_UnifiedPosition;

local MAX_OBJ_DISTANCE = 3.0

local g_PetSoul_Smash_NpcId = -1;

local g_PetSoul_Smash_ItemBagIndex = -1

local g_PetSoul_Smash_TargetId = -1

local g_PetSoul_Smash_CostList ={
	[0] = {piecesNumber = 20,moneyCost =100000},
	[1] = {piecesNumber = 30,moneyCost =300000},
	[2] = {piecesNumber = 40,moneyCost =1000000},
}

function PetSoul_Smash_PreLoad()

	this:RegisterEvent("UI_COMMAND");

	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")

    this:RegisterEvent("OBJECT_CARED_EVENT");           --某逻辑对象的某些发生改变，用于距离NPC够远则关闭界面

    this:RegisterEvent("UNIT_MONEY")					--金钱变化
	this:RegisterEvent("MONEYJZ_CHANGE")			    --交子变化
	
	this:RegisterEvent("PETSOUL_SMASH_PUTIN_ITEM"); --放入物品
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")			--背包中物品改变
	this:RegisterEvent("RESUME_ENCHASE_GEM"); --拖拽回背包
end

function PetSoul_Smash_OnLoad()
    
    g_PetSoul_Smash_UnifiedPosition=PetSoul_Smash_Frame:GetProperty("UnifiedPosition")
	
end

function PetSoul_Smash_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == 80012706 ) then
		local bIsShow = Get_XParam_INT(0);
		if bIsShow == 1 then
			this:Show()--打开界面
            OpenWindow("Packet")--打开背包
        end

        if this:IsVisible() then
			g_PetSoul_Smash_TargetId = Get_XParam_INT( 1 )
            PetSoul_Smash_BeginCareObject( g_PetSoul_Smash_TargetId )
            PetSoul_Smash_FrameInit() 
            PetSoul_Smash_MoneyUpdate()--金钱交子 数量刷新
		end

		return
	elseif event == "UI_COMMAND" and tonumber(arg0) == 201107281 and this:IsVisible() then
		if arg1 ~= nil then
			PetSoul_Smash_ItemUpdate(tonumber(arg1))
		end

		return
	elseif( event == "RESUME_ENCHASE_GEM" and this:IsVisible() ) then
		if(arg0~=nil) then---xml里配置的是W31
			PetSoul_Smash_Resume_Equip()
		end

		return
	elseif event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() then
		if not arg0 or tonumber(arg0) == -1 then
			return
		end
		
		if tonumber(arg0) == g_PetSoul_Smash_ItemBagIndex then
			PetSoul_Smash_ItemUpdate(-1)
		end 
		
		PetSoul_Smash_MoneyUpdate()--界面钱数刷新

		return
    elseif event == "OBJECT_CARED_EVENT" and this : IsVisible() then
		if(tonumber(arg0) ~= g_PetSoul_Smash_NpcId) then
			return;
		end
		
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if arg1 == "distance" and tonumber( arg2 ) > MAX_OBJ_DISTANCE or arg1 == "destroy" then
			PetSoul_Smash_Close()
		end

        return
    elseif event == "UNIT_MONEY" or event == "MONEYJZ_CHANGE" then
        PetSoul_Smash_MoneyUpdate()--金钱交子 数量刷新
        return
    elseif event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		PetSoul_Smash_On_ResetPos()
		return
	end
end

function PetSoul_Smash_Buttons_Clicked()

	-- local nQual=PlayerPackage:LuaFnGetPetSoulDataInBag( g_PetSoul_Smash_ItemBagIndex, "QUAL")
	-- if nQual == nil or g_PetSoul_Smash_ItemBagIndex < 0 then
		-- PushDebugMessage("#{SHXT_20211230_68}")
	-- end

	Clear_XSCRIPT()
		Set_XSCRIPT_ScriptID( 742562 )
		Set_XSCRIPT_Function_Name( "OnPetSoulSmash" )
		Set_XSCRIPT_Parameter(0, g_PetSoul_Smash_TargetId)
		Set_XSCRIPT_Parameter(1, g_PetSoul_Smash_ItemBagIndex)
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()
end

function PetSoul_Smash_Resume_Equip()
	PetSoul_Smash_ItemUpdate(-1)
end

function PetSoul_Smash_ItemUpdate(bagPos)

	--bagPos为-1，表示要初始化界面  关闭界面 右键取出物品时调用
	if bagPos == -1 then
		--确认按钮不能用
		PetSoul_Smash_OK:Disable()
		--物品置空
		PetSoul_Smash_Object:SetActionItem(-1);
		if g_PetSoul_Smash_ItemBagIndex ~= -1 then
			LifeAbility : Lock_Packet_Item(g_PetSoul_Smash_ItemBagIndex,0);
			g_PetSoul_Smash_ItemBagIndex = -1
		end
		--置可获得碎片数量
		PetSoul_Smash_Explain:SetText("#{SHXT_20211230_134}")
		--需求金币置零
		PetSoul_Smash_Demand_Jiaozi:SetProperty("MoneyNumber", "0")
		return
	end

	local theAction = EnumAction( bagPos, "packageitem");
	if theAction:GetID() ~= 0 then
		
		--判断是不是魂兽
		-- local nLevel=PlayerPackage:LuaFnGetPetSoulDataInBag( bagPos, "LEVEL")
		local nQual=LuaFnGetPetSoulDataInBag( bagPos, "QUAL")
		-- local nPetSoulIndex = PlayerPackage:GetItemTableIndex(bagPos);
		if nQual == nil then
			PushDebugMessage("#{SHXT_20211230_136}")
			return
		end

		--判断物品是否上锁 
		if PlayerPackage:IsLock(bagPos) == 1 then
			PushDebugMessage("#{SHXT_20211230_65}")
			return
		end

		--如果物品栏里有物品，先取消物品蒙红
		if g_PetSoul_Smash_ItemBagIndex ~= -1 then
			LifeAbility : Lock_Packet_Item(g_PetSoul_Smash_ItemBagIndex,0);
			g_PetSoul_Smash_ItemBagIndex = -1
		end
		PetSoul_Smash_Object:SetActionItem(theAction:GetID());
		g_PetSoul_Smash_ItemBagIndex = bagPos
		LifeAbility : Lock_Packet_Item(bagPos,1);

		--根据魂兽品质获取可获得碎片数量和需求金币数量
		if(nQual == nil)then
			return
		end

		--置需求金币
		PetSoul_Smash_Demand_Jiaozi:SetProperty("MoneyNumber", g_PetSoul_Smash_CostList[nQual].moneyCost)

		local piecesNumber = g_PetSoul_Smash_CostList[nQual].piecesNumber
		--置可获得碎片数量
		PetSoul_Smash_Explain:SetText(string.format("可得到的魂玉数量：#G%s#cfff263",tostring(piecesNumber)))

		PetSoul_Smash_OK:Enable()--确认按钮能用
	end
end

function PetSoul_Smash_OnHiden()
	PetSoul_Smash_StopCareObject();
	PetSoul_Smash_Close()
end

function PetSoul_Smash_Close()
	PetSoul_Smash_ItemUpdate(-1)
	this:Hide()
end

function PetSoul_Smash_On_ResetPos()
    PetSoul_Smash_Frame:SetProperty("UnifiedPosition", g_PetSoul_Smash_UnifiedPosition)
end

function PetSoul_Smash_FrameInit()
    --界面文字显示初始化
    PetSoul_Smash_Title:SetText("#{SHXT_20211230_131}")
    PetSoul_Smash_Info:SetText("#{SHXT_20211230_132}")
    PetSoul_Smash_Info2:SetText("#{SHXT_20211230_133}")
    --按钮文字显示初始化
    PetSoul_Smash_OK:SetText("#{SHXT_20211230_61}")
    PetSoul_Smash_Cancel:SetText("#{SHXT_20211230_63}")
    --按钮是否能用初始化
	PetSoul_Smash_OK:Disable()
	--需求金币数量初始化
	PetSoul_Smash_Demand_Jiaozi:SetProperty("MoneyNumber", "0")
end

--金钱交子 数量刷新
function PetSoul_Smash_MoneyUpdate()

    PetSoul_Smash_Currently_Money:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
	PetSoul_Smash_Currently_Jiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))

end

--=========================================================
--开始关心NPC，
--在开始关心之前需要先确定这个界面是不是已经有“关心”的NPC，
--如果有的话，先取消已经有的“关心”
--=========================================================
function PetSoul_Smash_BeginCareObject( objCaredId )
	g_PetSoul_Smash_NpcId = DataPool : GetNPCIDByServerID( objCaredId )
	if g_PetSoul_Smash_NpcId == -1 then
		this : Hide()
		return
	end

	this : CareObject( g_PetSoul_Smash_NpcId, 1, "PetSoul_Smash" )
end

--=========================================================
--停止对某NPC的关心
--=========================================================
function PetSoul_Smash_StopCareObject()
	this : CareObject( g_PetSoul_Smash_NpcId, 0, "PetSoul_Smash" )
	g_PetSoul_Smash_NpcId = -1
end