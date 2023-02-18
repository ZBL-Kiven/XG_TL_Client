
local g_Shanhebaojian_Month = 10
local g_Shanhebaojian_Last_Lock_Day = 7 --10��8�ս�����1��������10��9�ս�����2������������

local g_Shanhebaojian_Updated = 0
local g_Shanhebaojian_Frame_UnifiedPosition

local g_Shanhebaojian_Frame = {
	[1] = {
		button = nil,
		text = nil,
		info = nil,
		frame = nil,
		icon = {}
	},
	[2] = {
		button = nil,
		text = nil,
		info = nil,
		frame = nil,
		icon = {}
	},
	[3] = {
		button = nil,
		text = nil,
		info = nil,
		frame = nil,
		icon = {}
	},
	[4] = {
		button = nil,
		text = nil,
		info = nil,
		frame = nil,
		icon = {}
	},
	[5] = {
		button = nil,
		text = nil,
		info = nil,
		frame = nil,
		icon = {}
	}
}

local g_Shanhebaojian_Items = {
	[1] = {
		-- ����id���������Ƿ���Ҫǿ��
		{ 38002401, 1, 0 }, --����2
		{ 20310168, 10,0 }, --���˿
		{ 20800013, 5, 0 }, --���
		{ 38002176, 1, 0 }  --150��Ԫ��
	},
	[2] = {
		{ 38002402, 1, 0 }, --����3
		{ 30503133, 3, 0 }, --ǧ������
		{ 30700241, 3, 0 }, --������ʯ
		{ 38002176, 1, 0 }  --150��Ԫ��
	},
	[3] = {
		{ 38002403, 1, 0 }, --����4
		{ 30900045, 1, 1 }, --���ǿ��¶
		{ 38002221, 1, 0 }, --3����ʯ���
		{ 38002176, 1, 0 }  --150��Ԫ��
	},
	[4] = {
		{ 38002404, 1, 0 }, --����5
		{ 30502002, 8, 1 }, --�߼����ǵ�
		{ 20310116, 4, 1 }, --���޾���
		{ 38002176, 1, 0 }  --150��Ԫ��
	},
	[5] = {
		{ 38002425, 1, 1 }, --���������
		{ 20502003, 1, 1 }, --3������
		{ 20501003, 1, 1 }, --3���޲�
		{ 38002176, 1, 0 }  --150��Ԫ��
	}
}

function Shanhebaojian_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
end

function Shanhebaojian_OnLoad()
	g_Shanhebaojian_Frame_UnifiedPosition = Shanhebaojian_Frame:GetProperty("UnifiedPosition")

	g_Shanhebaojian_Frame[1].button = Shanhebaojian_Frame1_Button
	g_Shanhebaojian_Frame[2].button = Shanhebaojian_Frame2_Button
	g_Shanhebaojian_Frame[3].button = Shanhebaojian_Frame3_Button
	g_Shanhebaojian_Frame[4].button = Shanhebaojian_Frame4_Button
	g_Shanhebaojian_Frame[5].button = Shanhebaojian_Frame5_Button

	g_Shanhebaojian_Frame[1].text = Shanhebaojian_Frame1_BtnText
	g_Shanhebaojian_Frame[2].text = Shanhebaojian_Frame2_BtnText
	g_Shanhebaojian_Frame[3].text = Shanhebaojian_Frame3_BtnText
	g_Shanhebaojian_Frame[4].text = Shanhebaojian_Frame4_BtnText
	g_Shanhebaojian_Frame[5].text = Shanhebaojian_Frame5_BtnText

	g_Shanhebaojian_Frame[1].info = Shanhebaojian_Frame1_Info
	g_Shanhebaojian_Frame[2].info = Shanhebaojian_Frame2_Info
	g_Shanhebaojian_Frame[3].info = Shanhebaojian_Frame3_Info
	g_Shanhebaojian_Frame[4].info = Shanhebaojian_Frame4_Info
	g_Shanhebaojian_Frame[5].info = Shanhebaojian_Frame5_Info

	g_Shanhebaojian_Frame[1].frame = Shanhebaojian_Frame1_Bk
	g_Shanhebaojian_Frame[2].frame = Shanhebaojian_Frame2_Bk
	g_Shanhebaojian_Frame[3].frame = Shanhebaojian_Frame3_Bk
	g_Shanhebaojian_Frame[4].frame = Shanhebaojian_Frame4_Bk
	g_Shanhebaojian_Frame[5].frame = Shanhebaojian_Frame5_Bk

	g_Shanhebaojian_Frame[1].icon = {
		Shanhebaojian_Frame1_Icon1,
		Shanhebaojian_Frame1_Icon2,
		Shanhebaojian_Frame1_Icon3,
		Shanhebaojian_Frame1_Icon4,
		Shanhebaojian_Frame1_Icon5
	}
	g_Shanhebaojian_Frame[2].icon = {
		Shanhebaojian_Frame2_Icon1,
		Shanhebaojian_Frame2_Icon2,
		Shanhebaojian_Frame2_Icon3,
		Shanhebaojian_Frame2_Icon4,
		Shanhebaojian_Frame2_Icon5
	}
	g_Shanhebaojian_Frame[3].icon = {
		Shanhebaojian_Frame3_Icon1,
		Shanhebaojian_Frame3_Icon2,
		Shanhebaojian_Frame3_Icon3,
		Shanhebaojian_Frame3_Icon4,
		Shanhebaojian_Frame3_Icon5
	}
	g_Shanhebaojian_Frame[4].icon = {
		Shanhebaojian_Frame4_Icon1,
		Shanhebaojian_Frame4_Icon2,
		Shanhebaojian_Frame4_Icon3,
		Shanhebaojian_Frame4_Icon4,
		Shanhebaojian_Frame4_Icon5
	}
	g_Shanhebaojian_Frame[5].icon = {
		Shanhebaojian_Frame5_Icon1,
		Shanhebaojian_Frame5_Icon2,
		Shanhebaojian_Frame5_Icon3,
		Shanhebaojian_Frame5_Icon4,
		Shanhebaojian_Frame5_Icon5
	}
