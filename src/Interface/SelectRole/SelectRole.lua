-----------------------------------------------------------------------------------------------------------------
--
-- 全局变量区
--

-- 名字
local g_RoleName = {};

-- 门派
local g_iMenPai = {};

-- 等级
local g_iLevel = {};

-- 剩余删除时间
local g_iDelTime = {};

-- 头像资源名称
local g_FaceImg = {};

-- 在界面上显示的ui模型
local g_UIModel = {};

-- 选择按钮
local g_BnSelCheck = {};

-- 当前选择的角色
local g_iCurSelRole = 0;

-- 当前角色的个数
local g_iCurRoleCount = 0;

-- 如果是创建成功后刷新界面， 要选中最后创建的这个角色.
--
-- 0 -- 创建角色失败。
-- 1 -- 创建角色成功。
local g_bCreateSuccess = 0;

-- UI界面资源
local g_RolName_Text = {};
local g_MenPai_Text = {};
local g_Level_Text = {};
local g_Delete_Text = {};
local g_RolFace_Icon = {};
local g_HighLightBack = {};
local g_CreateInfo_Text = {};
------------------------------------------------------------------------------------------------------------------
--
-- 函数区
--

-- 注册onLoad事件
function LoginSelectRole_PreLoad()
	-- 打开界面
	this:RegisterEvent("GAMELOGIN_OPEN_SELECT_CHARACTOR");
	
	-- 关闭界面
	this:RegisterEvent("GAMELOGIN_CLOSE_SELECT_CHARACTOR");
	
	-- 刷新角色信息
	this:RegisterEvent("GAMELOGIN_REFRESH_ROLE_SELECT_CHARACTOR");
	
	-- 创建角色成功。
	this:RegisterEvent("GAMELOGIN_CREATE_ROLE_OK");
	
	this:RegisterEvent("ENTER_GAME");
	
	this:RegisterEvent("GAMELOGIN_SELECTCHARACTER");

end

-- 注册onLoad事件
function LoginSelectRole_OnLoad()
	
	-- 角色名字
	--g_RoleName[1] = SelectRole_Role1_Name;
	--g_RoleName[2] = SelectRole_Role2_Name;
	--g_RoleName[3] = SelectRole_Role3_Name;
	
	g_RoleName[1] = ""
	g_RoleName[2] = ""
	g_RoleName[3] = ""
	
	-- 角色门派
	g_iMenPai[1] = 0;
	g_iMenPai[2] = 0;
	g_iMenPai[3] = 0;
	
	-- 角色等级
	g_iLevel[1] = 0;
	g_iLevel[2] = 0;
	g_iLevel[3] = 0;
	
	g_iDelTime[1] = 0;
	g_iDelTime[2] = 0;
	g_iDelTime[3] = 0;
	
	-- 角色头像信息
	g_FaceImg[1] = ""
	g_FaceImg[2] = ""
	g_FaceImg[3] = ""
	
	-- 角色选择按钮
	--g_BnSelCheck[1] = SelectRole_Role1;
	--g_BnSelCheck[2] = SelectRole_Role2;
	--g_BnSelCheck[3] = SelectRole_Role3;
	
	-- 选择按钮
	--g_BnSelCheck[1]:SetProperty("CheckMode", "1");	
	--g_BnSelCheck[2]:SetProperty("CheckMode", "1");	
	--g_BnSelCheck[3]:SetProperty("CheckMode", "1");	
	
	--g_BnSelCheck[1]:SetCheck( 0 );	
	--g_BnSelCheck[2]:SetCheck( 0 );	
	--g_BnSelCheck[3]:SetCheck( 0 );	
	-- ui模型名字
	--g_UIModel[1] = SelectRole_Role1_Model;
	--g_UIModel[2] = SelectRole_Role2_Model;
	--g_UIModel[3] = SelectRole_Role3_Model;
	
	--SelectRole_Role1_Model:SetProperty("MouseHollow", "True");	
	--SelectRole_Role2_Model:SetProperty("MouseHollow", "True");	
	--SelectRole_Role3_Model:SetProperty("MouseHollow", "True");	
	
	g_RolName_Text[1] = SelectRole_TargetInfo_Name_Text;
	g_RolName_Text[2] = SelectRole_TargetInfo_Name_Text2;
	g_RolName_Text[3] = SelectRole_TargetInfo_Name_Text3;
	
	g_MenPai_Text[1] = SelectRole_TargetInfo_Menpai_Text;
	g_MenPai_Text[2] = SelectRole_TargetInfo_Menpai_Text2;
	g_MenPai_Text[3] = SelectRole_TargetInfo_Menpai_Text3;
	
	g_Level_Text[1] = SelectRole_TargetInfo_Level_Text;
	g_Level_Text[2] = SelectRole_TargetInfo_Level_Text2;
	g_Level_Text[3] = SelectRole_TargetInfo_Level_Text3;
	
	g_Delete_Text[1] = SelectRole_TargetInfo_Delete;
	g_Delete_Text[2] = SelectRole_TargetInfo_Delete2;
	g_Delete_Text[3] = SelectRole_TargetInfo_Delete3;
	
	g_RolFace_Icon[1] = SelectRole_Icon;
	g_RolFace_Icon[2] = SelectRole_Icon2;
	g_RolFace_Icon[3] = SelectRole_Icon3;
	
	g_HighLightBack[1] = SelectRole_TargetInfo_Gaoliang1;
	g_HighLightBack[2] = SelectRole_TargetInfo_Gaoliang2;
	g_HighLightBack[3] = SelectRole_TargetInfo_Gaoliang3;
	
	g_CreateInfo_Text[1] = SelectRole_TargetInfo_Create;
	g_CreateInfo_Text[2] = SelectRole_TargetInfo_Create2;
	g_CreateInfo_Text[3] = SelectRole_TargetInfo_Create3;
	
	for i = 1, 3 do
		g_RolName_Text[i]:SetText("");
		g_MenPai_Text[i]:SetText("");
		g_Level_Text[i]:SetText("");
		g_Delete_Text[i]:SetText("");
		g_RolFace_Icon[i]:SetProperty("Image", "");
		g_HighLightBack[i]:Hide();
		g_CreateInfo_Text[i]:Show();
	end
