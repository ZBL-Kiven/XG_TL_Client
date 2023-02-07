--由于时间关系，先不做那么精细
local g_SongliaoWarOver_Frame_UnifiedXPosition;
local g_SongliaoWarOver_Frame_UnifiedYPosition;
local g_SongliaoWarOver_Image = {
						[1] = "set:SongLiao02 image:HJ_Shengli",   --sheng
						[2] = "set:SongLiao02 image:HJ_Baibei", 	--Bai
						[3] = "set:SongLiao02 image:HJ_Pingju",     --ping
						[4] = "set:SongLiao02 image:HJ_Zhengduo" --weiwancheng
	}

local g_select = 0 --1:宋 0：辽
local g_Songliao_ItemBars 				= {}
local g_SongIsWinner = 0  --0:平局 1：宋胜 2：辽胜
local g_Final = 0
local myRet, myName, myCamp, myScore, mykillNum, myGUID,mySuccKill
local SongliaoWarOver_Battle_FourTimeEnd = 11470--SongLiaoWarSingle.lua 里面有一样的宏

--道具信息填充框架
local g_SongLiaoWarOverItem = {
--宋
[156] = {
--前两个是排名奖励，后两个是胜利奖励（时间原因只写前5）
{49000282,200},{10141069,1},{49000282,100},{38002228,2},
{49000282,180},{-1,2},{49000282,100},{38002228,2},
{49000282,160},{-1,5},{49000282,100},{38002228,2},
{49000282,140},{-1,5},{49000282,100},{38002228,2},
{49000282,140},{-1,5},{49000282,100},{38002228,2},
},
--辽
[157] = {
{49000282,200},{10141070,1},{49000282,100},{38002228,2},
{49000282,180},{-1,5},{49000282,100},{38002228,2},
{49000282,160},{-1,5},{49000282,100},{38002228,2},
{49000282,140},{-1,5},{49000282,100},{38002228,2},
{49000282,140},{-1,5},{49000282,100},{38002228,2},
}
}

--框架设定
local SongLiaoWarOver_List = {}
function SongliaoWarOver_PreLoad()
	this:RegisterEvent("SCENE_TRANSED");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	this:RegisterEvent("UI_COMMAND");	
	this:RegisterEvent("ADJEST_UI_POS");
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED");		
	this:RegisterEvent("SHOW_SONGLIAOWAR_SCORE_M");		
	this:RegisterEvent("REFRESH_SONGLIAOWAR_MULTI_SCORE");		
end

function SongliaoWarOver_OnLoad()
	-- 保存界面的默认相对位置
	g_SongliaoWarOver_Frame_UnifiedXPosition	= SongliaoWarOver : GetProperty("UnifiedXPosition");
	g_SongliaoWarOver_Frame_UnifiedYPosition	= SongliaoWarOver : GetProperty("UnifiedYPosition");
	
	for i = 1,5 do
		SongLiaoWarOver_List[i] = {
		_G[string.format("SongliaoWarOver_List_%d",i)],
		_G[string.format("SongliaoWarOver_List_%d_RankImage",i)],
		_G[string.format("SongliaoWarOver_List_%d_Name",i)],
		_G[string.format("SongliaoWarOver_List_%d_Kill",i)],
		_G[string.format("SongliaoWarOver_List_%d_Flag",i)],
		_G[string.format("SongliaoWarOver_List_%d_Integral",i)],
		_G[string.format("SongliaoWarOver_List_%d_Button1",i)],
		_G[string.format("SongliaoWarOver_List_%d_Button2",i)],
		_G[string.format("SongliaoWarOver_List_%d_Button3",i)],
		_G[string.format("SongliaoWarOver_List_%d_Button4",i)],
		}
	end
	
end

