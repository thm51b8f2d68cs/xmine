choices = "[auto - recommended/manual/exit]"
xDirData = dofile("/.getDirData.lua")
xroot = xDirData.xroot
xbin = xDirData.xbin
xlib = xDirData.xlib
xdata = xDirData.xdata
excavationsPath = xroot .. xdata .. ".excavations.txt"

function main()
    os.loadAPI(xroot .. xlib .. "gui.lua")
    gui.displayWelcomeScreen()
    runXMine(gui.promptUser(choices))
end

function runXMine(userChoice)
    if (userChoice == "auto") then
        autoSetup()
    elseif (userChoice == "manual") then
        manualSetup()
    elseif (userChoice == "exit") then
        return
    else
        print("Please enter an option.")
        runXMine(gui.promptUser(choices))
    end
end

function manualSetup()
    choice = gui.promptUser("[Excavate core shaft/Excavate quandrant shaft]")
    if (choice == "Excavate core shaft") then
        runCoreShaft()
    elseif (choice == "Excavate quandrant shaft") then
        runQuadrantShaft()
    else
        print("Please enter an option.")
        manualSetup()
    end
end

function autoSetup()

    --Read excavation file to see if a core shaft has already been dug in the vicinity of 500 blocks
    if (not dofile(xroot .. xbin .. "shaftLogger.lua")) then
        runCoreShaft()
    else
        runQuadrantShaft()
    end
end

function runCoreShaft()
    shell.run(xroot .. xbin .. "excavateCoreShaft.lua")
    --Ask user if it ran correctly eg. did it excavate the desired dimensions
    --or was there an error like the turtle did not finish
    checkForShaftCompletion()
    logCoreShaftExcavation()
end

function checkForShaftCompletion()
    choice = gui.promptUser("\nDid your turtle excavate the core as desired?\n [Yes/No - there were errors/exit]")
    if (choice == "no") then
        shell.run(xroot .. xbin .. "excavateCoreShaft.lua")
        checkForShaftCompletion()
    elseif (choice == "yes") then
        return
    elseif (choice == "exit") then
        return
    else
        checkForShaftCompletion()
    end
end

function runQuadrantShaft()
    shell.run(xroot .. xbin .. "excavateQuadrant.lua")
end

function logCoreShaftExcavation()
    local excavations = io.open(excavationsPath, "a")
    excavations:write(gps.locate())
    excavations:close()
end

main()
