-- 数据池中定义的装备数据.
--HEQUIP_WEAPON		=0,		//武器	WEAPON
--HEQUIP_CAP			=1,		//帽子	DEFENCE
--HEQUIP_ARMOR		=2,		//衣服	DEFENCE
--HEQUIP_CUFF			=3,		//手套	DEFENCE
--HEQUIP_BOOT			=4,		//鞋	DEFENCE
--HEQUIP_SASH			=5,		//腰带	ADORN
--HEQUIP_RING			=6,		//戒指	ADORN
--HEQUIP_NECKLACE	=7,		//项链	ADORN
--HEQUIP_RIDER		=8,		//坐骑	ADORN
--HEQUIP_BAG			=9,		//行囊
--HEQUIP_BOX			=10,	//箱格
--HEQUIP_RING_2		=11,	//第二个戒指	ADORN
--HEQUIP_CHARM		=12,	//护符				ADORN
--HEQUIP_CHARM_2	=13,	//第二个护符	ADORN
--HEQUIP_WRIST		=14,	//护腕				ADORN
--HEQUIP_SHOULDER	=15,	//护肩				DEFENCE
--HEQUIP_DRESS		=16,	//时装				DEFENCE
--HEQUIP_RESERVE	=17,	//暗器
--HEQUIP_RESERVE_2  =18,	//龙纹


--------------------------------------------------------------------------------
-- 装备按钮数据定义
--
local  g_WEAPON;		--武器
local  g_ARMOR;			--衣服
local  g_CAP;				--帽子 
local  g_CUFF;			--手套
local  g_BOOT;			--鞋
local  g_RING;			--戒指
local  g_SASH;			--腰带
local  g_NECKLACE;	--项链
local  g_Dark;			--暗器
local  g_RING_2;		--戒指2
local  g_CHARM;			--护符
local  g_CHARM_2;		--护符2
local  g_WRIST;			--护腕
local  g_SHOULDER;	--护肩
local  g_DRESS;			--时装

local  g_EquipMask ={}
---------------------------------------------------------------------------------
-- 点数定义
--
local g_XiulianTipTable = {"#{XL_XML_90}","#{XL_XML_91}","#{XL_XML_92}","#{XL_XML_93}","#{XL_XML_94}"
							,"#{XL_XML_95}","#{XL_XML_96}","#{XL_XML_97}","#{XL_XML_98}","#{XL_XML_99}"
							,"#{XL_XML_100}"}

local g_RemainPoint 			= 0;	-- 剩余点数
local g_CurExperience 	  = 0;	-- 当前剩余经验
local g_RequireExperience = 0;  -- 升级所需经验
local g_PropertyTable = {}
local g_AddStr = 0;					-- 分配在力量上的剩余点数.
local g_AddSpr = 0;					-- 分配在灵气上的剩余点数.
local g_AddCon = 0;					-- 分配在体质上的剩余点数.
local g_AddInt = 0;					-- 分配在定力上的剩余点数.
local g_AddDex = 0;					-- 分配在身法上的剩余点数.

local g_CurRemainPoint = 0;				-- 分配后的剩余点数

-- 是否打开称号界面
local g_bOpenTitleDlg = 0;
local SELFEQUIP_TAB_TEXT = {};
local LEVEL_MAX_ENABLE =149;	--最大允许等级


--------------------------------------------
-- 提供长按左键进行连加的功能	-- HenryFour@2010-04-16
local g_AutoClick_BtnFlag = -1			-- 记录当前鼠标左键是在哪个按钮按下
local g_AutoClickTimer_Step = 100		-- 多少时间(毫秒)模拟一次 Click 操作
local g_AutoClick_FunList = {}			-- 将公用一个 Timer 的回调功能函数放到一个数组
local g_AutoClick_Going = -1			-- 标志是否开始自动点击操作(第一次LButton后经过X个Timer才算开始, 也就是说是 g_AutoClickTimer_Step * X 的时候开始进行自动加, 这样为了防止本来要点击一下的结果点了好多下)


local GetBase = {
[0] = {{2539,761,761},{1269,380,380},{3809,825,825},{1904,571,571},{1500,650,650},{500,200,200}},
[1] = {{3174,825,825},{1904,444,444},{2539,571,571},{1269,444,444},{1500,750,750},{1000,300,300}},
[2] = {{2539,761,761},{1269,380,380},{3174,761,761},{1904,507,507},{2500,800,800},{1000,400,400}},
[3] = {{1269,444,444},{3174,888,888},{1269,444,444},{2539,761,761},{1500,700,700},{500,250,250}},
[4] = {{1269,380,380},{2539,761,761},{1269,507,507},{2539,825,825},{1500,750,750},{500,200,200}},
[5] = {{1269,444,444},{3174,761,761},{1269,444,444},{3174,888,888},{1000,600,600},{500,300,300}},
[6] = {{1904,634,634},{1904,634,634},{1904,634,634},{1904,634,634},{2500,900,900},{1000,300,300}},
[7] = {{2539,888,888},{1904,761,761},{1904,698,698},{1904,444,444},{2500,800,800},{1000,344,300}},
[8] = {{1904,444,444},{3174,761,761},{1904,507,507},{3174,825,825},{2500,750,750},{1000,300,300}},
[10] = {{1269,444,444},{3174,888,888},{1269,698,698},{2539,507,507},{1500,750,750},{1000,400,350}},
[11] = {{1269,444,444},{3174,825,825},{1269,444,444},{2539,888,888},{1500,850,850},{1000,334,300}},
[12] = {{1269,444,444},{3174,825,825},{1269,444,444},{2539,890,890},{1500,780,780},{1000,350,350}},
[13] = {{3174,825,825},{1904,444,444},{2539,571,571},{1269,444,444},{1500,750,750},{1000,300,300}},
}

function SelfEquip_PreLoad()
	
	-- 打开界面
	this:RegisterEvent("OPEN_EQUIP");
	
	--离开场景，自动关闭
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	
	-- 更新装备
	this:RegisterEvent("REFRESH_EQUIP");
	this:RegisterEvent("GEM_CONTAINER_REFRESH");
	
	this:RegisterEvent("UNIT_HP");
	this:RegisterEvent("UNIT_MAX_HP");
	this:RegisterEvent("UNIT_MP");
	this:RegisterEvent("UNIT_MAX_MP");
	this:RegisterEvent("UNIT_RAGE");			-- 注册怒气
	this:RegisterEvent("UPDATE_ACTION");			-- 注册怒气


	this:RegisterEvent("UNIT_EXP");
	this:RegisterEvent("UNIT_LEVEL");
	this:RegisterEvent("UNIT_MAX_EXP");
	this:RegisterEvent("UNIT_STR");
	this:RegisterEvent("UNIT_SPR");
	this:RegisterEvent("UNIT_CON");
	this:RegisterEvent("UNIT_INT");
	this:RegisterEvent("UNIT_DEX");
	this:RegisterEvent("UNIT_POINT_REMAIN");

	this:RegisterEvent("UNIT_ATT_PHYSICS");
	this:RegisterEvent("UNIT_ATT_MAGIC");
	this:RegisterEvent("UNIT_DEF_PHYSICS");
	this:RegisterEvent("UNIT_DEF_MAGIC");
	this:RegisterEvent("UNIT_HIT");
	this:RegisterEvent("UNIT_MISS");
	this:RegisterEvent("UNIT_CRITICAL_ATTACK");
	this:RegisterEvent("UNIT_CRITICAL_DEFENCE");
	this:RegisterEvent("CUR_TITLE_CHANGED"); 		--当前称号改变
	
	this:RegisterEvent("UNIT_DEF_COLD");				--防御属性
	this:RegisterEvent("UNIT_DEF_FIRE");
	this:RegisterEvent("UNIT_DEF_LIGHT");
	this:RegisterEvent("UNIT_DEF_POSION"); 		
	this:RegisterEvent("UNIT_MENPAI");
		
	this:RegisterEvent("UNIT_ATT_COLD");				--攻击属性
	this:RegisterEvent("UNIT_ATT_FIRE");
	this:RegisterEvent("UNIT_ATT_LIGHT");
	this:RegisterEvent("UNIT_ATT_POSION");
		
	this:RegisterEvent("UNIT_RESISTOTHER_COLD");			--减抗属性
	this:RegisterEvent("UNIT_RESISTOTHER_FIRE");
	this:RegisterEvent("UNIT_RESISTOTHER_LIGHT");
	this:RegisterEvent("UNIT_RESISTOTHER_POSION");
	
	this:RegisterEvent("UNIT_VIGOR");		-- 注册活力值
	this:RegisterEvent("UNIT_ENERGY");	-- 注册精力值
	
	
	this:RegisterEvent("GUILD_SHOW_MYGUILDNAME"); --帮会信息更新
	
	
	-- 手动调整点数成功
	this:RegisterEvent("MANUAL_ATTR_SUCCESS_EQUIP");	

	this:RegisterEvent("UPDATE_DUR");	

	this:RegisterEvent("SEX_CHANGED");	
	this:RegisterEvent("UI_COMMAND");	
end

