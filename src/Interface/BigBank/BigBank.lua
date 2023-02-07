local g_BigInitiativeClose = 0;
local g_BigBank_Frame_UnifiedPosition;

--格子及其编号
local BIGBIGGRID_BUTTONS_NUM = 120;
local BIGGRID_BUTTONS = {};

local BIGGRID_SETS = {}

--未购买
local BigBank_UNBUY_NUM = 6
local BIGBANK_UNBUY_SET = {}

local BigBank_HaveItem = {}

--local BigBank_UNBUYTIP_SET = {}

--当前打开的租赁箱
local g_BigCurrentRentBox = 0; --0表示全部

local objBigCared = -1;
local MAX_BIG_OBJ_DISTANCE = 3.0;

local BigBank_BeginIndex = 0

local nBankGemPosID = {}
BigBank_AllEndIndex = 0

local BigBank_ItemID = {}
local BigBank_ItemNum = {}
--===============================================
-- OnLoad()
--===============================================
function BigBank_PreLoad()

	this:RegisterEvent("TOGLE_BigBank");
	this:RegisterEvent("UPDATE_BANK");
	this:RegisterEvent("OBJECT_CARED_EVENT");
		-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")

	-- 开始整理和结束整理
	this:RegisterEvent("BEGIN_PACKUP_BigBank")
	this:RegisterEvent("END_PACKUP_BigBank")

	this:RegisterEvent("HIDE_ON_SCENE_TRANSED") 
	this:RegisterEvent("PLAYER_LEAVE_WORLD");--切场景
	this:RegisterEvent("PLAYER_ENTER_WORLD");--切场景
	this:RegisterEvent("ON_SCENE_TRANS");--切场景
	this:RegisterEvent("ON_SERVER_TRANS");--切场景 
	this:RegisterEvent("UI_COMMAND");--切场景 
end

