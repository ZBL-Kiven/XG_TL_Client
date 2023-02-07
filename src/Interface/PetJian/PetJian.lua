--����ͼ��
--build 2019-8-6 16:04:30 ��ң��
local g_petNum = 0;
local g_CurSel = -1;
local g_Icon = "";

local Max_BtnNum = 10;
local PetNames = {
	"��������",
	"���ޱ���",
	"1������",
	"2������",
	"3������",
	"4������",
	"5������",
	"6������",
	"7������",
	"8������",
};
local PetNames_HH = {
	"�û����1",
	"�û����2",
	"�û����3",
	"�û����4",
	"�û����5",
	"�û����6",
	"�û����7",
	"�û����8",
	"�û����9",
	"�û����10",
};
local PetNames_ChangeModel = {
	"�û����1",
	"�û����2",
	"ԭ���������",
	"ԭ���������",
	"ԭ���������",
	"ԭ���������",
	"ԭ���������",
	"ԭ���������",
	"ԭ���������",
	"ԭ���������",
};

-- �����Ĭ�����λ��
local g_PetJian_Frame_UnifiedXPosition;
local g_PetJian_Frame_UnifiedYPosition;

local m_IsHH = 0
local WorkType = "";
local m_NewModel = -1;
function PetJian_PreLoad()
	this:RegisterEvent("OPEN_PETJIAN_DLG");
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED");
	this:RegisterEvent("UI_COMMAND");
	-- ��Ϸ���ڳߴ緢���˱仯
	this:RegisterEvent("ADJEST_UI_POS")

	-- ��Ϸ�ֱ��ʷ����˱仯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function PetJian_OnLoad()

	-- ��������Ĭ�����λ��
	g_PetJian_Frame_UnifiedXPosition	= PetJian_Frame : GetProperty("UnifiedXPosition");
	g_PetJian_Frame_UnifiedYPosition	= PetJian_Frame : GetProperty("UnifiedYPosition");

end

function PetJian_OnEvent(event)
	if ( event == "OPEN_PETJIAN_DLG" ) then
		WorkType = tostring(arg0);
		m_NewModel = tonumber(arg1);
		PetJian_Init()
		this:Show();
	end
	if ( event == "HIDE_ON_SCENE_TRANSED" ) then
		this:Hide();
		g_petNum = 0;
		g_CurSel = -1;
		g_Icon = "";
	end
	if ( event == "UI_COMMAND" and arg0 == "1000000077" ) then
		m_IsHH = 1;
		WorkType = tostring(arg1);
		m_NewModel = tonumber(arg2);
		PetJian_Init()
		this:Show();
	end
	-- ��Ϸ���ڳߴ緢���˱仯
	if (event == "ADJEST_UI_POS" ) then
		-- ���±�������λ��
		PetJian_Frame_On_ResetPos()

	-- ��Ϸ�ֱ��ʷ����˱仯
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		-- ���±�������λ��	
		PetJian_Frame_On_ResetPos()
	end

end

function PetJian_Init()
	PetJian_List : ClearListBox();
	PetJian_FakeObject : SetFakeObject( "" );
	g_petNum = DataPool:GetPetsOneTypeNum();
	g_CurSel = -1;
	if(Max_BtnNum <  g_petNum) then
		g_petNum = Max_BtnNum;
	end
	--------------------------------------------------
	--Buttons	
	for i = 1 , g_petNum do
		if WorkType ~=nil and WorkType == "ChangeModel" then --�ı����
			PetJian_List : AddItem(PetNames_ChangeModel[i], i-1);
		else --�û� �� ���޽���
			if m_IsHH == 1 then
				PetJian_List : AddItem(PetNames_HH[i], i-1);
			else
				PetJian_List : AddItem(PetNames[i], i-1);
			end
		end
	end
	--Ĭ��ѡ�����һ�� ����Ǹı�������۽��������ѡ��ı�

	local nIndex = g_petNum;
	if WorkType ~=nil and WorkType == "ChangeModel" then	--�ı���۽���
		if m_NewModel ~= nil and m_NewModel >= 0 then	--ѡ�������
			if m_NewModel == 0 then
				nIndex = 3
			else
				nIndex = m_NewModel
			end
		else	--ûѡ����� Ĭ�ϵ�һ��ѡ��
			nIndex = 1
		end
	end
	--û��ԭʼ��� �� ����ѡ��ԭʼ��۵�BT���
	if(g_petNum < nIndex) then
		nIndex = 1
	end
	
	PetJian_List : SetItemSelectByItemID(nIndex - 1);
	PetJian_SelectOneType(nIndex);

end

