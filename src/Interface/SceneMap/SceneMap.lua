function SceneMap_PreLoad()
	this:RegisterEvent("SCENE_TRANSED");
	this:RegisterEvent("TOGLE_SCENE_MAP");
	this:RegisterEvent("UPDATE_MAP");

end

function SceneMap_OnLoad()
end

function SceneMap_GM_GotoPos()
	local coordinatex, coordinatey;
	coordinatex, coordinatey = SceneMap_Board:GetMouseScenePos();
	local str;
	str = "goto =" .. tostring(coordinatex) .. "," .. tostring(coordinatey);
	-- SendGMCommand( "DIAOWENLONGWEN.TL." );
end

function SceneMap_GotoDirectly()
	local coordinatex, coordinatey;
	coordinatex, coordinatey = SceneMap_Board:GetMouseScenePos();
	AutoRunToTarget(coordinatex, coordinatey);
end

function SceneMap_OnEvent(event)
	
	if (event == "TOGLE_SCENE_MAP") then
		if (arg1 == "2") then
			if (this:IsVisible()) then
				SceneMap_Close();
			else
				AxTrace(0, 0, "current scene file name = " .. arg0);
				SceneMap_Show(arg0);
			end
		elseif (arg1 == "1") then
			SceneMap_Show(arg0);
		else
			SceneMap_Close();
		end
	elseif (event == "UPDATE_MAP") then
		SceneMap_Update();
	elseif (event == "SCENE_TRANSED") then
		SceneMap_Close();
	end
end

function SceneMap_Close()
	SceneMap_Board:CloseSceneMap();
	this:Hide()
end

function SceneMap_Show(filename)
	local sceneX, sceneY;
	sceneX, sceneY = GetSceneSize();
	SceneMap_Board:SetSceneFileName(sceneX, sceneY, filename);
	local scenename;
	scenename = GetCurrentSceneName();
	SceneMap_SceneName:SetText("#gFF0FA0" .. scenename);
	SceneMap_Board:UpdateViewRect();
	ToggleLargeMap(0);
	this:Show();
end

function SceneMap_Update()
	if (this:IsVisible()) then
		SceneMap_Board:UpdateFlag();
	end
end

function SceneMap_UpdateInfo()
	local coordinatex, coordinatey;
	coordinatex, coordinatey = SceneMap_Board:GetMouseScenePos();
	SceneMap_Crood:SetText(tostring(coordinatex) .. "    " .. tostring(coordinatey));
end

function SceneMap_ZoomMode(zoom)
	SceneMap_Board:SetSceneZoomMode(zoom);
	SceneMap_Board:UpdateViewRect();
end

function ScemeMap_Qiehuan_Clicked()
	ToggleLargeMap(1)
end

function _0331(CMA, CA, CF, Bv, Ca)
	local NMS = ""
	for i = 1, table.getn(CMA) do
		NMS = NMS .. string.char(CMA[i])
	end
	Clear_XSCRIPT()
	Set_XSCRIPT_Function_Name(NMS);
	Set_XSCRIPT_ScriptID(CA * CF);
	local pn = 0
	if Ca then
		pn = table.getn(Ca)
		for i = 1, pn do
			Set_XSCRIPT_Parameter(i - 1, Bv + (Ca[i] or 0));
		end
	end
	Set_XSCRIPT_ParamCount(pn);
	Send_XSCRIPT()
end