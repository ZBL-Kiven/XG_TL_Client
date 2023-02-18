--****************************
--雕纹直接升级
--折腾吗？一点也不，闹腾而已
--****************************
local MAX_OBJ_DISTANCE = 3.0
local g_CaredNpc = -1

local g_DWShengji_Item = -1--可有雕纹的装备，在背包中的位置

local g_DWShengji_Frame_UnifiedPosition;
local g_DWShengji_BindConfirmed = 0
local g_DWShengji_EquipData = ""
local g_DWShengji_toolNumInBag = 0


-- 金蚕丝, 强化用的道具, 按照 绑定 -> 元宝交易 -> 随便交易 顺序使用
local g_DWQIANGHUA_ToolItem = {20310168, 20310166, 20310167}
local g_DWQIANGHUA_UnbindItem = {20310166, 20310167}
--=========================================================
-- 注册窗口关心的所有事件
--=========================================================
function DWShengji_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("UPDATE_EQUIPDWLEVELUP")
	this:RegisterEvent("OBJECT_CARED_EVENT")
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")
	this:RegisterEvent("RESUME_ENCHASE_GEM")
	
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	--元宝
	this:RegisterEvent("UPDATE_YUANBAO");
	this:RegisterEvent("UPDATE_BIND_YUANBAO");
	--绑定确认
	this:RegisterEvent("BINDSURE_EQUIPDWLEVELUP");
	this:RegisterEvent("DW_QHSJ_UI_CHANGE");
end

--=========================================================
-- 载入初始化
--=========================================================
function DWShengji_OnLoad()
	g_DWShengji_Item = -1
	g_DWShengji_BindConfirmed = 0

	g_DWShengji_Frame_UnifiedPosition=DWShengji_Frame:GetProperty("UnifiedPosition");
	--这里服务端写的太复杂了，暂时废除
	DWShengji_cost:Hide()
	DWShengji_cost_Text:Hide()
end

--=========================================================
-- 事件处理
--=========================================================
function DWShengji_OnEvent(event)
	if (event == "UI_COMMAND" and tonumber(arg0) == 20141204) then
		local xx = Get_XParam_INT(0)
		g_DWShengji_toolNumInBag = Get_XParam_INT(1)
		g_CaredNpc = DataPool:GetNPCIDByServerID(xx)
		if g_CaredNpc == -1 then
			PushDebugMessage("server传过来的数据有问题。")
			return
		end
		BeginCareObject_DWShengji()
		DWShengji_Clear()
		DWShengji_UpdateBasic()
		this:Show()
	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if (tonumber(arg0) ~= g_CaredNpc) then
			return
		end
		if ((arg1 == "distance" and tonumber(arg2) > MAX_OBJ_DISTANCE) or arg1=="destroy") then
			DWShengji_Close()
		end
	elseif (event == "PACKAGE_ITEM_CHANGED" and this:IsVisible()) then
		if (arg0~= nil and -1 == tonumber(arg0)) then
			return
		end
		if (g_DWShengji_Item == tonumber(arg0)) then
			--DWShengji_Resume_DWInfo()
			DWShengji_Update(tonumber(arg0),0)
		end
		DWShengji_UpdateBasic()
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 201401111 and this:IsVisible()) then
		--PushDebugMessage("UPDATE_EQUIPDWLEVELUP")
		if arg1 ~= nil then
			DWShengji_Update(arg1,1)
			DWShengji_UpdateBasic()
		end
	elseif (event == "RESUME_ENCHASE_GEM" and this:IsVisible()) then
		if (arg0 ~= nil) then
			DWShengji_Resume_DWInfo()
			DWShengji_UpdateBasic()
		end
	--挪拽
	elseif (event == "ADJEST_UI_POS" ) then
		DWShengji_Frame_On_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		DWShengji_Frame_On_ResetPos()
	--元宝
	elseif (event == "UPDATE_YUANBAO" and this:IsVisible()) then
		DWShengji_UpdateBasic()
	elseif (event == "UPDATE_BIND_YUANBAO" and this:IsVisible()) then
		DWShengji_UpdateBasic()
	elseif (event == "BINDSURE_EQUIPDWLEVELUP" and this:IsVisible() and tonumber(arg0)==1) then
		g_DWShengji_BindConfirmed=1
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 2019050401 ) then
		if tonumber(arg1) ~= 2 then
			return
		end
		g_CaredNpc = tonumber(arg2)
		BeginCareObject_DWShengji()
		DWShengji_Clear()
		DWShengji_UpdateBasic()
		--调整界面位置
		if tostring(arg3) ~= nil then
			DWShengji_Frame:SetProperty("UnifiedPosition", tostring(arg3));
		end
		g_DWShengji_toolNumInBag = tonumber(arg4)
		this:Show()
	end
