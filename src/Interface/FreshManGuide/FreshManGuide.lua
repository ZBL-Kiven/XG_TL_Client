-- 新手指引ui ---只有  
local g_Frame_Width = 0
local g_Frame_Height = 0

local g_Frame_SizeRaw = ""
local g_Lace_SizeRaw = "" 
local g_Ctl_Corner = {}
   
local g_X_Offset = 0  --相对目标窗口的偏移
local g_Y_Offset = 0  --同上
local g_Direct   = "" --相对目标窗口的方位
local g_cached_textid = -1 

function FreshManGuide_PreLoad()
	this:RegisterEvent("OPEN_FRESHMAN_GUIDE")
	this:RegisterEvent("CLOSE_FRESHMAN_GUIDE")
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
end

function FreshManGuide_OnLoad()

	--note：two varibles below will be set to string in fact, so do not compare with number directly.
	g_Frame_Width  = FreshManGuide_Frame:GetProperty("AbsoluteWidth")
	g_Frame_Height = FreshManGuide_Frame:GetProperty("AbsoluteHeight") 
	g_Frame_SizeRaw = FreshManGuide_Frame:GetProperty("UnifiedSize")
	g_Lace_SizeRaw = FreshManGuide_Lace:GetProperty("UnifiedSize")

	g_Ctl_Corner = {  --顺时针,四个角
        FreshManGuide_UpLeft,
        FreshManGuide_UpRight,
        FreshManGuide_DownRight,
        FreshManGuide_DownLeft,
    }
end

function FreshManGuide_OnEvent(event)
	if event == "OPEN_FRESHMAN_GUIDE" then
	    if 1 ~= FreshManGuide_CheckSize(tonumber(arg4), tonumber(arg5)) then
	        return  -- 客户端主窗口比本界面还小,不予显示了就
	    end
	    if "" == GetFreshManGuideOwner() or "PlayerQuicklyEnter" ~= GetFreshManGuideOwner() then
			assert("" == GetFreshManGuideOwner())
			assert("PlayerQuicklyEnter" ~= GetFreshManGuideOwner())
			return  -- 必须要有目标窗口
	    end
	    if 1 == tonumber(arg0) then
            FreshManGuide_Reset(tonumber(arg1), tonumber(arg2), tonumber(arg3), tonumber(arg4), tonumber(arg5), arg6)
        elseif 2 == tonumber(arg0) and this:IsVisible() then
            FreshManGuide_Modify(tonumber(arg1), tonumber(arg2), tonumber(arg3), tonumber(arg4), tonumber(arg5), arg6)
        end
        return
	end

	if event == "ADJEST_UI_POS" or
	    event == "VIEW_RESOLUTION_CHANGED" or
	    event == "CLOSE_FRESHMAN_GUIDE" then
		FreshManGuide_Close()
        return
	end
end

function FreshManGuide_Close()
    if not this:IsVisible() then
        return
    end

    KillTimer("FreshManGuide_Close()")
    this:Hide()
end

function FreshManGuide_Reset(nTextID, nTipPosX, nTipPosY, nClientWidth, nClientHight, szCorner)

	g_cached_textid = nTextID 
	Lua_TDU_Log("FreshManGuide_Reset g_cached_textid: "..g_cached_textid )

    KillTimer("FreshManGuide_Close()")
	FreshManGuide_Modify(nTextID, nTipPosX, nTipPosY, nClientWidth, nClientHight, szCorner)
	
	local ButtonCount 	= GetPlayerQuickEnterCount()
	local g_Flex		= GetPlayerQuickEnterHide() 

	if type(g_Flex)  ~= "table" or g_Flex[nTextID] == nil or nTextID > ButtonCount then
		return
	end 
	SetTimer("FreshManGuide", "FreshManGuide_Close()", tonumber(g_Flex[nTextID].FreshFlash))

	this:Show()
end

