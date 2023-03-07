--���ļ����������QQ14993663 
--**--**--**--**--**--**--**--**--
local g_Frame_UnifiedXPosition;
local g_Frame_UnifiedYPosition;
local sceninfog = {}
local sceninfo1 = {}
local sceninfo2 = {}
local sceninfo3 = {}
local sceninfo4 = {}
local sceninfo5 = {}
local List_String = {}
local axiaocs = 1
function Agname_Kong_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
end
function Agname_Kong_()
	Agname_Kong_List:ClearListBox()
	for i = 1, 54 do
		Agname_Kong_List:AddItem(List_String[i], i - 1);
	end
	this:Show()
end
function Agname_Kong_OnEvent(event)
	if (event == "UI_COMMAND" and tonumber(arg0) == 20170503) then
		Agname_Kong_()
		Agname_Kong_Load(1)
	end
	if (event == "PLAYER_LEAVE_WORLD") then
		this:Hide();
	elseif (event == "ADJEST_UI_POS") then
		Agname_Kong_ResetPos()
	end
end
function Agname_Kong_OnLoad()
	List_String[1] = "#G����������鿴����"
	List_String[2] = "#-39#cfff263���ġ�#cfff263ǧ�����"
	List_String[3] = "#-39#cfff263��ԭ��#cfff263����ڤ"
	List_String[4] = "#-39#cfff263��ɽ��#cfff263�������"
	List_String[5] = "#-39#cfff263���䡤#cfff263ç�����"
	List_String[6] = "#-38#cfff263��Ĺ1�㡤#cfff263��"
	List_String[7] = "#-38#cfff263��Ĺ2�㡤#cfff263��ħ"
	List_String[8] = "#-38#cfff263��Ĺ3�㡤#cfff263��˿֩����"
	List_String[9] = "#-38#cfff263��Ĺ4�㡤#cfff263��ʮ����"
	List_String[10] = "#-38#cfff263��Ĺ5�㡤#cfff263����ħ"
	List_String[11] = "#-38#cfff263��Ĺ6�㡤#cfff263�׵۵���Ӱ"
	List_String[12] = "#-38#cfff263��Ĺ7�㡤#cfff263ڤ��"
	List_String[13] = "#-38#cfff263��Ĺ8�㡤#cfff263Ѫ����"
	List_String[14] = "#-38#cfff263��Ĺ9�㡤#cfff263�������"
	List_String[15] = "#-40#cfff263�ع�1�㡤#cfff263�Ľ�����"
	List_String[16] = "#-40#cfff263�ع�2�㡤#cfff263�������"
	List_String[17] = "#-40#cfff263�ع�3�㡤#cfff263�ػ�֮��"
	List_String[18] = "#-41#cfff263�ر�ͼ��#cfff263�ᱦ����"
	List_String[19] = "#-41#cfff263���ض���#cfff263��������"
	List_String[20] = "#-41#cfff263���䵺��#cfff263��������"
	List_String[21] = "#-41#cfff263ʥ��ɽ��#cfff263ǧ������"
	List_String[22] = "#-42#cfff263����ѩԭ��#cfff263�����"
	List_String[23] = "#-42#cfff263Ħ�¶���#cfff263����Ӱ��"
	List_String[24] = "#-42#cfff263���ض���#cfff263ľͰ��"
	List_String[25] = "#-42#cfff263���ӹ���#cfff263˪Ӱ"
	List_String[26] = "#-43#cfff263�������췴����"
	List_String[27] = "#-43#cfff263������͵Ϯ����"
	List_String[28] = "#-43#cfff263������������"
	List_String[29] = "#-43#cfff263������������"
	List_String[30] = "#-43#cfff263��������翷�"
	List_String[31] = "#-43#cfff263�������ľ�ׯ"
	List_String[32] = "#-43#cfff263��������ʥ��Ϯ"
	List_String[33] = "#-43#cfff263������ʮ��ɱ��"
	
	List_String[34] = "#-44#cfff263����ɽ����"
	List_String[35] = "#-45#cfff263�ػͱ�Ӷ"
	List_String[36] = "#-45#cfff263��ɽľ��"
	List_String[37] = "#-46#cfff263�㱱��"
	List_String[38] = "#-46#cfff263��������"
	List_String[39] = "#-40#cfff263��Ϫʯ��"
	List_String[40] = "#-41#cfff263÷������"
	List_String[41] = "#-41#cfff263��������"
	List_String[42] = "#-42#cfff263��������"
	List_String[43] = "#-42#cfff263�Ϻ����"
	
	sceninfo1 = {
		{ str = "����", Num = Agname_Kong_goto1 },
		{ str = "����У��", Num = Agname_Kong_goto2 },
		{ str = "�����̻�", Num = Agname_Kong_goto3 },
		{ str = "����", Num = Agname_Kong_goto4 },
		{ str = "����������", Num = Agname_Kong_goto5 },
		{ str = "��������", Num = Agname_Kong_goto6 },
		{ str = "���û�", Num = Agname_Kong_goto7 },
		{ str = "��������", Num = Agname_Kong_goto8 },
		{ str = "����ϵͳ", Num = Agname_Kong_goto9 },
		{ str = "Ⱦɫ��׺", Num = Agname_Kong_goto10 },
		{ str = "����", Num = Agname_Kong_goto11 },
		{ str = "��ң", Num = Agname_Kong_goto12 },
		{ str = "����", Num = Agname_Kong_goto13 },
		{ str = "��ɽ", Num = Agname_Kong_goto14 },
		{ str = "����", Num = Agname_Kong_goto15 },
		{ str = "����", Num = Agname_Kong_goto16 },
		{ str = "�䵱", Num = Agname_Kong_goto17 },
		{ str = "����", Num = Agname_Kong_goto18 },
		{ str = "ؤ��", Num = Agname_Kong_goto19 },
		{ str = "����ɽׯ", Num = Agname_Kong_goto20 },
		{ str = "������������", Num = Agname_Kong_goto21 },
		{ str = "�� �� ��", Num = Agname_Kong_goto26 },
		{ str = "Ħ �� ��", Num = Agname_Kong_goto27 },
		{ str = "�� Ĺ һ", Num = Agname_Kong_goto28 },
		{ str = "�� �� ��", Num = Agname_Kong_goto29 },
		{ str = "���������", Num = Agname_Kong_goto30 },
		
	}
	
	sceninfo2 = {
		{ str = "����", Num = Agname_Kong_goto1 },
		{ str = "����", Num = Agname_Kong_goto2 },
		{ str = "��Ȫ", Num = Agname_Kong_goto3 },
		{ str = "����", Num = Agname_Kong_goto4 },
		{ str = "�㱱", Num = Agname_Kong_goto5 },
		{ str = "��ɽ", Num = Agname_Kong_goto6 },
		{ str = "ʯ��", Num = Agname_Kong_goto7 },
		{ str = "��ԭ", Num = Agname_Kong_goto8 },
		{ str = "÷��", Num = Agname_Kong_goto9 },
		{ str = "����", Num = Agname_Kong_goto10 },
		{ str = "��Ϫ", Num = Agname_Kong_goto11 },
		{ str = "�Ϻ�", Num = Agname_Kong_goto12 },
		{ str = "��گ", Num = Agname_Kong_goto13 },
		{ str = "�置", Num = Agname_Kong_goto14 },
		{ str = "����", Num = Agname_Kong_goto15 },
		{ str = "����ɽ", Num = Agname_Kong_goto16 },
		{ str = "������", Num = Agname_Kong_goto17 },
	}
	
	sceninfo3 = {
		{ str = "ľͰ��", Num = Agname_Kong_goto1 },
		{ str = "����Ӱ��", Num = Agname_Kong_goto2 },
		{ str = "�ع��ػ�", Num = Agname_Kong_goto3 },
		{ str = "�����", Num = Agname_Kong_goto4 },
		{ str = "ʥ�ޱ���", Num = Agname_Kong_goto5 },
		{ str = "���ı���", Num = Agname_Kong_goto6 },
		{ str = "������", Num = Agname_Kong_goto7 },
		{ str = "��ɽ���", Num = Agname_Kong_goto8 },
		{ str = "��ԭС��", Num = Agname_Kong_goto9 },
		{ str = "ʥ������", Num = Agname_Kong_goto10 },
		{ str = "#G����BOOS", Num = Agname_Kong_goto11 },
		{ str = "#G����Ⱥ��", Num = Agname_Kong_goto12 },
		{ str = "��������", Num = Agname_Kong_goto13 },
		{ str = "�置����", Num = Agname_Kong_goto14 },
		{ str = "�Ϻ�����", Num = Agname_Kong_goto15 },
		{ str = "����������", Num = Agname_Kong_goto16 },
	}
	
	sceninfo4 = {
		{ str = "������", Num = Agname_Kong_goto1 },
		{ str = "������", Num = Agname_Kong_goto2 },
		{ str = "������", Num = Agname_Kong_goto3 },
		{ str = "��翷�", Num = Agname_Kong_goto4 },
		{ str = "ʮ��ɱ��", Num = Agname_Kong_goto5 },
		{ str = "ˮ��ɽׯ", Num = Agname_Kong_goto6 },
		{ str = "�ٱ�����", Num = Agname_Kong_goto7 },
		{ str = "���ľ���", Num = Agname_Kong_goto8 },
		{ str = "���˿����", Num = Agname_Kong_goto9 },
		{ str = "��������", Num = Agname_Kong_goto11 },
		{ str = "��������", Num = Agname_Kong_goto12 },
		{ str = "��������", Num = Agname_Kong_goto13 },
	}
	
	sceninfo5 = {
		{ str = "����ɽ", Num = Agname_Kong_goto1 },
		{ str = "�ػ�", Num = Agname_Kong_goto2 },
		{ str = "��ɽ", Num = Agname_Kong_goto3 },
		{ str = "�㱱", Num = Agname_Kong_goto6 },
		{ str = "����", Num = Agname_Kong_goto7 },
		{ str = "��Ϫ", Num = Agname_Kong_goto8 },
		{ str = "÷��", Num = Agname_Kong_goto11 },
		{ str = "����", Num = Agname_Kong_goto12 },
		{ str = "����", Num = Agname_Kong_goto13 },
		{ str = "�Ϻ�", Num = Agname_Kong_goto14 },
		{ str = "ľͰ��", Num = Agname_Kong_goto21 },
		{ str = "����Ӱ��", Num = Agname_Kong_goto22 },
		{ str = "�ع��ػ�", Num = Agname_Kong_goto23 },
		{ str = "�����", Num = Agname_Kong_goto24 },
		{ str = "ʥ�ޱ���", Num = Agname_Kong_goto25 },
		{ str = "���ı���", Num = Agname_Kong_goto26 },
		{ str = "������", Num = Agname_Kong_goto27 },
		{ str = "��ɽ���", Num = Agname_Kong_goto28 },
		{ str = "��ԭС��", Num = Agname_Kong_goto29 },
		{ str = "ʥ������", Num = Agname_Kong_goto30 },
	}
	sceninfog[1] = Agname_Kong_goto1
	sceninfog[2] = Agname_Kong_goto2
	sceninfog[3] = Agname_Kong_goto3
	sceninfog[4] = Agname_Kong_goto4
	sceninfog[5] = Agname_Kong_goto5
	sceninfog[6] = Agname_Kong_goto6
	sceninfog[7] = Agname_Kong_goto7
	sceninfog[8] = Agname_Kong_goto8
	sceninfog[9] = Agname_Kong_goto9
	sceninfog[10] = Agname_Kong_goto10
	sceninfog[11] = Agname_Kong_goto11
	sceninfog[12] = Agname_Kong_goto12
	sceninfog[13] = Agname_Kong_goto13
	sceninfog[14] = Agname_Kong_goto14
	sceninfog[15] = Agname_Kong_goto15
	sceninfog[16] = Agname_Kong_goto16
	sceninfog[17] = Agname_Kong_goto17
	sceninfog[18] = Agname_Kong_goto18
	sceninfog[19] = Agname_Kong_goto19
	sceninfog[20] = Agname_Kong_goto20
	sceninfog[21] = Agname_Kong_goto21
	sceninfog[22] = Agname_Kong_goto22
	sceninfog[23] = Agname_Kong_goto23
	sceninfog[24] = Agname_Kong_goto24
	sceninfog[25] = Agname_Kong_goto25
	sceninfog[26] = Agname_Kong_goto26
	sceninfog[27] = Agname_Kong_goto27
	sceninfog[28] = Agname_Kong_goto28
	sceninfog[29] = Agname_Kong_goto29
	sceninfog[30] = Agname_Kong_goto30
	
	g_Frame_UnifiedXPosition = Agname_Kong_Frame:GetProperty("UnifiedXPosition");
	g_Frame_UnifiedYPosition = Agname_Kong_Frame:GetProperty("UnifiedYPosition");
