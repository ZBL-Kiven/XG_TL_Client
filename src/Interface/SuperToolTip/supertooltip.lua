local CU_MONEY			= 1	-- 钱
local CU_GOODBAD		= 2	-- 善恶值
local CU_MORALPOINT	= 3	-- 师德点
local CU_TICKET			= 4 -- 官票钱
local CU_YUANBAO		= 5	-- 元宝
local CU_ZENGDIAN		= 6 -- 赠点
local CU_MENPAI_POINT	= 7 -- 师门贡献度
local CU_MONEYJZ		= 8 -- 交子
local nGemNum = 0 --点缀数量

local g_pos1;
local g_pos2;
local g_PurpleColor = "#c9107e1";
local g_BlueColor   = "#c00ccff";
local g_YellowColor = "#cfeff95";
local g_GreenColor	= "#c5bc257";
local g_Stars;		
local g_IsNoStringTip = {"武魂","时装"}
g_nUnlockingTimeNeeded = 259200;
local WuHunMagic_Tips = {"#{WH_090817_04}" , "#{WH_xml_XX(56)}","#{WH_xml_XX(57)}","#{WH_xml_XX(58)}","#{WH_xml_XX(59)}"}
xSrtong = {
[0] = { Tooltip = "幻饰武器" },
[1] = { Tooltip = "扇类" },
[2] = { Tooltip = "单短类" },
[3] = { Tooltip = "双短类" },
[4] = { Tooltip = "刀斧类" },
[5] = { Tooltip = "枪棒类" },
[6] = { Tooltip = "环类" },
[7] = { Tooltip = "弩类" },
[8] = { Tooltip = "长杖类" },
[9] = { Tooltip = "龙纹" },
[10] = { Tooltip = "暗器" },
[11] = { Tooltip = "戒指" },
[12] = { Tooltip = "护符" },
[13] = { Tooltip = "护腕" },
[14] = { Tooltip = "项链" },
[15] = { Tooltip = "武魂" },
[16] = { Tooltip = "护肩" },
[17] = { Tooltip = "鞋" },
[18] = { Tooltip = "帽子" },
[19] = { Tooltip = "手套" },
[20] = { Tooltip = "衣服" },
[21] = { Tooltip = "腰带" },
[22] = { Tooltip = "豪侠印" },
}
local g_EffectDic = {
	"内功攻击",	--内功攻击
	"外功攻击",	--外功攻击
	"冰属性",	--冰属性
	"火属性",	--火属性
	"玄属性",	--玄属性
	"毒属性",	--毒属性
}
local g_strAttrDic = {
[6]="#{equip_attr_attack_cold}",
[9]="#{equip_attr_attack_fire}",
[12]="#{equip_attr_attack_light}",
[15]="#{equip_attr_attack_poison}",
[19]="#{equip_attr_attack_p}",
[26]="#{equip_attr_attack_m}",
}
local g_NewAuthorInfo = ""

local Gem_Cloth_Icon = {
	[59000001] = "Charm8_8",
	[59000002] = "Charm7_12",
	[59000003] = "Charm8_12",
	[59000004] = "Charm8_4",
	[59000005] = "Charm7_16",
	[59000006] = "TaskTools16_7",
	[59000007] = "TaskTools16_16",
	[59000008] = "Charm10_4",
	[59000009] = "Charm10_8",
	[59000010] = "Charm10_14",
	[59000011] = "Charm11_2",
	[59000012] = "Charm8_8",
	[59000013] = "Charm7_12",
	[59000014] = "Charm8_12",
	[59000015] = "Charm8_4",
	[59000016] = "Charm7_16",
	[59000017] = "TaskTools16_7",
	[59000018] = "TaskTools16_16",
	[59000019] = "Charm10_4",
	[59000020] = "Charm10_8",
	[59000021] = "Charm10_14",
	[59000022] = "Charm11_2",
	[59000023] = "Charm8_8",
	[59000024] = "Charm7_12",
	[59000025] = "Charm8_12",
	[59000026] = "Charm8_4",
	[59000027] = "Charm7_16",
	[59000028] = "TaskTools16_7",
	[59000029] = "TaskTools16_16",
	[59000030] = "Charm10_4",
	[59000031] = "Charm10_8",
	[59000032] = "Charm10_14",
	[59000033] = "Charm11_2",
}
function g_GetUnlockingStr ( nUnlockElapsedTime )
	local nLeftTime = g_nUnlockingTimeNeeded - nUnlockElapsedTime;
	local strLeftTime = "";
		
	if( nLeftTime <= 0 ) then
		strLeftTime = "解锁成功！请重新登录或切换场景正式解锁。";
	else
		nLeftTime = math.ceil( nLeftTime/3600 );
		if( nLeftTime >= 24 ) then
			strLeftTime = ""..math.floor(nLeftTime/24).." 天";
			nLeftTime = math.mod(nLeftTime,24);
		end
		if( nLeftTime > 0 ) then 
			strLeftTime = strLeftTime.." "..nLeftTime.." 小时";					
		end
		
		strLeftTime = strLeftTime.."后正式解锁";
	end
	
	return strLeftTime;
end

function SuperTooltip_PreLoad()
	this:RegisterEvent("SHOW_SUPERTOOLTIP");
	this:RegisterEvent("UPDATE_SUPERTOOLTIP");
	this:RegisterEvent("UI_COMMAND");
end

function SuperTooltip_OnLoad()
	SuperTooltip_StaticPart_Money:SetClippedByParent(0);
	SuperTooltip_StaticPart_Money_JiaoZi:SetClippedByParent(0);
	g_Stars={
				SuperTooltip_StaticPart_Star1,
				SuperTooltip_StaticPart_Star2,
				SuperTooltip_StaticPart_Star3,
				SuperTooltip_StaticPart_Star4,
				SuperTooltip_StaticPart_Star5,
				SuperTooltip_StaticPart_Star6,
				SuperTooltip_StaticPart_Star7,
				SuperTooltip_StaticPart_Star8,
				SuperTooltip_StaticPart_Star9,
		};
	for i=1,9 do
		g_Stars[i]:Hide();
	end;
	--AxTrace(0, 2, "LoadSuperTooltips");
end										

function SuperTooltip_OnEvent(event)

--	SuperTooltip_StaticPart_Money:Hide();
	if(event == "SHOW_SUPERTOOLTIP") then
		if( arg0 == "1" and SuperTooltips:IsPresent()) then
			
			SuperTooltips:SendAskItemInfoMsg();
			if(SuperTooltip_Update()==1) then
				g_pos1, g_pos2 = _SuperTooltip_:PositionSelf(arg2, arg3, arg4, arg5);	
				this:Show();
			end;
			return;
		else
			this:Hide();
			return;

		end
	end
	if(event == "UI_COMMAND" and tonumber(arg0) == 11605923) then
		g_NewAuthorInfo = arg1
		SuperTooltip_Update();		
		_SuperTooltip_:PositionSelf(0, 0, g_pos1, g_pos2);
	end	
	if(event == "UPDATE_SUPERTOOLTIP") or (event == "UI_COMMAND" and tonumber(arg0) == 202107295  )then
		if(this:IsVisible() and SuperTooltips:IsPresent()) then
			SuperTooltip_Update();
			_SuperTooltip_:PositionSelf(0, 0, g_pos1, g_pos2);
			return;
		end;
	end
	
end

