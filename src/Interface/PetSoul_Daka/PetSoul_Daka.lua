local g_PetSoul_Daka_Frame_UnifiedPosition	= nil 

local g_PetSoul_Daka_Tick_Time				= 0.5		-- 定时器时间(秒)
local g_PetSoul_Daka_ReadyTime				= 5			-- 等待时间
local g_PetSoul_Daka_AnswerTime				= 7.5		-- 答题时间
local g_PetSoul_Daka_QuestionTime			= 7.5		-- 题目时间
local g_PetSoul_Daka_ResultTime				= 8			-- 结果显示时间
local g_PetSoul_Daka_QuestionMax			= 16		-- 最多16道题

local g_PetSoul_Daka_Tick_Logic				= 0			-- 计时
local g_PetSoul_Daka_Status					= 0			-- 状态
local g_PetSoul_Daka_Tick_Logic_End			= 0			-- 结束tick
local g_PetSoul_Daka_Tick_Logic_TimeOut		= g_PetSoul_Daka_ReadyTime + g_PetSoul_Daka_AnswerTime	-- 超时
local g_PetSoul_Daka_Ani_Info				= string.format("curve:Liner mode:Once duration:%s startx:0 starty:0 endx:496 endy:0", g_PetSoul_Daka_AnswerTime)
local g_PetSoul_Daka_Ani_Pos				= nil		-- 滑块位置
local g_PetSoul_Daka_Subject				= ""
local g_PetSoul_Daka_Key					= ""
local g_PetSoul_Daka_CaredNpc				= -1		-- NpccareID
local g_PetSoul_Daka_MainScript				= 893089
local g_PetSoul_Daka_NpcIdx					= 1
local g_PetSoul_Daka_Icon					= {
	{head = "set:PetSoulDaka image:PetSoulDaka_TextBK_Hu", arrow = "set:PetSoulDaka image:PetSoulDaka_Hu",},
	{head = "set:PetSoulDaka image:PetSoulDaka_TextBK_Long", arrow = "set:PetSoulDaka image:PetSoulDaka_Long",},
	{head = "set:PetSoulDaka image:PetSoulDaka_TextBK_Xuanwu", arrow = "set:PetSoulDaka image:PetSoulDaka_Xuanwu",},
	{head = "set:PetSoulDaka image:PetSoulDaka_TextBK_Hu", arrow = "set:PetSoulDaka image:PetSoulDaka_Hu",},
}
local g_PetSoul_Daka_AnswerIcon = {
	normal = "set:PetSoulDaka image:PetSoulDaka_Level1",
	excellent = "set:PetSoulDaka image:PetSoulDaka_Level2",
	perfect = "set:PetSoulDaka image:PetSoulDaka_Level3",
	fail = "set:PetSoulDaka image:PetSoulDaka_Level0",
}

function PetSoul_Daka_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
end 

function PetSoul_Daka_OnLoad()
	g_PetSoul_Daka_Frame_UnifiedPosition = PetSoul_Daka_Blank:GetProperty("UnifiedPosition")
	g_PetSoul_Daka_Ani_Pos = PetSoul_Daka_Arrow_All:GetProperty("UnifiedPosition")
end

function PetSoul_Daka_OnEvent(event)
	if(event == "ADJEST_UI_POS") then
		PetSoul_Daka_On_ResetPos()
	elseif(event == "VIEW_RESOLUTION_CHANGED") then
		PetSoul_Daka_On_ResetPos()
	elseif(event == "HIDE_ON_SCENE_TRANSED") then
		PetSoul_Daka_OnClose()
	elseif event == "UI_COMMAND" and tonumber(arg0) == 89308901 then
		PetSoul_Daka_OnGameReady()
	elseif event == "UI_COMMAND" and tonumber(arg0) == 89308902 and this:IsVisible() then
		PetSoul_Daka_OnGameStart()
	elseif event == "UI_COMMAND" and tonumber(arg0) == 89308903 and this:IsVisible() then
		PetSoul_Daka_OnResultCalculate()
	elseif event == "UI_COMMAND" and tonumber(arg0) == 89308904 and this:IsVisible() then
		PetSoul_Daka_OnClose()
	elseif event == "UI_COMMAND" and tonumber(arg0) == 89308905 and this:IsVisible() then
		PetSoul_Daka_OnResultUpdate()
	elseif event == "UI_COMMAND" and tonumber(arg0) == 89308906 and this:IsVisible() then
		PetSoul_Daka_OnQuestionShow()
	elseif event == "UI_COMMAND" and tonumber(arg0) == 89308907 and this:IsVisible() then
		PetSoul_Daka_OnAnswerQuestionShow()
	end
