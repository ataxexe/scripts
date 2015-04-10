tell application "System Events"
	-- Get all VPN services configured
	tell current location of network preferences
		get the name of every service whose kind is 11
		
		set vpn_connections to result
		set vpn_default to first item of vpn_connections
	end tell
	-- enable user interaction
	activate
	choose from list vpn_connections with title "Select VPN Connection" default items vpn_default
	
	if the result is not false then
		set connection to first item of result
		tell current location of network preferences
			get connected of current configuration of service connection
			if result is false then
				connect service connection
			end if
		end tell
	end if
end tell
