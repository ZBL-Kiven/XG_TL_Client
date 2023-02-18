--Q546528533新增对方武魂查看
local TargetKfs_AttrEx_Text = {}
local TargetKfs_AttrEx_Value = {}
local TargetKfs_ATTREX_MAX_NUM = 10
local TargetKfs_Base_Original_Text = {}
local TargetKfs_Base_Original_Value = {}
local TargetKfs_Base_Text = {}
local TargetKfs_Base_Value = {}
local TargetKfs_Skills = {}
local TargetKfs_Magic

local TargetKfs_Magic_Image = {}
local TargetKfs_Skill_ID = {}
--风、地、水、火
local TargetKfs_Magic_tips = {"#{WH_090817_04}" , "#{WH_090817_05}","#{WH_090817_06}","#{WH_090817_07}","#{WH_090817_08}"}
--力量、灵气、体力、身法、平衡
local TargetKfs_Att_tips = {"#{WH_xml_XX(53)}" , "#{WH_xml_XX(52)}" , "#{WH_xml_XX(54)}"  , "#{WH_xml_XX(60)}" , "#{WH_xml_XX(01)}"}
--力量、灵气、体力、身法、平衡
local Kfs_Att_tips = {"#{WH_xml_XX(53)}" , "#{WH_xml_XX(52)}" , "#{WH_xml_XX(54)}"  , "#{WH_xml_XX(60)}" , "#{WH_xml_XX(01)}"}

