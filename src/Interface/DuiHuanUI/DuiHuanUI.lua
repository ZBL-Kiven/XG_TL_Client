
local g_DuiHuanUI_Frame_UnifiedPosition;


function DuiHuanUI_PreLoad()
	this:RegisterEvent("UI_COMMAND");
		-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("SCENE_TRANSED")
end


function DuiHuanUI_OnLoad()--载入
	DuiHuanUI_Bk_Icon = {
		DuiHuanUI_Bk_Icon1	,
		DuiHuanUI_Bk_Icon2	,
		DuiHuanUI_Bk_Icon3	,
		DuiHuanUI_Bk_Icon4	,
		DuiHuanUI_Bk_Icon5	,
		DuiHuanUI_Bk_Icon6	,
		DuiHuanUI_Bk_Icon7	,
		DuiHuanUI_Bk_Icon8	,
		DuiHuanUI_Bk_Icon9	,
		DuiHuanUI_Bk_Icon10	,
		DuiHuanUI_Bk_Icon11	,
		DuiHuanUI_Bk_Icon12	,
		DuiHuanUI_Bk_Icon13	,
		DuiHuanUI_Bk_Icon14	,
		DuiHuanUI_Bk_Icon15	,
		DuiHuanUI_Bk_Icon16	,
		DuiHuanUI_Bk_Icon17	,
		DuiHuanUI_Bk_Icon18	,
		DuiHuanUI_Bk_Icon19	,
		DuiHuanUI_Bk_Icon20	,
		DuiHuanUI_Bk_Icon21	,
		DuiHuanUI_Bk_Icon22	,
		DuiHuanUI_Bk_Icon23	,
		DuiHuanUI_Bk_Icon24	,
		DuiHuanUI_Bk_Icon25	,
		DuiHuanUI_Bk_Icon26	,
		DuiHuanUI_Bk_Icon27	,
		DuiHuanUI_Bk_Icon28	,
		DuiHuanUI_Bk_Icon29	,
		DuiHuanUI_Bk_Icon30	,
		DuiHuanUI_Bk_Icon31	,
		DuiHuanUI_Bk_Icon32	,
		DuiHuanUI_Bk_Icon33	,
		DuiHuanUI_Bk_Icon34	,
		DuiHuanUI_Bk_Icon35	,
		DuiHuanUI_Bk_Icon36	,
		DuiHuanUI_Bk_Icon37	,
		DuiHuanUI_Bk_Icon38	,
		DuiHuanUI_Bk_Icon39	,
		DuiHuanUI_Bk_Icon40	,
		DuiHuanUI_Bk_Icon41	,
		DuiHuanUI_Bk_Icon42	,
		DuiHuanUI_Bk_Icon43	,
		DuiHuanUI_Bk_Icon44	,
		DuiHuanUI_Bk_Icon45	,
		DuiHuanUI_Bk_Icon46	,
		DuiHuanUI_Bk_Icon47	,
		DuiHuanUI_Bk_Icon48	,
		DuiHuanUI_Bk_Icon49	,
		DuiHuanUI_Bk_Icon50,
		DuiHuanUI_Bk_Icon51,
		DuiHuanUI_Bk_Icon52,
		DuiHuanUI_Bk_Icon53,
		DuiHuanUI_Bk_Icon54,
		DuiHuanUI_Bk_Icon55,
		DuiHuanUI_Bk_Icon56,
		DuiHuanUI_Bk_Icon57,
		DuiHuanUI_Bk_Icon58,
		DuiHuanUI_Bk_Icon59,
		DuiHuanUI_Bk_Icon60,
		DuiHuanUI_Bk_Icon61,
		DuiHuanUI_Bk_Icon62,
		DuiHuanUI_Bk_Icon63,
		DuiHuanUI_Bk_Icon64,
		DuiHuanUI_Bk_Icon65,
		DuiHuanUI_Bk_Icon66,
		DuiHuanUI_Bk_Icon67,
		DuiHuanUI_Bk_Icon68,
		DuiHuanUI_Bk_Icon69,
		DuiHuanUI_Bk_Icon70,
	}
   g_DuiHuanUI_Frame_UnifiedPosition=DuiHuanUI_Frame:GetProperty("UnifiedPosition");
end

function DuiHuanUI_ResetPos()-- 游戏窗口尺寸发生了变化
  DuiHuanUI_Frame:SetProperty("UnifiedPosition", g_DuiHuanUI_Frame_UnifiedPosition);
end
function DuiHuanUI_qingchushuju() --清除数据
	for i=1,table.getn(DuiHuanUI_Bk_Icon) do
		DuiHuanUI_Bk_Icon[i]:Hide()--隐藏主窗口
	end
end

local szSeparator=","
local yixuanzeID = 0 --选择的道具
local fanhuiID = 0 --返回脚本ID
local shuzu = {}
local shuzu2 = {}


