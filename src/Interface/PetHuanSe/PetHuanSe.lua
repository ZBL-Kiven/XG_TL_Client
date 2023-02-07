--附体幻色
--build 2019-7-28 14:55:16 逍遥子
--add 2019-9-26 23:18:45 逍遥子 新增瑞鹤附体
local g_Huanse_Select_IndexId = -1
local g_Huanse_Select_Index = -1
local g_Huanse_NeedMoney = 50000
local g_Huanse_Select_IndexIdMini = 1001--2001
local g_Huanse_Select_IndexIdMax = 10000
local g_Huanse_Frame_UnifiedXPosition
local g_Huanse_Frame_UnifiedYPosition
local g_Huanse_theNPC = -1
local g_Huanse_CurFitValue_Index = 4
--local g_Huanse_TipsTwice = 1

local g_Huanse_MaxTypeCount = 9     --类型上限值 2019-9-26 23:27:30 修正 新增瑞鹤附体
local g_Huanse_MaxColorCount = 9    --幻色上限值
local g_Huanse_CurColorIndex = -1   --当前选中的颜色图标下标

local g_InitState = 0
local g_NowPossVisual = 0

local g_Huanse_Huanse_IndexId = -1
--附体外形列表
local g_Huanse_PetPossModelList = {
	[1] = 0,	--附体：默认
	[2] = 0,	--附体：游龙
	[3] = 0,	--附体：幻蝶
	[4] = 0,	--附体：飞凤
	[5] = 0,	--附体：清羽
	[6] = 0,	--附体：霸魂
	[7] = 0,	--附体：锦麟
	[8] = 0,	--附体：灵鹊
	[9] = 0,	--附体：瑞鹤
}

--附体外形列表
local g_Huanse_IconVisList = {
	[1] = {[1]=1, [2]=0, [3]=0, [4]=0, [5]=0, [6]=0, [7]=0, [8]=0, [9]=0 },
	[2] = {[1]=0, [2]=0, [3]=0, [4]=0, [5]=0, [6]=0, [7]=0, [8]=0, [9]=0 },
	[3] = {[1]=0, [2]=0, [3]=0, [4]=0, [5]=0, [6]=0, [7]=0, [8]=0, [9]=0 },
	[4] = {[1]=0, [2]=0, [3]=0, [4]=0, [5]=0, [6]=0, [7]=0, [8]=0, [9]=0 },
	[5] = {[1]=0, [2]=0, [3]=0, [4]=0, [5]=0, [6]=0, [7]=0, [8]=0, [9]=0 },
	[6] = {[1]=0, [2]=0, [3]=0, [4]=0, [5]=0, [6]=0, [7]=0, [8]=0, [9]=0 },
	[7] = {[1]=0, [2]=0, [3]=0, [4]=0, [5]=0, [6]=0, [7]=0, [8]=0, [9]=0 },
	[8] = {[1]=0, [2]=0, [3]=0, [4]=0, [5]=0, [6]=0, [7]=0, [8]=0, [9]=0 },
	[9] = {[1]=0, [2]=0, [3]=0, [4]=0, [5]=0, [6]=0, [7]=0, [8]=0, [9]=0 },
}

