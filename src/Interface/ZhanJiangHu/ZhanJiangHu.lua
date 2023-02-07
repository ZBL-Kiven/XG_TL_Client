-- 移植-新春签到活动-天禧春华战江湖
--战江湖界面
-- !!!reloadscript =ZhanJiangHu
local g_ZhanJiangHu_Frame_UnifiedXPosition
local g_ZhanJiangHu_Frame_UnifiedYPosition

local g_ZhanJiangHu_DataRefreshTime = 0

local g_ZhanJiangHu_EventId2Data = 
{	
	[1] = 	{Len=12,Start = 0 },    --累计击杀怪物数量
	[2] = 	{Len=5,Start = 12	},	  --完成帮会任务次数
	[3] = 	{Len=1,Start = 17	},	 	--参加镜湖剿匪次数
	[4] = 	{Len=4,Start = 18	},	 	--参加老三环次数
	[5] = 	{Len=3,Start = 22	},	 	--完成燕子次数
	[6] = 	{Len=3,Start = 25	},	 	--完成我爱幸运快活三次数
	[7] = 	{Len=1,Start = 28	},	 	--完成蹴鞠次数
	[8] = 	{Len=1,Start = 29	},   	--完成华山论剑次数
	[9] = 	{Len=1,Start = 30	},   	--完成比武大会次数
	[10] = 	{Len=1,Start = 31	},	 	--完成仲夏除魔次数
	[11] =	{Len=3,Start = 32	},	 	--完成棋局次数
	[12] = 	{Len=3,Start = 35	},   	--完成小票次数
	[13] = 	{Len=2,Start = 38	},	 	--完成千寻活动次数
	[14] = 	{Len=2,Start = 40	},	 	--完成凤凰古城争夺战次数
	[15] = 	{Len=2,Start = 42	},		--完成前世今生次数
	[16] = 	{Len=6,Start = 44	},		--完成每日任务积分数（不是事件）
}

local g_ZhanJiangHu_HongFuSocreDataIndex = 16
local g_ZhanJiangHu_HongFuMaxValue = 25

