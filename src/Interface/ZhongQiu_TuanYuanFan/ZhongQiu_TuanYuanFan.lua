--***********************************************************************************************************************************************
--local isLeader = Player:IsLeader();

--***********************************************************************************************************************************************

local g_clientNpcId = -1

local g_ZhongQiu_TuanYuanFan_Frame_UnifiedPosition;

local g_headmodel_ctrl_A = {}
local g_headmodel_ctrl_B = {}

local g_TuanYuanFan_Sel = 0
local g_CloseTick = 3
local g_bReceiveCloseUIMsg = 0
--local g_guidLeaveMem = 0

local g_memberlist={}

local g_SeatStateImage={}
-- OnLoad
--
--************************************************************************************************************************************************
function ZhongQiu_TuanYuanFan_PreLoad()
	this:RegisterEvent("OPEN_TUANYUANFAN");
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
end

function ZhongQiu_TuanYuanFan_OnLoad()
	g_ZhongQiu_TuanYuanFan_Frame_UnifiedPosition=ZhongQiu_TuanYuanFan_Frame:GetProperty("UnifiedPosition");
	g_headmodel_ctrl_A = {
		{frame=	ZhongQiu_TuanYuanFan_Table1_Member1	, name=	ZhongQiu_TuanYuanFan_Table1_Name1	, stat=	ZhongQiu_TuanYuanFan_Table1_Info1_BK	, head=	ZhongQiu_TuanYuanFan_Table1_Head1	},
		{frame=	ZhongQiu_TuanYuanFan_Table1_Member2	, name=	ZhongQiu_TuanYuanFan_Table1_Name2	, stat=	ZhongQiu_TuanYuanFan_Table1_Info2_BK	, head=	ZhongQiu_TuanYuanFan_Table1_Head2	},
		{frame=	ZhongQiu_TuanYuanFan_Table1_Member3	, name=	ZhongQiu_TuanYuanFan_Table1_Name3	, stat=	ZhongQiu_TuanYuanFan_Table1_Info3_BK	, head=	ZhongQiu_TuanYuanFan_Table1_Head3	},
		{frame=	ZhongQiu_TuanYuanFan_Table1_Member4	, name=	ZhongQiu_TuanYuanFan_Table1_Name4	, stat=	ZhongQiu_TuanYuanFan_Table1_Info4_BK	, head=	ZhongQiu_TuanYuanFan_Table1_Head4	},
		{frame=	ZhongQiu_TuanYuanFan_Table1_Member5	, name=	ZhongQiu_TuanYuanFan_Table1_Name5	, stat=	ZhongQiu_TuanYuanFan_Table1_Info5_BK	, head=	ZhongQiu_TuanYuanFan_Table1_Head5	},
	}
	g_headmodel_ctrl_B = {
		{frame=	ZhongQiu_TuanYuanFan_Table2_Member1	, name=	ZhongQiu_TuanYuanFan_Table2_Name1	, stat=	ZhongQiu_TuanYuanFan_Table2_Info1_BK	, head=	ZhongQiu_TuanYuanFan_Table2_Head1	},
		{frame=	ZhongQiu_TuanYuanFan_Table2_Member2	, name=	ZhongQiu_TuanYuanFan_Table2_Name2	, stat=	ZhongQiu_TuanYuanFan_Table2_Info2_BK	, head=	ZhongQiu_TuanYuanFan_Table2_Head2	},
		{frame=	ZhongQiu_TuanYuanFan_Table2_Member3	, name=	ZhongQiu_TuanYuanFan_Table2_Name3	, stat=	ZhongQiu_TuanYuanFan_Table2_Info3_BK	, head=	ZhongQiu_TuanYuanFan_Table2_Head3	},
		{frame=	ZhongQiu_TuanYuanFan_Table2_Member4	, name=	ZhongQiu_TuanYuanFan_Table2_Name4	, stat=	ZhongQiu_TuanYuanFan_Table2_Info4_BK	, head=	ZhongQiu_TuanYuanFan_Table2_Head4	},
		{frame=	ZhongQiu_TuanYuanFan_Table2_Member5	, name=	ZhongQiu_TuanYuanFan_Table2_Name5	, stat=	ZhongQiu_TuanYuanFan_Table2_Info5_BK	, head=	ZhongQiu_TuanYuanFan_Table2_Head5	},
		{frame=	ZhongQiu_TuanYuanFan_Table2_Member6	, name=	ZhongQiu_TuanYuanFan_Table2_Name6	, stat=	ZhongQiu_TuanYuanFan_Table2_Info6_BK	, head=	ZhongQiu_TuanYuanFan_Table2_Head6	},
	}
	g_TuanYuanFan_Sel = 0
	--玩家状态:
	g_SeatStateImage={
		["yiruzuo"]="set:ZhongQiu_TuanYuanFan1 image:TuanYuanFan_In",--已入座    
		["weiruzuo"]="set:ZhongQiu_TuanYuanFan1 image:TuanYuanFan_Out",--未入座    
		["kongwei"]="set:ZhongQiu_TuanYuanFan1 image:TuanYuanFan_Empty",--空位      
		["dengdai"]="set:ZhongQiu_TuanYuanFan1 image:TuanYuanFan_Wait",--等待    
		["likai"]="set:ZhongQiu_TuanYuanFan1 image:TuanYuanFan_Leave",--离开    
	}
