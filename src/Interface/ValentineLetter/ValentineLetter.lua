
local g_imgs = {
	[1] = {
		name = "set:Valentine_bk1 image:Valentine_bk1_2",
		template = "#{YDSS_15018_188}",
	},
	[2] = {
		name = "set:Valentine_bk2 image:Valentine_bk2_2",
		template = "#{YDSS_15018_189}",
	},
	[3] = {
		name = "set:Valentine_bk2 image:Valentine_bk2_1",
		template = "#{YDSS_15018_190}",
	},
}

function ValentineLetter_PreLoad()
	this:RegisterEvent("UI_COMMAND")
end

function ValentineLetter_OnLoad()

end

function ValentineLetter_OnEvent(event)
	if event == "UI_COMMAND" and tonumber(arg0) == 8910461 then
		local n = Get_XParam_INT(0)
		if n == 0 then
			this:Hide()
		else
			local img = g_imgs[n]
			if not img then
				return
			end
			
			if not this:IsVisible() then
				this:Show()
			end
			local myname = Player:GetName()
			local hisname = Get_XParam_STR(0)
			
			ValentineLetter_bk1:SetProperty( "Image", img.name )
			ValentineLetter_Name:SetText( ScriptGlobal_Format( img.template, myname, hisname ) )
			
		end
	end
end