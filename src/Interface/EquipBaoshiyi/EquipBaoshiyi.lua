--宝石乾坤移
--build 逍遥子 2019-9-2 09:37:10
local g_Object = -1;
local objCared = -1;
local g_EquipBaoshiyi_Frame_UnifiedPosition;
local GEMSOURCE_BUTTONS = {}
local GEMDEST_BUTTONS = {}
local EQUIPITEM_SOURCE = -1
local EQUIPITEM_DEST = -1
--local EQUIPITEM_QIANKUNFU = -1
local bConfirm = -1
-- 装备允许镶嵌的宝石类型表
local g_EquipGemTable = {}
local g_GemLevelTable = {}
local g_EquipScoreTable = {-1,-1,-1,-1}
local g_EquipDestTable = {-1,-1,-1,-1}
local g_bClick = -1;
--local g_needFu = -1;
function EquipBaoshiyi_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OBJECT_CARED_EVENT",false);
	this:RegisterEvent("UPDATE_BAOSHIYI")
	this:RegisterEvent("PACKAGE_ITEM_CHANGED_EX",false)
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("UNIT_MONEY",false)
	this:RegisterEvent("MONEYJZ_CHANGE",false)
	this:RegisterEvent("BAOSHIYI_CLEAR")
end

function EquipBaoshiyi_OnLoad()
	GEMSOURCE_BUTTONS[1] = EquipBaoshiyi_Special_Button
	GEMSOURCE_BUTTONS[2] = EquipBaoshiyi_Special_Button1
	GEMSOURCE_BUTTONS[3] = EquipBaoshiyi_Special_Button2
	GEMSOURCE_BUTTONS[4] = EquipBaoshiyi_Special_Button3
	GEMSOURCE_BUTTONS[5] = EquipBaoshiyi_Special_Button4
	EQUIPITEM_SOURCE = -1;
	EQUIPITEM_DEST = -1;


	GEMDEST_BUTTONS[1] = EquipBaoshiyi_Special_Button5
	GEMDEST_BUTTONS[2] = EquipBaoshiyi_Special_Button6
	GEMDEST_BUTTONS[3] = EquipBaoshiyi_Special_Button7
	GEMDEST_BUTTONS[4] = EquipBaoshiyi_Special_Button8
	GEMDEST_BUTTONS[5] = EquipBaoshiyi_Special_Button9
	--QIANKUNFU_BUTTON = EquipBaoshiyi_Special_ButtonM
	g_EquipBaoshiyi_Frame_UnifiedPosition = EquipBaoshiyi_Frame:GetProperty("UnifiedPosition");
	--EquipBaoshiyi_huifu : Disable()
	EquipBaoshiyi_zhuanyi : Enable()
	EquipBaoshiyi_zhuanyi : SetText("#{BSQKY_20110506_05}")
	g_EquipGemTable[0] = { 1, 2, 3, 4, 6, 7, 8, 9, 21, 26 }
	g_EquipGemTable[1] = { 11, 12, 13, 14, 16, 17, 18, 19 }
	g_EquipGemTable[3] = { 11, 12, 13, 14, 16, 17, 18, 19 }
	g_EquipGemTable[4] = { 11, 12, 13, 14, 16, 17, 18, 19 }
	g_EquipGemTable[5] = { 11, 12, 13, 14, 16, 17, 18, 19 }
	g_EquipGemTable[6] = { 1, 2, 3, 4, 6, 7, 8, 9, 21, 26 }
	g_EquipGemTable[7] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 26 }
	g_EquipGemTable[11] = { 1, 2, 3, 4, 6, 7, 8, 9, 21, 26 }
	g_EquipGemTable[12] = { 1, 2, 3, 4, 6, 7, 8, 9, 21, 26 }
	g_EquipGemTable[13] = { 1, 2, 3, 4, 6, 7, 8, 9, 21, 26 }
	g_EquipGemTable[14] = { 1, 2, 3, 4, 6, 7, 8, 9, 21, 26 }
	g_EquipGemTable[15] = { 11, 12, 13, 14, 16, 17, 18, 19 }
	g_EquipGemTable[16] = { 11, 12, 13, 14, 16, 17, 18, 19 }
	g_EquipGemTable[17] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 26 }
	g_EquipGemTable[18] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 26 }
	g_EquipGemTable[19] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 26 }
	g_EquipGemTable[20] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 }
	g_EquipGemTable[21] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 26 }
	g_GemLevelTable[1] = 2
	g_GemLevelTable[2] = 3
	g_GemLevelTable[3] = 6
	g_GemLevelTable[4] = 8
	g_GemLevelTable[5] = 24
	g_GemLevelTable[6] = 29
	g_GemLevelTable[7] = 34
	g_GemLevelTable[8] = 39
	g_GemLevelTable[9] = 44
	--EQUIPITEM_QIANKUNFU = 30900104
