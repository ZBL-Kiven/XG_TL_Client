--通用双匡UI界面 Q546528533
local MAX_OBJ_DISTANCE = 3.0;
local objCared = -1;
local g_Object = -1;
local TongYongUiDub_g_CommandType = 1
local Dark_Button = -1
local Equip_Bag_Index = -1
local nEquip_Bag_Index = -1
function TongYongUiDub_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("RESUME_ENCHASE_GEM");
	--金钱改变的处理
	this:RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("MONEYJZ_CHANGE");
end

function TongYongUiDub_OnLoad()
	Dark_Button = TongYongUiDub_Special_Button;
	Dark_Buttona = TongYongUiDub_Speciala_Button;
end

function TongYongUiDub_OnEvent(event)
	if(event == "UI_COMMAND" and tonumber(arg0) == 20200608) then
		if this : IsVisible() then									-- 如果界面开着，则不处理
			TongYongUiDub_Close();
		end
		
		objCared = -1;
		local xx = Get_XParam_INT(1);
		objCared = DataPool : GetNPCIDByServerID(xx);
		AxTrace(0,0,"xx="..xx .. " objCared="..objCared)
		if objCared == -1 then
				PushDebugMessage("server传过来的数据有问题。");
				return;
		end
		TongYongUiDub_BeginCareObject(objCared);

		TongYongUiDub_g_CommandType = Get_XParam_INT(0);
		TongYongUiDub_InitDlg();
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 201107281 and this:IsVisible()) then
      if Equip_Bag_Index == -1 then
		TongYongUiDub_Update(arg1,-1)
      else
	    TongYongUiDub_Update(-1,arg1)
	  end
	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			
			--取消关心
			TongYongUiDub_Close()
		end
	elseif(event == "RESUME_ENCHASE_GEM" and this:IsVisible())then
		if(tonumber(arg0) == 72) then
			TongYongUiDub_Resume();
		end
	elseif( (event == "UNIT_MONEY" or event == "MONEYJZ_CHANGE") and this:IsVisible()) then
		TongYongUiDub_UpdateMoneyDisp();
	end
end

function TongYongUiDub_UpdateMoneyDisp()
		local playerMoney = Player:GetData("MONEY");
		local playerMoneyJZ = Player:GetData("MONEY_JZ");
		TongYongUiDub_NeedMoney:SetProperty("MoneyMaxNumber", playerMoney + playerMoneyJZ);
		--TongYongUiDub_NeedMoney:SetProperty("MoneyNumber", nNeed);
		TongYongUiDub_SelfJiaozi:SetProperty("MoneyNumber", playerMoneyJZ);
		TongYongUiDub_SelfMoney:SetProperty("MoneyNumber", playerMoney);
end

function TongYongUiDub_InitDlg( )
	if  TongYongUiDub_g_CommandType == 1 then   --属性时装修复
		TongYongUiDub_DragTitle:SetText("属性时装转移");
		TongYongUiDub_Info:SetText("  玩家可通过本功能，将属性时装的属性转移至其他属性，这样就会穿上自己想要的时装外观啦。");
		TongYongUiDub_Static2:SetText("先放入时装后放入转移属性的时装");
		TongYongUiDub_UpdateMoneyDisp();
		TongYongUiDub_NeedMoney:SetProperty("MoneyNumber", 10000);
		this:Show();
		TongYongUiDub_OK:Disable();
	end
end

function TongYongUiDub_OK_Clicked()
	if (Equip_Bag_Index ~= -1) then
		local EquipPoint = LifeAbility : Get_Equip_Point(Equip_Bag_Index)
		  if TongYongUiDub_g_CommandType == 1 then
		    if (EquipPoint ~= 2) then
			    PushDebugMessage("此处只能放入时装")
			   return
		    end
		  end
		--客户端预先判断金钱，减轻服务器压力
		local nHave = TongYongUiDub_NeedMoney:GetProperty("MoneyMaxNumber");
		local nNeed = TongYongUiDub_NeedMoney:GetProperty("MoneyNumber");
		if (tonumber(nNeed) > tonumber(nHave)) then
			 PushDebugMessage("#{FBSJ_081209_25}");
			 return;
		end
		if TongYongUiDub_g_CommandType == 1 then --重置属性时装属性
					Clear_XSCRIPT();
						Set_XSCRIPT_Function_Name("Scripttransitcenter");
						Set_XSCRIPT_ScriptID(892002);
						Set_XSCRIPT_Parameter(0,26)
						Set_XSCRIPT_Parameter(1,Equip_Bag_Index)
						Set_XSCRIPT_Parameter(2,nEquip_Bag_Index)
						Set_XSCRIPT_ParamCount(3)
					Send_XSCRIPT();
		end
		
	end
	TongYongUiDub_Clear()
end


function TongYongUiDub_Cancel_Clicked()
	TongYongUiDub_Close();
end

function TongYongUiDub_Clear()
	 TongYongUiDub_Resume();
end


function TongYongUiDub_Update(Item_index,nItem_index)
    if nItem_index == -1 then
	local i_index = tonumber(Item_index)
	local theAction = EnumAction(i_index, "packageitem");	
	--先把对象给清了
	-- TongYongUiDub_Resume();	
	if theAction:GetID() ~= 0 then
		Dark_Button:SetActionItem(theAction:GetID());
		Equip_Bag_Index = i_index;
		LifeAbility : Lock_Packet_Item(i_index,1);
		TongYongUiDub_OK:Enable();
	end
	end
    if Item_index == -1 then
	local i_index = tonumber(nItem_index)
	local theAction = EnumAction(i_index, "packageitem");	
	--先把对象给清了
	-- TongYongUiDub_Resume();	
	if theAction:GetID() ~= 0 then
		Dark_Buttona:SetActionItem(theAction:GetID());
		nEquip_Bag_Index = i_index;
		LifeAbility : Lock_Packet_Item(i_index,1);
		TongYongUiDub_OK:Enable();
	end
	end
	
end


function TongYongUiDub_Resume()	
	TongYongUiDub_OK:Disable();
	    Dark_Button:SetActionItem(-1);
		LifeAbility : Lock_Packet_Item(Equip_Bag_Index,0);
		Equip_Bag_Index = -1;
	    Dark_Buttona:SetActionItem(-1);	
		LifeAbility : Lock_Packet_Item(nEquip_Bag_Index,0);
		nEquip_Bag_Index = -1;
end

function TongYongUiDub_Close()
	this:Hide()
	StopCareObject_Enchase(objCared)
end


--=========================================================
--开始关心NPC，
--在开始关心之前需要先确定这个界面是不是已经有“关心”的NPC，
--如果有的话，先取消已经有的“关心”
--=========================================================
function TongYongUiDub_BeginCareObject(objCaredId)

	g_Object = objCaredId;
	AxTrace(0,0,"LUA___CareObject g_Object =" .. g_Object );
	this:CareObject(g_Object, 1, "TongYongUiDub");

end

--=========================================================
--停止对某NPC的关心
--=========================================================
function TongYongUiDub_StopCareObject(objCaredId)
	this:CareObject(objCaredId, 0, "TongYongUiDub");
	g_Object = -1;
	

end