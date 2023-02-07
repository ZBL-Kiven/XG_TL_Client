--  WuhunSkillUp
--build 2019-7-16 11:25:31 逍遥子
local m_UI_NUM = 20090723
local m_ObjCared = -1
local m_Equip_Idx = -1
local m_Equip_Item = -1

local Skills = {}
local skillSelected = -1
local Kfs_Skill_ID = {}
local Kfs_SkillCommonId = {[1500] =49000023,[1501] =49000024,[1502] =49000025,[1503] =49000026,[1504] =49000027,[1505] =49000028,[1506] =49000029,[1507] =49000030,[1508] =49000031,[1509] =49000032,[1510] =49000033,[1511] =49000034,[1512] =49000035,[1513] =49000036,[1514] =49000037,[1515] =49000038,[1516] =49000039,[1517] =49000040,[1518] =49000041,[1519] =49000042,[1520] =49000043,[1521] =49000044,[1522] =49000045,[1523] =49000046,[1524] =49000047,[1525] =49000048,[1526] =49000049,[1527] =49000050,[1528] =49000051,[1529] =49000052,[1530] =49000053,[1531] =49000054,[1532] =49000055,[1533] =49000056,[1534] =49000057,[1535] =49000058,[1536] =49000059,[1537] =49000060,[1538] =49000061,[1539] =49000062,[1540] =49000063,[1541] =49000064,[1542] =49000065,[1543] =49000066,[1544] =49000067,[1545] =49000068,[1546] =49000069,[1547] =49000070,[1548] =49000071,[1549] =49000072,[1550] =49000073,[1551] =49000074,[1552] =49000075,[1553] =49000076,[1554] =49000077,[1555] =49000078,[1556] =49000079,[1557] =49000080,[1558] =49000081,[1559] =49000082,[1560] =49000083,[1561] =49000084,[1562] =49000085,[1563] =49000086,[1564] =49000087,[1565] =49000088,[1566] =49000089,[1567] =49000090,[1568] =49000091,[1569] =49000092,[1570] =49000093,[1571] =49000094,[1572] =49000095,[1573] =49000096,[1574] =49000097,[1575] =49000098,[1576] =49000099,[1577] =49000100,[1578] =49000101,[1579] =49000102,[1580] =49000103,[1581] =49000104,[1582] =49000105,[1583] =49000106,[1584] =49000107,[1585] =49000108,[1586] =49000109,[1587] =49000110,[1588] =49000111,[1589] =49000112,[1590] =49000113,[1591] =49000114,[1592] =49000115,[1593] =49000116,[1594] =49000117,[1595] =49000118,[1596] =49000119,[1597] =49000120,[1598] =49000121,[1599] =49000122,[1600] =49000123,[1601] =49000124,[1602] =49000125,[1603] =49000126,[1604] =49000127,[1605] =49000128,[1606] =49000129,[1607] =49000130,[1608] =49000131,[1609] =49000132,[1610] =49000133,[1611] =49000134,[1612] =49000135,[1613] =49000136,[1614] =49000137,[1615] =49000138,[1616] =49000139,[1617] =49000140,[1618] =49000141,[1619] =49000142,[1620] =49000143,[1621] =49000144,[1622] =49000145,[1623] =49000146,[1624] =49000147,[1625] =49000148,[1626] =49000149,[1627] =49000150,[1628] =49000151,[1629] =49000152,[1630] =49000153,[1631] =49000154,[1632] =49000155,[1633] =49000156,[1634] =49000157,[1635] =49000158,[1636] =49000159,[1637] =49000160,[1638] =49000161,[1639] =49000162,[1640] =49000163,[1641] =49000164,[1642] =49000165,[1643] =49000166,[1644] =49000167,[1645] =49000168,[1646] =49000169,[1647] =49000170,[1648] =49000171,[1649] =49000172,[1650] =49000173,[1651] =49000174,[1652] =49000175,[1653] =49000176,[1654] =49000177,[1655] =49000178,[1656] =49000179,[1657] =49000180,[1658] =49000181,[1659] =49000182,[1660] =49000183,[1661] =49000184,[1662] =49000185,[1663] =49000186,[1664] =49000187,[1665] =49000188,[1666] =49000189,[1667] =49000190,[1668] =49000191,[1669] =49000192,[1670] =49000193,[1671] =49000194,[1672] =49000195,[1673] =49000196,[1674] =49000197,[1675] =49000198,[1676] =49000199,[1677] =49000200,[1678] =49000201,[1679] =49000202,[1680] =49000203,[1681] =49000204,[1682] =49000205,[1683] =49000206,[1684] =49000207,[1685] =49000208,[1686] =49000209,[1687] =49000210,[1688] =49000211,[1689] =49000212,[1690] =49000213,[1691] =49000214,[1692] =49000215,[1693] =49000216,[1694] =49000217,[1695] =49000218,[1696] =49000219,[1697] =49000220,[1698] =49000221,[1699] =49000222,[1700] =49000223,[1701] =49000224,[1702] =49000225,[1703] =49000226,[1704] =49000227,[1705] =49000228,[1706] =49000229,[1707] =49000230,[1708] =49000231,[1709] =49000232,[1710] =49000233,[1711] =49000234,[1712] =49000235,[1713] =49000236,[1714] =49000237,[1715] =49000238,[1716] =49000239,[1717] =49000240,[1718] =49000241,[1719] =49000242,[1720] =49000243,[1721] =49000244,[1722] =49000245,[1723] =49000246,[1724] =49000247,[1725] =49000248,[1726] =49000249,[1727] =49000250,[1728] =49000251,[1729] =49000252,[1730] =49000253,[1731] =49000254,[1732] =49000255,[1733] =49000256,[1734] =49000257,[1735] =49000258,[1736] =49000259,[1737] =49000260,[1738] =49000261,[1739] =49000262,[1740] =49000263,[1741] =49000264,[1742] =49000265,[1743] =49000266,[1744] =49000267,[1745] =49000268,[1746] =49000269,[1747] =49000270,[1748] =49000271,[1749] =49000272,[1750] =49000273,[1751] =49000274,}
--魂冰石
local g_HunBing = {
		20310117,	--魂冰珠（1级）
		20310118,	--魂冰珠（2级）
		20310119,	--魂冰珠（3级）
		20310120,	--魂冰珠（4级）
		20310121,	--魂冰珠（5级）
		}

