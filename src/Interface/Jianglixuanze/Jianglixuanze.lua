local g_Frame_UnifiedPosition

local g_objid = -1
local g_objCared = -1
local g_Jianglixuanze_total = -1

local g_Jianglixuanze_MF = {} --是否已经领奖
local g_Jianglixuanze_Button = {} --奖励礼包控件
local g_Jianglixuanze_Impact = {} --提示需要领奖的特效
local g_Jianglixuanze_Finish = {} --完成领奖的图标
local g_Jianglixuanze_NewButton = {}

local g_Jianglixuanze_ItemInfo = {

	[1] = {id=38002334, cost=3,},
	[2] = {id=38002335, cost=8,},
	[3] = {id=38002336, cost=14,},
	
}

--=========
-- PreLoad()
--=========
function Jianglixuanze_PreLoad()

	this:RegisterEvent("UI_COMMAND",true)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)	--进场景关闭界面
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("OBJECT_CARED_EVENT",false)

end

--=========
-- OnLoad()
--=========
function Jianglixuanze_OnLoad()

	g_Frame_UnifiedPosition = Jianglixuanze_Frame:GetProperty("UnifiedPosition")
	
	g_objid = -1
	g_objCared = -1
	g_Jianglixuanze_total = -1
	g_Jianglixuanze_MF1 = -1
	g_Jianglixuanze_MF2 = -1
	g_Jianglixuanze_MF3 = -1
	
	g_Jianglixuanze_MF[1] = -1
	g_Jianglixuanze_MF[2] = -1
	g_Jianglixuanze_MF[3] = -1
	
	g_Jianglixuanze_Button[1] = Jianglixuanze_Item1
	g_Jianglixuanze_Button[2] = Jianglixuanze_Item2
	g_Jianglixuanze_Button[3] = Jianglixuanze_Item3
	
	g_Jianglixuanze_Impact[1] = Jianglixuanze_ItemAnimate1
	g_Jianglixuanze_Impact[2] = Jianglixuanze_ItemAnimate2
	g_Jianglixuanze_Impact[3] = Jianglixuanze_ItemAnimate3
	
	g_Jianglixuanze_Finish[1] = Jianglixuanze_ItemOK1
	g_Jianglixuanze_Finish[2] = Jianglixuanze_ItemOK2
	g_Jianglixuanze_Finish[3] = Jianglixuanze_ItemOK3
	
	g_Jianglixuanze_NewButton[1] = Jianglilingqu_OK1
	g_Jianglixuanze_NewButton[2] = Jianglilingqu_OK2
	g_Jianglixuanze_NewButton[3] = Jianglilingqu_OK3
	
end

--=========
-- Event
--=========
function Jianglixuanze_OnEvent(event)

	if event == "UI_COMMAND" and tonumber(arg0) == 89117202 then
			
		Jianglixuanze_OnHiden()
		
		g_objid = Get_XParam_INT(0)
        g_objCared = DataPool:GetNPCIDByServerID(g_objid)
		this:CareObject(g_objCared, 1, "Jianglixuanze");
		g_Jianglixuanze_total = Get_XParam_INT(1)
		g_Jianglixuanze_MF[1] = Get_XParam_INT(2)
		g_Jianglixuanze_MF[2] = Get_XParam_INT(3)
		g_Jianglixuanze_MF[3] = Get_XParam_INT(4)
		
		Jianglixuanze_UpdateUI()	
		this:Show()

	elseif event == "HIDE_ON_SCENE_TRANSED" then

		Jianglixuanze_OnHiden()

	elseif event == "VIEW_RESOLUTION_CHANGED" then

		Jianglixuanze_ResetPos()

	elseif event == "ADJEST_UI_POS" then

		Jianglixuanze_ResetPos()
		
    elseif ( event == "OBJECT_CARED_EVENT" and this:IsVisible() ) then
		if(tonumber(arg0) ~= g_objCared) then
			return
		end
		-- 如果和NPC的距离大于一定距离或者被删除，自动关闭
        if(arg1 == "distance" and tonumber(arg2)>3 or arg1=="destroy") then
            Jianglixuanze_OnHiden()
        end
		--取消关心
		this:CareObject(g_objCared, 0, "Jianglixuanze");		
	end

