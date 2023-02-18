
local XINFA_BUTTONS_NUM = 8;
local XINFA_BUTTONS = {};

local SKILL_BUTTONS_NUM = 5;
local SKILL_BUTTONS = {};

local g_XinfaID = {};
local g_XinfaDefineID = {};

local g_SkillID = {};

-- 当前选中的Button，如果选中的是Xinfa，值等于Xinfa的nIndex
-- 									 如果选中的是Skill，值等于Skill的nIndex + XINFA_BUTTONS_NUM
local g_CurSelectButton;

-- 当前选中的心法
local g_CurSelect;

--当前选中的心法Id
local g_CurSelectXinfaId;

local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;


local MenPai_UsedAttr = {
[0] = {image = "set:Menpaishuxing image:Shuxing_Dark", Tooltip = "MPZSX_20071221_13", },			--少林
[1] = {image = "set:Menpaishuxing image:Shuxing_Fire", Tooltip = "MPZSX_20071221_12",},			--明教
[2] = {image = "set:Menpaishuxing image:Shuxing_PoisonFire", Tooltip = "MPZSX_20071221_15",},		--丐帮
[3] = {image = "set:Menpaishuxing image:Shuxing_DarkIce", Tooltip = "MPZSX_20071221_16",},		--武当
[4] = {image = "set:Menpaishuxing image:Shuxing_IceDark", Tooltip = "MPZSX_20071221_17",},		--峨眉
[5] = {image = "set:Menpaishuxing image:Shuxing_Poison", Tooltip = "MPZSX_20071221_14",},			--星宿
[6] = {image = "set:Menpaishuxing image:Shuxing_FIPD", Tooltip = "MPZSX_20071221_18",}, --天龙
[7] = {image = "set:Menpaishuxing image:Shuxing_Ice", Tooltip = "MPZSX_20071221_11",},			--天山
[8] = {image = "set:Menpaishuxing image:Shuxing_FirePoison", Tooltip = "MPZSX_20071221_19",},		--逍遥
[9] = {image = "", Tooltip = "无门派",},	--无门派
[10]= {image = "set:CommonFrame38 image:Shuxing_ManTuoDarkPoison", Tooltip = "MPZSX_20071221_20",},				--mtsz
};



--===============================================
-- OnLoad()
--===============================================
function ActionSkillsStudy_PreLoad()

	this:RegisterEvent("TOGLE_SKILLSTUDY");
	this:RegisterEvent("SKILLSTUDY_SUCCEED");
	this:RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("UNIT_EXP");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("UNIT_LEVEL");
	this:RegisterEvent("MONEYJZ_CHANGE");
	this:RegisterEvent("UI_COMMAND");
	
end

function ActionSkillsStudy_OnLoad()
	XINFA_BUTTONS[1] = ActionSkillsStudy_XinfaSkill_1;
	XINFA_BUTTONS[2] = ActionSkillsStudy_XinfaSkill_2;
	XINFA_BUTTONS[3] = ActionSkillsStudy_XinfaSkill_3;
	XINFA_BUTTONS[4] = ActionSkillsStudy_XinfaSkill_4;
	XINFA_BUTTONS[5] = ActionSkillsStudy_XinfaSkill_5;
	XINFA_BUTTONS[6] = ActionSkillsStudy_XinfaSkill_6;
	XINFA_BUTTONS[7] = ActionSkillsStudy_XinfaSkill_7;
	XINFA_BUTTONS[8] = ActionSkillsStudy_XinfaSkill_8;

	SKILL_BUTTONS[1] = ActionSkillsStudy_ZhaoshiSkill_1;
	SKILL_BUTTONS[2] = ActionSkillsStudy_ZhaoshiSkill_2;
	SKILL_BUTTONS[3] = ActionSkillsStudy_ZhaoshiSkill_3;
	SKILL_BUTTONS[4] = ActionSkillsStudy_ZhaoshiSkill_4;
	SKILL_BUTTONS[5] = ActionSkillsStudy_ZhaoshiSkill_5;

	g_CurSelectButton = 1;
	g_CurSelect				= 1;

