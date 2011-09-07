require('sproutcore')
require('sensor-maps/libs/leaflet')

# Sensor Maps namespace
SM = {}
@SM = SM

SM.CLOUDMADE_API_KEY = 'a33ede6a9595478ba1025f20398c0341'

SM.Map = SC.Object.extend
  init: ->
    @_super()
    map = new L.Map @get('divId')
    cloudmadeUrl = "http://{s}.tile.cloudmade.com/#{SM.CLOUDMADE_API_KEY}/997/256/{z}/{x}/{y}.png"
    cloudmade = new L.TileLayer(cloudmadeUrl, {maxZoom: 18})
    map.addLayer cloudmade
    @set('mapObject', map)
    @set('objects',[])
  addObject: (object) ->
    @get('objects').push object
    @mapObject.addLayer(object.mapObject)
    this
  fitBounds: (bounds) ->
    @get('mapObject').fitBounds(bounds)
  fitAllObjects: ->
    bounds = new L.LatLngBounds()
    for object in @objects
      bounds.extend object.bounds().getSouthWest()
      bounds.extend object.bounds().getNorthEast()
    @fitBounds bounds

SM.Polyline = SC.Object.extend
  init: ->
    @_super()
    @mapObject = new L.Polyline(@_latlngs())
  _latlngs: ->
    points = @getPath('points.content') || @get('points') || [[51.509,-0.08]] # Need this for now becuase leaflet doesn't let you create polylines with an empty array
    latlngs = (new L.LatLng(point[0],point[1]) for point in points)
    latlngs
  bounds: ->
    new L.LatLngBounds(@mapObject._latlngs)
  pointsDidChange: (->
    @mapObject.setLatLngs @_latlngs()
  ).observes('points.length')
