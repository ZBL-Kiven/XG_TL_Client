local g_ItemMax = 0;
local g_ItemIdx = -1;

local CU_MONEY			= 1	-- Ǯ

local objCared = -1;

g_MountXueYuID = 39;   --����ѩ���id
g_MountMingYuID = 44;	--����ڤ���id
g_CameraHeight = 1;     --��Ӱ���߶�
g_CameraDistance = 2;   --��Ӱ������
g_CameraPitch = 3;      --��Ӱ���Ƕ�





function Shop_Fitting_PreLoad()
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("OPEN_SHOP_FITTING");
	this:RegisterEvent("CLOSE_SHOP_FITTING");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("SEX_CHANGED");
end

function Shop_Fitting_OnLoad()
end


function ShopFitting_OnHiden()
	SetDefaultMouse();
	RestoreShopFitting();
	this:Hide();
end

function Shop_Fitting_OnEvent(event)

--AxTrace(0,0,event);

	if ( event == "PLAYER_ENTERING_WORLD" ) then
		Shop_Fitting_Booth_Close();
		
		-- ��ʾ����
	end
	if(event == "OPEN_SHOP_FITTING") then
		this:Show();
		
		objCared = NpcShop:GetNpcId();
		this:CareObject(objCared, 1, "Shop_Fitting");
	
		Shop_Fitting_FakeObject:SetFakeObject("");	
		Shop_Fitting_FakeObject:SetFakeObject("EquipChange_Player");
		
		local nMountID = GetMountID();
		if nMountID == g_MountXueYuID or g_MountMingYuID == nMountID  then   --ѩ�������Ƚ����⣬���������������λ��
		  FakeObj_SetCamera( "EquipChange_Player", g_CameraDistance,12);
		  FakeObj_SetCamera( "EquipChange_Player", g_CameraHeight,2);
		elseif nMountID > 0 then
			FakeObj_SetCamera( "EquipChange_Player", g_CameraDistance,12);	
		end
		
	elseif(event == "CLOSE_SHOP_FITTING") then
		
		RestoreShopFitting();
		this:Hide();
		
	elseif (event == "OBJECT_CARED_EVENT") then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		
		--��������˵ľ������һ��������߱�ɾ�����Զ��ر�
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			--ȡ������
			RestoreShopFitting();
			this:CareObject(objCared, 0, "Shop_Fitting");
			this:Hide();			
		end
	end
	if event == "SEX_CHANGED" and  this:IsVisible() then
			Shop_Fitting_FakeObject : Hide();
			Shop_Fitting_FakeObject : Show();
			Shop_Fitting_FakeObject:SetFakeObject("EquipChange_Player");
					local nMountID = GetMountID();
		if nMountID == g_MountXueYuID or g_MountMingYuID == nMountID then   --ѩ�������Ƚ����⣬���������������λ��
		  FakeObj_SetCamera( "EquipChange_Player", g_CameraDistance,12);
		  FakeObj_SetCamera( "EquipChange_Player", g_CameraHeight,2);
		elseif nMountID > 0 then
			FakeObj_SetCamera( "EquipChange_Player", g_CameraDistance,12);	
		end
	end
end

function Shop_Fitting_Booth_Close()
	
	--ȡ������
	this:CareObject(objCared, 0, "Shop_Fitting");
	RestoreShopFitting();
	CloseShopFitting();
	this:Hide();
end


function Shop_Fitting_Accept_Clicked()

	this:Hide();
end

function Shop_Fitting_TextChanged()

	
end


----------------------------------------------------------------------------------
--
-- ��ת����ͷ��ģ�ͣ�����)
--
function Shop_Fitting_TurnLeft(start)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
	AxTrace( 0,0, "Shop_Fitting_TurnLeft   " )
		--������ת��ʼ
		if(start == 1) then
			Shop_Fitting_FakeObject:RotateBegin(-0.3);
		--������ת����
		else
			Shop_Fitting_FakeObject:RotateEnd();
		end
	end
end

----------------------------------------------------------------------------------
--
--��ת����ͷ��ģ�ͣ�����)
--
function Shop_Fitting_TurnRight(start)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
	AxTrace( 0,0, "Shop_Fitting_TurnRight   " )
		--������ת��ʼ
		if(start == 1) then
			Shop_Fitting_FakeObject:RotateBegin(0.3);
		--������ת����
		else
			Shop_Fitting_FakeObject:RotateEnd();
		end
	end
end