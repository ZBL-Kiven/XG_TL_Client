-- --******************************************************************************
-- --
-- -- ֯�ƽ���ᴺ����� by �ܼγ�
-- --
-- --******************************************************************************

local g_Frame_UnifiedPosition
local UI_Command_S = 89301101

local g_objID = -1
local g_objCared = -1
local MAX_OBJ_DISTANCE = 3.0

--ͼƬ
local SpringFestival_PIC = {}
--����
local SpringFestivals_Animation = {}

--��˿
local SpringFestival_needitem = 38000128
local SpringFestival_needitem_Bind = 38000127
local Need_count = 0
local ZhiXiu_Num = 0
local Get_Prize = 0
local Animation_Flag = 0

-- --******************************************************************************

function SpringFestival_NewClothes_PreLoad()

	-- ע���¼�
	this:RegisterEvent("UI_COMMAND")
	-- ��Ϸ���ڳߴ緢���˱仯
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- ��Ϸ�ֱ��ʷ����˱仯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	-- �뿪����
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)	
	-- OBJECT_CARED
	this:RegisterEvent("OBJECT_CARED_EVENT",false)

	this:RegisterEvent("PACKAGE_ITEM_CHANGED")
end

function SpringFestival_NewClothes_OnLoad()

	g_Frame_UnifiedPosition	= SpringFestival_NewClothes_Frame:GetProperty("UnifiedPosition")

	SpringFestival_PIC[1] = SpringFestival_NewClothes_Image1
	SpringFestival_PIC[2] = SpringFestival_NewClothes_Image2
	SpringFestival_PIC[3] = SpringFestival_NewClothes_Image3
	SpringFestival_PIC[4] = SpringFestival_NewClothes_Image4
	SpringFestival_PIC[5] = SpringFestival_NewClothes_Image5
	SpringFestival_PIC[6] = SpringFestival_NewClothes_Image6

	SpringFestivals_Animation[1] = SpringFestival_NewClothes_Animation2
	SpringFestivals_Animation[2] = SpringFestival_NewClothes_Animation2
	SpringFestivals_Animation[3] = SpringFestival_NewClothes_Animation3
	SpringFestivals_Animation[4] = SpringFestival_NewClothes_Animation4
	SpringFestivals_Animation[5] = SpringFestival_NewClothes_Animation5
	SpringFestivals_Animation[6] = SpringFestival_NewClothes_Animation6

end

function SpringFestival_NewClothes_OnEvent( event )

	if ( event == "UI_COMMAND" and tonumber(arg0) == UI_Command_S ) then --xjc1 �򿪽���

		SpringFestival_NewClothes_Clean()

		g_objID = Get_XParam_INT(0)

		g_objCared = DataPool : GetNPCIDByServerID(tonumber(g_objID))
		if g_objCared == -1 then
			PushDebugMessage("server�����������������⡣")
			return
		end
		if nil ~= g_objCared and g_objCared > 0 then
			this:CareObject(g_objCared, 1, "SpringFestival_NewClothes")
		end

		Need_count = Get_XParam_INT(1) --ӵ�н�����˿
		ZhiXiu_Num = Get_XParam_INT(2) --��ǰ��֯��
		Get_Prize =  Get_XParam_INT(3) --��ȡ����
		Animation_Flag = Get_XParam_INT(4) --��ȡ����

		SpringFestival_NewClothes_Set(Need_count, ZhiXiu_Num, Get_Prize, Animation_Flag)

		this:Show()
	elseif ( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() ) then
		local nGemCount_1 = PlayerPackage:Lua_GetUnLockItemCount(SpringFestival_needitem)
		local nGemCount_2 = PlayerPackage:Lua_GetUnLockItemCount(SpringFestival_needitem_Bind)
		local nGemCount = nGemCount_1 + nGemCount_2
		SpringFestival_NewClothes_Text1:SetText( ScriptGlobal_Format("#{ZYJX_211124_11}", nGemCount)) --ӵ�н�����˿��%s0��

	elseif( event == "ADJEST_UI_POS" ) then
		SpringFestival_NewClothes_ResetPos()

	elseif( event == "VIEW_RESOLUTION_CHANGED" ) then
		SpringFestival_NewClothes_ResetPos()

	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		SpringFestival_NewClothes_Close()

	elseif ( event == "OBJECT_CARED_EVENT" and this:IsVisible() ) then
		if(tonumber(arg0) ~= g_objCared) then
			return
        end
        
		-- �����NPC�ľ������һ��������߱�ɾ�����Զ��ر�
        if(arg1 == "distance" and tonumber(arg2) > MAX_OBJ_DISTANCE or arg1=="destroy") then
            SpringFestival_NewClothes_Close()
        end
		
	end