local TargetKfs_AttrEx_Mask_L = {}
local	TargetKfs_AttrEx_Mask_R	=	{}
local Kfs_AttrType = {
	[10156001] = 0,
	[10156002] = 1,
	[10156003] = 0,
	[10156004] = 1,
}
local g_TargetWuhun_Frame_UnifiedPosition;
local Kfs_SkillCommonId = {[1500] =49000023,[1501] =49000024,[1502] =49000025,[1503] =49000026,[1504] =49000027,[1505] =49000028,[1506] =49000029,[1507] =49000030,[1508] =49000031,[1509] =49000032,[1510] =49000033,[1511] =49000034,[1512] =49000035,[1513] =49000036,[1514] =49000037,[1515] =49000038,[1516] =49000039,[1517] =49000040,[1518] =49000041,[1519] =49000042,[1520] =49000043,[1521] =49000044,[1522] =49000045,[1523] =49000046,[1524] =49000047,[1525] =49000048,[1526] =49000049,[1527] =49000050,[1528] =49000051,[1529] =49000052,[1530] =49000053,[1531] =49000054,[1532] =49000055,[1533] =49000056,[1534] =49000057,[1535] =49000058,[1536] =49000059,[1537] =49000060,[1538] =49000061,[1539] =49000062,[1540] =49000063,[1541] =49000064,[1542] =49000065,[1543] =49000066,[1544] =49000067,[1545] =49000068,[1546] =49000069,[1547] =49000070,[1548] =49000071,[1549] =49000072,[1550] =49000073,[1551] =49000074,[1552] =49000075,[1553] =49000076,[1554] =49000077,[1555] =49000078,[1556] =49000079,[1557] =49000080,[1558] =49000081,[1559] =49000082,[1560] =49000083,[1561] =49000084,[1562] =49000085,[1563] =49000086,[1564] =49000087,[1565] =49000088,[1566] =49000089,[1567] =49000090,[1568] =49000091,[1569] =49000092,[1570] =49000093,[1571] =49000094,[1572] =49000095,[1573] =49000096,[1574] =49000097,[1575] =49000098,[1576] =49000099,[1577] =49000100,[1578] =49000101,[1579] =49000102,[1580] =49000103,[1581] =49000104,[1582] =49000105,[1583] =49000106,[1584] =49000107,[1585] =49000108,[1586] =49000109,[1587] =49000110,[1588] =49000111,[1589] =49000112,[1590] =49000113,[1591] =49000114,[1592] =49000115,[1593] =49000116,[1594] =49000117,[1595] =49000118,[1596] =49000119,[1597] =49000120,[1598] =49000121,[1599] =49000122,[1600] =49000123,[1601] =49000124,[1602] =49000125,[1603] =49000126,[1604] =49000127,[1605] =49000128,[1606] =49000129,[1607] =49000130,[1608] =49000131,[1609] =49000132,[1610] =49000133,[1611] =49000134,[1612] =49000135,[1613] =49000136,[1614] =49000137,[1615] =49000138,[1616] =49000139,[1617] =49000140,[1618] =49000141,[1619] =49000142,[1620] =49000143,[1621] =49000144,[1622] =49000145,[1623] =49000146,[1624] =49000147,[1625] =49000148,[1626] =49000149,[1627] =49000150,[1628] =49000151,[1629] =49000152,[1630] =49000153,[1631] =49000154,[1632] =49000155,[1633] =49000156,[1634] =49000157,[1635] =49000158,[1636] =49000159,[1637] =49000160,[1638] =49000161,[1639] =49000162,[1640] =49000163,[1641] =49000164,[1642] =49000165,[1643] =49000166,[1644] =49000167,[1645] =49000168,[1646] =49000169,[1647] =49000170,[1648] =49000171,[1649] =49000172,[1650] =49000173,[1651] =49000174,[1652] =49000175,[1653] =49000176,[1654] =49000177,[1655] =49000178,[1656] =49000179,[1657] =49000180,[1658] =49000181,[1659] =49000182,[1660] =49000183,[1661] =49000184,[1662] =49000185,[1663] =49000186,[1664] =49000187,[1665] =49000188,[1666] =49000189,[1667] =49000190,[1668] =49000191,[1669] =49000192,[1670] =49000193,[1671] =49000194,[1672] =49000195,[1673] =49000196,[1674] =49000197,[1675] =49000198,[1676] =49000199,[1677] =49000200,[1678] =49000201,[1679] =49000202,[1680] =49000203,[1681] =49000204,[1682] =49000205,[1683] =49000206,[1684] =49000207,[1685] =49000208,[1686] =49000209,[1687] =49000210,[1688] =49000211,[1689] =49000212,[1690] =49000213,[1691] =49000214,[1692] =49000215,[1693] =49000216,[1694] =49000217,[1695] =49000218,[1696] =49000219,[1697] =49000220,[1698] =49000221,[1699] =49000222,[1700] =49000223,[1701] =49000224,[1702] =49000225,[1703] =49000226,[1704] =49000227,[1705] =49000228,[1706] =49000229,[1707] =49000230,[1708] =49000231,[1709] =49000232,[1710] =49000233,[1711] =49000234,[1712] =49000235,[1713] =49000236,[1714] =49000237,[1715] =49000238,[1716] =49000239,[1717] =49000240,[1718] =49000241,[1719] =49000242,[1720] =49000243,[1721] =49000244,[1722] =49000245,[1723] =49000246,[1724] =49000247,[1725] =49000248,[1726] =49000249,[1727] =49000250,[1728] =49000251,[1729] =49000252,[1730] =49000253,[1731] =49000254,[1732] =49000255,[1733] =49000256,[1734] =49000257,[1735] =49000258,[1736] =49000259,[1737] =49000260,[1738] =49000261,[1739] =49000262,[1740] =49000263,[1741] =49000264,[1742] =49000265,[1743] =49000266,[1744] =49000267,[1745] =49000268,[1746] =49000269,[1747] =49000270,[1748] =49000271,[1749] =49000272,[1750] =49000273,[1751] =49000274,}

