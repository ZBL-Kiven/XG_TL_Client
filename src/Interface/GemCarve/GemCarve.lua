
local MAX_OBJ_DISTANCE = 3.0;

local g_GemItemPos = -1;
local g_GemItemID = -1;
local g_NeedItemPos = -1;
local g_NeedItemID = -1;
local g_NeedMoney = 0;
local g_RightGem = 0;
local EB_BINDED = 1;				-- 已经绑定

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
	this:RegisterEvent("BUY_ITEM")				--快捷购买，更新界面
	
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
					PushDebugMessage("server传过来的数据有问题。");
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

		--如果和NPC的距离大于一定距离或者被删除，自动关闭
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
		
	elseif event == "UI_COMMAND" and tonumber( arg0 ) == 80011701 and this:IsVisible() then	-- 购买到宝石雕琢符的通知
		local nBagPos = Get_XParam_INT( 1 );
		GemCarve_Update(2,tonumber(nBagPos));	
	elseif event == "BUY_ITEM" and this:IsVisible() then	--快捷购买，更新界面
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
--重置界面
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
--更新界面
--=========================================================
function GemCarve_Update( pos_ui, pos_packet )

	local theAction = EnumAction(pos_packet, "packageitem");



	if pos_ui == 1 then

		if theAction:GetID() == 0 then
			return
		end

		--必须是宝石....
		local Item_Class = PlayerPackage : GetItemSubTableIndex(pos_packet,0)
		if Item_Class ~= 5 then
			PushDebugMessage("只有宝石才可被雕琢")
			return
		end

		--记录刷新前....玩家放到所需物品栏中的所需物品的信息....
		local lastNeedItemPos = g_NeedItemPos
		local lastNeedItemID = g_NeedItemID

		--重置界面....
		GemCarve_Clear();

		--更换ActionButton....
		if g_GemItemPos ~= -1 then
			LifeAbility : Lock_Packet_Item(g_GemItemPos,0);
		end
		g_GemItemPos = pos_packet;
		LifeAbility : Lock_Packet_Item(g_GemItemPos,1);
		GemCarve_GemItem:SetActionItem(theAction:GetID());

		--获取雕琢的信息....
		local GemItemID = PlayerPackage : GetItemTableIndex( pos_packet )
		g_GemItemID = GemItemID;
		local ProductID
		ProductID, g_NeedItemID, g_NeedMoney = GemCarve:GetGemCarveInfo( GemItemID )
		if -1 == ProductID then
			g_RightGem = 0
			GemCarve_State : SetText("此宝石无法被雕琢。")
			return
		else
			g_RightGem = 1
		end

		--设置产品ActionButton....
		GemCarve_State : SetText("雕琢后的产物：")
		GemCarve_ProductItem:Show()
		local ProductAction = GemCarve:UpdateProductAction( ProductID )
		if ProductAction and ProductAction:GetID() ~= 0 then
			GemCarve_ProductItem:SetActionItem(ProductAction:GetID());
		else
			GemCarve_ProductItem:SetActionItem(-1);
		end

		--设置所需物品Tooltips....
		GemCarve_NeedItem : SetToolTip("需要放入#{_ITEM"..g_NeedItemID.."}")

		--设置所需钱数....
		GemCarve_Money : SetProperty("MoneyNumber", tostring(g_NeedMoney));
		
		--如果这次的所需物品与上次的相同....则直接把上次的所需物品放到所需物品栏内....
		if lastNeedItemID ~= -1 and lastNeedItemID == g_NeedItemID then
			GemCarve_Update( 2, lastNeedItemPos )
		end
		
		--如果物品都正确了并且钱也够就Enable雕琢按钮....这里不用再考虑雕琢符了
		local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")  --交子普及 Vega
		if selfMoney >= g_NeedMoney then
			GemCarve_Accept:Enable();
		end

	elseif pos_ui == 2 then

		if theAction:GetID() == 0 then
			return
		end

		if -1 == g_GemItemPos or g_RightGem == 0 then
			PushDebugMessage("请先放入需要雕琢的宝石")
			return
		end

		--不是需求的物品....
		if PlayerPackage:GetItemTableIndex( pos_packet ) ~= g_NeedItemID then
			PushDebugMessage("这里只能放入#{_ITEM"..g_NeedItemID.."}")
			return
		end

		--更换ActionButton....
		if g_NeedItemPos ~= -1 then
			LifeAbility : Lock_Packet_Item(g_NeedItemPos,0);
		end
		g_NeedItemPos = pos_packet;
		LifeAbility : Lock_Packet_Item(g_NeedItemPos,1);
		GemCarve_NeedItem:SetActionItem(theAction:GetID());

		--如果物品都正确了并且钱也够就Enable雕琢按钮....
		--local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")  --交子普及 Vega
		--if selfMoney >= g_NeedMoney then
		--	GemCarve_Accept:Enable();
		--end

	end

end

--=========================================================
--清除ActionButton
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
--确定
--=========================================================
function GemCarve_Buttons_Clicked()

	if g_GemItemPos == -1 or g_RightGem == 0 then
		return
	end

	if g_NeedItemPos == -1 then
		return
	end
	
	--判断电话密保和二级密码保护2012.6.8-LIUBO
	-- 判断是否为安全时间2012.6.8-LIUBO
	if (tonumber(DataPool:GetLeftProtectTime()) > 0) then
		PushDebugMessage("#{ZYXT_120528_16}")
		return
	end
	
	if(g_LastGemItemID ~= g_GemItemID or g_LastNeedItemID ~= g_NeedItemID) then
	  g_LastGemItemID = g_GemItemID
	  g_LastNeedItemID = g_NeedItemID
	  --根据宝石是否绑定和宝石雕琢符是否绑定，决定摘除后的宝石是否绑定
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
--关闭
--=========================================================
function GemCarve_Close()
	-- g_GemCarve_YuanBaoPay = GemCarve_YuanBaoPay:GetCheck();
	this:Hide();
	StopCareObject_GemCarve()
	GemCarve_Clear();
end

--=========================================================
--界面隐藏
--=========================================================
function GemCarve_OnHide()
	-- g_GemCarve_YuanBaoPay = GemCarve_YuanBaoPay:GetCheck();
	StopCareObject_GemCarve()
	GemCarve_Clear();
end

--=========================================================
--开始关心NPC，
--在开始关心之前需要先确定这个界面是不是已经有“关心”的NPC，
--如果有的话，先取消已经有的“关心”
--=========================================================
function BeginCareObject_GemCarve()
	this:CareObject(ObjCaredID, 1, "GemCarve");
end

--=========================================================
--停止对某NPC的关心
--=========================================================
function StopCareObject_GemCarve()
	this:CareObject(ObjCaredID, 0, "GemCarve");
end

--=========================================================
--玩家金钱变化
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

--TAB界面切换
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