local g_Frame_UnifiedPosition

local g_objid = -1
local g_objCared = -1

local MCTJ_QUALITY = {};
local MCTJ_BUTTONS = {};
local MCTJ_IMPACT = {};
local g_Impact_Index = -1

--每天对应的菜系
local g_Menu = {
	--[20211014]={name="#{KYX_20210715_64}",id=1}, --川菜 1
	[20211015]={name="#{KYX_20210715_65}",id=2}, --鲁菜 2
	[20211016]={name="#{KYX_20210715_69}",id=6}, --闽菜 6
	[20211017]={name="#{KYX_20210715_68}",id=5}, --浙菜 5
	[20211018]={name="#{KYX_20210715_70}",id=7}, --湘菜 7
	[20211019]={name="#{KYX_20210715_71}",id=8}, --徽菜 8
	[20211020]={name="#{KYX_20210715_66}",id=3}, --粤菜 3
	[20211021]={name="#{KYX_20210715_67}",id=4}, --苏菜 4
	[20211022]={name="#{KYX_20210715_65}",id=2}, --鲁菜 2
	[20211023]={name="#{KYX_20210715_68}",id=5}, --浙菜 5
	[20211024]={name="#{KYX_20210715_71}",id=8}, --徽菜 8
	[20211025]={name="#{KYX_20210715_67}",id=4}, --苏菜 4
	[20211026]={name="#{KYX_20210715_64}",id=1}, --川菜 1
	[20211027]={name="#{KYX_20210715_69}",id=6}, --闽菜 6
	[20211028]={name="#{KYX_20210715_70}",id=7}, --湘菜 7
	[20211029]={name="#{KYX_20210715_66}",id=3}, --粤菜 3
	[20211030]={name="#{KYX_20210715_65}",id=2}, --鲁菜 2
	[20211031]={name="#{KYX_20210715_67}",id=4}, --苏菜 4
	[20211101]={name="#{KYX_20210715_64}",id=1}, --川菜 1
	[20211102]={name="#{KYX_20210715_66}",id=3}, --粤菜 3
	[20211103]={name="#{KYX_20210715_68}",id=5}, --浙菜 5
}


--=========
-- PreLoad()
--=========
function Mingcaitijiao_PreLoad()

	this:RegisterEvent("UI_COMMAND",true)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)	--进场景关闭界面
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("OBJECT_CARED_EVENT",false)
	this:RegisterEvent("UPDATE_KAIYANXI_SUBMIT",false)
	this:RegisterEvent("PACKAGE_ITEM_CHANGED",false)

end

--=========
-- OnLoad()
--=========
function Mingcaitijiao_OnLoad()

	g_Frame_UnifiedPosition = Mingcaitijiao_Frame:GetProperty("UnifiedPosition")
	
	MCTJ_QUALITY[1] = -1;
	MCTJ_QUALITY[2] = -1;

	MCTJ_BUTTONS[1] = Mingcaitijiao_Gift1_Item1;
	MCTJ_BUTTONS[2] = Mingcaitijiao_Gift1_Item2;	
	
	MCTJ_IMPACT[1] = {main=Mingcaitijiao_Select_1,H=Mingcaitijiao_Select1_H,N=Mingcaitijiao_Select1_N}
	MCTJ_IMPACT[2] = {main=Mingcaitijiao_Select_2,H=Mingcaitijiao_Select2_H,N=Mingcaitijiao_Select2_N}
	MCTJ_IMPACT[3] = {main=Mingcaitijiao_Select_3,H=Mingcaitijiao_Select3_H,N=Mingcaitijiao_Select3_N}
	MCTJ_IMPACT[4] = {main=Mingcaitijiao_Select_4,H=Mingcaitijiao_Select4_H,N=Mingcaitijiao_Select4_N}
	MCTJ_IMPACT[5] = {main=Mingcaitijiao_Select_5,H=Mingcaitijiao_Select5_H,N=Mingcaitijiao_Select5_N}
	MCTJ_IMPACT[6] = {main=Mingcaitijiao_Select_6,H=Mingcaitijiao_Select6_H,N=Mingcaitijiao_Select6_N}
	MCTJ_IMPACT[7] = {main=Mingcaitijiao_Select_7,H=Mingcaitijiao_Select7_H,N=Mingcaitijiao_Select7_N}
	MCTJ_IMPACT[8] = {main=Mingcaitijiao_Select_8,H=Mingcaitijiao_Select8_H,N=Mingcaitijiao_Select8_N}
	
	g_Impact_Index = -1
	
