-- Nic Magnier
function table.random(t)
	if type(t)~="table" then return nil end
	return t[math.ceil(math.random(#t))]
end

-- Nic Magnier
function table.each(t, funct)
	if type(funct)~="function" then		
		return
	end
	
	for _, e in pairs(t) do
		fn(e)
	end
end

-- Matt Sephton
function newAutotable(dim)
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

-- from https://stackoverflow.com/a/21287623/28290
-- Usage
-- local at = newAutotable(3);
-- print(at[0]) -- returns table
-- print(at[0][1]) -- returns table
-- print(at[0][1][2]) -- returns nil
-- at[0][1][2] = 2;
-- print(at[0][1][2]) -- returns value
-- print(at[0][1][3][3]) -- error, because only 3 dimensions set