function SelfEquip_OnLoad()
	
	-- action buttion 按钮
	g_WEAPON   = SelfEquip_11;		--武器
	g_ARMOR    = SelfEquip_12;		--衣服
	g_CAP      = SelfEquip_1;		--帽子 
	g_CUFF     = SelfEquip_4;		--手套
	g_BOOT     = SelfEquip_6;		--鞋
	g_RING     = SelfEquip_7;		--戒指
	g_SASH     = SelfEquip_5;		--腰带
	g_NECKLACE = SelfEquip_13;		--项链
	g_Dark	   = SelfEquip_14;		--暗器
	g_RING_2	 = SelfEquip_8;		--戒指2
	g_CHARM		 = SelfEquip_9;		--护符 
	g_CHARM_2	 = SelfEquip_10;		--护符2	
	g_WRIST		 = SelfEquip_3;		--护腕 		
	g_SHOULDER = SelfEquip_2;		--护肩  
	-- g_DRESS		 = SelfEquip_15;		--时装 		
	
	g_EquipMask[0]	= SelfEquip_11_Mask;
	g_EquipMask[2]	= SelfEquip_12_Mask;
	g_EquipMask[1]	= SelfEquip_1_Mask;
	g_EquipMask[3]	= SelfEquip_4_Mask;
	g_EquipMask[4]	= SelfEquip_6_Mask;
	g_EquipMask[6]	= SelfEquip_7_Mask;
	g_EquipMask[5]	= SelfEquip_5_Mask;
	g_EquipMask[7]	= SelfEquip_13_Mask;
	g_EquipMask[8]	= SelfEquip_14_Mask;
	g_EquipMask[11]	= SelfEquip_8_Mask;
	g_EquipMask[12]	= SelfEquip_9_Mask;
	g_EquipMask[13]	= SelfEquip_10_Mask;
	g_EquipMask[14]	= SelfEquip_3_Mask;
	g_EquipMask[15]	= SelfEquip_2_Mask;
	-- g_EquipMask[16]	= SelfEquip_15_Mask;

    g_PropertyTable[1] = SelfEquip_Str_Plus;
    g_PropertyTable[2] = SelfEquip_Nimbus_Plus;
    g_PropertyTable[3] = SelfEquip_PhysicalStrength_Plus;
    g_PropertyTable[4] = SelfEquip_Stability_Plus;
    g_PropertyTable[5] = SelfEquip_Footwork_Plus;
    g_PropertyTable[6] = SelfEquip_Perporty1_Plus;
    g_PropertyTable[7] = SelfEquip_Perporty2_Plus;
    g_PropertyTable[8] = SelfEquip_Perporty3_Plus;
    g_PropertyTable[9] = SelfEquip_Perporty4_Plus;
    g_PropertyTable[10] = SelfEquip_Perporty7_Plus;
    g_PropertyTable[11] = SelfEquip_Perporty6_Plus;
	g_AutoClick_Going = -1
	g_AutoClick_BtnFlag = -1
	g_AutoClick_FunList[1] = SelfEquip_Add1_Click
	g_AutoClick_FunList[2] = SelfEquip_Add2_Click
	g_AutoClick_FunList[3] = SelfEquip_Add3_Click
	g_AutoClick_FunList[4] = SelfEquip_Add4_Click
	g_AutoClick_FunList[5] = SelfEquip_Add5_Click
	g_AutoClick_FunList[6] = SelfEquip_Dec1_Click
	g_AutoClick_FunList[7] = SelfEquip_Dec2_Click
	g_AutoClick_FunList[8] = SelfEquip_Dec3_Click
	g_AutoClick_FunList[9] = SelfEquip_Dec4_Click
	g_AutoClick_FunList[10] = SelfEquip_Dec5_Click
	SELFEQUIP_TAB_TEXT = {
		[0] = "装备",
		"资料",
		"珍兽",
		-- "骑乘",
		"其他",
	};
end

-- OnEvent
function SelfEquip_OnEvent(event)
	-- 显示tooltip
	SelfEquip_SetStateTooltip();

	if ( event == "OPEN_EQUIP" ) then
		if(this:IsVisible()) then
			SelfEquip_Close();
			return;
		end
		if(IsWindowShow("NewExterior_Facestyle")) then
			CloseWindow("NewExterior_Facestyle", true)
		end
		if(IsWindowShow("NewExterior_HairStyle")) then
			CloseWindow("NewExterior_HairStyle", true)
		end
		if(IsWindowShow("NewExterior_PetSoul")) then
			CloseWindow("NewExterior_PetSoul", true)
		end
		if(IsWindowShow("NewExterior_PlayerFrame")) then
			CloseWindow("NewExterior_PlayerFrame", true)
		end
		if(IsWindowShow("NewExterior_Ride")) then
			CloseWindow("NewExterior_Ride", true)
		end
		if(IsWindowShow("NewExterior_Weapon")) then
			CloseWindow("NewExterior_Weapon", true)
		end
		if(IsWindowShow("NewExterior_Weapon_Levelup")) then
			CloseWindow("NewExterior_Weapon_Levelup", true)
		end
		if(IsWindowShow("NewExterior_DressBox")) then
			CloseWindow("NewExterior_DressBox", true)
		end
		if(IsWindowShow("DressPaint")) then
			CloseWindow("DressPaint", true)
		end
		SelfEquip_Open();
		SelfEquip_BaiBingJingTong:Hide()
		SelfEquip_FakeObject:SetFakeObject("Player");	
		local selfUnionPos = Variable:GetVariable("SelfUnionPos");
		if(selfUnionPos ~= nil) then
			SelfEquip_Frame:SetProperty("UnifiedPosition", selfUnionPos);
		end
			
		Equip_OnUpdateShow();
		Equip_RefreshEquip();
		
		--在打开的时候，将属性页的缺省页进行调整
		SelfEquip_SelfEquip:SetCheck(1);
		SelfEquip_SelfData:SetCheck(0);
		SelfEquip_Pet:SetCheck(0);
		
		-- 显示精力
		SelfEquip_ShowVigor();
		
		-- 显示活力
		SelfEquip_ShowEnergy();
		SelfEquip_SetTabColor(0);
	end
    if ( event == "GEM_CONTAINER_REFRESH" ) then
		Equip_RefreshEquip()
        return
    end	
	if( event == "PLAYER_LEAVE_WORLD") then
		SelfEquip_Close();
		return;
	end
	if( event == "UPDATE_ACTION") then
		Equip_RefreshEquip();
		return;
	end--[[	
	if("CUR_TITLE_CHANGED" == event) then
		GetCurTitle();
		return;
	end

	if(event == "GUILD_SHOW_MYGUILDNAME") then
		GetGuildTitle();
		return;
	end
--]]
	-- 装备变化时刷新装备.
	if("REFRESH_EQUIP" == event) then 
		Equip_RefreshEquip();
		return;
	end
	
	if("MANUAL_ATTR_SUCCESS_EQUIP" == event) then
	
		-- 分配属性成功.
		SelfEquip_ManualAttr_Success();
		--AxTrace( 0,0, "even  分配点数成功 ====  "..tostring(event));
		
		-- 设置手动调节点数按钮的状态.
		SetAcceptButtonState();
		
		Equip_OnUpdateShow();
		return;
	end
	
	--以下事件限于窗口打开时
	if(this:IsVisible()) then
		
		local nNumber=0;
		local nMaxnumber=0;
		local strName;
		--AxTrace( 0,0, "even ===="..tostring(event));
		-- 等级
		if ((event == "UNIT_LEVEL" or event == "UNIT_MAX_EXP") and arg0 == "player") then
			--nNumber = Player:GetData( "LEVEL" );
			--SelfEquip_Level:SetText( "Level " .. tostring( nNumber ) );
			--nNumber = Player:GetData("NEEDEXP");
			--SelfEquip_Exp1:SetText( tostring( nNumber ) );
			-- 刷新所有信息
			Equip_OnUpdateShow();
			
		-- 血
		elseif((event == "UNIT_HP" or event == "UNIT_MAX_HP")  and arg0 == "player") then
			nNumber = Player:GetData("HP");
			nMaxnumber = Player:GetData( "MAXHP" );
			
			local strHpText = tostring( nNumber ).."/"..tostring( nMaxnumber );
			strHpText = "#cFAFFA4"..strHpText;  
			SelfEquip_HP:SetText( strHpText );
		-- mana
		elseif((event == "UNIT_MP" or event == "UNIT_MAX_MP")  and arg0 == "player") then
			nNumber = Player:GetData( "MP" );
			nMaxnumber = Player:GetData( "MAXMP" );
			
			local strMpText = tostring( nNumber ).."/"..tostring( nMaxnumber ) ;
			strMpText = "#cFAFFA4"..strMpText;  
			SelfEquip_MP:SetText( strMpText );
			
		-- 怒气
		elseif((event == "UNIT_RAGE" )  and arg0 == "player") then
			-- 怒气
		  nNumber = Player:GetData("RAGE");
		  nMaxnumber = Player:GetData("MAXRAGE");
		  
		  local strRageText = tostring( nNumber ).."/"..tostring( nMaxnumber );
		  strRageText = "#cFAFFA4"..strRageText;  
			SelfEquip_SP:SetText(strRageText );
		--经验值
		elseif(event == "UNIT_EXP" and arg0 == "player") then
			nNumber = Player:GetData("EXP");
			SelfEquip_Exp2:SetText( "#cC8B88E"..tostring( nNumber ) );
		
			-- 得到升级需要的经验
			g_RequireExperience = Player:GetData("NEEDEXP");
			SelfEquip_Exp1:SetText( "#cC8B88E"..tostring( g_RequireExperience ) );
			
			-- 根据经验禁止或者打开升级
			if(nNumber >= g_RequireExperience and tonumber(Player:GetData("LEVEL"))<LEVEL_MAX_ENABLE) then
			
				SelfEquip_UpLevel:Enable();
			else
			
				SelfEquip_UpLevel:Disable();
			end
	

		--STR
		elseif(event == "UNIT_STR" and arg0 == "player") then
			nNumber = Player:GetData("STR");
			SelfEquip_Str:SetText( tostring( nNumber ) );
		
		--SPR
		elseif(event == "UNIT_SPR" and arg0 == "player") then
			nNumber = Player:GetData("SPR");
			SelfEquip_Nimbus:SetText( tostring( nNumber ) );

		--CON
		elseif(event == "UNIT_CON" and arg0 == "player") then
			nNumber = Player:GetData("CON");
			SelfEquip_PhysicalStrength:SetText( tostring( nNumber ) );

		--INT
		elseif(event == "UNIT_INT" and arg0 == "player") then
			nNumber = Player:GetData("INT");
			SelfEquip_Stability:SetText( tostring( nNumber ) );

		--DEX
		elseif(event == "UNIT_DEX" and arg0 == "player") then
			nNumber = Player:GetData("DEX");
			SelfEquip_Footwork:SetText( tostring( nNumber ) );

		--POINT_REMAIN
		elseif(event == "POINT_REMAIN" and arg0 == "player") then
			nNumber = Player:GetData("POINT_REMAIN");
			SelfEquip_Potential:SetText( tostring( nNumber ) );
			g_CurRemainPoint = nNumber;
			g_RemainPoint    = nNumber;
			
			DisablePointAddButtion();
			if(g_CurRemainPoint > 0) then
				EanblePointAddButtion();
			end
			
			-- 设置手动调节点数按钮的状态.
			SetAcceptButtonState();
	
		--ATT_PHYSICS
		elseif(event == "UNIT_ATT_PHYSICS" and arg0 == "player") then
			nNumber = Player:GetData("ATT_PHYSICS");
			SelfEquip_Perporty1:SetText( tostring( nNumber ) );

		--DEF_PHYSICS
		elseif(event == "UNIT_DEF_PHYSICS" and arg0 == "player") then
			nNumber = Player:GetData("DEF_PHYSICS");
			if nNumber > 999999 then --为帮战修改的 modified by hukai
				SelfEquip_Perporty3:SetText( "??????" );
			else
				SelfEquip_Perporty3:SetText( tostring( nNumber ) );
			end

		--ATT_MAGIC
		elseif(event == "UNIT_ATT_MAGIC" and arg0 == "player") then
			nNumber = Player:GetData("ATT_MAGIC");
			SelfEquip_Perporty2:SetText( tostring( nNumber ) );

		--DEF_MAGIC
		elseif(event == "UNIT_DEF_MAGIC" and arg0 == "player") then
			nNumber = Player:GetData("DEF_MAGIC");
			if nNumber > 999999 then --为帮战修改的 modified by hukai
				SelfEquip_Perporty4:SetText( "??????" );
			else
				SelfEquip_Perporty4:SetText( tostring( nNumber ) );
			end

		--UNIT_HUIXINFANGYU
