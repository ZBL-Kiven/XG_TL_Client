-- 天机锦囊批量取出
-- 清微子 2021-5-25 21:16:30

Packet_MaxCount = 0
Packet_ItemId = -1
Packet_Bind = 0
MousePos = 0
QuChuCount = 0
g_CurrentRentBox = 0
pos = 0
function Packet_PiLiang_PreLoad()
	this:RegisterEvent("UI_COMMAND");
end

function Packet_PiLiang_OnLoad()

end
function Packet_PiLiang_OnEvent(event)
	if(event == "UI_COMMAND" and tonumber(arg0) == 2021052521) then
		Packet_MaxCount = tonumber(arg2)
		Packet_ItemId = tonumber(arg1)
		Packet_Bind = tonumber(arg3)
		g_CurrentRentBox = tonumber(arg4)
		pos = tonumber(arg5)
		if Packet_MaxCount <= 0 then
			return
		end
		if Packet_MaxCount == 1 then
			--走服务端
			Clear_XSCRIPT();
				Set_XSCRIPT_Function_Name("PacketTemporaryTakeout");
				Set_XSCRIPT_ScriptID(900017);
				Set_XSCRIPT_Parameter(0,g_CurrentRentBox)
				Set_XSCRIPT_Parameter(1,pos)
				Set_XSCRIPT_Parameter(2,1)
				Set_XSCRIPT_ParamCount(3)
			Send_XSCRIPT();	
			return
		end
		Packet_PiLiang_Update()
		this:Show()
	end
end
function Packet_PiLiang_Update()
	local tAction = GemMelting:UpdateProductAction(Packet_ItemId)
	Packet_PiLiang_ItemInfo_Text:SetText("#G"..tAction:GetName())
	Packet_PiLiang_Item:SetActionItem(tAction:GetID())
	Packet_PiLiang_InputNum:SetProperty("DefaultEditBox", "True");
	Packet_PiLiang_InputNum:SetText("1");
	Packet_PiLiang_InputNum:SetSelected( 0, -1 );	
end

function Packet_PiLiang_MouseEnter()
	MousePos = 1
end
function Packet_PiLiang_MouseLeave()
	MousePos = 0
end
function LuaFnGetPacketPiLiangMousePos()
	return MousePos,Packet_Bind
end
--点击最大
function Packet_PiLiang_CalMax()
	if Packet_MaxCount < 1 then
		Packet_MaxCount = 1
	end
	Packet_PiLiang_InputNum:SetText(tostring(Packet_MaxCount));
end

--点击确定
function Packet_PiLiang_BuyMulti_Clicked()
	local Num = tonumber(Packet_PiLiang_InputNum:GetText())
	if Num ~= nil  and Num > 0 then
		QuChuCount = Num
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("PacketTemporaryTakeout");
			Set_XSCRIPT_ScriptID(900017);
			Set_XSCRIPT_Parameter(0,g_CurrentRentBox)
			Set_XSCRIPT_Parameter(1,pos)
			Set_XSCRIPT_Parameter(2,Num)
			Set_XSCRIPT_ParamCount(3)
		Send_XSCRIPT();	
		Packet_PiLiang_Close_Clicked()
	else
		PushDebugMessage("请输入正确取出数量！")
		return
	end

end
function LuaFnGetPacket_PiLiang_QuChuNum()
	local quchu = QuChuCount
	QuChuCount = 0
	return quchu
end

function Packet_PiLiang_Close_Clicked()
	Packet_MaxCount = 0
	MousePos = 0
	Packet_Bind = 0
	Packet_ItemId = -1
	this:Hide()
end