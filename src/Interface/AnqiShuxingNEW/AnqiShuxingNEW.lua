-- !!!reloadscript =AnqiShuxingNEW
-- 10155001	飞蝗石
-- 10155002	冰魄神针
-- 10155003	梅花镖
-- !!createitem = 10155002 = 1=1
-- !!createitem = 30503118 = 1=100

--暗器 属性调整页面
local MAX_OBJ_DISTANCE = 3.0;
local objCared = -1;
local g_Object = -1;
local AnqiShuxingNEW_g_CommandType = 1
local Dark_Bag_Index = -1
local Dark_Attr_Name = {[1] = "#{equip_attr_str}",[2] = "#{equip_attr_spr}",[3] = "#{equip_attr_con}",[4] = "#{equip_attr_int}",[5] = "#{equip_attr_dex}",}

-- 0表示没有进行过重洗 1 表示重洗完成
local Dark_chongxi_state =0

function AnqiShuxingNEW_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("RESUME_ENCHASE_GEM");           --参见\ClientLib\Ui_cegui\UISystem.cpp，line:1018
	--金钱改变的处理
	this:RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("MONEYJZ_CHANGE");

	-- new

	this:RegisterEvent("UI_REGEN_DARKITEM");
	-- this:RegisterEvent("CLEAN_ANQI_DATA");
	this:RegisterEvent("DARK_SKILL_UPDATE_RECOIN");
	this:RegisterEvent("DARK_SKILL_RECOIN_CONFIRM_OK");


end

function AnqiShuxingNEW_OnLoad()
	--Dark_Button = AnqiShuxingNEW_BeforeIcon;
	--Dark_New_Button = AnqiShuxingNEW_AfterIcon;
	Dark_chongxi_state =0;
end

function AnqiShuxingNEW_OnEvent(event)
	if(event == "UI_COMMAND" and tonumber(arg0) == 800034) then
		if this : IsVisible() then									-- 如果界面开着，则不处理
			AnqiShuxingNEW_Close();
		end

		objCared = -1;
		local xx = Get_XParam_INT(1);
		objCared = DataPool : GetNPCIDByServerID(xx);

		if objCared == -1 then
				PushDebugMessage("server传过来的数据有问题。");
				return;
		end
		AnqiShuxingNEW_BeginCareObject(objCared);

		AnqiShuxingNEW_g_CommandType = Get_XParam_INT(0);
		if AnqiShuxingNEW_g_CommandType ==6 then
			AnqiShuxingNEW_InitDlg();
		end
	elseif (event == "UI_COMMAND" ) and tonumber(arg0) == 8000341 then
		AnqiShuxingNEW_Reset(0)
		AnqiShuxingNEW_Update(Dark_Bag_Index)

	elseif (event == "UI_REGEN_DARKITEM" and this:IsVisible()) then

			AnqiShuxingNEW_Update(arg0);
	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if(tonumber(arg0) ~= objCared) then
			return;
		end

	--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then

			--取消关心
			AnqiShuxingNEW_Close()
		end
	elseif(event == "RESUME_ENCHASE_GEM" and this:IsVisible())then
		if(tonumber(arg0) == 140) then
			AnqiShuxingNEW_Clear();
		end
	elseif( (event == "UNIT_MONEY" or event == "MONEYJZ_CHANGE") and this:IsVisible()) then
		AnqiShuxingNEW_UpdateMoneyDisp();

	-- elseif(event == "CLEAN_ANQI_DATA" and this:IsVisible()) then
		-- AnqiShuxingNEW_Update(arg0);
	--重洗暗器技能生成新的数据
	elseif (event == "DARK_SKILL_UPDATE_RECOIN" and this:IsVisible()) then
			AnqiShuxingNEW_UpDateRecoin();

	elseif (event == "DARK_SKILL_RECOIN_CONFIRM_OK") then
		if tonumber(arg1) == 1 then
			AnqiShuxingNEW_Reset(1) --先把原来的清空了
			AnqiShuxingNEW_Update(arg0) --再放上新的~
		elseif tonumber(arg1) == 0 then
			AnqiShuxingNEW_Reset(1)
			this:Hide()
		elseif tonumber(arg1) == 2 then
			AnqiShuxingNEW_Reset(1) --先把原来的清空了
		end
	end
end

function AnqiShuxingNEW_UpdateMoneyDisp()
		local playerMoney = Player:GetData("MONEY");
		local playerMoneyJZ = Player:GetData("MONEY_JZ");
		AnqiShuxingNEW_WantNum:SetProperty("MoneyMaxNumber", playerMoney + playerMoneyJZ);
		--AnqiShuxing_NeedMoney:SetProperty("MoneyNumber", nNeed);
		AnqiShuxingNEW_HaveNum:SetProperty("MoneyNumber", playerMoneyJZ);
		AnqiShuxingNEW_HaveGoldNum:SetProperty("MoneyNumber", playerMoney);