function SuperTooltip_Update()
		-- 先清空以前显示的文字
	SuperTooltip_ClearText();
	local typeDesc = SuperTooltips:GetTypeDesc();
	if typeDesc ~= nil then
		if string.find(typeDesc,"NewExterior") ~= nil then
			return 0
		end
	end		
	local typeDesc = SuperTooltips:GetTypeDesc();
	local ActionID = SuperTooltips:GetActionID();
	local nGemHoleCounts = SuperTooltips:GetGemHoleCounts();
	local nMoney1, szMoneyDesc1 = SuperTooltips:GetMoney1();
	local nMoney2, szMoneyDesc2 = SuperTooltips:GetMoney2();
	local szPropertys = SuperTooltips:GetPropertys();
	local szAuthor = SuperTooltips:GetAuthorInfo();
	local szExplain = SuperTooltips:GetExplain();
	local unLockingElapsedTime	=SuperTooltips:GetPUnlockElapsedTime();
	local IsProtectd	=SuperTooltips:GetDesc5();
	local nYuanbaotrade = SuperTooltips:GetYuanbaoTradeFlag();
	local nXinfaId = LifeAbility:GetLifeAbility_Number(ActionID);
	----------------------------------------------------------------------
	--显示静态头
	local toDisplay = "";
	
	if(SuperTooltips:GetTitle()~="" and SuperTooltips:GetIconName()~="")then
		toDisplay = toDisplay .."SuperTooltip_PageHeader";
	end
	
	--剩余解锁时间
	if( IsProtectd == "1" and unLockingElapsedTime ~= 0) then
		toDisplay = toDisplay .. ";SuperTooltip_UnlockingTimePart";
	end
		
		
	--加上类型描述
	if( typeDesc ~= nil) then 
		local XL_Pos1,XL_Pos2 = string.find(typeDesc, "XL_BOOK")
		local XL_Pos3,XL_Pos4 = string.find(typeDesc, "XL_MIJI")
		local nKfsSkill_1,nKfsSkill_2 = string.find(typeDesc,"XYJ_KFS_SKILL")
		local nKFSwg_1,nKFSwg_2 = string.find(typeDesc,"KFSWG_")
		local TALENT,TALENT2 = string.find(typeDesc,"TALENT")
		if  TALENT == nil and TALENT2 == nil and nKfsSkill_1 == nil and nKfsSkill_2 == nil and XL_Pos1 == nil and XL_Pos2 == nil and XL_Pos3 == nil and XL_Pos4 == nil and nKFSwg_1 == nil and nKFSwg_2 == nil then
			toDisplay = toDisplay .. ";SuperTooltip_ShortDesc";
		end
	end		
	--元宝交易
	if (nYuanbaotrade == 1) then
		toDisplay = toDisplay .. ";SuperTooltip_StaticPart_Yuanbaojiaoyi";
		SuperTooltip_StaticPart_Yuanbaojiaoyi:SetText("#c00ff00元宝交易");
	end
	--格子tip
	if IsWindowShow("NewExterior_DressBox") and typeDesc == "#cffcc99时装"  then
		szPropertys = string.gsub(szPropertys, "装备时绑定", "已绑定");
		if g_PlayerString ~= "" then
			szAuthor = g_PlayerString
			if szAuthor ~= nil and szAuthor ~= "" then
				local nGemPos_1,nGemPos_2,nGemID_1,_,nGemID_2,_,nGemID_3 = string.find(szAuthor,"&DZ("..string.rep("%d",8)..")".."(%w)".."("..string.rep("%d",8)..")".."(%w)".."("..string.rep("%d",8)..")")
				if nGemPos_1 ~=  nil and nGemPos_2 ~= nil then
					if tonumber(nGemID_1) > 0 then
						nGemHoleCounts = nGemHoleCounts + 1
					end
					if tonumber(nGemID_2) > 0 then
						nGemHoleCounts = nGemHoleCounts + 1
					end
					if tonumber(nGemID_3) > 0 then
						nGemHoleCounts = nGemHoleCounts + 1
					end
					if nGemHoleCounts > 3 then
						nGemHoleCounts = 3
					end
				end	
			end
		end
	end		
	--宝石部分
	if( type(nGemHoleCounts) == "number" and nGemHoleCounts>0 ) then 
		toDisplay = toDisplay .. ";SuperTooltip_GemPart";
	end
	--金钱1
	if( nMoney1 ~= nil) then 
		toDisplay = toDisplay .. ";SuperTooltip_MoneyPart";
	end

	--金钱2
	if(nMoney2 ~= nil) then 
		toDisplay = toDisplay .. ";SuperTooltip_MoneyPart_2";
	end
	--高级保护
	local nGoodsProtect = 1
	local nXingZhenSkill_1,nXingZhenSkill_2 = nil,nil
	local nKSFWG_1,nKSFWG_2 = nil,nil
	local nXiuLian_1,nXiuLian_2 = nil,nil
	local TALENT,TALENT2,id = nil,nil,0
	if typeDesc ~= nil then
		nXingZhenSkill_1,nXingZhenSkill_2 = string.find(typeDesc,"秘技")
		nKSFWG_1,nKSFWG_2 = string.find(typeDesc,"KFSWG_")
		nXiuLian_1,nXiuLian_2 = string.find(typeDesc,"XL_BOOK")
		nXiuLian_1,nXiuLian_2 = string.find(typeDesc,"XL_BOOK")
		TALENT,TALENT2,id = string.find(typeDesc,"TALENT_(%w%w%w)")
	end
	--原先不存在的部分
	local nEquipMasterFlag = 0
	if DataPool:GetPlayerMission_DataRound(309) > 0 then
		nEquipMasterFlag = 1
	end	
	if nGoodsProtect == 1 and nEquipMasterFlag == 1 then
		if TALENT ==nil and TALENT2 == nil and nXingZhenSkill_1 == nil and nXingZhenSkill_2 == nil and nKSFWG_1 == nil and nKSFWG_2 == nil and nXiuLian_1 == nil and nXiuLian_2 == nil then
			toDisplay = toDisplay .. ";SuperTooltip_Notice";
		end
	end
	id = tonumber(id)
	local Sect = id
	if id ~= 0 and id ~= nil then
		if id < 199 then
			for i = 1,id do
				if Sect <= 11 then
					break
				end
				Sect = Sect - 11
			end
		elseif id >= 199 then
			Sect = 0
		end
	end
	local bhave,SectLevel = 0,0
	if id ~= nil then
		bhave,SectLevel = Lua_HasSect(id,0);
	end
	--属性
	if(szPropertys ~= nil) or ( nKSFWG_1 ~= nil and nKSFWG_2 ~= nil ) or (TALENT ~= nil and TALENT2 ~= nil and SectLevel > 0 and SectLevel < 5 and Sect ~= 1 ) then 
		toDisplay = toDisplay .. ";SuperTooltip_Property";
	else
		if typeDesc ~= nil then
			local Pos_1,Pos_2 = string.find(typeDesc,"PetSoulEquip")
			if Pos_1 ~= nil and Pos_2 ~= nil then
				toDisplay = toDisplay .. ";SuperTooltip_Property";	
			end
		end		
	end
	--作者
	if typeDesc ~= "#cffcc99时装" and typeDesc ~= "#cffcc99幻饰武器" then
	if(szAuthor ~= nil ) then
			if typeDesc == nil then--and string.find(ItemTitle,"典籍·") ~= nil
				toDisplay = toDisplay .. ";SuperTooltip_Manufacturer_Frame";
			else
				if string.find(typeDesc,"PET|") == nil and string.find(typeDesc,"武魂_") == nil  then
					toDisplay = toDisplay .. ";SuperTooltip_Manufacturer_Frame";
				end
			end
		end
	end
	--详细解释
	local nEquiMasterText = ""
	local nBaiShouLevelText = ""
		toDisplay = toDisplay .. ";SuperTooltip_Explain";

	--显示组件内容
	if(toDisplay=="") then
		this:Hide();
		return 0;
	end;
	AxTrace( 8,0,toDisplay );
	_SuperTooltip_:SetProperty("PageElements",  toDisplay);
	--获取物品等级
	local nItemLevel = 1
	local nLevelData = SuperTooltips:GetDesc1()
	local nLevelPos1,nLevelPos2 = string.find(nLevelData,"等级:")
	if nLevelPos1 ~= nil and nLevelPos2 ~= nil then
		LEVEL_SPLIT_DATA = Split(nLevelData,":")
		local nLevelPos3,nLevelPos4 = string.find(nLevelData,"/修炼")
		if nLevelPos3 ~= nil and nLevelPos4 ~= nil then --暗器修正
			LEVEL_SPLIT_DATA_FIX = Split(LEVEL_SPLIT_DATA[2],"/")
			LEVEL_SPLIT_DATA[2] = LEVEL_SPLIT_DATA_FIX[1]
		end
		nItemLevel = tonumber(LEVEL_SPLIT_DATA[2])
	end		
		----------------------------------------------------------------------
		--显示新的内容
		SuperTooltip_StaticPart_Title:SetText(SuperTooltips:GetTitle());
		SuperTooltip_StaticPart_Item1:SetText(SuperTooltips:GetDesc1());
		SuperTooltip_StaticPart_Item2:SetText(SuperTooltips:GetDesc2());
		SuperTooltip_StaticPart_Item3:SetText(SuperTooltips:GetDesc3());
	local Is_Weapon =0
	if typeDesc ~= nil then
		for i=  1,8 do
			local Pos1_WQ,Pos2_WQ = string.find(typeDesc, xSrtong[i].Tooltip)
			if Pos1_WQ ~= nil and Pos2_WQ ~= nil then
				Is_Weapon = 1
			end
		end
	end
	--////////////////////////////////////////////////////
	--百兵精通
	local nIs_BBJT_Equip =0
	if typeDesc ~= nil then
		for i = 1, table.getn(xSrtong) do
			local Pos1_BBJT,Pos2_BBJT = string.find(typeDesc, xSrtong[i].Tooltip)
			if Pos1_BBJT ~= nil and Pos2_BBJT ~= nil then
				nIs_BBJT_Equip = 1
			end
		end
	end
	if nEquipMasterFlag == 1 and nIs_BBJT_Equip == 1 then
		local nNeedLevel = nItemLevel - 10
		if nNeedLevel <= 0 then
			nNeedLevel = 1
		end
		nEquiMasterText = string.format("#c00ccff携带等级降至%d（百兵精通）",nNeedLevel)
	end		
		local StrongLevel	=SuperTooltips:GetDesc4();
	--*************************************************显示雕纹*************************************************
	local  _,dwIcon,dwIconEx = Lua_GetDWShowMsg(szAuthor)--&DW()      
	if (dwIcon ~= "" and dwIcon ~= nil ) then
		SuperTooltip_StaticPart_DW:Show()
		SuperTooltip_StaticPart_DW:SetProperty("Image", dwIcon)
	else
		SuperTooltip_StaticPart_DW:Hide()
	end	
	if( szPropertys ~= nil and typeDesc ~= nil ) then--雕文其他			
		local  dwdesc = Lua_GetDWShowMsg(szAuthor) --diaowen
		--武魂雕纹特写 2019-11-3 16:05:46 逍遥子
		g_DWAttr = dwdesc
		local wunhPos1,wunhsxPos1 = string.find(typeDesc, "武魂")
		if wunhPos1 == nil and  wunhsxPos1 == nil and dwdesc ~= "" and dwdesc ~=nil  then
			local tmp1,tmp2 = string.find(szPropertys, "绑定#r")
			local tmp3,tmp4 = string.find(szPropertys, "刻铭#r")				
			if tmp3 ~= nil then
				szPropertys = string.gsub(szPropertys, "刻铭#r", "刻铭#r"..dwdesc);
			elseif tmp1 ~= nil then
				szPropertys = string.gsub(szPropertys, "绑定#r", "绑定#r"..dwdesc);
			else
				szPropertys = dwdesc..szPropertys
			end
		end
	end	
	--最终显示
	if( szPropertys ~= nil) and string.find(typeDesc, "暗器") ~= nil then
		--暗器雕纹
		local  _,dwIcon,dwIconEx = Lua_GetDWShowMsgEx()--&DW()      
		if (dwIcon ~= "" and dwIcon ~= nil ) then
			SuperTooltip_StaticPart_DW:Show()
			SuperTooltip_StaticPart_DW:SetProperty("Image", dwIcon)
		else
			SuperTooltip_StaticPart_DW:Hide()
		end
		if( szPropertys ~= nil) then--雕文其他			
			local  dwdesc = Lua_GetDWShowMsgEx()
			if dwdesc ~= "" and dwdesc ~=nil  then
				local tmp1,tmp2 = string.find(szPropertys, "绑定#r")
				local tmp3,tmp4 = string.find(szPropertys, "刻铭#r")				
				if tmp3 ~= nil then
					szPropertys = string.gsub(szPropertys, "刻铭#r", "刻铭#r"..dwdesc);
				elseif tmp1 ~= nil then
					szPropertys = string.gsub(szPropertys, "绑定#r", "绑定#r"..dwdesc);
				else
				szPropertys = dwdesc..szPropertys
				end		
			end
		end
	end 	
		if(StrongLevel~="" and tonumber(StrongLevel)>0) then
			
			SuperTooltip_StaticPart_Item4:SetText("#c0FFFFF强化: +"..SuperTooltips:GetDesc4());
		end;
		--SuperTooltip_StaticPart_Item5:SetText(SuperTooltips:GetDesc5());
		SuperTooltip_StaticPart_Icon:SetImage(SuperTooltips:GetIconName());
		SuperTooltip_ShortDesc_Text:SetText(typeDesc);
		
		
		if (IsProtectd == "1" and unLockingElapsedTime ~= 0) then		
			local strLeftTime = g_GetUnlockingStr(unLockingElapsedTime);		
			SuperTooltip_UnlockingTimePart:SetText("#b#cFFFF00"..strLeftTime);
			SuperTooltip_StaticPart_Icon_Protected : SetProperty("Image","set:CommonFrame6 image:NewLock");
		else
			SuperTooltip_UnlockingTimePart:SetText("");
			SuperTooltip_StaticPart_Icon_Protected : SetProperty("Image","set:UIIcons image:Icon_Lock");
		end
		--tongxi modify 显示星星
		--AxTrace( 5,0,StrongLevel );
		local qual =SuperTooltips:GetEquipQual();
		if(type(qual) == "number" and tonumber(qual)>0)then
			local starNum	=	tonumber(qual);
			if(starNum<10) then
				for i=1,starNum do
					--AxTrace( 5,0,StrongLevel.."hehe" );
					if starNum <=4 then
						g_Stars[i]:SetProperty("Animate", "Animate_StarNoFlash");
					else
						g_Stars[i]:SetProperty("Animate", "Animate_Star");
					end
					g_Stars[i]:Show();
				end;
				for i=starNum+1, 9 do
					g_Stars[i]:SetProperty("Animate", "Animate_StarDark");
					g_Stars[i]:Show();
				end
			end;
		end;
		if(IsProtectd=="1") then
			SuperTooltip_StaticPart_Icon_Protected:Show();
		end;
		--modify end
		if( type(nGemHoleCounts) == "number" and nGemHoleCounts>0) then
			AxTrace(5,1,"nGemHoleCounts="..nGemHoleCounts)
			if(nGemHoleCounts > 0) then 
				SuperTooltip_StaticPart_Gem1:Show();
			end
			
			if(nGemHoleCounts > 1) then 
				SuperTooltip_StaticPart_Gem2:Show();
			end
			
			if(nGemHoleCounts > 2) then 
				SuperTooltip_StaticPart_Gem3:Show();
			end
			
			if(nGemHoleCounts > 3) then 
				SuperTooltip_StaticPart_Gem4:Show();
			end
			
			
			local gemIcon = SuperTooltips:GetGemIcon1();
			AxTrace(5,5,"gemIcon="..gemIcon)
			if(gemIcon ~= "") then
				SuperTooltip_StaticPart_Gem1:SetProperty("ShortImage", gemIcon);
			end
			
			gemIcon = SuperTooltips:GetGemIcon2();
			AxTrace(5,5,"gemIcon="..gemIcon)
			if(gemIcon ~= "") then
				SuperTooltip_StaticPart_Gem2:SetProperty("ShortImage", gemIcon);
			end
			
			gemIcon = SuperTooltips:GetGemIcon3();
			AxTrace(5,5,"gemIcon="..gemIcon)
			if(gemIcon ~= "") then
				SuperTooltip_StaticPart_Gem3:SetProperty("ShortImage", gemIcon);
			end
			
			gemIcon = SuperTooltips:GetGemIcon4();
			
			AxTrace(5,5,"gemIcon="..gemIcon)
			if(gemIcon ~= "") then
				SuperTooltip_StaticPart_Gem4:SetProperty("ShortImage", gemIcon);
			end
			
		end
	--*************************************************百兵精通*************************************************
	if nEquipMasterFlag == 1 then
		SuperTooltip_BaiBingJingTong_Text:SetText(nEquiMasterText)
	else
		SuperTooltip_BaiBingJingTong_Text:SetText("")
	end
	--*************************************************百兵精通*************************************************		
	--*************************************************百兽精通*************************************************
	local nIsBaiShou = 0
	if nIsBaiShou == 1 then
		SuperTooltip_BaishouJingTong_Text : SetText(nBaiShouLevelText)
	else
		SuperTooltip_BaishouJingTong_Text : SetText("")
	end
	--*************************************************百兽精通*************************************************
	if typeDesc ~= "#cffcc99时装" then --点缀特殊显示
		local gemIcon = SuperTooltips:GetGemIcon1();
		if(gemIcon ~= "") then
			SuperTooltip_StaticPart_Gem1:SetProperty("ShortImage", gemIcon);
		end
		gemIcon = SuperTooltips:GetGemIcon2();
		if(gemIcon ~= "") then
			SuperTooltip_StaticPart_Gem2:SetProperty("ShortImage", gemIcon);
		end
		gemIcon = SuperTooltips:GetGemIcon3();
		if(gemIcon ~= "") then
			SuperTooltip_StaticPart_Gem3:SetProperty("ShortImage", gemIcon);
		end
		gemIcon = SuperTooltips:GetGemIcon4();			
		if(gemIcon ~= "") then
			SuperTooltip_StaticPart_Gem4:SetProperty("ShortImage", gemIcon);
		end
	else
		if szAuthor ~= nil and szAuthor ~= "" then
			local nGemPos_1,nGemPos_2,nGemID_1,_,nGemID_2,_,nGemID_3 = string.find(szAuthor,"&DZ("..string.rep("%d",8)..")".."(%w)".."("..string.rep("%d",8)..")".."(%w)".."("..string.rep("%d",8)..")")
			local GemInfo = {}--Split(szAuthor,",")
			if nGemPos_1 ~= nil and nGemPos_2 ~= nil then
				GemInfo[1] = nGemID_1
				GemInfo[2] = nGemID_2
				GemInfo[3] = nGemID_3
			end
			-- PushDebugMessage("tonumber(GemInfo[1])   "..Gem_Cloth_Icon[tonumber(GemInfo[1])])
			if GemInfo[1] ~= nil and Gem_Cloth_Icon[tonumber(GemInfo[1])] ~= nil then
				SuperTooltip_StaticPart_Gem1:SetProperty("ShortImage", Gem_Cloth_Icon[tonumber(GemInfo[1])]);
			end
			if GemInfo[2] ~= nil and Gem_Cloth_Icon[tonumber(GemInfo[2])] ~= nil then
				SuperTooltip_StaticPart_Gem2:SetProperty("ShortImage", Gem_Cloth_Icon[tonumber(GemInfo[2])]);
			end
			if GemInfo[3] ~= nil and Gem_Cloth_Icon[tonumber(GemInfo[3])] ~= nil then
				SuperTooltip_StaticPart_Gem3:SetProperty("ShortImage", Gem_Cloth_Icon[tonumber(GemInfo[3])]);
			end
			local Gem_Cloth_Name = ""
			for i = 1,3 do
				if tonumber(GemInfo[i]) ~= nil and tonumber(GemInfo[i]) ~= 0 then
					local theAction = GemMelting:UpdateProductAction(tonumber(GemInfo[i]))
					if theAction:GetID() ~= 0 then
						Gem_Cloth_Name = "#Y"..Gem_Cloth_Name..theAction:GetName().."#r"
						nGemNum = nGemNum + 1
					end
				end
			end
			szPropertys =  szPropertys..Gem_Cloth_Name
		end	
	end		
	if(typeDesc == "#cffcc99时装" and szAuthor ~= nil) then
		--时装染色
		local nPos1,nPos2,nColorId = string.find(szAuthor,"&CO(%w%w%w%w)")
		if nPos1 ~= nil and nPos2 ~= nil then
			local nColorID,nColorName = Lua_GetDressColor(tonumber(nColorId))
			if nColorID ~= -1 and nColorName ~= "" then
				szExplain = szExplain.."#r"..nColorName
			end
		end
		--蜜语金丝
		nPos1,nPos2 = string.find(szAuthor,"&MY")
		if nPos1 ~= nil and nPos2 ~= nil then
			local MYJS_Data = string.sub(szAuthor,nPos2+1,string.len(szAuthor))
			local sweetWordsID = tonumber(string.sub(MYJS_Data,1,2))
			local nCreator_JS = string.sub(MYJS_Data,3,string.len(MYJS_Data))
			if tonumber(sweetWordsID) > 0 then
				local len = string.len( nCreator_JS ) - 8
				if len == nil or len > 14 or len <= 0 then
					len = 14
				end
				local spaceStr = g_supertooltip_space_num[len].spaceStr
				local sweetWords = g_supertooltip_sweet_words[ tonumber( sweetWordsID ) ].sweetWords
				if sweetWords ~= nil and sweetWords ~= "" then
					if szPropertys ~= nil then
						SuperTooltip_Property:SetText(szPropertys.."#{MYJS_120723_25}\n"..sweetWords..spaceStr..nCreator_JS );
					else
						SuperTooltip_Property:SetText("#{MYJS_120723_25}\n"..sweetWords..spaceStr..nCreator_JS );
					end
				end                
			end
		end
	end	
	if(nMoney1 ~= nil)  then
		SuperTooltip_StaticPart_Money_Text:SetText(szMoneyDesc1);
		SetupMoneyPart(1,nMoney1);
			
	end		
	if(nMoney2 ~= nil)  then
		SuperTooltip_StaticPart_Money_Text_2:SetText(szMoneyDesc2);
		SetupMoneyPart(2,nMoney2);
	end
		
	if( szPropertys ~= nil) then
		SuperTooltip_Property:SetText(szPropertys);
	end
	if nXinfaId ~= nil and nXinfaId ~= "" then
		if nXinfaId >= 160 and nXinfaId <= 509 then
			local addskill = TBSearch_Index_EQU("SUPERTOOLTIP",nXinfaId)
			if addskill ~= nil and addskill ~= "" then
				if table.getn(addskill) > 0 then
					for i = 1,table.getn(addskill) do
						if addskill[i] == nil or addskill[i] == "" then
							break
						end
						local nHave,nLevel = Lua_HasSect(addskill[i],0);
						if nHave > 0 then
							local infodesc = TBSearch_Index_EQU("DBC_SECT_DESC",tonumber(addskill[i]))
							szExplain = szExplain.."#r#Y武道效果#r#W"..infodesc.szLevelDesc[nLevel]
						end
					end
				end
			end
		elseif nXinfaId >= 152 and nXinfaId <= 157 then
			local NewSkill = {[0] = {152,153,154},[1] = {155,156,157}}
			local JiNeng = 0
			for i = 0,1 do
				for j = 1,3 do
					if NewSkill[i][j] == nXinfaId then
						JiNeng = 199 + (Player:GetData("MEMPAI") * 20 ) + (DataPool:GetPlayerMission_DataRound(480) -1 ) * 10 + j + 6
						break
					end
				end
			end
			if JiNeng > 0 then
				local nHave,nLevel = Lua_HasSect(JiNeng,0);
				if nHave > 0 then
					local infodesc = TBSearch_Index_EQU("DBC_SECT_DESC",JiNeng)
					szExplain = GetTalentErSkillDesc(infodesc.szLevelDesc[nLevel],szExplain)
					SuperTooltip_Explain:SetText(szExplain);
					return 1
				end
			end
		end
	end
	if typeDesc ~= nil then
		if TALENT ~= nil and TALENT2 ~= nil then
			--区分预览界面，预览直接5级数据
			if IsWindowShow("Talent_Preview") then
				SectLevel = 5
				-- szPropertys				
			end
			--武道境界
			SuperTooltip_StaticPart_Item1:SetText("#W武道境界：武道一重")
			--武道等级
			SuperTooltip_StaticPart_Item2:SetText(string.format("#W武道等级：%s/5",SectLevel))
			SuperTooltip_StaticPart_Item3:SetText("")
			local infodesc = TBSearch_Index_EQU("DBC_SECT_DESC",tonumber(id))
			--武道境界
			if infodesc.szJingjie ~= nil then
				SuperTooltip_StaticPart_Item1:SetText("#W武道境界：武道"..infodesc.szJingjie.."重")
			end
			if infodesc.szLevelDesc[SectLevel] == nil and SectLevel == 0 and Sect ~= 1 then
				szExplain = "1级效果（激活生效）#r"..infodesc.szLevelDesc[1]
			elseif SectLevel > 0 and SectLevel < 5 and Sect ~= 1 then
				szPropertys = string.format("当前等级效果：（%s级）#r",SectLevel)..infodesc.szLevelDesc[SectLevel]
				szExplain = string.format("下一等级效果：（%s级）#r",SectLevel+1)..infodesc.szLevelDesc[SectLevel+1]
			elseif Sect ~= 1 then
				szExplain = string.format("当前满级效果：（%s级）#r",5)..infodesc.szLevelDesc[5]				
			end	
			if Sect == 1 then
				SuperTooltip_StaticPart_Item2:Hide()
			else
				SuperTooltip_StaticPart_Item2:Show()
			end
			SuperTooltip_Explain:SetText(szExplain);
			if szPropertys ~= nil then
				SuperTooltip_Property:SetText(szPropertys);
			end
			return 1
		end
	end
	if typeDesc ~= nil then
		local Pos_1,Pos_2,nPsType,nPsQual = string.find(typeDesc,"PetSoulEquip(%w)(%w)")
		if Pos_1 ~= nil and Pos_2 ~= nil then
			SuperTooltip_StaticPart_Title:SetText("#cff6600"..SuperTooltips:GetTitle());
			local DescoName = {"#{SHXT_20211230_172}","#{SHXT_20211230_171}","#{SHXT_20211230_170}"}
			nPsQual = tonumber(nPsQual)
			typeDesc = DescoName[nPsQual+1]
			if szPropertys == nil then
				szPropertys = ""
			end
			local Soul = LuaFnGetPetSoulPsTypeEx(nPsType)
			--详细属性
			local ItemBind = string.find(szPropertys,"绑定")
			if ItemBind == nil then	--绑定
				szPropertys = "#cccffff装备时绑定\n"	
			end
			if g_NewAuthorInfo ~= "" then
				szPropertys = "#cccffff已绑定\n"	
			end
			local nLevel,nPinJie,nHunYi,nSolt,nSkill,nAttrInfo = 1,1,0,1,1,""
			--100 6 10000 6 A15000 B2000 C1500 D4500 E4000 F300
			if szAuthor == nil and g_NewAuthorInfo ~= "" then
				szAuthor = g_NewAuthorInfo
			end
			if szAuthor ~= nil then
				local posx,posy,Level,PinJie,HunYi,skill,AttrInfo = string.find(szAuthor,"&SH(%w%w%w)(%w)(%w%w%w%w%w)(%w)(.*)")
				if posx ~= nil and posy ~= nil then
					nLevel = tonumber(Level)
					nPinJie = tonumber(PinJie)
					nHunYi = tonumber(HunYi)
					nSolt = nPinJie
					nSkill = tonumber(skill)
					nAttrInfo = AttrInfo
				else
					nAttrInfo = "&SH"
				end
			else
				nAttrInfo = "&SH"
			end
			local nMaxExpTable = {{300,750,2000,4500,10000,10000},{450,1120,3000,6750,15000,15000},{600,1500,4000,9000,20000,20000}}
			SuperTooltip_StaticPart_Item1:SetText("#cc8b88e等级："..nLevel);
			SuperTooltip_StaticPart_Item2:SetText("#cc8b88e魂境阶级："..nPinJie);
			SuperTooltip_StaticPart_Item3:SetText("#cc8b88e魂意值："..nHunYi.."/"..nMaxExpTable[nPsQual+1][nPinJie]);
			--资质属性部分
			local nAttrper = {"#cFAFFA4力量资质：+%s","#cFAFFA4灵气资质：+%s","#cFAFFA4体力资质：+%s","#cFAFFA4定力资质：+%s","#cFAFFA4身法资质：+%s"}
			local GetPetSoulPer = LuaFnGetPetSoulLevelupInfo(nLevel,Soul)
			for i = 1,5 do
				szPropertys = szPropertys..string.format(nAttrper[i],string.format("%.2f", GetPetSoulPer[i]/100)).."%".."\n"
			end
			--扩展属性条数
			local nMaxSolt = 4
			if nPsQual == 2 then
				nMaxSolt = 6
			elseif nPsQual == 1 then
				nMaxSolt = 5
			end
			szPropertys = szPropertys..string.format("#cFFCC99扩展属性条数：%s/%s",nSolt,nMaxSolt).."\n"
			--基础属性加成
			local BaseAttr = LuaFnGetPetSoulBase(nAttrInfo,3,nSolt,nMaxSolt)
			szPropertys = szPropertys.."#{SHXT_20211230_230}".."\n"..BaseAttr
			--融魂描述
			szPropertys = szPropertys.."#{SHXT_20211230_231}".."\n".."#{SHXT_20211230_232}".."\n"
			--出战描述
			local FightDes,FigthName1,FigthName2 = LuaFnGetPetSoulSkill(Soul,nPinJie)
			szPropertys = szPropertys.."#c009933#{SHXT_20211230_190}".."\n".."#{JIZHI_"..FightDes.."}".."\n#{SHXT_20211230_191}\n"..FigthName1.."\n"..FigthName2
			SuperTooltip_Property:SetText(szPropertys);
			SuperTooltip_ShortDesc_Text:SetText(typeDesc);
			SuperTooltip_Explain:SetText(szExplain);
			return 1
		end
	end
	--Q546528533兽魂特写
	if nXinfaId ~= nil then
		if nXinfaId >= 765 and nXinfaId <= 854 then
			local strName = Player:GetSkillInfo(nXinfaId,"explain");
			SuperTooltip_Explain:SetText(strName);
			return 1
		end
	end	
	if( szAuthor ~= nil) then
    	local agname = string.find(szAuthor, "&")		--Q546528533新增	
		if agname ~= nil then
			local mytypeDesc = string.sub(szAuthor,1,agname-1)
			SuperTooltip_Manufacturer:SetText(mytypeDesc);
			SuperTooltip_Manufacturer_Frame:Show()
		else
			SuperTooltip_Manufacturer:SetText(szAuthor);
		end	
     end		
	--/////////////////////////修炼系统显示{利群天龙独家}
	if typeDesc ~= nil then
		local Pos1_XL,Pos2_XL = string.find(typeDesc, "XL_BOOK")
		if Pos1_XL ~= nil and Pos2_XL ~= nil then
			XiuLianBookData = Split(typeDesc,"_")
			local Book_code = XiuLianBookData[3] --数值修正
			local nLevel_JingJie = GetXiuLianBookInfo(tonumber(Book_code - 1),"Level")
			SuperTooltip_StaticPart_Item1:SetText("#{XL_XML_29}");
			SuperTooltip_StaticPart_Item2:SetText(string.format("#cfff263第%d重",nLevel_JingJie));
			SuperTooltip_StaticPart_Item3:SetText("");
			typeDesc = ""
		end
		local Pos3_XL,Pos4_XL = string.find(typeDesc, "XL_MIJI")
		if Pos3_XL ~= nil and Pos4_XL ~= nil then
			MijiBookData = Split(typeDesc,"_")
			local MIJI_code = tonumber(MijiBookData[3])--数值修正
			if MIJI_code < 12 then
				local MIJI_StrCode = {}
				local MIJI_Add = GetXiuLianMiJiInfo(MIJI_code - 1,"XYJ_MIJI_ADD")
				local MIJI_Add_Next = GetXiuLianMiJiInfo(MIJI_code - 1,"XYJ_MIJI_NEXT_ADD")
				local MIJI_Add_Fina = GetXiuLianMiJiInfo(MIJI_code - 1,"XYJ_MIJI_FIN_ADD")
				local MIJI_Name = {"力量","灵气","体力","定力","身法","外功攻击","内功攻击","外功防御","内功防御","命中","闪避"}
				MIJI_StrCode[1] = "#W基础"..MIJI_Name[MIJI_code].."提升：#H"..MIJI_Add.."%"
				MIJI_StrCode[2] = "#W基础"..MIJI_Name[MIJI_code].."提升：#H"..MIJI_Add_Fina.."%"
				MIJI_StrCode[3] = "#W基础"..MIJI_Name[MIJI_code].."提升：#H"..MIJI_Add_Next.."%"
				szExplain = "#W当前等级效果：\n"..MIJI_StrCode[1].."\n \n".."#W受心法和人物等级影响后效果：".."\n"..MIJI_StrCode[2].."\n \n".."#W下一等级效果：\n"..MIJI_StrCode[3].."\n \n".."#W"..szExplain
			end
			local nMijiLevel = GetXiuLianMiJiInfo(MIJI_code - 1,"Level")
			local nMijiLevelMax = GetXiuLianMiJiInfo(MIJI_code - 1,"MaxLevel")
			local nMiJi_JingJie = GetXiuLianMiJiInfo(MIJI_code - 1,"JingJie")
			SuperTooltip_StaticPart_Item1:SetText(string.format("#cfff263修炼等级：%d/%d",nMijiLevel,nMijiLevelMax));
			SuperTooltip_StaticPart_Item2:SetText(string.format("#cfff263修炼境界：第%d重",nMiJi_JingJie));
			SuperTooltip_StaticPart_Item3:SetText("");
			SuperTooltip_Explain:SetText(szExplain);
			return 1;
		end
	end	 
	--===重楼套装显示（现行测试版） Q546528533 同步
	if typeDesc ~= nil and string.find(SuperTooltips:GetTitle(),"重楼") ~= nil then
	    if string.find(typeDesc,"戒指") ~= nil or string.find(typeDesc,"项链") ~= nil or string.find(typeDesc,"护符") ~= nil then
		    if string.find(SuperTooltips:GetTitle(),"真·") ~= nil then
				local _,_,EquipSetNum = string.find(szPropertys,"（(%w)/3）")			
				if tonumber(EquipSetNum)== 2 then
					szPropertys = string.gsub(szPropertys,"{equip_attr_restorehp}%s%p1","免疫控制几率 +10%%")
		    	elseif tonumber(EquipSetNum) == 3 then
				    szPropertys = string.gsub(szPropertys,"{equip_attr_restorehp}%s%p1","免疫控制几率 +10%%")
				    szPropertys = string.gsub(szPropertys,"{equip_attr_restorehp}%s%p2","免疫控制几率 +10%%")
				end			
				SuperTooltip_Property:SetText(szPropertys);
				SuperTooltip_Explain:SetText(szExplain);
				return 1
			end			
		end		
	    if string.find(typeDesc,"戒指") ~= nil or string.find(typeDesc,"项链") ~= nil or string.find(typeDesc,"护符") ~= nil then
		    if string.find(SuperTooltips:GetTitle(),"真·") == nil then
				local _,_,EquipSetNum = string.find(szPropertys,"（(%w)/3）")			
				if tonumber(EquipSetNum)== 2 then
					szPropertys = string.gsub(szPropertys,"{equip_attr_restorehp}%s%p1","免疫控制几率 +5%%")
		    	elseif tonumber(EquipSetNum) == 3 then
				    szPropertys = string.gsub(szPropertys,"{equip_attr_restorehp}%s%p1","免疫控制几率 +5%%")
				    szPropertys = string.gsub(szPropertys,"{equip_attr_restorehp}%s%p2","免疫控制几率 +5%%")
				end			
				SuperTooltip_Property:SetText(szPropertys);
				SuperTooltip_Explain:SetText(szExplain);
				return 1
			end		
		end			    
		if string.find(typeDesc,"鞋") ~= nil or string.find(typeDesc,"帽") ~= nil or string.find(typeDesc,"手") ~= nil or string.find(typeDesc,"腰") ~= nil or string.find(typeDesc,"腕") ~= nil then
		    if string.find(SuperTooltips:GetTitle(),"真·") ~= nil then
				local _,_,EquipSetNum = string.find(szPropertys,"（(%w)/5）")			
				if tonumber(EquipSetNum)== 2 then
					szPropertys = string.gsub(szPropertys,"{equip_attr_restorehp}%s%p1","全属性 +600")
		    	elseif tonumber(EquipSetNum) == 3 then
				    szPropertys = string.gsub(szPropertys,"{equip_attr_restorehp}%s%p1","全属性 +600")
				    szPropertys = string.gsub(szPropertys,"{equip_attr_restorehp}%s%p2","全属性攻击 +10%%")
		    	elseif tonumber(EquipSetNum) == 4 then
				    szPropertys = string.gsub(szPropertys,"{equip_attr_restorehp}%s%p1","全属性攻击 +600")
				    szPropertys = string.gsub(szPropertys,"{equip_attr_restorehp}%s%p2","全属性攻击 +10%%")
				    szPropertys = string.gsub(szPropertys,"{equip_attr_restorehp}%s%p3","全属性抗性 +10%%")
		    	elseif tonumber(EquipSetNum) == 5 then
				    szPropertys = string.gsub(szPropertys,"{equip_attr_restorehp}%s%p1","全属性攻击 +600")
				    szPropertys = string.gsub(szPropertys,"{equip_attr_restorehp}%s%p2","全属性攻击 +10%%")
				    szPropertys = string.gsub(szPropertys,"{equip_attr_restorehp}%s%p3","全属性抗性 +10%%")
				    szPropertys = string.gsub(szPropertys,"{equip_attr_restorehp}%s%p4","重楼破军：攻击时有6%%的几率进入疯狂和嗜血状态，疯狂状态无视目标的防御，持续20秒，嗜血状态降低目标10%%血值。")
				end
				SuperTooltip_Property:SetText(szPropertys);
				SuperTooltip_Explain:SetText(szExplain);
				return 1
			end			
		end			
		if string.find(typeDesc,"鞋") ~= nil or string.find(typeDesc,"帽") ~= nil or string.find(typeDesc,"手") ~= nil or string.find(typeDesc,"腰") ~= nil or string.find(typeDesc,"腕") ~= nil then
		    if string.find(SuperTooltips:GetTitle(),"真·") == nil then
				local _,_,EquipSetNum = string.find(szPropertys,"（(%w)/5）")
                -- PushDebugMessage(EquipSetNum)				
				if tonumber(EquipSetNum)== 2 then
					szPropertys = string.gsub(szPropertys,"{equip_attr_restorehp}%s%p1","全属性 +300")
		    	elseif tonumber(EquipSetNum) == 3 then
				    szPropertys = string.gsub(szPropertys,"{equip_attr_restorehp}%s%p1","全属性 +300")
				    szPropertys = string.gsub(szPropertys,"{equip_attr_restorehp}%s%p2","全属性攻击 +5%%")
		    	elseif tonumber(EquipSetNum) == 4 then
				    szPropertys = string.gsub(szPropertys,"{equip_attr_restorehp}%s%p1","全属性攻击 +300")
				    szPropertys = string.gsub(szPropertys,"{equip_attr_restorehp}%s%p2","全属性攻击 +5%%")
				    szPropertys = string.gsub(szPropertys,"{equip_attr_restorehp}%s%p3","全属性抗性 +5%%")
		    	elseif tonumber(EquipSetNum) == 5 then
				    szPropertys = string.gsub(szPropertys,"{equip_attr_restorehp}%s%p1","全属性攻击 +300")
				    szPropertys = string.gsub(szPropertys,"{equip_attr_restorehp}%s%p2","全属性攻击 +5%%")
				    szPropertys = string.gsub(szPropertys,"{equip_attr_restorehp}%s%p3","全属性抗性 +5%%")
				    szPropertys = string.gsub(szPropertys,"{equip_attr_restorehp}%s%p4","重楼破军：攻击时有3%%的几率进入疯狂和嗜血状态，疯狂状态无视目标的防御，持续10秒，嗜血状态降低目标5%%血值。")
				end
				SuperTooltip_Property:SetText(szPropertys);
				SuperTooltip_Explain:SetText(szExplain);
				return 1
			end			
		end			
	end
	if typeDesc ~= nil and typeDesc ~= "" then
		local Pos_1,Pos_2,nWGID = string.find(typeDesc,"KFSWG_(%w)")--#gFF0FA0
		if Pos_1 ~= nil and Pos_2 ~= nil then		
			local nLock = LuaFnGetWHWGInfo(tonumber(nWGID),"UnLocked")
			SuperTooltip_StaticPart_Title:SetText("#gFF0FA0"..SuperTooltips:GetTitle());
			if nLock == 0 then
				SuperTooltip_StaticPart_Item1:SetText("#cfff263未激活");
			else
				local nTPGrade = LuaFnGetWHWGInfo(tonumber(nWGID), "Grade")
				local nTPLevel = LuaFnGetWHWGInfo(tonumber(nWGID), "Level")
				SuperTooltip_StaticPart_Item1:SetText("#cfff263等级："..nTPGrade.."阶"..nTPLevel.."级");
				--乾位属性
				local grade = LuaFnGetWHWGInfo(tonumber(nWGID), "Grade")
				local level = LuaFnGetWHWGInfo(tonumber(nWGID), "Level")
				local strAttr,strValue = LuaFnGetWHWGLevelInfo(tonumber(nWGID),grade,level,"wszAttr")
				local attr_yang,attrvalue_yang,effecttype_yang,effectvalue_yang = LuaFnGetWHWGLevelInfo(tonumber(nWGID), grade, level,"AttrEffectYang")
				local attr_yin,attrvalue_yin,effecttype_yin,effectvalue_yin = LuaFnGetWHWGLevelInfo(tonumber(nWGID), grade, level,"AttrEffectYin")
				szPropertys = "#cfff263乾位\n"..g_strAttrDic[attr_yang].." +"..attrvalue_yang.."\n"..string.format("%s伤害增加", g_EffectDic[effecttype_yang + 1]).." +"..string.format("%.2f%%",effectvalue_yang*0.01)
				szPropertys = szPropertys.."\n \n坤位#r"..g_strAttrDic[attr_yin].." +"..attrvalue_yin.."\n"..string.format("受%s伤害降低", g_EffectDic[effecttype_yin + 1]).." +"..string.format("%.2f%%",effectvalue_yin*0.01)
				szPropertys = szPropertys.."\n \n未填入：#r"..g_strAttrDic[strAttr].." +"..strValue
			end
			SuperTooltip_StaticPart_Item2:SetText("");
			SuperTooltip_StaticPart_Item3:SetText("");	
			SuperTooltip_Property:SetText(szPropertys);
			SuperTooltip_Explain:SetText(szExplain);
			return 1
		end
	end
	--珍兽装备
	if typeDesc ~= nil and typeDesc ~= "" and string.find(typeDesc,"PET") ~= nil then
		--以下颜色数据如有异议可至D:\TLBB\ML_365\Prj\GameCode\Client\Game\Item\GMItem_PetEquip.cpp查看
		SuperTooltip_StaticPart_Item1:SetText("");
		SuperTooltip_StaticPart_Item2:SetText("");
		SuperTooltip_StaticPart_Item3:SetText("");
		local tPetEquipData = Split(typeDesc,"|");
		if tPetEquipData ~= nil then
			local isOnEquip = 0;
			if string.find(typeDesc,"PETON") ~= nil then
				isOnEquip = 1;
			end
			local nLevel = SuperTooltips:GetDesc3();
			if nLevel ~= nil and nLevel ~= "" and string.find(nLevel,":") ~= nil then
				local nLevelTemp = Split(nLevel,":");
				local nLevel = tonumber(nLevelTemp[2])
				SuperTooltip_StaticPart_Item1:SetText("#cC8B88E等级: "..nLevel);
			end
			SuperTooltip_ShortDesc_Text:SetText("#cC8B88E"..tPetEquipData[2]); --显示类型
			local nPetEquipID = tonumber(tPetEquipData[3])
			local nEquipQual = tonumber(tPetEquipData[4])
			local nEquipPoint = math.mod(math.floor(nPetEquipID/1000),10)
			SuperTooltip_ShowStar(nEquipQual)
			if nEquipQual < 6 then
				SuperTooltip_StaticPart_Item2:SetText("#{ZSZBSJ_090706_18}");
				SuperTooltip_StaticPart_Item3:SetText("#{ZSZBSJ_090706_17}");
		    else
				SuperTooltip_StaticPart_Item2:SetText("#{ZSZBSJ_090706_18}");
		    end
			local nBaseWG,nBaseNG,nBaseWF,nBaseNF,nBaseMiss,nSetAttr,_,_,_,nEquipBase_1,nEquipBase_2,nEquipBase_3,nEquipBase_4,nEquipBase_1Data,nEquipBase_2Data,nEquipBase_3Data,nEquipBase_4Data = Lua_EnumPetEquip(nPetEquipID)
			local AttrName = {
			[46]="#{equip_attr_dex}",[29]="#{equip_attr_defence_m}",[22]="#{equip_attr_defence_p}",[43]="#{equip_attr_spr}",[26]="#{equip_attr_attack_m}",
			[0]="#{equip_attr_maxhp}",[19]="#{equip_attr_attack_p}",[35]="#{equip_attr_hit}",[42]="#{equip_attr_str}",[36]="#{equip_attr_miss}",[37]="#{equip_attr_2attack}",
			[44]="#{equip_attr_con}",[45]="#{equip_attr_int}",
			}

			local nBaseAttr = "#cC8B88E"
			if nBaseWG > 0 then
				nBaseAttr = nBaseAttr.."#{equip_base_attack_p} +"..nBaseWG.."#r"
			end
			if nBaseNG > 0 then
				nBaseAttr = nBaseAttr.."#{equip_base_attack_m} +"..nBaseNG.."#r"
			end
			if nBaseWF > 0 then
				nBaseAttr = nBaseAttr.."#{equip_base_defence_p} +"..nBaseWF.."#r"
			end
			if nBaseNF > 0 then
				nBaseAttr = nBaseAttr.."#{equip_base_defence_m} +"..nBaseNF.."#r"
			end
			if nBaseMiss > 0 then
				nBaseAttr = nBaseAttr.."#{equip_base_miss} +"..nBaseMiss.."#r"
			end
			local nEquipBase = "#cFFCC00"
			if nEquipBase_1 > 0 then
			    nBaseAttr = nBaseAttr..nEquipBase..AttrName[nEquipBase_1Data].." +"..nEquipBase_1.."#r"
			end
			if nEquipBase_2 > 0 then
			    nBaseAttr = nBaseAttr..nEquipBase..AttrName[nEquipBase_2Data].." +"..nEquipBase_2.."#r"
			end
			if nEquipBase_3 > 0 then
			    nBaseAttr = nBaseAttr..nEquipBase..AttrName[nEquipBase_3Data].." +"..nEquipBase_3.."#r"
			end
			if nEquipBase_4 > 0 then
			    nBaseAttr = nBaseAttr..nEquipBase..AttrName[nEquipBase_4Data].." +"..nEquipBase_4.."#r"
			end 
			--套装效果
			local nSetAttrData = "#cffba00"
			local nAttrName,nStr,nAttrType_1,nAttr_1,nAttrType_2,nAttr_2,nAttrType_3,nAttr_3,nPetEquipT = Lua_EnumPetEquipAttr(nSetAttr)
			if isOnEquip == 0 then
				--#c605c4f     未激活的颜色
				nSetAttrData = nSetAttrData..nAttrName.."(0/5)\n#c605c4f"
				local nSetAttrTable = Lua_GetAttrEquipID(nSetAttr)
				for i = 1,table.getn(nSetAttrTable) do
					nSetAttrData = nSetAttrData..LuaFnGetItemName(nSetAttrTable[i]).."\n"
				end
				for i = 1,4 do
					nSetAttrData = nSetAttrData.."#{GMItem_Equip_8}\n"
				end
			else
				--查看已装备的
				--#c99CC00%s\n 属性颜色
				local Pet_Head  = DataPool:GetXYJServerData(15)
				local Pet_Claw  = DataPool:GetXYJServerData(16)
				local Pet_Body  = DataPool:GetXYJServerData(17)
				local Pet_Neck  = DataPool:GetXYJServerData(18)
				local Pet_Charm = DataPool:GetXYJServerData(19)
				local nEquipTab = {Pet_Head,Pet_Claw,Pet_Body,Pet_Neck,Pet_Charm}
				local nSetAttrTable = Lua_GetAttrEquipID(nSetAttr)
				local nSetAttrNum = 0
				for i = 1,5 do
					if nEquipTab[i] ~= 0 and LuaFnGetItemName(nSetAttrTable[i]) == LuaFnGetItemName(nEquipTab[i]) then
						nSetAttrNum = nSetAttrNum + 1;
					end
				end
				nSetAttrData = nSetAttrData..nAttrName.."("..nSetAttrNum.."/5)\n"
				for i = 1,table.getn(nSetAttrTable) do
					if nEquipTab[i] == 0 or LuaFnGetItemName(nSetAttrTable[i]) ~= LuaFnGetItemName(nEquipTab[i]) then
						nSetAttrData = nSetAttrData.."#c605c4f"..LuaFnGetItemName(nSetAttrTable[i]).."\n"
					else
						nSetAttrData = nSetAttrData.."#cffba00"..LuaFnGetItemName(nSetAttrTable[i]).."\n"
					end
				end
				local nSetAttrExData = "#c99CC00"
				if nSetAttrNum <= 1 then
					for i = 1,4 do
						nSetAttrExData = nSetAttrExData.."#{GMItem_Equip_8}\n"
					end
				elseif nSetAttrNum == 2 then
					nSetAttrExData = nSetAttrExData..AttrName[nAttrType_1].." +"..nAttr_1.."\n"
					for i = 1,3 do
						nSetAttrExData = nSetAttrExData.."#{GMItem_Equip_8}\n"
					end
				elseif nSetAttrNum == 3 then
					nSetAttrExData = nSetAttrExData..AttrName[nAttrType_1].." +"..nAttr_1.."\n"
					nSetAttrExData = nSetAttrExData..AttrName[nAttrType_2].." +"..nAttr_2.."\n"
					for i = 1,2 do
						nSetAttrExData = nSetAttrExData.."#{GMItem_Equip_8}\n"
					end
				elseif nSetAttrNum == 4 then
					nSetAttrExData = nSetAttrExData..AttrName[nAttrType_1].." +"..nAttr_1.."\n"
					nSetAttrExData = nSetAttrExData..AttrName[nAttrType_2].." +"..nAttr_2.."\n"
					nSetAttrExData = nSetAttrExData..AttrName[nAttrType_3].." +"..nAttr_3.."\n"
					nSetAttrExData = nSetAttrExData.."#{GMItem_Equip_8}\n"
				elseif nSetAttrNum == 5 then
					nSetAttrExData = nSetAttrExData..AttrName[nAttrType_1].." +"..nAttr_1.."\n"
					nSetAttrExData = nSetAttrExData..AttrName[nAttrType_2].." +"..nAttr_2.."\n"
					nSetAttrExData = nSetAttrExData..AttrName[nAttrType_3].." +"..nAttr_3.."\n"
					nSetAttrExData = nSetAttrExData..nStr.."\n"
				end
				nSetAttrData = nSetAttrData..nSetAttrExData
			end
			--资质契合部分（这里不完善了 珍兽装备太多 直接固定体力2.5吧）
			local nZiZhiQiHe = ""
			-- nPetEquipT ==
			local nZiZhiQiHeTable = {"#{ZSZB_0710_06}","#{ZSZB_0710_07}","#{ZSZB_0710_08}","#{ZSZB_0710_10}"}
			local nZiZhiQiHeTableOnEquip = {"#{ZSZB_0710_01}","#{ZSZB_0710_02}","#{ZSZB_0710_03}","#{ZSZB_0710_05}"}
			if isOnEquip == 0 then
				nZiZhiQiHe = "#cFFCC99"..nZiZhiQiHeTable[nPetEquipT].."\n"
			else
				--查看已装备的
				nZiZhiQiHe = nZiZhiQiHeTableOnEquip[nPetEquipT].."2.5%\n"
			end
			szPropertys = "#{GMItem_Equip_2}"..nBaseAttr..nZiZhiQiHe..nSetAttrData
			--装备资质
			if isOnEquip == 0 then
				if szAuthor ~= nil and szAuthor ~= "" then
					szPropertys = szPropertys..Lua_GetPetEquipZiZhiDesc(nPetEquipID,szAuthor)
				else
					szPropertys = szPropertys.."#r#{GMItem_Equip_15}"
				end
			else
				--查看已装备的
				local nEquipDataMD = {5,6,7,8,9,10,11,12,13,14}
				nEquipPoint = nEquipPoint + 1
				local nAdpt_1 = DataPool:GetXYJServerData(nEquipDataMD[(nEquipPoint * 2) - 1])
				local nAdpt_2 = DataPool:GetXYJServerData(nEquipDataMD[nEquipPoint * 2])
				if nAdpt_1 == 0 then
					szPropertys = szPropertys.."#r#{GMItem_Equip_15}"
				else
					if nAdpt_1 < 10 then
						nAdpt_1 = "0"..nAdpt_1
					end
					if nAdpt_2 < 10 then
						nAdpt_2 = "0"..nAdpt_2
					end
					local nEquipData = "&PET"..nAdpt_1..nAdpt_2
					szPropertys = szPropertys..Lua_GetPetEquipZiZhiDesc(nPetEquipID,nEquipData)
				end
			end
            SuperTooltip_Property:SetText(szPropertys);
		end
	end	 
	--*************************************************武魂系统*************************************************
	if( szPropertys ~= nil) then	
		local wunhPos1,wunhsxPos1 = string.find(typeDesc, "武魂")
		if  wunhPos1 ~= nil and  wunhsxPos1 ~= nil then
			local nGrow,nExLevel,nLevel,nExp,nMagic,nExAttrNum,nExAttr,nSkill = LuaGetKfsAttrData(szAuthor)
			local nFixnGrow = 500
			--头部显示
			SuperTooltip_StaticPart_Item1:SetText("#cC8B88E携带等级:65");
			SuperTooltip_StaticPart_Item2:SetText("#cC8B88E等级:"..tonumber(nLevel));
			--武魂类型
			local nAttactType = 0
			if string.find(typeDesc,"武魂_0") ~= nil then
				SuperTooltip_StaticPart_Item3:SetText("#{WH_xml_XX(100)}");
			else
				SuperTooltip_StaticPart_Item3:SetText("#{WH_xml_XX(101)}");
				nAttactType = 1;
			end			
			SuperTooltip_ShortDesc_Text:SetText("#cffcc99武魂");
			local Life = LifeAbility:Get_UserEquip_Current_Durability(18);
			local maxLife = LifeAbility:Get_UserEquip_Maximum_Durability(18);
			if maxLife ~= -1 and Life  ~= -1 then
				SuperTooltip_StaticPart_Item4:SetText("#cC8B88E寿命："..tostring(Life).."/"..tostring(maxLife));
			end
			local nKfsBaseDataShow = ""
			local nKfsBaseData = {"#{WH_xml_XX(63)}","#{WH_xml_XX(61)}","#{WH_xml_XX(65)}","#{WH_xml_XX(67)}","#{WH_xml_XX(69)}"}
			local nKfsOldData = {"#{WH_xml_XX(64)}","#{WH_xml_XX(62)}","#{WH_xml_XX(66)}","#{WH_xml_XX(68)}","#{WH_xml_XX(70)}"}
			for i = 1,5 do
				local nBaseAttr,nOldBaseAttr = Lua_KfsGetAttrAndOldAttr(i,nGrow,nAttactType,nLevel)
				if nBaseAttr ~= nil then
					nKfsBaseDataShow = nKfsBaseDataShow..nKfsBaseData[i].."+"..nBaseAttr
				end
				if nOldBaseAttr ~= nil then
					nKfsBaseDataShow = nKfsBaseDataShow.."("..nKfsOldData[i].."+"..nOldBaseAttr..")".."#r"
				end
			end
			local grade = Lua_GetKfsDataGrade(nGrow)
			nFixnGrow = nGrow
			--成长率 2019-10-18 18:47:52逍遥子
			if grade == 0 then
				nGrow = "#{WH_xml_XX(72)}"..nGrow.."(#{ZSKSSJ_PT})#r";
			elseif grade == 1 then
				nGrow = "#{WH_xml_XX(72)}"..nGrow.."(#{ZSKSSJ_YX})#r";
			elseif grade == 2 then
				nGrow = "#{WH_xml_XX(72)}"..nGrow.."(#{ZSKSSJ_JC})#r";
			elseif grade == 3 then
				nGrow = "#{WH_xml_XX(72)}"..nGrow.."(#{ZSKSSJ_ZY})#r";
			elseif grade == 4 then
				nGrow = "#{WH_xml_XX(72)}"..nGrow.."(#{ZSKSSJ_WM})#r";
			end
			
			nExLevel = "#{WH_xml_XX(74)}"..nExLevel.."#r";--合成等级
			local nExAttrNumShow = "#{WH_xml_XX(80)}"..nExAttrNum.."#r#cFFCC00"--扩展属性
			if nExAttrNum >= 1 then
				for i = 1,nExAttrNum do
					local iText , iValue = Lua_GetKfsFixAttrEx(nExAttr,i,nFixnGrow)
					if iValue > 0 then
						nExAttrNumShow = nExAttrNumShow..iText.."+"..iValue.."#r"
					end
				end
			end
			--技能部分
			--WuHunAttrTable
			local nSkillType,nSkillValue = {},{}
			local nSkillSign,nSkillShow = "",""
			for i = 1,3 do
				nSkillType[i] = string.sub(nSkill, (i*2) - 1,(i*2) - 1)
				nSkillValue[i] = tonumber(string.sub(nSkill, i*2,i*2))
				nSkillSign = tostring(nSkillType[i]..nSkillValue[i]);
				if nSkillSign ~= "00" then
					nSkillShow = nSkillShow.."#{XYJ_KFS_SKILL_"..nSkillSign.."}".."#r"
				end
			end
			--属相
			local nMagicName = {"#{WH_xml_XX(56)}","#{WH_xml_XX(57)}","#{WH_xml_XX(58)}","#{WH_xml_XX(59)}"}
			if nMagic >= 1 and nMagic <= 4 then
				nMagic = "#H"..nMagicName[nMagic]
			else
				nMagic = ""
			end
			local nFinalShow = g_DWAttr..nGrow..nKfsBaseDataShow..nExLevel..nExAttrNumShow..nSkillShow
			local Temp1,Temp2 = string.find(szPropertys, "绑定#r")
			local Temp3,Temp4 = string.find(szPropertys, "刻铭#r")
			if Temp3 ~= nil then
				szPropertys = string.gsub(szPropertys, "刻铭#r", "刻铭#r"..nFinalShow);
			elseif Temp1 ~= nil then
				szPropertys = string.gsub(szPropertys, "绑定#r", "绑定#r"..nFinalShow);
			else
				szPropertys = "#r"..nFinalShow..szPropertys
			end
			--宝石评分 2019-10-19 19:33:09 逍遥子修正显示
			szPropertys = szPropertys
			if nMagic ~= nil then
				SuperTooltip_Property:SetText(szPropertys.."\n"..nMagic);
			else
				SuperTooltip_Property:SetText(szPropertys);
			end
			SuperTooltip_Explain:SetText(szExplain);
			return 1;
		end
	end
	if szAuthor ~= nil and string.find(typeDesc,"绑元票") ~= nil then
	    local nPos_1,nPos_2,nBindYuanBao = string.find(szAuthor,"&BINDYAUNBAO(.*)")
		if nPos_1 ~= nil and nPos_2 ~= nil then
		    szExplain = string.gsub(szExplain, "元宝。#r", "元宝。#r此面额为"..nBindYuanBao.."绑定元宝。#r");
		    SuperTooltip_Explain:SetText(szExplain);
		    return 1
		end
	end
	SuperTooltip_Explain:SetText(szExplain);
	return 1;
		
