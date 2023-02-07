
local g_uitype 		= 1;
local g_selectIdx 	= -1
local g_CurUiType 	= -1
local MAX_OBJ_DISTANCE = 3.0;
local g_serverrequest  = 1100
local g_clientNpcId = -1
local g_serverNpcId = -1
local g_DefaultTxt = "请将要使用的道具拖拽到前面的道具框中。";

--*************************************************
--
--*************************************************
function PetPropagateCheck_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("REPLY_MISSION_PET");
	this:RegisterEvent("UPDATE_PET_PAGE");
	this:RegisterEvent("DELETE_PET");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("NEW_DEBUGMESSAGE")
end

function PetPropagateCheck_OnLoad()
end

--*************************************************
--
--*************************************************
function PetPropagateCheck_OnEvent(event)

	if ( event == "UI_COMMAND" ) then
		PetPropagateCheck_UICommand(arg0);

	elseif ( event == "REPLY_MISSION_PET" ) then
		PetPropagateCheck_Selected(tonumber(arg0));

	elseif ( event == "UPDATE_PET_PAGE" ) then
		PetPropagateCheck_Show()

	elseif ( event == "DELETE_PET" ) then
		PetPropagateCheck_Hide()

	elseif ( event == "OBJECT_CARED_EVENT") then
		PetPropagateCheck_CareObj(arg0,arg1,arg2);
	end
end

--*************************************************
--
--*************************************************
function PetPropagateCheck_UICommand(arg0)
	g_CurUiType = -1
	local op = tonumber(arg0);
	if( op ==  g_serverrequest) then

		g_serverNpcId = Get_XParam_INT(0)
		g_clientNpcId = Target:GetServerId2ClientId(g_serverNpcId)
		if (g_clientNpcId == -1) then
			return
		end
		this:CareObject(g_clientNpcId, 1, "PetPropagateCheck")

		g_uitype 	= Get_XParam_INT(1)
		if(g_selectIdx ~= -1) then
			Pet:SetPetLocation(g_selectIdx,-1);
		end
		g_selectIdx = -1

		PetPropagateCheck_PetModel:SetFakeObject( "" )
		PetPropagateCheck_Text1:SetText("#{FZCX_90627_2}")
		PetPropagateCheck_Static3:SetText("#{FZCX_90627_3}")
		this:Show()
		Pet:ShowPetList(1)
		PetPropagateCheck_Accept:Enable()
	elseif( op == 20090907 and 1 == g_uitype ) then
		local nRet = Get_XParam_INT(0)
		if (nRet == 0) then
			PetPropagateCheck_Text1:SetText("#{FZCX_90627_4}");
			PetPropagateCheck_Text1:Show();
			return
		end

		local nLevel = Get_XParam_INT(1)
		if (nLevel == 0) then
			PetPropagateCheck_Text1:SetText("#{FZCX_90627_5}");
			PetPropagateCheck_Text1:Show();
			return
		end
		--local szTip = format( "#cfff263该珍兽上次繁殖的等级是#G"..nLevel.."级#cfff263" )
		PetPropagateCheck_Text1:SetText("#cfff263该珍兽上次繁殖的等级是#G"..nLevel.."级#cfff263");
		PetPropagateCheck_Text1:Show();
	end
end

--*************************************************
--选择不同珍兽时，设置不同的珍兽模型
--*************************************************
function PetPropagateCheck_Selected(selidx)

	if (this:IsVisible() == false) then
		return
	end

	if( -1 == selidx ) then
		return;
	end

	--珍兽已被其它界面选中
	if (Pet:GetPetLocation(selidx) ~= -1) then
		return;
	end
	--切换珍兽的时候，释放上一个珍兽
	if(g_selectIdx ~= -1) then
		Pet:SetPetLocation(g_selectIdx,-1);
	end

	g_selectIdx = tonumber(selidx);	--已经选好了珍兽
	PetPropagateCheck_Text1:SetText("#{FZCX_90627_2}");
	PetPropagateCheck_PetModel:SetFakeObject("");
	Pet:SetPropagateModel(g_selectIdx);
	PetPropagateCheck_PetModel:SetFakeObject( "My_PetPropagate" );
	Pet:SetPetLocation(g_selectIdx,11);
	PetPropagateCheck_Accept:Enable()