--附体颜色图标列表
local g_Huanse_IconNameList = {
	[1] = {
		[1]="set:JSGX image:Mren", [2]="", [3]="", 
		[4]="", [5]="", [6]="", 
		[7]="", [8]="", [9]="" 
		},
	[2] = {
		[1]="set:JSGX image:Youlong0", [2]="set:JSGX image:Youlong1", [3]="set:JSGX image:Youlong2", 
		[4]="set:JSGX image:Youlong3", [5]="set:JSGX image:Youlong4", [6]="set:JSGX image:Youlong5", 
		[7]="set:JSGX image:Youlong6", [8]="set:JSGX image:Youlong7", [9]="set:JSGX image:Youlong8" 
		},
	[3] = {
		[1]="set:JSGX image:Huandie0", [2]="set:JSGX image:Huandie1", [3]="set:JSGX image:Huandie2", 
		[4]="set:JSGX image:Huandie3", [5]="set:JSGX image:Huandie4", [6]="set:JSGX image:Huandie5", 
		[7]="set:JSGX image:Huandie6", [8]="set:JSGX image:Huandie7", [9]="set:JSGX image:Huandie8" 
		},
	[4] = {
		[1]="set:JSGX image:Feifeng0", [2]="set:JSGX image:Feifeng1", [3]="set:JSGX image:Feifeng2", 
		[4]="set:JSGX image:Feifeng3", [5]="set:JSGX image:Feifeng4", [6]="set:JSGX image:Feifeng5", 
		[7]="set:JSGX image:Feifeng6", [8]="set:JSGX image:Feifeng7", [9]="set:JSGX image:Feifeng8" 
		},
	[5] = {
		[1]="set:JSGX image:Qingyu0", [2]="set:JSGX image:Qingyu1", [3]="set:JSGX image:Qingyu2", 
		[4]="set:JSGX image:Qingyu3", [5]="set:JSGX image:Qingyu4", [6]="set:JSGX image:Qingyu5", 
		[7]="set:JSGX image:Qingyu6", [8]="set:JSGX image:Qingyu7", [9]="set:JSGX image:Qingyu8" 
		},
	[6] = {
		[1]="set:JSGX image:Bahun0", [2]="set:JSGX image:Bahun1", [3]="set:JSGX image:Bahun2", 
		[4]="set:JSGX image:Bahun3", [5]="set:JSGX image:Bahun4", [6]="set:JSGX image:Bahun5", 
		[7]="set:JSGX image:Bahun6", [8]="set:JSGX image:Bahun7", [9]="set:JSGX image:Bahun8" 
		},
	[7] = {
		[1]="set:JSGX image:Jinli0", [2]="set:JSGX image:Jinli1", [3]="set:JSGX image:Jinli2", 
		[4]="set:JSGX image:Jinli3", [5]="set:JSGX image:Jinli4", [6]="set:JSGX image:Jinli5", 
		[7]="set:JSGX image:Jinli6", [8]="set:JSGX image:Jinli7", [9]="set:JSGX image:Jinli8" 
		},
	[8] = {
		[1]="set:JSGX image:LingQue0", [2]="set:JSGX image:LingQue1", [3]="set:JSGX image:LingQue2", 
		[4]="set:JSGX image:LingQue3", [5]="set:JSGX image:LingQue4", [6]="set:JSGX image:LingQue5", 
		[7]="set:JSGX image:LingQue6", [8]="set:JSGX image:LingQue7", [9]="set:JSGX image:LingQue8" 
		},
	[9] = {
		[1]="set:JSGX image:ShuangHe0", [2]="set:JSGX image:ShuangHe1", [3]="set:JSGX image:ShuangHe2", 
		[4]="set:JSGX image:ShuangHe3", [5]="set:JSGX image:ShuangHe4", [6]="set:JSGX image:ShuangHe7", 
		[7]="set:JSGX image:ShuangHe6", [8]="set:JSGX image:ShuangHe5", [9]="set:JSGX image:ShuangHe8" 
		},
}

--附体外形染色图标名称
local g_Huanse_IconList = {}

--附体外形染色蒙红图标名称
local g_Huanse_IconMaskList = {}

--附体外形染色动画图标名称
local g_Huanse_IconAniList = {}

--索引对应MD的位数
local g_Huanse_PetPossNameList = {
	[1] = "#{FTWX_110511_02}",	--附体：默认
	[2] = "#{FTWX_110511_03}",	--附体：游龙
	[3] = "#{FTWX_110511_04}",	--附体：幻蝶
	[4] = "#{FTWX_110511_05}",	--附体：飞凤
	[5] = "#{ZSHT_110301_03}",	--附体：清羽
	[6] = "#{FTHS_140417_01}",	--附体：霸魂
	[7] = "#{FTHS_150113_01}",	--附体：锦鳞
	[8] = "#{FTHS_150805_01}",	--附体：灵鹊
	[9] = "#{FTSH_190415_01}",	--附体：瑞鹤
}

--附体融合度列表
local PetHuanSe_CboSearchItem = 
	{
		[1] = "0~2",		--0~2
		[2] = "3~5",		--3~5
		[3] = "6~7",		--6~7
		[4] = "8~9",		--8~9
		[5] = "10",		    --10
	}

local g_PetHuanSeTbl = 
	{
		[1] = 0, 	--融合度：0-2
		[2] = 3, 	--融合度：3-5
		[3] = 6, 	--融合度：6-7
		[4] = 8, 	--融合度：8-9
		[5] = 10,	--融合度：10
	}

local g_Huanse_YBConfirm = 1

function PetHuanSe_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("UNIT_MONEY",false)
	this:RegisterEvent("MONEYJZ_CHANGE",false)
	this:RegisterEvent("PETPOSSSHOWUPDATE")
	this:RegisterEvent("ADJEST_UI_POS",false);
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false);
	--this:RegisterEvent("PETPOSSHUANSE_LIST")
	this:RegisterEvent("UPDATE_FAKE_OBJECT")
	this:RegisterEvent("RESET_ALLUI")				-- 返回登录界面, 重置所有UI
end

function PetHuanSe_OnLoad()


