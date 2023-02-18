-------排行榜
-------!!!reloadscript =MenPaiWar_TopList
-- QQ1513260550  仅供娱乐交流，请下载浏览后24小时后删除！

local g_MenPaiWar_TopList_Frame_UnifiedXPosition;
local g_MenPaiWar_TopList_Frame_UnifiedYPosition;

local g_MaxPlayer = 4
local g_NeedLevel = 60
local g_TargetId = -1
local g_nType = -1
local g_State = -1
-- 服务端数据传递
local g_MenPaiWar_TopList_Data = {}
local MenPaiWar_TopList_Item = {} 
local MenPaiWar_TopList_NumberImage = {}
local MenPaiWar_TopList_Number = {}
local MenPaiWar_TopList_TeamNull = {}
local MenPaiWar_TopList_Team = {}
local MenPaiWar_TopList_Time = {}
local MenPaiWar_TopList_ItemBKImage = {}
local MenPaiWar_TopList_ItemBK = {}
local MenPaiWar_ListPage = 0
local JSRankingListDataCount = {}
local g_MenPaiName = {
		[0] = "#{XQ_MP_1}",    --少林
		[1] = "#{XQ_MP_2}",    --明教
		[2] = "#{XQ_MP_3}",    --丐帮
		[3] = "#{XQ_MP_4}",    --武当
		[4] = "#{XQ_MP_5}",    --峨眉
		[5] = "#{XQ_MP_6}",    --星宿
		[6] = "#{XQ_MP_7}",    --天龙
		[7] = "#{XQ_MP_8}",    --天山
		[8] = "#{XQ_MP_9}",    --逍遥
		[9] = "",         --无门派
		[10] = "曼陀",         --无门派
}


function MenPaiWar_TopList_PreLoad()
	--
	this:RegisterEvent("UI_COMMAND");
	
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	
	this:RegisterEvent("ADJEST_UI_POS");
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED");
end


function MenPaiWar_TopList_OnLoad()
	--
	g_MenPaiWar_TopList_Frame_UnifiedXPosition	= MenPaiWar_TopList_MainFrame : GetProperty("UnifiedXPosition");
	g_MenPaiWar_TopList_Frame_UnifiedYPosition	= MenPaiWar_TopList_MainFrame : GetProperty("UnifiedYPosition");
	for i = 1,4 do
		MenPaiWar_TopList_Item[i] = _G[string.format("MenPaiWar_TopList_Item%d",i)]
		MenPaiWar_TopList_NumberImage[i] = _G[string.format("MenPaiWar_TopList_NumberImage%d",i)]
		MenPaiWar_TopList_Number[i] = _G[string.format("MenPaiWar_TopList_Number%d",i)]
		MenPaiWar_TopList_TeamNull[i] = _G[string.format("MenPaiWar_TopList_TeamNull%d",i)]
		MenPaiWar_TopList_Team[i] = _G[string.format("MenPaiWar_TopList_Team%d",i)]
		MenPaiWar_TopList_Time[i] = _G[string.format("MenPaiWar_TopList_Time%d",i)]
		MenPaiWar_TopList_ItemBKImage[i] = _G[string.format("MenPaiWar_TopList_ItemBKImage%d",i)]
		MenPaiWar_TopList_ItemBK[i] = _G[string.format("MenPaiWar_TopList_ItemBK%d",i)]
	end
	g_MenPaiWar_TopList_Data[1] = {{name = "",menpai="",level=""},{name = "",menpai="",level=""},{name = "",menpai="",level=""},{name = "",menpai="",level=""},{name = "",menpai="",level=""},{name = "",menpai="",level=""},0}
	g_MenPaiWar_TopList_Data[2] = {{name = "",menpai="",level=""},{name = "",menpai="",level=""},{name = "",menpai="",level=""},{name = "",menpai="",level=""},{name = "",menpai="",level=""},{name = "",menpai="",level=""},0}
	g_MenPaiWar_TopList_Data[3] = {{name = "",menpai="",level=""},{name = "",menpai="",level=""},{name = "",menpai="",level=""},{name = "",menpai="",level=""},{name = "",menpai="",level=""},{name = "",menpai="",level=""},0}
	g_MenPaiWar_TopList_Data[4] = {{name = "",menpai="",level=""},{name = "",menpai="",level=""},{name = "",menpai="",level=""},{name = "",menpai="",level=""},{name = "",menpai="",level=""},{name = "",menpai="",level=""},0}	