end

--===============================================
-- ActionSkillsStudy_OnEvent
--===============================================
function ActionSkillsStudy_OnEvent(event)

	if(event == "TOGLE_SKILLSTUDY") then
		--关心NPC
		objCared = tonumber(arg0);
		this:CareObject(objCared, 1, "ActionSkillsStudy");

		this:Show();
		ActionSkillsStudy_UpdateFrame();
		ActionSkillsStudy_NpcName:SetText("#gFF0FA0" ..Target:GetXinfaNpcName());

	--刷新金钱
	elseif(event == "UNIT_MONEY") then
		local nMoneyNow,nGold,nSilverCoin,nCopperCoin = Player:GetData("MONEY");

		ActionSkillsStudy_Currently_Money:SetProperty("MoneyNumber", tostring(nMoneyNow));
	--刷新交子
	elseif (event == "MONEYJZ_CHANGE") then
		ActionSkillsStudy_Currently_Jiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));	
	--刷新经验值
	elseif(event == "UNIT_EXP") then

		local nExpNow = Player:GetData("EXP");
		ActionSkillsStudy_CurrentlyExp_Character_Text:SetText("当前经验:" .. tostring(nExpNow));
	
	-- 人物升级
	elseif(event == "UNIT_LEVEL") then
		ActionSkillsStudy_UpdateFrame();
	elseif(event == "UI_COMMAND" and tonumber(arg0) == 201812202) then
		ActionSkillsStudy_UpdateFrame();
	elseif(event == "SKILLSTUDY_SUCCEED") then
		ActionSkillsStudy_UpdateFrame();

	elseif (event == "OBJECT_CARED_EVENT") then
		--AxTrace(0, 0, "arg0"..arg0.." arg1"..arg1.." arg2"..arg2);
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			this:Hide();

			--取消关心
			this:CareObject(objCared, 0, "ActionSkillsStudy");
		end

	end
end

--===============================================
-- UpdateFrame
--===============================================
function ActionSkillsStudy_UpdateFrame()

	-- Xinfa
	local i=1;
	local nActionIndex = 0;
	
	local nPlayerLevel = Player:GetData("LEVEL")

	--绘制心法图标
	while i<= XINFA_BUTTONS_NUM do

		local theAction = EnumAction(nActionIndex, "xinfa");

		if (theAction:GetID() == 0) then
			XINFA_BUTTONS[i]:SetActionItem(-1);
			g_XinfaID[i] = -1;
			g_XinfaDefineID[i] = -1;
		else
			XINFA_BUTTONS[i]:SetActionItem(theAction:GetID());
			--记录每个格子的心法ID
			g_XinfaID[i] = theAction:GetID();
			g_XinfaDefineID[i] = theAction:GetDefineID();
			
			-- 如果玩家不到20级，那么他将有部分的心法不能升级
			if nPlayerLevel < 20  then
				XINFA_BUTTONS[2]:Disable()
				XINFA_BUTTONS[3]:Disable()
				XINFA_BUTTONS[6]:Disable()
			else
				XINFA_BUTTONS[2]:Enable()
				XINFA_BUTTONS[3]:Enable()
				XINFA_BUTTONS[6]:Enable()
			end
		end


		i = i+1;
		nActionIndex = nActionIndex + 1;

	end

	--玩家身上金钱
	local nMoneyNow,nGold,nSilverCoin,nCopperCoin = Player:GetData("MONEY");

	ActionSkillsStudy_Currently_Money:SetProperty("MoneyNumber", tostring(nMoneyNow));
	ActionSkillsStudy_Currently_Jiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
	--ActionSkillsStudy_Icon_Gold_Currently_Text:SetText(tostring(nGold));
	--ActionSkillsStudy_Icon_Silver_Currently_Text:SetText(tostring(nSilverCoin));
	--ActionSkillsStudy_Icon_CopperCoin_Currently_Text:SetText(tostring(nCopperCoin));

	--玩家已经取得的经验
	local nExpNow = Player:GetData("EXP");
	ActionSkillsStudy_CurrentlyExp_Character_Text:SetText("当前经验:" .. tostring(nExpNow));

	--更新当前选中的心法的技能
	ActionSkillsStudy_Xinfa_Clicked(g_CurSelect);
	--更新主属性信息
	ActionSkillsStudy_UpdateMenPaiText();

