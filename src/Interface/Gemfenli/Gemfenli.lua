----***************************
----减抗型宝石分离界面
----***************************
local MAX_OBJ_DISTANCE = 3.0;

local g_GemItemPos = -1;
local g_GemItemID = -1;

local g_NeedMoney = 200000; --5J

local ObjCaredIDID = -1;


local g_Gemfenli_Frame_UnifiedPosition;
--分离道具
local g_fenlifuSTID={38000447, 38000444}--（绑定的新道具）--（不绑定的新道具）
local g_fenlifuID=-1
local g_fenlifuPos=-1

local g_ShowBind=0

local g_Gemfenli_YuanBaoPay = 1

function Gemfenli_PreLoad()

	this:RegisterEvent("UPDATE_DOUBLEGEM_FENLI");
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("PACKAGE_ITEM_CHANGED");
	this:RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("RESUME_ENCHASE_GEM")
	this:RegisterEvent("MONEYJZ_CHANGE")		--交子普及 Vega
	this:RegisterEvent("BUY_ITEM")				--快捷购买，更新界面
	
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function Gemfenli_OnLoad()
    g_Gemfenli_Frame_UnifiedPosition=Gemfenli_Frame:GetProperty("UnifiedPosition");
    g_Gemfenli_YuanBaoPay = 1
end

function Gemfenli_OnEvent(event)

	if ( event == "UI_COMMAND" and tonumber(arg0) == 201210121 ) then

			local npcObjId = tonumber(Variable:GetVariable("GemNPCObjId"));
			Variable:SetVariable("GemNPCObjId", "", 1)
			if(npcObjId == nil) then
				npcObjId = Get_XParam_INT( 0 )
			end
			
			ObjCaredID = DataPool : GetNPCIDByServerID(npcObjId);
			if ObjCaredID == -1 then
					PushDebugMessage("Error!");
					return;
			end
			ObjCaredIDID = npcObjId
			Gemfenli_BeginCareObject()
			Gemfenli_Clear()
			Gemfenli_UserMoneyChanged()
			local GemUnionPos = Variable:GetVariable("GemUnionPos");
			if(GemUnionPos ~= nil) then
			  Gemfenli_Frame:SetProperty("UnifiedPosition", GemUnionPos);
			end
			Gemfenli_FenYe5:SetCheck(1)
			if g_Gemfenli_YuanBaoPay == 1 or g_Gemfenli_YuanBaoPay == 0 then
				Gemfenli_YuanBaoPay:SetCheck(g_Gemfenli_YuanBaoPay)
			end
			this:Show();

	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then

		if(tonumber(arg0) ~= ObjCaredID) then
			return;
		end

		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			Gemfenli_Close()
		end

	elseif ( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() ) then
		if( arg0~= nil and -1 == tonumber(arg0)) then
			
			return;
		end
		if g_GemItemPos ~= -1 then 
      --Gemfenli_GetBsgEm(g_GemItemPos)
	  end
     --Gemfenli_Update(1,tonumber(arg1));
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 201107281 and this:IsVisible()) then

		if arg0 == nil or arg1 == nil then
			return
		end

		--arg0 是UI的第几个位置
		--arg1 是背包的格子

		Gemfenli_Update(1,tonumber(arg1));
		
	elseif event == "BUY_ITEM" and this:IsVisible() then	--快捷购买，更新界面
		local itemId = tonumber(arg1)
		if itemId ==g_fenlifuSTID[1] or itemId ==g_fenlifuSTID[2] then
			Gemfenli_Update(3,tonumber(PlayerPackage:GetBagPosByItemIndex(itemId)));	
		end

	elseif( event == "UNIT_MONEY" or event =="MONEYJZ_CHANGE") then

		Gemfenli_UserMoneyChanged();

	elseif ( event == "RESUME_ENCHASE_GEM" and this:IsVisible() ) then
		if( arg0~= nil and -1 == tonumber(arg0)) then
			return;
		end
		if tonumber(arg0) == 126 then
			Gemfenli_Resume_Equip(1)
		elseif tonumber(arg0) == 127 then
			Gemfenli_Resume_Equip(2)
		end
		
	elseif (event == "ADJEST_UI_POS" ) then
		Gemfenli_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		Gemfenli_Frame_On_ResetPos()

	end

