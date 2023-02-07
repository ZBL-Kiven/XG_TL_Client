
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
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")	--Àë¿ª³¡¾°¹Ø±Õ½çÃæ
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
		
		if Type == 1 then       --´ò¿ª½çÃæ
			if this : IsVisible() then									-- Èç¹û½çÃæ¿ª×Å£¬Ôò²»´¦Àí
				return
			end
			
			local npcObjId = Get_XParam_INT(1)
			g_clientNpcId = DataPool : GetNPCIDByServerID(npcObjId)
			if g_clientNpcId == -1 then
				PushDebugMessage("Î´·¢ÏÖ NPC")
				DecorateWeapon_OnHiden()
				return
			end
		
			this:CareObject( g_clientNpcId, 1, "DecorateWeapon" )
			
			DecorateWeapon_FakeObject:SetFakeObject("")
			
			
			DecorateWeapon_Init()
			this:Show()
			g_bSendConfirm = 1
			
		elseif Type == 2 then		--³É¹¦Ë¢ÐÂ½çÃæ
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
		if tonumber(arg1) ~= -1 and tonumber(arg1) ~= nil then   --·ÅÈëÎäÆ÷
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
	    PushDebugMessage("#HÇë·ÅÈë102ÉñÆ÷£¡")
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
	--ÏÔÊ¾Ä¬ÈÏÐ§¹û
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
		--Ïò×óÐý×ª¿ªÊ¼
		if(start == 1) then
			DecorateWeapon_FakeObject:RotateBegin( -0.3);
		--Ïò×óÐý×ª½áÊø
		else
			DecorateWeapon_FakeObject:RotateEnd();
		end
	end
end

----------------------------------------------------------------------------------
function DecorateWeapon_TurnRight(start)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		--ÏòÓÒÐý×ª¿ªÊ¼
		if(start == 1) then
			DecorateWeapon_FakeObject:RotateBegin( -0.3);
		--ÏòÓÒÐý×ª½áÊø
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
	if string.find(nIetmTiele,"´ó") ~= nil then
	    return 1
	end
	return 0
end

