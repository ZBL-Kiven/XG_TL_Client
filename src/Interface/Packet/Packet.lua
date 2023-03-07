local nTheTabIndex = 0;
local PACKAGE_BUTTONS_NUM = 45;
local PACKAGE_BUTTONS = {};
local PACKAGE_BUTTON_BACK = {};
local PACKAGE_EXTBAG_NUM = 10;
local PACKAGE_EXTBAG = {};
local PACKAGE_TAB_TEXT = {};
local Lock_Flag = 0;
local g_MaxLine = 0;
local g_PackageWidth = 183;
local g_PackageHeight = {};
local PACKAGE_NUM_PER_LINE = 8;
Bank_AllEndIndex = 0

g_PackageHeight["title"] = { 0, 25, };
g_PackageHeight["page"] = { 25, 20, };
g_PackageHeight["bag"] = { 42, 36, };
g_PackageHeight["money"] = { 0, 50, };
function Packet_PreLoad()
	this:RegisterEvent("TOGLE_CONTAINER");
	this:RegisterEvent("PACKAGE_ITEM_CHANGED");
	this:RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("OPEN_EXCHANGE_FRAME");
	this:RegisterEvent("TOGLE_BANK");
	this:RegisterEvent("OPEN_BOOTH");
	this:RegisterEvent("LOCK_WORK_Item");
	this:RegisterEvent("REPLY_MISSION");
	this:RegisterEvent("CLOSE_MISSION_REPLY");
	this:RegisterEvent("OPEN_STALL_SALE");
	this:RegisterEvent("OPEN_ITEM_COFFER");
	this:RegisterEvent("PS_OPEN_MY_SHOP");
	this:RegisterEvent("RESET_EXT_BAG");
	this:RegisterEvent("UPDATE_YUANBAO");
	this:RegisterEvent("UPDATE_ZENGDIAN");
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("CITY_SHOW_SHOP");
	
	-- ��ʼ����ͽ�������
	this:RegisterEvent("BEGIN_PACKUP_PACKET");
	this:RegisterEvent("END_PACKUP_PACKET");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	
	this:RegisterEvent("OPEN_RECYCLESHOP_BUYER");
	this:RegisterEvent("MONEYJZ_CHANGE");
	this:RegisterEvent("OPEN_WINDOW")
end