function BigBank_OnLoad()

	BIGGRID_BUTTONS[1]  = BigBank_Item1_1;
	BIGGRID_BUTTONS[2]  = BigBank_Item1_2;
	BIGGRID_BUTTONS[3]  = BigBank_Item1_3;
	BIGGRID_BUTTONS[4]  = BigBank_Item1_4;
	BIGGRID_BUTTONS[5]  = BigBank_Item1_5;
	BIGGRID_BUTTONS[6]  = BigBank_Item1_6;
	BIGGRID_BUTTONS[7]  = BigBank_Item1_7;
	BIGGRID_BUTTONS[8]  = BigBank_Item1_8;
	BIGGRID_BUTTONS[9]  = BigBank_Item1_9;
	BIGGRID_BUTTONS[10] = BigBank_Item1_10;
	BIGGRID_BUTTONS[11] = BigBank_Item1_11;
	BIGGRID_BUTTONS[12] = BigBank_Item1_12;
	BIGGRID_BUTTONS[13] = BigBank_Item1_13;
	BIGGRID_BUTTONS[14] = BigBank_Item1_14;
	BIGGRID_BUTTONS[15] = BigBank_Item1_15;
	BIGGRID_BUTTONS[16] = BigBank_Item1_16;
	BIGGRID_BUTTONS[17] = BigBank_Item1_17;
	BIGGRID_BUTTONS[18] = BigBank_Item1_18;
	BIGGRID_BUTTONS[19] = BigBank_Item1_19;
	BIGGRID_BUTTONS[20] = BigBank_Item1_20;

	BIGGRID_BUTTONS[21]  = BigBank_Item2_1;
	BIGGRID_BUTTONS[22]  = BigBank_Item2_2;
	BIGGRID_BUTTONS[23]  = BigBank_Item2_3;
	BIGGRID_BUTTONS[24]  = BigBank_Item2_4;
	BIGGRID_BUTTONS[25]  = BigBank_Item2_5;
	BIGGRID_BUTTONS[26]  = BigBank_Item2_6;
	BIGGRID_BUTTONS[27]  = BigBank_Item2_7;
	BIGGRID_BUTTONS[28]  = BigBank_Item2_8;
	BIGGRID_BUTTONS[29]  = BigBank_Item2_9;
	BIGGRID_BUTTONS[30] = BigBank_Item2_10;
	BIGGRID_BUTTONS[31] = BigBank_Item2_11;
	BIGGRID_BUTTONS[32] = BigBank_Item2_12;
	BIGGRID_BUTTONS[33] = BigBank_Item2_13;
	BIGGRID_BUTTONS[34] = BigBank_Item2_14;
	BIGGRID_BUTTONS[35] = BigBank_Item2_15;
	BIGGRID_BUTTONS[36] = BigBank_Item2_16;
	BIGGRID_BUTTONS[37] = BigBank_Item2_17;
	BIGGRID_BUTTONS[38] = BigBank_Item2_18;
	BIGGRID_BUTTONS[39] = BigBank_Item2_19;
	BIGGRID_BUTTONS[40] = BigBank_Item2_20;

	BIGGRID_BUTTONS[41]  = BigBank_Item3_1;
	BIGGRID_BUTTONS[42]  = BigBank_Item3_2;
	BIGGRID_BUTTONS[43]  = BigBank_Item3_3;
	BIGGRID_BUTTONS[44]  = BigBank_Item3_4;
	BIGGRID_BUTTONS[45]  = BigBank_Item3_5;
	BIGGRID_BUTTONS[46]  = BigBank_Item3_6;
	BIGGRID_BUTTONS[47]  = BigBank_Item3_7;
	BIGGRID_BUTTONS[48]  = BigBank_Item3_8;
	BIGGRID_BUTTONS[49]  = BigBank_Item3_9;
	BIGGRID_BUTTONS[50] = BigBank_Item3_10;
	BIGGRID_BUTTONS[51] = BigBank_Item3_11;
	BIGGRID_BUTTONS[52] = BigBank_Item3_12;
	BIGGRID_BUTTONS[53] = BigBank_Item3_13;
	BIGGRID_BUTTONS[54] = BigBank_Item3_14;
	BIGGRID_BUTTONS[55] = BigBank_Item3_15;
	BIGGRID_BUTTONS[56] = BigBank_Item3_16;
	BIGGRID_BUTTONS[57] = BigBank_Item3_17;
	BIGGRID_BUTTONS[58] = BigBank_Item3_18;
	BIGGRID_BUTTONS[59] = BigBank_Item3_19;
	BIGGRID_BUTTONS[60] = BigBank_Item3_20;

	BIGGRID_BUTTONS[61]  = BigBank_Item4_1;
	BIGGRID_BUTTONS[62]  = BigBank_Item4_2;
	BIGGRID_BUTTONS[63]  = BigBank_Item4_3;
	BIGGRID_BUTTONS[64]  = BigBank_Item4_4;
	BIGGRID_BUTTONS[65]  = BigBank_Item4_5;
	BIGGRID_BUTTONS[66]  = BigBank_Item4_6;
	BIGGRID_BUTTONS[67]  = BigBank_Item4_7;
	BIGGRID_BUTTONS[68]  = BigBank_Item4_8;
	BIGGRID_BUTTONS[69]  = BigBank_Item4_9;
	BIGGRID_BUTTONS[70] = BigBank_Item4_10;
	BIGGRID_BUTTONS[71] = BigBank_Item4_11;
	BIGGRID_BUTTONS[72] = BigBank_Item4_12;
	BIGGRID_BUTTONS[73] = BigBank_Item4_13;
	BIGGRID_BUTTONS[74] = BigBank_Item4_14;
	BIGGRID_BUTTONS[75] = BigBank_Item4_15;
	BIGGRID_BUTTONS[76] = BigBank_Item4_16;
	BIGGRID_BUTTONS[77] = BigBank_Item4_17;
	BIGGRID_BUTTONS[78] = BigBank_Item4_18;
	BIGGRID_BUTTONS[79] = BigBank_Item4_19;
	BIGGRID_BUTTONS[80] = BigBank_Item4_20;

	BIGGRID_BUTTONS[81]  = BigBank_Item5_1;
	BIGGRID_BUTTONS[82]  = BigBank_Item5_2;
	BIGGRID_BUTTONS[83]  = BigBank_Item5_3;
	BIGGRID_BUTTONS[84]  = BigBank_Item5_4;
	BIGGRID_BUTTONS[85]  = BigBank_Item5_5;
	BIGGRID_BUTTONS[86]  = BigBank_Item5_6;
	BIGGRID_BUTTONS[87]  = BigBank_Item5_7;
	BIGGRID_BUTTONS[88]  = BigBank_Item5_8;
	BIGGRID_BUTTONS[89]  = BigBank_Item5_9;
	BIGGRID_BUTTONS[90] = BigBank_Item5_10;
	BIGGRID_BUTTONS[91] = BigBank_Item5_11;
	BIGGRID_BUTTONS[92] = BigBank_Item5_12;
	BIGGRID_BUTTONS[93] = BigBank_Item5_13;
	BIGGRID_BUTTONS[94] = BigBank_Item5_14;
	BIGGRID_BUTTONS[95] = BigBank_Item5_15;
	BIGGRID_BUTTONS[96] = BigBank_Item5_16;
	BIGGRID_BUTTONS[97] = BigBank_Item5_17;
	BIGGRID_BUTTONS[98] = BigBank_Item5_18;
	BIGGRID_BUTTONS[99] = BigBank_Item5_19;
	BIGGRID_BUTTONS[100] = BigBank_Item5_20;

	BIGGRID_BUTTONS[101] = BigBank_Item6_1;
	BIGGRID_BUTTONS[102] = BigBank_Item6_2;
	BIGGRID_BUTTONS[103] = BigBank_Item6_3;
	BIGGRID_BUTTONS[104] = BigBank_Item6_4;
	BIGGRID_BUTTONS[105] = BigBank_Item6_5;
	BIGGRID_BUTTONS[106] = BigBank_Item6_6;
	BIGGRID_BUTTONS[107] = BigBank_Item6_7;
	BIGGRID_BUTTONS[108] = BigBank_Item6_8;
	BIGGRID_BUTTONS[109] = BigBank_Item6_9;
	BIGGRID_BUTTONS[110] = BigBank_Item6_10;
	BIGGRID_BUTTONS[111] = BigBank_Item6_11;
	BIGGRID_BUTTONS[112] = BigBank_Item6_12;
	BIGGRID_BUTTONS[113] = BigBank_Item6_13;
	BIGGRID_BUTTONS[114] = BigBank_Item6_14;
	BIGGRID_BUTTONS[115] = BigBank_Item6_15;
	BIGGRID_BUTTONS[116] = BigBank_Item6_16;
	BIGGRID_BUTTONS[117] = BigBank_Item6_17;
	BIGGRID_BUTTONS[118] = BigBank_Item6_18;
	BIGGRID_BUTTONS[119] = BigBank_Item6_19;
	BIGGRID_BUTTONS[120] = BigBank_Item6_20;

	BIGBANK_UNBUY_SET[1] = BigBank_Item1_Close;
	BIGBANK_UNBUY_SET[2] = BigBank_Item2_Close;
	BIGBANK_UNBUY_SET[3] = BigBank_Item3_Close;
	BIGBANK_UNBUY_SET[4] = BigBank_Item4_Close;
	BIGBANK_UNBUY_SET[5] = BigBank_Item5_Close;
	BIGBANK_UNBUY_SET[6] = BigBank_Item6_Close;

	--BigBank_UNBUYTIP_SET[1] = BigBank_Item1_Close_Tips
	--BigBank_UNBUYTIP_SET[2] = BigBank_Item2_Close_Tips
	--BigBank_UNBUYTIP_SET[3] = BigBank_Item3_Close_Tips
	--BigBank_UNBUYTIP_SET[4] = BigBank_Item4_Close_Tips
	--BigBank_UNBUYTIP_SET[5] = BigBank_Item5_Close_Tips
	--BigBank_UNBUYTIP_SET[6] = BigBank_Item6_Close_Tips
	--BigBank_UNBUYTIP_SET[7] = BigBank_Item7_Close_Tips

	BIGGRID_SETS[1] = BigBank_Item1_Set
	BIGGRID_SETS[2] = BigBank_Item2_Set
	BIGGRID_SETS[3] = BigBank_Item3_Set
	BIGGRID_SETS[4] = BigBank_Item4_Set
	BIGGRID_SETS[5] = BigBank_Item5_Set
	BIGGRID_SETS[6] = BigBank_Item6_Set


	g_BigBank_Frame_UnifiedPosition=BigBank_Frame:GetProperty("UnifiedPosition");

