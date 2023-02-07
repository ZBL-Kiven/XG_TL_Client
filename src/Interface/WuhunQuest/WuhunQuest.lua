----------------------------------------------------------------

--CLIENT ����ȷ�Ͽ� CREATED BY SUNYAN FOR XYJ Q 857904341

----------------------------------------------------------------
local g_FrameInfo = -1				--��ǰ����ȷ�ϵ�����
local g_FrameEvent = -1       --��ǰʹ���ĸ������¼�
local g_LuaArg0 = 0
--ȷ�Ͽ򻺴���������ڵ��ȷ����ȡ��ʱ������, ÿ�����������壬���ݽ��治ͬ������ͬ����ʹ�����õ�ʱ�Լ�ע��
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
	SHENDING_RESET_CONFIRM  = 1,	--��ľ���� ����Ǳ�ܵ� ����ȷ��
	ZHENGYUAN_CUIJIE_CONFIRM  = 2,	--��Ԫ��� ����ȷ��
	ZHENGYUAN_CUIJIE_CONFIRM_ALL  = 3,	--��Ԫһ����� ����ȷ��
	ZHENGYUAN_AUTO_RONGLIAN  = 4,   --��Ԫһ����������
	ZHENGYUAN_AUTO_RONGLIAN_QR  = 5,   --��Ԫһ���������������١�
	ZHENGYUAN_CUIJIE_CONFIRM_PARCKET  = 6,	--��Ԫ��⡾��Ԫ������ ����ȷ��
	MARTAIL_RLEARN_TALENT_CONFIRM = 7, --�����츳ϴ�����ȷ��
	MARTIAIL_RECYCLEATTRPOINT_CONFIRM = 8, --����һ��ϴ�����ȷ��
	AQLY_FLASH_COMFIRM = 9,--����������ϴ
	WUHUN_SKILL_RECOIN_CONFIRM = 10, --��ϴ��꼼�ܵĶ���ȷ��
	SUPER_ATTR_RECOIN_CONFIRM = 11, --�滻��������ԵĶ���ȷ��
	EQUIP_DECOMPOSE_CONFIRM = 12,--װ��������ȷ��
	EQUIP_TEMPER_QUERENCONFIRM = 13,--װ����ͨ���Դ���
	EQUIP_TEMPER_CONFIRM = 14,			--װ����������ȷ��
	EQUIP_UPDATE_CONFIRM = 15,			--װ����������ȷ��
	EQUIP_UPDATE_CONFIRMEX = 16,		--װ���������������ȷ��
	EQUIP_TRANSFER_CONFIRM = 17,			--װ��ת�ƶ���ȷ��
	EQUIP_ATTRFUKE_CONFIRM = 18,			--װ�����̶���ȷ�� 
	LW_ATTR_RECOIN_CONFIRM = 19, --����������ϴ����ȷ��
	PETSKILL_SHOULANUP_CONFIRM = 20,	--���������Զ�����
	PETSKILL_SHOULANUSE_CONFIRM = 21,	--���������Զ�ʹ��
	PETEQUIP_ZIZHI_RECOIN_CONFIRM = 22, --���¼���װ�����ʵĶ���ȷ��
	PET_HUANHUA_CONFIRM = 23, --���޻û�����ȷ��
	QUICKUP_PET_CONFIRM	= 24, --���޿�����������ȷ��
	SECKILL_GIVEUP_CONFIRM = 25, --ɨ������ȷ��
	SECKILL_GIVEUP_CONFIRM_ZHAOHUI = 26, --ɨ������ȷ��
	ZHENFA_FORGET_CONFIRM = 27,		--��������󷨶���ȷ�� 
	DELETE_COMBOBOOK_CONFIRM = 28,			--ɾ�������ؼ�����ȷ��
	HXY_ACTIVE_EFFECT_CONFIRM = 29, --����ӡ���Լ���
	HXY_RESET_EFFECT_CONFIRM = 30, --����ӡ���Ը���
	NEW_BANKZHUANGZHANG = 31, --ת��
	NEW_BANKTIXIAN = 32, --����
	PETHUANTONG_YUANBAOPAY = 33, --��ͯԪ������ȷ��
	PETHUANTONG_QUICK = 33, --������ͯ
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
		    WindowText = "#cfff263��Ҫ��������Ԫ���ΪԪ���𣿴��󣬸���Ԫ����#G��ʧ#cfff263��#W#r"..LuaFnGetItemName(ZhenYuanItemCode).."#cfff263���ȼ���#G"..math.mod(ZhenYuanItemCode,10).."#cfff263��#r#W"..Lua_GetPneumaProectory(ItemNindex).."#W#r#cfff263���ɻ��Ԫ����#G"..GetPneumaProperty(tonumber(arg2),7).."#cfff263#r�����������#Gȷ��#cfff263�����������#Gȡ��#cfff263��"
			Button1 = "#{XLDL_140606_121}"
			Button2 = "#cfff263ȡ��"
			g_FrameInfo = FrameInfoList.ZHENGYUAN_CUIJIE_CONFIRM
		end
		WuhunQuest_InfoWindow:SetText( WindowText )
		WuhunQuest_Button1:Show()
		WuhunQuest_Button1:SetText(Button1);  --ȷ��
		WuhunQuest_Button2:Show()
		WuhunQuest_Button2:SetText(Button2);  --ȡ��
		WuhunQuest_Clear_Var();
		WuhunQuestUpdateRect();
		this:Show()
	end
	if ( event == "UI_COMMAND" and tonumber(arg0) == 2019040201) then
		WindowText = Get_XParam_STR(0)
		Button1 = "#cfff263ȷ��"
		Button2 = "#cfff263ȡ��"
		g_FrameInfo = FrameInfoList.PETHUANTONG_YUANBAOPAY
		WuhunQuest_InfoWindow:SetText( WindowText )
		WuhunQuest_Button1:Show()
		WuhunQuest_Button1:SetText(Button1);  --ȷ��
		WuhunQuest_Button2:Show()
		WuhunQuest_Button2:SetText(Button2);  --ȡ��
		WuhunQuest_Clear_Var();
		WuhunQuestUpdateRect();
		this:Show()
	end
	if ( event == "UI_COMMAND" and tonumber(arg0) == 220220923) then
		 local nType = tonumber(arg1); 			--1�����ԣ�2�����ԣ�3���ں϶ȣ�4�ǳɳ���
		 local nCurData --= tonumber(arg1); 	--��ǰ���ԡ����ԡ��ں϶ȡ��ɳ���
		 if nType == 4 then
		 	 nCurData = tostring(arg2);
		 else
		 	 nCurData = tonumber(arg2);
		 end
		 local nPrice = tonumber(arg3);			--Ԫ����
		 local strMsg = tostring(arg4); 		--��������
		 WuhunQuest_QuickUpPet_Confirm(nType,nCurData,nPrice,strMsg);
	end
	if ( event == "UI_COMMAND" and tonumber(arg0) == 2019040203) then
		local nJYNum = tonumber(arg1)
		WindowText = "    #cfff263��������#G"..tostring(nJYNum * 20).."��Ԫ����#cfff263����#G���һ����Ԫ#cfff263����ͬ��һ�����#G�ֶ�#cfff263���#G"..nJYNum.."����Ԫ#cfff263�������һ����Ԫ����ᱣ��#G��ɫ#cfff263��#G��ɫ#cfff263��Ԫ��#G��ɫ#cfff263��#G��ɫ#cfff263��#G��ɫ#cfff263��Ԫ��#G�Զ����ΪԪ��#cfff263��#r    ��ȷ��Ҫ�������һ����Ԫ�������������#Gȷ��#cfff263�����#Gȡ��#cfff263�رս��档"
		Button1 = "#{XLDL_140606_121}"
		Button2 = "#cfff263ȡ��"
		g_LuaArg0 = tonumber(arg2)
		g_FrameInfo = FrameInfoList.ZHENGYUAN_AUTO_RONGLIAN_QR
		WuhunQuest_InfoWindow:SetText( WindowText )
		WuhunQuest_Button1:Show()
		WuhunQuest_Button1:SetText(Button1);  --ȷ��
		WuhunQuest_Button2:Show()
		WuhunQuest_Button2:SetText(Button2);  --ȡ��
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
			WindowText = "#cfff263��Ҫ��������Ԫ���ΪԪ���𣿴��󣬸���Ԫ����#G��ʧ#cfff263��#W#r"..LuaFnGetItemName(ZhenYuanItemCode).."#cfff263���ȼ���#G"..math.mod(ZhenYuanItemCode,10).."#cfff263��#r#W"..Lua_GetPneumaProectory(ItemNindex).."#W#r#cfff263���ɻ��Ԫ����#G"..GetPneumaProperty(g_LuaArg0,7).."#cfff263#r�����������#Gȷ��#cfff263�����������#Gȡ��#cfff263��"
		else
			WindowText = "#cfff263��Ҫ�����»�Ԫ���ΪԪ���𣿴��󣬸û�Ԫ����#G��ʧ#cfff263����#G100%#cfff263���#G1#cfff263��#G��Ԫ�����#cfff263��#W#r"..LuaFnGetItemName(ZhenYuanItemCode).."#cfff263���ȼ���#G"..math.mod(ZhenYuanItemCode,10).."#cfff263��#r#W"..Lua_GetPneumaProectory(ItemNindex).."#W#r#cfff263���ɻ��Ԫ����#G"..GetPneumaProperty(g_LuaArg0,7).."#cfff263#r�����������#Gȷ��#cfff263�����������#Gȡ��#cfff263��"
		end
		Button1 = "#{XLDL_140606_121}"
		Button2 = "#cfff263ȡ��"
		g_FrameInfo = FrameInfoList.ZHENGYUAN_CUIJIE_CONFIRM_PARCKET
		WuhunQuest_InfoWindow:SetText( WindowText )
		WuhunQuest_Button1:Show()
		WuhunQuest_Button1:SetText(Button1);  --ȷ��
		WuhunQuest_Button2:Show()
		WuhunQuest_Button2:SetText(Button2);  --ȡ��
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
		 local nType = tonumber(arg1); 			--1�����ԣ�2�����ԣ�3���ں϶ȣ�4�ǳɳ���
		 local nCurData --= tonumber(arg1); 	--��ǰ���ԡ����ԡ��ں϶ȡ��ɳ���
		 if nType == 4 then
		 	 nCurData = tostring(arg2);
		 else
		 	 nCurData = tonumber(arg2);
		 end
		 local nPrice = tonumber(arg3);			--Ԫ����
		 local nUplimit = tonumber(arg4);		--�ɳ�������
		 local strMsg = tostring(arg5); 		--��������
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
		-- ����
		strText = string.format("#{ZSKJT_130428_5}",strMsg,nCurData,nPrice)
	elseif nType == 2 then
		-- ����
		strText = string.format("#{ZSKJT_130428_10}",strMsg,nCurData,nPrice);
	elseif nType == 3 then
		-- �ں϶�
		strText = string.format("#{ZSKJT_130428_17}",strMsg,nCurData,nPrice);
	elseif nType == 4 then
		-- �ɳ���
		strText = string.format("    #G%s#W��ǰ�ĳɳ���Ϊ#G%s#W����ͯ�ɹ�����ɳ��ʽ�������#G����#W������������ͯ��Ҫ֧��#G%s#WԪ����#r    ���ȷ�Ͻ�������������ȷ���󼴿��������������������������������ȡ����#r    #GС��ʾ�����޵������ɳ������������Я���ȼ��йء�������ͯʱ����ͯ���޵����ʺ����β��ᷢ���κα仯��",strMsg,nCurData,nPrice);
	end

	g_FrameInfo = FrameInfoList.QUICKUP_PET_CONFIRM
	WuhunQuest_InfoWindow:SetText( strText );
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{INTERFACE_XML_557}");  --ȷ��
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{INTERFACE_XML_542}");  --ȡ��
	WuhunQuestUpdateRect();
	this:Show();
