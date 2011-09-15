require('sensor-maps/marker')

# Icons required for the vehicle marker
SM.VehicleMovingIcon = L.Icon.extend
  iconUrl: '/assets/images/marker-blue.png'
  iconSize: new L.Point(16, 22)
  shadowSize: new L.Point(16, 22)
  iconAnchor: new L.Point(8,11)

SM.VehicleStoppedIcon = L.Icon.extend
  iconUrl: '/assets/images/amber-dot.png'
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
    # TODO: Leaflet won't let allow setIcon to be used on a marker object until it has
    # been added to the map, hence I need to set all vehicles to display the stoppedIcon
    # to begin with
    @mapObject = new L.Marker(new L.LatLng(@get('lat'),@get('lon')), icon: @get('stoppedIcon'))
  bounds: ->
    latlng = @get('mapObject')._latlng
    new L.LatLngBounds(latlng,latlng)
  _stateDidChange: ( ->
    state = @getPath('vehicle.state')
    @set('icon', @get("#{state}Icon"))
  ).observes('vehicle.state')
  _latDidChange: ( ->
    console.log "Marker latitude did change"
    mapObject = @get('mapObject')
    mapObject.setLatLng(new L.LatLng(@getPath('vehicle.lat'),@getPath('vehicle.lon')))
  ).observes('vehicle.lat')
  _iconDidChange: ( ->
    mapObject = @get('mapObject')
    if mapObject
      mapObject.setIcon @get('icon')
      mapObject._reset() # A reset is needed to redraw the layer
  ).observes('icon')
  _rotationDidChange: ( ->
    $img = $(@get('mapObject')._icon)
    rotation = @getPath('vehicle.heading')
    webkitTransform = $img.css('-webkit-transform')
    $img.css('-webkit-transform', webkitTransform + " rotate(#{rotation}deg)")
  ).observes('vehicle.heading')
