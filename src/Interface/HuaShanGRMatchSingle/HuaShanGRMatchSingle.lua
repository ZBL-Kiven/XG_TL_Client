--��ɽ�۽����������ֽ��洦��ű�
--���ߣ�����
--ʱ�䣺2010-1-19

--===============================================
--�¼�ע��
--===============================================
function HuaShanGRMatchSingle_PreLoad()
	this:RegisterEvent("REFRESH_HUASHANGRMATCH_SCORE");
	this:RegisterEvent("SHOW_HUASHANGRMATCH_SCORE_S");
	this:RegisterEvent("SHOW_HUASHANGRMATCH_SCORE_M");
	this:RegisterEvent("SCENE_TRANSED");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
end
--===============================================
--��ʼ����Ϣ����
--===============================================
function HuaShanGRMatchSingle_OnLoad()
end


--===============================================
--�¼���Ӧ
--===============================================
function HuaShanGRMatchSingle_OnEvent(event)
	if( event == "SHOW_HUASHANGRMATCH_SCORE_M" ) then
		if arg0 == "0" then
			HuaShanGRMatchSingleOpen:Show();
	    HuaShanGRMatchSingleClose:Hide();
	  end	
	elseif event == "PLAYER_LEAVE_WORLD"  then
		if( this:IsVisible() ) then
			this:Hide();
		end
	elseif ( event == "REFRESH_HUASHANGRMATCH_SCORE" and this:IsVisible() == true) then
		for i=0,9 do 
			local ret,szName,nLevel,nMenPai,nScore,nKillCount,nDieCount = Match:GetHuaShanGRMatchScore(i);
			local szPlayerName = Player:GetName();
			if ret == 1 and szName ~= "" and szName == szPlayerName then 		
				HuaShanGRMatchSingle_Position:SetText("");
				HuaShanGRMatchSingle_GuildText:SetText("#B"..szName);
				HuaShanGRMatchSingle_ScoreText:SetText(nScore);
				break
			end
		end
	elseif ( event == "SCENE_TRANSED" ) then
		Match:ClearHuaShanGRMatchScore();
		if ( arg0 == "huashanzhidian" ) then
			this:Show();	
			HuaShanGRMatchSingle_GuildText:SetText("");
			HuaShanGRMatchSingle_Position:SetText("");
			HuaShanGRMatchSingle_ScoreText:SetText("");
		else
			this:Hide();
		end
	end
end
--===============================================
--�رո��������ִ���
--===============================================
function HuaShanGRMatchSingle_Close()
	Match:CloseHuaShanGRMatchScoreMultiTable();
	HuaShanGRMatchSingleOpen:Show();
	HuaShanGRMatchSingleClose:Hide();
end
--===============================================
--�򿪸��������ִ���
--===============================================
function HuaShanGRMatchSingle_Open()
	Match:OpenHuaShanGRMatchScoreMultiTable();
	HuaShanGRMatchSingleOpen:Hide();
	HuaShanGRMatchSingleClose:Show();	
end
