turtleX = 0
turtleZ = 0

function setTurtlePos(x, z)
    turtleX = x
    turtleZ = z
end

function updateTurtleX(x)
    turtleX = x
    printTurtleX()
    os.sleep(1)
end

function updateTurtleZ(z)
    turtleZ = z
    printTurtleZ()
    os.sleep(1)
end

function getTurtleX()
    return turtleX
end

function getTurtleZ()
    return turtleZ
end

function printTurtleX()
    print(turtleX)
end

function printTurtleZ()
    print(turtleZ)
end

function printTurtlePos()
    print("X:", turtleX, "Z:", turtleZ)
end
