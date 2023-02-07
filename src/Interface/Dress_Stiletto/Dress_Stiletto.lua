local EQUIP_BUTTONS;

local MATERIAL_BUTTONS;
local MATERIAL_QUALITY = -1;
local Need_Item = 0
local Need_Money =0
local Need_Item_Count = 0
local Bore_Count=-1
local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;
local costMoneyArray = {3000, 3600, 4200}
local g_Object = -1;
local Max_Dress_Bore_Count = 3
local Dress_Stiletto_CostItemIndex = -1;
local Dress_Cloth = -1
local Dress_GEM_ActButton = {}
local Dress_GEM_Feng = {}
local Dress_GEM_Text = {}
local Dress_GEM_Tips = {}

local g_Dress_Stiletto_Frame_UnifiedPosition;
local nSign = "&DZ("..string.rep("%d",8)..")".."(%w)".."("..string.rep("%d",8)..")".."(%w)".."("..string.rep("%d",8)..")"

function Dress_Stiletto_PreLoad()

	this:RegisterEvent("DRESS_STILETTO_UPDATE");
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OBJECT_CARED_EVENT",false);
	this:RegisterEvent("PACKAGE_ITEM_CHANGED",false);
	this:RegisterEvent("RESUME_ENCHASE_GEM",false);
	this:RegisterEvent("OPEN_STALL_SALE")
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("OPEN_DRESSCLOTH")
	this:RegisterEvent("UNIT_MONEY",false);
	this:RegisterEvent("MONEYJZ_CHANGE",false);	
end

function Dress_Stiletto_OnLoad()
	EQUIP_BUTTONS = Dress_Stiletto_RightClient1_Item
	
	Dress_GEM_ActButton[1] = Dress_Stiletto_RightClient2_P1_Item
	Dress_GEM_ActButton[2] = Dress_Stiletto_RightClient2_P2_Item	
	Dress_GEM_ActButton[3] = Dress_Stiletto_RightClient2_P3_Item
	
	Dress_GEM_Feng[1] = Dress_Stiletto_RightClient2_P1_Item_Feng
	Dress_GEM_Feng[2] = Dress_Stiletto_RightClient2_P2_Item_Feng
	Dress_GEM_Feng[3] = Dress_Stiletto_RightClient2_P3_Item_Feng

	Dress_GEM_Text[1] = Dress_Stiletto_RightClient2_P1_text2
	Dress_GEM_Text[2] = Dress_Stiletto_RightClient2_P2_text2
	Dress_GEM_Text[3] = Dress_Stiletto_RightClient2_P3_text2	
	
	Dress_GEM_Tips[1] = Dress_Stiletto_RightClient2_P1_Item_tips
	Dress_GEM_Tips[2] = Dress_Stiletto_RightClient2_P2_Item_tips
	Dress_GEM_Tips[3] = Dress_Stiletto_RightClient2_P3_Item_tips
	
	g_Dress_Stiletto_Frame_UnifiedPosition=Dress_Stiletto_Frame:GetProperty("UnifiedPosition");
	Dress_Stiletto_cost:Hide()
	Dress_Stiletto_cost_Text:Hide()
	Dress_Stiletto_TopFrame_Fenye4:Hide()
end