end

--================================================
-- Ĭ�����λ��
--================================================
function SpringFestival_NewClothes_ResetPos()

	SpringFestival_NewClothes_Frame:SetProperty("UnifiedPosition", g_Frame_UnifiedPosition)

end

-- ���ڹر�
function SpringFestival_NewClothes_Close()

	if nil ~= g_objCared and g_objCared > 0 then
		this:CareObject(g_objCared, 0, "SpringFestival_NewClothes")
    end
	
	SpringFestival_NewClothes_Clean()

	this:Hide()

end

function SpringFestival_NewClothes_Click(index)

	if index == 1 then
		--֯��
		Clear_XSCRIPT()
			Set_XSCRIPT_ScriptID(893011)
			Set_XSCRIPT_Function_Name("ZhiXiu")
			Set_XSCRIPT_Parameter( 0, g_objID )
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
	elseif index == 2 then
		--��ȡ����
		Clear_XSCRIPT()
			Set_XSCRIPT_ScriptID(893011)
			Set_XSCRIPT_Function_Name("GetPrize")
			Set_XSCRIPT_Parameter( 0, g_objID )
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
	else
		--Ԥ��
		-- PushDebugMessage("  ")
	end

end

function SpringFestival_NewClothes_Clean()

	Need_count = 0
	ZhiXiu_Num = 0
	Get_Prize = 0
	Animation_Flag = 0

	SpringFestival_PIC[1]:Show()
	SpringFestival_PIC[2]:Hide()
	SpringFestival_PIC[3]:Hide()
	SpringFestival_PIC[4]:Hide()
	SpringFestival_PIC[5]:Hide()
	SpringFestival_PIC[6]:Hide()

	SpringFestivals_Animation[1]:Play(false)
	SpringFestivals_Animation[2]:Play(false)
	SpringFestivals_Animation[3]:Play(false)
	SpringFestivals_Animation[4]:Play(false)
	SpringFestivals_Animation[5]:Play(false)
	SpringFestivals_Animation[6]:Play(false)

	local itemAction = DataPool:CreateActionItemForShow(SpringFestival_needitem_Bind, 1)
	if itemAction:GetID() ~= 0 then
		SpringFestival_NewClothes_Right_Item1:SetActionItem( itemAction:GetID() );
	else
		SpringFestival_NewClothes_Right_Item1:SetActionItem( -1 );
	end
	
	SpringFestival_NewClothes_Text1:SetText( ScriptGlobal_Format("#{ZYJX_211124_11}", 0)) --ӵ�н�����˿��%s0��
	SpringFestival_NewClothes_Text2:SetText( ScriptGlobal_Format("#{ZYJX_211124_12}", 0)) --����ǰ��֯�壺%s0��

	SpringFestival_NewClothes_Button1:Show()
	SpringFestival_NewClothes_Button2:Hide()
	SpringFestival_NewClothes_Received:Hide()

	--SpringFestival_NewClothes_Button3:Show()
end

--��������
function SpringFestival_NewClothes_Set(count, Num, Flag, Animation_Flag)
	--count ӵ�н�����˿ --Num ��ǰ��֯�� --Flag ��ȡ����
	SpringFestival_NewClothes_Text1:SetText( ScriptGlobal_Format("#{ZYJX_211124_11}", count)) --ӵ�н�����˿��%s0��
	SpringFestival_NewClothes_Text2:SetText( ScriptGlobal_Format("#{ZYJX_211124_12}", Num)) --����ǰ��֯�壺%s0��
	
	local Test = Num + 1
	if Test > 6 then
		Test = 6
	elseif Test < 1 then
		Test = 1
	end

	for i = 1, 6 do
		if i == Test then
			SpringFestival_PIC[i]:Show()
			if i ~= 1 and Animation_Flag == 1 then
				SpringFestivals_Animation[i]:Play(true)
			else
				SpringFestivals_Animation[i]:Play(false)
			end	
		else
			SpringFestival_PIC[i]:Hide()
			SpringFestivals_Animation[i]:Play(false)
		end    
	end

	--֯��5�����ϣ���ʾ��ȡ����
	if Num >= 5 then
		SpringFestival_NewClothes_Button1:Hide() --֯�尴ť
		SpringFestival_NewClothes_Button2:Show() --�콱����
		SpringFestival_NewClothes_Received:Hide() --����ȡ
	end

	--����ȡ����ʾ����ȡ����
	if Flag > 0 then
		SpringFestival_NewClothes_Button1:Hide() --֯�尴ť
		SpringFestival_NewClothes_Button2:Hide() --�콱����
		SpringFestival_NewClothes_Received:Show() --����ȡ
	end

end