--华山论剑 新比武大会

local g_HuaShanLunJian_Frame_UnifiedPosition;
local g_HuaShanLunJian_Star3 = {} --3颗星星
local g_HuaShanLunJian_Star4 = {} --4颗星星
local g_HuaShanLunJian_Star5 = {} --5颗星星
local g_HuaShanLunJian_Star6 = {} --6颗星星
local g_HuaShanLunJian_Star8 = {} --8颗星星

local g_HuaShanLunJian_Dw2_Button = {} --段位奖励 小段位按钮
local g_HuaShanLunJian_Rank_Button = {} --段位奖励 小段位按钮

local g_HuaShanLunJian_DuanWei_ActionItem = {}
local g_HuaShanLunJian_DuanWei_LingQu = {}

local g_HuaShanLunJian_Rank_ActionItem = {}

local g_HuaShanLunJian_PrizeButton = {}
local g_HuaShanLunJian_DuanWei_1
local g_HuaShanLunJian_DuanWei_2
local g_HuaShanLunJian_Rank_1
local g_HuaShanLunJian_Rank_2
local g_HuaShanLunJian_MyRank 
local g_HuaShanLunJian_Rank_LingQu = {}
local g_HuaShanLunJian_TargetId

local g_HuaShanLunJian_RedPoint_Duan
local g_HuaShanLunJian_RedPoint_Jie = {} 
local g_HuaShanLunJian_RedPoint_Button

local g_Duanwei1_Image = {

	[0] = {
		[1] = "set:HSLJ_04 image:HSLJ_Hawk1",
		[2] = "set:HSLJ_04 image:HSLJ_Hawk2",
		[3] = "set:HSLJ_04 image:HSLJ_Hawk3",
		[4] = "set:HSLJ_04 image:HSLJ_Hawk4",
		[5] = "set:HSLJ_04 image:HSLJ_Hawk5",
		[6] = "set:HSLJ_04 image:HSLJ_Hawk6",
	},
	
	[1] = {
		[1] = "set:HSLJ_01 image:HSLJ_Tiger1",
		[2] = "set:HSLJ_01 image:HSLJ_Tiger2",
		[3] = "set:HSLJ_02 image:HSLJ_Tiger3",
		[4] = "set:HSLJ_02 image:HSLJ_Tiger4",
		[5] = "set:HSLJ_02 image:HSLJ_Tiger5",
		[6] = "set:HSLJ_02 image:HSLJ_Tiger6",
	},	

	[2] = {
		[1] = "set:HSLJ_01 image:HSLJ_Dragon1",
		[2] = "set:HSLJ_01 image:HSLJ_Dragon2",
		[3] = "set:HSLJ_01 image:HSLJ_Dragon3",
		[4] = "set:HSLJ_01 image:HSLJ_Dragon4",
		[5] = "set:HSLJ_01 image:HSLJ_Dragon5",
		[6] = "set:HSLJ_01 image:HSLJ_Dragon6",
	},
}
local g_Duanwei1_name = {
	[1] = "#{HSLJ_190919_145}",
	[2] = "#{HSLJ_190919_146}",
	[3] = "#{HSLJ_190919_147}",
	[4] = "#{HSLJ_190919_148}",
	[5] = "#{HSLJ_190919_149}",
	[6] = "#{HSLJ_190919_157}",
}

local g_Duanwei2_Info = {
	[1] = {image="set:HSLJ_Match1 image:Number1", name="#{HSLJ_190919_154}"},
	[2] = {image="set:HSLJ_Match1 image:Number2", name="#{HSLJ_190919_153}"},
	[3] = {image="set:HSLJ_Match1 image:Number3", name="#{HSLJ_190919_152}"},
	[4] = {image="set:HSLJ_Match1 image:Number4", name="#{HSLJ_190919_151}"},
	[5] = {image="set:HSLJ_Match1 image:Number5", name="#{HSLJ_190919_150}"},
}

local g_FightLevel = {
	[1] = "#{HSLJ_190919_142}",
	[2] = "#{HSLJ_190919_143}",
	[3] = "#{HSLJ_190919_144}",
	}

local g_RankText = {
	[1] = "#{HSLJ_190919_229}",
	[2] = "#{HSLJ_190919_230}",
	[3] = "#{HSLJ_190919_231}",
	[4] = "#{HSLJ_190919_232}",
	}
	
local g_RankAward = {
	[0] = {
		[1] = { {id=20501003, num=5}, {id=20502003, num=5}, {id=38002485, num=1} },
		[2] = { {id=20501003, num=3}, {id=20502003, num=3}, {id=38002486, num=1} },
		[3] = { {id=20501003, num=2}, {id=20502003, num=2}, {id=38002487, num=1} },
		[4] = { {id=20501003, num=1}, {id=20502003, num=1} },
	},
	[1] = {
		[1] = { {id=20501003, num=5}, {id=20502003, num=5}, {id=38002418, num=1} },
		[2] = { {id=20501003, num=3}, {id=20502003, num=3}, {id=38002419, num=1} },
		[3] = { {id=20501003, num=2}, {id=20502003, num=2}, {id=38002420, num=1} },
		[4] = { {id=20501003, num=1}, {id=20502003, num=1} },
	},	
	[2] = {
		[1] = { {id=20501003, num=5}, {id=20502003, num=5}, {id=38002421, num=1} },
		[2] = { {id=20501003, num=3}, {id=20502003, num=3}, {id=38002422, num=1} },
		[3] = { {id=20501003, num=2}, {id=20502003, num=2}, {id=38002423, num=1} },
		[4] = { {id=20501003, num=1}, {id=20502003, num=1} },
	},
}
	
