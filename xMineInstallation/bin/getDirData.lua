function main()
  xdirdata = io.open("/.dirdata.txt", "r")
  dataFromFile = xdirdata:read("*a")
  print(dataFromFile)
  dirdata = textutils.unserialize(dataFromFile)
  print(dirdata)
  print(dirdata.xroot)
  os.sleep(5)
  xdirdata:close()
  return dirdata
end
 
return main()
