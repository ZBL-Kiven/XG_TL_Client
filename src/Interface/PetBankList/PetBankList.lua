local PET_MAX_NUMBER = 10	--最大珍兽携带上限 --add by xindefeng
local PETBANK_LIST_CURRENT_SELECT =0 --列表现在选中的项
local PETBAGMAX_CURRNET_SIZE =0 ;--当前珍兽银行的最大size
local objCared = -1;
local g_nSelect_Index = 0;
local g_PreSelect = -1;
local g_PetIndex  = {};


function PetBankList_PreLoad()
	
	this:RegisterEvent("TOGLE_PETBANK"); --打开珍兽银行界面事件
--	this:RegisterEvent("TOGLE_PETBANK"); --打开珍兽银行界面事件
	this:RegisterEvent("TOGLE_PETLIST_SELECT_CHNAGE");	
	this:RegisterEvent("TOGLE_PETLIST_PETNUM_CHNAGE");
	this:RegisterEvent("OPEN_WINDOW");
	this:RegisterEvent("UPDATE_PET_PAGE");
	--this:RegisterEvent("TOGLE_GETBANKSIZE_PETBANK"); --更新选中事件
	this:RegisterEvent("OBJECT_CARED_EVENT",false); --界面敏感事件

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


	-- 打开珍兽列表界面	
	if(event == "TOGLE_PETBANK") then
	local nMaxbagsize = tonumber(arg1)
  	if nMaxbagsize ~= nil and 0 < nMaxbagsize and nMaxbagsize <= 10 then
  	 	 PETBAGMAX_CURRNET_SIZE = nMaxbagsize
		 local petNum =Pet:GetPet_Count()
		 PetBankList_TheHaveList:SetText("#{ZSYH_120503_19}"..petNum.."/"..PETBAGMAX_CURRNET_SIZE) -- "#{ZSYH_120503_19}" 可携带珍兽
  	end
  	 local openpetbank = tonumber(arg3)
         if openpetbank ~= nil and openpetbank < 1 then
	   return ;
	 end
		if(IsWindowShow("PetBankList")) then
		 return;
		 end
		objCared = Bank:GetNpcId(); --套用bank的数据
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
   elseif ( event == "TOGLE_PETLIST_SELECT_CHNAGE" ) then--更新选中事件
			 local commandIndex = tonumber(arg0)
			 local nType= tonumber(arg1)
			 if nType~=nil and commandIndex~= nil and 0 <= commandIndex  and nType== 0 then
			 		PETBANK_LIST_CURRENT_SELECT =commandIndex;
			 end
	 elseif ( event == "TOGLE_PETLIST_PETNUM_CHNAGE" ) then--珍兽更新
	 			PetBankList_UpdateFrame();
	-- 玩家身上的珍兽数据发生变化，包括珍兽出战、休息、增加一只珍兽
	elseif ( event == "UPDATE_PET_PAGE" ) then	
	     PetBankList_UpdateFrame()	
   elseif (event == "OBJECT_CARED_EVENT") then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			this:Hide();
			CloseWindow("PetBankMain", true);
			--取消关心
			this:CareObject(objCared, 0, "PetBankList");
		end
	-------------------------------------------------------------------
	end
   
end
-- !!!reloadscript =PetBankList
--===============================================
-- 更新界面
--===============================================
function PetBankList_UpdateFrame()
 	
	-- 先清空当前列表
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
			  	strToolTips =  "已加锁" ;
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
			szPetName = "#c808080" .. szPetName;		-- 灰色显示
			PetBankList_List:AddItem(szPetName, i);
		elseif(Pet : GetIsFighting(i)) then
		    szPetName = "#c808080" .. szPetName;		-- 灰色显示
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
	PetBankList_TheHaveList:SetText("#{ZSYH_120503_19}"..petNum.."/"..PETBAGMAX_CURRNET_SIZE) -- "#{ZSYH_120503_19}" 可携带珍兽
end

--===============================================
-- 存银行操作
--===============================================
function PetBankList_Refuse_Click()							
	
	if( g_nSelect_Index == -1 )  then
		g_nSelect_Index = PetBankList_List:GetFirstSelectItem();
	end
	if( g_nSelect_Index == -1 )  then
		 PushDebugMessage("#{ZSYH_120503_30}") --请选择要存放的珍兽
		return;
	end
       
	-- if PlayerPackage:IsPetLock(g_nSelect_Index) == 1 then
	--	 PushDebugMessage("#{Pet_Locked}") --Pet_Locked  珍兽已加锁
	--	 return; 
	-- end
	if  -1<g_nSelect_Index  and g_nSelect_Index < PET_MAX_NUMBER then
	 if(IsWindowShow("TargetPet2")) then
	   CloseWindow("TargetPet2", true);
	 end
	  if(IsWindowShow("Pet")) then
	   CloseWindow("Pet", true);
	 end
	
	 Pet:SavePetIntoBank_PetBank(g_nSelect_Index, 1) --0标示从背包到银行
	 local nfirstpagpet = Pet:GetFirstPetPosInPag();
	  PetBankList_List : SetItemSelectByItemID(nfirstpagpet);
	  g_nSelect_Index = nfirstpagpet;
	end
	
end


--===============================================
-- 选中列表中的珍兽
--===============================================
function PetBankList_List_Selected()
	local Num = PetBankList_List:GetFirstSelectItem();
	if g_nSelect_Index == Num then
		return ;
	end
	g_nSelect_Index =Num
	if  -1<g_nSelect_Index  and g_nSelect_Index < PET_MAX_NUMBER then
		--	把珍兽背包数据更新了的操作告诉银行
		Pet:PetBank_PetListSelectChange(g_nSelect_Index,1);
	end
end

--===============================================
--根据选择的珍兽，显示相应的详细信息
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
-- 恢复界面的默认相对位置
--================================================
function PetBankList_Frame_On_ResetPos()
  --PetBankList_Frame:SetProperty("UnifiedPosition", g_PetBankList_Frame_UnifiedPosition);
end

--关闭窗口
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
			 PushDebugMessage("#{ZSYH_120503_30}") --请选择要存放的珍兽
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
		 --  PushDebugMessage("珍兽银行界面已经关闭请先打开！") --Pet_Locked  珍兽已加锁	
		  -- return ;
		--end
		Pet:SavePetIntoBank_PetBank(g_nSelect_Index,2,PETBANK_LIST_CURRENT_SELECT); --参数：银行选中，2，背包选中
	end
end