local g_Bright_Stars = "set:HSLJ_01 image:HSLJ_Star"
local g_Gray_Stars = "set:HSLJ_01 image:HSLJ_StarGray"

local g_DwWangzhe = 6


function HuaShanLunJian_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("XBW_SELF_DETAIL_UPDATE")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
	
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function HuaShanLunJian_OnLoad()
	g_HuaShanLunJian_Frame_UnifiedPosition = HuaShanLunJian_Frame:GetProperty("UnifiedPosition");

	g_HuaShanLunJian_Star3[1] = HuaShanLunJian_Stage_Star1
	g_HuaShanLunJian_Star3[2] = HuaShanLunJian_Stage_Star2
	g_HuaShanLunJian_Star3[3] = HuaShanLunJian_Stage_Star3

	g_HuaShanLunJian_Star4[1] = HuaShanLunJian_Stage_Star1_1
	g_HuaShanLunJian_Star4[2] = HuaShanLunJian_Stage_Star1_2
	g_HuaShanLunJian_Star4[3] = HuaShanLunJian_Stage_Star1_3
	g_HuaShanLunJian_Star4[4] = HuaShanLunJian_Stage_Star1_4

	g_HuaShanLunJian_Star5[1] = HuaShanLunJian_Stage_Star2_1
	g_HuaShanLunJian_Star5[2] = HuaShanLunJian_Stage_Star2_2
	g_HuaShanLunJian_Star5[3] = HuaShanLunJian_Stage_Star2_3
	g_HuaShanLunJian_Star5[4] = HuaShanLunJian_Stage_Star2_4
	g_HuaShanLunJian_Star5[5] = HuaShanLunJian_Stage_Star2_5
  
	g_HuaShanLunJian_Star6[1] = HuaShanLunJian_Stage_Star4_1
	g_HuaShanLunJian_Star6[2] = HuaShanLunJian_Stage_Star4_2
	g_HuaShanLunJian_Star6[3] = HuaShanLunJian_Stage_Star4_3
	g_HuaShanLunJian_Star6[4] = HuaShanLunJian_Stage_Star4_4
	g_HuaShanLunJian_Star6[5] = HuaShanLunJian_Stage_Star4_5
	g_HuaShanLunJian_Star6[6] = HuaShanLunJian_Stage_Star4_6
  
	g_HuaShanLunJian_Star8[1] = HuaShanLunJian_Stage_Star5_1
	g_HuaShanLunJian_Star8[2] = HuaShanLunJian_Stage_Star5_2
	g_HuaShanLunJian_Star8[3] = HuaShanLunJian_Stage_Star5_3
	g_HuaShanLunJian_Star8[4] = HuaShanLunJian_Stage_Star5_4
	g_HuaShanLunJian_Star8[5] = HuaShanLunJian_Stage_Star5_5
	g_HuaShanLunJian_Star8[6] = HuaShanLunJian_Stage_Star5_6
	g_HuaShanLunJian_Star8[7] = HuaShanLunJian_Stage_Star5_7
	g_HuaShanLunJian_Star8[8] = HuaShanLunJian_Stage_Star5_8
  
	g_HuaShanLunJian_Dw2_Button[1] = HuaShanLunJian_DanAward_LiftOne
	g_HuaShanLunJian_Dw2_Button[2] = HuaShanLunJian_DanAward_LiftTwo
	g_HuaShanLunJian_Dw2_Button[3] = HuaShanLunJian_DanAward_LiftThree
	g_HuaShanLunJian_Dw2_Button[4] = HuaShanLunJian_DanAward_LiftFour
  
	g_HuaShanLunJian_Rank_Button[1] = HuaShanLunJian_DanAward_RightOne
	g_HuaShanLunJian_Rank_Button[2] = HuaShanLunJian_DanAward_RightTwo
	g_HuaShanLunJian_Rank_Button[3] = HuaShanLunJian_DanAward_RightThree
	g_HuaShanLunJian_Rank_Button[4] = HuaShanLunJian_DanAward_RightFour
	
	g_HuaShanLunJian_DuanWei_ActionItem[1] = HuaShanLunJian_LiftBtn01
	g_HuaShanLunJian_DuanWei_ActionItem[2] = HuaShanLunJian_LiftBtn02
	g_HuaShanLunJian_DuanWei_ActionItem[3] = HuaShanLunJian_LiftBtn03
	
	g_HuaShanLunJian_DuanWei_LingQu[1] = HuaShanLunJian_LiftBtn01YiLing
	g_HuaShanLunJian_DuanWei_LingQu[2] = HuaShanLunJian_LiftBtn02YiLing
	g_HuaShanLunJian_DuanWei_LingQu[3] = HuaShanLunJian_LiftBtn03YiLing
	
	g_HuaShanLunJian_Rank_ActionItem[1] = HuaShanLunJian_RightBtn01
	g_HuaShanLunJian_Rank_ActionItem[2] = HuaShanLunJian_RightBtn02
	g_HuaShanLunJian_Rank_ActionItem[3] = HuaShanLunJian_RightBtn03
	
	g_HuaShanLunJian_PrizeButton[1] = HuaShanLunJian_GetAward
	g_HuaShanLunJian_PrizeButton[1]:SetText("#{HSLJ_190919_15}")
	g_HuaShanLunJian_PrizeButton[1]:Enable()	
	g_HuaShanLunJian_PrizeButton[2] = HuaShanLunJian_GetAward2
	g_HuaShanLunJian_PrizeButton[2]:SetText("#{HSLJ_190919_15}")
	g_HuaShanLunJian_PrizeButton[2]:Enable()		
	g_HuaShanLunJian_DuanWei_1 = -1
	g_HuaShanLunJian_DuanWei_2 = -1
	g_HuaShanLunJian_Rank_1 = -1
	g_HuaShanLunJian_Rank_2 = -1 
	g_HuaShanLunJian_MyRank	= -1
	g_HuaShanLunJian_TargetId = -1
	g_HuaShanLunJian_Rank_LingQu[1] = HuaShanLunJian_RightBtn01YiLing
	g_HuaShanLunJian_Rank_LingQu[2] = HuaShanLunJian_RightBtn02YiLing
	g_HuaShanLunJian_Rank_LingQu[3] = HuaShanLunJian_RightBtn03YiLing	
	
	g_HuaShanLunJian_RedPoint_Duan = HuaShanLunJian_DanAward_LiftList_Tips
	g_HuaShanLunJian_RedPoint_Jie[1] = HuaShanLunJian_DanAward_LiftOne_Tips
	g_HuaShanLunJian_RedPoint_Jie[2] = HuaShanLunJian_DanAward_LiftTwo_Tips
	g_HuaShanLunJian_RedPoint_Jie[3] = HuaShanLunJian_DanAward_LiftThree_Tips
	g_HuaShanLunJian_RedPoint_Jie[4] = HuaShanLunJian_DanAward_LiftFour_Tips
	g_HuaShanLunJian_RedPoint_Button = HuaShanLunJian_GetAward_Tips