end

-- OnEvent
function LoginSelectRole_OnEvent(event)
	
	if (event == "GAMELOGIN_OPEN_SELECT_CHARACTOR") then
		MAINMENUBAR_COOLDOWN = {}
		MAINMENUBAR_SKILLID = {}
		local CurSelIndex = GameProduceLogin:GetCurSelectRole();
		
		-- 默认选择第一个人物。
		g_iCurSelRole = CurSelIndex + 1  --1;
		
		AxTrace(1, 0, g_iCurSelRole)
		
		SelectRole_ClearInfo();
		SelectRole_RefreshRoleInfo();
		this:Show();
		return ;
	end
	
	if (event == "GAMELOGIN_CLOSE_SELECT_CHARACTOR") then
		
		-- 清空数据
		SelectRole_ClearInfo();
		this:Hide();
		return ;
	end
	
	
	-- 刷新角色
	if (event == "GAMELOGIN_REFRESH_ROLE_SELECT_CHARACTOR") then
		
		SelectRole_RefreshRoleInfo();
		return ;
	end
	
	
	-- 创建角色成功。
	if (event == "GAMELOGIN_CREATE_ROLE_OK") then
		
		g_bCreateSuccess = 1;
		return ;
	end
	
	if (event == "ENTER_GAME") then
		GameProduceLogin:SendEnterGameMsg(g_iCurSelRole - 1);
		return ;
	end
	
	if (event == "GAMELOGIN_SELECTCHARACTER") then
		local CurSel = tonumber(arg0)
		
		if (0 == CurSel) then
			SelectRole_SelectRole1()
		end
		
		if (1 == CurSel) then
			SelectRole_SelectRole2()
		end
		
		if (2 == CurSel) then
			SelectRole_SelectRole3()
		end
	
	end
	SelectRole_HighLight();

end



---------------------------------------------------------------------------------------------
--
-- 进入游戏
--
function SelectRole_EnterGame()
	
	-- 发送进入游戏消息
	GameProduceLogin:SendEnterGameMsg(g_iCurSelRole - 1);
