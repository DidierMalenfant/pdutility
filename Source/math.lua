--
--  pdutility.math - Handy utility functions for Playdate development.
--  Based on code originally by Nic Magnier, Nick Splendorr.
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

-- luacheck: globals math.clamp
function math.clamp(a, min, max)
	if min > max then
		min, max = max, min
	end

	return math.max(min, math.min(max, a))
end

-- luacheck: globals math.ring
function math.ring(a, min, max)
	if min > max then
		min, max = max, min
	end

	return min + (a-min)%(max-min)
end

-- Like clamp but instead of clamping it loop back to the start.
-- Useful to cycle through values, for example an index in a menu.
-- luacheck: globals math.ring_int
function math.ring_int(a, min, max)
	return math.ring(a, min, max+1)
end

-- luacheck: globals math.approach
function math.approach(value, target, step)
	if value==target then
		return value, true
	end

	local d = target-value
	if d>0 then
		value = value + step
		if value >= target then
			return target, true
		else
			return value, false
		end
	elseif d<0 then
		value = value - step
		if value <= target then
			return target, true
		else
			return value, false
		end
	else
		return value, true
	end
end

-- luacheck: globals math.infinite_approach
function math.infinite_approach(at_zero, at_infinite, x_halfway, x)
	return at_infinite - (at_infinite-at_zero)*0.5^(x/x_halfway)
end

-- from http://lua-users.org/wiki/SimpleRound
-- rounds v to the number of places in bracket, i.e. 0.01, 0.1, 1, 10, etc
-- luacheck: globals math.round
function math.round(v, bracket)
	bracket = bracket or 1

	-- path for additional precision
	if bracket < 1 then
		bracket = 1 // bracket
		local half = (v >= 0 and 0.5) or -0.5
		return (v * bracket + half) // 1 / bracket
	end

	local half = (v >= 0 and bracket / 2) or -bracket / 2

	return ((v + half) // bracket) * bracket
end

-- luacheck: globals math.sign
function math.sign(v)
	return (v >= 0 and 1) or -1
end
