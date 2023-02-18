-- ʱװ������Ƕ����

local Dress_Enchase_CoseArray = {5000,6000,7000,8000}
local g_objCared = -1
local Dress_Gem_Buttons={}
local Dress_GemID = {}
local Dress_GemType = {}
local Dress_GemIsNew = {}
local Dress_GemPos = {}
local Dress_GEM_ActButton = {}
local Dress_GEM_Feng = {}
local Dress_GEM_Text = {}
local Dress_GEM_Tips = {}
local Dress_GEM_Animate = {}
local Dress_GEM_EFFECT ={}
local MAX_OBJ_DISTANCE =3.0
local Dress_Gem_Cost = {5000,6000,7000,8000}
local Dress_Cloth = -1
local Dress_GemNewCnt = 0 
local IsTip = 0  --�Ƿ���ʾ��ݹ���
local Dress_FenYe ={}
local lastDress = -1
local lastGem = {}
local nTips = 
{
	[1] = "#{SZZH_170306_144}",
	[2] = "#{SZZH_170306_143}",
	[3] = "#{SZZH_170306_145}",
};
local nSign = "&DZ("..string.rep("%d",8)..")".."(%w)".."("..string.rep("%d",8)..")".."(%w)".."("..string.rep("%d",8)..")"

local g_Dress_Enchase_Frame_UnifiedPosition;

function Dress_Enchase_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OBJECT_CARED_EVENT",false);
	this:RegisterEvent("UPDATE_DRESS_ENCHASE")
	this:RegisterEvent("RESUME_ENCHASE_GEM",false)
	this:RegisterEvent("PACKAGE_ITEM_CHANGED",false);	
	this:RegisterEvent("UNIT_MONEY",false);
	this:RegisterEvent("MONEYJZ_CHANGE",false);
	this:RegisterEvent("ENABLE_DRESS_ENCHASE_PREVIEW");
	this:RegisterEvent("DISABLE_DRESS_ENCHASE_PREVIEW");
	this:RegisterEvent("OPEN_STALL_SALE");
	this:RegisterEvent("PROGRESSBAR_SHOW");
	this:RegisterEvent("CLOSE_DRESS_ENCHASE");	
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("OPEN_DRESSCLOTH")
end

function Dress_Enchase_OnLoad()
	Dress_Cloth = -1;		-- ʱװ
	Dress_GemNewCnt = 0 ;  -- ʱװ������ʯ����
	for i=1,3 do
		Dress_GemID[i] = 0   --ʱװ��ʯid
		Dress_GemType[i] = -1 --ʱװ��ʯ����
		Dress_GemIsNew[i] = -1 --�Ƿ���������ʱװ��ʯ
		Dress_GemPos[i] = -1  --����ʱװ��ʯ�ڱ����е�λ��
	end
	
	Dress_GEM_ActButton[1] = Dress_Enchase_RightClient2_P1_Item
	Dress_GEM_ActButton[2] = Dress_Enchase_RightClient2_P2_Item	
	Dress_GEM_ActButton[3] = Dress_Enchase_RightClient2_P3_Item
	
	Dress_GEM_Feng[1] = Dress_Enchase_RightClient2_P1_Item_Feng2
	Dress_GEM_Feng[2] = Dress_Enchase_RightClient2_P2_Item_Feng2
	Dress_GEM_Feng[3] = Dress_Enchase_RightClient2_P3_Item_Feng2

	Dress_GEM_Text[1] = Dress_Enchase_RightClient2_P1_text2
	Dress_GEM_Text[2] = Dress_Enchase_RightClient2_P2_text2
	Dress_GEM_Text[3] = Dress_Enchase_RightClient2_P3_text2	
	
	Dress_GEM_Tips[1] = Dress_Enchase_RightClient2_P1_Item_tips
	Dress_GEM_Tips[2] = Dress_Enchase_RightClient2_P2_Item_tips
	Dress_GEM_Tips[3] = Dress_Enchase_RightClient2_P3_Item_tips
	
	Dress_GEM_Animate[1] = Dress_Enchase_RightClient2_P1_Item_Animate
	Dress_GEM_Animate[2] = Dress_Enchase_RightClient2_P2_Item_Animate
	Dress_GEM_Animate[3] = Dress_Enchase_RightClient2_P3_Item_Animate
		
	g_Dress_Enchase_Frame_UnifiedPosition=Dress_Enchase_Frame:GetProperty("UnifiedPosition");
	Dress_Enchase_cost:Hide()
	Dress_Enchase_cost_Text:Hide()
	Dress_Enchase_TopFrame_Fenye4:Hide()
end

