local objCared = -1
local g_Object = -1
local MAX_OBJ_DISTANCE = 3.0
local Dress_Cloth = -1
local Dress_CHARM_QUALITY = -1
local Dress_GEM_ActButton={}
local Dress_GEM_Feng = {}
local Dress_GEM_Text = {}
local Dress_GEM_Tips = {}
local Dress_GEM_Animate = {}
local Dress_Button
local GEM_SELECTED = {}
local IsTip = 0
local g_Dress_SplitGem_Frame_UnifiedPosition;
local nSelectCnt = 0
local nSign = "&DZ("..string.rep("%d",8)..")".."(%w)".."("..string.rep("%d",8)..")".."(%w)".."("..string.rep("%d",8)..")"

function Dress_SplitGem_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OBJECT_CARED_EVENT",false);	
	this:RegisterEvent("PACKAGE_ITEM_CHANGED",false);	
	this:RegisterEvent("UPDATE_DRESS_SPLITGEM");
	this:RegisterEvent("RESUME_ENCHASE_GEM",false);
	this:RegisterEvent("OPEN_STALL_SALE")
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("OPEN_DRESSCLOTH")
end

function Dress_SplitGem_OnLoad()

	Dress_Button	 = Dress_SplitGem_RightClient1_Item --时装
	Dress_GEM_ActButton[1] = Dress_SplitGem_RightClient2_P1_Item			 --配饰1
	Dress_GEM_ActButton[2] = Dress_SplitGem_RightClient2_P2_Item
	Dress_GEM_ActButton[3] = Dress_SplitGem_RightClient2_P3_Item
	
	Dress_GEM_Feng[1] = Dress_SplitGem_RightClient2_P1_Item_Feng2
	Dress_GEM_Feng[2] = Dress_SplitGem_RightClient2_P2_Item_Feng2
	Dress_GEM_Feng[3] = Dress_SplitGem_RightClient2_P3_Item_Feng2

	Dress_GEM_Text[1] = Dress_SplitGem_RightClient2_P1_text2
	Dress_GEM_Text[2] = Dress_SplitGem_RightClient2_P2_text2
	Dress_GEM_Text[3] = Dress_SplitGem_RightClient2_P3_text2	
	
	Dress_GEM_Tips[1] = Dress_SplitGem_RightClient2_P1_Item_tips
	Dress_GEM_Tips[2] = Dress_SplitGem_RightClient2_P2_Item_tips
	Dress_GEM_Tips[3] = Dress_SplitGem_RightClient2_P3_Item_tips
	
	Dress_GEM_Animate[1] = Dress_SplitGem_RightClient2_P1_Item_Animate
	Dress_GEM_Animate[2] = Dress_SplitGem_RightClient2_P2_Item_Animate
	Dress_GEM_Animate[3] = Dress_SplitGem_RightClient2_P3_Item_Animate

	g_Dress_SplitGem_Frame_UnifiedPosition=Dress_SplitGem_Frame:GetProperty("UnifiedPosition");
	Dress_SplitGem_Blank:Hide()
	Dress_SplitGem_cost_Text:Hide()
	Dress_SplitGem_TopFrame_Fenye4:Hide()
end

