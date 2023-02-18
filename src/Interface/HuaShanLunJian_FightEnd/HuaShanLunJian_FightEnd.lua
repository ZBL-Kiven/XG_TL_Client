-- 新比武大会结算界面

local g_Frame_UnifiedPosition ={}

local g_Star1 = {}
local g_Star2 = {}
local g_Star3 = {}
local g_Star4 = {}
local g_Star5 = {}
local g_StarAnim1 = {}
local g_StarAnim2 = {}
local g_StarAnim3 = {}
local g_StarAnim4 = {}
local g_StarAnim5 = {}
local g_Image = {
						[1] = "set:HSLJ_01  image:HSLJ_Tiger1",
						[2] = "set:HSLJ_01  image:HSLJ_Tiger2",
						[3] = "set:HSLJ_02  image:HSLJ_Tiger3",
						[4] = "set:HSLJ_02  image:HSLJ_Tiger4",
						[5] = "set:HSLJ_02  image:HSLJ_Tiger5",
						--[6] = "set:BW_Match1  image:Match_Tiger6",
						[6] = "set:HSLJ_02  image:HSLJ_Tiger6",
						[7] = "set:HSLJ_01  image:HSLJ_Dragon1",
						[8] = "set:HSLJ_01  image:HSLJ_Dragon2",
						[9] = "set:HSLJ_01  image:HSLJ_Dragon3",
						[10] = "set:HSLJ_01  image:HSLJ_Dragon4",
						[11] = "set:HSLJ_01  image:HSLJ_Dragon5",
						--[13] = "set:BW_Match5  image:Match_Dragon6",
						[12] = "set:HSLJ_01  image:HSLJ_Dragon6",
						[13] = "set:HSLJ_04  image:HSLJ_Hawk1",
						[14] = "set:HSLJ_04  image:HSLJ_Hawk2",
						[15] = "set:HSLJ_04  image:HSLJ_Hawk3",
						[16] = "set:HSLJ_04  image:HSLJ_Hawk4",
						[17] = "set:HSLJ_04  image:HSLJ_Hawk5",
						--[20] = "set:BW_Match4  image:Match_Eagle6",
						[18] = "set:HSLJ_04  image:HSLJ_Hawk6",
						-- 数字
						[19] = "set::HSLJ_Match1  image:Number1", 
						[20] = "set::HSLJ_Match1  image:Number2",	
						[21] = "set::HSLJ_Match1  image:Number3", 
						[22] = "set::HSLJ_Match1  image:Number4",	
						[23] = "set::HSLJ_Match1  image:Number5", 
						--[24] = "set:BW_Match1 image:Number6",
					
}
-- 你会唱小星星吗？ 一闪一闪亮晶晶，满天都是小星星？ 不对哦，是大河向东流啊，天上的星星参北斗啊。
local g_ImageStar = {
						[1] = "set:HSLJ_01 image:HSLJ_Star", --亮星星
						[2] = "set:HSLJ_01 image:HSLJ_StarGray",	--灰星星
}

local g_Timer = -1
local g_BigUpTimer = -1
local g_BigDownTimer = -1
local g_EndLineTimer = -1
local g_SecondEndLineTimer = -1
local g_CurStarFor6 = -1
local g_CurMajorRank = -1
local g_UpType = -1
local g_SecondLineNum = -1
local g_SecondLineMax = -1
local g_NeedSecond = -1
local g_WhichLight = -1
local g_UpTimer = -1
local g_DownTimer = -1
local g_CurStar = -1 
local g_StarUpTime = 2
local g_StarKongTime1 = 2 --升小段动画时间
local g_StarKongTime2 = 2 --升大段动画时间
local g_AllTime1 = g_StarUpTime + g_StarKongTime1 + g_StarUpTime
local g_AllTime2 = g_StarUpTime + g_StarKongTime2 + g_StarUpTime
-- 没有办法 全局不够用了 都塞一起了
local g_DuanWei1 = {
	-- 大段
	[1] = "#{HSSC_191009_37}",
	[2] = "#{HSSC_191009_38}",
	[3] = "#{HSSC_191009_39}",
	[4] = "#{HSSC_191009_40}",
	[5] = "#{HSSC_191009_41}",
	[6] = "#{HSSC_191009_42}",
	-- 小段
	[7] = "#{HSLJ_190919_154}",
	[8] = "#{HSLJ_190919_153}",
	[9] = "#{HSLJ_190919_152}",
	[10] = "#{HSLJ_190919_151}",
	[11] = "#{HSLJ_190919_150}",
	-- 分组
	[12] = "#{HSLJ_190919_142}",
	[13] = "#{HSLJ_190919_143}",
	[14] = "#{HSLJ_190919_144}",
}

function HuaShanLunJian_FightEnd_PreLoad()

	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- 游戏分辨率发生了变化
	this:RegisterEvent("BWTROOPS_RESULT_SHOW")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
end

function HuaShanLunJian_FightEnd_OnLoad()
	-- 保存界面的默认相对位置
	g_Frame_UnifiedPosition[1]	= HuaShanLunJian_FightEnd_Frame:GetProperty("UnifiedXPosition");
	g_Frame_UnifiedPosition[2]	= HuaShanLunJian_FightEnd_Frame:GetProperty("UnifiedYPosition");

	--把界面上的空间都存到数组里
	g_Star1={
			[0] = HuaShanLunJian_FightEnd_Star1,
			[1] = HuaShanLunJian_FightEnd_Star2,
			[2] = HuaShanLunJian_FightEnd_Star3,
	}
	
	g_Star2={
			[0] = HuaShanLunJian_FightEnd_Star1_1,
			[1] = HuaShanLunJian_FightEnd_Star1_2,
			[2] = HuaShanLunJian_FightEnd_Star1_3,
			[3] = HuaShanLunJian_FightEnd_Star1_4,
	}
	
	g_Star3={
			[0] = HuaShanLunJian_FightEnd_Star2_1,
			[1] = HuaShanLunJian_FightEnd_Star2_2,
			[2] = HuaShanLunJian_FightEnd_Star2_3,
			[3] = HuaShanLunJian_FightEnd_Star2_4,
			[4] = HuaShanLunJian_FightEnd_Star2_5,
	}
	
	g_Star4={
			[0] = HuaShanLunJian_FightEnd_Star4_1,
			[1] = HuaShanLunJian_FightEnd_Star4_2,
			[2] = HuaShanLunJian_FightEnd_Star4_3,
			[3] = HuaShanLunJian_FightEnd_Star4_4,
			[4] = HuaShanLunJian_FightEnd_Star4_5,
			[5] = HuaShanLunJian_FightEnd_Star4_6,
	}
	
	g_Star5={
			[0] = HuaShanLunJian_FightEnd_Star5_1,
			[1] = HuaShanLunJian_FightEnd_Star5_2,
			[2] = HuaShanLunJian_FightEnd_Star5_3,
			[3] = HuaShanLunJian_FightEnd_Star5_4,
			[4] = HuaShanLunJian_FightEnd_Star5_5,
			[5] = HuaShanLunJian_FightEnd_Star5_6,
			[6] = HuaShanLunJian_FightEnd_Star5_7,
			[7] = HuaShanLunJian_FightEnd_Star5_8,
	}
	
	g_StarAnim1={
			[0] = HuaShanLunJian_FightEnd_Star1Animate,
			[1] = HuaShanLunJian_FightEnd_Star2Animate,
			[2] = HuaShanLunJian_FightEnd_Star3Animate,
	}
	
	g_StarAnim2={
			[0] = HuaShanLunJian_FightEnd_Star1_1Animate,
			[1] = HuaShanLunJian_FightEnd_Star1_2Animate,
			[2] = HuaShanLunJian_FightEnd_Star1_3Animate,
			[3] = HuaShanLunJian_FightEnd_Star1_4Animate,
	}
	
	g_StarAnim3={
			[0] = HuaShanLunJian_FightEnd_Star2_1Animate,
			[1] = HuaShanLunJian_FightEnd_Star2_2Animate,
			[2] = HuaShanLunJian_FightEnd_Star2_3Animate,
			[3] = HuaShanLunJian_FightEnd_Star2_4Animate,
			[4] = HuaShanLunJian_FightEnd_Star2_5Animate,
	}
	
	g_StarAnim4={
			[0] = HuaShanLunJian_FightEnd_Star4_1Animate,
			[1] = HuaShanLunJian_FightEnd_Star4_2Animate,
			[2] = HuaShanLunJian_FightEnd_Star4_3Animate,
			[3] = HuaShanLunJian_FightEnd_Star4_4Animate,
			[4] = HuaShanLunJian_FightEnd_Star4_5Animate,
			[5] = HuaShanLunJian_FightEnd_Star4_6Animate,
	}
	
	g_StarAnim5={
			[0] = HuaShanLunJian_FightEnd_Star5_1Animate,
			[1] = HuaShanLunJian_FightEnd_Star5_2Animate,
			[2] = HuaShanLunJian_FightEnd_Star5_3Animate,
			[3] = HuaShanLunJian_FightEnd_Star5_4Animate,
			[4] = HuaShanLunJian_FightEnd_Star5_5Animate,
			[5] = HuaShanLunJian_FightEnd_Star5_6Animate,
			[6] = HuaShanLunJian_FightEnd_Star5_7Animate,
			[7] = HuaShanLunJian_FightEnd_Star5_8Animate,
	}
	
	--初始化各个控件
	HuaShanLunJian_FightEnd_CtrlList_InitData()