end

--=========================================================
--重置界面
--=========================================================
function Gemfenli_Clear()

	if(g_GemItemPos ~= -1) then
		LifeAbility : Lock_Packet_Item(g_GemItemPos,0);
	end

	Gemfenli_Object : SetActionItem(-1);
	
	g_GemItemPos = -1;
	g_GemItemID = -1;

	Gemfenli_info3:SetText("")
	if(g_fenlifuPos ~= -1) then
		LifeAbility : Lock_Packet_Item(g_fenlifuPos,0);
	end
	Gemfenli_Object2 : SetActionItem(-1);

	g_fenlifuPos = -1;
	g_fenlifuID = -1;

	Gemfenli_OK:Disable();
	g_ShowBind=0

end








--=========================================================
--更新界面
--=========================================================
function Gemfenli_Update( pos_ui, pos_packet )

	local theAction = EnumAction(pos_packet, "packageitem");
	--1 右键点击
	if theAction:GetID() == 0 then
		return
	end
	local itemID = PlayerPackage : GetItemTableIndex( pos_packet )
	if pos_ui == 1 then
		local bJianKangGem=0
		local Item_Class = PlayerPackage : GetItemSubTableIndex(pos_packet,0)
		--获取双属性宝石拆分的信息....
		if Item_Class==5 then
			local GemType = PlayerPackage : GetItemSubTableIndex(pos_packet,2)
			local GemIndex = PlayerPackage : GetItemSubTableIndex(pos_packet,3)--小index
			if GemType==21 and GemIndex>100 then
				bJianKangGem=1
			end
		end
		if itemID~=g_fenlifuSTID[1] and itemID~=g_fenlifuSTID[2] and bJianKangGem==0 then
			PushDebugMessage("#{BSZK_121012_58}")--请放入琢刻后的忽略目标抗性宝石或者琢刻分离符
			return
		end
		
		
		
		if bJianKangGem==1 then
			local nMainID, nAssistID, nAssistCount=Gemfenli_GetfdsfsdeBsgEm(itemID)
			if nMainID<=0 or nAssistID==nil or nAssistCount==nil then
				return
			end			
			--更换ActionButton....
			if g_GemItemPos ~= -1 then
				LifeAbility : Lock_Packet_Item(g_GemItemPos,0);
			end
			g_GemItemPos = pos_packet;
			LifeAbility : Lock_Packet_Item(g_GemItemPos,1);
			Gemfenli_Object:SetActionItem(theAction:GetID());
			--显示可得物品  
			  local gemMainName = "#{_ITEM" ..tostring(nMainID).."}"
			  local gemAssisName = "#{_ITEM" ..tostring(nAssistID).."}"
      	     local szShow=string.format( "#cfff2631个#G%s#cfff263、%s个#G%s#cfff263、1个#G宝石琢刻符", gemMainName, nAssistCount, gemAssisName)
			Gemfenli_info3:SetText(szShow)
			Gemfenli_LightfenliBtn()
		elseif itemID~=g_fenlifuSTID[1] or itemID~=g_fenlifuSTID[2] then
			--琢刻分离符
			g_fenlifuID=itemID
			--更换ActionButton....
			if g_fenlifuPos ~= -1 then
				LifeAbility : Lock_Packet_Item(g_fenlifuPos,0);
			end
			
			g_fenlifuPos = pos_packet;
			LifeAbility : Lock_Packet_Item(g_fenlifuPos,1);
			Gemfenli_Object2:SetActionItem(theAction:GetID());
			Gemfenli_LightfenliBtn()
		end
	end

end