end

function MenPaiWar_TopList_OnEvent(event)

	if (event=="UI_COMMAND" and tonumber(arg0) == 20221011) then 
		-- 数据重置
		g_MenPaiWar_TopList_Data[1] = {{name = "",menpai="",level=""},{name = "",menpai="",level=""},{name = "",menpai="",level=""},{name = "",menpai="",level=""},{name = "",menpai="",level=""},{name = "",menpai="",level=""},0}
		g_MenPaiWar_TopList_Data[2] = {{name = "",menpai="",level=""},{name = "",menpai="",level=""},{name = "",menpai="",level=""},{name = "",menpai="",level=""},{name = "",menpai="",level=""},{name = "",menpai="",level=""},0}
		g_MenPaiWar_TopList_Data[3] = {{name = "",menpai="",level=""},{name = "",menpai="",level=""},{name = "",menpai="",level=""},{name = "",menpai="",level=""},{name = "",menpai="",level=""},{name = "",menpai="",level=""},0}
		g_MenPaiWar_TopList_Data[4] = {{name = "",menpai="",level=""},{name = "",menpai="",level=""},{name = "",menpai="",level=""},{name = "",menpai="",level=""},{name = "",menpai="",level=""},{name = "",menpai="",level=""},0}	
		-- 数据分离
		local Ju_Data = Split(Get_XParam_STR(0),"|")
		for i = 1,4 do
			if Ju_Data[i] == nil or Ju_Data[i] == "" then
				break
			end
			local TeamInfo = Split(Ju_Data[i],"/")
			for j = 1,7 do
				if j == 7 then
					g_MenPaiWar_TopList_Data[i][j] = tonumber(TeamInfo[7])
				else
					local Team_Ju = Split(TeamInfo[j],",")
					g_MenPaiWar_TopList_Data[i][j].name = Team_Ju[1]
					g_MenPaiWar_TopList_Data[i][j].menpai = tonumber(Team_Ju[2])
					g_MenPaiWar_TopList_Data[i][j].level = tonumber(Team_Ju[3])
				end
			end
		end
		MenPaiWar_TopList_BeginCareObject(Get_XParam_INT(0))
		JSRankingListDataCount = {Get_XParam_INT(1),Get_XParam_INT(2)}
		MenPaiWar_TopList_Update()	
		this : Show()	
	elseif (event=="UI_COMMAND" and tonumber(arg0) == 20221119) then -- 数据刷新
		-- 数据分离
		local Ju_Data = Split(Get_XParam_STR(0),"|")
		for i = 1,4 do
			if Ju_Data[i] == nil or Ju_Data[i] == "" then
				break
			end
			local TeamInfo = Split(Ju_Data[i],"/")
			for j = 1,7 do
				if j == 7 then
					g_MenPaiWar_TopList_Data[i][j] = tonumber(TeamInfo[7])
				else
					local Team_Ju = Split(TeamInfo[j],",")
					g_MenPaiWar_TopList_Data[i][j].name = Team_Ju[1]
					g_MenPaiWar_TopList_Data[i][j].menpai = Team_Ju[2]
					g_MenPaiWar_TopList_Data[i][j].level = Team_Ju[3]
				end
			end
		end
		JSRankingListDataCount = {Get_XParam_INT(1),Get_XParam_INT(2)}
		MenPaiWar_TopList_RecordInfo()
	elseif (event=="PLAYER_LEAVE_WORLD") then 
		MenPaiWar_TopList_Close()
		
	elseif (event == "ADJEST_UI_POS" ) then	
		MenPaiWar_TopList_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED" ) then
		MenPaiWar_TopList_Frame_On_ResetPos()
		
	end
end


function MenPaiWar_TopList_Update()	
	--框架初始化
	
	MenPaiWar_TopList_RecordInfo()	
	MenPaiWar_TopList_PrizeInfo()
	
end

