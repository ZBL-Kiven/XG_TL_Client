local g_nBagIndex = -1    		--背包中的位置 
local g_nItemIndex = -1   		--物品ID 
local g_nCanSelectTotal = 0     --可选按钮个数 
local g_strPetName = ""

function PetLongzi_PreLoad()

	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	this:RegisterEvent("SCENE_TRANSED");
	this:RegisterEvent("ON_SCENE_TRANSING");

end

function PetLongzi_OnLoad()


end

function PetLongzi_OnEvent(event)

	if(event == "UI_COMMAND" and tonumber(arg0) == 171718) then
        --PushDebugMessage("Enter UI_COMMAND")
		g_nBagIndex = Get_XParam_INT(0)
		g_nItemIndex = Get_XParam_INT(1)
        g_nCanSelectTotal = Get_XParam_INT(2)
        g_strPetName = Get_XParam_STR(0)
        
        PetLongzi_UpdateFrame()
        this:Show();
    elseif event == "PLAYER_LEAVE_WORLD"  then
		if( this:IsVisible() ) then
			this:Hide()
		end
	elseif event == "SCENE_TRANSED"  then
		if( this:IsVisible() ) then
			this:Hide()
		end
	elseif event == "ON_SCENE_TRANSING"  then
		if( this:IsVisible() ) then
			this:Hide()
		end
    end
			
end

function PetLongzi_UpdateFrame()
	--目前只有2,4两种情况 
	
	if  g_nCanSelectTotal == 2 then
		
		PetLongzi_OK1:Hide()
		PetLongzi_OK2:Hide()
		PetLongzi_OK3:Show()
		PetLongzi_OK4:Show()
		
		PetLongzi_OK3:SetText("#{ZSLZ_XML_4}")
		PetLongzi_OK4:SetText("#{ZSLZ_XML_5}")
		
		PetLongzi_Text:SetText("#{ZSLZ_XML_2}"..g_strPetName.."#{ZSLZ_XML_3}")

	elseif g_nCanSelectTotal == 4 then
		if g_nItemIndex == 38000204 or g_nItemIndex == 38001080 or g_nItemIndex == 38001798 
			or g_nItemIndex == 38002172  -- 七巧狸猫
			or g_nItemIndex == 30309982  -- 九黎妖虎
			or g_nItemIndex == 30309984  -- 万世魂
			or g_nItemIndex == 30309988	 -- 狭路逢
			or g_nItemIndex == 30309989  -- 秦小偶
			or g_nItemIndex == 30309995  -- 四时山君
			or g_nItemIndex == 30309996  -- 安琪儿
			or g_nItemIndex == 30310011  -- 霓凰宝宝
			then

			PetLongzi_OK1:Show()
			PetLongzi_OK2:Show()
			PetLongzi_OK3:Show()
			PetLongzi_OK4:Show()
			
			PetLongzi_OK1:SetText("#{ZSLZ_XML_7}")--65
			PetLongzi_OK2:SetText("#{ZSLZ_XML_8}")--75
			PetLongzi_OK3:SetText("#{ZSLZ_XML_9}")--85
			PetLongzi_OK4:SetText("#{VIPBS_201126_11}")--95
			
			PetLongzi_Text:SetText("#{ZSLZ_XML_2}"..g_strPetName.."#{ZSLZ_XML_3}")

		else
			PetLongzi_OK1:Show()
			PetLongzi_OK2:Show()
			PetLongzi_OK3:Show()
			PetLongzi_OK4:Show()
			
			PetLongzi_OK1:SetText("#{ZSLZ_XML_6}")
			PetLongzi_OK2:SetText("#{ZSLZ_XML_7}")
			PetLongzi_OK3:SetText("#{ZSLZ_XML_8}")
			PetLongzi_OK4:SetText("#{ZSLZ_XML_9}")
			
			PetLongzi_Text:SetText("#{ZSLZ_XML_2}"..g_strPetName.."#{ZSLZ_XML_3}")
		end

	else
		this:Hide()
	end 
end

function PetLongzi_Close()
	this:Hide();
end

function PetLongzi_Select(nIndex)
	
	local nRealSelect = nIndex
	if g_nCanSelectTotal == 2 then
		if nIndex == 3 then
			nRealSelect = 1
		elseif nIndex == 4 then
			nRealSelect = 2
		end
	end
	
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("LongZiCreatPetPair")
		Set_XSCRIPT_ScriptID(300300)
		Set_XSCRIPT_Parameter(0,g_nBagIndex)
		Set_XSCRIPT_Parameter(1,g_nItemIndex)
		Set_XSCRIPT_Parameter(2,nRealSelect)
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT();
	
	this:Hide()
end