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

function tintUserMenPai(menPaiId)
	local strName = "";
	local nTalent = DataPool:GetPlayerMission_DataRound(480)
	-- 得到门派名称.
	if (0 == menPaiId) then
		strName = "少林";
		if nTalent == 1 then
			strName = "少林·罗汉"
		end
		if nTalent == 2 then
			strName = "少林·金刚"
		end
	elseif (1 == menPaiId) then
		strName = "明教";
		if nTalent == 1 then
			strName = "明教·天罗"
		end
		if nTalent == 2 then
			strName = "明教·血戾"
		end
	
	elseif (2 == menPaiId) then
		strName = "丐帮";
		if nTalent == 1 then
			strName = "丐帮·酒狂"
		end
		if nTalent == 2 then
			strName = "丐帮·行侠"
		end
	
	elseif (3 == menPaiId) then
		strName = "武当";
		if nTalent == 1 then
			strName = "武当·凭虚"
		end
		if nTalent == 2 then
			strName = "武当·摘星"
		end
	
	elseif (4 == menPaiId) then
		strName = "峨嵋";
		if nTalent == 1 then
			strName = "峨嵋·沁芳"
		end
		if nTalent == 2 then
			strName = "峨嵋·清音"
		end
	
	elseif (5 == menPaiId) then
		strName = "星宿";
		if nTalent == 1 then
			strName = "星宿·寒冥"
		end
		if nTalent == 2 then
			strName = "星宿·九厄"
		end
	
	elseif (6 == menPaiId) then
		strName = "天龙";
		if nTalent == 1 then
			strName = "天龙·龙威"
		end
		if nTalent == 2 then
			strName = "天龙·菩天"
		end
	
	elseif (7 == menPaiId) then
		strName = "天山";
		if nTalent == 1 then
			strName = "天山·霜凝"
		end
		if nTalent == 2 then
			strName = "天山·雪隐"
		end
	
	elseif (8 == menPaiId) then
		strName = "逍遥";
		if nTalent == 1 then
			strName = "逍遥·逸仙"
		end
		if nTalent == 2 then
			strName = "逍遥·明鬼"
		end
	elseif (9 == menPaiId) then
		strName = "无门派";
	elseif (10 == menPaiId) then
		strName = "曼陀山庄";
		if nTalent == 1 then
			strName = "曼陀·昭明"
		end
		if nTalent == 2 then
			strName = "曼陀·晚籁"
		end
	end
	return strName
end

function GetUserCountryName(colorParse, symbolParse)
	local countryName = DataPool:GetPlayerMission_DataRound(213)
	local name, color;
	if countryName == 10001 then
		color = "#c7f074f"
		name = "宋"
	elseif countryName == 10002 then
		color = "#c984009"
		name = "辽"
	elseif countryName == 10003 then
		color = "#c124b5a"
		name = "燕"
	else
		return 0, "流民"
	end
	if symbolParse == 1 then
		name = "·" .. name
	end
	if colorParse == 1 then
		return 1, color .. name
	end
	return 1, name
end
