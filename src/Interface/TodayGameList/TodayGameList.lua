
--今日游戏进度
--author:dengxx 2009.06.19
local TodayGameList_QuitType = 0 --退出方式 1： 退出游戏 2：返回登录界面

local TodayGameList_ActList = {
			[1]= {min=10,max =160,name="#{XXTSP_090619_XML_004}",prog="#{XXTSP_090619_XML_014}",tip="#{XXTSP_090619_XML_021}",}, --双倍经验
			[2]= {min=10,max =19,name="#{XXTSP_090619_XML_005}",prog="#{XXTSP_090619_XML_015}",tip="#{XXTSP_090619_XML_022}",}, --师门任务
			[3]= {min=20,max =39,name="#{XXTSP_090619_XML_005}",prog="#{XXTSP_090619_XML_016}",tip="#{XXTSP_090619_XML_023}",},
			[4]= {min=40,max =74,name="#{XXTSP_090619_XML_005}",prog="#{XXTSP_090619_XML_017}",tip="#{XXTSP_090619_XML_024}",},
			[5]= {min=10,max =74,name="#{XXTSP_090619_XML_006}",prog="#{XXTSP_090619_XML_018}",tip="#{XXTSP_090619_XML_025}",}, --科举答题
			[6]= {min=10,max =160,name="#{XXTSP_090619_XML_007}",prog="#{XXTSP_090619_XML_018}",tip="#{XXTSP_090619_XML_026}",},--珍珑棋局
			[7]= {min=75,max =160,name="#{XXTSP_090619_XML_008}",prog="#{XXTSP_090619_XML_018}",tip="#{XXTSP_090619_XML_027}",},--楼兰寻宝
			[8]= {min=30,max =160,name="#{XXTSP_090619_XML_009}",prog="#{XXTSP_090619_XML_019}",tip="#{XXTSP_090619_XML_028}",},--一个都不能跑
			[9]= {min=75,max =160,name="#{XXTSP_090619_XML_010}",prog="#{XXTSP_090619_XML_019}",tip="#{XXTSP_090619_XML_029}",},--黄金之链
			[10]={min=75,max =160,name="#{XXTSP_090619_XML_011}",prog="#{XXTSP_090619_XML_020}",tip="#{XXTSP_090619_XML_030}",},--初战缥缈峰（较难）
			[11]={min=20,max =160,name="#{XXTSP_090619_XML_012}",prog="#{XXTSP_090619_XML_018}",tip="#{XXTSP_090619_XML_031}",},	--幸运快活三
			[12]={min=30,max =160,name="#{XXTSP_090619_XML_013}",prog="#{XXTSP_090619_XML_018}",tip="#{XXTSP_090619_XML_032}",},--寒玉谷修行
}
local TodayGameList_IndexList ={}
function TodayGameList_PreLoad()
	this:RegisterEvent("SHOW_GAME_PROGRESS");
	this:RegisterEvent("UI_COMMAND");	
end

function TodayGameList_OnLoad()
		
end

-- OnEvent
function TodayGameList_OnEvent(event)
	
	if ( event == "UI_COMMAND" and tonumber(arg0) == 20200517 ) then
		TodayGameList_QuitType = tonumber(arg1);
		--请求一些数据回来
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("AuditGameProgess");
			Set_XSCRIPT_ScriptID(800120);
			Set_XSCRIPT_ParamCount(0);
		Send_XSCRIPT();
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 800120 ) then
		TodayGameList_Init()
		this:Show()
	end
end

function TodayGameList_Init()
	
	TodayGameList_ListCtl:RemoveAllItem();
	local level = Player:GetData("LEVEL")
	local index = 0
	local showList ={}
	
	for i,act in TodayGameList_ActList do
		
		if level >=act.min and level <= act.max then
			
			TodayGameList_IndexList[index]=i
		
			TodayGameList_ListCtl:AddNewItem(act.name, 0, index)
			local nCount = Get_XParam_INT(index)
			if nCount and nCount < 0 then 
				nCount = 0 
			end
			TodayGameList_ListCtl:AddNewItem(tostring(nCount)..act.prog, 1, index)
			index = index + 1
		end
		
	end
	---默认选择第一条
	TodayGameList_ListCtl:SetSelectItem(0)
	TodayGameList_Explain1:SetText(TodayGameList_ActList[1].tip)
	
end

function TodayGameList_OnOK()
	
	if TodayGameList_QuitType == 1 then          --退出游戏
		EnterQuitWait(0);
	elseif TodayGameList_QuitType == 2 then      --返回登录界面
		EnterQuitWait(2);
	else
		return
	end
	
end
---------------------
--打开活动日程
----------------------
function TodayGameList_OnOpenCampList()
  OpenTodayCampaignList();
end

-- 鼠标点击具体活动后的相应函数
function TodayGameList_ListCtl_OnSelectionChanged()

	TodayGameList_Explain1:SetText("#{XXTSP_090630_XML_038}");	
	
	local nSel = TodayGameList_ListCtl:GetSelectItem();	-- 当前选择的行号
	if nSel >= 0 then
	   TodayGameList_Explain1:SetText(TodayGameList_ActList[TodayGameList_IndexList[nSel]].tip);
  end
	TodayGameList_Explain1:Show();	
end

-- 关闭
function TodayGameList_OnClosed()
	this:Hide();
	TodayGameList_QuitType = 0
	TodayGameList_IndexList ={}
end

-- 取消
function TodayGameList_OnCancel()
	this:Hide()
	TodayGameList_QuitType = 0
	TodayGameList_IndexList ={}
end
