--****************************
--雕纹拆解
--****************************
local MAX_OBJ_DISTANCE = 3.0
local g_CaredNpc = -1
local g_disibaoshi =0
local baoshitable ={}
--装备在背包中的位置
local g_GemcomupDate_Item = -1
local g_GemcomupDate_Itemnew = -1

local g_GemcomupDate_Frame_UnifiedPosition;

local g_GemcomupDate_Space = {}

local g_GemcomupDate_Selected = 0

local g_GemcomupDate_SubSel = 0
local g_GemcomupDate_Type = 0
local g_GemcomupDate_Name = ""
local g_npcObjId = -1
--=========================================================
-- 注册窗口关心的所有事件
--=========================================================
function GemcomupDate_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("UPDATE_GEM_LEVELUP")
	this:RegisterEvent("GEM_LEVELUP_UPDATE_UI")
	this:RegisterEvent("OBJECT_CARED_EVENT")
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")
	this:RegisterEvent("RESUME_ENCHASE_GEM")
	
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	--元宝
	this:RegisterEvent("UPDATE_YUANBAO");
	--拆解确认
	this:RegisterEvent("SURE_GEM_LEVELUP");
end

--=========================================================
-- 载入初始化
--=========================================================
function GemcomupDate_OnLoad()
	g_GemcomupDate_Item = -1
	g_GemcomupDate_Itemnew = -1

	g_GemcomupDate_Frame_UnifiedPosition=GemcomupDate_Frame:GetProperty("UnifiedPosition");
	g_GemcomupDate_Space={
	GemcomupDate_Space1,
	GemcomupDate_Space2,
	GemcomupDate_Space3,
	GemcomupDate_Space4
	}
	

	
end

--=========================================================
-- 事件处理
--=========================================================
function GemcomupDate_OnEvent(event)
	
	if (event == "UI_COMMAND" and tonumber(arg0) == 201408140) then
		g_npcObjId = tonumber(Variable:GetVariable("GemNPCObjId"));
		Variable:SetVariable("GemNPCObjId", "", 1)
--		if(npcObjId == nil) then
--			npcObjId = Get_XParam_INT( 0 )
--		end

		g_CaredNpc = DataPool : GetNPCIDByServerID(g_npcObjId);
		if g_CaredNpc == -1 then
				PushDebugMessage("Error!");
				return;
		end
		GemcomupDate_BeginCareObject()

		local GemUnionPos = Variable:GetVariable("GemUnionPos");
		if(GemUnionPos ~= nil) then
		  GemcomupDate_Frame:SetProperty("UnifiedPosition", GemUnionPos);
		end
		GemcomupDate_FenYe6:SetCheck(1)
		GemcomupDate_Clear()
		GemcomupDate_UpdateBasic()

		this:Show()
		
		
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 201408141 and this:IsVisible()) then
		--刷新
		local itemPos = Get_XParam_INT( 0 )
		local gem_Index = Get_XParam_INT( 1 )
		local gem_subIndex = Get_XParam_INT( 2 )
		--GemcomupDate_Update(itemPos)
		--GemcomupDate_SelectedTwo(gem_Index,gem_subIndex)
	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if (tonumber(arg0) ~= g_CaredNpc) then
			return
		end
		if ((arg1 == "distance" and tonumber(arg2) > MAX_OBJ_DISTANCE) or arg1=="destroy") then
			GemcomupDate_Close()
		end
	elseif (event == "PACKAGE_ITEM_CHANGED" and this:IsVisible()) then
		if (arg0~= nil and -1 == tonumber(arg0)) then
			return
		end
		if (g_GemcomupDate_Item == tonumber(arg0)) then
		--	GemcomupDate_Resume_GemInfo()
		end

	
	
	

		
		
				
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 201107281 and this:IsVisible()) then
		if arg0 ~= nil or arg1 ~= nil and arg1 ~= -1 then
			GemcomupDate_Update(arg1)
			
			
			GemcomupDate_UpdateBasic()
		end
	elseif (event == "GEM_LEVELUP_UPDATE_UI" and this:IsVisible() ) then
		GemcomupDate_Mjingshi_Button:SetCheck(0)
		GemcomupDate_Jingshi_Button:SetCheck(0)	
		if g_GemcomupDate_SubSel == 1 then
			GemcomupDate_Mjingshi_Button:SetCheck(1)
		end
		if g_GemcomupDate_SubSel == 2 then
			GemcomupDate_Jingshi_Button:SetCheck(1)	
		end
	elseif (event == "RESUME_ENCHASE_GEM_EX" and this:IsVisible()) then
		if (arg0 ~= nil) then
			GemcomupDate_Resume_GemInfo()
			GemcomupDate_UpdateBasic()
		end
	--挪拽
	elseif (event == "ADJEST_UI_POS" ) then
		GemcomupDate_Frame_On_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		GemcomupDate_Frame_On_ResetPos()
	--元宝
	elseif (event == "UPDATE_YUANBAO" and this:IsVisible()) then
		GemcomupDate_UpdateBasic()
	end
