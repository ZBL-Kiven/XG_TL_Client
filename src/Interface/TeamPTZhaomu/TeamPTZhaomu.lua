local MENPAI_BUTTON= {}; --门派单选
local MENPAI_NUM = 11; --门派个数，包括任意
local MENPAI_NAME = {
	"#{ZDPT_XML_31}",
	"#{GMGameInterface_Script_DataPool_Info_ShaoLin}",
	"#{GMGameInterface_Script_DataPool_Info_Mingjiao}",
	"#{GMGameInterface_Script_DataPool_Info_GaiBang}",
	"#{GMGameInterface_Script_DataPool_Info_WuDang}",
	"#{GMGameInterface_Script_DataPool_Info_EMei}",
	"#{GMGameInterface_Script_DataPool_Info_XingXiu}",
	"#{GMGameInterface_Script_DataPool_Info_DaLi}",
	"#{GMGameInterface_Script_DataPool_Info_TianShan}",
	"#{GMGameInterface_Script_DataPool_Info_XiaoYao}",
	"#{GMGameInterface_Script_DataPool_Info_GuSu}",
}

local MENPAI_STATUS = { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0};

local g_isModify = 0;

function TeamPTZhaomu_PreLoad()
	this:RegisterEvent("OPEN_WINDOW");
	this:RegisterEvent("CLOSE_WINDOW");
	this:RegisterEvent("TEAMBOARD_MODIFY_TEAM");
end

function TeamPTZhaomu_OnLoad()
	MENPAI_BUTTON[1] = TeamPTZhaomu_RenyiInfo;
	MENPAI_BUTTON[2] = TeamPTZhaomu_SlInfo;
	MENPAI_BUTTON[3] = TeamPTZhaomu_MjInfo;
	MENPAI_BUTTON[4] = TeamPTZhaomu_GbInfo;
	MENPAI_BUTTON[5] = TeamPTZhaomu_WdInfo;
	MENPAI_BUTTON[6] = TeamPTZhaomu_EmInfo;
	MENPAI_BUTTON[7] = TeamPTZhaomu_XxInfo;
	MENPAI_BUTTON[8] = TeamPTZhaomu_TlInfo;
	MENPAI_BUTTON[9] = TeamPTZhaomu_TsInfo;
	MENPAI_BUTTON[10] = TeamPTZhaomu_XyInfo;

	TeamPTZhaomu_Mudi:ResetList()
	local num = DataPool : GetTeamBoardGoalNum();
	if (num > 0) then
		for i = 0, num-1 do
			local _id,_name =DataPool : EnumTeamBoardGoal(i);
			if( _id >= 0 ) then
				TeamPTZhaomu_Mudi:ComboBoxAddItem(_name,_id);
			end
		end
	end
end

--初始化窗口的一些参数
function TeamPTZhaomu_InitWindow()
	TeamPTZhaomu_EditName:SetText(ParserString("ZDPT_091028_14","NoColor"))
	TeamPTZhaomu_NumericalValue1:SetText("10");
	TeamPTZhaomu_NumericalValue2:SetText("119");
	MENPAI_BUTTON_SetCheck(1,1); --默认 任意
	MENPAI_STATUS[1] = 1;
	for i=2, MENPAI_NUM do
		MENPAI_BUTTON_SetCheck(i,0);
		MENPAI_STATUS[i] = 0;
	end
	TeamPTZhaomu_Mudi: SetCurrentSelect(0)--默认 任意;
	UpdataMenpaiText();
	TeamPTZhaomu_Cancel: SetText("#{INTERFACE_XML_542}");
	g_isModify = 0;
end

