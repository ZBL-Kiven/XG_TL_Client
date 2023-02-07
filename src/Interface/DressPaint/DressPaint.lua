--时装染色
local MAX_OBJ_DISTANCE = 3.0
local DRESS_POS = -1
local g_NeedMoney = 50000
local g_ObjCared = -1
local g_DressPaint_Frame_UnifiedPosition;
local g_DressPaint_TipsTwice = 0
local g_dressNum 					= 9;
local DressVisualID 			=	{};
local DressNames 					= {};
local DressRate 					= {};
local g_ZiDongState 			= 0			--判断是不是自动染色  默认关闭   0 表示关闭  1 表示开启  作用 1判断取消背包操作  2当服务器返回时 根据这个标示判断是自动染色返回还是染色返回
local g_ZiDongTimerState 	= 0			--自动染色状态  0 关闭  1 开启 2 暂停
local g_RecvGRespState 		= 0			--是否收到服务器染色返回  0.3秒间隔发送一次 但是只有返回后 才继续发   0 表示关闭  1 表示开启  这个要在收到服务器返回后 先判断是否稀有后再置成收到状态 
local g_Zidong_ClickTime 	= 300; 	--300毫秒 模拟点击染色按钮
local g_Rare_Time 				= 1000; --1000毫秒 当rou到稀有颜色  关闭自动timer 开启等待timer
local g_Rare_Count        = 3;
local g_IsFirstAuto				= 1;		--是否是auto第一次请求
local HongYaoShi_POS			= -1;
local g_IsXiYouStop				= 0;
local g_DressPaint_ItemID = 0
local g_DressPaint_YuanbaoPay = 1

--PreLoad
function DressPaint_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("OBJECT_CARED_EVENT")
	this:RegisterEvent("UPDATE_DRESS_PAINT")
	this:RegisterEvent("RESUME_ENCHASE_GEM")
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")
	this:RegisterEvent("UNIT_MONEY")
	this:RegisterEvent("MONEYJZ_CHANGE")
	this:RegisterEvent("DISABLE_DRESS_PAINT_TRACING")
	this:RegisterEvent("PROGRESSBAR_SHOW")
	this:RegisterEvent("CLOSE_DRESS_PAINT")
	this:RegisterEvent("OPEN_STALL_SALE");
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")

	this:RegisterEvent("SEX_CHANGED")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED");
	this:RegisterEvent("OPEN_EQUIP");
end

--OnLoad
function DressPaint_OnLoad()
	g_DressPaint_Frame_UnifiedPosition=DressPaint_Frame:GetProperty("UnifiedPosition");
	
	Dress_Jian:Hide()
	--时装还原暂时屏蔽
	--DressPaint_FenYe2:Hide()
	-- DressPaint_Blank_Queren_Clicked()
--	DressPaint_Zidong:Hide()
--	DressPaint_Zidong_Animate:Hide()
end

--OnEvent
function DressPaint_OnEvent(event)
	
	-- 读进度条中，不能进行染色
	if ( event == "PROGRESSBAR_SHOW" ) then
		if (this:IsVisible()) then
			DressPaint_OnHiden();
		end
	end

	-- 某些功能互斥，需要关闭该界面
	if ( event == "CLOSE_DRESS_PAINT" ) then
		if (this:IsVisible()) then
			DressPaint_OnHiden();
		end
	end

	-- 开始摆摊，不能进行染色
	if ( event == "OPEN_STALL_SALE" ) then
		if (this:IsVisible()) then
			DressPaint_OnHiden();
		end
	end

	if event == "UI_COMMAND" and arg0 ~= nil and tonumber(arg0) == 0910281 then
		if this:IsVisible() then 
			DressPaint_OnHiden();
		end
		DressPaint_OK:Disable()										-- 禁用“确定”按钮
		DressPaint_Zidong:SetText("#{YJRS_140613_04}") 
		DressPaint_Zidong:Disable()
		DressPaint_Zidong_Animate:Play(false)
		DressPaint_Text : SetText("") 
		DressPaint_Protect : SetText("") 
		DressPaint_Zidong_ALLChoice:Disable()
		DressPaint_Protect:Hide()
		this:Show()
		
		DressPaint_Fitting_FakeObject : SetFakeObject("");
		DressPaint_Fitting_FakeObject : SetFakeObject("EquipChange_Player");
		
		Dress_Jian : Hide()
		
		local xx = Get_XParam_INT(0);
		local objCared = DataPool:GetNPCIDByServerID(xx);
		if objCared == -1 then
			return;
		end
		BeginCareObject_DressPaint(objCared)

		DressPaint_DemandMoney:SetProperty("MoneyNumber", g_NeedMoney)
		local playerMoney = Player:GetData("MONEY")
		DressPaint_SelfMoney:SetProperty("MoneyNumber", playerMoney)
		local playerJZ = Player:GetData("MONEY_JZ")
		DressPaint_SelfJiaozi:SetProperty("MoneyNumber", playerJZ)
		
		g_DressPaint_TipsTwice = 0
		g_DressPaint_TipsBind = 0
		
		--yuanbaoPay
		if g_DressPaint_YuanbaoPay == 1 or g_DressPaint_YuanbaoPay == 0 then
			-- DressPaint_Blank_Queren:SetCheck(g_DressPaint_YuanbaoPay)
		end
		--DressPaint_FenYe1:SetProperty("Selected", "True")
		--DressPaint_FenYe2:SetProperty("Selected", "False")
		
	elseif event == "UI_COMMAND" and tonumber(arg0) == 1000000003 then
		local objCared = tonumber(arg1);
		if this:IsVisible() then 
			DressPaint_OnHiden();
		end
		g_DressPaint_Frame_UnifiedPosition = Variable:GetVariable("DressClothPos")
		DressPaint_Frame:SetProperty("UnifiedPosition", g_DressPaint_Frame_UnifiedPosition);
		
		DressPaint_OK:Disable()										-- 禁用“确定”按钮
		DressPaint_Zidong:SetText("#{YJRS_140613_04}") 
		DressPaint_Zidong:Disable()
		DressPaint_Zidong_Animate:Play(false)
		DressPaint_Fitting_FakeObject : Hide() 
		DressPaint_Text : SetText("") 
		DressPaint_Protect : SetText("") 
		DressPaint_Zidong_ALLChoice:Disable()
		DressPaint_Protect:Hide()
		this:Show()
		
		DressPaint_Fitting_FakeObject : SetFakeObject("");
		DressPaint_Fitting_FakeObject : SetFakeObject("EquipChange_Player");
		DressPaint_Fitting_FakeObject : Show()
		
		Dress_Jian : Hide()
		
		--local objCared = DataPool:GetNPCIDByServerID(_objCared);
		if objCared == -1 then
			return;
		end