--附体外形染色图标名称
	g_Huanse_IconList[1] = PetHuanSe_Icon0
	g_Huanse_IconList[2] = PetHuanSe_Icon1
	g_Huanse_IconList[3] = PetHuanSe_Icon2
	g_Huanse_IconList[4] = PetHuanSe_Icon3
	g_Huanse_IconList[5] = PetHuanSe_Icon4
	g_Huanse_IconList[6] = PetHuanSe_Icon5
	g_Huanse_IconList[7] = PetHuanSe_Icon6
	g_Huanse_IconList[8] = PetHuanSe_Icon7
	g_Huanse_IconList[9] = PetHuanSe_Icon8


--附体外形染色蒙红图标名称
	g_Huanse_IconMaskList[1] = PetHuanSe_Mask0
	g_Huanse_IconMaskList[2] = PetHuanSe_Mask1
	g_Huanse_IconMaskList[3] = PetHuanSe_Mask2
	g_Huanse_IconMaskList[4] = PetHuanSe_Mask3
	g_Huanse_IconMaskList[5] = PetHuanSe_Mask4
	g_Huanse_IconMaskList[6] = PetHuanSe_Mask5
	g_Huanse_IconMaskList[7] = PetHuanSe_Mask6
	g_Huanse_IconMaskList[8] = PetHuanSe_Mask7
	g_Huanse_IconMaskList[9] = PetHuanSe_Mask8
	
--附体外形染色动画图标名称
	g_Huanse_IconAniList[1] = PetHuanSe_Animate0
	g_Huanse_IconAniList[2] = PetHuanSe_Animate1
	g_Huanse_IconAniList[3] = PetHuanSe_Animate2
	g_Huanse_IconAniList[4] = PetHuanSe_Animate3
	g_Huanse_IconAniList[5] = PetHuanSe_Animate4
	g_Huanse_IconAniList[6] = PetHuanSe_Animate5
	g_Huanse_IconAniList[7] = PetHuanSe_Animate6
	g_Huanse_IconAniList[8] = PetHuanSe_Animate7
	g_Huanse_IconAniList[9] = PetHuanSe_Animate8
	
	
	for i=1,g_Huanse_MaxColorCount do
		g_Huanse_IconList[i] : SetPushed(0)
		g_Huanse_IconList[i] : SetProperty("NormalImage","")
		g_Huanse_IconList[i] : SetProperty("HoverImage","")
		g_Huanse_IconList[i] : SetToolTip("")
		g_Huanse_IconMaskList[i] : SetProperty("Image", "")
		g_Huanse_IconMaskList[i] : SetToolTip("")
		g_Huanse_IconAniList[i] : SetProperty("Visible","False")
	end

	g_Huanse_Frame_UnifiedXPosition	= PetHuanSe_Frame:GetProperty("UnifiedXPosition");
    g_Huanse_Frame_UnifiedYPosition	= PetHuanSe_Frame:GetProperty("UnifiedYPosition");
    PetHuanSe_SearchMode:Disable()
end

