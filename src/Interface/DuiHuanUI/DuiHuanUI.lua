
local g_DuiHuanUI_Frame_UnifiedPosition;


function DuiHuanUI_PreLoad()
	this:RegisterEvent("UI_COMMAND");
		-- ��Ϸ���ڳߴ緢���˱仯
	this:RegisterEvent("ADJEST_UI_POS")
	-- ��Ϸ�ֱ��ʷ����˱仯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("SCENE_TRANSED")
end


function DuiHuanUI_OnLoad()--����
	DuiHuanUI_Bk_Icon = {
		DuiHuanUI_Bk_Icon1	,
		DuiHuanUI_Bk_Icon2	,
		DuiHuanUI_Bk_Icon3	,
		DuiHuanUI_Bk_Icon4	,
		DuiHuanUI_Bk_Icon5	,
		DuiHuanUI_Bk_Icon6	,
		DuiHuanUI_Bk_Icon7	,
		DuiHuanUI_Bk_Icon8	,
		DuiHuanUI_Bk_Icon9	,
		DuiHuanUI_Bk_Icon10	,
		DuiHuanUI_Bk_Icon11	,
		DuiHuanUI_Bk_Icon12	,
		DuiHuanUI_Bk_Icon13	,
		DuiHuanUI_Bk_Icon14	,
		DuiHuanUI_Bk_Icon15	,
		DuiHuanUI_Bk_Icon16	,
		DuiHuanUI_Bk_Icon17	,
		DuiHuanUI_Bk_Icon18	,
		DuiHuanUI_Bk_Icon19	,
		DuiHuanUI_Bk_Icon20	,
		DuiHuanUI_Bk_Icon21	,
		DuiHuanUI_Bk_Icon22	,
		DuiHuanUI_Bk_Icon23	,
		DuiHuanUI_Bk_Icon24	,
		DuiHuanUI_Bk_Icon25	,
		DuiHuanUI_Bk_Icon26	,
		DuiHuanUI_Bk_Icon27	,
		DuiHuanUI_Bk_Icon28	,
		DuiHuanUI_Bk_Icon29	,
		DuiHuanUI_Bk_Icon30	,
		DuiHuanUI_Bk_Icon31	,
		DuiHuanUI_Bk_Icon32	,
		DuiHuanUI_Bk_Icon33	,
		DuiHuanUI_Bk_Icon34	,
		DuiHuanUI_Bk_Icon35	,
		DuiHuanUI_Bk_Icon36	,
		DuiHuanUI_Bk_Icon37	,
		DuiHuanUI_Bk_Icon38	,
		DuiHuanUI_Bk_Icon39	,
		DuiHuanUI_Bk_Icon40	,
		DuiHuanUI_Bk_Icon41	,
		DuiHuanUI_Bk_Icon42	,
		DuiHuanUI_Bk_Icon43	,
		DuiHuanUI_Bk_Icon44	,
		DuiHuanUI_Bk_Icon45	,
		DuiHuanUI_Bk_Icon46	,
		DuiHuanUI_Bk_Icon47	,
		DuiHuanUI_Bk_Icon48	,
		DuiHuanUI_Bk_Icon49	,
		DuiHuanUI_Bk_Icon50,
		DuiHuanUI_Bk_Icon51,
		DuiHuanUI_Bk_Icon52,
		DuiHuanUI_Bk_Icon53,
		DuiHuanUI_Bk_Icon54,
		DuiHuanUI_Bk_Icon55,
		DuiHuanUI_Bk_Icon56,
		DuiHuanUI_Bk_Icon57,
		DuiHuanUI_Bk_Icon58,
		DuiHuanUI_Bk_Icon59,
		DuiHuanUI_Bk_Icon60,
		DuiHuanUI_Bk_Icon61,
		DuiHuanUI_Bk_Icon62,
		DuiHuanUI_Bk_Icon63,
		DuiHuanUI_Bk_Icon64,
		DuiHuanUI_Bk_Icon65,
		DuiHuanUI_Bk_Icon66,
		DuiHuanUI_Bk_Icon67,
		DuiHuanUI_Bk_Icon68,
		DuiHuanUI_Bk_Icon69,
		DuiHuanUI_Bk_Icon70,
	}
   g_DuiHuanUI_Frame_UnifiedPosition=DuiHuanUI_Frame:GetProperty("UnifiedPosition");
end

function DuiHuanUI_ResetPos()-- ��Ϸ���ڳߴ緢���˱仯
  DuiHuanUI_Frame:SetProperty("UnifiedPosition", g_DuiHuanUI_Frame_UnifiedPosition);
end
function DuiHuanUI_qingchushuju() --�������
	for i=1,table.getn(DuiHuanUI_Bk_Icon) do
		DuiHuanUI_Bk_Icon[i]:Hide()--����������
	end
end

local szSeparator=","
local yixuanzeID = 0 --ѡ��ĵ���
local fanhuiID = 0 --���ؽű�ID
local shuzu = {}
local shuzu2 = {}