end



--*************************************************
-- 旋转珍兽模型（向左)
--*************************************************
function PetPropagateCheck_Modle_TurnLeft(start)
	--向左旋转开始
	if(start == 1) then
		PetPropagateCheck_PetModel:RotateBegin(-0.3);
	--向左旋转结束
	else
		PetPropagateCheck_PetModel:RotateEnd();
	end
end

--*************************************************
--旋转珍兽模型（向右)
--*************************************************
function PetPropagateCheck_Modle_TurnRight(start)
	--向右旋转开始
	if(start == 1) then
		PetPropagateCheck_PetModel:RotateBegin(0.3);
	--向右旋转结束
	else
		PetPropagateCheck_PetModel:RotateEnd();
	end
end


--*************************************************
--处理玩家确认要做的事情，根据g_uitype
--*************************************************
function PetPropagateCheck_Do()
	if (g_selectIdx == nil or g_selectIdx == -1 or g_serverNpcId == -1) then
		PushDebugMessage("请选择你要查询的珍兽！")
		PetPropagateCheck_Text1:SetText("请选择你要查询的珍兽！")
		return
	end

	local slidx = g_selectIdx;	--ListBox选中的索引
	if (1 == g_uitype  ) then
		local hid,lid = Pet:GetGUID(slidx);
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("OnLastPreCreateLevel");
			Set_XSCRIPT_ScriptID(1031);
			Set_XSCRIPT_Parameter(0,g_serverNpcId);
			Set_XSCRIPT_Parameter(1,hid);
			Set_XSCRIPT_Parameter(2,lid);
			Set_XSCRIPT_ParamCount(3);
		Send_XSCRIPT();
		PetPropagateCheck_Accept:Disable()
		return;
	end
end

--*************************************************
--隐藏窗口，清空变量
--*************************************************
function PetPropagateCheck_Frame_OnHiden()
	if (g_clientNpcId ~= -1) then
		this:CareObject(g_clientNpcId, 0, "PetPropagateCheck");
	end
	this:Hide();
	Pet:ShowPetList(-1);
	Pet:SetPetLocation(g_selectIdx,-1);
	g_selectIdx = -1;
	PetPropagateCheck_Hide()
end

--*************************************************
--窗口隐藏函数
--*************************************************
function PetPropagateCheck_Hide()
	if (this:IsVisible() == false) then
		return
	end
	--Pet:ClosePetPropagateCheckMsgBox()
	if (g_clientNpcId ~= -1) then
		this:CareObject(g_clientNpcId, 0, "PetPropagateCheck");
	end
	this:Hide();
	Pet:ShowPetList(-1);
	Pet:SetPetLocation(g_selectIdx,-1);
	g_selectIdx = -1;
end

--*************************************************
--
--*************************************************
function PetPropagateCheck_CareObj(careId, op, distance)
	if(nil == careId or nil == op or nil == distance) then
		return;
	end

	if(tonumber(careId) ~= g_clientNpcId) then
		return;
	end

	if(op == "distance" and tonumber(distance)>MAX_OBJ_DISTANCE or op=="destroy") then
		PetPropagateCheck_Hide();
	end
end

--*************************************************
--
--*************************************************
function PetPropagateCheck_Show()
	if (this:IsVisible() == false) then
		return
	end
	PetPropagateCheck_PetModel:SetFakeObject( "" )
	if(g_selectIdx ~= -1) then
		Pet:SetPetLocation(g_selectIdx,-1);
	end
	g_selectIdx = -1
end
