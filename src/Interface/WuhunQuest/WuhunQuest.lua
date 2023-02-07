----------------------------------------------------------------

--CLIENT 二次确认框 CREATED BY SUNYAN FOR XYJ Q 857904341

----------------------------------------------------------------
local g_FrameInfo = -1				--当前窗口确认的类型
local g_FrameEvent = -1       --当前使用哪个窗口事件
local g_LuaArg0 = 0
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
local g_proDes = {"#{AQJJ_160127_147}", "#{AQJJ_160127_148}", "#{AQJJ_160127_149}", "#{AQJJ_160127_150}", "#{ZZZB_150811_182}"}
local FrameInfoList = {
	SHENDING_RESET_CONFIRM  = 1,	--神木王鼎 重置潜能点 二次确认
	ZHENGYUAN_CUIJIE_CONFIRM  = 2,	--真元粹解 二次确认
	ZHENGYUAN_CUIJIE_CONFIRM_ALL  = 3,	--真元一键粹解 二次确认
	ZHENGYUAN_AUTO_RONGLIAN  = 4,   --真元一键特殊熔炼
	ZHENGYUAN_AUTO_RONGLIAN_QR  = 5,   --真元一键特殊熔炼【急速】
	ZHENGYUAN_CUIJIE_CONFIRM_PARCKET  = 6,	--真元粹解【真元背包】 二次确认
	MARTAIL_RLEARN_TALENT_CONFIRM = 7, --武意天赋洗点二次确认
	MARTIAIL_RECYCLEATTRPOINT_CONFIRM = 8, --武意一键洗点二次确认
	AQLY_FLASH_COMFIRM = 9,--暗器二次重洗
	WUHUN_SKILL_RECOIN_CONFIRM = 10, --重洗武魂技能的二次确认
	SUPER_ATTR_RECOIN_CONFIRM = 11, --替换炼魂后属性的二次确认
	EQUIP_DECOMPOSE_CONFIRM = 12,--装备拆解二次确认
	EQUIP_TEMPER_QUERENCONFIRM = 13,--装备精通属性淬炼
	EQUIP_TEMPER_CONFIRM = 14,			--装备淬炼二次确认
	EQUIP_UPDATE_CONFIRM = 15,			--装备升级二次确认
	EQUIP_UPDATE_CONFIRMEX = 16,		--装备升级用特殊道具确认
	EQUIP_TRANSFER_CONFIRM = 17,			--装备转移二次确认
	EQUIP_ATTRFUKE_CONFIRM = 18,			--装备复刻二次确认 
	LW_ATTR_RECOIN_CONFIRM = 19, --龙纹属性重洗二次确认
	PETSKILL_SHOULANUP_CONFIRM = 20,	--珍兽兽栏自动购买
	PETSKILL_SHOULANUSE_CONFIRM = 21,	--珍兽兽栏自动使用
	PETEQUIP_ZIZHI_RECOIN_CONFIRM = 22, --重新鉴定装备资质的二次确认
	PET_HUANHUA_CONFIRM = 23, --珍兽幻化二次确认
	QUICKUP_PET_CONFIRM	= 24, --珍兽快速提升二次确认
	SECKILL_GIVEUP_CONFIRM = 25, --扫荡丢弃确认
	SECKILL_GIVEUP_CONFIRM_ZHAOHUI = 26, --扫荡丢弃确认
	ZHENFA_FORGET_CONFIRM = 27,		--遗忘结拜阵法二次确认 
	DELETE_COMBOBOOK_CONFIRM = 28,			--删除武林秘籍二次确认
	HXY_ACTIVE_EFFECT_CONFIRM = 29, --豪侠印属性激活
	HXY_RESET_EFFECT_CONFIRM = 30, --豪侠印属性更新
	NEW_BANKZHUANGZHANG = 31, --转账
	NEW_BANKTIXIAN = 32, --提现
	PETHUANTONG_YUANBAOPAY = 33, --还童元宝购买确定
	PETHUANTONG_QUICK = 33, --完美还童
}

function WuhunQuest_PreLoad()
	this:RegisterEvent("UI_COMMAND");
end

function WuhunQuest_OnLoad()
	WuhunQuest_Frame_sub:SetProperty("AlwaysOnTop", "True");
end

function WuhunQuestUpdateRect()
	local nWidth, nHeight = WuhunQuest_InfoWindow:GetWindowSize();
	local nTitleHeight = 23;
	local nBottomHeight = 25;
	nWindowHeight = nTitleHeight + nBottomHeight + nHeight;
	WuhunQuest_Frame_sub:SetProperty( "AbsoluteHeight", tostring( nWindowHeight ) );
end