end

-- 进入等待时间
function PetSoul_Daka_OnGameReady()
	-- 关心ID
	local targetId =  Get_XParam_INT(0)
	-- 时间
	local time = Get_XParam_INT(1)
	-- NPC头像索引
	g_PetSoul_Daka_NpcIdx = Get_XParam_INT(2)
	-- 关系npc
	PetSoul_Daka_BeginCareObject(targetId)
	-- 初始化答题数据
	ActQTESignInUI:Lua_Reset()
	-- 进行内容初始化
	PetSoul_Daka_OnDataInit()
	-- 进行界面显示
	PetSoul_Daka_OnShow()
end -- PetSoul_Daka_OnGameReady end

-- 单人答题活动开始
function PetSoul_Daka_OnGameStart()
	-- 初始化答题数据
	ActQTESignInUI:Lua_Reset()

	PushDebugMessage("#{BBYJ_220104_70}")
	
	-- 进入答题模式
	PetSoul_Daka_OnAnswerQuestionShow()
end -- PetSoul_Daka_OnGameStart end

-- 对数据进行初始化
function PetSoul_Daka_OnDataInit()
	g_PetSoul_Daka_Tick_Logic = 0
	g_PetSoul_Daka_Status = 0
	g_PetSoul_Daka_Tick_Logic_End = 0
end

function PetSoul_Daka_OnShow()
	-- 进行基础内容显示
	PetSoul_Daka_OnBaseShow()
	-- 更新处理
	PetSoul_Daka_OnUpdate()

	-- 关闭NPC对话界面
	PushEvent("UI_COMMAND", 1000)

	-- 屏蔽NPC
	ActQTESignInUI:Lua_ChangeModelVisible(0)
	ActQTESignInUI:Lua_ChangeCamera(1)
	--PetSoul_Daka_Info:SetText("")
	PetSoul_Daka_Info2:SetText("")

	PetSoul_Daka_IconShow()

	this:Show()
end

-- 进行基础显示
function PetSoul_Daka_OnBaseShow()
	-- 给个开始提示
	PushDebugMessage("#{BBYJ_220104_62}")

	-- 优先还原动画位置
	PetSoul_Daka_AniPosReset(0)
	-- 显示准备内容
	PetSoul_Daka_OnReadyShow()
end

-- 进行准备时间显示
function PetSoul_Daka_OnReadyShow()
	if g_PetSoul_Daka_ReadyTime - g_PetSoul_Daka_Tick_Logic > 0 then
		PetSoul_Daka_State:Hide()
		local bShow = 0
		for i=1, g_PetSoul_Daka_ReadyTime do
			if i == g_PetSoul_Daka_ReadyTime - g_PetSoul_Daka_Tick_Logic then
				bShow = 1
			end
		end
		if bShow < 1 then
			return
		end
		-- 倒计时
		local msg = ScriptGlobal_Format("#{BBYJ_220104_68}", math.floor(g_PetSoul_Daka_ReadyTime - g_PetSoul_Daka_Tick_Logic) )
		PushDebugMessage(msg)

		-- 显示提示
		msg = ScriptGlobal_Format("#{BBYJ_220104_69}", math.floor(g_PetSoul_Daka_ReadyTime - g_PetSoul_Daka_Tick_Logic ))
		--msg = tostring(math.floor(g_PetSoul_Daka_ReadyTime - g_PetSoul_Daka_Tick_Logic ))
		PetSoul_Daka_Info:SetText("")

		PetSoul_Daka_Info1:SetText(msg)
		PetSoul_Daka_Info1:Show()
	end
end

