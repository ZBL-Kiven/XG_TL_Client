--Create By MD
local g_FrameInfo = -1				--当前窗口确认的类型
local g_FrameEvent = -1       --当前使用哪个窗口事件
local g_YIMIN_OBJ_DISTANCE = 3.0
local g_Yimin_Gain_NPCID = -1
local FrameInfoList = {
	CONFIRM_IMMIGRATION  = 1,				 			 -- 确认
	CONFIRM_IMMIGRATION_SPOUSE  = 2,			 -- 夫妻 确认
}
--确认框缓存变量，用于点击确定和取消时做处理, 每个变量的意义，根据界面不同各不相同，请使用者用到时自己注释
local g_FrameVar = {
	[1] = 0,
	[2] = 0,
	[3] = 0,
	[4] = 0,
	[5] = 0,
	[6] = 0,
	[7] = 0,
	[8] = 0,
}
function YiMin_ReadMe_PreLoad()
	this:RegisterEvent("SCENE_TRANSED");
	this:RegisterEvent("UI_COMMAND");
    this:RegisterEvent("OBJECT_CARED_EVENT",false)
end

function YiMin_ReadMe_OnLoad()
	YiMin_ReadMe_Frame:SetProperty("AlwaysOnTop", "True");
end

function YiMin_ReadMeUpdateRect()
--	local nWidth, nHeight = YiMin_ReadMe_InfoWindow:GetWindowSize();
--	local nTitleHeight = 23;
--	local nBottomHeight = 25;
--	nWindowHeight = nTitleHeight + nBottomHeight + nHeight;
--	YiMin_ReadMe_Frame:SetProperty( "AbsoluteHeight", tostring( nWindowHeight ) );
end

-- OnEvent
function YiMin_ReadMe_OnEvent(event)
	--******************************
	--建议：处理不同的event，请在读出参数后，将逻辑自己写在一个函数内
	--这样可以尽可能的使OnEvent函数能简洁一些不至于像MessageBox界面一样
	--注意：一定要先将参数读出来再传给自己写的函数
	--参考：event == "YBMARKET_UP_ITEM_COMFIRM"
	--*******************************
	if event == "SCENE_TRANSED" then
		if this:IsVisible()  then
			this:Hide()
		end
		return
	end
	
	
	if ( event == "UI_COMMAND" and tonumber(arg0) == 20160622 ) then
		YiMin_ReadMe_Clear_Var()
		
		g_FrameVar[1]  = Get_XParam_INT(0)
		g_FrameVar[2]  = Get_XParam_INT(1)
		g_FrameVar[3]  = Get_XParam_INT(2)
		g_FrameVar[4]  = Get_XParam_INT(3)
		
		
		------------------------------------------------
		g_FrameVar[5] = Get_XParam_INT(4)	;
       		YiMin_ReadMe_BeginCareObject( g_FrameVar[5] )	
		------------------------------------------------
		
		
		local targetName = Get_XParam_STR(0);
		local targetServerName = Get_XParam_STR(1)	;		
		local ImmgTime = Get_XParam_STR(2)	;		
		local msg =ScriptGlobal_Format( "#{FWQYM_160622_273}", targetServerName,ImmgTime)
		YiMin_ReadMe_Info_text:SetText( msg );	-- 设置内容
		g_FrameInfo = FrameInfoList.CONFIRM_IMMIGRATION ;
		YiMin_ReadMeUpdateRect();
		DataPool:SetCanUseHotKey(0)
		YiMin_ReadMe_BtnOK:SetProperty("Visible","True")
		YiMin_ReadMe_BtnCancel:SetProperty("Visible","True")
		YiMin_ReadMe_BtnQueDing:SetProperty("Visible","False")
		this:Show();
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 20160623 ) then
		YiMin_ReadMe_Clear_Var()
		
		g_FrameVar[1]  = Get_XParam_INT(0)
		g_FrameVar[2]  = Get_XParam_INT(1)
		g_FrameVar[3]  = Get_XParam_INT(2)
		g_FrameVar[4]  = Get_XParam_INT(3)
		------------------------------------------------
		g_FrameVar[5] = Get_XParam_INT(4)	;
    	    	YiMin_ReadMe_EndCareObject( g_FrameVar[5] )	
		------------------------------------------------
		
		local targetName = Get_XParam_STR(0);
		local targetServerName = Get_XParam_STR(1)	;		
		local ImmgTime = Get_XParam_STR(2)	;		
		local msg =ScriptGlobal_Format( "#{FWQYM_160622_274}", targetServerName,ImmgTime)
		YiMin_ReadMe_Info_text:SetText( msg );	-- 设置内容
		g_FrameInfo = FrameInfoList.CONFIRM_IMMIGRATION_SPOUSE ;
		YiMin_ReadMeUpdateRect();
		DataPool:SetCanUseHotKey(0)
		YiMin_ReadMe_BtnOK:SetProperty("Visible","True")
		YiMin_ReadMe_BtnCancel:SetProperty("Visible","True")
		YiMin_ReadMe_BtnQueDing:SetProperty("Visible","False")
		this:Show();
	elseif ( event == "OBJECT_CARED_EVENT" and this : IsVisible() ) then
        if( tonumber(arg0) ~= g_Yimin_Gain_NPCID ) then
			return
		end
       		 --- 如果和NPC的距离大于一定的距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2) > g_YIMIN_OBJ_DISTANCE or arg1=="destroy") then
            		YiMin_ReadMe_Close()
		end
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 20160624 ) then
		YiMin_ReadMe_Clear_Var()		
		local ImmgTime = Get_XParam_STR(0)	;	
		
		------------------------------------------------
		local npcObjID = Get_XParam_INT(0)	;
        	YiMin_ReadMe_BeginCareObject( npcObjID )	
		------------------------------------------------
		
		local msg =ScriptGlobal_Format( "#{FWQYM_160622_275}",ImmgTime)
		YiMin_ReadMe_Info_text:SetText( msg );	-- 设置内容
		YiMin_ReadMeUpdateRect();
		YiMin_ReadMe_BtnOK:SetProperty("Visible","False")
		YiMin_ReadMe_BtnCancel:SetProperty("Visible","False")
		YiMin_ReadMe_BtnQueDing:SetProperty("Visible","True")
		this:Show();

		
	end

