local g_QingQiu_Shop_Frame_UnifiedXPosition;
local g_QingQiu_Shop_Frame_UnifiedYPosition;  

local g_QingQiu_Curpage = 1
local g_QingQiu_TotalPage= 0
local g_QingQiu_PerPage =12
local g_QingQiu_itemctl = {}
local g_QingQiu_Type = 1
local g_QingQiu_DaiBi= 0
local g_QingQiu_TargetID = 0
local g_QingQiu_NpcId=0
local g_QingQiuDirectly = 0
local g_QingQiu_Title = {
    [1] = "#{QQSD_220801_15}",
    [2] = "#{QQSD_220801_21}",
}
local g_QingQiu_Money = {
    [1] = "#cfff263持有青丘灵叶：%s",
    [2] = "#cfff263持有青丘新叶：%s",
}
local QingQiuShopTable = {
[1] = {{itemid = 38002520,itemnum = 1,daibinum = 5},{itemid = 38002521,itemnum = 1,daibinum = 5},{itemid = 38002522,itemnum = 1,daibinum = 5},{itemid = 38002523,itemnum = 1,daibinum = 5},{itemid = 38002524,itemnum = 1,daibinum = 5},{itemid = 38002515,itemnum = 1,daibinum = 8},{itemid = 38002516,itemnum = 1,daibinum = 8},{itemid = 38002517,itemnum = 1,daibinum = 8},{itemid = 38002518,itemnum = 1,daibinum = 8},{itemid = 38002519,itemnum = 1,daibinum = 8}},
[2] = {{itemid = 38002520,itemnum = 1,daibinum = 6},{itemid = 38002521,itemnum = 1,daibinum = 6},{itemid = 38002522,itemnum = 1,daibinum = 6},{itemid = 38002523,itemnum = 1,daibinum = 6},{itemid = 38002524,itemnum = 1,daibinum = 6},{itemid = 38002515,itemnum = 1,daibinum = 23},{itemid = 38002516,itemnum = 1,daibinum = 23},{itemid = 38002517,itemnum = 1,daibinum = 23},{itemid = 38002518,itemnum = 1,daibinum = 23},{itemid = 38002519,itemnum = 1,daibinum = 23}},
}
function QingQiu_Shop_PreLoad()
	this:RegisterEvent("UI_COMMAND");
		-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED") 
	this:RegisterEvent("OBJECT_CARED_EVENT") 
	this:RegisterEvent("UPDATE_DOUBLE_EXP") 
end

function QingQiu_Shop_OnEvent(event) 
	if( event == "ADJEST_UI_POS" ) then
		QingQiu_Shop_ResetPos()
	elseif( event == "VIEW_RESOLUTION_CHANGED" ) then
		QingQiu_Shop_ResetPos()
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		QingQiu_Shop_Close()    
	elseif event == "PLAYER_LEAVE_WORLD" then
		QingQiu_Shop_Close()
    elseif ( event == "UI_COMMAND" and tonumber( arg0 ) == 89306001 ) then	        	  
        if ( IsWindowShow( "QingQiu_Shop" ) == true ) then 
            QingQiu_Shop_Close()    
        end 
        g_QingQiu_TargetID = Get_XParam_INT( 0 );
        g_QingQiu_Type     = Get_XParam_INT( 1 );
        g_QingQiu_DaiBi    = Get_XParam_INT( 2 );
        QingQiu_Shop_OnShown()  
		g_QingQiu_NpcId = DataPool : GetNPCIDByServerID(g_QingQiu_TargetID)
		if g_QingQiu_NpcId == -1 then
			QingQiu_Shop_Close()
			return
		end
        this : CareObject( g_QingQiu_NpcId, 1, "QingQiu_Shop" )
    elseif ( event == "UI_COMMAND" and tonumber( arg0 ) == 89306002 ) then	        	  
        if ( IsWindowShow( "QingQiu_Shop" ) == false ) then 
            return
        end 
        local daibinum = Get_XParam_INT( 0 );
        QingQiu_Shop_Total_Text:SetText(string.format(g_QingQiu_Money[g_QingQiu_Type], daibinum))
    elseif (event == "OBJECT_CARED_EVENT") then
		if(tonumber(arg0) ~= g_QingQiu_NpcId) then
			return;
		end
		
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if arg1 == "distance" and tonumber(arg2) > MAX_OBJ_DISTANCE or arg1=="destroy" then
			QingQiu_Shop_Close()
		end
	end