local g_ZhanJiangHu_AhieveIdData = 
{
	--初八
	[1]  = 	{EventId=1,	NeedValue = 100,FuValue=1,HFStateBit=0,Pos={},Tips="#{CJYJ_201222_98}",Desc="#{CJYJ_201222_12}",ToolTips="#{CJYJ_201222_52}",},   --击杀100个怪物
	[2]  = 	{EventId=11,NeedValue = 1,	FuValue=1,HFStateBit=1,Pos={sceneId=2,x=274,z=95,npcName="刘仲甫"},Tips="",Desc="#{CJYJ_201222_13}",ToolTips="#{CJYJ_201222_53}",},	 	--参加1次棋局
	[3]  = 	{EventId=13,NeedValue = 1,	FuValue=1,HFStateBit=2,Pos={sceneId=1,x=129,z=213,npcName="左桐"},Tips="",Desc="#{CJYJ_201222_14}",ToolTips="#{CJYJ_201222_54}",},		--完成1次千寻活动	 
	[4]  = 	{EventId=6,	NeedValue = 1,	FuValue=1,HFStateBit=3,Pos={sceneId=1,x=130,z=230,npcName="柳月虹"},Tips="",Desc="#{CJYJ_201222_15}",ToolTips="#{CJYJ_201222_55}",},	 		--完成1次我爱幸运快活三
	[5]  = 	{EventId=2,	NeedValue = 5,	FuValue=1,HFStateBit=4,Pos={},Tips="#{CJYJ_201222_114}",Desc="#{CJYJ_201222_16}",ToolTips="#{CJYJ_201222_56}",},	 		--完成5次帮会任务
	--初九
	[6]  = 	{EventId=1,	NeedValue = 500,FuValue=1,HFStateBit=5,Pos={},Tips="#{CJYJ_201222_99}",Desc="#{CJYJ_201222_17}",ToolTips="#{CJYJ_201222_57}",},	 	--击杀500个怪物
	[7]  = 	{EventId=4,	NeedValue = 5,	FuValue=1,HFStateBit=6,Pos={sceneId=1,x=62,z=162,npcName="钱宏宇"},Tips="",Desc="#{CJYJ_201222_18}",ToolTips="#{CJYJ_201222_58}",},	 		--完成5次老三环
	[8]  = 	{EventId=14,NeedValue = 1,	FuValue=1,HFStateBit=7,Pos={sceneId=260,x=150,z=152,npcName="李野"},Tips="",Desc="#{CJYJ_201222_19}",ToolTips="#{CJYJ_201222_59}",},		--完成1次凤凰古城争夺战
	[9]  = 	{EventId=3,	NeedValue = 1,	FuValue=1,HFStateBit=8,Pos={sceneId=5,x=199,z=54,npcName="齐煞云"},Tips="",Desc="#{CJYJ_201222_20}",ToolTips="#{CJYJ_201222_60}",},	 		--完成1次镜湖剿匪
	[10] = 	{EventId=2,	NeedValue = 10,	FuValue=1,HFStateBit=9,Pos={},Tips="#{CJYJ_201222_114}",Desc="#{CJYJ_201222_21}",ToolTips="#{CJYJ_201222_61}",},		--完成10次帮会任务
	--初十
	[11] = 	{EventId=1,	NeedValue = 1000,FuValue=1,HFStateBit=10,Pos={},Tips="#{CJYJ_201222_100}",Desc="#{CJYJ_201222_22}",ToolTips="#{CJYJ_201222_62}",},	--击杀1000个怪物
	[12] = 	{EventId=11,NeedValue = 2,	FuValue=1,HFStateBit=11,Pos={sceneId=2,x=274,z=95,npcName="刘仲甫"},Tips="",Desc="#{CJYJ_201222_23}",ToolTips="#{CJYJ_201222_63}",},	 	--参加2次棋局
	[13] =  {EventId=7,	NeedValue = 1,	FuValue=1,HFStateBit=12,Pos={sceneId=1,x=187,z=147,npcName="于倩倩"},Tips="",Desc="#{CJYJ_201222_24}",ToolTips="#{CJYJ_201222_64}",},	 		--完成1次蹴鞠
	[14] =  {EventId=6,	NeedValue = 2,	FuValue=1,HFStateBit=13,Pos={sceneId=1,x=130,z=230,npcName="柳月虹"},Tips="",Desc="#{CJYJ_201222_25}",ToolTips="#{CJYJ_201222_65}",},			--完成2次我爱幸运快活三
	[15] =  {EventId=5,	NeedValue = 3,	FuValue=1,HFStateBit=14,Pos={sceneId=4,x=70,z=119,npcName="李纲"},Tips="",Desc="#{CJYJ_201222_26}",ToolTips="#{CJYJ_201222_66}",},			--完成3次燕子
	--十一
	[16] = 	{EventId=1,	NeedValue = 1500,FuValue=1,HFStateBit=15,Pos={},Tips="#{CJYJ_201222_101}",Desc="#{CJYJ_201222_27}",ToolTips="#{CJYJ_201222_67}",},  --击杀1500个怪物
	[17] = 	{EventId=4,	NeedValue = 10,	FuValue=1,HFStateBit=16,Pos={sceneId=1,x=62,z=162,npcName="钱宏宇"},Tips="",Desc="#{CJYJ_201222_28}",ToolTips="#{CJYJ_201222_68}",},   	--完成10次老三环
	[18] = 	{EventId=12,NeedValue = 2,	FuValue=1,HFStateBit=17,Pos={sceneId=246,x=193,z=224,npcName="程青霜"},Tips="",Desc="#{CJYJ_201222_29}",ToolTips="#{CJYJ_201222_69}",},	 	--完成2次小票
	[19] = 	{EventId=6,	NeedValue = 3,	FuValue=1,HFStateBit=18,Pos={sceneId=1,x=130,z=230,npcName="柳月虹"},Tips="",Desc="#{CJYJ_201222_30}",ToolTips="#{CJYJ_201222_70}",},			--完成3次我爱幸运快活三
	[20] = 	{EventId=15,NeedValue = 1,	FuValue=1,HFStateBit=19,Pos={sceneId=0,x=194,z=180,npcName="诸葛孔亮"},Tips="",Desc="#{CJYJ_201222_31}",ToolTips="#{CJYJ_201222_71}",},	 	--完成1次前世今生
	--十二
	[21] = 	{EventId=1,	NeedValue = 2000,FuValue=1,HFStateBit=20,Pos={},Tips="#{CJYJ_201222_102}",Desc="#{CJYJ_201222_32}",ToolTips="#{CJYJ_201222_72}",},   --击杀2000个怪物
	[22] = 	{EventId=11,NeedValue = 3,	FuValue=1,HFStateBit=21,Pos={sceneId=2,x=274,z=95,npcName="刘仲甫"},Tips="",Desc="#{CJYJ_201222_33}",ToolTips="#{CJYJ_201222_73}",},    --完成3次棋局
	[23] = 	{EventId=8,	NeedValue = 1,	FuValue=1,HFStateBit=22,Pos={sceneId=1,x=193,z=138,npcName="苏剑岭"},Tips="",Desc="#{CJYJ_201222_34}",ToolTips="#{CJYJ_201222_74}",},   	--完成1次华山论剑
	[24] = 	{EventId=12,NeedValue = 4,	FuValue=1,HFStateBit=23,Pos={sceneId=246,x=193,z=224,npcName="程青霜"},Tips="",Desc="#{CJYJ_201222_35}",ToolTips="#{CJYJ_201222_75}",},		--完成4次小票
	[25] = 	{EventId=2,	NeedValue = 15,	FuValue=1,HFStateBit=24,Pos={},Tips="#{CJYJ_201222_114}",Desc="#{CJYJ_201222_36}",ToolTips="#{CJYJ_201222_76}",},	 	--完成15次帮会任务
	--十三
	[26] = 	{EventId=1,	NeedValue = 2500,FuValue=1,HFStateBit=25,Pos={},Tips="#{CJYJ_201222_103}",Desc="#{CJYJ_201222_37}",ToolTips="#{CJYJ_201222_77}",},  	--击杀2500个怪物
	[27] = 	{EventId=9,	NeedValue = 1,	FuValue=1,HFStateBit=26,Pos={sceneId=1,x=173,z=130,npcName="隋豹鸣"},Tips="",Desc="#{CJYJ_201222_38}",ToolTips="#{CJYJ_201222_78}",},    	--参加1次比武大会
	[28] =  {EventId=10,NeedValue = 1,	FuValue=1,HFStateBit=27,Pos={sceneId=1,x=186,z=182,npcName="梁道士"},Tips="",Desc="#{CJYJ_201222_39}",ToolTips="#{CJYJ_201222_79}",},	 	--完成1次仲夏除魔
	[29] =  {EventId=6,	NeedValue = 4,	FuValue=1,HFStateBit=28,Pos={sceneId=1,x=130,z=230,npcName="柳月虹"},Tips="",Desc="#{CJYJ_201222_40}",ToolTips="#{CJYJ_201222_80}",},	 		--完成4次我爱幸运快活三
	[30] = 	{EventId=14,NeedValue = 2,	FuValue=1,HFStateBit=29,Pos={sceneId=260,x=150,z=152,npcName="李野"},Tips="",Desc="#{CJYJ_201222_41}",ToolTips="#{CJYJ_201222_81}",},		--完成2次凤凰古城争夺战
  --十四	
	[31] = 	{EventId=1,	NeedValue = 3000,FuValue=1,HFStateBit=30,Pos={},Tips="#{CJYJ_201222_104}",Desc="#{CJYJ_201222_42}",ToolTips="#{CJYJ_201222_82}",},   --击杀3000个怪物
	[32] = 	{EventId=4,	NeedValue = 15,	FuValue=1,HFStateBit=31,Pos={sceneId=1,x=62,z=162,npcName="钱宏宇"},Tips="",Desc="#{CJYJ_201222_43}",ToolTips="#{CJYJ_201222_83}",},    --完成15次老三环
	[33] = 	{EventId=11,NeedValue = 4,	FuValue=1,HFStateBit=32,Pos={sceneId=2,x=274,z=95,npcName="刘仲甫"},Tips="",Desc="#{CJYJ_201222_44}",ToolTips="#{CJYJ_201222_84}",},   	--完成4次棋局
	[34] =  {EventId=5,	NeedValue = 6,	FuValue=1,HFStateBit=33,Pos={sceneId=4,x=70,z=119,npcName="李纲"},Tips="",Desc="#{CJYJ_201222_45}",ToolTips="#{CJYJ_201222_85}",},	 		--完成6次燕子
	[35] = 	{EventId=15,NeedValue = 2,	FuValue=1,HFStateBit=34,Pos={sceneId=0,x=194,z=180,npcName="诸葛孔亮"},Tips="",Desc="#{CJYJ_201222_46}",ToolTips="#{CJYJ_201222_86}",},		--完成2次前世今生
	--十五
	[36] = 	{EventId=1,	NeedValue = 4000,FuValue=1,HFStateBit=35,Pos={},Tips="#{CJYJ_201222_105}",Desc="#{CJYJ_201222_47}",ToolTips="#{CJYJ_201222_87}",},   --击杀4000个怪物
	[37] = 	{EventId=12,NeedValue = 6,	FuValue=1,HFStateBit=36,Pos={sceneId=246,x=193,z=224,npcName="程青霜"},Tips="",Desc="#{CJYJ_201222_48}",ToolTips="#{CJYJ_201222_88}",},    --完成6次小票
	[38] = 	{EventId=13,NeedValue = 2,	FuValue=1,HFStateBit=37,Pos={sceneId=1,x=129,z=213,npcName="左桐"},Tips="",Desc="#{CJYJ_201222_49}",ToolTips="#{CJYJ_201222_89}",},		--完成2次千寻活动
	[39] = 	{EventId=6,	NeedValue = 5,	FuValue=1,HFStateBit=38,Pos={sceneId=1,x=130,z=230,npcName="柳月虹"},Tips="",Desc="#{CJYJ_201222_50}",ToolTips="#{CJYJ_201222_90}",},   	--完成5次我爱幸运快活三
	[40] =  {EventId=2,	NeedValue = 20,	FuValue=1,HFStateBit=39,Pos={},Tips="#{CJYJ_201222_114}",Desc="#{CJYJ_201222_51}",ToolTips="#{CJYJ_201222_91}",},		--完成20次帮会任务
}