end

function WuhunQuest_DeleteComboBook_Confirm(nParam)
	local bookname = GetComboBookInfo(nParam, "bookname");
	local bookitemid = GetComboBookInfo(nParam, "bookitemId");
	local strText = string.format("#cfff263��ȷ��Ҫ����#G%s#cfff263������֮�󣬸ñ��ؼ������¼����ʽ����ȫ����ʧ����ΪҲ���������ͣ���Ϊ������һ��ֵ����Ϊ����Ҳ��֮���ͣ������������ñ��ؼ����������ĵ�ȫ��#G��ѧ�ĵ�#cfff263��#G�ؼ���ҳ#cfff263��������#G�黹#cfff263����ȷ�������˱��ؼ�������#Gȷ��#cfff263�������������ؼ������#Gȡ��#cfff263���ɡ�", bookname )
	if( bookitemid == 30311205 or bookitemid == 30311210 ) then
		strText = strText.."#{WLMJ_130121_77}"
	end
	g_FrameInfo = FrameInfoList.DELETE_COMBOBOOK_CONFIRM
	WuhunQuest_InfoWindow:SetText( strText );
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{INTERFACE_XML_557}");  --ȷ��
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{INTERFACE_XML_542}");  --ȡ��
	WuhunQuestUpdateRect();
	this:Show();
