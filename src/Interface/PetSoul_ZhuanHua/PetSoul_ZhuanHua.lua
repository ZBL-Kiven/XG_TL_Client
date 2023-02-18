--PetSoul_ZhuanHua

local g_PetSoul_ZhuanHua_UnifiedPosition;

local MAX_OBJ_DISTANCE = 3.0

local g_PetSoul_ZhuanHua_NpcId = -1;
local g_PetSoul_ZhuanHua_targetId = -1;
local g_PetSoul_ZhuanHua_PetSoulPieceCtrl={}
local g_PetSoul_ZhuanHua_PetSoulPieceBagIndex={-1,-1}
local g_PetSoul_ZhuanHua_PetSoulPieceItemIndex={-1,-1}
local g_PetSoul_ZhuanHua_PetSoulPieceQual={-1,-1}
local g_PetSoul_ZhuanHua_PetSoulPieceComboQual=-1
local g_PetSoul_ZhuanHua_Qual_Dest={
	-- 灵兽
	[0] = {
		[1] ="赤熊魂玉",
		[2] ="白驹魂玉",
		[3] ="灵蝉魂玉",
		[4] ="苍狼魂玉",
		[5] ="飞羚魂玉",
	},
	-- 荒兽
	[1] = {
		[1] ="锦鳞魂玉",
		[2] ="幻蝶魂玉",
		[3] ="霜鹤魂玉",
		[4] ="金乌魂玉",
		[5] ="鹿蜀魂玉",
	},
	-- 神兽
	[2] = {
		[1] ="青龙魂玉",
		[2] ="玄武魂玉",
		[3] ="白虎魂玉",
		[4] ="朱雀魂玉",
		[5] ="九尾魂玉",
	},
}

--[[
local g_PetSoul_ZhuanHua_Qual_Dest={
	-- 灵兽
	[0] = {
		[1] ="#{SHXT_20211230_263}",
		[2] ="#{SHXT_20211230_264}",
		[3] ="#{SHXT_20211230_265}",
		[4] ="#{SHXT_20211230_266}",
		[5] ="#{SHXT_20211230_267}",
	},
	-- 荒兽
	[1] = {
		[1] ="#{SHXT_20211230_259}",
		[2] ="#{SHXT_20211230_260}",
		[3] ="#{SHXT_20211230_261}",
		[4] ="#{SHXT_20211230_262}",
		[5] ="#{SHXT_20211230_263}",
	},
	-- 神兽
	[2] = {
		[1] ="#{SHXT_20211230_254}",
		[2] ="#{SHXT_20211230_255}",
		[3] ="#{SHXT_20211230_256}",
		[4] ="#{SHXT_20211230_257}",
		[5] ="#{SHXT_20211230_258}",
	},
}
--]]
function PetSoul_ZhuanHua_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("PETSOUL_ZHUANHUA_PUTIN_ITEM");
	this:RegisterEvent("RESUME_ENCHASE_GEM")
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")			--背包中物品改变需要判断
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function PetSoul_ZhuanHua_OnLoad()
	
	g_PetSoul_ZhuanHua_UnifiedPosition=PetSoul_ZhuanHua_Frame:GetProperty("UnifiedPosition")
	
	g_PetSoul_ZhuanHua_PetSoulPieceCtrl[1] = PetSoul_ZhuanHua_Icon1
	g_PetSoul_ZhuanHua_PetSoulPieceCtrl[2] = PetSoul_ZhuanHua_Icon2
	
end

function PetSoul_ZhuanHua_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == 80012801 ) then
		
		local bIsShow = Get_XParam_INT(0);
		if bIsShow == 1 then
			PetSoul_ZhuanHua_Clear();
			OpenWindow("Packet")
			this:Show()
		end
		
		if this:IsVisible() then
			g_PetSoul_ZhuanHua_targetId = Get_XParam_INT( 1 )
			PetSoul_ZhuanHua_BeginCareObject( g_PetSoul_ZhuanHua_targetId )
		end
		
	elseif event == "PETSOUL_ZHUANHUA_PUTIN_ITEM" and this:IsVisible() then
		if arg0 ~= nil and arg1 ~= nil then
			PetSoul_ZhuanHua_Update( tonumber(arg0), tonumber(arg1), 0 )
		end
		
	elseif ( event == "RESUME_ENCHASE_GEM" and this:IsVisible() ) then
		if tonumber(arg0) == 15 then
			PetSoul_ZhuanHua_Resume(1)
		elseif tonumber(arg0) >= 16 then
			PetSoul_ZhuanHua_Resume(2);
		end
								
	elseif event == "UI_COMMAND" and tonumber(arg0) == 201107281 and this:IsVisible() then
		if not arg1 or tonumber(arg1) == -1 then
			return
		end
		if g_PetSoul_ZhuanHua_PetSoulPieceBagIndex[1] < 0 then
			PetSoul_ZhuanHua_Update(0, tonumber(arg1), 0 )
		else
			PetSoul_ZhuanHua_Update(1, tonumber(arg1), 0 )
		end
		return			
	elseif event == "OBJECT_CARED_EVENT" and this : IsVisible() then
		if(tonumber(arg0) ~= g_PetSoul_ZhuanHua_NpcId) then
			return;
		end
		
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if arg1 == "distance" and tonumber( arg2 ) > MAX_OBJ_DISTANCE or arg1 == "destroy" then
			PetSoul_ZhuanHua_Close()
		end
		return
		
	elseif event == "ADJEST_UI_POS" then
		PetSoul_ZhuanHua_On_ResetPos()
		return
	
	elseif event == "VIEW_RESOLUTION_CHANGED" then
		PetSoul_ZhuanHua_On_ResetPos()
		return
	end
	
