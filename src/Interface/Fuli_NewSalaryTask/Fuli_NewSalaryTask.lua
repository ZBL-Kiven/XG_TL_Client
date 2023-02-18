--- �����������֮����½���
--- Author: ��ң�� 2019-11-14 15:16:36

local g_Frame_UnifiedXPosition;
local g_Frame_UnifiedYPosition;

local g_Fuli_NewSalaryTask_ObjCared = -1
local g_Fuli_NewSalaryTask_MAX_OBJ_DISTANCE = 3.0
local g_changeUI = 0

local g_Fuli_NewSalaryTask_ImageList  = {}        --- ����״̬ͼ��
local g_Fuli_NewSalaryTask_ButtonList = {}        --- ToolTips
local g_Fuli_NewSalaryTask_NameList   = {}        --- ��������
local g_Fuli_NewSalaryTask_ProgList   = {}        --- �����������

local g_Fuli_NewSalaryTask_Value_Count = 100000000  --- ���ڽ���MD1������

local CreateDate = 904691712			-- 2013��08��22��08:00:00
local nCharCreateDate = 0;
local g_bIsNewServerGiftsForLevelUpValid = 0
local g_SalaryTaskData = {} --��������
local g_ButtonPos = {
											[1] = {x =0, y = 0, tipx =0, tipy =0},
											[2] = {x =0, y = 0, tipx =0, tipy =0},
											[3] = {x =0, y = 0, tipx =0, tipy =0},
											[4] = {x =0, y = 0, tipx =0, tipy =0},
											[5] = {x =0, y = 0, tipx =0, tipy =0},
											[6] = {x =0, y = 0, tipx =0, tipy =0},
										}
										
local g_Fuli_NewSalaryTask_MaxValueByInedx = {
    [1] = { 2, 2, 40, 40,  4,  2,  3,  3 },     --- ��1�ȼ�����
    [2] = { 2, 2, 40,  4,  4,  3,  3,  3 },     --- ��2�ȼ�����
    [3] = { 2, 2, 40,  4,  4,  3,  3,  3 },     --- ��3�ȼ�����
}

local g_Fuli_NewSalaryTask_Level_Desc_New = {
    [1] = "#{GZGZ_120514_05}", 
    [2] = "#{GZGZ_120514_06}", 
    [3] = "#{GZGZ_120514_07}",
}

