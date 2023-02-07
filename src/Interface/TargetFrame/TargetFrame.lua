
local strMenPaiName ={
						"����",
						"����",	
						"ؤ��",	
						"�䵱",	
						"����",	
						"����",	
						"����",	
						"��ɽ",	
						"��ң",
						"����",	
						"����ɽׯ",
						"����",
						"����",
						"����",
						"����",
						"����",	
						"����",	
						"����",	
						"ç��",	
						"����",	
						"����",	
						"����",	
						"����",	
						"����",	
						"ԽŮ",
						"Խ��",
						"����",	
						"Ұ��",	
						"����",	
						"��ħ",};

local g_TargetGuid_Temp = 0
function TargetFrame_PreLoad()
	this:RegisterEvent("MAINTARGET_CHANGED")
	this:RegisterEvent("UNIT_HP");
	this:RegisterEvent("UNIT_MP");
	this:RegisterEvent("UNIT_RAGE");
	this:RegisterEvent("UNIT_LEVEL");
	this:RegisterEvent("UNIT_RELATIVE");
	this:RegisterEvent("MAINTARGET_OPEN")
end

function TargetFrame_OnLoad()

end

function TargetFrame_OnEvent(event)

	if ( event == "MAINTARGET_OPEN" ) then
	
		--AxTrace(0,0,"��main target");
		TargetFrame_DataBack:Show();
		TargetFrame_DataBack2:Hide();
		TargetFrame_Update_Name_Team();
		TargetFrame_Update_HP_Team();
		TargetFrame_Update_MP_Team();
		TargetFrame_Update_Rage_Team();
		TargetFrame_Update_Level_Team();
		this:Show();
		return;
	end;
	
	if ( event == "MAINTARGET_CHANGED" ) then
	
		AxTrace(0,0,"id === "..tostring(arg0));
	  if(-1 == tonumber(arg0)) then
	  
	  	this:Hide();
	  	return;
	  end;
	  
		if( Target:IsPresent()) then
			this:Show();
			TargetFrame_Update_Name();
			TargetFrame_Update_HP();
			TargetFrame_Update_MP();
			TargetFrame_Update_Rage();
			TargetFrame_Update_Level();
			TargetFrame_Update_Head()
		else
		
			if(Target:IsTargetTeamMember()) then
			
				this:Show();
				TargetFrame_DataBack:Show();
				TargetFrame_DataBack2:Hide();
			else
				this:Hide();
			end;
				
		end
		return;
	end
	
	
	
	if( (event == "UNIT_MP") and Target:IsPresent()) then
		TargetFrame_Update_MP();
		return;
	end

	if( (event == "UNIT_HP") and Target:IsPresent()) then
		TargetFrame_Update_HP();
		return;
	end

	if( (event == "UNIT_RAGE") and Target:IsPresent()) then
		TargetFrame_Update_Rage();
		return;
	end

	if( (event == "UNIT_LEVEL") and Target:IsPresent()) then
		TargetFrame_Update_Level();
		return;
	end

	if( (event == "UNIT_RELATIVE") and Target:IsPresent()) then
		TargetFrame_Update_Name();
		return;
	end
	
	
	
	
	-------------------------------------------------------------------------------------------------
	--
	-- ��target���Լ���ʱ���޷�ˢ�¡�
	--
	
	--if( (event == "UNIT_MP") and (arg0 == "target") and Target:IsPresent()) then
	--	TargetFrame_Update_MP();
	--	return;
	--end

	--if( (event == "UNIT_HP") and (arg0 == "target") and Target:IsPresent()) then
	--	TargetFrame_Update_HP();
	--	return;
	--end

	--if( (event == "UNIT_RAGE") and (arg0 == "target") and Target:IsPresent()) then
	--	TargetFrame_Update_Rage();
	--	return;
	--end

	--if( (event == "UNIT_LEVEL") and (arg0 == "target") and Target:IsPresent()) then
	--	TargetFrame_Update_Level();
	--	return;
	--end

	--if( (event == "UNIT_RELATIVE") and (arg0 == "target") and Target:IsPresent()) then
	--	TargetFrame_Update_Name();
	--	return;
	--end
end

function TargetFrame_Update_Head()
	local nModelID = Target:GetData("MODELID");
--	PushDebugMessage("nModelID "..nModelID)
	local tempNpcID = Target:GetData("NPCID");
	if (tempNpcID ~= nil) then
		if (g_TargetID ~= tempNpcID) then
			g_TargetID = tempNpcID
		end
	end
	local nNpcType = Target:GetData( "TYPE" );
	--ͷ���ˢ��
	if tonumber(nNpcType) == 2 then
		local TargetGuid = GetTargetPlayerGUID();
		if TargetGuid ~= nil  and TargetGuid ~= -1 then
		    local nNpcReputation = Target:GetData( "MEMPAI" );
		    if nNpcReputation >= 0 and nNpcReputation <= 13 then
				Clear_XSCRIPT();
					Set_XSCRIPT_Function_Name("TargetFrame");
					Set_XSCRIPT_ScriptID(500505);
					Set_XSCRIPT_Parameter(0,TargetGuid)
					Set_XSCRIPT_ParamCount(1)
				Send_XSCRIPT();
			end
		end
	end
end

function TargetFrame_Update_Name()
	local txtColor="#cFFFFFF";
--or Target:GetData("ISNPC") == 0
--��ǰ���ͳһ��ʾΪ��ɫ��������ö5��27���ĵ����ģ���Һ�NPC��ͬһ����
	if Target:GetData( "RELATIVE" ) == 2  then 
		txtColor = "#W"
	else
		txtColor = "#R"
	end
	TargetFrame_NameBar : Show();
	local occupation = Target:GetData("OCCUPATION")
	
	AxTrace(0,1,"OCCUPATION="..occupation)
	if(occupation == -1) then
		TargetFrame_NameBar : SetImageColor("FF00FF00")
	elseif(occupation == 0) then
		TargetFrame_NameBar : SetImageColor("FFFFFFFF")
	elseif(occupation == 1) then
		TargetFrame_NameBar : SetImageColor("FFFF0000")
	end

	TargetFrame_Name:SetText( txtColor..string_name(Target:GetName()));
	TargetFrame_Name:Show();
	AxTrace( 8,0,txtColor..Target:GetName() );
	local szIcon = Target : GetData("PORTRAIT");
	TargetFrame_Icon:SetProperty("Image", szIcon);
--����ж�Ŀ�����Ե����
	--���衱���ˡ����������ޡ���ç�����ޡ�������
	local nNpcType = Target:GetData( "TYPE" );
	TargetFrame_TypeIcon:SetProperty( "SetCurrentImage", "TypeName"..tostring( nNpcType ) );
	
	--1.�Ѻ�
	--2.����
	--3.����
	--4.��ͨ����
	--5.��Ӣ����
	--6.�з�boss	
	local nNpcRelation = Target:GetData( "RELATION" );
	TargetFrame_TypeFrame:SetProperty( "SetCurrentImage", "TypeFrame"..tostring( nNpcRelation ) );
	
	--��������
	local nNpcReputation = Target:GetData( "MEMPAI" );
	if( nNpcReputation == -1 ) then
		TargetFrame_CampFrame1:Hide();
	else
		TargetFrame_CampFrame1:Show();
		if nNpcReputation ~= 10 then
			TargetFrame_CampFrame:SetProperty( "SetCurrentImage", "Reputation"..tostring( nNpcReputation ) );
		else
			TargetFrame_CampFrame:SetProperty( "SetCurrentImage", "Reputation32");
		end
		TargetFrame_CampFrame:SetToolTip( strMenPaiName[ nNpcReputation + 1 ] );
	end
	local TargetGuid = GetTargetPlayerGUID()
	if TargetGuid ~=nil  and TargetGuid ~= -1 then
	    SetTargetMenuGUID(TargetGuid)
	end
	
end

function TargetFrame_Update_HP()
	local nNpcRelation = Target:GetData( "RELATION" );
	if( tonumber( nNpcRelation ) == 6 ) then
		TargetFrame_DataBack:Hide();
		TargetFrame_DataBack2:Show();
		local hp = Target:GetHPPercent();
		TargetFrame_HP_Boss1:SetProgress( hp * 3, 1 );
		TargetFrame_HP_Boss2:SetProgress( ( hp - 0.33333 ) * 3, 1 );
		TargetFrame_HP_Boss3:SetProgress( ( hp - 0.66666 ) * 3, 1 );
	else
		TargetFrame_DataBack:Show();
		TargetFrame_DataBack2:Hide();
		TargetFrame_HP:SetProgress(Target:GetHPPercent(), 1);
		TargetFrame_Update_Name();
	end
end