function Dress_SplitGem_OnEvent(event)
	if event == "UI_COMMAND" and tonumber(arg0)==19851274 then
		this:Show()
		Dress_SplitGem_Clear()
		--Dress_SplitGem_LeftFrame_FakeObject:SetFakeObject("");
		--Dress_SplitGem_LeftFrame_FakeObject:SetFakeObject("EquipChange_Player");
		Dress_SplitGem_TopFrame_Fenye3:SetCheck(1)
		local xx = Get_XParam_INT(0);
		objCared = DataPool : GetNPCIDByServerID(xx);
		if objCared == -1 then
			return;
		end
		BeginCareObject_Dress_SplitGem(objCared)
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 201812181 ) then
		local type = tonumber( arg1 );
		if type == 3 and true ~= this:IsVisible() then
			Dress_SplitGem_CloseOtherWindows()
			this:Show()
			Dress_SplitGem_Clear()
			--Dress_SplitGem_LeftFrame_FakeObject:SetFakeObject("");
			--Dress_SplitGem_LeftFrame_FakeObject:SetFakeObject("EquipChange_Player");
			Dress_SplitGem_TopFrame_Fenye3:SetCheck(1)
			local objCared = tonumber( Variable:GetVariable("DressClothNPCID") );
			if objCared == -1 then
				return;
			end
			g_Dress_SplitGem_Frame_UnifiedPosition=Variable:GetVariable("DressClothPos")
			Dress_SplitGem_Frame:SetProperty("UnifiedPosition", g_Dress_SplitGem_Frame_UnifiedPosition);
			BeginCareObject_Dress_SplitGem(objCared)			
		end
	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			
			--取消关心
			Dress_SplitGem_Cancel_Clicked()
		end
		
	elseif ( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() ) then		
		--g_LastEquipID = -1;
	  --g_LastNeedItemID = -1;	  
		if( arg0~= nil and -1 == tonumber(arg0)) then
			return;
		end		

		if (Dress_Cloth == tonumber(arg0) ) then
			Dress_SplitGem_Clear()
			Dress_SplitGem_Update(23,tonumber(arg0),1)
			--Dress_SplitGem_Explain3:Hide();
		end
	elseif( event == "UPDATE_DRESS_SPLITGEM") then
		if arg0 ~= nil then
			Dress_SplitGem_Update(arg0,arg1,0);
		end
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 201107281 and this:IsVisible()) then
		if arg1 ~= nil or tonumber(arg1)~= -1 then
			Dress_SplitGem_Update(23,tonumber(arg1),0);
		end
	elseif( event == "RESUME_ENCHASE_GEM") then
		if(arg0~=nil and (tonumber(arg0) == 23 or tonumber(arg0) == 25)) then
			Resume_Dress_Split_Gem(tonumber(arg0))
			if(tonumber(arg0) == 25) then
					Dress_SplitGem_Explain3:Hide() 
			end
		end

	elseif ( event == "OPEN_STALL_SALE" and this:IsVisible() ) then
		--和摆摊界面互斥
		this:Hide()
		
	elseif (event == "ADJEST_UI_POS" ) then
		Dress_SplitGem_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		Dress_SplitGem_Frame_On_ResetPos()

	end
	
	
end

function Dress_SplitGem_Clear()
	if(Dress_Cloth ~= -1) then
		LifeAbility : Lock_Packet_Item(Dress_Cloth,0);
		Dress_Cloth	= -1;
	end
	Dress_Button : SetActionItem(-1);
	-- Dress_SplitGem_LeftFrame_Jian:Hide()	
	-- Dress_SplitGem_LeftFrame_Text:SetText("")
	Dress_SplitGem_RestoreFakeObj()

	for i=1,3 do
			Dress_GEM_ActButton[i]:SetActionItem(-1);
			Dress_GEM_Feng[i]:SetProperty("Image","")
			Dress_GEM_Text[i]:SetText("")
			Dress_GEM_Tips[i]:SetToolTip("")		
			Dress_GEM_Tips[i]:Show()		
			Dress_GEM_Feng[i]:Show()
			Dress_GEM_Tips[i]:Show()
			Dress_GEM_Animate[i]:Hide()
			GEM_SELECTED[i] = -1
	end	
end

function BeginCareObject_Dress_SplitGem(objCared)
	g_Object = objCared;
	this:CareObject(g_Object, 1, "Dress_SplitGem");
end

function Dress_SplitGem_Cancel_Clicked()
	Dress_SplitGem_Closed()
end

function Dress_SplitGem_Closed()
	Dress_SplitGem_OnHiden()
	this:Hide()
end

function Dress_SplitGem_OnHiden()
	StopCareObject_Dress_SplitGem(objCared)
	Dress_SplitGem_Clear()
	--Dress_SplitGem_LeftFrame_FakeObject:SetFakeObject("");

	if(IsWindowShow("DressJian") == true) then
		PushEvent( "CLOSE_DRESSJIAN_DLG")		
	end	
	
	return
end


function StopCareObject_Dress_SplitGem(objCaredId)
	this:CareObject(objCaredId, 0, "Dress_SplitGem");
	g_Object = -1;
end

function Dress_SplitGem_OnShown()
	Dress_SplitGem_Clear()
end

function Dress_SplitGem_Update(arg0,arg1,IsMessage)
	local ui_Index = tonumber(arg0)
	local bagPos = tonumber(arg1)
	
	local theActionItem = EnumAction(bagPos, "packageitem")
	if ui_Index == 23 then --时装
		if theActionItem:GetID() ~= 0 then
			--//////////////////////////////////////////////ADD 20190228
			local dress_GemNum = 0
			local GemMsg_Data = tostring(SuperTooltips:GetAuthorInfo())--取得当前镶嵌信息
			if GemMsg_Data ~= nil and GemMsg_Data ~= "" then
				local nGemPos_1,nGemPos_2,nGemID_1,_,nGemID_2,_,nGemID_3 = string.find(GemMsg_Data,nSign)
				local GemMsg = {}--Split(GemMsg_Data,",")
				if nGemPos_1 ~= nil and nGemPos_2 ~= nil then
					GemMsg[1] = nGemID_1
					GemMsg[2] = nGemID_2
					GemMsg[3] = nGemID_3
				end