local Fuli_NewSalaryTask_ActList = {
    [1] = {
			[1] = { name="#{GZRW_XML_6}",     prog="/2",  tip="#{GZGZ_120514_10}", sImage="set:SalaryMission2 image:SalaryMission2_11", eImage="set:SalaryMission image:SalaryMission_11", }, --- ��ֻ
			[2] = { name="#{GZRW_XML_7}",     prog="/2",  tip="#{GZGZ_120514_22}", sImage="set:SalaryMission2 image:SalaryMission2_6",  eImage="set:SalaryMission image:SalaryMission_6",  }, --- һ����������
			[3] = { name="#{GZRW_XML_8}",     prog="/40", tip="#{GZGZ_120514_12}", sImage="set:SalaryMission2 image:SalaryMission2_3",  eImage="set:SalaryMission image:SalaryMission_3",  }, --- ʦ����������
			[4] = { name="#{GZRW_XML_9}",     prog="/40", tip="#{GZGZ_120514_14}", sImage="set:SalaryMission2 image:SalaryMission2_8",  eImage="set:SalaryMission image:SalaryMission_8",  }, --- �´����¥
			[5] = { name="#{GZRW_XML_10}",    prog="/4",  tip="#{GZGZ_120514_16}", sImage="set:SalaryMission2 image:SalaryMission2_13", eImage="set:SalaryMission image:SalaryMission_13", }, --- ���˿�����
			[6] = { name="#{GZRW_XML_11}",    prog="/2",  tip="#{GZGZ_120514_18}", sImage="set:SalaryMission2 image:SalaryMission2_10", eImage="set:SalaryMission image:SalaryMission_10", }, --- �ڲر�ͼ
            [7] = { name="#{GZRW_XML_12}",    prog="/3",  tip="#{GZGZ_120514_20}", sImage="set:SalaryMission2 image:SalaryMission2_4",  eImage="set:SalaryMission image:SalaryMission_4",  }, --- ��������
            [8] = { name="#{GZGZ_120514_33}", prog="/3",  tip="#{GZGZ_120514_34}", sImage="set:SalaryMission2 image:SalaryMission2_1",  eImage="set:SalaryMission image:SalaryMission_1",  }, --- һǧ��һ��Ը��
          },																																   
    [2] = {																																	   
			[1] = { name="#{GZRW_XML_6}",     prog="/2",  tip="#{GZGZ_120514_10}", sImage="set:SalaryMission2 image:SalaryMission2_11", eImage="set:SalaryMission image:SalaryMission_11", }, --- ��ֻ
			[2] = { name="#{GZGZ_120514_31}", prog="/2",  tip="#{GZGZ_120514_32}", sImage="set:SalaryMission2 image:SalaryMission2_5",  eImage="set:SalaryMission image:SalaryMission_5",  }, --- �ƽ�֮��
			[3] = { name="#{GZRW_XML_8}",     prog="/40", tip="#{GZGZ_120514_12}", sImage="set:SalaryMission2 image:SalaryMission2_3",  eImage="set:SalaryMission image:SalaryMission_3",  }, --- ʦ����������
			[4] = { name="#{GZGZ_120514_23}", prog="/4",  tip="#{GZGZ_120514_24}", sImage="set:SalaryMission2 image:SalaryMission2_2",  eImage="set:SalaryMission image:SalaryMission_2",  }, --- �ľ�ׯ
			[5] = { name="#{GZRW_XML_10}",    prog="/4",  tip="#{GZGZ_120514_16}", sImage="set:SalaryMission2 image:SalaryMission2_13", eImage="set:SalaryMission image:SalaryMission_13", }, --- ���˿�����
			[6] = { name="#{GZGZ_120514_25}", prog="/3",  tip="#{GZGZ_120514_26}", sImage="set:SalaryMission2 image:SalaryMission2_12", eImage="set:SalaryMission image:SalaryMission_12", }, --- ɱ��
			[7] = { name="#{GZGZ_120514_27}", prog="/3",  tip="#{GZGZ_120514_28}", sImage="set:SalaryMission2 image:SalaryMission2_7",  eImage="set:SalaryMission image:SalaryMission_7",  }, --- �۱���
            [8] = { name="#{GZGZ_120514_33}", prog="/3",  tip="#{GZGZ_120514_34}", sImage="set:SalaryMission2 image:SalaryMission2_1",  eImage="set:SalaryMission image:SalaryMission_1",  }, --- һǧ��һ��Ը��
          },																																   
    [3] = {																																	   
			[1] = { name="#{GZGZ_120514_29}", prog="/2",  tip="#{GZGZ_120514_30}", sImage="set:SalaryMission2 image:SalaryMission2_9",  eImage="set:SalaryMission image:SalaryMission_9",  }, --- ¥��Ѱ��
			[2] = { name="#{GZGZ_120514_31}", prog="/2",  tip="#{GZGZ_120514_32}", sImage="set:SalaryMission2 image:SalaryMission2_5",  eImage="set:SalaryMission image:SalaryMission_5",  }, --- �ƽ�֮��
			[3] = { name="#{GZRW_XML_8}",     prog="/40", tip="#{GZGZ_120514_12}", sImage="set:SalaryMission2 image:SalaryMission2_3",  eImage="set:SalaryMission image:SalaryMission_3",  }, --- ʦ����������
			[4] = { name="#{GZGZ_120514_23}", prog="/4",  tip="#{GZGZ_120514_24}", sImage="set:SalaryMission2 image:SalaryMission2_2",  eImage="set:SalaryMission image:SalaryMission_2",  }, --- �ľ�ׯ
			[5] = { name="#{GZRW_XML_10}",    prog="/4",  tip="#{GZGZ_120514_16}", sImage="set:SalaryMission2 image:SalaryMission2_13", eImage="set:SalaryMission image:SalaryMission_13", }, --- ���˿�����
			[6] = { name="#{GZGZ_120514_25}", prog="/3",  tip="#{GZGZ_120514_26}", sImage="set:SalaryMission2 image:SalaryMission2_12", eImage="set:SalaryMission image:SalaryMission_12", }, --- ɱ��
			[7] = { name="#{GZGZ_120514_27}", prog="/3",  tip="#{GZGZ_120514_28}", sImage="set:SalaryMission2 image:SalaryMission2_7",  eImage="set:SalaryMission image:SalaryMission_7",  }, --- �۱���
            [8] = { name="#{GZGZ_120514_33}", prog="/3",  tip="#{GZGZ_120514_34}", sImage="set:SalaryMission2 image:SalaryMission2_1",  eImage="set:SalaryMission image:SalaryMission_1",  }, --- һǧ��һ��Ը��
          },																			   
}																						   

