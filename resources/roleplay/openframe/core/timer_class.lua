-----------------------------------------------------------
--- /shared/timer_class.lua                             ---
--- Part of openFrame project                           ---
--- Written by Orange                                   ---
--- Lately edited in revision number 10 by Orange       ---
--- Licensed under BSD licence                          ---
-----------------------------------------------------------

-- Class: Timer Class
-- Class which creates timers in a class form
Timer = of.class:new()

--	Function: Timer:Create
--	Creates a timer object
--	
--	Required Arguments:
--	   * func: The function you wish the timer to call.
--	   * time: The number of milliseconds that should elapse before the function is called. (the minimum is 50)(1000 milliseconds = 1 second)
--	   * times: The number of times you want the timer to execute, or 0 for infinite repetitions. 
--
--	Optional Arguments:
--	   * ...: Any arguments you wish to pass to the function can be listed after the timesToExecute argument. Note that any tables you want to pass will get cloned, whereas metatables will get lost. Also changes you make in the original table before the function gets called won't get transfered.
--	   
--	Returns:
--		The result is a timer object
function Timer:Create(func, time, times, ...)
	local object = of.class:new(self)
	object.handler = setTimer(func, time, times, ...)
	
	if object.handler then
		return object;	
	end
	return false;
end

--	Function: Timer:Reset
--	This function allows you to reset the elapsed time in existing timers to zero. The function does not reset the 'times to execute' count on timers which have a limited amout of repetitions. 
--
--	Returns:
--		Returns true if the timer was successfully reset, false otherwise. 
function Timer:Reset() 
	return resetTimer(self.handler);
end


--	Function: Timer:Kill
--	This function allows you to kill/halt existing timer. 
--
--	Returns:
--		Returns true if the timer was successfully killed, false if not. 
function Timer:Kill()
	return killTimer(self.handler)
end