
--×î¶àÏÔÊ¾µÄÐ§¹ûÊýÁ¿
local IMPACT_NUM = 60;
mypet_buff = {0,   0,0,0,0,  0,0,0,0,  0,0}
mypet_str = {"ÑªÉÏÏÞ +", "±ù¹¥»÷ +","»ð¹¥»÷ +","Ðþ¹¥»÷ +","¶¾¹¥»÷ +","±ù¿¹ÐÔ +","»ð¿¹ÐÔ +","Ðþ¿¹ÐÔ +","¶¾¿¹ÐÔ +" ,"ÃüÖÐ +","ÉÁ±Ü +"   }

local IMPACT_DESC = {};
IMPACT_DESC[1] = 0;
IMPACT_DESC[2] = 0;
IMPACT_DESC[3] = 0;
IMPACT_DESC[4] = 0;
IMPACT_DESC[5] = 0;
IMPACT_DESC[6] = 0;
IMPACT_DESC[7] = 0;
IMPACT_DESC[8] = 0;
IMPACT_DESC[9] = 0;
IMPACT_DESC[10] = 0;
IMPACT_DESC[11] = 0;
IMPACT_DESC[12] = 0;
IMPACT_DESC[13] = 0;
IMPACT_DESC[14] = 0;
IMPACT_DESC[15] = 0;
IMPACT_DESC[16] = 0;
IMPACT_DESC[17] = 0;
IMPACT_DESC[18] = 0;
IMPACT_DESC[19] = 0;
IMPACT_DESC[20] = 0;
IMPACT_DESC[21] = 0;
IMPACT_DESC[22] = 0;
IMPACT_DESC[23] = 0;
IMPACT_DESC[24] = 0;
IMPACT_DESC[25] = 0;
IMPACT_DESC[26] = 0;
IMPACT_DESC[27] = 0;
IMPACT_DESC[28] = 0;
IMPACT_DESC[29] = 0;
IMPACT_DESC[30] = 0;
IMPACT_DESC[31] = 0;
IMPACT_DESC[32] = 0;
IMPACT_DESC[33] = 0;
IMPACT_DESC[34] = 0;
IMPACT_DESC[35] = 0;
IMPACT_DESC[36] = 0;
IMPACT_DESC[37] = 0;
IMPACT_DESC[38] = 0;
IMPACT_DESC[39] = 0;
IMPACT_DESC[40] = 0;
IMPACT_DESC[41] = 0;
IMPACT_DESC[42] = 0;
IMPACT_DESC[43] = 0;
IMPACT_DESC[44] = 0;
IMPACT_DESC[45] = 0;
IMPACT_DESC[46] = 0;
IMPACT_DESC[47] = 0;
IMPACT_DESC[48] = 0;
IMPACT_DESC[49] = 0;
IMPACT_DESC[50] = 0;
IMPACT_DESC[51] = 0;
IMPACT_DESC[52] = 0;
IMPACT_DESC[53] = 0;
IMPACT_DESC[54] = 0;
IMPACT_DESC[55] = 0;
IMPACT_DESC[56] = 0;
IMPACT_DESC[57] = 0;
IMPACT_DESC[58] = 0;
IMPACT_DESC[59] = 0;
IMPACT_DESC[60] = 0;




