
local g_DecorateWeaponEx_Frame_UnifiedPosition;
local g_clientNpcId = -1
local g_WeaponBagPos = -1
local g_DestDecoWeaponId = -1
local g_DestDecoWeaponLevelId = {}
local g_bSendConfirm = 1
local g_SourceDecoWeaponId = -1
local g_XuanZhong = -1
local g_StartID = 10102220
local g_EndID = 10103000
function DecorateWeaponEx_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("UNIT_MONEY")
	this:RegisterEvent("MONEYJZ_CHANGE")
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")	--离开场景关闭界面
	this:RegisterEvent("SEX_CHANGED");
	this:RegisterEvent("DECOWEAPON_CONVER_CONFIRM_OK")
end

function DecorateWeaponEx_OnLoad() 
	g_DecorateWeaponEx_Frame_UnifiedPosition = DecorateWeaponEx_Frame:GetProperty("UnifiedPosition");
	for i=1, 5 do
		g_DestDecoWeaponLevelId[i] = -1
	end
end

function DecorateWeaponEx_OnEvent(event) 

	if event == "UI_COMMAND" and arg0 ~= nil and tonumber(arg0) == 20210330 then
		local Type = Get_XParam_INT(0)
		
		if Type == 1 then       --打开界面
			if this : IsVisible() then									-- 如果界面开着，则不处理
				return
			end
			
			local npcObjId = Get_XParam_INT(1)
			g_clientNpcId = DataPool : GetNPCIDByServerID(npcObjId)
			if g_clientNpcId == -1 then
				PushDebugMessage("未发现 NPC")
				DecorateWeaponEx_OnHiden()
				return
			end
		
			this:CareObject( g_clientNpcId, 1, "DecorateWeaponEx" )
			
			DecorateWeaponEx_FakeObject:SetFakeObject("")
			
			
			DecorateWeaponEx_Init()
			this:Show()
			g_bSendConfirm = 1
			
		elseif Type == 2 then		--成功刷新界面
			DecorateWeaponEx_Init()
		end
	
	elseif (event == "ADJEST_UI_POS" ) then
		DecorateWeaponEx_Frame_On_ResetPos()

	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		DecorateWeaponEx_Frame_On_ResetPos()
		
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		DecorateWeaponEx_OnHiden()
		
	elseif (event == "UNIT_MONEY") then
		local playerMoney = Player:GetData("MONEY")
		DecorateWeaponEx_SelfMoney:SetProperty("MoneyNumber", playerMoney)
		
	elseif (event == "MONEYJZ_CHANGE") then
		local playerJZ = Player:GetData("MONEY_JZ")
		DecorateWeaponEx_SelfJiaozi:SetProperty("MoneyNumber", playerJZ)
		
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 201107281 and this:IsVisible()) then
		if tonumber(arg1) ~= -1 and tonumber(arg1) ~= nil then   --放入武器
			DecorateWeaponEx_Update(tonumber(arg1))
	    end
	elseif (event == "DECOWEAPON_CONVER_CONFIRM_OK") then
		g_bSendConfirm = 0
	elseif event == "SEX_CHANGED" and  this:IsVisible() then
		DecorateWeaponEx_FakeObject : Hide();
		DecorateWeaponEx_FakeObject : Show();
		DecorateWeaponEx_FakeObject:SetFakeObject("EquipChange_Player");
	end
end

function DecorateWeaponEx_Frame_On_ResetPos()
  DecorateWeaponEx_Frame:SetProperty("UnifiedPosition", g_DecorateWeaponEx_Frame_UnifiedPosition);
end

function DecorateWeaponEx_Init()
	DecorateWeaponEx_RestData()
	
	DecorateWeaponEx_ALLChoice:Disable()
	DecorateWeaponEx_ALLChoice:SetText("#{DECOW_160126_16}")
	
	DecorateWeaponEx_DemandMoney:SetProperty("MoneyNumber", 0)
	local playerMoney = Player:GetData("MONEY")
	DecorateWeaponEx_SelfMoney:SetProperty("MoneyNumber", playerMoney)
	local playerJZ = Player:GetData("MONEY_JZ")
	DecorateWeaponEx_SelfJiaozi:SetProperty("MoneyNumber", playerJZ)
	
	DecorateWeaponEx_OK:Disable()
	DecorateWeaponEx_Object:SetActionItem(-1)
	g_bSendConfirm = 1
end

function DecorateWeaponEx_Update(bagBos)
	DecorateWeaponEx_RestData()
	g_SourceDecoWeaponId = PlayerPackage:GetItemTableIndex(bagBos)	
	local iSok = LuaFnGetIsDecorateWeaponEx(g_SourceDecoWeaponId)
	if iSok == 0 then
	    PushDebugMessage("#H你放入的武器无法锻造为幻饰武器！")
		return
	end
	local theAction = EnumAction(bagBos, "packageitem")
	if theAction:GetID() ~= 0 then
	    local DestDecoWeaponId = math.mod(g_SourceDecoWeaponId,10) + 1
		
		g_WeaponBagPos = bagBos
		
		LifeAbility:Lock_Packet_Item(g_WeaponBagPos, 1)
		DecorateWeaponEx_Object:SetActionItem(theAction:GetID())
		
		g_DestDecoWeaponId = DestDecoWeaponId
		
		DecorateWeaponEx_DemandMoney:SetProperty("MoneyNumber", 100000)
		DecorateWeaponEx_OK:Enable()
		
		DecorateWeaponEx_ALLChoice_Init()
		g_bSendConfirm = 1
		DecorateWeaponEx_FakeObject:SetFakeObject("EquipChange_Player")
	end
end

