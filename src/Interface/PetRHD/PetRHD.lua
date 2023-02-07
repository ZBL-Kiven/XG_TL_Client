-- PetRHD.lua
-- 提升珍兽融合度
-- 2019-9-11 18:32:20 逍遥子
local mainPet = { idx = -1, guid = { high = -1, low = -1 } }
local assisPet = { idx = -1, guid = { high = -1, low =-1 } }

-- 功能 NPC
local theNPC = -1
local MAX_OBJ_DISTANCE = 3.0
local g_YuanbaoBuyState = 0

local g_RHD_YBConfirm = 1 --add:lby2015

local currentChoose = -1

-- 索引是珍兽的当前融合度
local moneyCosts = {
	[0] = 100,
	[1] = 115,
	[2] = 132,
	[3] = 151,
	[4] = 173,
	[5] = 199,
	[6] = 228,
	[7] = 261,
	[8] = 300,
	[9] = 339,
}

-- 融合度对应元宝
local YuanBaoCosts = {
	[0] = 29260,
	[1] = 29200,
	[2] = 29100,
	[3] = 28920,
	[4] = 28380,
	[5] = 28140,
	[6] = 26960,
	[7] = 17160,
	[8] = 16620,
	[9] = 300,
}

--4> HenryFour: 融合丹ID确定后这儿需要改变
local g_Item_RongHeDan = 30503182
local g_Item_RongHeDan_Bind = 30503189

local g_PetRHD_Frame_UnifiedPosition

function PetRHD_PreLoad()
	this : RegisterEvent("UI_COMMAND")
	this : RegisterEvent("REPLY_MISSION_PET")			-- 玩家从列表选定一只珍兽
	this : RegisterEvent("UPDATE_PET_PAGE")				-- 玩家身上的珍兽数据发生变化
	this : RegisterEvent("DELETE_PET")					-- 玩家身上减少一只珍兽
	this : RegisterEvent("OBJECT_CARED_EVENT")			-- 关心 NPC 的存在和范围
	this : RegisterEvent("UNIT_MONEY")
	this : RegisterEvent("MONEYJZ_CHANGE")				--交子普及 Vega
	this : RegisterEvent("OPEN_EXCHANGE_FRAME")			--打开交易界面
	this : RegisterEvent("ADJEST_UI_POS")
	this : RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this : RegisterEvent("QUICKUP_PET_SENDMSG")				--二次确认
end

function PetRHD_OnLoad()
	PetRHD_Clear()
	g_PetRHD_Frame_UnifiedPosition = PetRHD_Frame:GetProperty("UnifiedPosition")
	-- PetRHD_Yuanbao_Bind:SetCheck(g_RHD_YBConfirm)
	PetRHD_Jian:Hide();
end

