local g_QinHuangTime3_Data = {}
local g_QinHuangTime3_Scene = 0
local g_QinHuangTime3_UnifiedPosition;
local g_QinHuangTime3_UI = {}
local g_QinHuangTime3_select = -1
local g_QinHuangTime3_Pos = 
{
	[0] = {x = 190,z=190},
	[1] = {x = 53.2,z=58.2},
	[2] = {x = 97.5,z=44.7},
	[3] = {x = 170,z=30},
	[4] = {x = 214,z=69},
	[5] = {x = 77,z =110},
	[6] = {x = 135,z=101},
	[7] = {x = 208,z=119},
	[8] = {x = 127,z=157},
	[9] = {x = 54,z=202},
	[10] = {x = 130,z=203.5},

}
local g_QinHuangTime3_Name = 
{
	[1] = "#{MJXZ_210510_34}",
	[2] = "#{MJXZ_210510_107}",
	[3] = "#{MJXZ_210510_108}",
	[4] = "#{MJXZ_210510_109}",
	[5] = "#{MJXZ_210510_110}",
	[6] = "#{MJXZ_210510_111}",
	[7] = "#{MJXZ_210510_112}",
	[8] = "#{MJXZ_210510_113}",
	[9] = "#{MJXZ_210510_114}",
	[10] = "#{MJXZ_210510_115}",
}
function QinHuangTime3_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	--离开场景，自动关闭
	this:RegisterEvent("PLAYER_LEAVE_WORLD", false)	
	this:RegisterEvent("QIHUANTIME_SWITCH")
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")		
end
--界面21点50到24点显示
function QinHuangTime3_OnLoad()	
	g_QinHuangTime3_Data[1] = {title = "#{MJXZ_210510_09}",board="#{MJXZ_210510_10}",msg="#{MJXZ_210510_11}"}
	g_QinHuangTime3_Data[2] = {title = "#{MJXZ_210510_18}",board="#{MJXZ_210510_19}",msg="#{MJXZ_210510_20}"}
	g_QinHuangTime3_Data[3] = {title = "#{MJXZ_210510_21}",board="#{MJXZ_210510_22}",msg="#{MJXZ_210510_23}"}
	g_QinHuangTime3_Data[4] = {title = "#{MJXZ_210510_26}",board="#{MJXZ_210510_27}",msg="#{MJXZ_210510_28}"}

	g_QinHuangTime3_UI[1] = {name = QinHuangTime3_DiJiang1Ent,info = QinHuangTime3_DiJiang1Ent2}
	g_QinHuangTime3_UI[2] = {name = QinHuangTime3_DiJiang2Ent,info = QinHuangTime3_DiJiang2Ent2}
	g_QinHuangTime3_UI[3] = {name = QinHuangTime3_DiJiang3Ent,info = QinHuangTime3_DiJiang3Ent2}
	g_QinHuangTime3_UI[4] = {name = QinHuangTime3_DiJiang4Ent,info = QinHuangTime3_DiJiang4Ent2}
	g_QinHuangTime3_UI[5] = {name = QinHuangTime3_DiJiang5Ent,info = QinHuangTime3_DiJiang5Ent2}
	g_QinHuangTime3_UI[6] = {name = QinHuangTime3_DiJiang6Ent,info = QinHuangTime3_DiJiang6Ent2}
	g_QinHuangTime3_UI[7] = {name = QinHuangTime3_DiJiang7Ent,info = QinHuangTime3_DiJiang7Ent2}
	g_QinHuangTime3_UI[8] = {name = QinHuangTime3_DiJiang8Ent,info = QinHuangTime3_DiJiang8Ent2}
	g_QinHuangTime3_UI[9] = {name = QinHuangTime3_DiJiang9Ent,info = QinHuangTime3_DiJiang9Ent2}
	g_QinHuangTime3_UI[10] = {name = QinHuangTime3_DiJiang10Ent,info = QinHuangTime3_DiJiang10Ent2}

	g_QinHuangTime3_UnifiedPosition  =QinHuangTime3:GetProperty("UnifiedPosition");
end

