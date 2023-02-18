--Q546528533 仅供娱乐交流，切勿它用，请浏览后24小时内删除
local g_Talent_Frame_UnifiedPosition = nil 

local g_Talent_UI = {}
local g_Talent_Item = {}
local g_Talent_Line = {}
local g_Talent_LearnedList = {}
local g_Talent_poslist = {}
local g_Talent_StudyTree = {}
local g_Talent_curToplayer = -1
local g_Talent_curFenye = 1
local g_Talent_subSchema = nil
local g_Talent_Schema = nil

g_Talent_Sect = {}
local g_GetSectType = 0
local g_LastScetType = 0
local g_Talent_Info =
{
	[0] =
	{
		[1] = {instrct = "#{TalentSL_20210804_02}",icon="set:Talent image:Talent_SLLH",
				 [1] = {23}, [2] = {24,-1,25},[3] = {26,27,28},[4] = {29,30,-1}, [5] = {31,32,33}},
		[2] = {instrct = "#{TalentSL_20210804_04}",icon="set:Talent image:Talent_SLJG", 
					[1] = {34},[2] = {35,-1,36}, [3] = {37,38,39}, [4] = {40,-1,41},[5] = {42,43,44}},
		[3] = {instrct = "#{TalentSL_20210804_02}",icon="set:Talent image:Talent_SLLH",
				 [1] = {23}, [2] = {199,-1,200},[3] = {201,202,203},[4] = {204,-1,205}, [5] = {206,207,208}},
		[4] = {instrct = "#{TalentSL_20210804_04}",icon="set:Talent image:Talent_SLJG", 
					[1] = {34},[2] = {209,-1,210}, [3] = {211,212,213}, [4] = {214,-1,215},[5] = {216,217,218}}
	},
	[1] =
	{
		[1] = {instrct = "#{TalentMJ_20210804_02}",icon="set:Talent image:Talent_MJTL", 
				[1] = {45}, [2] = {46,-1,47},[3] = {48,49,50},[4] = {51,-1,52}, [5] = {53,54,55}},
		[2] = {instrct = "#{TalentMJ_20210804_04}",icon="set:Talent image:Talent_MJXL", 
				[1] = {56},[2] = {57,-1,58}, [3] = {59,60,61}, [4] = {62,-1,63},[5] = {64,65,66}},
		[3] = {instrct = "#{TalentMJ_20210804_02}",icon="set:Talent image:Talent_MJTL", 
				[1] = {45}, [2] = {219,-1,220},[3] = {221,222,223},[4] = {224,-1,225}, [5] = {226,227,228}},
		[4] = {instrct = "#{TalentMJ_20210804_04}",icon="set:Talent image:Talent_MJXL", 
				[1] = {56},[2] = {229,-1,230}, [3] = {231,232,233}, [4] = {234,-1,235},[5] = {236,237,238}}
	},	

	[2] =
	{
		[1] = {instrct = "#{TalentGB_20210804_02}",icon="set:Talent image:Talent_GBJK", 
				 [1] = {1}, [2] = {2,-1,3},[3] = {4,5,6},[4] = {7,8,-1}, [5] = {9,10,11}},
		[2] = {instrct = "#{TalentGB_20210804_04}",icon="set:Talent image:Talent_GBXX", 
				[1] = {12},[2] = {13,-1,14}, [3] = {15,16,17}, [4] = {18,-1,19},[5] = {20,21,22}},
		[3] = {instrct = "#{TalentGB_20210804_02}",icon="set:Talent image:Talent_GBJK", 
				 [1] = {1}, [2] = {239,-1,240},[3] = {241,242,243},[4] = {244,-1,245}, [5] = {246,247,248}},
		[4] = {instrct = "#{TalentGB_20210804_04}",icon="set:Talent image:Talent_GBXX", 
				[1] = {12},[2] = {249,-1,250}, [3] = {251,252,253}, [4] = {254,-1,255},[5] = {256,257,258}}
	},
	[3] =
	{
		[1] = {instrct = "#{TalentWD_20210804_02}",icon="set:Talent2 image:Talent_WDPX", 
				[1] = {67}, [2] = {68,-1,69},[3] = {70,71,72},[4] = {73,-1,74}, [5] = {75,76,77}},
		[2] = {instrct = "#{TalentWD_20210804_04}",icon="set:Talent2 image:Talent_WDZX", 
				[1] = {78},[2] = {79,-1,80}, [3] = {81,82,83}, [4] = {84,-1,85},[5] = {86,87,88}},
		[3] = {instrct = "#{TalentWD_20210804_02}",icon="set:Talent2 image:Talent_WDPX", 
				[1] = {67}, [2] = {259,-1,260},[3] = {261,262,263},[4] = {264,-1,265}, [5] = {266,267,268}},
		[4] = {instrct = "#{TalentWD_20210804_04}",icon="set:Talent2 image:Talent_WDZX", 
				[1] = {78},[2] = {269,-1,270}, [3] = {271,272,273}, [4] = {274,-1,275},[5] = {276,277,278}}
	},
	[4] =
	{
		[1] = {instrct = "#{TalentEM_20210804_02}",icon="set:Talent image:Talent_EMQF", 
					[1] = {89}, [2] = {90,-1,91},[3] = {92,93,94},[4] = {95,96,-1}, [5] = {97,98,99}},
		[2] = {instrct = "#{TalentEM_20210804_04}",icon="set:Talent image:Talent_EMQY", 
					[1] = {100},[2] = {101,-1,102}, [3] = {103,104,105}, [4] = {106,-1,107},[5] = {108,109,110}},
		[3] = {instrct = "#{TalentEM_20210804_02}",icon="set:Talent image:Talent_EMQF", 
					[1] = {89}, [2] = {279,-1,280},[3] = {281,282,283},[4] = {284,-1,285}, [5] = {286,287,288}},
		[4] = {instrct = "#{TalentEM_20210804_04}",icon="set:Talent image:Talent_EMQY", 
					[1] = {100},[2] = {289,-1,290}, [3] = {291,292,293}, [4] = {294,-1,295},[5] = {296,297,298}}
	},
	[5] =
	{
		[1] = {instrct = "#{TalentXX_20210804_02}",icon="set:Talent2 image:Talent_XXHM", 
					[1] = {111}, [2] = {112,-1,113},[3] = {114,115,116},[4] = {117,-1,118}, [5] = {119,120,121}},
		[2] = {instrct = "#{TalentXX_20210804_04}",icon="set:Talent2 image:Talent_XXJE", 
					[1] = {122},[2] = {123,-1,124}, [3] = {125,126,127}, [4] = {128,-1,129},[5] = {130,131,132}},
		[3] = {instrct = "#{TalentXX_20210804_02}",icon="set:Talent2 image:Talent_XXHM", 
					[1] = {111}, [2] = {299,-1,300},[3] = {301,302,303},[4] = {304,-1,305}, [5] = {306,307,308}},
		[4] = {instrct = "#{TalentXX_20210804_04}",icon="set:Talent2 image:Talent_XXJE", 
					[1] = {122},[2] = {309,-1,310}, [3] = {311,312,313}, [4] = {314,-1,315},[5] = {316,317,318}}
	},
	[6] =
	{
		[1] = {instrct = "#{TalentTL_20210804_02}",icon="set:Talent image:Talent_TLLW", 
					[1] = {133}, [2] = {134,-1,135},[3] = {136,137,138},[4] = {139,-1,140}, [5] = {141,142,143}},
		[2] = {instrct = "#{TalentTL_20210804_04}",icon="set:Talent image:Talent_TLPT", 
					[1] = {144},[2] = {145,-1,146}, [3] = {147,148,149}, [4] = {150,-1,151},[5] = {152,153,154}},
		[3] = {instrct = "#{TalentTL_20210804_02}",icon="set:Talent image:Talent_TLLW", 
					[1] = {133}, [2] = {319,-1,320},[3] = {321,322,323},[4] = {324,-1,325}, [5] = {326,327,328}},
		[4] = {instrct = "#{TalentTL_20210804_04}",icon="set:Talent image:Talent_TLPT", 
					[1] = {144},[2] = {329,-1,330}, [3] = {331,332,333}, [4] = {334,-1,335},[5] = {336,337,338}}
	},
	[7] =
	{
		[1] = {instrct = "#{TalentTS_20210804_02}",icon="set:Talent2 image:Talent_TSNS", 
					 [1] = {155}, [2] = {156,-1,157},[3] = {158,159,160},[4] = {161,-1,162}, [5] = {163,164,165}},
		[2] = {instrct = "#{TalentTS_20210804_04}",icon="set:Talent2 image:Talent_TSXY", 
						[1] = {166},[2] = {167,-1,168}, [3] = {169,170,171}, [4] = {172,-1,173},[5] = {174,175,176}},
		[3] = {instrct = "#{TalentTS_20210804_02}",icon="set:Talent2 image:Talent_TSNS", 
					 [1] = {155}, [2] = {339,-1,340},[3] = {341,342,343},[4] = {344,-1,345}, [5] = {346,347,348}},
		[4] = {instrct = "#{TalentTS_20210804_04}",icon="set:Talent2 image:Talent_TSXY", 
						[1] = {166},[2] = {349,-1,350}, [3] = {351,352,353}, [4] = {354,-1,355},[5] = {356,357,358}}
	},
	[8] =
	{
		[1] = {instrct = "#{TalentXY_20210804_02}",icon="set:Talent2 image:Talent_XYYX", 
					[1] = {177}, [2] = {178,-1,179},[3] = {180,181,182},[4] = {183,-1,184}, [5] = {185,186,187}},
		[2] = {instrct = "#{TalentXY_20210804_04}",icon="set:Talent2 image:Talent_XYMG", 
					[1] = {188},[2] = {189,-1,190}, [3] = {191,192,193}, [4] = {194,-1,195},[5] = {196,197,198}},
		[3] = {instrct = "#{TalentXY_20210804_02}",icon="set:Talent2 image:Talent_XYYX", 
					[1] = {177}, [2] = {359,-1,360},[3] = {361,362,363},[4] = {364,-1,365}, [5] = {366,367,368}},
		[4] = {instrct = "#{TalentXY_20210804_04}",icon="set:Talent2 image:Talent_XYMG", 
					[1] = {188},[2] = {369,-1,370}, [3] = {371,372,373}, [4] = {374,-1,375},[5] = {376,377,378}}
	},
	
	[10] =
	{
		[1] = {instrct = "#{TalentMT_20220621_04}",icon="set:Talent2 image:Talent_MTWL", 
					[1] = {379}, [2] = {380,-1,381},[3] = {382,383,384},[4] = {385,-1,386}, [5] = {387,388,389}},
		[2] = {instrct = "#{TalentMT_20220621_05}",icon="set:Talent2 image:Talent_MTZM", 
					[1] = {390},[2] = {391,-1,392}, [3] = {393,394,395}, [4] = {396,-1,397},[5] = {398,399,400}},
		[3] = {instrct = "#{TalentMT_20220621_04}",icon="set:Talent2 image:Talent_MTWL", 
					[1] = {379}, [2] = {401,-1,402},[3] = {403,404,405},[4] = {406,-1,407}, [5] = {408,409,410}},
		[4] = {instrct = "#{TalentMT_20220621_05}",icon="set:Talent2 image:Talent_MTZM", 
					[1] = {390},[2] = {411,-1,412}, [3] = {413,414,415}, [4] = {416,-1,417},[5] = {418,419,420}}
	},

}

