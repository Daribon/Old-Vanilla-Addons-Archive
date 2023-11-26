
Titan Panel Recap 2.6+ plugin

All files in this directory are used for the Recap plugin for Titan Panel

If you don't use Titan Panel you can safely delete this directory

To Gello:

Added to Recap.lua in the Recap addon core:

-=-=-

function Recap_GetTitan_Tooltip()
	return recap_temp.Local.LastAll[recap.Opt.View.value]..":\nYour DPS: ".."\t"..Recap_GetHighlightText(RecapMinYourDPS_Text:GetText()).."\nMax hit: ".."\t"..Recap_GetHighlightText(RecapTotals_MaxHit:GetText()).."\nTotal DPS Out: ".."\t"..Recap_GetHighlightText(RecapTotals_DPS:GetText()).."\nTotal DPS In: ".."\t"..Recap_GetHighlightText(RecapTotals_DPSIn:GetText());
end

function Recap_GetHighlightText(text)
	if (text) then
		return HIGHLIGHT_FONT_COLOR_CODE..text..FONT_COLOR_CODE_CLOSE;
	end
end
