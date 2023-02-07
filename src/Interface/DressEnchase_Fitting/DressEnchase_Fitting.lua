-- ʱװ��Ƕ���¼�

local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0

local g_DressEnchase_Fitting_Frame_UnifiedPosition;

function DressEnchase_Fitting_PreLoad()
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OPEN_DRESS_ENCHASE_FITTING");
	this:RegisterEvent("CLOSE_DRESS_ENCHASE_FITTING");	
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("OPEN_STALL_SALE");
	this:RegisterEvent("PROGRESSBAR_SHOW");	
	this:RegisterEvent("OPEN_EQUIP");
	this:RegisterEvent("SEX_CHANGED");
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("YIGUI_OPEN",false)
end

function DressEnchase_Fitting_OnLoad()
	g_DressEnchase_Fitting_Frame_UnifiedPosition=DressEnchase_Fitting_Frame:GetProperty("UnifiedPosition");
end

function DressEnchase_Fitting_OnEvent(event)
	
	-- �뿪��Ϸ����
	if ( event == "PLAYER_ENTERING_WORLD" ) then
		if this:IsVisible() then
			DressEnchase_Fitting_OnHiden();
		end
	end
	
	-- ��Ƕ�ɹ���������¼俪�ţ����ȹر�
	if event == "UI_COMMAND" and tonumber(arg0) == 09111602 then		
		if this:IsVisible() then
			DressEnchase_Fitting_OnHiden();										-- �رա���ǶԤ�������¼䣬�������������Ʒ�����ݶ�û�ˣ����Բ��ܼ����ǶԤ������ť
		end
	end
	
	-- �ر����¼�
	if (event == "CLOSE_DRESS_ENCHASE_FITTING") then		
		if this:IsVisible() then
			DressEnchase_Fitting_OnHiden();										-- �����������߼���������Ʒ���ϸ�رյ����¼䣬���Բ��ܼ����ǶԤ������ť
		end
	end
	
	-- ��ʼ��̯
	if ( event == "OPEN_STALL_SALE" ) then
		if (this:IsVisible()) then
			DressEnchase_Fitting_OnClosed();										-- �رա���ǶԤ�������¼䣬���¼����ǶԤ������ť
		end
	end
	
	-- ����������
	if ( event == "PROGRESSBAR_SHOW" ) then
		if (this:IsVisible()) then
			DressEnchase_Fitting_OnClosed();									-- �رա���ǶԤ�������¼䣬���¼����ǶԤ������ť
		end
	end
	
	-- ���µ�ʱ���ܴ򿪽�ɫ���ϴ���
	if ( event == "OPEN_EQUIP" ) then
		if (this:IsVisible()) then
			DressEnchase_Fitting_OnClosed();									-- �رա���ǶԤ�������¼䣬���¼����ǶԤ������ť
		end
	end
	
	-- ���µ�ʱ���ܴ��¹񴰿�
	if ( event == "YIGUI_OPEN" ) then
		if (this:IsVisible()) then
			DressEnchase_Fitting_OnClosed();									-- �رա���ǶԤ�������¼䣬���¼����ǶԤ������ť
		end
	end
	
	-- �����¼�
	if(event == "OPEN_DRESS_ENCHASE_FITTING") then
		
		-- ���¼����ǶԤ������ť
		if (IsWindowShow("Dress_Enchase")) then
			DressEnchasing : EnableDressEnchasePreview()
		end

		-- ����
		local nDressBagPos	= tonumber(arg0)
		local nGemBagPos		= tonumber(arg1)
		DressEnchasing : FittingOnDress (nDressBagPos, nGemBagPos)
		this:Show();
		
		-- ����ʹ���ĸ�ģ��
		DressEnchase_Fitting_FakeObject : SetFakeObject("");	
		DressEnchase_Fitting_FakeObject : SetFakeObject("DressEnchase_Player");
				
		-- ��ʼ����NPC
		local npcID = Get_XParam_INT(0);
		local objCared = DataPool : GetNPCIDByServerID(npcID);
		if objCared == -1 then
			return;
		end		
		this:CareObject(objCared, 1, "DressEnchase_Fitting");
	end	
	
	-- ����NPC
	if (event == "OBJECT_CARED_EVENT") then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		
		--��������˵ľ������һ��������߱�ɾ�����Զ��ر�
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			if this:IsVisible() then
				DressEnchase_Fitting_OnHiden();								-- �رա���ǶԤ�������¼䣬���ھ���NPC��Զ����Ƕ��������Ѿ��ر��ˣ����Բ���Ҫ�����ǶԤ������ť�ˡ�
			end
		end
	end
	
	-- ����
	if event == "SEX_CHANGED" and  this:IsVisible() then
		DressEnchase_Fitting_FakeObject : Hide();
		DressEnchase_Fitting_FakeObject : Show();
		DressEnchase_Fitting_FakeObject : SetFakeObject("DressEnchase_Player")
		
	elseif (event == "ADJEST_UI_POS" ) then
		DressEnchase_Fitting_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		DressEnchase_Fitting_Frame_On_ResetPos()
	end

end

--*******************************************************************************
-- ע�⣡����
-- OnHiden() �����رս����ʱ�򣬲����ٴμ����ǶԤ������ť
-- OnClosed() �����رս����ʱ�򣬻��ٴμ����ǶԤ������ť
-- ��������������ͨ��~~
--*******************************************************************************

----------------------------------------------------------------------------------
--
-- ����
--
function DressEnchase_Fitting_OnHiden()
	SetDefaultMouse();

	-- �ָ�����ǰ��װ������
	DressEnchasing : RestoreDressEnchaseFitting()
	DressEnchase_Fitting_FakeObject:SetFakeObject("")
	--ȡ������
	this:CareObject(objCared, 0, "DressEnchase_Fitting");
	objCared = -1

	this:Hide();
end

----------------------------------------------------------------------------------
--
-- �ر�
--
function DressEnchase_Fitting_OnClosed()
	
	-- �ָ�����ǰ��װ������
	DressEnchasing : RestoreDressEnchaseFitting()	
	
	--ȡ������
	this:CareObject(objCared, 0, "DressEnchase_Fitting");
	objCared = -1

	-- ���¼����ǶԤ������ť
	if (IsWindowShow("Dress_Enchase")) then
		DressEnchasing : EnableDressEnchasePreview()
	end
	
	this:Hide();

end

----------------------------------------------------------------------------------
--
-- ��ת����ͷ��ģ�ͣ�����)
--
function DressEnchase_Fitting_TurnLeft(start)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then	
		--������ת��ʼ
		if(start == 1) then
			DressEnchase_Fitting_FakeObject:RotateBegin(-0.3);
		--������ת����
		else
			DressEnchase_Fitting_FakeObject:RotateEnd();
		end
	end
end

----------------------------------------------------------------------------------
--
--��ת����ͷ��ģ�ͣ�����)
--
function DressEnchase_Fitting_TurnRight(start)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then	
		--������ת��ʼ
		if(start == 1) then
			DressEnchase_Fitting_FakeObject:RotateBegin(0.3);
		--������ת����
		else
			DressEnchase_Fitting_FakeObject:RotateEnd();
		end
	end
end

function DressEnchase_Fitting_Frame_On_ResetPos()
  DressEnchase_Fitting_Frame:SetProperty("UnifiedPosition", g_DressEnchase_Fitting_Frame_UnifiedPosition);
end