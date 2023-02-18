--[ 创建人 QUFEI 2007-12-15 16:40 UPDATE BugID 26242 ]

local g_HeadGroup_Icon = {}
local g_Headstyle_Icon = {}
local MAX_OBJ_DISTANCE = 3.0;
local g_nCurSelectGrp = 0
local g_Group_Index = {}
local g_Style_Index = {}
local g_Group_Count = 0
local g_Original_Style = 0

-- hjj 2009/08/10
-- 不知道为什么， 虽然在Public/Config/CharHead.txt中，
-- 每个GroupId， 可以拥有多个图片， （按照界面写死了， 应该是不能超过5个）
-- 程序获取方式是， 遍历GroupId,  当第N次遍历到一行记录是GroupId的时候，
-- 则获取到GroupId && Index 的图片。 这有个问题：
-- CharHead.txt讲性别raceId也放到里面去了， 而这个Index是包含性别的，
-- 就是说， 如果Groupid=0, Index=1是男性， 那么女性玩家永远获取不到GroupId, Index=1的信息
-- 即便后来有， 这需要修改代码， 只有性别符合的时候， 才进行 nGroupidx ++;操作。
-- 不过好在txt中， 目前认为虽然拥有这个功能， 但是一个“组”只有一张图片， 不考虑这个因素。
-- 现在需要添加的功能是需要“组”的滚动， 因为快满了， 所以我们在Load的时候， 全部读出来，
-- 然后24分组。
local MAXGROUPSIZE = 24
local g_nCurPage = 1
local g_nAllPage = 1
local g_TotalGroup = 0;
local g_All_Icon = { }

-- chenshengkai 2009/10/22
-- 原objCared变量在多个函数中使用，应该声明为全局变量
local g_objCared = 0

local g_SelectHeadstyle_Frame_UnifiedPosition;

--==================================
-- SelectHeadstyle_PreLoad
--==================================
function SelectHeadstyle_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")

end

--==================================
-- SelectHeadstyle_OnLoad
--==================================
function SelectHeadstyle_OnLoad()

	g_HeadGroup_Icon[1]		= SelectHeadGroup_Skill1_BKG
	g_HeadGroup_Icon[2]		= SelectHeadGroup_Skill2_BKG
	g_HeadGroup_Icon[3]		= SelectHeadGroup_Skill3_BKG
	g_HeadGroup_Icon[4]		= SelectHeadGroup_Skill4_BKG
	g_HeadGroup_Icon[5]		= SelectHeadGroup_Skill5_BKG
	g_HeadGroup_Icon[6]		= SelectHeadGroup_Skill6_BKG
	g_HeadGroup_Icon[7]		= SelectHeadGroup_Skill7_BKG
	g_HeadGroup_Icon[8]		= SelectHeadGroup_Skill8_BKG
	g_HeadGroup_Icon[9]		= SelectHeadGroup_Skill9_BKG
	g_HeadGroup_Icon[10]	= SelectHeadGroup_Skill10_BKG
	g_HeadGroup_Icon[11]	= SelectHeadGroup_Skill11_BKG
	g_HeadGroup_Icon[12]	= SelectHeadGroup_Skill12_BKG
	g_HeadGroup_Icon[13]	= SelectHeadGroup_Skill13_BKG
	g_HeadGroup_Icon[14]	= SelectHeadGroup_Skill14_BKG
	g_HeadGroup_Icon[15]	= SelectHeadGroup_Skill15_BKG
	g_HeadGroup_Icon[16]	= SelectHeadGroup_Skill16_BKG
	g_HeadGroup_Icon[17]	= SelectHeadGroup_Skill17_BKG
	g_HeadGroup_Icon[18]	= SelectHeadGroup_Skill18_BKG
	g_HeadGroup_Icon[19]	= SelectHeadGroup_Skill19_BKG
	g_HeadGroup_Icon[20]	= SelectHeadGroup_Skill20_BKG
	g_HeadGroup_Icon[21]	= SelectHeadGroup_Skill21_BKG
	g_HeadGroup_Icon[22]	= SelectHeadGroup_Skill22_BKG
	g_HeadGroup_Icon[23]	= SelectHeadGroup_Skill23_BKG
	g_HeadGroup_Icon[24]	= SelectHeadGroup_Skill24_BKG

	g_Headstyle_Icon[1]		= SelectHeadstyle_Skill1_BKG
	g_Headstyle_Icon[2] 	= SelectHeadstyle_Skill2_BKG
	g_Headstyle_Icon[3] 	= SelectHeadstyle_Skill3_BKG
	g_Headstyle_Icon[4] 	= SelectHeadstyle_Skill4_BKG
	g_Headstyle_Icon[5] 	= SelectHeadstyle_Skill5_BKG

	local i, j;
	for i=1, 24  do
		g_Group_Index[i] = -1
	end

	for j=1, 5  do
		g_Style_Index[j] = -1
	end

	-- Init All Item from DataPool	--Can't do like this,a bug!!!
