local DianDang_Button = {}
local DianDang_Frame = {}
local NewItemPos = -1
local ItemNum = -1
local straa = 0
function DianDang_PreLoad()
    this:RegisterEvent("UI_COMMAND")
    this:RegisterEvent("PLAYER_ENTERING_WORLD")	--进场景关闭界面
end

function DianDang_OnLoad()
	DianDang_Button[1] = DianDang_Button01
	DianDang_Button[2] = DianDang_Button02
	DianDang_Frame[1]  = DianDang_Frame1
	DianDang_Frame[2]  = DianDang_Frame2
	DianDang_HuiShou:Disable()
	DianDang_ChageTable(1)
end

function DianDang_OnEvent(event)
	if event == "UI_COMMAND"  and tonumber(arg0) == 20191218 then
		--默认打开选中第一页
		DianDang_Button01:SetCheck(1)
		this:Show()	
	end
	if event == "UI_COMMAND"  and tonumber(arg0) == 201107281 then
	if arg1~= nil then
		Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("HuiShou")
		Set_XSCRIPT_ScriptID(999998)
		Set_XSCRIPT_Parameter(0,2)
		Set_XSCRIPT_Parameter(1,tonumber(arg1))
		Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT();    
	DianDang_UpData(tonumber(arg1) )   
	end   
	end
	if event == "UI_COMMAND"  and tonumber(arg0) == 201912181 then
		straa=Get_XParam_INT(0);
		DianDang_NumFrame:SetText("拥有数量："..straa)
	end
	if event == "UI_COMMAND"  and tonumber(arg0) == 201912182 then--赎回界面数据更新
		DianDang_lvwEquipTitle:RemoveAllItem()
		local PaimingNam = {}
		local ChongzhiPaiming = {}
		for i =1,12 do	
			ChongzhiPaiming[i] = Get_XParam_STR(i-1)
			if ChongzhiPaiming[i] == nil then
				return
			end
			PaimingNam[i] = Split(ChongzhiPaiming[i], ",")
			if PaimingNam[i] ~=nil and  PaimingNam[i][1] ~= ""  then
				DianDang_lvwEquipTitle:AddNewItem("#e660066"..PaimingNam[i][1],0,i-1)
				DianDang_lvwEquipTitle:AddNewItem("#e660066"..PaimingNam[i][2],1,i-1)
				DianDang_lvwEquipTitle:AddNewItem("#e660066"..PaimingNam[i][3],2,i-1)
				DianDang_lvwEquipTitle:AddNewItem("#e660066"..PaimingNam[i][4],3,i-1)	
			end
		end	
	end
	
    --进场景关闭界面
    if ( event == "PLAYER_ENTERING_WORLD" ) then  
        DianDang_Close()
    end
end
function DianDang_UpData(arg1)
	DianDang_ClaerItem()
	local theAction = EnumAction(arg1, "packageitem");
	if theAction:GetID() ~= 0 then
		NewItemPos = arg1
		LifeAbility : Lock_Packet_Item(arg1,1)
		DianDang_Item:SetActionItem(theAction:GetID());
		DianDang_HuiShou:Enable()
	end
end


function DianDang_Close()
	this:Hide()
	DianDang_ClaerItem()
end


function DianDang_ChageTable(idx)
	for i = 1,table.getn(DianDang_Button) do
		DianDang_Button[i]:SetCheck(0)
		DianDang_Frame[i]:Hide()
	end
	DianDang_Button[idx]:SetCheck(1)
	DianDang_Frame[idx]:Show()
	if idx == 2 then
		 Clear_XSCRIPT();
		 Set_XSCRIPT_Function_Name("HuiShou")
		 Set_XSCRIPT_ScriptID(999998)
		 Set_XSCRIPT_Parameter(0,4)
		 Set_XSCRIPT_ParamCount(1)
		 Send_XSCRIPT();
	end
end


function DianDang_ClaerItem()
	DianDang_Item:SetActionItem(-1);
	LifeAbility : Lock_Packet_Item(NewItemPos,0);
	NewItemPos = -1
end


function DianDang_Clicked()
	local nAge = DianDang_NumText:GetText();
		ItemNum = tonumber(nAge)

	if NewItemPos == -1 then
		PushDebugMessage("没有放入回收物品")
		return
	end
	if ItemNum == -1 then
		PushDebugMessage("未知的数量错误")
		return
	end
	if ItemNum >straa then
		PushDebugMessage("回收数量大于拥有数量，无法回收")
		return
	end
	Clear_XSCRIPT();
	Set_XSCRIPT_Function_Name("HuiShou")
	Set_XSCRIPT_ScriptID(999998)
	Set_XSCRIPT_Parameter(0,3)
	Set_XSCRIPT_Parameter(1,NewItemPos)
	Set_XSCRIPT_Parameter(2,ItemNum)	 
	Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT();
end

function DianDang_Clickeda()
     local nIdex = DianDang_lvwEquipTitle:GetSelectItem()
	 Clear_XSCRIPT();
	 Set_XSCRIPT_Function_Name("HuiShou")
	 Set_XSCRIPT_ScriptID(999998)
	 Set_XSCRIPT_Parameter(0,5)
	 Set_XSCRIPT_Parameter(1,nIdex)
	 Set_XSCRIPT_ParamCount(2)
	 Send_XSCRIPT();
end