local ACTION_BUTTON = {};
local ACTION_BUTTON_NUMBERS = 25;

function Action_PreLoad()
	this:RegisterEvent("CHAT_ACT_SELECT");
	this:RegisterEvent("CHAT_ADJUST_MOVE_CTL");
end

function Action_OnLoad()
	ACTION_BUTTON[1] = Action_1;
	ACTION_BUTTON[2] = Action_2;
	ACTION_BUTTON[3] = Action_3;
	ACTION_BUTTON[4] = Action_4;
	ACTION_BUTTON[5] = Action_5;
	ACTION_BUTTON[6] = Action_6;
	ACTION_BUTTON[7] = Action_7;
	ACTION_BUTTON[8] = Action_8;
	ACTION_BUTTON[9] = Action_9;
	ACTION_BUTTON[10] = Action_10;
	ACTION_BUTTON[11] = Action_11;
	ACTION_BUTTON[12] = Action_12;
	ACTION_BUTTON[13] = Action_13;
	ACTION_BUTTON[14] = Action_14;
	ACTION_BUTTON[15] = Action_15;
	ACTION_BUTTON[16] = Action_16;
	ACTION_BUTTON[17] = Action_17;
	ACTION_BUTTON[18] = Action_18;
	ACTION_BUTTON[19] = Action_19;
	ACTION_BUTTON[20] = Action_20;
	ACTION_BUTTON[21] = Action_21;
	ACTION_BUTTON[22] = Action_22;
	ACTION_BUTTON[23] = Action_23;
	ACTION_BUTTON[24] = Action_24;
	ACTION_BUTTON[25] = Action_25;
end

function Action_OnEvent( event )
	if( event == "CHAT_ACT_SELECT" ) then
		Action_OnShow(arg0);
	elseif (event == "CHAT_ADJUST_MOVE_CTL") then
		Action_AdjustMoveCtl();
	end
end

function Action_OnShow(pos)
	local i = 1;
	if(this:IsVisible() or this:ClickHide()) then
		this:Hide();
		return;
	end
	Action_ChangePosition(pos);
	while i <= ACTION_BUTTON_NUMBERS do
		local theAction = Talk:EnumChatMood(i-1);
		
		if(theAction:GetID() ~= 0) then
			ACTION_BUTTON[i]:SetActionItem(theAction:GetID());
			ACTION_BUTTON[i]:Enable();
			--local strTip = theAction:GetDesc();
			--ACTION_BUTTON[i]:SetToolTip(strTip);
		else
			ACTION_BUTTON[i]:SetActionItem(-1);
			ACTION_BUTTON[i]:Disable();
			--ACTION_BUTTON[i]:SetToolTip("");
		end
		
		i=i+1;
	end
	
--	local ctl = Chat_SelfActionFrame;
--	ctl:SetProperty("UnifiedXPosition", "{0.0,0.0}");
--	local udimYPos = ctl:GetProperty("UnifiedPosition");
--	local udimSize = ctl:GetProperty("UnifiedSize");
--	AxTrace(0,0,"Action1: Action_AdjustMoveCtl: Pos:"..udimYPos.." Size:"..udimSize);
	
	this:Show();
	
--	udimYPos = ctl:GetProperty("UnifiedPosition");
--	udimSize = ctl:GetProperty("UnifiedSize");
--	AxTrace(0,0,"Action2: Action_AdjustMoveCtl: Pos:"..udimYPos.." Size:"..udimSize);
end

function Action_AdjustMoveCtl()
	this:Hide();
end

function Action_ChangePosition(pos)
	Action_Frame:SetProperty("UnifiedXPosition", "{0.0,"..pos.."}");
end