local PlayerImpactFrame_TimeCtrl = {};
PlayerImpactFrame_TimeCtrl[1] = 0;
PlayerImpactFrame_TimeCtrl[2] = 0;
PlayerImpactFrame_TimeCtrl[3] = 0;
PlayerImpactFrame_TimeCtrl[4] = 0;
PlayerImpactFrame_TimeCtrl[5] = 0;
PlayerImpactFrame_TimeCtrl[6] = 0;
PlayerImpactFrame_TimeCtrl[7] = 0;
PlayerImpactFrame_TimeCtrl[8] = 0;
PlayerImpactFrame_TimeCtrl[9] = 0;
PlayerImpactFrame_TimeCtrl[10] = 0;
PlayerImpactFrame_TimeCtrl[11] = 0;
PlayerImpactFrame_TimeCtrl[12] = 0;
PlayerImpactFrame_TimeCtrl[13] = 0;
PlayerImpactFrame_TimeCtrl[14] = 0;
PlayerImpactFrame_TimeCtrl[15] = 0;
PlayerImpactFrame_TimeCtrl[16] = 0;
PlayerImpactFrame_TimeCtrl[17] = 0;
PlayerImpactFrame_TimeCtrl[18] = 0;
PlayerImpactFrame_TimeCtrl[19] = 0;
PlayerImpactFrame_TimeCtrl[20] = 0;
PlayerImpactFrame_TimeCtrl[21] = 0;
PlayerImpactFrame_TimeCtrl[22] = 0;
PlayerImpactFrame_TimeCtrl[23] = 0;
PlayerImpactFrame_TimeCtrl[24] = 0;
PlayerImpactFrame_TimeCtrl[25] = 0;
PlayerImpactFrame_TimeCtrl[26] = 0;
PlayerImpactFrame_TimeCtrl[27] = 0;
PlayerImpactFrame_TimeCtrl[28] = 0;
PlayerImpactFrame_TimeCtrl[29] = 0;
PlayerImpactFrame_TimeCtrl[30] = 0;
PlayerImpactFrame_TimeCtrl[31] = 0;
PlayerImpactFrame_TimeCtrl[32] = 0;
PlayerImpactFrame_TimeCtrl[33] = 0;
PlayerImpactFrame_TimeCtrl[34] = 0;
PlayerImpactFrame_TimeCtrl[35] = 0;
PlayerImpactFrame_TimeCtrl[36] = 0;
PlayerImpactFrame_TimeCtrl[37] = 0;
PlayerImpactFrame_TimeCtrl[38] = 0;
PlayerImpactFrame_TimeCtrl[39] = 0;
PlayerImpactFrame_TimeCtrl[40] = 0;
PlayerImpactFrame_TimeCtrl[41] = 0;
PlayerImpactFrame_TimeCtrl[42] = 0;
PlayerImpactFrame_TimeCtrl[43] = 0;
PlayerImpactFrame_TimeCtrl[44] = 0;
PlayerImpactFrame_TimeCtrl[45] = 0;
PlayerImpactFrame_TimeCtrl[46] = 0;
PlayerImpactFrame_TimeCtrl[47] = 0;
PlayerImpactFrame_TimeCtrl[48] = 0;
PlayerImpactFrame_TimeCtrl[49] = 0;
PlayerImpactFrame_TimeCtrl[50] = 0;
PlayerImpactFrame_TimeCtrl[51] = 0;
PlayerImpactFrame_TimeCtrl[52] = 0;
PlayerImpactFrame_TimeCtrl[53] = 0;
PlayerImpactFrame_TimeCtrl[54] = 0;
PlayerImpactFrame_TimeCtrl[55] = 0;
PlayerImpactFrame_TimeCtrl[56] = 0;
PlayerImpactFrame_TimeCtrl[57] = 0;
PlayerImpactFrame_TimeCtrl[58] = 0;
PlayerImpactFrame_TimeCtrl[59] = 0;
PlayerImpactFrame_TimeCtrl[60] = 0;

local IMPACT_BUTTONS = {};

local buffIndex = {};
buffIndex[1] = 0;
buffIndex[2] = 0;
buffIndex[3] = 0;
buffIndex[4] = 0;
buffIndex[5] = 0;
buffIndex[6] = 0;
buffIndex[7] = 0;
buffIndex[8] = 0;
buffIndex[9] = 0;
buffIndex[10] = 0;
buffIndex[11] = 0;
buffIndex[12] = 0;
buffIndex[13] = 0;
buffIndex[14] = 0;
buffIndex[15] = 0;
buffIndex[16] = 0;
buffIndex[17] = 0;
buffIndex[18] = 0;
buffIndex[19] = 0;
buffIndex[20] = 0;
buffIndex[21] = 0;
buffIndex[22] = 0;
buffIndex[23] = 0;
buffIndex[24] = 0;
buffIndex[25] = 0;
buffIndex[26] = 0;
buffIndex[27] = 0;
buffIndex[28] = 0;
buffIndex[29] = 0;
buffIndex[30] = 0;
buffIndex[31] = 0;
buffIndex[32] = 0;
buffIndex[33] = 0;
buffIndex[34] = 0;
buffIndex[35] = 0;
buffIndex[36] = 0;
buffIndex[37] = 0;
buffIndex[38] = 0;
buffIndex[39] = 0;
buffIndex[40] = 0;
buffIndex[41] = 0;
buffIndex[42] = 0;
buffIndex[43] = 0;
buffIndex[44] = 0;
buffIndex[45] = 0;
buffIndex[46] = 0;
buffIndex[47] = 0;
buffIndex[48] = 0;
buffIndex[49] = 0;
buffIndex[50] = 0;
buffIndex[51] = 0;
buffIndex[52] = 0;
buffIndex[53] = 0;
buffIndex[54] = 0;
buffIndex[55] = 0;
buffIndex[56] = 0;
buffIndex[57] = 0;
buffIndex[58] = 0;
buffIndex[59] = 0;
buffIndex[60] = 0;