local TimerArg = "";
local g_QuitType = 0;
local g_bIsQuitMsgBox = 0;
-- OnEvent
function WuhunQuest_OnEvent(event)
	
	if ( event == "UI_COMMAND" and tonumber(arg0) == 20190209) then
		local WindowText = ""
		local Button1 = ""
		local Button2 = ""
		local Operation = tonumber(arg1)
		if Operation == 2129 then
		    WindowText = "#{XLDL_140606_150}"
			Button1 = "#{XLDL_140606_121}"
			Button2 = "#{XLDL_140606_151}"
			g_FrameInfo = FrameInfoList.SHENDING_RESET_CONFIRM
		elseif Operation == 2130 then
			local ItemNindex = tonumber(arg2)
			local ZhenYuanItemCode = Lua_GetZhenYuanID(ItemNindex)
			if ZhenYuanItemCode == nil or ZhenYuanItemCode == 0 then
				return
			end
			g_LuaArg0 = tonumber(arg3)
			local nZhenYuanType = math.mod(math.floor(ZhenYuanItemCode/1000),100)
		    WindowText = "#cfff263你要将以下真元淬解为元晶吗？淬解后，该真元将会#G消失#cfff263。#W#r"..LuaFnGetItemName(ZhenYuanItemCode).."#cfff263（等级：#G"..math.mod(ZhenYuanItemCode,10).."#cfff263）#r#W"..Lua_GetPneumaProectory(ItemNindex).."#W#r#cfff263淬解可获得元晶：#G"..GetPneumaProperty(tonumber(arg2),7).."#cfff263#r继续淬解请点击#G确定#cfff263，不淬解请点击#G取消#cfff263。"
			Button1 = "#{XLDL_140606_121}"
			Button2 = "#cfff263取消"
			g_FrameInfo = FrameInfoList.ZHENGYUAN_CUIJIE_CONFIRM
		end
		WuhunQuest_InfoWindow:SetText( WindowText )
		WuhunQuest_Button1:Show()
		WuhunQuest_Button1:SetText(Button1);  --确定
		WuhunQuest_Button2:Show()
		WuhunQuest_Button2:SetText(Button2);  --取消
		WuhunQuest_Clear_Var();
		WuhunQuestUpdateRect();
		this:Show()
	end
	if ( event == "UI_COMMAND" and tonumber(arg0) == 2019040201) then
		WindowText = Get_XParam_STR(0)
		Button1 = "#cfff263确定"
		Button2 = "#cfff263取消"
		g_FrameInfo = FrameInfoList.PETHUANTONG_YUANBAOPAY
		WuhunQuest_InfoWindow:SetText( WindowText )
		WuhunQuest_Button1:Show()
		WuhunQuest_Button1:SetText(Button1);  --确定
		WuhunQuest_Button2:Show()
		WuhunQuest_Button2:SetText(Button2);  --取消
		WuhunQuest_Clear_Var();
		WuhunQuestUpdateRect();
		this:Show()
	end
	if ( event == "UI_COMMAND" and tonumber(arg0) == 220220923) then
		 local nType = tonumber(arg1); 			--1是悟性，2是灵性，3是融合度，4是成长率
		 local nCurData --= tonumber(arg1); 	--当前悟性、灵性、融合度、成长率
		 if nType == 4 then
		 	 nCurData = tostring(arg2);
		 else
		 	 nCurData = tonumber(arg2);
		 end
		 local nPrice = tonumber(arg3);			--元宝数
		 local strMsg = tostring(arg4); 		--宠物名字
		 WuhunQuest_QuickUpPet_Confirm(nType,nCurData,nPrice,strMsg);
	end
	if ( event == "UI_COMMAND" and tonumber(arg0) == 2019040203) then
		local nJYNum = tonumber(arg1)
		WindowText = "    #cfff263您将花费#G"..tostring(nJYNum * 20).."真元精粹#cfff263进行#G快捷一键凝元#cfff263（等同于一次完成#G手动#cfff263点击#G"..nJYNum.."次凝元#cfff263），快捷一键凝元后仅会保留#G橙色#cfff263和#G紫色#cfff263真元，#G蓝色#cfff263、#G绿色#cfff263、#G白色#cfff263真元将#G自动淬解为元晶#cfff263。#r    您确定要继续快捷一键凝元吗，如果继续请点击#G确定#cfff263，点击#G取消#cfff263关闭界面。"
		Button1 = "#{XLDL_140606_121}"
		Button2 = "#cfff263取消"
		g_LuaArg0 = tonumber(arg2)
		g_FrameInfo = FrameInfoList.ZHENGYUAN_AUTO_RONGLIAN_QR
		WuhunQuest_InfoWindow:SetText( WindowText )
		WuhunQuest_Button1:Show()
		WuhunQuest_Button1:SetText(Button1);  --确定
		WuhunQuest_Button2:Show()
		WuhunQuest_Button2:SetText(Button2);  --取消
		WuhunQuest_Clear_Var();
		WuhunQuestUpdateRect();
		this:Show()
	end
	if ( event == "UI_COMMAND" and tonumber(arg0) == 2019040601) then
		local ItemNindex = tonumber(arg1)
		local ZhenYuanItemCode = Lua_GetZhenYuanID(ItemNindex)
		if ZhenYuanItemCode == nil or ZhenYuanItemCode == 0 then
			return
		end
		g_LuaArg0 = tonumber(arg2)
		local nZhenYuanType = math.mod(math.floor(ZhenYuanItemCode/1000),100)
		if nZhenYuanType < 50 then
			WindowText = "#cfff263你要将以下真元淬解为元晶吗？淬解后，该真元将会#G消失#cfff263。#W#r"..LuaFnGetItemName(ZhenYuanItemCode).."#cfff263（等级：#G"..math.mod(ZhenYuanItemCode,10).."#cfff263）#r#W"..Lua_GetPneumaProectory(ItemNindex).."#W#r#cfff263淬解可获得元晶：#G"..GetPneumaProperty(g_LuaArg0,7).."#cfff263#r继续淬解请点击#G确定#cfff263，不淬解请点击#G取消#cfff263。"
		else
			WindowText = "#cfff263你要将以下魂元淬解为元晶吗？淬解后，该魂元将会#G消失#cfff263。且#G100%#cfff263获得#G1#cfff263个#G橙元铸金符#cfff263。#W#r"..LuaFnGetItemName(ZhenYuanItemCode).."#cfff263（等级：#G"..math.mod(ZhenYuanItemCode,10).."#cfff263）#r#W"..Lua_GetPneumaProectory(ItemNindex).."#W#r#cfff263淬解可获得元晶：#G"..GetPneumaProperty(g_LuaArg0,7).."#cfff263#r继续淬解请点击#G确定#cfff263，不淬解请点击#G取消#cfff263。"
		end
		Button1 = "#{XLDL_140606_121}"
		Button2 = "#cfff263取消"
		g_FrameInfo = FrameInfoList.ZHENGYUAN_CUIJIE_CONFIRM_PARCKET
		WuhunQuest_InfoWindow:SetText( WindowText )
		WuhunQuest_Button1:Show()
		WuhunQuest_Button1:SetText(Button1);  --确定
		WuhunQuest_Button2:Show()
		WuhunQuest_Button2:SetText(Button2);  --取消
		WuhunQuest_Clear_Var();
		WuhunQuestUpdateRect();
		this:Show()
	end
	if (event == "UI_COMMAND" and tonumber(arg0) == 1000000015 ) then
		local nLayer = tonumber(arg1)
		local nLevel = tonumber(arg2)
		local nCost = tonumber(arg3)
		local nLayerName = tostring(arg4)
		WuhunQuest_Martial_RLearnTalent_Confirm(nLayer,nLevel,nCost,nLayerName,tonumber(arg5))
	end
	if (event == "UI_COMMAND" and tonumber(arg0) == 1000000016 ) then
		local nIndex = tonumber(arg0); 
		local strTip = arg1;
		local Martial_WuYi_YuanbaoPay = tonumber(arg2);
		WuhunQuest_Open_Martail_Confirm(nIndex,strTip,Martial_WuYi_YuanbaoPay)
	end
	if event == "UI_COMMAND" and tonumber(arg0) == 1000000024 then
		WuhunQuest_AQLY_AutoFlash_Confirm(tonumber(arg1))
	end
	if event == "UI_COMMAND" and tonumber(arg0) == 1000000031 then
		local npocketIndex = tonumber(arg1);
		local keepopen = tonumber(arg2);
		WuhunQuest_WuhunSkill_confirm(npocketIndex,keepopen)
	end
	if event == "UI_COMMAND" and arg0 == "1000000034" then
		local npocketIndex = tonumber(arg1);
		local keepopen = tonumber(arg2);
		WuhunQuest_Super_ATTR_confirm(npocketIndex,keepopen)
	end
	if event == "UI_COMMAND" and arg0 == "1000000043" then
		local equiplock = Get_XParam_INT(0);
		local GetStrengthenLevel = Get_XParam_INT(1);
		local IsHaveAttaProperty = Get_XParam_INT(2);
		local bHaveSL = Get_XParam_INT(3);
		g_FrameVar[1] = Get_XParam_INT(4);
		WuhunQuest_EquipDecompose_Confirm(equiplock,GetStrengthenLevel,IsHaveAttaProperty,bHaveSL);
	end
	if (event == "UI_COMMAND" and arg0 == "1000000044") then
		WuhunQuest_EquipTemper_QueRenConfirm(arg1,tonumber(arg2),tonumber(arg3))
	end
	if ( event == "UI_COMMAND" and arg0 == "1000000046") then
		WuhunQuest_EquipTemper_Confirm()
	end
	if ( event == "UI_COMMAND" and arg0 == "1000000048") then
		if(tonumber(arg1) == 0) then
			WuhunQuest_EquipUpdate_Confirm()
		elseif(tonumber(arg1) == 1) then
			WuhunQuest_EquipUpdate_ConfirmEx(tonumber(arg2))
		end
	end
	if ( event == "UI_COMMAND" and arg0 == "1000000050") then
		WuhunQuest_EquipTransfer_Confirm(tonumber(arg1))
	end
	if ( event == "UI_COMMAND" and arg0 == "1000000052") then
		WuhunQuest_EquipFuKe_Confirm()
	end
	if event == "UI_COMMAND" and arg0 == "1000000059" then
		local npocketIndex = tonumber(arg1);
		local keepopen = tonumber(arg2);
		WuhunQuest_LW_ATTR_confirm(npocketIndex,keepopen)
	end
	if (event == "UI_COMMAND" and arg0 == "1000000063") then
		local nShouLanCnt = tonumber(arg1);
		local nRequireItem = tonumber(arg2);
		local nRequireYB = tonumber(arg3);
		WuhunQuest_Open_Window_PetShouLan_AutoUp(nShouLanCnt,nRequireItem,nRequireYB);
	end
	if (event == "UI_COMMAND" and arg0 == "1000000064") then
		local nShouLanCnt = tonumber(arg1);
		local nRequireItem = tonumber(arg2);
		WuhunQuest_Open_Window_PetShouLan_AutoUse(nShouLanCnt,nRequireItem);
	end
	if (event == "UI_COMMAND" and arg0 == "1000001164") then
		local nShouLanCnt = tonumber(arg1);
		local nRequireItem = tonumber(arg2);
		WuhunQuest_Open_Window_ZhuanZhang(nShouLanCnt,nRequireItem)
	end	
	if (event == "UI_COMMAND" and arg0 == "1000001165") then
		local nShouLanCnt = tonumber(arg1);
		local nRequireItem = tonumber(arg2);
		local nRequireType = tonumber(arg3);
		local nRequirenType = tonumber(arg4);
		WuhunQuest_Open_Window_TiXian(nShouLanCnt,nRequireItem,nRequireType,nRequirenType)
	end	
	
	if event == "UI_COMMAND" and arg0 == "1000000069" then
		local npocketIndex = tonumber(arg1);
		local keepopen = tonumber(arg2);
		WuhunQuest_PetEquipZiZhi_confirm(npocketIndex,keepopen)
	end
	if event == "UI_COMMAND" and arg0 == "1000000075" then
		local nIndex = tonumber(arg1);
		local NewModel = tonumber(arg2);
		WuhunQuest_PetHH_confirm(nIndex,NewModel)
	end
	if ( event == "UI_COMMAND" and arg0 == "1000000078") then
		 local nType = tonumber(arg1); 			--1是悟性，2是灵性，3是融合度，4是成长率
		 local nCurData --= tonumber(arg1); 	--当前悟性、灵性、融合度、成长率
		 if nType == 4 then
		 	 nCurData = tostring(arg2);
		 else
		 	 nCurData = tonumber(arg2);
		 end
		 local nPrice = tonumber(arg3);			--元宝数
		 local nUplimit = tonumber(arg4);		--成长率上限
		 local strMsg = tostring(arg5); 		--宠物名字
		 WuhunQuest_QuickUpPet_Confirm(nType,nCurData,nPrice,strMsg);
	end
	if event == "UI_COMMAND" and arg0 == "1000000094" then
		WuhunQuest_SeckillGiveUp_confirm(tonumber(arg1))
	end
	if event == "UI_COMMAND" and arg0 == "1000000098" then
		WuhunQuest_ZhenfaForget_Confirm(tonumber(arg1) )
		return	
	end
	if event == "UI_COMMAND" and arg0 == "1000000115" then
		WuhunQuest_Bn2Click();
		return	
	end
	if event == "UI_COMMAND" and arg0 == "1000000118" then
		local nParam = tonumber(arg1);
		if nParam >= 0 then
			WuhunQuest_DeleteComboBook_Confirm(nParam);
		end
	end
	if event == "UI_COMMAND" and arg0 == "1000000131" then
		local nBagIndex = tonumber(arg1)
		WuhunQuest_HxyEffectResetConfirm(nBagIndex)
	elseif event == "UI_COMMAND" and arg0 == "1000000132" then
		local nEffectIndex = tonumber(arg1)
		WuhunQuest_HxyEffectActiveConfirm(nEffectIndex )
	end
