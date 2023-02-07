
local ITEM_BUTTONS_NUM = 18;       --һҳ��Ʒ��ť���� 
local ITEM_MULTIPLELINT_NUM = 11;  --һҳ�б����� 
local ITEM_BUTTONS = {};
local ITEM_INFO = {};
local ITEM_NAME = {};
local ITEM_LEAVETIME = {};
local LINE_STATE={0,0,0,0,0,0,0,0,0,0,0};               --�б�һ�е�״̬ 0��ʾ��ȡ 1��ʾ����ȡ  ��11�� 

local g_Selectindex = -1;
local g_ObjCared = -1;

local MAX_OBJ_DISTANCE = 2.0;

local g_posX =0.0;
local g_posY =0.0;

local g_ReturnType = 0;

local g_OnShow = 0;
local g_NowPage = 0;
local g_MaxPage = 0;

local PageUpEnable = 0;
local PageDownEnable = 0;
--===============================================
-- OnLoad
--===============================================
function Compensate_PreLoad()
    this:RegisterEvent("RETURNITEM_UPDATE_PAGE");   -- �򿪹黹��Ʒ����
    this:RegisterEvent("RETURNPET_UPDATE_PAGE");    -- �򿪹黹���ﴰ��
    this:RegisterEvent("RETURNSHOP_UPDATE_PAGE");    -- �򿪹黹�̵괰��
    this:RegisterEvent("RETURNRESULT_UPDATE_UI")  --���������ع黹��� 
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("QUIT_RELATIVE");
	this:RegisterEvent("TIME_UPDATE");	
end

function Compensate_OnLoad()
    ITEM_BUTTONS[1] = Compensate_Item1;
	ITEM_BUTTONS[2] = Compensate_Item2;
	ITEM_BUTTONS[3] = Compensate_Item3;
	ITEM_BUTTONS[4] = Compensate_Item4;
	ITEM_BUTTONS[5] = Compensate_Item5;
	ITEM_BUTTONS[6] = Compensate_Item6;
	ITEM_BUTTONS[7] = Compensate_Item7;
	ITEM_BUTTONS[8] = Compensate_Item8;
	ITEM_BUTTONS[9] = Compensate_Item9;
	ITEM_BUTTONS[10] = Compensate_Item10;
	ITEM_BUTTONS[11] = Compensate_Item11;
	ITEM_BUTTONS[12] = Compensate_Item12;
	ITEM_BUTTONS[13] = Compensate_Item13;
	ITEM_BUTTONS[14] = Compensate_Item14;
	ITEM_BUTTONS[15] = Compensate_Item15;
	ITEM_BUTTONS[16] = Compensate_Item16;
	ITEM_BUTTONS[17] = Compensate_Item17;
	ITEM_BUTTONS[18] = Compensate_Item18;

    ITEM_INFO[1] = Compensate_ItemInfo1;
    ITEM_INFO[2] = Compensate_ItemInfo2; 
    ITEM_INFO[3] = Compensate_ItemInfo3;
    ITEM_INFO[4] = Compensate_ItemInfo4; 
    ITEM_INFO[5] = Compensate_ItemInfo5;
    ITEM_INFO[6] = Compensate_ItemInfo6; 
    ITEM_INFO[7] = Compensate_ItemInfo7;
    ITEM_INFO[8] = Compensate_ItemInfo8;
    ITEM_INFO[9] = Compensate_ItemInfo9;
    ITEM_INFO[10] = Compensate_ItemInfo10; 
    ITEM_INFO[11] = Compensate_ItemInfo11;
    ITEM_INFO[12] = Compensate_ItemInfo12;
    ITEM_INFO[13] = Compensate_ItemInfo13;
    ITEM_INFO[14] = Compensate_ItemInfo14; 
    ITEM_INFO[15] = Compensate_ItemInfo15;
    ITEM_INFO[16] = Compensate_ItemInfo16;
    ITEM_INFO[17] = Compensate_ItemInfo17;
    ITEM_INFO[18] = Compensate_ItemInfo18;
 
    ITEM_NAME[1] = Compensate_ItemInfo1_Text;
    ITEM_NAME[2] = Compensate_ItemInfo2_Text;
    ITEM_NAME[3] = Compensate_ItemInfo3_Text;
    ITEM_NAME[4] = Compensate_ItemInfo4_Text;
    ITEM_NAME[5] = Compensate_ItemInfo5_Text;
    ITEM_NAME[6] = Compensate_ItemInfo6_Text;
    ITEM_NAME[7] = Compensate_ItemInfo7_Text;
    ITEM_NAME[8] = Compensate_ItemInfo8_Text;
    ITEM_NAME[9] = Compensate_ItemInfo9_Text;
    ITEM_NAME[10] = Compensate_ItemInfo10_Text;
    ITEM_NAME[11] = Compensate_ItemInfo11_Text;
    ITEM_NAME[12] = Compensate_ItemInfo12_Text;
    ITEM_NAME[13] = Compensate_ItemInfo13_Text;
    ITEM_NAME[14] = Compensate_ItemInfo14_Text;
    ITEM_NAME[15] = Compensate_ItemInfo15_Text;
    ITEM_NAME[16] = Compensate_ItemInfo16_Text;
    ITEM_NAME[17] = Compensate_ItemInfo17_Text;
    ITEM_NAME[18] = Compensate_ItemInfo18_Text;

    ITEM_LEAVETIME[1] = Compensate_ItemInfo1_GB;
    ITEM_LEAVETIME[2] = Compensate_ItemInfo2_GB;
    ITEM_LEAVETIME[3] = Compensate_ItemInfo3_GB;
    ITEM_LEAVETIME[4] = Compensate_ItemInfo4_GB;
    ITEM_LEAVETIME[5] = Compensate_ItemInfo5_GB;
    ITEM_LEAVETIME[6] = Compensate_ItemInfo6_GB;
    ITEM_LEAVETIME[7] = Compensate_ItemInfo7_GB;
    ITEM_LEAVETIME[8] = Compensate_ItemInfo8_GB;
    ITEM_LEAVETIME[9] = Compensate_ItemInfo9_GB;
    ITEM_LEAVETIME[10] = Compensate_ItemInfo10_GB;
    ITEM_LEAVETIME[11] = Compensate_ItemInfo11_GB;
    ITEM_LEAVETIME[12] = Compensate_ItemInfo12_GB;
    ITEM_LEAVETIME[13] = Compensate_ItemInfo13_GB;
    ITEM_LEAVETIME[14] = Compensate_ItemInfo14_GB;
    ITEM_LEAVETIME[15] = Compensate_ItemInfo15_GB;
    ITEM_LEAVETIME[16] = Compensate_ItemInfo16_GB;
    ITEM_LEAVETIME[17] = Compensate_ItemInfo17_GB;
    ITEM_LEAVETIME[18] = Compensate_ItemInfo18_GB;
    
