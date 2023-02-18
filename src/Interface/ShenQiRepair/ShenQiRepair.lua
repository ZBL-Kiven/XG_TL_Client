
-- [ QUFEI 2007-10-15 15:31 UPDATE BugID 26358 ]

local ShenQi_BUTTONS;
local CaiLiao_BUTTONS;
local ShenQi_QUALITY = -1;
local CaiLiao_QUALITY = -1;
local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;
local ShenQi_NPC_ID = -1
local ShenQi_PARA_PRICE = -1
local EQUIP_SHENQI_BEGIN = 10300000
local EQUIP_SHENQI_END = 10399999
local shenfuid = 0
local shenfu_grade = -1
--local SHENQI_NPC_NAME = "欧冶子"
--local g_ShenQiRepair_YuanBaoPay = 1


local g_Object = -1;
--local g_Npc_Name = ""


local g_NeedItemBonus={	{sqid01=10300000, sqid02=10302000, sqid03=10304000, sqid04=10305000, sfid=30505800},
			{sqid01=10300001, sqid02=10302001, sqid03=10304001, sqid04=10305001, sfid=30505801},
			{sqid01=10300002, sqid02=10302002, sqid03=10304002, sqid04=10305002, sfid=30505802},
			{sqid01=10300003, sqid02=10302003, sqid03=10304003, sqid04=10305003, sfid=30505803},
			{sqid01=10300004, sqid02=10302004, sqid03=10304004, sqid04=10305004, sfid=30505804},
			{sqid01=10300005, sqid02=10302005, sqid03=10304005, sqid04=10305005, sfid=30505805},
			{sqid01=10300100, sqid02=10300100, sqid03=10300100, sqid04=10300100, sfid=30505806},		-- 褚少微
			{sqid01=10300101, sqid02=10300101, sqid03=10300101, sqid04=10300101, sfid=30505806},
			{sqid01=10300102, sqid02=10300102, sqid03=10300102, sqid04=10300102, sfid=30505806},
			{sqid01=10301100, sqid02=10301100, sqid03=10301100, sqid04=10301100, sfid=30505806},
			{sqid01=10301101, sqid02=10301101, sqid03=10301101, sqid04=10301101, sfid=30505806},
			{sqid01=10301102, sqid02=10301102, sqid03=10301102, sqid04=10301102, sfid=30505806},
			{sqid01=10301200, sqid02=10301200, sqid03=10301200, sqid04=10301200, sfid=30505806},
			{sqid01=10301201, sqid02=10301201, sqid03=10301201, sqid04=10301201, sfid=30505806},
			{sqid01=10301202, sqid02=10301202, sqid03=10301202, sqid04=10301202, sfid=30505806},
			{sqid01=10302100, sqid02=10302100, sqid03=10302100, sqid04=10302100, sfid=30505806},
			{sqid01=10302101, sqid02=10302101, sqid03=10302101, sqid04=10302101, sfid=30505806},
			{sqid01=10302102, sqid02=10302102, sqid03=10302102, sqid04=10302102, sfid=30505806},
			{sqid01=10303100, sqid02=10303100, sqid03=10303100, sqid04=10303100, sfid=30505806},
			{sqid01=10303101, sqid02=10303101, sqid03=10303101, sqid04=10303101, sfid=30505806},
			{sqid01=10303102, sqid02=10303102, sqid03=10303102, sqid04=10303102, sfid=30505806},
			{sqid01=10303200, sqid02=10303200, sqid03=10303200, sqid04=10303200, sfid=30505806},
			{sqid01=10303201, sqid02=10303201, sqid03=10303201, sqid04=10303201, sfid=30505806},
			{sqid01=10303202, sqid02=10303202, sqid03=10303202, sqid04=10303202, sfid=30505806},
			{sqid01=10304100, sqid02=10304100, sqid03=10304100, sqid04=10304100, sfid=30505806},
			{sqid01=10304101, sqid02=10304101, sqid03=10304101, sqid04=10304101, sfid=30505806},
			{sqid01=10304102, sqid02=10304102, sqid03=10304102, sqid04=10304102, sfid=30505806},
			{sqid01=10305100, sqid02=10305100, sqid03=10305100, sqid04=10305100, sfid=30505806},
			{sqid01=10305101, sqid02=10305101, sqid03=10305101, sqid04=10305101, sfid=30505806},
			{sqid01=10305102, sqid02=10305102, sqid03=10305102, sqid04=10305102, sfid=30505806},
			{sqid01=10305200, sqid02=10305200, sqid03=10305200, sqid04=10305200, sfid=30505806},
			{sqid01=10305201, sqid02=10305201, sqid03=10305201, sqid04=10305201, sfid=30505806},
			{sqid01=10305202, sqid02=10305202, sqid03=10305202, sqid04=10305202, sfid=30505806},
			--86级新神器
			{sqid01=10300006, sqid02=10301000, sqid03=10301198, sqid04=10302006, sfid=30505804},
			{sqid01=10302008, sqid02=10303000, sqid03=10304006, sqid04=10305006, sfid=30505804},
			{sqid01=10305008, sqid02=10304008, sqid03=10302010, sqid04=10304008, sfid=30505804},
			--新增86神器（升星）
			{sqid01=10300400, sqid02=10301400, sqid03=10301401, sqid04=10302400, sfid=30505804},
			{sqid01=10302401, sqid02=10302402, sqid03=10303400, sqid04=10304400, sfid=30505804},
			{sqid01=10304401, sqid02=10305400, sqid03=10305401, sqid04=10300401, sfid=30505804},
			{sqid01=10301402, sqid02=10301403, sqid03=10302403, sqid04=10302404, sfid=30505804},
			{sqid01=10302405, sqid02=10303401, sqid03=10304402, sqid04=10304403, sfid=30505804},
			{sqid01=10305402, sqid02=10305403, sqid03=10302405, sqid04=10301403, sfid=30505804},
			--96级新神器
			{sqid01=10300007, sqid02=10301001, sqid03=10301199, sqid04=10302007, sfid=30505805},
			{sqid01=10302009, sqid02=10303001, sqid03=10304007, sqid04=10305007, sfid=30505805},
			{sqid01=10305009, sqid02=10304009, sqid03=10302011, sqid04=10304009, sfid=30505805},
			--新增96神器（升星）
			{sqid01=10300402, sqid02=10301404, sqid03=10301405, sqid04=10302406, sfid=30505805},
			{sqid01=10302407, sqid02=10302408, sqid03=10303402, sqid04=10304404, sfid=30505805},
			{sqid01=10304405, sqid02=10305404, sqid03=10305405, sqid04=10300403, sfid=30505805},
			{sqid01=10301406, sqid02=10301407, sqid03=10302409, sqid04=10302410, sfid=30505805},
			{sqid01=10302411, sqid02=10303403, sqid03=10304406, sqid04=10304407, sfid=30505805},
			{sqid01=10305406, sqid02=10305407, sqid03=10304406, sqid04=10305405, sfid=30505805},
			--102级新神器
			{sqid01=10300103, sqid02=10300104, sqid03=10300105, sqid04=10300106, sfid=30505806},
			{sqid01=10300107, sqid02=10300108, sqid03=10300109, sqid04=10300110, sfid=30505806},
			{sqid01=10300111, sqid02=10301103, sqid03=10301104, sqid04=10301105, sfid=30505806},
			{sqid01=10301106, sqid02=10301107, sqid03=10301108, sqid04=10301109, sfid=30505806},
			{sqid01=10301110, sqid02=10301111, sqid03=10301203, sqid04=10301204, sfid=30505806},
			{sqid01=10301205, sqid02=10301206, sqid03=10301207, sqid04=10301208, sfid=30505806},
			{sqid01=10301209, sqid02=10301210, sqid03=10301211, sqid04=10302103, sfid=30505806},
			{sqid01=10302104, sqid02=10302105, sqid03=10302106, sqid04=10302107, sfid=30505806},
			{sqid01=10302108, sqid02=10302109, sqid03=10302110, sqid04=10302111, sfid=30505806},
			{sqid01=10303103, sqid02=10303104, sqid03=10303105, sqid04=10303106, sfid=30505806},
			{sqid01=10303107, sqid02=10303108, sqid03=10303109, sqid04=10303110, sfid=30505806},
			{sqid01=10303111, sqid02=10303203, sqid03=10303204, sqid04=10303205, sfid=30505806},
			{sqid01=10303206, sqid02=10303207, sqid03=10303208, sqid04=10303209, sfid=30505806},
			{sqid01=10303210, sqid02=10303211, sqid03=10304103, sqid04=10304104, sfid=30505806},
			{sqid01=10304105, sqid02=10304106, sqid03=10304107, sqid04=10304108, sfid=30505806},
			{sqid01=10304109, sqid02=10304110, sqid03=10304111, sqid04=10305103, sfid=30505806},
			{sqid01=10305104, sqid02=10305105, sqid03=10305106, sqid04=10305107, sfid=30505806},
			{sqid01=10305108, sqid02=10305109, sqid03=10305110, sqid04=10305111, sfid=30505806},
			{sqid01=10305203, sqid02=10305204, sqid03=10305205, sqid04=10305206, sfid=30505806},
			{sqid01=10305207, sqid02=10305208, sqid03=10305209, sqid04=10305210, sfid=30505806},
			{sqid01=10305211, sqid02=10302200, sqid03=10302201, sqid04=10302202, sfid=30505806},
  			{sqid01=10302203, sqid02=10302204, sqid03=10302205, sqid04=10302206, sfid=30505806},
			{sqid01=10302207, sqid02=10302208, sqid03=10302209, sqid04=10302210, sfid=30505806},
			{sqid01=10302211, sqid02=10302211, sqid03=10302211, sqid04=10302211, sfid=30505806},
			--	新增神器
			{sqid01=10300404, sqid02=10300405, sqid03=10300406, sqid04=10300407, sfid=30505806},
			{sqid01=10300408, sqid02=10300409, sqid03=10300410, sqid04=10300411, sfid=30505806},
			{sqid01=10300412, sqid02=10301408, sqid03=10301409, sqid04=10301410, sfid=30505806},
			{sqid01=10301411, sqid02=10301412, sqid03=10301413, sqid04=10301414, sfid=30505806},
			{sqid01=10301415, sqid02=10301416, sqid03=10301417, sqid04=10301418, sfid=30505806},
			{sqid01=10301419, sqid02=10301420, sqid03=10301421, sqid04=10301422, sfid=30505806},
			{sqid01=10301423, sqid02=10301424, sqid03=10301425, sqid04=10302412, sfid=30505806},
			{sqid01=10302413, sqid02=10302414, sqid03=10302415, sqid04=10302416, sfid=30505806},
			{sqid01=10302417, sqid02=10302418, sqid03=10302419, sqid04=10302420, sfid=30505806},
			{sqid01=10302421, sqid02=10302422, sqid03=10302423, sqid04=10302424, sfid=30505806},
			{sqid01=10302425, sqid02=10302426, sqid03=10302427, sqid04=10302428, sfid=30505806},
			{sqid01=10302429, sqid02=10303404, sqid03=10303405, sqid04=10303406, sfid=30505806},
			{sqid01=10303407, sqid02=10303408, sqid03=10303409, sqid04=10303410, sfid=30505806},
			{sqid01=10303411, sqid02=10303412, sqid03=10303413, sqid04=10303414, sfid=30505806},
			{sqid01=10303415, sqid02=10303416, sqid03=10303417, sqid04=10303418, sfid=30505806},
			{sqid01=10303419, sqid02=10303420, sqid03=10303421, sqid04=10304408, sfid=30505806},
			{sqid01=10304409, sqid02=10304410, sqid03=10304411, sqid04=10304412, sfid=30505806},
			{sqid01=10304413, sqid02=10304414, sqid03=10304415, sqid04=10304416, sfid=30505806},
			{sqid01=10305408, sqid02=10305409, sqid03=10305410, sqid04=10305411, sfid=30505806},
			{sqid01=10305412, sqid02=10305413, sqid03=10305414, sqid04=10305415, sfid=30505806},
			{sqid01=10305416, sqid02=10305417, sqid03=10305418, sqid04=10305419, sfid=30505806},
			{sqid01=10305420, sqid02=10305421, sqid03=10305422, sqid04=10305423, sfid=30505806},
			{sqid01=10305424, sqid02=10305425, sqid03=10300413, sqid04=10300414, sfid=30505806},
			{sqid01=10300415, sqid02=10300416, sqid03=10300417, sqid04=10300418, sfid=30505806},
			{sqid01=10300419, sqid02=10300420, sqid03=10300421, sqid04=10301426, sfid=30505806},
			{sqid01=10301427, sqid02=10301428, sqid03=10301429, sqid04=10301430, sfid=30505806},
			{sqid01=10301431, sqid02=10301432, sqid03=10301433, sqid04=10301434, sfid=30505806},
			{sqid01=10301435, sqid02=10301436, sqid03=10301437, sqid04=10301438, sfid=30505806},
			{sqid01=10301439, sqid02=10301440, sqid03=10301441, sqid04=10301442, sfid=30505806},
			{sqid01=10301443, sqid02=10302430, sqid03=10302431, sqid04=10302432, sfid=30505806},
			{sqid01=10302433, sqid02=10302434, sqid03=10302435, sqid04=10302436, sfid=30505806},
			{sqid01=10302437, sqid02=10302438, sqid03=10302439, sqid04=10302440, sfid=30505806},
			{sqid01=10302441, sqid02=10302442, sqid03=10302443, sqid04=10302444, sfid=30505806},
			{sqid01=10302445, sqid02=10302446, sqid03=10302447, sqid04=10303422, sfid=30505806},
			{sqid01=10303423, sqid02=10303424, sqid03=10303425, sqid04=10303426, sfid=30505806},
			{sqid01=10303427, sqid02=10303428, sqid03=10303429, sqid04=10303430, sfid=30505806},
			{sqid01=10303431, sqid02=10303432, sqid03=10303433, sqid04=10303434, sfid=30505806},
			{sqid01=10303435, sqid02=10303436, sqid03=10303437, sqid04=10303438, sfid=30505806},
			{sqid01=10303439, sqid02=10304417, sqid03=10304418, sqid04=10304419, sfid=30505806},
			{sqid01=10304420, sqid02=10304421, sqid03=10304422, sqid04=10304423, sfid=30505806},
			{sqid01=10304424, sqid02=10304425, sqid03=10305426, sqid04=10305427, sfid=30505806},
			{sqid01=10305428, sqid02=10305429, sqid03=10305430, sqid04=10305431, sfid=30505806},
			{sqid01=10305432, sqid02=10305433, sqid03=10305434, sqid04=10305435, sfid=30505806},
			{sqid01=10305436, sqid02=10305437, sqid03=10305438, sqid04=10305439, sfid=30505806},
			{sqid01=10305440, sqid02=10305441, sqid03=10305442, sqid04=10305443, sfid=30505806},
			--新门派神器
			{sqid01=10306000, sqid02=10306000, sqid03=10306000, sqid04=10306000, sfid=30505800},
			{sqid01=10306001, sqid02=10306001, sqid03=10306001, sqid04=10306001, sfid=30505801},
			{sqid01=10306002, sqid02=10306002, sqid03=10306002, sqid04=10306002, sfid=30505802},
			{sqid01=10306003, sqid02=10306003, sqid03=10306003, sqid04=10306003, sfid=30505803},
			{sqid01=10306004, sqid02=10306006, sqid03=10306008, sqid04=10306010, sfid=30505804},
			{sqid01=10306005, sqid02=10306007, sqid03=10306009, sqid04=10306011, sfid=30505805},
			{sqid01=10306012, sqid02=10306013, sqid03=10306014, sqid04=10306012, sfid=30505806},
			{sqid01=10306015, sqid02=10306016, sqid03=10306017, sqid04=10306018, sfid=30505806},
			{sqid01=10306019, sqid02=10306020, sqid03=10306021, sqid04=10306022, sfid=30505806},
			{sqid01=10306023, sqid02=10306023, sqid03=10306023, sqid04=10306023, sfid=30505806},
			{sqid01=10306024, sqid02=10306025, sqid03=10306026, sqid04=10306027, sfid=30505806},
			{sqid01=10306028, sqid02=10306029, sqid03=10306030, sqid04=10306031, sfid=30505806},
			{sqid01=10306032, sqid02=10306033, sqid03=10306034, sqid04=10306035, sfid=30505806},
			{sqid01=10306036, sqid02=10306037, sqid03=10306038, sqid04=10306039, sfid=30505806},
			{sqid01=10306040, sqid02=10306041, sqid03=10306041, sqid04=10306041, sfid=30505806},

			--新门派神器鬼谷
			{sqid01=10307000, sqid02=10307000, sqid03=10307000, sqid04=10307000, sfid=30505800},
			{sqid01=10307001, sqid02=10307001, sqid03=10307001, sqid04=10307001, sfid=30505801},
			{sqid01=10307002, sqid02=10307002, sqid03=10307002, sqid04=10307002, sfid=30505802},
			{sqid01=10307003, sqid02=10307003, sqid03=10307003, sqid04=10307003, sfid=30505803},
			{sqid01=10307004, sqid02=10307006, sqid03=10307008, sqid04=10307010, sfid=30505804},
			{sqid01=10307005, sqid02=10307007, sqid03=10307009, sqid04=10307011, sfid=30505805},
			{sqid01=10307012, sqid02=10307013, sqid03=10307014, sqid04=10307012, sfid=30505806},
			{sqid01=10307015, sqid02=10307016, sqid03=10307017, sqid04=10307018, sfid=30505806},
			{sqid01=10307019, sqid02=10307020, sqid03=10307021, sqid04=10307022, sfid=30505806},
			{sqid01=10307023, sqid02=10307023, sqid03=10307023, sqid04=10307023, sfid=30505806},
			{sqid01=10307024, sqid02=10307025, sqid03=10307026, sqid04=10307027, sfid=30505806},
			{sqid01=10307028, sqid02=10307029, sqid03=10307030, sqid04=10307031, sfid=30505806},
			{sqid01=10307032, sqid02=10307033, sqid03=10307034, sqid04=10307035, sfid=30505806},
			{sqid01=10307036, sqid02=10307037, sqid03=10307038, sqid04=10307039, sfid=30505806},
			{sqid01=10307040, sqid02=10307041, sqid03=10307041, sqid04=10307041, sfid=30505806},

			--新门派神器桃花岛
			{sqid01=10308000, sqid02=10308000, sqid03=10308000, sqid04=10308000, sfid=30505800},
			{sqid01=10308001, sqid02=10308001, sqid03=10308001, sqid04=10308001, sfid=30505801},
			{sqid01=10308002, sqid02=10308002, sqid03=10308002, sqid04=10308002, sfid=30505802},
			{sqid01=10308003, sqid02=10308003, sqid03=10308003, sqid04=10308003, sfid=30505803},
			{sqid01=10308004, sqid02=10308006, sqid03=10308008, sqid04=10308010, sfid=30505804},
			{sqid01=10308005, sqid02=10308007, sqid03=10308009, sqid04=10308011, sfid=30505805},
			{sqid01=10308012, sqid02=10308013, sqid03=10308014, sqid04=10308012, sfid=30505806},
			{sqid01=10308015, sqid02=10308016, sqid03=10308017, sqid04=10308018, sfid=30505806},
			{sqid01=10308019, sqid02=10308020, sqid03=10308021, sqid04=10308022, sfid=30505806},
			{sqid01=10308023, sqid02=10308023, sqid03=10308023, sqid04=10308023, sfid=30505806},
			{sqid01=10308024, sqid02=10308025, sqid03=10308026, sqid04=10308027, sfid=30505806},
			{sqid01=10308028, sqid02=10308029, sqid03=10308030, sqid04=10308031, sfid=30505806},
			{sqid01=10308032, sqid02=10308033, sqid03=10308034, sqid04=10308035, sfid=30505806},
			{sqid01=10308036, sqid02=10308037, sqid03=10308038, sqid04=10308039, sfid=30505806},
			{sqid01=10308040, sqid02=10308041, sqid03=10308041, sqid04=10308041, sfid=30505806},

			--九星神器
			{sqid01=10300423, sqid02=10300424, sqid03=10300425, sqid04=10300426, sfid=30505806},
			{sqid01=10300427, sqid02=10300428, sqid03=10300429, sqid04=10300430, sfid=30505806},
			{sqid01=10300431, sqid02=10301444, sqid03=10301445, sqid04=10301446, sfid=30505806},
			{sqid01=10301447, sqid02=10301448, sqid03=10301449, sqid04=10301450, sfid=30505806},
			{sqid01=10301451, sqid02=10301452, sqid03=10301453, sqid04=10301454, sfid=30505806},
			{sqid01=10301455, sqid02=10301456, sqid03=10301457, sqid04=10301458, sfid=30505806},
			{sqid01=10301459, sqid02=10301460, sqid03=10301461, sqid04=10302449, sfid=30505806},
			{sqid01=10302450, sqid02=10302451, sqid03=10302452, sqid04=10302453, sfid=30505806},
			{sqid01=10302454, sqid02=10302455, sqid03=10302456, sqid04=10302457, sfid=30505806},
			{sqid01=10302458, sqid02=10302459, sqid03=10302460, sqid04=10302461, sfid=30505806},
			{sqid01=10302462, sqid02=10302463, sqid03=10302464, sqid04=10302465, sfid=30505806},
			{sqid01=10302466, sqid02=10303440, sqid03=10303441, sqid04=10303442, sfid=30505806},
			{sqid01=10303443, sqid02=10303444, sqid03=10303445, sqid04=10303446, sfid=30505806},
			{sqid01=10303447, sqid02=10303448, sqid03=10303449, sqid04=10303450, sfid=30505806},
			{sqid01=10303451, sqid02=10303452, sqid03=10303453, sqid04=10303454, sfid=30505806},
			{sqid01=10303455, sqid02=10303456, sqid03=10303457, sqid04=10304427, sfid=30505806},
			{sqid01=10304428, sqid02=10304429, sqid03=10304430, sqid04=10304431, sfid=30505806},
			{sqid01=10304432, sqid02=10304433, sqid03=10304434, sqid04=10304435, sfid=30505806},
			{sqid01=10305445, sqid02=10305446, sqid03=10305447, sqid04=10305448, sfid=30505806},
			{sqid01=10305449, sqid02=10305450, sqid03=10305451, sqid04=10305452, sfid=30505806},
			{sqid01=10305453, sqid02=10305454, sqid03=10305455, sqid04=10305456, sfid=30505806},
			{sqid01=10305457, sqid02=10305458, sqid03=10305459, sqid04=10305460, sfid=30505806},
			{sqid01=10305461, sqid02=10305462, sqid03=10306043, sqid04=10306044, sfid=30505806},
			{sqid01=10306045, sqid02=10306046, sqid03=10306047, sqid04=10306048, sfid=30505806},
			{sqid01=10306049, sqid02=10306050, sqid03=10306051, sqid04=10307043, sfid=30505806},
			{sqid01=10307044, sqid02=10307045, sqid03=10307046, sqid04=10307047, sfid=30505806},
			{sqid01=10307048, sqid02=10307049, sqid03=10307050, sqid04=10307051, sfid=30505806},
			{sqid01=10308043, sqid02=10308044, sqid03=10308045, sqid04=10308046, sfid=30505806},
			{sqid01=10308047, sqid02=10308048, sqid03=10308049, sqid04=10308050, sfid=30505806},
			{sqid01=10308051, sqid02=0, sqid03=0, sqid04=0, sfid=30505806},
		}

