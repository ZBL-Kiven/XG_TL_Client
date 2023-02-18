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
	PetProcreate_DanRen_WarningText:SetText("只要你能提供#G爱心小窝#W，就能在我这里#G单人进行珍兽的繁殖#W。因引擎限制，无法继承成长率。#G注意：确认繁殖和领取繁殖珍兽时请保留至少2个珍兽空位。")
end


function PetProcreate_DanRen_OnEvent(event)
	
	if ( event == "UI_COMMAND" and tonumber(arg0) == 20210216) then
		MySelf_Pet = ""
		if IsWindowShow("PetSkillStudy") then
			PetProcreate_DanRen_Self_PetModel : SetFakeObject( "" )
			PetProcreate_DanRen_Other_PetModel : SetFakeObject( "" )
			CloseWindow("PetSkillStudy" ,true)
		end
		--第0个是金钱
		local xx = Get_XParam_INT(0);
		objCared = DataPool : GetNPCIDByServerID(xx);
		AxTrace(0,1,"xx="..xx .. " objCared="..objCared)
		if objCared == -1 then
				PushDebugMessage("server传过来的数据有问题。");
				return;
		end
		BeginCareObject_PetProcreate_DanRen(objCared)
		PetProcreate_DanRen_OnUICommand();
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 201812271 and this:IsVisible())	then
		if this : IsVisible() then		-- 如果界面开着，则不处理
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
			PushDebugMessage("对方确认了繁殖。")
			PetProcreate_DanRen_Refresh_Confirm_Ok()
		else
			PushDebugMessage("对方取消了繁殖。")
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

		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			--取消关心
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
	--得到Index。
	if (PetProcreate_DanRenPet_Index1 == -1 or PetProcreate_DanRenPet_Index2 == -1) and PetProcreate_DanRenPet_Index1 == PetProcreate_DanRenPet_Index2 then
		return
	end
	--性别判断
	local _,_,sex_1 = Pet:GetID(PetProcreate_DanRenPet_Index1)
	local _,_,sex_2 = Pet:GetID(PetProcreate_DanRenPet_Index2)
	if sex_1 == sex_2 then
		PushDebugMessage("繁殖的两只珍兽必须互为异性")
		return
	end
	--是否二代判断
	local nEra_1 = Pet:GetPetTypeName(PetProcreate_DanRenPet_Index1);
	local nEra_2 = Pet:GetPetTypeName(PetProcreate_DanRenPet_Index2);
	if nEra_1 == 1 or nEra_2 == 1then
		PushDebugMessage("二代珍兽无法进行繁殖") 
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
-- 右键点击(查看对方的珍兽资料)
--===============================================
function PetProcreate_DanRen_Other_PetList_RClick()
	if PetProcreate_DanRen_Other_Pet:GetText() ~= "" then
		Pet:ViewPetDetailData("other");
	end
end

--===============================================
-- 右键点击(查看自己的珍兽资料)
--===============================================
function PetProcreate_DanRen_Self_PetList_RClick()
	if PetProcreate_DanRen_Self_Pet:GetText() ~= "" then
		Pet:ViewPetDetailData("self");
	end
end

----------------------------------------------------------------------------------
--
-- 旋转珍兽模型（向左)
--
function PetProcreate_DanRen_Self_TurnLeft(start)
	--向左旋转开始
	if(start == 1) then
		PetProcreate_DanRen_Self_PetModel:RotateBegin(-0.3);
	--向左旋转结束
	else
		PetProcreate_DanRen_Self_PetModel:RotateEnd();
	end
end

----------------------------------------------------------------------------------
--
--旋转珍兽模型（向右)
--
function PetProcreate_DanRen_Self_TurnRight(start)
	--向右旋转开始
	if(start == 1) then
		PetProcreate_DanRen_Self_PetModel:RotateBegin(0.3);
	--向右旋转结束
	else
		PetProcreate_DanRen_Self_PetModel:RotateEnd();
	end
end


----------------------------------------------------------------------------------
--
-- 旋转珍兽模型（向左)
--
function PetProcreate_DanRen_Other_TurnLeft(start)
	--向左旋转开始
	if(start == 1) then
		PetProcreate_DanRen_Other_PetModel:RotateBegin(-0.3);
	--向左旋转结束
	else
		PetProcreate_DanRen_Other_PetModel:RotateEnd();
	end
end

----------------------------------------------------------------------------------
--
--旋转珍兽模型（向右)
--
function PetProcreate_DanRen_Other_TurnRight(start)
	--向右旋转开始
	if(start == 1) then
		PetProcreate_DanRen_Other_PetModel:RotateBegin(0.3);
	--向右旋转结束
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
--开始关心NPC，
--在开始关心之前需要先确定这个界面是不是已经有“关心”的NPC，
--如果有的话，先取消已经有的“关心”
--=========================================================
function BeginCareObject_PetProcreate_DanRen(objCaredId)

	g_Object = objCaredId;
	AxTrace(0,0,"LUA___CareObject g_Object =" .. g_Object );
	this:CareObject(g_Object, 1, "PetProcreate_DanRen");

end

--=========================================================
--停止对某NPC的关心
--=========================================================
function StopCareObject_PetProcreate_DanRen(objCaredId)
	this:CareObject(objCaredId, 0, "PetProcreate_DanRen");
	g_Object = -1;

end


function PetProcreate_DanRen_Frame_OnHide()
	--关掉相关界面
	PetProcreate_DanRen_Close2();
	--发取消消息
	-- Pet:ConfirmPetProcreate_DanRen(0);
end

function PetProcreate_DanRen_Close2()
	Pet:ClosePetSkillStudyMsgBox()
	MySelf_Pet = ""
	Other_Pet = ""
	bIsSelfLock = 0
	bIsOtherLock = 0	
	--设置变量
	PetProcreate_DanRen_Self_PetModel : SetFakeObject( "" )
	PetProcreate_DanRen_Other_PetModel : SetFakeObject( "" )
	Pet:SetPetLocation(PetProcreate_DanRenPet_Index1,-1)
	Pet:SetPetLocation(PetProcreate_DanRenPet_Index2,-1)
	PetProcreate_DanRenPet_Index1 = -1
	PetProcreate_DanRenPet_Index2 = -1
	PetProcreate_DanRenLock = -1
	this:Hide();
end