CooldownCount_SideBarsSideCount = 0;
CooldownCount_AutoScaleSideBars = 1;
CooldownCount_SideBarOffset = 36*1.5;

CooldownCountSideBar_Saved_GenerateButtonUpdateList = nil;
CooldownCountSideBar_BarName = "SideBarButton";
CooldownCountSideBar_ButtonNameFormat = "SideBar%sButton%d";
CooldownCountSideBar_NumberOfButtons = 12;
CooldownCountSideBar_NumberOfBars = 12;
CooldownCountSideBar_NormalBar = 0;

function CooldownCountSideBar_OnLoad()
	if ( CooldownCountSideBar_NormalBar == 1 ) then
		table.insert(CooldownCount_ButtonNames, CooldownCountSideBar_BarName);
	else
		CooldownCountSideBar_Saved_GenerateButtonUpdateList = CooldownCount_GenerateButtonUpdateList;
		CooldownCount_GenerateButtonUpdateList = CooldownCountSideBar_GenerateButtonUpdateList;
	end
	CooldownCount_RegenerateList();


end

function CooldownCountSideBar_Register()
	if ( ( Cosmos_UpdateValue ) and ( Cosmos_RegisterConfiguration ) and ( CooldownCount_Cosmos_Registered == 0 ) ) then
		Cosmos_RegisterConfiguration(
			"COS_COOLDOWNCOUNT_SIDECOUNT",
			"CHECKBOX",
			TEXT(COOLDOWNCOUNT_SIDECOUNT),
			TEXT(COOLDOWNCOUNT_SIDECOUNT_INFO),
			CooldownCount_Toggle_SideCount,
			CooldownCount_SideBarsSideCount
		);
		Cosmos_RegisterConfiguration(
			"COS_COOLDOWNCOUNT_AUTOSCALESIDEBARS",
			"CHECKBOX",
			TEXT(COOLDOWNCOUNT_AUTOSCALESIDEBARS),
			TEXT(COOLDOWNCOUNT_AUTOSCALESIDEBARS_INFO),
			CooldownCount_Toggle_AutoScaleSideBars,
			CooldownCount_AutoScaleSideBars
		);
		Cosmos_RegisterConfiguration(
			"COS_COOLDOWNCOUNT_SIDEBAROFFSET",
			"SLIDER",
			TEXT(COOLDOWNCOUNT_SIDEBAROFFSET),
			TEXT(COOLDOWNCOUNT_SIDEBAROFFSET_INFO),
			function (checked, value) CooldownCount_SetSideBarOffset(value); end,
			1,
			CooldownCount_SideBarOffset,
			1,
			200,
			COOLDOWNCOUNT_SIDEBAROFFSET_SLIDER_DESCRIPTION,
			1,
			1,
			COOLDOWNCOUNT_SIDEBAROFFSET_SLIDER_APPEND,
			1
		);
	end
end

function CooldownCountSideBar_GenerateButtonUpdateList()
	local updateList = CooldownCountSideBar_Saved_GenerateButtonUpdateList();
	local sideBarFormatStr = "SideBar%sButton%d";
	local sideBarStr = "";
	local tmpSideBarButton = "";
	for i = 1, CooldownCountSideBar_NumberOfButtons do
		if ( i >= 7 ) then
			tmpSideBarButton = format(sideBarFormatStr, "2", i-6);
		else
			tmpSideBarButton = format(sideBarFormatStr, "", i);
		end
		if ( getglobal(tmpSideBarButton) ) then
			table.insert(updateList, tmpSideBarButton);
		end
	end
	return updateList;
end
