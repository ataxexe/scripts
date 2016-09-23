set _normal_height to 500
set _max_height to 900

tell application "iTerm"
	set _bounds to bounds of the first window
	set _x to item 1 of _bounds
	set _y to item 2 of _bounds
	set _width to item 3 of _bounds
	set _height to item 4 of _bounds
	
	if _height > _normal_height then
		set _height to _normal_height
	else
		set _height to _max_height
	end if
	
	set the bounds of the first window to {_x, _y, _width, _height}
end tell