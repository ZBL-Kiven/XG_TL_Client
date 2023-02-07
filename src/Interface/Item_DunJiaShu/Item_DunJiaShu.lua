-- 遁甲奇(天)书专用界面，请不要用于其他功能，
local g_SERVER_CONTROL_1 = 1122361   --遁甲天书使用界面
local g_SERVER_CONTROL_2 = 1122371   --遁甲奇书使用界面
local g_SERVER_CONTROL_3 = 330061	 --遁甲书VIP专用使用界面
local g_Client_ItemIndex = 0
local g_CurSelectIndex_DJTS = 0
local g_CurSelectIndex_DJQS = 0
local g_CurSelectIndex_DJVIP = 0


local g_DJTS_MAX_USETIMES =20
local g_DJTS_INIT_USETIMES =20
local g_DJQS_MAX_USETIMES =20
local YeQianBtnArray = {}
local g_SceneLogData = ""
local g_SceneNamestring = ""
local g_Item_Const = 0
local g_Type_Index = 0
local g_Type	-- "useDJTS"使用遁甲天书
		        -- "useDJQS"使用遁甲奇书
				-- "useDJVIP"使用遁甲书VIP

local g_Item_DunJiaShu_Frame_UnifiedPosition;

local g_CurSelectPage = 1

local PosBtnArray = {}
local PosBtnTextArray = {}

local g_defBtnTextCr = "#cfff263#e000001"

--缺省场景,仅显示需要
local DefaultScn=
{
	{"#{DJTS_110509_34}",401,223,225},	--秦皇地宫二层
	{"#{DJTS_110509_36}",161,13,25},	--燕王古墓三层
	{"#{DJTS_110509_37}",165,25,108},	--燕王古墓七层
	{"#{DJTS_110509_35}",402,224,216},	--燕王古墓七层
}
local DunJiaShu_NameScene,DunJiaShu_PosZ,DunJiaShu_PosX = {"","","","","","","","","","","","","","",""},{"0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"},{"0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"}
--===============================================
-- PreLoad()
--===============================================
function Get_Scene_NameAndPos()
	local pos1,pos2		
	pos1,pos2,DunJiaShu_PosZ[1],DunJiaShu_PosX[1],DunJiaShu_PosZ[2],DunJiaShu_PosX[2],DunJiaShu_PosZ[3],DunJiaShu_PosX[3],DunJiaShu_PosZ[4],DunJiaShu_PosX[4],DunJiaShu_PosZ[5],DunJiaShu_PosX[5],DunJiaShu_PosZ[6],DunJiaShu_PosX[6],DunJiaShu_PosZ[7],DunJiaShu_PosX[7],DunJiaShu_PosZ[8],DunJiaShu_PosX[8],DunJiaShu_PosZ[9],DunJiaShu_PosX[9],DunJiaShu_PosZ[10],DunJiaShu_PosX[10] = string.find(g_SceneLogData,string.rep("(%d%d%d)",20))
	if 	pos1 == nil or 	pos2 == nil then
		for i =1,10 do
			DunJiaShu_PosZ[i] = "0"
			DunJiaShu_PosX[i] = "0"
		end
	end
	pos1,pos2,DunJiaShu_NameScene[1],DunJiaShu_NameScene[2],DunJiaShu_NameScene[3],DunJiaShu_NameScene[4],DunJiaShu_NameScene[5],DunJiaShu_NameScene[6],DunJiaShu_NameScene[7],DunJiaShu_NameScene[8],DunJiaShu_NameScene[9],DunJiaShu_NameScene[10] = string.find(g_SceneNamestring,string.rep("(.-)|",10))
	if 	pos1 == nil or 	pos2 == nil then
		for i =1,10 do
			DunJiaShu_NameScene[i] = ""
		end
	end

	for i = 1,4 do
		if DunJiaShu_NameScene[i] == "" and g_CurSelectPage == 1 then
			DunJiaShu_NameScene[i] = DefaultScn[i][1]
			DunJiaShu_PosZ[i] = DefaultScn[i][3]
			DunJiaShu_PosX[i] = DefaultScn[i][4]
		end
	end

end

--===============================================
-- PreLoad()
--===============================================
function Item_DunJiaShu_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	this:RegisterEvent("SCENE_TRANSED");
	this:RegisterEvent("ON_SCENE_TRANSING");
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

