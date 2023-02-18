local g_ZLHeroMeeting_Manifesto_Frame_UnifiedYPosition;
local g_ZLHeroMeeting_Manifesto_Frame_UnifiedYPosition;   
local g_ZLHeroMeeting_Manifesto_TargetID = -1; 
local g_ZLHeroMeeting_Manifesto_NPCID = -1;  
local g_ZLHeroMeeting_Manifesto_TextMaxSendSize = 24
function ZLHeroMeeting_Manifesto_PreLoad()
	this:RegisterEvent("UI_COMMAND");
		-- ��Ϸ���ڳߴ緢���˱仯
	this:RegisterEvent("ADJEST_UI_POS")
	-- ��Ϸ�ֱ��ʷ����˱仯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED") 
    this:RegisterEvent("OBJECT_CARED_EVENT")  
    this:RegisterEvent("OPEN_ZLHERO_XUANYAN")  
    
end

function ZLHeroMeeting_Manifesto_OnEvent(event) 
	if( event == "ADJEST_UI_POS" ) then
		ZLHeroMeeting_Manifesto_ResetPos()
	elseif( event == "VIEW_RESOLUTION_CHANGED" ) then
		ZLHeroMeeting_Manifesto_ResetPos()
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		ZLHeroMeeting_Manifesto_Close()    
	elseif event == "PLAYER_LEAVE_WORLD" then
		ZLHeroMeeting_Manifesto_Close()
    elseif (event == "OBJECT_CARED_EVENT") then
		if(tonumber(arg0) ~= g_ZLHeroMeeting_Manifesto_NPCID) then
			return;
		end 
		--�����NPC�ľ������һ��������߱�ɾ�����Զ��ر�
		if arg1 == "distance" and tonumber(arg2) > MAX_OBJ_DISTANCE or arg1=="destroy" then
			ZLHeroMeeting_Manifesto_Close()
		end
    elseif( event == "OPEN_ZLHERO_XUANYAN" ) then 
        ZLHeroMeeting_Manifesto_OnShown()
    elseif ( event == "UI_COMMAND" and tonumber( arg0 ) == 89111907) then	
        ZLHeroMeeting_Manifesto_OnShown() 
	elseif ( event == "UI_COMMAND" and tonumber( arg0 ) == 89111908 ) then
        ZLHeroMeeting_Manifesto_Close()
    
	end
end

function ZLHeroMeeting_Manifesto_OnLoad()  
	-- ��������Ĭ�����λ��
	g_ZLHeroMeeting_Manifesto_Frame_UnifiedXPosition	= ZLHeroMeeting_Manifesto_Frame:GetProperty("UnifiedXPosition");
    g_ZLHeroMeeting_Manifesto_Frame_UnifiedYPosition	= ZLHeroMeeting_Manifesto_Frame:GetProperty("UnifiedYPosition");  
end 

function ZLHeroMeeting_Manifesto_OnShown()  
    ZLHeroMeeting_Manifesto_Update()
	this:Show();
end 

function ZLHeroMeeting_Manifesto_Update()    
    g_ZLHeroMeeting_Manifesto_TargetID = Get_XParam_INT(0)
	g_ZLHeroMeeting_Manifesto_NPCID = DataPool : GetNPCIDByServerID(g_ZLHeroMeeting_Manifesto_TargetID)
	if g_AwardNpcId == -1 then
		ZLHeroMeeting_Manifesto_Close()
		return
	end 
	ZLHeroMeeting_Manifesto_EditInfo:SetText("")
	ZLHeroMeeting_Manifesto_EditInfo:SetProperty("DefaultEditBox", "True");
	this : CareObject( g_ZLHeroMeeting_Manifesto_NPCID, 1, "ZLHeroMeeting_Manifesto" )
    
	ZLHeroMeeting_Manifesto_Info1:SetText(ScriptGlobal_Format("#{YXDHGN_210222_120}","0", g_ZLHeroMeeting_Manifesto_TextMaxSendSize))
	
	ZLHeroMeeting_Manifesto_EditInfo:SetProperty("MaxTextLength", g_ZLHeroMeeting_Manifesto_TextMaxSendSize);
end 
--================================================
-- �����Ĭ�����λ��
--================================================
function ZLHeroMeeting_Manifesto_ResetPos()
	ZLHeroMeeting_Manifesto_Frame:SetProperty("UnifiedXPosition", g_ZLHeroMeeting_ManifestoFrame_UnifiedXPosition);
	ZLHeroMeeting_Manifesto_Frame:SetProperty("UnifiedYPosition", g_ZLHeroMeeting_Manifesto_Frame_UnifiedYPosition); 
end 

function ZLHeroMeeting_Manifesto_OnHiden()
    ZLHeroMeeting_Manifesto_Close();
end
function ZLHeroMeeting_Manifesto_Close() 
    this:CareObject(g_ZLHeroMeeting_Manifesto_NPCID, 0, "ZLHeroMeeting_Manifesto")
	g_ZLHeroMeeting_Manifesto_NPCID = -1
	ZLHeroMeeting_Manifesto_EditInfo:SetProperty("DefaultEditBox", "False");
	this:Hide();
end
 

function ZLHeroMeeting_Manifesto_XuanYan()    
	local text = ZLHeroMeeting_Manifesto_EditInfo:GetText();  
	local text = ZLHeroMeeting_Manifesto_EditInfo:GetText(); 
	local nlen = string.len(text)
	if nlen <= 0 then
		PushDebugMessage("#{YXDHGN_210222_129}")
		return
	end
	if  nlen > g_ZLHeroMeeting_Manifesto_TextMaxSendSize then
		PushDebugMessage("#{YXDHGN_210222_130}")
		return
	end 
    HeroCompetChangeXuanYan(text, g_ZLHeroMeeting_Manifesto_TargetID)
end

function ZLHeroMeeting_ChangeMessage()
    local text = ZLHeroMeeting_Manifesto_EditInfo:GetText(); 
	local nlen = string.len(text)
    ZLHeroMeeting_Manifesto_Info1:SetText(ScriptGlobal_Format("#{YXDHGN_210222_120}",nlen, g_ZLHeroMeeting_Manifesto_TextMaxSendSize)) 
end

function ZLHeroMeeting_Manifesto_Cancel_Clicked()
    ZLHeroMeeting_Manifesto_Info1:SetText(ScriptGlobal_Format("#{YXDHGN_210222_120}","0", g_ZLHeroMeeting_Manifesto_TextMaxSendSize))
    ZLHeroMeeting_Manifesto_EditInfo:SetText(""); 
    ZLHeroMeeting_Manifesto_Close()
end

function ZLHeroMeeting_Manifesto_OK_Clicked()
    ZLHeroMeeting_Manifesto_XuanYan()
end