local g_ZhanJiangHu_CurPage = 0

local g_ZhanJiangHu_EventDataPool = {}
local g_ZhanJiangHu_RewardStatePool = {}
local g_ZhanJiangHu_HongFuDianStatePool = {}
--活动重开OpenDay 需要对应修改
local g_ZhanJiangHu_PageAhieve = 
{
	[1] = {AchieveCount = 5,OpenDay=20210219,AchieveList={1,2,3,4,5},},
	[2] = {AchieveCount = 5,OpenDay=20210220,AchieveList={6,7,8,9,10},},
	[3] = {AchieveCount = 5,OpenDay=20210221,AchieveList={11,12,13,14,15},},
	[4] = {AchieveCount = 5,OpenDay=20210222,AchieveList={16,17,18,19,20},},
	[5] = {AchieveCount = 5,OpenDay=20210223,AchieveList={21,22,23,24,25},},
	[6] = {AchieveCount = 5,OpenDay=20210224,AchieveList={26,27,28,29,30},},
	[7] = {AchieveCount = 5,OpenDay=20210225,AchieveList={31,32,33,34,35},},
	[8] = {AchieveCount = 5,OpenDay=20210226,AchieveList={36,37,38,39,40},},
}

g_ZhanJiangHu_RewardNum = 6
g_ZhanJiangHu_HongFuReward = 
{
	[1] = {NeedHongFu = 4,RewardBit=1,RewardList={id=30900006,count=5}},
	[2] = {NeedHongFu = 8,RewardBit=2,RewardList={id=20310168,count=8}},
	[3] = {NeedHongFu = 12,RewardBit=3,RewardList={id=30700241,count=3}},
	[4] = {NeedHongFu = 16,RewardBit=4,RewardList={id=20501003,count=1}},
	[5] = {NeedHongFu = 20,RewardBit=5,RewardList={id=20502003,count=1}},
	[6] = {NeedHongFu = 25,RewardBit=6,RewardList={id=38002169,count=1}},
}

