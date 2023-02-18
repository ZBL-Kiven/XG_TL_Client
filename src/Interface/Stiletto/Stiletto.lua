local EQUIP_BUTTONS;
local EQUIP_QUALITY = -1;
local MATERIAL_BUTTONS;
local MATERIAL_QUALITY = -1;
local lastMaterial = -1
local Need_Item = 0
local Need_Money =0
local Need_Item_Count = 0
local Bore_Count=0
local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;

local g_Object = -1;

local Stiletto_CostItemIndex = -1;

local g_Stiletto_Frame_UnifiedPosition;

function Stiletto_PreLoad()

	this:RegisterEvent("UPDATE_STILETTO");
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("PACKAGE_ITEM_CHANGED");
	this:RegisterEvent("RESUME_ENCHASE_GEM");
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")

end

function Stiletto_OnLoad()
	EQUIP_BUTTONS = Stiletto_Item
	MATERIAL_BUTTONS = Stiletto_Material
	
	 g_Stiletto_Frame_UnifiedPosition=Stiletto_Frame:GetProperty("UnifiedPosition");
end

function Stiletto_OnEvent(event)

	if ( event == "UI_COMMAND" and tonumber(arg0) == 25) then
			Dress_Stiletto_CloseOtherWindows()	
			this:Show();
			Stiletto_Clear();
			local xx = Get_XParam_INT(0);
			objCared = DataPool : GetNPCIDByServerID(xx);
			AxTrace(0,1,"xx="..xx .. " objCared="..objCared)
			if objCared == -1 then
                    --ȥ�����У���Ϊ������Ϣ���ʺ���ʾ�ڿͻ���
					--PushDebugMessage("server�����������������⡣");
					return;
			end
			BeginCareObject_Stiletto(objCared)
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 201107281 and this:IsVisible()) then
		if arg1 == nil then
			return
		end
		local itemID = PlayerPackage:GetItemTableIndex(tonumber(arg1));
		if itemID < 19999999 and itemID > 10000000 then
			--Ϊװ��
			Stiletto_Update(1,tonumber(arg1),1)
			return
		end
		if itemID < 50000000 and itemID > 20000000 then
			--Ϊ����
			Stiletto_Update(2,tonumber(arg1),1)
			return
		end
	     
		-- ���﷢�͸������
		-- local theAction = EnumAction(pos_packet, "packageitem");
		-- SetActionItem(theAction:GetID())	
	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		
		--�����NPC�ľ������һ��������߱�ɾ�����Զ��ر�
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			
			--ȡ������
			Stiletto_Cancel_Clicked()
		end

	elseif ( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() ) then

		lastMaterial = -1
		if( arg0~= nil and -1 == tonumber(arg0)) then
			return;
		end

		
		if (EQUIP_QUALITY == tonumber(arg0) ) then
			Stiletto_Update(1,tonumber(arg0))
		end
			
		if (MATERIAL_QUALITY == tonumber(arg0) ) then
			Stiletto_Clear()
			Stiletto_Update(2,tonumber(arg0))
		end
	
		
	elseif ( event == "RESUME_STILETTO_EQUIP" ) then
		Resume_Equip(1);
	elseif( event == "UPDATE_STILETTO") then
		AxTrace(0,1,"arg0="..arg0)
		if arg0 == nil or arg1 == nil then
			return
		end

		Stiletto_Update(tonumber(arg0),tonumber(arg1));		

	elseif( event == "RESUME_ENCHASE_GEM" and this:IsVisible() ) then
		if(arg0~=nil and tonumber(arg0) == 3) then
			Resume_Equip_Stiletto(1);
		elseif(arg0~=nil and tonumber(arg0) == 35) then
			Resume_Equip_Stiletto(2);
		end
		
	elseif (event == "ADJEST_UI_POS" ) then
		Stiletto_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		Stiletto_Frame_On_ResetPos()
		
	end
end

function Stiletto_OnShown()
	Stiletto_Clear()
end

function Stiletto_Clear()
	if(EQUIP_QUALITY ~= -1) then
		EQUIP_BUTTONS : SetActionItem(-1);
		LifeAbility : Lock_Packet_Item(EQUIP_QUALITY,0);
		EQUIP_QUALITY = -1;
	end
	lastMaterial = -1
	