function Dress_Enchase_OnEvent(event)
	if(event == "UI_COMMAND" and tonumber(arg0)==20091029) then
		local type = Get_XParam_INT(1);
		if type == 0 then
			Dress_Enchase_CloseOtherWindows()
			Dress_Enchase_TopFrame_Fenye2:SetCheck(1)
			this:Show()
					
			g_objCared = -1;
			local xx = Get_XParam_INT(0);
			g_objCared = DataPool : GetNPCIDByServerID(xx);
			if g_objCared == -1 then				
					return;
			end
			BeginCareObject_Dress_Enchase(g_objCared)
			
			Dress_Enchase_InitFakeObj()
		elseif type == 1 then  --������ ʱװȡ����
			Dress_Enchase_Resume_Gem(25)
		elseif type == 2 then  --����� ����һ�½���
			Dress_Enchase_Update('1', tostring( Dress_Cloth ))		
		end
		return
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 201812181 ) then
		local type = tonumber( arg1 );
		if type == 2 and true ~= this:IsVisible() then
			Dress_Enchase_CloseOtherWindows()
			Dress_Enchase_TopFrame_Fenye2:SetCheck(1)
			this:Show()
			g_objCared = tonumber( Variable:GetVariable("DressClothNPCID") )
			if g_objCared == -1 then				
					return;
			end
			g_Dress_Enchase_Frame_UnifiedPosition=Variable:GetVariable("DressClothPos")
			Dress_Enchase_Frame:SetProperty("UnifiedPosition", g_Dress_Enchase_Frame_UnifiedPosition);
			BeginCareObject_Dress_Enchase(g_objCared)
			
			Dress_Enchase_InitFakeObj()			
		end
	-- ��ʼ��̯�����ܽ�����Ƕ
	elseif ( event == "OPEN_STALL_SALE" ) then
		if this:IsVisible() then
			Dress_Enchase_OnHiden();
		end
		return
		
	-- ���������У����ܽ�����Ƕ
	elseif ( event == "PROGRESSBAR_SHOW" ) then
		if this:IsVisible() then
			Dress_Enchase_OnHiden();
		end
		return
		
	-- ĳЩ���ܻ��⣬��Ҫ�رոý���
	elseif ( event == "CLOSE_DRESS_ENCHASE" ) then
		if this:IsVisible() then
			Dress_Enchase_OnHiden();
		end
		return

	elseif(event == "UPDATE_DRESS_ENCHASE") then
		-- ������ʱװ�������Σ���ԭԤ��
		if ( (tonumber(arg0) == 1) or (tonumber(arg0) == 2) or (tonumber(arg0) == 20) or (tonumber(arg0) == 21) or (tonumber(arg0) == 22) ) then
			Dress_Enchase_Update(arg0,arg1)
			--DressEnchasing : RestoreDressEnchaseFitting()
		end	
		return
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 201107281 and this:IsVisible()) then
		if arg1 == nil or tonumber(arg1) == -1  then
		    return
		end
        Dress_Enchase_UpdateActionButton(tonumber(arg1))
	elseif(event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if(tonumber(arg0) ~= g_objCared) then
			return;
		end
		--�����NPC�ľ������һ��������߱�ɾ�����Զ��ر�
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			Dress_Enchase_OnHiden()
		end
		return

	elseif( event == "RESUME_ENCHASE_GEM" and this:IsVisible() ) then
		if(arg0~=nil and tonumber(arg0) == 3) then---xml�����õ���D3
			Dress_Enchase_Resume_Gem(25);									-- ȡ��ʱװ
		elseif(arg0~=nil and tonumber(arg0) == 5 ) then
			Dress_Enchase_Resume_Gem(1)									-- ȡ������1
		elseif(arg0~=nil and tonumber(arg0) == 102 ) then
			Dress_Enchase_Resume_Gem(2)									-- ȡ������2
		elseif(arg0~=nil and tonumber(arg0) == 103 ) then
			Dress_Enchase_Resume_Gem(3)									-- ȡ������3						
		end
		return

	elseif( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() ) then
		
	elseif (event == "UNIT_MONEY" and this:IsVisible()) then
		Dress_Enchase_RightFrame_FunClient_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));	
	elseif (event == "MONEYJZ_CHANGE" and this:IsVisible()) then
		Dress_Enchase_RightFrame_FunClient_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
		
	elseif (event == "ADJEST_UI_POS" ) then
		Dress_Enchase_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		Dress_Enchase_Frame_On_ResetPos()
	
	end
	
end
		
function BeginCareObject_Dress_Enchase(objCaredId)
	g_objCared = objCaredId;
	this:CareObject(objCaredId, 1, "Dress_Enchase");
end

function StopCareObject_Dress_Enchase(objCaredId)
	this:CareObject(objCaredId, 0, "Dress_Enchase")
	g_objCared = -1
end

