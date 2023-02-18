local m_PetIndex = -1
-----------------------------------------------------------------------
-- OnGameEvent
-----------------------------------------------------------------------

function YbMarketUpPet_PreLoad()
	this:RegisterEvent("OPEN_UP_PET")
	this:RegisterEvent("CLOSE_UP_PET")
	this:RegisterEvent("REPLY_MISSION_PET")                        --��Ҵ��б�ѡ��һֻ����
	this:RegisterEvent("UPDATE_UP_PET_PAGE")
	this:RegisterEvent("DELETE_PET");                                --���۵��������ݱ仯��
	this:RegisterEvent("UPDATE_PET_PAGE")
end

function YbMarketUpPet_OnLoad()
end

function YbMarketUpPet_OnEvent(event)
	if event == "OPEN_UP_PET" then
		if this:IsVisible() then
			return
		end
		YbMarketUpPet_CleanUp()
		this:Show()
		Pet:ShowPetList(1)
	elseif event == "REPLY_MISSION_PET" and this:IsVisible() then
		
		YbMarketUpPet_OnSelectPet(tonumber(arg0))
	
	elseif event == "UPDATE_PET_PAGE" and this:IsVisible() then
		YbMarketUpPet_CleanUp()
	elseif event == "CLOSE_UP_PET" and this:IsVisible() then
		this:Hide()
	elseif (event == "DELETE_PET") then
		YbMarketUpPet_CleanUp()
	end
end

-----------------------------------------------------------------------
-- on events
-----------------------------------------------------------------------
function YbMarketUpPet_OK_Clicked()
	
	local price = YbMarketUpPet_Moral_Value:GetText()
	if m_PetIndex ~= -1 and price ~= "" and tonumber(price) > 0 then
		--��ȫʱ��
		if tonumber(DataPool:GetLeftProtectTime()) > 0 then
			PushDebugMessage("#{OR_PILFER_LOCK_FLAG}")
			return
		end
		--С��30��
		if Player:GetData("LEVEL") < 30 then
			PushDebugMessage("#{YBSC_100111_42}")
			return
		end
		--�ǹ�������
		if PlayerPackage:IsGoodsProtect_Pet(m_PetIndex) == 1 then
			PushDebugMessage("#{YBSC_100111_07}")
			return
		end
		--���ܴ�װ��
		if Pet:IsPetHaveEquip(m_PetIndex) == 1 then
			PushDebugMessage("#{ZSZB_090211_18}")
			return
		end
		if tonumber(price) > 200000 then
			PushDebugMessage("#{YBSC_100111_54}")
			return
		end
		if tonumber(price) < 2 then
			PushDebugMessage("#{YBSC_100111_53}")
			return
		end
		local needMoney = Auction:GetNeedMoneyForSell(tonumber(price))
		local myMoney = Player:GetData("MONEY_JZ") + Player:GetData("MONEY")
		if myMoney < needMoney then
			PushDebugMessage("#{YBSC_100111_09}")
			return
		end
		Auction:PacketSend_SellPet(m_PetIndex, tonumber(price), 0)
	end

end

function YbMarketUpPet_Cancel_Clicked()
	this:Hide()
end

function YbMarketUpPet_Count_Change()
	YbMarketUpPet_Refresh_Bn_and_Money()
end

function YbMarketUpPet_Pet_Modle_TurnLeft(start)
	--������ת��ʼ
	if (start == 1) then
		YbMarketUpPet_FakeObject:RotateBegin(-0.3);
		--������ת����
	else
		YbMarketUpPet_FakeObject:RotateEnd();
	end
end

function YbMarketUpPet_Pet_Modle_TurnRight(start)
	--������ת��ʼ
	if (start == 1) then
		YbMarketUpPet_FakeObject:RotateBegin(0.3);
		--������ת����
	else
		YbMarketUpPet_FakeObject:RotateEnd();
	end
end

function YbMarketUpPet_OnHidden()
	Pet:SetPetLocation(m_PetIndex, -1);
	m_PetIndex = -1;
	YbMarketUpPet_FakeObject:SetFakeObject("");
	Pet:ShowPetList(0)
	YbMarketUpPet_Moral_Value:SetText("")
	YbMarketUpPet_OK:Disable()
	YbMarketUpPet_NeedMoney:SetProperty("MoneyNumber", "0");
end

-----------------------------------------------------------------------
--private function
-----------------------------------------------------------------------
function YbMarketUpPet_OnSelectPet(petIndex)
	if (-1 == petIndex) then
		return ;
	end
	--�����ѱ���������ѡ��
	if (Pet:GetPetLocation(petIndex) ~= -1) then
		return ;
	end
	YbMarketUpPet_FakeObject:SetFakeObject("");
	Pet:SetSkillStudyModel(petIndex);
	YbMarketUpPet_FakeObject:SetFakeObject("My_PetStudySkill");
	--�л����޵�ʱ���ͷ���һ������
	if (m_PetIndex ~= -1) then
		Pet:SetPetLocation(m_PetIndex, -1);
	end
	m_PetIndex = petIndex;    --�Ѿ�ѡ��������
	Pet:SetPetLocation(m_PetIndex, 14);
	YbMarketUpPet_Refresh_Bn_and_Money()
end

function YbMarketUpPet_CleanUp()
	Pet:SetPetLocation(m_PetIndex, -1);
	m_PetIndex = -1;
	YbMarketUpPet_FakeObject:SetFakeObject("");
	YbMarketUpPet_Moral_Value:SetText("")
	YbMarketUpPet_OK:Disable()
	YbMarketUpPet_NeedMoney:SetProperty("MoneyNumber", "0");
end

function YbMarketUpPet_Refresh_Bn_and_Money()
	local price = YbMarketUpPet_Moral_Value:GetText()
	if m_PetIndex ~= -1 and price ~= "" and tonumber(price) > 0 then
		YbMarketUpPet_OK:Enable()
		YbMarketUpPet_NeedMoney:SetProperty("MoneyNumber", tostring(Auction:GetNeedMoneyForSell(tonumber(price))));
	else
		YbMarketUpPet_NeedMoney:SetProperty("MoneyNumber", "0");
		YbMarketUpPet_OK:Disable()
	end
end
