local g_Agname_Frame_UnifiedPosition;
local g_Agname_MapIndex = {}	--1.title的索引，2.总数的索引
local g_Agname_LogicTypeTable = {}
local g_Agname_curselect = -1
local g_Agname_Curname = ""
local g_Agname_PageIndex = 0
local g_Agname_Time = 1 --冷却
local g_Agname_ServerData = {}
local g_nCurSelectAllTileListIndex = 1
local alltitlelist = {}
local nEffectNum = 0
local nEffectTab = {}
local effect = ""
local MyGuildPos = -1
local AGNAME_BUTTTONS = {}

--称号属性处理
local nAttrTable = {[0] = 0,[1] = 0,[6] = 0,[7] = 0,[9] = 0,[10] = 0,[12] = 0,[13] = 0,[15] = 0,[16] = 0,[19] = 0,[20] = 0,[26] = 0,[27] = 0,[44] = 0,[46] = 0,[48] = 0,[54] = 0,[55] = 0,[56] = 0,[57] = 0,}
--Board 参考表
-- 0		64	68	74	78		10	68	74	78
-- 1	nihongleft	64	68	74	78	nihongright	10	68	74	78
-- 2	wuqizuo	64	68	74	78	wuqiyou	10	68	74	78
-- 3	SongLiao1	40	42	36	40		10	68	74	78
-- 4	SongLiao2	45	40	45	44	SongLiao2	0	40	44	44
-- 5	SongLiao3	57	45	60	50	SongLiao3	0	45	60	50
-- 6	ZLHeroMeetingLevel1_Left	41	31	45	24	ZLHeroMeetingLevel1_Right	0	31	45	24
-- 7	ZLHeroMeetingLevel2_Left	57	36	59	33	ZLHeroMeetingLevel2_Right	0	36	59	33
-- 8	ZLHeroMeetingLevel3_Left	66	45	70	46	ZLHeroMeetingLevel3_Right	0	45	70	46
-- 9	ZLHeroMeetingLevel4_Left	89	45	90	50	ZLHeroMeetingLevel4_Right	0	45	90	50
-- 10	JiaRenYing_L	44	40	48	42	JiaRenYing_R	0	40	48	42
-- 11	WanFangZhu_L	90	50	94	56	WanFangZhu_R	0	50	94	56
-- 12	XingMouGu_L	57	45	68	44	XingMouGu_R	0	45	68	44
-- 13	QXHBL_L	63	45	60	48	QXHBL_R	0	45	60	48
-- 14	QXHBM_L	64	55	74	60	QXHBM_R	10	55	74	60
-- 15	QXHBH_L	64	56	74	60	QXHBH_R	10	56	74	60
-- 16	TLNS_GuardKnight_L	54	38	60	33	TLNS_GuardKnight_R	4	38	60	33
-- 17	GHJH_L	60	42	64	46	GHJH_R	2	42	64	46
-- 18	ZXZD_L	46	39	54	50	ZXZD_R	6	39	54	50
-- 19	ZhuJian_L	66	36	76	36	ZhuJian_R	4	36	76	36

local g_Agname_Image =
{
	[1] = "set:AgnameLayout image:AgnameLayout_Inuse",	--使用中
	[2] = "",	--已拥有
	[3] = "set:AgnameLayout image:AgnameLayout_Notgain"	--未拥有

}
local g_Agname_Info = {} 
function Agname_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("CLOSE_AGNAME");
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")	
	this:RegisterEvent("CHANGE_TITLE_STATUS")
end

function Agname_OnLoad()
	g_Agname_MapIndex = {}
	g_Agname_Frame_UnifiedPosition=AgnameFrame:GetProperty("UnifiedPosition");
	for i = 1,16 do
		AGNAME_BUTTTONS[i] = {
		_G[string.format("AgnameFrame_ListContent_CoinAItem_%d",i)],
		_G[string.format("AgnameFrame_CoinAItem_Image_%d",i)],
		_G[string.format("AgnameFrame_CoinAItem_Icon_%d",i)],
		}
	end
	Agname_Button_Show:SetText("#{XCHXT_180124_17}")
end

-- OnEvent
function Agname_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == 20211113 ) then
		local nGetData = 0
		local nAgnameNum = GetAgnameNum()
		local nAgnameState = Get_XParam_STR(0)
		MyGuildPos = Get_XParam_INT(0)
		if nAgnameState ~= nil and nAgnameState ~= "" then
			local nAgnameStateTab = nAgnameState
			for i = 1,string.len(nAgnameStateTab) do
				local nAgnameData = string.sub(nAgnameStateTab,i,i)
				if nAgnameData ~= nil and nAgnameData ~= "" and table.getn(g_Agname_ServerData) < nAgnameNum then
					table.insert(g_Agname_ServerData,tonumber(nAgnameData))
				end
			end
		end
		if table.getn(g_Agname_ServerData) < nAgnameNum then
			Clear_XSCRIPT()
				Set_XSCRIPT_Function_Name( "OpenAgname" );
				Set_XSCRIPT_ScriptID(992004);
				Set_XSCRIPT_Parameter(0,g_Agname_Time);
				Set_XSCRIPT_ParamCount(1);	
			Send_XSCRIPT()
			g_Agname_Time = g_Agname_Time + 1
			return
		end
		if table.getn(g_Agname_ServerData) >= nAgnameNum then
		--数据接收完毕后开始打开UI
			Clear_XSCRIPT()
				Set_XSCRIPT_Function_Name( "OpenAgname" );
				Set_XSCRIPT_ScriptID(992004);
				Set_XSCRIPT_Parameter(0,999);
				Set_XSCRIPT_ParamCount(1);	
			Send_XSCRIPT()					
			return
		end
		
		-- Agname_ListContent:RemoveAllItem()	
		-- for i = 1,100 do
			-- Agname_ListContent:AddNewItem("称号名称",0,i)
		-- end
		-- 
		-- Agname_UpdateFrame();
		-- 
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 202111131 ) then
		------------------------------------------------测试数据
		-- local nTest = ""
		-- for i = 1,table.getn(g_Agname_ServerData) do
			-- nTest = nTest..g_Agname_ServerData[i].."\n"
		-- end
		-- local file = io.open("./Log.txt", "wb")
		-- if file ~= nil and nTest ~= ""then
		    -- file:write(nTest);
			-- file:close();
		-- end
		-----------------------------------------
		
		g_Agname_Time = 1
		nEffectTab = {}
		nAttrTable = {[0] = 0,[1] = 0,[6] = 0,[7] = 0,[9] = 0,[10] = 0,[12] = 0,[13] = 0,[15] = 0,[16] = 0,[19] = 0,[20] = 0,[26] = 0,[27] = 0,[44] = 0,[46] = 0,[48] = 0,[54] = 0,[55] = 0,[56] = 0,[57] = 0,}
		effect = ""
		Agname_Init();
		Agname_UpdateFrame();
		this:Show();
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 20211121 ) then
		local nState = Get_XParam_STR(0)
		local nData = Get_XParam_STR(1)
		SystemSetup:SetPrivateInfo("self",nState,nData)
		SystemSetup:ApplyPrivateInfo()
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 120211121 ) then
		--更新
		Agname_RestUpDate()
	end
	
	if ( event == "CLOSE_AGNAME" ) then
		Agname_CloseUI()
	end
	
		-- 游戏窗口尺寸发生了变化
	if (event == "ADJEST_UI_POS" ) then
		Agname_Frame_On_ResetPos()
	-- 游戏分辨率发生了变化
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		Agname_Frame_On_ResetPos()
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 320211121 ) then
		Player:SetNullAgname();
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 220211121 ) then
		if this:IsVisible() then
			Agname_UpdateFrame()
			-- Agname_RestUpDate()
		end
	end