end


--===============================================
-- OnEvent
--===============================================
function BigBank_OnEvent(event)

	if(event == "UI_COMMAND" and tonumber(arg0) == 20220659) then
		nBankGemPosID = {}
		this:Show();
		g_BigInitiativeClose = 0;
		--关心NPC
		objCared = tonumber(arg1)
		this:CareObject(objCared, 1, "Bank");
		g_BigCurrentRentBox = 1;
		BigBank_UpdateFrame(1);
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("RestBankItemInfo");
			Set_XSCRIPT_ScriptID(791011);
			Set_XSCRIPT_Parameter(0, 1)
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT();	
		
		if IsWindowShow("YueKa") then
			CloseWindow("YueKa", true)
		end
	elseif(event == "UI_COMMAND" and tonumber(arg0) == 201107281 and this:IsVisible())  then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("AddItemBank");
			Set_XSCRIPT_ScriptID(791011);
			Set_XSCRIPT_Parameter(0,tonumber(arg1))
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT();		
	elseif(event == "UI_COMMAND" and tonumber(arg0) == 201107282 and this:IsVisible())  then
		BigBank_ItemID = {}
		BigBank_ItemNum = {}
		if Get_XParam_STR(0) ~= "" and Get_XParam_STR(0) ~= nil then
			local nItemID = Split(Get_XParam_STR(0), ",")
			local nItemNum = Split(Get_XParam_STR(1), ",")
			for i = 1,30 do
				BigBank_ItemID[i] = tonumber(nItemID[i])
				BigBank_ItemNum[i] = tonumber(nItemNum[i])
			end
		end
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("RestBankItemInfo");
			Set_XSCRIPT_ScriptID(791011);
			Set_XSCRIPT_Parameter(0, 2)
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT();	
	elseif(event == "UI_COMMAND" and tonumber(arg0) == 201107283 and this:IsVisible())  then
		--数据二次传输
		if Get_XParam_STR(0) ~= "" and Get_XParam_STR(0) ~= nil then
			local nItemID = Split(Get_XParam_STR(0), ",")
			local nItemNum = Split(Get_XParam_STR(1), ",")
			for i = 1,30 do
				BigBank_ItemID[i+30] = tonumber(nItemID[i])
				BigBank_ItemNum[i+30] = tonumber(nItemNum[i])
			end
		end
		BigBank_UpdateFrame(g_BigCurrentRentBox);
	elseif(event == "UI_COMMAND" and tonumber(arg0) == 201107284 and this:IsVisible())  then
		local nPos = Get_XParam_INT(0)
		local nItemID = Get_XParam_INT(1)
		local ItemNum = Get_XParam_INT(2)
		if Get_XParam_INT(1) == 0 then
			BIGGRID_BUTTONS[nPos]:SetActionItem(-1);
			BIGGRID_BUTTONS[nPos]:SetProperty("CornerChar", "BotRight ");
			if nPos > 60 then
				BigBank_ItemID[nPos-60] = 0
			end
		else
			local theAction = GemMelting:UpdateProductAction(nItemID);
			BIGGRID_BUTTONS[nPos]:SetActionItem(theAction:GetID());
			if nPos > 60 then
				BigBank_ItemID[nPos-60] = nItemID
				BigBank_ItemNum[nPos-60] = ItemNum
			end
			if ItemNum > 1 then
				BIGGRID_BUTTONS[nPos]:SetProperty("CornerChar", string.format( "BotRight %s", ItemNum));
			else
				BIGGRID_BUTTONS[nPos]:SetProperty("CornerChar", "BotRight ");
			end
		end
		BigBank_BeginIndex = 0
		BigBank_UpdateFrame(g_BigCurrentRentBox);
	elseif(event == "UPDATE_BANK" and this:IsVisible())  then
		BigBank_BeginIndex = 0
		BigBank_UpdateFrame(g_BigCurrentRentBox);
	elseif (event == "OBJECT_CARED_EVENT") then
		AxTrace(0, 0, "arg0"..arg0.." arg1"..arg1.." arg2"..arg2);
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_BIG_OBJ_DISTANCE or arg1=="destroy") then
			g_BigInitiativeClose = 1;
			this:Hide();
			Bank:Close();
			--取消关心
			this:CareObject(objCared, 0, "Bank");
		end
		-- 游戏窗口尺寸发生了变化
	elseif (event == "ADJEST_UI_POS" ) then
		BigBank_Frame_On_ResetPos()
	-- 游戏分辨率发生了变化
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		BigBank_Frame_On_ResetPos()

	--Disable“整理”
	elseif ( event == "BEGIN_PACKUP_BigBank" )   then
		BigBank_Classify:Disable()
	--Enable“整理”
	elseif ( event == "END_PACKUP_BigBank" )	    then
		BigBank_Classify:Enable()

	elseif (event == "PLAYER_ENTER_WORLD") or (event == "PLAYER_LEAVE_WORLD") or (event == "HIDE_ON_SCENE_TRANSED") then
		BigBank_Close_Clicked()
	end