end
function LuaFnGetItemName(ItemID)
	return LifeAbility : GetPrescr_Material(ItemID)
end
function Lua_GetPetEquipZiZhiDesc(nPetEquipID,nData)
	local nBaseWG,nBaseNG,nBaseWF,nBaseNF,nBaseMiss,nSetAttr = Lua_EnumPetEquip(nPetEquipID)
	local nPos1,nPos2,nAdpt1,nAdpt2 = string.find(nData,"&PET(%w%w)(%w%w)");
	if nPos1 ~= nil and nPos2 ~= nil then
		nAdpt1 = tonumber(nAdpt1)
		nAdpt2 = tonumber(nAdpt2)
		local nAdptType_1,nAdptType_2 = "",""
		local nAdptAdd = 0
		if nBaseWF > 0 then
			nAdptType_1 = "#{GMItem_Equip_11}"
			nAdptType_2 = "#{GMItem_Equip_12}"
			nAdptAdd = nBaseWF
		elseif nBaseWG > 0 then
			nAdptType_1 = "#{GMItem_Equip_9}"
			nAdptType_2 = "#{GMItem_Equip_10}"
			nAdptAdd = nBaseWG
		elseif nBaseMiss > 0 then
			nAdptType_1 = "#{GMItem_Equip_14}"
			nAdptAdd = nBaseMiss
		end
		local nFinalAdpt = ""
		if nAdpt1 >= 20 and nAdpt2 >= 20 then
			nFinalAdpt = "#cFFCC00"..nAdptType_1.." #{GMItem_Equip_19} +"..nAdpt1.."% （+"..tostring(math.ceil(nAdptAdd * (nAdpt1/100))).."）\n"
			if nAdptType_2 ~= "" then
				nFinalAdpt = nFinalAdpt..nAdptType_2.." #{GMItem_Equip_19} +"..nAdpt2.."% （+"..tostring(math.ceil(nAdptAdd * (nAdpt2/100))).."）\n"
			end
		else
			local nAdpt1_Show,nAdpt2_Show = "",""
			--资质1
			if nAdpt1 >= 20 then
				nAdpt1_Show = "#{GMItem_Equip_19}"
			elseif nAdpt1 >= 2 and nAdpt1 <= 10 then
				nAdpt1_Show = "#{GMItem_Equip_22}"
			elseif nAdpt1 >= 11 and nAdpt1 <= 15 then
				nAdpt1_Show = "#{GMItem_Equip_21}"	
			elseif nAdpt1 >= 16 and nAdpt1 <= 19 then
				nAdpt1_Show = "#{GMItem_Equip_20}"	
			end
			--资质2
			if nAdpt2 >= 20 then
				nAdpt2_Show = "#{GMItem_Equip_19}"
			elseif nAdpt2 >= 2 and nAdpt2 <= 10 then
				nAdpt2_Show = "#{GMItem_Equip_22}"
			elseif nAdpt2 >= 11 and nAdpt2 <= 15 then
				nAdpt2_Show = "#{GMItem_Equip_21}"	
			elseif nAdpt2 >= 16 and nAdpt2 <= 19 then
				nAdpt2_Show = "#{GMItem_Equip_20}"	
			end
			nFinalAdpt = "#P"..nAdptType_1.." "..nAdpt1_Show.." +"..nAdpt1.."% （+"..tostring(math.ceil(nAdptAdd * (nAdpt1/100))).."）\n"
			if nAdptType_2 ~= nil and nBaseMiss <= 0 then
				nFinalAdpt = nFinalAdpt..nAdptType_2.." "..nAdpt2_Show.." +"..nAdpt2.."% （+"..tostring(math.ceil(nAdptAdd * (nAdpt2/100))).."）\n"
			end
		end
		return nFinalAdpt
	else
		return "#r#{GMItem_Equip_15}"
	end
