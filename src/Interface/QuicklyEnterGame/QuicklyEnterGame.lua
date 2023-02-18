--QuicklyEnterGame
--Q 546528533
--=======================================
local g_QuicklyEnterGame_Frame_UnifiedPosition;
local nSelect = -1
local nAccount = ""
local nPassWord = ""
--**********************************
-- PRELOAD 变化时
--**********************************
function QuicklyEnterGame_PreLoad()
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED");	-- 游戏分辨率发生了变化
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("GAMELOGIN_OPEN_SELECT_CHARACTOR")
end
--**********************************
-- ONLOAD
--**********************************
function QuicklyEnterGame_OnLoad()--载入

end

--**********************************
-- ONEvent
--**********************************
function QuicklyEnterGame_OnEvent( event )
	if ( event == "VIEW_RESOLUTION_CHANGED" ) then
		QuicklyEnterGame_UpdateUIPos()
	elseif ( event == "ADJEST_UI_POS" ) then
		QuicklyEnterGame_UpdateUIPos()
	elseif  event == "UI_COMMAND" and tonumber(arg0) == 20210129  then
	    QuicklyEnterGame_Menu:RemoveAllItem()
		this:Show();
		QuicklyEnterGame_Update()
	elseif event == "GAMELOGIN_OPEN_SELECT_CHARACTOR" then
		this:Hide()
    end
end

function QuicklyEnterGame_Del()	
	if nSelect ~= -1 then
		local a,b = QuicklyEnterGame_GetPassWord()
		local nSvaeData = ""
		table.remove(a,nSelect)
		table.remove(b,nSelect)
		for i = 1,table.getn(a) do
			nSvaeData = nSvaeData ..a[i].."\t"..b[i].."\n"
		end
		local file = io.open("./Plugin_SavePassWord.dll", "wb")
		if file ~= nil and nSvaeData ~= ""then
		    file:write(nSvaeData);
			file:close();
		end		
		QuicklyEnterGame_Menu:RemoveAllItem()
		nAccount,nPassWord,nSelect = "","",-1
		QuicklyEnterGame_Update()
	end
end

function QuicklyEnterGame_Enter()	
	PushEvent("UI_COMMAND",20210201,nAccount,nPassWord)
	this:Hide()
end

function QuicklyEnterGame_ItemSelectChanged()
	local lNo = QuicklyEnterGame_Menu:GetSelectItem()
	nSelect = lNo + 1
	local a,b = QuicklyEnterGame_GetPassWord()
	if a[lNo+1] == nil then
		PushDebugMessage("请选择需要快捷登录的账号")
		return 
	end
	nAccount,nPassWord  = a[lNo+1],b[lNo+1]
	-- GameProduceLogin:CheckAccount("", 0);
end

function QuicklyEnterGame_GetPassWord()--读取上一次登录的账号和密码。
        local file = io.open("./Plugin_SavePassWord.dll", "r")
		local nSavenAccID,nSavenPassd = {},{}
		local i = 1
		if file ~= nil then
            for l in file:lines() do
			    if l == nil then
				    break
				end
				local _,_,nID,nPass = string.find(l,"(.*)\t(.*)")
				nSavenAccID[i] = nID
				nSavenPassd[i] = nPass
				i = i + 1
			end
			file:close()
			return nSavenAccID,nSavenPassd
		end
	return nSavenAccID,nSavenPassd 
end
--================================================
-- 数据读取
--================================================
function QuicklyEnterGame_Update()
    local a,b = QuicklyEnterGame_GetPassWord()
	for i = 0,table.getn(a)-1 do
		QuicklyEnterGame_Menu:AddNewItem( a[i+1].."@game.sohu.com", 0, i )
	end
end
--================================================
-- 恢复界面的默认相对位置
--================================================
function QuicklyEnterGame_UpdateUIPos()
    QuicklyEnterGame_Frame:SetProperty("UnifiedPosition", g_QuicklyEnterGame_Frame_UnifiedPosition);
end














