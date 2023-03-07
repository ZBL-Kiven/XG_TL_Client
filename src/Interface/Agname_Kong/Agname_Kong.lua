--本文件由潇湘解密QQ14993663 
--**--**--**--**--**--**--**--**--
local g_Frame_UnifiedXPosition;
local g_Frame_UnifiedYPosition;
local sceninfog = {}
local sceninfo1 = {}
local sceninfo2 = {}
local sceninfo3 = {}
local sceninfo4 = {}
local sceninfo5 = {}
local List_String = {}
local axiaocs = 1
function Agname_Kong_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
end
function Agname_Kong_()
	Agname_Kong_List:ClearListBox()
	for i = 1, 54 do
		Agname_Kong_List:AddItem(List_String[i], i - 1);
	end
	this:Show()
end
function Agname_Kong_OnEvent(event)
	if (event == "UI_COMMAND" and tonumber(arg0) == 20170503) then
		Agname_Kong_()
		Agname_Kong_Load(1)
	end
	if (event == "PLAYER_LEAVE_WORLD") then
		this:Hide();
	elseif (event == "ADJEST_UI_POS") then
		Agname_Kong_ResetPos()
	end
end
function Agname_Kong_OnLoad()
	List_String[1] = "#G点击下面怪物查看介绍"
	List_String[2] = "#-39#cfff263武夷·#cfff263千年冰魄"
	List_String[3] = "#-39#cfff263草原·#cfff263白启冥"
	List_String[4] = "#-39#cfff263苍山·#cfff263玄击金刚"
	List_String[5] = "#-39#cfff263玄武·#cfff263莽牯朱蛤"
	List_String[6] = "#-38#cfff263古墓1层·#cfff263鬼剑"
	List_String[7] = "#-38#cfff263古墓2层·#cfff263岩魔"
	List_String[8] = "#-38#cfff263古墓3层·#cfff263毒丝蜘蛛王"
	List_String[9] = "#-38#cfff263古墓4层·#cfff263春十三娘"
	List_String[10] = "#-38#cfff263古墓5层·#cfff263伏地魔"
	List_String[11] = "#-38#cfff263古墓6层·#cfff263白帝的阴影"
	List_String[12] = "#-38#cfff263古墓7层·#cfff263冥将"
	List_String[13] = "#-38#cfff263古墓8层·#cfff263血饮狂刀"
	List_String[14] = "#-38#cfff263古墓9层·#cfff263赤霄火魂"
	List_String[15] = "#-40#cfff263地宫1层·#cfff263幽禁守卫"
	List_String[16] = "#-40#cfff263地宫2层·#cfff263幽灵祭祀"
	List_String[17] = "#-40#cfff263地宫3层·#cfff263秦皇之魄"
	List_String[18] = "#-41#cfff263藏宝图·#cfff263夺宝马贼"
	List_String[19] = "#-41#cfff263宝藏洞·#cfff263护宝神兽"
	List_String[20] = "#-41#cfff263玄武岛·#cfff263护岛神兽"
	List_String[21] = "#-41#cfff263圣兽山·#cfff263千年龙龟"
	List_String[22] = "#-42#cfff263银铠雪原·#cfff263企鹅王"
	List_String[23] = "#-42#cfff263摩崖洞·#cfff263工魂影像"
	List_String[24] = "#-42#cfff263宝藏洞·#cfff263木桶伯"
	List_String[25] = "#-42#cfff263束河古镇·#cfff263霜影"
	List_String[26] = "#-43#cfff263副本：造反恶贼"
	List_String[27] = "#-43#cfff263副本：偷袭门派"
	List_String[28] = "#-43#cfff263副本：老三环"
	List_String[29] = "#-43#cfff263副本：新三环"
	List_String[30] = "#-43#cfff263副本：缥缈峰"
	List_String[31] = "#-43#cfff263副本：四绝庄"
	List_String[32] = "#-43#cfff263副本：兵圣奇袭"
	List_String[33] = "#-43#cfff263副本：十二杀星"
	
	List_String[34] = "#-44#cfff263无量山猴王"
	List_String[35] = "#-45#cfff263敦煌兵佣"
	List_String[36] = "#-45#cfff263嵩山木人"
	List_String[37] = "#-46#cfff263雁北恶豹"
	List_String[38] = "#-46#cfff263西湖花妖"
	List_String[39] = "#-40#cfff263玉溪石人"
	List_String[40] = "#-41#cfff263梅岭土著"
	List_String[41] = "#-41#cfff263辽西悍匪"
	List_String[42] = "#-42#cfff263琼州鳄鱼"
	List_String[43] = "#-42#cfff263南海恶霸"
	
	sceninfo1 = {
		{ str = "大理", Num = Agname_Kong_goto1 },
		{ str = "洛阳校场", Num = Agname_Kong_goto2 },
		{ str = "九州商会", Num = Agname_Kong_goto3 },
		{ str = "苏州", Num = Agname_Kong_goto4 },
		{ str = "苏州铁匠铺", Num = Agname_Kong_goto5 },
		{ str = "神器进阶", Num = Agname_Kong_goto6 },
		{ str = "武魂幻化", Num = Agname_Kong_goto7 },
		{ str = "修炼境界", Num = Agname_Kong_goto8 },
		{ str = "雕纹系统", Num = Agname_Kong_goto9 },
		{ str = "染色点缀", Num = Agname_Kong_goto10 },
		{ str = "星宿", Num = Agname_Kong_goto11 },
		{ str = "逍遥", Num = Agname_Kong_goto12 },
		{ str = "少林", Num = Agname_Kong_goto13 },
		{ str = "天山", Num = Agname_Kong_goto14 },
		{ str = "天龙", Num = Agname_Kong_goto15 },
		{ str = "峨嵋", Num = Agname_Kong_goto16 },
		{ str = "武当", Num = Agname_Kong_goto17 },
		{ str = "明教", Num = Agname_Kong_goto18 },
		{ str = "丐帮", Num = Agname_Kong_goto19 },
		{ str = "曼陀山庄", Num = Agname_Kong_goto20 },
		{ str = "↓快速升级↓", Num = Agname_Kong_goto21 },
		{ str = "宝 藏 洞", Num = Agname_Kong_goto26 },
		{ str = "摩 崖 洞", Num = Agname_Kong_goto27 },
		{ str = "古 墓 一", Num = Agname_Kong_goto28 },
		{ str = "地 宫 三", Num = Agname_Kong_goto29 },
		{ str = "塔克拉玛干", Num = Agname_Kong_goto30 },
		
	}
	
	sceninfo2 = {
		{ str = "洱海", Num = Agname_Kong_goto1 },
		{ str = "西湖", Num = Agname_Kong_goto2 },
		{ str = "龙泉", Num = Agname_Kong_goto3 },
		{ str = "雁南", Num = Agname_Kong_goto4 },
		{ str = "雁北", Num = Agname_Kong_goto5 },
		{ str = "苍山", Num = Agname_Kong_goto6 },
		{ str = "石林", Num = Agname_Kong_goto7 },
		{ str = "草原", Num = Agname_Kong_goto8 },
		{ str = "梅岭", Num = Agname_Kong_goto9 },
		{ str = "辽西", Num = Agname_Kong_goto10 },
		{ str = "玉溪", Num = Agname_Kong_goto11 },
		{ str = "南海", Num = Agname_Kong_goto12 },
		{ str = "南诏", Num = Agname_Kong_goto13 },
		{ str = "苗疆", Num = Agname_Kong_goto14 },
		{ str = "琼州", Num = Agname_Kong_goto15 },
		{ str = "长白山", Num = Agname_Kong_goto16 },
		{ str = "黄龙洞", Num = Agname_Kong_goto17 },
	}
	
	sceninfo3 = {
		{ str = "木桶伯", Num = Agname_Kong_goto1 },
		{ str = "工魂影像", Num = Agname_Kong_goto2 },
		{ str = "地宫秦皇", Num = Agname_Kong_goto3 },
		{ str = "企鹅王", Num = Agname_Kong_goto4 },
		{ str = "圣兽宝箱", Num = Agname_Kong_goto5 },
		{ str = "武夷冰妖", Num = Agname_Kong_goto6 },
		{ str = "玄武蛤蟆", Num = Agname_Kong_goto7 },
		{ str = "苍山金刚", Num = Agname_Kong_goto8 },
		{ str = "草原小白", Num = Agname_Kong_goto9 },
		{ str = "圣兽龙龟", Num = Agname_Kong_goto10 },
		{ str = "#G束河BOOS", Num = Agname_Kong_goto11 },
		{ str = "#G镜湖群雄", Num = Agname_Kong_goto12 },
		{ str = "辽西马贼", Num = Agname_Kong_goto13 },
		{ str = "苗疆马贼", Num = Agname_Kong_goto14 },
		{ str = "南海马贼", Num = Agname_Kong_goto15 },
		{ str = "黄龙府马贼", Num = Agname_Kong_goto16 },
	}
	
	sceninfo4 = {
		{ str = "老三环", Num = Agname_Kong_goto1 },
		{ str = "新三环", Num = Agname_Kong_goto2 },
		{ str = "燕子坞", Num = Agname_Kong_goto3 },
		{ str = "缥缈峰", Num = Agname_Kong_goto4 },
		{ str = "十二杀星", Num = Agname_Kong_goto5 },
		{ str = "水月山庄", Num = Agname_Kong_goto6 },
		{ str = "百变脸谱", Num = Agname_Kong_goto7 },
		{ str = "爱心救助", Num = Agname_Kong_goto8 },
		{ str = "幸运快活三", Num = Agname_Kong_goto9 },
		{ str = "青丘试炼", Num = Agname_Kong_goto11 },
		{ str = "雁门论武", Num = Agname_Kong_goto12 },
		{ str = "兵行四象", Num = Agname_Kong_goto13 },
	}
	
	sceninfo5 = {
		{ str = "无量山", Num = Agname_Kong_goto1 },
		{ str = "敦煌", Num = Agname_Kong_goto2 },
		{ str = "嵩山", Num = Agname_Kong_goto3 },
		{ str = "雁北", Num = Agname_Kong_goto6 },
		{ str = "西湖", Num = Agname_Kong_goto7 },
		{ str = "玉溪", Num = Agname_Kong_goto8 },
		{ str = "梅岭", Num = Agname_Kong_goto11 },
		{ str = "辽西", Num = Agname_Kong_goto12 },
		{ str = "琼州", Num = Agname_Kong_goto13 },
		{ str = "南海", Num = Agname_Kong_goto14 },
		{ str = "木桶伯", Num = Agname_Kong_goto21 },
		{ str = "工魂影像", Num = Agname_Kong_goto22 },
		{ str = "地宫秦皇", Num = Agname_Kong_goto23 },
		{ str = "企鹅王", Num = Agname_Kong_goto24 },
		{ str = "圣兽宝箱", Num = Agname_Kong_goto25 },
		{ str = "武夷冰妖", Num = Agname_Kong_goto26 },
		{ str = "玄武蛤蟆", Num = Agname_Kong_goto27 },
		{ str = "苍山金刚", Num = Agname_Kong_goto28 },
		{ str = "草原小白", Num = Agname_Kong_goto29 },
		{ str = "圣兽龙龟", Num = Agname_Kong_goto30 },
	}
	sceninfog[1] = Agname_Kong_goto1
	sceninfog[2] = Agname_Kong_goto2
	sceninfog[3] = Agname_Kong_goto3
	sceninfog[4] = Agname_Kong_goto4
	sceninfog[5] = Agname_Kong_goto5
	sceninfog[6] = Agname_Kong_goto6
	sceninfog[7] = Agname_Kong_goto7
	sceninfog[8] = Agname_Kong_goto8
	sceninfog[9] = Agname_Kong_goto9
	sceninfog[10] = Agname_Kong_goto10
	sceninfog[11] = Agname_Kong_goto11
	sceninfog[12] = Agname_Kong_goto12
	sceninfog[13] = Agname_Kong_goto13
	sceninfog[14] = Agname_Kong_goto14
	sceninfog[15] = Agname_Kong_goto15
	sceninfog[16] = Agname_Kong_goto16
	sceninfog[17] = Agname_Kong_goto17
	sceninfog[18] = Agname_Kong_goto18
	sceninfog[19] = Agname_Kong_goto19
	sceninfog[20] = Agname_Kong_goto20
	sceninfog[21] = Agname_Kong_goto21
	sceninfog[22] = Agname_Kong_goto22
	sceninfog[23] = Agname_Kong_goto23
	sceninfog[24] = Agname_Kong_goto24
	sceninfog[25] = Agname_Kong_goto25
	sceninfog[26] = Agname_Kong_goto26
	sceninfog[27] = Agname_Kong_goto27
	sceninfog[28] = Agname_Kong_goto28
	sceninfog[29] = Agname_Kong_goto29
	sceninfog[30] = Agname_Kong_goto30
	
	g_Frame_UnifiedXPosition = Agname_Kong_Frame:GetProperty("UnifiedXPosition");
	g_Frame_UnifiedYPosition = Agname_Kong_Frame:GetProperty("UnifiedYPosition");