function PetHuanSe_OnEvent(event)
	
	if (event == "UI_COMMAND" and tonumber(arg0) == 8893833) then  --获取附体外形MD列表
		--设置数据
		for i = 1, g_Huanse_MaxTypeCount do
			local tempmd = Get_XParam_STR(i - 1)
			if tempmd ~= nil and tempmd ~= "" then
				for j = 1, g_Huanse_MaxColorCount do
					if tonumber(string.sub(tempmd,j,j)) ~= 0 then
						g_Huanse_IconVisList[i][j] = 1
					end
				end
			end
		end
		--刷新列表
		PetHuanse_UpdateColorList()
	end

	if (event == "UI_COMMAND" and tonumber(arg0) == 8893832) then  --打开附体幻色界面
		--关闭关联界面
		if(IsWindowShow("PetPossJian")) then
			CloseWindow("PetPossJian", true);
		end	
		
		--关闭当前界面
		if this:IsVisible() and Get_XParam_INT(3) == 0 then
			if Get_XParam_INT(0) == -1 then		--关闭界面
				PetHuanSe_Close_Window()
			end
			return
		end
			
		if Get_XParam_INT(3) == 0 then
			--npc关联
			local npcObjId = Get_XParam_INT(0)	
			g_Huanse_theNPC = DataPool:GetNPCIDByServerID(npcObjId)
			if g_Huanse_theNPC == -1 then
				--PushDebugMessage("server传过来的数据有问题。")
				return
			end
			PetHuanSe_BeginCareObject()
		end
		
		--参数检测
		local md = Get_XParam_STR(0)--Get_XParam_INT(1)
		if md == nil then
			return
		end		
		local modelTypeId = Get_XParam_INT(2)
		if modelTypeId ~= nil then
			g_Huanse_Select_IndexId = modelTypeId
			g_Huanse_Select_Index = math.floor(g_Huanse_Select_IndexId/1000)--Pet:GetPetPossModelTypeById(g_Huanse_Select_IndexId)
		end
		
		g_NowPossVisual = Get_XParam_INT(4)
		--PetHuanSe_YuanBaoPay_Button:SetCheck(g_Huanse_YBConfirm)
		--显示界面
		this:Show()		
			
		--更新左侧列表
		PetHuanSe_UpdateList(md)
		
		--设置左侧列表默认项
		PetHuanSe_SelectFirstInList()
		
		--计算当前颜色值，不更新指定图标
		PetHuanse_UpdateColorIndex(0)
		--更新右侧颜色列表
		PetHuanse_UpdateColorList()
		
		--更新融合度列表
		PetHuanSe_SearchMode:ResetList()
		for i = 1, table.getn(PetHuanSe_CboSearchItem) do
			PetHuanSe_SearchMode:AddTextItem(PetHuanSe_CboSearchItem[i], i)
	    end
		PetHuanSe_SearchMode:SetCurrentSelect(4)
		
		PetHuanSe_FakeObject:SetFakeObject("")
		PetHuanSe_FakeObject:SetFakeObject("EquipChange_Player")
		--PushDebugMessage("g_Huanse_Select_IndexId"..g_Huanse_Select_IndexId)
		PetHuanSe_SearchMode_Changed()
		
		--更新金钱
		PetHuanSe_Money:SetProperty("MoneyNumber", g_Huanse_NeedMoney)
		local playerMoney = Player:GetData("MONEY")
		PetHuanSe_SelfMoney:SetProperty("MoneyNumber", playerMoney)
		local playerJZ = Player:GetData("MONEY_JZ")
		PetHuanSe_SelfJiaozi:SetProperty("MoneyNumber", playerJZ)
		
		--幻色确认标示
		--g_Huanse_TipsTwice = 1
		-- 向服务器发送刷新消息
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("OnUpdate")
			Set_XSCRIPT_ScriptID(889383)
			Set_XSCRIPT_ParamCount(0)
		Send_XSCRIPT()
	end	
	
	if (event == "UI_COMMAND" and tonumber(arg0) == 889822) then  --使用融魂丹刷新界面
		if this:IsVisible() then
			-- 向服务器发送刷新消息
			Clear_XSCRIPT()
				Set_XSCRIPT_Function_Name("OnUpdate")
				Set_XSCRIPT_ScriptID(889383)
				Set_XSCRIPT_ParamCount(0)
			Send_XSCRIPT()
		end
	end
	
	if tonumber(arg0) == 1000000062 and this:IsVisible() then
		LifeAbility:Wear_Equip_VisualID(Get_XParam_INT(0),Get_XParam_INT(1))
	end
	
	if (event == "UNIT_MONEY" and this:IsVisible()) then				
		PetHuanSe_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))		
	end
	
	if (event == "MONEYJZ_CHANGE" and this:IsVisible()) then
		PetHuanSe_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
	end
	
	if (event == "UI_COMMAND" and tonumber(arg0) == 1000000065 and this:IsVisible()) then				
		g_Huanse_Huanse_IndexId = Get_XParam_INT(0)
		local str
		str,g_Huanse_CurFitValue_Index = PetHuanSe_SearchMode:GetCurrentSelect()
							
		--计算当前颜色值，同时更新指定图标
		PetHuanse_UpdateColorIndex(1)
		--更新右侧颜色列表
		PetHuanse_UpdateColorList()
			
		if g_Huanse_CurFitValue_Index ~= -1 then
			g_Huanse_CurFitValue_Index = g_Huanse_CurFitValue_Index -1
			PetHuanSe_SearchMode:SetCurrentSelect(g_Huanse_CurFitValue_Index)
			PetHuanSe_SearchMode_Changed()
		end		

	end
	
	if( event == "UPDATE_FAKE_OBJECT" ) then	
		if( arg0 == "" and this:IsVisible() ) then
			PetHuanSe_SetFakeCamera()
		end
	end
	
	if( event == "ADJEST_UI_POS" ) then
		PetHuanSe_ResetPos()
	end

	if( event == "VIEW_RESOLUTION_CHANGED" ) then
		PetHuanSe_ResetPos()
	end
	
	if (event == "RESET_ALLUI") then				
		g_Huanse_YBConfirm = 1
	end
end

