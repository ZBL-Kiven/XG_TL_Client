local MAX_OBJ_DISTANCE = 3.0
local DRESS_POS = -1
local g_NeedMoney = 50000
local g_ObjCared = -1

local g_DressWash_Frame_UnifiedPosition;

--PreLoad
function DressWash_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("OBJECT_CARED_EVENT")
	this:RegisterEvent("UPDATE_DRESS_WASH")
	this:RegisterEvent("RESUME_ENCHASE_GEM")
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")
	this:RegisterEvent("UNIT_MONEY")
	this:RegisterEvent("MONEYJZ_CHANGE")
	this:RegisterEvent("OPEN_STALL_SALE")
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

--OnLoad
function DressWash_OnLoad()

	g_DressWash_Frame_UnifiedPosition=DressWash_Frame:GetProperty("UnifiedPosition");
end

--OnEvent
function DressWash_OnEvent(event)
	if event == "UI_COMMAND" then
	 	if arg0 ~= nil and tonumber(arg0) == 0910282 then
			if this:IsVisible() then
				this:Hide()
			end
			DressWash_OK:Disable()
			
			this:Show()
			local xx = Get_XParam_INT(0);
			local objCared = DataPool:GetNPCIDByServerID(xx);
			if objCared == -1 then
				return;
			end
			BeginCareObject_DressWash(objCared)
		
			DressWash_DemandMoney:SetProperty("MoneyNumber", g_NeedMoney)
			local playerMoney = Player:GetData("MONEY")
			DressWash_SelfMoney:SetProperty("MoneyNumber", playerMoney)
			local playerJZ = Player:GetData("MONEY_JZ")
			DressWash_SelfJiaozi:SetProperty("MoneyNumber", playerJZ)
		
		elseif arg0 ~= nil and tonumber(arg0) == 910283 then
			if this:IsVisible() then
				DressWash_Clear()
			end			
		end			
	elseif event ==	"UPDATE_DRESS_WASH" then
		if arg0 ~= nil and arg1 ~= nil then
			DressWash_Update(tonumber(arg0), tonumber(arg1))
		end
	elseif event == "OBJECT_CARED_EVENT" then
		if(arg0 ~= nil and tonumber(arg0) ~= objCared) then
			return;
		end		
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then		
			--取消关心
			this:Hide()
		end	
			
	elseif event == "RESUME_ENCHASE_GEM" and this:IsVisible() then		
		if(arg0~=nil and tonumber(arg0) == 97) then
			DressWash_Resume_Equip()
		end
	elseif event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() then
		if( arg0~= nil and -1 == tonumber(arg0)) then
			return;
		end
		if (DRESS_POS == tonumber(arg0)) then
			DressWash_Update(tonumber(arg0), 1)
		end
	elseif (event == "UNIT_MONEY" and this:IsVisible()) then
		DressWash_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
	elseif (event == "MONEYJZ_CHANGE" and this:IsVisible()) then
		DressWash_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));

	elseif (event == "OPEN_STALL_SALE" and this:IsVisible()) then
		--和摆摊界面互斥
		this:Hide()
		
	elseif (event == "ADJEST_UI_POS" ) then
		DressWash_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		DressWash_Frame_On_ResetPos()

	end
end

function DressWash_Update(Pos, isEquip)
	--DressWash_Clear()
	
	if isEquip == 1 then
		local theAction = EnumAction(Pos, "packageitem")
		if theAction:GetID() ~= 0 then
			--物品是否已加锁
			if PlayerPackage:IsLock(Pos) == 1 then
				PushDebugMessage("#{SZPR_091023_16}")
				--DressWash_Clear()
				return
			end

			--物品是否是时装
			local EquipPoint = LifeAbility:Get_Equip_Point(Pos)
			if EquipPoint ~= 16 then
				PushDebugMessage("#{SZPR_091023_17}")
				--DressWash_Clear()
				return
			end
	
			--是不是已染色（可还原）时装 
			local canWash = DressReplaceColor:DressCanWash(Pos)
			if canWash ~= 1 then
				PushDebugMessage("#{SZPR_091023_27}")
				--DressWash_Clear()
				return
			end

			DressWash_Clear()
			
			DRESS_POS = Pos;
			LifeAbility:Lock_Packet_Item(DRESS_POS, 1)	
			DressWash_Object:SetActionItem(theAction:GetID())
		
			--启用确定按钮
			DressWash_OK:Enable()
			return
		else
			--DressWash_Clear()
			PushDebugMessage("#{SZPR_091023_17}")
			return
		end
	else
		PushDebugMessage("#{SZPR_091023_17}")
		--DressWash_Clear()
		return
	end
end

function DressWash_Resume_Equip()	
	DressWash_Clear()	
end

function DressWash_Clear()
	if(DRESS_POS ~= -1) then
		--禁用确定按钮
		DressWash_OK:Disable()
		DressWash_Object:SetActionItem(-1)
		LifeAbility:Lock_Packet_Item(DRESS_POS, 0)
		DRESS_POS = -1
	end
end

function DressWash_OnHiden()
	StopCareObject_DressWash(objCared)
	DressWash_Clear()
	return
end

function DressWash_OK_Clicked()
	--金钱是否足够
	local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")
	if selfMoney < g_NeedMoney then
		PushDebugMessage("#{RXZS_090804_11}")
		return
	end

	Clear_XSCRIPT()
	Set_XSCRIPT_Function_Name("OnDressWash")
	Set_XSCRIPT_ScriptID(830002)
	Set_XSCRIPT_Parameter(0, DRESS_POS)
	Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
end


function BeginCareObject_DressWash(objCaredId)
	g_ObjCared = objCaredId
	this:CareObject(g_ObjCared, 1, "DressWash")
end


function StopCareObject_DressWash(objCaredId)
	this:CareObject(g_ObjCared, 0, "DressWash")
	g_ObjCared = -1
end

function DressWash_Frame_On_ResetPos()
  DressWash_Frame:SetProperty("UnifiedPosition", g_DressWash_Frame_UnifiedPosition);
end