--		elseif(event == "UNIT_MISS" and arg0 == "player") then
--			nNumber = Player:GetData("MISS");
--			SelfEquip_Perporty5:SetText( tostring( nNumber ) );

		--UNIT_MISS
		elseif(event == "UNIT_MISS" and arg0 == "player") then
			nNumber = Player:GetData("MISS");
			SelfEquip_Perporty6:SetText( tostring( nNumber ) );

		--UNIT_HIT
		elseif(event == "UNIT_HIT" and arg0 == "player") then
			nNumber = Player:GetData("HIT");
			SelfEquip_Perporty7:SetText( tostring( nNumber ) );

		--UNIT_CRITICAL_ATTACK
		elseif(event == "UNIT_CRITICAL_ATTACK" and arg0 == "player") then
			nNumber = Player:GetData("CRITICALATTACK");
			SelfEquip_Perporty8:SetText( tostring( nNumber ) );

		--UNIT_CRITICAL_DEFENCE
		elseif(event == "UNIT_CRITICAL_DEFENCE" and arg0 == "player") then
			nNumber = Player:GetData("CRITICALDEFENCE");
			SelfEquip_Perporty9:SetText( tostring( nNumber ) );

		--冰防御
		elseif(event == "UNIT_DEF_COLD" and arg0 == "player") then
			SelfEquip_SetStateTooltip();	
			
		--火防御
		elseif(event == "UNIT_DEF_FIRE" and arg0 == "player") then
			SelfEquip_SetStateTooltip();
			
		--电防御
		elseif(event == "UNIT_DEF_LIGHT" and arg0 == "player") then
			SelfEquip_SetStateTooltip();
			
		--毒防御
		elseif(event == "UNIT_DEF_POSION" and arg0 == "player") then
			SelfEquip_SetStateTooltip();
				
		--减冰抗
		elseif(event == "UNIT_RESISTOTHER_COLD" and arg0 == "player") then
			SelfEquip_SetStateTooltip();	
			
		--减火抗
		elseif(event == "UNIT_RESISTOTHER_FIRE" and arg0 == "player") then
			SelfEquip_SetStateTooltip();
			
		--减电抗
		elseif(event == "UNIT_RESISTOTHER_LIGHT" and arg0 == "player") then
			SelfEquip_SetStateTooltip();
			
		--减毒抗
		elseif(event == "UNIT_RESISTOTHER_POSION" and arg0 == "player") then
			SelfEquip_SetStateTooltip();
		
		--冰攻击
		elseif(event == "UNIT_ATT_COLD" and arg0 == "player") then
			SelfEquip_SetStateTooltip();	
		--火攻击
		elseif(event == "UNIT_ATT_FIRE" and arg0 == "player") then
			SelfEquip_SetStateTooltip();
		--电攻击
		elseif(event == "UNIT_ATT_LIGHT" and arg0 == "player") then
			SelfEquip_SetStateTooltip();
		--毒攻击
		elseif(event == "UNIT_ATT_POSION" and arg0 == "player") then
			SelfEquip_SetStateTooltip();
				
		elseif(event == "UNIT_VIGOR" and arg0 == "player") then
		
			SelfEquip_ShowVigor();
			
		elseif(event == "UNIT_ENERGY" and arg0 == "player") then
			
			SelfEquip_ShowEnergy();
		elseif( event == "UPDATE_DUR" ) then
			SelfEquip_UpdateMask();
		else
			
			-- 不要默认的情况下调用这个函数， 会造成属性点数莫名其妙的刷新。
			-- 2006-3-23
			--Equip_OnUpdateShow();
		end;
		
		if event == "SEX_CHANGED"  then
			SelfEquip_FakeObject : Hide();
			SelfEquip_FakeObject : Show();
			SelfEquip_FakeObject:SetFakeObject("Player");
		end
		return;
	end

	-- 其它事件都更新人物的基本信息.
	--Equip_OnUpdateShow();
		
end

