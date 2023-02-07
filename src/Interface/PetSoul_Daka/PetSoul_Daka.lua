local g_PetSoul_Daka_Frame_UnifiedPosition	= nil 

local g_PetSoul_Daka_Tick_Time				= 0.5		-- ��ʱ��ʱ��(��)
local g_PetSoul_Daka_ReadyTime				= 5			-- �ȴ�ʱ��
local g_PetSoul_Daka_AnswerTime				= 7.5		-- ����ʱ��
local g_PetSoul_Daka_QuestionTime			= 7.5		-- ��Ŀʱ��
local g_PetSoul_Daka_ResultTime				= 8			-- �����ʾʱ��
local g_PetSoul_Daka_QuestionMax			= 16		-- ���16����

local g_PetSoul_Daka_Tick_Logic				= 0			-- ��ʱ
local g_PetSoul_Daka_Status					= 0			-- ״̬
local g_PetSoul_Daka_Tick_Logic_End			= 0			-- ����tick
local g_PetSoul_Daka_Tick_Logic_TimeOut		= g_PetSoul_Daka_ReadyTime + g_PetSoul_Daka_AnswerTime	-- ��ʱ
local g_PetSoul_Daka_Ani_Info				= string.format("curve:Liner mode:Once duration:%s startx:0 starty:0 endx:496 endy:0", g_PetSoul_Daka_AnswerTime)
local g_PetSoul_Daka_Ani_Pos				= nil		-- ����λ��
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
	-- ��Ϸ���ڳߴ緢���˱仯
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

-- ����ȴ�ʱ��
function PetSoul_Daka_OnGameReady()
	-- ����ID
	local targetId =  Get_XParam_INT(0)
	-- ʱ��
	local time = Get_XParam_INT(1)
	-- NPCͷ������
	g_PetSoul_Daka_NpcIdx = Get_XParam_INT(2)
	-- ��ϵnpc
	PetSoul_Daka_BeginCareObject(targetId)
	-- ��ʼ����������
	ActQTESignInUI:Lua_Reset()
	-- �������ݳ�ʼ��
	PetSoul_Daka_OnDataInit()
	-- ���н�����ʾ
	PetSoul_Daka_OnShow()
end -- PetSoul_Daka_OnGameReady end

-- ���˴�����ʼ
function PetSoul_Daka_OnGameStart()
	-- ��ʼ����������
	ActQTESignInUI:Lua_Reset()

	PushDebugMessage("#{BBYJ_220104_70}")
	
	-- �������ģʽ
	PetSoul_Daka_OnAnswerQuestionShow()
end -- PetSoul_Daka_OnGameStart end

-- �����ݽ��г�ʼ��
function PetSoul_Daka_OnDataInit()
	g_PetSoul_Daka_Tick_Logic = 0
	g_PetSoul_Daka_Status = 0
	g_PetSoul_Daka_Tick_Logic_End = 0
end

function PetSoul_Daka_OnShow()
	-- ���л���������ʾ
	PetSoul_Daka_OnBaseShow()
	-- ���´���
	PetSoul_Daka_OnUpdate()

	-- �ر�NPC�Ի�����
	PushEvent("UI_COMMAND", 1000)

	-- ����NPC
	ActQTESignInUI:Lua_ChangeModelVisible(0)
	ActQTESignInUI:Lua_ChangeCamera(1)
	--PetSoul_Daka_Info:SetText("")
	PetSoul_Daka_Info2:SetText("")

	PetSoul_Daka_IconShow()

	this:Show()
end

-- ���л�����ʾ
function PetSoul_Daka_OnBaseShow()
	-- ������ʼ��ʾ
	PushDebugMessage("#{BBYJ_220104_62}")

	-- ���Ȼ�ԭ����λ��
	PetSoul_Daka_AniPosReset(0)
	-- ��ʾ׼������
	PetSoul_Daka_OnReadyShow()
end