--		PushDebugMessage("objCared "..objCared)
		BeginCareObject_DressPaint(objCared)

		DressPaint_DemandMoney:SetProperty("MoneyNumber", g_NeedMoney)
		local playerMoney = Player:GetData("MONEY")
		DressPaint_SelfMoney:SetProperty("MoneyNumber", playerMoney)
		local playerJZ = Player:GetData("MONEY_JZ")
		DressPaint_SelfJiaozi:SetProperty("MoneyNumber", playerJZ)
		
		g_DressPaint_TipsTwice = 0
		g_DressPaint_TipsBind = 0
		
		--yuanbaoPay
		if g_DressPaint_YuanbaoPay == 1 or g_DressPaint_YuanbaoPay == 0 then
			-- DressPaint_Blank_Queren:SetCheck(g_DressPaint_YuanbaoPay)
		end
		--DressPaint_FenYe1:SetProperty("Selected", "True")
		--DressPaint_FenYe2:SetProperty("Selected", "False")
	elseif ( event=="UI_COMMAND" and tonumber(arg0) == 201107281) and this : IsVisible() then
        if arg1 == -1 then
			return
		end		
        DressPaint_Update(tonumber(arg1))
	elseif(event == "UI_COMMAND" and tonumber(arg0) == 1000000011) then

		-- 试衣
		local nNowVisualID = tonumber(Get_XParam_INT(0))
		if nNowVisualID == -1 then
			return ;
		end
		DRESS_POS = tonumber(Get_XParam_INT(1))
		LifeAbility:Wear_Equip_VisualID(DRESS_POS,nNowVisualID)
        DressPaint_RestUpdate(DRESS_POS)
		-- 设置使用哪个模型
--		DressPaint_Fitting_FakeObject : SetFakeObject("");
--		DressPaint_Fitting_FakeObject : SetFakeObject("EquipChange_Player"); 
		local nColorID,nColorName,nNormalName = Lua_GetDressColor(nNowVisualID)
		if nColorID ~= -1 then
			DressPaint_Text:SetText(nColorName)
		end
		--dujm
		if g_ZiDongState == 1 then  
			local n_visualID = nNowVisualID
			if n_visualID == 0 then
				return
			end 
			local nIsSepcial = tonumber(Get_XParam_INT(2))
			local _name,ComIdx = DressPaint_Zidong_ALLChoice:GetCurrentSelect()  
			if DressVisualID[ComIdx] == n_visualID then
				DressPaint_SuccDestMode(nNormalName) 
			elseif  nIsSepcial == 1 then  
				DressPaint_SuccDestMode(nNormalName)  
			end   
			g_RecvGRespState = 1 
		end 
	elseif event == "UI_COMMAND" and arg0 ~= nil and tonumber(arg0) == 091109 then		
		if this:IsVisible() then
			DressPaint_Show()
			g_DressPaint_TipsTwice = 0
			g_DressPaint_TipsBind = 0
		end
	elseif event == "UI_COMMAND" and arg0 ~= nil and tonumber(arg0) == 2019030101 then	--没有染色成功	
		if this:IsVisible() then
			g_RecvGRespState = 1
		end
	-- 染色追踪界面已打开，禁用“染色追踪”按钮	
	elseif event == "DISABLE_DRESS_PAINT_TRACING" then		
		if this:IsVisible() then
			
		end
	elseif event == "OBJECT_CARED_EVENT" then
		if(arg0 ~= nil and tonumber(arg0) ~= objCared) then
			return;
		end		
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then		
			DressPaint_OnHiden();
		end	

	elseif event == "RESUME_ENCHASE_GEM" and this:IsVisible() then		
		if(arg0~=nil and tonumber(arg0) == 96) then
			DressPaint_Resume_Equip()
		end

	elseif event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() then
		if( arg0~= nil and -1 == tonumber(arg0)) then
			return
		end