-- 更新主角基本信息
function Equip_OnUpdateShow()
	
	
		
	g_RemainPoint 			= 0;	-- 剩余点数
	g_CurExperience 	  = 0;	-- 当前剩余经验
	g_RequireExperience = 0;  -- 升级所需经验

	g_AddStr = 0;					-- 分配在力量上的剩余点数.
	g_AddSpr = 0;					-- 分配在灵气上的剩余点数.
	g_AddCon = 0;					-- 分配在体质上的剩余点数.
	g_AddInt = 0;					-- 分配在定力上的剩余点数.
	g_AddDex = 0;					-- 分配在身法上的剩余点数.
	g_CurRemainPoint = 0;	-- 分配后的剩余点数
	
	
	local nNumber=0;
	local nMaxnumber=0;
	local strName;
	
	-- 禁止增加潜能按钮.
	Equip_Addition_Button1:Disable();
	Equip_Decrease_Button1:Disable();
	
	Equip_Addition_Button2:Disable();
	Equip_Decrease_Button2:Disable();
	
	Equip_Addition_Button3:Disable();
	Equip_Decrease_Button3:Disable();
	
	Equip_Addition_Button4:Disable();
	Equip_Decrease_Button4:Disable();
	
	Equip_Addition_Button5:Disable();
	Equip_Decrease_Button5:Disable();
	
	-- 允许按钮
	-- SelfEquip_Accept:Enalbe();
	
	-- 禁止增加按钮
	-- SelfEquip_Accept:Disable();
	
	-- 得到自己的名字
  strName = Player:GetName();
	SelfEquip_PageHeader:SetText("#gFF0FA0".. strName );
	
	-- 得到血值	
	nNumber = Player:GetData("HP");
	nMaxnumber = Player:GetData( "MAXHP" );
	local HPText = tostring( nNumber ).."/"..tostring( nMaxnumber );
	HPText = "#cFAFFA4"..HPText;  
	SelfEquip_HP:SetText( HPText );
		

	-- 得到魔法值
	nNumber = Player:GetData( "MP" );
	nMaxnumber = Player:GetData( "MAXMP" );
	
	local MPText = tostring( nNumber ).."/"..tostring( nMaxnumber );
	MPText = "#cFAFFA4"..MPText;  
	SelfEquip_MP:SetText( MPText );

	-- 怒气
  nNumber = Player:GetData("RAGE");
  nMaxnumber = Player:GetData("MAXRAGE");
  local RageText = tostring( nNumber ).."/"..tostring( nMaxnumber );
  RageText = "#cFAFFA4"..RageText;  
 	SelfEquip_SP:SetText( RageText );

	-- 得到当前经验
	g_CurExperience = Player:GetData("EXP");
	local CurExpText = tostring( g_CurExperience );
	CurExpText = "#cC8B88E"..CurExpText;  
	SelfEquip_Exp2:SetText( CurExpText );
	
	-- 得到升级需要的经验
	g_RequireExperience = Player:GetData("NEEDEXP");
	local NeedExpText =  tostring( g_RequireExperience );
	NeedExpText = "#cC8B88E"..NeedExpText;  
	SelfEquip_Exp1:SetText( NeedExpText );
	
	-- 根据经验禁止或者打开升级
	if(g_CurExperience >= g_RequireExperience) then
	
		SelfEquip_UpLevel:Enable();
	else
	
		SelfEquip_UpLevel:Disable();
	end
	
	-- 得到等级
	nNumber = Player:GetData( "LEVEL" );
	local LevelText = tostring( nNumber ).." 级";
	LevelText = "#cC8B88E"..LevelText;  
	SelfEquip_Level:SetText( LevelText );
	
	-- 如果等级大于某值禁止按钮.
	if( LEVEL_MAX_ENABLE <= nNumber ) then
		SelfEquip_UpLevel:Disable();
	end
  
  -- 力量
  nNumber = Player:GetData("STR");
  local StrText = tostring( nNumber );
  --StrText = "#DED784"..StrText;  
	SelfEquip_Str:SetText( StrText );
	
	-- 灵气
  nNumber = Player:GetData("SPR");
  local SprText = tostring( nNumber );
  --SprText = "#DED784"..SprText;  
	SelfEquip_Nimbus:SetText( SprText );
		
	-- 体质
	nNumber = Player:GetData("CON");
	local ConText = tostring( nNumber );
	SelfEquip_PhysicalStrength:SetText( ConText );
		 
	
	-- 定力
	nNumber = Player:GetData("INT");
	SelfEquip_Stability:SetText( tostring( nNumber ) );
	
	-- 身法
	nNumber = Player:GetData("DEX");
	SelfEquip_Footwork:SetText( tostring( nNumber ) );
	
	-- 剩余点数
	g_RemainPoint = Player:GetData("POINT_REMAIN");
	SelfEquip_Potential:SetText( tostring( g_RemainPoint ) );
	--AxTrace( 0,0, "得到剩余点数"..tostring( g_RemainPoint ));
	g_CurRemainPoint = g_RemainPoint;
	
	if(g_CurRemainPoint > 0) then
	
		Equip_Addition_Button1:Enable();
		Equip_Addition_Button2:Enable();
		Equip_Addition_Button3:Enable();
		Equip_Addition_Button4:Enable();
		Equip_Addition_Button5:Enable();
		
	end;

	
	-- 物理攻击
	nNumber = Player:GetData("ATT_PHYSICS");
	SelfEquip_Perporty1:SetText( tostring( nNumber ) );
	
	-- 物理防御
	nNumber = Player:GetData("DEF_PHYSICS");
	if nNumber > 999999 then --为帮战修改的 modified by hukai
		SelfEquip_Perporty3:SetText( "??????" );
	else
		SelfEquip_Perporty3:SetText( tostring( nNumber ) );
	end
	
	-- 魔法攻击
	nNumber = Player:GetData("ATT_MAGIC");
	SelfEquip_Perporty2:SetText( tostring( nNumber ) );
	
	-- 魔法防御
	nNumber = Player:GetData("DEF_MAGIC");
	if nNumber > 999999 then --为帮战修改的 modified by hukai
		SelfEquip_Perporty4:SetText( "??????" );
	else
		SelfEquip_Perporty4:SetText( tostring( nNumber ) );
	end
	
	-- 闪避率
	nNumber = Player:GetData("MISS");
	SelfEquip_Perporty6:SetText( tostring( nNumber ) );
	
	-- 命中率
	nNumber = Player:GetData("HIT");
	SelfEquip_Perporty7:SetText( tostring( nNumber ) );
	
	-- 会心攻击
	nNumber = Player:GetData("CRITICALATTACK");
	SelfEquip_Perporty8:SetText( tostring( nNumber ) );

	-- 会心防御
	nNumber = Player:GetData("CRITICALDEFENCE");
	SelfEquip_Perporty9:SetText( tostring( nNumber ) );
	if Lua_GetXiuLianData("XIULIANFLAG") > 0 then
		nNumber = Lua_GetXiuLianData("XIULIAN_STR");
		local StrText = "#H+" .. tostring( nNumber );
		SelfEquip_Str_Plus:SetText( StrText );

		nNumber = Lua_GetXiuLianData("XIULIAN_SPR");
		local StrText = "#H+" .. tostring( nNumber );
		SelfEquip_Nimbus_Plus:SetText( StrText );

		nNumber = Lua_GetXiuLianData("XIULIAN_CON");
		local StrText = "#H+" .. tostring( nNumber );
		SelfEquip_PhysicalStrength_Plus:SetText( StrText );

		nNumber = Lua_GetXiuLianData("XIULIAN_INT");
		local StrText = "#H+" .. tostring( nNumber );
		SelfEquip_Stability_Plus:SetText( StrText );

		nNumber = Lua_GetXiuLianData("XIULIAN_DEX");
		local StrText = "#H+" .. tostring( nNumber );
		SelfEquip_Footwork_Plus:SetText( StrText );

		nNumber = Lua_GetXiuLianData("XIULIAN_HIT");
		local StrText = "#H+" .. tostring( nNumber );
		SelfEquip_Perporty7_Plus:SetText( StrText );

		nNumber = Lua_GetXiuLianData("XIULIAN_ATTP");
		local StrText = "#H+" .. tostring( nNumber );
		SelfEquip_Perporty1_Plus:SetText( StrText );

		nNumber = Lua_GetXiuLianData("XIULIAN_DEFP");
		local StrText = "#H+" .. tostring( nNumber );
		SelfEquip_Perporty3_Plus:SetText( StrText );

		nNumber = Lua_GetXiuLianData("XIULIAN_ATTM");
		local StrText = "#H+" .. tostring( nNumber );
		SelfEquip_Perporty2_Plus:SetText( StrText );

		nNumber = Lua_GetXiuLianData("XIULIAN_DEFM");
		local StrText = "#H+" .. tostring( nNumber );
		SelfEquip_Perporty4_Plus:SetText( StrText );

		nNumber = Lua_GetXiuLianData("XIULIAN_MISS");
		local StrText = "#H+" .. tostring( nNumber );
		SelfEquip_Perporty6_Plus:SetText( StrText );
	else
		SelfEquip_Str_Plus:SetText( "" );
		SelfEquip_Nimbus_Plus:SetText( "" );
		SelfEquip_PhysicalStrength_Plus:SetText( "" );
		SelfEquip_Stability_Plus:SetText( "" );
		SelfEquip_Footwork_Plus:SetText( "" );
		SelfEquip_Perporty7_Plus:SetText( "" );
		SelfEquip_Perporty1_Plus:SetText( "" );
		SelfEquip_Perporty3_Plus:SetText( "" );
		SelfEquip_Perporty2_Plus:SetText( "" );
		SelfEquip_Perporty4_Plus:SetText( "" );
		SelfEquip_Perporty6_Plus:SetText( "" );
	end
	-- 活力
	SelfEquip_ShowVigor();
	
	-- 精力
	SelfEquip_ShowEnergy();
	
	-- 门派
	local menpai = Player:GetData("MEMPAI");
	local strName = "";
	local nTalent = DataPool:GetPlayerMission_DataRound(480)		
	-- 得到门派名称.
	if(0 == menpai) then
		strName = "少林";
		if nTalent == 1 then
			strName = "少林·罗汉"
		end
		if nTalent == 2 then
			strName = "少林·金刚"
		end
	elseif(1 == menpai) then
		strName = "明教";
		if nTalent == 1 then
			strName = "明教·天罗"
		end
		if nTalent == 2 then
			strName = "明教·血戾"
		end
		
	elseif(2 == menpai) then
		strName = "丐帮";
		if nTalent == 1 then
			strName = "丐帮·酒狂"
		end
		if nTalent == 2 then
			strName = "丐帮·行侠"
		end
		
	elseif(3 == menpai) then
		strName = "武当";
		if nTalent == 1 then
			strName = "武当·凭虚"
		end
		if nTalent == 2 then
			strName = "武当·摘星"
		end
	
	elseif(4 == menpai) then
		strName = "峨嵋";
		if nTalent == 1 then
			strName = "峨嵋·沁芳"
		end
		if nTalent == 2 then
			strName = "峨嵋·清音"
		end
	
	elseif(5 == menpai) then
		strName = "星宿";
		if nTalent == 1 then
			strName = "星宿·寒冥"
		end
		if nTalent == 2 then
			strName = "星宿·九厄"
		end
	
	elseif(6 == menpai) then
		strName = "天龙";
		if nTalent == 1 then
			strName = "天龙·龙威"
		end
		if nTalent == 2 then
			strName = "天龙·菩天"
		end
	
	elseif(7 == menpai) then
		strName = "天山";
		if nTalent == 1 then
			strName = "天山·霜凝"
		end
		if nTalent == 2 then
			strName = "天山·雪隐"
		end
	
	elseif(8 == menpai) then
		strName = "逍遥";
		if nTalent == 1 then
			strName = "逍遥·逸仙"
		end
		if nTalent == 2 then
			strName = "逍遥·明鬼"
		end	
	elseif(9 == menpai) then
		strName = "无门派";
	elseif(10 == menpai) then
		strName = "曼陀山庄";
		if nTalent == 1 then
			strName = "曼陀·昭明"
		end
		if nTalent == 2 then
			strName = "曼陀·晚籁"
		end	
	end
	-- 设置显示的门派.
	SelfEquip_MenPai:SetText(strName);
	
	-- 设置帮会显示
