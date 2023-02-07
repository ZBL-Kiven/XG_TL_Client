
local g_nTheTabIndex = 0;
local PACKAGE_BUTTONS_NUM = 70;
local PACKAGE_BUTTONS = {};
local PACKAGE_TAB_TEXT = {};
local	LOCK_ICON = {};
local PACKAGE_EXTBAG_NUM = 10;
local PACKAGE_EXTBAG = {};
local PACKAGE_NUM_PER_LINE = 8--10;

local g_CurSelect			= -1;
local g_CurSelectPet	= -1;
local g_PetIndex = {};

local PET_MAX_NUMBER = 6+4	--最大珍兽携带上限(包括兽栏)--add by xindefeng

-- 界面的默认相对位置
local g_ItemCoffer_Frame_UnifiedXPosition;
local g_ItemCoffer_Frame_UnifiedYPosition;

--===============================================
-- PreLoad
--===============================================
function ItemCoffer_PreLoad()

	this:RegisterEvent("OPEN_ITEM_COFFER");
	this:RegisterEvent("PACKAGE_ITEM_CHANGED");
	
	this:RegisterEvent("UPDATE_ITEM_COFFER");
	this:RegisterEvent("UPDATE_PET_LIST");
	this:RegisterEvent("RESET_EXT_BAG");
	this:RegisterEvent("UI_COMMAND");

	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")

	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")

end

--===============================================
-- OnLoad
--===============================================
function ItemCoffer_OnLoad()

	PACKAGE_BUTTONS = {
		ItemCoffer_1, ItemCoffer_2, ItemCoffer_3, ItemCoffer_4, ItemCoffer_5, 
		ItemCoffer_6, ItemCoffer_7, ItemCoffer_8, ItemCoffer_9, ItemCoffer_10,
		ItemCoffer_11, ItemCoffer_12, ItemCoffer_13, ItemCoffer_14, ItemCoffer_15, 
		ItemCoffer_16, ItemCoffer_17, ItemCoffer_18, ItemCoffer_19, ItemCoffer_20,
		ItemCoffer_21, ItemCoffer_22, ItemCoffer_23, ItemCoffer_24, ItemCoffer_25, 
		ItemCoffer_26, ItemCoffer_27, ItemCoffer_28, ItemCoffer_29, ItemCoffer_30,
		ItemCoffer_31, ItemCoffer_32, ItemCoffer_33, ItemCoffer_34, ItemCoffer_35, 
		ItemCoffer_36, ItemCoffer_37, ItemCoffer_38, ItemCoffer_39, ItemCoffer_40,
		ItemCoffer_41, ItemCoffer_42, ItemCoffer_43, ItemCoffer_44, ItemCoffer_45, 
		ItemCoffer_46, ItemCoffer_47, ItemCoffer_48, ItemCoffer_49, ItemCoffer_50,
		ItemCoffer_51, ItemCoffer_52, ItemCoffer_53, ItemCoffer_54, ItemCoffer_55, 
		ItemCoffer_56, ItemCoffer_57, ItemCoffer_58, ItemCoffer_59, ItemCoffer_60,
		ItemCoffer_61, ItemCoffer_62, ItemCoffer_63, ItemCoffer_64, ItemCoffer_65, 
		ItemCoffer_66, ItemCoffer_67, ItemCoffer_68, ItemCoffer_69, ItemCoffer_70,
	}
	
	LOCK_ICON = {
		ItemCofferIcon_1, ItemCofferIcon_2, ItemCofferIcon_3, ItemCofferIcon_4, ItemCofferIcon_5,
		ItemCofferIcon_6, ItemCofferIcon_7, ItemCofferIcon_8, ItemCofferIcon_9, ItemCofferIcon_10,
		ItemCofferIcon_11, ItemCofferIcon_12, ItemCofferIcon_13, ItemCofferIcon_14, ItemCofferIcon_15,
		ItemCofferIcon_16, ItemCofferIcon_17, ItemCofferIcon_18, ItemCofferIcon_19, ItemCofferIcon_20,
		ItemCofferIcon_21, ItemCofferIcon_22, ItemCofferIcon_23, ItemCofferIcon_24, ItemCofferIcon_25,
		ItemCofferIcon_26, ItemCofferIcon_27, ItemCofferIcon_28, ItemCofferIcon_29, ItemCofferIcon_30,
		ItemCofferIcon_31, ItemCofferIcon_32, ItemCofferIcon_33, ItemCofferIcon_34, ItemCofferIcon_35,
		ItemCofferIcon_36, ItemCofferIcon_37, ItemCofferIcon_38, ItemCofferIcon_39, ItemCofferIcon_40,
		ItemCofferIcon_41, ItemCofferIcon_42, ItemCofferIcon_43, ItemCofferIcon_44, ItemCofferIcon_45,
		ItemCofferIcon_46, ItemCofferIcon_47, ItemCofferIcon_48, ItemCofferIcon_49, ItemCofferIcon_50,
		ItemCofferIcon_51, ItemCofferIcon_52, ItemCofferIcon_53, ItemCofferIcon_54, ItemCofferIcon_55,
		ItemCofferIcon_56, ItemCofferIcon_57, ItemCofferIcon_58, ItemCofferIcon_59, ItemCofferIcon_60,
		ItemCofferIcon_61, ItemCofferIcon_62, ItemCofferIcon_63, ItemCofferIcon_64, ItemCofferIcon_65,
		ItemCofferIcon_66, ItemCofferIcon_67, ItemCofferIcon_68, ItemCofferIcon_69, ItemCofferIcon_70,
	}
		
	PACKAGE_EXTBAG = {
		ItemCoffer_21, ItemCoffer_22, ItemCoffer_23, ItemCoffer_24, ItemCoffer_25, 
		ItemCoffer_26, ItemCoffer_27, ItemCoffer_28, ItemCoffer_29, ItemCoffer_30,
		ItemCoffer_31, ItemCoffer_32, ItemCoffer_33, ItemCoffer_34, ItemCoffer_35, 
		ItemCoffer_36, ItemCoffer_37, ItemCoffer_38, ItemCoffer_39, ItemCoffer_40,
		ItemCoffer_41, ItemCoffer_42, ItemCoffer_43, ItemCoffer_44, ItemCoffer_45, 
		ItemCoffer_46, ItemCoffer_47, ItemCoffer_48, ItemCoffer_49, ItemCoffer_50,
		ItemCoffer_51, ItemCoffer_52, ItemCoffer_53, ItemCoffer_54, ItemCoffer_55, 
		ItemCoffer_56, ItemCoffer_57, ItemCoffer_58, ItemCoffer_59, ItemCoffer_60,
		ItemCoffer_61, ItemCoffer_62, ItemCoffer_63, ItemCoffer_64, ItemCoffer_65, 
		ItemCoffer_66, ItemCoffer_67, ItemCoffer_68, ItemCoffer_69, ItemCoffer_70,
	}
	
	PACKAGE_TAB_TEXT = {
		[0] = "道具",
		"材料",
		"珍兽",
	};
	
	-- 保存界面的默认相对位置
	g_ItemCoffer_Frame_UnifiedXPosition	= ItemCoffer_Frame : GetProperty("UnifiedXPosition");
	g_ItemCoffer_Frame_UnifiedYPosition	= ItemCoffer_Frame : GetProperty("UnifiedYPosition");

