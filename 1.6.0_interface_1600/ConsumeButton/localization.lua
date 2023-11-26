-- Version : English - sarf
-- Translation by : None

BINDING_HEADER_CONSUMEBUTTONHEADER		= "Consume Button";
BINDING_NAME_CONSUMEBUTTON				= "Consume Food and Drink";

CONSUMEBUTTON_CONFIG_HEADER				= "Consume Button";
CONSUMEBUTTON_CONFIG_HEADER_INFO		= "Contains settings for the Consume Button,\nan AddOn which gives the user a button that can be clicked to consume food/drink. Will show amount left.";

CONSUMEBUTTON_ENABLED					= "Enable Consume Button";
CONSUMEBUTTON_ENABLED_INFO				= "Enables Consume Button";

CONSUMEBUTTON_LARGE						= "Large Consume Button";
CONSUMEBUTTON_LARGE_INFO				= "Makes the Consume Button larger";

CONSUMEBUTTON_CHAT_ENABLED				= "Consume Button enabled.";
CONSUMEBUTTON_CHAT_DISABLED				= "Consume Button disabled.";

CONSUMEBUTTON_CHAT_LARGE_ENABLED		= "Consume Button set to large size.";
CONSUMEBUTTON_CHAT_LARGE_DISABLED		= "Consume Button set to small size.";

CONSUMEBUTTON_CHAT_COMMAND_INFO			= "Controls Consume Button by the command line - /consumebutton for usage.";

CONSUMEBUTTON_CHAT_COMMAND_USAGE		= "Usage: /consumebutton [state|large] [on/off/toggle]\nCommands:\n state - determines whether the ConsumeButton should be enabled or not\n large - determines whether the ConsumeButton should be large or small";

CONSUMEBUTTON_TOOLTIP_FORMAT			= "Chosen Drink:\n %s\nChosen Food:\n %s";

CONSUMEBUTTON_NODRINK					= "No drink!";

CONSUMEBUTTON_NOFOOD					= "No food!";

CONSUMEBUTTON_CLASSIFICATION_FOOD		= "Food";
CONSUMEBUTTON_CLASSIFICATION_DRINK		= "Drink";

CONSUMEBUTTON_NAME_RECIPE_SUBSTRING		= "Recipe";


ConsumeButton_Exclusion_List = {
	[CONSUMEBUTTON_CLASSIFICATION_FOOD] = {
		"Dragonbreath Chili",
	},
};