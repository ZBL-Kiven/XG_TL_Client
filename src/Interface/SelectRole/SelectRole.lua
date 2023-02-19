-----------------------------------------------------------------------------------------------------------------
--
-- ȫ�ֱ�����
--

-- ����
local g_RoleName = {};

-- ����
local g_iMenPai = {};

-- �ȼ�
local g_iLevel = {};

-- ʣ��ɾ��ʱ��
local g_iDelTime = {};

-- ͷ����Դ����
local g_FaceImg = {};

-- �ڽ�������ʾ��uiģ��
local g_UIModel = {};

-- ѡ��ť
local g_BnSelCheck = {};

-- ��ǰѡ��Ľ�ɫ
local g_iCurSelRole = 0;

-- ��ǰ��ɫ�ĸ���
local g_iCurRoleCount = 0;

-- ����Ǵ����ɹ���ˢ�½��棬 Ҫѡ����󴴽��������ɫ.
--
-- 0 -- ������ɫʧ�ܡ�
-- 1 -- ������ɫ�ɹ���
local g_bCreateSuccess = 0;

-- UI������Դ
local g_RolName_Text = {};
local g_MenPai_Text = {};
local g_Level_Text = {};
local g_Delete_Text = {};
local g_RolFace_Icon = {};
local g_HighLightBack = {};
local g_CreateInfo_Text = {};
------------------------------------------------------------------------------------------------------------------
--
-- ������
--

-- ע��onLoad�¼�
function LoginSelectRole_PreLoad()
	-- �򿪽���
	this:RegisterEvent("GAMELOGIN_OPEN_SELECT_CHARACTOR");
	
	-- �رս���
	this:RegisterEvent("GAMELOGIN_CLOSE_SELECT_CHARACTOR");
	
	-- ˢ�½�ɫ��Ϣ
	this:RegisterEvent("GAMELOGIN_REFRESH_ROLE_SELECT_CHARACTOR");
	
	-- ������ɫ�ɹ���
	this:RegisterEvent("GAMELOGIN_CREATE_ROLE_OK");
	
	this:RegisterEvent("ENTER_GAME");
	
	this:RegisterEvent("GAMELOGIN_SELECTCHARACTER");

end

