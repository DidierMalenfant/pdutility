--
--  pdutility.table - Handy utility functions for Playdate development.
--  Based on code originally by Nic Magnier, Matt Sephton.
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

table = table or {}		-- luacheck: globals table

-- luacheck: globals table.random
function table.random(t)
    if type(t) ~= "table" then return nil end

    return t[math.ceil(math.random(#t))]
end

-- luacheck: globals table.each
function table.each(t, funct)
    if type(funct)~="function" then
        return
    end

    for _, e in pairs(t) do
        funct(e)
    end
end

-- from https://stackoverflow.com/a/21287623/28290
-- Usage
-- local at = newAutotable(3);
-- print(at[0]) -- returns table
-- print(at[0][1]) -- returns table
-- print(at[0][1][2]) -- returns nil
-- at[0][1][2] = 2;
-- print(at[0][1][2]) -- returns value
-- print(at[0][1][3][3]) -- error, because only 3 dimensions set

-- luacheck: globals table.newAutotable
function table.newAutotable(dim)
    local MT = {};
    for i=1, dim do
        MT[i] = {__index = function(t, k)
            if i < dim then
                t[k] = setmetatable({}, MT[i+1])
                return t[k];
            end
        end}
    end

    return setmetatable({}, MT[1]);
end
