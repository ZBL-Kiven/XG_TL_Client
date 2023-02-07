-- 时装镶嵌试衣间

local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0

local g_DressEnchase_Fitting_Frame_UnifiedPosition;

function DressEnchase_Fitting_PreLoad()
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OPEN_DRESS_ENCHASE_FITTING");
	this:RegisterEvent("CLOSE_DRESS_ENCHASE_FITTING");	
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("OPEN_STALL_SALE");
	this:RegisterEvent("PROGRESSBAR_SHOW");	
	this:RegisterEvent("OPEN_EQUIP");
	this:RegisterEvent("SEX_CHANGED");
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("YIGUI_OPEN",false)
end

function DressEnchase_Fitting_OnLoad()
	g_DressEnchase_Fitting_Frame_UnifiedPosition=DressEnchase_Fitting_Frame:GetProperty("UnifiedPosition");
end

function DressEnchase_Fitting_OnEvent(event)
	
	-- 离开游戏世界
	if ( event == "PLAYER_ENTERING_WORLD" ) then
		if this:IsVisible() then
			DressEnchase_Fitting_OnHiden();
		end
	end
	
	-- 镶嵌成功，如果试衣间开着，就先关闭
	if event == "UI_COMMAND" and tonumber(arg0) == 09111602 then		
		if this:IsVisible() then
			DressEnchase_Fitting_OnHiden();										-- 关闭“镶嵌预览”试衣间，这里相关试衣物品的数据都没了，所以不能激活“镶嵌预览”按钮
		end
	end
	
	-- 关闭试衣间
	if (event == "CLOSE_DRESS_ENCHASE_FITTING") then		
		if this:IsVisible() then
			DressEnchase_Fitting_OnHiden();										-- 这里是由于逻辑不合理、物品不合格关闭的试衣间，所以不能激活“镶嵌预览”按钮
		end
	end
	
	-- 开始摆摊
	if ( event == "OPEN_STALL_SALE" ) then
		if (this:IsVisible()) then
			DressEnchase_Fitting_OnClosed();										-- 关闭“镶嵌预览”试衣间，重新激活“镶嵌预览”按钮
		end
	end
	
	-- 读进度条中
	if ( event == "PROGRESSBAR_SHOW" ) then
		if (this:IsVisible()) then
			DressEnchase_Fitting_OnClosed();									-- 关闭“镶嵌预览”试衣间，重新激活“镶嵌预览”按钮
		end
	end
	
	-- 试衣的时候不能打开角色资料窗口
	if ( event == "OPEN_EQUIP" ) then
		if (this:IsVisible()) then
			DressEnchase_Fitting_OnClosed();									-- 关闭“镶嵌预览”试衣间，重新激活“镶嵌预览”按钮
		end
	end
	
	-- 试衣的时候不能打开衣柜窗口
	if ( event == "YIGUI_OPEN" ) then
		if (this:IsVisible()) then
			DressEnchase_Fitting_OnClosed();									-- 关闭“镶嵌预览”试衣间，重新激活“镶嵌预览”按钮
		end
	end
	
	-- 打开试衣间
	if(event == "OPEN_DRESS_ENCHASE_FITTING") then
		
		-- 重新激活“镶嵌预览”按钮
		if (IsWindowShow("Dress_Enchase")) then
			DressEnchasing : EnableDressEnchasePreview()
		end

		-- 试衣
		local nDressBagPos	= tonumber(arg0)
		local nGemBagPos		= tonumber(arg1)
		DressEnchasing : FittingOnDress (nDressBagPos, nGemBagPos)
		this:Show();
		
		-- 设置使用哪个模型
		DressEnchase_Fitting_FakeObject : SetFakeObject("");	
		DressEnchase_Fitting_FakeObject : SetFakeObject("DressEnchase_Player");
				
		-- 开始关心NPC
		local npcID = Get_XParam_INT(0);
		local objCared = DataPool : GetNPCIDByServerID(npcID);
		if objCared == -1 then
			return;
		end		
		this:CareObject(objCared, 1, "DressEnchase_Fitting");
	end	
	
	-- 关心NPC
	if (event == "OBJECT_CARED_EVENT") then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		
		--如果和商人的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			if this:IsVisible() then
				DressEnchase_Fitting_OnHiden();								-- 关闭“镶嵌预览”试衣间，由于距离NPC较远，镶嵌界面可能已经关闭了，所以不需要激活“镶嵌预览”按钮了。
			end
		end
	end
	
	-- 变性
	if event == "SEX_CHANGED" and  this:IsVisible() then
		DressEnchase_Fitting_FakeObject : Hide();
		DressEnchase_Fitting_FakeObject : Show();
		DressEnchase_Fitting_FakeObject : SetFakeObject("DressEnchase_Player")
		
	elseif (event == "ADJEST_UI_POS" ) then
		DressEnchase_Fitting_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		DressEnchase_Fitting_Frame_On_ResetPos()
	end

end

--*******************************************************************************
-- 注意！！！
-- OnHiden() 函数关闭界面的时候，不会再次激活“镶嵌预览”按钮
-- OnClosed() 函数关闭界面的时候，会再次激活“镶嵌预览”按钮
-- 这两个函数不能通用~~
--*******************************************************************************

----------------------------------------------------------------------------------
--
-- 隐藏
--
function DressEnchase_Fitting_OnHiden()
	SetDefaultMouse();

	-- 恢复试衣前的装备参数
	DressEnchasing : RestoreDressEnchaseFitting()
	DressEnchase_Fitting_FakeObject:SetFakeObject("")
	--取消关心
	this:CareObject(objCared, 0, "DressEnchase_Fitting");
	objCared = -1

	this:Hide();
end

----------------------------------------------------------------------------------
--
-- 关闭
--
function DressEnchase_Fitting_OnClosed()
	
	-- 恢复试衣前的装备参数
	DressEnchasing : RestoreDressEnchaseFitting()	
	
	--取消关心
	this:CareObject(objCared, 0, "DressEnchase_Fitting");
	objCared = -1

	-- 重新激活“镶嵌预览”按钮
	if (IsWindowShow("Dress_Enchase")) then
		DressEnchasing : EnableDressEnchasePreview()
	end
	
	this:Hide();

end

----------------------------------------------------------------------------------
--
-- 旋转人物头像模型（向左)
--
function DressEnchase_Fitting_TurnLeft(start)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then	
		--向左旋转开始
		if(start == 1) then
			DressEnchase_Fitting_FakeObject:RotateBegin(-0.3);
		--向左旋转结束
		else
			DressEnchase_Fitting_FakeObject:RotateEnd();
		end
	end
end

----------------------------------------------------------------------------------
--
--旋转人物头像模型（向右)
--
function DressEnchase_Fitting_TurnRight(start)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then	
		--向右旋转开始
		if(start == 1) then
			DressEnchase_Fitting_FakeObject:RotateBegin(0.3);
		--向右旋转结束
		else
			DressEnchase_Fitting_FakeObject:RotateEnd();
		end
	end
end

function DressEnchase_Fitting_Frame_On_ResetPos()
  DressEnchase_Fitting_Frame:SetProperty("UnifiedPosition", g_DressEnchase_Fitting_Frame_UnifiedPosition);
end