end

--=========================================================
-- 更新基本显示信息
--=========================================================
function GemcomupDate_UpdateBasic()
	GemcomupDate_SelfYuanbao:SetText(tostring(Player:GetData("YUANBAO")));
end

--=========================================================
-- 重置界面
--=========================================================
function GemcomupDate_Clear()
	if g_GemcomupDate_Item ~= -1 then
		GemcomupDate_Special_Button:SetActionItem(-1)
		LifeAbility:Lock_Packet_Item(g_GemcomupDate_Item, 0)

		g_GemcomupDate_Item = -1
		GemcomupDate_Mjingshi_Button:Hide()
		GemcomupDate_Mjingshi_TXT:Hide()
		GemcomupDate_Jingshi_TXT:Hide()
		GemcomupDate_Jingshi_Button:Hide()
	end
	
	
	if g_GemcomupDate_Itemnew ~= -1 then
		LifeAbility:Lock_Packet_Item(g_GemcomupDate_Itemnew, 0)
		GemcomupDate_Space3:SetActionItem(-1)
	end
	
	
	

	GemcomupDate_Mjingshi_Button:Hide()
	GemcomupDate_Mjingshi_TXT:Hide()
	GemcomupDate_Jingshi_Button:Hide()
	GemcomupDate_Jingshi_TXT:Hide()

	GemcomupDate_NeedYuanbao:SetText("")
	g_GemcomupDate_SubSel = 0
	GemcomupDate_OK:Disable()
	    GemcomupDate_Space5_YearAnimal:ResetList();
		GemcomupDate_Space5_YearAnimal:ComboBoxAddItem("选择转换类型",0);
		GemcomupDate_Space5_YearAnimal:SetCurrentSelect(0);	
		GemcomupDate_Space5_YearAnimal:Disable();
	g_GemcomupDate_Type=0	
	g_GemcomupDate_Name=""
end

function GemcomupDate_OnHidden()
	GemcomupDate_Clear()
end

--- 判断是否是礼金宝石。这里使用了比较蛋疼的判断方法，就是名字里面是否有"·通"
function GemcomupDate_IsLiJinGem( nGemID )
    if nGemID == -1 then
        return 0
    end

    local gemName = DoubleGem:GetGemNamebyID( nGemID )
    if gemName == nil or gemName == "" then
        return 0
    end
		local specStr = "·红利"
    local sPos, ePos = string.find( gemName, specStr )
    if sPos == nil or ePos == nil then
        return 0
    end
    return 1
end