function Dress_Enchase_OnHiden()
	StopCareObject_Dress_Enchase(g_objCared)
	Dress_Enchase_Clear()
	-- Dress_Enchase_RestoreFakeObj()
	-- Dress_Enchase_LeftFrame_FakeObject:SetFakeObject("");
	
	if(IsWindowShow("DressJian") == true) then
		PushEvent( "CLOSE_DRESSJIAN_DLG")		
	end
	
	this:Hide()
end

function Dress_Enchase_Clear()
	if Dress_Cloth ~= -1 then
		LifeAbility : Lock_Packet_Item(Dress_Cloth,0);
		Dress_Cloth = -1
	end
	
	Dress_Enchase_RightClient1_Item:SetActionItem(-1);
	Dress_GemNewCnt = 0

	for i=1,3 do
			if Dress_GemIsNew[i] == 1 then
				LifeAbility : Lock_Packet_Item(Dress_GemPos[i],0);
			end
			Dress_GEM_ActButton[i]:SetActionItem(-1);
			Dress_GEM_ActButton[i]:SetProperty("DraggingEnabled","False");				
			Dress_GEM_Feng[i]:SetProperty("Image","")
			Dress_GemID[i] = -1   --ʱװ��ʯid
			Dress_GemType[i] = -1 --ʱװ��ʯ����
			Dress_GemIsNew[i] = -1 --�Ƿ���������ʱװ��ʯ
			Dress_GemPos[i] = -1  --����ʱװ��ʯ�ڱ����е�λ��	
			Dress_GEM_Text[i]:SetText("")
			Dress_GEM_Tips[i]:SetToolTip("")
			Dress_GEM_Feng[i]:Show()
			Dress_GEM_Tips[i]:Show()
			Dress_GEM_Animate[i]:Hide()
	end
	
	Dress_Enchase_RightFrame_FunClient_DemandMoney : SetProperty("MoneyNumber", 0);
	local nMoneyNow,nGold,nSilverCoin,nCopperCoin = Player:GetData("MONEY");
	Dress_Enchase_RightFrame_FunClient_SelfMoney:SetProperty("MoneyNumber", tostring(nMoneyNow));
	Dress_Enchase_RightFrame_FunClient_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))	
	Dress_Enchase_RightFrame_Intro:SetText("#{SZZH_170111_51}")
end

function Dress_Enchase_Resume_Gem(nIndex)
	if nIndex == 25 then
		Dress_Enchase_Clear()
		Dress_Enchase_InitFakeObj()
		Dress_Enchase_RestoreFakeObj()
	elseif nIndex == 1 or nIndex == 2 or nIndex == 3 then --�Ҽ�����
		if Dress_GemIsNew[nIndex] == 1 then --�����������β���ȡ��
			Dress_GEM_ActButton[nIndex]:SetActionItem(-1);
			LifeAbility : Lock_Packet_Item(Dress_GemPos[nIndex],0);
			Dress_GemType[nIndex] = 0 --ʱװ��ʯ����
			Dress_GemIsNew[nIndex] = -1 --�Ƿ���������ʱװ��ʯ
			Dress_GemPos[nIndex] = -1  --����ʱװ��ʯ�ڱ����е�λ��			
			Dress_GEM_Animate[nIndex]:Hide()
			Dress_GEM_ActButton[nIndex]:SetToolTip("#{SZZH_170111_35}")
			Dress_GEM_Tips[nIndex]:Hide()
			Dress_Enchase_UpdateMoney()
			Dress_Enchase_UpdateFakeObj()
		end
	end
end

function Dress_Enchase_OnShown()
	Dress_Enchase_Clear()
	Dress_Enchase_RightFrame_FunClient_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
	Dress_Enchase_RightFrame_FunClient_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
end
function Dress_Enchase_UpdateActionButton(pos)
	if pos == -1 then
		return
	end
    local itemID = PlayerPackage:GetItemTableIndex(pos)
	if itemID < 19999999 and itemID > 10000000 then
		--Ϊװ��
		Dress_Enchase_Update(1,pos)
	end
	if itemID < 50000000 and itemID > 20000000 then
		--Ϊ����
		--EnchaseEx_Update_Sub(pos)
	end
	if itemID < 60000000 and itemID > 50000000 then
		--Ϊ��ʯ
		Dress_Enchase_Update(2,pos)
	end