local Kfs_EquipData = ""
function TargetWuhun_PreLoad()
	--open or close this window
	this:RegisterEvent("OPEN_OTHERPLAYER_WUHUN");
	--player quit game
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	--update equip
	this:RegisterEvent("OTHERPLAYER_UPDATE_EQUIP");
	this:RegisterEvent("UI_COMMAND");	
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function TargetWuhun_OnLoad()
	--AttrEx text
	TargetKfs_AttrEx_Mask_L[1] = TargetWuhun_Property1_Text
	TargetKfs_AttrEx_Mask_L[2] = TargetWuhun_Property2_Text
	TargetKfs_AttrEx_Mask_L[3] = TargetWuhun_Property3_Text
	TargetKfs_AttrEx_Mask_L[4] = TargetWuhun_Property4_Text
	TargetKfs_AttrEx_Mask_L[5] = TargetWuhun_Property5_Text
	TargetKfs_AttrEx_Mask_L[6] = TargetWuhun_Property6_Text
	TargetKfs_AttrEx_Mask_L[7] = TargetWuhun_Property7_Text
	TargetKfs_AttrEx_Mask_L[8] = TargetWuhun_Property8_Text
	TargetKfs_AttrEx_Mask_L[9] = TargetWuhun_Property9_Text
	TargetKfs_AttrEx_Mask_L[10] = TargetWuhun_Property10_Text
	--AttrEx value
	TargetKfs_AttrEx_Mask_R[1] = TargetWuhun_Property1
	TargetKfs_AttrEx_Mask_R[2] = TargetWuhun_Property2
	TargetKfs_AttrEx_Mask_R[3] = TargetWuhun_Property3
	TargetKfs_AttrEx_Mask_R[4] = TargetWuhun_Property4
	TargetKfs_AttrEx_Mask_R[5] = TargetWuhun_Property5
	TargetKfs_AttrEx_Mask_R[6] = TargetWuhun_Property6
	TargetKfs_AttrEx_Mask_R[7] = TargetWuhun_Property7
	TargetKfs_AttrEx_Mask_R[8] = TargetWuhun_Property8
	TargetKfs_AttrEx_Mask_R[9] = TargetWuhun_Property9
	TargetKfs_AttrEx_Mask_R[10] = TargetWuhun_Property10

	TargetKfs_AttrEx_Text[1] = TargetWuhun_Property1_Text_UnVisible;
	TargetKfs_AttrEx_Text[2] = TargetWuhun_Property2_Text_UnVisible;
	TargetKfs_AttrEx_Text[3] = TargetWuhun_Property3_Text_UnVisible;
	TargetKfs_AttrEx_Text[4] = TargetWuhun_Property4_Text_UnVisible;
	TargetKfs_AttrEx_Text[5] = TargetWuhun_Property5_Text_UnVisible;
	TargetKfs_AttrEx_Text[6] = TargetWuhun_Property6_Text_UnVisible;
	TargetKfs_AttrEx_Text[7] = TargetWuhun_Property7_Text_UnVisible;
	TargetKfs_AttrEx_Text[8] = TargetWuhun_Property8_Text_UnVisible;
	TargetKfs_AttrEx_Text[9] = TargetWuhun_Property9_Text_UnVisible;
	TargetKfs_AttrEx_Text[10] = TargetWuhun_Property10_Text_UnVisible;

	TargetKfs_AttrEx_Value[1] = TargetWuhun_Property1_UnVisible;
	TargetKfs_AttrEx_Value[2] = TargetWuhun_Property2_UnVisible;
	TargetKfs_AttrEx_Value[3] = TargetWuhun_Property3_UnVisible;
	TargetKfs_AttrEx_Value[4] = TargetWuhun_Property4_UnVisible;
	TargetKfs_AttrEx_Value[5] = TargetWuhun_Property5_UnVisible;
	TargetKfs_AttrEx_Value[6] = TargetWuhun_Property6_UnVisible;
	TargetKfs_AttrEx_Value[7] = TargetWuhun_Property7_UnVisible;
	TargetKfs_AttrEx_Value[8] = TargetWuhun_Property8_UnVisible;
	TargetKfs_AttrEx_Value[9] = TargetWuhun_Property9_UnVisible;
	TargetKfs_AttrEx_Value[10] = TargetWuhun_Property10_UnVisible;
	--Original five text
	TargetKfs_Base_Original_Text[1] = TargetWuhun_OriginalStr_Text
	TargetKfs_Base_Original_Text[2] = TargetWuhun_OriginalNimbus_Text
	TargetKfs_Base_Original_Text[3] = TargetWuhun_OriginalPhysicalStrength_Text
	TargetKfs_Base_Original_Text[4] = TargetWuhun_OriginalStability_Text
	TargetKfs_Base_Original_Text[5] = TargetWuhun_OriginalFootwork_Text
	--Original five value
	TargetKfs_Base_Value[1] = TargetWuhun_OriginalStr
	TargetKfs_Base_Value[2] = TargetWuhun_OriginalNimbus
	TargetKfs_Base_Value[3] = TargetWuhun_OriginalPhysicalStrength
	TargetKfs_Base_Value[4] = TargetWuhun_OriginalStability
	TargetKfs_Base_Value[5] = TargetWuhun_OriginalDexterity
	--five text
	TargetKfs_Base_Text[1] = TargetWuhun_Str_Text
	TargetKfs_Base_Text[2] = TargetWuhun_Nimbus_Text
	TargetKfs_Base_Text[3] = TargetWuhun_PhysicalStrength_Text
	TargetKfs_Base_Text[4] = TargetWuhun_Stability_Text
	TargetKfs_Base_Text[5] = TargetWuhun_Footwork_Text
	--five value 
	TargetKfs_Base_Original_Value[1] = TargetWuhun_Str
	TargetKfs_Base_Original_Value[2] = TargetWuhun_Nimbus
	TargetKfs_Base_Original_Value[3] = TargetWuhun_PhysicalStrength
	TargetKfs_Base_Original_Value[4] = TargetWuhun_Stability
	TargetKfs_Base_Original_Value[5] = TargetWuhun_Dexterity
	--skills
	TargetKfs_Skills[1] = TargetWuhun_Skill2
	TargetKfs_Skills[2] = TargetWuhun_Skill3
	TargetKfs_Skills[3] = TargetWuhun_Skill4
	--magic
	TargetKfs_Magic = TargetWuhun_Skill1
	--magic image
	
	TargetKfs_Magic_Image[1] = "set:Wuhun4 image:Wuhun4_2"
	TargetKfs_Magic_Image[2] = "set:Wuhun4 image:Wuhun4_1"
	TargetKfs_Magic_Image[3] = "set:Wuhun4 image:Wuhun4_4"
	TargetKfs_Magic_Image[4] = "set:Wuhun4 image:Wuhun4_3"
	
	 g_TargetWuhun_Frame_UnifiedPosition=TargetWuhun_Frame:GetProperty("UnifiedPosition");