---------------------------------------
--- ͳ�ƹ����������
--- ����˵����
--- taskLevel: 1, Index: 1: �������		0/2	    --- 401001  --- 1110
---                      2: һ����������	0/2	    --- 050102  --- 2100
---                      3: ʦ������		0/40                --- 3111
---                      4: �������¥		0/40                --- 4100
---                      5: ���˿����		0/4                 --- 5111
---                      6: �ڲر�ͼ		0/2                 --- 6100
---                      7: ��������		0/3                 --- 7100
---                      8: һǧ��һ��Ը��	0/3                 --- 8111
---
--- taskLevel: 2, Index: 1: �������		0/2     --- 401001  --- 1110
---                      2: �ƽ�֮��		0/2     --- 050220  --- 2011
---                      3: ʦ������		0/40                --- 3111
---                      4: �ľ�ׯ			0/4     --- 402052  --- 4011
---                      5: ���˿����		0/4                 --- 5111
---                      6: ɱ��			0/3     --- 402048  --- 6011
---                      7: �۱�����ȡ		0/3                 --- 7011
---                      8: һǧ��һ��Ը��	0/3                 --- 8111
--- 
--- taskLevel: 3, Index: 1: ¥��Ѱ��		0/2     --- 808039  --- 1001
---                      2: �ƽ�֮��		0/2     --- 050220  --- 2011
---                      3: ʦ������		0/40                --- 3111
---                      4: �ľ�ׯ			0/4     --- 402052  --- 4011
---                      5: ���˿����		0/4                 --- 5111
---                      6: ɱ��			0/3     --- 402048  --- 6011
---                      7: �۱�����ȡ		0/3                 --- 7011
---                      8: һǧ��һ��Ը��	0/3                 --- 8111
--- 
---------------------------------------

