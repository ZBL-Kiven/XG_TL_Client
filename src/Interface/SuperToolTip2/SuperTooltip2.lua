
local g_PurpleColor = "#c9107e1";
local g_BlueColor   = "#c00ccff";
local g_YellowColor = "#cfeff95";
local g_GreenColor	= "#c5bc257";
local nGemNum = 0 --点缀数量

local g_NeedClickHide = 0;
local g_FirstShow = 1;
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
function SuperTooltip2_PreLoad()
	this:RegisterEvent("SHOW_SUPERTOOLTIP2");
end

function SuperTooltip2_OnLoad()
	SuperTooltip2_StaticPart_Money:SetClippedByParent(0);
		g_Stars={
				SuperTooltip2_StaticPart_Star1,
				SuperTooltip2_StaticPart_Star2,
				SuperTooltip2_StaticPart_Star3,
				SuperTooltip2_StaticPart_Star4,
				SuperTooltip2_StaticPart_Star5,
				SuperTooltip2_StaticPart_Star6,
				SuperTooltip2_StaticPart_Star7,
				SuperTooltip2_StaticPart_Star8,
				SuperTooltip2_StaticPart_Star9,
		};
	for i=1,9 do
		g_Stars[i]:Hide();
	end;
	--AxTrace(0, 2, "LoadSuperTooltips");
end										

function SuperTooltip2_OnEvent(event)

--	SuperTooltip2_StaticPart_Money:Hide();
	if(event == "SHOW_SUPERTOOLTIP2") then
		if( arg0 == "1" and SuperTooltips2:IsPresent()) then
			
			SuperTooltips2:SendAskItemInfoMsg();
			SuperTooltip2_Update();
			_SuperTooltip2_:PositionSelf(0, 0, 1, 1);
			local rH = _SuperTooltip2_:GetProperty("AbsoluteHeight");
			SuperTooltip2_Frame:SetProperty("AbsoluteHeight", tostring(rH+5.0));

			if(g_FirstShow == 1) then 
				SuperTooltip2_Frame:CenterWindow();
				g_FirstShow = 0;
			end
			
			this:Show();
			return;
		else
			this:Hide();
			return;
		end
	end
	
	this:Hide();	
end

