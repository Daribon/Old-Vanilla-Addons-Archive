--[[
	Title:
		ItemCount 1.10(1300)

	Description:

		Provides UltimateUI style stack size numbering.
		Example: A stack of 1200 will display 1.2k not *.
		All credit to UltimateUI team for original code.

	Author:
	
		Milena of Garona

	Release History:

		Version 1.00(1300)	3/23/2005 3:41PM
			Initial version.
		Version 1.10(1300)	3/25/2005 8:20PM
			Corrected offset for ammo display on paper doll.
]]

function ItemCount_OnLoad()
	SetItemButtonCount = ItemCount_SetItemButtonCount;
	CharacterAmmoSlotCount:ClearAllPoints();
	CharacterAmmoSlotCount:SetPoint( "BOTTOMRIGHT", "CharacterAmmoSlot", "BOTTOMRIGHT", -2, 2 );
end

function ItemCount_SetItemButtonCount( button, count )
	if( not button ) then
		return;
	end
	if( not count ) then
		count = 0;
	end
	button.count = count;
	if( count > 1 or ( button.isBag and count > 0 )) then
		if( count > 999 ) then
			local fixedCount = count+50;
			count = floor(( fixedCount ) / 1000 ).."."..floor((( mod( fixedCount, 1000 )) / 100 )).."k";
		end
		getglobal( button:GetName().."Count" ):SetText( count );
		getglobal( button:GetName().."Count" ):Show();
	else
		getglobal( button:GetName().."Count" ):Hide();
	end
end