end

-- 清空
function HuaShanLunJian_FightEnd_CtrlList_InitData()

	--HuaShanLunJian_FightEnd_RightBK_Text1:SetText("")
	--HuaShanLunJian_FightEnd_Progress:SetProgress(0,100000)
	--HuaShanLunJian_FightEnd_RightBK_Text2:SetText("")
	--HuaShanLunJian_FightEnd_RightBK_Text3:SetText("")
	--HuaShanLunJian_FightEnd_RightBK_Text4:SetText("")
	--HuaShanLunJian_FightEnd_RightBK_Text5:SetText("")
	HuaShanLunJian_FightEnd_StageBK_Text2:SetText("")
	--HuaShanLunJian_FightEnd_StageBK_Button:Disable()
	g_Timer = 30
	g_BigDownTimer = 2
	g_DownTimer = 2
	g_CurStar = 0
	g_EndLineTimer = 100
	g_SecondEndLineTimer = 100
	g_SecondLineNum = -1
	g_SecondLineMax = -1
	g_NeedSecond = -1
	g_WhichLight = -1
	g_UpType = -1
	g_StarUpTime = 2
	g_StarKongTime1 = 2
	g_StarKongTime2 = 2
	g_AllTime1 = g_StarUpTime + g_StarKongTime1 + g_StarUpTime
	g_AllTime2 = g_StarUpTime + g_StarKongTime2 + g_StarUpTime
	g_UpTimer = g_AllTime1
	g_BigUpTimer = g_AllTime2
	for i=0, 4 do
		g_Star3[i]:Hide()
		g_Star3[i]:SetProperty("Image", g_ImageStar[2])
		g_StarAnim3[i]:Hide()
		g_StarAnim3[i]:Play(false)
	end
	for i=0, 2 do
		g_Star1[i]:Hide()
		g_Star1[i]:SetProperty("Image", g_ImageStar[2])
		g_StarAnim1[i]:Hide()
		g_StarAnim1[i]:Play(false)
	end
	for i=0, 3 do
		g_Star2[i]:Hide()
		g_Star2[i]:SetProperty("Image", g_ImageStar[2])
		g_StarAnim2[i]:Hide()
		g_StarAnim2[i]:Play(false)
	end
	for i=0, 5 do
		g_Star4[i]:Hide()
		g_Star4[i]:SetProperty("Image", g_ImageStar[2])
		g_StarAnim4[i]:Hide()
		g_StarAnim4[i]:Play(false)
	end
	for i=0, 7 do
		g_Star5[i]:Hide()
		g_Star5[i]:SetProperty("Image", g_ImageStar[2])
		g_StarAnim5[i]:Hide()
		g_StarAnim5[i]:Play(false)
	end
	HuaShanLunJian_FightEnd_Star3_1:Hide()
	HuaShanLunJian_FightEnd_Star3_1Animate:Hide()
	HuaShanLunJian_FightEnd_Star3_1Animate:Play(false)
	HuaShanLunJian_FightEnd_Star3Text:SetText("")
	HuaShanLunJian_FightEnd_Client_Frame_Victory:Hide()
	HuaShanLunJian_FightEnd_GoupAnimate:Hide()
	HuaShanLunJian_FightEnd_ImageAnimate:Hide()
	HuaShanLunJian_FightEnd_ImageAnimate:Play(false)
	HuaShanLunJian_FightEnd_Text:Hide()
	--HuaShanLunJian_FightEnd_Line1:Hide()
	--HuaShanLunJian_FightEnd_Line2:Hide()
	--HuaShanLunJian_FightEnd_Line3:Hide()
	--HuaShanLunJian_FightEnd_Line4:Hide()
	--HuaShanLunJian_FightEnd_RightBK_Text2:Hide()
	--HuaShanLunJian_FightEnd_RightBK_Text6:Hide()
	--HuaShanLunJian_FightEnd_RightBK_Text2_1:SetText("")
	--HuaShanLunJian_FightEnd_RightBK_Text2_2:SetText("")
	--HuaShanLunJian_FightEnd_RightBK_Text2_3:SetText("")
	--HuaShanLunJian_FightEnd_RightBK_Text2_4:SetText("")
	--HuaShanLunJian_FightEnd_RightBK_Text6_1:SetText("")
	--HuaShanLunJian_FightEnd_RightBK_Text6_2:SetText("")
	--HuaShanLunJian_FightEnd_RightBK_Text6_3:SetText("")
	-- HuaShanLunJian_FightEnd_ProgressWindowText:SetText("")
	-- HuaShanLunJian_FightEnd_ProgressWindowText1:SetText("")
	--HuaShanLunJian_FightEnd_RightBK_Lace_Text:SetText("")
	--HuaShanLunJian_FightEnd_RightBK_Lace_TextBk:Hide()
	--HuaShanLunJian_FightEnd_RightBK_Text2_1Bk:Hide()
	--HuaShanLunJian_FightEnd_RightBK_Text3Bk:Hide()
	--HuaShanLunJian_FightEnd_RightBK_Text6_1Bk:Hide()
	--HuaShanLunJian_FightEnd_RightBK_Text6_2Bk:Hide()
	-- HuaShanLunJian_FightEnd_RightBK_Lace_TextNum:SetText("")
	-- HuaShanLunJian_FightEnd_RightBK_Text2_1Num:SetText("")
	-- HuaShanLunJian_FightEnd_RightBK_Text3Num:SetText("")
	-- HuaShanLunJian_FightEnd_RightBK_Text6_1Num:SetText("")
	-- HuaShanLunJian_FightEnd_RightBK_Text6_2Num:SetText("")
	
	
end

function HuaShanLunJian_FightEnd_OnEvent(event)

	if( event == "ADJEST_UI_POS" ) then
		HuaShanLunJian_FightEnd_ResetPos()
	elseif ( event == "BWTROOPS_RESULT_SHOW" ) then
		--测试赛 by yuanpeilong
		if tonumber(arg1) ~= -1 then
			this:Hide()
			return
		end
		HuaShanLunJian_FightEnd_CtrlList_InitData()
		-- g_Timer = 30
		-- HuaShanLunJian_FightEnd_RightBK_Text5:SetText(ScriptGlobal_Format("#{SCGZ_180816_88}", g_Timer))
		-- SetTimer("HuaShanLunJian_FightEnd","HuaShanLunJian_FightEnd_Timer()", 1*1000)
		HuaShanLunJian_FightEnd_Frame_FullFill_Data()
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		this:Hide()
	end
	
end

--================================================
-- 恢复界面的默认相对位置
--================================================
function HuaShanLunJian_FightEnd_ResetPos()
	HuaShanLunJian_FightEnd_Frame:SetProperty("UnifiedXPosition", g_Frame_UnifiedPosition[1]);
	HuaShanLunJian_FightEnd_Frame:SetProperty("UnifiedYPosition", g_Frame_UnifiedPosition[2]);
end
-- 关闭函数
function HuaShanLunJian_FightEndFrame_CloseWindow()
	this:Hide()
end