function SongliaoWarOver_OnEvent(event)
	if (event=="SCENE_TRANSED") then
		if(548~=GetSceneID()) then
			this:Hide()
			return
		end
	elseif (event=="PLAYER_LEAVE_WORLD") then
		if( this:IsVisible() ) then
			this:Hide()
		end
	elseif (event == "UI_COMMAND") then 
		if tonumber(arg0) == 502011  then
			myRet = 1
			myName = Player:GetName()
			myCamp = Get_XParam_INT(1)
			myScore = DataPool:GetPlayerMission_DataRound(361)
			mykillNum = DataPool:GetPlayerMission_DataRound(363)
			mySuccKill = DataPool:GetPlayerMission_DataRound(367)
			this:Show()
			SongliaoWarOver_Open(Get_XParam_INT(7))
		end

	-- 游戏窗口尺寸发生了变化
	elseif (event == "ADJEST_UI_POS" ) then
		SongliaoWarOver_Frame_On_ResetPos();
	-- 游戏分辨率发生了变化		
	elseif (event == "VIEW_RESOLUTION_CHANGED" ) then
		SongliaoWarOver_Frame_On_ResetPos();
	elseif (event == "SHOW_SONGLIAOWAR_SCORE_M" ) then
		this:Show()
		SongliaoWarOver_Open(0)
	elseif (event=="REFRESH_SONGLIAOWAR_MULTI_SCORE" and this:IsVisible()) then
		SongliaoWarOver_Open(0)
	end
end