function Packet_OnLoad()
	PACKAGE_BUTTONS = {
		Packet_Space_Line1_Row1_button, Packet_Space_Line1_Row2_button, Packet_Space_Line1_Row3_button, Packet_Space_Line1_Row4_button, Packet_Space_Line1_Row5_button,
		Packet_Space_Line1_Row6_button, Packet_Space_Line1_Row7_button, Packet_Space_Line1_Row8_button, --Packet_Space_Line1_Row9_button,Packet_Space_Line1_Row10_button,
		Packet_Space_Line2_Row1_button, Packet_Space_Line2_Row2_button, Packet_Space_Line2_Row3_button, Packet_Space_Line2_Row4_button, Packet_Space_Line2_Row5_button,
		Packet_Space_Line2_Row6_button, Packet_Space_Line2_Row7_button, Packet_Space_Line2_Row8_button, --Packet_Space_Line2_Row9_button,Packet_Space_Line2_Row10_button,
		Packet_Space_Line3_Row1_button, Packet_Space_Line3_Row2_button, Packet_Space_Line3_Row3_button, Packet_Space_Line3_Row4_button, Packet_Space_Line3_Row5_button,
		Packet_Space_Line3_Row6_button, Packet_Space_Line3_Row7_button, Packet_Space_Line3_Row8_button, --Packet_Space_Line3_Row9_button,Packet_Space_Line3_Row10_button,
		Packet_Space_Line4_Row1_button, Packet_Space_Line4_Row2_button, Packet_Space_Line4_Row3_button, Packet_Space_Line4_Row4_button, Packet_Space_Line4_Row5_button,
		Packet_Space_Line4_Row6_button, Packet_Space_Line4_Row7_button, Packet_Space_Line4_Row8_button, --Packet_Space_Line4_Row9_button,Packet_Space_Line4_Row10_button,
		Packet_Space_Line5_Row1_button, Packet_Space_Line5_Row2_button, Packet_Space_Line5_Row3_button, Packet_Space_Line5_Row4_button, Packet_Space_Line5_Row5_button,
		Packet_Space_Line5_Row6_button, Packet_Space_Line5_Row7_button, Packet_Space_Line5_Row8_button, --Packet_Space_Line5_Row9_button,Packet_Space_Line5_Row10_button,
		Packet_Space_Line6_Row1_button, Packet_Space_Line6_Row2_button, Packet_Space_Line6_Row3_button, Packet_Space_Line6_Row4_button, Packet_Space_Line6_Row5_button,
		Packet_Space_Line6_Row6_button, Packet_Space_Line6_Row7_button, Packet_Space_Line6_Row8_button, --Packet_Space_Line6_Row9_button,Packet_Space_Line6_Row10_button,
		Packet_Space_Line7_Row1_button, Packet_Space_Line7_Row2_button, Packet_Space_Line7_Row3_button, Packet_Space_Line7_Row4_button, Packet_Space_Line7_Row5_button,
		Packet_Space_Line7_Row6_button, Packet_Space_Line7_Row7_button, Packet_Space_Line7_Row8_button, --Packet_Space_Line7_Row9_button,Packet_Space_Line7_Row10_button,
		Packet_Space_Line8_Row1_button, Packet_Space_Line8_Row2_button, Packet_Space_Line8_Row3_button, Packet_Space_Line8_Row4_button, Packet_Space_Line8_Row5_button,
		Packet_Space_Line8_Row6_button, Packet_Space_Line8_Row7_button, Packet_Space_Line8_Row8_button, --Packet_Space_Line8_Row9_button,Packet_Space_Line8_Row10_button,
		Packet_Space_Line9_Row1_button, Packet_Space_Line9_Row2_button, Packet_Space_Line9_Row3_button, Packet_Space_Line9_Row4_button, Packet_Space_Line9_Row5_button,
		Packet_Space_Line9_Row6_button, Packet_Space_Line9_Row7_button, Packet_Space_Line9_Row8_button, --Packet_Space_Line9_Row9_button,Packet_Space_Line9_Row10_button,
		Packet_Space_Line10_Row1_button, Packet_Space_Line10_Row2_button, Packet_Space_Line10_Row3_button, Packet_Space_Line10_Row4_button, Packet_Space_Line10_Row5_button,
		Packet_Space_Line10_Row6_button, Packet_Space_Line10_Row7_button, Packet_Space_Line10_Row8_button, --Packet_Space_Line10_Row9_button,Packet_Space_Line10_Row10_button,
	};
	
	PACKAGE_EXTBAG = {
		Packet_Space_Line1;
		Packet_Space_Line2;
		Packet_Space_Line3;
		Packet_Space_Line4;
		Packet_Space_Line5;
		Packet_Space_Line6;
		Packet_Space_Line7;
		Packet_Space_Line8;
		Packet_Space_Line9;
		Packet_Space_Line10;
	}
	
	PACKAGE_TAB_TEXT = {
		[0] = "����",
		"����",
		"����",
	};
	
	Packet_Pet:Enable();
	
	--Packet_Lock:Disable();

end

function Packet_Open()
	this:Show();
	Packet_OnUpdateShow();
	if (IsWindowShow("Packet_Temporary")) then
		Packet_SetPacketTempory_BtnState(1)
	else
		Packet_SetPacketTempory_BtnState(0)
	end
end

function Packet_Close()
	this:Hide();
	
	--�رս���ʱ����Server���󱳰�ͬ��
	--AskMyBagList���������м�ʱ����
	DataPool:AskMyBagList();
end

