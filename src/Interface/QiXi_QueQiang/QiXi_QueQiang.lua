--��Ϧȵ��
--
--
--��������
local g_QiXi_QueQiang_Frame_UnifiedPosition
local g_UICOMMAND = 891160
local g_objCared = -1
local g_objID = -1
local MAX_OBJ_DISTANCE = 3.0

--�ʱ��
local starttime = 20210805
local endtime = 20210818

--���ͼƬ����
local QXQQ_picnum = 15
--��������� 3X10
local QXQQ_num = 30
--3X10���ÿ����������
local QXQQ_table = 
{
    [1] = 0, [2] = 0, [3] = 0, [4] = 0, [5] = 0, [6] = 0, [7] = 0, [8] = 0, [9] = 0, [10] = 0,
    [11] = 0,[12] = 0,[13] = 0,[14] = 0,[15] = 0,[16] = 0,[17] = 0,[18] = 0,[19] = 0,[20] = 0,
    [21] = 0,[22] = 0,[23] = 0,[24] = 0,[25] = 0,[26] = 0,[27] = 0,[28] = 0,[29] = 0,[30] = 0,
}

--OnLoad����
local QiXi_BUTTONS = {} --3X10 ���ť
local QiXi_TOP = {} --������һ�Ű�ť
local QiXi_NUM = {} --���������Ƭ����
local QiXi_PRICE = {} --�Ҳཱ��ͼ��
local QiXi_ANIMATE = {} --�Ҳ��������
local QiXi_AWARDOK = {} --�Ҳ�OK��־

--��ת״̬
local xuanzhuan = {[2] = 2, [3] = 6, [4] = 10,}
--��ת���ֵ
local xuanmax = {[2] = 5, [3] = 9, [4] = 13,}
--��ת��Сֵ
local xuanmin = {[2] = 2, [3] = 6, [4] = 10,}

--ѡ�и��Ӽ��� 
--1���Ϸ�  2:�Ϸ�ͼƬ
--3���·�  4���·�ͼƬ
local XZnum = {[1] = 0, [2] = 0, [3] = 0, [4] = 0, }
--�Ϸ����ӵ�ǰͼƬ
local TOPnum ={[1] = 1, [2] = 2, [3] = 6, [4] = 10, [5] = 14, [6] = 15,}

--��Ƭ����
local QXQQ_OWN = {[1] = 0, [2] = 0, [3] = 0, [4] = 0, [5] = 0, [6] = 0,}
local QXQQ_NOW = {[1] = 0, [2] = 0, [3] = 0, [4] = 0, [5] = 0, [6] = 0,}
--�Ƿ���ȡ����
local QXQQ_LINQU = {[1]=0,[2]=0,[3]=0,[4]=0,}
--�������� 0�� 1�� 2�� 3�� 4��
local QXQQ_ManZu = 0

--����
local g_Price = {
    [1] = {ItemID =20310168,gpcount=8},--���˿*8
    [2] = {ItemID =50313004,gpcount=3},--�챦ʯ3��
    [3] = {ItemID =20501003,gpcount=1},--3���޲�
    [4] = {ItemID =20502003,gpcount=1},--3������
}
--���淢���仯
local g_BOOL = 0
--���UP״̬
local g_GeneralBtn_clicked = 0
local g_Jigsaw_clicked = 0

