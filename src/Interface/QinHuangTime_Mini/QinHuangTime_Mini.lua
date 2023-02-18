

local g_QinHuangTime_Mini_SceneId;

function QinHuangTime_Mini_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	--离开场景，自动关闭
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED", false)	
	this:RegisterEvent("QIHUANTIME_SWITCH")
end

function QinHuangTime_Mini_OnLoad()	

end

function QinHuangTime_Mini_OnEvent(event)
	if event == "QIHUANTIME_SWITCH" then
		if tonumber(arg0) == 0 then
			local sceneId = tonumber(arg1)
			if sceneId == 400 then
				QinHuangTime_Mini_PageHeader:SetText("#{MJXZ_210510_09}")
			elseif sceneId == 401 then
				QinHuangTime_Mini_PageHeader:SetText("#{MJXZ_210510_18}")
			elseif sceneId == 402 then
				QinHuangTime_Mini_PageHeader:SetText("#{MJXZ_210510_21}")
			elseif sceneId == 203 then
				QinHuangTime_Mini_PageHeader:SetText("#{MJXZ_210510_26}")
			end	
			g_QinHuangTime_Mini_SceneId = sceneId		
			this:Show()
		else
			this:Hide()
		end
	elseif event == "HIDE_ON_SCENE_TRANSED" then
		this:Hide()
	elseif event == "UI_COMMAND" and tonumber(arg0) == 20210510 then
		local sceneId = tonumber(arg1)
		if sceneId == 400 or sceneId == 401 or sceneId == 402 or sceneId == 203 then

		else
			this:Hide()
		end
	end
end


function QinHuangTime_Mini_Open()
	PushEvent("QIHUANTIME_SWITCH",g_QinHuangTime_Mini_SceneId)
end