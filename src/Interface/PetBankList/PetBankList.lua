local PET_MAX_NUMBER = 10	--�������Я������ --add by xindefeng
local PETBANK_LIST_CURRENT_SELECT =0 --�б�����ѡ�е���
local PETBAGMAX_CURRNET_SIZE =0 ;--��ǰ�������е����size
local objCared = -1;
local g_nSelect_Index = 0;
local g_PreSelect = -1;
local g_PetIndex  = {};


function PetBankList_PreLoad()
	
	this:RegisterEvent("TOGLE_PETBANK"); --���������н����¼�
--	this:RegisterEvent("TOGLE_PETBANK"); --���������н����¼�
	this:RegisterEvent("TOGLE_PETLIST_SELECT_CHNAGE");	
	this:RegisterEvent("TOGLE_PETLIST_PETNUM_CHNAGE");
	this:RegisterEvent("OPEN_WINDOW");
	this:RegisterEvent("UPDATE_PET_PAGE");
	--this:RegisterEvent("TOGLE_GETBANKSIZE_PETBANK"); --����ѡ���¼�
	this:RegisterEvent("OBJECT_CARED_EVENT",false); --���������¼�

end

function PetBankList_OnLoad()

	for i=1 ,20   do
		g_PetIndex[i] = -1;
	end
	-- g_PetBankList_Frame_UnifiedPosition=PetBankList_Frame:GetProperty("UnifiedPosition");
end

--===============================================
-- OnEvent()
--===============================================
function PetBankList_OnEvent(event)


	-- �������б����	
	if(event == "TOGLE_PETBANK") then
	local nMaxbagsize = tonumber(arg1)
  	if nMaxbagsize ~= nil and 0 < nMaxbagsize and nMaxbagsize <= 10 then
  	 	 PETBAGMAX_CURRNET_SIZE = nMaxbagsize
		 local petNum =Pet:GetPet_Count()
		 PetBankList_TheHaveList:SetText("#{ZSYH_120503_19}"..petNum.."/"..PETBAGMAX_CURRNET_SIZE) -- "#{ZSYH_120503_19}" ��Я������
  	end
  	 local openpetbank = tonumber(arg3)
         if openpetbank ~= nil and openpetbank < 1 then
	   return ;
	 end
		if(IsWindowShow("PetBankList")) then
		 return;
		 end
		objCared = Bank:GetNpcId(); --����bank������
		this:CareObject(objCared, 1, "PetBankList");
		this:Show();
		PetBankList_UpdateFrame();
	--	PetBankList_Frame:SetProperty("UnifiedXPosition","{0.0,570}");
	--	PetBankList_Frame:SetProperty("UnifiedYPosition","{0.0,206}");
	elseif ( event == "OPEN_WINDOW" ) then
	   if( arg0 ~= "PetBankList") then
	   	 return;
	   end
		 if(IsWindowShow("PetBankList")) then
		   return;
		 end
		 this:Show();
		 PetBankList_UpdateFrame();
   elseif ( event == "TOGLE_PETLIST_SELECT_CHNAGE" ) then--����ѡ���¼�
			 local commandIndex = tonumber(arg0)
			 local nType= tonumber(arg1)
			 if nType~=nil and commandIndex~= nil and 0 <= commandIndex  and nType== 0 then
			 		PETBANK_LIST_CURRENT_SELECT =commandIndex;
			 end
	 elseif ( event == "TOGLE_PETLIST_PETNUM_CHNAGE" ) then--���޸���
	 			PetBankList_UpdateFrame();
	-- ������ϵ��������ݷ����仯���������޳�ս����Ϣ������һֻ����
	elseif ( event == "UPDATE_PET_PAGE" ) then	
	     PetBankList_UpdateFrame()	
   elseif (event == "OBJECT_CARED_EVENT") then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		--�����NPC�ľ������һ��������߱�ɾ�����Զ��ر�
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			this:Hide();
			CloseWindow("PetBankMain", true);
			--ȡ������
			this:CareObject(objCared, 0, "PetBankList");
		end
	-------------------------------------------------------------------
	end
   
end
-- !!!reloadscript =PetBankList
--===============================================
-- ���½���
--===============================================
function PetBankList_UpdateFrame()
 	
	-- ����յ�ǰ�б�
	PetBankList_List:ClearListBox();
	local PetInListIndex = 0;
	for i=0, PET_MAX_NUMBER-1 do	
	  local szPetName,szOn  = Pet:GetPetList_Appoint(i);
	  local strToolTips = "";
	  if(szPetName ~= "")   then
		if (PlayerPackage:IsPetLock(i) == 1)  then
			  local nUnlockElapsedTime = PlayerPackage:GetPUnlockElapsedTime_Pet(i);
			  if( nUnlockElapsedTime == 0 ) then
				if (Pet : GetIsFighting(i)) then
					  szPetName = "#c808080"..szPetName
				end
			  	szPetName = szPetName.. "#-05";
			  	strToolTips =  "�Ѽ���" ;
			  else
			    if (Pet : GetIsFighting(i)) then
					  szPetName = "#c808080"..szPetName
				end
			  	szPetName = szPetName.. "#-10";
			  	local strLeftTime = g_GetUnlockingStr(nUnlockElapsedTime);			
			  	strToolTips = strLeftTime ;
			  end
			PetBankList_List:AddItem(szPetName, i);
		elseif (szOn ~= "on_packa" ) then
			szPetName = "#c808080" .. szPetName;		-- ��ɫ��ʾ
			PetBankList_List:AddItem(szPetName, i);
		elseif(Pet : GetIsFighting(i)) then
		    szPetName = "#c808080" .. szPetName;		-- ��ɫ��ʾ
			PetBankList_List:AddItem(szPetName, i);
		else
			PetBankList_List:AddItem(szPetName, i);
		 end
				PetBankList_List:SetItemTooltip( PetInListIndex, strToolTips );
				PetInListIndex = PetInListIndex + 1 ;
		end
	end
	local szPetNameChar = Pet:GetPetList_Appoint(g_nSelect_Index);
	if(szPetNameChar ~= "")   then
		PetBankList_List : SetItemSelectByItemID(g_nSelect_Index);
	else
		local nfirstpagpet =Pet: GetFirstPetPosInPag();
	  PetBankList_List : SetItemSelectByItemID(nfirstpagpet);
	  g_nSelect_Index = nfirstpagpet;
	end
	
	local petNum =Pet:GetPet_Count()
	PetBankList_TheHaveList:SetText("#{ZSYH_120503_19}"..petNum.."/"..PETBAGMAX_CURRNET_SIZE) -- "#{ZSYH_120503_19}" ��Я������
