--交互NPC

local XIULIAN_BOOKS = {}
local XIULIAN_MIJI = {}
local XIULIAN_MIJI_TEXT = {}

local g_clientNpcId =-1
local g_ServerNpcId =-1

local g_IsSpecialState = -1

local XIULIAN_BOOK_SELECT = 1
local XIULIAN_MIJI_SELECT = -1

local XIULIAN_STUDY_TYPE = 0

local MIJI_CAN_SELECT = false;
local g_Xiulian_Book = {49000001,49000002,49000003}
local g_Xiulian_MijiBook = {49000004,49000005,49000006,49000007,49000008,49000009,49000010,49000011,49000012,49000013,49000014,49000015,49000016,49000017,49000018}

local g_XiulianStudy_Frame_UnifiedPosition;

local strZhiyeTip_study = {}
strZhiyeTip_study[1] = "#{XLZY_120330_02}" --少林
strZhiyeTip_study[2] = "#{XLZY_120330_04}" --明教
strZhiyeTip_study[3] = "#{XLZY_120330_03}" --丐帮
strZhiyeTip_study[4] = "#{XLZY_120330_05}" --武当
strZhiyeTip_study[5] = "#{XLZY_120330_08}" --峨嵋
strZhiyeTip_study[6] = "#{XLZY_120330_09}" --星宿
strZhiyeTip_study[7] = "#{XLZY_120330_06}" --天龙
strZhiyeTip_study[8] = "#{XLZY_120330_10}" --天山
strZhiyeTip_study[9] = "#{XLZY_120330_07}" --逍遥
strZhiyeTip_study[10] = " " --无门派
strZhiyeTip_study[11] = "#{XLZY_120330_11}" --慕容
strZhiyeTip_study[12] = "#{XMPTM_130123_08}" --唐门

function XiulianStudy_PreLoad()

	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("UNIT_XIULIAN");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("UNIT_EXP");
	this:RegisterEvent("MONEYJZ_CHANGE");
	this:RegisterEvent("UINT_POWER");
	--this:RegisterEvent("UNIT_GUILDPOINT"); --帮贡界面没有实时刷新机制，人物属性和会员管理界面都没有

	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")

	this:RegisterEvent("UPDATE_MISSION_DATA") -- "回流专属经验"和"回流补偿功力值"

end

function XiulianStudy_OnLoad()

	XIULIAN_BOOKS[1] = XiulianStudy_XinfaSkill_1
	XIULIAN_BOOKS[2] = XiulianStudy_XinfaSkill_2
	XIULIAN_BOOKS[3] = XiulianStudy_XinfaSkill_3
	XIULIAN_BOOKS[4] = XiulianStudy_XinfaSkill_4

	XIULIAN_MIJI[1] = XiulianStudy_ZhaoshiSkill_1
	XIULIAN_MIJI[2] = XiulianStudy_ZhaoshiSkill_2
	XIULIAN_MIJI[3] = XiulianStudy_ZhaoshiSkill_3
	XIULIAN_MIJI[4] = XiulianStudy_ZhaoshiSkill_4
	XIULIAN_MIJI[5] = XiulianStudy_ZhaoshiSkill_5
	XIULIAN_MIJI[6] = XiulianStudy_ZhaoshiSkill_6

	XIULIAN_MIJI_TEXT[1] = XiulianStudy_ZhaoshiSkill_level1
	XIULIAN_MIJI_TEXT[2] = XiulianStudy_ZhaoshiSkill_level2
	XIULIAN_MIJI_TEXT[3] = XiulianStudy_ZhaoshiSkill_level3
	XIULIAN_MIJI_TEXT[4] = XiulianStudy_ZhaoshiSkill_level4
	XIULIAN_MIJI_TEXT[5] = XiulianStudy_ZhaoshiSkill_level5
	XIULIAN_MIJI_TEXT[6] = XiulianStudy_ZhaoshiSkill_level6

	g_XiulianStudy_Frame_UnifiedPosition=XiulianStudy_Frame:GetProperty("UnifiedPosition");

end

