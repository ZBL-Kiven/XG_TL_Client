
local strMenPaiName ={
						"少林",
						"明教",	
						"丐帮",	
						"武当",	
						"峨嵋",	
						"星宿",	
						"天龙",	
						"天山",	
						"逍遥",
						"新手",	
						"曼陀山庄",
						"大宋",
						"大宋",
						"大辽",
						"大辽",
						"大理",	
						"西夏",	
						"番邦",	
						"莽盖",	
						"遗民",	
						"狼人",	
						"白苗",	
						"黑苗",	
						"修罗",	
						"越女",
						"越男",
						"鳄神",	
						"野兽",	
						"绿林",	
						"妖魔",};

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
	
		--AxTrace(0,0,"打开main target");
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
	-- 当target是自己的时候无法刷新。
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
	--头像框刷新
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
--以前玩家统一显示为白色，根据阮枚5月27日文档更改，玩家和NPC走同一规则。
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
--添加判断目标属性的设计
	--“宠”“人”“傀”“兽”“莽”“修”“妖”
	local nNpcType = Target:GetData( "TYPE" );
	TargetFrame_TypeIcon:SetProperty( "SetCurrentImage", "TypeName"..tostring( nNpcType ) );
	
	--1.友好
	--2.中立
	--3.珍兽
	--4.普通敌人
	--5.精英敌人
	--6.敌方boss	
	local nNpcRelation = Target:GetData( "RELATION" );
	TargetFrame_TypeFrame:SetProperty( "SetCurrentImage", "TypeFrame"..tostring( nNpcRelation ) );
	
	--跟新门派
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
	
	AxTrace( 0,0, "等级差为"..tostring( level ) );
--根据阮枚5月27日策划文档修改
--	if( level > 12 ) then
--		txtColor = "#R";
--	elseif( level > 4 ) then
--		txtColor = "#cff9000";
--		--以前是c9ccf00，根据杨耀提供的.jpg修改
--	elseif( level > -4 ) then
--		txtColor="#Y";
--	elseif( level > -12 ) then
--		txtColor="#G"
--	else
--		txtColor="#c4b4b4b";
--根据杨耀口述修改
--		txtColor="#c240c0c";
--	end

--根据阮枚5月27日策划文档修改如下
	if( level > 5 ) then
		txtColor = "#R";
	elseif( level > 2 ) then
		txtColor = "#cff9000";
		--以前是c9ccf00，根据杨耀提供的.jpg修改
	elseif( level >= -2 ) then
		txtColor="#Y";
	elseif( level >= -5 ) then
		txtColor="#W"
	else
--		txtColor="#c4b4b4b";
--根据杨耀口述修改
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

-- 显示右键菜单
function TargetFrame_Show_Menu_Func()

	--AxTrace( 0,0, "Target 右键菜单!");
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
["ti01"]={"体力","1级","0/2","体力+20","set:TattooShow image:TattooShow_1",""},
["ti02"]={"体力","2级","0/9","体力+40","set:TattooShow image:TattooShow_1",""}, 
["ti03"]={"体力","3级","0/50","体力+60","set:TattooShow image:TattooShow_1",""}, 
["ti04"]={"体力","4级","0/87","体力+80","set:TattooShow image:TattooShow_2",""}, 
["ti05"]={"体力","5级","0/165","体力+100","set:TattooShow image:TattooShow_2",""}, 
["ti06"]={"体力","6级","0/284","体力+120","set:TattooShow image:TattooShow_2",""}, 
["ti07"]={"体力","7级","0/811","体力+140","set:TattooShow image:TattooShow_3",""}, 
["ti08"]={"体力","8级","0/2088","体力+160","set:TattooShow image:TattooShow_3",""}, 
["ti09"]={"体力","9级","0/3570","体力+180","set:TattooShow image:TattooShow_3",""}, 
["ti10"]={"体力","10级","满级","体力+200","set:TattooShow image:TattooShow_4",""}, 

["ll01"]={"力量","1级","0/2","力量+20","set:TattooShow image:TattooShow_1",""},  
["ll02"]={"力量","2级","0/9","力量+40","set:TattooShow image:TattooShow_1",""}, 
["ll03"]={"力量","3级","0/50","力量+60","set:TattooShow image:TattooShow_1",""}, 
["ll04"]={"力量","4级","0/87","力量+80","set:TattooShow image:TattooShow_2",""}, 
["ll05"]={"力量","5级","0/165","力量+100","set:TattooShow image:TattooShow_2",""}, 
["ll06"]={"力量","6级","0/284","力量+120","set:TattooShow image:TattooShow_2",""}, 
["ll07"]={"力量","7级","0/811","力量+140","set:TattooShow image:TattooShow_3",""}, 
["ll08"]={"力量","8级","0/2088","力量+160","set:TattooShow image:TattooShow_3",""}, 
["ll09"]={"力量","9级","0/3570","力量+180","set:TattooShow image:TattooShow_3",""}, 
["ll10"]={"力量","10级","满级","力量+200","set:TattooShow image:TattooShow_4",""}, 

["lt01"]={"灵气","1级","0/2","灵气+20","set:TattooShow image:TattooShow_1",""},  
["lt02"]={"灵气","2级","0/9","灵气+40","set:TattooShow image:TattooShow_1",""}, 
["lt03"]={"灵气","3级","0/50","灵气+60","set:TattooShow image:TattooShow_1",""}, 
["lt04"]={"灵气","4级","0/87","灵气+80","set:TattooShow image:TattooShow_2",""}, 
["lt05"]={"灵气","5级","0/165","灵气+100","set:TattooShow image:TattooShow_2",""}, 
["lt06"]={"灵气","6级","0/284","灵气+120","set:TattooShow image:TattooShow_2",""}, 
["lt07"]={"灵气","7级","0/811","灵气+140","set:TattooShow image:TattooShow_3",""}, 
["lt08"]={"灵气","8级","0/2088","灵气+160","set:TattooShow image:TattooShow_3",""}, 
["lt09"]={"灵气","9级","0/3570","灵气+180","set:TattooShow image:TattooShow_3",""}, 
["lt10"]={"灵气","10级","满级","灵气+200","set:TattooShow image:TattooShow_4",""}, 

["sf01"]={"身法","1级","0/2","身法+20","set:TattooShow image:TattooShow_1",""},  
["sf02"]={"身法","2级","0/9","身法+40","set:TattooShow image:TattooShow_1",""}, 
["sf03"]={"身法","3级","0/50","身法+60","set:TattooShow image:TattooShow_1",""}, 
["sf04"]={"身法","4级","0/87","身法+80","set:TattooShow image:TattooShow_2",""}, 
["sf05"]={"身法","5级","0/165","身法+100","set:TattooShow image:TattooShow_2",""}, 
["sf06"]={"身法","6级","0/284","身法+120","set:TattooShow image:TattooShow_2",""}, 
["sf07"]={"身法","7级","0/811","身法+140","set:TattooShow image:TattooShow_3",""}, 
["sf08"]={"身法","8级","0/2088","身法+160","set:TattooShow image:TattooShow_3",""}, 
["sf09"]={"身法","9级","0/3570","身法+180","set:TattooShow image:TattooShow_3",""}, 
["sf10"]={"身法","10级","满级","身法+200","set:TattooShow image:TattooShow_4",""}, 


