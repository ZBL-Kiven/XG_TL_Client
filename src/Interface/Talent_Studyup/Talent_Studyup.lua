--Q546528533 仅供娱乐交流，切勿它用，请浏览后24小时内删除
--id:429
--界面1
local g_Talent_Studyup_Frame_UnifiedPosition = nil 

local g_Talent_Studyup_Item = {}
local g_Talent_Studyup_UI = {}
local g_Talent_Studyup_Line = {}
local g_Talent_Studyup_saveid = -1
local g_Talent_Studyup_layer = -1
local g_Talent_Studyup_col = -1
local g_Talent_Studyup_StudyTree = {}	--存当前流派需要有前置天赋的数据
local g_Talent_Studyup_LearnedList = {}
local g_Talent_Studyup_curToplayer = 0
local g_GetSectType = 0
local g_LastSectType = 0
local g_Talent_Studyup_poslist = {}		--根据ID快查位置
local g_Talent_Studyup_Info =
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
-- local g_Talent_Sect = {}
local g_Talent_table ={[1]=1,[2]=2,[3]=3,[4]=4,[5]=5,[6]=6,[7]=7,[8]=8,[9]=9,[10]=10,[11]=11,[12]=1,[13]=2,[14]=3,[15]=4,[16]=5,[17]=6,[18]=7,[19]=8,[20]=9,[21]=10,[22]=11,[23]=1,[24]=2,[25]=3,[26]=4,[27]=5,[28]=6,[29]=7,[30]=8,[31]=9,[32]=10,[33]=11,[34]=1,[35]=2,[36]=3,[37]=4,[38]=5,[39]=6,[40]=7,[41]=8,[42]=9,[43]=10,[44]=11,[45]=1,[46]=2,[47]=3,[48]=4,[49]=5,[50]=6,[51]=7,[52]=8,[53]=9,[54]=10,[55]=11,[56]=1,[57]=2,[58]=3,[59]=4,[60]=5,[61]=6,[62]=7,[63]=8,[64]=9,[65]=10,[66]=11,[67]=1,[68]=2,[69]=3,[70]=4,[71]=5,[72]=6,[73]=7,[74]=8,[75]=9,[76]=10,[77]=11,[78]=1,[79]=2,[80]=3,[81]=4,[82]=5,[83]=6,[84]=7,[85]=8,[86]=9,[87]=10,[88]=11,[89]=1,[90]=2,[91]=3,[92]=4,[93]=5,[94]=6,[95]=7,[96]=8,[97]=9,[98]=10,[99]=11,[100]=1,[101]=2,[102]=3,[103]=4,[104]=5,[105]=6,[106]=7,[107]=8,[108]=9,[109]=10,[110]=11,[111]=1,[112]=2,[113]=3,[114]=4,[115]=5,[116]=6,[117]=7,[118]=8,[119]=9,[120]=10,[121]=11,[122]=1,[123]=2,[124]=3,[125]=4,[126]=5,[127]=6,[128]=7,[129]=8,[130]=9,[131]=10,[132]=11,[133]=1,[134]=2,[135]=3,[136]=4,[137]=5,[138]=6,[139]=7,[140]=8,[141]=9,[142]=10,[143]=11,[144]=1,[145]=2,[146]=3,[147]=4,[148]=5,[149]=6,[150]=7,[151]=8,[152]=9,[153]=10,[154]=11,[155]=1,[156]=2,[157]=3,[158]=4,[159]=5,[160]=6,[161]=7,[162]=8,[163]=9,[164]=10,[165]=11,[166]=1,[167]=2,[168]=3,[169]=4,[170]=5,[171]=6,[172]=7,[173]=8,[174]=9,[175]=10,[176]=11,[177]=1,[178]=2,[179]=3,[180]=4,[181]=5,[182]=6,[183]=7,[184]=8,[185]=9,[186]=10,[187]=11,[188]=1,[189]=2,[190]=3,[191]=4,[192]=5,[193]=6,[194]=7,[195]=8,[196]=9,[197]=10,[198]=11,}

function Talent_Studyup_PreLoad()

	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	--this:RegisterEvent("OBJECT_CARED_EVENT")
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("FLUSH_SECT_LEVELUP",false)
	this:RegisterEvent("SECT_OPPOSITE",false)

end 