function TargetFrame_Update_MP()
	TargetFrame_MP:SetProgress(Target:GetMPPercent(), 1);
end

function TargetFrame_Update_Rage()
	TargetFrame_SP:SetProgress(Target:GetRagePercent(), 1);
end

function TargetFrame_Update_Level()

	local txtColor="#cFFFFFF";
	local level =  Target:GetData( "LEVEL" ) - Player:GetData( "LEVEL" );
	
	AxTrace( 0,0, "�ȼ���Ϊ"..tostring( level ) );
--������ö5��27�ղ߻��ĵ��޸�
--	if( level > 12 ) then
--		txtColor = "#R";
--	elseif( level > 4 ) then
--		txtColor = "#cff9000";
--		--��ǰ��c9ccf00��������ҫ�ṩ��.jpg�޸�
--	elseif( level > -4 ) then
--		txtColor="#Y";
--	elseif( level > -12 ) then
--		txtColor="#G"
--	else
--		txtColor="#c4b4b4b";
--������ҫ�����޸�
--		txtColor="#c240c0c";
--	end

--������ö5��27�ղ߻��ĵ��޸�����
	if( level > 5 ) then
		txtColor = "#R";
	elseif( level > 2 ) then
		txtColor = "#cff9000";
		--��ǰ��c9ccf00��������ҫ�ṩ��.jpg�޸�
	elseif( level >= -2 ) then
		txtColor="#Y";
	elseif( level >= -5 ) then
		txtColor="#W"
	else
--		txtColor="#c4b4b4b";
--������ҫ�����޸�
		txtColor="#W";
	end
	

	if( tonumber( Target:GetData( "LEVEL" ) ) >= 200 ) then
		TargetFrame_LevelText:SetText(txtColor .."?");
	else
		TargetFrame_LevelText:SetText(txtColor .. tostring(Target:GetData( "LEVEL" )));
	end
end

function TargetFrame_ArtLayout_Click()
	ShowContexMenu("other_player");
end

-- ��ʾ�Ҽ��˵�
function TargetFrame_Show_Menu_Func()

	--AxTrace( 0,0, "Target �Ҽ��˵�!");
	OpenTargetMenu();
end


function	TargetFrame_Update_Name_Team()

	local strName = Target:TargetFrame_Update_Name_Team();
	local nMenpai = Target:TargetFrame_Update_Menpai_Team();
	TargetFrame_Name:SetText(strName);
	if( tonumber(nMenpai) == -1 ) then
		TargetFrame_CampFrame1:Hide();
	else
		TargetFrame_CampFrame1:Show();
		TargetFrame_CampFrame:SetProperty( "SetCurrentImage", "Reputation"..tostring( nMenpai ) );
		TargetFrame_CampFrame:SetToolTip( strMenPaiName[ nMenpai + 1 ] );
	end
	local strIcon = Target:TargetFrame_Update_Icon_Team();
	TargetFrame_Icon:SetProperty("Image", strIcon);
	TargetFrame_TypeFrame:SetProperty( "SetCurrentImage", "TypeFrame1" );
	TargetFrame_TypeIcon:SetProperty( "SetCurrentImage", "TypeName2" );
end;

function 	TargetFrame_Update_HP_Team()

	local TeamHP = Target:TargetFrame_Update_HP_Team();
	TargetFrame_HP:SetProgress(TeamHP, 1);
end;
function GetDW(StrDW,Explain)