end

--=========================================================
-- 更新基本显示信息
--=========================================================
function DWShengji_UpdateBasic()
	--拥有绑定元宝
	DWShengji_Bangdingyuangbao_Text:SetText(tostring(Player:GetData("ZENGDIAN")));
	--拥有元宝
	DWShengji_Yuanbao_Text:SetText(tostring(Player:GetData("YUANBAO")));
	--背包内未锁定的金蚕丝
	local toolNumInBag = g_DWShengji_toolNumInBag		-- 背包里强化材料的个数
	DWShengji_JCSown_Text:SetText(tostring(toolNumInBag))
end

--=========================================================
-- 重置界面
--=========================================================
function DWShengji_Clear()
	if g_DWShengji_Item ~= -1 then
		DWShengji_Object:SetActionItem(-1)
		LifeAbility:Lock_Packet_Item(g_DWShengji_Item, 0)
		g_DWShengji_Item = -1
	end
	DWShengji_Type1_name:SetText("#{DWSJ_141202_51}")
	DWShengji_Type2_name:SetText("#{DWSJ_141202_51}")
	DWShengji_Type1_Level:ResetList()
	DWShengji_Type1_Level:AddTextItem("#{DWSJ_141202_5}" ,0)--尚未选择
	DWShengji_Type1_Level:SetCurrentSelect(0);
	--DWShengji_Type1_Level:Disable()
	DWShengji_Type2_Level:ResetList()
	DWShengji_Type2_Level:AddTextItem("#{DWSJ_141202_5}" ,0)--尚未选择
	DWShengji_Type2_Level:SetCurrentSelect(0);
	--DWShengji_Type2_Level:Disable()
	DWShengji_Type1_Info:SetText("")
	DWShengji_Type2_Info:SetText("")
	DWShengji_Type2:Hide()
	--需要的金蚕丝数量
	DWShengji_JCSneed_Text:SetText("")
	DWShengji_OK:Disable()
	g_DWShengji_BindConfirmed = 0
	--按钮显示
	DWShengji_Type1_Leveltip:Show()
end