g_ZhanJiangHu_HongFuButtons = {}

--小红点
local g_ZhanJiangHu_FlexTips = {}
local g_ZhanJiangHu_FlexState = 
{
	[1] = 0,
	[2] = 0,
}

local g_ZhanJiangHu_PageMaxCount = 5--每日活动数量
local g_ZhanJiangHu_MaxPage = 8--初八-十五

local g_ZhanJiangHu_AchieveContorl = {}
local g_ZhanJiangHu_DaySwithcButon = {}
local g_ZhanJiangHu_DaySwithButtonTips = {}

local g_ZhanJiangHu_MaxBit = 31

--===============================================
-- PreLoad()
--===============================================
function ZhanJiangHu_PreLoad()

	this:RegisterEvent("UI_COMMAND",true)	
	this:RegisterEvent("OPEN_ZHANJIANGHU",true)
		
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	
	this:RegisterEvent("PLAYER_ENTERING_WORLD",true)	
	this:RegisterEvent("XINCHUNYINGJING_FLEX_UPDATE",true)
		
	this:RegisterEvent("RESET_ALLUI");

end

--================================================
-- OnLoad()
--================================================
function ZhanJiangHu_OnLoad()
	g_ZhanJiangHu_AchieveContorl = 
	{
		[1] = {Desc=ZhanJiangHu_BottomText1,Btn=ZhanJiangHu_RewardButton1,BtnText=ZhanJiangHu_RewardText1,ValueText=ZhanJiangHu_BottomInfo1,Finish=ZhanJiangHu_DianshuBk1},
		[2] = {Desc=ZhanJiangHu_BottomText2,Btn=ZhanJiangHu_RewardButton2,BtnText=ZhanJiangHu_RewardText2,ValueText=ZhanJiangHu_BottomInfo2,Finish=ZhanJiangHu_DianshuBk2},
		[3] = {Desc=ZhanJiangHu_BottomText3,Btn=ZhanJiangHu_RewardButton3,BtnText=ZhanJiangHu_RewardText3,ValueText=ZhanJiangHu_BottomInfo3,Finish=ZhanJiangHu_DianshuBk3},
		[4] = {Desc=ZhanJiangHu_BottomText4,Btn=ZhanJiangHu_RewardButton4,BtnText=ZhanJiangHu_RewardText4,ValueText=ZhanJiangHu_BottomInfo4,Finish=ZhanJiangHu_DianshuBk4},
		[5] = {Desc=ZhanJiangHu_BottomText5,Btn=ZhanJiangHu_RewardButton5,BtnText=ZhanJiangHu_RewardText5,ValueText=ZhanJiangHu_BottomInfo5,Finish=ZhanJiangHu_DianshuBk5},
	}
	g_ZhanJiangHu_DaySwithcButon = 
	{
		[1] = {Btn=ZhanJiangHu_Button1,Tips=ZhanJiangHu_Button1Tips,},
		[2] = {Btn=ZhanJiangHu_Button2,Tips=ZhanJiangHu_Button2Tips,},
		[3] = {Btn=ZhanJiangHu_Button3,Tips=ZhanJiangHu_Button3Tips,},
		[4] = {Btn=ZhanJiangHu_Button4,Tips=ZhanJiangHu_Button4Tips,},
		[5] = {Btn=ZhanJiangHu_Button5,Tips=ZhanJiangHu_Button5Tips,},
		[6] = {Btn=ZhanJiangHu_Button6,Tips=ZhanJiangHu_Button6Tips,},
		[7] = {Btn=ZhanJiangHu_Button7,Tips=ZhanJiangHu_Button7Tips,},
		[8] = {Btn=ZhanJiangHu_Button8,Tips=ZhanJiangHu_Button8Tips,},
	}
	g_ZhanJiangHu_HongFuButtons = 
	{
		[1] = {Btn=ZhanJiangHu_Page1_one,FinishFlag=ZhanJiangHu_Page1_oneMark,Text=ZhanJiangHu_oneText,Tips=ZhanJiangHu_oneTips,},
		[2] = {Btn=ZhanJiangHu_Page1_two,FinishFlag=ZhanJiangHu_Page1_twoMark,Text=ZhanJiangHu_twoText,Tips=ZhanJiangHu_twoTips,},
		[3] = {Btn=ZhanJiangHu_Page1_three,FinishFlag=ZhanJiangHu_Page1_threeMark,Text=ZhanJiangHu_threeText,Tips=ZhanJiangHu_threeTips,},
		[4] = {Btn=ZhanJiangHu_Page1_four,FinishFlag=ZhanJiangHu_Page1_fourMark,Text=ZhanJiangHu_fourText,Tips=ZhanJiangHu_fourTips,},
		[5] = {Btn=ZhanJiangHu_Page1_five,FinishFlag=ZhanJiangHu_Page1_fiveMark,Text=ZhanJiangHu_fiveText,Tips=ZhanJiangHu_fiveTips,},
		[6] = {Btn=ZhanJiangHu_Page1_six,FinishFlag=ZhanJiangHu_Page1_sixMark,Text=ZhanJiangHu_Page1_sixText,Tips=ZhanJiangHu_sixTips,},
	}
	g_ZhanJiangHu_FlexTips = 
	{
		[1] = ZhanJiangHu_FenYe1_Tips,
		[2] = ZhanJiangHu_FenYe2_Tips,
	}
	
	-- 保存界面的默认相对位置
	g_ZhanJiangHu_Frame_UnifiedXPosition	= ZhanJiangHu_Frame : GetProperty("UnifiedXPosition");
	g_ZhanJiangHu_Frame_UnifiedYPosition	= ZhanJiangHu_Frame : GetProperty("UnifiedYPosition");