["bg01"]={"冰攻","1级","0/2","冰攻击+30","set:TattooShow image:TattooShow_9",""},  
["bg02"]={"冰攻","2级","0/9","冰攻击+60","set:TattooShow image:TattooShow_9",""}, 
["bg03"]={"冰攻","3级","0/50","冰攻击+90","set:TattooShow image:TattooShow_9",""}, 
["bg04"]={"冰攻","4级","0/87","冰攻击+120","set:TattooShow image:TattooShow_10",""}, 
["bg05"]={"冰攻","5级","0/165","冰攻击+150","set:TattooShow image:TattooShow_10",""}, 
["bg06"]={"冰攻","6级","0/284","冰攻击+180","set:TattooShow image:TattooShow_10",""}, 
["bg07"]={"冰攻","7级","0/811","冰攻击+210","set:TattooShow image:TattooShow_11",""}, 
["bg08"]={"冰攻","8级","0/2088","冰攻击+240","set:TattooShow image:TattooShow_11",""}, 
["bg09"]={"冰攻","9级","0/3570","冰攻击+270","set:TattooShow image:TattooShow_11",""}, 
["bg10"]={"冰攻","10级","满级","冰攻击+300","set:TattooShow image:TattooShow_12",""}, 

["hg01"]={"火攻","1级","0/2","火攻击+30","set:TattooShow image:TattooShow_9",""},  
["hg02"]={"火攻","2级","0/9","火攻击+60","set:TattooShow image:TattooShow_9",""}, 
["hg03"]={"火攻","3级","0/50","火攻击+90","set:TattooShow image:TattooShow_9",""}, 
["hg04"]={"火攻","4级","0/87","火攻击+120","set:TattooShow image:TattooShow_10",""}, 
["hg05"]={"火攻","5级","0/165","火攻击+150","set:TattooShow image:TattooShow_10",""}, 
["hg06"]={"火攻","6级","0/284","火攻击+180","set:TattooShow image:TattooShow_10",""}, 
["hg07"]={"火攻","7级","0/811","火攻击+210","set:TattooShow image:TattooShow_11",""}, 
["hg08"]={"火攻","8级","0/2088","火攻击+240","set:TattooShow image:TattooShow_11",""}, 
["hg09"]={"火攻","9级","0/3570","火攻击+270","set:TattooShow image:TattooShow_11",""}, 
["hg10"]={"火攻","10级","满级","火攻击+300","set:TattooShow image:TattooShow_12",""}, 

["xg01"]={"玄攻","1级","0/2","玄攻击+30","set:TattooShow image:TattooShow_9",""},  
["xg02"]={"玄攻","2级","0/9","玄攻击+60","set:TattooShow image:TattooShow_9",""}, 
["xg03"]={"玄攻","3级","0/50","玄攻击+90","set:TattooShow image:TattooShow_9",""}, 
["xg04"]={"玄攻","4级","0/87","玄攻击+120","set:TattooShow image:TattooShow_10",""}, 
["xg05"]={"玄攻","5级","0/165","玄攻击+150","set:TattooShow image:TattooShow_10",""}, 
["xg06"]={"玄攻","6级","0/284","玄攻击+180","set:TattooShow image:TattooShow_10",""}, 
["xg07"]={"玄攻","7级","0/811","玄攻击+210","set:TattooShow image:TattooShow_11",""}, 
["xg08"]={"玄攻","8级","0/2088","玄攻击+240","set:TattooShow image:TattooShow_11",""}, 
["xg09"]={"玄攻","9级","0/3570","玄攻击+270","set:TattooShow image:TattooShow_11",""}, 
["xg10"]={"玄攻","10级","满级","玄攻击+300","set:TattooShow image:TattooShow_12",""}, 

["dg01"]={"毒攻","1级","0/2","毒攻击+30","set:TattooShow image:TattooShow_9",""},  
["dg02"]={"毒攻","2级","0/9","毒攻击+60","set:TattooShow image:TattooShow_9",""}, 
["dg03"]={"毒攻","3级","0/50","毒攻击+90","set:TattooShow image:TattooShow_9",""}, 
["dg04"]={"毒攻","4级","0/87","毒攻击+120","set:TattooShow image:TattooShow_10",""}, 
["dg05"]={"毒攻","5级","0/165","毒攻击+150","set:TattooShow image:TattooShow_10",""}, 
["dg06"]={"毒攻","6级","0/284","毒攻击+180","set:TattooShow image:TattooShow_10",""}, 
["dg07"]={"毒攻","7级","0/811","毒攻击+210","set:TattooShow image:TattooShow_11",""}, 
["dg08"]={"毒攻","8级","0/2088","毒攻击+240","set:TattooShow image:TattooShow_11",""}, 
["dg09"]={"毒攻","9级","0/3570","毒攻击+270","set:TattooShow image:TattooShow_11",""}, 
["dg10"]={"毒攻","10级","满级","毒攻击+300","set:TattooShow image:TattooShow_12",""}, 

["bj01"]={"减冰抗","1级","0/2","忽略目标冰抗+8","set:TattooShow image:TattooShow_17",""},  
["bj02"]={"减冰抗","2级","0/9","忽略目标冰抗+16","set:TattooShow image:TattooShow_17",""}, 
["bj03"]={"减冰抗","3级","0/50","忽略目标冰抗+24","set:TattooShow image:TattooShow_17",""}, 
["bj04"]={"减冰抗","4级","0/87","忽略目标冰抗+32","set:TattooShow image:TattooShow_18",""}, 
["bj05"]={"减冰抗","5级","0/165","忽略目标冰抗+40","set:TattooShow image:TattooShow_18",""}, 
["bj06"]={"减冰抗","6级","0/284","忽略目标冰抗+48","set:TattooShow image:TattooShow_18",""}, 
["bj07"]={"减冰抗","7级","0/811","忽略目标冰抗+56","set:TattooShow image:TattooShow_19",""}, 
["bj08"]={"减冰抗","8级","0/2088","忽略目标冰抗+64","set:TattooShow image:TattooShow_19",""}, 
["bj09"]={"减冰抗","9级","0/3570","忽略目标冰抗+72","set:TattooShow image:TattooShow_19",""}, 
["bj10"]={"减冰抗","10级","满级","忽略目标冰抗+80","set:TattooShow image:TattooShow_20",""}, 

["hj01"]={"减火抗","1级","0/2","忽略目标火抗+8","set:TattooShow image:TattooShow_17",""},  
["hj02"]={"减火抗","2级","0/9","忽略目标火抗+16","set:TattooShow image:TattooShow_17",""}, 
["hj03"]={"减火抗","3级","0/50","忽略目标火抗+24","set:TattooShow image:TattooShow_17",""}, 
["hj04"]={"减火抗","4级","0/87","忽略目标火抗+32","set:TattooShow image:TattooShow_18",""}, 
["hj05"]={"减火抗","5级","0/165","忽略目标火抗+40","set:TattooShow image:TattooShow_18",""}, 
["hj06"]={"减火抗","6级","0/284","忽略目标火抗+48","set:TattooShow image:TattooShow_18",""}, 
["hj07"]={"减火抗","7级","0/811","忽略目标火抗+56","set:TattooShow image:TattooShow_19",""}, 
["hj08"]={"减火抗","8级","0/2088","忽略目标火抗+64","set:TattooShow image:TattooShow_19",""}, 
["hj09"]={"减火抗","9级","0/3570","忽略目标火抗+72","set:TattooShow image:TattooShow_19",""}, 
["hj10"]={"减火抗","10级","满级","忽略目标火抗+80","set:TattooShow image:TattooShow_20",""}, 

