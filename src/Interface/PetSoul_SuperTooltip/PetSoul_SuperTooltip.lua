
local g_pos1;
local g_pos2;
local g_TitleColor = "#cff6600";
local g_ExplainColor = "#cFFCC00";
local g_PurpleColor = "#c9107e1";
local g_BlueColor   = "#c00ccff";
local g_YellowColor = "#cfeff95";
local g_GreenColor	= "#c5bc257";
local g_Stars;		
local g_PetSoul_Index = 0;	
local g_PetSoul_BloodRank = 0;	
local g_PetSoul_HandbookSelId = 1;	
local g_PetSoul_HandbookBloodLevel = 1;	
local g_PetSoul_Other = 0;


function PetSoul_SuperTooltip_PreLoad()

	this:RegisterEvent("SHOW_PETSOUL_SUPERTOOLTIP");
	this:RegisterEvent("UPDATE_PETSOUL_SUPERTOOLTIP");
	
	
	this:RegisterEvent("SHOW_PETSOUL_SUPERTOOLTIP_HANDBOOK");
	this:RegisterEvent("UPDATE_PETSOUL_SUPERTOOLTIP_HANDBOOK");
	this:RegisterEvent("UI_COMMAND");
	
end

function PetSoul_SuperTooltip_OnLoad()

	g_Stars={
				PetSoul_SuperTooltip_StaticPart_Star1,
				PetSoul_SuperTooltip_StaticPart_Star2,
				PetSoul_SuperTooltip_StaticPart_Star3,
				PetSoul_SuperTooltip_StaticPart_Star4,
				PetSoul_SuperTooltip_StaticPart_Star5,
				PetSoul_SuperTooltip_StaticPart_Star6,
				PetSoul_SuperTooltip_StaticPart_Star7,
				PetSoul_SuperTooltip_StaticPart_Star8,
				PetSoul_SuperTooltip_StaticPart_Star9,
		};
		
	for i=1,9 do
		g_Stars[i]:Hide();
	end;
	
end										

function PetSoul_SuperTooltip_OnEvent(event)

	if (event == "UI_COMMAND" and tonumber(arg0) == 20220525 ) then
		g_PetSoul_Index = tonumber(arg1)
		g_PetSoul_BloodRank = tonumber(arg2)
		if(PetSoul_SuperTooltip_Update(tonumber(arg5))==1) then
			g_pos1, g_pos2 = _PetSoul_SuperTooltip_:PositionSelf(0,0,arg3,arg4);
			this:Show();
		end;
	end
	if (event == "UI_COMMAND" and tonumber(arg0) == 210220525 ) then
		this:Hide();
	end	
	
	
	if(event == "UPDATE_PETSOUL_SUPERTOOLTIP") then
		if(this:IsVisible()) then
			PetSoul_SuperTooltip_Update(1);
			_PetSoul_SuperTooltip_:PositionSelf(0, 0, g_pos1, g_pos2);
			return;
		end;
	end	
	
	
	if(event == "UPDATE_PETSOUL_SUPERTOOLTIP_HANDBOOK") then
		if(this:IsVisible()) then
			PetSoul_SuperTooltip_Update(2);
			_PetSoul_SuperTooltip_:PositionSelf(0, 0, g_pos1, g_pos2);
			return;
		end;
	end
	
end

function PetSoul_SuperTooltip_Update(showtype)

	-- 先清空以前显示的文字
	PetSoul_SuperTooltip_ClearText();
		
	local typeDesc = nil
	local szPropertys = nil
	local szTitle, szIconName, szExplain1, szExplain2
	-- PushDebugMessage("showtype   "..showtype)
	if showtype == 2 then
		szTitle, szIconName, szExplain1, szExplain2 = LuaFnGetPetSoulPossSkillInfo(g_PetSoul_Index,g_PetSoul_BloodRank);	
	elseif showtype == 1 then
		szIconName,szExplain1,szTitle,szExplain2 = LuaFnEnumPetSoulSkillActionOnPet(g_PetSoul_Index,g_PetSoul_BloodRank)
	end
	----------------------------------------------------------------------
	--显示静态头
	local toDisplay = "";
		
	if(szTitle ~= "" and szIconName ~= "")then
		toDisplay = toDisplay .."PetSoul_SuperTooltip_PageHeader";
	end
	
	--加上类型描述
	if( typeDesc ~= nil) then 
		toDisplay = toDisplay .. ";PetSoul_SuperTooltip_ShortDesc";
	end
	
	--属性
	if(szPropertys ~= nil) then 
		toDisplay = toDisplay .. ";PetSoul_SuperTooltip_Property";
	end

	--详细解释
	if(szExplain1 ~= "" and szExplain2 ~= "") then 
		toDisplay = toDisplay .. ";PetSoul_SuperTooltip_Explain";
	end

	--显示组件内容
	if(toDisplay=="") then
		this:Hide();
		return 0;
	end;
	
	--AxTrace( 8,0,toDisplay );
	_PetSoul_SuperTooltip_:SetProperty("PageElements",  toDisplay);
		
	----------------------------------------------------------------------
	--显示新的内容
	PetSoul_SuperTooltip_StaticPart_Title:SetText(g_TitleColor..szTitle);
	
	--PetSoul_SuperTooltip_StaticPart_Item1:SetText(SuperTooltips:GetDesc1());
	--PetSoul_SuperTooltip_StaticPart_Item2:SetText(SuperTooltips:GetDesc2());
	--PetSoul_SuperTooltip_StaticPart_Item3:SetText(SuperTooltips:GetDesc3());
	--PetSoul_SuperTooltip_StaticPart_Item4:SetText(SuperTooltips:GetDesc4());
		
	local sPos,_ = string.find(szIconName," ");
	local IconImageSet = string.sub(szIconName, 5, sPos-1);
	local IconIamge = string.sub(szIconName, sPos+7)
	PetSoul_SuperTooltip_StaticPart_Icon:SetImage(IconIamge);
	
	--PetSoul_SuperTooltip_ShortDesc_Text:SetText(typeDesc);
	
	local szExplain = ""
	szExplain = g_ExplainColor..szExplain1
	if showtype ~= 1 then
		szExplain = g_ExplainColor..szExplain1.."#r"..szExplain2
		szExplain = szExplain.."#r".."#{SHXT_20211230_218}"	
	end
	PetSoul_SuperTooltip_Explain:SetText(szExplain);		
	--AxTrace( 8,0,"Show tooltip  "..szExplain);
	
	return 1;
		
end

-------------------------------------------------------------------------------------------------------------------------------
--
-- 清空显示文本
--
function PetSoul_SuperTooltip_ClearText()
		
	PetSoul_SuperTooltip_StaticPart_Title:SetText("");
	PetSoul_SuperTooltip_StaticPart_Item1:SetText("");
	PetSoul_SuperTooltip_StaticPart_Item2:SetText("");
	PetSoul_SuperTooltip_StaticPart_Item3:SetText("");
	PetSoul_SuperTooltip_StaticPart_Item4:SetText("");
		
	local starNum=9
	for i=1,starNum do
		g_Stars[i]:Hide();
	end;
		
	PetSoul_SuperTooltip_Explain:SetText("");
	PetSoul_SuperTooltip_Property:SetText("");
	PetSoul_SuperTooltip_Manufacturer:SetText("");
		
end