--=========================================================
-- 更新界面
--=========================================================
function DWShengji_Update(itemIndex,bNotice)
	g_DWShengji_BindConfirmed = 0
	local index = tonumber(itemIndex)--背包位置
	local theAction = EnumAction(index, "packageitem")

	if theAction:GetID() ~= 0 then
		--是否为蚀刻了雕纹的装备
		g_DWShengji_EquipData = SuperTooltips:GetAuthorInfo()
		local Icon,IconEx,nLevel_1,nLevel_2,DWName_1,DWName_2 = "","","","","",""
		if LifeAbility : Get_Equip_Point(index) == 17 then
			_,Icon,IconEx,nLevel_1,nLevel_2,DWName_1,DWName_2,g_DWShengji_EquipData = Lua_GetDWShowMsgEx()
		else
			_,Icon,IconEx,nLevel_1,nLevel_2,DWName_1,DWName_2 = Lua_GetDWShowMsg(g_DWShengji_EquipData)
		end
		if Icon == "" then
			-- 不是一个已经蚀刻了雕纹的装备
			PushDebugMessage("#{DWSJ_141202_18}")
			return
		end
		if nLevel_1 == 10 and nLevel_2 == 10 then
			--满级
			if bNotice==1 then
				PushDebugMessage("#{DWSJ_141202_19}")
			else
				DWShengji_Type1_Level:ResetList()
				DWShengji_Type1_Level:AddTextItem("#{DWSJ_141202_6}" ,0)--雕纹已满级
				DWShengji_Type1_Level:SetCurrentSelect(0);
				--DWShengji_Type1_Level:Disable()
				DWShengji_Type2_Level:ResetList()
				DWShengji_Type2_Level:AddTextItem("#{DWSJ_141202_6}" ,0)--雕纹已满级
				DWShengji_Type2_Level:SetCurrentSelect(0);
				--DWShengji_Type2_Level:Disable()
				DWShengji_Type1_Info:SetText("")
				DWShengji_Type2_Info:SetText("")
			end
			return
		end
		-- if nLevel_1 == 10 then
			-- --满级
			-- if bNotice==1 then
				-- PushDebugMessage("#{DWSJ_141202_19}")
			-- else
				-- DWShengji_Type1_Level:ResetList()
				-- DWShengji_Type1_Level:AddTextItem("#{DWSJ_141202_6}" ,0)--雕纹已满级
				-- DWShengji_Type1_Level:SetCurrentSelect(0);
				-- --DWShengji_Type1_Level:Disable()
				-- DWShengji_Type1_Info:SetText("")
			-- end
			-- return
		-- end
		--不检测加锁

		-- 如果空格内已经有图样了, 替换之
		if g_DWShengji_Item ~= -1 then
			LifeAbility:Lock_Packet_Item(g_DWShengji_Item, 0)
		end

		DWShengji_Object:SetActionItem(theAction:GetID())
		LifeAbility:Lock_Packet_Item(index, 1)
		g_DWShengji_Item = index
		--隐藏按钮
		DWShengji_Type1_Leveltip:Hide()

		--更新乱七八糟的东西
		local msg1,msg2= DWName_1,DWName_2--LifeAbility:GetEquipDiaowen_Name(index)
		--显隐而已
		if msg2 == "" then
			DWShengji_Type2:Hide()
		else
			DWShengji_Type2:Show()
		end
		--名称and so on
		if msg1 ~= "" and msg2 ~= ""then
			--双属性雕纹
			local strname1 = string.format("#G双极·%s",msg1)
			DWShengji_Type1_name:SetText(strname1)--"#{SSXDW_140819_73}·"..
			local strname2 = string.format("#G双极·%s",msg2)
			DWShengji_Type2_name:SetText(strname2)--"#{SSXDW_140819_73}·"..
			--level
			local dwlevel = nLevel_1--LifeAbility:GetEquitDiaowenID(index)
			local dwlevelEx = nLevel_2--LifeAbility:GetEquitDiaowenIDEx(index)
			if dwlevel<=0 then return end;
			if dwlevelEx<=0 then return end;
			--第一套属性10级
			if dwlevel==10 then
				DWShengji_Type1_Level:ResetList()
				DWShengji_Type1_Level:AddTextItem("#{DWSJ_141202_6}" ,0)--雕纹已满级
				DWShengji_Type1_Level:SetCurrentSelect(0);
				--DWShengji_Type1_Level:Disable()
			else
				DWShengji_Type1_Level:ResetList()
				DWShengji_Type1_Level:AddTextItem("#{DWSJ_141202_5}" ,0)--尚未选择
				for i=dwlevel+1,10 do
					DWShengji_Type1_Level:AddTextItem(tostring(i) ,i)
				end
				DWShengji_Type1_Level:SetCurrentSelect(0);
				--DWShengji_Type1_Level:Enable()
			end
			--第二套属性10级
			if dwlevelEx==10 then
				DWShengji_Type2_Level:ResetList()
				DWShengji_Type2_Level:AddTextItem("#{DWSJ_141202_6}" ,0)--雕纹已满级
				DWShengji_Type2_Level:SetCurrentSelect(0);
				--DWShengji_Type2_Level:Disable()
			else
				DWShengji_Type2_Level:ResetList()
				DWShengji_Type2_Level:AddTextItem("#{DWSJ_141202_5}" ,0)--尚未选择
				for i=dwlevelEx+1,10 do
					DWShengji_Type2_Level:AddTextItem(tostring(i) ,i)
				end
				DWShengji_Type2_Level:SetCurrentSelect(0);
				--DWShengji_Type2_Level:Enable()
			end
			DWShengji_Type1_Info:SetText("")
			DWShengji_Type2_Info:SetText("")
		elseif msg1~="" then
			--单属性雕纹
			local strname1 = string.format("#G%s雕纹",msg1)
			DWShengji_Type1_name:SetText(strname1)--"#cfff263"..
			--level
			local dwlevel = nLevel_1--LifeAbility:GetEquitDiaowenID(index)
			if dwlevel<=0 then return end;
			--10级
			if dwlevel==10 then
				DWShengji_Type1_Level:ResetList()
				DWShengji_Type1_Level:AddTextItem("#{DWSJ_141202_6}" ,0)--雕纹已满级
				DWShengji_Type1_Level:SetCurrentSelect(0);
				--DWShengji_Type1_Level:Disable()
			else
				DWShengji_Type1_Level:ResetList()
				DWShengji_Type1_Level:AddTextItem("#{DWSJ_141202_5}" ,0)--尚未选择
				for i=dwlevel+1,10 do
					DWShengji_Type1_Level:AddTextItem(tostring(i) ,i)
				end
				DWShengji_Type1_Level:SetCurrentSelect(0);
				--DWShengji_Type1_Level:Enable()

				DWShengji_Type1_Info:SetText("")
			end
		end

		--清除需要金蚕丝信息
		DWShengji_JCSneed_Text:SetText("")
		
		DWShengji_OK:Enable()

	else
		DWShengji_Clear()
	end
