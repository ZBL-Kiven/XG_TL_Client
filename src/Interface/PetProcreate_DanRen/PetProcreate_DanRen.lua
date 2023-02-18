local MySelf_Pet = ""
local Other_Pet = ""
local bIsSelfLock = 0
local bIsOtherLock = 0
local bIsConfirm = 0
local objCared = -1
local MAX_OBJ_DISTANCE = 15.0;
local PetProcreate_DanRenLock = -1
local PetProcreate_DanRenPet_Index1 = -1
local PetProcreate_DanRenPet_Index2 = -1
function PetProcreate_DanRen_PreLoad()
	this:RegisterEvent("UI_COMMAND");	
	-- this:RegisterEvent("PETPROCREATE_MYSELF");	
	-- this:RegisterEvent("PETPROCREATE_OTHER");
	-- this:RegisterEvent("PETPROCREATE_OTHER_LOCK");	
	-- this:RegisterEvent("PETPROCREATE_OTHER_OK");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	-- this:RegisterEvent("PETPROCREATE_KEY_STATE");	
end

function PetProcreate_DanRen_OnLoad()
	PetProcreate_DanRen_WarningText:SetText("ֻҪ�����ṩ#G����С��#W��������������#G���˽������޵ķ�ֳ#W�����������ƣ��޷��̳гɳ��ʡ�#Gע�⣺ȷ�Ϸ�ֳ����ȡ��ֳ����ʱ�뱣������2�����޿�λ��")
end


function PetProcreate_DanRen_OnEvent(event)
	
	if ( event == "UI_COMMAND" and tonumber(arg0) == 20210216) then
		MySelf_Pet = ""
		if IsWindowShow("PetSkillStudy") then
			PetProcreate_DanRen_Self_PetModel : SetFakeObject( "" )
			PetProcreate_DanRen_Other_PetModel : SetFakeObject( "" )
			CloseWindow("PetSkillStudy" ,true)
		end
		--��0���ǽ�Ǯ
		local xx = Get_XParam_INT(0);
		objCared = DataPool : GetNPCIDByServerID(xx);
		AxTrace(0,1,"xx="..xx .. " objCared="..objCared)
		if objCared == -1 then
				PushDebugMessage("server�����������������⡣");
				return;
		end
		BeginCareObject_PetProcreate_DanRen(objCared)
		PetProcreate_DanRen_OnUICommand();
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 201812271 and this:IsVisible())	then
		if this : IsVisible() then		-- ������濪�ţ��򲻴���
			if MySelf_Pet == "" then
				PetProcreate_DanRenUpdate(1,arg1)
			elseif MySelf_Pet ~= "" then
				PetProcreate_DanRenUpdate(2,arg1)
			end
		else
			PetProcreate_DanRen_Self_PetModel : SetFakeObject( "" )
			PetProcreate_DanRen_Other_PetModel : SetFakeObject( "" )			
			return
		end
	elseif  ( event == "PETPROCREATE_MYSELF" ) then
		MySelf_Pet=tostring(arg0);
		PetProcreate_DanRen_Self_Pet : SetText(MySelf_Pet);
		PetProcreate_DanRen_Self_PetModel : SetFakeObject( "" );
		Pet:SetProcreate_Self_Model();
		PetProcreate_DanRen_Self_PetModel : SetFakeObject( "My_PetProcreateOther" );
		PetProcreate_DanRen_ViewDesc_Self : Enable();
		PetProcreate_DanRen_Self_Lock:Enable();
		PetProcreate_DanRen_Self_Lock:SetCheck(0);
		bIsSelfLock = 0
		bIsConfirm = 0
		PetProcreate_DanRen_Accept:Disable();
		
	elseif  ( event == "PETPROCREATE_OTHER" ) then
		Other_Pet = tostring(arg0);
		PetProcreate_DanRen_Other_Pet : SetText(Other_Pet);
		PetProcreate_DanRen_Other_PetModel : SetFakeObject( "" );
		Pet:SetProcreate_Other_Model();
		PetProcreate_DanRen_Other_PetModel : SetFakeObject( "My_PetProcreate_DanRenOther" );
		PetProcreate_DanRen_Other_Lock : SetCheck(0)
		bIsOtherLock = 0
		PetProcreate_DanRen_Refresh_Confirm()	
	
	elseif  ( event == "PETPROCREATE_OTHER_LOCK" ) then
		if tonumber(arg0) == 1 then
			PetProcreate_DanRen_Other_Lock : SetCheck(1)
			bIsOtherLock = 1
			PetProcreate_DanRen_Refresh_Confirm()	
		else
			PetProcreate_DanRen_Other_Lock : SetCheck(0)
			bIsOtherLock = 0
			if bIsSelfLock == 1 then
				PetProcreate_DanRen_Lock_Clicked();
			end
			PetProcreate_DanRen_Refresh_Confirm()	
		end
	
	elseif  ( event == "PETPROCREATE_OTHER_OK" ) then
		if tonumber(arg0) == 1 then
			PushDebugMessage("�Է�ȷ���˷�ֳ��")
			PetProcreate_DanRen_Refresh_Confirm_Ok()
		else
			PushDebugMessage("�Է�ȡ���˷�ֳ��")
			PetProcreate_DanRen_Close2(1)
		end
	elseif ( event == "PETPROCREATE_KEY_STATE")then
		PetProcreate_DanRen_Refresh_BtnOK(tonumber(arg0));
	elseif (event == "OBJECT_CARED_EVENT") then
		if(not this:IsVisible() ) then
			return;
		end
	
		if(tonumber(arg0) ~= objCared) then
			return;
		end

		--�����NPC�ľ������һ��������߱�ɾ�����Զ��ر�
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			--ȡ������
			PetProcreate_DanRen_OK_Clicked(0)
		end
	end
	
	return