--	g_nCurPage = 0;
--
--	j = 1;
--	for i=1, 200 do
--	  local nID,ItemID,ItemCount,SelectType,IconFile,CostMoney,StyleName,TitleInfo;
--		nID,ItemID,ItemCount,SelectType,IconFile,CostMoney,StyleName,TitleInfo = DataPool : Change_MyHeadStyle_Item(i, 0);			-- 获得头像组信息
--		if(ItemID ~= -1) then
--			g_All_Icon[j] = { IconFile = IconFile, StyleName = StyleName, Index = i };
--			j = j+1;
--		end
--	end
--
--	g_TotalGroup = j-1;
--	g_FirstPage = true;
--	if g_TotalGroup > MAXGROUPSIZE then
--		g_LastPage = false;
--	else
--		g_LastPage = true;
--	end

	g_SelectHeadstyle_Frame_UnifiedPosition=SelectHeadstyle_Frame:GetProperty("UnifiedPosition");

end

--==================================
-- SelectHeadstyle_OnEvent
--==================================
function SelectHeadstyle_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == 112730) then
		local xx = Get_XParam_INT(0);
		g_objCared = DataPool : GetNPCIDByServerID(xx);
		if g_objCared == -1 then
				PushDebugMessage("server传过来的数据有问题。");
				return;
		end

		if(IsWindowShow("SelectHairstyle")) then
			CloseWindow("SelectHairstyle", true);
		end

		if(IsWindowShow("SelectHairColor")) then
			CloseWindow("SelectHairColor", true);
		end

		if(IsWindowShow("SelectFacestyle")) then
			CloseWindow("SelectFacestyle", true);
		end

		-- if(this:IsVisible() and tonumber(g_Original_Style)) then
			-- AxTrace(1, 1, "SelectHeadstyle_OnEvent: g_Original_Style="..g_Original_Style)
			-- DataPool : Change_MyHeadStyle(g_Original_Style);
		-- end
		SelectHeadstyle_OnShown()
		BeginCareObject_SelectHeadstyle(g_objCared)

	elseif (event == "OBJECT_CARED_EVENT") then
		if(not this:IsVisible() ) then
			return;
		end
		if(tonumber(arg0) ~= g_objCared) then
			Close_Headstyle()
			return;
		end
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then

			--取消关心
			Close_Headstyle()
		end
		
	elseif (event == "ADJEST_UI_POS" ) then
		SelectHeadstyle_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		SelectHeadstyle_Frame_On_ResetPos()
	end

end

--==================================
-- SelectHeadstyle_OnShown
--==================================
function SelectHeadstyle_OnShown()

	g_nCurPage = 1

	for i,eachGroup in g_HeadGroup_Icon do
		eachGroup : SetPushed(0)
	end

	for j,eachstyle in g_Headstyle_Icon do
		eachstyle : SetPushed(0)
	end

	g_Original_Style = DataPool : Get_MyHeadStyle();

	SelectHeadstyle_Update();
	this:Show();
end

