local vehiclesI = {}
local vehiclesMarkers = {}

local markersPhrase = false

function indBlink() {
	if markersPhrase then
		-- Niszczymy wszystkie markery (faza znikania)		
		for _, vehicleMarkers in pairs(vehiclesMarkers) do
			for _, vehicleMarker in pairs(vehicleMarkers) do
				destroyElement( vehicleMarker )
			end
		end
		
		markersPhrase = false
	else
		-- Tworzymy markery (faza swiecenia)
		
		
		
		markersPhrase = true
	end
}

addEventHandler ( "onResourceStart", getRootElement(), 
	function (resource) {
		if resource == getThisResource() then
			setTimer ( indBlink, 200, 0 )
		end
	}
)