end

function Agname_Init()
	local Show_Hide = Lua_Get_IsShow_Hide_Flag()
	if Show_Hide == 1 then
		Agname_Button_Show:SetText("#{XCHXT_180124_12}") --显示称号
	else
		Agname_Button_Show:SetText("#{XCHXT_180124_17}") --隐藏称号
	end
end

----------------------------------------------------------------------------------------
--
-- 关闭界面
--

function Agname_CloseUI()
	--数据清空
	g_Agname_PageIndex = 0
	g_Agname_ServerData = {}
	this:Hide()
end

function Agname_LeftLoad()
	if table.getn(g_Agname_ServerData) <= 0 then
		return
	end
	-- Agname_ListContent:RemoveAllItem()
	AgnameFrame_Text:Hide()
	g_Agname_Curname = ""
	local nAgnameNum = GetAgnameNum();
	-- PushDebug("nAgnameNum "..tostring(nAgnameNum))
		--已拥有称号前排显示
		g_Agname_LogicTypeTable = {}
		-- local count = GetAllTitlesNum();    --获取当前的类型数量
		local index = 0
		local name = ""
		local valid = 1
		local titleindex = 0
		local curid = GetCurTitleID()
		local curstr = Player:GetCurrentAgname()
		for i = 1 , nAgnameNum do
			-- local tableindex = index
			index,titleindex,logictype,level,bnew,name,_,_,_,_,property = FeatchVaildTitle(i);
			
			-- PushDebug(name)
			if string.find(name,"$N") ~= nil then
				name = string.gsub(name,"$N","**")
			end
			tableindex = index
			-- PushDebugMessage(name)
			if index < 0 then
			  break
			else
				-- if logictype > 0 then
				-- 	table.insert(g_Agname_LogicTypeTable[logictype],titleindex)
				-- end
				local bflag,shorname = nil,nil
				--帮会特写
				if Player:GetData("GUILD") ~= -1 then
					if titleindex == 15 then
						local nPos_1,nPos_2,find_name = string.find(name,"**(.*)")
						if MyGuildPos - 1 == level then
							g_Agname_ServerData[i] = 1
							bflag = 2
						end
						shorname = Guild:GetMyGuildInfo("Name")..find_name
					end
					if titleindex == 21 then
						local nPos_1,nPos_2,find_name = string.find(name,"**(.*)")
						local nPoint = Guild:GetGuildContri();
						local nPoint_Level = -1
						if nPoint >= 250 then
							nPoint_Level = 1
						end
						if nPoint >= 750 then
							nPoint_Level = 2
						end
						if nPoint >= 1500 then
							nPoint_Level = 3
						end
						if nPoint >= 3000 then
							nPoint_Level = 4
						end
						if nPoint >= 7500 then
							nPoint_Level = 5
						end
						if nPoint >= 15000 then
							nPoint_Level = 6
						end
						if nPoint >= 30000 then
							nPoint_Level = 7
						end
						if nPoint >= 60000 then
							nPoint_Level = 8
						end
						if nPoint >= 125000 then
							nPoint_Level = 9
						end
						if nPoint >= 250000 then
							nPoint_Level = 10
						end
						if nPoint_Level == level then
							g_Agname_ServerData[i] = 1
							bflag = 2
						end
						shorname = Guild:GetMyGuildInfo("Name")..find_name
					end
				end
				--婚烟状态特写
				local nWife = Lua_GetMarryName()
				if nWife ~= "" then
					if titleindex == 2 then
						local nPos_1,nPos_2,find_name = string.find(name,"**(.*)")
						if string.find(nWife,find_name) ~= nil then
							g_Agname_ServerData[i] = 1;
							name = string.gsub(nWife,"#gB0E2FF#826","")
							name = string.gsub(name,"#827","")
						end
					end
				end
				--结拜特写
				if titleindex == 14 then
					local nJieBai = Lua_GetJieBaiName()
					if nJieBai ~= "" then
						g_Agname_ServerData[i] = 1
						name = nJieBai
					end
				end
				--掌柜特写
				if titleindex == 36 then
					local nShopTitle = Lua_GetSelfShopName()
					if nShopTitle ~= "" then
						g_Agname_ServerData[i] = 1
						name = nShopTitle
					end
				end
				--师傅特写
				if titleindex == 13 then
					local masterLvl = Player : GetData("MASTERLEVEL");
					if masterLvl == level then
						g_Agname_ServerData[i] = 1
					end
				end
				--弟子特写
				if titleindex == 38 then
					local szMaster = Lua_GetMasterName()
					if szMaster ~= nil and szMaster ~= "" then
						g_Agname_ServerData[i] = 1
						name = szMaster
					end
				end
				local bhave = g_Agname_ServerData[i]
				local bwear = 0
				if bnew == 1 then
					if string.find(curstr,name) ~= nil then
						bwear = 1
					end
				else
					if bhave == 1 and bflag == 2 then
						-- if curstr == strname then	--要求显示**,判断是否佩戴就会出问题，所以这再加一下
							-- bwear = 1
						-- end
						name = shorname
					end
					if bhave == 1 then
						if string.find(curstr,name) ~= nil then
							bwear = 1
						end
					end	
				end
				
					alltitlelist[valid] = {["name"]=name,["titleindex"]=titleindex,["tableindex"]=tableindex,["bhave"]=bhave,["property"]=property,
															["logictype"]=logictype,["level"]=level,["bnew"]=bnew,["bwear"]=bwear}					

				--Agname_InsertData(valid,name,titleindex,tableindex)
				valid = valid+1
			end
		end

		table.sort(alltitlelist,function(a,b)
			if a.bhave == b.bhave then

				if a.bwear == b.bwear then
					if a.logictype == b.logictype then
						if a.level == b.level then
							return a.tableindex < b.tableindex
						else
							return a.level < b.level
						end
					else
						return a.logictype < b.logictype
					end
				else
					return a.bwear > b.bwear
				end
			else	

				return a.bhave > b.bhave
			end
	
		end)
		
		for i, v in ipairs(alltitlelist) do 
			if string.find(v.name,"#") ~= nil then
				table.remove(alltitlelist,i)
			end
		end
		local havetypelist = {}
		for i, v in ipairs(alltitlelist) do 
			--属性
			-- Agname_InsertData(i,v)
			if v.bhave == 1  then	--处理旧表称号的问题
				g_Agname_LogicTypeTable[v.logictype] = v.level
				--属性
				if v.property and v.property ~= "" then
					-- calcAllEffectAgname
					Agname_Effect(v.tableindex)
				end
			end

		end
		AgnameFrame_Text:Hide()
		AgnameFrame_ListContent:Show();
		for i = g_Agname_PageIndex*16+1,g_Agname_PageIndex*16+16 do
			if alltitlelist[i] == nil then
				break
			end
			Agname_InsertData(i,alltitlelist[i])
		end
		calcAllEffectAgname()
