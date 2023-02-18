--������������
--build 2019-8-7 15:07:38 ��ң��
local m_UI_NUM = 20090805	--������������
local m_PetIndex = -1
local m_ObjCared = -1
local g_Lingxing_YBConfirm = 1 --add:lby2015
--����1-10�Ľ�Ǯ����
local m_money = { 10000 , 12000 , 14400 ,17280 , 20736,  24883 , 29860 , 35832 ,42998 , 51598}
local m_YuanbaoBuyState = 0
-- ���Եȼ���ӦԪ��
local m_YuanBaoCosts = {
	[0] = 29880,
	[1] = 29760,
	[2] = 29560,
	[3] = 29220,
	[4] = 28620,
	[5] = 27600,
	[6] = 26040,
	[7] = 23560,
	[8] = 19340,
	[9] = 12960,
}

--���޸��ˣ�����˧��
--��TT��78725��
function PetLingXingUp_PreLoad()
	this : RegisterEvent( "UI_COMMAND" )
	this : RegisterEvent( "REPLY_MISSION_PET" )						-- ��Ҵ��б�ѡ��һֻ����
	--this : RegisterEvent( "UPDATE_PET_PAGE" )						-- ������ϵ��������ݷ����仯����������һֻ����
	this : RegisterEvent( "DELETE_PET" )							-- ������ϼ���һֻ����
	this : RegisterEvent("UNIT_MONEY");
	this : RegisterEvent("MONEYJZ_CHANGE")	
	this : RegisterEvent("QUICKUP_PET_SENDMSG")
end

function PetLingXingUp_OnLoad()

----PetLingXingUp_Yuanbao_Bind:SetCheck(g_Lingxing_YBConfirm) --add:lby2015

end

function PetLingXingUp_OnEvent(event)
	-- if event == "UI_COMMAND" then
		-- if IsWindowShow("PetHuanhua") then
			-- PetLingXingUp_FakeObject:SetFakeObject("");
			-- CloseWindow("PetHuanhua" ,true)
		-- end	
	-- end
	if event == "UI_COMMAND" and tonumber( arg0 ) == m_UI_NUM then
		if IsWindowShow("PetHuanhua") then
			PetLingXingUp_FakeObject:SetFakeObject("");
			CloseWindow("PetHuanhua" ,true)
		end
		if this : IsVisible() then
			return
		end
		
		local check  = m_YuanbaoBuyState--add:lby 2015
		if(check>=1)then
			--PetLingXingUp_Yuanbao_Bind:SetCheck(0);
		else
			--PetLingXingUp_Yuanbao_Bind:SetCheck(1);
		end	
		
		PetLingXingUp_CleanUp()
		PetLingXingUp_BeginCareObj( Get_XParam_INT(0) );
		this:Show()
		Pet : ShowPetList( 1 )
		PetLingXingUp_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
		PetLingXingUp_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
			
		--PetLingXingUp_Quick_Up : Disable()
		--PetLingXingUp_Quick_Up : SetText( "#{ZSKJT_130507_1}" )
		--PetLingXingUp_Quick_Up_Animate:Play(false)

	elseif (event == "UNIT_MONEY" and this : IsVisible()) then
		PetLingXingUp_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
		PetLingXingUp_UICheck()
	elseif (event == "MONEYJZ_CHANGE" and this : IsVisible() ) then
		PetLingXingUp_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
		PetLingXingUp_UICheck()
	elseif event == "UI_COMMAND" and arg0 == "201812271" and this : IsVisible() then
		PetLingXingUp_OnSelectPet( tonumber( arg1 ) )
	elseif event == "UPDATE_PET_PAGE"  and this:IsVisible() then
		PetLingXingUp_CleanUp()
	elseif event == "DELETE_PET"  and this:IsVisible() then
		this:Hide()
	end
	if (event == "UI_COMMAND") and arg0 == "1000000079" and (tonumber(arg1) == 2) then
		PetLingXingUp_Quick_ExeLXUp()
	end
	if event == "UI_COMMAND" and tonumber(arg0) == 201810283 and this:IsVisible() then
		PetLingXingUp_UICheck()
	end
end


--Close
function PetLingXingUp_Close_Window()

	--�رն���ȷ�Ͻ���
	PushEvent("CONVENIENT_BUY_CONFIRM_CLOSE");
	
	this:Hide();
end