function GetDecoWeaponName(a)
local nName = {
{668,"´óÏÄÁúÈ¸"},
{667,"´óÏÄÁúÈ¸"},
{669,"´óÏÄÁúÈ¸"},
{713,"³àÑæ¾ÅÎÆµ¶"},
{936,"³ãÑæ¾ÅÁúµ¶"},
{668,"´óÏÄÁúÈ¸"},
{667,"´óÏÄÁúÈ¸"},
{669,"´óÏÄÁúÈ¸"},
{946,"¾ÅÏöìÍÑô"},
{956,"¾ÅÏöìÍÑô"},
{966,"¾ÅÏöìÍÑô"},
{1398,"Ã÷×ð"},
{1399,"Ã÷×ð"},
{1400,"Ã÷×ð"},
{665,"´óÇØ·æïá"},
{664,"´óÇØ·æïá"},
{666,"´óÇØ·æïá"},
{689,"´óÌÆÀ¥ÔÀ"},
{688,"´óÌÆÀ¥ÔÀ"},
{690,"´óÌÆÀ¥ÔÀ"},
{709,"Õ¶ÓÇ¶Ï³îÇ¹"},
{711,"ÞÄÌìÆÆÐ°ÕÈ"},
{932,"ÍüÓÇÏú»êÇ¹"},
{934,"·¨Ìì±ÙÐ°ÕÈ"},
{942,"ºé»ÄÁúÎè"},
{952,"ºé»ÄÁúÎè"},
{962,"ºé»ÄÁúÎè"},
{944,"´ïÄ¦Ò»Ì¾"},
{954,"´ïÄ¦Ò»Ì¾"},
{964,"´ïÄ¦Ò»Ì¾"},
{1401,"·üÁú"},
{1402,"·üÁú"},
{1403,"·üÁú"},
{1395,"ÊÍåÈ"},
{1396,"ÊÍåÈ"},
{1397,"ÊÍåÈ"},
{673,"´óÉÌ³¾Ó°"},
{674,"´óÉÌ³¾Ó°"},
{675,"´óÉÌ³¾Ó°"},
{721,"´óÑàÔÏÕÂ"},
{720,"´óÑàÔÏÕÂ"},
{719,"´óÑàÔÏÕÂ"},
{717,"º¬¹âÅªÓ°½£"},
{714,"ÍòØðÁúÔ¨½£"},
{718,"ÐÇÒÆÎÞºÛ½£"},
{940,"Ìì¹âÁ÷Ó°½£"},
{937,"¾Å×ªÁúÈª½£"},
{941,"ÐÇÒÆÔÂ¶¯½£"},
{947,"´óÑÜÌìÐþ"},
{957,"´óÑÜÌìÐþ"},
{967,"´óÑÜÌìÐþ"},
{951,"Ä©ÊÀÍõÈ¨"},
{961,"Ä©ÊÀÍõÈ¨"},
{971,"Ä©ÊÀÍõÈ¨"},
{1404,"µÀ³å"},
{1405,"µÀ³å"},
{1406,"µÀ³å"},
{1422,"µÛãÚ"},
{1423,"µÛãÚ"},
{1424,"µÛãÚ"},
{670,"´óÖÜá°Ò¹"},
{671,"´óÖÜá°Ò¹"},
{672,"´óÖÜá°Ò¹"},
{676,"´ó½úÐÇºÛ"},
{677,"´ó½úÐÇºÛ"},
{678,"´ó½úÐÇºÛ"},
{710,"×ª»êÃðÆÇ¹³"},
{933,"Ãð»êÂÖ»Ø¹³"},
{929,"ÒÐÌì³¤Éú"},
{930,"ÒÐÌì³¤Éú"},
{931,"ÒÐÌì³¤Éú"},
{943,"ÁùµÀ»ÆÈª"},
{953,"ÁùµÀ»ÆÈª"},
{963,"ÁùµÀ»ÆÈª"},
{1407,"Ôì»¯"},
{1408,"Ôì»¯"},
{1409,"Ôì»¯"},
{1410,"ÓÄÚ¤"},
{1411,"ÓÄÚ¤"},
{1412,"ÓÄÚ¤"},
{686,"´óËÎ¾ýá¯"},
{685,"´óËÎ¾ýá¯"},
{687,"´óËÎ¾ýá¯"},
{712,"À×ÃùÀë»ðÉÈ"},
{935,"ÌìÀ×Õæ»ðÉÈ"},
{945,"Ì«¹ÅÆ®ôá"},
{955,"Ì«¹ÅÆ®ôá"},
{965,"Ì«¹ÅÆ®ôá"},
{1419,"¸¡Éú"},
{1420,"¸¡Éú"},
{1421,"¸¡Éú"},
{679,"´óºººë¸Ù"},
{680,"´óºººë¸Ù"},
{681,"´óºººë¸Ù"},
{683,"´óËåÄýËª"},
{682,"´óËåÄýËª"},
{684,"´óËåÄýËª"},
{715,"ËéÇéÎíÓ°»·"},
{716,"ÌìÐÇÒ«Ñô»·"},
{938,"¾øÇéÁÑÓ°»·"},
{939,"ÐÇÔÆ¾ÛÈÕ»·"},
{949,"ÍòÊÀ¿ÝÈÙ"},
{959,"ÍòÊÀ¿ÝÈÙ"},
{969,"ÍòÊÀ¿ÝÈÙ"},
{948,"ÎÞÏà¾ø×Ù"},
{958,"ÎÞÏà¾ø×Ù"},
{968,"ÎÞÏà¾ø×Ù"},
{1413,"ÈëÃð"},
{1414,"ÈëÃð"},
{1415,"ÈëÃð"},
{1416,"ÉñÒþ"},
{1417,"ÉñÒþ"},
{1418,"ÉñÒþ"},
{646,"ÈÛ½ðÂäÈÕµ¶"},
{647,"ÇïË®ÎÞºÛ½£"},
{649,"ÍòÛÖËÉ·çÉÈ"},
{648,"±Ìº£ÒøÌÎ»·"},
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