end
function WuhunQuest_QuickUpPet_Confirm(nType,nCurData,nPrice,strMsg)
	WuhunQuest_Clear_Var()
	g_FrameVar[1] = tonumber(nType);

	local strText

	if nType == 1 then
		-- 悟性
		strText = string.format("#{ZSKJT_130428_5}",strMsg,nCurData,nPrice)
	elseif nType == 2 then
		-- 灵性
		strText = string.format("#{ZSKJT_130428_10}",strMsg,nCurData,nPrice);
	elseif nType == 3 then
		-- 融合度
		strText = string.format("#{ZSKJT_130428_17}",strMsg,nCurData,nPrice);
	elseif nType == 4 then
		-- 成长率
		strText = string.format("    #G%s#W当前的成长率为#G%s#W，还童成功后，其成长率将提升至#G完美#W。本次完美还童需要支付#G%s#W元宝。#r    如果确认进行提升，则点击确定后即可完成提升。若放弃进行提升，则请点击取消。#r    #G小提示：珍兽的完美成长率上限与其可携带等级有关。完美还童时，还童珍兽的资质和外形不会发生任何变化。",strMsg,nCurData,nPrice);
	end

	g_FrameInfo = FrameInfoList.QUICKUP_PET_CONFIRM
	WuhunQuest_InfoWindow:SetText( strText );
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{INTERFACE_XML_557}");  --确定
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{INTERFACE_XML_542}");  --取消
	WuhunQuestUpdateRect();
	this:Show();
end

function WuhunQuest_DeleteComboBook_Confirm(nParam)
	local bookname = GetComboBookInfo(nParam, "bookname");
	local bookitemid = GetComboBookInfo(nParam, "bookitemId");
	local strText = string.format("#cfff263您确定要遗忘#G%s#cfff263吗？遗忘之后，该本秘籍及其记录的招式将会全部消失，修为也会有所降低，修为降低至一定值，修为境界也随之降低，但用于提升该本秘籍层数所消耗的全部#G武学心得#cfff263和#G秘籍残页#cfff263将会如数#G归还#cfff263。若确认遗忘此本秘籍，请点击#G确定#cfff263。若不想遗忘秘籍，点击#G取消#cfff263即可。", bookname )
	if( bookitemid == 30311205 or bookitemid == 30311210 ) then
		strText = strText.."#{WLMJ_130121_77}"
	end
	g_FrameInfo = FrameInfoList.DELETE_COMBOBOOK_CONFIRM
	WuhunQuest_InfoWindow:SetText( strText );
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{INTERFACE_XML_557}");  --确定
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{INTERFACE_XML_542}");  --取消
	WuhunQuestUpdateRect();
	this:Show();
end