end

function AnqiShuxingNEW_InitDlg( )
--	if (AnqiShuxingNEW_g_CommandType == 6) then   --重洗暗器技能
	--重洗暗器技能
		AnqiShuxingNEW_Reset(1)
		AnqiShuxingNEW_DragTitle:SetText("#{FBSJ_081209_80}");
		--如果对暗器领悟的技能不满意，可以使用忘无石将技能重洗。重洗后可选择使用新的技能或保留原有技能。
--注意：重洗时暗器的所有技能都将被重置。重洗完成后如果您进行关闭重洗技能界面、取消暗器放入状态、更换已放入的暗器等操作，均视为保留原有技能操作。

		AnqiShuxingNEW_Info:SetText("#{FBSJ_081209_56}");
		--请放入暗器
		AnqiShuxingNEW_BeforeText:SetText("#{CXYH_140813_1}");
		--
		AnqiShuxingNEW_UpdateMoneyDisp();
		AnqiShuxingNEW_WantNum:SetProperty("MoneyNumber", 50000);
		this:Show();
		AnqiShuxingNEW_OK:Disable();

--	end
end

function AnqiShuxingNEW_OK_Clicked()

	--一共三项需要安全检查: 重洗暗器原始属性;重洗暗器技能;重置暗器修炼等级

	if CheckPhoneMibaoAndMinorPassword() ~= 1 then
		return
	end
		-- 判断是否为安全时间 在安全时间内无法进行此操作。打开包裹栏，点击防盗号按钮可以自行设置安全时间。
	-- if (tonumber(DataPool:GetLeftProtectTime()) > 0) then
	-- 	PushDebugMessage("#{CXYH_140813_11}")
	-- 	return
	-- end

	--硬件密保
	--畅游+
	--电话密保
	--二级密码

	--判断高级密保 对不起，您需要解锁硬件密保再进行以下操作。
	if CheckPhoneMibaoAndMinorPassword() ~= 1 then
		PushDebugMessage("#{CXYH_140813_12}")
		return
	end

	--请先放入暗器。
	if (Dark_Bag_Index == -1) then
		PushDebugMessage("#{CXYH_140813_16}")
	end

	--是否有物品 缺少道具忘无石或者背包中的忘无石已加锁！

	local EquipPoint = LifeAbility : Get_Equip_Point(Dark_Bag_Index)
	if (EquipPoint ~= 17) then
		PushDebugMessage("#{FBSJ_081209_37}")
	end
	--客户端预先判断金钱，减轻服务器压力
	local nHave = AnqiShuxingNEW_WantNum:GetProperty("MoneyMaxNumber");
	local nNeed = AnqiShuxingNEW_WantNum:GetProperty("MoneyNumber");
	if (tonumber(nNeed) > tonumber(nHave)) then
		PushDebugMessage("#{CXYH_140813_19}");
		return;
	end
	--洗技能

	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("DarkSkillAdjustForBagItem");
		Set_XSCRIPT_ScriptID(332207);
		Set_XSCRIPT_Parameter(0,Dark_Bag_Index);
		Set_XSCRIPT_Parameter(1,0);
		Set_XSCRIPT_ParamCount(2);
	Send_XSCRIPT();

		--设置重洗状态
--	Dark_chongxi_state =1

end


function AnqiShuxingNEW_Cancel_Clicked()
	AnqiShuxingNEW_Close();
end

function AnqiShuxingNEW_Clear()
	if Dark_Bag_Index ~= -1 and Dark_chongxi_state == 1  then
		AnqiShuxingNEW_SendDarkSkillConfirm(Dark_Bag_Index,2)
		return
	end
	AnqiShuxingNEW_Reset(1)
end