end
function Dress_Enchase_Update(ItemIndex, ItemPos)		
	local IIndex = tonumber(ItemIndex)
	local IPos = tonumber(ItemPos)
	local theActionItem = EnumAction(IPos, "packageitem")
	local Dress_Bore_Count = 0
	local Dress_Gem_Enchased = 0

	if theActionItem:GetID() ~= 0 then
		if IIndex == 1 then---װ���࣬��Ҫʱװ
			local equipPoint = LifeAbility:Get_Equip_Point(IPos)
			if equipPoint ~= 2 then --20190226����
				PushDebugMessage("#{SZPR_091023_45}")
				return
			end

			Dress_Bore_Count = LifeAbility : GetEquip_HoleCount(IPos)		-- �õ�ʱװ�ϵı�ʯ����Ŀ
			--//////////////////////////////////////////////ADD 20190228 
			--FIX 20190520 BY XYZ
			local GemMsg_Data = tostring(SuperTooltips:GetAuthorInfo())--ȡ�õ�ǰ��Ƕ��Ϣ
			if GemMsg_Data ~= nil and GemMsg_Data ~= "" then
				local nGemPos_1,nGemPos_2,nGemID_1,_,nGemID_2,_,nGemID_3 = string.find(GemMsg_Data,nSign)
				local GemMsg = {}--Split(GemMsg_Data,",")
				if nGemPos_1 ~= nil and nGemPos_2 ~= nil then
					GemMsg[1] = nGemID_1
					GemMsg[2] = nGemID_2
					GemMsg[3] = nGemID_3
				end
				for i = 1,table.getn(GemMsg) do
					if GemMsg[i] ~= nil and GemMsg[i] ~= "" then
						if tonumber(GemMsg[i]) ~= 0 and tonumber(GemMsg[i]) ~= nil then
							Dress_Gem_Enchased = Dress_Gem_Enchased + 1
						end
					else
						Dress_Gem_Enchased = 0
					end
				end
			else
				Dress_Gem_Enchased = 0
			end
			--//////////////////////////////////////////////
			--Dress_Gem_Enchased = LifeAbility : GetEquip_GemCount(IPos)	-- �����Ƕ��ʱװ�ϵı�ʯ��Ŀ
			
			if Dress_Gem_Enchased == 3 then 
				PushDebugMessage("#{SZPR_091023_47}")				-- "��ʱװ��������Ƕ���������"
				return
			end

			if Dress_Bore_Count == Dress_Gem_Enchased then
				PushDebugMessage("#{SZPR_091023_87}")				-- "��ʱװ��Ҫ��������246��129������ʴ����ӿ�λ����ܼ�����Ƕ"
				return
			end

			Dress_Enchase_Clear()
			
			Dress_Enchase_RightClient1_Item:SetActionItem(theActionItem:GetID());
			LifeAbility : Lock_Packet_Item(IPos,1);
			Dress_Cloth = IPos	
			Dress_Enchase_RightFrame_Intro:SetText("#{SZZH_170111_51}#r    #cfff263��ǰʱװ�ɵ�׺��������#G"..tostring(Dress_Bore_Count-Dress_Gem_Enchased).."#cfff263")
			
			lastDress = -1
			lastGem[1] = -1
			lastGem[2] = -1
			lastGem[3] = -1			
			
			--����DataPool�е�m_vGemSeparateList
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
--				GemData = Split(GemInfo, ",")
--				for i = 1,4 do
--				    if tonumber(GemData[i]) ~= nil then --�����ͺ��Ե��������
--						table.insert(GemData_Table,tonumber(GemData[i]))
--					    --PushDebugMessage(GemData[i])
--					end
--				end
				
				for i = 1,3 do
					Dress_GEM_ActButton[i] : SetActionItem(-1)
					if Dress_Bore_Count >= i then
						Dress_GEM_Feng[i]:SetProperty("Image","")
						Dress_GEM_Text[i]:SetText("#{SZZH_170111_36}")
						Dress_GEM_ActButton[i]:SetToolTip("#{SZZH_170111_35}")
						Dress_GEM_Feng[i]:Hide()
						Dress_GEM_Tips[i]:Hide()
						Dress_GEM_ActButton[i]:SetProperty("DraggingEnabled","False");
						Dress_GemType[i]=0
					else
						Dress_GEM_Text[i]:SetText("#{SZZH_170111_34}")
						Dress_GEM_Tips[i]:SetToolTip("#{SZZH_170111_33}")	
						Dress_GEM_Tips[i]:Show()							
						Dress_GEM_Feng[i]:SetProperty("Image","set:BaoJianUI image:Dress_Feng")
						Dress_GemType[i]=-1
					end
					
					if tonumber(GemData_Table[i]) ~= nil then
						if tonumber(GemData_Table[i]) ~= 0 then		
							local theAction = GemMelting:UpdateProductAction(tonumber(GemData_Table[i]))
							if theAction:GetID() ~= 0 then
								
								Dress_GemID[i] = gemid   --ʱװ��ʯid
								Dress_GemType[i] = 31 --ʱװ��ʯ����
								Dress_GemIsNew[i] = 0 --�Ƿ���������ʱװ��ʯ
								Dress_GemPos[i] = -1  --����ʱװ��ʯ�ڱ����е�λ��
								
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
			Dress_Enchase_UpdateFakeObj()
			Dress_Enchase_UpdateMoney()
			Dress_EnchaseJian_Update()
		elseif IIndex == 2 then--- �Ҽ����������
			Dress_Enchase_UpdatePeiShiYouJian(IIndex,IPos)
		elseif IIndex == 20 then--- �����ק����һ������
			Dress_Enchase_UpdatePeiShiZuoJian(IIndex,IPos,1)
		elseif IIndex == 21 then--- �����ק���ڶ�������
			Dress_Enchase_UpdatePeiShiZuoJian(IIndex,IPos,2)
		elseif IIndex == 22 then--- �����ק������������
			Dress_Enchase_UpdatePeiShiZuoJian(IIndex,IPos,3)						
		end
	end	
