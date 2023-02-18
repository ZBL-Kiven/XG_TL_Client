-- --******************************************************************************
-- --
-- -- 织云锦绣会春风界面 by 熊嘉程
-- --
-- --******************************************************************************

local g_Frame_UnifiedPosition
local UI_Command_S = 89301101

local g_objID = -1
local g_objCared = -1
local MAX_OBJ_DISTANCE = 3.0

--图片
local SpringFestival_PIC = {}
--动画
local SpringFestivals_Animation = {}

--云丝
local SpringFestival_needitem = 38000128
local SpringFestival_needitem_Bind = 38000127
local Need_count = 0
local ZhiXiu_Num = 0
local Get_Prize = 0
local Animation_Flag = 0

-- --******************************************************************************

function SpringFestival_NewClothes_PreLoad()

	-- 注册事件
	this:RegisterEvent("UI_COMMAND")
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	-- 离开场景
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)	
	-- OBJECT_CARED
	this:RegisterEvent("OBJECT_CARED_EVENT",false)

	this:RegisterEvent("PACKAGE_ITEM_CHANGED")
end

function SpringFestival_NewClothes_OnLoad()

	g_Frame_UnifiedPosition	= SpringFestival_NewClothes_Frame:GetProperty("UnifiedPosition")

	SpringFestival_PIC[1] = SpringFestival_NewClothes_Image1
	SpringFestival_PIC[2] = SpringFestival_NewClothes_Image2
	SpringFestival_PIC[3] = SpringFestival_NewClothes_Image3
	SpringFestival_PIC[4] = SpringFestival_NewClothes_Image4
	SpringFestival_PIC[5] = SpringFestival_NewClothes_Image5
	SpringFestival_PIC[6] = SpringFestival_NewClothes_Image6

	SpringFestivals_Animation[1] = SpringFestival_NewClothes_Animation2
	SpringFestivals_Animation[2] = SpringFestival_NewClothes_Animation2
	SpringFestivals_Animation[3] = SpringFestival_NewClothes_Animation3
	SpringFestivals_Animation[4] = SpringFestival_NewClothes_Animation4
	SpringFestivals_Animation[5] = SpringFestival_NewClothes_Animation5
	SpringFestivals_Animation[6] = SpringFestival_NewClothes_Animation6

end

function SpringFestival_NewClothes_OnEvent( event )

	if ( event == "UI_COMMAND" and tonumber(arg0) == UI_Command_S ) then --xjc1 打开界面

		SpringFestival_NewClothes_Clean()

		g_objID = Get_XParam_INT(0)

		g_objCared = DataPool : GetNPCIDByServerID(tonumber(g_objID))
		if g_objCared == -1 then
			PushDebugMessage("server传过来的数据有问题。")
			return
		end
		if nil ~= g_objCared and g_objCared > 0 then
			this:CareObject(g_objCared, 1, "SpringFestival_NewClothes")
		end

		Need_count = Get_XParam_INT(1) --拥有锦绣云丝
		ZhiXiu_Num = Get_XParam_INT(2) --当前已织绣
		Get_Prize =  Get_XParam_INT(3) --领取奖励
		Animation_Flag = Get_XParam_INT(4) --领取奖励

		SpringFestival_NewClothes_Set(Need_count, ZhiXiu_Num, Get_Prize, Animation_Flag)

		this:Show()
	elseif ( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() ) then
		local nGemCount_1 = PlayerPackage:Lua_GetUnLockItemCount(SpringFestival_needitem)
		local nGemCount_2 = PlayerPackage:Lua_GetUnLockItemCount(SpringFestival_needitem_Bind)
		local nGemCount = nGemCount_1 + nGemCount_2
		SpringFestival_NewClothes_Text1:SetText( ScriptGlobal_Format("#{ZYJX_211124_11}", nGemCount)) --拥有锦绣云丝：%s0个

	elseif( event == "ADJEST_UI_POS" ) then
		SpringFestival_NewClothes_ResetPos()

	elseif( event == "VIEW_RESOLUTION_CHANGED" ) then
		SpringFestival_NewClothes_ResetPos()

	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		SpringFestival_NewClothes_Close()

	elseif ( event == "OBJECT_CARED_EVENT" and this:IsVisible() ) then
		if(tonumber(arg0) ~= g_objCared) then
			return
        end
        
		-- 如果和NPC的距离大于一定距离或者被删除，自动关闭
        if(arg1 == "distance" and tonumber(arg2) > MAX_OBJ_DISTANCE or arg1=="destroy") then
            SpringFestival_NewClothes_Close()
        end
		
	end