function SongliaoWarOver_Open(final)
	g_SongIsWinner = 0
	local nTick = Get_XParam_INT(0)
	if nTick >= SongliaoWarOver_Battle_FourTimeEnd then
		final = 1
	end
	
	g_Final = final
	if g_Final == 1 then
		SongliaoWarOver_Sure:Enable()
	else
		SongliaoWarOver_Sure:Disable()
	end
	-- local myRet, myName, myCamp, myScore= CSongliaoWarData:GetMyScore()

	if myCamp == 156 then
		g_select = 1
		-- SongliaoWarOver_Song_Check:SetProperty("Selected", "True"); 
		-- SongliaoWarOver_Liao_Check:SetProperty("Selected", "False");   
		SongliaoWarOver_SongCamp:SetText("本方")
		SongliaoWarOver_LiaoCamp:SetText("敌方")
	else
		g_select = 0
		-- SongliaoWarOver_Song_Check:SetProperty("Selected", "False"); 
		-- SongliaoWarOver_Liao_Check:SetProperty("Selected", "True");   
		SongliaoWarOver_SongCamp:SetText("敌方")
		SongliaoWarOver_LiaoCamp:SetText("本方")
	end

	--Lua_TDU_Log("myRet="..myRet.." myName="..myName.." myCamp="..myCamp.." myScore="..myScore.." mykillNum="..mykillNum)
	
	--local nState = CSongliaoWarData:GetState()
	
	local winSong = {0,0,0,0}
	local winLiao = {0,0,0,0}

	for nState=1,4 do
		-- local nCampScore = CSongliaoWarData:GetCampStateScore(nState);
		--Lua_TDU_Log("songliao".."nState="..nState.." nCampScore"..nCampScore)
		if nState == 1 then --第一阶段
			
			local nStateWinner=  Get_XParam_INT(2)
			--Lua_TDU_Log("nState"..nState.." nStateWinner="..nStateWinner)
			if nStateWinner == 1 then --宋	
				SongliaoWarOver_QL:SetProperty("Visible" , "True" )
				SongliaoWarOver_QL2:SetProperty("Visible" , "False" )
				winSong[1] = 1
			elseif nStateWinner == 2 then --辽
				SongliaoWarOver_QL:SetProperty("Visible" , "False" )
				SongliaoWarOver_QL2:SetProperty("Visible" , "True" )
				winLiao[1] = 1
			else --平
				SongliaoWarOver_QL:SetProperty("Visible" , "False" )
				SongliaoWarOver_QL2:SetProperty("Visible" , "False" )	
			end
			
		elseif nState == 2 then --第二阶段

			local nStateWinner=  Get_XParam_INT(3)
			if nStateWinner == 1 then --宋	
				SongliaoWarOver_BH:SetProperty("Visible" , "True" )
				SongliaoWarOver_BH2:SetProperty("Visible" , "False" )
				winSong[2] = 1
			elseif nStateWinner == 2 then --辽
				SongliaoWarOver_BH:SetProperty("Visible" , "False" )
				SongliaoWarOver_BH2:SetProperty("Visible" , "True" )
				winLiao[2] = 1
			else --平
				SongliaoWarOver_BH:SetProperty("Visible" , "False" )
				SongliaoWarOver_BH2:SetProperty("Visible" , "False" )	
			end

		elseif nState == 3 then --第三阶段

			local nStateWinner=  Get_XParam_INT(4)

			if nStateWinner == 1 then --宋	
				SongliaoWarOver_XW:SetProperty("Visible" , "True" )
				SongliaoWarOver_XW2:SetProperty("Visible" , "False" )
				winSong[3] = 1
			elseif nStateWinner == 2 then --辽
				SongliaoWarOver_XW:SetProperty("Visible" , "False" )
				SongliaoWarOver_XW2:SetProperty("Visible" , "True" )
				winLiao[3] = 1
			else --平
				SongliaoWarOver_XW:SetProperty("Visible" , "False" )
				SongliaoWarOver_XW2:SetProperty("Visible" , "False" )	
			end

		elseif nState == 4 then --第四阶段

			local nStateWinner=  Get_XParam_INT(5)
			if nStateWinner == 1 then --宋	
				SongliaoWarOver_ZQ:SetProperty("Visible" , "True" )
				SongliaoWarOver_ZQ2:SetProperty("Visible" , "False" )
				winSong[4] = 1
			elseif nStateWinner == 2 then --辽
				SongliaoWarOver_ZQ:SetProperty("Visible" , "False" )
				SongliaoWarOver_ZQ2:SetProperty("Visible" , "True" )
				winLiao[4] = 1
			else --平
				SongliaoWarOver_ZQ:SetProperty("Visible" , "False" )
				SongliaoWarOver_ZQ2:SetProperty("Visible" , "False" )				
			end
		end
	end

	local songcnt =0 
	local liaocnt =0
	for i=1,4 do
		songcnt = songcnt + winSong[i]
		liaocnt = liaocnt + winLiao[i]
	end

	if g_Final == 1 then
		if songcnt > liaocnt then
			if myCamp ==  156 then --我是宋
				SongliaoWarOver_Sheng:SetProperty("Image", g_SongliaoWarOver_Image[1])
			else
				SongliaoWarOver_Sheng:SetProperty("Image", g_SongliaoWarOver_Image[2])
			end
			g_SongIsWinner = 1
		elseif songcnt < liaocnt then
			if myCamp ==  156 then --我是宋
				SongliaoWarOver_Sheng:SetProperty("Image", g_SongliaoWarOver_Image[2])
			else
				SongliaoWarOver_Sheng:SetProperty("Image", g_SongliaoWarOver_Image[1])
			end
			g_SongIsWinner = 2
		elseif songcnt == liaocnt then
			SongliaoWarOver_Sheng:SetProperty("Image", g_SongliaoWarOver_Image[3])
			g_SongIsWinner = 0
		end
	else
		SongliaoWarOver_Sheng:SetProperty("Image", g_SongliaoWarOver_Image[4])
	end

	SongliaoWarOver_Frame_Draw(g_Final)
	
end

function SongliaoWarOver_Close()

	--SongliaoWarOver_CleanActionItemInfo()
	--SongliaoWarOver_List:CleanAllElement("SongliaoWarOver") 
	this:Hide()
	
	--SongliaoWarOver_Time:SetProperty("Timer", "-1");
end
function SongliaoWarOver_Sure_Clicked()

	SongliaoWarOver_Close()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "Transfer" )
		Set_XSCRIPT_ScriptID(502021) --别忘了：AllowableScriptFunc.txt中加上这个接口和脚本号
		Set_XSCRIPT_ParamCount(0)
	Send_XSCRIPT()		
	--SongliaoWarOver_Time:SetProperty("Timer", "-1");
end