end

function Dress_Enchase_UpdatePeiShiZuoJian(IIndex,IPos,nGeZi)
	local theActionItem = EnumAction(IPos, "packageitem")
	local nGemType = 31
--	local nGemType = LifeAbility : Get_Gem_Level(IPos,2);
	--if(nGemType ~= 31 and nGemType ~= 32 and nGemType ~= 33) then
	--	PushDebugMessage("#{SZPR_091023_48}")
	--	return
	--end
	if Dress_Cloth == -1 then
		PushDebugMessage("#{SZPR_091023_89}")
		return
	end

	local	Dress_Bore_Count = LifeAbility : GetEquip_HoleCount(Dress_Cloth)		-- �õ�ʱװ�ϵı�ʯ����Ŀ
	--//////////////////////////////////////////////ADD 20190228
	--FIX 20190520 XYZ
	local Dress_Gem_Enchased = 0
	local GemMsg_Data = tostring(SuperTooltips:GetAuthorInfo())--ȡ�õ�ǰ��Ƕ��Ϣ
	if GemMsg_Data ~= nil and GemMsg_Data ~= "" then
		local nGemPos_1,nGemPos_2,nGemID_1,_,nGemID_2,_,nGemID_3 = string.find(GemMsg_Data,nSign)
		local GemMsg = {}--Split(GemMsg_Data,",")
		if nGemPos_1 ~= nil and nGemPos_2 ~= nil then
			GemMsg[1] = nGemID_1
			GemMsg[2] = nGemID_2
			GemMsg[3] = nGemID_3
		end
		--local GemMsg = Split(GemMsg_Data,",")
		for i = 1,table.getn(GemMsg) do
			if GemMsg[i] ~= nil and GemMsg[i] ~= "" then
				if tonumber(GemMsg[i]) ~= 0 and tonumber(GemMsg[i]) ~= nil then
					Dress_Gem_Enchased = Dress_Gem_Enchased + 1
				end
			else
				Dress_Gem_Enchased = 0
			end
		end
	else
		Dress_Gem_Enchased = 0
	end
	--//////////////////////////////////////////////
	--local	Dress_Gem_Enchased = LifeAbility : GetEquip_GemCount(Dress_Cloth)	-- �����Ƕ��ʱװ�ϵı�ʯ��Ŀ	
		
	if nGeZi > Dress_Bore_Count then
		PushDebugMessage("#{SZZH_170111_58}")
		return		
	end
									
	if Dress_GemIsNew[nGeZi] == 0 then
		PushDebugMessage("#{SZZH_170111_59}")
		return			
	end
									
--	for i=1,3 do
--		if nGemType == Dress_GemType[i] and i~=nGeZi then
--			if Dress_GemIsNew[i] == 0 then
--				PushDebugMessage(ScriptGlobal_Format("#{SZZH_170216_137}",nTips[nGemType-30]))
--			elseif Dress_GemIsNew[i] == 1 then
--				PushDebugMessage("��Ҫ��׺�������������Ѿ��������ĵ�׺�����ظ�����ѡ���������͵����Ρ�")
--			end			
--			return		
--		end 
--	end
	
	local isTihuan = 0
	if Dress_GemIsNew[nGeZi] == 1 then
		isTihuan = nGeZi
	end
	
	if isTihuan > 0 then
		--ԭ�������ν���
		LifeAbility : Lock_Packet_Item(Dress_GemPos[isTihuan],0);
		Dress_GemIsNew[isTihuan] = 1
		Dress_GemPos[isTihuan] = IPos
		Dress_GemType[isTihuan] = nGemType		
		
		Dress_GEM_ActButton[isTihuan]:SetActionItem(theActionItem:GetID());
		LifeAbility : Lock_Packet_Item(IPos,1);
	else
	
		Dress_GemIsNew[nGeZi] = 1 --�Ƿ���������ʱװ��ʯ
		Dress_GemPos[nGeZi] = IPos  --����ʱװ��ʯ�ڱ����е�λ��
		Dress_GemType[nGeZi] = nGemType --ʱװ��ʯ����
		
		Dress_GEM_ActButton[nGeZi]:SetActionItem(theActionItem:GetID());
		Dress_GEM_Animate[nGeZi]:Show()
		Dress_GEM_Tips[nGeZi]:Hide()	
		LifeAbility : Lock_Packet_Item(IPos,1);
	end
	
	Dress_Enchase_UpdateMoney()
	Dress_Enchase_UpdateFakeObj()		
