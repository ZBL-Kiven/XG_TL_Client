--潇湘添加
local g_Anniversary_LevelUp_GiftsIcons = { }   --物品UI
local g_Anniversary_LevelUp_Gifts = {}

function Anniversary_PreLoad()
this:RegisterEvent("UI_COMMAND");
end


function Anniversary_OnLoad()
	g_Anniversary_LevelUp_GiftsIcons =
	{
	[1] = {Anniversary_Page3_TextBK_Icon1,}, 
	[2] = {Anniversary_Page3_TextBK_Icon2,}, 
	[3] = {Anniversary_Page3_TextBK_Icon3,}, 
	[4] = {Anniversary_Page3_TextBK_Icon4,},
	[5] = {Anniversary_Page3_TextBK_Icon5,},
	}
	
	g_Anniversary_LevelUp_Gifts = {
	[1] = {39901005},
	[2] = {20501007},
	[3] = {20502007},
	[4] = {20800013},
	[5] = {30008014},
	}
	
end

function Anniversary_OnEvent(event)
	  if ( event == "UI_COMMAND" and tonumber(arg0) == 2000000126)  then
       Anniversary_Show()
	   Anniversary_LevelUp_Click_Button()
	 end
end


function Anniversary_Show()
this:Show();
end

function Anniversary_Close()
this:Hide()
end


function Anniversary_wukong()
	local cardNum = Anniversary_Page_NumericalValue:GetText();
	if(0 == string.len(cardNum)) then
		PushDebugMessage("请正确填写推广码");
	return; end
		if string.len(cardNum) ~= 8 then
	PushDebugMessage("推广码错误");
			return
		end
local n2 = tonumber(string.sub(cardNum,2,2))
local n4 = tonumber(string.sub(cardNum,4,4))
local n6 = tonumber(string.sub(cardNum,6,6))
if n2 == nil or n4 == nil or n6 == nil then
	PushDebugMessage("推广码错误");	return
end
Clear_XSCRIPT();
Set_XSCRIPT_Function_Name( "XiaoXiang_yaoqingma"  )
Set_XSCRIPT_ScriptID(tonumber(928775))
Set_XSCRIPT_Parameter(0, tonumber(20000))
Set_XSCRIPT_Parameter(1, tonumber(cardNum))
Set_XSCRIPT_ParamCount(2);
Send_XSCRIPT();

end

function Anniversary_LevelUp_Click_Button()
	for i=1 ,5 do
	for j=1, 1 do 
		if g_Anniversary_LevelUp_Gifts[i][j] ~= nil then
			   local PrizeAction = GemMelting:UpdateProductAction(g_Anniversary_LevelUp_Gifts[i][j])	
		     if PrizeAction:GetID() ~= 0 then
			 g_Anniversary_LevelUp_GiftsIcons[i][j]:SetActionItem(PrizeAction:GetID());
			else
			 g_Anniversary_LevelUp_GiftsIcons[i][j]:SetActionItem(-1)
		   end
		else
		g_Anniversary_LevelUp_GiftsIcons[i][j]:Hide()
		end
	end
end
end