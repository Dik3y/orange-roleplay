-----------------------------------------------------------
--- /shared/class_class.lua                             ---
--- Part of openFrame project                           ---
--- Written by Orange                                   ---
--- Lately edited in revision number 12 by Orange       ---
--- Licensed under BSD licence                          ---
-----------------------------------------------------------

-- Title: Main Class

-- Class: of
-- Main Class
of = {}

-- Class: of.version
-- Class which has info about the used version of openFrame
of.version = {}

-- String: of.version.type
-- Type of used version
of.version.type = "Work"

-- Integer: of.version
-- Number with used version
of.version.number = 3

-- String: of.version.string
-- Full string with version name
of.version.string = "1.0 Alpha-1.2"

-- String: of.version.type
-- Type of used version

-- Class: of.class
-- Class which creates other classes
of.class = {}
of.class.__index = of.class;

-- Function: of.class:new
-- Creates a new class
--
-- Required arguments:
--		inherit - (table/class) Table which the new class will inherit.
--		
--	Optional arguments:
--		elementData - (bool) If true, makes a "class.data" metatable
--					  which dynamically gets and sets elementData.
--		element - (element) The element which the data will be set for.
--	
--	Returns:
--		The result is a class

function of.class:new( inherit, elementData, element )
	local object = { element = element }
	object.__index = object
	
	setmetatable(object, inherit)
	
	if inherit then
		object.__index = inherit
	end
	
	
	if elementData == true then
		object.data = {}
		setmetatable(object.data, { __index = function(w) return getElementData(self.element, w) end, __newindex = function(w,x,z) return setElementData(self.element, w, z) end })
	end
	
	return object;
end