local g_ZLHeroMeeting_Vote_Frame_UnifiedYPosition;
local g_ZLHeroMeeting_Vote_Frame_UnifiedYPosition;   
local g_ZLHeroMeeting_Vote_TargetID = -1; 
local g_ZLHeroMeeting_Vote_NPCID = -1;  
local g_ZLHeroMeeting_Vote_Selidx = -1;
local g_ZLHeroMeeting_Vote_Selguid = -1;
local g_ZLHeroMeeting_Vote_MenPaiList = {
	[0] = "#{GMGameInterface_Script_DataPool_Info_ShaoLin}",    --少林
	[1] = "#{GMGameInterface_Script_DataPool_Info_Mingjiao}",    --明教
	[2] = "#{GMGameInterface_Script_DataPool_Info_GaiBang}",    --丐帮
	[3] = "#{GMGameInterface_Script_DataPool_Info_WuDang}",    --武当
	[4] = "#{GMGameInterface_Script_DataPool_Info_EMei}",    --峨眉
	[5] = "#{GMGameInterface_Script_DataPool_Info_XingXiu}",    --星宿
	[6] = "#{GMGameInterface_Script_DataPool_Info_DaLi}",    --天龙
	[7] = "#{GMGameInterface_Script_DataPool_Info_TianShan}",    --天山
	[8] = "#{GMGameInterface_Script_DataPool_Info_XiaoYao}",     --逍遥
	[9] = "#{GMGameInterface_Script_DataPool_Info_WuMenPai}"     --无门派
}
local g_ZLHeroMeetingCDTime  = 1
local g_ZLHeroMeetingLastClickTime_Refresh = 0 
local g_ZLHeroMeetingLastClickTime_Update = 0

function ZLHeroMeeting_Vote_PreLoad()
	this:RegisterEvent("UI_COMMAND");
		-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED") 
	this:RegisterEvent("OBJECT_CARED_EVENT") 
	this:RegisterEvent("HEROCOMPET_UPDATE") 
end

function ZLHeroMeeting_Vote_OnEvent(event) 
	if( event == "ADJEST_UI_POS" ) then
		ZLHeroMeeting_Vote_ResetPos()
	elseif( event == "VIEW_RESOLUTION_CHANGED" ) then
		ZLHeroMeeting_Vote_ResetPos()
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		ZLHeroMeeting_Vote_Close()    
	elseif event == "PLAYER_LEAVE_WORLD" then
		ZLHeroMeeting_Vote_Close()
    elseif (event == "OBJECT_CARED_EVENT") then
		if(tonumber(arg0) ~= g_ZLHeroMeeting_Vote_NPCID) then
			return;
		end 
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if arg1 == "distance" and tonumber(arg2) > MAX_OBJ_DISTANCE or arg1=="destroy" then
			ZLHeroMeeting_Vote_Close()
		end
    elseif ( event == "UI_COMMAND" and tonumber( arg0 ) == 89111909) then	
        ZLHeroMeeting_Vote_OnShown()
	elseif ( event == "UI_COMMAND" and tonumber( arg0 ) == 89111910 ) then
		ZLHeroMeeting_GetSelIdxForUpdate()
        ZLHeroMeeting_Vote_Update(1)
	elseif (event == "HEROCOMPET_UPDATE") then 
		if (true ~= this:IsVisible()) then
			return
		end
		ZLHeroMeeting_GetSelIdxForUpdate()
        ZLHeroMeeting_Vote_Update(0)
	elseif ( event == "UI_COMMAND" and tonumber( arg0 ) == 89111911 ) then
        ZLHeroMeeting_Vote_Close()
    
	end
end

function ZLHeroMeeting_Vote_OnLoad()  
	-- 保存界面的默认相对位置
	g_ZLHeroMeeting_Vote_Frame_UnifiedXPosition	= ZLHeroMeeting_Vote_Frame:GetProperty("UnifiedXPosition");
    g_ZLHeroMeeting_Vote_Frame_UnifiedYPosition	= ZLHeroMeeting_Vote_Frame:GetProperty("UnifiedYPosition"); 
   
end 

function ZLHeroMeeting_Vote_OnShown()   
	g_ZLHeroMeeting_Vote_Selidx = 1;
    ZLHeroMeeting_Vote_Update( 1 )
	this:Show();
end 