function PlayerImpactFrame_PreLoad()
	this:RegisterEvent( "UI_COMMAND" )

	this:RegisterEvent("IMPACT_SELF_UPDATE");
	this:RegisterEvent("IMPACT_SELF_UPDATE_TIME");
end

function PlayerImpactFrame_OnLoad()

	IMPACT_BUTTONS[1] = PlayerImpact_Image1;
	IMPACT_BUTTONS[2] = PlayerImpact_Image2;
	IMPACT_BUTTONS[3] = PlayerImpact_Image3;
	IMPACT_BUTTONS[4] = PlayerImpact_Image4;
	IMPACT_BUTTONS[5] = PlayerImpact_Image5;
	IMPACT_BUTTONS[6] = PlayerImpact_Image6;
	IMPACT_BUTTONS[7] = PlayerImpact_Image7;
	IMPACT_BUTTONS[8] = PlayerImpact_Image8;
	IMPACT_BUTTONS[9] = PlayerImpact_Image9;
	IMPACT_BUTTONS[10] = PlayerImpact_Image10;
	IMPACT_BUTTONS[11] = PlayerImpact_Image11;
	IMPACT_BUTTONS[12] = PlayerImpact_Image12;
	IMPACT_BUTTONS[13] = PlayerImpact_Image13;
	IMPACT_BUTTONS[14] = PlayerImpact_Image14;
	IMPACT_BUTTONS[15] = PlayerImpact_Image15;
	IMPACT_BUTTONS[16] = PlayerImpact_Image16;
	IMPACT_BUTTONS[17] = PlayerImpact_Image17;
	IMPACT_BUTTONS[18] = PlayerImpact_Image18;
	IMPACT_BUTTONS[19] = PlayerImpact_Image19;
	IMPACT_BUTTONS[20] = PlayerImpact_Image20;
	IMPACT_BUTTONS[21] = PlayerImpact_Image21;
	IMPACT_BUTTONS[22] = PlayerImpact_Image22;
	IMPACT_BUTTONS[23] = PlayerImpact_Image23;
	IMPACT_BUTTONS[24] = PlayerImpact_Image24;
	IMPACT_BUTTONS[25] = PlayerImpact_Image25;
	IMPACT_BUTTONS[26] = PlayerImpact_Image26;
	IMPACT_BUTTONS[27] = PlayerImpact_Image27;
	IMPACT_BUTTONS[28] = PlayerImpact_Image28;
	IMPACT_BUTTONS[29] = PlayerImpact_Image29;
	IMPACT_BUTTONS[30] = PlayerImpact_Image30;
	IMPACT_BUTTONS[31] = PlayerImpact_Image31;
	IMPACT_BUTTONS[32] = PlayerImpact_Image32;
	IMPACT_BUTTONS[33] = PlayerImpact_Image33;
	IMPACT_BUTTONS[34] = PlayerImpact_Image34;
	IMPACT_BUTTONS[35] = PlayerImpact_Image35;
	IMPACT_BUTTONS[36] = PlayerImpact_Image36;
	IMPACT_BUTTONS[37] = PlayerImpact_Image37;
	IMPACT_BUTTONS[38] = PlayerImpact_Image38;
	IMPACT_BUTTONS[39] = PlayerImpact_Image39;
	IMPACT_BUTTONS[40] = PlayerImpact_Image40;
	IMPACT_BUTTONS[41] = PlayerImpact_Image41;
	IMPACT_BUTTONS[42] = PlayerImpact_Image42;
	IMPACT_BUTTONS[43] = PlayerImpact_Image43;
	IMPACT_BUTTONS[44] = PlayerImpact_Image44;
	IMPACT_BUTTONS[45] = PlayerImpact_Image45;
	IMPACT_BUTTONS[46] = PlayerImpact_Image46;
	IMPACT_BUTTONS[47] = PlayerImpact_Image47;
	IMPACT_BUTTONS[48] = PlayerImpact_Image48;
	IMPACT_BUTTONS[49] = PlayerImpact_Image49;
	IMPACT_BUTTONS[50] = PlayerImpact_Image50;
	IMPACT_BUTTONS[51] = PlayerImpact_Image51;
	IMPACT_BUTTONS[52] = PlayerImpact_Image52;
	IMPACT_BUTTONS[53] = PlayerImpact_Image53;
	IMPACT_BUTTONS[54] = PlayerImpact_Image54;
	IMPACT_BUTTONS[55] = PlayerImpact_Image55;
	IMPACT_BUTTONS[56] = PlayerImpact_Image56;
	IMPACT_BUTTONS[57] = PlayerImpact_Image57;
	IMPACT_BUTTONS[58] = PlayerImpact_Image58;
	IMPACT_BUTTONS[59] = PlayerImpact_Image59;
	IMPACT_BUTTONS[60] = PlayerImpact_Image60;
	
	PlayerImpactFrame_TimeCtrl[1] = PlayerImpact_Text1;
	PlayerImpactFrame_TimeCtrl[2] = PlayerImpact_Text2;
	PlayerImpactFrame_TimeCtrl[3] = PlayerImpact_Text3;
	PlayerImpactFrame_TimeCtrl[4] = PlayerImpact_Text4;
	PlayerImpactFrame_TimeCtrl[5] = PlayerImpact_Text5;
	PlayerImpactFrame_TimeCtrl[6] = PlayerImpact_Text6;
	PlayerImpactFrame_TimeCtrl[7] = PlayerImpact_Text7;
	PlayerImpactFrame_TimeCtrl[8] = PlayerImpact_Text8;
	PlayerImpactFrame_TimeCtrl[9] = PlayerImpact_Text9;
	PlayerImpactFrame_TimeCtrl[10] = PlayerImpact_Text10;
	PlayerImpactFrame_TimeCtrl[11] = PlayerImpact_Text11;
	PlayerImpactFrame_TimeCtrl[12] = PlayerImpact_Text12;
	PlayerImpactFrame_TimeCtrl[13] = PlayerImpact_Text13;
	PlayerImpactFrame_TimeCtrl[14] = PlayerImpact_Text14;
	PlayerImpactFrame_TimeCtrl[15] = PlayerImpact_Text15;
	PlayerImpactFrame_TimeCtrl[16] = PlayerImpact_Text16;
	PlayerImpactFrame_TimeCtrl[17] = PlayerImpact_Text17;
	PlayerImpactFrame_TimeCtrl[18] = PlayerImpact_Text18;
	PlayerImpactFrame_TimeCtrl[19] = PlayerImpact_Text19;
	PlayerImpactFrame_TimeCtrl[20] = PlayerImpact_Text20;
	PlayerImpactFrame_TimeCtrl[21] = PlayerImpact_Text21;
	PlayerImpactFrame_TimeCtrl[22] = PlayerImpact_Text22;
	PlayerImpactFrame_TimeCtrl[23] = PlayerImpact_Text23;
	PlayerImpactFrame_TimeCtrl[24] = PlayerImpact_Text24;
	PlayerImpactFrame_TimeCtrl[25] = PlayerImpact_Text25;
	PlayerImpactFrame_TimeCtrl[26] = PlayerImpact_Text26;
	PlayerImpactFrame_TimeCtrl[27] = PlayerImpact_Text27;
	PlayerImpactFrame_TimeCtrl[28] = PlayerImpact_Text28;
	PlayerImpactFrame_TimeCtrl[29] = PlayerImpact_Text29;
	PlayerImpactFrame_TimeCtrl[30] = PlayerImpact_Text30;
	PlayerImpactFrame_TimeCtrl[31] = PlayerImpact_Text31;
	PlayerImpactFrame_TimeCtrl[32] = PlayerImpact_Text32;
	PlayerImpactFrame_TimeCtrl[33] = PlayerImpact_Text33;
	PlayerImpactFrame_TimeCtrl[34] = PlayerImpact_Text34;
	PlayerImpactFrame_TimeCtrl[35] = PlayerImpact_Text35;
	PlayerImpactFrame_TimeCtrl[36] = PlayerImpact_Text36;
	PlayerImpactFrame_TimeCtrl[37] = PlayerImpact_Text37;
	PlayerImpactFrame_TimeCtrl[38] = PlayerImpact_Text38;
	PlayerImpactFrame_TimeCtrl[39] = PlayerImpact_Text39;
	PlayerImpactFrame_TimeCtrl[40] = PlayerImpact_Text40;
	PlayerImpactFrame_TimeCtrl[41] = PlayerImpact_Text41;
	PlayerImpactFrame_TimeCtrl[42] = PlayerImpact_Text42;
	PlayerImpactFrame_TimeCtrl[43] = PlayerImpact_Text43;
	PlayerImpactFrame_TimeCtrl[44] = PlayerImpact_Text44;
	PlayerImpactFrame_TimeCtrl[45] = PlayerImpact_Text45;
	PlayerImpactFrame_TimeCtrl[46] = PlayerImpact_Text46;
	PlayerImpactFrame_TimeCtrl[47] = PlayerImpact_Text47;
	PlayerImpactFrame_TimeCtrl[48] = PlayerImpact_Text48;
	PlayerImpactFrame_TimeCtrl[49] = PlayerImpact_Text49;
	PlayerImpactFrame_TimeCtrl[50] = PlayerImpact_Text50;
	PlayerImpactFrame_TimeCtrl[51] = PlayerImpact_Text51;
	PlayerImpactFrame_TimeCtrl[52] = PlayerImpact_Text52;
	PlayerImpactFrame_TimeCtrl[53] = PlayerImpact_Text53;
	PlayerImpactFrame_TimeCtrl[54] = PlayerImpact_Text54;
	PlayerImpactFrame_TimeCtrl[55] = PlayerImpact_Text55;
	PlayerImpactFrame_TimeCtrl[56] = PlayerImpact_Text56;
	PlayerImpactFrame_TimeCtrl[57] = PlayerImpact_Text57;
	PlayerImpactFrame_TimeCtrl[58] = PlayerImpact_Text58;
	PlayerImpactFrame_TimeCtrl[59] = PlayerImpact_Text59;
	PlayerImpactFrame_TimeCtrl[60] = PlayerImpact_Text60;
