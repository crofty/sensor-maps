require('sensor-maps/marker')

SM.Vehicle = SM.Marker.extend
  _latDidChange: ( ->
    console.log "Marker latitude did change"
    mapObject = @get('mapObject')
    mapObject.setLatLng(new L.LatLng(@getPath('vehicle.lat'),@getPath('vehicle.lon')))
  ).observes('vehicle.lat')