function WuhunQuest_ZhenfaForget_Confirm(nIndex)
	WuhunQuest_Clear_Var()
	local skillname = {"#{JBGXW_150526_138}","#{JBGXW_150526_139}","#{JBGXW_150526_140}","#{JBGXW_150526_141}"}
	local backup = Lua_GetZhenfareturnback(nIndex)
	local strText = string.format("    #cfff263您确定要遗忘#G%s#cfff263吗？遗忘之后，该#G阵法#cfff263及#G启阵技能#cfff263将会全部消失，用于提升该阵法所消耗的#G%s#cfff263点#G情义值#cfff263将会如数归还，同时失去对应的#G%s#cfff263点#G阵法修为#cfff263。若确认遗忘此阵法，请点击#G确定#cfff263。若不想遗忘阵法，点击#G取消#cfff263即可。" , skillname[nIndex+1],backup,backup)	
	local bsNum = DataPool:GetPlayerMission_DataRound(302)
	local maxnum = 150000
	if bsNum + backup >= maxnum then
		local realback = maxnum - bsNum;
		strText = string.format("    #cfff263您的情义值即将达到上限，您确定要遗忘#G%s#cfff263吗？遗忘后，该#G阵法#cfff263及#G启阵技能#cfff263将会全部消失，遗忘该阵法将失去对应的#G%s#cfff263点#G阵法修为#cfff263。由于您的情义值即将#G达到上限#cfff263，本次操作仅将归还您#G%s#cfff263点#G情义值#cfff263。若确认遗忘此阵法，请点击#G确定#cfff263。若不想遗忘阵法，点击#G取消#cfff263即可。" , skillname[nIndex+1],backup,realback)	
	end
	WuhunQuest_InfoWindow:SetText(strText)
	g_FrameVar[1] = tonumber(nIndex)
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{ZZZB_150811_19}");  --确定
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{ZZZB_150811_20}");  --取消
	WuhunQuestUpdateRect();
	g_FrameInfo = FrameInfoList.ZHENFA_FORGET_CONFIRM
	this:Show()
end

function WuhunQuest_SeckillGiveUp_confirm(nFubenID)
	WuhunQuest_Clear_Var()
	g_FrameVar[1] = tonumber(nFubenID);
	WuhunQuest_InfoWindow:SetText("#{FBSD_151123_07}")
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{LS78_140819_55}");  --确定
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{LS78_140819_56}");  --取消
	WuhunQuestUpdateRect();
	g_FrameInfo = FrameInfoList.SECKILL_GIVEUP_CONFIRM
	this:Show()
end

function WuhunQuest_PetHH_confirm(nIndex,NewModel)
	WuhunQuest_Clear_Var()
	NewModel = tonumber(NewModel)
	local strInfo = ""
	if NewModel == 0 then
		strInfo = "#cfff263您确认需要将您的#G"..Pet:GetName(nIndex).."#cfff263幻化，并#G继承#cfff263珍兽外观。另外，#G珍兽宝宝#cfff263幻化后将#G不能#cfff263再进行#G繁殖#cfff263。确认继续幻化，请点击确定按钮。"
	elseif NewModel == 1 or NewModel == 2 then
		strInfo = "#cfff263您确认需要将您的#G"..Pet:GetName(nIndex).."#cfff263幻化，并#G不继承#cfff263珍兽外观。#r#G注意：#cfff263幻化后改变外观的珍兽无法恢复至幻化前的外观。是否继承外观可在珍兽幻化界面上选择。另外，#G珍兽宝宝#cfff263幻化后将#G不能#cfff263再进行#G繁殖#cfff263。确认继续幻化，请点击确定按钮。"
	end

	WuhunQuest_InfoWindow:SetText(strInfo)
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{ZBCZ_140618_07}");  --确定
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{ZBCZ_140618_08}");  --取消
	WuhunQuestUpdateRect();
	g_FrameInfo = FrameInfoList.PET_HUANHUA_CONFIRM
	this:Show();
end

function WuhunQuest_PetEquipZiZhi_confirm(nIndex,keepopen)
	WuhunQuest_Clear_Var()
	g_FrameVar[1] = tonumber(nIndex)
	g_FrameVar[2] = tonumber(keepopen)
	local strInfo = "#{ZZCX_11119_09}"
	if keepopen == 0 then
		strInfo = "#{ZZCX_11119_13}"
	elseif keepopen == 1 then
		strInfo = "#{ZZCX_11119_09}"
	elseif  keepopen == 2 then
		strInfo = "#{ZZCX_11119_12}"
	end

	WuhunQuest_InfoWindow:SetText(strInfo)
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{ZBCZ_140618_07}");  --确定
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{ZBCZ_140618_08}");  --取消
	WuhunQuestUpdateRect();
	g_FrameInfo = FrameInfoList.PETEQUIP_ZIZHI_RECOIN_CONFIRM
	this:Show();
end

function WuhunQuest_Open_Window_PetShouLan_AutoUse(nShouLanCnt,nRequireItem)
	WuhunQuest_Clear_Var()

	g_FrameVar[1] = tonumber(nRequireItem);
	local itemName = LuaFnGetItemName(tonumber(nRequireItem))
	local nMaxPetCount = GetMyCurMaxPetCount()
	--#cfff263您可消耗1个#G%s0#cfff263，激活1个非免费珍兽栏位，激活后您所拥有的#G珍兽栏位总数#cfff263增加至#G%s1#cfff263个，角色最多可拥有#G4#cfff263个非免费珍兽栏位。#r    点击#G确认#cfff263按钮后，将完成本次激活，若点击#G取消#cfff263按钮，则放弃本次操作。
	local strMsg = string.format("    #cfff263您可消耗1个#G%s#cfff263，激活1个非免费珍兽栏位，激活后您所拥有的#G珍兽栏位总数#cfff263增加至#G%s#cfff263个，角色最多可拥有#G4#cfff263个非免费珍兽栏位。#r    点击#G确认#cfff263按钮后，将完成本次激活，若点击#G取消#cfff263按钮，则放弃本次操作。",itemName,nMaxPetCount+1)
	WuhunQuest_InfoWindow:SetText( strMsg );

	g_FrameInfo = FrameInfoList.PETSKILL_SHOULANUSE_CONFIRM;
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{INTERFACE_XML_557}");  --确定
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{INTERFACE_XML_542}");  --取消
	WuhunQuestUpdateRect();

	this:Show();
end

