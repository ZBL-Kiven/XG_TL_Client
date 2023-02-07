
local DuanWuCXN_Frame_UnifiedPosition;
local g_StartTime = 20220526
local g_EndTime = 20220608
local g_LimitLV = 30
local g_ZhenPinImageNULL = {}
local g_LiangPinImageNULL = {}
local g_ChoseButton = {}
local g_Tips = {}
local g_Reward = 
{
	[1] = {itemId = 20310168, num = 8, times = 5,},--金蚕丝*8
	[2] = {itemId = 50313004, num = 1, times = 10,},--红宝石3级
	[3] = {itemId = 20501003, num = 1, times = 20,},--3级棉布
	[4] = {itemId = 20502003, num = 1, times = 30,},--3级秘银
}
local g_Res = {0,0,0,0,0}
local g_Result = {
	[1] = {0,0,0},
	[2] = {0,0,0},
	[3] = {0,0,0},
	[4] = {0,0,0},
	[5] = {0,0,0},
}
local g_PlayerRes = {0,0,0}
local g_PlayerResult = {
	[1] = {0,0,0},
	[2] = {0,0,0},
	[3] = {0,0,0},
}
local g_RestTimes = 0
local g_Pic = {
	[1] = {image = "set:JiXiangNang03 image:AiYe", },
	[2] = {image = "set:JiXiangNang03 image:ChangPu", },
	[3] = {image = "set:JiXiangNang03 image:GeTeng", },
	[4] = {image = "set:JiXiangNang03 image:RenDong", },
	[5] = {image = "set:JiXiangNang03 image:BaiZhi", },
	[6] = {image = "set:JiXiangNang03 image:CangShu", },
}