function Dress_Stiletto_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == 20091027) then
		local type = Get_XParam_INT(1);
		if type == 0 then
			Dress_Stiletto_CloseOtherWindows()	
			Dress_Stiletto_TopFrame_Fenye1:SetCheck(1)
			this:Show();
			-- 清空物品槽
			Dress_Stiletto_Clear();
			local xx = Get_XParam_INT(0);
			objCared = DataPool : GetNPCIDByServerID(xx);
			if objCared == -1 then
					return;
			end
			BeginCareObject_Dress_Stiletto(objCared)
		elseif type == 1 then  --更新一下界面
			Dress_Stiletto_Update('1',tostring( Dress_Cloth ))
			Dress_Stiletto_UpdateMoney()
		elseif type == 2 then  --打满了 摘下来
			Resume_Equip_Dress_Stiletto(1);
		end
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 201812181 ) then
		local type = tonumber( arg1 );
		if type == 1 and true ~= this:IsVisible() then
			Dress_Stiletto_CloseOtherWindows()	
			Dress_Stiletto_TopFrame_Fenye1:SetCheck(1)
			this:Show();
			-- 清空物品槽
			Dress_Stiletto_Clear();
			objCared = tonumber( Variable:GetVariable("DressClothNPCID") )
			g_Dress_Stiletto_Frame_UnifiedPosition = Variable:GetVariable("DressClothPos")
			if objCared == -1 then
					return;
			end
			BeginCareObject_Dress_Stiletto(objCared)
			Dress_Stiletto_Frame:SetProperty("UnifiedPosition", g_Dress_Stiletto_Frame_UnifiedPosition);
		end		
	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			
			--取消关心
			Dress_Stiletto_Cancel_Clicked()
		end

	elseif( event == "DRESS_STILETTO_UPDATE") then
		if arg0 == nil or arg1 == nil then
			return
		end 

		Dress_Stiletto_Update(tonumber(arg0),tonumber(arg1));		
    
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 201107281 and this:IsVisible()) then
		if arg1 == nil then
			return
		end 

		Dress_Stiletto_Update(1,tonumber(arg1));	
	elseif( event == "RESUME_ENCHASE_GEM" and this:IsVisible() ) then
		if(arg0~=nil and tonumber(arg0) == 1) then---xml里配置的是D1
			Resume_Equip_Dress_Stiletto(1);
		end
		
	elseif ( event == "OPEN_STALL_SALE" and this:IsVisible() ) then
		--和摆摊界面互斥
		this:Hide()
		
	elseif (event == "ADJEST_UI_POS" ) then
		Dress_Stiletto_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		Dress_Stiletto_Frame_On_ResetPos()
	elseif (event == "UNIT_MONEY" and this:IsVisible()) then
		Dress_Stiletto_RightFrame_FunClient_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));	
	elseif (event == "MONEYJZ_CHANGE" and this:IsVisible()) then
		Dress_Stiletto_RightFrame_FunClient_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));	
	end
end

function Dress_Stiletto_OnShown()
	Dress_Stiletto_Clear()
end

function Dress_Stiletto_Clear()

	if(Dress_Cloth ~= -1) then
		LifeAbility : Lock_Packet_Item(Dress_Cloth,0);
		Dress_Cloth	= -1;
	end
	EQUIP_BUTTONS : SetActionItem(-1);
	Dress_Stiletto_RightFrame_FunClient_DemandMoney:SetProperty("MoneyNumber", 0);
	local nMoneyNow,nGold,nSilverCoin,nCopperCoin = Player:GetData("MONEY");
	Dress_Stiletto_RightFrame_FunClient_SelfMoney:SetProperty("MoneyNumber", tostring(nMoneyNow));
	Dress_Stiletto_RightFrame_FunClient_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))	
	Dress_Stiletto_RightFrame_Intro:SetText("#cfff263    您可通过#G时装裁剪#cfff263，为时装开启#G点缀位#cfff263。每件时装可开启#G3个点缀位#cfff263，#G点缀位#cfff263可用来点缀时装配饰。每开启#G1#cfff263个#G点缀位#cfff263需要消耗#G1#cfff263个未锁定的#G金梭#cfff263和少量金钱。时装裁剪#G100%成功#cfff263。")
	
	for i=1,3 do
			Dress_GEM_ActButton[i]:SetActionItem(-1);
			Dress_GEM_Feng[i]:SetProperty("Image","set:BaoJianUI image:Dress_Feng")
			Dress_GEM_Text[i]:SetText("")
			Dress_GEM_ActButton[i]:SetToolTip("")
			Dress_GEM_Tips[i]:Hide()
			Dress_GEM_Feng[i]:Show()
	end	
end

