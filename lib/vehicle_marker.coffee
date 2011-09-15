require('sensor-maps/marker')

# Icons required for the vehicle marker
SM.VehicleMovingIcon = L.Icon.extend
  iconUrl: './assets/images/marker-blue.png'
  iconSize: new L.Point(16, 22)
  shadowSize: new L.Point(16, 22)
  iconAnchor: new L.Point(8,11)

SM.VehicleStoppedIcon = L.Icon.extend
  iconUrl: './assets/images/amber-dot.png'
  iconSize: new L.Point(15, 16)
  shadowSize: new L.Point(15, 16)
  iconAnchor: new L.Point(8,8)

# Initialise this type of marker with a sensor vehicle
# and the current lat and lon, e.g.
#   marker = SM.VehicleMarker.create
#     vehicle: vehicle
#     lat: vehicle.get('lat')
#     lon: vehicle.get('lon')
SM.VehicleMarker = SC.Object.extend
  init: ->
    @set('movingIcon', new SM.VehicleMovingIcon())
    @set('stoppedIcon', new SM.VehicleStoppedIcon())
    @mapObject = new L.Marker(new L.LatLng(@get('lat'),@get('lon')))
  bounds: ->
    latlng = @get('mapObject')._latlng
    new L.LatLngBounds(latlng,latlng)
  stateDidChange: ( ->
    state = @getPath('vehicle.state')
    @set('icon', @get("#{state}Icon"))
  ).observes('vehicle.state')
  _latDidChange: ( ->
    console.log "Marker latitude did change"
    mapObject = @get('mapObject')
    mapObject.setLatLng(new L.LatLng(@getPath('vehicle.lat'),@getPath('vehicle.lon')))
  ).observes('vehicle.lat')
  iconDidChange: ( ->
    mapObject = @get('mapObject')
    if mapObject
      mapObject.setIcon @get('icon')
      console.log mapObject
      # mapObject._reset() # A reset is needed to redraw the layer
  ).observes('icon')
