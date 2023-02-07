local g_SongliaoWarMulti_Frame_UnifiedXPosition;
local g_SongliaoWarMulti_Frame_UnifiedYPosition;
function SongliaoWarMulti_PreLoad()
	this:RegisterEvent("REFRESH_SONGLIAOWAR_MULTI_SCORE");
	--this:RegisterEvent("SHOW_SONGLIAOWAR_SCORE_M");
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false);
	this:RegisterEvent("ADJEST_UI_POS");
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED");
end

function SongliaoWarMulti_OnLoad()
	SongliaoWarMulti_List:SetProperty( "ColumnsSizable", "False" )
	SongliaoWarMulti_List:SetProperty( "ColumnsAdjust", "True" )
	SongliaoWarMulti_List:SetProperty( "ColumnsMovable", "False" )
	
	g_SongliaoWarMulti_Frame_UnifiedXPosition	= SongliaoWarMulti_Frame : GetProperty("UnifiedXPosition");
	g_SongliaoWarMulti_Frame_UnifiedYPosition	= SongliaoWarMulti_Frame : GetProperty("UnifiedYPosition");
end

function SongliaoWarMulti_OnHiden()
	this:Hide()
end

function SongliaoWarMulti_OnEvent(event)
	--PushDebugMessage(event)
	if( event == "SHOW_SONGLIAOWAR_SCORE_M" ) then
		if this:IsVisible() then
			this:Hide();
		else
			this:Show()
			SongliaoWarMulti_GetData()
		end 
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		this:Hide();
	elseif (event=="REFRESH_SONGLIAOWAR_MULTI_SCORE" and this:IsVisible()) then
			SongliaoWarMulti_GetData()
	-- 游戏窗口尺寸发生了变化
	elseif (event == "ADJEST_UI_POS" ) then
		SongliaoWarMulti_Frame_On_ResetPos();
	-- 游戏分辨率发生了变化		
	elseif (event == "VIEW_RESOLUTION_CHANGED" ) then
		SongliaoWarMulti_Frame_On_ResetPos();
	end
end


function SongliaoWarMulti_Close()
	this:Hide()
end

function SongliaoWarMulti_GetData()
	SongliaoWarMulti_List:RemoveAllItem()
	local myRet, myName, myCamp, myScore, mykillNum, myGUID,mySuccKill = CSongliaoWarData:GetMyScore()
	if myRet~=nil and myRet==1 then
		--SongliaoWarMulti_SetInterface(0,myName,myCamp,myScore, g_myColor)
	else
		return
	end
	
	if myCamp == 156 then
		SongliaoWarMulti_DragTitle:SetText("#{XSLDZ_180424_26}")
	else
		SongliaoWarMulti_DragTitle:SetText("#{XSLDZ_180424_27}")
	end

	local nIndex = 0
	local nCount = 0
	for i=0,59 do
		local ret, charname, camp, score ,killnum, humanGUID,succkill = CSongliaoWarData:GetScoreByIndex(i)

		--PushDebugMessange(ret)
		if ret~=nil and ret==1 then -- and myCamp == camp
			if tonumber(succkill) > 11 then
				succkill = 11
			end
		
			if camp ~= myCamp then
				continue
			end

			if humanGUID==myGUID then
				SongliaoWarMulti_SetInterface(nIndex,charname,camp,score, killnum,"FF0000FF",succkill)
			else
				SongliaoWarMulti_SetInterface(nIndex,charname,camp,score, killnum,"",succkill)
			end
			nIndex = nIndex + 1
			if nIndex == 15 then
				break
			end
		else
			--SongliaoWarMulti_SetInterface(i+1,"N/A",156,0)--测试用，注意用完要删除
		end
	end


	if mySuccKill > 11 then
		mySuccKill = 11
	end
	local myindex = 0
	for i=0,59 do
		local ret, charname, camp, score ,killnum, humanGUID= CSongliaoWarData:GetScoreByIndex(i)
		--PushDebugMessange(ret)
		if ret~=nil and ret==1 then
			
			if camp ~= myCamp then
				continue
			end
			myindex = myindex + 1
			if myGUID == humanGUID then
				break
			end
		end
	end
	
	--SongliaoWarMulti_List:AddNewItem(myindex, 0, 0, g_myColor) --排名
	--SongliaoWarMulti_List:AddNewItem(myName, 1, 0, g_myColor) --姓名
	--SongliaoWarMulti_List:AddNewItem(mykillNum, 2,0, g_myColor) --战旗数量
	--SongliaoWarMulti_List:AddNewItem(mySuccKill, 3,0, g_myColor) --战旗数量
	--SongliaoWarMulti_List:AddNewItem(myScore, 4, 0, g_myColor)--积分
	SongliaoWarMulti_SelfInfo1:SetText(myindex)
	SongliaoWarMulti_SelfInfo2:SetText(myName)
	SongliaoWarMulti_SelfInfo3:SetText(mykillNum)
	SongliaoWarMulti_SelfInfo4:SetText(mySuccKill)
	SongliaoWarMulti_SelfInfo5:SetText(myScore)
end


function SongliaoWarMulti_SetInterface(index, charname, camp, score,killnum, color,succkill)
	SongliaoWarMulti_List:AddNewItem(index+1, 0, index , color) --排名
	SongliaoWarMulti_List:AddNewItem(charname, 1, index , color) --姓名
	SongliaoWarMulti_List:AddNewItem(killnum, 2, index , color) --击杀
	SongliaoWarMulti_List:AddNewItem(succkill, 3, index , color) --击杀
	SongliaoWarMulti_List:AddNewItem(score, 4, index, color)--积分

	--SongliaoWarMulti_List:AddNewItem(charname, 4, index, color)
	--if camp==156 then
		--PushDebugMessage(score)
	--	SongliaoWarMulti_List:AddNewItem("#{SLDZ_100805_118}", 1, index, color)
	--elseif camp==157 then
	--	SongliaoWarMulti_List:AddNewItem("#{SLDZ_100805_119}", 1, index, color)
	--else
	--	SongliaoWarMulti_List:AddNewItem("N/A", 1, index, color)
	--end
	--SongliaoWarMulti_List:AddNewItem(score, 2, index, color)
end

--更新主界面位置
function SongliaoWarMulti_Frame_On_ResetPos()

	SongliaoWarMulti_Frame : SetProperty("UnifiedXPosition", g_SongliaoWarMulti_Frame_UnifiedXPosition);
	SongliaoWarMulti_Frame : SetProperty("UnifiedYPosition", g_SongliaoWarMulti_Frame_UnifiedYPosition);

end