function ZLHeroMeeting_Vote_Update( ntargetid )    
	if ntargetid == 1 then
		g_ZLHeroMeeting_Vote_TargetID = Get_XParam_INT(0)
		g_ZLHeroMeeting_Vote_NPCID = DataPool : GetNPCIDByServerID(g_ZLHeroMeeting_Vote_TargetID)
		if g_AwardNpcId == -1 then
			ZLHeroMeeting_Vote_Close()
			return
		end 
	end
	this : CareObject( g_ZLHeroMeeting_Vote_NPCID, 1, "ZLHeroMeeting_Vote" )
 
 	local nCount = GetHeroCompetCount()
	local tblinfo= GetHeroCompetData()
	
	if type(tblinfo) ~= "table" and nCount ~= 0 then
		PushDebugMessage("error6")
		return
	end
	ZLHeroMeeting_Vote_List:RemoveAllItem();
	 
	for i = 1, nCount do 
		local guid 	= tblinfo[i].guid
		local name 	= tblinfo[i].name
		local level = tblinfo[i].level
		local menpai= tblinfo[i].menpai
		local mood  = tostring(tblinfo[i].mood) 
		local portrait = tblinfo[i].portrait
		local yxz   = tblinfo[i].yxz
		local piaoshu = tblinfo[i].piaoshu 

		ZLHeroMeeting_Vote_List:AddNewItem("#G"..i, 0, i-1);
		ZLHeroMeeting_Vote_List:AddNewItem("#G"..name, 1, i-1);
		ZLHeroMeeting_Vote_List:AddNewItem("#G"..level, 2, i-1);	
		ZLHeroMeeting_Vote_List:AddNewItem("#G"..g_ZLHeroMeeting_Vote_MenPaiList[menpai], 3, i-1);	
		ZLHeroMeeting_Vote_List:AddNewItem("#G"..yxz, 4, i-1);	 
	end
	ZLHeroMeeting_Vote_List:SetSelectItem(g_ZLHeroMeeting_Vote_Selidx-1)
	ZLHeroMeeting_Vote_Update_Right()   
end 

--================================================
-- 界面的默认相对位置
--================================================
function ZLHeroMeeting_Vote_ResetPos()
	ZLHeroMeeting_Vote_Frame:SetProperty("UnifiedXPosition", g_ZLHeroMeeting_VoteFrame_UnifiedXPosition);
	ZLHeroMeeting_Vote_Frame:SetProperty("UnifiedYPosition", g_ZLHeroMeeting_Vote_Frame_UnifiedYPosition); 
end 

function ZLHeroMeeting_Vote_OnHiden()
    ZLHeroMeeting_Vote_Close();
end
function ZLHeroMeeting_Vote_Close() 
    this:CareObject(g_ZLHeroMeeting_Vote_NPCID, 0, "ZLHeroMeeting_Vote")
	g_ZLHeroMeeting_Vote_NPCID = -1
	g_ZLHeroMeeting_Vote_Selguid = -1;
	g_ZLHeroMeeting_Vote_Selidx = -1;
	this:Hide();
end
 

function ZLHeroMeeting_Vote_Click()    
	local nCount = GetHeroCompetCount()
	local tblinfo= GetHeroCompetData()
	
	if type(tblinfo) ~= "table"  and nCount ~= 0 then
		PushDebugMessage("error7")
		return
	end

	if g_ZLHeroMeeting_Vote_Selidx > nCount or g_ZLHeroMeeting_Vote_Selidx <= 0 then
		PushDebugMessage("error8")
		return
	end  
	if tblinfo[g_ZLHeroMeeting_Vote_Selidx].guid == Player:GetGUID() then
		Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("XuanYan")
		Set_XSCRIPT_ScriptID(891119) 
		Set_XSCRIPT_Parameter( 0, g_ZLHeroMeeting_Vote_TargetID ); -- 参数一  
		Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT() 
	else
		Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("Vote")
		Set_XSCRIPT_ScriptID(891119) 
		Set_XSCRIPT_Parameter( 0, g_ZLHeroMeeting_Vote_TargetID ); -- 参数一
		Set_XSCRIPT_Parameter( 1, g_ZLHeroMeeting_Vote_Selidx-1 ); -- 参数二 
		Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT()
	end

end

function ZLHeroMeeting_Vote_RefreshClick()    
	local nCount = GetHeroCompetCount()
	local tblinfo= GetHeroCompetData()
	
	if type(tblinfo) ~= "table"  and nCount ~= 0 then
		PushDebugMessage("error1")
		return
	end

	if g_ZLHeroMeeting_Vote_Selidx > nCount or g_ZLHeroMeeting_Vote_Selidx <= 0 then
		PushDebugMessage("error2")
		return
	end  
	if tblinfo[g_ZLHeroMeeting_Vote_Selidx].guid == Player:GetGUID() then
		local curTime = OSAPI:GetTickCount()
		if ( curTime - g_ZLHeroMeetingLastClickTime_Update < g_ZLHeroMeetingCDTime * 1000) then 
			PushDebugMessage("#{YXDHGN_210222_89}")
			return
		end
		g_ZLHeroMeetingLastClickTime_Update = curTime
		Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("UpdateInfo")
		Set_XSCRIPT_ScriptID(891119) 
		Set_XSCRIPT_Parameter( 0, g_ZLHeroMeeting_Vote_TargetID ); -- 参数一 
		Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
	else
		local curTime = OSAPI:GetTickCount()
		if ( curTime - g_ZLHeroMeetingLastClickTime_Refresh < g_ZLHeroMeetingCDTime * 1000) then 
			PushDebugMessage("#{YXDHGN_210222_89}")
			return
		end
		g_ZLHeroMeetingLastClickTime_Refresh = curTime

		Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("FreshClientData")
		Set_XSCRIPT_ScriptID(891119) 
		Set_XSCRIPT_Parameter( 0, g_ZLHeroMeeting_Vote_TargetID ); -- 参数一 
		Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
	end