end
function calcAllEffectAgname()
		if nAttrTable[0] > 0 then
			table.insert(nEffectTab,"#{equip_attr_maxhp} +"..nAttrTable[0].."\n")
		end
		if nAttrTable[1] > 0 then
			table.insert(nEffectTab,"#{equip_attr_maxhp} +"..nAttrTable[1].."%\n")
		end
		if nAttrTable[54] > 0 then
			table.insert(nEffectTab,"#{equip_attr_resistother_cold} +"..nAttrTable[54].."\n")
		end
		if nAttrTable[55] > 0 then
			table.insert(nEffectTab,"#{equip_attr_resistother_fire} +"..nAttrTable[55].."\n")
		end
		if nAttrTable[56] > 0 then
			table.insert(nEffectTab,"#{equip_attr_resistother_light} +"..nAttrTable[56].."\n")
		end
		if nAttrTable[57] > 0 then
			table.insert(nEffectTab,"#{equip_attr_resistother_poison} +"..nAttrTable[57].."\n")
		end
		if nAttrTable[6] > 0 then
			table.insert(nEffectTab,"#{equip_attr_attack_cold} +"..nAttrTable[6].."\n")
		end
		if nAttrTable[7] > 0 then
			table.insert(nEffectTab,"#{equip_attr_resist_cold} +"..nAttrTable[7].."\n")
		end
		if nAttrTable[9] > 0 then
			table.insert(nEffectTab,"#{equip_attr_attack_fire} +"..nAttrTable[9].."\n")
		end
		if nAttrTable[10] > 0 then
			table.insert(nEffectTab,"#{equip_attr_resist_fire} +"..nAttrTable[10].."\n")
		end
		if nAttrTable[12] > 0 then
			table.insert(nEffectTab,"#{equip_attr_attack_light} +"..nAttrTable[12].."\n")
		end
		if nAttrTable[13] > 0 then
			table.insert(nEffectTab,"#{equip_attr_resist_light} +"..nAttrTable[13].."\n")
		end
		if nAttrTable[15] > 0 then
			table.insert(nEffectTab,"#{equip_attr_attack_poison} +"..nAttrTable[15].."\n")
		end
		if nAttrTable[16] > 0 then
			table.insert(nEffectTab,"#{equip_attr_resist_poison} +"..nAttrTable[16].."\n")
		end
		if nAttrTable[19] > 0 then
			table.insert(nEffectTab,"#{equip_attr_attack_p} +"..nAttrTable[19].."\n")
		end
		if nAttrTable[20] > 0 then
			table.insert(nEffectTab,"#{equip_base_attack_p} +"..nAttrTable[19].."%\n")
		end
		if nAttrTable[26] > 0 then
			table.insert(nEffectTab,"#{equip_attr_attack_m} +"..nAttrTable[26].."\n")
		end
		if nAttrTable[27] > 0 then
			table.insert(nEffectTab,"#{equip_base_attack_m} +"..nAttrTable[19].."%\n")
		end
		if nAttrTable[44] > 0 then
			table.insert(nEffectTab,"#{equip_attr_con} +"..nAttrTable[44].."\n")
		end
		if nAttrTable[46] > 0 then
			table.insert(nEffectTab,"#{equip_attr_dex} +"..nAttrTable[46].."\n")
		end
		if nAttrTable[48] > 0 then
			table.insert(nEffectTab,"#{equip_attr_all} +"..nAttrTable[48].."\n")
		end
		local nEffectNum = table.getn(nEffectTab)
		if nEffectNum == 1 then
			effect = nEffectTab[1]
		elseif nEffectNum == 2 then
			effect = nEffectTab[1]..nEffectTab[2]
		elseif nEffectNum == 3 then
			effect = nEffectTab[1]..nEffectTab[2]..nEffectTab[3]
		elseif nEffectNum == 4 then
			effect = nEffectTab[1]..nEffectTab[2]..nEffectTab[3]..nEffectTab[4]
		elseif nEffectNum == 5 then
			effect = nEffectTab[1]..nEffectTab[2]..nEffectTab[3]..nEffectTab[4]..nEffectTab[5]
		elseif nEffectNum == 6 then
			effect = nEffectTab[1]..nEffectTab[2]..nEffectTab[3]..nEffectTab[4]..nEffectTab[5]..nEffectTab[6]
		elseif nEffectNum == 7 then
			effect = nEffectTab[1]..nEffectTab[2]..nEffectTab[3]..nEffectTab[4]..nEffectTab[5]..nEffectTab[6]..nEffectTab[7]
		elseif nEffectNum == 8 then
			effect = nEffectTab[1]..nEffectTab[2]..nEffectTab[3]..nEffectTab[4]..nEffectTab[5]..nEffectTab[6]..nEffectTab[7]..nEffectTab[8]
		end
		if effect ~= nil then
			effect = "#cFFCC00"..effect
		end
	return effect