end

--===============================================
-- BigBank_UpdateFrame
--===============================================
function BigBank_UpdateFrame(nIndex)
	
	Bank:SetCurRentIndex(1);
	--获得已经拥有的租赁箱个数
	local nRentNum = Bank:GetRentBoxNum();
	nRentNum = nRentNum + DataPool:GetPlayerMission_DataRound(252)

	--未购买
	for i=1, nRentNum do
		BIGBANK_UNBUY_SET[i]:Hide();
		BIGGRID_SETS[i]:Show()
	end

	for i = nRentNum + 1, BigBank_UNBUY_NUM do
		BIGBANK_UNBUY_SET[i]:Show();
		BIGGRID_SETS[i]:Hide()
	end

	--处理金钱
	local nMoney;
	local nGoldCoin;
	local nSilverCoin;
	local nCopperCoin;

	nMoney,nGoldCoin,nSilverCoin,nCopperCoin = Bank:GetBankMoney();
	BigBank_Money:SetProperty("MoneyNumber", tostring(nMoney));

	--获得这个背包可以使用的格子数
	local nBeginIndex,nGridNum = Bank:GetRentBoxInfo(nIndex);
	nGridNum = nRentNum * 20
	-- PushDebugMessage(nGridNum)
	for i=1, nGridNum do
		BIGGRID_BUTTONS[i]:Show();
		BIGGRID_BUTTONS[i]:SetActionItem(-1);
		BIGGRID_BUTTONS[i]:Enable();
	end
	for i=nGridNum+1 ,BIGBIGGRID_BUTTONS_NUM do
		BIGGRID_BUTTONS[i]:SetProperty("NormalImage","set:Common2 image:Unopened_Normal");
		BIGGRID_BUTTONS[i]:SetProperty("Empty","False");
		--设置四个角的数字，全设置为空
		BIGGRID_BUTTONS[i]:SetProperty("CornerChar","TopLeft ");
		BIGGRID_BUTTONS[i]:SetProperty("CornerChar","TopRight ");
		BIGGRID_BUTTONS[i]:SetProperty("CornerChar","BotLeft ");
		BIGGRID_BUTTONS[i]:SetProperty("CornerChar","BotRight ");
		BIGGRID_BUTTONS[i]:Disable();
		BIGGRID_BUTTONS[i]:Hide();
	end
	--从数据池中使用数据填入背包内的物品
	local nTotalNum = GetActionNum("BigBankitem"); 
	local nActIndex = nBeginIndex;
	local i=1;
	local Lock_Flag = 0
	for i=1, nGridNum  do
		local theAction, bLocked = Bank:EnumItem(nActIndex);
		nActIndex = nActIndex+1;
		if theAction:GetID() ~= 0 then
			BIGGRID_BUTTONS[i]:SetActionItem(theAction:GetID());
			if theAction:GetDefineID() >= 50101001 then
				table.insert(nBankGemPosID,i)
			end
			BigBank_HaveItem[i] = 1
			if(bLocked == true) then
				BIGGRID_BUTTONS[i]:Disable();
				Lock_Flag = 1
			else
				BIGGRID_BUTTONS[i]:Enable();
			end
		elseif i > 60 and BigBank_ItemID[i-60] ~= nil and BigBank_ItemID[i-60] ~= "" then
			if tonumber(BigBank_ItemID[i-60]) > 0 then
				local theAction = GemMelting:UpdateProductAction(tonumber(BigBank_ItemID[i-60]));
				if theAction:GetID() ~= 0 then
					BigBank_HaveItem[i] = 1
					BIGGRID_BUTTONS[i]:SetActionItem(theAction:GetID());
					if tonumber(BigBank_ItemNum[i-60]) > 1 then
						BIGGRID_BUTTONS[i]:SetProperty("CornerChar", string.format( "BotRight %s", tonumber(BigBank_ItemNum[i-60])));
					else
						BIGGRID_BUTTONS[i]:SetProperty("CornerChar", "BotRight ");
					end
				end
			end
		else
			BIGGRID_BUTTONS[i]:SetActionItem(-1);
			BigBank_HaveItem[i] = 0
		end
	end
	--自动选择储物格
	for i = 1,table.getn(BigBank_HaveItem) do
		if BigBank_HaveItem[i] == 0 then
			if i <= 20 then
				Bank:SetCurRentIndex(1);
				break
			elseif i > 20 and i <= 40 then
				Bank:SetCurRentIndex(2);
				break
			elseif i > 40 and i <= 60 then
				Bank:SetCurRentIndex(3);
				break
			end
		end
		BigBank_AllEndIndex = i
	end
	-- PushDebugMessage(BigBank_AllEndIndex)
	if Lock_Flag == 0 then
		BigBank_Classify:Enable()
	else
		BigBank_Classify:Disable()
	end