--	GetGuildTitle();
	
	-- 得到称号
--	GetCurTitle();
	
	-- 设置手动调节点数按钮的状态.
	SetAcceptButtonState();
	
end

-- 刷新装备
function Equip_RefreshEquip()
	
	
	--  清空按钮显示图标
	g_WEAPON:SetActionItem(-1);			--武器
	g_CAP:SetActionItem(-1);				--帽子 
	g_ARMOR:SetActionItem(-1);			--盔甲
	g_CUFF:SetActionItem(-1);				--手套
	g_BOOT:SetActionItem(-1);				--鞋
	g_SASH:SetActionItem(-1);				--腰带
	g_RING:SetActionItem(-1);				--戒指
	g_NECKLACE:SetActionItem(-1);		--项链
	g_Dark:SetActionItem(-1);			--暗器
	g_RING_2:SetActionItem(-1);			--戒指2	  
	g_CHARM:SetActionItem(-1);			--护符		
	g_CHARM_2:SetActionItem(-1);		--护符2
	g_WRIST:SetActionItem(-1);			--护腕	
	g_SHOULDER:SetActionItem(-1);		--护肩
	-- g_DRESS:SetActionItem(-1);			--时装	
	
	local ActionWeapon 		= EnumAction(0, "equip");
	local ActionCap    		= EnumAction(1, "equip");
	local ActionArmor  		= EnumAction(16, "equip");
	local ActionCuff   		= EnumAction(3, "equip");
	local ActionBoot   		= EnumAction(4, "equip");
	local ActionSash   		= EnumAction(5, "equip");
	local ActionRing    	= EnumAction(6, "equip");
	local ActionNecklace	= EnumAction(7, "equip");
	local ActionMount			= EnumAction(17, "equip");
	local ActionRing_2		= EnumAction(11, "equip");
	local ActionCharm 		= EnumAction(12, "equip");
	local ActionCharm_2   = EnumAction(13, "equip");
	local ActionWrist  		= EnumAction(14, "equip");
	local ActionShoulder  = EnumAction(15, "equip");
	local ActionDress   	= EnumAction(2, "equip");

	-- 显示人身上的武器装备
	g_WEAPON:SetActionItem(ActionWeapon:GetID());			--武器
	g_CAP:SetActionItem(ActionCap:GetID());						--帽子 
	g_ARMOR:SetActionItem(ActionArmor:GetID());				--盔甲
	g_CUFF:SetActionItem(ActionCuff:GetID());					--护腕
	g_BOOT:SetActionItem(ActionBoot:GetID());					--鞋
	g_SASH:SetActionItem(ActionSash:GetID());					--腰带
	g_RING:SetActionItem(ActionRing:GetID());					--戒子
	g_NECKLACE:SetActionItem(ActionNecklace:GetID());	--项链
	g_Dark:SetActionItem(ActionMount:GetID());				--暗器
	g_RING_2:SetActionItem(ActionRing_2:GetID());			--戒指2	  
	g_CHARM:SetActionItem(ActionCharm:GetID());			--护符		
	g_CHARM_2:SetActionItem(ActionCharm_2:GetID());		--护符2
	g_WRIST:SetActionItem(ActionWrist:GetID());			--护腕	
	g_SHOULDER:SetActionItem(ActionShoulder:GetID());		--护肩
	-- g_DRESS:SetActionItem(ActionDress:GetID());			--时装	
	SystemSetup:Set_Display_Dress(1)
	SelfEquip_UpdateMask();
end

function SelfEquip_Equip_Click( nTypeIn,buttonIn )

	local nType = tonumber( nTypeIn );
	local button = tonumber( buttonIn );
	if( nType == 11 ) then
		if( button == 1 ) then
			g_WEAPON:DoAction();	--武器
		else
			g_WEAPON:DoSubAction();	--武器
		end
	elseif( nType == 12 ) then
		if( button == 1 ) then
			g_ARMOR:DoAction();	--衣服
		else
			g_ARMOR:DoSubAction();	--衣服
		end
	elseif( nType == 1 ) then
		if( button == 1 ) then
			g_CAP:DoAction();	--帽子
		else
			g_CAP:DoSubAction();	--帽子
		end
	elseif( nType == 4 ) then
		if( button == 1 ) then
			g_CUFF:DoAction();	--手套
		else
			g_CUFF:DoSubAction();	--手套
		end		
	elseif( nType == 6 ) then
		if( button == 1 ) then
			g_BOOT:DoAction();	--鞋
		else
			g_BOOT:DoSubAction();	--鞋
		end
	elseif( nType == 7 ) then
		if( button == 1 ) then
			g_RING:DoAction();	--戒指
		else
			g_RING:DoSubAction();	--戒指
		end
	elseif( nType == 5 ) then
		if( button == 1 ) then
			g_SASH:DoAction();	--腰带
		else
			g_SASH:DoSubAction();	--腰带
		end
	elseif( nType == 13) then
		if( button == 1 ) then
			g_NECKLACE:DoAction();	--项链
		else
			g_NECKLACE:DoSubAction();	--项链
		end
	elseif( nType == 14 ) then
		if( button == 1 ) then
			g_Dark:DoAction();	--暗器
		else
			g_Dark:DoSubAction();	--暗器
		end
	elseif( nType == 2 ) then
		if( button == 1 ) then
			g_SHOULDER:DoAction();	--护肩
		else
			g_SHOULDER:DoSubAction();	--护肩
		end
	elseif( nType == 3 ) then
		if( button == 1 ) then
			g_WRIST:DoAction();	--护腕
		else
			g_WRIST:DoSubAction();	--护腕
		end
	elseif( nType == 8 ) then
		if( button == 1 ) then
			g_RING_2:DoAction();	--戒指2
		else
			g_RING_2:DoSubAction();	--戒指
		end
	elseif( nType == 9 ) then
		if( button == 1 ) then
			g_CHARM:DoAction();	--护符
		else
			g_CHARM:DoSubAction();	--护符
		end
	elseif( nType == 10 ) then
		if( button == 1 ) then
			g_CHARM_2:DoAction();	--护符2
		else
			g_CHARM_2:DoSubAction();	--护符2
		end		
	elseif( nType == 15 ) then
		if( button == 1 ) then
			-- g_DRESS:DoAction();	--时装
		else
			-- g_DRESS:DoSubAction();	--时装
		end
	end
end


----------------------------------------------------------------------------
-- 力量点数按钮
--
-- 减少力量点数按钮
function SelfEquip_Dec1_Click()

	if (g_AddStr > 0) then
		g_CurRemainPoint = g_CurRemainPoint + 1;
		if(g_CurRemainPoint > 0) then
			EanblePointAddButtion();
		end;

		g_AddStr = g_AddStr - 1;
	end

	if(g_AddStr <= 0) then
		g_AddStr = 0;
		Equip_Decrease_Button1:Disable();
	end
	
	-- 显示当前剩余的点数
	ShowCurRemainPoint();
	
	-- 设置剩余点数按钮状态
	SetAcceptButtonState();
	
	-- 显示力量
	ShowCurStr();
	
end

-- 增加力量点数按钮
function SelfEquip_Add1_Click()

	if (g_CurRemainPoint > 0) then
		g_AddStr = g_AddStr + 1;
		if(g_AddStr > 0) then
			Equip_Decrease_Button1:Enable();
		end

		g_CurRemainPoint = g_CurRemainPoint - 1;
	end

	if(g_CurRemainPoint <= 0) then
		g_CurRemainPoint = 0;
		DisablePointAddButtion();
	end
	
	-- 显示当前剩余的点数
	ShowCurRemainPoint();
	
	-- 设置剩余点数按钮状态
	SetAcceptButtonState();
	
	-- 显示力量
	ShowCurStr();
	
end