end

function PlayerImpactFrame_OnEvent(event)
	if ( event == "IMPACT_SELF_UPDATE" or (event == "UI_COMMAND" and arg0 == "1000000106")) then
		PlayerImpactFrame_Update( 1, 1 );
		return;
	end
	if ( event == "IMPACT_SELF_UPDATE" ) then
		PlayerImpactFrame_Update( 1, 1 );
		return;
	end

	if ( event == "IMPACT_SELF_UPDATE_TIME" ) then
		PlayerImpactFrame_Update( 0, 1 );
		return;
	end
	

end

function PlayerImpactFrame_Update( bUpdateImage, bUpdateTime )

	local buff_num = Player:GetBuffNumber();
	if ( buff_num > IMPACT_NUM ) then
		buff_num = IMPACT_NUM;
	end

	if( buff_num == 0) then 
		this:Hide();
		return;
	end

	this:Show();
	if ( bUpdateImage > 0 ) then
		initbuffIndex()
		local szIconName, szToolTips;
		local i,j;
		
		i = 0;
		j = 0;
		while i<buff_num do			
			szIconName = Player:GetBuffIconNameByIndex(i);
			szToolTips = Player:GetBuffToolTipsByIndex(i);
			if szToolTips=="MyMenpaiId=15" or szToolTips=="MyMenpaiId=16" or szToolTips=="999" then 
				i=i+1;
				continue;
			end			
			--ÊÞ»ê¸½ÌåÏÔÊ¾Õ¼ÓÃ
			if szToolTips ~= nil and string.find(szToolTips,"ÊÞ»ê¸½Ìå") ~= nil then
				local nExShow = "#cffcc00"
				local nExShowStr = {
					"equip_attr_attack_cold",
					"equip_attr_attack_fire",
					"equip_attr_attack_light",
					"equip_attr_attack_poison",
					"equip_attr_resist_cold",
					"equip_attr_resist_fire",
					"equip_attr_resist_light",
					"equip_attr_resist_poison",
					"equip_attr_attack_p",
					"equip_attr_attack_m",
					"equip_attr_maxhp",
					"equip_attr_hit",
					"equip_attr_miss",
				}
				local nExShowData = {56,57,58,59,60,61,62,63,64,65,66,67,68}
				local nExShowDataEx = {69,70,71,72,73,74,75,76,77,78,79,80,81}
				for i = 1,table.getn(nExShowData) do
					local nCommonAdd = DataPool:GetXYJServerData(nExShowData[i]);
					if nCommonAdd > 0 then
						nExShow = nExShow.."#cffcc00#{"..nExShowStr[i].."} +"..nCommonAdd
						local nCommonAddEx = DataPool:GetXYJServerData(nExShowDataEx[i]);
						if nCommonAddEx > 0 then
							nExShow = nExShow.."#H  +"..nCommonAddEx.."#r"
						else
							nExShow = nExShow.."#r"
						end
					end
				end
				szToolTips = szToolTips.."#r"..nExShow
			end
			buffIndex[j+1]=i;
			IMPACT_BUTTONS[j+1]:SetProperty("ShortImage", szIconName);
			IMPACT_BUTTONS[j+1]:SetProperty("MouseHollow","False");
			IMPACT_BUTTONS[j+1]:SetToolTip(szToolTips);
			IMPACT_BUTTONS[j+1]:Show();
			i = i+1;
			j = j+1;
		end		

		while j<IMPACT_NUM do
			IMPACT_BUTTONS[j+1]:SetProperty("MouseHollow","True");
			IMPACT_BUTTONS[j+1]:Hide();
			j = j+1;
		end
	end
	
	if ( bUpdateTime > 0 ) then
		local szTimeText, szToolTips;
		local i,j;

		i = 0;
		j = 0;
		while i<buff_num do
			szTimeText = Player:GetBuffTimeTextByIndex(i);
			szToolTips = Player:GetBuffToolTipsByIndex(i);
			if szToolTips=="MyMenpaiId=15" or szToolTips=="MyMenpaiId=16" or szToolTips=="999" then 
				i=i+1;
				continue;
			end
