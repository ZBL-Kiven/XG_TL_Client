local CU_MONEY			= 1	-- Ǯ
local CU_GOODBAD		= 2	-- �ƶ�ֵ
local CU_MORALPOINT	= 3	-- ʦ�µ�
local CU_TICKET			= 4 -- ��ƱǮ
local CU_YUANBAO		= 5	-- Ԫ��
local CU_ZENGDIAN		= 6 -- ����
local CU_MENPAI_POINT	= 7 -- ʦ�Ź��׶�
local CU_MONEYJZ		= 8 -- ����
local nGemNum = 0 --��׺����

local g_pos1;
local g_pos2;
local g_PurpleColor = "#c9107e1";
local g_BlueColor   = "#c00ccff";
local g_YellowColor = "#cfeff95";
local g_GreenColor	= "#c5bc257";
local g_Stars;		
local g_IsNoStringTip = {"���","ʱװ"}
g_nUnlockingTimeNeeded = 259200;
local WuHunMagic_Tips = {"#{WH_090817_04}" , "#{WH_xml_XX(56)}","#{WH_xml_XX(57)}","#{WH_xml_XX(58)}","#{WH_xml_XX(59)}"}
xSrtong = {
[0] = { Tooltip = "��������" },
[1] = { Tooltip = "����" },
[2] = { Tooltip = "������" },
[3] = { Tooltip = "˫����" },
[4] = { Tooltip = "������" },
[5] = { Tooltip = "ǹ����" },
[6] = { Tooltip = "����" },
[7] = { Tooltip = "����" },
[8] = { Tooltip = "������" },
[9] = { Tooltip = "����" },
[10] = { Tooltip = "����" },
[11] = { Tooltip = "��ָ" },
[12] = { Tooltip = "����" },
[13] = { Tooltip = "����" },
[14] = { Tooltip = "����" },
[15] = { Tooltip = "���" },
[16] = { Tooltip = "����" },
[17] = { Tooltip = "Ь" },
[18] = { Tooltip = "ñ��" },
[19] = { Tooltip = "����" },
[20] = { Tooltip = "�·�" },
[21] = { Tooltip = "����" },
[22] = { Tooltip = "����ӡ" },
}
local g_EffectDic = {
	"�ڹ�����",	--�ڹ�����
	"�⹦����",	--�⹦����
	"������",	--������
	"������",	--������
	"������",	--������
	"������",	--������
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
		strLeftTime = "�����ɹ��������µ�¼���л�������ʽ������";
	else
		nLeftTime = math.ceil( nLeftTime/3600 );
		if( nLeftTime >= 24 ) then
			strLeftTime = ""..math.floor(nLeftTime/24).." ��";
			nLeftTime = math.mod(nLeftTime,24);
		end
		if( nLeftTime > 0 ) then 
			strLeftTime = strLeftTime.." "..nLeftTime.." Сʱ";					
		end
		
		strLeftTime = strLeftTime.."����ʽ����";
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
		-- �������ǰ��ʾ������
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
	--��ʾ��̬ͷ
	local toDisplay = "";
	
	if(SuperTooltips:GetTitle()~="" and SuperTooltips:GetIconName()~="")then
		toDisplay = toDisplay .."SuperTooltip_PageHeader";
	end
	
	--ʣ�����ʱ��
	if( IsProtectd == "1" and unLockingElapsedTime ~= 0) then
		toDisplay = toDisplay .. ";SuperTooltip_UnlockingTimePart";
	end
		
		
	--������������
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
	--Ԫ������
	if (nYuanbaotrade == 1) then
		toDisplay = toDisplay .. ";SuperTooltip_StaticPart_Yuanbaojiaoyi";
		SuperTooltip_StaticPart_Yuanbaojiaoyi:SetText("#c00ff00Ԫ������");
	end
	--����tip
	if IsWindowShow("NewExterior_DressBox") and typeDesc == "#cffcc99ʱװ"  then
		szPropertys = string.gsub(szPropertys, "װ��ʱ��", "�Ѱ�");
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
	--��ʯ����
	if( type(nGemHoleCounts) == "number" and nGemHoleCounts>0 ) then 
		toDisplay = toDisplay .. ";SuperTooltip_GemPart";
	end
	--��Ǯ1
	if( nMoney1 ~= nil) then 
		toDisplay = toDisplay .. ";SuperTooltip_MoneyPart";
	end

	--��Ǯ2
	if(nMoney2 ~= nil) then 
		toDisplay = toDisplay .. ";SuperTooltip_MoneyPart_2";
	end
	--�߼�����
	local nGoodsProtect = 1
	local nXingZhenSkill_1,nXingZhenSkill_2 = nil,nil
	local nKSFWG_1,nKSFWG_2 = nil,nil
	local nXiuLian_1,nXiuLian_2 = nil,nil
	local TALENT,TALENT2,id = nil,nil,0
	if typeDesc ~= nil then
		nXingZhenSkill_1,nXingZhenSkill_2 = string.find(typeDesc,"�ؼ�")
		nKSFWG_1,nKSFWG_2 = string.find(typeDesc,"KFSWG_")
		nXiuLian_1,nXiuLian_2 = string.find(typeDesc,"XL_BOOK")
		nXiuLian_1,nXiuLian_2 = string.find(typeDesc,"XL_BOOK")
		TALENT,TALENT2,id = string.find(typeDesc,"TALENT_(%w%w%w)")
	end
	--ԭ�Ȳ����ڵĲ���
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
	--����
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
	--����
	if typeDesc ~= "#cffcc99ʱװ" and typeDesc ~= "#cffcc99��������" then
	if(szAuthor ~= nil ) then
			if typeDesc == nil then--and string.find(ItemTitle,"�伮��") ~= nil
				toDisplay = toDisplay .. ";SuperTooltip_Manufacturer_Frame";
			else
				if string.find(typeDesc,"PET|") == nil and string.find(typeDesc,"���_") == nil  then
					toDisplay = toDisplay .. ";SuperTooltip_Manufacturer_Frame";
				end
			end
		end
	end
	--��ϸ����
	local nEquiMasterText = ""
	local nBaiShouLevelText = ""
		toDisplay = toDisplay .. ";SuperTooltip_Explain";

	--��ʾ�������
	if(toDisplay=="") then
		this:Hide();
		return 0;
	end;
	AxTrace( 8,0,toDisplay );
	_SuperTooltip_:SetProperty("PageElements",  toDisplay);
	--��ȡ��Ʒ�ȼ�
	local nItemLevel = 1
	local nLevelData = SuperTooltips:GetDesc1()
	local nLevelPos1,nLevelPos2 = string.find(nLevelData,"�ȼ�:")
	if nLevelPos1 ~= nil and nLevelPos2 ~= nil then
		LEVEL_SPLIT_DATA = Split(nLevelData,":")
		local nLevelPos3,nLevelPos4 = string.find(nLevelData,"/����")
		if nLevelPos3 ~= nil and nLevelPos4 ~= nil then --��������
			LEVEL_SPLIT_DATA_FIX = Split(LEVEL_SPLIT_DATA[2],"/")
			LEVEL_SPLIT_DATA[2] = LEVEL_SPLIT_DATA_FIX[1]
		end
		nItemLevel = tonumber(LEVEL_SPLIT_DATA[2])
	end		
		----------------------------------------------------------------------
		--��ʾ�µ�����
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
	--�ٱ���ͨ
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
		nEquiMasterText = string.format("#c00ccffЯ���ȼ�����%d���ٱ���ͨ��",nNeedLevel)
	end		
		local StrongLevel	=SuperTooltips:GetDesc4();
	--*************************************************��ʾ����*************************************************
	local  _,dwIcon,dwIconEx = Lua_GetDWShowMsg(szAuthor)--&DW()      
	if (dwIcon ~= "" and dwIcon ~= nil ) then
		SuperTooltip_StaticPart_DW:Show()
		SuperTooltip_StaticPart_DW:SetProperty("Image", dwIcon)
	else
		SuperTooltip_StaticPart_DW:Hide()
	end	
	if( szPropertys ~= nil and typeDesc ~= nil ) then--��������			
		local  dwdesc = Lua_GetDWShowMsg(szAuthor) --diaowen
		--��������д 2019-11-3 16:05:46 ��ң��
		g_DWAttr = dwdesc
		local wunhPos1,wunhsxPos1 = string.find(typeDesc, "���")
		if wunhPos1 == nil and  wunhsxPos1 == nil and dwdesc ~= "" and dwdesc ~=nil  then
			local tmp1,tmp2 = string.find(szPropertys, "��#r")
			local tmp3,tmp4 = string.find(szPropertys, "����#r")				
			if tmp3 ~= nil then
				szPropertys = string.gsub(szPropertys, "����#r", "����#r"..dwdesc);
			elseif tmp1 ~= nil then
				szPropertys = string.gsub(szPropertys, "��#r", "��#r"..dwdesc);
			else
				szPropertys = dwdesc..szPropertys
			end
		end
	end	
	--������ʾ
	if( szPropertys ~= nil) and string.find(typeDesc, "����") ~= nil then
		--��������
		local  _,dwIcon,dwIconEx = Lua_GetDWShowMsgEx()--&DW()      
		if (dwIcon ~= "" and dwIcon ~= nil ) then
			SuperTooltip_StaticPart_DW:Show()
			SuperTooltip_StaticPart_DW:SetProperty("Image", dwIcon)
		else
			SuperTooltip_StaticPart_DW:Hide()
		end
		if( szPropertys ~= nil) then--��������			
			local  dwdesc = Lua_GetDWShowMsgEx()
			if dwdesc ~= "" and dwdesc ~=nil  then
				local tmp1,tmp2 = string.find(szPropertys, "��#r")
				local tmp3,tmp4 = string.find(szPropertys, "����#r")				
				if tmp3 ~= nil then
					szPropertys = string.gsub(szPropertys, "����#r", "����#r"..dwdesc);
				elseif tmp1 ~= nil then
					szPropertys = string.gsub(szPropertys, "��#r", "��#r"..dwdesc);
				else
				szPropertys = dwdesc..szPropertys
				end		
			end
		end
	end 	
		if(StrongLevel~="" and tonumber(StrongLevel)>0) then
			
			SuperTooltip_StaticPart_Item4:SetText("#c0FFFFFǿ��: +"..SuperTooltips:GetDesc4());
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
		--tongxi modify ��ʾ����
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
	--*************************************************�ٱ���ͨ*************************************************
	if nEquipMasterFlag == 1 then
		SuperTooltip_BaiBingJingTong_Text:SetText(nEquiMasterText)
	else
		SuperTooltip_BaiBingJingTong_Text:SetText("")
	end
	--*************************************************�ٱ���ͨ*************************************************		
	--*************************************************���޾�ͨ*************************************************
	local nIsBaiShou = 0
	if nIsBaiShou == 1 then
		SuperTooltip_BaishouJingTong_Text : SetText(nBaiShouLevelText)
	else
		SuperTooltip_BaishouJingTong_Text : SetText("")
	end
	--*************************************************���޾�ͨ*************************************************
	if typeDesc ~= "#cffcc99ʱװ" then --��׺������ʾ
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
	if(typeDesc == "#cffcc99ʱװ" and szAuthor ~= nil) then
		--ʱװȾɫ
		local nPos1,nPos2,nColorId = string.find(szAuthor,"&CO(%w%w%w%w)")
		if nPos1 ~= nil and nPos2 ~= nil then
			local nColorID,nColorName = Lua_GetDressColor(tonumber(nColorId))
			if nColorID ~= -1 and nColorName ~= "" then
				szExplain = szExplain.."#r"..nColorName
			end
		end
		--�����˿
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
							szExplain = szExplain.."#r#Y���Ч��#r#W"..infodesc.szLevelDesc[nLevel]
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
			--����Ԥ�����棬Ԥ��ֱ��5������
			if IsWindowShow("Talent_Preview") then
				SectLevel = 5
				-- szPropertys				
			end
			--�������
			SuperTooltip_StaticPart_Item1:SetText("#W������磺���һ��")
			--����ȼ�
			SuperTooltip_StaticPart_Item2:SetText(string.format("#W����ȼ���%s/5",SectLevel))
			SuperTooltip_StaticPart_Item3:SetText("")
			local infodesc = TBSearch_Index_EQU("DBC_SECT_DESC",tonumber(id))
			--�������
			if infodesc.szJingjie ~= nil then
				SuperTooltip_StaticPart_Item1:SetText("#W������磺���"..infodesc.szJingjie.."��")
			end
			if infodesc.szLevelDesc[SectLevel] == nil and SectLevel == 0 and Sect ~= 1 then
				szExplain = "1��Ч����������Ч��#r"..infodesc.szLevelDesc[1]
			elseif SectLevel > 0 and SectLevel < 5 and Sect ~= 1 then
				szPropertys = string.format("��ǰ�ȼ�Ч������%s����#r",SectLevel)..infodesc.szLevelDesc[SectLevel]
				szExplain = string.format("��һ�ȼ�Ч������%s����#r",SectLevel+1)..infodesc.szLevelDesc[SectLevel+1]
			elseif Sect ~= 1 then
				szExplain = string.format("��ǰ����Ч������%s����#r",5)..infodesc.szLevelDesc[5]				
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
			--��ϸ����
			local ItemBind = string.find(szPropertys,"��")
			if ItemBind == nil then	--��
				szPropertys = "#cccffffװ��ʱ��\n"	
			end
			if g_NewAuthorInfo ~= "" then
				szPropertys = "#cccffff�Ѱ�\n"	
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
			SuperTooltip_StaticPart_Item1:SetText("#cc8b88e�ȼ���"..nLevel);
			SuperTooltip_StaticPart_Item2:SetText("#cc8b88e�꾳�׼���"..nPinJie);
			SuperTooltip_StaticPart_Item3:SetText("#cc8b88e����ֵ��"..nHunYi.."/"..nMaxExpTable[nPsQual+1][nPinJie]);
			--�������Բ���
			local nAttrper = {"#cFAFFA4�������ʣ�+%s","#cFAFFA4�������ʣ�+%s","#cFAFFA4�������ʣ�+%s","#cFAFFA4�������ʣ�+%s","#cFAFFA4�����ʣ�+%s"}
			local GetPetSoulPer = LuaFnGetPetSoulLevelupInfo(nLevel,Soul)
			for i = 1,5 do
				szPropertys = szPropertys..string.format(nAttrper[i],string.format("%.2f", GetPetSoulPer[i]/100)).."%".."\n"
			end
			--��չ��������
			local nMaxSolt = 4
			if nPsQual == 2 then
				nMaxSolt = 6
			elseif nPsQual == 1 then
				nMaxSolt = 5
			end
			szPropertys = szPropertys..string.format("#cFFCC99��չ����������%s/%s",nSolt,nMaxSolt).."\n"
			--�������Լӳ�
			local BaseAttr = LuaFnGetPetSoulBase(nAttrInfo,3,nSolt,nMaxSolt)
			szPropertys = szPropertys.."#{SHXT_20211230_230}".."\n"..BaseAttr
			--�ڻ�����
			szPropertys = szPropertys.."#{SHXT_20211230_231}".."\n".."#{SHXT_20211230_232}".."\n"
			--��ս����
			local FightDes,FigthName1,FigthName2 = LuaFnGetPetSoulSkill(Soul,nPinJie)
			szPropertys = szPropertys.."#c009933#{SHXT_20211230_190}".."\n".."#{JIZHI_"..FightDes.."}".."\n#{SHXT_20211230_191}\n"..FigthName1.."\n"..FigthName2
			SuperTooltip_Property:SetText(szPropertys);
			SuperTooltip_ShortDesc_Text:SetText(typeDesc);
			SuperTooltip_Explain:SetText(szExplain);
			return 1
		end
	end
	--Q546528533�޻���д
	if nXinfaId ~= nil then
		if nXinfaId >= 765 and nXinfaId <= 854 then
			local strName = Player:GetSkillInfo(nXinfaId,"explain");
			SuperTooltip_Explain:SetText(strName);
			return 1
		end
	end	
	if( szAuthor ~= nil) then
    	local agname = string.find(szAuthor, "&")		--Q546528533����	
		if agname ~= nil then
			local mytypeDesc = string.sub(szAuthor,1,agname-1)
			SuperTooltip_Manufacturer:SetText(mytypeDesc);
			SuperTooltip_Manufacturer_Frame:Show()
		else
			SuperTooltip_Manufacturer:SetText(szAuthor);
		end	
     end		
	--/////////////////////////����ϵͳ��ʾ{��Ⱥ��������}
	if typeDesc ~= nil then
		local Pos1_XL,Pos2_XL = string.find(typeDesc, "XL_BOOK")
		if Pos1_XL ~= nil and Pos2_XL ~= nil then
			XiuLianBookData = Split(typeDesc,"_")
			local Book_code = XiuLianBookData[3] --��ֵ����
			local nLevel_JingJie = GetXiuLianBookInfo(tonumber(Book_code - 1),"Level")
			SuperTooltip_StaticPart_Item1:SetText("#{XL_XML_29}");
			SuperTooltip_StaticPart_Item2:SetText(string.format("#cfff263��%d��",nLevel_JingJie));
			SuperTooltip_StaticPart_Item3:SetText("");
			typeDesc = ""
		end
		local Pos3_XL,Pos4_XL = string.find(typeDesc, "XL_MIJI")
		if Pos3_XL ~= nil and Pos4_XL ~= nil then
			MijiBookData = Split(typeDesc,"_")
			local MIJI_code = tonumber(MijiBookData[3])--��ֵ����
			if MIJI_code < 12 then
				local MIJI_StrCode = {}
				local MIJI_Add = GetXiuLianMiJiInfo(MIJI_code - 1,"XYJ_MIJI_ADD")
				local MIJI_Add_Next = GetXiuLianMiJiInfo(MIJI_code - 1,"XYJ_MIJI_NEXT_ADD")
				local MIJI_Add_Fina = GetXiuLianMiJiInfo(MIJI_code - 1,"XYJ_MIJI_FIN_ADD")
				local MIJI_Name = {"����","����","����","����","��","�⹦����","�ڹ�����","�⹦����","�ڹ�����","����","����"}
				MIJI_StrCode[1] = "#W����"..MIJI_Name[MIJI_code].."������#H"..MIJI_Add.."%"
				MIJI_StrCode[2] = "#W����"..MIJI_Name[MIJI_code].."������#H"..MIJI_Add_Fina.."%"
				MIJI_StrCode[3] = "#W����"..MIJI_Name[MIJI_code].."������#H"..MIJI_Add_Next.."%"
				szExplain = "#W��ǰ�ȼ�Ч����\n"..MIJI_StrCode[1].."\n \n".."#W���ķ�������ȼ�Ӱ���Ч����".."\n"..MIJI_StrCode[2].."\n \n".."#W��һ�ȼ�Ч����\n"..MIJI_StrCode[3].."\n \n".."#W"..szExplain
			end
			local nMijiLevel = GetXiuLianMiJiInfo(MIJI_code - 1,"Level")
			local nMijiLevelMax = GetXiuLianMiJiInfo(MIJI_code - 1,"MaxLevel")
			local nMiJi_JingJie = GetXiuLianMiJiInfo(MIJI_code - 1,"JingJie")
			SuperTooltip_StaticPart_Item1:SetText(string.format("#cfff263�����ȼ���%d/%d",nMijiLevel,nMijiLevelMax));
			SuperTooltip_StaticPart_Item2:SetText(string.format("#cfff263�������磺��%d��",nMiJi_JingJie));
			SuperTooltip_StaticPart_Item3:SetText("");
			SuperTooltip_Explain:SetText(szExplain);
			return 1;
		end
	end	 
	--===��¥��װ��ʾ�����в��԰棩 Q546528533 ͬ��
	if typeDesc ~= nil and string.find(SuperTooltips:GetTitle(),"��¥") ~= nil then
	    if string.find(typeDesc,"��ָ") ~= nil or string.find(typeDesc,"����") ~= nil or string.find(typeDesc,"����") ~= nil then
		    if string.find(SuperTooltips:GetTitle(),"�桤") ~= nil then
				local _,_,EquipSetNum = string.find(szPropertys,"��(%w)/3��")			
				if tonumber(EquipSetNum)== 2 then
					szPropertys = string.gsub(szPropertys,"{equip_attr_restorehp}%s%p1","���߿��Ƽ��� +10%%")
		    	elseif tonumber(EquipSetNum) == 3 then
				    szPropertys = string.gsub(szPropertys,"{equip_attr_restorehp}%s%p1","���߿��Ƽ��� +10%%")
				    szPropertys = string.gsub(szPropertys,"{equip_attr_restorehp}%s%p2","���߿��Ƽ��� +10%%")
				end			
				SuperTooltip_Property:SetText(szPropertys);
				SuperTooltip_Explain:SetText(szExplain);
				return 1
			end			
		end		
	    if string.find(typeDesc,"��ָ") ~= nil or string.find(typeDesc,"����") ~= nil or string.find(typeDesc,"����") ~= nil then
		    if string.find(SuperTooltips:GetTitle(),"�桤") == nil then
				local _,_,EquipSetNum = string.find(szPropertys,"��(%w)/3��")			
				if tonumber(EquipSetNum)== 2 then
					szPropertys = string.gsub(szPropertys,"{equip_attr_restorehp}%s%p1","���߿��Ƽ��� +5%%")
		    	elseif tonumber(EquipSetNum) == 3 then
				    szPropertys = string.gsub(szPropertys,"{equip_attr_restorehp}%s%p1","���߿��Ƽ��� +5%%")
				    szPropertys = string.gsub(szPropertys,"{equip_attr_restorehp}%s%p2","���߿��Ƽ��� +5%%")
				end			
				SuperTooltip_Property:SetText(szPropertys);
				SuperTooltip_Explain:SetText(szExplain);
				return 1
			end		
		end			    
		if string.find(typeDesc,"Ь") ~= nil or string.find(typeDesc,"ñ") ~= nil or string.find(typeDesc,"��") ~= nil or string.find(typeDesc,"��") ~= nil or string.find(typeDesc,"��") ~= nil then
		    if string.find(SuperTooltips:GetTitle(),"�桤") ~= nil then
				local _,_,EquipSetNum = string.find(szPropertys,"��(%w)/5��")			
				if tonumber(EquipSetNum)== 2 then
					szPropertys = string.gsub(szPropertys,"{equip_attr_restorehp}%s%p1","ȫ���� +600")
		    	elseif tonumber(EquipSetNum) == 3 then
				    szPropertys = string.gsub(szPropertys,"{equip_attr_restorehp}%s%p1","ȫ���� +600")
				    szPropertys = string.gsub(szPropertys,"{equip_attr_restorehp}%s%p2","ȫ���Թ��� +10%%")
		    	elseif tonumber(EquipSetNum) == 4 then
				    szPropertys = string.gsub(szPropertys,"{equip_attr_restorehp}%s%p1","ȫ���Թ��� +600")
				    szPropertys = string.gsub(szPropertys,"{equip_attr_restorehp}%s%p2","ȫ���Թ��� +10%%")
				    szPropertys = string.gsub(szPropertys,"{equip_attr_restorehp}%s%p3","ȫ���Կ��� +10%%")
		    	elseif tonumber(EquipSetNum) == 5 then
				    szPropertys = string.gsub(szPropertys,"{equip_attr_restorehp}%s%p1","ȫ���Թ��� +600")
				    szPropertys = string.gsub(szPropertys,"{equip_attr_restorehp}%s%p2","ȫ���Թ��� +10%%")
				    szPropertys = string.gsub(szPropertys,"{equip_attr_restorehp}%s%p3","ȫ���Կ��� +10%%")
				    szPropertys = string.gsub(szPropertys,"{equip_attr_restorehp}%s%p4","��¥�ƾ�������ʱ��6%%�ļ��ʽ��������Ѫ״̬�����״̬����Ŀ��ķ���������20�룬��Ѫ״̬����Ŀ��10%%Ѫֵ��")
				end
				SuperTooltip_Property:SetText(szPropertys);
				SuperTooltip_Explain:SetText(szExplain);
				return 1
			end			
		end			
		if string.find(typeDesc,"Ь") ~= nil or string.find(typeDesc,"ñ") ~= nil or string.find(typeDesc,"��") ~= nil or string.find(typeDesc,"��") ~= nil or string.find(typeDesc,"��") ~= nil then
		    if string.find(SuperTooltips:GetTitle(),"�桤") == nil then
				local _,_,EquipSetNum = string.find(szPropertys,"��(%w)/5��")
                -- PushDebugMessage(EquipSetNum)				
				if tonumber(EquipSetNum)== 2 then
					szPropertys = string.gsub(szPropertys,"{equip_attr_restorehp}%s%p1","ȫ���� +300")
		    	elseif tonumber(EquipSetNum) == 3 then
				    szPropertys = string.gsub(szPropertys,"{equip_attr_restorehp}%s%p1","ȫ���� +300")
				    szPropertys = string.gsub(szPropertys,"{equip_attr_restorehp}%s%p2","ȫ���Թ��� +5%%")
		    	elseif tonumber(EquipSetNum) == 4 then
				    szPropertys = string.gsub(szPropertys,"{equip_attr_restorehp}%s%p1","ȫ���Թ��� +300")
				    szPropertys = string.gsub(szPropertys,"{equip_attr_restorehp}%s%p2","ȫ���Թ��� +5%%")
				    szPropertys = string.gsub(szPropertys,"{equip_attr_restorehp}%s%p3","ȫ���Կ��� +5%%")
		    	elseif tonumber(EquipSetNum) == 5 then
				    szPropertys = string.gsub(szPropertys,"{equip_attr_restorehp}%s%p1","ȫ���Թ��� +300")
				    szPropertys = string.gsub(szPropertys,"{equip_attr_restorehp}%s%p2","ȫ���Թ��� +5%%")
				    szPropertys = string.gsub(szPropertys,"{equip_attr_restorehp}%s%p3","ȫ���Կ��� +5%%")
				    szPropertys = string.gsub(szPropertys,"{equip_attr_restorehp}%s%p4","��¥�ƾ�������ʱ��3%%�ļ��ʽ��������Ѫ״̬�����״̬����Ŀ��ķ���������10�룬��Ѫ״̬����Ŀ��5%%Ѫֵ��")
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
				SuperTooltip_StaticPart_Item1:SetText("#cfff263δ����");
			else
				local nTPGrade = LuaFnGetWHWGInfo(tonumber(nWGID), "Grade")
				local nTPLevel = LuaFnGetWHWGInfo(tonumber(nWGID), "Level")
				SuperTooltip_StaticPart_Item1:SetText("#cfff263�ȼ���"..nTPGrade.."��"..nTPLevel.."��");
				--Ǭλ����
				local grade = LuaFnGetWHWGInfo(tonumber(nWGID), "Grade")
				local level = LuaFnGetWHWGInfo(tonumber(nWGID), "Level")
				local strAttr,strValue = LuaFnGetWHWGLevelInfo(tonumber(nWGID),grade,level,"wszAttr")
				local attr_yang,attrvalue_yang,effecttype_yang,effectvalue_yang = LuaFnGetWHWGLevelInfo(tonumber(nWGID), grade, level,"AttrEffectYang")
				local attr_yin,attrvalue_yin,effecttype_yin,effectvalue_yin = LuaFnGetWHWGLevelInfo(tonumber(nWGID), grade, level,"AttrEffectYin")
				szPropertys = "#cfff263Ǭλ\n"..g_strAttrDic[attr_yang].." +"..attrvalue_yang.."\n"..string.format("%s�˺�����", g_EffectDic[effecttype_yang + 1]).." +"..string.format("%.2f%%",effectvalue_yang*0.01)
				szPropertys = szPropertys.."\n \n��λ#r"..g_strAttrDic[attr_yin].." +"..attrvalue_yin.."\n"..string.format("��%s�˺�����", g_EffectDic[effecttype_yin + 1]).." +"..string.format("%.2f%%",effectvalue_yin*0.01)
				szPropertys = szPropertys.."\n \nδ���룺#r"..g_strAttrDic[strAttr].." +"..strValue
			end
			SuperTooltip_StaticPart_Item2:SetText("");
			SuperTooltip_StaticPart_Item3:SetText("");	
			SuperTooltip_Property:SetText(szPropertys);
			SuperTooltip_Explain:SetText(szExplain);
			return 1
		end
	end
	--����װ��
	if typeDesc ~= nil and typeDesc ~= "" and string.find(typeDesc,"PET") ~= nil then
		--������ɫ���������������D:\TLBB\ML_365\Prj\GameCode\Client\Game\Item\GMItem_PetEquip.cpp�鿴
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
				SuperTooltip_StaticPart_Item1:SetText("#cC8B88E�ȼ�: "..nLevel);
			end
			SuperTooltip_ShortDesc_Text:SetText("#cC8B88E"..tPetEquipData[2]); --��ʾ����
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
			--��װЧ��
			local nSetAttrData = "#cffba00"
			local nAttrName,nStr,nAttrType_1,nAttr_1,nAttrType_2,nAttr_2,nAttrType_3,nAttr_3,nPetEquipT = Lua_EnumPetEquipAttr(nSetAttr)
			if isOnEquip == 0 then
				--#c605c4f     δ�������ɫ
				nSetAttrData = nSetAttrData..nAttrName.."(0/5)\n#c605c4f"
				local nSetAttrTable = Lua_GetAttrEquipID(nSetAttr)
				for i = 1,table.getn(nSetAttrTable) do
					nSetAttrData = nSetAttrData..LuaFnGetItemName(nSetAttrTable[i]).."\n"
				end
				for i = 1,4 do
					nSetAttrData = nSetAttrData.."#{GMItem_Equip_8}\n"
				end
			else
				--�鿴��װ����
				--#c99CC00%s\n ������ɫ
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
			--�������ϲ��֣����ﲻ������ ����װ��̫�� ֱ�ӹ̶�����2.5�ɣ�
			local nZiZhiQiHe = ""
			-- nPetEquipT ==
			local nZiZhiQiHeTable = {"#{ZSZB_0710_06}","#{ZSZB_0710_07}","#{ZSZB_0710_08}","#{ZSZB_0710_10}"}
			local nZiZhiQiHeTableOnEquip = {"#{ZSZB_0710_01}","#{ZSZB_0710_02}","#{ZSZB_0710_03}","#{ZSZB_0710_05}"}
			if isOnEquip == 0 then
				nZiZhiQiHe = "#cFFCC99"..nZiZhiQiHeTable[nPetEquipT].."\n"
			else
				--�鿴��װ����
				nZiZhiQiHe = nZiZhiQiHeTableOnEquip[nPetEquipT].."2.5%\n"
			end
			szPropertys = "#{GMItem_Equip_2}"..nBaseAttr..nZiZhiQiHe..nSetAttrData
			--װ������
			if isOnEquip == 0 then
				if szAuthor ~= nil and szAuthor ~= "" then
					szPropertys = szPropertys..Lua_GetPetEquipZiZhiDesc(nPetEquipID,szAuthor)
				else
					szPropertys = szPropertys.."#r#{GMItem_Equip_15}"
				end
			else
				--�鿴��װ����
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
	--*************************************************���ϵͳ*************************************************
	if( szPropertys ~= nil) then	
		local wunhPos1,wunhsxPos1 = string.find(typeDesc, "���")
		if  wunhPos1 ~= nil and  wunhsxPos1 ~= nil then
			local nGrow,nExLevel,nLevel,nExp,nMagic,nExAttrNum,nExAttr,nSkill = LuaGetKfsAttrData(szAuthor)
			local nFixnGrow = 500
			--ͷ����ʾ
			SuperTooltip_StaticPart_Item1:SetText("#cC8B88EЯ���ȼ�:65");
			SuperTooltip_StaticPart_Item2:SetText("#cC8B88E�ȼ�:"..tonumber(nLevel));
			--�������
			local nAttactType = 0
			if string.find(typeDesc,"���_0") ~= nil then
				SuperTooltip_StaticPart_Item3:SetText("#{WH_xml_XX(100)}");
			else
				SuperTooltip_StaticPart_Item3:SetText("#{WH_xml_XX(101)}");
				nAttactType = 1;
			end			
			SuperTooltip_ShortDesc_Text:SetText("#cffcc99���");
			local Life = LifeAbility:Get_UserEquip_Current_Durability(18);
			local maxLife = LifeAbility:Get_UserEquip_Maximum_Durability(18);
			if maxLife ~= -1 and Life  ~= -1 then
				SuperTooltip_StaticPart_Item4:SetText("#cC8B88E������"..tostring(Life).."/"..tostring(maxLife));
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
			--�ɳ��� 2019-10-18 18:47:52��ң��
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
			
			nExLevel = "#{WH_xml_XX(74)}"..nExLevel.."#r";--�ϳɵȼ�
			local nExAttrNumShow = "#{WH_xml_XX(80)}"..nExAttrNum.."#r#cFFCC00"--��չ����
			if nExAttrNum >= 1 then
				for i = 1,nExAttrNum do
					local iText , iValue = Lua_GetKfsFixAttrEx(nExAttr,i,nFixnGrow)
					if iValue > 0 then
						nExAttrNumShow = nExAttrNumShow..iText.."+"..iValue.."#r"
					end
				end
			end
			--���ܲ���
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
			--����
			local nMagicName = {"#{WH_xml_XX(56)}","#{WH_xml_XX(57)}","#{WH_xml_XX(58)}","#{WH_xml_XX(59)}"}
			if nMagic >= 1 and nMagic <= 4 then
				nMagic = "#H"..nMagicName[nMagic]
			else
				nMagic = ""
			end
			local nFinalShow = g_DWAttr..nGrow..nKfsBaseDataShow..nExLevel..nExAttrNumShow..nSkillShow
			local Temp1,Temp2 = string.find(szPropertys, "��#r")
			local Temp3,Temp4 = string.find(szPropertys, "����#r")
			if Temp3 ~= nil then
				szPropertys = string.gsub(szPropertys, "����#r", "����#r"..nFinalShow);
			elseif Temp1 ~= nil then
				szPropertys = string.gsub(szPropertys, "��#r", "��#r"..nFinalShow);
			else
				szPropertys = "#r"..nFinalShow..szPropertys
			end
			--��ʯ���� 2019-10-19 19:33:09 ��ң��������ʾ
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
	if szAuthor ~= nil and string.find(typeDesc,"��ԪƱ") ~= nil then
	    local nPos_1,nPos_2,nBindYuanBao = string.find(szAuthor,"&BINDYAUNBAO(.*)")
		if nPos_1 ~= nil and nPos_2 ~= nil then
		    szExplain = string.gsub(szExplain, "Ԫ����#r", "Ԫ����#r�����Ϊ"..nBindYuanBao.."��Ԫ����#r");
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
			nFinalAdpt = "#cFFCC00"..nAdptType_1.." #{GMItem_Equip_19} +"..nAdpt1.."% ��+"..tostring(math.ceil(nAdptAdd * (nAdpt1/100))).."��\n"
			if nAdptType_2 ~= "" then
				nFinalAdpt = nFinalAdpt..nAdptType_2.." #{GMItem_Equip_19} +"..nAdpt2.."% ��+"..tostring(math.ceil(nAdptAdd * (nAdpt2/100))).."��\n"
			end
		else
			local nAdpt1_Show,nAdpt2_Show = "",""
			--����1
			if nAdpt1 >= 20 then
				nAdpt1_Show = "#{GMItem_Equip_19}"
			elseif nAdpt1 >= 2 and nAdpt1 <= 10 then
				nAdpt1_Show = "#{GMItem_Equip_22}"
			elseif nAdpt1 >= 11 and nAdpt1 <= 15 then
				nAdpt1_Show = "#{GMItem_Equip_21}"	
			elseif nAdpt1 >= 16 and nAdpt1 <= 19 then
				nAdpt1_Show = "#{GMItem_Equip_20}"	
			end
			--����2
			if nAdpt2 >= 20 then
				nAdpt2_Show = "#{GMItem_Equip_19}"
			elseif nAdpt2 >= 2 and nAdpt2 <= 10 then
				nAdpt2_Show = "#{GMItem_Equip_22}"
			elseif nAdpt2 >= 11 and nAdpt2 <= 15 then
				nAdpt2_Show = "#{GMItem_Equip_21}"	
			elseif nAdpt2 >= 16 and nAdpt2 <= 19 then
				nAdpt2_Show = "#{GMItem_Equip_20}"	
			end
			nFinalAdpt = "#P"..nAdptType_1.." "..nAdpt1_Show.." +"..nAdpt1.."% ��+"..tostring(math.ceil(nAdptAdd * (nAdpt1/100))).."��\n"
			if nAdptType_2 ~= nil and nBaseMiss <= 0 then
				nFinalAdpt = nFinalAdpt..nAdptType_2.." "..nAdpt2_Show.." +"..nAdpt2.."% ��+"..tostring(math.ceil(nAdptAdd * (nAdpt2/100))).."��\n"
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
-- �����ʾ�ı�
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
		--ʹ��ʲô��Ϊ����
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
	if(CU_MONEY	== nUnit or CU_TICKET == nUnit or CU_MONEYJZ == nUnit)       then      --Ǯ����ƱǮ, ����
			StaticPart_GB_Ctl:Hide()
			StaticPart_Money_Ctl:Show();
			StaticPart_Money_Ctl:SetProperty("MoneyNumber", tostring(nPrice));

	elseif(CU_GOODBAD == nUnit) then			--�ƶ�ֵ
			
			StaticPart_GB_Ctl:Show()
			StaticPart_Money_Ctl:Hide();
			StaticPart_GB_Ctl:SetText("�ƶ�ֵ:" .. tostring(nPrice) .. " ��")


	elseif(CU_MORALPOINT == nUnit)  then	--ʦ�µ�

			StaticPart_GB_Ctl:Show()
			SuperTooltip_StaticPart_Money:Hide();
			StaticPart_GB_Ctl:SetText("ʦ�µ�:" .. tostring(nPrice) .. " ��")

	elseif(CU_YUANBAO == nUnit) then	--Ԫ��

			StaticPart_GB_Ctl:Show()
			StaticPart_Money_Ctl:Hide();
			StaticPart_GB_Ctl:SetText("Ԫ��:" .. tostring(nPrice))

	elseif(CU_ZENGDIAN == nUnit) then	--����

			StaticPart_GB_Ctl:Show()
			StaticPart_Money_Ctl:Hide();
			StaticPart_GB_Ctl:SetText("��Ԫ��:" .. tostring(nPrice))

	elseif(CU_MENPAI_POINT == nUnit) then	--ʦ�Ź��׶�

			StaticPart_GB_Ctl:Show()
			StaticPart_Money_Ctl:Hide();
			StaticPart_GB_Ctl:SetText("���ɹ��׶�:" .. tostring(nPrice))

	end	
	
end;
--��ʾָ������������
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
			--���϶���ʾ
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
			--�������󲿷�
			local nSkillName = {"��","��","��","��"}
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
					nSuperWeaponSX_Show = nSuperWeaponSX_Show.."#c1f941e����λ��"..tonumber(nLevel_1).."������"..nSkillName[tonumber(nType_1)].."�����˺�����"..nSkillName_Add_A[tonumber(nLevel_1)].."��#r"
				end
				if tonumber(nLevel_2) == 0 then
					nSuperWeaponSX_Show = nSuperWeaponSX_Show.."#{JXSQ_170811_174}#r"
				elseif tonumber(nLevel_2) > 0 and tonumber(nType_2) == 0 then
					nSuperWeaponSX_Show = nSuperWeaponSX_Show.."#{JXSQ_170811_172}#r"
				else
					nSuperWeaponSX_Show = nSuperWeaponSX_Show.."#c1f941e�ػ�λ��"..tonumber(nLevel_2).."��������"..nSkillName[tonumber(nType_2)].."������"..nSkillName_Add_B[tonumber(nLevel_2)].."�㣬����5��#r"
				end
				if tonumber(nLevel_3) == 0 then
					nSuperWeaponSX_Show = nSuperWeaponSX_Show.."#{JXSQ_170811_176}#r"
				elseif tonumber(nLevel_3) > 0 and tonumber(nType_3) == 0 then
					nSuperWeaponSX_Show = nSuperWeaponSX_Show.."#{JXSQ_170811_172}#r"
				else
					nSuperWeaponSX_Show = nSuperWeaponSX_Show.."#c1f941e���λ��"..tonumber(nLevel_3).."��������"..nSkillName[tonumber(nType_3)].."����������"..tonumber(nLevel_3).."%������5��#r"
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