local g_XieZi_DwStr={
["ti01"]={"����","1��","0/2","����+20","set:TattooShow image:TattooShow_1",""},
["ti02"]={"����","2��","0/9","����+40","set:TattooShow image:TattooShow_1",""}, 
["ti03"]={"����","3��","0/50","����+60","set:TattooShow image:TattooShow_1",""}, 
["ti04"]={"����","4��","0/87","����+80","set:TattooShow image:TattooShow_2",""}, 
["ti05"]={"����","5��","0/165","����+100","set:TattooShow image:TattooShow_2",""}, 
["ti06"]={"����","6��","0/284","����+120","set:TattooShow image:TattooShow_2",""}, 
["ti07"]={"����","7��","0/811","����+140","set:TattooShow image:TattooShow_3",""}, 
["ti08"]={"����","8��","0/2088","����+160","set:TattooShow image:TattooShow_3",""}, 
["ti09"]={"����","9��","0/3570","����+180","set:TattooShow image:TattooShow_3",""}, 
["ti10"]={"����","10��","����","����+200","set:TattooShow image:TattooShow_4",""}, 

["ll01"]={"����","1��","0/2","����+20","set:TattooShow image:TattooShow_1",""},  
["ll02"]={"����","2��","0/9","����+40","set:TattooShow image:TattooShow_1",""}, 
["ll03"]={"����","3��","0/50","����+60","set:TattooShow image:TattooShow_1",""}, 
["ll04"]={"����","4��","0/87","����+80","set:TattooShow image:TattooShow_2",""}, 
["ll05"]={"����","5��","0/165","����+100","set:TattooShow image:TattooShow_2",""}, 
["ll06"]={"����","6��","0/284","����+120","set:TattooShow image:TattooShow_2",""}, 
["ll07"]={"����","7��","0/811","����+140","set:TattooShow image:TattooShow_3",""}, 
["ll08"]={"����","8��","0/2088","����+160","set:TattooShow image:TattooShow_3",""}, 
["ll09"]={"����","9��","0/3570","����+180","set:TattooShow image:TattooShow_3",""}, 
["ll10"]={"����","10��","����","����+200","set:TattooShow image:TattooShow_4",""}, 

["lt01"]={"����","1��","0/2","����+20","set:TattooShow image:TattooShow_1",""},  
["lt02"]={"����","2��","0/9","����+40","set:TattooShow image:TattooShow_1",""}, 
["lt03"]={"����","3��","0/50","����+60","set:TattooShow image:TattooShow_1",""}, 
["lt04"]={"����","4��","0/87","����+80","set:TattooShow image:TattooShow_2",""}, 
["lt05"]={"����","5��","0/165","����+100","set:TattooShow image:TattooShow_2",""}, 
["lt06"]={"����","6��","0/284","����+120","set:TattooShow image:TattooShow_2",""}, 
["lt07"]={"����","7��","0/811","����+140","set:TattooShow image:TattooShow_3",""}, 
["lt08"]={"����","8��","0/2088","����+160","set:TattooShow image:TattooShow_3",""}, 
["lt09"]={"����","9��","0/3570","����+180","set:TattooShow image:TattooShow_3",""}, 
["lt10"]={"����","10��","����","����+200","set:TattooShow image:TattooShow_4",""}, 

["sf01"]={"��","1��","0/2","��+20","set:TattooShow image:TattooShow_1",""},  
["sf02"]={"��","2��","0/9","��+40","set:TattooShow image:TattooShow_1",""}, 
["sf03"]={"��","3��","0/50","��+60","set:TattooShow image:TattooShow_1",""}, 
["sf04"]={"��","4��","0/87","��+80","set:TattooShow image:TattooShow_2",""}, 
["sf05"]={"��","5��","0/165","��+100","set:TattooShow image:TattooShow_2",""}, 
["sf06"]={"��","6��","0/284","��+120","set:TattooShow image:TattooShow_2",""}, 
["sf07"]={"��","7��","0/811","��+140","set:TattooShow image:TattooShow_3",""}, 
["sf08"]={"��","8��","0/2088","��+160","set:TattooShow image:TattooShow_3",""}, 
["sf09"]={"��","9��","0/3570","��+180","set:TattooShow image:TattooShow_3",""}, 
["sf10"]={"��","10��","����","��+200","set:TattooShow image:TattooShow_4",""}, 


["bg01"]={"����","1��","0/2","������+30","set:TattooShow image:TattooShow_9",""},  
["bg02"]={"����","2��","0/9","������+60","set:TattooShow image:TattooShow_9",""}, 
["bg03"]={"����","3��","0/50","������+90","set:TattooShow image:TattooShow_9",""}, 
["bg04"]={"����","4��","0/87","������+120","set:TattooShow image:TattooShow_10",""}, 
["bg05"]={"����","5��","0/165","������+150","set:TattooShow image:TattooShow_10",""}, 
["bg06"]={"����","6��","0/284","������+180","set:TattooShow image:TattooShow_10",""}, 
["bg07"]={"����","7��","0/811","������+210","set:TattooShow image:TattooShow_11",""}, 
["bg08"]={"����","8��","0/2088","������+240","set:TattooShow image:TattooShow_11",""}, 
["bg09"]={"����","9��","0/3570","������+270","set:TattooShow image:TattooShow_11",""}, 
["bg10"]={"����","10��","����","������+300","set:TattooShow image:TattooShow_12",""}, 

["hg01"]={"��","1��","0/2","�𹥻�+30","set:TattooShow image:TattooShow_9",""},  
["hg02"]={"��","2��","0/9","�𹥻�+60","set:TattooShow image:TattooShow_9",""}, 
["hg03"]={"��","3��","0/50","�𹥻�+90","set:TattooShow image:TattooShow_9",""}, 
["hg04"]={"��","4��","0/87","�𹥻�+120","set:TattooShow image:TattooShow_10",""}, 
["hg05"]={"��","5��","0/165","�𹥻�+150","set:TattooShow image:TattooShow_10",""}, 
["hg06"]={"��","6��","0/284","�𹥻�+180","set:TattooShow image:TattooShow_10",""}, 
["hg07"]={"��","7��","0/811","�𹥻�+210","set:TattooShow image:TattooShow_11",""}, 
["hg08"]={"��","8��","0/2088","�𹥻�+240","set:TattooShow image:TattooShow_11",""}, 
["hg09"]={"��","9��","0/3570","�𹥻�+270","set:TattooShow image:TattooShow_11",""}, 
["hg10"]={"��","10��","����","�𹥻�+300","set:TattooShow image:TattooShow_12",""}, 

["xg01"]={"����","1��","0/2","������+30","set:TattooShow image:TattooShow_9",""},  
["xg02"]={"����","2��","0/9","������+60","set:TattooShow image:TattooShow_9",""}, 
["xg03"]={"����","3��","0/50","������+90","set:TattooShow image:TattooShow_9",""}, 
["xg04"]={"����","4��","0/87","������+120","set:TattooShow image:TattooShow_10",""}, 
["xg05"]={"����","5��","0/165","������+150","set:TattooShow image:TattooShow_10",""}, 
["xg06"]={"����","6��","0/284","������+180","set:TattooShow image:TattooShow_10",""}, 
["xg07"]={"����","7��","0/811","������+210","set:TattooShow image:TattooShow_11",""}, 
["xg08"]={"����","8��","0/2088","������+240","set:TattooShow image:TattooShow_11",""}, 
["xg09"]={"����","9��","0/3570","������+270","set:TattooShow image:TattooShow_11",""}, 
["xg10"]={"����","10��","����","������+300","set:TattooShow image:TattooShow_12",""}, 

["dg01"]={"����","1��","0/2","������+30","set:TattooShow image:TattooShow_9",""},  
["dg02"]={"����","2��","0/9","������+60","set:TattooShow image:TattooShow_9",""}, 
["dg03"]={"����","3��","0/50","������+90","set:TattooShow image:TattooShow_9",""}, 
["dg04"]={"����","4��","0/87","������+120","set:TattooShow image:TattooShow_10",""}, 
["dg05"]={"����","5��","0/165","������+150","set:TattooShow image:TattooShow_10",""}, 
["dg06"]={"����","6��","0/284","������+180","set:TattooShow image:TattooShow_10",""}, 
["dg07"]={"����","7��","0/811","������+210","set:TattooShow image:TattooShow_11",""}, 
["dg08"]={"����","8��","0/2088","������+240","set:TattooShow image:TattooShow_11",""}, 
["dg09"]={"����","9��","0/3570","������+270","set:TattooShow image:TattooShow_11",""}, 
["dg10"]={"����","10��","����","������+300","set:TattooShow image:TattooShow_12",""}, 

["bj01"]={"������","1��","0/2","����Ŀ�����+8","set:TattooShow image:TattooShow_17",""},  
["bj02"]={"������","2��","0/9","����Ŀ�����+16","set:TattooShow image:TattooShow_17",""}, 
["bj03"]={"������","3��","0/50","����Ŀ�����+24","set:TattooShow image:TattooShow_17",""}, 
["bj04"]={"������","4��","0/87","����Ŀ�����+32","set:TattooShow image:TattooShow_18",""}, 
["bj05"]={"������","5��","0/165","����Ŀ�����+40","set:TattooShow image:TattooShow_18",""}, 
["bj06"]={"������","6��","0/284","����Ŀ�����+48","set:TattooShow image:TattooShow_18",""}, 
["bj07"]={"������","7��","0/811","����Ŀ�����+56","set:TattooShow image:TattooShow_19",""}, 
["bj08"]={"������","8��","0/2088","����Ŀ�����+64","set:TattooShow image:TattooShow_19",""}, 
["bj09"]={"������","9��","0/3570","����Ŀ�����+72","set:TattooShow image:TattooShow_19",""}, 
["bj10"]={"������","10��","����","����Ŀ�����+80","set:TattooShow image:TattooShow_20",""}, 

["hj01"]={"����","1��","0/2","����Ŀ���+8","set:TattooShow image:TattooShow_17",""},  
["hj02"]={"����","2��","0/9","����Ŀ���+16","set:TattooShow image:TattooShow_17",""}, 
["hj03"]={"����","3��","0/50","����Ŀ���+24","set:TattooShow image:TattooShow_17",""}, 
["hj04"]={"����","4��","0/87","����Ŀ���+32","set:TattooShow image:TattooShow_18",""}, 
["hj05"]={"����","5��","0/165","����Ŀ���+40","set:TattooShow image:TattooShow_18",""}, 
["hj06"]={"����","6��","0/284","����Ŀ���+48","set:TattooShow image:TattooShow_18",""}, 
["hj07"]={"����","7��","0/811","����Ŀ���+56","set:TattooShow image:TattooShow_19",""}, 
["hj08"]={"����","8��","0/2088","����Ŀ���+64","set:TattooShow image:TattooShow_19",""}, 
["hj09"]={"����","9��","0/3570","����Ŀ���+72","set:TattooShow image:TattooShow_19",""}, 
["hj10"]={"����","10��","����","����Ŀ���+80","set:TattooShow image:TattooShow_20",""}, 

["xj01"]={"������","1��","0/2","����Ŀ������+8","set:TattooShow image:TattooShow_17",""},  
["xj02"]={"������","2��","0/9","����Ŀ������+16","set:TattooShow image:TattooShow_17",""}, 
["xj03"]={"������","3��","0/50","����Ŀ������+24","set:TattooShow image:TattooShow_17",""}, 
["xj04"]={"������","4��","0/87","����Ŀ������+32","set:TattooShow image:TattooShow_18",""}, 
["xj05"]={"������","5��","0/165","����Ŀ������+40","set:TattooShow image:TattooShow_18",""}, 
["xj06"]={"������","6��","0/284","����Ŀ������+48","set:TattooShow image:TattooShow_18",""}, 
["xj07"]={"������","7��","0/811","����Ŀ������+56","set:TattooShow image:TattooShow_19",""}, 
["xj08"]={"������","8��","0/2088","����Ŀ������+64","set:TattooShow image:TattooShow_19",""}, 
["xj09"]={"������","9��","0/3570","����Ŀ������+72","set:TattooShow image:TattooShow_19",""}, 
["xj10"]={"������","10��","����","����Ŀ������+80","set:TattooShow image:TattooShow_20",""}, 

["dj01"]={"������","1��","0/2","����Ŀ�궾��+8","set:TattooShow image:TattooShow_17",""},  
["dj02"]={"������","2��","0/9","����Ŀ�궾��+16","set:TattooShow image:TattooShow_17",""}, 
["dj03"]={"������","3��","0/50","����Ŀ�궾��+24","set:TattooShow image:TattooShow_17",""}, 
["dj04"]={"������","4��","0/87","����Ŀ�궾��+32","set:TattooShow image:TattooShow_18",""}, 
["dj05"]={"������","5��","0/165","����Ŀ�궾��+40","set:TattooShow image:TattooShow_18",""}, 
["dj06"]={"������","6��","0/284","����Ŀ�궾��+48","set:TattooShow image:TattooShow_18",""}, 
["dj07"]={"������","7��","0/811","����Ŀ�궾��+56","set:TattooShow image:TattooShow_19",""}, 
["dj08"]={"������","8��","0/2088","����Ŀ�궾��+64","set:TattooShow image:TattooShow_19",""}, 
["dj09"]={"������","9��","0/3570","����Ŀ�궾��+72","set:TattooShow image:TattooShow_19",""}, 
["dj10"]={"������","10��","����","����Ŀ�궾��+80","set:TattooShow image:TattooShow_20",""}, 

["bk01"]={"����","1��","0/2","������+8","set:TattooShow image:TattooShow_13",""},  
["bk02"]={"����","2��","0/9","������+16","set:TattooShow image:TattooShow_13",""}, 
["bk03"]={"����","3��","0/50","������+24","set:TattooShow image:TattooShow_13",""}, 
["bk04"]={"����","4��","0/87","������+32","set:TattooShow image:TattooShow_14",""}, 
["bk05"]={"����","5��","0/165","������+40","set:TattooShow image:TattooShow_14",""}, 
["bk06"]={"����","6��","0/284","������+48","set:TattooShow image:TattooShow_14",""}, 
["bk07"]={"����","7��","0/811","������+56","set:TattooShow image:TattooShow_15",""}, 
["bk08"]={"����","8��","0/2088","������+64","set:TattooShow image:TattooShow_15",""}, 
["bk09"]={"����","9��","0/3570","������+72","set:TattooShow image:TattooShow_15",""}, 
["bk10"]={"����","10��","����","������+80","set:TattooShow image:TattooShow_16",""}, 

["hk01"]={"��","1��","0/2","����+8","set:TattooShow image:TattooShow_13",""},  
["hk02"]={"��","2��","0/9","����+16","set:TattooShow image:TattooShow_13",""}, 
["hk03"]={"��","3��","0/50","����+24","set:TattooShow image:TattooShow_13",""}, 
["hk04"]={"��","4��","0/87","����+32","set:TattooShow image:TattooShow_14",""}, 
["hk05"]={"��","5��","0/165","����+40","set:TattooShow image:TattooShow_14",""}, 
["hk06"]={"��","6��","0/284","����+48","set:TattooShow image:TattooShow_14",""}, 
["hk07"]={"��","7��","0/811","����+56","set:TattooShow image:TattooShow_15",""}, 
["hk08"]={"��","8��","0/2088","����+64","set:TattooShow image:TattooShow_15",""}, 
["hk09"]={"��","9��","0/3570","����+72","set:TattooShow image:TattooShow_15",""}, 
["hk10"]={"��","10��","����","����+80","set:TattooShow image:TattooShow_16",""}, 

["xk01"]={"����","1��","0/2","������+8","set:TattooShow image:TattooShow_13",""},  
["xk02"]={"����","2��","0/9","������+16","set:TattooShow image:TattooShow_13",""}, 
["xk03"]={"����","3��","0/50","������+24","set:TattooShow image:TattooShow_13",""}, 
["xk04"]={"����","4��","0/87","������+32","set:TattooShow image:TattooShow_14",""}, 
["xk05"]={"����","5��","0/165","������+40","set:TattooShow image:TattooShow_14",""}, 
["xk06"]={"����","6��","0/284","������+48","set:TattooShow image:TattooShow_14",""}, 
["xk07"]={"����","7��","0/811","������+56","set:TattooShow image:TattooShow_15",""}, 
["xk08"]={"����","8��","0/2088","������+64","set:TattooShow image:TattooShow_15",""}, 
["xk09"]={"����","9��","0/3570","������+72","set:TattooShow image:TattooShow_15",""}, 
["xk10"]={"����","10��","����","������+80","set:TattooShow image:TattooShow_16",""}, 

["dk01"]={"����","1��","0/2","������+8","set:TattooShow image:TattooShow_13",""},  
["dk02"]={"����","2��","0/9","������+16","set:TattooShow image:TattooShow_13",""}, 
["dk03"]={"����","3��","0/50","������+24","set:TattooShow image:TattooShow_13",""}, 
["dk04"]={"����","4��","0/87","������+32","set:TattooShow image:TattooShow_14",""}, 
["dk05"]={"����","5��","0/165","������+40","set:TattooShow image:TattooShow_14",""}, 
["dk06"]={"����","6��","0/284","������+48","set:TattooShow image:TattooShow_14",""}, 
["dk07"]={"����","7��","0/811","������+56","set:TattooShow image:TattooShow_15",""}, 
["dk08"]={"����","8��","0/2088","������+64","set:TattooShow image:TattooShow_15",""}, 
["dk09"]={"����","9��","0/3570","������+72","set:TattooShow image:TattooShow_15",""}, 
["dk10"]={"����","10��","����","������+80","set:TattooShow image:TattooShow_16",""}, 

["ww01"]={"����","1��","0/2","ǿ����һ���ķ���һ�����ܣ������˺�15","set:TattooShow image:TattooShow_5",""},  
["ww02"]={"����","2��","0/9","ǿ����һ���ķ���һ�����ܣ������˺�30","set:TattooShow image:TattooShow_5",""}, 
["ww03"]={"����","3��","0/50","ǿ����һ���ķ���һ�����ܣ������˺�45","set:TattooShow image:TattooShow_5",""}, 
["ww04"]={"����","4��","0/87","ǿ����һ���ķ���һ�����ܣ������˺�90","set:TattooShow image:TattooShow_6",""}, 
["ww05"]={"����","5��","0/165","ǿ����һ���ķ���һ�����ܣ������˺�150","set:TattooShow image:TattooShow_6",""}, 
["ww06"]={"����","6��","0/284","ǿ����һ���ķ���һ�����ܣ������˺�180","set:TattooShow image:TattooShow_6",""}, 
["ww07"]={"����","7��","0/811","ǿ����һ���ķ���һ�����ܣ������˺�195","set:TattooShow image:TattooShow_7",""}, 
["ww08"]={"����","8��","0/2088","ǿ����һ���ķ���һ�����ܣ������˺�210","set:TattooShow image:TattooShow_7",""}, 
["ww09"]={"����","9��","0/3570","ǿ����һ���ķ���һ�����ܣ������˺�270","set:TattooShow image:TattooShow_7",""}, 
["ww10"]={"����","10��","����","ǿ����һ���ķ���һ�����ܣ������˺�360","set:TattooShow image:TattooShow_8",""}, 

["mx01"]={"ڤ��","1��","0/2","ǿ���ڶ����ķ���һ�����ܣ����ܵ��˺�Ч������10��","set:TattooShow image:TattooShow_5",""},  
["mx02"]={"ڤ��","2��","0/9","ǿ���ڶ����ķ���һ�����ܣ����ܵ��˺�Ч������20��","set:TattooShow image:TattooShow_5",""}, 
["mx03"]={"ڤ��","3��","0/50","ǿ���ڶ����ķ���һ�����ܣ����ܵ��˺�Ч������40��","set:TattooShow image:TattooShow_5",""}, 
["mx04"]={"ڤ��","4��","0/87","ǿ���ڶ����ķ���һ�����ܣ����ܵ��˺�Ч������70��","set:TattooShow image:TattooShow_6",""}, 
["mx05"]={"ڤ��","5��","0/165","ǿ���ڶ����ķ���һ�����ܣ����ܵ��˺�Ч������100��","set:TattooShow image:TattooShow_6",""}, 
["mx06"]={"ڤ��","6��","0/284","ǿ���ڶ����ķ���һ�����ܣ����ܵ��˺�Ч������110��","set:TattooShow image:TattooShow_6",""}, 
["mx07"]={"ڤ��","7��","0/811","ǿ���ڶ����ķ���һ�����ܣ����ܵ��˺�Ч������120��","set:TattooShow image:TattooShow_7",""}, 
["mx08"]={"ڤ��","8��","0/2088","ǿ���ڶ����ķ���һ�����ܣ����ܵ��˺�Ч������130��","set:TattooShow image:TattooShow_7",""}, 
["mx09"]={"ڤ��","9��","0/3570","ǿ���ڶ����ķ���һ�����ܣ����ܵ��˺�Ч������140��","set:TattooShow image:TattooShow_7",""}, 
["mx10"]={"ڤ��","10��","����","ǿ���ڶ����ķ���һ�����ܣ����ܵ��˺�Ч������150��","set:TattooShow image:TattooShow_8",""}, 

["yj01"]={"����","1��","0/2","ǿ�����屾�ķ����������ܣ����ܵ��˺�Ч������10��","set:TattooShow image:TattooShow_5",""},  
["yj02"]={"����","2��","0/9","ǿ�����屾�ķ����������ܣ����ܵ��˺�Ч������20��","set:TattooShow image:TattooShow_5",""}, 
["yj03"]={"����","3��","0/50","ǿ�����屾�ķ����������ܣ����ܵ��˺�Ч������40��","set:TattooShow image:TattooShow_5",""}, 
["yj04"]={"����","4��","0/87","ǿ�����屾�ķ����������ܣ����ܵ��˺�Ч������70��","set:TattooShow image:TattooShow_6",""}, 
["yj05"]={"����","5��","0/165","ǿ�����屾�ķ����������ܣ����ܵ��˺�Ч������100��","set:TattooShow image:TattooShow_6",""}, 
["yj06"]={"����","6��","0/284","ǿ�����屾�ķ����������ܣ����ܵ��˺�Ч������110��","set:TattooShow image:TattooShow_6",""}, 
["yj07"]={"����","7��","0/811","ǿ�����屾�ķ����������ܣ����ܵ��˺�Ч������120��","set:TattooShow image:TattooShow_7",""}, 
["yj08"]={"����","8��","0/2088","ǿ�����屾�ķ����������ܣ����ܵ��˺�Ч������130��","set:TattooShow image:TattooShow_7",""}, 
["yj09"]={"����","9��","0/3570","ǿ�����屾�ķ����������ܣ����ܵ��˺�Ч������140��","set:TattooShow image:TattooShow_7",""}, 
["yj10"]={"����","10��","����","ǿ�����屾�ķ����������ܣ����ܵ��˺�Ч������150��","set:TattooShow image:TattooShow_8",""}, 

["bn01"]={"��ŭ","1��","0/2","ǿ���������ķ���һ�����ܣ����ܵ��˺�Ч������10��","set:TattooShow image:TattooShow_5",""},  
["bn02"]={"��ŭ","2��","0/9","ǿ���������ķ���һ�����ܣ����ܵ��˺�Ч������20��","set:TattooShow image:TattooShow_5",""}, 
["bn03"]={"��ŭ","3��","0/50","ǿ���������ķ���һ�����ܣ����ܵ��˺�Ч������40��","set:TattooShow image:TattooShow_5",""}, 
["bn04"]={"��ŭ","4��","0/87","ǿ���������ķ���һ�����ܣ����ܵ��˺�Ч������70��","set:TattooShow image:TattooShow_6",""}, 
["bn05"]={"��ŭ","5��","0/165","ǿ���������ķ���һ�����ܣ����ܵ��˺�Ч������100��","set:TattooShow image:TattooShow_6",""}, 
["bn06"]={"��ŭ","6��","0/284","ǿ���������ķ���һ�����ܣ����ܵ��˺�Ч������110��","set:TattooShow image:TattooShow_6",""}, 
["bn07"]={"��ŭ","7��","0/811","ǿ���������ķ���һ�����ܣ����ܵ��˺�Ч������120��","set:TattooShow image:TattooShow_7",""}, 
["bn08"]={"��ŭ","8��","0/2088","ǿ���������ķ���һ�����ܣ����ܵ��˺�Ч������130��","set:TattooShow image:TattooShow_7",""}, 
["bn09"]={"��ŭ","9��","0/3570","ǿ���������ķ���һ�����ܣ����ܵ��˺�Ч������140��","set:TattooShow image:TattooShow_7",""}, 
["bn10"]={"��ŭ","10��","����","ǿ���������ķ���һ�����ܣ����ܵ��˺�Ч������150��","set:TattooShow image:TattooShow_8",""}, 
}	
local DarkDwData = {[1]="ti",[2]="bg",[3]="hg",[4]="xg",[5]="dg",[6]="bj",[7]="hj",[8]="xj",[9]="dj"}