end


--***********************************************************************************************************************************************
-- 事件响应函数
--************************************************************************************************************************************************
function ZhongQiu_TuanYuanFan_OnEvent(event)

	if ( event == "OPEN_TUANYUANFAN" ) then

		local uiflag = tonumber(arg0)
		if uiflag==-1 then
			--播放特效
			g_bReceiveCloseUIMsg = 1
			ZhongQiu_TuanYuanFan_AnimateUpdate(1)
			return
		elseif uiflag>0 then
			ZhongQiu_TuanYuanFan_Clean()
			g_clientNpcId = uiflag
			local objId = DataPool : GetNPCIDByServerID(g_clientNpcId)
			if objId == -1 then
				return
			end
			g_TuanYuanFan_Sel = tonumber(arg1)
			ZhongQiu_TuanYuanFan_Update()
			ZhongQiu_TuanYuanFan_AnimateUpdate(0)
			this : CareObject( objId, 1, "ZhongQiu_TuanYuanFan" )
			this : Show()
		elseif uiflag==-2 and this:IsVisible() then
			--更新
			ZhongQiu_TuanYuanFan_EnterUpdate(tonumber(arg1))
		elseif uiflag==-3 and this:IsVisible() then
			--关闭界面倒计时
			g_bReceiveCloseUIMsg = 1
			this:Hide()
--			g_CloseTick = 3
--			g_guidLeaveMem = tonumber(arg1)
--			ZhongQiu_TuanYuanFan_LeaveUpdate()
--			KillTimer("ZhongQiu_TuanYuanFanCloseTick()")
--			SetTimer("ZhongQiu_TuanYuanFan","ZhongQiu_TuanYuanFanCloseTick()", 1000);
		elseif uiflag==-4 and this:IsVisible() then
			g_bReceiveCloseUIMsg = 1
			this:Hide()
		end

	elseif (event == "ADJEST_UI_POS" ) then
		ZhongQiu_TuanYuanFan_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		ZhongQiu_TuanYuanFan_Frame_On_ResetPos()
	end
end


function ZhongQiu_TuanYuanFan_Frame_On_ResetPos()
  ZhongQiu_TuanYuanFan_Frame:SetProperty("UnifiedPosition", g_ZhongQiu_TuanYuanFan_Frame_UnifiedPosition);
end

function ZhongQiu_TuanYuanFan_AnimateUpdate(bShow)
	if bShow==1 then
		ZhongQiu_TuanYuanFan_Table_Animate:Show()
		ZhongQiu_TuanYuanFan_Table_Animate:Play(true)
	else
		ZhongQiu_TuanYuanFan_Table_Animate:Hide()
		ZhongQiu_TuanYuanFan_Table_Animate:Play(false)
	end
