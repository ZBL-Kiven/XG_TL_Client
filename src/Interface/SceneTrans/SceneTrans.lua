
local g_strTargetSceneName;

function SceneTrans_PreLoad()
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	this:RegisterEvent("SCENE_TRANSED");
	this:RegisterEvent("ON_SCENE_TRANSING");
end

function SceneTrans_OnLoad()
end
	
function SceneTrans_OnEvent(event)
	if ( event == "PLAYER_LEAVE_WORLD" ) then
		g_strTargetSceneName = arg0;
		SceneTrans_TargetScene:SetText("ǰ��" .. g_strTargetSceneName);
		this:Show();
	elseif( event == "ON_SCENE_TRANSING") then
		if(this:IsVisible()) then
			SceneTrans_TargetScene:SetText("ǰ��" .. g_strTargetSceneName .. "[" .. tostring(arg0) .. "]");
		end
	elseif ( event == "SCENE_TRANSED" ) then
		local defent = DataPool:GetPlayerMission_DataRound(469)
		if defent == 0 then
			local DefDress = GetGameMissionData("CREATEROLE")
			Clear_XSCRIPT();
				Set_XSCRIPT_Function_Name("RideSysteam");
				Set_XSCRIPT_ScriptID(830243);
				Set_XSCRIPT_Parameter(0,15);
				Set_XSCRIPT_Parameter(1,DefDress);
				Set_XSCRIPT_ParamCount(2);
			Send_XSCRIPT();			
		end
		this:Hide();
	end
end