local b ,c ,d="","",""
--*****************************************************
--Q546528533������Ӱ�����������
--*****************************************************
    if string.find(Explain,"����ƿ��") ~= nil then
	    local nDarkDW = DataPool:GetPlayerMission_DataRound(503)
		if nDarkDW == 0 then
		    return 0,0,0
		end
		local nDarkDWData,nDarkDWLevel = math.floor(nDarkDW/100),math.mod(nDarkDW,100)
        nDarkDWData = DarkDwData[nDarkDWData]
		if nDarkDWData ~= nil then
		    if nDarkDWLevel < 10 then
			    nDarkDWLevel = "0"..nDarkDWLevel
			end
			-- PushDebugMessage("nDarkDWLevel  "..nDarkDWLevel)
			-- PushDebugMessage("nDarkDWData  "..nDarkDWData)
			local nData = nDarkDWData..nDarkDWLevel
		    b ="#cFF0000"..g_XieZi_DwStr[nData][1].."����"..g_XieZi_DwStr[nData][2].."\n������Ҫ�Ĳ�������"..g_XieZi_DwStr[nData][3].."\n"..g_XieZi_DwStr[nData][4].."\n"
		    c= g_XieZi_DwStr[nData][5]
			d= 0
			return b,c,d
		else
		    return  0,0,0
		end
	    return  0,0,0
	end
