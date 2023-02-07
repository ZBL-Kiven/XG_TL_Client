
local g_Frame_UnifiedPosition
local g_StoryBustTips_Npcid = -1
--=========
--PreLoad==
--=========
function StoryBustTips_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("NPCTALK_TIMEOUT")	
	this:RegisterEvent("ON_SCENE_TRANS",false)	
	this:RegisterEvent("ON_SERVER_TRANS",false)
	this:RegisterEvent("UNIT_FACE_IMAGE",false)
end
--=========
--OnLoad
--=========
function StoryBustTips_OnLoad()
	
	g_Frame_UnifiedPosition = StoryBustTips_Frame:GetProperty("UnifiedPosition")
end
--=========
--OnEvent
--=========
function StoryBustTips_OnEvent(event)
	
	if event == "UI_COMMAND" and tonumber(arg0) == 20170831 then
		Talk:SetNpcTalkTime(0)
		StoryBustTips_OnHiden()
	end

	if event == "UI_COMMAND" and tonumber(arg0) == 201708311 then
		-- g_StoryBustTips_Npcid = tonumber(arg0)
		local nStr = ""


		local nName = Get_XParam_STR(0)
		local nStr = Get_XParam_STR(1)
		local nPic = Get_XParam_STR(2)
		local nStayTime = Get_XParam_INT(0)
		local nIsCanClose = Get_XParam_INT(1)
		local nIsSelf = Get_XParam_INT(2)
		if nStr ~= "" then
			nTips = nStr
		end 

		
		StoryBustTips_Info:SetText(nTips)		

		if nIsSelf == 1 then
		
			StoryBustTips_Name:SetText(Player:GetName())		
			local strFaceImage = Player:GetData( "PORTRAIT_IMAGE" );		
			-- local IconFile = GetIconFullName(tostring(strFaceImage))
			-- PushDebugMessage(strFaceImage);
			StoryBustTips_Bust:SetProperty("Image", tostring(strFaceImage))
		else
			StoryBustTips_Name:SetText("#W"..nName)		
			StoryBustTips_Bust:SetProperty("Image", nPic)
		end
		
		if nStayTime > 0 then
			SetTimer("StoryBustTips","StoryBustTips_OnHiden()", nStayTime)
		end
		if nIsCanClose == 1 then
			StoryBustTips_Close:Show()
		else
			StoryBustTips_Close:Hide()
		end
		this:Show()
		if Get_XParam_INT(3) == 89331103 then
			PushEvent("UI_COMMAND",89331103,Get_XParam_STR(3))
		end		
		if Get_XParam_INT(3) == 189331105 then
			PushEvent("UI_COMMAND",189331105,2)
		end		
		return

	end	
	
	if event == "NPCTALK_TIMEOUT" then
		StoryBustTips_OnHiden()
	end	

	if ( event == "ON_SCENE_TRANS" or event == "ON_SERVER_TRANS") then
		-- Talk:SetNpcTalkTime(0)
		StoryBustTips_OnHiden()
	end
	
	if( (event == "UNIT_FACE_IMAGE") and (arg0 == "player") ) then
		-- local nName,nTips,nPic,nStayTime,nIsCanClose,nIsSelf = Talk:GetNpcTalk(g_StoryBustTips_Npcid)
		-- if nIsSelf == 1 then
		-- 	local strFaceImage = Player:GetData( "PORTRAIT" );		
		-- 	local IconFile = GetIconFullName(tostring(strFaceImage))
		-- 	StoryBustTips_Bust:SetProperty("Image", tostring(IconFile))
		-- end
	end
end
--=========
--Show UI
--=========
function StoryBustTips_Show()
	

end

--=========
--OnClose "X"
--=========
function StoryBustTips_OnCloseClicked()
	this:Hide()
end
--=========
--handle Hide Event
--=========
function StoryBustTips_OnHiden()
	this:Hide()
	KillTimer("StoryBustTips_OnHiden()")
end

function StoryBustTips_On_ResetPos()
	StoryBustTips_Frame:SetProperty("UnifiedPosition", g_Frame_UnifiedPosition)
end