end

---------------------------------------------------------------------------------------------
--
-- 创建角色
--
function SelectRole_CreateRole()
	
	--此处不直接从人物选择界面切换到人物创建界面....
	--向Login请求创建人物的图形验证信息....验证信息到来后会开启验证界面....验证通过后验证界面会切换到人物创建流程....
	-- DataPool:AskCreateCharCode();
	GameProduceLogin:ChangeToCreateRoleDlgFromSelectRole(); --若果开启这个，创建人物无验证
end



---------------------------------------------------------------------------------------------
--
-- 删除角色
--
function SelectRole_DelRole()
	
	GameProduceLogin:SetCurSelect(g_iCurSelRole - 1);
	-- 从人物选择界面切换到人物创建界面.
	local strName;
	local iMenPai;
	local iLevel;
	local iDelTime;
	local strInfo;
	local strImgName;
	strName
	, iMenPai
	, iLevel
	, iDelTime
	, strImgName = GameProduceLogin:GetRoleInfo(g_iCurSelRole - 1);
	if (iLevel == 0) then
		--说明没有角色
		strInfo = "没有选择角色";
		GameProduceLogin:ShowMessageBox(strInfo, "OK", "6");
		return ;
	end
	if (iLevel >= 1) then
		--如果大于10级
		if (iDelTime >= 11) then
			--说明还不能删除呢，出提示对话框
			strInfo = "删除申请已经提交" .. tostring(14 - iDelTime) .. "天了,请在删除角色3天后，14天以内登录游戏，到洛阳（268，46）找到关汉寿或者到大理（80，136）找到周仓确认。";
			GameProduceLogin:ShowMessageBox(strInfo, "OK", "6");
		elseif (iDelTime > 0) then
			--说明可以删除呢，出提示对话框
			strInfo = "请登录游戏，到洛阳（268，46）找到关汉寿或者到大理（80，136）找到周仓确认，即可永久删除。你必须没有帮会、结婚、开店、结拜、师徒关系才能删除。";
			GameProduceLogin:ShowMessageBox(strInfo, "OK", "5");
		else
			--说明要删除了，出现提示对话框
			strInfo = "你确定要将" .. tostring(iLevel) .. "级的角色#c00ff00" .. strName .. "#cffffff删除吗?";
			GameProduceLogin:ShowMessageBox(strInfo, "YesNo", "4");
		end
	else
		--直接出现提示，是否删除
		strInfo = "你确定要将" .. tostring(iLevel) .. "级的角色#c00ff00" .. strName .. "#cffffff删除吗?";
		GameProduceLogin:ShowMessageBox(strInfo, "YesNo", "7");
	end

end


---------------------------------------------------------------------------------------------
--
-- 返回到上一步
--				
function SelectRole_Return()
	
	GameProduceLogin:ExitToAccountInput_YesNo();
	--GameProduceLogin:ChangeToAccountInputDlgFromSelectRole();
end


---------------------------------------------------------------------------------------------------------------
--
--   刷新角色信息
--
function SelectRole_RefreshRoleInfo()
	
	-- 清空界面.
	SelectRole_ClearInfo();
	
	g_iCurRoleCount = GameProduceLogin:GetRoleCount();
	-- 得到人物的个数
	AxTrace(0, 0, "得到角色个数" .. tostring(g_iCurRoleCount));
	
	if (0 == g_iCurRoleCount) then
		
		return ;
	end ;
	
	for index = 0, g_iCurRoleCount - 1 do
		
		AxTrace(0, 0, "显示角色" .. tostring(index));
		SelectRole_GetRoleInfo(index);
	end
	
	-- 选择角色
	if (1 == g_bCreateSuccess) then
		
		-- 创建成功后
		g_iCurSelRole = g_iCurRoleCount;
		g_bCreateSuccess = 0;
	end
	
	for index = 1, g_iCurRoleCount do
		SelectRole_ShowSelRoleInfo(index);
	end

end