-----------------------------------------------------------------------------
-- 灵气点数按钮
--
-- 减少灵气点数按钮
function SelfEquip_Dec2_Click()

	if (g_AddSpr > 0) then
		g_CurRemainPoint = g_CurRemainPoint + 1;
		if(g_CurRemainPoint > 0) then
			EanblePointAddButtion();
		end

		g_AddSpr = g_AddSpr - 1;
	end

	if(g_AddSpr <= 0) then
			
		g_AddSpr = 0;
		Equip_Decrease_Button2:Disable();
	end
	
	-- 显示当前剩余的点数
	ShowCurRemainPoint();
	
	-- 设置剩余点数按钮状态
	SetAcceptButtonState();
	
	-- 显示灵气
	ShowCurSpr();
	
end

-- 增加灵气点数按钮
function SelfEquip_Add2_Click()

	if (g_CurRemainPoint > 0) then
		g_AddSpr = g_AddSpr + 1;
		if(g_AddSpr > 0) then
			Equip_Decrease_Button2:Enable();
		end

		g_CurRemainPoint = g_CurRemainPoint - 1;
	end

	if(g_CurRemainPoint <= 0) then
		g_CurRemainPoint = 0;
		DisablePointAddButtion();
	end
	
	-- 显示当前剩余的点数
	ShowCurRemainPoint();
	
	-- 设置剩余点数按钮状态
	SetAcceptButtonState();
	
	-- 显示灵气
	ShowCurSpr();
	
end


-----------------------------------------------------------------------------
-- 体质点数按钮
--
-- 减少体质点数按钮
function SelfEquip_Dec3_Click()

	if (g_AddCon > 0) then
		g_CurRemainPoint = g_CurRemainPoint + 1;
		if(g_CurRemainPoint > 0) then
			EanblePointAddButtion();
		end

		g_AddCon = g_AddCon - 1;
	end

	if(g_AddCon <= 0) then
			
		g_AddCon = 0;
		Equip_Decrease_Button3:Disable();
	end
	
	-- 显示当前剩余的点数
	ShowCurRemainPoint();
	
	-- 设置剩余点数按钮状态
	SetAcceptButtonState();
	
	-- 显示体质
	ShowCurCon();
	
	
end

-- 增加体质点数按钮
function SelfEquip_Add3_Click()

	if (g_CurRemainPoint > 0) then
		g_AddCon = g_AddCon + 1;
		if(g_AddCon > 0) then
			Equip_Decrease_Button3:Enable();
		end

		g_CurRemainPoint = g_CurRemainPoint - 1;
	end

	if(g_CurRemainPoint <= 0) then
		g_CurRemainPoint = 0;
		DisablePointAddButtion();
	end
	
	-- 显示当前剩余的点数
	ShowCurRemainPoint();
	
	-- 设置剩余点数按钮状态
	SetAcceptButtonState();
	
	-- 显示体质
	ShowCurCon();
	
end


-------------------------------------------------------------------------------
-- 定力点数按钮
--
-- 减少定力点数按钮
function SelfEquip_Dec4_Click()

	if (g_AddInt > 0) then
		g_CurRemainPoint = g_CurRemainPoint + 1;
		if(g_CurRemainPoint > 0) then
			EanblePointAddButtion();
		end

		g_AddInt = g_AddInt - 1;
	end

	if(g_AddInt <= 0) then
			
		g_AddInt = 0;
		Equip_Decrease_Button4:Disable();
	end
	
	-- 显示当前剩余的点数
	ShowCurRemainPoint();
	
	-- 设置剩余点数按钮状态
	SetAcceptButtonState();
	
	-- 显示定力
	ShowCurInt();
	
end

-- 增加定力点数按钮
function SelfEquip_Add4_Click()

	if (g_CurRemainPoint > 0) then
		g_AddInt = g_AddInt + 1;
		if(g_AddInt > 0) then
			Equip_Decrease_Button4:Enable();
		end

		g_CurRemainPoint = g_CurRemainPoint - 1;
	end

	if(g_CurRemainPoint <= 0) then
	
		g_CurRemainPoint = 0;
		DisablePointAddButtion();
	end
	
	-- 显示当前剩余的点数
	ShowCurRemainPoint();
	
	-- 设置剩余点数按钮状态
	SetAcceptButtonState();
	
	-- 显示定力
	ShowCurInt();
	
end



--------------------------------------------------------------------------------
-- 身法点数按钮
--
-- 减少身法点数按钮
function SelfEquip_Dec5_Click()

	if (g_AddDex > 0) then
		g_CurRemainPoint = g_CurRemainPoint + 1;
		if(g_CurRemainPoint > 0) then
			EanblePointAddButtion();
		end

		g_AddDex = g_AddDex - 1;
	end

	if(g_AddDex <= 0) then
			
		g_AddDex = 0;
		Equip_Decrease_Button5:Disable();
	end
	
	-- 显示当前剩余的点数
	ShowCurRemainPoint();
	
	-- 设置剩余点数按钮状态
	SetAcceptButtonState();
	
	-- 显示身法
	ShowCurDex();
	
end

-- 增加身法点数按钮
function SelfEquip_Add5_Click()

	if (g_CurRemainPoint > 0) then
		g_AddDex = g_AddDex + 1;
		if(g_AddDex > 0) then
			Equip_Decrease_Button5:Enable();
		end

		g_CurRemainPoint = g_CurRemainPoint - 1;
	end

	if(g_CurRemainPoint <= 0) then
	
		g_CurRemainPoint = 0;
		DisablePointAddButtion();
	end
	
	-- 显示当前剩余的点数
	ShowCurRemainPoint();
	
	-- 设置剩余点数按钮状态
	SetAcceptButtonState();
	
	-- 显示身法
	ShowCurDex();
	
end

--------------------------------------------------------------------------------
--
-- 打开所有的点数增加按钮
--
function EanbleAskAttrBn(bEnable)

	Equip_Addition_Button1:Enable();
	Equip_Addition_Button2:Enable();
	Equip_Addition_Button3:Enable();
	Equip_Addition_Button4:Enable();
	Equip_Addition_Button5:Enable();
end

--------------------------------------------------------------------------------
--
-- 打开所有的点数增加按钮
--
function EanblePointAddButtion()

	Equip_Addition_Button1:Enable();
	Equip_Addition_Button2:Enable();
	Equip_Addition_Button3:Enable();
	Equip_Addition_Button4:Enable();
	Equip_Addition_Button5:Enable();
end


--------------------------------------------------------------------------------
--
-- 禁止所有的点数增加按钮
--
function DisablePointAddButtion()

	Equip_Addition_Button1:Disable();
	Equip_Addition_Button2:Disable();
	Equip_Addition_Button3:Disable();
	Equip_Addition_Button4:Disable();
	Equip_Addition_Button5:Disable();
end


--------------------------------------------------------------------------------
--
-- 打开所有的点数增加按钮
--
function EanblePointDecButtion()

	Equip_Decrease_Button1:Enable();
	Equip_Decrease_Button2:Enable();
	Equip_Decrease_Button3:Enable();
	Equip_Decrease_Button4:Enable();
	Equip_Decrease_Button5:Enable();
end


--------------------------------------------------------------------------------
--
-- 禁止所有的点数增加按钮
--
function DisablePointDecButtion()

	Equip_Decrease_Button1:Disable();
	Equip_Decrease_Button2:Disable();
	Equip_Decrease_Button3:Disable();
	Equip_Decrease_Button4:Disable();
	Equip_Decrease_Button5:Disable();
end


---------------------------------------------------------------------------------
-- 
-- 显示当前的潜能
--
function ShowCurRemainPoint()

	SelfEquip_Potential:SetText( tostring( g_CurRemainPoint ) );

end

---------------------------------------------------------------------------------
-- 
-- 显示力量
--
function ShowCurStr()

	SelfEquip_Str:SetText( tostring( g_AddStr + Player:GetData("STR") ) );

end

---------------------------------------------------------------------------------
-- 
-- 显示灵气
--
function ShowCurSpr()

	SelfEquip_Nimbus:SetText( tostring( g_AddSpr + Player:GetData("SPR"))  );

end

---------------------------------------------------------------------------------
-- 
-- 显示体质
--
function ShowCurCon()

	SelfEquip_PhysicalStrength:SetText( tostring( g_AddCon + Player:GetData("CON"))  );

end

---------------------------------------------------------------------------------
-- 
-- 显示定力
--
function ShowCurInt()

	SelfEquip_Stability:SetText( tostring( g_AddInt + Player:GetData("INT"))  );

end

---------------------------------------------------------------------------------
-- 
-- 显示身法
--
function ShowCurDex()

	SelfEquip_Footwork:SetText( tostring( g_AddDex + Player:GetData("DEX"))  );

end



---------------------------------------------------------------------------------
--
-- 禁止, 打开申请潜能按钮潜能按钮
--
function SetAcceptButtonState()

	if(g_CurRemainPoint == g_RemainPoint) then
	
		SelfEquip_Accept:Disable();
	else
		
		--SelfEquip_Accept:Disable();
		SelfEquip_Accept:Enable();
	end;
	
end

