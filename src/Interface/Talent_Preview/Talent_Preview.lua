--Q546528533 仅供娱乐交流，切勿它用，请浏览后24小时内删除
local g_Talent_Preview_Frame_UnifiedPosition = nil 
local g_Talent_Preview_Item = {}
local g_Talent_Preview_UI = {}
local g_Talent_Preview_Line = {}
local g_Talent_Preview_StudyTree = {}	--存当前流派需要有前置天赋的数据

local g_Talent_preview_menpai = -1
local g_Talent_preview_secttype = -1
local g_Talent_preview_targetid = -1
local g_Talent_Preview_curFenye = 1
local g_Talent_Preview_LaseFenye = 1
local g_Talent_Preview_Info =
{
	[0] =
	{
		[1] = {instrct = "#{TalentSL_20210804_02}",icon="set:Talent image:Talent_SLLH",SectName = "#{TalentSL_20210804_03}",
				 [1] = {23}, [2] = {24,-1,25},[3] = {26,27,28},[4] = {29,30,-1}, [5] = {31,32,33}},
		[2] = {instrct = "#{TalentSL_20210804_04}",icon="set:Talent image:Talent_SLJG",SectName = "#{TalentSL_20210804_05}",
					[1] = {34},[2] = {35,-1,36}, [3] = {37,38,39}, [4] = {40,-1,41},[5] = {42,43,44}},
		[3] = {instrct = "#{TalentSL_20210804_02}",icon="set:Talent image:Talent_SLLH",SectName = "#{TalentSL_20210804_03}",
				 [1] = {23}, [2] = {199,-1,200},[3] = {201,202,203},[4] = {204,-1,205}, [5] = {206,207,208}},
		[4] = {instrct = "#{TalentSL_20210804_04}",icon="set:Talent image:Talent_SLJG",SectName = "#{TalentSL_20210804_05}",
					[1] = {34},[2] = {209,-1,210}, [3] = {211,212,213}, [4] = {214,-1,215},[5] = {216,217,218}}
	},
	[1] =
	{
		[1] = {instrct = "#{TalentMJ_20210804_02}",icon="set:Talent image:Talent_MJTL", SectName = "#{TalentMJ_20210804_03}",
				[1] = {45}, [2] = {46,-1,47},[3] = {48,49,50},[4] = {51,-1,52}, [5] = {53,54,55}},
		[2] = {instrct = "#{TalentMJ_20210804_04}",icon="set:Talent image:Talent_MJXL", SectName = "#{TalentMJ_20210804_05}",
				[1] = {56},[2] = {57,-1,58}, [3] = {59,60,61}, [4] = {62,-1,63},[5] = {64,65,66}},
		[3] = {instrct = "#{TalentMJ_20210804_02}",icon="set:Talent image:Talent_MJTL", SectName = "#{TalentMJ_20210804_03}",
				[1] = {45}, [2] = {219,-1,220},[3] = {221,222,223},[4] = {224,-1,225}, [5] = {226,227,228}},
		[4] = {instrct = "#{TalentMJ_20210804_04}",icon="set:Talent image:Talent_MJXL", SectName = "#{TalentMJ_20210804_05}",
				[1] = {56},[2] = {229,-1,230}, [3] = {231,232,233}, [4] = {234,-1,235},[5] = {236,237,238}}
	},	

	[2] =
	{
		[1] = {instrct = "#{TalentGB_20210804_02}",icon="set:Talent image:Talent_GBJK", SectName = "#{TalentGB_20210804_03}",
				 [1] = {1}, [2] = {2,-1,3},[3] = {4,5,6},[4] = {7,8,-1}, [5] = {9,10,11}},
		[2] = {instrct = "#{TalentGB_20210804_04}",icon="set:Talent image:Talent_GBXX", SectName = "#{TalentGB_20210804_05}",
				[1] = {12},[2] = {13,-1,14}, [3] = {15,16,17}, [4] = {18,-1,19},[5] = {20,21,22}},
		[3] = {instrct = "#{TalentGB_20210804_02}",icon="set:Talent image:Talent_GBJK", SectName = "#{TalentGB_20210804_03}",
				 [1] = {1}, [2] = {239,-1,240},[3] = {241,242,243},[4] = {244,-1,245}, [5] = {246,247,248}},
		[4] = {instrct = "#{TalentGB_20210804_04}",icon="set:Talent image:Talent_GBXX", SectName = "#{TalentGB_20210804_05}",
				[1] = {12},[2] = {249,-1,250}, [3] = {251,252,253}, [4] = {254,-1,255},[5] = {256,257,258}}
	},
	[3] =
	{
		[1] = {instrct = "#{TalentWD_20210804_02}",icon="set:Talent2 image:Talent_WDPX",SectName = "#{TalentWD_20210804_03}", 
				[1] = {67}, [2] = {68,-1,69},[3] = {70,71,72},[4] = {73,-1,74}, [5] = {75,76,77}},
		[2] = {instrct = "#{TalentWD_20210804_04}",icon="set:Talent2 image:Talent_WDZX", SectName = "#{TalentWD_20210804_05}", 
				[1] = {78},[2] = {79,-1,80}, [3] = {81,82,83}, [4] = {84,-1,85},[5] = {86,87,88}},
		[3] = {instrct = "#{TalentWD_20210804_02}",icon="set:Talent2 image:Talent_WDPX",SectName = "#{TalentWD_20210804_03}", 
				[1] = {67}, [2] = {259,-1,260},[3] = {261,262,263},[4] = {264,-1,265}, [5] = {266,267,268}},
		[4] = {instrct = "#{TalentWD_20210804_04}",icon="set:Talent2 image:Talent_WDZX", SectName = "#{TalentWD_20210804_05}", 
				[1] = {78},[2] = {269,-1,270}, [3] = {271,272,273}, [4] = {274,-1,275},[5] = {276,277,278}}
	},
	[4] =
	{
		[1] = {instrct = "#{TalentEM_20210804_02}",icon="set:Talent image:Talent_EMQF",SectName = "#{TalentEM_20210804_03}",  
					[1] = {89}, [2] = {90,-1,91},[3] = {92,93,94},[4] = {95,96,-1}, [5] = {97,98,99}},
		[2] = {instrct = "#{TalentEM_20210804_04}",icon="set:Talent image:Talent_EMQY", SectName = "#{TalentEM_20210804_05}",  
					[1] = {100},[2] = {101,-1,102}, [3] = {103,104,105}, [4] = {106,-1,107},[5] = {108,109,110}},
		[3] = {instrct = "#{TalentEM_20210804_02}",icon="set:Talent image:Talent_EMQF",SectName = "#{TalentEM_20210804_03}",  
					[1] = {89}, [2] = {279,-1,280},[3] = {281,282,283},[4] = {284,-1,285}, [5] = {286,287,288}},
		[4] = {instrct = "#{TalentEM_20210804_04}",icon="set:Talent image:Talent_EMQY", SectName = "#{TalentEM_20210804_05}",  
					[1] = {100},[2] = {289,-1,290}, [3] = {291,292,293}, [4] = {294,-1,295},[5] = {296,297,298}}
	},
	[5] =
	{
		[1] = {instrct = "#{TalentXX_20210804_02}",icon="set:Talent2 image:Talent_XXHM", SectName = "#{TalentXX_20210804_03}",  
					[1] = {111}, [2] = {112,-1,113},[3] = {114,115,116},[4] = {117,-1,118}, [5] = {119,120,121}},
		[2] = {instrct = "#{TalentXX_20210804_04}",icon="set:Talent2 image:Talent_XXJE", SectName = "#{TalentXX_20210804_05}",  
					[1] = {122},[2] = {123,-1,124}, [3] = {125,126,127}, [4] = {128,-1,129},[5] = {130,131,132}},
		[3] = {instrct = "#{TalentXX_20210804_02}",icon="set:Talent2 image:Talent_XXHM", SectName = "#{TalentXX_20210804_03}",  
					[1] = {111}, [2] = {299,-1,300},[3] = {301,302,303},[4] = {304,-1,305}, [5] = {306,307,308}},
		[4] = {instrct = "#{TalentXX_20210804_04}",icon="set:Talent2 image:Talent_XXJE", SectName = "#{TalentXX_20210804_05}",  
					[1] = {122},[2] = {309,-1,310}, [3] = {311,312,313}, [4] = {314,-1,315},[5] = {316,317,318}}
	},
	[6] =
	{
		[1] = {instrct = "#{TalentTL_20210804_02}",icon="set:Talent image:Talent_TLLW",SectName = "#{TalentTL_20210804_03}",   
					[1] = {133}, [2] = {134,-1,135},[3] = {136,137,138},[4] = {139,-1,140}, [5] = {141,142,143}},
		[2] = {instrct = "#{TalentTL_20210804_04}",icon="set:Talent image:Talent_TLPT", SectName = "#{TalentTL_20210804_05}",   
					[1] = {144},[2] = {145,-1,146}, [3] = {147,148,149}, [4] = {150,-1,151},[5] = {152,153,154}},
		[3] = {instrct = "#{TalentTL_20210804_02}",icon="set:Talent image:Talent_TLLW",SectName = "#{TalentTL_20210804_03}",   
					[1] = {133}, [2] = {319,-1,320},[3] = {321,322,323},[4] = {324,-1,325}, [5] = {326,327,328}},
		[4] = {instrct = "#{TalentTL_20210804_04}",icon="set:Talent image:Talent_TLPT", SectName = "#{TalentTL_20210804_05}",   
					[1] = {144},[2] = {329,-1,330}, [3] = {331,332,333}, [4] = {334,-1,335},[5] = {336,337,338}}
	},
	[7] =
	{
		[1] = {instrct = "#{TalentTS_20210804_02}",icon="set:Talent2 image:Talent_TSNS",  SectName = "#{TalentTS_20210804_03}",   
					 [1] = {155}, [2] = {156,-1,157},[3] = {158,159,160},[4] = {161,-1,162}, [5] = {163,164,165}},
		[2] = {instrct = "#{TalentTS_20210804_04}",icon="set:Talent2 image:Talent_TSXY", SectName = "#{TalentTS_20210804_05}",
						[1] = {166},[2] = {167,-1,168}, [3] = {169,170,171}, [4] = {172,-1,173},[5] = {174,175,176}},
		[3] = {instrct = "#{TalentTS_20210804_02}",icon="set:Talent2 image:Talent_TSNS",  SectName = "#{TalentTS_20210804_03}",   
					 [1] = {155}, [2] = {339,-1,340},[3] = {341,342,343},[4] = {344,-1,345}, [5] = {346,347,348}},
		[4] = {instrct = "#{TalentTS_20210804_04}",icon="set:Talent2 image:Talent_TSXY", SectName = "#{TalentTS_20210804_05}",
						[1] = {166},[2] = {349,-1,350}, [3] = {351,352,353}, [4] = {354,-1,355},[5] = {356,357,358}}
	},
	[8] =
	{
		[1] = {instrct = "#{TalentXY_20210804_02}",icon="set:Talent2 image:Talent_XYYX", SectName = "#{TalentXY_20210804_03}",
					[1] = {177}, [2] = {178,-1,179},[3] = {180,181,182},[4] = {183,-1,184}, [5] = {185,186,187}},
		[2] = {instrct = "#{TalentXY_20210804_04}",icon="set:Talent2 image:Talent_XYMG", SectName = "#{TalentXY_20210804_05}",
					[1] = {188},[2] = {189,-1,190}, [3] = {191,192,193}, [4] = {194,-1,195},[5] = {196,197,198}},
		[3] = {instrct = "#{TalentXY_20210804_02}",icon="set:Talent2 image:Talent_XYYX", SectName = "#{TalentXY_20210804_03}",
					[1] = {177}, [2] = {359,-1,360},[3] = {361,362,363},[4] = {364,-1,365}, [5] = {366,367,368}},
		[4] = {instrct = "#{TalentXY_20210804_04}",icon="set:Talent2 image:Talent_XYMG", SectName = "#{TalentXY_20210804_05}",
					[1] = {188},[2] = {369,-1,370}, [3] = {371,372,373}, [4] = {374,-1,375},[5] = {376,377,378}}
	},
	[10] =
	{
		[1] = {instrct = "#{TalentMT_20220621_04}",icon="set:Talent2 image:Talent_MTWL", SectName = "#{TalentMT_20220621_01}",
					[1] = {379}, [2] = {380,-1,381},[3] = {382,383,384},[4] = {385,-1,386}, [5] = {387,388,389}},
		[2] = {instrct = "#{TalentMT_20220621_05}",icon="set:Talent2 image:Talent_MTZM", SectName = "#{TalentMT_20220621_02}",
					[1] = {390},[2] = {391,-1,392}, [3] = {393,394,395}, [4] = {396,-1,397},[5] = {398,399,400}},
		[3] = {instrct = "#{TalentMT_20220621_04}",icon="set:Talent2 image:Talent_MTWL", SectName = "#{TalentMT_20220621_01}",
					[1] = {379}, [2] = {401,-1,402},[3] = {403,404,405},[4] = {406,-1,407}, [5] = {408,409,410}},
		[4] = {instrct = "#{TalentMT_20220621_05}",icon="set:Talent2 image:Talent_MTZM", SectName = "#{TalentMT_20220621_02}",
					[1] = {390},[2] = {411,-1,412}, [3] = {413,414,415}, [4] = {416,-1,417},[5] = {418,419,420}}
	},

}