end

--===============================================
-- OnEvent
--===============================================
function ItemCoffer_OnEvent(event)

	if ( event == "OPEN_ITEM_COFFER" )         then
		this:Show();
		g_nTheTabIndex = tonumber(arg0);
		g_CurSelect = -1;
		ItemCoffer_UpdateFrame(g_nTheTabIndex);
		
	elseif ( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible()) then
		ItemCoffer_UpdateFrame(g_nTheTabIndex);
		
	elseif ( event == "UPDATE_ITEM_COFFER" )   then
		ItemCoffer_UpdateFrame(g_nTheTabIndex);
		
	elseif ( event == "UPDATE_PET_LIST" )   then
		ItemCoffer_UpdateFrame(g_nTheTabIndex);

	elseif ( event == "RESET_EXT_BAG" ) then
		ItemCoffer_UpdateFrame(g_nTheTabIndex);
		
	elseif ( event == "UI_COMMAND" ) then
		if ( tonumber(arg0) == 5421 ) then
			this:Show();
			g_nTheTabIndex = tonumber(0);
			g_CurSelect = -1;
			ItemCoffer_UpdateFrame(g_nTheTabIndex);
		end

	-- 游戏窗口尺寸发生了变化
	elseif (event == "ADJEST_UI_POS" ) then
		-- 更新背包界面位置
		ItemCoffer_Frame_On_ResetPos()

	-- 游戏分辨率发生了变化
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		-- 更新背包界面位置	
		ItemCoffer_Frame_On_ResetPos()
	end
	
end