end

function PetProcreate_DanRen_OnUICommand()
	g_Money = 1000000--Get_XParam_INT(0)
	--PetProcreate_DanRen_Consume : SetText("#{_MONEY".. g_Money .."}")
	PetProcreate_DanRen_Consume:SetProperty( "MoneyNumber", tostring(g_Money) );

	PetProcreate_DanRen_Show();		
end

function PetProcreate_DanRen_Show()
	Pet:ShowPetList(1);
	this:Show();
	PetProcreate_DanRen_Accept:Disable();
	PetProcreate_DanRen_Self_Pet:SetText("")
	PetProcreate_DanRen_Other_Pet:SetText("")
	
	PetProcreate_DanRen_Other_Lock : SetCheck(0);
	PetProcreate_DanRen_Other_Lock : Disable();
	PetProcreate_DanRen_Self_Lock:SetCheck(0);
	PetProcreate_DanRen_Self_Lock:Disable();
	
	PetProcreate_DanRen_ViewDesc_Self:Disable();
	PetProcreate_DanRen_ViewDesc_Other:Disable();
	bIsSelfLock = 0
	bIsOtherLock = 0
	PetProcreate_DanRen_Self_PetModel : SetFakeObject( "" )
	PetProcreate_DanRen_Other_PetModel : SetFakeObject( "" )
	
end
function PetProcreate_DanRenUpdate(nIndex,arg1)
	if nIndex == 1 then
		MySelf_Pet = Pet:GetName(tonumber(arg1))		
		PetProcreate_DanRen_Other_Pet : SetText(MySelf_Pet);
		PetProcreate_DanRen_Other_PetModel : SetFakeObject( "" );
		Pet:SetSkillStudyModel(tonumber(arg1));
		PetProcreate_DanRen_Other_PetModel : SetFakeObject( "My_PetStudySkill" );
		PetProcreate_DanRen_Other_Lock : SetCheck(0)
		PetProcreate_DanRen_ViewDesc_Other:Enable()
		bIsOtherLock = 0
		PetProcreate_DanRen_Refresh_Confirm()
		PetProcreate_DanRenPet_Index1 = tonumber(arg1)
		Pet:SetPetLocation(tonumber(arg1),-1);
	else
		Other_Pet = Pet:GetName(tonumber(arg1))		
		PetProcreate_DanRen_Self_Pet : SetText(Other_Pet);
		PetProcreate_DanRen_Self_PetModel : SetFakeObject( "" );
		Pet:SetSkillLevelupModel(tonumber(arg1));
		PetProcreate_DanRen_Self_PetModel : SetFakeObject( "My_PetLevelup" );
		PetProcreate_DanRen_ViewDesc_Self : Enable()
		PetProcreate_DanRen_Self_Lock:SetCheck(0);
		bIsSelfLock = 0
		PetProcreate_DanRen_Accept:Disable();	
		PetProcreate_DanRen_Refresh_Confirm()
		PetProcreate_DanRenPet_Index2 = tonumber(arg1)	
		Pet:SetPetLocation(tonumber(arg1),-1);		
	end