function Dress_Stiletto_Update(pos1,pos0)
	local pos_packet,pos_ui;
	pos_packet = tonumber(pos0);
	pos_ui		 = tonumber(pos1)
	
	local theAction = EnumAction(pos_packet, "packageitem");
	if pos_ui == 1 then
		if theAction:GetID() ~= 0 then
			local equipPoint = LifeAbility:Get_Equip_Point(pos_packet)
			if equipPoint ~= 2 then --20190520修正
				PushDebugMessage("#{SZPR_091023_34}")
				return
			end
			local ncount = LifeAbility : GetEquip_HoleCount(pos_packet)
			if ncount > 2 then 
				PushDebugMessage("该时装点缀位数已达最大")
				--Dress_Stiletto_Clear()
				return
			end
			
			Bore_Count = ncount
			--将之前加锁物品解锁
			Dress_Stiletto_Clear()

			--加锁
			EQUIP_BUTTONS:SetActionItem(theAction:GetID());
			Dress_Cloth = pos_packet;
			LifeAbility : Lock_Packet_Item(Dress_Cloth,1);
			Dress_StilettoJian_Update()
			Dress_Stiletto_RightFrame_FunClient_DemandMoney : SetProperty("MoneyNumber", tostring(costMoneyArray[Bore_Count+1]));
			Dress_Stiletto_UpdateFakeObj()
			Dress_Stiletto_RightFrame_Intro:SetText("#cfff263    您可通过#G时装裁剪#cfff263，为时装开启#G点缀位#cfff263。每件时装可开启#G3个点缀位#cfff263，#G点缀位#cfff263可用来点缀时装配饰。每开启#G1#cfff263个#G点缀位#cfff263需要消耗#G1#cfff263个未锁定的#G金梭#cfff263和少量金钱。时装裁剪#G100%成功#cfff263。#r    #cfff263当前时装已开启点缀位：#G"..Bore_Count.."#cfff263#r    可开启点缀位：#G"..tostring(3-Bore_Count).."#cfff263")
			
			--设置DataPool中的m_vGemSeparateList
			local Dress_Bore_Count = LifeAbility : GetEquip_HoleCount(Dress_Cloth)		-- 得到时装上的宝石孔数目
			--20190228新增//////////////////////////////////////////////////////////////////////////////////////
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
--			    GemData = Split(GemInfo, ",")
--				for i = 1,4 do
--				    if tonumber(GemData[i]) ~= nil then --这样就忽略掉尴尬情况
--						table.insert(GemData_Table,tonumber(GemData[i]))
--					    --PushDebugMessage(GemData[i])
--					end
--				end
				for i = 1,3 do
					Dress_GEM_ActButton[i] : SetActionItem(-1)
					if Dress_Bore_Count >= i then
						Dress_GEM_Feng[i]:SetProperty("Image","") --未点缀
						Dress_GEM_Text[i]:SetText("#{SZZH_170111_36}")
						Dress_GEM_ActButton[i]:SetToolTip("#{SZZH_170111_35}")
						Dress_GEM_Tips[i]:Hide()
						Dress_GEM_Feng[i]:Hide()
						Dress_GEM_ActButton[i]:SetProperty("DraggingEnabled","False");
					else
						Dress_GEM_Text[i]:SetText("#{SZZH_170111_34}")
						Dress_GEM_Tips[i]:SetToolTip("#{SZZH_170111_33}")
						Dress_GEM_Tips[i]:Show()
						Dress_GEM_Feng[i]:SetProperty("Image","set:BaoJianUI image:Dress_Feng")					
						Dress_GEM_Feng[i]:Show()	
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
					Dress_GEM_Feng[i]:SetProperty("Image","set:BaoJianUI image:Dress_Feng")
				end
			end
			--//////////////////////////////////////////////////////////////////////////////////////
		else
			EQUIP_BUTTONS:SetActionItem(-1);
			LifeAbility : Lock_Packet_Item(Dress_Cloth,0);
			Dress_Cloth = -1;
			--Dress_Stiletto_Money : SetProperty("MoneyNumber", "");
			return;
		end
	end
	
end

