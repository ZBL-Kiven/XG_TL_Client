--LandReward
local g_LandReward_Frame_UnifiedPosition;

local g_AccountDay = 0
local g_IsGetGift = {0,0,0,0,0,0}

local g_Fengyecount = 0

local g_LandReward_Gifts = {
	[1] ={
				[1]={ItemID = 30503133, num = 3, needbind =1,}, 
				[2]={ItemID = 20310168, num = 5, needbind =1,},
				[3]={ItemID = 38000202, num = 1, needbind =1,},
				},
	[2] ={
				[1]={ItemID = 30700241, num = 3, needbind =1,},
				[2]={ItemID = 20310168, num = 7, needbind =1,},
				[3]={ItemID = 38002162, num = 1, needbind =1,}
				},
	[3] ={
				[1]={ItemID = 30900045, num = 1, needbind =1,},
				[2]={ItemID = 20310168, num = 9, needbind =1,},
				[3]={ItemID = 38002166, num = 1, needbind =1,},
				},
	[4] ={
				[1]={ItemID = 30008048, num = 1, needbind =1,},
				[2]={ItemID = 20310168, num = 11, needbind =1,},
				[3]={ItemID = 38002174, num = 1, needbind =1,},
				},
	[5] ={
				[1]={ItemID = 20502003, num = 1, needbind =1,},
				[2]={ItemID = 20310168, num = 13, needbind =1,},
				[3]={ItemID = 38002175, num = 1, needbind =1,},
				},
	[6] ={
				[1]={ItemID = 20501003, num = 1, needbind =1,},
				[2]={ItemID = 20310168, num = 15, needbind =1,},
				[3]={ItemID = 38002176, num = 1, needbind =1,},
				},									
}
local g_NeedLoginDays = {1,3,5,8,12,15}

--界面上显示奖励物品的ICON表
local g_LandReward_GiftsIcons = { }
local g_LandReward_Button = {}
local g_LandReward_NotReach = {}

function LandReward_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	--离开场景，自动关闭
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED");
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("UPDATE_REDPOINT_IN_UI")
end

function LandReward_OnLoad()
	g_LandReward_Frame_UnifiedPosition=LandReward_Frame:GetProperty("UnifiedPosition");

	--界面上显示奖励物品的ICON表
	g_LandReward_GiftsIcons =
	{
	[1] = {LandReward_DengLu_Bk1_Icon1, LandReward_DengLu_Bk1_Icon2, LandReward_DengLu_Bk1_Icon3, LandReward_DengLu_Bk1_Icon4, }, 
	[2] = {LandReward_DengLu_Bk2_Icon1, LandReward_DengLu_Bk2_Icon2, LandReward_DengLu_Bk2_Icon3, LandReward_DengLu_Bk2_Icon4, }, 
	[3] = {LandReward_DengLu_Bk3_Icon1, LandReward_DengLu_Bk3_Icon2, LandReward_DengLu_Bk3_Icon3, LandReward_DengLu_Bk3_Icon4, }, 
	[4] = {LandReward_DengLu_Bk4_Icon1, LandReward_DengLu_Bk4_Icon2, LandReward_DengLu_Bk4_Icon3, LandReward_DengLu_Bk4_Icon4, }, 
	[5] = {LandReward_DengLu_Bk5_Icon1, LandReward_DengLu_Bk5_Icon2, LandReward_DengLu_Bk5_Icon3, LandReward_DengLu_Bk5_Icon4, }, 
	[6] = {LandReward_DengLu_Bk6_Icon1, LandReward_DengLu_Bk6_Icon2, LandReward_DengLu_Bk6_Icon3, LandReward_DengLu_Bk6_Icon4, }, 
	}
	
	g_LandReward_Button = {
		[1] = LandReward_DengLu_Bk1_Button1,
		[2] = LandReward_DengLu_Bk2_Button1,
		[3] = LandReward_DengLu_Bk3_Button1,
		[4] = LandReward_DengLu_Bk4_Button1,
		[5] = LandReward_DengLu_Bk5_Button1,
		[6] = LandReward_DengLu_Bk6_Button1,
	}
	
	g_LandReward_NotReach = {
		[1] = LandReward_DengLu_Bk1_Button1NotReach,
		[2] = LandReward_DengLu_Bk2_Button1NotReach,
		[3] = LandReward_DengLu_Bk3_Button1NotReach,
		[4] = LandReward_DengLu_Bk4_Button1NotReach,
		[5] = LandReward_DengLu_Bk5_Button1NotReach,
		[6] = LandReward_DengLu_Bk6_Button1NotReach,
	}
end

-- OnEvent
function LandReward_OnEvent(event)

	if (event == "UI_COMMAND") and (tonumber(arg0) == 89267801) then	
		--打开界面
		local operator = Get_XParam_INT(0)
		if operator == 1 then
			g_AccountDay = Get_XParam_INT(1)
			for i = 1, 6 do
				g_IsGetGift[i] = Get_XParam_INT(1+i)
			end
			
			LandReward_UpdateUI()
			this:Show();
		elseif operator == 2 then
			if this:IsVisible() then
				for i = 1, 6 do
					g_IsGetGift[i] = Get_XParam_INT(i)
				end
				LandReward_UpdateUI()
			end
		end
		--LandReward_UpdateRedPointInUI()	

	elseif( event == "HIDE_ON_SCENE_TRANSED") then
		this:Hide();
		return;
	elseif (event == "ADJEST_UI_POS" ) then
		LandReward_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		LandReward_Frame_On_ResetPos()
		
	end

end

function LandReward_UpdateRedPointInUI()	

end
--显示界面内容
function LandReward_UpdateUI()	
		
	local str = ScriptGlobal_Format("#{LJDL_170823_05}",tostring(g_AccountDay))
	LandReward_DengLu_InfoText:SetText(str)
	
    --将物品奖励加载到页面显示
    for i = 1,  table.getn(g_LandReward_GiftsIcons) do
    	for j = 1, table.getn(g_LandReward_GiftsIcons[i]) do
    		local	GiftItemID	=	-1
    		local	GiftItemNum	=	0
			if j > table.getn( g_LandReward_Gifts[i] ) then
    			g_LandReward_GiftsIcons[i][j]:Hide();
    		else
    			GiftItemID	=	g_LandReward_Gifts[i][j].ItemID
    			GiftItemNum	= 	g_LandReward_Gifts[i][j].num
    			local theAction = DataPool:CreateBindActionItemForShow(GiftItemID, GiftItemNum)
    			if theAction:GetID() ~= 0 then
    				g_LandReward_GiftsIcons[i][j]:SetActionItem(theAction:GetID());
    				g_LandReward_GiftsIcons[i][j]:Show();
    			end
    		end
    	end
    end	
	
	for i = 1, 6 do
		if g_AccountDay >= g_NeedLoginDays[i] then
			g_LandReward_NotReach[i]:Hide()
			g_LandReward_Button[i]:Show()
			if g_IsGetGift[i] == 1 then
				g_LandReward_Button[i]:Disable()
			else
				g_LandReward_Button[i]:Enable()
			end
		else
			g_LandReward_NotReach[i]:Show()
			g_LandReward_Button[i]:Hide()
		end

	end
end

function LandReward_DengLu_GetGift( btnId )

		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "GetLoginDaysPrize" )
			Set_XSCRIPT_ScriptID( 892678 )
			Set_XSCRIPT_Parameter(0,btnId)
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
	
end

function LandReward_Frame_On_ResetPos()
  LandReward_Frame:SetProperty("UnifiedPosition", g_LandReward_Frame_UnifiedPosition);
end	

function LandReward_Close()
	this:Hide();
end