["xj01"]={"减玄抗","1级","0/2","忽略目标玄抗+8","set:TattooShow image:TattooShow_17",""},  
["xj02"]={"减玄抗","2级","0/9","忽略目标玄抗+16","set:TattooShow image:TattooShow_17",""}, 
["xj03"]={"减玄抗","3级","0/50","忽略目标玄抗+24","set:TattooShow image:TattooShow_17",""}, 
["xj04"]={"减玄抗","4级","0/87","忽略目标玄抗+32","set:TattooShow image:TattooShow_18",""}, 
["xj05"]={"减玄抗","5级","0/165","忽略目标玄抗+40","set:TattooShow image:TattooShow_18",""}, 
["xj06"]={"减玄抗","6级","0/284","忽略目标玄抗+48","set:TattooShow image:TattooShow_18",""}, 
["xj07"]={"减玄抗","7级","0/811","忽略目标玄抗+56","set:TattooShow image:TattooShow_19",""}, 
["xj08"]={"减玄抗","8级","0/2088","忽略目标玄抗+64","set:TattooShow image:TattooShow_19",""}, 
["xj09"]={"减玄抗","9级","0/3570","忽略目标玄抗+72","set:TattooShow image:TattooShow_19",""}, 
["xj10"]={"减玄抗","10级","满级","忽略目标玄抗+80","set:TattooShow image:TattooShow_20",""}, 

["dj01"]={"减毒抗","1级","0/2","忽略目标毒抗+8","set:TattooShow image:TattooShow_17",""},  
["dj02"]={"减毒抗","2级","0/9","忽略目标毒抗+16","set:TattooShow image:TattooShow_17",""}, 
["dj03"]={"减毒抗","3级","0/50","忽略目标毒抗+24","set:TattooShow image:TattooShow_17",""}, 
["dj04"]={"减毒抗","4级","0/87","忽略目标毒抗+32","set:TattooShow image:TattooShow_18",""}, 
["dj05"]={"减毒抗","5级","0/165","忽略目标毒抗+40","set:TattooShow image:TattooShow_18",""}, 
["dj06"]={"减毒抗","6级","0/284","忽略目标毒抗+48","set:TattooShow image:TattooShow_18",""}, 
["dj07"]={"减毒抗","7级","0/811","忽略目标毒抗+56","set:TattooShow image:TattooShow_19",""}, 
["dj08"]={"减毒抗","8级","0/2088","忽略目标毒抗+64","set:TattooShow image:TattooShow_19",""}, 
["dj09"]={"减毒抗","9级","0/3570","忽略目标毒抗+72","set:TattooShow image:TattooShow_19",""}, 
["dj10"]={"减毒抗","10级","满级","忽略目标毒抗+80","set:TattooShow image:TattooShow_20",""}, 

["bk01"]={"冰抗","1级","0/2","冰抗性+8","set:TattooShow image:TattooShow_13",""},  
["bk02"]={"冰抗","2级","0/9","冰抗性+16","set:TattooShow image:TattooShow_13",""}, 
["bk03"]={"冰抗","3级","0/50","冰抗性+24","set:TattooShow image:TattooShow_13",""}, 
["bk04"]={"冰抗","4级","0/87","冰抗性+32","set:TattooShow image:TattooShow_14",""}, 
["bk05"]={"冰抗","5级","0/165","冰抗性+40","set:TattooShow image:TattooShow_14",""}, 
["bk06"]={"冰抗","6级","0/284","冰抗性+48","set:TattooShow image:TattooShow_14",""}, 
["bk07"]={"冰抗","7级","0/811","冰抗性+56","set:TattooShow image:TattooShow_15",""}, 
["bk08"]={"冰抗","8级","0/2088","冰抗性+64","set:TattooShow image:TattooShow_15",""}, 
["bk09"]={"冰抗","9级","0/3570","冰抗性+72","set:TattooShow image:TattooShow_15",""}, 
["bk10"]={"冰抗","10级","满级","冰抗性+80","set:TattooShow image:TattooShow_16",""}, 

["hk01"]={"火抗","1级","0/2","火抗性+8","set:TattooShow image:TattooShow_13",""},  
["hk02"]={"火抗","2级","0/9","火抗性+16","set:TattooShow image:TattooShow_13",""}, 
["hk03"]={"火抗","3级","0/50","火抗性+24","set:TattooShow image:TattooShow_13",""}, 
["hk04"]={"火抗","4级","0/87","火抗性+32","set:TattooShow image:TattooShow_14",""}, 
["hk05"]={"火抗","5级","0/165","火抗性+40","set:TattooShow image:TattooShow_14",""}, 
["hk06"]={"火抗","6级","0/284","火抗性+48","set:TattooShow image:TattooShow_14",""}, 
["hk07"]={"火抗","7级","0/811","火抗性+56","set:TattooShow image:TattooShow_15",""}, 
["hk08"]={"火抗","8级","0/2088","火抗性+64","set:TattooShow image:TattooShow_15",""}, 
["hk09"]={"火抗","9级","0/3570","火抗性+72","set:TattooShow image:TattooShow_15",""}, 
["hk10"]={"火抗","10级","满级","火抗性+80","set:TattooShow image:TattooShow_16",""}, 

["xk01"]={"玄抗","1级","0/2","玄抗性+8","set:TattooShow image:TattooShow_13",""},  
["xk02"]={"玄抗","2级","0/9","玄抗性+16","set:TattooShow image:TattooShow_13",""}, 
["xk03"]={"玄抗","3级","0/50","玄抗性+24","set:TattooShow image:TattooShow_13",""}, 
["xk04"]={"玄抗","4级","0/87","玄抗性+32","set:TattooShow image:TattooShow_14",""}, 
["xk05"]={"玄抗","5级","0/165","玄抗性+40","set:TattooShow image:TattooShow_14",""}, 
["xk06"]={"玄抗","6级","0/284","玄抗性+48","set:TattooShow image:TattooShow_14",""}, 
["xk07"]={"玄抗","7级","0/811","玄抗性+56","set:TattooShow image:TattooShow_15",""}, 
["xk08"]={"玄抗","8级","0/2088","玄抗性+64","set:TattooShow image:TattooShow_15",""}, 
["xk09"]={"玄抗","9级","0/3570","玄抗性+72","set:TattooShow image:TattooShow_15",""}, 
["xk10"]={"玄抗","10级","满级","玄抗性+80","set:TattooShow image:TattooShow_16",""}, 

["dk01"]={"毒抗","1级","0/2","毒抗性+8","set:TattooShow image:TattooShow_13",""},  
["dk02"]={"毒抗","2级","0/9","毒抗性+16","set:TattooShow image:TattooShow_13",""}, 
["dk03"]={"毒抗","3级","0/50","毒抗性+24","set:TattooShow image:TattooShow_13",""}, 
["dk04"]={"毒抗","4级","0/87","毒抗性+32","set:TattooShow image:TattooShow_14",""}, 
["dk05"]={"毒抗","5级","0/165","毒抗性+40","set:TattooShow image:TattooShow_14",""}, 
["dk06"]={"毒抗","6级","0/284","毒抗性+48","set:TattooShow image:TattooShow_14",""}, 
["dk07"]={"毒抗","7级","0/811","毒抗性+56","set:TattooShow image:TattooShow_15",""}, 
["dk08"]={"毒抗","8级","0/2088","毒抗性+64","set:TattooShow image:TattooShow_15",""}, 
["dk09"]={"毒抗","9级","0/3570","毒抗性+72","set:TattooShow image:TattooShow_15",""}, 
["dk10"]={"毒抗","10级","满级","毒抗性+80","set:TattooShow image:TattooShow_16",""}, 

