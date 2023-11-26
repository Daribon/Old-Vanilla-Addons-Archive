
function DAB_Options_LoadCustomSettings()
	DAB_Settings[DAB_INDEX] = {};


	DAB_Settings[DAB_INDEX] = {
	["BagOffsetX"] = 0,
	["EventMacros"] = {
		["UNIT_HEALTH"] = "if arg1==\"player\" then if UnitHealth(\"player\")/UnitHealthMax(\"player\") < .50 then DAB_Bar_Show(5) else DAB_Bar_Hide(5) end end ",
	},
	["BagOffsetY"] = 0,
	["MinCooldownCount"] = 4,
	["ShowCooldownCount"] = true,
	["INITIALIZED2.3"] = true,
	["INITIALIZED2.2"] = true,
	["Timeout"] = 0.5,
	["OptionsScale"] = 80,
	["Button"] = {
		[1] = 1,
		[2] = 1,
		[3] = 1,
		[4] = 1,
		[5] = 1,
		[6] = 1,
		[7] = 1,
		[8] = 1,
		[9] = 1,
		[10] = 1,
		[11] = 1,
		[12] = 1,
		[13] = 2,
		[14] = 2,
		[15] = 2,
		[16] = 2,
		[17] = 2,
		[18] = 2,
		[22] = 4,
		[23] = 4,
		[24] = 2,
		[25] = 3,
		[26] = 3,
		[27] = 3,
		[28] = 3,
		[29] = 3,
		[30] = 3,
		[31] = 3,
		[49] = 5,
		[50] = 5,
		[51] = 5,
		[61] = 6,
		[62] = 6,
		[63] = 6,
		[64] = 6,
		[82] = 7,
		[84] = 7,
		[86] = 8,
		[119] = 9,
		[81] = 7,
		[117] = 9,
		[98] = 9,
		[100] = 9,
		[87] = 8,
		[73] = 7,
		[75] = 7,
		[108] = 9,
		[110] = 10,
		[112] = 10,
		[83] = 7,
		[85] = 8,
		[118] = 9,
		[120] = 8,
		[116] = 9,
		[93] = 7,
		[115] = 7,
		[97] = 9,
		[99] = 9,
		[114] = 7,
		[113] = 7,
		[74] = 7,
		[76] = 7,
		[109] = 10,
		[111] = 10,
		[88] = 8,
	},
	["OutOfRangeColor"] = {
		["b"] = 0.1,
		["g"] = 0.1,
		["r"] = 1,
	},
	["OutOfManaColor"] = {
		["b"] = 1,
		["g"] = 0.5,
		["r"] = 0.5,
	},
	["INITIALIZED2.1"] = true,
	["ModifyCooldownByUIScale"] = true,
	["HideKeybindings"] = true,
	["Floaters"] = {
	},
	["UnusableColor"] = {
		["b"] = 0.4,
		["g"] = 0.4,
		["r"] = 0.4,
	},
	["OtherBar"] = {
		[12] = {
			["attachoffsety"] = 0,
			["spacingv"] = 0,
			["attachpoint"] = "TOPLEFT",
			["alpha"] = 1,
			["attachoffsetx"] = 0,
			["size"] = 30,
			["layout"] = 1,
			["background"] = {
				["style"] = 1,
				["borderalpha"] = 0,
				["color"] = {
					["b"] = 0,
					["g"] = 0,
					["r"] = 0.7,
				},
				["bordercolor"] = {
					["b"] = 0,
					["g"] = 1,
					["r"] = 1,
				},
				["alpha"] = 0,
			},
			["attachto"] = "TOPLEFT",
			["spacingh"] = 0,
			["padding"] = 10,
			["label"] = {
				["attachoffsety"] = 0,
				["bgcolor"] = {
					["b"] = 0,
					["g"] = 0,
					["r"] = 0.7,
				},
				["borderalpha"] = 1,
				["color"] = {
					["b"] = 0,
					["g"] = 1,
					["r"] = 1,
				},
				["attachpoint"] = "BOTTOMLEFT",
				["alpha"] = 1,
				["attachoffsetx"] = 0,
				["attachto"] = "TOPLEFT",
				["bgalpha"] = 1,
				["text"] = "Shapeshift Bar",
				["bordercolor"] = {
					["b"] = 0,
					["g"] = 0.7,
					["r"] = 0.7,
				},
				["textsize"] = 12,
			},
			["hide"] = true,
		},
		[14] = {
			["attachoffsety"] = 0,
			["size"] = 30,
			["label"] = {
				["attachoffsety"] = 0,
				["bgcolor"] = {
					["b"] = 0,
					["g"] = 0,
					["r"] = 0.7,
				},
				["borderalpha"] = 1,
				["color"] = {
					["b"] = 0,
					["g"] = 1,
					["r"] = 1,
				},
				["attachpoint"] = "BOTTOMLEFT",
				["alpha"] = 1,
				["attachoffsetx"] = 0,
				["attachto"] = "TOPLEFT",
				["bgalpha"] = 1,
				["text"] = "Menu Bar",
				["bordercolor"] = {
					["b"] = 0,
					["g"] = 0.7,
					["r"] = 0.7,
				},
				["textsize"] = 12,
			},
			["layout"] = 1,
			["attachpoint"] = "TOPLEFT",
			["alpha"] = 1,
			["attachoffsetx"] = 0,
			["background"] = {
				["style"] = 1,
				["borderalpha"] = 0,
				["color"] = {
					["b"] = 0,
					["g"] = 0,
					["r"] = 0.7,
				},
				["bordercolor"] = {
					["b"] = 0,
					["g"] = 1,
					["r"] = 1,
				},
				["alpha"] = 0,
			},
			["mouseoverbar"] = true,
			["spacingh"] = 0,
			["attachto"] = "TOPLEFT",
			["hidelabel"] = true,
			["padding"] = 10,
			["spacingv"] = 0,
			["hide"] = true,
		},
		[11] = {
			["attachoffsety"] = 0,
			["spacingv"] = 0,
			["attachpoint"] = "TOPLEFT",
			["alpha"] = 1,
			["attachoffsetx"] = 0,
			["hidelabel"] = true,
			["label"] = {
				["attachoffsety"] = 0,
				["bgcolor"] = {
					["b"] = 0,
					["g"] = 0,
					["r"] = 0.7,
				},
				["borderalpha"] = 1,
				["color"] = {
					["b"] = 0,
					["g"] = 1,
					["r"] = 1,
				},
				["attachpoint"] = "BOTTOMLEFT",
				["alpha"] = 1,
				["attachoffsetx"] = 0,
				["attachto"] = "TOPLEFT",
				["bgalpha"] = 1,
				["text"] = "Pet Action Bar",
				["bordercolor"] = {
					["b"] = 0,
					["g"] = 0.7,
					["r"] = 0.7,
				},
				["textsize"] = 12,
			},
			["background"] = {
				["style"] = 1,
				["borderalpha"] = 0,
				["color"] = {
					["b"] = 0,
					["g"] = 0,
					["r"] = 0.7,
				},
				["bordercolor"] = {
					["b"] = 0,
					["g"] = 1,
					["r"] = 1,
				},
				["alpha"] = 0,
			},
			["attachto"] = "TOPLEFT",
			["layout"] = 4,
			["padding"] = 10,
			["spacingh"] = 0,
			["size"] = 16,
		},
		[13] = {
			["attachoffsety"] = 0,
			["label"] = {
				["attachoffsety"] = 0,
				["bgcolor"] = {
					["b"] = 0,
					["g"] = 0,
					["r"] = 0.7,
				},
				["borderalpha"] = 1,
				["color"] = {
					["b"] = 0,
					["g"] = 1,
					["r"] = 1,
				},
				["attachpoint"] = "BOTTOMLEFT",
				["alpha"] = 1,
				["attachoffsetx"] = 0,
				["attachto"] = "TOPLEFT",
				["bgalpha"] = 1,
				["text"] = "Bag Bar",
				["bordercolor"] = {
					["b"] = 0,
					["g"] = 0.7,
					["r"] = 0.7,
				},
				["textsize"] = 12,
			},
			["attachpoint"] = "TOPLEFT",
			["alpha"] = 1,
			["attachoffsetx"] = 0,
			["hide"] = true,
			["spacingv"] = 0,
			["background"] = {
				["style"] = 1,
				["borderalpha"] = 0,
				["color"] = {
					["b"] = 0,
					["g"] = 0,
					["r"] = 0.7,
				},
				["bordercolor"] = {
					["b"] = 0,
					["g"] = 1,
					["r"] = 1,
				},
				["alpha"] = 0,
			},
			["spacingh"] = 0,
			["layout"] = 1,
			["padding"] = 10,
			["attachto"] = "TOPLEFT",
			["size"] = 30,
		},
	},
	["FrameLocation"] = {
		["DAB_ActionButton_44"] = {
			["y"] = -1399.99990284443,
			["x"] = 782.5000646337858,
		},
		["DAB_OtherBar_Pet"] = {
			["y"] = -1091.000779107201,
			["x"] = 675.0001425296047,
		},
		["DAB_OtherBar_Menu"] = {
			["y"] = -32.99995373189518,
			["x"] = 668.9999289959679,
		},
		["DAB_ActionButton_60"] = {
			["y"] = -1399.99990284443,
			["x"] = 782.5000646337858,
		},
		["DAB_ActionButton_80"] = {
			["y"] = -1399.99990284443,
			["x"] = 782.5000646337858,
		},
		["DAB_ActionButton_90"] = {
			["y"] = -1399.99990284443,
			["x"] = 782.5000646337858,
		},
		["DAB_ActionButton_58"] = {
			["y"] = -1399.99990284443,
			["x"] = 782.5000646337858,
		},
		["DAB_OtherBar_Form"] = {
			["y"] = -588.9999683350329,
			["x"] = 888.9999257177126,
		},
		["DAB_ActionButton_33"] = {
			["y"] = -1399.99990284443,
			["x"] = 771.5000037625432,
		},
		["DAB_ActionButton_43"] = {
			["y"] = -1399.99990284443,
			["x"] = 782.5000646337858,
		},
		["DAB_ActionButton_95"] = {
			["y"] = -1399.99990284443,
			["x"] = 784.5000340864058,
		},
		["DAB_ActionButton_102"] = {
			["y"] = -1399.99990284443,
			["x"] = 782.5000646337858,
		},
		["DAB_ActionButton_103"] = {
			["y"] = -1399.99990284443,
			["x"] = 782.5000646337858,
		},
		["DAB_ActionButton_54"] = {
			["y"] = -1399.99990284443,
			["x"] = 782.5000646337858,
		},
		["DAB_ActionButton_116"] = {
			["y"] = -1399.99990284443,
			["x"] = 782.5000646337858,
		},
		["DAB_ActionButton_35"] = {
			["y"] = -1399.99990284443,
			["x"] = 781.0000493973487,
		},
		["DAB_ActionButton_46"] = {
			["y"] = -1399.99990284443,
			["x"] = 781.0000493973487,
		},
		["DAB_ActionButton_92"] = {
			["y"] = -1399.99990284443,
			["x"] = 782.5000646337858,
		},
		["DAB_ActionBar_7"] = {
			["y"] = -992.9985279888133,
			["x"] = 1365.001200363022,
		},
		["DAB_ActionButton_108"] = {
			["y"] = -1399.99990284443,
			["x"] = 768.0000190734861,
		},
		["DAB_ControlBox_3"] = {
			["y"] = -150,
			["x"] = 150,
		},
		["DAB_ActionButton_120"] = {
			["y"] = -1399.99990284443,
			["x"] = 782.5000646337858,
		},
		["DAB_ActionButton_105"] = {
			["y"] = -1399.99990284443,
			["x"] = 782.5000646337858,
		},
		["DAB_ActionButton_114"] = {
			["y"] = -1399.99990284443,
			["x"] = 782.5000646337858,
		},
		["DAB_ActionButton_81"] = {
			["y"] = -1399.99990284443,
			["x"] = 782.5000646337858,
		},
		["DAB_ControlBox_9"] = {
			["y"] = -939.9994900822715,
			["x"] = 1263.000698342909,
		},
		["DAB_ActionButton_107"] = {
			["y"] = -1399.99990284443,
			["x"] = 768.0000190734861,
		},
		["DAB_ActionButton_66"] = {
			["y"] = -1399.99990284443,
			["x"] = 782.5000646337858,
		},
		["DAB_ActionButton_78"] = {
			["y"] = -1399.99990284443,
			["x"] = 782.5000646337858,
		},
		["DAB_ActionButton_32"] = {
			["y"] = -1399.99990284443,
			["x"] = 771.5000037625432,
		},
		["DAB_ActionButton_24"] = {
			["y"] = -1399.99990284443,
			["x"] = 780.5000188872216,
		},
		["DAB_ActionBar_6"] = {
			["y"] = -857.9997507035769,
			["x"] = 701.9998827278631,
		},
		["DAB_ActionBar_3"] = {
			["y"] = -1032.001003146157,
			["x"] = 695.0005999952465,
		},
		["DAB_ActionButton_79"] = {
			["y"] = -1399.99990284443,
			["x"] = 782.5000646337858,
		},
		["DAB_ActionButton_91"] = {
			["y"] = -1399.99990284443,
			["x"] = 782.5000646337858,
		},
		["DAB_ActionButton_83"] = {
			["y"] = -1399.99990284443,
			["x"] = 782.5000646337858,
		},
		["DAB_ActionButton_96"] = {
			["y"] = -1399.99990284443,
			["x"] = 784.5000340864058,
		},
		["DAB_ActionButton_38"] = {
			["y"] = -1399.99990284443,
			["x"] = 781.0000493973487,
		},
		["DAB_ActionButton_68"] = {
			["y"] = -1399.99990284443,
			["x"] = 782.5000646337858,
		},
		["DAB_ActionButton_101"] = {
			["y"] = -1399.99990284443,
			["x"] = 782.5000646337858,
		},
		["DAB_ActionButton_47"] = {
			["y"] = -1399.99990284443,
			["x"] = 781.0000493973487,
		},
		["DAB_ActionBar_4"] = {
			["y"] = -497.0004961341546,
			["x"] = 1518.999611154204,
		},
		["DAB_ActionButton_36"] = {
			["y"] = -1399.99990284443,
			["x"] = 768.0000190734861,
		},
		["DAB_ActionButton_84"] = {
			["y"] = -1399.99990284443,
			["x"] = 782.5000646337858,
		},
		["DAB_ControlBox_6"] = {
			["y"] = -300,
			["x"] = 150,
		},
		["DAB_ControlBox_10"] = {
			["y"] = -500,
			["x"] = 150,
		},
		["DAB_ActionButton_21"] = {
			["y"] = -1399.99990284443,
			["x"] = 780.5000188872216,
		},
		["DAB_ActionButton_34"] = {
			["y"] = -1399.99990284443,
			["x"] = 781.0000493973487,
		},
		["DAB_ActionButton_39"] = {
			["y"] = -1399.99990284443,
			["x"] = 781.0000493973487,
		},
		["DAB_ActionButton_89"] = {
			["y"] = -1399.99990284443,
			["x"] = 782.5000646337858,
		},
		["DAB_ActionButton_82"] = {
			["y"] = -1399.99990284443,
			["x"] = 782.5000646337858,
		},
		["DAB_ActionBar_1"] = {
			["y"] = -980.0001952052087,
			["x"] = 627.000227168199,
		},
		["DAB_ActionButton_104"] = {
			["y"] = -1399.99990284443,
			["x"] = 782.5000646337858,
		},
		["DAB_ActionButton_19"] = {
			["y"] = -1399.99990284443,
			["x"] = 780.5000188872216,
		},
		["DAB_ActionButton_55"] = {
			["y"] = -1399.99990284443,
			["x"] = 782.5000646337858,
		},
		["DAB_ActionButton_37"] = {
			["y"] = -1399.99990284443,
			["x"] = 781.0000493973487,
		},
		["DAB_ActionButton_69"] = {
			["y"] = -1399.99990284443,
			["x"] = 782.5000646337858,
		},
		["DAB_ActionBar_5"] = {
			["y"] = -632.9999829381707,
			["x"] = 670.9995169788671,
		},
		["DAB_ActionBar_2"] = {
			["y"] = -1006.002144128052,
			["x"] = 695.0000659376373,
		},
		["DAB_ActionButton_40"] = {
			["y"] = -1399.99990284443,
			["x"] = 782.5000646337858,
		},
		["DAB_ActionButton_22"] = {
			["y"] = -1399.99990284443,
			["x"] = 780.5000188872216,
		},
		["DAB_ActionBar_10"] = {
			["y"] = -821.9998427927517,
			["x"] = 960.9994363635863,
		},
		["DAB_ActionButton_57"] = {
			["y"] = -1399.99990284443,
			["x"] = 782.5000646337858,
		},
		["DAB_ActionBar_9"] = {
			["y"] = -948.9996768683243,
			["x"] = 1253.000164434311,
		},
		["DAB_ActionButton_56"] = {
			["y"] = -1399.99990284443,
			["x"] = 782.5000646337858,
		},
		["DAB_ActionButton_59"] = {
			["y"] = -1399.99990284443,
			["x"] = 782.5000646337858,
		},
		["DAB_ActionButton_20"] = {
			["y"] = -1399.99990284443,
			["x"] = 780.5000188872216,
		},
		["DAB_ActionButton_93"] = {
			["y"] = -1399.99990284443,
			["x"] = 779.5000341609116,
		},
		["DAB_ActionButton_118"] = {
			["y"] = -1399.99990284443,
			["x"] = 782.5000646337858,
		},
		["DAB_ActionButton_77"] = {
			["y"] = -1399.99990284443,
			["x"] = 782.5000646337858,
		},
		["DAB_ControlBox_8"] = {
			["y"] = -942.9999020248665,
			["x"] = 1426.0000397861,
		},
		["DAB_ControlBox_1"] = {
			["y"] = -50,
			["x"] = 150,
		},
		["DAB_ActionButton_94"] = {
			["y"] = -1399.99990284443,
			["x"] = 784.5000340864058,
		},
		["DAB_ControlBox_4"] = {
			["y"] = -200,
			["x"] = 150,
		},
		["DAB_ActionButton_119"] = {
			["y"] = -1399.99990284443,
			["x"] = 782.5000646337858,
		},
		["DAB_ActionButton_106"] = {
			["y"] = -1399.99990284443,
			["x"] = 782.5000646337858,
		},
		["DAB_ActionButton_42"] = {
			["y"] = -1399.99990284443,
			["x"] = 782.5000646337858,
		},
		["DAB_ActionButton_53"] = {
			["y"] = -1399.99990284443,
			["x"] = 782.5000646337858,
		},
		["DAB_ActionButton_23"] = {
			["y"] = -1399.99990284443,
			["x"] = 780.5000188872216,
		},
		["DAB_ActionButton_67"] = {
			["y"] = -1399.99990284443,
			["x"] = 782.5000646337858,
		},
		["DAB_ActionButton_113"] = {
			["y"] = -1399.99990284443,
			["x"] = 782.5000646337858,
		},
		["DAB_ActionButton_117"] = {
			["y"] = -1399.99990284443,
			["x"] = 782.5000646337858,
		},
		["DAB_ControlBox_2"] = {
			["y"] = -100,
			["x"] = 150,
		},
		["DAB_OtherBar_Bag"] = {
			["y"] = -650,
			["x"] = 300,
		},
		["DAB_ControlBox_7"] = {
			["y"] = -982.999443665155,
			["x"] = 1427.000558570019,
		},
		["DAB_ActionButton_48"] = {
			["y"] = -1399.99990284443,
			["x"] = 784.5000340864058,
		},
		["DAB_Options"] = {
			["y"] = 115.323866079392,
			["x"] = 360.3576987928495,
		},
		["DAB_ControlBox_5"] = {
			["y"] = -250,
			["x"] = 150,
		},
		["DAB_ActionButton_115"] = {
			["y"] = -1399.99990284443,
			["x"] = 782.5000646337858,
		},
		["DAB_ActionButton_70"] = {
			["y"] = -1399.99990284443,
			["x"] = 782.5000646337858,
		},
		["DAB_ActionButton_71"] = {
			["y"] = -1399.99990284443,
			["x"] = 782.5000646337858,
		},
		["DAB_ActionButton_45"] = {
			["y"] = -1399.99990284443,
			["x"] = 781.0000493973487,
		},
		["DAB_ActionButton_65"] = {
			["y"] = -1399.99990284443,
			["x"] = 782.5000646337858,
		},
		["DAB_ActionBar_8"] = {
			["y"] = -664.999570474035,
			["x"] = 1189.999982267618,
		},
		["DAB_ActionButton_41"] = {
			["y"] = -1399.99990284443,
			["x"] = 782.5000646337858,
		},
		["DAB_ActionButton_52"] = {
			["y"] = -1399.99990284443,
			["x"] = 771.5000037625432,
		},
		["DAB_ActionButton_72"] = {
			["y"] = -1399.99990284443,
			["x"] = 782.5000646337858,
		},
	},
	["Bar"] = {
		[1] = {
			["ccfontsize"] = 16,
			["label"] = {
				["attachoffsety"] = 0,
				["bgcolor"] = {
					["b"] = 0,
					["g"] = 0,
					["r"] = 0.7,
				},
				["borderalpha"] = 1,
				["color"] = {
					["b"] = 0,
					["g"] = 1,
					["r"] = 1,
				},
				["attachpoint"] = "BOTTOMLEFT",
				["alpha"] = 1,
				["attachoffsetx"] = 0,
				["attachto"] = "TOPLEFT",
				["bgalpha"] = 1,
				["text"] = "Bar 1",
				["bordercolor"] = {
					["b"] = 0,
					["g"] = 0.7,
					["r"] = 0.7,
				},
				["textsize"] = 12,
			},
			["rightclick"] = 1,
			["rows"] = 1,
			["buttonborderalpha"] = 1,
			["attachoffsetx"] = 0,
			["middleclick"] = 1,
			["attachto"] = "TOPLEFT",
			["background"] = {
				["style"] = 1,
				["borderalpha"] = 0,
				["color"] = {
					["b"] = 0,
					["g"] = 0,
					["r"] = 0.7,
				},
				["bordercolor"] = {
					["b"] = 0,
					["g"] = 1,
					["r"] = 1,
				},
				["alpha"] = 0,
			},
			["buttonbordercolor"] = {
				["b"] = 0,
				["g"] = 1,
				["r"] = 1,
			},
			["hidelabel"] = true,
			["attachoffsety"] = 0,
			["controlbox"] = {
				["bgcolor"] = {
					["b"] = 0,
					["g"] = 0,
					["r"] = 0.7,
				},
				["fontheight"] = 12,
				["bgalpha"] = 1,
				["left"] = true,
				["attachoffsetx"] = 0,
				["attachto"] = "TOPLEFT",
				["mouseovercolor"] = {
					["b"] = 0,
					["g"] = 1,
					["r"] = 1,
				},
				["hide"] = true,
				["attachoffsety"] = 0,
				["textcolor"] = {
					["b"] = 0,
					["g"] = 1,
					["r"] = 1,
				},
				["textmouseovercolor"] = {
					["b"] = 0,
					["g"] = 0,
					["r"] = 0,
				},
				["bottom"] = true,
				["right"] = true,
				["text"] = "Cbox Bar 1",
				["alpha"] = 1,
				["width"] = 100,
				["top"] = true,
				["bordercolor"] = {
					["b"] = 0,
					["g"] = 0.7,
					["r"] = 0.7,
				},
				["borderalpha"] = 1,
				["recolor"] = true,
				["height"] = 26,
				["baronclick"] = true,
				["textrecolor"] = true,
				["attachpoint"] = "TOPLEFT",
			},
			["numbuttons"] = 12,
			["alpha"] = 1,
			["keybindings"] = {
				[1] = {
					["key1"] = "1",
				},
				[2] = {
					["key1"] = "2",
				},
				[3] = {
					["key1"] = "3",
				},
				[4] = {
					["key1"] = "4",
				},
				[5] = {
					["key1"] = "5",
				},
				[6] = {
					["key1"] = "6",
				},
				[7] = {
					["key1"] = "7",
				},
				[8] = {
					["key1"] = "8",
				},
				[9] = {
					["key1"] = "9",
				},
				[10] = {
					["key1"] = "0",
				},
				[11] = {
					["key1"] = "+",
				},
				[12] = {
					["key1"] = "´",
				},
			},
			["attachpoint"] = "TOPLEFT",
			["buttonborderpadding"] = 0,
			["spacingv"] = 0,
			["padding"] = 10,
			["spacingh"] = 0,
			["size"] = 27,
		},
		[2] = {
			["ccfontsize"] = 16,
			["label"] = {
				["attachoffsety"] = 0,
				["bgcolor"] = {
					["b"] = 0,
					["g"] = 0,
					["r"] = 0.7,
				},
				["borderalpha"] = 1,
				["color"] = {
					["b"] = 0,
					["g"] = 1,
					["r"] = 1,
				},
				["attachpoint"] = "BOTTOM",
				["alpha"] = 1,
				["attachoffsetx"] = 0,
				["attachto"] = "BOTTOMLEFT",
				["bgalpha"] = 1,
				["text"] = "Bar 2",
				["bordercolor"] = {
					["b"] = 0,
					["g"] = 0.7,
					["r"] = 0.7,
				},
				["textsize"] = 12,
			},
			["rightclick"] = 2,
			["rows"] = 1,
			["buttonborderalpha"] = 1,
			["attachoffsetx"] = 0,
			["middleclick"] = 2,
			["attachto"] = "TOP",
			["background"] = {
				["style"] = 1,
				["borderalpha"] = 0,
				["color"] = {
					["b"] = 0,
					["g"] = 0,
					["r"] = 0.7,
				},
				["bordercolor"] = {
					["b"] = 0,
					["g"] = 1,
					["r"] = 1,
				},
				["alpha"] = 0,
			},
			["buttonbordercolor"] = {
				["b"] = 0,
				["g"] = 1,
				["r"] = 1,
			},
			["hidelabel"] = true,
			["attachoffsety"] = 0,
			["controlbox"] = {
				["bgcolor"] = {
					["b"] = 0,
					["g"] = 0,
					["r"] = 0.7,
				},
				["fontheight"] = 12,
				["bgalpha"] = 1,
				["left"] = true,
				["attachoffsetx"] = 0,
				["attachto"] = "TOPLEFT",
				["mouseovercolor"] = {
					["b"] = 0,
					["g"] = 1,
					["r"] = 1,
				},
				["hide"] = true,
				["attachoffsety"] = 0,
				["textcolor"] = {
					["b"] = 0,
					["g"] = 1,
					["r"] = 1,
				},
				["textmouseovercolor"] = {
					["b"] = 0,
					["g"] = 0,
					["r"] = 0,
				},
				["bottom"] = true,
				["right"] = true,
				["text"] = "Cbox Bar 2",
				["alpha"] = 1,
				["width"] = 100,
				["top"] = true,
				["bordercolor"] = {
					["b"] = 0,
					["g"] = 0.7,
					["r"] = 0.7,
				},
				["borderalpha"] = 1,
				["recolor"] = true,
				["height"] = 26,
				["baronclick"] = true,
				["textrecolor"] = true,
				["attachpoint"] = "TOPLEFT",
			},
			["numbuttons"] = 7,
			["alpha"] = 1,
			["keybindings"] = {
				[1] = {
					["key1"] = "SHIFT-1",
				},
				[2] = {
					["key1"] = "SHIFT-2",
				},
				[3] = {
					["key1"] = "SHIFT-3",
				},
				[4] = {
					["key1"] = "SHIFT-4",
				},
				[5] = {
					["key1"] = "SHIFT-5",
				},
				[6] = {
					["key1"] = "SHIFT-6",
				},
				[7] = {
					["key1"] = "SHIFT-7",
				},
				[8] = {
				},
				[9] = {
				},
				[10] = {
				},
				[11] = {
				},
				[12] = {
				},
			},
			["attachpoint"] = "BOTTOM",
			["spacingv"] = 0,
			["buttonborderpadding"] = 0,
			["spacingh"] = 0,
			["padding"] = 10,
			["hideempty"] = true,
			["size"] = 27,
		},
		[3] = {
			["ccfontsize"] = 16,
			["label"] = {
				["attachoffsety"] = 0,
				["bgcolor"] = {
					["b"] = 0,
					["g"] = 0,
					["r"] = 0.7,
				},
				["borderalpha"] = 1,
				["color"] = {
					["b"] = 0,
					["g"] = 1,
					["r"] = 1,
				},
				["attachpoint"] = "BOTTOMLEFT",
				["alpha"] = 1,
				["attachoffsetx"] = 0,
				["attachto"] = "BOTTOMLEFT",
				["bgalpha"] = 1,
				["text"] = "Bar 3",
				["bordercolor"] = {
					["b"] = 0,
					["g"] = 0.7,
					["r"] = 0.7,
				},
				["textsize"] = 12,
			},
			["rightclick"] = 3,
			["rows"] = 1,
			["buttonborderalpha"] = 1,
			["attachoffsetx"] = 0,
			["middleclick"] = 3,
			["attachto"] = "TOPLEFT",
			["background"] = {
				["style"] = 1,
				["borderalpha"] = 0,
				["color"] = {
					["b"] = 0,
					["g"] = 0,
					["r"] = 0.7,
				},
				["bordercolor"] = {
					["b"] = 0,
					["g"] = 1,
					["r"] = 1,
				},
				["alpha"] = 0,
			},
			["buttonbordercolor"] = {
				["b"] = 0,
				["g"] = 1,
				["r"] = 1,
			},
			["hidelabel"] = true,
			["attachoffsety"] = 0,
			["controlbox"] = {
				["bgcolor"] = {
					["b"] = 0,
					["g"] = 0,
					["r"] = 0.7,
				},
				["fontheight"] = 12,
				["bgalpha"] = 1,
				["left"] = true,
				["attachoffsetx"] = 0,
				["attachto"] = "TOPLEFT",
				["mouseovercolor"] = {
					["b"] = 0,
					["g"] = 1,
					["r"] = 1,
				},
				["hide"] = true,
				["attachoffsety"] = 0,
				["textcolor"] = {
					["b"] = 0,
					["g"] = 1,
					["r"] = 1,
				},
				["textmouseovercolor"] = {
					["b"] = 0,
					["g"] = 0,
					["r"] = 0,
				},
				["bottom"] = true,
				["right"] = true,
				["text"] = "Cbox Bar 3",
				["alpha"] = 1,
				["width"] = 100,
				["top"] = true,
				["bordercolor"] = {
					["b"] = 0,
					["g"] = 0.7,
					["r"] = 0.7,
				},
				["borderalpha"] = 1,
				["recolor"] = true,
				["height"] = 26,
				["baronclick"] = true,
				["textrecolor"] = true,
				["attachpoint"] = "TOPLEFT",
			},
			["numbuttons"] = 7,
			["alpha"] = 1,
			["keybindings"] = {
				[1] = {
					["key1"] = "CTRL-1",
				},
				[2] = {
					["key1"] = "CTRL-2",
				},
				[3] = {
					["key1"] = "CTRL-3",
				},
				[4] = {
					["key1"] = "CTRL-4",
				},
				[5] = {
					["key1"] = "CTRL-5",
				},
				[6] = {
					["key1"] = "CTRL-6",
				},
				[7] = {
					["key1"] = "CTRL-7",
				},
				[8] = {
				},
				[9] = {
				},
				[10] = {
				},
				[11] = {
				},
				[12] = {
				},
			},
			["attachpoint"] = "TOPLEFT",
			["buttonborderpadding"] = 0,
			["spacingv"] = 0,
			["padding"] = 10,
			["spacingh"] = 0,
			["size"] = 27,
		},
		[4] = {
			["ccfontsize"] = 16,
			["label"] = {
				["attachoffsety"] = 0,
				["bgcolor"] = {
					["b"] = 0,
					["g"] = 0,
					["r"] = 0.7,
				},
				["borderalpha"] = 1,
				["color"] = {
					["b"] = 0,
					["g"] = 1,
					["r"] = 1,
				},
				["attachpoint"] = "BOTTOMLEFT",
				["alpha"] = 1,
				["attachoffsetx"] = 0,
				["attachto"] = "TOPLEFT",
				["bgalpha"] = 1,
				["text"] = "Bar 4",
				["bordercolor"] = {
					["b"] = 0,
					["g"] = 0.7,
					["r"] = 0.7,
				},
				["textsize"] = 12,
			},
			["rightclick"] = 4,
			["rows"] = 2,
			["buttonborderalpha"] = 1,
			["attachoffsetx"] = 40,
			["middleclick"] = 4,
			["attachto"] = "TOPLEFT",
			["background"] = {
				["style"] = 1,
				["borderalpha"] = 0,
				["color"] = {
					["b"] = 0,
					["g"] = 0,
					["r"] = 0.7,
				},
				["bordercolor"] = {
					["b"] = 0,
					["g"] = 1,
					["r"] = 1,
				},
				["alpha"] = 0,
			},
			["buttonbordercolor"] = {
				["b"] = 0,
				["g"] = 1,
				["r"] = 1,
			},
			["size"] = 71,
			["attachoffsety"] = -29,
			["controlbox"] = {
				["bgcolor"] = {
					["b"] = 0,
					["g"] = 0,
					["r"] = 0.7,
				},
				["fontheight"] = 12,
				["bgalpha"] = 1,
				["left"] = true,
				["attachoffsetx"] = 0,
				["attachto"] = "TOPLEFT",
				["mouseovercolor"] = {
					["b"] = 0,
					["g"] = 1,
					["r"] = 1,
				},
				["hide"] = true,
				["attachoffsety"] = 0,
				["textcolor"] = {
					["b"] = 0,
					["g"] = 1,
					["r"] = 1,
				},
				["textmouseovercolor"] = {
					["b"] = 0,
					["g"] = 0,
					["r"] = 0,
				},
				["bottom"] = true,
				["right"] = true,
				["text"] = "Cbox Bar 4",
				["alpha"] = 1,
				["width"] = 100,
				["top"] = true,
				["bordercolor"] = {
					["b"] = 0,
					["g"] = 0.7,
					["r"] = 0.7,
				},
				["borderalpha"] = 1,
				["recolor"] = true,
				["height"] = 26,
				["baronclick"] = true,
				["textrecolor"] = true,
				["attachpoint"] = "TOPLEFT",
			},
			["numbuttons"] = 2,
			["alpha"] = 1,
			["keybindings"] = {
				[1] = {
				},
				[2] = {
				},
				[3] = {
				},
				[4] = {
				},
				[5] = {
				},
				[6] = {
				},
				[7] = {
				},
				[8] = {
				},
				[9] = {
				},
				[10] = {
				},
				[11] = {
				},
				[12] = {
				},
				[13] = {
				},
				[14] = {
				},
				[15] = {
				},
				[16] = {
				},
				[17] = {
				},
				[18] = {
				},
			},
			["hidelabel"] = true,
			["attachpoint"] = "TOPLEFT",
			["spacingh"] = -1,
			["spacingv"] = -1,
			["padding"] = 10,
			["buttonborderpadding"] = 0,
			["hide"] = true,
		},
		[5] = {
			["ccfontsize"] = 16,
			["label"] = {
				["attachoffsety"] = 0,
				["bgcolor"] = {
					["b"] = 0,
					["g"] = 0,
					["r"] = 0.7,
				},
				["borderalpha"] = 1,
				["color"] = {
					["b"] = 0,
					["g"] = 1,
					["r"] = 1,
				},
				["attachpoint"] = "BOTTOMLEFT",
				["alpha"] = 1,
				["attachoffsetx"] = 0,
				["attachto"] = "TOPLEFT",
				["bgalpha"] = 1,
				["text"] = "Bigbutts",
				["bordercolor"] = {
					["b"] = 0,
					["g"] = 0.7,
					["r"] = 0.7,
				},
				["textsize"] = 12,
			},
			["rightclick"] = 5,
			["rows"] = 1,
			["buttonborderalpha"] = 1,
			["attachoffsetx"] = 0,
			["middleclick"] = 5,
			["attachto"] = "TOPLEFT",
			["background"] = {
				["style"] = 1,
				["borderalpha"] = 0,
				["color"] = {
					["b"] = 0,
					["g"] = 0,
					["r"] = 0.7,
				},
				["bordercolor"] = {
					["b"] = 0,
					["g"] = 1,
					["r"] = 1,
				},
				["alpha"] = 0,
			},
			["buttonbordercolor"] = {
				["b"] = 0,
				["g"] = 1,
				["r"] = 1,
			},
			["hidelabel"] = true,
			["attachoffsety"] = 0,
			["controlbox"] = {
				["bgcolor"] = {
					["b"] = 0,
					["g"] = 0,
					["r"] = 0.7,
				},
				["fontheight"] = 12,
				["bgalpha"] = 1,
				["left"] = true,
				["attachoffsetx"] = 0,
				["attachto"] = "TOPLEFT",
				["mouseovercolor"] = {
					["b"] = 0,
					["g"] = 1,
					["r"] = 1,
				},
				["hide"] = true,
				["attachoffsety"] = 0,
				["textcolor"] = {
					["b"] = 0,
					["g"] = 1,
					["r"] = 1,
				},
				["textmouseovercolor"] = {
					["b"] = 0,
					["g"] = 0,
					["r"] = 0,
				},
				["bottom"] = true,
				["right"] = true,
				["text"] = "Cbox Bar 5",
				["alpha"] = 1,
				["width"] = 100,
				["top"] = true,
				["bordercolor"] = {
					["b"] = 0,
					["g"] = 0.7,
					["r"] = 0.7,
				},
				["borderalpha"] = 1,
				["recolor"] = true,
				["height"] = 26,
				["baronclick"] = true,
				["textrecolor"] = true,
				["attachpoint"] = "TOPLEFT",
			},
			["numbuttons"] = 3,
			["alpha"] = 1,
			["keybindings"] = {
				[1] = {
				},
				[2] = {
				},
				[3] = {
				},
				[4] = {
				},
				[5] = {
				},
				[6] = {
				},
				[7] = {
				},
				[8] = {
				},
				[9] = {
				},
				[10] = {
				},
				[11] = {
				},
				[12] = {
				},
			},
			["hide"] = true,
			["attachpoint"] = "TOPLEFT",
			["buttonborderpadding"] = 0,
			["spacingv"] = 0,
			["padding"] = 10,
			["spacingh"] = 25,
			["size"] = 57,
		},
		[6] = {
			["ccfontsize"] = 16,
			["label"] = {
				["attachoffsety"] = 0,
				["bgcolor"] = {
					["b"] = 0,
					["g"] = 0,
					["r"] = 0.7,
				},
				["borderalpha"] = 1,
				["color"] = {
					["b"] = 0,
					["g"] = 1,
					["r"] = 1,
				},
				["attachpoint"] = "BOTTOMLEFT",
				["alpha"] = 1,
				["attachoffsetx"] = 0,
				["attachto"] = "TOPLEFT",
				["bgalpha"] = 1,
				["text"] = "Bar 6",
				["bordercolor"] = {
					["b"] = 0,
					["g"] = 0.7,
					["r"] = 0.7,
				},
				["textsize"] = 12,
			},
			["rightclick"] = 6,
			["rows"] = 1,
			["buttonborderalpha"] = 1,
			["attachoffsetx"] = 0,
			["middleclick"] = 6,
			["attachto"] = "TOPLEFT",
			["background"] = {
				["style"] = 1,
				["borderalpha"] = 0,
				["color"] = {
					["b"] = 0,
					["g"] = 0,
					["r"] = 0.7,
				},
				["bordercolor"] = {
					["b"] = 0,
					["g"] = 1,
					["r"] = 1,
				},
				["alpha"] = 0,
			},
			["buttonbordercolor"] = {
				["b"] = 0,
				["g"] = 1,
				["r"] = 1,
			},
			["hidelabel"] = true,
			["attachoffsety"] = 0,
			["controlbox"] = {
				["bgcolor"] = {
					["b"] = 0,
					["g"] = 0,
					["r"] = 0.7,
				},
				["fontheight"] = 12,
				["bgalpha"] = 1,
				["left"] = true,
				["attachoffsetx"] = 0,
				["attachto"] = "TOPLEFT",
				["mouseovercolor"] = {
					["b"] = 0,
					["g"] = 1,
					["r"] = 1,
				},
				["hide"] = true,
				["attachoffsety"] = 0,
				["textcolor"] = {
					["b"] = 0,
					["g"] = 1,
					["r"] = 1,
				},
				["textmouseovercolor"] = {
					["b"] = 0,
					["g"] = 0,
					["r"] = 0,
				},
				["bottom"] = true,
				["right"] = true,
				["text"] = "Cbox Bar 6",
				["alpha"] = 1,
				["width"] = 100,
				["top"] = true,
				["bordercolor"] = {
					["b"] = 0,
					["g"] = 0.7,
					["r"] = 0.7,
				},
				["borderalpha"] = 1,
				["recolor"] = true,
				["height"] = 26,
				["baronclick"] = true,
				["textrecolor"] = true,
				["attachpoint"] = "TOPLEFT",
			},
			["numbuttons"] = 4,
			["alpha"] = 1,
			["keybindings"] = {
				[1] = {
					["key1"] = "Q",
				},
				[2] = {
					["key1"] = "E",
				},
				[3] = {
				},
				[4] = {
				},
				[5] = {
				},
				[6] = {
				},
				[7] = {
				},
				[8] = {
				},
				[9] = {
				},
				[10] = {
				},
				[11] = {
				},
				[12] = {
				},
			},
			["attachpoint"] = "TOPLEFT",
			["spacingv"] = 0,
			["buttonborderpadding"] = 0,
			["spacingh"] = 0,
			["padding"] = 10,
			["size"] = 51,
			["hide"] = true,
		},
		[7] = {
			["ccfontsize"] = 16,
			["label"] = {
				["attachoffsety"] = 0,
				["bgcolor"] = {
					["b"] = 0,
					["g"] = 0,
					["r"] = 0.7,
				},
				["borderalpha"] = 1,
				["color"] = {
					["b"] = 0,
					["g"] = 1,
					["r"] = 1,
				},
				["attachpoint"] = "BOTTOMLEFT",
				["alpha"] = 1,
				["attachoffsetx"] = 0,
				["attachto"] = "TOPLEFT",
				["bgalpha"] = 1,
				["text"] = "pets Buffs",
				["bordercolor"] = {
					["b"] = 0,
					["g"] = 0.7,
					["r"] = 0.7,
				},
				["textsize"] = 12,
			},
			["rightclick"] = 7,
			["rows"] = 2,
			["buttonborderalpha"] = 1,
			["attachoffsetx"] = 0,
			["middleclick"] = 7,
			["attachto"] = "TOPLEFT",
			["background"] = {
				["style"] = 1,
				["borderalpha"] = 0,
				["color"] = {
					["b"] = 0,
					["g"] = 0,
					["r"] = 0.7,
				},
				["bordercolor"] = {
					["b"] = 0,
					["g"] = 1,
					["r"] = 1,
				},
				["alpha"] = 0,
			},
			["buttonbordercolor"] = {
				["b"] = 0,
				["g"] = 1,
				["r"] = 1,
			},
			["size"] = 32,
			["attachoffsety"] = 0,
			["controlbox"] = {
				["bgcolor"] = {
					["b"] = 0,
					["g"] = 0,
					["r"] = 0.7,
				},
				["borderalpha"] = 0,
				["attachpoint"] = "TOPLEFT",
				["left"] = true,
				["attachoffsetx"] = 0,
				["attachto"] = "TOPLEFT",
				["mouseovercolor"] = {
					["b"] = 0,
					["g"] = 1,
					["r"] = 1,
				},
				["attachoffsety"] = 0,
				["textcolor"] = {
					["b"] = 0,
					["g"] = 1,
					["r"] = 1,
				},
				["bottom"] = true,
				["text"] = "Pets & Buffs",
				["alpha"] = 1,
				["width"] = 100,
				["top"] = true,
				["right"] = true,
				["bgalpha"] = 0,
				["height"] = 26,
				["bordercolor"] = {
					["b"] = 0,
					["g"] = 0.7,
					["r"] = 0.7,
				},
				["fontheight"] = 12,
				["textmouseovercolor"] = {
					["b"] = 0,
					["g"] = 0,
					["r"] = 0,
				},
			},
			["numbuttons"] = 12,
			["alpha"] = 1,
			["keybindings"] = {
				[1] = {
				},
				[2] = {
				},
				[3] = {
				},
				[4] = {
				},
				[5] = {
				},
				[6] = {
				},
				[7] = {
				},
				[8] = {
				},
				[9] = {
				},
				[10] = {
				},
				[11] = {
				},
				[12] = {
				},
			},
			["hidelabel"] = true,
			["buttonborderpadding"] = 0,
			["attachpoint"] = "TOPLEFT",
			["padding"] = 10,
			["spacingh"] = 2,
			["spacingv"] = 2,
		},
		[8] = {
			["ccfontsize"] = 16,
			["label"] = {
				["attachoffsety"] = 0,
				["bgcolor"] = {
					["b"] = 0,
					["g"] = 0,
					["r"] = 0.7,
				},
				["borderalpha"] = 1,
				["color"] = {
					["b"] = 0,
					["g"] = 1,
					["r"] = 1,
				},
				["attachpoint"] = "BOTTOMLEFT",
				["alpha"] = 1,
				["attachoffsetx"] = 0,
				["attachto"] = "TOPLEFT",
				["bgalpha"] = 1,
				["text"] = "Bar 8",
				["bordercolor"] = {
					["b"] = 0,
					["g"] = 0.7,
					["r"] = 0.7,
				},
				["textsize"] = 12,
			},
			["rightclick"] = 8,
			["rows"] = 1,
			["buttonborderalpha"] = 1,
			["attachoffsetx"] = 0,
			["middleclick"] = 8,
			["attachto"] = "TOPLEFT",
			["background"] = {
				["style"] = 1,
				["borderalpha"] = 0,
				["color"] = {
					["b"] = 0,
					["g"] = 0,
					["r"] = 0.7,
				},
				["bordercolor"] = {
					["b"] = 0,
					["g"] = 1,
					["r"] = 1,
				},
				["alpha"] = 0,
			},
			["buttonbordercolor"] = {
				["b"] = 0,
				["g"] = 1,
				["r"] = 1,
			},
			["size"] = 77,
			["attachoffsety"] = 0,
			["controlbox"] = {
				["bgcolor"] = {
					["b"] = 0,
					["g"] = 0,
					["r"] = 0.7,
				},
				["borderalpha"] = 0,
				["textmouseovercolor"] = {
					["b"] = 0,
					["g"] = 0,
					["r"] = 0,
				},
				["left"] = true,
				["attachoffsetx"] = 0,
				["attachto"] = "TOPLEFT",
				["mouseovercolor"] = {
					["b"] = 0,
					["g"] = 1,
					["r"] = 1,
				},
				["attachoffsety"] = 0,
				["textcolor"] = {
					["b"] = 0,
					["g"] = 1,
					["r"] = 1,
				},
				["bottom"] = true,
				["text"] = "Item Swap",
				["alpha"] = 1,
				["width"] = 100,
				["top"] = true,
				["right"] = true,
				["attachpoint"] = "TOPLEFT",
				["height"] = 26,
				["bordercolor"] = {
					["b"] = 0,
					["g"] = 0.7,
					["r"] = 0.7,
				},
				["fontheight"] = 12,
				["bgalpha"] = 0,
			},
			["numbuttons"] = 5,
			["alpha"] = 1,
			["keybindings"] = {
				[1] = {
				},
				[2] = {
				},
				[3] = {
				},
				[4] = {
				},
				[5] = {
				},
				[6] = {
				},
				[7] = {
				},
				[8] = {
				},
				[9] = {
				},
				[10] = {
				},
				[11] = {
				},
				[12] = {
				},
			},
			["hide"] = true,
			["buttonborderpadding"] = 0,
			["attachpoint"] = "TOPLEFT",
			["padding"] = 10,
			["spacingv"] = 0,
			["spacingh"] = 13,
		},
		[9] = {
			["ccfontsize"] = 16,
			["label"] = {
				["attachoffsety"] = 0,
				["bgcolor"] = {
					["b"] = 0,
					["g"] = 0,
					["r"] = 0.7,
				},
				["borderalpha"] = 1,
				["color"] = {
					["b"] = 0,
					["g"] = 1,
					["r"] = 1,
				},
				["attachpoint"] = "BOTTOMLEFT",
				["alpha"] = 1,
				["attachoffsetx"] = 0,
				["attachto"] = "TOPLEFT",
				["bgalpha"] = 1,
				["text"] = "HP MP",
				["bordercolor"] = {
					["b"] = 0,
					["g"] = 0.7,
					["r"] = 0.7,
				},
				["textsize"] = 12,
			},
			["rightclick"] = 9,
			["rows"] = 3,
			["buttonborderalpha"] = 1,
			["attachoffsetx"] = 0,
			["middleclick"] = 9,
			["attachto"] = "TOPLEFT",
			["background"] = {
				["style"] = 2,
				["borderalpha"] = 0,
				["color"] = {
					["b"] = 0,
					["g"] = 0,
					["r"] = 0.7,
				},
				["bordercolor"] = {
					["b"] = 0,
					["g"] = 1,
					["r"] = 1,
				},
				["alpha"] = 0,
			},
			["buttonbordercolor"] = {
				["r"] = 0.3294117647058824,
				["g"] = 0.4823529411764706,
				["b"] = 0.7215686274509804,
			},
			["hidelabel"] = true,
			["attachoffsety"] = 0,
			["controlbox"] = {
				["bgcolor"] = {
					["b"] = 0,
					["g"] = 0,
					["r"] = 0.7,
				},
				["borderalpha"] = 0,
				["attachpoint"] = "TOPLEFT",
				["left"] = true,
				["attachoffsetx"] = 0,
				["attachto"] = "TOPLEFT",
				["mouseovercolor"] = {
					["b"] = 0,
					["g"] = 1,
					["r"] = 1,
				},
				["attachoffsety"] = 0,
				["textcolor"] = {
					["b"] = 0,
					["g"] = 1,
					["r"] = 1,
				},
				["bottom"] = true,
				["text"] = "HP & MP",
				["alpha"] = 1,
				["width"] = 100,
				["top"] = true,
				["right"] = true,
				["bgalpha"] = 0,
				["height"] = 26,
				["bordercolor"] = {
					["b"] = 0,
					["g"] = 0.7,
					["r"] = 0.7,
				},
				["fontheight"] = 11,
				["textmouseovercolor"] = {
					["b"] = 0,
					["g"] = 0,
					["r"] = 0,
				},
			},
			["numbuttons"] = 9,
			["alpha"] = 1,
			["keybindings"] = {
				[1] = {
				},
				[2] = {
				},
				[3] = {
				},
				[4] = {
				},
				[5] = {
				},
				[6] = {
				},
				[7] = {
				},
				[8] = {
				},
				[9] = {
				},
				[10] = {
				},
				[11] = {
				},
				[12] = {
				},
			},
			["attachpoint"] = "TOPLEFT",
			["spacingh"] = 2,
			["spacingv"] = 2,
			["padding"] = 10,
			["buttonborderpadding"] = 1,
			["size"] = 35,
		},
		[10] = {
			["ccfontsize"] = 16,
			["label"] = {
				["attachoffsety"] = 0,
				["bgcolor"] = {
					["b"] = 0,
					["g"] = 0,
					["r"] = 0.7,
				},
				["borderalpha"] = 1,
				["color"] = {
					["b"] = 0,
					["g"] = 1,
					["r"] = 1,
				},
				["attachpoint"] = "BOTTOMLEFT",
				["alpha"] = 1,
				["attachoffsetx"] = 0,
				["attachto"] = "TOPLEFT",
				["bgalpha"] = 1,
				["text"] = "Vael",
				["bordercolor"] = {
					["b"] = 0,
					["g"] = 0.7,
					["r"] = 0.7,
				},
				["textsize"] = 12,
			},
			["rightclick"] = 10,
			["rows"] = 1,
			["buttonborderalpha"] = 1,
			["attachoffsetx"] = 0,
			["middleclick"] = 10,
			["attachto"] = "TOPLEFT",
			["background"] = {
				["style"] = 1,
				["borderalpha"] = 0,
				["color"] = {
					["b"] = 0,
					["g"] = 0,
					["r"] = 0.7,
				},
				["bordercolor"] = {
					["b"] = 0,
					["g"] = 1,
					["r"] = 1,
				},
				["alpha"] = 0,
			},
			["buttonbordercolor"] = {
				["b"] = 0.3803921568627451,
				["g"] = 0.9725490196078431,
				["r"] = 1,
			},
			["hidelabel"] = true,
			["attachoffsety"] = 0,
			["controlbox"] = {
				["bgcolor"] = {
					["b"] = 0,
					["g"] = 0,
					["r"] = 0.7,
				},
				["fontheight"] = 12,
				["bgalpha"] = 1,
				["left"] = true,
				["attachoffsetx"] = 0,
				["attachto"] = "TOPLEFT",
				["mouseovercolor"] = {
					["b"] = 0,
					["g"] = 1,
					["r"] = 1,
				},
				["hide"] = true,
				["attachoffsety"] = 0,
				["textcolor"] = {
					["b"] = 0,
					["g"] = 1,
					["r"] = 1,
				},
				["textmouseovercolor"] = {
					["b"] = 0,
					["g"] = 0,
					["r"] = 0,
				},
				["bottom"] = true,
				["right"] = true,
				["text"] = "Cbox Bar 10",
				["alpha"] = 1,
				["width"] = 100,
				["top"] = true,
				["bordercolor"] = {
					["b"] = 0,
					["g"] = 0.7,
					["r"] = 0.7,
				},
				["borderalpha"] = 1,
				["recolor"] = true,
				["height"] = 26,
				["baronclick"] = true,
				["textrecolor"] = true,
				["attachpoint"] = "TOPLEFT",
			},
			["numbuttons"] = 4,
			["alpha"] = 1,
			["keybindings"] = {
				[1] = {
				},
				[2] = {
				},
				[3] = {
				},
				[4] = {
				},
				[5] = {
				},
				[6] = {
				},
				[7] = {
				},
				[8] = {
				},
				[9] = {
				},
				[10] = {
				},
				[11] = {
				},
				[12] = {
				},
			},
			["attachpoint"] = "TOPLEFT",
			["spacingv"] = 27,
			["buttonborderpadding"] = 0,
			["spacingh"] = 29,
			["padding"] = 10,
			["size"] = 54,
			["hide"] = true,
		},
	},
}
      DAB_Initialize_AllSettings();
	DAB_Feedback(DAB_TEXT.SettingsLoaded);
end