function XiulianStudy_OnEvent(event)

	if(event == "UI_COMMAND" and tonumber(arg0) == 171717) then
		g_IsSpecialState = -1
		g_ServerNpcId = Get_XParam_INT(0);
		local nStudyType = Get_XParam_INT(1);
		g_IsSpecialState = Get_XParam_INT(2)
		g_clientNpcId = DataPool : GetNPCIDByServerID(g_ServerNpcId)
		if g_clientNpcId == -1 then
			XiulianStudy_Close()
			return
		end

		if this : IsVisible() then									-- 如果界面开着，则不处理
			if XIULIAN_STUDY_TYPE ~= nStudyType then
				XiulianStudy_Frame:SetProperty("UnifiedPosition", "{{0.5,-128.000000},{0.1,0.0}");
			else
				return
			end
		end

		XIULIAN_STUDY_TYPE = nStudyType
		--初始化选中状态
		XIULIAN_BOOK_SELECT = 1
		XIULIAN_MIJI_SELECT = -1

		if g_IsSpecialState == 1 then
			XIULIAN_BOOK_SELECT = 3
		end
        XiulianStudy_CurrentlyGongli_Character_Text:SetText("#{XL_XML_65}"..tostring(Get_XParam_INT(3)).."/100");
		XiuLianStudy_UpdateFrame(nStudyType);
		--极致币属性
		--XiulianStudy_huiliuExperience_TXT:SetText("#G极致币："..tostring(DataPool:GetPlayerMission_DataRound(289)))
		--极致币属性
		this : Show()
		this : CareObject( g_clientNpcId, 1, "XiulianStudy" )
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 2019042003) then
		for i = 1, 2 do
			local theAction = GemCarve:UpdateProductAction(g_Xiulian_Book[i])--EnumAction(i - 1, "xiulianbook")
			if(theAction:GetID() ~= 0) then
				XIULIAN_BOOKS[i] : SetActionItem(theAction:GetID())
			end
		end
		XiulianStudy_JingJie_Selected_Update()
		XiulianStudy_Skill_Selected_Update()
		XiulianStudy_SetSelectState()
		XiulianStudy_CurrentlyGongli_Character_Text:SetText("#{XL_XML_65}"..tostring(Get_XParam_INT(0)).."/100");
	elseif (event == "OBJECT_CARED_EVENT") then
		if(tonumber(arg0) ~= g_clientNpcId) then
			return;
		end

		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if arg1 == "distance" and tonumber(arg2) > MAX_OBJ_DISTANCE or arg1=="destroy" then
			XiulianStudy_Close()
		end
	elseif (event == "UNIT_MONEY") then
	     --玩家身上金钱
		local nMoneyNow,nGold,nSilverCoin,nCopperCoin = Player:GetData("MONEY");
		XiulianStudy_Currently_Money:SetProperty("MoneyNumber", tostring(nMoneyNow));
	elseif (event == "UNIT_EXP") then
		--玩家已经取得的经验
		local nExpNow = Player:GetData("EXP");
		XiulianStudy_CurrentlyExp_Character_Text:SetText("#{XL_XML_67}" .. tostring(nExpNow));
	elseif (event == "MONEYJZ_CHANGE") then
		XiulianStudy_Currently_Jiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
	elseif (event == "UINT_POWER") then
		local nPower =  DataPool:GetPlayerMission_DataRound(316)		
		local attch =""

		--XiulianStudy_CurrentlyGongli_Tooltip:SetText(attch)
		-- XiulianStudy_CurrentlyGongli_Character_Text:SetText("#{XL_XML_65}"..tostring(nPower).."/100");
	elseif (event == "ADJEST_UI_POS" ) then
		XiulianStudy_Frame_On_ResetPos()

	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		XiulianStudy_Frame_On_ResetPos()
	elseif ( event == "UPDATE_MISSION_DATA" ) then
		local nHuiLiuExp = Player : GetData( "HUILIUEXP" );			-- 回流专属经验
		--XiulianStudy_huiliuExperience_TXT : SetText( "#{HLJYBC_120813_32}"..nHuiLiuExp );
		local nHuiLiuGongLi = Player : GetData( "HUILIUGONGLI" );	-- 回流补偿功力值
		XiulianStudy_huiliuGongLI_TXT : SetText( "#{HLJYBC_120813_33}"..nHuiLiuGongLi );
	end

end

--===============================================
-- 关闭事件
--===============================================
function XiulianStudy_Close()
    --PushDebugMessage("XiulianStudy_Close is Call")
	this:Hide()
	this:CareObject(g_clientNpcId, 0, "XiulianStudy")
	g_clientNpcId = -1