end
function PetProcreate_DanRen_Lock_Other_Clicked()
	-- Pet:LockPetProcreate_DanRen()
	if bIsOtherLock == 0 then
		bIsOtherLock = 1
	else
		bIsOtherLock = 0
	end
	PetProcreate_DanRen_Other_Lock:SetCheck(bIsOtherLock);
	PetProcreate_DanRen_Refresh_Confirm()
end


function PetProcreate_DanRen_Lock_Self_Clicked()
	-- Pet:LockPetProcreate_DanRen()
	if bIsSelfLock == 0 then
		bIsSelfLock = 1
	else
		bIsSelfLock = 0
	end
	PetProcreate_DanRen_Self_Lock:SetCheck(bIsSelfLock);
	PetProcreate_DanRen_Refresh_Confirm()
end

function PetProcreate_DanRen_OK_Clicked()

	if PetProcreate_DanRenLock ~= 1 then
		PetProcreate_DanRen_Accept:Disable();
		return
	end
	--�õ�Index��
	if (PetProcreate_DanRenPet_Index1 == -1 or PetProcreate_DanRenPet_Index2 == -1) and PetProcreate_DanRenPet_Index1 == PetProcreate_DanRenPet_Index2 then
		return
	end
	--�Ա��ж�
	local _,_,sex_1 = Pet:GetID(PetProcreate_DanRenPet_Index1)
	local _,_,sex_2 = Pet:GetID(PetProcreate_DanRenPet_Index2)
	if sex_1 == sex_2 then
		PushDebugMessage("��ֳ����ֻ���ޱ��뻥Ϊ����")
		return
	end
	--�Ƿ�����ж�
	local nEra_1 = Pet:GetPetTypeName(PetProcreate_DanRenPet_Index1);
	local nEra_2 = Pet:GetPetTypeName(PetProcreate_DanRenPet_Index2);
	if nEra_1 == 1 or nEra_2 == 1then
		PushDebugMessage("���������޷����з�ֳ") 
		return
	end
	local npet1_H,npet1_L = Pet:GetGUID(PetProcreate_DanRenPet_Index1);
	local npet2_H,npet2_L = Pet:GetGUID(PetProcreate_DanRenPet_Index2);
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "PetProcreateDanRen" );
		Set_XSCRIPT_ScriptID(900009);
		Set_XSCRIPT_Parameter(0,npet1_H);
		Set_XSCRIPT_Parameter(1,npet1_L);
		Set_XSCRIPT_Parameter(2,npet2_H);
		Set_XSCRIPT_Parameter(3,npet2_L);
		Set_XSCRIPT_ParamCount(4);
	Send_XSCRIPT()	
end

function PetProcreate_DanRen_Close()
	StopCareObject_Carriage(objCared);
	Pet : ShowPetList(0);
end

--===============================================
-- �Ҽ����(�鿴�Է�����������)
--===============================================
function PetProcreate_DanRen_Other_PetList_RClick()
	if PetProcreate_DanRen_Other_Pet:GetText() ~= "" then
		Pet:ViewPetDetailData("other");
	end
end

--===============================================
-- �Ҽ����(�鿴�Լ�����������)
--===============================================
function PetProcreate_DanRen_Self_PetList_RClick()
	if PetProcreate_DanRen_Self_Pet:GetText() ~= "" then
		Pet:ViewPetDetailData("self");
	end
end