--===============================================
-- OnLoad()
--===============================================
function Item_DunJiaShu_OnLoad()
	g_Item_DunJiaShu_Frame_UnifiedPosition=Item_DunJiaShu_Frame:GetProperty("UnifiedPosition");
	PosBtnArray[1] = Item_DunJiaShu_Btn01
	PosBtnArray[2] = Item_DunJiaShu_Btn02
	PosBtnArray[3] = Item_DunJiaShu_Btn03
	PosBtnArray[4] = Item_DunJiaShu_Btn04
	PosBtnArray[5] = Item_DunJiaShu_Btn05
	PosBtnArray[6] = Item_DunJiaShu_Btn06
	PosBtnArray[7] = Item_DunJiaShu_Btn07
	PosBtnArray[8] = Item_DunJiaShu_Btn08
	PosBtnArray[9] = Item_DunJiaShu_Btn09
	PosBtnArray[10] = Item_DunJiaShu_Btn10
	
	YeQianBtnArray[1] = Item_DunJiaShu_yeqian01
	YeQianBtnArray[2] = Item_DunJiaShu_yeqian02
	YeQianBtnArray[3] = Item_DunJiaShu_yeqian03

	PosBtnTextArray [1] = string.format("%s(%d,%d)", DefaultScn[1][1], DefaultScn[1][3], DefaultScn[1][4])
	PosBtnTextArray [2] = string.format("%s(%d,%d)", DefaultScn[2][1], DefaultScn[2][3], DefaultScn[2][4])
	PosBtnTextArray [3] = string.format("%s(%d,%d)", DefaultScn[3][1], DefaultScn[3][3], DefaultScn[3][4])
	PosBtnTextArray [4] = string.format("%s(%d,%d)", DefaultScn[4][1], DefaultScn[4][3], DefaultScn[4][4])
	PosBtnTextArray [5] = "#{DJTS_110509_07}"
	PosBtnTextArray [6] = "#{DJTS_110509_07}"
	PosBtnTextArray [7] = "#{DJTS_110509_07}"
	PosBtnTextArray [8] = "#{DJTS_110509_07}"
	PosBtnTextArray [9] = "#{DJTS_110509_07}"
	PosBtnTextArray [10] = "#{DJTS_110509_07}"

end

--===============================================
-- OnEvent()
--===============================================
function Item_DunJiaShu_OnEvent(event)

	if ( event == "UI_COMMAND" ) and tonumber(arg0) == g_SERVER_CONTROL_1 then
		g_Type_Index = tonumber(Get_XParam_INT(0))
		g_Client_ItemIndex = tonumber(Get_XParam_INT(1))
		g_Item_Const = tonumber(Get_XParam_INT(2))
		g_CurSelectPage = tonumber(Get_XParam_INT(3))
		g_SceneLogData = tostring(Get_XParam_STR(0))
		g_SceneNamestring = tostring(Get_XParam_STR(1))
		Get_Scene_NameAndPos()
		if g_Type_Index == 1 then
			Item_DunJiaShu_Show("useDJTS") --使用遁甲天书
			g_Type = "useDJTS"
		elseif g_Type_Index == 2 then
			Item_DunJiaShu_Show("useDJQS")--使用遁甲奇书
			g_Type = "useDJQS"
		else
			Item_DunJiaShu_ShengYu:SetText("#{DJTS_110509_03} "..Get_XParam_INT(2).."/"..g_DJTS_MAX_USETIMES);
		end
	elseif event == "PLAYER_LEAVE_WORLD"  then
		if( this:IsVisible() ) then
			this:Hide()
		end
	elseif event == "SCENE_TRANSED"  then
		if( this:IsVisible() ) then
			this:Hide()
		end
	elseif event == "ON_SCENE_TRANSING"  then
		if( this:IsVisible() ) then
			this:Hide()
		end
	elseif (event == "ADJEST_UI_POS" ) then
		Item_DunJiaShu_Frame_On_ResetPos()

	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		Item_DunJiaShu_Frame_On_ResetPos()
	end
end

