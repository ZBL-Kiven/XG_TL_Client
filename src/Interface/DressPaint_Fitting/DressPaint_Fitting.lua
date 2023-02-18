-- ʱװȾɫ���¼�

local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0

local g_DressPaint_Fitting_Frame_UnifiedPosition;

function DressPaint_Fitting_PreLoad()
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("UI_COMMAND");
	--this:RegisterEvent("OPEN_DRESS_PAINT_FITTING");
	this:RegisterEvent("CLOSE_DRESS_PAINT_FITTING");	
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("PROGRESSBAR_SHOW");
	this:RegisterEvent("OPEN_STALL_SALE");
	this:RegisterEvent("OPEN_EQUIP");
	this:RegisterEvent("SEX_CHANGED");
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("YIGUI_OPEN",false)
end

function DressPaint_Fitting_OnLoad()
	g_DressPaint_Fitting_Frame_UnifiedPosition=DressPaint_Fitting_Frame:GetProperty("UnifiedPosition");
end

function DressPaint_Fitting_OnEvent(event)

	-- �뿪��Ϸ����
	if ( event == "PLAYER_ENTERING_WORLD" ) then
		DressPaint_Fitting_OnHiden();
		return
	end

	-- �ر����¼�
	if (event == "CLOSE_DRESS_PAINT_FITTING") then
		if (this:IsVisible()) then		
			DressPaint_Fitting_OnHiden();									-- �����������߼���������Ʒ���ϸ�رյ����¼䣬���Բ��ܼ��Ⱦɫ׷�١���ť
		end
	end

	-- Ⱦɫ�ɹ���������¼俪�ţ����ȹر�
	if event == "UI_COMMAND" and tonumber(arg0) == 091111 then		
		if (this:IsVisible()) then
			DressPaint_Fitting_OnClosed();								-- �رա�Ⱦɫ׷�١����¼䣬���ڱ�Ⱦɫ���·����ᱻɾ�������Կ������¼��Ⱦɫ׷�١���ť
		end
	end
	
	-- ��ʼ��̯�����ܽ�������
	if ( event == "OPEN_STALL_SALE" ) then
		if (this:IsVisible()) then
			DressPaint_Fitting_OnClosed();									-- �رա�Ⱦɫ׷�١����¼䣬���¼��Ⱦɫ׷�١���ť
		end
	end

	-- ���������У����ܽ�������
	if ( event == "PROGRESSBAR_SHOW" ) then
		if (this:IsVisible()) then
			DressPaint_Fitting_OnClosed();								-- �رա�Ⱦɫ׷�١����¼䣬���¼��Ⱦɫ׷�١���ť
		end
	end

	-- ���µ�ʱ���ܴ򿪽�ɫ���ϴ���
	if ( event == "OPEN_EQUIP" ) then
		if (this:IsVisible()) then
			DressPaint_Fitting_OnClosed();								-- �رա�Ⱦɫ׷�١����¼䣬���¼��Ⱦɫ׷�١���ť
		end
	end
	
	-- ���µ�ʱ���ܴ��¹�
	if ( event == "YIGUI_OPEN" ) then
		if (this:IsVisible()) then
			DressPaint_Fitting_OnClosed();								-- �رա�Ⱦɫ׷�١����¼䣬���¼��Ⱦɫ׷�١���ť
		end
	end
	
	-- �����¼�
	if(event == "OPEN_DRESS_PAINT_FITTING") then
			
		-- ����
		local nDressBagPos = tonumber(arg0)
		DressReplaceColor : FittingOnDress(nDressBagPos)
		this:Show()
		
		-- ����ʹ���ĸ�ģ��
		DressPaint_Fitting_FakeObject : SetFakeObject("");	
		DressPaint_Fitting_FakeObject : SetFakeObject("DressPaint_Player");
				
		-- ��ʼ����NPC
		local npcID = Get_XParam_INT(0);
		local objCared = DataPool:GetNPCIDByServerID(npcID);
		if objCared == -1 then
			return;
		end		
		this:CareObject(objCared, 1, "DressPaint_Fitting");
	end
	
	-- ����NPC
	if (event == "OBJECT_CARED_EVENT") then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		
		--��������˵ľ������һ��������߱�ɾ��
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			DressPaint_Fitting_OnHiden();								-- �رա���ǶԤ�������¼䣬���ھ���NPC��Զ��Ⱦɫ��������Ѿ��ر��ˣ����Բ���Ҫ���Ⱦɫ׷�١���ť�ˡ�
		end
	end
	
	-- ����
	if event == "SEX_CHANGED" and  this:IsVisible() then
		DressPaint_Fitting_FakeObject : Hide();
		DressPaint_Fitting_FakeObject : Show();
		DressPaint_Fitting_FakeObject : SetFakeObject("DressPaint_Player");
		
	elseif (event == "ADJEST_UI_POS" ) then
		DressPaint_Fitting_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		DressPaint_Fitting_Frame_On_ResetPos()
	end

end

--*******************************************************************************
-- ע�⣡����
-- OnHiden() �����رս����ʱ�򣬲����ٴμ��Ⱦɫ׷�١���ť
-- OnClosed() �����رս����ʱ�򣬻��ٴμ��Ⱦɫ׷�١���ť
-- ��������������ͨ��~~
--*******************************************************************************

----------------------------------------------------------------------------------
--
-- ����
--
function DressPaint_Fitting_OnHiden()
	SetDefaultMouse();

	-- �ָ�����ǰ��װ������
	DressReplaceColor:RestoreDressPaintFitting()
	
	--ȡ������
	this:CareObject(objCared, 0, "DressPaint_Fitting");
	objCared = -1

	this:Hide();
end

----------------------------------------------------------------------------------
--
-- �ر�
--
function DressPaint_Fitting_OnClosed()
	
	-- �ָ�����ǰ��װ������
	DressReplaceColor:RestoreDressPaintFitting()
	
	--ȡ������
	this:CareObject(objCared, 0, "DressPaint_Fitting");
	objCared = -1
	
	this:Hide()

end

----------------------------------------------------------------------------------
--
-- ��ת����ͷ��ģ�ͣ�����)
--
function DressPaint_Fitting_TurnLeft(start)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then	
		--������ת��ʼ
		if(start == 1) then
			DressPaint_Fitting_FakeObject:RotateBegin(-0.3);
		--������ת����
		else
			DressPaint_Fitting_FakeObject:RotateEnd();
		end
	end
end

----------------------------------------------------------------------------------
--
--��ת����ͷ��ģ�ͣ�����)
--
function DressPaint_Fitting_TurnRight(start)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then	
		--������ת��ʼ
		if(start == 1) then
			DressPaint_Fitting_FakeObject:RotateBegin(0.3);
		--������ת����
		else
			DressPaint_Fitting_FakeObject:RotateEnd();
		end
	end
end

function DressPaint_Fitting_Frame_On_ResetPos()
  DressPaint_Fitting_Frame:SetProperty("UnifiedPosition", g_DressPaint_Fitting_Frame_UnifiedPosition);
end