end
function SuperTooltip_OnHide()
	g_left = 0;
	g_top  = 0;
	g_right = 0;
	g_bottom = 0;
	g_mCmpWndCount = 0;
	SuperTooltips:CloseCmpWindowMain()
	SuperTooltips:CloseCmpWindowSub()
end
-------------------------------------------------------------------------------------------------------------------------------
--
-- 清空显示文本
--
function SuperTooltip_ClearText()
		SuperTooltip_StaticPart_Title:SetText("");
		SuperTooltip_StaticPart_Item1:SetText("");
		SuperTooltip_StaticPart_Item2:SetText("");
		SuperTooltip_StaticPart_Item3:SetText("");
		SuperTooltip_StaticPart_Item4:SetText("");
		local starNum=9
		for i=1,starNum do
			g_Stars[i]:Hide();
		end;
		SuperTooltip_StaticPart_Gem1:SetImage("");
		SuperTooltip_StaticPart_Gem2:SetImage("");
		SuperTooltip_StaticPart_Gem3:SetImage("");
		SuperTooltip_StaticPart_Gem4:SetImage("");
		SuperTooltip_StaticPart_Gem1:Hide();
		SuperTooltip_StaticPart_Gem2:Hide()
		SuperTooltip_StaticPart_Gem3:Hide()
		SuperTooltip_StaticPart_Gem4:Hide()
		SuperTooltip_Explain:SetText("");
		SuperTooltip_Property:SetText("");
		SuperTooltip_Manufacturer:SetText("");
		SuperTooltip_StaticPart_Icon_Protected:Hide();