end

function WuhunQuest_ZhenfaForget_Confirm(nIndex)
	WuhunQuest_Clear_Var()
	local skillname = {"#{JBGXW_150526_138}","#{JBGXW_150526_139}","#{JBGXW_150526_140}","#{JBGXW_150526_141}"}
	local backup = Lua_GetZhenfareturnback(nIndex)
	local strText = string.format("    #cfff263��ȷ��Ҫ����#G%s#cfff263������֮�󣬸�#G��#cfff263��#G������#cfff263����ȫ����ʧ�������������������ĵ�#G%s#cfff263��#G����ֵ#cfff263���������黹��ͬʱʧȥ��Ӧ��#G%s#cfff263��#G����Ϊ#cfff263����ȷ���������󷨣�����#Gȷ��#cfff263�������������󷨣����#Gȡ��#cfff263���ɡ�" , skillname[nIndex+1],backup,backup)	
	local bsNum = DataPool:GetPlayerMission_DataRound(302)
	local maxnum = 150000
	if bsNum + backup >= maxnum then
		local realback = maxnum - bsNum;
		strText = string.format("    #cfff263��������ֵ�����ﵽ���ޣ���ȷ��Ҫ����#G%s#cfff263�������󣬸�#G��#cfff263��#G������#cfff263����ȫ����ʧ���������󷨽�ʧȥ��Ӧ��#G%s#cfff263��#G����Ϊ#cfff263��������������ֵ����#G�ﵽ����#cfff263�����β��������黹��#G%s#cfff263��#G����ֵ#cfff263����ȷ���������󷨣�����#Gȷ��#cfff263�������������󷨣����#Gȡ��#cfff263���ɡ�" , skillname[nIndex+1],backup,realback)	
	end
	WuhunQuest_InfoWindow:SetText(strText)
	g_FrameVar[1] = tonumber(nIndex)
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{ZZZB_150811_19}");  --ȷ��
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{ZZZB_150811_20}");  --ȡ��
	WuhunQuestUpdateRect();
	g_FrameInfo = FrameInfoList.ZHENFA_FORGET_CONFIRM
	this:Show()