function PetRHD_OnEvent(event)
	if event == "UI_COMMAND" and tonumber(arg0) == 1001095 then		-- 打开界面
		if this : IsVisible() then									-- 如果界面开着，则不处理
			return
		end
		if(g_YuanbaoBuyState>=1)then
			-- PetRHD_Yuanbao_Bind:SetCheck(0);
		else
			-- PetRHD_Yuanbao_Bind:SetCheck(1);
		end	
		
		PetRHD_Text:SetText("#{ZSHT_XML_01}")
		this : Show()
		PetRHD_Pet : SetText("")
		PetRHD_Text2 : SetText("")
		PetRHD_NeedMoney:SetProperty("MoneyNumber", tostring(0))
		local npcObjId = Get_XParam_INT(0)
		BeginCareObject(npcObjId)
		PetRHD_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
		PetRHD_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
		PetRHD_OK:Disable()
		--PetRHD_Quick_Up : Disable()
		--PetRHD_Quick_Up : SetText( "#{ZSKJT_130507_1}" )
		--PetRHD_Quick_Up_Animate:Play(false)
		return
	end

	-- 玩家选了一只珍兽
	if event == "UI_COMMAND" and arg0 == "201812271" and this : IsVisible() then
		PetRHD_SelectPet(tonumber(arg1))
		PetRHD_SelfMoney_Text:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
		PetRHD_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
		return
	end

	-- 玩家身上的珍兽数据发生变化，包括珍兽出战、休息、增加一只珍兽
	if event == "UPDATE_PET_PAGE" and this : IsVisible() then
		PetRHD_UpdateSelected()
		PetRHD_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
		PetRHD_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
		return
	end

	-- 玩家身上减少一只珍兽
	if event == "DELETE_PET" and this : IsVisible() then
		PetRHD_UpdateSelected()
		PetRHD_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
		PetRHD_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
		return
	end

	-- 关心 NPC 的存在和范围
	if event == "OBJECT_CARED_EVENT" and this : IsVisible() then
		Pet : ShowPetList(0)
		if tonumber(arg0) ~= theNPC then
			return
		end

		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if arg1 == "distance" and tonumber(arg2) > MAX_OBJ_DISTANCE or arg1 == "destroy" then			
			PetRHD_Cancel_Clicked()
		end
		return
	end

	if (event == "UNIT_MONEY" and this:IsVisible()) then
		PetRHD_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
	end

	if (event == "MONEYJZ_CHANGE" and this:IsVisible()) then
		PetRHD_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
	end
	
	-- 打开交易界面的同时关闭该界面，但是需要刷新一下珍兽列表
	if (event == "OPEN_EXCHANGE_FRAME" and this:IsVisible()) then
		StopCareObject()
		PetRHD_Clear()
		Pet : ShowPetList(0)
		Pet : ShowPetList(1)
		this:Hide()
	end
	
	 if (event == "ADJEST_UI_POS" ) then
		PetRHD_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		PetRHD_Frame_On_ResetPos()
	end	
	
	if (event == "QUICKUP_PET_SENDMSG") and (tonumber(arg0) == 3) then
		PetRHD_Quick_ExeScript()
	end
end

-- 选择珍兽
function PetRHD_SelectPet(petIdx)
	if -1 == petIdx then
		return
	end

	--珍兽已被其它界面选中	
	local petName = Pet : GetPetList_Appoint(petIdx)
	local guidH, guidL = Pet : GetGUID(petIdx)

	-- 如果原来已经选择了一个被提升的宠, 则清空原来的数据
	PetRHD_RemoveMainPet()
	
	local nFitValue = LuaFn_GetPetRHD(petIdx)
	local nFitObj = 614
	if nFitValue ~= nil then
		if nFitValue <= 1 then
			nFitObj = 614
		elseif nFitValue > 1 and nFitValue <= 2 then
			nFitObj = 615
		elseif nFitValue > 2 and nFitValue <= 4 then
			nFitObj = 616
		elseif nFitValue > 5 and nFitValue <= 7 then
			nFitObj = 617
		elseif nFitValue > 7 and nFitValue <= 9 then
			nFitObj = 618
		end
	end
	if nFitValue <=9 then
		-- 将珍兽名字填到文本框中
		PetRHD_Pet : SetText(petName)
		-- 给珍兽上锁，设置珍兽已经提交到17号界面容器
		-- 容器编号对应 Client 代码中的 PET_LOCATION_TYPE
		Pet : SetPetLocation(petIdx, 17)		
		--Model
		PetRHD_FakeObject:SetFakeObject("")
		CachedTarget : SetHorseModel(nFitObj);
		PetRHD_FakeObject:SetFakeObject("Other_Horse")
	else
		PetRHD_Pet : SetText("")
		PetRHD_NeedMoney : SetProperty("MoneyNumber", 0)
		PetRHD_Text2 : SetText("#{ZSHT_XML_07}")
		--PushDebugMessage("#{ZSHT_XML_07}")
		PetRHD_OK:Disable()
		--PetRHD_Quick_Up : Disable()
		--PetRHD_Quick_Up : SetText( "#{ZSKJT_130507_1}" )
		--PetRHD_Quick_Up_Animate:Play(false)
		PetRHD_FakeObject:SetFakeObject("")
		return
	end

	-- 记录该宠的位置号、GUID
	mainPet.idx = petIdx
	mainPet.guid.high = guidH
	mainPet.guid.low = guidL
	
	--更新金钱和几率显示
	PetRHD_CalcSuccOdds()
	PetRHD_CalcCost()
	