--szCorner代表调用者期望的显示方位
--如期望方位显示不下本窗口,才进入自由选择
function FreshManGuide_Modify(nTextID, nTipPosX, nTipPosY, nClientWidth, nClientHight, szCorner) 
	
	Lua_TDU_Log("FreshManGuide_Modify nTextID: "..nTextID )
	Lua_TDU_Log("FreshManGuide_Modify nTipPosX: "..nTipPosX )
	Lua_TDU_Log("FreshManGuide_Modify nTipPosY: "..nTipPosY )
	Lua_TDU_Log("FreshManGuide_Modify nClientWidth: "..nClientWidth )
	Lua_TDU_Log("FreshManGuide_Modify nClientHight: "..nClientHight )
	Lua_TDU_Log("FreshManGuide_Modify szCorner: "..szCorner )

	if nTextID == -1 then
		nTextID = g_cached_textid
	end

	--FreshManGuide_CrackSize( nTextID )

	if nTipPosX ~= -1 or nTipPosY ~= -1 then             --都为-1，表示不改变相对位置
        g_X_Offset = nTipPosX                            --本tip相对于目标窗口的偏移
        g_Y_Offset = nTipPosY
    end
    if szCorner ~= "" then                               --空串,表示方位不变
        g_Direct = szCorner
	end
	
    local OffsetX, OffsetY = GetWindowPos(GetFreshManGuideOwner()) --得到目标窗口相对于底板的偏移
    OffsetX = OffsetX + g_X_Offset                       --本tip相对于客户端窗口底板的偏移
    OffsetY = OffsetY + g_Y_Offset 
	 
	Lua_TDU_Log("FreshManGuide_Modify OffsetX: "..OffsetX )
	Lua_TDU_Log("FreshManGuide_Modify g_Frame_Width: "..g_Frame_Width )
	Lua_TDU_Log("FreshManGuide_Modify nClientWidth: "..nClientWidth )
	Lua_TDU_Log("FreshManGuide_Modify OffsetY: "..OffsetY )
	Lua_TDU_Log("FreshManGuide_Modify g_Frame_Height: "..g_Frame_Height )
	
	if "northwest" == g_Direct and 
        OffsetX - g_Frame_Width > 0 and OffsetY - g_Frame_Height > 0 then
        FreshManGuide_To(OffsetX - g_Frame_Width, OffsetY - g_Frame_Height)
        FreshManGuide_Show_Corner(3)   --左上显示，show右下角
    elseif "northeast" == g_Direct and
        OffsetX + g_Frame_Width - nClientWidth < 0 and OffsetY - g_Frame_Height > 0 then
        FreshManGuide_To(OffsetX, OffsetY - g_Frame_Height)
		FreshManGuide_Show_Corner(4)   --右上显示，show左下角
		Lua_TDU_Log("FreshManGuide_Modify northeast: "..OffsetX )
		Lua_TDU_Log("FreshManGuide_Modify northeast: "..OffsetY - g_Frame_Height )
    elseif "southeast" == g_Direct and
        OffsetX + g_Frame_Width - nClientWidth < 0 and OffsetY + g_Frame_Height - nClientHight < 0 then
        FreshManGuide_To(OffsetX, OffsetY)
        FreshManGuide_Show_Corner(1)   --右下显示，show左上角
    elseif "southwest" == g_Direct and
        OffsetX - g_Frame_Width > 0 and OffsetY + g_Frame_Height - nClientHight < 0 then
        FreshManGuide_To(OffsetX - g_Frame_Width, OffsetY)
        FreshManGuide_Show_Corner(2)   --左下显示，show右上角
    else
        if OffsetX - g_Frame_Width < 0 then
            if OffsetY - g_Frame_Height < 0 then
                FreshManGuide_To(OffsetX, OffsetY)
                FreshManGuide_Show_Corner(1)
            else
                FreshManGuide_To(OffsetX, OffsetY - g_Frame_Height)
                FreshManGuide_Show_Corner(4)
            end
        else
            if OffsetY - g_Frame_Height < 0 then
                FreshManGuide_To(OffsetX - g_Frame_Width, OffsetY)
                FreshManGuide_Show_Corner(2)
            else
                FreshManGuide_To(OffsetX - g_Frame_Width, OffsetY - g_Frame_Height)
                FreshManGuide_Show_Corner(3)
            end
        end
    end

	local ButtonCount 	= GetPlayerQuickEnterCount()
	local g_Flex		= GetPlayerQuickEnterHide() 

	if type(g_Flex)  ~= "table" or g_Flex[nTextID] == nil or nTextID > ButtonCount then
		return
	end 
	Lua_TDU_Log("FreshManGuide_Modify nTextID: "..nTextID )
	if nil ~= nTextID  then  --nTextID允许传入异常值,表示不改变当前文本 
		Lua_TDU_Log("FreshManGuide_Modify FreshStr: "..g_Flex[nTextID].FreshStr )
		
 		FreshManGuide_GuideInfo:SetText(g_Flex[nTextID].FreshStr) 
    end
end

function FreshManGuide_To(nXPos, nYPos)
    FreshManGuide_Frame:SetProperty("AbsoluteXPosition", nXPos)
    FreshManGuide_Frame:SetProperty("AbsoluteYPosition", nYPos)
end

function FreshManGuide_Show_Corner(nIdx)
    if nil == g_Ctl_Corner[nIdx] then
        return
    end

    for i = 1, table.getn(g_Ctl_Corner) do
       if nIdx == i then
           g_Ctl_Corner[i]:Show()
       else
           g_Ctl_Corner[i]:Hide()
       end
    end
end

function FreshManGuide_CheckSize(nClientWidth, nClientHight)
    if g_Frame_Width - nClientWidth > 0 or g_Frame_Height - nClientHight > 0 then
        return 0
    end
    return 1
end
 
function FreshManGuide_CrackSize( nTextID )

	if nTextID ~= nil then 
		FreshManGuide_Frame:SetProperty("UnifiedSize", tostring(g_Frame_SizeRaw) )
		FreshManGuide_Lace:SetProperty("UnifiedSize", tostring(g_Lace_SizeRaw) )
	end

	g_Frame_Width  = FreshManGuide_Frame:GetProperty("AbsoluteWidth")
	g_Frame_Heigh = FreshManGuide_Frame:GetProperty("AbsoluteHeight")

end