end
function ZhongQiu_TuanYuanFan_Update()
	if g_TuanYuanFan_Sel>=1 and g_TuanYuanFan_Sel<=2 then
		ZhongQiu_TuanYuanFan_Table1:Show()
		ZhongQiu_TuanYuanFan_Table2:Hide()
		g_memberlist={}
		-- 得到队员的个数
		local iMemCount = DataPool:GetTeamMemberCount();
		for i=1,iMemCount do
			-- 得到队员的详细信息
			local charname
			, charguid
			, strIconIndex
			, isLeader
			, _
			= DataPool:GetTeamMemInfoExByIndex( i-1 );
			g_headmodel_ctrl_A[i].name:SetText(charname)
			if isLeader==1 then
				g_headmodel_ctrl_A[i].stat:SetProperty("Image",g_SeatStateImage["dengdai"])--("#{TYF_210712_43}")--等待
			else
				g_headmodel_ctrl_A[i].stat:SetProperty("Image",g_SeatStateImage["weiruzuo"])--SetText("#{TYF_210712_49}")--为入座
			end
			g_headmodel_ctrl_A[i].head:SetProperty("Image", strIconIndex);
			ZhongQiu_TuanYuanFan_InserMember(charguid,charname)
		end
		--我是不是队长
		if( tonumber( Player:IsLeader() ) == 1 ) then
			ZhongQiu_TuanYuanFan_StartButton:Show()--开始宴席
			ZhongQiu_TuanYuanFan_EnterButton:Hide()--入座
		else
			ZhongQiu_TuanYuanFan_StartButton:Hide()
			ZhongQiu_TuanYuanFan_EnterButton:Show()
		end
		if iMemCount<5 then
			for i=iMemCount+1,5 do
				g_headmodel_ctrl_A[i].stat:SetProperty("Image",g_SeatStateImage["kongwei"])--SetText("#{TYF_210712_51}")--空位
				g_headmodel_ctrl_A[i].head:SetProperty("Image", "set: ZhongQiu_TuanYuanFan1 image: TuanYuanFan_EmptySeat");
				g_headmodel_ctrl_A[i].name:SetText("")
			end
		end
	else
		ZhongQiu_TuanYuanFan_Table1:Hide()
		ZhongQiu_TuanYuanFan_Table2:Show()
		g_memberlist={}
		-- 得到队员的个数
		local iMemCount = DataPool:GetTeamMemberCount();
		for i=1,iMemCount do
			-- 得到队员的详细信息
			local charname
			, charguid
			, strIconIndex
			, isLeader
			, _
			= DataPool:GetTeamMemInfoExByIndex( i-1 );
			g_headmodel_ctrl_B[i].name:SetText(charname)
			if isLeader==1 then
				g_headmodel_ctrl_B[i].stat:SetProperty("Image",g_SeatStateImage["dengdai"])--SetText("#{TYF_210712_43}")--等待
			else
				g_headmodel_ctrl_B[i].stat:SetProperty("Image",g_SeatStateImage["weiruzuo"])--SetText("#{TYF_210712_49}")--未入座
			end
			g_headmodel_ctrl_B[i].head:SetProperty("Image", strIconIndex);
			ZhongQiu_TuanYuanFan_InserMember(charguid,charname)
		end
		--我是不是队长
		if( tonumber( Player:IsLeader() ) == 1 ) then
			ZhongQiu_TuanYuanFan_StartButton:Show()
			ZhongQiu_TuanYuanFan_EnterButton:Hide()
		else
			ZhongQiu_TuanYuanFan_StartButton:Hide()
			ZhongQiu_TuanYuanFan_EnterButton:Show()
		end
	end
--	PushDebugMessage("g_TuanYuanFan_Sel="..g_TuanYuanFan_Sel)
	if g_TuanYuanFan_Sel==1 then
		ZhongQiu_TuanYuanFan_Function_BKtable:SetProperty("Image", "set:ZhongQiu_TuanYuanFan1 image:TuanYuanFan_Table1_Normal")
	elseif g_TuanYuanFan_Sel==2 then
		ZhongQiu_TuanYuanFan_Function_BKtable:SetProperty("Image", "set:ZhongQiu_TuanYuanFan1 image:TuanYuanFan_Table1_Luxury")
	elseif g_TuanYuanFan_Sel==3 then
		ZhongQiu_TuanYuanFan_Function_BKtable:SetProperty("Image", "set:ZhongQiu_TuanYuanFan1 image:TuanYuanFan_Table2_Normal")
	elseif g_TuanYuanFan_Sel==4 then
		ZhongQiu_TuanYuanFan_Function_BKtable:SetProperty("Image", "set:ZhongQiu_TuanYuanFan2 image:TuanYuanFan_Table2_Luxury")
	end