["ww01"]={"忘无","1级","0/2","强化第一本心法第一个技能，附加伤害15","set:TattooShow image:TattooShow_5",""},  
["ww02"]={"忘无","2级","0/9","强化第一本心法第一个技能，附加伤害30","set:TattooShow image:TattooShow_5",""}, 
["ww03"]={"忘无","3级","0/50","强化第一本心法第一个技能，附加伤害45","set:TattooShow image:TattooShow_5",""}, 
["ww04"]={"忘无","4级","0/87","强化第一本心法第一个技能，附加伤害90","set:TattooShow image:TattooShow_6",""}, 
["ww05"]={"忘无","5级","0/165","强化第一本心法第一个技能，附加伤害150","set:TattooShow image:TattooShow_6",""}, 
["ww06"]={"忘无","6级","0/284","强化第一本心法第一个技能，附加伤害180","set:TattooShow image:TattooShow_6",""}, 
["ww07"]={"忘无","7级","0/811","强化第一本心法第一个技能，附加伤害195","set:TattooShow image:TattooShow_7",""}, 
["ww08"]={"忘无","8级","0/2088","强化第一本心法第一个技能，附加伤害210","set:TattooShow image:TattooShow_7",""}, 
["ww09"]={"忘无","9级","0/3570","强化第一本心法第一个技能，附加伤害270","set:TattooShow image:TattooShow_7",""}, 
["ww10"]={"忘无","10级","满级","强化第一本心法第一个技能，附加伤害360","set:TattooShow image:TattooShow_8",""}, 

["mx01"]={"冥想","1级","0/2","强化第二本心法第一个技能，技能的伤害效果提升10％","set:TattooShow image:TattooShow_5",""},  
["mx02"]={"冥想","2级","0/9","强化第二本心法第一个技能，技能的伤害效果提升20％","set:TattooShow image:TattooShow_5",""}, 
["mx03"]={"冥想","3级","0/50","强化第二本心法第一个技能，技能的伤害效果提升40％","set:TattooShow image:TattooShow_5",""}, 
["mx04"]={"冥想","4级","0/87","强化第二本心法第一个技能，技能的伤害效果提升70％","set:TattooShow image:TattooShow_6",""}, 
["mx05"]={"冥想","5级","0/165","强化第二本心法第一个技能，技能的伤害效果提升100％","set:TattooShow image:TattooShow_6",""}, 
["mx06"]={"冥想","6级","0/284","强化第二本心法第一个技能，技能的伤害效果提升110％","set:TattooShow image:TattooShow_6",""}, 
["mx07"]={"冥想","7级","0/811","强化第二本心法第一个技能，技能的伤害效果提升120％","set:TattooShow image:TattooShow_7",""}, 
["mx08"]={"冥想","8级","0/2088","强化第二本心法第一个技能，技能的伤害效果提升130％","set:TattooShow image:TattooShow_7",""}, 
["mx09"]={"冥想","9级","0/3570","强化第二本心法第一个技能，技能的伤害效果提升140％","set:TattooShow image:TattooShow_7",""}, 
["mx10"]={"冥想","10级","满级","强化第二本心法第一个技能，技能的伤害效果提升150％","set:TattooShow image:TattooShow_8",""}, 

["yj01"]={"御劲","1级","0/2","强化第五本心法第三个技能，技能的伤害效果提升10％","set:TattooShow image:TattooShow_5",""},  
["yj02"]={"御劲","2级","0/9","强化第五本心法第三个技能，技能的伤害效果提升20％","set:TattooShow image:TattooShow_5",""}, 
["yj03"]={"御劲","3级","0/50","强化第五本心法第三个技能，技能的伤害效果提升40％","set:TattooShow image:TattooShow_5",""}, 
["yj04"]={"御劲","4级","0/87","强化第五本心法第三个技能，技能的伤害效果提升70％","set:TattooShow image:TattooShow_6",""}, 
["yj05"]={"御劲","5级","0/165","强化第五本心法第三个技能，技能的伤害效果提升100％","set:TattooShow image:TattooShow_6",""}, 
["yj06"]={"御劲","6级","0/284","强化第五本心法第三个技能，技能的伤害效果提升110％","set:TattooShow image:TattooShow_6",""}, 
["yj07"]={"御劲","7级","0/811","强化第五本心法第三个技能，技能的伤害效果提升120％","set:TattooShow image:TattooShow_7",""}, 
["yj08"]={"御劲","8级","0/2088","强化第五本心法第三个技能，技能的伤害效果提升130％","set:TattooShow image:TattooShow_7",""}, 
["yj09"]={"御劲","9级","0/3570","强化第五本心法第三个技能，技能的伤害效果提升140％","set:TattooShow image:TattooShow_7",""}, 
["yj10"]={"御劲","10级","满级","强化第五本心法第三个技能，技能的伤害效果提升150％","set:TattooShow image:TattooShow_8",""}, 

["bn01"]={"暴怒","1级","0/2","强化第六本心法第一个技能，技能的伤害效果提升10％","set:TattooShow image:TattooShow_5",""},  
["bn02"]={"暴怒","2级","0/9","强化第六本心法第一个技能，技能的伤害效果提升20％","set:TattooShow image:TattooShow_5",""}, 
["bn03"]={"暴怒","3级","0/50","强化第六本心法第一个技能，技能的伤害效果提升40％","set:TattooShow image:TattooShow_5",""}, 
["bn04"]={"暴怒","4级","0/87","强化第六本心法第一个技能，技能的伤害效果提升70％","set:TattooShow image:TattooShow_6",""}, 
["bn05"]={"暴怒","5级","0/165","强化第六本心法第一个技能，技能的伤害效果提升100％","set:TattooShow image:TattooShow_6",""}, 
["bn06"]={"暴怒","6级","0/284","强化第六本心法第一个技能，技能的伤害效果提升110％","set:TattooShow image:TattooShow_6",""}, 
["bn07"]={"暴怒","7级","0/811","强化第六本心法第一个技能，技能的伤害效果提升120％","set:TattooShow image:TattooShow_7",""}, 
["bn08"]={"暴怒","8级","0/2088","强化第六本心法第一个技能，技能的伤害效果提升130％","set:TattooShow image:TattooShow_7",""}, 
["bn09"]={"暴怒","9级","0/3570","强化第六本心法第一个技能，技能的伤害效果提升140％","set:TattooShow image:TattooShow_7",""}, 
["bn10"]={"暴怒","10级","满级","强化第六本心法第一个技能，技能的伤害效果提升150％","set:TattooShow image:TattooShow_8",""}, 
}	
local DarkDwData = {[1]="ti",[2]="bg",[3]="hg",[4]="xg",[5]="dg",[6]="bj",[7]="hj",[8]="xj",[9]="dj"}

local b ,c ,d="","",""
--*****************************************************
--Q546528533极致添加暗器雕纹修正
--*****************************************************
    if string.find(Explain,"修炼瓶颈") ~= nil then
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
		    b ="#cFF0000"..g_XieZi_DwStr[nData][1].."雕纹"..g_XieZi_DwStr[nData][2].."\n升级需要的材料数："..g_XieZi_DwStr[nData][3].."\n"..g_XieZi_DwStr[nData][4].."\n"
		    c= g_XieZi_DwStr[nData][5]
			d= 0
			return b,c,d
		else
		    return  0,0,0
		end
	    return  0,0,0
	end