local g_RewardButton = {}
local g_Total = 0
local g_PlayerChoose = {0,0,0,0,0,0}
local g_NeedTimes = {5,10,20,30}
local g_objCared = -1
local g_TargetId = -1
local MAX_OBJ_DISTANCE = 5
local g_ZhenPinAward = 38002572
local g_LiangPinAward = 38002571
local g_GuLiAward = 38002570
local g_MF = {0,0,0,0}
local g_CheckMask = {}
local g_DefaultPic = "set:JiXiangNang03 image:CaoYaoBK"
local g_RewardOK = {}
local g_RewardTxt = {}
--=========================================================
-- 注册窗口关心的所有事件
--=========================================================
function DuanWuCXN_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("ADJEST_UI_POS", false)
	this:RegisterEvent("OBJECT_CARED_EVENT", false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED", false)
	this:RegisterEvent( "HIDE_ON_SCENE_TRANSED" );		-- 离开场景

end

--=========================================================
-- 载入初始化
--=========================================================
function DuanWuCXN_OnLoad()
	g_ZhenPinImageNULL[1] = {}
	g_ZhenPinImageNULL[1][1] = DuanWuCXN_Todaylevel1_1
	g_ZhenPinImageNULL[1][2] = DuanWuCXN_Todaylevel1_2
	g_ZhenPinImageNULL[1][3] = DuanWuCXN_Todaylevel1_3
	g_ZhenPinImageNULL[2] = {}
	g_ZhenPinImageNULL[2][1] = DuanWuCXN_Todaylevel1_4
	g_ZhenPinImageNULL[2][2] = DuanWuCXN_Todaylevel1_5
	g_ZhenPinImageNULL[2][3] = DuanWuCXN_Todaylevel1_6

	g_LiangPinImageNULL[1] = {}
	g_LiangPinImageNULL[1][1] = DuanWuCXN_Todaylevel2_1
	g_LiangPinImageNULL[1][2] = DuanWuCXN_Todaylevel2_2
	g_LiangPinImageNULL[1][3] = DuanWuCXN_Todaylevel2_3
	g_LiangPinImageNULL[2] = {}
	g_LiangPinImageNULL[2][1] = DuanWuCXN_Todaylevel2_4
	g_LiangPinImageNULL[2][2] = DuanWuCXN_Todaylevel2_5
	g_LiangPinImageNULL[2][3] = DuanWuCXN_Todaylevel2_6
	g_LiangPinImageNULL[3] = {}
	g_LiangPinImageNULL[3][1] = DuanWuCXN_Todaylevel2_7
	g_LiangPinImageNULL[3][2] = DuanWuCXN_Todaylevel2_8
	g_LiangPinImageNULL[3][3] = DuanWuCXN_Todaylevel2_9

	g_ChoseButton[1] = DuanWuCXN_Down_1
	g_ChoseButton[2] = DuanWuCXN_Down_2
	g_ChoseButton[3] = DuanWuCXN_Down_3
	g_ChoseButton[4] = DuanWuCXN_Down_4
	g_ChoseButton[5] = DuanWuCXN_Down_5
	g_ChoseButton[6] = DuanWuCXN_Down_6

	g_RewardButton[1] = DuanWuCXN_PageIcon1Btn
	g_RewardButton[2] = DuanWuCXN_PageIcon2Btn
	g_RewardButton[3] = DuanWuCXN_PageIcon3Btn
	g_RewardButton[4] = DuanWuCXN_PageIcon4Btn

	g_Tips[1] = DuanWuCXN_PageIcon1BtnTips
	g_Tips[2] = DuanWuCXN_PageIcon2BtnTips
	g_Tips[3] = DuanWuCXN_PageIcon3BtnTips
	g_Tips[4] = DuanWuCXN_PageIcon4BtnTips

	g_RewardOK[1] = DuanWuCXN_PageIcon1BtnOK
	g_RewardOK[2] = DuanWuCXN_PageIcon2BtnOK
	g_RewardOK[3] = DuanWuCXN_PageIcon3BtnOK
	g_RewardOK[4] = DuanWuCXN_PageIcon4BtnOK

	g_RewardTxt[1] = DuanWuCXN_PageIcon1Text
	g_RewardTxt[2] = DuanWuCXN_PageIcon2Text
	g_RewardTxt[3] = DuanWuCXN_PageIcon3Text
	g_RewardTxt[4] = DuanWuCXN_PageIcon4Text

	g_CheckMask[1] = DuanWuCXN_Down_1OK
	g_CheckMask[2] = DuanWuCXN_Down_2OK
	g_CheckMask[3] = DuanWuCXN_Down_3OK
	g_CheckMask[4] = DuanWuCXN_Down_4OK
	g_CheckMask[5] = DuanWuCXN_Down_5OK
	g_CheckMask[6] = DuanWuCXN_Down_6OK

	DuanWuCXN_Frame_UnifiedPosition = DuanWuCXN_Frame:GetProperty("UnifiedPosition");

end

--=========================================================
-- 事件处理
--=========================================================
function DuanWuCXN_OnEvent(event)

	if (event == "UI_COMMAND" and tonumber(arg0) == 89115201) then --打开界面
		DuanWuCXN_Clear()
		DuanWuCXN_ShowAnimate:Hide()
		DuanWuCXN_ShowAnimate:Play(false)
		DuanWuCXN_ShowAnimate2:Hide()
		DuanWuCXN_ShowAnimate:Play(false)
		for i = 1, 5 do
			g_Res[i] = Get_XParam_INT(i - 1)
		end
		g_RestTimes = 3 - Get_XParam_INT(5)
		g_PlayerRes[1] = Get_XParam_INT(6)
		g_PlayerRes[2] = Get_XParam_INT(7)
		g_PlayerRes[3] = Get_XParam_INT(8)
		g_Total = Get_XParam_INT(9)
		g_TargetId = Get_XParam_INT(10)
		g_objCared = DataPool : GetNPCIDByServerID(g_TargetId)
		g_MF[1] = Get_XParam_INT(11)
		g_MF[2] = Get_XParam_INT(12)
		g_MF[3] = Get_XParam_INT(13)
		g_MF[4] = Get_XParam_INT(14)
		DuanWuCXN_ConvertRes()
		DuanWuCXN_ShowFrame()
		this:Show()

	elseif (event == "UI_COMMAND" and tonumber(arg0) == 89115202) then --刷新界面
		

		DuanWuCXN_Clear()
		DuanWuCXN_ShowAnimate:Hide()
		for i = 1, 5 do
			g_Res[i] = Get_XParam_INT(i - 1)
		end
		g_RestTimes = 3 - Get_XParam_INT(5)
		g_PlayerRes[1] = Get_XParam_INT(6)
		g_PlayerRes[2] = Get_XParam_INT(7)
		g_PlayerRes[3] = Get_XParam_INT(8)
		g_Total = Get_XParam_INT(9)
		g_TargetId = Get_XParam_INT(10)
		local class = Get_XParam_INT(11)
		if class == 1 or class == 2 then
			--播放动画 刷新界面
			DuanWuCXN_ShowAnimate3:Show()
			DuanWuCXN_ShowAnimate3:Play(true)
		elseif class >= 3 and class <=5 then
			DuanWuCXN_ShowAnimate2:Show()
			DuanWuCXN_ShowAnimate2:Play(true)
		else
			DuanWuCXN_ShowAnimate:Show()
			DuanWuCXN_ShowAnimate:Play(true)
		end
		g_objCared = DataPool : GetNPCIDByServerID(g_TargetId)
		DuanWuCXN_ConvertRes()
		DuanWuCXN_ShowFrame()
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 89115203) then --刷新界面
		g_MF[1] = Get_XParam_INT(0)
		g_MF[2] = Get_XParam_INT(1)
		g_MF[3] = Get_XParam_INT(2)
		g_MF[4] = Get_XParam_INT(3)

		for i = 1, 4 do
			g_Tips[i]:Hide()
			if g_Total >= g_NeedTimes[i] and g_MF[i] < 1 then
				g_Tips[i]:Show()
			end
			if g_MF[i] == 1 then
				g_RewardOK[i]:Show()
			end
		end
	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if(tonumber(arg0) ~= g_objCared) then
			return
		end
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			DuanWuCXN_OnClosed()
		end	
	elseif (event == "ADJEST_UI_POS" ) then
		DuanWuCXN_On_ResetPos()

	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		DuanWuCXN_On_ResetPos()
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		DuanWuCXN_OnClosed()
	end