function WuhunQuest_Open_Window_PetShouLan_AutoUp(nShouLanCnt,nRequireItem,nRequireYB)
	WuhunQuest_Clear_Var()

	g_FrameVar[1] = tonumber(nShouLanCnt);
	g_FrameVar[2] = tonumber(nRequireYB);
	
	local levelList = {21, 41, 61, 81};
	local freeLanWeiList = {3, 4, 5, 6, 6};
	
	--判断等级阶段
	local playerLevel =  Player:GetData("LEVEL");
	local levelPos = 1;
	for i = 1, 4 do
	    if(playerLevel >= levelList[i]) then
			levelPos = i + 1;
	    end
	end
	
	local strMsg = "";
	local nMaxPetCount = GetMyCurMaxPetCount()--当前最大容器
	
	--当前免费珍兽栏
	local curFreePetCount = 0;
	if(playerLevel < levelList[4]) then
	    curFreePetCount = freeLanWeiList[levelPos] -1;
	 else
		curFreePetCount = 6;
	end
	
	--当前额外珍兽栏
	local curExPetCount = nMaxPetCount - curFreePetCount;
	if(playerLevel < levelList[4]) then
	    strMsg = string.format("    #cfff263当您达到#G%s#cfff263级时即可激活第#G%s#cfff263个#G免费珍兽栏位#cfff263。每个角色最多可激活#G6#cfff263个#G免费珍兽栏位#cfff263。#r    同时，您现在可花费#G%s#cfff263元宝，激活第#G%s#cfff263个#G额外珍兽栏位#cfff263。激活后您所拥有的#G珍兽栏位总数#cfff263增加至#G%s#cfff263个。每个角色最多可激活#G4#cfff263个#G额外珍兽栏位#cfff263。#r    点击#G确认#cfff263按钮后，将完成本次#G额外珍兽栏位#cfff263的激活操作，若点击#G取消#cfff263按钮，则放弃本次操作。", levelList[levelPos], freeLanWeiList[levelPos], nRequireYB, curExPetCount+1, nMaxPetCount+1);
	else
	    strMsg = string.format("    #cfff263您已经激活了#G6#cfff263个#G免费珍兽栏位#cfff263。#r    同时，您现在可花费#G%s#cfff263元宝，激活第#G%s#cfff263个#G额外珍兽栏位#cfff263。激活后您所拥有的#G珍兽栏位总数#cfff263增加至#G%s#cfff263个，每个角色最多可激活#G4#cfff263个#G额外珍兽栏位#cfff263。#r    点击#G确认#cfff263按钮后，将完成本次#G额外珍兽栏位#cfff263的激活操作。若点击#G取消#cfff263按钮，则放弃本次操作。", nRequireYB, curExPetCount+1, nMaxPetCount+1);
	end

    --local itemName = PlayerPackage:GetItemName(tonumber(nRequireItem))
	WuhunQuest_InfoWindow:SetText( strMsg );

	g_FrameInfo = FrameInfoList.PETSKILL_SHOULANUP_CONFIRM;
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{INTERFACE_XML_557}");  --确定
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{INTERFACE_XML_542}");  --取消
	WuhunQuestUpdateRect();

	this:Show();
end

function WuhunQuest_LW_ATTR_confirm(nIndex,keepopen)
	WuhunQuest_Clear_Var()
	g_FrameVar[1] = tonumber(nIndex)
	g_FrameVar[2] = tonumber(keepopen)
	local strInfo = "#{CXYH_140813_52}"
	if keepopen == 0 then
		strInfo = "#{CXYH_140813_51}"
	elseif keepopen == 1 then
		strInfo = "#{CXYH_140813_52}"
	elseif  keepopen == 2 then
		strInfo = "#{CXYH_140813_50}"
	end

	WuhunQuest_InfoWindow:SetText(strInfo)
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{ZBCZ_140618_07}");  --确定
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{ZBCZ_140618_08}");  --取消
	WuhunQuestUpdateRect();
	g_FrameInfo = FrameInfoList.LW_ATTR_RECOIN_CONFIRM
	this:Show();
end

function WuhunQuest_EquipFuKe_Confirm()
	g_FrameInfo = FrameInfoList.EQUIP_ATTRFUKE_CONFIRM 
	WuhunQuest_InfoWindow:SetText( "#{JTFK_1117_31}" );
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{JTFK_1117_32}");  --确定
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{JTFK_1117_33}");  --取消
	WuhunQuestUpdateRect();
	this:Show();
end

function WuhunQuest_EquipTransfer_Confirm(messagetype)
	local str =""
	if(messagetype == 0) then
		str = "#{ZBSX_130625_120}"
	elseif (messagetype == 1) then
		str = "#{ZBSX_130625_121}"
	elseif (messagetype == 2) then
		str = "#{ZBSX_180502_133}" --"精通属性转移成功后，接受转移的装备将与您绑定。#r如果确认继续进行转移，点击确定后，再次点击转移按钮即可完成。"
	end
	g_FrameInfo = FrameInfoList.EQUIP_TRANSFER_CONFIRM
	WuhunQuest_InfoWindow:SetText( str );
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{INTERFACE_XML_557}");  --确定
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{INTERFACE_XML_542}");  --取消
	WuhunQuestUpdateRect();
	this:Show();
end

function WuhunQuest_EquipUpdate_ConfirmEx(itemindex)
	local strInfo = string.format("#cfff263您用于提高升级成功率的#G%s#cfff263为#G绑定#cfff263道具，精通属性升级成功时，进行升级的装备也将与您#G绑定#cfff263。#r如果确认继续进行升级，点击#G确定#cfff263后，再次点击#G升级按钮#cfff263即可完成。", LuaFnGetItemName(itemindex))
	g_FrameInfo = FrameInfoList.EQUIP_UPDATE_CONFIRMEX
	WuhunQuest_InfoWindow:SetText( strInfo );
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{INTERFACE_XML_557}");  --确定
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{INTERFACE_XML_542}");  --取消
	WuhunQuestUpdateRect();
	this:Show();
end

function WuhunQuest_EquipUpdate_Confirm()
	local strInfo = string.format("#cfff263精通属性升级成功时，将#G优先扣除#cfff263背包中#G已绑定#cfff263的#G%s#cfff263，且进行升级的装备也将与您#G绑定#cfff263。#r如果确认继续进行升级，点击#G确定#cfff263后，再次点击#G升级按钮#cfff263即可完成。#r#G小提示：如果不想在精通属性升级成功后将装备绑定，请将背包中已绑定的%s放入仓库后再来进行升级。", LuaFnGetItemName(20700055),LuaFnGetItemName(20700055))
	g_FrameInfo = FrameInfoList.EQUIP_UPDATE_CONFIRM
	WuhunQuest_InfoWindow:SetText( strInfo );
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{INTERFACE_XML_557}");  --确定
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{INTERFACE_XML_542}");  --取消
	WuhunQuestUpdateRect();
	this:Show();
end

function WuhunQuest_EquipTemper_Confirm()
	g_FrameInfo = FrameInfoList.EQUIP_TEMPER_CONFIRM
	local strInfo = string.format("#cfff263淬炼成功时，将优先扣除背包中已绑定的#G%s#cfff263，且进行淬炼的装备也将与您#G绑定#cfff263。#r如果确认继续进行淬炼，点击#G确定#cfff263后，再次点击#G淬炼按钮#cfff263即可完成。#r#G小提示：如果不想在淬炼后将装备绑定，请将背包中已绑定的%s放入仓库后再来进行淬炼。", "离火","离火")
	WuhunQuest_InfoWindow:SetText( strInfo );
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{ZBSX_130625_70}");  --确定
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{INTERFACE_XML_542}");  --取消
	WuhunQuestUpdateRect();
	this:Show();
end

function WuhunQuest_EquipTemper_QueRenConfirm(ProName,nCount,nSameCount)
	g_FrameInfo = FrameInfoList.EQUIP_TEMPER_QUERENCONFIRM
	--local strInfo = string.format("您的装备已存在相同的精通属性：%s，且没有被锁定，继续淬炼精通属性将会被替换。提示：您可以锁定需要的精通属性后，再继续淬炼。点击“关闭”按钮关闭本界面。",ProName)
	local strInfo = ""
	if(nCount ~= nSameCount) then
		strInfo = string.format("    #Y当前所淬炼的装备存在#G%s条#Y相同的精通属性：#G%s#Y，且其中#G%s#Y条未被锁定。如果继续进行#G淬炼#Y操作，#G未锁定#Y的#G精通属性#Y可能会被#G替换#Y。#r    您可在#G锁定#Y想要保留的#G精通属性#Y后，继续进行#G淬炼#Y，或是放弃锁定直接进行#G淬炼#Y。",nSameCount,ProName,nCount)
	else
		strInfo = string.format("    #Y当前所#G淬炼#Y的装备存在#G%s条#Y相同的精通属性：#G%s#Y，且均未被锁定。如果继续进行#G淬炼#Y操作，#G未锁定#Y的#G精通属性#Y可能会被#G替换#Y。#r    您可在#G锁定#Y想要保留的#G精通属性#Y后，继续进行#G淬炼#Y，或是放弃锁定直接进行#G淬炼#Y。",nSameCount,ProName)
	end
	WuhunQuest_InfoWindow:SetText( strInfo );
	WuhunQuest_Button1:Hide()
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{INTERFACE_XML_1173}");  --关闭
	WuhunQuestUpdateRect();
	this:Show();