--2014��5��20�գ����������Ż�:start
local g_Fuli_NewSalaryTask_MaxValueByInedx_New = {	
	[1] = { 2, 2, 40, 40,  4,  2,  3,  2 },     --- ��1�ȼ����� 
    [2] = { 2, 2, 2,  40,  4,  3,  40,  3 },     --- ��2�ȼ�����
    [3] = { 1, 1, 1,  1,  1,  40,  1,  3 },     --- ��3�ȼ�����	
}
local Fuli_NewSalaryTask_ActList_New = {
    [1] = {
			[1] = { name="#{GZRW_XML_6}",     prog="/2",  tip="#{GZGZ_120514_10}", sImage="set:SalaryMission2 image:SalaryMission2_11", eImage="set:SalaryMission image:SalaryMission_11", }, --- ��ֻ
			[2] = { name="#{GZRW_XML_7}",     prog="/2",  tip="#{GZGZ_120514_22}", sImage="set:SalaryMission2 image:SalaryMission2_6",  eImage="set:SalaryMission image:SalaryMission_6",  }, --- һ����������
			[3] = { name="#{GZRW_XML_8}",     prog="/40", tip="#{GZGZ_120514_12}", sImage="set:SalaryMission2 image:SalaryMission2_3",  eImage="set:SalaryMission image:SalaryMission_3",  }, --- ʦ����������
			[4] = { name="#{GZRW_XML_9}",     prog="/40", tip="#{GZGZ_120514_14}", sImage="set:SalaryMission2 image:SalaryMission2_8",  eImage="set:SalaryMission image:SalaryMission_8",  }, --- �´����¥
			[5] = { name="#{GZRW_XML_10}",    prog="/4",  tip="#{GZGZ_120514_16}", sImage="set:SalaryMission2 image:SalaryMission2_13", eImage="set:SalaryMission image:SalaryMission_13", }, --- ���˿�����
			[6] = { name="#{GZRW_XML_11}",    prog="/2",  tip="#{GZGZ_120514_18}", sImage="set:SalaryMission2 image:SalaryMission2_10", eImage="set:SalaryMission image:SalaryMission_10", }, --- �ڲر�ͼ
            [7] = { name="#{GZRW_XML_12}",    prog="/3",  tip="#{GZGZ_120514_20}", sImage="set:SalaryMission2 image:SalaryMission2_4",  eImage="set:SalaryMission image:SalaryMission_4",  }, --- ��������							
            [8] = { name="#{GZGZ_120514_33}", prog="/2",  tip="#{GZGZ_120514_34}", sImage="set:SalaryMission2 image:SalaryMission2_1",  eImage="set:SalaryMission image:SalaryMission_1",  }, --- һǧ��һ��Ը��
          },																																   
    [2] = {																								   
			[1] = { name="#{GZGZ_120514_29}", prog="/2",  tip="#{GZGZ_120514_30}", sImage="set:SalaryMission2 image:SalaryMission2_9",  eImage="set:SalaryMission image:SalaryMission_9",  }, --- ¥��Ѱ��
			[2] = { name="#{GZGZ_120514_31}", prog="/2",  tip="#{GZGZ_120514_32}", sImage="set:SalaryMission2 image:SalaryMission2_5",  eImage="set:SalaryMission image:SalaryMission_5",  }, --- �ƽ�֮��		
			[3] = { name="#{GZGZ_120514_54}",     prog="/2", tip="#{GZGZ_120514_55}", sImage="set:SalaryMission2 image:SalaryMission2_15",  eImage="set:SalaryMission image:SalaryMission_15",  }, --- ��ս��翷�
			[4] = { name="#{GZRW_XML_9}",     prog="/40", tip="#{GZGZ_120514_14}", sImage="set:SalaryMission2 image:SalaryMission2_8",  eImage="set:SalaryMission image:SalaryMission_8",  }, --- �´����¥
			[5] = { name="#{GZGZ_120514_56}",    prog="/4",  tip="#{GZGZ_120514_57}", sImage="set:LongZhengWuZai_Icon3 image:LongZhengWuZai_Icon3_8", eImage="set:LongZhengWuZai_Icon1 image:LongZhengWuZai_Icon1_16", }, --- �ַ�������
            [7] = { name="#{GZGZ_120514_25}", prog="/3",  tip="#{GZGZ_120514_26}", sImage="set:SalaryMission2 image:SalaryMission2_12", eImage="set:SalaryMission image:SalaryMission_12", }, --- ɱ��
			[6] = { name="#{GZRW_XML_8}",     prog="/40", tip="#{GZGZ_120514_12}", sImage="set:SalaryMission2 image:SalaryMission2_3",  eImage="set:SalaryMission image:SalaryMission_3",  }, --- ʦ����������
            [8] = { name="#{GZRW_XML_12}",    prog="/3",  tip="#{GZGZ_120514_20}", sImage="set:SalaryMission2 image:SalaryMission2_4",  eImage="set:SalaryMission image:SalaryMission_4",  }, --- ��������
          },																																   
    [3] = {	
			[1] = { name="#{GZGZ_120514_29}", prog="/1",  tip="#{GZGZ_120514_30}", sImage="set:SalaryMission2 image:SalaryMission2_9",  eImage="set:SalaryMission image:SalaryMission_9",  }, --- ¥��Ѱ��
			[2] = { name="#{GZGZ_120514_31}", prog="/1",  tip="#{GZGZ_120514_32}", sImage="set:SalaryMission2 image:SalaryMission2_5",  eImage="set:SalaryMission image:SalaryMission_5",  }, --- �ƽ�֮��		
			[3] = { name="#{GZGZ_120514_54}",     prog="/1", tip="#{GZGZ_120514_55}", sImage="set:SalaryMission2 image:SalaryMission2_15",  eImage="set:SalaryMission image:SalaryMission_15",  }, --- ��ս��翷�
			[4] = { name="#{GZRW_XML_6}",     prog="/1",  tip="#{GZGZ_120514_10}", sImage="set:SalaryMission2 image:SalaryMission2_11", eImage="set:SalaryMission image:SalaryMission_11", }, --- ��ֻ
			[5] = { name="#{GZGZ_120514_56}",    prog="/1",  tip="#{GZGZ_120514_57}", sImage="set:LongZhengWuZai_Icon3 image:LongZhengWuZai_Icon3_8", eImage="set:LongZhengWuZai_Icon1 image:LongZhengWuZai_Icon1_16", }, --- �ַ�������
			[6] = { name="#{GZRW_XML_8}",     prog="/40", tip="#{GZGZ_120514_12}", sImage="set:SalaryMission2 image:SalaryMission2_3",  eImage="set:SalaryMission image:SalaryMission_3",  }, --- ʦ����������
            [7] = { name="#{GZGZ_120514_25}", prog="/1",  tip="#{GZGZ_120514_26}", sImage="set:SalaryMission2 image:SalaryMission2_12", eImage="set:SalaryMission image:SalaryMission_12", }, --- ɱ��
            [8] = { name="#{GZRW_XML_12}",    prog="/3",  tip="#{GZGZ_120514_20}", sImage="set:SalaryMission2 image:SalaryMission2_4",  eImage="set:SalaryMission image:SalaryMission_4",  }, --- ��������
          },																			   
}	