-- ע��onLoad�¼�
function LoginSelectRole_OnLoad()
	
	-- ��ɫ����
	--g_RoleName[1] = SelectRole_Role1_Name;
	--g_RoleName[2] = SelectRole_Role2_Name;
	--g_RoleName[3] = SelectRole_Role3_Name;
	
	g_RoleName[1] = ""
	g_RoleName[2] = ""
	g_RoleName[3] = ""
	
	-- ��ɫ����
	g_iMenPai[1] = 0;
	g_iMenPai[2] = 0;
	g_iMenPai[3] = 0;
	
	-- ��ɫ�ȼ�
	g_iLevel[1] = 0;
	g_iLevel[2] = 0;
	g_iLevel[3] = 0;
	
	g_iDelTime[1] = 0;
	g_iDelTime[2] = 0;
	g_iDelTime[3] = 0;
	
	-- ��ɫͷ����Ϣ
	g_FaceImg[1] = ""
	g_FaceImg[2] = ""
	g_FaceImg[3] = ""
	
	-- ��ɫѡ��ť
	--g_BnSelCheck[1] = SelectRole_Role1;
	--g_BnSelCheck[2] = SelectRole_Role2;
	--g_BnSelCheck[3] = SelectRole_Role3;
	
	-- ѡ��ť
	--g_BnSelCheck[1]:SetProperty("CheckMode", "1");	
	--g_BnSelCheck[2]:SetProperty("CheckMode", "1");	
	--g_BnSelCheck[3]:SetProperty("CheckMode", "1");	
	
	--g_BnSelCheck[1]:SetCheck( 0 );	
	--g_BnSelCheck[2]:SetCheck( 0 );	
	--g_BnSelCheck[3]:SetCheck( 0 );	
	-- uiģ������
	--g_UIModel[1] = SelectRole_Role1_Model;
	--g_UIModel[2] = SelectRole_Role2_Model;
	--g_UIModel[3] = SelectRole_Role3_Model;
	
	--SelectRole_Role1_Model:SetProperty("MouseHollow", "True");	
	--SelectRole_Role2_Model:SetProperty("MouseHollow", "True");	
	--SelectRole_Role3_Model:SetProperty("MouseHollow", "True");	
	
	g_RolName_Text[1] = SelectRole_TargetInfo_Name_Text;
	g_RolName_Text[2] = SelectRole_TargetInfo_Name_Text2;
	g_RolName_Text[3] = SelectRole_TargetInfo_Name_Text3;
	
	g_MenPai_Text[1] = SelectRole_TargetInfo_Menpai_Text;
	g_MenPai_Text[2] = SelectRole_TargetInfo_Menpai_Text2;
	g_MenPai_Text[3] = SelectRole_TargetInfo_Menpai_Text3;
	
	g_Level_Text[1] = SelectRole_TargetInfo_Level_Text;
	g_Level_Text[2] = SelectRole_TargetInfo_Level_Text2;
	g_Level_Text[3] = SelectRole_TargetInfo_Level_Text3;
	
	g_Delete_Text[1] = SelectRole_TargetInfo_Delete;
	g_Delete_Text[2] = SelectRole_TargetInfo_Delete2;
	g_Delete_Text[3] = SelectRole_TargetInfo_Delete3;
	
	g_RolFace_Icon[1] = SelectRole_Icon;
	g_RolFace_Icon[2] = SelectRole_Icon2;
	g_RolFace_Icon[3] = SelectRole_Icon3;
	
	g_HighLightBack[1] = SelectRole_TargetInfo_Gaoliang1;
	g_HighLightBack[2] = SelectRole_TargetInfo_Gaoliang2;
	g_HighLightBack[3] = SelectRole_TargetInfo_Gaoliang3;
	
	g_CreateInfo_Text[1] = SelectRole_TargetInfo_Create;
	g_CreateInfo_Text[2] = SelectRole_TargetInfo_Create2;
	g_CreateInfo_Text[3] = SelectRole_TargetInfo_Create3;
	
	for i = 1, 3 do
		g_RolName_Text[i]:SetText("");
		g_MenPai_Text[i]:SetText("");
		g_Level_Text[i]:SetText("");
		g_Delete_Text[i]:SetText("");
		g_RolFace_Icon[i]:SetProperty("Image", "");
		g_HighLightBack[i]:Hide();
		g_CreateInfo_Text[i]:Show();
	end
end

-- OnEvent
function LoginSelectRole_OnEvent(event)
	
	if (event == "GAMELOGIN_OPEN_SELECT_CHARACTOR") then
		MAINMENUBAR_COOLDOWN = {}
		MAINMENUBAR_SKILLID = {}
		local CurSelIndex = GameProduceLogin:GetCurSelectRole();
		
		-- Ĭ��ѡ���һ�����
		g_iCurSelRole = CurSelIndex + 1  --1;
		
		AxTrace(1, 0, g_iCurSelRole)
		
		SelectRole_ClearInfo();
		SelectRole_RefreshRoleInfo();
		this:Show();
		return ;
	end
	
	if (event == "GAMELOGIN_CLOSE_SELECT_CHARACTOR") then
		
		-- �������
		SelectRole_ClearInfo();
		this:Hide();
		return ;
	end
	
	
	-- ˢ�½�ɫ
	if (event == "GAMELOGIN_REFRESH_ROLE_SELECT_CHARACTOR") then
		
		SelectRole_RefreshRoleInfo();
		return ;
	end
	
	
	-- ������ɫ�ɹ���
	if (event == "GAMELOGIN_CREATE_ROLE_OK") then
		
		g_bCreateSuccess = 1;
		return ;
	end
	
	if (event == "ENTER_GAME") then
		GameProduceLogin:SendEnterGameMsg(g_iCurSelRole - 1);
		return ;
	end
	
	if (event == "GAMELOGIN_SELECTCHARACTER") then
		local CurSel = tonumber(arg0)
		
		if (0 == CurSel) then
			SelectRole_SelectRole1()
		end
		
		if (1 == CurSel) then
			SelectRole_SelectRole2()
		end
		
		if (2 == CurSel) then
			SelectRole_SelectRole3()
		end
	
	end
	SelectRole_HighLight();

end



---------------------------------------------------------------------------------------------
--
-- ������Ϸ
--
function SelectRole_EnterGame()
	
	-- ���ͽ�����Ϸ��Ϣ
	GameProduceLogin:SendEnterGameMsg(g_iCurSelRole - 1);
end

