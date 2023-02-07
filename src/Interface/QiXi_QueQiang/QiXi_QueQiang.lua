--七夕鹊桥
--
--
--界面数据
local g_QiXi_QueQiang_Frame_UnifiedPosition
local g_UICOMMAND = 891160
local g_objCared = -1
local g_objID = -1
local MAX_OBJ_DISTANCE = 3.0

--活动时间
local starttime = 20210805
local endtime = 20210818

--最大图片数量
local QXQQ_picnum = 15
--最大框框数量 3X10
local QXQQ_num = 30
--3X10框框每个格子数字
local QXQQ_table = 
{
    [1] = 0, [2] = 0, [3] = 0, [4] = 0, [5] = 0, [6] = 0, [7] = 0, [8] = 0, [9] = 0, [10] = 0,
    [11] = 0,[12] = 0,[13] = 0,[14] = 0,[15] = 0,[16] = 0,[17] = 0,[18] = 0,[19] = 0,[20] = 0,
    [21] = 0,[22] = 0,[23] = 0,[24] = 0,[25] = 0,[26] = 0,[27] = 0,[28] = 0,[29] = 0,[30] = 0,
}

--OnLoad数据
local QiXi_BUTTONS = {} --3X10 框框按钮
local QiXi_TOP = {} --最上面一排按钮
local QiXi_NUM = {} --玩家身上碎片数量
local QiXi_PRICE = {} --右侧奖励图标
local QiXi_ANIMATE = {} --右侧高亮动画
local QiXi_AWARDOK = {} --右侧OK标志

--旋转状态
local xuanzhuan = {[2] = 2, [3] = 6, [4] = 10,}
--旋转最大值
local xuanmax = {[2] = 5, [3] = 9, [4] = 13,}
--旋转最小值
local xuanmin = {[2] = 2, [3] = 6, [4] = 10,}

--选中格子计数 
--1：上方  2:上方图片
--3：下方  4：下方图片
local XZnum = {[1] = 0, [2] = 0, [3] = 0, [4] = 0, }
--上方格子当前图片
local TOPnum ={[1] = 1, [2] = 2, [3] = 6, [4] = 10, [5] = 14, [6] = 15,}

--碎片数量
local QXQQ_OWN = {[1] = 0, [2] = 0, [3] = 0, [4] = 0, [5] = 0, [6] = 0,}
local QXQQ_NOW = {[1] = 0, [2] = 0, [3] = 0, [4] = 0, [5] = 0, [6] = 0,}
--是否领取奖励
local QXQQ_LINQU = {[1]=0,[2]=0,[3]=0,[4]=0,}
--奖励满足 0档 1档 2档 3档 4档
local QXQQ_ManZu = 0

--奖励
local g_Price = {
    [1] = {ItemID =20310168,gpcount=8},--金蚕丝*8
    [2] = {ItemID =50313004,gpcount=3},--红宝石3级
    [3] = {ItemID =20501003,gpcount=1},--3级棉布
    [4] = {ItemID =20502003,gpcount=1},--3级秘银
}
--界面发生变化
local g_BOOL = 0
--点击UP状态
local g_GeneralBtn_clicked = 0
local g_Jigsaw_clicked = 0