function TeamPTZhaomu_OnEvent( event )
	if(event == "OPEN_WINDOW") then
		if( arg0 == "TeamPTZhaomuWindow") then
			--如果已经显示就应该关掉
			if ( this:IsVisible() ) then
				this:Hide();
				return;
			end
			TeamPTZhaomu_InitWindow();
			CloseWindow("TeamPTFindWindow")
			this:Show();
		end

	elseif(event == "CLOSE_WINDOW") then
		if( arg0 == "TeamPTZhaomuWindow") then
			this:Hide();
		end
	elseif(event == "TEAMBOARD_MODIFY_TEAM") then
		TeamPTZhaomu_Modify(arg0,arg1,arg2,arg3,arg4)
		this:Show();
	end
end

function TeamPTZhaomu_Modify(strTopic,strGoal,strMenpaiList,strMinLevel,strMaxLevel)
	TeamPTZhaomu_EditName:SetText(strTopic);
	TeamPTZhaomu_NumericalValue1:SetText(strMinLevel);
	TeamPTZhaomu_NumericalValue2:SetText(strMaxLevel);
	local Menpai = ""; --框中显示的内容
	local TipsMenpai =""; --tips
	for i=1, MENPAI_NUM do
		if string.byte(strMenpaiList,i) == 49 then  --对应字符为1
			MENPAI_BUTTON_SetCheck(i,1);
		end
	end
	TeamPTZhaomu_Mudi: SetCurrentSelect(tonumber(strGoal))--默认 任意;
	TeamPTZhaomu_Cancel: SetText("#{ZDPT_XML_23}");
	UpdataMenpaiText();
	g_isModify = 1;

end

--确认发布按钮
function TeamPTZhaomu_Accept_Clicked()
	if( tonumber( Player:IsLeader() ) ~= 1 ) then
		--不是队长
		PushDebugMessage("#{ZDPT_091028_3}");
		return;
	end

	local strTopic = TeamPTZhaomu_EditName:GetText();
	if( strTopic == "" ) then
		PushDebugMessage("#{ZDPT_091028_15}");
		return;
	end
	local strGoal, nGoalIndex = TeamPTZhaomu_Mudi:GetCurrentSelect();

	local strMinLevel = TeamPTZhaomu_NumericalValue1:GetText();
	local strMaxLevel = TeamPTZhaomu_NumericalValue2:GetText();

	if( strMinLevel == nil or strMaxLevel == nil or strMinLevel == "" or strMaxLevel == "") then
		PushDebugMessage("#{ZDPT_091028_17}");
		return
	end

	local nMinLevel = tonumber(strMinLevel);
	local nMaxLevel = tonumber(strMaxLevel);

	if nMinLevel < 1 or nMaxLevel > 119 then
		PushDebugMessage("#{ZDPT_091028_17}");
		return
	end

	if nMinLevel < 10 then
		PushDebugMessage("#{ZDPT_091028_20}");
		return
	end

	if nMinLevel > nMaxLevel then
		PushDebugMessage("#{ZDPT_091028_4}");
		return
	end
	local bAllNoCheckNum = 0;
	local strMenpai ="";
	for i=1, MENPAI_NUM do
		if "True" == MENPAI_BUTTON_GetSelected(i) then
			strMenpai = strMenpai.."1";
		else
			strMenpai = strMenpai.."0";
			bAllNoCheckNum = bAllNoCheckNum + 1;
		end
	end

	if bAllNoCheckNum == MENPAI_NUM then
		--所有的按钮都没按下
		PushDebugMessage("#{ZDPT_091028_18}")
		return
	end

	if TeamBoardDataPool:SendTeamSeekInfo(strTopic,nGoalIndex,strMenpai,nMinLevel,nMaxLevel,g_isModify) < 0 then
		return;
	end
	this:Hide();
end

--作废按钮
function TeamPTZhaomu_Cancel_Clicked()
	if g_isModify == 0 then
		this:Hide();
	else
		DataPool:OpenDelCheckBox(1);
	end
end

--关闭按钮
function TeamPTZhaomu_Close_Clicked()
	this:Hide();
end