function Talent_PreLoad()

	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("SECT_OPPOSITE",false)
	this:RegisterEvent("FLUSH_SECT_PT",false)
end 

function Lua_HasSect(ID,int)
    if ID <= 0 then
        return 0,0
    end
	local menpai = Player:GetData("MEMPAI")
	if menpai ~= 10 then
		if ID < 199 then
			for i = 1,ID do
				if ID <= 11 then
					break
				end
				ID = ID -11		
			end
		else
			ID = ID - 198
			for i = 1,ID do
				if ID <= 10 then
					break
				end
				ID = ID -10		
			end
			ID = ID + 11
		end
	else
		if ID < 401 then
			ID = ID - 378
			for i = 1,ID do
				if ID <= 11 then
					break
				end
				ID = ID - 11
			end
		else
			ID = ID - 400
			for i = 1,ID do
				if ID <= 10 then
					break
				end
				ID = ID - 10
			end
			ID = ID + 11
		end
	end
	--一重
	local nFinalData_1 = DataPool:GetPlayerMission_DataRound(482)
	local nFinalData_2 = DataPool:GetPlayerMission_DataRound(483)
	--二重
	local nFinalData_3 = DataPool:GetPlayerMission_DataRound(242)
	local nFinalData_4 = DataPool:GetPlayerMission_DataRound(243)
	local nTalentData = {}
	local nValue = {1,10,100,1000,10000,100000}
	for i = 1,6 do
		table.insert(nTalentData,math.mod(math.floor(nFinalData_1/nValue[i]),10))
	end
	for i = 1,5 do
		table.insert(nTalentData,math.mod(math.floor(nFinalData_2/nValue[i]),10))
	end	
	for i = 1,6 do
		table.insert(nTalentData,math.mod(math.floor(nFinalData_3/nValue[i]),10))
	end
	for i = 1,5 do
		table.insert(nTalentData,math.mod(math.floor(nFinalData_4/nValue[i]),10))
	end	
	nTalentData[1] = 1
	if nTalentData[ID] >= 1 then
		return 1,nTalentData[ID]
	end
	return 0,0