end

--===============================================
-- OnEvent
--===============================================
function Compensate_OnEvent(event)
	if ( event == "RETURNITEM_UPDATE_PAGE" ) then
                if g_OnShow == 0 then
        		this:Show();
                        Compensate_SetPageSelectButton();
	        	g_posX, g_posY = Player:GetPos();
                        g_OnShow = 1;
                        g_ReturnType = 1;
                end	

		--g_ObjCared = tonumber(arg0);
		--this:CareObject(g_ObjCared, 1, "RS_Returnlist");
			
		CompensateUpdateItemInfo();
        
        elseif( event == "RETURNPET_UPDATE_PAGE" )  then
                if g_OnShow == 0 then
        	 	this:Show();
                        Compensate_SetPageSelectButton();
	        	g_posX, g_posY = Player:GetPos();
                        g_OnShow = 1;
                        g_ReturnType = 2;
                end	

		--g_ObjCared = tonumber(arg0);
		--this:CareObject(g_ObjCared, 1, "RS_Returnlist");
			
		CompensateUpdatePetInfo();

        elseif( event == "RETURNSHOP_UPDATE_PAGE" )  then
                if g_OnShow == 0 then
        	 	this:Show();
                        Compensate_SetPageSelectButton();
	        	g_posX, g_posY = Player:GetPos();
                        g_OnShow = 1;
                        g_ReturnType = 3;
                end	

		--g_ObjCared = tonumber(arg0);
		--this:CareObject(g_ObjCared, 1, "RS_Returnlist");
			
		CompensateUpdateShopInfo();
		
		elseif( event == "RETURNRESULT_UPDATE_UI" )  then
		         local nResultCount = ReturnTool:GetReturnResultCount();
		         for i=0, (nResultCount - 1) do
		                local nRealIndex,nResult =  ReturnTool:EnumReturnResult(i);
		                if nResult == 1 then
		                        Compensate_ReturnSuccess(nRealIndex); 
		                else
		                        Compensate_ReturnFailed(nRealIndex);
		                end
		                     
		         end  

	elseif( event == "OBJECT_CARED_EVENT" )  then
		if(tonumber(arg0) ~= g_ObjCared) then
			return;
		end
		--�����NPC�ľ������һ��������߱�ɾ�����Զ��ر�
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			this:Hide();

			--ȡ������
			--this:CareObject(g_ObjCared, 0, "PS_Shoplist");
				
		end	

	elseif( event == "QUIT_RELATIVE" and this:IsVisible() )  then
			this:Hide();
			--this:CareObject(g_ObjCared, 0, "PS_Shoplist");

	elseif event == "TIME_UPDATE" then
		if this:IsVisible() then
			local xNow, yNow;
			xNow, yNow = Player:GetPos();
			if (xNow - g_posX) * (xNow - g_posX) + (yNow - g_posY) * (yNow - g_posY) > MAX_OBJ_DISTANCE * MAX_OBJ_DISTANCE then
			--if(tostring(xNow) ~= tostring(g_posX) or tostring(yNow) ~= tostring(g_posY) ) then
				this:Hide();
			--  this:CareObject(g_ObjCared, 0, "PS_Shoplist");
			  				
			end	
		end																		
	end