end

function DuanWuCXN_Clear( )
	for i = 1, 6 do
		g_Res[i] = 0
		g_PlayerChoose[i] = 0
		g_ChoseButton[i]:SetCheck(0);
		g_CheckMask[i]:Hide()
	end

	for i = 1, 5 do
		for j = 1, 3 do
			g_Result[i][j] = 0
		end
	end
	for i = 1, 3 do
		for j = 1, 3 do
			g_PlayerResult[i][j] = 0
			g_LiangPinImageNULL[i][j]:Show()
			g_LiangPinImageNULL[i][j]:SetProperty("Image",g_DefaultPic);
			g_LiangPinImageNULL[i][j]:SetToolTip("#{DWCXN_20210508_55}")
		end
	end
	for i = 1, 3 do
		g_PlayerRes[i] = 0
	end
	for i = 1, 2 do
		for j = 1, 3 do
			g_ZhenPinImageNULL[i][j]:Show()
			g_ZhenPinImageNULL[i][j]:SetProperty("Image",g_DefaultPic);
			g_ZhenPinImageNULL[i][j]:SetToolTip("#{DWCXN_20210508_54}")
		end
	end
	for i = 1, 4 do
		g_Tips[i]:Hide()
		g_MF[i] = 0
		g_RewardOK[i]:Hide()
	end
