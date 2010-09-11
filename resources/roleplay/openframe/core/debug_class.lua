-----------------------------------------------------------
--- /shared/debug_class.lua                             ---
--- Part of openFrame project                           ---
--- Uses functions from the Multi Theft Auto Wiki       ---
--- Additional code changes made by Orange              ---
--- Lately edited in revision number 12 by Orange       ---
--- Licensed under BSD licence                          ---
-----------------------------------------------------------

-- Title: Debug Class

--    Class: of.debug
--    Class which can be used to debug scripts
of.debug = of.class:new()

--	Function: of.debug:var_dump
--	This function outputs information about one or more variables using console output. 
--	
--	Arguments:
--		The function can have a variable number of arguments. Those arguments can be of three types
--		- Modifiers: A string that begins with a "-" (minus) and that is followed by at least another parameter is a modifier. A modifier can change the behaviour of the function. Modifiers don't have to be the first argument, they always work on all arguments after it (see examples).
--		- Names: A string that is followed by at least another parameter and isn't preceeded by another string (that is not a modifier), is a name. A name is output before the variable output, to make it recognizable (basicially a description of the variable that is being output, e.g. the name).
--		- Values: Any value that is not one of the two above will generate an output with information about the variable:
--			  o For strings: string(lengthOfString) "value"
--			  o For userdata: userdata(MTA element type) "value"
--			  o For tables: table(numerOfElements) "value"
--					+ If the table contains any elements, they will also be output if the appropriate modifiers are set. This will always be in the form [key] => value, while key and value are formatted by var_dump. 
--		
--	Modifiers:
--		* v (verbose): Dumps more data than usual (for now it outputs whole tables including subtables)
--		* n (normal): Switches back into 'normal' non-verbose mode.
--		* s (silent): With this activated, it outputs nothing at all, however it still returns the output, so you can use it yourself (also used internally for recursion).
--		* u (unnamed): Don't use names. Every string that is not a modifier will be output as a value, not a decription.
--		* d[number] (depth): Output nested tables up to this depth (e.g. "d1" means output all values of the initial table, but not the values of the values, if they are also tables). 
--
--	Returns:
--	Returns a string with all the output in one line and a table with several lines of output. 

function of.debug:var_dump(...)
	-- default options
	local verbose = false
	local firstLevel = true
	local outputDirectly = true
	local noNames = false
	local indentation = "\t\t\t\t\t\t"
	local depth = nil
 
	local name = nil
	local output = {}
	for k,v in ipairs(arg) do
		-- check for modifiers
		if type(v) == "string" and k < #arg and v:sub(1,1) == "-" then
			local modifiers = v:sub(2)
			if modifiers:find("v") ~= nil then
				verbose = true
			end
			if modifiers:find("s") ~= nil then
				outputDirectly = false
			end
			if modifiers:find("n") ~= nil then
				verbose = false
			end
			if modifiers:find("u") ~= nil then
				noNames = true
			end
			local s,e = modifiers:find("d%d+")
			if s ~= nil then
				depth = tonumber(string.sub(modifiers,s+1,e))
			end
		-- set name if appropriate
		elseif type(v) == "string" and k < #arg and name == nil and not noNames then
			name = v
		else
			if name ~= nil then
				name = ""..name..": "
			else
				name = ""
			end
 
			local o = ""
			if type(v) == "string" then
				table.insert(output,name..type(v).."("..v:len()..") \""..v.."\"")
			elseif type(v) == "userdata" then
				local elementType = "no valid MTA element"
				if isElement(v) then
					elementType = getElementType(v)
				end
				table.insert(output,name..type(v).."("..elementType..") \""..tostring(v).."\"")
			elseif type(v) == "table" then
				local count = 0
				for key,value in pairs(v) do
					count = count + 1
				end
				table.insert(output,name..type(v).."("..count..") \""..tostring(v).."\"")
				if verbose and count > 0 and (depth == nil or depth > 0) then
					table.insert(output,"\t{")
					for key,value in pairs(v) do
						-- calls itself, so be careful when you change anything
						local newModifiers = "-s"
						if depth == nil then
							newModifiers = "-sv"
						elseif  depth > 1 then
							local newDepth = depth - 1
							newModifiers = "-svd"..newDepth
						end
						local keyString, keyTable = self:var_dump(newModifiers,key)
						local valueString, valueTable = self:var_dump(newModifiers,value)
 
						if #keyTable == 1 and #valueTable == 1 then
							table.insert(output,indentation.."["..keyString.."]\t=>\t"..valueString)
						elseif #keyTable == 1 then
							table.insert(output,indentation.."["..keyString.."]\t=>")
							for k,v in ipairs(valueTable) do
								table.insert(output,indentation..v)
							end
						elseif #valueTable == 1 then
							for k,v in ipairs(keyTable) do
								if k == 1 then
									table.insert(output,indentation.."["..v)
								elseif k == #keyTable then
									table.insert(output,indentation..v.."]")
								else
									table.insert(output,indentation..v)
								end
							end
							table.insert(output,indentation.."\t=>\t"..valueString)
						else
							for k,v in ipairs(keyTable) do
								if k == 1 then
									table.insert(output,indentation.."["..v)
								elseif k == #keyTable then
									table.insert(output,indentation..v.."]")
								else
									table.insert(output,indentation..v)
								end
							end
							for k,v in ipairs(valueTable) do
								if k == 1 then
									table.insert(output,indentation.." => "..v)
								else
									table.insert(output,indentation..v)
								end
							end
						end
					end
					table.insert(output,"\t}")
				end
			else
				table.insert(output,name..type(v).." \""..tostring(v).."\"")
			end
			name = nil
		end
	end
	local string = ""
	for k,v in ipairs(output) do
		if outputDirectly then
			outputConsole(v)
		end
		string = string..v
	end
	return string, output
