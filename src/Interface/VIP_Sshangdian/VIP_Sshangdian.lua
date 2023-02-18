
local g_VIP_Sshangdian_Frame_UnifiedPosition;


function VIP_Sshangdian_PreLoad()
	this:RegisterEvent("UI_COMMAND");
		-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("SCENE_TRANSED")
	this:RegisterEvent("UPDATE_YUANBAO");
end

local bdxdaoju = -1

local fenzu = 1
local fenlei = 1



local VIPfenzu = {} --分组
local VIPfenlei = {} --分类

local VIPshangpin = {} --商品
local VIPshangpinming = {} --商品名
local VIPshangpinYB = {} --商品需要元宝



function VIP_Sshangdian_OnLoad()--载入
	--PushDebugMessage("34.！")--调试
	
	VIPfenzu[1]	 = VIP_Sshangdian_Button1
	--VIPfenzu[2]	 = VIP_Sshangdian_Button2
	--VIPfenzu[3]	 = VIP_Sshangdian_Button3
	--VIPfenzu[4]	 = VIP_Sshangdian_Button4
	--VIPfenzu[5]	 = VIP_Sshangdian_Button5
	--VIPfenzu[6]	 = VIP_Sshangdian_Button6
	--VIPfenzu[7]	 = VIP_Sshangdian_Button7
	--VIPfenzu[8]	 = VIP_Sshangdian_Button8
	--VIPfenzu[9]	 = VIP_Sshangdian_Button9
	--VIPfenzu[10]	 = VIP_Sshangdian_Button10
	
	--分类
	VIPfenlei[1]	 = VIP_Sshangdian_Button01
	VIPfenlei[2]	 = VIP_Sshangdian_Button02
	VIPfenlei[3]	 = VIP_Sshangdian_Button03
	VIPfenlei[4]	 = VIP_Sshangdian_Button04
	VIPfenlei[5]	 = VIP_Sshangdian_Button05
	VIPfenlei[6]	 = VIP_Sshangdian_Button06
	VIPfenlei[7]	 = VIP_Sshangdian_Button07
	VIPfenlei[8]	 = VIP_Sshangdian_Button08

	
	--商品
	VIPshangpin[1]	 = VIP_Sshangdian_Item1
	VIPshangpin[2]	 = VIP_Sshangdian_Item2
	VIPshangpin[3]	 = VIP_Sshangdian_Item3
	VIPshangpin[4]	 = VIP_Sshangdian_Item4
	VIPshangpin[5]	 = VIP_Sshangdian_Item5
	VIPshangpin[6]	 = VIP_Sshangdian_Item6
	VIPshangpin[7]	 = VIP_Sshangdian_Item7
	VIPshangpin[8]	 = VIP_Sshangdian_Item8
	VIPshangpin[9]	 = VIP_Sshangdian_Item9
	VIPshangpin[10]	 = VIP_Sshangdian_Item10
	VIPshangpin[11]	 = VIP_Sshangdian_Item11
	VIPshangpin[12]	 = VIP_Sshangdian_Item12
	VIPshangpin[13]	 = VIP_Sshangdian_Item13
	VIPshangpin[14]	 = VIP_Sshangdian_Item14
	VIPshangpin[15]	 = VIP_Sshangdian_Item15
	VIPshangpin[16]	 = VIP_Sshangdian_Item16
	VIPshangpin[17]	 = VIP_Sshangdian_Item17
	VIPshangpin[18]	 = VIP_Sshangdian_Item18
	VIPshangpin[19]	 = VIP_Sshangdian_Item19
	VIPshangpin[20]	 = VIP_Sshangdian_Item20
	VIPshangpin[21]	 = VIP_Sshangdian_Item21
	VIPshangpin[22]	 = VIP_Sshangdian_Item22
	VIPshangpin[23]	 = VIP_Sshangdian_Item23
	VIPshangpin[24]	 = VIP_Sshangdian_Item24
	VIPshangpin[25]	 = VIP_Sshangdian_Item25
	VIPshangpin[26]	 = VIP_Sshangdian_Item26
	VIPshangpin[27]	 = VIP_Sshangdian_Item27
	VIPshangpin[28]	 = VIP_Sshangdian_Item28
	VIPshangpin[29]	 = VIP_Sshangdian_Item29
	VIPshangpin[30]	 = VIP_Sshangdian_Item30
	
	--商品名称
	VIPshangpinming[1]	 = VIP_Sshangdian_ItemInfo1_Text	
	VIPshangpinming[2]	 = VIP_Sshangdian_ItemInfo2_Text	
	VIPshangpinming[3]	 = VIP_Sshangdian_ItemInfo3_Text	
	VIPshangpinming[4]	 = VIP_Sshangdian_ItemInfo4_Text	
	VIPshangpinming[5]	 = VIP_Sshangdian_ItemInfo5_Text	
	VIPshangpinming[6]	 = VIP_Sshangdian_ItemInfo6_Text	
	VIPshangpinming[7]	 = VIP_Sshangdian_ItemInfo7_Text	
	VIPshangpinming[8]	 = VIP_Sshangdian_ItemInfo8_Text	
	VIPshangpinming[9]	 = VIP_Sshangdian_ItemInfo9_Text	
	VIPshangpinming[10]	 = VIP_Sshangdian_ItemInfo10_Text	
	VIPshangpinming[11]	 = VIP_Sshangdian_ItemInfo11_Text	
	VIPshangpinming[12]	 = VIP_Sshangdian_ItemInfo12_Text	
	VIPshangpinming[13]	 = VIP_Sshangdian_ItemInfo13_Text	
	VIPshangpinming[14]	 = VIP_Sshangdian_ItemInfo14_Text	
	VIPshangpinming[15]	 = VIP_Sshangdian_ItemInfo15_Text	
	VIPshangpinming[16]	 = VIP_Sshangdian_ItemInfo16_Text	
	VIPshangpinming[17]	 = VIP_Sshangdian_ItemInfo17_Text	
	VIPshangpinming[18]	 = VIP_Sshangdian_ItemInfo18_Text	
	VIPshangpinming[19]	 = VIP_Sshangdian_ItemInfo19_Text	
	VIPshangpinming[20]	 = VIP_Sshangdian_ItemInfo20_Text	
	VIPshangpinming[21]	 = VIP_Sshangdian_ItemInfo21_Text	
	VIPshangpinming[22]	 = VIP_Sshangdian_ItemInfo22_Text	
	VIPshangpinming[23]	 = VIP_Sshangdian_ItemInfo23_Text	
	VIPshangpinming[24]	 = VIP_Sshangdian_ItemInfo24_Text	
	VIPshangpinming[25]	 = VIP_Sshangdian_ItemInfo25_Text	
	VIPshangpinming[26]	 = VIP_Sshangdian_ItemInfo26_Text	
	VIPshangpinming[27]	 = VIP_Sshangdian_ItemInfo27_Text	
	VIPshangpinming[28]	 = VIP_Sshangdian_ItemInfo28_Text	
	VIPshangpinming[29]	 = VIP_Sshangdian_ItemInfo29_Text	
	VIPshangpinming[30]	 = VIP_Sshangdian_ItemInfo30_Text	
	
	--商品所需货币额度
	VIPshangpinYB[1]	 = VIP_Sshangdian_ItemInfo1_GB
	VIPshangpinYB[2]	 = VIP_Sshangdian_ItemInfo2_GB
	VIPshangpinYB[3]	 = VIP_Sshangdian_ItemInfo3_GB
	VIPshangpinYB[4]	 = VIP_Sshangdian_ItemInfo4_GB
	VIPshangpinYB[5]	 = VIP_Sshangdian_ItemInfo5_GB
	VIPshangpinYB[6]	 = VIP_Sshangdian_ItemInfo6_GB
	VIPshangpinYB[7]	 = VIP_Sshangdian_ItemInfo7_GB
	VIPshangpinYB[8]	 = VIP_Sshangdian_ItemInfo8_GB
	VIPshangpinYB[9]	 = VIP_Sshangdian_ItemInfo9_GB
	VIPshangpinYB[10]	 = VIP_Sshangdian_ItemInfo10_GB
	VIPshangpinYB[11]	 = VIP_Sshangdian_ItemInfo11_GB
	VIPshangpinYB[12]	 = VIP_Sshangdian_ItemInfo12_GB
	VIPshangpinYB[13]	 = VIP_Sshangdian_ItemInfo13_GB
	VIPshangpinYB[14]	 = VIP_Sshangdian_ItemInfo14_GB
	VIPshangpinYB[15]	 = VIP_Sshangdian_ItemInfo15_GB
	VIPshangpinYB[16]	 = VIP_Sshangdian_ItemInfo16_GB
	VIPshangpinYB[17]	 = VIP_Sshangdian_ItemInfo17_GB
	VIPshangpinYB[18]	 = VIP_Sshangdian_ItemInfo18_GB
	VIPshangpinYB[19]	 = VIP_Sshangdian_ItemInfo19_GB
	VIPshangpinYB[20]	 = VIP_Sshangdian_ItemInfo20_GB
	VIPshangpinYB[21]	 = VIP_Sshangdian_ItemInfo21_GB
	VIPshangpinYB[22]	 = VIP_Sshangdian_ItemInfo22_GB
	VIPshangpinYB[23]	 = VIP_Sshangdian_ItemInfo23_GB
	VIPshangpinYB[24]	 = VIP_Sshangdian_ItemInfo24_GB
	VIPshangpinYB[25]	 = VIP_Sshangdian_ItemInfo25_GB
	VIPshangpinYB[26]	 = VIP_Sshangdian_ItemInfo26_GB
	VIPshangpinYB[27]	 = VIP_Sshangdian_ItemInfo27_GB
	VIPshangpinYB[28]	 = VIP_Sshangdian_ItemInfo28_GB
	VIPshangpinYB[29]	 = VIP_Sshangdian_ItemInfo29_GB
	VIPshangpinYB[30]	 = VIP_Sshangdian_ItemInfo30_GB
	
	
	
	
	-- 保存界面的默认相对位置
   g_VIP_Sshangdian_Frame_UnifiedPosition=VIP_Sshangdian_Frame:GetProperty("UnifiedPosition");
