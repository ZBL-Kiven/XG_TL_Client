-- ����ָ��ui ---ֻ��  
local g_Frame_Width = 0
local g_Frame_Height = 0

local g_Frame_SizeRaw = ""
local g_Lace_SizeRaw = "" 
local g_Ctl_Corner = {}
   
local g_X_Offset = 0  --���Ŀ�괰�ڵ�ƫ��
local g_Y_Offset = 0  --ͬ��
local g_Direct   = "" --���Ŀ�괰�ڵķ�λ
local g_cached_textid = -1 

function FreshManGuide_PreLoad()
	this:RegisterEvent("OPEN_FRESHMAN_GUIDE")
	this:RegisterEvent("CLOSE_FRESHMAN_GUIDE")
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
end

function FreshManGuide_OnLoad()

	--note��two varibles below will be set to string in fact, so do not compare with number directly.
	g_Frame_Width  = FreshManGuide_Frame:GetProperty("AbsoluteWidth")
	g_Frame_Height = FreshManGuide_Frame:GetProperty("AbsoluteHeight") 
	g_Frame_SizeRaw = FreshManGuide_Frame:GetProperty("UnifiedSize")
	g_Lace_SizeRaw = FreshManGuide_Lace:GetProperty("UnifiedSize")

	g_Ctl_Corner = {  --˳ʱ��,�ĸ���
        FreshManGuide_UpLeft,
        FreshManGuide_UpRight,
        FreshManGuide_DownRight,
        FreshManGuide_DownLeft,
    }
end

function FreshManGuide_OnEvent(event)
	if event == "OPEN_FRESHMAN_GUIDE" then
	    if 1 ~= FreshManGuide_CheckSize(tonumber(arg4), tonumber(arg5)) then
	        return  -- �ͻ��������ڱȱ����滹С,������ʾ�˾�
	    end
	    if "" == GetFreshManGuideOwner() or "PlayerQuicklyEnter" ~= GetFreshManGuideOwner() then
			assert("" == GetFreshManGuideOwner())
			assert("PlayerQuicklyEnter" ~= GetFreshManGuideOwner())
			return  -- ����Ҫ��Ŀ�괰��
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

--szCorner�����������������ʾ��λ
--��������λ��ʾ���±�����,�Ž�������ѡ��
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

	if nTipPosX ~= -1 or nTipPosY ~= -1 then             --��Ϊ-1����ʾ���ı����λ��
        g_X_Offset = nTipPosX                            --��tip�����Ŀ�괰�ڵ�ƫ��
        g_Y_Offset = nTipPosY
    end
    if szCorner ~= "" then                               --�մ�,��ʾ��λ����
        g_Direct = szCorner
	end
	
    local OffsetX, OffsetY = GetWindowPos(GetFreshManGuideOwner()) --�õ�Ŀ�괰������ڵװ��ƫ��
    OffsetX = OffsetX + g_X_Offset                       --��tip����ڿͻ��˴��ڵװ��ƫ��
    OffsetY = OffsetY + g_Y_Offset 
	 
	Lua_TDU_Log("FreshManGuide_Modify OffsetX: "..OffsetX )
	Lua_TDU_Log("FreshManGuide_Modify g_Frame_Width: "..g_Frame_Width )
	Lua_TDU_Log("FreshManGuide_Modify nClientWidth: "..nClientWidth )
	Lua_TDU_Log("FreshManGuide_Modify OffsetY: "..OffsetY )
	Lua_TDU_Log("FreshManGuide_Modify g_Frame_Height: "..g_Frame_Height )
	
	if "northwest" == g_Direct and 
        OffsetX - g_Frame_Width > 0 and OffsetY - g_Frame_Height > 0 then
        FreshManGuide_To(OffsetX - g_Frame_Width, OffsetY - g_Frame_Height)
        FreshManGuide_Show_Corner(3)   --������ʾ��show���½�
    elseif "northeast" == g_Direct and
        OffsetX + g_Frame_Width - nClientWidth < 0 and OffsetY - g_Frame_Height > 0 then
        FreshManGuide_To(OffsetX, OffsetY - g_Frame_Height)
		FreshManGuide_Show_Corner(4)   --������ʾ��show���½�
		Lua_TDU_Log("FreshManGuide_Modify northeast: "..OffsetX )
		Lua_TDU_Log("FreshManGuide_Modify northeast: "..OffsetY - g_Frame_Height )
    elseif "southeast" == g_Direct and
        OffsetX + g_Frame_Width - nClientWidth < 0 and OffsetY + g_Frame_Height - nClientHight < 0 then
        FreshManGuide_To(OffsetX, OffsetY)
        FreshManGuide_Show_Corner(1)   --������ʾ��show���Ͻ�
    elseif "southwest" == g_Direct and
        OffsetX - g_Frame_Width > 0 and OffsetY + g_Frame_Height - nClientHight < 0 then
        FreshManGuide_To(OffsetX - g_Frame_Width, OffsetY)
        FreshManGuide_Show_Corner(2)   --������ʾ��show���Ͻ�
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
	if nil ~= nTextID  then  --nTextID�������쳣ֵ,��ʾ���ı䵱ǰ�ı� 
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