end

--	Function: of.debug:check
--	This function checks the given arguments and calls the error-function if something is wrong. Finally it makes debugging easier since you'll get useful error-messages when calling a selfmade function with wrong or malformed arguments.  
--	
--	Required Arguments:
--	* funcname: Name of the function in which the Check-function is called.
--	* types1: Type(s) that arg1 should/may be of. It's a string if only one type is possible, otherwise it can be a table with strings. Possible types are "nil", "boolean", "number", "string", "function", "table", "thread" and "userdata".
--	* arg1: Value of the argument that should be checked.
--	* argname1: Name of the argument whose value is arg1. 
--
--	Optional Arguments:
--	* ...: You may pass as many triples as you want to. 
--
--	Returns:
--	Returns nothing
function of.debug:check(funcname, ...)
    local arg = {...}
 
    if (type(funcname) ~= "string") then
        error("Argument type mismatch at 'Check' ('funcname'). Expected 'string', got '"..type(funcname).."'.", 2)
    end
    if (#arg % 3 > 0) then
        error("Argument number mismatch at 'Check'. Expected #arg % 3 to be 0, but it is "..(#arg % 3)..".", 2)
    end
 
    for i=1, #arg-2, 3 do
        if (type(arg[i]) ~= "string" and type(arg[i]) ~= "table") then
            error("Argument type mismatch at 'Check' (arg #"..i.."). Expected 'string' or 'table', got '"..type(arg[i]).."'.", 2)
        elseif (type(arg[i+2]) ~= "string") then
            error("Argument type mismatch at 'Check' (arg #"..(i+2).."). Expected 'string', got '"..type(arg[i+2]).."'.", 2)
        end
 
        if (type(arg[i]) == "table") then
            local aType = type(arg[i+1])
            for _, pType in next, arg[i] do
                if (aType == pType) then
                    aType = nil
                    break
                end
            end
            if (aType) then
                error("Argument type mismatch at '"..funcname.."' ('"..arg[i+2].."'). Expected '"..table.concat(arg[i], "' or '").."', got '"..aType.."'.", 3)
            end
        elseif (type(arg[i+1]) ~= arg[i]) then
            error("Argument type mismatch at '"..funcname.."' ('"..arg[i+2].."'). Expected '"..arg[i].."', got '"..type(arg[i+1]).."'.", 3)
        end
    end
end

--	Function: of.debug:print
--	This function prints debug string (you can see it in debugconsole).
--	
--	Required Arguments:
--		* text: the text to be output to the debug box. 
--
--	Optional Arguments:
--	* level: the debug message level. Possible values are:
--		  o 0: Custom message
--		  o 1: Error message
--		  o 2: Warning message
--		  o 3: Information message (default) 
--	* red: The amount of red in the color of the text. Default value is 255.
--	* green: The amount of green in the color of the text. Default value is 255.
--	* blue: The amount of blue in the color of the text. Default value is 255.
--	
--	Returns:
--	Returns true if the debug message was successfully output, false if invalid arguments are specified. 

function of.debug:print(a, b, c, d, e)
	return outputDebugScript(a,b,c,d,e)
end