end
--===============================================
-- 取出钱庄物品
--===============================================
function BigBank_DoAction(nIndex)
	if nIndex > 60 then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("OutBankItem");
			Set_XSCRIPT_ScriptID(791011);--nTheTabIndex
			Set_XSCRIPT_Parameter(0, nIndex)
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT();
	else
		BIGGRID_BUTTONS[nIndex]:DoAction()
	end
	for i = 1,table.getn(nBankGemPosID) do
		if nBankGemPosID[i] == nIndex then
			RePacketGemInfo()
			break
		end
	end	
end
--===============================================
-- 打开存钱的对话框
--===============================================
function BigBank_Save_Clicked()
	Bank:OpenSaveFrame();
end

--===============================================
-- 打开取钱的对话框
--===============================================
function BigBank_Get_Clicked()
	Bank:OpenGetFrame();
end


--===============================================
-- 点击关闭
--===============================================
function BigBank_Close_Clicked()
	Bank_AllEndIndex = 0
	if(g_BigInitiativeClose == 1)  then
		return;
	end
	this:Hide();
	Bank:Close();
end


--========================================================================
--
-- 设置二级密码。
--
--========================================================================
function BigBank_SuperPassword_Clicked()

		Player:SetSupperPassword();
end

--显示小银行
function BigBank_ShowAllOff_Clicked()
	SetOpenWhichBank(0)
	PushEvent("TOGLE_BANK", Bank:GetNpcId())
	this:Hide()
end


--================================================
-- 恢复界面的默认相对位置
--================================================
function BigBank_Frame_On_ResetPos()
  BigBank_Frame:SetProperty("UnifiedPosition", g_BigBank_Frame_UnifiedPosition);
end

function BigBank_PackUp_Clicked()
end