-- Talent_Studyup_DragTitle => TLBB_DragTitle
-- Talent_Studyup_Help => TLBB_ButtonHelp
-- Talent_Studyup_Close => TLBB_ButtonClose
-- Talent_Studyup_Frame_Client => DefaultWindow
function Talent_Studyup_OnLoad()
	g_Talent_Studyup_Frame_UnifiedPosition = Talent_Studyup_Frame:GetProperty("UnifiedPosition");

	for i =1, 12 do

		local icon = _G["Talent_Studyup_SkillTree_Skill"..i.."Icon"]
		local name = _G["Talent_Studyup_SkillTree_Skill"..i.."Name"]
		local level = _G["Talent_Studyup_SkillTree_Skill"..i.."Level"]
		local mask = _G["Talent_Studyup_SkillTree_Skill"..i]
		local iconmask = _G["Talent_Studyup_SkillTree_Skill"..i.."IconMask"]
		local all = _G["Talent_Studyup_SkillTree_Skill"..i.."Btn"]
		local animate = _G["Talent_Studyup_SkillTree_Skill"..i.."IconAnimate"]
		g_Talent_Studyup_Item[i] = {icon=icon,name=name,level=level,mask=mask, iconmask=iconmask, animate= animate,all=all}

	end

	for i=1,9 do
		local light = _G["Talent_Studyup_SkillTree_Line"..i.."_2"]
		local dark  = _G["Talent_Studyup_SkillTree_Line"..i]

		g_Talent_Studyup_Line[i] = { light = light, dark = dark}

	end
	--g_Talent_Studyup_Item[5].name:SetText("fdd")
	g_Talent_Studyup_UI[1] = {icon = Talent_Studyup_SkillTree_SkillIcon, name = Talent_Studyup_SkillTree_SkillName}
	g_Talent_Studyup_UI[2] = {[1] = g_Talent_Studyup_Item[1], [2] = g_Talent_Studyup_Item[2],[3] = g_Talent_Studyup_Item[3]}
	g_Talent_Studyup_UI[3] = {[1] = g_Talent_Studyup_Item[4], [2] = g_Talent_Studyup_Item[5],[3] = g_Talent_Studyup_Item[6]}
	g_Talent_Studyup_UI[4] = {[1] = g_Talent_Studyup_Item[7], [2] = g_Talent_Studyup_Item[8],[3] = g_Talent_Studyup_Item[9]}
	g_Talent_Studyup_UI[5] = {[1] = g_Talent_Studyup_Item[10], [2] = g_Talent_Studyup_Item[11],[3]=g_Talent_Studyup_Item[12]}


	--Talent_Studyup_SkillTree_MenPai:Hide()
end

function Talent_Studyup_OnEvent(event)
	if(event == "ADJEST_UI_POS") then
		Talent_Studyup_On_ResetPos()
	elseif(event == "VIEW_RESOLUTION_CHANGED") then
		Talent_Studyup_On_ResetPos()
	elseif(event == "HIDE_ON_SCENE_TRANSED") then
		Talent_Studyup_On_Hide()
	elseif event == "UI_COMMAND" and tonumber(arg0) == 120211030 then
		CloseWindow( "Talent_Preview" );
		g_Talent_Sect = {}
		g_Talent_Sect = Split(Get_XParam_STR(0),"|")
		local menpai = Player:GetData("MEMPAI")
		local secttype = Get_XParam_INT(1)
		g_GetSectType = secttype
		g_LastSectType = g_GetSectType
		local targetobjId = tonumber(Get_XParam_INT(0));
		Talent_Studyup_BeginCareObject(targetobjId)
		--二重
		local totallevel = Get_XParam_INT(2)
		local showlayer = math.floor(totallevel/20)+1;
		local maxlayer = 2;
		if showlayer > maxlayer then
			showlayer = maxlayer	--防止第二层点满了的情况
		end
		Talent_Studyup_ChangeFenye(showlayer,1)
		Talent_Studyup_SkillTree_Advance2Animate:Hide()
		PushEvent("SECT_OPPOSITE",1)
		this:Show()	
	elseif event == "UI_COMMAND" and tonumber(arg0) == 120211031 then
		g_Talent_Sect = {}
		g_Talent_Sect = Split(Get_XParam_STR(0),"|")	
		local menpai = Player:GetData("MEMPAI")
		local secttype = g_GetSectType
		Talent_Studyup_InitSect(menpai,secttype)
		Talent_Studyup_produceline()
		local param = Get_XParam_INT(0)
		Talent_Studyup_animate(param)
		Talent_Studyup_SkillTreeClicked(g_Talent_Studyup_layer,g_Talent_Studyup_col)
	elseif event == "SECT_OPPOSITE" then
		if tonumber(arg0) ~= 1 then
			this:Hide()
		end

	end
