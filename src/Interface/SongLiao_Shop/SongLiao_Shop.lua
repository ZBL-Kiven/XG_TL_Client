
local g_SongLiao_Shop_Frame_UnifiedPosition

local g_PageItem_Num = 12

local g_UI_Items = {}

local g_UICOMMAND = 89115701

local g_ExeScript = 891157

local g_CurShopID = 0 --1,2,4

local g_ShopInfo = {} --[i] = itemIndex,itemID,itemName,shopID,onceNum,countLimit,countNow,needNum


local g_objCared = -1

local g_objID = -1

local MAX_OBJ_DISTANCE = 3.0

local g_PriceFormat = {
    [1] = {ItemID =38002256,price="������֣�%s",show="�������������%s"},
    [2] = {ItemID =38002257,price="���������%s",show="�������������%s"},
    [4] = {ItemID =38002262,price="����������%s",show="��ǰ����������%s"},
}



function SongLiao_Shop_PreLoad()
    this:RegisterEvent("UI_COMMAND",true)
	this:RegisterEvent("UPDATE_SongLiao_Shop",false)
	this:RegisterEvent("OBJECT_CARED_EVENT",false)
    this:RegisterEvent("PACKAGE_ITEM_CHANGED",false)
	this:RegisterEvent("ADJEST_UI_POS",false)
    this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
    this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
end

function SongLiao_Shop_OnLoad()
    g_SongLiao_Shop_Frame_UnifiedPosition = SongLiao_Shop_Frame:GetProperty("UnifiedPosition")
    g_UI_Items.ItemInfo  = {}
    for i=1,g_PageItem_Num do
        g_UI_Items.ItemInfo[i]={}
        g_UI_Items.ItemInfo[i].actionBtn = _G["SongLiao_Shop_Item"..i]
        g_UI_Items.ItemInfo[i].itemName = _G[string.format("SongLiao_Shop_ItemInfo%d_Text",i )]
        g_UI_Items.ItemInfo[i].itemPrice = _G[string.format("SongLiao_Shop_ItemInfo%d_Price",i )]
        g_UI_Items.ItemInfo[i].quota = _G[string.format("SongLiao_Shop_ItemInfo%d_Quota",i )]
    end
    g_UI_Items.Daibi = SongLiao_Shop_Num_Text
end

--�ع��̵� shopid:1,2,4 ��Ӧ�ŵع�����1,2,4  û��3
local function OpenShop(shopId,daibiNum)
    if shopId < 1 or shopId > 4 or shopId == 3 then
        return 
    end
    -- g_CurShopID = shopId
    g_UI_Items.Daibi:SetText(string.format(g_PriceFormat[shopId].show,daibiNum))
    -- g_ShopInfo = {}--Lua_GetDiGongShop(shopId)
    local cnt = table.getn(g_ShopInfo)
	-- PushDebugMessage(cnt)
    for i = 1, g_PageItem_Num do
        if i <= cnt then
            local itemInfo = g_ShopInfo[i]
            -- if itemInfo.shopID == shopId then
                local itemID = itemInfo.itemIndex
                local itemName = LuaFnGetItemName(itemInfo.itemIndex)
                -- local countLimit = -1
                local needNum = itemInfo.needNum
                local onceNum = itemInfo.onceNum--��Ʒ����
                -- if countLimit == -1 then
                    --������
                    g_UI_Items.ItemInfo[i].quota:Hide()
					if i > 4 then
						-- g_UI_Items.ItemInfo[i].quota:Show()
					end
                    local theAction = GemMelting:UpdateProductAction(itemID)
                    if theAction:GetID() ~= 0 then
                        g_UI_Items.ItemInfo[i].actionBtn:SetActionItem(theAction:GetID())
						if tonumber(onceNum) ~= 0 then
							g_UI_Items.ItemInfo[i].actionBtn:SetProperty("CornerChar",string.format("BotRight %s",onceNum))
							g_UI_Items.ItemInfo[i].actionBtn:Enable()
						else
							g_UI_Items.ItemInfo[i].actionBtn:SetProperty("CornerChar",string.format("BotRight %s",0))
							g_UI_Items.ItemInfo[i].quota:Show()
							g_UI_Items.ItemInfo[i].actionBtn:Disable()
						end
                    end
                -- else
                    -- g_UI_Items.ItemInfo[i].quota:Show()
                    -- local countLeft = countLimit-countNow --ʣ������
                    -- if countLeft < 0 or countLeft > 255 then
                        -- countLeft = 0
                    -- end
                    -- ͼ���Լ�ʣ������
                    -- local theAction = DataPool:CreateBindActionItemForShowWithMaxNum(itemID,onceNum,countLeft)
                    -- if theAction:GetID() ~= 0 then
                        -- g_UI_Items.ItemInfo[i].actionBtn:SetActionItem(theAction:GetID())
                    -- end
                    -- if countLeft == 0 then
                        -- g_UI_Items.ItemInfo[i].actionBtn:SetProperty("Gloom", "true")
                    -- else
                        -- g_UI_Items.ItemInfo[i].actionBtn:SetProperty("Gloom", "False")
                    -- end
                -- end
                --�۸�
                g_UI_Items.ItemInfo[i].itemPrice:SetText(string.format(g_PriceFormat[shopId].price,needNum))
                --��Ʒ��
                g_UI_Items.ItemInfo[i].itemName:SetText(itemName)
            -- end
        else
            --��btn
            g_UI_Items.ItemInfo[i].itemPrice:SetText("")
            g_UI_Items.ItemInfo[i].itemName:SetText("")
            g_UI_Items.ItemInfo[i].quota:Hide()
			g_UI_Items.ItemInfo[i].actionBtn:SetActionItem(-1)
        end
    end
    if nil ~= g_objCared and g_objCared > 0 then
		this:CareObject(g_objCared, 1, "SongLiao_Shop")
    end
    this:Show()

