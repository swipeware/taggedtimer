A simple Corona SDK module which is a drop-in replacement for the Corona timer.* API.  
Supports all functions of the original timer API with the added ability to:

- Add a tag name to timers  
- Cancel / Pause / Resume timers by tag name
- Cancel / Pause / Resume all active timers


#Usage
```
-- main.lua

require( "taggedtimer" )
```

Place the require statement at the top of your main.lua. (No need to declare  a return variable as it replaces the existing timer API)  
You only need to require it once. The new timer functionality will be available to all other modules in your project.


#Functions
####Declare a timer  
```
timer.performWithDelay(delay, listener [, iterations] [, tagname])  
```
Returns a timer reference which can be used in pause() cancel() and resume().

**delay (required)**  
Number. The delay in milliseconds, for example, 1000 = 1 second

**listener (required)**  
Listener. The listener to invoke after the delay. This may be either a function listener or a table listener. If a table listener, it must have a timer method because timer events are sent to the listener.

**iterations (optional)**  
Number. Optionally specifies the number of times listener is to be invoked. By default, it is 1; pass 0 or -1 if you want the timer to loop forever.

**tagname (optional)**  
String. Optionally specifies a tag name for use when pausing, resuming or cancelling timers.

----
####Cancel a timer  
```
timer.cancel()  
timer.cancel(timerReference, log)  
timer.cancel(tagName, log)
```
Returns 1 value. 'Found' (boolean). 'Found' indicates if any timers have been cancelled. If no timers were cancelled 'Found' will be false.

####Pause a timer  
```
timer.pause()  
timer.pause(timerReference, log)  
timer.pause(tagName, log)  
```

Returns 2 values. 'Time' (number), and 'Found' (boolean). 'Time' is the time remaining for the timer being paused. Will be nil when called with no arguments. 'Found' indicates if any timers have been paused. If no timers were paused 'Found' will be false.

####Resume a timer  
```
timer.resume()  
timer.resume(timerReference, log)  
timer.resume(tagName, log)  
```

Returns 2 values. 'Time' (number), and 'Found' (boolean). 'Time' is the time remaining for the timer being resumed. Will be nil when called with no arguments. 'Found' indicates if any timers have been resumed. If no timers were resumed 'Found' will be false.

**No arguments**  
Will cancel / pause or resume all active timers.

**timerReference (optional)**  
Reference. The reference returned by timer.performWithDelay()

**tagName (optional)**  
String. Tag name as specified in the call to timer.performWithDelay()

**log (optional)**  
Boolean. Log a message in the console if timerReference or tagName not found. Defaults to true.