function SuperTooltip2_Update()
		g_NeedClickHide = 0;
		-- 先清空以前显示的文字
		SuperTooltip2_ClearText();
		
		if(SuperTooltips2:IsTransferItem()) then
			g_NeedClickHide = 1;
		end
		
		local typeDesc = SuperTooltips2:GetTypeDesc();
		local nGemHoleCounts = SuperTooltips2:GetGemHoleCounts();
		local nMoney1, szMoneyDesc1 = SuperTooltips2:GetMoney1();
		local nMoney2, szMoneyDesc2 = SuperTooltips2:GetMoney2();
		local szPropertys = SuperTooltips2:GetPropertys();
		local szAuthor = SuperTooltips2:GetAuthorInfo();
		local szExplain = SuperTooltips2:GetExplain();
		local nYuanbaotrade = SuperTooltips2:GetYuanbaoTradeFlag();
		
		----------------------------------------------------------------------
		--显示静态头
		local toDisplay = "SuperTooltip2_PageHeader";
		
		--加上类型描述
		if( typeDesc ~= nil) then 
			toDisplay = toDisplay .. ";SuperTooltip2_ShortDesc";
		end
		
		--宝石部分
		if( type(nGemHoleCounts) == "number" and nGemHoleCounts>0 ) then 
			toDisplay = toDisplay .. ";SuperTooltip2_GemPart";
		end
		
		--元宝交易
		if (nYuanbaotrade == 1) then
			toDisplay = toDisplay .. ";SuperTooltip2_StaticPart_Yuanbaojiaoyi";
			SuperTooltip2_StaticPart_Yuanbaojiaoyi:SetText("#c00ff00元宝交易");
		end

		--金钱1
		if( nMoney1 ~= nil) then 
			toDisplay = toDisplay .. ";SuperTooltip2_MoneyPart";
		end

		--金钱2
		if(nMoney2 ~= nil) then 
			toDisplay = toDisplay .. ";SuperTooltip2_MoneyPart2";
		end

		--属性
		if(szPropertys ~= nil) then 
			toDisplay = toDisplay .. ";SuperTooltip2_Property";
		end
		--作者
	if typeDesc ~= "#cffcc99时装" and typeDesc ~= "#cffcc99幻饰武器" then
		if(szAuthor ~= nil ) then
			if typeDesc == nil then--and string.find(ItemTitle,"典籍·") ~= nil
				toDisplay = toDisplay .. ";SuperTooltip2_Manufacturer_Frame";
		    else
				if string.find(typeDesc,"武魂_") == nil  then
					toDisplay = toDisplay .. ";SuperTooltip2_Manufacturer_Frame";
				end
			end
		end
	end
		--详细解释
		toDisplay = toDisplay .. ";SuperTooltip2_Explain";

		--显示组件内容
		_SuperTooltip2_:SetProperty("PageElements", toDisplay);
		
		----------------------------------------------------------------------
		--显示新的内容
	
		SuperTooltip2_StaticPart_Title:SetText(SuperTooltips2:GetTitle());
		SuperTooltip2_StaticPart_Item1:SetText(SuperTooltips2:GetDesc1());
		SuperTooltip2_StaticPart_Item2:SetText(SuperTooltips2:GetDesc2());
		SuperTooltip2_StaticPart_Item3:SetText(SuperTooltips2:GetDesc3());
		--SuperTooltip2_StaticPart_Item4:SetText(SuperTooltips2:GetDesc4());
		local StrongLevel	=SuperTooltips2:GetDesc4();
		local IsProtectd	=SuperTooltips2:GetDesc5();
		if(StrongLevel~="" and tonumber(StrongLevel)>0) then
			
			SuperTooltip2_StaticPart_Item4:SetText("#c0FFFFF强化: +"..SuperTooltips2:GetDesc4());
		end;
		--SuperTooltip2_StaticPart_Item5:SetText(SuperTooltips:GetDesc5());
		SuperTooltip2_StaticPart_Icon:SetImage(SuperTooltips2:GetIconName());
		SuperTooltip2_ShortDesc_Text:SetText(typeDesc);

	-- 显示雕纹
	local  _,dwIcon,dwIconEx = Lua_GetDWShowMsg(szAuthor)--&DW()      
	if (dwIcon ~= "" and dwIcon ~= nil ) then
		SuperTooltip2_StaticPart_DW:Show()
		SuperTooltip2_StaticPart_DW:SetProperty("Image", dwIcon)
	else
		SuperTooltip2_StaticPart_DW:Hide()
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
			SuperTooltip2_StaticPart_DW:Show()
			SuperTooltip2_StaticPart_DW:SetProperty("Image", dwIcon)
		else
			SuperTooltip2_StaticPart_DW:Hide()
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
		--tongxi modify 显示星星		
		local qual =SuperTooltips2:GetEquipQual();
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
			SuperTooltip2_StaticPart_Icon_Protected:Show();
		end;
		--modify end
		
		if( type(nGemHoleCounts) == "number" and nGemHoleCounts>0) then
			if(nGemHoleCounts > 0) then 
				SuperTooltip2_StaticPart_Gem1:Show();
			end
			
			if(nGemHoleCounts > 1) then 
				SuperTooltip2_StaticPart_Gem2:Show();
			end
			
			if(nGemHoleCounts > 2) then 
				SuperTooltip2_StaticPart_Gem3:Show();
			end
		
			if(nGemHoleCounts > 3) then 
				SuperTooltip2_StaticPart_Gem4:Show();
			end
			
			local gemIcon = SuperTooltips2:GetGemIcon1();
			if(gemIcon ~= "") then
				SuperTooltip2_StaticPart_Gem1:SetImage(gemIcon);
			end
			
			gemIcon = SuperTooltips2:GetGemIcon2();
			if(gemIcon ~= "") then
				SuperTooltip2_StaticPart_Gem2:SetImage(gemIcon);
			end
			
			gemIcon = SuperTooltips2:GetGemIcon3();
			if(gemIcon ~= "") then
				SuperTooltip2_StaticPart_Gem3:SetImage(gemIcon);
			end
			
			gemIcon = SuperTooltips2:GetGemIcon4();
			if(gemIcon ~= "") then
				SuperTooltip2_StaticPart_Gem4:SetImage(gemIcon);
			end
			
		end
	if typeDesc ~= "#cffcc99时装" then --点缀特殊显示
		local gemIcon = SuperTooltips:GetGemIcon1();
		if(gemIcon ~= "") then
			SuperTooltip2_StaticPart_Gem1:SetProperty("ShortImage", gemIcon);
		end
		gemIcon = SuperTooltips:GetGemIcon2();
		if(gemIcon ~= "") then
			SuperTooltip2_StaticPart_Gem2:SetProperty("ShortImage", gemIcon);
		end
		gemIcon = SuperTooltips:GetGemIcon3();
		if(gemIcon ~= "") then
			SuperTooltip2_StaticPart_Gem3:SetProperty("ShortImage", gemIcon);
		end
		gemIcon = SuperTooltips:GetGemIcon4();			
		if(gemIcon ~= "") then
			SuperTooltip2_StaticPart_Gem4:SetProperty("ShortImage", gemIcon);
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
			if GemInfo[1] ~= nil and Gem_Cloth_Icon[tonumber(GemInfo[1])] ~= nil then
				SuperTooltip2_StaticPart_Gem1:SetProperty("ShortImage", Gem_Cloth_Icon[tonumber(GemInfo[1])]);
			end
			if GemInfo[2] ~= nil and Gem_Cloth_Icon[tonumber(GemInfo[2])] ~= nil then
				SuperTooltip2_StaticPart_Gem2:SetProperty("ShortImage", Gem_Cloth_Icon[tonumber(GemInfo[2])]);
			end
			if GemInfo[3] ~= nil and Gem_Cloth_Icon[tonumber(GemInfo[3])] ~= nil then
				SuperTooltip2_StaticPart_Gem3:SetProperty("ShortImage", Gem_Cloth_Icon[tonumber(GemInfo[3])]);
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
						SuperTooltip2_Property:SetText(szPropertys.."#{MYJS_120723_25}\n"..sweetWords..spaceStr..nCreator_JS );
					else
						SuperTooltip2_Property:SetText("#{MYJS_120723_25}\n"..sweetWords..spaceStr..nCreator_JS );
					end
				end                
			end
		end
	end		
		if(nMoney1 ~= nil)  then
			SuperTooltip2_StaticPart_Money_Text:SetText(szMoneyDesc1);
			SuperTooltip2_StaticPart_Money:SetProperty("MoneyNumber", tostring(nMoney1));
		end
		
		if(nMoney2 ~= nil)  then
			SuperTooltip2_StaticPart_Money_Text_2:SetText(szMoneyDesc2);
			SuperTooltip2_StaticPart_Money_2:SetProperty("MoneyNumber", tostring(nMoney2));
		end
		
		if( szPropertys ~= nil) then
			SuperTooltip2_Property:SetText(szPropertys);
		end
		
	if( szAuthor ~= nil) then
    		local agname = string.find(szAuthor, "&")		--Q546528533新增	
			if agname ~= nil then
			local mytypeDesc = string.sub(szAuthor,1,agname-1)
			SuperTooltip2_Manufacturer:SetText(mytypeDesc);
			SuperTooltip2_Manufacturer_Frame:Show()
			else
			SuperTooltip2_Manufacturer:SetText(szAuthor);
			end	
     end
	--===重楼套装显示（现行测试版） Q546528533 同步
	if typeDesc ~= nil and string.find(SuperTooltips2:GetTitle(),"重楼") ~= nil then
	    if string.find(typeDesc,"戒指") ~= nil or string.find(typeDesc,"项链") ~= nil or string.find(typeDesc,"护符") ~= nil then
		    if string.find(SuperTooltips2:GetTitle(),"真·") ~= nil then
				local _,_,EquipSetNum = string.find(szPropertys,"（(%w)/3）")			
				if tonumber(EquipSetNum)== 2 then
					szPropertys = string.gsub(szPropertys,"{equip_attr_restorehp}%s%p1","免疫控制几率 +10%%")
		    	elseif tonumber(EquipSetNum) == 3 then
				    szPropertys = string.gsub(szPropertys,"{equip_attr_restorehp}%s%p1","免疫控制几率 +10%%")
				    szPropertys = string.gsub(szPropertys,"{equip_attr_restorehp}%s%p2","免疫控制几率 +10%%")
				end			
				SuperTooltip2_Property:SetText(szPropertys);
				SuperTooltip2_Explain:SetText(szExplain);
				return 1
			end			
		end		
	    if string.find(typeDesc,"戒指") ~= nil or string.find(typeDesc,"项链") ~= nil or string.find(typeDesc,"护符") ~= nil then
		    if string.find(SuperTooltips2:GetTitle(),"真·") == nil then
				local _,_,EquipSetNum = string.find(szPropertys,"（(%w)/3）")			
				if tonumber(EquipSetNum)== 2 then
					szPropertys = string.gsub(szPropertys,"{equip_attr_restorehp}%s%p1","免疫控制几率 +5%%")
		    	elseif tonumber(EquipSetNum) == 3 then
				    szPropertys = string.gsub(szPropertys,"{equip_attr_restorehp}%s%p1","免疫控制几率 +5%%")
				    szPropertys = string.gsub(szPropertys,"{equip_attr_restorehp}%s%p2","免疫控制几率 +5%%")
				end			
				SuperTooltip2_Property:SetText(szPropertys);
				SuperTooltip2_Explain:SetText(szExplain);
				return 1
			end		
		end			    
		if string.find(typeDesc,"鞋") ~= nil or string.find(typeDesc,"帽") ~= nil or string.find(typeDesc,"手") ~= nil or string.find(typeDesc,"腰") ~= nil or string.find(typeDesc,"腕") ~= nil then
		    if string.find(SuperTooltips2:GetTitle(),"真·") ~= nil then
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
				SuperTooltip2_Property:SetText(szPropertys);
				SuperTooltip2_Explain:SetText(szExplain);
				return 1
			end			
		end			
		if string.find(typeDesc,"鞋") ~= nil or string.find(typeDesc,"帽") ~= nil or string.find(typeDesc,"手") ~= nil or string.find(typeDesc,"腰") ~= nil or string.find(typeDesc,"腕") ~= nil then
		    if string.find(SuperTooltips2:GetTitle(),"真·") == nil then
				local _,_,EquipSetNum = string.find(szPropertys,"（(%w)/5）")			
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
				SuperTooltip2_Property:SetText(szPropertys);
				SuperTooltip2_Explain:SetText(szExplain);
				return 1
			end		
		end			
	end
	--珍兽装备
	if typeDesc ~= nil and typeDesc ~= "" and string.find(typeDesc,"PET") ~= nil then
		--以下颜色数据如有异议可至D:\TLBB\ML_365\Prj\GameCode\Client\Game\Item\GMItem_PetEquip.cpp查看
		SuperTooltip2_StaticPart_Item1:SetText("");
		SuperTooltip2_StaticPart_Item2:SetText("");
		SuperTooltip2_StaticPart_Item3:SetText("");
		local tPetEquipData = Split(typeDesc,"|");
		if tPetEquipData ~= nil then
			local isOnEquip = 0;
			if string.find(typeDesc,"PETON") ~= nil then
				isOnEquip = 1;
			end
			local nLevel = SuperTooltips2:GetDesc3();
			if nLevel ~= nil and nLevel ~= "" and string.find(nLevel,":") ~= nil then
				local nLevelTemp = Split(nLevel,":");
				local nLevel = tonumber(nLevelTemp[2])
				SuperTooltip2_StaticPart_Item1:SetText("#cC8B88E等级: "..nLevel);
			end
			SuperTooltip2_ShortDesc_Text:SetText("#cC8B88E"..tPetEquipData[2]); --显示类型
			local nPetEquipID = tonumber(tPetEquipData[3])
			local nEquipQual = tonumber(tPetEquipData[4])
			local nEquipPoint = math.mod(math.floor(nPetEquipID/1000),10)
			SuperTooltip2_ShowStar(nEquipQual)
			if nEquipQual < 6 then
				SuperTooltip2_StaticPart_Item2:SetText("#{ZSZBSJ_090706_18}");
				SuperTooltip2_StaticPart_Item3:SetText("#{ZSZBSJ_090706_17}");
		    else
				SuperTooltip2_StaticPart_Item2:SetText("#{ZSZBSJ_090706_18}");
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
			local nAttrName,nStr,nAttrType_1,nAttr_1,nAttrType_2,nAttr_2,nAttrType_3,nAttr_3 = Lua_EnumPetEquipAttr(nSetAttr)
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
			if isOnEquip == 0 then
				nZiZhiQiHe = "#cFFCC99#{ZSZB_0710_08}\n"
			else
				--查看已装备的
				nZiZhiQiHe = "#{ZSZB_0710_03}2.5%\n"
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
            SuperTooltip2_Property:SetText(szPropertys);
		end
	end	
	--*************************************************武魂系统*************************************************
	if( szPropertys ~= nil) then	
		local wunhPos1,wunhsxPos1 = string.find(typeDesc, "武魂")
		if  wunhPos1 ~= nil and  wunhsxPos1 ~= nil then
			local nGrow,nExLevel,nLevel,nExp,nMagic,nExAttrNum,nExAttr,nSkill = LuaGetKfsAttrData(szAuthor)
			local nFixnGrow = 500
			--头部显示
			SuperTooltip2_StaticPart_Item1:SetText("#cC8B88E携带等级:65");
			SuperTooltip2_StaticPart_Item2:SetText("#cC8B88E等级:"..tonumber(nLevel));
			--武魂类型
			local nAttactType = 0
			if string.find(typeDesc,"武魂_0") ~= nil then
				SuperTooltip2_StaticPart_Item3:SetText("#{WH_xml_XX(100)}");
			else
				SuperTooltip2_StaticPart_Item3:SetText("#{WH_xml_XX(101)}");
				nAttactType = 1;
			end			
			SuperTooltip2_ShortDesc_Text:SetText("#cffcc99武魂");
			local Life = LifeAbility:Get_UserEquip_Current_Durability(10);
			local maxLife = LifeAbility:Get_UserEquip_Maximum_Durability(10);
			if maxLife ~= -1 and Life  ~= -1 then
				SuperTooltip2_StaticPart_Item4:SetText("#cC8B88E寿命："..tostring(Life).."/"..tostring(maxLife));
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
				SuperTooltip2_Property:SetText(szPropertys.."\n"..nMagic);
			else
				SuperTooltip2_Property:SetText(szPropertys);
			end
			SuperTooltip2_Explain:SetText(szExplain);
			return 1;
		end
	end
 	if szAuthor ~= nil and string.find(typeDesc,"绑元票") ~= nil then
	    local nPos_1,nPos_2,nBindYuanBao = string.find(szAuthor,"&BINDYAUNBAO(.*)")
		if nPos_1 ~= nil and nPos_2 ~= nil then
		    szExplain = string.gsub(szExplain, "元宝。#r", "元宝。#r此面额为"..nBindYuanBao.."绑定元宝。#r");
		    SuperTooltip2_Explain:SetText(szExplain);
		    return 1
		end
	end   	
	SuperTooltip2_Explain:SetText(szExplain);
		