end

function Dress_Enchase_UpdatePeiShiYouJian(IIndex,IPos)
	local theActionItem = EnumAction(IPos, "packageitem")
	local nGemType = 31
	if(nGemType ~= 31 and nGemType ~= 32 and nGemType ~= 33) then
		PushDebugMessage("#{SZPR_091023_48}")
		return
	end
	if Dress_Cloth == -1 then
		PushDebugMessage("#{SZPR_091023_89}")
		return
	end
						
	local	Dress_Bore_Count = LifeAbility : GetEquip_HoleCount(Dress_Cloth)		-- �õ�ʱװ�ϵı�ʯ����Ŀ
	--//////////////////////////////////////////////ADD 20190228
	local Dress_Gem_Enchased = 0
	local GemMsg_Data = tostring(SuperTooltips:GetAuthorInfo())--ȡ�õ�ǰ��Ƕ��Ϣ
	if GemMsg_Data ~= nil and GemMsg_Data ~= "" then
		--local GemMsg = Split(GemMsg_Data,",")
		local nGemPos_1,nGemPos_2,nGemID_1,_,nGemID_2,_,nGemID_3 = string.find(GemMsg_Data,nSign)
		local GemMsg = {}--Split(GemMsg_Data,",")
		if nGemPos_1 ~= nil and nGemPos_2 ~= nil then
			GemMsg[1] = nGemID_1
			GemMsg[2] = nGemID_2
			GemMsg[3] = nGemID_3
		end
		for i = 1,table.getn(GemMsg) do
			if GemMsg[i] ~= nil and GemMsg[i] ~= "" then
				if tonumber(GemMsg[i]) ~= 0 and tonumber(GemMsg[i]) ~= nil then
					Dress_Gem_Enchased = Dress_Gem_Enchased + 1
				end
			else
				Dress_Gem_Enchased = 0
			end
		end
	else
		Dress_Gem_Enchased = 0
	end
	--//////////////////////////////////////////////
--	local	Dress_Gem_Enchased = LifeAbility : GetEquip_GemCount(Dress_Cloth)	-- �����Ƕ��ʱװ�ϵı�ʯ��Ŀ					
--	for i=1,3 do
--		if nGemType == Dress_GemType[i] and Dress_GemIsNew[i] == 0 then
--			PushDebugMessage(ScriptGlobal_Format("#{SZZH_170216_137}",nTips[nGemType-30]))
--			return			
--		end 
--	end
	
	local isTihuan = 0
	for i=1,3 do  -- �ȿ���û�п׿����滻
		if nGemType == Dress_GemType[i] and Dress_GemIsNew[i] == 1 then
			isTihuan = i
			break		
		end 
	end
	local nKong = 0
	if isTihuan == 0 then  --û�׿����滻 �ҿ�λ��
		for i=1,3 do
			if Dress_GemType[i] == 0 then
				nKong = i		
				break
			end 
		end
	end
	if isTihuan == 0 and nKong == 0 then --û�׿����滻 Ҳû��λ�� �ҵ�һ�������������滻
		for i=1,3 do
			if Dress_GemIsNew[i] == 1 then
				isTihuan = i	
				break	
			end 
		end	
	end
	
	if isTihuan > 0 then
		--ԭ�������ν���
		LifeAbility : Lock_Packet_Item(Dress_GemPos[isTihuan],0);
		Dress_GemIsNew[isTihuan] = 1
		Dress_GemPos[isTihuan] = IPos
		Dress_GemType[isTihuan] = nGemType		
		
		Dress_GEM_ActButton[isTihuan]:SetActionItem(theActionItem:GetID());
		LifeAbility : Lock_Packet_Item(IPos,1);
	else
	
		Dress_GemIsNew[nKong] = 1 --�Ƿ���������ʱװ��ʯ
		Dress_GemPos[nKong] = IPos  --����ʱװ��ʯ�ڱ����е�λ��
		Dress_GemType[nKong] = nGemType --ʱװ��ʯ����
		
		Dress_GEM_ActButton[nKong]:SetActionItem(theActionItem:GetID());
		Dress_GEM_Animate[nKong]:Show()
		Dress_GEM_Tips[nKong]:Hide()
		LifeAbility : Lock_Packet_Item(IPos,1);
	end
	
	Dress_Enchase_UpdateMoney()
	Dress_Enchase_UpdateFakeObj()
end

