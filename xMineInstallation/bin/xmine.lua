choices = "[auto - recommended/manual/exit]"
xDirData = dofile("/.getDirData.lua")
xroot = xDirData.xroot
xbin = xDirData.xbin
xlib = xDirData.xlib
xdata = xDirData.xdata
 
function main()
  --os.loadAPI(xroot .. xlib .. "fs.lua")
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
  path = xroot .. xdata .. ".excavations.txt"
  createVectorsFromFile(path)
  if (nearCoreShaft(gps.locate() ) ) then
    runCoreShaft()
  else
    runQuadrantShaft()
  end
end
 
function runCoreShaft()
  shell.run(xroot .. xbin .. "excavateQuadrant.lua")
end
 
function runQuadrantShaft()
  shell.run(xroot .. xbin .. "excavateCoreShaft.lua")  
end
 
function nearCoreShaft(x, y, z)
  currentLocation = vector.new(x,y,z)
  for index in pairs(vectors) do
    if (currentLocation - index < 500) then
      return true
    end
  end
  return false
end
 
function createVectorsFromFile(path)
  vectors = {}
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
 
main()