end

function VIP_Sshangdian_ResetPos()-- 游戏窗口尺寸发生了变化
  VIP_Sshangdian_Frame:SetProperty("UnifiedPosition", g_VIP_Sshangdian_Frame_UnifiedPosition);
end



function VIP_Sshangdian_Split(szFullString, szSeparator)
	local nFindStartIndex = 1    
	local nSplitIndex = 1    
	local nSplitArray = {}    
	while true do    
		local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)    
		if not nFindLastIndex then    
			nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))    
			break    
		end    
		nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)    
		nFindStartIndex = nFindLastIndex + string.len(szSeparator)    
		nSplitIndex = nSplitIndex + 1    
	end
	return nSplitArray
end



function VIP_Sshangdian_qingchu()
	for i=1,table.getn(VIPfenlei) do
		VIPfenlei[i]:Hide()--隐藏
	end
	for i=1,table.getn(VIPshangpin) do --删除商品
		VIPshangpin[i]:SetActionItem(-1); --显示物品
		VIPshangpinming[i]:Hide()
		VIPshangpinYB[i]:Hide()
	end
	VIP_Sshangdian_OK:Disable();--黑掉购买
	
	if bdxdaoju ~= -1 then
		VIPshangpin[bdxdaoju]:SetPushed(0);--点选
	end
	--VIP_Sshangdian_qinglitu(nIndex) --清理点选图片