end

function WuhunQuest_SeckillGiveUp_confirm(nFubenID)
	WuhunQuest_Clear_Var()
	g_FrameVar[1] = tonumber(nFubenID);
	WuhunQuest_InfoWindow:SetText("#{FBSD_151123_07}")
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{LS78_140819_55}");  --ȷ��
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{LS78_140819_56}");  --ȡ��
	WuhunQuestUpdateRect();
	g_FrameInfo = FrameInfoList.SECKILL_GIVEUP_CONFIRM
	this:Show()
end

function WuhunQuest_PetHH_confirm(nIndex,NewModel)
	WuhunQuest_Clear_Var()
	NewModel = tonumber(NewModel)
	local strInfo = ""
	if NewModel == 0 then
		strInfo = "#cfff263��ȷ����Ҫ������#G"..Pet:GetName(nIndex).."#cfff263�û�����#G�̳�#cfff263������ۡ����⣬#G���ޱ���#cfff263�û���#G����#cfff263�ٽ���#G��ֳ#cfff263��ȷ�ϼ����û�������ȷ����ť��"
	elseif NewModel == 1 or NewModel == 2 then
		strInfo = "#cfff263��ȷ����Ҫ������#G"..Pet:GetName(nIndex).."#cfff263�û�����#G���̳�#cfff263������ۡ�#r#Gע�⣺#cfff263�û���ı���۵������޷��ָ����û�ǰ����ۡ��Ƿ�̳���ۿ������޻û�������ѡ�����⣬#G���ޱ���#cfff263�û���#G����#cfff263�ٽ���#G��ֳ#cfff263��ȷ�ϼ����û�������ȷ����ť��"
	end

	WuhunQuest_InfoWindow:SetText(strInfo)
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{ZBCZ_140618_07}");  --ȷ��
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{ZBCZ_140618_08}");  --ȡ��
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
	WuhunQuest_Button1:SetText("#{ZBCZ_140618_07}");  --ȷ��
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{ZBCZ_140618_08}");  --ȡ��
	WuhunQuestUpdateRect();
	g_FrameInfo = FrameInfoList.PETEQUIP_ZIZHI_RECOIN_CONFIRM
	this:Show();
end

function WuhunQuest_Open_Window_PetShouLan_AutoUse(nShouLanCnt,nRequireItem)
	WuhunQuest_Clear_Var()

	g_FrameVar[1] = tonumber(nRequireItem);
	local itemName = LuaFnGetItemName(tonumber(nRequireItem))
	local nMaxPetCount = GetMyCurMaxPetCount()
	--#cfff263��������1��#G%s0#cfff263������1�������������λ�����������ӵ�е�#G������λ����#cfff263������#G%s1#cfff263������ɫ����ӵ��#G4#cfff263�������������λ��#r    ���#Gȷ��#cfff263��ť�󣬽���ɱ��μ�������#Gȡ��#cfff263��ť����������β�����
	local strMsg = string.format("    #cfff263��������1��#G%s#cfff263������1�������������λ�����������ӵ�е�#G������λ����#cfff263������#G%s#cfff263������ɫ����ӵ��#G4#cfff263�������������λ��#r    ���#Gȷ��#cfff263��ť�󣬽���ɱ��μ�������#Gȡ��#cfff263��ť����������β�����",itemName,nMaxPetCount+1)
	WuhunQuest_InfoWindow:SetText( strMsg );

	g_FrameInfo = FrameInfoList.PETSKILL_SHOULANUSE_CONFIRM;
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{INTERFACE_XML_557}");  --ȷ��
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{INTERFACE_XML_542}");  --ȡ��
	WuhunQuestUpdateRect();

	this:Show();