end

--===============================================
-- 技能的更新绘制
--===============================================
function ActionSkillsStudy_UpdateSkill( nIndex )

	for i=1, SKILL_BUTTONS_NUM do
		SKILL_BUTTONS[i]:SetActionItem(-1);
		g_SkillID[i] = -1;
	end

		local nSumSkill = GetActionNum("skill");
		local nSkillIndex = 1;

		--AxTrace(0,0,"nSumSkill = ".. nSumSkill);


		for i=1, nSumSkill do
			theAction = EnumAction(i-1, "skill");

			if theAction:GetOwnerXinfa() == g_XinfaID[nIndex] then
				SKILL_BUTTONS[nSkillIndex]:SetActionItem(theAction:GetID());
				g_SkillID[nSkillIndex] = theAction:GetID();
				--AxTrace(0,0,"g_SkillID[nSkillIndex] = ".. g_SkillID[nSkillIndex]);
				nSkillIndex = nSkillIndex+1;
			end
		end
end

--===============================================
-- 更新一个技能图标的操作
--===============================================
function ActionSkillsStudy_SkillInfo_Update( SkillID )

	--ActionSkillsStudy_XinfaSkillIcon_Frame:Hide();
	ActionSkillsStudy_XinfaIcon:Hide();
	--ActionSkillsStudy_ZhaoshiSkillIcon_Frame:Show();
	ActionSkillsStudy_SkillIcon:Show();

	ActionSkillsStudy_SkillIcon:SetActionItem( -1 );
	ActionSkillsStudy_SkillIcon:SetActionItem( SkillID );

	if(SkillID == -1)then

		--清空技能
		ActionSkillsStudy_SkillName:SetText("");
		ActionSkillsStudy_SkillLevel:SetText("");
		ActionSkillsStudy_SkillInfo:SetText("");

		return;
	end

	local nSkillId = LifeAbility : GetLifeAbility_Number(SkillID);


	--更新技能信息
	local szInfo = Player:GetSkillInfo(nSkillId,"explain");
	local szName = Player:GetSkillInfo(nSkillId,"name");
	--local szSkillData = Player:GetSkillInfo(nSkillId,"skilldata");

	ActionSkillsStudy_SkillName:SetText(szName);
	ActionSkillsStudy_SkillLevel:SetText("");
	ActionSkillsStudy_SkillInfo:SetText(szInfo);

end

--===============================================
-- 更新一个心法图标的操作
--===============================================
function ActionSkillsStudy_XinfaInfo_Update( nIndex )--XinfaID

	ActionSkillsStudy_SkillIcon:Hide();
	--ActionSkillsStudy_ZhaoshiSkillIcon_Frame:Hide();
	ActionSkillsStudy_XinfaIcon:Show();
	--ActionSkillsStudy_XinfaSkillIcon_Frame:Show();

	ActionSkillsStudy_XinfaIcon:SetActionItem( -1 );
	ActionSkillsStudy_XinfaIcon:SetActionItem( g_XinfaID[nIndex] );

	--获得现在的心法等级
	local nXinfaLevel = GetXinfaLevel( g_XinfaDefineID[nIndex] );
	local NeedMoney,NeedExp = GetXinFaStudyInfo(sceneId,selfId,g_XinfaDefineID[nIndex],nXinfaLevel + 1)
	local menpaiID = Player : GetData("MEMPAI");		--获取玩家门派ID
	
	--获得升级心法需要的金钱
	local nMoneyNow,nGold,nSilverCoin,nCopperCoin = GetUplevelXinfaSpendMoney(g_XinfaDefineID[nIndex],nXinfaLevel + 1);
	--获得升级心法需要的经验
	local nExp = GetUplevelXinfaSpendExp(g_XinfaDefineID[nIndex],nXinfaLevel + 1);
	if menpaiID >= 10 then
		nMoneyNow = NeedMoney
		nExp = NeedExp
	end
	--ActionSkillsStudy_Demand_Money:SetProperty("MoneyNumber", tostring(nMoneyNow));
	ActionSkillsStudy_Demand_Jiaozi:SetProperty("MoneyNumber", tostring(nMoneyNow));
	--ActionSkillsStudy_Icon_Gold_Demand_Text:SetText(tostring(nGold));
	--ActionSkillsStudy_Icon_Silver_Demand_Text:SetText(tostring(nSilverCoin));
	--ActionSkillsStudy_Icon_CopperCoin_Demand_Text:SetText(tostring(nCopperCoin));

	ActionSkillsStudy_DemandExp_Character_Text:SetText("所需经验:" .. tostring(nExp));