function QinHuangTime3_OnEvent(event)

	if event == "UI_COMMAND" and tonumber(arg0) == 20210519 then
		local sceneId =  Get_XParam_INT( 0 );
		local info = {}
		for i = 0, 11 do
			data = Get_XParam_INT(i+1)
			info[i+1] = { calltime = math.floor(data/1000),difftime =math.mod(data,1000) }
		end
		

		--PushDebugMessage("ssss="..sceneId)		


		if sceneId == 203 then

			QinHuangTime3_InitFrame(4,info)
			if IsWindowShow("QinHuangTime_Mini") == false then
				this:Show()
			end
		else
			this:Hide()
		end

		g_QinHuangTime3_Scene = sceneId
	elseif event == "UI_COMMAND" and tonumber(arg0) == 20210510 then
		--第四就直接关闭就完事了
		this:Hide()
	end

	if event == "QIHUANTIME_SWITCH" then
		if tonumber(arg0) == 203 then
			this:Show()
		else
			this:Hide()
		end
	end

			-- 游戏窗口尺寸发生了变化
		if (event == "ADJEST_UI_POS" ) then
			QinHuangTime3_On_ResetPos()
		-- 游戏分辨率发生了变化
		elseif (event == "VIEW_RESOLUTION_CHANGED") then
			QinHuangTime3_On_ResetPos()
		elseif (event == "PLAYER_LEAVE_WORLD") then
			this:Hide()
		end	
end

function QinHuangTime3_On_ResetPos()
	QinHuangTime3:SetProperty("UnifiedPosition", g_QinHuangTime3_UnifiedPosition);
end

function QinHuangTime3_InitFrame(index,info)


	local strInfo = g_QinHuangTime3_Data[index];
	if strInfo then
		if g_QinHuangTime3_select < 0 then
			QinHuangTime3_DiHunEntBtn:SetCheck(1)
		end
		--local pos = QinHuangTime3_DiJiangEntLace:GetScrollPosition()
		--QinHuangTime3_DiJiangEntLace:Clear()
		QinHuangTime3_DragTitle:SetText(strInfo.title)
		QinHuangTime3_Text:SetText(strInfo.board)
		QinHuangTime3_Pair_Title1:SetText(strInfo.msg)
		local left = 1-info[1].calltime
		if info[1].calltime >= 1 then
			QinHuangTime3_DiHunEnt2:SetText("#{MJXZ_210510_33}")
		else
			if info[1].difftime >= 600 then

				QinHuangTime3_DiHunEnt2:SetText(ScriptGlobal_Format("#{MJXZ_210510_30}",left))
			else
				info[1].difftime = 600 - info[1].difftime
				local min = math.floor(info[1].difftime/60)
				local sec = math.mod(info[1].difftime,60)
				local str = ScriptGlobal_Format("#{MJXZ_210510_31}",min,sec)
				QinHuangTime3_DiHunEnt2:SetText(str..ScriptGlobal_Format("#{MJXZ_210510_32}",left))
			end
		end

		for i = 1,10 do
			QinHuangTime3_InsertData(i,info[i+1])
		end
		--QinHuangTime3_DiJiangEntLace:SetScrollPosition(pos)

		
		local sec = Lua_GetDiffTime_InSecond_ServerTime(23,59,0)
		QinHuangTime3_Time:SetProperty("TextColor","FB00FF00")
		QinHuangTime3_Time:SetProperty("Timer",sec)
	end
end


function QinHuangTime3_InsertData(index,info)
	-- if index == 8 then
	-- 	PushDebugMessage("info.calltime="..info.calltime..",info.difftime="..info.difftime)
	-- end

	local text = ""
	local left = 2-info.calltime
	if info.calltime >= 2 then
		text ="#{MJXZ_210510_38}"
	else
		if info.difftime >= 600 then
			text =ScriptGlobal_Format("#{MJXZ_210510_35}", left)
		else
			info.difftime = 600 - info.difftime
			local min = math.floor(info.difftime/60)
			local sec = math.mod(info.difftime,60)
			local str = ScriptGlobal_Format("#{MJXZ_210510_36}",min,sec)
			text =str
		end
	end
	g_QinHuangTime3_UI[index].name:SetText(g_QinHuangTime3_Name[index])
	g_QinHuangTime3_UI[index].info:SetText(text)



end

function QinHuangTime3_OpenMini()
	PushEvent("QIHUANTIME_SWITCH",0,g_QinHuangTime3_Scene)
end

function QinHuangTime3_Goto()
	g_QinHuangTime3_select = 0
end

function QinHuangTime3_GotoJitan()

	if g_QinHuangTime3_Pos[g_QinHuangTime3_select] ~= nil then
		AutoRunToTarget( g_QinHuangTime3_Pos[g_QinHuangTime3_select].x, g_QinHuangTime3_Pos[g_QinHuangTime3_select].z )
	end
end


function QinHuangTime3_Click(index)
	g_QinHuangTime3_select = index

end