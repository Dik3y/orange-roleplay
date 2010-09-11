-----------------------------------------------------------
--- /shared/command_class.lua                           ---
--- Part of openFrame project                           ---
--- Written by Orange                                   ---
--- Lately edited in revision number 12 by Orange       ---
--- Licensed under BSD licence                          ---
-----------------------------------------------------------

-- Title: Command Class

--    Class: Command
--    Class which creates new commands
Command = of.class:new()

--	Function: Command:Create
--	Creates a new command object.
--	
--	Required arguments:
--		name - (string) Name of the command to create.
--		func - (function) Function which will be called when someone would type the command.
--
--		
--	Optional arguments:
--		restricted - (bool) Is the command restricted by ACL?
--		sensitive - (bool) Is the command case sensitive?
--	
--	Returns:
--		The result is a command class
function Command:Create(name, func, restricted, sensitive)
	local object = of.class:new(self)
	object.name = name
	
	if addCommandHandler(name, func, restricted, sensitive) then
		return object;	
	end
	return false;
end

--	Function: Command:Use
--	Creates a new command object from existing command name.
--	
--	Required arguments:
--		name - (string) Name of the command.
--
--	Returns:
--		The result is a command class

function Command:Use(name)
	local object = of.class:new(self)
	object.name = name
	return object;	
end

--	Function: Command:Remove
--	Removes command handler
--		
--	Optional arguments:
--		handler - (function) The function handler to remove
--	
--	Returns:
--		Returns true if successfully removed.
--		Returns false if not.
function Command:Remove(handler) 
	return removeCommandHandler(self.name, handler);
end

--	Function: Command:Execute
--	Executes command handler
--		
--	Server - required arguments:
--		player - (element) A player which "executes" the command.
--		
--	Server and server - optional arguments:
--		arguments - (string) Additional parameters that will be passed to the
--		            handler function(s) of the command that is called, separated by spaces. 
--					
--	Returns:
--		Returns true if successfully executed.
--		Returns false if not.
function Command:Execute(arg1, arg2)
	if isServer() then return executeCommandHandler(self.name, arg1, arg2); end
	return executeCommandHandler(self.name, arg1)
end