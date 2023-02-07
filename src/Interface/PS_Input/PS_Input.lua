
local g_MoneyType=-1;

local PS_IMMITBASE			= 1;
local PS_IMMIT					= 2;
local PS_DRAW						= 3;

local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;

--===============================================
-- PreLoad
--===============================================
function PS_Input_PreLoad()
	this:RegisterEvent("PS_INPUT_MONEY");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("PS_CLOSE_SHOP_MAG");
end

--===============================================
-- OnLoad
--===============================================
function PS_Input_OnLoad()
end

--===============================================
-- OnEvent
--===============================================
function PS_Input_OnEvent(event)

	if(event == "PS_INPUT_MONEY") then
		--����̵���뱾��
		if (arg0 == "immitbase") then
			this:Show();
			objCared = PlayerShop:GetNpcId();
			this:CareObject(objCared, 1, "PS_Input");	

			g_nSaveOrGetMoney = PS_IMMITBASE;
			
			local nBaseMoney;
			local nMoney1;
			local nMoney2;
			local nMoney3;
			nBaseMoney,nMoney1,nMoney2,nMoney3 = PlayerShop:GetMoney("base","self");

			PS_Input_DragTitle:SetText("#gFF0FA0���뱾��");
			PS_Input_Accept:SetText("����");
			PS_Input_Warning:SetText("���뱾�������Ϊ10#-02#r��ǰ�������Ϊ".. tostring(nMoney1) .."#-02" .. tostring(nMoney2) .. "#-03" .. tostring(nMoney3) .. "#-04");
			PS_Input_CurrentlyPrincipal:SetProperty("MoneyNumber", tostring(nBaseMoney));
			PS_Input_Text1:SetText("����뱾��");
			PS_Input_Text2:SetText("��ǰ����");
			
			PS_Input_Gold:SetProperty("DefaultEditBox", "True");
			
		--����̵����
		elseif (arg0 == "immit") then
			this:Show();
			objCared = PlayerShop:GetNpcId();
			this:CareObject(objCared, 1, "PS_Input");	

			g_nSaveOrGetMoney = PS_IMMIT;
			PS_Input_DragTitle:SetText("#gFF0FA0����ӯ���ʽ�");
			PS_Input_Accept:SetText("����");
			PS_Input_CurrentlyPrincipal:SetProperty("MoneyNumber", tostring(PlayerShop:GetMoney("profit","self")));
			
			local nBaseMoney;
			local nMoney1;
			local nMoney2;
			local nMoney3;
			nBaseMoney,nMoney1,nMoney2,nMoney3 = PlayerShop:GetMoney("input_profit","self");
			local szCom = PlayerShop:GetCommercialFactor()

			local szInfo = "����ӯ���ʽ����������С�ڱ������ֵ�����������30" .. "#-02" .. "*��ҵָ��*��̨������ǰ����ҵָ��Ϊ".. szCom .. "��������Ҫ����".. tostring(nMoney1) .."#-02" .. tostring(nMoney2) .. "#-03" .. tostring(nMoney3) .. "#-04";
			PS_Input_Warning:SetText(szInfo);
			
			PS_Input_Text1:SetText("�����ӯ���ʽ�");
			PS_Input_Text2:SetText("��ǰӯ���ʽ�");

			PS_Input_Gold:SetProperty("DefaultEditBox", "True");

		--����̵�ȡ��
		elseif (arg0 == "draw") then
			this:Show();
			objCared = PlayerShop:GetNpcId();
			this:CareObject(objCared, 1, "PS_Input");	

			g_nSaveOrGetMoney = PS_DRAW;
			PS_Input_DragTitle:SetText("#gFF0FA0֧ȡӯ���ʽ�");
			PS_Input_Accept:SetText("֧ȡ");

			PS_Input_Warning:SetText("#{SHOPTIPS_090205_2}");--[tx44221]

			PS_Input_Text1:SetText("Ҫ֧ȡӯ���ʽ�");
			PS_Input_Text2:SetText("��ǰӯ���ʽ�");

			PS_Input_Gold:SetProperty("DefaultEditBox", "True");
			PS_Input_CurrentlyPrincipal:SetProperty("MoneyNumber", tostring(PlayerShop:GetMoney("profit","self")));
		end		
		PS_Input_Frame:SetForce();
		PS_Input_Gold:SetText("");
		PS_Input_Silver:SetText("");
		PS_Input_CopperCoin:SetText("");
		
	elseif ( event == "OBJECT_CARED_EVENT" )   then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		
		--�����NPC�ľ������һ��������߱�ɾ�����Զ��ر�
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			g_InitiativeClose = 1;
			this:Hide();

			--ȡ������
			this:CareObject(objCared, 0, "PS_Input");
		end	
	
	elseif( event == "PS_CLOSE_SHOP_MAG" )    then
	
		if( this:IsVisible() )   then
			this:Hide();
			--ȡ������
			this:CareObject(objCared, 0, "PS_Input");
		end
		
	end	
	
end

--===============================================
-- Accept
--===============================================
function PS_Input_Accept_Clicked()
	local szGold = PS_Input_Gold:GetText();
	local szSilver = PS_Input_Silver:GetText();
	local szCopperCoin = PS_Input_CopperCoin:GetText();
	
	--�ڳ�����ͷ�ټ�������ַ�����Ч�Ժ���ֵ
	local bAvailability,nMoney = Bank:GetInputMoney(szGold,szSilver,szCopperCoin);
	if(bAvailability == true) then
	
		if( g_nSaveOrGetMoney == PS_IMMITBASE ) then
			--���뱾��
			local szResult;
			local nResult;
			szResult,nResult= PlayerShop:DealMoney("immitbase",nMoney)
			if( szResult == "ok" )   then
				this:Hide();
				--ȡ������
				this:CareObject(objCared, 0, "PS_Input");

				PlayerShop:ApplyMoney("immitbase",nMoney);
				
			elseif(szResult == "few" )  then
				

			elseif(szResult == "more" )  then
				this:Hide();
				--ȡ������
				this:CareObject(objCared, 0, "PS_Input");

				PlayerShop:ApplyMoney("immitbase",nResult);

			end
		
		elseif( g_nSaveOrGetMoney == PS_IMMIT ) then
			--����
			local szResult;
			local nResult;
			szResult,nResult= PlayerShop:DealMoney("immit",nMoney);
			
			if( szResult == "ok" )   then
				this:Hide();
				--ȡ������
				this:CareObject(objCared, 0, "PS_Input");

				PlayerShop:ApplyMoney("immit",nMoney);
			
			elseif(szResult == "few" )  then
				
			
			elseif(szResult == "more" )  then
				this:Hide();
				--ȡ������
				this:CareObject(objCared, 0, "PS_Input");

				PlayerShop:ApplyMoney("immit",nResult);

			end
		
		elseif( g_nSaveOrGetMoney == PS_DRAW ) then
			--֧ȡ
			PlayerShop:ApplyMoney("draw_ok",nMoney);
			this:Hide();
			--ȡ������
			this:CareObject(objCared, 0, "PS_Input");
			
		end
	end
end

--===============================================
-- Cancel
--===============================================
function PS_Input_Cancel_Clicked()
	this:Hide();
	--ȡ������
	this:CareObject(objCared, 0, "PS_Input");
end


--===============================================
-- OnHiden
--===============================================
function PS_Input_Frame_OnHiden()
	PS_Input_Gold:SetProperty("DefaultEditBox", "False");
	PS_Input_Silver:SetProperty("DefaultEditBox", "False");
	PS_Input_CopperCoin:SetProperty("DefaultEditBox", "False");
end

