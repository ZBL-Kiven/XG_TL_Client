--����ϵͳ
---===================================================
local MAX_OBJ_DISTANCE = 3.0
local g_CaredNpc = -1
local g_DWCHAICHU_Item = {}
local g_DWCHAICHU_Object = {}
local g_DWCHAICHU_GRID_SKIP = 100	-- G101 -> G102
local g_DWCHAICHU_DemandMoney = 50000
local g_DWChaichu_EquipData = ""

local g_DWCHAICHU_Action_Type = 3
local g_DWCHAICHU_RScript_ID = 900014
local g_DWCHAICHU_RScript_Name = "DoDiaowenAction"

local g_DWCHAICHU_Clicked_Num = 0			-- �Ƿ��Ѿ�����һ�Ρ�ȷ���� by lhx tt80366

local g_DWChaichu_Frame_UnifiedPosition;
local g_ChaichuDirectly = 0

local g_DWCHAICHU_Select = 1 -- Ҫ����ĵ��� Ĭ�ϲ������1
local g_DWCHAICHU_Diaowen = {}

--=========================================================
-- ע�ᴰ�ڹ��ĵ������¼�
--=========================================================
function DWChaichu_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("UPDATE_DWCHAICHU")
	this:RegisterEvent("OBJECT_CARED_EVENT")
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")
	this:RegisterEvent("RESUME_ENCHASE_GEM")
	this:RegisterEvent("UNIT_MONEY")
	this:RegisterEvent("MONEYJZ_CHANGE")
	this:RegisterEvent("BUY_ITEM_DW_CHAICHU")
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

--=========================================================
-- �����ʼ��
--=========================================================
function DWChaichu_OnLoad()
	g_DWCHAICHU_Diaowen[1] = DWChaichu_Gem1
	-- g_DWCHAICHU_Diaowen[2] = DWChaichu_Gem2
	g_DWCHAICHU_Item[1] = -1
	g_DWCHAICHU_Item[2] = -1
	g_DWCHAICHU_Object[1] = DWChaichu_Object
	g_DWCHAICHU_Object[2] = DWChaichu_Object2
	DWChaichu_Gem1:SetActionItem(-1)
	-- DWChaichu_Gem2:SetActionItem(-1)
	
	g_DWChaichu_Frame_UnifiedPosition=DWChaichu_Frame:GetProperty("UnifiedPosition");
	    
end

--=========================================================
-- �¼�����
--=========================================================
function DWChaichu_OnEvent(event)
	if (event == "UI_COMMAND" and tonumber(arg0) == 4000156) then
		local xx = Get_XParam_INT(0)
		g_CaredNpc = DataPool:GetNPCIDByServerID(xx)
		if g_CaredNpc == -1 then
			PushDebugMessage("server�����������������⡣")
			return
		end
		BeginCareObject_DWChaichu()
		DWChaichu_Clear()
		DWChaichu_UpdateBasic()
		this:Show()
	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if (tonumber(arg0) ~= g_CaredNpc) then
			return
		end
		if ((arg1 == "distance" and tonumber(arg2) > MAX_OBJ_DISTANCE) or arg1=="destroy") then
			DWChaichu_Close()
		end
	elseif (event == "PACKAGE_ITEM_CHANGED" and this:IsVisible()) then
		if (arg0 == nil or -1 == tonumber(arg0)) then
			return
		end
		for i = 1, 2 do
			if g_DWCHAICHU_Item[i] == tonumber(arg0) then
				DWChaichu_Resume_Equip(i + g_DWCHAICHU_GRID_SKIP)
				DWChaichu_UpdateBasic()
				break
			end
		end
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 201401111 and this:IsVisible()) then
		DWChaichu_UpdateBasic()
		if arg1 ~= nil then
			DWChaichu_Update(0, arg1)
			DWChaichu_UpdateBasic()
		end
	elseif (event == "UNIT_MONEY" or event =="MONEYJZ_CHANGE") then
		DWChaichu_UpdateBasic()
	elseif (event == "RESUME_ENCHASE_GEM" and this:IsVisible()) then
		if arg0 ~= nil then
			DWChaichu_Resume_Equip(tonumber(arg0))
			DWChaichu_UpdateBasic()
		end
	elseif (event == "BUY_ITEM_DW_CHAICHU" and this:IsVisible()) then
		local item = tonumber(arg0)
		if 30503150 ~= item then 
			return 
		end
		DWChaichu_Update(2,Lua_GetBagPosByItemIndex(30503150))		
	elseif (event == "ADJEST_UI_POS" ) then
		DWChaichu_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		DWChaichu_Frame_On_ResetPos()
	end