--*****************************************************
--Q546528533������Ӱ�����������
--*****************************************************	
if StrDW ==nil or StrDW =="" then 
return 0,0,0
end 
local ax,ay,str,str1 = string.find(StrDW,"&DW("..string.rep("%w",4)..")("..string.rep("%w",4)..")")
 if ax ==nil or ay ==nil or str==nil then
return 0,0,0
end
if g_XieZi_DwStr[str] == nil then
return 0,0,0	
end	

if g_XieZi_DwStr[str] ~= nil and g_XieZi_DwStr[str1] == nil then
 b ="#cFF0000"..g_XieZi_DwStr[str][1].."����"..g_XieZi_DwStr[str][2].."\n������Ҫ�Ĳ�������"..g_XieZi_DwStr[str][3].."\n"..g_XieZi_DwStr[str][4].."\n"
 c= g_XieZi_DwStr[str][5]
 d= 0
end 

if g_XieZi_DwStr[str] ~= nil and g_XieZi_DwStr[str1] ~= nil then
 b ="#cFF0000˫�����ƣ�"..g_XieZi_DwStr[str][1].."��"..g_XieZi_DwStr[str1][1].."("..g_XieZi_DwStr[str][2].."��"..g_XieZi_DwStr[str1][2]..")\n�������裺"..g_XieZi_DwStr[str][1].."("..g_XieZi_DwStr[str][3]..") "..g_XieZi_DwStr[str1][1].."("..g_XieZi_DwStr[str1][3]..") \n˫����"..g_XieZi_DwStr[str][1].."��"..g_XieZi_DwStr[str][4].."\n˫����"..g_XieZi_DwStr[str1][1].."��"..g_XieZi_DwStr[str1][4].."\n"
 c= g_XieZi_DwStr[str][5]
 d= g_XieZi_DwStr[str1][5]
end 
return b,c,d
end
function	TargetFrame_Update_MP_Team()
	
	local TeamMp = Target:TargetFrame_Update_MP_Team();
	TargetFrame_MP:SetProgress(TeamMp, 1);
end;

function	TargetFrame_Update_Rage_Team()

	local TeamRange = Target:TargetFrame_Update_Rage_Team();
	TargetFrame_SP:SetProgress(TeamRange, 1000);
end;

function	TargetFrame_Update_Level_Team()

	local TeamLevel = Target:TargetFrame_Update_Level_Team();
	TargetFrame_LevelText:SetText(tostring(TeamLevel));
end;


function GetDWEx(StrDW,Explain)

