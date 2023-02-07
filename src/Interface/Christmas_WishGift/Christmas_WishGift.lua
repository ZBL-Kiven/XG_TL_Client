--***********************************************************************************************************************************************
-- 
--***********************************************************************************************************************************************

local g_clientNpcId = -1

local g_Christmas_WishGift_Frame_UnifiedPosition;

--local g_Christmas_WishGift_MyTopRank = -1
--local g_BarList={}

local g_XinYuanPointSt = {10,25,40}
local g_XinYuanPointCtr = {}

local g_XinYuanPrizeABCtr = {}
local g_XinYuanPrizeImgCtr = {}
local g_XinYuanPrizeAniCtr = {}
local g_XinYuanPrizeRPCtr = {}

local g_WishPrize = {30900045,30008048,-1}
local g_WishBigPrize = {10124610,10141337,38000114}

-- OnLoad
--
--************************************************************************************************************************************************
function Christmas_WishGift_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
end

function Christmas_WishGift_OnLoad()
	g_Christmas_WishGift_Frame_UnifiedPosition=Christmas_WishGift_Frame:GetProperty("UnifiedPosition");
	g_XinYuanPointCtr = {
		Christmas_WishGift_WishPoint1,Christmas_WishGift_WishPoint2,Christmas_WishGift_WishPoint3
	}
	g_XinYuanPrizeABCtr = {
		Christmas_WishGift_Item1,Christmas_WishGift_Item2,Christmas_WishGift_Item3
	}
	g_XinYuanPrizeImgCtr = {
		Christmas_WishGift_ItemOK1,Christmas_WishGift_ItemOK2,Christmas_WishGift_ItemOK3
	}
	g_XinYuanPrizeAniCtr = {
		Christmas_WishGift_ItemAnimate1,Christmas_WishGift_ItemAnimate2,Christmas_WishGift_ItemAnimate3
	}
	g_XinYuanPrizeRPCtr = {
		Christmas_WishGift_Item1_Tips,Christmas_WishGift_Item2_Tips,Christmas_WishGift_Item3_Tips
	}
end


--***********************************************************************************************************************************************
--
-- 事件响应函数
--
--
--************************************************************************************************************************************************
function Christmas_WishGift_OnEvent(event)

	if ( event == "UI_COMMAND" and tonumber(arg0) == 88877302 ) then
		local clientNpcId = Get_XParam_INT(0)
		if clientNpcId==-1 then
			this:Hide()
			return
		end

		g_clientNpcId = clientNpcId
		local objId = DataPool : GetNPCIDByServerID(g_clientNpcId)
		if objId == -1 then
			return
		end
		local MDRecord = Get_XParam_INT(1)
		Christmas_WishGift_Update(MDRecord)
		this : CareObject( objId, 1, "Christmas_WishGift" )
		this : Show()

	elseif (event == "ADJEST_UI_POS" ) then
		Christmas_WishGift_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		Christmas_WishGift_Frame_On_ResetPos()
	end
end

function Christmas_WishGift_ItemClicked(nIdx)
--PushDebugMessage("Christmas_WishGift_StartClicked")
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("OnShengDanGetPrize")
		Set_XSCRIPT_ScriptID(888773);
		Set_XSCRIPT_Parameter(0,g_clientNpcId);
		Set_XSCRIPT_Parameter(1,nIdx);
		Set_XSCRIPT_ParamCount(2);
	Send_XSCRIPT();
end

function Christmas_WishGift_Close()
	this:Hide()
end
function Christmas_WishGift_OnHiden()
end

function Christmas_WishGift_Frame_On_ResetPos()
  Christmas_WishGift_Frame:SetProperty("UnifiedPosition", g_Christmas_WishGift_Frame_UnifiedPosition);
end

function Christmas_WishGift_Update(MDRecordData)
--PushDebugMessage("Christmas_WishGift_Update "..MDRecordData)
	local nXYValue = math.floor(MDRecordData/10000)
	local nLeft = math.mod(MDRecordData,10000)
	local nChristmasGiftSel = math.floor(nLeft/1000)
	nLeft = math.mod(MDRecordData,1000)
	local nGetFlag = {}
	nGetFlag[1] = math.mod(nLeft,10)
	nLeft = math.floor(nLeft/10)
	nGetFlag[2] = math.mod(nLeft,10)
	nGetFlag[3] = math.floor(nLeft/10)

	--当前值
	local curpointmsg = ScriptGlobal_Format("#{SDXY_211103_23}",nXYValue)
	Christmas_WishGift_WishPointNum:SetText(curpointmsg)
	for i=1,3 do
		local pointmsg = ScriptGlobal_Format("#{SDXY_211103_24}",g_XinYuanPointSt[i])
		g_XinYuanPointCtr[i]:SetText(pointmsg)
	end

	--奖励
	for i=1,3 do
		local prizeItemId = g_WishPrize[i]
		if i==3 then
			prizeItemId = g_WishBigPrize[nChristmasGiftSel]
		end
		local showAction = DataPool:CreateBindActionItemForShow(prizeItemId, 1)
		if showAction:GetID() ~= 0 then
			g_XinYuanPrizeABCtr[i]:SetActionItem(showAction:GetID())
		end

		--领取标记
		if nGetFlag[i]==1 then
			g_XinYuanPrizeImgCtr[i]:Show()
		else
			g_XinYuanPrizeImgCtr[i]:Hide()
		end

		--可以领但没领
		if i ~= 3 then
			if nXYValue >= g_XinYuanPointSt[i] and nGetFlag[i] == 0 then
				g_XinYuanPrizeAniCtr[i]:Show()
				g_XinYuanPrizeRPCtr[i]:Show()
			else
				g_XinYuanPrizeAniCtr[i]:Hide()
				g_XinYuanPrizeRPCtr[i]:Hide()
			end
		end
	end

	--12.25 20:00之前锁定
	--日期
	if nXYValue >= g_XinYuanPointSt[3] and nGetFlag[3] == 0 then
		local curDay = tonumber(DataPool:GetServerDayTime());
		if curDay > 20211224 and curDay <= 20211231 then
			g_XinYuanPrizeAniCtr[3]:Show()
			g_XinYuanPrizeRPCtr[3]:Show()
		elseif curDay == 20211224 then
			local curTime = tonumber(DataPool:GetServerMinuteTime())
			local curHour = math.floor(curTime/10000)	
			if curHour>=20 then
				g_XinYuanPrizeAniCtr[3]:Show()
				g_XinYuanPrizeRPCtr[3]:Show()
			end
		end
	else
		g_XinYuanPrizeAniCtr[3]:Hide()
		g_XinYuanPrizeRPCtr[3]:Hide()
	end
	
end

function Christmas_WishGift_WishPonitNum_HelpClick()
	PushEvent("QUEST_HELPINFO","#{SDXY_211103_28}")
end

--function Christmas_WishGift_HelpClicked()
--	PushEvent("QUEST_HELPINFO","#{QCD_20210524_09}")
--end