function DecorateWeaponEx_ALLChoice_Init()
	local WeaponName = {}
	for i=1, GetDecoWeaponMsgEx(-1) do
		g_DestDecoWeaponLevelId[i] = -1
	end
	for i = 1,GetDecoWeaponMsgEx(-1) do
		WeaponName[i],g_DestDecoWeaponLevelId[i] = GetDecoWeaponMsgEx(i)
	end	
	if name1 == -1 then
		return
	end
	
	DecorateWeaponEx_ALLChoice:ResetList()
		 	
	-- DecorateWeaponEx_ALLChoice:SetText(WeaponName[1])
	
	for i = 1 , GetDecoWeaponMsgEx(-1) do 
		DecorateWeaponEx_ALLChoice:AddTextItem(WeaponName[i] ,i) 
	end 
	
	DecorateWeaponEx_ALLChoice:Enable() 
	--显示默认效果
	local VisualID = g_DestDecoWeaponLevelId[1]--GetDecoWeaponMsg(g_DestDecoWeaponLevelId[1])
	DecorateWeaponEx_FakeObject:SetFakeObject("");	
	DecorateWeaponEx_FakeObject:SetFakeObject("EquipChange_Player");	
	LifeAbility:Wear_Equip_VisualID(g_WeaponBagPos,VisualID)
end

function DecorateWeaponEx_RestData()
	if g_WeaponBagPos ~= -1 then
		LifeAbility:Lock_Packet_Item(g_WeaponBagPos, 0)
		g_WeaponBagPos = -1
	end
	g_WeaponBagPos = -1
	g_DestDecoWeaponId = -1
	
	for i=1, GetDecoWeaponMsgEx(-1) do
		g_DestDecoWeaponLevelId[i] = -1
	end
end

function DecorateWeaponEx_OnHiden()
	LifeAbility : Update_Equip_VisualID()
	this:CareObject( g_clientNpcId, 0, "DecorateWeaponEx" )
	DecorateWeaponEx_FakeObject:SetFakeObject("")
	g_clientNpcId = -1
	
	DecorateWeaponEx_RestData()
	this:Hide() 
end

function DecorateWeaponEx_Level_Changed() 

	local _name,ComIdx = DecorateWeaponEx_ALLChoice:GetCurrentSelect()
	
	if ComIdx > 0 and ComIdx < 49 and g_DestDecoWeaponLevelId[ComIdx] ~= -1 then 
		local VisualID = g_DestDecoWeaponLevelId[ComIdx]--GetDecoWeaponMsg(g_DestDecoWeaponLevelId[ComIdx])
		DecorateWeaponEx_FakeObject:SetFakeObject("");	
		DecorateWeaponEx_FakeObject:SetFakeObject("EquipChange_Player");	
		LifeAbility:Wear_Equip_VisualID(g_WeaponBagPos,VisualID)
		g_XuanZhong = ComIdx
	end
end

function DecorateWeaponEx_TurnLeft(start)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		--向左旋转开始
		if(start == 1) then
			DecorateWeaponEx_FakeObject:RotateBegin( -0.3);
		--向左旋转结束
		else
			DecorateWeaponEx_FakeObject:RotateEnd();
		end
	end
end

----------------------------------------------------------------------------------
function DecorateWeaponEx_TurnRight(start)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		--向右旋转开始
		if(start == 1) then
			DecorateWeaponEx_FakeObject:RotateBegin( -0.3);
		--向右旋转结束
		else
			DecorateWeaponEx_FakeObject:RotateEnd();
		end
	end
end

function DecorateWeaponEx_OnOK()
	if g_WeaponBagPos ~= -1 then
		local myMoney = Player:GetData("MONEY_JZ") + Player:GetData("MONEY")
		
		if myMoney < 100000 then
			PushDebugMessage("#{DECOW_160126_33}")
			return
		end
		
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("DoSuperDecorateWeaponEx")
			Set_XSCRIPT_ScriptID(500506)
			Set_XSCRIPT_Parameter(0, g_WeaponBagPos)
			Set_XSCRIPT_Parameter(1, g_XuanZhong)
			Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT()
	end
end

function DecorateWeaponEx_Resume_Equip()
	if g_WeaponBagPos ~= -1 then
		DecorateWeaponEx_Init()
	end
end

function DecorateWeaponEx_OnHelp()
	PushEvent("OPEN_FUQICHENGHAO",3)
end

function LuaFnGetIsDecorateWeaponEx(nItemID)
    local qual = SuperTooltips:GetEquipQual();
	if tonumber(qual) == 9 then
	    return 1
	end
	return 0
end

function GetDecoWeaponMsgEx(itemID)
local DecoWeaponMsg = {
{10102101,1197},
{10102102,1193},
{10102103,1201},
{10102104,1213},
{10102105,1209},
{10102106,1205},
{10102107,1249},
{10102108,1245},
{10102109,1233},
{10102110,1229},
{10102111,1241},
{10102112,1237},
{10102113,1217},
{10102114,1225},
{10102115,1221},
{10102116,1314},
{10102117,1323},
{10102118,1328},
{10102119,1333},
{10102120,1339},
{10102121,1354},
{10102122,1364},
{10102123,1374},
{10102124,1384},
{10102125,1440},
{10102126,1455},
{10102127,1485},
{10102128,1475},
{10102129,1480},
{10102130,1490},
{10102131,1495},
{10102132,1565},
{10102133,1550},
{10102134,1545},
{10102135,1435},
{10102136,1580},
{10102137,1586},
{10102138,1595},
{10102139,1785},
		}
	if itemID == -1 then --查询个数的
	    return table.getn(DecoWeaponMsg)
	end
    local Name,VisualID = "",0
		Name = LuaFnGetItemName(DecoWeaponMsg[itemID][1])--此处升级
		VisualID = DecoWeaponMsg[itemID][2]
	return Name,VisualID
end