function AnqiShuxingNEW_Update(Item_index)

	local i_index = tonumber(Item_index)
	local theAction = EnumAction(i_index, "packageitem");

	if theAction:GetID() ~= 0 then

		if Dark_Bag_Index ~= -1 and i_index ~= Dark_Bag_Index and  Dark_chongxi_state == 1  then

		--二次确认框
			AnqiShuxingNEW_SendDarkSkillConfirm(i_index,1)
		-- 如果空格内已经有对应物品了,需要弹一个二次确认……
			return
		end

		--先把对象给清了
		AnqiShuxingNEW_Reset(1);

		AnqiShuxingNEW_BeforeIcon:SetActionItem(theAction:GetID());
		Dark_Bag_Index = i_index;
		LifeAbility : Lock_Packet_Item(i_index,1);
		AnqiShuxingNEW_OK:Enable();

		local icon =  tostring(LifeAbility : Get_Item_Icon_Name(i_index))

		AnqiShuxingNEW_AfterIcon:SetProperty("Image",icon)

		--显示技能
		local desc0,desc1,desc2 = DataPool:GetDarkSkillDesc(i_index)
		AnqiShuxingNEW_BeforeAttrFirst:SetText("#c009933#{FBSJ_081209_71}"..desc0)
		AnqiShuxingNEW_BeforeAttrSecond:SetText("#c009933#{FBSJ_081209_72}"..desc1)
		AnqiShuxingNEW_BeforeAttrThird:SetText("#c009933#{FBSJ_081209_73}"..desc2)
	end

end
--更新技能重新后属性
function AnqiShuxingNEW_UpDateRecoin()

	local desc0,desc1,desc2 = DataPool:GetDarkSkillNewDesc()
	AnqiShuxingNEW_AfterAttrFirst:SetText("#c009933#{FBSJ_081209_71}"..desc0)
	AnqiShuxingNEW_AfterAttrSecond:SetText("#c009933#{FBSJ_081209_72}"..desc1)
	AnqiShuxingNEW_AfterAttrThird:SetText("#c009933#{FBSJ_081209_73}"..desc2)

--	AnqiShuxingNEW_YUANSHI:Enable()
	AnqiShuxingNEW_TIHUAN:Enable()
	Dark_chongxi_state =1
end


function AnqiShuxingNEW_Reset(cleanaction)
	Dark_chongxi_state =0
	AnqiShuxingNEW_BeforeIcon:SetActionItem(-1);
	AnqiShuxingNEW_OK:Disable();
--	AnqiShuxingNEW_YUANSHI:Disable();
	AnqiShuxingNEW_TIHUAN:Disable();


	AnqiShuxingNEW_AfterIcon:SetProperty("Image","")

	AnqiShuxingNEW_BeforeAttrFirst:SetText("")
	AnqiShuxingNEW_BeforeAttrSecond:SetText("")
	AnqiShuxingNEW_BeforeAttrThird:SetText("")

	AnqiShuxingNEW_AfterAttrFirst:SetText("")
	AnqiShuxingNEW_AfterAttrSecond:SetText("")
	AnqiShuxingNEW_AfterAttrThird:SetText("")
	if cleanaction == 1 then
		if (Dark_Bag_Index ~= -1) then
			LifeAbility : Lock_Packet_Item(Dark_Bag_Index,0);
			Dark_Bag_Index = -1;
		end
	end


end

function AnqiShuxingNEW_Close()
	--关闭前也要来个二次确认
	if Dark_Bag_Index ~= -1 and  Dark_chongxi_state == 1 then
		AnqiShuxingNEW_SendDarkSkillConfirm(Dark_Bag_Index,0)
		return
	end
	AnqiShuxingNEW_Reset(1);
	this:Hide()
	AnqiShuxingNEW_StopCareObject(objCared)
end

function AnqiShuxingNEW_SaveChange_Clicked(nGiveUp)

	if Dark_chongxi_state ==1 then

 		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("DoRefreshDarkSkill");
			Set_XSCRIPT_ScriptID(332207);
			Set_XSCRIPT_Parameter(0,Dark_Bag_Index);
			Set_XSCRIPT_Parameter(1,nGiveUp);
			Set_XSCRIPT_ParamCount(2);
		Send_XSCRIPT();
	end

		--设置重洗状态
	Dark_chongxi_state =0

	AnqiShuxingNEW_Reset(0)
	AnqiShuxingNEW_Update(Dark_Bag_Index)

end

--发送替换暗器技能的二次确认
function AnqiShuxingNEW_SendDarkSkillConfirm(nIndex,keepopen)
	PushEvent("DARK_SKILL_RECOIN_CONFIRM",tostring(nIndex),tostring(keepopen))
end


--=========================================================
--开始关心NPC，
--在开始关心之前需要先确定这个界面是不是已经有“关心”的NPC，
--如果有的话，先取消已经有的“关心”
--=========================================================
function AnqiShuxingNEW_BeginCareObject(objCaredId)

	g_Object = objCaredId;

	this:CareObject(g_Object, 1, "AnqiShuxingNEW");

end

--=========================================================
--停止对某NPC的关心
--=========================================================
function AnqiShuxingNEW_StopCareObject(objCaredId)
	this:CareObject(objCaredId, 0, "AnqiShuxingNEW");
	g_Object = -1;


end
