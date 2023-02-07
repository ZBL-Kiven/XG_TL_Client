--征友玩家留言 dengxx

-- 修改广告语按钮的两种状态“发布”，“更改”
local ZY_ADAPPLY	=0  
local ZY_ADEDIT   =1  
local zy_AdState	= ZY_ADAPPLY

local zy_lastSendMsgTime = 0
local zy_sendMsgCD = 5  --发送留言冷却时间 5秒
--===============================================
-- PreLoad()
--===============================================
function ZhengyouMessage_PreLoad()

	this:RegisterEvent("ZHENGYOU_MESSAGE_OPEN")
	this:RegisterEvent("ZHENGYOU_MESSAGE_CLOSE")
	this:RegisterEvent("CLOSE_WINDOW")
	
end
--===============================================
-- OnLoad()
--===============================================
function ZhengyouMessage_OnLoad()
end

--===============================================
-- OnEvent()
--===============================================
function ZhengyouMessage_OnEvent(event)

	if(event == "ZHENGYOU_MESSAGE_OPEN") then

		if(arg0 == "self") then	
			if(zy_AdState == ZY_ADEDIT) then
				ZhengyouMessage_Ad:SetText("发布")
				ZhengyouMessage_EditText:Show()
				ZhengyouMessage_StaticText:Hide()
			else
				ZhengyouMessage_Ad:SetText("更改")
				ZhengyouMessage_EditText:Hide()
				ZhengyouMessage_StaticText:Show()
				local adtitle = FindFriendDataPool:GetPlayerBBSADTitle()
				if adtitle == "" then 
					adtitle = "希望大家多多支持哦" 
				end
				ZhengyouMessage_StaticText:SetText("#c9CCF00"..adtitle)
				ZhengyouMessage_EditText:SetText(adtitle)
			end	
		
			ZhengyouMessage_Ad:Show()
			ZhengyouMessage_ClearMessage:Show()
		else
			if(arg0 == "other") then		
				ZhengyouMessage_EditText:Hide()
				ZhengyouMessage_Ad:Hide()
				ZhengyouMessage_ClearMessage:Hide()
				ZhengyouMessage_StaticText:Show()
				local adtitle = FindFriendDataPool:GetPlayerBBSADTitle()
				
				if adtitle == "" then 
					adtitle = "希望大家多多支持哦" 
				end
				ZhengyouMessage_StaticText:SetText("#c9CCF00"..adtitle)
		  end	
		end
		
		this:Show()
		ZhengyouMessage_UpdateFrame()
		
	elseif(event == "CLOSE_STALL_MESSAGE") then
		ZhengyouMessage_Close()
	elseif(event =="CLOSE_WINDOW" and arg0 == "ZhengyouMessage")then
		ZhengyouMessage_Close()
	end

end

--===============================================
-- 更新留言信息
--===============================================

function ZhengyouMessage_UpdateFrame()
	
	ZhengyouMessage_Desc:ClearAllElement()
	local szPlayerName
	local nTime
	local szMessage
	local szTime
	local nMsgNum = FindFriendDataPool:GetPlayerMsgNum()

	for i=1, nMsgNum do
		szPlayerName,nTime,szMessage = FindFriendDataPool:EnumPlayerMsg(i-1)
		nTime = nTime + 1000000  --月份[0，11],因此需要加一个1
		szTime = ""
		local tArray ={}
		for j = 1,8 do
			tArray[j] = math.mod(nTime,10)
			nTime = math.floor(nTime/10)
		end
		szTime = string.format("%d%d-%d%d %d%d:%d%d",tArray[8],tArray[7],tArray[6],tArray[5],tArray[4],tArray[3],tArray[2],tArray[1])
		ZhengyouMessage_Desc:AddChatBoardElement(szPlayerName..szTime)
		ZhengyouMessage_Desc:AddChatBoardElement("#c9CCF00"..szMessage)
	end
	
end

--===============================================
--发送留言
--===============================================
function ZhengyouMessage_SendMessage_Clicked()
 local curTime = FindFriendDataPool:GetTickCount();
 if ( curTime - zy_lastSendMsgTime < zy_sendMsgCD * 1000) then
 	 PushDebugMessage("#{ZYPT_081127_2}"); --不可连续点击，请稍等片刻后再点击
   return;
 else
 	 zy_lastSendMsgTime = curTime;
   FindFriendDataPool:AddPlayerMsg(ZhengyouMessage_EditInfoText:GetText())
   ZhengyouMessage_EditInfoText:SetText("")
 end


end


--===============================================
-- 清除留言
--===============================================
function ZhengyouMessage_ClearMessage_Clicked()

	local nMsgNum = FindFriendDataPool:GetPlayerMsgNum()
	if(nMsgNum <= 0) then
		PushDebugMessage("#{ZYLY_091118_04}")
	   return
	end
	
  ZhengyouMessage_Desc:ClearAllElement()
  FindFriendDataPool:ClearPlayerMsg()

end

--===============================================
-- 广告按钮,仅自己可见
--     状态1。“发布” ZY_ADEDIT
--     状态2。“更改” ZY_ADAPPLY
--===============================================
function ZhengyouMessage_Ad_Clicked()
	
	if(zy_AdState == ZY_ADEDIT) then
		FindFriendDataPool:SetADTitle(ZhengyouMessage_EditText:GetText())
		zy_AdState = ZY_ADAPPLY
	else
  	ZhengyouMessage_Ad:SetText("发布")
		ZhengyouMessage_StaticText:Hide()
		ZhengyouMessage_EditText:Show()
		zy_AdState = ZY_ADEDIT
	end

end


function ZhengyouMessage_Close()
	zy_AdState	= ZY_ADAPPLY
	this:Hide()
end

function ZhengyouMessage_Frame_OnHiden()
ZhengyouMessage_Close()
end