--ͼƬ
local QiXi_PIC = 
{
    --��ɫ
    [0] = {PushedImage = "set:QiXi_QueQiao image:XuanZhong",NormalImage = "set:QiXi_QueQiao image:Normal",HoverImage = "set:QiXi_QueQiao image:GaoLiang",}, --��ɫ
    --��1
    [1] = {PushedImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn1Dis",NormalImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn1",HoverImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn1Hover",}, --��1
    --��2
    [2] = {PushedImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn2_1Dis", NormalImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn2_1", HoverImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn2_1Hover",}, --��2 a
    [3] = {PushedImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn2_1Dis", NormalImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn2_1", HoverImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn2_1Hover",}, --��2 b
    [4] = {PushedImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn2_1Dis", NormalImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn2_1", HoverImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn2_1Hover",}, --��2 c
    [5] = {PushedImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn2_1Dis", NormalImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn2_1", HoverImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn2_1Hover",}, --��2 d
    --��3
    [6] = {PushedImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn3_1Dis", NormalImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn3_1", HoverImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn3_1Hover",}, --��3 a
    [7] = {PushedImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn3_1Dis", NormalImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn3_1", HoverImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn3_1Hover",}, --��3 b
    [8] = {PushedImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn3_1Dis", NormalImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn3_1", HoverImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn3_1Hover",}, --��3 c
    [9] = {PushedImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn3_1Dis", NormalImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn3_1", HoverImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn3_1Hover",}, --��3 d
    --��4
    [10] = {PushedImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn4_1Dis", NormalImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn4_1", HoverImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn4_1Hover",}, --��4 a
    [11] = {PushedImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn4_1Dis", NormalImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn4_1", HoverImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn4_1Hover",}, --��4 b
    [12] = {PushedImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn4_1Dis", NormalImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn4_1", HoverImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn4_1Hover",}, --��4 c
    [13] = {PushedImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn4_1Dis", NormalImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn4_1", HoverImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn4_1Hover",}, --��4 d
    --��5
    [14] = {PushedImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn5Dis", NormalImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn5", HoverImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn5Hover",}, --��5
    --��6
    [15] = {PushedImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn6Dis", NormalImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn6", HoverImage = "set:QiXi_QueQiao image:QiXi_QueQiaoBtn6Hover",}, --��6
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

    --3X10��ͼ��չʾ
    --��һ��
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
    --�ڶ���
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
    --������
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

    --������
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

--����ÿ����ͼ��
local function SetOpenSeKuai()
    
    --������һ��
    --��1
    QiXi_TOP[1]:SetProperty("PushedImage", QiXi_PIC[1].PushedImage);--���״̬
    QiXi_TOP[1]:SetProperty("NormalImage", QiXi_PIC[1].NormalImage); --����״̬
    QiXi_TOP[1]:SetProperty("HoverImage", QiXi_PIC[1].HoverImage);--�ƶ���ͼ����
    QiXi_TOP[1]:Show()

    --��2
    QiXi_TOP[2]:SetProperty("PushedImage", QiXi_PIC[2].PushedImage);--���״̬
    QiXi_TOP[2]:SetProperty("NormalImage", QiXi_PIC[2].NormalImage); --����״̬
    QiXi_TOP[2]:SetProperty("HoverImage", QiXi_PIC[2].HoverImage);--�ƶ���ͼ����
    QiXi_TOP[2]:Show()

    --��3
    QiXi_TOP[3]:SetProperty("PushedImage", QiXi_PIC[6].PushedImage);--���״̬
    QiXi_TOP[3]:SetProperty("NormalImage", QiXi_PIC[6].NormalImage); --����״̬
    QiXi_TOP[3]:SetProperty("HoverImage", QiXi_PIC[6].HoverImage);--�ƶ���ͼ����
    QiXi_TOP[3]:Show()

    --��4
    QiXi_TOP[4]:SetProperty("PushedImage", QiXi_PIC[10].PushedImage);--���״̬
    QiXi_TOP[4]:SetProperty("NormalImage", QiXi_PIC[10].NormalImage); --����״̬
    QiXi_TOP[4]:SetProperty("HoverImage", QiXi_PIC[10].HoverImage);--�ƶ���ͼ����
    QiXi_TOP[4]:Show()

    --��5
    QiXi_TOP[5]:SetProperty("PushedImage", QiXi_PIC[14].PushedImage);--���״̬
    QiXi_TOP[5]:SetProperty("NormalImage", QiXi_PIC[14].NormalImage); --����״̬
    QiXi_TOP[5]:SetProperty("HoverImage", QiXi_PIC[14].HoverImage);--�ƶ���ͼ����
    QiXi_TOP[5]:Show()

    --��5
    QiXi_TOP[6]:SetProperty("PushedImage", QiXi_PIC[15].PushedImage);--���״̬
    QiXi_TOP[6]:SetProperty("NormalImage", QiXi_PIC[15].NormalImage); --����״̬
    QiXi_TOP[6]:SetProperty("HoverImage", QiXi_PIC[15].HoverImage);--�ƶ���ͼ����
    QiXi_TOP[6]:Show()

    for i = 1, QXQQ_num do    
        QiXi_BUTTONS[i]:SetProperty("PushedImage", QiXi_PIC[QXQQ_table[i]].PushedImage);--���״̬
        QiXi_BUTTONS[i]:SetProperty("NormalImage", QiXi_PIC[QXQQ_table[i]].NormalImage); --����״̬
        QiXi_BUTTONS[i]:SetProperty("HoverImage", QiXi_PIC[QXQQ_table[i]].HoverImage);--�ƶ���ͼ����
        QiXi_BUTTONS[i]:Show()
    end
    --ʵʱ�������ʣ��ɫ������
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
    --����ÿ����ͼ��
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

--��6��10λMDת����30��2λ����
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
            PushDebugMessage("�����������������⡣")
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
    --������
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
        if Get_XParam_STR(0) == "REFRESH_SHOW" then --�����Ҳ�ͼ��
            if this:IsVisible() then
                local QXQQ_PRIZE = Get_XParam_INT(0)
                --�Ҳ����������
                QiXi_QueQiang_JinDuTiao(QXQQ_PRIZE)
            end
        else
            --����Ϧȵ�Ž���
            clean()
            g_objID = Get_XParam_INT(0)

            g_objCared = DataPool : GetNPCIDByServerID(tonumber(g_objID))
            if g_objCared == -1 then
                PushDebugMessage("server�����������������⡣")
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
            --��Ϧ�Ȼ��ȵ�Ż MD ÿ�ո��� �һ����������� ϡ��+��ͨ+ϡ��ɫ������ 654312
            --6:ϡ��ÿ�նһ� 5����ͨÿ�նһ� 43��ϡ��ɫ������2 21��ϡ��ɫ������1 7:�Ƿ���ȡ���� 8���Ƿ���������
            local QXQQ_PT = Get_XParam_INT(7)
            --6:ϡ��ÿ�նһ� 5����ͨÿ�նһ� 43��ϡ��ɫ������2 21��ϡ��ɫ������1
            local QXQQ_XY = Get_XParam_INT(8)
            ----��Ϧȵ��,������ȡ���
            --1:1�Ž�����ȡ 2:2�Ž�����ȡ 3:3�Ž�����ȡ 4:4�Ž�����ȡ --5:��������
            local QXQQ_PRIZE = Get_XParam_INT(9)

            ----�Ҳ����������
            QiXi_QueQiang_JinDuTiao(QXQQ_PRIZE)
            --�����������ɫ������
            QiXi_QueQiang_SetShuLiang(QXQQ_PT,QXQQ_XY)
            --�򿪽���
            QiXi_QueQiang_Open(QXQQ_11,QXQQ_12,QXQQ_21,QXQQ_22,QXQQ_31,QXQQ_32)
        end
    elseif ( event == "OBJECT_CARED_EVENT" and this:IsVisible() ) then
		if(tonumber(arg0) ~= g_objCared) then
			return
        end
        
		-- �����NPC�ľ������һ��������߱�ɾ�����Զ��ر�
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

--�򿪽���
function QiXi_QueQiang_Open(table11,table12,table21,table22,table31,table32)
    --��6��10λMDת����30��2λ����
    if SetSekuaiNum(table11,table12,table21,table22,table31,table32) == 0 then
        return
    end
    --����ÿ����ͼ��
    SetOpenSeKuai()
    --ʵʱ�������ʣ��ɫ������
    QiXi_QueQiang_NowShuLiang()

    -- -- --�����Ҳཱ����Ʒͼ��
    -- QiXi_PRICE[1]:SetProperty("BackImage","set:QiXi_QueQiao image:CircularTaskTool84_4")
    -- QiXi_PRICE[2]:SetProperty("BackImage","set:QiXi_QueQiao image:CircularTaskTool84_5")
    -- QiXi_PRICE[3]:SetProperty("BackImage","set:QiXi_QueQiao image:CircularTaskTool84_6")
    -- QiXi_PRICE[4]:SetProperty("BackImage","set:QiXi_QueQiao image:CircularTaskTool84_7")

    this:Show()

end

--���� 1 2 3 4 5 6_UP
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

--���� 1 2 3 4 5 6
function QiXi_QueQiang_GeneralBtn(index)
    PushEvent("CONFIRM_QIXI_QUEQIANG", "close")

    g_GeneralBtn_clicked = 1

    if XZnum[1] == index then
        XZnum[1] = 0
    else
        --�Ϸ�ѡ�еڼ�������
        XZnum[1] = index
        --�������Ŀǰ��ͼƬ
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

--��ת 2 3 4
function QiXi_QueQiang_GeneralRotate(index)
    PushEvent("CONFIRM_QIXI_QUEQIANG", "close")

    --��תʱ���Ϸ���ťͻ����
    for i = 1,6 do
        XZnum[1] = 0
        QiXi_TOP[i]:SetCheck(0) 
    end  

    xuanzhuan[index] = xuanzhuan[index] + 1
    if xuanzhuan[index] > xuanmax[index] then
        xuanzhuan[index] = xuanmin[index]
    end
    TOPnum[index] = xuanzhuan[index]

    QiXi_TOP[index]:SetProperty("PushedImage", QiXi_PIC[xuanzhuan[index]].PushedImage);--���״̬
    QiXi_TOP[index]:SetProperty("NormalImage", QiXi_PIC[xuanzhuan[index]].NormalImage); --����״̬
    QiXi_TOP[index]:SetProperty("HoverImage", QiXi_PIC[xuanzhuan[index]].HoverImage);--�ƶ���ͼ����
    QiXi_TOP[index]:Show()

end

--30��С����_UP
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

--30��С����
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

--�콱��� 1 2 3 4
function QiXi_QueQiang_Award(index)
    PushEvent("CONFIRM_QIXI_QUEQIANG", "close")

    --��ȡ����
    Clear_XSCRIPT()
        Set_XSCRIPT_ScriptID(891161)
        Set_XSCRIPT_Function_Name("GetPrize")
        Set_XSCRIPT_Parameter( 0, index )
        Set_XSCRIPT_ParamCount(1)
    Send_XSCRIPT()

end

--���ð�ť
function QiXi_QueQiang_Reset()
    PushEvent("CONFIRM_QIXI_QUEQIANG", "open")
end

--����
function QiXi_QueQiang_ResetOK()
    --�����仯��BOOL��Ϊ1
    g_BOOL = 1
    reset()
end

--����
function QiXi_QueQiang_Fill()
    PushEvent("CONFIRM_QIXI_QUEQIANG", "close")

    if QiXi_QueQiang_Check() == 0 then
        return
    end
    --�·�
    if XZnum[3] == 0 then
        PushDebugMessage("#{QXWH_20210616_61}") --����ѡ��Ҫ���и�������λ�á�
        return
    end
    --�Ϸ�
    if XZnum[1] == 0 then
        PushDebugMessage("#{QXWH_20210616_62}") --����ѡ��Ҫ�������ĸ��ס�
        return
    end

    if QXQQ_NOW[XZnum[1]] == 0 then
        PushDebugMessage("#{QXWH_20210616_05}") --��ǰ����ʣ���������㣬�����һ�����������
        return
    end

    QXQQ_table[XZnum[3]] = XZnum[2]
    QiXi_BUTTONS[XZnum[3]]:SetProperty("PushedImage", QiXi_PIC[QXQQ_table[XZnum[3]]].PushedImage);--���״̬
    QiXi_BUTTONS[XZnum[3]]:SetProperty("NormalImage", QiXi_PIC[QXQQ_table[XZnum[3]]].NormalImage); --����״̬
    QiXi_BUTTONS[XZnum[3]]:SetProperty("HoverImage", QiXi_PIC[QXQQ_table[XZnum[3]]].HoverImage);--�ƶ���ͼ����
    QiXi_BUTTONS[XZnum[3]]:Show()

    --ʵʱ�������ʣ��ɫ������
    QiXi_QueQiang_NowShuLiang()
    --�����仯��BOOL��Ϊ1
    g_BOOL = 1

    --����ǰ���״̬�����������MD�����MD
    local pushnum = QiXi_QueQiang_PUSH()
    local level = QiXi_QueQiang_Level(pushnum)
    if level > QXQQ_ManZu then
        --��ȡ����
        Clear_XSCRIPT()
            Set_XSCRIPT_ScriptID(891161)
            Set_XSCRIPT_Function_Name("UpdataMD")
            Set_XSCRIPT_Parameter(0,level)
            Set_XSCRIPT_ParamCount(1)
        Send_XSCRIPT()
    end

end

--���
function QiXi_QueQiang_Clear()
    PushEvent("CONFIRM_QIXI_QUEQIANG", "close")

    if QiXi_QueQiang_Check() == 0 then
        return
    end

    if XZnum[3] == 0 then
        PushDebugMessage("#{QXWH_20210616_88}") --����ѡ��Ҫ���и��������λ�á�
        return
    end

    QXQQ_table[XZnum[3]] = 0
    QiXi_BUTTONS[XZnum[3]]:SetProperty("PushedImage", QiXi_PIC[QXQQ_table[XZnum[3]]].PushedImage);--���״̬
    QiXi_BUTTONS[XZnum[3]]:SetProperty("NormalImage", QiXi_PIC[QXQQ_table[XZnum[3]]].NormalImage); --����״̬
    QiXi_BUTTONS[XZnum[3]]:SetProperty("HoverImage", QiXi_PIC[QXQQ_table[XZnum[3]]].HoverImage);--�ƶ���ͼ����
    QiXi_BUTTONS[XZnum[3]]:Show()

    PushDebugMessage("#{QXWH_20210616_68}") --��������ɹ���

    --�����仯��BOOL��Ϊ1
    g_BOOL = 1

    --ʵʱ�������ʣ��ɫ������
    QiXi_QueQiang_NowShuLiang()
end

--Help
function QiXi_QueQiang_Help()
    PushEvent("CONFIRM_QIXI_QUEQIANG", "close")
end

--Check
function QiXi_QueQiang_Check()

    --����
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

--�����������ɫ������
function QiXi_QueQiang_SetShuLiang(QXQQ_PT,QXQQ_XY)
    --21��΢�� 43������ 65������ 87��ϼ��
    QXQQ_OWN[4]  = math.floor(math.mod(QXQQ_PT/1000000,100)) 
    QXQQ_OWN[3]  = math.floor(math.mod(QXQQ_PT/10000,100))
    QXQQ_OWN[2]  = math.floor(math.mod(QXQQ_PT/100,100))
    QXQQ_OWN[1]  = math.floor(math.mod(QXQQ_PT/1,100))
    --43��ϡ��ɫ������2 21��ϡ��ɫ������1
    QXQQ_OWN[5]  = math.floor(math.mod(QXQQ_XY/1,100))
    QXQQ_OWN[6]  = math.floor(math.mod(QXQQ_XY/100,100))

end

--ʵʱ�������ʣ��ɫ������
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

--������
function QiXi_QueQiang_Save()
    
    local QXQQ_11 = QXQQ_table[1] * 100000000 + QXQQ_table[2] * 1000000 + QXQQ_table[3] * 10000 + QXQQ_table[4] * 100 + QXQQ_table[5] * 1
    local QXQQ_12 = QXQQ_table[6] * 100000000 + QXQQ_table[7] * 1000000 + QXQQ_table[8] * 10000 + QXQQ_table[9] * 100 + QXQQ_table[10] * 1
    local QXQQ_21 = QXQQ_table[11] * 100000000 + QXQQ_table[12] * 1000000 + QXQQ_table[13] * 10000 + QXQQ_table[14] * 100 + QXQQ_table[15] * 1
    local QXQQ_22 = QXQQ_table[16] * 100000000 + QXQQ_table[17] * 1000000 + QXQQ_table[18] * 10000 + QXQQ_table[19] * 100 + QXQQ_table[20] * 1
    local QXQQ_31 = QXQQ_table[21] * 100000000 + QXQQ_table[22] * 1000000 + QXQQ_table[23] * 10000 + QXQQ_table[24] * 100 + QXQQ_table[25] * 1
    local QXQQ_32 = QXQQ_table[26] * 100000000 + QXQQ_table[27] * 1000000 + QXQQ_table[28] * 10000 + QXQQ_table[29] * 100 + QXQQ_table[30] * 1

    --����MD
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

--��ȡ��ǰ�������
function QiXi_QueQiang_PUSH()
    local num = 0
    for i = 1, QXQQ_num do
        if QXQQ_table[i] ~= 0 then
            num = num + 1
        end    
    end
    return num
end

--������
function QiXi_QueQiang_JinDuTiao(NUM)

    --5:�������� 30101
    --1:1�Ž�����ȡ 2:2�Ž�����ȡ 3:3�Ž�����ȡ 4:4�Ž�����ȡ
    QXQQ_ManZu = math.floor(math.mod(NUM/10000,10))

    QXQQ_LINQU[1] = math.floor(math.mod(NUM/1000,10))
    QXQQ_LINQU[2] = math.floor(math.mod(NUM/100,10))
    QXQQ_LINQU[3] = math.floor(math.mod(NUM/10,10))
    QXQQ_LINQU[4] = math.floor(math.mod(NUM/1,10))
  
    for i = 1, 4 do
        --���Ѿ���ȡ���û�
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

--��ǰ����������
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