end

-- OnEvent
function HuaShanLunJian_OnEvent(event)
	--
	if ( event == "UI_COMMAND" and tonumber(arg0) == 89289503 ) then 
		if Get_XParam_INT(0) == 0 then
			HuaShanLunJian_CloseWindow()
		else
			HuaShanLunJian_BeginCare( Get_XParam_INT(1) )
			g_HuaShanLunJian_TargetId = Get_XParam_INT(1)
		end
	elseif ( event == "XBW_SELF_DETAIL_UPDATE" ) then
		local levelIndex = Player:Lua_GetXbwData( "LevelIndex" )
		if levelIndex < 0 or levelIndex > 2 then
			return
		end

		local nCurDuanWei1 = Player:Lua_GetXbwData( "CuruanWei1" )
		if nCurDuanWei1 <= 0 or nCurDuanWei1 > 6 then
			PushDebugMessage("大段位错误")
			return
		end

		local nCurDuanWei2 = Player:Lua_GetXbwData( "CuruanWei2" )
		if nCurDuanWei2 <= 0 or nCurDuanWei2 > 4 then
			PushDebugMessage("小段位错误")
			return
		end

		local nCurDuanWei3 = Player:Lua_GetXbwData( "CuruanWei3" )
		if nCurDuanWei3 < 0 then
			PushDebugMessage("星数错误")
			return
		end

		g_HuaShanLunJian_MyRank = tonumber(arg0)
		
		HuaShanLunJian_Init()
		HuaShanLunJian_Update_Top()
			
		HuaShanLunJian_Update_RankAward( )
		HuaShanLunJian_Update_DuanWeiAward( )
		
		this:Show()

	elseif ( event == "HIDE_ON_SCENE_TRANSED" ) then
		HuaShanLunJian_CloseWindow()

	elseif (event == "ADJEST_UI_POS" ) then
		HuaShanLunJian_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		HuaShanLunJian_ResetPos()
		
	end
end

--=========
--Care Obj
--=========
function HuaShanLunJian_BeginCare( serverObjId )
	local objCared = DataPool : GetNPCIDByServerID(serverObjId)
	this:CareObject(objCared, 1)
end

function HuaShanLunJian_Init( )
	HuaShanLunJian_Stage_StarSet:Hide()
	HuaShanLunJian_Stage_StarSet1:Hide()
	HuaShanLunJian_Stage_StarSet2:Hide()
	HuaShanLunJian_Stage_StarSet3:Hide()
	HuaShanLunJian_Stage_StarSet4:Hide()
	HuaShanLunJian_Stage_StarSet5:Hide()
	g_HuaShanLunJian_RedPoint_Duan:Hide()
	g_HuaShanLunJian_RedPoint_Jie[1]:Hide()
	g_HuaShanLunJian_RedPoint_Jie[2]:Hide()
	g_HuaShanLunJian_RedPoint_Jie[3]:Hide()
	g_HuaShanLunJian_RedPoint_Jie[4]:Hide()
	g_HuaShanLunJian_RedPoint_Button:Hide()