end

-- Talent_Checkbox_Frame => DefaultWindow
-- Talent_DragTitle => TLBB_DragTitle
-- Talent_Help => TLBB_ButtonHelp
-- Talent_Frame_Client => DefaultWindow
-- Talent_Close => TLBB_ButtonClose
function Talent_OnLoad()
	g_Talent_Frame_UnifiedPosition = Talent_Frame:GetProperty("UnifiedPosition");

	for i =1, 12 do

		local icon = _G["Talent_Skill"..i.."Icon"]
		local name = _G["Talent_Skill"..i.."Name"]
		local level = _G["Talent_Skill"..i.."Level"]
		local iconmask = _G["Talent_Skill"..i.."IconMask"]
		local all =  _G["Talent_Skill"..i]
		g_Talent_Item[i] = {icon=icon,name=name,level = level,iconmask=iconmask, all=all}

	end


	for i=1,9 do
		local light = _G["Talent_Tree_Line"..i.."_2"]
		local dark  = _G["Talent_Tree_Line"..i]

		g_Talent_Line[i] = { light = light, dark = dark}

	end
	
	g_Talent_UI[1] = {icon = Talent_SkillIcon, name = Talent_SkillName}
	g_Talent_UI[2] = {[1] = g_Talent_Item[1], [2] = g_Talent_Item[2],[3] = g_Talent_Item[3]}
	g_Talent_UI[3] = {[1] = g_Talent_Item[4], [2] = g_Talent_Item[5],[3] = g_Talent_Item[6]}
	g_Talent_UI[4] = {[1] = g_Talent_Item[7], [2] = g_Talent_Item[8],[3] = g_Talent_Item[9]}
	g_Talent_UI[5] = {[1] = g_Talent_Item[10], [2] = g_Talent_Item[11],[3]=g_Talent_Item[12]}

