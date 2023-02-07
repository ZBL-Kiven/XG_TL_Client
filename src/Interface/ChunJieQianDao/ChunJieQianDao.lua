--2022Q1春节日历
local g_Frame_UnifiedPosition = nil
local g_ExeScript = 892975
local g_UICOMMAND = 89297501
-----------------------
local g_BitNum = 28
--0~10位 迎春日历 每日勾画
--11位 今日是否勾画了
--12~25位 新春日历 每日签到
--26位 新春日历 每日补签
--27位 春节毛笔
local g_BitTable = {}
local g_Index_YingChunFlag_Begin = 1
--local g_Index_YingChunFlag_End = 11
local g_Index_TodayFlag = 12
local g_Index_XinChunFlag_Begin = 13
--local g_Index_XinChunFlag_End = 26
local g_Index_ResignFlag = 27
local g_Index_BrushPenFlag = 28
--------------------------
local g_UI_Items = {}
local g_YCItemsNum = 11
local g_XCItemsNum = 14
local g_curPage = 0

local g_showItem = {
	[1] = {
		[1] = {itemID=30900045,num=1},
		[2] = {itemID=38002494,num=1},
		[3] = {itemID=30008048,num=1},
		[4] = {itemID=30503133,num=4},
		[5] = {itemID=20800013,num=8},
		[6] = {itemID=30501361,num=4},
		[7] = {itemID=30503140,num=5},
		[8] = {itemID=30502002,num=15},
		[9] = {itemID=30008114,num=1},
		[10] = {itemID=30008027,num=5},
		[11] = {itemID=50313004,num=1},
	},
	[2] = {
		[1] = {itemID=10124614,num=1},
		[2] = {itemID=38002168,num=1},
		[3] = {itemID=20800013,num=10},
		[4] = {itemID=20501003,num=1},
		[5] = {itemID=10142007,num=1},
		[6] = {itemID=20502003,num=1},
		[7] = {itemID=50413004,num=1},
		[8] = {itemID=20310168,num=20},
		[9] = {itemID=30503020,num=2},
		[10] = {itemID=30700241,num=4},
		[11] = {itemID=38002221,num=1},
		[12] = {itemID=20310116,num=8},
		[13] = {itemID=20502004,num=1},
		[14] = {itemID=20501004,num=1},
	},
}

function ChunJieQianDao_PreLoad()
	this:RegisterEvent("UI_COMMAND", true)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
    this:RegisterEvent("ADJEST_UI_POS",false)
    this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
end

function ChunJieQianDao_OnLoad()
    g_Frame_UnifiedPosition = ChunJieQianDao_Frame:GetProperty("UnifiedPosition")
    g_UI_Items.pageTagBtn1 = ChunJieQianDao_Page1_Btn
    g_UI_Items.pageTagBtn2 = ChunJieQianDao_Page2_Btn
    g_UI_Items.pageTagBtn1Tips = ChunJieQianDao_Page1_Btn_Tips
    g_UI_Items.pageTagBtn2Tips = ChunJieQianDao_Page2_Btn_Tips
    g_UI_Items.page1 = ChunJieQianDao_Page1
    g_UI_Items.page2 = ChunJieQianDao_Page2
    g_UI_Items.page1Items = {}
    g_UI_Items.page1Items.YCItems = {}
    for i=1,g_YCItemsNum do
        g_UI_Items.page1Items.YCItems[i] = {
            --bk = _G[string.format( "ChunJieQianDao_Item%d_BK",i)],
            btn = _G["ChunJieQianDao_Item"..i],
            anim = _G[string.format( "ChunJieQianDao_Item%d_Animate",i)],
            got = _G[string.format( "ChunJieQianDao_Item%d_Get",i)],
        }
    end
    g_UI_Items.page1Items.actNum = ChunJieQianDao_TextNum
    g_UI_Items.page1Items.coinBtn = ChunJieQianDao_Down_Item
    g_UI_Items.page1Items.coinAnim = ChunJieQianDao_Down_ItemAnimate
    g_UI_Items.page1Items.coinGot = ChunJieQianDao_Down_Item_Get
    g_UI_Items.page1Items.brushPen = {H=ChunJieQianDao_TextNum_Icon_H,D=ChunJieQianDao_TextNum_Icon_D}
    g_UI_Items.page1Items.actBtn = ChunJieQianDao_Get_Btn
    g_UI_Items.page1Items.actBtnTips = ChunJieQianDao_Get_Btn_Tips

    g_UI_Items.page2Items = {}
    g_UI_Items.page2Items.XCItems = {}
    for i=1,g_XCItemsNum do
        g_UI_Items.page2Items.XCItems[i] = {
            --bk = _G[string.format( "ChunJieQianDao_Item%d_BK",i)],
            btn = _G["ChunJieQianDao_Page2_Item"..i],
            anim = _G[string.format( "ChunJieQianDao_Page2_Item%d_Animate",i)],
            got = _G[string.format( "ChunJieQianDao_Page2_Item%d_Get",i)],
            repair = _G[string.format( "ChunJieQianDao_Page2_Item%d_Repair",i)],
        }
    end
    g_UI_Items.page2Items.resignNum = ChunJieQianDao_Page2_TextNum
    g_UI_Items.page2Items.resignBtn = ChunJieQianDao_Page2_Btn1
    g_UI_Items.page2Items.resignBtnTips = ChunJieQianDao_Page2_Btn1_Tips
    g_UI_Items.page2Items.signBtn = ChunJieQianDao_Page2_Btn2
    g_UI_Items.page2Items.signBtnTips = ChunJieQianDao_Page2_Btn2_Tips