function SongliaoWarOver_CleanActionItemInfo()
	local nListCount = table.getn(g_Songliao_ItemBars)
	if nListCount <= 0 then
		g_Songliao_ItemBars = {}
		return
	end
	for i = 1, nListCount do
		if nil ~= g_Songliao_ItemBars[i] then
			local itemButton = g_Songliao_ItemBars[i]:GetLuaActionButton(1,"SongliaoWarOver")
			if nil ~= itemButton then
				itemButton:SetActionItem(-1)
			end
		end
	end
	g_Songliao_ItemBars = {}
end

--更新主界面位置
function SongliaoWarOver_Frame_On_ResetPos()

	SongliaoWarOver : SetProperty("UnifiedXPosition", g_SongliaoWarOver_Frame_UnifiedXPosition);
	SongliaoWarOver : SetProperty("UnifiedYPosition", g_SongliaoWarOver_Frame_UnifiedYPosition);

end

function SongliaoWarOver_Frame_Song_Check()

	if g_select == 0 then 
		-- SongliaoWarOver_Song_Check:SetProperty("Selected", "True");  
		-- SongliaoWarOver_Liao_Check:SetProperty("Selected", "False");  
		g_select = 1
		-- SongliaoWarOver_Frame_Draw(g_Final)
	end
end

function SongliaoWarOver_Frame_Liao_Check()

	if g_select == 1 then
		-- SongliaoWarOver_Song_Check:SetProperty("Selected", "False"); 
		-- SongliaoWarOver_Liao_Check:SetProperty("Selected", "True");   
		g_select = 0
		-- SongliaoWarOver_Frame_Draw(g_Final)
	end
end

function SongliaoWarOver_Hidden()

	PushEvent('SONGLIAOSINGLE_MINI', 1)
    this:Hide()
	
end