end

--===============================================
-- OnEvent()
--===============================================
function ZhanJiangHu_OnEvent(event)

	if(event == "UI_COMMAND" and tonumber(arg0) == 2018010901) then
		local bOpen = Get_XParam_INT(0)
		--
		local nCount = Get_XParam_INT(1)
		local nIndex = 2
		for i=1,nCount do
			g_ZhanJiangHu_EventDataPool[i] = Get_XParam_INT(nIndex)
			nIndex = nIndex + 1
		end
		--
		nCount = Get_XParam_INT(nIndex)
		nIndex = nIndex + 1
		for i=1,nCount do
			g_ZhanJiangHu_RewardStatePool[i] = Get_XParam_INT(nIndex)
			nIndex = nIndex + 1
		end
		--
		nCount = Get_XParam_INT(nIndex)
		nIndex = nIndex + 1
		for i=1,nCount do
			g_ZhanJiangHu_HongFuDianStatePool[i] = Get_XParam_INT(nIndex)
			nIndex = nIndex + 1
		end
		--
		local nPage = g_ZhanJiangHu_CurPage
		g_ZhanJiangHu_CurPage = 0
		--
		local bFlexFresh = ZhanJiangHu_RefreshFlexState()
		if(bOpen == 1) then
			nPage = 1
			ZhanJiangHu_FenYe1:SetCheck(0)
			ZhanJiangHu_FenYe2:SetCheck(1)
			if(IsWindowShow("HeXinChun") == true) then
				CloseWindow("HeXinChun",true)
			end
			this:Show()
		end
		--
		ZhanJiangHu_RefreshDayButtons()
		ZhanJiangHu_SwitchPage(nPage)
		ZhanJiangHu_RefreshHongFu()
		--
		g_ZhanJiangHu_DataRefreshTime = OSAPI:GetTickCount()
		if(bFlexFresh == 1) then
			PushEvent("XINCHUNYINGJING_FLEX_UPDATE",2,g_ZhanJiangHu_FlexState[2])
		end
	elseif (event == "OPEN_ZHANJIANGHU") then
		local bOpen = tonumber(arg0)
		if(bOpen == 0 and this:IsVisible()) then
			ZhanJiangHu_OnHiden()
			return
		end
		if(tonumber(arg1) ~= -1 and tonumber(arg2)  ~= -1) then
			g_ZhanJiangHu_Frame_UnifiedXPosition = arg1
			g_ZhanJiangHu_Frame_UnifiedYPosition = arg2
			ZhanJiangHu_Frame_On_ResetPos()
		end
		local nCur = OSAPI:GetTickCount()
		if( (g_ZhanJiangHu_DataRefreshTime <= 0) or (nCur - g_ZhanJiangHu_DataRefreshTime >= 300000)) then
			--重新请求一次数据
			ZhanJiangHu_AskData(1)
			return
		end
		if(IsWindowShow("HeXinChun") == true) then
			CloseWindow("HeXinChun",true)
		end
		g_ZhanJiangHu_CurPage = 0
		ZhanJiangHu_FenYe1:SetCheck(0)
		ZhanJiangHu_FenYe2:SetCheck(1)
		this:Show()
		ZhanJiangHu_RefreshDayButtons()
		ZhanJiangHu_SwitchPage(1)
		ZhanJiangHu_RefreshHongFu()
		
	elseif (event == "XINCHUNYINGJING_FLEX_UPDATE") then
		if(tonumber(arg0) ~= 1 )then
			return
		end
		g_ZhanJiangHu_FlexState[1] = tonumber(arg1)
		if(this:IsVisible()) then
			ZhanJiangHu_RefreshHongFu()
		end
		
	-- 游戏窗口尺寸发生了变化
	elseif (event == "ADJEST_UI_POS" ) then
		-- 更新背包界面位置
		ZhanJiangHu_Frame_On_ResetPos()

	-- 游戏分辨率发生了变化
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		-- 更新背包界面位置
		ZhanJiangHu_Frame_On_ResetPos()
	elseif (event == "PLAYER_ENTERING_WORLD" ) then
		ZhanJiangHu_AskData(0)
		ZhanJiangHu_OnHiden()
	elseif(event == "RESET_ALLUI") then
		g_ZhanJiangHu_DataRefreshTime = 0
		g_ZhanJiangHu_FlexState[1] = 0
		g_ZhanJiangHu_FlexState[2] = 0
	end
end

--===============================================
-- OnHiden
--===============================================
function ZhanJiangHu_OnHiden()
	this:Hide()
end

--================================================
--关界面
--================================================
function ZhanJiangHu_Close()
	ZhanJiangHu_OnHiden()
end

--================================================
-- 恢复界面的默认相对位置
--================================================
function ZhanJiangHu_Frame_On_ResetPos()
	ZhanJiangHu_Frame : SetProperty("UnifiedXPosition", g_ZhanJiangHu_Frame_UnifiedXPosition);
	ZhanJiangHu_Frame : SetProperty("UnifiedYPosition", g_ZhanJiangHu_Frame_UnifiedYPosition);