end

function Agname_Kong_List_Selected()
	local nSelIndex = Agname_Kong_List:GetFirstSelectItem();
	if nSelIndex == -1 then
		return
	end
	if nSelIndex == 1 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3000);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27������Ʒ��Ԫ��Ʊ1000,�����,���ʯ,�����ֹ�����,������,�ͼ���ʯ�ϳ�,���ɼ�����,�ļ���ʯ,�����ݣ�#r#-23ˢ��ʱ�䣺ͬ���ٷ�")
	end
	if nSelIndex == 2 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3001);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27������Ʒ��Ԫ��Ʊ1000,�����,���ʯ,�����ֹ�����,������,�ͼ���ʯ�ϳ�,���ɼ�����,�ļ���ʯ,�����ݣ�#r#-23ˢ��ʱ�䣺ͬ���ٷ�")
	end
	if nSelIndex == 3 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3002);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27������Ʒ��Ԫ��Ʊ1000,�����,���ʯ,�����ֹ�����,������,�ͼ���ʯ�ϳ�,���ɼ�����,�ļ���ʯ,�����ݣ�#r#-23ˢ��ʱ�䣺ͬ���ٷ�")
	end
	if nSelIndex == 4 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3003);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27������Ʒ��Ԫ��Ʊ1000,�����,���ʯ,�����ֹ�����,������,�ͼ���ʯ�ϳ�,���ɼ�����,�ļ���ʯ,�����ݣ�#r#-23ˢ��ʱ�䣺ͬ���ٷ�")
	end
	
	if nSelIndex == 5 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3004);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27������Ʒ��Ԫ��Ʊ600,�ļ���ʯ,���˿,�����ݣ�#r#-23ˢ��ʱ�䣺ͬ���ٷ�")
	end
	if nSelIndex == 6 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3005);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27������Ʒ��Ԫ��Ʊ600,�ļ���ʯ,���˿,�����ݣ�#r#-23ˢ��ʱ�䣺ͬ���ٷ�")
	end
	if nSelIndex == 7 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3006);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27������Ʒ��Ԫ��Ʊ600,�ļ���ʯ,���˿,�����ݣ�#r#-23ˢ��ʱ�䣺ͬ���ٷ�")
	end
	if nSelIndex == 8 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3007);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27������Ʒ��Ԫ��Ʊ600,�ļ���ʯ,���˿,�����ݣ�#r#-23ˢ��ʱ�䣺ͬ���ٷ�")
	end
	if nSelIndex == 9 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3008);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27������Ʒ��Ԫ��Ʊ600,�ļ���ʯ,���˿,�����ݣ�#r#-23ˢ��ʱ�䣺ͬ���ٷ�")
	end
	if nSelIndex == 10 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3009);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27������Ʒ��Ԫ��Ʊ600,�ļ���ʯ,���˿,�����ݣ�#r#-23ˢ��ʱ�䣺ͬ���ٷ�")
	end
	if nSelIndex == 11 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3010);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27������Ʒ��Ԫ��Ʊ600,�ļ���ʯ,���˿,�����ݣ�#r#-23ˢ��ʱ�䣺ͬ���ٷ�")
	end
	if nSelIndex == 12 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3011);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27������Ʒ��Ԫ��Ʊ600,�ļ���ʯ,���˿,�����ݣ�#r#-23ˢ��ʱ�䣺ͬ���ٷ�")
	end
	if nSelIndex == 13 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3012);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27������Ʒ��Ԫ��Ʊ600,�ļ���ʯ,���˿,�����ݣ�#r#-23ˢ��ʱ�䣺ͬ���ٷ�")
	end
	if nSelIndex == 14 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3013);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27������Ʒ��Ԫ��Ʊ1000,�����ֹ�����,���˿,�����ݣ�#r#-23ˢ��ʱ�䣺ͬ���ٷ�")
	end
	if nSelIndex == 15 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3014);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27������Ʒ��Ԫ��Ʊ1000,�����ֹ�����,���˿,�����ݣ�#r#-23ˢ��ʱ�䣺ͬ���ٷ�")
	end
	if nSelIndex == 16 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3015);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27������Ʒ��Ԫ��Ʊ1000,�����ֹ�����,���˿,�����ݣ�#r#-23ˢ��ʱ�䣺ͬ���ٷ�")
	end
	if nSelIndex == 17 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3016);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27������Ʒ���߶�Ԫ��Ʊ�����˿���ϳɷ�,������,��������#r#-23ˢ��ʱ�䣺�ر�ͼ���������")
	end
	if nSelIndex == 18 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3017);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27������Ʒ��200Ԫ��Ʊ�����˿���ϳɷ�,�����ݣ�#r#-23ˢ��ʱ�䣺ͬ���ٷ�")
	end
	if nSelIndex == 19 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3018);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27������Ʒ�����޵�,���ǵ�,�����ݣ�#r#-23ˢ��ʱ�䣺ͬ���ٷ�")
	end
	if nSelIndex == 20 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3019);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27������Ʒ��Ԫ��Ʊ5000,�弶��ʯ,������ʯ,׺����ʯ,���弼����,���˿,�����ݣ�#r#-23ˢ��ʱ�䣺ͬ���ٷ�")
	end
	if nSelIndex == 21 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3020);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27������Ʒ��Ԫ��Ʊ2000,�����ֹ�����,���ǵ�,���ǿ��¶,������ʯ,�������޻�ͯ����,���˿,�����ݣ�#r#-23ˢ��ʱ�䣺ͬ���ٷ�")
	end
	
	if nSelIndex == 22 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3021);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27������Ʒ��Ԫ��Ʊ1000,���ǿ��¶,�����ֹ�����,���˿,�����ݣ�#r#-23ˢ��ʱ�䣺ͬ���ٷ�")
	end
	if nSelIndex == 23 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3023);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27������Ʒ��Ԫ��Ʊ1000,���ǿ��¶,�����ֹ�����,��������,���˿,�����ݣ�#r#-23ˢ��ʱ�䣺ͬ���ٷ�")
	end
	if nSelIndex == 24 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3022);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27������Ʒ��Ԫ��Ʊ400,�����ֹ�����,��¥����,���˿,�����ݣ�#r#-23ˢ��ʱ�䣺ͬ���ٷ�")
	end
	if nSelIndex == 25 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3024);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27������Ʒ��Ԫ��Ʊ600,Ը��Ȫ,�����,�����ֹ�����,�ļ���ʯ,�����ݣ�#r#-23ˢ��ʱ�䣺ͬ���ٷ�")
	end
	if nSelIndex == 26 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3025);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27������Ʒ��Ԫ��Ʊ600,���ɼ�����,�����ֹ�����,�ļ���ʯ,�����ݣ�#r#-23ˢ��ʱ�䣺ͬ���ٷ�")
	end
	if nSelIndex == 27 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3026);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27������Ʒ��Ԫ��Ʊ600,�ļ���ʯ,���,�����ֹ�����,�����ݣ�#r#-23ˢ��ʱ�䣺ÿ�츱��5��")
	end
	if nSelIndex == 28 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3027);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27������Ʒ��Ԫ��Ʊ600,�ļ���ʯ,���,�����,������ʯ,�����ֹ�����,�����ݣ�#r#-23ˢ��ʱ�䣺ÿ�츱��3��")
	end
	if nSelIndex == 29 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3028);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27������Ʒ����Ʊ,����ˮ�ص���¥����,Ԫ��Ʊ800,�ļ���ʯ,�����ֹ�����,ǧ������,����ʯ,��ç���,�����ݣ�#r#-23ˢ��ʱ�䣺ÿ�츱��2��")
	end
	if nSelIndex == 30 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3029);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27������Ʒ����������ӣ�#r#-23ˢ��ʱ�䣺ÿ�츱��3��")
	end
	if nSelIndex == 31 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3030);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27������Ʒ����������ӣ�#r#-23ˢ��ʱ�䣺ÿ�츱��1��")
	end
	if nSelIndex == 32 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3031);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27������Ʒ�������ֹ�����,������,Ԫ��Ʊ400,�ļ���ʯ,���˿,�����ݣ�#r#-23ˢ��ʱ�䣺ÿ�츱��3��")
	end
	
	if nSelIndex == 33 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3032);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27������Ʒ��F1,Ԫ��Ʊ400,�����ֹ�����,�ļ���ʯ,�����Ƭ,���˿,�����ݣ�#r#-23ˢ��ʱ�䣺ÿСʱ�����ʱ�Զ�ˢ�£�ÿ�칲ˢ24��")
	end
	if nSelIndex == 34 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3033);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27������Ʒ��F2,Ԫ��Ʊ400,�����ֹ�����,�ļ���ʯ,�����Ƭ,���˿,�����ݣ�#r#-23ˢ��ʱ�䣺ÿСʱ5��ʱ�Զ�ˢ�£�ÿ�칲ˢ24��")
	end
	if nSelIndex == 35 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3035);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27������Ʒ��F3,Ԫ��Ʊ600,�����ֹ�����,�ļ���ʯ,�����Ƭ,���˿,�����ݣ�#r#-23ˢ��ʱ�䣺ÿСʱ10��ʱ�Զ�ˢ�£�ÿ�칲ˢ24��")
	end
	if nSelIndex == 36 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3036);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27������Ʒ��F3,Ԫ��Ʊ600,�����ֹ�����,�ļ���ʯ,�����Ƭ,���˿,�����ݣ�#r#-23ˢ��ʱ�䣺ÿСʱ15��ʱ�Զ�ˢ�£�ÿ�칲ˢ24��")
	end
	
	if nSelIndex == 37 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3038);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27������Ʒ��F4,Ԫ��Ʊ800,�ļ���ʯ,�����Ƭ,���˿,�����ݣ�#r#-23ˢ��ʱ�䣺ÿСʱ25��ʱ�Զ�ˢ�£�ÿ�칲ˢ24��")
	end
	
	if nSelIndex == 38 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3040);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27������Ʒ��F4,Ԫ��Ʊ800,�ļ���ʯ,�����Ƭ,���˿,�����ݣ�#r#-23ˢ��ʱ�䣺ÿСʱ35��ʱ�Զ�ˢ�£�ÿ�칲ˢ24��")
	end
	
	if nSelIndex == 39 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3042);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27������Ʒ��F5,Ԫ��Ʊ1000,�����ֹ�����,�ļ���ʯ,�����Ƭ,���˿,�����ݣ�#r#-23ˢ��ʱ�䣺ÿСʱ45��ʱ�Զ�ˢ�£�ÿ�칲ˢ24��")
	end
	if nSelIndex == 40 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3046);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27������Ʒ��F5,Ԫ��Ʊ1000,�����ֹ�����,�ļ���ʯ,�����Ƭ,���˿,�����ݣ�#r#-23ˢ��ʱ�䣺ÿСʱ55��ʱ�Զ�ˢ�£�ÿ�칲ˢ24��")
	end
	if nSelIndex == 41 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3048);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27������Ʒ��F7,Ԫ��Ʊ2000,�����ֹ�����,���,15��õ��,������,����80������,�Ͻ�ʯ,���˿,�����ݣ�#r#-23ˢ��ʱ�䣺ÿ��ÿСʱ˫��30��ˢ�£�ÿ�칲ˢ12��")
	end
	if nSelIndex == 42 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3051);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27������Ʒ��F6,Ԫ��Ʊ2000,�����ֹ�����,���,15��õ��,������,����80������,�����,���˿,�����ݣ�#r#-23ˢ��ʱ�䣺ÿ��ÿСʱ����30��ˢ�£�ÿ�칲ˢ12��")
	end
	if nSelIndex == 43 then
		Agname_Kong_MeshW:SetFakeObject("");
		CachedTarget:SetHorseModel(3052);
		Agname_Kong_MeshW:SetFakeObject("Other_Horse");
		Agname_Kong_Item1:SetText("#K#-27������Ʒ��F7,Ԫ��Ʊ2000,�����ֹ�����,���,15��õ��,������,����80������,�Ͻ�ʯ,���˿,�����ݣ�#r#-23ˢ��ʱ�䣺ÿ��2Сʱ�Զ�ˢ�£�ÿ�칲ˢ12��")
	end

