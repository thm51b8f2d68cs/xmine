function main()
  local xdirdata = io.open("/.dirdata.txt", "r")
  local dataFromFile = xdirdata:read("*a")
  local dirdata = textutils.unserialize(dataFromFile)
  xdirdata:close()
  return dirdata
end

return main()