end

function Shanhebaojian_OnEvent(event)

	if ( event == "UI_COMMAND" ) then
		if tonumber(arg0) == 50509901 then
			Shanhebaojian_Update(Get_XParam_INT(0), Get_XParam_INT(1), Get_XParam_INT(2))
			if not this:IsVisible() then
				this:Show()
			end
		end

		if tonumber(arg0) == 50509902 then
			if this:IsVisible() then
				this:Hide()
			end
		end

	elseif (event == "ADJEST_UI_POS" ) then
		Shanhebaojian_Frame_On_ResetPos()

	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		Shanhebaojian_Frame_On_ResetPos()

	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		this:Hide()

	end
end

function Shanhebaojian_UpdateActionItems()
	for i = 1, 5 do
		local num = table.getn(g_Shanhebaojian_Items[i])
		if num > 0 then
			for j = 1, num do
				-- ����iconͼ��
				if g_Shanhebaojian_Items[i][j] ~= nil then
					local theAction = nil
					if g_Shanhebaojian_Items[i][j][3] == 1 then --��Ҫǿ��
						theAction = DataPool:CreateBindActionItemForShow(g_Shanhebaojian_Items[i][j][1], g_Shanhebaojian_Items[i][j][2])
					else
						theAction = DataPool:CreateActionItemForShow(g_Shanhebaojian_Items[i][j][1], g_Shanhebaojian_Items[i][j][2])
					end
					if theAction ~= nil and theAction:GetID() ~= 0 and g_Shanhebaojian_Frame[i].icon[j] ~= nil then
						g_Shanhebaojian_Frame[i].icon[j]:SetActionItem(theAction:GetID())
					end
				end
			end
		end
	end
	g_Shanhebaojian_Updated = 1
end

function Shanhebaojian_Update(idx, id_unlock, id_can_get)
	if g_Shanhebaojian_Updated == 0 then
		Shanhebaojian_UpdateActionItems()

	end

	for i = 1, 5 do
		if idx > i then --֮ǰ�ı����϶����ѽ�����
			g_Shanhebaojian_Frame[i].button:Disable()
			g_Shanhebaojian_Frame[i].text:SetText("#{SHYBJ_20210805_10}")
			g_Shanhebaojian_Frame[i].info:Hide()
			g_Shanhebaojian_Frame[i].frame:SetProperty("Image", "set:Shanhebaojian image:SHBJ_Frame3")
		elseif i == id_can_get then --�ɽ���
			g_Shanhebaojian_Frame[i].button:Enable()
			g_Shanhebaojian_Frame[i].text:SetText("#{SHYBJ_20210805_08}")
			g_Shanhebaojian_Frame[i].info:SetText( ScriptGlobal_Format("#{SHYBJ_20210805_20}", tostring(6)) ) --����6������
			g_Shanhebaojian_Frame[i].info:Show()
			g_Shanhebaojian_Frame[i].frame:SetProperty("Image", "set:Shanhebaojian image:SHBJ_Frame1")
		elseif id_unlock >= i then --����״̬ �Ѿ�������ʱ��
			g_Shanhebaojian_Frame[i].button:Disable()
			g_Shanhebaojian_Frame[i].text:SetText("#{SHYBJ_20210805_19}")
			g_Shanhebaojian_Frame[i].info:Hide()
			g_Shanhebaojian_Frame[i].frame:SetProperty("Image", "set:Shanhebaojian image:SHBJ_Frame2")
		else --��������ʱ��
			g_Shanhebaojian_Frame[i].button:Disable()
			g_Shanhebaojian_Frame[i].text:SetText("#{SHYBJ_20210805_19}")
			g_Shanhebaojian_Frame[i].info:SetText( ScriptGlobal_Format("#{SHYBJ_20210805_11}", tostring(g_Shanhebaojian_Month), tostring(g_Shanhebaojian_Last_Lock_Day + i)) )
			g_Shanhebaojian_Frame[i].info:Show()
			g_Shanhebaojian_Frame[i].frame:SetProperty("Image", "set:Shanhebaojian image:SHBJ_Frame2")
		end
	end

end

function Shanhebaojian_GetGift(idx)
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OpenBaoZang")
		Set_XSCRIPT_ScriptID(505099)
		Set_XSCRIPT_Parameter(0, idx)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
end

function Shanhebaojian_Close_Click()
	this:Hide()
end

function Shanhebaojian_Frame_On_ResetPos()
	Shanhebaojian_Frame:SetProperty("UnifiedPosition", g_Shanhebaojian_Frame_UnifiedPosition)
end