function GemcomupDate_SelectedTwo(gem_Index, subIndex)
	if gem_Index < 1 or gem_Index > 4 then return end
	if subIndex < 0 or subIndex > 2 then return end--[0 1 2]

	if g_GemcomupDate_Item==-1 then
		return
	end
	if g_GemcomupDate_Space[gem_Index]:GetActionItem() == -1 then
		PushDebugMessage("#{BSSJ_140816_18}")
		return
	end
	--时装宝石
	local nGemType, nGemSubIndex = LifeAbility : GetEquip_GemTypeSubindex(g_GemcomupDate_Item,gem_Index-1)
	if nGemType==31 or nGemType==32 or nGemType==33 then
		PushDebugMessage("#{BSSJ_140816_19}")
		return
	end
	--红利石头
	local nGemID = LifeAbility : GetEquip_GemID(g_GemcomupDate_Item,gem_Index-1)
	if GemcomupDate_IsLiJinGem(nGemID) == 1 then
		PushDebugMessage( "#{BSSJ_140816_20}" )
		return
	end
	--分期

	--冥晶石
	if DoubleGem:IsDoubleGembyID(nGemID)==1 then
		--由于红利冥晶石的GemIndex违和，不能从GemIndex来得出从宝石等级，所以，只能根据宝石是否在GemLevelup.txt中有内容，来判断是否可以升级
		local nextGemID,nextGemYB,nextGemID2,nextGemYB2=LifeAbility:GetGemLevelupTBInfo(nGemID)
		if nextGemID>0 and nextGemID2>0 then
			if subIndex==2 then
				GemcomupDate_Mjingshi_Button:Show()
				GemcomupDate_Mjingshi_TXT:Show()
				GemcomupDate_Mjingshi_Button:SetCheck(0)
				GemcomupDate_Jingshi_TXT:Show()
				GemcomupDate_Jingshi_Button:Show()
				GemcomupDate_Jingshi_Button:SetCheck(1)
				g_GemcomupDate_SubSel=2
			else
				GemcomupDate_Mjingshi_Button:Show()
				GemcomupDate_Mjingshi_TXT:Show()
				GemcomupDate_Mjingshi_Button:SetCheck(1)
				GemcomupDate_Jingshi_TXT:Show()
				GemcomupDate_Jingshi_Button:Show()
				GemcomupDate_Jingshi_Button:SetCheck(0)
				g_GemcomupDate_SubSel=1
			end
		elseif nextGemID>0 then
			GemcomupDate_Mjingshi_Button:Show()
			GemcomupDate_Mjingshi_TXT:Show()
			GemcomupDate_Mjingshi_Button:SetCheck(1)
			GemcomupDate_Jingshi_TXT:Show()
			GemcomupDate_Jingshi_Button:Show()
			GemcomupDate_Jingshi_Button:SetCheck(0)
			g_GemcomupDate_SubSel=1
		elseif nextGemID2>0 then
			GemcomupDate_Mjingshi_Button:Show()
			GemcomupDate_Mjingshi_TXT:Show()
			GemcomupDate_Mjingshi_Button:SetCheck(0)
			GemcomupDate_Jingshi_TXT:Show()
			GemcomupDate_Jingshi_Button:Show()
			GemcomupDate_Jingshi_Button:SetCheck(1)
			g_GemcomupDate_SubSel=2
		else
			GemcomupDate_Mjingshi_Button:Hide()
			GemcomupDate_Mjingshi_TXT:Hide()
			GemcomupDate_Jingshi_TXT:Hide()
			GemcomupDate_Jingshi_Button:Hide()
--			PushDebugMessage("#{BSSJ_140816_22}")
			g_GemcomupDate_SubSel=0
			return
		end
	else
		GemcomupDate_Mjingshi_Button:Hide()
		GemcomupDate_Mjingshi_TXT:Hide()
		GemcomupDate_Jingshi_TXT:Hide()
		GemcomupDate_Jingshi_Button:Hide()
		--也不级别判断了，表里找到就算可以升级
		local nextGemID,nextGemYB,nextGemID2,nextGemYB2=LifeAbility:GetGemLevelupTBInfo(nGemID)
		if nextGemID<=0 then