--	PetRHD_Jian:Show()
end


function PetRHD_OK_Clicked()
	-- 判断是否为安全时间2012.6.12-LIUBO
	if (tonumber(DataPool:GetLeftProtectTime()) > 0) then
		PushDebugMessage("#{ZYXT_120528_16}")
		return
	end
	
	-- 首先判定玩家是否放入需要提升的珍兽，如果没有放入NPC将会弹出对话并返回：
	if mainPet.idx == -1 then
		-- 请放入您要提升融合度的珍兽。
		PushDebugMessage("请放入您要提升融合度的珍兽。")
		return
	end

	-- 判定玩家的金钱是否足够，如果不够将会弹出对话。
	local nFitValue = LuaFn_GetPetRHD(mainPet.idx)
	local cost = moneyCosts[nFitValue]
	if not cost then
		cost = 0
	end	

	-- 您的金钱不足，请确认
	local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")
	if selfMoney < cost then
		PushDebugMessage("#{ZSHT_100809_13}")
		return
	end
	
	--融合度已经满了
	local nFitValue = LuaFn_GetPetRHD(mainPet.idx)
	if nFitValue > 9 then
		PushDebugMessage("#{ZSKJT_130428_16}")
		return 0
	end
	
	--检查背包里是否有珍兽融合丹
	local bExist = IsItemExist(g_Item_RongHeDan)
	
	if bExist <= 0 then
		bExist = IsItemExist(g_Item_RongHeDan_Bind)
		if bExist <= 0 then
		PushDebugMessage("#{ZSHT_100809_12}")
		return
		end
	end
	
	-- 发送 UI_Command 实现
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("PetAddRHD")
		Set_XSCRIPT_ScriptID(900009)
		Set_XSCRIPT_Parameter(0, mainPet.guid.high)
		Set_XSCRIPT_Parameter(1, mainPet.guid.low)		
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()
end

function PetRHD_Quick_check()
		if 1 == 1 then
	    PushDebugMessage("该功能暂不开启")
	    return
	end
	--增加15级判断
	local mylevel = Player:GetData("LEVEL");
	if mylevel < 15 then
		PushDebugMessage("#{ZSKJT_130717_01}")
		return 0
	end
	-- 判断是否为安全时间2012.6.12-LIUBO
	if (tonumber(DataPool:GetLeftProtectTime()) > 0) then
		PushDebugMessage("#{ZYXT_120528_16}")
		return 0
	end
	
	-- 首先判定玩家是否放入需要提升的珍兽，如果没有放入NPC将会弹出对话并返回：
	if mainPet.idx == -1 then
		-- 请放入您要提升融合度的珍兽。
		PushDebugMessage("#{ZSKJT_130428_13}")
		return 0
	end
	
	local savvy = Pet : GetSavvy( mainPet.idx )
	local lingxing = Lua_GetLixing(nIndex);
	if 	savvy < 10 or lingxing < 10 then
		PushDebugMessage("#{ZSKJT_130428_15}")
		return 0
	end
	
	local nFitValue = LuaFn_GetPetRHD(mainPet.idx)
	if nFitValue > 9 then
		PushDebugMessage("#{ZSKJT_130428_16}")
		return 0
	end
	
	return 1
end

function PetRHD_Quick_ExeScript()
	if PetRHD_Quick_check() == 1 then 
		-- 发送 UI_Command 实现
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("QuickPetRHD")
			Set_XSCRIPT_ScriptID(800125)
			Set_XSCRIPT_Parameter(0, mainPet.guid.high)
			Set_XSCRIPT_Parameter(1, mainPet.guid.low)		
			Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT()
	end
end

function PetRHD_Quick_OK_Clicked()
	if PetRHD_Quick_check() == 1 then 
		local nFitValue = LuaFn_GetPetRHD(mainPet.idx)
		local petName = Pet : GetPetList_Appoint( mainPet.idx )
		local cost = YuanBaoCosts[nFitValue]
		--弹出确认框
		PushEvent("UI_COMMAND",1000000078, 3, tonumber(nFitValue), tonumber(cost),0, tostring(petName))
	end
end

