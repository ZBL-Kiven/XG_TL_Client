--SpringFesival_Shop
local g_SpringFestival_Shop_Frame_UnifiedPosition = nil 
local g_SpringFestival_Shop_List = {}
local g_SpringFestival_Shop_ObjId = -1
function SpringFestival_Shop_PreLoad()
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("OPEN_FESTIVAL_SHOP")
	this:RegisterEvent("MD_FESTIVAL_SHOP_TOKEN",false)
end


function SpringFestival_Shop_OnLoad()
	g_SpringFestival_Shop_Frame_UnifiedPosition = SpringFestival_Shop_Frame:GetProperty("UnifiedPosition");

	for i=1,12 do
		local action = _G["SpringFestival_Shop_Item"..i]
		local name  = _G["SpringFestival_Shop_ItemInfo"..i.."_Text"]
		local price = _G["SpringFestival_Shop_ItemInfo"..i.."_Price"]
		local icon = _G["SpringFestival_Shop_ItemInfo"..i.."_DaibiIcon"]

		g_SpringFestival_Shop_List[i] = { action = action, name = name,price = price, icon = icon}

	end

end

function SpringFestival_Shop_OnEvent(event)
	if(event == "ADJEST_UI_POS") then
		SpringFestival_Shop_On_ResetPos()
	elseif(event == "VIEW_RESOLUTION_CHANGED") then
		SpringFestival_Shop_On_ResetPos()
	elseif event == "OPEN_FESTIVAL_SHOP" then
		local targetobjId = tonumber(arg0);
		g_SpringFestival_Shop_ObjId = targetobjId
		SpringFestival_Shop_BeginCareObject(targetobjId)
		SpringFestival_Shop_Init()
		this:Show()
		OpenWindow("Packet")
	elseif event == "MD_FESTIVAL_SHOP_TOKEN" then
		local nCount = DataPool:GetPlayerMission_DataRound(676)
		SpringFestival_Shop_MoneyInfo_Text:SetText(ScriptGlobal_Format("#{CJDB_211122_4}",nCount));
	end
end

function SpringFestival_Shop_On_ResetPos()
	SpringFestival_Shop_Frame:SetProperty("UnifiedPosition", g_SpringFestival_Shop_Frame_UnifiedPosition)
end

function SpringFestival_Shop_BeginCareObject(objid)
	local nID = DataPool : GetNPCIDByServerID( objid )
	this:CareObject(nID, 1, "SpringFestival_Shop");
end


function SpringFestival_Shop_Clean(index)
	g_SpringFestival_Shop_List[index].action:SetActionItem(-1)
	g_SpringFestival_Shop_List[index].name:SetText("")
	g_SpringFestival_Shop_List[index].price:SetText("")
	g_SpringFestival_Shop_List[index].icon:Hide()
end

function SpringFestival_Shop_Init()

	local mydata = DataPool:Lua_GetFestivalShopData()
	
	local bConfirm = Variable:GetVariable("FestivalShopConfirm")
	if bConfirm == nil then
		Variable:SetVariable("FestivalShopConfirm","1",0)
		bConfirm = 1
	end

	local mark = tonumber(bConfirm)

	if mark == 1 then
		SpringFestival_Shop_DuihuanCheck:SetCheck(1)
	else
		SpringFestival_Shop_DuihuanCheck:SetCheck(0)
	end

	for i =1,12 do 
		SpringFestival_Shop_Clean(i)
		iteminfo = DataPool:TBSearch_Index_EQU("DBC_FESTIVAL_SHOP_ITEM",i)
		if iteminfo then
			local theAction;
			local bDisable = 0;
			if iteminfo.nLimit > 0 then
				local num = iteminfo.nLimit - mydata.m_limitList[i]
				if num < 0 then
					num = 0
				end
				theAction = DataPool:CreateBindActionItemForShowWithMaxNum(iteminfo.nItemID, 1,num)
			else
				theAction = DataPool:CreateBindActionItemForShow(iteminfo.nItemID, 1)
			end
			
			local name =  DataPool:LuaFnGetItemNameByTableIndex(iteminfo.nItemID)

			g_SpringFestival_Shop_List[i].action:SetActionItem(theAction:GetID())
			-- if bDisable == 1 then
			-- 	g_SpringFestival_Shop_List[i].action:Disable()
			-- end
			g_SpringFestival_Shop_List[i].name:SetText(name)
			g_SpringFestival_Shop_List[i].price:SetText(iteminfo.nPrice)
			g_SpringFestival_Shop_List[i].icon:Show()
		end
	end

	SpringFestival_Shop_MoneyInfo_Text:SetText(ScriptGlobal_Format("#{CJDB_211122_4}",mydata.m_Token));
	
end

function SpringFestival_Shop_Act_Clicked(index)

	if SpringFestival_Shop_DuihuanCheck:GetCheck() == 1 then
		Player:Lua_AskBuyFestivalShopItem(index,0,g_SpringFestival_Shop_ObjId)
		--开了购买确认
	else
		Player:Lua_AskBuyFestivalShopItem(index,1,g_SpringFestival_Shop_ObjId)
	end
	

end

function SpringFestival_Shop_Duihuan_SetCheck()
	Variable:SetVariable("FestivalShopConfirm",tostring(SpringFestival_Shop_DuihuanCheck:GetCheck()),0)
end