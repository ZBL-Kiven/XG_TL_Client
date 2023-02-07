local NEWBIEHELP_MY_LEVEL = 1
local g_FreshManIntro_Frame_UnifiedPosition;

local NEWBIEHELP_EVENT_TABLE_SERVER_COMMAND = 
{
{ command=888888, arg=1, set=1 },
{ command=888888, arg=3, set=5 }
}

local NEWBIEHELP_EVENT_TABLE_TRANSCENE_WITH_MISSION = 
{
{ scene="wuliangscene", mission="Mission:1403", set=4 },
{ scene="newbie_2", mission="Mission:1415", set=8 }
}

local NEWBIEHELP_EVENT_TABLE_FINISH_MISSION = 
{
{ mission="1401", set=3 },
{ mission="1415", set=9 },
{ mission="1406", set=6 },
}

local NEWBIEHELP_EVENT_TABLE_LEARN_SKILL = 
{
{ skill=241, set=5 }
}

local NEWBIEHELP_EVENT_TABLE_ACCEPT_MISSION = 
{
{ mission="Mission:1401", set=2 },
{ mission="Mission:1414", set=7 }
}


local NEWBIEHELP_TUTORIAL = 
{
{set=1,num=4,image={{"set:FreshManIntro01_01_1 image:IntroImage1_1",
                     "set:FreshManIntro01_01_2 image:IntroImage1_2",
                     "set:FreshManIntro01_01_3 image:IntroImage1_3",
                     "set:FreshManIntro01_01_3 image:IntroImage1_4",
                     "set:FreshManIntro01_01_4 image:IntroImage1_5",
                     "set:FreshManIntro01_01_4 image:IntroImage1_6"},
                     {"set:FreshManIntro01_02_1 image:IntroImage1_1",
                     "set:FreshManIntro01_02_2 image:IntroImage1_2",
                     "set:FreshManIntro01_02_3 image:IntroImage1_3",
                     "set:FreshManIntro01_02_3 image:IntroImage1_4",
                     "set:FreshManIntro01_02_4 image:IntroImage1_5",
                     "set:FreshManIntro01_02_4 image:IntroImage1_6"},
                     {"set:FreshManIntro01_03_1 image:IntroImage1_1",
                     "set:FreshManIntro01_03_2 image:IntroImage1_2",
                     "set:FreshManIntro01_03_3 image:IntroImage1_3",
                     "set:FreshManIntro01_03_3 image:IntroImage1_4",
                     "set:FreshManIntro01_03_4 image:IntroImage1_5",
                     "set:FreshManIntro01_03_4 image:IntroImage1_6"},
                     {"set:FreshManIntro01_04_1 image:IntroImage1_1",
                     "set:FreshManIntro01_04_2 image:IntroImage1_2",
                     "set:FreshManIntro01_04_3 image:IntroImage1_3",
                     "set:FreshManIntro01_04_3 image:IntroImage1_4",
                     "set:FreshManIntro01_04_4 image:IntroImage1_5",
                     "set:FreshManIntro01_04_4 image:IntroImage1_6"}}},

{set=2,num=2,image={{"set:FreshManIntro02_01_1 image:IntroImage1_1",
                     "set:FreshManIntro02_01_2 image:IntroImage1_2",
                     "set:FreshManIntro02_01_3 image:IntroImage1_3",
                     "set:FreshManIntro02_01_3 image:IntroImage1_4",
                     "set:FreshManIntro02_01_4 image:IntroImage1_5",
                     "set:FreshManIntro02_01_4 image:IntroImage1_6"},
                     {"set:FreshManIntro02_02_1 image:IntroImage1_1",
                     "set:FreshManIntro02_02_2 image:IntroImage1_2",
                     "set:FreshManIntro02_02_3 image:IntroImage1_3",
                     "set:FreshManIntro02_02_3 image:IntroImage1_4",
                     "set:FreshManIntro02_02_4 image:IntroImage1_5",
                     "set:FreshManIntro02_02_4 image:IntroImage1_6"}}},

{set=3,num=5,image={{"set:FreshManIntro03_01_1 image:IntroImage1_1",
                     "set:FreshManIntro03_01_2 image:IntroImage1_2",
                     "set:FreshManIntro03_01_3 image:IntroImage1_3",
                     "set:FreshManIntro03_01_3 image:IntroImage1_4",
                     "set:FreshManIntro03_01_4 image:IntroImage1_5",
                     "set:FreshManIntro03_01_4 image:IntroImage1_6"},
                     {"set:FreshManIntro03_02_1 image:IntroImage1_1",
                     "set:FreshManIntro03_02_2 image:IntroImage1_2",
                     "set:FreshManIntro03_02_3 image:IntroImage1_3",
                     "set:FreshManIntro03_02_3 image:IntroImage1_4",
                     "set:FreshManIntro03_02_4 image:IntroImage1_5",
                     "set:FreshManIntro03_02_4 image:IntroImage1_6"},
                     {"set:FreshManIntro03_03_1 image:IntroImage1_1",
                     "set:FreshManIntro03_03_2 image:IntroImage1_2",
                     "set:FreshManIntro03_03_3 image:IntroImage1_3",
                     "set:FreshManIntro03_03_3 image:IntroImage1_4",
                     "set:FreshManIntro03_03_4 image:IntroImage1_5",
                     "set:FreshManIntro03_03_4 image:IntroImage1_6"},
                     {"set:FreshManIntro03_04_1 image:IntroImage1_1",
                     "set:FreshManIntro03_04_2 image:IntroImage1_2",
                     "set:FreshManIntro03_04_3 image:IntroImage1_3",
                     "set:FreshManIntro03_04_3 image:IntroImage1_4",
                     "set:FreshManIntro03_04_4 image:IntroImage1_5",
                     "set:FreshManIntro03_04_4 image:IntroImage1_6"},
                     {"set:FreshManIntro03_05_1 image:IntroImage1_1",
                     "set:FreshManIntro03_05_2 image:IntroImage1_2",
                     "set:FreshManIntro03_05_3 image:IntroImage1_3",
                     "set:FreshManIntro03_05_3 image:IntroImage1_4",
                     "set:FreshManIntro03_05_4 image:IntroImage1_5",
                     "set:FreshManIntro03_05_4 image:IntroImage1_6"}}},

{set=4,num=2,image={{"set:FreshManIntro04_01_1 image:IntroImage1_1",
                     "set:FreshManIntro04_01_2 image:IntroImage1_2",
                     "set:FreshManIntro04_01_3 image:IntroImage1_3",
                     "set:FreshManIntro04_01_3 image:IntroImage1_4",
                     "set:FreshManIntro04_01_4 image:IntroImage1_5",
                     "set:FreshManIntro04_01_4 image:IntroImage1_6"},
                     {"set:FreshManIntro04_02_1 image:IntroImage1_1",
                     "set:FreshManIntro04_02_2 image:IntroImage1_2",
                     "set:FreshManIntro04_02_3 image:IntroImage1_3",
                     "set:FreshManIntro04_02_3 image:IntroImage1_4",
                     "set:FreshManIntro04_02_4 image:IntroImage1_5",
                     "set:FreshManIntro04_02_4 image:IntroImage1_6"}}},

{set=5,num=3,image={{"set:FreshManIntro05_01_1 image:IntroImage1_1",
                     "set:FreshManIntro05_01_2 image:IntroImage1_2",
                     "set:FreshManIntro05_01_3 image:IntroImage1_3",
                     "set:FreshManIntro05_01_3 image:IntroImage1_4",
                     "set:FreshManIntro05_01_4 image:IntroImage1_5",
                     "set:FreshManIntro05_01_4 image:IntroImage1_6"},
                     {"set:FreshManIntro05_02_1 image:IntroImage1_1",
                     "set:FreshManIntro05_02_2 image:IntroImage1_2",
                     "set:FreshManIntro05_02_3 image:IntroImage1_3",
                     "set:FreshManIntro05_02_3 image:IntroImage1_4",
                     "set:FreshManIntro05_02_4 image:IntroImage1_5",
                     "set:FreshManIntro05_02_4 image:IntroImage1_6"},
                     {"set:FreshManIntro05_03_1 image:IntroImage1_1",
                     "set:FreshManIntro05_03_2 image:IntroImage1_2",
                     "set:FreshManIntro05_03_3 image:IntroImage1_3",
                     "set:FreshManIntro05_03_3 image:IntroImage1_4",
                     "set:FreshManIntro05_03_4 image:IntroImage1_5",
                     "set:FreshManIntro05_03_4 image:IntroImage1_6"}}},

{set=6,num=1,image={{"set:FreshManIntro06_01_1 image:IntroImage1_1",
                     "set:FreshManIntro06_01_2 image:IntroImage1_2",
                     "set:FreshManIntro06_01_3 image:IntroImage1_3",
                     "set:FreshManIntro06_01_3 image:IntroImage1_4",
                     "set:FreshManIntro06_01_4 image:IntroImage1_5",
                     "set:FreshManIntro06_01_4 image:IntroImage1_6"}}},

{set=7,num=3,image={{"set:FreshManIntro07_01_1 image:IntroImage1_1",
                     "set:FreshManIntro07_01_2 image:IntroImage1_2",
                     "set:FreshManIntro07_01_3 image:IntroImage1_3",
                     "set:FreshManIntro07_01_3 image:IntroImage1_4",
                     "set:FreshManIntro07_01_4 image:IntroImage1_5",
                     "set:FreshManIntro07_01_4 image:IntroImage1_6"},
                     {"set:FreshManIntro07_02_1 image:IntroImage1_1",
                     "set:FreshManIntro07_02_2 image:IntroImage1_2",
                     "set:FreshManIntro07_02_3 image:IntroImage1_3",
                     "set:FreshManIntro07_02_3 image:IntroImage1_4",
                     "set:FreshManIntro07_02_4 image:IntroImage1_5",
                     "set:FreshManIntro07_02_4 image:IntroImage1_6"},
                     {"set:FreshManIntro07_03_1 image:IntroImage1_1",
                     "set:FreshManIntro07_03_2 image:IntroImage1_2",
                     "set:FreshManIntro07_03_3 image:IntroImage1_3",
                     "set:FreshManIntro07_03_3 image:IntroImage1_4",
                     "set:FreshManIntro07_03_4 image:IntroImage1_5",
                     "set:FreshManIntro07_03_4 image:IntroImage1_6"}}},

{set=8,num=2,image={{"set:FreshManIntro08_01_1 image:IntroImage1_1",
                     "set:FreshManIntro08_01_2 image:IntroImage1_2",
                     "set:FreshManIntro08_01_3 image:IntroImage1_3",
                     "set:FreshManIntro08_01_3 image:IntroImage1_4",
                     "set:FreshManIntro08_01_4 image:IntroImage1_5",
                     "set:FreshManIntro08_01_4 image:IntroImage1_6"},
                     {"set:FreshManIntro08_02_1 image:IntroImage1_1",
                     "set:FreshManIntro08_02_2 image:IntroImage1_2",
                     "set:FreshManIntro08_02_3 image:IntroImage1_3",
                     "set:FreshManIntro08_02_3 image:IntroImage1_4",
                     "set:FreshManIntro08_02_4 image:IntroImage1_5",
                     "set:FreshManIntro08_02_4 image:IntroImage1_6"}}},

{set=9,num=1,image={{"set:FreshManIntro09_01_1 image:IntroImage1_1",
                     "set:FreshManIntro09_01_2 image:IntroImage1_2",
                     "set:FreshManIntro09_01_3 image:IntroImage1_3",
                     "set:FreshManIntro09_01_3 image:IntroImage1_4",
                     "set:FreshManIntro09_01_4 image:IntroImage1_5",
                     "set:FreshManIntro09_01_4 image:IntroImage1_6"}}},

{set=10,num=2,image={{"set:FreshManIntro10_01_1 image:IntroImage1_1",
                     "set:FreshManIntro10_01_2 image:IntroImage1_2",
                     "set:FreshManIntro10_01_3 image:IntroImage1_3",
                     "set:FreshManIntro10_01_3 image:IntroImage1_4",
                     "set:FreshManIntro10_01_4 image:IntroImage1_5",
                     "set:FreshManIntro10_01_4 image:IntroImage1_6"},
                     {"set:FreshManIntro10_03_1 image:IntroImage1_1",
                     "set:FreshManIntro10_03_2 image:IntroImage1_2",
                     "set:FreshManIntro10_03_3 image:IntroImage1_3",
                     "set:FreshManIntro10_03_3 image:IntroImage1_4",
                     "set:FreshManIntro10_03_4 image:IntroImage1_5",
                     "set:FreshManIntro10_03_4 image:IntroImage1_6"}}},

}