--		if (DRESS_POS == tonumber(arg0)) then
--			DressPaint_Update(tonumber(arg0), 1)
--		end

	elseif (event == "UNIT_MONEY" and this:IsVisible()) then
		DressPaint_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));

	elseif (event == "MONEYJZ_CHANGE" and this:IsVisible()) then
		DressPaint_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
		
	elseif (event == "ADJEST_UI_POS" ) then
		DressPaint_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		DressPaint_Frame_On_ResetPos()	
	elseif event == "SEX_CHANGED" and  this:IsVisible() then
		DressPaint_Fitting_FakeObject : Hide();
		DressPaint_Text : Hide()
		Dress_Jian : Hide()
		DressPaint_Fitting_FakeObject : Show();
		DressPaint_Text : Show()
		Dress_Jian : Show()
		DressPaint_Fitting_FakeObject : SetFakeObject("EquipChange_Player");
	end
end





--事件函数
------------------------------------------------------
--
--	打开试衣间
--
function DressPaint_Show()

	DressPaint_Text : Show();
end
function DressPaint_RestUpdate(Pos)
     local theAction = EnumAction(Pos, "packageitem")
	 DressPaint_Object:SetActionItem(theAction:GetID())
	 LifeAbility:Lock_Packet_Item(DRESS_POS, 1)	
end
function DressPaint_Update(Pos)
	-- 设置使用哪个模型	
	local theAction = EnumAction(Pos, "packageitem")
	if theAction:GetID() ~= 0 then
		local EquipPoint = LifeAbility:Get_Equip_Point(Pos)
		if EquipPoint ~= 2 then
			PushDebugMessage("此物品不是时装")
			return
		end
		
		--判断是不是可染色时装
		local canPaint = PlayerPackage:GetItemTableIndex(Pos)
		g_DressPaint_ItemID = canPaint
		if canPaint < 10131000 or canPaint > 10131027 then
			PushDebugMessage("#{SZPR_091023_18}")--对不起，该时装不符合染色要求。
			return
		end
		DressPaint_Clear()
		DRESS_POS = Pos;
		g_DressPaint_ItemID = canPaint
		LifeAbility:Lock_Packet_Item(DRESS_POS, 1)	
		DressPaint_Object:SetActionItem(theAction:GetID())
--		DressPaint_Fitting_FakeObject : SetFakeObject("");
--		DressPaint_Fitting_FakeObject : SetFakeObject("EquipChange_Player");
		
		--启用确定按钮
		DressPaint_OK:Enable();
		DressPaint_Zidong_ALLChoice:Enable(); 
		DressPaint_Zidong_ALLChoice_Init()
		return
	else
		--DressPaint_Clear()
		return
	end
end

function DressPaint_Resume_Equip()	
	DressPaint_Clear()	
end

function DressPaint_Clear()
	LifeAbility : Update_Equip_VisualID()
	if(DRESS_POS ~= -1) then
		DressPaint_OK:Disable()										-- 禁用“确定”按钮
		DressPaint_Zidong:SetText("#{YJRS_140613_04}") 
		DressPaint_Zidong:Disable(); 
		DressPaint_Zidong_Animate:Play(false)
		DressPaint_Zidong_ALLChoice:Disable()
		DressPaint_Object:SetActionItem(-1)
		LifeAbility:Lock_Packet_Item(DRESS_POS, 0)
		DRESS_POS = -1
		--DressPaint_Fitting_FakeObject : Hide();
		DressPaint_Text : SetText("");
		Dress_Jian : Hide() 
		DressPaint_Zidong_ALLChoice_Init() 
		DressVisualID ={};
		DressNames = {};
		DressRate = {}; 
		
		if g_ZiDongState == 1  then  				--- count timer  kill  没写呢 
  		KillTimer("DressPaint_countEvent()") 
  		PushDebugMessage("#{YJRS_140613_17}")
  	end   	
  	if g_ZiDongTimerState == 2  and g_Rare_Count < 3 then  				--- count timer  kill  没写呢 
  		KillTimer("DressRare_TimerEvent()") 
  	end   	
		DressPaint_ResetZiDongState()
	end