function DuiHuanUI_Split(szFullString, szSeparator)
	local nFindStartIndex = 1    
	local nSplitIndex = 1    
	local nSplitArray = {}    
	while true do    
		local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)    
		if not nFindLastIndex then    
			nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))    
			break    
		end    
		nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)    
		nFindStartIndex = nFindLastIndex + string.len(szSeparator)    
		nSplitIndex = nSplitIndex + 1    
	end
	return nSplitArray
end




function DuiHuanUI_OnEvent(event)
	if event == "UI_COMMAND"  and tonumber(arg0) == 20170204 then   ---��������
		fanhuiID = Get_XParam_INT(0)
		DuiHuanUI_qingchushuju() --���������й���
		
		if Get_XParam_STR(1) ~= nil then
			shuzu = DuiHuanUI_Split(Get_XParam_STR(1), szSeparator) --���ı��������
		end
		--�������
		for i=1,table.getn(shuzu) do
			if shuzu[i]~="" then
				shuzu[i]=tostring(tonumber("0x"..shuzu[i],16))
			end
		end
		for i=1,table.getn(shuzu) do
			if shuzu[i] ~= nil and shuzu[i] ~= "" and tonumber(shuzu[i]) > 10000000 then
				DuiHuanUI_Bk_Icon[i]:Show();
				local PrizeAction = GemMelting:UpdateProductAction(tonumber(shuzu[i]))
				DuiHuanUI_Bk_Icon[i]:SetActionItem(PrizeAction:GetID()); --��ʾ��Ʒ
			end
		end
		
		
		
		DuiHuanUI_DragTitle:SetText("#gFF0FA0"..Get_XParam_STR(0)) --�һ�ϵͳ
		DuiHuanUI_Frame_Texta1:SetText("��δѡ�����") --����ѡ��һ���
		DuiHuanUI_Frame_Texta2:SetText("") --�һ�������ߣ�
		DuiHuanUI_Frame_Texta3:SetText("") --��������������
		DuiHuanUI_OK:Disable();--�ڵ��һ�

		
		this:Show();
		
		
	elseif event == "UI_COMMAND"  and tonumber(arg0) == 20170205 then   ---��������
		if Get_XParam_STR(0) ~= nil then
			shuzu2 = DuiHuanUI_Split(Get_XParam_STR(0), szSeparator) --���ı��������
		end
		yixuanzeID = Get_XParam_INT(0)
		DuiHuanUI_Clicked2(yixuanzeID) --ѡ��
		
	elseif( event == "ADJEST_UI_POS" ) then
		DuiHuanUI_ResetPos()
	elseif( event == "VIEW_RESOLUTION_CHANGED" ) then
		DuiHuanUI_ResetPos()
	elseif (event == "SCENE_TRANSED") then
		this:Hide()--����������
	end
end


function DuiHuanUI_Clicked(nIndex) --ѡ��
	for i=1,table.getn(DuiHuanUI_Bk_Icon) do
		DuiHuanUI_Bk_Icon[i]:SetPushed(0);--��յ�ѡ
	end
	-- ִ�нű�
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "GetGiftsForUI" ); 	-- �ű���������
		Set_XSCRIPT_ScriptID( 889064 );-- �ű����
		Set_XSCRIPT_Parameter( 0, -131495 );	-- ����һ
		Set_XSCRIPT_Parameter( 1, tonumber( nIndex ) );	-- ����һ
		Set_XSCRIPT_Parameter( 2, tonumber(shuzu[nIndex]) );	-- ����һ
		Set_XSCRIPT_ParamCount( 3 );						-- ��������
	Send_XSCRIPT()
end

function DuiHuanUI_Clicked2(nIndex) --ѡ��
	DuiHuanUI_Bk_Icon[nIndex]:SetPushed(1);--��ѡ
	DuiHuanUI_OK:Enable(); --���һ�
	DuiHuanUI_Frame_Texta1:SetText("#G�һ�#W["..shuzu2[1].."]") --����ѡ��һ���
	DuiHuanUI_Frame_Texta2:SetText("#G��Ҫ"..shuzu2[2]) --�һ�������ߣ�
	DuiHuanUI_Frame_Texta3:SetText("") --��������������
end

--ѡ��
function DuiHuanUI_OK_Clicked(nIndex) --ȷ��
	-- ִ�нű�
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "GetGiftsForUI" ); 	-- �ű���������
		Set_XSCRIPT_ScriptID( 889064 );						-- �ű����
		Set_XSCRIPT_Parameter( 0, -131494 );	-- ����һ
		Set_XSCRIPT_Parameter( 1, tonumber( 0 ) );	-- ����һ
		Set_XSCRIPT_Parameter( 2, tonumber(shuzu[yixuanzeID]) );	-- ����һ
		Set_XSCRIPT_ParamCount( 3 );						-- ��������
	Send_XSCRIPT()
end