--*****************************************************
--Q546528533极致添加暗器雕纹修正
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
 b ="#cFF0000"..g_XieZi_DwStr[str][1].."雕纹"..g_XieZi_DwStr[str][2].."\n升级需要的材料数："..g_XieZi_DwStr[str][3].."\n"..g_XieZi_DwStr[str][4].."\n"
 c= g_XieZi_DwStr[str][5]
 d= 0
end 

if g_XieZi_DwStr[str] ~= nil and g_XieZi_DwStr[str1] ~= nil then
 b ="#cFF0000双级雕纹："..g_XieZi_DwStr[str][1].."·"..g_XieZi_DwStr[str1][1].."("..g_XieZi_DwStr[str][2].."·"..g_XieZi_DwStr[str1][2]..")\n升级所需："..g_XieZi_DwStr[str][1].."("..g_XieZi_DwStr[str][3]..") "..g_XieZi_DwStr[str1][1].."("..g_XieZi_DwStr[str1][3]..") \n双级·"..g_XieZi_DwStr[str][1].."："..g_XieZi_DwStr[str][4].."\n双级·"..g_XieZi_DwStr[str1][1].."："..g_XieZi_DwStr[str1][4].."\n"
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
["ti01"]={"体力","1级","0/2","体力+20","set:TattooShow image:TattooShow_1",""},
["ti02"]={"体力","2级","0/9","体力+40","set:TattooShow image:TattooShow_1",""}, 
["ti03"]={"体力","3级","0/50","体力+60","set:TattooShow image:TattooShow_1",""}, 
["ti04"]={"体力","4级","0/87","体力+80","set:TattooShow image:TattooShow_2",""}, 
["ti05"]={"体力","5级","0/165","体力+100","set:TattooShow image:TattooShow_2",""}, 
["ti06"]={"体力","6级","0/284","体力+120","set:TattooShow image:TattooShow_2",""}, 
["ti07"]={"体力","7级","0/811","体力+140","set:TattooShow image:TattooShow_3",""}, 
["ti08"]={"体力","8级","0/2088","体力+160","set:TattooShow image:TattooShow_3",""}, 
["ti09"]={"体力","9级","0/3570","体力+180","set:TattooShow image:TattooShow_3",""}, 
["ti10"]={"体力","10级","满级","体力+200","set:TattooShow image:TattooShow_4",""}, 

["ll01"]={"力量","1级","0/2","力量+20","set:TattooShow image:TattooShow_1",""},  
["ll02"]={"力量","2级","0/9","力量+40","set:TattooShow image:TattooShow_1",""}, 
["ll03"]={"力量","3级","0/50","力量+60","set:TattooShow image:TattooShow_1",""}, 
["ll04"]={"力量","4级","0/87","力量+80","set:TattooShow image:TattooShow_2",""}, 
["ll05"]={"力量","5级","0/165","力量+100","set:TattooShow image:TattooShow_2",""}, 
["ll06"]={"力量","6级","0/284","力量+120","set:TattooShow image:TattooShow_2",""}, 
["ll07"]={"力量","7级","0/811","力量+140","set:TattooShow image:TattooShow_3",""}, 
["ll08"]={"力量","8级","0/2088","力量+160","set:TattooShow image:TattooShow_3",""}, 
["ll09"]={"力量","9级","0/3570","力量+180","set:TattooShow image:TattooShow_3",""}, 
["ll10"]={"力量","10级","满级","力量+200","set:TattooShow image:TattooShow_4",""}, 

["lt01"]={"灵气","1级","0/2","灵气+20","set:TattooShow image:TattooShow_1",""},  
["lt02"]={"灵气","2级","0/9","灵气+40","set:TattooShow image:TattooShow_1",""}, 
["lt03"]={"灵气","3级","0/50","灵气+60","set:TattooShow image:TattooShow_1",""}, 
["lt04"]={"灵气","4级","0/87","灵气+80","set:TattooShow image:TattooShow_2",""}, 
["lt05"]={"灵气","5级","0/165","灵气+100","set:TattooShow image:TattooShow_2",""}, 
["lt06"]={"灵气","6级","0/284","灵气+120","set:TattooShow image:TattooShow_2",""}, 
["lt07"]={"灵气","7级","0/811","灵气+140","set:TattooShow image:TattooShow_3",""}, 
["lt08"]={"灵气","8级","0/2088","灵气+160","set:TattooShow image:TattooShow_3",""}, 
["lt09"]={"灵气","9级","0/3570","灵气+180","set:TattooShow image:TattooShow_3",""}, 
["lt10"]={"灵气","10级","满级","灵气+200","set:TattooShow image:TattooShow_4",""}, 

["sf01"]={"身法","1级","0/2","身法+20","set:TattooShow image:TattooShow_1",""},  
["sf02"]={"身法","2级","0/9","身法+40","set:TattooShow image:TattooShow_1",""}, 
["sf03"]={"身法","3级","0/50","身法+60","set:TattooShow image:TattooShow_1",""}, 
["sf04"]={"身法","4级","0/87","身法+80","set:TattooShow image:TattooShow_2",""}, 
["sf05"]={"身法","5级","0/165","身法+100","set:TattooShow image:TattooShow_2",""}, 
["sf06"]={"身法","6级","0/284","身法+120","set:TattooShow image:TattooShow_2",""}, 
["sf07"]={"身法","7级","0/811","身法+140","set:TattooShow image:TattooShow_3",""}, 
["sf08"]={"身法","8级","0/2088","身法+160","set:TattooShow image:TattooShow_3",""}, 
["sf09"]={"身法","9级","0/3570","身法+180","set:TattooShow image:TattooShow_3",""}, 
["sf10"]={"身法","10级","满级","身法+200","set:TattooShow image:TattooShow_4",""}, 


["bg01"]={"冰攻","1级","0/2","冰攻击+30","set:TattooShow image:TattooShow_9",""},  
["bg02"]={"冰攻","2级","0/9","冰攻击+60","set:TattooShow image:TattooShow_9",""}, 
["bg03"]={"冰攻","3级","0/50","冰攻击+90","set:TattooShow image:TattooShow_9",""}, 
["bg04"]={"冰攻","4级","0/87","冰攻击+120","set:TattooShow image:TattooShow_10",""}, 
["bg05"]={"冰攻","5级","0/165","冰攻击+150","set:TattooShow image:TattooShow_10",""}, 
["bg06"]={"冰攻","6级","0/284","冰攻击+180","set:TattooShow image:TattooShow_10",""}, 
["bg07"]={"冰攻","7级","0/811","冰攻击+210","set:TattooShow image:TattooShow_11",""}, 
["bg08"]={"冰攻","8级","0/2088","冰攻击+240","set:TattooShow image:TattooShow_11",""}, 
["bg09"]={"冰攻","9级","0/3570","冰攻击+270","set:TattooShow image:TattooShow_11",""}, 
["bg10"]={"冰攻","10级","满级","冰攻击+300","set:TattooShow image:TattooShow_12",""}, 