end

function QingQiu_Shop_OnLoad()  
	-- 保存界面的默认相对位置
	g_QingQiu_Shop_Frame_UnifiedXPosition	= QingQiu_Shop_Frame:GetProperty("UnifiedXPosition");
    g_QingQiu_Shop_Frame_UnifiedYPosition	= QingQiu_Shop_Frame:GetProperty("UnifiedYPosition");  
    for i = 1, g_QingQiu_PerPage do
        g_QingQiu_itemctl[i] = {}
        g_QingQiu_itemctl[i].act  = _G["QingQiu_Shop_Item"..i]
        g_QingQiu_itemctl[i].name = _G[string.format("QingQiu_Shop_ItemInfo%d_Text",i)] 
        g_QingQiu_itemctl[i].money= _G[string.format("QingQiu_Shop_ItemInfo%d_GB",i)]  
    end 
end 

function QingQiu_Shop_OnShown()
    
    for i = 1, table.getn(g_QingQiu_itemctl) do
        g_QingQiu_itemctl[i].name:SetText("") 
        g_QingQiu_itemctl[i].money:SetText("")
        g_QingQiu_itemctl[i].act:SetActionItem(-1)
    end

    QingQiu_Shop_Text:SetText(g_QingQiu_Title[g_QingQiu_Type])
    QingQiu_Shop_Total_Text:SetText(string.format(g_QingQiu_Money[g_QingQiu_Type], g_QingQiu_DaiBi)) 
    
    if g_QingQiu_Type == 1 then
        if g_QingQiuDirectly >= 1 then
            QingQiu_Shop_querengoumai:SetCheck(0)
        else
            QingQiu_Shop_querengoumai:SetCheck(1)
        end
    else
        if g_QingQiuDirectly >= 1 then
            QingQiu_Shop_querengoumai:SetCheck(0)
        else
            QingQiu_Shop_querengoumai:SetCheck(1)
        end
    end

    for i = 1, table.getn(QingQiuShopTable[g_QingQiu_Type]) do
        local itemname = LuaFnGetItemNameByTableIndex(QingQiuShopTable[g_QingQiu_Type][i].itemid)
        g_QingQiu_itemctl[i].name:SetText(itemname) 
        if g_QingQiu_Type == 1 then 
            g_QingQiu_itemctl[i].money:SetText(string.format("#cfff263青丘灵叶：%s",QingQiuShopTable[g_QingQiu_Type][i].daibinum) )
        else
            g_QingQiu_itemctl[i].money:SetText(string.format("#cfff263青丘新叶：%s",QingQiuShopTable[g_QingQiu_Type][i].daibinum) )
        end
        local id = QingQiuShopTable[g_QingQiu_Type][i].itemid
        local theAction = GemCarve:UpdateProductAction(id)
	    if theAction:GetID() ~= 0 then
	    	g_QingQiu_itemctl[i].act:SetActionItem(theAction:GetID())
        end        
    end

    if g_QingQiu_Curpage == 1 then
        QingQiu_Shop_UpPage:Disable()
    else
        QingQiu_Shop_UpPage:Enable()
    end
    
    if g_QingQiu_Curpage*g_QingQiu_PerPage >= GetQingQiuShopTotalCount(g_QingQiu_Type) then
        QingQiu_Shop_DownPage:Disable()
    else
        QingQiu_Shop_DownPage:Enable()
    end

    local npagecount = 0
    if GetQingQiuShopTotalCount(g_QingQiu_Type) <= g_QingQiu_PerPage then
        npagecount = 1
    elseif math.mod(GetQingQiuShopTotalCount(g_QingQiu_Type), g_QingQiu_PerPage) == 0  then
        npagecount = math.floor(GetQingQiuShopTotalCount(g_QingQiu_Type)/g_QingQiu_PerPage)
    else
        npagecount = math.floor(GetQingQiuShopTotalCount(g_QingQiu_Type)/g_QingQiu_PerPage) + 1
    end
    QingQiu_Shop_CurrentlyPage:SetText( string.format("#cfff263%s/%s",g_QingQiu_Curpage, npagecount) )

	this:Show();