end

function AskOpenShop()
    Clear_XSCRIPT()
    Set_XSCRIPT_ScriptID(g_ExeScript)
    Set_XSCRIPT_Function_Name("OpenShop")
    Set_XSCRIPT_Parameter(0, g_CurShopID)
    Set_XSCRIPT_Parameter(1, g_objID)
    Set_XSCRIPT_ParamCount(2)
    Send_XSCRIPT()
end

-- function CleanShop()
    -- g_CurShopID = 0
    -- for k, v in pairs(g_UI_Items.ItemInfo) do
        -- v.actionBtn:SetActionItem(-1)
    -- end
-- end

function SongLiao_Shop_CloseShop()
    -- CleanShop()
    if nil ~= g_objCared and g_objCared > 0 then
		this:CareObject(g_objCared, 0, "SongLiao_Shop")
    end
    g_objID = -1
    g_objCared= -1
    this:Hide()
end


function SongLiao_Shop_OnEvent(event)
    if event == "UI_COMMAND" and tonumber(arg0) == g_UICOMMAND then
        --�򿪵ع��̵�
		g_ShopInfo = {} --[i] = itemIndex,onceNum,needNum
        local shopId = Get_XParam_INT(0)
        local daibiNum = Get_XParam_INT(1)
        g_objID = Get_XParam_INT(2)
		local ItemID = Split(Get_XParam_STR(0), ",")
		local ItemNUM = Split(Get_XParam_STR(1), ",")
		local NeedNum = Split(Get_XParam_STR(2), ",")
		for i = 1,Get_XParam_INT(3) do
			g_ShopInfo[i] = {itemIndex = tonumber(ItemID[i]) , onceNum = tonumber(ItemNUM[i]) ,needNum = tonumber(NeedNum[i]) }
		end
		-- PushDebugMessage(g_ShopInfo[1].itemIndex)
        g_objCared = DataPool : GetNPCIDByServerID(tonumber(g_objID))
        -- CleanShop()
        OpenShop(shopId,daibiNum)
        OpenWindow("Packet")
    elseif event == "UPDATE_SongLiao_Shop" and this:IsVisible() then
        -- AskOpenShop()
    elseif ( event == "OBJECT_CARED_EVENT" and this:IsVisible() ) then
		if(tonumber(arg0) ~= g_objCared) then
			return
		end
		-- �����NPC�ľ������һ��������߱�ɾ�����Զ��ر�
        if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
            SongLiao_Shop_CloseShop()
        end
    elseif event == "PACKAGE_ITEM_CHANGED"  and this:IsVisible() then
        if (arg0 == nil or -1 == tonumber(arg0)) then
			return
        end
        local changeItem = tonumber(arg0)
        if changeItem == g_PriceFormat[g_CurShopID].itemID then
            -- AskOpenShop()
        end
    end

    if this:IsVisible() then
        if event == "ADJEST_UI_POS" or
			event == "VIEW_RESOLUTION_CHANGED" then
				SongLiao_Shop_ResetPos()
        elseif event == "HIDE_ON_SCENE_TRANSED" then
            this:Hide()
        end
    end
end



function SongLiao_Shop_ItemClicked(index)
    if g_ShopInfo[index] ~= nil then
        Clear_XSCRIPT()
        Set_XSCRIPT_ScriptID(892335)
        Set_XSCRIPT_Function_Name("BuySongLiaoShop")
        Set_XSCRIPT_Parameter(0, g_objID)
        Set_XSCRIPT_Parameter(1, index)
        Set_XSCRIPT_ParamCount(2)
        Send_XSCRIPT()
    end
end

function SongLiao_Shop_ResetPos()
    SongLiao_Shop_Frame:SetProperty("UnifiedPosition", g_SongLiao_Shop_Frame_UnifiedPosition)
end