--	Stiletto_Material_Bak : SetProperty("Image", "set:CommonItem image:ActionBK"); 
--	Stiletto_Material_Bak	: SetToolTip("")
	if(MATERIAL_QUALITY ~= -1) then
		MATERIAL_BUTTONS : SetActionItem(-1);
		LifeAbility : Lock_Packet_Item(MATERIAL_QUALITY,0);
		MATERIAL_QUALITY = -1;
	end
	Stiletto_Money : SetProperty("MoneyNumber", "");
	Stiletto_State: SetText("")
	Stiletto_CostItemIndex =-1
end
function Dress_Stiletto_CloseOtherWindows()
	if(IsWindowShow("Dress_Enchase")) then
		CloseWindow("Dress_Enchase", true);
	end			
	if(IsWindowShow("Dress_Transfer")) then
		CloseWindow("Dress_Transfer", true);
	end			
	if(IsWindowShow("Dress_SplitGem")) then
		CloseWindow("Dress_SplitGem", true);
	end				
end
function Stiletto_Update(pos1,pos0)
	local pos_packet,pos_ui;
	pos_packet = tonumber(pos0);
	pos_ui		 = tonumber(pos1)

	local theAction = EnumAction(pos_packet, "packageitem");
	if pos_ui == 1 then
		if theAction:GetID() ~= 0 then
			
			local Bore_Count1 = 0;
		  local Need_Item1 = -1;
		  local Need_Money1 = 0;
		  local Need_Item_Count1 =0;
			
			--Need_Item,Need_Money,Need_Item_Count,Bore_Count=LifeAbility : Stiletto_Preparation(pos_packet);
			Need_Item1,Need_Money1,Need_Item_Count1,Bore_Count1=LifeAbility : Stiletto_Preparation(pos_packet, 1); --1��ʾȡ��һ������ֵ
			
			if Need_Item1 == 0 then
				return
			end
					
			if Bore_Count1 > 2 then --add:lby 20080521 
				PushDebugMessage("�˴�ֻ�ܴ�ǰ3����")
				Stiletto_Clear()
				return
			end
			
			if Need_Item1 < -1 then
				PushDebugMessage("����Ʒ�޷����Ӱ���")
				return
			end
			
			
			Need_Item = Need_Item1
			Need_Money = Need_Money1 
			Need_Item_Count = Need_Item_Count1
			Bore_Count = Bore_Count1
			
			
			--��֮ǰ�Ķ�������
			if EQUIP_QUALITY ~= -1 then
				LifeAbility : Lock_Packet_Item(EQUIP_QUALITY,0);
				Stiletto_Money : SetProperty("MoneyNumber", "");
				Stiletto_State: SetText("")
			end

			EQUIP_BUTTONS:SetActionItem(theAction:GetID());
			EQUIP_QUALITY = pos_packet;
			LifeAbility : Lock_Packet_Item(EQUIP_QUALITY,1);
		else
			EQUIP_BUTTONS:SetActionItem(-1);
			LifeAbility : Lock_Packet_Item(EQUIP_QUALITY,0);
			EQUIP_QUALITY = -1;
			Stiletto_Money : SetProperty("MoneyNumber", "");
			Stiletto_State: SetText("")
			return;
		end
		Stiletto_Money : SetProperty("MoneyNumber", tostring(Need_Money));
		Stiletto_State : SetText("��ǰ������:"..Bore_Count..";�������Ӱ�����:"..tostring(3-Bore_Count))
	elseif pos_ui == 2 then
		
		local Item_Class = PlayerPackage : GetItemSubTableIndex(pos_packet,0)
		local Item_Quality = PlayerPackage : GetItemSubTableIndex(pos_packet,1)
		local Item_Type = PlayerPackage : GetItemSubTableIndex(pos_packet,2)
		
		local itemindex = PlayerPackage : GetItemTableIndex(pos_packet)
		
		
		
	  if itemindex == 20109101 or itemindex == 20310111 then  --add:lby 20080521���֮�䲻�ܷ��룬���񾫴ⲻ�ܷ���
	 		PushDebugMessage("����Ʒ�޷��ڴ˴�ʹ��")
	 		return
	  end

		if Item_Class ~= 2 or Item_Quality ~= 1 or Item_Type ~= 9 then
			return
		end
		
		--����һ��
		Stiletto_CostItemIndex = itemindex

		if theAction:GetID() ~= 0 then
			MATERIAL_BUTTONS:SetActionItem(theAction:GetID());
			if MATERIAL_QUALITY ~= -1 then
				LifeAbility : Lock_Packet_Item(MATERIAL_QUALITY,0);
			end
			--��֮ǰ�Ķ�������
			MATERIAL_QUALITY = pos_packet;
			LifeAbility : Lock_Packet_Item(MATERIAL_QUALITY,1);
		else
			MATERIAL_BUTTONS:SetActionItem(-1);
			LifeAbility : Lock_Packet_Item(MATERIAL_QUALITY,0);
			MATERIAL_QUALITY = -1;
			return;
		end
		
	end
	