end

function Talent_OnEvent(event)
	if(event == "ADJEST_UI_POS") then
		Talent_On_ResetPos()
	elseif(event == "VIEW_RESOLUTION_CHANGED") then
		Talent_On_ResetPos()
	elseif(event == "HIDE_ON_SCENE_TRANSED") then
		Talent_On_Hide()
	elseif event == "UI_COMMAND" and tonumber(arg0) == 20211030 then
		g_Talent_Sect = {}
		if this:IsVisible() then
			this:Hide()
			return
		end
		PushEvent("SECT_OPPOSITE",3)
		g_Talent_Sect = Split(Get_XParam_STR(0),"|")
		g_GetSectType = Get_XParam_INT(0)
		g_LastScetType = g_GetSectType
		--2022-07-09 新增
		local totallevel = Get_XParam_INT(1)
		local maxlayer = 2;
		local showlayer = math.floor(totallevel/20)+1;
		if showlayer > maxlayer then
			showlayer = maxlayer	--防止第二层点满了的情况
		end
		Talent_ChangeFenye(showlayer,1)
		if showlayer == 2 then
			g_GetSectType = g_GetSectType + 2
		end
		this:Show()
		return
	elseif event == "SECT_OPPOSITE" then
		if tonumber(arg0) ~= 3 then
			this:Hide()
		end
	elseif event == "FLUSH_SECT_PT" then
		Talent_SetLeftpoint()

	end
end



function Talent_Update()
	Talent_Talent:SetCheck(1)
	--Pos
	local selfUnionPos = Variable:GetVariable("SelfUnionPos");
	if(selfUnionPos ~= nil) then
		Talent_Frame:SetProperty("UnifiedPosition", selfUnionPos);
	end
	local menpai = Player:GetData("MEMPAI")
	local secttype = g_GetSectType
	Talent_InitSect(menpai,secttype)
	Talent_produceline()
	Talent_ShowLearnTree(menpai,secttype)
