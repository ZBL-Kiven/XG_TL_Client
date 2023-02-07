--UI COMMAND ID 198122

local g_clientNpcId = -1;

local g_ExchangeMaxBangGong = 200; --���Զһ��İﹱ����
local g_ExchangeMinBangGong = 10;	--���Զһ��İﹱ����

local g_GoldTicket_TabelIndex = 40004517;

function Huoyuezhiduixian_PreLoad()

	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	--this:RegisterEvent("UNIT_GUILDPOINT"); --�ﹱ����û��ʵʱˢ�»��ƣ��������Ժͻ�Ա������涼û��

end

function Huoyuezhiduixian_OnLoad()
end

function Huoyuezhiduixian_OnEvent(event)
	if(event == "UI_COMMAND" and tonumber(arg0) == 198122) then
		if this : IsVisible() then									-- ������濪�ţ��򲻴���
			return
		end
		Huoyuezhiduixian_Clear()
		HuoyuezhiDuixian_Moral_Value:SetText("1")
		HuoyuezhiDuixian_Moral_Value:SetProperty("DefaultEditBox", "True");
		HuoyuezhiDuixian_Moral_Value:SetSelected( 0, -1 )
		HuoyuezhiDuixian_Text3:SetText("��Ծֵ����:"..tostring(Player:GetData( "ACTIVEPOINT" )))
		local nPonit = PlayerPackage:GetGoldTickValueByIndex(g_GoldTicket_TabelIndex);
		HuoyuezhiDuixian_Text1:SetText("�̻�������:#{_MONEY"..nPonit.."}")

		this : Show()

		local npcObjId = Get_XParam_INT(0)
		g_clientNpcId = DataPool : GetNPCIDByServerID(npcObjId)
		if g_clientNpcId == -1 then
			PushDebugMessage("δ���� NPC")
			Huoyuezhiduixian_Close()
			return
		end

		this : CareObject( g_clientNpcId, 1, "Huoyuezhiduixian" )
	elseif (event == "OBJECT_CARED_EVENT") then
		if(tonumber(arg0) ~= g_clientNpcId) then
			return;
		end

		--�����NPC�ľ������һ��������߱�ɾ�����Զ��ر�
		if arg1 == "distance" and tonumber(arg2) > MAX_OBJ_DISTANCE or arg1=="destroy" then
			Huoyuezhiduixian_Close()
		end

--	elseif (event == "UNIT_GUILDPOINT" and this:IsVisible()) then
--
--		Huoyuezhiduixian_Moral_Value:SetProperty("DefaultEditBox", "True");
--		Huoyuezhiduixian_Moral_Value:SetSelected( 0, -1 )
--		Huoyuezhiduixian_Text1:SetText("#{BGCH_8901_23}"..tostring(Player:GetData("GUILDPOINT")))

	end

end

function HuoyuezhiDuixian_Cancel_Clicked()
	Huoyuezhiduixian_Close()
end

function Huoyuezhiduixian_Clear()
end

function Huoyuezhiduixian_Close()
	this:Hide()
	this:CareObject(g_clientNpcId, 0, "Huoyuezhiduixian")
	g_clientNpcId = -1
	Huoyuezhiduixian_Clear()
end

function HuoyuezhiDuixian_Count_Change()
	local str = HuoyuezhiDuixian_Moral_Value:GetText()
	local strNumber = 0;

	if ( str == nil ) then
		return;
	elseif( str == "" ) then
		strNumber = 1;
	else
		strNumber = tonumber( str );
	end

	str = tostring( strNumber );
	HuoyuezhiDuixian_Moral_Value:SetTextOriginal( str );

end

function HuoyuezhiDuixian_OK_Clicked()
	local str = HuoyuezhiDuixian_Moral_Value:GetText()
	local nNumber = 0

	if str == nil or str == "" then
		return
	end

	nNumber = tonumber(str)
	if nNumber <= 0 then
		PushDebugMessage("#{XHYZ_100125_12}")
		return
	end

	if nNumber > Player:GetData( "ACTIVEPOINT" ) then
		PushDebugMessage("#{XHYZ_100125_7}") --��Ŀǰ��ӵ�еĻ�Ծֵ�������㣬�޷����ж������������
		return
	end

	if PlayerPackage:GetGoldTickValueByIndex(g_GoldTicket_TabelIndex) == 0 then
		PushDebugMessage("#{XHYZ_100125_6}") --��û���̻��Ʊ���Ʊ���޽�ң��޷����ж��ֲ���
		return
	end

	Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "Huoyuezhiduixian" )
			Set_XSCRIPT_ScriptID( 889203 )
			Set_XSCRIPT_Parameter( 0, nNumber )
			Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()

	Huoyuezhiduixian_Close()
end

--=============================================
--
--=============================================
function HuoyuezhiDuixian_Max_Clicked()
    HuoyuezhiDuixian_Moral_Value:SetText(Player:GetData( "ACTIVEPOINT" ));
    HuoyuezhiDuixian_Moral_Value:SetProperty("DefaultEditBox", "True");
    HuoyuezhiDuixian_Moral_Value:SetSelected( 0, -1 );
end
