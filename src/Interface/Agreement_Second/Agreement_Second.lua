
local g_fullPath = "..\\Helper\\license-game.txt"
local g_Text = "no license..."
local g_fullPath_Privacy="..\\Helper\\license-privacy.txt"

local g_Agreement_Second_Frame_UnifiedPosition;

--===============================================
-- PreLoad()
--===============================================
function Agreement_Second_PreLoad()

	this:RegisterEvent("OPEN_AGREEMENT_SECOND_UI");
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED");
end

--===============================================
-- OnLoad()
--===============================================
function Agreement_Second_OnLoad()
	g_Agreement_Second_Frame_UnifiedPosition=Agreement_Second_Frame:GetProperty("UnifiedPosition");
end

--===============================================
-- OnEvent()
--===============================================
function Agreement_Second_OnEvent(event)
	
	if(event == "OPEN_AGREEMENT_SECOND_UI") then
		local nType = tonumber(arg0);
		if nType == 0 then	--用户协议
			local f = io.open(g_fullPath,"rb");
			if(f)then
				g_Text = f : read("*all");
			end
			if(f)then
				f : close();
				f = nil;
			end
			
			Agreement_Second_Title:SetText("#{TYXY_20211105_10}")
		
		else	--隐私协议
			local fprivacy = io.open(g_fullPath_Privacy,"rb");
			if(fprivacy)then
				g_Text = fprivacy : read("*all");
			end
			if(fprivacy)then
				fprivacy : close();
				fprivacy = nil;
			end
			
			Agreement_Second_Title:SetText("#{TYXY_20211105_11}")
		
		end

		Agreement_Second_Text:SetText(" ")
		Agreement_Second_Text:SetText(g_Text)
		
		if(not this:IsVisible() ) then
			this:Show()
		end
	elseif (event == "ADJEST_UI_POS" ) then
		Agreement_Second_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		Agreement_Second_Frame_On_ResetPos()
	elseif ( event == "HIDE_ON_SCENE_TRANSED" ) then
		Agreement_Second_Close()
	end
end

function Agreement_Second_Close()
	this : Hide();
end

function Agreement_Second_Frame_On_ResetPos()
  Agreement_Second_Frame:SetProperty("UnifiedPosition", g_Agreement_Second_Frame_UnifiedPosition);
end