end

function ZLHeroMeeting_Vote_SelectChanged() 
	local idx = ZLHeroMeeting_Vote_List:GetSelectItem();  
	if(idx == -1)  then
		return;
	end 
	if g_ZLHeroMeeting_Vote_Selidx ~= idx + 1 then
		g_ZLHeroMeeting_Vote_Selidx = idx+1;
		ZLHeroMeeting_Vote_Update_Right()
	end
end

function ZLHeroMeeting_Vote_Update_Right()
	local nCount = GetHeroCompetCount()
	local tblinfo= GetHeroCompetData()

	if nCount == 0  then
		ZLHeroMeeting_Vote_Icon:Hide()
		ZLHeroMeeting_Vote_Tenet_Text1:Hide()
		ZLHeroMeeting_Vote_Tenet_Text2:Hide()
		ZLHeroMeeting_Vote_Tenet_Text3:Hide()
		ZLHeroMeeting_Vote_Vote:Hide() 
		ZLHeroMeeting_Vote_Info0:Show()
		ZLHeroMeeting_Vote_F5:Hide()
		return
	else
		ZLHeroMeeting_Vote_Icon:Show()
		ZLHeroMeeting_Vote_Tenet_Text1:Show()
		ZLHeroMeeting_Vote_Tenet_Text2:Show()
		ZLHeroMeeting_Vote_Tenet_Text3:Show() 
		ZLHeroMeeting_Vote_Tenet_Text1:SetText("")
		ZLHeroMeeting_Vote_Tenet_Text2:SetText("")
		ZLHeroMeeting_Vote_Tenet_Text3:SetText("") 
		ZLHeroMeeting_Vote_Info0:Hide()
	end 
	
	if type(tblinfo) ~= "table" and nCount ~= 0 then
		PushDebugMessage("error3")
		return
	end

	if g_ZLHeroMeeting_Vote_Selidx > nCount or g_ZLHeroMeeting_Vote_Selidx <= 0 then
		PushDebugMessage("error4")
		return
	end
	
	ZLHeroMeeting_Vote_Tenet_Text1:SetText(ScriptGlobal_Format("#{YXDHGN_210222_84}",tblinfo[g_ZLHeroMeeting_Vote_Selidx].name))
	ZLHeroMeeting_Vote_Tenet_Text2:SetText(ScriptGlobal_Format("#{YXDHGN_210222_85}",tblinfo[g_ZLHeroMeeting_Vote_Selidx].yxz))
	local mood = tostring(tblinfo[g_ZLHeroMeeting_Vote_Selidx].mood)   
	if tblinfo[g_ZLHeroMeeting_Vote_Selidx].moodsize == 0 then
		mood = "#{YXDHGN_210222_87}"
	end 
	ZLHeroMeeting_Vote_Tenet_Text3:SetText(ScriptGlobal_Format("#{YXDHGN_210222_86}", mood)) 
	
	local strFaceImage = DataPool:GetPortraitByID(tblinfo[g_ZLHeroMeeting_Vote_Selidx].portrait);
	ZLHeroMeeting_Vote_Icon:SetProperty("Image", tostring(strFaceImage));

	if tblinfo[g_ZLHeroMeeting_Vote_Selidx].guid == Player:GetGUID() then
		ZLHeroMeeting_Vote_F5:SetText("#{YXDHGN_210222_94}")
		ZLHeroMeeting_Vote_Vote:SetText("#{YXDHGN_210222_93}")
		ZLHeroMeeting_Vote_Vote:Show()
		ZLHeroMeeting_Vote_F5:Show()
	else
		ZLHeroMeeting_Vote_F5:SetText("#{YXDHGN_210222_88}")
		ZLHeroMeeting_Vote_Vote:SetText("#{YXDHGN_210222_91}")
		ZLHeroMeeting_Vote_Vote:Show()
		ZLHeroMeeting_Vote_F5:Show()
	end
	g_ZLHeroMeeting_Vote_Selguid = tblinfo[g_ZLHeroMeeting_Vote_Selidx].guid;
end

function ZLHeroMeeting_GetSelIdxForUpdate()
	local nCount = GetHeroCompetCount()
	local tblinfo= GetHeroCompetData()
	
	if type(tblinfo) ~= "table" and nCount ~= 0 then
		PushDebugMessage("error5")
		return
	end

	for i = 1, nCount do  
		local guid 	= tblinfo[i].guid
		local name 	= tblinfo[i].name
		local level = tblinfo[i].level
		local menpai= tblinfo[i].menpai
		local mood  = tblinfo[i].mood
		local portrait = tblinfo[i].portrait
		local yxz   = tblinfo[i].yxz
		local piaoshu = tblinfo[i].piaoshu 
		if g_ZLHeroMeeting_Vote_Selguid ~= -1 and g_ZLHeroMeeting_Vote_Selidx >= 1 and g_ZLHeroMeeting_Vote_Selguid == guid then
			g_ZLHeroMeeting_Vote_Selidx = i
			return
		end
	end
	g_ZLHeroMeeting_Vote_Selidx = 1;
end
 