end

--===============================================
-- �б�ѡ�� 
--===============================================
function Compensate_SelectChanged()
	g_Selectindex = Compensate_List:GetSelectItem();
	--PushDebugMessage("Enter Shop Select!" .. g_Selectindex );		
end

--===============================================
-- ������ʾ��Ʒ��Ϣ
--===============================================
function CompensateUpdateItemInfo()


	--���ù黹ѡ��ť״̬
        Compensate_Button01:SetCheck(1);

	Compensate_ClearGridShow();

        --ˢ��ҳ��
        g_NowPage = ReturnTool:GetNowPageNum();
        g_MaxPage = ReturnTool:GetReturnItemPageTatol();
        Compensate_CurrentlyPage:SetText(g_NowPage .."/"..g_MaxPage);
        
        Compensate_RefreshPageButton();
         
        Compensate2_Receive:Hide()
  
        --ˢ��ҳ��
        for i=0, (ITEM_BUTTONS_NUM - 1) do
                local theAction,bHaveReturn,LeaveTime = ReturnTool:EnumReturnItem(i)
                if theAction:GetID() ~= 0 then
                       --PushDebugMessage("CompensateUpdataItemInfo !"..theAction:GetID());
                       ITEM_NAME[i+1]:SetText( theAction:GetName() );
                       ITEM_LEAVETIME[i+1]:SetText("#{TLBC_090714_13}"..LeaveTime);
                       ITEM_BUTTONS[i+1]:SetActionItem(theAction:GetID());
                       ITEM_BUTTONS[i+1]:Enable();
                       if(bHaveReturn == 1) then
                              ITEM_BUTTONS[i+1]:Disable();
                       end
                else
                       ITEM_NAME[i+1]:SetText("");
                       ITEM_LEAVETIME[i+1]:SetText("");
                       ITEM_BUTTONS[i+1]:SetActionItem(-1);
                end
        end
        
        Compensate_CreateItemShow();	
end

