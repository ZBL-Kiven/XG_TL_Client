--�㳡�û�Э�����(�ͻ���)

function ShowAgreement_PreLoad()
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	this:RegisterEvent("UI_COMMAND")
end


function ShowAgreement_OnLoad()
	
end

function ShowAgreement_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == 88996201) then
		local operType = Get_XParam_INT(0)
		if operType == 1 then
			ShowAgreement_Updata()
		elseif operType == 2 then
			OpenXiuChang()
		end 		
	elseif ( event == "HIDE_ON_SCENE_TRANSED") then
		--�г������ؽ���
		ShowAgreement_Close()
	end
end


function ShowAgreement_Close()
	this:Hide()
end

function ShowAgreement_Updata()
	local ruledes = DataPool:Lua_GetXiuChangUserRuleDes()
	if ruledes ~= nil and ruledes ~= "" then
		ShowAgreement_Context : SetText(ruledes)
	end
	this:Show()
end

--ͬ�ⰴť�ص�
function ShowAgreement_Agree()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("XiuAgreeRule")
		Set_XSCRIPT_ScriptID(889962)
		Set_XSCRIPT_ParamCount(0)
	Send_XSCRIPT()
	ShowAgreement_Close()
end

--ȡ����ť�ص�
function ShowAgreement_DisAgree()
	ShowAgreement_Close()
end


