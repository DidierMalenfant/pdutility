--
--  pdutility.graphics.parallax - Handy utility functions for Playdate development.
--  Based on code originally by Robert Curry.
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

import "CoreLibs/graphics"
import "CoreLibs/object"

import "math"

pdutility = pdutility or {}
pdutility.graphics = pdutility.graphics or {}

local gfx <const> = playdate.graphics

class('parallax', { }, pdutility.graphics).extends(gfx.sprite)

function pdutility.graphics.parallax:init()
    pdutility.graphics.parallax.super.init(self)

    self.layers = {}
end

function pdutility.graphics.parallax:draw(...)
    gfx.setClipRect(...)

    for _, layer in ipairs(self.layers) do
        local img = layer.image
        -- lock offset to steps of 2 to reduce flashing
        local offset = layer.offset - (layer.offset % 2)
        local w = layer.width
        img:draw(self.x+offset, self.y)
        if offset < 0 or offset > w - self.width then
            if offset > 0 then
                img:draw(self.x+offset-w, self.y)
            else
                img:draw(self.x+offset+w, self.y)
            end
        end
    end

    gfx.clearClipRect()
end

function pdutility.graphics.parallax:addLayer(img, depth)
    local w, _ = img:getSize()
    local layer = {}
    layer.image = img
    layer.depth = depth
    layer.offset = 0
    layer.width = w

    table.insert(self.layers, layer)
end

function pdutility.graphics.parallax:scroll(delta)
    for _, layer in ipairs(self.layers) do
        layer.offset = math.ring(layer.offset + (delta * layer.depth), -layer.width, 0)
    end

    self:markDirty()
end
