
local MAX_OBJ_DISTANCE = 3.0;

local g_GemItemPos = -1;
local g_GemItemID = -1;
local g_NeedItemPos = -1;
local g_NeedItemID = -1;
local g_NeedMoney = 0;
local g_RightGem = 0;
local EB_BINDED = 1;				-- �Ѿ���

local g_LastGemItemID = -1;
local g_LastNeedItemID = -1;

local ObjCaredIDID = -1;
local g_GemCarve_YuanBaoPay = 1

local g_GemCarve_Frame_UnifiedPosition;

function GemCarve_PreLoad()

	this:RegisterEvent("UPDATE_GEMCARVE");
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("PACKAGE_ITEM_CHANGED");

	this:RegisterEvent("RESUME_ENCHASE_GEM")
	this:RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("MONEYJZ_CHANGE")
	this:RegisterEvent("BUY_ITEM")				--��ݹ��򣬸��½���
	
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function GemCarve_OnLoad()
    g_GemCarve_Frame_UnifiedPosition=GemCarve_Frame:GetProperty("UnifiedPosition");
    g_GemCarve_YuanBaoPay = 1;
end

function GemCarve_OnEvent(event)

	if ( event == "UI_COMMAND" and tonumber(arg0) == 112236) then

			local npcObjId = tonumber(Variable:GetVariable("GemNPCObjId"));
			Variable:SetVariable("GemNPCObjId", "", 1)
			if(npcObjId == nil) then
				npcObjId = Get_XParam_INT( 0 )
			end
		
			ObjCaredID = DataPool : GetNPCIDByServerID(npcObjId);
			if ObjCaredID == -1 then
					PushDebugMessage("server�����������������⡣");
					return;
			end
			ObjCaredIDID = npcObjId
			BeginCareObject_GemCarve()
			GemCarve_Clear()
			local GemUnionPos = Variable:GetVariable("GemUnionPos");
			if(GemUnionPos ~= nil) then
			  GemCarve_Frame:SetProperty("UnifiedPosition", GemUnionPos);
			end
			-- GemCarve_FenYe2:SetCheck(1)
			if g_GemCarve_YuanBaoPay == 1 or g_GemCarve_YuanBaoPay == 0 then
				-- GemCarve_YuanBaoPay:SetCheck(g_GemCarve_YuanBaoPay)
			end
			GemCarve_Money:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY") + Player:GetData("MONEY_JZ")));
			-- GemCarve_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
			this:Show();

	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then

		if(tonumber(arg0) ~= ObjCaredID) then
			return;
		end

		--�����NPC�ľ������һ��������߱�ɾ�����Զ��ر�
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			GemCarve_Close()
		end

	elseif ( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() ) then

		if( arg0~= nil and -1 == tonumber(arg0)) then
			return;
		end

		if ( g_GemItemPos == tonumber(arg0) ) then
			Resume_Equip_GemCarve(1)
		end

		if ( g_NeedItemPos == tonumber(arg0) ) then
			Resume_Equip_GemCarve(2)
		end

	elseif( event == "UPDATE_GEMCARVE") then

		if arg0 == nil or arg1 == nil then
			return
		end

		GemCarve_Update(tonumber(arg0),tonumber(arg1));
		
	elseif event == "UI_COMMAND" and tonumber( arg0 ) == 80011701 and this:IsVisible() then	-- ���򵽱�ʯ��������֪ͨ
		local nBagPos = Get_XParam_INT( 1 );
		GemCarve_Update(2,tonumber(nBagPos));	
	elseif event == "BUY_ITEM" and this:IsVisible() then	--��ݹ��򣬸��½���
		local itemId = tonumber(arg1)
		if g_NeedItemID == itemId then
			GemCarve_Update(2,tonumber(PlayerPackage:GetBagPosByItemIndex(itemId)));	
		end
	
	elseif( event == "UNIT_MONEY" or event =="MONEYJZ_CHANGE") then

		GemCarve_UserMoneyChanged();

	elseif ( event == "RESUME_ENCHASE_GEM" and this:IsVisible() ) then

		if tonumber(arg0) == 41 then
			Resume_Equip_GemCarve(1)
		elseif tonumber(arg0) == 42 then
			Resume_Equip_GemCarve(2)
		end
		
	elseif (event == "ADJEST_UI_POS" ) then
		GemCarve_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		GemCarve_Frame_On_ResetPos()

	end

end