end

function TargetWuhun_OnEvent(event)
	
	if( event == "PLAYER_LEAVE_WORLD") then
		
		this:Hide();
		return;
	
	elseif( event == "UI_COMMAND" and tonumber(arg0) == 2019012101 ) then
		if (not CachedTarget:IsPresent(1)) then
			return;
		end
		g_TargetKfs_Data = Get_XParam_STR(0)
		g_TargetKfs_Life = Get_XParam_INT(0)
		g_TargetKfs_Model = Get_XParam_INT(1)
		TargetWuhun_Update();
		this:Show();
	elseif( event == "OTHERPLAYER_UPDATE_EQUIP" and this:IsVisible() ) then
		Variable:SetVariable("SelfUnionPos", TargetWuhun_Frame:GetProperty("UnifiedPosition"), 1);
		TargetWuhun_Update()
		
	elseif (event == "ADJEST_UI_POS" ) then
		TargetWuhun_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		TargetWuhun_Frame_On_ResetPos()
	end
end

function TargetWuhun_Update()
	--Tab
	TargetWuhun_TargetWuhun:SetCheck(1)
	TargetWuhun_Equip_Mask:Hide()
	--Pos
	local otherUnionPos = Variable:GetVariable("OtherUnionPos");
	if(otherUnionPos ~= nil) then
		TargetWuhun_Frame:SetProperty("UnifiedPosition", otherUnionPos);
	end
	--KFS data
	local nGrow,nExLevel,nLevel,nExp,nMagic,nExAttrNum,nExAttr,nSkill = LuaGetKfsAttrData(g_TargetKfs_Data)
	--ICON
	TargetWuhun_Equip:SetActionItem(-1)
	local ActionKFS = EnumAction(10, "targetequip")
	TargetWuhun_Equip:SetActionItem(ActionKFS:GetID());
	--Title
	TargetWuhun_PageHeader:SetText("#gFF0FA0#{WH_xml_XX(95)}")
	local data = ActionKFS:GetName()
	if data ~= nil then
		TargetWuhun_PageHeader:SetText("#gFF0FA0"..tostring(data))
	end
	--Model
	local nKfsDefenceID = ActionKFS:GetDefineID();
	TargetWuhun_FakeObject:SetFakeObject("");
	if g_TargetKfs_Model ~= 0 then
		Player:SetHorseModel(g_TargetKfs_Model+tonumber(nMagic));
	end
	TargetWuhun_FakeObject:SetFakeObject("My_Horse");

	--NeedLv
	TargetWuhun_NeedLevel_Text:SetText("")
	
	local _,_,nNeedLv = LifeAbility:GetPrescr_Material_Tooltip(ActionKFS:GetDefineID());
	if nNeedLv ~= nil then
		TargetWuhun_NeedLevel_Text:SetText(tostring(nNeedLv))
	end

	--Lv
	TargetWuhun_Level_Text:SetText("")

	if nLevel ~= nil then
		TargetWuhun_Level_Text:SetText(tostring(nLevel))
	end

	--ExtraLevel
	TargetWuhun_ExtraLevel_Text:SetText("")
	if nExLevel ~= nil then
		TargetWuhun_ExtraLevel_Text:SetText(tostring(nExLevel))
	end

	--AttactType
	TargetWuhun_Type:SetText("")

	--AttactType
	TargetWuhun_Type:SetText("")
	
	local AttactType = Kfs_AttrType[ActionKFS:GetDefineID()]
	if AttactType ~= nil and AttactType < 5 and AttactType >= 0 then
		TargetWuhun_Type:SetText(Kfs_Att_tips[AttactType + 1])
	end
	
	--Life
	TargetWuhun_Life_Text2:SetText("")
	
	if g_TargetKfs_Life ~= nil then
		TargetWuhun_Life_Text2:SetText(tostring(g_TargetKfs_Life).."/255")
	end

	--Exp
	TargetWuhun_Exp:SetText("#{WH_xml_XX(76)}")
	if nLevel ~= nil then
		local needexp = Lua_KfsGetLevelUpNeedExp(tonumber(nLevel + 1))
		if nExp ~= nil then
			TargetWuhun_Exp:SetText("#{WH_xml_XX(76)}"..tostring(nExp).."/"..tostring(needexp))
		end
	end
	
	--GrowRate
	TargetWuhun_Growth1:SetText("")
	TargetWuhun_Growth1:SetToolTip("")
	TargetWuhun_Growth:SetText("")
	TargetWuhun_Growth:SetToolTip("")
	local grade = Lua_GetKfsDataGrade(nGrow)
	if nGrow ~= nil and grade ~= nil then
		TargetWuhun_Growth1:SetText("#{WH_xml_XX(93)}")
		TargetWuhun_Growth1:SetToolTip("#{WH_090729_43}")
	  if grade == 0 then
			TargetWuhun_Growth:SetText("#G#{ZSKSSJ_PT}"..tostring(nGrow))
	  elseif grade == 1 then
			TargetWuhun_Growth:SetText("#G#{ZSKSSJ_YX}"..tostring(nGrow))
	  elseif grade == 2 then
			TargetWuhun_Growth:SetText("#G#{ZSKSSJ_JC}"..tostring(nGrow))
	  elseif grade == 3 then
			TargetWuhun_Growth:SetText("#G#{ZSKSSJ_ZY}"..tostring(nGrow))
	  elseif grade == 4 then
			TargetWuhun_Growth:SetText("#G#{ZSKSSJ_WM}"..tostring(nGrow))
	  end
	end

	--AttrEx
	for i=1,TargetKfs_ATTREX_MAX_NUM do

		TargetKfs_AttrEx_Text[i]:SetText("")
		TargetKfs_AttrEx_Value[i]:SetText("")

		if nExAttrNum ~= nil and i <= nExAttrNum then
			TargetKfs_AttrEx_Text[i]:Show()
			TargetKfs_AttrEx_Value[i]:Show()
		else
			TargetKfs_AttrEx_Text[i]:Hide()
			TargetKfs_AttrEx_Value[i]:Hide()
		end
		local iText , iValue = Lua_GetKfsFixAttrEx(nExAttr,i,nGrow)
		-- PushDebugMessage("nExAttr "..nExAttr)
		-- PushDebugMessage("iValue "..iValue)
		if iText ~= nil and iText ~= "" and iValue ~= nil and iValue > 0 and maxLife ~= 0 then
			TargetKfs_AttrEx_Text[i]:SetText(iText)
			TargetKfs_AttrEx_Value[i]:SetText("+"..tostring(iValue))
		end
	end

	--BaseAttr
	-- PushDebugMessage("nGrow "..nGrow.." AttactType "..AttactType.." nLevel "..nLevel)
	for i=1,5 do
		TargetKfs_Base_Original_Value[i]:SetText("")
		TargetKfs_Base_Value[i]:SetText("")
		local nBaseAttr,nOldBaseAttr = Lua_KfsGetAttrAndOldAttr(i,nGrow,AttactType,nLevel)
		if nOldBaseAttr ~= nil then
			TargetKfs_Base_Original_Value[i]:SetText("+"..tostring(nOldBaseAttr))
		end
		if nBaseAttr ~= nil then
			TargetKfs_Base_Value[i]:SetText("+"..tostring(nBaseAttr))
		end
	end

	--SKills
	TargetKfs_Skills[1]:SetActionItem(-1)
	TargetKfs_Skills[2]:SetActionItem(-1)
	TargetKfs_Skills[3]:SetActionItem(-1)

	TargetKfs_Skills[1]:SetActionItem(-1)
	TargetKfs_Skills[2]:SetActionItem(-1)
	TargetKfs_Skills[3]:SetActionItem(-1)
	local Kfs_Skill_ID = {0,0,0}
	for i = 1,3 do
		local skillID = Lua_GetKfsSkill(nSkill,i)
		if skillID ~= nil and skillID > 0 then
			Kfs_Skill_ID[i] = skillID
		else
			Kfs_Skill_ID[i] = -1
		end
	end	
	for i = 1,3 do	   
		if Kfs_SkillCommonId[Kfs_Skill_ID[i]] ~= nil then
		    local theAction = GemMelting:UpdateProductAction(Kfs_SkillCommonId[Kfs_Skill_ID[i]])
		    TargetKfs_Skills[i] :SetActionItem(theAction:GetID());
		end
	end
	--Magic
	TargetKfs_Magic:SetProperty("NormalImage" ,"" )
	TargetKfs_Magic:SetToolTip("")
	if nMagic ~= nil and nMagic < 5 and nMagic >= 0 and maxLife ~= 0 then
		TargetKfs_Magic:SetProperty("Empty", "False")
		if nMagic > 0 then
			TargetKfs_Magic:SetProperty("NormalImage" , TargetKfs_Magic_Image[nMagic] )
		end
		TargetKfs_Magic:SetToolTip(TargetKfs_Magic_tips[nMagic+1])
	end