local button = {}
function Talent_Preview_PreLoad()

	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("SECT_OPPOSITE",false)
end 

-- Talent_Preview_Close => TLBB_ButtonClose
-- Talent_Preview_Frame_Client => DefaultWindow
-- Talent_Preview_DragTitle => TLBB_DragTitle
-- Talent_Preview_Help => TLBB_ButtonHelp
function Talent_Preview_OnLoad()
	g_Talent_Preview_Frame_UnifiedPosition = Talent_Preview_Frame:GetProperty("UnifiedPosition");

	for i =1, 12 do

		local icon = _G["Talent_Preview_Skill"..i.."Icon"]
		local name = _G["Talent_Preview_Skill"..i.."Name"]

		local all = _G["Talent_Preview_Skill"..i.."Btn"]
		g_Talent_Preview_Item[i] = {icon=icon,name=name,all=all}

	end

	for i=1,9 do
		local light = _G["Talent_Preview_Line"..i.."_2"]
		local dark  = _G["Talent_Preview_Line"..i]

		g_Talent_Preview_Line[i] = { light = light, dark = dark}

	end
	button = {Talent_Preview_SkillTree_LiupaiChange,Talent_Preview_SkillTree_LiupaiChange2}




	g_Talent_Preview_UI[1] = {icon = Talent_Preview_SkillIcon, name = Talent_Preview_SkillName}
	g_Talent_Preview_UI[2] = {[1] = g_Talent_Preview_Item[1], [2] = g_Talent_Preview_Item[2],[3] = g_Talent_Preview_Item[3]}
	g_Talent_Preview_UI[3] = {[1] = g_Talent_Preview_Item[4], [2] = g_Talent_Preview_Item[5],[3] = g_Talent_Preview_Item[6]}
	g_Talent_Preview_UI[4] = {[1] = g_Talent_Preview_Item[7], [2] = g_Talent_Preview_Item[8],[3] = g_Talent_Preview_Item[9]}
	g_Talent_Preview_UI[5] = {[1] = g_Talent_Preview_Item[10], [2] = g_Talent_Preview_Item[11],[3]=g_Talent_Preview_Item[12]}


