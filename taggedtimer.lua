-- taggedtimer.lua
--
-- Common github module
-- Drop-in replacement for Corona's timer API
--
-- The MIT License (MIT)
--
-- (c) Ingemar Bergmark (www.swipeware.com)
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.
 
local timerStack = {}

local removeTimer = function(id)
    timerStack[id] = nil
end

local defaultListener = function(event)
    local timerHandle = event.source

    timerHandle.params.pass = timerHandle.params.pass + 1

    if (type(timerHandle.params.listener) == "table") then
        timerHandle.params.listener.timer(event)
    else -- assume function listener
        timerHandle.params.listener(event)
    end

    if (timerHandle.params.pass == timerHandle.params.iterations) then
        removeTimer(timerHandle.params.id)
    end
end

timer.corona_performWithDelay = timer.performWithDelay
timer.performWithDelay = function(delay, listener, arg3, arg4)
    assert(delay, "delay mandatory")
    assert(listener, "listener mandatory")
    if (type(listener) == "table") then
        assert(listener.timer, "timer method mandatory for table listeners")
    end

    local timerID = "timer"..tostring(system.getTimer())
    local iterations = 1
    local tag = nil

    if (type(arg3) == "number") then
        iterations = arg3
    end

    if (type(arg3) == "string") then
        tag = arg3 
    end

    if (type(arg4) == "string") then
        tag = arg4
    end

    timerStack[timerID] = timer.corona_performWithDelay(delay, defaultListener, iterations)
    timerStack[timerID].params = {}
    timerStack[timerID].params.id = timerID
    timerStack[timerID].params.listener = listener
    timerStack[timerID].params.pass = 0    
    timerStack[timerID].params.isPaused = false
    timerStack[timerID].params.iterations = iterations
    timerStack[timerID].params.tag = tag

    return timerID
end

timer.corona_cancel = timer.cancel
timer.cancel = function(id, logError)
    if (logError == nil) then
        logError = true
    end
    
    local found = false

    local doCancel = function(id)
        found = true
        timer.corona_cancel(timerStack[id])
        removeTimer(id)
    end

    if (id) then
        if (timerStack[id]) then
            doCancel(id)
        else -- find tags
            for k, t in pairs(timerStack) do
                if (t.params.tag == id) then
                    doCancel(k)
                end
            end

            if (not found) and (logError) then
                print("timer.cancel(): id/tag '"..id.."' not found.")
            end
        end
    else
        for k, v in pairs(timerStack) do
            doCancel(k)
        end
    end

    return found
end

timer.corona_pause = timer.pause
timer.pause = function(id, logError)
    if (logError == nil) then
        logError = true
    end

    local timeRemaining
    local found = false

    local doPause = function(id)
        found = true
        timeRemaining = timer.corona_pause(timerStack[id])
        timerStack[id].params.isPaused = true
    end

    if (id) then
        if (timerStack[id]) then
            doPause(id)        
        else -- find tags
            for k, t in pairs(timerStack) do
                if (t.params.tag == id) then
                    doPause(k)
                end
            end

            if (not found) and (logError) then
                print("timer.pause(): id/tag '"..id.."' not found.")
            end
        end
    else
        for k, v in pairs(timerStack) do
            doPause(k)
        end

        timeRemaining = nil     -- set to nil when no specific timer id is given
    end

    return timeRemaining, found
end

timer.corona_resume = timer.resume
timer.resume = function(id, logError)
    if (logError == nil) then
        logError = true
    end

    local timeRemaining
    local found = false

    local doResume = function(id)
        found = true

        if (timerStack[id].params.isPaused) then
            timeRemaining = timer.corona_resume(timerStack[id])
            timerStack[id].params.isPaused = false
        end
    end

    if (id) then
        if (timerStack[id]) then
            doResume(id)
        else -- find tags
            for k, t in pairs(timerStack) do
                if (t.params.tag == id) then
                    doResume(k)
                end
            end

            if (not found) and (logError) then
                print("timer.resume(): id/tag '"..id.."' not found.")
            end
        end
    else
        for k, v in pairs(timerStack) do
            doResume(k)
        end

        timeRemaining = nil     -- set to nil when no specific timer id is given
    end

    return timeRemaining, found
end

print("**** Corona timer API replaced with 'taggedtimer.lua' from Swipeware's github repository ****")