--==================================
-- SelectHeadstyle_Update
--==================================
function SelectHeadstyle_Update()

	local i,j,nID,ItemID,ItemCount,SelectType,IconFile,CostMoney,StyleName,TitleInfo;


	for i,eachGroup in g_HeadGroup_Icon do
		eachGroup : SetPushed(0)
		eachGroup : SetProperty("NormalImage","")
		eachGroup : SetProperty("HoverImage","")
		eachGroup : SetToolTip("")
	end

	for j,eachstyle in g_Headstyle_Icon do
		eachstyle : SetPushed(0)
		eachstyle : SetProperty("NormalImage","")
		eachstyle : SetProperty("HoverImage","")
		eachstyle : SetToolTip("")
	end

	j = 1
	for i=1, 200 do
		nID,ItemID,ItemCount,SelectType,IconFile,CostMoney,StyleName,TitleInfo = DataPool : Change_MyHeadStyle_Item(i, 0);			-- 获得头像组信息
		if(ItemID ~= -1) then
			g_All_Icon[j] = { IconFile = IconFile, StyleName = StyleName, Index = i };
			j = j+1;
		end
	end

	g_TotalGroup = j-1;

	g_nAllPage = math.floor((g_TotalGroup - 1) / MAXGROUPSIZE) + 1

	if g_nCurPage <= 1 then
		g_nCurPage = 1
	elseif g_nCurPage >= g_nAllPage then
		g_nCurPage = g_nAllPage
	end

	if g_nCurPage == g_nAllPage then
		g_Group_Count = g_TotalGroup - (g_nCurPage - 1) * MAXGROUPSIZE
	else
		g_Group_Count = MAXGROUPSIZE
	end

	for i = 1, g_Group_Count do
		local index = (g_nCurPage - 1) * MAXGROUPSIZE + i;
		index = g_TotalGroup - index + 1
		local IccoFile = GetIconFullName(g_All_Icon[index].IconFile);
		g_HeadGroup_Icon[i]:SetProperty("NormalImage", IccoFile)
		g_HeadGroup_Icon[i]:SetProperty("HoverImage", IccoFile)
		g_HeadGroup_Icon[i]:SetToolTip(g_All_Icon[index].StyleName)
		g_HeadGroup_Icon[i]:Show()
		g_Group_Index[i] = g_All_Icon[index].Index;
	end
	for i = g_Group_Count + 1, MAXGROUPSIZE do
		g_HeadGroup_Icon[i]:Hide()
	end

	if g_nCurPage == 1 then
		SelectHeadstyle_PageUp : Disable();
	else
		SelectHeadstyle_PageUp : Enable();
	end

	if g_nCurPage == g_nAllPage then
		SelectHeadstyle_PageDown : Disable();
	else
		SelectHeadstyle_PageDown : Enable();
	end

	if(g_Group_Count <= 0) then
		SelectHeadstyle_Require:SetText("没有可更改的头型。");
		SelectHeadstyle_CurrentlyPage:SetText("1/1");
		SelectHeadstyle_PageUp : Disable();
		SelectHeadstyle_PageDown : Disable();
		SelectHeadstyle_Accept : Disable();
		return;
	end

	g_nCurSelectGrp = 0
	SelectHeadstyle_WarningText : SetText("#{INTERHEAD_XML_002}");
end


--=========================================
--翻页
--=========================================
function SelectHeadstyle_Page(nPage)

	g_nCurPage = g_nCurPage + nPage;

	SelectHeadstyle_Update();

end



--==================================
-- Close_Headstyle
--==================================
function Close_Headstyle()
	g_HaveChange = 0;
	StopCareObject_SelectHeadstyle(g_objCared)
	this:Hide();
end

--==================================
--开始关心NPC，
--==================================
function BeginCareObject_SelectHeadstyle(objCaredId)
	g_Object = objCaredId;
	this:CareObject(g_Object, 1, "SelectHeadstyle");
end

--==================================
--停止对某NPC的关心
--==================================
function StopCareObject_SelectHeadstyle(objCaredId)
	this:CareObject(objCaredId, 0, "SelectHeadstyle");
	g_Object = -1;

end

--==================================
--关闭
--==================================
function SelectHeadstyle_Cancel_Clicked()
	-- AxTrace(1, 1, "SelectHeadstyle_Cancel_Clicked: g_Original_Style="..g_Original_Style)
	-- DataPool : Change_MyHeadStyle(g_Original_Style);
	Close_Headstyle()
	g_nCurSelectGrp = 0
end

--==================================
--确认
--==================================
function SelectHeadstyle_OK_Clicked()

	-- 没有选择头像
	if g_nCurSelectGrp <= 0 then
		PushDebugMessage("#{INTERHEAD_XML_004}");															-- "您没有选择想要更换的头像"
		return 0
	end

	-- 得到选择的头像信息
	local nID,ItemID,ItemCount,SelectType,IconFile,CostMoney,StyleName,_ = DataPool : Change_MyHeadStyle_Item(g_Group_Index[g_nCurSelectGrp], g_Style_Index[1]);

	if(ItemID ~= -1 and SelectType >= 2) then
		if( DataPool:GetPlayerMission_ItemCountNow(ItemID) < ItemCount) then
			PushDebugMessage("#{INTERHEAD_XML_005}");														-- "缺少足够的材料或该材料被锁定。"
			return;
		end
	end

	-- 得到玩家的金币和交子数目
	local nMoney = Player:GetData("MONEY")
	local nMoneyJZ = Player:GetData("MONEY_JZ")

	if (nMoney + nMoneyJZ) < CostMoney then
		PushDebugMessage("#{INTERHEAD_XML_006}");															-- "金钱不足"
		return
	end

	-- 调试信息，当前选择的头像ID
	--PushDebugMessage ("StyleId = "..nID)
	-- 如果选择的头像和当前头像不同
	if nID ~= g_Original_Style then
		g_HaveChange = 1

		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("FinishAdjust");
			Set_XSCRIPT_ScriptID(805030);
			Set_XSCRIPT_Parameter(0, nID);
			Set_XSCRIPT_ParamCount(1);
		Send_XSCRIPT();
		Close_Headstyle();

		g_nCurSelectGrp = 0

	else
		PushDebugMessage("#{INTERHEAD_XML_009}");															-- "请选择一种和你当前不同的头像。"
	end

