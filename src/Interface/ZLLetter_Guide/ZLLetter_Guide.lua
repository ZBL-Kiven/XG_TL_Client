
--//2021剧情任务-ypl

local g_ZLLetter_Guide_Frame_UnifiedPosition

local g_ZLLetter_Guide_num1 = 0
local g_ZLLetter_Guide_num2 = 0

local g_ZLLetter_Guide_Info = {
	[0]={name="#{YXDHYD_20210207_81}", posx=160, posz=157, sceneid=2, npc="赵天师"},
	[1]={name="#{YXDHYD_20210207_82}", posx=160, posz=157, sceneid=2, npc="赵天师"},
	[2]={name="#{YXDHYD_20210207_83}", posx=129, posz=107, sceneid=1, npc="沈夜雨"},
	[3]={name="#{YXDHYD_20210207_84}", posx=129, posz=107, sceneid=1, npc="沈夜雨"},
	[4]={name="#{YXDHYD_20210207_85}", posx=129, posz=107, sceneid=1, npc="沈夜雨"},
	[5]={name="#{YXDHYD_20210207_86}", posx=160, posz=157, sceneid=2, npc="赵天师"},
	[6]={name="#{YXDHYD_20210207_87}", posx=129, posz=107, sceneid=1, npc="沈夜雨"},
	[7]={name="#{YXDHYD_20210207_88}", posx=160, posz=157, sceneid=2, npc="赵天师"},
	[8]={name="#{YXDHYD_20210207_89}", posx=137, posz=180, sceneid=2, npc="武泽"},
	[9]={name="#{YXDHYD_20210207_90}", posx=137, posz=180, sceneid=2, npc="武泽"},
	[10]={name="#{YXDHYD_20210207_91}", posx=160, posz=157, sceneid=2, npc="赵天师"},
	[11]={name="#{YXDHYD_20210207_92}", posx=126, posz=96, sceneid=0, npc="蔡京"},
	[12]={name="#{YXDHYD_20210207_93}", posx=126, posz=96, sceneid=0, npc="蔡京"},
	[13]={name="#{YXDHYD_20210207_94}", posx=193, posz=144, sceneid=1, npc="种师道"},
	[14]={name="#{YXDHYD_20210207_95}", posx=193, posz=144, sceneid=1, npc="种师道"},
	[15]={name="#{YXDHYD_20210207_96}", posx=193, posz=144, sceneid=1, npc="种师道"},
	[16]={name="#{YXDHYD_20210207_97}", posx=193, posz=144, sceneid=1, npc="种师道"},
}

function ZLLetter_Guide_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")	
	this:RegisterEvent("PLAYER_LEAVE_WORLD");		
end

function ZLLetter_Guide_OnLoad()
	g_ZLLetter_Guide_Frame_UnifiedPosition = ZLLetter_Guide_Frame:GetProperty("UnifiedPosition");
	g_ZLLetter_Guide_num1 = 0
	g_ZLLetter_Guide_num2 = 0
	ZLLetter_Guide_Info:SetText("")
	ZLLetter_Guide_Info:SetText("")
end

function ZLLetter_Guide_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == 8910803 ) then
		local param1 = Get_XParam_INT(0)
		local param2 = Get_XParam_INT(1)
		local param3 = Get_XParam_INT(2)
		local param4 = Get_XParam_INT(3)
		local HaveGetPrize = Get_XParam_INT(4)
		g_ZLLetter_Guide_num1 = Get_XParam_INT(5)
		g_ZLLetter_Guide_num2 = Get_XParam_INT(6)
		local openui = Get_XParam_INT(7)
		if openui == 0 then
			if not this:IsVisible() then
				return
			end
		end
		if param1 == 1 then
			ZLLetter_Guide_Letter1_Image:Enable()
		else
			ZLLetter_Guide_Letter1_Image:Disable()
		end
		if param2 == 1 then
			ZLLetter_Guide_Letter2_Image:Enable()
		else
			ZLLetter_Guide_Letter2_Image:Disable()
		end
		if param3 == 1 then
			ZLLetter_Guide_Letter3_Image:Enable()
		else
			ZLLetter_Guide_Letter3_Image:Disable()
		end
		if param4 == 1 then
			ZLLetter_Guide_Letter4_Image:Enable()
		else
			ZLLetter_Guide_Letter4_Image:Disable()
		end
		if HaveGetPrize == 1 then
			ZLLetter_Guide_GotoBtn:SetText("#{YXDHYD_20210309_05}")
			ZLLetter_Guide_GotoBtn:Disable()
		elseif param1 == 1 and param2 == 1 and param3 == 1 and param4 == 1 then
			ZLLetter_Guide_GotoBtn:SetText("#{YXDHYD_20210309_04}")
			ZLLetter_Guide_GotoBtn:Enable()
		else
			ZLLetter_Guide_GotoBtn:SetText("#{YXDHYD_20210309_04}")
			ZLLetter_Guide_GotoBtn:Disable()
		end
		if g_ZLLetter_Guide_Info[g_ZLLetter_Guide_num1] ~= nil then
			ZLLetter_Guide_Info:SetText(ScriptGlobal_Format("#{YXDHYD_20210325_31}", g_ZLLetter_Guide_Info[g_ZLLetter_Guide_num1].name))
			if g_ZLLetter_Guide_num2 == 1 then
				ZLLetter_Guide_Goto:Hide()
				ZLLetter_Guide_Goto:Disable()
			else
				ZLLetter_Guide_Goto:Show()
				ZLLetter_Guide_Goto:Enable()			
			end			
		elseif g_ZLLetter_Guide_num1 == 17 then
			ZLLetter_Guide_Info:SetText("#{YXDHYD_20210325_42}")
			ZLLetter_Guide_Goto:Hide()
			ZLLetter_Guide_Goto:Disable()			
		end

		this:Show()
	-- 游戏窗口尺寸发生了变化
	elseif (event == "ADJEST_UI_POS" ) then
		ZLLetter_Guide_ResetPos()
	-- 游戏分辨率发生了变化
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		ZLLetter_Guide_ResetPos()	
	elseif (event == "PLAYER_LEAVE_WORLD" and this:IsVisible()) then
		this:Hide()		
	end
end

function ZLLetter_Guide_Clicked(index)
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OpenUI")
		Set_XSCRIPT_ScriptID(891080)
		Set_XSCRIPT_Parameter( 0, index )
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()	
end

function ZLLetter_Guide_Hide()
	this:Hide()
end

function ZLLetter_Guide_Frame_OnHiden()
	this:Hide()
end

--================================================
-- 恢复界面的默认相对位置
--================================================
function ZLLetter_Guide_ResetPos()
  ZLLetter_Guide_Frame:SetProperty("UnifiedPosition", g_ZLLetter_Guide_Frame_UnifiedPosition);
end

function ZLLetter_Guide_NewClicked()

	local info = g_ZLLetter_Guide_Info[g_ZLLetter_Guide_num1]
	if info ~= nil then
		AutoRuntoTargetExWithName(info.posx, info.posz, info.sceneid, info.npc)
	end	

end