local g_XieZi_DwStr={
["ti01"]={"����","1��","0/2","����+20","set:TattooShow image:TattooShow_1",""},
["ti02"]={"����","2��","0/9","����+40","set:TattooShow image:TattooShow_1",""}, 
["ti03"]={"����","3��","0/50","����+60","set:TattooShow image:TattooShow_1",""}, 
["ti04"]={"����","4��","0/87","����+80","set:TattooShow image:TattooShow_2",""}, 
["ti05"]={"����","5��","0/165","����+100","set:TattooShow image:TattooShow_2",""}, 
["ti06"]={"����","6��","0/284","����+120","set:TattooShow image:TattooShow_2",""}, 
["ti07"]={"����","7��","0/811","����+140","set:TattooShow image:TattooShow_3",""}, 
["ti08"]={"����","8��","0/2088","����+160","set:TattooShow image:TattooShow_3",""}, 
["ti09"]={"����","9��","0/3570","����+180","set:TattooShow image:TattooShow_3",""}, 
["ti10"]={"����","10��","����","����+200","set:TattooShow image:TattooShow_4",""}, 

["ll01"]={"����","1��","0/2","����+20","set:TattooShow image:TattooShow_1",""},  
["ll02"]={"����","2��","0/9","����+40","set:TattooShow image:TattooShow_1",""}, 
["ll03"]={"����","3��","0/50","����+60","set:TattooShow image:TattooShow_1",""}, 
["ll04"]={"����","4��","0/87","����+80","set:TattooShow image:TattooShow_2",""}, 
["ll05"]={"����","5��","0/165","����+100","set:TattooShow image:TattooShow_2",""}, 
["ll06"]={"����","6��","0/284","����+120","set:TattooShow image:TattooShow_2",""}, 
["ll07"]={"����","7��","0/811","����+140","set:TattooShow image:TattooShow_3",""}, 
["ll08"]={"����","8��","0/2088","����+160","set:TattooShow image:TattooShow_3",""}, 
["ll09"]={"����","9��","0/3570","����+180","set:TattooShow image:TattooShow_3",""}, 
["ll10"]={"����","10��","����","����+200","set:TattooShow image:TattooShow_4",""}, 

["lt01"]={"����","1��","0/2","����+20","set:TattooShow image:TattooShow_1",""},  
["lt02"]={"����","2��","0/9","����+40","set:TattooShow image:TattooShow_1",""}, 
["lt03"]={"����","3��","0/50","����+60","set:TattooShow image:TattooShow_1",""}, 
["lt04"]={"����","4��","0/87","����+80","set:TattooShow image:TattooShow_2",""}, 
["lt05"]={"����","5��","0/165","����+100","set:TattooShow image:TattooShow_2",""}, 
["lt06"]={"����","6��","0/284","����+120","set:TattooShow image:TattooShow_2",""}, 
["lt07"]={"����","7��","0/811","����+140","set:TattooShow image:TattooShow_3",""}, 
["lt08"]={"����","8��","0/2088","����+160","set:TattooShow image:TattooShow_3",""}, 
["lt09"]={"����","9��","0/3570","����+180","set:TattooShow image:TattooShow_3",""}, 
["lt10"]={"����","10��","����","����+200","set:TattooShow image:TattooShow_4",""}, 

["sf01"]={"��","1��","0/2","��+20","set:TattooShow image:TattooShow_1",""},  
["sf02"]={"��","2��","0/9","��+40","set:TattooShow image:TattooShow_1",""}, 
["sf03"]={"��","3��","0/50","��+60","set:TattooShow image:TattooShow_1",""}, 
["sf04"]={"��","4��","0/87","��+80","set:TattooShow image:TattooShow_2",""}, 
["sf05"]={"��","5��","0/165","��+100","set:TattooShow image:TattooShow_2",""}, 
["sf06"]={"��","6��","0/284","��+120","set:TattooShow image:TattooShow_2",""}, 
["sf07"]={"��","7��","0/811","��+140","set:TattooShow image:TattooShow_3",""}, 
["sf08"]={"��","8��","0/2088","��+160","set:TattooShow image:TattooShow_3",""}, 
["sf09"]={"��","9��","0/3570","��+180","set:TattooShow image:TattooShow_3",""}, 
["sf10"]={"��","10��","����","��+200","set:TattooShow image:TattooShow_4",""}, 


["bg01"]={"����","1��","0/2","������+30","set:TattooShow image:TattooShow_9",""},  
["bg02"]={"����","2��","0/9","������+60","set:TattooShow image:TattooShow_9",""}, 
["bg03"]={"����","3��","0/50","������+90","set:TattooShow image:TattooShow_9",""}, 
["bg04"]={"����","4��","0/87","������+120","set:TattooShow image:TattooShow_10",""}, 
["bg05"]={"����","5��","0/165","������+150","set:TattooShow image:TattooShow_10",""}, 
["bg06"]={"����","6��","0/284","������+180","set:TattooShow image:TattooShow_10",""}, 
["bg07"]={"����","7��","0/811","������+210","set:TattooShow image:TattooShow_11",""}, 
["bg08"]={"����","8��","0/2088","������+240","set:TattooShow image:TattooShow_11",""}, 
["bg09"]={"����","9��","0/3570","������+270","set:TattooShow image:TattooShow_11",""}, 
["bg10"]={"����","10��","����","������+300","set:TattooShow image:TattooShow_12",""}, 

["hg01"]={"��","1��","0/2","�𹥻�+30","set:TattooShow image:TattooShow_9",""},  
["hg02"]={"��","2��","0/9","�𹥻�+60","set:TattooShow image:TattooShow_9",""}, 
["hg03"]={"��","3��","0/50","�𹥻�+90","set:TattooShow image:TattooShow_9",""}, 
["hg04"]={"��","4��","0/87","�𹥻�+120","set:TattooShow image:TattooShow_10",""}, 
["hg05"]={"��","5��","0/165","�𹥻�+150","set:TattooShow image:TattooShow_10",""}, 
["hg06"]={"��","6��","0/284","�𹥻�+180","set:TattooShow image:TattooShow_10",""}, 
["hg07"]={"��","7��","0/811","�𹥻�+210","set:TattooShow image:TattooShow_11",""}, 
["hg08"]={"��","8��","0/2088","�𹥻�+240","set:TattooShow image:TattooShow_11",""}, 
["hg09"]={"��","9��","0/3570","�𹥻�+270","set:TattooShow image:TattooShow_11",""}, 
["hg10"]={"��","10��","����","�𹥻�+300","set:TattooShow image:TattooShow_12",""}, 

["xg01"]={"����","1��","0/2","������+30","set:TattooShow image:TattooShow_9",""},  
["xg02"]={"����","2��","0/9","������+60","set:TattooShow image:TattooShow_9",""}, 
["xg03"]={"����","3��","0/50","������+90","set:TattooShow image:TattooShow_9",""}, 
["xg04"]={"����","4��","0/87","������+120","set:TattooShow image:TattooShow_10",""}, 
["xg05"]={"����","5��","0/165","������+150","set:TattooShow image:TattooShow_10",""}, 
["xg06"]={"����","6��","0/284","������+180","set:TattooShow image:TattooShow_10",""}, 
["xg07"]={"����","7��","0/811","������+210","set:TattooShow image:TattooShow_11",""}, 
["xg08"]={"����","8��","0/2088","������+240","set:TattooShow image:TattooShow_11",""}, 
["xg09"]={"����","9��","0/3570","������+270","set:TattooShow image:TattooShow_11",""}, 
["xg10"]={"����","10��","����","������+300","set:TattooShow image:TattooShow_12",""}, 

["dg01"]={"����","1��","0/2","������+30","set:TattooShow image:TattooShow_9",""},  
["dg02"]={"����","2��","0/9","������+60","set:TattooShow image:TattooShow_9",""}, 
["dg03"]={"����","3��","0/50","������+90","set:TattooShow image:TattooShow_9",""}, 
["dg04"]={"����","4��","0/87","������+120","set:TattooShow image:TattooShow_10",""}, 
["dg05"]={"����","5��","0/165","������+150","set:TattooShow image:TattooShow_10",""}, 
["dg06"]={"����","6��","0/284","������+180","set:TattooShow image:TattooShow_10",""}, 
["dg07"]={"����","7��","0/811","������+210","set:TattooShow image:TattooShow_11",""}, 
["dg08"]={"����","8��","0/2088","������+240","set:TattooShow image:TattooShow_11",""}, 
["dg09"]={"����","9��","0/3570","������+270","set:TattooShow image:TattooShow_11",""}, 
["dg10"]={"����","10��","����","������+300","set:TattooShow image:TattooShow_12",""}, 

["bj01"]={"������","1��","0/2","����Ŀ�����+8","set:TattooShow image:TattooShow_17",""},  
["bj02"]={"������","2��","0/9","����Ŀ�����+16","set:TattooShow image:TattooShow_17",""}, 
["bj03"]={"������","3��","0/50","����Ŀ�����+24","set:TattooShow image:TattooShow_17",""}, 
["bj04"]={"������","4��","0/87","����Ŀ�����+32","set:TattooShow image:TattooShow_18",""}, 
["bj05"]={"������","5��","0/165","����Ŀ�����+40","set:TattooShow image:TattooShow_18",""}, 
["bj06"]={"������","6��","0/284","����Ŀ�����+48","set:TattooShow image:TattooShow_18",""}, 
["bj07"]={"������","7��","0/811","����Ŀ�����+56","set:TattooShow image:TattooShow_19",""}, 
["bj08"]={"������","8��","0/2088","����Ŀ�����+64","set:TattooShow image:TattooShow_19",""}, 
["bj09"]={"������","9��","0/3570","����Ŀ�����+72","set:TattooShow image:TattooShow_19",""}, 
["bj10"]={"������","10��","����","����Ŀ�����+80","set:TattooShow image:TattooShow_20",""}, 

["hj01"]={"����","1��","0/2","����Ŀ���+8","set:TattooShow image:TattooShow_17",""},  
["hj02"]={"����","2��","0/9","����Ŀ���+16","set:TattooShow image:TattooShow_17",""}, 
["hj03"]={"����","3��","0/50","����Ŀ���+24","set:TattooShow image:TattooShow_17",""}, 
["hj04"]={"����","4��","0/87","����Ŀ���+32","set:TattooShow image:TattooShow_18",""}, 
["hj05"]={"����","5��","0/165","����Ŀ���+40","set:TattooShow image:TattooShow_18",""}, 
["hj06"]={"����","6��","0/284","����Ŀ���+48","set:TattooShow image:TattooShow_18",""}, 
["hj07"]={"����","7��","0/811","����Ŀ���+56","set:TattooShow image:TattooShow_19",""}, 
["hj08"]={"����","8��","0/2088","����Ŀ���+64","set:TattooShow image:TattooShow_19",""}, 
["hj09"]={"����","9��","0/3570","����Ŀ���+72","set:TattooShow image:TattooShow_19",""}, 
["hj10"]={"����","10��","����","����Ŀ���+80","set:TattooShow image:TattooShow_20",""}, 

["xj01"]={"������","1��","0/2","����Ŀ������+8","set:TattooShow image:TattooShow_17",""},  
["xj02"]={"������","2��","0/9","����Ŀ������+16","set:TattooShow image:TattooShow_17",""}, 
["xj03"]={"������","3��","0/50","����Ŀ������+24","set:TattooShow image:TattooShow_17",""}, 
["xj04"]={"������","4��","0/87","����Ŀ������+32","set:TattooShow image:TattooShow_18",""}, 
["xj05"]={"������","5��","0/165","����Ŀ������+40","set:TattooShow image:TattooShow_18",""}, 
["xj06"]={"������","6��","0/284","����Ŀ������+48","set:TattooShow image:TattooShow_18",""}, 
["xj07"]={"������","7��","0/811","����Ŀ������+56","set:TattooShow image:TattooShow_19",""}, 
["xj08"]={"������","8��","0/2088","����Ŀ������+64","set:TattooShow image:TattooShow_19",""}, 
["xj09"]={"������","9��","0/3570","����Ŀ������+72","set:TattooShow image:TattooShow_19",""}, 
["xj10"]={"������","10��","����","����Ŀ������+80","set:TattooShow image:TattooShow_20",""}, 

["dj01"]={"������","1��","0/2","����Ŀ�궾��+8","set:TattooShow image:TattooShow_17",""},  
["dj02"]={"������","2��","0/9","����Ŀ�궾��+16","set:TattooShow image:TattooShow_17",""}, 
["dj03"]={"������","3��","0/50","����Ŀ�궾��+24","set:TattooShow image:TattooShow_17",""}, 
["dj04"]={"������","4��","0/87","����Ŀ�궾��+32","set:TattooShow image:TattooShow_18",""}, 
["dj05"]={"������","5��","0/165","����Ŀ�궾��+40","set:TattooShow image:TattooShow_18",""}, 
["dj06"]={"������","6��","0/284","����Ŀ�궾��+48","set:TattooShow image:TattooShow_18",""}, 
["dj07"]={"������","7��","0/811","����Ŀ�궾��+56","set:TattooShow image:TattooShow_19",""}, 
["dj08"]={"������","8��","0/2088","����Ŀ�궾��+64","set:TattooShow image:TattooShow_19",""}, 
["dj09"]={"������","9��","0/3570","����Ŀ�궾��+72","set:TattooShow image:TattooShow_19",""}, 
["dj10"]={"������","10��","����","����Ŀ�궾��+80","set:TattooShow image:TattooShow_20",""}, 

["bk01"]={"����","1��","0/2","������+8","set:TattooShow image:TattooShow_13",""},  
["bk02"]={"����","2��","0/9","������+16","set:TattooShow image:TattooShow_13",""}, 
["bk03"]={"����","3��","0/50","������+24","set:TattooShow image:TattooShow_13",""}, 
["bk04"]={"����","4��","0/87","������+32","set:TattooShow image:TattooShow_14",""}, 
["bk05"]={"����","5��","0/165","������+40","set:TattooShow image:TattooShow_14",""}, 
["bk06"]={"����","6��","0/284","������+48","set:TattooShow image:TattooShow_14",""}, 
["bk07"]={"����","7��","0/811","������+56","set:TattooShow image:TattooShow_15",""}, 
["bk08"]={"����","8��","0/2088","������+64","set:TattooShow image:TattooShow_15",""}, 
["bk09"]={"����","9��","0/3570","������+72","set:TattooShow image:TattooShow_15",""}, 
["bk10"]={"����","10��","����","������+80","set:TattooShow image:TattooShow_16",""}, 

["hk01"]={"��","1��","0/2","����+8","set:TattooShow image:TattooShow_13",""},  
["hk02"]={"��","2��","0/9","����+16","set:TattooShow image:TattooShow_13",""}, 
["hk03"]={"��","3��","0/50","����+24","set:TattooShow image:TattooShow_13",""}, 
["hk04"]={"��","4��","0/87","����+32","set:TattooShow image:TattooShow_14",""}, 
["hk05"]={"��","5��","0/165","����+40","set:TattooShow image:TattooShow_14",""}, 
["hk06"]={"��","6��","0/284","����+48","set:TattooShow image:TattooShow_14",""}, 
["hk07"]={"��","7��","0/811","����+56","set:TattooShow image:TattooShow_15",""}, 
["hk08"]={"��","8��","0/2088","����+64","set:TattooShow image:TattooShow_15",""}, 
["hk09"]={"��","9��","0/3570","����+72","set:TattooShow image:TattooShow_15",""}, 
["hk10"]={"��","10��","����","����+80","set:TattooShow image:TattooShow_16",""}, 

["xk01"]={"����","1��","0/2","������+8","set:TattooShow image:TattooShow_13",""},  
["xk02"]={"����","2��","0/9","������+16","set:TattooShow image:TattooShow_13",""}, 
["xk03"]={"����","3��","0/50","������+24","set:TattooShow image:TattooShow_13",""}, 
["xk04"]={"����","4��","0/87","������+32","set:TattooShow image:TattooShow_14",""}, 
["xk05"]={"����","5��","0/165","������+40","set:TattooShow image:TattooShow_14",""}, 
["xk06"]={"����","6��","0/284","������+48","set:TattooShow image:TattooShow_14",""}, 
["xk07"]={"����","7��","0/811","������+56","set:TattooShow image:TattooShow_15",""}, 
["xk08"]={"����","8��","0/2088","������+64","set:TattooShow image:TattooShow_15",""}, 
["xk09"]={"����","9��","0/3570","������+72","set:TattooShow image:TattooShow_15",""}, 
["xk10"]={"����","10��","����","������+80","set:TattooShow image:TattooShow_16",""}, 

["dk01"]={"����","1��","0/2","������+8","set:TattooShow image:TattooShow_13",""},  
["dk02"]={"����","2��","0/9","������+16","set:TattooShow image:TattooShow_13",""}, 
["dk03"]={"����","3��","0/50","������+24","set:TattooShow image:TattooShow_13",""}, 
["dk04"]={"����","4��","0/87","������+32","set:TattooShow image:TattooShow_14",""}, 
["dk05"]={"����","5��","0/165","������+40","set:TattooShow image:TattooShow_14",""}, 
["dk06"]={"����","6��","0/284","������+48","set:TattooShow image:TattooShow_14",""}, 
["dk07"]={"����","7��","0/811","������+56","set:TattooShow image:TattooShow_15",""}, 
["dk08"]={"����","8��","0/2088","������+64","set:TattooShow image:TattooShow_15",""}, 
["dk09"]={"����","9��","0/3570","������+72","set:TattooShow image:TattooShow_15",""}, 
["dk10"]={"����","10��","����","������+80","set:TattooShow image:TattooShow_16",""}, 

["ww01"]={"����","1��","0/2","ǿ����һ���ķ���һ�����ܣ������˺�15","set:TattooShow image:TattooShow_5",""},  
["ww02"]={"����","2��","0/9","ǿ����һ���ķ���һ�����ܣ������˺�30","set:TattooShow image:TattooShow_5",""}, 
["ww03"]={"����","3��","0/50","ǿ����һ���ķ���һ�����ܣ������˺�45","set:TattooShow image:TattooShow_5",""}, 
["ww04"]={"����","4��","0/87","ǿ����һ���ķ���һ�����ܣ������˺�90","set:TattooShow image:TattooShow_6",""}, 
["ww05"]={"����","5��","0/165","ǿ����һ���ķ���һ�����ܣ������˺�150","set:TattooShow image:TattooShow_6",""}, 
["ww06"]={"����","6��","0/284","ǿ����һ���ķ���һ�����ܣ������˺�180","set:TattooShow image:TattooShow_6",""}, 
["ww07"]={"����","7��","0/811","ǿ����һ���ķ���һ�����ܣ������˺�195","set:TattooShow image:TattooShow_7",""}, 
["ww08"]={"����","8��","0/2088","ǿ����һ���ķ���һ�����ܣ������˺�210","set:TattooShow image:TattooShow_7",""}, 
["ww09"]={"����","9��","0/3570","ǿ����һ���ķ���һ�����ܣ������˺�270","set:TattooShow image:TattooShow_7",""}, 
["ww10"]={"����","10��","����","ǿ����һ���ķ���һ�����ܣ������˺�360","set:TattooShow image:TattooShow_8",""}, 

["mx01"]={"ڤ��","1��","0/2","ǿ���ڶ����ķ���һ�����ܣ����ܵ��˺�Ч������10��","set:TattooShow image:TattooShow_5",""},  
["mx02"]={"ڤ��","2��","0/9","ǿ���ڶ����ķ���һ�����ܣ����ܵ��˺�Ч������20��","set:TattooShow image:TattooShow_5",""}, 
["mx03"]={"ڤ��","3��","0/50","ǿ���ڶ����ķ���һ�����ܣ����ܵ��˺�Ч������40��","set:TattooShow image:TattooShow_5",""}, 
["mx04"]={"ڤ��","4��","0/87","ǿ���ڶ����ķ���һ�����ܣ����ܵ��˺�Ч������70��","set:TattooShow image:TattooShow_6",""}, 
["mx05"]={"ڤ��","5��","0/165","ǿ���ڶ����ķ���һ�����ܣ����ܵ��˺�Ч������100��","set:TattooShow image:TattooShow_6",""}, 
["mx06"]={"ڤ��","6��","0/284","ǿ���ڶ����ķ���һ�����ܣ����ܵ��˺�Ч������110��","set:TattooShow image:TattooShow_6",""}, 
["mx07"]={"ڤ��","7��","0/811","ǿ���ڶ����ķ���һ�����ܣ����ܵ��˺�Ч������120��","set:TattooShow image:TattooShow_7",""}, 
["mx08"]={"ڤ��","8��","0/2088","ǿ���ڶ����ķ���һ�����ܣ����ܵ��˺�Ч������130��","set:TattooShow image:TattooShow_7",""}, 
["mx09"]={"ڤ��","9��","0/3570","ǿ���ڶ����ķ���һ�����ܣ����ܵ��˺�Ч������140��","set:TattooShow image:TattooShow_7",""}, 
["mx10"]={"ڤ��","10��","����","ǿ���ڶ����ķ���һ�����ܣ����ܵ��˺�Ч������150��","set:TattooShow image:TattooShow_8",""}, 

["yj01"]={"����","1��","0/2","ǿ�����屾�ķ����������ܣ����ܵ��˺�Ч������10��","set:TattooShow image:TattooShow_5",""},  
["yj02"]={"����","2��","0/9","ǿ�����屾�ķ����������ܣ����ܵ��˺�Ч������20��","set:TattooShow image:TattooShow_5",""}, 
["yj03"]={"����","3��","0/50","ǿ�����屾�ķ����������ܣ����ܵ��˺�Ч������40��","set:TattooShow image:TattooShow_5",""}, 
["yj04"]={"����","4��","0/87","ǿ�����屾�ķ����������ܣ����ܵ��˺�Ч������70��","set:TattooShow image:TattooShow_6",""}, 
["yj05"]={"����","5��","0/165","ǿ�����屾�ķ����������ܣ����ܵ��˺�Ч������100��","set:TattooShow image:TattooShow_6",""}, 
["yj06"]={"����","6��","0/284","ǿ�����屾�ķ����������ܣ����ܵ��˺�Ч������110��","set:TattooShow image:TattooShow_6",""}, 
["yj07"]={"����","7��","0/811","ǿ�����屾�ķ����������ܣ����ܵ��˺�Ч������120��","set:TattooShow image:TattooShow_7",""}, 
["yj08"]={"����","8��","0/2088","ǿ�����屾�ķ����������ܣ����ܵ��˺�Ч������130��","set:TattooShow image:TattooShow_7",""}, 
["yj09"]={"����","9��","0/3570","ǿ�����屾�ķ����������ܣ����ܵ��˺�Ч������140��","set:TattooShow image:TattooShow_7",""}, 
["yj10"]={"����","10��","����","ǿ�����屾�ķ����������ܣ����ܵ��˺�Ч������150��","set:TattooShow image:TattooShow_8",""}, 

["bn01"]={"��ŭ","1��","0/2","ǿ���������ķ���һ�����ܣ����ܵ��˺�Ч������10��","set:TattooShow image:TattooShow_5",""},  
["bn02"]={"��ŭ","2��","0/9","ǿ���������ķ���һ�����ܣ����ܵ��˺�Ч������20��","set:TattooShow image:TattooShow_5",""}, 
["bn03"]={"��ŭ","3��","0/50","ǿ���������ķ���һ�����ܣ����ܵ��˺�Ч������40��","set:TattooShow image:TattooShow_5",""}, 
["bn04"]={"��ŭ","4��","0/87","ǿ���������ķ���һ�����ܣ����ܵ��˺�Ч������70��","set:TattooShow image:TattooShow_6",""}, 
["bn05"]={"��ŭ","5��","0/165","ǿ���������ķ���һ�����ܣ����ܵ��˺�Ч������100��","set:TattooShow image:TattooShow_6",""}, 
["bn06"]={"��ŭ","6��","0/284","ǿ���������ķ���һ�����ܣ����ܵ��˺�Ч������110��","set:TattooShow image:TattooShow_6",""}, 
["bn07"]={"��ŭ","7��","0/811","ǿ���������ķ���һ�����ܣ����ܵ��˺�Ч������120��","set:TattooShow image:TattooShow_7",""}, 
["bn08"]={"��ŭ","8��","0/2088","ǿ���������ķ���һ�����ܣ����ܵ��˺�Ч������130��","set:TattooShow image:TattooShow_7",""}, 
["bn09"]={"��ŭ","9��","0/3570","ǿ���������ķ���һ�����ܣ����ܵ��˺�Ч������140��","set:TattooShow image:TattooShow_7",""}, 
["bn10"]={"��ŭ","10��","����","ǿ���������ķ���һ�����ܣ����ܵ��˺�Ч������150��","set:TattooShow image:TattooShow_8",""}, 
}	
local DarkDwData = {[1]="ti",[2]="bg",[3]="hg",[4]="xg",[5]="dg",[6]="bj",[7]="hj",[8]="xj",[9]="dj"}