--OK
function PetLingXingUp_OK_Clicked()

	-- �ж��Ƿ�Ϊ��ȫʱ��2012.6.12-LIUBO
	if (tonumber(DataPool:GetLeftProtectTime()) > 0) then
		PushDebugMessage("#{ZYXT_120528_16}")
		return
	end
	
	if m_PetIndex == -1  then
		return
	end
	
	local isExist = IsItemExist(20310116)
	if isExist == 0 then
		isExist = IsItemExist(20310160)
		if isExist == 0 then
			isExist = IsItemExist(20310175)
			if isExist == 0 then
				PushDebugMessage("#{RXZS_090804_15}")  --������ȱ�������������ϣ����޾��ǡ�
				-- �����Լ��ĺ���
				-- PetYuanbaoBuyLingxingAsk()
				return
			end
		end
	end
	local hid,lid = Pet:GetGUID(m_PetIndex);
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "Pet_LXUP" )
		Set_XSCRIPT_ScriptID( 800124 )
		Set_XSCRIPT_Parameter( 0, hid )
		Set_XSCRIPT_Parameter( 1, lid )
		Set_XSCRIPT_ParamCount( 2 )
	Send_XSCRIPT()
end

function PetLingXingUp_Quick_Check()
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
	
	if m_PetIndex == -1  then
		ShowSystemTipInfo( "#{ZSKJT_130428_9}" )
		return 0
	end
	
	-- �жϵ�ǰ���޵������Ƿ�С��10
--	local lingxing = Pet : GetLixing( m_PetIndex )
--	if lingxing >= 10 then 
--		ShowSystemTipInfo("#{RXZS_090804_14}")
--		return 0
--	end
	
	-- �ж��Ƿ�û�
	local nGen = LuaFn_GetPetLingXing(m_PetIndex,2)
	if nGen ~= nil and nGen == 999 then	--0-10Ϊ�û�����
		ShowSystemTipInfo("#{RXZS_090804_13}")    --��ѡ������޻�δ�û���ֻ�лû�������޲����������ԡ�
		return 0
	end
		
	return 1
end

function PetLingXingUp_Quick_OK_Clicked()
	if PetLingXingUp_Quick_Check() == 1 then 	
		local lingxing = LuaFn_GetPetLingXing(m_PetIndex,2)
		if lingxing == nil or lingxing == 999 then
			lingxing = 0
		end
		local petName = Pet : GetPetList_Appoint( m_PetIndex )
		local cost = m_YuanBaoCosts[lingxing]
		--����ȷ�Ͽ�
		PushEvent("UI_COMMAND",1000000078, 2, tonumber(lingxing), tonumber(cost),0, tostring(petName))
	end
end

function PetLingXingUp_Quick_ExeLXUp()
	if PetLingXingUp_Quick_Check() == 1 then 	
		local hid,lid = Pet:GetGUID(m_PetIndex);
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "Quick_Pet_LXUP" )
			Set_XSCRIPT_ScriptID( 800124 )
			Set_XSCRIPT_Parameter( 0, hid )
			Set_XSCRIPT_Parameter( 1, lid )
			Set_XSCRIPT_ParamCount( 2 )
		Send_XSCRIPT()
	end
end

--Select Pet
function PetLingXingUp_SelectPet_Clicked()
	Pet : ShowPetList( 0 )
	Pet : ShowPetList( 1 )			
	if  m_PetIndex ~= -1 then
		local lingxing = LuaFn_GetPetLingXing(m_PetIndex,2)
		if lingxing >= 10 and lingxing ~= 999 then	
			--PetLingXingUp_Quick_Up : Disable()
			--PetLingXingUp_Quick_Up : SetText( "#{ZSKJT_130507_1}" )
			--PetLingXingUp_Quick_Up_Animate:Play(false)
		end
	end
end




function PetLingXingUp_Pet_Modle_TurnLeft( start )
	--������ת��ʼ
	if(start == 1) then
		PetLingXingUp_FakeObject:RotateBegin(-0.3);
	--������ת����
	else
		PetLingXingUp_FakeObject:RotateEnd();
	end

end


function PetLingXingUp_Pet_Modle_TurnRight( start )
	--������ת��ʼ
	if(start == 1) then
		PetLingXingUp_FakeObject:RotateBegin(0.3);
	--������ת����
	else
		PetLingXingUp_FakeObject:RotateEnd();
	end
end


function PetLingXingUp_OnHidden()

	Pet:ShowPetList(0);
	PetLingXingUp_CleanUp()
	
	--�رն���ȷ�Ͻ���
	PushEvent("CONVENIENT_BUY_CONFIRM_CLOSE");
end


function PetLingXingUp_OnSelectPet(petIndex)
	
	if( -1 == petIndex ) then
		return;
	end
	
	--�����ѱ���������ѡ��
	-- if (Pet:GetPetLocation(petIndex) ~= -1) then
		-- return;
	-- end

	--δ�û�
--	local gen = Pet:GetType(petIndex)
--	if gen ~= nil and gen < 100 then	--100����Ϊ�û�����
--		PushDebugMessage("#{RXZS_090804_13}")    --��ѡ������޻�δ�û���ֻ�лû�������޲����������ԡ�
--		return
--	end
	--�ⶥ��
