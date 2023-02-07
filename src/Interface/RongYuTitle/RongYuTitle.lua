-- 宋辽称号领取界面

local g_objCared 		= -1
local g_Title_Index = 0					-- 当前可以领取称号的索引
local g_UI_Title_MAX = 7				-- 目前领取的称号最大数量
local g_UI_Command_ID = 50202301			-- UICommandID
local g_UI_RewardStart = 1				-- 奖励参数的其实位置


local g_TitleID_List = {}				-- 称号列表
local g_RewardType = {}					-- 奖励类型
local g_UI_Name_List = {}				-- list中Item名称
local g_UI_Title_List = {}				-- 下拉列表集合
local g_TitleNeed_List = {}				-- 领取称号对应的消耗
local g_UI_Control_List = {}			-- UI控制界面内容
local g_UI_Command_EventList = {}		-- UICommand

local g_data_list = {}					-- 数据缓存

local g_Frame_UnifiedPosition = nil		-- 分辨率变化跟踪数值

local g_UI_Title_Icon = "set:TaskTools05 image:TaskTools05_2"

function RongYuTitle_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
end

function RongYuTitle_OnLoad()
	g_UI_Control_List = {
		Frame = RongYuTitle_Frame,
		TitleList = RongYuTitleList,
		Desc = RongYuTitle_Hint,
	}

	g_TitleID_List = {
		{49000275,1034,1},{49000276,1035,2},{49000277,1036,3},{49000278,1037,4},{49000279,1038,5},{49000280,1039,6},{49000281,1040,7} 
	}
	g_UI_Name_List = {
		ItemName		= "RongYuTitleItem",		-- 子结构Item名称
		TileName		= "RongYuTitle_Text",		-- 称号名字
		HistoryStr		= "RongYuTitle_Text2",		-- 门派历史贡献
		HistoryNeed		= "RongYuTitle_MenGongNum",	-- 需要额度
		Button			= "RongYuTitle_OKButton",	-- 领取按钮
		Already			= "RongYuTitle_YiWanCheng",		-- 已领取提示
		Icon			= "RongYuTitle_IconBK",		-- actionbutton
		TitleNeed		= 0,
		TitleID			= 0,
		TitleGet                = 0,
		ButtonIndex	        = -1,
	}
	g_UI_Command_EventList = {
		OpenUI = 2,
		RwardReturn = 3,
	}
	g_RewardType = {title=1}--{title=1,fashion=2,mount=3,}
	g_TitleNeed_List ={500,2000,5000,20000,50000,100000,200000}
	g_Frame_UnifiedPosition = g_UI_Control_List.Frame:GetProperty("UnifiedPosition")
end

-- 对传过来的数据进行初始化
local function initdata()
	g_data_list = {}
	for i=1, g_UI_Title_MAX do
		g_data_list[i] = Get_XParam_INT(i+g_UI_RewardStart)
	end

end

-- 刷新传过来的数据
local function updatedata()
	local curidx = Get_XParam_INT(2)
	if curidx > 0 and curidx <= g_UI_Title_MAX then
		g_data_list[curidx] = Get_XParam_INT(3)
	end
	for i=1,g_UI_Title_MAX do
		if g_TitleID_List[curidx][2] ==g_UI_Title_List[i].TitleID then
			g_UI_Title_List[i].TitleGet = Get_XParam_INT(3)
			break
		end
	end

	-- g_UI_Control_List.TitleList = {}
	for i = 1, g_UI_Title_MAX do
		RongYuTitle_AddItem(i)
	end
	-- table.sort(g_UI_Title_List,RongYuTitle_SortID)
	for i = 1, g_UI_Title_MAX do
		RongYuTitle_FreshItem(i)
	end
end

function RongYuTitle_OnEvent(event)
	if event == "UI_COMMAND" and tonumber(arg0) == g_UI_Command_ID then
		RongYuTitle_DragTitle:SetText("#{XSLDZ_180521_225}")
		local eventID = Get_XParam_INT(0)	

		if eventID == g_UI_Command_EventList.OpenUI then
			if not this:IsVisible() then
				initdata()
				RongYuTitle_OnShow()
				RongYuTitle_CareTargetObject(Get_XParam_INT(1))
			end
			
		elseif eventID == g_UI_Command_EventList.RwardReturn then
			if this:IsVisible() then

				updatedata()
				
				for i=1,g_UI_Title_MAX do
					RongYuTitle_RefreshOneTitleInfo(i, i)
				end
			end
		end
	elseif event == "VIEW_RESOLUTION_CHANGED" then
		RongYuTitle_ResetPos()
	elseif event == "ADJEST_UI_POS" then
		RongYuTitle_ResetPos()
	elseif event == "HIDE_ON_SCENE_TRANSED" then
		RongYuTitle_OnClosed()
	end
end

-- 显示界面
function RongYuTitle_OnShow()
	--RongYuTitle_ResetPos()

	RongYuTitle_InitShow()

	RongYuTitle_RefreshInfo()
	this:Show()
	
end

-- 初始化界面信息
function RongYuTitle_InitShow()
	g_UI_Title_List = {}
	-- g_UI_Control_List.TitleList:Clear()
	local titlemax = g_UI_Title_MAX
	for i = 1, titlemax do
		RongYuTitle_AddItem(i)
	end
	table.sort(g_UI_Title_List,RongYuTitle_SortID)
	for i = 1, titlemax do
		RongYuTitle_FreshItem(i)
	end
end

function RongYuTitle_AddItem(i)

	g_UI_Title_List[i] = {}
	g_UI_Title_List[i].TitleID = g_TitleID_List[i][2]
	g_UI_Title_List[i].needhistory = g_TitleNeed_List[i]
	g_UI_Title_List[i].TitleGet = g_data_list[i]
	-- 注册点击事件
	g_UI_Title_List[i].ButtonIndex = i
	g_UI_Title_List[i].itemid = g_TitleID_List[i][1]