local b ,c ,d="","",""
--*****************************************************
--Q546528533������Ӱ�����������
--*****************************************************
    if string.find(Explain,"����ƿ��") ~= nil then
	    local nDarkDW = DataPool:GetPlayerMission_DataRound(504)
		if nDarkDW == 0 then
		    return 0,0,0
		end
		local nDarkDWData,nDarkDWLevel = math.floor(nDarkDW/100),math.mod(nDarkDW,100)
        nDarkDWData = DarkDwData[nDarkDWData]
		if nDarkDWData ~= nil then
		    if nDarkDWLevel < 10 then
			    nDarkDWLevel = "0"..nDarkDWLevel
			end
			-- PushDebugMessage("nDarkDWLevel  "..nDarkDWLevel)
			-- PushDebugMessage("nDarkDWData  "..nDarkDWData)
			local nData = nDarkDWData..nDarkDWLevel
		    b ="#cFF0000"..g_XieZi_DwStr[nData][1].."����"..g_XieZi_DwStr[nData][2].."\n������Ҫ�Ĳ�������"..g_XieZi_DwStr[nData][3].."\n"..g_XieZi_DwStr[nData][4].."\n"
		    c= g_XieZi_DwStr[nData][5]
			d= 0
			return b,c,d
		else
		    return  0,0,0
		end
	    return  0,0,0
	end