--	if gen ~= nil and gen >= 110 then
--		PushDebugMessage("#{RXZS_090804_14}")    --��ѡ����������Եȼ��Ѿ��ﵽ��ߣ������ٴ��������ԡ�
--		return
--	end

	PetLingXingUp_FakeObject:SetFakeObject("");
	Pet:SetSkillStudyModel(petIndex);

	PetLingXingUp_FakeObject:SetFakeObject( "My_PetStudySkill" );
	

	--�л����޵�ʱ���ͷ���һ������
	if(m_PetIndex ~= -1) then
		Pet:SetPetLocation(m_PetIndex,-1);
	end

	m_PetIndex = petIndex;	--�Ѿ�ѡ��������
	Pet:SetPetLocation(m_PetIndex,10);
--	Pet:ClosePetSkillStudyMsgBox()

	PetLingXingUp_UICheck()

end


function PetLingXingUp_CleanUp()
	PetLingXingUp_Money:SetProperty("MoneyNumber", 0 );
	PetLingXingUp_Pet_Text:SetText("")
	PetLingXingUp_OK:Disable()
	--PetLingXingUp_Quick_Up:Disable()
	--PetLingXingUp_Quick_Up : SetText( "#{ZSKJT_130507_1}" )
	--PetLingXingUp_Quick_Up_Animate:Play(false)

	PetLingXingUp_FakeObject:SetFakeObject("");

	PetLingXingUp_Probability_Percent:SetText("")
	PetLingXingUp_Wuxing_Percent:SetText("")

	if(m_PetIndex ~= -1) then
		Pet:SetPetLocation(m_PetIndex,-1);
	end
	m_PetIndex = -1
end


function PetLingXingUp_UICheck()
	
	PetLingXingUp_Money:SetProperty("MoneyNumber", 0 );
	PetLingXingUp_Pet_Text:SetText("")
	PetLingXingUp_OK:Disable()
	--PetLingXingUp_Quick_Up:Enable()
	--PetLingXingUp_Quick_Up : SetText( "#{ZSKJT_130428_1}" )
	--PetLingXingUp_Quick_Up_Animate:Play(true)
	if  m_PetIndex ~= -1 then
		local strName , strName2 = Pet:GetName(m_PetIndex)
		PetLingXingUp_Pet_Text:SetText(strName)	
		
		local gen = 100--Pet:GetType(m_PetIndex)
		if gen >= 100 and gen < 110 then				 --100����Ϊ�û�����
			PetLingXingUp_Money:SetProperty("MoneyNumber", m_money[gen - 99] );	
			local nLx = LuaFn_GetPetLingXing(m_PetIndex,2)
			if nLx ~= 0 and m_money[nLx] ~= nil then
				PetLingXingUp_Money:SetProperty("MoneyNumber", m_money[nLx]);	
			end
			PetLingXingUp_OK:Enable()
			local upRate = 100
			local nSuccessRate = {100,60,36,20,12,8,5,3,2,1}
			PetLingXingUp_Probability_Percent:SetText(upRate.."%")

	local nLingXingAttr = {10,20,50,70,110,140,180,220,260,310}
	local upPercent,nNowLx = 0,nLx
	if nLingXingAttr[nLx] ~= nil then
		if nType == 0 then
			upPercent = nLingXingAttr[nLx]
		else
			upPercent = nLingXingAttr[nLx + 1]
		end
	end			
			if upPercent ~= nil and nNowLx ~= nil and nSuccessRate[nNowLx] ~= nil then
				PetLingXingUp_Probability_Percent:SetText(nSuccessRate[nNowLx].."%")
				local perStr = string.format("%0.1f" , upPercent / 10.0)
				PetLingXingUp_Wuxing_Percent:SetText(perStr.."%")
			end
		else
			PetLingXingUp_Probability_Percent:SetText("")
			PetLingXingUp_Wuxing_Percent:SetText("")
		end
	end
end


--Care Obj
function PetLingXingUp_BeginCareObj(obj_id)
	m_ObjCared = DataPool : GetNPCIDByServerID(obj_id);
	this:CareObject(m_ObjCared, 1);
end



function PetLingxing_YBPay_Clicked() --add:lby2015����Ԫ��ȷ�Ϲ���
	if(m_YuanbaoBuyState>=1)then
		--PetLingXingUp_Yuanbao_Bind:SetCheck(1);
		m_YuanbaoBuyState = 0
	else
		--PetLingXingUp_Yuanbao_Bind:SetCheck(0);
		m_YuanbaoBuyState = 1
	end	
end

--add:lby2015
function PetYuanbaoBuyLingxingAsk()
end