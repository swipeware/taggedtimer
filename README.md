A simple Corona SDK module which is a drop-in replacement for the Corona timer.* API.  
Supports all functions of the original timer API with the added ability to:

- Add tag name to timers  
- Cancel / Pause / Resume timers by tag name
- Cancel / Pause / Resume all active timers


#Usage
```
-- main.lua

require( "taggabletimer" )
```

Place the require statement at the top of your main.lua.  
You only need to require it once. The new timer functionality will be available to all other modules in your project.


#Functions
```
timer.performWithDelay(delay, listener [, iterations] [, tagname])  
```
**delay (required)**  
Number. The delay in milliseconds, for example, 1000 = 1 second

**listener (required)**  
Listener. The listener to invoke after the delay. This may be either a function listener or a table listener. If a table listener, it must have a timer method because timer events are sent to the listener.

**iterations (optional)**  
Number. Optionally specifies the number of times listener is to be invoked. By default, it is 1; pass 0 or -1 if you want the timer to loop forever.

**tagname (optional)**  
String. Optionally specifies a tag name for use when pausing, resuming or cancelling timers.

```
timer.cancel()  
timer.cancel(timerReference)  
timer.cancel(tagName)  
```
```
timer.pause()  
timer.pause(timerReference)  
timer.pause(tagName)  
```
```
timer.resume()  
timer.resume(timerReference)  
timer.resume(tagName)  
```
**No arguments**  
Will cancel / pause or resume all active timers.

**timerReference (optional)**  
Reference. The reference returned by timer.performWithDelay()

**tagName (optional)**  
String. Tag name as specified in the call to timer.performWithDelay()
