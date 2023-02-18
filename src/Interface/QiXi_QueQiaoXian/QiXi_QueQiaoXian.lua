--七夕鹊桥
--
--
--界面数据

local g_QiXi_QueQiaoXian_Frame_UnifiedPosition
local g_UICOMMAND = 89116101
local g_objCared = -1
local g_objID = -1
local MAX_OBJ_DISTANCE = 3.0

--OnLoad数据
local QiXi_Bridge_Disabled = {} --1X8格子 未解锁
local QiXi_Bridge_Normal = {} --1X8格子 普通鸟
local QiXi_Bridge_Advanced = {} --1X8格子 高级鸟
local QiXi_Bridge_Advanced_Animate = {} --1X8格子 高级鸟 动画
local QiXi_QueQiaoXian_EXP_Animate = {} --特效暴击

local QiXi_QueQiaoXian_Award_Kuang  = {} --奖励框框
local QiXi_QueQiaoXian_Award_Animate = {} --奖励动画
local QiXi_QueQiaoXian_Award_OK = {} --奖励OK

--活动时间
local starttime = 20210805
local endtime = 20210818

function QiXi_QueQiaoXian_PreLoad()
    this:RegisterEvent("UI_COMMAND",true)
    this:RegisterEvent("OBJECT_CARED_EVENT",false)
	this:RegisterEvent("ADJEST_UI_POS",false)
    this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
    this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
end