--绑定魂冰石
local g_HunBing_Bind = {
		20310117,	--魂冰珠（1级）
		20310118,	--魂冰珠（2级）
		20310119,	--魂冰珠（3级）
		20310120,	--魂冰珠（4级）
		20310121,	--魂冰珠（5级）
		}
		
local g_LevelMax = 6

local nKfsData = ""
local g_KfsSkillData = ""
		
--PreLoad
function WuhunSkillUp_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("UPDATE_KFS_SKILLUP")
	this:RegisterEvent("UNIT_MONEY",false);
	this:RegisterEvent("MONEYJZ_CHANGE",false);
	this:RegisterEvent("PACKAGE_ITEM_CHANGED_EX",false)
end

--OnLoad
function WuhunSkillUp_OnLoad()
	Skills[1] = WuhunSkillUp_Object2
	Skills[2] = WuhunSkillUp_Object3
	Skills[3] = WuhunSkillUp_Object4
end

--OnEvent
function WuhunSkillUp_OnEvent(event)

	if (event == "UI_COMMAND" and tonumber(arg0) == m_UI_NUM) then
		
		WuhunSkillUp_BeginCareObj( Get_XParam_INT(0) );
		
		WuhunSkillUp_Update(-1)
		WuhunSkillUp_Update_Sub(-1)
		this:Show();

	elseif (event == "UI_COMMAND" and arg0 == "201107281" and this:IsVisible() ) then
		if arg1 == nil then
			return
		end
		local itemID = PlayerPackage:GetItemTableIndex(tonumber(arg1));
		if itemID < 19999999 and itemID > 10000000 then
			--为装备
			nKfsData = SuperTooltips:GetAuthorInfo();
			WuhunSkillUp_Update(tonumber(arg1))
			return
		end
		if itemID < 50000000 and itemID > 20000000 then
			--为材料
			WuhunSkillUp_Update_Sub(tonumber(arg1))
			return
		end	
	elseif (event == "UNIT_MONEY") then
		WuhunSkillUp_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
	
	elseif (event == "MONEYJZ_CHANGE") then 
		WuhunSkillUp_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
	
	elseif (event == "PACKAGE_ITEM_CHANGED_EX") then
		--WuhunSkillUp_UICheck()
		if arg0 ~= nil and tonumber(arg0) == m_Equip_Idx then
			WuhunSkillUp_Update(m_Equip_Idx)
		elseif  arg0 ~= nil and tonumber(arg0) == m_Equip_Item then
			WuhunSkillUp_Update_Sub(m_Equip_Item)
		end 
	end
end