end

--===============================================
-- �����в���
--===============================================
function PetBankList_Refuse_Click()							
	
	if( g_nSelect_Index == -1 )  then
		g_nSelect_Index = PetBankList_List:GetFirstSelectItem();
	end
	if( g_nSelect_Index == -1 )  then
		 PushDebugMessage("#{ZSYH_120503_30}") --��ѡ��Ҫ��ŵ�����
		return;
	end
       
	-- if PlayerPackage:IsPetLock(g_nSelect_Index) == 1 then
	--	 PushDebugMessage("#{Pet_Locked}") --Pet_Locked  �����Ѽ���
	--	 return; 
	-- end
	if  -1<g_nSelect_Index  and g_nSelect_Index < PET_MAX_NUMBER then
	 if(IsWindowShow("TargetPet2")) then
	   CloseWindow("TargetPet2", true);
	 end
	  if(IsWindowShow("Pet")) then
	   CloseWindow("Pet", true);
	 end
	
	 Pet:SavePetIntoBank_PetBank(g_nSelect_Index, 1) --0��ʾ�ӱ���������
	 local nfirstpagpet = Pet:GetFirstPetPosInPag();
	  PetBankList_List : SetItemSelectByItemID(nfirstpagpet);
	  g_nSelect_Index = nfirstpagpet;
	end
	
end


--===============================================
-- ѡ���б��е�����
--===============================================
function PetBankList_List_Selected()
	local Num = PetBankList_List:GetFirstSelectItem();
	if g_nSelect_Index == Num then
		return ;
	end
	g_nSelect_Index =Num
	if  -1<g_nSelect_Index  and g_nSelect_Index < PET_MAX_NUMBER then
		--	�����ޱ������ݸ����˵Ĳ�����������
		Pet:PetBank_PetListSelectChange(g_nSelect_Index,1);
	end
end

--===============================================
--����ѡ������ޣ���ʾ��Ӧ����ϸ��Ϣ
--===============================================
function PetBankList_ShowTargetPet()
	
	local nSelect = PetBankList_List:GetFirstSelectItem();
	if( -1 == g_nSelect_Index ) then
		return;
	end
	g_nSelect_Index =nSelect 
	if(IsWindowShow("TargetPet2")) then
	   CloseWindow("TargetPet2", true);
	end
	Pet:ShowBagSelectPet_PetBank(nSelect);
	
end



--================================================
-- �ָ������Ĭ�����λ��
--================================================
function PetBankList_Frame_On_ResetPos()
  --PetBankList_Frame:SetProperty("UnifiedPosition", g_PetBankList_Frame_UnifiedPosition);
end

--�رմ���
function PetBankList_Close_Click()
  this:Hide()
  this:CareObject(objCared, 0, "PetBankList");
  	 if(IsWindowShow("TargetPet")) then
			CloseWindow("TargetPet", true);
	end
	
	if(IsWindowShow("TargetPet2")) then
			CloseWindow("TargetPet2", true);
	end
	
	if(IsWindowShow("Pet")) then
			CloseWindow("Pet", true);
	end
end

function PetBankList_Choose_Click()
	if( g_nSelect_Index == -1 )  then
			g_nSelect_Index = PetBankList_List:GetFirstSelectItem();
		end
		
		if( g_nSelect_Index == -1 )  then
			 PushDebugMessage("#{ZSYH_120503_30}") --��ѡ��Ҫ��ŵ�����
			return;
		end
	if  -1<g_nSelect_Index  and g_nSelect_Index < PET_MAX_NUMBER then
		if(IsWindowShow("TargetPet2")) then
		  CloseWindow("TargetPet2", true);
		end
		 if(IsWindowShow("Pet")) then
			CloseWindow("Pet", true);
		end
		--if(1~=IsWindowShow("PetBankMain")) then
		 --  PushDebugMessage("�������н����Ѿ��ر����ȴ򿪣�") --Pet_Locked  �����Ѽ���	
		  -- return ;
		--end
		Pet:SavePetIntoBank_PetBank(g_nSelect_Index,2,PETBANK_LIST_CURRENT_SELECT); --����������ѡ�У�2������ѡ��
	end
end

