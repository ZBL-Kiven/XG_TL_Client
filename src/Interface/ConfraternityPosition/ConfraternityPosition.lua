local GUILD_POSITION_SIZE = 10; --������ְλ��

function ConfraternityPosition_PreLoad()
	this:RegisterEvent("GUILD_SHOW_APPOINTPOS");
	this:RegisterEvent("GUILD_FORCE_CLOSE");
end

function ConfraternityPosition_OnLoad()
end

function ConfraternityPosition_OnEvent(event)
	if(event == "GUILD_SHOW_APPOINTPOS") then
		ConfraternityPosition_PositionList:ClearListBox();
		local i = 0;
		while i < GUILD_POSITION_SIZE do
			local szMsg = Guild:GetMyGuildInfo("Appoint", i);
			--AxTrace(0,0,"Guild Position:"..tostring(i).." pos:"..tostring(szMsg));
			if(nil ~= szMsg and "" ~= szMsg) then
				ConfraternityPosition_PositionList:AddItem(szMsg,i);
			else
				break;
			end
			i = i + 1;
		end
		
		if(nil ~= Guild:GetMyGuildInfo("Appoint", 0)) then
			ConfraternityPosition_PositionList:SetItemSelectByItemID(0);
		end
		this:Show();
	elseif(event == "GUILD_FORCE_CLOSE") then
		this:Hide();
	end
end

function Guild_Position_Confirm()
	local selidx = ConfraternityPosition_PositionList:GetFirstSelectItem();
	-- add by zchw 
	local szMsg = Guild:GetMyGuildInfo("Appoint", selidx);
	if szMsg == "����" then
		local Num = Guild:GetMemberBak();
		local szLvl = Guild:GetMembersInfo(Num, "Level");	
		if szLvl < 40 then
			PushDebugMessage("40�����µİ��ڲ��ܱ�����Ϊ���ˣ�");
			return;
		end
	-- end
	end	
	if(-1 ~= selidx) then
		--���������ӿ�
		Guild:AdjustMemberAuth(selidx);
	end
	this:Hide();
end