end

	
--=========================================================
-- 界面控件数据
--=========================================================
function DuanWuCXN_ShowFrame()
	if g_objCared ~= -1 then
		this:CareObject(g_objCared, 0, "DuanWuCXN")
		this:CareObject(g_objCared, 1, "DuanWuCXN")
	else
		return
	end
	local itemAction = DataPool:CreateActionItemForShow(g_ZhenPinAward, 1)
	if itemAction:GetID() ~= 0 then
		DuanWuCXN_Todaylevel1_Award:SetActionItem( itemAction:GetID() );
	else
		DuanWuCXN_Todaylevel1_Award:SetActionItem( -1 );
	end

	itemAction = DataPool:CreateActionItemForShow(g_LiangPinAward, 1)
	if itemAction:GetID() ~= 0 then
		DuanWuCXN_Todaylevel2_Award:SetActionItem( itemAction:GetID() );
	else
		DuanWuCXN_Todaylevel2_Award:SetActionItem( -1 );
	end
	
	itemAction = DataPool:CreateActionItemForShow(g_GuLiAward, 1)
	if itemAction:GetID() ~= 0 then
		DuanWuCXN_Todaylevel3_Award:SetActionItem( itemAction:GetID() );
	else
		DuanWuCXN_Todaylevel3_Award:SetActionItem( -1 );
	end
	--显示珍品 玩家没猜的时候
	if g_RestTimes == 3 then
		g_LiangPinImageNULL[1][1]:SetProperty("Image",g_Pic[g_Result[3][1]].image)
		g_LiangPinImageNULL[2][1]:SetProperty("Image",g_Pic[g_Result[4][1]].image)
		g_LiangPinImageNULL[3][1]:SetProperty("Image",g_Pic[g_Result[5][1]].image)
	else--玩家猜了
		g_LiangPinImageNULL[1][1]:SetProperty("Image",g_Pic[g_Result[3][1]].image)
		g_LiangPinImageNULL[2][1]:SetProperty("Image",g_Pic[g_Result[4][1]].image)
		g_LiangPinImageNULL[3][1]:SetProperty("Image",g_Pic[g_Result[5][1]].image)
		local num = 0
		local idx = {0,0,0}
		for i = 1, 3 do
			num = 0
			for x = 1, 5 do
				num = 0
				for j = 1, 3 do
					for z = 1, 3 do
						if g_PlayerResult[i][j] == g_Result[x][z] then
							num = num + 1
							break
						end
					end	
					if num == 0 then
						break
					end
				end
				if num == 3 then
					idx[i] = x
					break
				end
			end
		end
		for y = 1, 3 do
			if idx[y] > 0 then
				--显示玩家猜对的
				if idx[y] <= 2 then
					g_ZhenPinImageNULL[idx[y]][1]:SetProperty("Image",g_Pic[g_Result[idx[y]][1]].image)
					g_ZhenPinImageNULL[idx[y]][2]:SetProperty("Image",g_Pic[g_Result[idx[y]][2]].image)
					g_ZhenPinImageNULL[idx[y]][3]:SetProperty("Image",g_Pic[g_Result[idx[y]][3]].image)
					g_ZhenPinImageNULL[idx[y]][1]:SetToolTip("")
					g_ZhenPinImageNULL[idx[y]][2]:SetToolTip("")
					g_ZhenPinImageNULL[idx[y]][3]:SetToolTip("")
				else
					local index = idx[y] - 2
					g_LiangPinImageNULL[index][1]:SetProperty("Image",g_Pic[g_Result[idx[y]][1]].image)
					g_LiangPinImageNULL[index][2]:SetProperty("Image",g_Pic[g_Result[idx[y]][2]].image)
					g_LiangPinImageNULL[index][3]:SetProperty("Image",g_Pic[g_Result[idx[y]][3]].image)
					g_LiangPinImageNULL[index][1]:SetToolTip("")
					g_LiangPinImageNULL[index][2]:SetToolTip("")
					g_LiangPinImageNULL[index][3]:SetToolTip("")
				end
			end
		end
		
	end
	for i = 1, 4 do
		local itemAction = DataPool:CreateBindActionItemForShow(g_Reward[i].itemId, g_Reward[i].num)
		if itemAction:GetID() ~= 0 then
			g_RewardButton[i]:SetActionItem( itemAction:GetID() );
		else
			g_RewardButton[i]:SetActionItem( -1 );
		end
		if g_Total >= g_NeedTimes[i] and g_MF[i] < 1 then
			g_Tips[i]:Show()
		end
		if g_MF[i] == 1 then
			g_RewardOK[i]:Show()
		end
		local rtxt = ScriptGlobal_Format("#{DWCXN_20210508_42}", tostring(g_NeedTimes[i]))
		g_RewardTxt[i]:SetText(rtxt)
	end
	if g_RestTimes > 0 then
		DuanWuCXN_ShowImage:SetProperty("Image", "set:JiXiangNang03 image:XiangNangKai")
	else
		DuanWuCXN_ShowImage:SetProperty("Image", "set:JiXiangNang03 image:XiangNangGuan")
	end

	local tipstr = ScriptGlobal_Format("#{DWCXN_20210508_45}", tostring(g_Total))
	DuanWuCXN_Down_TextNum:SetText(tipstr)
	if g_RestTimes ~= 0 then
		tipstr = ScriptGlobal_Format("#{DWCXN_20210508_31}", tostring(g_RestTimes), tostring(3))
	else
		tipstr = ScriptGlobal_Format("#{DWCXN_20210508_32}", tostring(g_RestTimes), tostring(3))
	end
	DuanWuCXN_Down_TextNum2:SetText(tipstr)
end


