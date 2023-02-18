--!!!reloadscript =BeiZhu
local g_BeiZhu_Channel = -1
local g_BeiZhu_Index = -1
local g_BeiZhu_Id = -1
local g_BeiZhu_ZoneworldId = -1
local g_BeiZhu_Name = ""
local g_BeiZhu_Remark = ""

function BeiZhu_PreLoad()
	this:RegisterEvent("OPEN_REMARK")
end

function BeiZhu_OnLoad()

end

function BeiZhu_OnEvent(event)
	if event == "OPEN_REMARK" then
		g_BeiZhu_Channel = tonumber(arg0)
		g_BeiZhu_Index = tonumber(arg1)		
		local strName = DataPool:GetFriend(g_BeiZhu_Channel, g_BeiZhu_Index, "NAME")
		local strRemark = DataPool:GetFriend(g_BeiZhu_Channel, g_BeiZhu_Index, "REMARK")
		local strTemp = ScriptGlobal_Format("#{BZXX_140915_15}", strName)
		BeiZhu_Text1:SetText(strTemp)
		BeiZhu_FeudalName:SetText(strRemark)
		BeiZhu_FeudalName:SetProperty("DefaultEditBox", "true")
		this:Show()
	end

end

function BeiZhu_Release_Button_Clicked()
	local guid = DataPool:GetFriend(g_BeiZhu_Channel, g_BeiZhu_Index, "ID")
	local strRemark = BeiZhu_FeudalName:GetText()

	DataPool:SetRemark(guid, strRemark)
	this:Hide()
end