end

--================================================
--刷新积分值+累计积分领奖
--================================================
function ZhanJiangHu_RefreshHongFu()

	--当前积分值
	local nHongFu = ZhanJiangHu_GetHongFuValue()
	--进度条显示
	local tipstr = ScriptGlobal_Format("#{CJYJ_201222_97}", tostring(nHongFu))
	ZhanJiangHu_EXP:SetToolTip(tipstr)
	ZhanJiangHu_EXP:SetProgress(tonumber(nHongFu),g_ZhanJiangHu_HongFuMaxValue)	

	--奖励显示
	for i=1,table.getn(g_ZhanJiangHu_HongFuButtons) do
		--领取标记
		local state = ZhanJiangHu_GetHFRewardState(i)
		if(state == 1) then
			g_ZhanJiangHu_HongFuButtons[i].FinishFlag:Show()
			g_ZhanJiangHu_HongFuButtons[i].Tips:Hide()
		else
			g_ZhanJiangHu_HongFuButtons[i].FinishFlag:Hide()
			--小红点
			local nHongFu = ZhanJiangHu_GetHongFuValue()
			if (nHongFu >= g_ZhanJiangHu_HongFuReward[i].NeedHongFu and state == 0) then
				g_ZhanJiangHu_HongFuButtons[i].Tips:Show()
			else
				g_ZhanJiangHu_HongFuButtons[i].Tips:Hide()
			end
		end
		--道具
		local theAction = DataPool:CreateBindActionItemForShow(g_ZhanJiangHu_HongFuReward[i].RewardList.id, g_ZhanJiangHu_HongFuReward[i].RewardList.count)
		if theAction:GetID() ~= 0 then
			g_ZhanJiangHu_HongFuButtons[i].Btn:SetActionItem(theAction:GetID())
		end
		--积分
		g_ZhanJiangHu_HongFuButtons[i].Text:SetText(g_ZhanJiangHu_HongFuReward[i].NeedHongFu)
	end
	
	--更新页签小红点
	for i=1,table.getn(g_ZhanJiangHu_FlexTips) do
		if(g_ZhanJiangHu_FlexState[i] == 1) then
			g_ZhanJiangHu_FlexTips[i]:Show()
		else
			g_ZhanJiangHu_FlexTips[i]:Hide()
		end
	end
	
end

--================================================
--刷新日期页签显示
--================================================
function ZhanJiangHu_RefreshDayButtons()
	for i=1,table.getn(g_ZhanJiangHu_DaySwithcButon) do
		--可点击
		if(ZhanJiangHu_CheckDayHasOpen(i) == 1) then
			g_ZhanJiangHu_DaySwithcButon[i].Btn:Enable()
		else
			g_ZhanJiangHu_DaySwithcButon[i].Btn:Disable()
		end
		--选中状态
		if(g_ZhanJiangHu_CurPage == i) then
			g_ZhanJiangHu_DaySwithcButon[i].Btn:SetCheck(1)
		else
			g_ZhanJiangHu_DaySwithcButon[i].Btn:SetCheck(0)
		end
		--小红点
		if(g_ZhanJiangHu_DaySwithcButon[i].Tips ~= nil) then
			local nState = ZhanJiangHu_HasRewardForDay(i)--当前页签下是否还有积分可领取
			if(nState == 1 ) then
				g_ZhanJiangHu_DaySwithcButon[i].Tips:Show()
			else
				g_ZhanJiangHu_DaySwithcButon[i].Tips:Hide()
			end
		end
	end
end

--================================================
--切换日期分+显示具体活动
--================================================
function ZhanJiangHu_SwitchPage(nPage)
	if(nPage== nil or nPage < 1 or nPage > g_ZhanJiangHu_MaxPage) then
		return
	end		
	if(g_ZhanJiangHu_CurPage == nPage) then
		ZhanJiangHu_RefreshDayButtons()
		return
	end
	for i=1,g_ZhanJiangHu_PageMaxCount do
		local AchieveId = g_ZhanJiangHu_PageAhieve[nPage].AchieveList[i]
		g_ZhanJiangHu_AchieveContorl[i].Desc:Hide()
		if(AchieveId ~= nil) then
			local szDesc = g_ZhanJiangHu_AhieveIdData[AchieveId].Desc
			local nSocre = ZhanJiangHu_GetEventDataById(g_ZhanJiangHu_AhieveIdData[AchieveId].EventId)
			local nNeedValue = g_ZhanJiangHu_AhieveIdData[AchieveId].NeedValue
			local szToolTips = g_ZhanJiangHu_AhieveIdData[AchieveId].ToolTips
			if(nSocre >= nNeedValue) then--已完成
				local HasGet = ZhanJiangHu_GetHongFuDianState(AchieveId)
				if(HasGet == 1) then--已领取
					g_ZhanJiangHu_AchieveContorl[i].Btn:Disable()
					g_ZhanJiangHu_AchieveContorl[i].BtnText:SetText("#{CJYJ_180104_63}")
				else--可领取
					g_ZhanJiangHu_AchieveContorl[i].Btn:Enable()
					g_ZhanJiangHu_AchieveContorl[i].BtnText:SetText("#{CJYJ_201222_106}")
				end					
				g_ZhanJiangHu_AchieveContorl[i].Btn:SetToolTip("")
				g_ZhanJiangHu_AchieveContorl[i].Finish:Show()
				g_ZhanJiangHu_AchieveContorl[i].ValueText:Hide()
			else--未完成
				g_ZhanJiangHu_AchieveContorl[i].Btn:Enable()
				g_ZhanJiangHu_AchieveContorl[i].BtnText:SetText("#{CJYJ_180104_61}")
				g_ZhanJiangHu_AchieveContorl[i].Btn:SetToolTip(szToolTips)
				g_ZhanJiangHu_AchieveContorl[i].Finish:Hide()
				if nSocre == nil or nSocre < 0 then
					nSocre = 0
				end
				g_ZhanJiangHu_AchieveContorl[i].ValueText:SetText(tostring(nSocre).."/"..g_ZhanJiangHu_AhieveIdData[AchieveId].NeedValue)
				g_ZhanJiangHu_AchieveContorl[i].ValueText:Show()
			end
			g_ZhanJiangHu_AchieveContorl[i].Desc:SetText(szDesc)
			g_ZhanJiangHu_AchieveContorl[i].Desc:Show()
		end
	end

	g_ZhanJiangHu_CurPage = nPage
	ZhanJiangHu_RefreshDayButtons()