end

function WuhunQuest_EquipDecompose_Confirm(equiplock,GetStrengthenLevel,IsHaveAttaProperty,bHaveSL)
	local strText = "#{ZBSX_171106_01}"
	if equiplock > 0 then
		strText = strText.."#{ZBSX_171106_02}"
	end
	
	if GetStrengthenLevel > 0 then
		strText = strText.."#{ZBSX_171106_03}"
	end
	
	if IsHaveAttaProperty > 0 then
		strText = strText.."#{ZBSX_171106_04}"
	end
	
	if bHaveSL > 0 then
		strText = strText.."#{ZBSX_171106_05}"
	end

	strText = strText.."#{ZBSX_171106_06}"
	
	g_FrameInfo = FrameInfoList.EQUIP_DECOMPOSE_CONFIRM
	WuhunQuest_InfoWindow:SetText( strText );
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{INTERFACE_XML_557}");  --确定
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{INTERFACE_XML_542}");  --取消
	WuhunQuestUpdateRect();
	DataPool:SetCanUseHotKey(0)
	this:Show();
end

function WuhunQuest_Super_ATTR_confirm(nIndex,keepopen)
	WuhunQuest_Clear_Var()
	g_FrameVar[1] = tonumber(nIndex)
	g_FrameVar[2] = tonumber(keepopen)
	local strInfo = "#{CXYH_140813_31}"
	if keepopen == 0 then
		strInfo = "#{CXYH_140813_30}"
	elseif keepopen == 1 then
		strInfo = "#{CXYH_140813_31}"
	elseif  keepopen == 2 then
		strInfo = "#{CXYH_140813_29}"
	end

	WuhunQuest_InfoWindow:SetText(strInfo)
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{ZBCZ_140618_07}");  --确定
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{ZBCZ_140618_08}");  --取消
	WuhunQuestUpdateRect();
	g_FrameInfo = FrameInfoList.SUPER_ATTR_RECOIN_CONFIRM
	this:Show();
end

function WuhunQuest_WuhunSkill_confirm(nIndex,keepopen)
	WuhunQuest_Clear_Var()
	g_FrameVar[1] = tonumber(nIndex)
	g_FrameVar[2] = tonumber(keepopen)
	local strInfo = "#{WHZN_141216_17}"
--	PushDebugMessage(keepopen)
	if keepopen == 0 then --关闭
		strInfo = "#{WHZN_141216_5}"
	elseif keepopen == 1 then  --更换
		strInfo = "#{WHZN_141216_17}"
	elseif  keepopen == 2 then  --取消放入
		strInfo = "#{WHZN_141216_2}"
	end

	WuhunQuest_InfoWindow:SetText(strInfo)
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{ZBCZ_140618_07}");  --确定
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{ZBCZ_140618_08}");  --取消
	WuhunQuestUpdateRect();
	g_FrameInfo = FrameInfoList.WUHUN_SKILL_RECOIN_CONFIRM
	this:Show();
end

function WuhunQuest_AQLY_AutoFlash_Confirm(Ind)
	g_FrameInfo = FrameInfoList.AQLY_FLASH_COMFIRM
	local strTemp = string.format("    #cfff263您选择将当前金翅翎羽的连击技能效果重洗为#G%s#cfff263。点击#G确定#cfff263后，将自动对连击技能效果进行重洗。#r    自动重洗开始后，当连击技能的#G五个技能效果#cfff263均重洗为您所选择的效果，或是您背包中未锁定的#G灵鹫石#cfff263、#G交子#cfff263或#G金币#cfff263用尽，重洗过程将#G自动停止#cfff263。#r    重洗过程中，当重洗出的#G%s#cfff263条数，多于当前连击技能中的#G%s#cfff263条数，则将#G自动#cfff263进行替换。#r    #G小提示：自动重洗过程中，您可以通过点击终止重洗按钮或关闭重洗界面，来终止自动重洗。#cfff263",g_proDes[Ind + 1],g_proDes[Ind + 1],g_proDes[Ind + 1])
	WuhunQuest_InfoWindow:SetText(strTemp)
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{INTERFACE_XML_557}") 	--确定 
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{INTERFACE_XML_542}") 	--取消
	WuhunQuestUpdateRect()
	this:Show()
	
end
function WuhunQuest_Open_Window_ZhuanZhang(arg1,arg2)
	g_FrameInfo = FrameInfoList.NEW_BANKZHUANGZHANG
	g_FrameVar[1]  = arg1
	g_FrameVar[2]  = arg2
	local str = ""
		str = string.format("#cfff263    您确定向#G%s#cfff263转账#G%s#cfff263金坷垃。#r    注意：转账后无法撤回，您确定转账吗？#G确认#cfff263请点击“确定”按钮。",tostring(arg1),tostring(arg2))
	WuhunQuest_InfoWindow:SetText(str)
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{WYXT_20170803_52}") 	--确定
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{WYXT_20170803_53}") 	--取消
	WuhunQuestUpdateRect()
	this:Show() 

end
function WuhunQuest_Open_Window_TiXian(arg1,arg2,arg3,arg4)
	g_FrameInfo = FrameInfoList.NEW_BANKTIXIAN
	g_FrameVar[1]  = arg1
	g_FrameVar[2]  = arg2
	g_FrameVar[3]  = arg3
	g_FrameVar[4]  = arg4
	local nTyoe = {[0] = "微信",[1] = "支付宝"}
	local str = ""
		str = string.format("#cfff263    您确定要将#G%s#cfff263金坷垃提现到账户为#G%s的#G%s#cfff263吗？#r    注意：提现后将在每天中午1点后到账，您确定提现吗？如特殊情况可联系管理进行提现加急，#G确认#cfff263请点击“确定”按钮。",tostring(arg2),tostring(arg1),nTyoe[arg3])
	WuhunQuest_InfoWindow:SetText(str)
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{WYXT_20170803_52}") 	--确定
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{WYXT_20170803_53}") 	--取消
	WuhunQuestUpdateRect()
	this:Show() 

end
function WuhunQuest_Open_Martail_Confirm(nIndex,strTip,Yuanbao)
	g_FrameInfo = FrameInfoList.MARTIAIL_RECYCLEATTRPOINT_CONFIRM
	g_FrameVar[1]  = nIndex
	g_FrameVar[2]  = strTip
	g_FrameVar[3]  = Yuanbao
	local str = ""
	if(nIndex == 15) then
		str = string.format("#cfff263    您正在进行#G一键化气#cfff263操作。本次武意潜灵一键化气，需要消耗#G%s#cfff263个#G紫府星髓#cfff263。化气成功后，将为您归还#G%s#cfff263点的#G武意潜灵#cfff263。#r    你确认要进行一键化气吗？#G确认#cfff263请点击“确定”按钮。",tostring(strTip),tostring(strTip))
	else
		str = strTip
	end
	WuhunQuest_InfoWindow:SetText(str)
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{WYXT_20170803_52}") 	--确定
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{WYXT_20170803_53}") 	--取消
	WuhunQuestUpdateRect()
	this:Show() 