end
function Agname_Effect(nIndex)
		local nTitleElements = GetEffectAgname(nIndex)
		if nTitleElements[2] > 0 then
			nAttrTable[nTitleElements[1]] = nAttrTable[nTitleElements[1]] + nTitleElements[2]
		end
		if nTitleElements[4] > 0 then
			nAttrTable[nTitleElements[3]] = nAttrTable[nTitleElements[3]] + nTitleElements[4]
		end
		if nTitleElements[6] > 0 then
			nAttrTable[nTitleElements[5]] = nAttrTable[nTitleElements[5]] + nTitleElements[6]
		end
		if nTitleElements[8] > 0 then
			nAttrTable[nTitleElements[7]] = nAttrTable[nTitleElements[7]] + nTitleElements[8]
		end
		if nTitleElements[10] > 0 then
			nAttrTable[nTitleElements[9]] = nAttrTable[nTitleElements[9]] + nTitleElements[10]
		end
		if nTitleElements[12] > 0 then
			nAttrTable[nTitleElements[11]] = nAttrTable[nTitleElements[11]] + nTitleElements[12]
		end
		if nTitleElements[14] > 0 then
			nAttrTable[nTitleElements[13]] = nAttrTable[nTitleElements[13]] + nTitleElements[14]
		end
end
function Agname_RestUpDate()
	-- local curid = GetCurTitleID()
	-- alltitlelist[curid].bwear = 1
	for i = g_Agname_PageIndex*16+1,g_Agname_PageIndex*16+16 do
		if alltitlelist[i] == nil then
			break
		end
		Agname_InsertData(i,alltitlelist[i])
	end	
end

function Agname_PageChange(idx)
	local nAgnameNum = GetAgnameNum();
	g_Agname_PageIndex = g_Agname_PageIndex + idx
	if g_Agname_PageIndex < 0 then
		g_Agname_PageIndex = 0
	elseif g_Agname_PageIndex >= nAgnameNum/16 then
		g_Agname_PageIndex = math.floor(nAgnameNum/16)
	end
	-- AGNAME_BUTTTONS 控件隐藏
	for i = 1,16 do
		AGNAME_BUTTTONS[i][1]:Hide()
	end
	-- PushDebugMessage(g_Agname_PageIndex*16+1)--//////////睡起来搞
	for i = g_Agname_PageIndex*16+1,g_Agname_PageIndex*16+16 do
		if alltitlelist[i] == nil then
			break
		end
		Agname_InsertData(i,alltitlelist[i])
	end
end

function Agname_InsertData(index,info)
	--index还原
	for i = 1,50 do
		if index < 17 then
			break
		end
		index = index - 16
	end
	local ItemBar = AGNAME_BUTTTONS[index][1]
	ItemBar:SetText(tostring(info.name))
	ItemBar:Show()
	ItemBar = AGNAME_BUTTTONS[index][2]
	if info.bwear == 1 then
		ItemBar:SetProperty("Image",g_Agname_Image[1]);
	elseif info.bhave == 1 then
		ItemBar:SetProperty("Image",g_Agname_Image[2]);
	else
		ItemBar:SetProperty("Image",g_Agname_Image[3]);
	end
	ItemBar = AGNAME_BUTTTONS[index][3]
	if info.property and info.property ~= "" then
		ItemBar:Show()
	else
		ItemBar:Hide()
	end	
	g_Agname_MapIndex[index] = {info.titleindex,info.tableindex};
end


function Agname_SetTitlePos()
	local nPosY = tonumber(AgnameFrame_PlayerTitle:GetProperty("AbsoluteHeight"))
	local nPosX = tonumber(AgnameFrame_PlayerTitle:GetProperty("AbsoluteWidth"))

	local FramH = tonumber(AgnameFrame_FenYeWindow1:GetProperty("AbsoluteHeight"))
	local FramW = tonumber(AgnameFrame_Prize1_Image:GetProperty("AbsoluteWidth"))	

	local fX = 0
	local fY = 0

	fX = math.floor(tonumber(FramW/2 - nPosX/2 ))	
	fY = math.floor(tonumber(fY+20 )	)

	AgnameFrame_PlayerTitle:SetProperty("AbsoluteXPosition", fX);	
	AgnameFrame_PlayerTitle:SetProperty("AbsoluteYPosition", fY);
end

function Agname_SetTitleanimatePos()
	fH = tonumber(AgnameFrame_TopTitleAnimate:GetProperty("AbsoluteHeight"))
	fW = tonumber(AgnameFrame_TopTitleAnimate:GetProperty("AbsoluteWidth"))	

		FramW = tonumber(AgnameFrame_PlayerTitle:GetProperty("AbsoluteWidth"))
	nPosX = tonumber(AgnameFrame_PlayerTitle:GetProperty("AbsoluteXPosition"))
	nPosY = tonumber(AgnameFrame_PlayerTitle:GetProperty("AbsoluteYPosition"))

	fX = math.floor(tonumber( nPosX + (FramW  * 0.5) - (fW * 0.5)))	
	fY = math.floor(tonumber(nPosY - fH/4 ))

	AgnameFrame_TopTitleAnimate:SetProperty("AbsoluteXPosition", fX);	
	AgnameFrame_TopTitleAnimate:SetProperty("AbsoluteYPosition", fY);
end

--获取称号色彩管理显示
function Lua_GetSystemColorText(nShowType,nTiTleName)
	--代码来源于D:\TLBB\Temp_Release_v3-65-3370_JD\Prj\GameCode\Client\Game\Interface\GMGameInterface_Script_PlayerMySelf.cpp
	local nClorIndex = 0
	if nShowType == 15 then
		nClorIndex = 101
	elseif nShowType == 21 then
		nClorIndex = 101
	elseif nShowType == 36 then
		nClorIndex = 103
	elseif nShowType == 13 then
		nClorIndex = 115
	end
	local nSystemColor = {
	[100] = "#cffff00",
	[101] = "#c00A8EB",
	[102] = "#ce8641b",
	[103] = "#c0000FF",
	[104] = "#c00FF00",
	[105] = "#gff0f5e",
	[106] = "#cffff00",
	[107] = "#gf0f0ff",
	[108] = "#c00A8EB",
	[109] = "#gff00ff",
	[110] = "#gfff70f",
	[111] = "#gf49f10",
	[112] = "#gff3e96",
	[113] = "#gFF00FF",
	[114] = "#gDC4C18",
	[115] = "#G",
	}
	if nSystemColor[nClorIndex] ~= nil then
		return nSystemColor[nClorIndex]..nTiTleName
	else
		return "#cffff00"..nTiTleName
	end
end