function PetHuanSe_ListBox_Selected()
	--获得列表选项
	g_Huanse_Select_Index = PetHuanSe_EquiptShapeList:GetFirstSelectItem()--选择的附体类型
	--参数有效性判断
	if g_Huanse_Select_Index <= 0 or g_Huanse_Select_Index > g_Huanse_MaxTypeCount then 
		return
	end
	--设置颜色值
	local value = 1--通过左侧的附体名称进行选择时，默认选中9个颜色中的第一个颜色	
	--初次登陆时默认选中角色已有的颜色（这里特殊处理了下，因为每次重置listbox选中项时会隐形调用这个函数导致颜色选取错误）
	if g_InitState == 1 then
		if g_Huanse_Select_IndexId >= g_Huanse_Select_IndexIdMini and  g_Huanse_Select_IndexId < g_Huanse_Select_IndexIdMax then
			value = math.mod(g_Huanse_Select_IndexId, 1000)
			g_InitState = 0
		end
	end
	PetHuanSe_ColorBox_Selected(value)
	
	--更新右侧颜色列表
	PetHuanse_UpdateColorList()
end

function PetHuanSe_ColorBox_Selected(value)
	--参数有效性判断
	if g_Huanse_Select_Index <= 0 or g_Huanse_Select_Index > g_Huanse_MaxTypeCount then 
		return
	end	
	if value <= 0 or value > g_Huanse_MaxColorCount then
		return
	end

	--原附体颜色取消选中
	if g_Huanse_CurColorIndex > 0 and g_Huanse_CurColorIndex <= g_Huanse_MaxColorCount then
		g_Huanse_IconList[g_Huanse_CurColorIndex]:SetPushed(0)
	end
		
	--计算附体外形值
	g_Huanse_CurColorIndex = value
	g_Huanse_Select_IndexId = g_Huanse_Select_Index * 1000 + g_Huanse_CurColorIndex

	--新附体颜色选中
	g_Huanse_IconList[g_Huanse_CurColorIndex]:SetPushed(1)
	
	--更新模型	
	if g_Huanse_Select_Index ~= -1 and g_Huanse_Select_IndexId >= g_Huanse_Select_IndexIdMini and  g_Huanse_Select_IndexId < g_Huanse_Select_IndexIdMax then
		PetHuanSe_SearchMode:SetCurrentSelect(4)
		PetHuanSe_SearchMode_Changed()
	end
end

function PetHuanse_UpdateColorIndex(flag)--只有在幻色成功时才会将flag置为1
	if flag == 0 then
			--参数有效性判断
			if g_Huanse_Select_Index <= 0 or g_Huanse_Select_Index > g_Huanse_MaxTypeCount then 
				return
			end	
			if g_Huanse_Select_IndexId < g_Huanse_Select_IndexIdMini or g_Huanse_Select_IndexId >= g_Huanse_Select_IndexIdMax then
				return
			end
		
			--计算颜色值
			g_Huanse_CurColorIndex = math.mod(g_Huanse_Select_IndexId, 1000)
			if g_Huanse_CurColorIndex <= 0 or g_Huanse_CurColorIndex > g_Huanse_MaxColorCount then 
				return
			end
			
			--附体颜色选中
			for i=1,g_Huanse_MaxColorCount do
				g_Huanse_IconList[i] : SetPushed(0)
				g_Huanse_IconAniList[i] : SetProperty("Visible","False")
			end
			g_Huanse_IconList[g_Huanse_CurColorIndex]:SetPushed(1)
	elseif flag == 1 then
			--计算颜色值
			g_Huanse_CurColorIndex = math.mod(g_Huanse_Huanse_IndexId, 1000)
			if g_Huanse_CurColorIndex <= 0 or g_Huanse_CurColorIndex > g_Huanse_MaxColorCount then 
				return
			end
			
			--更新可见性并点亮图标
			if g_Huanse_IconVisList[g_Huanse_Select_Index][g_Huanse_CurColorIndex] ~= 1 then
				--附体颜色选中
				g_Huanse_Select_IndexId = g_Huanse_Huanse_IndexId
				g_Huanse_Select_Index = math.floor(g_Huanse_Select_IndexId/1000)--Pet:GetPetPossModelTypeById(g_Huanse_Select_IndexId)
				for i=1,g_Huanse_MaxColorCount do
					g_Huanse_IconList[i] : SetPushed(0)
					g_Huanse_IconAniList[i] : SetProperty("Visible","False")
				end
				g_Huanse_IconList[g_Huanse_CurColorIndex]:SetPushed(1)
					
				g_Huanse_IconVisList[g_Huanse_Select_Index][g_Huanse_CurColorIndex] = 1
				g_Huanse_IconAniList[g_Huanse_CurColorIndex]:SetProperty("Visible","True")
				g_Huanse_IconAniList[g_Huanse_CurColorIndex]:Play(true)
			end
	end
end