end

function Agname_Kong_List_Selected()
	local nSelIndex = Agname_Kong_List:GetFirstSelectItem();
	if nSelIndex == -1 then
		return
	end
	if nSelIndex == 1 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3000);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27掉落物品：元宝票1000,魂冰珠,润魂石,三级手工材料,功力丹,低级宝石合成,门派技能书,四级宝石,长生草！#r#-23刷新时间：同步官方")
	end
	if nSelIndex == 2 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3001);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27掉落物品：元宝票1000,魂冰珠,润魂石,三级手工材料,功力丹,低级宝石合成,门派技能书,四级宝石,长生草！#r#-23刷新时间：同步官方")
	end
	if nSelIndex == 3 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3002);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27掉落物品：元宝票1000,魂冰珠,润魂石,三级手工材料,功力丹,低级宝石合成,门派技能书,四级宝石,长生草！#r#-23刷新时间：同步官方")
	end
	if nSelIndex == 4 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3003);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27掉落物品：元宝票1000,魂冰珠,润魂石,三级手工材料,功力丹,低级宝石合成,门派技能书,四级宝石,长生草！#r#-23刷新时间：同步官方")
	end
	
	if nSelIndex == 5 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3004);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27掉落物品：元宝票600,四级宝石,金蚕丝,长生草！#r#-23刷新时间：同步官方")
	end
	if nSelIndex == 6 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3005);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27掉落物品：元宝票600,四级宝石,金蚕丝,长生草！#r#-23刷新时间：同步官方")
	end
	if nSelIndex == 7 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3006);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27掉落物品：元宝票600,四级宝石,金蚕丝,长生草！#r#-23刷新时间：同步官方")
	end
	if nSelIndex == 8 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3007);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27掉落物品：元宝票600,四级宝石,金蚕丝,长生草！#r#-23刷新时间：同步官方")
	end
	if nSelIndex == 9 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3008);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27掉落物品：元宝票600,四级宝石,金蚕丝,长生草！#r#-23刷新时间：同步官方")
	end
	if nSelIndex == 10 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3009);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27掉落物品：元宝票600,四级宝石,金蚕丝,长生草！#r#-23刷新时间：同步官方")
	end
	if nSelIndex == 11 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3010);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27掉落物品：元宝票600,四级宝石,金蚕丝,长生草！#r#-23刷新时间：同步官方")
	end
	if nSelIndex == 12 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3011);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27掉落物品：元宝票600,四级宝石,金蚕丝,长生草！#r#-23刷新时间：同步官方")
	end
	if nSelIndex == 13 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3012);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27掉落物品：元宝票600,四级宝石,金蚕丝,长生草！#r#-23刷新时间：同步官方")
	end
	if nSelIndex == 14 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3013);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27掉落物品：元宝票1000,三级手工材料,金蚕丝,长生草！#r#-23刷新时间：同步官方")
	end
	if nSelIndex == 15 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3014);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27掉落物品：元宝票1000,三级手工材料,金蚕丝,长生草！#r#-23刷新时间：同步官方")
	end
	if nSelIndex == 16 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3015);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27掉落物品：元宝票1000,三级手工材料,金蚕丝,长生草！#r#-23刷新时间：同步官方")
	end
	if nSelIndex == 17 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3016);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27掉落物品：高额元宝票，金蚕丝，合成符,长生草,功力丹！#r#-23刷新时间：藏宝图触发活动开启")
	end
	if nSelIndex == 18 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3017);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27掉落物品：200元宝票，金蚕丝，合成符,长生草！#r#-23刷新时间：同步官方")
	end
	if nSelIndex == 19 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3018);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27掉落物品：灵兽丹,根骨丹,长生草！#r#-23刷新时间：同步官方")
	end
	if nSelIndex == 20 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3019);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27掉落物品：元宝票5000,五级宝石,回天神石,缀梦灵石,附体技能书,金蚕丝,长生草！#r#-23刷新时间：同步官方")
	end
	if nSelIndex == 21 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3020);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27掉落物品：元宝票2000,三级手工材料,根骨丹,天罡强化露,回天神石,超级珍兽还童天书,金蚕丝,长生草！#r#-23刷新时间：同步官方")
	end
	
	if nSelIndex == 22 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3021);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27掉落物品：元宝票1000,天罡强化露,三级手工材料,金蚕丝,长生草！#r#-23刷新时间：同步官方")
	end
	if nSelIndex == 23 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3023);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27掉落物品：元宝票1000,天罡强化露,二级手工材料,天龙代金卡,金蚕丝,长生草！#r#-23刷新时间：同步官方")
	end
	if nSelIndex == 24 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3022);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27掉落物品：元宝票400,三级手工材料,重楼材料,金蚕丝,长生草！#r#-23刷新时间：同步官方")
	end
	if nSelIndex == 25 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3024);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27掉落物品：元宝票600,愿灵泉,破天箭,三级手工材料,四级宝石,长生草！#r#-23刷新时间：同步官方")
	end
	if nSelIndex == 26 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3025);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27掉落物品：元宝票600,门派技能书,三级手工材料,四级宝石,长生草！#r#-23刷新时间：同步官方")
	end
	if nSelIndex == 27 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3026);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27掉落物品：元宝票600,四级宝石,武魂,三级手工材料,长生草！#r#-23刷新时间：每天副本5次")
	end
	if nSelIndex == 28 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3027);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27掉落物品：元宝票600,四级宝石,武魂,玄昊玉,回天神石,三级手工材料,长生草！#r#-23刷新时间：每天副本3次")
	end
	if nSelIndex == 29 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3028);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27掉落物品：大票,李秋水必掉重楼材料,元宝票800,四级宝石,三级手工材料,千淬神玉,忘无石,新莽神符,长生草！#r#-23刷新时间：每天副本2次")
	end
	if nSelIndex == 30 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3029);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27掉落物品：副本待添加！#r#-23刷新时间：每天副本3次")
	end
	if nSelIndex == 31 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3030);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27掉落物品：副本待添加！#r#-23刷新时间：每天副本1次")
	end
	if nSelIndex == 32 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3031);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27掉落物品：三级手工材料,功力丹,元宝票400,四级宝石,金蚕丝,长生草！#r#-23刷新时间：每天副本3次")
	end
	
	if nSelIndex == 33 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3032);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27掉落物品：F1,元宝票400,三级手工材料,四级宝石,灵魂碎片,金蚕丝,长生草！#r#-23刷新时间：每小时整点分时自动刷新，每天共刷24波")
	end
	if nSelIndex == 34 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3033);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27掉落物品：F2,元宝票400,三级手工材料,四级宝石,灵魂碎片,金蚕丝,长生草！#r#-23刷新时间：每小时5分时自动刷新，每天共刷24波")
	end
	if nSelIndex == 35 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3035);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27掉落物品：F3,元宝票600,三级手工材料,四级宝石,灵魂碎片,金蚕丝,长生草！#r#-23刷新时间：每小时10分时自动刷新，每天共刷24波")
	end
	if nSelIndex == 36 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3036);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27掉落物品：F3,元宝票600,三级手工材料,四级宝石,灵魂碎片,金蚕丝,长生草！#r#-23刷新时间：每小时15分时自动刷新，每天共刷24波")
	end
	
	if nSelIndex == 37 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3038);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27掉落物品：F4,元宝票800,四级宝石,灵魂碎片,金蚕丝,长生草！#r#-23刷新时间：每小时25分时自动刷新，每天共刷24波")
	end
	
	if nSelIndex == 38 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3040);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27掉落物品：F4,元宝票800,四级宝石,灵魂碎片,金蚕丝,长生草！#r#-23刷新时间：每小时35分时自动刷新，每天共刷24波")
	end
	
	if nSelIndex == 39 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3042);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27掉落物品：F5,元宝票1000,三级手工材料,四级宝石,灵魂碎片,金蚕丝,长生草！#r#-23刷新时间：每小时45分时自动刷新，每天共刷24波")
	end
	if nSelIndex == 40 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3046);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27掉落物品：F5,元宝票1000,三级手工材料,四级宝石,灵魂碎片,金蚕丝,长生草！#r#-23刷新时间：每小时55分时自动刷新，每天共刷24波")
	end
	if nSelIndex == 41 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3048);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27掉落物品：F7,元宝票2000,三级手工材料,武魂,15朵玫瑰,功力丹,门派80技能书,紫金石,金蚕丝,长生草！#r#-23刷新时间：每天每小时双数30分刷新，每天共刷12波")
	end
	if nSelIndex == 42 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3051);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27掉落物品：F6,元宝票2000,三级手工材料,武魂,15朵玫瑰,功力丹,门派80技能书,点金玉,金蚕丝,长生草！#r#-23刷新时间：每天每小时单数30分刷新，每天共刷12波")
	end
	if nSelIndex == 43 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3052);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27掉落物品：F7,元宝票2000,三级手工材料,武魂,15朵玫瑰,功力丹,门派80技能书,紫金石,金蚕丝,长生草！#r#-23刷新时间：每隔2小时自动刷新，每天共刷12波")
	end