-- ����׼��ʱ����ʾ
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
		-- ����ʱ
		local msg = ScriptGlobal_Format("#{BBYJ_220104_68}", math.floor(g_PetSoul_Daka_ReadyTime - g_PetSoul_Daka_Tick_Logic) )
		PushDebugMessage(msg)

		-- ��ʾ��ʾ
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

-- ����
function PetSoul_Daka_OnAnswerShow()
	PetSoul_Daka_State:Hide()

	-- ��ʾ��Ŀ
	PetSoul_Daka_Info2:SetText(g_PetSoul_Daka_Subject)

	-- ����ǰ��Ҫ������λ�û�ԭ
	PetSoul_Daka_AniPosReset(1)
end

-- ���⶯��
function PetSoul_Daka_OnAnswerQuestionShow()

		-- �Ȼ�����ǲ�����ֵ
	local total = Get_XParam_INT(0)
	local question = Get_XParam_INT(1)
	local team = Get_XParam_INT(2)
	g_PetSoul_Daka_Subject = Get_XParam_STR(0)
	ActQTESignInUI:Lua_SetTotal(total)
	ActQTESignInUI:Lua_SetTeamInfo(team)
	ActQTESignInUI:Lua_SetQuestionInfo(total, question)

	g_PetSoul_Daka_Subject = Get_XParam_STR(0)

	-- �л�״̬
	g_PetSoul_Daka_Status = 4
	g_PetSoul_Daka_Tick_Logic = 0

	PetSoul_Daka_OnUpdate()
	PetSoul_Daka_State:Hide()
	PetSoul_Daka_Info1:Hide()
	-- ��ʾ��Ŀ
	PetSoul_Daka_Info2:SetText(g_PetSoul_Daka_Subject)

	PetSoul_Daka_AniPosReset(0)
	PetSoul_Daka_OnQuestionTipTimeShow()
end

-- ���⶯��
function PetSoul_Daka_OnAnswerAniShow()
	-- �л�״̬
	g_PetSoul_Daka_Status = 1
	g_PetSoul_Daka_Tick_Logic = 0

	PetSoul_Daka_OnUpdate()

	--PushDebugMessage("#{BBYJ_220104_70}")

	-- ��ʼ���Ŷ���
	PetSoul_Daka_OnAnswerShow()
	PetSoul_Daka_OnAnswerTipTimeShow()
end

-- �����ʾ
function PetSoul_Daka_OnQuestionShow()
	local total =  Get_XParam_INT(0)
	local question = Get_XParam_INT(1)


	g_PetSoul_Daka_Subject = Get_XParam_STR(0)

	ActQTESignInUI:Lua_SetTotal(total)
	ActQTESignInUI:Lua_SetQuestionInfo(total, question)

	-- ��ʾ�ҵĴ������
	g_PetSoul_Daka_Status = 1
	g_PetSoul_Daka_Tick_Logic = 0

	PetSoul_Daka_OnUpdate()

	PetSoul_Daka_OnAnswerShow()
	PetSoul_Daka_OnAnswerTipTimeShow()
end


-- �����ʾ
function PetSoul_Daka_OnResultUpdate()
	local ret = Get_XParam_INT(0)
	local succeed = Get_XParam_INT(1)
	g_PetSoul_Daka_Key = Get_XParam_STR(0)

	local image = g_PetSoul_Daka_AnswerIcon.fail
	if ret == 0 and succeed > 0 then
		--PushDebugMessage("������ͨ")
		image = g_PetSoul_Daka_AnswerIcon.normal
	elseif ret == 1 and succeed > 0 then
		--PushDebugMessage("����׿Խ")
		image = g_PetSoul_Daka_AnswerIcon.excellent
	elseif ret == 2 and succeed > 0 then
		--PushDebugMessage("��������")
		image = g_PetSoul_Daka_AnswerIcon.perfect
	elseif ret == -1 then
		--PushDebugMessage("���Ѵ��ⳬʱ")
	elseif ret == -2 then
		--PushDebugMessage("�Լ����ⳬʱ")
		PushDebugMessage("#{BBYJ_220104_89}")
	end

	if ret == -2 then
		PetSoul_Daka_State:Hide()
	else
		PetSoul_Daka_State:SetProperty("Image", image)
		PetSoul_Daka_State:Show()
	end

	-- �Ի����������
	PetSoul_Daka_AniPosReset(0)
	-- �Խ��������ʾ
	PetSoul_Daka_OnResultShow()

	g_PetSoul_Daka_Status = 3

	PetSoul_Daka_OnUpdate()

	PetSoul_Daka_OnResultTipExTimeShow()