--=========================================================
-- 关闭界面
--=========================================================
function DuanWuCXN_OnClosed()
	if g_objCared ~= -1 then
		this:CareObject(g_objCared, 0, "DuanWuCXN")
		g_objCared = -1
	end
	DuanWuCXN_Clear()
	this:Hide()
	return
end


function DuanWuCXN_On_ResetPos()
  	DuanWuCXN_Frame:SetProperty("UnifiedPosition", DuanWuCXN_Frame_UnifiedPosition);
end


function DuanWuCXN_Select(idx)

	if idx <= 0 or idx > 6 then
		return
	end

	if g_PlayerChoose[idx] == 1 then
		g_CheckMask[idx]:Hide()
		g_PlayerChoose[idx] = 0
		--取消
		return
	end

	local sum = 0
	for i = 1, 6 do
		if g_PlayerChoose[i] == 1 then
			sum = sum + 1;
		end
	end
	if sum >= 3 then
		PushDebugMessage("#{DWCXN_20210508_30}")
		return 
	end

	if g_PlayerChoose[idx] == 0 then
		g_CheckMask[idx]:Show()
		g_PlayerChoose[idx] = 1
		--选择
	end
end

function DuanWuCXN_OnOKClick()

	local nCurDay = tonumber(DataPool:GetServerDayTime());
	if nCurDay < g_StartTime or nCurDay > g_EndTime then
		PushDebugMessage("#{DWCXN_20210508_8}")
		return 
	end

	local nLevel = Player:GetData("LEVEL")
	if nLevel < g_LimitLV  then
		PushDebugMessage("#{DWCXN_20210508_9}")
		return
	end

	local total = 0
	local choose = {0,0,0}
	for i = 1, 6 do
		if g_PlayerChoose[i] == 1 then
			total = total + 1
			choose[total] = i
		end
	end
	if total ~= 3 then
		PushDebugMessage("#{DWCXN_20210508_35}")
		return
	end

	if g_RestTimes <= 0 then
		PushDebugMessage("#{DWCXN_20210508_34}")
		return
	end

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("DuiJiang")
		Set_XSCRIPT_ScriptID(891152)
		Set_XSCRIPT_Parameter(0, g_TargetId)
		Set_XSCRIPT_Parameter(1, choose[1])
		Set_XSCRIPT_Parameter(2, choose[2])
		Set_XSCRIPT_Parameter(3, choose[3])
		Set_XSCRIPT_ParamCount(4)
	Send_XSCRIPT()
	--DuanWuCXN_ShowAnimate4:Show()
end

function DuanWuCXN_OnRewardClick(idx)
	
	if idx <= 0 or idx > 5 then

		return 
	end

	local nCurDay = tonumber(DataPool:GetServerDayTime());
	if nCurDay < g_StartTime or nCurDay > g_EndTime then
		PushDebugMessage("#{DWCXN_20210508_8}")
		DuanWuCXN_OnClosed()
		return 
	end

	local nLevel = Player:GetData("LEVEL")
	if nLevel < g_LimitLV  then
		PushDebugMessage("#{DWCXN_20210508_9}")
		return
	end

	if g_MF[idx] == 1 then
		PushDebugMessage("#{DWCXN_20210508_41}")
		return
	end

	if g_Total < g_NeedTimes[idx] then
		PushDebugMessage(ScriptGlobal_Format("#{DWCXN_20210508_44}", tostring(g_NeedTimes[idx])))
		return
	end

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("GetReward")
		Set_XSCRIPT_ScriptID(891152)
		Set_XSCRIPT_Parameter(0, g_TargetId)
		Set_XSCRIPT_Parameter(1, idx)
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()

end

function DuanWuCXN_OnHiden()
	DuanWuCXN_OnClosed()
end

function DuanWuCXN_ConvertRes()
	for i = 1, 5 do
		g_Result[i][1] = math.floor(g_Res[i]/100)
		g_Result[i][2] = math.floor(math.mod(g_Res[i]/10, 10))
		g_Result[i][3] = math.floor(math.mod(g_Res[i], 10))
	end
	for i = 1, 3 do
		g_PlayerResult[i][1] = math.floor(g_PlayerRes[i]/100)
		g_PlayerResult[i][2] = math.floor(math.mod(g_PlayerRes[i]/10, 10))
		g_PlayerResult[i][3] = math.floor(math.mod(g_PlayerRes[i], 10))
	end
end