--================================================
-- 填充数据
--================================================
function HuaShanLunJian_FightEnd_Frame_FullFill_Data()
	
	-- 取了一裤兜子数据，难受的亚比
	local nCurMajorRank,nCurMinorRank,nCurStar,nCurWeekAddMJB,nCurWeekMaxMJB,nAddMJB,nPreMajorRank,nPreMinorRank,nPreStar,nBWResult= XBW:GetResultData()
	g_CurStarFor6 = nCurStar
	g_CurStar = nCurStar
	--local Text = ScriptGlobal_Format("#{SCGZ_180816_107}", nYZScore)
	
	if nBWResult == nil then 
		return
	end
	
	local nResultType = XBW:GetBWTroopsPK_Result_Info()
	if nBWResult == 0 then
		HuaShanLunJian_FightEnd_Client_Frame_Victory:Show()
		HuaShanLunJian_FightEnd_Client_Frame_Victory:SetProperty("Image", "set:HSLJ_02 image:HSLJ02_Win")
	elseif nResultType == 3 then
		HuaShanLunJian_FightEnd_Client_Frame_Victory:Show()
		HuaShanLunJian_FightEnd_Client_Frame_Victory:SetProperty("Image", "set:HSLJ_02 image:HSLJ02_Ping")
	elseif nBWResult == 1 then
		HuaShanLunJian_FightEnd_Client_Frame_Victory:Show()
		HuaShanLunJian_FightEnd_Client_Frame_Victory:SetProperty("Image", "set:HSLJ_02 image:HSLJ02_Lost")
	end
	
	
	--设置图片 数组序号前面的数字是偏移量= =，
	local MatchId = XBW:GetMatchId()
	-- 不掉段
	if nCurMajorRank == nPreMajorRank and nCurMinorRank == nPreMinorRank then
		if MatchId == 0 then
			HuaShanLunJian_FightEnd_Image:SetProperty("Image", g_Image[12+nCurMajorRank])
			--HuaShanLunJian_FightEnd_Image:SetProperty("Image", g_Image[0+nCurMajorRank])
		elseif MatchId == 1 then
			HuaShanLunJian_FightEnd_Image:SetProperty("Image", g_Image[0+nCurMajorRank])
			--HuaShanLunJian_FightEnd_Image:SetProperty("Image", g_Image[6+nCurMajorRank])
		elseif MatchId == 2 then
			HuaShanLunJian_FightEnd_Image:SetProperty("Image", g_Image[6+nCurMajorRank])
		else 
			return 
		end
		if nCurMajorRank ~= 6 then
			HuaShanLunJian_FightEnd_Text:Show()
			HuaShanLunJian_FightEnd_Text:SetProperty("Image", g_Image[nCurMinorRank+18])
			-- 填充左边的数据
			local text2 = ScriptGlobal_Format("#{HSLJ_190919_189}",  g_DuanWei1[nCurMajorRank], g_DuanWei1[nCurMinorRank+6])
			HuaShanLunJian_FightEnd_StageBK_Text2:SetText(text2)
		else
			--HuaShanLunJian_FightEnd_Text:Show()
			-- 填充左边的数据
			local text2 = ScriptGlobal_Format("#{HSLJ_190919_190}",nCurStar)
			HuaShanLunJian_FightEnd_StageBK_Text2:SetText(text2)--..g_DuanWei1[nCurMinorRank+6].."阶")
		end
		
	elseif nCurMajorRank == nPreMajorRank and nCurMinorRank < nPreMinorRank then --升小段
		if MatchId == 0 then
			HuaShanLunJian_FightEnd_Image:SetProperty("Image", g_Image[12+nPreMajorRank])
		elseif MatchId == 1 then
			HuaShanLunJian_FightEnd_Image:SetProperty("Image", g_Image[0+nPreMajorRank])
		elseif MatchId == 2 then
			HuaShanLunJian_FightEnd_Image:SetProperty("Image", g_Image[6+nPreMajorRank])
		else 
			return 
		end
		HuaShanLunJian_FightEnd_Text:Show()
		HuaShanLunJian_FightEnd_Text:SetProperty("Image", g_Image[nPreMinorRank+18])
		-- 填充左边的数据
		local text2 = ScriptGlobal_Format("#{HSLJ_190919_189}",g_DuanWei1[nPreMajorRank], g_DuanWei1[nPreMinorRank+6])
		HuaShanLunJian_FightEnd_StageBK_Text2:SetText(text2)
			
	elseif nCurMajorRank > nPreMajorRank then --升大段
		if MatchId == 0 then
			HuaShanLunJian_FightEnd_Image:SetProperty("Image", g_Image[12+nPreMajorRank])
		elseif MatchId == 1 then
			HuaShanLunJian_FightEnd_Image:SetProperty("Image", g_Image[0+nPreMajorRank])
		elseif MatchId == 2 then
			HuaShanLunJian_FightEnd_Image:SetProperty("Image", g_Image[6+nPreMajorRank])
		else 
			return 
		end
		HuaShanLunJian_FightEnd_Text:Show()
		HuaShanLunJian_FightEnd_Text:SetProperty("Image", g_Image[nPreMinorRank+18])
		-- 填充左边的数据
		local text2 = ScriptGlobal_Format("#{HSLJ_190919_189}", g_DuanWei1[nPreMajorRank], g_DuanWei1[nPreMinorRank+6])
		HuaShanLunJian_FightEnd_StageBK_Text2:SetText(text2)

	end
	--没升段
	if nCurMajorRank == nPreMajorRank and nCurMinorRank == nPreMinorRank then
		--青铜
		if nCurMajorRank == 1 then
			for i = 0,2 do
				g_Star1[i]:Show()
			end
			--升星了,先把星星都点亮，然后再新加的那个上面来个可爱的特效
			if nCurStar > nPreStar then
				if nCurStar-nPreStar == 1 then
					for i = 0,nCurStar-1 do
						g_Star1[i]:SetProperty("Image", g_ImageStar[1])
					end
					for i=nPreStar,nCurStar-1 do
						g_StarAnim1[i]:Show()
						g_StarAnim1[i]:SetProperty("Animate","HSLJ_LevelupStrars")
						g_StarAnim1[i]:Play(true)
					end
				end
			elseif nCurStar == nPreStar then --没加也没减
				for i = 0,nCurStar-1 do
					g_Star1[i]:SetProperty("Image", g_ImageStar[1])
				end
				
			end
		elseif nCurMajorRank == 2 then -- 白银
			for i = 0,3 do
				g_Star2[i]:Show()
				--PushDebugMessage(i)
			end
				--升星了,先把星星都点亮，然后再新加的那个上面来个可爱的特效
			if nCurStar > nPreStar then
				if nCurStar-nPreStar == 1 then
					for i = 0,nCurStar-1 do
						g_Star2[i]:SetProperty("Image", g_ImageStar[1])
					end
					for i=nPreStar,nCurStar-1 do
						g_StarAnim2[i]:Show()
						g_StarAnim2[i]:SetProperty("Animate","HSLJ_LevelupStrars")
						g_StarAnim2[i]:Play(true)
					end
				end
			elseif nCurStar == nPreStar then --没加也没减
				for i = 0,nCurStar-1 do
					g_Star2[i]:SetProperty("Image", g_ImageStar[1])
				end
			end
		elseif nCurMajorRank == 3 then -- 黄金
			for i = 0,4 do
				g_Star3[i]:Show()
				--PushDebugMessage(i)
			end
				--升星了,先把星星都点亮，然后再新加的那个上面来个可爱的特效
			if nCurStar > nPreStar then
				if nCurStar-nPreStar == 1 then
					for i = 0,nCurStar-1 do
						g_Star3[i]:SetProperty("Image", g_ImageStar[1])
					end
					for i=nPreStar,nCurStar-1 do
						g_StarAnim3[i]:Show()
						g_StarAnim3[i]:SetProperty("Animate","HSLJ_LevelupStrars")
						g_StarAnim3[i]:Play(true)
					end
				end
			elseif nCurStar == nPreStar then --没加也没减
				for i = 0,nCurStar-1 do
					g_Star3[i]:SetProperty("Image", g_ImageStar[1])
				end
			end
		elseif nCurMajorRank == 4 then -- 白金
			for i = 0,5 do
				g_Star4[i]:Show()
			end
			--升星了,先把星星都点亮，然后再新加的那个上面来个可爱的特效
			if nCurStar > nPreStar then
				if nCurStar-nPreStar == 1 then
					for i = 0,nCurStar-1 do
						g_Star4[i]:SetProperty("Image", g_ImageStar[1])
					end
					for i=nPreStar,nCurStar-1 do
						g_StarAnim4[i]:Show()
						g_StarAnim4[i]:SetProperty("Animate","HSLJ_LevelupStrars")
						g_StarAnim4[i]:Play(true)
					end				
				end
			elseif nCurStar == nPreStar then --没加也没减
				for i = 0,nCurStar-1 do
					g_Star4[i]:SetProperty("Image", g_ImageStar[1])
				end
			end
		elseif nCurMajorRank == 5 then -- 钻石
			for i = 0,7 do
				g_Star5[i]:Show()
			end
			--升星了,先把星星都点亮，然后再新加的那个上面来个可爱的特效
			if nCurStar > nPreStar then
				if nCurStar-nPreStar == 1 then
					for i = 0,nCurStar-1 do
						g_Star5[i]:SetProperty("Image", g_ImageStar[1])
					end
					for i=nPreStar,nCurStar-1 do
						g_StarAnim5[i]:Show()
						g_StarAnim5[i]:SetProperty("Animate","HSLJ_LevelupStrars")
						g_StarAnim5[i]:Play(true)
					end				
				end
			elseif nCurStar == nPreStar then --没加也没减
				for i = 0,nCurStar-1 do
					g_Star5[i]:SetProperty("Image", g_ImageStar[1])
				end
			end
		elseif nCurMajorRank == 6 then
			if nCurStar > nPreStar then
				if nCurStar-nPreStar == 1 then
					HuaShanLunJian_FightEnd_Star3_1:Show()
					HuaShanLunJian_FightEnd_Star3_1:SetProperty("Image", g_ImageStar[1])
					HuaShanLunJian_FightEnd_Star3Text:SetText(ScriptGlobal_Format("#{HSSC_191009_73}",nCurStar))
				end
			elseif nCurStar == nPreStar then --没加也没减
				HuaShanLunJian_FightEnd_Star3_1:Show()
				HuaShanLunJian_FightEnd_Star3_1:SetProperty("Image", g_ImageStar[1])
				HuaShanLunJian_FightEnd_Star3Text:SetText(ScriptGlobal_Format("#{HSSC_191009_73}",nCurStar))
			end
		end
	--升段
	elseif nCurMajorRank > nPreMajorRank or (nCurMinorRank < nPreMinorRank and nCurMajorRank == nPreMajorRank) then
		g_CurMajorRank = nCurMajorRank
		-- 升到白银
		if nCurMajorRank == 2 and nCurMajorRank > nPreMajorRank then
		
			g_UpType = 3
			-- 先给这小老弟儿的星星都加特效
			for i = 0,2 do
				g_Star1[i]:Show()
				g_Star1[i]:SetProperty("Image", g_ImageStar[1])
				g_StarAnim1[i]:Show()
				g_StarAnim1[i]:SetProperty("Animate","HSLJ_LevelupStrars")
				g_StarAnim1[i]:Play(true)
			end
			SetTimer("HuaShanLunJian_FightEnd","HuaShanLunJian_FightEnd_1to2Timer()", 1000)
		elseif nCurMajorRank == 3 and nCurMajorRank > nPreMajorRank then --升到黄金
			
			g_UpType = 3
			-- 先给这小老弟儿的星星都加特效
			for i = 0,3 do
				g_Star2[i]:Show()
				g_Star2[i]:SetProperty("Image", g_ImageStar[1])
				g_StarAnim2[i]:Show()
				g_StarAnim2[i]:SetProperty("Animate","HSLJ_LevelupStrars")
				g_StarAnim2[i]:Play(true)
			end
			SetTimer("HuaShanLunJian_FightEnd","HuaShanLunJian_FightEnd_2to3Timer()", 1000)
		elseif nCurMajorRank == 4 and nCurMajorRank > nPreMajorRank then	--升到白金
			
				g_UpType = 3
				-- 先给这小老弟儿的星星都加特效
				for i = 0,4 do
					g_Star3[i]:Show()
					g_Star3[i]:SetProperty("Image", g_ImageStar[1])
					g_StarAnim3[i]:Show()
					g_StarAnim3[i]:SetProperty("Animate","HSLJ_LevelupStrars")
					g_StarAnim3[i]:Play(true)
				end
			SetTimer("HuaShanLunJian_FightEnd","HuaShanLunJian_FightEnd_3to4Timer()", 1000)
		elseif nCurMajorRank == 5 and nCurMajorRank > nPreMajorRank then --升到钻石
			
				g_UpType = 3
				-- 先给这小老弟儿的星星都加特效
				for i = 0,5 do
					g_Star4[i]:Show()
					g_Star4[i]:SetProperty("Image", g_ImageStar[1])
					g_StarAnim4[i]:Show()
					g_StarAnim4[i]:SetProperty("Animate","HSLJ_LevelupStrars")
					g_StarAnim4[i]:Play(true)
				end
			SetTimer("HuaShanLunJian_FightEnd","HuaShanLunJian_FightEnd_4to5Timer()", 1000)
		elseif nCurMajorRank == 6 and nCurMajorRank > nPreMajorRank then --升到王者
			
				g_UpType = 3
				-- 先给这小老弟儿的星星都加特效
				for i = 0,7 do
					g_Star5[i]:Show()
					g_Star5[i]:SetProperty("Image", g_ImageStar[1])
					g_StarAnim5[i]:Show()
					g_StarAnim5[i]:SetProperty("Animate","HSLJ_LevelupStrars")
					g_StarAnim5[i]:Play(true)
				end
			SetTimer("HuaShanLunJian_FightEnd","HuaShanLunJian_FightEnd_5to6Timer()", 1000)
		-- 只升阶不升段，
		else
		
			if nCurMajorRank == 1 then
				g_CurMajorRank = nCurMajorRank
				
					g_UpType = 3
					-- 先给这小老弟儿的星星都加特效
					for i = 0,2 do
						g_Star1[i]:Show()
						g_Star1[i]:SetProperty("Image", g_ImageStar[1])
						g_StarAnim1[i]:Show()
						g_StarAnim1[i]:SetProperty("Animate","HSLJ_LevelupStrars")
						g_StarAnim1[i]:Play(true)
					end
				SetTimer("HuaShanLunJian_FightEnd","HuaShanLunJian_FightEnd_UpTimer()", 1000)
				
			elseif nCurMajorRank == 2  then
				g_CurMajorRank = nCurMajorRank
				
					g_UpType = 3
					-- 先给这小老弟儿的星星都加特效
					for i = 0,3 do
						g_Star2[i]:Show()
						g_Star2[i]:SetProperty("Image", g_ImageStar[1])
						g_StarAnim2[i]:Show()
						g_StarAnim2[i]:SetProperty("Animate","HSLJ_LevelupStrars")
						g_StarAnim2[i]:Play(true)
					end
				SetTimer("HuaShanLunJian_FightEnd","HuaShanLunJian_FightEnd_UpTimer()", 1000)
				
			elseif nCurMajorRank == 3  then
				g_CurMajorRank = nCurMajorRank
				
					g_UpType = 3
					-- 先给这小老弟儿的星星都加特效
					for i = 0,4 do
						g_Star3[i]:Show()
						g_Star3[i]:SetProperty("Image", g_ImageStar[1])
						g_StarAnim3[i]:Show()
						g_StarAnim3[i]:SetProperty("Animate","HSLJ_LevelupStrars")
						g_StarAnim3[i]:Play(true)
					end
				SetTimer("HuaShanLunJian_FightEnd","HuaShanLunJian_FightEnd_UpTimer()", 1000)	
				
			elseif nCurMajorRank == 4  then
				g_CurMajorRank = nCurMajorRank
				
					g_UpType = 3
					-- 先给这小老弟儿的星星都加特效
					for i = 0,5 do
						g_Star4[i]:Show()
						g_Star4[i]:SetProperty("Image", g_ImageStar[1])
						g_StarAnim4[i]:Show()
						g_StarAnim4[i]:SetProperty("Animate","HSLJ_LevelupStrars")
						g_StarAnim4[i]:Play(true)
					end
				SetTimer("HuaShanLunJian_FightEnd","HuaShanLunJian_FightEnd_UpTimer()", 1000)
				
			elseif nCurMajorRank == 5  then
				g_CurMajorRank = nCurMajorRank
				
					g_UpType = 3
					-- 先给这小老弟儿的星星都加特效
					for i = 0,7 do
						g_Star5[i]:Show()
						g_Star5[i]:SetProperty("Image", g_ImageStar[1])
						g_StarAnim5[i]:Show()
						g_StarAnim5[i]:SetProperty("Animate","HSLJ_LevelupStrars")
						g_StarAnim5[i]:Play(true)
					end
				SetTimer("HuaShanLunJian_FightEnd","HuaShanLunJian_FightEnd_UpTimer()", 1000)
			end
			
		
		end
	
	end
	this:Show()