end









local szSeparator=","
local shuzuFL = {}
local shuzuBZ = {"元宝","绑定元宝","",""}


local shuzuSP = {}
local shuzuJG = {}

local shuzuFLA = -1
local shuzuSPA = -1
local shuzuJGA = -1



function VIP_Sshangdian_OnEvent(event)
	if event == "UI_COMMAND"  and tonumber(arg0) == 2017031008 then   --UI进入服务端再打开
		this:Hide()--隐藏主窗口
		VIP_Sshangdian_dakaiUI()
	elseif event == "UI_COMMAND"  and tonumber(arg0) == 2017031110 then   ---服务端回调打开UI
		--VIP_Sshangdian_Yuanbao : SetCheck(0)
		--VIP_Sshangdian_Gongzi : SetCheck(0)
		VIP_Sshangdian_Gold : SetCheck(1)
		--PushDebugMessage(fenzu.."!~=~!"..fenlei)--调试
		VIP_Sshangdian_Frame_Texta1:SetText ("绑定元宝"..tostring(Player:GetData("ZENGDIAN")))
		VIP_Sshangdian_qingchu()
		
		
		if shuzuFLA ~= Get_XParam_STR(0) then
			shuzuFLA = Get_XParam_STR(0)
		end
		if shuzuSPA ~= Get_XParam_STR(2) then
			shuzuSPA = Get_XParam_STR(2)
		end
		if shuzuJGA ~= Get_XParam_STR(3) then
			shuzuJGA = Get_XParam_STR(3)
		end

		
		if shuzuFLA ~= nil then
			shuzuFL = VIP_Sshangdian_Split(shuzuFLA, szSeparator) --将文本打成数组
		end
		for i=1,table.getn(shuzuFL) do
			VIPfenlei[i]:SetText (shuzuFL[i])
			VIPfenlei[i]:Show()
		end
		

		if shuzuSPA ~= nil then
			shuzuSP = VIP_Sshangdian_Split(shuzuSPA, szSeparator) --将文本打成数组
		end

		if shuzuJGA ~= nil then
			shuzuJG = VIP_Sshangdian_Split(shuzuJGA, szSeparator) --将文本打成数组
		end

		
		
		for i=1,table.getn(shuzuSP) do
			if tonumber(shuzuSP[i]) > 10000000 then
				local PrizeAction = GemMelting:UpdateProductAction(tonumber(shuzuSP[i]))
				VIPshangpin[i]:SetActionItem(PrizeAction:GetID()); --显示物品
				VIPshangpinming[i]:SetText ("#{_ITEM"..tonumber(shuzuSP[i]).."}")
				VIPshangpinming[i]:Show()
				VIPshangpinYB[i]:SetText (shuzuBZ[tonumber(Get_XParam_STR(1))].."："..shuzuJG[i])
				VIPshangpinYB[i]:Show()
			end
		end
		this:Show();
		
		
	elseif (event == "UPDATE_YUANBAO" and this:IsVisible() ) then
		VIP_Sshangdian_Frame_Texta1:SetText ("绑定元宝"..tostring(Player:GetData("ZENGDIAN")))

	elseif( event == "ADJEST_UI_POS" ) then
		VIP_Sshangdian_ResetPos()
	elseif( event == "VIEW_RESOLUTION_CHANGED" ) then
		VIP_Sshangdian_ResetPos()
	elseif (event == "SCENE_TRANSED") then
		this:Hide()--隐藏主窗口
	end
