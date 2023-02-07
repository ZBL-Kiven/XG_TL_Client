
--拼图名称及对应图片
local PintuImage = {
	{"#{TJRW_100511_43}", "set:Pintu1 image:Pintu_1"},
	{"#{TJRW_100511_44}", "set:Pintu1 image:Pintu_2"},
	{"#{TJRW_100511_45}", "set:Pintu1 image:Pintu_3"},
	{"#{TJRW_100511_47}", "set:Pintu2 image:Pintu_5"},
	{"#{TJRW_100511_50}", "set:Pintu2 image:Pintu_8"},
	{"#{TJRW_100511_51}", "set:Pintu3 image:Pintu_9"},
	{"#{TJRW_100511_52}", "set:Pintu3 image:Pintu_10"},
	{"#{TJRW_100511_46}", "set:Pintu1 image:Pintu_4"},
	{"#{TJRW_100511_49}", "set:Pintu2 image:Pintu_7"},
	{"#{TJRW_100511_48}", "set:Pintu2 image:Pintu_6"},
}

function Pintu_PreLoad()
	this:RegisterEvent("UI_COMMAND");
end

function Pintu_OnLoad()
	this:Hide()
	Pintu_DragTitle:SetText("")
	Pintu_Clear()
end

function Pintu_OnEvent(event)

	if ( event == "UI_COMMAND" and tonumber(arg0) == 20100517) then

			local imageIndex = Get_XParam_INT(0);
			if imageIndex < 1 or imageIndex > 10 then
				return
			end	
			
			local imageName = PintuImage[imageIndex][1]
			local imageProp = PintuImage[imageIndex][2]
			
--			local showStr = string.format("下图为%s的一角，请你去找到它所在的位置：", imageName)
			local showStr = string.format("#{TJRW_100511_75}%s#{TJRW_100511_76}", imageName)
			
			Pintu_Text:SetText(showStr)
			Pintu_Image:SetProperty("Image", imageProp);
			
			this:Show()
	elseif   ( event == "UI_COMMAND" and tonumber(arg0) == 20100518) then
		 if(this:IsVisible()) then
			this:Hide()
		end
	end

end

--=========================================================
--重置界面
--=========================================================
function Pintu_Clear() 
	Pintu_Text:SetText("")
	Pintu_Image:SetProperty("Image", "");		
end

--=========================================================
--更新界面
--=========================================================
function Pintu_Update( pos_ui, pos_packet )

end

--=========================================================
--关闭
--=========================================================
function Pintu_Close()
	this:Hide()
	Pintu_Clear()
end

--=========================================================
--界面隐藏
--=========================================================
function Pintu_OnHide()
	this:Hide()
end