--===============================================
-- ������ʾ�������Ϣ
--===============================================
function CompensateUpdatePetInfo()

        --���ù黹ѡ��ť״̬
        Compensate_Button02:SetCheck(1);


        --ˢ��ҳ��
 
        g_NowPage = ReturnTool:GetNowPageNum();
        g_MaxPage = ReturnTool:GetReturnPetPageTatol();

        Compensate_CurrentlyPage:SetText(g_NowPage .."/"..g_MaxPage);
        
        Compensate_RefreshPageButton();
        Compensate2_Receive:Show();
        
        --ˢ��ҳ��
        Compensate_ClearItemShow();
        Compensate_List:RemoveAllItem();

        local ColumnCount = Compensate_List:GetColumnCount();
        

        for i = 0,(ColumnCount - 1) do
              Compensate_List:RemoveColumnByPos(0);
        end 

        Compensate_List:AddColumn("#{TLBC_090714_07}",0, 0.28);
        Compensate_List:AddColumn("#{TLBC_090714_06}",1, 0.28);
        Compensate_List:AddColumn("#{TLBC_090714_08}",2, 0.28);
        Compensate_List:AddColumn("#{TLBC_090714_09}",3, 0.16);
 

        Compensate_List:SetProperty( "ColumnsSizable", "False" );
	    Compensate_List:SetProperty( "ColumnsAdjust", "True" );
	    Compensate_List:SetProperty( "ColumnsMovable", "False" );
        Compensate_CreateGridShow();	
       
        local nCount = ReturnTool:GetReturnPetCount();
       
        --ˢ��ҳ��
        for i=0, (nCount - 1) do	
                local PetName,PetNickName,HaveReturned,LeaveTime = ReturnTool:EnumReturnPet(i)
                if PetName ~= "" then
                       Compensate_List:AddNewItem(PetName, 0, i);
                       Compensate_List:AddNewItem(PetNickName, 1, i);
                       Compensate_List:AddNewItem(LeaveTime, 2,i);
                       if (HaveReturned == 1) then
                           Compensate_List:AddNewItem("#{TLBC_090714_19}", 3, i);
                           LINE_STATE[i] = 1; 
                       else
                           Compensate_List:AddNewItem("#{TLBC_090714_16}", 3, i);
                           LINE_STATE[i] = 0
                       end  
                end
        end
        
end

--===============================================
-- ������ʾ�̵����Ϣ
--===============================================
function CompensateUpdateShopInfo()

        --���ù黹ѡ��ť״̬
        Compensate_Button03:SetCheck(1);

        --ˢ��ҳ��
        g_NowPage = ReturnTool:GetNowPageNum();
        g_MaxPage = ReturnTool:GetReturnShopPageTatol();
        Compensate_CurrentlyPage:SetText(g_NowPage .."/"..g_MaxPage);
        Compensate_RefreshPageButton();

        Compensate2_Receive:Show();
        
        --ˢ��ҳ��
        Compensate_ClearItemShow();
        Compensate_List:RemoveAllItem();
        local ColumnCount = Compensate_List:GetColumnCount();
        for i = 0,(ColumnCount - 1) do
              Compensate_List:RemoveColumnByPos(0);
        end 

        Compensate_List:AddColumn("#{TLBC_090714_10}", 0, 0.28);
        Compensate_List:AddColumn("#{TLBC_090714_11}", 1, 0.28);
        Compensate_List:AddColumn("#{TLBC_090714_08}", 2, 0.28);
        Compensate_List:AddColumn("#{TLBC_090714_09}", 3, 0.16);

        Compensate_List:SetProperty( "ColumnsSizable", "False" );
	    Compensate_List:SetProperty( "ColumnsAdjust", "True" );
	    Compensate_List:SetProperty( "ColumnsMovable", "False" );
        Compensate_CreateGridShow();
       
        local nCount = ReturnTool:GetReturnShopCount();
        Compensate_List:RemoveAllItem();

        --ˢ��ҳ��
        for i=0, (nCount - 1) do	
                local ShopName,ShopClass,HaveReturned,LeaveTime = ReturnTool:EnumReturnShop(i);
                if ShopClass == 1 then
                       Compensate_List:AddNewItem(ShopName, 0, i);
                       Compensate_List:AddNewItem("#{GMGameInterface_Script_PlayerShop_Info_Item_Shop}", 1, i);
                       Compensate_List:AddNewItem(LeaveTime, 2, i);
                else
                    if (ShopClass == 2) then
                       Compensate_List:AddNewItem(ShopName, 0, i);
                       Compensate_List:AddNewItem("#{GMGameInterface_Script_PlayerShop_Info_Pet_Shop}",1,i);
                       Compensate_List:AddNewItem(LeaveTime, 2, i);
                    else
                       continue;
                    end
                end
                if (HaveReturned == 1) then
                       Compensate_List:AddNewItem("#{TLBC_090714_19}", 3, i);
                       LINE_STATE[i] = 1; 
                else
                       Compensate_List:AddNewItem("#{TLBC_090714_16}", 3, i);
                       LINE_STATE[i] = 0;
                end  
        end
        Compensate_List:SetSelectItem(0)
        Compensate_List:Enable();
