
local g_DecorateWeapon_Frame_UnifiedPosition;
local g_clientNpcId = -1
local g_WeaponBagPos = -1
local g_DestDecoWeaponId = -1
local g_DestDecoWeaponLevelId = {}
local g_bSendConfirm = 1
local g_SourceDecoWeaponId = -1
local g_XuanZhong = -1
local g_StartID = 10102220
local g_EndID = 10103000
function DecorateWeapon_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("UNIT_MONEY")
	this:RegisterEvent("MONEYJZ_CHANGE")
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")	--�뿪�����رս���
	this:RegisterEvent("SEX_CHANGED");
	this:RegisterEvent("DECOWEAPON_CONVER_CONFIRM_OK")
end

function DecorateWeapon_OnLoad() 
	g_DecorateWeapon_Frame_UnifiedPosition = DecorateWeapon_Frame:GetProperty("UnifiedPosition");
	for i=1, 6 do
		g_DestDecoWeaponLevelId[i] = -1
	end
end

function DecorateWeapon_OnEvent(event) 

	if event == "UI_COMMAND" and arg0 ~= nil and tonumber(arg0) == 2019012302 then
		local Type = Get_XParam_INT(0)
		
		if Type == 1 then       --�򿪽���
			if this : IsVisible() then									-- ������濪�ţ��򲻴���
				return
			end
			
			local npcObjId = Get_XParam_INT(1)
			g_clientNpcId = DataPool : GetNPCIDByServerID(npcObjId)
			if g_clientNpcId == -1 then
				PushDebugMessage("δ���� NPC")
				DecorateWeapon_OnHiden()
				return
			end
		
			this:CareObject( g_clientNpcId, 1, "DecorateWeapon" )
			
			DecorateWeapon_FakeObject:SetFakeObject("")
			
			
			DecorateWeapon_Init()
			this:Show()
			g_bSendConfirm = 1
			
		elseif Type == 2 then		--�ɹ�ˢ�½���
			DecorateWeapon_Init()
		end
	
	elseif (event == "ADJEST_UI_POS" ) then
		DecorateWeapon_Frame_On_ResetPos()

	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		DecorateWeapon_Frame_On_ResetPos()
		
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		DecorateWeapon_OnHiden()
		
	elseif (event == "UNIT_MONEY") then
		local playerMoney = Player:GetData("MONEY")
		DecorateWeapon_SelfMoney:SetProperty("MoneyNumber", playerMoney)
		
	elseif (event == "MONEYJZ_CHANGE") then
		local playerJZ = Player:GetData("MONEY_JZ")
		DecorateWeapon_SelfJiaozi:SetProperty("MoneyNumber", playerJZ)
		
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 201107281 and this:IsVisible()) then
		if tonumber(arg1) ~= -1 and tonumber(arg1) ~= nil then   --��������
			DecorateWeapon_Update(tonumber(arg1))
	    end
	elseif (event == "DECOWEAPON_CONVER_CONFIRM_OK") then
		g_bSendConfirm = 0
	elseif event == "SEX_CHANGED" and  this:IsVisible() then
		DecorateWeapon_FakeObject : Hide();
		DecorateWeapon_FakeObject : Show();
		DecorateWeapon_FakeObject:SetFakeObject("EquipChange_Player");
	end
end

function DecorateWeapon_Frame_On_ResetPos()
  DecorateWeapon_Frame:SetProperty("UnifiedPosition", g_DecorateWeapon_Frame_UnifiedPosition);
end

function DecorateWeapon_Init()
	DecorateWeapon_RestData()
	
	DecorateWeapon_ALLChoice:Disable()
	DecorateWeapon_ALLChoice:SetText("#{DECOW_160126_16}")
	
	DecorateWeapon_DemandMoney:SetProperty("MoneyNumber", 0)
	local playerMoney = Player:GetData("MONEY")
	DecorateWeapon_SelfMoney:SetProperty("MoneyNumber", playerMoney)
	local playerJZ = Player:GetData("MONEY_JZ")
	DecorateWeapon_SelfJiaozi:SetProperty("MoneyNumber", playerJZ)
	
	DecorateWeapon_OK:Disable()
	DecorateWeapon_Object:SetActionItem(-1)
	g_bSendConfirm = 1