function SongliaoWarOver_Frame_Draw(g_Final)
	local nWarOverList = Get_XParam_STR(0)
	if nWarOverList == nil or nWarOverList == "" then
		return
	end
	nWarOverList = Split(nWarOverList, "\r")
	SongliaoWarOver_NoEnd:Hide()
	
	local theAction
	local nCount = 0
	local myCount = 0
	for i = 1,5 do
		if nWarOverList[i] ~= nil and nWarOverList[i] ~= "" then
			SongLiaoWarOver_List[i][1]:Show()
			local nWarOver = Split(nWarOverList[i], ",")
			if nWarOver[i] ~= "" and nWarOver[i] ~= nil then
				SongLiaoWarOver_List[i][3]:SetText(nWarOver[1])
				SongLiaoWarOver_List[i][4]:SetText(nWarOver[2])
				SongLiaoWarOver_List[i][5]:SetText(nWarOver[3])
				SongLiaoWarOver_List[i][6]:SetText(nWarOver[4])
				if i == 1 then
					SongLiaoWarOver_List[i][2]:SetProperty("Image", "set:SongLiao02 image:Win_1");
				elseif i == 2 then
					SongLiaoWarOver_List[i][2]:SetProperty("Image", "set:SongLiao02 image:Win_2");
				elseif i == 3 then
					SongLiaoWarOver_List[i][2]:SetProperty("Image", "set:SongLiao02 image:Win_3");
				else
					SongLiaoWarOver_List[i][2]:SetText(i)
				end
				--道具信息填充
				if g_SongLiaoWarOverItem[myCamp] ~= nil then
					for j = 1,4 do
						theAction = GemCarve:UpdateProductAction(g_SongLiaoWarOverItem[myCamp][j + nCount * 4][1])
						if theAction:GetID() ~= 0 then
							SongLiaoWarOver_List[i][j+6]:SetActionItem(theAction:GetID());
							SongLiaoWarOver_List[i][j+6]:SetProperty("CornerChar", string.format( "BotRight %s", g_SongLiaoWarOverItem[myCamp][j + nCount * 4][2] ));
							SongLiaoWarOver_List[i][j+6]:Show()
						else
							SongLiaoWarOver_List[i][j+6]:Hide()
						end
					end
					nCount = nCount + 1
				end
			end
		else
			SongLiaoWarOver_List[i][1]:Hide()
		end
	end
	--自己的判断
	local nSelWar = Get_XParam_INT(6)
	if nSelWar <= 3 and nSelWar > 0 then
		local ntheActionXmls = {SongliaoWarOver_SelfButton3,SongliaoWarOver_SelfButton4,SongliaoWarOver_SelfButton5,SongliaoWarOver_SelfButton6}
		if nSelWar == 1 then
			SongliaoWarOver_SelfRankImage:SetProperty("Image", "set:SongLiao02 image:Win_1");
			--奖励装配
			for j = 1,4 do
				theAction = GemCarve:UpdateProductAction(g_SongLiaoWarOverItem[myCamp][j][1])
				if theAction:GetID() ~= 0 then
					ntheActionXmls[j]:SetActionItem(theAction:GetID());
					ntheActionXmls[j]:SetProperty("CornerChar", string.format( "BotRight %s", g_SongLiaoWarOverItem[myCamp][j][2] ));
					ntheActionXmls[j]:Show()
				else
					ntheActionXmls[j]:Hide()
				end
			end
		elseif nSelWar == 2 then
			SongliaoWarOver_SelfRankImage:SetProperty("Image", "set:SongLiao02 image:Win_2");
			--奖励装配
			for j = 1,4 do
				theAction = GemCarve:UpdateProductAction(g_SongLiaoWarOverItem[myCamp][j+4][1])
				if theAction:GetID() ~= 0 then
					ntheActionXmls[j]:SetActionItem(theAction:GetID());
					ntheActionXmls[j]:SetProperty("CornerChar", string.format( "BotRight %s", g_SongLiaoWarOverItem[myCamp][j+4][2] ));
					ntheActionXmls[j]:Show()
				else
					ntheActionXmls[j]:Hide()				
				end
			end			
		elseif nSelWar == 3 then
			SongliaoWarOver_SelfRankImage:SetProperty("Image", "set:SongLiao02 image:Win_3");
			--奖励装配
			for j = 1,4 do
				theAction = GemCarve:UpdateProductAction(g_SongLiaoWarOverItem[myCamp][j+8][1])
				if theAction:GetID() ~= 0 then
					ntheActionXmls[j]:SetActionItem(theAction:GetID());
					ntheActionXmls[j]:SetProperty("CornerChar", string.format( "BotRight %s", g_SongLiaoWarOverItem[myCamp][j+8][2] ));
					ntheActionXmls[j]:Show()
				else
					ntheActionXmls[j]:Hide()				
				end
			end			
		end
		SongliaoWarOver_SelfRankImage:Show()
		SongliaoWarOver_SelfButton3:Show()
		SongliaoWarOver_SelfButton4:Show()
		SongliaoWarOver_SelfButton5:Show()
		SongliaoWarOver_SelfButton6:Show()
		SongliaoWarOver_SelfRank:Hide()
		SongliaoWarOver_SelfName:SetText(Player:GetName())
		SongliaoWarOver_SelfKill:SetText(DataPool:GetPlayerMission_DataRound(363))
		SongliaoWarOver_SelfFlag:SetText(DataPool:GetPlayerMission_DataRound(367))
		SongliaoWarOver_SelfPoints:SetText(DataPool:GetPlayerMission_DataRound(361))
	else
		if nSelWar == 0 then
			SongliaoWarOver_SelfRank:SetText("无排名")
		else
			SongliaoWarOver_SelfRank:SetText(nSelWar)
		end
		
		SongliaoWarOver_SelfName:SetText(Player:GetName())
		SongliaoWarOver_SelfKill:SetText(DataPool:GetPlayerMission_DataRound(363))
		SongliaoWarOver_SelfFlag:SetText(DataPool:GetPlayerMission_DataRound(367))
		SongliaoWarOver_SelfPoints:SetText(DataPool:GetPlayerMission_DataRound(361))		
		SongliaoWarOver_SelfRankImage:Hide()
		SongliaoWarOver_SelfButton3:Hide()
		SongliaoWarOver_SelfButton4:Hide()
		SongliaoWarOver_SelfButton5:Hide()
		SongliaoWarOver_SelfButton6:Hide()
	end
end
