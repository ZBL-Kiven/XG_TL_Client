--珍兽图鉴
--build 2019-8-6 16:04:30 逍遥子
local g_petNum = 0;
local g_CurSel = -1;
local g_Icon = "";

local Max_BtnNum = 10;
local PetNames = {
	"成年珍兽",
	"珍兽宝宝",
	"1级变异",
	"2级变异",
	"3级变异",
	"4级变异",
	"5级变异",
	"6级变异",
	"7级变异",
	"8级变异",
};
local PetNames_HH = {
	"幻化外观1",
	"幻化外观2",
	"幻化外观3",
	"幻化外观4",
	"幻化外观5",
	"幻化外观6",
	"幻化外观7",
	"幻化外观8",
	"幻化外观9",
	"幻化外观10",
};
local PetNames_ChangeModel = {
	"幻化外观1",
	"幻化外观2",
	"原有珍兽外观",
	"原有珍兽外观",
	"原有珍兽外观",
	"原有珍兽外观",
	"原有珍兽外观",
	"原有珍兽外观",
	"原有珍兽外观",
	"原有珍兽外观",
};

-- 界面的默认相对位置
local g_PetJian_Frame_UnifiedXPosition;
local g_PetJian_Frame_UnifiedYPosition;

local m_IsHH = 0
local WorkType = "";
local m_NewModel = -1;
function PetJian_PreLoad()
	this:RegisterEvent("OPEN_PETJIAN_DLG");
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED");
	this:RegisterEvent("UI_COMMAND");
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")

	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function PetJian_OnLoad()

	-- 保存界面的默认相对位置
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
	-- 游戏窗口尺寸发生了变化
	if (event == "ADJEST_UI_POS" ) then
		-- 更新背包界面位置
		PetJian_Frame_On_ResetPos()

	-- 游戏分辨率发生了变化
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		-- 更新背包界面位置	
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
		if WorkType ~=nil and WorkType == "ChangeModel" then --改变外观
			PetJian_List : AddItem(PetNames_ChangeModel[i], i-1);
		else --幻化 或 珍兽界面
			if m_IsHH == 1 then
				PetJian_List : AddItem(PetNames_HH[i], i-1);
			else
				PetJian_List : AddItem(PetNames[i], i-1);
			end
		end
	end
	--默认选中最后一个 如果是改变珍兽外观界面则根据选项改变

	local nIndex = g_petNum;
	if WorkType ~=nil and WorkType == "ChangeModel" then	--改变外观界面
		if m_NewModel ~= nil and m_NewModel >= 0 then	--选了新外观
			if m_NewModel == 0 then
				nIndex = 3
			else
				nIndex = m_NewModel
			end
		else	--没选新外观 默认第一个选中
			nIndex = 1
		end
	end
	--没有原始外观 又 点了选中原始外观的BT情况
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
	local strNeedLevel = strNeedLevelColor..tostring( nTakeLevel ).."级#W可携带";
	PetJian_NeedLevel:SetText( strNeedLevel );
	-----------------------------------------------------
	--get AttackTrait (暂缺)
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
		strName = strName .. "肉";
		food = food - 1000;
		if food > 0 then
			strName = strName .. ",";
		end
	end
	if(food >= 100) then
		strName = strName .. "草";
		food = food - 100;
		if food > 0 then
			strName = strName .. ",";
		end
	end
	if(food >= 10) then
		strName = strName .. "虫";
		food = food - 10;
		if food > 0 then
			strName = strName .. ",";
		end
	end
	
	if(food >= 1) then
		strName = strName .. "谷";
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
-- 旋转珍兽模型（向左)
--
function PetJian_Modle_TurnLeft(start)
	--向左旋转开始
	if(start == 1 and CEArg:GetValue("MouseButton")=="LeftButton") then
		PetJian_FakeObject:RotateBegin(-0.3);
	--向左旋转结束
	else
		PetJian_FakeObject:RotateEnd();
	end
end

----------------------------------------------------------------------------------
--
--旋转珍兽模型（向右)
--
function PetJian_Modle_TurnRight(start)
	--向右旋转开始
	if(start == 1 and CEArg:GetValue("MouseButton")=="LeftButton") then
		PetJian_FakeObject:RotateBegin(0.3);
	--向右旋转结束
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
-- 恢复界面的默认相对位置
--================================================
function PetJian_Frame_On_ResetPos()

	PetJian_Frame : SetProperty("UnifiedXPosition", g_PetJian_Frame_UnifiedXPosition);
	PetJian_Frame : SetProperty("UnifiedYPosition", g_PetJian_Frame_UnifiedYPosition);

end