end


--处理连线
function Talent_Preview_Getline(p1,p2)

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
function Talent_Preview_produceline()
	local coverpos = function(info)
		if info then
			return (info.layer-2)*3+info.col   --(i-2)*3+vi
		end
		return -1
	end
	--local linelist = g_Talent_Studyup_Info[menpai][secttype].line
	for i,v in ipairs(g_Talent_Preview_Line) do

		v.light:Hide()
		v.dark:Hide()
	end

	local linelist = {}

	for i,v in pairs(g_Talent_Preview_StudyTree) do
		local lineid = Talent_Preview_Getline(coverpos(g_Talent_Preview_poslist[v]),coverpos(g_Talent_Preview_poslist[i]))
		if lineid > 0 then
			table.insert(linelist,lineid)
		end
	end
	for j,vj in pairs(linelist) do
		g_Talent_Preview_Line[vj].dark:Show()		
	end	
end
--处理连线end


function Talent_Preview_OnEvent(event)

	if(event == "ADJEST_UI_POS") then
		Talent_Preview_On_ResetPos()
	elseif(event == "VIEW_RESOLUTION_CHANGED") then
		Talent_Preview_On_ResetPos()
	elseif(event == "HIDE_ON_SCENE_TRANSED") then
		Talent_Preview_On_Hide()
	elseif event == "UI_COMMAND" and tonumber(arg0) == 20210801 then
		CloseWindow( "Talent_Studyup" );
		g_Talent_Preview_curFenye = 1
		g_Talent_preview_menpai = Get_XParam_INT(0);
		g_Talent_preview_secttype = Get_XParam_INT(1);
		g_Talent_Preview_LaseFenye = g_Talent_preview_secttype
		local targetobjId = Get_XParam_INT(2);
		g_Talent_preview_targetid = targetobjId
		-- Talent_Preview_InitSect(menpai,secttype)
		Talent_Preview_Update()
		Talent_Preview_BeginCareObject(targetobjId)
		Talent_Preview_SetFenYe(1)
		PushEvent("SECT_OPPOSITE",2)
		this:Show()
	elseif event == "SECT_OPPOSITE" then
		if tonumber(arg0) ~= 2 then
			this:Hide()
		end
	end