--Update UI
function WuhunSkillUp_Update(itemIdx)
	local theAction = EnumAction(itemIdx, "packageitem");
	local _,_,_,_,_,_,_,nSkill = LuaGetKfsAttrData(nKfsData)
	g_KfsSkillData = nSkill
	if theAction:GetID() ~= 0 then

		if LifeAbility : Get_Equip_Point(itemIdx) ~= 18 then
			PushDebugMessage("#{WHYH_161121_33}")	--此处只能放入武魂。
			return
		end

		local nSumSkill = Lua_GetBagKfsSkillNum(g_KfsSkillData)
		if nSumSkill ~= nil and nSumSkill <= 0 then
			if m_Equip_Idx == itemIdx then
				WuhunSkillUp_Object1:SetActionItem(-1);			
				LifeAbility : Lock_Packet_Item(m_Equip_Idx,0);		
				m_Equip_Idx = -1;
				return
			end
			PushDebugMessage("#{WHYH_161121_61}")	--当前武魂没有领悟技能，请先领悟技能再进行技能升级操作
			return
		end

		if m_Equip_Idx ~= -1 then
			LifeAbility : Lock_Packet_Item(m_Equip_Idx,0);
			WuhunSkillUp_Update_Sub(-1)--清空材料
		end

		WuhunSkillUp_Object1:SetActionItem(theAction:GetID());
		LifeAbility : Lock_Packet_Item(itemIdx,1);
		m_Equip_Idx = itemIdx
	else
		WuhunSkillUp_Object1:SetActionItem(-1);			
		LifeAbility : Lock_Packet_Item(m_Equip_Idx,0);		
		m_Equip_Idx = -1;
		WuhunSkillUp_Update_Sub(-1)--清空材料
	end
	WuhunSkillUp_UICheck()
end

--Update UI
function WuhunSkillUp_Update_Sub(itemIdx)
	local theAction = EnumAction(itemIdx, "packageitem");
	if theAction:GetID() ~= 0 then
		-- 该界面是否已置入武魂
		if m_Equip_Idx == -1 then
			PushDebugMessage("#{WHYH_161121_63}")
			return
		end
		if LifeAbility : Get_Equip_Point(m_Equip_Idx) ~= 18 then
			PushDebugMessage("#{WHYH_161121_63}")
			return
		end
		
		-- 当前武魂是否拥有技能
		local nSumSkill = Lua_GetBagKfsSkillNum(g_KfsSkillData)
		if nSumSkill == nil or nSumSkill <= 0 then
			PushDebugMessage("#{WHYH_161121_64}")	--当前武魂没有领悟技能，请先领悟技能再进行技能升级操作
			return
		end
		
		-- 是否已选中任一希望升级的技能
		if skillSelected == -1 then
			PushDebugMessage("#{WHYH_161121_65}") --请选择需要升级的技能
			return
		end	
		
		-- 升级后技能
		local upSkillID,needItem,nMoney,nLevel = Lua_GetkfsSkillLevelUp(Lua_GetKfsSkill(g_KfsSkillData,skillSelected + 1))
		if upSkillID == nil or upSkillID == 0 then
			PushDebugMessage("#{WHYH_161121_65}")  --请选择需要升级的技能
			return
		end		
		
		-- 武魂的当前技能是否已提升至最高级
		if upSkillID == -1 then
			PushDebugMessage("#{WHYH_161121_66}")  --该技能已经达到最高等级，不能继续升级！
			return
		end
		
		-- 所需材料
		if needItem ~= nil and needItem <= 0 then
			PushDebugMessage("#{WHYH_161121_66}")
			return
		end
		local needItemBind = WuhunSkillUp_GetBindItemIndex(needItem)
		if needItemBind ~= nil and needItemBind <= 0 then
			PushDebugMessage("#{WHYH_161121_66}")
			return
		end
					
		-- 道具是否为魂冰珠
		local itemID = PlayerPackage:GetItemTableIndex(itemIdx)
		local bValid = WuhunSkillUp_CheckItemValid(itemID)
		if bValid == nil or bValid <= 0 then
			PushDebugMessage("#{WHYH_161121_67}") -- 此处只能放入。
			return
		end

		if PlayerPackage:IsLock( itemIdx ) == 1 then
			PushDebugMessage("#{WHYH_161121_68}")	--上锁了
			return
		end
		
		-- 当前是否符合已选中的升级所需
		if itemID ~= needItem and itemID ~= needItemBind then
			if m_Equip_Item == itemIdx then
				WuhunSkillUp_Object6:SetActionItem(-1);			
				LifeAbility : Lock_Packet_Item(m_Equip_Item,0);		
				m_Equip_Item = -1;
				return
			end
			local needItemName = LuaFnGetItemName(needItem)
			local bRet,strSkillName = Lua_GetKfsSkillName(upSkillID)
			if bRet == 1 then
				local tips = string.format("升级至%s#H技能需要使用一颗%s#H。您当前放入的魂冰珠不符合升级条目的需要，请重新放置。", strSkillName, needItemName)
				PushDebugMessage(tips)
			end
			return
		end

		if m_Equip_Item ~= -1 then
			LifeAbility : Lock_Packet_Item(m_Equip_Item,0);
		end

		WuhunSkillUp_Object6:SetActionItem(theAction:GetID());
		LifeAbility : Lock_Packet_Item(itemIdx,1);
		m_Equip_Item = itemIdx
	else
		WuhunSkillUp_Object6:SetActionItem(-1);			
		LifeAbility : Lock_Packet_Item(m_Equip_Item,0);		
		m_Equip_Item = -1;
	end
	
	WuhunSkillUp_UICheck()
end