end

--===============================================
--学习页面刷新
--===============================================
function XiuLianStudy_UpdateFrame(nStudyType)
	if(nStudyType == 1) then
        XiulianStudy_NpcName:SetText("#{XL_XML_01}")

        XiulianStudy_UpLevel_Frame:Show()
        XiulianStudy_UpJingJie_Frame:Hide()
	elseif(nStudyType == 2) then
        XiulianStudy_NpcName:SetText("#{XL_XML_53}")

        XiulianStudy_UpLevel_Frame:Hide()
        XiulianStudy_UpJingJie_Frame:Show()
	else
		return
	end

	XiulianStudy_UpdateFrameDynamic()

end

--===============================================
-- 刷新除提升按钮外所有动态控件
--===============================================
function XiulianStudy_UpdateFrameDynamic()

	for i = 1, 2 do
		local theAction = GemCarve:UpdateProductAction(g_Xiulian_Book[i])--EnumAction(i - 1, "xiulianbook")
		if(theAction:GetID() ~= 0) then
			XIULIAN_BOOKS[i] : SetActionItem(theAction:GetID())
		end
	end

	XiulianStudy_JingJie_Selected_Update()
	XiulianStudy_Skill_Selected_Update()

     --玩家身上金钱
	local nMoneyNow,nGold,nSilverCoin,nCopperCoin = Player:GetData("MONEY");

	XiulianStudy_Currently_Money:SetProperty("MoneyNumber", tostring(nMoneyNow));
	XiulianStudy_Currently_Jiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));


	--玩家已经取得的经验
	local nExpNow = Player:GetData("EXP");
	XiulianStudy_CurrentlyExp_Character_Text:SetText("#{XL_XML_67}" .. tostring(nExpNow));
	local nPower = DataPool:GetPlayerMission_DataRound(316)
	-- XiulianStudy_CurrentlyGongli_Character_Text:SetText("#{XL_XML_65}"..tostring(nPower).."/100");		
	--设计按钮
	XiulianStudy_SetSelectState();
end

--===============================================
-- 点击提升修炼等级
--===============================================
function XiulianStudy_UpLevel_Clicked()

	if XIULIAN_BOOK_SELECT == 3 then
		--判断等级
		if(Player:GetData("LEVEL") < 90) then
			PushDebugMessage("#{XLZY_120330_17}")
			return
		end
		--判断进阶任务
		if GetXiuLianBookInfo(2,"HasActived") ~= 1 then
			PushDebugMessage("#{XLZY_120330_18}")
			return
		end
	end
	
	-- 请选择您要修炼的修炼秘籍。
    if  XIULIAN_MIJI_SELECT == -1 then
		PushDebugMessage("#{XL_090707_03}")
		return
    end

	-- 该秘籍的修炼等级已经到达上限，您需要提升修炼境界才能继续修炼该秘籍。
	local nXiulianLvl = GetXiuLianMiJiInfo( XIULIAN_MIJI_SELECT - 1, "Level" );
	local nXiulianMaxLvl = GetXiuLianMiJiInfo( XIULIAN_MIJI_SELECT - 1, "MaxLevel" );
	if ( nXiulianLvl >= nXiulianMaxLvl ) then
		PushDebugMessage("#{XL_090707_04}")
		return
	end

	local nCurExp = Player : GetData( "EXP" );	-- 自身经验
	local nHuiLiuExp = 0--Player : GetData( "HUILIUEXP" );	-- 回流专属经验
	local nNeedExp = GetXiuLianMiJiInfo( XIULIAN_MIJI_SELECT - 1, "UpLevelNeedExp" );	-- 需要的经验
	if ( nHuiLiuExp > 0 and nCurExp + nHuiLiuExp >= nNeedExp ) then	-- 经验总量超过所需经验
		if ( nHuiLiuExp < nNeedExp ) then	-- 回归经验又不足, 需要扣除玩家自身经验的时候
			-- messagebox
			PushEvent( "STUDY_XIULIAN", "AskXiuLianLevelUp", 002099, g_ServerNpcId, XIULIAN_MIJI_SELECT - 1 );
			return
		end
	end

	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("XIULIAN");
		Set_XSCRIPT_ScriptID(990025);
		Set_XSCRIPT_Parameter(0,tonumber(2));
		Set_XSCRIPT_Parameter(1,tonumber(XIULIAN_MIJI_SELECT - 1));
		Set_XSCRIPT_ParamCount(2);
	Send_XSCRIPT();
	XiulianStudy_SetSelectState();