end

--=========================================================
-- ���»�����ʾ��Ϣ
--=========================================================
function DWChaichu_UpdateBasic()
	DWChaichu_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY") + Player:GetData("MONEY_JZ"))
	-- DWChaichu_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"))

	-- ���������Ǯ
	if g_DWCHAICHU_Item[1] == -1 then
		g_DWCHAICHU_DemandMoney = 0
	else
		g_DWCHAICHU_DemandMoney = 50000
	end
	DWChaichu_DemandMoney:SetProperty("MoneyNumber", tostring(g_DWCHAICHU_DemandMoney))
end

--=========================================================
-- ���ý���
--=========================================================
function DWChaichu_Clear()
	for i = 1, 2 do
		if g_DWCHAICHU_Item[i] ~= -1 then
			g_DWCHAICHU_Object[i]:SetActionItem(-1)
			LifeAbility:Lock_Packet_Item(g_DWCHAICHU_Item[i], 0)
			g_DWCHAICHU_Item[i] = -1
		end
	end

	DWChaichu_UpdateBasic()
	DWChaichu_Gem1:SetActionItem(-1)
	-- DWChaichu_Gem2:SetActionItem(-1)
end

--=========================================================
-- ���½���
--=========================================================
function DWChaichu_Update(uiIndex, itemIndex)
	local u_index = tonumber(uiIndex)
	local i_index = tonumber(itemIndex)
	local itemId = PlayerPackage:GetItemTableIndex(i_index)
	if itemId == 30503150 or itemId == 30121002 then
		u_index = 2
	elseif itemId >= 10100000 and itemId <= 12100000 then
		u_index = 1
	else
		u_index = -1
	end
	local nEquipPoint = LifeAbility:Get_Equip_Point(i_index)
	local theAction = EnumAction(i_index, "packageitem")

	if theAction:GetID() ~= 0 then
		-- �ж��Ƿ�Ϊ��ȫʱ��
		if (tonumber(DataPool:GetLeftProtectTime()) > 0) then
			PushDebugMessage("#{JJTZ_090826_26}")
			return
		end

		if u_index == 1 then
			-- �ж���Ʒ�Ƿ�Ϊ�Ѿ�ʴ���˵��Ƶ�װ��, �������, ֱ��return
			-- ֱ����ǿ���Ǹ��ӿ�, ���ݷ���ֵ��ȷ��
			local Icon,IconEx,nLevel_1,nLevel_2,DWName_1,DWName_2 = "","","","","",""
			g_DWChaichu_EquipData = SuperTooltips:GetAuthorInfo()
			if LifeAbility : Get_Equip_Point(i_index) == 17 then
				_,Icon,IconEx,nLevel_1,nLevel_2,DWName_1,DWName_2,g_DWChaichu_EquipData = Lua_GetDWShowMsgEx()
			else
				_,Icon,IconEx,nLevel_1,nLevel_2,DWName_1,DWName_2 = Lua_GetDWShowMsg(g_DWChaichu_EquipData)
			end
			
			if Icon == "" and IconEx == "" then
				-- ����һ���Ѿ�ʴ���˵��Ƶ�װ��
				PushDebugMessage("#{ZBDW_091105_19}")
				return
			end
			g_DWCHAICHU_Clicked_Num = 0
			DWChaichu_Gem1:SetActionItem(-1)
			-- DWChaichu_Gem2:SetActionItem(-1)
		elseif u_index == 2 then
			-- �ж���Ʒ�Ƿ�Ϊ���Ʋ����, �������, ֱ��return
			if PlayerPackage:GetItemTableIndex(i_index) ~= 30503150 then
			    if PlayerPackage:GetItemTableIndex(i_index) ~= 30121002 then
					PushDebugMessage("#{ZBDW_091105_20}")
					return
				end
			end
		else
			-- �쳣���
			DWChaichu_Clear()
			return
		end
		
		-- �ж���Ʒ�Ƿ����(ִ�е�����֮ǰ, �Ѿ����ж���)
		if PlayerPackage:IsLock(i_index) == 1 then
			PushDebugMessage("#{ZBDW_091105_3}")
			return
		end

		-- ����ո����Ѿ��ж�Ӧ��Ʒ��, �滻֮
		if g_DWCHAICHU_Item[u_index] ~= -1 then
			LifeAbility:Lock_Packet_Item(g_DWCHAICHU_Item[u_index], 0)
		end
		g_DWCHAICHU_Object[u_index]:SetActionItem(theAction:GetID())
		LifeAbility:Lock_Packet_Item(i_index, 1)
		g_DWCHAICHU_Item[u_index] = i_index
		
		--װ������ʾ����
		if u_index == 1 then
			local dwId,dwIdEx = Lua_GetEquipDiaowenID(i_index,g_DWChaichu_EquipData)			
			if dwId > 0  then
				local theAction = GemMelting:UpdateProductAction(dwId)
				if theAction:GetID() ~= 0 then	
					DWChaichu_Gem1:SetActionItem(theAction:GetID());
				end			
			end					
			-- if dwIdEx > 0 then
				-- local theAction2 = GemMelting:UpdateProductAction(dwIdEx)
				-- if theAction2:GetID() ~= 0 then	
					-- DWChaichu_Gem2:SetActionItem(theAction2:GetID());
				-- end						
			-- end
			
			g_DWCHAICHU_Diaowen[1]:SetPushed(1)
			g_DWCHAICHU_Select = 1
		end
	else
		DWChaichu_Clear()
	end
