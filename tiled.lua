--
--  pdutility.graphics.tiled - Helper class for loading game data from a Tiled JSON file.
--  Based on code originally provided a an example in the Playdate SDK.
--
--  MIT License
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

import '../toyboxes/DidierMalenfant/pdutility/filepath.lua'

pdutility = pdutility or {}
pdutility.graphics = pdutility.graphics or {}
pdutility.graphics.tiled = pdutility.graphics or {}

local gfx <const> = playdate.graphics
local file <const> = playdate.file
local path <const> = pdutility.filepath

-- loads the json file and returns a Lua table containing the data
local function getjson_tableFromTiledFile(level_path)
    local f = file.open(level_path)
    if file == nil then
        print('Error opening level file.')
        return nil
    end

    local s = file.getSize(level_path)
    local level_data = f:read(s)
    f:close()

    if level_data == nil then
        print('Error reading level data.')
        return nil
    end

    local json_table = json.decode(level_data)
    if json_table == nil then
        print('Error decoding JSON data.')
        return nil
    end

    return json_table
end

-- returns an array containing the tile sets from the json file
local function getTilesetsFromJSON(json_table, parent_folder)
    local tilesets = {}

    for i=1, #json_table.tilesets do
        local tileset = json_table.tilesets[i]
        if tileset.source ~= nil then
            print('Error: Tilesets need to be embedded in the Tiled map.')
            return nil
        end

        local new_tileset = {}
        new_tileset.firstgid = tileset.firstgid
        new_tileset.lastgid = tileset.firstgid + tileset.tilecount - 1
        new_tileset.name = tileset.name
        new_tileset.tileHeight = tileset.tileheight
        new_tileset.tileWidth = tileset.tilewidth

        local table_index = string.find(tileset.image, '-table-')
        if table_index == nil then
            print('Error: Invalid image name for tileset.')
            return nil
        end

        local tileset_image_name = string.sub(tileset.image, 1, table_index - 1)
        if parent_folder ~= nil then
            tileset_image_name = path.join(parent_folder, tileset_image_name)
        end

        new_tileset.imageTable = gfx.imagetable.new(tileset_image_name)
        if new_tileset.imageTable == nil then
            print('Error creating new imagetable.')
            return nil
        end

        tilesets[i] = new_tileset
    end

    return tilesets
end

-- utility function for importTilemapsFromTiledJSON()
local function tilesetWithName(tilesets, name)
    for _, tileset in pairs(tilesets) do
        if tileset.name == name then
            return tileset
        end
    end

    return nil

end

local function tileset_nameForProperies(properties)
    for _, property in ipairs(properties) do
        if property.name == 'tileset' then
            return property.value
        end
    end
    return nil
end

local function collisions_onForProperies(properties)
    for _, property in ipairs(properties) do
        if property.name == 'collisions_on' then
            return property.value == true
        end
    end

    return false
end

-- loads the data we are interested in from the Tiled json file
-- returns custom layer tables containing the data, which are basically a
-- subset of the layer objects found in the Tiled file
function pdutility.graphics.tiled.importTilemapsFromTiledJSON(tiled_json_path)
    local json_table = getjson_tableFromTiledFile(tiled_json_path)
    if json_table == nil then
        return nil
    end

    -- load tile sets
    local parent_folder = path.directory(tiled_json_path)
    local tilesets = getTilesetsFromJSON(json_table, parent_folder)
    if tilesets == nil then
        return nil
    end

    -- create tile maps from the level data and already-loaded tile sets
    local layers = {}

    for i = 1, #json_table.layers do
        local level = {}
        local layer = json_table.layers[i]

        level.name = layer.name
        level.x = layer.x
        level.y = layer.y
        level.tileHeight = layer.height
        level.tileWidth = layer.width

        local tileset = nil
        local properties = layer.properties
        if properties ~= nil then
            local tileset_name = tileset_nameForProperies(properties)
            if tileset_name ~= nil then
                tileset = tilesetWithName(tilesets, tileset_name)
                level.pixelHeight = level.tileHeight * tileset.tileHeight
                level.pixelWidth = level.tileWidth * tileset.tileWidth

                local tilemap = gfx.tilemap.new()
                assert(tilemap)

                tilemap:setImageTable(tileset.imageTable)
                tilemap:setSize(level.tileWidth, level.tileHeight)

                -- we want our indexes for each tile set to be 1-based, so remove the offset that Tiled adds.
                -- this is only makes sense because because we have exactly one tile map image per layer
                local index_modifier = tileset.firstgid - 1

                local tileData = layer.data
                local x = 1
                local y = 1

                for j = 1, #tileData do
                    local tile_index = tileData[j]

                    if tile_index > 0 then
                        tile_index = tile_index - index_modifier
                        tilemap:setTileAtPosition(x, y, tile_index)
                    end

                    x = x + 1

                    if x > level.tileWidth - 1 then
                        x = 0
                        y = y + 1
                    end
                end

                level.tilemap = tilemap
                layers[layer.name] = level
            end

            level.collisions_on = collisions_onForProperies(properties)
        end

        if tileset == nil then
            print('Could not find a tileset name property for layer \'' .. layer.name .. '\'')
        end
    end

    local tile_width = json_table.tilewidth
    if tile_width == nil then
        print('Error: Can\'t read tile width from Tiles data.')
        return nil
    end

    local tile_height = json_table.tileheight
    if tile_height == nil then
        print('Error: Can\'t read tile height from Tiles data.')
        return nil
    end

    return layers, tile_width, tile_height
end
