--ʱװȾɫ
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
local g_ZiDongState 			= 0			--�ж��ǲ����Զ�Ⱦɫ  Ĭ�Ϲر�   0 ��ʾ�ر�  1 ��ʾ����  ���� 1�ж�ȡ����������  2������������ʱ ���������ʾ�ж����Զ�Ⱦɫ���ػ���Ⱦɫ����
local g_ZiDongTimerState 	= 0			--�Զ�Ⱦɫ״̬  0 �ر�  1 ���� 2 ��ͣ
local g_RecvGRespState 		= 0			--�Ƿ��յ�������Ⱦɫ����  0.3��������һ�� ����ֻ�з��غ� �ż�����   0 ��ʾ�ر�  1 ��ʾ����  ���Ҫ���յ����������غ� ���ж��Ƿ�ϡ�к����ó��յ�״̬ 
local g_Zidong_ClickTime 	= 300; 	--300���� ģ����Ⱦɫ��ť
local g_Rare_Time 				= 1000; --1000���� ��rou��ϡ����ɫ  �ر��Զ�timer �����ȴ�timer
local g_Rare_Count        = 3;
local g_IsFirstAuto				= 1;		--�Ƿ���auto��һ������
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
	--ʱװ��ԭ��ʱ����
	--DressPaint_FenYe2:Hide()
	-- DressPaint_Blank_Queren_Clicked()
--	DressPaint_Zidong:Hide()
--	DressPaint_Zidong_Animate:Hide()
end

--OnEvent
function DressPaint_OnEvent(event)
	
	-- ���������У����ܽ���Ⱦɫ
	if ( event == "PROGRESSBAR_SHOW" ) then
		if (this:IsVisible()) then
			DressPaint_OnHiden();
		end
	end

	-- ĳЩ���ܻ��⣬��Ҫ�رոý���
	if ( event == "CLOSE_DRESS_PAINT" ) then
		if (this:IsVisible()) then
			DressPaint_OnHiden();
		end
	end

	-- ��ʼ��̯�����ܽ���Ⱦɫ
	if ( event == "OPEN_STALL_SALE" ) then
		if (this:IsVisible()) then
			DressPaint_OnHiden();
		end
	end

	if event == "UI_COMMAND" and arg0 ~= nil and tonumber(arg0) == 0910281 then
		if this:IsVisible() then 
			DressPaint_OnHiden();
		end
		DressPaint_OK:Disable()										-- ���á�ȷ������ť
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
		
		DressPaint_OK:Disable()										-- ���á�ȷ������ť
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

		-- ����
		local nNowVisualID = tonumber(Get_XParam_INT(0))
		if nNowVisualID == -1 then
			return ;
		end
		DRESS_POS = tonumber(Get_XParam_INT(1))
		LifeAbility:Wear_Equip_VisualID(DRESS_POS,nNowVisualID)
        DressPaint_RestUpdate(DRESS_POS)
		-- ����ʹ���ĸ�ģ��
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
	elseif event == "UI_COMMAND" and arg0 ~= nil and tonumber(arg0) == 2019030101 then	--û��Ⱦɫ�ɹ�	
		if this:IsVisible() then
			g_RecvGRespState = 1
		end
	-- Ⱦɫ׷�ٽ����Ѵ򿪣����á�Ⱦɫ׷�١���ť	
	elseif event == "DISABLE_DRESS_PAINT_TRACING" then		
		if this:IsVisible() then
			
		end
	elseif event == "OBJECT_CARED_EVENT" then
		if(arg0 ~= nil and tonumber(arg0) ~= objCared) then
			return;
		end		
		--�����NPC�ľ������һ��������߱�ɾ�����Զ��ر�
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





--�¼�����
------------------------------------------------------
--
--	�����¼�
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
	-- ����ʹ���ĸ�ģ��	
	local theAction = EnumAction(Pos, "packageitem")
	if theAction:GetID() ~= 0 then
		local EquipPoint = LifeAbility:Get_Equip_Point(Pos)
		if EquipPoint ~= 2 then
			PushDebugMessage("����Ʒ����ʱװ")
			return
		end
		
		--�ж��ǲ��ǿ�Ⱦɫʱװ
		local canPaint = PlayerPackage:GetItemTableIndex(Pos)
		g_DressPaint_ItemID = canPaint
		if canPaint < 10131000 or canPaint > 10131027 then
			PushDebugMessage("#{SZPR_091023_18}")--�Բ��𣬸�ʱװ������ȾɫҪ��
			return
		end
		DressPaint_Clear()
		DRESS_POS = Pos;
		g_DressPaint_ItemID = canPaint
		LifeAbility:Lock_Packet_Item(DRESS_POS, 1)	
		DressPaint_Object:SetActionItem(theAction:GetID())
