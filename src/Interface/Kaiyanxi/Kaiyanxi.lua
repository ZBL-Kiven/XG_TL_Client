local g_Frame_UnifiedPosition

local g_objCared = -1

local g_Kaiyanxi_ItemInfo = {
	--川菜
	[1] = {id=38002318, itype=1, cost=3,},
	[2] = {id=38002319, itype=1, cost=3,},
	--鲁菜
	[3] = {id=38002320, itype=2, cost=3,},
	[4] = {id=38002321, itype=2, cost=3,},
	--粤菜
	[5] = {id=38002322, itype=3, cost=3,},
	[6] = {id=38002323, itype=3, cost=3,},	
	--苏菜
	[7] = {id=38002324, itype=4, cost=3,},
	[8] = {id=38002325, itype=4, cost=3,},
	--浙菜
	[9] = {id=38002326, itype=5, cost=3,},
	[10] = {id=38002327, itype=5, cost=3,},	
	--闽菜
	[11] = {id=38002328, itype=6, cost=3,},
	[12] = {id=38002329, itype=6, cost=3,},	
	--湘菜
	[13] = {id=38002330, itype=7, cost=3,},
	[14] = {id=38002331, itype=7, cost=3,},		
	--徽菜
	[15] = {id=38002332, itype=8, cost=3,},
	[16] = {id=38002333, itype=8, cost=3,},	
}

--=========
-- PreLoad()
--=========
function Kaiyanxi_PreLoad()

	this:RegisterEvent("UI_COMMAND",true)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)	--进场景关闭界面
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("OBJECT_CARED_EVENT",false)

end

--=========
-- OnLoad()
--=========
function Kaiyanxi_OnLoad()

	g_Frame_UnifiedPosition = Kaiyanxi_Frame:GetProperty("UnifiedPosition")

end

--=========
-- Event
--=========
function Kaiyanxi_OnEvent(event)

	if event == "UI_COMMAND" and tonumber(arg0) == 89117201 then
			
		Kaiyanxi_OnHiden()
		
        g_objCared = DataPool:GetNPCIDByServerID(Get_XParam_INT(0))
		this:CareObject(g_objCared, 1, "Kaiyanxi");
		Kaiyanxi_UpdateUI()	
		this:Show()

	elseif event == "HIDE_ON_SCENE_TRANSED" then

		Kaiyanxi_OnHiden()

	elseif event == "VIEW_RESOLUTION_CHANGED" then

		Kaiyanxi_ResetPos()

	elseif event == "ADJEST_UI_POS" then

		Kaiyanxi_ResetPos()
		
    elseif ( event == "OBJECT_CARED_EVENT" and this:IsVisible() ) then
		if(tonumber(arg0) ~= g_objCared) then
			return
		end
		-- 如果和NPC的距离大于一定距离或者被删除，自动关闭
        if(arg1 == "distance" and tonumber(arg2)>3 or arg1=="destroy") then
            Kaiyanxi_OnHiden()
        end
		--取消关心
		this:CareObject(g_objCared, 0, "Kaiyanxi");		
	end

end

function Kaiyanxi_UpdateUI()

	Kaiyanxi_List:Clear()
	
	for i=1, table.getn(g_Kaiyanxi_ItemInfo) do
		local bar = Kaiyanxi_List:AddChild("Kaiyanxi_Gift1")
		if not bar then
			break
		end
		bar:GetSubItem("Kaiyanxi_Gift1_ButtonNull"):SetEvent( "Clicked", string.format("Kaiyanxi_DuiHuan_Clicked(%d)", i))
		bar:GetSubItem("Kaiyanxi_Gift1_Item1"):SetEvent( "Clicked", string.format("Kaiyanxi_DuiHuan_Clicked(%d)", i))
		local theAction = DataPool:CreateBindActionItemForShow(g_Kaiyanxi_ItemInfo[i].id,1)
		if theAction:GetID() ~= 0 then
			bar:GetSubItem("Kaiyanxi_Gift1_Item1"):SetActionItem(theAction:GetID())
		end		
		bar:GetSubItem("Kaiyanxi_Gift1_Item1Text"):SetText( DataPool:LuaFnGetItemNameByTableIndex(g_Kaiyanxi_ItemInfo[i].id) )
		--bar:GetSubItem("Kaiyanxi_Gift1_Item2Text"):SetText("")--ScriptGlobal_Format("#{KYX_20210715_74}", g_Kaiyanxi_ItemInfo[i].cost) )		
	end
			
end

function Kaiyanxi_DuiHuan_Clicked(index)

	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("DuiHuan_Confirm");
		Set_XSCRIPT_ScriptID(891176);
		Set_XSCRIPT_Parameter(0,index);
		Set_XSCRIPT_ParamCount(1);
	Send_XSCRIPT();
	
end

function Kaiyanxi_ResetPos()

	Kaiyanxi_Frame:SetProperty("UnifiedPosition", g_Frame_UnifiedPosition)

end

function Kaiyanxi_OnHiden()
	--取消关心
	this:CareObject(g_objCared, 0, "Kaiyanxi");
	g_objCared = -1
	CloseWindow("MessageBox_Self",true);
	this:Hide()
end