end

function ZhongQiu_TuanYuanFan_InserMember(guid,name)
	local nItem = {}
	nItem.charguid = guid
	nItem.charname = name
	table.insert(g_memberlist,nItem)
end
--举杯开席
function ZhongQiu_TuanYuanFan_StartClick()
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("OnLeaderStartClk")
		Set_XSCRIPT_ScriptID(807031);
		Set_XSCRIPT_Parameter(0,g_clientNpcId);
		Set_XSCRIPT_Parameter(1,g_TuanYuanFan_Sel);
		Set_XSCRIPT_ParamCount(2);
	Send_XSCRIPT();
end
--入座
function ZhongQiu_TuanYuanFan_EnterClick()
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("OnMemberEnterClk")
		Set_XSCRIPT_ScriptID(807031);
		Set_XSCRIPT_Parameter(0,g_clientNpcId);
		Set_XSCRIPT_ParamCount(1);
	Send_XSCRIPT();
end

function ZhongQiu_TuanYuanFan_Hidden()
--	PushDebugMessage("ZhongQiu_TuanYuanFan_Hidden.."..g_bReceiveCloseUIMsg)
	if g_bReceiveCloseUIMsg==0 then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("OnMemberLeaveClk")
			Set_XSCRIPT_ScriptID(807031);
			Set_XSCRIPT_Parameter(0,g_clientNpcId);
			Set_XSCRIPT_ParamCount(1);
		Send_XSCRIPT();
		g_bReceiveCloseUIMsg = 1
	end
end

--function ZhongQiu_TuanYuanFanCloseTick()
--	if g_CloseTick<=0 then
--		KillTimer("ZhongQiu_TuanYuanFanCloseTick()")
--		this:Hide()
--	end
--	local tipMsg = {"#{TYF_210712_47}","#{TYF_210712_46}","#{TYF_210712_45}"}
--	if tipMsg[g_CloseTick]~=nil then
--		local iMemCount = table.getn(g_memberlist)
--		for i=1,iMemCount do
--			-- 得到队员的详细信息
--			if g_guidLeaveMem==g_memberlist[i].charguid then
--				local tips = ScriptGlobal_Format(tipMsg[g_CloseTick], g_memberlist[i].charname)
--				PushDebugMessage(tips)
----				break;
--			end
--		end
--	end
--
--	g_CloseTick = g_CloseTick-1
--end

function ZhongQiu_TuanYuanFan_EnterUpdate(memguid)
--PushDebugMessage("ZhongQiu_TuanYuanFan_StateUpdate "..memguid)
	local iMemCount = table.getn(g_memberlist)
	for i=1,iMemCount do
		-- 得到队员的详细信息
		if memguid==g_memberlist[i].charguid then
			--入座更新
			if g_TuanYuanFan_Sel>=1 and g_TuanYuanFan_Sel<=2 then
				g_headmodel_ctrl_A[i].stat:SetProperty("Image",g_SeatStateImage["yiruzuo"])--SetText("#{TYF_210712_50}")--入座
			else
				g_headmodel_ctrl_B[i].stat:SetProperty("Image",g_SeatStateImage["yiruzuo"])--SetText("#{TYF_210712_50}")--入座
			end
			return
		end
	end
end
--function ZhongQiu_TuanYuanFan_LeaveUpdate()
--	local iMemCount = table.getn(g_memberlist)
--	for i=1,iMemCount do
--		-- 得到队员的详细信息
--		if g_guidLeaveMem==g_memberlist[i].charguid then
--			--入座更新
--			if g_TuanYuanFan_Sel>=1 and g_TuanYuanFan_Sel<=2 then
--				g_headmodel_ctrl_A[i].stat:SetProperty("Image",g_SeatStateImage["likai"])--SetText("#{TYF_210712_44}")--离开
--			else
--				g_headmodel_ctrl_B[i].stat:SetProperty("Image",g_SeatStateImage["likai"])--SetText("#{TYF_210712_44}")--离开
--			end
--			return
--		end
--	end
--end

function ZhongQiu_TuanYuanFan_Clean()
	g_TuanYuanFan_Sel = 0
	g_bReceiveCloseUIMsg = 0
--	g_guidLeaveMem = 0
end