function Gemfenli_LightfenliBtn()
	if g_GemItemPos==-1 or g_fenlifuPos ==-1 then
		return
	end
	Gemfenli_OK:Enable();
	g_ShowBind=0
end


function Gemfenli_GetfdsfsdeBsgEm(GemItemID)
	
	 n_GemItemID =tostring(GemItemID) 
	local lksqw,ddfw,nAssistCount  = -1,nil,nil
	local x,y,GemLevel =  string.find(n_GemItemID,"%d%d(%d)%d%d%d%d%d")
	if x == nil or y == nil then 
		GemLevel=0
	end
	GemLevel=tonumber(GemLevel)
	if GemLevel ==nil or GemLevel ==0 then 
	return -1,nil,nil	
	end
	local x,y,IcemLevel = string.find(n_GemItemID,"%d%d%d%d%d%d%d(%d)")
	if x == nil or y == nil then 
		IcemLevel=0
	end	
	IcemLevel=tonumber(IcemLevel)
	if IcemLevel ==nil or IcemLevel ==0 then 
	return -1,nil,nil	
	end
	
	local x,y,GemIndex = string.find(n_GemItemID,"%d%d%d%d%d(%d)%d%d")
	if x == nil or y == nil then 
		GemIndex=0
	end	
	GemIndex=tonumber(GemIndex)
	if GemIndex ==nil or GemIndex ==0 then 
	return -1,nil,nil	
	end
	

	local x,y,HemIndex = string.find(n_GemItemID,"(%d%d%d%d%d)%d%d%d")
	if x == nil or y == nil then 
		HemIndex=0
	end		
	if HemIndex ==0 or string.len(HemIndex) ~= 5 then
		return -1,nil,nil	
	end 
	
	
    lksqw = tostring(HemIndex).."00"..GemIndex
	
	lksqw=tonumber(lksqw)
	if lksqw ==nil then 
	 return -1,nil,nil	
	end
   local baoshibiao = {50002005,50002006,50002007,50002008}
   if baoshibiao[GemIndex] == nil then 
	return -1,nil,nil
   end
    ddfw,k = string.gsub(baoshibiao[GemIndex],"(%d%d)%d(%d%d%d%d%d)","%1"..tostring(IcemLevel).."%2")
	if k==0 then 
		return -1,nil,nil
	end	
	if ddfw ==nil or string.len(ddfw) ~= 8 then 
		return -1,nil,nil
	end
	
	local x,y,kGemLevel =  string.find(ddfw,"%d%d(%d)%d%d%d%d%d")
	if x == nil or y == nil then 
		kGemLevel=0
	end	
	if kGemLevel ==nil or kGemLevel ==0 then 
	return -1,nil,nil	
	end	
	
	ddfw = tonumber(ddfw)
    if ddfw == nil then 
		return -1,nil,nil
	end
   nAssistCount =4	
   if tonumber(kGemLevel) >=7 then 
	nAssistCount=3
   end	
   return lksqw,ddfw,nAssistCount 
end

--=========================================================
--清除ActionButton
--=========================================================
function Gemfenli_Resume_Equip(index)

	if index==1 then
		if(g_GemItemPos ~= -1) then
			LifeAbility : Lock_Packet_Item(g_GemItemPos,0);
		end
		Gemfenli_Object : SetActionItem(-1);
		g_GemItemPos = -1;
		g_GemItemID = -1;
		Gemfenli_info3:SetText("")
		Gemfenli_OK:Disable();
		g_ShowBind=0
	elseif index==2 then
		if(g_fenlifuPos ~= -1) then
			LifeAbility : Lock_Packet_Item(g_fenlifuPos,0);
		end
		Gemfenli_Object2 : SetActionItem(-1);
		g_fenlifuPos = -1;
		g_fenlifuID = -1;

		--Gemfenli_OK:Disable();
		g_ShowBind=0
	end

end