---------------------------------------------------------------------------------
--
-- 申请增加潜能
--
function SelfEquip_Accept_Click()

	-- 发送更改属性请求.
	Player:SendAskManualAttr(g_AddStr, g_AddSpr, g_AddCon, g_AddInt, g_AddDex);
	--AxTrace( 0,0, "潜能点数"..tostring( g_AddStr ).."\n"..tostring( g_AddSpr ).."\n"..tostring( g_AddCon ).."\n"..tostring( g_AddInt ).."\n"..tostring(g_AddDex));
	
	-- 测试使用, 向服务器要装备的详细信息
	--AskEquipDetial();
			
end


---------------------------------------------------------------------------------
--
-- 手动调整成功
--
function SelfEquip_ManualAttr_Success()
	
	g_AddStr = 0;					-- 分配在力量上的剩余点数.
	g_AddSpr = 0;					-- 分配在灵气上的剩余点数.
	g_AddCon = 0;					-- 分配在体质上的剩余点数.
	g_AddInt = 0;					-- 分配在定力上的剩余点数.
	g_AddDex = 0;					-- 分配在身法上的剩余点数.
	
	-- 禁止所有减少点数按钮
	DisablePointDecButtion();
	
	-- 剩余没有分配的点数
	g_RemainPoint = g_CurRemainPoint;
	if(g_CurRemainPoint > 0) then
	
		EanblePointAddButtion();
	end

		
end

---------------------------------------------------------------------------------
--
-- 点击称号按钮
--
function TitleButton_Click()

	g_bOpenTitleDlg = 1;
	-- 打开称号界面
	OpenTitleList();
	--AxTrace( 0,0, "打开称号界面");
	
end

----------------------------------------------------------------------------------
--
-- 点击帮会按钮
--
function OpenConfraternity_click()
	
	-- 打开或关闭帮会界面.
	--Guild:AskGuildDetailInfo();
	Guild:ToggleGuildDetailInfo();
end


----------------------------------------------------------------------------------
--
-- 得到当前的title
--
--[[
function GetCurTitle()
	
	-- 得到当前的称号.
	local strCurTitle = Player:GetCurTitle();
	SelfEquip_Agname:SetText(strCurTitle);

end

function GetGuildTitle()
	local szGuildName = Guild:GetMyGuildInfo("Name");
	--AxTrace(0,0,"szGuildName:"..szGuildName);
	if(nil ~= szGuildName and "" ~= szGuildName) then
		SelfEquip_Confraternity:SetText(szGuildName);
	else
		SelfEquip_Confraternity:SetText("");
	end
end
--]]
----------------------------------------------------------------------------------
--
-- 选装玩家模型（向左)
--
function SelfEquip_Modle_TurnLeft(start)
	--向左旋转开始
	if(start == 1 and CEArg:GetValue("MouseButton")=="LeftButton") then
		SelfEquip_FakeObject:RotateBegin(-0.3);
	--向左旋转结束
	else
		SelfEquip_FakeObject:RotateEnd();
	end
end


function SelfEquip_ShowTooltip(Subject)
	if (g_PropertyTable[Subject] ~= nil) then
		if g_PropertyTable[Subject]:GetText() == "" then
			g_PropertyTable[Subject]:SetToolTip("")
		else
			if (g_XiulianTipTable[Subject] ~= nil) then
				g_PropertyTable[Subject]:SetToolTip( g_XiulianTipTable[Subject] )
			end
		end
	end
end
----------------------------------------------------------------------------------
--
-- 选装玩家模型（向右)
--
function SelfEquip_Modle_TurnRight(start)
	--向右旋转开始
	if(start == 1 and CEArg:GetValue("MouseButton")=="LeftButton") then
		SelfEquip_FakeObject:RotateBegin(0.3);
	--向右旋转结束
	else
		SelfEquip_FakeObject:RotateEnd();
	end
end

---------------------------------------------------------------------------------
--
-- 设置状态tooltip
--
function SelfEquip_SetStateTooltip()
	

	-- 得到状态属性
	local iIceDefine  		= Player:GetData( "DEFENCECOLD" );
	local iFireDefine 		= Player:GetData( "DEFENCEFIRE" );
	local iThunderDefine	= Player:GetData( "DEFENCELIGHT" );
	local iPoisonDefine		= Player:GetData( "DEFENCEPOISON" );
	
	local iIceAttack  		= Player:GetData( "ATTACKCOLD" );
	local iFireAttack 		= Player:GetData( "ATTACKFIRE" );
	local iThunderAttack	= Player:GetData( "ATTACKLIGHT" );
	local iPoisonAttack		= Player:GetData( "ATTACKPOISON" );
	
	local iIceResistOther	= Player:GetData( "RESISTOTHERCOLD" );
	local iFireResistOther= Player:GetData( "RESISTOTHERFIRE" );
	local iThunderResistOther	= Player:GetData( "RESISTOTHERLIGHT" );
	local iPoisonResistOther= Player:GetData( "RESISTOTHERPOISON" );
	
	local WW_lw1 = DataPool:GetPlayerMission_DataRound(427)
	local WW_lw2 = DataPool:GetPlayerMission_DataRound(428)
	local WW_lw3 = DataPool:GetPlayerMission_DataRound(429)
	local WW_lw4 = DataPool:GetPlayerMission_DataRound(430)
	local nIsBaiShou = DataPool:GetPlayerMission_DataRound(309)
	if nIsBaiShou > 0 then
	    SelfEquip_BaiBingJingTong:Show()
	end
	SelfEquip_IceFastness:SetToolTip("冰攻:"..tostring(iIceAttack).."#r冰抗:"..tostring(iIceDefine).."#r减冰抗:"..tostring(iIceResistOther).."#{JKXX_091228_1}"..tostring(WW_lw1) );
	SelfEquip_FireFastness:SetToolTip("火攻:"..tostring(iFireAttack).."#r火抗:"..tostring(iFireDefine).."#r减火抗:"..tostring(iFireResistOther).."#{JKXX_091228_2}"..tostring(WW_lw2) );
	SelfEquip_ThunderFastness:SetToolTip("玄攻:"..tostring(iThunderAttack).."#r玄抗:"..tostring(iThunderDefine).."#r减玄抗:"..tostring(iThunderResistOther).."#{JKXX_091228_3}"..tostring(WW_lw3) );
	SelfEquip_PoisonFastness:SetToolTip("毒攻:"..tostring(iPoisonAttack).."#r毒抗:"..tostring(iPoisonDefine).."#r减毒抗:"..tostring(iPoisonResistOther).."#{JKXX_091228_4}"..tostring(WW_lw4) );
		
end


---------------------------------------------------------------------------------
--
-- 显示活力
--
function SelfEquip_ShowVigor()
	-- 
	
	--this:RegisterEvent("UNIT_VIGOR");		-- 注册活力值
	--this:RegisterEvent("UNIT_ENERGY");	-- 注册精力值
	local iVigor = Player:GetData("VIGOR");
	local iVigorMax = Player:GetData("MAXVIGOR");
	local VigorText = tostring(iVigor).."/"..tostring(iVigorMax);
	SelfEquip_Vigor:SetText( VigorText );
	
end

---------------------------------------------------------------------------------
--
-- 显示活力
--
function SelfEquip_ShowEnergy()
	-- 
		
	local iEnergy 	 = Player:GetData("ENERGY");
	local iEnergyMax = Player:GetData("MAXENERGY");
	local EnergyText = tostring(iEnergy).."/"..tostring(iEnergyMax);
	SelfEquip_Energy:SetText(EnergyText);
	
	
end


----------------------------------------------------------------------------------------
--
-- 关闭界面
--

function SelfEquip_CloseUI()

	-- 打开或者关闭称号界面
	CloseTitleList();
	SelfEquip_FakeObject:SetFakeObject("");	
	SelfEquip_Close();

end;


function Pet_Page_Switch()
	Variable:SetVariable("SelfUnionPos", SelfEquip_Frame:GetProperty("UnifiedPosition"), 1);
	TogglePetPage();
	SelfEquip_SetTabColor(0);
end

--打开自己的资料页面
function Pet_Page_SelfData()
	Variable:SetVariable("SelfUnionPos", SelfEquip_Frame:GetProperty("UnifiedPosition"), 1);
	SystemSetup:OpenPrivatePage("self");
	
end

function SelfEquip_SetTabColor(idx)
	if(idx == nil or idx < 0 or idx > 4) then
		return;
	end	
	
	--AxTrace(0,0,tostring(idx));
	local i = 0;
	local selColor = "#e010101#Y";
	local noselColor = "#e010101";
	local tab = {
								[0] = SelfEquip_SelfEquip,
								SelfEquip_SelfData,
								SelfEquip_Pet,
								-- SelfEquip_Ride,
								SelfEquip_OtherInfo,
							};
	
	while i < 4 do
		if(i == idx) then
			tab[i]:SetText(selColor..SELFEQUIP_TAB_TEXT[i]);
		else
			tab[i]:SetText(noselColor..SELFEQUIP_TAB_TEXT[i]);
		end
		i = i + 1;
	end
end

function Ride_Page_Switch()
	Variable:SetVariable("SelfUnionPos", SelfEquip_Frame:GetProperty("UnifiedPosition"), 1);
	OpenRidePage();
	SelfEquip_SetTabColor(0);
end

function Other_Info_Page_Switch()
	Variable:SetVariable("SelfUnionPos", SelfEquip_Frame:GetProperty("UnifiedPosition"), 1);
	OtherInfoPage();
    UpdateDoubleExpData();
	