local g_ShenQiRepair_Frame_UnifiedPosition;

local g_ShenQiRepair_SuperWeaponStartUpCommandList =
{
	201208094, 201208093, 201208092, 201208091, 201208098
}

function ShenQiRepair_PreLoad()

	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OBJECT_CARED_EVENT",false);
	this:RegisterEvent("PACKAGE_ITEM_CHANGED",false);
	this:RegisterEvent("UPDATE_SHENQI_REPAIR");
	this:RegisterEvent("RESUME_ENCHASE_GEM_EX",false);
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)	--进场景关闭界面
	this:RegisterEvent("BUY_ITEM")				--快捷购买，更新界面

end

function ShenQiRepair_OnLoad()
	ShenQi_BUTTONS = ShenQiRepair_Item
	CaiLiao_BUTTONS = ShenQiRepair_Item02
	g_ShenQiRepair_Frame_UnifiedPosition=ShenQiRepair_Frame:GetProperty("UnifiedPosition");
	--g_ShenQiRepair_YuanBaoPay = 1;
	--ShenQiRepair_YuanBaoPay:SetCheck(g_ShenQiRepair_YuanBaoPay)
end

function ShenQiRepair_OnEvent(event)
--	神器升星互斥
	if ( event == "UI_COMMAND" ) then
		if tonumber(arg0) == 101526358 then
			ShenQi_NPC_ID = Get_XParam_INT(0);
			ShenQi_PARA_PRICE = Get_XParam_INT(1);
			if  ShenQi_PARA_PRICE == -1 then
				ShenQiRepair_DragTitle:SetText("#{INTERFACE_XML_994}")
			--	ShenQiRepair_TiShi:SetText("#{SQXL_030225_01}")
				ShenQiRepair_Clear()
			--	if g_ShenQiRepair_YuanBaoPay == 1 or g_ShenQiRepair_YuanBaoPay == 0 then
			--		ShenQiRepair_YuanBaoPay:SetCheck(g_ShenQiRepair_YuanBaoPay)
			--	end
				this:Show();

				if ShenQi_NPC_ID == -1 then
					--ShenQiRepair_DragTitle:SetText("#{VIPTQ_120221_19}")
				else
					objCared = DataPool : GetNPCIDByServerID(ShenQi_NPC_ID);
					if objCared == -1 then
						PushDebugMessage("server传过来的数据有问题。");
						return;
					end
					BeginCareObject_ShenQiRepair()
				end
			else
				if this:IsVisible() then
					--显示价钱
					--ShenQiRepair_DemandMoney:SetProperty("MoneyNumber", ShenQi_PARA_PRICE)
					ShenQi_PARA_PRICE = -1
				end
			end
		else
			for i, tempValue in g_ShenQiRepair_SuperWeaponStartUpCommandList do
				if tonumber(arg0) == tempValue then
					ShenQiRepair_Close();
					return;
				end
			end
		end

	elseif (event == "OBJECT_CARED_EVENT") then
		if(tonumber(arg0) ~= objCared) then
			return
		end

		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			--取消关心
			ShenQiRepair_Close();
		end

	elseif ( event == "PACKAGE_ITEM_CHANGED" ) then

		if( arg0~= nil and -1 == tonumber(arg0)) then
			return
		end

		if( arg0~= nil ) then
			if (ShenQi_QUALITY == tonumber(arg0) ) then
				ShenQiRepair_Update(1, tonumber(arg0))
			end

			if (CaiLiao_QUALITY == tonumber(arg0) ) then
				ShenQiRepair_Update(2, tonumber(arg0))
			end

		end

	elseif( event == "UPDATE_SHENQI_REPAIR") then

		if arg0 == nil or arg1 == nil then
			return
		end
		ShenQiRepair_Update(tonumber(arg0), tonumber(arg1));

	elseif( event == "RESUME_ENCHASE_GEM_EX" ) then
		if(arg0~=nil and tonumber(arg0) == 128) then
			ShenQiRepair_Resume(1)
		elseif(arg0~=nil and tonumber(arg0) == 129) then
			ShenQiRepair_Mat_Clear()
		end
	elseif event == "BUY_ITEM" and this:IsVisible() then	--快捷购买，更新界面
		local itemId = tonumber(arg1)
		if 38000498 == itemId then
			ShenQiRepair_Update(2,tonumber(PlayerPackage:GetBagPosByItemIndex(itemId)));
		end
	elseif (event == "ADJEST_UI_POS" ) then
		ShenQiRepair_Frame_On_ResetPos()

	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		ShenQiRepair_Frame_On_ResetPos()

	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		ShenQiRepair_Close()

	end
