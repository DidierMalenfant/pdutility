--
--  pdutility.utils.signal - Handy utility functions for Playdate development.
--  Based on code originally by Dustin Mierau.
--
--  MIT License
--  Copyright (c) 2022 Didier Malenfant.
--
--  Permission is hereby granted, free of charge, to any person obtaining a copy
--  of this software and associated documentation files (the "Software"), to deal
--  in the Software without restriction, including without limitation the rights
--  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
--  copies of the Software, and to permit persons to whom the Software is
--  furnished to do so, subject to the following conditions:
--
--  The above copyright notice and this permission notice shall be included in all
--  copies or substantial portions of the Software.
--
--  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
--  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
--  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
--  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
--  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
--  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
--  SOFTWARE.
--

-- signal - A Lua class for subscribing to keys and notifying subscribers of that key.
-- Example:
--  -- ... creating a global variable in main ...
--  NotificationCenter = Signal()
--
--  -- ... in code that needs to know when score has changed ...
--  NotificationCenter:subscribe("game_score", self, function(new_score, score_delta)
--     self:update_score(new_score)
--  end)
--
--  ... in code that changes the score ...
--  NotificationCenter:notify("game_score", new_score, score_delta)

import "CoreLibs/object"

pdutility = pdutility or {}					-- luacheck: globals pdutility
pdutility.utils = pdutility.utils or {}		-- luacheck: globals pdutility.utils

-- luacheck: globals pdutility.utils.signal
class("signal", { }, pdutility.utils).extends()

function pdutility.utils.signal:init()
	pdutility.utils.signal.super.init()

    self.listeners = {}
end

function pdutility.utils.signal:subscribe(key, bind, fn)
    local t = self.listeners[key]
    local v = {fn = fn, bind = bind}
    if not t then
        self.listeners[key] = {v}
    else
        t[#t + 1] = v
    end
    return fn
end

function pdutility.utils.signal:unsubscribe(key, fn)
    local t = self.listeners[key]
    if t then
        for i, v in ipairs(t) do
            if v.fn == fn then
                table.remove(t, i)
                break
            end
        end

        if #t == 0 then
            self.listeners[key] = nil
        end
    end
end

function pdutility.utils.signal:notify(key, ...)
    local t = self.listeners[key]
    if t then
        for _, v in ipairs(t) do
            v.fn(v.bind, key, ...)
        end
    end
end
