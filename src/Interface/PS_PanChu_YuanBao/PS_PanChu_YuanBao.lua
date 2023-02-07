-- 默认选择方式
local g_SelectType = -1

-- 盘出方式
local SALETYPE_MONEY = 0
local SALETYPE_YUANBAO = 1

-- 界面的默认相对位置
local g_PS_PanChu_YuanBao_Frame_UnifiedXPosition
local g_PS_PanChu_YuanBao_Frame_UnifiedYPosition

-- npc关注
local objCared = -1
local MAX_OBJ_DISTANCE = 3.0

--===============================================
-- PreLoad()
--===============================================
function PS_PanChu_YuanBao_PreLoad()
	this:RegisterEvent("PLAYERSHOP_PANCHU_INPUT_OPEN")
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("OBJECT_CARED_EVENT",false)
	this:RegisterEvent("PLAYERSHOP_PANCHU_INPUT_CLOSE")
	this:RegisterEvent("PS_CLOSE_SHOP_MAG")
end

--===============================================
-- OnLoad()
--===============================================
function PS_PanChu_YuanBao_OnLoad()
	-- 保存界面的默认相对位置
	g_PS_PanChu_YuanBao_Frame_UnifiedXPosition	= PS_PanChu_YuanBao_Frame : GetProperty("UnifiedXPosition")
	g_PS_PanChu_YuanBao_Frame_UnifiedYPosition	= PS_PanChu_YuanBao_Frame : GetProperty("UnifiedYPosition")
end

--===============================================
-- OnEvent
--===============================================
function PS_PanChu_YuanBao_OnEvent(event)
	-- 打开界面
	if(event == "PLAYERSHOP_PANCHU_INPUT_OPEN") then
		this:Show()			
		-- npc关注
		objCared = PlayerShop:GetNpcId()
		this:CareObject(objCared, 1, "PS_PanChu_YuanBao")
		-- 设置界面
		PS_PanChu_YuanBao_ChangeMode(SALETYPE_MONEY)--默认金币盘出方式
	end
	
	-- 游戏窗口尺寸发生了变化
	if (event == "ADJEST_UI_POS" ) then
		PS_PanChu_YuanBao_ResetPos()
	end
	
	-- 游戏分辨率发生了变化
	if (event == "VIEW_RESOLUTION_CHANGED") then
		PS_PanChu_YuanBao_ResetPos()
	end
	
	-- 离开npc关闭界面
	if ( event == "OBJECT_CARED_EVENT" )   then
		if(tonumber(arg0) ~= objCared) then
			return
		end		
		-- 如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			PS_PanChu_YuanBao_OnHiden()
		end	
	end
	
	-- 关闭界面
	if( event == "PLAYERSHOP_PANCHU_INPUT_CLOSE")	 then
		PS_PanChu_YuanBao_OnHiden()
	end
	
	-- 关闭界面
	if( event == "PS_CLOSE_SHOP_MAG")	 then
		PS_PanChu_YuanBao_OnHiden()
	end

end

--===============================================
-- 隐藏
--===============================================
function PS_PanChu_YuanBao_OnHiden()
	--变量重置
	g_SelectType = -1
	--控件清空
	PS_PanChu_YuanBao_Clear()
	--界面隐藏
	this:Hide()
	--取消关心
	this:CareObject(objCared, 0, "PS_PanChu_YuanBao")
end

--================================================
-- 恢复界面的默认相对位置
--================================================
function PS_PanChu_YuanBao_ResetPos()
	PS_PanChu_YuanBao_Frame : SetProperty("UnifiedXPosition", g_PS_PanChu_YuanBao_Frame_UnifiedXPosition)
	PS_PanChu_YuanBao_Frame : SetProperty("UnifiedYPosition", g_PS_PanChu_YuanBao_Frame_UnifiedYPosition)
end

--===============================================
-- 清空
--===============================================
function PS_PanChu_YuanBao_Clear()
	--文字内容清空
	PS_PanChu_YuanBao_Gold:SetText("")
	PS_PanChu_YuanBao_Silver:SetText("")
	PS_PanChu_YuanBao_CopperCoin:SetText("")
	PS_PanChu_YuanBao_InputYuanBao:SetText("")
	--光标默认位置
	PS_PanChu_YuanBao_Gold:SetProperty("DefaultEditBox", "False")
	PS_PanChu_YuanBao_Silver:SetProperty("DefaultEditBox", "False")	
	PS_PanChu_YuanBao_CopperCoin:SetProperty("DefaultEditBox", "False")
	PS_PanChu_YuanBao_InputYuanBao:SetProperty("DefaultEditBox", "False")	
	--确认按钮默认禁用
	PS_PanChu_YuanBao_Accept:Disable()	
end