end

function DressPaint_OnHiden()
	SetDefaultMouse();
	StopCareObject_DressPaint(objCared)
	DressPaint_Clear()  
	DressPaint_Fitting_FakeObject : SetFakeObject("");
	DressPaint_Text : SetText("");
	Dress_Jian : Hide() 
	this:Hide() 
	if(IsWindowShow("DressJian") == true) then
		PushEvent( "CLOSE_DRESSJIAN_DLG")		
	end
	return
end

--初始化自动状态 并构造数据
function DressPaint_Zidong_ALLChoice_Init() 
	DressPaint_Zidong_ALLChoice:ResetList()  	
	DressPaint_Zidong_ALLChoice:SetText("#{YJRS_140613_03}")--选择目标染色风格  
	--DressPaint_Zidong_ALLChoice:SetCurrentSelect(0); 
	if ( DRESS_POS == -1 ) then  
		DressVisualID 	= {};
		DressNames 			= {};
		DressRate 			= {};  
		DressPaint_Zidong_ALLChoice:Disable();
		return
	end

	--DressReplaceColor :StoreDressType(DRESS_POS); 
	local nColorID_Table,nColorName_Table,nColorRate_Table = Lua_GetDressColor(g_DressPaint_ItemID)
	if nColorID_Table ~= nil and table.getn(nColorID_Table) > 0 then
	    for i= 1 ,table.getn(nColorID_Table) do
			DressVisualID[i] = nColorID_Table[i]; 
			DressNames[i] = nColorName_Table[i]; 
			DressRate[i] = nColorRate_Table[i]
			DressPaint_Zidong_ALLChoice:AddTextItem(DressNames[i],i) 
		end
	else
		PushDebugMessage("对不起，该时装暂无染色图鉴")
		return
	end
	
	DressPaint_Zidong_ALLChoice:Enable() 
	
end

function Lua_DressCanWash(nIndex)
--	local nCanWash = 0
--	local nClothPos = 0
--	local nColorID = 0
--	for i = 1,table.getn(g_DressPaint_Item) do
--		for j = 1,table.getn(g_DressPaint_Item[i]) do
--			if g_DressPaint_Item[i][j] == nIndex then
--				nClothPos = i
--				nColorID = j
--				break
--			end
--		end
--	end
----	PushDebugMessage("nColorID "..nColorID)
--	if nColorID > 1 then
--		nCanWash = 1
--	end
	return 1
end

--染出目标颜色
function DressPaint_SuccDestMode(strDressDesc)
	local Msg = string.format("#H恭喜您！染出了%s#H，自动染色结束。", strDressDesc) 
	PushDebugMessage(Msg)
	DressPaint_ResetZiDongState()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnSuccDressPaint")
		Set_XSCRIPT_ScriptID(900007) 
		Set_XSCRIPT_ParamCount(0)
	Send_XSCRIPT()  
end

--目标ComList选择事件
function DressPaint_DestMode_Changed() 
	if g_ZiDongState == 1 then
		PushDebugMessage("#{YJRS_140613_07}") 
		return
	end 
	local _name,ComIdx = DressPaint_Zidong_ALLChoice:GetCurrentSelect()
	if ComIdx == g_dressNum then
		g_IsXiYouStop = 1
	else
		g_IsXiYouStop = 0
	end
	if ComIdx > 0 then 
		DressPaint_Zidong:SetText("#G#{YJRS_140613_04}") 
		DressPaint_Zidong:Enable()
		DressPaint_Zidong_Animate:Play(true)
	else
		DressPaint_Zidong:SetText("#{YJRS_140613_04}") 
		DressPaint_Zidong:Disable() 
		DressPaint_Zidong_Animate:Play(false)
	end
    if DressVisualID[ComIdx] ~= nil then
	    LifeAbility:Wear_Equip_VisualID(DRESS_POS,DressVisualID[ComIdx])
	end
end

------------------------------------------------------
--
--	确定
--
function DressPaint_Blank_Queren_Clicked() 
	g_DressPaint_YuanbaoPay = DressPaint_Blank_Queren:GetCheck();
	--PushDebugMessage("DressPaint_Blank_Queren_Clicked"..g_DressPaint_YuanbaoPay) 
end
function DressPaint_OK_Clicked()
	if g_ZiDongState == 1 then
		PushDebugMessage("#{YJRS_140613_07}") 
		return 
	end 
	
	-- 判断是否为安全时间2012.6.12-LIUBO
	if (tonumber(DataPool:GetLeftProtectTime()) > 0) then
		PushDebugMessage("#{ZYXT_120528_16}")
		return
	end
	
	local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")
	if selfMoney < g_NeedMoney then
		PushDebugMessage("#{RXZS_090804_11}")
		return
	end
	
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnDressPaint")
		Set_XSCRIPT_ScriptID(900007)
		Set_XSCRIPT_Parameter(0, DRESS_POS)
		Set_XSCRIPT_Parameter(1, g_DressPaint_YuanbaoPay)
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()
	return