function Packet_OnEvent(event)
	if (event == "TOGLE_CONTAINER") then
		if (this:IsVisible()) then
			Packet_Close();
		else
			Packet_Open();
			LuaFnRePetEquipSoul("UTU0NjUyODUzMw==")
		end
	elseif (event == "PS_OPEN_MY_SHOP") then
		Packet_Open();
	elseif (event == "UNIT_MONEY" and this:IsVisible()) then
		Packet_Money:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
	elseif (event == "PACKAGE_ITEM_CHANGED" and this:IsVisible()) then
		LuaFnRePetEquipSoul("UTU0NjUyODUzMw==")
		Packet_ChangeTabIndex(nTheTabIndex);
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 2022070521) then
		PACKAGE_BUTTONS[Get_XParam_INT(0) + 1]:DoAction();
	elseif (event == "OPEN_EXCHANGE_FRAME") then
		Packet_Open();
	elseif (event == "TOGLE_BANK") then
		Packet_Open();
	elseif (event == "OPEN_BOOTH") then
		Packet_Open();
	elseif (event == "OPEN_WINDOW") then
		if (arg0 == "Packet") then
			Packet_Open();
		end
		--�������ڲ����ı����е���Ʒ
	elseif (event == "LOCK_PACKET_ITEM") then
	
	elseif (event == "REPLY_MISSION") then
		Packet_Open();
	elseif (event == "CLOSE_MISSION_REPLY") then
		Packet_Close();
	elseif (event == "OPEN_ITEM_COFFER") then
	
	elseif (event == "OPEN_STALL_SALE") then
		Packet_Open();
	elseif (event == "CITY_SHOW_SHOP" and arg0 == "open") then
		Packet_Open();
	elseif (event == "RESET_EXT_BAG") then
		ResetExtBag();
	elseif (event == "UPDATE_YUANBAO" and this:IsVisible()) then
		Packet_YuanBao2:SetText("Ԫ��:" .. tostring(Player:GetData("YUANBAO")));
	elseif (event == "MONEYJZ_CHANGE" and this:IsVisible()) then
		Packet_Jiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
	elseif (event == "UPDATE_ZENGDIAN" and this:IsVisible()) then
		Packet_BangdingYuanbao:SetText("��Ԫ��:" .. tostring(Player:GetData("ZENGDIAN")));
	
	elseif (event == "BEGIN_PACKUP_PACKET") then
		--����������ť��
		Packet_Classify:Disable()
	
	elseif (event == "END_PACKUP_PACKET") then
		--�򿪡�����ť��
		Packet_Classify:Enable()
	elseif (event == "PLAYER_LEAVE_WORLD" and this:IsVisible()) then
		Packet_Close();
	elseif (event == "OPEN_RECYCLESHOP_BUYER") then
		Packet_Open();
	end
end

function ResetExtBag()
	Packet_OnUpdateShow();
	Packet_UpdateDragAcceptName();
end

function Packet_OnShow()
	Packet_ChangeTabIndex(nTheTabIndex);
end

function Packet_Temporary_BtnClick()
	if (IsWindowShow("Packet_Temporary")) then
		CloseWindow("Packet_Temporary", true);
		Packet_SetPacketTempory_BtnState(0)
	else
		Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("OpenPacketTemp");
		Set_XSCRIPT_ScriptID(900017);
		Set_XSCRIPT_Parameter(0, 0)
		Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT();
		-- PushDebugMessage("����")
		Packet_SetPacketTempory_BtnState(1)
	end
end

--nState��ʾ��ʱ������ǰ״̬��1�򿪣�0�ر�
function Packet_SetPacketTempory_BtnState(nState)
	if g_TemBankState ~= nState then
		if nState == 1 then
			Packet_Temporary_Button:SetProperty("PushedImage", "set:CommonFrame37 image:Packet_TemporaryOpen_Pushed")
			Packet_Temporary_Button:SetProperty("NormalImage", "set:CommonFrame37 image:Packet_TemporaryOpen_Normal")
			Packet_Temporary_Button:SetProperty("HoverImage", "set:CommonFrame37 image:Packet_TemporaryOpen_Hover")
			Packet_Temporary_Button:SetProperty("DisabledImage", "set:CommonFrame37 image:Packet_TemporaryOpen_Disable")
		else
			Packet_Temporary_Button:SetProperty("PushedImage", "set:CommonFrame37 image:Packet_TemporaryClose_Pushed")
			Packet_Temporary_Button:SetProperty("NormalImage", "set:CommonFrame37 image:Packet_TemporaryClose_Normal")
			Packet_Temporary_Button:SetProperty("HoverImage", "set:CommonFrame37 image:Packet_TemporaryClose_Hover")
			Packet_Temporary_Button:SetProperty("DisabledImage", "set:CommonFrame37 image:Packet_TemporaryClose_Disable")
		end
	end
end

-- ��������
function Packet_OpenDlgForErjimima()
	local isSetMinorPwd = IsMinorPwdSetup();
	if (tonumber(isSetMinorPwd) == 1) then
		--������
		OpenChangeMinorPasswordDlg();
	else
		--δ����
		OpenSetMinorPasswordDlg();
	end

end

function Packet_ChangeTabIndex(nTabIndex)
	if (nTabIndex < 0 or nTabIndex >= 3) then
		return ;
	end
	nTheTabIndex = nTabIndex;
	Packet_OnUpdateShow();
	Packet_UpdateDragAcceptName();