---------------------------------------------------------------------------------------------------------------
--
--   刷新角色信息
--
function SelectRole_GetRoleInfo(index)
	local strName;
	local iMenPai;
	local iLevel;
	local iDelTime;
	local strFaceImgName;
	strName, iMenPai, iLevel, iDelTime, strFaceImgName = GameProduceLogin:GetRoleInfo(index);
	-- 设置名字
	g_RoleName[index + 1] = strName;
	g_iMenPai[index + 1] = iMenPai;
	g_iLevel[index + 1] = iLevel;
	g_iDelTime[index + 1] = iDelTime;
	g_FaceImg[index + 1] = Lua_GetCharacterImage(strName)
end

---------------------------------------------------------------------------------------------------------------
--
--   清空角色信息.
--
function SelectRole_ClearInfo()
	for i = 1, 3 do
		g_RolName_Text[i]:SetText("");
		g_MenPai_Text[i]:SetText("");
		g_Level_Text[i]:SetText("");
		g_Delete_Text[i]:Hide();
		g_RolFace_Icon[i]:SetProperty("Image", "");
		g_HighLightBack[i]:Hide();
		g_CreateInfo_Text[i]:Show();
	end
end


---------------------------------------------------------------------------------------------------------------
--
--   选择角色1.
--
function SelectRole_SelectRole1()
	
	AxTrace(0, 0, " 选1");
	g_iCurSelRole = 1;
	if (g_iCurRoleCount < g_iCurSelRole) then
		
		AxTrace(0, 0, " 未选中一");
		SelectRole_TargetInfo_Name_Text:SetText("");
		SelectRole_TargetInfo_Menpai_Text:SetText("");
		SelectRole_TargetInfo_Level_Text:SetText("");
		return ;
	end
	SelectRole_HighLight();
	SelectRole_ShowSelRoleInfo(g_iCurSelRole);

end

---------------------------------------------------------------------------------------------------------------
--
--   选择角色2.
--
function SelectRole_SelectRole2()
	
	AxTrace(0, 0, " 选2");
	g_iCurSelRole = 2;
	if (g_iCurRoleCount < g_iCurSelRole) then
		
		SelectRole_TargetInfo_Name_Text:SetText("");
		SelectRole_TargetInfo_Menpai_Text:SetText("");
		SelectRole_TargetInfo_Level_Text:SetText("");
		return ;
	end
	
	SelectRole_ShowSelRoleInfo(g_iCurSelRole);
	SelectRole_HighLight();
end


---------------------------------------------------------------------------------------------------------------
--
--   选择角色3.
--
function SelectRole_SelectRole3()
	
	AxTrace(0, 0, " 选3");
	g_iCurSelRole = 3;
	if (g_iCurRoleCount < g_iCurSelRole) then
		
		SelectRole_TargetInfo_Name_Text:SetText("");
		SelectRole_TargetInfo_Menpai_Text:SetText("");
		SelectRole_TargetInfo_Level_Text:SetText("");
		return ;
	end
	
	SelectRole_ShowSelRoleInfo(g_iCurSelRole);
	SelectRole_HighLight();
end


