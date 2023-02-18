local objCared = -1;			--关心NPC与否
local GEMSOURCE_BUTTONS = -1 	--控件：源宝石框
local GEMDEST_BUTTONS = -1 		--控件：目的宝石框
local EQUIPITEM_SOURCE = -1		--空否：源宝石框
local EQUIPITEM_DEST = -1		--空否：目的宝石框
local CostYuanBao_Total = ""	--转换需要消耗的元宝
local bConfirm = -1				--二次确认框，弹出来了吗

local GemLv = -1				--宝石等级
local GemLx = -1				--宝石类型
local GemId = -1				--小ID
local Lx = -1

local i_index = -1
local NewGem = -1

local Gem_Select_ItemID = -1	--目的宝石ID
local Gem_Source_Name = ""		--源宝石Name
local Gem_Dest_Name = ""		--目的宝石Name
local MAX_OBJ_DISTANCE = 3.0	--对话框关闭距离

BaoShi_LeiXing = {
[5] = {[1] ={50513006,50501001,50501002,50502001,50502002,50502003,50502004,50503001,50504002,50511001,50511002,50512001,50512002,50512003,50512004,50513001,50513002,50513003,50513004,50513005,50514001},[2] = {50502005,50502006,50502007,50502008,50512005,50512006,50512007,50512008},[3] = {50521001,50521002,50521003,50521004}},
[6] = {[1] ={50613006,50601001,50601002,50602001,50602002,50602003,50602004,50603001,50604002,50611001,50611002,50612001,50612002,50612003,50612004,50613001,50613002,50613003,50613004,50613005,50614001},[2] = {50602005,50602006,50602007,50602008,50612005,50612006,50612007,50612008},[3] = {50621001,50621002,50621003,50621004}},
[7] = {[1] ={50713006,50701001,50701002,50702001,50702002,50702003,50702004,50703001,50704002,50711001,50711002,50712001,50712002,50712003,50712004,50713001,50713002,50713003,50713004,50713005,50714001},[2] = {50702005,50702006,50702007,50702008,50712005,50712006,50712007,50712008},[3] = {50721001,50721002,50721003,50721004}},
[8] = {[1]= {50813006,50801001,50801002,50802001,50802002,50802003,50802004,50803001,50804002,50811001,50811002,50812001,50812002,50812003,50812004,50813001,50813002,50813003,50813004,50813005,50814001},[2] = {50802005,50802006,50802007,50802008,50812005,50812006,50812007,50812008},[3] = {50821001,50821002,50821003,50821004}},
[9] = {[1]= {50913006,50901001,50901002,50902001,50902002,50902003,50902004,50903001,50904002,50911001,50911002,50912001,50912002,50912003,50912004,50913001,50913002,50913003,50913004,50913005,50914001},[2] = {50902005,50902006,50902007,50902008,50912005,50912006,50912007,50912008},[3] = {50921001,50921002,50921003,50921004}},
}



local Cost_YuanBao = {			--不同类型宝石，消耗元宝配表
[5] = {normal=1,	special=1},
[6] = {normal=1,	special=1},
[7] = {normal=20,	special=60},
[8] = {normal=100,	special=300},
[9] = {normal=500,	special=1500},
}

function GemChange_PreLoad()
	this:RegisterEvent("UI_COMMAND"); 				 --作用：打开宝石转换界面
	this:RegisterEvent("OBJECT_CARED_EVENT"); 		 --作用：关闭宝石转换界面
	this:RegisterEvent("UPDATE_GEMCHANGE"); 		 --作用：刷新界面
	this:RegisterEvent("UPDATE_YUANBAO");			 --作用：宝石转换界面元宝刷新
	this:RegisterEvent("RESUME_ENCHASE_GEM_EX");		 --作用：源宝石拖回背包里
	this:RegisterEvent("BAOSHI_CHANGE_CONFIRM");	 --作用：宝石转换的二次确认：打开界面
	this:RegisterEvent("BAOSHI_CHANGE_CONFIRM_TRUE");--作用：宝石转换的二次确认：再次确认，不再打开界面
	this:RegisterEvent("BAOSHI_CHANGE_CONFIRM_CANCEL"); --//By YPL,2013/3/6	
