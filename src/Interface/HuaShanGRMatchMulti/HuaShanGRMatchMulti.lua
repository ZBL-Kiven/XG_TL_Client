--华山论剑个人赛积分界面处理脚本
--作者：马亮
--时间：2010-1-19

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
-- 关闭复合窗口
--===============================================
function HuaShanGRMatchMulti_Close()
	Match:CloseHuaShanGRMatchScoreMultiTable();
end
--===============================================
--获取复合窗口的成绩
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
--ID转门派
--===============================================
function HuaShanGRMatchMulti_Id2MenPai(nMenpaiId)
	local szMenpai = "有问题门派"
	if nMenpaiId == 0  then
		szMenpai = "少林派"
	elseif nMenpaiId == 1  then
		szMenpai = "明教"
	elseif nMenpaiId == 2  then
		szMenpai = "丐帮"
	elseif nMenpaiId == 3  then
		szMenpai = "武当派"
	elseif nMenpaiId == 4  then
		szMenpai = "峨嵋派"
	elseif nMenpaiId == 5  then
		szMenpai = "星宿派"
	elseif nMenpaiId == 6  then
		szMenpai = "天龙派"
	elseif nMenpaiId == 7  then
		szMenpai = "天山派"
	elseif nMenpaiId == 8  then
		szMenpai = "逍遥派"
	elseif nMenpaiId == 9 then 
		szMenpai = "无门派"
	elseif nMenpaiId == 10 then 
		szMenpai = "慕容世家"
	end	
	return szMenpai	
end
--===============================================
--设定界面的显示
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