end

function WuhunQuest_Martial_RLearnTalent_Confirm(nLayer,nLevel,nCost,LayerName,nId1)
	g_FrameInfo = FrameInfoList.MARTAIL_RLEARN_TALENT_CONFIRM
	g_FrameVar[1] = tonumber(nLayer)
	g_FrameVar[2] = tonumber(nId1)
	
	local strTip = string.format("#cfff263    您是否确认要消耗#G#{_EXCHG%s}#cfff263，遗忘已学习的武意秘传：#G【%s】#cfff263吗？#r    通过#G遗忘#cfff263操作，将为您返还研习#G【%s】#cfff263所消耗的全部#G培元#cfff263，同时遗忘已研习的#G【%s】#cfff263。#r    确认进行#G遗忘#cfff263操作，请点击#G确定#cfff263按钮。放弃该操作可点击#G取消#cfff263按钮。",nCost,LayerName,LayerName,LayerName)
	WuhunQuest_InfoWindow:SetText( strTip );

	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{WYXT_20170803_52}");  --确定
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{WYXT_20170803_53}");  --取消
	WuhunQuestUpdateRect();
	this:Show();
	
end

function WuhunQuest_HxyEffectActiveConfirm(nIndex )

	local strVar = ""
	if nIndex == 1 then
		strVar = string.format("    #cfff263您确认选择将#G豪侠绶印效果：减免%s状态#cfff263提升至#G1级#cfff263么？#r    点击确认按钮并成功激活此#G豪侠绶印#cfff26", "#{HXYSJ_141031_79}")
	elseif nIndex == 2 then
		strVar = string.format("    #cfff263您确认选择将#G豪侠绶印效果：减免%s状态#cfff263提升至#G1级#cfff263么？#r    点击确认按钮并成功激活此#G豪侠绶印#cfff26", "#{HXYSJ_141031_80}")
	elseif nIndex == 3 then
		strVar = string.format("    #cfff263您确认选择将#G豪侠绶印效果：减免%s状态#cfff263提升至#G1级#cfff263么？#r    点击确认按钮并成功激活此#G豪侠绶印#cfff26", "#{HXYSJ_141031_81}")
	elseif nIndex == 4 then
		strVar = string.format("    #cfff263您确认选择将#G豪侠绶印效果：减免%s状态#cfff263提升至#G1级#cfff263么？#r    点击确认按钮并成功激活此#G豪侠绶印#cfff26", "#{HXYSJ_141031_82}")
	elseif nIndex == 5 then
		strVar = string.format("    #cfff263您确认选择将#G豪侠绶印效果：减免%s状态#cfff263提升至#G1级#cfff263么？#r    点击确认按钮并成功激活此#G豪侠绶印#cfff26", "#{HXYSJ_141031_83}")
	elseif nIndex == 6 then
		strVar = string.format("    #cfff263您确认选择将#G豪侠绶印效果：减免%s状态#cfff263提升至#G1级#cfff263么？#r    点击确认按钮并成功激活此#G豪侠绶印#cfff26", "#{HXYSJ_141031_84}")
	elseif nIndex == 7 then
		strVar = string.format("    #cfff263您确认选择将#G豪侠绶印效果：减免%s状态#cfff263提升至#G1级#cfff263么？#r    点击确认按钮并成功激活此#G豪侠绶印#cfff26", "#{HXYSJ_141031_85}")
	end

	WuhunQuest_Open_Window_YESNO(tostring(strVar))
	g_FrameVar[1] = tonumber(nIndex)
	g_FrameInfo = FrameInfoList.HXY_ACTIVE_EFFECT_CONFIRM
end

function WuhunQuest_HxyEffectResetConfirm(nBagIndex)
	WuhunQuest_Open_Window_YESNO("#{HXYSJ_141031_127}")
	g_FrameVar[1] = tonumber(nBagIndex)
	g_FrameInfo = FrameInfoList.HXY_RESET_EFFECT_CONFIRM
end

function WuhunQuest_Open_Window_YESNO(str)
	WuhunQuest_Clear_Var()
	WuhunQuest_InfoWindow:SetText(str);
	WuhunQuestUpdateRect();
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{INTERFACE_XML_557}");  --确定
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{INTERFACE_XML_542}");  --取消
	DataPool:SetCanUseHotKey(0)
	this:Show();
end