end


function HuaShanLunJian_Update_Top( )

	local curDay = tonumber(DataPool:GetServerDayTime());
	local nIndex,seasonBeg,seasonEnd = XBW:GetXbwGetRecentSeasonInfo(curDay)
	if nIndex == nil or nIndex < 0 then
		return
	end
	local yearBeg = math.floor(seasonBeg / 10000)
	local monthBeg = math.mod(math.floor(seasonBeg / 100), 100)
	local dayBeg = math.mod(seasonBeg, 100)
	
	local yearEnd = math.floor(seasonEnd / 10000)
	local monthEnd = math.mod(math.floor(seasonEnd / 100), 100)
	local dayEnd = math.mod(seasonEnd, 100)
	
	local dayText = ScriptGlobal_Format("#{HSLJ_190919_215}", tostring(monthBeg), tostring(dayBeg), tostring(monthEnd), tostring(dayEnd))
	HuaShanLunJian_Text8Info:SetText( dayText )

	--大段位
	local nCurDuanWei1 = Player:Lua_GetXbwData( "CuruanWei1" )
	local levelIndex = Player:Lua_GetXbwData( "LevelIndex" )
	HuaShanLunJian_Dan_Image:SetProperty("Image", g_Duanwei1_Image[levelIndex][nCurDuanWei1])

	--小段位
	local nCurDuanWei2 = Player:Lua_GetXbwData( "CuruanWei2" )
	if nCurDuanWei1 ~= g_DwWangzhe then
		HuaShanLunJian_Dan_Text:SetProperty("Image", g_Duanwei2_Info[nCurDuanWei2].image)
		HuaShanLunJian_Dan_Text:Show()
	else
		HuaShanLunJian_Dan_Text:Hide()
	end

	--星星
	local nCurDuanWei3 = Player:Lua_GetXbwData( "CuruanWei3" )
	if nCurDuanWei3 == nil then
		return
	end

	local nMaxDuanWei3 = XBW:GetXbwDuanweinfo(nCurDuanWei1, nCurDuanWei2)
	if  nCurDuanWei1 == g_DwWangzhe then --王者
		HuaShanLunJian_Stage_StarSet3:Show()
		HuaShanLunJian_Stage_Star3_1:SetProperty("Image", g_Bright_Stars)
		HuaShanLunJian_Stage_Star3_1:SetToolTip("#{HSLJ_190919_326}")
			
		local dw3Text = ScriptGlobal_Format("#{HSLJ_190919_25}", tostring(nCurDuanWei3))
		HuaShanLunJian_Stage_Star3Text:SetText(dw3Text)

	elseif nMaxDuanWei3 == 3 then
		HuaShanLunJian_Stage_StarSet:Show()
		for i=1, nMaxDuanWei3 do
			if i <= nCurDuanWei3 then
				g_HuaShanLunJian_Star3[i]:SetProperty("Image", g_Bright_Stars)
			else
				g_HuaShanLunJian_Star3[i]:SetProperty("Image", g_Gray_Stars)
			end
			g_HuaShanLunJian_Star3[i]:SetToolTip("#{HSLJ_190919_326}")
		end

	elseif nMaxDuanWei3 == 4 then
		HuaShanLunJian_Stage_StarSet1:Show()
		for i=1,nMaxDuanWei3 do
			if i <= nCurDuanWei3 then
				g_HuaShanLunJian_Star4[i]:SetProperty("Image", g_Bright_Stars)
			else
				g_HuaShanLunJian_Star4[i]:SetProperty("Image", g_Gray_Stars)
			end
			g_HuaShanLunJian_Star4[i]:SetToolTip("#{HSLJ_190919_326}")
		end
		
	elseif nMaxDuanWei3 == 5 then
		HuaShanLunJian_Stage_StarSet2:Show()
		for i=1,nMaxDuanWei3 do
			if i <= nCurDuanWei3 then
				g_HuaShanLunJian_Star5[i]:SetProperty("Image", g_Bright_Stars)
			else
				g_HuaShanLunJian_Star5[i]:SetProperty("Image", g_Gray_Stars)
			end
			g_HuaShanLunJian_Star5[i]:SetToolTip("#{HSLJ_190919_326}")
		end
		
	elseif nMaxDuanWei3 == 6 then
		HuaShanLunJian_Stage_StarSet4:Show()
		for i=1,nMaxDuanWei3 do
			if i <= nCurDuanWei3 then
				g_HuaShanLunJian_Star6[i]:SetProperty("Image", g_Bright_Stars)
			else
				g_HuaShanLunJian_Star6[i]:SetProperty("Image", g_Gray_Stars)
			end
			g_HuaShanLunJian_Star6[i]:SetToolTip("#{HSLJ_190919_326}")
		end
		
	elseif nMaxDuanWei3 == 8 then
		HuaShanLunJian_Stage_StarSet5:Show()
		for i=1,nMaxDuanWei3 do
			if i <= nCurDuanWei3 then
				g_HuaShanLunJian_Star8[i]:SetProperty("Image", g_Bright_Stars)
			else
				g_HuaShanLunJian_Star8[i]:SetProperty("Image", g_Gray_Stars)
			end
			g_HuaShanLunJian_Star8[i]:SetToolTip("#{HSLJ_190919_326}")
		end
	end

	--华山论剑第X赛季 AAA
	local levelName = g_FightLevel[levelIndex + 1]
	local titleText = ScriptGlobal_Format("#{HSLJ_190919_27}", tostring(nIndex+1), levelName)
	HuaShanLunJian_UpRight_Title:SetText(titleText)
	
	--当前段位
	local curDwText = ""
	if nCurDuanWei1 < g_DwWangzhe then
		curDwText = ScriptGlobal_Format("#{HSLJ_190919_23}", g_Duanwei1_name[nCurDuanWei1], g_Duanwei2_Info[nCurDuanWei2].name)
	else
		curDwText = "#{HSLJ_190919_157}"
	end
	HuaShanLunJian_Text1Info:SetText(curDwText)
	
	--赛季排名
	local mRank,mName,mLevel,nMenPai = XBW:GetSelfInfo()
	if mRank == 255 then
		HuaShanLunJian_Text2Info:SetText("#{HSLJ_190919_210}")
	else
		local rankText = ScriptGlobal_Format("#{HSLJ_190919_211}", tostring(mRank+1))
		HuaShanLunJian_Text2Info:SetText(rankText)
	end

	--赛季的参与次数
	local nSeasonPartCnt = Player:Lua_GetXbwData( "SeasonPartCnt" )
	local partCntText = ScriptGlobal_Format("#{HSLJ_190919_207}", tostring(nSeasonPartCnt))
	HuaShanLunJian_Text3Info:SetText( partCntText )

	--	获胜场次
	local nSeasonWinCnt = Player:Lua_GetXbwData( "SeasonWinCnt" )
	local winCntText = ScriptGlobal_Format("#{HSLJ_190919_207}", tostring(nSeasonWinCnt))
	HuaShanLunJian_Text4Info:SetText(winCntText)
	
	--赛季胜率
	if nSeasonPartCnt == 0 then
		HuaShanLunJian_Text5Info:SetText("#{HSLJ_190919_31}")
	else
		local nSeasonWinCnt = Player:Lua_GetXbwData( "SeasonWinCnt" )
		local result = math.floor( (nSeasonWinCnt/nSeasonPartCnt) * 100 )
		local text6 = ScriptGlobal_Format("#{HSLJ_190919_164}", tostring(result))
		HuaShanLunJian_Text5Info:SetText(text6)
	end

	--	当前连胜场次
	local nCurConWinCnt = Player:Lua_GetXbwData( "CurConWinCnt" )
	local curConWinCntText = ScriptGlobal_Format("#{HSLJ_190919_207}", tostring(nCurConWinCnt))
	HuaShanLunJian_Text6Info:SetText(curConWinCntText)
	
	--赛季最高连胜场次
	local nSeasonConWinCnt = Player:Lua_GetXbwData( "SeasonConWinCnt" )
	local conWinCntText = ScriptGlobal_Format("#{HSLJ_190919_207}", tostring(nSeasonConWinCnt))
	HuaShanLunJian_Text7Info:SetText(conWinCntText)