function Agname_ShowTitle(nIndex)
	local _,titleindex,logictype,level,bnew,name,desc,desc2,validtime,validtype,property = FeatchVaildTitle(g_Agname_MapIndex[nIndex][2]);
	local setvalidstr = function(str) Agname_Info2_Text2:SetText(str) end

	-- local bHave,bflag,strname,newdesc = Player:HaveTitle(g_Agname_MapIndex[nIndex][1])
	-- if bHave == 1 and bflag == 2 then
		-- name = strname
		-- desc = newdesc
	-- end
	Agname_TitlteInfoOnChoice(0)
	g_Agname_curselect = g_Agname_MapIndex[nIndex][2]
	
	
	local banimate = 0
	local animateindex = 0
	local boardindex = 0
	-- if bnew == 1 then
	banimate,animateindex,boardindex = GetTitleAnimateInfo(g_Agname_MapIndex[nIndex][2])
	-- end
	if string.find(name,"$N") ~= nil then
		name = string.gsub(name,"$N","**")
	end	
	--帮会特写
	if Player:GetData("GUILD") ~= -1 then
		if titleindex == 15 or titleindex == 21 then
			local nPos_1,nPos_2,find_name = string.find(name,"**(.*)")
			name = Guild:GetMyGuildInfo("Name")..find_name
		end
	end
	--师傅特写
	-- if titleindex == 13 then
		-- local masterLvl = Player : GetData("MASTERLEVEL");
		-- if masterLvl == level then
			-- g_Agname_ServerData[i] = 1
		-- end
	-- end	
	--婚烟状态特写
	local nWife = Lua_GetMarryName()
	if nWife ~= "" then
		if titleindex == 2 then
			local nPos_1,nPos_2,find_name = string.find(name,"**(.*)")
			if string.find(nWife,find_name) ~= nil then
				name = nWife
			end
		end
	end
	--结拜特写
	if titleindex == 14 then
		local nJieBai = Lua_GetJieBaiName()
		if nJieBai ~= "" then
			name = nJieBai
		end
	end
	--掌柜特写
	if titleindex == 36 then
		local nShopTitle = Lua_GetSelfShopName()
		if nShopTitle ~= "" then
			name = nShopTitle
		end
	end
	--弟子特写
	if titleindex == 38 then
		local szMaster = Lua_GetMasterName()
		if szMaster ~= nil and szMaster ~= "" then
			name = szMaster
		end
	end
	if(name) then
		g_Agname_Curname = name
		local StrColorName = Lua_GetSystemColorText(titleindex,name);		
		AgnameFrame_PlayerTitle:SetText(StrColorName)
		AgnameFrame_PlayerTitle:Show()
		AgnameFrame_LeftTitleAnimate:Hide()
		AgnameFrame_RightTitleAnimate:Hide()
		AgnameFrame_TopTitleAnimate:Hide()
		Agname_SetTitlePos()

		if banimate == 1 then
			--动画的情况（动画替代了称号字）
			AgnameFrame_TopTitleAnimate:Show()
			local SizeX,SizeY,szName = Player:EnumFlashType(animateindex);

			AgnameFrame_TopTitleAnimate:SetProperty("AbsoluteSize", "w:"..SizeX.." ".."h:"..SizeY)	
			Agname_SetTitleanimatePos()
			AgnameFrame_TopTitleAnimate:SetProperty( "Animate", szName );			
			AgnameFrame_PlayerTitle:Hide()
		else
			-- PushDebugMessage("boardindex "..boardindex)
			if boardindex and boardindex > 0 then
				
				

				local Leftname,Rightname,LeftSizeX,LeftSizeY,RightSizeX,RightSizeY,
				LeftOffsetX,LeftOffsetY,RightOffsetX,RightOffsetY = EnumBoardType(boardindex);
				if Leftname then
					AgnameFrame_LeftTitleAnimate:SetProperty("AbsoluteSize", "w:"..LeftSizeX.." ".."h:"..LeftSizeY)
					AgnameFrame_RightTitleAnimate:SetProperty("AbsoluteSize", "w:"..RightSizeX.." ".."h:"..RightSizeY)
					AgnameFrame_LeftTitleAnimate:SetProperty("Animate", Leftname)
					AgnameFrame_RightTitleAnimate:SetProperty("Animate", Rightname)
					if(string.len(Leftname) == 0) then
						AgnameFrame_LeftTitleAnimate:Play(false)
						AgnameFrame_LeftTitleAnimate:Hide()
					else
						AgnameFrame_LeftTitleAnimate:Play(true)
						AgnameFrame_LeftTitleAnimate:Show()
					end
					if Rightname ~= nil and tostring(Rightname) ~= "nil" then
						-- if(string.len(Rightname) > 3 ) then
						-- else
							AgnameFrame_RightTitleAnimate:Play(true)
							AgnameFrame_RightTitleAnimate:Show()
						else	
							AgnameFrame_RightTitleAnimate:Play(false)
							AgnameFrame_RightTitleAnimate:Hide()
						-- end
					end

					nPosX = tonumber(AgnameFrame_PlayerTitle:GetProperty("AbsoluteXPosition"))
					nPosY = tonumber(AgnameFrame_PlayerTitle:GetProperty("AbsoluteYPosition"))
					local nHeight = tonumber(AgnameFrame_PlayerTitle:GetProperty("AbsoluteHeight"))
					local nWidth = tonumber(AgnameFrame_PlayerTitle:GetProperty("AbsoluteWidth"))
					
					--Left
					fX = 0
					fY = 0
					fX = math.floor(tonumber(fX + nPosX - LeftOffsetX ))
					fY = math.floor(tonumber(fY + nPosY + nHeight - LeftOffsetY))
					AgnameFrame_LeftTitleAnimate:SetProperty("AbsoluteXPosition", fX);	
					AgnameFrame_LeftTitleAnimate:SetProperty("AbsoluteYPosition", fY);

					--Right
					fX = 0
					fY = 0
					fX = math.floor(tonumber(fX + nPosX + nWidth - RightOffsetX ))
					fY = math.floor(tonumber(fY + nPosY + nHeight - RightOffsetY))
					AgnameFrame_RightTitleAnimate:SetProperty("AbsoluteXPosition", fX);	
					AgnameFrame_RightTitleAnimate:SetProperty("AbsoluteYPosition", fY);
					
					AgnameFrame_LeftTitleAnimate:Show()
					AgnameFrame_RightTitleAnimate:Show()
				end



			end
		end

		Agname_Info2_Text3:SetText(desc)
		Agname_Info2_Text7_1:SetText(desc2)
		-- if(bnew == 0) then
			if validtime < 0 then
				setvalidstr("#{XCHXT_180428_72}")
			else
				-- if bHave == 1 then
					-- local disableDayTime = Player:GetTitleDisableTimeByTitleID(g_Agname_MapIndex[nIndex][1])
					-- if disableDayTime == 0 then
						-- disableDayTime =  1
					-- end
					-- setvalidstr(string.format("剩余%s天",math.floor( disableDayTime ) ))
				-- else
					local nTemp= math.floor( validtime/24 )
					if nTemp <= 0 then
						nTemp = 1
					end
					setvalidstr( string.format("%s天",nTemp))
				-- end

			end
			-- if(property and string.len(property) > 0 ) then
				-- Agname_Info2_Text6:SetText("#{XCHXT_180428_37}")
				-- Agname_Info2_Text5_1:SetText(property)
			-- else
				-- Agname_Info2_Text6:SetText("#{XCHXT_180428_37}")
				-- Agname_Info2_Text5_1:SetText("#{XCHXT_180322_25}")
			-- end
		-- else

			-- if validtype > 0 then
				-- if validtype == 1 then
					-- if bHave == 1 then
						-- local disableDayTime = Player:GetTitleDisableTimeByTitleID(g_Agname_MapIndex[nIndex][1])
						-- if disableDayTime == 0 then
							-- disableDayTime =  1
						-- end
						-- setvalidstr(ScriptGlobal_Format("#{XCHXT_180428_73}",math.floor( disableDayTime ) ))
					-- else

						-- local nTemp= math.floor( validtime/24 )
						-- if nTemp <= 0 then
							-- nTemp = 1
						-- end
						-- setvalidstr( ScriptGlobal_Format("#{XCHXT_180428_74}",nTemp))
					-- end

				-- elseif validtype == 2 then
					-- if bHave == 1 then
						-- local DifDay = DataPool:GetDifDayWithServerTime(validtime,2)
						-- if DifDay <= 0 then
							-- DifDay = 1
						-- end
						-- setvalidstr(ScriptGlobal_Format("#{XCHXT_180428_73}", DifDay))
					-- else
						-- local year = math.floor(validtime/10000)
						-- local month = math.floor(math.mod(validtime,10000)/100)
						-- local day = math.mod(validtime,100)
						-- local str = ScriptGlobal_Format("#{XCHXT_180428_34}",year,month,day)
						-- setvalidstr(str)
					-- end
				-- elseif validtype == 3 then
					-- if bHave == 1 then
						-- local nTrueTime = Player:GetTitleDisableTimeByTitleID(g_Agname_MapIndex[nIndex][1])
						-- if nTrueTime == 0 then
							-- nTrueTime = 1
						-- end
						-- setvalidstr( ScriptGlobal_Format("#{XCHXT_180428_73}", math.floor( nTrueTime )))

					-- else
						-- local str = ScriptGlobal_Format("#{XCHXT_180428_35}",g_Agname_Time[validtime])
						-- setvalidstr(str)
					-- end
				-- elseif validtype == 4 then

					-- if bHave == 1 then
						-- local nTrueTime = Player:GetTitleDisableTimeByTitleID(g_Agname_MapIndex[nIndex][1])
						-- if nTrueTime == 0 then
							-- nTrueTime = 1
						-- end
						-- setvalidstr( ScriptGlobal_Format("#{XCHXT_180428_73}", math.floor( nTrueTime )))
					-- else
						-- local str = ScriptGlobal_Format("#{XCHXT_180428_82}",g_Agname_Time[validtime])
						-- setvalidstr(str)
					-- end

				-- end
			-- else
				-- setvalidstr("#{XCHXT_180428_72}")
			-- end

			if(property and string.len(property) > 0 ) then
				Agname_Info2_Text6:SetText("#{XCHXT_180428_37}")
				Agname_Info2_Text5_1:SetText("#cFFCC00"..property)
			else
				Agname_Info2_Text6:SetText("#{XCHXT_180428_37}")
				Agname_Info2_Text5_1:SetText("#{XCHXT_180322_25}")
			end
			
		end
	end