end

function ChunJieQianDao_OnEvent(event)
    if event == "UI_COMMAND" and tonumber(arg0) == g_UICOMMAND then
        local nOpt = Get_XParam_INT(0)
        if nOpt == 1 then
            --打开界面1
            ChunJieQianDao_OpenUI1()
        elseif nOpt == 2 then
            ChunJieQianDao_OpenUI2()
        elseif nOpt == 3 then
            --刷新界面1
            if ChunJieQianDao_Frame:IsVisible() then	
                ChunJieQianDao_OpenUI1()
            end
        elseif nOpt == 4 then
            --刷新界面2
            if ChunJieQianDao_Frame:IsVisible() then	
                ChunJieQianDao_OpenUI2()
            end
        end

	elseif event == "VIEW_RESOLUTION_CHANGED" or event=="ADJEST_UI_POS" then
        ChunJieQianDao_On_ResetPos()
    elseif event == "HIDE_ON_SCENE_TRANSED" then
		ChunJieQianDao_OnClose()
	end

end

function ChunJieQianDao_OpenUI1()
    ChunJieQianDao_SetBitTable(Get_XParam_INT(1))
    local dayIndex = Get_XParam_INT(2)
    local showOtherTips = Get_XParam_INT(3)
    --items
    if dayIndex < 0  or dayIndex > g_YCItemsNum then
        return 
    end
    this:Show()
    g_curPage = 1
    g_UI_Items.page1:Show()
    g_UI_Items.page2:Hide()
    g_UI_Items.pageTagBtn1:SetCheck(1)
    g_UI_Items.pageTagBtn2:SetCheck(0)
    local page1Tips = 0
    --勾画次数
    --local MarkTimes = 0

    for i=1,g_YCItemsNum do
        --设置ACTIONITEM
        local theAction = DataPool:CreateBindActionItemForShow(g_showItem[1][i].itemID,g_showItem[1][i].num)
        if theAction:GetID() ~= 0 then
            g_UI_Items.page1Items.YCItems[i].btn:SetActionItem(theAction:GetID())
        end
        local state = g_BitTable[g_Index_YingChunFlag_Begin+i-1]
        if i < dayIndex or dayIndex == 0 then
            --前面几天的item
            if state == 1 then
                g_UI_Items.page1Items.YCItems[i].got:Show()
                --MarkTimes = MarkTimes +1
            else
                g_UI_Items.page1Items.YCItems[i].got:Hide()
            end
            g_UI_Items.page1Items.YCItems[i].anim:Hide()
        elseif i == dayIndex then
            --当天的item
            if state == 1 then
                g_UI_Items.page1Items.YCItems[i].got:Show()
                g_UI_Items.page1Items.YCItems[i].anim:Hide()
                --MarkTimes = MarkTimes +1
            else
                g_UI_Items.page1Items.YCItems[i].got:Hide()
                if g_BitTable[g_Index_BrushPenFlag] == 1 then
                    g_UI_Items.page1Items.YCItems[i].anim:Show()
                else
                    g_UI_Items.page1Items.YCItems[i].anim:Hide()
                end
            end
            
        else
            --后面几天的item
            g_UI_Items.page1Items.YCItems[i].anim:Hide()
            g_UI_Items.page1Items.YCItems[i].got:Hide()
        end
    end
    
    local theAction = DataPool:CreateBindActionItemForShow(38000127,1)
    if theAction:GetID() ~= 0 then
        g_UI_Items.page1Items.coinBtn:SetActionItem(theAction:GetID())
    end
    g_UI_Items.page1Items.coinAnim:Hide()
    if g_BitTable[g_Index_YingChunFlag_Begin+6] == 1 then
        --第7天 领了硬币
        g_UI_Items.page1Items.coinGot:Show()
    else
        g_UI_Items.page1Items.coinGot:Hide()
        if dayIndex == 7 and g_BitTable[g_Index_BrushPenFlag] == 1 then
            g_UI_Items.page1Items.coinAnim:Show()
        end
    end
    g_UI_Items.page1Items.actBtn:SetToolTip("#{CJQD_20211130_20}")
    g_UI_Items.page1Items.actBtnTips:Hide()
    if g_BitTable[g_Index_BrushPenFlag] == 1 and dayIndex > 0 then
        --拥有毛笔
        g_UI_Items.page1Items.brushPen.H:Show()    
        g_UI_Items.page1Items.brushPen.H:SetToolTip("#{CJQD_20211130_19}")
        g_UI_Items.page1Items.brushPen.D:Hide()    
        if g_BitTable[g_Index_YingChunFlag_Begin+dayIndex-1] == 0 then
            g_UI_Items.page1Items.actBtnTips:Show()
            page1Tips = 1
        end
        g_UI_Items.page1Items.actNum:SetText(ScriptGlobal_Format("#{CJQD_20211130_04}",1))
    else
        g_UI_Items.page1Items.brushPen.D:Show()    
        g_UI_Items.page1Items.brushPen.D:SetToolTip("#{CJQD_20211130_19}")
        g_UI_Items.page1Items.brushPen.H:Hide() 
        g_UI_Items.page1Items.actNum:SetText(ScriptGlobal_Format("#{CJQD_20211130_04}",0))
    end

    if page1Tips == 1 then
        g_UI_Items.pageTagBtn1Tips:Show()
    else
        g_UI_Items.pageTagBtn1Tips:Hide()
    end
    if showOtherTips == 1 then
        g_UI_Items.pageTagBtn2Tips:Show()
    else
        g_UI_Items.pageTagBtn2Tips:Hide()
    end
