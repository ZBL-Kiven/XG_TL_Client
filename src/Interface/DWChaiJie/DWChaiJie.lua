--****************************
--雕纹拆解
--****************************
local MAX_OBJ_DISTANCE = 3.0
local g_CaredNpc = -1
local g_DWChaiJie_Item = -1

local g_DWChaiJie_Frame_UnifiedPosition;

local g_DWChaiJie_Confirmed = 0
local g_DWChaiJie_JCSNum = 0


--拆解信息
local g_DWChaiJieInfo={
[2]={kangxing={28,2},jiankang={84,6},normal={28,2}},
[3]={kangxing={154,11},jiankang={462,33},normal={154,11}},
[4]={kangxing={854,61},jiankang={2562,183},normal={854,61}},
[5]={kangxing={2072,148},jiankang={6216,444},normal={2072,148}},
[6]={kangxing={4382,313},jiankang={13146,939},normal={4382,313}},
[7]={kangxing={8358,597},jiankang={25074,1791},normal={8358,597}},
[8]={kangxing={19712,1408},jiankang={59136,4224},normal={19712,1408}},
[9]={kangxing={48944,3496},jiankang={146832,10488},normal={48944,3496}},
[10]={kangxing={87164,6226},jiankang={261492,18678},normal={98924,7066}},
}

--=========================================================
-- 注册窗口关心的所有事件
--=========================================================
function DWChaiJie_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("UPDATE_DWCHAIJIE")
	this:RegisterEvent("OBJECT_CARED_EVENT",false)
	this:RegisterEvent("PACKAGE_ITEM_CHANGED",false)
	this:RegisterEvent("RESUME_ENCHASE_GEM",false)
	
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	--元宝
	this:RegisterEvent("UPDATE_YUANBAO");
	--拆解确认
	this:RegisterEvent("SURE_DWCHAIJIE");
end

--=========================================================
-- 载入初始化
--=========================================================
function DWChaiJie_OnLoad()
	g_DWChaiJie_Item = -1
	g_DWChaiJie_Confirmed = 0

	g_DWChaiJie_Frame_UnifiedPosition=DWChaiJie_Frame:GetProperty("UnifiedPosition");
end

--=========================================================
-- 事件处理
--=========================================================
function DWChaiJie_OnEvent(event)
	if (event == "UI_COMMAND" and tonumber(arg0) == 20140612) then
		local xx = Get_XParam_INT(0)
		g_CaredNpc = DataPool:GetNPCIDByServerID(xx)
		if g_CaredNpc == -1 then
			PushDebugMessage("server传过来的数据有问题。")
			return
		end
		BeginCareObject_DWChaiJie()
		DWChaiJie_Clear()
		DWChaiJie_UpdateBasic()
		this:Show()
	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if (tonumber(arg0) ~= g_CaredNpc) then
			return
		end
		if ((arg1 == "distance" and tonumber(arg2) > MAX_OBJ_DISTANCE) or arg1=="destroy") then
			DWChaiJie_Close()
		end
	elseif (event == "PACKAGE_ITEM_CHANGED" and this:IsVisible()) then
		if (arg0~= nil and -1 == tonumber(arg0)) then
			return
		end
		if (g_DWChaiJie_Item == tonumber(arg0)) then
			DWChaiJie_Resume_DWInfo()
		end
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 201401111 and this:IsVisible()) then
		if arg1 ~= nil then
			DWChaiJie_Update(arg1)
			DWChaiJie_UpdateBasic()
		end
	elseif (event == "RESUME_ENCHASE_GEM" and this:IsVisible()) then
		if (arg0 ~= nil) then
			DWChaiJie_Resume_DWInfo()
			DWChaiJie_UpdateBasic()
		end
	--挪拽
	elseif (event == "ADJEST_UI_POS" ) then
		DWChaiJie_Frame_On_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		DWChaiJie_Frame_On_ResetPos()
	--元宝
	elseif (event == "UPDATE_YUANBAO" and this:IsVisible()) then
		DWChaiJie_UpdateBasic()
	elseif (event == "SURE_DWCHAIJIE") then
		g_DWChaiJie_Confirmed = 1
	end