----------------------------------------------------------------------------------
--
-- ��ת����ģ�ͣ�����)
--
function PetProcreate_DanRen_Self_TurnLeft(start)
	--������ת��ʼ
	if(start == 1) then
		PetProcreate_DanRen_Self_PetModel:RotateBegin(-0.3);
	--������ת����
	else
		PetProcreate_DanRen_Self_PetModel:RotateEnd();
	end
end

----------------------------------------------------------------------------------
--
--��ת����ģ�ͣ�����)
--
function PetProcreate_DanRen_Self_TurnRight(start)
	--������ת��ʼ
	if(start == 1) then
		PetProcreate_DanRen_Self_PetModel:RotateBegin(0.3);
	--������ת����
	else
		PetProcreate_DanRen_Self_PetModel:RotateEnd();
	end
end


----------------------------------------------------------------------------------
--
-- ��ת����ģ�ͣ�����)
--
function PetProcreate_DanRen_Other_TurnLeft(start)
	--������ת��ʼ
	if(start == 1) then
		PetProcreate_DanRen_Other_PetModel:RotateBegin(-0.3);
	--������ת����
	else
		PetProcreate_DanRen_Other_PetModel:RotateEnd();
	end
end

----------------------------------------------------------------------------------
--
--��ת����ģ�ͣ�����)
--
function PetProcreate_DanRen_Other_TurnRight(start)
	--������ת��ʼ
	if(start == 1) then
		PetProcreate_DanRen_Other_PetModel:RotateBegin(0.3);
	--������ת����
	else
		PetProcreate_DanRen_Other_PetModel:RotateEnd();
	end
end

function PetProcreate_DanRen_PetList_Show()
	DataPool : ToggleShowPetList();
end

function PetProcreate_DanRen_Refresh_BtnOK(isEnable)
	if(isEnable > 0) then
		PetProcreate_DanRen_Accept:Enable()
	else
		PetProcreate_DanRen_Accept:Disable()
	end
end

function PetProcreate_DanRen_Refresh_Confirm()
	if bIsSelfLock == 1 and bIsOtherLock == 1 then
		PetProcreate_DanRenLock = 1
		PetProcreate_DanRen_Accept:Enable()
	else
		PetProcreate_DanRen_Accept:Disable()
		PetProcreate_DanRenLock = -1
	end
	
end

function PetProcreate_DanRen_Refresh_Confirm_Ok()
	-- if bIsConfirm == 1  then
		PetProcreate_DanRen_Close2()
	-- end
end

--=========================================================
--��ʼ����NPC��
--�ڿ�ʼ����֮ǰ��Ҫ��ȷ����������ǲ����Ѿ��С����ġ���NPC��
--����еĻ�����ȡ���Ѿ��еġ����ġ�
--=========================================================
function BeginCareObject_PetProcreate_DanRen(objCaredId)

	g_Object = objCaredId;
	AxTrace(0,0,"LUA___CareObject g_Object =" .. g_Object );
	this:CareObject(g_Object, 1, "PetProcreate_DanRen");

end

--=========================================================
--ֹͣ��ĳNPC�Ĺ���
--=========================================================
function StopCareObject_PetProcreate_DanRen(objCaredId)
	this:CareObject(objCaredId, 0, "PetProcreate_DanRen");
	g_Object = -1;

end


function PetProcreate_DanRen_Frame_OnHide()
	--�ص���ؽ���
	PetProcreate_DanRen_Close2();
	--��ȡ����Ϣ
	-- Pet:ConfirmPetProcreate_DanRen(0);
end

function PetProcreate_DanRen_Close2()
	Pet:ClosePetSkillStudyMsgBox()
	MySelf_Pet = ""
	Other_Pet = ""
	bIsSelfLock = 0
	bIsOtherLock = 0	
	--���ñ���
	PetProcreate_DanRen_Self_PetModel : SetFakeObject( "" )
	PetProcreate_DanRen_Other_PetModel : SetFakeObject( "" )
	Pet:SetPetLocation(PetProcreate_DanRenPet_Index1,-1)
	Pet:SetPetLocation(PetProcreate_DanRenPet_Index2,-1)
	PetProcreate_DanRenPet_Index1 = -1
	PetProcreate_DanRenPet_Index2 = -1
	PetProcreate_DanRenLock = -1
	this:Hide();
end