end


function EquipBaoshiyi_OnEvent(event)
	if (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			--取消关心
			EquipBaoshiyi_Cancel_Clicked()
		end
	elseif ( event == "UI_COMMAND" and tonumber(arg0)== 20110509 ) then
		EquipBaoshiyi_Close();
		this:Show();
		EquipBaoshiyi_OnShown();
		objCared = -1;
		local xx = Get_XParam_INT(0);
		objCared = DataPool : GetNPCIDByServerID(xx);
		if objCared == -1 then
			return;
		end
		BeginCareObject_EquipBaoshiyi(objCared)
		return
	elseif ( event == "UI_COMMAND" and arg0 == "201107281" and this:IsVisible() ) then
		EquipBaoshiyi_Update(0, tonumber(arg1));
	elseif ( event == "UI_COMMAND" and arg0 == "1000000108" and this:IsVisible() ) then
		g_EquipDestTable = {-1,-1,-1,-1}
		for i = 1,4 do
			local nGemIndex = Get_XParam_INT(i - 1);
			if nGemIndex ~= 0 then
				g_EquipDestTable[i] = nGemIndex;
			end
		end
		EquipBaoshiyi_UpdateButton()
	elseif ( event == "UI_COMMAND" and arg0 == "1000000109" and this:IsVisible() ) then
		g_EquipScoreTable = {-1,-1,-1,-1}
		for i = 1,4 do
			local nGemIndex = Get_XParam_INT(i - 1);
			if nGemIndex ~= 0 then
				g_EquipScoreTable[i] = nGemIndex;
			end
		end
		EquipBaoshiyi_UpdateButton()	
	elseif (event == "UNIT_MONEY" and this:IsVisible()) then
		EquipBaoshiyi_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
	elseif (event == "MONEYJZ_CHANGE" and this:IsVisible()) then
		EquipBaoshiyi_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ"))); --zchw
	elseif (event == "ADJEST_UI_POS" ) then
		EquipBaoshiyi_Frame_On_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		EquipBaoshiyi_Frame_On_ResetPos()
	elseif (event == "BAOSHIYI_CLEAR") then
		EquipBaoshiyi_Clear();
	end

end

function EquipBaoshiyi_OnShown()
	EquipBaoshiyi_Clear();
	EquipBaoshiyi_zhuanyi : Enable()
	EquipBaoshiyi_zhuanyi : SetText("#{BSQKY_20110506_05}")
	g_bClick = 0
	EquipBaoshiyi_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
	EquipBaoshiyi_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ"))); --zchw
end

function EquipBaoshiyi_Clear()
	EquipBaoshiyi_NeedMoney:SetProperty("MoneyNumber", tostring(0));
	EquipBaoshiyi_zhuanyi : SetText("#{BSQKY_20110506_05}")
	--g_needFu = -1
	if (EQUIPITEM_SOURCE ~= -1) then
		GEMSOURCE_BUTTONS[1]:SetActionItem(-1);
		LifeAbility : Lock_Packet_Item(EQUIPITEM_SOURCE,0);
		EQUIPITEM_SOURCE = -1
	end
	for i=2,5 do 
		GEMSOURCE_BUTTONS[i]:SetActionItem(-1);
	end
	if (EQUIPITEM_DEST ~= -1) then
		GEMDEST_BUTTONS[1]:SetActionItem(-1);
		LifeAbility : Lock_Packet_Item(EQUIPITEM_DEST,0);
		EQUIPITEM_DEST = -1
	end
	for i=2,5 do 
		GEMDEST_BUTTONS[i]:SetActionItem(-1);
	end
	bConfirm = -1
end

function EquipBaoshiyi_Update(UI_index, Item_index)
	local i_index = tonumber(Item_index)
	local ui_index = tonumber(UI_index)
	if ui_index < 0 or ui_index > 2 then
		return
	end
	local theAction = EnumAction(i_index, "packageitem");
	
	EquipBaoshiyi_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
	EquipBaoshiyi_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
	local uiPos = -1;
	local gem_count = 0
	if ui_index ~= 3 then
		gem_count = LifeAbility : GetEquip_GemCount(i_index);
		if gem_count > 4 or gem_count == -1 then
			return
		end
		bConfirm = -1
		g_bClick = 0
		EquipBaoshiyi_zhuanyi : SetText("#{BSQKY_20110506_05}")
		--时装不能操作
		local equippoint = LifeAbility : Get_Equip_Point(i_index);
		if (not g_EquipGemTable[equippoint]) or (equippoint == 2) then
			PushDebugMessage("#{BSQKY_20110506_30}")
			return
		end
	end
	if theAction:GetID() ~= 0 then
		if ui_index == 0 then
			if EQUIPITEM_SOURCE == -1 then
				if gem_count < 1 then
					PushDebugMessage("#{BSQKY_20110506_13}")
					return
				end
				GEMSOURCE_BUTTONS[1]:SetActionItem(theAction:GetID());
				LifeAbility : Lock_Packet_Item(i_index,1);
				EQUIPITEM_SOURCE = i_index;
				uiPos = 1;
				--return
			--end
			else
				if EQUIPITEM_DEST ~= -1 then
					LifeAbility : Lock_Packet_Item(EQUIPITEM_DEST,0);
				end
				GEMDEST_BUTTONS[1]:SetActionItem(theAction:GetID());
				LifeAbility : Lock_Packet_Item(i_index,1);
				EQUIPITEM_DEST = i_index;
				uiPos = 2;
			end
		elseif ui_index == 1 then
			if gem_count < 1 then
				PushDebugMessage("#{BSQKY_20110506_13}")
				return
			end
			if EQUIPITEM_SOURCE ~= -1 then
				LifeAbility : Lock_Packet_Item(EQUIPITEM_SOURCE,0);
			end
			GEMSOURCE_BUTTONS[1]:SetActionItem(theAction:GetID());
			LifeAbility : Lock_Packet_Item(i_index,1);
			EQUIPITEM_SOURCE = i_index;
			uiPos = 1;
		elseif ui_index == 2 then
			if EQUIPITEM_DEST ~= -1 then
				LifeAbility : Lock_Packet_Item(EQUIPITEM_DEST,0);
			end
			GEMDEST_BUTTONS[1]:SetActionItem(theAction:GetID());
			LifeAbility : Lock_Packet_Item(i_index,1);
			EQUIPITEM_DEST = i_index;
			uiPos = 2;
		end
		if uiPos == 1 then--和宝石摘除共用一套实现
			if not LifeAbility:SplitGem_Update(i_index) then
				for i=1,4 do
					GEMSOURCE_BUTTONS[i+1] : SetActionItem(-1)
					GEMSOURCE_BUTTONS[i+1] : Gloom();
				end
			else
				local ActionID,nItemID
				for i=1,4 do
					nItemID = LifeAbility : GetSplitGem_Gem (i-1);
					if nItemID ~= -1 then
						ActionID = DataPool:EnumPlayerMission_ItemAction(nItemID);
						GEMSOURCE_BUTTONS[i+1] : SetActionItem(ActionID);
						g_EquipScoreTable[i] = nItemID
						g_EquipDestTable[i] = nItemID
					else
						GEMSOURCE_BUTTONS[i+1] : SetActionItem(-1)
						GEMSOURCE_BUTTONS[i+1] : Gloom();
					end
				end
			end
			-- if EQUIPITEM_SOURCE ~= -1 then
				-- Clear_XSCRIPT();
					-- Set_XSCRIPT_Function_Name("XYJ_AskDisplaceGem");
					-- Set_XSCRIPT_ScriptID(900011);
					-- Set_XSCRIPT_Parameter(0,EQUIPITEM_SOURCE);
					-- Set_XSCRIPT_Parameter(1,0);
					-- Set_XSCRIPT_ParamCount(2);
				-- Send_XSCRIPT()
			-- end
		elseif uiPos == 2 then--这里用自己实现的一套
			-- if not LifeAbility:SplitGem_Update(i_index) then
				-- for i=1,4 do
					-- GEMDEST_BUTTONS[i+1] : SetActionItem(-1)
					-- GEMDEST_BUTTONS[i+1] : Gloom();
				-- end
			-- else
				-- local ActionID,nItemID
				-- for i=1,4 do
					-- nItemID = LifeAbility : GetSplitGem_Gem (i-1);
					-- if nItemID ~= -1 then
						-- ActionID = DataPool:EnumPlayerMission_ItemAction(nItemID);
						-- GEMDEST_BUTTONS[i+1] : SetActionItem(ActionID);
						-- GEMDEST_BUTTONS[i+1] : Bright();
					-- else
						-- GEMDEST_BUTTONS[i+1] : SetActionItem(-1)
						-- GEMDEST_BUTTONS[i+1] : Gloom();
					-- end
				-- end
			-- end
			-- if EQUIPITEM_DEST ~= -1 then
				-- Clear_XSCRIPT();
					-- Set_XSCRIPT_Function_Name("XYJ_AskDisplaceGem");
					-- Set_XSCRIPT_ScriptID(900011);
					-- Set_XSCRIPT_Parameter(0,EQUIPITEM_DEST);
					-- Set_XSCRIPT_Parameter(1,1);
					-- Set_XSCRIPT_ParamCount(2);
				-- Send_XSCRIPT()
			-- end
		end
		EquipBaoshiyi_NeedMoney:SetProperty("MoneyNumber", tostring(100000));
	end
end

function EquipBaoshiyi_Resume_Equip(nIndex)
	if nIndex < 1 or nIndex > 3 then
		return
	end
	EquipBaoshiyi_NeedMoney:SetProperty("MoneyNumber", tostring(0));
	if nIndex == 1 and (EQUIPITEM_SOURCE ~= -1) then
		GEMSOURCE_BUTTONS[1]:SetActionItem(-1);
		LifeAbility : Lock_Packet_Item(EQUIPITEM_SOURCE,0);
		EQUIPITEM_SOURCE = -1
		g_EquipScoreTable = {-1,-1,-1,-1}
		for i=2,5 do 
			GEMSOURCE_BUTTONS[i]:SetActionItem(-1);
		end
		if EQUIPITEM_DEST ~= -1 then
			EquipBaoshiyi_Update(2, EQUIPITEM_DEST)
		end
		g_bClick = 0
		EquipBaoshiyi_zhuanyi : SetText("#{BSQKY_20110506_05}")
	elseif nIndex == 2 and (EQUIPITEM_DEST ~= -1) then
		GEMDEST_BUTTONS[1]:SetActionItem(-1);
		LifeAbility : Lock_Packet_Item(EQUIPITEM_DEST,0);
		EQUIPITEM_DEST = -1
		g_EquipDestTable = {-1,-1,-1,-1}
		for i=2,5 do 
			GEMDEST_BUTTONS[i]:SetActionItem(-1);
		end
		if EQUIPITEM_SOURCE ~= -1 then
			EquipBaoshiyi_Update(1, EQUIPITEM_SOURCE)
		end
		g_bClick = 0
		EquipBaoshiyi_zhuanyi : SetText("#{BSQKY_20110506_05}")
	end
end

function EquipBaoshiyi_UpdateButton()
	local ActionID,nItemID
	for i=1,4 do
		GEMSOURCE_BUTTONS[i+1] : SetActionItem(-1)
		nItemID = g_EquipScoreTable[i]
		if nItemID ~= nil and nItemID ~= -1 then
			ActionID = GemMelting:UpdateProductAction(nItemID);
			if ActionID then
				GEMSOURCE_BUTTONS[i+1] : SetActionItem(ActionID:GetID());
			end
		else
			GEMSOURCE_BUTTONS[i+1] : SetActionItem(-1)
			GEMSOURCE_BUTTONS[i+1] : Gloom();
		end
	end
	for i=1,4 do
		GEMDEST_BUTTONS[i+1] : SetActionItem(-1)
		nItemID = g_EquipDestTable[i]
		if nItemID ~= nil and nItemID ~= -1 then
			ActionID = GemMelting:UpdateProductAction(nItemID);
			if ActionID then
				GEMDEST_BUTTONS[i+1] : SetActionItem(ActionID:GetID());
				GEMDEST_BUTTONS[i+1] : Bright();
			end
		else
			GEMDEST_BUTTONS[i+1] : SetActionItem(-1)
			GEMDEST_BUTTONS[i+1] : Gloom();
		end
	end
end
function EquipBaoshiyi_Check()
	if EQUIPITEM_SOURCE == -1 then
		PushDebugMessage("#{BSQKY_20110506_04}")
		return 0
	end
	if EQUIPITEM_DEST == -1 then
		PushDebugMessage("#{BSQKY_20110506_08}")
		return 0
	end

	local equippointSrc = LifeAbility : Get_Equip_Point(EQUIPITEM_SOURCE);
	if (not g_EquipGemTable[equippointSrc]) or (equippointSrc == 2) then
		PushDebugMessage("#{BSQKY_20110506_30}")
		return
	end
	local equippointDst = LifeAbility : Get_Equip_Point(EQUIPITEM_DEST);
	if (not g_EquipGemTable[equippointDst]) or (equippointDst == 2) then
		PushDebugMessage("#{BSQKY_20110506_30}")
		return
	end
	
	local gem_count = LifeAbility : GetEquip_GemCount(EQUIPITEM_SOURCE);
	if gem_count > 4 then
		return 0
	end
	--debug
	if 1 == 1 then
		return 1
	end
	--debug
	local hole_count = LifeAbility : GetEquip_HoleCount(EQUIPITEM_DEST);
	local gemdest_count = LifeAbility : GetEquip_GemCount(EQUIPITEM_DEST);
	
	local nItemIDSrc = -1
	local nItemIDDest = -1
	for i=1,4 do
		nItemIDSrc = LifeAbility : GetSplitGem_Gem (i-1);
		if (nItemIDSrc ~= -1) then
			if (i > hole_count) then
				PushDebugMessage("#{BSQKY_20110506_16}")
				return 0
			end
			if ( i < 4 ) then
				local cando = LifeAbility : Can_Enchase(EQUIPITEM_DEST, i - 1);--nItemIDSrc
				if cando == false then
					PushDebugMessage("#{BSQKY_20110506_18}")
					return 0
				end
				if passFlag == 0 then
					PushDebugMessage("#{BSQKY_20110506_18}")
					return 0
				end
			end
		end
	end
	if hole_count - gemdest_count < gem_count then--目标装备的剩余孔数不能小于源装备上的宝石数量
		PushDebugMessage("#{BSQKY_20110506_16}")
		return 0
	end
	return 1
end
function EquipBaoshiyi_Zhuanyi_Clicked()
	if g_bClick ~= 1 then
		if EquipBaoshiyi_Check() ~= 1 then
			return
		end
		for i = 1,4 do
			if g_EquipDestTable[i] == -1 and g_EquipScoreTable[i] ~= -1 then
				g_EquipDestTable[i] = g_EquipScoreTable[i]
			end
		end
		EquipBaoshiyi_UpdateButton()
		EquipBaoshiyi_zhuanyi : SetText("#{BSQKY_20110506_06}")
		g_bClick = 1
	else
		EquipBaoshiyi_zhuanyi : SetText("#{BSQKY_20110506_05}")
		EquipBaoshiyi_Update(1, EQUIPITEM_SOURCE)
		EquipBaoshiyi_Update(2, EQUIPITEM_DEST)
		g_bClick = 0
	end
end

function EquipBaoshiyi_Huifu_Clicked()
	if EQUIPITEM_SOURCE == -1 then
		EquipBaoshiyi_huifu : Disable()
		return
	end
	local gem_count = LifeAbility:GetEquip_GemCount(EQUIPITEM_SOURCE);
	if gem_count > 4 then
		EquipBaoshiyi_huifu : Disable()
		return
	end
	EquipBaoshiyi_Update(1, EQUIPITEM_SOURCE)
	EquipBaoshiyi_Update(2, EQUIPITEM_DEST)
	EquipBaoshiyi_huifu : Disable()
	EquipBaoshiyi_zhuanyi : Enable()
end

function EquipBaoshiyi_Buttons_Clicked()
	-- 判断是否为安全时间2012.6.12-LIUBO
	if (tonumber(DataPool:GetLeftProtectTime()) > 0) then
		PushDebugMessage("#{ZYXT_120528_16}")
		return
	end
	
	if EquipBaoshiyi_Check() ~= 1 then
		return
	end
	-- if bConfirm == -1 then
		-- PushEvent("UI_COMMAND",1000000107, 26,0)--弹出确认框
		-- bConfirm = 1
	-- elseif bConfirm == 1 then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("XYJ_Do_Displace");
			Set_XSCRIPT_ScriptID(900011);
			Set_XSCRIPT_Parameter(0,EQUIPITEM_SOURCE);
			Set_XSCRIPT_Parameter(1,EQUIPITEM_DEST);
			Set_XSCRIPT_Parameter(2,0);
			Set_XSCRIPT_ParamCount(3);
		Send_XSCRIPT()
		EquipBaoshiyi_Clear()
		-- bConfirm = -1
	-- end
end

function EquipBaoshiyi_Close()
	EquipBaoshiyi_Clear()
	PushEvent("DISPLACE_CLOSE_MSGBOX");
	this:Hide()
end

function EquipBaoshiyi_Cancel_Clicked()
	EquipBaoshiyi_Close();
	return;
end

function EquipBaoshiyi_OnHidden()
	StopCareObject_EquipBaoshiyi(objCared)
	EquipBaoshiyi_Close()
	return
end
--=========================================================
--开始关心NPC，
--在开始关心之前需要先确定这个界面是不是已经有“关心”的NPC，
--如果有的话，先取消已经有的“关心”
--=========================================================
function BeginCareObject_EquipBaoshiyi(objCaredId)
	g_Object = objCaredId;
	this:CareObject(g_Object, 1, "EquipBaoshiyi");
end

--=========================================================
--停止对某NPC的关心
--=========================================================
function StopCareObject_EquipBaoshiyi(objCaredId)
	this:CareObject(objCaredId, 0, "EquipBaoshiyi");
	g_Object = -1;

end

function EquipBaoshiyi_IsBind( ItemID )
	if(GetItemBindStatus(ItemID) == 1) then
		return 1;
	else
		return 0;
	end
end

function EquipBaoshiyi_Frame_On_ResetPos()
	EquipBaoshiyi_Frame:SetProperty("UnifiedPosition", g_EquipBaoshiyi_Frame_UnifiedPosition);
end