-- 检测放入的材料是否是魂冰珠，如果是则返回下标
function WuhunSkillUp_CheckItemValid(itemID)
	if itemID == nil or itemID <= 0 then
		return 0
	end
	
	-- 查找放入的道具是否为非绑定材料，返回对应的下标
	for i=1, table.getn(g_HunBing) do
		if g_HunBing[i] == itemID then
			return i
		end
	end
	
	-- 查找放入的道具是否为绑定材料，返回对应的下标
	for i=1, table.getn(g_HunBing_Bind) do
		if g_HunBing_Bind[i] == itemID then
			return i
		end
	end
	
	return 0
end

-- 获得所需的材料对应的绑定材料
function WuhunSkillUp_GetBindItemIndex(needItem)
	if needItem == nil or needItem <= 0 then
		return 0
	end

	-- 所需材料id对应的索引
	local needLevelIndex = 0
	for i=1, table.getn(g_HunBing) do
		if g_HunBing[i] == needItem then
			needLevelIndex = i
			break
		end
	end
	if needLevelIndex == 0 then
		return 0
	end
	
	-- 所需材料对应的绑定材料
	return g_HunBing_Bind[needLevelIndex]
end

-- quick ok
function WuhunSkillUp_Quick_OK_Clicked()
	-- 判断是否为安全时间
	if (tonumber(DataPool:GetLeftProtectTime()) > 0) then
		PushDebugMessage("#{WHYH_161121_8}")
		return
	end
	
	-- 是否放入武魂
	if m_Equip_Idx == -1 then
		PushDebugMessage("#{WHYH_161121_70}")
		return
	end
	if LifeAbility : Get_Equip_Point(m_Equip_Idx) ~= 18 then
		PushDebugMessage("#{WHYH_161121_70}")
		return
	end

	-- 当前武魂是否拥有技能
	local nSumSkill = Lua_GetBagKfsSkillNum(g_KfsSkillData)
	if nSumSkill == nil or nSumSkill <= 0 then
		PushDebugMessage("#{WHYH_161121_71}")	--当前武魂没有领悟技能，请先领悟技能再进行技能升级操作
		return
	end
	
	if skillSelected == -1 then
		PushDebugMessage("#{WHYH_161121_72}") --请选择需要升级的技能
		return
	end

	local upSkillID = Lua_GetkfsSkillLevelUp(Lua_GetKfsSkill(g_KfsSkillData,skillSelected + 1))
	if upSkillID == -1 then
		PushDebugMessage("#{WHYH_161121_66}")  --该技能已经达到最高等级，不能继续升级！
		return
	end
    PushDebugMessage("暂不开放快捷提升功能。")
end

--OnOK
function WuhunSkillUp_OK_Clicked()
	-- 判断是否为安全时间
	if (tonumber(DataPool:GetLeftProtectTime()) > 0) then
		PushDebugMessage("#{WHYH_161121_8}")
		return
	end
	
	-- 是否放入武魂
	if m_Equip_Idx == -1 then
		PushDebugMessage("#{WHYH_161121_70}")
		return
	end
	if LifeAbility : Get_Equip_Point(m_Equip_Idx) ~=18 then
		PushDebugMessage("#{WHYH_161121_70}")
		return
	end

	-- 当前武魂是否拥有技能
	local nSumSkill = Lua_GetBagKfsSkillNum(g_KfsSkillData)
	if nSumSkill == nil or nSumSkill <= 0 then
		PushDebugMessage("#{WHYH_161121_71}")	--当前武魂没有领悟技能，请先领悟技能再进行技能升级操作
		return
	end
	
	if skillSelected == -1 then
		PushDebugMessage("#{WHYH_161121_72}") --请选择需要升级的技能
		return
	end

	local upSkillID,needItem,needMoney,nLevel = Lua_GetkfsSkillLevelUp(Lua_GetKfsSkill(g_KfsSkillData,skillSelected + 1))
	if upSkillID == nil or upSkillID == 0 then
		PushDebugMessage("#{WHYH_161121_72}")  --请选择需要升级的技能
		return
	end
	
	-- 所需材料
	if needItem ~= nil and needItem <= 0 then
		PushDebugMessage("#{WHYH_161121_72}")
		return
	end
	local needItemBind = WuhunSkillUp_GetBindItemIndex(needItem)
	if needItemBind ~= nil and needItemBind <= 0 then
		PushDebugMessage("#{WHYH_161121_72}")
		return
	end
		
	if upSkillID == -1 then
		PushDebugMessage("#{WHYH_161121_66}")  --该技能已经达到最高等级，不能继续升级！
		return
	end
	
	-- 界面是否已置入魂冰珠
	if m_Equip_Item == -1 then
		PushDebugMessage("#{WHYH_161121_74}") --请先放入升级技所需的魂冰珠，再进行该操作
		return
	end	
	
	-- 道具是否为魂冰珠
	local itemID = PlayerPackage:GetItemTableIndex(m_Equip_Item)
	local bValid = WuhunSkillUp_CheckItemValid(itemID)
	if bValid == nil or bValid <= 0 then
		PushDebugMessage("#{WHYH_161121_74}") -- 此处只能放入。
		return
	end

	if PlayerPackage:IsLock( m_Equip_Item ) == 1 then
		PushDebugMessage("#{WHYH_161121_68}")	--上锁了
		return
	end
	
	-- 当前是否符合已选中的升级所需
	if itemID ~= needItem and itemID ~= needItemBind then
		local needItemName = LuaFnGetItemName(needItem)
		local bRet,strSkillName = Lua_GetKfsSkillName(upSkillID)
		if bRet == 1 then
			local tips = string.format("升级至%s#H技能需要使用一颗%s#H。您当前放入的魂冰珠不符合升级条目的需要，请重新放置。", strSkillName, needItemName)
			PushDebugMessage(tips)
		end
		return
	end

	local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")
	
	if selfMoney < needMoney then
		PushDebugMessage("#{WHYH_161121_75}")  --对不起，你身上金钱不足，无法继续进行
		return
	end
	
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("KfsSkillUp");
		Set_XSCRIPT_ScriptID(900004);
		Set_XSCRIPT_Parameter(0,m_Equip_Idx);
		Set_XSCRIPT_Parameter(1,m_Equip_Item);
		Set_XSCRIPT_Parameter(2,skillSelected);
		Set_XSCRIPT_Parameter(3,0);-- 0 普通 1 快捷 2 快捷确认
		Set_XSCRIPT_ParamCount(4);
	Send_XSCRIPT();	