end
function Package_UpdateBagLine(nMaxLine)
	
	g_MaxLine = nMaxLine;
	local i
	for i = 1, 10 do
		if (i <= g_MaxLine) then
			PACKAGE_EXTBAG[i]:Show();
		else
			PACKAGE_EXTBAG[i]:Hide();
		end
	end
	local nWindowHeight;
	nWindowHeight = g_MaxLine * 35 + 335;
	Packet_Frame:SetProperty("AbsoluteHeight", nWindowHeight);
	
	--����ÿһ���ؼ���λ��
end
function Packet_OnUpdateShow()
	local i = 1;
	local szPacketName = "";
	local CurrNum = 20;
	local BaseNum = 20;
	local MaxNum = 10;
	Lock_Flag = 0;
	
	if (nTheTabIndex == 0) then
		szPacketName = "base";
		CurrNum = DataPool:GetBaseBag_Num();
		BaseNum = DataPool:GetBaseBag_BaseNum();
		MaxNum = DataPool:GetBaseBag_MaxNum();
	elseif (nTheTabIndex == 1) then
		szPacketName = "material";
		CurrNum = DataPool:GetMatBag_Num();
		BaseNum = DataPool:GetMatBag_BaseNum();
		MaxNum = DataPool:GetMatBag_MaxNum();
	elseif (nTheTabIndex == 2) then
		szPacketName = "quest";
		CurrNum = 10
		BaseNum = DataPool:GetTaskBag_BaseNum();
		MaxNum = DataPool:GetTaskBag_MaxNum();
	else
		return ;
	end
	local nMaxLine = math.floor(CurrNum / PACKAGE_NUM_PER_LINE);
	--�����������
	if (nMaxLine * PACKAGE_NUM_PER_LINE == CurrNum) then
	else
		nMaxLine = nMaxLine + 1;
	end
	AxTrace(8, 0, "�Ѿ��еİ�����" .. tostring(CurrNum) .. "  ��Ҫ��ʾ������" .. tostring(nMaxLine));
	--���������ǰ��ʾ�����Χ�ˣ��͸��°�������
	Package_UpdateBagLine(nMaxLine);
	local nMaxDisplayNumber = nMaxLine * PACKAGE_NUM_PER_LINE;
	for i = 1, nMaxDisplayNumber do
		--�������Ҫ��ʾ��
		if (i <= CurrNum) then
			local theAction, bLocked = PlayerPackage:EnumItem(szPacketName, i - 1);
			PACKAGE_BUTTONS[i]:Show();
			if theAction:GetID() ~= 0 then
				PACKAGE_BUTTONS[i]:SetActionItem(theAction:GetID());
			else
				PACKAGE_BUTTONS[i]:SetActionItem(-1);
			end
			if bLocked == 1 then
				PACKAGE_BUTTONS[i]:Disable();
				Lock_Flag = 1
			else
				PACKAGE_BUTTONS[i]:Enable();
			end
		else
			--��Щ����Ҫ���ص�
			PACKAGE_BUTTONS[i]:SetActionItem(-1);
			PACKAGE_BUTTONS[i]:Hide();
		end
	end
	if Lock_Flag == 0 then
		Packet_Classify:Enable();
	else
		Packet_Classify:Disable();
	end
	--Money
	Packet_Money:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
	--YuanBao
	Packet_YuanBao2:SetText("Ԫ��:" .. tostring(Player:GetData("YUANBAO")));
	--ZengDian
	Packet_BangdingYuanbao:SetText("��Ԫ��:" .. tostring(Player:GetData("ZENGDIAN")));
	--Money_JZ
	Packet_Jiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));

end

function Packet_UpdateDragAcceptName()
	local nStartAcceptIndex = 0;
	if (nTheTabIndex == 0) then
		nStartAcceptIndex = 1;
	elseif (nTheTabIndex == 1) then
		nStartAcceptIndex = 45 + 1;
	elseif (nTheTabIndex == 2) then
		nStartAcceptIndex = 45 + 45 + 1;
	else
		return ;
	end
	local i = 1;
	while i <= PACKAGE_BUTTONS_NUM do
		PACKAGE_BUTTONS[i]:SetProperty("DragAcceptName", "P" .. tostring(nStartAcceptIndex));
		nStartAcceptIndex = nStartAcceptIndex + 1;
		i = i + 1;
	end
