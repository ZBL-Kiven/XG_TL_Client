--������ by yuanpeilong��ÿ���콱

local g_HuaShanLunJian_GetAward3_ActionItem = {}
local g_HuaShanLunJian_GetAward3_HaveGetFlag = {}
local g_HuaShanLunJian_GetAward3_GetPrizeButton = {}
local g_HuaShanLunJian_GetAward3_PrizeItem = {}
local g_HuaShanLunJian_GetAward3_MF = {}

local g_ServerNpc = -1

-- �����Ĭ�����λ��
local g_HuaShanLunJian_GetAward3_UnifiedXPosition
local g_HuaShanLunJian_GetAward3_UnifiedYPosition

local g_HuaShanLunJian_GetAward3_MD
local g_HuaShanLunJian_GetAward3_MF_1
local g_HuaShanLunJian_GetAward3_MF_2
--local g_HuaShanLunJian_GetAward3_MF_3

local g_HuaShanLunJian_GetAward3_RetPoint = {}
local g_HuaShanLunJian_GetAward3_NeedNum = {}

function HuaShanLunJian_GetAward3_PreLoad()
	this:RegisterEvent("UI_COMMAND", true);
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED", false)
	-- ��Ϸ���ڳߴ緢���˱仯
	this:RegisterEvent("ADJEST_UI_POS", false)
	-- ��Ϸ�ֱ��ʷ����˱仯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED", false)	
end

function HuaShanLunJian_GetAward3_OnLoad()
	--this:SetPosAdjustFlag(1)

	g_HuaShanLunJian_GetAward3_ActionItem[1] = HuaShanLunJian_GetAward3_Icon1
	g_HuaShanLunJian_GetAward3_ActionItem[2] = HuaShanLunJian_GetAward3_Icon2
	--g_HuaShanLunJian_GetAward3_ActionItem[3] = HuaShanLunJian_GetAward3_Icon3

	g_HuaShanLunJian_GetAward3_HaveGetFlag[1] = HuaShanLunJian_GetAward3_Icon1Get
	g_HuaShanLunJian_GetAward3_HaveGetFlag[2] = HuaShanLunJian_GetAward3_Icon2Get
	--g_HuaShanLunJian_GetAward3_HaveGetFlag[3] = HuaShanLunJian_GetAward3_Icon3Get
  
	g_HuaShanLunJian_GetAward3_GetPrizeButton[1] = HuaShanLunJian_GetAward3_Pic1Btn
	g_HuaShanLunJian_GetAward3_GetPrizeButton[2] = HuaShanLunJian_GetAward3_Pic2Btn
	--g_HuaShanLunJian_GetAward3_GetPrizeButton[3] = HuaShanLunJian_GetAward3_Pic3Btn
  
	g_HuaShanLunJian_GetAward3_PrizeItem[1] = {id=30505281, num=1} --���
	g_HuaShanLunJian_GetAward3_PrizeItem[2] = {id=38002448, num=1} --���
	--g_HuaShanLunJian_GetAward3_PrizeItem[3] = {id=30008027, num=3} --���
 
	g_HuaShanLunJian_GetAward3_MD = 0
	g_HuaShanLunJian_GetAward3_MF_1 = 0
	g_HuaShanLunJian_GetAward3_MF_2 = 0
	--g_HuaShanLunJian_GetAward3_MF_3 = 0
	
	g_HuaShanLunJian_GetAward3_MF[1] = 0
	g_HuaShanLunJian_GetAward3_MF[2] = 0
	--g_HuaShanLunJian_GetAward3_MF[3] = 0	
	
	g_HuaShanLunJian_GetAward3_RetPoint[1] = HuaShanLunJian_GetAward3_Pic1Btn_Tips
	g_HuaShanLunJian_GetAward3_RetPoint[2] = HuaShanLunJian_GetAward3_Pic2Btn_Tips
	
	g_HuaShanLunJian_GetAward3_NeedNum[1] = 4
	g_HuaShanLunJian_GetAward3_NeedNum[2] = 8
	
	g_HuaShanLunJian_GetAward3_UnifiedXPosition = HuaShanLunJian_GetAward3_Frame : GetProperty("UnifiedXPosition")
	g_HuaShanLunJian_GetAward3_UnifiedYPosition	= HuaShanLunJian_GetAward3_Frame : GetProperty("UnifiedYPosition")
	
	g_ServerNpc = -1
end

-- OnEvent
function HuaShanLunJian_GetAward3_OnEvent(event)
	--
	if ( event == "UI_COMMAND" and tonumber(arg0) == 89289102 ) then --�򿪽���
		HuaShanLunJian_GetAward3_BeginCare( Get_XParam_INT(0) )
		g_HuaShanLunJian_GetAward3_MD = Get_XParam_INT(1)
		g_HuaShanLunJian_GetAward3_MF_1 = Get_XParam_INT(2)
		g_HuaShanLunJian_GetAward3_MF_2 = Get_XParam_INT(3)
		--g_HuaShanLunJian_GetAward3_MF_3 = Get_XParam_INT(4)		
		HuaShanLunJian_GetAward3_Init()
		HuaShanLunJian_GetAward3_Update( )		
		this:Show()
		
	elseif ( event == "HIDE_ON_SCENE_TRANSED" ) then
		HuaShanLunJian_GetAward3_Hide()
	-- ��Ϸ���ڳߴ緢���˱仯
	elseif (event == "ADJEST_UI_POS" ) then
		-- ���½���λ��
		HuaShanLunJian_GetAward3_ResetPos()
	-- ��Ϸ�ֱ��ʷ����˱仯
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		-- ���½���λ��	
		HuaShanLunJian_GetAward3_ResetPos()
	end
