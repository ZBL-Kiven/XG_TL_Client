local WeaponName = {}
local g_Decorateyifu_Frame_UnifiedPosition;
local g_clientNpcId = -1
local g_WeaponBagPos = -1
local g_DestDecoWeaponId = -1
local g_DestDecoWeaponLevelId = {}
local g_bSendConfirm = 1
local myequi = -1
local NowPos = -1
local Nowmyequi = -1
local indexxx = -1
local number = -1
local Original_Visual_ID = -1
local UUUU = -1
local NowID = -1
local PPPP = -1
local Decorateyifu_Dress = {
[1]={400,401,402,403,404,405,406,407,408},--云酥梦裳
[2]={409,410,411,412,413,414,415,416,417},--雪羽霜衣
[3]={418,419,420,421,422,423,424,425,426},--万紫千红
[4]={427,428,429,430,431,432,433,434,435},--黯淡雕灵
[5]={436,437,438,439,440,441,442,443,444},--清风怡江
[6]={445,446,447,448,449,450,451,452,453},--春风余雪
[7]={454,455,446,457,458,459,460,461,462},--疏狂暗香
[8]={463,464,465,466,467,468,469,470,471},--仙羽凝月
}

local Decorateyifu_shenqi = {
[10143000]={400,401,402,403,404,405,406,407,408},
[10143010]={409,410,411,412,413,414,415,416,417},
[10143020]={418,419,420,421,422,423,424,425,426},
[10143030]={427,428,429,430,431,432,433,434,435},
[10143040]={436,437,438,439,440,441,442,443,444},
[10143050]={445,446,447,448,449,450,451,452,453},
[10143060]={454,455,446,457,458,459,460,461,462},
[10143070]={463,464,465,466,467,468,469,470,471},
}
function Decorateyifu_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("MONEY_CHANGE_EX")
	this:RegisterEvent("MONEYJZ_CHANGE_EX")
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")	--离开场景关闭界面
	this:RegisterEvent("UPDATE_DECOWEAPON_CONVER") --拖入框放入武器
	this:RegisterEvent("DECOWEAPON_CONVER_CONFIRM_OK")
end

function Decorateyifu_OnLoad() 
	g_Decorateyifu_Frame_UnifiedPosition = Decorateyifu_Frame:GetProperty("UnifiedPosition");
	for i=1, 5 do
		g_DestDecoWeaponLevelId[i] = -1
	end
end

function Decorateyifu_OnEvent(event) 

	if event == "UI_COMMAND" and arg0 ~= nil and tonumber(arg0) == 2180905 then
            Decorateyifu_Init()
--			Decorateyifu_OK1:Disable()
			this:Show()
			--g_bSendConfirm = 1
	elseif event == "UI_COMMAND" and arg0 ~= nil and tonumber(arg0) == 20181110 then
            Decorateyifu_Init()
			this:Show()
--			Decorateyifu_OK1:Disable()
			--g_bSendConfirm = 1
			   local qian = Player:GetData("MONEY")
	           	if DataPool:GetPlayerMission_ItemCountNow(30503140) < 1 then
	           PushDebugMessage("虹耀石不足无法染色")
	          KillTimer("Decorateyifu_ZDtime()")
	         return
	          end
			   if qian < 500000 then
	           PushDebugMessage("金钱不足，无法自动染色")
			   KillTimer("Decorateyifu_ZDtime()")
	           return
	           end
			UUUU = tonumber( Get_XParam_INT( 0 ))
			PPPP = tonumber( Get_XParam_INT( 1 ))
			if PPPP == 2 then
			KillTimer("Decorateyifu_ZDtime()")
--			Decorateyifu_OK1:Enable()
			Decorateyifu_OK:Enable()
			end
	        Decorateyifu_Update(UUUU)
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 201107281 and this:IsVisible()) then
    
	Decorateyifu_Update(tonumber(arg1))
	elseif (event == "ADJEST_UI_POS" ) then
		Decorateyifu_Frame_On_ResetPos()

	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		Decorateyifu_Frame_On_ResetPos()
		
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		Decorateyifu_OnHiden()
		
	elseif (event == "MONEY_CHANGE_EX") then
		local playerMoney = Player:GetData("MONEY")
		Decorateyifu_SelfMoney:SetProperty("MoneyNumber", playerMoney)
		
	elseif (event == "MONEYJZ_CHANGE_EX") then
		local playerJZ = Player:GetData("MONEY_JZ")
		Decorateyifu_SelfJiaozi:SetProperty("MoneyNumber", playerJZ)
		
	elseif (event == "UPDATE_DECOWEAPON_CONVER") then
		Decorateyifu_Update(tonumber(arg0))
	
	elseif (event == "DECOWEAPON_CONVER_CONFIRM_OK") then
		g_bSendConfirm = 0
	end