end

--=========================================================
-- ȡ�������ڷ������Ʒ
--=========================================================
function DWChaichu_Resume_Equip(nIndex)
	if nIndex <= g_DWCHAICHU_GRID_SKIP or nIndex > g_DWCHAICHU_GRID_SKIP + 2 then
		return
	end

	nIndex = nIndex - g_DWCHAICHU_GRID_SKIP
	if this:IsVisible() then
		if g_DWCHAICHU_Item[nIndex] ~= -1 then
			g_DWCHAICHU_Object[nIndex]:SetActionItem(-1)
			LifeAbility:Lock_Packet_Item(g_DWCHAICHU_Item[nIndex], 0)
			g_DWCHAICHU_Item[nIndex] = -1
			if nIndex == 1 then
				DWChaichu_Gem1:SetActionItem(-1)
				DWChaichu_Gem2:SetActionItem(-1)
			end
		end
	end
	DWChaichu_Check_AllItem()
end

--=========================================================
-- �ж��Ƿ�������Ʒ���ѷź�
-- ֻ�ڵ�� OK ��ť��ʱ������������
--=========================================================
function DWChaichu_Check_AllItem()
	DWChaichu_UpdateBasic()

	for i = 1, 2 do
		if g_DWCHAICHU_Item[i] == -1 then
			return i
		end
	end

	local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")
	if selfMoney < g_DWCHAICHU_DemandMoney then
		return 44
	end

	return 0
end

--=========================================================
-- ȷ��ִ�й���
--=========================================================
function DWChaichu_OK_Clicked()
	local ret = DWChaichu_Check_AllItem()
	if ret == 1 then
		PushDebugMessage("#{ZBDW_091105_12}")
		return
	elseif ret == 2 then
		DWChaichu_YuanbaoPay()
		return
	elseif ret == 44 then
		PushDebugMessage("#{GMGameInterface_Script_PlayerMySelf_Info_Money_Not_Enough}")
	end

	if ret == 0 then
		-- ִ�е��Ʋ������
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name(g_DWCHAICHU_RScript_Name)
			Set_XSCRIPT_ScriptID(g_DWCHAICHU_RScript_ID)
			Set_XSCRIPT_Parameter(0, g_DWCHAICHU_Action_Type)
			for i = 1, 2 do
				Set_XSCRIPT_Parameter(i, g_DWCHAICHU_Item[i])
			end
			Set_XSCRIPT_Parameter(3, g_DWCHAICHU_Select)
			Set_XSCRIPT_ParamCount(4)
		Send_XSCRIPT()
		DWChaichu_Clear()
		g_DWCHAICHU_Clicked_Num = 0
	end