end

function ShenQiRepair_OnShown()
	ShenQiRepair_Clear()
end

function ShenQiRepair_Clear()

		if ShenQi_QUALITY ~= -1 then
			ShenQi_BUTTONS : SetActionItem(-1);
			LifeAbility : Lock_Packet_Item(ShenQi_QUALITY,0);
			ShenQi_QUALITY = -1;
		end
		if CaiLiao_QUALITY ~= -1 then
			CaiLiao_BUTTONS : SetActionItem(-1)
			LifeAbility : Lock_Packet_Item(CaiLiao_QUALITY,0);
			CaiLiao_QUALITY = -1;
		end

		ShenQiRepair_TiShi03:SetText("")
		ShenQiRepair_OK:Disable()
end

function ShenQiRepair_Update(pos0, pos1)

	local pos_packet =tonumber(pos1)
	local pos_ui = tonumber(pos0)
	local theAction = EnumAction(pos_packet, "packageitem");
	local ItemID = PlayerPackage : GetItemTableIndex(pos_packet)

	if ShenQi_QUALITY == -1 and (ItemID < EQUIP_SHENQI_BEGIN or ItemID > EQUIP_SHENQI_END) then
			PushDebugMessage("#{SQXL_030225_08}")
			return
	end

	if pos_ui == 1 then
		--在写代码之前，一定要好好看文档，想好逻辑在写啊，否则，逻辑很麻烦
		if theAction:GetID() ~= 0 then

			for i, item in g_NeedItemBonus do
				if ItemID == item.sqid01
					or ItemID == item.sqid02
					or ItemID == item.sqid03
					or ItemID == item.sqid04 then
					shenfuid = item.sfid
					--新莽神符没有配等级，根据ID计算等级
					shenfu_grade = math.mod(shenfuid,10) + 1
					break
				end
			end

			if ItemID < EQUIP_SHENQI_BEGIN or ItemID > EQUIP_SHENQI_END then
				if shenfu_grade == 7 then
					PushDebugMessage("#{SQXL_160901_14}")
				else
					local strdic = ""
					strdic = ScriptGlobal_Format("#{SQXL_030225_10}", shenfu_grade)
					PushDebugMessage(strdic)
				end
				return
			end

			-- 15级神器不需要修理 by lishilong 2016-8-23
			if 10300422 == ItemID or 10302448 == ItemID or 10304426 == ItemID
				or 10305444 == ItemID or 10306042 == ItemID or 10307042 == ItemID or 10308042 == ItemID then
				PushDebugMessage("此神器不需要修理")
				return
			end

			local ShenQiPoint = LifeAbility:Get_Equip_Point(pos_packet)
			if ShenQiPoint == -1 or ShenQiPoint == 8 or ShenQiPoint == 9 or ShenQiPoint == 10
				or PlayerPackage:IsBagItemKFS(pos_packet) ==1 then --武魂的限制
				if ShenQiPoint ~= -1 then
					PushDebugMessage("此物品不需要修理。")
				end
				return
			end
			local nDurValue,nDurMaxValue = theAction:GetEquipDurValue()
			if nDurValue>=nDurMaxValue then
				PushDebugMessage("#{SQXL_030225_11}")
				return
			end
			ShenQi_BUTTONS:SetActionItem(theAction:GetID());



			local strdic = ""
			if shenfu_grade == 7 then
				strdic = "#{SQXL_160901_13}"
			else
				strdic = ScriptGlobal_Format("#{SQXL_030225_05}", shenfu_grade) --需要1瓶神魂液或1个#{_ITEM%s0}#H
			end
		--	if IsTBFinalServer() >= 1 then
		--		--T服跨服战总决赛特写
		--		strdic = "无需消耗"
		--	end
			ShenQiRepair_TiShi03:SetText( strdic );
			if ShenQi_QUALITY ~= -1 then
				LifeAbility : Lock_Packet_Item(ShenQi_QUALITY,0);
			end
			--让之前的东西变亮
			ShenQi_QUALITY = pos_packet;
			LifeAbility : Lock_Packet_Item(ShenQi_QUALITY,1);

			--材料拿下来
			if CaiLiao_QUALITY ~= -1 then
					CaiLiao_BUTTONS:SetActionItem(-1);
					LifeAbility : Lock_Packet_Item(CaiLiao_QUALITY,0);
					CaiLiao_QUALITY = -1;
			end
			ShenQiRepair_OK:Disable()
			--ShenQiRepair_OK:Enable()

		else

			ShenQi_BUTTONS:SetActionItem(-1);
			LifeAbility : Lock_Packet_Item(ShenQi_QUALITY,0);
			ShenQi_QUALITY = -1;
			return
		end

	elseif pos_ui == 2 then

		if theAction:GetID() ~= 0 then

			if ShenQi_QUALITY == -1 then
				PushDebugMessage("#{SQXL_030225_08}")
				return
			end

			if ItemID == 38000055 or ItemID == 38000056 or (ItemID >= shenfuid and ItemID <= 30505806)then

				--是否加锁
				if PlayerPackage:IsLock(pos_packet) == 1 then
					local strname = PlayerPackage:GetBagItemName( pos_packet )
					if strname == nil then
        		return
    			end
					local strdic = ScriptGlobal_Format("#{SQXL_030225_09}", strname)
					PushDebugMessage(strdic)
					return
				end

				CaiLiao_BUTTONS:SetActionItem(theAction:GetID());
				if CaiLiao_QUALITY ~= -1 then
					LifeAbility : Lock_Packet_Item(CaiLiao_QUALITY,0);
				end
				--让之前的东西变亮
				CaiLiao_QUALITY = pos_packet;
				LifeAbility : Lock_Packet_Item(CaiLiao_QUALITY,1);
				ShenQiRepair_OK:Enable()

			else
					local strdic = ""
					if shenfu_grade == 7 then
						strdic = "#{SQXL_160901_14}"
					else
						strdic = ScriptGlobal_Format("#{SQXL_030225_10}", shenfu_grade)
					end
					PushDebugMessage(strdic)

			end

		else

			CaiLiao_BUTTONS:SetActionItem(-1);
			LifeAbility : Lock_Packet_Item(CaiLiao_QUALITY,0);
			CaiLiao_QUALITY = -1;
			return;
		end

	end --end pos_ui