--=========================================================
--确定
--=========================================================
function Gemfenli_OK_Clicked()

	if g_GemItemPos == -1 then
		PushDebugMessage("#{BSZK_121012_37}")
		return
	end
	--if g_fenlifuPos == -1 then
	--	PushDebugMessage("#{BSZK_121012_57}")
	--	return
	--end

	local GemItemID = PlayerPackage : GetItemTableIndex( g_GemItemPos )
	local nMainID, nAssistID, nAssistCount=Gemfenli_GetfdsfsdeBsgEm(GemItemID)
	if nMainID<=0 or nAssistID==nil or nAssistCount==nil then
		return
	end
	-- 安全时间
	if (tonumber(DataPool:GetLeftProtectTime()) > 0) then
		PushDebugMessage("#{ZYXT_120528_16}")
		return
	end

	--钱数
	-- 检查身上的金钱是否足够
	local selfMoney = Player : GetData( "MONEY" ) + Player : GetData( "MONEY_JZ" )
	if selfMoney < g_NeedMoney then
		PushDebugMessage( "#{BSZK_121012_39}" )
		return
	end
	
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("OnDoubleGemFenLi");
		Set_XSCRIPT_ScriptID(290205);
		Set_XSCRIPT_Parameter(0,g_GemItemPos);
		Set_XSCRIPT_Parameter(1,g_fenlifuPos);
		Set_XSCRIPT_ParamCount(2);
	Send_XSCRIPT();
    Gemfenli_Clear()
end

--=========================================================
--关闭
--=========================================================
function Gemfenli_Close_Click()
	Gemfenli_StopCareObject()
	Gemfenli_Clear();
	g_Gemfenli_YuanBaoPay = Gemfenli_YuanBaoPay:GetCheck();
	this:Hide();
end

function Gemfenli_OnHiden()
	Gemfenli_StopCareObject()
	Gemfenli_Clear();
	g_Gemfenli_YuanBaoPay = Gemfenli_YuanBaoPay:GetCheck();
	this:Hide();
end

--=========================================================
--开始关心NPC，
--在开始关心之前需要先确定这个界面是不是已经有“关心”的NPC，
--如果有的话，先取消已经有的“关心”
--=========================================================
function Gemfenli_BeginCareObject()
	this:CareObject(ObjCaredID, 1, "Gemfenli");
end

--=========================================================
--停止对某NPC的关心
--=========================================================
function Gemfenli_StopCareObject()
	this:CareObject(ObjCaredID, 0, "Gemfenli");
end

--=========================================================
--玩家金钱变化
--=========================================================
function Gemfenli_UserMoneyChanged()
	--设置所需钱数....
	Gemfenli_DemandMoney : SetProperty("MoneyNumber", tostring(g_NeedMoney));
	Gemfenli_SelfMoney: SetProperty("MoneyNumber", Player:GetData("MONEY"))
	Gemfenli_SelfJiaozi: SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"))
end

function Gemfenli_Frame_On_ResetPos()
  Gemfenli_Frame:SetProperty("UnifiedPosition", g_Gemfenli_Frame_UnifiedPosition);
end

--TAB界面切换
function Gemfenli_ChangeTabIndex( nIndex )

	if nIndex == 5 or nIndex == 4 or nIndex == 3 then

	end
	
	local nUI = 0
	if 1 == nIndex then
		nUI = 23
	elseif 2 == nIndex then
		nUI = 112236
	elseif 3 == nIndex then
		nUI = 112237
	elseif 4 == nIndex then
		nUI = 201210120
	elseif 5 == nIndex then
		return 0
	elseif 6 == nIndex then
		nUI = 201408140
	end
	if nUI ~= 0 then
		Variable:SetVariable("GemUnionPos", Gemfenli_Frame:GetProperty("UnifiedPosition"), 1)
		Variable:SetVariable("GemNPCObjId", tostring(ObjCaredIDID), 1)
		PushEvent("UI_COMMAND", nUI)
		Gemfenli_OnHiden()
	end
end

function Gemfenli_Yuanbao_Click()
end