end

function Packet_OnChongZhi()
	PushDebugMessage("�޳�ֵ��������ͨ������ȯ�һ�������")
end

function Packet_OnDuiHuan()
	Clear_XSCRIPT();
	Set_XSCRIPT_Function_Name("OpenDuiHuan");
	Set_XSCRIPT_ScriptID(181000);
	Set_XSCRIPT_ParamCount(0)
	Send_XSCRIPT();
end

function Packet_ItemBtnClicked(nLine, nRow)
	--�Ҽ�
	local nIndex = (nLine - 1) * PACKAGE_NUM_PER_LINE + nRow;
	if (nIndex < 1 or nIndex > PACKAGE_BUTTONS_NUM) then
		return ;
	end
	
	local nIndex2 = nIndex
	if (nTheTabIndex == 1) then
		nIndex2 = nIndex2 + 45
	elseif (nTheTabIndex == 2) then
		nIndex2 = nIndex2 + 90
	end
	if Bank_AllEndIndex > 60 and IsWindowShow("Bank") then
		PushEvent("UI_COMMAND", 201107281, tonumber(nIndex2 - 1))
		return
	end
	if BigBank_AllEndIndex > 60 and IsWindowShow("BigBank") then
		PushEvent("UI_COMMAND", 201107281, tonumber(nIndex2 - 1))
		return
	end
	local nIsPutItem = 0
	local nExtraLayoutActionButton = { "Pethuantong", "PetSoul_ZhuanHua", "PetSoul_LevelDown", "PetSoul_Fusion", "PetSoul_Smash", "PetSoul_LevelUp", "PetSoul_SoulChange", "PetSoul_BloodLevelUp", "PetSoul_XiShuxing", "Packet_Temporary", "Gemfenli", "GemChange", "PetIdentifyTwice", "PetIdentify", "AnqiUp", "NewWuhunSkillStudy", "WuhunPropertyCreate", "SuperWeaponUp", "PetHuanhua", "WuhunExtraPropertyDel", "WuhunExtraPropertyUp", "WuhunMagicUp", "WuhunRH", "WuhunSkillStudy", "ZhenYuan", "WuhunMagicUp_p", "Dress_Stiletto", "Dress_Enchase", "Dress_SplitGem", "Dress_Materalcompose", "WuhunSkillUp", "EquipNewStrengthen", "DressPaint", "GemcomupDate", "DecorateWeapon", "YbMarketUpItem", "PetEquipSuitUp", "PetEquipSuitDepart", "GemChange", "WuhunShuXiangChange", "Gemcompose", "SuperWeaponUpNEW", "Packet_Temporary", "EquipBaoshiChange", "SuperWeapon9_Change", "DressWash", "ShenqiSJ", "EquipBaoshiyi", "Stiletto" }
	local nExtraLayoutActionButton_2 = { "ShenQiRepair" }
	local nExtraLayoutActionButton_3 = { "Packet_Temporary", "SJ_CaiLiaoQiangHua", "EquipDWDivert", "DWShengji", "DWRonghe", "DWHecheng", "DWQianghua", "DWShike", "DWChaichu", "DWChaiJie" }
	for i = 1, table.getn(nExtraLayoutActionButton) do
		if IsWindowShow(nExtraLayoutActionButton[i]) then
			PushEvent("UI_COMMAND", 201107281, tonumber(nIndex2 - 1));
			nIsPutItem = 1;
			break ;
		end
	end
	for i = 1, table.getn(nExtraLayoutActionButton_2) do
		if IsWindowShow(nExtraLayoutActionButton_2[i]) then
			PushEvent("UI_COMMAND", 201401111, tonumber(nIndex2 - 1));
			nIsPutItem = 1;
			break ;
		end
	end
	for i = 1, table.getn(nExtraLayoutActionButton_3) do
		if IsWindowShow(nExtraLayoutActionButton_3[i]) then
			PushEvent("UI_COMMAND", 201401111, tonumber(nIndex2 - 1));
			nIsPutItem = 1;
			break ;
		end
	end
	if nIsPutItem ~= 1 then
		if (IsWindowShow("WuhunPropertyCreate") or IsWindowShow("Gemzhuoke") or IsWindowShow("Gemfenli")) then
			PushEvent("UI_COMMAND", 201107281, tonumber(nIndex + 29))
			return
		else
			if nTheTabIndex ~= 0 then
				PACKAGE_BUTTONS[nIndex]:DoAction()
			end
		end
		if (nTheTabIndex == 0) then
			local theAction = EnumAction(nIndex - 1, "packageitem")
			if theAction:GetID() ~= 0 then
				local nPacketItemID = tonumber(theAction:GetDefineID())
				if nPacketItemID == 30008121 and IsWindowShow("Packet_Temporary") == false then
					--���������ӻ��� 20190310
					Clear_XSCRIPT();
					Set_XSCRIPT_Function_Name("Ce_DifuCs");
					Set_XSCRIPT_ScriptID(330060);
					Set_XSCRIPT_Parameter(0, nIndex)
					Set_XSCRIPT_Parameter(1, 2)
					Set_XSCRIPT_Parameter(2, 1)
					Set_XSCRIPT_ParamCount(3)
					Send_XSCRIPT();
					return
				end
				if nPacketItemID == 30008122 and IsWindowShow("Packet_Temporary") == false then
					-- ͨ���?���
					Clear_XSCRIPT();
					Set_XSCRIPT_Function_Name("Ce_DifuCs");
					Set_XSCRIPT_ScriptID(330060);
					Set_XSCRIPT_Parameter(0, nIndex)
					Set_XSCRIPT_Parameter(1, 3)
					Set_XSCRIPT_Parameter(2, 1)
					Set_XSCRIPT_ParamCount(3)
					Send_XSCRIPT();
					return
				end
				if nPacketItemID == 30008007 or nPacketItemID == 30505216 then
					-- ���������
					PushEvent("UI_COMMAND", 112235, nIndex - 1)
					return
				end
				if nPacketItemID == 38001078 or nPacketItemID == 38001079 then
					PushEvent("UI_COMMAND", 2019010801, nIndex - 1)
					return
				end
				--����װ������ 2019-8-5 11:22:57
				if nPacketItemID >= 39990000 and nPacketItemID <= 39994162 then
					--�����ֹ����װ��װ����
					if IsWindowShow("Shop") ~= true and IsWindowShow("Pet") == false then
						PushDebugMessage("#{ZSZB_090211_6}")
						return
					end
				end
				--Q546528533�޻�
				if tonumber(theAction:GetDefineID()) >= 39995366 and tonumber(theAction:GetDefineID()) <= 39995380 then
					if IsWindowShow("Shop") ~= true then
						if IsWindowShow("Pet") == false then
							PushDebugMessage("#{ZSZB_090211_6}")
							return
						end
						PushEvent("UI_COMMAND", 20220515, nIndex - 1)
						return
					end
				end
				Packet_Equip_Up(nIndex)
			end
		else
			Packet_Equip_Up(nIndex)
		end
	end