function PetRHD_Jian_Clicked()
--	local nModeType = Pet:GetPetPossModel()
--	if nModeType == -1 then
--		nModeType = 1001
--	end
--	Pet:PetOpenPossJian(nModeType)
end

-- 关闭、取消
function PetRHD_Cancel_Clicked()

	--关闭二次确认界面
	PushEvent("UI_COMMAND",1000000115);
	
	PetRHD_Clear()
	this : Hide()
end

function PetRHD_Choose_Clicked(type)
	-- 关一下再开，清空数据
	Pet : ShowPetList(0)
	Pet : ShowPetList(1)
end

function PetRHD_Close()
	Pet : ShowPetList(0)
	StopCareObject()
	PetRHD_Clear()
	
	--关闭二次确认界面
	PushEvent("UI_COMMAND",1000000115);
end

function PetRHD_RemoveMainPet()
	if mainPet.idx ~= -1 then
		Pet : SetPetLocation(mainPet.idx, -1)
	end

	mainPet.idx = -1
	mainPet.guid.high = -1
	mainPet.guid.low = -1
end

function PetRHD_Clear()
	PetRHD_RemoveMainPet()
	PetRHD_Pet : SetText("")
	PetRHD_Text2 : SetText("")
	PetRHD_NeedMoney : SetProperty("MoneyNumber", tostring(0))

	PetRHD_OK : Disable()
	--PetRHD_Quick_Up : Disable()
	--PetRHD_Quick_Up : SetText( "#{ZSKJT_130507_1}" )
	--PetRHD_Quick_Up_Animate:Play(false)
	
	PetRHD_FakeObject:SetFakeObject("")

	currentChoose = -1
	
	PetRHD_Jian:Hide()
	if IsWindowShow("PetPossJian") then
--		Pet:PetOpenPossJian(-1)
	end
end

--model turn left
function PetRHD_Model_TurnLeft(start)
	--start
	if(start == 1 and CEArg:GetValue("MouseButton")=="LeftButton") then
		PetRHD_FakeObject:RotateBegin(-0.3);
	--stop
	else
		PetRHD_FakeObject:RotateEnd();
	end
end

--model turn right
function PetRHD_Model_TurnRight(start)
	--start
	if(start == 1 and CEArg:GetValue("MouseButton")=="LeftButton") then
		PetRHD_FakeObject:RotateBegin(0.3);
	--stop
	else
		PetRHD_FakeObject:RotateEnd();
	end
end

-- 计算成功率
function PetRHD_CalcSuccOdds()
	if mainPet.idx == -1 then
		PetRHD_Text2 : SetText("")
		PetRHD_OK : Disable()
		--PetRHD_Quick_Up : Disable()
		--PetRHD_Quick_Up : SetText( "#{ZSKJT_130507_1}" )
		--PetRHD_Quick_Up_Animate:Play(false)
		return
	end

	-- 索引是珍兽的当前融合度
	succOdds = {
		[0] = 900,
		[1] = 750,
		[2] = 600,
		[3] = 450,
		[4] = 300,
		[5] = 300,
		[6] = 300,
		[7] = 150,
		[8] = 100,
		[9] = 200,
	}

	local nFitValue = LuaFn_GetPetRHD(mainPet.idx)
	local str = "#cFFF263"
	local odds = succOdds[nFitValue]
	if not odds then
		str = "无法提升"
		PetRHD_OK : Disable()
		--PetRHD_Quick_Up : Disable()
		--PetRHD_Quick_Up : SetText( "#{ZSKJT_130507_1}" )
		--PetRHD_Quick_Up_Animate:Play(false)
	else
		str = str .. "当前融合度: " .. nFitValue .. "    " .. "成功率: " .. math.floor(odds / 10) .. "%"
		PetRHD_OK : Enable()
		--PetRHD_Quick_Up : Enable()
		--PetRHD_Quick_Up : SetText( "#{ZSKJT_130428_1}" )
		--PetRHD_Quick_Up_Animate:Play(true)
	end

	PetRHD_Text2 : SetText(str)
end