end
--显示指定数量的星星
function SuperTooltip2_ShowStar(starNum)
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

-------------------------------------------------------------------------------------------------------------------------------
--
-- 清空显示文本
--
function SuperTooltip2_ClearText()
		SuperTooltip2_StaticPart_Title:SetText("");
		SuperTooltip2_StaticPart_Item1:SetText("");
		SuperTooltip2_StaticPart_Item2:SetText("");
		SuperTooltip2_StaticPart_Item3:SetText("");
		SuperTooltip2_StaticPart_Item4:SetText("");
		SuperTooltip2_StaticPart_Gem1:SetImage("");
		SuperTooltip2_StaticPart_Gem2:SetImage("");
		SuperTooltip2_StaticPart_Gem3:SetImage("");
		SuperTooltip2_StaticPart_Gem4:SetImage("");
		SuperTooltip2_StaticPart_Gem1:Hide()
		SuperTooltip2_StaticPart_Gem2:Hide();
		SuperTooltip2_StaticPart_Gem3:Hide();
		SuperTooltip2_StaticPart_Gem4:Hide();
		
		SuperTooltip2_Explain:SetText("");
		SuperTooltip2_Property:SetText("");
		SuperTooltip2_Manufacturer:SetText("");
		SuperTooltip2_StaticPart_Icon_Protected:Hide();
		local starNum=9
		for i=1,starNum do
			g_Stars[i]:Hide();
		end;
end

function SuperTooltip2_LClick()
	if( 1 == g_NeedClickHide and this:IsVisible()) then
		g_NeedClickHide = 0;
		this:Hide();
	end
end