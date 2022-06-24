--
--  pdutility.debug - Handy utility functions for Playdate development.
--  Based on code originally by Denisov Yaroslav, Dustin Mierau.
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

pdutility = pdutility or {}
pdutility.debug = pdutility.debug or {}

local gfx <const> = playdate.graphics

-- Show Toast message (temporary text that pop up on the screen)
function pdutility.debug.showToast(x, y, text, duration)
    local t = playdate.frameTimer.new(duration)
    t.updateCallback = function()
        gfx.drawTextAligned(text, x, y, kTextAlignment.center)
    end
end

-- Graphs samples collected/frame against a specified sample duration
class("sampler", { }, pdutility.debug).extends()

function pdutility.debug.sampler:init(sample_period, sampler_fn)
	pdutility.debug.sampler.super.init()

    self.sample_period = sample_period
    self.sampler_fn = sampler_fn
    self:reset()
end

function pdutility.debug.sampler:reset()
    self.last_sample_time = nil
    self.samples = {}
    self.current_sample = {}
    self.current_sample_time = 0
    self.high_watermark = 0
end

function pdutility.debug.sampler:print()
    print("")

    print("Sampler Info")
    print("=================")
    print("Now: "..self.samples[#self.samples].." KB")
    print("High Watermark: "..self.high_watermark.." KB")

    local current_sample_avg = 0
    for _, v in ipairs(self.samples) do
        current_sample_avg += v
    end
    current_sample_avg /= #self.samples
    print("Average: "..current_sample_avg.." KB")

    print("Log:")
    for _, v in ipairs(self.samples) do
        print("\t"..v.." KB")
    end

    print("")
end

function pdutility.debug.sampler:draw(x, y, width, height)
    local time_delta = 0
    local current_time <const> = playdate.getCurrentTimeMilliseconds()
    local graph_padding <const> = 1
    local draw_height <const> = height - (graph_padding * 2)
    local draw_width <const> = width - (graph_padding * 2)

    if self.last_sample_time then
        time_delta = (current_time - self.last_sample_time)
    end
    self.last_sample_time = current_time

    self.current_sample_time += time_delta
    if self.current_sample_time < self.sample_period then
        self.current_sample[#self.current_sample + 1] = self.sampler_fn()
    else
        self.current_sample_time = 0
        if #self.current_sample > 0 then
            local current_sample_avg = 0
            for _, v in ipairs(self.current_sample) do
                current_sample_avg += v
            end
            current_sample_avg /= #self.current_sample
            self.high_watermark = math.max(self.high_watermark, current_sample_avg)
            if #self.samples == draw_width then
                table.remove(self.samples, 1)
            end
            self.samples[#self.samples + 1] = current_sample_avg
        end
        self.current_sample = {}
    end

    -- Render graph
    gfx.setColor(gfx.kColorWhite)
    gfx.fillRect(x, y, width, height)
    gfx.setColor(gfx.kColorBlack)

    for i, v in ipairs(self.samples) do
        local sample_height <const> = math.max(0, draw_height * (v / self.high_watermark))
        gfx.drawLine(x + graph_padding + i - 1,
                     y + height - graph_padding,
                     x + i - 1 + graph_padding,
                     (y + height - graph_padding) - sample_height)
    end
end
