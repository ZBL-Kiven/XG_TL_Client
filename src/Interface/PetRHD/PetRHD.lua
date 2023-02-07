-- PetRHD.lua
-- ���������ں϶�
-- 2019-9-11 18:32:20 ��ң��
local mainPet = { idx = -1, guid = { high = -1, low = -1 } }
local assisPet = { idx = -1, guid = { high = -1, low =-1 } }

-- ���� NPC
local theNPC = -1
local MAX_OBJ_DISTANCE = 3.0
local g_YuanbaoBuyState = 0

local g_RHD_YBConfirm = 1 --add:lby2015

local currentChoose = -1

-- ���������޵ĵ�ǰ�ں϶�
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

-- �ں϶ȶ�ӦԪ��
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

--4> HenryFour: �ںϵ�IDȷ���������Ҫ�ı�
local g_Item_RongHeDan = 30503182
local g_Item_RongHeDan_Bind = 30503189

local g_PetRHD_Frame_UnifiedPosition

function PetRHD_PreLoad()
	this : RegisterEvent("UI_COMMAND")
	this : RegisterEvent("REPLY_MISSION_PET")			-- ��Ҵ��б�ѡ��һֻ����
	this : RegisterEvent("UPDATE_PET_PAGE")				-- ������ϵ��������ݷ����仯
	this : RegisterEvent("DELETE_PET")					-- ������ϼ���һֻ����
	this : RegisterEvent("OBJECT_CARED_EVENT")			-- ���� NPC �Ĵ��ںͷ�Χ
	this : RegisterEvent("UNIT_MONEY")
	this : RegisterEvent("MONEYJZ_CHANGE")				--�����ռ� Vega
	this : RegisterEvent("OPEN_EXCHANGE_FRAME")			--�򿪽��׽���
	this : RegisterEvent("ADJEST_UI_POS")
	this : RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this : RegisterEvent("QUICKUP_PET_SENDMSG")				--����ȷ��
end

function PetRHD_OnLoad()
	PetRHD_Clear()
	g_PetRHD_Frame_UnifiedPosition = PetRHD_Frame:GetProperty("UnifiedPosition")
	-- PetRHD_Yuanbao_Bind:SetCheck(g_RHD_YBConfirm)
	PetRHD_Jian:Hide();
end

function PetRHD_OnEvent(event)
	if event == "UI_COMMAND" and tonumber(arg0) == 1001095 then		-- �򿪽���
		if this : IsVisible() then									-- ������濪�ţ��򲻴���
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

	-- ���ѡ��һֻ����
	if event == "UI_COMMAND" and arg0 == "201812271" and this : IsVisible() then
		PetRHD_SelectPet(tonumber(arg1))
		PetRHD_SelfMoney_Text:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
		PetRHD_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
		return
	end

	-- ������ϵ��������ݷ����仯���������޳�ս����Ϣ������һֻ����
	if event == "UPDATE_PET_PAGE" and this : IsVisible() then
		PetRHD_UpdateSelected()
		PetRHD_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
		PetRHD_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
		return
	end

	-- ������ϼ���һֻ����
	if event == "DELETE_PET" and this : IsVisible() then
		PetRHD_UpdateSelected()
		PetRHD_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
		PetRHD_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
		return
	end

	-- ���� NPC �Ĵ��ںͷ�Χ
	if event == "OBJECT_CARED_EVENT" and this : IsVisible() then
		Pet : ShowPetList(0)
		if tonumber(arg0) ~= theNPC then
			return
		end

		--�����NPC�ľ������һ��������߱�ɾ�����Զ��ر�
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
	
	-- �򿪽��׽����ͬʱ�رոý��棬������Ҫˢ��һ�������б�
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

-- ѡ������
function PetRHD_SelectPet(petIdx)
	if -1 == petIdx then
		return
	end

	--�����ѱ���������ѡ��	
	local petName = Pet : GetPetList_Appoint(petIdx)
	local guidH, guidL = Pet : GetGUID(petIdx)

	-- ���ԭ���Ѿ�ѡ����һ���������ĳ�, �����ԭ��������
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
		-- ������������ı�����
		PetRHD_Pet : SetText(petName)
		-- ���������������������Ѿ��ύ��17�Ž�������
		-- ������Ŷ�Ӧ Client �����е� PET_LOCATION_TYPE
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

	-- ��¼�ó��λ�úš�GUID
	mainPet.idx = petIdx
	mainPet.guid.high = guidH
	mainPet.guid.low = guidL
	
	--���½�Ǯ�ͼ�����ʾ
	PetRHD_CalcSuccOdds()
	PetRHD_CalcCost()
	
--	PetRHD_Jian:Show()
end