end

function WuhunQuest_Open_Window_PetShouLan_AutoUp(nShouLanCnt,nRequireItem,nRequireYB)
	WuhunQuest_Clear_Var()

	g_FrameVar[1] = tonumber(nShouLanCnt);
	g_FrameVar[2] = tonumber(nRequireYB);
	
	local levelList = {21, 41, 61, 81};
	local freeLanWeiList = {3, 4, 5, 6, 6};
	
	--�жϵȼ��׶�
	local playerLevel =  Player:GetData("LEVEL");
	local levelPos = 1;
	for i = 1, 4 do
	    if(playerLevel >= levelList[i]) then
			levelPos = i + 1;
	    end
	end
	
	local strMsg = "";
	local nMaxPetCount = GetMyCurMaxPetCount()--��ǰ�������
	
	--��ǰ���������
	local curFreePetCount = 0;
	if(playerLevel < levelList[4]) then
	    curFreePetCount = freeLanWeiList[levelPos] -1;
	 else
		curFreePetCount = 6;
	end
	
	--��ǰ����������
	local curExPetCount = nMaxPetCount - curFreePetCount;
	if(playerLevel < levelList[4]) then
	    strMsg = string.format("    #cfff263�����ﵽ#G%s#cfff263��ʱ���ɼ����#G%s#cfff263��#G���������λ#cfff263��ÿ����ɫ���ɼ���#G6#cfff263��#G���������λ#cfff263��#r    ͬʱ�������ڿɻ���#G%s#cfff263Ԫ���������#G%s#cfff263��#G����������λ#cfff263�����������ӵ�е�#G������λ����#cfff263������#G%s#cfff263����ÿ����ɫ���ɼ���#G4#cfff263��#G����������λ#cfff263��#r    ���#Gȷ��#cfff263��ť�󣬽���ɱ���#G����������λ#cfff263�ļ�������������#Gȡ��#cfff263��ť����������β�����", levelList[levelPos], freeLanWeiList[levelPos], nRequireYB, curExPetCount+1, nMaxPetCount+1);
	else
	    strMsg = string.format("    #cfff263���Ѿ�������#G6#cfff263��#G���������λ#cfff263��#r    ͬʱ�������ڿɻ���#G%s#cfff263Ԫ���������#G%s#cfff263��#G����������λ#cfff263�����������ӵ�е�#G������λ����#cfff263������#G%s#cfff263����ÿ����ɫ���ɼ���#G4#cfff263��#G����������λ#cfff263��#r    ���#Gȷ��#cfff263��ť�󣬽���ɱ���#G����������λ#cfff263�ļ�������������#Gȡ��#cfff263��ť����������β�����", nRequireYB, curExPetCount+1, nMaxPetCount+1);
	end

    --local itemName = PlayerPackage:GetItemName(tonumber(nRequireItem))
	WuhunQuest_InfoWindow:SetText( strMsg );

	g_FrameInfo = FrameInfoList.PETSKILL_SHOULANUP_CONFIRM;
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{INTERFACE_XML_557}");  --ȷ��
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{INTERFACE_XML_542}");  --ȡ��
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
	WuhunQuest_Button1:SetText("#{ZBCZ_140618_07}");  --ȷ��
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{ZBCZ_140618_08}");  --ȡ��
	WuhunQuestUpdateRect();
	g_FrameInfo = FrameInfoList.LW_ATTR_RECOIN_CONFIRM
	this:Show();
end

function WuhunQuest_EquipFuKe_Confirm()
	g_FrameInfo = FrameInfoList.EQUIP_ATTRFUKE_CONFIRM 
	WuhunQuest_InfoWindow:SetText( "#{JTFK_1117_31}" );
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{JTFK_1117_32}");  --ȷ��
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{JTFK_1117_33}");  --ȡ��
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
		str = "#{ZBSX_180502_133}" --"��ͨ����ת�Ƴɹ��󣬽���ת�Ƶ�װ���������󶨡�#r���ȷ�ϼ�������ת�ƣ����ȷ�����ٴε��ת�ư�ť������ɡ�"
	end
	g_FrameInfo = FrameInfoList.EQUIP_TRANSFER_CONFIRM
	WuhunQuest_InfoWindow:SetText( str );
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{INTERFACE_XML_557}");  --ȷ��
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{INTERFACE_XML_542}");  --ȡ��
	WuhunQuestUpdateRect();
	this:Show();