function MenPaiWar_TopList_PageChange(idx)
	MenPaiWar_ListPage = MenPaiWar_ListPage + idx
	if MenPaiWar_ListPage < 0 then
		MenPaiWar_ListPage = 0
	elseif MenPaiWar_ListPage > 4 then
		MenPaiWar_ListPage = 4
	end
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "OpenMenPaiWar_TopList" ); 	-- 脚本函数名称
		Set_XSCRIPT_ScriptID( 650001 );						-- 脚本编号
		Set_XSCRIPT_Parameter( 0, MenPaiWar_ListPage );					-- 参数一
		Set_XSCRIPT_ParamCount( 1 );						-- 参数个数
	Send_XSCRIPT()
end

function MenPaiWar_TopList_RecordInfo( )	
	for i = 1,4 do
		if g_MenPaiWar_TopList_Data[i][7] == 0 then
			MenPaiWar_TopList_NoRecord( i )
		else
			MenPaiWar_TopList_HaveRecord( i )
		end
	end	
end


function MenPaiWar_TopList_HaveRecord( index )
	-- local nRank, name, usetime, state = DataPool:lua_GetJSRankingListInfo(g_nType, index);
	-- if nRank == nil then
		-- return
	-- end
			
	-- local ItemBar = MenPaiWar_TopList:AddChild( "MenPaiWar_TopList_Item")
	-- if ItemBar == nil then
		-- return 
	-- end

	local teamBKButton = MenPaiWar_TopList_ItemBK[index]
	teamBKButton:Show()
	local teamBKImage = MenPaiWar_TopList_ItemBKImage[index]
	teamBKImage:Show()
	teamBKImage:SetProperty("Image","set:MenPaiWar_TopList image:MenPaiWar_TopListBK1")
		
	--名次
	if index + MenPaiWar_ListPage * 4 <= 3 then
		local numImageButton = MenPaiWar_TopList_NumberImage[index]
		numImageButton:Show()
		if index + MenPaiWar_ListPage * 4 == 1 then
			numImageButton:SetProperty("Image","set:MenPaiWar_TopList image:MenPaiWar_TopListTop1")
		elseif index + MenPaiWar_ListPage * 4 == 2 then
			numImageButton:SetProperty("Image","set:MenPaiWar_TopList image:MenPaiWar_TopListTop2")
		else
			numImageButton:SetProperty("Image","set:MenPaiWar_TopList image:MenPaiWar_TopListTop3")
		end
		local numButton = MenPaiWar_TopList_Number[index]
		numButton:SetText(index + MenPaiWar_ListPage * 4)
	else
		local numImageButton = MenPaiWar_TopList_NumberImage[index]
		numImageButton:Hide()
		local numButton = MenPaiWar_TopList_Number[index]
		numButton:SetText(index + MenPaiWar_ListPage * 4)
	end
		
	--队员
	local noTeamButton = MenPaiWar_TopList_TeamNull[index]
	noTeamButton:Hide()
	
	local teamButton = MenPaiWar_TopList_Team[index]
	teamButton:Show()
	
	local mennum = 0
	for j = 1,6 do
		local bValid, memguid, memname, menpai, level = lua_GetJSRankingListMemberInfo(index, j);
		
		if bValid == 1 then
			MenPaiWar_TopList_HaveMember( index, j, memname, menpai, level )

			mennum = j
		else
			MenPaiWar_TopList_NoMember( index, j )
		end
	end
	local usetime = g_MenPaiWar_TopList_Data[index][7]
	--副本时间
	local timeShow = MenPaiWar_TopList_FormatTime(usetime)
	local timeButton = MenPaiWar_TopList_Time[index]
	timeButton:SetText(timeShow)
end

function lua_GetJSRankingListMemberInfo(index,j)
	local bValid, memguid, memname, menpai, level = 0,0,0,9,0
	if g_MenPaiWar_TopList_Data[index][j].name ~= nil and g_MenPaiWar_TopList_Data[index][j].name ~= "" then
		bValid = 1
		memguid = -1
		memname = g_MenPaiWar_TopList_Data[index][j].name
		menpai = g_MenPaiWar_TopList_Data[index][j].menpai
		level = g_MenPaiWar_TopList_Data[index][j].level
	end
	return bValid, memguid, memname, menpai, level
end