function Lua_GetOtherPetEquipAttr()
	local nEquipTab = {0,0,0,0,0} 
	local nPetEquipZhiZi = {0,0,0,0,0,0,0,0,0,0}
	local nEquipDataMD = {105,106,107,108,109,110,111,112,113,114}
	local nPetAdptMD_3 = {100,101,102,103,104}
	for i = 1,5 do
	    local nEquipData = DataPool:GetXYJServerData(nPetAdptMD_3[i])
	    nEquipTab[i] = nEquipData
	end
	for i = 1,10 do
	    local nEquipZhiZiData = DataPool:GetXYJServerData(nEquipDataMD[i])
	    nPetEquipZhiZi[i] = nEquipZhiZiData
	end	
	local nPetEquipAttrData = {0,0,0,0,0,0,0,0,0,0,0,0,0} 
	local nAttrTtpe = {[46]=1,[29]=2,[22]=3,[43]=4,[26]=5,[0]=6,[19]=7,[35]=8,[42]=9,[36]=10,[37]=11,[44]=12,[45]=13}
	local nSetAttrNum = 0
	local _,_,nAttrType_1,nAttr_1,nAttrType_2,nAttr_2,nAttrType_3,nAttr_3
    --身法 内功防御 外功防御 灵气 内功攻击 血上限 外功攻击 命中 力量 闪避 会心 体力 定力
	for i = 1,5 do	
	    if  nEquipTab[i] >= 39980000 and nEquipTab[i] <= 39994162 then
            local nBaseWG,nBaseNG,nBaseWF,nBaseNF,nBaseMiss,nSetAttr,_,_,_,nEquipBase_1,nEquipBase_2,nEquipBase_3,nEquipBase_4,nEquipBase_1Data,nEquipBase_2Data,nEquipBase_3Data,nEquipBase_4Data = Lua_EnumPetEquip(nEquipTab[i])
			_,_,nAttrType_1,nAttr_1,nAttrType_2,nAttr_2,nAttrType_3,nAttr_3 = Lua_EnumPetEquipAttr(nSetAttr)
			local nHaveAttrData = {nBaseWG,nBaseNG,nBaseWF,nBaseNF,nBaseMiss,nEquipBase_1,nEquipBase_2,nEquipBase_3,nEquipBase_4}
			local nSetAttrTable = Lua_GetAttrEquipID(nSetAttr)			
			for j = 1, 5 do
				if LuaFnGetItemName(nSetAttrTable[j]) == LuaFnGetItemName(nEquipTab[i]) then
					nSetAttrNum = nSetAttrNum + 1;
				end
			end			
			--装备基础属性
			nPetEquipAttrData[nAttrTtpe[19]] = nPetEquipAttrData[nAttrTtpe[19]] + nBaseWG
			nPetEquipAttrData[nAttrTtpe[26]] = nPetEquipAttrData[nAttrTtpe[26]] + nBaseNG
			nPetEquipAttrData[nAttrTtpe[22]] = nPetEquipAttrData[nAttrTtpe[22]] + nBaseWF
			nPetEquipAttrData[nAttrTtpe[29]] = nPetEquipAttrData[nAttrTtpe[29]] + nBaseNF
			nPetEquipAttrData[nAttrTtpe[36]] = nPetEquipAttrData[nAttrTtpe[36]] + nBaseMiss
			--装备属性
			nPetEquipAttrData[nAttrTtpe[nEquipBase_1Data]] = nPetEquipAttrData[nAttrTtpe[nEquipBase_1Data]] + nEquipBase_1
			nPetEquipAttrData[nAttrTtpe[nEquipBase_2Data]] = nPetEquipAttrData[nAttrTtpe[nEquipBase_2Data]] + nEquipBase_2
			nPetEquipAttrData[nAttrTtpe[nEquipBase_3Data]] = nPetEquipAttrData[nAttrTtpe[nEquipBase_3Data]] + nEquipBase_3
			nPetEquipAttrData[nAttrTtpe[nEquipBase_4Data]] = nPetEquipAttrData[nAttrTtpe[nEquipBase_4Data]] + nEquipBase_4
			--装备资质计算
			local nAdpt_1 = nPetEquipZhiZi[(i * 2) - 1]
			local nAdpt_2 = nPetEquipZhiZi[(i * 2)]
			if nAdpt_1 ~= 0 then
			    --外功资质
                if nBaseWG > 0 then
				    nPetEquipAttrData[7] = nPetEquipAttrData[7] + math.ceil(nBaseWG * (nAdpt_1/100))
				    nPetEquipAttrData[5] = nPetEquipAttrData[5] + math.ceil(nBaseNG * (nAdpt_2/100))
                end						
			    --外功防御
                if nBaseWF > 0 then
				    nPetEquipAttrData[3] = nPetEquipAttrData[3] + math.ceil(nBaseWF * (nAdpt_1/100))
				    nPetEquipAttrData[2] = nPetEquipAttrData[2] + math.ceil(nBaseNF * (nAdpt_2/100))
                end						
			    --闪避
                if nBaseMiss > 0 then
				    nPetEquipAttrData[10] = nPetEquipAttrData[10] + math.ceil(nBaseMiss * (nAdpt_1/100))
                end				
			end
		end	
	end
	--套装属性
    if nSetAttrNum == 2 then
		nPetEquipAttrData[nAttrTtpe[nAttrType_1]] = nPetEquipAttrData[nAttrTtpe[nAttrType_1]] + nAttr_1
	elseif nSetAttrNum == 3 then		
		nPetEquipAttrData[nAttrTtpe[nAttrType_1]] = nPetEquipAttrData[nAttrTtpe[nAttrType_1]] + nAttr_1
		nPetEquipAttrData[nAttrTtpe[nAttrType_2]] = nPetEquipAttrData[nAttrTtpe[nAttrType_2]] + nAttr_2
	elseif nSetAttrNum == 4 then		
		nPetEquipAttrData[nAttrTtpe[nAttrType_1]] = nPetEquipAttrData[nAttrTtpe[nAttrType_1]] + nAttr_1
		nPetEquipAttrData[nAttrTtpe[nAttrType_2]] = nPetEquipAttrData[nAttrTtpe[nAttrType_2]] + nAttr_2
		nPetEquipAttrData[nAttrTtpe[nAttrType_3]] = nPetEquipAttrData[nAttrTtpe[nAttrType_3]] + nAttr_3
	elseif nSetAttrNum == 5 then		
		nPetEquipAttrData[nAttrTtpe[nAttrType_1]] = nPetEquipAttrData[nAttrTtpe[nAttrType_1]] + nAttr_1
		nPetEquipAttrData[nAttrTtpe[nAttrType_2]] = nPetEquipAttrData[nAttrTtpe[nAttrType_2]] + nAttr_2
		nPetEquipAttrData[nAttrTtpe[nAttrType_3]] = nPetEquipAttrData[nAttrTtpe[nAttrType_3]] + nAttr_3
	end	
    for i = 1,table.getn(nPetEquipAttrData) do
	    if nPetEquipAttrData[i] < 0 then
		    nPetEquipAttrData[i] = 0
		end
	end
	--属性异步，同步服务端，奈何奈何~属性完全不够用。
	local nYiBuValue = {10,20,20,1,20,10,20,25,1,25,1,1,1}
	for i = 1,table.getn(nPetEquipAttrData) do
	    if nPetEquipAttrData[i] > 0 then
			local nMaxBase = math.ceil(nPetEquipAttrData[i]/nYiBuValue[i])
			nPetEquipAttrData[i] = nMaxBase * nYiBuValue[i]
		end
	end
	return nPetEquipAttrData