end

--=========
--Care Obj
--=========
function HuaShanLunJian_GetAward3_BeginCare( serverObjId )
	g_ServerNpc = serverObjId
	local objCared = DataPool : GetNPCIDByServerID(serverObjId)
	this:CareObject(objCared, 1)
end

function HuaShanLunJian_GetAward3_Init( )
	for i=1, table.getn(g_HuaShanLunJian_GetAward3_HaveGetFlag) do
		g_HuaShanLunJian_GetAward3_HaveGetFlag[i]:Hide()
	end
	
	for i=1, table.getn(g_HuaShanLunJian_GetAward3_GetPrizeButton) do
		g_HuaShanLunJian_GetAward3_GetPrizeButton[i]:SetText("#{HSLJ_190919_283}")
	end
	
	g_HuaShanLunJian_GetAward3_MF[1] = g_HuaShanLunJian_GetAward3_MF_1
	g_HuaShanLunJian_GetAward3_MF[2] = g_HuaShanLunJian_GetAward3_MF_2
	--g_HuaShanLunJian_GetAward3_MF[3] = g_HuaShanLunJian_GetAward3_MF_3

	g_HuaShanLunJian_GetAward3_RetPoint[1]:Hide()
	g_HuaShanLunJian_GetAward3_RetPoint[2]:Hide()
end


function HuaShanLunJian_GetAward3_Update( )

	local nDayTotalCnt = g_HuaShanLunJian_GetAward3_MD
	if nDayTotalCnt == 0 then
		local dayCntText = ScriptGlobal_Format("#{HSLJ_190919_297}", nDayTotalCnt) --��ɫ
		HuaShanLunJian_GetAward3_Text:SetText(dayCntText)
	else
		local dayCntText = ScriptGlobal_Format("#{HSLJ_190919_281}", nDayTotalCnt) --����ɫ
		HuaShanLunJian_GetAward3_Text:SetText(dayCntText)
	end
	
	for i=1, table.getn(g_HuaShanLunJian_GetAward3_ActionItem) do
		local itemId = g_HuaShanLunJian_GetAward3_PrizeItem[i].id
		local itemNum = g_HuaShanLunJian_GetAward3_PrizeItem[i].num
		local theAction = DataPool:CreateBindActionItemForShow(itemId, itemNum)
		if theAction:GetID() ~= 0 then
			g_HuaShanLunJian_GetAward3_ActionItem[i]:SetActionItem(theAction:GetID())
		end
	
		local bGetAward = g_HuaShanLunJian_GetAward3_MF[i]
		if bGetAward >= 1 then
			g_HuaShanLunJian_GetAward3_HaveGetFlag[i]:Show()
			g_HuaShanLunJian_GetAward3_GetPrizeButton[i]:SetText("#{HSLJ_190919_284}")
			g_HuaShanLunJian_GetAward3_GetPrizeButton[i]:Disable()
			g_HuaShanLunJian_GetAward3_RetPoint[i]:Hide()
		else
			g_HuaShanLunJian_GetAward3_GetPrizeButton[i]:Enable()
			if (g_HuaShanLunJian_GetAward3_MD >= g_HuaShanLunJian_GetAward3_NeedNum[i]) then
				g_HuaShanLunJian_GetAward3_RetPoint[i]:Show()
			end
		end
	
	end
	
end


function HuaShanLunJian_GetAward3_GetAward( index )
	if index == nil then
		return
	end

	if index < 1 or index > 2 then
		return
	end

	local level = Player:GetData("LEVEL")
	if level < 60 then
		HuaShanLunJian_GetAward3_Hide()
		PushDebugMessage( "#{HSLJ_190919_195}" )
		return
	end

	local bGetAward = g_HuaShanLunJian_GetAward3_MF[index]
	if bGetAward >= 1 then
		PushDebugMessage( "#{HSLJ_190919_39}" )
		return
	end

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("GiveTestPrize_Day")
		Set_XSCRIPT_ScriptID( 892891 )
		Set_XSCRIPT_Parameter( 0, index-1 )
		Set_XSCRIPT_Parameter( 1,  g_ServerNpc)
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()

end

function HuaShanLunJian_GetAward3_Hide()
	this:Hide()
end

--================================================
-- �ָ������Ĭ�����λ��
--================================================
function HuaShanLunJian_GetAward3_ResetPos()

	HuaShanLunJian_GetAward3_Frame : SetProperty("UnifiedXPosition", g_HuaShanLunJian_GetAward3_UnifiedXPosition);
	HuaShanLunJian_GetAward3_Frame : SetProperty("UnifiedYPosition", g_HuaShanLunJian_GetAward3_UnifiedYPosition);

end
