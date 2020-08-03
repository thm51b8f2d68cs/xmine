xDirData = dofile("/.getDirData.lua")
xroot = xDirData.xroot
xbin = xDirData.xbin
xlib = xDirData.xlib
xdata = xDirData.xdata

vectors = {}

function main()
    local path = xroot .. xdata .. ".excavations.txt"
    createVectorsFromFile(path)
    return isNearCoreShaft(gps.locate())
end

function isNearCoreShaft(x, y, z)
    local currentLocation = vector.new(x, y, z)
    for index in pairs(vectors) do
        if (currentLocation - index < 500) then
            return true
        end
    end
    return false
end

function createVectorsFromFile(path)
    --excavations.txt should be formatted as
    --x
    --y
    --z
    --x
    --y
    --z
    local excavationData = io.open(path, "r")
    local lineNum = 1
    local index = 1
    local x = 0
    local y = 0
    local z = 0
    for line in excavationData:lines() do
        if (lineNum < 3) then
            if (lineNum == 1) then
                x = excavationData:read("*n")
                lineNum = lineNum + 1
            else
                y = excavationData:read("*n")
                lineNum = lineNum + 1
            end
        else
            z = excavationData:read("*n")
            lineNum = 1
            vectors.index = vector.new(x, y, z)
            index = index + 1
        end
    end
    excavationData:close()
end

return main()