end


function ChunJieQianDao_OpenUI2(showOtherTips) 
    --打开界面2
    ChunJieQianDao_SetBitTable( Get_XParam_INT(1))
    local dayIndex = Get_XParam_INT(2)
    local showOtherTips = Get_XParam_INT(3)
    local todayWeekActivePoint = Get_XParam_INT(4)

    if dayIndex < 0 or dayIndex > g_XCItemsNum then
        return 
    end
    this:Show()
    g_curPage = 2
    g_UI_Items.page2:Show()
    g_UI_Items.page1:Hide()
    g_UI_Items.pageTagBtn1:SetCheck(0)
    g_UI_Items.pageTagBtn2:SetCheck(1)
    local page2Tips = 0
    local resignIndex = 0
    for i=1,g_XCItemsNum do
        --设置ACTIONITEM
        local theAction = DataPool:CreateBindActionItemForShow(g_showItem[2][i].itemID,g_showItem[2][i].num)
        if theAction:GetID() ~= 0 then
            g_UI_Items.page2Items.XCItems[i].btn:SetActionItem(theAction:GetID())
        end
        local state = g_BitTable[g_Index_XinChunFlag_Begin+i-1]
        if i < dayIndex then
            --前面几天的item
            if state == 1 then
                --领了
                g_UI_Items.page2Items.XCItems[i].got:Show()
            else
                g_UI_Items.page2Items.XCItems[i].got:Hide()
            end
            g_UI_Items.page2Items.XCItems[i].anim:Hide()
            if i <= 7 and dayIndex > 7 then
                --在后7天的时候 前7天的item 是否可以补签
                if state == 0 then
                    g_UI_Items.page2Items.XCItems[i].repair:Show()
                    if resignIndex == 0 then
                        resignIndex = i
                    end
                else
                    g_UI_Items.page2Items.XCItems[i].repair:Hide()
                end
            else
                g_UI_Items.page2Items.XCItems[i].repair:Hide()
            end
        elseif i == dayIndex then
            --当天的item
            if state == 1 then
                --领了
                g_UI_Items.page2Items.XCItems[i].got:Show()
                g_UI_Items.page2Items.XCItems[i].anim:Hide()
            else
                g_UI_Items.page2Items.XCItems[i].got:Hide()
                g_UI_Items.page2Items.XCItems[i].anim:Show()
            end
            
            g_UI_Items.page2Items.XCItems[i].repair:Hide()
        else
            g_UI_Items.page2Items.XCItems[i].got:Hide()
            g_UI_Items.page2Items.XCItems[i].anim:Hide()
            g_UI_Items.page2Items.XCItems[i].repair:Hide()
        end
    end
    if resignIndex > 0 and todayWeekActivePoint >= 200 and g_BitTable[g_Index_ResignFlag] == 0 then
        g_UI_Items.page2Items.resignBtnTips:Show()
        g_UI_Items.page2Items.resignNum:SetText(ScriptGlobal_Format("#{CJQD_20211130_34}",1))
        page2Tips = 1
    else
        g_UI_Items.page2Items.resignBtnTips:Hide()
        g_UI_Items.page2Items.resignNum:SetText(ScriptGlobal_Format("#{CJQD_20211130_34}",0))
    end
    if dayIndex>0 and g_BitTable[g_Index_XinChunFlag_Begin+dayIndex-1] == 0 then
        g_UI_Items.page2Items.signBtnTips:Show()
        page2Tips = 1
    else
        g_UI_Items.page2Items.signBtnTips:Hide()        
    end

    if showOtherTips == 1 then
        g_UI_Items.pageTagBtn1Tips:Show()
    else
        g_UI_Items.pageTagBtn1Tips:Hide()
    end
    if page2Tips == 1 then
        g_UI_Items.pageTagBtn2Tips:Show()
    else
        g_UI_Items.pageTagBtn2Tips:Hide()
    end