end

function DecorateWeapon_Update(bagBos)
	DecorateWeapon_RestData()
	g_SourceDecoWeaponId = PlayerPackage:GetItemTableIndex(bagBos)	
	local iSok = LuaFnGetIsDecorateWeapon(g_SourceDecoWeaponId)
	if iSok == 0 then
	    PushDebugMessage("#H�����102������")
		return
	end
	local theAction = EnumAction(bagBos, "packageitem")
	if theAction:GetID() ~= 0 then
	    local DestDecoWeaponId = math.mod(g_SourceDecoWeaponId,10) + 1
		
		g_WeaponBagPos = bagBos
		
		LifeAbility:Lock_Packet_Item(g_WeaponBagPos, 1)
		DecorateWeapon_Object:SetActionItem(theAction:GetID())
		
		g_DestDecoWeaponId = DestDecoWeaponId
		
		DecorateWeapon_DemandMoney:SetProperty("MoneyNumber", 100000)
		DecorateWeapon_OK:Enable()
		
		DecorateWeapon_ALLChoice_Init()
		g_bSendConfirm = 1
		DecorateWeapon_FakeObject:SetFakeObject("EquipChange_Player")
	end
end

function DecorateWeapon_ALLChoice_Init()
	local WeaponName = {}
	for i=1, 6 do
		g_DestDecoWeaponLevelId[i] = -1
	end
	local n,l = GetDecoWeaponMsg(g_SourceDecoWeaponId)
	for i = 1,6 do
		WeaponName[i],g_DestDecoWeaponLevelId[i] = n[i],l[i]
	end	
	if WeaponName[1] == nil then
		return
	end	
	DecorateWeapon_ALLChoice:ResetList()		 	
	-- DecorateWeapon_ALLChoice:SetText(WeaponName[1])	
	for i = 1 , 6 do 
		DecorateWeapon_ALLChoice:AddTextItem(WeaponName[i] ,i) 
	end 
	
	DecorateWeapon_ALLChoice:Enable() 
	--��ʾĬ��Ч��
	local VisualID = g_DestDecoWeaponLevelId[1]--GetDecoWeaponMsg(g_DestDecoWeaponLevelId[1])
	DecorateWeapon_FakeObject:SetFakeObject("");	
	DecorateWeapon_FakeObject:SetFakeObject("EquipChange_Player");	
	LifeAbility:Wear_Equip_VisualID(g_WeaponBagPos,VisualID)
end

function DecorateWeapon_RestData()
	if g_WeaponBagPos ~= -1 then
		LifeAbility:Lock_Packet_Item(g_WeaponBagPos, 0)
		g_WeaponBagPos = -1
	end
	g_WeaponBagPos = -1
	g_DestDecoWeaponId = -1
	
	for i= 1, 6 do
		g_DestDecoWeaponLevelId[i] = -1
	end
end

function DecorateWeapon_OnHiden()
	LifeAbility : Update_Equip_VisualID()
	this:CareObject( g_clientNpcId, 0, "DecorateWeapon" )
	DecorateWeapon_FakeObject:SetFakeObject("")
	g_clientNpcId = -1
	
	DecorateWeapon_RestData()
	this:Hide() 
end

function DecorateWeapon_Level_Changed() 

	local _name,ComIdx = DecorateWeapon_ALLChoice:GetCurrentSelect()
	
	if ComIdx > 0 and ComIdx < 7 and g_DestDecoWeaponLevelId[ComIdx] ~= -1 then 
		local VisualID = g_DestDecoWeaponLevelId[ComIdx]--GetDecoWeaponMsg(g_DestDecoWeaponLevelId[ComIdx])
		DecorateWeapon_FakeObject:SetFakeObject("");	
		DecorateWeapon_FakeObject:SetFakeObject("EquipChange_Player");	
		LifeAbility:Wear_Equip_VisualID(g_WeaponBagPos,VisualID)
		g_XuanZhong = ComIdx
	end