end

function RongYuTitle_FreshItem(i)

	-- local titleItem = g_UI_Control_List.TitleList:AddChild(g_UI_Name_List.ItemName)
	-- if titleItem == nil then
		-- return
	-- end
	g_UI_Title_List[i].Item = titleItem
	g_UI_Title_List[i].TitleName = _G[string.format(g_UI_Name_List.TileName.."_"..i)]
	g_UI_Title_List[i].HistoryStr =_G[string.format( g_UI_Name_List.HistoryStr.."_"..i)]
	g_UI_Title_List[i].HistoryNeed = _G[string.format(g_UI_Name_List.HistoryNeed.."_"..i)]
	g_UI_Title_List[i].Button = _G[string.format(g_UI_Name_List.Button.."_"..i)]
	g_UI_Title_List[i].Already = _G[string.format(g_UI_Name_List.Already.."_"..i)]
	g_UI_Title_List[i].Icon = _G[string.format(g_UI_Name_List.Icon.."_"..i)]
	
	local theAction = GemCarve:UpdateProductAction(g_UI_Title_List[i].itemid)
    if theAction:GetID() ~= 0 then
        g_UI_Title_List[i].Icon:SetActionItem(theAction:GetID())
    end

	-- g_UI_Title_List[i].Button:SetEvent( "Clicked", string.format("RongYuTitle_ClickOK(%d)",g_UI_Title_List[i].ButtonIndex))
end

-- 刷新UI内容
function RongYuTitle_RefreshInfo()
	local titlemax = g_UI_Title_MAX

	for i = 1, titlemax do
		RongYuTitle_RefreshOneTitleInfo(i, i)
	end

	local history = DataPool:GetPlayerMission_DataRound(360)

	local str = string.format("历史四象荣誉：%s", tostring(history))

	g_UI_Control_List.Desc:SetText(str)
end

function RongYuTitle_RefreshOneTitleInfo(titleIndex, idx)
	
	local titleItem = g_UI_Title_List[titleIndex]
	if titleItem ~= nil then
		--local data = RongYuTitle_GetDataByIndex(titleIndex)
		local datatype,value,szName,bGet = 1,titleItem.TitleID,"",false --data[1],data[2],"",false

		if datatype == g_RewardType.title then
			szName = LuaFnGetItemName(g_UI_Title_List[titleIndex].itemid)
		else
			return
		end

		local bGet = false
		if titleItem.TitleGet > 0 then
			bGet = true
		else
			bGet = false
		end

		titleItem.TitleName:SetText(szName)
		titleItem.HistoryStr:SetText("#{XSLDZ_180521_227}")
		
		--数值不达标，进行颜色区分
		local szpoint,needhistory = "",titleItem.needhistory
		local history = DataPool:GetPlayerMission_DataRound(360)
		if history >= needhistory then
			szpoint = "#G"..tostring(needhistory)
		else
			szpoint = "#cFF0000"..tostring(needhistory)
		end
		local szNeed = szpoint
		titleItem.HistoryNeed:SetText(szNeed)


		-- 两个UI互斥关系
		if bGet then
			titleItem.Button:Show()
			titleItem.Already:Show()
			titleItem.Button:Disable()
			titleItem.Button:SetText("已领取")
		else
			titleItem.Button:Show()
			titleItem.Already:Hide()
			titleItem.Button:Enable()
			titleItem.Button:SetText("领取")
		end
	end
end

function RongYuTitle_GetDataByIndex(titleIndex)
	return g_TitleID_List[titleIndex]
end

-- 点击领取称号
function RongYuTitle_ClickOK(index)
	if index == nil then
		return
	end
	local item = g_UI_Title_List[index]
	if item == nil then
		return
	end

	local data = RongYuTitle_GetDataByIndex(index)
	if data == nil then
		return
	end

	-- 已经拥有
	local bget = g_data_list[index] > 0
	if bget then
		PushDebugMessage("#{XSLDZ_180521_232}")
		return	
	end

	-- 历史贡献是否足够
	local history = DataPool:GetPlayerMission_DataRound(360)
	if g_TitleNeed_List[index] > history then
		PushDebugMessage("#{XSLDZ_180521_233}")
		return
	end

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("AddTitleRequest")
		Set_XSCRIPT_ScriptID(892335)
		Set_XSCRIPT_Parameter(0, item.ButtonIndex)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
end

function RongYuTitle_Hide()
	RongYuTitle_OnClosed()
end

function RongYuTitle_OnClosed()
	g_objCared = -1
	this:Hide()
end

function RongYuTitle_OnHelp()

end

function RongYuTitle_ResetPos()
	g_UI_Control_List.Frame:SetProperty("UnifiedPosition", g_Frame_UnifiedPosition)
end

function  RongYuTitle_CareTargetObject(ntarget)
	g_objCared = DataPool:GetNPCIDByServerID(tonumber(ntarget))
	this:CareObject(g_objCared, 1, "RongYuTitle")
end

function  RongYuTitle_Help_Click()
	PushEvent("UI_COMMAND", 20211229)
end



--对子类型数据进行排序
function RongYuTitle_SortID(a,b)
	
	local aneedhistory = a.needhistory
	local bneedhistory = b.needhistory

	if a.TitleGet == 0 and b.TitleGet == 1 then
		return true	
	elseif a.TitleGet == 1 and b.TitleGet == 0 then
		return false
	end
	
	if a.needhistory > b.needhistory then
		return false
	elseif  a.needhistory < b.needhistory then	
		return true
	end
	
	return false	
end