end


-- function HuaShanLunJian_FightEnd_Timer()
	-- g_Timer = g_Timer - 1 
	-- --PushDebugMessage(g_Timer)
	-- if g_Timer == 0 then
		-- KillTimer("HuaShanLunJian_FightEnd_Timer()")
		-- this:Hide()
	-- end
	-- HuaShanLunJian_FightEnd_RightBK_Text5:SetText(ScriptGlobal_Format("#{SCGZ_180816_88}", g_Timer))
-- end

function HuaShanLunJian_FightEnd_1to2Timer()
	g_BigUpTimer = g_BigUpTimer - 1 
	if g_BigUpTimer == 0 then
		KillTimer("HuaShanLunJian_FightEnd_1to2Timer()")
		return
	end
	if g_BigUpTimer == g_AllTime2 - g_StarUpTime then --播放升段动画,星星置为空星
		HuaShanLunJian_FightEnd_GoupAnimate:Show()
		HuaShanLunJian_FightEnd_ImageAnimate:Show()
		HuaShanLunJian_FightEnd_GoupAnimate:SetProperty("Animate","HSLJ_GoupFlash")
		HuaShanLunJian_FightEnd_ImageAnimate:SetProperty("Animate","HSLJ_LightUpFlash")
		HuaShanLunJian_FightEnd_GoupAnimate:Play(true)
		HuaShanLunJian_FightEnd_ImageAnimate:Play(true)	
	end
	
		-- 给星星播特效留x秒
	if g_BigUpTimer > g_AllTime2 - g_StarUpTime then
		return 
	elseif g_BigUpTimer > g_AllTime2 - g_StarUpTime - g_StarKongTime2 then --给升小段动画留时间
		if g_BigUpTimer == g_AllTime2 - g_StarUpTime then --播放升段动画,星星置为空星
			-- 把上个段位的都隐掉，调用新的控件
			for i = 0,2 do
				g_StarAnim1[i]:Hide()
				g_Star1[i]:Hide()
			end
			for i = 0,3 do
				g_Star2[i]:SetProperty("Image", g_ImageStar[2])
				g_Star2[i]:Show()
			end
		end
		return
	elseif g_BigUpTimer == g_AllTime2 - g_StarUpTime - g_StarKongTime2 then --给加的第一个星星加特效。
		-- g_Star2[0]:SetProperty("Image", g_ImageStar[1])
		-- g_StarAnim2[0]:Show()
		-- g_StarAnim2[0]:SetProperty("Animate","HSLJ_LevelupStrars")
		-- g_StarAnim2[0]:Play(true)
		KillTimer("HuaShanLunJian_FightEnd_1to2Timer()")
	end
	
	--切换段位图
	if g_BigUpTimer == g_AllTime2 - g_StarUpTime - g_StarKongTime2 then
		local MatchId = XBW:GetMatchId()
		if MatchId == 0 then
			HuaShanLunJian_FightEnd_Image:SetProperty("Image", g_Image[12+2]) -- 前面的数字是偏移量，后面的数字是当前的大段位
		elseif MatchId == 1 then
			HuaShanLunJian_FightEnd_Image:SetProperty("Image", g_Image[0+2])
		elseif MatchId == 2 then
			HuaShanLunJian_FightEnd_Image:SetProperty("Image", g_Image[6+2])
		else 
			return 
		end
		HuaShanLunJian_FightEnd_Text:Show()
		HuaShanLunJian_FightEnd_Text:SetProperty("Image", g_Image[3+18]) -- 后面的数字是偏移量，前面的数字是当前的小段位
		-- 填充左边的数据
		local text2 = ScriptGlobal_Format("#{HSLJ_190919_189}",  g_DuanWei1[2], g_DuanWei1[3+6])
		HuaShanLunJian_FightEnd_StageBK_Text2:SetText(text2)
	end