end

function ShenQiRepair_Buttons_Clicked()

	local enterID = 2;
	if ShenQi_NPC_ID ~= -1 then enterID = 0; end

	if ShenQi_QUALITY ~= -1 then
		-- [ QUFEI 2007-10-15 15:31 UPDATE BugID 26358 ]

		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("OnEquipRepair");
			Set_XSCRIPT_ScriptID(805027);
			Set_XSCRIPT_Parameter(0,enterID);
			Set_XSCRIPT_Parameter(1,ShenQi_NPC_ID);
			Set_XSCRIPT_Parameter(2,ShenQi_QUALITY);
		--	if IsTBFinalServer() >= 1 then
		--		Set_XSCRIPT_Parameter(3,0);
		--	else
				Set_XSCRIPT_Parameter(3,CaiLiao_QUALITY);
		--	end

		--	Set_XSCRIPT_Parameter(4,tonumber(ShenQiRepair_YuanBaoPay:GetCheck()));
			Set_XSCRIPT_ParamCount(4);
		Send_XSCRIPT();
		LifeAbility : Lock_Packet_Item(ShenQi_QUALITY,0);
	--	if IsTBFinalServer() <= 0 then
			--普通服务器才需要加锁
			LifeAbility : Lock_Packet_Item(CaiLiao_QUALITY,0);
	--	end
		if CaiLiao_QUALITY ~= -1 then
			ShenQiRepair_Clear();
		--	g_ShenQiRepair_YuanBaoPay = ShenQiRepair_YuanBaoPay:GetCheck();
		        this:Hide();
		end
	--	if IsTBFinalServer() > 0 then
	--	        this:Hide();
	--	end
	else
		PushDebugMessage("#{SQXL_030225_08}")
	end