function Dress_Enchase_InitFakeObj()
	-- Dress_Enchase_LeftFrame_FakeObject:SetFakeObject("");
	-- Dress_Enchase_LeftFrame_FakeObject:SetFakeObject("EquipChange_Player");
	-- Dress_Enchase_LeftFrame_Jian:Hide()
	-- Dress_Enchase_LeftFrame_Text:SetText("")
end

function Dress_Enchase_UpdateFakeObj()
--	DressEnchasing : FittingOnDressNew (Dress_Cloth,Dress_GemPos[1],Dress_GemPos[2],Dress_GemPos[3])
    -- Dress_Enchase_LeftFrame_FakeObject:SetFakeObject("");
	-- Dress_Enchase_LeftFrame_FakeObject:SetFakeObject("EquipChange_Player")
end

function Dress_Enchase_RestoreFakeObj()
	-- �ָ�����ǰ��װ������
--	DressEnchasing : RestoreDressEnchaseFitting()
	-- Dress_Enchase_LeftFrame_FakeObject:SetFakeObject("");
	-- Dress_Enchase_LeftFrame_FakeObject:SetFakeObject("EquipChange_Player");
end

function Dress_Enchase_Frame_On_ResetPos()
  Dress_Enchase_Frame:SetProperty("UnifiedPosition", g_Dress_Enchase_Frame_UnifiedPosition);
end

function Dress_Enchase_UpdateMoney()
	--//////////////////////////////////////////////ADD 20190228
	local Dress_Gem_Enchased = 0
	local GemMsg_Data = tostring(SuperTooltips:GetAuthorInfo())--ȡ�õ�ǰ��Ƕ��Ϣ
	if GemMsg_Data ~= nil and GemMsg_Data ~= "" then
		local nGemPos_1,nGemPos_2,nGemID_1,_,nGemID_2,_,nGemID_3 = string.find(GemMsg_Data,nSign)
		local GemMsg = {}--Split(GemMsg_Data,",")
		if nGemPos_1 ~= nil and nGemPos_2 ~= nil then
			GemMsg[1] = nGemID_1
			GemMsg[2] = nGemID_2
			GemMsg[3] = nGemID_3
		end
		--local GemMsg = Split(GemMsg_Data,",")
		for i = 1,table.getn(GemMsg) do
			if GemMsg[i] ~= nil and GemMsg[i] ~= "" then
				if tonumber(GemMsg[i]) ~= 0 and tonumber(GemMsg[i]) ~= nil then
					Dress_Gem_Enchased = Dress_Gem_Enchased + 1
				end
			else
				Dress_Gem_Enchased = 0
			end
		end
	else
		Dress_Gem_Enchased = 0
	end
	--//////////////////////////////////////////////
	--local	Dress_Gem_Enchased = LifeAbility : GetEquip_GemCount(Dress_Cloth)	-- �����Ƕ��ʱװ�ϵı�ʯ��Ŀ	
	local needMoney = 0
	local isnewcnt = 0
	for i=1,3 do
		if Dress_GemIsNew[i] == 1 then
			isnewcnt = isnewcnt + 1
			local nLevel = 4
			needMoney = needMoney + (Dress_Gem_Enchased + isnewcnt)*Dress_Gem_Cost[nLevel]
		end
	end
	Dress_Enchase_RightFrame_FunClient_DemandMoney : SetProperty("MoneyNumber",needMoney);
	local nMoneyNow,nGold,nSilverCoin,nCopperCoin = Player:GetData("MONEY");
	Dress_Enchase_RightFrame_FunClient_SelfMoney:SetProperty("MoneyNumber", tostring(nMoneyNow));
	Dress_Enchase_RightFrame_FunClient_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))	
end