end

function HuaShanLunJian_FightEnd_2to3Timer()
	g_BigUpTimer = g_BigUpTimer - 1 
	if g_BigUpTimer == 0 then
		KillTimer("HuaShanLunJian_FightEnd_2to3Timer()")
		return
	end
	if g_BigUpTimer == g_AllTime2 - g_StarUpTime then --播放升段动画,星星置为空星
		HuaShanLunJian_FightEnd_GoupAnimate:Show()
		HuaShanLunJian_FightEnd_ImageAnimate:Show()
		HuaShanLunJian_FightEnd_GoupAnimate:SetProperty("Animate","HSLJ_GoupFlash")
		HuaShanLunJian_FightEnd_ImageAnimate:SetProperty("Animate","HSLJ_LightUpFlash")
		HuaShanLunJian_FightEnd_GoupAnimate:Play(true)
		HuaShanLunJian_FightEnd_ImageAnimate:Play(true)	
	end
	
	-- 给星星播特效留x秒
	if g_BigUpTimer > g_AllTime2 - g_StarUpTime then
		return 
	elseif g_BigUpTimer > g_AllTime2 - g_StarUpTime - g_StarKongTime2 then --给升小段动画留时间
		if g_BigUpTimer == g_AllTime2 - g_StarUpTime then --播放升段动画,星星置为空星
			-- 把上个段位的都隐掉，调用新的控件
			for i = 0,3 do
				g_StarAnim2[i]:Hide()
				g_Star2[i]:Hide()
			end
			for i = 0,4 do
				g_Star3[i]:SetProperty("Image", g_ImageStar[2])
				g_Star3[i]:Show()
			end
		end
		return
	elseif g_BigUpTimer == g_AllTime2 - g_StarUpTime - g_StarKongTime2 then --给加的第一个星星加特效。
		-- g_Star3[0]:SetProperty("Image", g_ImageStar[1])
		-- g_StarAnim3[0]:Show()
		-- g_StarAnim3[0]:SetProperty("Animate","HSLJ_LevelupStrars")
		-- g_StarAnim3[0]:Play(true)			
		KillTimer("HuaShanLunJian_FightEnd_2to3Timer()")
	end
	
	--切换段位图
	if g_BigUpTimer == g_AllTime2 - g_StarUpTime - g_StarKongTime2 then
		local MatchId = XBW:GetMatchId()
		if MatchId == 0 then
			HuaShanLunJian_FightEnd_Image:SetProperty("Image", g_Image[12+3]) -- 前面的数字是偏移量，后面的数字是当前的大段位
		elseif MatchId == 1 then
			HuaShanLunJian_FightEnd_Image:SetProperty("Image", g_Image[0+3])
		elseif MatchId == 2 then
			HuaShanLunJian_FightEnd_Image:SetProperty("Image", g_Image[6+3])
		else 
			return 
		end
		HuaShanLunJian_FightEnd_Text:Show()
		HuaShanLunJian_FightEnd_Text:SetProperty("Image", g_Image[3+18]) -- 后面的数字是偏移量，前面的数字是当前的小段位
		-- 填充左边的数据
		local text2 = ScriptGlobal_Format("#{HSLJ_190919_189}", g_DuanWei1[3], g_DuanWei1[3+6])
		HuaShanLunJian_FightEnd_StageBK_Text2:SetText(text2)
		--HuaShanLunJian_FightEnd_StageBK_Text2:SetText(g_DuanWei1[MatchId+12].." "..g_DuanWei1[3]..g_DuanWei1[3+6].."阶")
	end
	
end