function PetHuanse_UpdateColorList()
	--参数有效性判断
	if g_Huanse_Select_Index <= 0 or g_Huanse_Select_Index > g_Huanse_MaxTypeCount then 
		return
	end	
	if g_Huanse_Select_IndexId < g_Huanse_Select_IndexIdMini or g_Huanse_Select_IndexId >= g_Huanse_Select_IndexIdMax then
		return
	end
	
	--隐藏图标
	for i=1, g_Huanse_MaxColorCount do
		g_Huanse_IconList[i] : SetProperty("NormalImage","")
		g_Huanse_IconList[i] : SetProperty("HoverImage","")
		g_Huanse_IconList[i] : SetToolTip("")
		g_Huanse_IconList[i] : SetProperty("Visible","False")
		g_Huanse_IconMaskList[i] : SetToolTip("")
		g_Huanse_IconMaskList[i] : SetProperty("Image", "")
	end	
	
	--显示图标
	local curCount = 0
	if g_Huanse_Select_Index == 1 then
		curCount = 1
	else
		curCount = g_Huanse_MaxColorCount
	end
		
	--显示颜色图标
	for i=1, curCount do
		g_Huanse_IconList[i] : SetProperty("Visible","True")
		g_Huanse_IconList[i] : SetProperty("NormalImage",g_Huanse_IconNameList[g_Huanse_Select_Index][i])
		g_Huanse_IconList[i] : SetProperty("HoverImage",g_Huanse_IconNameList[g_Huanse_Select_Index][i])
		if g_Huanse_IconVisList[g_Huanse_Select_Index][i] ~= 1 then
			--蒙红图标
			g_Huanse_IconMaskList[i]:SetProperty("Image", "set:Face_04 image:Remind_Bak")
		end
		--更新tips
		local strName = Lua_GetPetPossModelNameById(g_Huanse_Select_Index * 1000 + i)
		if strName ~= nil and strName ~= "" then
			g_Huanse_IconList[i] : SetToolTip(strName)
			g_Huanse_IconMaskList[i] : SetToolTip(strName)
		end
	end	
	
end

function PetHuanSe_UpdateList(md)
	--先清空当前列表
	PetHuanSe_EquiptShapeList:ClearListBox()
	if md ~= "" then
		for nIndex = 1, table.getn(g_Huanse_PetPossNameList) do
			local szPossName = g_Huanse_PetPossNameList[nIndex]
			if szPossName ~= "" then
				if (tonumber(string.sub(md,nIndex,nIndex)) == 0) or (Player:GetData("LEVEL") < 45) then
					szPossName = "#c808080"..szPossName		--灰色
					PetHuanSe_EquiptShapeList:AddItem(szPossName, nIndex)
				else
					szPossName = "#cfff263"..szPossName		--黄色
					PetHuanSe_EquiptShapeList:AddItem(szPossName, nIndex)
				end
			end
		end
	end
end

function PetHuanSe_SelectFirstInList()
	if g_NowPossVisual >= g_Huanse_Select_IndexIdMini then
		--更新当前选项
		if g_NowPossVisual ~= g_Huanse_Select_IndexId then
			g_Huanse_Select_IndexId = g_NowPossVisual
			g_Huanse_Select_Index = math.floor(g_Huanse_Select_IndexId/1000)--Pet:GetPetPossModelTypeById(g_Huanse_Select_IndexId)
		end
	else
		PetHuanSe_EquiptShapeList:SetItemSelect(tonumber(0))
	end
	
	--显示当前选项
	g_InitState = 1
	PetHuanSe_SelectCurInList()
	
end

function PetHuanSe_SelectCurInList()
	if g_Huanse_Select_Index <= 0 or g_Huanse_Select_Index > g_Huanse_MaxTypeCount then 
		return
	end

	if g_Huanse_Select_Index ~= -1  and g_Huanse_Select_IndexId >= g_Huanse_Select_IndexIdMini and g_Huanse_Select_IndexId < g_Huanse_Select_IndexIdMax then
		PetHuanSe_EquiptShapeList:SetItemSelectByItemID(g_Huanse_Select_Index)
	end
end

--=========================================================
--开始关心NPC，
--在开始关心之前需要先确定这个界面是不是已经有“关心”的NPC，
--如果有的话，先取消已经有的“关心”
--=========================================================
function PetHuanSe_BeginCareObject()
	this:CareObject(g_Huanse_theNPC, 1, "PetHuanSe")
end

--=========================================================
--停止对某NPC的关心
--=========================================================
function PetHuanSe_StopCareObject()
	this:CareObject(g_Huanse_theNPC, 0, "PetHuanSe")
	g_Huanse_theNPC = -1
end

function PetHuanSe_Close_Window()
	PetHuanSe_StopCareObject()
	PetHuanSe_Clear()
	this:Hide()
	if(IsWindowShow("PetHuanSeJian")) then
		CloseWindow("PetHuanSeJian", true);
	end	