---------------------------------------------------------------------------------------------
--
-- ������ɫ
--
function SelectRole_CreateRole()
	
	--�˴���ֱ�Ӵ�����ѡ������л������ﴴ������....
	--��Login���󴴽������ͼ����֤��Ϣ....��֤��Ϣ������Ὺ����֤����....��֤ͨ������֤������л������ﴴ������....
	-- DataPool:AskCreateCharCode();
	GameProduceLogin:ChangeToCreateRoleDlgFromSelectRole(); --�������������������������֤
end



---------------------------------------------------------------------------------------------
--
-- ɾ����ɫ
--
function SelectRole_DelRole()
	
	GameProduceLogin:SetCurSelect(g_iCurSelRole - 1);
	-- ������ѡ������л������ﴴ������.
	local strName;
	local iMenPai;
	local iLevel;
	local iDelTime;
	local strInfo;
	local strImgName;
	strName
	, iMenPai
	, iLevel
	, iDelTime
	, strImgName = GameProduceLogin:GetRoleInfo(g_iCurSelRole - 1);
	if (iLevel == 0) then
		--˵��û�н�ɫ
		strInfo = "û��ѡ���ɫ";
		GameProduceLogin:ShowMessageBox(strInfo, "OK", "6");
		return ;
	end
	if (iLevel >= 1) then
		--�������10��
		if (iDelTime >= 11) then
			--˵��������ɾ���أ�����ʾ�Ի���
			strInfo = "ɾ�������Ѿ��ύ" .. tostring(14 - iDelTime) .. "����,����ɾ����ɫ3���14�����ڵ�¼��Ϸ����������268��46���ҵ��غ��ٻ��ߵ�����80��136���ҵ��ܲ�ȷ�ϡ�";
			GameProduceLogin:ShowMessageBox(strInfo, "OK", "6");
		elseif (iDelTime > 0) then
			--˵������ɾ���أ�����ʾ�Ի���
			strInfo = "���¼��Ϸ����������268��46���ҵ��غ��ٻ��ߵ�����80��136���ҵ��ܲ�ȷ�ϣ���������ɾ���������û�а�ᡢ��顢���ꡢ��ݡ�ʦͽ��ϵ����ɾ����";
			GameProduceLogin:ShowMessageBox(strInfo, "OK", "5");
		else
			--˵��Ҫɾ���ˣ�������ʾ�Ի���
			strInfo = "��ȷ��Ҫ��" .. tostring(iLevel) .. "���Ľ�ɫ#c00ff00" .. strName .. "#cffffffɾ����?";
			GameProduceLogin:ShowMessageBox(strInfo, "YesNo", "4");
		end
	else
		--ֱ�ӳ�����ʾ���Ƿ�ɾ��
		strInfo = "��ȷ��Ҫ��" .. tostring(iLevel) .. "���Ľ�ɫ#c00ff00" .. strName .. "#cffffffɾ����?";
		GameProduceLogin:ShowMessageBox(strInfo, "YesNo", "7");
	end

end


---------------------------------------------------------------------------------------------
--
-- ���ص���һ��
--				
function SelectRole_Return()
	
	GameProduceLogin:ExitToAccountInput_YesNo();
	--GameProduceLogin:ChangeToAccountInputDlgFromSelectRole();
end


---------------------------------------------------------------------------------------------------------------
--
--   ˢ�½�ɫ��Ϣ
--
function SelectRole_RefreshRoleInfo()
	
	-- ��ս���.
	SelectRole_ClearInfo();
	
	g_iCurRoleCount = GameProduceLogin:GetRoleCount();
	-- �õ�����ĸ���
	AxTrace(0, 0, "�õ���ɫ����" .. tostring(g_iCurRoleCount));
	
	if (0 == g_iCurRoleCount) then
		
		return ;
	end ;
	
	for index = 0, g_iCurRoleCount - 1 do
		
		AxTrace(0, 0, "��ʾ��ɫ" .. tostring(index));
		SelectRole_GetRoleInfo(index);
	end
	
	-- ѡ���ɫ
	if (1 == g_bCreateSuccess) then
		
		-- �����ɹ���
		g_iCurSelRole = g_iCurRoleCount;
		g_bCreateSuccess = 0;
	end
	
	for index = 1, g_iCurRoleCount do
		SelectRole_ShowSelRoleInfo(index);
	end

end