function Dress_Enchase_Buttons_Clicked()	
	local sCheck = Dress_Enchase_cost : GetProperty("Selected")
	if sCheck == 'True' then
		IsTip = 1		
	elseif sCheck == 'False' then
		IsTip = 0
	end
	
	if Dress_Cloth == -1 then
		PushDebugMessage("#{SZZH_170111_61}")
		return
	end
			
	local addGem={}
	addGem[1] = -1
	addGem[2] = -1
	addGem[3] = -1
	
	local addcnt = 0
	for i=1,3 do
		if Dress_GemIsNew[i] == 1 then
			addGem[i] = Dress_GemPos[i]
			addcnt = addcnt + 1
		end 
	end	
	
	if addcnt < 1 then
		PushDebugMessage("#{SZZH_170111_62}")
		return 
	end

	--��������Ѿ���������ť�ɵ��
	local Notify = 0	
	if (lastDress ~= Dress_Cloth or lastGem[1] ~=	addGem[1]
		or lastGem[2] ~=	addGem[2] or lastGem[3] ~=	addGem[3]) then
		lastDress = Dress_Cloth
		lastGem[1] =	addGem[1]
		lastGem[2] =	addGem[2]
		lastGem[3] =	addGem[3]
		Notify = 1;		
	end
	
	if( Notify == 1) then
		--�жϰ�
		local Dress_Bind = 0
		local Dress_Gem_Bind = 0
		if Dress_Cloth ~=-1 then
			Dress_Bind = Dress_Enchase_IsBind(Dress_Cloth)
		end
		for i=1,3 do
			if lastGem[i] ~= -1 then
				local nBind = Dress_Enchase_IsBind(lastGem[i])
				if nBind == 1 then
					Dress_Gem_Bind = 1
					break
				end
			end
		end
		
		--if(Dress_Bind == 1 or Dress_Gem_Bind == 1) then
			--DressEnchasing:Dress_EnchaseShowInfo("SZPR_XML_51")
			--return
		--else
			--DressEnchasing:Dress_EnchaseShowInfo("SZPR_XML_50")
			--return
		--end
	end
	local GemPos_ToServer = 0
	for i = 1,3 do
	    if addGem[i] ~= nil and addGem[i] >= 0 then
		    GemPos_ToServer = addGem[i]
		end
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("Cloth_Enchase");--XYJCall
		Set_XSCRIPT_ScriptID(900011);
		Set_XSCRIPT_Parameter(0,Dress_Cloth);
		Set_XSCRIPT_Parameter(1,GemPos_ToServer);
		Set_XSCRIPT_ParamCount(2);
	Send_XSCRIPT();
	Dress_Enchase_Clear() --�����ڷ����ˢ����
end

function Dress_Enchase_BuyDressFu()
	local addcnt = 0
	for i=1,3 do
		if Dress_GemIsNew[i] == 1 then
			addcnt = addcnt + 1
		end 
	end	
	
	if addcnt < 1 then
		PushDebugMessage("#{SZZH_170111_62}")
		return 
	end
	
--	Clear_XSCRIPT();
--		Set_XSCRIPT_Function_Name("BuyDressFu");
--		Set_XSCRIPT_ScriptID(830013);
--		Set_XSCRIPT_Parameter(0,addcnt);			
--		Set_XSCRIPT_ParamCount(1);
--	Send_XSCRIPT();	
end

-- function Dress_Enchase_TurnLeft(start)
	-- local mouse_button = CEArg:GetValue("MouseButton");
	-- if(mouse_button == "LeftButton") then
		-- --������ת��ʼ
		-- if(start == 1) then
			-- Dress_Enchase_LeftFrame_FakeObject:RotateBegin(-0.3);
		-- --������ת����
		-- else
			-- Dress_Enchase_LeftFrame_FakeObject:RotateEnd();
		-- end
	-- end
-- end

-- function Dress_Enchase_TurnRight(start)
	-- local mouse_button = CEArg:GetValue("MouseButton");
	-- if(mouse_button == "LeftButton") then
		-- --������ת��ʼ
		-- if(start == 1) then
			-- Dress_Enchase_LeftFrame_FakeObject:RotateBegin(0.3);
		-- --������ת����
		-- else
			-- Dress_Enchase_LeftFrame_FakeObject:RotateEnd();
		-- end
	-- end
-- end

function Dress_Enchase_Clicked()
--	local canPaint = DressReplaceColor:DressCanPaint(Dress_Cloth)
--	if canPaint ~= 1 then
--		PushDebugMessage("��ʱװ����Ⱦɫ�����ܲ鿴ͼ����")
--		return
--	end
--	DressReplaceColor :DressOpenDressJian(Dress_Cloth);
end

function Dress_EnchaseJian_Update()
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
--	Dress_Enchase_LeftFrame_Jian:Show()
--	Dress_Enchase_LeftFrame_Text:SetText(strdic)
end

function Dress_Enchase_CloseOtherWindows()
	if(IsWindowShow("Dress_Stiletto")) then
		CloseWindow("Dress_Stiletto", true);
	end			
	if(IsWindowShow("Dress_Transfer")) then
		CloseWindow("Dress_Transfer", true);
	end			
	if(IsWindowShow("Dress_SplitGem")) then
		CloseWindow("Dress_SplitGem", true);
	end				
end

function Dress_Enchase_FenYeClick(index)
	if index == 1 or index == 3 or index == 4 then
		Variable:SetVariable("DressClothPos", Dress_Enchase_Frame:GetProperty("UnifiedPosition"), 1);
		Variable:SetVariable("DressClothNPCID", g_objCared, 1);
		--PushEvent("OPEN_DRESSCLOTH",index)
		PushEvent("UI_COMMAND",201812181,index)	
	end
end

function Dress_Enchase_IsBind(ItemID)
	if(GetItemBindStatus(ItemID) == 1) then
		return 1;
	else
		return 0;
	end
end