function Item_DunJiaShu_PageClick(nPageIdx)
	g_CurSelectPage = nPageIdx
	local nIndex = -1
	for i = 1,45 do
		local theAction = EnumAction(i-1, "packageitem")
		if theAction:GetID() ~= 0 then 
			local nPacketItemID = tonumber(theAction:GetDefineID())
			if nPacketItemID == 30008122 then
				nIndex = i
				break
			end
		end
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("Ce_DifuCs");
		Set_XSCRIPT_ScriptID(330060);
		Set_XSCRIPT_Parameter(0,nIndex)
		Set_XSCRIPT_Parameter(1, 3)
		Set_XSCRIPT_Parameter(2, nPageIdx)
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT();	
	Item_DunJiaShu_Show(g_Type)
end
--===============================================
-- Show()
--===============================================
function Item_DunJiaShu_Show(event)

	for i=1, table.getn(YeQianBtnArray) do
		if g_CurSelectPage == i then
			YeQianBtnArray[i]:SetCheck(1)
		else
			YeQianBtnArray[i]:SetCheck(0)
		end
	end

	if event == "useDJTS"  then
		local Level = 0;
		Level = Player:GetData("LEVEL");
		if Player ~= nil and Player:GetData("LEVEL") < 10 then
			PushDebugMessage("#{GMTripperObj_Resource_Info_Level_Not_Enough}");
			return
		end

		Item_DunJiaShu_Title:SetProperty("Image","set:Menpaishuxing image:DunJiaShu_Title_Index")--遁甲天书
		Item_DunJiaShu_Info:SetText("#{DJTS_110509_02}")		--遁甲天书介绍

		for i=1,table.getn(PosBtnArray) do
			PosBtnArray[i]:SetCheck(0)
			strText = string.format("%s(%d,%d)", DunJiaShu_NameScene[i], DunJiaShu_PosX[i], DunJiaShu_PosZ[i])
			if DunJiaShu_NameScene[i] == "" then
				PosBtnArray[i]:SetText(g_defBtnTextCr..PosBtnTextArray[i])
			else
				PosBtnArray[i]:SetText(g_defBtnTextCr..strText)
 			end

			--第一次使用
			if g_Item_Const ==0 then
				count = g_DJTS_MAX_USETIMES
			else
				count = 20 - g_Item_Const
			end

			Item_DunJiaShu_ShengYu:SetText("#{DJTS_110509_03} "..count.."/"..g_DJTS_MAX_USETIMES);

		end

		if g_CurSelectIndex_DJTS ~= 0 then
			PosBtnArray[g_CurSelectIndex_DJTS]:SetCheck(1)
		end

		-- 添加倒计时
		--Item_DunJiaShu_StopWatch : SetProperty("Timer",tostring(20));
		--Item_DunJiaShu_StopWatch:Show()

		if g_CurSelectIndex_DJTS == 0 then
			Item_DunJiaShu_DingWei:Disable()
	        Item_DunJiaShu_ChuanSong:Disable()
		else
			Item_DunJiaShu_DingWei:Enable()
			Item_DunJiaShu_ChuanSong:Enable()
		end

		this:Show()
	elseif event == "useDJQS"  then
		local Level = 0;
		Level = Player:GetData("LEVEL");
		if Player ~= nil and Player:GetData("LEVEL") < 10 then
			PushDebugMessage("#{GMTripperObj_Resource_Info_Level_Not_Enough}");
			return
		end

		Item_DunJiaShu_Title:SetProperty("Image","set:Menpaishuxing image:DunJiaShu_Title_Monster")--遁甲天书	        --遁甲奇书
		Item_DunJiaShu_Info:SetText("#{DJTS_110509_26}")	        --遁甲奇书介绍
		Item_DunJiaShu_BuChong:Show()

		for i=1,table.getn(PosBtnArray) do
			PosBtnArray[i]:SetCheck(0)
			strText = string.format("%s(%d,%d)", DunJiaShu_NameScene[i], DunJiaShu_PosX[i], DunJiaShu_PosZ[i])
			if DunJiaShu_NameScene[i] == "" then
				if g_CurSelectPage == 1 then
					PosBtnArray[i]:SetText(g_defBtnTextCr..PosBtnTextArray[i])
				else
					PosBtnArray[i]:SetText(g_defBtnTextCr.."#{DJTS_110509_07}")
				end
			else
				PosBtnArray[i]:SetText(g_defBtnTextCr..strText)
			end
			--第一次使用
			if g_Item_Const ==0 then
				count = g_DJTS_MAX_USETIMES
			else
				count = 20 - g_Item_Const
			end

			Item_DunJiaShu_ShengYu:SetText("#{DJTS_110509_03} "..count.."/"..g_DJQS_MAX_USETIMES);

		end

		if g_CurSelectIndex_DJQS ~= 0 then
			PosBtnArray[g_CurSelectIndex_DJQS]:SetCheck(1)
		end

		if g_CurSelectIndex_DJQS == 0 then
			Item_DunJiaShu_DingWei:Disable()
	        Item_DunJiaShu_ChuanSong:Disable()
		else
			Item_DunJiaShu_DingWei:Enable()
	        Item_DunJiaShu_ChuanSong:Enable()
		end

		this:Show()
	else
		return
	end