---------------------------------------------------------------------------------------------------------------
--
--   ˢ�½�ɫ��Ϣ
--
function SelectRole_GetRoleInfo(index)
	local strName;
	local iMenPai;
	local iLevel;
	local iDelTime;
	local strFaceImgName;
	strName, iMenPai, iLevel, iDelTime, strFaceImgName = GameProduceLogin:GetRoleInfo(index);
	-- ��������
	g_RoleName[index + 1] = strName;
	g_iMenPai[index + 1] = iMenPai;
	g_iLevel[index + 1] = iLevel;
	g_iDelTime[index + 1] = iDelTime;
	g_FaceImg[index + 1] = Lua_GetCharacterImage(strName)
end

---------------------------------------------------------------------------------------------------------------
--
--   ��ս�ɫ��Ϣ.
--
function SelectRole_ClearInfo()
	for i = 1, 3 do
		g_RolName_Text[i]:SetText("");
		g_MenPai_Text[i]:SetText("");
		g_Level_Text[i]:SetText("");
		g_Delete_Text[i]:Hide();
		g_RolFace_Icon[i]:SetProperty("Image", "");
		g_HighLightBack[i]:Hide();
		g_CreateInfo_Text[i]:Show();
	end
end


---------------------------------------------------------------------------------------------------------------
--
--   ѡ���ɫ1.
--
function SelectRole_SelectRole1()
	
	AxTrace(0, 0, " ѡ1");
	g_iCurSelRole = 1;
	if (g_iCurRoleCount < g_iCurSelRole) then
		
		AxTrace(0, 0, " δѡ��һ");
		SelectRole_TargetInfo_Name_Text:SetText("");
		SelectRole_TargetInfo_Menpai_Text:SetText("");
		SelectRole_TargetInfo_Level_Text:SetText("");
		return ;
	end
	SelectRole_HighLight();
	SelectRole_ShowSelRoleInfo(g_iCurSelRole);

end

---------------------------------------------------------------------------------------------------------------
--
--   ѡ���ɫ2.
--
function SelectRole_SelectRole2()
	
	AxTrace(0, 0, " ѡ2");
	g_iCurSelRole = 2;
	if (g_iCurRoleCount < g_iCurSelRole) then
		
		SelectRole_TargetInfo_Name_Text:SetText("");
		SelectRole_TargetInfo_Menpai_Text:SetText("");
		SelectRole_TargetInfo_Level_Text:SetText("");
		return ;
	end
	
	SelectRole_ShowSelRoleInfo(g_iCurSelRole);
	SelectRole_HighLight();
end


---------------------------------------------------------------------------------------------------------------
--
--   ѡ���ɫ3.
--
function SelectRole_SelectRole3()
	
	AxTrace(0, 0, " ѡ3");
	g_iCurSelRole = 3;
	if (g_iCurRoleCount < g_iCurSelRole) then
		
		SelectRole_TargetInfo_Name_Text:SetText("");
		SelectRole_TargetInfo_Menpai_Text:SetText("");
		SelectRole_TargetInfo_Level_Text:SetText("");
		return ;
	end
	
	SelectRole_ShowSelRoleInfo(g_iCurSelRole);
	SelectRole_HighLight();
end