end

function GemChange_OnLoad()
	GEMSOURCE_BUTTONS = GemChange_InputGemIcon;
	GEMDEST_BUTTONS = GemChange_OutputGemIcon;

	GemChange_SearchMode0:ResetList();
	GemChange_SearchMode0:AddTextItem("请放入宝石" ,0)
	GemChange_SearchMode0:SetCurrentSelect(0)
	GemChange_SearchMode0:Disable()

	GemChange_SearchMode1:ResetList();
	GemChange_SearchMode1:AddTextItem("血精石" ,1)
	GemChange_SearchMode1:AddTextItem("猫眼石" ,2)
	GemChange_SearchMode1:AddTextItem("虎眼石" ,3)
	GemChange_SearchMode1:AddTextItem("黄晶石" ,4)
	GemChange_SearchMode1:AddTextItem("蓝晶石" ,5)
	GemChange_SearchMode1:AddTextItem("红晶石" ,6)
	GemChange_SearchMode1:AddTextItem("绿晶石" ,7)
	GemChange_SearchMode1:AddTextItem("紫玉" ,8)
	GemChange_SearchMode1:AddTextItem("变石" ,9)
	GemChange_SearchMode1:AddTextItem("石榴石" ,10)
	GemChange_SearchMode1:AddTextItem("尖晶石" ,11)
	GemChange_SearchMode1:AddTextItem("黄玉" ,12)
	GemChange_SearchMode1:AddTextItem("皓石" ,13)
	GemChange_SearchMode1:AddTextItem("月光石" ,14)
	GemChange_SearchMode1:AddTextItem("碧玺" ,15)
	GemChange_SearchMode1:AddTextItem("黄宝石" ,16)
	GemChange_SearchMode1:AddTextItem("蓝宝石" ,17)
	GemChange_SearchMode1:AddTextItem("绿宝石" ,18)
	GemChange_SearchMode1:AddTextItem("红宝石" ,19)
	GemChange_SearchMode1:AddTextItem("黑宝石" ,20)
	GemChange_SearchMode1:AddTextItem("祖母绿" ,21)
	GemChange_SearchMode1:SetCurrentSelect(0)

	GemChange_SearchMode2:ResetList();
	GemChange_SearchMode2:AddTextItem("纯净黄晶石" ,1)
	GemChange_SearchMode2:AddTextItem("纯净蓝晶石" ,2)
	GemChange_SearchMode2:AddTextItem("纯净红晶石" ,3)
	GemChange_SearchMode2:AddTextItem("纯净绿晶石" ,4)
	GemChange_SearchMode2:AddTextItem("纯净黄玉" ,5)
	GemChange_SearchMode2:AddTextItem("纯净皓石" ,6)
	GemChange_SearchMode2:AddTextItem("纯净月光石" ,7)
	GemChange_SearchMode2:AddTextItem("纯净碧玺" ,8)
	GemChange_SearchMode2:SetCurrentSelect(0)
	
	GemChange_SearchMode3:ResetList();	
	GemChange_SearchMode3:AddTextItem("黄冥石" ,1)
	GemChange_SearchMode3:AddTextItem("蓝冥石" ,2)
	GemChange_SearchMode3:AddTextItem("红冥石" ,3)
	GemChange_SearchMode3:AddTextItem("绿冥石" ,4)
	GemChange_SearchMode3:SetCurrentSelect(0)

	GemChange_SearchMode0:Show()	
	GemChange_SearchMode1:Hide()
	GemChange_SearchMode2:Hide()
	GemChange_SearchMode3:Hide()
	EQUIPITEM_SOURCE = -1;
	EQUIPITEM_DEST = -1;
	--GemChange_Select:Disable(); --"选择宝石"按钮状态： 置灰
	CostYuanBao_Total = "";
	GemChange_WantNum:SetText(""..CostYuanBao_Total);
	GemChange_HaveNum:SetText(""..tostring(Player:GetData("YUANBAO")));
	GemChange_OK:Disable();	--"确定"按钮状态： 置灰