["hg01"]={"火攻","1级","0/2","火攻击+30","set:TattooShow image:TattooShow_9",""},  
["hg02"]={"火攻","2级","0/9","火攻击+60","set:TattooShow image:TattooShow_9",""}, 
["hg03"]={"火攻","3级","0/50","火攻击+90","set:TattooShow image:TattooShow_9",""}, 
["hg04"]={"火攻","4级","0/87","火攻击+120","set:TattooShow image:TattooShow_10",""}, 
["hg05"]={"火攻","5级","0/165","火攻击+150","set:TattooShow image:TattooShow_10",""}, 
["hg06"]={"火攻","6级","0/284","火攻击+180","set:TattooShow image:TattooShow_10",""}, 
["hg07"]={"火攻","7级","0/811","火攻击+210","set:TattooShow image:TattooShow_11",""}, 
["hg08"]={"火攻","8级","0/2088","火攻击+240","set:TattooShow image:TattooShow_11",""}, 
["hg09"]={"火攻","9级","0/3570","火攻击+270","set:TattooShow image:TattooShow_11",""}, 
["hg10"]={"火攻","10级","满级","火攻击+300","set:TattooShow image:TattooShow_12",""}, 

["xg01"]={"玄攻","1级","0/2","玄攻击+30","set:TattooShow image:TattooShow_9",""},  
["xg02"]={"玄攻","2级","0/9","玄攻击+60","set:TattooShow image:TattooShow_9",""}, 
["xg03"]={"玄攻","3级","0/50","玄攻击+90","set:TattooShow image:TattooShow_9",""}, 
["xg04"]={"玄攻","4级","0/87","玄攻击+120","set:TattooShow image:TattooShow_10",""}, 
["xg05"]={"玄攻","5级","0/165","玄攻击+150","set:TattooShow image:TattooShow_10",""}, 
["xg06"]={"玄攻","6级","0/284","玄攻击+180","set:TattooShow image:TattooShow_10",""}, 
["xg07"]={"玄攻","7级","0/811","玄攻击+210","set:TattooShow image:TattooShow_11",""}, 
["xg08"]={"玄攻","8级","0/2088","玄攻击+240","set:TattooShow image:TattooShow_11",""}, 
["xg09"]={"玄攻","9级","0/3570","玄攻击+270","set:TattooShow image:TattooShow_11",""}, 
["xg10"]={"玄攻","10级","满级","玄攻击+300","set:TattooShow image:TattooShow_12",""}, 

["dg01"]={"毒攻","1级","0/2","毒攻击+30","set:TattooShow image:TattooShow_9",""},  
["dg02"]={"毒攻","2级","0/9","毒攻击+60","set:TattooShow image:TattooShow_9",""}, 
["dg03"]={"毒攻","3级","0/50","毒攻击+90","set:TattooShow image:TattooShow_9",""}, 
["dg04"]={"毒攻","4级","0/87","毒攻击+120","set:TattooShow image:TattooShow_10",""}, 
["dg05"]={"毒攻","5级","0/165","毒攻击+150","set:TattooShow image:TattooShow_10",""}, 
["dg06"]={"毒攻","6级","0/284","毒攻击+180","set:TattooShow image:TattooShow_10",""}, 
["dg07"]={"毒攻","7级","0/811","毒攻击+210","set:TattooShow image:TattooShow_11",""}, 
["dg08"]={"毒攻","8级","0/2088","毒攻击+240","set:TattooShow image:TattooShow_11",""}, 
["dg09"]={"毒攻","9级","0/3570","毒攻击+270","set:TattooShow image:TattooShow_11",""}, 
["dg10"]={"毒攻","10级","满级","毒攻击+300","set:TattooShow image:TattooShow_12",""}, 

["bj01"]={"减冰抗","1级","0/2","忽略目标冰抗+8","set:TattooShow image:TattooShow_17",""},  
["bj02"]={"减冰抗","2级","0/9","忽略目标冰抗+16","set:TattooShow image:TattooShow_17",""}, 
["bj03"]={"减冰抗","3级","0/50","忽略目标冰抗+24","set:TattooShow image:TattooShow_17",""}, 
["bj04"]={"减冰抗","4级","0/87","忽略目标冰抗+32","set:TattooShow image:TattooShow_18",""}, 
["bj05"]={"减冰抗","5级","0/165","忽略目标冰抗+40","set:TattooShow image:TattooShow_18",""}, 
["bj06"]={"减冰抗","6级","0/284","忽略目标冰抗+48","set:TattooShow image:TattooShow_18",""}, 
["bj07"]={"减冰抗","7级","0/811","忽略目标冰抗+56","set:TattooShow image:TattooShow_19",""}, 
["bj08"]={"减冰抗","8级","0/2088","忽略目标冰抗+64","set:TattooShow image:TattooShow_19",""}, 
["bj09"]={"减冰抗","9级","0/3570","忽略目标冰抗+72","set:TattooShow image:TattooShow_19",""}, 
["bj10"]={"减冰抗","10级","满级","忽略目标冰抗+80","set:TattooShow image:TattooShow_20",""}, 

["hj01"]={"减火抗","1级","0/2","忽略目标火抗+8","set:TattooShow image:TattooShow_17",""},  
["hj02"]={"减火抗","2级","0/9","忽略目标火抗+16","set:TattooShow image:TattooShow_17",""}, 
["hj03"]={"减火抗","3级","0/50","忽略目标火抗+24","set:TattooShow image:TattooShow_17",""}, 
["hj04"]={"减火抗","4级","0/87","忽略目标火抗+32","set:TattooShow image:TattooShow_18",""}, 
["hj05"]={"减火抗","5级","0/165","忽略目标火抗+40","set:TattooShow image:TattooShow_18",""}, 
["hj06"]={"减火抗","6级","0/284","忽略目标火抗+48","set:TattooShow image:TattooShow_18",""}, 
["hj07"]={"减火抗","7级","0/811","忽略目标火抗+56","set:TattooShow image:TattooShow_19",""}, 
["hj08"]={"减火抗","8级","0/2088","忽略目标火抗+64","set:TattooShow image:TattooShow_19",""}, 
["hj09"]={"减火抗","9级","0/3570","忽略目标火抗+72","set:TattooShow image:TattooShow_19",""}, 
["hj10"]={"减火抗","10级","满级","忽略目标火抗+80","set:TattooShow image:TattooShow_20",""}, 

["xj01"]={"减玄抗","1级","0/2","忽略目标玄抗+8","set:TattooShow image:TattooShow_17",""},  
["xj02"]={"减玄抗","2级","0/9","忽略目标玄抗+16","set:TattooShow image:TattooShow_17",""}, 
["xj03"]={"减玄抗","3级","0/50","忽略目标玄抗+24","set:TattooShow image:TattooShow_17",""}, 
["xj04"]={"减玄抗","4级","0/87","忽略目标玄抗+32","set:TattooShow image:TattooShow_18",""}, 
["xj05"]={"减玄抗","5级","0/165","忽略目标玄抗+40","set:TattooShow image:TattooShow_18",""}, 
["xj06"]={"减玄抗","6级","0/284","忽略目标玄抗+48","set:TattooShow image:TattooShow_18",""}, 
["xj07"]={"减玄抗","7级","0/811","忽略目标玄抗+56","set:TattooShow image:TattooShow_19",""}, 
["xj08"]={"减玄抗","8级","0/2088","忽略目标玄抗+64","set:TattooShow image:TattooShow_19",""}, 
["xj09"]={"减玄抗","9级","0/3570","忽略目标玄抗+72","set:TattooShow image:TattooShow_19",""}, 
["xj10"]={"减玄抗","10级","满级","忽略目标玄抗+80","set:TattooShow image:TattooShow_20",""}, 