end

-- 按钮1 点击事件
function YiMin_ReadMe_Bn1Click()

	if (g_FrameInfo == FrameInfoList.CONFIRM_IMMIGRATION) then
	
		Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("ImmigrationCallBack_After")
		Set_XSCRIPT_ScriptID(807012)
		Set_XSCRIPT_Parameter(0,g_FrameVar[3])
		Set_XSCRIPT_Parameter(1,g_FrameVar[4]) 
		Set_XSCRIPT_Parameter(2,g_FrameVar[5]) 
		Set_XSCRIPT_ParamCount(3)
		Send_XSCRIPT()
	elseif (g_FrameInfo == FrameInfoList.CONFIRM_IMMIGRATION_SPOUSE) then
	
		Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("SpouseImmigrationCallBack")
		Set_XSCRIPT_ScriptID(807012)
		Set_XSCRIPT_Parameter(0,g_FrameVar[2])
		Set_XSCRIPT_Parameter(1,g_FrameVar[3])
		Set_XSCRIPT_Parameter(2,1)
		Set_XSCRIPT_Parameter(3,g_FrameVar[5])
		Set_XSCRIPT_ParamCount(4)
		Send_XSCRIPT()	

	end

	this:Hide()

end
-- 按钮2 点击事件
function YiMin_ReadMe_Bn2Click()
	--由服务器记统计日志

	if (g_FrameInfo == FrameInfoList.CONFIRM_IMMIGRATION_SPOUSE) then
		--移民取消
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("SpouseImmigrationCallBack")
			Set_XSCRIPT_ScriptID(807012)
			Set_XSCRIPT_Parameter(0,g_FrameVar[2] )
			Set_XSCRIPT_Parameter(1,g_FrameVar[3] )
			Set_XSCRIPT_Parameter(2,0)
			Set_XSCRIPT_Parameter(3,g_FrameVar[5] )
			Set_XSCRIPT_ParamCount(4)
		Send_XSCRIPT()
	end
	this:Hide();
end

function YiMin_ReadMe_Frame_OnHiden()
	if(IsWindowShow("AntiJDY")) then    --简单游互斥界面显示时，不激活快捷键 for 69994
	else
		DataPool:SetCanUseHotKey(1);
	end
	YiMin_ReadMe_Clear_Var()
end



function YiMin_ReadMe_Clear_Var()
	for i = 1,8 do
		g_FrameVar[i] = 0
	end
	g_FrameInfo = -1
end

function YiMin_ReadMe_BeginCareObject( careObjID )
    g_Yimin_Gain_NPCID = DataPool : GetNPCIDByServerID( careObjID )
    if -1 == g_Yimin_Gain_NPCID then
        return 
    end
    this:CareObject( g_Yimin_Gain_NPCID, 1, "YiMin_ReadMe" )
end
function YiMin_ReadMe_EndCareObject( careObjID )
	if g_Yimin_Gain_NPCID ~= nil and g_Yimin_Gain_NPCID >= 0 then
        this:CareObject( g_Yimin_Gain_NPCID, 0, "YiMin_ReadMe" )
    end
    g_Yimin_Gain_NPCID = -1
end
function YiMin_ReadMe_Close()

    this:Hide()
end