---------------------------------------------------------------------------------------------------------------
--
--   ͨ������, ѡ���ɫ
--
function SelectRole_ShowSelRoleInfo(index)
	
	if (g_iCurRoleCount < index or 0 >= index) then
		return ;
	end
	
	if (index < 1) then
		
		return ;
	end ;
	-- ��ʾ����
	AxTrace(0, 0, "show sel info index=" .. index);
	--SelectRole_TargetInfo_Name_Text:SetText(g_RoleName[index]:GetText());
	--added by dun.liu 2008-04-18
	g_RolName_Text[index]:SetText("" .. g_RoleName[index]);
	
	local Family = g_iMenPai[index];
	g_MenPai_Text[index]:SetText("#c00ff00����:#cffffff" .. tintUserMenPai(Family));
	
	-- ��ʾ�ȼ�
	g_Level_Text[index]:SetText("#c00ff00�ȼ�:#cffffff" .. tostring(g_iLevel[index]));
	
	if (tonumber(g_iDelTime[index]) > 0) then
		if (g_iDelTime[index] >= 11) then
			g_Delete_Text[index]:SetText("#c00ff00" .. (3 - (14 - g_iDelTime[index])) .. "����ɾ����ɫ");
		else
			g_Delete_Text[index]:SetText("#c00ff00�ѿ�ɾ����ɫ");
		end
		
		g_Delete_Text[index]:Show();
	else
		g_Delete_Text[index]:Hide();
	end
	-- ��Ϊѡ��״̬
	--g_BnSelCheck[index]:SetCheck(1);
	
	g_RolFace_Icon[index]:SetProperty("Image", g_FaceImg[index]);
	
	g_CreateInfo_Text[index]:Hide();
	if g_iLevel[index] == 0 then
		g_Level_Text[index]:SetText("#cFF0000�ý�ɫ�ѱ����ᣡ");
		g_MenPai_Text[index]:SetText("#cFF0000���ڷǷ�����");
		SelectRole_Play:Disable()
		strInfo = "�����˺�����ʹ��#c00ff00�Ƿ������۸Ŀͻ���#cffffff�����½�ɫ���ڷǷ����ݣ��ָý�ɫ�ѱ�#c00ff00����#cffffff��#r#G������ɫ��������Ϸ����Ҫʹ�÷Ƿ�������������飬����ϵ��Ⱥ������Ӫ�Ŷӣ�#r#G��ܰ��ʾ�������˻���Ȼ����ʹ�ã������½���ɫ��������Ϸ��";
		GameProduceLogin:ShowMessageBox(strInfo, "OK", "5");
		g_Delete_Text[index]:Hide()
	end
end

function SelectRole_SelRole_MouseEnter(index)
	
	SelectRole_Info:SetText("ѡ��ǰ��¼��ɫ");
end

function SelectRole_MouseLeave()
	
	SelectRole_Info:SetText("");
end

function SelectRole_Play_MouseEnter()
	
	SelectRole_Info:SetText("������Ϸ");
end

function SelectRole_Create_MouseEnter()
	
	SelectRole_Info:SetText("����һ���½�ɫ");
end

function SelectRole_Delete_MouseEnter()
	
	SelectRole_Info:SetText("ɾ��һ�����н�ɫ");
end

function SelectRole_Last_MouseEnter()
	
	SelectRole_Info:SetText("���ص��˺ŵ�¼����");    --�ʺ�  to  �˺�
end;

function SelectRole_Role_Modle_TurnRightBegin(index)
	
	if (1 == index) then
		
		SelectRole_Role1_Model:RotateBegin(0.3);
	
	elseif (2 == index) then
		
		SelectRole_Role2_Model:RotateBegin(0.3);
	
	elseif (3 == index) then
		
		SelectRole_Role3_Model:RotateBegin(0.3);
	
	end ;

end;

function SelectRole_Role_Modle_TurnRightEnd(index)
	
	if (1 == index) then
		
		SelectRole_Role1_Model:RotateEnd();
	
	elseif (2 == index) then
		
		SelectRole_Role2_Model:RotateEnd();
	
	elseif (3 == index) then
		
		SelectRole_Role3_Model:RotateEnd();
	
	end ;

end;

function SelectRole_Role_Modle_TurnLeftBegin(index)
	
	if (1 == index) then
		
		SelectRole_Role1_Model:RotateBegin(-0.3);
	
	elseif (2 == index) then
		
		SelectRole_Role2_Model:RotateBegin(-0.3);
	
	elseif (3 == index) then
		
		SelectRole_Role3_Model:RotateBegin(-0.3);
	
	end ;

end;

function SelectRole_Role_Modle_TurnLeftEnd(index)
	
	if (1 == index) then
		
		SelectRole_Role1_Model:RotateEnd();
	
	elseif (2 == index) then
		
		SelectRole_Role2_Model:RotateEnd();
	
	elseif (3 == index) then
		
		SelectRole_Role3_Model:RotateEnd();
	
	end ;

end;

function SelectRole_Role_Modle_TurnRight(start)
	--������ת��ʼ
	if (start == 1) then
		--GameProduceLogin:ModelRotBegin(0.3)
		GameProduceLogin:ModelRotBegin(1.0)   --ÿ��һȦ
		--������ת����
	else
		GameProduceLogin:ModelRotEnd(0.0)
	end

end

function SelectRole_Role_Modle_TurnLeft(start)
	if (start == 1) then
		--GameProduceLogin:ModelRotBegin(-0.3)
		GameProduceLogin:ModelRotBegin(-1.0)   --ÿ��-1Ȧ
	else
		GameProduceLogin:ModelRotEnd(0.0)
	end