end
function Talent_Studyup_Update()
	local menpai = Player:GetData("MEMPAI")
	local secttype = g_GetSectType
	
	Talent_Studyup_InitSect(menpai,secttype)
	Talent_Studyup_produceline()
	local line,col = Talent_Studyup_ShowSkill(menpai,secttype)
	Talent_Studyup_SkillTreeClicked(line,col)
end

function Talent_Studyup_animate(param)
	local i,j = Talent_Studyup_GetposByID(param)
	if i > 1 then
		g_Talent_Studyup_UI[i][j].animate:Play(true)
	end

end


function Talent_Studyup_GetposByID(id)
	if g_Talent_Studyup_poslist[id] ~= nil then
		return g_Talent_Studyup_poslist[id].layer,g_Talent_Studyup_poslist[id].col
	end	
	return 1,1
end



function Talent_Studyup_ShowSkill(menpai,secttype)
	if g_Talent_Studyup_curToplayer == 1 then
		return 2,1
	end
	list = g_Talent_Studyup_Info[menpai][secttype]
	local learnedinfo = g_Talent_Studyup_LearnedList[g_Talent_Studyup_curToplayer];
	if learnedinfo ~= nil then
		if learnedinfo.level < 5 or g_Talent_Studyup_curToplayer == 5 then	--第五层了或者没够5级
			return learnedinfo.line,learnedinfo.col
		else


			--第二顺位			
			for i,v in ipairs(list[g_Talent_Studyup_curToplayer+1]) do
			--下一排的需要挨个检验
				if g_Talent_Studyup_StudyTree[v] ~= nil then
					if g_Talent_Studyup_StudyTree[v] ~= nil then
						if g_Talent_Studyup_StudyTree[v] == learnedinfo.id then
							return g_Talent_Studyup_curToplayer+1,i
						else

						end
					end
				else
					return g_Talent_Studyup_curToplayer+1,i
				end
			end			
			--返回下一层第一个
			return g_Talent_Studyup_curToplayer+1,1
		end

	


	end

end

--处理连线
function Talent_Studyup_Getline(p1,p2)

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
function Talent_Studyup_produceline()

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
	for i,v in ipairs(g_Talent_Studyup_Line) do

		v.light:Hide()
		v.dark:Hide()
	end

	local linelist = {}
	--可以根据g_Talent_Studyup_StudyTree算出那些有关联
	for i,v in pairs(g_Talent_Studyup_StudyTree) do
		local lineid = Talent_Studyup_Getline(coverpos(g_Talent_Studyup_poslist[v]),coverpos(g_Talent_Studyup_poslist[i]))
		if lineid > 0 then
			table.insert(linelist,lineid)
		end
	end
	for j,vj in pairs(linelist) do
		g_Talent_Studyup_Line[vj].dark:Show()		
	end	

	--目前只有一个6,12 是跨行的，特写一下
	if g_Talent_Studyup_curToplayer == 5 then
		local lineindex = Talent_Studyup_Getline(g_Talent_Studyup_LearnedList[3].pos,g_Talent_Studyup_LearnedList[5].pos)
		if lineindex > 0 and hasvalue(linelist,lineindex) == 1 then
			
			g_Talent_Studyup_Line[lineindex].light:Show()
			g_Talent_Studyup_Line[lineindex].dark:Hide()
		end		
	end
	for i,v in ipairs(g_Talent_Studyup_LearnedList) do
		if g_Talent_Studyup_LearnedList[i+1] ~= nil then
			local lineindex = Talent_Studyup_Getline(g_Talent_Studyup_LearnedList[i].pos,g_Talent_Studyup_LearnedList[i+1].pos)

			if lineindex > 0 and hasvalue(linelist,lineindex) == 1 then
				
				g_Talent_Studyup_Line[lineindex].light:Show()
				g_Talent_Studyup_Line[lineindex].dark:Hide()
			end
		end
	end

end


function Talent_Studyup_SetLeftpoint(leftpoint)
			--剩余天赋点数

			Talent_Studyup_Skillup_Have:SetText(string.format("剩余武道领悟点：#G%s",leftpoint))
end


function Talent_Studyup_CheckCanLearn(infodetail,totalpoint)
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
function Talent_Studyup_ChangeFenye(page,bInit)
	Talent_Studyup_SetFenYe(page)
	g_Talent_Studyup_curFenye = page
	if page == 1 then
		g_GetSectType = g_LastSectType
	elseif page == 2 then 
		g_GetSectType = g_LastSectType + 2
	end
	Talent_Studyup_Update()