end

function WuhunQuest_EquipUpdate_ConfirmEx(itemindex)
	local strInfo = string.format("#cfff263��������������ɹ��ʵ�#G%s#cfff263Ϊ#G��#cfff263���ߣ���ͨ���������ɹ�ʱ������������װ��Ҳ������#G��#cfff263��#r���ȷ�ϼ����������������#Gȷ��#cfff263���ٴε��#G������ť#cfff263������ɡ�", LuaFnGetItemName(itemindex))
	g_FrameInfo = FrameInfoList.EQUIP_UPDATE_CONFIRMEX
	WuhunQuest_InfoWindow:SetText( strInfo );
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{INTERFACE_XML_557}");  --ȷ��
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{INTERFACE_XML_542}");  --ȡ��
	WuhunQuestUpdateRect();
	this:Show();
end

function WuhunQuest_EquipUpdate_Confirm()
	local strInfo = string.format("#cfff263��ͨ���������ɹ�ʱ����#G���ȿ۳�#cfff263������#G�Ѱ�#cfff263��#G%s#cfff263���ҽ���������װ��Ҳ������#G��#cfff263��#r���ȷ�ϼ����������������#Gȷ��#cfff263���ٴε��#G������ť#cfff263������ɡ�#r#GС��ʾ����������ھ�ͨ���������ɹ���װ���󶨣��뽫�������Ѱ󶨵�%s����ֿ����������������", LuaFnGetItemName(20700055),LuaFnGetItemName(20700055))
	g_FrameInfo = FrameInfoList.EQUIP_UPDATE_CONFIRM
	WuhunQuest_InfoWindow:SetText( strInfo );
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{INTERFACE_XML_557}");  --ȷ��
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{INTERFACE_XML_542}");  --ȡ��
	WuhunQuestUpdateRect();
	this:Show();
end

function WuhunQuest_EquipTemper_Confirm()
	g_FrameInfo = FrameInfoList.EQUIP_TEMPER_CONFIRM
	local strInfo = string.format("#cfff263�����ɹ�ʱ�������ȿ۳��������Ѱ󶨵�#G%s#cfff263���ҽ��д�����װ��Ҳ������#G��#cfff263��#r���ȷ�ϼ������д��������#Gȷ��#cfff263���ٴε��#G������ť#cfff263������ɡ�#r#GС��ʾ����������ڴ�����װ���󶨣��뽫�������Ѱ󶨵�%s����ֿ���������д�����", "���","���")
	WuhunQuest_InfoWindow:SetText( strInfo );
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{ZBSX_130625_70}");  --ȷ��
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{INTERFACE_XML_542}");  --ȡ��
	WuhunQuestUpdateRect();
	this:Show();
end

function WuhunQuest_EquipTemper_QueRenConfirm(ProName,nCount,nSameCount)
	g_FrameInfo = FrameInfoList.EQUIP_TEMPER_QUERENCONFIRM
	--local strInfo = string.format("����װ���Ѵ�����ͬ�ľ�ͨ���ԣ�%s����û�б�����������������ͨ���Խ��ᱻ�滻����ʾ��������������Ҫ�ľ�ͨ���Ժ��ټ���������������رա���ť�رձ����档",ProName)
	local strInfo = ""
	if(nCount ~= nSameCount) then
		strInfo = string.format("    #Y��ǰ��������װ������#G%s��#Y��ͬ�ľ�ͨ���ԣ�#G%s#Y��������#G%s#Y��δ�������������������#G����#Y������#Gδ����#Y��#G��ͨ����#Y���ܻᱻ#G�滻#Y��#r    ������#G����#Y��Ҫ������#G��ͨ����#Y�󣬼�������#G����#Y�����Ƿ�������ֱ�ӽ���#G����#Y��",nSameCount,ProName,nCount)
	else
		strInfo = string.format("    #Y��ǰ��#G����#Y��װ������#G%s��#Y��ͬ�ľ�ͨ���ԣ�#G%s#Y���Ҿ�δ�������������������#G����#Y������#Gδ����#Y��#G��ͨ����#Y���ܻᱻ#G�滻#Y��#r    ������#G����#Y��Ҫ������#G��ͨ����#Y�󣬼�������#G����#Y�����Ƿ�������ֱ�ӽ���#G����#Y��",nSameCount,ProName)
	end
	WuhunQuest_InfoWindow:SetText( strInfo );
	WuhunQuest_Button1:Hide()
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{INTERFACE_XML_1173}");  --�ر�
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
	WuhunQuest_Button1:SetText("#{INTERFACE_XML_557}");  --ȷ��
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{INTERFACE_XML_542}");  --ȡ��
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
	WuhunQuest_Button1:SetText("#{ZBCZ_140618_07}");  --ȷ��
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{ZBCZ_140618_08}");  --ȡ��
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
	if keepopen == 0 then --�ر�
		strInfo = "#{WHZN_141216_5}"
	elseif keepopen == 1 then  --����
		strInfo = "#{WHZN_141216_17}"
	elseif  keepopen == 2 then  --ȡ������
		strInfo = "#{WHZN_141216_2}"
	end

	WuhunQuest_InfoWindow:SetText(strInfo)
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{ZBCZ_140618_07}");  --ȷ��
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{ZBCZ_140618_08}");  --ȡ��
	WuhunQuestUpdateRect();
	g_FrameInfo = FrameInfoList.WUHUN_SKILL_RECOIN_CONFIRM
	this:Show();