end

function SelectRole_Modle_ZoomOut(start)
	if (start == 1) then
		GameProduceLogin:ModelZoom(-1.0)
	else
		GameProduceLogin:ModelZoom(0.0)
	end

end

function SelectRole_Modle_ZoomIn(start)
	if (start == 1) then
		GameProduceLogin:ModelZoom(1.0)
	else
		GameProduceLogin:ModelZoom(0.0)
	end

end

function SelectRole_DoubleClicked(index)
	local strName;
	local iMenPai;
	local iLevel;
	local iDelTime;
	local strInfo;
	local strImgName;
	strName
	, iMenPai
	, iLevel
	, iDelTime
	, strImgName = GameProduceLogin:GetRoleInfo(index);
	if (iLevel == 0) then
		--˵��û�н�ɫ
		SelectRole_CreateRole();
	else
		if (g_iCurRoleCount <= index or 0 > index) then
			return ;
		end
		
		if (g_iCurSelRole ~= index + 1) then
			g_iCurSelRole = index + 1;
		end
		
		SelectRole_EnterGame();
	end
end
--/////////////////////////////��¼��ɫ���ݴ洢ϵͳ
function Lua_SetCharacterImage(nName, image)
	if nName == nil or nName == "" or image == nil or image == "" then
		return
	end
	local handle = io.open("./Character_Frame.cfg", "r");
	local nNowCharData = {};
	if handle ~= nil then
		for l in handle:lines() do
			local nPos_1, nPos_2, nCharName, nCharImage = string.find(l, "(.*)\t(.*)");
			if nPos_1 ~= nil and nPos_2 ~= nil then
				table.insert(nNowCharData, { nCharName, nCharImage });
			end
		end
		handle:close();
	end
	local nIsInsertNew = 0;
	for i = 1, table.getn(nNowCharData) do
		if nNowCharData[i][1] == nName then
			nNowCharData[i][2] = image;
			nIsInsertNew = 1;
			break ;
		end
	end
	if nIsInsertNew == 0 then
		table.insert(nNowCharData, { nName, image });
	end
	local nFinalData = "";
	for i = 1, table.getn(nNowCharData) do
		nFinalData = nFinalData .. nNowCharData[i][1] .. "\t" .. nNowCharData[i][2] .. "\n";
	end
	handle = io.open("./Character_Frame.cfg", "w");
	handle:write(nFinalData);
	handle:close();
end

--��ɫͷ����Ϣ��ȡ
--2020-06-20 01:33:51 ���֔�����ԭ���£�
function Lua_GetCharacterImage(nName)
	local nDefaultCharImage = "set:GirlProtagonist image:GirlProtagonist_1";
	if nName == nil or nName == "" then
		return nDefaultCharImage
	end
	local handle = io.open("./Character_Frame.cfg", "r")
	local nFinalData
	if handle ~= nil then
		for l in handle:lines() do
			if l ~= nil then
				local nPos_1, nPos_2, nCharName, nImage = string.find(l, "(.*)\t(.*)");
				if nPos_1 ~= nil and nPos_2 ~= nil then
					if nCharName ~= nil and nCharName == nName then
						nFinalData = nImage;
						break
					end
				end
			end
		end
		handle:close()
		if nFinalData ~= nil then
			return nFinalData
		else
			return nDefaultCharImage
		end
	else
		return nDefaultCharImage
	end
end

function SelectRole_MouseEnterCharArea(index)
	local strName;
	local iMenPai;
	local iLevel;
	local iDelTime;
	local strInfo;
	local strImgName;
	strName
	, iMenPai
	, iLevel
	, iDelTime
	, strImgName = GameProduceLogin:GetRoleInfo(index);
	if (iLevel == 0) then
		--˵��û�н�ɫ
		SelectRole_Info:SetText("#{DLJM_XML_5}");
	else
		SelectRole_Info:SetText("#{DLJM_XML_6}");
	end
end

function SelectRole_HighLight()
	if (g_iCurRoleCount < g_iCurSelRole or 0 >= g_iCurSelRole) then
		return ;
	end
	
	for i = 1, 3 do
		g_HighLightBack[i]:Hide();
	end
	g_HighLightBack[g_iCurSelRole]:Show();
end