--			PlayerImpactFrame_TimeCtrl[i+1]:SetText(szTimeText);
			PlayerImpactFrame_TimeCtrl[j+1]:SetProperty("Timer",tostring(szTimeText));
			PlayerImpactFrame_TimeCtrl[j+1]:Show();
			i = i+1;
			j = j+1;
		end

		while j<IMPACT_NUM do
			PlayerImpactFrame_TimeCtrl[j+1]:SetProperty("Timer","-2");
			PlayerImpactFrame_TimeCtrl[j+1]:Hide();
			j = j+1;
		end
	end
end

function PlayerImpactFrame_Image1_Click()
	Player:DispelBuffByIndex( buffIndex[1] );
end

function PlayerImpactFrame_Image2_Click()
	Player:DispelBuffByIndex( buffIndex[2] );
end

function PlayerImpactFrame_Image3_Click()
	Player:DispelBuffByIndex( buffIndex[3] );
end

function PlayerImpactFrame_Image4_Click()
	Player:DispelBuffByIndex( buffIndex[4] );
end

function PlayerImpactFrame_Image5_Click()
	Player:DispelBuffByIndex( buffIndex[5] );
end

function PlayerImpactFrame_Image6_Click()
	Player:DispelBuffByIndex( buffIndex[6] );
end

