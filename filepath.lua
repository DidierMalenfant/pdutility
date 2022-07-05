--
--  pdutility.filepath - Handy utility functions for Playdate development.
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

pdutility = pdutility or {}
pdutility.filepath= pdutility.filepath or {}

function pdutility.filepath.filename(path)
    local path_length = #path

    for i = path_length, 1, -1 do
        if string.sub(path, i, i) == '/' then
            if i == path_length then
                return nil
            end

            return string.sub(path, i + 1, path_length)
        end
    end

    return path
end

function pdutility.filepath.extension(path)
    local path_length = #path

    for i = path_length, 1, -1 do
        local char = string.sub(path, i, i)
        if char == '/' then
            return nil
        end

        if string.sub(path, i, i) == '.' then
            if i == path_length then
                return nil
            end

            return string.sub(path, i + 1, path_length)
        end
    end

    return nil
end

function pdutility.filepath.directory(path)
    local path_length = #path

    for i = path_length, 1, -1 do
        if string.sub(path, i, i) == '/' then
            return string.sub(path, 1, i - 1)
        end
    end

    return nil
end

function pdutility.filepath.basename(path)
    local filename = pdutility.filepath.filename(path)
    if filename ~= nil then
        local filename_length = #path

        for i = filename_length, 1, -1 do
            if string.sub(path, i, i) == '.' then
                return string.sub(path, 1, i - 1)
            end
        end
    end

    return filename
end

function pdutility.filepath.join(path1, path2)
    return path1 .. '/' .. path2
end