local now_tutorial_set = 0
local now_tutorial_page = 0

--===============================================
-- OnLoad()
--===============================================
function FreshManIntro_PreLoad()
	this:RegisterEvent("SCENE_TRANSED");
	this:RegisterEvent("FINISH_MISSION");
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("NEW_MISSION");
	this:RegisterEvent("OPEN_FRESHMAN_INTRO");
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")	
	this:RegisterEvent("UNIT_LEVEL")	
end

function FreshManIntro_OnLoad()
	g_FreshManIntro_Frame_UnifiedPosition=FreshManIntro_Frame:GetProperty("UnifiedPosition");
end

function FreshManIntro_OnHiden()
    
end


--===============================================
-- OnEvent()
--===============================================
function FreshManIntro_OnEvent(event)

	--PushDebugMessage("FreshManIntro_OnEvent " .. event.. " " .. arg0 .. " " .. arg1 .. " " .. arg2);

	if (event == "ADJEST_UI_POS" ) then
		FreshManIntro_Frame_On_ResetPos()
		-- 游戏分辨率发生了变化
		return

	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		FreshManIntro_Frame_On_ResetPos()
		return

	end

	if (event == "UNIT_LEVEL" ) then
		NEWBIEHELP_MY_LEVEL = Player:GetData("LEVEL")
		return
	end

	local nLevel = Player:GetData("LEVEL")
	if nLevel == nil then
		--PushDebugMessage("FreshManIntro_OnEvent nil level" );
		return
	end

	--PushDebugMessage("FreshManIntro_OnEvent level " .. nLevel );
	--因为切场景的时候获得的Player:GetData("LEVEL")是0，不愿意动底层所以如此
	if nLevel == 0 then
		nLevel = NEWBIEHELP_MY_LEVEL
	end

	if nLevel > 20 then
		return
	end

	local showed = 0;
	if ( event == "SCENE_TRANSED" ) then
		for i, transtab in NEWBIEHELP_EVENT_TABLE_TRANSCENE_WITH_MISSION do
			if( transtab.scene == arg0 ) then
				for j = 1, 20 do
					if (DataPool:GetPlayerMission_InUse(j-1) == 1) then
						local missname = DataPool:GetPlayerMission_Name(j-1)
						--PushDebugMessage("FreshManIntro_Mission " .. missname );
						if ( missname == transtab.mission ) then
							--PushDebugMessage( transtab.mission .." == " .. missname );
							showed = FreshManIntro_ReSetImage( transtab.set )
							break;
						--else
							--PushDebugMessage( transtab.mission .." != " .. missname );
						end
					end
				end
			end
			if(showed ==1) then
				break;
			end
		end
	elseif ( event == "UI_COMMAND" ) then
		for i, commandtab in NEWBIEHELP_EVENT_TABLE_SERVER_COMMAND do
			if( commandtab.command == tonumber( arg0 ) and commandtab.arg == Get_XParam_INT(0)) then
				showed = FreshManIntro_ReSetImage( commandtab.set )
			end
			if(showed ==1) then
				break;
			end
		end
	elseif ( event == "NEW_MISSION" ) then

		for i, newmissiontab in NEWBIEHELP_EVENT_TABLE_ACCEPT_MISSION do
			local missname = DataPool:GetPlayerMission_Name(tonumber( arg0 ))
			--PushDebugMessage( newmissiontab.mission.." :: " .. missname );
			if( newmissiontab.mission == missname ) then
				showed = FreshManIntro_ReSetImage( newmissiontab.set )
			end
			if(showed ==1) then
				break;
			end
		end

	elseif ( event == "FINISH_MISSION" ) then

		for i, finishmissiontab in NEWBIEHELP_EVENT_TABLE_FINISH_MISSION do
			--local missname = DataPool:GetPlayerMission_Name(tonumber( arg0 ))
			--PushDebugMessage( finishmissiontab.mission.." :: " .. arg0 );
			if( finishmissiontab.mission == arg0 ) then
				showed = FreshManIntro_ReSetImage( finishmissiontab.set )
			end
			if(showed ==1) then
				break;
			end
		end

	elseif ( event == "OPEN_FRESHMAN_INTRO" ) then
		local introSet = tonumber(arg0)
		FreshManIntro_ReSetImage( introSet )

	end

