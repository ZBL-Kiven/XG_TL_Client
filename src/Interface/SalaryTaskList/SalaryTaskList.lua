
--������Ϸ����
--author:dengxx 2009.07.19
local objCared = -1
local MAX_OBJ_DISTANCE = 3.0
local SalaryTask_ActList = {
			[1]= {name="#{GZRW_XML_6}",  prog="/2", tip="#{GZRW_090715_02}",}, --��ֻ
			[2]= {name="#{GZRW_XML_7}",  prog="/2", tip="#{GZRW_090715_03}",}, --һ����������
			[3]= {name="#{GZRW_XML_8}",  prog="/20",tip="#{GZRW_090715_04}",}, --ʦ����������
			[4]= {name="#{GZRW_XML_9}",  prog="/40",tip="#{GZRW_090715_05}",},--�´����¥
			[5]= {name="#{GZRW_XML_10}", prog="/4", tip="#{GZRW_090715_06}",},--���˿�����
			[6]= {name="#{GZRW_XML_11}", prog="/2", tip="#{GZRW_090715_07}",},--�ڱ�
			[7]= {name="#{GZRW_XML_12}", prog="/3", tip="#{GZRW_090715_08}",},--��������
			[8]= {name="#{GZRW_XML_13}", prog="/3", tip="#{GZRW_090715_09}",},--͵Ϯ����			
}

--taskIndex:  1:��ֻ
--            2:һ����������
--            3:ʦ����������
--            4:�´����¥
--            5:���˿�����
--            6:�ڱ�
--            7:��������
--            8:͵Ϯ����

function SalaryTaskList_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("OBJECT_CARED_EVENT")
end

function SalaryTaskList_OnLoad()
		
end

-- OnEvent
function SalaryTaskList_OnEvent(event)
  if( event == "UI_COMMAND" and tonumber(arg0) == 8121 ) then
		SalaryTaskList_Init()
		this:Show()
		objCared = Get_XParam_INT(0)
		objCared = Target:GetServerId2ClientId(objCared)
		this:CareObject(objCared, 1, "SalaryTaskList")
	elseif(event == "OBJECT_CARED_EVENT") then
		if(tonumber(arg0) ~= objCared) then
			return
		end
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			SalaryTaskList_OnClosed()
			this:CareObject(objCared, 0, "SalaryTaskList")
		end
	end
end

function SalaryTaskList_Init()
	
	SalaryTaskList_ListCtl:RemoveAllItem()
	SalaryTaskList_DetailDesc:ClearAllElement()	
	local stData1 = Get_XParam_INT(1)
	local stData2 = Get_XParam_INT(2)
	if stData1 and stData1 < 0 then 
		stData1 = 0 
	end
	if stData2 and stData2 < 0 then 
		stData2 = 0 
	end
	
	local dataList={}
  local index = 0
  
  for i = 1, 5 do
  	index =  index + 1
		dataList[index] = math.mod(stData1,100) 
		stData1 = math.floor(stData1/100)
	end
	
	for i = 1, 3 do
		index =  index + 1
		dataList[index] = math.mod(stData2,100) 
		stData2 = math.floor(stData2/100)
	end
	
  
  for i=1,8 do
  	SalaryTaskList_ListCtl:AddNewItem(SalaryTask_ActList[i].name, 0, i-1)
  	SalaryTaskList_ListCtl:AddNewItem(dataList[i]..SalaryTask_ActList[i].prog, 1, i-1)	
  end

	SalaryTaskList_DetailDesc:AddTextElement("#{GZRW_XML_14}#r#{GZRW_090928_01}")
	SalaryTaskList_DetailDesc:Show()
end


-- ��������������Ӧ����
function SalaryTaskList_ListCtl_OnSelectionChanged()
	SalaryTaskList_DetailDesc:ClearAllElement()
	local nSel = SalaryTaskList_ListCtl:GetSelectItem()	-- ��ǰѡ����к�
	if nSel >= 0 then
		SalaryTaskList_DetailDesc:AddTextElement(SalaryTask_ActList[nSel+1].tip)
	else
		SalaryTaskList_DetailDesc:AddTextElement("#{GZRW_XML_14}#r#{GZRW_090928_01}")
  end
  SalaryTaskList_DetailDesc:Show()
end

-- �ر�
function SalaryTaskList_OnClosed()
	SalaryTaskList_DetailDesc:ClearAllElement()
	this:Hide()
end

-- ȡ��
function SalaryTaskList_OnCancel()
	SalaryTaskList_DetailDesc:ClearAllElement()
	this:Hide()
end