end


function Talent_ShowLearnTree(menpai,secttype)
	--工具函数，移出table
	local removekey = function(list,key)
		for i,v in ipairs(list) do
			if key == v then
				table.remove(list,i)
			end
		end
	end

	--工具函数，是否有这个value
	local hasValue = function(list, value)

		for i,v in ipairs(list) do
			if v == value then
				return 1
			end
		end

		return 0
	end

	local list = g_Talent_Info[menpai][secttype]
	local totallist = {}
	local light = {}
	local dark = {}
	if g_Talent_curToplayer <= 1 then
		for i,v in ipairs(list) do
			for vi,vv in ipairs(v) do
				if i == 1 then

				else
					if i <= 2 then
						if vv > 0 then
							table.insert(light,vv)
							g_Talent_UI[i][vi].iconmask:Hide();
						end				
					else
						if(vv > 0) then
							table.insert(dark,vv)
						end
					end

				end
			end
			
		end	
		
		Talent_produceBoard(list,light,1)
		Talent_produceBoard(list,dark,0)	
		return --直接返回
	end

	--构建全表
	for i,v in ipairs(list) do
		for vi,vv in ipairs(v) do
			if i == 1 then

			else
				if i <= g_Talent_curToplayer then
					if vv > 0 then
						if g_Talent_LearnedList[i] and vv == g_Talent_LearnedList[i].id then
							table.insert(light,vv)
							g_Talent_UI[i][vi].iconmask:Hide();
							removekey(totallist,vv)	
						else
							table.insert(dark,vv)
							g_Talent_UI[i][vi].iconmask:Show();
							removekey(totallist,vv)	
						end	
					end				
				else
					if(vv > 0) then
						table.insert(totallist,vv)
					end
				end

			end
		end
		
	end	

			--他上层的
		for i = g_Talent_curToplayer+1,5 do
			for j,vj in ipairs(list[i]) do
				if vj > 0 then
					if g_Talent_poslist[vj].canlearn > 0 then
						table.insert(light,vj)
						removekey(totallist,vj)	
					else
						table.insert(dark,vj)
						removekey(totallist,vj)	
					end
				end
			end
		end


		Talent_produceBoard(list,light,1)
		Talent_produceBoard(list,dark,0)

end


function Talent_GetposByID(id)
	if g_Talent_poslist[id] ~= nil then
		return g_Talent_poslist[id].layer,g_Talent_poslist[id].col
	end	

	return 1,1
end

function Talent_produceBoard(mainlist,list,blight)
	if list ~= nil then
		for i,v in pairs(list) do
			local x,y =Talent_GetposByID(v)
			if x > 1 then
				if blight == 1 then
					Talent_MaskHide(g_Talent_UI[x][y].all)
				else
					Talent_MaskShow(g_Talent_UI[x][y].all)
				end
				
			end
		end	
	end
end
function Talent_SetLeftpoint()
	--剩余天赋点数
	local leftpoint = Lua_GetSectPoint()
	Talent_Have:SetText(string.format("剩余武道领悟点：#G%s",leftpoint))
end


--处理连线
function Talent_Getline(p1,p2)

	p1 = tonumber(p1)
	p2 = tonumber(p2)
	--lua的二维数组不是很好用
	local list = { 
			[1] = {[4] = 1, [5] = 2},
			[3] = {[5] = 9, [6] = 3},
			[6] = {[9] = 8, [12] = 6},
			[7] = {[10] = 4, [11] = 5},
			[9]= {[12] = 7}}


	if list[p1]~= nil and list[p1][p2] ~= nil then
		return list[p1][p2]
	end
	return -1