function PetJian_Onshow()
	---------------------------------------------------------
	--DisableSomeThing
	local nIsBaiShou = DataPool:GetPlayerMission_DataRound(309)
	if(nIsBaiShou > 0) then
		-- PetJian_Proficient_Text:Show()
	else
		-- PetJian_Proficient_Text:Hide()
	end
	PetJian_FakeObject : SetFakeObject( "" );
	PetJianFood_Type   : Hide();
	PetJianAttack_Type : Hide();
	PetJian_NeedLevel  : Hide();
	PetJian_Model_TurnLeft : Disable();
	PetJian_Model_TurnRight: Disable();

	if(g_CurSel < 0 or g_petNum <= 0)then
		return;
	end
	PetJian_FakeObject : SetFakeObject( "" );
	DataPool : PetsOneType_SetModel(g_CurSel);
	---------------------------------------------------------------------
	-- fake obj
	PetJian_FakeObject : SetFakeObject("PetOneType_Pet");
	PetJian_Model_TurnLeft : Enable();
	PetJian_Model_TurnRight: Enable();
	PetJian_NeedLevel      : Show();
	---------------------------------------------------
	--get TakeLevel
	local nTakeLevel = DataPool : PetsOneType_GetAttr(g_CurSel,"takelevel");
	local strNeedLevelColor = "";
	local nTakeLevel_BaiShou = nTakeLevel
	local nIsBaiShou = DataPool:GetPlayerMission_DataRound(309)
	if(nIsBaiShou > 0) then
		nTakeLevel_BaiShou = nTakeLevel - 10
	    if nTakeLevel_BaiShou < 1 then
			nTakeLevel_BaiShou = 1
		end
	end
	if( nTakeLevel_BaiShou > Player:GetData( "LEVEL" ) )then
		strNeedLevelColor ="#cFF0000";
	else
		strNeedLevelColor ="#c00FF00";
	end
	local strNeedLevel = strNeedLevelColor..tostring( nTakeLevel ).."��#W��Я��";
	PetJian_NeedLevel:SetText( strNeedLevel );
	-----------------------------------------------------
	--get AttackTrait (��ȱ)
	strName,strIcon = DataPool : PetsOneType_GetAttr(g_CurSel,"attacktype");
	if strIcon ~= "" then
		PetJianAttack_Type : SetProperty( "Image", "set:Button6 image:"..strIcon )
		PetJianAttack_Type : SetToolTip(strName)
		PetJianAttack_Type : Show();
	end
	-----------------------------------------------------
	--get FoodType 
	local food = DataPool : PetsOneType_GetAttr(g_CurSel,"food");
	strName = "";
	if(food >= 1000) then
		strName = strName .. "��";
		food = food - 1000;
		if food > 0 then
			strName = strName .. ",";
		end
	end
	if(food >= 100) then
		strName = strName .. "��";
		food = food - 100;
		if food > 0 then
			strName = strName .. ",";
		end
	end
	if(food >= 10) then
		strName = strName .. "��";
		food = food - 10;
		if food > 0 then
			strName = strName .. ",";
		end
	end
	
	if(food >= 1) then
		strName = strName .. "��";
	end
	PetJianFood_Type : Show();
	PetJianFood_Type : SetToolTip( strName );
end

function PetJian_SelectOneType(typeIdx)
	if(g_CurSel + 1 == typeIdx or typeIdx < 1 or typeIdx > g_petNum) then
		return;
	end
	g_CurSel = typeIdx - 1;
	PetJian_Onshow();
end

function PetJian_List_Click()
	local typeIdx =  PetJian_List : GetFirstSelectItem();
	PetJian_SelectOneType(typeIdx + 1);
end

----------------------------------------------------------------------------------
--
-- ��ת����ģ�ͣ�����)
--
function PetJian_Modle_TurnLeft(start)
	--������ת��ʼ
	if(start == 1 and CEArg:GetValue("MouseButton")=="LeftButton") then
		PetJian_FakeObject:RotateBegin(-0.3);
	--������ת����
	else
		PetJian_FakeObject:RotateEnd();
	end
end

----------------------------------------------------------------------------------
--
--��ת����ģ�ͣ�����)
--
function PetJian_Modle_TurnRight(start)
	--������ת��ʼ
	if(start == 1 and CEArg:GetValue("MouseButton")=="LeftButton") then
		PetJian_FakeObject:RotateBegin(0.3);
	--������ת����
	else
		PetJian_FakeObject:RotateEnd();
	end
end

function PetJian_OnHiden()
	-- do nothing
	WorkType = ""
	m_NewModel = -1;
	m_IsHH = 0;
end

--================================================
-- �ָ������Ĭ�����λ��
--================================================
function PetJian_Frame_On_ResetPos()

	PetJian_Frame : SetProperty("UnifiedXPosition", g_PetJian_Frame_UnifiedXPosition);
	PetJian_Frame : SetProperty("UnifiedYPosition", g_PetJian_Frame_UnifiedYPosition);

end