--武魂拓展属性栏开辟
local m_UI_NUM = 20090721
local m_ObjCared = -1
local m_Equip_Idx = -1
local m_Equip_Item = -1
--local g_ItemItm   = -1;
local UI_TYPE_ATTR	= 1--武魂扩展属性学习
local UI_TYPE_COMPOUND	= 2--武魂提升灵力
local UI_TYPE_LIFE	= 3--武魂增加寿命
local UI_TYPE_SLOT	= 4--武魂开辟属性栏

local m_UIType = 0

local INDEX_SLOT_ITEM1 = 20310158 --麟木剑
local INDEX_SLOT_ITEM2 = 20310159 --破天剑

local needMoney = 0
local nKfsData = ""

local g_YBCheck = 1--默认选中
g_WuHun_Material_Buy = -1--快捷购买

local g_LastTimer = -1 --增加点击扩展武魂属性的冷却时间
local MIN_PASS_TIME = 200 --200ms--冷却时间1秒

--PreLoad
function WuhunPropertyCreate_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("UPDATE_KFS_PROPERTYCREATE")
	this:RegisterEvent("UNIT_MONEY",false);
	this:RegisterEvent("MONEYJZ_CHANGE",false);
	this:RegisterEvent("BUY_ITEM")
	this:RegisterEvent("PACKAGE_ITEM_CHANGED_EX",false);
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)	--进场景关闭界面
end

--OnLoad
function WuhunPropertyCreate_OnLoad()

end

--OnEvent
function WuhunPropertyCreate_OnEvent(event)

	if (event == "UI_COMMAND" and tonumber(arg0) == m_UI_NUM) then
		
		WuhunPropertyCreate_BeginCareObj( Get_XParam_INT(0) );
		m_UIType = Get_XParam_INT(1)
		
		if m_UIType == UI_TYPE_SLOT then
			WuhunPropertyCreate_Update(-1)
			WuhunPropertyCreate_Update_Sub(-1)
			this:Show();
			-- 元宝确认
			if g_YBCheck == 1 then
				--WuhunPropertyCreate_Blank_Queren:SetCheck( 1 )
			elseif g_YBCheck == 0 then
				--WuhunPropertyCreate_Blank_Queren:SetCheck( 0 )
			end
		end		

	
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 201107281 and this:IsVisible() ) then		
		if m_Equip_Idx ~= -1 then
			WuhunPropertyCreate_Update_Sub( tonumber(arg1) )
		else 
			nKfsData = SuperTooltips:GetAuthorInfo();
			WuhunPropertyCreate_Update( tonumber(arg1) )
		end
	elseif (event == "UNIT_MONEY") then
		WuhunPropertyCreate_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
	
	elseif (event == "MONEYJZ_CHANGE") then 
		WuhunPropertyCreate_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
	
	elseif event == "BUY_ITEM" and this:IsVisible() then 
		if m_Equip_Idx ~= -1 and g_WuHun_Material_Buy > 0 then
			local item = tonumber(arg1)
			if item > 0 then
				if INDEX_SLOT_ITEM2 ~= item then 
					return 
				end
				local itemIdx = PlayerPackage:GetBagPosByItemIndex(item)
				if itemIdx >= 0 then
					g_WuHun_Material_Buy = -1
					WuhunPropertyCreate_Update_Sub(itemIdx)
				end
			end
		end
		
	elseif (event == "PACKAGE_ITEM_CHANGED_EX") then 
		if arg0 ~= nil and tonumber(arg0) == m_Equip_Idx then
			WuhunPropertyCreate_Update(m_Equip_Idx)
		
		elseif  arg0 ~= nil and tonumber(arg0) == m_Equip_Item then
			WuhunPropertyCreate_Update_Sub(m_Equip_Item)
		end
	elseif ( event == "HIDE_ON_SCENE_TRANSED" ) then
		this:Hide()
	end
end