end

--点击自动染色事件
function DressPaint_Zidong_Clicked()			--自动开启  开启timer事件
	if g_ZiDongState == 0 then 
		if (tonumber(DataPool:GetLeftProtectTime()) > 0) then
			PushDebugMessage("#{OR_PILFER_LOCK_FLAG}")
			return
		end 	
		local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")
		if selfMoney < g_NeedMoney then
			PushDebugMessage("#{YJRS_140613_11}")
			return
		end 
		g_IsFirstAuto       = 1
		g_ZiDongState 			= 1			
		g_ZiDongTimerState	= 1
		g_RecvGRespState    = 1 	
		SetTimer("DressPaint","DressPaint_ZiDong_TimerEvent()", 300)
		DressPaint_Zidong_ALLChoice:Disable() 
		DressPaint_Zidong:SetText("#{YJRS_140613_05}")
	else 
		PushDebugMessage("#{YJRS_140613_17}")
		DressPaint_ResetZiDongState()
	end
end

--重置自动状态 1.点击停止 关闭窗口时
function DressPaint_ResetZiDongState() 	
	local _name,ComIdx = DressPaint_Zidong_ALLChoice:GetCurrentSelect()
	if ComIdx > 0 then 
		DressPaint_Zidong:SetText("#{YJRS_140613_04}") 
		DressPaint_Zidong:Disable()
		DressPaint_Zidong_Animate:Play(false)
		DressPaint_Zidong_ALLChoice:Enable() 
		DressPaint_Zidong_ALLChoice:SetText("#{YJRS_140613_03}")--选择目标染色风格  
	end 
	  DressPaint_Zidong:SetText("#{YJRS_140613_04}") 
	  if g_ZiDongTimerState == 2  and g_Rare_Count < 3 then  				--- count timer  kill  没写呢 
  		--KillTimer("DressRare_TimerEvent()") 
  	  end
  	DressPaint_Protect:SetText(""); 
  	if g_ZiDongState == 1  then 
  		KillTimer("DressPaint_ZiDong_TimerEvent()") 
  	end  

  	g_ZiDongState 			= 0			
    g_ZiDongTimerState	= 0
    g_RecvGRespState    = 0 

end	

function DressPaint_ZiDong_TimerEvent()	--模拟点击染色按钮  0.3秒一次  
	if g_ZiDongTimerState == 1  and g_RecvGRespState == 1 then 
 	   -- 判断是否为安全时间
		if (tonumber(DataPool:GetLeftProtectTime()) > 0) then
			PushDebugMessage("#{ZYXT_120528_16}")
			DressPaint_ResetZiDongState()
			return
		end  

		local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")
		if selfMoney < g_NeedMoney then
			PushDebugMessage("#{YJRS_140613_14}")
			DressPaint_ResetZiDongState()
			return
		end  
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("OnAutoDressPaint")
			Set_XSCRIPT_ScriptID(900007)
			Set_XSCRIPT_Parameter(0, DRESS_POS)
			Set_XSCRIPT_Parameter(1, g_IsFirstAuto)			--是否是第一次自动染色  为了区别显示不同内容  1 代表第一次 0不是
			Set_XSCRIPT_Parameter(2, g_DressPaint_YuanbaoPay)			--是否是第一次自动染色  为了区别显示不同内容  1 代表第一次 0不是
			Set_XSCRIPT_ParamCount(3)
		Send_XSCRIPT() 

		g_RecvGRespState    = 0 
		g_IsFirstAuto       = 0
 	end 
end
------------------------------------------------------
--
--	打开试衣间
--
function DressPaint_Show_Clicked() --这里对应自动染色按钮
	--DressPaint_Update(0,1);
	--PushDebugMessage("请将染色时装放在道具栏第一格上")
end

------------------------------------------------------
--
--	关心NPC
--
function BeginCareObject_DressPaint(objCaredId)
	g_ObjCared = objCaredId
	this:CareObject(g_ObjCared, 1, "DressPaint")
end


function StopCareObject_DressPaint(objCaredId)
	this:CareObject(g_ObjCared, 0, "DressPaint")
	g_ObjCared = -1
end

function DressPaint_Frame_On_ResetPos()
	DressPaint_Frame:SetProperty("UnifiedPosition", g_DressPaint_Frame_UnifiedPosition);
end
----------------------------------------------------------------------------------
--
-- 旋转人物头像模型（向左)
--
function DressPaint_Fitting_TurnLeft(start)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		--向左旋转开始
		if(start == 1) then
			DressPaint_Fitting_FakeObject:RotateBegin(-0.3);
		--向左旋转结束
		else
			DressPaint_Fitting_FakeObject:RotateEnd();
		end
	end
