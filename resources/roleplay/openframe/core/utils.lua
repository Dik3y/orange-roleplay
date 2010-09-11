-----------------------------------------------------------
--- /shared/timer_class.lua                             ---
--- Part of openFrame project                           ---
--- Written by Orange                                   ---
--- Lately edited in revision number 11 by Orange       ---
--- Licensed under BSD licence                          ---
-----------------------------------------------------------

-- Title: Utility functions

--	Function: removeColorCoding
--	This function removes color tags from text/nicknames etc.
--
--	Returns:
--		Returns string without color codes
function removeColorCoding ( name )
	return type(name)=='string' and string.gsub ( name, '#%x%x%x%x%x%x', '' ) or name
end

--	Function: isServer
--	This function detects if the script is running serverside.
--
--	Returns:
--		Returns true if the side is server, false otherwise.
function isServer()
				return triggerClientEvent ~= nil	end


--	Function: isClient
--	This function detects if the script is running clientside.
--
--	Returns:
--		Returns true if the side is client, false otherwise.
function isClient()	
			return triggerServerEvent ~= nil	end
			
ResourceRoot = getResourceRootElement(getThisResource())