end
function GetXinFaStudyInfo(sceneId,selfId,XinFaID,nXinFaLevel)
	XinFaID = XinFaID - 63
	local XinFa_V1 = {
		{5,8,28,23,28,23,8,11,8,11,28,23,30,30},
		{10,27,56,81,56,81,15,41,15,41,56,81,60,108},
		{15,53,84,158,84,158,23,79,23,79,84,158,90,210},
		{20,96,112,288,112,288,30,144,30,144,112,288,120,384},
		{25,149,140,446,140,446,38,223,38,223,140,446,150,594},
		{30,218,168,653,168,653,45,326,45,326,168,653,180,870},
		{35,306,196,917,196,917,53,458,53,458,196,917,210,1222},
		{40,414,224,1242,224,1242,60,621,60,621,224,1242,240,1656},
		{45,468,252,1404,252,1404,68,702,68,702,252,1404,270,1872},
		{50,525,280,1575,280,1575,75,788,75,788,280,1575,300,2100},
		{55,585,308,1755,308,1755,83,878,83,878,308,1755,330,2340},
		{60,648,336,1944,336,1944,90,972,90,972,336,1944,360,2592},
		{65,740,364,2219,364,2219,98,1109,98,1109,364,2219,390,2958},
		{70,837,392,2511,392,2511,105,1256,105,1256,392,2511,420,3348},
		{75,969,420,2907,420,2907,113,1454,113,1454,420,2907,450,3876},
		{84,1110,470,3330,470,3330,126,1665,126,1665,470,3330,504,4440},
		{108,1292,602,3875,602,3875,161,1937,161,1937,602,3875,645,5166},
		{135,1518,756,4554,756,4554,203,2277,203,2277,756,4554,810,6072},
		{168,1794,940,5382,940,5382,252,2691,252,2691,940,5382,1008,7176},
		{286,2124,1602,6372,1602,6372,429,3186,429,3186,1602,6372,1716,8496},
		{352,2513,1970,7538,1970,7538,528,3769,528,3769,1970,7538,2111,10050},
		{429,2964,2403,8892,2403,8892,644,4446,644,4446,2403,8892,2574,11856},
		{519,3483,2907,10449,2907,10449,779,5225,779,5225,2907,10449,3115,13932},
		{624,4074,3492,12222,3492,12222,936,6111,936,6111,3492,12222,3742,16296},
		{744,4785,4166,14355,4166,14355,1116,7178,1116,7178,4166,14355,4463,19140},
		{881,5625,4934,16875,4934,16875,1322,8438,1322,8438,4934,16875,5286,22500},
		{1038,6557,5810,19670,5810,19670,1556,9835,1556,9835,5810,19670,6225,26226},
		{1214,7584,6796,22752,6796,22752,1821,11376,1821,11376,6796,22752,7282,30336},
		{1413,8712,7911,26136,7911,26136,2119,13068,2119,13068,7911,26136,8476,34848},
		{1513,10302,8471,30906,8471,30906,2269,15453,2269,15453,8471,30906,9076,41208},
		{1685,12023,9436,36068,9436,36068,2527,18034,2527,18034,9436,36068,10110,48090},
		{1871,13878,10478,41634,10478,41634,2807,20817,2807,20817,10478,41634,11227,55512},
		{2073,15873,11607,47619,11607,47619,3109,23810,3109,23810,11607,47619,12436,63492},
		{2290,18012,12824,54036,12824,54036,3435,27018,3435,27018,12824,54036,13740,72048},
		{2524,20300,14135,60899,14135,60899,3786,30449,3786,30449,14135,60899,15145,81198},
		{2776,22740,15543,68220,15543,68220,4163,34110,4163,34110,15543,68220,16653,90960},
		{3045,25338,17053,76014,17053,76014,4568,38007,4568,38007,17053,76014,18271,101352},
		{3334,28098,18670,84294,18670,84294,5001,42147,5001,42147,18670,84294,20004,112392},
		{3643,31025,20400,93074,20400,93074,5464,46537,5464,46537,20400,93074,21857,124098},
		{3973,34155,22247,102465,22247,102465,5959,51233,5959,51233,22247,102465,23836,136620},
		{5405,37497,30270,112490,30270,112490,8108,56245,8108,56245,30270,112490,32432,149986},
		{5873,41055,32889,123165,32889,123165,8810,61583,8810,61583,32889,123165,35239,164220},
		{6371,44838,35678,134514,35678,134514,9557,67257,9557,67257,35678,134514,38226,179352},
		{6899,48852,38636,146556,38636,146556,10349,73278,10349,73278,38636,146556,41395,195408},
		{7460,53104,41774,159312,41774,159312,11189,79656,11189,79656,41774,159312,44757,212416},
		{8054,57600,45100,172800,45100,172800,12080,86400,12080,86400,45100,172800,48321,230400},
		{8682,62348,48620,187043,48620,187043,13023,93521,13023,93521,48620,187043,52093,249390},
		{9347,67353,52340,202059,52340,202059,14020,101030,14020,101030,52340,202059,56079,269412},
		{10048,72624,56268,217871,56268,217871,15072,108935,15072,108935,56268,217871,60288,290494},
		{11375,78165,63697,234495,63697,234495,17062,117248,17062,117248,63697,234495,68247,312660},
		{11660,83985,65294,251955,65294,251955,17490,125978,17490,125978,65294,251955,69958,335940},
		{12278,90090,68757,270270,68757,270270,18417,135135,18417,135135,68757,270270,73669,360360},
		{12980,96487,72685,289461,72685,289461,19469,144731,19469,144731,72685,289461,77877,385948},
		{14000,103182,78400,309546,78400,309546,21000,154773,21000,154773,78400,309546,84000,412728},
		{14632,110183,81937,330548,81937,330548,21948,165274,21948,165274,81937,330548,87790,440730},
		{15332,117495,85861,352485,85861,352485,22999,176243,22999,176243,85861,352485,91994,469980},
		{16116,125127,90249,375380,90249,375380,24174,187690,24174,187690,90249,375380,96696,500506},
		{16983,133083,95103,399249,95103,399249,25474,199625,25474,199625,95103,399249,101896,532332},
		{17933,141372,100422,424116,100422,424116,26899,212058,26899,212058,100422,424116,107595,565488},
		{18966,150000,106206,450000,106206,450000,28448,225000,28448,225000,106206,450000,113793,600000},
		{20081,158974,112456,476922,112456,476922,30122,238461,30122,238461,112456,476922,120488,635896},
		{21280,168300,119170,504900,119170,504900,31921,252450,31921,252450,119170,504900,127682,673200},
		{22563,177986,126350,533957,126350,533957,33844,266978,33844,266978,126350,533957,135375,711942},
		{23928,188037,133994,564111,133994,564111,35891,282056,35891,282056,133994,564111,143565,752148},
		{25376,198462,142104,595385,142104,595385,38064,297692,38064,297692,142104,595385,152255,793846},
		{26907,209738,150679,629213,150679,629213,40361,314606,40361,314606,150679,629213,161442,838950},
		{28521,222319,159720,666957,159720,666957,42782,333479,42782,333479,159720,666957,171128,889276},
		{30219,236250,169225,708750,169225,708750,45328,354375,45328,354375,169225,708750,181313,945000},
		{31999,251577,179196,754730,179196,754730,47999,377365,47999,377365,179196,754730,191995,1006306},
		{33863,268343,189631,805028,189631,805028,50794,402514,50794,402514,189631,805028,203176,1073370},
		{35809,286594,200532,859782,200532,859782,53714,429891,53714,429891,200532,859782,214856,1146376},
		{37839,306375,211898,919125,211898,919125,56759,459563,56759,459563,211898,919125,227034,1225500},
		{39952,327732,223729,983195,223729,983195,59928,491597,59928,491597,223729,983195,239710,1310926},
		{42147,350708,236025,1052123,236025,1052123,63221,526061,63221,526061,236025,1052123,252884,1402830},
		{44426,376534,248787,1129602,248787,1129602,66639,564801,66639,564801,248787,1129602,266557,1506136},
		{46788,405300,262013,1215900,262013,1215900,70182,607950,70182,607950,262013,1215900,280729,1621200},
		{49233,437097,275705,1311290,275705,1311290,73850,655645,73850,655645,275705,1311290,295398,1748386},
		{51761,472013,289862,1416038,289862,1416038,77642,708019,77642,708019,289862,1416038,310567,1888050},
		{54372,510139,304484,1530417,304484,1530417,81558,765209,81558,765209,304484,1530417,326233,2040556},
		{57066,561645,319571,1684935,319571,1684935,85600,842468,85600,842468,319571,1684935,342398,2246580},
		{59844,639732,335124,1919195,335124,1919195,89765,959597,89765,959597,335124,1919195,359061,2558926},
		{62704,758198,351141,2274593,351141,2274593,94056,1137296,94056,1137296,351141,2274593,376223,3032790},
		{65647,931444,367624,2794332,367624,2794332,98471,1397166,98471,1397166,367624,2794332,393883,3725776},
		{68674,1174470,384572,3523410,384572,3523410,103010,1761705,103010,1761705,384572,3523410,412041,4697880},
		{71783,1502877,401985,4508630,401985,4508630,107675,2254315,107675,2254315,401985,4508630,430698,6011506},
		{74976,1932863,419863,5798588,419863,5798588,112463,2899294,112463,2899294,419863,5798588,449853,7731450},
		{78251,2481229,438206,7443687,438206,7443687,117377,3721844,117377,3721844,438206,7443687,469507,9924916},
		{81610,3165375,457014,9496125,457014,9496125,122415,4748063,122415,4748063,457014,9496125,489658,12661500},
		{85052,4003302,476288,12009905,476288,12009905,127577,6004952,127577,6004952,476288,12009905,510309,16013206},
		{88576,5013608,496027,15040823,496027,15040823,132864,7520411,132864,7520411,496027,15040823,531457,20054430},
		{92184,6215494,516231,18646482,516231,18646482,138276,9323241,138276,9323241,516231,18646482,553104,24861976},
		{95875,7628760,536900,22886280,536900,22886280,143813,11443140,143813,11443140,536900,22886280,575250,30515040},
		{99649,9273807,558034,27821420,558034,27821420,149473,13910710,149473,13910710,558034,27821420,597893,37095226},
		{103506,11171633,579633,33514898,579633,33514898,155259,16757449,155259,16757449,579633,33514898,621036,44686530},
		{107446,13343839,601698,40031517,601698,40031517,161169,20015759,161169,20015759,601698,40031517,644676,53375356},
		{111469,15812625,624227,47437875,624227,47437875,167204,23718938,167204,23718938,624227,47437875,668815,63250500},
		{115575,18600792,647222,55802375,647222,55802375,173363,27901187,173363,27901187,647222,55802375,693452,74403166},
		{119765,21731738,670682,65195213,670682,65195213,179647,32597606,179647,32597606,670682,65195213,718588,86926950},
		{124037,25229464,694607,75688392,694607,75688392,186056,37844196,186056,37844196,694607,75688392,744222,100917856},
		{128393,25630410,718998,76891230,718998,76891230,192589,38445615,192589,38445615,718998,76891230,770355,102521640},
		{132831,26042232,743853,78126695,743853,78126695,199247,39063347,199247,39063347,743853,78126695,796986,104168926},
		{137353,26465153,769174,79395458,769174,79395458,206029,39697729,206029,39697729,769174,79395458,824115,105860610},
		{141957,26899399,794959,80698197,794959,80698197,212936,40349099,212936,40349099,794959,80698197,851742,107597596},
		{146645,27345195,821209,82035585,821209,82035585,219967,41017793,219967,41017793,821209,82035585,879867,109380780},
		{151416,27802767,847926,83408300,847926,83408300,227123,41704150,227123,41704150,847926,83408300,908493,111211066},
		{157301,28272338,880885,84817013,880885,84817013,235952,42408506,235952,42408506,880885,84817013,943806,113089350},
		{162601,28754134,910565,86262402,910565,86262402,243902,43131201,243902,43131201,910565,86262402,975606,115016536},
		{168021,29248380,940914,87745140,940914,87745140,252031,43872570,252031,43872570,940914,87745140,1008123,116993520},
		{173561,29755302,971938,89265905,971938,89265905,260341,44632952,260341,44632952,971938,89265905,1041363,119021206},
		{358446,30275123,2007297,90825368,2007297,90825368,537670,45412684,537670,45412684,2007297,90825368,2150676,121100490},
		{370018,30808069,2072100,92424207,2072100,92424207,555028,46212104,555028,46212104,2072100,92424207,2220108,123232276},
		{381840,31354365,2138304,94063095,2138304,94063095,572760,47031548,572760,47031548,2138304,94063095,2291040,125417460},
		{393916,31914237,2205924,95742710,2205924,95742710,590872,47871355,590872,47871355,2205924,95742710,2363490,127656946},
		{406246,32487908,2274972,97463723,2274972,97463723,609368,48731861,609368,48731861,2274972,97463723,2437470,129951630},
		{418834,33075604,2345464,99226812,2345464,99226812,628250,49613406,628250,49613406,2345464,99226812,2512998,132302416},
		{431682,33677550,2417413,101032650,2417413,101032650,647522,50516325,647522,50516325,2417413,101032650,2590086,134710200},
		{444794,34293972,2490840,102881915,2490840,102881915,667190,51440957,667190,51440957,2490840,102881915,2668758,137175886},
		{458172,34925093,2565757,104775278,2565757,104775278,687256,52387639,687256,52387639,2565757,104775278,2749026,139700370},
		{471818,35571139,2642180,106713417,2642180,106713417,707728,53356709,707728,53356709,2642180,106713417,2830908,142284556},
		{485736,36232335,2720121,108697005,2720121,108697005,728604,54348503,728604,54348503,2720121,108697005,2914416,144929340},
	}
	
	local NewData = XinFa_V1[nXinFaLevel]
	if NewData == nil then
		return -1,-1
	end
	if XinFaID == 1 then
		return NewData[1],NewData[2]
	end
	if XinFaID == 2 then
		return NewData[3],NewData[4]
	end
	if XinFaID == 3 then
		return NewData[5],NewData[6]
	end
	if XinFaID == 4 then
		return NewData[7],NewData[8]
	end
	if XinFaID == 5 then
		return NewData[9],NewData[10]
	end
	if XinFaID == 6 then
		return NewData[11],NewData[12]
	end
	if XinFaID == 7 then
		return NewData[13],NewData[14]
	end