end
function Talent_produceline()
	local coverpos = function(info)
		if info then
			return (info.layer-2)*3+info.col   --(i-2)*3+vi
		end
		return -1
	end

	local hasvalue = function(table,value)
		for i,v in pairs(table) do
			if v == value then
				return 1
			end
		end
		return 0
	end		
	--local linelist = g_Talent_Studyup_Info[menpai][secttype].line
	for i,v in ipairs(g_Talent_Line) do

		v.light:Hide()
		v.dark:Hide()
	end

	local linelist = {}

	for i,v in pairs(g_Talent_StudyTree) do
		local lineid = Talent_Getline(coverpos(g_Talent_poslist[v]),coverpos(g_Talent_poslist[i]))
		if lineid > 0 then
			table.insert(linelist,lineid)
		end
	end
	for j,vj in pairs(linelist) do
		g_Talent_Line[vj].dark:Show()		
	end	
	--目前只有一个6,12 是跨行的，特写一下
	if g_Talent_curToplayer == 5 then
		local lineindex = Talent_Studyup_Getline(g_Talent_LearnedList[3].pos,g_Talent_LearnedList[5].pos)
		if lineindex > 0 and hasvalue(linelist,lineindex) == 1 then
			
			g_Talent_Line[lineindex].light:Show()
			g_Talent_Line[lineindex].dark:Hide()
		end		
	end
	for i,v in ipairs(g_Talent_LearnedList) do
		if g_Talent_LearnedList[i+1] ~= nil then
			local lineindex = Talent_Getline(g_Talent_LearnedList[i].pos,g_Talent_LearnedList[i+1].pos)
			if lineindex > 0 and hasvalue(linelist,lineindex) == 1 then
				
				g_Talent_Line[lineindex].light:Show()
				g_Talent_Line[lineindex].dark:Hide()
			end
		end
	end

end
--处理连线end

function Talent_InitSect(menpai,secttype)
	Talent_UpPage:Disable()
	Talent_DownPage:Disable()

	g_Talent_LearnedList={}
	g_Talent_poslist = {}
	g_Talent_StudyTree = {}
	local SetSectcube = function(info,state)
		if state == 0 then
			info.all:Hide()
		else
			info.all:Show()
		end
	end


	Talent_SetLeftpoint()
	local list = g_Talent_Info[menpai][secttype]

	local sectname = Lua_GetSectName(menpai,secttype)
	Talent_LiuPaiIcon:SetProperty( "Image", list.icon )
	Talent_LiuPaiName:SetText(sectname)
	Talent_LiuPaiDetails:SetText(list.instrct)
	
	local totallevel = Lua_GetSectTotalLevel(0)
	for i,v in ipairs(list) do
		for vi,vv in ipairs(v) do
			local infodetail;
			local action = nil
			local bhave,level;
			local canlearn = 0;
			if vv >= 0 then
				bhave,level = Lua_HasSect(vv,0);
				action = Lua_CreateSectInfoAction(vv,level);
				action = GemMelting:UpdateProductAction(action)
				infodetail = TBSearch_Index_EQU("DBC_SECT_INFO",vv)

				--把他的前置条件存一下
				if infodetail.limittype > 0 then
					table.insert(g_Talent_StudyTree,vv,infodetail.limittype)
				end		
				if bhave > 0 then
					table.insert(g_Talent_LearnedList,i,{id = vv, pos = (i-2)*3+vi, line=i,col=vi,level=level})
					g_Talent_curToplayer = i
				else
					canlearn = Talent_CheckCanLearn(infodetail,totallevel) 
				end

				table.insert(g_Talent_poslist,vv,{layer = i,col = vi,canlearn=canlearn})
			end
			if i == 1 then
				--第一层数据少
				if action then
					g_Talent_UI[i].icon:SetProperty("DraggingEnabled","False")
					g_Talent_UI[i].icon:SetActionItem(action:GetID());
				end

				if infodetail.addskill > 0 then
				--有技能就换技能的图标啊
					local nSumSkill = GetActionNum("skill");
					for j=1, nSumSkill do
						theAction = EnumAction(j-1, "skill");
						if theAction:GetDefineID() == infodetail.addskill then	
							g_Talent_UI[i].icon:SetProperty("DraggingEnabled","True")
							g_Talent_UI[i].icon:SetActionItem(theAction:GetID());
					
						end
					end					
				end
				g_Talent_UI[i].name:SetText(infodetail.szName)
			else
				local uidata = g_Talent_UI[i][vi];
				if vv < 0 then
					SetSectcube(uidata,0)
				else
					SetSectcube(uidata,1)

					if(action) then
						uidata.icon:SetActionItem(action:GetID());
					end
					uidata.name:SetText(infodetail.szName);
					if bhave == 0 then
						if canlearn > 0 then
							uidata.iconmask:Hide()
							--Talent_MaskHide(uidata.all)	
						else
							uidata.iconmask:Show()
							--Talent_MaskShow(uidata.all)
						end

					else
						Talent_MaskHide(uidata.all)		
						uidata.iconmask:Hide()						
					end

					uidata.level:SetText(level.."/"..infodetail.maxlevel)
				end

			end
		end
		
	end