function DuiHuanUI_Split(szFullString, szSeparator)
	local nFindStartIndex = 1    
	local nSplitIndex = 1    
	local nSplitArray = {}    
	while true do    
		local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)    
		if not nFindLastIndex then    
			nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))    
			break    
		end    
		nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)    
		nFindStartIndex = nFindLastIndex + string.len(szSeparator)    
		nSplitIndex = nSplitIndex + 1    
	end
	return nSplitArray
end




function DuiHuanUI_OnEvent(event)
	if event == "UI_COMMAND"  and tonumber(arg0) == 20170204 then   ---升级好礼
		fanhuiID = Get_XParam_INT(0)
		DuiHuanUI_qingchushuju() --先隐藏所有功能
		
		if Get_XParam_STR(1) ~= nil then
			shuzu = DuiHuanUI_Split(Get_XParam_STR(1), szSeparator) --将文本打成数组
		end
		--潇湘加入
		for i=1,table.getn(shuzu) do
			if shuzu[i]~="" then
				shuzu[i]=tostring(tonumber("0x"..shuzu[i],16))
			end
		end
		for i=1,table.getn(shuzu) do
			if shuzu[i] ~= nil and shuzu[i] ~= "" and tonumber(shuzu[i]) > 10000000 then
				DuiHuanUI_Bk_Icon[i]:Show();
				local PrizeAction = GemMelting:UpdateProductAction(tonumber(shuzu[i]))
				DuiHuanUI_Bk_Icon[i]:SetActionItem(PrizeAction:GetID()); --显示物品
			end
		end
		
		
		
		DuiHuanUI_DragTitle:SetText("#gFF0FA0"..Get_XParam_STR(0)) --兑换系统
		DuiHuanUI_Frame_Texta1:SetText("尚未选择道具") --您已选择兑换：
		DuiHuanUI_Frame_Texta2:SetText("") --兑换所需道具：
		DuiHuanUI_Frame_Texta3:SetText("") --道具消耗数量：
		DuiHuanUI_OK:Disable();--黑掉兑换

		
		this:Show();
		
		
	elseif event == "UI_COMMAND"  and tonumber(arg0) == 20170205 then   ---升级好礼
		if Get_XParam_STR(0) ~= nil then
			shuzu2 = DuiHuanUI_Split(Get_XParam_STR(0), szSeparator) --将文本打成数组
		end
		yixuanzeID = Get_XParam_INT(0)
		DuiHuanUI_Clicked2(yixuanzeID) --选择
		
	elseif( event == "ADJEST_UI_POS" ) then
		DuiHuanUI_ResetPos()
	elseif( event == "VIEW_RESOLUTION_CHANGED" ) then
		DuiHuanUI_ResetPos()
	elseif (event == "SCENE_TRANSED") then
		this:Hide()--隐藏主窗口
	end
end


function DuiHuanUI_Clicked(nIndex) --选择
	for i=1,table.getn(DuiHuanUI_Bk_Icon) do
		DuiHuanUI_Bk_Icon[i]:SetPushed(0);--清空点选
	end
	-- 执行脚本
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "GetGiftsForUI" ); 	-- 脚本函数名称
		Set_XSCRIPT_ScriptID( 889064 );-- 脚本编号
		Set_XSCRIPT_Parameter( 0, -131495 );	-- 参数一
		Set_XSCRIPT_Parameter( 1, tonumber( nIndex ) );	-- 参数一
		Set_XSCRIPT_Parameter( 2, tonumber(shuzu[nIndex]) );	-- 参数一
		Set_XSCRIPT_ParamCount( 3 );						-- 参数个数
	Send_XSCRIPT()
end

function DuiHuanUI_Clicked2(nIndex) --选择
	DuiHuanUI_Bk_Icon[nIndex]:SetPushed(1);--点选
	DuiHuanUI_OK:Enable(); --开兑换
	DuiHuanUI_Frame_Texta1:SetText("#G兑换#W["..shuzu2[1].."]") --您已选择兑换：
	DuiHuanUI_Frame_Texta2:SetText("#G需要"..shuzu2[2]) --兑换所需道具：
	DuiHuanUI_Frame_Texta3:SetText("") --道具消耗数量：
end

--选项
function DuiHuanUI_OK_Clicked(nIndex) --确定
	-- 执行脚本
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "GetGiftsForUI" ); 	-- 脚本函数名称
		Set_XSCRIPT_ScriptID( 889064 );						-- 脚本编号
		Set_XSCRIPT_Parameter( 0, -131494 );	-- 参数一
		Set_XSCRIPT_Parameter( 1, tonumber( 0 ) );	-- 参数一
		Set_XSCRIPT_Parameter( 2, tonumber(shuzu[yixuanzeID]) );	-- 参数一
		Set_XSCRIPT_ParamCount( 3 );						-- 参数个数
	Send_XSCRIPT()
end