function MenPaiWar_TopList_NoRecord( index )	
	local teamBKImage = MenPaiWar_TopList_ItemBKImage[index]
	teamBKImage:Show()
	teamBKImage:SetProperty("Image","set:MenPaiWar_TopList image:MenPaiWar_TopListBK2")	
	--名次
	if index + MenPaiWar_ListPage * 4 <= 3 then
		local numImageButton = MenPaiWar_TopList_NumberImage[index]
		numImageButton:Show()
		if index == 1 then
			numImageButton:SetProperty("Image","set:MenPaiWar_TopList image:MenPaiWar_TopListTop1")
		elseif index == 2 then
			numImageButton:SetProperty("Image","set:MenPaiWar_TopList image:MenPaiWar_TopListTop2")
		else
			numImageButton:SetProperty("Image","set:MenPaiWar_TopList image:MenPaiWar_TopListTop3")
		end
		local numButton = MenPaiWar_TopList_Number[index]
		numButton:SetText(index)
	else
		local numImageButton = MenPaiWar_TopList_NumberImage[index]
		numImageButton:Hide()
		local numButton = MenPaiWar_TopList_Number[index]
		numButton:SetText(index + MenPaiWar_ListPage * 4)
	end
	
	--队员
	local noTeamButton = MenPaiWar_TopList_TeamNull[index]
	noTeamButton:Show()
	
	local teamButton = MenPaiWar_TopList_Team[index]
	teamButton:Hide()
	
	--副本时间
	local timeButton = MenPaiWar_TopList_Time[index]
	timeButton:SetText("——")
end


function MenPaiWar_TopList_HaveMember( ItemBar, index, memname, menpai, level )
	local memberButton = _G[string.format("MenPaiWar_TopList_TeamMember%d%d",ItemBar,index)]
	memberButton:Show()
	
	local nameButton = _G[string.format("MenPaiWar_TopList_Name%d%d",ItemBar,index)]
	nameButton:SetText(memname)
	
	local menpaiButton = _G[string.format("MenPaiWar_TopList_School%d%d",ItemBar,index)]
	menpaiButton:SetText( g_MenPaiName[menpai] )
	

	local LevelButton = _G[string.format("MenPaiWar_TopList_Level%d%d",ItemBar,index)]
	LevelButton:SetText( level )

	if index ~= 1 then
		local nullteamButton = _G[string.format("MenPaiWar_TopList_TeamNull%d%d",ItemBar,index)]
		nullteamButton:Hide()
	end
end


function MenPaiWar_TopList_NoMember( ItemBar, index )
	local memberButton = _G[string.format("MenPaiWar_TopList_TeamMember%d%d",ItemBar,index)]
	memberButton:Hide()

	if index ~= 1 then
		local nullteamButton = _G[string.format("MenPaiWar_TopList_TeamNull%d%d",ItemBar,index)]
		nullteamButton:Show()
	end
end

