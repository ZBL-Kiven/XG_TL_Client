local YIGUI_BUTTON = {}
local YIGUI_BUTTON_NUM = 30
local YIGUI_FIRST_SIZE = 15


local YIGUI_DRESS_NUM = 5
local YIGUI_DRESS_MODEL = {} --模型显示控件
local YIGUI_DRESS_NULL	= {} --衣架
local YIGUI_DRESS_BUTTON = {} --展示按钮
local YIGUI_DRESS_TEXT = {} --衣服名字 文字
local YIGUI_DRESS_FG_TEXT = {} --风格 文字

local YIGUI_DRESS_ITEM_INDEX  = {-1,-1,-1,-1,-1} --衣柜模型显示对应物品ID

local YIGUI_DRESS_ITEM_SELECT = -1     --玩家选中的衣柜模型   -1表示为空

local nCareNpcID = -1
local MAX_OBJ_DISTANCE = 3.0;

local g_YiGui_Frame_UnifiedPosition = 0

local g_CurSelectPage = 1


function DressBoxFrame_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("YIGUI_UPDATE")
	this:RegisterEvent("YIGUI_CLOSE")
	this:RegisterEvent("OBJECT_CARED_EVENT", false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED", false)
	this:RegisterEvent("ADJEST_UI_POS", false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED", false)	--进场景关闭界面

	-- FakeObject模型界面互斥
	this:RegisterEvent("OPEN_SHOP_FITTING", false);				-- 元宝商店试衣间
	this:RegisterEvent("OPEN_DRESS_PAINT_FITTING", false);			-- 时装染色试衣间
	this:RegisterEvent("OPEN_DRESS_ENCHASE_FITTING", false);		-- 时装镶嵌试衣间
	
end

function DressBoxFrame_OnLoad()
	YIGUI_BUTTON[1] = DressBox_Bank1
	YIGUI_BUTTON[2] = DressBox_Bank2
	YIGUI_BUTTON[3] = DressBox_Bank3
	YIGUI_BUTTON[4] = DressBox_Bank4
	YIGUI_BUTTON[5] = DressBox_Bank5
	YIGUI_BUTTON[6] = DressBox_Bank6
	YIGUI_BUTTON[7] = DressBox_Bank7
	YIGUI_BUTTON[8] = DressBox_Bank8
	YIGUI_BUTTON[9] = DressBox_Bank9
	YIGUI_BUTTON[10] = DressBox_Bank10
	YIGUI_BUTTON[11] = DressBox_Bank11
	YIGUI_BUTTON[12] = DressBox_Bank12
	YIGUI_BUTTON[13] = DressBox_Bank13
	YIGUI_BUTTON[14] = DressBox_Bank14
	YIGUI_BUTTON[15] = DressBox_Bank15

	YIGUI_BUTTON[16] = DressBox_Bank1_2
	YIGUI_BUTTON[17] = DressBox_Bank2_2
	YIGUI_BUTTON[18] = DressBox_Bank3_2
	YIGUI_BUTTON[19] = DressBox_Bank4_2
	YIGUI_BUTTON[20] = DressBox_Bank5_2
	YIGUI_BUTTON[21] = DressBox_Bank6_2
	YIGUI_BUTTON[22] = DressBox_Bank7_2
	YIGUI_BUTTON[23] = DressBox_Bank8_2
	YIGUI_BUTTON[24] = DressBox_Bank9_2
	YIGUI_BUTTON[25] = DressBox_Bank10_2
	YIGUI_BUTTON[26] = DressBox_Bank11_2
	YIGUI_BUTTON[27] = DressBox_Bank12_2
	YIGUI_BUTTON[28] = DressBox_Bank13_2
	YIGUI_BUTTON[29] = DressBox_Bank14_2
	YIGUI_BUTTON[30] = DressBox_Bank15_2

	YIGUI_DRESS_MODEL[1] = Dress_1_Model
	YIGUI_DRESS_MODEL[2] = Dress_2_Model
	YIGUI_DRESS_MODEL[3] = Dress_3_Model
	YIGUI_DRESS_MODEL[4] = Dress_4_Model
	YIGUI_DRESS_MODEL[5] = Dress_5_Model

	YIGUI_DRESS_NULL[1]	= Dress_1_Null
	YIGUI_DRESS_NULL[2]	= Dress_2_Null
	YIGUI_DRESS_NULL[3]	= Dress_3_Null
	YIGUI_DRESS_NULL[4]	= Dress_4_Null
	YIGUI_DRESS_NULL[5]	= Dress_5_Null

	YIGUI_DRESS_BUTTON[1] = Dress_1_Button
	YIGUI_DRESS_BUTTON[2] = Dress_2_Button
	YIGUI_DRESS_BUTTON[3] = Dress_3_Button
	YIGUI_DRESS_BUTTON[4] = Dress_4_Button
	YIGUI_DRESS_BUTTON[5] = Dress_5_Button

	YIGUI_DRESS_TEXT[1] = Dress_1_Text
	YIGUI_DRESS_TEXT[2] = Dress_2_Text
	YIGUI_DRESS_TEXT[3] = Dress_3_Text
	YIGUI_DRESS_TEXT[4] = Dress_4_Text
	YIGUI_DRESS_TEXT[5] = Dress_5_Text

	YIGUI_DRESS_FG_TEXT[1] = Dress_1_Text2
	YIGUI_DRESS_FG_TEXT[2] = Dress_2_Text2
	YIGUI_DRESS_FG_TEXT[3] = Dress_3_Text2
	YIGUI_DRESS_FG_TEXT[4] = Dress_4_Text2
	YIGUI_DRESS_FG_TEXT[5] = Dress_5_Text2

	g_YiGui_Frame_UnifiedPosition = DressBox_Frame:GetProperty("UnifiedPosition")

end


function DressBoxFrame_OnEvent(event)
	if (event == "UI_COMMAND" and tonumber(arg0) == 202112041) then
		DressBoxFrame_Open()
		
    elseif (event == "YIGUI_UPDATE")	then
    	DressBoxFrame_Update()
    elseif (event == "YIGUI_CLOSE") then
		DressBoxFrame_CloseWindow()
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		this:Hide()
    elseif (event == "OBJECT_CARED_EVENT") then

		if(tonumber(arg0) ~= nCareNpcID) then
			return;
		end
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			this:Hide()

			--取消关心
			this:CareObject(nCareNpcID, 0, "DressBoxFrame");
		end
	elseif (event == "OPEN_SHOP_FITTING") or
	       (event == "OPEN_DRESS_PAINT_FITTING") or
	       (event == "OPEN_DRESS_ENCHASE_FITTING") then
        	this:Hide()
		--取消关心
		this:CareObject(nCareNpcID, 0, "DressBoxFrame");
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		DressBoxFrame_On_ResetPos()
	elseif (event == "ADJEST_UI_POS") then
		DressBoxFrame_On_ResetPos()
	end
end

function DressBoxFrame_Open()

	if IsWindowShow("YueKa") then
		CloseWindow("YueKa", true)
	end
	
	this:Show()
	nCareNpcID = Get_XParam_INT( 0 );
	if nCareNpcID == -1 then
		--DressBox_DragTitle:SetText("#{VIPTQ_120221_20}")
	else
		DressBox_DragTitle:SetText("#{YG_INTERFACE_01}")
		this:CareObject(nCareNpcID,1,"DressBoxFrame")
	end

	local i =1
	for i =1 ,YIGUI_DRESS_NUM do
		YIGUI_DRESS_ITEM_INDEX[i] = -1
	end
	
	YIGUI_DRESS_ITEM_SELECT = -1
	g_CurSelectPage = 1

    DressBoxFrame_Update()
end

function DressBoxFrame_Update()
	DressBoxFrame_Clear()
	local   nYiGuiSize = 30
	local   i=1
	local   nActiveCount = 0
	local   nIndex = 1

	if g_CurSelectPage == 1 then
		if nYiGuiSize > YIGUI_FIRST_SIZE then
			nYiGuiSize = YIGUI_FIRST_SIZE
		end
	elseif g_CurSelectPage == 2 then
		if nYiGuiSize > YIGUI_FIRST_SIZE then
			nActiveCount = YIGUI_BUTTON_NUM - YIGUI_FIRST_SIZE
		end
		nIndex = 1 + YIGUI_FIRST_SIZE
	end
	
	PushDebugMessage("nIndex "..nIndex)
	for i=nIndex,nYiGuiSize do
		YIGUI_BUTTON[i]:Enable()
        YIGUI_BUTTON[i]:Show()
		-- local kAction = YiGui:EnumItem(i - 1)
		if kAction:GetID() ~= 0 then
        	YIGUI_BUTTON[i]:SetActionItem(kAction:GetID());
		else
		    YIGUI_BUTTON[i]:SetActionItem(-1)
	    end
	end

	DressBoxFrame_FrefreshDressYiGuiAfterMove()
	DressBoxFrame_RevertDressShow()

	-- YiGui:ResetYiGuiMoveFlag()

end

function DressBoxFrame_BtnClicked(nIndex)

	if(YIGUI_BUTTON[nIndex]:GetActionItem() == -1) then
	    return
	end

    local i=1
	for i = 1,YIGUI_DRESS_NUM do
        if  YIGUI_DRESS_ITEM_INDEX[i] == nIndex then
			
			YIGUI_DRESS_MODEL[i]:SetFakeObject("")				
			YIGUI_DRESS_NULL[i]:Show()
			YIGUI_DRESS_BUTTON[i]:SetCheck(0)
			if YIGUI_DRESS_ITEM_SELECT  == i then
				YIGUI_DRESS_ITEM_SELECT = -1
			end
           
			YIGUI_DRESS_TEXT[i]:SetProperty( "Text", "" )
			YIGUI_DRESS_FG_TEXT[i]:SetProperty( "Text", "" )
        	YIGUI_BUTTON[YIGUI_DRESS_ITEM_INDEX[i]]:SetPushed(0)
        	YIGUI_DRESS_ITEM_INDEX[i] = -1        	
            return
        end
    end
	local nSelectResult = -1;
	for i = 1 , YIGUI_DRESS_NUM	do
	    if YIGUI_DRESS_ITEM_INDEX[i] == -1 then
			nSelectResult = i
          	break
		end
	end

	if(nSelectResult == -1) then
	    PushDebugMessage("#{YG_20100809_33}")
	    return
	end
	
	YiGui:SetShowDress(nSelectResult-1,nIndex-1)	
	
	YIGUI_DRESS_MODEL[nSelectResult]:SetFakeObject("")
	YIGUI_DRESS_MODEL[nSelectResult]:SetFakeObject("YiGuiAvatar_Player"..tostring(nSelectResult-1))
  	YIGUI_DRESS_NULL[nSelectResult]:Hide()
  	local strItemName, fengGe, nRate, nDressId = YiGui:EnumItemName(nIndex-1)
  	YIGUI_DRESS_TEXT[nSelectResult]:SetProperty( "Text", strItemName )
  	local strdic = "#G"..fengGe;

  	if nRate == 23000 then
		strdic = ScriptGlobal_Format("#{SZRSYH_120912_10}", fengGe)
	elseif nRate == 14000 then
		strdic = ScriptGlobal_Format("#{SZRSYH_120912_11}", fengGe)
	elseif nRate == 1000 then
		strdic = ScriptGlobal_Format("#{SZRSYH_120912_12}", fengGe)
	elseif nRate == -1 then
		strdic = "#G"..fengGe
	elseif nRate == 0 then
		-- 如果是非染色时装，看是否存在特殊风格，有特殊风格显示内容
		local exist, str_sp = YiGui:GetFashionSpecialVisualName(nDressId)
		if exist > 0 then
			strdic = str_sp
		end
	end
	
  	YIGUI_DRESS_FG_TEXT[nSelectResult]:SetText(strdic )
	YIGUI_BUTTON[nIndex]:SetPushed(1)
	YIGUI_DRESS_ITEM_INDEX[nSelectResult] = nIndex

	YiGui:PlayDressAction(nSelectResult-1)
end


function DressBoxFrame_RBtnClicked(nIndex)
	YIGUI_BUTTON[nIndex]:DoAction()
end

function DressBoxFrame_Clear()
	local i = 1
	for i=1,YIGUI_DRESS_NUM do
		YIGUI_DRESS_MODEL[i]:SetFakeObject("")
		YIGUI_DRESS_TEXT[i]:SetProperty( "Text", "" )
		YIGUI_DRESS_FG_TEXT[i]:SetProperty( "Text", "" )
		YIGUI_DRESS_NULL[i]:Show()
		YIGUI_DRESS_BUTTON[i]:SetCheck(0)
	end
	for i=1,YIGUI_BUTTON_NUM do
		YIGUI_BUTTON[i]:SetProperty("Empty", "False")
		YIGUI_BUTTON[i]:Disable()
	end

	if g_CurSelectPage == 1 then
		DressBox_Bank_2:Hide()
		DressBox_Bank_2:Disable()
		DressBox_Bank:Show()
		DressBox_Bank:Enable()
		DressBox_Left:Disable()
		DressBox_Right:Enable()
	elseif g_CurSelectPage == 2 then
		DressBox_Bank_2:Show()
		DressBox_Bank_2:Enable()
		DressBox_Bank:Hide()
		DressBox_Bank:Disable()
		DressBox_Left:Enable()
		DressBox_Right:Disable()
	end

end

function DressBoxFrame_DressUp_Click()
    --PushDebugMessage("穿衣 pushde")
	if(YIGUI_DRESS_ITEM_SELECT ~= -1) then		
		if YIGUI_DRESS_ITEM_INDEX[YIGUI_DRESS_ITEM_SELECT] ~= -1 then
			YiGui:EquipDressAskBind(YIGUI_DRESS_ITEM_INDEX[YIGUI_DRESS_ITEM_SELECT] - 1)
		end				
	else
		PushDebugMessage("#{YG_20100809_39}")
	end
end

function DressBoxFrame_CloseWindow()
	this:CareObject(nCareNpcID, 0, "DressBoxFrame");
	nCareNpcID = -1;
	this:Hide()
end


function DressBoxFrame_DressButton_BtnClick(nIndex)

	if (YIGUI_DRESS_ITEM_INDEX[nIndex] ~= -1) then
        YIGUI_DRESS_ITEM_SELECT = nIndex
    else
		YIGUI_DRESS_BUTTON[nIndex]:SetCheck(0)
	end
end

function DressBoxFrame_DressButton_RBtnClick(nIndex)

	if (YIGUI_DRESS_ITEM_INDEX[nIndex] ~= -1) then
        YIGUI_DRESS_MODEL[nIndex]:SetFakeObject("")
        YIGUI_DRESS_TEXT[nIndex]:SetProperty( "Text", "" )
        YIGUI_DRESS_FG_TEXT[nIndex]:SetProperty( "Text", "" )
        YIGUI_BUTTON[YIGUI_DRESS_ITEM_INDEX[nIndex]]:SetPushed(0)		
        YIGUI_DRESS_ITEM_INDEX[nIndex] = -1
        YIGUI_DRESS_NULL[nIndex]:Show()
        YIGUI_DRESS_BUTTON[nIndex]:SetCheck(0)
  		if YIGUI_DRESS_ITEM_SELECT  == nIndex then
                YIGUI_DRESS_ITEM_SELECT = -1
        end
	end
end

function DressBoxFrame_Fitting_TurnLeft(nIndex,nBeginOrEnd)
     --PushDebugMessage("Enter Fitting TurnLeft"..nIndex);

	if (YIGUI_DRESS_ITEM_INDEX[nIndex] == -1) then
		return
	end

	local mouse_button =CEArg:GetValue("MouseButton")
	if (mouse_button == "LeftButton") then
	    if(nBeginOrEnd == 1) then
	        YIGUI_DRESS_MODEL[nIndex]:RotateBegin(-0.3)
		else
            YIGUI_DRESS_MODEL[nIndex]:RotateEnd()
	    end
	end
end


function DressBoxFrame_Fitting_TurnRight(nIndex,nBeginOrEnd)

    --PushDebugMessage("Enter Fitting TurnRight"..nIndex);
	if (YIGUI_DRESS_ITEM_INDEX[nIndex] == -1) then
		return
	end

	local mouse_button =CEArg:GetValue("MouseButton")
	if (mouse_button == "LeftButton") then
	    if(nBeginOrEnd == 1) then
	        YIGUI_DRESS_MODEL[nIndex]:RotateBegin(0.3)
		else
            YIGUI_DRESS_MODEL[nIndex]:RotateEnd()
	    end
	end
end

function DressBoxFrame_RevertDressShow()
    --PushDebugMessage("debug enter ReverDressShow");
	local i =1
	for i = 1,YIGUI_DRESS_NUM   do
        --PushDebugMessage("debug enter ReverDres In For");
		if  YIGUI_DRESS_ITEM_INDEX[i] ~= -1 then
	        --PushDebugMessage("debug enter ReverDres have Dress"..tostring(i-1));

			YIGUI_DRESS_MODEL[i]:SetFakeObject("YiGuiAvatar_Player"..tostring(i-1))
			local strItemName, fengGe, nRate, nDressId = YiGui:EnumItemName(YIGUI_DRESS_ITEM_INDEX[i]-1)
			YIGUI_DRESS_TEXT[i]:SetProperty( "Text", strItemName )
			local strdic = "#G"..fengGe;
			if nRate == 23000 then
				strdic = ScriptGlobal_Format("#{SZRSYH_120912_10}", fengGe)
			elseif nRate == 14000 then
				strdic = ScriptGlobal_Format("#{SZRSYH_120912_11}", fengGe)
			elseif nRate == 1000 then
				strdic = ScriptGlobal_Format("#{SZRSYH_120912_12}", fengGe)
			elseif nRate == -1 then
				strdic = "#G"..fengGe
			elseif nRate == 0 then
				-- 如果是非染色时装，看是否存在特殊风格，有特殊风格显示内容
				local exist, str_sp = YiGui:GetFashionSpecialVisualName(nDressId)
				if exist > 0 then		
					strdic = str_sp
				end
			end
			YIGUI_DRESS_FG_TEXT[i]:SetText(strdic )
			YIGUI_DRESS_NULL[i]:Hide()
			YIGUI_BUTTON[YIGUI_DRESS_ITEM_INDEX[i]]:SetPushed(1)
	
	    end
	end
end


--按照移动调整衣柜展示
function DressBoxFrame_FrefreshDressYiGuiAfterMove()
	local nIndexFrom	= YiGui:GetYiGuiMoveFromIndex() + 1
	local nIndexTo		= YiGui:GetYiGuiMoveToIndex() + 1

	if(nIndexFrom ~= 0) or (nIndexTo ~= 0) then
		if((nIndexFrom ~= 0) and (nIndexTo ~= 0))  then
			local i = 1
			local bFromHavePushed = false
			local bToHavePushed = false

			for i = 1,YIGUI_DRESS_NUM do
				if YIGUI_DRESS_ITEM_INDEX[i] == nIndexFrom then
					YIGUI_DRESS_ITEM_INDEX[i] = nIndexTo
					bFromHavePushed = true
				elseif YIGUI_DRESS_ITEM_INDEX[i] == nIndexTo then
					YIGUI_DRESS_ITEM_INDEX[i] = nIndexFrom
					bToHavePushed = true
				end
			end
			if bFromHavePushed == true and bToHavePushed == false then
				YIGUI_BUTTON[nIndexFrom]:SetPushed(0)
				YIGUI_BUTTON[nIndexTo]:SetPushed(1)
			end
			if bFromHavePushed == false and bToHavePushed == true then
				YIGUI_BUTTON[nIndexFrom]:SetPushed(1)
				YIGUI_BUTTON[nIndexTo]:SetPushed(0)
			end
		else
			if (nIndexFrom == 0) then
				local i = 1
				for i = 1,YIGUI_DRESS_NUM do
					if YIGUI_DRESS_ITEM_INDEX[i] == nIndexTo then
						YIGUI_DRESS_MODEL[i]:SetFakeObject("")
						YIGUI_DRESS_TEXT[i]:SetProperty( "Text", "" )
						YIGUI_DRESS_FG_TEXT[i]:SetProperty( "Text", "" )
						YIGUI_BUTTON[YIGUI_DRESS_ITEM_INDEX[i]]:SetPushed(0)
						YIGUI_DRESS_ITEM_INDEX[i] = -1
						YIGUI_DRESS_BUTTON[i]:SetCheck(0)
						YIGUI_DRESS_NULL[i]:Show()
					end
				end
			elseif(nIndexTo == 0) then
				for i = 1,YIGUI_DRESS_NUM do
					if YIGUI_DRESS_ITEM_INDEX[i] == nIndexFrom then
						YIGUI_DRESS_MODEL[i]:SetFakeObject("")
						YIGUI_DRESS_TEXT[i]:SetProperty( "Text", "" )
						YIGUI_DRESS_FG_TEXT[i]:SetProperty( "Text", "" )
						YIGUI_BUTTON[YIGUI_DRESS_ITEM_INDEX[i]]:SetPushed(0)
						YIGUI_DRESS_ITEM_INDEX[i] = -1
						YIGUI_DRESS_BUTTON[i]:SetCheck(0)
						YIGUI_DRESS_NULL[i]:Show()
					end
				end
			end

		end
	end
	
	
end
 


function DressBoxFrame_DressButton_MouseEnter()
   DressBox_Info:SetText("#{YG_20100809_37}" )
end


function DressBoxFrame_DressButton_MouseLeave()
    DressBox_Info:SetText("")
end

function DressBoxFrame_DressBox_MouseEnter()
	DressBox_Info:SetText("#{YG_20100809_36}" )
end


function DressBoxFrame_DressBox_MouseLeave()
     DressBox_Info:SetText("")
end

function DressBoxFrame_DressUp_MouseEnter()
	DressBox_Info:SetText("#{YG_20100809_38}")
end

function DressBoxFrame_DressUp_MouseLeave()
    DressBox_Info:SetText("")
end

function DressBoxFrame_On_ResetPos()
	DressBox_Frame:SetProperty("UnifiedPosition",g_YiGui_Frame_UnifiedPosition);
end

--前一页
function DressBox_Left_Click()
	if g_CurSelectPage ~= 1 then
		g_CurSelectPage = 1
		DressBoxFrame_Update()
	end
end

--后一页
function DressBox_Right_Click()
	if g_CurSelectPage ~= 2 then
		g_CurSelectPage = 2
		DressBoxFrame_Update()
	end
end