--		DressPaint_Fitting_FakeObject : SetFakeObject("");
--		DressPaint_Fitting_FakeObject : SetFakeObject("EquipChange_Player");
		
		--����ȷ����ť
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
		DressPaint_OK:Disable()										-- ���á�ȷ������ť
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
		
		if g_ZiDongState == 1  then  				--- count timer  kill  ûд�� 
  		KillTimer("DressPaint_countEvent()") 
  		PushDebugMessage("#{YJRS_140613_17}")
  	end   	
  	if g_ZiDongTimerState == 2  and g_Rare_Count < 3 then  				--- count timer  kill  ûд�� 
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

--��ʼ���Զ�״̬ ����������
function DressPaint_Zidong_ALLChoice_Init() 
	DressPaint_Zidong_ALLChoice:ResetList()  	
	DressPaint_Zidong_ALLChoice:SetText("#{YJRS_140613_03}")--ѡ��Ŀ��Ⱦɫ���  
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
		PushDebugMessage("�Բ��𣬸�ʱװ����Ⱦɫͼ��")
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

--Ⱦ��Ŀ����ɫ
function DressPaint_SuccDestMode(strDressDesc)
	local Msg = string.format("#H��ϲ����Ⱦ����%s#H���Զ�Ⱦɫ������", strDressDesc) 
	PushDebugMessage(Msg)
	DressPaint_ResetZiDongState()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnSuccDressPaint")
		Set_XSCRIPT_ScriptID(900007) 
		Set_XSCRIPT_ParamCount(0)
	Send_XSCRIPT()  
end

--Ŀ��ComListѡ���¼�
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
--	ȷ��
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
	
	-- �ж��Ƿ�Ϊ��ȫʱ��2012.6.12-LIUBO
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

--����Զ�Ⱦɫ�¼�
function DressPaint_Zidong_Clicked()			--�Զ�����  ����timer�¼�
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

--�����Զ�״̬ 1.���ֹͣ �رմ���ʱ
function DressPaint_ResetZiDongState() 	
	local _name,ComIdx = DressPaint_Zidong_ALLChoice:GetCurrentSelect()
	if ComIdx > 0 then 
		DressPaint_Zidong:SetText("#{YJRS_140613_04}") 
		DressPaint_Zidong:Disable()
		DressPaint_Zidong_Animate:Play(false)
		DressPaint_Zidong_ALLChoice:Enable() 
		DressPaint_Zidong_ALLChoice:SetText("#{YJRS_140613_03}")--ѡ��Ŀ��Ⱦɫ���  
	end 
	  DressPaint_Zidong:SetText("#{YJRS_140613_04}") 
	  if g_ZiDongTimerState == 2  and g_Rare_Count < 3 then  				--- count timer  kill  ûд�� 
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

function DressPaint_ZiDong_TimerEvent()	--ģ����Ⱦɫ��ť  0.3��һ��  
	if g_ZiDongTimerState == 1  and g_RecvGRespState == 1 then 
 	   -- �ж��Ƿ�Ϊ��ȫʱ��
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
			Set_XSCRIPT_Parameter(1, g_IsFirstAuto)			--�Ƿ��ǵ�һ���Զ�Ⱦɫ  Ϊ��������ʾ��ͬ����  1 �����һ�� 0����
			Set_XSCRIPT_Parameter(2, g_DressPaint_YuanbaoPay)			--�Ƿ��ǵ�һ���Զ�Ⱦɫ  Ϊ��������ʾ��ͬ����  1 �����һ�� 0����
			Set_XSCRIPT_ParamCount(3)
		Send_XSCRIPT() 

		g_RecvGRespState    = 0 
		g_IsFirstAuto       = 0
 	end 
end
------------------------------------------------------
--
--	�����¼�
--
function DressPaint_Show_Clicked() --�����Ӧ�Զ�Ⱦɫ��ť
	--DressPaint_Update(0,1);
	--PushDebugMessage("�뽫Ⱦɫʱװ���ڵ�������һ����")
end