end

--================================================
--获取鸿福点数
--================================================
function ZhanJiangHu_GetHongFuValue()
	local nData = ZhanJiangHu_GetEventDataById(g_ZhanJiangHu_HongFuSocreDataIndex)
	if nData ~= nil and nData > 0 then
		return nData
	end
	return 0
end

--================================================
-- 切换页签
--================================================
function ZhanJiangHu_ChangeTabIndex()
	local X = ZhanJiangHu_Frame : GetProperty("UnifiedXPosition");
	local Y = ZhanJiangHu_Frame : GetProperty("UnifiedYPosition");
	PushEvent("OPEN_HEXINCHUN",1,X,Y)
	--ZhanJiangHu_OnHiden()
end

--================================================
-- 请求刷新界面
--================================================
function ZhanJiangHu_AskData(bOpen)
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("OnOpenUI")
			Set_XSCRIPT_ScriptID(892664)
			Set_XSCRIPT_Parameter(0,bOpen)
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
end

--================================================
--战江湖某个成就是否完成
--================================================
function ZhanJiangHu_AhieveHasFinish(AchieveId)
	if(g_ZhanJiangHu_AhieveIdData[AchieveId] == nil) then
		return 0
	end
	local nEventData = ZhanJiangHu_GetEventDataById(g_ZhanJiangHu_AhieveIdData[AchieveId].EventId)
	if(nEventData ~= nil and nEventData >= g_ZhanJiangHu_AhieveIdData[AchieveId].NeedValue) then
		return 1
	end
	return 0
end

--================================================
--当天页签下是否有奖励可以领取包括鸿福点数
--================================================
function ZhanJiangHu_HasRewardForDay(nDay)
	if(nDay == nil or g_ZhanJiangHu_PageAhieve[nDay] == nil) then
		return -1
	end
	if(ZhanJiangHu_CheckDayHasOpen(nDay) == 0) then
		return -2
	end
	for i=1,table.getn(g_ZhanJiangHu_PageAhieve[nDay].AchieveList) do
		local AchId = g_ZhanJiangHu_PageAhieve[nDay].AchieveList[i]
		if(g_ZhanJiangHu_AhieveIdData[AchId] ~= nil) then
			local nScore = ZhanJiangHu_GetEventDataById(g_ZhanJiangHu_AhieveIdData[AchId].EventId)
			local nState = ZhanJiangHu_GetHongFuDianState(AchId)
			if(nScore >= g_ZhanJiangHu_AhieveIdData[AchId].NeedValue and nState == 0) then
				return 1
			end
		end
	end
	return 0
end

--================================================
--日期是否开启
--================================================
function ZhanJiangHu_CheckDayHasOpen(nDayIndex)
	if(nDayIndex == nil or g_ZhanJiangHu_PageAhieve[nDayIndex] == nil) then
		return 0
	end
	local nCurrentDay = tonumber(DataPool:GetServerDayTime());
	local nNeedDay = g_ZhanJiangHu_PageAhieve[nDayIndex].OpenDay
	if(nCurrentDay >= nNeedDay) then
		return 1
	end
	return 0
end

--================================================
--获得积分的领取状态
--================================================
function ZhanJiangHu_GetHongFuDianState(AchId)
	if(g_ZhanJiangHu_AhieveIdData[AchId] == nil) then
		return -1
	end
	local nSplit = math.floor(g_ZhanJiangHu_AhieveIdData[AchId].HFStateBit / g_ZhanJiangHu_MaxBit) + 1
	local nIndex = math.mod(g_ZhanJiangHu_AhieveIdData[AchId].HFStateBit ,g_ZhanJiangHu_MaxBit)
	if(g_ZhanJiangHu_HongFuDianStatePool[nSplit] == nil) then
		return -1
	end
	local Data = g_ZhanJiangHu_HongFuDianStatePool[nSplit]
	local bRet,state = GetBitValueInUINT(Data,nIndex,1)
	if bRet == nil or state == nil or bRet ~= 1 then
		return -1
	end
	return state
end