end

function HuaShanLunJian_Update_DuanWeiAward( )

	--当前：段位、阶
	local nCurDuanWei1 = Player:Lua_GetXbwData( "CuruanWei1" )
	local nCurDuanWei2 = Player:Lua_GetXbwData( "CuruanWei2" )
	
	--目前最低未领奖的信息：段位、阶
	local nStopDuanWei = -1
	local nStopJie = -1
	
	--已领取全部可领取的奖励
	local LingQuPrizeAll = 1
	for i=1, nCurDuanWei1 do
		for j=1, XBW:GetXbwMaxDuanWei2(i) do
			if i==nCurDuanWei1 and j<nCurDuanWei2 then
				break
			end
			--因为阶是逆序的，数越大，阶越低，所以遍历领奖时，需要再逆回来
			local HaveLingQuPrize = Player:Lua_GetXbwData("GetDuanWeiReward",i-1, j-1)	
			--特写
			if i==1 and j==2 then
				HaveLingQuPrize = 1
			end
			if HaveLingQuPrize == 0 then
				LingQuPrizeAll = 0
			end
		end
	end
	
	--遍历领奖情况：从低到高，确定最低未领奖的：段位、阶
	for i=1, nCurDuanWei1 do
		for j=1, XBW:GetXbwMaxDuanWei2(i) do
			--因为阶是逆序的，数越大，阶越低，所以遍历领奖时，需要再逆回来
			local k = XBW:GetXbwMaxDuanWei2(i)-j+1
			local HaveLingQuPrize = Player:Lua_GetXbwData("GetDuanWeiReward",i-1, k-1)
			--特写
			if i==1 and k==2 then
				HaveLingQuPrize = 1
			end
			--特写
			-- if (i == nCurDuanWei1) and (j < nCurDuanWei2) then
				-- nStopDuanWei = i
				-- nStopJie = k				
				-- i = 999
				-- break			
			-- end
			if HaveLingQuPrize ~= 1 then
				nStopDuanWei = i
				nStopJie = k
				--LingQuPrizeAll = 0
				i = 999
				break
			else
				nStopDuanWei = i
				nStopJie = k				
			end
		end
		if (i == 999) then
			break
		end
	end
	local nextDw1 = nStopDuanWei
	local nextDw2 = nStopJie
	
	--如果是初始段位，显示：一段一阶
	if (nCurDuanWei1 == 1) and (nCurDuanWei2 == 2) then
		nextDw1 = 1
		nextDw2 = 1
	--如果已达到最高段位，且领取完奖励，显示：霸剑
	elseif (nCurDuanWei1 == g_DwWangzhe) and (LingQuPrizeAll == 1)then
		nextDw1 = g_DwWangzhe
		nextDw2 = 1
	--否则
	else
		--可领：已领完，显示：下一级
		if (LingQuPrizeAll == 1) then
			if nextDw2 == 1 then
				if (nStopDuanWei < g_DwWangzhe) then
					nextDw1 = nStopDuanWei + 1
					nextDw2 = XBW:GetXbwMaxDuanWei2(nextDw1)
				else
					nextDw1 = g_DwWangzhe --nStopDuanWei
				end
				
			else
				nextDw1 = nStopDuanWei
				--nextDw2 = nStopJie - 1
				nextDw2 = nStopJie				
			end
		--可领：没领完，显示：当前级
		else
			nextDw1 = nStopDuanWei
			nextDw2 = nStopJie
			if (nextDw1 == 1) and (nextDw2 == 2) then
				nextDw2 = 1
			end
		end
	end
	
	HuaShanLunJian_DanAward_LiftList:ResetList()

	for i = 1, table.getn(g_Duanwei1_name) do 
		HuaShanLunJian_DanAward_LiftList:AddTextItem(g_Duanwei1_name[i], i) 
	end 
	
	--容错处理
	if nextDw1 < 1 or nextDw1 > g_DwWangzhe or nextDw2 < 1 or nextDw2 > 4 then
		nextDw1 = nCurDuanWei1
		nextDw2 = nCurDuanWei2 - 1
		if nCurDuanWei2 == 1 then
			nextDw1 = nCurDuanWei1 + 1
			nextDw2 = XBW:GetXbwMaxDuanWei2(nextDw1)
		end		
	end

	if LingQuPrizeAll == 1 then
		g_HuaShanLunJian_RedPoint_Duan:Hide()
	else
		g_HuaShanLunJian_RedPoint_Duan:Show()
	end
	
	HuaShanLunJian_DanAward_LiftList:SetCurrentSelect(nextDw1 - 1)
	HuaShanLunJian_DanAward_AwardButton(nextDw1, nextDw2)