--图片
local QiXi_PIC = 
{
    --底色
    [0] = {PushedImage = "set:QiXi_QueQiao image:XuanZhong",NormalImage = "set:QiXi_QueQiao image:Normal",HoverImage = "set:QiXi_QueQiao image:GaoLiang",}, --底色
    --左1
    [1] = {PushedImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn1Dis",NormalImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn1",HoverImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn1Hover",}, --左1
    --左2
    [2] = {PushedImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn2_1Dis", NormalImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn2_1", HoverImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn2_1Hover",}, --左2 a
    [3] = {PushedImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn2_1Dis", NormalImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn2_1", HoverImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn2_1Hover",}, --左2 b
    [4] = {PushedImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn2_1Dis", NormalImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn2_1", HoverImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn2_1Hover",}, --左2 c
    [5] = {PushedImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn2_1Dis", NormalImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn2_1", HoverImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn2_1Hover",}, --左2 d
    --左3
    [6] = {PushedImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn3_1Dis", NormalImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn3_1", HoverImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn3_1Hover",}, --左3 a
    [7] = {PushedImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn3_1Dis", NormalImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn3_1", HoverImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn3_1Hover",}, --左3 b
    [8] = {PushedImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn3_1Dis", NormalImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn3_1", HoverImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn3_1Hover",}, --左3 c
    [9] = {PushedImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn3_1Dis", NormalImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn3_1", HoverImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn3_1Hover",}, --左3 d
    --左4
    [10] = {PushedImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn4_1Dis", NormalImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn4_1", HoverImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn4_1Hover",}, --左4 a
    [11] = {PushedImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn4_1Dis", NormalImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn4_1", HoverImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn4_1Hover",}, --左4 b
    [12] = {PushedImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn4_1Dis", NormalImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn4_1", HoverImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn4_1Hover",}, --左4 c
    [13] = {PushedImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn4_1Dis", NormalImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn4_1", HoverImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn4_1Hover",}, --左4 d
    --左5
    [14] = {PushedImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn5Dis", NormalImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn5", HoverImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn5Hover",}, --左5
    --左6
    [15] = {PushedImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn6Dis", NormalImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn6", HoverImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn6Hover",}, --左6
};

function QiXi_QueQiang_PreLoad()
    this:RegisterEvent("UI_COMMAND",true)
    this:RegisterEvent("OBJECT_CARED_EVENT",false)
	this:RegisterEvent("ADJEST_UI_POS",false)
    this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
    this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
    this:RegisterEvent("RESET_QIXI_QUEQIANG");
end

function QiXi_QueQiang_OnLoad()
    g_QiXi_QueQiang_Frame_UnifiedPosition = QiXi_QueQiang_Frame:GetProperty("UnifiedPosition")

    --3X10填图框展示
    --第一行
	QiXi_BUTTONS[1]	= QiXi_QueQiang_Jigsaw1
	QiXi_BUTTONS[2]	= QiXi_QueQiang_Jigsaw2
	QiXi_BUTTONS[3]	= QiXi_QueQiang_Jigsaw3
	QiXi_BUTTONS[4]	= QiXi_QueQiang_Jigsaw4
	QiXi_BUTTONS[5]	= QiXi_QueQiang_Jigsaw5
	QiXi_BUTTONS[6]	= QiXi_QueQiang_Jigsaw6
	QiXi_BUTTONS[7]	= QiXi_QueQiang_Jigsaw7
	QiXi_BUTTONS[8]	= QiXi_QueQiang_Jigsaw8
	QiXi_BUTTONS[9]	= QiXi_QueQiang_Jigsaw9
    QiXi_BUTTONS[10] = QiXi_QueQiang_Jigsaw10
    --第二行
	QiXi_BUTTONS[11]	= QiXi_QueQiang_Jigsaw11
	QiXi_BUTTONS[12]	= QiXi_QueQiang_Jigsaw12
	QiXi_BUTTONS[13]	= QiXi_QueQiang_Jigsaw13
	QiXi_BUTTONS[14]	= QiXi_QueQiang_Jigsaw14
    QiXi_BUTTONS[15]	= QiXi_QueQiang_Jigsaw15
    QiXi_BUTTONS[16]	= QiXi_QueQiang_Jigsaw16
    QiXi_BUTTONS[17]	= QiXi_QueQiang_Jigsaw17
    QiXi_BUTTONS[18]	= QiXi_QueQiang_Jigsaw18
    QiXi_BUTTONS[19]	= QiXi_QueQiang_Jigsaw19
    QiXi_BUTTONS[20]	= QiXi_QueQiang_Jigsaw20
    --第三行
    QiXi_BUTTONS[21]	= QiXi_QueQiang_Jigsaw21
    QiXi_BUTTONS[22]	= QiXi_QueQiang_Jigsaw22
    QiXi_BUTTONS[23]	= QiXi_QueQiang_Jigsaw23
    QiXi_BUTTONS[24]	= QiXi_QueQiang_Jigsaw24
    QiXi_BUTTONS[25]	= QiXi_QueQiang_Jigsaw25
    QiXi_BUTTONS[26]	= QiXi_QueQiang_Jigsaw26
    QiXi_BUTTONS[27]	= QiXi_QueQiang_Jigsaw27
    QiXi_BUTTONS[28]	= QiXi_QueQiang_Jigsaw28
    QiXi_BUTTONS[29]	= QiXi_QueQiang_Jigsaw29
    QiXi_BUTTONS[30]	= QiXi_QueQiang_Jigsaw30

    --最上面
    QiXi_TOP[1]	= QiXi_QueQiang_General1Btn
    QiXi_TOP[2]	= QiXi_QueQiang_General2Btn
    QiXi_TOP[3]	= QiXi_QueQiang_General3Btn
    QiXi_TOP[4]	= QiXi_QueQiang_General4Btn
    QiXi_TOP[5]	= QiXi_QueQiang_Rare1Btn
    QiXi_TOP[6]	= QiXi_QueQiang_Rare2Btn

    QiXi_NUM[1]	= QiXi_QueQiang_General1Text
    QiXi_NUM[2]	= QiXi_QueQiang_General2Text
    QiXi_NUM[3]	= QiXi_QueQiang_General3Text
    QiXi_NUM[4]	= QiXi_QueQiang_General4Text
    QiXi_NUM[5]	= QiXi_QueQiang_Rare1Text
    QiXi_NUM[6]	= QiXi_QueQiang_Rare2Text

    QiXi_PRICE[1] = QiXi_QueQiang_Award1
    QiXi_PRICE[2] = QiXi_QueQiang_Award2
    QiXi_PRICE[3] = QiXi_QueQiang_Award3
    QiXi_PRICE[4] = QiXi_QueQiang_Award4

    QiXi_ANIMATE[1] = QiXi_QueQiang_Award1Animate
    QiXi_ANIMATE[2] = QiXi_QueQiang_Award2Animate
    QiXi_ANIMATE[3] = QiXi_QueQiang_Award3Animate
    QiXi_ANIMATE[4] = QiXi_QueQiang_Award4Animate

    QiXi_AWARDOK[1] = QiXi_QueQiang_Award1OK
    QiXi_AWARDOK[2] = QiXi_QueQiang_Award2OK
    QiXi_AWARDOK[3] = QiXi_QueQiang_Award3OK
    QiXi_AWARDOK[4] = QiXi_QueQiang_Award4OK
end

--设置每个框图案
local function SetOpenSeKuai()
    
    --最上面一排
    --左1
    QiXi_TOP[1]:SetProperty("PushedImage", QiXi_PIC[1].PushedImage);--点击状态
    QiXi_TOP[1]:SetProperty("NormalImage", QiXi_PIC[1].NormalImage); --正常状态
    QiXi_TOP[1]:SetProperty("HoverImage", QiXi_PIC[1].HoverImage);--移动到图标上
    QiXi_TOP[1]:Show()

    --左2
    QiXi_TOP[2]:SetProperty("PushedImage", QiXi_PIC[2].PushedImage);--点击状态
    QiXi_TOP[2]:SetProperty("NormalImage", QiXi_PIC[2].NormalImage); --正常状态
    QiXi_TOP[2]:SetProperty("HoverImage", QiXi_PIC[2].HoverImage);--移动到图标上
    QiXi_TOP[2]:Show()

    --左3
    QiXi_TOP[3]:SetProperty("PushedImage", QiXi_PIC[6].PushedImage);--点击状态
    QiXi_TOP[3]:SetProperty("NormalImage", QiXi_PIC[6].NormalImage); --正常状态
    QiXi_TOP[3]:SetProperty("HoverImage", QiXi_PIC[6].HoverImage);--移动到图标上
    QiXi_TOP[3]:Show()

    --左4
    QiXi_TOP[4]:SetProperty("PushedImage", QiXi_PIC[10].PushedImage);--点击状态
    QiXi_TOP[4]:SetProperty("NormalImage", QiXi_PIC[10].NormalImage); --正常状态
    QiXi_TOP[4]:SetProperty("HoverImage", QiXi_PIC[10].HoverImage);--移动到图标上
    QiXi_TOP[4]:Show()

    --左5
    QiXi_TOP[5]:SetProperty("PushedImage", QiXi_PIC[14].PushedImage);--点击状态
    QiXi_TOP[5]:SetProperty("NormalImage", QiXi_PIC[14].NormalImage); --正常状态
    QiXi_TOP[5]:SetProperty("HoverImage", QiXi_PIC[14].HoverImage);--移动到图标上
    QiXi_TOP[5]:Show()

    --左5
    QiXi_TOP[6]:SetProperty("PushedImage", QiXi_PIC[15].PushedImage);--点击状态
    QiXi_TOP[6]:SetProperty("NormalImage", QiXi_PIC[15].NormalImage); --正常状态
    QiXi_TOP[6]:SetProperty("HoverImage", QiXi_PIC[15].HoverImage);--移动到图标上
    QiXi_TOP[6]:Show()

    for i = 1, QXQQ_num do    
        QiXi_BUTTONS[i]:SetProperty("PushedImage", QiXi_PIC[QXQQ_table[i]].PushedImage);--点击状态
        QiXi_BUTTONS[i]:SetProperty("NormalImage", QiXi_PIC[QXQQ_table[i]].NormalImage); --正常状态
        QiXi_BUTTONS[i]:SetProperty("HoverImage", QiXi_PIC[QXQQ_table[i]].HoverImage);--移动到图标上
        QiXi_BUTTONS[i]:Show()
    end
    --实时更新玩家剩余色块数量
    QiXi_QueQiang_NowShuLiang()

end

local function reset()
    for i = 1, QXQQ_num do
        QXQQ_table[i] = 0
    end

    for i = 1,6 do
        QiXi_TOP[i]:SetCheck(0)   
    end
    
    for i = 1,QXQQ_num do
        QiXi_BUTTONS[i]:SetCheck(0)
    end
    
    xuanzhuan = { [2] = 2, [3] = 6, [4] = 10, }
    XZnum = {[1] = 0, [2] = 0, [3] = 0, [4] = 0, }

    TOPnum =
    {
        [1] = 1, [2] = 2, [3] = 6, [4] = 10, [5] = 14, [6] = 15,
    }

    QXQQ_NOW = {[1] = 0, [2] = 0, [3] = 0, [4] = 0, [5] = 0, [6] = 0,}

    g_GeneralBtn_clicked = 0
    g_Jigsaw_clicked = 0
    --设置每个框图案
    SetOpenSeKuai()
end

local function clean()
    g_objID = -1
    g_objCared= -1

    for i = 1, 4 do
        QiXi_ANIMATE[i]:Hide()
        QiXi_AWARDOK[i]:Hide()
        QiXi_PRICE[i]:Enable() 
    end

    QXQQ_ManZu = 0
    QXQQ_LINQU = {[1]=0,[2]=0,[3]=0,[4]=0,}

    g_BOOL = 0

    reset()
end

--将6个10位MD转化成30个2位数字
local function SetSekuaiNum(num1,num2,num3,num4,num5,num6)
    local intmax = 1600000000
    local intmin = 0
    local table_temp = 
    {
        [1] = num1,[2] = num2,[3] = num3,
        [4] = num4,[5] = num5,[6] = num6,
    }

    for i = 1, 6 do
        if (table_temp[i] >= intmax or table_temp[i] < intmin) then
            PushDebugMessage("传过来的数据有问题。")
            return 0
        end
    end

    QXQQ_table[1]  = math.floor(math.mod(num1/100000000,100))
    QXQQ_table[2]  = math.floor(math.mod(num1/1000000,100))
    QXQQ_table[3]  = math.floor(math.mod(num1/10000,100))
    QXQQ_table[4]  = math.floor(math.mod(num1/100,100))
    QXQQ_table[5]  = math.floor(math.mod(num1/1,100))

    QXQQ_table[6]  = math.floor(math.mod(num2/100000000,100))
    QXQQ_table[7]  = math.floor(math.mod(num2/1000000,100))
    QXQQ_table[8]  = math.floor(math.mod(num2/10000,100))
    QXQQ_table[9]  = math.floor(math.mod(num2/100,100))
    QXQQ_table[10] = math.floor(math.mod(num2/1,100))

    QXQQ_table[11]  = math.floor(math.mod(num3/100000000,100))
    QXQQ_table[12]  = math.floor(math.mod(num3/1000000,100))
    QXQQ_table[13]  = math.floor(math.mod(num3/10000,100))
    QXQQ_table[14]  = math.floor(math.mod(num3/100,100))
    QXQQ_table[15]  = math.floor(math.mod(num3/1,100))

    QXQQ_table[16]  = math.floor(math.mod(num4/100000000,100))
    QXQQ_table[17]  = math.floor(math.mod(num4/1000000,100))
    QXQQ_table[18]  = math.floor(math.mod(num4/10000,100))
    QXQQ_table[19]  = math.floor(math.mod(num4/100,100))
    QXQQ_table[20]  = math.floor(math.mod(num4/1,100))

    QXQQ_table[21]  = math.floor(math.mod(num5/100000000,100))
    QXQQ_table[22]  = math.floor(math.mod(num5/1000000,100))
    QXQQ_table[23]  = math.floor(math.mod(num5/10000,100))
    QXQQ_table[24]  = math.floor(math.mod(num5/100,100))
    QXQQ_table[25]  = math.floor(math.mod(num5/1,100))

    QXQQ_table[26]  = math.floor(math.mod(num6/100000000,100))
    QXQQ_table[27]  = math.floor(math.mod(num6/1000000,100))
    QXQQ_table[28]  = math.floor(math.mod(num6/10000,100))
    QXQQ_table[29]  = math.floor(math.mod(num6/100,100))
    QXQQ_table[30]  = math.floor(math.mod(num6/1,100))

    for i = 1, QXQQ_num do
        if QXQQ_table[i] > QXQQ_picnum or QXQQ_table[i] < 0 then
            QXQQ_table[i] = 0
        end    
    end

    return 1
end

function QiXi_QueQiang_OnHiden()
    if nil ~= g_objCared and g_objCared > 0 then
		this:CareObject(g_objCared, 0, "QiXi_QueQiang")
    end

    PushEvent("CONFIRM_QIXI_QUEQIANG", "close")
    --存数据
    if g_BOOL == 1 then
        QiXi_QueQiang_Save()
    end
    
    clean()

    this:Hide()

end

function QiXi_QueQiang_Close()
    QiXi_QueQiang_OnHiden()
end

function QiXi_QueQiang_ResetPos()
    QiXi_QueQiang_Frame:SetProperty("UnifiedPosition", g_QiXi_QueQiang_Frame_UnifiedPosition)
end

function QiXi_QueQiang_OnEvent(event)
    if event == "UI_COMMAND" and tonumber(arg0) == g_UICOMMAND then
        if Get_XParam_STR(0) == "REFRESH_SHOW" then --更新右侧图标
            if this:IsVisible() then
                local QXQQ_PRIZE = Get_XParam_INT(0)
                --右侧进度条设置
                QiXi_QueQiang_JinDuTiao(QXQQ_PRIZE)
            end
        else
            --打开七夕鹊桥界面
            clean()
            g_objID = Get_XParam_INT(0)

            g_objCared = DataPool : GetNPCIDByServerID(tonumber(g_objID))
            if g_objCared == -1 then
                PushDebugMessage("server传过来的数据有问题。")
                return
            end
            if nil ~= g_objCared and g_objCared > 0 then
                this:CareObject(g_objCared, 1, "QiXi_QueQiang")
            end

            local QXQQ_11 = Get_XParam_INT(1)
            local QXQQ_12 = Get_XParam_INT(2)
            local QXQQ_21 = Get_XParam_INT(3)
            local QXQQ_22 = Get_XParam_INT(4)
            local QXQQ_31 = Get_XParam_INT(5)
            local QXQQ_32 = Get_XParam_INT(6)
            --七夕稳活搭鹊桥活动 MD 每日更新 兑换总数量上限 稀有+普通+稀有色块数量 654312
            --6:稀有每日兑换 5：普通每日兑换 43：稀有色块数量2 21：稀有色块数量1 7:是否领取奖励 8：是否满足需求
            local QXQQ_PT = Get_XParam_INT(7)
            --6:稀有每日兑换 5：普通每日兑换 43：稀有色块数量2 21：稀有色块数量1
            local QXQQ_XY = Get_XParam_INT(8)
            ----七夕鹊桥,奖励领取情况
            --1:1号奖励领取 2:2号奖励领取 3:3号奖励领取 4:4号奖励领取 --5:奖励满足
            local QXQQ_PRIZE = Get_XParam_INT(9)

            ----右侧进度条设置
            QiXi_QueQiang_JinDuTiao(QXQQ_PRIZE)
            --计算玩家身上色块数量
            QiXi_QueQiang_SetShuLiang(QXQQ_PT,QXQQ_XY)
            --打开界面
            QiXi_QueQiang_Open(QXQQ_11,QXQQ_12,QXQQ_21,QXQQ_22,QXQQ_31,QXQQ_32)
        end
    elseif ( event == "OBJECT_CARED_EVENT" and this:IsVisible() ) then
		if(tonumber(arg0) ~= g_objCared) then
			return
        end
        
		-- 如果和NPC的距离大于一定距离或者被删除，自动关闭
        if(arg1 == "distance" and tonumber(arg2) > MAX_OBJ_DISTANCE or arg1=="destroy") then
            QiXi_QueQiang_Close()
        end
    elseif ( event == "RESET_QIXI_QUEQIANG")then
		QiXi_QueQiang_ResetOK()
    end

    if this:IsVisible() then
        if event == "ADJEST_UI_POS" or
			event == "VIEW_RESOLUTION_CHANGED" then
				QiXi_QueQiang_ResetPos()
        elseif event == "HIDE_ON_SCENE_TRANSED" then
            QiXi_QueQiang_OnHiden()
        end
    end
end

--打开界面
function QiXi_QueQiang_Open(table11,table12,table21,table22,table31,table32)
    --将6个10位MD转化成30个2位数字
    if SetSekuaiNum(table11,table12,table21,table22,table31,table32) == 0 then
        return
    end
    --设置每个框图案
    SetOpenSeKuai()
    --实时更新玩家剩余色块数量
    QiXi_QueQiang_NowShuLiang()

    -- -- --设置右侧奖励物品图案
    -- QiXi_PRICE[1]:SetProperty("BackImage","set:QiXi_QueQiao image:CircularTaskTool84_4")
    -- QiXi_PRICE[2]:SetProperty("BackImage","set:QiXi_QueQiao image:CircularTaskTool84_5")
    -- QiXi_PRICE[3]:SetProperty("BackImage","set:QiXi_QueQiao image:CircularTaskTool84_6")
    -- QiXi_PRICE[4]:SetProperty("BackImage","set:QiXi_QueQiao image:CircularTaskTool84_7")

    this:Show()

end

--大框框 1 2 3 4 5 6_UP
function QiXi_QueQiang_GeneralBtn_UP(index)
    PushEvent("CONFIRM_QIXI_QUEQIANG", "close")

    if g_GeneralBtn_clicked == 1 then
        g_GeneralBtn_clicked = 0
        return 0
    end
    
    for i = 1,6 do
        if i ==  XZnum[1] then
            QiXi_TOP[i]:SetCheck(1)
        else
            QiXi_TOP[i]:SetCheck(0)
        end    
    end

end

--大框框 1 2 3 4 5 6
function QiXi_QueQiang_GeneralBtn(index)
    PushEvent("CONFIRM_QIXI_QUEQIANG", "close")

    g_GeneralBtn_clicked = 1

    if XZnum[1] == index then
        XZnum[1] = 0
    else
        --上方选中第几个格子
        XZnum[1] = index
        --这个格子目前的图片
        XZnum[2] = TOPnum[index]
    end

    for i = 1,6 do
        if i ==  XZnum[1] then
            QiXi_TOP[i]:SetCheck(1)
        else
            QiXi_TOP[i]:SetCheck(0)
        end    
    end

end

--旋转 2 3 4
function QiXi_QueQiang_GeneralRotate(index)
    PushEvent("CONFIRM_QIXI_QUEQIANG", "close")

    --旋转时候上方按钮突出来
    for i = 1,6 do
        XZnum[1] = 0
        QiXi_TOP[i]:SetCheck(0) 
    end  

    xuanzhuan[index] = xuanzhuan[index] + 1
    if xuanzhuan[index] > xuanmax[index] then
        xuanzhuan[index] = xuanmin[index]
    end
    TOPnum[index] = xuanzhuan[index]

    QiXi_TOP[index]:SetProperty("PushedImage", QiXi_PIC[xuanzhuan[index]].PushedImage);--点击状态
    QiXi_TOP[index]:SetProperty("NormalImage", QiXi_PIC[xuanzhuan[index]].NormalImage); --正常状态
    QiXi_TOP[index]:SetProperty("HoverImage", QiXi_PIC[xuanzhuan[index]].HoverImage);--移动到图标上
    QiXi_TOP[index]:Show()

end

--30个小格子_UP
function QiXi_QueQiang_Jigsaw_UP(index)
    PushEvent("CONFIRM_QIXI_QUEQIANG", "close")
    if g_Jigsaw_clicked == 1 then
        g_Jigsaw_clicked = 0
        return 0
    end

    for i = 1,QXQQ_num do
        if i == XZnum[3] then
            QiXi_BUTTONS[i]:SetCheck(1)
        else
            QiXi_BUTTONS[i]:SetCheck(0)
        end    
    end
    
end

--30个小格子
function QiXi_QueQiang_Jigsaw(index)
    PushEvent("CONFIRM_QIXI_QUEQIANG", "close")

    g_Jigsaw_clicked = 1

    if XZnum[3] == index then
        XZnum[3] = 0
    else
        XZnum[3] = index
    end

    for i = 1,QXQQ_num do
        if i == XZnum[3] then
            QiXi_BUTTONS[i]:SetCheck(1)
        else
            QiXi_BUTTONS[i]:SetCheck(0)
        end    
    end
    
end

--领奖框框 1 2 3 4
function QiXi_QueQiang_Award(index)
    PushEvent("CONFIRM_QIXI_QUEQIANG", "close")

    --领取奖励
    Clear_XSCRIPT()
        Set_XSCRIPT_ScriptID(891161)
        Set_XSCRIPT_Function_Name("GetPrize")
        Set_XSCRIPT_Parameter( 0, index )
        Set_XSCRIPT_ParamCount(1)
    Send_XSCRIPT()

end

--重置按钮
function QiXi_QueQiang_Reset()
    PushEvent("CONFIRM_QIXI_QUEQIANG", "open")
end

--重置
function QiXi_QueQiang_ResetOK()
    --发生变化，BOOL置为1
    g_BOOL = 1
    reset()
end

--填入
function QiXi_QueQiang_Fill()
    PushEvent("CONFIRM_QIXI_QUEQIANG", "close")

    if QiXi_QueQiang_Check() == 0 then
        return
    end
    --下方
    if XZnum[3] == 0 then
        PushDebugMessage("#{QXWH_20210616_61}") --请先选中要进行浮阶填充的位置。
        return
    end
    --上方
    if XZnum[1] == 0 then
        PushDebugMessage("#{QXWH_20210616_62}") --请先选中要进行填充的浮阶。
        return
    end

    if QXQQ_NOW[XZnum[1]] == 0 then
        PushDebugMessage("#{QXWH_20210616_05}") --当前浮阶剩余数量不足，少侠兑换后再来填充吧
        return
    end

    QXQQ_table[XZnum[3]] = XZnum[2]
    QiXi_BUTTONS[XZnum[3]]:SetProperty("PushedImage", QiXi_PIC[QXQQ_table[XZnum[3]]].PushedImage);--点击状态
    QiXi_BUTTONS[XZnum[3]]:SetProperty("NormalImage", QiXi_PIC[QXQQ_table[XZnum[3]]].NormalImage); --正常状态
    QiXi_BUTTONS[XZnum[3]]:SetProperty("HoverImage", QiXi_PIC[QXQQ_table[XZnum[3]]].HoverImage);--移动到图标上
    QiXi_BUTTONS[XZnum[3]]:Show()

    --实时更新玩家剩余色块数量
    QiXi_QueQiang_NowShuLiang()
    --发生变化，BOOL置为1
    g_BOOL = 1

    --若当前填充状态大于玩家身上MD则跟新MD
    local pushnum = QiXi_QueQiang_PUSH()
    local level = QiXi_QueQiang_Level(pushnum)
    if level > QXQQ_ManZu then
        --领取奖励
        Clear_XSCRIPT()
            Set_XSCRIPT_ScriptID(891161)
            Set_XSCRIPT_Function_Name("UpdataMD")
            Set_XSCRIPT_Parameter(0,level)
            Set_XSCRIPT_ParamCount(1)
        Send_XSCRIPT()
    end

end

--清除
function QiXi_QueQiang_Clear()
    PushEvent("CONFIRM_QIXI_QUEQIANG", "close")

    if QiXi_QueQiang_Check() == 0 then
        return
    end

    if XZnum[3] == 0 then
        PushDebugMessage("#{QXWH_20210616_88}") --请先选中要进行浮阶清除的位置。
        return
    end

    QXQQ_table[XZnum[3]] = 0
    QiXi_BUTTONS[XZnum[3]]:SetProperty("PushedImage", QiXi_PIC[QXQQ_table[XZnum[3]]].PushedImage);--点击状态
    QiXi_BUTTONS[XZnum[3]]:SetProperty("NormalImage", QiXi_PIC[QXQQ_table[XZnum[3]]].NormalImage); --正常状态
    QiXi_BUTTONS[XZnum[3]]:SetProperty("HoverImage", QiXi_PIC[QXQQ_table[XZnum[3]]].HoverImage);--移动到图标上
    QiXi_BUTTONS[XZnum[3]]:Show()

    PushDebugMessage("#{QXWH_20210616_68}") --浮阶清除成功。

    --发生变化，BOOL置为1
    g_BOOL = 1

    --实时更新玩家剩余色块数量
    QiXi_QueQiang_NowShuLiang()
end

--Help
function QiXi_QueQiang_Help()
    PushEvent("CONFIRM_QIXI_QUEQIANG", "close")
end

--Check
function QiXi_QueQiang_Check()

    --日期
	local curDay = tonumber(DataPool:GetServerDayTime());
	if curDay < starttime or curDay > endtime then
        PushDebugMessage("#{QXWH_20210616_39}")
		return 0
    end
    
    local myLevel = Player:GetData("LEVEL")
	if myLevel < 30 then
        PushDebugMessage("#{QXWH_20210616_19}")
        return 0
    end

    return 1
end

--计算玩家身上色块数量
function QiXi_QueQiang_SetShuLiang(QXQQ_PT,QXQQ_XY)
    --21：微风 43：纤云 65：辰光 87：霞光
    QXQQ_OWN[4]  = math.floor(math.mod(QXQQ_PT/1000000,100)) 
    QXQQ_OWN[3]  = math.floor(math.mod(QXQQ_PT/10000,100))
    QXQQ_OWN[2]  = math.floor(math.mod(QXQQ_PT/100,100))
    QXQQ_OWN[1]  = math.floor(math.mod(QXQQ_PT/1,100))
    --43：稀有色块数量2 21：稀有色块数量1
    QXQQ_OWN[5]  = math.floor(math.mod(QXQQ_XY/1,100))
    QXQQ_OWN[6]  = math.floor(math.mod(QXQQ_XY/100,100))

end

--实时更新玩家剩余色块数量
function QiXi_QueQiang_NowShuLiang()

    local temp = {[1] = 0, [2] = 0, [3] = 0, [4] = 0, [5] = 0, [6] = 0,}

    for i = 1, QXQQ_num do
        if QXQQ_table[i] == 1 then
            temp[1] = temp[1] + 1
        elseif QXQQ_table[i] == 2 or QXQQ_table[i] == 3 or QXQQ_table[i] == 4 or QXQQ_table[i] == 5 then
            temp[2] = temp[2] + 1
        elseif QXQQ_table[i] == 6 or QXQQ_table[i] == 7 or QXQQ_table[i] == 8 or QXQQ_table[i] == 9 then
            temp[3] = temp[3] + 1
        elseif QXQQ_table[i] == 10 or QXQQ_table[i] == 11 or QXQQ_table[i] == 12 or QXQQ_table[i] == 13 then
            temp[4] = temp[4] + 1
        elseif QXQQ_table[i] == 14 then
            temp[5] = temp[5] + 1
        elseif QXQQ_table[i] == 15 then
            temp[6] = temp[6] + 1
        end    
    end

    for i = 1,6 do
        QXQQ_NOW[i] = QXQQ_OWN[i] - temp[i]
        if QXQQ_NOW[i] < 0 then
            QXQQ_NOW[i] = 0
        end
        QiXi_NUM[i]:SetText( ScriptGlobal_Format("#{QXWH_20210616_89}", QXQQ_NOW[i]))
    end

end

--存数据
function QiXi_QueQiang_Save()
    
    local QXQQ_11 = QXQQ_table[1] * 100000000 + QXQQ_table[2] * 1000000 + QXQQ_table[3] * 10000 + QXQQ_table[4] * 100 + QXQQ_table[5] * 1
    local QXQQ_12 = QXQQ_table[6] * 100000000 + QXQQ_table[7] * 1000000 + QXQQ_table[8] * 10000 + QXQQ_table[9] * 100 + QXQQ_table[10] * 1
    local QXQQ_21 = QXQQ_table[11] * 100000000 + QXQQ_table[12] * 1000000 + QXQQ_table[13] * 10000 + QXQQ_table[14] * 100 + QXQQ_table[15] * 1
    local QXQQ_22 = QXQQ_table[16] * 100000000 + QXQQ_table[17] * 1000000 + QXQQ_table[18] * 10000 + QXQQ_table[19] * 100 + QXQQ_table[20] * 1
    local QXQQ_31 = QXQQ_table[21] * 100000000 + QXQQ_table[22] * 1000000 + QXQQ_table[23] * 10000 + QXQQ_table[24] * 100 + QXQQ_table[25] * 1
    local QXQQ_32 = QXQQ_table[26] * 100000000 + QXQQ_table[27] * 1000000 + QXQQ_table[28] * 10000 + QXQQ_table[29] * 100 + QXQQ_table[30] * 1

    --更新MD
    Clear_XSCRIPT()
        Set_XSCRIPT_ScriptID(891161)
        Set_XSCRIPT_Function_Name("SaveMD")
        Set_XSCRIPT_Parameter( 0, QXQQ_11 )
        Set_XSCRIPT_Parameter( 1, QXQQ_12 )
        Set_XSCRIPT_Parameter( 2, QXQQ_21 )
        Set_XSCRIPT_Parameter( 3, QXQQ_22 )
        Set_XSCRIPT_Parameter( 4, QXQQ_31 )
        Set_XSCRIPT_Parameter( 5, QXQQ_32 )
        Set_XSCRIPT_ParamCount(6)
    Send_XSCRIPT()

end

--获取当前填充数量
function QiXi_QueQiang_PUSH()
    local num = 0
    for i = 1, QXQQ_num do
        if QXQQ_table[i] ~= 0 then
            num = num + 1
        end    
    end
    return num
end

--进度条
function QiXi_QueQiang_JinDuTiao(NUM)

    --5:奖励满足 30101
    --1:1号奖励领取 2:2号奖励领取 3:3号奖励领取 4:4号奖励领取
    QXQQ_ManZu = math.floor(math.mod(NUM/10000,10))

    QXQQ_LINQU[1] = math.floor(math.mod(NUM/1000,10))
    QXQQ_LINQU[2] = math.floor(math.mod(NUM/100,10))
    QXQQ_LINQU[3] = math.floor(math.mod(NUM/10,10))
    QXQQ_LINQU[4] = math.floor(math.mod(NUM/1,10))
  
    for i = 1, 4 do
        --若已经领取则置灰
        if QXQQ_LINQU[i] > 0 then
            QiXi_AWARDOK[i]:Show()
            QiXi_ANIMATE[i]:Hide()
            --QiXi_PRICE[i]:Disable()
            --QiXi_ANIMATE[i]:Play(false)
        else
            if QXQQ_ManZu >= i then
                QiXi_ANIMATE[i]:Show()
            end
        end
    end

end

--当前进度条档次
function QiXi_QueQiang_Level(NUM)
    local QiXi_Level = {[0] = 0, [1] = 8,[2] = 15,[3] = 23, [4] = 30,}

	if NUM >= QiXi_Level[1] and NUM < QiXi_Level[2] then
		return 1
	elseif NUM >= QiXi_Level[2] and NUM < QiXi_Level[3] then
		return 2
	elseif NUM >= QiXi_Level[3] and NUM < QiXi_Level[4] then
		return 3
	elseif NUM >= QiXi_Level[4] then
		return 4
	else
		return 0
    end
    
	return 0
end