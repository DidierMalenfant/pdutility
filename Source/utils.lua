
-- Nic Magnier
function enum( t )
	local result = {}

	for index, name in pairs(t) do
		result[name] = index
	end

	return result
end

--I just declare my layer list at launch:
--layers = enum({
--	"background",
--	"enemies",
--	"player",
--	"clouds"
--})
-- and just use to setup my sprites
-- sprite:setZIndex(layer.player)
