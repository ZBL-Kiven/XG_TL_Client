local g_nSelect_Index = -1;
local g_PreSelect = -1;
local g_PetIndex  = {};
local PET_MAX_NUMBER = 10	--最大珍兽携带上限 --add by xindefeng

--===============================================
-- OnLoad()
--===============================================
function PetListEx_PreLoad()	
	this:RegisterEvent("UI_COMMAND");
end

function PetListEx_OnLoad()

	for i=1 ,20   do
		g_PetIndex[i] = -1;
	end

end

--===============================================
-- OnEvent()
--===============================================
function PetListEx_OnEvent(event)
    if (event == "UI_COMMAND" and tonumber(arg0) == 20201244)then
	    PetListEx_UpdateFrame()
		g_nSelect_Index = -1
		this:Show()
	end

end

--===============================================
-- 更新界面
--===============================================
function PetListEx_UpdateFrame()

	PetListEx_List:ClearListBox();
	local nPetCount = Pet:GetPet_Count();
	local PetInListIndex = 0;
	for	i=1, PET_MAX_NUMBER do	--modify by xindfeng
		local szPetName,szOn = Pet:GetPetList_Appoint(i-1);
		local strToolTips = "";
		
		if(szPetName ~= "")   then
			if( szOn ~= "on_packa" )  then 
				szPetName = "#c808080" .. szPetName;
			end
			if(PlayerPackage:IsPetLock(i-1) == 1)    then
			    local nUnlockElapsedTime = PlayerPackage:GetPUnlockElapsedTime_Pet(i-1);
				if( nUnlockElapsedTime == 0 ) then
					szPetName = szPetName.. "  #-05";
					
					strToolTips =  "已加锁" ;
				else
					szPetName = szPetName.. "  #-10";
					
					local strLeftTime = g_GetUnlockingStr(nUnlockElapsedTime);			
					strToolTips = strLeftTime ;
				end
			end
			PetListEx_List:AddItem(szPetName, i-1);
			PetListEx_List:SetItemTooltip( PetInListIndex, strToolTips );
			PetInListIndex = PetInListIndex + 1 ;
		end
	end

end

--===============================================
-- 选择
--===============================================
function PetListEx_Choose_Click()
	g_nSelect_Index = PetListEx_List:GetFirstSelectItem();
	if( g_nSelect_Index == -1 )  then
		return;
	end
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "PetChangeModelForItem" );
		Set_XSCRIPT_ScriptID(900009);
		Set_XSCRIPT_Parameter(0,g_nSelect_Index);
		Set_XSCRIPT_ParamCount(1);
	Send_XSCRIPT()	
	this:Hide()
	if g_nSelect_Index ~= -1 then
		Pet:SetPetLocation(g_nSelect_Index,-1);
	end	
end

--===============================================
-- 放弃
--===============================================
function PetListEx_Refuse_Click()
	if g_nSelect_Index ~= -1 then
		Pet:SetPetLocation(g_nSelect_Index,-1);
	end
	this:Hide();
end

--===============================================
-- 选中列表中的珍兽
--===============================================
function PetListEx_List_Selected()
	g_nSelect_Index = PetListEx_List:GetFirstSelectItem();
end