end
--===============================================
-- 玩家点击学习的响应
--===============================================
function ActionSkillsStudy_UpLevel_Clicked()
	--AxTrace(0, 0, "ActionSkillsStudy_Study" );

	--if (g_CurSelectButton < 1  or  g_CurSelectButton > XINFA_BUTTONS_NUM) then
	--	return;
		--需要提示不能升级技能
	--end

	-- 处理学习
	local menpaiID = Player : GetData("MEMPAI");		--获取玩家门派ID
	if menpaiID ~= 10 then
		SkillsStudyFrame_study( g_XinfaDefineID[g_CurSelect] );
	else
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "StudySkill" );
			Set_XSCRIPT_ScriptID(377005);
			Set_XSCRIPT_Parameter(0,g_XinfaDefineID[g_CurSelect]);
			Set_XSCRIPT_ParamCount(1);	
		Send_XSCRIPT()		
	end
end

--===============================================
-- 选中一个心法图标
--===============================================
function ActionSkillsStudy_Xinfa_Clicked(nIndex)

	--AxTrace(0, 0, "ActionSkillsStudy_Xinfa_Clicked " ..nIndex );
	-- 数据超过范围，返回
	if(nIndex < 1 or nIndex > XINFA_BUTTONS_NUM) then
		return;
	end

	if g_XinfaID[nIndex] == -1 then
		return
	end

	local i = 1;
	for i=1, XINFA_BUTTONS_NUM do
		if(i==nIndex) then
			XINFA_BUTTONS[i]:SetPushed(1);
		else
			XINFA_BUTTONS[i]:SetPushed(0);
		end
	end

	local i = 1;
	for i=1, SKILL_BUTTONS_NUM do
		SKILL_BUTTONS[i]:SetPushed(0);
	end

	local nXinfaId = LifeAbility : GetLifeAbility_Number(g_XinfaID[nIndex]);

	--更新技能的说明
	local strName = Player:GetXinfaInfo(nXinfaId,"name");
	local nLevel= Player:GetXinfaInfo(nXinfaId,"level");
	local strInfo = Player:GetXinfaInfo(nXinfaId,"explain");

	ActionSkillsStudy_SkillName:SetText(strName);
	ActionSkillsStudy_SkillLevel:SetText("当前等级:".. nLevel);
	ActionSkillsStudy_SkillInfo:SetText(strInfo);

	--更新技能
	ActionSkillsStudy_UpdateSkill( nIndex );

	--更新说明内容
	ActionSkillsStudy_XinfaInfo_Update( nIndex );

	g_CurSelectButton = nIndex;
	g_CurSelect				= nIndex;