end


--select a skill
function WuhunSkillUp_Select_Skill(skill_index)

	-- 相同则不必更新
	if skillSelected == skill_index then
		return
	end
	
	Skills[1]:SetPushed(0)
	Skills[2]:SetPushed(0)
	Skills[3]:SetPushed(0)

	Skills[skill_index + 1]:SetPushed(1)
	skillSelected = skill_index
	
	local _,_,needMoney = Lua_GetkfsSkillLevelUp(Lua_GetKfsSkill(g_KfsSkillData,skill_index + 1))
	WuhunSkillUp_DemandMoney:SetProperty("MoneyNumber", needMoney); 
	
	-- 清空材料栏并在uicheck里更新所需材料
	WuhunSkillUp_Update_Sub(-1)
	
end

--Right button clicked
function WuhunSkillUp_Resume_Equip()

	WuhunSkillUp_Update(-1)

end

--Right button clicked
function WuhunSkillUp_Resume_Item()

	WuhunSkillUp_Update_Sub(-1)

end

--Care Obj
function WuhunSkillUp_BeginCareObj(obj_id)
	
	m_ObjCared = DataPool : GetNPCIDByServerID(obj_id);
	this:CareObject(m_ObjCared, 1);
end

--handle Hide Event
function WuhunSkillUp_OnHiden()

	WuhunSkillUp_Update(-1)
	WuhunSkillUp_Update_Sub(-1)
	
end


function WuhunSkillUp_UICheck()
	WuhunSkillUp_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"));
	WuhunSkillUp_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ")); 
	WuhunSkillUp_DemandMoney:SetProperty("MoneyNumber", 0); 
	WuhunSkillUp_OK:Disable()
	-- 所需材料
	WuhunSkillUp_Object5:SetActionItem(-1)
	-- 快捷提升	
	WuhunSkillUp_QuicklyUp:Disable()
	WuhunSkillUp_QuicklyUp:SetText("#{WHYH_161121_31}")
	WuhunSkillUp_QuicklyUp_Animate:SetToolTip("")
	WuhunSkillUp_QuicklyUp_Animate:Play(false)

	Skills[1]:SetActionItem(-1)
	Skills[2]:SetActionItem(-1)
	Skills[3]:SetActionItem(-1)
	Skills[1]:SetPushed(0)
	Skills[2]:SetPushed(0)
	Skills[3]:SetPushed(0)
	Kfs_Skill_ID = {}
	
	if m_Equip_Idx ~= -1 then
		local nSumSkill = Lua_GetBagKfsSkillNum(g_KfsSkillData)
		if nSumSkill ~= nil and nSumSkill > 0 and nSumSkill < 4 then
			for i=1 ,3 do
				local skillID = Lua_GetKfsSkill(g_KfsSkillData,i)
				if skillID ~= nil and skillID > 0 then
					Kfs_Skill_ID[i] = skillID
				else
					Kfs_Skill_ID[i] = -1
				end
			end
			
			local theAction_kfs = EnumAction(m_Equip_Idx, "packageitem");
			local kfsID = -1
			for i=1, nSumSkill do
				if Kfs_SkillCommonId[Kfs_Skill_ID[i]] ~= nil then
					local theAction = GemMelting:UpdateProductAction(Kfs_SkillCommonId[Kfs_Skill_ID[i]])
					if theAction:GetID() ~= 0 then
						Skills[i]:SetActionItem(theAction:GetID());
					end
				end
			end
			
			local upSkillID,needItem,needMoney,nLevel = Lua_GetkfsSkillLevelUp(Lua_GetKfsSkill(g_KfsSkillData,skillSelected + 1))
			if skillSelected ~= -1  then
				Skills[skillSelected + 1]:SetPushed(1)	
				WuhunSkillUp_DemandMoney:SetProperty("MoneyNumber", needMoney); 
			end
			
			-- 所需材料
			if needItem ~= nil and needItem > 0 then
				local theAction = GemMelting:UpdateProductAction(needItem)
				if theAction:GetID() ~= 0 then
					WuhunSkillUp_Object5:SetActionItem(theAction:GetID())
				end
			end
			
			-- 快捷提升	
			if skillSelected ~= -1  then
				WuhunSkillUp_QuicklyUp:Enable()
				WuhunSkillUp_QuicklyUp:SetText("#{WHYH_161121_131}")
				WuhunSkillUp_QuicklyUp_Animate:SetToolTip(string.format("#Y您可通过直接支付元宝的方式，将武魂技能提升至%s#Y级。提升前的武魂技能等级不同，提升至%s#Y级所需支付的元宝数量也不同。", g_LevelMax, g_LevelMax))--目前只开放到6级
				WuhunSkillUp_QuicklyUp_Animate:Play(true)
			end
				
		else
			skillSelected = -1	--没有技能
		end
	else
		skillSelected = -1  --武魂栏 空
	end
	
	if m_Equip_Idx ~= -1 and m_Equip_Item ~= -1 then
		WuhunSkillUp_OK:Enable()
	end

