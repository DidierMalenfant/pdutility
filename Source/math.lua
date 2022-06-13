-- Nic Magnier
function math.clamp(a, min, max)
	if min > max then
		min, max = max, min
	end
	return math.max(min, math.min(max, a))
end

-- Nic Magnier
function math.ring(a, min, max)
	if min > max then
		min, max = max, min
	end
	return min + (a-min)%(max-min)
end

-- Like clamp but instead of clamping it loop back to the start. Useful to cycle through values, for example an index in a menu
-- Nic Magnier
function math.ring_int(a, min, max)
	return math.ring(a, min, max+1)
end

-- Nic Magnier
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

-- Nic Magnier
function math.infinite_approach(at_zero, at_infinite, x_halfway, x)
	return at_infinite - (at_infinite-at_zero)*0.5^(x/x_halfway)
end

-- nick_splendorr
-- from http://lua-users.org/wiki/SimpleRound
-- rounds v to the number of places in bracket, i.e. 0.01, 0.1, 1, 10, etc
function math.round(v, bracket)
	bracket = bracket or 1

	-- path for additional precision 
	if bracket<1 then
		bracket = 1//bracket
		local half = (number >= 0 and 0.5) or -0.5
		return (number*bracket+half)//1/bracket
	end
	
	local half = (number >= 0 and bracket/2) or -bracket/2
	return ((number+half)//bracket)*bracket
end

-- nick_splendorr
-- round needs sign:
function math.sign(v)
	return (v >= 0 and 1) or -1
end