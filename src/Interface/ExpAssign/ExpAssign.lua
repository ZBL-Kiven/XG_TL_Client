local	gOpType						= 0; --��������
local	gExp							= 0; --�����
local	gAssExp						= 0; --���Զһ��������
local	gGBValue					= 0; --����ƶ�ֵ
local	gAssGBValue				= 0; --�һ�������ƶ�ֵ
local	gGPValue					= 0; --�����ɹ��׶�
local	gAssGPValue				= 0; --�һ��������ɹ��׶�
local	gMasterLevel			= 0; --ʦ���ȼ�
local	gBasePoint				= 0;
local	objCared					= -1;
local	MAX_OBJ_DISTANCE	= 3.0;

--===============================================
-- OnLoad()
--===============================================
function ExpAssign_PreLoad()
	this:RegisterEvent("OPEN_EXP_ASSIGN");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("UI_COMMAND");
end

function ExpAssign_OnLoad()
end

--===============================================
-- OnEvent()
--===============================================
function ExpAssign_OnEvent(event)
	if( event == "OPEN_EXP_ASSIGN" )then
		ExpAssign_Update();
		this:Show();
		objCared = DataPool : GetNPCIDByServerID( Get_XParam_INT(0) );
		if objCared == -1 then
				PushDebugMessage("server�����������������⡣");
				return;
		end
		this:CareObject(objCared, 1, "ExpAssign");
	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if(tonumber(arg0) ~= objCared) then
			return
		end
		
		--�����NPC�ľ������һ��������߱�ɾ�����Զ��ر�
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			--ȡ������
			this:CareObject(objCared, 0, "ExpAssign");
			this:Hide();
			objCared = -1
		end
	end
end

function ExpAssign_Update()

	AxTrace(0,0,tostring(arg0));
	local	str0, str1
	_, _, gExp, gGBValue, gGPValue, gMasterLevel, gOpType	= string.find( arg0, "(%d+),(%d+),(%d+),(%d+),(%d+)" );
	gExp					= tonumber( gExp )
	gGBValue			= tonumber( gGBValue )
	gGPValue			= tonumber( gGPValue )
	gMasterLevel	= tonumber( gMasterLevel )
	gOpType				= tonumber( gOpType )

	AxTrace(0,0,"gExp="..tostring(gExp));
	AxTrace(0,0,"gGBValue="..tostring(gGBValue));
	AxTrace(0,0,"gGPValue="..tostring(gGPValue));
	AxTrace(0,0,"gMasterLevel="..tostring(gMasterLevel));
	AxTrace(0,0,"gOpType="..tostring(gOpType));
	
	--�ƶ�ֵ�һ�
	if gOpType == 1 then
		ExpAssign_Info2:SetText("ÿ������ܶһ����ƶ�ֵΪ5000�㡣");
		if gMasterLevel == 1 then
			gBasePoint = 30; 		--1��ʦ���ȼ�
		elseif gMasterLevel == 2 then
			gBasePoint = 35;		--2��ʦ���ȼ�
		elseif gMasterLevel == 3 then
			gBasePoint = 50;		--3��ʦ���ȼ�
		elseif gMasterLevel == 4 then
			gBasePoint = 70;		--4��ʦ���ȼ�
		end
		
		if(gBasePoint ==0)then
			gAssGBValue = 0;
			gAssExp = 0;
		else
			if(gGBValue * gBasePoint>gExp)then
				--����ƶ��*a���ڿɶһ�����
				if(gExp >5000 * gBasePoint)then
					gAssGBValue = 5000;
					gAssExp = 5000 * gBasePoint;	
				else
					gAssGBValue = math.ceil( gExp / gBasePoint )	
					gAssExp = gExp;
				end
			else
				if(gGBValue>5000)then
					gAssGBValue = 5000;
					gAssExp = 5000 * gBasePoint;	
				else
					gAssGBValue = gGBValue;
					gAssExp = gGBValue*gBasePoint;
				end
			end
		end
		str0	= "�����ڿ�����ȡ�ľ���Ϊ"..tostring( gExp )..",��ӵ�е��ƶ�ֵΪ"..tostring( gGBValue )
		str1	= "��Ҫ�ƶ��:0"

	--���ɹ��׶ȶһ�
	elseif gOpType == 2 then
		ExpAssign_Info2:SetText("ÿ���ðﹱ������ȡ�ľ���Ϊ12��㡣");
		if gMasterLevel == 1 then
			gBasePoint = 250;		--1��ʦ���ȼ�
		elseif gMasterLevel == 2 then
			gBasePoint = 300;		--2��ʦ���ȼ�
		elseif gMasterLevel == 3 then
			gBasePoint = 400;		--3��ʦ���ȼ�
		elseif gMasterLevel == 4 then
			gBasePoint = 600;		--4��ʦ���ȼ�
		end
		gAssGPValue		= gGPValue
		gAssExp				= gGPValue * gBasePoint
		if gAssExp > gExp and gBasePoint ~= 0 then
			gAssExp			= gExp
			gAssGBValue	= math.ceil( gAssExp / gBasePoint )
		end
		str0	= "�����ڿ�����ȡ�ľ���Ϊ"..tostring( gExp )..",��ӵ�еİ��ɹ��׶�Ϊ"..tostring( gGPValue )
		str1	= "��Ҫ���ɹ��׶�:0"

	else
		return
	end

	ExpAssign_Cur_Info:SetText( str0 )
	ExpAssign_Moral_Need:SetText( str1 );
	--�ı������
	ExpAssign_Moral_Value:SetText( "0" );

end

function ExpAssign_Button_Max_Click()

	AxTrace(0,0,"gBasePoint="..tostring(gBasePoint));
	if gBasePoint == 0 then
		return
	end
	
	local	str
	--�ƶ�ֵ�һ�
	if gOpType == 1 then
		str	= "��Ҫ�ƶ��:"..tostring(gAssGBValue)
	--���ɹ��׶ȶһ�
	elseif gOpType == 2 then
		str	= "��Ҫ���ɹ��׶�:"..tostring(gAssGPValue)
	else
		return
	end
	ExpAssign_Moral_Need:SetText( str );
	--�ı������
	ExpAssign_Moral_Value:SetText( tostring(gAssExp) );

end

function ExpAssign_Value_Change()

	if gBasePoint == 0 then
		return
	end
	
	local nCurExp
	local	str
	nCurExp		= tonumber( ExpAssign_Moral_Value:GetText() );
	if nCurExp == nil then
		nCurExp	= 0
	end
	if nCurExp > gAssExp then
		nCurExp	= gAssExp
		ExpAssign_Moral_Value:SetText( nCurExp );
	end
	--�ƶ�ֵ�һ�
	if gOpType == 1 then
		str	= "��Ҫ�ƶ��:"..tostring( math.ceil( nCurExp / gBasePoint ) )
	--���ɹ��׶ȶһ�
	elseif gOpType == 2 then
		str	= "��Ҫ���ɹ��׶�:"..tostring( math.ceil( nCurExp / gBasePoint ) )
	else
		return
	end
	ExpAssign_Moral_Need:SetText( str );

end

function ExpAssign_Button_Get_Click()
	local nCurExp = tonumber( ExpAssign_Moral_Value:GetText() );
	if nCurExp == nil then
		nCurExp = 0
	end
	if nCurExp > 0 then
		Player:SetExpAssgin( nCurExp, gOpType );
	end
	
	this:Hide();
end

function ExpAssign_Button_Close_Click()
	this:Hide();
end
