--报名
local g_ZLHeroMeeting_Join_Frame_UnifiedYPosition;
local g_ZLHeroMeeting_Join_Frame_UnifiedYPosition;   
local g_ZLHeroMeeting_Join_TargetID = -1; 
local g_ZLHeroMeeting_Join_NPCID = -1; 
local g_ZLHeroMeeting_Join_Min =  200; 
local g_ZLHeroMeeting_Join_listitem = {}
local g_ZLHeroMeeting_Join_MenPaiList = {
	[0] = "#{GMGameInterface_Script_DataPool_Info_ShaoLin}",    --少林
	[1] = "#{GMGameInterface_Script_DataPool_Info_Mingjiao}",    --明教
	[2] = "#{GMGameInterface_Script_DataPool_Info_GaiBang}",    --丐帮
	[3] = "#{GMGameInterface_Script_DataPool_Info_WuDang}",    --武当
	[4] = "#{GMGameInterface_Script_DataPool_Info_EMei}",    --峨眉
	[5] = "#{GMGameInterface_Script_DataPool_Info_XingXiu}",    --星宿
	[6] = "#{GMGameInterface_Script_DataPool_Info_DaLi}",    --天龙
	[7] = "#{GMGameInterface_Script_DataPool_Info_TianShan}",    --天山
	[8] = "#{GMGameInterface_Script_DataPool_Info_XiaoYao}" ,    --逍遥
	[9] = "#{GMGameInterface_Script_DataPool_Info_WuMenPai}"     --无门派
}

function ZLHeroMeeting_Join_PreLoad()
	this:RegisterEvent("UI_COMMAND");
		-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED") 
	this:RegisterEvent("OBJECT_CARED_EVENT") 
	this:RegisterEvent("UPDATE_DOUBLE_EXP") 
end

function ZLHeroMeeting_Join_OnEvent(event) 
	if( event == "ADJEST_UI_POS" ) then
		ZLHeroMeeting_Join_ResetPos()
	elseif( event == "VIEW_RESOLUTION_CHANGED" ) then
		ZLHeroMeeting_Join_ResetPos()
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		ZLHeroMeeting_Join_OnClose()    
	elseif event == "PLAYER_LEAVE_WORLD" then
		ZLHeroMeeting_Join_OnClose()
    elseif (event == "OBJECT_CARED_EVENT") then
		if(tonumber(arg0) ~= g_ZLHeroMeeting_Join_NPCID) then
			return;
		end 
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if arg1 == "distance" and tonumber(arg2) > MAX_OBJ_DISTANCE or arg1=="destroy" then
			ZLHeroMeeting_Join_OnClose()
		end
    elseif ( event == "UI_COMMAND" and tonumber( arg0 ) == 89111904) then	
        ZLHeroMeeting_Join_OnShown()
	elseif ( event == "UI_COMMAND" and tonumber( arg0 ) == 89111905 ) then
        ZLHeroMeeting_Join_Update()
	elseif ( event == "UI_COMMAND" and tonumber( arg0 ) == 89111906 ) then
        ZLHeroMeeting_Join_OnClose()
    
	end
end

function ZLHeroMeeting_Join_OnLoad()  
	-- 保存界面的默认相对位置
	g_ZLHeroMeeting_Join_Frame_UnifiedXPosition	= ZLHeroMeeting_Join_Frame:GetProperty("UnifiedXPosition");
    g_ZLHeroMeeting_Join_Frame_UnifiedYPosition	= ZLHeroMeeting_Join_Frame:GetProperty("UnifiedYPosition"); 
    ZLHeroMeeting_Join_List:Clear();   
end 

function ZLHeroMeeting_Join_OnShown()  
    ZLHeroMeeting_Join_Update()
	this:Show();
end 