end

-- uiPos:0~1 放到魂玉格; -1 寻找空闲的魂玉格
function PetSoul_ZhuanHua_Update( uiPos, bagPos, bItemChanged )

	if bItemChanged == nil then
		bItemChanged = 0;
	end
			
	-- 寻找空闲的魂玉格
	if uiPos == -1 then
		if g_PetSoul_ZhuanHua_PetSoulPieceBagIndex[1] < 0 then
			uiPos = 0;
		elseif g_PetSoul_ZhuanHua_PetSoulPieceBagIndex[2] < 0 then
			uiPos = 1
		else
			uiPos = 0;
		end
	end
	uiPos = uiPos + 1;
	
	local uiOtherPos = 1
	if uiPos == 1 then
		uiOtherPos = 2
	end
	--PushDebugMessage("PetSoul_ZhuanHua_Update2.."..uiPos.." "..uiOtherPos)
	--检查是否为魂玉
	local nItemIndex = PlayerPackage:GetItemTableIndex(bagPos);
	--后期添加函数PlayerPackage:GetBagItemNum
	-- local nItemCount = PlayerPackage:GetBagItemNum(bagPos);
	local nPsIndex, nPsQual = LuaFnGetPetSoulPieceInfo(nItemIndex);
	if nItemIndex == nil then
		PetSoul_ZhuanHua_Resume( uiPos )
		return
	end
	if nPsIndex == nil or nPsQual == nil then
		PushDebugMessage("仅可放入魂玉。")
		return
	end
	
	if bItemChanged > 0 and g_PetSoul_ZhuanHua_PetSoulPieceItemIndex[uiPos] ~= nItemIndex then
		PetSoul_ZhuanHua_Resume( uiPos )
		return
	end
	
	-- 是否同品质
	if g_PetSoul_ZhuanHua_PetSoulPieceBagIndex[uiOtherPos] == nil or g_PetSoul_ZhuanHua_PetSoulPieceQual[uiOtherPos] == nil then
		PushDebugMessage("只能放入同品质魂玉。")
		return
	end
	if g_PetSoul_ZhuanHua_PetSoulPieceQual[uiOtherPos] > -1 and g_PetSoul_ZhuanHua_PetSoulPieceQual[uiOtherPos] ~= nPsQual then
		PushDebugMessage("只能放入同品质魂玉。")
		return
	end
	
	--检查是否加锁
	if PlayerPackage:IsLock( bagPos ) == 1 then
		PushDebugMessage("物品已上锁，无法放入。")	--道具已上锁
		return
	end
	
	if g_PetSoul_ZhuanHua_PetSoulPieceBagIndex[uiPos] ~= -1 then
		LifeAbility : Lock_Packet_Item(g_PetSoul_ZhuanHua_PetSoulPieceBagIndex[uiPos],0);
	end
		
	local theAction = EnumAction( bagPos, "packageitem");
	if theAction:GetID() == 0 then
		return
	end
	g_PetSoul_ZhuanHua_PetSoulPieceCtrl[uiPos]:SetActionItem(theAction:GetID());
	LifeAbility : Lock_Packet_Item(bagPos,1);
	g_PetSoul_ZhuanHua_PetSoulPieceBagIndex[uiPos] = bagPos
	g_PetSoul_ZhuanHua_PetSoulPieceItemIndex[uiPos] = nItemIndex 
	g_PetSoul_ZhuanHua_PetSoulPieceQual[uiPos] = nPsQual; 
		
	PetSoul_ZhuanHua_Refresh_UI()

end

