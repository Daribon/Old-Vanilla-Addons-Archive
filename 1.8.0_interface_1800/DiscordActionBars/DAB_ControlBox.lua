function DAB_ControlBox_Initialize(box)
	local settings = DAB_Settings[DAB_INDEX].Bar[box].controlbox;
	local boxname = "DAB_ControlBox_"..box;
	local boxframe = getglobal(boxname);

	if (settings.hide) then
		boxframe:Hide();
	else
		boxframe:Show();
	end

	boxframe:SetHeight(settings.height);
	boxframe:SetWidth(settings.width);

	if (settings.attachframe) then
		boxframe:ClearAllPoints();
		boxframe:SetPoint(settings.attachpoint, settings.attachframe, settings.attachto, settings.attachoffsetx, settings.attachoffsety);
	else
		boxframe:ClearAllPoints();
		boxframe:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", DAB_Settings[DAB_INDEX].FrameLocation[boxname].x, DAB_Settings[DAB_INDEX].FrameLocation[boxname].y);
	end

	getglobal(boxname.."_Text"):SetText(settings.text);
	getglobal(boxname.."_Text"):SetTextColor(settings.textcolor.r, settings.textcolor.g, settings.textcolor.b, settings.alpha);
	getglobal(boxname.."_Text"):SetTextHeight(settings.fontheight);
	local origScale = getglobal(boxname):GetScale();
	getglobal(boxname):SetScale(origScale + 1);
	getglobal(boxname):SetScale(origScale);

	getglobal(boxname.."_Background"):SetAlpha(settings.bgalpha);
	getglobal(boxname.."_Background"):SetVertexColor(settings.bgcolor.r, settings.bgcolor.g, settings.bgcolor.b);
	for _,border in DAB_BORDERS do
		getglobal(boxname..border):SetAlpha(settings.borderalpha);
		getglobal(boxname..border):SetVertexColor(settings.bordercolor.r, settings.bordercolor.g, settings.bordercolor.b);
	end

	if (settings.bottom) then
		getglobal(boxname.."_Bottom"):Show();
	else
		getglobal(boxname.."_Bottom"):Hide();
	end
	if (settings.left) then
		getglobal(boxname.."_Left"):Show();
	else
		getglobal(boxname.."_Left"):Hide();
	end
	if (settings.right) then
		getglobal(boxname.."_Right"):Show();
	else
		getglobal(boxname.."_Right"):Hide();
	end
	if (settings.top) then
		getglobal(boxname.."_Top"):Show();
	else
		getglobal(boxname.."_Top"):Hide();
	end
end

function DAB_ControlBox_OnClick(bar)
	if (not bar) then
		bar=this:GetID();
	end
	local settings = DAB_Settings[DAB_INDEX].Bar[bar].controlbox;
	if (settings.baronclick) then
		DAB_Bar_Toggle(bar);
	end
	if (settings.hideotherbars) then
		for i = 1, DAB_NUMBER_OF_BARS do
			if (i ~= bar) then
				if (DAB_Settings[DAB_INDEX].Bar[i].controlbox.baronclick) then
					DAB_Bar_Hide(i);
				end
			end
		end
	end
	if (settings.macroonclick and settings.macroonclick ~= "") then
		DAB_Run_Macro(settings.macroonclick);
	end
end

function DAB_ControlBox_OnKeyPressed(box, uptoggle)
	if (uptoggle) then
		if (DAB_Settings[DAB_INDEX].Bar[box].controlbox.mouseovershowbar) then
			DAB_Bar_Hide(box);
		end
	else
		if (DAB_Settings[DAB_INDEX].Bar[box].controlbox.mouseovershowbar) then
			DAB_Bar_Show(box);
		else
			DAB_Bar_Toggle(box);
		end
	end
end

function DAB_ControlBox_OnEnter()
	local settings = DAB_Settings[DAB_INDEX].Bar[this:GetID()].controlbox;
	if (settings.mouseovershowbar) then
		DAB_Bar_Show(this:GetID());
	end
	if (settings.recolor) then
		getglobal(this:GetName().."_Background"):SetVertexColor(settings.mouseovercolor.r, settings.mouseovercolor.g, settings.mouseovercolor.b);
	end
	if (settings.textrecolor) then
		getglobal(this:GetName().."_Text"):SetTextColor(settings.textmouseovercolor.r, settings.textmouseovercolor.g, settings.textmouseovercolor.b);
	end
end

function DAB_ControlBox_OnLeave()
	local settings = DAB_Settings[DAB_INDEX].Bar[this:GetID()].controlbox;
	if (settings.mouseovershowbar) then
		getglobal("DAB_ActionBar_"..this:GetID()).timer = DAB_Settings[DAB_INDEX].Timeout;
	end
	if (settings.recolor) then
		getglobal(this:GetName().."_Background"):SetVertexColor(settings.bgcolor.r, settings.bgcolor.g, settings.bgcolor.b);
	end
	if (settings.textrecolor) then
		getglobal(this:GetName().."_Text"):SetTextColor(settings.textcolor.r, settings.textcolor.g, settings.textcolor.b);
	end
end