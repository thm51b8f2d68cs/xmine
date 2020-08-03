xDirData = dofile("/.getDirData.lua")
xroot = xDirData.xroot
xbin = xDirData.xbin
xdata = xDirData.xdata
xlib = xDirData.xlib


function main()
    os.loadAPI(xroot .. xlib .. "turtleGPS.lua")
    os.loadAPI(xroot .. xlib .. "gui.lua")
    if (isCoreShaftCompleted()) then
        return true
    end
    gui.displayWelcomeScreen()
    mineDimensions = getMineDimensions()
    excavateCoreShaft(mineDimensions)
    returnTurtle(mineDimensions["y depth"] + 14, 14)
    displayCoreShaftCompletion(mineDimensions)
end

function displayCoreShaftCompletion(mineDimensions)

    local x = mineDimensions["x dim"]
    local z = mineDimensions["z dim"]
    local y = mineDimensions["y depth"]

    print("Core shaft completed.")
    print("Mined:", x, "x", z, ":", y, "blocks down")
end

function isCoreShaftCompleted()
    turtle.forward()
    local x, y, z = gps.locate()
    local yOrigin = y
    refuelTurtle(1, y - 14, 1)
    while (y > 14) do
        if (turtle.detectDown()) then
            returnTurtle(yOrigin, y)
            return false
        else
            turtle.down()
            y = y - 1
        end
    end
    returnTurtle(yOrigin, y)
    return true
end

function getMineDimensions()

    local mineDimensions = {}
    --Dimensions will be referenced as follows
    -- x dim or x, z dim or z, and y depth or y, the y coord will be refenced
    --seperately as yCoord as it is used for calculations and is not a dimension

    print("\nPlace turtle on bottom left corner of\nwhere you want to mine...")

    io.write("\nEnter dimension x: ")
    local x = math.floor(tonumber(io.read()))
    print("X: ", x)
    mineDimensions["x dim"] = x

    io.write("\nEnter dimension z: ")
    local z = math.floor(tonumber(io.read()))
    print("Z: ", z)
    mineDimensions["z dim"] = z

    --Y must be less than 256 and greater than 14 for the safety of the user

    io.write("\nEnter Y coordinate: ")
    local yCoord = math.floor(tonumber(io.read()))
    if (yCoord >= 256 or yCoord <= 14) then
        while (yCoord >= 256 or yCoord <= 14) do
            print("\nEnter a Y coordinate that is below build height (256)")
            io.write("and above the minumum safety level (14): ")
            yCoord = math.floor(tonumber(io.read()))
        end
    end
    local y = yCoord - 14
    print("\nY level: ", y + 14)
    print("\nDepth of mine will be: ", y)
    mineDimensions["y depth"] = y

    return mineDimensions
end

function excavateCoreShaft(mineDimensions)

    --Account for the block the turtle
    --mines down by subtracting 1 from the
    --dimensions
    local x = mineDimensions["x dim"]
    local z = mineDimensions["z dim"]
    local y = mineDimensions["y depth"]

    --Check accuracy of table
    --[[print("X Dimension: ", x)
    print("Z Dimension", z)
    print("Y Depth: ", y)]]

    --Mine the dimensions down 1 layer(y coordinate) at a time.
    refuelTurtle(x, y, z)
    while (y > 0) do
        if (turtle.detectDown()) then
            turtle.digDown()
            turtle.down()
            excavateLayer(x, z)
            reorientTurtle()
        else
            turtle.down()
        end
        y = y - 1
    end
end

function excavateX(x)
    if (turtleGPS.getTurtleZ() % 2 == 0) then
        while (turtleGPS.getTurtleX() < x - 1) do
            turtle.dig()
            turtle.forward()
            turtleGPS.updateTurtleX((turtleGPS.getTurtleX() + 1))
        end
    else
        while (turtleGPS.getTurtleX() > 0) do
            turtle.dig()
            turtle.forward()
            turtleGPS.updateTurtleX((turtleGPS.getTurtleX() - 1))
        end
    end
end

function excavateLayer(x, z)
    --Mine x long z times
    while (turtleGPS.getTurtleZ() < z - 1) do
        excavateX(x)
        if (turtleGPS.getTurtleZ() % 2 == 0) then
            turtle.turnRight()
            turtle.dig()
            turtle.forward()
            turtleGPS.updateTurtleZ((turtleGPS.getTurtleZ() + 1))
            turtle.turnRight()
        else
            turtle.turnLeft()
            turtle.dig()
            turtle.forward()
            turtleGPS.updateTurtleZ((turtleGPS.getTurtleZ() + 1))
            turtle.turnLeft()
        end
    end
    --sentinel
    excavateX(x)
end

function reorientTurtle()
    if (turtleGPS.getTurtleX() > 0) then
        turtle.turnLeft()
        turtle.turnLeft()
        while (turtleGPS.getTurtleX() > 0) do
            turtle.forward()
            turtleGPS.updateTurtleX((turtleGPS.getTurtleX() - 1))
        end
        if (turtleGPS.getTurtleZ() == 0) then
            turtle.turnRight()
            turtle.turnRight()
        end
    end
    if (turtleGPS.getTurtleZ() > 0) then
        turtle.turnRight()
        while (turtleGPS.getTurtleZ() > 0) do
            turtle.forward()
            turtleGPS.updateTurtleZ((turtleGPS.getTurtleZ() - 1))
        end
        turtle.turnRight()
    end
end

function returnTurtle(yOrigin, yDepth)
    local yDisplacement = yOrigin - yDepth
    if (yDisplacement < 0) then
        --Set to because the refuelTurtle function argument increments the y displacement
        yDisplacement = -1
    end
    refuelTurtle(1, yDisplacement + 1, 1)
    while (yDepth < yOrigin) do
        turtle.digUp()
        turtle.up()
        yDepth = yDepth + 1
    end
    turtle.back()
end

function refuelTurtle(x, y, z)
    local fuelTask = x * y * z
    currentFuel = turtle.getFuelLevel()
    fuelNeeded = math.floor((fuelTask - currentFuel) / 80) + 1
    if (currentFuel < fuelTask) then
        turtle.refuel(fuelNeeded)
    end
end

return main()