end

--================================================
-- 默认相对位置
--================================================
function SpringFestival_NewClothes_ResetPos()

	SpringFestival_NewClothes_Frame:SetProperty("UnifiedPosition", g_Frame_UnifiedPosition)

end

-- 窗口关闭
function SpringFestival_NewClothes_Close()

	if nil ~= g_objCared and g_objCared > 0 then
		this:CareObject(g_objCared, 0, "SpringFestival_NewClothes")
    end
	
	SpringFestival_NewClothes_Clean()

	this:Hide()

end

function SpringFestival_NewClothes_Click(index)

	if index == 1 then
		--织绣
		Clear_XSCRIPT()
			Set_XSCRIPT_ScriptID(893011)
			Set_XSCRIPT_Function_Name("ZhiXiu")
			Set_XSCRIPT_Parameter( 0, g_objID )
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
	elseif index == 2 then
		--领取奖励
		Clear_XSCRIPT()
			Set_XSCRIPT_ScriptID(893011)
			Set_XSCRIPT_Function_Name("GetPrize")
			Set_XSCRIPT_Parameter( 0, g_objID )
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
	else
		--预览
		-- PushDebugMessage("  ")
	end

end

function SpringFestival_NewClothes_Clean()

	Need_count = 0
	ZhiXiu_Num = 0
	Get_Prize = 0
	Animation_Flag = 0

	SpringFestival_PIC[1]:Show()
	SpringFestival_PIC[2]:Hide()
	SpringFestival_PIC[3]:Hide()
	SpringFestival_PIC[4]:Hide()
	SpringFestival_PIC[5]:Hide()
	SpringFestival_PIC[6]:Hide()

	SpringFestivals_Animation[1]:Play(false)
	SpringFestivals_Animation[2]:Play(false)
	SpringFestivals_Animation[3]:Play(false)
	SpringFestivals_Animation[4]:Play(false)
	SpringFestivals_Animation[5]:Play(false)
	SpringFestivals_Animation[6]:Play(false)

	local itemAction = DataPool:CreateActionItemForShow(SpringFestival_needitem_Bind, 1)
	if itemAction:GetID() ~= 0 then
		SpringFestival_NewClothes_Right_Item1:SetActionItem( itemAction:GetID() );
	else
		SpringFestival_NewClothes_Right_Item1:SetActionItem( -1 );
	end
	
	SpringFestival_NewClothes_Text1:SetText( ScriptGlobal_Format("#{ZYJX_211124_11}", 0)) --拥有锦绣云丝：%s0个
	SpringFestival_NewClothes_Text2:SetText( ScriptGlobal_Format("#{ZYJX_211124_12}", 0)) --您当前已织绣：%s0次

	SpringFestival_NewClothes_Button1:Show()
	SpringFestival_NewClothes_Button2:Hide()
	SpringFestival_NewClothes_Received:Hide()

	--SpringFestival_NewClothes_Button3:Show()
end

--界面设置
function SpringFestival_NewClothes_Set(count, Num, Flag, Animation_Flag)
	--count 拥有锦绣云丝 --Num 当前已织绣 --Flag 领取奖励
	SpringFestival_NewClothes_Text1:SetText( ScriptGlobal_Format("#{ZYJX_211124_11}", count)) --拥有锦绣云丝：%s0个
	SpringFestival_NewClothes_Text2:SetText( ScriptGlobal_Format("#{ZYJX_211124_12}", Num)) --您当前已织绣：%s0次
	
	local Test = Num + 1
	if Test > 6 then
		Test = 6
	elseif Test < 1 then
		Test = 1
	end

	for i = 1, 6 do
		if i == Test then
			SpringFestival_PIC[i]:Show()
			if i ~= 1 and Animation_Flag == 1 then
				SpringFestivals_Animation[i]:Play(true)
			else
				SpringFestivals_Animation[i]:Play(false)
			end	
		else
			SpringFestival_PIC[i]:Hide()
			SpringFestivals_Animation[i]:Play(false)
		end    
	end

	--织绣5次以上，显示领取界面
	if Num >= 5 then
		SpringFestival_NewClothes_Button1:Hide() --织绣按钮
		SpringFestival_NewClothes_Button2:Show() --领奖界面
		SpringFestival_NewClothes_Received:Hide() --已领取
	end

	--已领取，显示已领取界面
	if Flag > 0 then
		SpringFestival_NewClothes_Button1:Hide() --织绣按钮
		SpringFestival_NewClothes_Button2:Hide() --领奖界面
		SpringFestival_NewClothes_Received:Show() --已领取
	end

end