--Update UI
function WuhunPropertyCreate_Update(itemIdx)

	local theAction = EnumAction(itemIdx, "packageitem");
	if theAction:GetID() ~= 0 then
		
		if LifeAbility : Get_Equip_Point(itemIdx) ~= 18 then
			PushDebugMessage("#{WH_090729_13}") -- 此处只能放入武魂。
			return
		end
		
		local _,comLv,_,_,_,nExAttrNum = LuaGetKfsAttrData(nKfsData)
		local slotNum = comLv - nExAttrNum
		if comLv ~=nil and slotNum ~= nil and slotNum >= comLv then
			if m_Equip_Idx == itemIdx then
				WuhunPropertyCreate_Object1:SetActionItem(-1);			
				LifeAbility : Lock_Packet_Item(m_Equip_Idx,0);		
				m_Equip_Idx = -1;
				return
			end
			if slotNum == 10 then
				PushDebugMessage("#{WH_090817_13}") -- 武魂的扩展属性栏数已经到达最大值10栏。
			else
				PushDebugMessage("#{WH_090729_50}") -- 该武魂不能开辟新的属性栏。提升灵力等级后，可以开辟新的属性栏。
			end
			return
		end
		
		if m_Equip_Idx ~= -1 then
			LifeAbility : Lock_Packet_Item(m_Equip_Idx,0);
		end
		
		WuhunPropertyCreate_Object1:SetActionItem(theAction:GetID());
		LifeAbility : Lock_Packet_Item(itemIdx,1);
		m_Equip_Idx = itemIdx
		
	else
		WuhunPropertyCreate_Object1:SetActionItem(-1);			
		LifeAbility : Lock_Packet_Item(m_Equip_Idx,0);		
		m_Equip_Idx = -1;
		WuhunPropertyCreate_Update_Sub(-1)-- 取消材料的置入状态
	end
	WuhunPropertyCreate_UICheck();

end

function WuhunPropertyCreate_Update_Sub(itemIdx)
	local theAction = EnumAction(itemIdx, "packageitem");
	if theAction:GetID() ~= 0 then		
		-- 该界面是否已置入武魂
		if m_Equip_Idx == -1 then
			PushDebugMessage("#{WHYH_161121_133}")
			return
		end
		if LifeAbility : Get_Equip_Point(m_Equip_Idx) ~= 18 then
			PushDebugMessage("#{WHYH_161121_133}")
			return
		end
		
		-- 道具是否为麟木箭/破天箭
		local itemID = PlayerPackage:GetItemTableIndex(itemIdx)
		if itemID ~=  INDEX_SLOT_ITEM1 and itemID ~= INDEX_SLOT_ITEM2 then
			PushDebugMessage("#{WHYH_161121_134}") --此处只能放入麟木箭、破天剑
			return
		end

		-- 当前麟木箭/破天箭是否已加锁
		if PlayerPackage:IsLock( itemIdx ) == 1 then
			PushDebugMessage("#{WHYH_161121_38}")	--道具已上锁
			return
		end

		if m_Equip_Item ~= -1 then
			LifeAbility : Lock_Packet_Item(m_Equip_Item,0);
		end
		WuhunPropertyCreate_Object2:SetActionItem(theAction:GetID());
		LifeAbility : Lock_Packet_Item(itemIdx,1);
		m_Equip_Item = itemIdx
	else
		WuhunPropertyCreate_Object2:SetActionItem(-1);			
		LifeAbility : Lock_Packet_Item(m_Equip_Item,0);		
		m_Equip_Item = -1;
	end

	WuhunPropertyCreate_UICheck()
end

--Care Obj
function WuhunPropertyCreate_BeginCareObj(obj_id)
	
	m_ObjCared = DataPool : GetNPCIDByServerID(obj_id);
	this:CareObject(m_ObjCared, 1);
end

--add by kaibin for tt86633 2010-12-9
--点击增加扩展属性cooldown时间检查
function AddExtAttr_PassTime()
   local iCur = Exchange:GetTickCount();

	if g_LastTimer == -1 then
		g_LastTimer = iCur;
		return 1
	end

   if ( iCur - g_LastTimer < MIN_PASS_TIME) then
      return 0
   else
      g_LastTimer = iCur;
   	  return 1
   end
end

--OnOK
function WuhunPropertyCreate_OK_Clicked()
	
	-- 判断是否为安全时间
	if (tonumber(DataPool:GetLeftProtectTime()) > 0) then
		PushDebugMessage("#{WHYH_161121_8}")
		return
	end

	-- 是否放入武魂
	if m_Equip_Idx == -1 then
		PushDebugMessage("#{WHYH_161121_13}")
		return
	end
	if LifeAbility : Get_Equip_Point(m_Equip_Idx) ~= 18 then
		PushDebugMessage("#{WHYH_161121_13}")
		return
	end
		
	-- 玩家身上的金钱是否足够
	local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")	
	if selfMoney < needMoney then
		PushDebugMessage("#{WHYH_161121_16}")  --对不起，你身上金钱不足，无法继续进行。
		return
	end
	
	--add by kaibin 增加点击增加武魂扩展属性冷却时间判断
	if AddExtAttr_PassTime() == 0 then
		return
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("AddKfsSlot");
		Set_XSCRIPT_ScriptID(900004);
		Set_XSCRIPT_Parameter(0,m_Equip_Idx);
		Set_XSCRIPT_Parameter(1,m_Equip_Item);
		Set_XSCRIPT_Parameter(2,g_YBCheck);
		Set_XSCRIPT_ParamCount(3);
	Send_XSCRIPT();
	WuhunPropertyCreate_Resume_Equip();