end

--===============================================
-- 点击提升修炼境界
--===============================================
function XiulianStudy_UpJingJie_Clicked()

	if XIULIAN_BOOK_SELECT == 3 then
		--判断等级
		if(Player:GetData("LEVEL") < 90) then
			PushDebugMessage("#{XLZY_120330_17}")
			return
		end
		--判断进阶任务
		if GetXiuLianBookInfo(2,"HasActived") ~= 1 then
			PushDebugMessage("#{XLZY_120330_18}")
			return
		end
	end
	
	if  XIULIAN_MIJI_SELECT == -1 then
		PushDebugMessage("#{XL_090707_03}")
		return
    end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("XIULIAN");
		Set_XSCRIPT_ScriptID(990025);
		Set_XSCRIPT_Parameter(0,tonumber(3));
		Set_XSCRIPT_Parameter(1,tonumber(XIULIAN_MIJI_SELECT - 1));
		Set_XSCRIPT_ParamCount(2);
	Send_XSCRIPT();
	XiulianStudy_SetSelectState();
end

--===============================================
-- 点击修炼书
--===============================================
function XiulianStudy_Xinfa_Clicked(nIndex)
    if(nIndex < 4) then --开启第3第4本
	    XIULIAN_BOOK_SELECT = nIndex
	    XIULIAN_MIJI_SELECT = -1
	    XiulianStudy_JingJie_Selected_Update()
	    XiulianStudy_SetSelectState()
	else
		--PushDebugMessage("#{XL_090707_50}")
    end
end

--===============================================
-- 点击修炼秘籍
--===============================================
function XiulianStudy_Skill_Clicked(nIndex)
	if MIJI_CAN_SELECT == false then
		return
	end
	if(XIULIAN_BOOK_SELECT == 1) then
	   if (nIndex ~= 6)  then
         XIULIAN_MIJI_SELECT  = nIndex
	   else
	     XIULIAN_MIJI_SELECT  = -1
	   end
	elseif(XIULIAN_BOOK_SELECT == 2)  then
	     XIULIAN_MIJI_SELECT  = nIndex + 5
	elseif XIULIAN_BOOK_SELECT == 3 then --开启第3本 add by kaibin for
		if nIndex >= 1 and nIndex <= 4 then
			XIULIAN_MIJI_SELECT = nIndex + 11
		else
			XIULIAN_MIJI_SELECT = -1
		end
	else
         XIULIAN_MIJI_SELECT = -1
	end

	XiulianStudy_Skill_Selected_Update()
	XiulianStudy_SetSelectState()
end