end

--检查时机：当左键拖动或右键点击背包宝石，到宝石转换界面的框内时
function GemChange_CheckBaoshi(Item_index)
	local pos_packet = tonumber(Item_index)

	--条件1：放入物品是宝石吗
	local Item_Class = PlayerPackage:GetItemSubTableIndex(pos_packet,0)--是否宝石
	if Item_Class ~= 5 then
		PushDebugMessage("#{JKBS_081021_006}")
		return 0
	end
	--条件2：放入的是宝石等级不低于5级吗
	local GemLevel = PlayerPackage:GetItemSubTableIndex(pos_packet,1)--宝石等级
	if GemLevel < 5 then
		PushDebugMessage("#{BSZH_130220_14}")
		return 0
	end
	--条件3：放入的是宝石是冥晶石不能转换
	local GemType = PlayerPackage:GetItemSubTableIndex(pos_packet,2)--宝石类型
	if GemType == 21 then
		local GemIndex = PlayerPackage:GetItemSubTableIndex(pos_packet,3)--小index
			if GemLevel > 0 and ( GemIndex >= 101 and GemIndex <= 409)  then
				PushDebugMessage( "冥晶石不能宝石转换。" )
				return 0
			end
	end	
	--条件4：放入的是宝石已加锁了吗
	if PlayerPackage:IsLock(pos_packet) == 1 then
		PushDebugMessage("#{BSZH_130220_17}")
		return 0	
	end

	--条件5：宝石框内有宝石吗
	if PlayerPackage:IsGem(pos_packet) ~= 1 then
		return 0	
	end		
	
	return 1;
end

function GemChange_Update(UI_index,Item_index)
	
	i_index = tonumber(Item_index)
	
	--先判断物品是否符合放入的条件，才可进行后续逻辑 ！！！！！！！！！！！！！！！必须保证这一步，否则会有各种异常问题！！！！！！！！！！！！！！！
	if GemChange_CheckBaoshi(i_index) == 0 then
		return
	end

	if EQUIPITEM_SOURCE ~= -1 then
		GemChange_Clear();
		GEMSOURCE_BUTTONS:SetActionItem(theAction:GetID());
		LifeAbility : Lock_Packet_Item(i_index,0);
		EQUIPITEM_SOURCE = -1	
	end

	local theAction = EnumAction(i_index,"packageitem");
	GemChange_HaveNum:SetText(""..tostring(Player:GetData("YUANBAO")));

	if theAction:GetID() ~= 0 then
		--if UI_index == 1 then
			GemChange_Clear();
			GEMSOURCE_BUTTONS:SetActionItem(theAction:GetID());
			LifeAbility:Lock_Packet_Item(i_index,1);
			EQUIPITEM_SOURCE = i_index;	
			--GemChange_Select:Enable(); --"选择宝石"按钮状态：可点击
			GemChange_Flush_DestGemList(); --刷新匹配宝石列表
			------这些数据传回服务器
			GemLv = PlayerPackage:GetItemSubTableIndex(i_index,1)--宝石等级
			GemLx = PlayerPackage:GetItemSubTableIndex(i_index,2)--宝石类型
			GemId = PlayerPackage:GetItemSubTableIndex(i_index,3)--宝石类型
			------
		--end	
		if GemLx == 21 then
			GemChange_SearchMode0:Hide()
			GemChange_SearchMode1:Hide()	
			GemChange_SearchMode2:Hide()
			GemChange_SearchMode3:Show()
			Lx = 3
		end
		if GemLx == 2 or GemLx == 12 then
			if GemId > 4 and GemId < 9 then
			        GemChange_SearchMode0:Hide()
				GemChange_SearchMode1:Hide()	
				GemChange_SearchMode2:Show()
				GemChange_SearchMode3:Hide()
				Lx = 2
			else
			        GemChange_SearchMode0:Hide()	
				GemChange_SearchMode1:Show()	
				GemChange_SearchMode2:Hide()
				GemChange_SearchMode3:Hide()
				Lx = 1
			end
		end	
		if GemLx == 1 or GemLx == 3 or GemLx == 11 or GemLx == 13 or GemLx == 14 or GemLx == 4 then
			GemChange_SearchMode0:Hide()
			GemChange_SearchMode1:Show()	
			GemChange_SearchMode2:Hide()
			GemChange_SearchMode3:Hide()
			Lx = 1			
		end	
		GemChange_Need_YuanBao_Flush(GemLv,GemLx);
                GemChange_Open_DestGemList()
	end