end

function PetHuanSe_Clear()
	PetHuanSe_EquiptShapeList:ClearListBox()
	LifeAbility : Update_Equip_VisualID()
	PetHuanSe_FakeObject:SetFakeObject("")
	--PetHuanSe_Jian: SetProperty("Visible","False")
	g_Huanse_Select_Index = -1
	g_Huanse_Select_IndexId = -1
	g_Huanse_CurColorIndex = -1
	g_InitState = 0
	
	for i=1,g_Huanse_MaxColorCount do
		g_Huanse_IconList[i] : SetPushed(0)
		g_Huanse_IconList[i] : SetProperty("NormalImage","")
		g_Huanse_IconList[i] : SetProperty("HoverImage","")
		g_Huanse_IconList[i] : SetToolTip("")
		g_Huanse_IconMaskList[i] : SetProperty("Image", "")
		g_Huanse_IconMaskList[i] : SetToolTip("")
		g_Huanse_IconAniList[i] : SetProperty("Visible","False")
	end
	
	for i=1, g_Huanse_MaxTypeCount do
		for j=1, g_Huanse_MaxColorCount do
			g_Huanse_IconVisList[i][j] = 0
		end
	end

end

function PetHuanSe_SearchMode_Changed()
	local str,nIndex = PetHuanSe_SearchMode:GetCurrentSelect()
	if nIndex ~= -1 then
		--Model
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("SetGXHColorRateByFitValue")
			Set_XSCRIPT_ScriptID(889383);
			Set_XSCRIPT_Parameter(0,g_Huanse_Select_IndexId);
			Set_XSCRIPT_Parameter(1,g_PetHuanSeTbl[nIndex]);
			Set_XSCRIPT_ParamCount(2);
		Send_XSCRIPT();
		PetHuanSe_SetFakeCamera()
		local strName = Lua_GetPetPossModelNameById(g_Huanse_Select_IndexId)
		if strName == nil or strName == "" then
			return
		end
		PetHuanSe_Pet_Type:SetText(strName)
	end

end

function PetHuanSe_SetFakeCamera()
	FakeObj_SetCamera( "EquipChange_Player", 2,9)
end

--“幻色”按钮
function PetHuanSe_OK_Clicked()
	-- 判断是否为安全时间
	if (tonumber(DataPool:GetLeftProtectTime()) > 0) then
		PushDebugMessage("#{JJTZ_090826_26}")
		return
	end

	if Player:GetData("LEVEL") < 45 then
		PushDebugMessage("#{ZSYH_170111_41}")
		return
	end
	--判断金钱是否足够
	PetHuanSe_Money:SetProperty("MoneyNumber", g_Huanse_NeedMoney)
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnPetPossHuanSe")
		Set_XSCRIPT_ScriptID(889383)
		Set_XSCRIPT_Parameter(0, g_Huanse_Select_IndexId)
		Set_XSCRIPT_Parameter(1, g_Huanse_YBConfirm)
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()
end

--更换附体外形
function PetHuanSe_Visual_Clicked()
	--是否达到45级
	if Player:GetData("LEVEL") < 45 then
		PushDebugMessage("#{FTWX_110511_13}")
		return
	end
  
  --判断玩家是否选中1个附体颜色
	if g_Huanse_CurColorIndex <= 0 or g_Huanse_CurColorIndex > g_Huanse_MaxColorCount then
		PushDebugMessage("#{GXHDZ_141121_65}")
		return
	end

	--判断当前选中的外形是否正在使用中
	if g_NowPossVisual == g_Huanse_Select_IndexId then
		PushDebugMessage("#{GXHDZ_141121_66}")
		return
	end
	
	--Server会再次判断这些条件
	
	-- 向服务器发送更换消息
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnChange")
		Set_XSCRIPT_ScriptID(889383)
		Set_XSCRIPT_Parameter(0, g_Huanse_Select_IndexId) --这块必须传类型id
		Set_XSCRIPT_Parameter(1, 0)
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()
end

--model turn left
function PetHuanSe_Pet_Modle_TurnLeft(start)
	--start
	if (start == 1 and CEArg:GetValue("MouseButton") == "LeftButton") then
		PetHuanSe_FakeObject:RotateBegin(-0.3)
	else
		PetHuanSe_FakeObject:RotateEnd()
	end
end

--model turn right
function PetHuanSe_Pet_Modle_TurnRight(start)
	--start
	if (start == 1 and CEArg:GetValue("MouseButton") == "LeftButton") then
		PetHuanSe_FakeObject:RotateBegin(0.3)
	else
		PetHuanSe_FakeObject:RotateEnd()
	end
end