-- 计算金钱消耗
function PetRHD_CalcCost()
	if mainPet.idx == -1 then
		PetRHD_NeedMoney : SetProperty("MoneyNumber", tostring(0))
		return
	end

	local nFitValue = LuaFn_GetPetRHD(mainPet.idx)
	local cost = moneyCosts[nFitValue]
	if not cost then
		cost = 0
	end

	PetRHD_NeedMoney : SetProperty("MoneyNumber", tostring(cost))
end

function PetRHD_UpdateSelected()
	-- 判断被选中的珍兽是否还在背包里
	if mainPet.idx ~= -1 then
		local newIdx = Pet : GetPetIndexByGUID(mainPet.guid.high, mainPet.guid.low)
		Pet : SetPetLocation(mainPet.idx, -1)
		-- 如果不在则删掉
		if newIdx == -1 then
			mainPet.idx = -1
			mainPet.guid.high = -1
			mainPet.guid.low = -1
			PetRHD_Pet : SetText("")
			PetRHD_Text2 : SetText("")
			PetRHD_OK : Disable()
			--PetRHD_Quick_Up : Disable()
			--PetRHD_Quick_Up : SetText( "#{ZSKJT_130507_1}" )
			--PetRHD_Quick_Up_Animate:Play(false)
		-- 否则判断珍兽的位置是否发生变化
		elseif newIdx ~= mainPet.idx then
			-- 如果发生变化则对位置进行更新
			mainPet.idx = newIdx
		end
	end

	PetRHD_SelectPet(mainPet.idx)
end

--=========================================================
--开始关心NPC，
--在开始关心之前需要先确定这个界面是不是已经有“关心”的NPC，
--如果有的话，先取消已经有的“关心”
--=========================================================
function BeginCareObject(objCaredId)
	theNPC = DataPool : GetNPCIDByServerID(objCaredId)
	if theNPC == -1 then
		PushDebugMessage("未发现 NPC")
		this : Hide()
		return
	end

	this : CareObject(theNPC, 1, "PetRHD")
end

--=========================================================
--停止对某NPC的关心
--=========================================================
function StopCareObject()
	this : CareObject(theNPC, 0, "PetRHD")
	Pet : ShowPetList(0)
	theNPC = -1
end


function PetRHD_Frame_On_ResetPos()
  PetRHD_Frame:SetProperty("UnifiedPosition", g_PetRHD_Frame_UnifiedPosition)
end


function PetRHD_YBPay_Clicked() --add:lby2015增加元宝确认购买
	--if g_RHD_YBConfirm==1 then
	--	g_RHD_YBConfirm = 0
	--else
	--	g_RHD_YBConfirm = 1
	--end
	--PetRHD_Yuanbao_Bind:SetCheck(g_RHD_YBConfirm)
	
	local check  = g_YuanbaoBuyState;
	
		if(check>=1)then
			PetRHD_Yuanbao_Bind:SetCheck(1);
			g_YuanbaoBuyState = 0
		else
			PetRHD_Yuanbao_Bind:SetCheck(0);
			g_YuanbaoBuyState = 1
		end	
		
	--PetRHD_Yuanbao_Bind:SetCheck(g_RHD_YBConfirm)
end

--add:lby2015
function PetYuanbaoBuyRHDAsk()
	local _material = 30503182
	local check  = g_YuanbaoBuyState	
	if check == 1 then
			--不提示 自动购买
			Clear_XSCRIPT()
				Set_XSCRIPT_Function_Name("Pet2RHD_Yuanbao_Pay")
				Set_XSCRIPT_ScriptID(800125)
				Set_XSCRIPT_Parameter(0,_material)
				Set_XSCRIPT_Parameter(1,0)
				Set_XSCRIPT_ParamCount(2)
			Send_XSCRIPT()
			return 
		elseif check == 0 then
			Clear_XSCRIPT()
				Set_XSCRIPT_Function_Name("Pet2RHD_Yuanbao_Pay")
				Set_XSCRIPT_ScriptID(800125)
				Set_XSCRIPT_Parameter(0,_material)
				Set_XSCRIPT_Parameter(1,1)
				Set_XSCRIPT_ParamCount(2)
			Send_XSCRIPT()
			return
		else return end
end