end

function Lua_GetkfsSkillLevelUp(nSkillID)
	local nSkillLevelupTab = {
	[1500] = {1501,20310117,10000,1},
	[1501] = {1502,20310118,10000,2},
	[1502] = {1503,20310119,15000,3},
	[1503] = {1504,20310120,15000,4},
	[1504] = {1505,20310121,20000,5},
	[1505] = {-1,-1,-1,6},
	[1506] = {1507,20310117,10000,1},
	[1507] = {1508,20310118,10000,2},
	[1508] = {1509,20310119,15000,3},
	[1509] = {1510,20310120,15000,4},
	[1510] = {1511,20310121,20000,5},
	[1511] = {-1,-1,-1,6},
	[1512] = {1513,20310117,10000,1},
	[1513] = {1514,20310118,10000,2},
	[1514] = {1515,20310119,15000,3},
	[1515] = {1516,20310120,15000,4},
	[1516] = {1517,20310121,20000,5},
	[1517] = {-1,-1,-1,6},
	[1518] = {1519,20310117,10000,1},
	[1519] = {1520,20310118,10000,2},
	[1520] = {1521,20310119,15000,3},
	[1521] = {1522,20310120,15000,4},
	[1522] = {1523,20310121,20000,5},
	[1523] = {-1,-1,-1,6},
	[1524] = {1525,20310117,10000,1},
	[1525] = {1526,20310118,10000,2},
	[1526] = {1527,20310119,15000,3},
	[1527] = {1528,20310120,15000,4},
	[1528] = {1529,20310121,20000,5},
	[1529] = {-1,-1,-1,6},
	[1530] = {1531,20310117,10000,1},
	[1531] = {1532,20310118,10000,2},
	[1532] = {1533,20310119,15000,3},
	[1533] = {1534,20310120,15000,4},
	[1534] = {1535,20310121,20000,5},
	[1535] = {-1,-1,-1,6},
	[1536] = {1537,20310117,10000,1},
	[1537] = {1538,20310118,10000,2},
	[1538] = {1539,20310119,15000,3},
	[1539] = {1540,20310120,15000,4},
	[1540] = {1541,20310121,20000,5},
	[1541] = {-1,-1,-1,6},
	[1542] = {1543,20310117,10000,1},
	[1543] = {1544,20310118,10000,2},
	[1544] = {1545,20310119,15000,3},
	[1545] = {1546,20310120,15000,4},
	[1546] = {1547,20310121,20000,5},
	[1547] = {-1,-1,-1,6},
	[1548] = {1549,20310117,10000,1},
	[1549] = {1550,20310118,10000,2},
	[1550] = {1551,20310119,15000,3},
	[1551] = {1552,20310120,15000,4},
	[1552] = {1553,20310121,20000,5},
	[1553] = {-1,-1,-1,6},
	[1554] = {1555,20310117,10000,1},
	[1555] = {1556,20310118,10000,2},
	[1556] = {1557,20310119,15000,3},
	[1557] = {1558,20310120,15000,4},
	[1558] = {1559,20310121,20000,5},
	[1559] = {-1,-1,-1,6},
	[1560] = {1561,20310117,10000,1},
	[1561] = {1562,20310118,10000,2},
	[1562] = {1563,20310119,15000,3},
	[1563] = {1564,20310120,15000,4},
	[1564] = {1565,20310121,20000,5},
	[1565] = {-1,-1,-1,6},
	[1566] = {1567,20310117,10000,1},
	[1567] = {1568,20310118,10000,2},
	[1568] = {1569,20310119,15000,3},
	[1569] = {1570,20310120,15000,4},
	[1570] = {1571,20310121,20000,5},
	[1571] = {-1,-1,-1,6},
	[1572] = {1573,20310117,10000,1},
	[1573] = {1574,20310118,10000,2},
	[1574] = {1575,20310119,15000,3},
	[1575] = {1576,20310120,15000,4},
	[1576] = {1577,20310121,20000,5},
	[1577] = {-1,-1,-1,6},
	[1578] = {1579,20310117,10000,1},
	[1579] = {1580,20310118,10000,2},
	[1580] = {1581,20310119,15000,3},
	[1581] = {1582,20310120,15000,4},
	[1582] = {1583,20310121,20000,5},
	[1583] = {-1,-1,-1,6},
	[1584] = {1585,20310117,10000,1},
	[1585] = {1586,20310118,10000,2},
	[1586] = {1587,20310119,15000,3},
	[1587] = {1588,20310120,15000,4},
	[1588] = {1589,20310121,20000,5},
	[1589] = {-1,-1,-1,6},
	[1590] = {1591,20310117,10000,1},
	[1591] = {1592,20310118,10000,2},
	[1592] = {1593,20310119,15000,3},
	[1593] = {1594,20310120,15000,4},
	[1594] = {1595,20310121,20000,5},
	[1595] = {-1,-1,-1,6},
	[1596] = {1597,20310117,10000,1},
	[1597] = {1598,20310118,10000,2},
	[1598] = {1599,20310119,15000,3},
	[1599] = {1600,20310120,15000,4},
	[1600] = {1601,20310121,20000,5},
	[1601] = {-1,-1,-1,6},
	[1602] = {1603,20310117,10000,1},
	[1603] = {1604,20310118,10000,2},
	[1604] = {1605,20310119,15000,3},
	[1605] = {1606,20310120,15000,4},
	[1606] = {1607,20310121,20000,5},
	[1607] = {-1,-1,-1,6},
	[1608] = {1609,20310117,10000,1},
	[1609] = {1610,20310118,10000,2},
	[1610] = {1611,20310119,15000,3},
	[1611] = {1612,20310120,15000,4},
	[1612] = {1613,20310121,20000,5},
	[1613] = {-1,-1,-1,6},
	[1614] = {1615,20310117,10000,1},
	[1615] = {1616,20310118,10000,2},
	[1616] = {1617,20310119,15000,3},
	[1617] = {1618,20310120,15000,4},
	[1618] = {1619,20310121,20000,5},
	[1619] = {-1,-1,-1,6},
	[1620] = {1621,20310117,10000,1},
	[1621] = {1622,20310118,10000,2},
	[1622] = {1623,20310119,15000,3},
	[1623] = {1624,20310120,15000,4},
	[1624] = {1625,20310121,20000,5},
	[1625] = {-1,-1,-1,6},
	[1626] = {1627,20310117,10000,1},
	[1627] = {1628,20310118,10000,2},
	[1628] = {1629,20310119,15000,3},
	[1629] = {1630,20310120,15000,4},
	[1630] = {1631,20310121,20000,5},
	[1631] = {-1,-1,-1,6},
	[1632] = {1633,20310117,10000,1},
	[1633] = {1634,20310118,10000,2},
	[1634] = {1635,20310119,15000,3},
	[1635] = {1636,20310120,15000,4},
	[1636] = {1637,20310121,20000,5},
	[1637] = {-1,-1,-1,6},
	[1638] = {1639,20310117,10000,1},
	[1639] = {1640,20310118,10000,2},
	[1640] = {1641,20310119,15000,3},
	[1641] = {1642,20310120,15000,4},
	[1642] = {1643,20310121,20000,5},
	[1643] = {-1,-1,-1,6},
	[1644] = {1645,20310117,10000,1},
	[1645] = {1646,20310118,10000,2},
	[1646] = {1647,20310119,15000,3},
	[1647] = {1648,20310120,15000,4},
	[1648] = {1649,20310121,20000,5},
	[1649] = {-1,-1,-1,6},
	[1650] = {1651,20310117,10000,1},
	[1651] = {1652,20310118,10000,2},
	[1652] = {1653,20310119,15000,3},
	[1653] = {1654,20310120,15000,4},
	[1654] = {1655,20310121,20000,5},
	[1655] = {-1,-1,-1,6},
	[1656] = {1657,20310117,10000,1},
	[1657] = {1658,20310118,10000,2},
	[1658] = {1659,20310119,15000,3},
	[1659] = {1660,20310120,15000,4},
	[1660] = {1661,20310121,20000,5},
	[1661] = {-1,-1,-1,6},
	[1662] = {1663,20310117,10000,1},
	[1663] = {1664,20310118,10000,2},
	[1664] = {1665,20310119,15000,3},
	[1665] = {1666,20310120,15000,4},
	[1666] = {1667,20310121,20000,5},
	[1667] = {-1,-1,-1,6},
	[1668] = {1669,20310117,10000,1},
	[1669] = {1670,20310118,10000,2},
	[1670] = {1671,20310119,15000,3},
	[1671] = {1672,20310120,15000,4},
	[1672] = {1673,20310121,20000,5},
	[1673] = {-1,-1,-1,6},
	[1674] = {1675,20310117,10000,1},
	[1675] = {1676,20310118,10000,2},
	[1676] = {1677,20310119,15000,3},
	[1677] = {1678,20310120,15000,4},
	[1678] = {1679,20310121,20000,5},
	[1679] = {-1,-1,-1,6},
	[1680] = {1681,20310117,10000,1},
	[1681] = {1682,20310118,10000,2},
	[1682] = {1683,20310119,15000,3},
	[1683] = {1684,20310120,15000,4},
	[1684] = {1685,20310121,20000,5},
	[1685] = {-1,-1,-1,6},
	[1686] = {1687,20310117,10000,1},
	[1687] = {1688,20310118,10000,2},
	[1688] = {1689,20310119,15000,3},
	[1689] = {1690,20310120,15000,4},
	[1690] = {1691,20310121,20000,5},
	[1691] = {-1,-1,-1,6},
	[1692] = {1693,20310117,10000,1},
	[1693] = {1694,20310118,10000,2},
	[1694] = {1695,20310119,15000,3},
	[1695] = {1696,20310120,15000,4},
	[1696] = {1697,20310121,20000,5},
	[1697] = {-1,-1,-1,6},
	[1698] = {1699,20310117,10000,1},
	[1699] = {1700,20310118,10000,2},
	[1700] = {1701,20310119,15000,3},
	[1701] = {1702,20310120,15000,4},
	[1702] = {1703,20310121,20000,5},
	[1703] = {-1,-1,-1,6},
	[1704] = {1705,20310117,10000,1},
	[1705] = {1706,20310118,10000,2},
	[1706] = {1707,20310119,15000,3},
	[1707] = {1708,20310120,15000,4},
	[1708] = {1709,20310121,20000,5},
	[1709] = {-1,-1,-1,6},
	[1710] = {1711,20310117,10000,1},
	[1711] = {1712,20310118,10000,2},
	[1712] = {1713,20310119,15000,3},
	[1713] = {1714,20310120,15000,4},
	[1714] = {1715,20310121,20000,5},
	[1715] = {-1,-1,-1,6},
	[1716] = {1717,20310117,10000,1},
	[1717] = {1718,20310118,10000,2},
	[1718] = {1719,20310119,15000,3},
	[1719] = {1720,20310120,15000,4},
	[1720] = {1721,20310121,20000,5},
	[1721] = {-1,-1,-1,6},
	[1722] = {1723,20310117,10000,1},
	[1723] = {1724,20310118,10000,2},
	[1724] = {1725,20310119,15000,3},
	[1725] = {1726,20310120,15000,4},
	[1726] = {1727,20310121,20000,5},
	[1727] = {-1,-1,-1,6},
	[1728] = {1729,20310117,10000,1},
	[1729] = {1730,20310118,10000,2},
	[1730] = {1731,20310119,15000,3},
	[1731] = {1732,20310120,15000,4},
	[1732] = {1733,20310121,20000,5},
	[1733] = {-1,-1,-1,6},
	[1734] = {1735,20310117,10000,1},
	[1735] = {1736,20310118,10000,2},
	[1736] = {1737,20310119,15000,3},
	[1737] = {1738,20310120,15000,4},
	[1738] = {1739,20310121,20000,5},
	[1739] = {-1,-1,-1,6},
	[1740] = {1741,20310117,10000,1},
	[1741] = {1742,20310118,10000,2},
	[1742] = {1743,20310119,15000,3},
	[1743] = {1744,20310120,15000,4},
	[1744] = {1745,20310121,20000,5},
	[1745] = {-1,-1,-1,6},
	[1746] = {1747,20310117,10000,1},
	[1747] = {1748,20310118,10000,2},
	[1748] = {1749,20310119,15000,3},
	[1749] = {1750,20310120,15000,4},
	[1750] = {1751,20310121,20000,5},
	[1751] = {-1,-1,-1,6},
	}
	local nNewSkillID,nItemID,nMoney,nLevel = 0,0,0,0
	if nSkillLevelupTab[nSkillID] ~= nil then
		nNewSkillID = nSkillLevelupTab[nSkillID][1]
		nItemID = nSkillLevelupTab[nSkillID][2]
		nMoney = nSkillLevelupTab[nSkillID][3]
		nLevel = nSkillLevelupTab[nSkillID][4]
	end
	return nNewSkillID,nItemID,nMoney,nLevel
end