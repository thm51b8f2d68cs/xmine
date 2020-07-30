--File read/write api for X Mine - Based on Computer Craft fs API
 
--All methods automatically close the file when finished
 
--Write appends to file
 
function readAllFrom(path)
  fs.open(path, "r")
  data = h.readAll()
  h.close()
  return data
end
 
function readLineFrom(path)
  fs.open(path, "r")
  data = h.readLine()
  h.close()
  return data
end
 
function searchIn(path, data)
  for line in pairs(fs.open(path, "r"))
    if (h.readLine() == data) then
      h.close()
      return true
    else
      h.close()
      return false
    end 
end
 
function writeTo(path, data)
  fs.open(path, "a")
  h.writeLine(data)
  h.close()
end