---------------------------------------------------------------------------------------------------------------
--
--   通过索引, 选择角色
--
function SelectRole_ShowSelRoleInfo(index)
	
	if (g_iCurRoleCount < index or 0 >= index) then
		return ;
	end
	
	if (index < 1) then
		
		return ;
	end ;
	-- 显示名字
	AxTrace(0, 0, "show sel info index=" .. index);
	--SelectRole_TargetInfo_Name_Text:SetText(g_RoleName[index]:GetText());
	--added by dun.liu 2008-04-18
	g_RolName_Text[index]:SetText("" .. g_RoleName[index]);
	
	local Family = g_iMenPai[index];
	g_MenPai_Text[index]:SetText("#c00ff00门派:#cffffff" .. tintUserMenPai(Family));
	
	-- 显示等级
	g_Level_Text[index]:SetText("#c00ff00等级:#cffffff" .. tostring(g_iLevel[index]));
	
	if (tonumber(g_iDelTime[index]) > 0) then
		if (g_iDelTime[index] >= 11) then
			g_Delete_Text[index]:SetText("#c00ff00" .. (3 - (14 - g_iDelTime[index])) .. "天后可删除角色");
		else
			g_Delete_Text[index]:SetText("#c00ff00已可删除角色");
		end
		
		g_Delete_Text[index]:Show();
	else
		g_Delete_Text[index]:Hide();
	end
	-- 设为选择状态
	--g_BnSelCheck[index]:SetCheck(1);
	
	g_RolFace_Icon[index]:SetProperty("Image", g_FaceImg[index]);
	
	g_CreateInfo_Text[index]:Hide();
	if g_iLevel[index] == 0 then
		g_Level_Text[index]:SetText("#cFF0000该角色已被冻结！");
		g_MenPai_Text[index]:SetText("#cFF0000存在非法数据");
		SelectRole_Play:Disable()
		strInfo = "您的账号因您使用#c00ff00非法软件或篡改客户端#cffffff而导致角色存在非法数据，现该角色已被#c00ff00冻结#cffffff！#r#G请您绿色、健康游戏，不要使用非法软件！如有异议，请联系利群天龙运营团队！#r#G温馨提示：您的账户依然可以使用，请您新建角色来进行游戏！";
		GameProduceLogin:ShowMessageBox(strInfo, "OK", "5");
		g_Delete_Text[index]:Hide()
	end
end

function SelectRole_SelRole_MouseEnter(index)
	
	SelectRole_Info:SetText("选择当前登录角色");
end

function SelectRole_MouseLeave()
	
	SelectRole_Info:SetText("");
end

function SelectRole_Play_MouseEnter()
	
	SelectRole_Info:SetText("进入游戏");
end

function SelectRole_Create_MouseEnter()
	
	SelectRole_Info:SetText("创建一个新角色");
end

function SelectRole_Delete_MouseEnter()
	
	SelectRole_Info:SetText("删除一个已有角色");
end

function SelectRole_Last_MouseEnter()
	
	SelectRole_Info:SetText("返回到账号登录界面");    --帐号  to  账号
end;

function SelectRole_Role_Modle_TurnRightBegin(index)
	
	if (1 == index) then
		
		SelectRole_Role1_Model:RotateBegin(0.3);
	
	elseif (2 == index) then
		
		SelectRole_Role2_Model:RotateBegin(0.3);
	
	elseif (3 == index) then
		
		SelectRole_Role3_Model:RotateBegin(0.3);
	
	end ;

end;

function SelectRole_Role_Modle_TurnRightEnd(index)
	
	if (1 == index) then
		
		SelectRole_Role1_Model:RotateEnd();
	
	elseif (2 == index) then
		
		SelectRole_Role2_Model:RotateEnd();
	
	elseif (3 == index) then
		
		SelectRole_Role3_Model:RotateEnd();
	
	end ;

end;

function SelectRole_Role_Modle_TurnLeftBegin(index)
	
	if (1 == index) then
		
		SelectRole_Role1_Model:RotateBegin(-0.3);
	
	elseif (2 == index) then
		
		SelectRole_Role2_Model:RotateBegin(-0.3);
	
	elseif (3 == index) then
		
		SelectRole_Role3_Model:RotateBegin(-0.3);
	
	end ;

end;

function SelectRole_Role_Modle_TurnLeftEnd(index)
	
	if (1 == index) then
		
		SelectRole_Role1_Model:RotateEnd();
	
	elseif (2 == index) then
		
		SelectRole_Role2_Model:RotateEnd();
	
	elseif (3 == index) then
		
		SelectRole_Role3_Model:RotateEnd();
	
	end ;

end;

function SelectRole_Role_Modle_TurnRight(start)
	--向右旋转开始
	if (start == 1) then
		--GameProduceLogin:ModelRotBegin(0.3)
		GameProduceLogin:ModelRotBegin(1.0)   --每秒一圈
		--向右旋转结束
	else
		GameProduceLogin:ModelRotEnd(0.0)
	end

end

function SelectRole_Role_Modle_TurnLeft(start)
	if (start == 1) then
		--GameProduceLogin:ModelRotBegin(-0.3)
		GameProduceLogin:ModelRotBegin(-1.0)   --每秒-1圈
	else
		GameProduceLogin:ModelRotEnd(0.0)
	end