function HuaShanLunJian_FightEnd_3to4Timer()
	g_BigUpTimer = g_BigUpTimer - 1 
	if g_BigUpTimer == 0 then
		KillTimer("HuaShanLunJian_FightEnd_3to4Timer()")
		return
	end
	if g_BigUpTimer == g_AllTime2 - g_StarUpTime then --播放升段动画,星星置为空星
		HuaShanLunJian_FightEnd_GoupAnimate:Show()
		HuaShanLunJian_FightEnd_ImageAnimate:Show()
		HuaShanLunJian_FightEnd_GoupAnimate:SetProperty("Animate","HSLJ_GoupFlash")
		HuaShanLunJian_FightEnd_ImageAnimate:SetProperty("Animate","HSLJ_LightUpFlash")
		HuaShanLunJian_FightEnd_GoupAnimate:Play(true)
		HuaShanLunJian_FightEnd_ImageAnimate:Play(true)	
	end

	-- 给星星播特效留x秒
	if g_BigUpTimer > g_AllTime2 - g_StarUpTime then
		return 
	elseif g_BigUpTimer > g_AllTime2 - g_StarUpTime - g_StarKongTime2 then --给升小段动画留时间
		if g_BigUpTimer == g_AllTime2 - g_StarUpTime then --播放升段动画,星星置为空星
			-- 把上个段位的都隐掉，调用新的控件
			for i = 0,4 do
				g_StarAnim3[i]:Hide()
				g_Star3[i]:Hide()
			end
			for i = 0,5 do
				g_Star4[i]:SetProperty("Image", g_ImageStar[2])
				g_Star4[i]:Show()
			end
		end
		return
	elseif g_BigUpTimer == g_AllTime2 - g_StarUpTime - g_StarKongTime2 then --给加的第一个星星加特效。
		-- g_Star4[0]:SetProperty("Image", g_ImageStar[1])
		-- g_StarAnim4[0]:Show()
		-- g_StarAnim4[0]:SetProperty("Animate","HSLJ_LevelupStrars")
		-- g_StarAnim4[0]:Play(true)
		KillTimer("HuaShanLunJian_FightEnd_3to4Timer()")
	end
	
	--切换段位图
	if g_BigUpTimer == g_AllTime2 - g_StarUpTime - g_StarKongTime2 then
		local MatchId = XBW:GetMatchId()
		if MatchId == 0 then
			HuaShanLunJian_FightEnd_Image:SetProperty("Image", g_Image[12+4]) -- 前面的数字是偏移量，后面的数字是当前的大段位
		elseif MatchId == 1 then
			HuaShanLunJian_FightEnd_Image:SetProperty("Image", g_Image[0+4])
		elseif MatchId == 2 then
			HuaShanLunJian_FightEnd_Image:SetProperty("Image", g_Image[6+4])
		else 
			return 
		end
		HuaShanLunJian_FightEnd_Text:Show()
		HuaShanLunJian_FightEnd_Text:SetProperty("Image", g_Image[4+18]) -- 后面的数字是偏移量，前面的数字是当前的小段位
		-- 填充左边的数据
		--HuaShanLunJian_FightEnd_StageBK_Text2:SetText(g_DuanWei1[MatchId+12].." "..g_DuanWei1[4]..g_DuanWei1[3+6].."阶")
		local text2 = ScriptGlobal_Format("#{HSLJ_190919_189}", g_DuanWei1[4], g_DuanWei1[4+6])
		HuaShanLunJian_FightEnd_StageBK_Text2:SetText(text2)
	end
	
end

function HuaShanLunJian_FightEnd_4to5Timer()
	g_BigUpTimer = g_BigUpTimer - 1 
	if g_BigUpTimer == 0 then
		KillTimer("HuaShanLunJian_FightEnd_4to5Timer()")
		return
	end
	if g_BigUpTimer == g_AllTime2 - g_StarUpTime then --播放升段动画,星星置为空星
		HuaShanLunJian_FightEnd_GoupAnimate:Show()
		HuaShanLunJian_FightEnd_ImageAnimate:Show()
		HuaShanLunJian_FightEnd_GoupAnimate:SetProperty("Animate","HSLJ_GoupFlash")
		HuaShanLunJian_FightEnd_ImageAnimate:SetProperty("Animate","HSLJ_LightUpFlash")
		HuaShanLunJian_FightEnd_GoupAnimate:Play(true)
		HuaShanLunJian_FightEnd_ImageAnimate:Play(true)	
	end
	
	-- 给星星播特效留x秒
	if g_BigUpTimer > g_AllTime2 - g_StarUpTime then
		return 
	elseif g_BigUpTimer > g_AllTime2 - g_StarUpTime - g_StarKongTime2 then --给升小段动画留时间
		if g_BigUpTimer == g_AllTime2 - g_StarUpTime then --播放升段动画,星星置为空星
			-- 把上个段位的都隐掉，调用新的控件
			for i = 0,5 do
				g_StarAnim4[i]:Hide()
				g_Star4[i]:Hide()
			end
			for i = 0,7 do
				g_Star5[i]:SetProperty("Image", g_ImageStar[2])
				g_Star5[i]:Show()
			end
		end
		return
	elseif g_BigUpTimer == g_AllTime2 - g_StarUpTime - g_StarKongTime2 then --给加的第一个星星加特效。
		-- g_Star5[0]:SetProperty("Image", g_ImageStar[1])
		-- g_StarAnim5[0]:Show()
		-- g_StarAnim5[0]:SetProperty("Animate","HSLJ_LevelupStrars")
		-- g_StarAnim5[0]:Play(true)
		KillTimer("HuaShanLunJian_FightEnd_4to5Timer()")
	end
	
	--切换段位图
	if g_BigUpTimer == g_AllTime2 - g_StarUpTime - g_StarKongTime2 then
		local MatchId = XBW:GetMatchId()
		if MatchId == 0 then
			HuaShanLunJian_FightEnd_Image:SetProperty("Image", g_Image[12+5]) -- 前面的数字是偏移量，后面的数字是当前的大段位
		elseif MatchId == 1 then
			HuaShanLunJian_FightEnd_Image:SetProperty("Image", g_Image[0+5])
		elseif MatchId == 2 then
			HuaShanLunJian_FightEnd_Image:SetProperty("Image", g_Image[6+5])
		else 
			return 
		end
		HuaShanLunJian_FightEnd_Text:Show()
		HuaShanLunJian_FightEnd_Text:SetProperty("Image", g_Image[4+18]) -- 后面的数字是偏移量，前面的数字是当前的小段位
		-- 填充左边的数据
		--HuaShanLunJian_FightEnd_StageBK_Text2:SetText(g_DuanWei1[MatchId+12].." "..g_DuanWei1[5]..g_DuanWei1[4+6].."阶")
		local text2 = ScriptGlobal_Format("#{HSLJ_190919_189}", g_DuanWei1[5], g_DuanWei1[4+6])
		HuaShanLunJian_FightEnd_StageBK_Text2:SetText(text2)
	end
	
end

function HuaShanLunJian_FightEnd_5to6Timer()
	g_BigUpTimer = g_BigUpTimer - 1 
	if g_BigUpTimer == 0 then
		KillTimer("HuaShanLunJian_FightEnd_5to6Timer()")
		return
	end
	if g_BigUpTimer == g_AllTime2 - g_StarUpTime then --播放升段动画,星星置为空星
		HuaShanLunJian_FightEnd_GoupAnimate:Show()
		HuaShanLunJian_FightEnd_ImageAnimate:Show()
		HuaShanLunJian_FightEnd_GoupAnimate:SetProperty("Animate","HSLJ_GoupFlash")
		HuaShanLunJian_FightEnd_ImageAnimate:SetProperty("Animate","HSLJ_LightUpFlash")
		HuaShanLunJian_FightEnd_GoupAnimate:Play(true)
		HuaShanLunJian_FightEnd_ImageAnimate:Play(true)	
	end
	
	-- 给星星播特效留x秒
	if g_BigUpTimer > g_AllTime2 - g_StarUpTime then
		return 
	elseif g_BigUpTimer > g_AllTime2 - g_StarUpTime - g_StarKongTime2 then --给升小段动画留时间
		if g_BigUpTimer == g_AllTime2 - g_StarUpTime then --播放升段动画,星星置为空星
			-- 把上个段位的都隐掉，调用新的控件
			for i = 0,7 do
				g_StarAnim5[i]:Hide()
				g_Star5[i]:Hide()
			end
			HuaShanLunJian_FightEnd_Star3_1:Show()
			HuaShanLunJian_FightEnd_Star3_1:SetProperty("Image", g_ImageStar[2])
		end
		return
	elseif g_BigUpTimer == g_AllTime2 - g_StarUpTime - g_StarKongTime2 then --给加的第一个星星加特效。
		HuaShanLunJian_FightEnd_Star3_1:SetProperty("Image", g_ImageStar[1])
		HuaShanLunJian_FightEnd_Star3Text:SetText(ScriptGlobal_Format("#{HSSC_191009_73}",0))
		HuaShanLunJian_FightEnd_Star3_1Animate:Show()
		HuaShanLunJian_FightEnd_Star3_1Animate:SetProperty("Animate","HSLJ_LevelupStrars")
		HuaShanLunJian_FightEnd_Star3_1Animate:Play(true)
		KillTimer("HuaShanLunJian_FightEnd_5to6Timer()")
	end
	
	--切换段位图
	if g_BigUpTimer == g_AllTime2 - g_StarUpTime - g_StarKongTime2 then
		local MatchId = XBW:GetMatchId()
		if MatchId == 0 then
			HuaShanLunJian_FightEnd_Image:SetProperty("Image", g_Image[12+6]) -- 前面的数字是偏移量，后面的数字是当前的大段位
		elseif MatchId == 1 then
			HuaShanLunJian_FightEnd_Image:SetProperty("Image", g_Image[0+6])
		elseif MatchId == 2 then
			HuaShanLunJian_FightEnd_Image:SetProperty("Image", g_Image[6+6])
		else 
			return 
		end
		HuaShanLunJian_FightEnd_Text:Hide()
		--HuaShanLunJian_FightEnd_Text:SetProperty("Image", g_Image[4+18]) -- 后面的数字是偏移量，前面的数字是当前的小段位
		-- 填充左边的数据
		--HuaShanLunJian_FightEnd_StageBK_Text2:SetText(g_DuanWei1[MatchId+12].." "..g_DuanWei1[6])--..g_DuanWei1[4+6].."阶")
		local text2 = ScriptGlobal_Format("#{HSLJ_190919_190}", 0)
		HuaShanLunJian_FightEnd_StageBK_Text2:SetText(text2)--..g_DuanWei1[nCurMinorRank+6].."阶")
	end
	