--- taskLevel: 1, Index: 1: �������		0/2	    --- 401001  --- 1100
---                      2: һ����������	0/2	    --- 050102  --- 2100
---                      3: ʦ������		0/40                --- 3100
---                      4: �۱�����ȡ		0/3                 --- 4111
---                      5: ���˿����		0/4                 --- 5100
---                      6: �ڲر�ͼ		0/2                 --- 6100
---                      7: ��������		0/2                 --- 7111
---                      8: һǧ��һ��Ը��	0/2                 --- 8100
---
--- taskLevel: 2, Index: 1: ¥��Ѱ��		0/2     --- 401001  --- 1011
---                      2: �ƽ�֮��		0/2     --- 050220  --- 2011
---                      3: ��ս��翷�		0/2                 --- 3011
---                      4: �۱�����ȡ		0/3     --- 402052  --- 4111
---                      5: �ַ�������		0/4                 --- 5011
---                      6: ɱ��			0/3     --- 402048  --- 6010
---                      7: ��������		0/10                --- 7111
---                      8: �ľ�ׯ			0/4                 --- 8011
---
--- taskLevel: 3, Index: 1: ¥��Ѱ��		0/2     --- 808039  --- 1011
---                      2: �ƽ�֮��		0/2     --- 050220  --- 2011
---                      3: ��ս��翷�		0/4                 --- 3011
---                      4: �۱�����ȡ		0/3     --- 402052  --- 4111
---                      5: �ַ�������		0/4                 --- 5011
---                      6: ��������		0/4     --- 402048  --- 6001
---                      7: ��������		0/15                --- 7111
---                      8: �ľ�ׯ			0/4                 --- 8011														
--2014��5��20�գ����������Ż�:end

function Fuli_NewSalaryTask_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	
	-- ��Ϸ���ڳߴ緢���˱仯
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- ��Ϸ�ֱ��ʷ����˱仯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false);
	this:RegisterEvent("OPEN_NEWSALARYTASK");
end