end


function HuaShanLunJian_Update_RankAward( )

	local levelIndex = Player:Lua_GetXbwData( "LevelIndex" )
	
	HuaShanLunJian_DanAward_RightList:ResetList()
	
	for i = 1, table.getn(g_FightLevel) do 
		HuaShanLunJian_DanAward_RightList:AddTextItem(g_FightLevel[i], i-1) 
	end 
	
	HuaShanLunJian_DanAward_RightList:SetCurrentSelect(levelIndex)
	HuaShanLunJian_Rank_AwardButton( levelIndex, 1 )
end


function HuaShanLunJian_CloseWindow()
	this:Hide()
end

function HuaShanLunJian_DuanWeiHelp()
	PushEvent("QUEST_HELPINFO","#{HSLJ_190919_206}")
end

function HuaShanLunJian_RankHelp()
	PushEvent("QUEST_HELPINFO","#{HSLJ_190919_212}")
end

function HuaShanLunJian_DanAward_LineChanged()
	local _name, comIdx = HuaShanLunJian_DanAward_LiftList:GetCurrentSelect()
	
	if comIdx == 1 then
		HuaShanLunJian_DanAward_AwardButton(comIdx, 1)
	
	elseif comIdx >= 2 and comIdx <= g_DwWangzhe then 
		local maxCurDw2 = XBW:GetXbwMaxDuanWei2(comIdx)
		HuaShanLunJian_DanAward_AwardButton(comIdx, maxCurDw2)
	end
end

function HuaShanLunJian_DanAward_ButtonChanged( buttonIndex )
	local _name, comIdx = HuaShanLunJian_DanAward_LiftList:GetCurrentSelect()	
	HuaShanLunJian_DanAward_AwardButton(comIdx, buttonIndex)
end