end

function SetupMoneyPart(type,nPrice)
	local StaticPart_GB_Ctl;
	local StaticPart_Money_Ctl;
		--使用什么作为货币
	local nUnit =  SuperTooltips:GetMoney1Type();
	if(type==1)then
		StaticPart_GB_Ctl = SuperTooltip_StaticPart_GB;
		local isShowJiaoZi = SuperTooltips:GetIsShowJiaoZi();
		if ( CU_MONEYJZ == nUnit ) then
			isShowJiaoZi = 1;
		end
		if (isShowJiaoZi == 1) then
			SuperTooltip_StaticPart_Money:Hide();
			StaticPart_Money_Ctl = SuperTooltip_StaticPart_Money_JiaoZi;
		else
			SuperTooltip_StaticPart_Money_JiaoZi:Hide()
			StaticPart_Money_Ctl = SuperTooltip_StaticPart_Money;
		end
	else
		StaticPart_GB_Ctl = SuperTooltip_StaticPart_GB_2;
		StaticPart_Money_Ctl = SuperTooltip_StaticPart_Money_2;
	end

	if(nUnit==nil)then
		nUnit = CU_MONEY;
	end;
	if(CU_MONEY	== nUnit or CU_TICKET == nUnit or CU_MONEYJZ == nUnit)       then      --钱，官票钱, 交子
			StaticPart_GB_Ctl:Hide()
			StaticPart_Money_Ctl:Show();
			StaticPart_Money_Ctl:SetProperty("MoneyNumber", tostring(nPrice));

	elseif(CU_GOODBAD == nUnit) then			--善恶值
			
			StaticPart_GB_Ctl:Show()
			StaticPart_Money_Ctl:Hide();
			StaticPart_GB_Ctl:SetText("善恶值:" .. tostring(nPrice) .. " 点")


	elseif(CU_MORALPOINT == nUnit)  then	--师德点

			StaticPart_GB_Ctl:Show()
			SuperTooltip_StaticPart_Money:Hide();
			StaticPart_GB_Ctl:SetText("师德点:" .. tostring(nPrice) .. " 点")

	elseif(CU_YUANBAO == nUnit) then	--元宝

			StaticPart_GB_Ctl:Show()
			StaticPart_Money_Ctl:Hide();
			StaticPart_GB_Ctl:SetText("元宝:" .. tostring(nPrice))

	elseif(CU_ZENGDIAN == nUnit) then	--赠点

			StaticPart_GB_Ctl:Show()
			StaticPart_Money_Ctl:Hide();
			StaticPart_GB_Ctl:SetText("绑定元宝:" .. tostring(nPrice))

	elseif(CU_MENPAI_POINT == nUnit) then	--师门贡献度

			StaticPart_GB_Ctl:Show()
			StaticPart_Money_Ctl:Hide();
			StaticPart_GB_Ctl:SetText("门派贡献度:" .. tostring(nPrice))

	end	
	