end

function Lua_GetPetEquipAttr(nIndex)
	local nEquipTab = {0,0,0,0,0} 
	local nPetEquipZhiZi = {0,0,0,0,0,0,0,0,0,0}
	local nEquipDataMD = {5,6,7,8,9,10,11,12,13,14}
	local nPetAdptMD_3 = {15,16,17,18,19}
	for i = 1,5 do
	    local nEquipData = DataPool:GetXYJServerData(nPetAdptMD_3[i])
	    nEquipTab[i] = nEquipData
	end
	for i = 1,10 do
	    local nEquipZhiZiData = DataPool:GetXYJServerData(nEquipDataMD[i])
	    nPetEquipZhiZi[i] = nEquipZhiZiData
	end	
	local nPetEquipAttrData = {0,0,0,0,0,0,0,0,0,0,0,0,0,0} 
	local nAttrTtpe = {[46]=1,[29]=2,[22]=3,[43]=4,[26]=5,[0]=6,[19]=7,[35]=8,[42]=9,[36]=10,[37]=11,[44]=12,[45]=13}
	local nSetAttrNum = 0
	local _,_,nAttrType_1,nAttr_1,nAttrType_2,nAttr_2,nAttrType_3,nAttr_3
    --身法 内功防御 外功防御 灵气 内功攻击 血上限 外功攻击 命中 力量 闪避 会心 体力 定力
	for i = 1,5 do	
	    if  nEquipTab[i] >= 39980000 and nEquipTab[i] <= 39994162 then
            local nBaseWG,nBaseNG,nBaseWF,nBaseNF,nBaseMiss,nSetAttr,_,_,_,nEquipBase_1,nEquipBase_2,nEquipBase_3,nEquipBase_4,nEquipBase_1Data,nEquipBase_2Data,nEquipBase_3Data,nEquipBase_4Data = Lua_EnumPetEquip(nEquipTab[i])
			_,_,nAttrType_1,nAttr_1,nAttrType_2,nAttr_2,nAttrType_3,nAttr_3 = Lua_EnumPetEquipAttr(nSetAttr)
			local nHaveAttrData = {nBaseWG,nBaseNG,nBaseWF,nBaseNF,nBaseMiss,nEquipBase_1,nEquipBase_2,nEquipBase_3,nEquipBase_4}
			local nSetAttrTable = Lua_GetAttrEquipID(nSetAttr)			
			for j = 1, 5 do
				if LuaFnGetItemName(nSetAttrTable[j]) == LuaFnGetItemName(nEquipTab[i]) then
					nSetAttrNum = nSetAttrNum + 1;
				end
			end			
			--装备基础属性
			nPetEquipAttrData[nAttrTtpe[19]] = nPetEquipAttrData[nAttrTtpe[19]] + nBaseWG
			nPetEquipAttrData[nAttrTtpe[26]] = nPetEquipAttrData[nAttrTtpe[26]] + nBaseNG
			nPetEquipAttrData[nAttrTtpe[22]] = nPetEquipAttrData[nAttrTtpe[22]] + nBaseWF
			nPetEquipAttrData[nAttrTtpe[29]] = nPetEquipAttrData[nAttrTtpe[29]] + nBaseNF
			nPetEquipAttrData[nAttrTtpe[36]] = nPetEquipAttrData[nAttrTtpe[36]] + nBaseMiss
			--装备属性
			nPetEquipAttrData[nAttrTtpe[nEquipBase_1Data]] = nPetEquipAttrData[nAttrTtpe[nEquipBase_1Data]] + nEquipBase_1
			nPetEquipAttrData[nAttrTtpe[nEquipBase_2Data]] = nPetEquipAttrData[nAttrTtpe[nEquipBase_2Data]] + nEquipBase_2
			nPetEquipAttrData[nAttrTtpe[nEquipBase_3Data]] = nPetEquipAttrData[nAttrTtpe[nEquipBase_3Data]] + nEquipBase_3
			nPetEquipAttrData[nAttrTtpe[nEquipBase_4Data]] = nPetEquipAttrData[nAttrTtpe[nEquipBase_4Data]] + nEquipBase_4
			--装备资质计算
			local nAdpt_1 = nPetEquipZhiZi[(i * 2) - 1]
			local nAdpt_2 = nPetEquipZhiZi[(i * 2)]
			if nAdpt_1 ~= 0 then
			    --外功资质
                if nBaseWG > 0 then
				    nPetEquipAttrData[7] = nPetEquipAttrData[7] + math.ceil(nBaseWG * (nAdpt_1/100))
				    nPetEquipAttrData[5] = nPetEquipAttrData[5] + math.ceil(nBaseNG * (nAdpt_2/100))
                end						
			    --外功防御
                if nBaseWF > 0 then
				    nPetEquipAttrData[3] = nPetEquipAttrData[3] + math.ceil(nBaseWF * (nAdpt_1/100))
				    nPetEquipAttrData[2] = nPetEquipAttrData[2] + math.ceil(nBaseNF * (nAdpt_2/100))
                end						
			    --闪避
                if nBaseMiss > 0 then
				    nPetEquipAttrData[10] = nPetEquipAttrData[10] + math.ceil(nBaseMiss * (nAdpt_1/100))
                end				
			end
		end	
	end
	--套装属性
    if nSetAttrNum == 2 then
		nPetEquipAttrData[nAttrTtpe[nAttrType_1]] = nPetEquipAttrData[nAttrTtpe[nAttrType_1]] + nAttr_1
	elseif nSetAttrNum == 3 then		
		nPetEquipAttrData[nAttrTtpe[nAttrType_1]] = nPetEquipAttrData[nAttrTtpe[nAttrType_1]] + nAttr_1
		nPetEquipAttrData[nAttrTtpe[nAttrType_2]] = nPetEquipAttrData[nAttrTtpe[nAttrType_2]] + nAttr_2
	elseif nSetAttrNum == 4 then		
		nPetEquipAttrData[nAttrTtpe[nAttrType_1]] = nPetEquipAttrData[nAttrTtpe[nAttrType_1]] + nAttr_1
		nPetEquipAttrData[nAttrTtpe[nAttrType_2]] = nPetEquipAttrData[nAttrTtpe[nAttrType_2]] + nAttr_2
		nPetEquipAttrData[nAttrTtpe[nAttrType_3]] = nPetEquipAttrData[nAttrTtpe[nAttrType_3]] + nAttr_3
	elseif nSetAttrNum == 5 then		
		nPetEquipAttrData[nAttrTtpe[nAttrType_1]] = nPetEquipAttrData[nAttrTtpe[nAttrType_1]] + nAttr_1
		nPetEquipAttrData[nAttrTtpe[nAttrType_2]] = nPetEquipAttrData[nAttrTtpe[nAttrType_2]] + nAttr_2
		nPetEquipAttrData[nAttrTtpe[nAttrType_3]] = nPetEquipAttrData[nAttrTtpe[nAttrType_3]] + nAttr_3
	end	
	--项圈出战属性
	if nEquipTab[4] ~= 0 then
		local nPos_1,nBase_1,nPos_2,nBase_2 = GetPetEquip4PointBase(nEquipTab[4])
		if nPos_1 ~= -1 then
			nPetEquipAttrData[nAttrTtpe[nPos_1]] = nPetEquipAttrData[nAttrTtpe[nPos_1]] + nBase_1
		end
		if nPos_2 ~= -1 then
			nPetEquipAttrData[nAttrTtpe[nPos_2]] = nPetEquipAttrData[nAttrTtpe[nPos_2]] + nBase_2
		end
	end		
    for i = 1,table.getn(nPetEquipAttrData) do
	    if nPetEquipAttrData[i] < 0 then
		    nPetEquipAttrData[i] = 0
		end
	end
	-- 属性异步，同步服务端，奈何奈何~属性完全不够用。
	-- 取消珍兽装备BUFF加成效果，改为引擎属性加成，引擎已修正
	-- 录入力，灵，体，定，身，属性加成
	local nLevel = Pet : GetLevel(nIndex)
	local nGrowRate = Pet : GetGrowRate(nIndex);
	local nStrPer = Pet : GetStrAptitude(nIndex)
	local nSprPer = Pet : GetIntAptitude(nIndex)
	local nConPer = Pet : GetPFAptitude(nIndex)
	local nIntPer = Pet : GetStaAptitude(nIndex)
	local nDexPer = Pet : GetDexAptitude(nIndex)
	--属性点加成计算
	if nPetEquipAttrData[12] ~= 0 then
		nPetEquipAttrData[6] = nPetEquipAttrData[6] + math.floor(44+(nLevel*6*nGrowRate+nPetEquipAttrData[12]*nConPer*1.8)/100)--血量
		nPetEquipAttrData[3] = nPetEquipAttrData[3] + math.floor(12+(nLevel*2.88*nGrowRate+nPetEquipAttrData[12]*nConPer*1.08)/100)--外功防御
	end
	if nPetEquipAttrData[9] ~= 0 then
		nPetEquipAttrData[7] = nPetEquipAttrData[7] + math.floor(50+(nLevel*2.9*nGrowRate+nPetEquipAttrData[9]*nStrPer*1.1)/100)--外功攻击
	end
	if nPetEquipAttrData[4] ~= 0 then
		nPetEquipAttrData[5] = nPetEquipAttrData[5] + math.floor(50+(nLevel*2.9*nGrowRate+nPetEquipAttrData[4]*nSprPer*1.1)/100)--内功攻击
	end
	if nPetEquipAttrData[13] ~= 0 then
		nPetEquipAttrData[2] = nPetEquipAttrData[2] + math.floor(12+(nLevel*2.88*nGrowRate+nPetEquipAttrData[13]*nIntPer*1.08)/100)--内功防御
	end
	if nPetEquipAttrData[1] ~= 0 then
		nPetEquipAttrData[10] = nPetEquipAttrData[10] + math.floor(5+(nLevel*0.26*nGrowRate+nPetEquipAttrData[1]*nDexPer*0.0863)/100)--闪避
		nPetEquipAttrData[8] = nPetEquipAttrData[8] + math.floor(16+(nLevel*0.78*nGrowRate+nPetEquipAttrData[1]*nDexPer*0.26)/100)--命中
		nPetEquipAttrData[11] = nPetEquipAttrData[11] + math.floor(6+(nLevel*0.006*nGrowRate+nPetEquipAttrData[1]*nDexPer*0.002)/100)--会心
		nPetEquipAttrData[14] = nPetEquipAttrData[14] + math.floor(6+(nLevel*0.006*nGrowRate+nPetEquipAttrData[1]*nDexPer*0.002)/100)--会心防御
	end	
	-- local nYiBuValue = {10,20,20,1,20,10,20,25,1,25,1,1,1}
	-- for i = 1,table.getn(nPetEquipAttrData) do
	    -- if nPetEquipAttrData[i] > 0 then
			-- local nMaxBase = math.ceil(nPetEquipAttrData[i]/nYiBuValue[i])
			-- nPetEquipAttrData[i] = nMaxBase * nYiBuValue[i]
		-- end
	-- end
	return nPetEquipAttrData