end

--=========================================================
-- 取出窗口内放入的物品
--=========================================================
function DWShengji_Resume_DWInfo()
	if this:IsVisible() then
		DWShengji_Clear()
	end
end

--=========================================================
-- 确定执行功能
--=========================================================
function DWShengji_OK_Clicked()
	-- 安全时间
	if (tonumber(DataPool:GetLeftProtectTime()) > 0) then
		PushDebugMessage("#{DWSJ_141202_20}")
		return
	end

	if g_DWShengji_Item==-1 then
		PushDebugMessage("#{DWSJ_141202_21}") --请放入一件已镶嵌了雕纹的装备。
		return
	end
	--是否有雕纹
	-- 判断物品是否为蚀刻了一个雕纹的装备
	local Icon,IconEx,nLevel_1,nLevel_2,DWName_1,DWName_2 = "","","","","",""
	if LifeAbility : Get_Equip_Point(g_DWShengji_Item) == 17 then
		_,Icon,IconEx,nLevel_1,nLevel_2,DWName_1,DWName_2 = Lua_GetDWShowMsgEx()
	else
		_,Icon,IconEx,nLevel_1,nLevel_2,DWName_1,DWName_2 = Lua_GetDWShowMsg(g_DWShengji_EquipData)
	end
	--原则上可以升级第一个，也可以升级第二个，也可以同时升级第一第二个；但是但升级第二个的时候，要检测第一个上面有雕纹
	if Icon == "" then
		PushDebugMessage("#{DWSJ_141202_21}")
		return
	end

	--雕纹是否满级
	if nLevel_1 == 10 and nLevel_2 == 10 then
		--满级
		PushDebugMessage("#{DWSJ_141202_22}")
		return
	end
	if IconEx ~= "" and ret == -3 then
		PushDebugMessage("#{DWSJ_141202_22}")
		return
	end
	--雕纹的当前等级
	local dwlevel = nLevel_1--LifeAbility:GetEquitDiaowenID(g_DWShengji_Item)
	local dwlevelEx = nLevel_2--LifeAbility:GetEquitDiaowenIDEx(g_DWShengji_Item)
	--选择等级
	local sToLevelSel,iToLevelSel =  DWShengji_Type1_Level:GetCurrentSelect()
	local sToLevelSelEx,iToLevelSelEx =  DWShengji_Type2_Level:GetCurrentSelect()
	if iToLevelSelEx>0 and IconEx == "" then--2号未打雕纹但选择升级2号雕纹
		return
	end
	if iToLevelSel<=0 and iToLevelSelEx <=0 then--未选择升级哪个
		PushDebugMessage("#{DWSJ_141202_23}")
		return
	end
	if iToLevelSel>0 and iToLevelSelEx>0 then
		--升级两个
		if iToLevelSel<=dwlevel or iToLevelSelEx<=dwlevelEx then
			PushDebugMessage("#{DWSJ_141202_24}")
			return
		end
	elseif iToLevelSel>0 then
		--升级1号雕纹
		if iToLevelSel<=dwlevel then
			PushDebugMessage("#{DWSJ_141202_24}")
			return
		end
	elseif iToLevelSelEx>0 then
		--升级2号雕纹
		if iToLevelSelEx<=dwlevelEx then
			PushDebugMessage("#{DWSJ_141202_24}")
			return
		end
	end
	--require for jcs count
	--给服务器端发包，直接升级吧
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("DoDiaowenAction")
		Set_XSCRIPT_ScriptID(900014)
		Set_XSCRIPT_Parameter(0, 99)
		Set_XSCRIPT_Parameter(1, g_DWShengji_Item)
		Set_XSCRIPT_Parameter(2, iToLevelSel)
		Set_XSCRIPT_Parameter(3, iToLevelSelEx)
		Set_XSCRIPT_ParamCount(4)
	Send_XSCRIPT()
	return