end

function Item_DunJiaShu_TimeOut()
	this:Hide()
end

--===============================================
-- 补充符咒
--===============================================
function Item_DunJiaShu_BuChong_Clicked()
	if g_Type == "useDJTS"  then
		PushEvent("UI_COMMAND",2015111097,g_Client_ItemIndex,20-g_Item_Const)
	end
	if g_Type == "useDJQS"  then
		PushEvent("UI_COMMAND",2019051211,g_Client_ItemIndex,20-g_Item_Const)
	end
	--this:Hide()
end

--===============================================
-- 定位
--===============================================
function Item_DunJiaShu_DingWei_Clicked()

	if g_Type == "useDJTS"  then
		local nNewSel = (g_CurSelectPage-1)*10 + g_CurSelectIndex_DJTS
		if g_CurSelectIndex_DJTS<=0 then
			return
		end
		if g_CurSelectIndex_DJTS <= table.getn(DefaultScn) then
			PushEvent("UI_COMMAND",2015111099,g_Client_ItemIndex,nNewSel-1,DunJiaShu_NameScene[g_CurSelectIndex_DJTS], DunJiaShu_PosX[g_CurSelectIndex_DJTS], DunJiaShu_PosZ[g_CurSelectIndex_DJTS])
		else
			PushEvent("UI_COMMAND",2015111099,g_Client_ItemIndex,nNewSel-1,DunJiaShu_NameScene[g_CurSelectIndex_DJTS], DunJiaShu_PosX[g_CurSelectIndex_DJTS], DunJiaShu_PosZ[g_CurSelectIndex_DJTS])
		end
	end
	if g_Type == "useDJQS"  then
		local nNewSel = (g_CurSelectPage-1)*10 + g_CurSelectIndex_DJQS
		if g_CurSelectIndex_DJQS <=0 then
			return
		end
		if g_CurSelectIndex_DJQS <= table.getn(DefaultScn) then
			PushEvent("UI_COMMAND",2019051212,g_Client_ItemIndex,nNewSel-1,DunJiaShu_NameScene[g_CurSelectIndex_DJQS], DunJiaShu_PosX[g_CurSelectIndex_DJQS], DunJiaShu_PosZ[g_CurSelectIndex_DJQS])
		else
			PushEvent("UI_COMMAND",2019051212,g_Client_ItemIndex,nNewSel-1,DunJiaShu_NameScene[g_CurSelectIndex_DJQS], DunJiaShu_PosX[g_CurSelectIndex_DJQS], DunJiaShu_PosZ[g_CurSelectIndex_DJQS])
		end
	end
	g_CurSelectIndex_DJTS = 0
	g_CurSelectIndex_DJQS = 0
	this:Hide()

end