end

function ShenQiRepair_Close()
	ShenQiRepair_Clear();
	StopCareObject_ShenQiRepair()
	ShenQi_NPC_ID = -1
--	g_ShenQiRepair_YuanBaoPay = ShenQiRepair_YuanBaoPay:GetCheck();
	this:Hide();
end

function ShenQiRepair_Cancel_Clicked()
	ShenQiRepair_Close();
	return
end

--=========================================================
--开始关心NPC，
--在开始关心之前需要先确定这个界面是不是已经有“关心”的NPC，
--如果有的话，先取消已经有的“关心”
--=========================================================
function BeginCareObject_ShenQiRepair()

	this:CareObject(objCared, 1, "ShenQiRepair");

end

--=========================================================
--停止对某NPC的关心
--=========================================================
function StopCareObject_ShenQiRepair()

	this:CareObject(objCared, 0, "ShenQiRepair");
	objCared = -1;

end

function ShenQiRepair_Resume(nIndex)
	if( this:IsVisible() ) then
		ShenQiRepair_Clear();
	end
end

function ShenQiRepair_Frame_On_ResetPos()
  ShenQiRepair_Frame:SetProperty("UnifiedPosition", g_ShenQiRepair_Frame_UnifiedPosition);
end

function ShenQiRepair_Item_RClick()
	ShenQiRepair_Clear()
end

function ShenQiRepair_Mat_Clear()
	if CaiLiao_QUALITY ~= -1 then
		CaiLiao_BUTTONS : SetActionItem(-1)
		LifeAbility : Lock_Packet_Item(CaiLiao_QUALITY,0);
		CaiLiao_QUALITY = -1;
	end
	--ShenQiRepair_OK 等不变
end

function ShenQiRepair_Mat_RClick()
	ShenQiRepair_Mat_Clear()
end