--================================================
--获得累计积分奖励的领取状态
--================================================
function ZhanJiangHu_GetHFRewardState(nId)
	if(g_ZhanJiangHu_HongFuReward[nId] == nil) then
		return -1
	end
	local nSplit = math.floor(g_ZhanJiangHu_HongFuReward[nId].RewardBit / g_ZhanJiangHu_MaxBit) + 1
	local nIndex = math.mod(g_ZhanJiangHu_HongFuReward[nId].RewardBit ,g_ZhanJiangHu_MaxBit)
	if(g_ZhanJiangHu_RewardStatePool[nSplit] == nil) then
		return -1
	end
	local Data = g_ZhanJiangHu_RewardStatePool[nSplit]
	local bRet,state = GetBitValueInUINT(Data,nIndex,1)
	if bRet == nil or state == nil or bRet ~= 1 then
		return -1
	end
	return state
end

--================================================
--获得成就完成情况
--================================================
function ZhanJiangHu_GetEventDataById(EventId)
	if(EventId == nil or g_ZhanJiangHu_EventId2Data[EventId] == nil) then
		return -1
	end
	local nStart = g_ZhanJiangHu_EventId2Data[EventId].Start
	local nLen = g_ZhanJiangHu_EventId2Data[EventId].Len
	local nIndex = math.floor(nStart / 32) + 1
	--处理跨MD数据
	local nNum = math.mod(nStart ,32)
	local nRetValue = 0
	local nRetValueLen = 0
	local nMaxClycle = 99 --做一个循环限制
	while(1) do
		if(nIndex >= nMaxClycle) then
			return -1
		end
		if(g_ZhanJiangHu_EventDataPool[nIndex] == nil) then
			return -1
		end
		local nEnd = nNum + nLen
		if(nEnd > 32) then
			nEnd = 32
		end
		local nSize = nEnd - nNum
		local nData = g_ZhanJiangHu_EventDataPool[nIndex]
		local nRet,nValue = GetBitValueInUINT(nData,nNum,nSize)
		if nRet == nil or nValue == nil or nRet ~= 1 then
			return -1
		end
		nRet,nRetValue = SetBitValueInUINT(nRetValue,nRetValueLen,nSize,nValue)
		
		nLen = nLen - nSize
		nRetValueLen = nRetValueLen + nSize
		nNum = 0
		nIndex = nIndex + 1
		if(nLen <= 0) then
			return nRetValue
		end
	end
end

--================================================
--点击参加活动按钮
--================================================
function ZhanJiangHu_ClickCanjia(nIndex)
	if(nIndex < 1 or nIndex > g_ZhanJiangHu_PageMaxCount) then
		return
	end
	
	local nAchieveId = g_ZhanJiangHu_PageAhieve[g_ZhanJiangHu_CurPage].AchieveList[nIndex]
	local nState = ZhanJiangHu_AhieveHasFinish(nAchieveId)
	if(nState == 1) then
		-- 领取积分
		local HasGet = ZhanJiangHu_GetHongFuDianState(nAchieveId)
		if(HasGet == 1) then
			PushDebugMessage("#{CJYJ_201222_110}")
			return
		end
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("GetHongFuDian")
			Set_XSCRIPT_ScriptID(892664)
			Set_XSCRIPT_Parameter(0,nAchieveId)
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
		return
	else	
		--自动寻路/醒目提示
		local Pos = g_ZhanJiangHu_AhieveIdData[nAchieveId].Pos
		local szTips = g_ZhanJiangHu_AhieveIdData[nAchieveId].Tips
		--自动寻路
		if(Pos ~= nil and Pos.x ~= nil and Pos.z ~= nil and Pos.sceneId~=nil and Pos.npcName ~= nil) then
			AutoRuntoTargetExWithName(Pos.x, Pos.z, Pos.sceneId, Pos.npcName)
		end
		--醒目提示
		if(szTips ~= nil and szTips~= "") then
			PushDebugMessage(szTips)
		end
	end
end

--================================================
--点击奖励道具
--================================================
function ZhanJiangHu_OnClick(nIndex)
	if(nIndex <= 0 or nIndex > g_ZhanJiangHu_RewardNum) then
		return
	end
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("GetHFReward")
		Set_XSCRIPT_ScriptID(892664)
		Set_XSCRIPT_Parameter(0,nIndex)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
end

--================================================
--刷新页签小红点
--================================================
function ZhanJiangHu_RefreshFlexState()
	local nFlex = 0
	local nHongFu = ZhanJiangHu_GetHongFuValue()
	for i=1,g_ZhanJiangHu_MaxPage do
		if(ZhanJiangHu_CheckDayHasOpen(i) == 1) then--是否开放页签
			if(ZhanJiangHu_HasRewardForDay(i) == 1) then--当前页签下是否还有积分可领取
				nFlex = 1
			end
		end
	end
	for i=1,table.getn(g_ZhanJiangHu_HongFuButtons) do
		local state = ZhanJiangHu_GetHFRewardState(i)--是否领过累计积分奖励
		if(nHongFu >= g_ZhanJiangHu_HongFuReward[i].NeedHongFu and state == 0) then
			nFlex = 1
		end
	end
	if(nFlex ~= g_ZhanJiangHu_FlexState[2]) then
		g_ZhanJiangHu_FlexState[2] = nFlex
		return 1
	end
	return 0
end

--================================================
-- 小问号
--================================================
function ZhanJiangHu_HelpClicked()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("NpcText")
		Set_XSCRIPT_ScriptID(892664)
		Set_XSCRIPT_ParamCount(0)
	Send_XSCRIPT()
end