end



function ChunJieQianDao_OnClickPage1Tag()
    if g_curPage == 1 then
        return 
    end
    Clear_XSCRIPT()
    Set_XSCRIPT_Function_Name( "OnOpenUI" ); 	
    Set_XSCRIPT_ScriptID( 892975 );						-- 脚本编号
    Set_XSCRIPT_Parameter( 0, 1 )
    Set_XSCRIPT_ParamCount( 1 );						-- 参数个数
    Send_XSCRIPT()
end

function ChunJieQianDao_OnClickPage2Tag()
    if g_curPage == 2 then
        return 
    end
    Clear_XSCRIPT()
    Set_XSCRIPT_Function_Name( "OnOpenUI" ); 	
    Set_XSCRIPT_ScriptID( 892975 );						-- 脚本编号
    Set_XSCRIPT_Parameter( 0, 2 )
    Set_XSCRIPT_ParamCount( 1 );						-- 参数个数
    Send_XSCRIPT()
end

--勾画
function ChunJieQianDao_OnClickPage1Btn1()
    Clear_XSCRIPT()
    Set_XSCRIPT_ScriptID( g_ExeScript )
    Set_XSCRIPT_Function_Name( "OnSign1" )
    Set_XSCRIPT_ParamCount( 0 )
    Send_XSCRIPT()
end

--签到
function ChunJieQianDao_OnClickPage2Btn2()
    Clear_XSCRIPT()
    Set_XSCRIPT_ScriptID( g_ExeScript )
    Set_XSCRIPT_Function_Name( "OnSign2" )
    Set_XSCRIPT_ParamCount( 0 )
    Send_XSCRIPT()
end

--补签
function ChunJieQianDao_OnClickPage2Btn1()
    Clear_XSCRIPT()
    Set_XSCRIPT_ScriptID( g_ExeScript )
    Set_XSCRIPT_Function_Name( "OnResign2" )
    Set_XSCRIPT_ParamCount( 0 )
    Send_XSCRIPT()
end


function ChunJieQianDao_On_ResetPos()
    if (this:IsVisible()) then
        if (g_Frame_UnifiedPosition ~= nil) then
            ChunJieQianDao_Frame:SetProperty("UnifiedPosition", g_Frame_UnifiedPosition)
        end
    end
end



function ChunJieQianDao_OnClose()
    this:Hide()
end

function ChunJieQianDao_SetBitTable(nOct)
    local oct = nOct
    if oct == nil then
        oct = 0
    end
	for i = 1 , g_BitNum do
		g_BitTable[i] = math.mod(oct , 2)
		oct = math.floor(oct / 2)
	end
end
