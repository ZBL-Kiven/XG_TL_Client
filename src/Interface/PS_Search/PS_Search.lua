--PS_Search.lua

local PAGE_ITEM = 0;
local PAGE_PET  = 1;

local g_CurPage;

local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;

--===============================================
-- PreLoad
--===============================================
function PS_Search_PreLoad()
	this:RegisterEvent("OPEN_FIND_SHOP");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("PS_CLOSE_FIND_SHOP");

end

--===============================================
-- OnLoad
--===============================================
function PS_Search_OnLoad()
	g_CurPage = PAGE_ITEM;
end

--===============================================
-- OnEvent
--===============================================
function PS_Search_OnEvent(event)

	if(event == "OPEN_FIND_SHOP")  then
		this:Show();
		PS_Search_UpdateFrame(g_CurPage)
		
		objCared = PlayerShop:GetNpcId();
		this:CareObject(objCared, 1, "PS_Search");
	
	elseif(event == "OBJECT_CARED_EVENT")   then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		
		--�����NPC�ľ������һ��������߱�ɾ�����Զ��ر�
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			g_InitiativeClose = 1;
			this:Hide();

			--ȡ������
			this:CareObject(objCared, 0, "PS_Search");
		end	
	
	elseif ( event == "PS_CLOSE_FIND_SHOP" )    then
		this:Hide();
		
		--ȡ������
		this:CareObject(objCared, 0, "PS_Search");

	end
	
end

--===============================================
-- ���ѡ���б�
--===============================================
function PS_Search_List_Selected()
	
	local nSelect = PS_Search_List:GetFirstSelectItem();
	if( nSelect == -1 )   then
		return;
	end
	
	if(g_CurPage == PAGE_ITEM)    then			--��Ʒҳ
		PlayerShop:FindShop("item",nSelect+1);
	
	elseif(g_CurPage == PAGE_PET) then			--����ҳ
		PlayerShop:FindShop("pet",nSelect+1);
		
	end

end

--===============================================
-- UpdateFrame
--===============================================
function PS_Search_UpdateFrame(nPage)
	
	PS_Search_SetTabColor(nPage);
	PS_Search_List:ClearListBox();
	if(nPage == PAGE_ITEM)    then					--��Ʒҳ
		PS_Search_List:AddItem("��Ʒ��",0)
		PS_Search_List:AddItem("��ʯ��",1)
		PS_Search_List:AddItem("������",2)
		PS_Search_List:AddItem("���׵�",3)
		PS_Search_List:AddItem("���ϵ�",4)
		
		PS_Search_All:SetText("ȫ����Ʒ��");

	elseif(nPage == PAGE_PET) then 					--����ҳ
		PS_Search_List:AddItem("���޵�",0)

		PS_Search_All:SetText("ȫ��������");
		
	end
end

--===============================================
-- ChangeTabIndex
--===============================================
function PS_Search_ChangeTabIndex(nPage)
	g_CurPage = nPage;
	PS_Search_UpdateFrame(nPage)
end

--===============================================
-- ѡһ��
--===============================================
function PS_Search_All_Clicked()
	
	if(g_CurPage == PAGE_ITEM)    then			--��Ʒҳ
		PlayerShop:FindShop("item", -1);
	
	elseif(g_CurPage == PAGE_PET) then			--����ҳ
		PlayerShop:FindShop("pet", -1);
		
	end
	
end

--===============================================
-- Tab�ϵ�������ɫ
--===============================================
function PS_Search_SetTabColor(nPage)

	local   selColor = "#e010101#Y";
	local noselColor = "#e010101";

	if( nPage == PAGE_ITEM )		then
		PS_Search_Check_Item:SetText(selColor.. "��Ʒ");
		PS_Search_Check_Pet:SetText(noselColor.. "����");
	elseif( nPage == PAGE_PET )	then
		PS_Search_Check_Item:SetText(noselColor.. "��Ʒ");
		PS_Search_Check_Pet:SetText(selColor.. "����");
	end

end

--===============================================
-- Close
--===============================================
function PS_Search_Close_Clicked()
	this:Hide();
	--ȡ������
	this:CareObject(objCared, 0, "PS_Search");
	
end