function ZLHeroMeeting_Join_Update()    
    g_ZLHeroMeeting_Join_TargetID = Get_XParam_INT(0)
    local  g_ZLHeroMeeting_Join_yxz = Get_XParam_INT(1)
	g_ZLHeroMeeting_Join_NPCID = DataPool : GetNPCIDByServerID(g_ZLHeroMeeting_Join_TargetID)
	if g_AwardNpcId == -1 then
		ZLHeroMeeting_Join_OnClose()
		return
	end 
	this : CareObject( g_ZLHeroMeeting_Join_NPCID, 1, "ZLHeroMeeting_Join" )

    for i = 1, table.getn(g_ZLHeroMeeting_Join_listitem) do
		if g_ZLHeroMeeting_Join_listitem[i] ~= nil then
			g_ZLHeroMeeting_Join_listitem[i] = nil
		end
    end
    
	ZLHeroMeeting_Join_List:Clear()
	--ZLHeroMeeting_Join_Join:Hide()
	if g_ZLHeroMeeting_Join_yxz >= g_ZLHeroMeeting_Join_Min then
		ZLHeroMeeting_Join_Tenet_Text:SetText(ScriptGlobal_Format("#{YXDHGN_210222_48}", g_ZLHeroMeeting_Join_yxz)) 
	else
		ZLHeroMeeting_Join_Tenet_Text:SetText(ScriptGlobal_Format("#{YXDHGN_210222_49}", g_ZLHeroMeeting_Join_yxz)) 
	end
	 
	local nCount = GetHeroCompetCount()
	local tblinfo= GetHeroCompetData()
	
	if nCount == 0 then
		ZLHeroMeeting_Join_Info0:Show()
	else		
		ZLHeroMeeting_Join_Info0:Hide()
	end

	if type(tblinfo) ~= "table" and nCount ~= 0 then
		PushDebugMessage("error")
		return
	end 
	for i = 1, nCount do
		--第一列
		local bar1 = ZLHeroMeeting_Join_List:AddChild("ZLHeroMeeting_Join_ListItem1")
		if not bar1 then
    	   break
        end
        local guid 	= tblinfo[i].guid
		local name 	= tblinfo[i].name
		local level = tblinfo[i].level
		local menpai= tblinfo[i].menpai
		local mood  = tblinfo[i].mood
		local portrait = tblinfo[i].portrait
		local yxz   = tblinfo[i].yxz
		local piaoshu = tblinfo[i].piaoshu

		bar1:GetSubItem("ZLHeroMeeting_Join_ListItem1_Rank"):SetText("#G"..i)
		bar1:GetSubItem("ZLHeroMeeting_Join_ListItem1_Name"):SetText("#G"..name)
		bar1:GetSubItem("ZLHeroMeeting_Join_ListItem1_Level"):SetText("#G"..level)
		bar1:GetSubItem("ZLHeroMeeting_Join_ListItem1_Menpai"):SetText("#G"..g_ZLHeroMeeting_Join_MenPaiList[menpai])
		bar1:GetSubItem("ZLHeroMeeting_Join_ListItem1_Count"):SetText("#G"..yxz) 
		g_ZLHeroMeeting_Join_listitem[i] = bar1
	end
	
end 
--================================================
-- 界面的默认相对位置
--================================================
function ZLHeroMeeting_Join_ResetPos()
	ZLHeroMeeting_Join_Frame:SetProperty("UnifiedXPosition", g_ZLHeroMeeting_JoinFrame_UnifiedXPosition);
	ZLHeroMeeting_Join_Frame:SetProperty("UnifiedYPosition", g_ZLHeroMeeting_Join_Frame_UnifiedYPosition); 
end 

function ZLHeroMeeting_join_OnHiden()
    ZLHeroMeeting_Join_OnClose();
end
function ZLHeroMeeting_Join_OnClose() 
    this:CareObject(g_ZLHeroMeeting_Join_NPCID, 0, "ZLHeroMeeting_Join")
	g_ZLHeroMeeting_Join_NPCID 		= -1
	g_ZLHeroMeeting_Join_TargetID 	= -1
	this:Hide();
end
 

function ZLHeroMeeting_Join_Click()    
	Clear_XSCRIPT()
	Set_XSCRIPT_Function_Name("Apply")
	Set_XSCRIPT_ScriptID(891119) 
    Set_XSCRIPT_Parameter( 0, g_ZLHeroMeeting_Join_TargetID ); -- 参数一 
	Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
 

end