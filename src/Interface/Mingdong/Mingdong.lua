--*******************************************
--信手斬龍（原极致） Q546528533
--*******************************************
local g_Frame_UnifiedXPosition;
local g_Frame_UnifiedYPosition;
local g_start_time = 0
local g_end_time = 0
local nUItype = 0
local nMenPaiName = {"少林","明教","丐帮","武当","峨嵋","星宿","天龙","天山","逍遥","","曼陀山庄","唐门","鬼谷"}
local acme_list = {}
function Mingdong_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("SCENE_TRANSED")	
end

function Mingdong_OnLoad()	
	-- 保存界面的默认相对位置
	g_Frame_UnifiedXPosition	= Mingdong_Frame:GetProperty("UnifiedXPosition");
	g_Frame_UnifiedYPosition	= Mingdong_Frame:GetProperty("UnifiedYPosition");
end



function Mingdong_OnEvent(event)
	
	if	event == "UI_COMMAND"  and tonumber(arg0) == 201812291 then   ---首次充值
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
		Mingdong_Title:SetText("#gFF0FA0名动江湖榜")
		-- Mingdong_Paihang_Info:SetText(string.format("    #G%s#cfff263至#G%s#cfff263期间争夺榜单，活动结束后的第一天领取结算，进行#G元宝兑换#cfff263时#G名动值#cfff263将会提升。获得的名动值达到#G600点#cfff263既有机会领取战区重楼榜。#r    #G声名远扬:开奖前#cfff263战区重楼榜累计获得名动值排名1-10位的玩家，可以根据排名获得不同的奖励#Y。#r注意：最后一天的24点后充值无法累计到排行榜内，领奖时间为第二天，第三天结束无法领取。",g_start_time,g_end_time))		
		-- Mingdong_Paihang_PlayerNameText2:SetText("活动的时间结束后可领取")
		-- local Nian,yue,ri = math.floor(g_end_time/10000),math.mod(math.floor(g_end_time/100),100),math.mod(g_end_time,100)
		-- Mingdong_Paihang_Accumulate2:SetText(string.format("#cfff263%s年%s月%s日24点开区名动榜排名前几的玩家可领取",Nian,yue,ri))
		-- Mingdong_Paihang_Accumulate:SetText(string.format("#cfff263活动日期内获得的点数为#G%s#cfff263点",DataPool:GetPlayerMission_DataRound(506)))
		-- Mingdong_Paihang_LastTime:SetText(string.format("#cfff263距豪情磊落奖的开奖时间剩余：#G%s",g_end_time - g_start_time))
		MingDong_UpateData()
	elseif 	event == "UI_COMMAND"  and tonumber(arg0) == 201812292 then
		Mingdong_Paihang_Info:SetText(Get_XParam_STR(0))
		Mingdong_Paihang_Accumulate2:SetText("#cfff263活动结束后可在右侧领奖按钮进行领取，领取前请预留足够的背包空间。")
		Mingdong_Paihang_Accumulate:SetText(string.format("#cfff263活动期间累计获得的名动值为#G%s#cfff263点",Get_XParam_STR(2)))
		Mingdong_Paihang_LastTime:SetText(string.format("#cfff263距名动江湖榜的结束时间剩余：#G%s",Get_XParam_STR(3)))
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