-- 按钮1 点击事件
function WuhunQuest_Bn1Click()
	if (g_FrameInfo == FrameInfoList.SHENDING_RESET_CONFIRM ) then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("OnLianDanLuQianNengReset");
			Set_XSCRIPT_ScriptID(900019);
			Set_XSCRIPT_ParamCount(0);
		Send_XSCRIPT();		
	end
	if (g_FrameInfo == FrameInfoList.ZHENGYUAN_CUIJIE_CONFIRM ) then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("ZhenYuan");
			Set_XSCRIPT_ScriptID(990020);
			Set_XSCRIPT_Parameter(0, 2);
			Set_XSCRIPT_Parameter(1, g_LuaArg0);
			Set_XSCRIPT_ParamCount(2);
		Send_XSCRIPT();
	end
	if (g_FrameInfo == FrameInfoList.ZHENGYUAN_CUIJIE_CONFIRM_ALL ) then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("ZhenYuan");
			Set_XSCRIPT_ScriptID(990020);
			Set_XSCRIPT_Parameter(0, 3);
			Set_XSCRIPT_ParamCount(1);
		Send_XSCRIPT();
	end
	if (g_FrameInfo == FrameInfoList.ZHENGYUAN_AUTO_RONGLIAN) then
		PushEvent("UI_COMMAND",2019040105)
	end
	if (g_FrameInfo == FrameInfoList.ZHENGYUAN_AUTO_RONGLIAN_QR) then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("ZhenYuan");
			Set_XSCRIPT_ScriptID(990020);
			Set_XSCRIPT_Parameter(0, 6);
			Set_XSCRIPT_Parameter(1, g_LuaArg0);
			Set_XSCRIPT_ParamCount(2);
		Send_XSCRIPT();
	end
	if (g_FrameInfo == FrameInfoList.ZHENGYUAN_CUIJIE_CONFIRM_PARCKET) then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("ZhenYuan");
			Set_XSCRIPT_ScriptID(990020);
			Set_XSCRIPT_Parameter(0,11);
			Set_XSCRIPT_Parameter(1,g_LuaArg0);
			Set_XSCRIPT_ParamCount(2);
		Send_XSCRIPT();
	end
	if (g_FrameInfo == FrameInfoList.MARTAIL_RLEARN_TALENT_CONFIRM) then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "RecycleTalent" )
			Set_XSCRIPT_ScriptID( 900002 )
			Set_XSCRIPT_Parameter(0,g_FrameVar[1])
			Set_XSCRIPT_Parameter(1,g_FrameVar[2])
			Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT()
	end
	if (g_FrameInfo == FrameInfoList.PETHUANTONG_YUANBAOPAY) then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "PetHuantong_Yuanbao_Pay" )
			Set_XSCRIPT_ScriptID( 311111 )
			Set_XSCRIPT_Parameter(0,-1)
			Set_XSCRIPT_Parameter(1,1)
			Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT()
	end
	if (g_FrameInfo == FrameInfoList.MARTIAIL_RECYCLEATTRPOINT_CONFIRM) then
		if(g_FrameVar[1] == 15) then
			Clear_XSCRIPT()
				Set_XSCRIPT_Function_Name( "RecycleAllAttrPoint" )
				Set_XSCRIPT_ScriptID( 900002 )
			Send_XSCRIPT()
		else
			Clear_XSCRIPT();
				Set_XSCRIPT_Function_Name("RecycleAttrPoint");
				Set_XSCRIPT_ScriptID(900002);
				Set_XSCRIPT_Parameter(0,g_FrameVar[1]);
				Set_XSCRIPT_Parameter(1,g_FrameVar[3]);
				Set_XSCRIPT_ParamCount(2);
			Send_XSCRIPT();
		end
	end
	if g_FrameInfo == FrameInfoList.AQLY_FLASH_COMFIRM then
		PushEvent("UI_COMMAND",1000000025)
	end
	if g_FrameInfo == FrameInfoList.NEW_BANKZHUANGZHANG then
		OpenJZServerNewData(13,g_FrameVar[1],g_FrameVar[2],1,1)
	end
	if g_FrameInfo == FrameInfoList.NEW_BANKTIXIAN then
		OpenJZServerNewData(14,g_FrameVar[1],g_FrameVar[2],g_FrameVar[3],g_FrameVar[4])
	end
	
	if g_FrameInfo == FrameInfoList.WUHUN_SKILL_RECOIN_CONFIRM then
		PushEvent("UI_COMMAND",1000000032,g_FrameVar[1],g_FrameVar[2])
	end
	if g_FrameInfo == FrameInfoList.SUPER_ATTR_RECOIN_CONFIRM then
		PushEvent("UI_COMMAND",1000000035,g_FrameVar[1],g_FrameVar[2])
	end
	if (g_FrameInfo == FrameInfoList.EQUIP_DECOMPOSE_CONFIRM) then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("EquipTojingshi");
			Set_XSCRIPT_ScriptID(890088);
			Set_XSCRIPT_Parameter(0,g_FrameVar[1]);	
			Set_XSCRIPT_Parameter(1,1);	
			Set_XSCRIPT_ParamCount(2);
		Send_XSCRIPT();
	end
	if (g_FrameInfo == FrameInfoList.EQUIP_TEMPER_QUERENCONFIRM) then
		PushEvent("UI_COMMAND",1000000045)
	end
	if (g_FrameInfo == FrameInfoList.EQUIP_TEMPER_CONFIRM) then
		PushEvent("UI_COMMAND",1000000047)
	end
	if (g_FrameInfo == FrameInfoList.EQUIP_UPDATE_CONFIRM) then
		PushEvent("UI_COMMAND",1000000049,0)
	end
	if (g_FrameInfo == FrameInfoList.EQUIP_UPDATE_CONFIRMEX ) then
		PushEvent("UI_COMMAND",1000000049,1)
	end
	if (g_FrameInfo == FrameInfoList.EQUIP_TRANSFER_CONFIRM) then
		PushEvent("UI_COMMAND",1000000051)
	end
	if (g_FrameInfo == FrameInfoList.EQUIP_ATTRFUKE_CONFIRM) then
		PushEvent("UI_COMMAND",1000000053)
	end
	if g_FrameInfo == FrameInfoList.LW_ATTR_RECOIN_CONFIRM then
		PushEvent("UI_COMMAND",1000000060,g_FrameVar[1],g_FrameVar[2])
	end
	if (g_FrameInfo == FrameInfoList.PETSKILL_SHOULANUP_CONFIRM) then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("PetShouLanAutoUp");
			Set_XSCRIPT_ScriptID(335805);
			Set_XSCRIPT_Parameter(0,g_FrameVar[1]);
			Set_XSCRIPT_Parameter(1,g_FrameVar[2]);
			Set_XSCRIPT_ParamCount(2);
		Send_XSCRIPT()
	end
	if (g_FrameInfo == FrameInfoList.PETSKILL_SHOULANUSE_CONFIRM) then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("OnActivateOnceSimulate");
			Set_XSCRIPT_ScriptID(335805);
			Set_XSCRIPT_Parameter(0,g_FrameVar[1]);--nRequireItem
			Set_XSCRIPT_ParamCount(1);
		Send_XSCRIPT();
	end
	if g_FrameInfo == FrameInfoList.PETEQUIP_ZIZHI_RECOIN_CONFIRM then
		PushEvent("UI_COMMAND",1000000068,g_FrameVar[1],g_FrameVar[2])
	end
	if g_FrameInfo == FrameInfoList.PET_HUANHUA_CONFIRM then
		PushEvent("UI_COMMAND",1000000076)
	end
	if (g_FrameInfo == FrameInfoList.QUICKUP_PET_CONFIRM) then
		PushEvent("UI_COMMAND",1000000079,g_FrameVar[1])
	end
	if g_FrameInfo == FrameInfoList.SECKILL_GIVEUP_CONFIRM then
		Clear_XSCRIPT()
			Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("SecKillGiveUpItem");
			Set_XSCRIPT_ScriptID(891062);
			Set_XSCRIPT_Parameter(0,g_FrameVar[1])
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
	end
	if (g_FrameInfo == FrameInfoList.ZHENFA_FORGET_CONFIRM) then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("ForgetZF");
			Set_XSCRIPT_ScriptID(900025);
			Set_XSCRIPT_Parameter(0,tonumber(g_FrameVar[1]));
			Set_XSCRIPT_ParamCount(1);
		Send_XSCRIPT();
	end
	if (g_FrameInfo == FrameInfoList.DELETE_COMBOBOOK_CONFIRM) then
		PushEvent("UI_COMMAND",1000000119)
	end
	--豪侠印开放 2019-11-12 13:50:55 逍遥子
	if g_FrameInfo == FrameInfoList.HXY_RESET_EFFECT_CONFIRM then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("ResetHXYEffect");
			Set_XSCRIPT_ScriptID( 880008 )
			Set_XSCRIPT_Parameter(0, g_FrameVar[1] );
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
	end
	if g_FrameInfo == FrameInfoList.HXY_ACTIVE_EFFECT_CONFIRM then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("HXY_EffectLevelUp");
			Set_XSCRIPT_ScriptID( 880006);
			Set_XSCRIPT_Parameter(0, g_FrameVar[1] );
			Set_XSCRIPT_Parameter(1 , 0)
			Set_XSCRIPT_ParamCount(2);
		Send_XSCRIPT()
	end
	this:Hide();
end
-- 按钮2 点击事件
function WuhunQuest_Bn2Click()
	this:Hide();
end

function WuhunQuest_Frame_OnHiden()
	DataPool:SetCanUseHotKey(1);
end
function WuhunQuest_Clear_Var()
	for i = 1,8 do
		g_FrameVar[i] = 0
	end
	--g_FrameInfo = -1
end
function WuhunQuest_CleanUp()
	WuhunQuest_Frame_sub:SetProperty( "UnifiedPosition", "{{0.500000,-173.000000},{0.500000,-118.000000}}" )
	WuhunQuest_Button2:Hide();
	WuhunQuest_Button1:Hide();
end