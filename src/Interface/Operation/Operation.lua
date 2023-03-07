--===============================================
-- OnLoad()
--===============================================
function Operation_PreLoad()
	
	this:RegisterEvent("TOGLE_SYSTEMFRAME");
	this:RegisterEvent("TOGLE_GAMESETUP");
	this:RegisterEvent("TOGLE_SOUNDSETUP");
	this:RegisterEvent("TOGLE_VIEWSETUP");
	this:RegisterEvent("RELIVE_SHOW");
	this:RegisterEvent("RELIVE_HIDE");
	this:RegisterEvent("TOGLE_INPUTSETUP");

end
function Operation_Ret2SelServer_Clicked()
	EnterQuitWait(1);
end;
function Operation_OnLoad()

end

--===============================================
-- OnEvent()
--===============================================
function Operation_OnEvent(event)
	if (event == "TOGLE_SYSTEMFRAME") then
		Operation_Open();
	elseif (event == "TOGLE_GAMESETUP") then
		Operation_Close();
	elseif (event == "TOGLE_SOUNDSETUP") then
		Operation_Close();
	elseif (event == "TOGLE_VIEWSETUP") then
		Operation_Close();
	elseif (event == "TOGLE_INPUTSETUP") then
		Operation_Close();
	elseif (event == "RELIVE_SHOW") then
		Operation_Help:Disable();
		Operation_View:Disable();
		Operation_Sound:Disable();
		Operation_Geme:Disable();
		Operation_2Menu:Disable();
		Operation_Acce_Custom:Disable();
	elseif (event == "RELIVE_HIDE") then
		Operation_Help:Enable();
		Operation_View:Enable();
		Operation_Sound:Enable();
		Operation_Geme:Enable();
		Operation_2Menu:Enable();
		Operation_Acce_Custom:Enable();
	end
end


--===============================================
-- UpdateFrame()
--===============================================
function Operation_UpdateFrame()

end



--===============================================
-- ��Ƶ����
--===============================================
function Operation_View_Clicked()
	SystemSetup:ViewSetup();
end
--===============================================
-- ��������
--===============================================
function Operation_Sound_Clicked()
	SystemSetup:SoundSetup();
end
--===============================================
-- ��������
--===============================================
function Operation_UI_Clicked()
	SystemSetup:UISetup();
end
--===============================================
-- ��������
--===============================================
function Operation_Input_Clicked()
	SystemSetup:InputSetup();
end

--===============================================
-- ��Ϸ������
--===============================================
function Operation_Game_Clicked()
	SystemSetup:GameSetup();
end

--===============================================
-- ��������
--===============================================
function Operation_Help_Clicked()
	--	Helper:GotoHelper("");
end

--===============================================
-- �˳���Ϸ
--===============================================
function Operation_QuitGame_Clicked()
	EnterQuitWait(0);
end

--===============================================
-- ������Ϸ
--===============================================
function Operation_BackGame_Clicked()
	SystemSetup:BackGame();
	
	Operation_Close();
end

function Operation_Close()
	this:Hide();
end

function Operation_Open()
	this:Show();
end

