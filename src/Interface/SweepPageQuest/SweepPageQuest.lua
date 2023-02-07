
function SweepPageQuest_PreLoad()
	this:RegisterEvent("OPEN_SWEEPPAGE_QUEST")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
end

function SweepPageQuest_OnLoad()
end

function SweepPageQuest_OnEvent(event)
	if event == "OPEN_SWEEPPAGE_QUEST" then
		SweepPageQuest_Open(arg0)
	elseif event == "HIDE_ON_SCENE_TRANSED" then
		this:Hide()
	end
end

function SweepPageQuest_Open(arg0)
	if arg0 == nil then
		return
	end
	
	if arg0 == "SweepAll_ExplainHelp" then
		SweepPageQuestGreeting_Desc:Hide()
		SweepPageQuestGreeting_Desc1:Show()
		SweepPageQuest_Title:SetText("")
		SweepPageQuestGreeting_Desc1:ClearAllElement()
		SweepPageQuestGreeting_Desc1:AddTextElement("#{FBSD_150126_04}")
	end

	this:Show()
end

function SweepPageQuest_Closed()
	this:Hide()
end

function SweepPageQuest_OnHidden()

end
