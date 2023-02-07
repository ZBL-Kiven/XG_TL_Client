
local ViewSetup = {};
local viewSetNum = 15;
local g_ViewSetup_Setup_Frame_UnifiedPosition;

--===============================================
-- OnLoad()
--===============================================
function ViewSetup_Setup_PreLoad()

	this:RegisterEvent("OPEN_OPTIMIZE")
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function ViewSetup_Setup_OnLoad()
		
		ViewSetup[1]   = "dxyy" 	--地形阴影				View_LightmapQuality
		ViewSetup[2]   = "fhj"		--全屏抗锯齿			View_Fanhunjiao
		ViewSetup[3]   = "wtdh"		--物体动画				View_ObjectMove
		ViewSetup[4]   = "rwyy"		--人物阴影				View_HumanLightmap
		ViewSetup[5]   = "ksfw"		--显示模型数 可视范围	View_VisibleRangeLevelNew
		ViewSetup[6]   = "dhgxzl"	--角色动画				View_UpdateQuality
		ViewSetup[7]   = "yszl"		--颜色质量	比特数		View_ColorQuality
		ViewSetup[8]  = "cy"		 	--采样					View_TextureFiltering
		ViewSetup[9]  = "txdjsz"	--粒子效果				View_EffectLevel
	--	ViewSetup[10]  = "mxxslj"	--模型显示				View_ModelShowLogic

		ViewSetup[10]   = "qpfg"	-- 全屏泛光
		ViewSetup[11]   = "rt"	-- 柔体
		ViewSetup[12]   = "miwu"	-- 显示迷雾
		ViewSetup[13]   = "zdbt"	-- 遮挡半透
		ViewSetup[14]   = "qpms"	-- 全屏模式
		ViewSetup[15]   = "cztb"	-- 垂直同步
		
		g_ViewSetup_Setup_Frame_UnifiedPosition=ViewSetup_Setup_Frame:GetProperty("UnifiedPosition");
			
end

--===============================================
-- OnEvent()
--===============================================
function ViewSetup_Setup_OnEvent(event)

	if ( event == "OPEN_OPTIMIZE" ) then
		this:Show();
		
	elseif (event == "ADJEST_UI_POS" ) then
		ViewSetup_Setup_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		ViewSetup_Setup_Frame_On_ResetPos()
	end

end

--显示设置 nIndex 1速度优先 2均衡设置
function ViewSetup_Setup_ClickViewSetup(nIndex)

	if( nIndex == 1 )then
		local setting =  {0, 0, 0, 0, 2, 0, 0, 0, 0,  0, 0, 1, 0, 0, 1}	--速度优先; 

		local bNeedReset1 = tonumber(SystemSetup:View_GetData(ViewSetup[2])) ~= setting[2];
		local bNeedReset2 = tonumber(SystemSetup:View_GetData(ViewSetup[15])) ~= setting[15];

		if(bNeedReset1 or bNeedReset2) then
			PushDebugMessage("部分设置需要重启");
		end

		for i=1, viewSetNum do
			SystemSetup:View_SetData(ViewSetup[i], setting[i]);
		end
	
	else
		local setting = {2, 0, 2, 2, 2, 2, 2, 2, 2,  0, 0, 1, 0, 0, 1}	--均衡设置

		local bNeedReset1 = tonumber(SystemSetup:View_GetData(ViewSetup[2])) ~= setting[2];
		local bNeedReset2 = tonumber(SystemSetup:View_GetData(ViewSetup[15])) ~= setting[15];

		if(bNeedReset1 or bNeedReset2) then
			PushDebugMessage("部分设置需要重启");
		end
	
		for i=1, viewSetNum do
			SystemSetup:View_SetData(ViewSetup[i], setting[i]);
		end
	end

--更新操作
		SystemSetup:OptimizeConfirm()
end

--关闭天空视角
function ViewSetup_Setup_CloseSkyEye()

		local string = "tksj";	
	  SystemSetup:View_SetData( string, 0);
	  
	 SystemSetup:OptimizeConfirm()
	
end


--分辨率 nIndex 1-1024*768 2-800*600
function ViewSetup_Setup_ScreenSize(nIndex)
			
	--全屏模式的话,要先改为非全屏
	local  bFullScreen = SystemSetup:View_GetData(ViewSetup[14]);
	if bFullScreen ~= 0 then
		SystemSetup:View_SetData(ViewSetup[14], 0);
	end
	
	if nIndex == 1 then
			Variable:SetVariable("View_Resoution", "", 0);
			Variable:SetVariable("View_Resoution", "1024,768", 0);
	else
			Variable:SetVariable("View_Resoution", "", 0);
			Variable:SetVariable("View_Resoution", "800,600", 0);
	end
	
	SystemSetup:OptimizeConfirm()
end

function ViewSetup_Setup_Frame_On_ResetPos()
  ViewSetup_Setup_Frame:SetProperty("UnifiedPosition", g_ViewSetup_Setup_Frame_UnifiedPosition);
end