end

----------------------------------------------------------------------------------
--
--旋转人物头像模型（向右)
--
function DressPaint_Fitting_TurnRight(start)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		--向右旋转开始
		if(start == 1) then
			DressPaint_Fitting_FakeObject:RotateBegin(0.3);
		--向右旋转结束
		else
			DressPaint_Fitting_FakeObject:RotateEnd();
		end
	end
end
function DressPaint_OpenDressWash_Clicked() 
	-- 打开时装还原界面
	Variable:SetVariable("DressClothPos", DressPaint_Frame:GetProperty("UnifiedPosition"), 1);
	PushEvent("UI_COMMAND",0910282,g_ObjCared)
	this:Hide()
end


function Lua_GetDressColor(nIndex)
	--新表
	local nDressColorTable = {
	{10131000,292,"",0},
	{10131000,293,"蓝绿风格",23000},
	{10131000,294,"翠绿风格",23000},
	{10131000,295,"暖红风格",23000},
	{10131000,296,"淡紫风格",14000},
	{10131000,297,"天蓝风格",14000},
	{10131000,298,"深紫风格",14000},
	{10131000,299,"亮橘风格",1000},
	{10131000,300,"棕红风格",1000},
	{10131001,283,"",0},
	{10131001,284,"天蓝风格",23000},
	{10131001,285,"深粉风格",23000},
	{10131001,286,"紫蓝风格",23000},
	{10131001,287,"暖红风格",14000},
	{10131001,288,"棕黄风格",14000},
	{10131001,289,"幽绿风格",14000},
	{10131001,290,"棕红风格",1000},
	{10131001,291,"翠绿风格",1000},
	{10131002,306,"",0},
	{10131002,307,"黄绿风格",23000},
	{10131002,308,"暖红风格",23000},
	{10131002,309,"香橘风格",23000},
	{10131002,310,"典雅风格",14000},
	{10131002,311,"淡紫风格",14000},
	{10131002,312,"海蓝风格",14000},
	{10131002,313,"风情风格",1000},
	{10131002,314,"浅蓝风格",1000},
	{10131003,316,"",0},
	{10131003,317,"棕黄风格",23000},
	{10131003,318,"墨蓝风格",23000},
	{10131003,319,"深紫风格",23000},
	{10131003,320,"幽绿风格",14000},
	{10131003,321,"紫蓝风格",14000},
	{10131003,322,"粉蓝风格",14000},
	{10131003,323,"暖红风格",1000},
	{10131003,324,"青绿风格",1000},
	{10131004,325,"",0},
	{10131004,326,"青绿风格",23000},
	{10131004,327,"深紫风格",23000},
	{10131004,328,"棕黄风格",23000},
	{10131004,329,"熟绿风格",14000},
	{10131004,330,"翠绿风格",14000},
	{10131004,331,"亮橘风格",14000},
	{10131004,332,"棕红风格",1000},
	{10131004,333,"粉红风格",1000},
	{10131005,369,"",0},
	{10131005,370,"草绿风格",23000},
	{10131005,371,"姹紫风格",23000},
	{10131005,372,"玄青风格",23000},
	{10131005,373,"华贵风格",14000},
	{10131005,374,"暖玉风格",14000},
	{10131005,375,"仙风风格",14000},
	{10131005,376,"神毓风格",1000},
	{10131005,377,"帝尊风格",1000},
	{10131006,378,"",0},
	{10131006,379,"葱翠风格",23000},
	{10131006,380,"淡紫风格",23000},
	{10131006,381,"绒黄风格",23000},
	{10131006,382,"鹅黄风格",14000},
	{10131006,383,"蝶粉风格",14000},
	{10131006,384,"粉色风格",14000},
	{10131006,385,"湖蓝风格",1000},
	{10131006,386,"亮紫风格",1000},
	{10131007,388,"",0},
	{10131007,389,"暖橙风格",23000},
	{10131007,390,"郁青风格",23000},
	{10131007,391,"凝紫风格",23000},
	{10131007,392,"夜影风格",14000},
	{10131007,393,"灵碧风格",14000},
	{10131007,394,"赤炼风格",14000},
	{10131007,395,"玉神风格",1000},
	{10131007,396,"幻蝶风格",1000},
	{10131008,515,"",0},
	{10131008,516,"凝碧风格",23000},
	{10131008,517,"鹅黄风格",23000},
	{10131008,518,"嫣红风格",23000},
	{10131008,519,"华贵风格",14000},
	{10131008,520,"豹影风格",14000},
	{10131008,521,"盈梦风格",14000},
	{10131008,522,"玄枫风格",1000},
	{10131008,523,"青花风格",1000},
	{10131009,506,"",0},
	{10131009,507,"蓝紫风格",23000},
	{10131009,508,"鹅黄风格",23000},
	{10131009,509,"苍翠风格",23000},
	{10131009,510,"深紫风格",14000},
	{10131009,511,"水碧风格",14000},
	{10131009,512,"蝶粉风格",14000},
	{10131009,513,"玄青风格",1000},
	{10131009,514,"皇室风格",1000},
	{10131010,534,"",0},
	{10131010,535,"浅樱风格",23000},
	{10131010,536,"鹅黄风格",23000},
	{10131010,537,"藕荷风格",23000},
	{10131010,538,"清辉风格",14000},
	{10131010,539,"藏茵风格",14000},
	{10131010,540,"漓川风格",14000},
	{10131010,541,"星瀚风格",1000},
	{10131010,542,"荧惑风格",1000},
	{10131011,524,"",0},
	{10131011,525,"暖金风格",23000},
	{10131011,526,"禾青风格",23000},
	{10131011,527,"幽蓝风格",23000},
	{10131011,528,"烈焰风格",14000},
	{10131011,529,"行云风格",14000},
	{10131011,530,"晨曦风格",14000},
	{10131011,531,"霞绮风格",1000},
	{10131011,532,"琉璃风格",1000},
	{10131012,491,"",0},
	{10131012,492,"芽青风格",23000},
	{10131012,493,"湛蓝风格",23000},
	{10131012,494,"鹅黄风格",23000},
	{10131012,495,"苍岚风格",14000},
	{10131012,496,"沾星风格",14000},
	{10131012,497,"沙华风格",14000},
	{10131012,498,"千灯风格",1000},
	{10131012,499,"墨染风格",1000},
	{10131013,479,"",0},
	{10131013,480,"鹅黄风格",23000},
	{10131013,481,"墨灰风格",23000},
	{10131013,482,"莹白风格",23000},
	{10131013,483,"薄荷风格",14000},
	{10131013,484,"玉青风格",14000},
	{10131013,485,"丹霞风格",14000},
	{10131013,486,"琉璃风格",1000},
	{10131013,487,"紫薇风格",1000},
	{10131014,470,"",0},
	{10131014,471,"绚彩风格",23000},
	{10131014,472,"浅绿风格",23000},
	{10131014,473,"淡粉风格",23000},
	{10131014,474,"潭青风格",14000},
	{10131014,475,"尘灰风格",14000},
	{10131014,476,"红鸾风格",14000},
	{10131014,477,"薄暮风格",1000},
	{10131014,478,"烟峦风格",1000},
	{10131015,425,"",0},
	{10131015,426,"淡青风格",23000},
	{10131015,427,"朱红风格",23000},
	{10131015,428,"幽紫风格",23000},
	{10131015,429,"明黄风格",14000},
	{10131015,430,"湖蓝风格",14000},
	{10131015,431,"典雅风格",14000},
	{10131015,432,"雅绿风格",1000},
	{10131015,433,"皇室风格",1000},
	{10131016,434,"",0},
	{10131016,435,"深紫风格",23000},
	{10131016,436,"浅紫风格",23000},
	{10131016,437,"鹅黄风格",23000},
	{10131016,438,"湖蓝风格",14000},
	{10131016,439,"月白风格",14000},
	{10131016,440,"石榴风格",14000},
	{10131016,441,"紫棠风格",1000},
	{10131016,442,"胭脂风格",1000},
	{10131017,443,"",0},
	{10131017,444,"青绿风格",23000},
	{10131017,445,"浅黄风格",23000},
	{10131017,446,"淡紫风格",23000},
	{10131017,447,"亮橙风格",14000},
	{10131017,448,"釉红风格",14000},
	{10131017,449,"粉蕊风格",14000},
	{10131017,450,"紫萱风格",1000},
	{10131017,451,"墨渊风格",1000},
	{10131018,452,"",0},
	{10131018,453,"墨染风格",23000},
	{10131018,454,"鹅黄风格",23000},
	{10131018,455,"姹紫风格",23000},
	{10131018,456,"葱翠风格",14000},
	{10131018,457,"芙蓉风格",14000},
	{10131018,458,"宝蓝风格",14000},
	{10131018,459,"绯红风格",1000},
	{10131018,460,"夜魅风格",1000},
	{10131019,461,"",0},
	{10131019,462,"琼紫风格",23000},
	{10131019,463,"玫红风格",23000},
	{10131019,464,"鹅黄风格",23000},
	{10131019,465,"青岚风格",14000},
	{10131019,466,"水粉风格",14000},
	{10131019,467,"琉璃风格",14000},
	{10131019,468,"玉神风格",1000},
	{10131019,469,"英伦风格",1000},
	{10131020,397,"",0},
	{10131020,398,"草绿风格",23000},
	{10131020,399,"淡紫风格",23000},
	{10131020,400,"水蓝风格",23000},
	{10131020,401,"胭脂风格",14000},
	{10131020,402,"绯红风格",14000},
	{10131020,403,"幽红风格",14000},
	{10131020,404,"玉神风格",1000},
	{10131020,405,"姹紫风格",1000},
	{10131021,406,"",0},
	{10131021,407,"天蓝风格",23000},
	{10131021,408,"鹅黄风格",23000},
	{10131021,409,"紫藤风格",23000},
	{10131021,410,"烟霞风格",14000},
	{10131021,411,"流焰风格",14000},
	{10131021,412,"云筑风格",14000},
	{10131021,413,"归墟风格",1000},
	{10131021,414,"幽冥风格",1000},
	{10131022,415,"",0},
	{10131022,416,"兰紫风格",23000},
	{10131022,417,"淡青风格",23000},
	{10131022,418,"亮金风格",23000},
	{10131022,419,"早樱风格",14000},
	{10131022,420,"流云风格",14000},
	{10131022,421,"清寂风格",14000},
	{10131022,422,"灼耀风格",1000},
	{10131022,423,"青花风格",1000},
	{10131023,339,"",0},
	{10131023,340,"深粉风格",23000},
	{10131023,341,"青棕风格",23000},
	{10131023,342,"蓝紫风格",23000},
	{10131023,343,"青绿风格",14000},
	{10131023,344,"翠绿风格",14000},
	{10131023,345,"熟绿风格",14000},
	{10131023,346,"深蓝风格",1000},
	{10131023,347,"冷红风格",1000},
	{10131024,348,"",0},
	{10131024,349,"蓝绿风格",23000},
	{10131024,350,"青棕风格",23000},
	{10131024,351,"翠绿风格",23000},
	{10131024,352,"深紫风格",14000},
	{10131024,353,"墨蓝风格",14000},
	{10131024,354,"棕红风格",14000},
	{10131024,355,"蓝灰风格",1000},
	{10131024,356,"棕黄风格",1000},
	
	{10131025,559,"",0},
	{10131025,560,"淡绿风格",23000},
	{10131025,561,"淡紫风格",23000},
	{10131025,562,"淡蓝风格",23000},
	{10131025,563,"幽潭风格",14000},
	{10131025,564,"墨痕风格",14000},
	{10131025,565,"华年风格",14000},
	{10131025,566,"红鸾风格",1000},
	{10131025,567,"青花风格",1000},	
	
	{10131026,568,"",0},
	{10131026,569,"绛紫风格",23000},
	{10131026,570,"淡紫风格",23000},
	{10131026,571,"玉神风格",23000},
	{10131026,572,"水碧风格",14000},
	{10131026,573,"豹魂风格",14000},
	{10131026,574,"天青风格",14000},
	{10131026,575,"绯红风格",1000},
	{10131026,576,"虎魄风格",1000},


	{10131027,577,"",0},
	{10131027,578,"鹅黄风格",23000},
	{10131027,579,"青萝风格",23000},
	{10131027,580,"紫桑风格",23000},
	{10131027,581,"洞明风格",14000},
	{10131027,582,"天虚风格",14000},
	{10131027,583,"枫魂风格",14000},
	{10131027,584,"永夜风格",1000},
	{10131027,585,"凌川风格",1000},
	
	}
	local nColorID,nColorName,nColorRate = -1,"",0
	local nColorID_Table,nColorName_Table,nColorRate_Table = {},{},{}
	if nIndex >= 10000000 then
		for i = 1,table.getn(nDressColorTable) do
			if nDressColorTable[i][1] == nIndex then
				table.insert(nColorID_Table,nDressColorTable[i][2])
				nColorName = nDressColorTable[i][3]
				nColorRate = nDressColorTable[i][4]
				table.insert(nColorRate_Table,nColorRate)
				if nColorRate == 23000 then
					nColorName = nColorName.."【普通】"
				elseif nColorRate == 14000 then
					nColorName = nColorName.."【高级】"
				elseif nColorRate == 1000 then
					nColorName = nColorName.."【稀有】"
				elseif nColorRate == -1 then
					nColorName = "默认风格"
				end
				table.insert(nColorName_Table,nColorName)
			end
		end
		return nColorID_Table,nColorName_Table,nColorRate_Table
	else
		local nNormalName = ""
		for i = 1,table.getn(nDressColorTable) do
			if nDressColorTable[i][2] == nIndex then
				nColorID = nIndex
				nColorName = nDressColorTable[i][3]
				nNormalName = nColorName
				nColorRate = nDressColorTable[i][4]
				if nColorRate == 23000 then
					nColorName = "#G"..nColorName.."【普通】"
				elseif nColorRate == 14000 then
					nColorName = "#B"..nColorName.."【高级】"
				elseif nColorRate == 1000 then
					nColorName = "#cbe38ff"..nColorName.."【稀有】"
				elseif nColorRate == -1 then
					nColorName = "#G默认风格"
				end
				break
			end
		end
		return nColorID,nColorName,nNormalName
	end
end