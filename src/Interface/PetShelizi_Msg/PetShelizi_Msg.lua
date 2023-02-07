local g_bagIndex = -1;
local g_petCurrLevel = -1;
local g_MaxLevel = -1;
function PetShelizi_Msg_PreLoad()
	this:RegisterEvent("UI_COMMAND");
end

function PetShelizi_Msg_OnLoad()
end

-- OnEvent
function PetShelizi_Msg_OnEvent(event)
	
	PetShelizi_Msg_Moral_Value:SetText("");
	PetShelizi_Msg_Moral_Value : Disable();
	PetShelizi_Msg_Check : SetCheck(0);
	
	if ( event == "UI_COMMAND" and tonumber(arg0) == 3000771) then
		local slzExp = Get_XParam_INT( 0 )
		local levelCanUp = Get_XParam_INT( 1 ) --����ֵ������������ߵȼ�
		local petLevel = Get_XParam_INT( 2 )
		local HumanMaxLevel = Get_XParam_INT( 3 )  --����Я����ߵȼ�
		local PetGuidH = Get_XParam_INT( 4 )
		local PetGuidL = Get_XParam_INT( 5 )
		g_bagIndex = Get_XParam_INT( 6 )
		g_petCurrLevel = petLevel;
		local petClass = Pet:GetPetDBCName(PetGuidH,PetGuidL)
		if levelCanUp == 0 then
			--�����������ᵽ������棬�ᵽMessageBox_Self����
			return
		elseif levelCanUp > 0 then
			
			--�������������ߵȼ�
			g_MaxLevel = HumanMaxLevel;
			if(g_MaxLevel > levelCanUp + petLevel) then
				g_MaxLevel = levelCanUp + petLevel;
			end
			
			local strText = string.format("#{SLZSDSJ_090922_1}%s#{SLZSDSJ_090922_2}%d#{SLZSDSJ_090922_3}%d#{SLZSDSJ_090922_4}%d#{SLZSDSJ_090922_5}%d#{SLZSDSJ_090922_6}%d#{SLZSDSJ_090922_7}",petClass,slzExp ,petLevel ,petLevel + levelCanUp ,HumanMaxLevel,g_MaxLevel);
																	
			PetShelizi_Msg_Text1:SetText( strText );
		end
		PetShelizi_Msg_Text2:SetText("#{SLZSDSJ_090915_11}");
		this:Show();
	end

end

function PetShelizi_Msg_Check_Clicked()
	if PetShelizi_Msg_Check : GetCheck() == 1 then
		PetShelizi_Msg_Moral_Value : Enable();
		PetShelizi_Msg_Moral_Value:SetProperty("DefaultEditBox", "True");
	else
		PetShelizi_Msg_Moral_Value:SetText("");
		PetShelizi_Msg_Moral_Value:SetProperty("DefaultEditBox", "False");
		PetShelizi_Msg_Moral_Value : Disable();
	end
end

-- ��ť1 ����¼�
function PetShelizi_Msg_Bn1Click()

	local upToLevel = -1; --Ĭ����������߼�
	if PetShelizi_Msg_Check : GetCheck() == 1 then 
		local upToLevelText = PetShelizi_Msg_Moral_Value:GetText();
		
		if(upToLevelText == "") then
			PushDebugMessage("#{SLZSDSJ_090915_12}");
			return
		end
	
		upToLevel = tonumber(upToLevelText);
		
		--PushDebugMessage(upToLevel);
		--PushDebugMessage(g_MaxLevel);
		
		if (upToLevel <= g_petCurrLevel) then
			PushDebugMessage("#{SLZSDSJ_090915_13}");
			return
		end
	
		if (upToLevel > g_MaxLevel) then
			PushDebugMessage("#{SLZSDSJ_090915_14}");
			return
		end
	end
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "UseShelizi" )
		Set_XSCRIPT_ScriptID( 300077 )
		Set_XSCRIPT_Parameter( 0, g_bagIndex )
		Set_XSCRIPT_Parameter( 1, upToLevel )
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()
	this:Hide();
end


-- ��ť2 ����¼�
function PetShelizi_Msg_Bn2Click()
	this:Hide();
end

function PetShelizi_Msg_Frame_OnHiden()
end