end

--================================================
-- 恢复界面的默认相对位置
--================================================
function FreshManIntro_Frame_On_ResetPos()
	FreshManIntro_Frame:SetProperty("UnifiedPosition", g_FreshManIntro_Frame_UnifiedPosition);
end

function FreshManIntro_ReSetImage( transtabset )
	now_tutorial_set = transtabset
	now_tutorial_page = 1
	return FreshManIntro_SetImage( );
end

function FreshManIntro_SetImage( )
	--PushDebugMessage( "FreshManIntro_SetImage ".. now_tutorial_set .." ".. now_tutorial_page );
	if now_tutorial_set == 0 then
		return
	end
	local tutorialtab = NEWBIEHELP_TUTORIAL[now_tutorial_set]
	if(now_tutorial_page >= tutorialtab.num) then
		FreshManIntro_DownPage:Disable();
	end
	if(now_tutorial_page <= 1) then
		FreshManIntro_UpPage:Disable();
	end

	if( tutorialtab.num > 1 )then
		if(now_tutorial_page > 1)then
			FreshManIntro_UpPage:Enable();
		end
		if(now_tutorial_page < tutorialtab.num)then
			FreshManIntro_DownPage:Enable();
		end
	end

	if(tutorialtab~=nil) then
		if ( now_tutorial_page > tutorialtab.num or now_tutorial_page < 1 ) then
			return
		end

		--PushDebugMessage(tutorialtab.image[now_tutorial_page][1])
		--PushDebugMessage(tutorialtab.image[now_tutorial_page][2])
		--PushDebugMessage(tutorialtab.image[now_tutorial_page][3])
		--PushDebugMessage(tutorialtab.image[now_tutorial_page][4])
		--PushDebugMessage(tutorialtab.image[now_tutorial_page][5])
		--PushDebugMessage(tutorialtab.image[now_tutorial_page][6])
		
		FreshManIntro_Image1:SetProperty("Image", tutorialtab.image[now_tutorial_page][1])
		FreshManIntro_Image2:SetProperty("Image", tutorialtab.image[now_tutorial_page][2])
		FreshManIntro_Image3:SetProperty("Image", tutorialtab.image[now_tutorial_page][3])
		FreshManIntro_Image4:SetProperty("Image", tutorialtab.image[now_tutorial_page][4])
		FreshManIntro_Image5:SetProperty("Image", tutorialtab.image[now_tutorial_page][5])
		FreshManIntro_Image6:SetProperty("Image", tutorialtab.image[now_tutorial_page][6])
		this:Show();
		return 1
	else
		return 0
	end
end

function FreshManIntro_Close()
	this:Hide();
end


function FreshManIntro_PageUp()
	--PushDebugMessage("FreshManIntro_FunctionPrev " .. now_tutorial_set.." "..now_tutorial_page );
	if(now_tutorial_page<=1) then
		return;
	end

	now_tutorial_page = now_tutorial_page - 1
	FreshManIntro_SetImage( )
end

function FreshManIntro_PageDown()
	--PushDebugMessage("FreshManIntro_FunctionNext " .. now_tutorial_set.." "..now_tutorial_page );
	local tutorialtab = NEWBIEHELP_TUTORIAL[now_tutorial_set]
	if(tutorialtab~=nil) then
		if(now_tutorial_page >= tutorialtab.num) then
			return;
		end
	end

	now_tutorial_page = now_tutorial_page + 1
	FreshManIntro_SetImage( )
end

function FreshManIntro_Quit_Clicked()
	this:Hide();
end
