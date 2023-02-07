--*******************************************
--���֔�����ԭ���£� Q546528533
--*******************************************
local g_Frame_UnifiedXPosition;
local g_Frame_UnifiedYPosition;
local g_start_time = 0
local g_end_time = 0
local nUItype = 0
local nMenPaiName = {"����","����","ؤ��","�䵱","����","����","����","��ɽ","��ң","","����ɽׯ","����","���"}
local acme_list = {}
function Mingdong_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	-- ��Ϸ���ڳߴ緢���˱仯
	this:RegisterEvent("ADJEST_UI_POS")
	-- ��Ϸ�ֱ��ʷ����˱仯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("SCENE_TRANSED")	
end

function Mingdong_OnLoad()	
	-- ��������Ĭ�����λ��
	g_Frame_UnifiedXPosition	= Mingdong_Frame:GetProperty("UnifiedXPosition");
	g_Frame_UnifiedYPosition	= Mingdong_Frame:GetProperty("UnifiedYPosition");
end



function Mingdong_OnEvent(event)
	
	if	event == "UI_COMMAND"  and tonumber(arg0) == 201812291 then   ---�״γ�ֵ
		local acme_LinShi = {}
		acme_list = {}
		for i = 1,10 do
		    acme_LinShi[i] = Get_XParam_STR(i-1)
		end
		for i = 1,table.getn(acme_LinShi) do
			if acme_LinShi[i] ~= "" and acme_LinShi[i] ~= nil then
				acme_list[i] = Split(acme_LinShi[i], ",")
			end
		end
		Mingdong_Title:SetText("#gFF0FA0����������")
		-- Mingdong_Paihang_Info:SetText(string.format("    #G%s#cfff263��#G%s#cfff263�ڼ�����񵥣��������ĵ�һ����ȡ���㣬����#GԪ���һ�#cfff263ʱ#G����ֵ#cfff263������������õ�����ֵ�ﵽ#G600��#cfff263���л�����ȡս����¥��#r    #G����Զ��:����ǰ#cfff263ս����¥���ۼƻ������ֵ����1-10λ����ң����Ը���������ò�ͬ�Ľ���#Y��#rע�⣺���һ���24����ֵ�޷��ۼƵ����а��ڣ��콱ʱ��Ϊ�ڶ��죬����������޷���ȡ��",g_start_time,g_end_time))		
		-- Mingdong_Paihang_PlayerNameText2:SetText("���ʱ����������ȡ")
		-- local Nian,yue,ri = math.floor(g_end_time/10000),math.mod(math.floor(g_end_time/100),100),math.mod(g_end_time,100)
		-- Mingdong_Paihang_Accumulate2:SetText(string.format("#cfff263%s��%s��%s��24�㿪������������ǰ������ҿ���ȡ",Nian,yue,ri))
		-- Mingdong_Paihang_Accumulate:SetText(string.format("#cfff263������ڻ�õĵ���Ϊ#G%s#cfff263��",DataPool:GetPlayerMission_DataRound(506)))
		-- Mingdong_Paihang_LastTime:SetText(string.format("#cfff263��������佱�Ŀ���ʱ��ʣ�ࣺ#G%s",g_end_time - g_start_time))
		MingDong_UpateData()
	elseif 	event == "UI_COMMAND"  and tonumber(arg0) == 201812292 then
		Mingdong_Paihang_Info:SetText(Get_XParam_STR(0))
		Mingdong_Paihang_Accumulate2:SetText("#cfff263�����������Ҳ��콱��ť������ȡ����ȡǰ��Ԥ���㹻�ı����ռ䡣")
		Mingdong_Paihang_Accumulate:SetText(string.format("#cfff263��ڼ��ۼƻ�õ�����ֵΪ#G%s#cfff263��",Get_XParam_STR(2)))
		Mingdong_Paihang_LastTime:SetText(string.format("#cfff263������������Ľ���ʱ��ʣ�ࣺ#G%s",Get_XParam_STR(3)))
	elseif ( event == "ADJEST_UI_POS" ) then
		Mingdong_ResetPos()
	elseif ( event == "VIEW_RESOLUTION_CHANGED" ) then
		Mingdong_ResetPos()
	elseif (event == "SCENE_TRANSED") then
		this:Hide()
	end
end


function MingDong_UpateData()
    Mingdong_Paihang_TopList:RemoveAllItem()
    for i = 1,table.getn(acme_list) do
	    if acme_list[i] ~= nil then
			Mingdong_Paihang_TopList:AddNewItem( "#G"..i.."", 0, i-1 )
			Mingdong_Paihang_TopList:AddNewItem( "#cFF0000"..acme_list[i][1], 1, i-1 )
			Mingdong_Paihang_TopList:AddNewItem( "#c66ffff"..nMenPaiName[tonumber(acme_list[i][2])+1], 2, i-1 )
			Mingdong_Paihang_TopList:AddNewItem( "#cff99ff"..acme_list[i][3], 3, i-1 )
			Mingdong_Paihang_TopList:AddNewItem( "#cfff263"..acme_list[i][4], 4, i-1 )
		end
	end
    this:Show()
	MingDong_GetServerDataInfo()
end

function MingDong_GetServerDataInfo()
	Clear_XSCRIPT()
	    Set_XSCRIPT_Function_Name("acme_OhterInfo");
	    Set_XSCRIPT_ScriptID(900037);
	    Set_XSCRIPT_ParamCount(0);
	Send_XSCRIPT()
end

function Mingdong_Paihang_Prize()
	Clear_XSCRIPT()
	    Set_XSCRIPT_Function_Name("ZhanQuMingDong");
	    Set_XSCRIPT_ScriptID(900037);
	    Set_XSCRIPT_ParamCount(0);
	Send_XSCRIPT()
end

function Mingdong_ResetPos()
	Mingdong_Frame:SetProperty("UnifiedXPosition", g_Frame_UnifiedXPosition);
	Mingdong_Frame:SetProperty("UnifiedYPosition", g_Frame_UnifiedYPosition);
end