--				local GemMsg = Split(GemMsg_Data,",")
				for i = 1,table.getn(GemMsg) do
					if GemMsg[i] ~= nil and GemMsg[i] ~= "" then
						if tonumber(GemMsg[i]) ~= 0 and tonumber(GemMsg[i]) ~= nil then
							dress_GemNum = dress_GemNum + 1
						end
					else
						dress_GemNum = 0
					end
				end
			else
				dress_GemNum = 0
			end
			--//////////////////////////////////////////////
			local dressEquipPoint = LifeAbility : Get_Equip_Point(bagPos)
			if dressEquipPoint~=2 then --20190226修正
				PushDebugMessage("#{SZPR_091023_77}")
				return
			end
			--local dress_GemNum = LifeAbility : GetEquip_GemCount(bagPos)
			if dress_GemNum > 3 or dress_GemNum<=0 then--有没有石头
				if IsMessage == 0 then
					PushDebugMessage("#{SZZH_170111_82}")
				end
				return
			end
			
			--将之前放入UI的物品解锁
			Dress_SplitGem_Clear()
			Dress_Cloth = bagPos
			Dress_Button:SetActionItem(theActionItem:GetID())
			LifeAbility : Lock_Packet_Item(Dress_Cloth,1)
			Dress_SplitGem_UpdateFakeObj()
		else
			Dress_SplitGem_Clear()
			return
		end
		
		--放上宝石	
		--设置DataPool中的m_vGemSeparateList
		local Dress_Bore_Count = LifeAbility : GetEquip_HoleCount(Dress_Cloth)		-- 得到时装上的宝石孔数目
		local GemInfo = tostring(SuperTooltips:GetAuthorInfo())
		local GemData_Table = {}
		--PushDebugMessage(GemInfo)
		if GemInfo ~= nil and GemInfo ~= "" then
			local nGemPos_1,nGemPos_2,nGemID_1,_,nGemID_2,_,nGemID_3 = string.find(GemInfo,nSign)
			if nGemPos_1 ~= nil and nGemPos_2 ~= nil then
				GemData_Table[1] = nGemID_1
				GemData_Table[2] = nGemID_2
				GemData_Table[3] = nGemID_3
			end
--			GemData = Split(GemInfo, ",")
--			for i = 1,4 do
--				if tonumber(GemData[i]) ~= nil then --这样就忽略掉尴尬情况
--					table.insert(GemData_Table,tonumber(GemData[i]))
--					--PushDebugMessage(GemData[i])
--				end
--			end
			
			for i = 1,3 do
				Dress_GEM_ActButton[i] : SetActionItem(-1)
						
				if Dress_Bore_Count >= i then
					Dress_GEM_Feng[i]:SetProperty("Image","")
					Dress_GEM_Text[i]:SetText("#{SZZH_170111_36}")
					Dress_GEM_ActButton[i]:SetToolTip("#{SZZH_170111_35}")
					Dress_GEM_Tips[i]:Hide()
					Dress_GEM_Feng[i]:Hide()
					Dress_GEM_ActButton[i]:SetProperty("DraggingEnabled","False");
				else
					Dress_GEM_Text[i]:SetText("#{SZZH_170111_34}")
					Dress_GEM_Tips[i]:SetToolTip("#{SZZH_170111_33}")
					Dress_GEM_Tips[i]:Show()							
					Dress_GEM_Feng[i]:SetProperty("Image","set:CommonFrame25 image:EquipLingPai_Feng")
				end
				
				if tonumber(GemData_Table[i]) ~= nil then
					if tonumber(GemData_Table[i]) ~= 0 then		
						local theAction = GemMelting:UpdateProductAction(tonumber(GemData_Table[i]))
						if theAction:GetID() ~= 0 then
							
							Dress_GEM_ActButton[i] : SetActionItem(theAction:GetID());
							Dress_GEM_Feng[i]:SetProperty("Image","")
							Dress_GEM_Text[i]:SetText(theAction:GetName())
							Dress_GEM_Tips[i]:SetToolTip(theAction:GetName())
							Dress_GEM_Tips[i]:Show()
						end
					end
				else
					Dress_GEM_ActButton[i] : SetActionItem(-1)
				end
			end
		else
			for i=1,3 do
				Dress_GEM_ActButton[i] : SetActionItem(-1)
				Dress_GEM_Feng[i]:SetProperty("Image","set:CommonFrame25 image:EquipLingPai_Feng")
			end
		end							
	end	