end
function Talent_Studyup_SetFenYe(page)
	local fenyetable = {Talent_Studyup_SkillTree_Advance,Talent_Studyup_SkillTree_Advance2}
	for i , v in ipairs(fenyetable) do
		if i == page then
			v:SetCheck(1)
		else
			v:SetCheck(0)
		end
	end
end
--设置界面
function Talent_Studyup_InitSect(menpai,secttype)

	Talent_Studyup_SkillTree_Line1:Show()
	Talent_Studyup_SkillTree_UpPage:Disable()
	Talent_Studyup_SkillTree_DownPage:Disable()

	g_Talent_Studyup_StudyTree = {}
	g_Talent_Studyup_LearnedList={}
	g_Talent_Studyup_poslist = {}
	local SetSectcube = function(info,state)
		if state == 0 then
			info.all:Hide()
		else
			info.all:Show()
		end
	end

	local list = g_Talent_Studyup_Info[menpai][secttype]
	local sectname = Lua_GetSectName(menpai,secttype)
	Talent_Studyup_SkillTree_LiuPaiName:SetText(sectname)
	Talent_Studyup_SkillTree_LiuPaiDetails:SetText(list.instrct)
	Talent_Studyup_SkillTree_LiuPaiIcon:SetProperty( "Image", list.icon )
	--暂时保留
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
					table.insert(g_Talent_Studyup_StudyTree,vv,infodetail.limittype)
				end
				if bhave > 0 then
					table.insert(g_Talent_Studyup_LearnedList,i,{id = vv, pos = (i-2)*3+vi, line=i,col=vi,level=level})
					g_Talent_Studyup_curToplayer = i
				else
					canlearn = Talent_Studyup_CheckCanLearn(infodetail,totallevel) 
				end

				table.insert(g_Talent_Studyup_poslist,vv,{layer = i,col = vi, canlearn=canlearn})
			end
			if i == 1 then
				--第一层数据少
				if action then
					g_Talent_Studyup_UI[i].icon:SetActionItem(action:GetID());
				end
				g_Talent_Studyup_UI[i].name:SetText(infodetail.szName)
			else
				local uidata = g_Talent_Studyup_UI[i][vi];
				if vv < 0 then
					SetSectcube(uidata,0)
				else
					SetSectcube(uidata,1)
					uidata.all:SetCheck(0)
					if(action) then
						uidata.icon:SetActionItem(action:GetID());
					end

					uidata.animate:Play(false)
					uidata.name:SetText(infodetail.szName);
					if bhave == 0 then
						if canlearn > 0 then
							uidata.iconmask:Hide()	
						else
							uidata.iconmask:Show()
						end

					else
						Talent_Studyup_MaskHide(uidata.mask)
						uidata.iconmask:Hide()							
					end

					uidata.level:SetText(level.."/"..infodetail.maxlevel)
				end

			end
		end
		
	end

	

end
function Talent_Studyup_CleanUp()

end

function Talent_Studyup_Close()

	this:Hide()
end


function Talent_Studyup_BeginCareObject(objid)
	local nID = DataPool : GetNPCIDByServerID( objid )
	this:CareObject(nID, 1, "Talent_Studyup");
end

function Talent_Studyup_On_ResetPos()
	Talent_Studyup_Frame:SetProperty("UnifiedPosition", g_Talent_Studyup_Frame_UnifiedPosition)
end

function Talent_Studyup_On_Hide()
	this:Hide()
end

function Talent_Studyup_Help_Click()
end

function Talent_Studyup_Close_Click()
end


function Talent_Studyup_DetailShow(bshow)

	if bshow == 0 then
		Talent_Studyup_Details:Show()
		Talent_Studyup_Skillup:Hide()
	else
		Talent_Studyup_Details:Hide()
		Talent_Studyup_Skillup:Show()
	end

end



function Talent_Studyup_ShowTree(list,layer,col)

	for i=2,5 do
		for j,vj in ipairs(list[i]) do
			if vj > 0  then				
				local x,y =Talent_Studyup_GetposByID(vj)				
				if i == 2 then
					Talent_Studyup_MaskHide(g_Talent_Studyup_UI[x][y].mask)
				else				
					Talent_Studyup_MaskShow(g_Talent_Studyup_UI[x][y].mask)
				end
			end
		end
	end

	

end