function HuaShanLunJian_DanAward_AwardButton(dw1, dw2)
	g_HuaShanLunJian_DuanWei_1 = dw1
	g_HuaShanLunJian_DuanWei_2 = dw2

	local nCurDuanWei1 = Player:Lua_GetXbwData( "CuruanWei1" )
	local nCurDuanWei2 = Player:Lua_GetXbwData( "CuruanWei2" )
	g_HuaShanLunJian_RedPoint_Jie[1]:Hide()
	g_HuaShanLunJian_RedPoint_Jie[2]:Hide()
	g_HuaShanLunJian_RedPoint_Jie[3]:Hide()
	g_HuaShanLunJian_RedPoint_Jie[4]:Hide()	
	g_HuaShanLunJian_RedPoint_Button:Hide()	
			
	local maxDw2 = XBW:GetXbwMaxDuanWei2(dw1)
	for index=1, maxDw2 do
		if index == dw2 then
			g_HuaShanLunJian_Dw2_Button[index]:SetCheck(1)
		else
			g_HuaShanLunJian_Dw2_Button[index]:SetCheck(0)
		end
		g_HuaShanLunJian_Dw2_Button[index]:Show()
		--各阶是否已经领奖
		--选择的段位 > 真实段位：Hide
		if (dw1 > nCurDuanWei1) then
			g_HuaShanLunJian_RedPoint_Jie[1]:Hide()
			g_HuaShanLunJian_RedPoint_Jie[2]:Hide()
			g_HuaShanLunJian_RedPoint_Jie[3]:Hide()
			g_HuaShanLunJian_RedPoint_Jie[4]:Hide()
		--选择的段位 = 真实段位：
		--阶数 >= 真实阶数的：领过奖励的，Hide；未领过奖励的，Show
		--阶数 < 真实阶数的：Hide
		elseif (dw1 == nCurDuanWei1) then
			if (index >= nCurDuanWei2) then
				local GetPrize = Player:Lua_GetXbwData("GetDuanWeiReward",dw1-1, index-1)
				--特写
				if dw1 == 1 and index == 2 then
					GetPrize = 1
				end	
				
				if GetPrize == 1 then
					g_HuaShanLunJian_RedPoint_Jie[index]:Hide()
				else
					g_HuaShanLunJian_RedPoint_Jie[index]:Show()
				end			
			else
				g_HuaShanLunJian_RedPoint_Jie[index]:Hide()	
			end

		--选择的段位 < 真实段位：领过奖励的，Hide；未领过奖励的，Show
		else
			local GetPrize = Player:Lua_GetXbwData("GetDuanWeiReward",dw1-1, index-1)
			if GetPrize == 1 then
				g_HuaShanLunJian_RedPoint_Jie[index]:Hide()
			else
				--特写
				if dw1 == 1 and index == 2 then
				
				else
					g_HuaShanLunJian_RedPoint_Jie[index]:Show()
				end
			end
		end
		
	end	
	
	for index=maxDw2+1, table.getn(g_HuaShanLunJian_Dw2_Button) do
		g_HuaShanLunJian_Dw2_Button[index]:Hide()
	end
	
	--做个修正
	if dw1 == 1 then
		g_HuaShanLunJian_Dw2_Button[2]:Hide()
	end
	
	--霸剑：隐藏这一行
	if dw1 == g_DwWangzhe then
		for i=1, table.getn(g_HuaShanLunJian_Dw2_Button) do
			g_HuaShanLunJian_Dw2_Button[i]:Hide()
		end
		--dw2 = 1		
	end
	
	for i=1, table.getn(g_HuaShanLunJian_DuanWei_ActionItem) do
		g_HuaShanLunJian_DuanWei_ActionItem[i]:SetActionItem(-1)
		g_HuaShanLunJian_DuanWei_ActionItem[i]:Hide()
		g_HuaShanLunJian_DuanWei_LingQu[i]:Hide()		
	end
	
	if dw1 > g_DwWangzhe then
		return
	end
	
	local HaveGetPrize = Player:Lua_GetXbwData("GetDuanWeiReward",dw1-1, dw2-1)
	local levelIndex = Player:Lua_GetXbwData( "LevelIndex" )
	for i=1, table.getn(g_HuaShanLunJian_DuanWei_ActionItem) do
		local itemId, itemNum = XBW:GetXbwSeasonAward(dw1, dw2, levelIndex, i-1)
		local theAction = DataPool:CreateBindActionItemForShow(itemId, itemNum)
		if theAction:GetID() ~= 0 then
			g_HuaShanLunJian_DuanWei_ActionItem[i]:Show()
			g_HuaShanLunJian_DuanWei_ActionItem[i]:SetActionItem(theAction:GetID())
			if HaveGetPrize == 1 then
				g_HuaShanLunJian_DuanWei_LingQu[i]:Show()
			else
				g_HuaShanLunJian_DuanWei_LingQu[i]:Hide()
			end				
		end	
	end
	
	if HaveGetPrize == 1 then
		g_HuaShanLunJian_PrizeButton[1]:SetText("#{HSLJ_190919_16}")
		g_HuaShanLunJian_PrizeButton[1]:Disable()
		g_HuaShanLunJian_RedPoint_Button:Hide()
	else
		g_HuaShanLunJian_PrizeButton[1]:SetText("#{HSLJ_190919_15}")
		g_HuaShanLunJian_PrizeButton[1]:Enable()
	end
	
	--选定阶的领奖按钮：可领奖，并且未领奖，才显示
	local  canshow = -1	
	if ((dw1 < nCurDuanWei1) or (dw1==nCurDuanWei1 and dw2>=nCurDuanWei2) )
		and (HaveGetPrize ~= 1) then
		canshow = 1
	end
	if canshow == 1 then
		g_HuaShanLunJian_RedPoint_Button:Show()	
	else
		g_HuaShanLunJian_RedPoint_Button:Hide()	
	end	