end

function WuhunQuest_AQLY_AutoFlash_Confirm(Ind)
	g_FrameInfo = FrameInfoList.AQLY_FLASH_COMFIRM
	local strTemp = string.format("    #cfff263��ѡ�񽫵�ǰ����������������Ч����ϴΪ#G%s#cfff263�����#Gȷ��#cfff263�󣬽��Զ�����������Ч��������ϴ��#r    �Զ���ϴ��ʼ�󣬵��������ܵ�#G�������Ч��#cfff263����ϴΪ����ѡ���Ч����������������δ������#G����ʯ#cfff263��#G����#cfff263��#G���#cfff263�þ�����ϴ���̽�#G�Զ�ֹͣ#cfff263��#r    ��ϴ�����У�����ϴ����#G%s#cfff263���������ڵ�ǰ���������е�#G%s#cfff263��������#G�Զ�#cfff263�����滻��#r    #GС��ʾ���Զ���ϴ�����У�������ͨ�������ֹ��ϴ��ť��ر���ϴ���棬����ֹ�Զ���ϴ��#cfff263",g_proDes[Ind + 1],g_proDes[Ind + 1],g_proDes[Ind + 1])
	WuhunQuest_InfoWindow:SetText(strTemp)
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{INTERFACE_XML_557}") 	--ȷ�� 
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{INTERFACE_XML_542}") 	--ȡ��
	WuhunQuestUpdateRect()
	this:Show()
	
end
function WuhunQuest_Open_Window_ZhuanZhang(arg1,arg2)
	g_FrameInfo = FrameInfoList.NEW_BANKZHUANGZHANG
	g_FrameVar[1]  = arg1
	g_FrameVar[2]  = arg2
	local str = ""
		str = string.format("#cfff263    ��ȷ����#G%s#cfff263ת��#G%s#cfff263�������#r    ע�⣺ת�˺��޷����أ���ȷ��ת����#Gȷ��#cfff263������ȷ������ť��",tostring(arg1),tostring(arg2))
	WuhunQuest_InfoWindow:SetText(str)
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{WYXT_20170803_52}") 	--ȷ��
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{WYXT_20170803_53}") 	--ȡ��
	WuhunQuestUpdateRect()
	this:Show() 

end
function WuhunQuest_Open_Window_TiXian(arg1,arg2,arg3,arg4)
	g_FrameInfo = FrameInfoList.NEW_BANKTIXIAN
	g_FrameVar[1]  = arg1
	g_FrameVar[2]  = arg2
	g_FrameVar[3]  = arg3
	g_FrameVar[4]  = arg4
	local nTyoe = {[0] = "΢��",[1] = "֧����"}
	local str = ""
		str = string.format("#cfff263    ��ȷ��Ҫ��#G%s#cfff263��������ֵ��˻�Ϊ#G%s��#G%s#cfff263��#r    ע�⣺���ֺ���ÿ������1����ˣ���ȷ���������������������ϵ����������ּӼ���#Gȷ��#cfff263������ȷ������ť��",tostring(arg2),tostring(arg1),nTyoe[arg3])
	WuhunQuest_InfoWindow:SetText(str)
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{WYXT_20170803_52}") 	--ȷ��
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{WYXT_20170803_53}") 	--ȡ��
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
		str = string.format("#cfff263    �����ڽ���#Gһ������#cfff263��������������Ǳ��һ����������Ҫ����#G%s#cfff263��#G�ϸ�����#cfff263�������ɹ��󣬽�Ϊ���黹#G%s#cfff263���#G����Ǳ��#cfff263��#r    ��ȷ��Ҫ����һ��������#Gȷ��#cfff263������ȷ������ť��",tostring(strTip),tostring(strTip))
	else
		str = strTip
	end
	WuhunQuest_InfoWindow:SetText(str)
	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{WYXT_20170803_52}") 	--ȷ��
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{WYXT_20170803_53}") 	--ȡ��
	WuhunQuestUpdateRect()
	this:Show() 
