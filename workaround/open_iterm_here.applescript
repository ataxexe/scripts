on run {}
	tell application "Finder"
		set dir_path to quoted form of (POSIX path of (folder of the front window as alias))
	end tell
	CD_to(dir_path)
end run

on CD_to(theDir)
	tell application "System Events"
		if (exists (processes where name is "iTerm")) then
			tell application "iTerm"
				make new terminal
				tell the current terminal
					activate current session
					launch session "Default Session"
				end tell
			end tell
		end if
	end tell
	tell application "iTerm"
		tell the current terminal
			activate current session
			tell the last session
				write text "cd " & theDir & ";clear;"
			end tell
		end tell
	end tell
end CD_to