function PlayerImpactFrame_Image7_Click()
	Player:DispelBuffByIndex( buffIndex[7] );
end

function PlayerImpactFrame_Image8_Click()
	Player:DispelBuffByIndex( buffIndex[8] );
end

function PlayerImpactFrame_Image9_Click()
	Player:DispelBuffByIndex( buffIndex[9] );
end

function PlayerImpactFrame_Image10_Click()
	Player:DispelBuffByIndex( buffIndex[10] );
end

function PlayerImpactFrame_Image11_Click()
	Player:DispelBuffByIndex( buffIndex[11] );
end

function PlayerImpactFrame_Image12_Click()
	Player:DispelBuffByIndex( buffIndex[12] );
end

function PlayerImpactFrame_Image13_Click()
	Player:DispelBuffByIndex( buffIndex[13] );
end

function PlayerImpactFrame_Image14_Click()
	Player:DispelBuffByIndex( buffIndex[14] );
end

function PlayerImpactFrame_Image15_Click()
	Player:DispelBuffByIndex( buffIndex[15] );
end

function PlayerImpactFrame_Image16_Click()
	Player:DispelBuffByIndex( buffIndex[16] );
end

function PlayerImpactFrame_Image17_Click()
	Player:DispelBuffByIndex( buffIndex[17] );