end

function SelfEquip_UpdateMask()
	local n1,n2,n3,n4,n5,n6,n7,_,n9,f10,n11,n12,n13,n14,n15 = SystemSetup:GameGetData();
	SystemSetup:SaveGameSetup ( n1,n2,n3,n4,n5,n6,n7,1,n9,tonumber(f10),n11,n12,1,n14,n15 );
	local i
	for i=0,16 do	
		if i ~= 9 and i ~=10 and i ~= 16 then
			SelfEquip_UpdateMaskByIndex( i );
		end
	end
end

function SelfEquip_UpdateMaskByIndex( index )

--	local ActionIndex = EnumAction(index, "equip");
--	local cur_dur = LifeAbility : Get_UserEquip_Current_Durability(index);
--	local max_dur = LifeAbility : Get_UserEquip_Maximum_Durability(index);
--	AxTrace(5,0,index.." max_dur="..max_dur)
--	AxTrace(5,0,index.." cur_dur="..cur_dur)
	
--	if( (cur_dur / max_dur) < 0.1 ) then

	local ActionIndex = EnumAction(index, "equip");
	if( ActionIndex:GetEquipDur() < 0.1 ) then
		g_EquipMask[ index ]:Show();
	else
		g_EquipMask[ index ]:Hide();
	end

end

function SelfEquip_OpenBlog()
	local strCharName =  Player:GetName();
	local strAccount =  Player:GetData("ACCOUNTNAME")
	PushDebugMessage("暂不开放博客")
	-- PushDebugMessage("暂不开放博客")--Blog:OpenBlogPage(strAccount,strCharName,true);
end
function XiuLian_Page_Switch()
	local nLevel = Player:GetData("LEVEL")
	if(nLevel >= 70) then
		Variable:SetVariable("SelfUnionPos", SelfEquip_Frame:GetProperty("UnifiedPosition"), 1);
		XiuLianPage();
		SelfEquip_SetTabColor(0);
		this:Hide()
	else
		SelfEquip_Xiulian : SetCheck(0)
		PushDebugMessage("#{XL_090707_62}")
	end
end
--显示武魂UI
function SelfEquip_Wuhun_Switch()
	Variable:SetVariable("SelfUnionPos", SelfEquip_Frame:GetProperty("UnifiedPosition"), 1);
	ToggleWuhunPage();
	SelfEquip_SetTabColor(0);
	this:Hide()
end
function Talent_Page_Switch()
	-- if Lua_CheckOpenTalent() == 1 then
		Variable:SetVariable("SelfUnionPos", SelfEquip_Frame:GetProperty("UnifiedPosition"), 1);
		ToggleTalentPage();
		this:Hide()
	-- else
		-- PushDebugMessage("#{TalentMP_20210804_62}")
	-- end
end
function SelfEquip_Open()
	g_AutoClick_Going = -1
	g_AutoClick_BtnFlag = -1
	SetTimer("SelfEquip", "SelfEquip_AutoClick_Timer()", g_AutoClickTimer_Step)

	this:Show();
end
function SelfEquip_Close()
	g_AutoClick_Going = -1
	g_AutoClick_BtnFlag = -1
	KillTimer("SelfEquip_AutoClick_Timer()")

	this:Hide();
end

function SelfEquip_DressDisPlay()
	
	if(IsWindowShow("Shop_Fitting")) then
		CloseWindow("Shop_Fitting", true);
	end
	local IsDisplay = SystemSetup:Get_Display_Dress();
	SelfEquip_Mode : SetCheck(1)
	if IsDisplay == 1 then
		IsDisplay = 0
	else
		IsDisplay = 1
	end
	
	SystemSetup:Set_Display_Dress(IsDisplay);
end
function LuaFnGetHumanAttrData(nType)
        local MenPai = tonumber(Player:GetData("MEMPAI"))
        local Lelvel = Player:GetData("LEVEL")
		local isHuManAttr = 0
		local AddHuman = Lua_GetHumanBaseAttr(nType)
		--特写修复
		if nType == 6 then
			AddHuman = Lua_GetHumanBaseAttr(5)
		end		
		if MenPai == 9 then
		   return isHuManAttr
		end
		if GetBase[MenPai] == nil then
		   return isHuManAttr
		end
		isHuManAttr = math.ceil(GetBase[MenPai][nType][2]/100 * Lelvel + GetBase[MenPai][nType][3]/100 * AddHuman) + GetBase[MenPai][nType][1]
	return isHuManAttr	
end

function SelfEquip_AskLevelup()
    local PlayerLevel = Player:GetData( "LEVEL" )
    local EvaluateLevelList = { 30, 45, 65, 75, 85 }
    
    local strMasterName = GetMasterName()
    
    if "" ~= strMasterName then   --空串表示在好友列表中没有找到师父名字,暨没有师父
        local ListSize = table.getn( EvaluateLevelList )
		for i = 1, ListSize do
			if EvaluateLevelList[ i ] == ( PlayerLevel+1 ) and PlayerLevel < 45 then
				--打开评价界面
				
				AskEvaluateAndLevelup()
				return
			end
		end
    end
    
    AskLevelUp( tonumber(0) )
    
end
-- 重置人物角色的剩余属性点和已经分配的属性点
function SelfEquip_ResetCharRemainPoint()
	g_AddStr = 0;					-- 分配在力量上的剩余点数.
	g_AddSpr = 0;					-- 分配在灵气上的剩余点数.
	g_AddCon = 0;					-- 分配在体质上的剩余点数.
	g_AddInt = 0;					-- 分配在定力上的剩余点数.
	g_AddDex = 0;					-- 分配在身法上的剩余点数.

	-- 禁用属性点的增加和减少操作
	DisablePointAddButtion();
	DisablePointDecButtion();

	-- 获取剩余属性点
	local nNumber 		= Player:GetData("POINT_REMAIN");
	g_CurRemainPoint 	= nNumber;
	g_RemainPoint   	= nNumber;

	-- 更新显示
	ShowCurStr();
	ShowCurSpr();
	ShowCurCon();
	ShowCurInt();
	ShowCurDex();
	ShowCurRemainPoint();

	if(g_CurRemainPoint > 0) then
		EanblePointAddButtion();
	end

	-- 设置手动调节点数按钮的状态.
	SetAcceptButtonState();
end

--***************************************************
-- 清空鼠标长按标记
--***************************************************
function SelfEquip_AutoClick_Clear(id)
	id = tonumber(id)
	if (id == g_AutoClick_BtnFlag) then
		g_AutoClick_BtnFlag = -1
	end
end

--***************************************************
-- 定时器回调函数
--    实现慢启动, 以后可以考虑加速(必要性不大)
--***************************************************
function SelfEquip_AutoClick_Timer()
	if (g_AutoClick_BtnFlag ~= -1) then
		-- 第一次LButton后经过X个Timer才算开始, 也就是说是 g_AutoClickTimer_Step * X 的时候开始进行自动加, 这样为了防止本来要点击一下的结果点了好多下
		if (g_AutoClick_Going < 4) then
			g_AutoClick_Going = g_AutoClick_Going + 1
			--目前先设置 6 Step 的等待时间, 下面注释的代码可以后来用于实现慢启动, 逐渐加速效果.
			--if (g_AutoClick_Going == 2 or g_AutoClick_Going == 5) then
				--g_AutoClick_FunList[g_AutoClick_BtnFlag]()
			--end
		else
			g_AutoClick_FunList[g_AutoClick_BtnFlag]()
		end
	end
end

--***************************************************
-- 鼠标左键松开操作
--    注意这里其实是代替 Click, 所以需要执行一次 Click 操作
--***************************************************
function SelfEquip_AutoClick_LButtonUp(id)
	id = tonumber(id)
	SelfEquip_AutoClick_Clear(id)
	g_AutoClick_FunList[id]()
end

--***************************************************
-- 设置定时器
--    设置标记说明鼠标已经按下
--***************************************************
function SelfEquip_AutoClick_SetTimer(id)
	id = tonumber(id)
	g_AutoClick_Going = -1
	g_AutoClick_BtnFlag = id
end

function SelfEquip_OnYirong()
	--试穿信息初始化
	this:Hide()
	SelfEquip_InitGameData()
	local DefDress = GetGameMissionData("CREATEROLE")
    Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("OpenDress");
		Set_XSCRIPT_ScriptID(830243);
		Set_XSCRIPT_Parameter(0,0);
		Set_XSCRIPT_Parameter(1,0);
		Set_XSCRIPT_Parameter(2,DefDress);
		Set_XSCRIPT_ParamCount(3);
    Send_XSCRIPT();	
end

function SelfEquip_InitGameData()
	SetGameMissionData("SELFPETINDEX",0)
	SetGameMissionData("MD_DRESS",0)
	SetGameMissionData("MD_EXTERIOR",0)
	SetGameMissionData("MD_WEAPON",0)
	SetGameMissionData("MD_HAIR",0)
	SetGameMissionData("MD_PETPOSS",0)
	SetGameMissionData("MD_HEAD",0)
	SetGameMissionData("MD_HAIRCLOLOUR",0)
	SetGameMissionData("MD_RIDA",0)
	SetGameMissionData("MD_FACE",0)
end	