function PetRHD_OK_Clicked()
	-- �ж��Ƿ�Ϊ��ȫʱ��2012.6.12-LIUBO
	if (tonumber(DataPool:GetLeftProtectTime()) > 0) then
		PushDebugMessage("#{ZYXT_120528_16}")
		return
	end
	
	-- �����ж�����Ƿ������Ҫ���������ޣ����û�з���NPC���ᵯ���Ի������أ�
	if mainPet.idx == -1 then
		-- �������Ҫ�����ں϶ȵ����ޡ�
		PushDebugMessage("�������Ҫ�����ں϶ȵ����ޡ�")
		return
	end

	-- �ж���ҵĽ�Ǯ�Ƿ��㹻������������ᵯ���Ի���
	local nFitValue = LuaFn_GetPetRHD(mainPet.idx)
	local cost = moneyCosts[nFitValue]
	if not cost then
		cost = 0
	end	

	-- ���Ľ�Ǯ���㣬��ȷ��
	local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")
	if selfMoney < cost then
		PushDebugMessage("#{ZSHT_100809_13}")
		return
	end
	
	--�ں϶��Ѿ�����
	local nFitValue = LuaFn_GetPetRHD(mainPet.idx)
	if nFitValue > 9 then
		PushDebugMessage("#{ZSKJT_130428_16}")
		return 0
	end
	
	--��鱳�����Ƿ��������ںϵ�
	local bExist = IsItemExist(g_Item_RongHeDan)
	
	if bExist <= 0 then
		bExist = IsItemExist(g_Item_RongHeDan_Bind)
		if bExist <= 0 then
		PushDebugMessage("#{ZSHT_100809_12}")
		return
		end
	end
	
	-- ���� UI_Command ʵ��
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
	    PushDebugMessage("�ù����ݲ�����")
	    return
	end
	--����15���ж�
	local mylevel = Player:GetData("LEVEL");
	if mylevel < 15 then
		PushDebugMessage("#{ZSKJT_130717_01}")
		return 0
	end
	-- �ж��Ƿ�Ϊ��ȫʱ��2012.6.12-LIUBO
	if (tonumber(DataPool:GetLeftProtectTime()) > 0) then
		PushDebugMessage("#{ZYXT_120528_16}")
		return 0
	end
	
	-- �����ж�����Ƿ������Ҫ���������ޣ����û�з���NPC���ᵯ���Ի������أ�
	if mainPet.idx == -1 then
		-- �������Ҫ�����ں϶ȵ����ޡ�
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
		-- ���� UI_Command ʵ��
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
		--����ȷ�Ͽ�
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

-- �رա�ȡ��
function PetRHD_Cancel_Clicked()

	--�رն���ȷ�Ͻ���
	PushEvent("UI_COMMAND",1000000115);
	
	PetRHD_Clear()
	this : Hide()
end

function PetRHD_Choose_Clicked(type)
	-- ��һ���ٿ����������
	Pet : ShowPetList(0)
	Pet : ShowPetList(1)
end

function PetRHD_Close()
	Pet : ShowPetList(0)
	StopCareObject()
	PetRHD_Clear()
	
	--�رն���ȷ�Ͻ���
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

-- ����ɹ���
function PetRHD_CalcSuccOdds()
	if mainPet.idx == -1 then
		PetRHD_Text2 : SetText("")
		PetRHD_OK : Disable()
		--PetRHD_Quick_Up : Disable()
		--PetRHD_Quick_Up : SetText( "#{ZSKJT_130507_1}" )
		--PetRHD_Quick_Up_Animate:Play(false)
		return
	end

	-- ���������޵ĵ�ǰ�ں϶�
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
		str = "�޷�����"
		PetRHD_OK : Disable()
		--PetRHD_Quick_Up : Disable()
		--PetRHD_Quick_Up : SetText( "#{ZSKJT_130507_1}" )
		--PetRHD_Quick_Up_Animate:Play(false)
	else
		str = str .. "��ǰ�ں϶�: " .. nFitValue .. "    " .. "�ɹ���: " .. math.floor(odds / 10) .. "%"
		PetRHD_OK : Enable()
		--PetRHD_Quick_Up : Enable()
		--PetRHD_Quick_Up : SetText( "#{ZSKJT_130428_1}" )
		--PetRHD_Quick_Up_Animate:Play(true)
	end

	PetRHD_Text2 : SetText(str)
end

-- �����Ǯ����
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
	-- �жϱ�ѡ�е������Ƿ��ڱ�����
	if mainPet.idx ~= -1 then
		local newIdx = Pet : GetPetIndexByGUID(mainPet.guid.high, mainPet.guid.low)
		Pet : SetPetLocation(mainPet.idx, -1)
		-- ���������ɾ��
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
		-- �����ж����޵�λ���Ƿ����仯
		elseif newIdx ~= mainPet.idx then
			-- ��������仯���λ�ý��и���
			mainPet.idx = newIdx
		end
	end

	PetRHD_SelectPet(mainPet.idx)
end

--=========================================================
--��ʼ����NPC��
--�ڿ�ʼ����֮ǰ��Ҫ��ȷ����������ǲ����Ѿ��С����ġ���NPC��
--����еĻ�����ȡ���Ѿ��еġ����ġ�
--=========================================================
function BeginCareObject(objCaredId)
	theNPC = DataPool : GetNPCIDByServerID(objCaredId)
	if theNPC == -1 then
		PushDebugMessage("δ���� NPC")
		this : Hide()
		return
	end

	this : CareObject(theNPC, 1, "PetRHD")
end

--=========================================================
--ֹͣ��ĳNPC�Ĺ���
--=========================================================
function StopCareObject()
	this : CareObject(theNPC, 0, "PetRHD")
	Pet : ShowPetList(0)
	theNPC = -1
end


function PetRHD_Frame_On_ResetPos()
  PetRHD_Frame:SetProperty("UnifiedPosition", g_PetRHD_Frame_UnifiedPosition)
end


function PetRHD_YBPay_Clicked() --add:lby2015����Ԫ��ȷ�Ϲ���
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
			--����ʾ �Զ�����
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