function Fuli_NewSalaryTask_OnLoad()
    g_Fuli_NewSalaryTask_ImageList[1] = Fuli_NewSalaryTask_StaticImageFrame1
    g_Fuli_NewSalaryTask_ImageList[2] = Fuli_NewSalaryTask_StaticImageFrame2
    g_Fuli_NewSalaryTask_ImageList[3] = Fuli_NewSalaryTask_StaticImageFrame3
    g_Fuli_NewSalaryTask_ImageList[4] = Fuli_NewSalaryTask_StaticImageFrame4
    g_Fuli_NewSalaryTask_ImageList[5] = Fuli_NewSalaryTask_StaticImageFrame5
    g_Fuli_NewSalaryTask_ImageList[6] = Fuli_NewSalaryTask_StaticImageFrame6
    g_Fuli_NewSalaryTask_ImageList[7] = Fuli_NewSalaryTask_StaticImageFrame7
    g_Fuli_NewSalaryTask_ImageList[8] = Fuli_NewSalaryTask_StaticImageFrame8
    
    g_Fuli_NewSalaryTask_ButtonList[1] = Fuli_NewSalaryTask_ButtonNULL1
    g_Fuli_NewSalaryTask_ButtonList[2] = Fuli_NewSalaryTask_ButtonNULL2
    g_Fuli_NewSalaryTask_ButtonList[3] = Fuli_NewSalaryTask_ButtonNULL3
    g_Fuli_NewSalaryTask_ButtonList[4] = Fuli_NewSalaryTask_ButtonNULL4
    g_Fuli_NewSalaryTask_ButtonList[5] = Fuli_NewSalaryTask_ButtonNULL5
    g_Fuli_NewSalaryTask_ButtonList[6] = Fuli_NewSalaryTask_ButtonNULL6
    g_Fuli_NewSalaryTask_ButtonList[7] = Fuli_NewSalaryTask_ButtonNULL7
    g_Fuli_NewSalaryTask_ButtonList[8] = Fuli_NewSalaryTask_ButtonNULL8

    g_Fuli_NewSalaryTask_NameList[1] = Fuli_NewSalaryTask_ItemName1
    g_Fuli_NewSalaryTask_NameList[2] = Fuli_NewSalaryTask_ItemName2
    g_Fuli_NewSalaryTask_NameList[3] = Fuli_NewSalaryTask_ItemName3
    g_Fuli_NewSalaryTask_NameList[4] = Fuli_NewSalaryTask_ItemName4
    g_Fuli_NewSalaryTask_NameList[5] = Fuli_NewSalaryTask_ItemName5
    g_Fuli_NewSalaryTask_NameList[6] = Fuli_NewSalaryTask_ItemName6
    g_Fuli_NewSalaryTask_NameList[7] = Fuli_NewSalaryTask_ItemName7
    g_Fuli_NewSalaryTask_NameList[8] = Fuli_NewSalaryTask_ItemName8

    g_Fuli_NewSalaryTask_ProgList[1] = Fuli_NewSalaryTask_completedinfo1
    g_Fuli_NewSalaryTask_ProgList[2] = Fuli_NewSalaryTask_completedinfo2
    g_Fuli_NewSalaryTask_ProgList[3] = Fuli_NewSalaryTask_completedinfo3
    g_Fuli_NewSalaryTask_ProgList[4] = Fuli_NewSalaryTask_completedinfo4
    g_Fuli_NewSalaryTask_ProgList[5] = Fuli_NewSalaryTask_completedinfo5
    g_Fuli_NewSalaryTask_ProgList[6] = Fuli_NewSalaryTask_completedinfo6
    g_Fuli_NewSalaryTask_ProgList[7] = Fuli_NewSalaryTask_completedinfo7
    g_Fuli_NewSalaryTask_ProgList[8] = Fuli_NewSalaryTask_completedinfo8
	
	-- ��������Ĭ�����λ��
	g_Frame_UnifiedXPosition	= Fuli_NewSalaryTask_Frame:GetProperty("UnifiedXPosition");
	g_Frame_UnifiedYPosition	= Fuli_NewSalaryTask_Frame:GetProperty("UnifiedYPosition");
		
end