function MENPAI_BUTTON_SetCheck(idx,val)
	if not idx then return; end
	if not val then return; end

	if MENPAI_BUTTON[idx] then
		MENPAI_BUTTON[idx]:SetCheck(val);
	end
end

function MENPAI_BUTTON_GetSelected(idx)
	if not idx then return "False"; end
	if MENPAI_BUTTON[idx] then
		return MENPAI_BUTTON[idx]:GetProperty("Selected");
	end
	return "False";
end

function MENPAI_BUTTON_Disable(idx)
	if not idx then return "False"; end
	if MENPAI_BUTTON[idx] then
		MENPAI_BUTTON[idx]:Disable();
	end
end

function MENPAI_BUTTON_Enable(idx)
	if not idx then return "False"; end
	if MENPAI_BUTTON[idx] then
		MENPAI_BUTTON[idx]:Enable();
	end
end

--点击门派后刷新“需求门派”Text显示
function UpdataMenpaiText()
	local Menpai = ""; --框中显示的内容
	local TipsMenpai =""; --tips
	local Num = 0;
	for i=1, MENPAI_NUM do
		if MENPAI_STATUS[i] == 1 then
			if Num == 0 then
				Menpai = MENPAI_NAME[i];
				TipsMenpai = MENPAI_NAME[i];
			else
				if Num < 3 then
					Menpai = Menpai..","..MENPAI_NAME[i];
					TipsMenpai = TipsMenpai..","..MENPAI_NAME[i];
				elseif Num == 3 then
					Menpai = Menpai.."...";
					TipsMenpai = TipsMenpai..","..MENPAI_NAME[i];
				elseif Num > 3 then
					TipsMenpai = TipsMenpai..","..MENPAI_NAME[i];
				end
			end
			Num = Num + 1;
		end
	end
	TeamPTZhaomu_Zhiye:SetText(Menpai);
	TeamPTZhaomu_Zhiye:SetToolTip(TipsMenpai);

end

--点击任意
--注意：这里是button down的事件，button down的时候，还没触发按钮切换状态，所以是反的
function TeamPTZhaomu_Renyi_Button_Down()
	if("False" == TeamPTZhaomu_RenyiInfo:GetProperty("Selected")) then
		--马上会切换回True
		MENPAI_STATUS[1] = 1;
		for i=2, MENPAI_NUM do
			MENPAI_BUTTON_SetCheck(i,0);
			MENPAI_STATUS[i] = 0;
		end
	else
		MENPAI_STATUS[1] = 0;
	end

	UpdataMenpaiText();
end

--点击其他门派
function TeamPTZhaomu_Other_Button_Down(nButtonIndex)
	if("True" == TeamPTZhaomu_RenyiInfo:GetProperty("Selected") ) then
		MENPAI_BUTTON_SetCheck(1,0);
		MENPAI_STATUS[1] = 0;
	end

	local bAllCheck = 1;
	for i=2, MENPAI_NUM do
		if i == nButtonIndex then
			if "True" == MENPAI_BUTTON_GetSelected(i) then
				bAllCheck = 0;
				break;
			end
		else
			if "False" == MENPAI_BUTTON_GetSelected(i) then
				bAllCheck = 0;
				break;
			end
		end
	end

	--如果全部都选定，则帮助他改变为任意
	if bAllCheck == 1 then
		MENPAI_BUTTON_SetCheck(1,1);
		MENPAI_STATUS[1] = 1;
		for i=2, MENPAI_NUM do
			MENPAI_STATUS[i] = 0;
			if i ~= nButtonIndex then
				MENPAI_BUTTON_SetCheck(i,0);
			else
				MENPAI_BUTTON_SetCheck(i,1);
			end
		end
	else
		if MENPAI_STATUS[nButtonIndex] == 1 then
			MENPAI_STATUS[nButtonIndex] = 0;
		else
			MENPAI_STATUS[nButtonIndex] = 1;
		end
	end

	UpdataMenpaiText();
end


function TeamPTZhaomu_ComboListChanged()
end