function Agname_UpdateFrame()
	--清空
	--总长度36-
	-- local nTim = "#cffff00#-88".."      科举探花      ".."#-89"
	Agname_LeftLoad()
	Agname_TitlteInfoOnChoice(0)
	
	Agname_Info2_Text2:SetText("")
	Agname_Info2_Text3:SetText("")
	Agname_Info2_Text5_1:SetText("")
	AgnameFrame_PlayerTitle:SetText("")
	Agname_Info2_Text7_1:SetText("")
	AgnameFrame_LeftTitleAnimate:Hide()
	AgnameFrame_RightTitleAnimate:Hide()
	Agname_PlayerTitle()
end

function Agname_PlayerTitle()
	local curid = GetCurTitleID()
	-- PushDebug(curid)
	local _,titleindex,logictype,level,bnew,name,desc,desc2,validtime,validtype,property = FeatchVaildTitle(curid);
	local setvalidstr = function(str) Agname_Info2_Text2:SetText(str) end

	-- local bHave,bflag,strname,newdesc = Player:HaveTitle(g_Agname_MapIndex[nIndex][1])
	-- if bHave == 1 and bflag == 2 then
		-- name = strname
		-- desc = newdesc
	-- end
	Agname_TitlteInfoOnChoice(0)
	-- g_Agname_curselect = g_Agname_MapIndex[nIndex][2]
	
	
	local banimate = 0
	local animateindex = 0
	local boardindex = 0
	-- if bnew == 1 then
	banimate,animateindex,boardindex = GetTitleAnimateInfo(curid)
	-- end
	if string.find(name,"$N") ~= nil then
		name = string.gsub(name,"$N","**")
	end	
	--帮会特写
	if Player:GetData("GUILD") ~= -1 then
		if titleindex == 15 or titleindex == 21 then
			local nPos_1,nPos_2,find_name = string.find(name,"**(.*)")
			name = Guild:GetMyGuildInfo("Name")..find_name
		end
	end
	--师傅特写
	-- if titleindex == 13 then
		-- local masterLvl = Player : GetData("MASTERLEVEL");
		-- if masterLvl == level then
			-- g_Agname_ServerData[i] = 1
		-- end
	-- end	
	--婚烟状态特写
	local nWife = Lua_GetMarryName()
	if nWife ~= "" then
		if titleindex == 2 then
			local nPos_1,nPos_2,find_name = string.find(name,"**(.*)")
			if string.find(nWife,find_name) ~= nil then
				name = nWife
			end
		end
	end
	--结拜特写
	if titleindex == 14 then
		local nJieBai = Lua_GetJieBaiName()
		if nJieBai ~= "" then
			name = nJieBai
		end
	end
	--掌柜特写
	if titleindex == 36 then
		local nShopTitle = Lua_GetSelfShopName()
		if nShopTitle ~= "" then
			name = nShopTitle
		end
	end
	--弟子特写
	if titleindex == 38 then
		local szMaster = Lua_GetMasterName()
		if szMaster ~= nil and szMaster ~= "" then
			name = szMaster
		end
	end
	if(name) then
		g_Agname_Curname = name
		local StrColorName = Lua_GetSystemColorText(titleindex,name);		
		AgnameFrame_PlayerTitle:SetText(StrColorName)
		AgnameFrame_PlayerTitle:Show()
		AgnameFrame_LeftTitleAnimate:Hide()
		AgnameFrame_RightTitleAnimate:Hide()
		AgnameFrame_TopTitleAnimate:Hide()
		Agname_SetTitlePos()

		if banimate == 1 then
			--动画的情况（动画替代了称号字）
			AgnameFrame_TopTitleAnimate:Show()
			local SizeX,SizeY,szName = Player:EnumFlashType(animateindex);

			AgnameFrame_TopTitleAnimate:SetProperty("AbsoluteSize", "w:"..SizeX.." ".."h:"..SizeY)	
			Agname_SetTitleanimatePos()
			AgnameFrame_TopTitleAnimate:SetProperty( "Animate", szName );			
			AgnameFrame_PlayerTitle:Hide()
		else
			-- PushDebugMessage("boardindex "..boardindex)
			if boardindex and boardindex > 0 then
				
				

				local Leftname,Rightname,LeftSizeX,LeftSizeY,RightSizeX,RightSizeY,
				LeftOffsetX,LeftOffsetY,RightOffsetX,RightOffsetY = EnumBoardType(boardindex);
				if Leftname then
					AgnameFrame_LeftTitleAnimate:SetProperty("AbsoluteSize", "w:"..LeftSizeX.." ".."h:"..LeftSizeY)
					AgnameFrame_RightTitleAnimate:SetProperty("AbsoluteSize", "w:"..RightSizeX.." ".."h:"..RightSizeY)
					AgnameFrame_LeftTitleAnimate:SetProperty("Animate", Leftname)
					AgnameFrame_RightTitleAnimate:SetProperty("Animate", Rightname)
					if(string.len(Leftname) == 0) then
						AgnameFrame_LeftTitleAnimate:Play(false)
						AgnameFrame_LeftTitleAnimate:Hide()
					else
						AgnameFrame_LeftTitleAnimate:Play(true)
						AgnameFrame_LeftTitleAnimate:Show()
					end
					if Rightname ~= nil then
						if(string.len(Rightname) == 0) then
							AgnameFrame_RightTitleAnimate:Play(false)
							AgnameFrame_RightTitleAnimate:Hide()
						else
							AgnameFrame_RightTitleAnimate:Play(true)
							AgnameFrame_RightTitleAnimate:Show()
						end
					end

					nPosX = tonumber(AgnameFrame_PlayerTitle:GetProperty("AbsoluteXPosition"))
					nPosY = tonumber(AgnameFrame_PlayerTitle:GetProperty("AbsoluteYPosition"))
					local nHeight = tonumber(AgnameFrame_PlayerTitle:GetProperty("AbsoluteHeight"))
					local nWidth = tonumber(AgnameFrame_PlayerTitle:GetProperty("AbsoluteWidth"))
					
					--Left
					fX = 0
					fY = 0
					fX = math.floor(tonumber(fX + nPosX - LeftOffsetX ))
					fY = math.floor(tonumber(fY + nPosY + nHeight - LeftOffsetY))
					AgnameFrame_LeftTitleAnimate:SetProperty("AbsoluteXPosition", fX);	
					AgnameFrame_LeftTitleAnimate:SetProperty("AbsoluteYPosition", fY);

					--Right
					fX = 0
					fY = 0
					fX = math.floor(tonumber(fX + nPosX + nWidth - RightOffsetX ))
					fY = math.floor(tonumber(fY + nPosY + nHeight - RightOffsetY))
					AgnameFrame_RightTitleAnimate:SetProperty("AbsoluteXPosition", fX);	
					AgnameFrame_RightTitleAnimate:SetProperty("AbsoluteYPosition", fY);
					
					AgnameFrame_LeftTitleAnimate:Show()
					AgnameFrame_RightTitleAnimate:Show()
				end



			end
		end

		Agname_Info2_Text3:SetText(desc)
		Agname_Info2_Text7_1:SetText(desc2)
		-- if(bnew == 0) then
			if validtime < 0 then
				setvalidstr("#{XCHXT_180428_72}")
			else
				-- if bHave == 1 then
					-- local disableDayTime = Player:GetTitleDisableTimeByTitleID(g_Agname_MapIndex[nIndex][1])
					-- if disableDayTime == 0 then
						-- disableDayTime =  1
					-- end
					-- setvalidstr(string.format("剩余%s天",math.floor( disableDayTime ) ))
				-- else
					local nTemp= math.floor( validtime/24 )
					if nTemp <= 0 then
						nTemp = 1
					end
					setvalidstr( string.format("%s天",nTemp))
				-- end

			end
			-- if(property and string.len(property) > 0 ) then
				-- Agname_Info2_Text6:SetText("#{XCHXT_180428_37}")
				-- Agname_Info2_Text5_1:SetText(property)
			-- else
				-- Agname_Info2_Text6:SetText("#{XCHXT_180428_37}")
				-- Agname_Info2_Text5_1:SetText("#{XCHXT_180322_25}")
			-- end
		-- else

			-- if validtype > 0 then
				-- if validtype == 1 then
					-- if bHave == 1 then
						-- local disableDayTime = Player:GetTitleDisableTimeByTitleID(g_Agname_MapIndex[nIndex][1])
						-- if disableDayTime == 0 then
							-- disableDayTime =  1
						-- end
						-- setvalidstr(ScriptGlobal_Format("#{XCHXT_180428_73}",math.floor( disableDayTime ) ))
					-- else

						-- local nTemp= math.floor( validtime/24 )
						-- if nTemp <= 0 then
							-- nTemp = 1
						-- end
						-- setvalidstr( ScriptGlobal_Format("#{XCHXT_180428_74}",nTemp))
					-- end

				-- elseif validtype == 2 then
					-- if bHave == 1 then
						-- local DifDay = DataPool:GetDifDayWithServerTime(validtime,2)
						-- if DifDay <= 0 then
							-- DifDay = 1
						-- end
						-- setvalidstr(ScriptGlobal_Format("#{XCHXT_180428_73}", DifDay))
					-- else
						-- local year = math.floor(validtime/10000)
						-- local month = math.floor(math.mod(validtime,10000)/100)
						-- local day = math.mod(validtime,100)
						-- local str = ScriptGlobal_Format("#{XCHXT_180428_34}",year,month,day)
						-- setvalidstr(str)
					-- end
				-- elseif validtype == 3 then
					-- if bHave == 1 then
						-- local nTrueTime = Player:GetTitleDisableTimeByTitleID(g_Agname_MapIndex[nIndex][1])
						-- if nTrueTime == 0 then
							-- nTrueTime = 1
						-- end
						-- setvalidstr( ScriptGlobal_Format("#{XCHXT_180428_73}", math.floor( nTrueTime )))

					-- else
						-- local str = ScriptGlobal_Format("#{XCHXT_180428_35}",g_Agname_Time[validtime])
						-- setvalidstr(str)
					-- end
				-- elseif validtype == 4 then

					-- if bHave == 1 then
						-- local nTrueTime = Player:GetTitleDisableTimeByTitleID(g_Agname_MapIndex[nIndex][1])
						-- if nTrueTime == 0 then
							-- nTrueTime = 1
						-- end
						-- setvalidstr( ScriptGlobal_Format("#{XCHXT_180428_73}", math.floor( nTrueTime )))
					-- else
						-- local str = ScriptGlobal_Format("#{XCHXT_180428_82}",g_Agname_Time[validtime])
						-- setvalidstr(str)
					-- end

				-- end
			-- else
				-- setvalidstr("#{XCHXT_180428_72}")
			-- end

			if(property and string.len(property) > 0 ) then
				Agname_Info2_Text6:SetText("#{XCHXT_180428_37}")
				Agname_Info2_Text5_1:SetText("#cFFCC00"..property)
			else
				Agname_Info2_Text6:SetText("#{XCHXT_180428_37}")
				Agname_Info2_Text5_1:SetText("#{XCHXT_180322_25}")
			end
	end			