function Talent_Studyup_produceBoard(mainlist,list,blight)
	if list ~= nil then
		for i,v in pairs(list) do
			local x,y =Talent_Studyup_GetposByID(v)
			if x > 1 then
				if blight == 1 then
					Talent_Studyup_MaskHide(g_Talent_Studyup_UI[x][y].mask)
				else
					Talent_Studyup_MaskShow(g_Talent_Studyup_UI[x][y].mask)
				end
				
			end
		end	
	end
end

function Talent_Studyup_DebugList(head,list)
	local str = ""
	if list ~= nil then
		for i,v in pairs(list) do
			str = str..","..v
		end
	else
		str = str.."null"
	end
	-- PushDebugMessage(head..str)
end


--这个特点是已经学过的技能，同级和下级铁锁定
function Talent_Studyup_ShowLearnTree(list,layer,col)

	--工具函数，移出table
	local removekey = function(list,key)
		for i,v in ipairs(list) do
			if key == v then
				table.remove(list,i)
			end
		end
	end

	if layer < 2 then
		return
	end

	local id = list[layer][col];

	local totallist,light,dark = Talent_Studyup_Createboardlist(list)



			--他上层的全暗
		for i = g_Talent_Studyup_curToplayer+1,5 do
			for j,vj in ipairs(list[i]) do
				if vj > 0 then
					if g_Talent_Studyup_poslist[vj].canlearn > 0 then
						table.insert(light,vj)
						removekey(totallist,vj)	
					else
						table.insert(dark,vj)
						removekey(totallist,vj)	
					end
				end
			end
		end


		Talent_Studyup_produceBoard(list,light,1)
		Talent_Studyup_produceBoard(list,dark,0)

	
end

function Talent_Studyup_Createboardlist(list)
	local totallist = {}
	local light = {}
	local dark = {}
	--工具函数，移出table
	local removekey = function(list,key)
		for i,v in ipairs(list) do
			if key == v then
				table.remove(list,i)
			end
		end
	end

	--构建全表
	for i,v in ipairs(list) do
		for vi,vv in ipairs(v) do
			if i == 1 then

			else
				if i <= g_Talent_Studyup_curToplayer then
					if vv > 0 then
						if g_Talent_Studyup_LearnedList[i] and vv == g_Talent_Studyup_LearnedList[i].id then
							table.insert(light,vv)
							g_Talent_Studyup_UI[i][vi].iconmask:Hide();
							removekey(totallist,vv)	
						else
							table.insert(dark,vv)
							g_Talent_Studyup_UI[i][vi].iconmask:Show();
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
	return totallist,light,dark

end