-- OnEvent
function Fuli_NewSalaryTask_OnEvent(event)
    if( event == "UI_COMMAND" and tonumber(arg0) == 20170605 ) then
		--2014��5��20�գ����������Ż���start
		--g_changeUI = Get_XParam_INT(3)
		--if g_changeUI == 1 then
			--Fuli_NewSalaryTask_DetailDesc:ClearAllElement()
			Fuli_NewSalaryTask_DetailDesc:SetText( "#{GZGZ_120514_08}" )		
			g_Fuli_NewSalaryTask_MaxValueByInedx = g_Fuli_NewSalaryTask_MaxValueByInedx_New
			Fuli_NewSalaryTask_ActList = Fuli_NewSalaryTask_ActList_New	
		--end
		--���ݴ���
        local Str0 = tostring(Get_XParam_STR(0))
		--PushDebugMessage(g_Original_gxh_count)
		--PushDebugMessage(Str0)
		if Str0 ~= "" then 
			NSdata = Split(Str0, ",")
		else
			PushDebugMessage("Server�����쳣������XYJ-HL-CLIENT-01")
			return
		end
		for i =1,9 do
			g_SalaryTaskData[i] = tonumber(NSdata[i])
		end		
		--���ݴ���
		Fuli_NewSalaryTask_DetailDesc:Show()	
		--2014��5��20�գ����������Ż���end	
		Fuli_NewSalaryTask_Init()
		local SelfFuliUnionIPos = Variable:GetVariable("SelfFuliUIPos")
		if( SelfFuliUnionIPos ~= nil) then
			Fuli_NewSalaryTask_Frame:SetProperty("UnifiedPosition", SelfFuliUnionIPos )
		end
			
		this:Show()
	elseif( event == "ADJEST_UI_POS" ) then
		Fuli_NewSalaryTask_ResetPos()
	elseif( event == "VIEW_RESOLUTION_CHANGED" ) then
		Fuli_NewSalaryTask_ResetPos()
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		Fuli_NewSalaryTask_OnClosed()
	elseif event == "OPEN_NEWSALARYTASK" then
		if(tonumber(arg0) == 0) then
			Fuli_NewSalaryTask_ResetPos()
		else
			Fuli_NewSalaryTask_SetLastPos()
		end
	end

end

--================================================
-- �����Ĭ�����λ��
--================================================
function Fuli_NewSalaryTask_ResetPos()
	Fuli_NewSalaryTask_Frame:SetProperty("UnifiedXPosition", g_Frame_UnifiedXPosition);
	Fuli_NewSalaryTask_Frame:SetProperty("UnifiedYPosition", g_Frame_UnifiedYPosition);
end

function Fuli_NewSalaryTask_SetLastPos()
	local SelfFuliUnionIPos = Variable:GetVariable("SelfFuliUIPos")
	if( SelfFuliUnionIPos ~= nil) then
	    Fuli_NewSalaryTask_Frame:SetProperty("UnifiedPosition", SelfFuliUnionIPos )
	end
end