--===============================================
-- 传送
--===============================================
function Item_DunJiaShu_ChuanSong_Clicked()

	if g_Item_Const == 20 then
		PushDebugMessage("#{DJTS_110509_51}"); --符咒耗尽，请使用遁地符补充符咒
		this:Hide()
		return
	end

	if g_Type == "useDJTS"  then
		local nNewSel = (g_CurSelectPage-1)*10 + g_CurSelectIndex_DJTS
		if g_CurSelectIndex_DJTS<=0 then
			return
		end
		if g_CurSelectIndex_DJTS <= table.getn(DefaultScn) then
			PushEvent("UI_COMMAND",2015111098,g_Client_ItemIndex,nNewSel-1,DunJiaShu_NameScene[g_CurSelectIndex_DJTS], DunJiaShu_PosX[g_CurSelectIndex_DJTS], DunJiaShu_PosZ[g_CurSelectIndex_DJTS])
		else
			PushEvent("UI_COMMAND",2015111098,g_Client_ItemIndex,nNewSel-1,DunJiaShu_NameScene[g_CurSelectIndex_DJTS], DunJiaShu_PosX[g_CurSelectIndex_DJTS], DunJiaShu_PosZ[g_CurSelectIndex_DJTS])
		end
	end
	if g_Type == "useDJQS"  then
		local nNewSel = (g_CurSelectPage-1)*10 + g_CurSelectIndex_DJQS
		if g_CurSelectIndex_DJQS <=0 then
			return
		end
		if g_CurSelectIndex_DJQS <= table.getn(DefaultScn) then
			PushEvent("UI_COMMAND",2019051213,g_Client_ItemIndex,nNewSel-1,DunJiaShu_NameScene[g_CurSelectIndex_DJQS], DunJiaShu_PosX[g_CurSelectIndex_DJQS], DunJiaShu_PosZ[g_CurSelectIndex_DJQS])
		else
			PushEvent("UI_COMMAND",2019051213,g_Client_ItemIndex,nNewSel-1,DunJiaShu_NameScene[g_CurSelectIndex_DJQS], DunJiaShu_PosX[g_CurSelectIndex_DJQS], DunJiaShu_PosZ[g_CurSelectIndex_DJQS])
		end
	end
	g_CurSelectIndex_DJTS = 0
	g_CurSelectIndex_DJQS = 0
	this:Hide()
end

--===============================================
-- 帮助
--===============================================
function Item_DunJiaShu_Help()

end

function Item_DunJiaShu_Frame_On_ResetPos()
  Item_DunJiaShu_Frame:SetProperty("UnifiedPosition", g_Item_DunJiaShu_Frame_UnifiedPosition);
end

function Item_DunJiaShu_Btn_Clicked(arg)
	if g_Type == "useDJTS"  then
		if g_CurSelectIndex_DJTS>0 then
			PosBtnArray[g_CurSelectIndex_DJTS]:SetCheck(0)
		end
		g_CurSelectIndex_DJTS = arg
		PosBtnArray[g_CurSelectIndex_DJTS]:SetCheck(1)
		Item_DunJiaShu_DingWei:Enable()
		Item_DunJiaShu_ChuanSong:Enable()
	elseif g_Type == "useDJQS"  then
		if g_CurSelectIndex_DJQS>0 then
			PosBtnArray[g_CurSelectIndex_DJQS]:SetCheck(0)
		end
		g_CurSelectIndex_DJQS = arg
		PosBtnArray[g_CurSelectIndex_DJQS]:SetCheck(1)
		Item_DunJiaShu_DingWei:Enable()
        Item_DunJiaShu_ChuanSong:Enable()
	elseif g_Type == "useDJVIP" then
		if g_CurSelectIndex_DJVIP > 0 then
			PosBtnArray[g_CurSelectIndex_DJVIP]:SetCheck(0)
		end
		g_CurSelectIndex_DJVIP = arg
		PosBtnArray[g_CurSelectIndex_DJVIP]:SetCheck(1)
		Item_DunJiaShu_DingWei:Enable()
        Item_DunJiaShu_ChuanSong:Enable()
	end


end

function Item_DunJiaShu_Btn_MouseLeave()

	if g_Type == "useDJTS"  then
		for i=1,table.getn(PosBtnArray) do
			if i==g_CurSelectIndex_DJTS then
				PosBtnArray[i]:SetCheck(1)
			else
				PosBtnArray[i]:SetCheck(0)
			end
		end
	elseif g_Type == "useDJQS"  then
		for i=1,table.getn(PosBtnArray) do
			if i==g_CurSelectIndex_DJQS then
				PosBtnArray[i]:SetCheck(1)
			else
				PosBtnArray[i]:SetCheck(0)
			end
		end
	
	elseif g_Type == "useDJVIP"  then
		for i=1,table.getn(PosBtnArray) do
			if i==g_CurSelectIndex_DJVIP then
				PosBtnArray[i]:SetCheck(1)
			else
				PosBtnArray[i]:SetCheck(0)
			end
		end
	
	end
end