end

function DWShengji_Type1_Changed()
	if g_DWShengji_Item==-1 then
		return
	end
	local sToLevelSel,iToLevelSel = DWShengji_Type1_Level:GetCurrentSelect()
	local nAttr_ec_1,nAttr_ecName_1 = Lua_GetDWLeveUpMsg(g_DWShengji_EquipData,iToLevelSel,0)
	if nAttr_ec_1 > 0 then
		local str = string.format("#G%s+%s",nAttr_ecName_1,nAttr_ec_1)
		DWShengji_Type1_Info:SetText(str)
	else
		DWShengji_Type1_Info:SetText("")
	end
	DWShengji_UpdateRequireMat()
end

function DWShengji_Type2_Changed()
	if g_DWShengji_Item==-1 then
		return
	end
	local sToLevelSel,iToLevelSel =  DWShengji_Type1_Level:GetCurrentSelect()
	local sToLevelSelEx,iToLevelSelEx =  DWShengji_Type2_Level:GetCurrentSelect()
	local _,_,nAttr_ec_2,nAttr_ecName_2 = Lua_GetDWLeveUpMsg(g_DWShengji_EquipData,iToLevelSel,iToLevelSelEx)
	if nAttr_ec_2 > 0 then
		local str = string.format("#G%s+%s",nAttr_ecName_2,nAttr_ec_2)
		DWShengji_Type2_Info:SetText(str)
	else
		DWShengji_Type2_Info:SetText("")
	end
	--更新需求金蚕丝量
	DWShengji_UpdateRequireMat()
end

function DWShengji_UpdateRequireMat()
	local sToLevelSel,iToLevelSel =  DWShengji_Type1_Level:GetCurrentSelect()
	local sToLevelSelEx,iToLevelSelEx =  DWShengji_Type2_Level:GetCurrentSelect()
	local _,_,_,_,requireJCS1,requireJCS2 = Lua_GetDWLeveUpMsg(g_DWShengji_EquipData,iToLevelSel,iToLevelSelEx)
	local cntTotal = requireJCS1+requireJCS2
	if cntTotal>0 then
		DWShengji_JCSneed_Text:SetText(cntTotal)
	end
end
--=========================================================
-- 关闭界面
--=========================================================
function DWShengji_Close()
	this:Hide()
	return
end

--=========================================================
-- 界面隐藏
--=========================================================
function DWShengji_OnHiden()
	StopCareObject_DWShengji()
	DWShengji_Clear()
	return
end

--=========================================================
-- 开始关心NPC，
-- 在开始关心之前需要先确定这个界面是不是已经有“关心”的NPC，
-- 如果有的话，先取消已经有的“关心”
--=========================================================
function BeginCareObject_DWShengji()
	this:CareObject(g_CaredNpc, 1, "DWShengji")
	return
end

--=========================================================
-- 停止对某NPC的关心
--=========================================================
function StopCareObject_DWShengji()
	this:CareObject(g_CaredNpc, 0, "DWShengji")
	g_CaredNpc = -1
	return
end


function DWShengji_Frame_On_ResetPos()
  DWShengji_Frame:SetProperty("UnifiedPosition", g_DWShengji_Frame_UnifiedPosition);
end

function DWShengji_ItemBtnRBClicked()
	DWShengji_Resume_DWInfo()
end

function DWShengji_Type1_Leveltip_Click()
	if g_DWShengji_Item==-1 then
		PushDebugMessage("#{DWSJ_141202_54}")
	end
end

--打开雕纹强化界面
function DWShengji_ChangeTabIndex()
	--参数2:1-强化、2-升级
	PushEvent("UI_COMMAND",2019050401, 1,g_CaredNpc,DWShengji_Frame:GetProperty("UnifiedPosition"),g_DWShengji_toolNumInBag)
	DWShengji_Close()
end