function Fuli_NewSalaryTask_Init()
--    local stData1 = Get_XParam_INT( 1 )
--	local stData2 = Get_XParam_INT( 2 )

    local salaryLevel = g_SalaryTaskData[9] --�ھ�λ�ǹ��ʵȼ�
    if salaryLevel <= 0 then
        salaryLevel = 1
    end

	Fuli_NewSalaryTask_thelevel:SetText( g_Fuli_NewSalaryTask_Level_Desc_New[salaryLevel] )
	
    --- tempData[1-8] ��ŵ��ǵ�ǰ������[1-8]����
	local tempData = {}
	local nIndex = 0
	for i = 1, 8 do
		--nIndex =  nIndex + 1
		tempData[i] = g_SalaryTaskData[i]
		--stData1 = math.floor( stData1 / 100 )
	end
	
	--for i = 1, 4 do
		--nIndex =  nIndex + 1
		--tempData[nIndex] = math.mod( stData2, 100 ) 
		--stData2 = math.floor( stData2 / 100 )
	--end

    for i = 1, 8 do
        --- ��������Ѿ������, ����ͼ��
        if tempData[i] == g_Fuli_NewSalaryTask_MaxValueByInedx[salaryLevel][i] then
            g_Fuli_NewSalaryTask_ImageList[i]:SetProperty("Image", Fuli_NewSalaryTask_ActList[salaryLevel][i].eImage );
        else
            g_Fuli_NewSalaryTask_ImageList[i]:SetProperty("Image", Fuli_NewSalaryTask_ActList[salaryLevel][i].sImage );
        end

        --- ������������
        g_Fuli_NewSalaryTask_NameList[i]:SetText( Fuli_NewSalaryTask_ActList[salaryLevel][i].name )

        --- ���������Ϣ
        g_Fuli_NewSalaryTask_ProgList[i]:SetText( tostring( tempData[i] )..Fuli_NewSalaryTask_ActList[salaryLevel][i].prog )

        --- ����ToolTips
        g_Fuli_NewSalaryTask_ButtonList[i]:SetToolTip( Fuli_NewSalaryTask_ActList[salaryLevel][i].tip )
    end

	local text1 = "#cfff263Ŀǰ���а�Ԫ��������#G"..DataPool:GetPlayerMission_DataRound(305)
	Fuli_NewSalaryTask_Text:SetText( "" )	
		nSuperSaveUp =-1; 
    return
end

function Fuli_NewSalaryTask_OnClosed()
    this:Hide()
    return
end

function Fuli_NewSalaryTask_Button1_Click()
	Lua_OpenFuliPage(1)
	Variable:SetVariable("SelfFuliUIPos", Fuli_NewSalaryTask_Frame:GetProperty("UnifiedPosition"), 1)
end

function Fuli_NewSalaryTask_Button2_Click()
	local nLevel = Player:GetData("LEVEL");
	if ( nLevel < 15 ) then
		PushDebugMessage("#{FLRK_160608_10}")
		return
	end
	Lua_OpenFuliPage(2)
	Variable:SetVariable("SelfFuliUIPos", Fuli_NewSalaryTask_Frame:GetProperty("UnifiedPosition"), 1)
end

function Fuli_NewSalaryTask_Button3_Click()
	Lua_OpenFuliPage(3)
	Variable:SetVariable("SelfFuliUIPos", Fuli_NewSalaryTask_Frame:GetProperty("UnifiedPosition"), 1)
end

function Fuli_NewSalaryTask_Button4_Click()
	Lua_OpenFuliPage(4)
	Variable:SetVariable("SelfFuliUIPos", Fuli_NewSalaryTask_Frame:GetProperty("UnifiedPosition"), 1)
--	this:Hide()
end

function Fuli_NewSalaryTask_Button5_Click()
	local nLevel = Player:GetData("LEVEL");
	if ( nLevel < 60 ) then
		PushDebugMessage("#{JFRW_170217_4}")
		return
	end
	
	Lua_OpenFuliPage(5)
	Variable:SetVariable("SelfFuliUIPos", Fuli_NewSalaryTask_Frame:GetProperty("UnifiedPosition"), 1)
end

function Fuli_NewSalaryTask_Button6_Click()
	
end

function Fuli_NewSalaryTask_Button7_Click()
	local nLevel = Player:GetData("LEVEL");
	if ( nLevel < 15 ) then
		PushDebugMessage("#{MRLB_170623_03}")
		return
	end
	Lua_OpenFuliPage(7)
	Variable:SetVariable("SelfFuliUIPos", Fuli_NewSalaryTask_Frame:GetProperty("UnifiedPosition"), 1)
end

function Fuli_NewSalaryTask_Button8_Click()
	Lua_OpenFuliPage(8)
	Variable:SetVariable("SelfFuliUIPos", Fuli_NewSalaryTask_Frame:GetProperty("UnifiedPosition"), 1)
end

function Fuli_NewSalaryTask_Button9_Click()
	Lua_OpenFuliPage(9)
	Variable:SetVariable("SelfFuliUIPos", Fuli_NewSalaryTask_Frame:GetProperty("UnifiedPosition"), 1)
end

function Fuli_NewSalaryTask_Bk_Help_Click()
end