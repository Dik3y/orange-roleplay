-----------------------------------------------------------
--- /shared/store_class.lua                             ---
--- Part of openFrame project                           ---
--- Written by Orange                                   ---
--- Lately edited in revision number 10 by Orange       ---
--- Licensed under BSD licence                          ---
-----------------------------------------------------------

-- Title: Storage Class

-- Class: of.store
-- Class which stores handlers and objects (for example SQL Connections).
of.store = of.class:new();
of.store.storage = {};

--	Function: of.store:Set
--	Sets a value in temporary database under specified key
--	
--	Required arguments:
--		ident - (string) Key of the row in temporary database
--		val - (everything) Value of the row
--	
--	Returns:
--		The result is boolean - true if successfully done, false if not.
function of.store:Set(ident, val)
	if ident == nil or val == nil then
		return false
	end
	
	self.storage[ident] = val
	return true
end

--	Function: of.store:Get
--	Gets a value in temporary database stored under specified key
--	
--	Required arguments:
--		ident - (string) Key of the row in temporary database
--	
--	Returns:
--		The result may be the value of row if found, false if not.
function of.store:Get(ident)
	if self.storage[ident] == nil then
		return false
	end
	return self.storage[ident]
end

--	Function: of.store:List
--	Returns a table with temporary database (good for searching).
--	
--	Returns:
--		Table with temporary database.
function of.store:List()
	return self.storage
end