end

function Jianglixuanze_UpdateUI()
	
	for i=1, table.getn(g_Jianglixuanze_ItemInfo) do
		if (g_Jianglixuanze_MF[i] ~= 1) then
			if (g_Jianglixuanze_total >= g_Jianglixuanze_ItemInfo[i].cost) then
				--达到领奖条件：是
				g_Jianglixuanze_Impact[i]:Play(true)
				g_Jianglixuanze_Finish[i]:Hide()				
				g_Jianglixuanze_Button[i]:Enable()
				g_Jianglixuanze_NewButton[i]:Enable()
				g_Jianglixuanze_NewButton[i]:SetText("#{KYX_20210715_42}")
				g_Jianglixuanze_NewButton[i]:SetToolTip("#{KYX_20210715_20}")				
			else
				--达到领奖条件：否
				g_Jianglixuanze_Impact[i]:Play(false)
				g_Jianglixuanze_Finish[i]:Hide()				
				g_Jianglixuanze_Button[i]:Enable()	
				g_Jianglixuanze_NewButton[i]:Enable()
				g_Jianglixuanze_NewButton[i]:SetText("#{KYX_20210715_42}")
				g_Jianglixuanze_NewButton[i]:SetToolTip(ScriptGlobal_Format("#{KYX_20210715_19}",g_Jianglixuanze_ItemInfo[i].cost))
			end
		else
			--已领奖
			g_Jianglixuanze_Impact[i]:Play(false)
			g_Jianglixuanze_Finish[i]:Show()				
			g_Jianglixuanze_Button[i]:Disable()	
			g_Jianglixuanze_NewButton[i]:Disable()
			g_Jianglixuanze_NewButton[i]:SetText("#{KYX_20210715_94}")
			g_Jianglixuanze_NewButton[i]:SetToolTip("#{KYX_20210715_21}")
		end
	end
	
	local str = ScriptGlobal_Format("#{KYX_20210715_17}", g_Jianglixuanze_total)
	Jianglixuanze_Info:SetText(str)
	
	-- str = ScriptGlobal_Format("#{KYX_20210715_18}", 3)
	-- Jianglixuanze_Info1:SetText(str)
	
	-- str = ScriptGlobal_Format("#{KYX_20210715_18}", 8)
	-- Jianglixuanze_Info2:SetText(str)	
	
	-- str = ScriptGlobal_Format("#{KYX_20210715_18}", 14)
	-- Jianglixuanze_Info3:SetText(str)	
	
	--显示一下奖励
	for i=1, table.getn(g_Jianglixuanze_Button) do
		g_Jianglixuanze_Button[i]:SetActionItem( -1 );
	end	
	
	for i=1, table.getn(g_Jianglixuanze_ItemInfo) do
		local theAction = DataPool:CreateBindActionItemForShow(g_Jianglixuanze_ItemInfo[i].id,1)
		if theAction:GetID() ~= 0 then
			g_Jianglixuanze_Button[i]:SetActionItem(theAction:GetID())
		else
			g_Jianglixuanze_Button[i]:SetActionItem( -1 );
		end	
	end
			
end

function Jianglixuanze_Clicked(index)

	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GetPrizeClicked");
		Set_XSCRIPT_ScriptID(891172);
		Set_XSCRIPT_Parameter(0,g_objid);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_ParamCount(2);
	Send_XSCRIPT();
	
end

function Jianglixuanze_ResetPos()

	Jianglixuanze_Frame:SetProperty("UnifiedPosition", g_Frame_UnifiedPosition)

end

function Jianglixuanze_OnHiden()
	--取消关心
	this:CareObject(g_objCared, 0, "Jianglixuanze");
	g_objid = -1
	g_objCared = -1
	g_Jianglixuanze_total = -1
	this:Hide()
end


