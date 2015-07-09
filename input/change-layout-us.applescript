set theInputSource to "U.S."
tell application "System Events" to tell process "SystemUIServer"
  click (menu bar item 1 of menu bar 1 whose description is "text input")
  click menu item theInputSource of menu 1 of result
end tell