--			PushDebugMessage( "#{BSSJ_140816_23}" )
			return
		end
	end
	
	--selected Gem
	for i=1,4 do
		if i==g_GemcomupDate_Selected then
			g_GemcomupDate_Space[i]:SetPushed(1)
		else
			g_GemcomupDate_Space[i]:SetPushed(0)
		end
	end
	--如果单属性宝石，显示需求元宝量
	GemcomupDate_UpdateYBRequire()
	
end
function GemcomupDate_Selected(gem_Index)
	if gem_Index < 1 or gem_Index > 4 then return end

	if g_GemcomupDate_Item==-1 then
		return
	end
	if g_GemcomupDate_Space[gem_Index]:GetActionItem() == -1 then
		PushDebugMessage("#{BSSJ_140816_18}")
		return
	end

	local Gem_Level = LifeAbility : GetEquip_GemLevel(g_GemcomupDate_Item,gem_Index-1)
	

	--冥晶石

		GemcomupDate_Mjingshi_Button:Hide()
		GemcomupDate_Mjingshi_TXT:Hide()
		GemcomupDate_Jingshi_TXT:Hide()
		GemcomupDate_Jingshi_Button:Hide()
		--也不级别判断了，表里找到就算可以升级
		if Gem_Level<3 or Gem_Level>7  then
			PushDebugMessage( "#{BSSJ_140816_23}" ..Gem_Level)
			return
		end
		if baoshitable[gem_Index]  ~= nil then 
			local nItemID = tonumber(baoshitable[gem_Index])
			local GemTapy = math.mod(nItemID,1000)
			
			if GemTapy >100 then 
				PushDebugMessage("#H双属性宝石不能进行宝石升级操作")
				return
			end
		end

	--selected Gem

	--如果单属性宝石，显示需求元宝量
--	GemcomupDate_UpdateYBRequire()
end

function GemcomupDate_DoubleGem_Clicked(index)
	
end

function GemcomupDate_UpdateYBRequire()
	GemcomupDate_OK:Disable()
	if g_GemcomupDate_Item==-1 then
		return
	end
	if g_GemcomupDate_Itemnew==-1 then
		return
	end	
	if g_GemcomupDate_Selected<1 then
		return
	end
	GemcomupDate_NeedYuanbao:SetText("500")
	GemcomupDate_OK:Enable()