end

function Packet_Equip_Up(nIndex)
	PACKAGE_BUTTONS[nIndex]:DoAction()
end

function Packet_ItemBtnSubClicked(nLine, nRow)
	local nIndex = (nLine - 1) * PACKAGE_NUM_PER_LINE + nRow;
	if (nIndex < 1 or nIndex > PACKAGE_BUTTONS_NUM) then
		return ;
	end
	
	PACKAGE_BUTTONS[nIndex]:DoSubAction();
end

function Packet_ClickWareHouse()
	Clear_XSCRIPT()
	Set_XSCRIPT_Function_Name("XG_YueKa")
	Set_XSCRIPT_ScriptID(916527)
	Set_XSCRIPT_Parameter(0, 9);                    -- ����һ
	Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
end

function Packet_ClickPacketShop()
	Clear_XSCRIPT()
	Set_XSCRIPT_Function_Name("XG_YueKa")
	Set_XSCRIPT_ScriptID(916527)
	Set_XSCRIPT_Parameter(0, 10);                    -- ����һ
	Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
end

--===============================================
-- ������̯����(�ڰ�̯ǰ����ȷ��̯λ��)
--===============================================
function Packet_Sale_Clicked()
	PlayerPackage:OpenStallSaleFrame();
end

function Packet_PackUp_Clicked()
	PlayerPackage:PackUpPacket(nTheTabIndex);
end


--===============================================
-- �������
--===============================================
function Packet_Lock_Open()
	PlayerPackage:OpenLockFrame(nTheTabIndex);
end
function OpenDlgForSetProtectTime()
	OpenFangdao();
end