end

-- �����ʾ
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
			--PushDebugMessage("������ͨ")
			image = g_PetSoul_Daka_AnswerIcon.normal
		elseif ret == 1 and succeed > 0 then
			--PushDebugMessage("����׿Խ")
			image = g_PetSoul_Daka_AnswerIcon.excellent
		elseif ret == 2 and succeed > 0 then
			--PushDebugMessage("��������")
			image = g_PetSoul_Daka_AnswerIcon.perfect
		elseif ret == -1 then
			--PushDebugMessage("���Ѵ��ⳬʱ")
		elseif ret == -2 then
			--PushDebugMessage("�Լ����ⳬʱ")
			PushDebugMessage("#{BBYJ_220104_89}")
		end
		
		if ret == -2 then
			PetSoul_Daka_State:Hide()
		else
			PetSoul_Daka_State:SetProperty("Image", image)
			PetSoul_Daka_State:Show()
		end
	end

	-- �Ի����������
	PetSoul_Daka_AniPosReset(0)
	-- �Խ��������ʾ
	PetSoul_Daka_OnResultShow()

	-- ��ʾ�ҵĴ������
	g_PetSoul_Daka_Status = 2
	g_PetSoul_Daka_Tick_Logic = 0
	
	PetSoul_Daka_OnUpdate()

	PetSoul_Daka_OnResultTipTimeShow()
end

function PetSoul_Daka_OnResultShow()
	PetSoul_Daka_Info2:SetText(g_PetSoul_Daka_Key)
end


-- �������Ž��������лص�
function PetSoul_Daka_Arrow_OnTweenAniEnd()

end

-- QTE�仯��ʾ
function PetSoul_Daka_OnUpdate()
	-- ���ȹرն�ʱ��
	KillTimer( "PetSoul_Daka_OnTimer()" )
	-- ������ʱ��
	SetTimer("PetSoul_Daka","PetSoul_Daka_OnTimer()", g_PetSoul_Daka_Tick_Time*1000)
end

function PetSoul_Daka_OnTimer()
	-- ��ʱʱ�����
	g_PetSoul_Daka_Tick_Logic = g_PetSoul_Daka_Tick_Logic + g_PetSoul_Daka_Tick_Time
	-- ׼���׶�������ʾ
	if g_PetSoul_Daka_Status == 0 and g_PetSoul_Daka_Tick_Logic < g_PetSoul_Daka_ReadyTime then
		-- ����ʱ��ʾ
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

-- ��������ʾ��ʱ������λ��
function PetSoul_Daka_AniPosReset(bShow)
	-- ����ǰ��Ҫ������λ�û�ԭ
	PetSoul_Daka_Arrow_All:Tween_Reset("Position",true)
	PetSoul_Daka_Arrow_All:SetProperty("UnifiedPosition", g_PetSoul_Daka_Ani_Pos)
	if bShow > 0 then
		-- ��ʼ���Ŷ���
		PetSoul_Daka_Arrow_All:Tween_SetInfo("Position", g_PetSoul_Daka_Ani_Info)
		PetSoul_Daka_Arrow_All:Tween_Play("Position", true, true)
		PetSoul_Daka_Arrow_All:Show()
	else
		PetSoul_Daka_Arrow_All:Hide()
	end
end

-- ��ӦNPC��ʾ
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
	-- ֪ͨ����������״̬
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

-- �˳�
function PetSoul_Daka_Throw()
	if this:IsVisible() then
		-- ����ȷ�Ͽ�
		PushEvent("ACT_QTE_SIGNIN_CONFIRM")
	end
end

function PetSoul_Daka_OnClose()
	this:Hide()
end