end

--model turn left
function TargetWuhun_Model_TurnLeft(start)
	--start
	if(start == 1 and CEArg:GetValue("MouseButton")=="LeftButton") then
		TargetWuhun_FakeObject:RotateBegin(-0.3);
	--stop
	else
		TargetWuhun_FakeObject:RotateEnd();
	end
end

--model turn right
function TargetWuhun_Model_TurnRight(start)
	--start
	if(start == 1 and CEArg:GetValue("MouseButton")=="LeftButton") then
		TargetWuhun_FakeObject:RotateBegin(0.3);
	--stop
	else
		TargetWuhun_FakeObject:RotateEnd();
	end
end

--kfs hidden event
function TargetWuhun_OnHiden()
	TargetWuhun_FakeObject:SetFakeObject("");	
end



--============================================================================================================
-- 打开玩家信息界面
function TargetWuhun_OtherData_Page_Switch()
	Variable:SetVariable("OtherUnionPos", TargetWuhun_Frame:GetProperty("UnifiedPosition"), 1);
	SystemSetup:OpenPrivatePage("other")
end
-- 打开玩家装备UI
function TargetWuhun_OtherEquip_Page_Switch()
	Variable:SetVariable("OtherUnionPos", TargetWuhun_Frame:GetProperty("UnifiedPosition"), 1);
	SystemSetup:OpenEquipFrame("other");
end
-- 打开玩家宠物UI
function TargetWuhun_OtherPet_Page_Switch()
	Variable:SetVariable("OtherUnionPos", TargetWuhun_Frame:GetProperty("UnifiedPosition"), 1);
	SystemSetup:OpenPetFrame("other");
end
--打开玩家骑乘UI
function TargetWuhun_OtherRide_Page_Switch()
	Variable:SetVariable("OtherUnionPos", TargetWuhun_Frame:GetProperty("UnifiedPosition"), 1);
	SystemSetup:OpenRidePage("other");
end
-- 打开玩家博客UI
-- function TargetWuhun_OtherBlog_Page_Switch()
-- 	Variable:SetVariable("OtherUnionPos", TargetWuhun_Frame:GetProperty("UnifiedPosition"), 1);
-- 	local strCharName =  CachedTarget:GetData("NAME");
-- 	local strAccount =  CachedTarget:GetData("ACCOUNTNAME")
-- 	Blog:OpenBlogPage(strAccount,strCharName,false);
-- end

function TargetWuhun_Frame_On_ResetPos()
  TargetWuhun_Frame:SetProperty("UnifiedPosition", g_TargetWuhun_Frame_UnifiedPosition);
end