end
function Agname_MouseLeave(idx)
	AgnameFrame_CoinAItem_Image_3BK:Hide()
end

function Agname_MouseEnter(idx)
	AgnameFrame_CoinAItem_Image_3BK:Show()
end

function Agname_TitlteInfoOnChoice(switch)

	if switch == 0 then
			
		Agname_AllAgname:Show()
		Agname_SelectAgname:Hide()
		Agname_Info1_Title:Hide()
		Agname_Xinxi:SetCheck(1)
	elseif switch == 1 then
		Agname_AllAgname:Hide()
		Agname_SelectAgname:Show()
		Agname_Info1_Title:SetText("")
		Agname_ShowAllAttr()
		Agname_Info1_Title:Show()
		Agname_Shuxing:SetCheck(1)
	end



end

function Agname_ShowAllAttr()
	local str = effect
	if str and str ~= "" and string.len(str) >= 8 then
		Agname_Info1_Title:SetText("#{XCHXT_180428_76}")
		Agname_Info1_MiniTitle:SetText(str)
	else
		Agname_Info1_Title:SetText("#{XCHXT_180428_76}")
		Agname_Info1_MiniTitle:SetText("#{XCHXT_180124_11}")
	end
	

end

--显示隐藏称号
function Agname_SHOW_HIDE_Clicked()
	local nAgnameNum = Player:GetAgnameNum()
	
	if nAgnameNum <= 0  then
	    PushDebugMessage("#{XCHXT_180124_15}")
	    return 
	end


	local str = GetCurTitleID()

	if str and string.len(str) > 0 then
		local Show_Hide = Lua_Get_IsShow_Hide_Flag()
		if Show_Hide == 1 then
			Lua_Set_IsShow_Hide_Flag(0)
		else
			Lua_Set_IsShow_Hide_Flag(1)
		end
	else
		PushDebugMessage("#{XCHXT_180428_77}")
	end
