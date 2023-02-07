
local g_JiaNianHua_Level = 15
local g_ChangXiuGe_Level = 15

--===============================================
-- OnLoad()
--===============================================
function JiaNianHua_PreLoad()
	this:RegisterEvent("PLAYER_ENTERING_WORLD" );	-- ����world
	this:RegisterEvent("UNIT_LEVEL");				-- ����
end

function JiaNianHua_OnLoad()

end

--===============================================
-- OnEvent()
--===============================================
function JiaNianHua_OnEvent( event )
	
	if event == "PLAYER_ENTERING_WORLD" then
		JiaNianHua_UpdateUI()
		
	elseif event == "UNIT_LEVEL" then
		JiaNianHua_UpdateUI()
	end

end

function JiaNianHua_UpdateUI()
	JiaNianHua_Update_ChangXiuGe()
	--JiaNianHua_Update_JiaNianHua()
end

--===============================================
-- Bn2Click()
--===============================================
function JiaNianHua_Clicked( index )
	if index == 1 then
		JiaNianHua_Click_ChangXiuGe()
		
	elseif index == 2 then
		--JiaNianHua_Click_JiaNianHua()
		
	end
end

--����������
function JiaNianHua_Update_ChangXiuGe()
	
	--����
	local curDay = tonumber(DataPool:GetServerDayTime());	
	if curDay < 20211017 or curDay > 20211017 then
		JiaNianHua_ChangXiuGe:Hide()
		this:Hide()
		return
	end
	--ʱ��
	local curTime = tonumber(DataPool:GetServerMinuteTime())
	local curHour = math.floor(curTime/10000)	
	if curHour<10 or curHour>20 then
		JiaNianHua_ChangXiuGe:Hide()
		this:Hide()
		return
	end
	--�ȼ�	
	local nPlayerLevel = Player:GetData("LEVEL")
	if nPlayerLevel < g_ChangXiuGe_Level then
		JiaNianHua_ChangXiuGe:Hide()
		this:Hide()
		return
	end		
	JiaNianHua_ChangXiuGe:Show()
	this:Show()	
	if curHour<19 then
		JiaNianHua_ChangXiuGeImage:SetToolTip("#{JNHZB_20210929_1}")
	else
		JiaNianHua_ChangXiuGeImage:SetToolTip("#{JNHZB_20210929_2}")
	end
	
end


function JiaNianHua_Click_ChangXiuGe()
	local nPlayerLevel = Player:GetData("LEVEL")
	if nPlayerLevel < g_ChangXiuGe_Level then
		PushDebugMessage("#{JNHZB_20201105_05}")
		return
	end
	
	GameProduceLogin:OpenURL(GetWeblink("WEB_JNHZB"))
end


--���껪ֱ���������
function JiaNianHua_Update_JiaNianHua()
	--����
	local curDay = tonumber(DataPool:GetServerDayTime());
	if curDay < 20201119 or curDay > 20201122 then
		JiaNianHua_DouYu:Hide()
		this:Hide()
		return
	end
	
	local nPlayerLevel = Player:GetData("LEVEL")
	if nPlayerLevel < g_JiaNianHua_Level then
		JiaNianHua_DouYu:Hide()
		this:Hide()
		return
	end
	
	JiaNianHua_DouYu:Show()
	this:Show()
	
	local curTime = tonumber(DataPool:GetServerMinuteTime())
	local curHour = math.floor(curTime/10000)
	
	if curDay <= 20201121 and curHour < 10 then
		--2020��11��19��21��10ʱ�����껪����11��21��10ʱ��ʼ�������ڴ���
		JiaNianHua_DouYuImage:SetToolTip("#{JNHZB_20201105_01}")
	else
		--2020��11��21��10ʱ֮�󣺵���ۿ��������껪�ֳ�ֱ����
		JiaNianHua_DouYuImage:SetToolTip("#{JNHZB_20201105_02}")
	end
end


function JiaNianHua_Click_JiaNianHua()
	local nPlayerLevel = Player:GetData("LEVEL")
	if nPlayerLevel < g_JiaNianHua_Level then
		PushDebugMessage("#{JNHZB_20201105_03}")
		return
	end
	
	GameProduceLogin:OpenURL(GetWeblink("WEB_JNHZB"))
end