end

--=========
-- Event
--=========
function Mingcaitijiao_OnEvent(event)

	if event == "UI_COMMAND" and tonumber(arg0) == 891175 then

		Mingcaitijiao_OnHiden()
	
		g_objid = Get_XParam_INT(0)
        g_objCared = DataPool:GetNPCIDByServerID(g_objid)
		this:CareObject(g_objCared, 1, "Mingcaitijiao");
		g_Impact_Index = Get_XParam_INT(1)
		
		for i=1, table.getn(MCTJ_IMPACT) do
			if i == g_Impact_Index then
				Mingcaitijiao_SetImage(i, 1)
			else
				Mingcaitijiao_SetImage(i, 0)
			end
		end
		
		Mingcaitijiao_Clear()
			
		this:Show()

	elseif event == "HIDE_ON_SCENE_TRANSED" then

		Mingcaitijiao_OnHiden()

	elseif event == "VIEW_RESOLUTION_CHANGED" then

		Mingcaitijiao_ResetPos()

	elseif event == "ADJEST_UI_POS" then

		Mingcaitijiao_ResetPos()

    elseif ( event == "OBJECT_CARED_EVENT" and this:IsVisible() ) then
		if(tonumber(arg0) ~= g_objCared) then
			return
		end
		-- 如果和NPC的距离大于一定距离或者被删除，自动关闭
        if(arg1 == "distance" and tonumber(arg2)>3 or arg1=="destroy") then
            Mingcaitijiao_OnHiden()
        end
		--取消关心
		this:CareObject(g_objCared, 0, "Mingcaitijiao");
	
	elseif ( event == "UPDATE_KAIYANXI_SUBMIT" ) then
		
		local param1 = tonumber(arg0) ---1:代表点击背包中的物品; 1，代表拖拽，到提交界面第1个槽；2，代表拖拽，到提交界面第2个槽
		local param2 = tonumber(arg1) --背包中点击或者拖拽的物品，在背包中的格子序号
		
		--点击背包
		if param1 == -1 then
			if MCTJ_QUALITY[1] == -1 then
				--MCTJ_QUALITY[1] = param2
				if MCTJ_QUALITY[2] ~= -1 then
					local theAction1 = EnumAction(param2, "packageitem");
					local theAction2 = EnumAction(MCTJ_QUALITY[2], "packageitem");
					if theAction1:GetDefineID() == theAction2:GetDefineID() then
						PushDebugMessage("#{KYX_20210715_12}")
						return
					end
				end					
				param1 = 1			
			elseif MCTJ_QUALITY[2] == -1 then
				--MCTJ_QUALITY[2] = param2
				if MCTJ_QUALITY[1] ~= -1 then
					local theAction1 = EnumAction(param2, "packageitem");
					local theAction2 = EnumAction(MCTJ_QUALITY[1], "packageitem");				
					if theAction1:GetDefineID() == theAction2:GetDefineID() then
						PushDebugMessage("#{KYX_20210715_12}")
						return
					end
				end					
				param1 = 2
			else
				PushDebugMessage("#{KYX_20210715_73}")
				--两个空格都有了，就不能再放了
				return
			end		
		--拖拽
		else
			if param1 == 1 then
				--MCTJ_QUALITY[1] = param2
				if MCTJ_QUALITY[2] ~= -1 then
					local theAction1 = EnumAction(param2, "packageitem");
					local theAction2 = EnumAction(MCTJ_QUALITY[2], "packageitem");
					if theAction1:GetDefineID() == theAction2:GetDefineID() then
						PushDebugMessage("#{KYX_20210715_12}")
						return
					end
				end					
			elseif param1 == 2 then
				--MCTJ_QUALITY[2] = param2
				if MCTJ_QUALITY[1] ~= -1 then
					local theAction1 = EnumAction(param2, "packageitem");
					local theAction2 = EnumAction(MCTJ_QUALITY[1], "packageitem");				
					if theAction1:GetDefineID() == theAction2:GetDefineID() then
						PushDebugMessage("#{KYX_20210715_12}")
						return
					end
				end					
			else
				return
			end		
		end
		
		Mingcaitijiao_UpdateUI(param1, param2)
	
	elseif (event == "PACKAGE_ITEM_CHANGED") then
	
		--有任何东西改变都要重置
		if( arg0~= nil and -1 == tonumber(arg0)) then
			return;
		end
		if( arg0~= nil ) then
			if (MCTJ_QUALITY[1] == tonumber(arg0) ) then
				Mingcaitijiao_Resume(1)
			elseif ( MCTJ_QUALITY[2] == tonumber(arg0) ) then
				Mingcaitijiao_Resume(2)
			end
		end		
	end

