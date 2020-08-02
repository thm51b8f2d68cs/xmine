xDirData = dofile("/.getDirData.lua")
xroot = xDirData.xroot
xbin = xDirData.xbin
xlib = xDirData.xlib
xdata = xDirData.xdata

vectors = {}

function main()
    path = xroot .. xdata .. ".excavations.txt"
    createVectorsFromFile(path)
    return isNearCoreShaft(gps.locate())
end

function isNearCoreShaft(x, y, z)
    currentLocation = vector.new(x,y,z)
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
    excavationData = io.open(path, "r")
    lineNum = 1
    index = 1
    x = 0
    y = 0
    z = 0
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
            vectors.index = vector.new(x,y,z)
            index = index + 1
        end
    end
    excavationData:close()
end

return main()