end

function PlayerImpactFrame_Image18_Click()
	Player:DispelBuffByIndex( buffIndex[18] );
end

function PlayerImpactFrame_Image19_Click()
	Player:DispelBuffByIndex( buffIndex[19] );
end

function PlayerImpactFrame_Image20_Click()
	Player:DispelBuffByIndex( buffIndex[20] );
end

function PlayerImpactFrame_Image21_Click()
	Player:DispelBuffByIndex( buffIndex[21] );
end

function PlayerImpactFrame_Image22_Click()
	Player:DispelBuffByIndex( buffIndex[22] );
end

function PlayerImpactFrame_Image23_Click()
	Player:DispelBuffByIndex( buffIndex[23] );
end

function PlayerImpactFrame_Image24_Click()
	Player:DispelBuffByIndex( buffIndex[24] );
end

function PlayerImpactFrame_Image25_Click()
	Player:DispelBuffByIndex( buffIndex[25] );
end

function PlayerImpactFrame_Image26_Click()
	Player:DispelBuffByIndex( buffIndex[26] );
end

function PlayerImpactFrame_Image27_Click()
	Player:DispelBuffByIndex( buffIndex[27] );
end

function PlayerImpactFrame_Image28_Click()
	Player:DispelBuffByIndex( buffIndex[28] );
end

function PlayerImpactFrame_Image29_Click()
	Player:DispelBuffByIndex( buffIndex[29] );
end

function PlayerImpactFrame_Image30_Click()
	Player:DispelBuffByIndex( buffIndex[30] );
end

function PlayerImpactFrame_Image31_Click()
	Player:DispelBuffByIndex( buffIndex[31] );
end

function PlayerImpactFrame_Image32_Click()
	Player:DispelBuffByIndex( buffIndex[32] );
end

function PlayerImpactFrame_Image33_Click()
	Player:DispelBuffByIndex( buffIndex[33] );
end

function PlayerImpactFrame_Image34_Click()
	Player:DispelBuffByIndex( buffIndex[34] );
end

function PlayerImpactFrame_Image35_Click()
	Player:DispelBuffByIndex( buffIndex[35] );
end

function PlayerImpactFrame_Image36_Click()
	Player:DispelBuffByIndex( buffIndex[36] );
end

function PlayerImpactFrame_Image37_Click()
	Player:DispelBuffByIndex( buffIndex[37] );
end

function PlayerImpactFrame_Image38_Click()
	Player:DispelBuffByIndex( buffIndex[38] );
end

function PlayerImpactFrame_Image39_Click()
	Player:DispelBuffByIndex( buffIndex[39] );
end

function PlayerImpactFrame_Image40_Click()
	Player:DispelBuffByIndex( buffIndex[40] );
end

function PlayerImpactFrame_Image41_Click()
	Player:DispelBuffByIndex( buffIndex[41] );
end

function PlayerImpactFrame_Image42_Click()
	Player:DispelBuffByIndex( buffIndex[42] );
end

function PlayerImpactFrame_Image43_Click()
	Player:DispelBuffByIndex( buffIndex[43] );