function QiXi_QueQiaoXian_OnLoad()
    g_QiXi_QueQiaoXian_Frame_UnifiedPosition = QiXi_QueQiaoXian_Frame:GetProperty("UnifiedPosition")

    --1X8格子 未解锁
	QiXi_Bridge_Disabled[1]	= QiXi_QueQiaoXian_Bridge1_Disabled
	QiXi_Bridge_Disabled[2]	= QiXi_QueQiaoXian_Bridge2_Disabled
	QiXi_Bridge_Disabled[3]	= QiXi_QueQiaoXian_Bridge3_Disabled
	QiXi_Bridge_Disabled[4]	= QiXi_QueQiaoXian_Bridge4_Disabled
	QiXi_Bridge_Disabled[5]	= QiXi_QueQiaoXian_Bridge5_Disabled
	QiXi_Bridge_Disabled[6]	= QiXi_QueQiaoXian_Bridge6_Disabled
    QiXi_Bridge_Disabled[7]	= QiXi_QueQiaoXian_Bridge7_Disabled
    QiXi_Bridge_Disabled[8]	= QiXi_QueQiaoXian_Bridge8_Disabled

    --1X8格子 普通鸟
	QiXi_Bridge_Normal[1]	= QiXi_QueQiaoXian_Bridge1_Normal
	QiXi_Bridge_Normal[2]	= QiXi_QueQiaoXian_Bridge2_Normal
	QiXi_Bridge_Normal[3]	= QiXi_QueQiaoXian_Bridge3_Normal
	QiXi_Bridge_Normal[4]	= QiXi_QueQiaoXian_Bridge4_Normal
	QiXi_Bridge_Normal[5]	= QiXi_QueQiaoXian_Bridge5_Normal
	QiXi_Bridge_Normal[6]	= QiXi_QueQiaoXian_Bridge6_Normal
    QiXi_Bridge_Normal[7]	= QiXi_QueQiaoXian_Bridge7_Normal
    QiXi_Bridge_Normal[8]	= QiXi_QueQiaoXian_Bridge8_Normal
    
    --1X8格子 高级鸟
	QiXi_Bridge_Advanced[1]	= QiXi_QueQiaoXian_Bridge1_Advanced
	QiXi_Bridge_Advanced[2]	= QiXi_QueQiaoXian_Bridge2_Advanced
	QiXi_Bridge_Advanced[3]	= QiXi_QueQiaoXian_Bridge3_Advanced
	QiXi_Bridge_Advanced[4]	= QiXi_QueQiaoXian_Bridge4_Advanced
	QiXi_Bridge_Advanced[5]	= QiXi_QueQiaoXian_Bridge5_Advanced
	QiXi_Bridge_Advanced[6]	= QiXi_QueQiaoXian_Bridge6_Advanced
    QiXi_Bridge_Advanced[7]	= QiXi_QueQiaoXian_Bridge7_Advanced
    QiXi_Bridge_Advanced[8]	= QiXi_QueQiaoXian_Bridge8_Advanced
    
    --1X8格子 高级鸟 动画
    QiXi_Bridge_Advanced_Animate[1] = QiXi_QueQiaoXian_Bridge1_AdvancedAnimate
    QiXi_Bridge_Advanced_Animate[2] = QiXi_QueQiaoXian_Bridge2_AdvancedAnimate
    QiXi_Bridge_Advanced_Animate[3] = QiXi_QueQiaoXian_Bridge3_AdvancedAnimate
    QiXi_Bridge_Advanced_Animate[4] = QiXi_QueQiaoXian_Bridge4_AdvancedAnimate
    QiXi_Bridge_Advanced_Animate[5] = QiXi_QueQiaoXian_Bridge5_AdvancedAnimate
    QiXi_Bridge_Advanced_Animate[6] = QiXi_QueQiaoXian_Bridge6_AdvancedAnimate
    QiXi_Bridge_Advanced_Animate[7] = QiXi_QueQiaoXian_Bridge7_AdvancedAnimate
    QiXi_Bridge_Advanced_Animate[8] = QiXi_QueQiaoXian_Bridge8_AdvancedAnimate

    --特效暴击
    QiXi_QueQiaoXian_EXP_Animate[1] = QiXi_QueQiaoXian_EXP1_Animate
    QiXi_QueQiaoXian_EXP_Animate[2] = QiXi_QueQiaoXian_EXP2_Animate
    QiXi_QueQiaoXian_EXP_Animate[3] = QiXi_QueQiaoXian_EXP3_Animate
    QiXi_QueQiaoXian_EXP_Animate[4] = QiXi_QueQiaoXian_EXP4_Animate
    QiXi_QueQiaoXian_EXP_Animate[5] = QiXi_QueQiaoXian_EXP5_Animate
    QiXi_QueQiaoXian_EXP_Animate[6] = QiXi_QueQiaoXian_EXP6_Animate
    QiXi_QueQiaoXian_EXP_Animate[7] = QiXi_QueQiaoXian_EXP7_Animate
    QiXi_QueQiaoXian_EXP_Animate[8] = QiXi_QueQiaoXian_EXP8_Animate

    --奖励框框
    QiXi_QueQiaoXian_Award_Kuang[1] = QiXi_QueQiaoXian_Award1
    QiXi_QueQiaoXian_Award_Kuang[2] = QiXi_QueQiaoXian_Award2
    QiXi_QueQiaoXian_Award_Kuang[3] = QiXi_QueQiaoXian_Award3
    QiXi_QueQiaoXian_Award_Kuang[4] = QiXi_QueQiaoXian_Award4

    --奖励动画
    QiXi_QueQiaoXian_Award_Animate[1] = QiXi_QueQiaoXian_Award1Animate
    QiXi_QueQiaoXian_Award_Animate[2] = QiXi_QueQiaoXian_Award2Animate
    QiXi_QueQiaoXian_Award_Animate[3] = QiXi_QueQiaoXian_Award3Animate
    QiXi_QueQiaoXian_Award_Animate[4] = QiXi_QueQiaoXian_Award4Animate

    --奖励OK
    QiXi_QueQiaoXian_Award_OK[1] = QiXi_QueQiaoXian_Award1OK
    QiXi_QueQiaoXian_Award_OK[2] = QiXi_QueQiaoXian_Award2OK 
    QiXi_QueQiaoXian_Award_OK[3] = QiXi_QueQiaoXian_Award3OK 
    QiXi_QueQiaoXian_Award_OK[4] = QiXi_QueQiaoXian_Award4OK  
end

function QiXi_QueQiaoXian_OnHiden()

    if nil ~= g_objCared and g_objCared > 0 then
		this:CareObject(g_objCared, 0, "QiXi_QueQiaoXian")
    end

    this:Hide()

end

function QiXi_QueQiaoXian_Close()
    QiXi_QueQiaoXian_OnHiden()
end

function QiXi_QueQiaoXian_ResetPos()
    QiXi_QueQiaoXian_Frame:SetProperty("UnifiedPosition", g_QiXi_QueQiaoXian_Frame_UnifiedPosition)
end

