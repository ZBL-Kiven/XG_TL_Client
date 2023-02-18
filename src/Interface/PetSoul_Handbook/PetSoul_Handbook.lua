--!!!reloadscript =PetSoul_Handbook

local g_PetSoul_Handbook_Frame_UnifiedPosition

local g_InitList = 0
local g_NeedChangeScrollSize = 1

local g_MaxBarNum = 15
local g_BarList = {}

local g_bloodLevelBtn = {}	

local g_curSelListId = 1					--当前选择的列表兽魂ID，从1开始
local g_curBloodLevelSel = 1					--血脉等级 1-6

local g_undefinedObj = ""

function PetSoul_Handbook_PreLoad()
	this:RegisterEvent("OPEN_WINDOW");
	this:RegisterEvent("CLOSE_WINDOW");
	this:RegisterEvent("UI_COMMAND", true)
	this:RegisterEvent("SHOW_PETSOUL_HANDBOOK", true)
	this:RegisterEvent("ADJEST_UI_POS", false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED", false)
end

function PetSoul_Handbook_OnLoad()	
	g_PetSoul_Handbook_Frame_UnifiedPosition=PetSoul_Handbook_Frame:GetProperty("UnifiedPosition")
	--g_bloodLevelBtn = {
	--	PetSoul_Handbook_BloodLevelBtn1,PetSoul_Handbook_BloodLevelBtn2,PetSoul_Handbook_BloodLevelBtn3,
	--	PetSoul_Handbook_BloodLevelBtn4,PetSoul_Handbook_BloodLevelBtn5,PetSoul_Handbook_BloodLevelBtn6
	--}
		if IsWindowShow("WuhunJian") then
			CloseWindow("WuhunJian", true)
		end
		if IsWindowShow("Wuhun") then
			CloseWindow("Wuhun", true)
		end
	
	g_undefinedObj = PetSoul_Handbook_FakeObjectNull
end

function PetSoul_Handbook_Frame_On_ResetPos()
	PetSoul_Handbook_Frame:SetProperty("UnifiedPosition", g_PetSoul_Handbook_Frame_UnifiedPosition);
end

function PetSoul_Handbook_OnEvent(event)
	if event == "UI_COMMAND" and tonumber(arg0) == 2022052559 then
		if IsWindowShow("WuhunJian") then
			CloseWindow("WuhunJian", true)
		end
		if IsWindowShow("Wuhun") then
			CloseWindow("Wuhun", true)
		end
		
		--if tonumber(arg0) ~= -1 then
		
			if this:IsVisible() then
				return
			end

			PetSoul_Handbook_OnShown(tonumber(arg0))	



		--end
	elseif event == "OPEN_WINDOW" then
		if( arg0 == "PetSoul_Handbook") then
			if this:IsVisible() then
				return
			end
			PetSoul_Handbook_OnShown()	
		end

	elseif event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		PetSoul_Handbook_Frame_On_ResetPos()
	end
end

function PetSoul_Handbook_InitList()
	
	-- if g_InitList == 0 then
		-- Pet:LuaFnInitPetSoulHandbookList()
		-- g_MaxBarNum = Pet:LuaFnGetPetSoulHandbookMaxCount()
		-- PushDebugMessage(g_MaxBarNum)
		-- for i = 1, g_MaxBarNum do
			-- local bar = PetSoul_Handbook_SuperList:AddChild("PetSoul_Handbook_SuperListItem")
			-- bar:SetProperty("SuperBarButtonHover", "SuperBarHoverSection")
			-- g_BarList[i] = bar	
			-- bar:GetSubItem("PetSoul_Handbook_SuperListItemAction"):SetEvent("MouseLButtonDown", string.format("PetSoul_Handbook_ItemClicked(%d)", i))
			-- bar:GetSubItem("PetSoul_Handbook_SuperListItemAction"):SetEvent("MouseMove", string.format("PetSoul_Handbook_ItemMouseMove(%d)", i))
			-- bar:GetSubItem("PetSoul_Handbook_SuperListItemAction"):SetProperty("Empty", "False")
			-- bar:GetSubItem("PetSoul_Handbook_SuperListItemAction"):SetProperty("UseDefaultTooltip", "True")
		-- end
		-- g_InitList = 1
	-- end

	PetSoul_Handbook_FakeObject : SetFakeObject( "" )
	g_undefinedObj:Hide()
	
	PetSoul_Handbook_BloodLevel:ResetList()

	PetSoul_Handbook_BloodLevel:AddTextItem("#{SHTJ_20211229_23}",0)
	PetSoul_Handbook_BloodLevel:AddTextItem("#{SHTJ_20211229_24}",1)
	PetSoul_Handbook_BloodLevel:AddTextItem("#{SHTJ_20211229_25}",2)	
	PetSoul_Handbook_BloodLevel:AddTextItem("#{SHTJ_20211229_26}",3)
	PetSoul_Handbook_BloodLevel:AddTextItem("#{SHTJ_20211229_27}",4)
	PetSoul_Handbook_BloodLevel:AddTextItem("#{SHTJ_20211229_28}",5)
	PetSoul_Handbook_BloodLevel:SetCurrentSelect(0)	

end

function PetSoul_Handbook_OnShown(curPetsoulOnPet)
	
	local curSelPet = curPetsoulOnPet
	
	g_NeedChangeScrollSize = 1
	
	PetSoul_Handbook_CleanUp()
	
	PetSoul_Handbook_InitList()
	
	PetSoul_Handbook_UpdateList()
	
	--if Pet:LuaFnIsPetEquipPetSoul(curSelPet) == 1 then
		--转化成图鉴id？
	--	g_curSelListId = Pet:LuaFnGetPetSoulDataOnPet(curSelPet, "LISTID")
	--	g_curBloodLevelSel = 1 --Pet:LuaFnGetPetSoulDataOnPet(curSelPet, "BR")
	--else
		g_curSelListId = 1
		g_curBloodLevelSel = 1
	--end
	
	PetSoul_Handbook_ItemClicked(1)
	
	this:Show()
			
	PetSoul_Handbook_FakeObject:SetFakeObject("Other_Horse")

end

function PetSoul_Handbook_UpdateList()
	

	local count = LuaFnGetPetSoulHandbookMaxCount()

	for i = 1, count do
		PetSoul_Handbook_SetItem(i, count)
	end
	
	if g_NeedChangeScrollSize == 1 then
		-- PetSoul_Handbook_SuperList:RefreshLayout() -- 重置UI
		g_NeedChangeScrollSize = 0
	end
end

function PetSoul_Handbook_SetItem(index, max_count)  --index 1开始
	--local nExteriorID = Exterior:LuaFnGetExteriorIDFromList(g_ExteriorType, index - 1)
	--local charHairId, _, _, _, IconFile, _, StyleName, reqMenPai = Exterior:LuaFnGetExteriorHairStyleInfo(nExteriorID)
	--local player_menpai = Player:GetData("MEMPAI")
	
	--if charHairId >= 0 then
		local ctrlAction = _G[string.format("PetSoul_Handbook_SuperListItemAction%d",index)]
		if ctrlAction ~= nil then
			local iconFile = LuaFnGetPetSoulDataByListID(index, "ICON")
			local sPos,_ = string.find(iconFile,"_");
			local iconImageSet = string.sub(iconFile,0,sPos-1);
			iconFile = "set:"..iconImageSet.." image:"..iconFile
			ctrlAction:SetProperty("BackImage", iconFile)
			local name = LuaFnGetPetSoulDataByListID(index, "NAME")
			ctrlAction:SetToolTip(string.format("#Y点击查看%s",name))
		
			if g_curSelListId == index then
				ctrlAction:SetPushed(1)
			else
				ctrlAction:SetPushed(0)
			end
		end
		
		local xin = _G[string.format("NPetSoul_Handbook_SuperListItemActionTip%d",index)]
		local equ = _G[string.format("PetSoul_Handbook_SuperListItemActionEqu%d",index)]
		xin:Hide()
		equ:Hide()

	--end
end

function PetSoul_Handbook_SetItemSelected(nIndex)
	for i = 1, 15 do
		if g_BarList[i] ~= nil then
			local ctrlAction = _G[string.format("PetSoul_Handbook_SuperListItemAction%d",nIndex)]
			if ctrlAction ~= nil then
				if i == nIndex then
					ctrlAction:SetPushed(1)
				else
					ctrlAction:SetPushed(0)
				end
			end
		end
	end
end

function PetSoul_Handbook_ItemClicked(nIndex)
	

	--local nExteriorID = Exterior:LuaFnGetExteriorIDFromList(g_ExteriorType, nIndex - 1)	
	--if g_curSelListId == nExteriorID then
	--	return
	--end	

	g_curSelListId = nIndex
	
	PetSoul_Handbook_BloodLevel:SetCurrentSelect(0)
	g_curBloodLevelSel = 1

	--PushDebugMessage("PetSoul_Handbook_ItemClicked  nIndex = "..nIndex.."    "..g_curSelListId.."  "..g_curBloodLevelSel)

	
	PetSoul_Handbook_SetItemSelected(nIndex)
	
	PetSoul_Handbook_ShowDetail()
	

end

function PetSoul_Handbook_ShowDetail()
	
	
	
	local _,curSelect = PetSoul_Handbook_BloodLevel:GetCurrentSelect()
	g_curBloodLevelSel = curSelect + 1
	if g_curBloodLevelSel < 1 or g_curBloodLevelSel > 6 then 
		g_curBloodLevelSel = 1
	end
	
	-- DataPool:PetSoulHandbook_SetCurSelLevel(g_curBloodLevelSel);
	
	
	--PushDebugMessage("PetSoul_Handbook_ShowDetail  "..g_curSelListId.."  "..g_curBloodLevelSel)	
	
	PetSoul_Handbook_FakeObject:SetFakeObject( "" )
	local showid = LuaFnGetPetSoulModel(g_curSelListId,g_curBloodLevelSel, "MODEL")
	Target:SetHorseModel(showid);
	PetSoul_Handbook_FakeObject:SetFakeObject("Other_Horse")

	
	local skillAction,_,strSkillName = LuaFnEnumPetSoulSkillActionOnPet(g_curSelListId,g_curBloodLevelSel)
	if skillAction ~= nil then
		PetSoul_Handbook_SkillIcon:SetProperty( "BackImage", skillAction )
	end
	PetSoul_Handbook_SkillNameText:SetText(string.format("#cfff263%s",strSkillName))
	
	local GetPetSoulPer = LuaFnGetPetSoulLevelupInfo(100, g_curSelListId-1)
	-- PushDebugMessage(g_curSelListId)
	PetSoul_Handbook_StrAptitude:SetText("#cFAFFA4+"..string.format("%.2f", GetPetSoulPer[1]/100).."%")
	
	-- local _, szSprAptitude = Pet:LuaFnGetPetSoulDataByListID(g_curSelListId, "SPR_APT")
	PetSoul_Handbook_SprAptitude:SetText("#cFAFFA4+"..string.format("%.2f", GetPetSoulPer[2]/100).."%")
	
	-- local _, szConAptitude = Pet:LuaFnGetPetSoulDataByListID(g_curSelListId, "CON_APT")
	PetSoul_Handbook_ConAptitude:SetText("#cFAFFA4+"..string.format("%.2f", GetPetSoulPer[3]/100).."%")

	-- local _, szIntAptitude = Pet:LuaFnGetPetSoulDataByListID(g_curSelListId, "INT_APT")
	PetSoul_Handbook_IntAptitude:SetText("#cFAFFA4+"..string.format("%.2f", GetPetSoulPer[4]/100).."%")
	
	-- local _, szDexAptitude = Pet:LuaFnGetPetSoulDataByListID(g_curSelListId, "DEX_APT")
	PetSoul_Handbook_DexAptitude:SetText("#cFAFFA4+"..string.format("%.2f", GetPetSoulPer[5]/100).."%")
	
	local nExAptitudeNum = LuaFnGetPetSoulDataByListID(g_curSelListId, "EXT_NUM")
	PetSoul_Handbook_ExnumAptitude_Textnum:SetText(string.format("#cFAFFA4%s",nExAptitudeNum))
	
	local szSourceDesc = LuaFnGetPetSoulDataByListID(g_curSelListId, "SOURCE")
	PetSoul_Handbook_Source_Text:SetText(szSourceDesc)
	
	local szPetPossEffectName, szPetPossSkillIcon, _, _ = LuaFnGetPetSoulPossSkillInfo(g_curSelListId, g_curBloodLevelSel)
	if szPetPossSkillIcon ~= "" then
		PetSoul_Handbook_SkillIcon2:SetProperty( "BackImage", szPetPossSkillIcon )
	end
	
	PetSoul_Handbook_SkillName2Text:SetText(string.format("#cfff263%s",szPetPossEffectName))	
	
	if showid > 0 then
		g_undefinedObj:Hide()
		PetSoul_Handbook_TurnLeft_Btn:Show()
		PetSoul_Handbook_TurnRight_Btn:Show()
	else
		g_undefinedObj:Show()
		PetSoul_Handbook_TurnLeft_Btn:Hide()
		PetSoul_Handbook_TurnRight_Btn:Hide()
	end


end

function PetSoul_Handbook_BloodLevelChanged()
	PetSoul_Handbook_ShowDetail()

end


function PetSoul_Handbook_ItemMouseMove(nIndex)

end


function PetSoul_Handbook_OnCancel()
	PetSoul_Handbook_OnHidden()
end

function PetSoul_Handbook_Close_Click()
	PetSoul_Handbook_OnHidden()
end

function PetSoul_Handbook_OnHidden()
	PetSoul_Handbook_CleanUp()
	this:Hide()
end

function PetSoul_Handbook_CleanUp()
	PetSoul_Handbook_FakeObject:SetFakeObject("")
	g_curSelListId = 1
	PetSoul_Handbook_SkillIcon:SetActionItem(-1)
	PetSoul_Handbook_SkillIcon2:SetProperty( "BackImage", "" )
		
	PetSoul_Handbook_BloodLevel:ResetList()
end


----------------------------------------------------------------------------------
-- 旋转人物头像模型（向左)
function PetSoul_Handbook_TurnLeft(start)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		--向左旋转开始
		if(start == 1) then
			PetSoul_Handbook_FakeObject:RotateBegin(-0.3);
		--向左旋转结束
		else
			PetSoul_Handbook_FakeObject:RotateEnd();
		end
	end