["dj01"]={"减毒抗","1级","0/2","忽略目标毒抗+8","set:TattooShow image:TattooShow_17",""},  
["dj02"]={"减毒抗","2级","0/9","忽略目标毒抗+16","set:TattooShow image:TattooShow_17",""}, 
["dj03"]={"减毒抗","3级","0/50","忽略目标毒抗+24","set:TattooShow image:TattooShow_17",""}, 
["dj04"]={"减毒抗","4级","0/87","忽略目标毒抗+32","set:TattooShow image:TattooShow_18",""}, 
["dj05"]={"减毒抗","5级","0/165","忽略目标毒抗+40","set:TattooShow image:TattooShow_18",""}, 
["dj06"]={"减毒抗","6级","0/284","忽略目标毒抗+48","set:TattooShow image:TattooShow_18",""}, 
["dj07"]={"减毒抗","7级","0/811","忽略目标毒抗+56","set:TattooShow image:TattooShow_19",""}, 
["dj08"]={"减毒抗","8级","0/2088","忽略目标毒抗+64","set:TattooShow image:TattooShow_19",""}, 
["dj09"]={"减毒抗","9级","0/3570","忽略目标毒抗+72","set:TattooShow image:TattooShow_19",""}, 
["dj10"]={"减毒抗","10级","满级","忽略目标毒抗+80","set:TattooShow image:TattooShow_20",""}, 

["bk01"]={"冰抗","1级","0/2","冰抗性+8","set:TattooShow image:TattooShow_13",""},  
["bk02"]={"冰抗","2级","0/9","冰抗性+16","set:TattooShow image:TattooShow_13",""}, 
["bk03"]={"冰抗","3级","0/50","冰抗性+24","set:TattooShow image:TattooShow_13",""}, 
["bk04"]={"冰抗","4级","0/87","冰抗性+32","set:TattooShow image:TattooShow_14",""}, 
["bk05"]={"冰抗","5级","0/165","冰抗性+40","set:TattooShow image:TattooShow_14",""}, 
["bk06"]={"冰抗","6级","0/284","冰抗性+48","set:TattooShow image:TattooShow_14",""}, 
["bk07"]={"冰抗","7级","0/811","冰抗性+56","set:TattooShow image:TattooShow_15",""}, 
["bk08"]={"冰抗","8级","0/2088","冰抗性+64","set:TattooShow image:TattooShow_15",""}, 
["bk09"]={"冰抗","9级","0/3570","冰抗性+72","set:TattooShow image:TattooShow_15",""}, 
["bk10"]={"冰抗","10级","满级","冰抗性+80","set:TattooShow image:TattooShow_16",""}, 

["hk01"]={"火抗","1级","0/2","火抗性+8","set:TattooShow image:TattooShow_13",""},  
["hk02"]={"火抗","2级","0/9","火抗性+16","set:TattooShow image:TattooShow_13",""}, 
["hk03"]={"火抗","3级","0/50","火抗性+24","set:TattooShow image:TattooShow_13",""}, 
["hk04"]={"火抗","4级","0/87","火抗性+32","set:TattooShow image:TattooShow_14",""}, 
["hk05"]={"火抗","5级","0/165","火抗性+40","set:TattooShow image:TattooShow_14",""}, 
["hk06"]={"火抗","6级","0/284","火抗性+48","set:TattooShow image:TattooShow_14",""}, 
["hk07"]={"火抗","7级","0/811","火抗性+56","set:TattooShow image:TattooShow_15",""}, 
["hk08"]={"火抗","8级","0/2088","火抗性+64","set:TattooShow image:TattooShow_15",""}, 
["hk09"]={"火抗","9级","0/3570","火抗性+72","set:TattooShow image:TattooShow_15",""}, 
["hk10"]={"火抗","10级","满级","火抗性+80","set:TattooShow image:TattooShow_16",""}, 

["xk01"]={"玄抗","1级","0/2","玄抗性+8","set:TattooShow image:TattooShow_13",""},  
["xk02"]={"玄抗","2级","0/9","玄抗性+16","set:TattooShow image:TattooShow_13",""}, 
["xk03"]={"玄抗","3级","0/50","玄抗性+24","set:TattooShow image:TattooShow_13",""}, 
["xk04"]={"玄抗","4级","0/87","玄抗性+32","set:TattooShow image:TattooShow_14",""}, 
["xk05"]={"玄抗","5级","0/165","玄抗性+40","set:TattooShow image:TattooShow_14",""}, 
["xk06"]={"玄抗","6级","0/284","玄抗性+48","set:TattooShow image:TattooShow_14",""}, 
["xk07"]={"玄抗","7级","0/811","玄抗性+56","set:TattooShow image:TattooShow_15",""}, 
["xk08"]={"玄抗","8级","0/2088","玄抗性+64","set:TattooShow image:TattooShow_15",""}, 
["xk09"]={"玄抗","9级","0/3570","玄抗性+72","set:TattooShow image:TattooShow_15",""}, 
["xk10"]={"玄抗","10级","满级","玄抗性+80","set:TattooShow image:TattooShow_16",""}, 

["dk01"]={"毒抗","1级","0/2","毒抗性+8","set:TattooShow image:TattooShow_13",""},  
["dk02"]={"毒抗","2级","0/9","毒抗性+16","set:TattooShow image:TattooShow_13",""}, 
["dk03"]={"毒抗","3级","0/50","毒抗性+24","set:TattooShow image:TattooShow_13",""}, 
["dk04"]={"毒抗","4级","0/87","毒抗性+32","set:TattooShow image:TattooShow_14",""}, 
["dk05"]={"毒抗","5级","0/165","毒抗性+40","set:TattooShow image:TattooShow_14",""}, 
["dk06"]={"毒抗","6级","0/284","毒抗性+48","set:TattooShow image:TattooShow_14",""}, 
["dk07"]={"毒抗","7级","0/811","毒抗性+56","set:TattooShow image:TattooShow_15",""}, 
["dk08"]={"毒抗","8级","0/2088","毒抗性+64","set:TattooShow image:TattooShow_15",""}, 
["dk09"]={"毒抗","9级","0/3570","毒抗性+72","set:TattooShow image:TattooShow_15",""}, 
["dk10"]={"毒抗","10级","满级","毒抗性+80","set:TattooShow image:TattooShow_16",""}, 

["ww01"]={"忘无","1级","0/2","强化第一本心法第一个技能，附加伤害15","set:TattooShow image:TattooShow_5",""},  
["ww02"]={"忘无","2级","0/9","强化第一本心法第一个技能，附加伤害30","set:TattooShow image:TattooShow_5",""}, 
["ww03"]={"忘无","3级","0/50","强化第一本心法第一个技能，附加伤害45","set:TattooShow image:TattooShow_5",""}, 
["ww04"]={"忘无","4级","0/87","强化第一本心法第一个技能，附加伤害90","set:TattooShow image:TattooShow_6",""}, 
["ww05"]={"忘无","5级","0/165","强化第一本心法第一个技能，附加伤害150","set:TattooShow image:TattooShow_6",""}, 
["ww06"]={"忘无","6级","0/284","强化第一本心法第一个技能，附加伤害180","set:TattooShow image:TattooShow_6",""}, 
["ww07"]={"忘无","7级","0/811","强化第一本心法第一个技能，附加伤害195","set:TattooShow image:TattooShow_7",""}, 
["ww08"]={"忘无","8级","0/2088","强化第一本心法第一个技能，附加伤害210","set:TattooShow image:TattooShow_7",""}, 
["ww09"]={"忘无","9级","0/3570","强化第一本心法第一个技能，附加伤害270","set:TattooShow image:TattooShow_7",""}, 
["ww10"]={"忘无","10级","满级","强化第一本心法第一个技能，附加伤害360","set:TattooShow image:TattooShow_8",""}, 