function PetSoul_Daka_OnAnswerTipTimeShow()
	local num = math.floor(g_PetSoul_Daka_AnswerTime - g_PetSoul_Daka_Tick_Logic )
	if num > 0 then
		local msg = ScriptGlobal_Format("#{BBYJ_220104_88}", math.floor(g_PetSoul_Daka_AnswerTime - g_PetSoul_Daka_Tick_Logic ))
		PetSoul_Daka_Info:SetText(msg)
	end
end

function PetSoul_Daka_OnResultTipTimeShow()
	local num = math.floor(g_PetSoul_Daka_AnswerTime - g_PetSoul_Daka_Tick_Logic )
	if num > 0 then
		local total = ActQTESignInUI:Lua_GetTotal()
		if total >= g_PetSoul_Daka_QuestionMax -1 then
			PetSoul_Daka_Info:SetText("")
		else
			local msg = ScriptGlobal_Format("#{BBYJ_220104_151}", math.floor(g_PetSoul_Daka_ResultTime - g_PetSoul_Daka_Tick_Logic ))
			PetSoul_Daka_Info:SetText(msg)
		end
	end
end

function PetSoul_Daka_OnResultTipExTimeShow()
	-- local num = math.floor(g_PetSoul_Daka_AnswerTime + g_PetSoul_Daka_ResultTime - g_PetSoul_Daka_Tick_Logic )
	-- if num > 0 then
	-- 	local msg = ScriptGlobal_Format("#{BBYJ_220104_161}", math.floor(g_PetSoul_Daka_AnswerTime + g_PetSoul_Daka_ResultTime - g_PetSoul_Daka_Tick_Logic ))
	-- 	PetSoul_Daka_Info:SetText(msg)
	-- end
	PetSoul_Daka_Info:SetText("#{BBYJ_220104_161}")
end

function PetSoul_Daka_OnQuestionTipTimeShow()
	local num = math.floor(g_PetSoul_Daka_QuestionTime - g_PetSoul_Daka_Tick_Logic )
	if  num > 0 then
		local msg = ScriptGlobal_Format("#{BBYJ_220104_71}", math.floor(g_PetSoul_Daka_QuestionTime - g_PetSoul_Daka_Tick_Logic ))
		PetSoul_Daka_Info:SetText(msg)
	end
end

-- 答题
function PetSoul_Daka_OnAnswerShow()
	PetSoul_Daka_State:Hide()

	-- 显示题目
	PetSoul_Daka_Info2:SetText(g_PetSoul_Daka_Subject)

	-- 播放前需要将动画位置还原
	PetSoul_Daka_AniPosReset(1)
end

-- 答题动画
function PetSoul_Daka_OnAnswerQuestionShow()

		-- 先获得我们参数数值
	local total = Get_XParam_INT(0)
	local question = Get_XParam_INT(1)
	local team = Get_XParam_INT(2)
	g_PetSoul_Daka_Subject = Get_XParam_STR(0)
	ActQTESignInUI:Lua_SetTotal(total)
	ActQTESignInUI:Lua_SetTeamInfo(team)
	ActQTESignInUI:Lua_SetQuestionInfo(total, question)

	g_PetSoul_Daka_Subject = Get_XParam_STR(0)

	-- 切换状态
	g_PetSoul_Daka_Status = 4
	g_PetSoul_Daka_Tick_Logic = 0

	PetSoul_Daka_OnUpdate()
	PetSoul_Daka_State:Hide()
	PetSoul_Daka_Info1:Hide()
	-- 显示题目
	PetSoul_Daka_Info2:SetText(g_PetSoul_Daka_Subject)

	PetSoul_Daka_AniPosReset(0)
	PetSoul_Daka_OnQuestionTipTimeShow()
end

-- 答题动画
function PetSoul_Daka_OnAnswerAniShow()
	-- 切换状态
	g_PetSoul_Daka_Status = 1
	g_PetSoul_Daka_Tick_Logic = 0

	PetSoul_Daka_OnUpdate()

	--PushDebugMessage("#{BBYJ_220104_70}")

	-- 开始播放动画
	PetSoul_Daka_OnAnswerShow()
	PetSoul_Daka_OnAnswerTipTimeShow()
end