--	RankingListData_DB_DataStatus_Free,
--	RankingListData_DB_DataStatus_Ranking,
--	RankingListData_DB_DataStatus_Settle,
function MenPaiWar_TopList_PrizeInfo()
	local state = GetDayWeek()
	-- g_State = state

	local myRank = -1
	local myRankTime = 0

	local nDataCount = JSRankingListDataCount[1]
	if nDataCount <= 0 then
		MenPaiWar_TopList_ReachTime:SetText("#{MPCG_191029_365}")
		MenPaiWar_TopList_ReachTop:SetText("#{MPCG_191029_370}")
		MenPaiWar_TopList_MyNumber:SetText("#{MPCG_191029_340}")
		MenPaiWar_TopList_ReachTime:Show()
		MenPaiWar_TopList_ReachTop:Show()
		MenPaiWar_TopList_Btn:Disable()
		return
	end

	-- for i = 0, nDataCount-1 do
		-- local nRank,name,usetime,state = DataPool:lua_GetJSRankingListInfo(g_nType,i)
		-- for j = 1,6 do
			-- local bValid, memguid, membname,menpai,level,score = DataPool:lua_GetJSRankingListMemberInfo(g_nType,i,j-1);
			-- if bValid == 1 and myRank < 0 then
				-- if memguid == Player:GetGUID() then
					myRank = JSRankingListDataCount[1]
					myRankTime = JSRankingListDataCount[2]
					-- break
				-- end
			-- end
		-- end
		-- if myRank ~= -1 then
			-- break
		-- end
	-- end

	if myRank == -1 then
		MenPaiWar_TopList_ReachTop:SetText("#{MPCG_191029_370}")
		MenPaiWar_TopList_ReachTop:Show()
	else
		MenPaiWar_TopList_ReachTop:SetText(string.format("排名：%s",myRank))
		MenPaiWar_TopList_ReachTop:Show()
	end

	local mytime = JSRankingListDataCount[2]
	if mytime == 0 then
		MenPaiWar_TopList_ReachTime:SetText("#{MPCG_191029_365}")
		MenPaiWar_TopList_ReachTime:Show()
	else
		local mintime = math.floor(mytime/60)
		local sectime = math.mod(mytime,60)
		MenPaiWar_TopList_ReachTime:SetText(string.format("当前完成时间：%s分%s秒",mintime,sectime))
		MenPaiWar_TopList_ReachTime:Show()
	end

	--未结算时显示
	if state ~= 7 then 
		MenPaiWar_TopList_MyNumber:SetText("#{MPCG_191029_340}")
		MenPaiWar_TopList_Btn:Disable()
		return
	end

	local myuset, myrewardflag = DataPool:lua_GetJSRankingListMyInfo(g_nType)

	MenPaiWar_TopList_ReachTime:Hide()
	MenPaiWar_TopList_ReachTop:Hide()
	
	--已结算
	if myRank < 0 then
		MenPaiWar_TopList_MyNumber:SetText("#{MPCG_191029_369}")
		MenPaiWar_TopList_Btn:Disable()
		return
	else
		-- if myrewardflag == 0 then
			local msg = string.format("恭喜您以第%s名的成绩成功登榜，请领取奖励！", myRank+1)
			MenPaiWar_TopList_MyNumber:SetText(msg)
			MenPaiWar_TopList_Btn:Enable()
		-- else
			-- local msg = string.format("恭喜您以第%s名的成绩成功登榜！", myRank+1)
			-- MenPaiWar_TopList_MyNumber:SetText(msg)
			-- MenPaiWar_TopList_Btn:Enable()
		-- end
		
		return
	end
	
end


--领奖
function MenPaiWar_TopList_Prize_Click( )
	
	local myLevel = Player:GetData("LEVEL")
	if myLevel < g_NeedLevel then
		PushDebugMessage("#{MPCG_191029_349}")
		return
	end	
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "OpenMenPaiWar_TopList" ); 	-- 脚本函数名称
		Set_XSCRIPT_ScriptID( 650001 );						-- 脚本编号
		Set_XSCRIPT_Parameter( 0, -999 );					-- 参数一
		Set_XSCRIPT_ParamCount( 1 );						-- 参数个数
	Send_XSCRIPT()	
end


function MenPaiWar_TopList_Preview_Click()
	PushEvent("UI_COMMAND",120221012, g_TargetId)
end


function MenPaiWar_TopList_Frame_On_ResetPos()

	MenPaiWar_TopList_MainFrame : SetProperty("UnifiedXPosition", g_MenPaiWar_TopList_Frame_UnifiedXPosition);
	MenPaiWar_TopList_MainFrame : SetProperty("UnifiedYPosition", g_MenPaiWar_TopList_Frame_UnifiedYPosition);

end


function MenPaiWar_TopList_Help_Click()
	PushEvent("UI_COMMAND",20211201, 5)
end


function MenPaiWar_TopList_Close()
	this:Hide()
end

--=========================================================
--开始关心NPC
--=========================================================
function MenPaiWar_TopList_BeginCareObject(objCaredId)
	
	g_TargetId = objCaredId
	if g_TargetId <= -1 then
		MenPaiWar_TopList_Close()
		return
	end

	local objId = DataPool : GetNPCIDByServerID(g_TargetId)
	if objId <= -1 then
		return
	end
		
	this : CareObject( objId, 1, "MenPaiWar_TopList" )
end

function MenPaiWar_TopList_FormatTime(nSec)
	local min = math.floor(nSec/60)
	local sec = math.mod(nSec,60)
	
	if min < 10 then
		return string.format("%02d:%02d",min,sec)
	else
		return string.format("%d:%02d",min,sec)
	end
	
end