end

--=========================================================
-- 更新基本显示信息
--=========================================================
function DWChaiJie_UpdateBasic()
	DWChaiJie_SelfYuanBao:SetText(tostring(Player:GetData("YUANBAO")));
end

--=========================================================
-- 重置界面
--=========================================================
function DWChaiJie_Clear()
	if g_DWChaiJie_Item ~= -1 then
		DWChaiJie_Object:SetActionItem(-1)
		LifeAbility:Lock_Packet_Item(g_DWChaiJie_Item, 0)
		g_DWChaiJie_Item = -1
	end

--	DWChaiJie_UpdateBasic()
	g_DWChaiJie_Confirmed = 0
	g_DWChaiJie_JCSNum = 0
	DWChaiJie_NeedYuanBao:SetText("")
	DWChaiJie_Quantity:SetText("")
end

--=========================================================
-- 更新界面
--=========================================================
function DWChaiJie_Update(itemIndex)
	g_DWChaiJie_Confirmed = 0
	local index = tonumber(itemIndex)--背包位置
	local theAction = EnumAction(index, "packageitem")

	if theAction:GetID() ~= 0 then
		-- 判断物品是否为雕纹, 如果不是, 直接return
		local nDiaoWenID,nDiaoWenLevel,nDiaoWenType = GetDiaowenId(index)--参数为背包中位置
		if nDiaoWenID == -1 then
			PushDebugMessage("#{DWCJJ_140606_11}")
			return
		end

		-- 判断物品是否加锁(在这个逻辑之前程序已经判断了)
		if PlayerPackage:IsLock(index) == 1 then
			PushDebugMessage("#{DWCJJ_140606_12}")
			return
		end
		if g_DWChaiJieInfo[nDiaoWenLevel]==nil then
--		if nDiaoWenLevel<2 or nDiaoWenLevel>10 then
			PushDebugMessage("#{DWCJJ_140606_11}")
			return
		end

		-- 如果空格内已经有图样了, 替换之
		if g_DWChaiJie_Item ~= -1 then
			LifeAbility:Lock_Packet_Item(g_DWChaiJie_Item, 0)
		end
		DWChaiJie_Object:SetActionItem(theAction:GetID())
		LifeAbility:Lock_Packet_Item(index, 1)
		g_DWChaiJie_Item = index

		if nDiaoWenType==1 then--普通
			DWChaiJie_NeedYuanBao:SetText(g_DWChaiJieInfo[nDiaoWenLevel].normal[1])
			DWChaiJie_Quantity:SetText(g_DWChaiJieInfo[nDiaoWenLevel].normal[2])
			g_DWChaiJie_JCSNum = g_DWChaiJieInfo[nDiaoWenLevel].normal[2]
		elseif nDiaoWenType==2 then--减抗
			DWChaiJie_NeedYuanBao:SetText(g_DWChaiJieInfo[nDiaoWenLevel].jiankang[1])
			DWChaiJie_Quantity:SetText(g_DWChaiJieInfo[nDiaoWenLevel].jiankang[2])
			g_DWChaiJie_JCSNum = g_DWChaiJieInfo[nDiaoWenLevel].jiankang[2]
		elseif nDiaoWenType==3 then--抗性
			DWChaiJie_NeedYuanBao:SetText(g_DWChaiJieInfo[nDiaoWenLevel].kangxing[1])
			DWChaiJie_Quantity:SetText(g_DWChaiJieInfo[nDiaoWenLevel].kangxing[2])
			g_DWChaiJie_JCSNum = g_DWChaiJieInfo[nDiaoWenLevel].kangxing[2]
		end
	else
		DWChaiJie_Clear()
	end
end

--=========================================================
-- 取出窗口内放入的物品
--=========================================================
function DWChaiJie_Resume_DWInfo()
	if this:IsVisible() then
		DWChaiJie_Clear()
	end
end