-- 结果显示
function PetSoul_Daka_OnQuestionShow()
	local total =  Get_XParam_INT(0)
	local question = Get_XParam_INT(1)


	g_PetSoul_Daka_Subject = Get_XParam_STR(0)

	ActQTESignInUI:Lua_SetTotal(total)
	ActQTESignInUI:Lua_SetQuestionInfo(total, question)

	-- 显示我的答题情况
	g_PetSoul_Daka_Status = 1
	g_PetSoul_Daka_Tick_Logic = 0

	PetSoul_Daka_OnUpdate()

	PetSoul_Daka_OnAnswerShow()
	PetSoul_Daka_OnAnswerTipTimeShow()
end


-- 结果显示
function PetSoul_Daka_OnResultUpdate()
	local ret = Get_XParam_INT(0)
	local succeed = Get_XParam_INT(1)
	g_PetSoul_Daka_Key = Get_XParam_STR(0)

	local image = g_PetSoul_Daka_AnswerIcon.fail
	if ret == 0 and succeed > 0 then
		--PushDebugMessage("答题普通")
		image = g_PetSoul_Daka_AnswerIcon.normal
	elseif ret == 1 and succeed > 0 then
		--PushDebugMessage("答题卓越")
		image = g_PetSoul_Daka_AnswerIcon.excellent
	elseif ret == 2 and succeed > 0 then
		--PushDebugMessage("答题优秀")
		image = g_PetSoul_Daka_AnswerIcon.perfect
	elseif ret == -1 then
		--PushDebugMessage("队友答题超时")
	elseif ret == -2 then
		--PushDebugMessage("自己答题超时")
		PushDebugMessage("#{BBYJ_220104_89}")
	end

	if ret == -2 then
		PetSoul_Daka_State:Hide()
	else
		PetSoul_Daka_State:SetProperty("Image", image)
		PetSoul_Daka_State:Show()
	end

	-- 对滑块进行隐藏
	PetSoul_Daka_AniPosReset(0)
	-- 对结果进行显示
	PetSoul_Daka_OnResultShow()

	g_PetSoul_Daka_Status = 3

	PetSoul_Daka_OnUpdate()

	PetSoul_Daka_OnResultTipExTimeShow()
end

-- 结果显示
function PetSoul_Daka_OnResultCalculate()
	local total =  Get_XParam_INT(0)
	local question = Get_XParam_INT(1)
	local ret = Get_XParam_INT(2)
	local succeed = Get_XParam_INT(3)

	g_PetSoul_Daka_Key = Get_XParam_STR(0)

	ActQTESignInUI:Lua_SetTotal(total)
	if ret > -100 then

		local image = g_PetSoul_Daka_AnswerIcon.fail
		if ret == 0 and succeed > 0 then
			--PushDebugMessage("答题普通")
			image = g_PetSoul_Daka_AnswerIcon.normal
		elseif ret == 1 and succeed > 0 then
			--PushDebugMessage("答题卓越")
			image = g_PetSoul_Daka_AnswerIcon.excellent
		elseif ret == 2 and succeed > 0 then
			--PushDebugMessage("答题优秀")
			image = g_PetSoul_Daka_AnswerIcon.perfect
		elseif ret == -1 then
			--PushDebugMessage("队友答题超时")
		elseif ret == -2 then
			--PushDebugMessage("自己答题超时")
			PushDebugMessage("#{BBYJ_220104_89}")
		end
		
		if ret == -2 then
			PetSoul_Daka_State:Hide()
		else
			PetSoul_Daka_State:SetProperty("Image", image)
			PetSoul_Daka_State:Show()
		end
	end

	-- 对滑块进行隐藏
	PetSoul_Daka_AniPosReset(0)
	-- 对结果进行显示
	PetSoul_Daka_OnResultShow()

	-- 显示我的答题情况
	g_PetSoul_Daka_Status = 2
	g_PetSoul_Daka_Tick_Logic = 0
	
	PetSoul_Daka_OnUpdate()

	PetSoul_Daka_OnResultTipTimeShow()
end

function PetSoul_Daka_OnResultShow()
	PetSoul_Daka_Info2:SetText(g_PetSoul_Daka_Key)
end


-- 动画播放结束，进行回调
function PetSoul_Daka_Arrow_OnTweenAniEnd()

end