end

function Agname_Kong_Close()
	Agname_Kong_MeshW:SetFakeObject("");
	this:Hide();
end
function Agname_Kong_ResetPos()
	Agname_Kong_Frame:SetProperty("UnifiedXPosition", g_Frame_UnifiedXPosition);
	Agname_Kong_Frame:SetProperty("UnifiedYPosition", g_Frame_UnifiedYPosition);
end
function Agname_Kong_Clicked(index)
	if index > 30 and index < 1 then
		return
	end
	Clear_XSCRIPT()
	Set_XSCRIPT_Function_Name("Scripttransitcenter");
	Set_XSCRIPT_ScriptID(990010);
	Set_XSCRIPT_Parameter(0, 9);
	Set_XSCRIPT_Parameter(1, tonumber(axiaocs));
	Set_XSCRIPT_Parameter(2, tonumber(index));
	Set_XSCRIPT_ParamCount(3);
	Send_XSCRIPT()
end

function Agname_Kong_Load(index)
	if index < 7 and index > 0 then
		axiaocs = index
		local nchuansong = 0
		for i = 1, 30 do
			sceninfog[i]:Hide();
		end
		if index == 1 then
			Agname_Kong_Client:Show()
			Agname_Kong_Client2:Hide()
			for i, j in ipairs(sceninfo1) do
				j.Num:Show()
				j.Num:SetText(j.str)
				nchuansong = nchuansong + 1
			end
		elseif index == 2 then
			Agname_Kong_Client:Show()
			Agname_Kong_Client2:Hide()
			for i, j in ipairs(sceninfo2) do
				j.Num:Show()
				j.Num:SetText(j.str)
				nchuansong = nchuansong + 1
			end
		elseif index == 3 then
			Agname_Kong_Client:Show()
			Agname_Kong_Client2:Hide()
			for i, j in ipairs(sceninfo3) do
				j.Num:Show()
				j.Num:SetText(j.str)
				nchuansong = nchuansong + 1
			end
		elseif index == 4 then
			Agname_Kong_Client:Show()
			Agname_Kong_Client2:Hide()
			for i, j in ipairs(sceninfo4) do
				j.Num:Show()
				j.Num:SetText(j.str)
				nchuansong = nchuansong + 1
			end
		
		elseif index == 5 then
			Agname_Kong_Client:Show()
			Agname_Kong_Client2:Hide()
			for i, j in ipairs(sceninfo5) do
				j.Num:Show()
				j.Num:SetText(j.str)
				nchuansong = nchuansong + 1
			end
		
		elseif index == 6 then
			Agname_Kong_Client:Hide()
			Agname_Kong_Client2:Show()
		end
	end
end