end

function DecorateWeapon_TurnLeft(start)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		--������ת��ʼ
		if(start == 1) then
			DecorateWeapon_FakeObject:RotateBegin( -0.3);
		--������ת����
		else
			DecorateWeapon_FakeObject:RotateEnd();
		end
	end
end

----------------------------------------------------------------------------------
function DecorateWeapon_TurnRight(start)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		--������ת��ʼ
		if(start == 1) then
			DecorateWeapon_FakeObject:RotateBegin( -0.3);
		--������ת����
		else
			DecorateWeapon_FakeObject:RotateEnd();
		end
	end
end

function DecorateWeapon_OnOK()
	if g_WeaponBagPos ~= -1 then
		local myMoney = Player:GetData("MONEY_JZ") + Player:GetData("MONEY")
		
		if myMoney < 100000 then
			PushDebugMessage("#{DECOW_160126_33}")
			return
		end
		
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("DoSuperDecorateWeapon")
			Set_XSCRIPT_ScriptID(001085)
			Set_XSCRIPT_Parameter(0, g_WeaponBagPos)
			Set_XSCRIPT_Parameter(1, g_XuanZhong)
			Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT()
	end
end

function DecorateWeapon_Resume_Equip()
	if g_WeaponBagPos ~= -1 then
		DecorateWeapon_Init()
	end
end

function DecorateWeapon_OnHelp()
	PushEvent("OPEN_FUQICHENGHAO",3)
end

function LuaFnGetIsDecorateWeapon(nItemID)
    local nIetmTiele = SuperTooltips:GetTitle()
	if string.find(nIetmTiele,"��") ~= nil then
	    return 1
	end
	return 0
end

function GetDecoWeaponName(a)
local nName = {
{668,"������ȸ"},
{667,"������ȸ"},
{669,"������ȸ"},
{713,"������Ƶ�"},
{936,"���������"},
{668,"������ȸ"},
{667,"������ȸ"},
{669,"������ȸ"},
{946,"��������"},
{956,"��������"},
{966,"��������"},
{1398,"����"},
{1399,"����"},
{1400,"����"},
{665,"���ط���"},
{664,"���ط���"},
{666,"���ط���"},
{689,"��������"},
{688,"��������"},
{690,"��������"},
{709,"ն�Ƕϳ�ǹ"},
{711,"������а��"},
{932,"��������ǹ"},
{934,"�����а��"},
{942,"�������"},
{952,"�������"},
{962,"�������"},
{944,"��Ħһ̾"},
{954,"��Ħһ̾"},
{964,"��Ħһ̾"},
{1401,"����"},
{1402,"����"},
{1403,"����"},
{1395,"����"},
{1396,"����"},
{1397,"����"},
{673,"���̳�Ӱ"},
{674,"���̳�Ӱ"},
{675,"���̳�Ӱ"},
{721,"��������"},
{720,"��������"},
{719,"��������"},
{717,"����ŪӰ��"},
{714,"������Ԩ��"},
{718,"�����޺۽�"},
{940,"�����Ӱ��"},
{937,"��ת��Ȫ��"},
{941,"�����¶���"},
{947,"��������"},
{957,"��������"},
{967,"��������"},
{951,"ĩ����Ȩ"},
{961,"ĩ����Ȩ"},
{971,"ĩ����Ȩ"},
{1404,"����"},
{1405,"����"},
{1406,"����"},
{1422,"����"},
{1423,"����"},
{1424,"����"},
{670,"�����ҹ"},
{671,"�����ҹ"},
{672,"�����ҹ"},
{676,"����Ǻ�"},
{677,"����Ǻ�"},
{678,"����Ǻ�"},
{710,"ת�����ǹ�"},
{933,"����ֻع�"},
{929,"���쳤��"},
{930,"���쳤��"},
{931,"���쳤��"},
{943,"������Ȫ"},
{953,"������Ȫ"},
{963,"������Ȫ"},
{1407,"�컯"},
{1408,"�컯"},
{1409,"�컯"},
{1410,"��ڤ"},
{1411,"��ڤ"},
{1412,"��ڤ"},
{686,"���ξ��"},
{685,"���ξ��"},
{687,"���ξ��"},
{712,"���������"},
{935,"���������"},
{945,"̫��Ʈ��"},
{955,"̫��Ʈ��"},
{965,"̫��Ʈ��"},
{1419,"����"},
{1420,"����"},
{1421,"����"},
{679,"�󺺺��"},
{680,"�󺺺��"},
{681,"�󺺺��"},
{683,"������˪"},
{682,"������˪"},
{684,"������˪"},
{715,"������Ӱ��"},
{716,"����ҫ����"},
{938,"������Ӱ��"},
{939,"���ƾ��ջ�"},
{949,"��������"},
{959,"��������"},
{969,"��������"},
{948,"�������"},
{958,"�������"},
{968,"�������"},
{1413,"����"},
{1414,"����"},
{1415,"����"},
{1416,"����"},
{1417,"����"},
{1418,"����"},
{646,"�۽����յ�"},
{647,"��ˮ�޺۽�"},
{649,"�����ɷ���"},
{648,"�̺����λ�"},
}
    for i = 1,table.getn(nName) do
	    if nName[i][1] == a then
		    return nName[i][2]
		end
	end