end

function PlayerImpactFrame_Image44_Click()
	Player:DispelBuffByIndex( buffIndex[44] );
end

function PlayerImpactFrame_Image45_Click()
	Player:DispelBuffByIndex( buffIndex[45] );
end

function PlayerImpactFrame_Image46_Click()
	Player:DispelBuffByIndex( buffIndex[46] );
end

function PlayerImpactFrame_Image47_Click()
	Player:DispelBuffByIndex( buffIndex[47] );
end

function PlayerImpactFrame_Image48_Click()
	Player:DispelBuffByIndex( buffIndex[48] );
end

function PlayerImpactFrame_Image49_Click()
	Player:DispelBuffByIndex( buffIndex[49] );
end

function PlayerImpactFrame_Image50_Click()
	Player:DispelBuffByIndex( buffIndex[50] );
end

function PlayerImpactFrame_Image51_Click()
	Player:DispelBuffByIndex( buffIndex[51] );
end

function PlayerImpactFrame_Image52_Click()
	Player:DispelBuffByIndex( buffIndex[52] );
end

function PlayerImpactFrame_Image53_Click()
	Player:DispelBuffByIndex( buffIndex[53] );
end

function PlayerImpactFrame_Image54_Click()
	Player:DispelBuffByIndex( buffIndex[54] );
end

function PlayerImpactFrame_Image55_Click()
	Player:DispelBuffByIndex( buffIndex[55] );
end

function PlayerImpactFrame_Image56_Click()
	Player:DispelBuffByIndex( buffIndex[56] );
end

function PlayerImpactFrame_Image57_Click()
	Player:DispelBuffByIndex( buffIndex[57] );
end

function PlayerImpactFrame_Image58_Click()
	Player:DispelBuffByIndex( buffIndex[58] );
end

function PlayerImpactFrame_Image59_Click()
	Player:DispelBuffByIndex( buffIndex[59] );
end

function PlayerImpactFrame_Image60_Click()
	Player:DispelBuffByIndex( buffIndex[60] );
end

function initbuffIndex()
	buffIndex[1] = 0;
	buffIndex[2] = 0;
	buffIndex[3] = 0;
	buffIndex[4] = 0;
	buffIndex[5] = 0;
	buffIndex[6] = 0;
	buffIndex[7] = 0;
	buffIndex[8] = 0;
	buffIndex[9] = 0;
	buffIndex[10] = 0;
	buffIndex[11] = 0;
	buffIndex[12] = 0;
	buffIndex[13] = 0;
	buffIndex[14] = 0;
	buffIndex[15] = 0;
	buffIndex[16] = 0;
	buffIndex[17] = 0;
	buffIndex[18] = 0;
	buffIndex[19] = 0;
	buffIndex[20] = 0;
	buffIndex[21] = 0;
	buffIndex[22] = 0;
	buffIndex[23] = 0;
	buffIndex[24] = 0;
	buffIndex[25] = 0;
	buffIndex[26] = 0;
	buffIndex[27] = 0;
	buffIndex[28] = 0;
	buffIndex[29] = 0;
	buffIndex[30] = 0;
	buffIndex[31] = 0;
	buffIndex[32] = 0;
	buffIndex[33] = 0;
	buffIndex[34] = 0;
	buffIndex[35] = 0;
	buffIndex[36] = 0;
	buffIndex[37] = 0;
	buffIndex[38] = 0;
	buffIndex[39] = 0;
	buffIndex[40] = 0;
	buffIndex[41] = 0;
	buffIndex[42] = 0;
	buffIndex[43] = 0;
	buffIndex[44] = 0;
	buffIndex[45] = 0;
	buffIndex[46] = 0;
	buffIndex[47] = 0;
	buffIndex[48] = 0;
	buffIndex[49] = 0;
	buffIndex[50] = 0;
	buffIndex[51] = 0;
	buffIndex[52] = 0;
	buffIndex[53] = 0;
	buffIndex[54] = 0;
	buffIndex[55] = 0;
	buffIndex[56] = 0;
	buffIndex[57] = 0;
	buffIndex[58] = 0;
	buffIndex[59] = 0;
	buffIndex[60] = 0;
end
