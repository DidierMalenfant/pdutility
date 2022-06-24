--
--  pdutility.utils.state - Handy utility functions for Playdate development.
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

--
-- signal - A Lua class for subscribing to keys and notifying subscribers of that key.
--
-- Example:
--  GameState = State()
--  GameState.score = 0
--
--  -- ... in code that needs to know when game score changes ...
--  GameState:subscribe("score", self, function(old_value, new_value)
--      if old_value ~= new_value then
--          self:update_game_score(new_value)
--      end
--  end)
--
--  -- ... in code that changes the game score, all subscribers of "score" on GameState will be
--         notified of the new value ...
--  GameState.score = 5
--

import "CoreLibs/object"

import "signal"

pdutility = pdutility or {}
pdutility.utils = pdutility.utils or {}

local allowed_variables = {
    __data = true,
    __signal = true
}

class('state', { }, pdutility.utils).extends()

function pdutility.utils.state.new(...)
    return pdutility.utils.state(...)
end

function pdutility.utils.state:init()
    pdutility.utils.state.super.init(self)

    self.__data = {}
    self.__signal = pdutility.utils.signal()
end

function pdutility.utils.state:__newindex(index, value)
    if allowed_variables[index] then
        rawset(self, index, value)
        return
    end

    -- Give metatable values priority.
    local mt = getmetatable(self)
    if mt[index] ~= nil then
        rawset(mt, index, value)
        return
    end

    -- Store value in our shadow table.
    local old_value = self.__data[index]
    self.__data[index] = value

    -- Notify anyone listening about the change.
    self.__signal:notify(index, old_value, value)
end

function pdutility.utils.state:__index(index)
    if allowed_variables[index] then
        return rawget(self, index)
    end

    -- Give metatable values priority.
    local mt = getmetatable(self)
    if mt[index] ~= nil then
        return rawget(mt, index)
    end

    -- Fetch value from shadow table.
    return self.__data[index]
end

function pdutility.utils.state:subscribe(key, bind, fn)
    self.__signal:subscribe(key, bind, fn)
end

function pdutility.utils.state:unsubscribe(key, fn)
    self.__signal:unsubscribe(key, fn)
end
