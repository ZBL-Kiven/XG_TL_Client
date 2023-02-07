--***********************************************************************************************************************************************
-- 累积奖励领取
--***********************************************************************************************************************************************

local g_clientNpcId = -1

local g_SpringFestival_Dedusting_Frame_UnifiedPosition;

local g_CW_PrizeList = {
38002479,38002480,38000127,38002481
}
local g_PrizeItemCtrl = {}
local g_PrizeTextCtrl = {}
local g_PrizeButtonImgCtrl = {}
local g_PrizeButtonCtrl={}

local g_PrizeCountStd = {2,4,5,7}

-- OnLoad
--
--************************************************************************************************************************************************
function SpringFestival_Dedusting_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
end

function SpringFestival_Dedusting_OnLoad()
	g_SpringFestival_Dedusting_Frame_UnifiedPosition=SpringFestival_Dedusting_Frame:GetProperty("UnifiedPosition");
	g_PrizeItemCtrl = {
		SpringFestival_Dedusting_GiftT1_Icon,SpringFestival_Dedusting_GiftT2_Icon,SpringFestival_Dedusting_GiftT3_Icon,SpringFestival_Dedusting_GiftT4_Icon
	}
	g_PrizeTextCtrl = {
		SpringFestival_Dedusting_GiftT1_Text,SpringFestival_Dedusting_GiftT2_Text,SpringFestival_Dedusting_GiftT3_Text,SpringFestival_Dedusting_GiftT4_Text
	}
	g_PrizeButtonImgCtrl = {
		SpringFestival_Dedusting_Received1,SpringFestival_Dedusting_Received2,SpringFestival_Dedusting_Received3,SpringFestival_Dedusting_Received4
	}
	g_PrizeButtonCtrl = {
		SpringFestival_Dedusting_GiftGet1,SpringFestival_Dedusting_GiftGet2,SpringFestival_Dedusting_GiftGet3,SpringFestival_Dedusting_GiftGet4
	}
end


--***********************************************************************************************************************************************
--
-- 事件响应函数
--
--
--************************************************************************************************************************************************
function SpringFestival_Dedusting_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == 88877801 ) then
		local clientNpcId = Get_XParam_INT(0)
		if clientNpcId==-1 then
			this:Hide()
			return
		end
		if clientNpcId==-2 then
			SpringFestival_Dedusting_UpdateButton(Get_XParam_INT(1),Get_XParam_INT(2))
		else
			g_clientNpcId = clientNpcId
			local objId = DataPool : GetNPCIDByServerID(g_clientNpcId)
			if objId == -1 then
				return
			end
			SpringFestival_Dedusting_Update(Get_XParam_INT(1),Get_XParam_INT(2))
			this : CareObject( objId, 1, "SpringFestival_Dedusting" )
			this : Show()
		end

	elseif (event == "ADJEST_UI_POS" ) then
		SpringFestival_Dedusting_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		SpringFestival_Dedusting_Frame_On_ResetPos()
	end
end

function SpringFestival_Dedusting_Confirm(nIndex)
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("OnGetCleanPrize")
		Set_XSCRIPT_ScriptID(888778);
		Set_XSCRIPT_Parameter(0,g_clientNpcId);
		Set_XSCRIPT_Parameter(1,nIndex);
		Set_XSCRIPT_ParamCount(2);
	Send_XSCRIPT();
end

function SpringFestival_Dedusting_OnClose()
	this:Hide()
end


function SpringFestival_Dedusting_Frame_On_ResetPos()
  SpringFestival_Dedusting_Frame:SetProperty("UnifiedPosition", g_SpringFestival_Dedusting_Frame_UnifiedPosition);
end

function SpringFestival_Dedusting_Update(nCount,awardFlagList)
	local tipMsg = ScriptGlobal_Format("#{CCYXN_20211202_33}",nCount)
	SpringFestival_Dedusting_Info2:SetText(tipMsg)
	local awardFlag={}
	awardFlag[1]=math.mod(awardFlagList,10)
	awardFlagList=math.floor(awardFlagList/10)
	awardFlag[2]=math.mod(awardFlagList,10)
	awardFlagList=math.floor(awardFlagList/10)
	awardFlag[3]=math.mod(awardFlagList,10)
	awardFlag[4]=math.floor(awardFlagList/10)

	for i=1,4 do
		local showAction = DataPool:CreateBindActionItemForShow(g_CW_PrizeList[i], 1)
		if showAction:GetID() ~= 0 then
			g_PrizeItemCtrl[i]:SetActionItem(showAction:GetID())
		end
		g_PrizeTextCtrl[i]:SetText( ScriptGlobal_Format("#{CCYXN_20211202_34}",g_PrizeCountStd[i]) )
		if awardFlag[i]>0 then
			g_PrizeButtonImgCtrl[i]:Show()
			g_PrizeButtonCtrl[i]:Hide()
		else
			g_PrizeButtonImgCtrl[i]:Hide()
			g_PrizeButtonCtrl[i]:Show()
			if nCount>=g_PrizeCountStd[i] then
				g_PrizeButtonCtrl[i]:SetToolTip("#{CCYXN_20211202_37}")
			else
				g_PrizeButtonCtrl[i]:SetToolTip( ScriptGlobal_Format("#{CCYXN_20211202_36}",g_PrizeCountStd[i]) )
			end
		end
	end
end

function SpringFestival_Dedusting_UpdateButton(nIdx,nFlag)
	if nFlag>0 then
		g_PrizeButtonImgCtrl[nIdx]:Show()
		g_PrizeButtonCtrl[nIdx]:Hide()
	else
		g_PrizeButtonImgCtrl[nIdx]:Hide()
		g_PrizeButtonCtrl[nIdx]:Show()
		if nCount>=g_PrizeCountStd[nIdx] then
			g_PrizeButtonCtrl[nIdx]:SetToolTip("#{CCYXN_20211202_37}")
		else
			g_PrizeButtonCtrl[nIdx]:SetToolTip( ScriptGlobal_Format("#{CCYXN_20211202_36}",g_PrizeCountStd[nIdx]) )
		end
	end
end

function SpringFestival_Dedusting_OnHiden()
end
--function SpringFestival_Dedusting_HelpClicked()
--	PushEvent("QUEST_HELPINFO","#{QCD_20210524_09}")
--end