end
function GetPetEquip4PointBase(nItemID)
	local nPetEquip4Point = {[39993000] ={42,11,44,11},[39993001] ={42,13,44,13},[39993002] ={42,18,44,28},[39993003] ={42,27,44,27},[39993004] ={42,33,44,33},[39993005] ={35,93,37,2},[39993006] ={35,102,37,4},[39993007] ={35,139,37,6},[39993008] ={35,204,37,8},[39993009] ={35,251,37,10},[39993010] ={42,11,46,11},[39993011] ={42,13,46,13},[39993012] ={42,18,46,18},[39993013] ={42,27,46,27},[39993014] ={42,33,46,33},[39993015] ={43,11,44,11},[39993016] ={43,13,44,13},[39993017] ={43,18,44,18},[39993018] ={43,27,44,27},[39993019] ={43,33,44,33},[39993020] ={35,93,37,2},[39993021] ={35,102,37,4},[39993022] ={35,139,37,6},[39993023] ={35,204,37,8},[39993024] ={35,251,37,10},[39993025] ={43,11,46,11},[39993026] ={43,13,46,13},[39993027] ={43,18,46,18},[39993028] ={43,27,46,27},[39993029] ={43,33,46,33},[39993030] ={44,19,-1,-1},[39993031] ={44,23,-1,-1},[39993032] ={44,32,-1,-1},[39993033] ={44,48,-1,-1},[39993034] ={44,59,-1,-1},[39993035] ={44,11,46,11},[39993036] ={44,13,46,13},[39993037] ={44,18,46,18},[39993038] ={44,27,46,27},[39993039] ={44,33,46,33},[39993040] ={46,19,-1,-1},[39993041] ={46,23,-1,-1},[39993042] ={46,32,-1,-1},[39993043] ={46,48,-1,-1},[39993044] ={46,59,-1,-1},[39993045] ={42,13,44,13},[39993046] ={42,15,44,15},[39993047] ={42,20,44,20},[39993048] ={42,30,44,30},[39993049] ={42,37,44,37},[39993050] ={35,105,37,3},[39993051] ={35,115,37,5},[39993052] ={35,157,37,7},[39993053] ={35,231,37,10},[39993054] ={35,283,37,13},[39993055] ={42,13,46,13},[39993056] ={42,15,46,15},[39993057] ={42,20,46,20},[39993058] ={42,30,46,30},[39993059] ={42,37,46,37},[39993060] ={43,13,44,13},[39993061] ={43,15,44,15},[39993062] ={43,20,44,20},[39993063] ={43,30,44,30},[39993064] ={43,37,44,37},[39993065] ={35,105,37,3},[39993066] ={35,115,37,5},[39993067] ={35,157,37,7},[39993068] ={35,231,37,10},[39993069] ={35,283,37,13},[39993070] ={43,13,46,13},[39993071] ={43,15,46,15},[39993072] ={43,20,46,20},[39993073] ={43,30,46,30},[39993074] ={43,37,46,37},[39993075] ={44,23,-1,-1},[39993076] ={44,27,-1,-1},[39993077] ={44,36,-1,-1},[39993078] ={44,54,-1,-1},[39993079] ={44,66,-1,-1},[39993080] ={44,13,46,13},[39993081] ={44,15,46,15},[39993082] ={44,20,46,20},[39993083] ={44,30,46,30},[39993084] ={44,37,46,37},[39993085] ={46,23,-1,-1},[39993086] ={46,27,-1,-1},[39993087] ={46,36,-1,-1},[39993088] ={46,54,-1,-1},[39993089] ={46,66,-1,-1},[39993090] ={42,14,44,14},[39993091] ={42,16,44,16},[39993092] ={42,23,44,23},[39993093] ={42,33,44,33},[39993094] ={42,41,44,41},[39993095] ={35,117,37,4},[39993096] ={35,128,37,6},[39993097] ={35,175,37,9},[39993098] ={35,257,37,12},[39993099] ={35,315,37,16},[39993100] ={42,14,46,14},[39993101] ={42,16,46,16},[39993102] ={42,23,46,23},[39993103] ={42,33,46,33},[39993104] ={42,41,42,41},[39993105] ={43,14,44,14},[39993106] ={43,16,44,16},[39993107] ={43,23,44,23},[39993108] ={43,33,44,33},[39993109] ={43,41,44,41},[39993110] ={35,117,37,4},[39993111] ={35,128,37,6},[39993112] ={35,175,37,9},[39993113] ={35,257,37,12},[39993114] ={35,315,37,16},[39993115] ={43,14,46,14},[39993116] ={43,16,46,16},[39993117] ={43,23,46,23},[39993118] ={43,33,46,33},[39993119] ={43,41,46,41},[39993120] ={44,25,-1,-1},[39993121] ={44,28,-1,-1},[39993122] ={44,41,-1,-1},[39993123] ={44,59,-1,-1},[39993124] ={44,73,-1,-1},[39993125] ={44,14,46,14},[39993126] ={44,16,46,16},[39993127] ={44,23,46,23},[39993128] ={44,33,46,33},[39993129] ={44,41,46,41},[39993130] ={46,25,-1,-1},[39993131] ={46,28,-1,-1},[39993132] ={46,41,-1,-1},[39993133] ={46,59,-1,-1},[39993134] ={46,73,-1,-1},[39993135] ={42,44,44,44},[39993136] ={35,334,37,12},[39993137] ={42,44,46,44},[39993138] ={43,44,44,44},[39993139] ={35,334,37,12},[39993140] ={43,44,46,44},[39993141] ={44,79,-1,-1},[39993142] ={44,44,46,44},[39993143] ={46,79,-1,-1},[39993144] ={42,49,44,49},[39993145] ={35,378,37,20},[39993146] ={42,49,46,49},[39993147] ={43,49,44,49},[39993148] ={35,378,37,17},[39993149] ={43,49,46,49},[39993150] ={44,88,-1,-1},[39993151] ={44,49,46,49},[39993152] ={46,88,-1,-1},[39993153] ={42,55,44,55},[39993154] ={35,421,37,20},[39993155] ={42,55,46,55},[39993156] ={43,55,44,55},[39993157] ={35,421,37,20},[39993158] ={43,55,46,55},[39993159] ={44,99,-1,-1},[39993160] ={44,55,46,55},[39993161] ={46,99,-1,-1},[39993162] ={44,19,-1,-1},}
    if nPetEquip4Point[nItemID] == nil then
	    return 0,0,0,0
	end
	return nPetEquip4Point[nItemID][1],nPetEquip4Point[nItemID][2],nPetEquip4Point[nItemID][3],nPetEquip4Point[nItemID][4]