end;
--显示指定数量的星星
function SuperTooltip_ShowStar(starNum)
	for i=1,starNum do
		if starNum <=4 then
			g_Stars[i]:SetProperty("Animate", "Animate_StarNoFlash");
		else
			g_Stars[i]:SetProperty("Animate", "Animate_Star");
		end
		g_Stars[i]:Show();
	end;
	for i=starNum+1, 9 do
		g_Stars[i]:SetProperty("Animate", "Animate_StarDark");
		g_Stars[i]:Show();
	end
end
function Lua_GetSuperWeaponSX(nCreater,nEquipLevel)
	local nSuperWeaponSX_Show,nStarNum_SX = "",1
	local nSuperWeaponSX_ShowForUp = ""
	if nCreater ~= nil then
		local Pos1,Pos2,nTongLing,nQiHe,nIndex = string.find(nCreater,"&XSZL(%w)(%w%w)(%w%w)")
		if Pos1 ~= nil and Pos2 ~= nil then
			local nSQQiHe = tonumber(nQiHe)
			local nIndex = tonumber(nIndex)
			--契合度显示
			g_FitTitle:Hide()
			g_FitTxt:Hide()
			g_Fit9Title:Hide();
			g_Fit9Txt:Hide();
			if nIndex >= 61 and nSQQiHe > 0 then
				g_Fit9Txt:SetText("" .. nSQQiHe .. "/20")
				g_Fit9Title:Show();
				g_Fit9Txt:Show();
				g_FitTitle:Hide()
				g_FitTxt:Hide()
			elseif nIndex < 61 and nSQQiHe > 0 then
				g_FitTxt:SetText("" .. nSQQiHe .. "/9")
				g_FitTitle:Show();
				g_FitTxt:Show();
			end
			--诛仙万象部分
			local nSkillName = {"冰","火","玄","毒"}
			local nSkillName_Add_A = {500,600,740,920,1140,1410,1730,2100,2520,3000}
			local nSkillName_Add_B = {8,12,16,21,26,32,38,45,52,60} 
			local Pos3,Pos4,nType_1,nLevel_1,nType_2,nLevel_2,nType_3,nLevel_3 = string.find(nCreater,"&ZX(%w)(%w%w)(%w)(%w%w)(%w)(%w%w)")
			if Pos3 ~= nil and Pos4 ~= nil then
				nSuperWeaponSX_Show = nSuperWeaponSX_Show.."#{JXSQ_170811_177}#r"
				if tonumber(nLevel_1) == 0 then
					nSuperWeaponSX_Show = nSuperWeaponSX_Show.."#{JXSQ_170811_171}#r"
				elseif tonumber(nLevel_1) > 0 and tonumber(nType_1) == 0 then
					nSuperWeaponSX_Show = nSuperWeaponSX_Show.."#{JXSQ_170811_172}#r"
				else
					nSuperWeaponSX_Show = nSuperWeaponSX_Show.."#c1f941e命魂位（"..tonumber(nLevel_1).."级）："..nSkillName[tonumber(nType_1)].."攻击伤害增加"..nSkillName_Add_A[tonumber(nLevel_1)].."点#r"
				end
				if tonumber(nLevel_2) == 0 then
					nSuperWeaponSX_Show = nSuperWeaponSX_Show.."#{JXSQ_170811_174}#r"
				elseif tonumber(nLevel_2) > 0 and tonumber(nType_2) == 0 then
					nSuperWeaponSX_Show = nSuperWeaponSX_Show.."#{JXSQ_170811_172}#r"
				else
					nSuperWeaponSX_Show = nSuperWeaponSX_Show.."#c1f941e地魂位（"..tonumber(nLevel_2).."级）：减"..nSkillName[tonumber(nType_2)].."抗增加"..nSkillName_Add_B[tonumber(nLevel_2)].."点，持续5秒#r"
				end
				if tonumber(nLevel_3) == 0 then
					nSuperWeaponSX_Show = nSuperWeaponSX_Show.."#{JXSQ_170811_176}#r"
				elseif tonumber(nLevel_3) > 0 and tonumber(nType_3) == 0 then
					nSuperWeaponSX_Show = nSuperWeaponSX_Show.."#{JXSQ_170811_172}#r"
				else
					nSuperWeaponSX_Show = nSuperWeaponSX_Show.."#c1f941e天魂位（"..tonumber(nLevel_3).."级）：减"..nSkillName[tonumber(nType_3)].."抗下限增加"..tonumber(nLevel_3).."%，持续5秒#r"
				end
			end
		end
	end
	return nSuperWeaponSX_Show,nStarNum_SX,nSuperWeaponSX_ShowForUp
end
function Split(szFullString, szSeparator)
    local nFindStartIndex = 1
    local nSplitIndex = 1
    local nSplitArray = {}
    while true do
        local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)
		if not nFindLastIndex then
			nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))
			break
		end
		nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)
		nFindStartIndex = nFindLastIndex + string.len(szSeparator)
        nSplitIndex = nSplitIndex + 1
    end
    return nSplitArray
end