--===============================================
-- 确定
--===============================================
function PS_PanChu_YuanBao_Accept_Clicked()
	--参数检测
	if g_SelectType ~= SALETYPE_MONEY and g_SelectType ~= SALETYPE_YUANBAO then
		return
	end

	--金币盘出
	if g_SelectType == SALETYPE_MONEY then
		local szGold = PS_PanChu_YuanBao_Gold:GetText()
		local szSilver = PS_PanChu_YuanBao_Silver:GetText()
		local szCopperCoin = PS_PanChu_YuanBao_CopperCoin:GetText()
		--在程序里头再检测输入字符的有效性和数值
		local bAvailability,nMoney = Bank:GetInputMoney(szGold,szSilver,szCopperCoin)		
		--什么情况下失败需要再定
		if(bAvailability == true) then
			--输入不合法
			if (tonumber(nMoney) < 1) then
				PS_PanChu_YuanBao_Gold:SetText("")
				PS_PanChu_YuanBao_Silver:SetText("")
				PS_PanChu_YuanBao_CopperCoin:SetText("")
				PS_PanChu_YuanBao_Gold:SetProperty("DefaultEditBox", "True")
				PushDebugMessage("盘出商店价格不能小于1铜，请重新输入")
				return
			elseif (tonumber(nMoney) > 100000000) then
				PS_PanChu_YuanBao_Gold:SetText("")
				PS_PanChu_YuanBao_Silver:SetText("")
				PS_PanChu_YuanBao_CopperCoin:SetText("")
				PS_PanChu_YuanBao_Gold:SetProperty("DefaultEditBox", "True")
				PushDebugMessage("盘出商店价格不能超过10000金，请重新输入")
				return
			end
			--确认盘出
			PlayerShop:Transfer("info", "sale", nMoney, g_SelectType)
			--关闭界面
			PS_PanChu_YuanBao_OnHiden()
		end
	elseif g_SelectType == SALETYPE_YUANBAO then
		local szYuanbao = PS_PanChu_YuanBao_InputYuanBao:GetText()
		--输入不合法
		if (tonumber(szYuanbao) < 1) then
			PS_PanChu_YuanBao_InputYuanBao:SetText("")
			PS_PanChu_YuanBao_InputYuanBao:SetProperty("DefaultEditBox", "True")		
			PushDebugMessage("盘出商店价格不能小于1元宝，请重新输入")
			return
		elseif (tonumber(szYuanbao) > 100000) then
			PS_PanChu_YuanBao_InputYuanBao:SetText("")
			PS_PanChu_YuanBao_InputYuanBao:SetProperty("DefaultEditBox", "True")		
			PushDebugMessage("盘出商店价格不能超过100000元宝，请重新输入")
			return
		end
		--确认盘出
		PlayerShop:Transfer("info", "sale", tonumber(szYuanbao), g_SelectType)
		--关闭界面
		PS_PanChu_YuanBao_OnHiden()		
	end
end

--===============================================
-- 取消
--===============================================
function PS_PanChu_YuanBao_Cancel_Clicked()
	PS_PanChu_YuanBao_OnHiden();
end

--===============================================
-- 输入改变
--===============================================
function PS_PanChu_YuanBao_ChangeMoney()	
	--金币盘出
	if g_SelectType == SALETYPE_MONEY then
		local szGold = PS_PanChu_YuanBao_Gold:GetText()
		local szSilver = PS_PanChu_YuanBao_Silver:GetText()
		local szCopperCoin = PS_PanChu_YuanBao_CopperCoin:GetText()		
		if szGold == "" and szSilver == "" and szCopperCoin == "" then
			PS_PanChu_YuanBao_Accept:Disable()
		else
			PS_PanChu_YuanBao_Accept:Enable()
		end
	--元宝盘出
	elseif g_SelectType == SALETYPE_YUANBAO then
		local szYuanbao = PS_PanChu_YuanBao_InputYuanBao:GetText()	
		if szYuanbao == "" then
			PS_PanChu_YuanBao_Accept:Disable()
		else
			PS_PanChu_YuanBao_Accept:Enable()
		end
	end
end

--===============================================
-- 选项改变
--===============================================
function PS_PanChu_YuanBao_ChangeMode(type)
	--参数检测
	if type ~= SALETYPE_MONEY and type ~= SALETYPE_YUANBAO then
		return
	end
	
	--模式设置
	if g_SelectType == type then
		return
	end
	g_SelectType = type
	
	--控件清空
	PS_PanChu_YuanBao_Clear()
		
	--状态修改
	if g_SelectType == SALETYPE_MONEY then
		--单选按钮
		PS_PanChu_YuanBao_YuanBao:SetCheck(0)
		PS_PanChu_YuanBao_Money:SetCheck(1)

		PS_PanChu_YuanBao_Gold:SetText("")
		PS_PanChu_YuanBao_Silver:SetText("")
		PS_PanChu_YuanBao_CopperCoin:SetText("")
		PS_PanChu_YuanBao_InputYuanBao:SetText("")
		--光标默认位置
		PS_PanChu_YuanBao_Gold:SetProperty("DefaultEditBox", "True")		
	elseif g_SelectType == SALETYPE_YUANBAO then
		--单选按钮
		PS_PanChu_YuanBao_Money:SetCheck(0)
		PS_PanChu_YuanBao_YuanBao:SetCheck(1)

		PS_PanChu_YuanBao_Gold:SetText("")
		PS_PanChu_YuanBao_Silver:SetText("")
		PS_PanChu_YuanBao_CopperCoin:SetText("")
		PS_PanChu_YuanBao_InputYuanBao:SetText("")
		--光标默认位置
		PS_PanChu_YuanBao_InputYuanBao:SetProperty("DefaultEditBox", "True")
	end
end