end

--/////////////////////////////////获取物品名称///////////////////////////
function LuaFnGetItemNameEx(nPos) --按照背包位置号获取物品名称
    local theAction = EnumAction(nPos, "packageitem")--GemMelting:UpdateProductAction(ItemID)
	if theAction:GetID() ~= 0 then		
		return theAction:GetName()
	else
		return ""
	end
end
--*********************************************
--珍兽灵性幻化获取，写一起了
--*********************************************
function LuaFn_GetPetLingXing(nIndex,nType)
	local strName = Pet:GetBasic(nIndex);
    if nType == 1 then
		return math.floor(strName/10000)
	end
    if nType == 2 then
		strName = Pet:GetSavvy(nIndex);
		if strName <= 10 then
			return 0
		end
		return strName - 10
	end
end
--*********************************************
--珍兽灵性幻化获取，写一起了
--*********************************************
function LuaFn_GetTargetPetLingXing(nType)
	local strName = TargetPet:GetBasic()
    if nType == 1 then
		return math.floor(strName/10000)
	end
    if nType == 2 then
		strName = TargetPet : GetSavvy();
		if strName <= 10 then
			return 0
		end
		return strName - 10
	end
end
--*********************************************
--珍兽灵性幻化获取 中位数
--*********************************************
function LuaFn_GetOtherPetLingXing(nIndex,nType)
	local strName = Pet:Other_GetBasic(nIndex);
    if nType == 1 then
		return math.floor(strName/10000)
	end
    if nType == 2 then
		strName = Pet : Other_GetSavvy(nIndex);
		if strName <= 10 then
			return 0
		end
		return strName - 10
	end
end
--*********************************************
--珍兽融合度 首位数
--*********************************************
function LuaFn_GetPetRHD(nIndex)
	local strName = Pet:GetBasic(nIndex);
	return math.mod(math.floor(strName/100),100)
end
--*********************************************
--珍兽融合度 首位数
--*********************************************
function LuaFn_GetTargetPetRHD()
	local strName = TargetPet:GetBasic()
	return math.mod(math.floor(strName/100),100)
end
--*********************************************
--珍兽融合度 首位数
--*********************************************
function LuaFn_GetOtherPetRHD(nIndex)
	local strName = Pet:Other_GetBasic(nIndex);
	return math.mod(math.floor(strName/100),100)
end