end

function GemChange_OnEvent(event)
        --local JubaoTim=DataPool:GetPlayerMission_DataRound(291)
        --PushDebugMessage("服务端传过来的是"..JubaoTim..",客户端时间是"..os.time().."")

	if (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		if((arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE) or arg1=="destroy") then		
			--取消关心
			GemChange_Cancel_Clicked()
		end
	elseif ( event == "UI_COMMAND" and tonumber(arg0)== 201302201 ) then
		if this:IsVisible() then
			GemChange_Close()
		end
		
		this:Show();
		GemChange_OnLoad();
		objCared = -1;
		local xx = Get_XParam_INT(0);
		objCared = DataPool:GetNPCIDByServerID(xx);
		if objCared == -1 then
				return;
		end
		GemChange_BeginCareObject(objCared)
		return
------------------------------------------------------------	
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 201107281 and this:IsVisible()) then
		GemChange_Update(tonumber(arg0),tonumber(arg1));
------------------------------------------------------------		
	elseif (event == "UPDATE_YUANBAO" and this:IsVisible()) then
		GemChange_HaveNum:SetText(""..tostring(Player:GetData("YUANBAO")));
	elseif event == "RESUME_ENCHASE_GEM_EX" and this:IsVisible() then
		 GemChange_Clear()
		 --GemChange_Select:Disable(); --"选择宝石"按钮状态：可点击

	elseif (event == "BAOSHI_CHANGE_CONFIRM_TRUE" and this:IsVisible()) then --作用：宝石转换的二次确认：再次确认，不再打开界面
		GemChange_Buttons_Clicked();
	elseif (event == "BAOSHI_CHANGE_CONFIRM_CANCEL" and this:IsVisible()) then
		bConfirm = -1		
	end

end
--清空
function GemChange_Clear()
	if (EQUIPITEM_SOURCE ~= -1) then
		GEMSOURCE_BUTTONS:SetActionItem(-1);
		LifeAbility:Lock_Packet_Item(EQUIPITEM_SOURCE,0);
		EQUIPITEM_SOURCE = -1
	--end
	
	--if (EQUIPITEM_DEST ~= -1) then
		GEMDEST_BUTTONS:SetActionItem(-1);
		EQUIPITEM_DEST = -1
	end	
	
	--GemChange_Select:Disable();
	CostYuanBao_Total = ""
	GemChange_WantNum:SetText(""..CostYuanBao_Total);	
	GemChange_OK:Disable();
	bConfirm = -1
	Gem_Source_Bind = 0
        GemChange_OnLoad()
end

function GemChange_Close()
	GemChange_Clear()
	this:Hide()
end
--关闭
function GemChange_Cancel_Clicked()
	GemChange_Close();
	return;
end
--检测分配
function GemChange_()




end
--确定按钮
function GemChange_Buttons_Clicked()

	-- 判断是否为安全时间
	if (tonumber(DataPool:GetLeftProtectTime()) > 0) then
		PushDebugMessage("#{OR_PILFER_LOCK_FLAG}")
		return
	end

	if GemChange_CheckBaoshi(EQUIPITEM_SOURCE) ~=1 then
		return
	end

	--条件8：玩家元宝是否足够
	if Player:GetData("YUANBAO") < CostYuanBao_Total then
		PushDebugMessage("#{BSZH_130220_20}")
		return
	end

	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("XieziQuickly");
		Set_XSCRIPT_ScriptID(070051);--蝎子改进
		Set_XSCRIPT_Parameter(0,8550);
		Set_XSCRIPT_Parameter(1,i_index);
		Set_XSCRIPT_Parameter(2,Gem_Select_ItemID);
		Set_XSCRIPT_ParamCount(3);
	Send_XSCRIPT();	
	GemChange_Close()