--add here

end

function Stiletto_Buttons_Clicked()
	if MATERIAL_QUALITY == -1 then
		PushDebugMessage("������ײ���")
		return
	end
	if EQUIP_QUALITY ~= -1 then
		if Need_Item == -2 then
			PushDebugMessage("����Ʒ�޷����Ӱ���")
		elseif Need_Item == -3 then
			PushDebugMessage("�����Ѵﵽ�������")
--		elseif DataPool:GetPlayerMission_ItemCountNow(Need_Item) < Need_Item_Count then
--			PushDebugMessage("ȱ�ٲ���")
		elseif Player:GetData("MONEY") + Player:GetData("MONEY_JZ") < Need_Money then
			PushDebugMessage("��Ǯ����")
		else
			
			local Notify = 0			
			if lastMaterial ~= MATERIAL_QUALITY then
				lastMaterial = MATERIAL_QUALITY
				Notify = 1
			end
			
			local isMaterialBind = GetItemBindStatus(MATERIAL_QUALITY)

			if Notify == 1 and isMaterialBind == 1 then
				DressEnchasing:Dress_EnchaseShowInfo("ZBDK_100112_1")
				return
			end			
			
			Clear_XSCRIPT();
				Set_XSCRIPT_Function_Name("OnStiletto");
				Set_XSCRIPT_ScriptID(311200);
				Set_XSCRIPT_Parameter(0,EQUIP_QUALITY);
				Set_XSCRIPT_Parameter(1,MATERIAL_QUALITY);
				Set_XSCRIPT_ParamCount(2);
			Send_XSCRIPT();
		end
	else
		PushDebugMessage("�����һ��װ��")
	end
	
end

function Stiletto_Close()
	--�����ã��ñ������λ�ñ���
	this:Hide();
	Stiletto_Clear();
	StopCareObject_Stiletto(objCared)
end

function Stiletto_Cancel_Clicked()
	Stiletto_Close();
	return;
end

--=========================================================
--��ʼ����NPC��
--�ڿ�ʼ����֮ǰ��Ҫ��ȷ����������ǲ����Ѿ��С����ġ���NPC��
--����еĻ�����ȡ���Ѿ��еġ����ġ�
--=========================================================
function BeginCareObject_Stiletto(objCaredId)

	g_Object = objCaredId;
	this:CareObject(g_Object, 1, "Stiletto");

end

--=========================================================
--ֹͣ��ĳNPC�Ĺ���
--=========================================================
function StopCareObject_Stiletto(objCaredId)
	this:CareObject(objCaredId, 0, "Stiletto");
	g_Object = -1;

end

function Resume_Equip_Stiletto(nIndex)

	if( this:IsVisible() ) then
	
		if(nIndex == 1) then
			if(EQUIP_QUALITY ~= -1) then
				LifeAbility : Lock_Packet_Item(EQUIP_QUALITY,0);
				EQUIP_BUTTONS : SetActionItem(-1);
				EQUIP_QUALITY	= -1;
				Stiletto_Money : SetProperty("MoneyNumber", "");
				Stiletto_State: SetText("")
			end
		else
			if(MATERIAL_QUALITY ~= -1) then
				LifeAbility : Lock_Packet_Item(MATERIAL_QUALITY,0);
				MATERIAL_BUTTONS : SetActionItem(-1);
				MATERIAL_QUALITY	= -1;
			end	
		end
		
	end
	
end

function Stiletto_Frame_On_ResetPos()
  Stiletto_Frame:SetProperty("UnifiedPosition", g_Stiletto_Frame_UnifiedPosition);
end