------------------------------------------------------
--
--	����NPC
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
-- ��ת����ͷ��ģ�ͣ�����)
--
function DressPaint_Fitting_TurnLeft(start)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		--������ת��ʼ
		if(start == 1) then
			DressPaint_Fitting_FakeObject:RotateBegin(-0.3);
		--������ת����
		else
			DressPaint_Fitting_FakeObject:RotateEnd();
		end
	end
end

----------------------------------------------------------------------------------
--
--��ת����ͷ��ģ�ͣ�����)
--
function DressPaint_Fitting_TurnRight(start)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		--������ת��ʼ
		if(start == 1) then
			DressPaint_Fitting_FakeObject:RotateBegin(0.3);
		--������ת����
		else
			DressPaint_Fitting_FakeObject:RotateEnd();
		end
	end
end
function DressPaint_OpenDressWash_Clicked() 
	-- ��ʱװ��ԭ����
	Variable:SetVariable("DressClothPos", DressPaint_Frame:GetProperty("UnifiedPosition"), 1);
	PushEvent("UI_COMMAND",0910282,g_ObjCared)
	this:Hide()
end


function Lua_GetDressColor(nIndex)
	--�±�
	local nDressColorTable = {
	{10131000,292,"",0},
	{10131000,293,"���̷��",23000},
	{10131000,294,"���̷��",23000},
	{10131000,295,"ů����",23000},
	{10131000,296,"���Ϸ��",14000},
	{10131000,297,"�������",14000},
	{10131000,298,"���Ϸ��",14000},
	{10131000,299,"���ٷ��",1000},
	{10131000,300,"�غ���",1000},
	{10131001,283,"",0},
	{10131001,284,"�������",23000},
	{10131001,285,"��۷��",23000},
	{10131001,286,"�������",23000},
	{10131001,287,"ů����",14000},
	{10131001,288,"�ػƷ��",14000},
	{10131001,289,"���̷��",14000},
	{10131001,290,"�غ���",1000},
	{10131001,291,"���̷��",1000},
	{10131002,306,"",0},
	{10131002,307,"���̷��",23000},
	{10131002,308,"ů����",23000},
	{10131002,309,"���ٷ��",23000},
	{10131002,310,"���ŷ��",14000},
	{10131002,311,"���Ϸ��",14000},
	{10131002,312,"�������",14000},
	{10131002,313,"������",1000},
	{10131002,314,"ǳ�����",1000},
	{10131003,316,"",0},
	{10131003,317,"�ػƷ��",23000},
	{10131003,318,"ī�����",23000},
	{10131003,319,"���Ϸ��",23000},
	{10131003,320,"���̷��",14000},
	{10131003,321,"�������",14000},
	{10131003,322,"�������",14000},
	{10131003,323,"ů����",1000},
	{10131003,324,"���̷��",1000},
	{10131004,325,"",0},
	{10131004,326,"���̷��",23000},
	{10131004,327,"���Ϸ��",23000},
	{10131004,328,"�ػƷ��",23000},
	{10131004,329,"���̷��",14000},
	{10131004,330,"���̷��",14000},
	{10131004,331,"���ٷ��",14000},
	{10131004,332,"�غ���",1000},
	{10131004,333,"�ۺ���",1000},
	{10131005,369,"",0},
	{10131005,370,"���̷��",23000},
	{10131005,371,"��Ϸ��",23000},
	{10131005,372,"������",23000},
	{10131005,373,"������",14000},
	{10131005,374,"ů����",14000},
	{10131005,375,"�ɷ���",14000},
	{10131005,376,"��ع���",1000},
	{10131005,377,"������",1000},
	{10131006,378,"",0},
	{10131006,379,"�д���",23000},
	{10131006,380,"���Ϸ��",23000},
	{10131006,381,"�޻Ʒ��",23000},
	{10131006,382,"��Ʒ��",14000},
	{10131006,383,"���۷��",14000},
	{10131006,384,"��ɫ���",14000},
	{10131006,385,"�������",1000},
	{10131006,386,"���Ϸ��",1000},
	{10131007,388,"",0},
	{10131007,389,"ů�ȷ��",23000},
	{10131007,390,"������",23000},
	{10131007,391,"���Ϸ��",23000},
	{10131007,392,"ҹӰ���",14000},
	{10131007,393,"��̷��",14000},
	{10131007,394,"�������",14000},
	{10131007,395,"������",1000},
	{10131007,396,"�õ����",1000},
	{10131008,515,"",0},
	{10131008,516,"���̷��",23000},
	{10131008,517,"��Ʒ��",23000},
	{10131008,518,"�̺���",23000},
	{10131008,519,"������",14000},
	{10131008,520,"��Ӱ���",14000},
	{10131008,521,"ӯ�η��",14000},
	{10131008,522,"������",1000},
	{10131008,523,"�໨���",1000},
	{10131009,506,"",0},
	{10131009,507,"���Ϸ��",23000},
	{10131009,508,"��Ʒ��",23000},
	{10131009,509,"�Դ���",23000},
	{10131009,510,"���Ϸ��",14000},
	{10131009,511,"ˮ�̷��",14000},
	{10131009,512,"���۷��",14000},
	{10131009,513,"������",1000},
	{10131009,514,"���ҷ��",1000},
	{10131010,534,"",0},
	{10131010,535,"ǳӣ���",23000},
	{10131010,536,"��Ʒ��",23000},
	{10131010,537,"ź�ɷ��",23000},
	{10131010,538,"��Է��",14000},
	{10131010,539,"������",14000},
	{10131010,540,"�촨���",14000},
	{10131010,541,"��嫷��",1000},
	{10131010,542,"ӫ����",1000},
	{10131011,524,"",0},
	{10131011,525,"ů����",23000},
	{10131011,526,"������",23000},
	{10131011,527,"�������",23000},
	{10131011,528,"������",14000},
	{10131011,529,"���Ʒ��",14000},
	{10131011,530,"���ط��",14000},
	{10131011,531,"ϼ粷��",1000},
	{10131011,532,"�������",1000},
	{10131012,491,"",0},
	{10131012,492,"ѿ����",23000},
	{10131012,493,"տ�����",23000},
	{10131012,494,"��Ʒ��",23000},
	{10131012,495,"��᰷��",14000},
	{10131012,496,"մ�Ƿ��",14000},
	{10131012,497,"ɳ�����",14000},
	{10131012,498,"ǧ�Ʒ��",1000},
	{10131012,499,"īȾ���",1000},
	{10131013,479,"",0},
	{10131013,480,"��Ʒ��",23000},
	{10131013,481,"ī�ҷ��",23000},
	{10131013,482,"Ө�׷��",23000},
	{10131013,483,"���ɷ��",14000},
	{10131013,484,"������",14000},
	{10131013,485,"��ϼ���",14000},
	{10131013,486,"�������",1000},
	{10131013,487,"��ޱ���",1000},
	{10131014,470,"",0},
	{10131014,471,"Ѥ�ʷ��",23000},
	{10131014,472,"ǳ�̷��",23000},
	{10131014,473,"���۷��",23000},
	{10131014,474,"̶����",14000},
	{10131014,475,"���ҷ��",14000},
	{10131014,476,"�����",14000},
	{10131014,477,"��ĺ���",1000},
	{10131014,478,"���ͷ��",1000},
	{10131015,425,"",0},
	{10131015,426,"������",23000},
	{10131015,427,"�����",23000},
	{10131015,428,"���Ϸ��",23000},
	{10131015,429,"���Ʒ��",14000},
	{10131015,430,"�������",14000},
	{10131015,431,"���ŷ��",14000},
	{10131015,432,"���̷��",1000},
	{10131015,433,"���ҷ��",1000},
	{10131016,434,"",0},
	{10131016,435,"���Ϸ��",23000},
	{10131016,436,"ǳ�Ϸ��",23000},
	{10131016,437,"��Ʒ��",23000},
	{10131016,438,"�������",14000},
	{10131016,439,"�°׷��",14000},
	{10131016,440,"ʯ����",14000},
	{10131016,441,"���ķ��",1000},
	{10131016,442,"��֬���",1000},
	{10131017,443,"",0},
	{10131017,444,"���̷��",23000},
	{10131017,445,"ǳ�Ʒ��",23000},
	{10131017,446,"���Ϸ��",23000},
	{10131017,447,"���ȷ��",14000},
	{10131017,448,"�Ժ���",14000},
	{10131017,449,"������",14000},
	{10131017,450,"������",1000},
	{10131017,451,"īԨ���",1000},
	{10131018,452,"",0},
	{10131018,453,"īȾ���",23000},
	{10131018,454,"��Ʒ��",23000},
	{10131018,455,"��Ϸ��",23000},
	{10131018,456,"�д���",14000},
	{10131018,457,"ܽ�ط��",14000},
	{10131018,458,"�������",14000},
	{10131018,459,"糺���",1000},
	{10131018,460,"ҹ�ȷ��",1000},
	{10131019,461,"",0},
	{10131019,462,"���Ϸ��",23000},
	{10131019,463,"õ����",23000},
	{10131019,464,"��Ʒ��",23000},
	{10131019,465,"��᰷��",14000},
	{10131019,466,"ˮ�۷��",14000},
	{10131019,467,"�������",14000},
	{10131019,468,"������",1000},
	{10131019,469,"Ӣ�׷��",1000},
	{10131020,397,"",0},
	{10131020,398,"���̷��",23000},
	{10131020,399,"���Ϸ��",23000},
	{10131020,400,"ˮ�����",23000},
	{10131020,401,"��֬���",14000},
	{10131020,402,"糺���",14000},
	{10131020,403,"�ĺ���",14000},
	{10131020,404,"������",1000},
	{10131020,405,"��Ϸ��",1000},
	{10131021,406,"",0},
	{10131021,407,"�������",23000},
	{10131021,408,"��Ʒ��",23000},
	{10131021,409,"���ٷ��",23000},
	{10131021,410,"��ϼ���",14000},
	{10131021,411,"������",14000},
	{10131021,412,"�������",14000},
	{10131021,413,"������",1000},
	{10131021,414,"��ڤ���",1000},
	{10131022,415,"",0},
	{10131022,416,"���Ϸ��",23000},
	{10131022,417,"������",23000},
	{10131022,418,"������",23000},
	{10131022,419,"��ӣ���",14000},
	{10131022,420,"���Ʒ��",14000},
	{10131022,421,"��ŷ��",14000},
	{10131022,422,"��ҫ���",1000},
	{10131022,423,"�໨���",1000},
	{10131023,339,"",0},
	{10131023,340,"��۷��",23000},
	{10131023,341,"���ط��",23000},
	{10131023,342,"���Ϸ��",23000},
	{10131023,343,"���̷��",14000},
	{10131023,344,"���̷��",14000},
	{10131023,345,"���̷��",14000},
	{10131023,346,"�������",1000},
	{10131023,347,"�����",1000},
	{10131024,348,"",0},
	{10131024,349,"���̷��",23000},
	{10131024,350,"���ط��",23000},
	{10131024,351,"���̷��",23000},
	{10131024,352,"���Ϸ��",14000},
	{10131024,353,"ī�����",14000},
	{10131024,354,"�غ���",14000},
	{10131024,355,"���ҷ��",1000},
	{10131024,356,"�ػƷ��",1000},
	
	{10131025,559,"",0},
	{10131025,560,"���̷��",23000},
	{10131025,561,"���Ϸ��",23000},
	{10131025,562,"�������",23000},
	{10131025,563,"��̶���",14000},
	{10131025,564,"ī�۷��",14000},
	{10131025,565,"������",14000},
	{10131025,566,"�����",1000},
	{10131025,567,"�໨���",1000},	
	
	{10131026,568,"",0},
	{10131026,569,"��Ϸ��",23000},
	{10131026,570,"���Ϸ��",23000},
	{10131026,571,"������",23000},
	{10131026,572,"ˮ�̷��",14000},
	{10131026,573,"������",14000},
	{10131026,574,"������",14000},
	{10131026,575,"糺���",1000},
	{10131026,576,"���Ƿ��",1000},


	{10131027,577,"",0},
	{10131027,578,"��Ʒ��",23000},
	{10131027,579,"���ܷ��",23000},
	{10131027,580,"��ɣ���",23000},
	{10131027,581,"�������",14000},
	{10131027,582,"������",14000},
	{10131027,583,"�����",14000},
	{10131027,584,"��ҹ���",1000},
	{10131027,585,"�质���",1000},
	
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
					nColorName = nColorName.."����ͨ��"
				elseif nColorRate == 14000 then
					nColorName = nColorName.."���߼���"
				elseif nColorRate == 1000 then
					nColorName = nColorName.."��ϡ�С�"
				elseif nColorRate == -1 then
					nColorName = "Ĭ�Ϸ��"
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
					nColorName = "#G"..nColorName.."����ͨ��"
				elseif nColorRate == 14000 then
					nColorName = "#B"..nColorName.."���߼���"
				elseif nColorRate == 1000 then
					nColorName = "#cbe38ff"..nColorName.."��ϡ�С�"
				elseif nColorRate == -1 then
					nColorName = "#GĬ�Ϸ��"
				end
				break
			end
		end
		return nColorID,nColorName,nNormalName
	end
end