end
--宝石移动：框->背包
--移动方式：右键点击
--参数含义：1，源宝石的框；2，目的宝石的框。
function GemChange_Resume_Equip(nIndex)

	if nIndex ~=1 then
		return
	end
	
	if (nIndex == 1) and (EQUIPITEM_SOURCE ~= -1) then
		GEMSOURCE_BUTTONS:SetActionItem(-1);
		LifeAbility:Lock_Packet_Item(EQUIPITEM_SOURCE,0);
		EQUIPITEM_SOURCE = -1
		--GemChange_Select:Disable(); --"选择宝石"按钮状态：不可点击

		GEMDEST_BUTTONS:SetActionItem(-1);
		LifeAbility:Lock_Packet_Item(EQUIPITEM_DEST,0);
		EQUIPITEM_DEST = -1	
		
		--元宝石框清空后，消耗元宝数清空
		CostYuanBao_Total = ""
		GemChange_WantNum:SetText(""..CostYuanBao_Total);
		
		--元宝石框清空后，交易确定按钮变灰
		GemChange_OK:Disable();	
		GemChange_Clear(); ---------------------20130304			
	end

end

--选择宝石
function GemChange_Open_DestGemList()
        if nIndex == nil or nIndex < 1 then
           nIndex = 1
        end

	if Lx == 1 then
		local strTail, nIndex = GemChange_SearchMode1:GetCurrentSelect()
                Gem_Select_ItemID = BaoShi_LeiXing[GemLv][Lx][nIndex]
		local theAction = GemMelting:UpdateProductAction(Gem_Select_ItemID);		
		GEMDEST_BUTTONS:SetActionItem(theAction:GetID());
                nIndex = nIndex
	end
	if Lx == 2 then
		local strTail, nIndex = GemChange_SearchMode2:GetCurrentSelect()
                Gem_Select_ItemID = BaoShi_LeiXing[GemLv][Lx][nIndex]
		local theAction = GemMelting:UpdateProductAction(Gem_Select_ItemID);		
		GEMDEST_BUTTONS:SetActionItem(theAction:GetID());
                nIndex = nIndex
	end
	if Lx == 3 then
		local strTail, nIndex = GemChange_SearchMode3:GetCurrentSelect()
                Gem_Select_ItemID = BaoShi_LeiXing[GemLv][Lx][nIndex]
		local theAction = GemMelting:UpdateProductAction(Gem_Select_ItemID);		
		GEMDEST_BUTTONS:SetActionItem(theAction:GetID());
                nIndex = nIndex
	end
	GemChange_OK:Enable();
        
	--PushDebugMessage("目标宝石是#{_ITEM"..Gem_Select_ItemID.."},编号"..Gem_Select_ItemID.."")
	
end

--刷新宝石列表
function GemChange_Flush_DestGemList()

end

function GemChange_BeginCareObject(objCaredId)
	this:CareObject(objCaredId,1,"GemChange");
end

function GemChange_StopCareObject(objCaredId)
	this:CareObject(objCaredId,0,"GemChange");
end

function GemChange_OnHidden()
	GemChange_StopCareObject(objCared)
	GemChange_Close()
	return
end

function GemChange_Help_Clicked()
	Helper:GotoHelper("*GemChange")
end

function GemChange_Need_YuanBao_Flush(param2,param3)

	local gem_level = tonumber(param2) --源宝石：等级
	local gem_type  = tonumber(param3) --源宝石：类别
	
	if Cost_YuanBao[gem_level] ~= nil then
		if gem_type == 3 then
		        CostYuanBao_Total = Cost_YuanBao[gem_level].special
		 else
			CostYuanBao_Total = Cost_YuanBao[gem_level].normal
		end
		GemChange_WantNum:SetText(""..CostYuanBao_Total);
	else
		GemChange_WantNum:SetText("");
	end
	
end