function QiXi_QueQiaoXian_OnEvent(event)
    if event == "UI_COMMAND" and tonumber(arg0) == g_UICOMMAND then
        --if Get_XParam_STR(0) == "REFRESH_SHOW" then --更新右侧图标
        --     if this:IsVisible() then

        --     end
        -- else
            --打开七夕鹊桥界面
            g_objID = Get_XParam_INT(0)

            g_objCared = DataPool : GetNPCIDByServerID(tonumber(g_objID))
            if g_objCared == -1 then
                PushDebugMessage("server传过来的数据有问题。")
                return
            end
            if nil ~= g_objCared and g_objCared > 0 then
                this:CareObject(g_objCared, 1, "QiXi_QueQiaoXian")
            end

            -- 1每日领取次数
            -- 2稀有色块数量
            -- 3普通色块数量
            -- 4已搭建进度条 -12345678
            -- 5已领取奖励 + 进度条进度 12
            local QXQQ_1 = Get_XParam_INT(1)
            local QXQQ_2 = Get_XParam_INT(2)
            local QXQQ_3 = Get_XParam_INT(3)
            local QXQQ_4 = Get_XParam_INT(4)
            local QXQQ_5 = Get_XParam_INT(5)

            --特效
            local QXQQ_6 = Get_XParam_INT(6)
            --第几个特效
            local QXQQ_7 = Get_XParam_INT(7)
            --是否为搭建打开
            local QXQQ_8 = Get_XParam_INT(8)

            --打开界面
            QiXi_QueQiaoXian_Open(QXQQ_1,QXQQ_2,QXQQ_3,QXQQ_4,QXQQ_5,QXQQ_6,QXQQ_7,QXQQ_8)

        --end
    elseif ( event == "OBJECT_CARED_EVENT" and this:IsVisible() ) then
		if(tonumber(arg0) ~= g_objCared) then
			return
        end
        
		-- 如果和NPC的距离大于一定距离或者被删除，自动关闭
        if(arg1 == "distance" and tonumber(arg2) > MAX_OBJ_DISTANCE or arg1=="destroy") then
            QiXi_QueQiaoXian_Close()
        end
    end

    if this:IsVisible() then
        if event == "ADJEST_UI_POS" or
			event == "VIEW_RESOLUTION_CHANGED" then
				QiXi_QueQiaoXian_ResetPos()
        elseif event == "HIDE_ON_SCENE_TRANSED" then
            QiXi_QueQiaoXian_OnHiden()
        end
    end
end

--1-4 领奖等级
function QiXi_QueQiaoXian_Award(Num)
    --1-4 领奖
    Clear_XSCRIPT()
        Set_XSCRIPT_ScriptID(891161)
        Set_XSCRIPT_Function_Name("LingJiang")
        Set_XSCRIPT_Parameter( 0, Num )
        Set_XSCRIPT_Parameter( 1, g_objID )
        Set_XSCRIPT_ParamCount(2)
    Send_XSCRIPT()
end

--普通搭建
function QiXi_QueQiaoXian_Normal_Clicked()
    --普通搭建
    Clear_XSCRIPT()
        Set_XSCRIPT_ScriptID(891161)
        Set_XSCRIPT_Function_Name("DaJian")
        Set_XSCRIPT_Parameter( 0, 1 )
        Set_XSCRIPT_Parameter( 1, g_objID )
        Set_XSCRIPT_ParamCount(2)
    Send_XSCRIPT()
end

--稀有搭建
function QiXi_QueQiaoXian_Advanced_Clicked()
    --稀有搭建
    Clear_XSCRIPT()
        Set_XSCRIPT_ScriptID(891161)
        Set_XSCRIPT_Function_Name("DaJian")
        Set_XSCRIPT_Parameter( 0, 2 )
        Set_XSCRIPT_Parameter( 1, g_objID )
        Set_XSCRIPT_ParamCount(2)
    Send_XSCRIPT()
end

--打开界面
-- 1每日领取次数
-- 2稀有色块数量
-- 3普通色块数量
-- 4已搭建进度条 -12345678
-- 5已领取奖励 + 进度条进度 12
function QiXi_QueQiaoXian_Open(table1,table2,table3,table4,table5,table6,table7,table8)

    --设置进度条和领奖按钮 table4 table5
    QiXi_QueQiaoXian_SetJinDuTiao(table4,table5,table8)
    --设置剩余浮阶数量 table2 table3
    QiXi_QueQiaoXian_SetFuJie(table2,table3)
    --特效暴击
    QiXi_QueQiaoXian_TeXiao(table6,table7)

    this:Show()

end

--设置进度条和领奖按钮 
--num1 已搭建进度条 -12345678
--num2 已领取奖励 + 进度条进度 12
function QiXi_QueQiaoXian_SetJinDuTiao(num1,num2,num3)
    
    local JiangLi    = math.floor(math.mod(num2/10,10)) --十位 已领取奖励
    local JinDuTiao  = math.floor(math.mod(num2/1,10))  --个位 进度条进度

    --已领取奖励
    QiXi_QueQiaoXian_LinQuPrize(JiangLi,JinDuTiao)

    --进度条染色
    QiXi_QueQiaoXian_JinDuTiao(JinDuTiao,num1,num3)