end

--Right button clicked
function WuhunPropertyCreate_Resume_Equip()

	WuhunPropertyCreate_Update(-1)

end

--Right button clicked
function WuhunPropertyCreate_Resume_Item()
	
	WuhunPropertyCreate_Update_Sub(-1)
	
end

--handle Hide Event
function WuhunPropertyCreate_OnHiden()

	WuhunPropertyCreate_Update(-1)
	WuhunPropertyCreate_Update_Sub(-1)

end

function WuhunPropertyCreate_UICheck()
	WuhunPropertyCreate_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"));
	WuhunPropertyCreate_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ")); 
	WuhunPropertyCreate_DemandMoney : SetProperty("MoneyNumber", 0)
	WuhunPropertyCreate_OK:Disable()
	-- 合成等级控件
	WuhunPropertyCreate_WHHeChengLevel_text2:SetText("")
	-- 扩展栏数控件
	WuhunPropertyCreate_WHKuoZhanShuXingLan_text2:SetText("")
	
	local _,comLv,_,_,_,slotNum = LuaGetKfsAttrData(nKfsData)
	if m_Equip_Idx ~= -1 then
		needMoney = Lua_GetBagKfsSlotMoney(slotNum);
		WuhunPropertyCreate_DemandMoney : SetProperty("MoneyNumber", needMoney)
	end
	
	if m_Equip_Idx ~= -1 then-- 可以不放打孔材料
		WuhunPropertyCreate_OK:Enable()
		-- 合成等级控件
		WuhunPropertyCreate_WHHeChengLevel_text2:SetText(tostring(comLv))
		-- 扩展栏数控件
		WuhunPropertyCreate_WHKuoZhanShuXingLan_text2:SetText(tostring(slotNum).."/"..tostring(comLv))
	end
end

function WuhunPropertyCreate_Queren_Clicked()
	-- local bCheck = --WuhunPropertyCreate_Blank_Queren:GetCheck();
	-- if ( bCheck == 1 ) then
		-- g_YBCheck = 1
		--WuhunPropertyCreate_Blank_Queren:SetCheck( 1 )
	-- elseif ( bCheck == 0 ) then
		-- g_YBCheck = 0
		--WuhunPropertyCreate_Blank_Queren:SetCheck( 0 )
	-- end
end

--Help
function WuhunPropertyCreate_Help_Clicked()
	if m_UIType == UI_TYPE_ATTR then
		Helper:GotoHelper("*WuhunExtraPropertyUp")
	elseif m_UIType == UI_TYPE_COMPOUND then
		Helper:GotoHelper("*WuhunPropertyCreate")
	elseif m_UIType == UI_TYPE_LIFE then
		Helper:GotoHelper("*Wuhun")
	elseif m_UIType == UI_TYPE_SLOT then
		Helper:GotoHelper("*WuhunExtraPropertyUp")
	end	
end

function Lua_GetBagKfsSlotMoney(nSlotNum)
	local nKfsSlotTab = {
		{1000 ,20310158 ,1000 ,20310159 ,10000},
		{700 ,20310158 ,800 ,20310159 ,20000},
		{350 ,20310158 ,500 ,20310159 ,30000},
		{200 ,20310158 ,300 ,20310159 ,40000},
		{100 ,20310158 ,150 ,20310159 ,50000},
		{40 ,20310158 ,80 ,20310159 ,60000},
		{20 ,20310158 ,40 ,20310159 ,70000},
		{15 ,20310158 ,30 ,20310159 ,80000},
		{10 ,20310158 ,20 ,20310159 ,90000},
		{5 ,20310158 ,10 ,20310159 ,100000},
	}
	local nCostMoney = 0
	if nSlotNum ~= nil and nKfsSlotTab[nSlotNum + 1] ~= nil then
		nCostMoney = nKfsSlotTab[nSlotNum + 1][5]
	end
	return nCostMoney
end