end

function Mingcaitijiao_Resume(nIndex)

	if( this:IsVisible() ) then
		if MCTJ_QUALITY[nIndex]~=nil and MCTJ_QUALITY[nIndex] ~= -1 then
			MCTJ_BUTTONS[nIndex]:SetActionItem(-1)			
			LifeAbility : Lock_Packet_Item(MCTJ_QUALITY[nIndex],0);
			MCTJ_QUALITY[nIndex] = -1
		end
	end
	
end

function Mingcaitijiao_UpdateUI(UI_index,Item_index)

	local i_index = tonumber(Item_index)
	local u_index = tonumber(UI_index)
	local theAction = EnumAction(i_index, "packageitem");
	
	if theAction:GetID() ~= 0 then
	
		if MCTJ_QUALITY[u_index] ~= -1 then
			LifeAbility : Lock_Packet_Item(MCTJ_QUALITY[u_index],0);
		end
		MCTJ_BUTTONS[u_index]:SetActionItem(theAction:GetID());
		LifeAbility : Lock_Packet_Item(i_index,1);
		MCTJ_QUALITY[u_index] = i_index

	else
	
		MCTJ_BUTTONS[u_index]:SetActionItem(-1);			
		LifeAbility : Lock_Packet_Item(MCTJ_QUALITY[u_index],0);		
		MCTJ_QUALITY[u_index] = -1;
			
	end
	
end

function Mingcaitijiao_OK_Clicked()

	local pos1 = MCTJ_QUALITY[1]
	local pos2 = MCTJ_QUALITY[2]
	local item1 = PlayerPackage : GetItemTableIndex( MCTJ_QUALITY[1] )
	local item2 = PlayerPackage : GetItemTableIndex( MCTJ_QUALITY[2] )

	if item1 == -1 or item2 == -1 then
		PushDebugMessage("#{KYX_20210715_57}")
		return
	end

	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("MingCaiSubmit");
		Set_XSCRIPT_ScriptID(891175);
		Set_XSCRIPT_Parameter(0, g_objid);
		Set_XSCRIPT_Parameter(1, pos1);
		Set_XSCRIPT_Parameter(2, pos2);
		Set_XSCRIPT_ParamCount(3);
	Send_XSCRIPT();
	
end

function Mingcaitijiao_ResetPos()

	Mingcaitijiao_Frame:SetProperty("UnifiedPosition", g_Frame_UnifiedPosition)

end

function Mingcaitijiao_OnHiden()
	--取消关心
	this:CareObject(g_objCared, 0, "Mingcaitijiao");
	g_objCared = -1
	g_objid = -1
	Mingcaitijiao_Clear()
	this:Hide()
end

function Mingcaitijiao_Clear()

	for i=1,2 do 
		if MCTJ_QUALITY[i] ~= -1 then
			MCTJ_BUTTONS[i]:SetActionItem(-1);
			LifeAbility : Lock_Packet_Item(MCTJ_QUALITY[i],0);
			MCTJ_QUALITY[i] = -1
		end
	end

end

function Mingcaitijiao_SetImage(index, operate)

	if index < 1 or index > table.getn(MCTJ_IMPACT) then
		return
	end
	
	if operate ~= 0 and operate ~= 1 then
		return
	end

	local info = MCTJ_IMPACT[index]
	if operate == 1 then
		--info.main:SetProperty("Image", info.H)
		info.H:Show()
		info.N:Hide()
	else
		--info.main:SetProperty("Image", info.N)
		info.H:Hide()
		info.N:Show()		
	end
	
end