end


function VIP_Sshangdian_qinglitu(nIndex) --清理点选图片
	for i=1,table.getn(VIPshangpin) do
		VIPshangpin[i]:SetPushed(0);--清空点选
	end
end



function VIP_Sshangdian_GoodButton_Clicked(nIndex) --点选图片
	--VIP_Sshangdian_qinglitu(nIndex)
	if bdxdaoju ~= nIndex then
		if bdxdaoju ~= -1 then
			VIPshangpin[bdxdaoju]:SetPushed(0);--点选
		end
		bdxdaoju = nIndex
	end
	VIPshangpin[nIndex]:SetPushed(1);--点选
	VIP_Sshangdian_OK:Enable(); --开购买
	VIP_Sshangdian_Moral_Value:SetText(1);
end

function VIP_Sshangdian_UpdateList(nIndex) --分组
	
	if fenzu ~= nIndex then
		VIPfenzu[fenzu] : SetCheck(0)
		fenzu = nIndex
		VIPfenlei[fenlei] : SetCheck(0)
		fenlei = 1
		VIPfenlei[fenlei] : SetCheck(1)
	end
	VIPfenzu[nIndex] : SetCheck(1)
	VIP_Sshangdian_dakaiUI()--向服务端请求
end




function VIP_Sshangdian_UpdateShop(nIndex) --分类
	
	if fenlei ~= nIndex then
		VIPfenlei[fenlei] : SetCheck(0)
		fenlei = nIndex
	end
	VIPfenlei[nIndex] : SetCheck(1)
	VIP_Sshangdian_dakaiUI()--向服务端请求
