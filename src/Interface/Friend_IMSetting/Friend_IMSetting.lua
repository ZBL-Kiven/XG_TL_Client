--!!!reloadscript =Friend_IMSetting

local g_Friend_IMSetting_Frame_UnifiedXPosition
local g_Friend_IMSetting_Frame_UnifiedYPosition

local MaxGroupingName = 4
local g_CurTagIndex = 0
local g_TagClicked = 0

--===============================================
-- OnLoad()
--===============================================
function Friend_IMSetting_PreLoad()
	this:RegisterEvent("OPEN_IM_SETTING")
	this:RegisterEvent("UPDATE_GROUPINGNAME")
	this:RegisterEvent("UI_COMMAND")
	
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function Friend_IMSetting_OnLoad()
	--��������Ĭ�����λ��
	g_Friend_IMSetting_Frame_UnifiedXPosition	= Friend_IMSetting_Frame:GetProperty("UnifiedXPosition")
	g_Friend_IMSetting_Frame_UnifiedYPosition	= Friend_IMSetting_Frame:GetProperty("UnifiedYPosition")
end

function Friend_IMSetting_OnEvent(event)

	if event == "UI_COMMAND" and tonumber(arg0) == 2022070511 then
		Friend_IMSetting_OnShow()
		g_CurTagIndex = 1
		Friend_IMSetting_UpdateFrame()
		this:Show()		
	elseif event == "UPDATE_GROUPINGNAME" then
		if tonumber(arg0) == 1 then
			PushDebugMessage("#{LTQH_XML_92}")
			Friend_IMSetting_UpdateFrame()
		end
	elseif event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		Friend_IMSetting_ResetPos()
	end

end

function Friend_IMSetting_ResetPos()
	Friend_IMSetting_Frame:SetProperty("UnifiedXPosition", g_Friend_IMSetting_Frame_UnifiedXPosition)
	Friend_IMSetting_Frame:SetProperty("UnifiedYPosition", g_Friend_IMSetting_Frame_UnifiedYPosition)
end

function Friend_IMSetting_OnShow()
	local n1,n2,n3,n4,n5,n6,n7,n8,n9,f10,n11,n12,n13,n14,n15 = SystemSetup:GameGetData();

	Friend_IMSetting_Basic1:SetCheck(n1)					-- �ܾ������ż�
	Friend_IMSetting_Basic2:SetCheck(n2)					-- �ܾ����Һ���
	Friend_IMSetting_Basic3:SetCheck(n3)					-- �ܾ�Ĭ�����ż�
	--Friend_IMSetting_Basic4:SetCheck(n4)					-- �ܾ�����������Ϣ

	Friend_IMSetting_GroupNameNew:SetText("")
	Friend_IMSetting_GroupName:SetText("")
	Friend_IMSetting_GroupName:ResetList()

	for i = 1, MaxGroupingName do
		local GroupName = GetGroupingName(i)
		Friend_IMSetting_GroupName:AddTextItem(GroupName, i)
	end
end

function Friend_IMSetting_UpdateFrame()
	if g_CurTagIndex == 1 then
		Friend_IMSetting_BasicSetting:SetCheck(1)
		Friend_IMSetting_GroupSetting:SetCheck(0)
		Friend_IMSetting_BasicContent:Show()
		Friend_IMSetting_GroupContent:Hide()
		Friend_IMSetting_Explain:SetText("#{KDHYYH_20211025_20}")
	else
		Friend_IMSetting_BasicSetting:SetCheck(0)
		Friend_IMSetting_GroupSetting:SetCheck(1)
		Friend_IMSetting_BasicContent:Hide()
		Friend_IMSetting_GroupContent:Show()
		Friend_IMSetting_Explain:SetText("#{KDHYYH_20211025_21}")
	end
end

--ȷ��
function Friend_IMSetting_Accept_Clicked()
	
	if g_CurTagIndex == 1 then
		
		local n1,n2,n3,n4,n5,n6,n7,n8,n9,f10,n11,n12,n13,n14,n15 = SystemSetup:GameGetData();

		n1 = Friend_IMSetting_Basic1:GetCheck()		-- �ܾ������ż�
		n2 = Friend_IMSetting_Basic2:GetCheck()		-- �ܾ����Һ���
		n3 = Friend_IMSetting_Basic3:GetCheck()		-- �ܾ�Ĭ�����ż�
		--n4 = Friend_IMSetting_Basic4:GetCheck()		-- �ܾ�����������Ϣ

		SystemSetup:SaveGameSetup( n1,n2,n3,n4,n5,n6,n7,n8,n9,tonumber(f10),n11,n12,n13,n14,n15 );

		this:Hide()
	end

end
--ȡ��
function Friend_IMSetting_Cancel_Clicked()
	this:Hide()
end

--�޸ķ�������
function Friend_IMSetting_Modify_Clicked()
	local oldName, nIndex = Friend_IMSetting_GroupName:GetCurrentSelect()
	local newName = Friend_IMSetting_GroupNameNew:GetText()
	if nIndex < 1 or nIndex > MaxGroupingName then
		PushDebugMessage("��ѡ��һ������")
		return -1
	end
	if newName == "" or newName == nil then
		PushDebugMessage("�µķ���������Ϊ��")
		return -1
	end

	local Ret = ModifyGroupingName(nIndex, newName)
	if Ret == nil or tonumber(Ret) < 0 then
		PushDebugMessage("������ķ������Ʋ��Ϲ�������������")
		return -1
	end
	
	return 1
end


function Friend_IMSetting_OnHidden()
	
end

function Friend_IMSetting_Tag_Clicked(Index)	
	if Index == g_CurTagIndex then
		return
	end
	
	g_CurTagIndex = Index
	Friend_IMSetting_UpdateFrame()
	g_TagClicked = 1
end

function Friend_IMSetting_Tag_Restore()
	if g_TagClicked == 1 then
		g_TagClicked = 0
		return
	end
	
	if g_CurTagIndex == 1 then
		Friend_IMSetting_BasicSetting:SetCheck(1)
		Friend_IMSetting_GroupSetting:SetCheck(0)
	else
		Friend_IMSetting_BasicSetting:SetCheck(0)
		Friend_IMSetting_GroupSetting:SetCheck(1)
	end
end