end

function Lua_GetSectName(menpai,index)
	return g_Talent_Preview_Info[menpai][index].SectName
end

function Talent_Preview_Update()
	if g_Talent_Preview_curFenye == 1 then
		g_Talent_preview_secttype = g_Talent_Preview_LaseFenye
	elseif g_Talent_Preview_curFenye == 2 then
		g_Talent_preview_secttype = g_Talent_Preview_LaseFenye + 2
	end
	Talent_Preview_InitSect(g_Talent_preview_menpai,g_Talent_preview_secttype)
	Talent_Preview_produceline()
	Talent_Preview_SkillTreeClicked(1,1)
end

function Talent_Preview_InitSect(menpai,secttype)

	Talent_Preview_SkillTree_UpPage:Disable()
	Talent_Preview_SkillTree_DownPage:Disable()
	if secttype == 1 then
		Talent_Preview_SkillTree_LiupaiChange:SetCheck(1)
	elseif secttype == 2 then
		Talent_Preview_SkillTree_LiupaiChange2:SetCheck(1)
	end

	local SetSectcube = function(info,state)
		if state == 0 then
			info.all:Hide()
		else
			info.all:Show()
		end
	end

	-- local SetButtonStr = function(button,index)
		for index = 1,2 do
			local sectname = Lua_GetSectName(menpai,index)
			local str = string.format("流派%s",sectname)
			button[index]:SetText(str)
		end
	-- end


	local list = g_Talent_Preview_Info[menpai][secttype]

	local sectname = Lua_GetSectName(menpai,secttype)
	Talent_Preview_SkillTree_LiuPaiName:SetText(sectname)
	Talent_Preview_SkillTree_LiuPaiDetails:SetText(list.instrct)
	Talent_Preview_SkillTree_LiuPaiIcon:SetProperty( "Image", list.icon )

	if list == nil then
		return
	end

	g_Talent_preview_menpai = menpai
	g_Talent_preview_secttype = secttype

	g_Talent_Preview_StudyTree = {}
	g_Talent_Preview_poslist = {}
	for i,v in ipairs(list) do
		for vi,vv in ipairs(v) do
			--PushDebugMessage("vv="..vv)

			local infodetail;
			local action = nil

			if vv >= 0 then
				infodetail = TBSearch_Index_EQU("DBC_SECT_INFO",vv)	
				action = Lua_CreateSectInfoAction(vv,infodetail.maxlevel);
				action = GemMelting:UpdateProductAction(action)
				--把他的前置条件存一下
				if infodetail.limittype > 0 then
					table.insert(g_Talent_Preview_StudyTree,vv,infodetail.limittype)
				end
				table.insert(g_Talent_Preview_poslist,vv,{layer = i,col = vi})

			end
			if i == 1 then
				--第一层数据少
				if action:GetID() ~= 0 then
					g_Talent_Preview_UI[i].icon:SetActionItem(action:GetID());
				end
				g_Talent_Preview_UI[i].name:SetText(infodetail.szName)
			else
				local uidata = g_Talent_Preview_UI[i][vi];
				if vv < 0 then
					uidata.all:Hide()
				else
					uidata.all:Show()
					uidata.all:SetCheck(0)
					if action:GetID() ~= 0 then
						uidata.icon:SetActionItem(action:GetID());
					end
					uidata.name:SetText(infodetail.szName);


				end

			end
		end
		
	end

	