end
--=========================================================
-- 更新界面
--=========================================================
function GemcomupDate_Update(itemIndex)
	local posBag = tonumber(itemIndex)--背包位置
	local theAction = EnumAction(posBag, "packageitem")
    if theAction:GetID() ==0 then 
	return
	end
	local Item_Class = PlayerPackage : GetItemSubTableIndex(posBag,0)
	local GemType = PlayerPackage : GetItemSubTableIndex(posBag,2)
	local itemID = PlayerPackage : GetItemTableIndex( posBag )
	local bJianKangGem=0
	if theAction:GetID() ~= 0 then
		if Item_Class==5 then
			local GemIndex = PlayerPackage : GetItemSubTableIndex(posBag,3)--小index
			if GemIndex <100 then 
			bJianKangGem=1	
			end 
		end
		if bJianKangGem ==0 and itemID ~=30000004 then 
		PushDebugMessage("#{BSZH_130220_16}")	
		return
		end
		if bJianKangGem ==1 then
			 GemcomupDate_Clear()	
			if GemType ==21 or GemType ==2 or GemType ==12 then
				g_GemcomupDate_Type=1
				GemcomupDate_Space5_YearAnimal:ResetList();
		        GemcomupDate_Space5_YearAnimal:ComboBoxAddItem("选择转换类型",0);
				GemcomupDate_Space5_YearAnimal:ComboBoxAddItem("玄属性类型",1);
				GemcomupDate_Space5_YearAnimal:ComboBoxAddItem("冰属性类型",2);
				GemcomupDate_Space5_YearAnimal:ComboBoxAddItem("火属性类型",3);
				GemcomupDate_Space5_YearAnimal:ComboBoxAddItem("毒属性类型",4);				
	            GemcomupDate_Space5_YearAnimal:SetCurrentSelect(0);		
				GemcomupDate_Space5_YearAnimal:Enable()
			else
			
			
			   g_GemcomupDate_Type=2
				GemcomupDate_Space5_YearAnimal:ResetList();
		        GemcomupDate_Space5_YearAnimal:ComboBoxAddItem("选择转换类型",0);
				GemcomupDate_Space5_YearAnimal:ComboBoxAddItem("猫眼石",1);
				GemcomupDate_Space5_YearAnimal:ComboBoxAddItem("虎眼石",2);
				GemcomupDate_Space5_YearAnimal:ComboBoxAddItem("紫玉",3);
				GemcomupDate_Space5_YearAnimal:ComboBoxAddItem("变石",4);	
				GemcomupDate_Space5_YearAnimal:ComboBoxAddItem("石榴石",5);
				GemcomupDate_Space5_YearAnimal:ComboBoxAddItem("尖晶石",6);
				GemcomupDate_Space5_YearAnimal:ComboBoxAddItem("黄宝石",7);
				GemcomupDate_Space5_YearAnimal:ComboBoxAddItem("蓝宝石",8);
				GemcomupDate_Space5_YearAnimal:ComboBoxAddItem("绿宝石",9);
				GemcomupDate_Space5_YearAnimal:ComboBoxAddItem("红宝石",10);
				GemcomupDate_Space5_YearAnimal:ComboBoxAddItem("黑宝石",11);
				GemcomupDate_Space5_YearAnimal:ComboBoxAddItem("血精石",12);		
				GemcomupDate_Space5_YearAnimal:ComboBoxAddItem("祖母绿",13);		
	            GemcomupDate_Space5_YearAnimal:SetCurrentSelect(0);		
				GemcomupDate_Space5_YearAnimal:Enable()			
			end
		if g_GemcomupDate_Item ~= -1 then
			LifeAbility:Lock_Packet_Item(g_GemcomupDate_Item, 0)
		end
		g_GemcomupDate_Name= theAction:GetName()
		GemcomupDate_Special_Button:SetActionItem(theAction:GetID())
		
		LifeAbility:Lock_Packet_Item(posBag, 1)
		GemcomupDate_UpdateYBRequire()
		g_GemcomupDate_Item = posBag
		elseif itemID ==30000004 then 
		if g_GemcomupDate_Itemnew ~= -1 then
			LifeAbility:Lock_Packet_Item(g_GemcomupDate_Itemnew, 0)
		end
		GemcomupDate_Space3:SetActionItem(theAction:GetID())
		LifeAbility:Lock_Packet_Item(posBag, 1)
		g_GemcomupDate_Itemnew = posBag
		GemcomupDate_UpdateYBRequire()
		else
		   GemcomupDate_Clear()
		end
		

		--灰化升级按钮
	else
		GemcomupDate_Clear()
	end
	--检测灰化按钮
	
end


function GemcomupDate_Changed()
	if g_GemcomupDate_Item==-1 then
		return
	end
	if g_GemcomupDate_Itemnew==-1 then
		return
	end	
	if g_GemcomupDate_Type ==0 then
		return
	end

local itemID = PlayerPackage : GetItemTableIndex( g_GemcomupDate_Item )	
local GemType = PlayerPackage : GetItemSubTableIndex(g_GemcomupDate_Item,2)	
local _name,nIndex = GemcomupDate_Space5_YearAnimal:GetCurrentSelect();
if nIndex ==0 then 
PushDebugMessage("#{FQBS_140508_16}")	
return
end
local canshu = math.mod(itemID,10)
if g_GemcomupDate_Type==1 then 
if math.mod(itemID,10) >4 then 
canshu=canshu-4	
end
if nIndex == canshu then 
PushDebugMessage("#{FQBS_140508_15}")
GemcomupDate_Space5_YearAnimal:SetCurrentSelect(0);		
return
end
elseif g_GemcomupDate_Type==2 then
local baishitab={"猫眼石","虎眼石","紫玉","变石","石榴石","尖晶石","黄宝石","蓝宝石","绿宝石","红宝石","黑宝石","血精石","祖母绿"}
if baishitab[nIndex] ==nil then 
PushDebugMessage("#{FQBS_140508_16}")		
return
end



