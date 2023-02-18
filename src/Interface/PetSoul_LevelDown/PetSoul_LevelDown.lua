--魂兽返魂 PetSoul_LevelDown

local g_PetSoul_LevelDown_UnifiedPosition;

local MAX_OBJ_DISTANCE = 3.0

local g_PetSoul_LevelDown_NpcId = -1;

local g_PetSoul_LevelDown_ItemBagIndex = -1

local g_PetSoul_LevelDown_TargetId = -1


function PetSoul_LevelDown_PreLoad()

	this:RegisterEvent("UI_COMMAND");

	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")

    this:RegisterEvent("OBJECT_CARED_EVENT");           --某逻辑对象的某些发生改变，用于距离NPC够远则关闭界面
    
    this:RegisterEvent("UNIT_MONEY")					--金钱变化
	this:RegisterEvent("MONEYJZ_CHANGE")			    --交子变化

	this:RegisterEvent("PETSOUL_LEVELDOWN_PUTIN_ITEM"); --放入物品
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")			--背包中物品改变
	this:RegisterEvent("RESUME_ENCHASE_GEM"); --拖拽回背包
	
end

function PetSoul_LevelDown_OnLoad()
    
    g_PetSoul_LevelDown_UnifiedPosition=PetSoul_LevelDown_Frame:GetProperty("UnifiedPosition")
	
end

function PetSoul_LevelDown_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == 80012705 ) then
		local bIsShow = Get_XParam_INT(0);
		if bIsShow == 1 then
			this:Show()
            OpenWindow("Packet")
        end

        if this:IsVisible() then
			g_PetSoul_LevelDown_TargetId = Get_XParam_INT( 1 )
            PetSoul_LevelDown_BeginCareObject( g_PetSoul_LevelDown_TargetId )
            PetSoul_LevelDown_FrameInit()
            PetSoul_LevelDown_MoneyUpdate()
		end

		return
	elseif event == "UI_COMMAND" and tonumber(arg0) == 201107281 and this:IsVisible() then
		if arg1 ~= nil then 
			PetSoul_LevelDown_ItemUpdate(tonumber(arg1))
		end

		return
	elseif( event == "RESUME_ENCHASE_GEM" and this:IsVisible() ) then
		if(arg0~=nil and tonumber(arg0) == 29) then---xml里配置的是 兽魂W29 
			PetSoul_LevelDown_Resume_Equip()
		end
		
		return
	elseif event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() then
		if not arg0 or tonumber(arg0) == -1 then
			return
		end
		
		if tonumber(arg0) == g_PetSoul_LevelDown_ItemBagIndex then
			PetSoul_LevelDown_ItemUpdate(-1)
		end 
		
		PetSoul_LevelDown_MoneyUpdate()--界面钱数刷新

		return
    elseif event == "OBJECT_CARED_EVENT" and this : IsVisible() then
		if(tonumber(arg0) ~= g_PetSoul_LevelDown_NpcId) then
			return;
		end
		
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if arg1 == "distance" and tonumber( arg2 ) > MAX_OBJ_DISTANCE or arg1 == "destroy" then
			PetSoul_LevelDown_Close()
		end

        return
    elseif event == "UNIT_MONEY" or event == "MONEYJZ_CHANGE" then
        PetSoul_LevelDown_MoneyUpdate()--金钱交子 数量刷新
        return
    elseif event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED"then
		PetSoul_LevelDown_On_ResetPos()
		return
	end
end