end

function Talent_CheckCanLearn(infodetail,totalpoint)
	local canup1 = 0;
	local canup2 = 0;
	if infodetail.limittype > 0 then
		local bhave,level = Lua_HasSect(infodetail.limittype,0);
		if bhave > 0 and level >= infodetail.lparam1 then
				canup1 = 1;
		else
			canup1 = 0;
		end
	else
		canup1 = 1
	end

	if(infodetail.lparam2 > 0) then
		if infodetail.lparam2 > totalpoint then
			canup2 = 0
		else
			canup2 = 1
		end
	else
		canup2 = 1
	end

	if canup1 > 0 and canup2 > 0 then
		return 1
	else
		return 0
	end


end

function Talent_CareObj()
	if(tonumber(arg0) ~= g_objCareID) then
		return;
	end
	--如果和NPC的距离大于一定距离或者被删除，自动关闭
	if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
		--取消关心
		Talent_StopCareObject(g_objCareID)
		Talent_On_Hide()
	end		
end

function Talent_StopCareObject(objCaredId)
	this:CareObject(objCaredId, 0, "Talent");
	g_objCareID = -1;
end

function Talent_BeginCareObject(objid)
	g_Object = objid
	this:CareObject(g_Object, 1, "Talent");
end

function Talent_On_ResetPos()
	Talent_Frame:SetProperty("UnifiedPosition", g_Talent_Frame_UnifiedPosition)
end

function Talent_On_Hide()
	this:Hide()
end

function Talent_Help_Click()
end



function Talent_SelfEquip_Page_Switch()

	Variable:SetVariable("SelfUnionPos", Talent_Frame:GetProperty("UnifiedPosition"), 1);
	OpenEquip(1);
end

function Talent_SelfData_Switch()
	Variable:SetVariable("SelfUnionPos", Talent_Frame:GetProperty("UnifiedPosition"), 1);
	SystemSetup:OpenPrivatePage("self");
end

function Talent_Pet_Switch()
	Variable:SetVariable("SelfUnionPos", Talent_Frame:GetProperty("UnifiedPosition"), 1);
	TogglePetPage();
end


function Talent_Wuhun_Switch()
	Variable:SetVariable("SelfUnionPos", Talent_Frame:GetProperty("UnifiedPosition"), 1);
	ToggleWuhunPage();
end


function Talent_Xiulian_Switch()
    local nLevel = Player:GetData("LEVEL")
	if(nLevel >= 70) then
		Variable:SetVariable("SelfUnionPos", Talent_Frame:GetProperty("UnifiedPosition"), 1);
		XiuLianPage();
	else
	    Talent_Talent:SetCheck(0)
	    PushDebugMessage("#{XL_090707_62}")
	end
end


function Talent_Talent_Switch()
	Talent_Talent:SetCheck(1)
end



function Talent_Ride_Switch()
	Variable:SetVariable("SelfUnionPos", Talent_Frame:GetProperty("UnifiedPosition"), 1);
	OpenRidePage();
end



function Talent_Other_Info_Page_Switch()
	Variable:SetVariable("SelfUnionPos", Talent_Frame:GetProperty("UnifiedPosition"), 1);
	OtherInfoPage();
end

function Talent_Close()
	this:Hide()
end

function Talent_MaskHide(mask)
	mask:SetProperty("Image","set:Talent image:Talent_HoverBK")
end

function Talent_MaskShow(mask)
	mask:SetProperty("Image","set:Talent image:Talent_DisBK")
end
function Talent_ChangeFenye(index,bInit)
	Talent_SetFenYe(index)
	if index == 1 then
		g_GetSectType = g_LastScetType
	elseif index == 2 then
		g_GetSectType = g_LastScetType + 2
	end
	g_Talent_curFenye = index
	Talent_Update()
end
function Talent_SetFenYe(fenye)
	local fenyetable = {Talent_SkillTree_Advance,Talent_SkillTree_Advance2}
	for i , v in ipairs(fenyetable) do
		if i == fenye then
			v:SetCheck(1)
		else
			v:SetCheck(0)
		end
	end
end
function Talent_ChatBtn()
	-- Player:Lua_CreateSectShare()



end