--===============================================
-- 选择修炼秘籍后刷新
--===============================================
function  XiulianStudy_Skill_Selected_Update()

    	--刷新中间图标
	if (XIULIAN_MIJI_SELECT ~= -1)   then
		local theAction = GemCarve:UpdateProductAction(g_Xiulian_MijiBook[XIULIAN_MIJI_SELECT])--EnumAction(XIULIAN_MIJI_SELECT - 1, "xiulianmiji")
		XiulianStudy_SkillIcon : SetActionItem(theAction:GetID())

		local XiuLianMiJiName = GetXiuLianMiJiInfo(XIULIAN_MIJI_SELECT-1,"Name");
		local XiuLianMiJiJingJie = GetXiuLianMiJiInfo(XIULIAN_MIJI_SELECT-1,"JingJie")
		local XiuLianMiJiLevel = GetXiuLianMiJiInfo(XIULIAN_MIJI_SELECT-1,"Level")
		local CurMaxLevel = GetXiuLianMiJiInfo(XIULIAN_MIJI_SELECT-1,"MaxLevel")
		local XiuLianMiJiExplain = GetXiuLianMiJiInfo(XIULIAN_MIJI_SELECT-1,"Explain")
		local nNeedMoney = GetXiuLianMiJiInfo(XIULIAN_MIJI_SELECT-1,"UpLevelNeedMoney")
		local nNeedExp = GetXiuLianMiJiInfo(XIULIAN_MIJI_SELECT-1,"UpLevelNeedExp")


		local StrJingJie = "#{XL_XML_32}".."#{XL_XML_85}"..XiuLianMiJiJingJie.."#{XL_XML_86}"
		local StrDengJi = "#{XL_XML_33}"..XiuLianMiJiLevel.."/"..CurMaxLevel

		XiulianStudy_SkillName:SetText(XiuLianMiJiName);
		XiulianStudy_SkillJingjie:SetText(StrJingJie);
		XiulianStudy_SkillLevel:SetText(StrDengJi);
		local strCondition = ""
		if(XIULIAN_BOOK_SELECT == 1) then
			if(Player:GetData("LEVEL") >= 70) then
				strCondition = "\n#G#{XL_XML_30}"
			else
				strCondition = "\n#cff0000#{XL_XML_30}"
			end
		elseif XIULIAN_BOOK_SELECT == 2 then
			local XiuLianBook1Level = GetXiuLianBookInfo(0,"Level")
			if (XiuLianBook1Level >= 3) then
				strCondition = "\n#G#{XL_XML_34}"
			else
				strCondition = "\n#cff0000#{XL_XML_34}"
			end
		elseif XIULIAN_BOOK_SELECT == 3 then  --第4本的条件是达到90级并完成门派进阶
			---------------------------------------------此处需要加上判断是否完成任务
			
			if XIULIAN_MIJI_SELECT-1 == 11 then
	            --等级限制
				if(Player:GetData("LEVEL") >= 90) then
					strCondition = "\n#{XLZY_120330_12}"
				else
					strCondition = "\n#{XLZY_120330_01}"
				end
				--完成进阶任务
				if GetXiuLianBookInfo(2,"HasActived") == 1 then
					strCondition = strCondition.."\n#{XLZY_120330_23}"
				else
					strCondition = strCondition.."\n#{XLZY_120330_22}"
				end
				
				--门派信息
				local nZhiye = Player:GetData("MEMPAI")
				nZhiye = nZhiye + 1
				if nZhiye >= 1 and nZhiye <= 12 then
					strCondition = strCondition..strZhiyeTip_study[nZhiye]    
				end
			
	        elseif XIULIAN_MIJI_SELECT-1 == 12 then
				local level = GetXiuLianMiJiInfo(11,"Level")
				if tonumber(level) >= 10 then
					strCondition = "\n#{XLZY_120330_14}"	
				else
					strCondition = "\n#{XLZY_120330_13}"
				end
	        elseif  XIULIAN_MIJI_SELECT-1 == 13 or XIULIAN_MIJI_SELECT-1 == 14 then
	            local level_11 = GetXiuLianMiJiInfo(11,"Level")
	            local level_12 = GetXiuLianMiJiInfo(12,"Level")
	            if tonumber(level_11) >= 20 and tonumber(level_12) >= 20 then
					strCondition = "\n#{XLZY_120330_16}"	
				else
					strCondition = "\n#{XLZY_120330_15}"
				end
	        end	
	        
		end
		XiulianStudy_SkillInfo:SetText(XiuLianMiJiExplain..strCondition);

		if(XIULIAN_STUDY_TYPE == 1) then
			XiulianStudy_Demand_Jiaozi:SetProperty("MoneyNumber", tostring(nNeedMoney));
			XiulianStudy_DemandExp_Character_Text:SetText("#{XL_XML_68}" .. tostring(nNeedExp));

			--计算需要功力
			local nXiulianNeedPower = 0;
			if (XiuLianMiJiLevel >= 0 and XiuLianMiJiLevel < 30)  then
				  nXiulianNeedPower = 33
			elseif(XiuLianMiJiLevel >= 30 and XiuLianMiJiLevel < 60 )  then
				  nXiulianNeedPower = 50
			elseif(XiuLianMiJiLevel >= 60 and XiuLianMiJiLevel <= 150)  then
			      nXiulianNeedPower = 100
			end
			XiulianStudy_DemandGongli_Character_Text:SetText("#{XL_XML_66}"..tostring(nXiulianNeedPower))

		elseif (XIULIAN_STUDY_TYPE ==2) then
		    	--得到重数,计算钱用
			local nJingJieNum = 0;
			if(CurMaxLevel <= 60)   then
				  nJingJieNum = CurMaxLevel/10;
			else
				  nJingJieNum = ((CurMaxLevel-60)/15) + 6
			end
			nJingJieNum = nJingJieNum + 1
			XiulianStudy_Demand_Jiaozi:SetProperty("MoneyNumber", tostring(nJingJieNum*10000));  --目前以等级设置为钱
		end

	else
        if(XIULIAN_BOOK_SELECT == -1)	then
	    	XiulianStudy_SkillIcon : SetActionItem(-1)
	    end
	end