end

--===============================================
-- 选中一个技能图标
--===============================================
function ActionSkillsStudy_Skill_Clicked(nIndex)

	local i = 1;
	for i=1, SKILL_BUTTONS_NUM do
		if(i==nIndex) then
			SKILL_BUTTONS[i]:SetPushed(1);
		else
			SKILL_BUTTONS[i]:SetPushed(0);
		end
	end

	--AxTrace(0, 0, "ActionSkillsStudy_Skill_Clicked  " ..nIndex );
	if(nIndex < 1 or nIndex > SKILL_BUTTONS_NUM) then
		return;
	end

	g_CurSelectButton = nIndex + XINFA_BUTTONS_NUM;

	--更新说明内容
	ActionSkillsStudy_SkillInfo_Update( g_SkillID[nIndex] )

end


--===============================================
-- Close
--===============================================
function ActionSkillsStudy_Close_Cilcked()
	this:Hide()
	--取消关心
	this:CareObject(objCared, 0, "ActionSkillsStudy");

end


function ActionSkillsStudy_ClearStaticImage()
	ActionSkillsStudy_MenPai_ICON : SetProperty("Tooltip", "");
	ActionSkillsStudy_MenPai_ICON : SetProperty("Image","");
end

function ActionSkillsStudy_UpdateMenPaiText()
	local menpaiID = Player : GetData("MEMPAI");		--获取玩家门派ID
	if menpaiID ~= nil and menpaiID >=0 and menpaiID <=10 then
		if (menpaiID == 9) then
			ActionSkillsStudy_ClearStaticImage();
			ActionSkillsStudy_MenPai_Attr_Intro : SetText(""); --一般来说这里不会被调到
			return;
		end
		local	str = GetDictionaryString( "MPZSX_20071221_0" .. (menpaiID +1) );
		ActionSkillsStudy_MenPai_Attr_Intro : SetText("#Y" .. str);
		--ActionSkillsStudy_ClearStaticImage();

		ActionSkillsStudy_MenPai_ICON : SetToolTip(GetDictionaryString(MenPai_UsedAttr[menpaiID].Tooltip));
		ActionSkillsStudy_MenPai_ICON : SetProperty("Image",MenPai_UsedAttr[menpaiID].image);
	end
end