end

function Resume_Dress_Split_Gem(index)
	if index ~= 23 then
		return
	end
	
	Dress_SplitGem_Clear()
end


function Dress_SplitGem_Selected(Gem_Index)
	for i=1,3 do
	    Dress_GEM_Animate[i]:Hide()
	end
	if Dress_GEM_ActButton[Gem_Index]:GetActionItem() == -1 then
		return
	end
	--if GEM_SELECTED[Gem_Index] ~= -1 then
	--	Dress_GEM_Animate[Gem_Index]:Hide()
	--	GEM_SELECTED[Gem_Index] = -1
	--else
		Dress_GEM_Animate[Gem_Index]:Show()
	--	GEM_SELECTED[Gem_Index] = Gem_Index
	--end
    nSelectCnt = Gem_Index
end

function Dress_SplitGem_Buttons_Clicked()

	-- 判断是否为安全时间2012.6.12-LIUBO
	if (tonumber(DataPool:GetLeftProtectTime()) > 0) then
		PushDebugMessage("#{ZYXT_120528_16}")
		return
	end
	
--	local nSelectCnt = 0
--	for i=1,3 do 
--		if GEM_SELECTED[i] ~= -1 then
--			nSelectCnt = nSelectCnt + 1
--		end
--	end
	if nSelectCnt == 0 then
		PushDebugMessage("#{SZZH_170111_84}")
		return
	end
	
	if Dress_Cloth == -1 then
		PushDebugMessage("#{SZPR_XML_74}")
		return
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("Cloth_SplitGem");
		Set_XSCRIPT_ScriptID(900011);
		Set_XSCRIPT_Parameter(0,Dress_Cloth);
		Set_XSCRIPT_Parameter(1,nSelectCnt);
		Set_XSCRIPT_ParamCount(2);
	Send_XSCRIPT();	
end

function Dress_SplitGem_Frame_On_ResetPos()
  Dress_SplitGem_Frame:SetProperty("UnifiedPosition", g_Dress_SplitGem_Frame_UnifiedPosition);
end

function Dress_SplitGem_UpdateFakeObj()
--	DressEnchasing : FittingOnDressNew (Dress_Cloth,-1,-1,-1)
--	local n_szDressDesc, nRate,MaterBind = DressReplaceColor : GetDressVisualInfo(Dress_Cloth)	
--
--	local strdic;
--	if nRate == 23000 then
--		strdic = ScriptGlobal_Format("#{SZRSYH_120912_10}", n_szDressDesc)
--	elseif nRate == 14000 then
--		strdic = ScriptGlobal_Format("#{SZRSYH_120912_11}", n_szDressDesc)
--	elseif nRate == 1000 then
--		strdic = ScriptGlobal_Format("#{SZRSYH_120912_12}", n_szDressDesc)
--	elseif nRate == -1 then
--		strdic = "#G"..n_szDressDesc
--	end
--		
--	Dress_SplitGem_LeftFrame_Jian:Show()
--	Dress_SplitGem_LeftFrame_Text:SetText(strdic)
end

function Dress_SplitGem_RestoreFakeObj()
	-- 恢复试衣前的装备参数
	--DressEnchasing : RestoreDressEnchaseFitting()
end

function Dress_SplitGem_Clicked()

end

function Dress_SplitGem_FenYeClick(index)
	if index == 1 or index == 2 or index == 4 then
		Variable:SetVariable("DressClothPos", Dress_SplitGem_Frame:GetProperty("UnifiedPosition"), 1);
		Variable:SetVariable("DressClothNPCID", g_Object, 1);
		--PushEvent("OPEN_DRESSCLOTH",index)	
		PushEvent("UI_COMMAND",201812181,index)	
	end
end

function Dress_SplitGem_CloseOtherWindows()
	if(IsWindowShow("Dress_Stiletto")) then
		CloseWindow("Dress_Stiletto", true);
	end			
	if(IsWindowShow("Dress_Transfer")) then
		CloseWindow("Dress_Transfer", true);
	end			
	if(IsWindowShow("Dress_Enchase")) then
		CloseWindow("Dress_Enchase", true);
	end				
end

--- 得到当前材料包有多少空位
function Dress_SplitGem_SpaceNum()
  local CurrBagNum = DataPool:GetMatBag_Num()
  local curMatNum  = 0
	for i=1, CurrBagNum do
        local theAction,bLocked = PlayerPackage:EnumItem( "material", i-1 );
        if theAction : GetID() ~= 0 then
            curMatNum = curMatNum + 1
        end
    end
    return CurrBagNum - curMatNum
end
