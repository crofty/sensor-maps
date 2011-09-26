require('sensor-maps/marker')

SM.VehicleMovingIcon = L.Icon.extend
  iconUrl: '/images/marker-blue.png'
  shadowUrl: '/images/marker-shadow.png'
  iconSize: new L.Point(16, 22)
  shadowSize: new L.Point(1, 1)
  iconAnchor: new L.Point(8,11)

SM.VehicleStoppedIcon = L.Icon.extend
  iconUrl: '/images/amber-dot.png'
  shadowUrl: '/images/marker-shadow.png'
  iconSize: new L.Point(15, 16)
  shadowSize: new L.Point(15, 16)
  iconAnchor: new L.Point(8,8)

SM.PopupContent = SC.View.extend
  template: SC.Handlebars.compile """
    <h2>{{registration}}</h2>
    <p>Speed: {{speed}}mph</p>
    <a {{bindAttr href="url"}}>Zoom</a>
  """

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
    state = @getPath('vehicle.state')
    @mapObject = new L.Marker(new L.LatLng(@get('lat'),@get('lon')), icon: @get("#{state}Icon"))
    @get('map').addObject(this) # Add the object to the map
    @_createPopup()
  _createPopup: ->
    @popup = new L.Popup()
    @mapObject._popup = @popup
    @mapObject.on('click', @mapObject.openPopup, @mapObject)
    @_setPopupContent()
  _setPopupContent: ->
    view = SM.PopupContent.create
      registration: @getPath('vehicle.registration')
      speed: @getPath('vehicle.speed') || 0
      url: "#/map/#{@getPath('vehicle.imei')}"
    view.createElement()
    @mapObject._popup.setContent(view.get('element'))
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
    @_setPopupContent()
  ).observes('vehicle.lat')
  _iconDidChange: ( ->
    mapObject = @get('mapObject')
    if mapObject
      mapObject.setIcon @get('icon')
      mapObject._reset() # A reset is needed to redraw the layer
  ).observes('icon')
  _rotationDidChange: ( ->
    # TODO: rotation changes are lost when the map is zoomed
    if img = @get('mapObject')._icon
      rotation = @getPath('vehicle.heading') || 0
      value = img.style.getPropertyValue('-webkit-transform')
      img.style.setProperty('-webkit-transform',value + " rotate(#{rotation}deg)")
  ).observes('vehicle.heading')
