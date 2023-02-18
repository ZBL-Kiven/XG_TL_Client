-------------------------------------------------------
--"�鿴�Զ�����ְλ"����ű�
--create by xindefeng
-------------------------------------------------------

local g_CustomPosition = nil	--��Ҫ�õ��Ŀؼ���

--��׼���ְλ����
local g_StdPositionName = {
	"����",			--9
	"������",		--8
	"����ʹ",		--7
	"����ʹ",		--6
	"�뻯ʹ",		--5
	"����",			--4
	"��Ӣ",			--3
	"����"			--2
}


--�¼�ע��
function CheckCustomPosition_PreLoad()
	this:RegisterEvent("GUILD_CHECK_CUSTOMPOSITION")
	this:RegisterEvent("GUILD_FORCE_CLOSE")	
end

function CheckCustomPosition_OnLoad()	
end

--�¼���Ӧ
function CheckCustomPosition_OnEvent(event)	
	if( event == "GUILD_CHECK_CUSTOMPOSITION" ) then
		CheckCustomPosition_SetCtls()	--���ÿؼ�
				
		CheckCustomPosition_Update()
		CheckCustomPosition_Show()
	elseif( event == "GUILD_FORCE_CLOSE" ) then	
		CheckCustomPosition_Ok()
	end
end

--���ÿؼ���
function CheckCustomPosition_SetCtls()
	g_CustomPosition = {
												CheckCustomPosition_CurPos1,
												CheckCustomPosition_CurPos2,
												CheckCustomPosition_CurPos3,
												CheckCustomPosition_CurPos4,
												CheckCustomPosition_CurPos5,
												CheckCustomPosition_CurPos6,
												CheckCustomPosition_CurPos7,
												CheckCustomPosition_CurPos8							
										}
end


--ˢ�½�����ʾ������
function CheckCustomPosition_Update()
	local szMsg = nil
	
	CheckCustomPosition_Title:SetText("#gFF0FA0�Զ���ְλ����")
	
	--��ʾ��ǰ"�Զ���ְλ����"
	for i=1,8 do
		szMsg = Guild:GetCurCustomPositionName(10-i)
		if((szMsg == "") or (szMsg == g_StdPositionName[i]))then
			szMsg = g_StdPositionName[i]			
		else
			szMsg = szMsg.."("..g_StdPositionName[i]..")"			
		end
		
		--���õ�ǰ�Զ���ְλ����
		g_CustomPosition[i]:SetText(szMsg)
		
	end
end

--�򿪽���
function CheckCustomPosition_Show()	
	this:Show()
end

--ȷ��
function CheckCustomPosition_Ok()	
	--�رմ���
	this:Hide()	
end