--=========================================================
--���ý���
--=========================================================
function GemCarve_Clear()

	if(g_GemItemPos ~= -1) then
		LifeAbility : Lock_Packet_Item(g_GemItemPos,0);
	end
	if(g_NeedItemPos ~= -1) then
		LifeAbility : Lock_Packet_Item(g_NeedItemPos,0);
	end

	GemCarve_GemItem : SetActionItem(-1);
	GemCarve_NeedItem : SetActionItem(-1);
	GemCarve_ProductItem:SetActionItem(-1);

	GemCarve_NeedItem : SetToolTip("")
	GemCarve_Money : SetProperty("MoneyNumber", "")
	GemCarve_State: SetText("")
	
	g_GemItemPos = -1;
	g_GemItemID = -1;
	g_NeedItemPos = -1;
	g_NeedItemID = -1;
	g_NeedMoney = 0;
	g_RightGem = 0;
	g_LastGemItemID = -1;
    g_LastNeedItemID = -1;

	GemCarve_ProductItem:Hide();
	GemCarve_Accept:Disable();

end

--=========================================================
--���½���
--=========================================================
function GemCarve_Update( pos_ui, pos_packet )

	local theAction = EnumAction(pos_packet, "packageitem");



	if pos_ui == 1 then

		if theAction:GetID() == 0 then
			return
		end

		--�����Ǳ�ʯ....
		local Item_Class = PlayerPackage : GetItemSubTableIndex(pos_packet,0)
		if Item_Class ~= 5 then
			PushDebugMessage("ֻ�б�ʯ�ſɱ�����")
			return
		end

		--��¼ˢ��ǰ....��ҷŵ�������Ʒ���е�������Ʒ����Ϣ....
		local lastNeedItemPos = g_NeedItemPos
		local lastNeedItemID = g_NeedItemID

		--���ý���....
		GemCarve_Clear();

		--����ActionButton....
		if g_GemItemPos ~= -1 then
			LifeAbility : Lock_Packet_Item(g_GemItemPos,0);
		end
		g_GemItemPos = pos_packet;
		LifeAbility : Lock_Packet_Item(g_GemItemPos,1);
		GemCarve_GemItem:SetActionItem(theAction:GetID());

		--��ȡ��������Ϣ....
		local GemItemID = PlayerPackage : GetItemTableIndex( pos_packet )
		g_GemItemID = GemItemID;
		local ProductID
		ProductID, g_NeedItemID, g_NeedMoney = GemCarve:GetGemCarveInfo( GemItemID )
		if -1 == ProductID then
			g_RightGem = 0
			GemCarve_State : SetText("�˱�ʯ�޷���������")
			return
		else
			g_RightGem = 1
		end

		--���ò�ƷActionButton....
		GemCarve_State : SetText("������Ĳ��")
		GemCarve_ProductItem:Show()
		local ProductAction = GemCarve:UpdateProductAction( ProductID )
		if ProductAction and ProductAction:GetID() ~= 0 then
			GemCarve_ProductItem:SetActionItem(ProductAction:GetID());
		else
			GemCarve_ProductItem:SetActionItem(-1);
		end

		--����������ƷTooltips....
		GemCarve_NeedItem : SetToolTip("��Ҫ����#{_ITEM"..g_NeedItemID.."}")

		--��������Ǯ��....
		GemCarve_Money : SetProperty("MoneyNumber", tostring(g_NeedMoney));
		
		--�����ε�������Ʒ���ϴε���ͬ....��ֱ�Ӱ��ϴε�������Ʒ�ŵ�������Ʒ����....
		if lastNeedItemID ~= -1 and lastNeedItemID == g_NeedItemID then
			GemCarve_Update( 2, lastNeedItemPos )
		end
		
		--�����Ʒ����ȷ�˲���ǮҲ����Enable������ť....���ﲻ���ٿ��ǵ�������
		local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")  --�����ռ� Vega
		if selfMoney >= g_NeedMoney then
			GemCarve_Accept:Enable();
		end

	elseif pos_ui == 2 then

		if theAction:GetID() == 0 then
			return
		end

		if -1 == g_GemItemPos or g_RightGem == 0 then
			PushDebugMessage("���ȷ�����Ҫ�����ı�ʯ")
			return
		end

		--�����������Ʒ....
		if PlayerPackage:GetItemTableIndex( pos_packet ) ~= g_NeedItemID then
			PushDebugMessage("����ֻ�ܷ���#{_ITEM"..g_NeedItemID.."}")
			return
		end

		--����ActionButton....
		if g_NeedItemPos ~= -1 then
			LifeAbility : Lock_Packet_Item(g_NeedItemPos,0);
		end
		g_NeedItemPos = pos_packet;
		LifeAbility : Lock_Packet_Item(g_NeedItemPos,1);
		GemCarve_NeedItem:SetActionItem(theAction:GetID());

		--�����Ʒ����ȷ�˲���ǮҲ����Enable������ť....
		--local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")  --�����ռ� Vega
		--if selfMoney >= g_NeedMoney then
		--	GemCarve_Accept:Enable();
		--end

	end

end

--=========================================================
--���ActionButton
--=========================================================
function Resume_Equip_GemCarve(nIndex)

	if(nIndex == 1) then
		GemCarve_Clear()
	else
		if(g_NeedItemPos ~= -1) then
			LifeAbility : Lock_Packet_Item(g_NeedItemPos,0);
			GemCarve_NeedItem : SetActionItem(-1);
			g_NeedItemPos	= -1;
		end
		--GemCarve_Accept:Disable();
	end