--*****************************************************
--Q546528533������Ӱ�����������
--*****************************************************	
if StrDW ==nil or StrDW =="" then 
return 0,0,0
end 
local ax,ay,str,str1 = string.find(StrDW,"&DW("..string.rep("%w",4)..")("..string.rep("%w",4)..")")
 if ax ==nil or ay ==nil or str==nil then
return 0,0,0
end
if g_XieZi_DwStr[str] == nil then
return 0,0,0	
end	

if g_XieZi_DwStr[str] ~= nil and g_XieZi_DwStr[str1] == nil then
 b ="#cFF0000"..g_XieZi_DwStr[str][1].."����"..g_XieZi_DwStr[str][2].."\n������Ҫ�Ĳ�������"..g_XieZi_DwStr[str][3].."\n"..g_XieZi_DwStr[str][4].."\n"
 c= g_XieZi_DwStr[str][5]
 d= 0
end 

if g_XieZi_DwStr[str] ~= nil and g_XieZi_DwStr[str1] ~= nil then
 b ="#cFF0000˫�����ƣ�"..g_XieZi_DwStr[str][1].."��"..g_XieZi_DwStr[str1][1].."("..g_XieZi_DwStr[str][2].."��"..g_XieZi_DwStr[str1][2]..")\n�������裺"..g_XieZi_DwStr[str][1].."("..g_XieZi_DwStr[str][3]..") "..g_XieZi_DwStr[str1][1].."("..g_XieZi_DwStr[str1][3]..") \n˫����"..g_XieZi_DwStr[str][1].."��"..g_XieZi_DwStr[str][4].."\n˫����"..g_XieZi_DwStr[str1][1].."��"..g_XieZi_DwStr[str1][4].."\n"
 c= g_XieZi_DwStr[str][5]
 d= g_XieZi_DwStr[str1][5]
end 
return b,c,d
end