function PetSoul_ZhuanHua_Resume( index )
	if g_PetSoul_ZhuanHua_PetSoulPieceCtrl[index] == nil then
		return
	end
	
	if g_PetSoul_ZhuanHua_PetSoulPieceBagIndex[index] ~= nil and
		g_PetSoul_ZhuanHua_PetSoulPieceBagIndex[index] >= 0 then
		LifeAbility : Lock_Packet_Item(g_PetSoul_ZhuanHua_PetSoulPieceBagIndex[index],0);
		g_PetSoul_ZhuanHua_PetSoulPieceCtrl[index]:SetActionItem(-1);
		g_PetSoul_ZhuanHua_PetSoulPieceBagIndex[index] = -1;
		g_PetSoul_ZhuanHua_PetSoulPieceItemIndex[index] = -1; 
		g_PetSoul_ZhuanHua_PetSoulPieceQual[index] = -1;
	end
	
	PetSoul_ZhuanHua_Refresh_UI()

end

function PetSoul_ZhuanHua_Clear()
	PetSoul_ZhuanHua_Resume(1)
	PetSoul_ZhuanHua_Resume(2)
	
	PetSoul_ZhuanHua_Refresh_UI()
		
end

function PetSoul_ZhuanHua_Refresh_UI()

	PetSoul_ZhuanHua_OK:Disable();
	
	local nPsQual = g_PetSoul_ZhuanHua_PetSoulPieceQual[1];
	if nPsQual == -1 then
		nPsQual = g_PetSoul_ZhuanHua_PetSoulPieceQual[2];
	end

	if g_PetSoul_ZhuanHua_PetSoulPieceComboQual ~= nPsQual then
		PetSoul_ZhuanHua_Bind:SetText("");
		PetSoul_ZhuanHua_Bind:ResetList();
		g_PetSoul_ZhuanHua_PetSoulPieceComboQual = nPsQual;
		
		local PetSoulPieceDest=g_PetSoul_ZhuanHua_Qual_Dest[nPsQual];
		if PetSoulPieceDest == nil then
			return
		end
	
		for i=1, table.getn(PetSoulPieceDest) do
			PetSoul_ZhuanHua_Bind:ComboBoxAddItem(PetSoulPieceDest[i], i);
		end
		
	end
	
	local nSelName, nSelID = PetSoul_ZhuanHua_Bind:GetCurrentSelect();
	if nSelID > 0 then
		PetSoul_ZhuanHua_OK:Enable();
	end
	
end

function PetSoul_ZhuanHua_DstChanged()
	PetSoul_ZhuanHua_Refresh_UI()
end

function PetSoul_ZhuanHua_Buttons_Clicked()

	--二级密码 电话密保检查
	-- if CheckPhoneMibaoAndMinorPassword() ~= 1 then
		-- return
	-- end
	
	local nSelName, nSelID = PetSoul_ZhuanHua_Bind:GetCurrentSelect();
	if nSelID <= 0 then
		return
	end
		
	Clear_XSCRIPT()
		Set_XSCRIPT_ScriptID( 742562 )
		Set_XSCRIPT_Function_Name( "OnPetSoulPieceZhuanHua" )
		Set_XSCRIPT_Parameter(0, g_PetSoul_ZhuanHua_targetId)
		Set_XSCRIPT_Parameter(1, g_PetSoul_ZhuanHua_PetSoulPieceBagIndex[1])
		Set_XSCRIPT_Parameter(2, g_PetSoul_ZhuanHua_PetSoulPieceBagIndex[2])
		Set_XSCRIPT_Parameter(3, nSelID)
		Set_XSCRIPT_ParamCount(4)
	Send_XSCRIPT()
end

--=========================================================
--开始关心NPC，
--在开始关心之前需要先确定这个界面是不是已经有“关心”的NPC，
--如果有的话，先取消已经有的“关心”
--=========================================================
function PetSoul_ZhuanHua_BeginCareObject( objCaredId )
	g_PetSoul_ZhuanHua_NpcId = DataPool : GetNPCIDByServerID( objCaredId )
	if g_PetSoul_ZhuanHua_NpcId == -1 then
		this : Hide()
		return
	end

	this : CareObject( g_PetSoul_ZhuanHua_NpcId, 1, "PetSoul_ZhuanHua" )
end

--=========================================================
--停止对某NPC的关心
--=========================================================
function PetSoul_ZhuanHua_StopCareObject()
	this : CareObject( g_PetSoul_ZhuanHua_NpcId, 0, "PetSoul_ZhuanHua" )
	g_PetSoul_ZhuanHua_NpcId = -1
end