function PetSoul_LevelDown_ItemUpdate(bagPos)

	--bagPos为-1，表示要初始化界面  关闭界面 右键取出物品时调用
	if bagPos == -1 then
		--放入物品栏置空
		PetSoul_LevelDown_Object:SetActionItem(-1)
		--蒙红物品解锁
		if g_PetSoul_LevelDown_ItemBagIndex ~= -1 then
			LifeAbility : Lock_Packet_Item(g_PetSoul_LevelDown_ItemBagIndex,0);
			g_PetSoul_LevelDown_ItemBagIndex = -1;
		end

		PetSoul_LevelDown_Explain:SetText("#{SHXT_20211230_122}")
		PetSoul_LevelDown_NeedYuanBaoObject:SetText("#{SHXT_20211230_121}")
		PetSoul_LevelDown_Demand_Jiaozi:SetProperty("MoneyNumber", "0")

		--刷新确认按钮
		if g_PetSoul_LevelDown_ItemBagIndex ~= -1 then
			PetSoul_LevelDown_OK:Enable()
		else
			PetSoul_LevelDown_OK:Disable()
		end
		
		return
	end
	
	--bagPos为正常物品BagIndex，表示放入物品
	local theAction = EnumAction( bagPos, "packageitem");
	if theAction:GetID() ~= 0 then

		--检查是否为兽魂
		local nLevel=LuaFnGetPetSoulDataInBag( bagPos, "LEVEL")
		if nLevel == nil  then
			PushDebugMessage("#{SHXT_20211230_124}")
			return
		end

		--判断物品是否上锁 
		if PlayerPackage:IsLock(bagPos) == 1 then
			PushDebugMessage("#{SHXT_20211230_65}")
			return
		end

		--检查兽魂等级是否大于1
		if(nLevel <= 1)then
			PushDebugMessage("#{SHXT_20211230_125}")
			return
		end

		--蒙红物品解锁
		if g_PetSoul_LevelDown_ItemBagIndex ~= -1 then
			LifeAbility : Lock_Packet_Item(g_PetSoul_LevelDown_ItemBagIndex,0);
			g_PetSoul_LevelDown_ItemBagIndex = -1;
		end
		g_PetSoul_LevelDown_ItemBagIndex = bagPos;
		PetSoul_LevelDown_Object:SetActionItem(theAction:GetID());
		LifeAbility : Lock_Packet_Item(bagPos,1);

		local nQual=LuaFnGetPetSoulDataInBag( bagPos, "QUAL")
		local nGiveItemCount,nItemCount,nMoneyCount = LuaFnGetPetSoulLeveldownCost(nLevel,nQual)

		PetSoul_LevelDown_NeedYuanBaoObject:SetText(string.format("#cfff263需要消耗返魂丹：#G%s#cfff263个",tostring(nItemCount)))
		PetSoul_LevelDown_Explain:SetText(string.format("可得到的升魂丹数量：#G%s#cfff263个",tostring(nGiveItemCount)))
		PetSoul_LevelDown_Demand_Jiaozi:SetProperty("MoneyNumber", tostring(nMoneyCount))
	else
		--放入物品栏置空
		PetSoul_LevelDown_Object:SetActionItem(-1)
		--蒙红物品解锁
		if g_PetSoul_LevelDown_ItemBagIndex ~= -1 then
			LifeAbility : Lock_Packet_Item(g_PetSoul_LevelDown_ItemBagIndex,0);
			g_PetSoul_LevelDown_ItemBagIndex = -1;
		end
	end

	--刷新确认按钮
	if g_PetSoul_LevelDown_ItemBagIndex ~= -1 then
		PetSoul_LevelDown_OK:Enable()
	else
		PetSoul_LevelDown_OK:Disable()
	end
end

function PetSoul_LevelDown_Buttons_Clicked()
	--二级密码 电话密保检查
	-- if CheckPhoneMibaoAndMinorPassword() ~= 1 then
		-- PushDebugMessage("#{SHXT_20211230_67}")
		-- return
	-- end
	
	--是否放入兽魂
	if g_PetSoul_LevelDown_ItemBagIndex < 0 then
		PushDebugMessage("#{SHXT_20211230_68}")
		return
	end

	Clear_XSCRIPT()
		Set_XSCRIPT_ScriptID( 742563 )
		Set_XSCRIPT_Function_Name( "PetSoulCenter" )
		Set_XSCRIPT_Parameter(0, 2)
		Set_XSCRIPT_Parameter(1, g_PetSoul_LevelDown_TargetId)
		Set_XSCRIPT_Parameter(2, g_PetSoul_LevelDown_ItemBagIndex)
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
end

function PetSoul_LevelDown_Resume_Equip()

	PetSoul_LevelDown_ItemUpdate(-1)
end


function PetSoul_LevelDown_OnHiden()
	PetSoul_LevelDown_StopCareObject();
	PetSoul_LevelDown_Close()
end

function PetSoul_LevelDown_Close()
	PetSoul_LevelDown_ItemUpdate(-1)
	this:Hide()
end

function PetSoul_LevelDown_On_ResetPos()
    PetSoul_LevelDown_Frame:SetProperty("UnifiedPosition", g_PetSoul_LevelDown_UnifiedPosition)
end

function PetSoul_LevelDown_FrameInit()
    --界面文字显示初始化
    PetSoul_LevelDown_Title:SetText("#{SHXT_20211230_118}")
    PetSoul_LevelDown_Info:SetText("#{SHXT_20211230_119}")
	PetSoul_LevelDown_Info2:SetText("#{SHXT_20211230_120}")
	PetSoul_LevelDown_Explain:SetText("#{SHXT_20211230_122}")
    --按钮文字显示初始化
    PetSoul_LevelDown_OK:SetText("#{SHXT_20211230_61}")
	PetSoul_LevelDown_Cancel:SetText("#{SHXT_20211230_63}")
    --按钮是否能用初始化
    PetSoul_LevelDown_OK:Disable()
end

--金钱交子 数量刷新
function PetSoul_LevelDown_MoneyUpdate()
    PetSoul_LevelDown_Currently_Money:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
	PetSoul_LevelDown_Currently_Jiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
end

--=========================================================
--开始关心NPC，
--在开始关心之前需要先确定这个界面是不是已经有“关心”的NPC，
--如果有的话，先取消已经有的“关心”
--=========================================================
function PetSoul_LevelDown_BeginCareObject( objCaredId )
	g_PetSoul_LevelDown_NpcId = DataPool : GetNPCIDByServerID( objCaredId )
	if g_PetSoul_LevelDown_NpcId == -1 then
		this : Hide()
		return
	end
	this : CareObject( g_PetSoul_LevelDown_NpcId, 1, "PetSoul_LevelDown" )
end

--=========================================================
--停止对某NPC的关心
--=========================================================
function PetSoul_LevelDown_StopCareObject()
	this : CareObject( g_PetSoul_LevelDown_NpcId, 0, "PetSoul_LevelDown" )
	g_PetSoul_LevelDown_NpcId = -1
end


