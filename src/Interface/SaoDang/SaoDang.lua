
local g_SaoDang_Level = 15

--===============================================
-- OnLoad()
--===============================================
function SaoDang_PreLoad()
	this:RegisterEvent("PLAYER_ENTERING_WORLD" );	-- 进入world
	this:RegisterEvent("UNIT_LEVEL");				-- 升级
end

function SaoDang_OnLoad()

end

--===============================================
-- OnEvent()
--===============================================
function SaoDang_OnEvent( event )
	
	if event == "PLAYER_ENTERING_WORLD" then
		SaoDang_UpdateUI()
		
	elseif event == "UNIT_LEVEL" then
		SaoDang_UpdateUI()
	end

end

function SaoDang_UpdateUI()
	SaoDang_Update_SaoDang()
end

--===============================================
-- Bn2Click()
--===============================================
function SaoDang_Clicked( index )
	if index == 1 then
		SaoDang_Click_SaoDang()
	end
end



--嘉年华直播功能入口
function SaoDang_Update_SaoDang()
	local nPlayerLevel = Player:GetData("LEVEL")
	if nPlayerLevel < g_SaoDang_Level then
		SaoDang:Hide()
		this:Hide()
		return
	end
	
	SaoDang:Show()
	this:Show()
	

	--SaoDang_Image:SetToolTip("#{JNHZB_20201105_02}")

end


function SaoDang_Click_SaoDang()
	local nPlayerLevel = Player:GetData("LEVEL")
	if nPlayerLevel < g_SaoDang_Level then
		if ( IsWindowShow( "SweepAll" ) ) then
			CloseWindow( "SweepAll", true );
			return
		end
	end
	
	OpenSecKillList();
end