end

function Decorateyifu_Frame_On_ResetPos()
  Decorateyifu_Frame:SetProperty("UnifiedPosition", g_Decorateyifu_Frame_UnifiedPosition);
end

function Decorateyifu_Init()
    g_WeaponBagPos =-1
	Decorateyifu_FakeObject:SetFakeObject("")

	Decorateyifu_ALLChoice:Disable()
--	Decorateyifu_OK1:Disable()
	Decorateyifu_DemandMoney:SetProperty("MoneyNumber", 0)
	local playerMoney = Player:GetData("MONEY")
	Decorateyifu_SelfMoney:SetProperty("MoneyNumber", playerMoney)
	local playerJZ = Player:GetData("MONEY_JZ")
	Decorateyifu_SelfJiaozi:SetProperty("MoneyNumber", playerJZ)
	
	Decorateyifu_OK:Disable()
	Decorateyifu_Object:SetActionItem(-1)
	LifeAbility:Lock_Packet_Item(g_DestDecoWeaponId, 0)	
	g_bSendConfirm = 1
	g_DestDecoWeaponId = -1
end

function Decorateyifu_Update(bagBos)

	local theAction = EnumAction(bagBos, "packageitem")
	if theAction:GetID() ~= 0 then
				local EquipPoint = LifeAbility:Get_Equip_Point(bagBos)
			if EquipPoint ~= 2 then
				PushDebugMessage("只能放入时装")
				return
			end
	    myequi = PlayerPackage:GetItemTableIndex(bagBos)	

				
		g_WeaponBagPos = bagBos

		if g_DestDecoWeaponId ~= -1 then
		LifeAbility:Lock_Packet_Item(g_DestDecoWeaponId, 0)	
		end
		LifeAbility:Lock_Packet_Item(g_WeaponBagPos, 1)
		
		
		Decorateyifu_Object:SetActionItem(theAction:GetID())		
		g_DestDecoWeaponId = g_WeaponBagPos


		Decorateyifu_FakeObject:SetFakeObject("")
	    Decorateyifu_FakeObject:SetFakeObject("EquipChange_Player")
        if myequi >= 10125000 and myequi<= 10125008 then
		Nowmyequi = 10125000
		number = myequi - Nowmyequi
		indexxx = 1
		elseif myequi >= 10125010 and myequi<= 10125018 then
		Nowmyequi = 10125010
		number = myequi - Nowmyequi
		indexxx = 2
		elseif myequi >= 10125020 and myequi<= 10125028 then
		Nowmyequi = 10125020
		number = myequi - Nowmyequi
		indexxx = 3
		elseif myequi >= 10125030 and myequi<= 10125038 then
		Nowmyequi = 10125030
		number = myequi - Nowmyequi
		indexxx = 4
		elseif myequi >= 10125040 and myequi<= 10125048 then
		Nowmyequi = 10125040
		number = myequi - Nowmyequi
		indexxx = 5
		elseif myequi >= 10125050 and myequi<= 10125058 then
		Nowmyequi = 10125050
		number = myequi - Nowmyequi
		indexxx = 6
		elseif myequi >= 10125060 and myequi<= 10125068 then
		Nowmyequi = 10125060
		number = myequi - Nowmyequi
		indexxx = 7
		elseif myequi >= 10125070 and myequi<= 10125078 then
		Nowmyequi = 10125070
		number = myequi - Nowmyequi
		indexxx = 8	
		end
		LifeAbility : Wear_Equip_VisualID(g_DestDecoWeaponId,Decorateyifu_Dress[indexxx][number + 1])

		Decorateyifu_DemandMoney:SetProperty("MoneyNumber", 500000)
		Decorateyifu_OK:Enable()
		
		Decorateyifu_ALLChoice_Init(Nowmyequi)
	end
end

function Decorateyifu_ALLChoice_Init(index)
--local Num = table.getn(Decorateyifu_shenqi[index])
if Num == 8 then
WeaponName = {
"请选择染色风格",	
"时装染色款式一",	
"时装染色款式二",	
"时装染色款式三",	
"时装染色款式四",	
"时装染色款式五",	
"时装染色款式六",	
"时装染色款式七",	
"时装染色款式八",	
                 }