function Dress_Stiletto_Buttons_Clicked()
	if Dress_Cloth ~= -1 and Bore_Count ~= -1 then
		if Bore_Count > Max_Dress_Bore_Count-1 then
			PushDebugMessage("#{SZPR_091023_35}")
			return 
		end
		if Player:GetData("MONEY") + Player:GetData("MONEY_JZ") < costMoneyArray[Bore_Count+1] then
			PushDebugMessage("#{RXZS_090804_11}")
			return
		else

		local sCheck = Dress_Stiletto_cost : GetProperty("Selected")
		if sCheck == 'True' then
			IsTip = 1		
		elseif sCheck == 'False' then
			IsTip = 0
		end
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("Cloth_Split");--XYJCall
			Set_XSCRIPT_ScriptID(900011);
			Set_XSCRIPT_Parameter(0,Dress_Cloth);
			Set_XSCRIPT_ParamCount(1);
		Send_XSCRIPT();		
		end
	else
		PushDebugMessage("#{SZPR_091023_84}")
	end	
end

function Dress_Stiletto_Close()
	--将加锁物品解锁
	this:Hide();
	Dress_Stiletto_Clear();
	StopCareObject_Dress_Stiletto(objCared)
	if(IsWindowShow("DressJian") == true) then
		PushEvent( "CLOSE_DRESSJIAN_DLG")		
	end	
		
end

function Dress_Stiletto_Cancel_Clicked()
	Dress_Stiletto_Close();
	return;
end

--=========================================================
--开始关心NPC，
--在开始关心之前需要先确定这个界面是不是已经有“关心”的NPC，
--如果有的话，先取消已经有的“关心”
--=========================================================
function BeginCareObject_Dress_Stiletto(objCaredId)

	g_Object = objCaredId;
	this:CareObject(g_Object, 1, "Dress_Stiletto");

end

--=========================================================
--停止对某NPC的关心
--=========================================================
function StopCareObject_Dress_Stiletto(objCaredId)
	this:CareObject(objCaredId, 0, "Dress_Stiletto");
	g_Object = -1;

end

function Resume_Equip_Dress_Stiletto(nIndex)
	if( this:IsVisible() ) then	
		Dress_Stiletto_Clear()
	end	
end

function Dress_Stiletto_Frame_On_ResetPos()
  Dress_Stiletto_Frame:SetProperty("UnifiedPosition", g_Dress_Stiletto_Frame_UnifiedPosition);
end

function Dress_StilettoJian_Update()

end

function Dress_Stiletto_UpdateFakeObj()
	--DressEnchasing : FittingOnDressNew (Dress_Cloth,-1,-1,-1)
end

function Dress_Stiletto_RestoreFakeObj()
	-- 恢复试衣前的装备参数
	--DressEnchasing : RestoreDressEnchaseFitting()
end
function Dress_Stiletto_Clicked()
--	local canPaint = DressReplaceColor:DressCanPaint(Dress_Cloth)
--	if canPaint ~= 1 then
--		PushDebugMessage("该时装不能染色，不能查看图鉴。")
--		return
--	end
	--DressReplaceColor :DressOpenDressJian(Dress_Cloth);
end

function Dress_Stiletto_UpdateMoney()
	local Bore_Count = LifeAbility : GetEquip_HoleCount(Dress_Cloth)
	Dress_Stiletto_RightFrame_FunClient_DemandMoney : SetProperty("MoneyNumber", tostring(costMoneyArray[Bore_Count+1]));	
	local nMoneyNow,nGold,nSilverCoin,nCopperCoin = Player:GetData("MONEY");
	Dress_Stiletto_RightFrame_FunClient_SelfMoney:SetProperty("MoneyNumber", tostring(nMoneyNow));
	Dress_Stiletto_RightFrame_FunClient_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))		
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

function Dress_Stiletto_FenYeClick(index)
	if index == 2 or index == 3 or index == 4 then
		Variable:SetVariable("DressClothPos", Dress_Stiletto_Frame:GetProperty("UnifiedPosition"), 1);
		Variable:SetVariable("DressClothNPCID", g_Object, 1);
		PushEvent("UI_COMMAND",201812181,index)	
		--PushEvent("OPEN_DRESSCLOTH",index)	
	end
end