end

function WuhunQuest_Martial_RLearnTalent_Confirm(nLayer,nLevel,nCost,LayerName,nId1)
	g_FrameInfo = FrameInfoList.MARTAIL_RLEARN_TALENT_CONFIRM
	g_FrameVar[1] = tonumber(nLayer)
	g_FrameVar[2] = tonumber(nId1)
	
	local strTip = string.format("#cfff263    ���Ƿ�ȷ��Ҫ����#G#{_EXCHG%s}#cfff263��������ѧϰ�������ش���#G��%s��#cfff263��#r    ͨ��#G����#cfff263��������Ϊ��������ϰ#G��%s��#cfff263�����ĵ�ȫ��#G��Ԫ#cfff263��ͬʱ��������ϰ��#G��%s��#cfff263��#r    ȷ�Ͻ���#G����#cfff263����������#Gȷ��#cfff263��ť�������ò����ɵ��#Gȡ��#cfff263��ť��",nCost,LayerName,LayerName,LayerName)
	WuhunQuest_InfoWindow:SetText( strTip );

	WuhunQuest_Button1:Show()
	WuhunQuest_Button1:SetText("#{WYXT_20170803_52}");  --ȷ��
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{WYXT_20170803_53}");  --ȡ��
	WuhunQuestUpdateRect();
	this:Show();
	
end

function WuhunQuest_HxyEffectActiveConfirm(nIndex )

	local strVar = ""
	if nIndex == 1 then
		strVar = string.format("    #cfff263��ȷ��ѡ��#G�����ӡЧ��������%s״̬#cfff263������#G1��#cfff263ô��#r    ���ȷ�ϰ�ť���ɹ������#G�����ӡ#cfff26", "#{HXYSJ_141031_79}")
	elseif nIndex == 2 then
		strVar = string.format("    #cfff263��ȷ��ѡ��#G�����ӡЧ��������%s״̬#cfff263������#G1��#cfff263ô��#r    ���ȷ�ϰ�ť���ɹ������#G�����ӡ#cfff26", "#{HXYSJ_141031_80}")
	elseif nIndex == 3 then
		strVar = string.format("    #cfff263��ȷ��ѡ��#G�����ӡЧ��������%s״̬#cfff263������#G1��#cfff263ô��#r    ���ȷ�ϰ�ť���ɹ������#G�����ӡ#cfff26", "#{HXYSJ_141031_81}")
	elseif nIndex == 4 then
		strVar = string.format("    #cfff263��ȷ��ѡ��#G�����ӡЧ��������%s״̬#cfff263������#G1��#cfff263ô��#r    ���ȷ�ϰ�ť���ɹ������#G�����ӡ#cfff26", "#{HXYSJ_141031_82}")
	elseif nIndex == 5 then
		strVar = string.format("    #cfff263��ȷ��ѡ��#G�����ӡЧ��������%s״̬#cfff263������#G1��#cfff263ô��#r    ���ȷ�ϰ�ť���ɹ������#G�����ӡ#cfff26", "#{HXYSJ_141031_83}")
	elseif nIndex == 6 then
		strVar = string.format("    #cfff263��ȷ��ѡ��#G�����ӡЧ��������%s״̬#cfff263������#G1��#cfff263ô��#r    ���ȷ�ϰ�ť���ɹ������#G�����ӡ#cfff26", "#{HXYSJ_141031_84}")
	elseif nIndex == 7 then
		strVar = string.format("    #cfff263��ȷ��ѡ��#G�����ӡЧ��������%s״̬#cfff263������#G1��#cfff263ô��#r    ���ȷ�ϰ�ť���ɹ������#G�����ӡ#cfff26", "#{HXYSJ_141031_85}")
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
	WuhunQuest_Button1:SetText("#{INTERFACE_XML_557}");  --ȷ��
	WuhunQuest_Button2:Show()
	WuhunQuest_Button2:SetText("#{INTERFACE_XML_542}");  --ȡ��
	DataPool:SetCanUseHotKey(0)
	this:Show();
end

-- ��ť1 ����¼�
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
	--����ӡ���� 2019-11-12 13:50:55 ��ң��
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
-- ��ť2 ����¼�
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