--===============================================
-- OnEvent
--===============================================
function ItemCoffer_UpdateFrame(nIndex)


	--先隐藏所有锁定图标
	for i=1 ,PACKAGE_BUTTONS_NUM   do
		LOCK_ICON[i]:Hide();
		PACKAGE_BUTTONS[i]:Hide();
	end

	local i=1;
	local szPacketName = "";
	local CurrNum = 20;
	local BaseNum = 20;
	local MaxNum = 10;

	ItemCoffer_PetList:Hide();
	ItemCoffer_Set:Hide();
	if(nIndex == 0) then
		CurrNum = DataPool:GetBaseBag_Num();
		BaseNum = DataPool:GetBaseBag_BaseNum();
		MaxNum = DataPool:GetBaseBag_MaxNum();
		ItemCoffer_Check_Material:SetCheck(1);
		szPacketName = "base";
		-- PushDebugMessage("MaxNum  "..MaxNum)
		for i=1 ,BaseNum  do
			PACKAGE_BUTTONS[i]:Show();
		end
		i = 1;
		while i <= CurrNum-BaseNum do
			PACKAGE_EXTBAG[i]:Show();
			PACKAGE_BUTTONS[BaseNum+i]:Enable();
			PACKAGE_BUTTONS[BaseNum+i]:Show();
			i = i + 1;
		end
		i = CurrNum-BaseNum+1;
		while i <= MaxNum-BaseNum do
			PACKAGE_EXTBAG[i]:Hide();
			PACKAGE_BUTTONS[BaseNum+i]:Hide();
			PACKAGE_BUTTONS[BaseNum+i]:Disable();
			i = i + 1;
		end
		ItemCoffer_Set:Show();
		ItemCoffer_UpDateItem(szPacketName);
		
	elseif(nIndex == 1) then
		CurrNum = DataPool:GetMatBag_Num();
		BaseNum = DataPool:GetMatBag_BaseNum();
		MaxNum = DataPool:GetMatBag_MaxNum();

		ItemCoffer_Check_Stall:SetCheck(1);
		szPacketName = "material";
		
		for i=1 ,BaseNum  do
			PACKAGE_BUTTONS[i]:Show();
		end
		i = 1;
		while i <= CurrNum-BaseNum do
			PACKAGE_EXTBAG[i]:Show();
			PACKAGE_BUTTONS[BaseNum+i]:Enable();
			PACKAGE_BUTTONS[BaseNum+i]:Show();
			i = i + 1;
		end
		i = CurrNum-BaseNum+1;
		while i <= MaxNum-BaseNum do
			PACKAGE_EXTBAG[i]:Hide();
			PACKAGE_BUTTONS[BaseNum+i]:Hide();
			PACKAGE_BUTTONS[BaseNum+i]:Disable();
			i = i + 1;
		end
		ItemCoffer_Set:Show();
		ItemCoffer_UpDateItem(szPacketName);
		
	elseif(nIndex == 2) then

		ItemCoffer_Check_Pet:SetCheck(1);
		szPacketName = "pet";
		
		for i=1 ,PACKAGE_BUTTONS_NUM  do
			PACKAGE_BUTTONS[i]:Hide();
		end
		ItemCoffer_PetList:Show();
		ItemCoffer_UpDatePet();
		
	end
	
	ItemCoffer_UpdateRect( CurrNum );
end

function ItemCoffer_UpdateRect( currNum )
	local offset = 55;
	local buttonHeight = 45;
	local itemHeight = 38;
	local nLine = math.floor( currNum / PACKAGE_NUM_PER_LINE );
	if( nLine * PACKAGE_NUM_PER_LINE < currNum ) then
		nLine = nLine + 1;
	end
	ItemCoffer_Frame:SetProperty( "AbsoluteHeight",nLine * itemHeight + offset + buttonHeight );
		
	
end
--===============================================
-- 更新物品
--===============================================
function ItemCoffer_UpDateItem(szPacketName)

	local i=1;
	while i<=PACKAGE_BUTTONS_NUM do
		local theAction,bLocked,bProtect,nUnlockElapsedTime = PlayerPackage:EnumItem(szPacketName, i-1);

		if theAction:GetID() ~= 0 then
			PACKAGE_BUTTONS[i]:SetActionItem(theAction:GetID());
			if( g_CurSelect == i )   then 
				PACKAGE_BUTTONS[i]:SetPushed(1);
			else
				PACKAGE_BUTTONS[i]:SetPushed(0);
			end
		else
			PACKAGE_BUTTONS[i]:SetActionItem(-1);
		end
		
		if bLocked == 1 then
			PACKAGE_BUTTONS[i]:Disable();
		else
			PACKAGE_BUTTONS[i]:Enable();
		end
		
		if( bProtect == 1 )   then
			LOCK_ICON[i]:Show();
			
			if( nUnlockElapsedTime == 0 ) then
				LOCK_ICON[i]:SetProperty("Image","set:UIIcons image:Icon_Lock");
			else
				LOCK_ICON[i]:SetProperty("Image","set:CommonFrame6 image:NewLock");
			end
		end

		i = i+1;
	end