function PetSoul_ZhuanHua_On_ResetPos()
  PetSoul_ZhuanHua_Frame:SetProperty("UnifiedPosition", g_PetSoul_ZhuanHua_UnifiedPosition)
end

function PetSoul_ZhuanHua_OnHiden()
	PetSoul_ZhuanHua_StopCareObject();
	
	PetSoul_ZhuanHua_Clear();	
end

function PetSoul_ZhuanHua_Close()
	this:Hide()
end

function LuaFnGetPetSoulPieceInfo(nItemIndex)
	local PetSoulInfo = {
	{38002515,39995366,2},
	{38002516,39995367,2},
	{38002517,39995368,2},
	{38002518,39995369,2},
	{38002519,39995370,2},
	{38002520,39995371,1},
	{38002521,39995372,1},
	{38002522,39995373,1},
	{38002523,39995374,1},
	{38002524,39995375,1},
	{38002525,39995376,0},
	{38002526,39995377,0},
	{38002527,39995378,0},
	{38002528,39995379,0},
	{38002529,39995380,0},
	}
	for i = 1,table.getn(PetSoulInfo) do
		if PetSoulInfo[i][1] == nItemIndex then
			return PetSoulInfo[i][2],PetSoulInfo[i][3]
		end
	end
	return nil,nil
end

function LuaFnGetPetSoulDataInBag(bagPos,typename,Num)
	if typename == "LEVEL" then
		local szAuthor = SuperTooltips:GetAuthorInfo();
		if szAuthor ~= nil then
			local posx,posy,Level = string.find(szAuthor,"&SH(%w%w%w)")
			if posx == nil and posy == nil then
				return nil
			else
				return tonumber(Level)
			end
		end
		return nil
	end
	if typename == "MAXNEED" then
		--品阶，当前魂意
		return 0
	end
	if typename == "BR" then
		local szAuthor = SuperTooltips:GetAuthorInfo();
		local _,_,_,nSolt,_,_,AttrInfo = string.find(szAuthor,"&SH(%w%w%w)(%w)(%w%w%w%w%w)(%w)(.*)")
		return tonumber(nSolt)
	end
	if typename == "BC" then
		local szAuthor = SuperTooltips:GetAuthorInfo();
		local _,_,_,_,nBloodConcentrate,_,AttrInfo = string.find(szAuthor,"&SH(%w%w%w)(%w)(%w%w%w%w%w)(%w)(.*)")
		return tonumber(nBloodConcentrate)
	end
	if typename == "MAXBC" then
		local szAuthor = SuperTooltips:GetAuthorInfo();
		local _,_,_,nPinJie = string.find(szAuthor,"&SH(%w%w%w)(%w)(%w%w%w%w%w)(%w)(.*)")
		local nSoulID = {{39995376,39995377,39995378,39995379,39995380},{39995371,39995372,39995373,39995374,39995375},{39995366,39995367,39995368,39995369,39995370}}
		local theAction = EnumAction(bagPos, "packageitem")
		local iQual = -1
		for i = 1,3 do
			for j = 1,5 do
				if theAction:GetDefineID() == nSoulID[i][j] then
					iQual = i - 1
				end
			end
		end		
		local HyMaxBc = LuaFnGetPetSoulMaxBc(tonumber(nPinJie),iQual)
		return tonumber(HyMaxBc)
	end
	if typename == "QUAL" then
		--修正
		local nSoulID = {{39995376,39995377,39995378,39995379,39995380},{39995371,39995372,39995373,39995374,39995375},{39995366,39995367,39995368,39995369,39995370}}
		local theAction = EnumAction(bagPos, "packageitem")
		for i = 1,3 do
			for j = 1,5 do
				if theAction:GetDefineID() == nSoulID[i][j] then
					return i-1
				end
			end
		end
		return -1
	end
	--得到属性名字咯
	if typename == "TIPS" then
		local tempStr, qual = "",0
		local szAuthor = SuperTooltips:GetAuthorInfo();
		local _,_,_,nSolt,_,_,AttrInfo = string.find(szAuthor,"&SH(%w%w%w)(%w)(%w%w%w%w%w)(%w)(.*)")
		tempStr = LuaFnGetPetSoulBaseIndex(AttrInfo,Num)
		qual = 4
		return tempStr, qual
	end
end

function LuaFnGetPetSoulDataInServer(typename,i)
	local tempStr = ""
	local _,_,_,nSolt,_,_,AttrInfo = string.find(typename,"&SH(%w%w%w)(%w)(%w%w%w%w%w)(%w)(.*)")
	tempStr = LuaFnGetPetSoulBaseIndex(AttrInfo,i)
	return tempStr
end