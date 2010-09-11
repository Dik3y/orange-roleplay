-----------------------------------------------------------
--- /shared/event_class.lua                             ---
--- Part of openFrame project                           ---
--- Written by Orange                                   ---
--- Lately edited in revision number 10 by Orange       ---
--- Licensed under BSD licence                          ---
-----------------------------------------------------------

-- Title: Event Class

--    Class: Event
--    Class which creates new events from a string
Event = of.class:new()

--	Function: Event:Create
--	Creates a new event object.
--	
--	Required arguments:
--		name - (string) Name of the event to create.
--		
--	Optional arguments:
--		multi - (bool) Can the client/server call this server/client event?
--	
--	Returns:
--		The result is a event class
function Event:Create(name, multi)
	local object = of.class:new(self)
	object.nam = name
	
	if multi == nil then
		multi = true
	end
	
	if addEvent(name, multi) then
		return object;	
	end
	return false;
end

--	Function: Event:Use
--	Creates a new event object from existing event name.
--	
--	Required arguments:
--		name - (string) Name of the event to create the object from.
--	
--	Returns:
--		The result is a event class
function Event:Use(name)
	local object = of.class:new(self)
	object.nam = name
	return object;	
end

--	Function: Event:Handle
--	Creates a new event object.
--	
--	Required arguments:
--		func - (function) The handler function you wish to call when the event is triggered. This function will be passed all of the event's parameters as arguments, but it isn't required that it takes all of them. 
--		
--	Optional arguments:
--		to - (element) The element you wish to attach the handler to. The handler will only be called when the event it is attached to is triggered for this element, or one of its children. Often, this can be the root element (meaning the handler will be called when the event is triggered for any element).
--
--	Returns:
--		Returns true if the event handler was attached successfully. Returns false if the specified event could not be found or any parameters were invalid. 	
function Event:Handle(func, to)
	if not to then
		to = getRootElement();
	end

	return addEventHandler(self.nam, to, func)
end

--	Function: Event:Trigger
--	Triggers event from the current side (if server, then server event).
--	
--	Required arguments:
--		src - (element) The element you wish to trigger the event on.
--		
--	Optional arguments:
--		... - (everything) Arguments passed to the handler after triggering.
--	
--	Returns:
--  	* Returns nil if the arguments are invalid or the event could not be found.
--  	* Returns true if the event was triggered successfully, and was not cancelled using cancelEvent.
--  	* Returns false if the event was triggered successfully, and was cancelled using cancelEvent. 

function Event:Trigger(src, ...)
	local t = pack(...)
	return triggerEvent(self.nam, src, unpack(t));
end

--	Function: Event:SideTrigger
--	Triggers event from the other side (if on server, then client event).
--	
--	 Required Arguments:
--		* src: The element that is the source of the event. This could be another player, or if this isn't relevant, use the root element. 
--		
--	Optional Arguments:
--		* triggerFor: The event will be triggered on all players that are children of the specified element. By default this is the root element, and hence the event is triggered on all elements. If you specify a single player it will just be triggered for that player.
--		* arguments...: A list of arguments to trigger with the event. You can pass any lua data type (except functions). You can also pass elements. 	

function Event:SideTrigger(src, ...)
	if isClient() then
		return triggerServerEvent(self.nam, src, ...);
	else
		if type(src) == "string" then
			return triggerClientEvent(src, self.nam, ...);
		else
			return triggerClientEvent(self.nam, src, ...)
		end
	end
end