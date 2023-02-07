--Award.lua
--领取奖励

local g_AwardNpcId = -1;
local g_Award_targetId = -1;
local g_AwardConfirm1 = 0
local g_AwardConfirm2 = 0
local g_AwardHavePrize = {0, 0, 0, 0};

function Award_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("BILLINGAWARD_CONFIRM_OK");
end

function Award_OnLoad()
	g_AwardConfirm1 = 0;
	g_AwardConfirm2 = 0;
end

function Award_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == 80806201 ) then
		
		local bIsShow = Get_XParam_INT(0);
		if bIsShow == 1 then
			this:Show()
		end
						
		if this:IsVisible() then
		
			for i=1,4 do
				g_AwardHavePrize[i] = Get_XParam_INT(i);	
			end
			Award_UpdateButton();
				
			if bIsShow == 1 then
				g_Award_targetId = Get_XParam_INT(5)
				g_AwardNpcId = DataPool : GetNPCIDByServerID(g_Award_targetId)
				if g_AwardNpcId == -1 then
					Award_Close()
					return
				end
			
				this : CareObject( g_AwardNpcId, 1, "Award" )
			end
		end
		
	elseif (event == "BILLINGAWARD_CONFIRM_OK") then	
		local nIndex = tonumber(arg0);
		if nIndex == 1 then
			g_AwardConfirm1 = 1;
		elseif nIndex == 2 then
			g_AwardConfirm2 = 1;
		end
		
	elseif (event == "OBJECT_CARED_EVENT") then
		if(tonumber(arg0) ~= g_AwardNpcId) then
			return;
		end
		
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if arg1 == "distance" and tonumber(arg2) > MAX_OBJ_DISTANCE or arg1=="destroy" then
			Award_Close()
		end
	end
end

function Award_UpdateButton()
	local buttonCtrl={Award_Frame_Button1, Award_Frame_Button2, Award_Frame_Button3 };
	
	for i=1,3 do
		if g_AwardHavePrize[i] == 1 then
			buttonCtrl[i]:Enable();
		else
			buttonCtrl[i]:Disable();
		end
	end
	
end

function Award_GetPrize( index )

	if g_AwardConfirm1 == 0 and index == 1 then
			PushEvent("BILLINGAWARD_CONFIRM", 1, "#{LJSJ_160308_09}");
			return
	elseif g_AwardConfirm2 == 0 and index == 2 then
			PushEvent("BILLINGAWARD_CONFIRM", 2, "#{LJSJ_160308_12}");
			return
	end
	
	if index >= 1 and index <= 3 then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "OnGetPrize" )
			Set_XSCRIPT_ScriptID( 808062 )
			Set_XSCRIPT_Parameter( 0, g_Award_targetId )
			Set_XSCRIPT_Parameter( 1, index-1 )
			Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT()
		
		g_AwardHavePrize[index] = 0;
		Award_UpdateButton()
	end
	
end

function Award_OnHiden()
	PushEvent("BILLINGAWARD_CONFIRM", -1);
	this:CareObject(g_AwardNpcId, 0, "Award")
	g_AwardNpcId = -1
end

function Award_Close()
	this:Hide()
end