end

--===============================================
-- 更新珍兽
--===============================================
function ItemCoffer_UpDatePet()

	ItemCoffer_PetList:ClearListBox();
	local nPetCount = Pet:GetPet_Count();
	local PetInListIndex = 0;

	for	i=1, PET_MAX_NUMBER do	--modify by xindefeng
		local szPetName,szOn = Pet:GetPetList_Appoint(i-1);
		local strToolTips = "";
		if(szPetName ~= "")   then
			if string.find(szPetName,"#") ~= nil then
				szPetName = string_name(szPetName)
			end
			if( szOn ~= "on_packa" )  then 
				szPetName = "#c808080" .. szPetName;
			end
			if(PlayerPackage:IsPetLock(i-1) == 1)    then
				local nUnlockElapsedTime = PlayerPackage:GetPUnlockElapsedTime_Pet(i-1);
				if( nUnlockElapsedTime == 0 ) then
					szPetName = szPetName.. "  #-05";
					
					strToolTips =  "已加锁" ;
				else
					szPetName = szPetName.. "  #-10";
					
					local strLeftTime = g_GetUnlockingStr(nUnlockElapsedTime);			
					strToolTips = strLeftTime ;
				end
			end
		
			ItemCoffer_PetList:AddItem(szPetName, PetInListIndex);
			
			ItemCoffer_PetList:SetItemTooltip( PetInListIndex, strToolTips );
			
			g_PetIndex[PetInListIndex] = i-1;
			PetInListIndex = PetInListIndex + 1 ;
		end	
	end
end


--===============================================
-- 选中珍兽
--===============================================
function ItemCoffer_ListSelected()
	
end

--===============================================
-- 右键选中珍兽
--===============================================
function ItemCoffer_ShowTargetPet()
	local nIndex = ItemCoffer_PetList:GetFirstSelectItem();

	if( -1 == nIndex ) then
		return;
	end
	Pet:ShowTargetPet(g_PetIndex[nIndex]);
end

--===============================================
-- 换页
--===============================================
function ItemCoffer_Check_ChangeTabIndex(nIndex)
	PlayerPackage:OpenLockFrame(nIndex);
end

--===============================================
-- 加锁
--===============================================
function ItemCoffer_Lock_Clicked()

	if( g_nTheTabIndex == 2 )  then  -- 珍兽界面
		local nPetIndex = ItemCoffer_PetList:GetFirstSelectItem();
		if(nPetIndex == -1)  then
			PlayerPackage:Lock("lock", "pet", -1);
		else
			PlayerPackage:Lock("lock", "pet", g_PetIndex[nPetIndex]);
		end
		
	else
		if( g_CurSelect == -1 )  then 
			PlayerPackage:Lock("lock", "item", -1);
		else
			PlayerPackage:Lock("lock", "item", g_nTheTabIndex*DataPool:GetBaseBag_MaxNum() + g_CurSelect-1);
		end
	end
	
end

--===============================================
-- 解锁
--===============================================
function ItemCoffer_Unlock_Clicked()

	if( g_nTheTabIndex == 2 )  then  -- 珍兽界面
		local nPetIndex = ItemCoffer_PetList:GetFirstSelectItem();
		if(nPetIndex == -1)  then
			PlayerPackage:Lock("unlock", "pet", -1);
		else
			PlayerPackage:Lock("unlock", "pet", g_PetIndex[nPetIndex]);
		end
		
	else
		if( g_CurSelect == -1 )  then 
			PlayerPackage:Lock("unlock", "item", -1);
		else
			PlayerPackage:Lock("unlock", "item", g_nTheTabIndex*DataPool:GetBaseBag_MaxNum() + g_CurSelect-1);
		end
	end
	
end

--===============================================
-- 选中物品
--===============================================
function ItemCofferClicked(nIndex)
	g_CurSelect = nIndex;
	ItemCoffer_UpdateFrame(g_nTheTabIndex)
end

--================================================
-- 恢复界面的默认相对位置
--================================================
function ItemCoffer_Frame_On_ResetPos()

	ItemCoffer_Frame : SetProperty("UnifiedXPosition", g_ItemCoffer_Frame_UnifiedXPosition);
	ItemCoffer_Frame : SetProperty("UnifiedYPosition", g_ItemCoffer_Frame_UnifiedYPosition);

end