end

--===============================================
-- 选择修炼境界后刷新
--===============================================
function  XiulianStudy_JingJie_Selected_Update()
    if XIULIAN_BOOK_SELECT == 3 then
	    return
	end
    if XIULIAN_BOOK_SELECT == 1  then
		for i = 1, 5 do
			local	theAction = GemCarve:UpdateProductAction(g_Xiulian_MijiBook[i])--EnumAction(i - 1, "xiulianmiji")
			if theAction ~= 0 then
				XIULIAN_MIJI[i] : SetActionItem(theAction:GetID())
				local CurMaxLevel = GetXiuLianMiJiInfo(i - 1,"MaxLevel")
		        local XiuLianMiJiLevel = GetXiuLianMiJiInfo(i - 1,"Level")
		        if (CurMaxLevel == nil) or (XiuLianMiJiLevel == nil) then
					MIJI_CAN_SELECT =false
					return
				else
					MIJI_CAN_SELECT =true
				end
		        local strTemp = XiuLianMiJiLevel.."/"..CurMaxLevel
		        XIULIAN_MIJI_TEXT[i]:SetText(XiuLianMiJiLevel.."/"..CurMaxLevel);
			end
		end
		XIULIAN_MIJI[6] : SetActionItem(-1)
		XIULIAN_MIJI_TEXT[6]:SetText("");
	elseif XIULIAN_BOOK_SELECT == 2  then
		for i = 1, 6 do
			theAction = GemCarve:UpdateProductAction(g_Xiulian_MijiBook[i+5])--EnumAction(i + 5 - 1, "xiulianmiji")
			if theAction ~= 0 then
		        XIULIAN_MIJI[i] : SetActionItem(theAction:GetID())
		        local CurMaxLevel = GetXiuLianMiJiInfo(i + 5 - 1,"MaxLevel")
		        local XiuLianMiJiLevel = GetXiuLianMiJiInfo(i + 5 - 1,"Level")
		        if (CurMaxLevel == nil) or (XiuLianMiJiLevel == nil) then
		        	MIJI_CAN_SELECT =false
					return
		        else
		        	MIJI_CAN_SELECT =true
				end
		        local strTemp = XiuLianMiJiLevel.."/"..CurMaxLevel
		        XIULIAN_MIJI_TEXT[i]:SetText(XiuLianMiJiLevel.."/"..CurMaxLevel);
			end
		end
	elseif XIULIAN_BOOK_SELECT == 3 then
		for i = 1, 4 do
			local	theAction = GemCarve:UpdateProductAction(g_Xiulian_MijiBook[i+11])--EnumAction(i + 11 - 1, "xiulianmiji")
			if theAction ~= 0 then
				XIULIAN_MIJI[i] : SetActionItem(theAction:GetID())
				local CurMaxLevel = GetXiuLianMiJiInfo(i + 11 - 1,"MaxLevel")
				local XiuLianMiJiLevel = GetXiuLianMiJiInfo(i + 11 - 1,"Level")
				if (CurMaxLevel == nil) or (XiuLianMiJiLevel == nil) then
					MIJI_CAN_SELECT =false
					return
				else
					MIJI_CAN_SELECT =true
				end
				local strTemp = XiuLianMiJiLevel.."/"..CurMaxLevel
				XIULIAN_MIJI_TEXT[i]:SetText(strTemp);
			end
		end
		XIULIAN_MIJI[5] : SetActionItem(-1)
		XIULIAN_MIJI_TEXT[5]:SetText("");
		XIULIAN_MIJI[6] : SetActionItem(-1)
		XIULIAN_MIJI_TEXT[6]:SetText("");
	else
		for i=1, 6 do
	        XIULIAN_MIJI[i] : SetActionItem(-1)
	        XIULIAN_MIJI_TEXT[i]:SetText("")
		end
	end

    	--刷新中间图标
	if (XIULIAN_BOOK_SELECT ~= -1)   then
		theAction = GemCarve:UpdateProductAction(g_Xiulian_Book[XIULIAN_BOOK_SELECT])--EnumAction(XIULIAN_BOOK_SELECT-1, "xiulianbook")
		XiulianStudy_SkillIcon : SetActionItem(theAction:GetID())
		local XiuLianBookName = GetXiuLianBookInfo(XIULIAN_BOOK_SELECT-1,"Name");
		local XiuLianBookLevel = GetXiuLianBookInfo(XIULIAN_BOOK_SELECT-1,"Level")
		local XiuLianBookExplain = GetXiuLianBookInfo(XIULIAN_BOOK_SELECT-1,"Explain")


		local StrJingJie = "#{XL_XML_29}".."#{XL_XML_85}"..XiuLianBookLevel.."#{XL_XML_86}"

		XiulianStudy_SkillName:SetText(XiuLianBookName);
		XiulianStudy_SkillJingjie:SetText(StrJingJie);
		XiulianStudy_SkillLevel:SetText("");
		local strCondition = ""
		if(XIULIAN_BOOK_SELECT == 1) then
			if(Player:GetData("LEVEL") >= 70) then
				strCondition = "\n#G#{XL_XML_30}"
			else
				strCondition = "\n#cff0000#{XL_XML_30}"
			end
		elseif XIULIAN_BOOK_SELECT == 2 then
			local XiuLianBook1Level = GetXiuLianBookInfo(0,"Level")
			if (XiuLianBook1Level >= 3) then
				strCondition = "\n#G#{XL_XML_34}"
			else
				strCondition = "\n#cff0000#{XL_XML_34}"
			end
		--第3本修炼
		elseif XIULIAN_BOOK_SELECT == 3 then
			--------------------------------------需要判断完成门派进阶
			--等级限制
			if(Player:GetData("LEVEL") >= 90) then
				strCondition = "\n#{XLZY_120330_12}"
			else
				strCondition = "\n#{XLZY_120330_01}"
			end
			--完成进阶任务
			if GetXiuLianBookInfo(2,"HasActived") == 1 then
			    strCondition = strCondition.."\n#{XLZY_120330_23}"
			else
				strCondition = strCondition.."\n#{XLZY_120330_22}"
			end
			
			--门派信息
			local nZhiye = Player:GetData("MEMPAI")
			nZhiye = nZhiye + 1
			--PushDebugMessage(tostring(nZhiye))
			if nZhiye >= 1 and nZhiye <= 12 then
				strCondition = strCondition..strZhiyeTip_study[nZhiye]    
			end		
		end
		XiulianStudy_SkillInfo:SetText(XiuLianBookExplain..strCondition);


		XiulianStudy_Demand_Jiaozi:SetProperty("MoneyNumber", tostring(0));

		XiulianStudy_DemandExp_Character_Text:SetText("");
		XiulianStudy_DemandGongli_Character_Text:SetText("")
	else
	    XiulianStudy_SkillIcon : SetActionItem(-1)
	end
end

--===============================================
-- 设置选中状态
--===============================================
function XiulianStudy_SetSelectState()

  	for i=1, 3 do
  	  if(i == XIULIAN_BOOK_SELECT) then
  	       XIULIAN_BOOKS[i]:SetPushed(1)
  	  else
  	       XIULIAN_BOOKS[i]:SetPushed(0)
  	  end
	end
	for i=1, 6 do
		if((XIULIAN_MIJI_SELECT <= 5 and i==XIULIAN_MIJI_SELECT) or
		   (XIULIAN_MIJI_SELECT > 5 and XIULIAN_MIJI_SELECT <= 11 and i == XIULIAN_MIJI_SELECT - 5) or
		   (XIULIAN_MIJI_SELECT > 11 and XIULIAN_MIJI_SELECT <= 15 and i == XIULIAN_MIJI_SELECT - 11)) then
			XIULIAN_MIJI[i]:SetPushed(1);
		else
			XIULIAN_MIJI[i]:SetPushed(0);
		end
	end
end

function XiulianStudy_Frame_On_ResetPos()
  XiulianStudy_Frame:SetProperty("UnifiedPosition", g_XiulianStudy_Frame_UnifiedPosition);
end