if  string.find(g_GemcomupDate_Name,baishitab[nIndex]) ~= nil then 
PushDebugMessage("#{FQBS_140508_15}")	
GemcomupDate_Space5_YearAnimal:SetCurrentSelect(0);	
return
end

end







g_GemcomupDate_Selected = nIndex
	--如果单属性宝石，显示需求元宝量
	GemcomupDate_UpdateYBRequire()
end
--=========================================================
-- 取出窗口内放入的物品
--=========================================================
function GemcomupDate_Resume_GemInfo()
	if this:IsVisible() then
		GemcomupDate_Clear()
	end
end

--=========================================================
-- 确定执行功能
--=========================================================
function GemcomupDate_Submit()
	-- 安全时间
	if (tonumber(DataPool:GetLeftProtectTime()) > 0) then
		PushDebugMessage("#{OR_PILFER_LOCK_FLAG}")
		return
	end
	if (tonumber(DataPool:GetLeftProtectTime()) > 0) then
		PushDebugMessage("#{OR_PILFER_LOCK_FLAG}")
		return
	end
	if g_GemcomupDate_Item==-1 then
		return
	end
	if g_GemcomupDate_Itemnew==-1 then
		return
	end	
	if g_GemcomupDate_Selected<1 then
		return
	end
	if tonumber(Player:GetData("YUANBAO")) <500 then
		PushDebugMessage("#{GCShopBuyHandler_5}")
		return
	end
			Clear_XSCRIPT()
				Set_XSCRIPT_Function_Name("BSzhuanhuan")
				Set_XSCRIPT_ScriptID(900011)
				Set_XSCRIPT_Parameter(0,tonumber(g_GemcomupDate_Item))
				Set_XSCRIPT_Parameter(1,tonumber(g_GemcomupDate_Itemnew))
				Set_XSCRIPT_Parameter(2,tonumber(g_GemcomupDate_Selected))
				Set_XSCRIPT_ParamCount(3)
			Send_XSCRIPT()	
   GemcomupDate_Clear()
end

--=========================================================
-- 关闭界面
--=========================================================
function GemcomupDate_Close()
	this:Hide()
	return
end

--=========================================================
-- 界面隐藏
--=========================================================
function GemcomupDate_OnHiden()
	StopCareObject_GemcomupDate()
	GemcomupDate_Clear()
	return
end

--=========================================================
-- 开始关心NPC，
-- 在开始关心之前需要先确定这个界面是不是已经有“关心”的NPC，
-- 如果有的话，先取消已经有的“关心”
--=========================================================
function GemcomupDate_BeginCareObject()
	this:CareObject(g_CaredNpc, 1, "GemcomupDate")
	return
end

--=========================================================
-- 停止对某NPC的关心
--=========================================================
function StopCareObject_GemcomupDate()
	this:CareObject(g_CaredNpc, 0, "GemcomupDate")
	g_CaredNpc = -1
	return
end


function GemcomupDate_Frame_On_ResetPos()
  GemcomupDate_Frame:SetProperty("UnifiedPosition", g_GemcomupDate_Frame_UnifiedPosition);
end


function GemcomupDate_SpecialBTN_RBClicked()
	GemcomupDate_Resume_GemInfo()
end

function GemcomupDate_querengoumai_Clicked()


end

function GemcomupDate_ChangeTabIndex(nIndex)

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
		nUI = 201210121
	elseif 6 == nIndex then
		return
	end
	if nUI ~= 0 then
		Variable:SetVariable("GemUnionPos", GemcomupDate_Frame:GetProperty("UnifiedPosition"), 1)
		Variable:SetVariable("GemNPCObjId", tostring(g_npcObjId), 1)
		PushEvent("UI_COMMAND", nUI)
		GemcomupDate_Close()
	end
end