end

function SelectRole_Modle_ZoomOut(start)
	if (start == 1) then
		GameProduceLogin:ModelZoom(-1.0)
	else
		GameProduceLogin:ModelZoom(0.0)
	end

end

function SelectRole_Modle_ZoomIn(start)
	if (start == 1) then
		GameProduceLogin:ModelZoom(1.0)
	else
		GameProduceLogin:ModelZoom(0.0)
	end

end

function SelectRole_DoubleClicked(index)
	local strName;
	local iMenPai;
	local iLevel;
	local iDelTime;
	local strInfo;
	local strImgName;
	strName
	, iMenPai
	, iLevel
	, iDelTime
	, strImgName = GameProduceLogin:GetRoleInfo(index);
	if (iLevel == 0) then
		--说明没有角色
		SelectRole_CreateRole();
	else
		if (g_iCurRoleCount <= index or 0 > index) then
			return ;
		end
		
		if (g_iCurSelRole ~= index + 1) then
			g_iCurSelRole = index + 1;
		end
		
		SelectRole_EnterGame();
	end
end
--/////////////////////////////登录角色数据存储系统
function Lua_SetCharacterImage(nName, image)
	if nName == nil or nName == "" or image == nil or image == "" then
		return
	end
	local handle = io.open("./Character_Frame.cfg", "r");
	local nNowCharData = {};
	if handle ~= nil then
		for l in handle:lines() do
			local nPos_1, nPos_2, nCharName, nCharImage = string.find(l, "(.*)\t(.*)");
			if nPos_1 ~= nil and nPos_2 ~= nil then
				table.insert(nNowCharData, { nCharName, nCharImage });
			end
		end
		handle:close();
	end
	local nIsInsertNew = 0;
	for i = 1, table.getn(nNowCharData) do
		if nNowCharData[i][1] == nName then
			nNowCharData[i][2] = image;
			nIsInsertNew = 1;
			break ;
		end
	end
	if nIsInsertNew == 0 then
		table.insert(nNowCharData, { nName, image });
	end
	local nFinalData = "";
	for i = 1, table.getn(nNowCharData) do
		nFinalData = nFinalData .. nNowCharData[i][1] .. "\t" .. nNowCharData[i][2] .. "\n";
	end
	handle = io.open("./Character_Frame.cfg", "w");
	handle:write(nFinalData);
	handle:close();
end

--角色头像信息读取
--2020-06-20 01:33:51 信手斬龍（原极致）
function Lua_GetCharacterImage(nName)
	local nDefaultCharImage = "set:GirlProtagonist image:GirlProtagonist_1";
	if nName == nil or nName == "" then
		return nDefaultCharImage
	end
	local handle = io.open("./Character_Frame.cfg", "r")
	local nFinalData
	if handle ~= nil then
		for l in handle:lines() do
			if l ~= nil then
				local nPos_1, nPos_2, nCharName, nImage = string.find(l, "(.*)\t(.*)");
				if nPos_1 ~= nil and nPos_2 ~= nil then
					if nCharName ~= nil and nCharName == nName then
						nFinalData = nImage;
						break
					end
				end
			end
		end
		handle:close()
		if nFinalData ~= nil then
			return nFinalData
		else
			return nDefaultCharImage
		end
	else
		return nDefaultCharImage
	end
end

function SelectRole_MouseEnterCharArea(index)
	local strName;
	local iMenPai;
	local iLevel;
	local iDelTime;
	local strInfo;
	local strImgName;
	strName
	, iMenPai
	, iLevel
	, iDelTime
	, strImgName = GameProduceLogin:GetRoleInfo(index);
	if (iLevel == 0) then
		--说明没有角色
		SelectRole_Info:SetText("#{DLJM_XML_5}");
	else
		SelectRole_Info:SetText("#{DLJM_XML_6}");
	end
end

function SelectRole_HighLight()
	if (g_iCurRoleCount < g_iCurSelRole or 0 >= g_iCurSelRole) then
		return ;
	end
	
	for i = 1, 3 do
		g_HighLightBack[i]:Hide();
	end
	g_HighLightBack[g_iCurSelRole]:Show();
end