end



function Agname_SHOW_HIDE_Format()
	-- local str = GetCurTitleID()
	-- if str and string.len(str) > 0 then
		-- local Show_Hide = Lua_Get_IsShow_Hide_Flag()
		-- if Show_Hide == 1 then
			-- Agname_Button_Show:SetText("#{XCHXT_180124_12}") --显示称号
		-- else
			Agname_Button_Show:SetText("#{XCHXT_180124_17}") --隐藏称号
		-- end
	-- else
		--PushDebugMessage("#{XCHXT_180124_15}")
	-- end
end

function Agname_ListContent_CoinAItem_Click(index)

	Agname_TitlteInfoOnChoice(0)
	Agname_ShowTitle(index)
	-- g_Agname_curselect = index
end



function Agname_ChangeBtn_Clicked()
	
	-- local nAgnameNum = Player:GetAgnameNum();
	-- if nAgnameNum <= 0 then
		-- PushDebugMessage("#{XCHXT_180124_15}")
		-- return 
	-- end
	
	if g_Agname_curselect <= 0 then
		PushDebugMessage("#{XCHXT_180428_60}")
		return 
	end

	--老表数据没法处理，只能用名字来比较了
	-- local str = Player:GetCurTitle()
	-- if str and string.len(str)>0 and str == g_Agname_Curname then
		-- PushDebugMessage("#{XCHXT_180428_63}")
		-- return 
	-- end





	-- local nIndex = Player:GetOwnerIndexByTitleID(g_Agname_MapIndex[g_Agname_curselect][1])
	-- if nIndex < 0 then
		-- PushDebugMessage("#{XCHXT_180428_61}")
		-- return 

	-- end
	-- Player:AskChangeCurrentAgname(nIndex);

	--老表加提示太难了，直接在客户端弹提示吧
	-- if(string.len(g_Agname_Curname) > 0 ) then
		-- local str = ScriptGlobal_Format("#{XCHXT_180428_64}",g_Agname_Curname)
		-- PushDebugMessage(str)
	-- end
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "AgnameChange" );
		Set_XSCRIPT_ScriptID(992004);
		Set_XSCRIPT_Parameter(0,g_Agname_curselect);
		Set_XSCRIPT_Parameter(1,g_Agname_PageIndex);
		Set_XSCRIPT_ParamCount(2);	
	Send_XSCRIPT()	
	this:Hide()
end

function Agname_HideTitle_Clicked()

	Agname_Currently:SetText( "当前称号:");
	Player:SetNullAgname();
end


--================================================
-- 恢复界面的默认相对位置
--================================================
function Agname_Frame_On_ResetPos()
	AgnameFrame:SetProperty("UnifiedPosition", g_Agname_Frame_UnifiedPosition);
end