function Talent_Studyup_SkillTreeClicked(layer,col)

	local menpai = Player:GetData("MEMPAI")
	local secttype = g_GetSectType

	local totallevel = Lua_GetSectTotalLevel(0)
	local list = g_Talent_Studyup_Info[menpai][secttype]
	local id = list[layer][col]; --呀，这个直接取不就行了？
	g_Talent_Studyup_saveid = id 
	g_Talent_Studyup_layer = layer
	g_Talent_Studyup_col = col
	Talent_Studyup_Skillup_Up:Enable()

	if totallevel <= 0 then
		--什么都没学的状态下需要展示冲突树
		Talent_Studyup_ShowTree(list,layer,col)
	else
		Talent_Studyup_ShowLearnTree(list,layer,col)
	end





	if layer == 1 then
		local infodesc = TBSearch_Index_EQU("DBC_SECT_DESC",id)
		local info = TBSearch_Index_EQU("DBC_SECT_INFO",id)
		local color = "#cFFF263"
		Talent_Studyup_DetailsName:SetText(info.szName)
		Talent_Studyup_Skillup_DetailsText:SetText(color..infodesc.szLevelDesc[1])
		Talent_Studyup_DetailShow(0)
		Talent_Studyup_SkillTree_SkillBtn:SetCheck(1)

		
	else
		g_Talent_Studyup_UI[layer][col].all:SetCheck(1)
		local bhave,level = Lua_HasSect(id,0);
		local infodesc = TBSearch_Index_EQU("DBC_SECT_DESC",id)
		local info = TBSearch_Index_EQU("DBC_SECT_INFO",id)
		Talent_Studyup_DetailShow(1)
		Talent_Studyup_SkillupName:SetText(info.szName)

		local str = string.format("#cfff263武道等级：%s级",level)
		Talent_Studyup_Skilluplevel:SetText(str)
		local strlayer = string.format("武道境界：武道%s重",infodesc.szJingjie)
		Talent_Studyup_SkilluplevelRealm:SetText(strlayer)

		local color = "#cFFF263"
		local needpt = 0
			--所需天赋点
			if level == info.maxlevel then
				Talent_Studyup_Skillup_EffectTitle:SetText(string.format("当前等级效果（%s级）",level))
				Talent_Studyup_Skillup_Explain1:SetText(color..infodesc.szLevelDesc[level])
				Talent_Studyup_Skillup_Explain2:SetText("")
				needpt = 0
				Talent_Studyup_Skillup_Up:Disable()
				Talent_Studyup_Skillup_EffectNextTitleDot:Hide()
				Talent_Studyup_Skillup_EffectNextTitle:Hide()
			elseif level == 0 then
				Talent_Studyup_Skillup_EffectTitle:SetText("#{TalentMP_20210804_60}")
				Talent_Studyup_Skillup_Explain1:SetText(color..infodesc.szLevelDesc[level+1])

				Talent_Studyup_Skillup_Explain2:SetText("")

				Talent_Studyup_Skillup_EffectNextTitleDot:Hide()
				Talent_Studyup_Skillup_EffectNextTitle:Hide()

				needpt = info.m_levelinfo[level+1].m_point

			else
				Talent_Studyup_Skillup_EffectTitle:SetText(string.format("当前等级效果（%s级）",level))
				Talent_Studyup_Skillup_Explain1:SetText(color..infodesc.szLevelDesc[level])

				Talent_Studyup_Skillup_EffectNextTitleDot:Show()
				Talent_Studyup_Skillup_EffectNextTitle:Show()		
				Talent_Studyup_Skillup_EffectNextTitle:SetText(string.format("下一等级效果（%s级）",level+1))
				Talent_Studyup_Skillup_Explain2:SetText(color..infodesc.szLevelDesc[level+1])
				

				needpt = info.m_levelinfo[level+1].m_point
			end



			local levelrequire = {Talent_Studyup_Skillup_Text1,Talent_Studyup_Skillup_Text2,Talent_Studyup_Skillup_Text3}

			local str1 = ""
			--处理升级限制条件1
			if info.limittype > 0 then

				local infoc = TBSearch_Index_EQU("DBC_SECT_DESC",info.limittype)
				str1 = string.format("需将#G%s#cfff263修行至#G%s#cfff263级",infoc.szName,info.lparam1)
				
			else
				str1 = ""
			end
			
			local str2 = ""
			--处理升级限制条件2
			if info.lparam2 > 0 then
				local sectname = Lua_GetSectName(menpai,secttype)
				str2 = string.format("当前#G%s#cfff263流派修行等级需达到#G%s#cfff263级",sectname,info.lparam2 )
			else
				str2 = ""
			end

			local str3 = ""
			--处理冲突字符串
			local conflictstr = ""
			for i,v in ipairs(list[layer]) do
				if v > 0 and v ~= id then
					local infoc = TBSearch_Index_EQU("DBC_SECT_DESC",v)	

					conflictstr = conflictstr..infoc.szName.."、"
				end
			end
			if string.len(conflictstr) > 0 then
				conflictstr = string.sub(conflictstr,1,-3)
				str3 = string.format("不可与#G%s#cfff263同时修行",conflictstr)
			else
				str3 = ""
			end


			local strlist = {str1,str2,str3}
			local textUI = 1
			for i=1,3 do
				levelrequire[i]:SetText("")
				if(string.len(strlist[i]) > 0) then
					levelrequire[textUI]:SetText(strlist[i])
					textUI = textUI+1
				end
			end



			local strneed = ""
			local leftpoint = Lua_GetSectPoint()
			if leftpoint >= needpt then
				strneed = "#G"..needpt
			else
				strneed = "#cff0000"..needpt
			end

			Talent_Studyup_Skillup_Need:SetText(string.format("所需武道领悟点：%s",strneed))
			Talent_Studyup_SetLeftpoint(leftpoint)

		




	end
end


function Talent_Studyup_Skillup_Up_Clicked()
	--升级流派
	Lua_AskSectOper(0,g_Talent_Studyup_saveid)

end


function Talent_Studyup_SkillTree_UpPage_Clicked()

end

function Talent_Studyup_SkillTree_DownPage_Clicked()

end

function Talent_Studyup_MaskHide(mask)
	mask:SetProperty("Image","set:Talent image:Talent_HoverBK")
end

function Talent_Studyup_MaskShow(mask)
	mask:SetProperty("Image","set:Talent image:Talent_DisBK")
end