["mx01"]={"冥想","1级","0/2","强化第二本心法第一个技能，技能的伤害效果提升10％","set:TattooShow image:TattooShow_5",""},  
["mx02"]={"冥想","2级","0/9","强化第二本心法第一个技能，技能的伤害效果提升20％","set:TattooShow image:TattooShow_5",""}, 
["mx03"]={"冥想","3级","0/50","强化第二本心法第一个技能，技能的伤害效果提升40％","set:TattooShow image:TattooShow_5",""}, 
["mx04"]={"冥想","4级","0/87","强化第二本心法第一个技能，技能的伤害效果提升70％","set:TattooShow image:TattooShow_6",""}, 
["mx05"]={"冥想","5级","0/165","强化第二本心法第一个技能，技能的伤害效果提升100％","set:TattooShow image:TattooShow_6",""}, 
["mx06"]={"冥想","6级","0/284","强化第二本心法第一个技能，技能的伤害效果提升110％","set:TattooShow image:TattooShow_6",""}, 
["mx07"]={"冥想","7级","0/811","强化第二本心法第一个技能，技能的伤害效果提升120％","set:TattooShow image:TattooShow_7",""}, 
["mx08"]={"冥想","8级","0/2088","强化第二本心法第一个技能，技能的伤害效果提升130％","set:TattooShow image:TattooShow_7",""}, 
["mx09"]={"冥想","9级","0/3570","强化第二本心法第一个技能，技能的伤害效果提升140％","set:TattooShow image:TattooShow_7",""}, 
["mx10"]={"冥想","10级","满级","强化第二本心法第一个技能，技能的伤害效果提升150％","set:TattooShow image:TattooShow_8",""}, 

["yj01"]={"御劲","1级","0/2","强化第五本心法第三个技能，技能的伤害效果提升10％","set:TattooShow image:TattooShow_5",""},  
["yj02"]={"御劲","2级","0/9","强化第五本心法第三个技能，技能的伤害效果提升20％","set:TattooShow image:TattooShow_5",""}, 
["yj03"]={"御劲","3级","0/50","强化第五本心法第三个技能，技能的伤害效果提升40％","set:TattooShow image:TattooShow_5",""}, 
["yj04"]={"御劲","4级","0/87","强化第五本心法第三个技能，技能的伤害效果提升70％","set:TattooShow image:TattooShow_6",""}, 
["yj05"]={"御劲","5级","0/165","强化第五本心法第三个技能，技能的伤害效果提升100％","set:TattooShow image:TattooShow_6",""}, 
["yj06"]={"御劲","6级","0/284","强化第五本心法第三个技能，技能的伤害效果提升110％","set:TattooShow image:TattooShow_6",""}, 
["yj07"]={"御劲","7级","0/811","强化第五本心法第三个技能，技能的伤害效果提升120％","set:TattooShow image:TattooShow_7",""}, 
["yj08"]={"御劲","8级","0/2088","强化第五本心法第三个技能，技能的伤害效果提升130％","set:TattooShow image:TattooShow_7",""}, 
["yj09"]={"御劲","9级","0/3570","强化第五本心法第三个技能，技能的伤害效果提升140％","set:TattooShow image:TattooShow_7",""}, 
["yj10"]={"御劲","10级","满级","强化第五本心法第三个技能，技能的伤害效果提升150％","set:TattooShow image:TattooShow_8",""}, 

["bn01"]={"暴怒","1级","0/2","强化第六本心法第一个技能，技能的伤害效果提升10％","set:TattooShow image:TattooShow_5",""},  
["bn02"]={"暴怒","2级","0/9","强化第六本心法第一个技能，技能的伤害效果提升20％","set:TattooShow image:TattooShow_5",""}, 
["bn03"]={"暴怒","3级","0/50","强化第六本心法第一个技能，技能的伤害效果提升40％","set:TattooShow image:TattooShow_5",""}, 
["bn04"]={"暴怒","4级","0/87","强化第六本心法第一个技能，技能的伤害效果提升70％","set:TattooShow image:TattooShow_6",""}, 
["bn05"]={"暴怒","5级","0/165","强化第六本心法第一个技能，技能的伤害效果提升100％","set:TattooShow image:TattooShow_6",""}, 
["bn06"]={"暴怒","6级","0/284","强化第六本心法第一个技能，技能的伤害效果提升110％","set:TattooShow image:TattooShow_6",""}, 
["bn07"]={"暴怒","7级","0/811","强化第六本心法第一个技能，技能的伤害效果提升120％","set:TattooShow image:TattooShow_7",""}, 
["bn08"]={"暴怒","8级","0/2088","强化第六本心法第一个技能，技能的伤害效果提升130％","set:TattooShow image:TattooShow_7",""}, 
["bn09"]={"暴怒","9级","0/3570","强化第六本心法第一个技能，技能的伤害效果提升140％","set:TattooShow image:TattooShow_7",""}, 
["bn10"]={"暴怒","10级","满级","强化第六本心法第一个技能，技能的伤害效果提升150％","set:TattooShow image:TattooShow_8",""}, 
}	
local DarkDwData = {[1]="ti",[2]="bg",[3]="hg",[4]="xg",[5]="dg",[6]="bj",[7]="hj",[8]="xj",[9]="dj"}

local b ,c ,d="","",""
--*****************************************************
--Q546528533极致添加暗器雕纹修正
--*****************************************************
    if string.find(Explain,"修炼瓶颈") ~= nil then
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
		    b ="#cFF0000"..g_XieZi_DwStr[nData][1].."雕纹"..g_XieZi_DwStr[nData][2].."\n升级需要的材料数："..g_XieZi_DwStr[nData][3].."\n"..g_XieZi_DwStr[nData][4].."\n"
		    c= g_XieZi_DwStr[nData][5]
			d= 0
			return b,c,d
		else
		    return  0,0,0
		end
	    return  0,0,0
	end
--*****************************************************
--Q546528533极致添加暗器雕纹修正
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
 b ="#cFF0000"..g_XieZi_DwStr[str][1].."雕纹"..g_XieZi_DwStr[str][2].."\n升级需要的材料数："..g_XieZi_DwStr[str][3].."\n"..g_XieZi_DwStr[str][4].."\n"
 c= g_XieZi_DwStr[str][5]
 d= 0
end 

if g_XieZi_DwStr[str] ~= nil and g_XieZi_DwStr[str1] ~= nil then
 b ="#cFF0000双级雕纹："..g_XieZi_DwStr[str][1].."·"..g_XieZi_DwStr[str1][1].."("..g_XieZi_DwStr[str][2].."·"..g_XieZi_DwStr[str1][2]..")\n升级所需："..g_XieZi_DwStr[str][1].."("..g_XieZi_DwStr[str][3]..") "..g_XieZi_DwStr[str1][1].."("..g_XieZi_DwStr[str1][3]..") \n双级·"..g_XieZi_DwStr[str][1].."："..g_XieZi_DwStr[str][4].."\n双级·"..g_XieZi_DwStr[str1][1].."："..g_XieZi_DwStr[str1][4].."\n"
 c= g_XieZi_DwStr[str][5]
 d= g_XieZi_DwStr[str1][5]
end 
return b,c,d
end