function PetHuanSe_ResetPos()
	PetHuanSe_Frame:SetProperty("UnifiedXPosition", g_Huanse_Frame_UnifiedXPosition);
	PetHuanSe_Frame:SetProperty("UnifiedYPosition", g_Huanse_Frame_UnifiedYPosition);
end

function PetHuanSe_YBPay_Clicked()
	if g_Huanse_YBConfirm==1 then
		g_Huanse_YBConfirm = 0
	else
		g_Huanse_YBConfirm = 1
	end
	--PetHuanSe_YuanBaoPay_Button:SetCheck(g_Huanse_YBConfirm)
end

function Lua_GetPetPossModelNameById(nID)
	local nPossModelTable = {
	[1001] = "原始风格",
	[2001] = "#{FTHS_120719_80}",
	[2002] = "#{FTHS_120719_81}",
	[2003] = "#{FTHS_120719_82}",
	[2004] = "#{FTHS_120719_83}",
	[2005] = "#{FTHS_120719_84}",
	[2006] = "#{FTHS_120719_85}",
	[2007] = "#{FTHS_120719_86}",
	[2008] = "#{FTHS_120719_87}",
	[2009] = "#{FTHS_120719_88}",
	[3001] = "#{FTHS_120719_80}",
	[3002] = "#{FTHS_120719_89}",
	[3003] = "#{FTHS_120719_90}",
	[3004] = "#{FTHS_120719_91}",
	[3005] = "#{FTHS_120719_92}",
	[3006] = "#{FTHS_120719_93}",
	[3007] = "#{FTHS_120719_94}",
	[3008] = "#{FTHS_120719_95}",
	[3009] = "#{FTHS_120719_96}",
	[4001] = "#{FTHS_120719_80}",
	[4002] = "#{FTHS_120719_97}",
	[4003] = "#{FTHS_120719_98}",
	[4004] = "#{FTHS_120719_99}",
	[4005] = "#{FTHS_120719_100}",
	[4006] = "#{FTHS_120719_101}",
	[4007] = "#{FTHS_120719_102}",
	[4008] = "#{FTHS_120719_103}",
	[4009] = "#{FTHS_120719_104}",
	[5001] = "#{FTHS_120719_80}",
	[5002] = "#{FTHS_120719_105}",
	[5003] = "#{FTHS_120719_106}",
	[5004] = "#{FTHS_120719_107}",
	[5005] = "#{FTHS_120719_108}",
	[5006] = "#{FTHS_120719_109}",
	[5007] = "#{FTHS_120719_110}",
	[5008] = "#{FTHS_120719_111}",
	[5009] = "#{FTHS_120719_112}",
	[6001] = "#{FTHS_120719_80}",
	[6002] = "#{FTHS_140417_12}",
	[6003] = "#{FTHS_140417_10}",
	[6004] = "#{FTHS_140417_11}",
	[6005] = "#{FTHS_140417_13}",
	[6006] = "#{FTHS_140417_14}",
	[6007] = "#{FTHS_140417_16}",
	[6008] = "#{FTHS_140417_17}",
	[6009] = "#{FTHS_140417_15}",
	[7001] = "#{FTHS_120719_80}",
	[7002] = "#{FTHS_150113_10}",
	[7003] = "#{FTHS_150113_11}",
	[7004] = "#{FTHS_150113_12}",
	[7005] = "#{FTHS_150113_13}",
	[7006] = "#{FTHS_150113_14}",
	[7007] = "#{FTHS_150113_15}",
	[7008] = "#{FTHS_150113_16}",
	[7009] = "#{FTHS_150113_17}",
	[8001] = "#{FTHS_120719_80}",
	[8002] = "#{FTHS_150805_10}",
	[8003] = "#{FTHS_150805_11}",
	[8004] = "#{FTHS_150805_12}",
	[8005] = "#{FTHS_150805_13}",
	[8006] = "#{FTHS_150805_14}",
	[8007] = "#{FTHS_150805_15}",
	[8008] = "#{FTHS_150805_16}",
	[8009] = "#{FTHS_150805_17}",
	--2019-9-26 23:22:11 新增瑞鹤附体 逍遥子
	[9001] = "#{FTHS_120719_80}",
	[9002] = "#{FTSH_190415_10}",
	[9003] = "#{FTSH_190415_11}",
	[9004] = "#{FTSH_190415_12}",
	[9005] = "#{FTSH_190415_13}",
	[9006] = "#{FTSH_190415_14}",
	[9007] = "#{FTSH_190415_15}",
	[9008] = "#{FTSH_190415_16}",
	[9009] = "#{FTSH_190415_17}",
	}
	if nPossModelTable[nID] ~= nil then
		return nPossModelTable[nID]
	else
		return ""
	end
end