elseif Num == 10 then
WeaponName = {
"请选择染色风格",	
"时装染色款式一",	
"时装染色款式二",	
"时装染色款式三",	
"时装染色款式四",	
"时装染色款式五",	
"时装染色款式六",	
"时装染色款式七",	
"时装染色款式八",
"时装染色款式九",
"时装染色款式十",	
                 }

else
WeaponName = {
"请选择染色风格",	
"时装染色款式一",	
"时装染色款式二",	
"时装染色款式三",	
"时装染色款式四",	
"时装染色款式五",	
"时装染色款式六",	
"时装染色款式七",	
"时装染色款式八",
"时装染色款式九",	
                 }
				 end
	Decorateyifu_ALLChoice:ResetList()
	-- for i = 0 , table.getn(Decorateyifu_shenqi[index]) do 
		-- Decorateyifu_ALLChoice:AddTextItem(WeaponName[i+1] ,i) 
	-- end 
	
	Decorateyifu_ALLChoice:Enable() 
--	Decorateyifu_OK1:Enable() 
end

function Decorateyifu_RestData()
	if g_WeaponBagPos ~= -1 then
		LifeAbility:Lock_Packet_Item(g_WeaponBagPos, 0)
		g_WeaponBagPos = -1
	end
	g_WeaponBagPos = -1
	g_DestDecoWeaponId = -1
	
	for i=1, 5 do
		g_DestDecoWeaponLevelId[i] = -1
	end
end

function Decorateyifu_OnHiden()
	this:CareObject( g_clientNpcId, 0, "Decorateyifu" )
	Decorateyifu_FakeObject:SetFakeObject("")
	g_clientNpcId = -1
	Decorateyifu_Init()
	this:Hide() 
end

function Decorateyifu_Level_Changed() 
	local _name,ComIdx = Decorateyifu_ALLChoice:GetCurrentSelect()
	if ComIdx == 0 then
	Decorateyifu_FakeObject:SetFakeObject("")
	return
	end
	if ComIdx > 0 and ComIdx < 89 and Decorateyifu_shenqi[Nowmyequi][ComIdx] ~= nil then
	Decorateyifu_FakeObject:SetFakeObject("")
	Decorateyifu_FakeObject:SetFakeObject("EquipChange_Player")
	LifeAbility : Wear_Equip_VisualID(g_DestDecoWeaponId,Decorateyifu_shenqi[Nowmyequi][ComIdx]) 
    if myequi == 10554081 or (myequi >= 10554109 and myequi<= 10554117) then		
	PushDebugMessage("云暖芳华暂不支持自动染色")
--	Decorateyifu_OK1:Disable()
	else
	NowID = (ComIdx + Nowmyequi) - 1 
	end
	end
end

function Decorateyifu_TurnLeft(start)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		--向左旋转开始
		if(start == 1) then
			Decorateyifu_FakeObject:RotateBegin(-0.3);
		--向左旋转结束
		else
			Decorateyifu_FakeObject:RotateEnd();
		end
	end
end

----------------------------------------------------------------------------------
function Decorateyifu_TurnRight(start)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		--向右旋转开始
		if(start == 1) then
			Decorateyifu_FakeObject:RotateBegin(0.3);
		--向右旋转结束
		else
			Decorateyifu_FakeObject:RotateEnd();
		end
	end
end

function Decorateyifu_OnOK()
    Clear_XSCRIPT()
	Set_XSCRIPT_Function_Name("OnDressPaint")
	Set_XSCRIPT_ScriptID(900001)--重写染色脚本，不然不匹配同用
	Set_XSCRIPT_Parameter(0, g_DestDecoWeaponId)
	Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()	

end

function Decorateyifu_ZDtime ()
			   local qian = Player:GetData("MONEY")
	           	if DataPool:GetPlayerMission_ItemCountNow(30503140) < 1 then
	           PushDebugMessage("虹耀石不足无法染色")
	          KillTimer("Decorateyifu_ZDtime()")
	         return
	          end
			   if qian < 500000 then
	           PushDebugMessage("金钱不足，无法自动染色")
			   KillTimer("Decorateyifu_ZDtime()")
	           return
	           end
    Clear_XSCRIPT()
	Set_XSCRIPT_Function_Name("OnDressPaint")
	Set_XSCRIPT_ScriptID(900001)--重写染色脚本，不然不匹配同用
	Set_XSCRIPT_Parameter(0, g_DestDecoWeaponId)
	Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()	

end
function Decorateyifu_Resume_Equip()
	if g_WeaponBagPos ~= -1 then
		Decorateyifu_Init()
	end
end

function Decorateyifu_OnHelp()
	PushEvent("OPEN_FUQICHENGHAO",3)
end





