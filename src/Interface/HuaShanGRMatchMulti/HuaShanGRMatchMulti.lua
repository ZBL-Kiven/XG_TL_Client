--��ɽ�۽����������ֽ��洦��ű�
--���ߣ�����
--ʱ�䣺2010-1-19

--===============================================
-- OnLoad()
--===============================================
function HuaShanGRMatchMulti_PreLoad()
	this:RegisterEvent("REFRESH_HUASHANGRMATCH_SCORE");
	this:RegisterEvent("SHOW_HUASHANGRMATCH_SCORE_M");
	this:RegisterEvent("SCENE_TRANSED");
end

function HuaShanGRMatchMulti_OnLoad()
	HuaShanGRMatchMulti_List:SetProperty( "ColumnsSizable", "False" );
	HuaShanGRMatchMulti_List:SetProperty( "ColumnsAdjust", "True" );
	HuaShanGRMatchMulti_List:SetProperty( "ColumnsMovable", "False" );
end

function HuaShanGRMatchMulti_OnHiden()
    Match:CloseHuaShanGRMatchScoreMultiTable();
end
--===============================================
-- OnEvent()
--===============================================
function HuaShanGRMatchMulti_OnEvent(event)
	
	if( event == "SHOW_HUASHANGRMATCH_SCORE_M" ) then
		if arg0 == "0" and this:IsVisible() then
			this:Hide();
		elseif arg0 == "0" and this:IsVisible() == false then
			--do nothing
		else
			this:Show();
			HuaShanGRMatchMulti_GetData();
		end
	elseif ( event == "REFRESH_PHOENIXPLAINWAR_SCORE" and this:IsVisible() ) then
		HuaShanGRMatchMulti_GetData();
	elseif ( event == "SCENE_TRANSED" ) then
		if this:IsVisible() then
			this:Hide();
		end
	end
end
--===============================================
-- �رո��ϴ���
--===============================================
function HuaShanGRMatchMulti_Close()
	Match:CloseHuaShanGRMatchScoreMultiTable();
end
--===============================================
--��ȡ���ϴ��ڵĳɼ�
--===============================================
function HuaShanGRMatchMulti_GetData()
	HuaShanGRMatchMulti_List:RemoveAllItem();
	for i = 0, 9 do
		local ret,szName,nLevel,nMenPai,nScore,nKillCount,nDieCount = Match:GetHuaShanGRMatchScore(i);
		if ret == 1 and szName ~= "" and nMenPai ~= 9 and nMenPai >= 0 and nMenPai <= 10 then
			local szMenPai = HuaShanGRMatchMulti_Id2MenPai(nMenPai)
			HuaShanGRMatchMulti_SetInterface( i, szName, nLevel, szMenPai, nScore, nKillCount,nDieCount)
		end
	end
end
--===============================================
--IDת����
--===============================================
function HuaShanGRMatchMulti_Id2MenPai(nMenpaiId)
	local szMenpai = "����������"
	if nMenpaiId == 0  then
		szMenpai = "������"
	elseif nMenpaiId == 1  then
		szMenpai = "����"
	elseif nMenpaiId == 2  then
		szMenpai = "ؤ��"
	elseif nMenpaiId == 3  then
		szMenpai = "�䵱��"
	elseif nMenpaiId == 4  then
		szMenpai = "������"
	elseif nMenpaiId == 5  then
		szMenpai = "������"
	elseif nMenpaiId == 6  then
		szMenpai = "������"
	elseif nMenpaiId == 7  then
		szMenpai = "��ɽ��"
	elseif nMenpaiId == 8  then
		szMenpai = "��ң��"
	elseif nMenpaiId == 9 then 
		szMenpai = "������"
	elseif nMenpaiId == 10 then 
		szMenpai = "Ľ������"
	end	
	return szMenpai	
end
--===============================================
--�趨�������ʾ
--===============================================
function HuaShanGRMatchMulti_SetInterface(index, szName, nLevel, szMenPai, nScore, nKillCount,nDieCount)

	HuaShanGRMatchMulti_List:AddNewItem( "#Y"..index+1, 0, index );
	HuaShanGRMatchMulti_List:AddNewItem( szMenPai, 1, index );	
	HuaShanGRMatchMulti_List:AddNewItem( nLevel, 2, index );
	HuaShanGRMatchMulti_List:AddNewItem( szName, 3, index );
	HuaShanGRMatchMulti_List:AddNewItem( nScore, 4, index );
	HuaShanGRMatchMulti_List:AddNewItem( nKillCount, 5, index );
	HuaShanGRMatchMulti_List:AddNewItem( nDieCount, 6, index );
end

