--[[
--
--	Sea.IO
--
--	Common Input/Output Functions for WoW
--
--	$LastChangedBy: AlexYoshi $
--	$Rev: 999 $
--	$Date: 2005-03-10 21:07:10 -0500 (Thu, 10 Mar 2005) $
--]]

-- Globals
SEA_DEBUG = true;
SEA_ERROR = true;

Sea.IO = {
	-- Default chat frame set to ChatFrame1
	DEFAULT_PRINT_FRAME = ChatFrame1;

	-- Default error frame set to ChatFrame1
	DEFAULT_ERROR_FRAME = ChatFrame1;

	-- Default banner frame
	DEFAULT_BANNER_FRAME = UIErrorsFrame;

	-- Default color scheme
	DEFAULT_ERROR_COLOR = RED_FONT_COLOR;
	DEFAULT_PRINT_COLOR = NORMAL_FONT_COLOR;

	-- Default Debug Tag
	debugKey = "SEA_DEBUG";

	-- Default Error Tag
	errorKey = "SEA_ERROR";
	
	-- Recursive check
	recursed = false;
	
--[[ Standard Prints ]]--
	
	--
	-- print ( ... )
	--
	-- Arguments
	-- 	() arg
	-- 	arg - the values to be printed
	--
	-- Returns
	-- 	(nil)
	--
	print = function(...) 
		Sea.IO.printf(nil, unpack(arg));
	end;

	--
	-- banner ( ... )
	--
	-- Arguments
	-- 	() arg
	-- 	arg - the values to be printed
	--
	-- Returns
	-- 	(nil)
	--
	banner = function(...) 
		Sea.IO.printf(Sea.IO.DEFAULT_BANNER_FRAME, unpack(arg));
	end;	

	--
	-- error (...)
	--
	-- 	prints just like Sea.IO.print, except as an error
	--
	-- Arguments:
	-- 	()  arg
	-- 	arg - contains all error output
	--
	error = function(...)
		Sea.IO.errorfc(nil, nil, unpack(arg) );
	end;

	--
	-- dprint (string debugkey, ...)
	--
	-- 	prints a message when getglobal(debugkey) is true
	--
	-- Arguments:
	-- 	(string debugkey) arg
	--
	dprint = function ( debugKey, ... )
		Sea.IO.dprintf(debugKey, Sea.IO.DEFAULT_PRINT_FRAME, unpack(arg));
	end;


	--
	-- dprint (string debugkey, ...)
	--
	-- 	prints a message when getglobal(debugkey) is true
	--
	-- Arguments:
	-- 	(string debugkey) arg
	--
	dprintc = function ( debugKey, color, ... )
		Sea.IO.dprintfc(debugKey, Sea.IO.DEFAULT_PRINT_FRAME, color,  unpack(arg));
	end;

	--
	-- derror (string debugkey, ...)
	--
	-- 	prints an error when getglobal(debugkey) is true
	--
	-- Arguments:
	-- 	(string debugkey) arg
	--
	derror = function ( debugKey, ... )
		Sea.IO.derrorf(debugKey, Sea.IO.DEFAULT_ERROR_FRAME, unpack(arg));
	end;

	--
	-- derrorf (string debugkey, MessageFrame frame, ...)
	--
	-- 	prints an error when getglobal(debugkey) is true
	--
	-- Arguments:
	-- 	(string debugkey, MessageFrame frame) arg
	--
	derrorf = function ( debugKey, frame, ... )
		Sea.IO.derrorfc(frame, Sea.IO.DEFAULT_ERROR_COLOR, unpack(arg));
	end;
	
	--
	-- derrorc (string debugkey, Table[r,g,b] color, ...)
	--
	-- 	prints an error when getglobal(debugkey) is true
	-- 	in the color specified by color
	--
	-- Arguments:
	-- 	(string debugkey, Table[r,g,b] color) arg
	--
	derrorc = function ( debugKey, color, ... )
		Sea.IO.derrorfc(Sea.IO.EFAULT_ERROR_FRAME, color, unpack(arg));
	end;

	--
	-- derrorfc (string debugkey, MessageFrame frame, Table[r,g,b] color, ...)
	--
	-- 	prints an error when getglobal(debugkey) is true
	-- 	in the frame specified, in the color specified
	--
	-- Arguments:
	-- 	(string debugkey, MessageFrame frame, Table[r,g,b] color) arg
	-- 	
	--
	derrorfc = function ( debugKey, frame, color, ... )
		if ( type(debugKey) ~= string ) then
			if ( type(debugKey) == nil ) then 
				debugKey = Sea.IO.errorKey;
			else
				--Sea.IO.error("Invalid debug key. Type: ", type(debugKey));
			end
		end
		if ( getglobal(debugKey) == true ) then 
			Sea.IO.errorfc(frame, color, unpack(arg));
		end
	end;
	
	
	--
	-- dbanner (string debugkey, ...)
	--
	-- 	prints a banner when getglobal(debugkey) is true
	--
	-- Arguments:
	-- 	(string debugkey) arg
	--
	dbanner = function ( debugKey, ... )
		Sea.IO.dprintf(debugKey, Sea.IO.DEFAULT_BANNER_FRAME, unpack(arg));
	end;
	
	--
	-- dbannerc (string debugkey, Table[r,g,b] ...)
	--
	-- 	prints a banner when getglobal(debugkey) is true
	--
	-- Arguments:
	-- 	(string debugkey) arg
	--
	dbannerc = function ( debugKey, color, ... )
		if ( type(debugKey) ~= string ) then
			if ( type(debugKey) == nil ) then 
				debugKey = Sea.IO.errorKey;
			else
				--Sea.IO.error("Invalid debug key. Type: ", type(debugKey));
			end
		end
		if ( getglobal(debugKey) == true ) then 
			Sea.IO.printfc(Sea.IO.DEFAULT_BANNER_FRAME, color, unpack(arg));
		end
	end;	

	--
	-- printf (MessageFrame frame, ...)
	--	
	--	prints a message in a message frame
	--
	-- Arguments:
	-- 	(MessageFrame frame) arg
	--
	-- 	frame - the object with AddMessage(self, string)
	-- 	arg - the string to be composed
	--
	-- Returns
	-- 	(nil)
	--
	
	printf = function (frame, ... )
		Sea.IO.printfc(frame, nil, unpack(arg));
	end;

	--
	-- dprintf (string debugkey, MessageFrame frame, ...)
	--
	-- 	prints a message when getglobal(debugkey) is true
	-- 	also decodes | and characters
	--
	-- Arguments:
	-- 	(string debugkey, MessageFrame frame) arg
	-- 	debugkey - string debug key
	-- 	frame - debug target frame
	--
	dprintf = function ( debugKey, frame, ... )
		Sea.IO.dprintfc(debugKey, frame, nil, unpack(arg));
	end;	


	--
	-- dprintfc (string debugkey, MessageFrame frame, Table[r,g,b] color, ...)
	--
	-- 	prints a message when getglobal(debugkey) is true
	-- 	also decodes | and characters, using the specified color
	-- 	
	-- Arguments:
	-- 	(string debugkey, MessageFrame frame) arg
	-- 	debugkey - string debug key
	-- 	frame - debug target frame
	-- 	color - table of colors
	--
	dprintfc = function ( debugKey, frame, color, ... )
		if ( type(debugKey) ~= string ) then
			if ( type(debugKey) == nil ) then 
				debugKey = Sea.UI.debugKey;
			else
				--Sea.IO.error("Invalid debug key. Type: ", type(debugKey));
			end
		end

		local msg = Sea.util.join(arg,"");
		msg = string.gsub(msg,"|","<pipe>");
		msg = string.gsub(msg,"([^%w%s%a%p])",Sea.string.byte);
		
		if ( getglobal(debugKey) == true ) then 
			Sea.IO.printfc(frame, color, unpack(arg));
		end
	end;	



	--
	-- errorc (Table[r,g,b] color, ...)
	--
	-- 	prints just like Sea.IO.print, except as an error with the color
	--
	-- Arguments:
	-- 	(Table[r,g,b] color)  arg
	-- 	color - the specified color
	-- 	arg - contains all error output
	--
	errorc = function(color, ...)
		Sea.IO.errorfc(Sea.IO.DEFAULT_ERROR_FRAME, color, unpack(arg) );
	end;	

	--
	-- errorf (MessageFrame frame, ...)
	--	
	--	prints a message in an error message frame
	--
	-- Arguments:
	-- 	(MessageFrame frame) arg
	--
	-- 	frame - the object with AddMessage(self, string)
	-- 	arg - the string to be composed
	--
	-- Returns
	-- 	(nil)
	--
	
	errorf = function (frame, ... )
		Sea.IO.errorfc(frame, nil, unpack(arg));
	end;

	--
	-- errorfc (MessageFrame frame, Table[r,g,b] color, ...)
	--	
	--	prints a message in an error message frame with the color
	--
	-- Arguments:
	-- 	(MessageFrame frame, Table[r,g,b] color) arg
	--
	-- 	frame - the object with AddMessage(self, string)
	-- 	color - table containing the colors
	-- 	arg - the string to be composed
	--
	-- Returns
	-- 	(nil)
	--
	
	errorfc = function (frame, color, ... )
		if ( frame == nil ) then
			frame = Sea.IO.DEFAULT_ERROR_FRAME;
		end
		if ( color == nil ) then
			color = Sea.IO.DEFAULT_ERROR_COLOR;
		end
		
		Sea.IO.printfc(frame, color, unpack(arg));		
	end;
	--
	-- printc ( ColorTable[r,g,b] color, ... )
	--	
	--	prints a message in the default frame with a 
	--	specified color
	--
	-- Arguments:
	-- 	color - the color
	-- 	arg - the message
	-- 
	printc = function ( color, ... ) 
		Sea.IO.printfc(nil, color, unpack(arg));
	end;

	--
	-- bannerc ( ColorTable[r,g,b] color, ... )
	--	
	--	prints a banner message with a 
	--	specified color
	--
	-- Arguments:
	-- 	color - the color
	-- 	arg - the message
	-- 
	bannerc = function ( color, ... ) 
		if ( color == nil ) then 
			color = Sea.IO.DEFAULT_PRINT_COLOR;
		end

		Sea.IO.printfc(Sea.IO.DEFAULT_BANNER_FRAME, color, unpack(arg));
	end;
		
	--
	-- printfc (MessageFrame frame, ColorTable[r,g,b] color, ... )
	--
	-- 	prints a message in a frame with a specified color
	--
	-- Arguments
	-- 	frame - the frame
	-- 	color - a table with .r .g and .b values
	-- 	arg - the message objects
	--
	printfc = function (frame, color, ... ) 
		if ( frame == nil ) then 
			frame = Sea.IO.DEFAULT_PRINT_FRAME;
		end
		if ( color == nil ) then 
			color = Sea.IO.DEFAULT_PRINT_COLOR;
		end

		if ( Sea.IO.recursed == false ) then 
			Sea.IO.recursed = true;
			if ( frame == Sea.IO.DEFAULT_BANNER_FRAME ) then
				frame:AddMessage(Sea.util.join(arg,""), color.r, color.g, color.b, 1.0, UIERRORS_HOLD_TIME);
			else
				frame:AddMessage(Sea.util.join(arg,""), color.r, color.g, color.b);
			end
			Sea.IO.recursed = false;
		else
			if ( frame == Sea.IO.DEFAULT_BANNER_FRAME ) then
				frame:AddMessage(arg[1], color.r, color.g, color.b, 1.0, UIERRORS_HOLD_TIME);
			else
				frame:AddMessage(arg[1], color.r, color.g, color.b);
			end
		end			
	end;

	--[[ End of Standard Prints ]]--
	
	--[[ Beginning of Special Prints ]]--
	
	--
	-- printComma (...)
	--
	--	Prints the arguments separated by commas
	--
	printComma = function(...)
		Sea.IO.print(Sea.util.join(arg,","));
	end;
	
	--
	-- printTable (table, [rowname, level])
	--
	-- 	Recursively prints a table
	--
	-- Args:
	-- 	table - table to be printed
	-- 	rowname - row's name
	-- 	level - level of depth
	--
	printTable = function (table, rowname, level) 
		if ( level == nil ) then level = 1; end

		if ( type(rowname) == "nil" ) then rowname = "ROOT"; 
		elseif ( type(rowname) == "string" ) then 
			rowname = "\""..rowname.."\"";
		elseif ( type(rowname) ~= "number" ) then
			rowname = "*"..type(rowname).."*";
		end

		local msg = "";
		for i=1,level, 1 do 
			msg = msg .. "  ";	
		end

		if ( table == nil ) then 
			Sea.IO.print(msg,"[",rowname,"] := nil "); return 
		end
		if ( type(table) == "table" ) then
			Sea.IO.print (msg,rowname," { ");
			for k,v in table do
				Sea.io.printTable(v,k,level+1);
			end
			Sea.IO.print(msg,"}");
		elseif (type(table) == "function" ) then 
			Sea.IO.print(msg,"[",rowname,"] => {{FunctionPtr*}}");
		elseif (type(table) == "userdata" ) then 
			Sea.IO.print(msg,"[",rowname,"] => {{UserData}}");
		elseif (type(table) == "boolean" ) then 
			local value = "true";
			if ( not table ) then
				value = "false";
			end
			Sea.IO.print(msg,"[",rowname,"] => ",value);
		else	
			Sea.IO.print(msg,"[",rowname,"] => ",table);
		end
	end
};

-- Aliases:
Sea.io = Sea.IO;
