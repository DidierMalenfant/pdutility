--
--  pdutility.animatedImage - Handy utility functions for Playdate development.
--  Based on code originally written by Dustin Mierau.
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

import "CoreLibs/animation"
import "CoreLibs/object"

pdutility = pdutility or {}
pdutility.animation = pdutility.animation or {}

local gfx <const> = playdate.graphics
local anim <const> = gfx.animation

-- Graphs samples collected/frame against a specified sample duration
class('animatedImage', { }, pdutility.animation).extends()

function pdutility.animation.animatedImage.new(...)
    return pdutility.animation.animatedImage(...)
end

-- image_table_path should be a path to an image table.
-- options is a table of initial settings:
--   delay:
--   paused: start in a paused state.
--   loop: loop the animation.
function pdutility.animation.animatedImage:init(image_table_path, options)
    pdutility.animation.animatedImage.super.init(self)

    options = options or {}

    self.image_table = gfx.imagetable.new(image_table_path)
    if self.image_table == nil then
        print('ANIMATEDIMAGE: FAILED TO LOAD IMAGE TABLE AT', image_table_path)
        return nil
    end

    if options.sequence ~= nil then
        local temp_imagetable = gfx.imagetable.new(#options.sequence)

        for i, v in ipairs(options.sequence) do
            temp_imagetable:setImage(i, self.image_table:getImage(v))
        end

        self.image_table = temp_imagetable
    end

    self.animation_loop = anim.loop.new(options.delay or 100, self.image_table, options.loop and true or false)
    self.animation_loop.paused = options.paused and true or false
    self.animation_loop.startFrame = options.first or 1
    self.animation_loop.endFrame = options.last or self.image_table:getLength()
end

function pdutility.animation.animatedImage:reset()
    self.loop.frame = 1
end

function pdutility.animation.animatedImage:setDelay(delay)
    self.loop.delay = delay
end

function pdutility.animation.animatedImage:getDelay()
    return self.loop.delay
end

function pdutility.animation.animatedImage:setShouldLoop(should_loop)
    self.loop.shouldLoop = should_loop
end

function pdutility.animation.animatedImage:getShouldLoop()
    return self.loop.shouldLoop
end

function pdutility.animation.animatedImage:setPaused(paused)
    self.loop.paused = paused
end

function pdutility.animation.animatedImage:getPaused()
    return self.loop.paused
end

function pdutility.animation.animatedImage:setFrame(frame)
    self.loop.frame = frame
end

function pdutility.animation.animatedImage:getFrame()
    return self.loop.frame
end

function pdutility.animation.animatedImage:setFirstFrame(frame)
    self.loop.startFrame = frame
end

function pdutility.animation.animatedImage:setLastFrame(frame)
    self.loop.endFrame = frame
end

pdutility.animation.animatedImage.__index = function(animated_image, key)
    local proxy_value = rawget(pdutility.animation.animatedImage, key)
    if proxy_value then
        return proxy_value
    end

    proxy_value = animated_image.image_table:getImage(animated_image.loop.frame)[key]

    if type(proxy_value) == 'function' then
        rawset(animated_image, key, function(ai, ...)
            local img = ai.image_table:getImage(ai.loop.frame)
            return img[key](img, ...)
        end)

        return animated_image[key]
    end

    return proxy_value
end