end

--===============================================
-- Close
--===============================================
function Compensate_Close()
	this:Hide();
	--ȡ������
	--this:CareObject(g_ObjCared, 0, "RS_Returnlist");
        g_OnShow = 0;
end

--===============================================
-- OnHiden
--===============================================
function Compensate_Frame_OnHiden()


end

function Compensate_SetPageSelectButton()
       
       Compensate_Button01:Enable();
       Compensate_Button02:Enable();
       Compensate_Button03:Enable();
        
       if ReturnTool:GetReturnItemPageTatol() <= 0 then
             Compensate_Button01:Disable()
       end
       if ReturnTool:GetReturnPetPageTatol() <= 0 then
             Compensate_Button02:Disable()
       end   
       if ReturnTool:GetReturnShopPageTatol() <= 0 then
             Compensate_Button03:Disable()
       end
end

function Compensate_GoodButton_Clicked(nIndex)

        if nIndex < 0 or nIndex >  ITEM_BUTTONS_NUM then
                return
        end
        
        if ReturnTool:AskToReturn(nIndex - 1) == 1 then
                ITEM_BUTTONS[nIndex]:Disable()
        end
end


--===============================================
-- �����Ʒ�ؼ�
--===============================================
function Compensate_ClearItemShow()
       for i=1,ITEM_BUTTONS_NUM do
            ITEM_BUTTONS[i]:Hide()
            ITEM_INFO[i]:Hide()
       end 
       Compensate_Action_Set:Hide()
end

--===============================================
-- ��ʾ��Ʒ�ؼ�
--===============================================
function Compensate_CreateItemShow()
      Compensate_Action_Set:Show()
      for i=1,ITEM_BUTTONS_NUM  do
          ITEM_BUTTONS[i]:Show()
          ITEM_INFO[i]:Show()
      end 
end


--===============================================
-- ������ؼ�
--===============================================
function Compensate_ClearGridShow()         
         Compensate_List:Hide()
end


--===============================================
-- ������ؼ�
--===============================================
function Compensate_CreateGridShow()
         Compensate_List:Show()
end

--===============================================
-- �黹���ѡ��ť
--===============================================
function Compensate_UpdateShop(nIndex)
		   if(g_ReturnType ~= nIndex)  then
                   g_ReturnType = nIndex;
                   ReturnTool:GetPageInfo(1,nIndex);
		   end
end


--===============================================
-- ˢ�·�ҳ��ť
--===============================================
function Compensate_RefreshPageButton()
         Compensate_DownPage:Enable();
         Compensate_UpPage:Enable();
         if (g_NowPage >= g_MaxPage) then
             Compensate_DownPage:Disable();
         end
         if (g_NowPage <= 1) then
             Compensate_UpPage:Disable();
         end
end

--===============================================
-- �·�ҳ
--===============================================
function Compensate_PageUp()
         if (g_NowPage > 1) then
             ReturnTool:GetPageInfo(g_NowPage - 1,g_ReturnType);
         end
end

--===============================================
-- �Ϸ�ҳ
--===============================================
function Compensate_PageDown()
         if (g_NowPage < g_MaxPage) then
             ReturnTool:GetPageInfo(g_NowPage + 1,g_ReturnType);
         end
end

--===============================================
-- �黹��ť
--===============================================
function Compensate_Receive()
		 if(LINE_STATE[g_Selectindex] == 0) and g_Selectindex >= 0 then
               ReturnTool:AskToReturn(g_Selectindex);
		 end
end
--===============================================
-- ���ù黹�ɹ� 
--===============================================
function Compensate_ReturnSuccess(nIndex)
         if g_ReturnType == 1 then
            ITEM_BUTTONS[nIndex + 1]:Disable();
         else
            Compensate_List:SetItemText(nIndex,3,"#{TLBC_090714_19}");
            LINE_STATE[g_Selectindex] = 1;
         end
end

--===============================================
-- ���ù黹ʧ�� 
--===============================================
function Compensate_ReturnFailed(nIndex)
         if g_ReturnType == 1 then
            ITEM_BUTTONS[nIndex + 1]:Enable();
         else
            Compensate_List:SetItemText(nIndex,3,"#{TLBC_090714_16}");
            LINE_STATE[g_Selectindex] = 0;
         end
end