end

--==================================
--选中一个头像组图标
--==================================
function SelectHeadGroup_Clicked(nGroupidx)

	if nGroupidx > g_Group_Count then
		return 0
	end
	for i,eachstyle in g_Headstyle_Icon do
		eachstyle : SetPushed(0)
		eachstyle : SetProperty("NormalImage","")
		eachstyle : SetProperty("HoverImage","")
		eachstyle : SetToolTip("")
	end

	local n = 1
	-- AxTrace(1, 1, "SelectHeadGroup_Clicked: g_Group_Count="..g_Group_Count)

	if(g_nCurSelectGrp > 0 )then
		g_HeadGroup_Icon[g_nCurSelectGrp]:SetPushed(0);
	end
	g_nCurSelectGrp = nGroupidx
	g_HeadGroup_Icon[g_nCurSelectGrp]:SetPushed(1);

	local nItemIdx = 0
	local nCostMoney = 0
	local GroupName = ""
	for i=1, 5 do
		local nID,ItemID,ItemCount,SelectType,IconFile,CostMoney,StyleName,TitleInfo = DataPool : Change_MyHeadStyle_Item(g_Group_Index[nGroupidx], i-1);
		-- AxTrace(1, 1, "SelectHeadGroup_Clicked: Index="..i.." nID="..nID.." ItemID="..ItemID.." ItemCount="..ItemCount.." SelectType="..SelectType.." IconFile="..IconFile.." CostMoney="..CostMoney.." StyleName="..StyleName.." TitleInfo="..TitleInfo)
		if(ItemID ~= -1) then
			if i == 1 then
				GroupName = TitleInfo
			end
			IconFile = GetIconFullName(IconFile)
			g_Headstyle_Icon[n]:SetProperty("NormalImage",IconFile)
			g_Headstyle_Icon[n]:SetProperty("HoverImage",IconFile)
			g_Headstyle_Icon[n]:SetToolTip(StyleName)
			g_Style_Index[n] = i-1
			n = n + 1
			nItemIdx = ItemID
			nCostMoney = CostMoney
		end
	end

	if nItemIdx <= 0 or nCostMoney <= 0 then
		return 0
	end
	local name,icon = LifeAbility : GetPrescr_Material(nItemIdx);
	SelectHeadstyle_WarningText : SetText("#{INTERHEAD_XML_013}"..GroupName.."#{INTERHEAD_XML_014}"..name.."#{INTERHEAD_XML_015}#{_EXCHG"..nCostMoney.."}#{INTERHEAD_XML_016}");

end

--==================================
--选中一个头像图标
--==================================
--function SelectHeadstyle_Clicked(nIndex)
--
--	AxTrace(1, 1, "SelectHeadstyle_Clicked: g_Style_Count="..g_Style_Count)
--	if nIndex > g_Style_Count  then
--		return
--	end
--	if(g_nCurSelect > 0 )then
--		g_Headstyle_Icon[g_nCurSelect]:SetPushed(0);
--	end
--	g_nCurSelect = nIndex
--	g_Headstyle_Icon[g_nCurSelect]:SetPushed(1);
--
--	local nID,ItemID,ItemCount,SelectType,IconFile,CostMoney,StyleName,_ = DataPool : Change_MyHeadStyle_Item(g_Group_Index[g_nCurSelectGrp], g_Style_Index[nIndex]);
--	AxTrace(1, 1, "SelectHeadstyle_Clicked: nID="..nID.." ItemID="..ItemID.." ItemCount="..ItemCount.." SelectType="..SelectType.." IconFile="..IconFile.." CostMoney="..CostMoney.." StyleName="..StyleName)
--	local name,icon = LifeAbility : GetPrescr_Material(ItemID);
--
--	SelectHeadstyle_WarningText : SetText("需要道具：#G"..name.."#r#W需要金钱：#Y#{_MONEY"..CostMoney.."}#W#r请在画面上方选择头型，然后点击“确定”。");
--
--end

function SelectHeadstyle_Frame_On_ResetPos()
  SelectHeadstyle_Frame:SetProperty("UnifiedPosition", g_SelectHeadstyle_Frame_UnifiedPosition);
end