end

----------------------------------------------------------------------------------
--旋转人物头像模型（向右)
function PetSoul_Handbook_TurnRight(start)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		--向右旋转开始
		if(start == 1) then
			PetSoul_Handbook_FakeObject:RotateBegin(0.3);
		--向右旋转结束
		else
			PetSoul_Handbook_FakeObject:RotateEnd();
		end
	end
end


function PetSoul_Handbook_MouseEnter(type)
	
	if g_curSelListId <= 0 or g_curSelListId > g_MaxBarNum then
		return
	end
	local PosX = PetSoul_Handbook_Frame:GetProperty("AbsoluteXPosition") + PetSoul_Handbook_SkillIcon2:GetProperty("AbsoluteXPosition") + PetSoul_Handbook_SkillIconbk2:GetProperty("AbsoluteXPosition") +  PetSoul_Handbook_Skill:GetProperty("AbsoluteXPosition") + PetSoul_Handbook_Frame_Client:GetProperty("AbsoluteXPosition") + 42
	local PosY = PetSoul_Handbook_Frame:GetProperty("AbsoluteYPosition") + PetSoul_Handbook_SkillIcon2:GetProperty("AbsoluteYPosition") + PetSoul_Handbook_SkillIconbk2:GetProperty("AbsoluteYPosition") +  PetSoul_Handbook_Skill:GetProperty("AbsoluteYPosition") + PetSoul_Handbook_Frame_Client:GetProperty("AbsoluteYPosition") + 42
	if type == 1 then
		PosY = PetSoul_Handbook_Frame:GetProperty("AbsoluteYPosition") + PetSoul_Handbook_SkillIconbk:GetProperty("AbsoluteYPosition") + PetSoul_Handbook_SkillIcon:GetProperty("AbsoluteYPosition") +  PetSoul_Handbook_Skill:GetProperty("AbsoluteYPosition") + PetSoul_Handbook_Frame_Client:GetProperty("AbsoluteYPosition") + 42		
	end
	PushEvent("UI_COMMAND",20220525,g_curSelListId,g_curBloodLevelSel,PosX,PosY,type)
end

function PetSoul_Handbook_MouseLeave()
	PushEvent("UI_COMMAND",210220525)
end