-- QTE变化显示
function PetSoul_Daka_OnUpdate()
	-- 优先关闭定时器
	KillTimer( "PetSoul_Daka_OnTimer()" )
	-- 启动定时器
	SetTimer("PetSoul_Daka","PetSoul_Daka_OnTimer()", g_PetSoul_Daka_Tick_Time*1000)
end

function PetSoul_Daka_OnTimer()
	-- 计时时间计数
	g_PetSoul_Daka_Tick_Logic = g_PetSoul_Daka_Tick_Logic + g_PetSoul_Daka_Tick_Time
	-- 准备阶段内容显示
	if g_PetSoul_Daka_Status == 0 and g_PetSoul_Daka_Tick_Logic < g_PetSoul_Daka_ReadyTime then
		-- 倒计时显示
		PetSoul_Daka_OnReadyShow()
	elseif g_PetSoul_Daka_Status == 1 then
		PetSoul_Daka_OnAnswerTipTimeShow()
	elseif g_PetSoul_Daka_Status == 2 then
		PetSoul_Daka_OnResultTipTimeShow()
	elseif g_PetSoul_Daka_Status == 3 then
		PetSoul_Daka_OnResultTipExTimeShow()
	elseif g_PetSoul_Daka_Status == 4 then
		PetSoul_Daka_OnQuestionTipTimeShow()
	end
end

-- 滑块在显示的时候，重置位置
function PetSoul_Daka_AniPosReset(bShow)
	-- 播放前需要将动画位置还原
	PetSoul_Daka_Arrow_All:Tween_Reset("Position",true)
	PetSoul_Daka_Arrow_All:SetProperty("UnifiedPosition", g_PetSoul_Daka_Ani_Pos)
	if bShow > 0 then
		-- 开始播放动画
		PetSoul_Daka_Arrow_All:Tween_SetInfo("Position", g_PetSoul_Daka_Ani_Info)
		PetSoul_Daka_Arrow_All:Tween_Play("Position", true, true)
		PetSoul_Daka_Arrow_All:Show()
	else
		PetSoul_Daka_Arrow_All:Hide()
	end
end

-- 对应NPC显示
function PetSoul_Daka_IconShow()
	if g_PetSoul_Daka_Icon[g_PetSoul_Daka_NpcIdx] ~= nil then
		PetSoul_Daka_InfoBK:SetProperty("Image", g_PetSoul_Daka_Icon[g_PetSoul_Daka_NpcIdx].head)
		PetSoul_Daka_Arrow:SetProperty("Image", g_PetSoul_Daka_Icon[g_PetSoul_Daka_NpcIdx].arrow)
	else
		PetSoul_Daka_InfoBK:SetProperty("Image", g_PetSoul_Daka_Icon[4].head)
		PetSoul_Daka_Arrow:SetProperty("Image", g_PetSoul_Daka_Icon[4].arrow)
	end
end

function PetSoul_Daka_BeginCareObject(objid)
	local nID = DataPool : GetNPCIDByServerID( objid )
	this:CareObject(nID, 1, "PetSoul_Daka")
	g_PetSoul_Daka_CaredNpc = nID
end

function PetSoul_Daka_On_ResetPos()
	PetSoul_Daka_Blank:SetProperty("UnifiedPosition", g_PetSoul_Daka_Frame_UnifiedPosition)
end

function PetSoul_Daka_Help_Click()
end

function PetSoul_Daka_DetailShow(bshow)

end

function PetSoul_Daka_OnHiden()
	this:CareObject(g_PetSoul_Daka_CaredNpc, 0, "PetSoul_Daka")
	g_PetSoul_Daka_CaredNpc = -1
	-- 通知，结束答题状态
	KillTimer( "PetSoul_Daka_OnTimer()" )
	ActQTESignInUI:Lua_Reset()
	ActQTESignInUI:Lua_ChangeModelVisible(1)
	ActQTESignInUI:Lua_ChangeCamera(0)
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("GameOver")
		Set_XSCRIPT_ScriptID(g_PetSoul_Daka_MainScript)
		Set_XSCRIPT_Parameter(0,1)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
end

-- 退出
function PetSoul_Daka_Throw()
	if this:IsVisible() then
		-- 二次确认框
		PushEvent("ACT_QTE_SIGNIN_CONFIRM")
	end
end

function PetSoul_Daka_OnClose()
	this:Hide()
end