end

--设置剩余浮阶数量 2稀有色块数量 3普通色块数量
function QiXi_QueQiaoXian_SetFuJie(num2,num3)
    --纤云鹊剩余数量：%s0 --PT
    QiXi_QueQiaoXian_NormalToken:SetText(ScriptGlobal_Format("#{QXWH_20210616_89}",num3))
    --飞星鹊剩余数量：%s0 --XY
    QiXi_QueQiaoXian_AdvancedToken:SetText(ScriptGlobal_Format("#{QXWH_20210616_97}",num2))
end

--已领取奖励
function QiXi_QueQiaoXian_LinQuPrize(JiangLi,JinDuTiao)
    
    for i=1,4 do
        if i <= JiangLi then
            --奖励框框
            QiXi_QueQiaoXian_Award_Kuang[i]:Show()
            QiXi_QueQiaoXian_Award_Kuang[i]:Disable()
            --奖励动画
            QiXi_QueQiaoXian_Award_Animate[i]:Hide()
            QiXi_QueQiaoXian_Award_Animate[i]:Play(false)
            --奖励OK
            QiXi_QueQiaoXian_Award_OK[i]:Show()
        else
            --奖励框框
            QiXi_QueQiaoXian_Award_Kuang[i]:Show()
            QiXi_QueQiaoXian_Award_Kuang[i]:Enable()
            --奖励动画
            QiXi_QueQiaoXian_Award_Animate[i]:Hide()
            QiXi_QueQiaoXian_Award_Animate[i]:Play(false)
            --奖励OK
            QiXi_QueQiaoXian_Award_OK[i]:Hide()
        end
    end

    --0未领取 1号已领取 2号已领取 3号已领取 4号已领取
    for i = 1,4 do
        --0 1 2 3
        if JiangLi == i-1 then
            if JinDuTiao >= i*2 then
                --奖励动画
                QiXi_QueQiaoXian_Award_Animate[i]:Show()
                QiXi_QueQiaoXian_Award_Animate[i]:Play(true)
            end
        end
    end

end

--进度条染色
--num1 进度条进度 8
--num2 已搭建进度条 -12345678
function QiXi_QueQiaoXian_JinDuTiao(num1,num2,num3)

    local fenmu = {1,10,100,1000,10000,100000,1000000,10000000}

    for i = 1, 8 do

        if i <= num1 then
            local RanSe = math.floor(math.mod(num2/fenmu[i],10)) --十位
            if RanSe == 2 then
                --只有是搭建打开切是最后一个的时候
                if num3 == 1 and i == num1 then
                    --高级鸟
                    QiXi_Bridge_Disabled[i]:Hide()
                    QiXi_Bridge_Normal[i]:Hide()
                    QiXi_Bridge_Advanced[i]:Show()

                    QiXi_Bridge_Advanced_Animate[i]:Show()
                    QiXi_Bridge_Advanced_Animate[i]:Play(true)
                else
                    --高级鸟
                    QiXi_Bridge_Disabled[i]:Hide()
                    QiXi_Bridge_Normal[i]:Hide()
                    QiXi_Bridge_Advanced[i]:Show()

                    QiXi_Bridge_Advanced_Animate[i]:Hide()
                    QiXi_Bridge_Advanced_Animate[i]:Play(false)
                end
            else
                --普通鸟
                QiXi_Bridge_Disabled[i]:Hide()
                QiXi_Bridge_Normal[i]:Show()
                QiXi_Bridge_Advanced[i]:Hide()

                QiXi_Bridge_Advanced_Animate[i]:Hide()
                QiXi_Bridge_Advanced_Animate[i]:Play(false)
            end
        else
            --未解锁
            QiXi_Bridge_Disabled[i]:Show()
            QiXi_Bridge_Normal[i]:Hide()
            QiXi_Bridge_Advanced[i]:Hide()

            QiXi_Bridge_Advanced_Animate[i]:Hide()
            QiXi_Bridge_Advanced_Animate[i]:Play(false)
        end

    end
end

--特效暴击
function QiXi_QueQiaoXian_TeXiao(num1,num2)

    if num2 >=1 and num2 <= 8 then
        if num1 == 1 then
            QiXi_QueQiaoXian_EXP_Animate[num2]:Show()
            QiXi_QueQiaoXian_EXP_Animate[num2]:Play(true)
        else
            QiXi_QueQiaoXian_EXP_Animate[num2]:Hide()
            QiXi_QueQiaoXian_EXP_Animate[num2]:Play(false)
        end
    end

end