end




function Talent_Preview_BeginCareObject(objid)
	local nID = DataPool : GetNPCIDByServerID( objid )
	this:CareObject(nID, 1, "Talent_Preview");
end

function Talent_Preview_On_ResetPos()
	Talent_Preview_Frame:SetProperty("UnifiedPosition", g_Talent_Preview_Frame_UnifiedPosition)
end

function Talent_Preview_On_Hide()
	this:Hide()
end

function Talent_Preview_SetFenYe(page)
	local fenyetable = {Talent_Preview_Advance,Talent_Preview_Advance2}
	for i , v in ipairs(fenyetable) do
		if i == page then
			v:SetCheck(1)
		else
			v:SetCheck(0)
		end
	end
end

function Talent_Preview_ChangeFenye(page)
	Talent_Preview_SetFenYe(page)
	g_Talent_Preview_curFenye = page
	Talent_Preview_Update()
end

function Talent_Preview_Help_Click()
end

function Talent_Preview_DetailShow(bshow)
	if bshow == 0 then
		Talent_Preview_Details:Show()
		Talent_Preview_Skillup:Hide()
	else
		Talent_Preview_Details:Hide()
		Talent_Preview_Skillup:Show()
	end
end


function Talent_Preview_SkillTreeClicked(layer,col)
	--他们要是扩了layer记得加上个偏移
	local list = g_Talent_Preview_Info[g_Talent_preview_menpai][g_Talent_preview_secttype]
	local id = list[layer][col];

	if layer == 1 then
		local infodesc = TBSearch_Index_EQU("DBC_SECT_DESC",id)
		local info = TBSearch_Index_EQU("DBC_SECT_INFO",id)
		local action = Lua_CreateSectInfoAction(id,1);
		Talent_Preview_DetailShow(0)
		local color = "#cFFF263"
		Talent_Preview_DetailsName:SetText(info.szName)
		Talent_Preview_Skillup_DetailsText:SetText(color..infodesc.szLevelDesc[1])
		Talent_Preview_SkillBtn:SetCheck(1)
	else
		g_Talent_Preview_UI[layer][col].all:SetCheck(1)
		local infodesc = TBSearch_Index_EQU("DBC_SECT_DESC",id)
		local info = TBSearch_Index_EQU("DBC_SECT_INFO",id)
		local action = Lua_CreateSectInfoAction(id,info.maxlevel);
		Talent_Preview_DetailShow(1)
		Talent_Preview_SkillupName:SetText(info.szName)
		local str = string.format("#cfff263武道等级：%s级",info.maxlevel)
		Talent_Preview_Skilluplevel:SetText(str)
		local strlayer = string.format("武道境界：武道%s重",infodesc.szJingjie)
		Talent_Preview_SkilluplevelRealm:SetText(strlayer)
		local str = string.format("武道等级：%s/%s",info.maxlevel,info.maxlevel)
		Talent_Preview_Skilluplevel:SetText(str)
		local strlayer = string.format("武道境界：武道%s重",infodesc.szJingjie)
		Talent_Preview_SkilluplevelRealm:SetText(strlayer)
		local color = "#cFFF263"
		Talent_Preview_Skillup_Explain1:SetText(color..infodesc.szLevelDesc[info.maxlevel])
	end
end

function Talent_Preview_Close()
	this:Hide()
end


function Talent_Preview_SkillTree_LiupaiChange_Clicked(index)

	if index == g_Talent_preview_secttype then
		return
	end
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "ShowPreview" )
		Set_XSCRIPT_ScriptID(992002)
		Set_XSCRIPT_Parameter( 0, g_Talent_preview_targetid )
		Set_XSCRIPT_Parameter( 1, index )
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()		


end