end

--=========================================================
--ȷ��
--=========================================================
function GemCarve_Buttons_Clicked()

	if g_GemItemPos == -1 or g_RightGem == 0 then
		return
	end

	if g_NeedItemPos == -1 then
		return
	end
	
	--�жϵ绰�ܱ��Ͷ������뱣��2012.6.8-LIUBO
	-- �ж��Ƿ�Ϊ��ȫʱ��2012.6.8-LIUBO
	if (tonumber(DataPool:GetLeftProtectTime()) > 0) then
		PushDebugMessage("#{ZYXT_120528_16}")
		return
	end
	
	if(g_LastGemItemID ~= g_GemItemID or g_LastNeedItemID ~= g_NeedItemID) then
	  g_LastGemItemID = g_GemItemID
	  g_LastNeedItemID = g_NeedItemID
	  --���ݱ�ʯ�Ƿ�󶨺ͱ�ʯ�������Ƿ�󶨣�����ժ����ı�ʯ�Ƿ��
	  if (GetItemBindStatus(g_GemItemPos) == EB_BINDED or GetItemBindStatus(g_NeedItemPos) == EB_BINDED) then
	    ShowSystemInfo("INTERFACE_XML_GemCarve_7");
	    --LifeAbility:Carve_Confirm("OnGemCarve",800117,g_GemItemPos,g_NeedItemPos,2);
	  return
	  end
	end


	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("OnGemCarve");
		Set_XSCRIPT_ScriptID(800117);
		Set_XSCRIPT_Parameter(0,g_GemItemPos);
		Set_XSCRIPT_Parameter(1,g_NeedItemPos);
		Set_XSCRIPT_Parameter(2,ObjCaredIDID);
		Set_XSCRIPT_ParamCount(3);
	Send_XSCRIPT();
	
	--GemCarve_Close()	--tt93366

end

--=========================================================
--�ر�
--=========================================================
function GemCarve_Close()
	-- g_GemCarve_YuanBaoPay = GemCarve_YuanBaoPay:GetCheck();
	this:Hide();
	StopCareObject_GemCarve()
	GemCarve_Clear();
end

--=========================================================
--��������
--=========================================================
function GemCarve_OnHide()
	-- g_GemCarve_YuanBaoPay = GemCarve_YuanBaoPay:GetCheck();
	StopCareObject_GemCarve()
	GemCarve_Clear();
end

--=========================================================
--��ʼ����NPC��
--�ڿ�ʼ����֮ǰ��Ҫ��ȷ����������ǲ����Ѿ��С����ġ���NPC��
--����еĻ�����ȡ���Ѿ��еġ����ġ�
--=========================================================
function BeginCareObject_GemCarve()
	this:CareObject(ObjCaredID, 1, "GemCarve");
end

--=========================================================
--ֹͣ��ĳNPC�Ĺ���
--=========================================================
function StopCareObject_GemCarve()
	this:CareObject(ObjCaredID, 0, "GemCarve");
end

--=========================================================
--��ҽ�Ǯ�仯
--=========================================================
function GemCarve_UserMoneyChanged()

	local nMoney = Player:GetData("MONEY");
	local nJiaoZi = Player:GetData("MONEY_JZ");
	GemCarve_Money:SetProperty("MoneyNumber", tostring(nMoney + nJiaoZi));
	local selfMoney = nMoney + nJiaoZi
	if g_NeedMoney ~= nil and selfMoney ~= nil then
		if selfMoney < g_NeedMoney then
			GemCarve_Accept:Disable();
		else
			if g_GemItemPos ~= -1 and g_NeedItemPos ~= -1 then
				GemCarve_Accept:Enable();
			end
		end
	end
end

function GemCarve_Frame_On_ResetPos()
  GemCarve_Frame:SetProperty("UnifiedPosition", g_GemCarve_Frame_UnifiedPosition);
end

--TAB�����л�
function GemCarve_ChangeTabIndex( nIndex )
	
	if nIndex == 5 or nIndex == 4 or nIndex == 3 then

	end
	
	local nUI = 0
	if 1 == nIndex then
		nUI = 23
	elseif 2 == nIndex then
		return 0
	elseif 3 == nIndex then
		nUI = 112237
	elseif 4 == nIndex then
		nUI = 19830424
	elseif 5 == nIndex then
		nUI = 27
	elseif 6 == nIndex then
		nUI = 2
	end
	if nUI ~= 0 then
		Variable:SetVariable("GemUnionPos", GemCarve_Frame:GetProperty("UnifiedPosition"), 1)
		Variable:SetVariable("GemNPCObjId", tostring(ObjCaredIDID), 1)
		PushEvent("UI_COMMAND", nUI)
		GemCarve_Close()
	end
end

function GetCarve_Yuanbao_Click()
end