
--雷蛇活动及对应图片
local LeiSheImage = {
	{"#{LSHZ_101008_23}","#{LSHZ_101008_29}", "set:LeiShe1 image:LeiShe_1"},--Razer那伽梵蛇
	{"#{LSHZ_101008_25}","#{LSHZ_101008_31}", "set:LeiShe2 image:LeiShe_2"},-- Razer二角尘蛛
	{"#{LSHZ_101008_52}","#{LSHZ_101008_55}", "set:LeiShe3 image:LeiShe_3"},--Razer战术信使包
	{"#{LSHZ_101008_53}","#{LSHZ_101008_56}", "set:LeiShe4 image:LeiShe_4"},--Razer杀人鲸
	{"#{LSHZ_101008_54}","#{LSHZ_101008_57}", "set:LeiShe5 image:LeiShe_5"},--Razer战神甲虫
	{"#{LSHZ_101008_24}","#{LSHZ_101008_30}", "set:LeiShe6 image:LeiShe_6"}--Razer黒腹狼蛛
}

function LeiShe_PreLoad()
	this:RegisterEvent("UI_COMMAND");
end

function LeiShe_OnLoad()
	this:Hide()
	LeiShe_DragTitle:SetText("")
	LeiShe_Clear()
end

function LeiShe_OnEvent(event)

	if ( event == "UI_COMMAND" and tonumber(arg0) == 20101031) then

			local imageIndex = Get_XParam_INT(0);
			if imageIndex < 1 or imageIndex > 6 then
				return
			end
			local str1 = string.format("#{LSHZ_101008_22}"..LeiSheImage[imageIndex][1])
			local str2 = string.format("#{LSHZ_101008_28}"..LeiSheImage[imageIndex][2])
			local str3 = "#{LSHZ_101008_35}"

			local str4 = "#{LSHZ_101008_34}"

			local showStr = str1.."\n"..str2..str4.."\n"..str3;

--			local imageName = LeiSheImage[imageIndex][1]
			local imageProp = LeiSheImage[imageIndex][3]

--			local showStr = string.format("下图为%s的一角，请你去找到它所在的位置：", imageName)
--			local showStr = string.format("#{TJRW_100511_75}%s#{TJRW_100511_76}", imageName)

			LeiShe_Text:SetText(showStr)
			LeiShe_Image:SetProperty("Image", imageProp);

			this:Show()
--	elseif   ( event == "UI_COMMAND" and tonumber(arg0) == 20100518) then
--		 if(this:IsVisible()) then
--			this:Hide()
--		end
	end

end

--=========================================================
--重置界面
--=========================================================
function LeiShe_Clear()
	LeiShe_Text:SetText("")
	LeiShe_Image:SetProperty("Image", "");
end

--=========================================================
--更新界面
--=========================================================
function LeiShe_Update( pos_ui, pos_packet )

end

--=========================================================
--关闭
--=========================================================
function LeiShe_Close()
	this:Hide()
	LeiShe_Clear()
end

--=========================================================
--界面隐藏
--=========================================================
function LeiShe_OnHide()
	this:Hide()
end