end
function VIP_Sshangdian_dakaiUI() --向服务端请求
	-- 执行脚本
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "VipShangChen" ); 	-- 脚本函数名称
		Set_XSCRIPT_ScriptID( 920023 );						-- 脚本编号
		Set_XSCRIPT_Parameter( 0, 1 );	-- 参数1
		Set_XSCRIPT_Parameter( 1, fenzu );	-- 参数1
		Set_XSCRIPT_Parameter( 2, fenlei ); -- 参数2
		Set_XSCRIPT_ParamCount( 3 ); -- 参数个数
	Send_XSCRIPT()
end



function VIP_Sshangdian_OK_Clicked() --购买
	local str = VIP_Sshangdian_Moral_Value : GetText(); 
	-- 执行脚本
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "VipShangChen" ); 	-- 脚本函数名称
		Set_XSCRIPT_ScriptID( 920023 );						-- 脚本编号
		Set_XSCRIPT_Parameter( 0, 2 );	-- 参数1
		Set_XSCRIPT_Parameter( 1, fenzu );	-- 参数1
		Set_XSCRIPT_Parameter( 2, fenlei ); -- 参数2
		Set_XSCRIPT_Parameter( 3, bdxdaoju ); -- 参数2
		Set_XSCRIPT_Parameter( 4, tonumber( str ) ); -- 参数2
		Set_XSCRIPT_ParamCount( 5 ); -- 参数个数
	Send_XSCRIPT()
end





function VIP_Sshangdian_Count_Change() --计算消费
	local str = VIP_Sshangdian_Moral_Value : GetText(); 
	local strNumber = 0;
	if ( str == nil ) then
		return;
	elseif( str == "" ) then
		strNumber = 1;
	else
		if tonumber( str ) > 1000 then
			strNumber = 1000
			PushDebugMessage("最大支持一次购买"..strNumber.."个商品")--调试
		else
			strNumber = tonumber( str );
		end
	end
	str = tostring( strNumber );
	VIP_Sshangdian_Moral_Value:SetTextOriginal( str );
	--YuanbaoExchange_Text3 : SetText("可兑换到游戏币数量："..tostring( Exchange_Rate * strNumber  ) )
end

--选项
function VIP_Sshangdian_ZHIZUNVIP(nIndex) --确定
	VIP_Sshangdian_Close()
	if nIndex == 0 then
		PushEvent("UI_COMMAND",2017031220,0)
	end
	if nIndex == 1 then
		PushEvent("UI_COMMAND",2017031220,1)
	end
end

function VIP_Sshangdian_Close() --关闭
	this:Hide()--隐藏主窗口
end