end


function HuaShanLunJian_FightEnd_UpTimer()
	
	g_UpTimer = g_UpTimer - 1 
	if g_UpTimer == 0 or g_UpType == -1 then
		KillTimer("HuaShanLunJian_FightEnd_UpTimer()")
		return
	end
	if g_CurMajorRank == 1 then
		if g_UpTimer == g_AllTime1 - g_StarUpTime then --播放升段动画,星星置为空星
			
			HuaShanLunJian_FightEnd_ImageAnimate:Show()
			HuaShanLunJian_FightEnd_ImageAnimate:SetProperty("Animate","HSLJ_LightUpFlash")		
			HuaShanLunJian_FightEnd_ImageAnimate:Play(true)	
		end
	
		-- 给星星播特效留x秒
		if g_UpTimer > g_AllTime1 - g_StarUpTime then
			return 
		elseif g_UpTimer > g_AllTime1 - g_StarUpTime - g_StarKongTime1 then --给升小段动画留时间
			if g_UpTimer == g_AllTime1 - g_StarUpTime then --播放升段动画,星星置为空星
				for i = 0,2 do
					g_StarAnim1[i]:Hide()
					g_Star1[i]:Hide()
				end
				for i = 0,2 do
					g_Star1[i]:SetProperty("Image", g_ImageStar[2])
					g_Star1[i]:Show()
				end
			end
			return
		elseif g_UpTimer == g_AllTime1 - g_StarUpTime - g_StarKongTime1 then --给加的第一个星星加特效。
			-- g_Star1[0]:SetProperty("Image", g_ImageStar[1])
			-- g_StarAnim1[0]:Show()
			-- g_StarAnim1[0]:SetProperty("Animate","HSLJ_LevelupStrars")
			-- g_StarAnim1[0]:Play(true)
			KillTimer("HuaShanLunJian_FightEnd_UpTimer()")
		end
		
		-- 切小段位
		if g_UpTimer == g_AllTime1 - g_StarUpTime  - g_StarKongTime1 then --给加的第一个星星加特效。
			local nCurMajorRank,nCurMinorRank,nCurStar,nCurWeekAddMJB,nCurWeekMaxMJB,nAddMJB,nPreMajorRank,nPreMinorRank,nPreStar,nBWResult= XBW:GetResultData()
			local MatchId = XBW:GetMatchId()
			HuaShanLunJian_FightEnd_Text:Show()
			HuaShanLunJian_FightEnd_Text:SetProperty("Image", g_Image[nCurMinorRank+18]) -- 后面的数字是偏移量，前面的数字是当前的小段位
			-- 填充左边的数据
			--HuaShanLunJian_FightEnd_StageBK_Text2:SetText(g_DuanWei1[MatchId+12].." "..g_DuanWei1[nCurMajorRank]..g_DuanWei1[nCurMinorRank+6].."阶")
			local text2 = ScriptGlobal_Format("#{HSLJ_190919_189}",g_DuanWei1[nCurMajorRank], g_DuanWei1[nCurMinorRank+6])
			HuaShanLunJian_FightEnd_StageBK_Text2:SetText(text2)
		end
		
	elseif g_CurMajorRank == 2  then
		if g_UpTimer == g_AllTime1 - g_StarUpTime then --播放升段动画,星星置为空星
			
			HuaShanLunJian_FightEnd_ImageAnimate:Show()
			HuaShanLunJian_FightEnd_ImageAnimate:SetProperty("Animate","HSLJ_LightUpFlash")		
			HuaShanLunJian_FightEnd_ImageAnimate:Play(true)	
		end
		
		-- 给星星播特效留x秒
		if g_UpTimer > g_AllTime1 - g_StarUpTime then
			return 
		elseif g_UpTimer > g_AllTime1 - g_StarUpTime - g_StarKongTime1 then --给升小段动画留时间
			if g_UpTimer == g_AllTime1 - g_StarUpTime then --播放升段动画,星星置为空星
				for i = 0,3 do
					g_StarAnim2[i]:Hide()
					g_Star2[i]:Hide()
				end
				for i = 0,3 do
					g_Star2[i]:SetProperty("Image", g_ImageStar[2])
					g_Star2[i]:Show()
				end
			end
			return
		elseif g_UpTimer == g_AllTime1 - g_StarUpTime - g_StarKongTime1 then --给加的第一个星星加特效。
			-- g_Star2[0]:SetProperty("Image", g_ImageStar[1])
			-- g_StarAnim2[0]:Show()
			-- g_StarAnim2[0]:SetProperty("Animate","HSLJ_LevelupStrars")
			-- g_StarAnim2[0]:Play(true)
			KillTimer("HuaShanLunJian_FightEnd_UpTimer()")
		end
		
		
		-- 切小段位
		if g_UpTimer == g_AllTime1 - g_StarUpTime - g_StarKongTime1 then --给加的第一个星星加特效。
			local nCurMajorRank,nCurMinorRank,nCurStar,nCurWeekAddMJB,nCurWeekMaxMJB,nAddMJB,nPreMajorRank,nPreMinorRank,nPreStar,nBWResult= XBW:GetResultData()
			local MatchId = XBW:GetMatchId()
			HuaShanLunJian_FightEnd_Text:Show()
			HuaShanLunJian_FightEnd_Text:SetProperty("Image", g_Image[nCurMinorRank+18]) -- 后面的数字是偏移量，前面的数字是当前的小段位
			-- 填充左边的数据
			--HuaShanLunJian_FightEnd_StageBK_Text2:SetText(g_DuanWei1[MatchId+12].." "..g_DuanWei1[nCurMajorRank]..g_DuanWei1[nCurMinorRank+6].."阶")
			local text2 = ScriptGlobal_Format("#{HSLJ_190919_189}", g_DuanWei1[nCurMajorRank], g_DuanWei1[nCurMinorRank+6])
			HuaShanLunJian_FightEnd_StageBK_Text2:SetText(text2)
		end
		
	elseif g_CurMajorRank == 3  then
		if g_UpTimer == g_AllTime1 - g_StarUpTime then --播放升段动画,星星置为空星
			
			HuaShanLunJian_FightEnd_ImageAnimate:Show()
			HuaShanLunJian_FightEnd_ImageAnimate:SetProperty("Animate","HSLJ_LightUpFlash")		
			HuaShanLunJian_FightEnd_ImageAnimate:Play(true)	
		end
		
		-- 给星星播特效留x秒
		if g_UpTimer > g_AllTime1 - g_StarUpTime then
			return 
		elseif g_UpTimer > g_AllTime1 - g_StarUpTime - g_StarKongTime1 then --给升小段动画留时间
			if g_UpTimer == g_AllTime1 - g_StarUpTime then --播放升段动画,星星置为空星
				for i = 0,4 do
					g_StarAnim3[i]:Hide()
					g_Star3[i]:Hide()
				end
				for i = 0,4 do
					g_Star3[i]:SetProperty("Image", g_ImageStar[2])
					g_Star3[i]:Show()
				end
			end
			return
		elseif g_UpTimer == g_AllTime1 - g_StarUpTime - g_StarKongTime1 then --给加的第一个星星加特效。
			-- g_Star3[0]:SetProperty("Image", g_ImageStar[1])
			-- g_StarAnim3[0]:Show()
			-- g_StarAnim3[0]:SetProperty("Animate","HSLJ_LevelupStrars")
			-- g_StarAnim3[0]:Play(true)
			KillTimer("HuaShanLunJian_FightEnd_UpTimer()")
		end
		
		
		-- 切小段位
		if g_UpTimer == g_AllTime1 - g_StarUpTime - g_StarKongTime1 then --给加的第一个星星加特效。
			local nCurMajorRank,nCurMinorRank,nCurStar,nCurWeekAddMJB,nCurWeekMaxMJB,nAddMJB,nPreMajorRank,nPreMinorRank,nPreStar,nBWResult= XBW:GetResultData()
			local MatchId = XBW:GetMatchId()
			HuaShanLunJian_FightEnd_Text:Show()
			HuaShanLunJian_FightEnd_Text:SetProperty("Image", g_Image[nCurMinorRank+18]) -- 后面的数字是偏移量，前面的数字是当前的小段位
			-- 填充左边的数据
			--HuaShanLunJian_FightEnd_StageBK_Text2:SetText(g_DuanWei1[MatchId+12].." "..g_DuanWei1[nCurMajorRank]..g_DuanWei1[nCurMinorRank+6].."阶")
			local text2 = ScriptGlobal_Format("#{HSLJ_190919_189}", g_DuanWei1[nCurMajorRank], g_DuanWei1[nCurMinorRank+6])
			HuaShanLunJian_FightEnd_StageBK_Text2:SetText(text2)
		end
		
	elseif g_CurMajorRank == 4  then
		if g_UpTimer == g_AllTime1 - g_StarUpTime then --播放升段动画,星星置为空星
			
			HuaShanLunJian_FightEnd_ImageAnimate:Show()
			HuaShanLunJian_FightEnd_ImageAnimate:SetProperty("Animate","HSLJ_LightUpFlash")		
			HuaShanLunJian_FightEnd_ImageAnimate:Play(true)	
		end
		
		-- 给星星播特效留x秒
		if g_UpTimer > g_AllTime1 - g_StarUpTime then
			return 
		elseif g_UpTimer > g_AllTime1 - g_StarUpTime - g_StarKongTime1 then --给升小段动画留时间
			if g_UpTimer == g_AllTime1 - g_StarUpTime then --播放升段动画,星星置为空星
				for i = 0,5 do
					g_StarAnim4[i]:Hide()
					g_Star4[i]:Hide()
				end
				for i = 0,5 do
					g_Star4[i]:SetProperty("Image", g_ImageStar[2])
					g_Star4[i]:Show()
				end
			end
			return
		elseif g_UpTimer == g_AllTime1 - g_StarUpTime - g_StarKongTime1 then --给加的第一个星星加特效。
			-- g_Star4[0]:SetProperty("Image", g_ImageStar[1])
			-- g_StarAnim4[0]:Show()
			-- g_StarAnim4[0]:SetProperty("Animate","HSLJ_LevelupStrars")
			-- g_StarAnim4[0]:Play(true)
			KillTimer("HuaShanLunJian_FightEnd_UpTimer()")
		end
	
		-- 切小段位
		if g_UpTimer == g_AllTime1 - g_StarUpTime - g_StarKongTime1 then --给加的第一个星星加特效。
			local nCurMajorRank,nCurMinorRank,nCurStar,nCurWeekAddMJB,nCurWeekMaxMJB,nAddMJB,nPreMajorRank,nPreMinorRank,nPreStar,nBWResult= XBW:GetResultData()
			local MatchId = XBW:GetMatchId()
			HuaShanLunJian_FightEnd_Text:Show()
			HuaShanLunJian_FightEnd_Text:SetProperty("Image", g_Image[nCurMinorRank+18]) -- 后面的数字是偏移量，前面的数字是当前的小段位
			-- 填充左边的数据
			--HuaShanLunJian_FightEnd_StageBK_Text2:SetText(g_DuanWei1[MatchId+12].." "..g_DuanWei1[nCurMajorRank]..g_DuanWei1[nCurMinorRank+6].."阶")
			local text2 = ScriptGlobal_Format("#{HSLJ_190919_189}",g_DuanWei1[nCurMajorRank], g_DuanWei1[nCurMinorRank+6])
			HuaShanLunJian_FightEnd_StageBK_Text2:SetText(text2)
		end
	elseif g_CurMajorRank == 5  then
		if g_UpTimer == g_AllTime1 - g_StarUpTime then --播放升段动画,星星置为空星
			
			HuaShanLunJian_FightEnd_ImageAnimate:Show()
			HuaShanLunJian_FightEnd_ImageAnimate:SetProperty("Animate","HSLJ_LightUpFlash")		
			HuaShanLunJian_FightEnd_ImageAnimate:Play(true)	
		end
		
		-- 给星星播特效留x秒
		if g_UpTimer > g_AllTime1 - g_StarUpTime then
			return 
		elseif g_UpTimer > g_AllTime1 - g_StarUpTime - g_StarKongTime1 then --给升小段动画留时间
			if g_UpTimer == g_AllTime1 - g_StarUpTime then --播放升段动画,星星置为空星
				for i = 0,7 do
					g_StarAnim5[i]:Hide()
					g_Star5[i]:Hide()
				end
				for i = 0,7 do
					g_Star5[i]:SetProperty("Image", g_ImageStar[2])
					g_Star5[i]:Show()
				end
			end
			return
		elseif g_UpTimer == g_AllTime1 - g_StarUpTime - g_StarKongTime1 then --给加的第一个星星加特效。
			-- g_Star5[0]:SetProperty("Image", g_ImageStar[1])
			-- g_StarAnim5[0]:Show()
			-- g_StarAnim5[0]:SetProperty("Animate","HSLJ_LevelupStrars")
			-- g_StarAnim5[0]:Play(true)
			KillTimer("HuaShanLunJian_FightEnd_UpTimer()")
		end
	
		-- 切小段位
		if g_UpTimer == g_AllTime1 - g_StarUpTime - g_StarKongTime1 then --给加的第一个星星加特效。
			local nCurMajorRank,nCurMinorRank,nCurStar,nCurWeekAddMJB,nCurWeekMaxMJB,nAddMJB,nPreMajorRank,nPreMinorRank,nPreStar,nBWResult= XBW:GetResultData()
			local MatchId = XBW:GetMatchId()
			HuaShanLunJian_FightEnd_Text:Show()
			HuaShanLunJian_FightEnd_Text:SetProperty("Image", g_Image[nCurMinorRank+18]) -- 后面的数字是偏移量，前面的数字是当前的小段位
			-- 填充左边的数据
			--HuaShanLunJian_FightEnd_StageBK_Text2:SetText(g_DuanWei1[MatchId+12].." "..g_DuanWei1[nCurMajorRank]..g_DuanWei1[nCurMinorRank+6].."阶")
			local text2 = ScriptGlobal_Format("#{HSLJ_190919_189}", g_DuanWei1[nCurMajorRank], g_DuanWei1[nCurMinorRank+6])
			HuaShanLunJian_FightEnd_StageBK_Text2:SetText(text2)
		end
	end
	
end


function HuaShanLunJian_FightEnd_Close()

	KillTimer("HuaShanLunJian_FightEnd_UpTimer()")
	KillTimer("HuaShanLunJian_FightEnd_5to6Timer()")
	KillTimer("HuaShanLunJian_FightEnd_4to5Timer()")
	KillTimer("HuaShanLunJian_FightEnd_3to4Timer()")
	KillTimer("HuaShanLunJian_FightEnd_2to3Timer()")
	KillTimer("HuaShanLunJian_FightEnd_1to2Timer()")
	this:Hide()
	
end