end
--=========================================================
-- Ԫ�������۽��
--=========================================================
function DWChaichu_YuanbaoPay()

	if DWChaichu_Blank_Queren:GetCheck() == 0 then
		--����ʾ �Զ�����
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name(g_DWCHAICHU_RScript_Name)
			Set_XSCRIPT_ScriptID(g_DWCHAICHU_RScript_ID)
			Set_XSCRIPT_Parameter(0,101)
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
	elseif DWChaichu_Blank_Queren:GetCheck() == 1 then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name(g_DWCHAICHU_RScript_Name)
			Set_XSCRIPT_ScriptID(g_DWCHAICHU_RScript_ID)
			Set_XSCRIPT_Parameter(0,102)
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
	end
end
function DWChaichu_Blank_Queren_Clicked()
	if(g_ChaichuDirectly == 0)then
		DWChaichu_Blank_Queren:SetCheck(0);
		g_ChaichuDirectly = 1
	else
		DWChaichu_Blank_Queren:SetCheck(1);
		g_ChaichuDirectly = 0
	end
end
--=========================================================
-- �رս���
--=========================================================
function DWChaichu_Close()
	this:Hide()
	return
end

--=========================================================
-- ��������
--=========================================================
function DWChaichu_OnHiden()
	StopCareObject_DWChaichu()
	DWChaichu_Clear()
	return
end

--=========================================================
-- ��ʼ����NPC��
-- �ڿ�ʼ����֮ǰ��Ҫ��ȷ����������ǲ����Ѿ��С����ġ���NPC��
-- ����еĻ�����ȡ���Ѿ��еġ����ġ�
--=========================================================
function BeginCareObject_DWChaichu()

	this:CareObject(g_CaredNpc, 1, "DWChaichu")
	return
end

--=========================================================
-- ֹͣ��ĳNPC�Ĺ���
--=========================================================
function StopCareObject_DWChaichu()
	this:CareObject(g_CaredNpc, 0, "DWChaichu")
	g_CaredNpc = -1
	g_DWCHAICHU_Clicked_Num = 0
	return
end

--=========================================================
-- ��ҽ�Ǯ�仯
--=========================================================
function DWChaichu_UserMoneyChanged()
	local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")
	if selfMoney < g_DWCHAICHU_DemandMoney then
		return -1
	end
	return 1
end


function DWChaichu_Frame_On_ResetPos()
	DWChaichu_Frame:SetProperty("UnifiedPosition", g_DWChaichu_Frame_UnifiedPosition);
end

--ѡ�����ڼ�������
function DWChaichu_Select(pos)
	if g_DWCHAICHU_Item[1] ~= -1 then
		local i_index = g_DWCHAICHU_Item[1]
		local _,Icon,IconEx,nLevel_1,nLevel_2,DWName_1,DWName_2 = Lua_GetDWShowMsg(g_DWChaichu_EquipData)
		if IconEx ~= "" and Icon ~= "" then
			g_DWCHAICHU_Select=pos
			g_DWCHAICHU_Diaowen[1]:SetPushed(0)
			-- g_DWCHAICHU_Diaowen[2]:SetPushed(0)
			g_DWCHAICHU_Diaowen[pos]:SetPushed(1)
		elseif Icon ~= "" then
			g_DWCHAICHU_Select=1
			g_DWCHAICHU_Diaowen[1]:SetPushed(1)
			-- g_DWCHAICHU_Diaowen[2]:SetPushed(0)						
		end
	end

end