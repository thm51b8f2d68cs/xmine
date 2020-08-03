function main()
  xdirdata = io.open("/.dirdata.txt", "r")
  dataFromFile = xdirdata:read("*a")
  dirdata = textutils.unserialize(dataFromFile)
  xdirdata:close()
  return dirdata
end

return main()