end

function GetDecoWeaponMsg(itemID)
local DecoWeaponMsg = {
[10300100] = {946,1398,713,936,668,646},
[10300101] = {956,1399,713,936,667,646},
[10300102] = {966,1400,713,936,669,646},
[10300103] = {946,1398,713,936,668,646},
[10300104] = {956,1399,713,936,667,646},
[10300105] = {966,1400,713,936,669,646},
[10300106] = {946,1398,713,936,668,646},
[10300107] = {956,1399,713,936,667,646},
[10300108] = {966,1400,713,936,669,646},
[10300109] = {946,1398,713,936,668,646},
[10300110] = {956,1399,713,936,667,646},
[10300111] = {966,1400,713,936,669,646},

[10301100] = {942,1401,709,932,665,646},
[10301101] = {952,1402,709,932,664,646},
[10301102] = {962,1403,709,932,666,646},
[10301103] = {942,1401,709,932,665,646},
[10301104] = {952,1402,709,932,664,646},
[10301105] = {962,1403,709,932,666,646},
[10301106] = {942,1401,709,932,665,646},
[10301107] = {952,1402,709,932,664,646},
[10301108] = {962,1403,709,932,666,646},
[10301109] = {942,1401,709,932,665,646},
[10301110] = {952,1402,709,932,664,646},
[10301111] = {962,1403,709,932,666,646},

[10301200] = {944,1395,711,934,689,646},
[10301201] = {954,1396,711,934,688,646},
[10301202] = {964,1397,711,934,690,646},
[10301203] = {944,1395,711,934,689,646},
[10301204] = {954,1396,711,934,688,646},
[10301205] = {964,1397,711,934,690,646},
[10301206] = {944,1395,711,934,689,646},
[10301207] = {954,1396,711,934,688,646},
[10301208] = {964,1397,711,934,690,646},
[10301209] = {944,1395,711,934,689,646},
[10301210] = {954,1396,711,934,688,646},
[10301211] = {964,1397,711,934,690,646},

[10302100] = {947,1404,714,937,673,647},
[10302101] = {957,1405,714,937,674,647},
[10302102] = {967,1406,714,937,675,647},
[10302103] = {947,1404,714,937,673,647},
[10302104] = {957,1405,714,937,674,647},
[10302105] = {967,1406,714,937,675,647},
[10302106] = {947,1404,714,937,673,647},
[10302107] = {957,1405,714,937,674,647},
[10302108] = {967,1406,714,937,675,647},
[10302109] = {947,1404,714,937,673,647},
[10302110] = {957,1405,714,937,674,647},
[10302111] = {967,1406,714,937,675,647},

[10303100] = {929,1407,717,940,670,647},
[10303101] = {930,1408,717,940,671,647},
[10303102] = {931,1409,717,940,672,647},
[10303103] = {929,1407,717,940,670,647},
[10303104] = {930,1408,717,940,671,647},
[10303105] = {931,1409,717,940,672,647},
[10303106] = {929,1407,717,940,670,647},
[10303107] = {930,1408,717,940,671,647},
[10303108] = {931,1409,717,940,672,647},
[10303109] = {929,1407,717,940,670,647},
[10303110] = {930,1408,717,940,671,647},
[10303111] = {931,1409,717,940,672,647},

[10303200] = {943,1410,710,933,676,647},
[10303201] = {953,1411,710,933,677,647},
[10303202] = {963,1412,710,933,678,647},
[10303203] = {943,1410,710,933,676,647},
[10303204] = {953,1411,710,933,677,647},
[10303205] = {963,1412,710,933,678,647},
[10303206] = {943,1410,710,933,676,647},
[10303207] = {953,1411,710,933,677,647},
[10303208] = {963,1412,710,933,678,647},
[10303209] = {943,1410,710,933,676,647},
[10303210] = {953,1411,710,933,677,647},
[10303211] = {963,1412,710,933,678,647},

[10304100] = {945,1419,712,935,686,649},
[10304101] = {955,1420,712,935,685,649},
[10304102] = {965,1421,712,935,687,649},
[10304103] = {945,1419,712,935,686,649},
[10304104] = {955,1420,712,935,685,649},
[10304105] = {965,1421,712,935,687,649},
[10304106] = {945,1419,712,935,686,649},
[10304107] = {955,1420,712,935,685,649},
[10304108] = {965,1421,712,935,687,649},
[10304109] = {945,1419,712,935,686,649},
[10304110] = {955,1420,712,935,685,649},
[10304111] = {965,1421,712,935,687,649},

[10305100] = {949,1413,716,939,679,648},
[10305101] = {959,1414,716,939,680,648},
[10305102] = {969,1415,716,939,681,648},
[10305103] = {949,1413,716,939,679,648},
[10305104] = {959,1414,716,939,680,648},
[10305105] = {969,1415,716,939,681,648},
[10305106] = {949,1413,716,939,679,648},
[10305107] = {959,1414,716,939,680,648},
[10305108] = {969,1415,716,939,681,648},
[10305109] = {949,1413,716,939,679,648},
[10305110] = {959,1414,716,939,680,648},
[10305111] = {969,1415,716,939,681,648},

[10305200] = {948,1416,715,938,683,648},
[10305201] = {958,1417,715,938,682,648},
[10305202] = {968,1418,715,938,684,648},
[10305203] = {948,1416,715,938,683,648},
[10305204] = {958,1417,715,938,682,648},
[10305205] = {968,1418,715,938,684,648},
[10305206] = {948,1416,715,938,683,648},
[10305207] = {958,1417,715,938,682,648},
[10305208] = {968,1418,715,938,684,648},
[10305209] = {948,1416,715,938,683,648},
[10305210] = {958,1417,715,938,682,648},
[10305211] = {968,1418,715,938,684,648},
}
    local Name,VisualID = {},{} 
	if DecoWeaponMsg[itemID] ~= nil then
	    for i = 1,6 do
			Name[i] = GetDecoWeaponName(DecoWeaponMsg[itemID][i])
			VisualID[i] = DecoWeaponMsg[itemID][i]
		end
	end
	return Name,VisualID
end