end 

--================================================
-- 界面的默认相对位置
--================================================
function QingQiu_Shop_ResetPos()
	QingQiu_Shop_Frame:SetProperty("UnifiedXPosition", g_QingQiu_Shop_Frame_UnifiedXPosition);
	QingQiu_Shop_Frame:SetProperty("UnifiedYPosition", g_QingQiu_Shop_Frame_UnifiedYPosition); 
end 

function QingQiu_Shop_Close() 
    g_QingQiu_Curpage = 1
	this:Hide();
end
 

function QingQiu_Shop_Btn_Clicked(index)  
    
    if QingQiuShopTable[g_QingQiu_Type][index] == nil or QingQiuShopTable[g_QingQiu_Type][index].itemid <= 0 then
        return
    end

    local isconfirm = QingQiu_Shop_querengoumai:GetCheck()
    if isconfirm == 0 then
        Clear_XSCRIPT()
            Set_XSCRIPT_Function_Name("buyitem")
            Set_XSCRIPT_ScriptID( 893060 )
            Set_XSCRIPT_Parameter( 0, g_QingQiu_TargetID ); 
            Set_XSCRIPT_Parameter( 1, g_QingQiu_Type ); 
            Set_XSCRIPT_Parameter( 2, index); 
            Set_XSCRIPT_ParamCount( 3 ); 
        Send_XSCRIPT() 
    else
        PushEvent("UI_COMMAND",89306003,QingQiuShopTable[g_QingQiu_Type][index].itemid, QingQiuShopTable[g_QingQiu_Type][index].daibinum, g_QingQiu_TargetID, g_QingQiu_Type,index)
    end
end

function QingQiu_Shop_PageDown()
    if g_QingQiu_Curpage*g_QingQiu_PerPage < GetQingQiuShopTotalCount(g_QingQiu_Type) then
        g_QingQiu_Curpage = g_QingQiu_Curpage + 1
        QingQiu_Shop_OnShown()
    end
end


function QingQiu_Shop_PageUp()
    if g_QingQiu_Curpage > 1 then
        g_QingQiu_Curpage = g_QingQiu_Curpage - 1
        QingQiu_Shop_OnShown()
    end
end

function QingQiu_Shop_Help_Click()
    if g_QingQiu_Type == 1 then
        PushEvent("UI_COMMAND",89306004, 8)
    else
        PushEvent("UI_COMMAND",89306004, 9)        
    end
end

function QingQiu_Shop_querengoumai_Clicked() 
    if g_QingQiu_Type == 1 then
		if g_QingQiuDirectly == 0 then
			QingQiu_Shop_querengoumai:SetCheck(0);
			g_QingQiuDirectly = 1
		else
			QingQiu_Shop_querengoumai:SetCheck(1);
			g_QingQiuDirectly = 0
		end
    else
		if g_QingQiuDirectly == 0 then
			QingQiu_Shop_querengoumai:SetCheck(0);
			g_QingQiuDirectly = 1
		else
			QingQiu_Shop_querengoumai:SetCheck(1);
			g_QingQiuDirectly = 0
		end
    end

end
--不改变官方翻页机制
function GetQingQiuShopTotalCount(Type)
	local QingQiuShopTotalTable = {
	[1] = {38002520,38002521,38002522,38002523,38002524,38002515,38002516,38002517,38002518,38002519},
	[2] = {38002520,38002521,38002522,38002523,38002524,38002515,38002516,38002517,38002518,38002519},
	}
	if QingQiuShopTotalTable[Type] ~= nil then
		return table.getn(QingQiuShopTotalTable[Type])
	end
end