end

function HuaShanLunJian_Rank_LineChanged()
	local _name, comIdx = HuaShanLunJian_DanAward_RightList:GetCurrentSelect()
	
	if comIdx >= 0 and comIdx <= 2 then 
		HuaShanLunJian_Rank_AwardButton( comIdx, 1 )
	end
end

function HuaShanLunJian_Rank_ButtonChange( rankIndex )
	local _name, comIdx = HuaShanLunJian_DanAward_RightList:GetCurrentSelect()
	HuaShanLunJian_Rank_AwardButton( comIdx, rankIndex )
end

function HuaShanLunJian_Rank_AwardButton( levelIndex, rankIndex )
	g_HuaShanLunJian_Rank_1 = levelIndex
	g_HuaShanLunJian_Rank_2 = rankIndex
	
	for index=1, table.getn(g_HuaShanLunJian_Rank_Button) do
		if index == rankIndex then
			g_HuaShanLunJian_Rank_Button[index]:SetCheck(1)
		else
			g_HuaShanLunJian_Rank_Button[index]:SetCheck(0)
		end
	end
	
	--奖励
	for i=1, table.getn(g_HuaShanLunJian_Rank_ActionItem) do
		g_HuaShanLunJian_Rank_ActionItem[i]:SetActionItem(-1)
		g_HuaShanLunJian_Rank_ActionItem[i]:Hide()
		g_HuaShanLunJian_Rank_LingQu[i]:Hide()		
	end

	local HaveGetPrize = Player:Lua_GetXbwData("GetRankReward")
	--等级分组：大组
	local truelevelIndex = Player:Lua_GetXbwData( "LevelIndex" )
	--等级分组：小组
	local truerankIndex = g_HuaShanLunJian_MyRank + 1
	local temp = -1
	if truerankIndex >= 1 and truerankIndex <= 3 then
		temp = 1
	elseif truerankIndex >= 4 and truerankIndex <= 9 then
		temp = 2
	elseif truerankIndex >= 10 and truerankIndex <= 30 then
		temp = 3
	elseif truerankIndex >= 31 and truerankIndex <= 60 then
		temp = 4
	end
	
	if (levelIndex == truelevelIndex) and (rankIndex == temp) and (HaveGetPrize == 1) then
		HaveGetPrize = 1
	else
		HaveGetPrize = 0
	end
	
	--{ {id=38002197, num=1}, {id=38002197, num=1} },
	local awardList = g_RankAward[levelIndex][rankIndex]
	for i=1, table.getn(awardList) do
		local theAction = DataPool:CreateBindActionItemForShow(awardList[i].id, awardList[i].num)
		if theAction:GetID() ~= 0 then
			g_HuaShanLunJian_Rank_ActionItem[i]:Show()
			g_HuaShanLunJian_Rank_ActionItem[i]:SetActionItem(theAction:GetID())
			if HaveGetPrize == 1 then
				g_HuaShanLunJian_Rank_LingQu[i]:Show()
			else
				g_HuaShanLunJian_Rank_LingQu[i]:Hide()
			end
		end
	end
	
	HuaShanLunJian_RightText2:SetText( g_RankText[rankIndex] )
	
	if HaveGetPrize == 1 then
		g_HuaShanLunJian_PrizeButton[2]:SetText("#{HSLJ_190919_16}")
		g_HuaShanLunJian_PrizeButton[2]:Disable()
	else
		g_HuaShanLunJian_PrizeButton[2]:SetText("#{HSLJ_190919_15}")
		g_HuaShanLunJian_PrizeButton[2]:Enable()			
	end	
end

function HuaShanLunJian_ResetPos()
  HuaShanLunJian_Frame:SetProperty("UnifiedPosition", g_HuaShanLunJian_Frame_UnifiedPosition);
end

function HuaShanLunJian_GetAward_Clicked(index)
	if index ~= 1 and index ~= 2 then
		return
	end

	if index == 1 then
	
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("GetTruePrize1")
			Set_XSCRIPT_ScriptID(892895)
			Set_XSCRIPT_Parameter( 0, g_HuaShanLunJian_DuanWei_1 )
			Set_XSCRIPT_Parameter( 1, g_HuaShanLunJian_DuanWei_2 )
			Set_XSCRIPT_Parameter( 2, g_HuaShanLunJian_TargetId )
			Set_XSCRIPT_ParamCount(3)
		Send_XSCRIPT()	
	elseif index == 2 then
	
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("GetTruePrize2")
			Set_XSCRIPT_ScriptID(892895)
			Set_XSCRIPT_Parameter( 0, g_HuaShanLunJian_Rank_1 )
			Set_XSCRIPT_Parameter( 1, g_HuaShanLunJian_Rank_2 )
			Set_XSCRIPT_Parameter( 2, g_HuaShanLunJian_TargetId )
			Set_XSCRIPT_ParamCount(3)
		Send_XSCRIPT()	
		
	end
end