--=========================================================
-- 确定执行功能
--=========================================================
function DWChaiJie_OK_Clicked()
	-- 安全时间
	if (tonumber(DataPool:GetLeftProtectTime()) > 0) then
		PushDebugMessage("#{DWCJJ_140606_21}")
		return
	end

	if g_DWChaiJie_Item==-1 then
		PushDebugMessage("#{DWCJJ_140606_13}")
		return
	end
	local nDiaoWenID,nDiaoWenLevel,nDiaoWenType=GetDiaowenId(g_DWChaiJie_Item)--参数为背包中位置
	if nDiaoWenID == -1 then
		PushDebugMessage("#{DWCJJ_140606_13}")
		return
	end
	-- 判断物品是否加锁(在这个逻辑之前程序已经判断了)
	if PlayerPackage:IsLock(g_DWChaiJie_Item) == 1 then
		PushDebugMessage("#{DWCJJ_140606_14}")
		return
	end
	if g_DWChaiJieInfo[nDiaoWenLevel]==nil then
--	if nDiaoWenLevel<2 or nDiaoWenLevel>10 then
		PushDebugMessage("#{DWCJJ_140606_11}")
		return
	end
	local needYB=0
	if nDiaoWenType==1 then
		needYB=g_DWChaiJieInfo[nDiaoWenLevel].normal[1]
	elseif nDiaoWenType==2 then--减抗
		needYB=g_DWChaiJieInfo[nDiaoWenLevel].jiankang[1]
	elseif nDiaoWenType==3 then
		needYB=g_DWChaiJieInfo[nDiaoWenLevel].kangxing[1]
	end
	local nCurYB=tonumber(Player:GetData("YUANBAO"))
	if nCurYB<needYB then
		PushDebugMessage("#{DWCJJ_140606_15}")
		return
	end
	
	if g_DWChaiJie_Confirmed ~= 1 then
		--绑定提示
		local nShowMsg = string.format("    #cfff263您当前将要拆解：#G%s#cfff263，拆解需要消耗元宝：#G%s#cfff263，拆解后获得#G%s个#G金蚕丝#cfff263。#r    点击确定按钮后，#G再次点击#cfff263雕纹拆解界面的确认按钮完成本次操作，取消操作请关闭界面。",
						LuaFnGetItemName(nDiaoWenID),
						tostring(needYB),
						tostring(g_DWChaiJie_JCSNum))
		GameProduceLogin:GameLoginShowSystemInfo( nShowMsg)
		g_DWChaiJie_Confirmed = 1;
		return
	end

--	PushDebugMessage("sure="..g_DWChaiJie_Confirmed)
	if g_DWChaiJie_Confirmed ==1 then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("DoDiaowenAction")
			Set_XSCRIPT_ScriptID(900014)
			Set_XSCRIPT_Parameter(0, 103)
			Set_XSCRIPT_Parameter(1, g_DWChaiJie_Item)
			Set_XSCRIPT_Parameter(2, 0)
			Set_XSCRIPT_ParamCount(3)
		Send_XSCRIPT()
		g_DWChaiJie_Confirmed = -1
	end

end

--=========================================================
-- 关闭界面
--=========================================================
function DWChaiJie_Close()
	this:Hide()
	return
end

--=========================================================
-- 界面隐藏
--=========================================================
function DWChaiJie_OnHiden()
	StopCareObject_DWChaiJie()
	DWChaiJie_Clear()
	return
end

--=========================================================
-- 开始关心NPC，
-- 在开始关心之前需要先确定这个界面是不是已经有“关心”的NPC，
-- 如果有的话，先取消已经有的“关心”
--=========================================================
function BeginCareObject_DWChaiJie()
	this:CareObject(g_CaredNpc, 1, "DWChaiJie")
	return
end

--=========================================================
-- 停止对某NPC的关心
--=========================================================
function StopCareObject_DWChaiJie()
	this:CareObject(g_CaredNpc, 0, "DWChaiJie")
	g_CaredNpc = -1
	return
end


function DWChaiJie_Frame_On_ResetPos()
  DWChaiJie_Frame:SetProperty("UnifiedPosition", g_DWChaiJie_Frame_UnifiedPosition);
end

function DWChaiJie_ItemBtnRBClicked()
	DWChaiJie_Resume_DWInfo()
end