end

function Agname_Kong_Close()
	Agname_Kong_MeshW:SetFakeObject("");
	this:Hide();
end
function Agname_Kong_ResetPos()
	Agname_Kong_Frame:SetProperty("UnifiedXPosition", g_Frame_UnifiedXPosition);
	Agname_Kong_Frame:SetProperty("UnifiedYPosition", g_Frame_UnifiedYPosition);
end
function Agname_Kong_Clicked(index)
	if index > 30 and index < 1 then
		return
	end
	Clear_XSCRIPT()
	Set_XSCRIPT_Function_Name("Scripttransitcenter");
	Set_XSCRIPT_ScriptID(990010);
	Set_XSCRIPT_Parameter(0, 9);
	Set_XSCRIPT_Parameter(1, tonumber(axiaocs));
	Set_XSCRIPT_Parameter(2, tonumber(index));
	Set_XSCRIPT_ParamCount(3);
	Send_XSCRIPT()
end

function Agname_Kong_Load(index)
	if index < 7 and index > 0 then
		axiaocs = index
		local nchuansong = 0
		for i = 1, 30 do
			sceninfog[i]:Hide();
		end
		if index == 1 then
			Agname_Kong_Client:Show()
			Agname_Kong_Client2:Hide()
			for i, j in ipairs(sceninfo1) do
				j.Num:Show()
				j.Num:SetText(j.str)
				nchuansong = nchuansong + 1
			end
		elseif index == 2 then
			Agname_Kong_Client:Show()
			Agname_Kong_Client2:Hide()
			for i, j in ipairs(sceninfo2) do
				j.Num:Show()
				j.Num:SetText(j.str)
				nchuansong = nchuansong + 1
			end
		elseif index == 3 then
			Agname_Kong_Client:Show()
			Agname_Kong_Client2:Hide()
			for i, j in ipairs(sceninfo3) do
				j.Num:Show()
				j.Num:SetText(j.str)
				nchuansong = nchuansong + 1
			end
		elseif index == 4 then
			Agname_Kong_Client:Show()
			Agname_Kong_Client2:Hide()
			for i, j in ipairs(sceninfo4) do
				j.Num:Show()
				j.Num:SetText(j.str)
				nchuansong = nchuansong + 1
			end
		
		elseif index == 5 then
			Agname_Kong_Client:Show()
			Agname_Kong_Client2:Hide()
			for i, j in ipairs(sceninfo5) do
				j.Num:Show()
				j.Num:SetText(j.str)
				nchuansong = nchuansong + 1
			end
		
		elseif index == 6 then
			Agname_Kong_Client:Hide()
			Agname_Kong_Client2:Show()
		end
	end
end