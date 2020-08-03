function displayWelcomeScreen()
    term.clear()
    print("                 X Mine")
    print("=======================================")
end

--Choices is a string of choices entered directly from the code of whatever file is using the gui
--format: "[choice 1/Choice2/etc...]"
function promptUser(choices)
    print("\nHow would you like to proceed?")
    io.write(choices)
    return io.read()
end
